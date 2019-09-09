-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Shopping = TSM.MainUI.Operations:NewPackage("Shopping")
local L = TSM.L
local private = { currentOperationName = nil }
local RESTOCK_SOURCES = { bank = BANK, guild = GUILD, alts = L["Alts"], auctions = L["Auctions"] }
local RESTOCK_SOURCES_ORDER = { "alts", "auctions", "bank", "guild" }



-- ============================================================================
-- Module Functions
-- ============================================================================

function Shopping.OnInitialize()
	TSM.MainUI.Operations.RegisterModule("Shopping", private.GetShoppingOperationSettings)
end



-- ============================================================================
-- Shopping Operation Settings UI
-- ============================================================================

function private.GetShoppingOperationSettings(operationName)
	TSM.UI.AnalyticsRecordPathChange("main", "operations", "shopping")
	private.currentOperationName = operationName
	local operation = TSM.Operations.GetSettings("Shopping", private.currentOperationName)
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
			:AddChild(TSM.MainUI.Operations.CreateHeadingLine("generalOptions", L["General Options"]))
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("maxPrice", L["Maximum Auction Price (Per Item)"]))
			:AddChild(TSMAPI_FOUR.UI.NewElement("BorderedFrame", "maxPrice")
				:SetLayout("HORIZONTAL")
				:SetStyle("borderTheme", "roundLight")
				:SetStyle("margin.bottom", 16)
				:AddChild(TSMAPI_FOUR.UI.NewElement("ScrollFrame", "scroll")
					:SetStyle("height", 61)
					:SetStyle("margin.bottom", 2)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
						:SetStyle("height", 59)
						:SetStyle("margin", { left = 2, right = 8 })
						:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
						:SetStyle("fontHeight", 14)
						:SetStyle("justifyH", "LEFT")
						:SetText(TSM.Money.ToString(operation.maxPrice) or operation.maxPrice)
						:SetDisabled(TSM.Operations.HasRelationship("Shopping", private.currentOperationName, "maxPrice"))
						:SetSettingInfo(operation, "maxPrice", TSM.MainUI.Operations.CheckCustomPrice)
						:SetSpacing(6)
						:SetMultiLine(true, true)
						:SetScript("OnSizeChanged", private.OperationOnSizeChanged)
						:SetScript("OnCursorChanged", private.OperationOnCursorChanged)
						:SetScript("OnEnterPressed", private.MaxPriceOnEnterPressed)
					)
				)
				:SetScript("OnMouseUp", private.OperationOnMouseUp)
			)
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("showAboveMaxPrice", L["Show auctions above max price?"])
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "showAboveMaxPriceSettingFrame")
					:SetLayout("HORIZONTAL")
					-- move the right by the width of the toggle so this frame gets half the total width
					:SetStyle("margin.right", -TSM.UI.TexturePacks.GetWidth("uiFrames.ToggleOn"))
					:AddChild(TSMAPI_FOUR.UI.NewElement("ToggleOnOff", "showAboveMaxPrice")
						:SetSettingInfo(operation, "showAboveMaxPrice")
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
				)
			)
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("evenStacks", L["Neat Stacks only?"])
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "evenStacksSettingFrame")
					:SetLayout("HORIZONTAL")
					-- move the right by the width of the toggle so this frame gets half the total width
					:SetStyle("margin.right", -TSM.UI.TexturePacks.GetWidth("uiFrames.ToggleOn"))
					:AddChild(TSMAPI_FOUR.UI.NewElement("ToggleOnOff", "evenStacks")
						:SetSettingInfo(operation, "evenStacks")
						:SetDisabled(TSM.Operations.HasRelationship("Shopping", private.currentOperationName, "evenStacks"))
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
				)
			)
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("restockQuantity", L["Maximum restock quantity:"])
				:SetLayout("HORIZONTAL")
				:SetStyle("margin.right", -112)
				:SetStyle("margin.bottom", 16)
				:AddChild(TSMAPI_FOUR.UI.NewElement("InputNumeric", "restockInput")
					:SetStyle("width", 96)
					:SetStyle("height", 24)
					:SetStyle("margin.right", 16)
					:SetStyle("justifyH", "CENTER")
					:SetStyle("font", TSM.UI.Fonts.MontserratBold)
					:SetStyle("fontHeight", 16)
					:SetSettingInfo(operation, "restockQuantity")
					:SetDisabled(TSM.Operations.HasRelationship("Shopping", private.currentOperationName, "restockQuantity"))
					:SetMaxNumber(10000)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "restockLabel")
					:SetText(L["(min 0 - max 10000)"])
					:SetStyle("fontHeight", 14)
				)
			)
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("restockSources", L["Sources to include for restock:"])
				:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "restockSourcesDropdown")
					:SetMultiselect(true)
					:SetDictionaryItems(RESTOCK_SOURCES, operation.restockSources, RESTOCK_SOURCES_ORDER)
					:SetSettingInfo(operation, "restockSources")
					:SetDisabled(TSM.Operations.HasRelationship("Shopping", private.currentOperationName, "restockSources"))
				)
			)
			:AddChild(TSM.MainUI.Operations.GetOperationManagementElements("Shopping", private.currentOperationName))
		)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.OperationOnSizeChanged(input, width, height)
	if input:HasFocus() then
		input:SetText(input:GetText())
	end

	input:SetStyle("height", height)
	input:GetParentElement():Draw()
end

function private.OperationOnCursorChanged(input, _, y)
	local scrollFrame = input:GetParentElement()
	scrollFrame._scrollbar:SetValue(TSMAPI_FOUR.Util.Round(abs(y) / (input:_GetStyle("height") - 22) * scrollFrame:_GetMaxScroll()))
end

function private.OperationOnMouseUp(frame)
	frame:GetElement("scroll.input"):SetFocused(true)
end

function private.MaxPriceOnEnterPressed(input)
	if not TSM.MainUI.Operations.CheckCustomPrice(input:GetText(), true) then
		local operation = TSM.Operations.GetSettings("Shopping", private.currentOperationName)
		input:SetText(TSM.Money.ToString(operation.maxPrice) or operation.maxPrice)
		input:SetFocused(true)

		private.OperationOnSizeChanged(input, nil, input:GetHeight())
	end
end
