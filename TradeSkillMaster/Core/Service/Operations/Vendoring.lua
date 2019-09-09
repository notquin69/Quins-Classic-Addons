-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Vendoring = TSM.Operations:NewPackage("Vendoring")
local private = {}
local L = TSM.L
local OPERATION_INFO = {
	sellAfterExpired = { type = "number", default = 20 },
	sellSoulbound = { type = "boolean", default = false },
	keepQty = { type = "number", default = 0 },
	restockQty = { type = "number", default = 0 },
	restockSources = { type = "table", default = { alts = false, ah = false, bank = false, guild = false, alts_ah = false, mail = false } },
	enableBuy = { type = "boolean", default = true },
	enableSell = { type = "boolean", default = true },
	vsMarketValue = { type = "string", default = "dbmarket" },
	vsMaxMarketValue = { type = "string", default = "0c" },
	vsDestroyValue = { type = "string", default = "destroy" },
	vsMaxDestroyValue = { type = "string", default = "0c" },
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Vendoring.OnInitialize()
	TSM.Operations.Register("Vendoring", L["Vendoring"], OPERATION_INFO, 1, private.GetOperationInfo)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetOperationInfo(operationSettings)
	local parts = TSMAPI_FOUR.Util.AcquireTempTable()
	if operationSettings.enableBuy and operationSettings.restockQty > 0 then
		tinsert(parts, format(L["Restocking to %d."], operationSettings.restockQty))
	end

	if operationSettings.enableSell then
		if operationSettings.keepQty > 0 then
			tinsert(parts, format(L["Keeping %d."], operationSettings.keepQty))
		end
		if operationSettings.sellSoulbound then
			tinsert(parts, L["Selling soulbound items."])
		end
	end

	local result = table.concat(parts, " ")
	TSMAPI_FOUR.Util.ReleaseTempTable(parts)
	return result
end
