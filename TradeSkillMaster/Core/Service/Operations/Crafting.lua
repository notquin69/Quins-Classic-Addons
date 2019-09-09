-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Crafting = TSM.Operations:NewPackage("Crafting")
local private = {}
local L = TSM.L
local OPERATION_INFO = {
	minRestock = { type = "number", default = 1 },
	maxRestock = { type = "number", default = 3 },
	minProfit = { type = "string", default = "100g" },
	craftPriceMethod = { type = "string", default = "" },
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Crafting.OnInitialize()
	TSM.Operations.Register("Crafting", L["Crafting"], OPERATION_INFO, 1, private.GetOperationInfo)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetOperationInfo(operationSettings)
	if operationSettings.minProfit ~= "" then
		return format(L["Restocking to a max of %d (min of %d) with a min profit."], operationSettings.maxRestock, operationSettings.minRestock)
	else
		return format(L["Restocking to a max of %d (min of %d) with no min profit."], operationSettings.maxRestock, operationSettings.minRestock)
	end
end
