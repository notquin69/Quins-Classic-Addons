-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Auctioning = TSM.Tooltip:NewPackage("Auctioning")
local L = TSM.L
local private = {}
local DEFAULTS = {
	operationPrices = false,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Auctioning.OnInitialize()
	TSM.Tooltip.Register("Auctioning", DEFAULTS, private.LoadTooltip)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.LoadTooltip(tooltip, itemString, options)
	if not options.operationPrices then
		-- only 1 tooltip option
		return
	end

	itemString = TSMAPI_FOUR.Item.ToBaseItemString(itemString, true)
	local _, operation = TSM.Operations.GetFirstOperationByItem("Auctioning", itemString)
	if not operation then return end

	local minPrice = private.PriceHelper(tooltip, operation, itemString, "minPrice")
	local normalPrice = private.PriceHelper(tooltip, operation, itemString, "normalPrice")
	local maxPrice = private.PriceHelper(tooltip, operation, itemString, "maxPrice")
	tooltip:AddLine(L["Min/Normal/Max Prices"], format("%s / %s / %s", minPrice, normalPrice, maxPrice))
end

function private.PriceHelper(tooltip, operation, itemString, priceKey)
	local price = TSM.Auctioning.Util.GetPrice(priceKey, operation, itemString)
	return price and tooltip:FormatMoney(price) or "|cffffffff---|r"
end
