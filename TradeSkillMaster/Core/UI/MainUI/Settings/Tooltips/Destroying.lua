-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Destroying = TSM.MainUI.Settings.Tooltip:NewPackage("Destroying")
local L = TSM.L
local private = { sources = {}, sourceKeys = {} }
local INVALID_PRICE_SOURCES = {
	Crafting = true,
	VendorBuy = true,
	VendorSell = true,
	Destroy = true,
	ItemQuality = true,
	ItemLevel = true,
	RequiredLevel = true,
	NumExpires = true,
	DBRegionSaleRate = true,
	DBRegionSoldPerDay = true,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Destroying.OnInitialize()
	TSM.MainUI.Settings.Tooltip.RegisterTooltipPage(L["Destroying"], private.GetTooltipSettingsFrame)
end



-- ============================================================================
-- Tooltip Settings UI
-- ============================================================================

function private.GetTooltipSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "tooltips", "destroying")
	wipe(private.sources)
	wipe(private.sourceKeys)
	for key, _, label in TSMAPI_FOUR.CustomPrice.Iterator() do
		if not INVALID_PRICE_SOURCES[key] then
			tinsert(private.sources, label)
			tinsert(private.sourceKeys, strlower(key))
		end
	end

	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "tooltipSettings")
		:SetStyle("padding.left", 12)
		:SetStyle("padding.right", 12)
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateHeading("heading", L["Destroying Tooltips"]))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "headingDesc")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 24)
			:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Select which destroying information to display in item tooltips."])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 4)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Destroy Value Source"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "dropdownFrame")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin.bottom", 16)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "dropdown")
				:SetItems(private.sources, private.sourceKeys)
				:SetSettingInfo(TSM.db.global.coreOptions, "destroyValueSource")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
		)
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display detailed destroy info"], TSM.db.global.tooltipOptions, "detailedDestroyTooltip"))
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display mill value"], TSM.db.global.tooltipOptions, "millTooltip"))
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display prospect value"], TSM.db.global.tooltipOptions, "prospectTooltip"))
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display disenchant value"], TSM.db.global.tooltipOptions, "deTooltip"))
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display transform value"], TSM.db.global.tooltipOptions, "transformTooltip"))
end
