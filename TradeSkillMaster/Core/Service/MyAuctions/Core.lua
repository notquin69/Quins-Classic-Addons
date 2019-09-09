-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local MyAuctions = TSM:NewPackage("MyAuctions")
local private = {
	pendingDB = nil,
	ahOpen = false,
	pendingHashes = {},
	expectedCounts = {},
	auctionInfo = { numPosted = 0, numSold = 0, postedGold = 0, soldGold = 0 },
	dbHashFields = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function MyAuctions.OnInitialize()
	private.pendingDB = TSMAPI_FOUR.Database.NewSchema("MY_AUCTIONS_PENDING")
		:AddUniqueNumberField("index")
		:AddNumberField("hash")
		:AddBooleanField("isPending")
		:Commit()
	for field in TSM.Inventory.AuctionTracking.DatabaseFieldIterator() do
		if field ~= "index" then
			tinsert(private.dbHashFields, field)
		end
	end

	TSMAPI_FOUR.Event.Register("AUCTION_HOUSE_SHOW", private.AuctionHouseShowEventHandler)
	TSMAPI_FOUR.Event.Register("AUCTION_HOUSE_CLOSED", private.AuctionHouseHideEventHandler)
	TSMAPI_FOUR.Event.Register("CHAT_MSG_SYSTEM", private.ChatMsgSystemEventHandler)
	TSMAPI_FOUR.Event.Register("UI_ERROR_MESSAGE", private.UIErrorMessageEventHandler)
	TSM.Inventory.AuctionTracking.RegisterCallback(private.OnAuctionsUpdated)
end

function MyAuctions.CreateQuery()
	return TSM.Inventory.AuctionTracking.CreateQuery()
		:LeftJoin(private.pendingDB, "index")
		:OrderBy("index", false)
end

function MyAuctions.CancelAuction(index)
	local row = private.pendingDB:NewQuery()
		:Equal("index", index)
		:GetFirstResultAndRelease()
	local hash = row:GetField("hash")
	assert(hash)
	if private.expectedCounts[hash] and private.expectedCounts[hash] > 0 then
		private.expectedCounts[hash] = private.expectedCounts[hash] - 1
	else
		private.expectedCounts[hash] = private.GetNumRowsByHash(hash) - 1
	end
	assert(private.expectedCounts[hash] >= 0)

	TSM:LOG_INFO("Canceling (index=%d, hash=%d)", index, hash)
	CancelAuction(index)
	assert(not row:GetField("isPending"))
	row:SetField("isPending", true)
		:Update()
	row:Release()

	tinsert(private.pendingHashes, hash)
end

function MyAuctions.CanCancel(index)
	local count = private.pendingDB:NewQuery()
		:Equal("isPending", true)
		:LessThanOrEqual("index", index)
		:CountAndRelease()
	return count == 0
end

function MyAuctions.GetNumPending()
	return private.pendingDB:NewQuery()
		:Equal("isPending", true)
		:CountAndRelease()
end

function MyAuctions.GetAuctionInfo()
	if not private.ahOpen then
		return
	end
	return private.auctionInfo.numPosted, private.auctionInfo.numSold, private.auctionInfo.postedGold, private.auctionInfo.soldGold
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.AuctionHouseShowEventHandler()
	private.ahOpen = true
end

function private.AuctionHouseHideEventHandler()
	private.ahOpen = false
end

function private.ChatMsgSystemEventHandler(_, msg)
	if msg == ERR_AUCTION_REMOVED and #private.pendingHashes > 0 then
		local hash = tremove(private.pendingHashes, 1)
		assert(hash)
		TSM:LOG_INFO("Confirmed (hash=%d)", hash)
	end
end

function private.UIErrorMessageEventHandler(_, _, msg)
	if msg == ERR_ITEM_NOT_FOUND and #private.pendingHashes > 0 then
		local hash = tremove(private.pendingHashes, 1)
		assert(hash)
		TSM:LOG_INFO("Failed to cancel (hash=%d)", hash)
		if private.expectedCounts[hash] then
			private.expectedCounts[hash] = private.expectedCounts[hash] + 1
		end
	end
end

function private.GetNumRowsByHash(hash)
	return private.pendingDB:NewQuery()
		:Equal("hash", hash)
		:CountAndRelease()
end

function private.OnAuctionsUpdated()
	local minPendingIndexByHash = TSMAPI_FOUR.Util.AcquireTempTable()
	local numByHash = TSMAPI_FOUR.Util.AcquireTempTable()
	local query = TSM.Inventory.AuctionTracking.CreateQuery()
		:OrderBy("index", true)
	for _, row in query:Iterator() do
		local index = row:GetField("index")
		local hash = row:CalculateHash(private.dbHashFields)
		numByHash[hash] = (numByHash[hash] or 0) + 1
		if not minPendingIndexByHash[hash] and private.pendingDB:GetUniqueRowField("index", index, "isPending") then
			minPendingIndexByHash[hash] = index
		end
	end
	local numUsed = TSMAPI_FOUR.Util.AcquireTempTable()
	private.pendingDB:TruncateAndBulkInsertStart()
	for _, row in query:Iterator() do
		local hash = row:CalculateHash(private.dbHashFields)
		assert(numByHash[hash] > 0)
		local expectedCount = private.expectedCounts[hash]
		local isPending = nil
		if not expectedCount then
			-- this was never pending
			isPending = false
		elseif numByHash[hash] <= expectedCount then
			-- this is no longer pending
			isPending = false
			private.expectedCounts[hash] = nil
		elseif row:GetField("index") >= (minPendingIndexByHash[hash] or math.huge) then
			local numPending = numByHash[hash] - expectedCount
			assert(numPending > 0)
			numUsed[hash] = (numUsed[hash] or 0) + 1
			isPending = numUsed[hash] <= numPending
		else
			-- it's a later auction which is pending
			isPending = false
		end
		private.pendingDB:BulkInsertNewRow(row:GetField("index"), hash, isPending)
	end
	private.pendingDB:BulkInsertEnd()
	TSMAPI_FOUR.Util.ReleaseTempTable(numByHash)
	TSMAPI_FOUR.Util.ReleaseTempTable(numUsed)
	TSMAPI_FOUR.Util.ReleaseTempTable(minPendingIndexByHash)

	-- update the player's auction status
	private.auctionInfo.numPosted = 0
	private.auctionInfo.numSold = 0
	private.auctionInfo.postedGold = 0
	private.auctionInfo.soldGold = 0
	for _, row in query:Iterator() do
		local saleStatus, buyout, currentBid = row:GetFields("saleStatus", "buyout", "currentBid")
		private.auctionInfo.numPosted = private.auctionInfo.numPosted + 1
		private.auctionInfo.postedGold = private.auctionInfo.postedGold + buyout
		if saleStatus == 1 then
			private.auctionInfo.numSold = private.auctionInfo.numSold + 1
			-- if somebody did a buyout, then bid will be equal to buyout, otherwise it'll be the winning bid
			private.auctionInfo.soldGold = private.auctionInfo.soldGold + currentBid
		end
	end
	query:Release()
end
