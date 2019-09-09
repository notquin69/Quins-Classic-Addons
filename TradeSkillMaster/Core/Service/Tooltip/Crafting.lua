-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Crafting = TSM.Tooltip:NewPackage("Crafting")
local L = TSM.L
local private = {}
local DEFAULTS = {
	craftingCost = true,
	matPrice = false,
	detailedMats = false,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Crafting.OnInitialize()
	TSM.Tooltip.Register("Crafting", DEFAULTS, private.LoadTooltip)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.LoadTooltip(tooltip, itemString, options)
	itemString = TSMAPI_FOUR.Item.ToBaseItemString(itemString)

	if TSM.Crafting.CanCraftItem(itemString) and options.craftingCost then
		local cost, spellId = TSM.Crafting.Cost.GetLowestCostByItem(itemString)
		if cost then
			local buyout = TSM.Crafting.Cost.GetCraftedItemValue(itemString)
			local profit = buyout and (buyout - cost) or nil

			local costText = cost and tooltip:FormatMoney(cost) or "|cffffffff---|r"
			local profitColor = (profit or 0) < 0 and "|cffff0000" or "|cff00ff00"
			local profitText = profit and tooltip:FormatMoney(profit, profitColor) or "|cffffffff---|r"
			tooltip:AddLine(L["Crafting Cost"], format(L["%s (%s profit)"], costText, profitText))

			if options.detailedMats then
				tooltip:StartSection()
				local numResult = TSM.Crafting.GetNumResult(spellId)
				for _, matItemString, matQuantity in TSM.Crafting.MatIterator(spellId) do
					local name = TSMAPI_FOUR.Item.GetName(matItemString)
					local matCost = TSM.Crafting.Cost.GetMatCost(matItemString)
					local quality = TSMAPI_FOUR.Item.GetQuality(matItemString)
					if name and matCost and quality then
						tooltip:AddSubItemValueLine(matItemString, matCost, matQuantity / numResult)
					end
				end
				tooltip:EndSection()
			end
		end
	end

	-- add mat price
	if options.matPrice then
		local matCost = TSM.Crafting.Cost.GetMatCost(itemString)
		if matCost then
			tooltip:AddItemValueLine(L["Mat Cost"], matCost)
		end
	end
end
