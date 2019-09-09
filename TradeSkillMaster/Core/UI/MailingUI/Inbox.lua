-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Inbox = TSM.UI.MailingUI:NewPackage("Inbox")
local L = TSM.L
local private = {
	fsm = nil,
	frame = nil,
	frameItems = nil,
	view = nil,
	inboxQuery = nil,
	itemsQuery = nil,
	selectedMail = nil,
	nextUpdate = nil,
	filterText = ""
}

local PLAYER_NAME = UnitName("player")



-- ============================================================================
-- Module Functions
-- ============================================================================

function Inbox.OnInitialize()
	private.FSMCreate()
	TSM.UI.MailingUI.RegisterTopLevelPage(INBOX, "iconPack.24x24/Mail", private.GetInboxFrame)
end

function Inbox.IsMailOpened()
	if not private.view or not private.view:GetElement("view") then
		return
	end

	return private.view:GetElement("view"):GetPath() == "items"
end



-- ============================================================================
-- Inbox UI
-- ============================================================================

function private.GetInboxFrame()
	TSM.UI.AnalyticsRecordPathChange("mailing", "inbox")
	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "frame")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("ViewContainer", "view")
			:SetNavCallback(private.GetViewContentFrame)
			:AddPath("mails")
			:AddPath("items")
			:SetPath("mails")
		)

	private.view = frame

	return frame
end

function private.GetViewContentFrame(viewContainer, path)
	if path == "mails" then
		private.selectedMail = nil
		return private.GetInboxMailsFrame()
	elseif path == "items" then
		return private.GetInboxItemsFrame()
	else
		error("Unexpected path: "..tostring(path))
	end
end

function private.GetInboxMailsFrame()
	private.inboxQuery = private.inboxQuery or TSM.Mailing.Inbox.CreateQuery()
	private.inboxQuery:ResetFilters()
	private.inboxQuery:ResetOrderBy()
	private.inboxQuery:OrderBy("index", true)

	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "inbox")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "top")
			:SetLayout("VERTICAL")
			:SetStyle("height", 79)
			:SetStyle("background", "#272727")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "reload")
				:SetStyle("anchors", { { "TOPRIGHT", -7, -5 } })
				:SetStyle("height", 29)
				:SetStyle("width", 22)
				:SetStyle("height", 22)
				:SetStyle("backgroundTexturePack", "iconPack.18x18/Reset")
				:SetScript("OnClick", ReloadUI)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "mails")
				:SetLayout("HORIZONTAL")
				:SetStyle("margin", { top = 4, left = 10, right = 10 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
					:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
					:SetStyle("fontHeight", 12)
					:SetStyle("justifyH", "LEFT")
					:SetFormattedText(L["Loading Mails..."])
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "countdown")
					:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
					:SetStyle("fontHeight", 12)
					:SetStyle("justifyH", "RIGHT")
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SearchInput", "filterInput")
				:SetStyle("height", 20)
				:SetStyle("margin", { top = 4, left = 10, right = 10, bottom = 10 })
				:SetHintText(L["Search Inbox"])
				:SetDisabled(false)
				:SetScript("OnTextChanged", private.SearchOnTextChanged)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
			:SetStyle("height", 2)
			:SetStyle("color", "#585858")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "mails")
			:SetStyle("headerBackground", "#404040")
			:SetStyle("headerFont", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("headerFontHeight", 14)
			:SetStyle("margin.bottom", 1)
			:GetScrollingTableInfo()
				:NewColumn("icon")
					:SetWidth(15)
					:SetFont(TSM.UI.Fonts.FRIZQT)
					:SetFontHeight(14)
					:SetJustifyH("CENTER")
					:SetTextInfo("icon", private.FormatIcon)
					:Commit()
				:NewColumn("items")
					:SetTitles(L["Items"])
					:SetFont(TSM.UI.Fonts.FRIZQT)
					:SetFontHeight(12)
					:SetJustifyH("LEFT")
					:SetTextInfo(nil, private.FormatItem)
					:SetTooltipInfo("itemString")
					:SetTooltipLinkingDisabled(true)
					:Commit()
				:NewColumn("expires")
					:SetTitles(L["Expires"])
					:SetWidth(65)
					:SetFont(TSM.UI.Fonts.MontserratMedium)
					:SetFontHeight(12)
					:SetJustifyH("RIGHT")
					:SetTextInfo("expires", private.FormatDaysLeft)
					:Commit()
				:NewColumn("money")
					:SetTitles(L["Gold"])
					:SetWidth(115)
					:SetFont(TSM.UI.Fonts.RobotoMedium)
					:SetFontHeight(12)
					:SetJustifyH("RIGHT")
					:SetTextInfo(nil, private.FormatMoney)
					:Commit()
				:Commit()
			:SetQuery(private.inboxQuery)
			:SetScript("OnRowClick", private.QueryOnRowClick)
			:SetScript("OnDataUpdated", private.InboxOnDataUpdated)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "footer")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 23)
			:SetStyle("margin.bottom", 3)
			:SetStyle("background", "#000000")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "gold")
				:SetStyle("margin.right", 8)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 13)
				:SetStyle("justifyH", "RIGHT")
				:SetText(L["Total Gold"]..": "..TSM.Money.ToString(0))
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "openAllMail")
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("margin.bottom", 4)
			:SetStyle("height", 26)
			:SetStyle("fontHeight", 14)
			:SetText(L["OPEN ALL MAIL"])
			:SetScript("OnClick", private.OpenBtnOnClick)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "buttons")
			:SetLayout("HORIZONTAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "openAllSales")
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("margin.right", 8)
				:SetStyle("height", 20)
				:SetStyle("fontHeight", 12)
				:SetStyle("iconTexturePack", "iconPack.12x12/Bid")
				:SetText(L["SALES"])
				:SetContext("SALE")
				:SetScript("OnClick", private.OpenBtnOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "openAllBuys")
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("margin.right", 8)
				:SetStyle("height", 20)
				:SetStyle("fontHeight", 12)
				:SetStyle("iconTexturePack", "iconPack.12x12/Shopping")
				:SetText(L["BUYS"])
				:SetContext("BUY")
				:SetScript("OnClick", private.OpenBtnOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "openAllCancels")
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("margin.right", 8)
				:SetStyle("height", 20)
				:SetStyle("fontHeight", 12)
				:SetStyle("iconTexturePack", "iconPack.12x12/Close/Circle")
				:SetText(L["CANCELS"])
				:SetContext("CANCEL")
				:SetScript("OnClick", private.OpenBtnOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "openAllExpires")
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("height", 20)
				:SetStyle("fontHeight", 12)
				:SetStyle("iconTexturePack", "iconPack.12x12/Clock")
				:SetText(L["EXPIRES"])
				:SetContext("EXPIRE")
				:SetScript("OnClick", private.OpenBtnOnClick)
			)
		)
		:SetScript("OnUpdate", private.InboxFrameOnUpdate)
		:SetScript("OnHide", private.InboxFrameOnHide)

	private.frame = frame

	return frame
end

function private.GetInboxItemsFrame()
	private.itemsQuery = private.itemsQuery or TSM.Inventory.MailTracking.CreateMailItemQuery()
	private.itemsQuery:ResetFilters()
		:Equal("index", private.selectedMail)
		:OrderBy("itemIndex", true)

	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "items")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "top")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 53)
			:SetStyle("background", "#272727")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "backBtn")
				:SetStyle("margin", { top = 21, left = 4 })
				:SetStyle("width", 18)
				:SetStyle("height", 18)
				:SetStyle("backgroundTexturePack", "iconPack.18x18/SideArrow")
				:SetStyle("backgroundTextureRotation", 180)
				:SetScript("OnClick", private.ViewBackButtonOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "backBtnText")
				:SetStyle("margin", { top = 21, left = 2 })
				:SetStyle("height", 15)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 12)
				:SetStyle("justifyH", "LEFT")
				:SetText(L["Back to List"])
				:SetScript("OnClick", private.ViewBackButtonOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "lineTop")
			:SetStyle("height", 2)
			:SetStyle("color", "#585858")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "header")
			:SetLayout("VERTICAL")
			:SetStyle("height", 50)
			:SetStyle("background", "#424242")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "top")
				:SetLayout("VERTICAL")
				:SetStyle("margin", { top = 3, left = 8, right = 8 })
				:SetStyle("height", 22)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "left")
					:SetLayout("HORIZONTAL")
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text")
						:SetStyle("autoWidth", true)
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 14)
						:SetStyle("justifyH", "LEFT")
						:SetText(L["From"]..": ")
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "sender")
						:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
						:SetStyle("fontHeight", 14)
						:SetStyle("justifyH", "LEFT")
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
					:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "report")
						:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
						:SetStyle("width", 124)
						:SetStyle("height", 20)
						:SetStyle("fontHeight", 12)
						:SetText(L["REPORT SPAM"])
						:SetScript("OnClick", private.ReportSpamOnClick)
					)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "bottom")
				:SetLayout("VERTICAL")
				:SetStyle("margin", { top = 1, left = 8, right = 8 })
				:SetStyle("height", 22)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "left")
					:SetLayout("HORIZONTAL")
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text")
						:SetStyle("autoWidth", true)
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 14)
						:SetStyle("justifyH", "LEFT")
						:SetText(L["Subject"]..": ")
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "subject")
						:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
						:SetStyle("fontHeight", 14)
						:SetStyle("justifyH", "LEFT")
					)
				)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "lineBottom")
			:SetStyle("height", 2)
			:SetStyle("color", "#585858")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "body")
			:SetLayout("VERTICAL")
			:SetStyle("background", "#000000")
			:AddChild(TSMAPI_FOUR.UI.NewElement("ScrollFrame", "scroll")
				:SetStyle("margin", { top = 2, left = 2, right = 2, bottom = 2 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
					:SetStyle("height", 105)
					:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
					:SetStyle("textColor", "#e2e2e2")
					:SetStyle("fontHeight", 12)
					:SetStyle("justifyH", "LEFT")
					:EnableMouse(false)
					:SetMultiLine(true)
					:SetText("")
					:SetScript("OnSizeChanged", private.BodyOnSizeChanged)
				)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "attachments")
			:SetLayout("VERTICAL")
			:SetStyle("margin", { top = 1, bottom = 8 })
			:SetStyle("height", 144)
			:SetStyle("background", "#000000")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "header")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 24)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
					:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
					:SetStyle("margin.left", 8)
					:SetStyle("height", 24)
					:SetStyle("fontHeight", 12)
					:SetStyle("justifyH", "LEFT")
					:SetText(L["Take Attachments"]..":")
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "cod")
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("height", 16)
					:SetStyle("fontHeight", 12)
					:SetStyle("margin", { right = 5 })
					:SetStyle("justifyH", "RIGHT")
					:SetText(L["COD"]..":")
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "codAmount")
					:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
					:SetStyle("autoWidth", true)
					:SetStyle("height", 16)
					:SetStyle("margin.right", 8)
					:SetStyle("fontHeight", 13)
					:SetStyle("justifyH", "RIGHT")
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "takeAll")
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("width", 94)
					:SetStyle("height", 16)
					:SetStyle("margin.right", 8)
					:SetStyle("fontHeight", 10)
					:SetText(L["TAKE ALL"])
					:SetScript("OnClick", private.TakeAllOnClick)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "items")
				:SetStyle("lineColor", "#000000")
				:SetStyle("hideHeader", true)
				:SetStyle("headerBackground", "#00000000")
				:SetStyle("background", "#000000")
				:SetStyle("altBackground", "#1b1b1b")
				:SetStyle("headerFont", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("headerFontHeight", 12)
				:GetScrollingTableInfo()
					:NewColumn("items")
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo(nil, private.FormatInboxItem)
						:SetIconInfo("itemLink", TSMAPI_FOUR.Item.GetTexture)
						:SetTooltipInfo("itemLink")
						:SetTooltipLinkingDisabled(true)
						:Commit()
					:Commit()
				:SetQuery(private.itemsQuery)
				:SetScript("OnRowClick", private.ItemQueryOnRowClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "footer")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "reply")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("width", 190)
				:SetStyle("height", 26)
				:SetStyle("margin", { left = 8, right = 8 })
				:SetStyle("fontHeight", 14)
				:SetText(L["REPLY"])
				:SetScript("OnClick", private.ReplyOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "return/send")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("width", 190)
				:SetStyle("height", 26)
				:SetStyle("fontHeight", 14)
				:SetText(strupper(MAIL_RETURN))
				:SetScript("OnClick", private.DeleteMailOnClick)
			)
		)
		:SetScript("OnUpdate", private.InboxItemsFrameOnUpdate)

	private.frameItems = frame

	private.UpdateInboxItemsFrame()

	return frame
end

function private.ViewBackButtonOnClick(button)
	button:GetElement("__parent.__parent.__parent"):SetPath("mails", true)
end

function private.BodyOnSizeChanged(input, width, height)
	input:SetStyle("height", height)
	input:GetParentElement():Draw()
end

function private.ItemQueryOnRowClick(scrollingTable, row)
	local index = row:GetField("index")
	local _, _, _, _, _, cod = GetInboxHeaderInfo(index)
	if cod > 0 then
		scrollingTable:GetBaseElement():ShowConfirmationDialog(L["Accepting this item will cost"]..":", TSM.Money.ToString(cod), strupper(ACCEPT), private.TakeInboxItem, scrollingTable, row)
		return
	end

	private.TakeInboxItem(scrollingTable, row)
end

function private.TakeInboxItem(scrollingTable, row)
	local index = row:GetField("index")
	local itemIndex = row:GetField("itemIndex")
	if private.itemsQuery:Count() == 1 then
		if itemIndex == 0 then
			TakeInboxMoney(index)
		else
			TakeInboxItem(index, row:GetField("itemIndex"))
		end
		scrollingTable:GetElement("__parent.__parent.__parent"):SetPath("mails", true)
	else
		if itemIndex == 0 then
			TakeInboxMoney(index)
		else
			TakeInboxItem(index, row:GetField("itemIndex"))
		end
	end
end

function private.ReportSpamOnClick(button)
	local _, _, sender = GetInboxHeaderInfo(private.selectedMail)
	local dialog = StaticPopup_Show("CONFIRM_REPORT_SPAM_MAIL", sender)
	if ( dialog ) then
		dialog.data = private.selectedMail
	end
end

function private.TakeAllOnClick(button)
	local _, _, _, _, _, cod = GetInboxHeaderInfo(private.selectedMail)
	if cod > 0 then
		button:GetBaseElement():ShowConfirmationDialog(L["Accepting these item(s) will cost"]..":", TSM.Money.ToString(cod), strupper(ACCEPT), private.AutoLootMailItem, button)
	else
		private.AutoLootMailItem(button)
	end
end

function private.AutoLootMailItem(button)
	-- marks the mail as read
	GetInboxText(private.selectedMail)
	AutoLootMailItem(private.selectedMail)
	button:GetElement("__parent.__parent.__parent.__parent"):SetPath("mails", true)
end

function private.ReplyOnClick(button)
	local _, _, sender = GetInboxHeaderInfo(private.selectedMail)
	TSM.UI.MailingUI.Send.SetSendRecipient(sender)
	TSM.UI.MailingUI.SetSelectedTab(L["Send"], true)
end

function private.DeleteMailOnClick(button)
	local _, _, _, _, money, _, _, itemCount = GetInboxHeaderInfo(private.selectedMail)
	if InboxItemCanDelete(private.selectedMail) then
		if itemCount and itemCount > 0 then
			return
		elseif money and money > 0 then
			return
		else
			DeleteInboxItem(private.selectedMail)
		end
	else
		ReturnInboxItem(private.selectedMail)
	end
	button:GetElement("__parent.__parent.__parent"):SetPath("mails", true)
end

function private.UpdateInboxItemsFrame()
	local _, _, sender, subject, money, cod, _, itemCount, _, _, _, canReply, isGM = GetInboxHeaderInfo(private.selectedMail)
	private.frameItems:GetElement("header.top.left.sender"):SetText(sender)
	private.frameItems:GetElement("header.bottom.left.subject"):SetText(subject)

	if isGM then
		private.frameItems:GetElement("header.top.left.sender"):SetStyle("textColor", "#00b4ff")
			:Draw()
	else
		private.frameItems:GetElement("header.top.left.sender"):SetStyle("textColor", "#e2e2e2")
			:Draw()
	end

	if CanComplainInboxItem(private.selectedMail) then
		private.frameItems:GetElement("header.top.left.report"):Show()
	else
		private.frameItems:GetElement("header.top.left.report"):Hide()
	end

	if cod and cod > 0 then
		private.frameItems:GetElement("attachments.header.cod"):Show()
		private.frameItems:GetElement("attachments.header.codAmount"):SetText(TSM.Money.ToString(cod, "|cffff0000"))
		private.frameItems:GetElement("attachments.header.codAmount"):Show()
	else
		private.frameItems:GetElement("attachments.header.cod"):Hide()
		private.frameItems:GetElement("attachments.header.codAmount"):Hide()
	end

	if itemCount and itemCount > 0 then
		private.frameItems:GetElement("attachments.header.takeAll"):Show()
	else
		private.frameItems:GetElement("attachments.header.takeAll"):Hide()
	end

	if not sender or not canReply or sender == PLAYER_NAME then
		private.frameItems:GetElement("footer.reply"):SetDisabled(true)
	else
		private.frameItems:GetElement("footer.reply"):SetDisabled(false)
	end

	if InboxItemCanDelete(private.selectedMail) then
		private.frameItems:GetElement("footer.return/send"):SetText(strupper(DELETE))
		if (itemCount and itemCount > 0) or (money and money > 0) then
			private.frameItems:GetElement("footer.return/send"):SetDisabled(true)
		else
			private.frameItems:GetElement("footer.return/send"):SetDisabled(false)
		end
	else
		private.frameItems:GetElement("footer.return/send"):SetText(strupper(MAIL_RETURN))
		private.frameItems:GetElement("footer.return/send"):SetDisabled(false)
	end

	local bodyText, _, _, _, isInvoice = GetInboxText(private.selectedMail)
	if isInvoice then
		local invoiceType, itemName, playerName, bid, buyout, deposit, consignment, _, etaHour, etaMin = GetInboxInvoiceInfo(private.selectedMail)
		local purchaseType = bid == buyout and BUYOUT or HIGH_BIDDER
		if invoiceType == "buyer" then
			bodyText = ITEM_PURCHASED_COLON.." "..itemName.."\n"..SOLD_BY_COLON.." "..playerName.." ("..purchaseType..")".."\n\n"..AMOUNT_RECEIVED_COLON.." "..TSM.Money.ToString(bid)
		elseif invoiceType == "seller" then
			bodyText = ITEM_SOLD_COLON.." "..itemName.."\n"..PURCHASED_BY_COLON.." "..playerName.." ("..purchaseType..")".."\n\n"..L["Sale Price"]..": "..TSM.Money.ToString(bid).."\n"..L["Deposit"]..": +"..TSM.Money.ToString(deposit).."\n"..L["Auction House Cut"]..": -"..TSM.Money.ToString(consignment, "|cffff0000").."\n\n"..AMOUNT_RECEIVED_COLON.." "..TSM.Money.ToString(bid + deposit - consignment)
		elseif invoiceType == "seller_temp_invoice" then
			bodyText = ITEM_SOLD_COLON.." "..itemName.."\n"..PURCHASED_BY_COLON.." "..playerName.." ("..purchaseType..")".."\n\n"..AUCTION_INVOICE_PENDING_FUNDS_COLON.." "..TSM.Money.ToString(bid + deposit - consignment).."\n"..L["Estimated deliver time"]..": "..GameTime_GetFormattedTime(etaHour, etaMin, true)
		end
	end
	private.frameItems:GetElement("body.scroll.input"):SetText(bodyText or "")

	if not bodyText then
		private.frameItems:GetElement("body"):Hide()
		private.frameItems:GetElement("attachments.header.text"):SetText(L["Take Attachments"]..":")
		private.frameItems:GetElement("attachments"):SetStyle("height", nil)
			:Draw()
	elseif private.itemsQuery:Count() == 0 then
		private.frameItems:GetElement("body"):Show()
		private.frameItems:GetElement("attachments.header.text"):SetText(L["No Attachments"])
		private.frameItems:GetElement("attachments"):SetStyle("height", 48)
			:Draw()
	else
		private.frameItems:GetElement("body"):Show()
		private.frameItems:GetElement("attachments.header.text"):SetText(L["Take Attachments"]..":")
		private.frameItems:GetElement("attachments"):SetStyle("height", 144)
			:Draw()
	end
end

function private.FormatInboxItem(row)
	local itemIndex = row:GetField("itemIndex")
	if itemIndex == 0 then
		return L["Gold"]..": "..TSM.Money.ToString(row:GetField("itemLink"), "|cff00ff00")
	end

	local coloredItem = TSM.UI.GetColoredItemName(row:GetField("itemLink")) or ""
	local quantity = row:GetField("quantity")

	local item = ""
	if quantity > 1 then
		item = coloredItem.."|cffe1f720 (x"..quantity..")|r"
	else
		item = coloredItem
	end

	return item
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.InboxFrameOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)
	frame:GetBaseElement():SetBottomPadding(55)

	private.UpdateCountDown(true)
	TSMAPI_FOUR.Delay.AfterTime("mailUpdateCounter", 0, private.UpdateCountDown, 1)

	private.fsm:ProcessEvent("EV_FRAME_SHOW", frame, private.filterText)
end

function private.InboxItemsFrameOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)
	frame:GetBaseElement():SetBottomPadding(34)
end

function private.InboxFrameOnHide(frame)
	assert(frame == private.frame)
	private.frame = nil

	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function private.InboxOnDataUpdated()
	if not private.frame then
		return
	end

	private.fsm:ProcessEvent("EV_MAIL_DATA_UPDATED", private.filterText)
end

function private.OpenBtnOnClick(button)
	local context = button:GetContext()
	button:SetPressed(true)
	private.fsm:ProcessEvent("EV_BUTTON_CLICKED", IsShiftKeyDown(), not context and IsControlKeyDown(), private.filterText, context)
end

function private.QueryOnRowClick(scrollingTable, row, button)
	if button ~= "LeftButton" then
		return
	end

	if IsShiftKeyDown() then
		local index = row:GetField("index")
		local _, _, _, _, _, cod = GetInboxHeaderInfo(index)
		if cod <= 0 then
			-- marks the mail as read
			GetInboxText(index)
			AutoLootMailItem(index)
		end
	else
		TSM.Mailing.Open.KillThread()
		private.selectedMail = row:GetField("index")
		scrollingTable:GetElement("__parent.__parent"):SetPath("items", true)
	end
end

function private.SearchOnTextChanged(input)
	local text = strtrim(input:GetText())
	if text == private.filterText then
		return
	end
	private.filterText = text
	input:SetText(private.filterText)

	private.inboxQuery:ResetFilters()
		:Or()
			:Matches("itemList", private.filterText)
			:Matches("subject", private.filterText)
		:End()

	input:GetElement("__parent.__parent.mails"):UpdateData(true)
end

function private.FormatIcon(mailType)
	local icon = nil
	if mailType == "SALE" then
		icon = TSM.UI.TexturePacks.GetTextureLink("iconPack.12x12/Bid")
	elseif mailType == "BUY" then
		icon = TSM.UI.TexturePacks.GetTextureLink("iconPack.12x12/Shopping")
	elseif mailType == "CANCEL" then
		icon = TSM.UI.TexturePacks.GetTextureLink("iconPack.12x12/Close/Circle")
	elseif mailType == "EXPIRE" then
		icon = TSM.UI.TexturePacks.GetTextureLink("iconPack.12x12/Clock")
	end
	return icon or ""
end

function private.FormatItem(row)
	private.itemsQuery = private.itemsQuery or TSM.Inventory.MailTracking.CreateMailItemQuery()

	private.itemsQuery:ResetFilters()
		:Equal("index", row:GetField("index"))
		:GreaterThan("itemIndex", 0)
		:ResetOrderBy()
		:OrderBy("itemIndex", true)

	local items = ""
	local item = nil
	local same = true
	local qty = 0
	for _, itemsRow in private.itemsQuery:Iterator() do
		local coloredItem = TSM.UI.GetColoredItemName(itemsRow:GetField("itemLink")) or ""
		local quantity = itemsRow:GetField("quantity")

		if not item then
			item = coloredItem
		end

		if quantity > 1 then
			items = items..coloredItem.."|cffe1f720 (x"..quantity..")|r"..", "
		else
			items = items..coloredItem..", "
		end

		if item == coloredItem then
			qty = qty + quantity
		else
			same = false
		end
	end
	items = strtrim(items, ", ")

	if same and item then
		if qty > 1 then
			items = item.."|cffe1f720 (x"..qty..")|r"
		else
			items = item
		end
	end

	if not items or items == "" then
		local subject = row:GetField("subject")
		if subject ~= "" then
			items = gsub(row:GetField("subject"), strtrim(AUCTION_SOLD_MAIL_SUBJECT, "%s.*"), "") or "--"
		else
			local _, _, sender = GetInboxHeaderInfo(row:GetField("index"))
			items = sender
		end
	end

	return items
end

function private.FormatDaysLeft(timeLeft)
	if timeLeft >= 1 then
		if timeLeft <= 5 then
			timeLeft = "|cffffff00"..floor(timeLeft).." "..DAYS
		else
			timeLeft = "|cff00ff00"..floor(timeLeft).." "..DAYS
		end
	else
		local hoursLeft = floor(timeLeft * 24)
		if hoursLeft > 1 then
			timeLeft = "|cffff0000"..hoursLeft.." "..L["Hrs"]
		elseif hoursLeft == 1 then
			timeLeft = "|cffff0000"..hoursLeft.." "..L["Hr"]
		else
			timeLeft = "|cffff0000"..floor(hoursLeft / 60).." "..L["Min"]
		end
	end

	return timeLeft
end

function private.FormatMoney(row)
	local money = row:GetField("money")
	local cod = row:GetField("cod")

	local gold
	if cod > 0 then
		gold = TSM.Money.ToString(cod, "|cffff0000")
	elseif money > 0 then
		gold = TSM.Money.ToString(money, "|cff00ff00")
	end

	return gold or "--"
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.UpdateCountDown(force)
	if not private.frame then
		return
	end

	local nextUpdate = 61 - (time() - TSM.Mailing.Open.GetLastCheckTime())
	if nextUpdate == 0 then
		nextUpdate = 61
	end

	if nextUpdate ~= private.nextUpdate or force then
		private.frame:GetElement("top.mails.countdown"):SetText(SecondsToTime(nextUpdate))
			:Draw()
		private.nextUpdate = nextUpdate
	end
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.FSMCreate()
	local fsmContext = {
		frame = nil,
		opening = false
	}

	local function UpdateText(context, filterText)
		local text
		local numMail, totalMail = GetInboxNumItems()
		if filterText == "" then
			if totalMail > numMail then
				text = L["Showing %d of %d Mails"]
			elseif (numMail == 1 and totalMail == 1) or (numMail == 0 and totalMail == 0) then
				text = L["Showing %d Mail"]
			else
				text = L["Showing all %d Mails"]
			end
		else
			numMail = private.inboxQuery:Count()

			if (numMail == 0 and totalMail == 0) or (numMail == 1 and totalMail == 1) then
				text = L["Showing %d of %d Mail"]
			else
				text = L["Showing %d of %d Mails"]
			end
		end

		context.frame:GetElement("top.mails.text"):SetFormattedText(text, numMail, totalMail)
			:Draw()

		local totalGold = 0
		for _, row in private.inboxQuery:Iterator() do
			totalGold = totalGold + row:GetField("money")
		end

		context.frame:GetElement("footer.gold"):SetText(L["Total Gold"]..": "..TSM.Money.ToString(totalGold))
			:Draw()
	end

	local function UpdateButtons(context)
		if not context.frame or not context.frame:GetElement("top.filterInput") then
			return
		end

		if context.opening then
			context.frame:GetElement("top.filterInput")
				:SetDisabled(true)

			context.frame:GetElement("openAllMail")
				:SetDisabled(true)
				:Draw()
			context.frame:GetElement("buttons.openAllSales")
				:SetDisabled(true)
			context.frame:GetElement("buttons.openAllBuys")
				:SetDisabled(true)
			context.frame:GetElement("buttons.openAllCancels")
				:SetDisabled(true)
			context.frame:GetElement("buttons.openAllExpires")
				:SetDisabled(true)

			context.frame:GetElement("buttons")
				:Draw()
		else
			context.frame:GetElement("top.filterInput")
				:SetDisabled(false)

			local all, sales, buys, cancels, expires = 0, 0, 0, 0, 0
			for _, row in private.inboxQuery:Iterator() do
				local iconType = row:GetField("icon")

				all = all + 1

				if iconType == "SALE" then
					sales = sales + 1
				elseif iconType == "BUY" then
					buys = buys + 1
				elseif iconType == "CANCEL" then
					cancels = cancels + 1
				elseif iconType == "EXPIRE" then
					expires = expires + 1
				end
			end

			local allMailButton = context.frame:GetElement("openAllMail")
			local saleButton = context.frame:GetElement("buttons.openAllSales")
			local buyButton = context.frame:GetElement("buttons.openAllBuys")
			local cancelButton = context.frame:GetElement("buttons.openAllCancels")
			local expiresButton = context.frame:GetElement("buttons.openAllExpires")

			allMailButton:SetDisabled(all == 0)
				:SetPressed(false)
				:Draw()
			saleButton:SetDisabled(sales == 0)
				:SetPressed(false)
			buyButton:SetDisabled(buys == 0)
				:SetPressed(false)
			cancelButton:SetDisabled(cancels == 0)
				:SetPressed(false)
			expiresButton:SetDisabled(expires == 0)
				:SetPressed(false)

			context.frame:GetElement("buttons")
				:Draw()
		end
	end

	private.fsm = TSMAPI_FOUR.FSM.New("MAILING_INBOX")
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_HIDDEN")
			:SetOnEnter(function(context)
				TSM.Mailing.Open.KillThread()
				TSMAPI_FOUR.Delay.Cancel("mailUpdateCounter")
				context.frame = nil
			end)
			:AddTransition("ST_SHOWN")
			:AddTransition("ST_HIDDEN")
			:AddEvent("EV_FRAME_SHOW", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_SHOWN"))
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_SHOWN")
			:SetOnEnter(function(context, frame, filterText)
				if not context.frame then
					context.frame = frame
					UpdateText(context, filterText)
					UpdateButtons(context, filterText)
				end
			end)
			:AddTransition("ST_HIDDEN")
			:AddTransition("ST_OPENING_START")
			:AddEvent("EV_MAIL_DATA_UPDATED", function(context, filterText)
				UpdateText(context, filterText)
				UpdateButtons(context, filterText)
			end)
			:AddEvent("EV_BUTTON_CLICKED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_OPENING_START"))
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_OPENING_START")
			:SetOnEnter(function(context, autoRefresh, keepMoney, filterText, filterType)
				context.opening = true
				UpdateButtons(context)
				TSM.Mailing.Open.StartOpening(private.FSMOpenCallback, autoRefresh, keepMoney, filterText, filterType)
			end)
			:SetOnExit(function(context)
				context.opening = false
				UpdateButtons(context)
			end)
			:AddTransition("ST_SHOWN")
			:AddTransition("ST_HIDDEN")
			:AddEvent("EV_MAIL_DATA_UPDATED", function(context, filterText)
				UpdateText(context, filterText)
			end)
			:AddEvent("EV_OPENING_DONE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_SHOWN"))
		)
		:AddDefaultEvent("EV_FRAME_HIDE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_HIDDEN"))
		:Init("ST_HIDDEN", fsmContext)
end

function private.FSMOpenCallback()
	private.fsm:ProcessEvent("EV_OPENING_DONE")

	TSMAPI_FOUR.Sound.PlaySound(TSM.db.global.mailingOptions.openMailSound)
end
