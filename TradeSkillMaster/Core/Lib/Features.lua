-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- This file contains all the code for TSM's standalone features

local _, TSM = ...
local L = TSM.L
local Features = TSM:NewPackage("Features", "AceHook-3.0")
Features.blackMarket = nil
Features.blackMarketTime = nil
local private = {
	isLoaded = {
		vendorBuy = nil,
		auctionSale = nil,
		auctionBuy = nil
	},
	lastPurchase = {},
	prevLineId = nil,
	prevLineResult = nil,
	twitterHookRegistered = nil,
	origChatFrame_OnEvent = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Features.OnEnable()
	if TSM.db.global.coreOptions.auctionSaleEnabled then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", private.FilterSystemMsg)
		-- scanning the auctions the player has posted is very low-priority, so throttle it to at most every 0.5 seconds
		TSM.Inventory.AuctionTracking.RegisterCallback(function()
			TSMAPI_FOUR.Delay.AfterTime("featuresOwnedAuctions", 0.5, private.OnAuctionOwnedListUpdate)
		end)
		private.isLoaded.auctionSale = true
	end
	if TSM.db.global.coreOptions.auctionBuyEnabled then
		Features:Hook("PlaceAuctionBid", private.OnAuctionBidPlaced, true)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", private.FilterSystemMsg)
		private.isLoaded.auctionBuy = true
	end
	if SocialPrefillItemText then
		private.CreateTwitterHooks()
	else
		TSMAPI_FOUR.Event.Register("ADDON_LOADED", function()
			if SocialPrefillItemText then
				private.CreateTwitterHooks()
			end
		end)
	end
	-- setup BMAH scanning
	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		TSMAPI_FOUR.Event.Register("BLACK_MARKET_ITEM_UPDATE", private.ScanBMAH)
	end
	-- setup auction created / cancelled filtering
	local ElvUIChat, ElvUIChatIsEnabled = nil, nil
	if IsAddOnLoaded("ElvUI") and ElvUI then
		ElvUIChat = ElvUI[1]:GetModule("Chat")
		if ElvUI[3].chat.enable then
			ElvUIChatIsEnabled = true
		end
	end
	if ElvUIChatIsEnabled then
		private.origChatFrame_OnEvent = ElvUIChat.ChatFrame_OnEvent
		ElvUIChat.ChatFrame_OnEvent = private.ChatFrame_OnEvent
	else
		private.origChatFrame_OnEvent = ChatFrame_OnEvent
		ChatFrame_OnEvent = private.ChatFrame_OnEvent
	end
end



-- ============================================================================
-- Auction Sale Functions
-- ============================================================================

function private.OnAuctionOwnedListUpdate()
	local INVALID_STACK_SIZE = -1
	-- recycle tables from TSM.db.char.internalData.auctionPrices if we can so we're not creating a ton of garbage
	local freeTables = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, tbl in pairs(TSM.db.char.internalData.auctionPrices) do
		wipe(tbl)
		tinsert(freeTables, tbl)
	end
	wipe(TSM.db.char.internalData.auctionPrices)
	wipe(TSM.db.char.internalData.auctionMessages)
	local auctionPrices = TSMAPI_FOUR.Util.AcquireTempTable()
	local auctionStackSizes = TSMAPI_FOUR.Util.AcquireTempTable()
	local query = TSM.Inventory.AuctionTracking.CreateQuery()
		:Select("itemLink", "stackSize", "buyout")
		:Equal("saleStatus", 0)
		:GreaterThan("buyout", 0)
		:OrderBy("index", true)
	for _, link, stackSize, buyout in query:IteratorAndRelease() do
		auctionPrices[link] = auctionPrices[link] or tremove(freeTables) or {}
		if stackSize ~= auctionStackSizes[link] then
			auctionStackSizes[link] = stackSize
		end
		tinsert(auctionPrices[link], buyout)
	end
	for link, prices in pairs(auctionPrices) do
		local name = TSMAPI_FOUR.Item.GetName(link)
		if auctionStackSizes[link] ~= INVALID_STACK_SIZE then
			sort(prices)
			TSM.db.char.internalData.auctionPrices[link] = prices
			TSM.db.char.internalData.auctionMessages[format(ERR_AUCTION_SOLD_S, name)] = link
		end
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(freeTables)
	TSMAPI_FOUR.Util.ReleaseTempTable(auctionPrices)
	TSMAPI_FOUR.Util.ReleaseTempTable(auctionStackSizes)
end



-- ============================================================================
-- Auction Buy Functions
-- ============================================================================

function private.OnAuctionBidPlaced(_, index, amountPaid)
	local link = GetAuctionItemLink("list", index)
	local name, _, stackSize, _, _, _, _, _, _, buyout = GetAuctionItemInfo("list", index)
	if amountPaid == buyout then
		wipe(private.lastPurchase)
		private.lastPurchase.name = name
		private.lastPurchase.link = link
		private.lastPurchase.stackSize = stackSize
		private.lastPurchase.buyout = buyout
	end
end



-- ============================================================================
-- Twitter Functions
-- ============================================================================

-- most of this code is based on Blizzard's code and inspired by the Disarmament addon
local TSM_ITEM_URL_FORMAT = "|cff3b94d9http://tradeskillmaster.com/items/%d|r"
function private.CreateTwitterHooks()
	if private.twitterHookRegistered then return end
	private.twitterHookRegistered = true
	hooksecurefunc("SocialPrefillItemText", function(itemID, earned, context, name, quality)
		if not TSM.db.global.coreOptions.tsmItemTweetEnabled then return end
		if name == nil or quality == nil then
			local _
			name, _, quality = GetItemInfo(itemID)
		end
		local tsmType, tsmItemId, tsmStackSize, tsmBuyout = strmatch(context or "", "^TSM_([A-Z]+)_(%d+)_(%d+)_(%d+)$")
		tsmItemId = tonumber(tsmItemId)
		tsmStackSize = tonumber(tsmStackSize)
		tsmBuyout = tonumber(tsmBuyout)
		if tsmType and tsmItemId and tsmStackSize and tsmBuyout then
			assert(tsmType == "BUY" or tsmType == "SELL")
			local url = format(TSM_ITEM_URL_FORMAT, tsmItemId)
			local text = nil
			if tsmType == "BUY" then
				text = format(L["I just bought [%s]x%d for %s! %s #TSM4 #warcraft"], name, tsmStackSize, TSM.Money.ToString(tsmBuyout), url)
			elseif tsmType == "SELL" then
				text = format(L["I just sold [%s] for %s! %s #TSM4 #warcraft"], name, TSM.Money.ToString(tsmBuyout), url)
			else
				error("Unknown type") -- should never happen
			end
			SocialPostFrame:SetAttribute("settext", text)
		else
			local prefillText = earned and SOCIAL_ITEM_PREFILL_TEXT_EARNED or SOCIAL_ITEM_PREFILL_TEXT_GENERIC
			local _, _, _, colorString = GetItemQualityColor(quality)
			local text = format(SOCIAL_ITEM_PREFILL_TEXT_ALL, prefillText, format("|c%s[%s]|r", colorString, name), format(TSM_ITEM_URL_FORMAT, itemID))
			SocialPostFrame:SetAttribute("settext", text)
		end
	end)
end



-- ============================================================================
-- Passive Features
-- ============================================================================

function private.ChatFrame_OnEvent(self, event, msg, ...)
	-- surpress auction created / cancelled spam
	if event == "CHAT_MSG_SYSTEM" and (msg == ERR_AUCTION_STARTED or msg == ERR_AUCTION_REMOVED) then
		return
	end
	return private.origChatFrame_OnEvent(self, event, msg, ...)
end

function private.ScanBMAH()
	local numItems = C_BlackMarket.GetNumItems()
	if not numItems then return end
	local items = TSMAPI_FOUR.Util.AcquireTempTable()
	for i = 1, numItems do
		local _, _, quantity, _, _, _, _, _, minBid, minIncr, currBid, _, numBids, timeLeft, itemLink, bmId = C_BlackMarket.GetItemInfoByIndex(i)
		local itemID = TSMAPI_FOUR.Item.ToItemID(itemLink)
		if itemID then
			minBid = floor(minBid / COPPER_PER_GOLD)
			minIncr = floor(minIncr / COPPER_PER_GOLD)
			currBid = floor(currBid / COPPER_PER_GOLD)
			tinsert(items, "[" .. table.concat({ bmId, itemID, quantity, timeLeft, minBid, minIncr, currBid, numBids, time() }, ",") .. "]")
		end
	end
	TSM.Features.blackMarket = "[" .. table.concat(items, ",") .. "]"
	TSM.Features.blackMarketTime = time()
	TSMAPI_FOUR.Util.ReleaseTempTable(items)
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.FilterSystemMsg(_, _, msg, ...)
	local lineID = select(10, ...)
	if lineID ~= private.prevLineId then
		private.prevLineId = lineID
		private.prevLineResult = nil
		local link = TSM.db.char.internalData.auctionMessages and TSM.db.char.internalData.auctionMessages[msg]
		if private.lastPurchase.name and msg == format(ERR_AUCTION_WON_S, private.lastPurchase.name) then
			-- we just bought an auction
			private.prevLineResult = format(L["You won an auction for %sx%d for %s"], private.lastPurchase.link, private.lastPurchase.stackSize, TSM.Money.ToString(private.lastPurchase.buyout, "|cffffffff"))
			local itemId = TSMAPI_FOUR.Item.ToItemID(private.lastPurchase.link)
			if C_Social.IsSocialEnabled() and itemId then
				-- add tweet icon
				local context = format("TSM_BUY_%s_%s_%s", itemId, private.lastPurchase.stackSize, private.lastPurchase.buyout)
				private.prevLineResult = private.prevLineResult .. Social_GetShareItemLink(itemId, context, true)
			end
			return nil, private.prevLineResult, ...
		elseif link then
			-- we may have just sold an auction
			local price = tremove(TSM.db.char.internalData.auctionPrices[link], 1)
			local numAuctions = #TSM.db.char.internalData.auctionPrices[link]
			if not price then
				-- couldn't determine the price, so just replace the link
				private.prevLineResult = format(ERR_AUCTION_SOLD_S, link)
				return nil, private.prevLineResult, ...
			end
			if numAuctions == 0 then -- this was the last auction
				TSM.db.char.internalData.auctionMessages[msg] = nil
			end
			private.prevLineResult = format(L["Your auction of %s has sold for %s!"], link, TSM.Money.ToString(price, "|cffffffff"))
			TSMAPI_FOUR.Sound.PlaySound(TSM.db.global.coreOptions.auctionSaleSound)
			local itemId = TSMAPI_FOUR.Item.ToItemID(link)
			if C_Social.IsSocialEnabled() and itemId then
				-- add tweet icon
				local context = format("TSM_SELL_%s_1_%s", itemId, price)
				private.prevLineResult = private.prevLineResult .. Social_GetShareItemLink(itemId, context, true)
			end
			return nil, private.prevLineResult, ...
		else
			return
		end
	end
end
