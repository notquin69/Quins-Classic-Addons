-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local BuyoutSearch = TSM.Sniper:NewPackage("BuyoutSearch")
local private = { scanThreadId = nil }



-- ============================================================================
-- Module Functions
-- ============================================================================

function BuyoutSearch.OnInitialize()
	private.scanThreadId = TSMAPI_FOUR.Thread.New("SNIPER_BUYOUT_SEARCH", private.ScanThread)
end

function BuyoutSearch.GetScanContext()
	return private.scanThreadId, private.MarketValueFunction
end



-- ============================================================================
-- Scan Thread
-- ============================================================================

function private.ScanThread(auctionScan)
	auctionScan:SetCustomFilterFunc(private.ScanFilter)
	local numFilters = auctionScan:GetNumFilters()
	if numFilters == 0 then
		auctionScan:NewAuctionFilter()
			:SetSniper(true)
	else
		assert(numFilters == 1)
	end
	auctionScan:StartScanThreaded()
	return true
end

function private.ScanFilter(row)
	local itemBuyout = row:GetField("itemBuyout")
	if itemBuyout == 0 then
		return true
	end

	local itemString = row:GetField("itemString")
	local _, operationSettings = TSM.Operations.GetFirstOperationByItem("Sniper", itemString)
	if not operationSettings then
		return true
	end

	local maxPrice = TSMAPI_FOUR.CustomPrice.GetValue(operationSettings.belowPrice, itemString)
	if not maxPrice or itemBuyout > maxPrice then
		return true
	end

	return false
end

function private.MarketValueFunction(row)
	local itemString = row:GetField("itemString")
	local _, operationSettings = TSM.Operations.GetFirstOperationByItem("Sniper", itemString)
	if not operationSettings then
		return nil
	end
	return TSMAPI_FOUR.CustomPrice.GetValue(operationSettings.belowPrice, itemString)
end
