-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local CancelScan = TSM.Auctioning:NewPackage("CancelScan")
local L = TSM.L
local private = { scanThreadId = nil, queueDB = nil, auctionScanDB = nil, itemList = {}, usedAuctionIndex = {} }



-- ============================================================================
-- Module Functions
-- ============================================================================

function CancelScan.OnInitialize()
	-- initialize thread
	private.scanThreadId = TSMAPI_FOUR.Thread.New("CANCEL_SCAN", private.ScanThread)
	private.queueDB = TSMAPI_FOUR.Database.NewSchema("AUCTIONING_CANCEL_QUEUE")
		:AddNumberField("index")
		:AddStringField("itemString")
		:AddStringField("operationName")
		:AddNumberField("bid")
		:AddNumberField("buyout")
		:AddNumberField("itemBid")
		:AddNumberField("itemBuyout")
		:AddNumberField("stackSize")
		:AddNumberField("numStacks")
		:AddNumberField("numProcessed")
		:AddNumberField("numConfirmed")
		:AddNumberField("numFailed")
		:AddIndex("index")
		:AddIndex("itemString")
		:Commit()
end

function CancelScan.Prepare()
	return private.scanThreadId
end

function CancelScan.GetCurrentRow()
	return private.queueDB:NewQuery()
		:Custom(private.NextProcessRowQueryHelper)
		:OrderBy("index", false)
		:GetFirstResultAndRelease()
end

function CancelScan.GetStatus()
	return TSM.Auctioning.Util.GetQueueStatus(private.queueDB:NewQuery())
end

function CancelScan.DoProcess()
	local cancelRow = CancelScan.GetCurrentRow()

	local query = TSM.Inventory.AuctionTracking.CreateQuery()
		:Equal("autoBaseItemString", cancelRow:GetField("itemString"))
		:Equal("saleStatus", 0)
		:Equal("stackSize", cancelRow:GetField("stackSize"))
		:Custom(private.ProcessQueryHelper, cancelRow)
		:OrderBy("index", false)
	if not TSM.db.global.auctioningOptions.cancelWithBid then
		query:Equal("highBidder", "")
	end
	local row = query:GetFirstResultAndRelease()
	if row then
		local index, itemString, currentBid, buyout = row:GetFields("index", "autoBaseItemString", "currentBid", "buyout")
		row:Release()
		private.usedAuctionIndex[itemString..buyout..currentBid..index] = true
		CancelAuction(index)
		cancelRow:SetField("numProcessed", cancelRow:GetField("numProcessed") + 1)
			:Update()
		cancelRow:Release()
		return true
	end

	-- we couldn't find this item, so mark this cancel as failed and we'll try again later
	cancelRow:SetField("numProcessed", cancelRow:GetField("numProcessed") + 1)
		:Update()
	cancelRow:Release()
	return false
end

function CancelScan.DoSkip()
	local cancelRow = CancelScan.GetCurrentRow()
	cancelRow:SetField("numProcessed", cancelRow:GetField("numProcessed") + 1)
		:SetField("numConfirmed", cancelRow:GetField("numConfirmed") + 1)
		:Update()
	cancelRow:Release()
end

function CancelScan.HandleConfirm(success, canRetry)
	local confirmRow = private.queueDB:NewQuery()
		:Custom(private.ConfirmRowQueryHelper)
		:OrderBy("index", true)
		:GetFirstResultAndRelease()
	if not confirmRow then
		-- we may have cancelled something outside of TSM
		return
	end

	if canRetry then
		confirmRow:SetField("numFailed", confirmRow:GetField("numFailed") + 1)
	end
	confirmRow:SetField("numConfirmed", confirmRow:GetField("numConfirmed") + 1)
		:Update()
	confirmRow:Release()
end

function CancelScan.PrepareFailedCancels()
	wipe(private.usedAuctionIndex)
	private.queueDB:SetQueryUpdatesPaused(true)
	local query = private.queueDB:NewQuery()
		:GreaterThan("numFailed", 0)
	for _, row in query:Iterator() do
		local numFailed, numProcessed, numConfirmed = row:GetFields("numFailed", "numProcessed", "numConfirmed")
		assert(numProcessed >= numFailed and numConfirmed >= numFailed)
		row:SetField("numFailed", 0)
			:SetField("numProcessed", numProcessed - numFailed)
			:SetField("numConfirmed", numConfirmed - numFailed)
			:Update()
	end
	query:Release()
	private.queueDB:SetQueryUpdatesPaused(false)
end

function CancelScan.Reset()
	private.auctionScanDB = nil
	private.queueDB:Truncate()
	wipe(private.usedAuctionIndex)
end



-- ============================================================================
-- Scan Thread
-- ============================================================================

function private.ScanThread(auctionScan, auctionScanDB, groupList)
	private.auctionScanDB = auctionScanDB
	auctionScan:SetScript("OnFilterDone", private.AuctionScanOnFilterDone)

	-- generate the list of items we want to scan for
	wipe(private.itemList)
	local processedItems = TSMAPI_FOUR.Util.AcquireTempTable()
	local query = TSM.Inventory.AuctionTracking.CreateQuery()
		:Select("autoBaseItemString")
		:Equal("saleStatus", 0)
	if not TSM.db.global.auctioningOptions.cancelWithBid then
		query:Equal("highBidder", "")
	end
	for _, itemString in query:Iterator() do
		if not processedItems[itemString] and private.CanCancelItem(itemString, groupList) then
			tinsert(private.itemList, itemString)
		end
		processedItems[itemString] = true
	end
	query:Release()
	TSMAPI_FOUR.Util.ReleaseTempTable(processedItems)

	if #private.itemList == 0 then
		return
	end
	TSM.Auctioning.SavedSearches.RecordSearch(groupList, "cancelGroups")

	-- run the scan
	auctionScan:AddItemListFiltersThreaded(private.itemList)
	auctionScan:StartScanThreaded()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.CanCancelItem(itemString, groupList)
	local groupPath = TSM.Groups.GetPathByItem(itemString)
	if not groupPath or not tContains(groupList, groupPath) then
		return false
	end

	local hasValidOperation, hasInvalidOperation = false, false
	for _, operationName, operationSettings in TSM.Operations.GroupOperationIterator("Auctioning", groupPath) do
		local isValid = private.IsOperationValid(itemString, operationName, operationSettings)
		if isValid == true then
			hasValidOperation = true
		elseif isValid == false then
			hasInvalidOperation = true
		else
			-- we are ignoring this operation
			assert(isValid == nil, "Invalid return value")
		end
	end
	return hasValidOperation and not hasInvalidOperation, itemString
end

function private.IsOperationValid(itemString, operationName, operationSettings)
	if not operationSettings.cancelUndercut and not operationSettings.cancelRepost then
		-- canceling is disabled, so ignore this operation
		TSM.Auctioning.Log.AddEntry(itemString, operationName, "cancelDisabled", "", 0, 0)
		return nil
	end

	local errMsg = nil
	local minPrice = TSM.Auctioning.Util.GetPrice("minPrice", operationSettings, itemString)
	local normalPrice = TSM.Auctioning.Util.GetPrice("normalPrice", operationSettings, itemString)
	local maxPrice = TSM.Auctioning.Util.GetPrice("maxPrice", operationSettings, itemString)
	local undercut = TSM.Auctioning.Util.GetPrice("undercut", operationSettings, itemString)
	local cancelRepostThreshold = TSM.Auctioning.Util.GetPrice("cancelRepostThreshold", operationSettings, itemString)
	if not minPrice then
		errMsg = format(L["Did not cancel %s because your minimum price (%s) is invalid. Check your settings."], TSMAPI_FOUR.Item.GetLink(itemString), operationSettings.minPrice)
	elseif not maxPrice then
		errMsg = format(L["Did not cancel %s because your maximum price (%s) is invalid. Check your settings."], TSMAPI_FOUR.Item.GetLink(itemString), operationSettings.maxPrice)
	elseif not normalPrice then
		errMsg = format(L["Did not cancel %s because your normal price (%s) is invalid. Check your settings."], TSMAPI_FOUR.Item.GetLink(itemString), operationSettings.normalPrice)
	elseif operationSettings.cancelRepost and not cancelRepostThreshold then
		errMsg = format(L["Did not cancel %s because your cancel to repost threshold (%s) is invalid. Check your settings."], TSMAPI_FOUR.Item.GetLink(itemString), operationSettings.cancelRepostThreshold)
	elseif not undercut then
		errMsg = format(L["Did not cancel %s because your undercut (%s) is invalid. Check your settings."], TSMAPI_FOUR.Item.GetLink(itemString), operationSettings.undercut)
	elseif maxPrice < minPrice then
		errMsg = format(L["Did not cancel %s because your maximum price (%s) is lower than your minimum price (%s). Check your settings."], TSMAPI_FOUR.Item.GetLink(itemString), operationSettings.maxPrice, operationSettings.minPrice)
	elseif normalPrice < minPrice then
		errMsg = format(L["Did not cancel %s because your normal price (%s) is lower than your minimum price (%s). Check your settings."], TSMAPI_FOUR.Item.GetLink(itemString), operationSettings.normalPrice, operationSettings.minPrice)
	end

	if errMsg then
		if not TSM.db.global.auctioningOptions.disableInvalidMsg then
			TSM:Print(errMsg)
		end
		TSM.Auctioning.Log.AddEntry(itemString, operationName, "invalidItemGroup", "", 0, 0)
		return false
	else
		return true
	end
end

function private.AuctionScanOnFilterDone(_, filter)
	TSM.Auctioning.Log.SetQueryUpdatesPaused(true)
	for _, itemString in ipairs(filter:GetItems()) do
		local isBaseItemString = itemString == TSMAPI_FOUR.Item.ToBaseItemString(itemString)
		local query = private.auctionScanDB:NewQuery()
			:Equal(isBaseItemString and "baseItemString" or "itemString", itemString)
			:GreaterThan("itemBuyout", 0)
			:OrderBy("itemBuyout", true)
		local groupPath = TSM.Groups.GetPathByItem(itemString)
		if groupPath then
			local auctionsDBQuery = TSM.Inventory.AuctionTracking.CreateQuery()
				:Equal("autoBaseItemString", itemString)
				:Equal("saleStatus", 0)
				:OrderBy("index", false)
			for _, auctionsDBRow in auctionsDBQuery:IteratorAndRelease() do
				private.GenerateCancels(auctionsDBRow, itemString, query, groupPath)
			end
		else
			TSM:LOG_WARN("Item removed from group since start of scan: %s", itemString)
		end
		query:Release()
	end
	TSM.Auctioning.Log.SetQueryUpdatesPaused(false)
end

function private.GenerateCancels(auctionsDBRow, itemString, query, groupPath)
	local isHandled = false
	for _, operationName, operationSettings in TSM.Operations.GroupOperationIterator("Auctioning", groupPath) do
		if not isHandled and private.IsOperationValid(itemString, operationName, operationSettings) then
			local handled, logReason, itemBuyout, seller, index = private.GenerateCancel(auctionsDBRow, itemString, operationName, operationSettings, query)
			if logReason then
				seller = seller or ""
				index = index or 0
				TSM.Auctioning.Log.AddEntry(itemString, operationName, logReason, seller, itemBuyout, index)
			end
			isHandled = isHandled or handled
		end
	end
end

function private.GenerateCancel(auctionsDBRow, itemString, operationName, operationSettings, query)
	local index, stackSize, bid, buyout, highBidder = auctionsDBRow:GetFields("index", "stackSize", "currentBid", "buyout", "highBidder")
	local itemBuyout = floor(buyout / stackSize)
	local itemBid = floor(bid / stackSize)
	if operationSettings.matchStackSize and stackSize ~= operationSettings.stackSize then
		return false
	elseif not TSM.db.global.auctioningOptions.cancelWithBid and highBidder ~= "" then
		-- Don't cancel an auction if it has a bid and we're set to not cancel those
		return true, "cancelBid", itemBuyout, nil, index
	end

	local lowestAuction = TSMAPI_FOUR.Util.AcquireTempTable()
	if not TSM.Auctioning.Util.GetLowestAuction(query, itemString, operationSettings, lowestAuction) then
		TSMAPI_FOUR.Util.ReleaseTempTable(lowestAuction)
		lowestAuction = nil
	end
	local minPrice = TSM.Auctioning.Util.GetPrice("minPrice", operationSettings, itemString)
	local normalPrice = TSM.Auctioning.Util.GetPrice("normalPrice", operationSettings, itemString)
	local maxPrice = TSM.Auctioning.Util.GetPrice("maxPrice", operationSettings, itemString)
	local resetPrice = TSM.Auctioning.Util.GetPrice("priceReset", operationSettings, itemString)
	local cancelRepostThreshold = TSM.Auctioning.Util.GetPrice("cancelRepostThreshold", operationSettings, itemString)
	local undercut = TSM.Auctioning.Util.GetPrice("undercut", operationSettings, itemString)
	local aboveMax = TSM.Auctioning.Util.GetPrice("aboveMax", operationSettings, itemString)

	if not lowestAuction then
		-- all auctions which are posted (including ours) have been ignored, so check if we should cancel to repost higher
		if operationSettings.cancelRepost and normalPrice - itemBuyout > cancelRepostThreshold then
			private.AddToQueue(itemString, operationName, itemBid, itemBuyout, stackSize, index)
			return true, "cancelRepost", itemBuyout, nil, index
		else
			return false, "cancelNotUndercut", itemBuyout
		end
	elseif lowestAuction.hasInvalidSeller then
		TSM:Printf(L["The seller name of the lowest auction for %s was not given by the server. Skipping this item."], TSMAPI_FOUR.Item.GetLink(itemString))
		TSMAPI_FOUR.Util.ReleaseTempTable(lowestAuction)
		return false, "invalidSeller", itemBuyout
	end

	local shouldCancel, logReason = false, nil
	local playerLowestItemBuyout = TSM.Auctioning.Util.GetPlayerLowestBuyout(query, itemString, operationSettings)
	local secondLowestBuyout = TSM.Auctioning.Util.GetNextLowestItemBuyout(query, itemString, lowestAuction.buyout, operationSettings)
	if itemBuyout < minPrice and not lowestAuction.isBlacklist then
		-- this auction is below the min price
		if operationSettings.cancelRepost and resetPrice and itemBuyout < (resetPrice - cancelRepostThreshold) then
			-- canceling to post at reset price
			shouldCancel = true
			logReason = "cancelReset"
		else
			logReason = "cancelBelowMin"
		end
	elseif lowestAuction.buyout < minPrice and not lowestAuction.isBlacklist then
		-- lowest buyout is below min price, so do nothing
		logReason = "cancelBelowMin"
	elseif operationSettings.cancelUndercut and playerLowestItemBuyout and (itemBuyout - undercut) > playerLowestItemBuyout then
		-- we've undercut this auction
		shouldCancel = true
		logReason = "cancelPlayerUndercut"
	elseif TSM.Auctioning.Util.IsPlayerOnlySeller(query, itemString, operationSettings) then
		-- we are the only auction
		if operationSettings.cancelRepost and (normalPrice - itemBuyout) > cancelRepostThreshold then
			-- we can repost higher
			shouldCancel = true
			logReason = "cancelRepost"
		else
			logReason = "cancelAtNormal"
		end
	elseif lowestAuction.isPlayer and secondLowestBuyout and secondLowestBuyout > maxPrice then
		-- we are posted at the aboveMax price with no competition under our max price
		if operationSettings.cancelRepost and operationSettings.aboveMax ~= "none" and (aboveMax - itemBuyout) > cancelRepostThreshold then
			-- we can repost higher
			shouldCancel = true
			logReason = "cancelRepost"
		else
			logReason = "cancelAtAboveMax"
		end
	elseif lowestAuction.isPlayer then
		-- we are the loewst auction
		if operationSettings.cancelRepost and secondLowestBuyout and ((secondLowestBuyout - undercut) - lowestAuction.buyout) > cancelRepostThreshold then
			-- we can repost higher
			shouldCancel = true
			logReason = "cancelRepost"
		else
			logReason = "cancelNotUndercut"
		end
	elseif not operationSettings.cancelUndercut then
		-- we're undercut but not canceling undercut auctions
	elseif lowestAuction.isWhitelist and itemBuyout == lowestAuction.buyout then
		-- at whitelisted player price
		logReason = "cancelAtWhitelist"
	elseif not lowestAuction.isWhitelist then
		-- we've been undercut by somebody not on our whitelist
		shouldCancel = true
		logReason = "cancelUndercut"
	elseif itemBuyout ~= lowestAuction.buyout or itemBid ~= lowestAuction.bid then
		-- somebody on our whitelist undercut us (or their bid is lower)
		shouldCancel = true
		logReason = "cancelWhitelistUndercut"
	else
		error("Should not get here")
	end

	local seller = lowestAuction.seller
	TSMAPI_FOUR.Util.ReleaseTempTable(lowestAuction)
	if shouldCancel then
		private.AddToQueue(itemString, operationName, itemBid, itemBuyout, stackSize, index)
	end
	return shouldCancel, logReason, itemBuyout, seller, shouldCancel and index or nil
end

function private.AddToQueue(itemString, operationName, itemBid, itemBuyout, stackSize, index)
	private.queueDB:NewRow()
		:SetField("index", index)
		:SetField("itemString", itemString)
		:SetField("operationName", operationName)
		:SetField("bid", itemBid * stackSize)
		:SetField("buyout", itemBuyout * stackSize)
		:SetField("itemBid", itemBid)
		:SetField("itemBuyout", itemBuyout)
		:SetField("stackSize", stackSize)
		:SetField("numStacks", 1)
		:SetField("numProcessed", 0)
		:SetField("numConfirmed", 0)
		:SetField("numFailed", 0)
		:Create()
end

function private.ProcessQueryHelper(row, cancelRow)
	local index, itemString, stackSize, currentBid, buyout = row:GetFields("index", "autoBaseItemString", "stackSize", "currentBid", "buyout")
	local itemBid = floor(currentBid / stackSize)
	local itemBuyout = floor(buyout / stackSize)
	return not private.usedAuctionIndex[itemString..buyout..currentBid..index] and cancelRow:GetField("itemBid") == itemBid and cancelRow:GetField("itemBuyout") == itemBuyout
end

function private.ConfirmRowQueryHelper(row)
	return row:GetField("numConfirmed") < row:GetField("numProcessed")
end

function private.NextProcessRowQueryHelper(row)
	return row:GetField("numProcessed") < row:GetField("numStacks")
end
