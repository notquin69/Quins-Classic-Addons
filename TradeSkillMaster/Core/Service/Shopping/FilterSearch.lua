-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local L = TSM.L
local FilterSearch = TSM.Shopping:NewPackage("FilterSearch")
local private = {
	scanThreadId = nil,
	itemFilter = nil,
	isSpecial = false,
	craftingModeTargetItem = nil,
	marketValueSource = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function FilterSearch.OnInitialize()
	-- initialize thread
	private.scanThreadId = TSMAPI_FOUR.Thread.New("FILTER_SEARCH", private.ScanThread)
	private.itemFilter = TSMAPI_FOUR.ItemFilter.New()
end

function FilterSearch.GetScanContext(isSpecial)
	private.isSpecial = isSpecial
	return private.scanThreadId, private.MarketValueFunction
end

function FilterSearch.PrepareFilter(filterStr, mode, marketValueSource)
	assert(mode == "NORMAL" or mode == "CRAFTING" or mode == "DISENCHANT")
	local isValid = true
	local filters = TSMAPI_FOUR.Util.AcquireTempTable()

	for filter in TSMAPI_FOUR.Util.StrSplitIterator(filterStr, ";") do
		filter = strtrim(filter)
		if isValid and filter ~= "" and private.itemFilter:ParseStr(filter) then
			local str = private.itemFilter:GetStr()
			if mode == "CRAFTING" and not strfind(strlower(filter), "/crafting") and str then
				filter = filter.."/crafting"
			elseif mode == "DISENCHANT" and not strfind(strlower(filter), "/disenchant") and str then
				filter = filter.."/disenchant"
			end
			if strfind(strlower(filter), "/crafting") then
				local craftingTargetItem = str and TSMAPI_FOUR.Conversions.GetTargetItemByName(str) or nil
				local conversionInfo = craftingTargetItem and TSMAPI_FOUR.Conversions.GetSourceItems(craftingTargetItem)
				if not conversionInfo or not conversionInfo.convert then
					isValid = false
				end
			end
			if strfind(strlower(filter), "/disenchant") then
				local craftingTargetItem =  str and TSMAPI_FOUR.Conversions.GetTargetItemByName(str) or nil
				local conversionInfo = craftingTargetItem and TSMAPI_FOUR.Conversions.GetSourceItems(craftingTargetItem)
				if not conversionInfo or not conversionInfo.disenchant then
					isValid = false
				end
			end
		else
			isValid = false
		end
		if isValid then
			tinsert(filters, filter)
		end
	end

	local result = table.concat(filters, ";")
	TSMAPI_FOUR.Util.ReleaseTempTable(filters)
	if not isValid or result == "" then
		return
	end

	private.marketValueSource = marketValueSource
	return result
end



-- ============================================================================
-- Scan Thread
-- ============================================================================

function private.ScanThread(auctionScan, filterStr)
	local hasFilter = false
	for filter in TSMAPI_FOUR.Util.StrSplitIterator(filterStr, ";") do
		filter = strtrim(filter)
		if filter ~= "" and private.itemFilter:ParseStr(filter) then
			auctionScan:AddItemFilterThreaded(private.itemFilter)
			hasFilter = true
		end
	end
	if not hasFilter then
		TSM:Print(L["Invalid search filter"]..": "..filterStr)
		return false
	end
	if not private.isSpecial then
		TSM.Shopping.SavedSearches.RecordFilterSearch(filterStr)
	end

	-- run the scan
	auctionScan:StartScanThreaded()
	return true
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.MarketValueFunction(row)
	local targetItem, targetItemRate = row:GetFields("targetItem", "targetItemRate")
	local value = TSMAPI_FOUR.CustomPrice.GetValue(private.marketValueSource, targetItem)
	if not value then
		return
	end
	return value * targetItemRate
end
