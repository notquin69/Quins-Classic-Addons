-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local VendoringUI = TSM.UI:NewPackage("VendoringUI")
local L = TSM.L
local private = { topLevelPages = {}, fsm = nil, defaultUISwitchBtn = nil, isVisible = false }
local MIN_FRAME_SIZE = { width = 560, height = 500 }



-- ============================================================================
-- Module Functions
-- ============================================================================

function VendoringUI.OnInitialize()
	private.FSMCreate()
end

function VendoringUI.OnDisable()
	-- hide the frame
	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function VendoringUI.RegisterTopLevelPage(name, textureInfo, callback)
	tinsert(private.topLevelPages, { name = name, textureInfo = textureInfo, callback = callback })
end

function VendoringUI.IsVisible()
	return private.isVisible
end



-- ============================================================================
-- Main Frame
-- ============================================================================

function private.CreateMainFrame()
	TSM.UI.AnalyticsRecordPathChange("vendoring")
	local frame = TSMAPI_FOUR.UI.NewElement("LargeApplicationFrame", "base")
		:SetParent(UIParent)
		:SetMinResize(MIN_FRAME_SIZE.width, MIN_FRAME_SIZE.height)
		:SetContextTable(TSM.db.global.internalData.vendoringUIFrameContext, TSM.db:GetDefaultReadOnly("global", "internalData", "vendoringUIFrameContext"))
		:SetStyle("strata", "HIGH")
		:SetStyle("titleStyle", "TITLE_ONLY")
		:SetTitle(L["TSM Vendoring"])
		:AddSwitchButton(private.SwitchBtnOnClick)
		:SetScript("OnHide", private.BaseFrameOnHide)

	for _, info in ipairs(private.topLevelPages) do
		frame:AddNavButton(info.name, info.textureInfo, info.callback)
	end

	return frame
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.BaseFrameOnHide()
	TSM.UI.AnalyticsRecordClose("vendoring")
	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function private.GetNavFrame(_, path)
	return private.topLevelPages.callback[path]()
end

function private.SwitchBtnOnClick(button)
	TSM.db.global.internalData.vendoringUIFrameContext.showDefault = button ~= private.defaultUISwitchBtn
	private.fsm:ProcessEvent("EV_SWITCH_BTN_CLICKED")
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.FSMCreate()
	local function MerchantShowDelayed()
		private.fsm:ProcessEvent("EV_MERCHANT_SHOW")
	end
	TSMAPI_FOUR.Event.Register("MERCHANT_SHOW", function()
		TSMAPI_FOUR.Delay.AfterFrame("MERCHANT_SHOW_DELAYED", 0, MerchantShowDelayed)
	end)
	TSMAPI_FOUR.Event.Register("MERCHANT_CLOSED", function()
		private.fsm:ProcessEvent("EV_MERCHANT_CLOSED")
	end)
	MerchantFrame:UnregisterEvent("MERCHANT_SHOW")

	local fsmContext = {
		frame = nil,
		defaultPoint = nil,
	}
	local function DefaultFrameOnHide()
		private.fsm:ProcessEvent("EV_FRAME_HIDE")
	end
	private.fsm = TSMAPI_FOUR.FSM.New("MERCHANT_UI")
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_CLOSED")
			:AddTransition("ST_DEFAULT_OPEN")
			:AddTransition("ST_FRAME_OPEN")
			:AddEvent("EV_FRAME_TOGGLE", function(context)
				assert(not TSM.db.global.internalData.vendoringUIFrameContext.showDefault)
				return "ST_FRAME_OPEN"
			end)
			:AddEvent("EV_MERCHANT_SHOW", function(context)
				if TSM.db.global.internalData.vendoringUIFrameContext.showDefault then
					return "ST_DEFAULT_OPEN"
				else
					return "ST_FRAME_OPEN"
				end
			end)
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_DEFAULT_OPEN")
			:SetOnEnter(function(context, isIgnored)
				MerchantFrame_OnEvent(MerchantFrame, "MERCHANT_SHOW")
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
					private.defaultUISwitchBtn:_GetBaseFrame():SetParent(MerchantFrame)
				end
				if isIgnored then
					private.defaultUISwitchBtn:Hide()
				else
					private.defaultUISwitchBtn:Show()
					private.defaultUISwitchBtn:Draw()
				end
				MerchantFrame:SetScript("OnHide", DefaultFrameOnHide)
			end)
			:SetOnExit(function(context)
				MerchantFrame:SetScript("OnHide", nil)
				HideUIPanel(MerchantFrame)
			end)
			:AddTransition("ST_CLOSED")
			:AddTransition("ST_FRAME_OPEN")
			:AddEvent("EV_FRAME_HIDE", function(context)
				CloseMerchant()
				return "ST_CLOSED"
			end)
			:AddEvent("EV_MERCHANT_SHOW", MerchantFrame_Update)
			:AddEvent("EV_MERCHANT_CLOSED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_CLOSED"))
			:AddEvent("EV_SWITCH_BTN_CLICKED", function()
				return "ST_FRAME_OPEN"
			end)
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_FRAME_OPEN")
			:SetOnEnter(function(context)
				assert(not context.frame)
				MerchantFrame_OnEvent(MerchantFrame, "MERCHANT_SHOW")
				if not context.defaultPoint then
					context.defaultPoint = { MerchantFrame:GetPoint(1) }
				end
				MerchantFrame:SetClampedToScreen(false)
				MerchantFrame:ClearAllPoints()
				MerchantFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100000, 100000)
				OpenAllBags()
				context.frame = private.CreateMainFrame()
				context.frame:Show()
				context.frame:GetElement("titleFrame.switchBtn"):Show()
				context.frame:Draw()
				private.isVisible = true
			end)
			:SetOnExit(function(context)
				CloseAllBags()
				MerchantFrame:ClearAllPoints()
				local point, region, relativePoint, x, y = unpack(context.defaultPoint)
				if point and region and relativePoint and x and y then
					MerchantFrame:SetPoint(point, region, relativePoint, x, y)
				else
					MerchantFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 16, -116)
				end
				private.isVisible = false
				context.frame:Hide()
				context.frame:Release()
				context.frame = nil
			end)
			:AddTransition("ST_CLOSED")
			:AddTransition("ST_DEFAULT_OPEN")
			:AddEvent("EV_FRAME_HIDE", function(context)
				CloseMerchant()
				return "ST_CLOSED"
			end)
			:AddEvent("EV_MERCHANT_CLOSED", function(context)
				return "ST_CLOSED"
			end)
			:AddEvent("EV_SWITCH_BTN_CLICKED", function()
				return "ST_DEFAULT_OPEN"
			end)
		)
		:Init("ST_CLOSED", fsmContext)
end
