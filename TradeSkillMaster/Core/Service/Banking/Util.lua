-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Util = TSM.Banking:NewPackage("Util")
local private = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Util.BagIterator(autoBaseItems)
	local includeBoABoP = not TSM.Banking.IsGuildBankOpen()
	return TSMAPI_FOUR.Inventory.BagIterator(autoBaseItems, includeBoABoP, includeBoABoP)
end

function Util.OpenBankIterator(autoBaseItems)
	if TSM.Banking.IsGuildBankOpen() then
		return TSM.Inventory.GuildTracking.GuildBankIterator(autoBaseItems)
	else
		return TSMAPI_FOUR.Inventory.BankIterator(autoBaseItems, true, true, true)
	end
end

function Util.PopulateGroupItemsFromBags(items, groups, getNumFunc, ...)
	local itemQuantity = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, _, _, itemString, quantity in Util.BagIterator(true) do
		if private.InGroups(itemString, groups) then
			itemQuantity[itemString] = (itemQuantity[itemString] or 0) + quantity
		end
	end
	for itemString, numHave in pairs(itemQuantity) do
		local numToMove = getNumFunc(itemString, numHave, ...)
		if numToMove > 0 then
			items[itemString] = numToMove
		end
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(itemQuantity)
end

function Util.PopulateGroupItemsFromOpenBank(items, groups, getNumFunc, ...)
	local itemQuantity = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, _, _, itemString, quantity in Util.OpenBankIterator(true) do
		if private.InGroups(itemString, groups) then
			itemQuantity[itemString] = (itemQuantity[itemString] or 0) + quantity
		end
	end
	for itemString, numHave in pairs(itemQuantity) do
		local numToMove = getNumFunc(itemString, numHave, ...)
		if numToMove > 0 then
			items[itemString] = numToMove
		end
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(itemQuantity)
end

function Util.PopulateItemsFromBags(items, getNumFunc, ...)
	local itemQuantity = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, _, _, itemString, quantity in Util.BagIterator(true) do
		itemQuantity[itemString] = (itemQuantity[itemString] or 0) + quantity
	end
	for itemString, numHave in pairs(itemQuantity) do
		local numToMove = getNumFunc(itemString, numHave, ...)
		if numToMove > 0 then
			items[itemString] = numToMove
		end
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(itemQuantity)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.InGroups(itemString, groups)
	local groupPath = TSM.Groups.GetPathByItem(itemString)
	-- TODO: support the base group
	return groupPath and groupPath ~= TSM.CONST.ROOT_GROUP_PATH and groups[groupPath]
end
