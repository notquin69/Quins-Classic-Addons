-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- ProfessionScrollingTable UI Element Class.
-- This is used to display the crafts within the currently-selected profession in the CraftingUI. It is a subclass of
-- the @{ScrollingTable} class.
-- @classmod ProfessionScrollingTable

local _, TSM = ...
local L = TSM.L
local ProfessionScrollingTable = TSMAPI_FOUR.Class.DefineClass("ProfessionScrollingTable", TSM.UI.ScrollingTable)
TSM.UI.ProfessionScrollingTable = ProfessionScrollingTable
local private = {
	rowFrameLookup = {},
	queryProfessionScrollingTableLookup = {},
	categoryInfoCache = {
		parent = {},
		numIndents = {},
		name = {},
	},
}
local PREFIX_ICON_SIZE = 14
local PREFIX_ICON_SPACING_RIGHT = 2
local PREFIX_ICON_SPACING_LEFT = 2
local INDENT_SPACING = 16
local RECIPE_COLORS = {
	optimal = "|cffff8040",
	medium = "|cffffff00",
	easy = "|cff40c040",
	trivial = "|cff808080",
	header = "|cffffd100",
	subheader = "|cffffd100",
	nodifficulty = "|cfff5f5f5",
}



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ProfessionScrollingTable.__init(self)
	self.__super:__init()
	self._query = nil
	self._collapsed = {}
	self._isSpellId = {}
end

function ProfessionScrollingTable.Acquire(self)
	self.__super:Acquire()
	self:GetScrollingTableInfo()
		:NewColumn("name")
			:SetTitles(NAME)
			:SetFont(TSM.UI.Fonts.FRIZQT)
			:SetFontHeight(12)
			:SetJustifyH("LEFT")
			:SetTextFunction(private.GetNameCellText)
			:Commit()
		:NewColumn("qty")
			:SetTitles(L["Craft"])
			:SetWidth(54)
			:SetFont(TSM.UI.Fonts.RobotoRegular)
			:SetFontHeight(12)
			:SetJustifyH("CENTER")
			:SetTextFunction(private.GetQtyCellText)
			:Commit()
		:NewColumn("rank")
			:SetTitles(RANK)
			:SetWidth(40)
			:SetFont(TSM.UI.Fonts.MontserratBold)
			:SetFontHeight(12)
			:SetJustifyH("CENTER")
			:Commit()
		:NewColumn("profit")
			:SetTitles(L["Profit"], L["Crafting Cost"], L["Item Value"])
			:SetWidth(115)
			:SetFont(TSM.UI.Fonts.RobotoMedium)
			:SetFontHeight(12)
			:SetJustifyH("RIGHT")
			:SetTextFunction(private.GetProfitCellText)
			:Commit()
		:NewColumn("saleRate")
			:SetTitleIcon("iconPack.14x14/SaleRate")
			:SetWidth(30)
			:SetFont(TSM.UI.Fonts.RobotoMedium)
			:SetFontHeight(12)
			:SetJustifyH("RIGHT")
			:SetTextFunction(private.GetSaleRateCellText)
			:Commit()
		:Commit()
end

function ProfessionScrollingTable.Release(self)
	if self._query then
		self._query:SetUpdateCallback()
		private.queryProfessionScrollingTableLookup[self._query] = nil
		self._query = nil
	end
	wipe(self._collapsed)
	wipe(self._isSpellId)
	self.__super:Release()
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

--- Sets the @{DatabaseQuery} source for this table.
-- This query is used to populate the entries in the profession scrolling table.
-- @tparam ProfessionScrollingTable self The profession scrolling table object
-- @tparam DatabaseQuery query The query object
-- @tparam[opt=false] bool redraw Whether or not to redraw the scrolling table
-- @treturn ProfessionScrollingTable The profession scrolling table object
function ProfessionScrollingTable.SetQuery(self, query, redraw)
	if query == self._query and not redraw then
		return self
	end
	if self._query then
		self._query:SetUpdateCallback()
		private.queryProfessionScrollingTableLookup[self._query] = nil
	end
	self._query = query
	private.queryProfessionScrollingTableLookup[self._query] = self
	self._query:SetUpdateCallback(private.QueryUpdateCallback)

	self:_UpdateData()
	if redraw then
		self:Draw()
	end

	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ProfessionScrollingTable._CreateScrollingTableInfo(self)
	return TSM.UI.Util.ScrollingTableInfo()
end

function ProfessionScrollingTable._ToggleCollapsed(self, data)
	self._collapsed[data] = not self._collapsed[data] or nil
end

function ProfessionScrollingTable._GetTableRow(self, isHeader)
	local row = self.__super:_GetTableRow(isHeader)
	if not isHeader then
		for _, tooltipFrame in pairs(row._buttons) do
			tooltipFrame:SetScript("OnClick", private.TooltipFrameOnClick)
		end
		row._frame:SetScript("OnClick", private.RowOnClick)
		private.rowFrameLookup[row._frame] = row

		-- add the prefix icon texture before the first col
		local firstText = row._texts[self._tableInfo:_GetCols()[1]:_GetId()]
		local prefixIcon = row:_GetTexture()
		prefixIcon:SetWidth(PREFIX_ICON_SIZE)
		prefixIcon:SetHeight(PREFIX_ICON_SIZE)
		row._icons.prefixIcon = prefixIcon

		local prefixIconBtn = row:_GetButton()
		prefixIconBtn:SetAllPoints(prefixIcon)
		prefixIconBtn:SetScript("OnClick", private.PrefixIconOnClick)
		prefixIconBtn:SetScript("OnEnter", private.PrefixIconOnEnter)
		prefixIconBtn:SetScript("OnLeave", private.PrefixIconOnLeave)
		row._buttons.prefixIconBtn = prefixIconBtn

		firstText:ClearAllPoints()
		firstText:SetPoint("LEFT", prefixIcon, "RIGHT", PREFIX_ICON_SPACING_RIGHT, 0)
		firstText:SetPoint("RIGHT", row._texts[self._tableInfo:_GetCols()[2]:_GetId()], "LEFT", -self:_GetStyle("colSpacing"), 0)

		-- add star textures
		local rankText = row._texts.rank
		local star1 = row:_GetTexture()
		TSM.UI.TexturePacks.SetSize(star1, "iconPack.12x12/Star/Filled")
		star1:SetPoint("LEFT", rankText)
		row._icons.star1 = star1
		local star2 = row:_GetTexture()
		TSM.UI.TexturePacks.SetSize(star2, "iconPack.12x12/Star/Filled")
		star2:SetPoint("CENTER", rankText)
		row._icons.star2 = star2
		local star3 = row:_GetTexture()
		TSM.UI.TexturePacks.SetSize(star3, "iconPack.12x12/Star/Filled")
		star3:SetPoint("RIGHT", rankText)
		row._icons.star3 = star3
	end
	return row
end

function ProfessionScrollingTable._UpdateData(self)
	local currentCategoryPath = TSMAPI_FOUR.Util.AcquireTempTable()
	local foundSelection = false
	-- populate the ScrollList data
	wipe(self._data)
	wipe(self._isSpellId)
	for _, spellId, categoryId in self._query:Iterator() do
		if categoryId ~= currentCategoryPath[#currentCategoryPath] then
			-- this is a new category
			local newCategoryPath = TSMAPI_FOUR.Util.AcquireTempTable()
			local currentCategoryId = categoryId
			while currentCategoryId do
				tinsert(newCategoryPath, 1, currentCategoryId)
				currentCategoryId = private.CategoryGetParentCategoryId(currentCategoryId)
			end
			-- create new category headers
			for i = 1, #newCategoryPath do
				local newCategoryId = newCategoryPath[i]
				if currentCategoryPath[i] ~= newCategoryId then
					if not self:_IsCategoryHidden(newCategoryId) then
						tinsert(self._data, newCategoryId)
					end
				end
			end
			TSMAPI_FOUR.Util.ReleaseTempTable(currentCategoryPath)
			currentCategoryPath = newCategoryPath
		end
		foundSelection = foundSelection or spellId == self:GetSelection()
		if not self._collapsed[categoryId] and not self:_IsCategoryHidden(categoryId) then
			tinsert(self._data, spellId)
			self._isSpellId[spellId] = true
		end
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(currentCategoryPath)
	if not foundSelection then
		self:SetSelection()
	end
end

function ProfessionScrollingTable._IsCategoryHidden(self, categoryId)
	local parent = private.CategoryGetParentCategoryId(categoryId)
	while parent do
		if self._collapsed[parent] then
			return true
		end
		parent = private.CategoryGetParentCategoryId(parent)
	end
	return false
end

function ProfessionScrollingTable._SetRowData(self, row, data)
	local numSkillUps = self._isSpellId[data] and TSM.Crafting.ProfessionScanner.GetNumSkillupsBySpellId(data) or nil
	local prefixIcon = row._icons.prefixIcon
	if not self._isSpellId[data] then
		prefixIcon:SetPoint("LEFT", PREFIX_ICON_SPACING_LEFT + private.CategoryGetNumIndents(data) * INDENT_SPACING, 0)
		TSM.UI.TexturePacks.SetTexture(prefixIcon, self._collapsed[data] and "iconPack.14x14/Carot/Collapsed" or "iconPack.14x14/Carot/Expanded")
		prefixIcon:SetVertexColor(1, 1, 1, 1)
		prefixIcon:Show()
	elseif numSkillUps > 1 then
		prefixIcon:SetPoint("LEFT", PREFIX_ICON_SPACING_LEFT + INDENT_SPACING, 0)
		TSM.UI.TexturePacks.SetTexture(prefixIcon, "iconPack.18x18/SkillUp")
		prefixIcon:SetVertexColor(TSM.UI.HexToRGBA("#ff8040"))
		prefixIcon:Show()
	else
		prefixIcon:SetPoint("LEFT", PREFIX_ICON_SPACING_LEFT + INDENT_SPACING, 0)
		prefixIcon:Hide()
	end
	local rank = self._isSpellId[data] and TSM.Crafting.ProfessionScanner.GetRankBySpellId(data) or -1
	if rank == -1 then
		row._icons.star1:Hide()
		row._icons.star2:Hide()
		row._icons.star3:Hide()
	else
		TSM.UI.TexturePacks.SetTexture(row._icons.star1, rank >= 1 and "iconPack.12x12/Star/Filled" or "iconPack.12x12/Star/Unfilled")
		TSM.UI.TexturePacks.SetTexture(row._icons.star2, rank >= 2 and "iconPack.12x12/Star/Filled" or "iconPack.12x12/Star/Unfilled")
		TSM.UI.TexturePacks.SetTexture(row._icons.star3, rank >= 3 and "iconPack.12x12/Star/Filled" or "iconPack.12x12/Star/Unfilled")
		row._icons.star1:Show()
		row._icons.star2:Show()
		row._icons.star3:Show()
	end
	self.__super:_SetRowData(row, data)
end

function ProfessionScrollingTable._ToggleSort(self, id)
	-- do nothing
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.PopulateCategoryInfoCache(categoryId)
	-- numIndents always gets set, so use that to know whether or not this category is already cached
	if not private.categoryInfoCache.numIndents[categoryId] then
		local name, numIndents, parentCategoryId = TSM.Crafting.ProfessionUtil.GetCategoryInfo(categoryId)
		private.categoryInfoCache.name[categoryId] = name
		private.categoryInfoCache.numIndents[categoryId] = numIndents
		private.categoryInfoCache.parent[categoryId] = parentCategoryId
	end
end

function private.CategoryGetParentCategoryId(categoryId)
	private.PopulateCategoryInfoCache(categoryId)
	return private.categoryInfoCache.parent[categoryId]
end

function private.CategoryGetNumIndents(categoryId)
	private.PopulateCategoryInfoCache(categoryId)
	return private.categoryInfoCache.numIndents[categoryId]
end

function private.CategoryGetName(categoryId)
	private.PopulateCategoryInfoCache(categoryId)
	return private.categoryInfoCache.name[categoryId]
end

function private.QueryUpdateCallback(query)
	private.queryProfessionScrollingTableLookup[query]:UpdateData(true)
end

function private.GetNameCellText(self, data)
	if self._isSpellId[data] then
		local name = TSM.Crafting.ProfessionScanner.GetNameBySpellId(data)
		local color = nil
		if TSM.Crafting.ProfessionUtil.IsGuildProfession() then
			color = RECIPE_COLORS.easy
		elseif TSM.Crafting.ProfessionUtil.IsNPCProfession() then
			color = RECIPE_COLORS.nodifficulty
		else
			local difficulty = TSM.Crafting.ProfessionScanner.GetDifficultyBySpellId(data)
			color = RECIPE_COLORS[difficulty]
		end
		return color..name.."|r"
	else
		-- this is a category
		local name = private.CategoryGetName(data)
		if not name then
			-- happens if we're switching to another profession
			return "?"
		end
		if private.CategoryGetNumIndents(data) == 0 then
			return "|cffffd839"..name.."|r"
		else
			return "|cff79a2ff"..name.."|r"
		end
	end
end

function private.GetQtyCellText(self, data)
	if not self._isSpellId[data] then
		return ""
	end
	local num, numAll = TSM.Crafting.ProfessionUtil.GetNumCraftable(data)
	if num == numAll then
		if num > 0 then
			return "|cff2cec0d"..num.."|r"
		end
		return tostring(num)
	else
		if num > 0 then
			return "|cff2cec0d"..num.."-"..numAll.."|r"
		elseif numAll > 0 then
			return "|cfffcf141"..num.."-"..numAll.."|r"
		else
			return num.."-"..numAll
		end
	end
end

function private.GetProfitCellText(self, data, currentTitleIndex)
	if not self._isSpellId[data] then
		return ""
	end
	local craftingCost, craftedItemValue, profit = TSM.Crafting.Cost.GetCostsBySpellId(data)
	local value, color = nil, nil
	if currentTitleIndex == 1 then
		value = profit
		color = value and value >= 0 and "|cff2cec0d" or "|cffd50000"
	elseif currentTitleIndex == 2 then
		value = craftingCost
	else
		value = craftedItemValue
	end

	if value then
		return TSM.Money.ToString(value, color)
	else
		return ""
	end
end

function private.GetSaleRateCellText(self, data)
	return self._isSpellId[data] and TSM.Crafting.Cost.GetSaleRateBySpellId(data) or ""
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.RowOnClick(frame, mouseButton)
	local self = private.rowFrameLookup[frame]
	local scrollingTable = self._scrollingTable
	local data = self:GetData()
	if mouseButton == "LeftButton" then
		if scrollingTable._isSpellId[data] then
			scrollingTable:SetSelection(data)
		else
			scrollingTable:_ToggleCollapsed(data)
		end
		scrollingTable:_UpdateData()
		scrollingTable:Draw()
	end
end

function private.TooltipFrameOnClick(frame, mouseButton)
	private.RowOnClick(frame:GetParent(), mouseButton)
end

function private.PrefixIconOnClick(button, mouseButton)
	private.RowOnClick(button:GetParent(), mouseButton)
end

function private.PrefixIconOnEnter(button)
	local frame = button:GetParent()
	frame:GetScript("OnEnter")(frame, button)
	local self = private.rowFrameLookup[frame]
	local data = self:GetData()
	if self._scrollingTable._isSpellId[data] then
		local numSkillUps = TSM.Crafting.ProfessionScanner.GetNumSkillupsBySpellId(data)
		if numSkillUps and numSkillUps > 1 then
			TSM.UI.ShowTooltip(button, format(SKILLUP_TOOLTIP, numSkillUps))
		end
	end
end

function private.PrefixIconOnLeave(button)
	local frame = button:GetParent()
	frame:GetScript("OnLeave")(frame, button)
	TSM.UI.HideTooltip()
end
