-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Mailing = TSM.MainUI.Operations:NewPackage("Mailing")
local L = TSM.L
local private = { currentOperationName = nil }
local RESTOCK_SOURCES = { bank = BANK, guild = GUILD }
local RESTOCK_SOURCES_ORDER = { "bank", "guild" }


-- ============================================================================
-- Module Functions
-- ============================================================================

function Mailing.OnInitialize()
	TSM.MainUI.Operations.RegisterModule("Mailing", private.GetMailingOperationSettings)
end



-- ============================================================================
-- Mailing Operation Settings UI
-- ============================================================================

function private.GetMailingOperationSettings(operationName)
	TSM.UI.AnalyticsRecordPathChange("main", "operations", "mailing")
	private.currentOperationName = operationName
	local operation = TSM.Operations.GetSettings("Mailing", private.currentOperationName)

	return TSMAPI_FOUR.UI.NewElement("Frame", "content")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
			:SetStyle("color", "#9d9d9d")
			:SetStyle("height", 2)
			:SetStyle("margin.top", 24)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("ScrollFrame", "content")
			:SetStyle("background", "#1e1e1e")
			:SetStyle("padding.left", 16)
			:SetStyle("padding.right", 16)
			:SetStyle("padding.bottom", -8)
			:AddChild(TSM.MainUI.Operations.CreateHeadingLine("generalOptions", L["General Options"]))
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("target", L["Target Character"]))
			:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "targetInput")
				:SetStyle("height", 26)
				:SetStyle("background", "#5c5c5c")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 16)
				:SetStyle("justifyH", "LEFT")
				:SetStyle("textColor", "#ffffff")
				:SetStyle("margin.top", -10)
				:SetStyle("margin.bottom", 20)
				:SetDisabled(TSM.Operations.HasRelationship("Mailing", private.currentOperationName, "target"))
				:SetText(operation.target)
				:SetSettingInfo(operation, "target")
			)
			:AddChild(private.CreateNumericInputLine("keepQty", L["Keep this amount:"], 5000))
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("maxQtyEnabled", L["Set maximum quantity?"])
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "maxQtyEnabledFrame")
					:SetLayout("HORIZONTAL")
					-- move the right by the width of the toggle so this frame gets half the total width
					:SetStyle("margin.right", -TSM.UI.TexturePacks.GetWidth("uiFrames.ToggleOn"))
					:AddChild(TSMAPI_FOUR.UI.NewElement("ToggleOnOff", "toggle")
						:SetValue(operation.maxQtyEnabled)
						:SetDisabled(TSM.Operations.HasRelationship("Mailing", private.currentOperationName, "maxQtyEnabled"))
						:SetSettingInfo(operation, "maxQtyEnabled")
						:SetScript("OnValueChanged", private.MaxQuantityToggleOnValueChanged)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
				)
			)
			:AddChild(private.CreateNumericInputLine("maxQty", L["Maximum quantity:"], 5000, not operation.maxQtyEnabled))
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("restock", L["Restock target to max quantity?"], not operation.maxQtyEnabled)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "restockEnabledFrame")
					:SetLayout("HORIZONTAL")
					-- move the right by the width of the toggle so this frame gets half the total width
					:SetStyle("margin.right", -TSM.UI.TexturePacks.GetWidth("uiFrames.ToggleOn"))
					:AddChild(TSMAPI_FOUR.UI.NewElement("ToggleOnOff", "toggle")
						:SetValue(operation.restock)
						:SetDisabled(TSM.Operations.HasRelationship("Mailing", private.currentOperationName, "restock") or not operation.maxQtyEnabled)
						:SetSettingInfo(operation, "restock")
						:SetScript("OnValueChanged", private.RestockToggleOnValueChanged)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
				)
			)
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("restockSources", L["Sources to include for restock:"], not operation.maxQtyEnabled)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "restockSourcesDropdown")
					:SetMultiselect(true)
					:SetDictionaryItems(RESTOCK_SOURCES, operation.restockSources, RESTOCK_SOURCES_ORDER)
					:SetSettingInfo(operation, "restockSources")
					:SetDisabled(TSM.Operations.HasRelationship("Mailing", private.currentOperationName, "restockSources") or not operation.restock or not operation.maxQtyEnabled)
				)
			)
			:AddChild(TSM.MainUI.Operations.GetOperationManagementElements("Mailing", private.currentOperationName))
		)
end

function private.CreateNumericInputLine(key, label, maxValue, disabled)
	local operation = TSM.Operations.GetSettings("Mailing", private.currentOperationName)
	local hasRelationship = TSM.Operations.HasRelationship("Mailing", private.currentOperationName, key)
	return TSM.MainUI.Operations.CreateLinkedSettingLine(key, label, disabled)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", key.."Frame")
			:SetLayout("HORIZONTAL")
			-- move the right by the width of the input box so this frame gets half the total width
			:SetStyle("margin.right", -112)
			:AddChild(TSMAPI_FOUR.UI.NewElement("InputNumeric", "input")
				:SetStyle("backgroundTexturePacks", (hasRelationship or disabled) and "uiFrames.InactiveInputField" or "uiFrames.ActiveInputField")
				:SetStyle("width", 96)
				:SetStyle("height", 24)
				:SetStyle("margin.right", 16)
				:SetStyle("justifyH", "CENTER")
				:SetStyle("font", TSM.UI.Fonts.MontserratBold)
				:SetStyle("fontHeight", 16)
				:SetDisabled(hasRelationship or disabled)
				:SetSettingInfo(operation, key)
				:SetMaxNumber(maxValue)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "maxLabel")
				:SetStyle("fontHeight", 12)
				:SetText(format(L["(max %d)"], maxValue))
				:SetStyle("textColor", (hasRelationship or disabled) and "#424242" or "#e2e2e2")
			)
		)
end

function private.MaxQuantityToggleOnValueChanged(toggle, value)
	local settingsFrame = toggle:GetParentElement():GetParentElement():GetParentElement()
	settingsFrame:GetElement("maxQty.left.linkBtn")
		:SetStyle("backgroundVertexColor", value and "#ffffff" or "#424242")
		:SetDisabled(not value)
	settingsFrame:GetElement("maxQty.left.label")
		:SetStyle("textColor", value and "#e2e2e2" or "#424242")
	settingsFrame:GetElement("maxQty.maxQtyFrame.maxLabel")
		:SetStyle("textColor", value and "#e2e2e2" or "#424242")
	settingsFrame:GetElement("maxQty.maxQtyFrame.input")
		:SetDisabled(not value)
		:SetStyle("backgroundTexturePacks", not value and "uiFrames.InactiveInputField" or "uiFrames.ActiveInputField")
	settingsFrame:GetElement("restock.left.linkBtn")
		:SetStyle("backgroundVertexColor", value and "#ffffff" or "#424242")
		:SetDisabled(not value)
	settingsFrame:GetElement("restock.left.label")
		:SetStyle("textColor", value and "#e2e2e2" or "#424242")
	settingsFrame:GetElement("restock.restockEnabledFrame.toggle")
		:SetDisabled(not value)
	settingsFrame:GetElement("restockSources.left.linkBtn")
		:SetStyle("backgroundVertexColor", value and "#ffffff" or "#424242")
		:SetDisabled(not value)
	settingsFrame:GetElement("restockSources.left.label")
		:SetStyle("textColor", value and "#e2e2e2" or "#424242")
	settingsFrame:GetElement("restockSources.restockSourcesDropdown")
		:SetDisabled(not value)
	settingsFrame:Draw()
end

function private.RestockToggleOnValueChanged(toggle, value)
	local settingsFrame = toggle:GetParentElement():GetParentElement():GetParentElement()
	settingsFrame:GetElement("restockSources.left.linkBtn")
		:SetStyle("backgroundVertexColor", value and "#ffffff" or "#424242")
		:SetDisabled(not value)
	settingsFrame:GetElement("restockSources.left.label")
		:SetStyle("textColor", value and "#e2e2e2" or "#424242")
	settingsFrame:GetElement("restockSources.restockSourcesDropdown")
		:SetDisabled(not value)
	settingsFrame:Draw()
end
