-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Crafting = TSM.MainUI.Settings.Tooltip:NewPackage("Crafting")
local L = TSM.L
local private = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Crafting.OnInitialize()
	TSM.MainUI.Settings.Tooltip.RegisterTooltipPage(L["Crafting"], private.GetTooltipSettingsFrame)
end



-- ============================================================================
-- Tooltip Settings UI
-- ============================================================================

function private.GetTooltipSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "tooltips", "crafting")
	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "tooltipSettings")
		:SetStyle("padding.left", 12)
		:SetStyle("padding.right", 12)
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateHeading("heading", L["Crafting Tooltips"]))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "headingDesc")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 8)
			:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Select which crafting information to display in item tooltips."])
		)
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display crafting cost"], TSM.db.global.tooltipOptions.moduleTooltips.Crafting, "craftingCost"))
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Show material cost"], TSM.db.global.tooltipOptions.moduleTooltips.Crafting, "matPrice"))
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["List materials in tooltip"], TSM.db.global.tooltipOptions.moduleTooltips.Crafting, "detailedMats"))
end
