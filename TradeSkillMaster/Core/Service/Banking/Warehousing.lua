-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Warehousing = TSM.Banking:NewPackage("Warehousing")
local private = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Warehousing.MoveGroupsToBank(callback, groups)
	local items = TSMAPI_FOUR.Util.AcquireTempTable()
	TSM.Banking.Util.PopulateGroupItemsFromBags(items, groups, private.GetNumToMoveToBank)
	TSM.Banking.MoveToBank(items, callback)
	TSMAPI_FOUR.Util.ReleaseTempTable(items)
end

function Warehousing.MoveGroupsToBags(callback, groups)
	local items = TSMAPI_FOUR.Util.AcquireTempTable()
	TSM.Banking.Util.PopulateGroupItemsFromOpenBank(items, groups, private.GetNumToMoveToBags)
	TSM.Banking.MoveToBag(items, callback)
	TSMAPI_FOUR.Util.ReleaseTempTable(items)
end

function Warehousing.RestockBags(callback, groups)
	local items = TSMAPI_FOUR.Util.AcquireTempTable()
	TSM.Banking.Util.PopulateGroupItemsFromOpenBank(items, groups, private.GetNumToMoveRestock)
	TSM.Banking.MoveToBag(items, callback)
	TSMAPI_FOUR.Util.ReleaseTempTable(items)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetNumToMoveToBank(itemString, numToMove)
	local _, operationSettings = TSM.Operations.GetFirstOperationByItem("Warehousing", itemString)
	if not operationSettings then
		return 0
	end
	if operationSettings.keepBagQuantity ~= 0 then
		numToMove = max(numToMove - operationSettings.keepBagQuantity, 0)
	end
	if operationSettings.moveQuantity ~= 0 then
		numToMove = min(numToMove, operationSettings.moveQuantity)
	end
	return numToMove
end

function private.GetNumToMoveToBags(itemString, numToMove)
	local _, operationSettings = TSM.Operations.GetFirstOperationByItem("Warehousing", itemString)
	if not operationSettings then
		return 0
	end
	if operationSettings.keepBankQuantity ~= 0 then
		numToMove = max(numToMove - operationSettings.keepBankQuantity, 0)
	end
	if operationSettings.moveQuantity ~= 0 then
		numToMove = min(numToMove, operationSettings.moveQuantity)
	end
	return TSMAPI_FOUR.Util.Floor(numToMove, operationSettings.stackSize ~= 0 and operationSettings.stackSize or 1)
end

function private.GetNumToMoveRestock(itemString, numToMove)
	local _, operationSettings = TSM.Operations.GetFirstOperationByItem("Warehousing", itemString)
	if not operationSettings then
		return 0
	end
	local numInBags = TSM.Inventory.BagTracking.GetQuantityByAutoBaseItemString(itemString, true, true)
	if operationSettings.restockQuantity == 0 or numInBags >= operationSettings.restockQuantity then
		return 0
	end
	if operationSettings.restockKeepBankQuantity ~= 0 then
		numToMove = max(numToMove - operationSettings.restockKeepBankQuantity, 0)
	end
	numToMove = min(numToMove, operationSettings.restockQuantity - numInBags)
	return TSMAPI_FOUR.Util.Floor(numToMove, operationSettings.restockStackSize ~= 0 and operationSettings.restockStackSize or 1)
end
