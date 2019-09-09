-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local AuctionDB = TSM.Tooltip:NewPackage("AuctionDB")
local L = TSM.L
local private = {}
local DEFAULTS = {
	minBuyout = true,
	marketValue = true,
	historical = false,
	regionMinBuyout = false,
	regionMarketValue = true,
	regionHistorical = false,
	regionSale = true,
	regionSalePercent = true,
	regionSoldPerDay = true,
}
local TOOLTIP_STRINGS = {
	minBuyout = L["Min Buyout"],
	marketValue = L["Market Value"],
	historical = L["Historical Price"],
	regionMinBuyout = L["Region Min Buyout Avg"],
	regionMarketValue = L["Region Market Value Avg"],
	regionHistorical = L["Region Historical Price"],
	regionSale = L["Region Sale Avg"],
	regionSalePercent = L["Region Sale Rate"],
	regionSoldPerDay = L["Region Avg Daily Sold"],
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function AuctionDB.OnInitialize()
	TSM.Tooltip.Register("AuctionDB", DEFAULTS, private.LoadTooltip)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.LoadTooltip(tooltip, itemString, options)
	-- add min buyout
	private.AddItemValueLine(tooltip, options, itemString, "minBuyout")
	-- add market value
	private.AddItemValueLine(tooltip, options, itemString, "marketValue")
	-- add historical price
	private.AddItemValueLine(tooltip, options, itemString, "historical")
	-- add region min buyout
	private.AddItemValueLine(tooltip, options, itemString, "regionMinBuyout")
	-- add region market value
	private.AddItemValueLine(tooltip, options, itemString, "regionMarketValue")
	-- add region historical price
	private.AddItemValueLine(tooltip, options, itemString, "regionHistorical")
	-- add region sale avg
	private.AddItemValueLine(tooltip, options, itemString, "regionSale")
	-- add region sale rate
	private.AddItemValueLine(tooltip, options, itemString, "regionSalePercent")
	-- add region sold per day
	private.AddItemValueLine(tooltip, options, itemString, "regionSoldPerDay")

	-- add the header if we've added at least one line
	local lastScan = TSM.AuctionDB.GetRealmItemData(itemString, "lastScan")
	local rightStr = nil
	if lastScan then
		local timeColor = (time() - lastScan) > 60 * 60 * 3 and "|cffff0000" or "|cff00ff00"
		local timeDiff = SecondsToTime(time() - lastScan)
		local numAuctions = TSM.AuctionDB.GetRealmItemData(itemString, "numAuctions") or 0
		rightStr = format("%s (%s)", format("|cffffffff"..L["%d auctions"].."|r", numAuctions), format(timeColor..L["%s ago"].."|r", timeDiff))
	else
		rightStr = "|cffffffff"..L["Not Scanned"].."|r"
	end

	return rightStr
end

function private.AddItemValueLine(tooltip, options, itemString, key)
	if not options[key] then
		return
	end
	local value = nil
	if strmatch(key, "^region") then
		value = TSM.AuctionDB.GetRegionItemData(itemString, key)
	else
		value = TSM.AuctionDB.GetRealmItemData(itemString, key)
	end
	if value then
		if key == "regionSalePercent" or key == "regionSoldPerDay" then
			tooltip:AddLine(TOOLTIP_STRINGS[key], "|cffffffff"..format("%0.2f", value/100).."|r")
		else
			tooltip:AddItemValueLine(TOOLTIP_STRINGS[key], value)
		end
	end
end
