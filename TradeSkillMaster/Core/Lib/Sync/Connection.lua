-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Connection = TSM.Sync:NewPackage("Connection")
local private = {
	newPlayer = nil,
	newAccount = nil,
	newSyncAcked = nil,
	connectionChangedCallbacks = {},
	threadId = {},
	threadRunning = {},
	connectedPlayer = {},
	lastHeartbeat = {},
	suppressThreadTime = {},
	connectionRequestReceived = {},
}
local L = TSM.L
local RECEIVE_TIMEOUT = 5
local HEARTBEAT_TIMEOUT = 10



-- ============================================================================
-- Module Functions
-- ============================================================================

function Connection.OnInitialize()
	TSM.Sync.Comm.RegisterHandler(TSM.Sync.DATA_TYPES.WHOAMI_ACCOUNT, private.WhoAmIAccountHandler)
	TSM.Sync.Comm.RegisterHandler(TSM.Sync.DATA_TYPES.WHOAMI_ACK, private.WhoAmIAckHandler)
	TSM.Sync.Comm.RegisterHandler(TSM.Sync.DATA_TYPES.CONNECTION_REQUEST, private.ConnectionHandler)
	TSM.Sync.Comm.RegisterHandler(TSM.Sync.DATA_TYPES.CONNECTION_REQUEST_ACK, private.ConnectionHandler)
	TSM.Sync.Comm.RegisterHandler(TSM.Sync.DATA_TYPES.DISCONNECT, private.DisconnectHandler)
	TSM.Sync.Comm.RegisterHandler(TSM.Sync.DATA_TYPES.HEARTBEAT, private.HeartbeatHandler)

	private.PrepareFriendsInfo()
end

function Connection.OnDisable()
	for _, player in pairs(private.connectedPlayer) do
		TSM.Sync.Comm.SendData(TSM.Sync.DATA_TYPES.DISCONNECT, player)
	end
end

function Connection.RegisterConnectionChangedCallback(handler)
	tinsert(private.connectionChangedCallbacks, handler)
end

function Connection.IsPlayerConnected(targetPlayer)
	for _, player in pairs(private.connectedPlayer) do
		if player == targetPlayer then
			return true
		end
	end
	return false
end

function Connection.ConnectedAccountIterator()
	return private.ConnectedPlayerIterator
end

function Connection.Establish(targetPlayer)
	if strlower(targetPlayer) == strlower(UnitName("player")) then
		TSM:Print(L["Sync Setup Error: You entered the name of the current character and not the character on the other account."])
		return false
	elseif not TSM.Sync.PlayerUtil.IsOnline(targetPlayer) then
		TSM:Print(L["Sync Setup Error: The specified player on the other account is not currently online."])
		return false
	end
	local invalidPlayer = false
	for _, player in TSM.db:FactionrealmCharacterIterator() do
		if strlower(player) == strlower(targetPlayer) then
			invalidPlayer = true
		end
	end
	if invalidPlayer then
		TSM:Print(L["Sync Setup Error: This character is already part of a known account."])
		return false
	end
	private.newPlayer = targetPlayer
	private.newAccount = nil
	private.newSyncAcked = nil
	TSMAPI_FOUR.Delay.Cancel("syncNewAccount")
	TSMAPI_FOUR.Delay.AfterTime("syncNewAccount", 0, private.SendNewAccountWhoAmI, 1)
	return true
end

function Connection.GetNewAccountStatus()
	if not private.newPlayer then
		return nil
	end
	return format(L["Connecting to %s"], private.newPlayer)
end

function Connection.GetStatus(account)
	if private.connectedPlayer[account] then
		return "|cff00ff00"..format(L["Connected to %s"], private.connectedPlayer[account]).."|r"
	else
		return "|cffff0000"..L["Offline"].."|r"
	end
end

function Connection.Remove(account)
	if private.threadRunning[account] then
		TSMAPI_FOUR.Thread.Kill(private.threadId[account])
		private.ConnectionThreadDone(account)
	end
	TSM.db:RemoveSyncAccount(account)
end

function Connection.GetConnectedPlayerByAccount(account)
	return private.connectedPlayer[account]
end



-- ============================================================================
-- Message Handlers
-- ============================================================================

function private.WhoAmIAckHandler(dataType, sourceAccount, sourcePlayer, data)
	assert(dataType == TSM.Sync.DATA_TYPES.WHOAMI_ACK)
	if not private.newPlayer or strlower(private.newPlayer) ~= strlower(sourcePlayer) then
		-- we aren't trying to connect with a new account
		return
	end
	TSM:LOG_INFO("WHOAMI_ACK '%s'", tostring(private.newPlayer))
	private.newSyncAcked = true
	private.CheckNewAccountStatus()
end

function private.WhoAmIAccountHandler(dataType, sourceAccount, sourcePlayer, data)
	assert(dataType == TSM.Sync.DATA_TYPES.WHOAMI_ACCOUNT)
	if not private.newPlayer then
		-- we aren't trying to connect with a new account
		return
	elseif strlower(private.newPlayer) ~= strlower(sourcePlayer) then
		TSM:LOG_INFO("WHOAMI_ACCOUNT from unknown player \"%s\", expected \"%s\"", private.newPlayer, sourcePlayer)
		return
	end
	private.newPlayer = sourcePlayer -- get correct capatilization
	private.newAccount = sourceAccount
	TSM:LOG_INFO("WHOAMI_ACCOUNT '%s' '%s'", private.newPlayer, private.newAccount)
	TSM.Sync.Comm.SendData(TSM.Sync.DATA_TYPES.WHOAMI_ACK, private.newPlayer)
	private.CheckNewAccountStatus()
end

function private.ConnectionHandler(dataType, sourceAccount, sourcePlayer, data)
	if not private.threadRunning[sourceAccount] then
		return
	end
	private.connectionRequestReceived[sourceAccount] = true
end

function private.DisconnectHandler(dataType, sourceAccount, sourcePlayer, data)
	assert(dataType == TSM.Sync.DATA_TYPES.DISCONNECT)
	if not private.threadRunning[sourceAccount] then
		return
	end

	-- kill the thread and prevent it from running again for 2 seconds
	TSMAPI_FOUR.Thread.Kill(private.threadId[sourceAccount])
	private.ConnectionThreadDone(sourceAccount)
	private.suppressThreadTime[sourceAccount] = time() + 2
end

function private.HeartbeatHandler(dataType, sourceAccount, sourcePlayer)
	assert(dataType == TSM.Sync.DATA_TYPES.HEARTBEAT)
	if not TSM.Sync.Connection.IsPlayerConnected(sourcePlayer) then
		-- we're not connected to this player
		return
	end
	private.lastHeartbeat[sourceAccount] = time()
end



-- ============================================================================
-- Management Loop / Sync Thread
-- ============================================================================

function private.PrepareFriendsInfo()
	-- wait for friend info to populate
	C_FriendList.ShowFriends()
	local isValid
	local num = C_FriendList.GetNumFriends()
	if not num then
		isValid = false
	else
		isValid = true
	end
	for i = 1, num or 0 do
		if not C_FriendList.GetFriendInfoByIndex(i) then
			isValid = false
			break
		end
	end
	if isValid then
		-- start the management loop
		TSMAPI_FOUR.Delay.AfterTime(1, private.ManagementLoop, 1)
	else
		-- try again
		TSMAPI_FOUR.Delay.AfterTime(0.5, private.PrepareFriendsInfo)
	end
end

function private.ManagementLoop()
	-- continuously spawn connection threads with online players as necessary
	for _, account in TSM.db:SyncAccountIterator() do
		local targetPlayer = TSM.Sync.PlayerUtil.GetTargetPlayer(account)
		if targetPlayer then
			if not private.threadId[account] then
				private.threadId[account] = TSMAPI_FOUR.Thread.New("SYNC_"..strmatch(account, "(%d+)$"), private.ConnectionThread)
			end
			if not private.threadRunning[account] and (private.suppressThreadTime[account] or 0) < time() then
				private.threadRunning[account] = true
				TSMAPI_FOUR.Thread.Start(private.threadId[account], account, targetPlayer)
			end
		end
	end
end


function private.ConnectionThreadInner(account, targetPlayer)
	-- for the initial handshake, the lower account key is the server, other is the client - after this it doesn't matter
	-- add some randomness to the timeout so we don't get stuck in a race condition
	local timeout = GetTime() + RECEIVE_TIMEOUT + random(0, 1000) / 1000
	if account < TSM.db:GetSyncAccountKey() then
		-- wait for the connection request from the client
		while not private.connectionRequestReceived[account] do
			if GetTime() > timeout then
				-- timed out on the connection - don't try again for a bit
				TSM:LOG_WARN("Timed out")
				return
			end
			TSMAPI_FOUR.Thread.Yield(true)
		end
		-- send an connection request ACK back to the client
		TSM.Sync.Comm.SendData(TSM.Sync.DATA_TYPES.CONNECTION_REQUEST_ACK, targetPlayer)
	else
		-- send a connection request to the server
		TSM.Sync.Comm.SendData(TSM.Sync.DATA_TYPES.CONNECTION_REQUEST, targetPlayer)
		-- wait for the connection request ACK
		while not private.connectionRequestReceived[account] do
			if GetTime() > timeout then
				-- timed out on the connection - don't try again for a bit
				TSM:LOG_WARN("Timed out")
				private.suppressThreadTime[account] = time() + RECEIVE_TIMEOUT * 3
				return
			end
			TSMAPI_FOUR.Thread.Yield(true)
		end
	end

	-- we are now connected
	TSM:LOG_INFO("Connected to: %s %s", account, targetPlayer)
	private.connectedPlayer[account] = targetPlayer
	private.lastHeartbeat[account] = time()
	for _, callback in ipairs(private.connectionChangedCallbacks) do
		callback(account, targetPlayer, true)
	end

	-- now that we are connected, data can flow in both directions freely
	local lastHeartbeatSend = time()
	while true do
		-- check if they either logged off or the heartbeats have timed-out
		if not TSM.Sync.PlayerUtil.IsOnline(targetPlayer, true) or time() - private.lastHeartbeat[account] > HEARTBEAT_TIMEOUT then
			return
		end

		-- check if we should send a heartbeat
		if time() - lastHeartbeatSend > floor(HEARTBEAT_TIMEOUT / 2) then
			TSM.Sync.Comm.SendData(TSM.Sync.DATA_TYPES.HEARTBEAT, targetPlayer)
			lastHeartbeatSend = time()
		end

		TSMAPI_FOUR.Thread.Yield(true)
	end
end

function private.ConnectionThread(account, targetPlayer)
	private.ConnectionThreadInner(account, targetPlayer)
	private.ConnectionThreadDone(account)
end

function private.ConnectionThreadDone(account)
	TSM:LOG_INFO("Connection ended to %s", account)
	local player = private.connectedPlayer[account]
	private.connectedPlayer[account] = nil
	if player then
		for _, callback in ipairs(private.connectionChangedCallbacks) do
			callback(account, player, false)
		end
	end
	private.threadRunning[account] = nil
	private.connectionRequestReceived[account] = nil
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.SendNewAccountWhoAmI()
	if not private.newPlayer then
		TSMAPI_FOUR.Delay.Cancel("syncNewAccount")
	elseif not TSM.Sync.PlayerUtil.IsOnline(private.newPlayer) then
		TSMAPI_FOUR.Delay.Cancel("syncNewAccount")
		private.newPlayer = nil
		private.newAccount = nil
		private.newSyncAcked = nil
		TSM:LOG_ERR("New player went offline")
	else
		TSM.Sync.Comm.SendData(TSM.Sync.DATA_TYPES.WHOAMI_ACCOUNT, private.newPlayer)
		TSM:LOG_INFO("Sent WHOAMI_ACCOUNT")
	end
end

function private.CheckNewAccountStatus()
	if not private.newPlayer or not private.newAccount or not private.newSyncAcked then
		return
	end
	TSM:LOG_INFO("New sync character: '%s' '%s'", private.newPlayer, private.newAccount)
	-- the other account ACK'd so setup a connection
	TSM.db:NewSyncCharacter(private.newPlayer, private.newAccount)

	-- call the callbacks for this new account
	for _, callback in ipairs(private.connectionChangedCallbacks) do
		callback(private.newAccount, private.newPlayer, nil)
	end

	private.newPlayer = nil
	private.newAccount = nil
	private.newSyncAcked = nil
end

function private.ConnectedPlayerIterator(_, index)
	index = next(private.connectedPlayer, index)
	if not index then
		return
	end
	return index, private.connectedPlayer[index]
end
