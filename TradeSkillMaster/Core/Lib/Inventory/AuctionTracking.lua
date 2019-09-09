-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--          http://www.curse.com/addons/wow/tradeskillmaster_warehousing          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local AuctionTracking = TSM.Inventory:NewPackage("AuctionTracking")
local private = {
	db = nil,
	updateQuery = nil,
	isAHOpen = false,
	callbacks = {},
	indexUpdates = {
		list = {},
		pending = {},
	},
	lastScanNum = nil,
	ignoreUpdateEvent = nil,
}
local PLAYER_NAME = UnitName("player")
local SALE_HINT_SEP = "\001"
local SALE_HINT_EXPIRE_TIME = 33 * 24 * 60 * 60



-- ============================================================================
-- Module Functions
-- ============================================================================

function AuctionTracking.OnInitialize()
	TSMAPI_FOUR.Event.Register("AUCTION_HOUSE_SHOW", private.AuctionHouseShowHandler)
	TSMAPI_FOUR.Event.Register("AUCTION_HOUSE_CLOSED", private.AuctionHouseClosedHandler)
	TSMAPI_FOUR.Event.Register("AUCTION_OWNED_LIST_UPDATE", private.AuctionOwnedListUpdateHandler)
	private.db = TSMAPI_FOUR.Database.NewSchema("AUCTION_TRACKING")
		:AddUniqueNumberField("index")
		:AddStringField("itemString")
		:AddSmartMapField("baseItemString", TSM.Item.GetBaseItemStringMap(), "itemString")
		:AddSmartMapField("autoBaseItemString", TSM.Groups.GetAutoBaseItemStringSmartMap(), "itemString")
		:AddStringField("itemLink")
		:AddNumberField("itemTexture")
		:AddStringField("itemName")
		:AddNumberField("itemQuality")
		:AddNumberField("duration")
		:AddStringField("highBidder")
		:AddNumberField("currentBid")
		:AddNumberField("buyout")
		:AddNumberField("stackSize")
		:AddNumberField("saleStatus")
		:AddIndex("index")
		:AddIndex("autoBaseItemString")
		:AddIndex("saleStatus")
		:Commit()
	private.updateQuery = private.db:NewQuery()
		:SetUpdateCallback(private.OnCallbackQueryUpdated)
	for info, timestamp in pairs(TSM.db.char.internalData.auctionSaleHints) do
		if time() > timestamp + SALE_HINT_EXPIRE_TIME then
			TSM.db.char.internalData.auctionSaleHints[info] = nil
		end
	end

	hooksecurefunc("PostAuction", function(self, _, runTime)
		local days = nil
		if runTime == 1 then
			days = 0.5
		elseif runTime == 2 then
			days = 1
		elseif runTime == 3 then
			days = 2
		end

		local expiration = time() + (days * 24 * 60 * 60)
		if (TSM.db.factionrealm.internalData.expiringAuction[PLAYER_NAME] or math.huge) < expiration then
			return
		end

		TSM.db.factionrealm.internalData.expiringAuction[PLAYER_NAME] = expiration
		TSM.TaskList.Expirations.Update()
	end)
end

function AuctionTracking.RegisterCallback(callback)
	tinsert(private.callbacks, callback)
end

function AuctionTracking.DatabaseFieldIterator()
	return private.db:FieldIterator()
end

function AuctionTracking.CreateQuery()
	return private.db:NewQuery()
end

function AuctionTracking.GetSaleHintItemString(name, stackSize, buyout)
	for info in pairs(TSM.db.char.internalData.auctionSaleHints) do
		local infoName, itemString, infoStackSize, infoBuyout = strsplit(SALE_HINT_SEP, info)
		if infoName == name and tonumber(infoStackSize) == stackSize and tonumber(infoBuyout) == buyout then
			return itemString
		end
	end
end



-- ============================================================================
-- Event Handlers
-- ============================================================================

function private.AuctionHouseShowHandler()
	private.isAHOpen = true
	GetOwnerAuctionItems()
	-- We don't always get AUCTION_OWNED_LIST_UPDATE events, so do our own scanning if needed
	TSMAPI_FOUR.Delay.AfterTime("auctionBackgroundScan", 1, private.DoBackgroundScan, 1)
end

function private.AuctionHouseClosedHandler()
	private.isAHOpen = false
	TSMAPI_FOUR.Delay.Cancel("auctionBackgroundScan")
end

function private.DoBackgroundScan()
	if GetNumAuctionItems("owner") ~= private.lastScanNum then
		private.AuctionOwnedListUpdateHandler()
	end
end

function private.AuctionOwnedListUpdateHandler()
	if private.ignoreUpdateEvent then
		return
	end
	wipe(private.indexUpdates.pending)
	wipe(private.indexUpdates.list)
	GetOwnerAuctionItems()
	for i = 1, GetNumAuctionItems("owner") do
		if not private.indexUpdates.pending[i] then
			private.indexUpdates.pending[i] = true
			tinsert(private.indexUpdates.list, i)
		end
	end
	TSMAPI_FOUR.Delay.AfterFrame("AUCTION_OWNED_LIST_SCAN", 2, private.AuctionOwnedListUpdateDelayed)
end

-- this is not a WoW event, but we fake it based on a delay from private.BankSlotChangedHandler
function private.AuctionOwnedListUpdateDelayed()
	if not private.isAHOpen then
		return
	elseif AuctionFrame and AuctionFrame:IsVisible() and AuctionFrame.selectedTab == 3 then
		-- default UI auctions tab is visible, so scan later
		TSMAPI_FOUR.Delay.AfterFrame("AUCTION_OWNED_LIST_SCAN", 2, private.AuctionOwnedListUpdateDelayed)
		return
	end
	-- check if we need to change the sort
	local needsSort = false
	local numColumns = #AuctionSort.owner_duration
	for i, info in ipairs(AuctionSort.owner_duration) do
		local col, reversed = GetAuctionSort("owner", numColumns - i + 1)
		-- we want to do the opposite order
		reversed = not reversed
		if col ~= info.column or info.reverse ~= reversed then
			needsSort = true
			break
		end
	end
	if needsSort then
		TSM:LOG_INFO("Sorting owner auctions")
		-- ignore events while changing the sort
		private.ignoreUpdateEvent = true
		AuctionFrame_SetSort("owner", "duration", true)
		SortAuctionApplySort("owner")
		private.ignoreUpdateEvent = nil
	end

	-- scan the auctions
	TSM.Inventory.WipeAuctionQuantity()

	private.db:TruncateAndBulkInsertStart()
	local expire = math.huge
	for i = #private.indexUpdates.list, 1, -1 do
		local index = private.indexUpdates.list[i]
		local name, texture, stackSize, quality, _, _, _, minBid, _, buyout, bid, highBidder, _, _, _, saleStatus = GetAuctionItemInfo("owner", index)
		local link = name and name ~= "" and GetAuctionItemLink("owner", index)
		if link then
			assert(saleStatus == 0 or saleStatus == 1)
			local duration = GetAuctionItemTimeLeft("owner", index)
			duration = saleStatus == 0 and duration or (time() + duration)
			if saleStatus == 0 then
				if duration == 1 then -- 30 min
					expire = min(expire, time() + 0.5 * 60 * 60)
				elseif duration == 2 then -- 2 hours
					expire = min(expire, time() + 2 * 60 * 60)
				elseif duration == 3 then -- 12 hours
					expire = min(expire, time() + 12 * 60 * 60)
				end
			end
			highBidder = highBidder or ""
			texture = texture or TSMAPI_FOUR.Item.GetTexture(link)
			local itemString = TSMAPI_FOUR.Item.ToItemString(link)
			local currentBid = highBidder ~= "" and bid or minBid
			if saleStatus == 0 then
				TSM.Inventory.ChangeAuctionQuantity(TSMAPI_FOUR.Item.ToBaseItemString(itemString), stackSize)
				local hintInfo = strjoin(SALE_HINT_SEP, TSMAPI_FOUR.Item.GetName(link), itemString, stackSize, buyout)
				TSM.db.char.internalData.auctionSaleHints[hintInfo] = time()
			end
			private.indexUpdates.pending[index] = nil
			tremove(private.indexUpdates.list, i)
			private.db:BulkInsertNewRow(index, itemString, link, texture, name, quality, duration, highBidder, currentBid, buyout, stackSize, saleStatus)
		end
	end
	private.db:BulkInsertEnd()

	if expire ~= math.huge then
		if (TSM.db.factionrealm.internalData.expiringAuction[PLAYER_NAME] or math.huge) > expire then
			TSM.db.factionrealm.internalData.expiringAuction[PLAYER_NAME] = expire
			TSM.TaskList.Expirations.Update()
		end
	end

	TSM:LOG_INFO("Scanned auctions (left=%d)", #private.indexUpdates.list)
	if #private.indexUpdates.list > 0 then
		-- some failed to scan so try again
		TSMAPI_FOUR.Delay.AfterFrame("AUCTION_OWNED_LIST_SCAN", 2, private.AuctionOwnedListUpdateDelayed)
	else
		private.lastScanNum = GetNumAuctionItems("owner")
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.OnCallbackQueryUpdated()
	for _, callback in ipairs(private.callbacks) do
		callback()
	end
end
