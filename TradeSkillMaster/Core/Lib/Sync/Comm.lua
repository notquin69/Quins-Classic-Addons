-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Comm = TSM.Sync:NewPackage("Comm", "AceComm-3.0")
local private = {
	handler = {},
	queuedPacket = {},
	queuedSourcePlayer = {},
}
-- Load the libraries needed for Compress and Decompress functions
local LibAceSerializer = LibStub:GetLibrary("AceSerializer-3.0")
local LibCompress = LibStub:GetLibrary("LibCompress")
local LibCompressAddonEncodeTable = LibCompress:GetAddonEncodeTable()



-- ============================================================================
-- Module Functions
-- ============================================================================

function Comm.OnEnable()
	Comm:RegisterComm("TSMSyncData", private.OnCommReceived)
end

function Comm.RegisterHandler(dataType, handler)
	assert(not private.handler[dataType])
	local isValid = false
	for _, v in pairs(TSM.Sync.DATA_TYPES) do
		if v == dataType then
			isValid = true
			break
		end
	end
	assert(isValid)
	private.handler[dataType] = handler
end

function Comm.SendData(dataType, targetPlayer, data)
	assert(type(dataType) == "string" and #dataType == 1)
	local serialized = nil
	if data then
		local packet = TSMAPI_FOUR.Util.AcquireTempTable()
		packet.dt = dataType
		packet.sa = TSM.db:GetSyncAccountKey()
		packet.v = TSM.Sync.SYNC_VERSION
		packet.d = data
		serialized = LibAceSerializer:Serialize(packet)
		TSMAPI_FOUR.Util.ReleaseTempTable(packet)
	else
		-- send a more compact version if there's no data
		serialized = "\240"..strjoin(";", dataType, TSM.db:GetSyncAccountKey(), UnitName("player"), TSM.Sync.SYNC_VERSION)
	end

	-- We will compress using Huffman, LZW, and no compression separately, validate each one, and pick the shortest valid one.
	-- This is to deal with a bug in the compression code.
	local encodedData = TSMAPI_FOUR.Util.AcquireTempTable()
	local huffmanCompressed = LibCompress:CompressHuffman(serialized)
	if huffmanCompressed then
		huffmanCompressed = LibCompressAddonEncodeTable:Encode(huffmanCompressed)
		tinsert(encodedData, huffmanCompressed)
	end
	local lzwCompressed = LibCompress:CompressLZW(serialized)
	if lzwCompressed then
		lzwCompressed = LibCompressAddonEncodeTable:Encode(lzwCompressed)
		tinsert(encodedData, lzwCompressed)
	end
	local uncompressed = LibCompressAddonEncodeTable:Encode("\001"..serialized)
	tinsert(encodedData, uncompressed)
	-- verify each compresion and pick the shortest valid one
	local minIndex = -1
	local minLen = math.huge
	for i = #encodedData, 1, -1 do
		local test = LibCompress:Decompress(LibCompressAddonEncodeTable:Decode(encodedData[i]))
		if test and test == serialized and #encodedData[i] < minLen then
			minLen = #encodedData[i]
			minIndex = i
		end
	end
	local minData = encodedData[minIndex]
	TSMAPI_FOUR.Util.ReleaseTempTable(encodedData)
	assert(minData, "Could not compress packet")

	-- give heartbeats and rpc preambles a higher priority
	local priority = (dataType == TSM.Sync.DATA_TYPES.HEARTBEAT or dataType == TSM.Sync.DATA_TYPES.RPC_PREAMBLE) and "ALERT" or nil
	-- send the message
	Comm:SendCommMessage("TSMSyncData", minData, "WHISPER", targetPlayer, priority)
	return #minData
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.OnCommReceived(_, packet, _, sourcePlayer)
	-- delay the processing to make sure it happens within a debuggable context (this function is called via pcall)
	tinsert(private.queuedPacket, packet)
	tinsert(private.queuedSourcePlayer, sourcePlayer)
	TSMAPI_FOUR.Delay.AfterFrame("commReceiveQueue", 0, private.ProcessReceiveQueue)
end

function private.ProcessReceiveQueue()
	assert(#private.queuedPacket == #private.queuedSourcePlayer)
	while #private.queuedPacket > 0 do
		local packet = tremove(private.queuedPacket, 1)
		local sourcePlayer = tremove(private.queuedSourcePlayer, 1)
		private.ProcessReceivedPacket(packet, sourcePlayer)
	end
end

function private.ProcessReceivedPacket(packet, sourcePlayer)
	-- remove realm name from source player
	sourcePlayer = ("-"):split(sourcePlayer)
	sourcePlayer = strtrim(sourcePlayer)
	local sourcePlayerAccountKey = TSM.db:GetSyncOwnerAccountKey(sourcePlayer)
	if sourcePlayerAccountKey and sourcePlayerAccountKey == TSM.db:GetSyncAccountKey() then
		TSM:LOG_ERR("We own the source character")
		TSM.Sync.ShowSVCopyError()
		return
	end

	-- decode and decompress
	packet = LibCompressAddonEncodeTable:Decode(packet)
	packet = packet and LibCompress:Decompress(packet)
	if type(packet) ~= "string" then
		TSM:LOG_ERR("Invalid packet")
		return
	end
	if strsub(packet, 1, 1) == "\240" then
		-- original data was a string, so we're done
		packet = strsub(packet, 2)
	else
		-- Deserialize
		local success
		success, packet = LibAceSerializer:Deserialize(packet)
		if not success or not packet then
			TSM:LOG_ERR("Invalid packet")
			return
		end
	end

	-- validate the packet
	local dataType, sourceAccount, version, data = nil, nil, nil, nil
	if type(packet) == "string" then
		-- if it's a string that means there was no data
		local _
		dataType, sourceAccount, _, version = (";"):split(packet)
		version = tonumber(version)
	else
		dataType = packet.dt
		sourceAccount = packet.sa
		version = packet.v
		data = packet.d
	end
	if type(dataType) ~= "string" or #dataType > 1 or not sourceAccount or version ~= TSM.Sync.SYNC_VERSION then
		TSM:LOG_INFO("Invalid message received")
		return
	elseif sourceAccount == TSM.db:GetSyncAccountKey() then
		TSM:LOG_ERR("We are the source account (SV copy)")
		TSM.Sync.ShowSVCopyError()
		return
	elseif sourcePlayerAccountKey and sourcePlayerAccountKey ~= sourceAccount then
		-- the source player now belongs to a different account than what we expect
		TSM:LOG_ERR("Unexpected source account")
		TSM.Sync.ShowSVCopyError()
		return
	end

	if private.handler[dataType] then
		private.handler[dataType](dataType, sourceAccount, sourcePlayer, data)
	else
		TSM:LOG_INFO("Received unhandled message of type: "..strbyte(dataType))
	end
end
