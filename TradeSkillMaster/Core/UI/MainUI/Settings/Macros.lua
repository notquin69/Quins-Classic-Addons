-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Macros = TSM.MainUI.Settings:NewPackage("Macros")
local L = TSM.L
local private = {}
local MACRO_NAME = "TSMMacro"
local MACRO_ICON = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and "INV_Misc_Flower_01" or "Achievement_Faction_GoldenLotus"
local BINDING_NAME = "MACRO "..MACRO_NAME
local BUTTON_MAPPING = {
	["row1.myauctionsCheckbox"] = "TSMCancelAuctionBtn",
	["row1.auctioningCheckbox"] = "TSMAuctioningBtn",
	["row2.shoppingCheckbox"] = "TSMShoppingBuyoutBtn",
	["row2.sniperCheckbox"] = "TSMSniperBtn",
	["row3.craftingCheckbox"] = "TSMCraftingBtn",
	["row3.destroyingCheckbox"] = "TSMDestroyBtn",
	["row4.vendoringCheckbox"] = "TSMVendoringSellAllButton",
}
local CHARACTER_BINDING_SET = 2
local MAX_MACRO_LENGTH = 255



-- ============================================================================
-- Module Functions
-- ============================================================================

function Macros.OnInitialize()
	TSM.MainUI.Settings.RegisterSettingPage("Macros", "middle", private.GetMacrosSettingsFrame)
end



-- ============================================================================
-- Macros Settings UI
-- ============================================================================

function private.GetMacrosSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "macros")
	local body = GetMacroBody(MACRO_NAME) or ""
	local upEnabled, downEnabled, altEnabled, ctrlEnabled, shiftEnabled = false, false, false, false, false
	for _, binding in TSMAPI_FOUR.Util.VarargIterator(GetBindingKey(BINDING_NAME)) do
		upEnabled = upEnabled or (strfind(binding, "MOUSEWHEELUP") and true)
		downEnabled = upEnabled or (strfind(binding, "MOUSEWHEELDOWN") and true)
		altEnabled = altEnabled or (strfind(binding, "ALT-") and true)
		ctrlEnabled = ctrlEnabled or (strfind(binding, "CTRL-") and true)
		shiftEnabled = shiftEnabled or (strfind(binding, "SHIFT-") and true)
	end

	local frame = TSMAPI_FOUR.UI.NewElement("ScrollFrame", "macroSettings")
		:SetStyle("padding.left", 12)
		:SetStyle("padding.right", 12)
		:AddChild(TSM.MainUI.Settings.CreateHeading("title", L["Macro Setup"]))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc")
			:SetStyle("height", 36)
			:SetStyle("margin.bottom", 24)
			:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Many commonly-used actions in TSM can be added to a macro and bound to your scroll wheel. Use the options below to setup this macro and scroll wheel binding."])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "actionsSubHeading")
			:SetStyle("height", 19)
			:SetStyle("margin.bottom", 8)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 16)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Bound Actions"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "row1")
			:SetStyle("height", 28)
			:SetLayout("HORIZONTAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "myauctionsCheckbox")
				:SetStyle("width", 240)
				:SetStyle("fontHeight", 12)
				:SetText(L["My Auctions 'CANCEL' Button"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "auctioningCheckbox")
				:SetStyle("fontHeight", 12)
				:SetText(L["Auctioning 'POST'/'CANCEL' Button"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "row2")
			:SetStyle("height", 28)
			:SetLayout("HORIZONTAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "shoppingCheckbox")
				:SetStyle("width", 240)
				:SetStyle("fontHeight", 12)
				:SetText(L["Shopping 'BUYOUT' Button"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "sniperCheckbox")
				:SetStyle("fontHeight", 12)
				:SetText(L["Sniper 'BUYOUT' Button"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "row3")
			:SetStyle("height", 28)
			:SetLayout("HORIZONTAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "craftingCheckbox")
				:SetStyle("width", 240)
				:SetStyle("fontHeight", 12)
				:SetText(L["Crafting 'CRAFT NEXT' Button"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "destroyingCheckbox")
				:SetStyle("fontHeight", 12)
				:SetText(L["Destroying 'DESTROY NEXT' Button"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "row4")
			:SetStyle("height", 28)
			:SetLayout("HORIZONTAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "vendoringCheckbox")
				:SetStyle("width", 240)
				:SetStyle("fontHeight", 12)
				:SetText(L["Vendoring 'SELL ALL' Button"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "scrollWheelSubHeading")
			:SetStyle("height", 19)
			:SetStyle("margin.top", 16)
			:SetStyle("margin.bottom", 8)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 16)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Configuration Scroll Wheel"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "direction")
			:SetStyle("height", 28)
			:SetLayout("HORIZONTAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
				:SetStyle("width", 240)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Scroll wheel direction:"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "upCheckbox")
				:SetStyle("width", 80)
				:SetText(L["Up"])
				:SetChecked(upEnabled)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "downCheckbox")
				:SetText(L["DOWN"])
				:SetChecked(downEnabled)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "modifiers")
			:SetStyle("height", 28)
			:SetLayout("HORIZONTAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
				:SetStyle("width", 240)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Modifiers:"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "altCheckbox")
				:SetStyle("width", 80)
				:SetText(ALT_KEY)
				:SetChecked(altEnabled)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "ctrlCheckbox")
				:SetStyle("width", 80)
				:SetText(CTRL_KEY)
				:SetChecked(ctrlEnabled)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "shiftCheckbox")
				:SetText(SHIFT_KEY)
				:SetChecked(shiftEnabled)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "createBtn")
			:SetStyle("margin.top", 24)
			:SetStyle("height", 26)
			:SetText(GetMacroInfo(MACRO_NAME) and L["UPDATE EXISTING MACRO"] or L["CREATE MACRO"])
			:SetScript("OnClick", private.CreateButtonOnClick)
		)

	for path, buttonName in pairs(BUTTON_MAPPING) do
		frame:GetElement(path):SetChecked(strfind(body, buttonName) and true or false)
	end
	return frame
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.CreateButtonOnClick(button)
	-- remove the old bindings and macros
	for _, binding in TSMAPI_FOUR.Util.VarargIterator(GetBindingKey(BINDING_NAME)) do
		SetBinding(binding)
	end
	DeleteMacro(MACRO_NAME)

	if GetNumMacros() >= MAX_ACCOUNT_MACROS then
		TSM:Print(L["Could not create macro as you already have too many. Delete one of your existing macros and try again."])
		return
	end

	-- create the new macro
	local scrollFrame = button:GetParentElement()
	local lines = TSMAPI_FOUR.Util.AcquireTempTable()
	for elementPath, buttonName in pairs(BUTTON_MAPPING) do
		if scrollFrame:GetElement(elementPath):IsChecked() then
			tinsert(lines, "/click "..buttonName)
		end
	end
	local macroText = table.concat(lines, "\n")
	CreateMacro(MACRO_NAME, MACRO_ICON, macroText)
	TSMAPI_FOUR.Util.ReleaseTempTable(lines)

	-- create the binding
	local modifierStr = ""
	if scrollFrame:GetElement("modifiers.ctrlCheckbox"):IsChecked() then
		modifierStr = modifierStr.."CTRL-"
	end
	if scrollFrame:GetElement("modifiers.altCheckbox"):IsChecked() then
		modifierStr = modifierStr.."ALT-"
	end
	if scrollFrame:GetElement("modifiers.shiftCheckbox"):IsChecked() then
		modifierStr = modifierStr.."SHIFT-"
	end
	-- we want to save these bindings to be per-character, so the mode should be 1 / 2 if we're currently on
	-- per-character bindings or not respectively
	local bindingMode = (GetCurrentBindingSet() == CHARACTER_BINDING_SET) and 1 or 2
	if scrollFrame:GetElement("direction.upCheckbox") then
		SetBinding(modifierStr.."MOUSEWHEELUP", nil, bindingMode)
		SetBinding(modifierStr.."MOUSEWHEELUP", BINDING_NAME, bindingMode)
	end
	if scrollFrame:GetElement("direction.downCheckbox") then
		SetBinding(modifierStr.."MOUSEWHEELDOWN", nil, bindingMode)
		SetBinding(modifierStr.."MOUSEWHEELDOWN", BINDING_NAME, bindingMode)
	end

	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		AttemptToSaveBindings(CHARACTER_BINDING_SET)
	else
		SaveBindings(CHARACTER_BINDING_SET)
	end

	TSM:Print(L["Macro created and scroll wheel bound!"])
	if #macroText > MAX_MACRO_LENGTH then
		TSM:Print(L["WARNING: The macro was too long, so was truncated to fit by WoW."])
	end
end
