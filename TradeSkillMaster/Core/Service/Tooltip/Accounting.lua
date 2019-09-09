-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Accounting = TSM.Tooltip:NewPackage("Accounting")
local L = TSM.L
local private = {}
local DEFAULTS = {
	sale = true,
	expiredAuctions = false,
	cancelledAuctions = false,
	saleRate = false,
	purchase = true,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Accounting.OnInitialize()
	TSM.Tooltip.Register("Accounting", DEFAULTS, private.LoadTooltip)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.LoadTooltip(tooltip, itemString, options)
	local avgSalePrice, totalSaleNum = nil, nil
	if options.sale or options.saleRate then
		local totalPrice = nil
		totalPrice, totalSaleNum = TSM.Accounting.Transactions.GetSaleStats(itemString)
		avgSalePrice = totalPrice and TSMAPI_FOUR.Util.Round(totalPrice / totalSaleNum) or nil
	end

	local lastSaleTime = TSM.Accounting.Transactions.GetLastSaleTime(itemString)
	if options.sale and totalSaleNum then
		if IsShiftKeyDown() then
			tooltip:AddLine(L["Sold (Total Price)"], format("|cffffffff%d|r (%s)", totalSaleNum, tooltip:FormatMoney(avgSalePrice * totalSaleNum)))
		else
			local minPrice = TSM.Accounting.Transactions.GetMinSalePrice(itemString)
			local maxPrice = TSM.Accounting.Transactions.GetMaxSalePrice(itemString)
			assert(minPrice and maxPrice)
			tooltip:AddLine(L["Sold (Min/Avg/Max Price)"], format("|cffffffff%d|r (%s / %s / %s)", totalSaleNum, tooltip:FormatMoney(minPrice), tooltip:FormatMoney(avgSalePrice), tooltip:FormatMoney(maxPrice)))
		end
		tooltip:AddLine(L["Last Sold"], "|cffffffff"..format(L["%s ago"], SecondsToTime(time() - lastSaleTime)).."|r")
	end

	local cancelledNum, expiredNum, totalFailed = TSM.Accounting.Auctions.GetStats(itemString, lastSaleTime)
	if expiredNum > 0 and cancelledNum > 0 and options.expiredAuctions and options.cancelledAuctions then
		local rightText = format("|cffffffff%s|r (|cffffffff%s|r/|cffffffff%s|r)", expiredNum + cancelledNum, expiredNum, cancelledNum)
		tooltip:AddLine(L["Failed Since Last Sale (Expired/Cancelled)"], rightText)
	elseif expiredNum > 0 and options.expiredAuctions then
		tooltip:AddLine(L["Expired Since Last Sale"], "|cffffffff"..expiredNum.."|r")
	elseif cancelledNum > 0 and options.cancelledAuctions then
		tooltip:AddLine(L["Cancelled Since Last Sale"], "|cffffffff"..cancelledNum.."|r")
	end

	if options.saleRate and totalSaleNum and totalFailed then
		local saleRate = TSMAPI_FOUR.Util.Round(totalSaleNum / (totalSaleNum + totalFailed), 0.01)
		tooltip:AddLine(L["Sale Rate"], "|cffffffff"..saleRate.."|r")
	end

	local smartBuyPrice, smartBuyNum, totalBuyNum = TSM.Accounting.Transactions.GetBuyStats(itemString)
	local avgBuyPrice = (smartBuyPrice and smartBuyPrice > 0 and smartBuyNum and smartBuyNum > 0) and TSMAPI_FOUR.Util.Round(smartBuyPrice / smartBuyNum) or nil
	if options.purchase and avgBuyPrice then
		local lastBuyTime = TSM.Accounting.Transactions.GetLastBuyTime(itemString)
		assert(lastBuyTime)
		if IsShiftKeyDown() then
			tooltip:AddLine(L["Purchased (Total Price)"], format("|cffffffff%d|r (%s)", totalBuyNum, tooltip:FormatMoney(avgBuyPrice * smartBuyNum)))
		else
			local minPrice = TSM.Accounting.Transactions.GetMinBuyPrice(itemString)
			local maxPrice = TSM.Accounting.Transactions.GetMaxBuyPrice(itemString)
			tooltip:AddLine(L["Purchased (Min/Avg/Max Price)"], format("|cffffffff%d|r (%s / %s / %s)", totalBuyNum, tooltip:FormatMoney(minPrice), tooltip:FormatMoney(avgBuyPrice), tooltip:FormatMoney(maxPrice)))
		end
		tooltip:AddLine(L["Last Purchased"], "|cffffffff"..format(L["%s ago"], SecondsToTime(time() - lastBuyTime)).."|r")
	end
end
