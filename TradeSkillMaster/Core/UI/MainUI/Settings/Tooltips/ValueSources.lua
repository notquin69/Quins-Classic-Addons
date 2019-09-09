-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local ValueSources = TSM.MainUI.Settings.Tooltip:NewPackage("ValueSources")
local L = TSM.L
local private = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function ValueSources.OnInitialize()
	TSM.MainUI.Settings.Tooltip.RegisterTooltipPage(L["ValueSources"], private.GetTooltipSettingsFrame)
end



-- ============================================================================
-- Value Sources Tooltip Settings UI
-- ============================================================================

function private.GetTooltipSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "tooltips", "value_sources")
	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "tooltipSettings")
		:SetStyle("padding.left", 12)
		:SetStyle("padding.right", 12)
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateHeading("dbHeading", L["Database Sources"]))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "dbHeadingDesc")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 24)
			:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Requires TSM Desktop Application"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "realmHeading")
			:SetStyle("height", 19)
			:SetStyle("margin.bottom", 10)
			:SetStyle("font", TSM.UI.Fonts.MontserratBold)
			:SetStyle("fontHeight", 16)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Realm Data Tooltips"])
		)
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display min buyout"], TSM.db.global.tooltipOptions.moduleTooltips.AuctionDB, "minBuyout"))
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display market value"], TSM.db.global.tooltipOptions.moduleTooltips.AuctionDB, "marketValue"))
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display historical price"], TSM.db.global.tooltipOptions.moduleTooltips.AuctionDB, "historical"))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "splitContent")
			:SetLayout("HORIZONTAL")
			:SetStyle("margin.top", 16)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "left")
				:SetLayout("VERTICAL")
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "regionHeading")
					:SetStyle("height", 19)
					:SetStyle("margin.bottom", 10)
					:SetStyle("font", TSM.UI.Fonts.MontserratBold)
					:SetStyle("fontHeight", 16)
					:SetStyle("textColor", "#ffffff")
					:SetText(L["Region Data Tooltips"])
				)
				:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display region min buyout avg"], TSM.db.global.tooltipOptions.moduleTooltips.AuctionDB, "regionMinBuyout"))
				:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display region market value avg"], TSM.db.global.tooltipOptions.moduleTooltips.AuctionDB, "regionMarketValue"))
				:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display region historical price"], TSM.db.global.tooltipOptions.moduleTooltips.AuctionDB, "regionHistorical"))
				:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display region sale avg"], TSM.db.global.tooltipOptions.moduleTooltips.AuctionDB, "regionSale"))
				:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display region sale rate"], TSM.db.global.tooltipOptions.moduleTooltips.AuctionDB, "regionSalePercent"))
				:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display region sold per day"], TSM.db.global.tooltipOptions.moduleTooltips.AuctionDB, "regionSoldPerDay"))
			)
		)
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateHeading("customSourcesHeading", L["Custom Sources"])
			:SetStyle("margin.top", 24)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "customSourcesDesc")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 24)
			:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Select custom price sources to include in item tooltips"])
		)
		:AddChildrenWithFunction(private.CustomPriceSources)
end

function private.CustomPriceSources(frame)
	for name in pairs(TSM.db.global.userData.customPriceSources) do
		frame:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(name, TSM.db.global.tooltipOptions.customPriceTooltips, name))
	end
end
