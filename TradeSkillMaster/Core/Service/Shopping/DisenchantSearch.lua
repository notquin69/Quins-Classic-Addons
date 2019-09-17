-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local DisenchantSearch = TSM.Shopping:NewPackage("DisenchantSearch")
local L = TSM.L
local private = { itemList = {}, scanThreadId = nil }



-- ============================================================================
-- Module Functions
-- ============================================================================

function DisenchantSearch.OnInitialize()
	-- initialize thread
	private.scanThreadId = TSMAPI_FOUR.Thread.New("DISENCHANT_SEARCH", private.ScanThread)
end

function DisenchantSearch.GetScanContext()
	return private.scanThreadId, private.MarketValueFunction
end



-- ============================================================================
-- Scan Thread
-- ============================================================================

function private.ScanThread(auctionScan)
	if (TSM.AuctionDB.GetLastCompleteScanTime() or 0) < time() - 60 * 60 * 12 then
		TSM:Print(L["No recent AuctionDB scan data found."])
		return false
	end
	auctionScan:SetCustomFilterFunc(private.IsItemBuyoutTooHigh)

	-- create the list of items, and add filters for them
	wipe(private.itemList)
	for _, itemString, _, minBuyout in TSM.AuctionDB.LastScanIteratorThreaded() do
		if minBuyout and private.ShouldInclude(itemString, minBuyout) then
			tinsert(private.itemList, itemString)
		end
		TSMAPI_FOUR.Thread.Yield()
	end
	auctionScan:AddItemListFiltersThreaded(private.itemList)

	-- run the scan
	auctionScan:StartScanThreaded()
	return true
end

function private.ShouldInclude(itemString, minBuyout)
	if not TSMAPI_FOUR.Item.IsDisenchantable(itemString) then
		return false
	end

	local itemLevel = TSMAPI_FOUR.Item.GetItemLevel(itemString) or -1
	if itemLevel < TSM.db.global.shoppingOptions.minDeSearchLvl or itemLevel > TSM.db.global.shoppingOptions.maxDeSearchLvl then
		return false
	end

	if private.IsItemBuyoutTooHigh(itemString, minBuyout) then
		return false
	end

	return true
end

function private.IsItemBuyoutTooHigh(itemString, buyout)
	local disenchantValue = TSMAPI_FOUR.CustomPrice.GetItemPrice(itemString, "Destroy")
	return not disenchantValue or buyout > TSM.db.global.shoppingOptions.maxDeSearchPercent / 100 * disenchantValue
end

function private.MarketValueFunction(row)
	return TSMAPI_FOUR.CustomPrice.GetItemPrice(row:GetField("itemString"), "Destroy")
end
