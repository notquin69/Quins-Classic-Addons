-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Warehousing = TSM.MainUI.Operations:NewPackage("Warehousing")
local L = TSM.L
local private = { currentOperationName = nil }



-- ============================================================================
-- Module Functions
-- ============================================================================

function Warehousing.OnInitialize()
	TSM.MainUI.Operations.RegisterModule("Warehousing", private.GetWarehousingOperationSettings)
end



-- ============================================================================
-- Warehousing Operation Settings UI
-- ============================================================================

function private.GetWarehousingOperationSettings(operationName)
	TSM.UI.AnalyticsRecordPathChange("main", "operations", "warehousing")
	private.currentOperationName = operationName
	return TSMAPI_FOUR.UI.NewElement("Frame", "content")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
			:SetStyle("color", "#9d9d9d")
			:SetStyle("height", 2)
			:SetStyle("margin.top", 24)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("ScrollFrame", "settings")
			:SetStyle("background", "#1e1e1e")
			:SetStyle("padding.left", 16)
			:SetStyle("padding.right", 16)
			:SetStyle("padding.top", -8)
			:AddChild(TSM.MainUI.Operations.CreateHeadingLine("buyOptionsHeading", L["Move Quantity Settings"]))
			:AddChild(private.CreateEnabledSettingLine("moveQuantity", L["Set move quantity?"], L["Quantity to move:"], 5000))
			:AddChild(private.CreateEnabledSettingLine("stackSize", L["Set stack size?"], L["Stack size multiple:"], 200))
			:AddChild(private.CreateEnabledSettingLine("keepBagQuantity", L["Set keep in bags quantity?"], L["Keep in bags quantity:"], 5000))
			:AddChild(private.CreateEnabledSettingLine("keepBankQuantity", L["Set keep in bank quantity?"], L["Keep in bank quantity:"], 5000))
			:AddChild(TSM.MainUI.Operations.CreateHeadingLine("restockSettings", L["Restock Settings"]))
			:AddChild(private.CreateEnabledSettingLine("restockQuantity", L["Enable restock?"], L["Restock quantity:"], 5000))
			:AddChild(private.CreateEnabledSettingLine("restockStackSize", L["Set stack size for restock?"], L["Stack size multiple:"], 200))
			:AddChild(private.CreateEnabledSettingLine("restockKeepBankQuantity", L["Set keep in bank quantity?"], L["Keep in bank quantity:"], 5000))
			:AddChild(TSM.MainUI.Operations.GetOperationManagementElements("Warehousing", private.currentOperationName))
		)
end

function private.CreateEnabledSettingLine(key, enableText, text, maxValue)
	local operation = TSM.Operations.GetSettings("Warehousing", private.currentOperationName)
	return TSMAPI_FOUR.UI.NewElement("Frame", key.."OuterFrame")
		:SetLayout("VERTICAL")
		:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine(key, text)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "frame")
				:SetLayout("HORIZONTAL")
				-- move the right by the width of the toggle so this frame gets half the total width
				:SetStyle("margin.right", -TSM.UI.TexturePacks.GetWidth("uiFrames.ToggleOn"))
				:AddChild(TSMAPI_FOUR.UI.NewElement("ToggleOnOff", "toggle")
					:SetValue(operation[key] ~= 0)
					:SetDisabled(TSM.Operations.HasRelationship("Warehousing", private.currentOperationName, key))
					:SetContext(key)
					:SetScript("OnValueChanged", private.EnabledSettingEnableOnValueChanged)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
			)
		)
		:AddChild(TSM.MainUI.Operations.CreateSettingLine("inputFrame", text, operation[key] == 0)
			:SetStyle("margin.left", 25)
			:SetStyle("margin.right", -85)
			:SetStyle("margin.bottom", 16)
			:AddChild(TSMAPI_FOUR.UI.NewElement("InputNumeric", "input")
				:SetStyle("width", 96)
				:SetStyle("height", 24)
				:SetStyle("margin.right", 16)
				:SetStyle("justifyH", "CENTER")
				:SetStyle("font", TSM.UI.Fonts.MontserratBold)
				:SetStyle("fontHeight", 16)
				:SetDisabled(TSM.Operations.HasRelationship("Warehousing", private.currentOperationName, key) or operation[key] == 0)
				:SetSettingInfo(operation, key)
				:SetMaxNumber(maxValue)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "maxLabel")
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", (TSM.Operations.HasRelationship("Warehousing", private.currentOperationName, key) or operation[key] == 0) and "#424242" or "#e2e2e2")
				:SetText(format(L["(max %d)"], maxValue))
			)
		)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.EnabledSettingEnableOnValueChanged(toggle, value)
	local key = toggle:GetContext()
	local operation = TSM.Operations.GetSettings("Warehousing", private.currentOperationName)
	operation[key] = value and 1 or 0
	local settingFrame = toggle:GetElement("__parent.__parent.__parent.inputFrame")
	settingFrame:GetElement("label"):SetStyle("textColor", value and "#e2e2e2" or "#424242")
	settingFrame:GetElement("maxLabel"):SetStyle("textColor", value and "#e2e2e2" or "#424242")
	settingFrame:GetElement("input")
		:SetDisabled(not value)
		:SetText(operation[key])
	settingFrame:Draw()
end
