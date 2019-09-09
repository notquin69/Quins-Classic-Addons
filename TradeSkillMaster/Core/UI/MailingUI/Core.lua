-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local MailingUI = TSM.UI:NewPackage("MailingUI")
local L = TSM.L
local private = {
	topLevelPages = {},
	frame = nil,
	fsm = nil,
	defaultUISwitchBtn = nil,
	isVisible = false,
}
local MIN_FRAME_SIZE = { width = 560, height = 500 }



-- ============================================================================
-- Module Functions
-- ============================================================================

function MailingUI.OnInitialize()
	private.FSMCreate()
end

function MailingUI.OnDisable()
	-- hide the frame
	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function MailingUI.RegisterTopLevelPage(name, textureInfo, callback)
	tinsert(private.topLevelPages, { name = name, textureInfo = textureInfo, callback = callback })
end

function MailingUI.IsVisible()
	return private.isVisible
end

function MailingUI.SetSelectedTab(buttonText, redraw)
	private.frame:SetSelectedNavButton(buttonText, redraw)
end



-- ============================================================================
-- Main Frame
-- ============================================================================

function private.CreateMainFrame()
	TSM.UI.AnalyticsRecordPathChange("mailing")
	-- Always show the Inbox first
	TSM.db.global.internalData.mailingUIFrameContext.page = 1
	local frame = TSMAPI_FOUR.UI.NewElement("LargeApplicationFrame", "base")
		:SetParent(UIParent)
		:SetMinResize(MIN_FRAME_SIZE.width, MIN_FRAME_SIZE.height)
		:SetContextTable(TSM.db.global.internalData.mailingUIFrameContext, TSM.db:GetDefaultReadOnly("global", "internalData", "mailingUIFrameContext"))
		:SetStyle("strata", "HIGH")
		:SetStyle("titleStyle", "TITLE_ONLY")
		:SetTitle(L["TSM Mailing"])
		:AddSwitchButton(private.SwitchBtnOnClick)
		:SetScript("OnHide", private.BaseFrameOnHide)

	for _, info in ipairs(private.topLevelPages) do
		frame:AddNavButton(info.name, info.textureInfo, info.callback)
	end

	private.frame = frame

	return frame
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.BaseFrameOnHide()
	TSM.UI.AnalyticsRecordClose("mailing")
	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function private.GetNavFrame(_, path)
	return private.topLevelPages.callback[path]()
end

function private.SwitchBtnOnClick(button)
	TSM.db.global.internalData.mailingUIFrameContext.showDefault = button ~= private.defaultUISwitchBtn
	private.fsm:ProcessEvent("EV_SWITCH_BTN_CLICKED")
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.FSMCreate()
	local function MailShowDelayed()
		private.fsm:ProcessEvent("EV_MAIL_SHOW")
	end
	TSMAPI_FOUR.Event.Register("MAIL_SHOW", function()
		TSMAPI_FOUR.Delay.AfterFrame("MAIL_SHOW_DELAYED", 0, MailShowDelayed)
	end)
	TSMAPI_FOUR.Event.Register("MAIL_CLOSED", function()
		private.fsm:ProcessEvent("EV_MAIL_CLOSED")
	end)

	MailFrame:UnregisterEvent("MAIL_SHOW")
	CancelEmote()

	local fsmContext = {
		frame = nil,
	}

	local function DefaultFrameOnHide()
		private.fsm:ProcessEvent("EV_FRAME_HIDE")
	end

	MailFrame:SetScript("OnHide", DefaultFrameOnHide)

	private.fsm = TSMAPI_FOUR.FSM.New("MAILING_UI")
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_CLOSED")
			:AddTransition("ST_DEFAULT_OPEN")
			:AddTransition("ST_FRAME_OPEN")
			:AddEvent("EV_FRAME_TOGGLE", function(context)
				assert(not TSM.db.global.internalData.mailingUIFrameContext.showDefault)
				return "ST_FRAME_OPEN"
			end)
			:AddEvent("EV_MAIL_SHOW", function(context)
				if TSM.db.global.internalData.mailingUIFrameContext.showDefault then
					return "ST_DEFAULT_OPEN"
				else
					return "ST_FRAME_OPEN"
				end
			end)
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_DEFAULT_OPEN")
			:SetOnEnter(function(context, isIgnored)
				MailFrame_OnEvent(MailFrame, "MAIL_SHOW")

				if not private.defaultUISwitchBtn then
					private.defaultUISwitchBtn = TSMAPI_FOUR.UI.NewElement("ActionButton", "switchBtn")
						:SetStyle("width", 60)
						:SetStyle("height", WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and 16 or 15)
						:SetStyle("anchors", { { "TOPRIGHT", WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and -26 or -27, WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and -3 or -4 } })
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 12)
						:DisableClickCooldown()
						:SetText(L["TSM4"])
						:SetScript("OnClick", private.SwitchBtnOnClick)
					private.defaultUISwitchBtn:_GetBaseFrame():SetParent(MailFrame)
				end

				if isIgnored then
					private.defaultUISwitchBtn:Hide()
				else
					private.defaultUISwitchBtn:Show()
					private.defaultUISwitchBtn:Draw()
				end
			end)
			:AddTransition("ST_CLOSED")
			:AddTransition("ST_FRAME_OPEN")
			:AddEvent("EV_FRAME_HIDE", function(context)
				OpenMailFrame:Hide()
				CloseMail()

				return "ST_CLOSED"
			end)
			:AddEvent("EV_MAIL_CLOSED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_CLOSED"))
			:AddEvent("EV_SWITCH_BTN_CLICKED", function()
				OpenMailFrame:Hide()
				return "ST_FRAME_OPEN"
			end)
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_FRAME_OPEN")
			:SetOnEnter(function(context)
				OpenAllBags()
				CheckInbox()
				DoEmote("READ", nil, true)
				HideUIPanel(MailFrame)

				assert(not context.frame)
				context.frame = private.CreateMainFrame()
				context.frame:Show()
				context.frame:Draw()
				private.isVisible = true
			end)
			:SetOnExit(function(context)
				if context.frame then
					context.frame:Hide()
					context.frame:Release()
					context.frame = nil
				end
				private.isVisible = false
			end)
			:AddTransition("ST_CLOSED")
			:AddTransition("ST_DEFAULT_OPEN")
			:AddEvent("EV_FRAME_HIDE", function(context)
				CancelEmote()
				CloseAllBags()
				CloseMail()

				return "ST_CLOSED"
			end)
			:AddEvent("EV_MAIL_SHOW", function(context)
				OpenAllBags()
				CheckInbox()

				if not context.frame then
					DoEmote("READ", nil, true)
					context.frame = private.CreateMainFrame()
					context.frame:Draw()
					private.isVisible = true
				end
			end)
			:AddEvent("EV_MAIL_CLOSED", function(context)
				CancelEmote()
				CloseAllBags()

				return "ST_CLOSED"
			end)
			:AddEvent("EV_SWITCH_BTN_CLICKED", function()
				return "ST_DEFAULT_OPEN"
			end)
		)
		:Init("ST_CLOSED", fsmContext)
end
