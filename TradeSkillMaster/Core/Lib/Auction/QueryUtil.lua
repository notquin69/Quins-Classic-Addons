-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local QueryUtil = TSM.Auction:NewPackage("QueryUtil")
local AuctionCountDatabase = TSMAPI_FOUR.Class.DefineClass("AuctionCountDatabase")
local private = {
	db = nil,
	itemListByClass = {},
}
local MAX_SCAN_DATA_AGE = 24 * 60 * 60
local MAX_ITEM_INFO_RETRIES = 30
local MAX_MISSING_ITEM_DATA = 20



-- ============================================================================
-- Module Functions
-- ============================================================================

function QueryUtil.OnInitialize()
	private.db = AuctionCountDatabase()
end

function QueryUtil.GenerateThreaded(itemList, callback)
	return private.GenerateQueriesThread(itemList, callback)
end



-- ============================================================================
-- AuctionCountDatabase Class
-- ============================================================================

function AuctionCountDatabase.__init(self)
	self._itemStrings = {}
	self._numAuctions = {}
	self._isComplete = false
end

function AuctionCountDatabase.PopulateDataThreaded(self)
	if self._isComplete then
		return true
	end
	if self.lastPopulateAttempt == time() then
		return
	end
	if (TSM.AuctionDB.GetLastCompleteScanTime() or 0) < time() - MAX_SCAN_DATA_AGE then
		TSM:LOG_WARN("Scan data too old to optimize searches")
		return
	end
	self.lastPopulateAttempt = time()
	self._isComplete = false
	wipe(self._itemStrings)
	wipe(self._numAuctions)
	local orderValueItem = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
	local orderValueCount = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
	local numMissing = 0
	for _, itemString, numAuctions in TSM.AuctionDB.LastScanIteratorThreaded() do
		local quality = TSMAPI_FOUR.Item.GetQuality(itemString)
		local level = TSMAPI_FOUR.Item.GetMinLevel(itemString)
		local classId = TSMAPI_FOUR.Item.GetClassId(itemString)
		if quality and level and classId then
			assert(quality < 10 and level < 200)
			local orderValue = (classId * 10 + quality) * 200 + level
			orderValueCount[orderValue] = (orderValueCount[orderValue] or 0) + 1
			local count = orderValueCount[orderValue]
			assert(count < 10000)
			orderValue = orderValue * 10000 + count
			assert(not orderValueItem[orderValue])
			orderValueItem[orderValue] = itemString
			self._numAuctions[itemString] = numAuctions
		else
			numMissing = numMissing + 1
		end
		TSMAPI_FOUR.Thread.Yield()
	end
	if numMissing > 0 then
		TSM:LOG_ERR("Missing %d items worth of data!", numMissing)
	end
	-- allow for some items to be missing data
	self._isComplete = numMissing < MAX_MISSING_ITEM_DATA
	if self._isComplete then
		-- pretty roundabout way of sorting to avoid "script ran too long" errors from a long sort() call
		local orderValueList = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
		wipe(orderValueList)
		for orderValue in pairs(orderValueItem) do
			tinsert(orderValueList, orderValue)
		end
		TSMAPI_FOUR.Thread.Yield(true)
		sort(orderValueList)
		TSMAPI_FOUR.Thread.Yield(true)
		assert(#self._itemStrings == 0)
		for _, orderValue in ipairs(orderValueList) do
			tinsert(self._itemStrings, orderValueItem[orderValue])
		end
		TSMAPI_FOUR.Thread.ReleaseSafeTempTable(orderValueList)
	end
	TSMAPI_FOUR.Thread.ReleaseSafeTempTable(orderValueItem)
	return self._isComplete
end

function AuctionCountDatabase._CompareFunc(self, itemString, queryClass)
	local class = TSMAPI_FOUR.Item.GetClassId(itemString) or -1
	return class == queryClass and 0 or (class - queryClass)
end

function AuctionCountDatabase.GetItemNumAuctions(self, itemString)
	itemString = TSMAPI_FOUR.Item.FilterItemString(itemString)
	return self._numAuctions[itemString] or 0
end

function AuctionCountDatabase.GetQueryNumPages(self, queryClass, queryMinLevel, queryMaxLevel, queryQuality)
	assert(queryClass)
	queryMinLevel = max(queryMinLevel or 0, 0)
	queryMaxLevel = queryMaxLevel and queryMaxLevel >= 1 and queryMaxLevel or math.huge
	queryQuality = queryQuality or 0
	local count = 0
	local startIndex = 1

	-- binary search for starting index
	local low, high = 1, #self._itemStrings
	while low <= high do
		local mid = floor((low + high) / 2)
		local cmpValue = self:_CompareFunc(self._itemStrings[mid], queryClass)
		if cmpValue == 0 then
			if mid == 1 or self:_CompareFunc(self._itemStrings[mid-1], queryClass) ~= 0 then
				-- we've found the row we want
				startIndex = mid
				break
			else
				-- we're too high
				high = mid - 1
			end
		elseif cmpValue < 0 then
			-- we're too low
			low = mid + 1
		else
			-- we're too high
			high = mid - 1
		end
	end

	for i = startIndex, #self._itemStrings do
		local itemString = self._itemStrings[i]
		local quality = TSMAPI_FOUR.Item.GetQuality(itemString)
		local class = TSMAPI_FOUR.Item.GetClassId(itemString)
		local level = TSMAPI_FOUR.Item.GetMinLevel(itemString)
		if self:_CompareFunc(itemString, class) ~= 0 then
			break
		end
		if quality >= queryQuality and class == queryClass and level >= queryMinLevel and level <= queryMaxLevel then
			count = count + self:GetItemNumAuctions(itemString)
		end
	end
	return private.NumAuctionsToNumPages(count)
end



-- ============================================================================
-- Main Generate Queries Thread
-- ============================================================================

function private.GenerateQueriesThread(itemList, callback)

	-- get all the item info into the game's cache
	for _ = 1, MAX_ITEM_INFO_RETRIES do
		local isMissingItemInfo = false
		for _, itemString in ipairs(itemList) do
			if not private.HasInfo(itemString) then
				isMissingItemInfo = true
			end
			TSMAPI_FOUR.Thread.Yield()
		end
		if not isMissingItemInfo then
			break
		end
		TSMAPI_FOUR.Thread.Sleep(0.1)
	end

	-- remove items we're missing info for
	for i = #itemList, 1, -1 do
		if not private.HasInfo(itemList[i]) then
			TSM:LOG_ERR("Missing item info for %s", itemList[i])
			tremove(itemList, i)
		end
		TSMAPI_FOUR.Thread.Yield()
	end

	if #itemList <= 1 then
		-- short-circuit for searching for a single or no items
		for _, itemString in ipairs(itemList) do
			callback(itemString, private.GetItemQueryInfo(itemString))
		end
		return
	end

	local dbComplete = false
	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		dbComplete = private.db:PopulateDataThreaded()
		TSMAPI_FOUR.Thread.Yield()
		if not dbComplete then
			TSM:LOG_ERR("Auction count database not complete")
		end
	end

	-- if the DB is not fully populated (or we're on classic), we don't have all the item info, just do individual scans
	if not dbComplete then
		for _, itemString in ipairs(itemList) do
			callback(itemString, private.GetItemQueryInfo(itemString))
		end
		return
	end
	TSMAPI_FOUR.Thread.Yield()

	-- organize by class
	for _, tbl in pairs(private.itemListByClass) do
		wipe(tbl)
	end
	for _, itemString in ipairs(itemList) do
		local classId = TSMAPI_FOUR.Item.GetClassId(itemString)
		if classId and classId ~= LE_ITEM_CLASS_BATTLEPET then
			private.itemListByClass[classId] = private.itemListByClass[classId] or {}
			tinsert(private.itemListByClass[classId], itemString)
		else
			assert(private.HasInfo(itemString), "Invalid item info for "..tostring(itemString))
			callback(itemString, private.GetItemQueryInfo(itemString))
		end
		TSMAPI_FOUR.Thread.Yield()
	end
	for classId, items in pairs(private.itemListByClass) do
		if #items > 0 then
			local totalPagesRaw = 0
			local totalPagesClass = 0
			-- calculate the number of pages if we scan items individually
			for _, itemString in ipairs(items) do
				totalPagesRaw = totalPagesRaw + private.NumAuctionsToNumPages(private.db:GetItemNumAuctions(itemString))
				TSMAPI_FOUR.Thread.Yield()
			end
			local classMinQuality, classMinLevel, classMaxLevel = nil, nil, nil
			if totalPagesRaw > 0 then
				-- calulate the number of pages if we group by class
				classMinQuality, classMinLevel, classMaxLevel = private.GetCommonInfo(items)
				totalPagesClass = private.db:GetQueryNumPages(classId, classMinLevel, classMaxLevel, classMinQuality)
			end
			totalPagesRaw = totalPagesRaw > 0 and totalPagesRaw or math.huge
			totalPagesClass = totalPagesClass > 0 and totalPagesClass or math.huge

			TSM:LOG_INFO("Scanning %d items by class (%d) would be %d pages instead of %d", #items, classId, totalPagesClass, totalPagesRaw)
			if totalPagesClass < totalPagesRaw then
				TSM:LOG_INFO("Should group by class")
				-- attempt to find a common name to filter by
				local name = private.GetCommonName(items)
				if name then
					TSM:LOG_INFO("Should group by filter: %s", name)
				else
					name = ""
				end
				callback(items, name, classMinLevel, classMaxLevel, classMinQuality, classId, nil)
				TSMAPI_FOUR.Thread.Yield()
			else
				TSM:LOG_INFO("Shouldn't group by anything!")
				for _, itemString in ipairs(items) do
					callback(itemString, private.GetItemQueryInfo(itemString))
				end
			end
			TSMAPI_FOUR.Thread.Yield()
		end
	end
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.GetItemQueryInfo(itemString)
	local name = TSMAPI_FOUR.Item.GetName(itemString)
	local level = TSMAPI_FOUR.Item.GetMinLevel(itemString) or 0
	local quality = TSMAPI_FOUR.Item.GetQuality(itemString)
	local classId = TSMAPI_FOUR.Item.GetClassId(itemString) or 0
	local subClassId = TSMAPI_FOUR.Item.GetSubClassId(itemString) or 0
	-- Ignoring level because level can now vary
	if itemString == TSMAPI_FOUR.Item.ToBaseItemString(itemString) and (classId == LE_ITEM_CLASS_WEAPON or classId == LE_ITEM_CLASS_ARMOR or (classId == LE_ITEM_CLASS_GEM and subClassId == LE_ITEM_GEM_ARTIFACTRELIC)) then
		level = 0
	end
	return name, level, level, quality, classId, subClassId
end

function private.NumAuctionsToNumPages(num)
	return max(ceil(num / NUM_AUCTION_ITEMS_PER_PAGE), 1)
end

function private.GetCommonInfo(items)
	local minQuality, minLevel, maxLevel = nil, nil, nil
	local filterLevel = true
	for _, itemString in ipairs(items) do
		local _, level, _, quality = private.GetItemQueryInfo(itemString)
		if level == 0 then
			filterLevel = false
		end
		minQuality = min(minQuality or quality, quality)
		minLevel = min(minLevel or level, level)
		maxLevel = max(maxLevel or level, level)
	end
	return minQuality or 0, filterLevel and minLevel or 0, filterLevel and maxLevel or 0
end

function private.GetCommonName(items)
	-- check if we can also group the query by name
	local nameTemp = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, itemString in ipairs(items) do
		local name = TSMAPI_FOUR.Item.GetName(itemString)
		if not name then
			TSMAPI_FOUR.Util.ReleaseTempTable(nameTemp)
			return
		end
		assert(type(name) == "string", "Unexpected item name: "..tostring(name))
		tinsert(nameTemp, name)
	end
	if #nameTemp ~= #items or #nameTemp < 2 then
		TSMAPI_FOUR.Util.ReleaseTempTable(nameTemp)
		return
	end
	sort(nameTemp)

	-- find common substring with first and last name, and if it's
	-- at least one word long, try and apply it to the rest
	local str1 = nameTemp[1]
	local str2 = nameTemp[#nameTemp]
	local endIndex = 0
	local hasSpace = nil
	for i = 1, min(#str1, #str2) do
		local c = strsub(str1, i, i)
		if c ~= strsub(str2, i, i) then
			break
		elseif c == " " then
			hasSpace = true
		end
		endIndex = i
	end
	-- make sure the common substring has at least one space and is at least 3 characters log
	if not hasSpace or endIndex < 3 then
		TSMAPI_FOUR.Util.ReleaseTempTable(nameTemp)
		return
	end

	local commonStr = strsub(str1, 1, endIndex)
	for _, name in ipairs(nameTemp) do
		if strsub(name, 1, endIndex) ~= commonStr then
			TSMAPI_FOUR.Util.ReleaseTempTable(nameTemp)
			return
		end
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(nameTemp)
	return commonStr
end

function private.HasInfo(itemString)
	return TSMAPI_FOUR.Item.GetName(itemString) and TSMAPI_FOUR.Item.GetQuality(itemString)
end
