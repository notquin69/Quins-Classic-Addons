-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Shopping = TSM.Operations:NewPackage("Shopping")
local private = {}
local L = TSM.L
local OPERATION_INFO = {
	restockQuantity = { type = "number", default = 0 },
	maxPrice = { type = "string", default = "dbmarket" },
	evenStacks = { type = "boolean", default = false },
	showAboveMaxPrice = { type = "boolean", default = true },
	restockSources = { type = "table", default = { alts = false, auctions = false, bank = false, guild = false } },
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Shopping.OnInitialize()
	TSM.Operations.Register("Shopping", L["Shopping"], OPERATION_INFO, 1, private.GetOperationInfo)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetOperationInfo(operationSettings)
	if operationSettings.showAboveMaxPrice and operationSettings.evenStacks then
		return format(L["Shopping for even stacks including those above the max price"])
	elseif operationSettings.showAboveMaxPrice then
		return format(L["Shopping for auctions including those above the max price."])
	elseif operationSettings.evenStacks then
		return format(L["Shopping for even stacks with a max price set."])
	else
		return format(L["Shopping for auctions with a max price set."])
	end
end
