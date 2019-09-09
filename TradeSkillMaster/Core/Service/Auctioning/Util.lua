-- ------------------------------------------------------------------------------ --
--                           TradeSkillMaster_Auctioning                          --
--           http://www.curse.com/addons/wow/tradeskillmaster_auctioning          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Util = TSM.Auctioning:NewPackage("Util")
local private = { priceCache = {} }
local INVALID_PRICE = {}
local VALID_PRICE_KEYS = {
	minPrice = true,
	normalPrice = true,
	maxPrice = true,
	undercut = true,
	cancelRepostThreshold = true,
	priceReset = true,
	aboveMax = true,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Util.GetPrice(key, operation, itemString)
	assert(VALID_PRICE_KEYS[key])
	local cacheKey = key..tostring(operation)..itemString
	if private.priceCache.updateTime ~= GetTime() then
		wipe(private.priceCache)
		private.priceCache.updateTime = GetTime()
	end
	if not private.priceCache[cacheKey] then
		if key == "normalPrice" then
			local normalPrice = TSMAPI_FOUR.CustomPrice.GetValue(operation.normalPrice, itemString)
			if normalPrice and TSM.db.global.auctioningOptions.roundNormalPrice then
				-- round up to the nearest gold
				normalPrice = ceil(normalPrice / COPPER_PER_GOLD) * COPPER_PER_GOLD
			end
			private.priceCache[cacheKey] = normalPrice
		elseif key == "aboveMax" or key == "priceReset" then
			-- redirect to the selected price (if applicable)
			local priceKey = operation[key]
			if VALID_PRICE_KEYS[priceKey] then
				private.priceCache[cacheKey] = Util.GetPrice(priceKey, operation, itemString)
			end
		else
			private.priceCache[cacheKey] = TSMAPI_FOUR.CustomPrice.GetValue(operation[key], itemString)
		end
		private.priceCache[cacheKey] = private.priceCache[cacheKey] or INVALID_PRICE
	end
	if private.priceCache[cacheKey] == INVALID_PRICE then
		return nil
	end
	return private.priceCache[cacheKey]
end

function Util.GetLowestAuction(query, itemString, operationSettings, resultTbl)
	local hasInvalidSeller = nil
	local ignoreWhitelist = nil
	local lowestItemBuyout = nil
	local lowestAuction = nil
	for _, record in query:Iterator() do
		if not private.ShouldIgnoreAuctionRecord(record, itemString, operationSettings) then
			local itemBuyout = record:GetField("itemBuyout")
			assert(itemBuyout and itemBuyout > 0)
			lowestItemBuyout = lowestItemBuyout or itemBuyout
			if itemBuyout == lowestItemBuyout then
				local seller = record:GetField("seller")
				local temp = TSMAPI_FOUR.Util.AcquireTempTable()
				temp.buyout = itemBuyout
				temp.bid = record:GetField("itemDisplayedBid")
				temp.seller = seller
				temp.isWhitelist = TSM.db.factionrealm.auctioningOptions.whitelist[strlower(seller)] and true or false
				temp.isPlayer = TSMAPI_FOUR.PlayerInfo.IsPlayer(seller, true, true, true)
				if not temp.isWhitelist and not temp.isPlayer then
					-- there is a non-whitelisted competitor, so we don't care if a whitelisted competitor also posts at this price
					ignoreWhitelist = true
				end
				if seller == "?" and next(TSM.db.factionrealm.auctioningOptions.whitelist) then
					hasInvalidSeller = true
				end
				if operationSettings.blacklist then
					for _, player in TSMAPI_FOUR.Util.VarargIterator(strsplit(",", operationSettings.blacklist)) do
						if strlower(strtrim(player)) == strlower(seller) then
							temp.isBlacklist = true
						end
					end
				end
				if not lowestAuction then
					lowestAuction = temp
				elseif private.LowestAuctionCompare(temp, lowestAuction) then
					TSMAPI_FOUR.Util.ReleaseTempTable(lowestAuction)
					lowestAuction = temp
				else
					TSMAPI_FOUR.Util.ReleaseTempTable(temp)
				end
			end
		end
	end
	if not lowestAuction then
		return false
	end
	for k, v in pairs(lowestAuction) do
		resultTbl[k] = v
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(lowestAuction)
	if resultTbl.isWhitelist and ignoreWhitelist then
		resultTbl.isWhitelist = false
	end
	resultTbl.hasInvalidSeller = hasInvalidSeller
	return true
end

function Util.GetPlayerAuctionCount(query, itemString, operationSettings, findBid, findBuyout, findStackSize)
	local quantity = 0
	for _, record in query:Iterator() do
		if not private.ShouldIgnoreAuctionRecord(record, itemString, operationSettings) then
			if record:GetField("itemDisplayedBid") == findBid and record:GetField("itemBuyout") == findBuyout and record:GetField("stackSize") == findStackSize and TSMAPI_FOUR.PlayerInfo.IsPlayer(record:GetField("seller"), true, true, true) then
				quantity = quantity + 1
			end
		end
	end
	return quantity
end

function Util.GetPlayerLowestBuyout(query, itemString, operationSettings)
	local lowestItemBuyout = nil
	for _, record in query:Iterator() do
		if not lowestItemBuyout and not private.ShouldIgnoreAuctionRecord(record, itemString, operationSettings) and TSMAPI_FOUR.PlayerInfo.IsPlayer(record:GetField("seller"), true, true, true) then
			lowestItemBuyout = record:GetField("itemBuyout")
		end
	end
	return lowestItemBuyout
end

function Util.IsPlayerOnlySeller(query, itemString, operationSettings)
	local isOnly = true
	for _, record in query:Iterator() do
		if isOnly and not private.ShouldIgnoreAuctionRecord(record, itemString, operationSettings) and not TSMAPI_FOUR.PlayerInfo.IsPlayer(record:GetField("seller"), true, true, true) then
			isOnly = false
		end
	end
	return isOnly
end

function Util.GetNextLowestItemBuyout(query, itemString, lowestItemBuyout, operationSettings)
	local nextLowestItemBuyout = nil
	for _, record in query:Iterator() do
		local itemBuyout = record:GetField("itemBuyout")
		if not nextLowestItemBuyout and not private.ShouldIgnoreAuctionRecord(record, itemString, operationSettings) and itemBuyout > lowestItemBuyout then
			nextLowestItemBuyout = itemBuyout
		end
	end
	return nextLowestItemBuyout
end

function Util.GetQueueStatus(query)
	local numProcessed, numConfirmed, numFailed, totalNum = 0, 0, 0, 0
	query:OrderBy("index", true)
	for _, row in query:Iterator() do
		local rowNumStacks, rowNumProcessed, rowNumConfirmed, rowNumFailed = row:GetFields("numStacks", "numProcessed", "numConfirmed", "numFailed")
		totalNum = totalNum + rowNumStacks
		numProcessed = numProcessed + rowNumProcessed
		numConfirmed = numConfirmed + rowNumConfirmed
		numFailed = numFailed + rowNumFailed
	end
	query:Release()
	return numProcessed, numConfirmed, numFailed, totalNum
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ShouldIgnoreAuctionRecord(record, itemString, operationSettings)
	if record:GetField("timeLeft") <= operationSettings.ignoreLowDuration then
		-- ignoring low duration
		return true
	elseif operationSettings.matchStackSize and record:GetField("stackSize") ~= operationSettings.stackSize then
		-- matching stack size
		return true
	elseif operationSettings.priceReset == "ignore" and record:GetField("itemBuyout") then
		local minPrice = Util.GetPrice("minPrice", operationSettings, itemString)
		if minPrice and record:GetField("itemBuyout") <= minPrice then
			-- ignoring auctions below threshold
			return true
		end
	end
	return false
end

function private.LowestAuctionCompare(a, b)
	if a.isBlacklist ~= b.isBlacklist then
		return a.isBlacklist
	end
	if a.isWhitelist ~= b.isWhitelist then
		return a.isWhitelist
	end
	if a.isPlayer ~= b.isPlayer then
		return a.isPlayer
	end
	return tostring(a) < tostring(b)
end
