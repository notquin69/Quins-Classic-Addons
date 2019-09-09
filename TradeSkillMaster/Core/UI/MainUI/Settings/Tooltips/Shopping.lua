-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Shopping = TSM.MainUI.Settings.Tooltip:NewPackage("Shopping")
local L = TSM.L
local private = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Shopping.OnInitialize()
	TSM.MainUI.Settings.Tooltip.RegisterTooltipPage(L["Shopping"], private.GetTooltipSettingsFrame)
end



-- ============================================================================
-- Tooltip Settings UI
-- ============================================================================

function private.GetTooltipSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "tooltips", "shopping")
	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "tooltipSettings")
		:SetStyle("padding.left", 12)
		:SetStyle("padding.right", 12)
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateHeading("heading", L["Shopping Tooltips"]))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "headingDesc")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 8)
			:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Select which shopping information to display in item tooltips."])
		)
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display shopping max price"], TSM.db.global.tooltipOptions.moduleTooltips.Shopping, "maxPrice"))
end
