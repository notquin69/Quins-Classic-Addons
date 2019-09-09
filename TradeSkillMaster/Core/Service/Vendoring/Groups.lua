-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Groups = TSM.Vendoring:NewPackage("Groups")
local L = TSM.L
local private = {
	buyThreadId = nil,
	sellThreadId = nil,
	tempGroups = {},
	printedBagsFullMsg = false,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Groups.OnInitialize()
	private.buyThreadId = TSMAPI_FOUR.Thread.New("VENDORING_GROUP_BUY", private.BuyThread)
	private.sellThreadId = TSMAPI_FOUR.Thread.New("VENDORING_GROUP_SELL", private.SellThread)
end

function Groups.BuyGroups(groups, callback)
	Groups.StopBuySell()

	wipe(private.tempGroups)
	for _, groupPath in ipairs(groups) do
		tinsert(private.tempGroups, groupPath)
	end
	TSMAPI_FOUR.Thread.SetCallback(private.buyThreadId, callback)
	TSMAPI_FOUR.Thread.Start(private.buyThreadId, private.tempGroups)
end

function Groups.SellGroups(groups, callback)
	Groups.StopBuySell()

	wipe(private.tempGroups)
	for _, groupPath in ipairs(groups) do
		tinsert(private.tempGroups, groupPath)
	end
	TSMAPI_FOUR.Thread.SetCallback(private.sellThreadId, callback)
	TSMAPI_FOUR.Thread.Start(private.sellThreadId, private.tempGroups)
end

function Groups.StopBuySell()
	TSMAPI_FOUR.Thread.Kill(private.buyThreadId)
	TSMAPI_FOUR.Thread.Kill(private.sellThreadId)
end



-- ============================================================================
-- Buy Thread
-- ============================================================================

function private.BuyThread(groups)
	for _, groupPath in ipairs(groups) do
		groups[groupPath] = true
	end

	local itemsToBuy = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
	local itemBuyQuantity = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
	local query = TSM.Vendoring.Buy.CreateMerchantQuery()
		:InnerJoin(TSM.ItemInfo.GetDBForJoin(), "itemString")
		:InnerJoin(TSM.Groups.GetItemDBForJoin(), "itemString")
		:Select("itemString", "groupPath", "numAvailable")
	for _, itemString, groupPath, numAvailable in query:Iterator() do
		if groups[groupPath] then
			local _, operationSettings = TSM.Operations.GetFirstOperationByItem("Vendoring", itemString)
			if operationSettings.enableBuy then
				local numToBuy = private.GetNumToBuy(itemString, operationSettings)
				if numAvailable ~= -1 then
					numToBuy = min(numToBuy, numAvailable)
				end
				if numToBuy > 0 then
					assert(not itemBuyQuantity[itemString])
					tinsert(itemsToBuy, itemString)
					itemBuyQuantity[itemString] = numToBuy
				end
			end
		end
	end
	query:Release()

	for _, itemString in ipairs(itemsToBuy) do
		local numToBuy = itemBuyQuantity[itemString]
		TSM.Vendoring.Buy.BuyItem(itemString, numToBuy)
		TSMAPI_FOUR.Thread.Yield(true)
	end

	TSMAPI_FOUR.Thread.ReleaseSafeTempTable(itemsToBuy)
	TSMAPI_FOUR.Thread.ReleaseSafeTempTable(itemBuyQuantity)
end

function private.GetNumToBuy(itemString, operationSettings)
	local numHave = TSM.Inventory.BagTracking.GetQuantityByAutoBaseItemString(itemString, true)
	if operationSettings.restockSources.bank then
		numHave = numHave + TSMAPI_FOUR.Inventory.GetBankQuantity(itemString) + TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString)
	end
	if operationSettings.restockSources.guild then
		numHave = numHave + TSMAPI_FOUR.Inventory.GetGuildQuantity(itemString)
	end
	if operationSettings.restockSources.ah then
		numHave = numHave + TSMAPI_FOUR.Inventory.GetAuctionQuantity(itemString)
	end
	if operationSettings.restockSources.mail then
		numHave = numHave + TSMAPI_FOUR.Inventory.GetMailQuantity(itemString)
	end
	if operationSettings.restockSources.alts or operationSettings.restockSources.alts_ah then
		local _, alts, _, altsAH = TSMAPI_FOUR.Inventory.GetPlayerTotals(itemString)
		numHave = numHave + (operationSettings.restockSources.alts and alts or 0) + (operationSettings.restockSources.alts_ah and altsAH or 0)
	end
	return max(operationSettings.restockQty - numHave, 0)
end



-- ============================================================================
-- Sell Thread
-- ============================================================================

function private.SellThread(groups)
	private.printedBagsFullMsg = false
	local totalValue = 0
	for _, groupPath in ipairs(groups) do
		for _, _, operationSettings in TSM.Operations.GroupOperationIterator("Vendoring", groupPath) do
			if operationSettings.enableSell then
				if groupPath == TSM.CONST.ROOT_GROUP_PATH then
					-- TODO
				else
					for _, itemString in TSM.Groups.ItemIterator(groupPath) do
						totalValue = totalValue + private.SellItemThreaded(itemString, operationSettings)
					end
				end
			end
		end
	end

	if TSM.db.global.vendoringOptions.displayMoneyCollected then
		TSM:Printf(L["Sold %s worth of items."], TSM.Money.ToString(totalValue))
	end
end

function private.SellItemThreaded(itemString, operationSettings)
	-- calculate the number to sell
	local numToSell = TSM.Inventory.BagTracking.GetQuantityByAutoBaseItemString(itemString, true) - operationSettings.keepQty
	if numToSell <= 0 then
		return 0
	end

	-- check the expires
	if operationSettings.sellAfterExpired > 0 and TSM.Accounting.Auctions.GetNumExpiresSinceSale(itemString) < operationSettings.sellAfterExpired then
		return 0
	end

	-- check the destroy value
	local destroyValue = TSMAPI_FOUR.CustomPrice.GetValue(operationSettings.vsDestroyValue, itemString) or 0
	local maxDestroyValue = TSMAPI_FOUR.CustomPrice.GetValue(operationSettings.vsMaxDestroyValue, itemString) or 0
	if maxDestroyValue > 0 and destroyValue >= maxDestroyValue then
		return 0
	end

	-- check the market value
	local marketValue = TSMAPI_FOUR.CustomPrice.GetValue(operationSettings.vsMarketValue, itemString) or 0
	local maxMarketValue = TSMAPI_FOUR.CustomPrice.GetValue(operationSettings.vsMaxMarketValue, itemString) or 0
	if maxMarketValue > 0 and marketValue >= maxMarketValue then
		return 0
	end

	-- get a list of empty slots which we can use to split items into
	local emptySlotIds = private.GetEmptyBagSlotsThreaded(GetItemFamily(TSMAPI_FOUR.Item.ToItemID(itemString)) or 0)

	-- get a list of slots containing the item we want to sell
	local slotIds = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
	local bagQuery = TSM.Inventory.BagTracking.CreateQuery()
		:Select("slotId", "quantity")
		:GreaterThanOrEqual("bag", 0)
		:LessThanOrEqual("bag", NUM_BAG_SLOTS)
		:Equal("autoBaseItemString", itemString)
		:Equal("isBoA", false)
		:OrderBy("quantity", true)
	if not operationSettings.sellSoulbound then
		bagQuery:Equal("isBoP", false)
	end
	for _, slotId in bagQuery:Iterator() do
		tinsert(slotIds, slotId)
	end
	bagQuery:Release()

	local totalValue = 0
	for _, slotId in ipairs(slotIds) do
		local bag, slot = TSMAPI_FOUR.Util.SplitSlotId(slotId)
		local quantity = TSM.Inventory.BagTracking.GetQuantityBySlotId(slotId)
		if quantity <= numToSell then
			UseContainerItem(bag, slot)
			totalValue = totalValue + ((TSMAPI_FOUR.Item.GetVendorSell(itemString) or 0) * quantity)
			numToSell = numToSell - quantity
		else
			if #emptySlotIds > 0 then
				local splitBag, splitSlot = TSMAPI_FOUR.Util.SplitSlotId(tremove(emptySlotIds, 1))
				SplitContainerItem(bag, slot, numToSell)
				PickupContainerItem(splitBag, splitSlot)
				-- wait for the stack to be split
				TSMAPI_FOUR.Thread.WaitForFunction(private.BagSlotHasItem, splitBag, splitSlot)
				PickupContainerItem(splitBag, splitSlot)
				UseContainerItem(splitBag, splitSlot)
				totalValue = totalValue + ((TSMAPI_FOUR.Item.GetVendorSell(itemString) or 0) * quantity)
			elseif not private.printedBagsFullMsg then
				TSM:Print(L["Could not sell items due to not having free bag space available to split a stack of items."])
				private.printedBagsFullMsg = true
			end
			-- we're done
			numToSell = 0
		end
		if numToSell == 0 then
			break
		end
		TSMAPI_FOUR.Thread.Yield(true)
	end

	TSMAPI_FOUR.Thread.ReleaseSafeTempTable(slotIds)
	TSMAPI_FOUR.Thread.ReleaseSafeTempTable(emptySlotIds)
	return totalValue
end

function private.GetEmptyBagSlotsThreaded(itemFamily)
	local emptySlotIds = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
	local sortvalue = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
	for bag = 0, NUM_BAG_SLOTS do
		-- make sure the item can go in this bag
		local bagFamily = bag ~= 0 and GetItemFamily(GetInventoryItemLink("player", ContainerIDToInventoryID(bag))) or 0
		if bagFamily == 0 or bit.band(itemFamily, bagFamily) > 0 then
			for slot = 1, GetContainerNumSlots(bag) do
				if not GetContainerItemInfo(bag, slot) then
					local slotId = TSMAPI_FOUR.Util.JoinSlotId(bag, slot)
					tinsert(emptySlotIds, slotId)
					-- use special bags first
					sortvalue[slotId] = slotId + (bagFamily > 0 and 0 or 100000)
				end
			end
		end
		TSMAPI_FOUR.Thread.Yield()
	end
	TSMAPI_FOUR.Util.TableSortWithValueLookup(emptySlotIds, sortvalue)
	TSMAPI_FOUR.Thread.ReleaseSafeTempTable(sortvalue)
	return emptySlotIds
end

function private.BagSlotHasItem(bag, slot)
	return GetContainerItemInfo(bag, slot) and true or false
end
