-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Tooltip = TSM.MainUI.Settings:NewPackage("Tooltip")
local L = TSM.L



-- ============================================================================
-- Module Functions
-- ============================================================================

function Tooltip.OnInitialize()
	TSM.MainUI.Settings.RegisterSettingPage(L["Tooltip Settings"], "top")
end

function Tooltip.RegisterTooltipPage(name, callback)
	TSM.MainUI.Settings.RegisterChildSettingPage(L["Tooltip Settings"], name, callback)
end

function Tooltip.CreateCheckbox(text, settingTable, settingKey)
	return TSMAPI_FOUR.UI.NewElement("Checkbox", settingKey.."Checkbox")
		:SetStyle("height", 24)
		:SetStyle("margin.left", -5)
		:SetStyle("margin.bottom", 4)
		:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
		:SetStyle("fontHeight", 12)
		:SetText(text)
		:SetSettingInfo(settingTable, settingKey)
end

function Tooltip.CreateHeading(id, text)
	return TSMAPI_FOUR.UI.NewElement("Text", id)
		:SetStyle("height", 19)
		:SetStyle("margin.bottom", 4)
		:SetStyle("font", TSM.UI.Fonts.MontserratBold)
		:SetStyle("fontHeight", 16)
		:SetStyle("textColor", "#ffffff")
		:SetText(text)
end

function Tooltip.CreateDescription(id, text)
	return TSMAPI_FOUR.UI.NewElement("Text", id)
		:SetStyle("height", 18)
		:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
		:SetStyle("fontHeight", 14)
		:SetStyle("textColor", "#ffffff")
		:SetText(text)
end
