-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Resale = TSM.MainUI.Ledger.Revenue:NewPackage("Resale")
local L = TSM.L
local SECONDS_PER_DAY = 24 * 60 * 60
local private = {
	query = nil,
	summaryQuery = nil,
	characters = {},
	characterFilter = ALL,
	typeFilter = "All",
	searchFilter = "",
	groupList = {},
	groupFilter = ALL,
	rarityList = {},
	rarityListKeys = {},
	rarityFilter = {},
	timeFrameFilter = 30 * SECONDS_PER_DAY
}
local TYPE_LIST = { ALL, L["Auction"], COD, TRADE, L["Vendor"] }
local TYPE_KEYS = { "All", "Auction", "COD", "Trade", "Vendor" }
do
	for i = 1, 4 do
		tinsert(private.rarityList, _G[format("ITEM_QUALITY%d_DESC", i)])
		tinsert(private.rarityListKeys, i)
	end
end
local TIME_LIST = { ALL, L["Last 3 Days"], L["Last 7 Days"], L["Last 14 Days"], L["Last 30 Days"], L["Last 60 Days"] }
local TIME_KEYS = { 0, 3 * SECONDS_PER_DAY, 7 * SECONDS_PER_DAY, 14 * SECONDS_PER_DAY, 30 * SECONDS_PER_DAY, 60 * SECONDS_PER_DAY }



-- ============================================================================
-- Module Functions
-- ============================================================================

function Resale.OnInitialize()
	TSM.MainUI.Ledger.Revenue.RegisterPage(L["Resale"], private.DrawResalePage)
end



-- ============================================================================
-- Resale UI
-- ============================================================================

function private.DrawResalePage()
	TSM.UI.AnalyticsRecordPathChange("main", "ledger", "revenue", "resale")
	wipe(private.characters)
	tinsert(private.characters, ALL)
	TSM.Accounting.Transactions.GetCharacters(private.characters)

	wipe(private.groupList)
	tinsert(private.groupList, ALL)
	for _, groupPath in TSM.Groups.GroupIterator() do
		tinsert(private.groupList, groupPath)
	end

	private.summaryQuery = private.summaryQuery or TSM.Accounting.Transactions.CreateSummaryQuery()
		:InnerJoin(TSM.ItemInfo.GetDBForJoin(), "itemString")
		:OrderBy("name", true)

	private.UpdateQuery()

	return TSMAPI_FOUR.UI.NewElement("Frame", "content")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "firstRow")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 14)
			:SetStyle("padding.left", 8)
			:SetStyle("padding.right", 8)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "search")
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 10)
				:SetText(strupper(SEARCH))
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "group")
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 10)
				:SetText(strupper(GROUP))
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "type")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 10)
				:SetText(strupper(TYPE))
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "firstRowFields")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin.top", 4)
			:SetStyle("margin.bottom", 24)
			:SetStyle("padding.left", 8)
			:SetStyle("padding.right", 8)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "searchInput")
				:SetStyle("margin.right", 16)
				:SetHintText(L["Filter by Keyword"])
				:SetStyle("hintTextColor", "#e2e2e2")
				:SetStyle("hintJustifyH", "LEFT")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetScript("OnEnterPressed", private.SearchFilterChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "groupInput")
				:SetStyle("margin.right", 16)
				:SetItems(private.groupList)
				:SetSelectedItem(private.groupFilter)
				:SetScript("OnSelectionChanged", private.GroupDropdownOnSelectionChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "typeInput")
				:SetItems(TYPE_LIST, TYPE_KEYS)
				:SetSelectedItemByKey(private.typeFilter)
				:SetScript("OnSelectionChanged", private.TypeDropdownOnSelectionChanged)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "secondRow")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 14)
			:SetStyle("padding.left", 8)
			:SetStyle("padding.right", 8)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "rarity")
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 10)
				:SetText(strupper(RARITY))
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "character")
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 10)
				:SetText(L["CHARACTER"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "timeFrame")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 10)
				:SetText(L["TIME FRAME"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "secondRowFields")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin.top", 4)
			:SetStyle("margin.bottom", 24)
			:SetStyle("padding.left", 8)
			:SetStyle("padding.right", 8)
			:AddChild(TSMAPI_FOUR.UI.NewElement("MultiselectionDropdown", "rarityInput")
				:SetStyle("margin.right", 16)
				:SetScript("OnSelectionChanged", private.RarityDropdownOnSelectionChanged)
				:SetItems(private.rarityList, private.rarityListKeys)
				:SetHintText(L["None"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "characterSelect")
				:SetStyle("margin.right", 16)
				:SetItems(private.characters)
				:SetSelectedItem(private.characterFilter)
				:SetScript("OnSelectionChanged", private.CharacterDropdownOnSelectionChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "timeFrameInput")
				:SetItems(TIME_LIST, TIME_KEYS)
				:SetSelectedItemByKey(private.timeFrameFilter)
				:SetScript("OnSelectionChanged", private.TimeDropdownOnSelectionChanged)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "accountingScrollingTableFrame")
			:SetLayout("VERTICAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", 2)
				:SetStyle("color", "#9d9d9d")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "scrollingTable")
				:SetStyle("headerBackground", "#404040")
				:SetStyle("headerFont", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("headerFontHeight", 14)
				:GetScrollingTableInfo()
					:NewColumn("item")
						:SetTitles(L["Item"])
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo("itemString", TSMAPI_FOUR.Item.GetLink)
						:SetSortInfo("name")
						:SetTooltipInfo("itemString")
						:Commit()
					:NewColumn("sold")
						:SetTitles(L["Sold"])
						:SetWidth(50)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo("sold")
						:SetSortInfo("sold")
						:Commit()
					:NewColumn("avgSellPrice")
						:SetTitles(L["Avg Sell Price"])
						:SetWidth(140)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo("avgSellPrice", private.GetMoneyText)
						:SetSortInfo("avgSellPrice")
						:Commit()
					:NewColumn("bought")
						:SetTitles(L["Bought"])
						:SetWidth(70)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("bought")
						:SetSortInfo("bought")
						:Commit()
					:NewColumn("avgBuyPrice")
						:SetTitles(L["Avg Buy Price"])
						:SetWidth(140)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("avgBuyPrice", private.GetMoneyText)
						:SetSortInfo("avgBuyPrice")
						:Commit()
					:NewColumn("avgResaleProfit")
						:SetTitles(L["Avg Resale Profit"])
						:SetWidth(140)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("avgResaleProfit", private.GetMoneyText)
						:SetSortInfo("avgResaleProfit")
						:Commit()
					:Commit()
				:SetQuery(private.summaryQuery)
				:SetScript("OnRowClick", private.TableSelectionChanged)
			)
		)
end



-- ============================================================================
-- Scrolling Table Helper Functions
-- ============================================================================

function private.GetMoneyText(record)
	return TSM.Money.ToString(record)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.DropdownChangedCommon(dropdown)
	private.UpdateQuery()
	dropdown:GetElement("__parent.__parent.accountingScrollingTableFrame.scrollingTable")
		:UpdateData(true)
end

function private.TimeDropdownOnSelectionChanged(dropdown)
	private.timeFrameFilter = dropdown:GetSelectedItemKey()
	private.DropdownChangedCommon(dropdown)
end

function private.TypeDropdownOnSelectionChanged(dropdown)
	private.typeFilter = dropdown:GetSelectedItemKey()
	private.DropdownChangedCommon(dropdown)
end

function private.SearchFilterChanged(input)
	private.searchFilter = strtrim(input:GetText())
	private.DropdownChangedCommon(input)
end

function private.CharacterDropdownOnSelectionChanged(dropdown)
	private.characterFilter = dropdown:GetSelectedItem()
	private.DropdownChangedCommon(dropdown)
end

function private.RarityDropdownOnSelectionChanged(dropdown)
	wipe(private.rarityFilter)
	for _, key in ipairs(private.rarityListKeys) do
		if dropdown:ItemIsSelectedByKey(key) then
			tinsert(private.rarityFilter, key)
		end
	end
	private.DropdownChangedCommon(dropdown)
end

function private.GroupDropdownOnSelectionChanged(dropdown)
	private.groupFilter = dropdown:GetSelectedItem()
	private.DropdownChangedCommon(dropdown)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.UpdateQuery()
	private.summaryQuery:ResetFilters()
	TSM.Accounting.Transactions.UpdateSummaryData(private.groupFilter, private.typeFilter, private.characterFilter, private.timeFrameFilter)

	if private.searchFilter ~= "" then
		private.summaryQuery:Matches("name", TSMAPI_FOUR.Util.StrEscape(private.searchFilter))
	end
	if #private.rarityFilter ~= 0 then
		private.summaryQuery:Custom(private.CompareRarityFilter, private.rarityFilter)
	end
end

function private.CompareRarityFilter(row, rarityFilter)
	return TSMAPI_FOUR.Util.TableKeyByValue(rarityFilter, row:GetField("quality")) and true or false
end

function private.TableSelectionChanged(scrollingTable, row)
	scrollingTable:GetParentElement():GetParentElement():GetParentElement():SetContext(row:GetField("itemString")):SetPath("itemDetail", true)
end
