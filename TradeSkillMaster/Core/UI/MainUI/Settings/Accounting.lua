-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Accounting = TSM.MainUI.Settings:NewPackage("Accounting")
local L = TSM.L
local private = { marketValueItems = {}, marketValueKeys = {} }
local DAYS_OLD_OPTIONS = { 30, 45, 60, 75, 90, 180, 360 }
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

function Accounting.OnInitialize()
	TSM.MainUI.Settings.RegisterSettingPage("Accounting", "middle", private.GetAccountingSettingsFrame)
end



-- ============================================================================
-- Accounting Settings UI
-- ============================================================================

function private.GetAccountingSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "accounting")
	wipe(private.marketValueItems)
	wipe(private.marketValueKeys)
	for key, _, label in TSMAPI_FOUR.CustomPrice.Iterator() do
		if not INVALID_PRICE_SOURCES[key] then
			tinsert(private.marketValueItems, label)
			tinsert(private.marketValueKeys, strlower(key))
		end
	end

	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "accountingSettings")
		:SetStyle("padding.left", 12)
		:SetStyle("padding.right", 12)
		:AddChild(TSM.MainUI.Settings.CreateHeading("generalOptionsTitle", L["General Options"])
			:SetStyle("margin.bottom", 16)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "row1Labels")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 4)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "timeFormat")
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Time Format"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "marketValue")
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Market Value Source"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "tradeCheckbox")
			:SetStyle("height", 28)
			:SetStyle("fontHeight", 12)
			:SetText(L["Track Sales / Purchases via trade"])
			:SetSettingInfo(TSM.db.global.accountingOptions, "trackTrades")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "tradePromptCheckbox")
			:SetStyle("height", 28)
			:SetStyle("fontHeight", 12)
			:SetText(L["Don't prompt to record trades"])
			:SetSettingInfo(TSM.db.global.accountingOptions, "autoTrackTrades")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "smartAvgCheckbox")
			:SetStyle("height", 28)
			:SetStyle("margin.bottom", 32)
			:SetStyle("fontHeight", 12)
			:SetText(L["Use smart average for purchase price"])
			:SetSettingInfo(TSM.db.global.accountingOptions, "smartBuyPrice")
		)
		:AddChild(TSM.MainUI.Settings.CreateHeading("clearOldData", L["Clear Old Data"]))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "clearDataDesc")
			:SetStyle("height", 54)
			:SetStyle("margin.bottom", 16)
			:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetFormattedText(L["You can use the options below to clear old data. It is recommended to occasionally clear your old data to keep the accounting module running smoothly. Select the minimum number of days old to be removed, then click '%s'."], L["CLEAR DATA"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "daysOldLabel")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 4)
			:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Minimum Days Old"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "daysOld")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "dropdown")
				:SetStyle("margin.right", 16)
				:SetHintText(L["None Selected"])
				:SetItems(DAYS_OLD_OPTIONS)
				:SetScript("OnSelectionChanged", private.DaysOldDropdownOnSelectionChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "clearBtn")
				:SetDisabled(true)
				:SetText(L["CLEAR DATA"])
				:SetScript("OnClick", private.ClearBtnOnClick)
			)
		)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.DaysOldDropdownOnSelectionChanged(dropdown)
	dropdown:GetElement("__parent.clearBtn")
		:SetDisabled(false)
		:Draw()
end

function private.ClearBtnOnClick(button)
	local days = button:GetElement("__parent.dropdown"):GetSelectedItem()
	button:GetBaseElement():ShowConfirmationDialog(L["Clear Old Data Confirmation"], L["Are you sure you want to clear old accounting data?"], strupper(YES), private.ClearDataConfirmed, days)
end

function private.ClearDataConfirmed(days)
	TSM:Printf(L["Removed a total of %s old records."], TSM.Accounting.Transactions.RemoveOldData(days) + TSM.Accounting.Money.RemoveOldData(days) + TSM.Accounting.Auctions.RemoveOldData(days))
end
