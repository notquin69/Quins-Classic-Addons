-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Send = TSM.Mailing:NewPackage("Send")
local L = TSM.L
local private = {
	thread = nil,
	bagUpdate = nil,
}

local PLAYER_NAME = UnitName("player")
local PLAYER_NAME_REALM = string.gsub(PLAYER_NAME.."-"..GetRealmName(), "%s+", "")



-- ============================================================================
-- Module Functions
-- ============================================================================

function Send.OnInitialize()
	private.thread = TSMAPI_FOUR.Thread.New("MAIL_SENDING", private.SendMailThread)
	TSM.Inventory.BagTracking.RegisterCallback(private.BagUpdate)
end

function Send.KillThread()
	TSMAPI_FOUR.Thread.Kill(private.thread)
end

function Send.StartSending(callback, recipient, subject, body, money, items, isGroup)
	TSMAPI_FOUR.Thread.Kill(private.thread)

	TSMAPI_FOUR.Thread.SetCallback(private.thread, callback)
	TSMAPI_FOUR.Thread.Start(private.thread, recipient, subject, body, money, items, isGroup)
end



-- ============================================================================
-- Mail Sending Thread
-- ============================================================================

function private.SendMailThread(recipient, subject, body, money, items, isGroup)
	if recipient == "" or recipient == PLAYER_NAME or recipient == PLAYER_NAME_REALM then
		return
	end

	if not items then
		if TSM.db.global.mailingOptions.sendMessages then
			private.PrintMailMessage(money, items, recipient)
		end
		private.SendMail(recipient, subject, body, money, true)

		return
	end

	ClearSendMail()

	if TSM.db.global.mailingOptions.sendMessages then
		local individually = false
		if isGroup and TSM.db.global.mailingOptions.sendItemsIndividually then
			individually = true
		end
		private.PrintMailMessage(money, items, recipient, individually)
	end

	local itemInfo = TSMAPI_FOUR.Thread.AcquireSafeTempTable()

	for _, bag, slot, itemString, quantity in TSMAPI_FOUR.Inventory.BagIterator(false, false, true) do
		if isGroup then
			itemString = TSMAPI_FOUR.Item.ToBaseItemString(itemString, true)
		end
		if items[itemString] and not TSMAPI_FOUR.Inventory.IsBagSlotLocked(bag, slot) then
			if not itemInfo[itemString] then
				itemInfo[itemString] = { locations = {} }
			end
			tinsert(itemInfo[itemString].locations, { bag = bag, slot = slot, quantity = quantity })
		end
	end

	for itemString, quantity in pairs(items) do
		if quantity > 0 and itemInfo[itemString] and #itemInfo[itemString].locations > 0 then
			for i = 1, #itemInfo[itemString].locations do
				local info = itemInfo[itemString].locations[i]
				if info.quantity > 0 then
					if quantity == info.quantity then
						PickupContainerItem(info.bag, info.slot)
						ClickSendMailItemButton()

						if private.GetNumPendingAttachments() == ATTACHMENTS_MAX_SEND or (isGroup and TSM.db.global.mailingOptions.sendItemsIndividually) then
							private.SendMail(recipient, subject, body, money)
						end

						items[itemString] = 0
						info.quantity = 0

						break
					end
				end
			end
		end
	end

	for itemString in pairs(items) do
		if items[itemString] > 0 and itemInfo[itemString] and #itemInfo[itemString].locations > 0 then
			local emptySlotIds = private.GetEmptyBagSlotsThreaded(GetItemFamily(TSMAPI_FOUR.Item.ToItemID(itemString)) or 0)
			for i = 1, #itemInfo[itemString].locations do
				local info = itemInfo[itemString].locations[i]
				if items[itemString] > 0 and info.quantity > 0 then
					if items[itemString] < info.quantity then
						if #emptySlotIds > 0 then
							local splitBag, splitSlot = TSMAPI_FOUR.Util.SplitSlotId(tremove(emptySlotIds, 1))
							SplitContainerItem(info.bag, info.slot, items[itemString])
							PickupContainerItem(splitBag, splitSlot)
							TSMAPI_FOUR.Thread.WaitForFunction(private.BagSlotHasItem, splitBag, splitSlot)
							PickupContainerItem(splitBag, splitSlot)
							ClickSendMailItemButton()

							if private.GetNumPendingAttachments() == ATTACHMENTS_MAX_SEND or (isGroup and TSM.db.global.mailingOptions.sendItemsIndividually) then
								private.SendMail(recipient, subject, body, money)
							end

							items[itemString] = 0
							info.quantity = 0

							break
						end
					else
						PickupContainerItem(info.bag, info.slot)
						ClickSendMailItemButton()

						if private.GetNumPendingAttachments() == ATTACHMENTS_MAX_SEND or (isGroup and TSM.db.global.mailingOptions.sendItemsIndividually) then
							private.SendMail(recipient, subject, body, money)
						end

						items[itemString] = items[itemString] - info.quantity
						info.quantity = 0
					end
				end
			end
			TSMAPI_FOUR.Thread.ReleaseSafeTempTable(emptySlotIds)
		end
	end

	if private.HasPendingAttachments() then
		private.SendMail(recipient, subject, body, money)
	end

	TSMAPI_FOUR.Thread.ReleaseSafeTempTable(itemInfo)
end

function private.PrintMailMessage(money, items, target, individually)
	if money > 0 and not items then
		TSM:Printf(L["Sending %s to %s"], TSM.Money.ToString(money), target)
		return
	end

	if not items then
		return
	end

	local itemList = ""
	for k, v in pairs(items) do
		local coloredItem = TSMAPI_FOUR.Item.GetLink(k)
		itemList = itemList..coloredItem.."x"..v..", "
	end
	itemList = strtrim(itemList, ", ")

	if next(items) and money < 0 then
		TSM:Printf(L["Sending %s to %s with a COD of %s"], itemList, target, TSM.Money.ToString(money, "|cffff0000"))
	elseif next(items) and individually then
		TSM:Printf(L["Sending %s individually to %s"], itemList, target)
	elseif next(items) then
		TSM:Printf(L["Sending %s to %s"], itemList, target)
	end
end

function private.SendMail(recipient, subject, body, money, noItem)
	if subject == "" then
		local text = SendMailSubjectEditBox:GetText()
		subject = text ~= "" and text or "TSM Mailing"
	end

	if money > 0 then
		SetSendMailMoney(money)
		SetSendMailCOD(0)
	elseif money < 0 then
		SetSendMailCOD(abs(money))
		SetSendMailMoney(0)
	else
		SetSendMailMoney(0)
		SetSendMailCOD(0)
	end

	private.bagUpdate = false
	SendMail(recipient, subject, body)

	if TSMAPI_FOUR.Thread.WaitForEvent("MAIL_SUCCESS", "MAIL_FAILED") == "MAIL_SUCCESS" then
		if noItem then
			TSMAPI_FOUR.Thread.Sleep(0.5)
		else
			TSMAPI_FOUR.Thread.WaitForFunction(private.HasNewBagUpdate)
		end
	else
		TSMAPI_FOUR.Thread.Sleep(0.5)
	end
end

function private.BagUpdate()
	private.bagUpdate = true
end

function private.HasNewBagUpdate()
	return private.bagUpdate
end

function private.HasPendingAttachments()
	for i = 1, ATTACHMENTS_MAX_SEND do
		if GetSendMailItem(i) then
			return true
		end
	end

	return false
end

function private.GetNumPendingAttachments()
	local totalAttached = 0
	for i = 1, ATTACHMENTS_MAX_SEND do
		if GetSendMailItem(i) then
			totalAttached = totalAttached + 1
		end
	end

	return totalAttached
end

function private.BagSlotHasItem(bag, slot)
	return GetContainerItemInfo(bag, slot) and true or false
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
