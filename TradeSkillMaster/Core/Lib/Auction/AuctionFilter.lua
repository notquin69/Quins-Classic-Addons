-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Auction Filter Class.
-- This class represents an auction filter with regards to a scan of the auction house.
-- @classmod AuctionFilter

local _, TSM = ...
local AuctionFilter = TSMAPI_FOUR.Class.DefineClass("AuctionFilter")
TSM.Auction.classes.AuctionFilter = AuctionFilter
local private = {}



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function AuctionFilter.__init(self)
	self._scan = nil
	self._name = nil
	self._minLevel = nil
	self._maxLevel = nil
	self._quality = nil
	self._class = nil
	self._subClass = nil
	self._invType = nil
	self._usable = nil
	self._unlearned = nil
	self._canlearn = nil
	self._exact = nil
	self._sniperLastPage = nil
	self._page = 0
	-- custom filters applies after the scan
	self._evenOnly = nil
	self._minItemLevel = nil
	self._maxItemLevel = nil
	self._minPrice = nil
	self._maxPrice = nil
	self._generalMaxQuantity = nil
	self._targetItem = nil
	self._getAll = nil
	self._items = {}
	self._itemMaxQuantities = {}
	self._resultIncludesRow = {}
end

function AuctionFilter._Acquire(self, scan)
	self._scan = scan
	self._page = 0
end

function AuctionFilter._Release(self)
	self._scan = nil
	self._name = nil
	self._minLevel = nil
	self._maxLevel = nil
	self._quality = nil
	self._class = nil
	self._subClass = nil
	self._invType = nil
	self._usable = nil
	self._unlearned = nil
	self._canlearn = nil
	self._exact = nil
	self._sniperLastPage = nil
	self._evenOnly = nil
	self._minItemLevel = nil
	self._maxItemLevel = nil
	self._minPrice = nil
	self._maxPrice = nil
	self._generalMaxQuantity = nil
	self._targetItem = nil
	self._getAll = nil
	wipe(self._items)
	wipe(self._itemMaxQuantities)
	wipe(self._resultIncludesRow)
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function AuctionFilter.SetName(self, name)
	self._name = name
	return self
end

function AuctionFilter.SetMinLevel(self, minLevel)
	self._minLevel = minLevel
	return self
end

function AuctionFilter.SetMaxLevel(self, maxLevel)
	self._maxLevel = maxLevel
	return self
end

function AuctionFilter.SetQuality(self, quality)
	self._quality = quality
	return self
end

function AuctionFilter.SetClass(self, class)
	self._class = class
	return self
end

function AuctionFilter.SetSubClass(self, subClass)
	self._subClass = subClass
	return self
end

function AuctionFilter.SetInvType(self, invType)
	self._invType = invType
	return self
end

function AuctionFilter.SetUsable(self, usable)
	self._usable = usable
	return self
end

function AuctionFilter.SetUnlearned(self, unlearned)
	self._unlearned = unlearned
	return self
end

function AuctionFilter.SetCanLearn(self, canlearn)
	self._canlearn = canlearn
	return self
end

function AuctionFilter.SetExact(self, exact)
	self._exact = exact
	return self
end

function AuctionFilter.SetItems(self, items)
	assert(#self._items == 0)
	if type(items) == "table" then
		assert(#items > 0)
		for _, itemString in ipairs(items) do
			tinsert(self._items, itemString)
		end
	else
		tinsert(self._items, items)
	end
	return self
end

function AuctionFilter.SetEvenOnly(self, evenOnly)
	self._evenOnly = evenOnly
	return self
end

function AuctionFilter.SetMinItemLevel(self, minItemLevel)
	self._minItemLevel = minItemLevel
	return self
end

function AuctionFilter.SetMaxItemLevel(self, maxItemLevel)
	self._maxItemLevel = maxItemLevel
	return self
end

function AuctionFilter.SetMinPrice(self, minPrice)
	self._minPrice = minPrice
	return self
end

function AuctionFilter.SetMaxPrice(self, maxPrice)
	self._maxPrice = maxPrice
	return self
end

function AuctionFilter.SetGeneralMaxQuantity(self, maxQuantity)
	self._generalMaxQuantity = maxQuantity
	return self
end

function AuctionFilter.SetItemMaxQuantity(self, itemString, maxQuantity)
	self._itemMaxQuantities[itemString] = maxQuantity
	return self
end

function AuctionFilter.SetSniper(self, isLastPage)
	assert(not self._getAll)
	assert(type(isLastPage) == "boolean")
	self._sniperLastPage = isLastPage
	return self
end

function AuctionFilter.SetTargetItem(self, itemString)
	assert(not self._getAll)
	self._targetItem = itemString
	return self
end

function AuctionFilter.SetGetAll(self)
	assert(self._name == nil)
	assert(self._minLevel == nil)
	assert(self._maxLevel == nil)
	assert(self._quality == nil)
	assert(self._class == nil)
	assert(self._subClass == nil)
	assert(self._invType == nil)
	assert(self._usable == nil)
	assert(self._unlearned == nil)
	assert(self._canlearn == nil)
	assert(self._exact == nil)
	assert(self._sniperLastPage == nil)
	assert(self._evenOnly == nil)
	assert(self._minItemLevel == nil)
	assert(self._maxItemLevel == nil)
	assert(self._minPrice == nil)
	assert(self._maxPrice == nil)
	assert(self._generalMaxQuantity == nil)
	assert(self._targetItem == nil)
	assert(#self._items == 0)
	assert(next(self._itemMaxQuantities) == nil)
	self._getAll = true
end

function AuctionFilter.GetItems(self)
	return self._items
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function AuctionFilter._IsSniper(self)
	return self._sniperLastPage ~= nil
end

function AuctionFilter._IsGetAll(self)
	return self._getAll ~= nil
end

function AuctionFilter._GetTargetItem(self)
	return self._targetItem
end

function AuctionFilter._GetPage(self)
	return self._page
end

function AuctionFilter._SetPage(self, page)
	self._page = page
end

function AuctionFilter._ResetPage(self)
	self._page = 0
end

function AuctionFilter._NextPage(self)
	self._page = self._page + 1
	return self._page < private.GetNumPages()
end

function AuctionFilter._GetPageProgress(self)
	return self._page, private.GetNumPages()
end

function AuctionFilter._IsFiltered(self, ignoreItemLevel, rowItemString, rowBuyout, stackSize, targetItemRate)
	if #self._items > 0 then
		local found = false
		local rowBaseItemString = TSMAPI_FOUR.Item.ToBaseItemString(rowItemString)
		for _, itemString in ipairs(self:GetItems()) do
			if itemString == rowItemString or itemString == rowBaseItemString then
				found = true
			end
		end
		if not found then
			return true
		end
	end
	if self._evenOnly and stackSize % 5 ~= 0 then
		return true
	end
	local itemLevel = TSMAPI_FOUR.Item.GetItemLevel(rowItemString)
	if not ignoreItemLevel and (itemLevel < (self._minItemLevel or 0) or itemLevel > (self._maxItemLevel or math.huge)) then
		return true
	end
	if self._unlearned and CanIMogIt:PlayerKnowsTransmog(TSMAPI_FOUR.Item.GetLink(rowItemString)) then
		return true
	end
	if self._canlearn and not CanIMogIt:CharacterCanLearnTransmog(TSMAPI_FOUR.Item.GetLink(rowItemString)) then
		return true
	end
	if self._minPrice or self._maxPrice then
		if not rowBuyout or rowBuyout < (self._minPrice or 0) or rowBuyout > (self._maxPrice or math.huge) then
			return true
		end
	end
	if self._targetItem and targetItemRate == 0 then
		return true
	end
	return false
end

function AuctionFilter._GetTargetItemRate(self, itemString)
	if not self._targetItem then
		return 1
	end
	if itemString == self._targetItem then
		return 1
	end
	local conversionInfo = TSMAPI_FOUR.Conversions.GetSourceItems(self._targetItem)
	if not conversionInfo then
		return 0
	end
	if conversionInfo.disenchant then
		local class = TSMAPI_FOUR.Item.GetClassId(itemString)
		local itemLevel = TSMAPI_FOUR.Item.GetItemLevel(itemString)
		local quality = TSMAPI_FOUR.Item.GetQuality(itemString)
		for _, info in ipairs(conversionInfo.disenchant.sourceInfo) do
			if class == TSMAPI_FOUR.Item.GetClassIdFromClassString(info.itemType) and quality == info.rarity and itemLevel >= info.minItemLevel and itemLevel <= info.maxItemLevel then
				return info.amountOfMats
			end
		end
		return 0
	else
		return conversionInfo.convert[itemString] and conversionInfo.convert[itemString].rate or 0
	end
end

function AuctionFilter._DoAuctionQueryThreaded(self)
	if self:_IsSniper() then
		if self._sniperLastPage then
			-- scan the last page
			local lastPage = max(private.GetNumPages() - 1, 0)
			while true do
				-- wait for the AH to be ready
				while not CanSendAuctionQuery() do
					if self._scan:_IsCancelled() then
						TSM:LOG_INFO("Stopping canelled scan")
						return false
					end
					TSMAPI_FOUR.Thread.Yield(true)
				end
				-- query the AH
				QueryAuctionItems(nil, nil, nil, lastPage)
				-- wait for the update event
				TSMAPI_FOUR.Thread.WaitForEvent("AUCTION_ITEM_LIST_UPDATE")
				local newLastPage = max(private.GetNumPages() - 1, 0)
				if newLastPage == lastPage then
					break
				end
				lastPage = newLastPage
			end
		else
			-- scan the first page
			-- wait for the AH to be ready
			TSMAPI_FOUR.Thread.WaitForFunction(CanSendAuctionQuery)
			-- query the AH
			QueryAuctionItems(nil, nil, nil, 0)
			-- wait for the update event
			TSMAPI_FOUR.Thread.WaitForEvent("AUCTION_ITEM_LIST_UPDATE")
		end
	elseif self:_IsGetAll() then
		-- wait for the AH to be ready
		TSMAPI_FOUR.Thread.WaitForFunction(CanSendAuctionQuery)
		if not select(2, CanSendAuctionQuery()) then
			-- can't do a getall scan right now
			return false
		end
		-- query the AH
		QueryAuctionItems(nil, nil, nil, 0, nil, nil, true)
		-- wait for the update event
		TSMAPI_FOUR.Thread.WaitForEvent("AUCTION_ITEM_LIST_UPDATE")
	else
		-- wait for the AH to be ready
		TSMAPI_FOUR.Thread.WaitForFunction(CanSendAuctionQuery)
		local classFilterInfo = nil
		if self._class or self._subClass or self._invType then
			classFilterInfo = TSMAPI_FOUR.Util.AcquireTempTable()
			if self._invType == LE_INVENTORY_TYPE_CHEST_TYPE or self._invType == LE_INVENTORY_TYPE_ROBE_TYPE then
				-- default AH sends in queries for both chest types, we need to mimic this when using a chest filter
				local info1 = TSMAPI_FOUR.Util.AcquireTempTable()
				info1.classID = self._class
				info1.subClassID = self._subClass
				info1.inventoryType = LE_INVENTORY_TYPE_CHEST_TYPE
				tinsert(classFilterInfo, info1)
				local info2 = TSMAPI_FOUR.Util.AcquireTempTable()
				info2.classID = self._class
				info2.subClassID = self._subClass
				info2.inventoryType = LE_INVENTORY_TYPE_ROBE_TYPE
				tinsert(classFilterInfo, info2)
			elseif self._invType == LE_ITEM_FILTER_TYPE_NECK or self._invType == LE_ITEM_FILTER_TYPE_FINGER or self._invType == LE_ITEM_FILTER_TYPE_TRINKET or self._invType == LE_INVENTORY_TYPE_HOLDABLE_TYPE then
				local info = TSMAPI_FOUR.Util.AcquireTempTable()
				info.classID = self._class
				info.subClassID = 0
				info.inventoryType = self._invType
				tinsert(classFilterInfo, info)
			elseif self._invType == LE_ITEM_FILTER_TYPE_CLOAK then
				local info = TSMAPI_FOUR.Util.AcquireTempTable()
				info.classID = self._class
				info.subClassID = 1
				info.inventoryType = LE_ITEM_FILTER_TYPE_CLOAK
				tinsert(classFilterInfo, info)
			else
				local info = TSMAPI_FOUR.Util.AcquireTempTable()
				info.classID = self._class
				info.subClassID = self._subClass
				info.inventoryType = self._invType
				tinsert(classFilterInfo, info)
			end
		end
		QueryAuctionItems(self._name, self._minLevel, self._maxLevel, self._page, self._usable, self._quality, nil, self._exact, classFilterInfo)
		if classFilterInfo then
			for i = #classFilterInfo, 1, -1 do
				TSMAPI_FOUR.Util.ReleaseTempTable(classFilterInfo[i])
				classFilterInfo[i] = nil
			end
			TSMAPI_FOUR.Util.ReleaseTempTable(classFilterInfo)
		end
		-- wait for the update event
		TSMAPI_FOUR.Thread.WaitForEvent("AUCTION_ITEM_LIST_UPDATE")
	end
end

function AuctionFilter._AddResultRow(self, uuid)
	self._resultIncludesRow[uuid] = true
end

function AuctionFilter._IncludesResultRow(self, uuid)
	return self._resultIncludesRow[uuid]
end

function AuctionFilter._GetNumCanBuy(self, row)
	local num = nil
	if self._generalMaxQuantity then
		num = min(self._generalMaxQuantity, num or math.huge)
	end
	if self._itemMaxQuantities then
		local itemString, baseItemString = row:GetFields("itemString", "baseItemString")
		if self._itemMaxQuantities[itemString] then
			num = min(self._itemMaxQuantities[itemString], num or math.huge)
		elseif self._itemMaxQuantities[baseItemString] then
			num = min(self._itemMaxQuantities[baseItemString], num or math.huge)
		end
	end
	if num then
		num = ceil(num / row:GetField("stackSize"))
	end
	return num
end

function AuctionFilter._RemoveResultRows(self, db, row, bought)
	self._resultIncludesRow[row:GetUUID()] = nil
	db:DeleteRow(row)
	if not bought then
		return
	end

	local numBought, itemString, baseItemString = row:GetFields("stackSize", "itemString", "baseItemString")
	if self._generalMaxQuantity then
		self._generalMaxQuantity = self._generalMaxQuantity - numBought
		if self._generalMaxQuantity <= 0 then
			-- remove everything
			for uuid in pairs(self._resultIncludesRow) do
				self._resultIncludesRow[uuid] = nil
				db:DeleteRowByUUID(uuid)
			end
		end
	end
	if self._itemMaxQuantities then
		if self._itemMaxQuantities[itemString] then
			self._itemMaxQuantities[itemString] = self._itemMaxQuantities[itemString] - numBought
			if self._itemMaxQuantities[itemString] <= 0 then
				-- remove all of this item
				for uuid in pairs(self._resultIncludesRow) do
					if db:GetRowFieldByUUID(uuid, "itemString") == itemString then
						self._resultIncludesRow[uuid] = nil
						db:DeleteRowByUUID(uuid)
					end
				end
			end
		elseif self._itemMaxQuantities[baseItemString] then
			self._itemMaxQuantities[baseItemString] = self._itemMaxQuantities[baseItemString] - numBought
			if self._itemMaxQuantities[baseItemString] <= 0 then
				-- remove all of this item
				for uuid in pairs(self._resultIncludesRow) do
					if db:GetRowFieldByUUID(uuid, "baseItemString") == baseItemString then
						self._resultIncludesRow[uuid] = nil
						db:DeleteRowByUUID(uuid)
					end
				end
			end
		end
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetNumPages()
	local _, total = GetNumAuctionItems("list")
	return ceil(total / NUM_AUCTION_ITEMS_PER_PAGE)
end
