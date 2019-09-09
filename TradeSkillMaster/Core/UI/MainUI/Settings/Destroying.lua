-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Destroying = TSM.MainUI.Settings:NewPackage("Destroying")
local L = TSM.L
local private = {}
local ITEM_QUALITY_DESCS = { ITEM_QUALITY2_DESC, ITEM_QUALITY3_DESC, ITEM_QUALITY4_DESC }
local ITEM_QUALITY_KEYS = { 2, 3, 4 }



-- ============================================================================
-- Module Functions
-- ============================================================================

function Destroying.OnInitialize()
	TSM.MainUI.Settings.RegisterSettingPage("Destroying", "middle", private.GetDestroyingSettingsFrame)
end



-- ============================================================================
-- Destroying Settings UI
-- ============================================================================

function private.GetDestroyingSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "destroying")
	return TSMAPI_FOUR.UI.NewElement("Frame", "destroyingSettings")
		:SetLayout("VERTICAL")
		:SetStyle("padding.left", 12)
		:SetStyle("padding.right", 12)
		:AddChild(TSM.MainUI.Settings.CreateHeading("generalOptionsTitle", L["General Options"])
			:SetStyle("margin.bottom", 15)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "autoStackCheckbox")
			:SetStyle("height", 28)
			:SetStyle("fontHeight", 12)
			:SetText(L["Enable automatic stack combination"])
			:SetSettingInfo(TSM.db.global.destroyingOptions, "autoStack")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "autoShowCheckbox")
			:SetStyle("height", 28)
			:SetStyle("margin.bottom", 30)
			:SetStyle("fontHeight", 12)
			:SetText(L["Show Destroying frame automatically"])
			:SetSettingInfo(TSM.db.global.destroyingOptions, "autoShow")
		)
		:AddChild(TSM.MainUI.Settings.CreateHeading("disenchantingOptionsTitle", L["Disenchanting Options"])
			:SetStyle("margin.bottom", 15)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 4)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Maximum Disenchant Quality"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "maxQualityDropDown")
			:SetStyle("height", 26)
			:SetStyle("width", 300)
			:SetStyle("margin.bottom", 14)
			:SetItems(ITEM_QUALITY_DESCS, ITEM_QUALITY_KEYS)
			:SetSettingInfo(TSM.db.global.destroyingOptions, "deMaxQuality")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "includeSoulboundCheckbox")
			:SetStyle("height", 28)
			:SetStyle("fontHeight", 12)
			:SetText(L["Include soulbound items"])
			:SetSettingInfo(TSM.db.global.destroyingOptions, "includeSoulbound")
		)
		:AddChild(TSM.MainUI.Settings.CreateInputWithReset("deDisenchantPriceField", L["Only show items with disenchant value above custom price"], "global.destroyingOptions.deAbovePrice", private.CheckCustomPrice))
		:AddChild(TSM.MainUI.Settings.CreateHeading("ignoredItemsTitle", L["Ignored Items"])
			:SetStyle("margin.top", 24)
			:SetStyle("margin.bottom", 6)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "items")
			:SetStyle("headerFontHeight", 12)
			:SetStyle("margin.left", -12)
			:SetStyle("margin.right", -12)
			:SetStyle("padding.left", 12)
			:SetStyle("padding.right", 12)
			:SetStyle("rowHeight", 20)
			:GetScrollingTableInfo()
				:NewColumn("item")
					:SetTitles(L["Item"])
					:SetFont(TSM.UI.Fonts.MontserratRegular)
					:SetFontHeight(12)
					:SetJustifyH("LEFT")
					:SetIconSize(12)
					:SetTextInfo("itemString", TSM.UI.GetColoredItemName)
					:SetIconInfo("texture")
					:SetTooltipInfo("itemString")
					:SetSortInfo("name")
					:Commit()
				:Commit()
			:SetQuery(TSM.Destroying.CreateIgnoreQuery())
			:SetAutoReleaseQuery(true)
			:SetSelectionDisabled(true)
			:SetScript("OnRowClick", private.IgnoredItemsOnRowClick)
		)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.CheckCustomPrice(value)
	local isValid, err = TSMAPI_FOUR.CustomPrice.Validate(value)
	if isValid then
		return true
	else
		TSM:Print(L["Invalid custom price."].." "..err)
		return false
	end
end

function private.IgnoredItemsOnRowClick(_, record, mouseButton)
	if mouseButton ~= "LeftButton" then
		return
	end
	TSM.Destroying.ForgetIgnoreItemPermanent(record:GetField("itemString"))
end
