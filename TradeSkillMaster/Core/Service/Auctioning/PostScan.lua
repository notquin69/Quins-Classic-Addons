-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local PostScan = TSM.Auctioning:NewPackage("PostScan")
local L = TSM.L
local private = {
	scanThreadId = nil,
	queueDB = nil,
	nextQueueIndex = 1,
	bagDB = nil,
	auctionScanDB = nil,
	itemList = {},
	operationDB = nil,
	debugLog = {},
}
local RESET_REASON_LOOKUP = {
	minPrice = "postResetMin",
	maxPrice = "postResetMax",
	normalPrice = "postResetNormal"
}
local ABOVE_MAX_REASON_LOOKUP = {
	minPrice = "postAboveMaxMin",
	maxPrice = "postAboveMaxMax",
	normalPrice = "postAboveMaxNormal",
	none = "postAboveMaxNoPost"
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function PostScan.OnInitialize()
	TSM.Inventory.BagTracking.RegisterCallback(private.UpdateOperationDB)
	private.operationDB = TSMAPI_FOUR.Database.NewSchema("AUCTIONING_OPERATIONS")
		:AddUniqueStringField("autoBaseItemString")
		:AddStringField("firstOperation")
		:Commit()
	private.scanThreadId = TSMAPI_FOUR.Thread.New("POST_SCAN", private.ScanThread)
	private.queueDB = TSMAPI_FOUR.Database.NewSchema("AUCTIONING_POST_QUEUE")
		:AddNumberField("index")
		:AddStringField("itemString")
		:AddStringField("operationName")
		:AddNumberField("bid")
		:AddNumberField("buyout")
		:AddNumberField("itemBuyout")
		:AddNumberField("stackSize")
		:AddNumberField("numStacks")
		:AddNumberField("postTime")
		:AddNumberField("numProcessed")
		:AddNumberField("numConfirmed")
		:AddNumberField("numFailed")
		:AddIndex("index")
		:AddIndex("itemString")
		:Commit()
	-- We maintain our own bag database rather than using the one in BagTracking since we need to be able to remove items
	-- as they are posted, without waiting for bag update events, and control when our DB updates.
	private.bagDB = TSMAPI_FOUR.Database.NewSchema("AUCTIONING_POST_BAGS")
		:AddStringField("itemString")
		:AddNumberField("bag")
		:AddNumberField("slot")
		:AddNumberField("quantity")
		:AddUniqueNumberField("slotId")
		:AddIndex("itemString")
		:AddIndex("slotId")
		:Commit()
end

function private.UpdateOperationDB()
	local used = TSMAPI_FOUR.Util.AcquireTempTable()
	private.operationDB:TruncateAndBulkInsertStart()
	for _, _, _, itemString in TSMAPI_FOUR.Inventory.BagIterator(true, false, false, true) do
		if not used[itemString] then
			used[itemString] = true
			local firstOperation = TSM.Operations.GetFirstOperationByItem("Auctioning", itemString)
			if firstOperation then
				private.operationDB:BulkInsertNewRow(itemString, firstOperation)
			end
		end
	end
	private.operationDB:BulkInsertEnd()
	TSMAPI_FOUR.Util.ReleaseTempTable(used)
end

function PostScan.CreateBagsQuery()
	return TSM.Inventory.BagTracking.CreateQuery()
		:GreaterThanOrEqual("bag", 0)
		:LessThanOrEqual("bag", NUM_BAG_SLOTS)
		:Equal("isBoP", false)
		:Equal("isBoA", false)
		:Equal("usedCharges", false)
		:Distinct("autoBaseItemString")
		:LeftJoin(private.operationDB, "autoBaseItemString")
		:InnerJoin(TSM.ItemInfo.GetDBForJoin(), "itemString")
		:OrderBy("name", true)
end

function PostScan.Prepare()
	return private.scanThreadId
end

function PostScan.GetCurrentRow()
	return private.queueDB:NewQuery()
		:Custom(private.NextProcessRowQueryHelper)
		:OrderBy("index", true)
		:GetFirstResultAndRelease()
end

function PostScan.GetStatus()
	return TSM.Auctioning.Util.GetQueueStatus(private.queueDB:NewQuery())
end

function PostScan.DoProcess()
	local success, noRetry = nil, false
	local postRow = PostScan.GetCurrentRow()
	local itemString, stackSize, bid, buyout, postTime = postRow:GetFields("itemString", "stackSize", "bid", "buyout", "postTime")
	local bag, slot = private.GetPostBagSlot(itemString, stackSize)
	if bag then
		-- need to set the duration in the default UI to avoid Blizzard errors
		AuctionFrameAuctions.duration = postTime
		ClearCursor()
		PickupContainerItem(bag, slot)
		ClickAuctionSellItemButton(AuctionsItemButton, "LeftButton")
		PostAuction(bid, buyout, postTime, stackSize, 1)
		ClearCursor()
		local _, bagQuantity = GetContainerItemInfo(bag, slot)
		TSM:LOG_INFO("Posting %s x %d from %d,%d (%d)", itemString, stackSize, bag, slot, bagQuantity or -1)
		private.DebugLogInsert(itemString, "Posting %d from %d, %d", stackSize, bag, slot)
		success = true
	else
		-- we couldn't find this item, so mark this post as failed and we'll try again later
		success = false
		noRetry = slot
		if noRetry then
			TSM:Printf(L["Failed to post %sx%d as the item no longer exists in your bags."], TSMAPI_FOUR.Item.GetLink(itemString), stackSize)
		end
	end
	postRow:SetField("numProcessed", postRow:GetField("numProcessed") + 1)
		:Update()
	postRow:Release()
	return success, noRetry
end

function PostScan.DoSkip()
	local postRow = PostScan.GetCurrentRow()
	local numStacks = postRow:GetField("numStacks")
	postRow:SetField("numProcessed", numStacks)
		:SetField("numConfirmed", numStacks)
		:Update()
	postRow:Release()
end

function PostScan.HandleConfirm(success, canRetry)
	if not success then
		ClearCursor()
	end

	local confirmRow = private.queueDB:NewQuery()
		:Custom(private.ConfirmRowQueryHelper)
		:OrderBy("index", true)
		:GetFirstResultAndRelease()
	if not confirmRow then
		-- we may have posted something outside of TSM
		return
	end

	private.DebugLogInsert(confirmRow:GetField("itemString"), "HandleConfirm(success=%s) x %d", tostring(success), confirmRow:GetField("stackSize"))
	if canRetry then
		confirmRow:SetField("numFailed", confirmRow:GetField("numFailed") + 1)
	end
	confirmRow:SetField("numConfirmed", confirmRow:GetField("numConfirmed") + 1)
		:Update()
	confirmRow:Release()
end

function PostScan.PrepareFailedPosts()
	private.queueDB:SetQueryUpdatesPaused(true)
	local query = private.queueDB:NewQuery()
		:GreaterThan("numFailed", 0)
		:OrderBy("index", true)
	for _, row in query:Iterator() do
		local numFailed, numProcessed, numConfirmed = row:GetFields("numFailed", "numProcessed", "numConfirmed")
		assert(numProcessed >= numFailed and numConfirmed >= numFailed)
		private.DebugLogInsert(row:GetField("itemString"), "Preparing failed (%d, %d, %d)", numFailed, numProcessed, numConfirmed)
		row:SetField("numFailed", 0)
			:SetField("numProcessed", numProcessed - numFailed)
			:SetField("numConfirmed", numConfirmed - numFailed)
			:Update()
	end
	query:Release()
	private.queueDB:SetQueryUpdatesPaused(false)
	private.UpdateBagDB()
end

function PostScan.Reset()
	private.auctionScanDB = nil
	private.queueDB:Truncate()
	private.nextQueueIndex = 1
	private.bagDB:Truncate()
end

function PostScan.ChangePostDetail(field, value)
	local postRow = PostScan.GetCurrentRow()
	if field == "bid" then
		value = min(max(value, 1), postRow:GetField("buyout"))
	end
	postRow:SetField(field, value)
		:Update()
	postRow:Release()
end



-- ============================================================================
-- Scan Thread
-- ============================================================================

function private.ScanThread(auctionScan, auctionScanDB, scanContext)
	wipe(private.debugLog)
	private.auctionScanDB = auctionScanDB
	auctionScan:SetScript("OnFilterPartialDone", private.AuctionScanOnFilterPartialDone)
	auctionScan:SetScript("OnFilterDone", private.AuctionScanOnFilterDone)
	private.UpdateBagDB()

	-- get the state of the player's bags
	local bagCounts = TSMAPI_FOUR.Util.AcquireTempTable()
	local bagQuery = private.bagDB:NewQuery()
		:Select("itemString", "quantity")
	for _, itemString, quantity in bagQuery:Iterator() do
		bagCounts[itemString] = (bagCounts[itemString] or 0) + quantity
	end
	bagQuery:Release()

	-- generate the list of items we want to scan for
	wipe(private.itemList)
	for itemString, numHave in pairs(bagCounts) do
		private.DebugLogInsert(itemString, "Scan thread has %d", numHave)
		local groupPath = TSM.Groups.GetPathByItem(itemString)
		local contextFilter = scanContext.isItems and itemString or groupPath
		if groupPath and tContains(scanContext, contextFilter) and private.CanPostItem(itemString, groupPath, numHave) then
			tinsert(private.itemList, itemString)
		end
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(bagCounts)
	if #private.itemList == 0 then
		return
	end
	-- record this search
	TSM.Auctioning.SavedSearches.RecordSearch(scanContext, scanContext.isItems and "postItems" or "postGroups")

	-- run the scan
	auctionScan:AddItemListFiltersThreaded(private.itemList)
	auctionScan:StartScanThreaded()
end



-- ============================================================================
-- Private Helper Functions for Scanning
-- ============================================================================

function private.UpdateBagDB()
	private.bagDB:TruncateAndBulkInsertStart()
	for _, bag, slot, itemString, quantity in TSMAPI_FOUR.Inventory.BagIterator(true, false, false, true) do
		private.DebugLogInsert(itemString, "Updating bag DB with %d in %d, %d", quantity, bag, slot)
		private.bagDB:BulkInsertNewRow(itemString, bag, slot, quantity, TSMAPI_FOUR.Util.JoinSlotId(bag, slot))
	end
	private.bagDB:BulkInsertEnd()
end

function private.CanPostItem(itemString, groupPath, numHave)
	local hasValidOperation, hasInvalidOperation = false, false
	for _, operationName, operationSettings in TSM.Operations.GroupOperationIterator("Auctioning", groupPath) do
		local isValid, numUsed = private.IsOperationValid(itemString, numHave, operationName, operationSettings)
		if isValid == true then
			assert(numUsed and numUsed > 0)
			numHave = numHave - numUsed
			hasValidOperation = true
		elseif isValid == false then
			hasInvalidOperation = true
		else
			-- we are ignoring this operation
			assert(isValid == nil, "Invalid return value")
		end
	end

	return hasValidOperation and not hasInvalidOperation
end

function private.GetKeepQuantity(itemString, operationSettings)
	local keepQuantity = operationSettings.keepQuantity
	if operationSettings.keepQtySources.bank then
		keepQuantity = keepQuantity - TSMAPI_FOUR.Inventory.GetBankQuantity(itemString) - TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString)
	end
	if operationSettings.keepQtySources.guild then
		keepQuantity = keepQuantity - TSMAPI_FOUR.Inventory.GetGuildQuantity(itemString)
	end
	return max(keepQuantity, 0)
end

function private.IsOperationValid(itemString, num, operationName, operationSettings)
	if operationSettings.postCap == 0 then
		-- posting is disabled, so ignore this operation
		TSM.Auctioning.Log.AddEntry(itemString, operationName, "postDisabled", "", 0, math.huge)
		return nil
	end

	-- check the stack size
	local maxStackSize = TSMAPI_FOUR.Item.GetMaxStack(itemString)
	local minPostStackSize = operationSettings.stackSizeIsCap and 1 or operationSettings.stackSize
	if not maxStackSize then
		-- couldn't lookup item info for this item (shouldn't happen)
		if not TSM.db.global.auctioningOptions.disableInvalidMsg then
			TSM:Printf(L["Did not post %s because Blizzard didn't provide all necessary information for it. Try again later."], TSMAPI_FOUR.Item.GetLink(itemString))
		end
		TSM.Auctioning.Log.AddEntry(itemString, operationName, "invalidItemGroup", "", 0, math.huge)
		return false
	elseif maxStackSize < minPostStackSize then
		-- invalid stack size
		return nil
	end

	-- check that we have enough to post
	num = num - private.GetKeepQuantity(itemString, operationSettings)
	if num < minPostStackSize then
		-- not enough items to post for this operation
		TSM.Auctioning.Log.AddEntry(itemString, operationName, "postNotEnough", "", 0, math.huge)
		return nil
	end

	-- check the max expires
	if operationSettings.maxExpires > 0 then
		local numExpires = TSM.Accounting.Auctions.GetNumExpiresSinceSale(itemString)
		if numExpires and numExpires > operationSettings.maxExpires then
			-- too many expires, so ignore this operation
			TSM.Auctioning.Log.AddEntry(itemString, operationName, "postMaxExpires", "", 0, math.huge)
			return nil
		end
	end

	local errMsg = nil
	local minPrice = TSM.Auctioning.Util.GetPrice("minPrice", operationSettings, itemString)
	local normalPrice = TSM.Auctioning.Util.GetPrice("normalPrice", operationSettings, itemString)
	local maxPrice = TSM.Auctioning.Util.GetPrice("maxPrice", operationSettings, itemString)
	local undercut = TSM.Auctioning.Util.GetPrice("undercut", operationSettings, itemString)
	if not minPrice then
		errMsg = format(L["Did not post %s because your minimum price (%s) is invalid. Check your settings."], TSMAPI_FOUR.Item.GetLink(itemString), operationSettings.minPrice)
	elseif not maxPrice then
		errMsg = format(L["Did not post %s because your maximum price (%s) is invalid. Check your settings."], TSMAPI_FOUR.Item.GetLink(itemString), operationSettings.maxPrice)
	elseif not normalPrice then
		errMsg = format(L["Did not post %s because your normal price (%s) is invalid. Check your settings."], TSMAPI_FOUR.Item.GetLink(itemString), operationSettings.normalPrice)
	elseif not undercut then
		errMsg = format(L["Did not post %s because your undercut (%s) is invalid. Check your settings."], TSMAPI_FOUR.Item.GetLink(itemString), operationSettings.undercut)
	elseif normalPrice < minPrice then
		errMsg = format(L["Did not post %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."], TSMAPI_FOUR.Item.GetLink(itemString), operationSettings.normalPrice, operationSettings.minPrice)
	elseif maxPrice < minPrice then
		errMsg = format(L["Did not post %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."], TSMAPI_FOUR.Item.GetLink(itemString), operationSettings.maxPrice, operationSettings.minPrice)
	end

	if errMsg then
		if not TSM.db.global.auctioningOptions.disableInvalidMsg then
			TSM:Print(errMsg)
		end
		TSM.Auctioning.Log.AddEntry(itemString, operationName, "invalidItemGroup", "", 0, math.huge)
		return false
	else
		local vendorSellPrice = TSMAPI_FOUR.Item.GetVendorSell(itemString) or 0
		if vendorSellPrice > 0 and minPrice <= vendorSellPrice / 0.95 then
			-- just a warning, not an error
			TSM:Printf(L["WARNING: You minimum price for %s is below its vendorsell price (with AH cut taken into account). Consider raising your minimum price, or vendoring the item."], TSMAPI_FOUR.Item.GetLink(itemString))
		end
		return true, operationSettings.stackSize * operationSettings.postCap
	end
end

function private.AuctionScanOnFilterPartialDone(auctionScan, filter)
	for _, itemString in ipairs(filter:GetItems()) do
		if not private.IsFilterDoneForItem(auctionScan, itemString) then
			return false
		end
	end
	return true
end

function private.IsFilterDoneForItem(auctionScan, itemString)
	local groupPath = TSM.Groups.GetPathByItem(itemString)
	if not groupPath then
		return true
	end
	local isFilterDone = true
	local isBaseItemString = itemString == TSMAPI_FOUR.Item.ToBaseItemString(itemString)
	for _, _, operationSettings in TSM.Operations.GroupOperationIterator("Auctioning", groupPath) do
		if isFilterDone then
			local query = auctionScan:CreateDBQuery()
				:Select("itemBuyout")
				:Distinct("itemBuyout")
				:Equal(isBaseItemString and "baseItemString" or "itemString", itemString)
				:GreaterThan("itemBuyout", 0)
				:GreaterThan("timeLeft", operationSettings.ignoreLowDuration)
				:OrderBy("itemBuyout", true)
			if operationSettings.matchStackSize then
				query:Equal("stackSize", operationSettings.stackSize)
			end
			local numBuyouts = query:Count()
			local lowestItemBuyout = query:GetFirstResult()
			local highestItemBuyout = query:ResetOrderBy():OrderBy("itemBuyout", false):GetFirstResult()
			query:Release()
			if numBuyouts <= 1 then
				-- there is only one distinct item buyout, so can't stop yet
				isFilterDone = false
			else
				local minPrice = TSM.Auctioning.Util.GetPrice("minPrice", operationSettings, itemString)
				if not minPrice then
					-- the min price is not valid, so just keep scanning
					isFilterDone = false
				elseif lowestItemBuyout <= minPrice then
					local resetPrice = TSM.Auctioning.Util.GetPrice("priceReset", operationSettings, itemString)
					if operationSettings.priceReset == "ignore" or (resetPrice and highestItemBuyout <= resetPrice) then
						-- we need to keep scanning to handle the reset price (always keep scanning for "ignore")
						isFilterDone = false
					end
				end
			end
		end
	end
	return isFilterDone
end

function private.AuctionScanOnFilterDone(_, filter)
	for _, itemString in ipairs(filter:GetItems()) do
		local isBaseItemString = itemString == TSMAPI_FOUR.Item.ToBaseItemString(itemString)
		local query = private.auctionScanDB:NewQuery()
			:Equal(isBaseItemString and "baseItemString" or "itemString", itemString)
			:GreaterThan("itemBuyout", 0)
			:OrderBy("itemBuyout", true)
		local groupPath = TSM.Groups.GetPathByItem(itemString)
		if groupPath then
			local numHave = 0
			local bagQuery = private.bagDB:NewQuery()
				:Select("quantity", "bag", "slot")
				:Equal("itemString", itemString)
			for _, quantity, bag, slot in bagQuery:Iterator() do
				numHave = numHave + quantity
				private.DebugLogInsert(itemString, "Filter done and have %d in %d, %d", numHave, bag, slot)
			end
			bagQuery:Release()

			for _, operationName, operationSettings in TSM.Operations.GroupOperationIterator("Auctioning", groupPath) do
				if private.IsOperationValid(itemString, numHave, operationName, operationSettings) then
					local operationNumHave = numHave - private.GetKeepQuantity(itemString, operationSettings)
					if operationNumHave > 0 then
						local reason, numUsed, itemBuyout, seller, index = private.GeneratePosts(itemString, operationName, operationSettings, operationNumHave, query)
						numHave = numHave - (numUsed or 0)
						seller = seller or ""
						index = index or math.huge
						TSM.Auctioning.Log.AddEntry(itemString, operationName, reason, seller, itemBuyout or 0, index)
					end
				end
			end
			assert(numHave >= 0)
		else
			TSM:LOG_WARN("Item removed from group since start of scan: %s", itemString)
		end
		query:Release()
	end
end

function private.GeneratePosts(itemString, operationName, operationSettings, numHave, query)
	if numHave == 0 then
		return "postNotEnough"
	end

	local maxStackSize = TSMAPI_FOUR.Item.GetMaxStack(itemString)
	if operationSettings.stackSize > maxStackSize and not operationSettings.stackSizeIsCap then
		return "postNotEnough"
	end

	local perAuction = min(operationSettings.stackSize, maxStackSize)
	local maxCanPost = min(floor(numHave / perAuction), operationSettings.postCap)
	if maxCanPost == 0 then
		if operationSettings.stackSizeIsCap then
			perAuction = numHave
			maxCanPost = 1
		else
			-- not enough for single post
			return "postNotEnough"
		end
	end

	local lowestAuction = TSMAPI_FOUR.Util.AcquireTempTable()
	if not TSM.Auctioning.Util.GetLowestAuction(query, itemString, operationSettings, lowestAuction) then
		TSMAPI_FOUR.Util.ReleaseTempTable(lowestAuction)
		lowestAuction = nil
	end
	local minPrice = TSM.Auctioning.Util.GetPrice("minPrice", operationSettings, itemString)
	local normalPrice = TSM.Auctioning.Util.GetPrice("normalPrice", operationSettings, itemString)
	local maxPrice = TSM.Auctioning.Util.GetPrice("maxPrice", operationSettings, itemString)
	local undercut = TSM.Auctioning.Util.GetPrice("undercut", operationSettings, itemString)
	local resetPrice = TSM.Auctioning.Util.GetPrice("priceReset", operationSettings, itemString)
	local aboveMax = TSM.Auctioning.Util.GetPrice("aboveMax", operationSettings, itemString)

	local reason, bid, buyout, seller, activeAuctions = nil, nil, nil, nil, 0
	if not lowestAuction then
		-- post as many as we can at the normal price
		reason = "postNormal"
		buyout = normalPrice
	elseif lowestAuction.hasInvalidSeller then
		-- we didn't get all the necessary seller info
		TSM:Printf(L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."], TSMAPI_FOUR.Item.GetLink(itemString))
		TSMAPI_FOUR.Util.ReleaseTempTable(lowestAuction)
		return "invalidSeller"
	elseif lowestAuction.isBlacklist and lowestAuction.isPlayer then
		TSM:Printf(L["Did not post %s because you or one of your alts (%s) is on the blacklist which is not allowed. Remove this character from your blacklist."], TSMAPI_FOUR.Item.GetLink(itemString), lowestAuction.seller)
		TSMAPI_FOUR.Util.ReleaseTempTable(lowestAuction)
		return "invalidItemGroup"
	elseif lowestAuction.isBlacklist and lowestAuction.isWhitelist then
		TSM:Printf(L["Did not post %s because the owner of the lowest auction (%s) is on both the blacklist and whitelist which is not allowed. Adjust your settings to correct this issue."], TSMAPI_FOUR.Item.GetLink(itemString), lowestAuction.seller)
		TSMAPI_FOUR.Util.ReleaseTempTable(lowestAuction)
		return "invalidItemGroup"
	elseif lowestAuction.buyout <= minPrice then
		seller = lowestAuction.seller
		if resetPrice then
			-- lowest is below the min price, but there is a reset price
			assert(RESET_REASON_LOOKUP[operationSettings.priceReset], "Unexpected 'below minimum price' setting: "..tostring(operationSettings.priceReset))
			reason = RESET_REASON_LOOKUP[operationSettings.priceReset]
			buyout = resetPrice
			bid = max(bid or buyout * operationSettings.bidPercent, minPrice)
			activeAuctions = TSM.Auctioning.Util.GetPlayerAuctionCount(query, itemString, operationSettings, floor(bid), buyout, perAuction)
		elseif lowestAuction.isBlacklist then
			-- undercut the blacklisted player
			reason = "postBlacklist"
			buyout = lowestAuction.buyout - undercut
		else
			-- don't post this item
			TSMAPI_FOUR.Util.ReleaseTempTable(lowestAuction)
			return "postBelowMin", nil, nil, seller
		end
	elseif lowestAuction.isPlayer or (lowestAuction.isWhitelist and TSM.db.global.auctioningOptions.matchWhitelist) then
		-- we (or a whitelisted play we should match) is lowest, so match the current price and post as many as we can
		activeAuctions = TSM.Auctioning.Util.GetPlayerAuctionCount(query, itemString, operationSettings, lowestAuction.bid, lowestAuction.buyout, perAuction)
		if lowestAuction.isPlayer then
			reason = "postPlayer"
		else
			reason = "postWhitelist"
		end
		bid = lowestAuction.bid
		buyout = lowestAuction.buyout
		seller = lowestAuction.seller
	elseif lowestAuction.isWhitelist then
		-- don't undercut a whitelisted player
		seller = lowestAuction.seller
		TSMAPI_FOUR.Util.ReleaseTempTable(lowestAuction)
		return "postWhitelistNoPost", nil, nil, seller
	elseif (lowestAuction.buyout - undercut) > maxPrice then
		-- we'd be posting above the max price, so resort to the aboveMax setting
		seller = lowestAuction.seller
		if operationSettings.aboveMax == "none" then
			TSMAPI_FOUR.Util.ReleaseTempTable(lowestAuction)
			return "postAboveMaxNoPost", nil, nil, seller
		end
		assert(ABOVE_MAX_REASON_LOOKUP[operationSettings.aboveMax], "Unexpected 'above max price' setting: "..tostring(operationSettings.aboveMax))
		reason = ABOVE_MAX_REASON_LOOKUP[operationSettings.aboveMax]
		buyout = aboveMax
	else
		-- we just need to do a normal undercut of the lowest auction
		reason = "postUndercut"
		buyout = lowestAuction.buyout - undercut
		seller = lowestAuction.seller
	end
	if reason == "postBlacklist" then
		bid = bid or buyout * operationSettings.bidPercent
	else
		buyout = max(buyout, minPrice)
		bid = max(bid or buyout * operationSettings.bidPercent, minPrice)
	end
	if lowestAuction then
		TSMAPI_FOUR.Util.ReleaseTempTable(lowestAuction)
	end
	bid = floor(bid)

	-- check if we can't post anymore
	local queueQuery = private.queueDB:NewQuery()
		:Select("numStacks")
		:Equal("itemString", itemString)
		:Equal("stackSize", perAuction)
		:Equal("itemBuyout", buyout)
	for _, numStacks in queueQuery:Iterator() do
		activeAuctions = activeAuctions + numStacks
	end
	queueQuery:Release()
	maxCanPost = min(operationSettings.postCap - activeAuctions, maxCanPost)
	if maxCanPost <= 0 then
		return "postTooMany"
	end

	-- insert the posts into our DB
	local index = private.nextQueueIndex
	local postTime = operationSettings.duration
	private.AddToQueue(itemString, operationName, bid, buyout, perAuction, maxCanPost, postTime)
	-- check if we can post an extra partial stack
	local extraStack = (maxCanPost < operationSettings.postCap and operationSettings.stackSizeIsCap and (numHave % perAuction)) or 0
	if extraStack > 0 then
		private.AddToQueue(itemString, operationName, bid, buyout, extraStack, 1, postTime)
	end
	return reason, (perAuction * maxCanPost) + extraStack, buyout, seller, index
end

function private.AddToQueue(itemString, operationName, itemBid, itemBuyout, stackSize, numStacks, postTime)
	private.DebugLogInsert(itemString, "Queued %d stacks of %d", stackSize, numStacks)
	private.queueDB:NewRow()
		:SetField("index", private.nextQueueIndex)
		:SetField("itemString", itemString)
		:SetField("operationName", operationName)
		:SetField("bid", min(itemBid * stackSize, MAXIMUM_BID_PRICE))
		:SetField("buyout", min(itemBuyout * stackSize, MAXIMUM_BID_PRICE))
		:SetField("itemBuyout", itemBuyout)
		:SetField("stackSize", stackSize)
		:SetField("numStacks", numStacks)
		:SetField("postTime", postTime)
		:SetField("numProcessed", 0)
		:SetField("numConfirmed", 0)
		:SetField("numFailed", 0)
		:Create()
	private.nextQueueIndex = private.nextQueueIndex + 1
end



-- ============================================================================
-- Private Helper Functions for Posting
-- ============================================================================

function private.GetPostBagSlot(itemString, quantity)
	-- start with the slot which is closest to the desired stack size
	local bag, slot = private.bagDB:NewQuery()
		:Select("bag", "slot")
		:Equal("itemString", itemString)
		:GreaterThanOrEqual("quantity", quantity)
		:OrderBy("quantity", true)
		:GetFirstResultAndRelease()
	if not bag then
		bag, slot = private.bagDB:NewQuery()
			:Select("bag", "slot")
			:Equal("itemString", itemString)
			:LessThanOrEqual("quantity", quantity)
			:OrderBy("quantity", false)
			:GetFirstResultAndRelease()
	end
	if not bag or not slot then
		-- this item was likely removed from the player's bags, so just give up
		TSM:LOG_ERR("Failed to find initial bag / slot (%s, %d)", itemString, quantity)
		return nil, true
	end
	local removeContext = TSMAPI_FOUR.Util.AcquireTempTable()
	bag, slot = private.ItemBagSlotHelper(itemString, bag, slot, quantity, removeContext)

	if TSMAPI_FOUR.Item.ToBaseItemString(GetContainerItemLink(bag, slot), true) ~= itemString then
		-- something changed with the player's bags so we can't post the item right now
		TSMAPI_FOUR.Util.ReleaseTempTable(removeContext)
		private.DebugLogInsert(itemString, "Bags changed")
		return nil, nil
	end
	local _, _, _, quality = GetContainerItemInfo(bag, slot)
	assert(quality)
	if quality == -1 then
		-- the game client doesn't have item info cached for this item, so we can't post it yet
		TSMAPI_FOUR.Util.ReleaseTempTable(removeContext)
		private.DebugLogInsert(itemString, "No item info")
		return nil, nil
	end
	for slotId, removeQuantity in pairs(removeContext) do
		private.RemoveBagQuantity(slotId, removeQuantity)
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(removeContext)
	private.DebugLogInsert(itemString, "GetPostBagSlot(%d) -> %d, %d", quantity, bag, slot)
	return bag, slot
end

function private.ItemBagSlotHelper(itemString, bag, slot, quantity, removeContext)
	local slotId = TSMAPI_FOUR.Util.JoinSlotId(bag, slot)

	-- try to post completely from the selected slot
	local found = private.bagDB:NewQuery()
		:Select("slotId")
		:Equal("slotId", slotId)
		:GreaterThanOrEqual("quantity", quantity)
		:GetFirstResultAndRelease()
	if found then
		removeContext[slotId] = quantity
		return bag, slot
	end

	-- try to find a stack at a lower slot which has enough to post from
	local foundSlotId, foundBag, foundSlot = private.bagDB:NewQuery()
		:Select("slotId", "bag", "slot")
		:Equal("itemString", itemString)
		:LessThan("slotId", slotId)
		:GreaterThanOrEqual("quantity", quantity)
		:OrderBy("slotId", true)
		:GetFirstResultAndRelease()
	if foundSlotId then
		removeContext[foundSlotId] = quantity
		return foundBag, foundSlot
	end

	-- try to post using the selected slot and the lower slots
	local selectedQuantity = private.bagDB:NewQuery()
		:Select("quantity")
		:Equal("slotId", slotId)
		:GetFirstResultAndRelease()
	local query = private.bagDB:NewQuery()
		:Select("slotId", "quantity")
		:Equal("itemString", itemString)
		:LessThan("slotId", slotId)
		:OrderBy("slotId", true)
	local numNeeded = quantity - selectedQuantity
	local numUsed = 0
	local usedSlotIds = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, rowSlotId, rowQuantity in query:Iterator() do
		if numNeeded ~= numUsed then
			numUsed = min(numUsed + rowQuantity, numNeeded)
			tinsert(usedSlotIds, rowSlotId)
		end
	end
	query:Release()
	if numNeeded == numUsed then
		removeContext[slotId] = selectedQuantity
		for _, rowSlotId in TSMAPI_FOUR.Util.TempTableIterator(usedSlotIds) do
			local rowQuantity = private.bagDB:GetUniqueRowField("slotId", rowSlotId, "quantity")
			local rowNumUsed = min(numUsed, rowQuantity)
			numUsed = numUsed - rowNumUsed
			removeContext[rowSlotId] = (removeContext[rowSlotId] or 0) + rowNumUsed
		end
		return bag, slot
	else
		TSMAPI_FOUR.Util.ReleaseTempTable(usedSlotIds)
	end

	-- try posting from the next highest slot
	local rowBag, rowSlot = private.bagDB:NewQuery()
		:Select("bag", "slot")
		:Equal("itemString", itemString)
		:GreaterThan("slotId", slotId)
		:OrderBy("slotId", true)
		:GetFirstResultAndRelease()
	if not rowBag or not rowSlot then
		private.ErrorForItem(itemString, "Failed to find next highest bag / slot")
	end
	return private.ItemBagSlotHelper(itemString, rowBag, rowSlot, quantity, removeContext)
end

function private.RemoveBagQuantity(slotId, quantity)
	local row = private.bagDB:GetUniqueRow("slotId", slotId)
	local remainingQuantity = row:GetField("quantity") - quantity
	private.DebugLogInsert(row:GetField("itemString"), "Removing %d (%d remain) from %d", quantity, remainingQuantity, slotId)
	if remainingQuantity > 0 then
		row:SetField("quantity", remainingQuantity)
			:Update()
	else
		assert(remainingQuantity == 0)
		private.bagDB:DeleteRow(row)
	end
	row:Release()
end

function private.ConfirmRowQueryHelper(row)
	return row:GetField("numConfirmed") < row:GetField("numProcessed")
end

function private.NextProcessRowQueryHelper(row)
	return row:GetField("numProcessed") < row:GetField("numStacks")
end

function private.DebugLogInsert(itemString, ...)
	tinsert(private.debugLog, itemString)
	tinsert(private.debugLog, format(...))
end

function private.ErrorForItem(itemString, errorStr)
	for i = 1, #private.debugLog, 2 do
		if private.debugLog[i] == itemString then
			TSM:LOG_INFO(private.debugLog[i + 1])
		end
	end
	TSM:LOG_INFO("Bag state:")
	for b = 0, NUM_BAG_SLOTS do
		for s = 1, GetContainerNumSlots(b) do
			if TSMAPI_FOUR.Item.ToBaseItemString(GetContainerItemLink(b, s)) == itemString then
				local _, q = GetContainerItemInfo(b, s)
				TSM:LOG_INFO("%d in %d, %d", q, b, s)
			end
		end
	end
	error(errorStr, 2)
end
