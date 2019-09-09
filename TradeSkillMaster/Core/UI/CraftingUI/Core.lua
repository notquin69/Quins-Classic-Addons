-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local CraftingUI = TSM.UI:NewPackage("CraftingUI")
local L = TSM.L
local private = { topLevelPages = {}, fsm = nil, defaultUISwitchBtn = nil, isVisible = false }
local MIN_FRAME_SIZE = { width = 820, height = 587 }



-- ============================================================================
-- Module Functions
-- ============================================================================

function CraftingUI.OnInitialize()
	private.FSMCreate()
	TSM.Crafting.ProfessionScanner.SetDisabled(TSM.db.global.internalData.craftingUIFrameContext.showDefault)
end

function CraftingUI.OnDisable()
	-- hide the frame
	if private.isVisible then
		TSM.Crafting.ProfessionScanner.SetDisabled(false)
		private.fsm:ProcessEvent("EV_FRAME_TOGGLE")
	end
end

function CraftingUI.RegisterTopLevelPage(name, textureInfo, callback)
	tinsert(private.topLevelPages, { name = name, textureInfo = textureInfo, callback = callback })
end

function CraftingUI.Toggle()
	TSM.db.global.internalData.craftingUIFrameContext.showDefault = false
	TSM.Crafting.ProfessionScanner.SetDisabled(false)
	private.fsm:ProcessEvent("EV_FRAME_TOGGLE")
end

function CraftingUI.IsProfessionIgnored(name)
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		if name == GetSpellInfo(7620) then
			return true
		elseif name == GetSpellInfo(2575) then
			return true
		elseif name == GetSpellInfo(2366) then
			return true
		elseif name == GetSpellInfo(8613) then
			return true
		end
	end
	for i in pairs(TSM.CONST.IGNORED_PROFESSIONS) do
		local ignoredName = GetSpellInfo(i)
		if ignoredName == name then
			return true
		end
	end
end

function CraftingUI.IsVisible()
	return private.isVisible
end



-- ============================================================================
-- Main Frame
-- ============================================================================

function private.CreateMainFrame()
	TSM.UI.AnalyticsRecordPathChange("crafting")
	local frame = TSMAPI_FOUR.UI.NewElement("LargeApplicationFrame", "base")
		:SetParent(UIParent)
		:SetMinResize(MIN_FRAME_SIZE.width, MIN_FRAME_SIZE.height)
		:SetContextTable(TSM.db.global.internalData.craftingUIFrameContext, TSM.db:GetDefaultReadOnly("global", "internalData", "craftingUIFrameContext"))
		:SetStyle("smallNavArea", true)
		:SetStyle("strata", "HIGH")
		:SetTitle(L["TSM Crafting"])
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
	TSM.UI.AnalyticsRecordClose("crafting")
	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function private.GetNavFrame(_, path)
	return private.topLevelPages.callback[path]()
end

function private.SwitchBtnOnClick(button)
	TSM.db.global.internalData.craftingUIFrameContext.showDefault = button ~= private.defaultUISwitchBtn
	TSM.Crafting.ProfessionScanner.SetDisabled(TSM.db.global.internalData.craftingUIFrameContext.showDefault)
	private.fsm:ProcessEvent("EV_SWITCH_BTN_CLICKED")
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.FSMCreate()
	TSMAPI_FOUR.Event.Register("TRADE_SKILL_SHOW", function()
		private.fsm:ProcessEvent("EV_TRADE_SKILL_SHOW")
	end)
	TSMAPI_FOUR.Event.Register("TRADE_SKILL_CLOSE", function()
		private.fsm:ProcessEvent("EV_TRADE_SKILL_CLOSED")
	end)
	-- we'll implement UIParent's event handler directly when necessary for TRADE_SKILL_SHOW
	UIParent:UnregisterEvent("TRADE_SKILL_SHOW")

	local fsmContext = {
		frame = nil,
		openedTime = 0,
	}
	local function DefaultFrameOnHide()
		private.fsm:ProcessEvent("EV_FRAME_HIDE")
	end
	private.fsm = TSMAPI_FOUR.FSM.New("CRAFTING_UI")
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_CLOSED")
			:AddTransition("ST_DEFAULT_OPEN")
			:AddTransition("ST_FRAME_OPEN")
			:AddEvent("EV_FRAME_TOGGLE", function(context)
				assert(not TSM.db.global.internalData.craftingUIFrameContext.showDefault)
				TSM.Crafting.ProfessionScanner.SetDisabled(false)
				return "ST_FRAME_OPEN"
			end)
			:AddEvent("EV_TRADE_SKILL_SHOW", function(context)
				TSM.Crafting.ProfessionScanner.SetDisabled(TSM.db.global.internalData.craftingUIFrameContext.showDefault)
				local name = TSM.Crafting.ProfessionUtil.GetCurrentProfessionName()
				if CraftingUI.IsProfessionIgnored(name) then
					return "ST_DEFAULT_OPEN", true
				elseif TSM.db.global.internalData.craftingUIFrameContext.showDefault then
					return "ST_DEFAULT_OPEN"
				else
					return "ST_FRAME_OPEN"
				end
			end)
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_DEFAULT_OPEN")
			:SetOnEnter(function(context, isIgnored)
				UIParent_OnEvent(UIParent, "TRADE_SKILL_SHOW")
				if not private.defaultUISwitchBtn then
					private.defaultUISwitchBtn = TSMAPI_FOUR.UI.NewElement("ActionButton", "switchBtn")
						:SetStyle("width", 60)
						:SetStyle("height", WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and 16 or 15)
						:SetStyle("anchors", { { "TOPRIGHT", WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and -60 or -27, WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and -16 or -4 } })
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 12)
						:SetStyle("relativeLevel", 3)
						:DisableClickCooldown()
						:SetText(L["TSM4"])
						:SetScript("OnClick", private.SwitchBtnOnClick)
					private.defaultUISwitchBtn:_GetBaseFrame():SetParent(TradeSkillFrame)
				end
				if isIgnored then
					TSM.Crafting.ProfessionScanner.SetDisabled(true)
					private.defaultUISwitchBtn:Hide()
				else
					private.defaultUISwitchBtn:Show()
					private.defaultUISwitchBtn:Draw()
				end
				TradeSkillFrame:SetScript("OnHide", DefaultFrameOnHide)
				if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
					local linked, linkedName = TSM.Crafting.ProfessionUtil.IsLinkedProfession()
					if TSM.Crafting.ProfessionUtil.IsDataStable() and not TSM.Crafting.ProfessionUtil.IsGuildProfession() and (not linked or (linked and linkedName == UnitName("player"))) then
						TradeSkillFrame:OnEvent("TRADE_SKILL_DATA_SOURCE_CHANGED")
						TradeSkillFrame:OnEvent("TRADE_SKILL_LIST_UPDATE")
					end
				end
			end)
			:SetOnExit(function(context)
				TradeSkillFrame:SetScript("OnHide", nil)
				HideUIPanel(TradeSkillFrame)
			end)
			:AddTransition("ST_CLOSED")
			:AddTransition("ST_FRAME_OPEN")
			:AddEvent("EV_FRAME_HIDE", function(context)
				TSM.Crafting.ProfessionUtil.CloseTradeSkill()
				return "ST_CLOSED"
			end)
			:AddEvent("EV_TRADE_SKILL_CLOSED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_CLOSED"))
			:AddEvent("EV_SWITCH_BTN_CLICKED", function()
				return "ST_FRAME_OPEN"
			end)
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_FRAME_OPEN")
			:SetOnEnter(function(context)
				assert(not context.frame)
				context.frame = private.CreateMainFrame()
				context.frame:Show()
				if TSM.Crafting.ProfessionUtil.GetCurrentProfessionName() then
					context.frame:GetElement("titleFrame.switchBtn"):Show()
				else
					context.frame:GetElement("titleFrame.switchBtn"):Hide()
				end
				context.frame:Draw()
				context.openedTime = GetTime()
				private.isVisible = true
			end)
			:SetOnExit(function(context)
				context.frame:Hide()
				context.frame:Release()
				context.frame = nil
				private.isVisible = false
			end)
			:AddTransition("ST_CLOSED")
			:AddTransition("ST_DEFAULT_OPEN")
			:AddEvent("EV_FRAME_HIDE", function(context)
				TSM.Crafting.ProfessionUtil.CloseTradeSkill()
				return "ST_CLOSED"
			end)
			:AddEvent("EV_TRADE_SKILL_SHOW", function(context)
				context.frame:GetElement("titleFrame.switchBtn"):Show()
				context.frame:GetElement("titleFrame"):Draw()
			end)
			:AddEvent("EV_TRADE_SKILL_CLOSED", function(context)
				context.frame:GetElement("titleFrame.switchBtn"):Hide()
				context.frame:GetElement("titleFrame"):Draw()
				if context.openedTime > GetTime() - 2 then
					return "ST_CLOSED"
				end
			end)
			:AddEvent("EV_SWITCH_BTN_CLICKED", function()
				return "ST_DEFAULT_OPEN"
			end)
			:AddEvent("EV_FRAME_TOGGLE", function(context)
				return "ST_CLOSED"
			end)
		)
		:Init("ST_CLOSED", fsmContext)
end
