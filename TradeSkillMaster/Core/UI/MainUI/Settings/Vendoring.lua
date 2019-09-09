-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Vendoring = TSM.MainUI.Settings:NewPackage("Vendoring")
local L = TSM.L
local private = {}


-- ============================================================================
-- Module Functions
-- ============================================================================

function Vendoring.OnInitialize()
	TSM.MainUI.Settings.RegisterSettingPage("Vendoring", "middle", private.GetVendoringSettingsFrame)
end



-- ============================================================================
-- Vendoring Settings UI
-- ============================================================================

function private.GetVendoringSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "vendoring")
	return TSMAPI_FOUR.UI.NewElement("Frame", "vendoringSettings")
		:SetLayout("VERTICAL")
		:SetStyle("padding.left", 12)
		:SetStyle("padding.right", 12)
		:AddChild(TSM.MainUI.Settings.CreateHeading("generalOptionsTitle", L["General Options"])
			:SetStyle("margin.bottom", 15)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "checkbox")
			:SetStyle("height", 28)
			:SetStyle("margin.left", -5)
			:SetStyle("margin.bottom", 24)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 12)
			:SetSettingInfo(TSM.db.global.vendoringOptions, "displayMoneyCollected")
			:SetText(L["Display total money recieved in chat?"])
		)
		:AddChild(TSM.MainUI.Settings.CreateHeading("quicksellOptionsTitle", L["Quick Sell Options"])
			:SetStyle("margin.bottom", 16)
		)
		:AddChild(TSM.MainUI.Settings.CreateInputWithReset("qsMarketValueSourceField", L["Market Value Price Source"], "global.vendoringOptions.qsMarketValue", private.CheckCustomPrice))
		:AddChild(TSM.MainUI.Settings.CreateHeading("ignoredItemsTitle", L["Ignored Items"])
			:SetStyle("margin.top", 24)
			:SetStyle("margin.bottom", 6)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "ignoredItems")
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
					:SetIconInfo("itemString", TSMAPI_FOUR.Item.GetTexture)
					:SetTooltipInfo("itemString")
					:SetSortInfo("name")
					:Commit()
				:Commit()
			:SetQuery(TSM.Vendoring.Sell.CreateIgnoreQuery())
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

function private.IgnoredItemsOnRowClick(_, row, mouseButton)
	if mouseButton ~= "LeftButton" then
		return
	end
	TSM.Vendoring.Sell.ForgetIgnoreItemPermanent(row:GetField("itemString"))
end
