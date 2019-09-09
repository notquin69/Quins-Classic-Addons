-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Destroying = TSM:NewPackage("Destroying")
local private = {
	combineThread = nil,
	destroyThread = nil,
	destroyThreadRunning = false,
	canDestroyCache = {},
	destroyQuantityCache = {},
	pendingCombines = {},
	newBagUpdate = false,
	bagUpdateCallback = nil,
	pendingSpellId = nil,
	didAutoShow = false,
	ignoreDB = nil,
	destroyInfoDB = nil,
}
local SPELL_IDS = {
	milling = 51005,
	prospect = 31252,
	disenchant = 13262,
}
local ITEM_SUB_CLASS_METAL_AND_STONE = 7
local ITEM_SUB_CLASS_HERB = 9
local TARGET_SLOT_ID_MULTIPLIER = 1000000
local GEM_CHIPS = {
	["i:129099"] = "i:129100",
	["i:130200"] = "i:129100",
	["i:130201"] = "i:129100",
	["i:130202"] = "i:129100",
	["i:130203"] = "i:129100",
	["i:130204"] = "i:129100",
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Destroying.OnInitialize()
	private.combineThread = TSMAPI_FOUR.Thread.New("COMBINE_STACKS", private.CombineThread)
	private.destroyThread = TSMAPI_FOUR.Thread.New("DESTROY", private.DestroyThread)
	TSM.Inventory.BagTracking.RegisterCallback(private.UpdateBagDB)

	private.ignoreDB = TSMAPI_FOUR.Database.NewSchema("DESTROYING_IGNORE")
		:AddUniqueStringField("itemString")
		:AddBooleanField("ignoreSession")
		:AddBooleanField("ignorePermanent")
		:Commit()
	private.ignoreDB:BulkInsertStart()
	local used = TSMAPI_FOUR.Util.AcquireTempTable()
	for itemString in pairs(TSM.db.global.userData.destroyingIgnore) do
		itemString = TSMAPI_FOUR.Item.ToItemString(itemString)
		if not used[itemString] then
			used[itemString] = true
			private.ignoreDB:BulkInsertNewRow(itemString, false, true)
		end
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(used)
	private.ignoreDB:BulkInsertEnd()

	private.destroyInfoDB = TSMAPI_FOUR.Database.NewSchema("DESTROYING_INFO")
		:AddUniqueStringField("itemString")
		:AddNumberField("minQuantity")
		:AddNumberField("spellId")
		:Commit()

	TSMAPI_FOUR.Event.Register("UNIT_SPELLCAST_START", private.SpellCastEventHandler)
	TSMAPI_FOUR.Event.Register("UNIT_SPELLCAST_INTERRUPTED", private.SpellCastEventHandler)
	TSMAPI_FOUR.Event.Register("UNIT_SPELLCAST_SUCCEEDED", private.SpellCastEventHandler)
	TSMAPI_FOUR.Event.Register("UNIT_SPELLCAST_FAILED", private.SpellCastEventHandler)
end

function Destroying.SetBagUpdateCallback(callback)
	assert(not private.bagUpdateCallback)
	private.bagUpdateCallback = callback
end

function Destroying.CreateBagQuery()
	return TSM.Inventory.BagTracking.CreateQuery()
		:LeftJoin(private.ignoreDB, "itemString")
		:InnerJoin(private.destroyInfoDB, "itemString")
		:InnerJoin(TSM.ItemInfo.GetDBForJoin(), "itemString")
		:NotEqual("ignoreSession", true)
		:NotEqual("ignorePermanent", true)
		:GreaterThanOrEqual("quantity", TSM.CONST.OTHER_FIELD_QUERY_PARAM, "minQuantity")
end

function Destroying.CanCombine()
	return #private.pendingCombines > 0
end

function Destroying.GetCombineThread()
	return private.combineThread
end

function Destroying.GetDestroyThread()
	return private.destroyThread
end

function Destroying.KillDestroyThread()
	TSMAPI_FOUR.Thread.Kill(private.destroyThread)
	private.destroyThreadRunning = false
end

function Destroying.IgnoreItemSession(itemString)
	local row = private.ignoreDB:GetUniqueRow("itemString", itemString)
	if row then
		assert(not row:GetField("ignoreSession"))
		row:SetField("ignoreSession", true)
		row:Update()
		row:Release()
	else
		private.ignoreDB:NewRow()
			:SetField("itemString", itemString)
			:SetField("ignoreSession", true)
			:SetField("ignorePermanent", false)
			:Create()
	end
end

function Destroying.IgnoreItemPermanent(itemString)
	assert(not TSM.db.global.userData.destroyingIgnore[itemString])
	TSM.db.global.userData.destroyingIgnore[itemString] = true

	local row = private.ignoreDB:GetUniqueRow("itemString", itemString)
	if row then
		assert(not row:GetField("ignorePermanent"))
		row:SetField("ignorePermanent", true)
		row:Update()
		row:Release()
	else
		private.ignoreDB:NewRow()
			:SetField("itemString", itemString)
			:SetField("ignoreSession", false)
			:SetField("ignorePermanent", true)
			:Create()
	end
end

function Destroying.ForgetIgnoreItemPermanent(itemString)
	assert(TSM.db.global.userData.destroyingIgnore[itemString])
	TSM.db.global.userData.destroyingIgnore[itemString] = nil

	local row = private.ignoreDB:GetUniqueRow("itemString", itemString)
	assert(row and row:GetField("ignorePermanent"))
	if row:GetField("ignoreSession") then
		row:SetField("ignorePermanent", false)
		row:Update()
	else
		private.ignoreDB:DeleteRow(row)
	end
	row:Release()
end

function Destroying.CreateIgnoreQuery()
	return private.ignoreDB:NewQuery()
		:InnerJoin(TSM.ItemInfo.GetDBForJoin(), "itemString")
		:Equal("ignorePermanent", true)
		:OrderBy("name", true)
end



-- ============================================================================
-- Combine Stacks Thread
-- ============================================================================

function private.CombineThread()
	while Destroying.CanCombine() do
		for _, combineSlotId in ipairs(private.pendingCombines) do
			local sourceBag, sourceSlot, targetBag, targetSlot = private.CombineSlotIdToBagSlot(combineSlotId)
			PickupContainerItem(sourceBag, sourceSlot)
			PickupContainerItem(targetBag, targetSlot)
		end
		-- wait for the bagDB to change
		private.newBagUpdate = false
		TSMAPI_FOUR.Thread.WaitForFunction(private.HasNewBagUpdate)
	end
end

function private.CombineSlotIdToBagSlot(combineSlotId)
	local sourceSlotId = combineSlotId % TARGET_SLOT_ID_MULTIPLIER
	local targetSlotId = floor(combineSlotId / TARGET_SLOT_ID_MULTIPLIER)
	local sourceBag, sourceSlot = TSMAPI_FOUR.Util.SplitSlotId(sourceSlotId)
	local targetBag, targetSlot = TSMAPI_FOUR.Util.SplitSlotId(targetSlotId)
	return sourceBag, sourceSlot, targetBag, targetSlot
end

function private.HasNewBagUpdate()
	return private.newBagUpdate
end



-- ============================================================================
-- Destroy Thread
-- ============================================================================

function private.DestroyThread(button, row)
	private.destroyThreadRunning = true
	-- we get sent a sync message so we run right away
	TSMAPI_FOUR.Thread.ReceiveMessage()

	local itemString, spellId, bag, slot = row:GetFields("itemString", "spellId", "bag", "slot")
	local spellName = GetSpellInfo(spellId)
	button:SetMacroText(format("/cast %s;\n/use %d %d", spellName, bag, slot))

	-- wait for the spell cast to start or fail
	private.pendingSpellId = spellId
	local event = TSMAPI_FOUR.Thread.ReceiveMessage()
	if event ~= "UNIT_SPELLCAST_START" then
		-- the spell cast failed for some reason
		ClearCursor()
		private.destroyThreadRunning = false
		return
	end

	-- discard any other messages
	TSMAPI_FOUR.Thread.Yield(true)
	while TSMAPI_FOUR.Thread.HasPendingMessage() do
		TSMAPI_FOUR.Thread.ReceiveMessage()
	end

	-- wait for the spell cast to finish
	event = TSMAPI_FOUR.Thread.ReceiveMessage()
	if event ~= "UNIT_SPELLCAST_SUCCEEDED" then
		-- the spell cast was interrupted
		private.destroyThreadRunning = false
		return
	end

	-- wait for the loot window to open
	TSMAPI_FOUR.Thread.WaitForEvent("LOOT_OPENED")

	-- add to the log
	local newEntry = {
		item = itemString,
		time = time(),
		result = {},
	}
	assert(GetNumLootItems() > 0)
	for i = 1, GetNumLootItems() do
		local lootItemString = TSMAPI_FOUR.Item.ToItemString(GetLootSlotLink(i))
		local _, _, quantity = GetLootSlotInfo(i)
		if lootItemString and (quantity or 0) > 0 then
			lootItemString = GEM_CHIPS[lootItemString] or lootItemString
			newEntry.result[lootItemString] = quantity
		end
	end
	TSM.db.global.internalData.destroyingHistory[spellName] = TSM.db.global.internalData.destroyingHistory[spellName] or {}
	tinsert(TSM.db.global.internalData.destroyingHistory[spellName], newEntry)

	-- wait for the loot window to close
	TSMAPI_FOUR.Thread.WaitForEvent("LOOT_CLOSED")
	TSMAPI_FOUR.Thread.WaitForEvent("BAG_UPDATE_DELAYED")

	-- we're done
	private.destroyThreadRunning = false
end

function private.SpellCastEventHandler(event, unit, _, spellId)
	if not private.destroyThreadRunning or unit ~= "player" or spellId ~= private.pendingSpellId then
		return
	end
	TSMAPI_FOUR.Thread.SendMessage(private.destroyThread, event)
end



-- ============================================================================
-- Bag Update Functions
-- ============================================================================

function private.UpdateBagDB()
	wipe(private.pendingCombines)
	private.destroyInfoDB:TruncateAndBulkInsertStart()
	local itemPrevSlotId = TSMAPI_FOUR.Util.AcquireTempTable()
	local checkedItem = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, bag, slot, itemString, quantity in TSMAPI_FOUR.Inventory.BagIterator(nil, TSM.db.global.destroyingOptions.includeSoulbound, TSM.db.global.destroyingOptions.includeSoulbound) do
		local minQuantity = nil
		if checkedItem[itemString] then
			minQuantity = private.destroyInfoDB:GetUniqueRowField("itemString", itemString, "minQuantity")
		else
			checkedItem[itemString] = true
			local spellId = nil
			minQuantity, spellId = private.ProcessBagItem(itemString)
			if minQuantity then
				private.destroyInfoDB:BulkInsertNewRow(itemString, minQuantity, spellId)
			end
		end
		if minQuantity and quantity % minQuantity ~= 0 then
			local slotId = TSMAPI_FOUR.Util.JoinSlotId(bag, slot)
			if itemPrevSlotId[itemString] then
				-- we can combine this with the previous partial stack
				tinsert(private.pendingCombines, itemPrevSlotId[itemString] * TARGET_SLOT_ID_MULTIPLIER + slotId)
				itemPrevSlotId[itemString] = nil
			else
				itemPrevSlotId[itemString] = slotId
			end
		end
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(checkedItem)
	TSMAPI_FOUR.Util.ReleaseTempTable(itemPrevSlotId)
	private.destroyInfoDB:BulkInsertEnd()

	private.newBagUpdate = true
	if private.bagUpdateCallback then
		private.bagUpdateCallback()
	end
end

function private.ProcessBagItem(itemString)
	if private.ignoreDB:HasUniqueRow("itemString", itemString) then
		return
	end

	local spellId, minQuantity = private.IsDestroyable(itemString)
	if not spellId then
		return
	elseif spellId == SPELL_IDS.disenchant then
		local deAbovePrice = TSMAPI_FOUR.CustomPrice.GetValue(TSM.db.global.destroyingOptions.deAbovePrice, itemString) or 0
		local deValue = TSMAPI_FOUR.CustomPrice.GetValue("Destroy", itemString) or math.huge
		if deValue < deAbovePrice then
			return
		end
	end
	return minQuantity, spellId
end

function private.IsDestroyable(itemString)
	if private.destroyQuantityCache[itemString] then
		return private.canDestroyCache[itemString], private.destroyQuantityCache[itemString]
	end

	-- disenchanting
	local quality = TSMAPI_FOUR.Item.GetQuality(itemString)
	if TSMAPI_FOUR.Item.IsDisenchantable(itemString) and quality <= TSM.db.global.destroyingOptions.deMaxQuality then
		private.canDestroyCache[itemString] = IsSpellKnown(SPELL_IDS.disenchant) and SPELL_IDS.disenchant
		private.destroyQuantityCache[itemString] = 1
		return private.canDestroyCache[itemString], private.destroyQuantityCache[itemString]
	end

	local destroyMethod, destroySpellId = nil, nil
	local classId = TSMAPI_FOUR.Item.GetClassId(itemString)
	local subClassId = TSMAPI_FOUR.Item.GetSubClassId(itemString)
	if classId == LE_ITEM_CLASS_TRADEGOODS and subClassId == ITEM_SUB_CLASS_HERB then
		destroyMethod = "mill"
		destroySpellId = SPELL_IDS.milling
	elseif classId == LE_ITEM_CLASS_TRADEGOODS and subClassId == ITEM_SUB_CLASS_METAL_AND_STONE then
		destroyMethod = "prospect"
		destroySpellId = SPELL_IDS.prospect
	else
		private.canDestroyCache[itemString] = false
		private.destroyQuantityCache[itemString] = nil
		return private.canDestroyCache[itemString], private.destroyQuantityCache[itemString]
	end

	for _, targetItem in ipairs(TSMAPI_FOUR.Conversions.GetTargetItemsByMethod(destroyMethod)) do
		local items = TSMAPI_FOUR.Conversions.GetData(targetItem)
		if items[itemString] then
			private.canDestroyCache[itemString] = IsSpellKnown(destroySpellId) and destroySpellId
			private.destroyQuantityCache[itemString] = 5
			return private.canDestroyCache[itemString], private.destroyQuantityCache[itemString]
		end
	end

	return private.canDestroyCache[itemString], private.destroyQuantityCache[itemString]
end
