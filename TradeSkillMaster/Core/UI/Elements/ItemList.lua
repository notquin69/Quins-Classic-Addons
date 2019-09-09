-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- ItemList UI Element Class.
-- This element is used for the item lists in the group UI. It is a subclass of the @{FastScrollingList} class.
-- @classmod ItemList

local _, TSM = ...
local ItemList = TSMAPI_FOUR.Class.DefineClass("ItemList", TSM.UI.FastScrollingList)
TSM.UI.ItemList = ItemList
local private = { rowFrameLookup = {} }
local EXPANDER_PADDING_LEFT = 7
local CHECK_PADDING_LEFT = 8
local TEXT_PADDING_RIGHT = 8
local ICON_PADDING_LEFT = 29
local ICON_SIZE = 14
local CHILD_TEXT_PADDING = 48
local HEADER_TEXT_PADDING = 29



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ItemList.__init(self)
	self.__super:__init()

	self._allData = {}
	self._selectedItems = {}
	self._header = {}
	self._headerCollapsed = {}
	self._filterFunc = nil
	self._onSelectionChangedHandler = nil
end

function ItemList.Release(self)
	wipe(self._allData)
	wipe(self._selectedItems)
	wipe(self._header)
	wipe(self._headerCollapsed)
	self._filterFunc = nil
	self._onSelectionChangedHandler = nil
	for _, row in ipairs(self._rows) do
		row._frame:SetScript("OnClick", nil)
		row._frame:SetScript("OnEnter", nil)
		row._frame:SetScript("OnLeave", nil)
		private.rowFrameLookup[row._frame] = nil
	end
	self.__super:Release()
end

--- Sets the items.
-- @tparam ItemList self The item list object
-- @tparam table items Either a list of items or list of tables with a `header` field and sub-list of items
-- @tparam boolean redraw Whether or not to redraw the item list
-- @treturn ItemList The item list object
function ItemList.SetItems(self, items, redraw)
	wipe(self._allData)
	wipe(self._header)
	wipe(self._headerCollapsed)

	for _, item in ipairs(items) do
		if type(item) == "table" then
			assert(item.header)
			tinsert(self._allData, item.header)
			for _, subItem in ipairs(item) do
				tinsert(self._allData, subItem)
				self._header[subItem] = item.header
			end
		else
			tinsert(self._allData, item)
			self._header[item] = ""
		end
	end
	self:_UpdateData()

	wipe(self._selectedItems)
	if self._onSelectionChangedHandler then
		self:_onSelectionChangedHandler(0)
	end

	if redraw then
		self:Draw()
	end

	return self
end

--- Sets a filter function.
-- @tparam ItemList self The item list object
-- @tparam function func A function which is passed an item and returns true if it should be filtered (not shown)
-- @treturn ItemList The item list object
function ItemList.SetFilterFunction(self, func)
	self._filterFunc = func
	self:_UpdateData()
	return self
end

--- Gets whether or not an item is selected.
-- @tparam ItemList self The item list object
-- @tparam string item The item
-- @treturn boolean Whether or not the item is selected
function ItemList.IsItemSelected(self, item)
	return tContains(self._data, item) and self._selectedItems[item]
end

--- Selects all items.
-- @tparam ItemList self The item list object
function ItemList.SelectAll(self)
	local num = 0
	for _, item in ipairs(self._data) do
		if self._header[item] then
			self._selectedItems[item] = true
			num = num + 1
		end
	end
	if self._onSelectionChangedHandler then
		self:_onSelectionChangedHandler(num)
	end
	self:Draw()
end

--- Deselects all items.
-- @tparam ItemList self The item list object
function ItemList.ClearSelection(self)
	wipe(self._selectedItems)
	if self._onSelectionChangedHandler then
		self:_onSelectionChangedHandler(0)
	end
	self:Draw()
end

--- Registers a script handler.
-- @tparam ItemList self The item list object
-- @tparam string script The script to register for (supported scripts: `OnSelectionChanged`)
-- @tparam function handler The script handler which will be called with the item list object followed by any arguments
-- to the script
-- @treturn ItemList The item list object
function ItemList.SetScript(self, script, handler)
	if script == "OnSelectionChanged" then
		self._onSelectionChangedHandler = handler
	else
		error("Unknown ItemList script: "..tostring(script))
	end
	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ItemList._UpdateData(self)
	wipe(self._data)
	for _, data in ipairs(self._allData) do
		if not self:_IsDataHidden(data) then
			tinsert(self._data, data)
		end
	end
end

function ItemList._IsDataHidden(self, data)
	if not self._header[data] then
		return false
	end
	if self._headerCollapsed[self._header[data]] then
		return true
	end
	if self._filterFunc then
		return self._filterFunc(data)
	end
	return false
end

function ItemList._GetListRow(self)
	local row = self.__super:_GetListRow()
	row._frame:SetScript("OnClick", private.RowOnClick)
	row._frame:SetScript("OnEnter", private.RowOnEnter)
	row._frame:SetScript("OnLeave", private.RowOnLeave)
	private.rowFrameLookup[row._frame] = row

	local text = row:_GetFontString()
	text:SetPoint("LEFT", 0, 0)
	text:SetPoint("TOPRIGHT", -TEXT_PADDING_RIGHT, 0)
	text:SetPoint("BOTTOMRIGHT", -TEXT_PADDING_RIGHT, 0)
	text:SetFont(self:_GetStyle("font"), self:_GetStyle("fontHeight"))
	text:SetJustifyH("LEFT")
	text:SetJustifyV("MIDDLE")
	row._texts.text = text

	local icon = row:_GetTexture()
	icon:SetPoint("LEFT", ICON_PADDING_LEFT, 0)
	icon:SetWidth(ICON_SIZE)
	icon:SetHeight(ICON_SIZE)
	row._icons.icon = icon

	local check = row:_GetTexture()
	check:SetPoint("LEFT", CHECK_PADDING_LEFT, 0)
	row._icons.check = check

	local expander = row:_GetTexture()
	expander:SetDrawLayer("ARTWORK", 2)
	expander:SetPoint("LEFT", EXPANDER_PADDING_LEFT, 0)
	row._icons.expander = expander

	return row
end

function ItemList._SetRowData(self, row, data)
	local isHeader = not self._header[data]
	local isCollapsed = isHeader and self._headerCollapsed[data]

	local text = row._texts.text
	text:SetFont(self:_GetStyle(isHeader and "headerFont" or "regularFont"), self:_GetStyle(isHeader and "headerFontHeight" or "regularFontHeight"))
	text:SetPoint("LEFT", isHeader and HEADER_TEXT_PADDING or CHILD_TEXT_PADDING, 0)
	local icon = row._icons.icon
	local expander = row._icons.expander
	local check = row._icons.check

	if isHeader then
		-- count the sub-elements below this header
		local numChildElements = 0
		local foundHeader = false
		for _, item in ipairs(self._allData) do
			if not self._header[item] then
				if item == data then
					foundHeader = true
				elseif foundHeader then
					break
				end
			elseif foundHeader then
				if not self._filterFunc or not self._filterFunc(item) then
					numChildElements = numChildElements + 1
				end
			end
		end
		text:SetText(data.. " |cffffd839(" .. numChildElements .. ")|r")
		icon:Hide()
		check:Hide()
		local texturePack = self:_GetStyle(isCollapsed and "expanderCollapsedBackgroundTexturePack" or "expanderExpandedBackgroundTexturePack")
		TSM.UI.TexturePacks.SetTextureAndSize(expander, texturePack)
		expander:Show()
	else
		text:SetText(TSM.UI.GetColoredItemName(data))
		icon:SetTexture(TSMAPI_FOUR.Item.GetTexture(data))
		icon:Show()
		expander:Hide()
		if not isHeader and self._selectedItems[data] then
			TSM.UI.TexturePacks.SetTextureAndSize(check, self:_GetStyle("checkTexturePack"))
			check:Show()
		else
			check:Hide()
		end
	end

	self.__super:_SetRowData(row, data)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.RowOnClick(frame)
	local self = private.rowFrameLookup[frame]
	local data = self:GetData()
	local scrollingList = self._scrollingList
	if scrollingList._header[data] then
		scrollingList._selectedItems[data] = not scrollingList._selectedItems[data]
	else
		scrollingList._headerCollapsed[data] = not scrollingList._headerCollapsed[data]
	end
	scrollingList:_UpdateData()
	if scrollingList._onSelectionChangedHandler then
		local num = 0
		for _, item in ipairs(scrollingList._data) do
			if scrollingList._selectedItems[item] then
				num = num + 1
			end
		end
		scrollingList:_onSelectionChangedHandler(num)
	end
	scrollingList:Draw()
end

function private.RowOnEnter(frame)
	local self = private.rowFrameLookup[frame]
	self:SetHighlightState("hover")
	local data = self:GetData()
	if self._scrollingList._header[data] then
		TSM.UI.ShowTooltip(frame, data)
	end
end

function private.RowOnLeave(frame)
	local self = private.rowFrameLookup[frame]
	TSM.UI.HideTooltip()
	self:SetHighlightState()
end
