-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Inbox = TSM.Mailing:NewPackage("Inbox")
local private = {
	itemsQuery = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Inbox.OnInitialize()
	private.itemsQuery = private.itemsQuery or TSM.Inventory.MailTracking.CreateMailItemQuery()
	private.itemsQuery:Equal("index", TSM.CONST.BOUND_QUERY_PARAM)
end

function Inbox.CreateQuery()
	local query = TSM.Inventory.MailTracking.CreateMailInboxQuery()
	query:VirtualField("itemList", "string", private.GetVirtualItemList)

	return query
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetVirtualItemList(row)
	private.itemsQuery:BindParams(row:GetField("index"))

	local items = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, itemsRow in private.itemsQuery:Iterator() do
		local itemName = TSM.UI.GetColoredItemName(itemsRow:GetField("itemLink")) or ""
		local qty = itemsRow:GetField("quantity")

		tinsert(items, qty > 1 and (itemName.." (x"..qty..")") or itemName)
	end

	local result = table.concat(items, ", ")
	TSMAPI_FOUR.Util.ReleaseTempTable(items)

	return result
end
