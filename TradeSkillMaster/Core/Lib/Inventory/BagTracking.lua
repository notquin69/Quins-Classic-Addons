-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--          http://www.curse.com/addons/wow/tradeskillmaster_warehousing          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local BagTracking = TSM.Inventory:NewPackage("BagTracking")
local private = {
	db = nil,
	bagUpdates = {
		pending = {},
		bagList = {},
		bankList = {},
	},
	bankSlotUpdates = {
		pending = {},
		list = {},
	},
	reagentBankSlotUpdates = {
		pending = {},
		list = {},
	},
	bankOpen = false,
	isFirstBankOpen = true,
	slotIdLocked = {},
	slotIdSoulboundCached = {},
	slotIdIsBoP = {},
	slotIdIsBoA = {},
	callbackQuery = nil,
	callbacks = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function BagTracking.OnInitialize()
	TSMAPI_FOUR.Event.Register("BAG_UPDATE", private.BagUpdateHandler)
	TSMAPI_FOUR.Event.Register("BAG_UPDATE_DELAYED", private.BagUpdateDelayedHandler)
	TSMAPI_FOUR.Event.Register("BANKFRAME_OPENED", private.BankOpenedHandler)
	TSMAPI_FOUR.Event.Register("BANKFRAME_CLOSED", private.BankClosedHandler)
	TSMAPI_FOUR.Event.Register("PLAYERBANKSLOTS_CHANGED", private.BankSlotChangedHandler)
	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		TSMAPI_FOUR.Event.Register("PLAYERREAGENTBANKSLOTS_CHANGED", private.ReagentBankSlotChangedHandler)
	end
	TSMAPI_FOUR.Event.Register("ITEM_LOCKED", private.ItemLockedHandler)
	TSMAPI_FOUR.Event.Register("ITEM_UNLOCKED", private.ItemUnlockedHandler)
	private.db = TSMAPI_FOUR.Database.NewSchema("BAG_TRACKING")
		:AddUniqueNumberField("slotId")
		:AddNumberField("bag")
		:AddNumberField("slot")
		:AddStringField("itemLink")
		:AddStringField("itemString")
		:AddSmartMapField("baseItemString", TSM.Item.GetBaseItemStringMap(), "itemString")
		:AddSmartMapField("autoBaseItemString", TSM.Groups.GetAutoBaseItemStringSmartMap(), "itemString")
		:AddNumberField("itemTexture")
		:AddNumberField("quantity")
		:AddBooleanField("isBoP")
		:AddBooleanField("isBoA")
		:AddBooleanField("usedCharges")
		:AddIndex("slotId")
		:AddIndex("bag")
		:AddIndex("itemString")
		:AddIndex("autoBaseItemString")
		:Commit()
	private.callbackQuery = private.db:NewQuery()
		:SetUpdateCallback(private.OnCallbackQueryUpdated)
end

-- Not all APIs return valid values as of OnInitialize when you first log in, so delay until OnEnable
function BagTracking.OnEnable()
	-- we'll scan all the bags and reagent bank right away, so wipe the existing quantities
	TSM.Inventory.WipeBagQuantity()
	TSM.Inventory.WipeReagentBankQuantity()

	-- WoW does not fire an update event for the backpack when you log in, so trigger one
	private.BagUpdateHandler(nil, 0)
	private.BagUpdateDelayedHandler()
	-- trigger an update event for all bank (initial container) and reagent bank slots since we won't get one otherwise on login
	assert(GetContainerNumSlots(BANK_CONTAINER) == NUM_BANKGENERIC_SLOTS)
	for slot = 1, GetContainerNumSlots(BANK_CONTAINER) do
		private.BankSlotChangedHandler(nil, slot)
	end
	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		for slot = 1, GetContainerNumSlots(REAGENTBANK_CONTAINER) do
			private.ReagentBankSlotChangedHandler(nil, slot)
		end
	end
end

function BagTracking.RegisterCallback(callback)
	tinsert(private.callbacks, callback)
end

function BagTracking.CreateQuery()
	return private.db:NewQuery()
end

function BagTracking.ForceBankQuantityDeduction(itemString, quantity)
	if private.bankOpen then
		return
	end
	private.db:SetQueryUpdatesPaused(true)
	local query = private.db:NewQuery()
		:Equal("itemString", itemString)
		:Or()
			:Equal("bag", BANK_CONTAINER)
			:And()
				:GreaterThan("bag", NUM_BAG_SLOTS)
				:LessThanOrEqual("bag", NUM_BAG_SLOTS + NUM_BANKBAGSLOTS)
			:End()
		:End()
	for _, row in query:Iterator() do
		if quantity > 0 then
			local rowQuantity, rowBag = row:GetFields("quantity", "bag")
			if rowQuantity <= quantity then
				TSM.Inventory.ChangeBagItemTotal(rowBag, itemString, -rowQuantity)
				private.db:DeleteRow(row)
				quantity = quantity - rowQuantity
			else
				row:SetField("quantity", rowQuantity - quantity)
					:Update()
				TSM.Inventory.ChangeBagItemTotal(rowBag, itemString, -quantity)
				quantity = 0
			end
		end
	end
	query:Release()
	private.db:SetQueryUpdatesPaused(false)
end

function BagTracking.GetQuantityByAutoBaseItemString(autoBaseItemString, includeBoP, includeBoA)
	local query = private.db:NewQuery()
		:Equal("autoBaseItemString", autoBaseItemString)
		:GreaterThanOrEqual("slotId", TSMAPI_FOUR.Util.JoinSlotId(0, 1))
		:LessThanOrEqual("slotId", TSMAPI_FOUR.Util.JoinSlotId(NUM_BAG_SLOTS + 1, 0))
	if not includeBoP then
		query:Equal("isBoP", false)
	end
	if not includeBoA then
		query:Equal("isBoA", false)
	end
	local result = query:Sum("quantity")
	query:Release()
	return result or 0
end

function BagTracking.GetBankQuantityByAutoBaseItemString(autoBaseItemString, includeBoP, includeBoA)
	local query = private.db:NewQuery()
		:Equal("autoBaseItemString", autoBaseItemString)
		:Or()
			:Equal("bag", BANK_CONTAINER)
			:And()
				:GreaterThan("bag", NUM_BAG_SLOTS)
				:LessThanOrEqual("bag", NUM_BAG_SLOTS + NUM_BANKBAGSLOTS)
			:End()
	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC and IsReagentBankUnlocked() then
		query:Equal("bag", REAGENTBANK_CONTAINER)
	end
	query:End() -- end the Or()
	if not includeBoP then
		query:Equal("isBoP", false)
	end
	if not includeBoA then
		query:Equal("isBoA", false)
	end
	local result = query:Sum("quantity")
	query:Release()
	return result or 0
end

function BagTracking.GetQuantityBySlotId(slotId)
	return private.db:GetUniqueRowField("slotId", slotId, "quantity")
end

function BagTracking.GetItemStringBySlotId(slotId)
	return private.db:GetUniqueRowField("slotId", slotId, "itemString")
end



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

function TSMAPI_FOUR.Inventory.IsSoulbound(bag, slot)
	local slotId = TSMAPI_FOUR.Util.JoinSlotId(bag, slot)
	if private.slotIdSoulboundCached[slotId] then
		return private.slotIdIsBoP[slotId], private.slotIdIsBoA[slotId]
	end
	if not TSMScanTooltip then
		CreateFrame("GameTooltip", "TSMScanTooltip", UIParent, "GameTooltipTemplate")
	end

	TSMScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	TSMScanTooltip:ClearLines()

	if GetContainerItemID(bag, slot) == TSMAPI_FOUR.Item.ToItemID(TSM.CONST.PET_CAGE_ITEMSTRING) then
		-- battle pets are never BoP or BoA
		private.slotIdSoulboundCached[slotId] = true
		private.slotIdIsBoP[slotId] = false
		private.slotIdIsBoA[slotId] = false
		return false, false
	end

	-- set TSMScanTooltip to show the inventory item
	if bag == BANK_CONTAINER then
		TSMScanTooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(slot))
	elseif bag == REAGENTBANK_CONTAINER then
		TSMScanTooltip:SetInventoryItem("player", ReagentBankButtonIDToInvSlotID(slot))
	else
		TSMScanTooltip:SetBagItem(bag, slot)
	end

	-- scan the tooltip
	local numLines = TSMScanTooltip:NumLines()
	if numLines < 1 then
		-- the tooltip didn't fully load or there's nothing in this slot
		return nil, nil
	end
	local isBOP, isBOA = false, false
	for id = 2, numLines do
		local text = private.GetTooltipText(_G["TSMScanTooltipTextLeft"..id])
		if text then
			if (text == ITEM_BIND_ON_PICKUP and id < 4) or text == ITEM_SOULBOUND or text == ITEM_BIND_QUEST then
				isBOP = true
				break
			elseif (text == ITEM_ACCOUNTBOUND or text == ITEM_BIND_TO_ACCOUNT or text == ITEM_BIND_TO_BNETACCOUNT or text == ITEM_BNETACCOUNTBOUND) then
				isBOA = true
				break
			end
		end
	end
	private.slotIdSoulboundCached[slotId] = true
	private.slotIdIsBoP[slotId] = isBOP
	private.slotIdIsBoA[slotId] = isBOA
	return isBOP, isBOA
end

function TSMAPI_FOUR.Inventory.HasUsedCharges(bag, slot)
	-- figure out if this item has a max number of charges
	local itemId = GetContainerItemID(bag, slot)
	if not itemId or itemId == TSMAPI_FOUR.Item.ToItemID(TSM.CONST.PET_CAGE_ITEMSTRING) then
		return false
	end
	if not TSMScanTooltip then
		CreateFrame("GameTooltip", "TSMScanTooltip", UIParent, "GameTooltipTemplate")
	end

	TSMScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	TSMScanTooltip:ClearLines()
	TSMScanTooltip:SetItemByID(itemId)

	local maxCharges = private.GetScanTooltipCharges()
	if not maxCharges then
		return false
	end

	-- set TSMScanTooltip to show the inventory item
	if bag == BANK_CONTAINER then
		TSMScanTooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(slot))
	elseif bag == REAGENTBANK_CONTAINER then
		TSMScanTooltip:SetInventoryItem("player", ReagentBankButtonIDToInvSlotID(slot))
	else
		TSMScanTooltip:SetBagItem(bag, slot)
	end

	-- check if there are used charges
	if maxCharges and private.GetScanTooltipCharges() ~= maxCharges then
		return true
	end
	return false
end

function TSMAPI_FOUR.Inventory.BagIterator(autoBaseItems, includeBoP, includeBoA, onlyUnused)
	local query = private.db:NewQuery()
		:GreaterThanOrEqual("slotId", TSMAPI_FOUR.Util.JoinSlotId(0, 1))
		:LessThanOrEqual("slotId", TSMAPI_FOUR.Util.JoinSlotId(NUM_BAG_SLOTS + 1, 0))
		:OrderBy("slotId", true)
		:Select("bag", "slot", autoBaseItems and "autoBaseItemString" or "itemString", "quantity")
	if not includeBoP then
		query:Equal("isBoP", false)
	end
	if not includeBoA then
		query:Equal("isBoA", false)
	end
	if onlyUnused then
		query:Equal("usedCharges", false)
	end
	return query:IteratorAndRelease()
end

function TSMAPI_FOUR.Inventory.BankIterator(autoBaseItems, includeBoP, includeBoA, includeReagents, onlyUnused)
	local query = private.db:NewQuery()
		:OrderBy("slotId", true)
		:Select("bag", "slot", autoBaseItems and "autoBaseItemString" or "itemString", "quantity")
		:Or()
			:Equal("bag", BANK_CONTAINER)
			:And()
				:GreaterThan("bag", NUM_BAG_SLOTS)
				:LessThanOrEqual("bag", NUM_BAG_SLOTS + NUM_BANKBAGSLOTS)
			:End()
	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC and includeReagents and IsReagentBankUnlocked() then
		query:Equal("bag", REAGENTBANK_CONTAINER)
	end
	query:End() -- end the Or()
	if not includeBoP then
		query:Equal("isBoP", false)
	end
	if not includeBoA then
		query:Equal("isBoA", false)
	end
	if onlyUnused then
		query:Equal("usedCharges", false)
	end
	return query:IteratorAndRelease()
end

function TSMAPI_FOUR.Inventory.IsBagSlotLocked(bag, slot)
	return private.slotIdLocked[TSMAPI_FOUR.Util.JoinSlotId(bag, slot)]
end

--- Check if an item will go in a bag.
-- @tparam string link The item
-- @tparam number bag The bag index
-- @treturn boolean Whether or not the item will go in the bag
function TSMAPI_FOUR.Inventory.ItemWillGoInBag(link, bag)
	if not link or not bag then
		return
	end
	if bag == BACKPACK_CONTAINER or bag == BANK_CONTAINER then
		return true
	elseif bag == REAGENTBANK_CONTAINER then
		return TSMAPI_FOUR.Item.IsCraftingReagent(link)
	end
	local itemFamily = GetItemFamily(link) or 0
	if TSMAPI_FOUR.Item.GetClassId(link) == LE_ITEM_CLASS_CONTAINER then
		-- bags report their family as what can go inside them, not what they can go inside
		itemFamily = 0
	end
	local _, bagFamily = GetContainerNumFreeSlots(bag)
	if not bagFamily then
		return
	end
	return bagFamily == 0 or bit.band(itemFamily, bagFamily) > 0
end



-- ============================================================================
-- Event Handlers
-- ============================================================================

function private.BankOpenedHandler()
	if private.isFirstBankOpen then
		private.isFirstBankOpen = false
		-- this is the first time opening the bank so we'll scan all the items so wipe our existing quantities
		TSM.Inventory.WipeBankQuantity()
	end
	private.bankOpen = true
	private.BagUpdateDelayedHandler()
	private.BankSlotUpdateDelayed()
end

function private.BankClosedHandler()
	private.bankOpen = false
end

local function SlotIdSoulboundCachedFilter(slotId, _, bag)
	return TSMAPI_FOUR.Util.SplitSlotId(slotId) == bag
end
function private.BagUpdateHandler(_, bag)
	-- clear the soulbound cache for everything in this bag
	TSMAPI_FOUR.Util.TableFilter(private.slotIdSoulboundCached, SlotIdSoulboundCachedFilter, bag)
	if private.bagUpdates.pending[bag] then
		return
	end
	private.bagUpdates.pending[bag] = true
	if bag >= BACKPACK_CONTAINER and bag <= NUM_BAG_SLOTS then
		tinsert(private.bagUpdates.bagList, bag)
	elseif bag == BANK_CONTAINER or (bag > NUM_BAG_SLOTS and bag <= NUM_BAG_SLOTS + NUM_BANKBAGSLOTS) then
		tinsert(private.bagUpdates.bankList, bag)
	else
		error("Unexpected bag: "..tostring(bag))
	end
end

function private.BagUpdateDelayedHandler()
	private.db:SetQueryUpdatesPaused(true)

	-- scan any pending bags
	for i = #private.bagUpdates.bagList, 1, -1 do
		local bag = private.bagUpdates.bagList[i]
		if private.ScanBagOrBank(bag) then
			private.bagUpdates.pending[bag] = nil
			tremove(private.bagUpdates.bagList, i)
		end
	end
	if #private.bagUpdates.bagList > 0 then
		-- some failed to scan so try again
		TSMAPI_FOUR.Delay.AfterFrame("bagBankScan", 2, private.BagUpdateDelayedHandler)
	end

	if private.bankOpen then
		-- scan any pending bank bags
		for i = #private.bagUpdates.bankList, 1, -1 do
			local bag = private.bagUpdates.bankList[i]
			if private.ScanBagOrBank(bag) then
				private.bagUpdates.pending[bag] = nil
				tremove(private.bagUpdates.bankList, i)
			end
		end
		if #private.bagUpdates.bankList > 0 then
			-- some failed to scan so try again
			TSMAPI_FOUR.Delay.AfterFrame("bagBankScan", 2, private.BagUpdateDelayedHandler)
		end
	end

	private.db:SetQueryUpdatesPaused(false)
end

function private.BankSlotChangedHandler(_, slot)
	if slot > NUM_BANKGENERIC_SLOTS then
		private.BagUpdateHandler(nil, slot - NUM_BANKGENERIC_SLOTS)
		return
	end
	-- clear the soulbound cache for this slot
	private.slotIdSoulboundCached[TSMAPI_FOUR.Util.JoinSlotId(BANK_CONTAINER, slot)] = nil
	if private.bankSlotUpdates.pending[slot] then
		return
	end
	private.bankSlotUpdates.pending[slot] = true
	tinsert(private.bankSlotUpdates.list, slot)
	TSMAPI_FOUR.Delay.AfterFrame("bankSlotScan", 2, private.BankSlotUpdateDelayed)
end

-- this is not a WoW event, but we fake it based on a delay from private.BankSlotChangedHandler
function private.BankSlotUpdateDelayed()
	if not private.bankOpen then
		return
	end
	private.db:SetQueryUpdatesPaused(true)

	-- scan any pending slots
	for i = #private.bankSlotUpdates.list, 1, -1 do
		local slot = private.bankSlotUpdates.list[i]
		if private.ScanBankSlot(slot) then
			private.bankSlotUpdates.pending[slot] = nil
			tremove(private.bankSlotUpdates.list, i)
		end
	end
	if #private.bankSlotUpdates.list > 0 then
		-- some failed to scan so try again
		TSMAPI_FOUR.Delay.AfterFrame("bankSlotScan", 2, private.BankSlotUpdateDelayed)
	end

	private.db:SetQueryUpdatesPaused(false)
end

function private.ReagentBankSlotChangedHandler(_, slot)
	-- clear the soulbound cache for this slot
	private.slotIdSoulboundCached[TSMAPI_FOUR.Util.JoinSlotId(REAGENTBANK_CONTAINER, slot)] = nil
	if private.reagentBankSlotUpdates.pending[slot] then
		return
	end
	private.reagentBankSlotUpdates.pending[slot] = true
	tinsert(private.reagentBankSlotUpdates.list, slot)
	TSMAPI_FOUR.Delay.AfterFrame("reagentBankSlotScan", 2, private.ReagentBankSlotUpdateDelayed)
end

-- this is not a WoW event, but we fake it based on a delay from private.ReagentBankSlotChangedHandler
function private.ReagentBankSlotUpdateDelayed()
	private.db:SetQueryUpdatesPaused(true)

	-- scan any pending slots
	for i = #private.reagentBankSlotUpdates.list, 1, -1 do
		local slot = private.reagentBankSlotUpdates.list[i]
		if private.ScanReagentBankSlot(slot) then
			private.reagentBankSlotUpdates.pending[slot] = nil
			tremove(private.reagentBankSlotUpdates.list, i)
		end
	end
	if #private.reagentBankSlotUpdates.list > 0 then
		-- some failed to scan so try again
		TSMAPI_FOUR.Delay.AfterFrame("reagentBankSlotScan", 2, private.ReagentBankSlotUpdateDelayed)
	end

	private.db:SetQueryUpdatesPaused(false)
end

function private.ItemLockedHandler(_, bag, slot)
	if not slot then
		return
	end
	private.slotIdLocked[TSMAPI_FOUR.Util.JoinSlotId(bag, slot)] = true
end

function private.ItemUnlockedHandler(_, bag, slot)
	if not slot then
		return
	end
	private.slotIdLocked[TSMAPI_FOUR.Util.JoinSlotId(bag, slot)] = nil
end



-- ============================================================================
-- Scanning Functions
-- ============================================================================

function private.ScanBagOrBank(bag)
	local numSlots = GetContainerNumSlots(bag)
	private.RemoveExtraSlots(bag, numSlots)
	local result = true
	for slot = 1, numSlots do
		if not private.ScanBagSlot(bag, slot) then
			result = false
		end
	end
	return result
end

function private.ScanBankSlot(slot)
	return private.ScanBagSlot(BANK_CONTAINER, slot)
end

function private.ScanReagentBankSlot(slot)
	return private.ScanBagSlot(REAGENTBANK_CONTAINER, slot)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.RemoveExtraSlots(bag, numSlots)
	-- the number of slots of this bag may have changed, in which case we should remove any higher ones from our DB
	local query = private.db:NewQuery()
		:Equal("bag", bag)
		:GreaterThan("slot", numSlots)
	for _, row in query:Iterator() do
		local baseItemString, quantity = row:GetFields("baseItemString", "quantity")
		TSM.Inventory.ChangeBagItemTotal(bag, baseItemString, -quantity)
		private.db:DeleteRow(row)
	end
	query:Release()
end

function private.ScanBagSlot(bag, slot)
	local texture, quantity, _, _, _, _, link, _, _, itemId = GetContainerItemInfo(bag, slot)
	if quantity and not itemId then
		-- we are pending item info for this slot so try again later to scan it
		return false
	elseif quantity == 0 then
		-- this item is going away, so try again later to scan it
		return false
	end
	local baseItemString = link and TSMAPI_FOUR.Item.ToBaseItemString(link)
	local slotId = TSMAPI_FOUR.Util.JoinSlotId(bag, slot)
	local row = private.db:GetUniqueRow("slotId", slotId)
	if baseItemString then
		local isBoP, isBoA = nil, nil
		if row then
			if row:GetField("itemLink") == link then
				-- the item didn't change, so use the previous values
				isBoP, isBoA = row:GetFields("isBoP", "isBoA")
			else
				isBoP, isBoA = TSMAPI_FOUR.Inventory.IsSoulbound(bag, slot)
				if isBoP == nil then
					TSM:LOG_ERR("Failed to get soulbound info for %d,%d (%s)", bag, slot, link or "?")
					return false
				end
			end
			-- remove the old row from the item totals
			local oldBaseItemString, oldQuantity = row:GetFields("baseItemString", "quantity")
			TSM.Inventory.ChangeBagItemTotal(bag, oldBaseItemString, -oldQuantity)
		else
			isBoP, isBoA = TSMAPI_FOUR.Inventory.IsSoulbound(bag, slot)
			if isBoP == nil then
				TSM:LOG_ERR("Failed to get soulbound info for %d,%d (%s)", bag, slot, link or "?")
				return false
			end
			-- there was nothing here previously so create a new row
			row = private.db:NewRow()
				:SetField("slotId", slotId)
				:SetField("bag", bag)
				:SetField("slot", slot)
		end
		-- update the row
		row:SetField("itemLink", link)
			:SetField("itemString", TSMAPI_FOUR.Item.ToItemString(link))
			:SetField("itemTexture", texture or TSMAPI_FOUR.Item.GetTexture(link))
			:SetField("quantity", quantity)
			:SetField("isBoP", isBoP)
			:SetField("isBoA", isBoA)
			:SetField("usedCharges", TSMAPI_FOUR.Inventory.HasUsedCharges(bag, slot))
			:CreateOrUpdateAndRelease()
		-- add to the item totals
		TSM.Inventory.ChangeBagItemTotal(bag, baseItemString, quantity)
	elseif row then
		-- nothing here now so delete the row and remove from the item totals
		local oldBaseItemString, oldQuantity = row:GetFields("baseItemString", "quantity")
		TSM.Inventory.ChangeBagItemTotal(bag, oldBaseItemString, -oldQuantity)
		private.db:DeleteRow(row)
		row:Release()
	end
	return true
end

function private.GetScanTooltipCharges()
	for id = 2, TSMScanTooltip:NumLines() do
		local text = private.GetTooltipText(_G["TSMScanTooltipTextLeft"..id])
		local num = text and strmatch(text, "%d+")
		local chargesStr = gsub(ITEM_SPELL_CHARGES, "%%d", "%%d+")
		if strfind(chargesStr, ":") then
			if num == 1 then
				chargesStr = gsub(chargesStr, "\1244(.+):.+;", "%1")
			else
				chargesStr = gsub(chargesStr, "\1244.+:(.+);", "%1")
			end
		end

		local maxCharges = text and strmatch(text, "^"..chargesStr.."$")

		if maxCharges then
			return maxCharges
		end
	end
end

function private.GetTooltipText(text)
	local textStr = strtrim(text and text:GetText() or "")
	if textStr == "" then return end

	local r, g, b = text:GetTextColor()
	return textStr, floor(r * 256), floor(g * 256), floor(b * 256)
end

function private.OnCallbackQueryUpdated()
	for _, callback in ipairs(private.callbacks) do
		callback()
	end
end
