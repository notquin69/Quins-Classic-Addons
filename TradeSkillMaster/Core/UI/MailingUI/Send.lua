-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Send = TSM.UI.MailingUI:NewPackage("Send")
local L = TSM.L
local private = {
	fsm = nil,
	frame = nil,
	contacts = nil,
	contactList = nil,
	db = nil,
	query = nil,
	recipient = "",
	subject = "",
	body = "",
	money = 0,
	isMoney = true,
	isCOD = false,
	listName = "",
	listElements = {},
	listFilter = ""
}
local PLAYER_NAME_REALM = string.gsub(UnitName("player").."-"..GetRealmName(), "%s+", "")



-- ============================================================================
-- Module Functions
-- ============================================================================

function Send.OnInitialize()
	private.FSMCreate()
	TSM.UI.MailingUI.RegisterTopLevelPage(L["Send"], "iconPack.24x24/Send Mail", private.GetSendFrame)

	private.db = TSMAPI_FOUR.Database.NewSchema("MAILTRACKING_SEND_INFO")
		:AddStringField("itemString")
		:AddNumberField("quantity")
		:Commit()
	private.query = private.db:NewQuery()
end

function Send.SetSendRecipient(recipient)
	private.recipient = recipient
end



-- ============================================================================
-- Send UI
-- ============================================================================

function private.GetSendFrame()
	TSM.UI.AnalyticsRecordPathChange("mailing", "send")
	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "send")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "container")
			:SetLayout("VERTICAL")
			:SetStyle("background", "#2e2e2e")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "recipient")
				:SetStyle("margin", { top = 35, left = 10, right = 10, bottom = 4 })
				:SetStyle("height", 13)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 10)
				:SetStyle("justifyH", "LEFT")
				:SetText(L["RECIPIENT"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "name")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 20)
				:SetStyle("margin", { left = 10, right = 10, bottom = 9 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
					:SetStyle("height", 20)
					:SetStyle("clearButton", true)
					:SetStyle("autoComplete", TSMAPI_FOUR.PlayerInfo.GetAlts())
					:SetStyle("font", TSM.UI.Fonts.FRIZQT)
					:SetStyle("fontHeight", 13)
					:SetText(private.recipient)
					:SetScript("OnEnterPressed", private.RecipientOnTextChanged)
					:SetScript("OnTextChanged", private.RecipientOnTextChanged)
					:SetScript("OnTabPressed", private.RecipientOnTabPressed)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "contacts")
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("margin.left", 8)
					:SetStyle("width", 119)
					:SetStyle("height", 20)
					:SetStyle("fontHeight", 12)
					:SetText(L["CONTACTS"])
					:SetScript("OnClick", private.ContactsBtnOnClick)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "opt")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 14)
				:SetStyle("margin", { left = 10, right = 10, bottom = 15 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "add")
					:SetStyle("margin.right", 8)
					:SetStyle("width", 14)
					:SetStyle("height", 14)
					:SetStyle("backgroundTexturePack", "iconPack.14x14/Add/Circle")
					:SetScript("OnClick", private.SubjectBtnOnClick)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "subject")
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 10)
					:SetStyle("justifyH", "LEFT")
					:SetText(L["Add Subject / Description (Optional)"])
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "header")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 13)
				:SetStyle("margin", { left = 10, right = 10, bottom = 4 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "items")
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 10)
					:SetStyle("justifyH", "LEFT")
					:SetText(L["ITEMS"])
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "postage")
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 10)
					:SetStyle("justifyH", "RIGHT")
					:SetText(L["POSTAGE"]..": "..TSM.Money.ToString(30))
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("BorderedFrame", "dragBox")
				:SetLayout("HORIZONTAL")
				:SetStyle("borderTheme", "roundDark")
				:SetStyle("margin", { left = 10, right = 10, bottom = 6 })
				:RegisterForDrag("LeftButton")
				:SetScript("OnReceiveDrag", private.DragBoxOnItemRecieve)
				:SetScript("OnMouseUp", private.DragBoxOnItemRecieve)
				:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "items")
					:SetStyle("anchors", { { "TOPLEFT", 2, -2 }, { "BOTTOMRIGHT", -2, 26 } })
					:SetStyle("hideHeader", true)
					:SetStyle("headerBackground", "#00000000")
					:SetStyle("background", "#1b1b1b")
					:SetStyle("altBackground", "#000000")
					:SetStyle("highlight", "#30290b")
					:SetStyle("headerFont", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("headerFontHeight", 14)
					:SetStyle("margin.bottom", 1)
					:GetScrollingTableInfo()
						:NewColumn("item")
							:SetFont(TSM.UI.Fonts.FRIZQT)
							:SetFontHeight(12)
							:SetJustifyH("LEFT")
							:SetTextInfo("itemString", TSM.UI.GetColoredItemName)
							:SetIconInfo("itemString", TSMAPI_FOUR.Item.GetTexture)
							:SetTooltipInfo("itemString")
							:SetTooltipLinkingDisabled(true)
							:Commit()
						:NewColumn("quantity")
							:SetWidth(100)
							:SetFont(TSM.UI.Fonts.RobotoMedium)
							:SetFontHeight(12)
							:SetJustifyH("RIGHT")
							:SetTextInfo("quantity")
							:Commit()
						:Commit()
					:SetQuery(private.query)
					:SetScript("OnRowClick", private.QueryOnRowClick)
					:SetScript("OnDataUpdated", private.SendOnDataUpdated)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "dragTextBig")
					:SetStyle("anchors", { { "CENTER" } })
					:SetStyle("autoWidth", true)
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 24)
					:SetStyle("justifyH", "CENTER")
					:SetText(L["Drag Item(s) Into Box"])
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "dragTextSmall")
					:SetStyle("anchors", { { "BOTTOMLEFT", 8, 5 } })
					:SetStyle("height", 15)
					:SetStyle("width", 220)
					:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
					:SetStyle("fontHeight", 12)
					:SetStyle("justifyH", "LEFT")
					:SetFormattedText(L["Drag in Additional Items (%d/%d Items)"], 0, ATTACHMENTS_MAX_SEND)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "footer")
					:SetLayout("HORIZONTAL")
					:SetStyle("anchors", { { "TOPLEFT", 2, -2 }, { "BOTTOMRIGHT", -2, 2 } })
					:SetStyle("background", "#1b1b1b")
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "check")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 24)
				:SetStyle("margin", { left = 6, right = 6 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "sendCheck")
					:SetStyle("height", 16)
					:SetStyle("margin.top", 1)
					:SetCheckboxPosition("LEFT")
					:SetChecked(private.isMoney)
					:SetText(L["Send Money"])
					:SetStyle("fontHeight", 12)
					:SetStyle("checkboxSpacing", 1)
					:SetScript("OnValueChanged", private.SendOnValueChanged)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer")
					:SetStyle("height", 16)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer")
					:SetStyle("height", 16)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "checkbox")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 24)
				:SetStyle("margin", { left = 6, right = 6})
				:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "cod")
					:SetStyle("height", 16)
					:SetStyle("margin.top", 1)
					:SetCheckboxPosition("LEFT")
					:SetChecked(private.isCOD)
					:SetText(L["Make Cash On Delivery?"])
					:SetStyle("fontHeight", 12)
					:SetStyle("checkboxSpacing", 1)
					:SetDisabled(true)
					:SetScript("OnValueChanged", private.CODOnValueChanged)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "amountText")
					:SetStyle("margin", { top = 1, right = 7 })
					:SetStyle("height", 13)
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 10)
					:SetStyle("justifyH", "RIGHT")
					:SetText(L["AMOUNT"]..":")
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "moneyInput")
					:SetStyle("margin.right", 4)
					:SetStyle("width", 169)
					:SetStyle("height", 20)
					:SetStyle("justifyH", "RIGHT")
					:SetText(TSM.Money.ToString(private.money))
					:SetScript("OnTextChanged", private.MoneyOnTextChanged)
					:SetScript("OnEnterPressed", private.MoneyValueConvert)
					:SetScript("OnEscapePressed", private.MoneyValueConvert)
					:SetScript("OnTabPressed", private.MoneyValueConvert)
					:SetScript("OnEditFocusGained", private.MoneyFocusGained)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer")
				:SetStyle("height", 8)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "footer")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 30)
			:SetStyle("margin", { top = 6 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "money")
				:SetLayout("VERTICAL")
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
					:SetStyle("margin.bottom", 2)
					:SetStyle("height", 13)
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 10)
					:SetStyle("justifyH", "LEFT")
					:SetText(L["GOLD ON HAND"])
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("PlayerGoldText", "gold")
					:SetStyle("height", 16)
					:SetStyle("fontHeight", 12)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer")
				:SetStyle("height", 0)
				:SetStyle("width", 170)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "sendMail")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("margin.top", 4)
				:SetStyle("width", 184)
				:SetStyle("height", 26)
				:SetStyle("fontHeight", 14)
				:SetText(L["SEND MAIL"])
				:SetScript("OnClick", private.SendMail)
				:SetDisabled(true)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "clear")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("margin", { top = 3, left = 16, right = 10 })
				:SetStyle("width", 42)
				:SetStyle("height", 20)
				:SetStyle("fontHeight", 12)
				:SetText(L["Clear"])
				:SetScript("OnClick", private.ClearOnClick)
			)
		)
		:SetScript("OnUpdate", private.SendFrameOnUpdate)
		:SetScript("OnHide", private.SendFrameOnHide)

	private.frame = frame

	return frame
end

function private.GetContactsContentFrame(viewContainer, path)
	if path == "menu" then
		return private.GetContactsMenuFrame()
	elseif path == "list" then
		return private.GetContactListFrame()
	else
		error("Unexpected path: "..tostring(path))
	end
end

function private.GetContactsMenuFrame()
	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "frame")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "header")
			:SetLayout("HORIZONTAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "title")
				:SetStyle("margin", { top = 8, bottom = 16 })
				:SetStyle("height", 18)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetStyle("justifyH", "CENTER")
				:SetText(L["Contacts Menu"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "closeBtn")
				:SetStyle("margin", { top = -9, left = -18, right = 6 })
				:SetStyle("width", 18)
				:SetStyle("height", 18)
				:SetStyle("iconTexturePack", "iconPack.18x18/Close/Default")
				:SetScript("OnClick", private.CloseDialog)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionList", "list")
			:SetStyle("width", 248)
			:SetStyle("height", 152)
			:SetStyle("border", "#6d6d6d")
			:SetStyle("borderSize", 1)
			:SetStyle("rowHeight", 20)
			:SetStyle("padding", { top = 1, left = 1, right = 1, bottom = 1 })
			:SetStyle("textColor", "#ffffff")
			:SetEntries({L["Alts"], L["Recently Mailed"], L["Friends"], L["Guild"]})
			:SetScript("OnEntrySelected", private.MenuOnEntrySelected)
		)

	return frame
end

function private.GetContactListFrame()
	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "frame")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "header")
			:SetLayout("HORIZONTAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "backBtn")
				:SetStyle("margin", { top = -9, left = 6 })
				:SetStyle("width", 18)
				:SetStyle("height", 18)
				:SetStyle("backgroundTexturePack", "iconPack.18x18/SideArrow")
				:SetStyle("backgroundTextureRotation", 180)
				:SetScript("OnClick", private.ListBackButtonOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "title")
				:SetStyle("margin", { top = 8, bottom = 16 })
				:SetStyle("height", 18)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetStyle("justifyH", "CENTER")
				:SetText(private.listName.." "..L["List"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "closeBtn")
				:SetStyle("margin", { top = -9, right = 6 })
				:SetStyle("width", 18)
				:SetStyle("height", 18)
				:SetStyle("iconTexturePack", "iconPack.18x18/Close/Default")
				:SetScript("OnClick", private.CloseDialog)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("SearchInput", "filterInput")
			:SetStyle("margin", { top = -9, left = 8, right = 8, bottom = 8 })
			:SetStyle("height", 20)
			:SetHintText(L["Search"].." "..private.listName)
			:SetScript("OnTextChanged", private.FilterSearchInputOnTextChanged)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionList", "list")
			:SetStyle("width", 248)
			:SetStyle("height", 133)
			:SetStyle("border", "#6d6d6d")
			:SetStyle("borderSize", 1)
			:SetStyle("rowHeight", 20)
			:SetStyle("padding", { top = 1, left = 1, right = 1, bottom = 1 })
			:SetEntries(private.listElements)
			:SetScript("OnEntrySelected", private.ListOnEntrySelected)
		)

	private.contactList = frame

	return frame
end

function private.SubjectBtnOnClick(button)
	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "frame")
		:SetLayout("VERTICAL")
		:SetStyle("width", 390)
		:SetStyle("height", 248)
		:SetStyle("anchors", { { "CENTER" } })
		:SetStyle("background", "#323232")
		:SetStyle("border", "#e2e2e2")
		:SetStyle("borderSize", 1)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "button")
			:SetLayout("HORIZONTAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "title")
				:SetStyle("margin", { top = 8, bottom = 11 })
				:SetStyle("height", 18)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetStyle("justifyH", "CENTER")
				:SetText(L["Add Subject / Description"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "closeBtn")
				:SetStyle("margin", { top = -9, left = -18, right = 8 })
				:SetStyle("width", 18)
				:SetStyle("height", 18)
				:SetStyle("iconTexturePack", "iconPack.18x18/Close/Default")
				:SetScript("OnClick", private.CloseDialog)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "subjectText")
			:SetStyle("margin", { left = 8, right = 8, bottom = 4 })
			:SetStyle("height", 13)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 10)
			:SetStyle("justifyH", "LEFT")
			:SetText(L["SUBJECT"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "subjectInput")
			:SetStyle("margin", { left = 8, right = 8, bottom = 12 })
			:SetStyle("height", 20)
			:SetStyle("justifyH", "LEFT")
			:SetStyle("clearButton", true)
			:SetStyle("font", TSM.UI.Fonts.FRIZQT)
			:SetStyle("fontHeight", 13)
			:SetMaxLetters(64)
			:SetText(private.subject)
			:SetScript("OnTextChanged", private.SubjectOnTextChanged)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "recipientText")
			:SetStyle("margin", { left = 8, right = 8, bottom = 4 })
			:SetStyle("height", 13)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 10)
			:SetStyle("justifyH", "LEFT")
			:SetText(strupper(DESCRIPTION))
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("BorderedFrame", "description")
			:SetLayout("HORIZONTAL")
			:SetStyle("borderTheme", "roundDark")
			:SetStyle("margin", { left = 8, right = 8, bottom = 2 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("ScrollFrame", "scroll")
				:SetStyle("height", 93)
				:SetStyle("margin", { top = 2, left = 2, right = 2, bottom = 2 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
					:SetStyle("height", 93)
					:SetStyle("fontHeight", 13)
					:SetStyle("justifyH", "LEFT")
					:SetStyle("font", TSM.UI.Fonts.FRIZQT)
					:SetMultiLine(true)
					:SetMaxLetters(500)
					:SetText(private.body)
					:SetScript("OnTextChanged", private.DesciptionOnTextChanged)
					:SetScript("OnSizeChanged", private.DesciptionOnSizeChanged)
					:SetScript("OnCursorChanged", private.DesciptionOnCursorChanged)
				)
			)
			:SetScript("OnMouseUp", private.DescriptionOnMouseUp)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "footer")
			:SetLayout("HORIZONTAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "title")
				:SetStyle("margin", { left = 8, bottom = 8 })
				:SetStyle("height", 13)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 10)
				:SetStyle("justifyH", "RIGHT")
				:SetFormattedText(L["(%d/500 Characters)"], #private.body)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "clearAll")
				:SetStyle("font", TSM.UI.Fonts.MontserratBold)
				:SetStyle("margin", { left = 4, right = 8, bottom = 8 })
				:SetStyle("width", 44)
				:SetStyle("height", 10)
				:SetStyle("fontHeight", 10)
				:SetStyle("justifyH", "LEFT")
				:SetText(L["Clear All"])
				:SetScript("OnClick", private.SubjectClearAllBtnOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "button")
			:SetLayout("HORIZONTAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "addMailBtn")
				:SetStyle("margin.left", { left = 172, right = 8, bottom = 8 })
				:SetStyle("width", 201)
				:SetStyle("height", 20)
				:SetText(L["ADD TO MAIL"])
				:SetScript("OnClick", private.AddToMailBtnOnClick)
			)
		)

	button:GetBaseElement():ShowDialogFrame(frame)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.SendFrameOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)
	frame:GetBaseElement():SetBottomPadding(36)

	private.fsm:ProcessEvent("EV_FRAME_SHOW", frame)
end

function private.SendFrameOnHide(frame)
	assert(frame == private.frame)
	private.frame = nil

	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function private.ClearOnClick(button)
	private.fsm:ProcessEvent("EV_MAIL_CLEAR", true)
end

function private.CloseDialog(button)
	button:GetBaseElement():HideDialog()
end

function private.ContactsBtnOnClick(button)
	button:GetParentElement():GetElement("input"):SetFocused(false)
		:Draw()
	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "frame")
		:SetLayout("VERTICAL")
		:SetStyle("width", 264)
		:SetStyle("height", 202)
		:SetStyle("anchors", { { "CENTER" } })
		:SetStyle("background", "#2e2e2e")
		:SetStyle("border", "#e2e2e2")
		:SetStyle("borderSize", 1)
		:AddChild(TSMAPI_FOUR.UI.NewElement("ViewContainer", "contacts")
			:SetNavCallback(private.GetContactsContentFrame)
			:AddPath("menu")
			:AddPath("list")
			:SetPath("menu")
		)

	private.contacts = frame

	button:GetBaseElement():ShowDialogFrame(frame)

	return frame
end

function private.MenuOnEntrySelected(list, name)
	private.listName = name

	private.GenerateListElements(private.listName)

	private.contacts:GetElement("contacts"):SetPath("list", true)
end

function private.ListBackButtonOnClick()
	private.contacts:GetElement("contacts"):SetPath("menu", true)
end

function private.FilterSearchInputOnTextChanged(input)
	local text = strtrim(input:GetText())
	if text == private.listFilter then
		return
	end
	private.listFilter = text

	private.GenerateListElements(private.listName, private.listFilter)
end

function private.ListOnEntrySelected(list, name)
	list:GetBaseElement():HideDialog()
	private.frame:GetElement("container.name.input"):SetText(name)
		:Draw()
end

function private.DragBoxOnItemRecieve(frame, button)
	if not CursorHasItem() then
		ClearCursor()
		return
	end

	if private.query:Count() >= 12 then
		ClearCursor()
		UIErrorsFrame:AddMessage(ERR_MAIL_INVALID_ATTACHMENT_SLOT, 1.0, 0.1, 0.1, 1.0)
		return
	end

	local _, _, subType = GetCursorInfo()
	local itemString = TSMAPI_FOUR.Item.ToItemString(subType)
	local stackSize
	for _, bag, slot, iString, quantity in TSMAPI_FOUR.Inventory.BagIterator(false, false, true) do
		if itemString == iString and TSMAPI_FOUR.Inventory.IsBagSlotLocked(bag, slot) then
			stackSize = quantity
		end
	end
	ClearCursor()
	if not stackSize then
		return
	end

	private.DatabaseNewRow(itemString, stackSize)
end

function private.QueryOnRowClick(scrollingTable, row, button)
	if button == "RightButton" then
		private.db:DeleteRow(row)
	end
end

function private.SendOnDataUpdated()
	private.fsm:ProcessEvent("EV_MAIL_DATA_UPDATED")
end

function private.SubjectClearAllBtnOnClick(button)
	private.subject = ""
	private.body = ""

	button:GetElement("__parent.__parent.subjectInput")
		:SetFocused(false)
		:SetText(private.subject)
		:Draw()
	button:GetElement("__parent.__parent.description.scroll.input")
		:SetFocused(false)
		:SetText(private.body)
		:Draw()

	button:GetElement("__parent.title"):SetFormattedText(L["(%d/500 Characters)"], 0)
		:Draw()
end

function private.AddToMailBtnOnClick(button)
	private.CloseDialog(button)
end

function private.RecipientOnTabPressed(input)
	input:HighlightText(0, 0)
		:SetFocused(false)
end

function private.RecipientOnTextChanged(input)
	local text = strtrim(input:GetText())
	if input._compStart then
		if text == private.recipient then
			input:HighlightText(input._compStart, #text)
			input._compStart = nil
		else
			private.recipient = text

			input:SetText(private.recipient)
				:Draw()

			private.UpdateSendFrame()
		end
		return
	end
	if text == private.recipient then
		return
	end
	private.recipient = text
	input:SetText(private.recipient)
		:Draw()

	private.UpdateSendFrame()
end

function private.SubjectOnTextChanged(input)
	local text = input:GetText()
	if input:GetText() == private.subject then
		return
	end
	private.subject = text
	input:SetText(private.subject)
		:Draw()

	private.UpdateSendFrame()
end

function private.DesciptionOnTextChanged(input)
	local text = input:GetText()
	if input:GetText() == private.body then
		return
	end
	private.body = text
	input:SetText(private.body)

	input:GetElement("__parent.__parent.__parent.footer.title"):SetFormattedText(L["(%d/500 Characters)"], #private.body)
		:Draw()
end

function private.DescriptionOnMouseUp(frame)
	frame:GetElement("scroll.input"):SetFocused(true)
end

function private.DesciptionOnSizeChanged(input, width, height)
	if not input:HasFocus() then
		return
	end

	private.DesciptionOnTextChanged(input)

	input:SetStyle("height", height)
	input:GetParentElement():Draw()
end

function private.DesciptionOnCursorChanged(input, _, y)
	local scrollFrame = input:GetParentElement()
	scrollFrame._scrollbar:SetValue(TSMAPI_FOUR.Util.Round(abs(y) / (input:_GetStyle("height") - 22) * scrollFrame:_GetMaxScroll()))
end

function private.SendOnValueChanged(checkbox)
	if checkbox:IsChecked() then
		checkbox:GetElement("__parent.__parent.checkbox.cod"):SetChecked(false)
			:Draw()

		private.isMoney = true
		private.isCOD = false
	else
		private.isMoney = false
	end
end

function private.CODOnValueChanged(checkbox)
	if checkbox:IsChecked() then
		checkbox:GetElement("__parent.__parent.check.sendCheck"):SetChecked(false)
			:Draw()

		private.isMoney = false
		private.isCOD = true

		local input = checkbox:GetElement("__parent.moneyInput")
		local text = gsub(strtrim(input:GetText()), TSMAPI_FOUR.Util.StrEscape(LARGE_NUMBER_SEPERATOR), "")
		local value = tonumber(text) or TSM.Money.FromString(text) or 0
		private.money = private.isCOD and min(value, 100000000) or value
		input:SetText(TSM.Money.ToString(private.money))
			:Draw()
	else
		private.isCOD = false
	end
end

function private.MoneyFocusGained(input)
	input:HighlightText()
end

function private.MoneyOnTextChanged(input)
	local text = gsub(strtrim(input:GetText()), TSMAPI_FOUR.Util.StrEscape(LARGE_NUMBER_SEPERATOR), "")
	if text == "" or text == private.money then
		return
	end

	if tonumber(text) then
		private.money = tonumber(text)
	else
		private.money = TSM.Money.FromString(text) or 0
	end

	private.UpdateSendFrame()
end

function private.MoneyValueConvert(input)
	local text = gsub(strtrim(input:GetText()), TSMAPI_FOUR.Util.StrEscape(LARGE_NUMBER_SEPERATOR), "")
	local value = min(max(tonumber(text) or TSM.Money.FromString(text) or 0, 0), MAXIMUM_BID_PRICE)

	private.money = private.isCOD and min(value, 100000000) or value

	input:SetFocused(false)
	input:SetText(TSM.Money.ToString(private.money))
		:Draw()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.SendMail(button)
	local money = 0
	if private.money > 0 and private.isMoney then
		money = private.money
	elseif private.money > 0 and private.isCOD then
		money = private.money * -1
	end

	button:GetElement("__parent.__parent.container.name.input"):SetFocused(false)
	private.UpdateRecentlyMailed(private.recipient)

	if private.query:Count() > 0 then
		local items = {}
		for _, row in private.query:Iterator() do
			local itemString = row:GetField("itemString")
			local quantity = row:GetField("quantity")
			if items[itemString] then
				items[itemString] = items[itemString] + quantity
			else
				items[itemString] = quantity
			end
		end

		private.fsm:ProcessEvent("EV_BUTTON_CLICKED", IsShiftKeyDown(), private.recipient, private.subject, private.body, money, items)
	else
		private.fsm:ProcessEvent("EV_BUTTON_CLICKED", IsShiftKeyDown(), private.recipient, private.subject, private.body, money)
	end
end

function private.UpdateRecentlyMailed(recipient)
	if recipient == UnitName("player") or recipient == PLAYER_NAME_REALM then
		return
	end

	local size = 0
	local oldestName = nil
	local oldestTime = nil
	for k, v in pairs(TSM.db.global.mailingOptions.recentlyMailedList) do
		size = size + 1
		if not oldestName or not oldestTime or oldestTime > v then
			oldestName = k
			oldestTime = v
		end
	end

	if size >= 20 then
		TSM.db.global.mailingOptions.recentlyMailedList[oldestName] = nil
	end

	TSM.db.global.mailingOptions.recentlyMailedList[recipient] = time()
end

function private.UpdateSendFrame()
	if not private.frame then
		return
	end

	local sendMail = private.frame:GetElement("footer.sendMail")
	if private.recipient ~= "" then
		sendMail:SetDisabled(false)
	else
		sendMail:SetDisabled(true)
	end
	sendMail:Draw()
end

function private.DatabaseNewRow(itemString, stackSize)
	private.db:NewRow()
		:SetField("itemString", itemString)
		:SetField("quantity", stackSize)
		:Create()
end

function private.GenerateListElements(category, filterText)
	private.listElements = {}
	if category == L["Alts"] then
		for factionrealm in TSM.db:GetConnectedRealmIterator("realm") do
			for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
				character = Ambiguate(gsub(strmatch(character, "(.*) "..TSMAPI_FOUR.Util.StrEscape("-")).."-"..gsub(factionrealm, TSMAPI_FOUR.Util.StrEscape("-"), ""), " ", ""), "none")
				if character ~= UnitName("player") then
					if filterText and filterText ~= "" then
						if strfind(strlower(character), filterText) then
							tinsert(private.listElements, character)
						end
					else
						tinsert(private.listElements, character)
					end
				end
			end
		end
	elseif category == L["Recently Mailed"] then
		for k in pairs(TSM.db.global.mailingOptions.recentlyMailedList) do
			local character = Ambiguate(k, "none")
			if filterText and filterText ~= "" then
				if strfind(strlower(character), filterText) then
					tinsert(private.listElements, character)
				end
			else
				tinsert(private.listElements, character)
			end
		end
	elseif category == L["Friends"] then
		for i = 1, C_FriendList.GetNumFriends() do
			local info = C_FriendList.GetFriendInfoByIndex(i)
			if info.name ~= PLAYER_NAME_REALM then
				local character = Ambiguate(info.name, "none")
				if filterText and filterText ~= "" then
					if strfind(strlower(character), filterText) then
						tinsert(private.listElements, character)
					end
				else
					tinsert(private.listElements, character)
				end
			end
		end
	elseif category == L["Guild"] then
		for i = 1, GetNumGuildMembers() do
			local name = GetGuildRosterInfo(i)
			if name ~= PLAYER_NAME_REALM then
				local character = Ambiguate(name, "none")
				if filterText and filterText ~= "" then
					if strfind(strlower(character), filterText) then
						tinsert(private.listElements, character)
					end
				else
					tinsert(private.listElements, character)
				end
			end
		end
	end

	sort(private.listElements)

	if private.contactList and private.contactList:GetElement("list") then
		private.contactList:GetElement("list"):SetEntries(private.listElements)
			:Draw()
	end
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.FSMCreate()
	TSMAPI_FOUR.Event.Register("MAIL_CLOSED", function()
		private.fsm:ProcessEvent("EV_MAIL_CLEAR")
	end)
	TSMAPI_FOUR.Event.Register("MAIL_SEND_INFO_UPDATE", function()
		private.fsm:ProcessEvent("EV_MAIL_INFO_UPDATE")
	end)
	TSMAPI_FOUR.Event.Register("MAIL_FAILED", function()
		private.fsm:ProcessEvent("EV_SENDING_DONE")
	end)

	local fsmContext = {
		frame = nil,
		sending = false,
		keepInfo = false
	}

	local function UpdateFrame(context)
		local smallText = context.frame:GetElement("container.dragBox.dragTextSmall")
		local bigText = context.frame:GetElement("container.dragBox.dragTextBig")
		local postage = context.frame:GetElement("container.header.postage")
		local send = context.frame:GetElement("container.check.sendCheck")
		local cod = context.frame:GetElement("container.checkbox.cod")

		local size = private.query:Count()

		if size > 0 then
			postage:SetText(L["POSTAGE"]..": "..TSM.Money.ToString(30 * size))
				:Draw()

			bigText:Hide()
			smallText:SetFormattedText(L["Drag in Additional Items (%d/%d Items)"], size, ATTACHMENTS_MAX_SEND)
				:Draw()
			smallText:Show()
			cod:SetDisabled(false)
				:Draw()
		else
			postage:SetText(L["POSTAGE"]..": "..TSM.Money.ToString(30))
				:Draw()

			bigText:Show()
			smallText:Hide()
			cod:SetDisabled(true)
				:Draw()
			send:SetChecked(true)
				:SetDisabled(false)
				:Draw()
		end
	end

	local function UpdateButton(context)
		context.frame:GetElement("footer.sendMail")
			:SetText(context.sending and L["SENDING..."] or L["SEND MAIL"])
			:SetPressed(context.sending)
			:Draw()
	end

	local function UpdateSendMailInfo(context)
		if private.query:Count() >= 12 then
			UIErrorsFrame:AddMessage(ERR_MAIL_INVALID_ATTACHMENT_SLOT, 1.0, 0.1, 0.1, 1.0)
		else
			for i = 1, ATTACHMENTS_MAX_SEND do
				local itemName, _, _, stackCount = GetSendMailItem(i)
				if itemName and stackCount then
					local itemLink = GetSendMailItemLink(i)
					local itemString = TSMAPI_FOUR.Item.ToItemString(itemLink)

					private.DatabaseNewRow(itemString, stackCount)

					break
				end
			end
		end

		ClearSendMail()
	end

	local function ClearMail(context, keepInfo, redraw)
		if not keepInfo then
			private.recipient = ""
		end
		private.subject = ""
		private.body = ""
		private.money = 0
		private.isMoney = true
		private.isCOD = false

		private.db:Truncate()

		if redraw and context.frame then
			context.frame:GetElement("container.name.input"):SetText(private.recipient)
				:Draw()
			context.frame:GetElement("container.checkbox.moneyInput"):SetText(TSM.Money.ToString(private.money))
				:Draw()
		end
	end

	local function SendMailShowing()
		SetSendMailShowing(true)
	end

	private.fsm = TSMAPI_FOUR.FSM.New("MAILING_SEND")
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_HIDDEN")
			:SetOnEnter(function(context)
				TSM.Mailing.Send.KillThread()
				SetSendMailShowing(false)
				context.frame = nil
			end)
			:AddTransition("ST_SHOWN")
			:AddTransition("ST_HIDDEN")
			:AddEvent("EV_FRAME_SHOW", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_SHOWN"))
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_SHOWN")
			:SetOnEnter(function(context, frame)
				if not context.frame then
					context.frame = frame
					UpdateFrame(context)
					TSMAPI_FOUR.Delay.AfterFrame("setMailShowing", 2, SendMailShowing)
				end
				UpdateButton(context)
			end)
			:AddTransition("ST_HIDDEN")
			:AddTransition("ST_SENDING_START")
			:AddEvent("EV_MAIL_INFO_UPDATE", function(context)
				UpdateSendMailInfo(context)
				UpdateFrame(context)
			end)
			:AddEvent("EV_MAIL_DATA_UPDATED", function(context)
				UpdateFrame(context)
			end)
			:AddEvent("EV_MAIL_CLEAR", function(context, redraw)
				ClearMail(context, IsShiftKeyDown(), redraw)
			end)
			:AddEvent("EV_BUTTON_CLICKED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_SENDING_START"))
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_SENDING_START")
			:SetOnEnter(function(context, keepInfo, recipient, subject, body, money, items)
				context.sending = true
				context.keepInfo = keepInfo
				private.db:SetQueryUpdatesPaused(true)
				TSM.Mailing.Send.StartSending(private.FSMSendCallback, recipient, subject, body, money, items)
				UpdateButton(context)
			end)
			:SetOnExit(function(context)
				context.sending = false
				private.db:SetQueryUpdatesPaused(false)
				ClearMail(context, context.keepInfo, true)
				UpdateFrame(context)
			end)
			:AddTransition("ST_SHOWN")
			:AddTransition("ST_HIDDEN")
			:AddEvent("EV_SENDING_DONE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_SHOWN"))
		)
		:AddDefaultEvent("EV_FRAME_HIDE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_HIDDEN"))
		:Init("ST_HIDDEN", fsmContext)
end

function private.FSMSendCallback()
	private.fsm:ProcessEvent("EV_SENDING_DONE")
end
