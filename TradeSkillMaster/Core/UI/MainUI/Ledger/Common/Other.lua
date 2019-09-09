-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Other = TSM.MainUI.Ledger.Common:NewPackage("Other")
local L = TSM.L
local SECONDS_PER_DAY = 24 * 60 * 60
local private = { query = nil, characters = {}, characterFilter = ALL, typeFilter = "All", recordType = nil, timeFrameFilter = 30 * SECONDS_PER_DAY }
local TIME_LIST = { ALL, L["Last 3 Days"], L["Last 7 Days"], L["Last 14 Days"], L["Last 30 Days"], L["Last 60 Days"] }
local TIME_KEYS = { 0, 3 * SECONDS_PER_DAY, 7 * SECONDS_PER_DAY, 14 * SECONDS_PER_DAY, 30 * SECONDS_PER_DAY, 60 * SECONDS_PER_DAY }
local TYPE_LIST = {
	expense = { ALL, L["Money Transfer"], L["Postage"], L["Repair Bill"] },
	income = { ALL, L["Money Transfer"], L["Garrison"] },
}
local TYPE_KEYS = {
	expense = { "All", "Money Transfer", "Postage", "Repair Bill" },
	income = { "All", "Money Transfer", "Garrison" },
}
local TYPE_STR_LOOKUP = {}
do
	-- populate lookup table
	assert(#TYPE_LIST.expense == #TYPE_KEYS.expense)
	for i = 1, #TYPE_LIST.expense do
		TYPE_STR_LOOKUP[TYPE_KEYS.expense[i]] = TYPE_LIST.expense[i]
	end
	assert(#TYPE_LIST.income == #TYPE_KEYS.income)
	for i = 1, #TYPE_LIST.income do
		TYPE_STR_LOOKUP[TYPE_KEYS.income[i]] = TYPE_LIST.income[i]
	end
end



-- ============================================================================
-- Module Functions
-- ============================================================================

function Other.OnInitialize()
	TSM.MainUI.Ledger.Expenses.RegisterPage(OTHER, private.DrawOtherExpensesPage)
	TSM.MainUI.Ledger.Revenue.RegisterPage(OTHER, private.DrawOtherRevenuePage)
end



-- ============================================================================
-- Other UIs
-- ============================================================================

function private.DrawOtherExpensesPage()
	TSM.UI.AnalyticsRecordPathChange("main", "ledger", "expenses", "other")
	return private.DrawOtherPage("expense")
end

function private.DrawOtherRevenuePage()
	TSM.UI.AnalyticsRecordPathChange("main", "ledger", "revenue", "other")
	return private.DrawOtherPage("income")
end

function private.DrawOtherPage(recordType)
	wipe(private.characters)
	tinsert(private.characters, ALL)
	for _, character in TSM.Accounting.Money.CharacterIterator(recordType) do
		tinsert(private.characters, character)
	end

	if not private.query then
		private.query = TSM.Accounting.Money.CreateQuery()
			:OrderBy("time", false)
	end
	private.recordType = recordType
	private.UpdateQuery()

	return TSMAPI_FOUR.UI.NewElement("Frame", "content")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "labels")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 14)
			:SetStyle("padding.left", 8)
			:SetStyle("padding.right", 8)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "type")
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 10)
				:SetText(strupper(TYPE))
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "character")
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 10)
				:SetText(L["CHARACTER"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "time")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 10)
				:SetText(L["TIME FRAME"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "dropdowns")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin.top", 4)
			:SetStyle("margin.bottom", 24)
			:SetStyle("padding.left", 8)
			:SetStyle("padding.right", 8)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "type")
				:SetStyle("margin.right", 16)
				:SetItems(TYPE_LIST[recordType], TYPE_KEYS[recordType])
				:SetSelectedItemByKey(private.typeFilter)
				:SetScript("OnSelectionChanged", private.TypeDropdownOnSelectionChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "character")
				:SetStyle("margin.right", 16)
				:SetItems(private.characters)
				:SetSelectedItem(private.characterFilter)
				:SetScript("OnSelectionChanged", private.CharacterDropdownOnSelectionChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "time")
				:SetItems(TIME_LIST, TIME_KEYS)
				:SetSelectedItemByKey(private.timeFrameFilter)
				:SetScript("OnSelectionChanged", private.TimeDropdownOnSelectionChanged)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
			:SetStyle("color", "#9d9d9d")
			:SetStyle("height", 1)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "table")
			:SetStyle("headerBackground", "#404040")
			:SetStyle("headerFont", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("headerFontHeight", 14)
			:GetScrollingTableInfo()
				:NewColumn("type")
					:SetTitles(L["Type"])
					:SetFont(TSM.UI.Fonts.FRIZQT)
					:SetFontHeight(12)
					:SetJustifyH("LEFT")
					:SetTextInfo("type", private.TableGetTypeText)
					:SetSortInfo("type")
					:Commit()
				:NewColumn("character")
					:SetTitles(L["Character"])
					:SetWidth(110)
					:SetFont(TSM.UI.Fonts.FRIZQT)
					:SetFontHeight(12)
					:SetJustifyH("LEFT")
					:SetTextInfo("player")
					:SetSortInfo("player")
					:Commit()
				:NewColumn("otherCharacter")
					:SetTitles(L["Other Character"])
					:SetFont(TSM.UI.Fonts.FRIZQT)
					:SetWidth(160)
					:SetFontHeight(12)
					:SetJustifyH("LEFT")
					:SetTextInfo("otherPlayer")
					:SetSortInfo("otherPlayer")
					:Commit()
				:NewColumn("amount")
					:SetTitles(L["Amount"])
					:SetWidth(120)
					:SetFont(TSM.UI.Fonts.FRIZQT)
					:SetFontHeight(12)
					:SetJustifyH("RIGHT")
					:SetTextInfo("amount", TSM.Money.ToString)
					:SetSortInfo("amount")
					:Commit()
				:NewColumn("time")
					:SetTitles(L["Time Frame"])
					:SetWidth(120)
					:SetFont(TSM.UI.Fonts.FRIZQT)
					:SetFontHeight(12)
					:SetJustifyH("LEFT")
					:SetTextInfo("time", private.TableGetTimeText)
					:SetSortInfo("time")
					:Commit()
				:Commit()
			:SetQuery(private.query)
			:SetSelectionDisabled(true)
		)
end



-- ============================================================================
-- Scrolling Table Helper Functions
-- ============================================================================

function private.TableGetTypeText(typeValue)
	return TYPE_STR_LOOKUP[typeValue]
end

function private.TableGetTimeText(timevalue)
	return SecondsToTime(time() - timevalue)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.DropdownChangedCommon(dropdown)
	private.UpdateQuery()
	dropdown:GetElement("__parent.__parent.table"):UpdateData(true)
end

function private.TypeDropdownOnSelectionChanged(dropdown)
	private.typeFilter = dropdown:GetSelectedItemKey()
	private.DropdownChangedCommon(dropdown)
end

function private.CharacterDropdownOnSelectionChanged(dropdown)
	private.characterFilter = dropdown:GetSelectedItem()
	private.DropdownChangedCommon(dropdown)
end

function private.TimeDropdownOnSelectionChanged(dropdown)
	private.timeFrameFilter = dropdown:GetSelectedItemKey()
	private.DropdownChangedCommon(dropdown)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.UpdateQuery()
	private.query:ResetFilters()
		:Equal("recordType", private.recordType)
	if private.typeFilter ~= "All" then
		private.query:Equal("type", private.typeFilter)
	end
	if private.characterFilter ~= ALL then
		private.query:Equal("player", private.characterFilter)
	end
	if private.timeFrameFilter ~= 0 then
		private.query:GreaterThan("time", time() - private.timeFrameFilter)
	end
end
