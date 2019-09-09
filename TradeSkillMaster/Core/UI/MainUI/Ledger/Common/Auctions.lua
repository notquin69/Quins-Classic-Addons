-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Auctions = TSM.MainUI.Ledger.Common:NewPackage("Auctions")
local L = TSM.L
local SECONDS_PER_DAY = 24 * 60 * 60
local private = {
	query = nil,
	characters = {},
	characterFilter = ALL,
	typeFilter = "All",
	searchFilter = "",
	groupList = {},
	groupFilter = ALL,
	rarityList = {},
	rarityListKeys = {},
	rarityFilter = {},
	timeFrameFilter = 30 * SECONDS_PER_DAY,
	type = nil
}
local TYPE_LIST = { ALL }
local TYPE_KEYS = { "All" }
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

function Auctions.OnInitialize()
	TSM.MainUI.Ledger.FailedAuctions.RegisterPage(L["Expired"], private.DrawExpiredPage)
	TSM.MainUI.Ledger.FailedAuctions.RegisterPage(L["Cancelled"], private.DrawCancelledPage)
end



-- ============================================================================
-- Auctions UIs
-- ============================================================================

function private.DrawExpiredPage()
	TSM.UI.AnalyticsRecordPathChange("main", "ledger", "failed_auctions", "expired")
	private.type = "expire"
	return private.DrawAuctionsPage()
end

function private.DrawCancelledPage()
	TSM.UI.AnalyticsRecordPathChange("main", "ledger", "failed_auctions", "cancelled")
	private.type = "cancel"
	return private.DrawAuctionsPage()
end

function private.DrawAuctionsPage()
	private.query = private.query or TSM.Accounting.Auctions.CreateQuery()

	private.query:Reset()
		:Equal("type", "cancel")
		:Distinct("player")
		:Select("player")
	wipe(private.characters)
	tinsert(private.characters, ALL)
	for _, character in private.query:Iterator() do
		tinsert(private.characters, character)
	end

	private.query:Reset()
		:InnerJoin(TSM.ItemInfo.GetDBForJoin(), "itemString")
		:LeftJoin(TSM.Groups.GetItemDBForJoin(), "itemString")
		:OrderBy("time", false)

	wipe(private.groupList)
	tinsert(private.groupList, ALL)
	for _, groupPath in TSM.Groups.GroupIterator() do
		tinsert(private.groupList, groupPath)
	end
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
				:SetHintText(L["None"])
				:SetItems(private.groupList)
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
						:SetTooltipInfo("itemString")
						:SetSortInfo("name")
						:Commit()
					:NewColumn("player")
						:SetTitles(PLAYER)
						:SetWidth(150)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo("player")
						:SetSortInfo("player")
						:Commit()
					:NewColumn("stackSize")
						:SetTitles(L["Stack"])
						:SetWidth(55)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("stackSize")
						:SetSortInfo("stackSize")
						:Commit()
					:NewColumn("quantity")
						:SetTitles(L["Auctions"])
						:SetWidth(80)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo(nil, private.FormatAuctions)
						:SetSortInfo("quantity")
						:Commit()
					:NewColumn("time")
						:SetTitles(L["Time Frame"])
						:SetWidth(120)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("time", private.TableGetTimeframeText)
						:SetSortInfo("time")
						:Commit()
					:Commit()
				:SetQuery(private.query)
				:SetScript("OnRowClick", private.TableSelectionChanged)
			)
		)
end



-- ============================================================================
-- Scrolling Table Helper Functions
-- ============================================================================

function private.TableGetTimeframeText(record)
	return SecondsToTime(time() - record)
end

function private.FormatAuctions(row)
	return row:GetField("quantity") / row:GetField("stackSize")
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
	private.rarityFilter = {}
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
	private.query:ResetFilters()
		:Equal("type", private.type)
	if private.searchFilter ~= "" then
		private.query:Matches("name", TSMAPI_FOUR.Util.StrEscape(private.searchFilter))
	end
	if private.typeFilter ~= "All" then
		private.query:Equal("source", private.typeFilter)
	end
	if #private.rarityFilter ~= 0 then
		private.query:Custom(private.CompareRarityFilter, private.rarityFilter)
	end
	if private.characterFilter ~= ALL then
		private.query:Equal("player", private.characterFilter)
	end
	if private.timeFrameFilter ~= 0 then
		private.query:GreaterThan("time", time() - private.timeFrameFilter)
	end
	if private.groupFilter ~= ALL then
		private.query:Equal("groupPath", private.groupFilter)
	end
end

function private.CompareRarityFilter(row, rarityFilter)
	return TSMAPI_FOUR.Util.TableKeyByValue(rarityFilter, row:GetField("quality")) and true or false
end

function private.TableSelectionChanged(scrollingTable, row)
	scrollingTable:GetParentElement():GetParentElement():GetParentElement():SetContext(row:GetField("itemString")):SetPath("itemDetail", true)
end
