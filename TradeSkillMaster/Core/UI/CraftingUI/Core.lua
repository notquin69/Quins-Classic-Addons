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
local private = { topLevelPages = {}, fsm = nil, craftOpen = nil, tradeSkillOpen = nil, defaultUISwitchBtn = nil, isVisible = false }
local MIN_FRAME_SIZE = { width = 820, height = 587 }
local BEAST_TRAINING_DE = "Bestienausbildung"
local BEAST_TRAINING_RUS = "Воспитание питомца"



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
		if name == GetSpellInfo(5149) or name == BEAST_TRAINING_DE or name == BEAST_TRAINING_RUS then -- Beast Training
			return true
		elseif name == GetSpellInfo(7620) then -- Fishing
			return true
		elseif name == GetSpellInfo(2366) then -- Herb Gathering
			return true
		elseif name == GetSpellInfo(8613) then -- Skinning
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
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		TSMAPI_FOUR.Event.Register("CRAFT_SHOW", function()
			CloseTradeSkill()
			private.craftOpen = true
			TSM.Crafting.ProfessionState.SetCraftOpen(true)
			private.fsm:ProcessEvent("EV_TRADE_SKILL_SHOW")
		end)
		TSMAPI_FOUR.Event.Register("CRAFT_CLOSE", function()
			private.craftOpen = false
			TSM.Crafting.ProfessionState.SetCraftOpen(false)
			if not private.tradeSkillOpen then
				private.fsm:ProcessEvent("EV_TRADE_SKILL_CLOSED")
			end
		end)
	end
	TSMAPI_FOUR.Event.Register("TRADE_SKILL_SHOW", function()
		if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
			CloseCraft()
		end
		private.tradeSkillOpen = true
		private.fsm:ProcessEvent("EV_TRADE_SKILL_SHOW")
	end)
	TSMAPI_FOUR.Event.Register("TRADE_SKILL_CLOSE", function()
		private.tradeSkillOpen = false
		if not private.craftOpen then
			private.fsm:ProcessEvent("EV_TRADE_SKILL_CLOSED")
		end
	end)
	-- we'll implement UIParent's event handler directly when necessary for TRADE_SKILL_SHOW
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		UIParent:UnregisterEvent("CRAFT_SHOW")
	end
	UIParent:UnregisterEvent("TRADE_SKILL_SHOW")

	local fsmContext = {
		frame = nil,
	}
	local function UpdateDefaultCraftButton()
		if CraftFrame and CraftCreateButton and private.craftOpen then
			CraftCreateButton:SetParent(CraftFrame)
			CraftCreateButton:ClearAllPoints()
			CraftCreateButton:SetPoint("CENTER", CraftFrame, "TOPLEFT", 224, -422)
			CraftCreateButton:SetFrameLevel(2)
			CraftCreateButton:EnableDrawLayer("BACKGROUND")
			CraftCreateButton:EnableDrawLayer("ARTWORK")
			CraftCreateButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
			CraftCreateButton:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		end
	end
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
				if private.craftOpen then
					UIParent_OnEvent(UIParent, "CRAFT_SHOW")
					UpdateDefaultCraftButton()
				else
					UIParent_OnEvent(UIParent, "TRADE_SKILL_SHOW")
				end
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
				end
				private.defaultUISwitchBtn:_GetBaseFrame():SetParent(private.craftOpen and CraftFrame or TradeSkillFrame)
				if isIgnored then
					TSM.Crafting.ProfessionScanner.SetDisabled(true)
					private.defaultUISwitchBtn:Hide()
				else
					private.defaultUISwitchBtn:Show()
					private.defaultUISwitchBtn:Draw()
				end
				if private.craftOpen then
					CraftFrame:SetScript("OnHide", DefaultFrameOnHide)
				else
					TradeSkillFrame:SetScript("OnHide", DefaultFrameOnHide)
				end
				if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
					local linked, linkedName = TSM.Crafting.ProfessionUtil.IsLinkedProfession()
					if TSM.Crafting.ProfessionUtil.IsDataStable() and not TSM.Crafting.ProfessionUtil.IsGuildProfession() and (not linked or (linked and linkedName == UnitName("player"))) then
						TradeSkillFrame:OnEvent("TRADE_SKILL_DATA_SOURCE_CHANGED")
						TradeSkillFrame:OnEvent("TRADE_SKILL_LIST_UPDATE")
					end
				end
			end)
			:SetOnExit(function(context)
				if private.craftOpen then
					if CraftFrame then
						CraftFrame:SetScript("OnHide", nil)
						HideUIPanel(CraftFrame)
					end
				else
					if TradeSkillFrame then
						TradeSkillFrame:SetScript("OnHide", nil)
						HideUIPanel(TradeSkillFrame)
					end
				end
			end)
			:AddTransition("ST_CLOSED")
			:AddTransition("ST_FRAME_OPEN")
			:AddTransition("ST_DEFAULT_OPEN")
			:AddEvent("EV_FRAME_HIDE", function(context)
				TSM.Crafting.ProfessionUtil.CloseTradeSkill(false, private.craftOpen)
				return "ST_CLOSED"
			end)
			:AddEvent("EV_TRADE_SKILL_SHOW", function(context)
				if CraftingUI.IsProfessionIgnored(TSM.Crafting.ProfessionUtil.GetCurrentProfessionName()) then
					return "ST_DEFAULT_OPEN", true
				else
					if TSM.db.global.internalData.craftingUIFrameContext.showDefault then
						return "ST_DEFAULT_OPEN"
					else
						TSM.Crafting.ProfessionScanner.SetDisabled(TSM.db.global.internalData.craftingUIFrameContext.showDefault)
						return "ST_FRAME_OPEN"
					end
				end
			end)
			:AddEvent("EV_TRADE_SKILL_CLOSED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_CLOSED"))
			:AddEvent("EV_SWITCH_BTN_CLICKED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_FRAME_OPEN"))
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
				private.isVisible = true
			end)
			:SetOnExit(function(context)
				context.frame:Hide()
				context.frame:Release()
				context.frame = nil
				private.isVisible = false
				if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
					UpdateDefaultCraftButton()
				end
			end)
			:AddTransition("ST_CLOSED")
			:AddTransition("ST_DEFAULT_OPEN")
			:AddEvent("EV_FRAME_HIDE", function(context)
				TSM.Crafting.ProfessionUtil.CloseTradeSkill(true)
				return "ST_CLOSED"
			end)
			:AddEvent("EV_TRADE_SKILL_SHOW", function(context)
				if CraftingUI.IsProfessionIgnored(TSM.Crafting.ProfessionUtil.GetCurrentProfessionName()) then
					return "ST_DEFAULT_OPEN", true
				end
				context.frame:GetElement("titleFrame.switchBtn"):Show()
				context.frame:GetElement("titleFrame"):Draw()
			end)
			:AddEvent("EV_TRADE_SKILL_CLOSED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_CLOSED"))
			:AddEvent("EV_SWITCH_BTN_CLICKED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_DEFAULT_OPEN"))
			:AddEvent("EV_FRAME_TOGGLE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_CLOSED"))
		)
		:Init("ST_CLOSED", fsmContext)
end
