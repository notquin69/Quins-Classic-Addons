-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Groups = TSM.UI.MailingUI:NewPackage("Other")
local L = TSM.L
local private = {
	frame = nil,
}

local PLAYER_NAME = UnitName("player")
local PLAYER_NAME_REALM = string.gsub(PLAYER_NAME.."-"..GetRealmName(), "%s+", "")



-- ============================================================================
-- Module Functions
-- ============================================================================

function Groups.OnInitialize()
	private.FSMCreate()
	TSM.UI.MailingUI.RegisterTopLevelPage(OTHER, "iconPack.24x24/Other", private.GetOtherFrame)
end



-- ============================================================================
-- Other UI
-- ============================================================================

function private.GetOtherFrame()
	TSM.UI.AnalyticsRecordPathChange("mailing", "other")
	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "other")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "container")
			:SetLayout("VERTICAL")
			:SetStyle("margin.bottom", 36)
			:SetStyle("background", "#2e2e2e")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "enchant")
				:SetStyle("margin", { top = 47, left = 12, right = 12 })
				:SetStyle("height", 19)
				:SetStyle("font", TSM.UI.Fonts.MontserratBold)
				:SetStyle("fontHeight", 16)
				:SetStyle("justifyH", "LEFT")
				:SetText(L["Mail Disenchantables"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "enchantDesc")
				:SetStyle("margin", { top = 4, left = 12, right = 12 })
				:SetStyle("height", 18)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 14)
				:SetStyle("justifyH", "LEFT")
				:SetText(L["Quickly mail all excess disenchantable items to a character"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "enchantRecipient")
				:SetStyle("margin", { top = 16, left = 12, right = 12 })
				:SetStyle("height", 13)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 10)
				:SetStyle("justifyH", "LEFT")
				:SetText(L["RECIPIENT"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "enchantHeader")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 26)
				:SetStyle("margin", { top = 4, left = 10, right = 17 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "recipient")
					:SetStyle("margin.right", 16)
					:SetStyle("height", 20)
					:SetStyle("clearButton", true)
					:SetStyle("autoComplete", TSMAPI_FOUR.PlayerInfo.GetAlts())
					:SetStyle("font", TSM.UI.Fonts.FRIZQT)
					:SetStyle("fontHeight", 13)
					:SetText(TSM.db.factionrealm.internalData.mailDisenchantablesChar)
					:SetScript("OnEnterPressed", private.EchantRecipientOnTextChanged)
					:SetScript("OnTextChanged", private.EchantRecipientOnTextChanged)
					:SetScript("OnTabPressed", private.EchantRecipientOnTabPressed)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "send")
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("width", 238)
					:SetStyle("height", 26)
					:SetStyle("fontHeight", 14)
					:SetDisabled(true)
					:SetText(L["SEND DISENCHANTABLES"])
					:SetScript("OnClick", private.EnchantSendBtnOnClick)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "gold")
				:SetStyle("margin", { top = 24, left = 12, right = 12 })
				:SetStyle("height", 19)
				:SetStyle("font", TSM.UI.Fonts.MontserratBold)
				:SetStyle("fontHeight", 16)
				:SetStyle("justifyH", "LEFT")
				:SetText(L["Send Excess Gold to Banker"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "goldDesc")
				:SetStyle("margin", { top = 4, left = 12, right = 12 })
				:SetStyle("height", 18)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 14)
				:SetStyle("justifyH", "LEFT")
				:SetText(L["Quickly mail all excess gold (limited to a certain amount) to a character"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "goldTextHeader")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 13)
				:SetStyle("margin", { top = 16, left = 12, right = 12 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "recipient")
					:SetStyle("margin.right", 16)
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 10)
					:SetStyle("justifyH", "LEFT")
					:SetText(L["RECIPIENT"])
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "limit")
					:SetStyle("margin.right", 16)
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 10)
					:SetStyle("justifyH", "LEFT")
					:SetText(L["LIMIT"])
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer")
					:SetStyle("width", 162)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "goldHeader")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 26)
				:SetStyle("margin", { top = 4, left = 10, right = 17 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "recipient")
					:SetStyle("margin.right", 16)
					:SetStyle("height", 20)
					:SetStyle("clearButton", true)
					:SetStyle("autoComplete", TSMAPI_FOUR.PlayerInfo.GetAlts())
					:SetStyle("font", TSM.UI.Fonts.FRIZQT)
					:SetStyle("fontHeight", 13)
					:SetText(TSM.db.factionrealm.internalData.mailExcessGoldChar)
					:SetScript("OnEnterPressed", private.GoldRecipientOnTextChanged)
					:SetScript("OnTextChanged", private.GoldRecipientOnTextChanged)
					:SetScript("OnTabPressed", private.GoldRecipientOnTabPressed)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "limit")
					:SetStyle("margin.right", 16)
					:SetStyle("height", 20)
					:SetStyle("justifyH", "RIGHT")
					:SetText(TSM.Money.ToString(TSM.db.factionrealm.internalData.mailExcessGoldLimit))
					:SetScript("OnTextChanged", private.MoneyOnTextChanged)
					:SetScript("OnEnterPressed", private.MoneyValueConvert)
					:SetScript("OnEscapePressed", private.MoneyValueConvert)
					:SetScript("OnTabPressed", private.MoneyValueConvert)
					:SetScript("OnEditFocusGained", private.MoneyFocusGained)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "send")
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("width", 162)
					:SetStyle("height", 26)
					:SetStyle("fontHeight", 14)
					:SetDisabled(true)
					:SetText(L["SEND GOLD"])
					:SetScript("OnClick", private.GoldSendBtnOnClick)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer")
			)
		)
		:SetScript("OnUpdate", private.FrameOnUpdate)
		:SetScript("OnHide", private.FrameOnHide)

	private.frame = frame

	return frame
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FrameOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)
	frame:GetBaseElement():SetBottomPadding(36)

	private.UpdateEnchantButton()
	private.UpdateGoldButton()

	private.fsm:ProcessEvent("EV_FRAME_SHOW", frame)
end

function private.FrameOnHide(frame)
	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function private.EchantRecipientOnTabPressed(input)
	input:HighlightText(0, 0)
		:SetFocused(false)
end

function private.EchantRecipientOnTextChanged(input)
	local text = strtrim(input:GetText())
	if input._compStart then
		if text == TSM.db.factionrealm.internalData.mailDisenchantablesChar then
			input:HighlightText(input._compStart, #text)
			input._compStart = nil
		else
			TSM.db.factionrealm.internalData.mailDisenchantablesChar = text
			input:SetText(TSM.db.factionrealm.internalData.mailDisenchantablesChar)
				:Draw()

			private.UpdateEnchantButton()
		end
		return
	end
	if text == TSM.db.factionrealm.internalData.mailDisenchantablesChar then
		return
	end
	TSM.db.factionrealm.internalData.mailDisenchantablesChar = text
	input:SetText(TSM.db.factionrealm.internalData.mailDisenchantablesChar)
		:Draw()

	private.UpdateEnchantButton()
end

function private.EnchantSendBtnOnClick(button)
	local items = {}
	for _, _, _, itemString, quantity in TSMAPI_FOUR.Inventory.BagIterator() do
		if TSMAPI_FOUR.Item.IsDisenchantable(itemString) and not TSMAPI_FOUR.Item.IsSoulbound(itemString) then
			local quality = TSMAPI_FOUR.Item.GetQuality(itemString)
			if quality <= TSM.db.global.mailingOptions.deMaxQuality then
				items[itemString] = (items[itemString] or 0) + quantity
			end
		end
	end

	private.fsm:ProcessEvent("EV_BUTTON_CLICKED", TSM.db.factionrealm.internalData.mailDisenchantablesChar, 0, items)
end

function private.GoldRecipientOnTabPressed(input)
	input:HighlightText(0, 0)
		:SetFocused(false)
end

function private.GoldRecipientOnTextChanged(input)
	local text = strtrim(input:GetText())
	if input._compStart then
		if text == TSM.db.factionrealm.internalData.mailExcessGoldChar then
			input:HighlightText(input._compStart, #text)
			input._compStart = nil
		else
			TSM.db.factionrealm.internalData.mailExcessGoldChar = text
			input:SetText(TSM.db.factionrealm.internalData.mailExcessGoldChar)
				:Draw()

			private.UpdateGoldButton()
		end
		return
	end
	if text == TSM.db.factionrealm.internalData.mailExcessGoldChar then
		return
	end
	TSM.db.factionrealm.internalData.mailExcessGoldChar = text
	input:SetText(TSM.db.factionrealm.internalData.mailExcessGoldChar)
		:Draw()

	private.UpdateGoldButton()
end

function private.GoldSendBtnOnClick(button)
	local money = private.GetSendMoney()
	private.fsm:ProcessEvent("EV_BUTTON_CLICKED", TSM.db.factionrealm.internalData.mailExcessGoldChar, money)
end

function private.MoneyFocusGained(input)
	input:HighlightText()
end

function private.MoneyOnTextChanged(input)
	local text = gsub(strtrim(input:GetText()), TSMAPI_FOUR.Util.StrEscape(LARGE_NUMBER_SEPERATOR), "")
	if text == "" or text == TSM.db.factionrealm.internalData.mailExcessGoldLimit then
		return
	end

	local limit = tonumber(text)
	if limit then
		TSM.db.factionrealm.internalData.mailExcessGoldLimit = limit >= 0 and limit or 0
	else
		TSM.db.factionrealm.internalData.mailExcessGoldLimit = TSM.Money.FromString(text) or 0
	end

	private.UpdateGoldButton()
end

function private.MoneyValueConvert(input)
	input:SetFocused(false)
	input:SetText(TSM.Money.ToString(min(TSM.db.factionrealm.internalData.mailExcessGoldLimit, MAXIMUM_BID_PRICE)))
		:Draw()

	private.UpdateGoldButton()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetSendMoney()
	local money = GetMoney() - 30 - TSM.db.factionrealm.internalData.mailExcessGoldLimit
	if money < 0 then
		money = 0
	end

	return money
end

function private.UpdateEnchantButton()
	local recipient = TSM.db.factionrealm.internalData.mailDisenchantablesChar
	local enchantButton = private.frame:GetElement("container.enchantHeader.send")

	if recipient == "" or recipient == PLAYER_NAME or recipient == PLAYER_NAME_REALM then
		enchantButton:SetDisabled(true)
			:Draw()
		return
	else
		enchantButton:SetDisabled(false)
			:Draw()
	end
end

function private.UpdateGoldButton()
	local recipient = TSM.db.factionrealm.internalData.mailExcessGoldChar
	local goldButton = private.frame:GetElement("container.goldHeader.send")

	if recipient == "" or recipient == PLAYER_NAME or recipient == PLAYER_NAME_REALM then
		goldButton:SetDisabled(true)
			:Draw()
		return
	end

	if private.GetSendMoney() > 0 then
		goldButton:SetDisabled(false)
	else
		goldButton:SetDisabled(true)
	end

	goldButton:Draw()
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.FSMCreate()
	TSMAPI_FOUR.Event.Register("PLAYER_MONEY", function()
		private.fsm:ProcessEvent("EV_PLAYER_MONEY_UPDATE")
	end)

	local fsmContext = {
		frame = nil,
		sending = false
	}

	local function UpdateEnchant(context)
		context.frame:GetElement("container.enchantHeader.send"):SetText(context.sending and L["SENDING..."] or L["SEND DISENCHANTABLES"])
			:SetPressed(context.sending)
			:Draw()
	end

	local function UpdateGold(context)
		private.UpdateGoldButton()

		context.frame:GetElement("container.goldHeader.send"):SetText(context.sending and L["SENDING..."] or L["SEND GOLD"])
			:SetPressed(context.sending)
			:Draw()
	end

	private.fsm = TSMAPI_FOUR.FSM.New("MAILING_GROUPS")
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_HIDDEN")
			:SetOnEnter(function(context)
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
				end
			end)
			:AddTransition("ST_HIDDEN")
			:AddTransition("ST_SENDING_START")
			:AddEvent("EV_PLAYER_MONEY_UPDATE", function(context)
				UpdateGold(context)
			end)
			:AddEvent("EV_BUTTON_CLICKED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_SENDING_START"))
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_SENDING_START")
			:SetOnEnter(function(context, recipient, money, items)
				context.sending = true
				if money > 0 then
					TSM.Mailing.Send.StartSending(private.FSMOthersCallback, recipient, "TSM Mailing: Excess Gold", "", money)
					UpdateGold(context)
				elseif items then
					TSM.Mailing.Send.StartSending(private.FSMOthersCallback, recipient, "TSM Mailing: Disenchantables", "", money, items)
					UpdateEnchant(context)
				end
			end)
			:SetOnExit(function(context)
				context.sending = false
				UpdateEnchant(context)
				UpdateGold(context)
			end)
			:AddTransition("ST_SHOWN")
			:AddTransition("ST_HIDDEN")
			:AddEvent("EV_SENDING_DONE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_SHOWN"))
		)
		:AddDefaultEvent("EV_FRAME_HIDE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_HIDDEN"))
		:Init("ST_HIDDEN", fsmContext)
end

function private.FSMOthersCallback()
	private.fsm:ProcessEvent("EV_SENDING_DONE")
end
