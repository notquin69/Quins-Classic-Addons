-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local GroupSearch = TSM.Shopping:NewPackage("GroupSearch")
local L = TSM.L
local private = {
	groups = {},
	itemList = {},
	maxQuantity = {},
	scanThreadId = nil,
	seenMaxPrice = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function GroupSearch.OnInitialize()
	-- initialize thread
	private.scanThreadId = TSMAPI_FOUR.Thread.New("GROUP_SEARCH", private.ScanThread)
end

function GroupSearch.GetScanContext()
	return private.scanThreadId, private.MarketValueFunction
end



-- ============================================================================
-- Scan Thread
-- ============================================================================

function private.ScanThread(auctionScan, groupList)
	auctionScan:SetCustomFilterFunc(private.ScanFilter)
	auctionScan:SetScript("OnFilterPartialDone", private.OnFilterPartialDone)
	wipe(private.seenMaxPrice)

	-- create the list of items, and add filters for them
	wipe(private.itemList)
	wipe(private.maxQuantity)
	for _, groupPath in ipairs(groupList) do
		private.groups[groupPath] = true
		for _, _, operation in TSM.Operations.GroupOperationIterator("Shopping", groupPath) do
			for _, itemString in TSM.Groups.ItemIterator(groupPath) do
				local isValid, err = TSMAPI_FOUR.CustomPrice.Validate(operation.maxPrice)
				if operation.restockQuantity > 0 then
					-- include mail and bags
					local numHave = TSMAPI_FOUR.Inventory.GetBagQuantity(itemString) + TSMAPI_FOUR.Inventory.GetMailQuantity(itemString)
					if operation.restockSources.bank then
						numHave = numHave + TSMAPI_FOUR.Inventory.GetBankQuantity(itemString) + TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString)
					end
					if operation.restockSources.guild then
						numHave = numHave + TSMAPI_FOUR.Inventory.GetGuildQuantity(itemString)
					end
					local _, numAlts, numAuctions = TSMAPI_FOUR.Inventory.GetPlayerTotals(itemString)
					if operation.restockSources.alts then
						numHave = numHave + numAlts
					end
					if operation.restockSources.auctions then
						numHave = numHave + numAuctions
					end
					if numHave >= operation.restockQuantity then
						isValid = false
					else
						private.maxQuantity[itemString] = operation.restockQuantity - numHave
					end
				end
				if not operation.showAboveMaxPrice and not TSMAPI_FOUR.CustomPrice.GetValue(operation.maxPrice, itemString) then
					-- we're not showing auctions above the max price and the max price isn't valid for this item, so skip it
					isValid = false
				end
				if isValid then
					tinsert(private.itemList, itemString)
				elseif err then
					TSM:Printf(L["Invalid custom price source for %s. %s"], TSMAPI_FOUR.Item.GetLink(itemString), err)
				end
			end
		end
	end
	if #private.itemList == 0 then
		return false
	end
	auctionScan:AddItemListFiltersThreaded(private.itemList, private.maxQuantity)

	-- run the scan
	auctionScan:StartScanThreaded()
	return true
end

function private.ScanFilter(itemString, itemBuyout, stackSize)
	if itemBuyout == 0 then
		return true
	end

	local groupPath = TSM.Groups.GetPathByItem(itemString)
	if not groupPath or not private.groups[groupPath] then
		return true
	end

	local _, operation = TSM.Operations.GetFirstOperationByItem("Shopping", itemString)
	if not operation then
		return true
	end

	if operation.evenStacks and stackSize % 5 ~= 0 then
		return true
	end

	if not operation.showAboveMaxPrice then
		local maxPrice = TSMAPI_FOUR.CustomPrice.GetValue(operation.maxPrice, itemString)
		if not maxPrice or itemBuyout > maxPrice then
			private.seenMaxPrice[itemString] = true
			return true
		end
	end

	return false
end

function private.OnFilterPartialDone(auctionScan, filter)
	for _, itemString in ipairs(filter:GetItems()) do
		local _, operationSettings = TSM.Operations.GetFirstOperationByItem("Shopping", itemString)
		-- the operation may get removed as we scan
		if operationSettings then
			if operationSettings.showAboveMaxPrice then
				-- need to scan all the auctions
				return false
			end
			if not private.seenMaxPrice[itemString] then
				-- need to keep scanning until we reach the max price
				return false
			end
		end
	end
	return true
end

function private.MarketValueFunction(row)
	local itemString = row:GetField("itemString")
	local _, operation = TSM.Operations.GetFirstOperationByItem("Shopping", itemString)
	if not operation then
		return
	end
	return TSMAPI_FOUR.CustomPrice.GetValue(operation.maxPrice, itemString)
end
