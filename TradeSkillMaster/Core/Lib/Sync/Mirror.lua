-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Mirror = TSM.Sync:NewPackage("Mirror")
local L = TSM.L
local private = {
	numConnected = 0,
	accountStatus = {},
}
local BROADCAST_INTERVAL = 3



-- ============================================================================
-- Module Functions
-- ============================================================================

function Mirror.OnInitialize()
	TSM.Sync.Connection.RegisterConnectionChangedCallback(private.ConnectionChangedHandler)
	TSM.Sync.Comm.RegisterHandler(TSM.Sync.DATA_TYPES.CHARACTER_HASHES_BROADCAST, private.CharacterHashesBroadcastHandler)
	TSM.Sync.Comm.RegisterHandler(TSM.Sync.DATA_TYPES.CHARACTER_SETTING_HASHES_REQUEST, private.CharacterSettingHashesRequestHandler)
	TSM.Sync.Comm.RegisterHandler(TSM.Sync.DATA_TYPES.CHARACTER_SETTING_HASHES_RESPONSE, private.CharacterSettingHashesResponseHandler)
	TSM.Sync.Comm.RegisterHandler(TSM.Sync.DATA_TYPES.CHARACTER_SETTING_DATA_REQUEST, private.CharacterSettingDataRequestHandler)
	TSM.Sync.Comm.RegisterHandler(TSM.Sync.DATA_TYPES.CHARACTER_SETTING_DATA_RESPONSE, private.CharacterSettingDataResponseHandler)
end

function Mirror.GetStatus(account)
	local status = private.accountStatus[account]
	if not status then
		return "|cffff0000"..L["Not Connected"].."|r"
	elseif status == "UPDATING" then
		return "|cfffcf141"..L["Updating"].."|r"
	elseif status == "SYNCED" then
		return "|cff00ff00"..L["Up to date"].."|r"
	else
		error("Invalid status: "..tostring(status))
	end
end



-- ============================================================================
-- Connection Callback Handlers
-- ============================================================================

function private.ConnectionChangedHandler(account, player, connected)
	if connected == nil then
		-- new account, but not yet connected
		return
	end
	if connected then
		TSM:LOG_INFO("Connected to %s (%s)", account, player)
	else
		TSM:LOG_INFO("Disconnected from %s (%s)", account, player)
	end
	private.numConnected = private.numConnected + (connected and 1 or -1)
	assert(private.numConnected >= 0)
	if connected then
		private.accountStatus[account] = "UPDATING"
		TSMAPI_FOUR.Delay.AfterTime("mirrorCharacterHashes", 0, private.SendCharacterHashes, BROADCAST_INTERVAL)
	else
		private.accountStatus[account] = nil
		if private.numConnected == 0 then
			TSMAPI_FOUR.Delay.Cancel("mirrorCharacterHashes")
		end
	end
end



-- ============================================================================
-- Delay-Based Last Update Send Function
-- ============================================================================

function private.SendCharacterHashes()
	assert(private.numConnected > 0)

	-- calculate the hashes of the sync settings for all characters on this account
	local hashes = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, character in TSM.db:FactionrealmCharacterByAccountIterator() do
		hashes[character] = private.CalculateCharacterHash(character)
	end

	-- send the hashes to all connected accounts
	for _, character in TSM.Sync.Connection.ConnectedAccountIterator() do
		TSM.Sync.Comm.SendData(TSM.Sync.DATA_TYPES.CHARACTER_HASHES_BROADCAST, character, hashes)
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(hashes)
end



-- ============================================================================
-- Message Handlers
-- ============================================================================

function private.CharacterHashesBroadcastHandler(dataType, sourceAccount, sourcePlayer, data)
	assert(dataType == TSM.Sync.DATA_TYPES.CHARACTER_HASHES_BROADCAST)
	if not TSM.Sync.Connection.IsPlayerConnected(sourcePlayer) then
		-- we're not connected to this player
		TSM:LOG_WARN("Got CHARACTER_HASHES_BROADCAST for player which isn't connected")
		return
	end
	local didChange = false
	for _, character in TSM.db:FactionrealmCharacterByAccountIterator(sourceAccount) do
		if not data[character] then
			-- this character doesn't exist anymore, so remove it
			TSM:LOG_INFO("Removed character: '%s'", character)
			TSM.db:RemoveSyncCharacter(character)
			didChange = true
		end
	end
	for character, hash in pairs(data) do
		if not TSM.db:GetSyncOwnerAccountKey(character) then
			-- this is a new character, so add it to our DB
			TSM:LOG_INFO("New character: '%s' '%s'", character, sourceAccount)
			TSM.db:NewSyncCharacter(character, sourceAccount)
			didChange = true
		end
		if hash ~= private.CalculateCharacterHash(character) then
			-- this character's data has changed so request a hash of each of the keys
			TSM:LOG_INFO("Character data has changed: '%s'", character)
			TSM.Sync.Comm.SendData(TSM.Sync.DATA_TYPES.CHARACTER_SETTING_HASHES_REQUEST, sourcePlayer, character)
			didChange = true
		end
	end
	if didChange then
		private.accountStatus[sourceAccount] = "UPDATING"
	else
		private.accountStatus[sourceAccount] = "SYNCED"
	end
end

function private.CharacterSettingHashesRequestHandler(dataType, sourceAccount, sourcePlayer, data)
	assert(dataType == TSM.Sync.DATA_TYPES.CHARACTER_SETTING_HASHES_REQUEST)
	if not TSM.Sync.Connection.IsPlayerConnected(sourcePlayer) then
		-- we're not connected to this player
		TSM:LOG_WARN("Got CHARACTER_HASHES_BROADCAST for player which isn't connected")
		return
	elseif TSM.db:GetSyncOwnerAccountKey(data) ~= TSM.db:GetSyncAccountKey() then
		-- we don't own this character
		TSM:LOG_ERR("Request for character we don't own ('%s', '%s')", tostring(data), tostring(TSM.db:GetSyncOwnerAccountKey(data)))
		return
	end
	TSM:LOG_INFO("CHARACTER_SETTING_HASHES_REQUEST (%s)", data)
	local responseData = TSMAPI_FOUR.Util.AcquireTempTable()
	responseData._character = data
	for _, namespace, settingKey in TSM.db:SyncSettingSortedIterator() do
		responseData[namespace.."."..settingKey] = private.CalculateCharacterSettingHash(data, namespace, settingKey)
	end
	TSM.Sync.Comm.SendData(TSM.Sync.DATA_TYPES.CHARACTER_SETTING_HASHES_RESPONSE, sourcePlayer, responseData)
	TSMAPI_FOUR.Util.ReleaseTempTable(responseData)
end

function private.CharacterSettingHashesResponseHandler(dataType, sourceAccount, sourcePlayer, data)
	assert(dataType == TSM.Sync.DATA_TYPES.CHARACTER_SETTING_HASHES_RESPONSE)
	if not TSM.Sync.Connection.IsPlayerConnected(sourcePlayer) then
		-- we're not connected to this player
		TSM:LOG_WARN("Got CHARACTER_HASHES_BROADCAST for player which isn't connected")
		return
	end
	local character = data._character
	data._character = nil
	TSM:LOG_INFO("CHARACTER_SETTING_HASHES_RESPONSE (%s)", character)
	for key, hash in pairs(data) do
		local namespace, settingKey = strsplit(".", key)
		if private.CalculateCharacterSettingHash(character, namespace, settingKey) ~= hash then
			-- the settings data for key changed, so request the latest data for it
			TSM:LOG_INFO("Setting data has changed: '%s', '%s'", character, key)
			TSM.Sync.Comm.SendData(TSM.Sync.DATA_TYPES.CHARACTER_SETTING_DATA_REQUEST, sourcePlayer, character.."."..key)
		end
	end
end

function private.CharacterSettingDataRequestHandler(dataType, sourceAccount, sourcePlayer, data)
	assert(dataType == TSM.Sync.DATA_TYPES.CHARACTER_SETTING_DATA_REQUEST)
	local character, namespace, settingKey = strsplit(".", data)
	if not TSM.Sync.Connection.IsPlayerConnected(sourcePlayer) then
		-- we're not connected to this player
		TSM:LOG_WARN("Got CHARACTER_HASHES_BROADCAST for player which isn't connected")
		return
	elseif TSM.db:GetSyncOwnerAccountKey(character) ~= TSM.db:GetSyncAccountKey() then
		-- we don't own this character
		TSM:LOG_ERR("Request for character we don't own ('%s', '%s')", tostring(character), tostring(TSM.db:GetSyncOwnerAccountKey(character)))
		return
	end
	TSM:LOG_INFO("CHARACTER_SETTING_DATA_REQUEST (%s,%s,%s)", character, namespace, settingKey)
	local responseData = TSMAPI_FOUR.Util.AcquireTempTable()
	responseData.character = character
	responseData.namespace = namespace
	responseData.settingKey = settingKey
	responseData.data = TSM.db:Get("sync", TSM.db:GetSyncScopeKeyByCharacter(character), namespace, settingKey)
	TSM.Sync.Comm.SendData(TSM.Sync.DATA_TYPES.CHARACTER_SETTING_DATA_RESPONSE, sourcePlayer, responseData)
	TSMAPI_FOUR.Util.ReleaseTempTable(responseData)
end

function private.CharacterSettingDataResponseHandler(dataType, sourceAccount, sourcePlayer, data)
	assert(dataType == TSM.Sync.DATA_TYPES.CHARACTER_SETTING_DATA_RESPONSE)
	if not TSM.Sync.Connection.IsPlayerConnected(sourcePlayer) then
		-- we're not connected to this player
		TSM:LOG_WARN("Got CHARACTER_HASHES_BROADCAST for player which isn't connected")
		return
	end
	TSM:LOG_INFO("CHARACTER_SETTING_DATA_RESPONSE (%s,%s,%s)", data.character, data.namespace, data.settingKey)
	if type(data.data) == "table" then
		local tbl = TSM.db:Get("sync", TSM.db:GetSyncScopeKeyByCharacter(data.character), data.namespace, data.settingKey)
		wipe(tbl)
		for i, v in pairs(data.data) do
			tbl[i] = v
		end
	else
		TSM.db:Set("sync", TSM.db:GetSyncScopeKeyByCharacter(data.character), data.namespace, data.settingKey, data.data)
	end
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.CalculateCharacterHash(character)
	local hash = nil
	for _, namespace, settingKey in TSM.db:SyncSettingSortedIterator() do
		local settingValue = TSM.db:Get("sync", TSM.db:GetSyncScopeKeyByCharacter(character), namespace, settingKey)
		hash = TSMAPI_FOUR.Util.CalculateHash(namespace.."."..settingKey, hash)
		hash = TSMAPI_FOUR.Util.CalculateHash(settingValue, hash)
	end
	assert(hash)
	return hash
end

function private.CalculateCharacterSettingHash(character, namespace, settingKey)
	return TSMAPI_FOUR.Util.CalculateHash(TSM.db:Get("sync", TSM.db:GetSyncScopeKeyByCharacter(character), namespace, settingKey))
end
