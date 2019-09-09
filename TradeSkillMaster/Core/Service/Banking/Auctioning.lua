-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Auctioning = TSM.Banking:NewPackage("Auctioning")
local private = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Auctioning.MoveGroupsToBank(callback, groups)
	local items = TSMAPI_FOUR.Util.AcquireTempTable()
	TSM.Banking.Util.PopulateGroupItemsFromBags(items, groups, private.GroupsGetNumToMoveToBank)
	TSM.Banking.MoveToBank(items, callback)
	TSMAPI_FOUR.Util.ReleaseTempTable(items)
end

function Auctioning.PostCapToBags(callback, groups)
	local items = TSMAPI_FOUR.Util.AcquireTempTable()
	TSM.Banking.Util.PopulateGroupItemsFromOpenBank(items, groups, private.GetNumToMoveToBags)
	TSM.Banking.MoveToBag(items, callback)
	TSMAPI_FOUR.Util.ReleaseTempTable(items)
end

function Auctioning.ShortfallToBags(callback, groups)
	local items = TSMAPI_FOUR.Util.AcquireTempTable()
	TSM.Banking.Util.PopulateGroupItemsFromOpenBank(items, groups, private.GetNumToMoveToBags, true)
	TSM.Banking.MoveToBag(items, callback)
	TSMAPI_FOUR.Util.ReleaseTempTable(items)
end

function Auctioning.MaxExpiresToBank(callback, groups)
	local items = TSMAPI_FOUR.Util.AcquireTempTable()
	TSM.Banking.Util.PopulateGroupItemsFromBags(items, groups, private.MaxExpiresGetNumToMoveToBank)
	TSM.Banking.MoveToBag(items, callback)
	TSMAPI_FOUR.Util.ReleaseTempTable(items)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GroupsGetNumToMoveToBank(itemString, numHave)
	-- move everything
	return numHave
end

function private.GetNumToMoveToBags(itemString, numHave, includeAH)
	local totalNumToMove = 0
	local numAvailable = numHave
	local numInBags = TSM.Inventory.BagTracking.GetQuantityByAutoBaseItemString(itemString, true, true)
	if includeAH then
		numInBags = numInBags + select(3, TSMAPI_FOUR.Inventory.GetPlayerTotals(itemString)) + TSMAPI_FOUR.Inventory.GetMailQuantity(itemString)
	end

	for _, _, operationSettings in TSM.Operations.GroupOperationIterator("Auctioning", TSM.Groups.GetPathByItem(itemString)) do
		local operationHasExpired = false
		if operationSettings.maxExpires > 0 then
			local numExpires = TSM.Accounting.Auctions.GetNumExpiresSinceSale(itemString)
			if numExpires and numExpires > operationSettings.maxExpires then
				operationHasExpired = true
			end
		end

		if not operationHasExpired then
			-- subtract the keep quantity
			if operationSettings.keepQuantity > 0 then
				if TSM.Banking.IsGuildBankOpen() and operationSettings.keepQtySources.guild then
					local numInBank = 0
					if operationSettings.keepQtySources.bank then
						numInBank = TSM.Inventory.BagTracking.GetBankQuantityByAutoBaseItemString(itemString, true, true)
					end
					numAvailable = numAvailable - max(operationSettings.keepQuantity - numInBank, 0)
				elseif not TSM.Banking.IsGuildBankOpen() and operationSettings.keepQtySources.bank then
					local numInBank = 0
					if operationSettings.keepQtySources.guild then
						numInBank = TSM.Inventory.GuildTracking.GetQuantityByAutoBaseItemString(itemString)
					end
					numAvailable = numAvailable - max(operationSettings.keepQuantity - numInBank, 0)
				end
			end

			local numNeeded = operationSettings.stackSize * operationSettings.postCap
			if numInBags > numNeeded then
				-- we can satisfy this operation from the bags
				numInBags = numInBags - numNeeded
				numNeeded = 0
			elseif numInBags > 0 then
				-- we can partially satisfy this operation from the bags
				numNeeded = numNeeded - numInBags
				numInBags = 0
			end

			local numToMove = min(numAvailable, numNeeded)
			if numToMove > 0 then
				numAvailable = numAvailable - numToMove
				totalNumToMove = totalNumToMove + numToMove
			end
		end
	end

	return totalNumToMove
end

function private.MaxExpiresGetNumToMoveToBank(itemString, numHave)
	local numToKeepInBags = 0
	for _, _, operationSettings in TSM.Operations.GroupOperationIterator("Auctioning", TSM.Groups.GetPathByItem(itemString)) do
		local operationHasExpired = false
		if operationSettings.maxExpires > 0 then
			local numExpires = TSM.Accounting.Auctions.GetNumExpiresSinceSale(itemString)
			if numExpires and numExpires > operationSettings.maxExpires then
				operationHasExpired = true
			end
		end
		if not operationHasExpired then
			numToKeepInBags = numToKeepInBags + operationSettings.stackSize * operationSettings.postCap
		end
	end
	return max(numHave - numToKeepInBags, 0)
end
