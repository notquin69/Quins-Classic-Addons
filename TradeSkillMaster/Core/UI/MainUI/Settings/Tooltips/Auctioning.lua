-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Auctioning = TSM.MainUI.Settings.Tooltip:NewPackage("Auctioning")
local L = TSM.L
local private = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Auctioning.OnInitialize()
	TSM.MainUI.Settings.Tooltip.RegisterTooltipPage(L["Auctioning"], private.GetTooltipSettingsFrame)
end



-- ============================================================================
-- Tooltip Settings UI
-- ============================================================================

function private.GetTooltipSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "tooltips", "auctioning")
	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "tooltipSettings")
		:SetStyle("padding.left", 12)
		:SetStyle("padding.right", 12)
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateHeading("header", L["Auctioning Tooltips"]))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "dbHeadingDesc")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 24)
			:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Select which auctioning information to display in item tooltips."])
		)
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display auctioning values"], TSM.db.global.tooltipOptions.moduleTooltips.Auctioning, "operationPrices"))
end
