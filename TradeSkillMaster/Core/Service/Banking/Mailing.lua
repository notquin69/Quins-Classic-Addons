-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Mailing = TSM.Banking:NewPackage("Mailing")
local private = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Mailing.MoveGroupsToBank(callback, groups)
	local items = TSMAPI_FOUR.Util.AcquireTempTable()
	TSM.Banking.Util.PopulateGroupItemsFromBags(items, groups, private.GroupsGetNumToMoveToBank)
	TSM.Banking.MoveToBank(items, callback)
	TSMAPI_FOUR.Util.ReleaseTempTable(items)
end

function Mailing.NongroupToBank(callback)
	local items = TSMAPI_FOUR.Util.AcquireTempTable()
	TSM.Banking.Util.PopulateItemsFromBags(items, private.NongroupGetNumToBank)
	TSM.Banking.MoveToBank(items, callback)
	TSMAPI_FOUR.Util.ReleaseTempTable(items)
end

function Mailing.TargetShortfallToBags(callback, groups)
	local items = TSMAPI_FOUR.Util.AcquireTempTable()
	TSM.Banking.Util.PopulateGroupItemsFromOpenBank(items, groups, private.TargetShortfallGetNumToBags)
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

function private.NongroupGetNumToBank(itemString, numHave)
	local hasOperations = false
	for _ in TSM.Operations.GroupOperationIterator("Mailing", TSM.Groups.GetPathByItem(itemString)) do
		hasOperations = true
	end
	return not hasOperations and numHave or 0
end

function private.TargetShortfallGetNumToBags(itemString, numHave)
	local totalNumToSend = 0
	for _, _, operationSettings in TSM.Operations.GroupOperationIterator("Mailing", TSM.Groups.GetPathByItem(itemString)) do
		local numAvailable = numHave - operationSettings.keepQty
		local numToSend = 0
		if numAvailable > 0 then
			if operationSettings.maxQtyEnabled then
				if operationSettings.restock then
					local targetQty = private.GetTargetQuantity(operationSettings.target, itemString, operationSettings.restockSources)
					if TSMAPI_FOUR.PlayerInfo.IsPlayer(operationSettings.target) and targetQty <= operationSettings.maxQty then
						numToSend = numAvailable
					else
						numToSend = min(numAvailable, operationSettings.maxQty - targetQty)
					end
					if TSMAPI_FOUR.PlayerInfo.IsPlayer(operationSettings.target) then
						-- if using restock and target == player ensure that subsequent operations don't take reserved bag inventory
						numHave = numHave - max((numAvailable - (targetQty - operationSettings.maxQty)), 0)
					end
				else
					numToSend = min(numAvailable, operationSettings.maxQty)
				end
			else
				numToSend = numAvailable
			end
		end
		totalNumToSend = totalNumToSend + numToSend
		numHave = numHave - numToSend
	end
	return totalNumToSend
end

function private.GetTargetQuantity(player, itemString, sources)
	if player then
		player = strtrim(strmatch(player, "^[^-]+"))
	end
	local num = TSMAPI_FOUR.Inventory.GetBagQuantity(itemString, player) + TSMAPI_FOUR.Inventory.GetMailQuantity(itemString, player) + TSMAPI_FOUR.Inventory.GetAuctionQuantity(itemString, player)
	if sources then
		if sources.guild then
			num = num + TSMAPI_FOUR.Inventory.GetGuildQuantity(itemString, TSMAPI_FOUR.PlayerInfo.GetPlayerGuild(player))
		end
		if sources.bank then
			num = num + TSMAPI_FOUR.Inventory.GetBankQuantity(itemString, player) + TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString, player)
		end
	end
	return num
end
