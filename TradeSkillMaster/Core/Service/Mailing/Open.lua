-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Open = TSM.Mailing:NewPackage("Open")
local L = TSM.L
local private = {
	thread = nil,
	isOpening = false,
	lastCheck = nil,
	moneyCollected = 0,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Open.OnInitialize()
	private.thread = TSMAPI_FOUR.Thread.New("MAIL_OPENING", private.OpenMailThread)

	TSMAPI_FOUR.Event.Register("MAIL_SHOW", private.ScheduleCheck)
	TSMAPI_FOUR.Event.Register("MAIL_CLOSED", private.MailClosedHandler)
end

function Open.KillThread()
	TSMAPI_FOUR.Thread.Kill(private.thread)

	private.PrintMoneyCollected()
	private.isOpening = false
end

function Open.StartOpening(callback, autoRefresh, keepMoney, filterText, filterType)
	TSMAPI_FOUR.Thread.Kill(private.thread)

	private.isOpening = true
	private.moneyCollected = 0

	TSMAPI_FOUR.Thread.SetCallback(private.thread, callback)
	TSMAPI_FOUR.Thread.Start(private.thread, autoRefresh, keepMoney, filterText, filterType)
end

function Open.GetLastCheckTime()
	return private.lastCheck
end



-- ============================================================================
-- Mail Opening Thread
-- ============================================================================

function private.OpenMailThread(autoRefresh, keepMoney, filterText, filterType)
	while true do
		local query = TSM.Mailing.Inbox.CreateQuery()
		query:ResetOrderBy()
			:OrderBy("index", false)
			:Or()
				:Matches("itemList", filterText)
				:Matches("subject", filterText)
			:End()
			:Select("index")

		if filterType then
			query:Equal("icon", filterType)
		end

		local mails = TSMAPI_FOUR.Thread.AcquireSafeTempTable()

		for _, index in query:Iterator() do
			tinsert(mails, index)
		end

		query:Release()

		private.OpenMails(mails, keepMoney, filterType)

		TSMAPI_FOUR.Thread.ReleaseSafeTempTable(mails)

		if not autoRefresh then
			break
		end

		local numLeftMail, totalLeftMail = GetInboxNumItems()
		if totalLeftMail == numLeftMail or numLeftMail == 50 then
			break
		end

		CheckInbox()
		TSMAPI_FOUR.Thread.Sleep(1)
	end

	private.PrintMoneyCollected()
	private.isOpening = false
end

function private.CanOpenMail()
	return not C_Mail.IsCommandPending()
end

function private.OpenMails(mails, keepMoney, filterType)
	for i = 1, #mails do
		local index = mails[i]
		TSMAPI_FOUR.Thread.WaitForFunction(private.CanOpenMail)

		local mailType = TSM.Inventory.MailTracking.GetMailType(index)
		if (not filterType and mailType) or (filterType and filterType == mailType) then
			if CalculateTotalNumberOfFreeBagSlots() <= TSM.db.global.mailingOptions.keepMailSpace then
				return
			end
			local _, _, _, _, money = GetInboxHeaderInfo(index)
			if not keepMoney or (keepMoney and money <= 0) then
				-- marks the mail as read
				GetInboxText(index)
				AutoLootMailItem(index)
				private.moneyCollected = private.moneyCollected + money

				if TSMAPI_FOUR.Thread.WaitForEvent("CLOSE_INBOX_ITEM", "MAIL_FAILED") ~= "MAIL_FAILED" then
					if TSM.db.global.mailingOptions.inboxMessages then
						private.PrintOpenMailMessage(index)
					end
				end
			end
		end
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.CheckInbox()
	if private.isOpening then
		private.ScheduleCheck()
		return
	end

	if not TSM.UI.MailingUI.Inbox.IsMailOpened() then
		CheckInbox()
	end
	private.ScheduleCheck()
end

function private.PrintMoneyCollected()
	if TSM.db.global.mailingOptions.inboxMessages and private.moneyCollected > 0 then
		TSM:Printf(L["Total Gold Collected: %s"], TSM.Money.ToString(private.moneyCollected))
	end
	private.moneyCollected = 0
end

function private.PrintOpenMailMessage(index)
	local _, _, sender, subject, money, cod, _, hasItem = GetInboxHeaderInfo(index)
	sender = sender or "?"
	local _, _, _, _, isInvoice = GetInboxText(index)
	if isInvoice then
		-- it's an invoice
		local invoiceType, itemName, playerName, bid, _, _, ahcut, _, _, _, quantity = GetInboxInvoiceInfo(index)
		playerName = playerName or "?"
		if invoiceType == "buyer" then
			local itemLink =  TSM.Inventory.MailTracking.GetInboxItemLink(index) or itemName
			TSM:Printf(L["Bought %sx%d for %s from %s"], itemLink, quantity, TSM.Money.ToString(bid, "|cffff0000"), playerName)
		elseif invoiceType == "seller" then
			TSM:Printf(L["Sold [%s]x%d for %s to %s"], itemName, quantity, TSM.Money.ToString(bid - ahcut, "|cff00ff00"), playerName)
		end
	elseif hasItem then
		local itemLink
		local quantity = 0
		for i = 1, hasItem do
			local link = GetInboxItemLink(index, i)
			itemLink = itemLink or link
			quantity = quantity + (select(4, GetInboxItem(index, i)) or 0)
			if TSMAPI_FOUR.Item.ToItemString(itemLink) ~= TSMAPI_FOUR.Item.ToItemString(link) then
				itemLink = L["Multiple Items"]
				quantity = -1
				break
			end
		end
		if hasItem == 1 then
			itemLink = TSM.Inventory.MailTracking.GetInboxItemLink(index) or itemLink
		end
		local itemName = TSMAPI_FOUR.Item.GetName(itemLink) or "?"
		local itemDesc = (quantity > 0 and format("%sx%d", itemLink, quantity)) or (quantity == -1 and "Multiple Items") or "?"
		if hasItem == 1 and itemLink and strfind(subject, "^" .. TSMAPI_FOUR.Util.StrEscape(format(AUCTION_EXPIRED_MAIL_SUBJECT, itemName))) then
			TSM:Printf(L["Your auction of %s expired"], itemDesc)
		elseif hasItem == 1 and quantity > 0 and (subject == format(AUCTION_REMOVED_MAIL_SUBJECT.."x%d", itemName, quantity) or subject == format(AUCTION_REMOVED_MAIL_SUBJECT, itemName)) then
			TSM:Printf(L["Cancelled auction of %sx%d"], itemLink, quantity)
		elseif cod > 0 then
			TSM:Printf(L["%s sent you a COD of %s for %s"], sender, TSM.Money.ToString(cod, "|cffff0000"), itemDesc)
		elseif money > 0 then
			TSM:Printf(L["%s sent you %s and %s"], sender, itemDesc, TSM.Money.ToString(money, "|cff00ff00"))
		else
			TSM:Printf(L["%s sent you %s"], sender, itemDesc)
		end
	elseif money > 0 then
		TSM:Printf(L["%s sent you %s"], sender, TSM.Money.ToString(money, "|cff00ff00"))
	elseif subject then
		TSM:Printf(L["%s sent you a message: %s"], sender, subject)
	end
end


-- ============================================================================
-- Event Handlers
-- ============================================================================

function private.ScheduleCheck()
	if not private.lastCheck or time() - private.lastCheck > 60 then
		private.lastCheck = time()
		TSMAPI_FOUR.Delay.AfterTime("mailInboxCheck", 61, private.CheckInbox)
	else
		local nextUpdate = 61 - (time() - private.lastCheck)
		TSMAPI_FOUR.Delay.AfterTime("mailInboxCheck", nextUpdate, private.CheckInbox)
	end
end

function private.MailClosedHandler()
	TSMAPI_FOUR.Delay.Cancel("mailInboxCheck")
end
