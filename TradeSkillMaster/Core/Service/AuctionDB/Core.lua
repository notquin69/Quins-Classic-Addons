-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local AuctionDB = TSM:NewPackage("AuctionDB")
local L = TSM.L
local private = {
	region = nil,
	realmData = {},
	regionData = nil,
	realmScanTime = nil,
	hasAppRealmData = false,
	scanDB = nil,
	scanThreadId = nil,
	ahOpen = false,
	marketValueDB = nil,
	marketValueQuery = nil,
	didScan = false,
}
local CSV_KEYS = { "itemString", "minBuyout", "marketValue", "numAuctions", "quantity", "lastScan" }



-- ============================================================================
-- Module Functions
-- ============================================================================

function AuctionDB.OnInitialize()
	private.scanThreadId = TSMAPI_FOUR.Thread.New("AUCTIONDB_SCAN", private.ScanThread)
	private.scanDB = TSMAPI_FOUR.Database.NewSchema("AUCTIONDB_SCAN")
		:AddStringField("itemString")
		:AddNumberField("stackSize")
		:AddNumberField("itemBuyout")
		:AddIndex("itemString")
		:Commit()
	private.marketValueDB = TSMAPI_FOUR.Database.NewSchema("AUCTIONDB_MARKET_VALUE")
		:AddStringField("itemString")
		:AddNumberField("itemBuyout")
		:AddNumberField("index")
		:AddIndex("itemString")
		:AddIndex("index")
		:Commit()
	private.marketValueQuery = private.marketValueDB:NewQuery()
		:Equal("itemString", TSM.CONST.BOUND_QUERY_PARAM)
		:GreaterThanOrEqual("index", TSM.CONST.BOUND_QUERY_PARAM)
		:LessThanOrEqual("index", TSM.CONST.BOUND_QUERY_PARAM)
		:GreaterThanOrEqual("itemBuyout", TSM.CONST.BOUND_QUERY_PARAM)
		:LessThanOrEqual("itemBuyout", TSM.CONST.BOUND_QUERY_PARAM)
		:Select("itemBuyout")
		:OrderBy("index", true)
	TSMAPI_FOUR.Event.Register("AUCTION_HOUSE_SHOW", private.OnAuctionHouseShow)
	TSMAPI_FOUR.Event.Register("AUCTION_HOUSE_CLOSED", private.OnAuctionHouseClosed)
end

function AuctionDB.OnEnable()
	private.region = TSM.GetRegion()

	local realmAppData = nil
	local appData = TSMAPI.AppHelper and TSMAPI.AppHelper:FetchData("AUCTIONDB_MARKET_DATA") -- get app data from TSM_AppHelper if it's installed
	if appData then
		for _, info in ipairs(appData) do
			local realm, data = unpack(info)
			local downloadTime = "?"
			if realm == private.region then
				local regionData, lastUpdate = private.LoadRegionAppData(data)
				if regionData then
					private.regionData = regionData
					downloadTime = SecondsToTime(time() - lastUpdate).." ago"
				end
			elseif TSMAPI.AppHelper:IsCurrentRealm(realm) then
				realmAppData = private.ProcessRealmAppData(data)
				downloadTime = SecondsToTime(time() - realmAppData.downloadTime).." ago"
			end
			TSM:LOG_INFO("Got AppData for %s (isCurrent=%s, %s)", realm, tostring(TSMAPI.AppHelper:IsCurrentRealm(realm)), downloadTime)
		end
	end

	-- check if we can load realm data from the app
	if realmAppData then
		private.hasAppRealmData = true
		private.realmScanTime = realmAppData.downloadTime
		local fields = realmAppData.fields
		for _, data in ipairs(realmAppData.data) do
			local itemString
			for i, key in ipairs(fields) do
				if i == 1 then
					-- item string must be the first field
					if type(data[i]) == "number" then
						itemString = "i:"..data[i]
					else
						itemString = gsub(data[i], ":0:", "::")
					end
					private.realmData[itemString] = {}
				else
					private.realmData[itemString][key] = data[i]
				end
			end
			private.realmData[itemString].lastScan = realmAppData.downloadTime
		end
	end

	for itemString in pairs(private.realmData) do
		TSMAPI_FOUR.Item.FetchInfo(itemString)
	end
	if not next(private.realmData) and TSM.db.factionrealm.internalData.auctionDBScanTime > 0 then
		private.LoadSVRealmData()
	end
	if not next(private.realmData) then
		TSM:Print(L["TSM doesn't currently have any AuctionDB pricing data for your realm. We recommend you download the TSM Desktop Application from |cff99ffffhttp://tradeskillmaster.com|r to automatically update your AuctionDB data (and auto-backup your TSM settings)."])
	end
	collectgarbage()
end

function AuctionDB.OnDisable()
	if not private.didScan or private.hasAppRealmData then
		return
	end

	local encodeContext = TSMAPI_FOUR.CSV.EncodeStart(CSV_KEYS)
	for itemString, data in pairs(private.realmData) do
		TSMAPI_FOUR.CSV.EncodeAddRowDataRaw(encodeContext, itemString, data.minBuyout, data.marketValue, data.numAuctions, data.quantity, data.lastScan)
	end
	TSMAPI_FOUR.CSV.EncodeSortLines(encodeContext)
	TSM.db.factionrealm.internalData.csvAuctionDBScan = TSMAPI_FOUR.CSV.EncodeEnd(encodeContext)
	TSM.db.factionrealm.internalData.auctionDBScanHash = TSMAPI_FOUR.Util.CalculateHash(TSM.db.factionrealm.internalData.csvAuctionDBScan)
end

function AuctionDB.GetLastCompleteScanTime()
	return private.realmScanTime
end

function AuctionDB.LastScanIteratorThreaded()
	local itemNumAuctions = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
	local itemMinBuyout = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
	local baseItems = TSMAPI_FOUR.Thread.AcquireSafeTempTable()

	for itemString, data in pairs(private.realmData) do
		if data.lastScan >= private.realmScanTime then
			itemString = TSMAPI_FOUR.Item.ToItemString(itemString)
			local baseItemString = TSMAPI_FOUR.Item.ToBaseItemString(itemString)
			if baseItemString ~= itemString then
				baseItems[baseItemString] = true
			end
			if not itemNumAuctions[itemString] then
				itemNumAuctions[itemString] = 0
			end
			itemNumAuctions[itemString] = itemNumAuctions[itemString] + data.numAuctions
			if data.minBuyout and data.minBuyout > 0 then
				itemMinBuyout[itemString] = min(itemMinBuyout[itemString] or math.huge, data.minBuyout)
			end
		end
		TSMAPI_FOUR.Thread.Yield()
	end

	-- remove the base items since they would be double-counted with the specific variants
	for itemString in pairs(baseItems) do
		itemNumAuctions[itemString] = nil
		itemMinBuyout[itemString] = nil
	end
	TSMAPI_FOUR.Thread.ReleaseSafeTempTable(baseItems)

	-- convert the remaining items into a list
	local itemList = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
	itemList.numAuctions = itemNumAuctions
	itemList.minBuyout = itemMinBuyout
	for itemString in pairs(itemNumAuctions) do
		tinsert(itemList, itemString)
	end
	return TSMAPI_FOUR.Util.TableIterator(itemList, private.LastScanIteratorHelper, itemList, private.LastScanIteratorCleanup)
end

function AuctionDB.GetRealmItemData(itemString, key)
	return private.GetItemDataHelper(private.realmData, key, itemString)
end

function AuctionDB.GetRegionItemData(itemString, key)
	return private.GetRegionItemDataHelper(private.regionData, key, itemString)
end

function AuctionDB.GetRegionSaleInfo(itemString, key)
	-- need to divide the result by 100
	local result = private.GetRegionItemDataHelper(private.regionData, key, itemString)
	return result and (result / 100) or nil
end

function AuctionDB.RunScan()
	if private.hasAppRealmData then
		TSM:Print(L["ERROR: Realm data is already available from the TSM Desktop App."])
	elseif not private.ahOpen then
		TSM:Print(L["ERROR: The auction house must be open in order to do a scan."])
		return
	end
	local canScan, canGetAllScan = CanSendAuctionQuery()
	if not canScan then
		TSM:Print(L["ERROR: The AH is currently busy with another scan. Please try again once that scan has completed."])
		return
	elseif not canGetAllScan then
		TSM:Print(L["ERROR: A full AH scan has recently been performed and is on cooldown. Log out to reset this cooldown."])
		return
	end
	TSM:Print(L["Starting full AH scan. Please note that this scan may cause your game client to lag or crash."])
	TSMAPI_FOUR.Thread.Start(private.scanThreadId)
end



-- ============================================================================
-- Scan Thread
-- ============================================================================

function private.ScanThread()
	private.scanDB:Truncate()
	if not private.DoScanThreaded() then
		TSM:Printf(L["Failed to scan the AH. Please try again."])
		return
	end

	TSM:Printf(L["Processing scan results..."])
	wipe(private.realmData)
	for _, data in pairs(private.realmData) do
		data.minBuyout = 0
		data.numAuctions = 0
		data.quantity = 0
	end
	local scannedItems = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
	private.realmScanTime = time()
	TSM.db.factionrealm.internalData.auctionDBScanTime = time()
	private.marketValueDB:TruncateAndBulkInsertStart()
	local scanQuery = private.scanDB:NewQuery()
		:Select("itemString", "stackSize", "itemBuyout")
		:OrderBy("itemBuyout", true)
	for _, itemString, stackSize, itemBuyout in scanQuery:Iterator() do
		private.ProcessScanResultItem(itemString, itemBuyout, stackSize)
		scannedItems[itemString] = true
	end
	scanQuery:Release()
	local numScannedAuctions = private.scanDB:GetNumRows()
	private.scanDB:Truncate()
	private.marketValueDB:BulkInsertEnd()
	TSMAPI_FOUR.Thread.Yield()

	for itemString in pairs(scannedItems) do
		local data = private.realmData[itemString]
		data.marketValue = private.CalculateItemMarketValue(itemString, data.quantity)
		assert(data.minBuyout == 0 or data.marketValue >= data.minBuyout)
		TSMAPI_FOUR.Thread.Yield()
	end
	private.marketValueDB:Truncate()
	TSMAPI_FOUR.Thread.ReleaseSafeTempTable(scannedItems)

	collectgarbage()
	TSM:Printf(L["Completed full AH scan (%d auctions)!"], numScannedAuctions)
	private.didScan = true
end

function private.DoScanThreaded()
	-- wait for the AH to be ready
	TSMAPI_FOUR.Thread.WaitForFunction(CanSendAuctionQuery)
	if not select(2, CanSendAuctionQuery()) or not private.ahOpen then
		-- can't do a getall scan right now
		TSM:LOG_ERR("AH closed or can't do GetAll")
		return false
	end
	-- query the AH
	QueryAuctionItems(nil, nil, nil, 0, nil, nil, true)
	-- wait for the update event
	TSMAPI_FOUR.Thread.WaitForEvent("AUCTION_ITEM_LIST_UPDATE")
	-- wait a bit for things to settle
	local settleStartTime = GetTime()
	while not CanSendAuctionQuery() do
		if not private.ahOpen then
			TSM:LOG_ERR("AH closed")
			return false
		end
		TSMAPI_FOUR.Thread.Yield(true)
	end
	TSM:LOG_INFO("Took %d seconds for AH to settle", GetTime() - settleStartTime)

	local startTime = GetTime()
	local lastSuccessTime = GetTime()
	local lastProgressTime = GetTime()
	local index = 1
	while true do
		local numAuctions, totalAuctions = GetNumAuctionItems("list")
		TSM:LOG_INFO("Scanning %d/%d", index, numAuctions)
		if totalAuctions <= NUM_AUCTION_ITEMS_PER_PAGE or numAuctions ~= totalAuctions then
			-- we're no longer on the getall results
			TSM:LOG_ERR("Switched off GetAll results")
			return false
		end
		local maxIndex = min(numAuctions, index + NUM_AUCTION_ITEMS_PER_PAGE)
		private.scanDB:BulkInsertStart()
		while index <= maxIndex do
			local _, _, stackSize, _, _, _, _, _, _, buyout, _, _, _, _, _, _, itemId = GetAuctionItemInfo("list", index)
			if stackSize and buyout and itemId then
				local itemBuyout = (buyout > 0) and floor(buyout / stackSize) or 0
				private.scanDB:BulkInsertNewRow("i:"..itemId, stackSize, itemBuyout)
				index = index + 1
				lastSuccessTime = GetTime()
			else
				break
			end
		end
		private.scanDB:BulkInsertEnd()
		if index > numAuctions then
			return true
		elseif GetTime() > startTime + 300 then
			TSM:LOG_ERR("Timed out on entire scan")
			return false
		elseif GetTime() > lastSuccessTime + 30 then
			TSM:LOG_ERR("Timed out on index (%d)", index)
			return false
		end
		if GetTime() > lastProgressTime + 1 then
			TSM:Printf(L["Scan progress: %d%%"], TSMAPI_FOUR.Util.Round(index * 100 / numAuctions))
			lastProgressTime = GetTime()
		end
		TSMAPI_FOUR.Thread.Yield(true)
	end
end

function private.ProcessScanResultItem(itemString, itemBuyout, stackSize)
	private.realmData[itemString] = private.realmData[itemString] or { numAuctions = 0, quantity = 0, minBuyout = 0 }
	local data = private.realmData[itemString]
	data.lastScan = time()
	if itemBuyout > 0 then
		data.minBuyout = min(data.minBuyout > 0 and data.minBuyout or math.huge, itemBuyout)
		for _ = 1, stackSize do
			data.quantity = data.quantity + 1
			private.marketValueDB:BulkInsertNewRow(itemString, itemBuyout, data.quantity)
		end
	end
	data.numAuctions = data.numAuctions + 1
end

function private.CalculateItemMarketValue(itemString, quantity)
	if quantity == 0 then
		return 0
	end

	-- calculate the average of the lowest 15-30% of auctions
	local total, num = 0, 0
	local lowBucketNum = max(floor(quantity * 0.15), 1)
	local midBucketNum = max(floor(quantity * 0.30), 1)
	local prevItemBuyout = 0
	private.marketValueQuery:BindParams(itemString, 1, midBucketNum, 0, math.huge)
	for _, itemBuyout in private.marketValueQuery:Iterator() do
		if num < lowBucketNum or itemBuyout < prevItemBuyout * 1.2 then
			num = num + 1
			total = total + itemBuyout
		end
		prevItemBuyout = itemBuyout
	end
	local avg = total / num

	-- calculate the stdev of the auctions we used in the average
	local stdev = nil
	if num > 1 then
		local stdevSum = 0
		private.marketValueQuery:BindParams(itemString, 1, num, 0, math.huge)
		for _, itemBuyout in private.marketValueQuery:Iterator() do
			stdevSum = stdevSum + (itemBuyout - avg) ^ 2
		end
		stdev = sqrt(stdevSum / (num - 1))
	else
		stdev = 0
	end

	-- calculate the market value as the average of all data within 1.5 stdev of our previous average
	private.marketValueQuery:BindParams(itemString, 1, num, avg - stdev * 1.5, avg + stdev * 1.5)
	return private.marketValueQuery:Avg("itemBuyout")
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.LoadSVRealmData()
	local decodeContext = TSMAPI_FOUR.CSV.DecodeStart(TSM.db.factionrealm.internalData.csvAuctionDBScan, CSV_KEYS)
	if not decodeContext then
		TSM:LOG_ERR("Failed to decode records")
		return
	end
	for itemString, minBuyout, marketValue, numAuctions, quantity, lastScan in TSMAPI_FOUR.CSV.DecodeIterator(decodeContext) do
		private.realmData[itemString] = {
			minBuyout = tonumber(minBuyout),
			marketValue = tonumber(marketValue),
			numAuctions = tonumber(numAuctions),
			quantity = tonumber(quantity),
			lastScan = tonumber(lastScan),
		}
	end
	if not TSMAPI_FOUR.CSV.DecodeEnd(decodeContext) then
		TSM:LOG_ERR("Failed to decode records")
	end
	private.realmScanTime = TSM.db.factionrealm.internalData.auctionDBScanTime
end

function private.ProcessRealmAppData(rawData)
	if #rawData < 3500000 then
		-- we can safely just use loadstring() for strings below 3.5M
		return assert(loadstring(rawData)())
	end
	-- load the data in chunks
	local leader, itemData, trailer = strmatch(rawData, "^(.+)data={({.+})}(.+)$")
	local resultData = {}
	local chunkStart, chunkEnd, nextChunkStart = 1, nil, nil
	while chunkStart do
		chunkEnd, nextChunkStart = strfind(itemData, "},{", chunkStart + 3400000)
		local chunkData = assert(loadstring("return {"..strsub(itemData, chunkStart, chunkEnd).."}")())
		for _, data in ipairs(chunkData) do
			tinsert(resultData, data)
		end
		chunkStart = nextChunkStart
	end
	__AUCTIONDB_IMPORT_TEMP = resultData
	local result = assert(loadstring(leader.."data=__AUCTIONDB_IMPORT_TEMP"..trailer)())
	__AUCTIONDB_IMPORT_TEMP = nil
	return result
end

function private.LoadRegionAppData(appData)
	local metaDataEndIndex, dataStartIndex = strfind(appData, ",data={")
	local itemData = strsub(appData, dataStartIndex + 1, -3)
	local metaDataStr = strsub(appData, 1, metaDataEndIndex - 1).."}"
	local metaData = assert(loadstring(metaDataStr))()
	local result = { fieldLookup = {}, itemLookup = {} }
	for i, field in ipairs(metaData.fields) do
		result.fieldLookup[field] = i
	end

	for itemString, otherData in gmatch(itemData, "{([^,]+),([^}]+)}") do
		if tonumber(itemString) then
			itemString = "i:"..itemString
		else
			itemString = gsub(strsub(itemString, 2, -2), ":0:", "::")
		end
		result.itemLookup[itemString] = otherData
	end

	return result, metaData.downloadTime
end

function private.LastScanIteratorHelper(index, itemString, tbl)
	return index, itemString, tbl.numAuctions[itemString], tbl.minBuyout[itemString]
end

function private.LastScanIteratorCleanup(tbl)
	TSMAPI_FOUR.Thread.ReleaseSafeTempTable(tbl.numAuctions)
	TSMAPI_FOUR.Thread.ReleaseSafeTempTable(tbl.minBuyout)
	TSMAPI_FOUR.Thread.ReleaseSafeTempTable(tbl)
end

function private.GetItemDataHelper(tbl, key, itemString)
	if not itemString or not tbl then return end
	itemString = TSMAPI_FOUR.Item.FilterItemString(itemString)
	local value = nil
	if tbl[itemString] then
		value = tbl[itemString][key]
	else
		local quality = TSMAPI_FOUR.Item.GetQuality(itemString)
		local itemLevel = TSMAPI_FOUR.Item.GetItemLevel(itemString)
		local classId = TSMAPI_FOUR.Item.GetClassId(itemString)
		if quality and quality >= 2 and itemLevel and itemLevel >= TSM.CONST.MIN_BONUS_ID_ITEM_LEVEL and (classId == LE_ITEM_CLASS_WEAPON or classId == LE_ITEM_CLASS_ARMOR) then
			if strmatch(itemString, "^i:[0-9]+:[0-9%-]*:") then return end
		end
		local baseItemString = TSMAPI_FOUR.Item.ToBaseItemString(itemString)
		if not baseItemString then return end
		value = tbl[baseItemString] and tbl[baseItemString][key]
	end
	if not value or value <= 0 then return end
	return value
end

function private.GetRegionItemDataHelper(tbl, key, itemString)
	if not itemString or not tbl then
		return
	end
	itemString = TSMAPI_FOUR.Item.FilterItemString(itemString)
	local fieldIndex = tbl.fieldLookup[key] - 1
	assert(fieldIndex and fieldIndex > 0)
	local data = tbl.itemLookup[itemString]
	if not data and not strmatch(itemString, "^[ip]:[0-9]+$") then
		-- for items with random enchants or for pets, get data for the base item
		local quality = TSMAPI_FOUR.Item.GetQuality(itemString)
		local itemLevel = TSMAPI_FOUR.Item.GetItemLevel(itemString)
		local classId = TSMAPI_FOUR.Item.GetClassId(itemString)
		if quality and quality >= 2 and itemLevel and itemLevel >= TSM.CONST.MIN_BONUS_ID_ITEM_LEVEL and (classId == LE_ITEM_CLASS_WEAPON or classId == LE_ITEM_CLASS_ARMOR) then
			if strmatch(itemString, "^i:[0-9]+:[0-9%-]*:") then
				return
			end
		end
		itemString = TSMAPI_FOUR.Item.ToBaseItemString(itemString)
		if not itemString then return end
		data = tbl.itemLookup[itemString]
	end
	if not data then
		return
	end
	if type(data) == "string" then
		local tblData = {strsplit(",", data)}
		for i = 1, #tblData do
			tblData[i] = tonumber(tblData[i])
		end
		tbl.itemLookup[itemString] = tblData
		data = tblData
	end
	local value = data[fieldIndex]
	if not value or value <= 0 then
		return
	end
	return value
end

function private.OnAuctionHouseShow()
	private.ahOpen = true
	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC or not select(2, CanSendAuctionQuery()) then
		return
	elseif private.hasAppRealmData or (private.realmScanTime or 0) > time() - 60 * 60 * 24 then
		return
	end
	StaticPopupDialogs["TSM_AUCTIONDB_SCAN"] = StaticPopupDialogs["TSM_AUCTIONDB_SCAN"] or {
		text = L["TSM does not have recent AuctionDB data. You can run '/tsm scan' to manually scan the AH."],
		button1 = OKAY,
		timeout = 0,
		whileDead = true,
	}
	TSMAPI_FOUR.Util.ShowStaticPopupDialog("TSM_AUCTIONDB_SCAN")
end

function private.OnAuctionHouseClosed()
	private.ahOpen = false
end
