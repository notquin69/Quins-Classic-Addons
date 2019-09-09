-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Crafting = TSM.MainUI.Operations:NewPackage("Crafting")
local L = TSM.L
local private = { currentOperationName = nil }



-- ============================================================================
-- Module Functions
-- ============================================================================

function Crafting.OnInitialize()
	TSM.MainUI.Operations.RegisterModule("Crafting", private.GetCraftingOperationSettings)
end



-- ============================================================================
-- Crafting Operation Settings UI
-- ============================================================================

function private.GetCraftingOperationSettings(operationName)
	TSM.UI.AnalyticsRecordPathChange("main", "operations", "crafting")
	private.currentOperationName = operationName
	local operation = TSM.Operations.GetSettings("Crafting", private.currentOperationName)
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
			:AddChild(TSM.MainUI.Operations.CreateHeadingLine("restockQuantity", L["Restock Quantity Settings"]))
			:AddChild(private.CreateNumericInputLine("minRestock", L["Minimum restock quantity:"], 1, 2000))
			:AddChild(private.CreateNumericInputLine("maxRestock", L["Maximum restock quantity:"], 1, 2000))
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("minProfit", L["Set minimum profit?"])
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "minProfitEnabledFrame")
					:SetLayout("HORIZONTAL")
					-- move the right by the width of the toggle so this frame gets half the total width
					:SetStyle("margin.right", -TSM.UI.TexturePacks.GetWidth("uiFrames.ToggleOn"))
					:AddChild(TSMAPI_FOUR.UI.NewElement("ToggleOnOff", "toggle")
						:SetValue(operation.minProfit ~= "")
						:SetDisabled(TSM.Operations.HasRelationship("Crafting", private.currentOperationName, "minProfit"))
						:SetScript("OnValueChanged", private.MinProfitToggleOnValueChanged)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "minProfitInputFrame")
				:SetLayout("VERTICAL")
				:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("minProfit", L["Minimum profit:"], operation.minProfit == "")
					:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
						:SetStyle("background", "#5c5c5c")
						:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
						:SetStyle("fontHeight", 16)
						:SetStyle("justifyH", "LEFT")
						:SetStyle("textColor", "#ffffff")
						:SetDisabled(TSM.Operations.HasRelationship("Crafting", private.currentOperationName, "minProfit") or operation.minProfit == "")
						:SetSettingInfo(operation, "minProfit", TSM.MainUI.Operations.CheckCustomPrice)
						:SetText(TSM.Money.ToString(TSM.Money.FromString(operation.minProfit)) or TSM.Money.ToString(operation.minProfit) or operation.minProfit)
						:SetScript("OnEnterPressed", private.MinProfitOnChanged)
						:SetScript("OnTabPressed", private.MinProfitOnChanged)
					)
				)
			)
			:AddChild(TSM.MainUI.Operations.CreateHeadingLine("priceSettings", L["Price Settings"]))
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("craftPriceMethod", L["Override default craft value method?"])
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "craftPriceOverrideFrame")
					:SetLayout("HORIZONTAL")
					-- move the right by the width of the toggle so this frame gets half the total width
					:SetStyle("margin.right", -TSM.UI.TexturePacks.GetWidth("uiFrames.ToggleOn"))
					:AddChild(TSMAPI_FOUR.UI.NewElement("ToggleOnOff", "toggle")
						:SetValue(operation.craftPriceMethod ~= "")
						:SetDisabled(TSM.Operations.HasRelationship("Crafting", private.currentOperationName, "craftPriceMethod"))
						:SetScript("OnValueChanged", private.CraftPriceToggleOnValueChanged)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "craftPriceLabel")
				:SetStyle("height", 26)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", (TSM.Operations.HasRelationship("Crafting", private.currentOperationName, "craftPriceMethod") or operation.craftPriceMethod == "") and "#424242" or "#e2e2e2")
				:SetText(L["Craft value method:"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("BorderedFrame", "craftPrice")
				:SetLayout("HORIZONTAL")
				:SetStyle("borderTheme", "roundLight")
				:AddChild(TSMAPI_FOUR.UI.NewElement("ScrollFrame", "scroll")
					:SetStyle("height", 99)
					:SetStyle("margin.bottom", 2)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
						:SetStyle("height", 97)
						:SetStyle("margin", { left = 2, right = 8 })
						:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
						:SetStyle("textColor", operation.craftPriceMethod == "" and "#757575" or "#ffffff")
						:SetStyle("fontHeight", 14)
						:SetStyle("justifyH", "LEFT")
						:SetDisabled(TSM.Operations.HasRelationship("Crafting", private.currentOperationName, "craftPriceMethod") or operation.craftPriceMethod == "")
						:SetSettingInfo(operation, "craftPriceMethod", TSM.MainUI.Operations.CheckCustomPrice)
						:SetText(operation.craftPriceMethod ~= "" and operation.craftPriceMethod or TSM.db.global.craftingOptions.defaultCraftPriceMethod)
						:SetSpacing(6)
						:SetMultiLine(true, true)
						:SetScript("OnSizeChanged", private.CraftPriceOnSizeChanged)
						:SetScript("OnCursorChanged", private.CraftPriceOnCursorChanged)
						:SetScript("OnEnterPressed", private.CraftPriceOnEnterPressed)
					)
				)
				:SetScript("OnMouseUp", private.CraftPriceOnMouseUp)
			)
			:AddChild(TSM.MainUI.Operations.GetOperationManagementElements("Crafting", private.currentOperationName))
		)
end

function private.CreateNumericInputLine(key, label, minValue, maxValue)
	local operation = TSM.Operations.GetSettings("Crafting", private.currentOperationName)
	local hasRelationship = TSM.Operations.HasRelationship("Crafting", private.currentOperationName, key)
	return TSM.MainUI.Operations.CreateLinkedSettingLine(key, label)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", key.."Frame")
			:SetLayout("HORIZONTAL")
			-- move the right by the width of the input box so this frame gets half the total width
			:SetStyle("margin.right", -112)
			:AddChild(TSMAPI_FOUR.UI.NewElement("InputNumeric", "input")
				:SetStyle("width", 96)
				:SetStyle("height", 24)
				:SetStyle("margin.right", 16)
				:SetStyle("justifyH", "CENTER")
				:SetStyle("font", TSM.UI.Fonts.MontserratBold)
				:SetStyle("fontHeight", 16)
				:SetDisabled(hasRelationship)
				:SetSettingInfo(operation, key)
				:SetMaxNumber(maxValue)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "maxLabel")
				:SetStyle("fontHeight", 12)
				:SetText(format(L["(min %d - max %d)"], minValue, maxValue))
				:SetStyle("textColor", hasRelationship and "#424242" or "#e2e2e2")
			)
		)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.MinProfitToggleOnValueChanged(toggle, value)
	local operation = TSM.Operations.GetSettings("Crafting", private.currentOperationName)
	operation.minProfit = value and TSM.Operations.GetSettingDefault("Crafting", "minProfit") or ""
	local settingsFrame = toggle:GetParentElement():GetParentElement():GetParentElement()
	settingsFrame:GetElement("minProfitInputFrame.minProfit.left.linkBtn")
		:SetStyle("backgroundVertexColor", value and "#ffffff" or "#424242")
		:SetDisabled(not value)
	settingsFrame:GetElement("minProfitInputFrame.minProfit.left.label")
		:SetStyle("textColor", value and "#e2e2e2" or "#424242")
	settingsFrame:GetElement("minProfitInputFrame.minProfit.input")
		:SetDisabled(not value)
		:SetText(TSM.Money.ToString(TSM.Money.FromString(operation.minProfit)) or operation.minProfit)
	settingsFrame:Draw()
end

function private.CraftPriceToggleOnValueChanged(toggle, value)
	local operation = TSM.Operations.GetSettings("Crafting", private.currentOperationName)
	operation.craftPriceMethod = value and TSM.db.global.craftingOptions.defaultCraftPriceMethod or ""
	local settingsFrame = toggle:GetParentElement():GetParentElement():GetParentElement()
	settingsFrame:GetElement("craftPriceLabel")
		:SetStyle("textColor", value and "#e2e2e2" or "#424242")
	settingsFrame:GetElement("craftPrice.scroll.input")
		:SetDisabled(not value)
		:SetStyle("textColor", value and "#ffffff" or "#757575")
		:SetText(operation.craftPriceMethod ~= "" and operation.craftPriceMethod or TSM.db.global.craftingOptions.defaultCraftPriceMethod)
	settingsFrame:Draw()
end

function private.MoneyValueConvert(input)
	local text = gsub(strtrim(input:GetText()), TSMAPI_FOUR.Util.StrEscape(LARGE_NUMBER_SEPERATOR), "")
	local value = min(max(tonumber(text) or TSM.Money.FromString(text) or 0, 0), MAXIMUM_BID_PRICE)

	input:SetFocused(false)
	input:SetText(TSM.Money.ToString(value))
		:Draw()
end

function private.MinProfitOnChanged(input)
	local text = input:GetText()
	if not TSM.MainUI.Operations.CheckCustomPrice(text, true) then
		local operation = TSM.Operations.GetSettings("Crafting", private.currentOperationName)
		input:SetText(TSM.Money.ToString(TSM.Money.FromString(operation.minProfit)) or TSM.Money.ToString(operation.minProfit) or operation.minProfit)
	else
		input:SetText(TSM.Money.ToString(TSM.Money.FromString(text)) or TSM.Money.ToString(text) or text)
			:Draw()
	end
end

function private.CraftPriceOnSizeChanged(input, width, height)
	if input:HasFocus() then
		input:SetText(input:GetText())
	end

	input:SetStyle("height", height)
	input:GetParentElement():Draw()
end

function private.CraftPriceOnCursorChanged(input, _, y)
	local scrollFrame = input:GetParentElement()
	scrollFrame._scrollbar:SetValue(TSMAPI_FOUR.Util.Round(abs(y) / (input:_GetStyle("height") - 22) * scrollFrame:_GetMaxScroll()))
end

function private.CraftPriceOnMouseUp(frame)
	frame:GetElement("scroll.input"):SetFocused(true)
end

function private.CraftPriceOnEnterPressed(input)
	local text = input:GetText()
	if not TSM.MainUI.Operations.CheckCustomPrice(text, true) then
		local operation = TSM.Operations.GetSettings("Crafting", private.currentOperationName)
		input:SetText(TSM.Money.ToString(operation.craftPriceMethod) or operation.craftPriceMethod)
		input:SetFocused(true)

		private.CraftPriceOnSizeChanged(input, nil, input:GetHeight())
	else
		input:SetText(TSM.Money.ToString(TSM.Money.FromString(text)) or TSM.Money.ToString(text) or text)
			:Draw()
	end
end
