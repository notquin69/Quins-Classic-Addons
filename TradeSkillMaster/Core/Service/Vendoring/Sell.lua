-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Sell = TSM.Vendoring:NewPackage("Sell")
local private = {
	ignoreDB = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Sell.OnInitialize()
	local used = TSMAPI_FOUR.Util.AcquireTempTable()
	private.ignoreDB = TSMAPI_FOUR.Database.NewSchema("VENDORING_IGNORE")
		:AddUniqueStringField("itemString")
		:AddBooleanField("ignoreSession")
		:AddBooleanField("ignorePermanent")
		:Commit()
	private.ignoreDB:BulkInsertStart()
	for itemString in pairs(TSM.db.global.userData.vendoringIgnore) do
		itemString = TSMAPI_FOUR.Item.ToItemString(itemString)
		if not used[itemString] then
			used[itemString] = true
			private.ignoreDB:BulkInsertNewRow(itemString, false, true)
		end
	end
	private.ignoreDB:BulkInsertEnd()
	TSMAPI_FOUR.Util.ReleaseTempTable(used)

	private.potentialValueDB = TSMAPI_FOUR.Database.NewSchema("VENDORING_POTENTIAL_VALUE")
		:AddUniqueStringField("itemString")
		:AddNumberField("potentialValue")
		:Commit()
	TSM.Inventory.BagTracking.RegisterCallback(private.UpdatePotentialValueDB)
end

function Sell.IgnoreItemSession(itemString)
	local row = private.ignoreDB:GetUniqueRow("itemString", itemString)
	if row then
		assert(not row:GetField("ignoreSession"))
		row:SetField("ignoreSession", true)
		row:Update()
		row:Release()
	else
		private.ignoreDB:NewRow()
			:SetField("itemString", itemString)
			:SetField("ignoreSession", true)
			:SetField("ignorePermanent", false)
			:Create()
	end
end

function Sell.IgnoreItemPermanent(itemString)
	assert(not TSM.db.global.userData.vendoringIgnore[itemString])
	TSM.db.global.userData.vendoringIgnore[itemString] = true

	local row = private.ignoreDB:GetUniqueRow("itemString", itemString)
	if row then
		assert(not row:GetField("ignorePermanent"))
		row:SetField("ignorePermanent", true)
		row:Update()
		row:Release()
	else
		private.ignoreDB:NewRow()
			:SetField("itemString", itemString)
			:SetField("ignoreSession", false)
			:SetField("ignorePermanent", true)
			:Create()
	end
end

function Sell.ForgetIgnoreItemPermanent(itemString)
	assert(TSM.db.global.userData.vendoringIgnore[itemString])
	TSM.db.global.userData.vendoringIgnore[itemString] = nil

	local row = private.ignoreDB:GetUniqueRow("itemString", itemString)
	assert(row and row:GetField("ignorePermanent"))
	if row:GetField("ignoreSession") then
		row:SetField("ignorePermanent")
		row:Update()
	else
		private.ignoreDB:DeleteRow(row)
	end
	row:Release()
end

function Sell.CreateIgnoreQuery()
	return private.ignoreDB:NewQuery()
		:Equal("ignorePermanent", true)
		:InnerJoin(TSM.ItemInfo.GetDBForJoin(), "itemString")
		:OrderBy("name", true)
end

function Sell.CreateBagsQuery()
	local query = TSM.Inventory.BagTracking.CreateQuery()
		:Distinct("itemString")
		:LeftJoin(private.ignoreDB, "itemString")
		:InnerJoin(TSM.ItemInfo.GetDBForJoin(), "itemString")
		:LeftJoin(private.potentialValueDB, "itemString")
	Sell.ResetBagsQuery(query)
	return query
end

function Sell.ResetBagsQuery(query)
	query:ResetOrderBy()
	query:ResetFilters()
	query:GreaterThanOrEqual("bag", 0)
		:LessThanOrEqual("bag", NUM_BAG_SLOTS)
		:NotEqual("ignoreSession", true)
		:NotEqual("ignorePermanent", true)
		:GreaterThan("vendorSell", 0)
		:OrderBy("name", true)
end

function Sell.SellItem(itemString, includeSoulbound)
	for _, bag, slot, bagItemString in TSMAPI_FOUR.Inventory.BagIterator() do
		if itemString == bagItemString and TSMAPI_FOUR.Item.ToItemString(GetContainerItemLink(bag, slot)) == itemString then
			UseContainerItem(bag, slot)
		end
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.UpdatePotentialValueDB()
	local used = TSMAPI_FOUR.Util.AcquireTempTable()
	private.potentialValueDB:TruncateAndBulkInsertStart()
	for _, _, _, itemString in TSMAPI_FOUR.Inventory.BagIterator() do
		if not used[itemString] then
			used[itemString] = true
			local value = TSMAPI_FOUR.CustomPrice.GetValue(TSM.db.global.vendoringOptions.qsMarketValue, itemString)
			if value then
				private.potentialValueDB:BulkInsertNewRow(itemString, value)
			end
		end
	end
	private.potentialValueDB:BulkInsertEnd()
	TSMAPI_FOUR.Util.ReleaseTempTable(used)
end
