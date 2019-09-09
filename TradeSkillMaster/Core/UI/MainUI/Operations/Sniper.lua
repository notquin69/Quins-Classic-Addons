-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Sniper = TSM.MainUI.Operations:NewPackage("Sniper")
local L = TSM.L
local private = { currentOperationName = nil }



-- ============================================================================
-- Module Functions
-- ============================================================================

function Sniper.OnInitialize()
	TSM.MainUI.Operations.RegisterModule("Sniper", private.GetSniperOperationSettings)
end



-- ============================================================================
-- Sniper Operation Settings UI
-- ============================================================================

function private.GetSniperOperationSettings(operationName)
	TSM.UI.AnalyticsRecordPathChange("main", "operations", "sniper")
	private.currentOperationName = operationName
	local operation = TSM.Operations.GetSettings("Sniper", private.currentOperationName)
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
			:AddChild(TSM.MainUI.Operations.CreateHeadingLine("settings", L["Sniper Settings"]))
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("belowPrice", L["Below custom price:"]))
			:AddChild(TSMAPI_FOUR.UI.NewElement("BorderedFrame", "sniperPrice")
				:SetLayout("HORIZONTAL")
				:SetStyle("borderTheme", "roundLight")
				:AddChild(TSMAPI_FOUR.UI.NewElement("ScrollFrame", "scroll")
					:SetStyle("height", 99)
					:SetStyle("margin.bottom", 2)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
						:SetStyle("height", 97)
						:SetStyle("margin", { left = 2, right = 8 })
						:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
						:SetStyle("fontHeight", 14)
						:SetStyle("justifyH", "LEFT")
						:SetDisabled(TSM.Operations.HasRelationship("Sniper", private.currentOperationName, "belowPrice"))
						:SetSettingInfo(operation, "belowPrice", TSM.MainUI.Operations.CheckCustomPrice)
						:SetText(TSM.Money.ToString(operation.belowPrice) or operation.belowPrice)
						:SetSpacing(6)
						:SetMultiLine(true, true)
						:SetScript("OnSizeChanged", private.SniperPriceOnSizeChanged)
						:SetScript("OnCursorChanged", private.SniperPriceOnCursorChanged)
						:SetScript("OnEnterPressed", private.SniperPriceOnEnterPressed)
					)
				)
				:SetScript("OnMouseUp", private.SniperPriceOnMouseUp)
			)
			:AddChild(TSM.MainUI.Operations.GetOperationManagementElements("Sniper", private.currentOperationName))
		)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.SniperPriceOnSizeChanged(input, width, height)
	if input:HasFocus() then
		input:SetText(input:GetText())
	end

	input:SetStyle("height", height)
	input:GetParentElement():Draw()
end

function private.SniperPriceOnCursorChanged(input, _, y)
	local scrollFrame = input:GetParentElement()
	scrollFrame._scrollbar:SetValue(TSMAPI_FOUR.Util.Round(abs(y) / (input:_GetStyle("height") - 22) * scrollFrame:_GetMaxScroll()))
end

function private.SniperPriceOnMouseUp(frame)
	frame:GetElement("scroll.input"):SetFocused(true)
end

function private.SniperPriceOnEnterPressed(input)
	if not TSM.MainUI.Operations.CheckCustomPrice(input:GetText(), true) then
		local operation = TSM.Operations.GetSettings("Sniper", private.currentOperationName)
		input:SetText(TSM.Money.ToString(operation.belowPrice) or operation.belowPrice)
		input:SetFocused(true)

		private.SniperPriceOnSizeChanged(input, nil, input:GetHeight())
	end
end
