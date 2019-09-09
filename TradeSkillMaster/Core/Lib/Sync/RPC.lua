-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local RPC = TSM.Sync:NewPackage("RPC")
local private = {
	rpcFunctions = {},
	pendingRPC = {},
	rpcSeqNum = 0,
}
local RPC_EXTRA_TIMEOUT = 15



-- ============================================================================
-- Module Functions
-- ============================================================================

function RPC.OnInitialize()
	TSM.Sync.Comm.RegisterHandler(TSM.Sync.DATA_TYPES.RPC_CALL, private.HandleCall)
	TSM.Sync.Comm.RegisterHandler(TSM.Sync.DATA_TYPES.RPC_RETURN, private.HandleReturn)
	TSM.Sync.Comm.RegisterHandler(TSM.Sync.DATA_TYPES.RPC_PREAMBLE, private.HandlePreamble)
	TSMAPI_FOUR.Delay.AfterTime(1, private.CheckPending, 1)
end

function RPC.Register(name, func)
	assert(name)
	private.rpcFunctions[name] = func
end

function RPC.Call(name, targetPlayer, handler, ...)
	assert(targetPlayer)
	if not TSM.Sync.Connection.IsPlayerConnected(targetPlayer) then
		return false
	end

	assert(private.rpcFunctions[name], "Cannot call an RPC which is not also registered locally.")
	private.rpcSeqNum = private.rpcSeqNum + 1

	local requestData = TSMAPI_FOUR.Util.AcquireTempTable()
	requestData.name = name
	requestData.args = TSMAPI_FOUR.Util.AcquireTempTable(...)
	requestData.seq = private.rpcSeqNum
	local numBytes = TSM.Sync.Comm.SendData(TSM.Sync.DATA_TYPES.RPC_CALL, targetPlayer, requestData)
	TSMAPI_FOUR.Util.ReleaseTempTable(requestData.args)
	TSMAPI_FOUR.Util.ReleaseTempTable(requestData)

	local context = TSMAPI_FOUR.Util.AcquireTempTable()
	context.name = name
	context.handler = handler
	context.timeoutTime = time() + RPC_EXTRA_TIMEOUT + private.EstimateTransferTime(numBytes)
	private.pendingRPC[private.rpcSeqNum] = context

	return true, (context.timeoutTime - time()) * 2 / 3
end

function RPC.Cancel(name, handler)
	for seq, info in pairs(private.pendingRPC) do
		if info.name == name and info.handler == handler then
			TSMAPI_FOUR.Util.ReleaseTempTable(info)
			private.pendingRPC[seq] = nil
			return
		end
	end
end



-- ============================================================================
-- Message Handlers
-- ============================================================================

function private.HandleCall(dataType, _, sourcePlayer, data)
	assert(dataType == TSM.Sync.DATA_TYPES.RPC_CALL)
	if type(data) ~= "table" or type(data.name) ~= "string" or type(data.seq) ~= "number" or type(data.args) ~= "table" then
		return
	end
	if not private.rpcFunctions[data.name] then
		return
	end
	local responseData = TSMAPI_FOUR.Util.AcquireTempTable()
	responseData.result = TSMAPI_FOUR.Util.AcquireTempTable(private.rpcFunctions[data.name](unpack(data.args)))
	responseData.seq = data.seq
	local numBytes = TSM.Sync.Comm.SendData(TSM.Sync.DATA_TYPES.RPC_RETURN, sourcePlayer, responseData)
	TSMAPI_FOUR.Util.ReleaseTempTable(responseData.result)
	TSMAPI_FOUR.Util.ReleaseTempTable(responseData)

	local transferTime = private.EstimateTransferTime(numBytes)
	if transferTime > 1 then
		-- We sent more than 1 second worth of data back, so send a preamble to allow the source to adjust its timeout accordingly.
		local preambleData = TSMAPI_FOUR.Util.AcquireTempTable()
		preambleData.transferTime = transferTime
		preambleData.seq = data.seq
		TSM.Sync.Comm.SendData(TSM.Sync.DATA_TYPES.RPC_PREAMBLE, sourcePlayer, preambleData)
		TSMAPI_FOUR.Util.ReleaseTempTable(preambleData)
	end
end

function private.HandleReturn(dataType, _, _, data)
	assert(dataType == TSM.Sync.DATA_TYPES.RPC_RETURN)
	if type(data.seq) ~= "number" or type(data.result) ~= "table" then
		return
	elseif not private.pendingRPC[data.seq] then
		return
	end
	private.pendingRPC[data.seq].handler(unpack(data.result))
	TSMAPI_FOUR.Util.ReleaseTempTable(private.pendingRPC[data.seq])
	private.pendingRPC[data.seq] = nil
end

function private.HandlePreamble(dataType, _, _, data)
	assert(dataType == TSM.Sync.DATA_TYPES.RPC_PREAMBLE)
	if type(data.seq) ~= "number" or type(data.transferTime) ~= "number" then
		return
	elseif not private.pendingRPC[data.seq] then
		return
	end
	-- extend the timeout
	private.pendingRPC[data.seq].timeoutTime = time() + RPC_EXTRA_TIMEOUT + data.transferTime
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.EstimateTransferTime(numBytes)
	return ceil(numBytes / (ChatThrottleLib.MAX_CPS / 2))
end

function private.CheckPending()
	if not next(private.pendingRPC) then
		return
	end
	local timedOut = TSMAPI_FOUR.Util.AcquireTempTable()
	for seq, info in pairs(private.pendingRPC) do
		if time() > info.timeoutTime then
			tinsert(timedOut, seq)
		end
	end
	for _, seq in ipairs(timedOut) do
		local info = private.pendingRPC[seq]
		TSM:LOG_WARN("RPC timed out (%s)", info.name)
		info.handler()
		TSMAPI_FOUR.Util.ReleaseTempTable(info)
		private.pendingRPC[seq] = nil
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(timedOut)
end
