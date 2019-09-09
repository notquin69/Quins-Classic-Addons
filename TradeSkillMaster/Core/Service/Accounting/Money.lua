-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Money = TSM.Accounting:NewPackage("Money")
local private = { db = nil }
local CSV_KEYS = { "type", "amount", "otherPlayer", "player", "time" }
local COMBINE_TIME_THRESHOLD = 300 -- group expenses within 5 minutes together
local SECONDS_PER_DAY = 24 * 60 * 60



-- ============================================================================
-- Module Functions
-- ============================================================================

function Money.OnInitialize()
	private.db = TSMAPI_FOUR.Database.NewSchema("ACCOUNTING_MONEY")
		:AddStringField("recordType")
		:AddStringField("type")
		:AddNumberField("amount")
		:AddStringField("otherPlayer")
		:AddStringField("player")
		:AddNumberField("time")
		:AddIndex("recordType")
		:Commit()
	private.db:BulkInsertStart()
	private.LoadData("expense", TSM.db.realm.internalData.csvExpense)
	private.LoadData("income", TSM.db.realm.internalData.csvIncome)
	private.db:BulkInsertEnd()
end

function Money.OnDisable()
	TSM.db.realm.internalData.csvExpense = private.SaveData("expense")
	TSM.db.realm.internalData.csvIncome = private.SaveData("income")
end

function Money.InsertMoneyTransferExpense(amount, destination)
	private.InsertRecord("expense", "Money Transfer", amount, destination, time())
end

function Money.InsertPostageExpense(amount, destination)
	private.InsertRecord("expense", "Postage", amount, destination, time())
end

function Money.InsertRepairBillExpense(amount)
	private.InsertRecord("expense", "Repair Bill", amount, "Merchant", time())
end

function Money.InsertMoneyTransferIncome(amount, source, timestamp)
	private.InsertRecord("income", "Money Transfer", amount, source, timestamp)
end

function Money.InsertGarrisonIncome(amount)
	private.InsertRecord("income", "Garrison", amount, "Mission", time())
end

function Money.CreateQuery()
	return private.db:NewQuery()
end

function Money.CharacterIterator(recordType)
	return private.db:NewQuery()
		:Equal("recordType", recordType)
		:Distinct("player")
		:Select("player")
		:IteratorAndRelease()
end

function Money.RemoveOldData(days)
	local query = private.db:NewQuery()
		:LessThan("time", time() - days * SECONDS_PER_DAY)
	local numRecords = 0
	private.db:SetQueryUpdatesPaused(true)
	for _, row in query:Iterator() do
		private.db:DeleteRow(row)
		numRecords = numRecords + 1
	end
	query:Release()
	private.db:SetQueryUpdatesPaused(false)
	return numRecords
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.LoadData(recordType, csvRecords)
	local decodeContext = TSMAPI_FOUR.CSV.DecodeStart(csvRecords, CSV_KEYS)
	if not decodeContext then
		TSM:LOG_ERR("Failed to decode %s records", recordType)
		return
	end

	for type, amount, otherPlayer, player, timestamp in TSMAPI_FOUR.CSV.DecodeIterator(decodeContext) do
		amount = tonumber(amount)
		timestamp = tonumber(timestamp)
		if amount and timestamp then
			local newTimestamp = floor(timestamp)
			if newTimestamp ~= timestamp then
				-- make sure all timestamps are stored as integers
				timestamp = newTimestamp
			end
			private.db:BulkInsertNewRowFast6(recordType, type, amount, otherPlayer, player, timestamp)
		end
	end

	if not TSMAPI_FOUR.CSV.DecodeEnd(decodeContext) then
		TSM:LOG_ERR("Failed to decode %s records", recordType)
	end
end

function private.SaveData(recordType)
	local query = private.db:NewQuery()
		:Equal("recordType", recordType)
	local encodeContext = TSMAPI_FOUR.CSV.EncodeStart(CSV_KEYS)
	for _, row in query:Iterator() do
		TSMAPI_FOUR.CSV.EncodeAddRowData(encodeContext, row)
	end
	query:Release()
	return TSMAPI_FOUR.CSV.EncodeEnd(encodeContext)
end

function private.InsertRecord(recordType, type, amount, otherPlayer, timestamp)
	assert(type and amount and amount > 0 and otherPlayer and timestamp)
	timestamp = floor(timestamp)
	local matchingRow = private.db:NewQuery()
		:Equal("recordType", recordType)
		:Equal("type", type)
		:Equal("otherPlayer", otherPlayer)
		:Equal("player", UnitName("player"))
		:GreaterThan("time", timestamp - COMBINE_TIME_THRESHOLD)
		:LessThan("time", timestamp + COMBINE_TIME_THRESHOLD)
		:GetFirstResultAndRelease()
	if matchingRow then
		matchingRow:SetField("amount", matchingRow:GetField("amount") + amount)
		matchingRow:Update()
		matchingRow:Release()
	else
		private.db:NewRow()
			:SetField("recordType", recordType)
			:SetField("type", type)
			:SetField("amount", amount)
			:SetField("otherPlayer", otherPlayer)
			:SetField("player", UnitName("player"))
			:SetField("time", timestamp)
			:Create()
	end
end
