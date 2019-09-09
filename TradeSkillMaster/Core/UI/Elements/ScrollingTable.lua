-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Scrolling Table UI Element Class.
-- A scrolling table contains a scrollable list of rows with a fixed set of columns. It is a subclass of the @{Element}
-- class.
-- @classmod ScrollingTable

local _, TSM = ...
local ScrollingTable = TSMAPI_FOUR.Class.DefineClass("ScrollingTable", TSM.UI.Element, "ABSTRACT")
TSM.UI.ScrollingTable = ScrollingTable
local private = {
	rowPool = TSMAPI_FOUR.ObjectPool.New("TABLE_ROWS", TSM.UI.Util.TableRow, 1),
	frameScrollingTableLookup = {},
}
local MOUSE_WHEEL_SCROLL_AMOUNT = 60
local HEADER_HEIGHT = 22
local HEADER_LINE_HEIGHT = 2



-- ============================================================================
-- Meta Class Methods
-- ============================================================================

function ScrollingTable.__init(self)
	local frame = CreateFrame("Frame", nil, nil, nil)

	self.__super:__init(frame)

	frame.backgroundTexture = frame:CreateTexture(nil, "BACKGROUND")
	frame.backgroundTexture:SetAllPoints()

	self._line = frame:CreateTexture(nil, "ARTWORK")
	self._line:SetPoint("TOPLEFT", 0, -HEADER_HEIGHT)
	self._line:SetPoint("TOPRIGHT", 0, -HEADER_HEIGHT)
	self._line:SetHeight(HEADER_LINE_HEIGHT)
	self._line:SetColorTexture(TSM.UI.HexToRGBA("#585858"))

	self._scrollFrame = CreateFrame("ScrollFrame", nil, frame, nil)
	self._scrollFrame:SetPoint("TOPLEFT", 0, -HEADER_HEIGHT - HEADER_LINE_HEIGHT)
	self._scrollFrame:SetPoint("BOTTOMRIGHT")

	self._scrollFrame:EnableMouseWheel(true)
	self._scrollFrame:SetScript("OnUpdate", private.FrameOnUpdate)
	self._scrollFrame:SetScript("OnMouseWheel", private.FrameOnMouseWheel)
	private.frameScrollingTableLookup[self._scrollFrame] = self

	self._scrollbar = TSM.UI.CreateScrollbar(self._scrollFrame)

	self._content = CreateFrame("Frame", nil, self._scrollFrame)
	self._content:SetPoint("TOPLEFT")
	self._content:SetPoint("TOPRIGHT")
	self._scrollFrame:SetScrollChild(self._content)

	self._rows = {}
	self._data = {}
	self._scrollValue = 0
	self._onSelectionChangedHandler = nil
	self._onRowClickHandler = nil
	self._selection = nil
	self._selectionDisabled = nil
	self._selectionValidator = nil
	self._tableInfo = self:_CreateScrollingTableInfo()
	self._header = nil
	self._dataTranslationFunc = nil
end

function ScrollingTable.Acquire(self)
	self._tableInfo:_Acquire(self)
	self._scrollValue = 0
	self._scrollbar:SetScript("OnValueChanged", private.OnScrollbarValueChangedNoDraw)
	self._scrollbar:SetMinMaxValues(0, self:_GetMaxScroll())
	-- don't want to cause this element to be drawn for this initial scrollbar change
	self._scrollbar:SetValue(0)
	self._scrollbar:SetScript("OnValueChanged", private.OnScrollbarValueChanged)

	self._scrollbar:ClearAllPoints()
	self._scrollbar:SetWidth(self:_GetStyle("scrollbarWidth"))
	self._scrollbar:SetPoint("TOPRIGHT", -self:_GetStyle("scrollbarMargin"), -self:_GetStyle("scrollbarMargin"))
	self._scrollbar:SetPoint("BOTTOMRIGHT", -self:_GetStyle("scrollbarMargin"), self:_GetStyle("scrollbarMargin"))
	self._scrollbar.thumb:SetWidth(self:_GetStyle("scrollbarThumbWidth"))
	self._scrollbar.thumb:SetColorTexture(TSM.UI.HexToRGBA(self:_GetStyle("scrollbarThumbBackground")))

	self.__super:Acquire()
end

function ScrollingTable.Release(self)
	if self._header then
		self._header:Release()
		private.rowPool:Recycle(self._header)
		self._header = nil
	end
	for _, row in ipairs(self._rows) do
		row:Release()
		private.rowPool:Recycle(row)
	end
	wipe(self._rows)
	self._tableInfo:_Release()
	self._onSelectionChangedHandler = nil
	self._onRowClickHandler = nil
	self._selection = nil
	self._selectionDisabled = nil
	self._selectionValidator = nil
	self._dataTranslationFunc = nil
	wipe(self._data)
	self.__super:Release()
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

--- Forces an update of the data shown within the table.
-- @tparam ScrollingTable self The scrolling table object
-- @tparam[opt=false] bool redraw Whether or not to redraw the scrolling table
function ScrollingTable.UpdateData(self, redraw)
	self:_UpdateData()
	if redraw then
		self:Draw()
	end
	return self
end

--- Gets the @{ScrollingTableInfo} object.
-- @tparam ScrollingTable self The scrolling table object
-- @treturn ScrollingTableInfo The scrolling table info object
function ScrollingTable.GetScrollingTableInfo(self)
	return self._tableInfo
end

--- Commits the scrolling table info.
-- This should be called once the scrolling table info is completely set (retrieved via @{ScrollingTable.GetScrollingTableInfo}).
-- @tparam ScrollingTable self The scrolling table object
-- @treturn ScrollingTable The scrolling table object
function ScrollingTable.CommitTableInfo(self)
	if self._header then
		self._header:Release()
		private.rowPool:Recycle(self._header)
		self._header = nil
	end
	self._header = self:_GetTableRow(true)
	self._header:SetBackgroundColor(self:_GetStyle("headerBackground"))
	self._header:SetHeight(HEADER_HEIGHT)
	return self
end

--- Registers a script handler.
-- @tparam ScrollingTable self The scrolling table object
-- @tparam string script The script to register for (supported scripts: `OnSelectionChanged`, `OnRowClick`)
-- @tparam function handler The script handler which will be called with the scrolling table object followed by any
-- arguments to the script
-- @treturn ScrollingTable The scrolling table object
function ScrollingTable.SetScript(self, script, handler)
	if script == "OnSelectionChanged" then
		self._onSelectionChangedHandler = handler
	elseif script == "OnRowClick" then
		self._onRowClickHandler = handler
	else
		error("Unknown ScrollingTable script: "..tostring(script))
	end
	return self
end

--- Sets the selected row.
-- @tparam ScrollingTable self The scrolling table object
-- @param selection The selected row or nil to clear the selection
-- @treturn ScrollingTable The scrolling table object
function ScrollingTable.SetSelection(self, selection)
	if selection == self._selection then
		return self
	elseif selection and self._selectionValidator and not self:_selectionValidator(selection) then
		return self
	end
	local index = nil
	if selection then
		index = TSMAPI_FOUR.Util.TableKeyByValue(self._data, selection)
		assert(index)
	end
	self._selection = selection
	if selection then
		-- set the scroll so that the selection is visible if necessary
		local rowHeight = self:_GetStyle("rowHeight")
		local firstVisibleIndex = ceil(self._scrollValue / rowHeight) + 1
		local lastVisibleIndex = floor((self._scrollValue + self:_GetDimension("HEIGHT")) / rowHeight)
		if lastVisibleIndex > firstVisibleIndex and (index < firstVisibleIndex or index > lastVisibleIndex) then
			self:_OnScrollValueChanged(min((index - 1) * rowHeight, self:_GetMaxScroll()))
		end
	end
	for _, row in ipairs(self._rows) do
		if not row:IsMouseOver() and row:IsVisible() and row:GetData() ~= selection then
			row:SetHighlightVisible(false)
		elseif row:IsVisible() and row:GetData() == selection then
			row:SetHighlightVisible(true)
		end
	end
	if self._onSelectionChangedHandler then
		self:_onSelectionChangedHandler()
	end
	return self
end

--- Gets the currently selected row.
-- @tparam ScrollingTable self The scrolling table object
-- @return The selected row or nil if there's nothing selected
function ScrollingTable.GetSelection(self)
	return self._selection
end

--- Sets a selection validator function.
-- @tparam ScrollingTable self The scrolling table object
-- @tparam function validator A function which gets called with the scrolling table object and a row to validate
-- whether or not it's selectable (returns true if it is, false otherwise)
-- @treturn ScrollingTable The scrolling table object
function ScrollingTable.SetSelectionValidator(self, validator)
	self._selectionValidator = validator
	return self
end

--- Sets whether or not selection is disabled.
-- @tparam ScrollingTable self The scrolling table object
-- @tparam boolean disabled Whether or not to disable selection
-- @treturn ScrollingTable The scrolling table object
function ScrollingTable.SetSelectionDisabled(self, disabled)
	self._selectionDisabled = disabled
	return self
end

function ScrollingTable.Draw(self)
	self.__super:Draw()
	self:_ApplyFrameBackgroundTexture()

	local rowHeight = self:_GetStyle("rowHeight")
	local totalHeight = #self._data * rowHeight
	local visibleHeight = self._scrollFrame:GetHeight()
	local numVisibleRows = ceil(visibleHeight / rowHeight)
	local scrollOffset = min(self._scrollValue, self:_GetMaxScroll())
	local dataOffset = floor(scrollOffset / rowHeight)

	self._scrollbar.thumb:SetHeight(min(visibleHeight / 2, self:_GetStyle("scrollbarThumbHeight")))
	self._scrollbar:SetMinMaxValues(0, self:_GetMaxScroll())
	self._scrollbar:SetValue(scrollOffset)
	self._content:SetWidth(self._scrollFrame:GetWidth())
	self._content:SetHeight(numVisibleRows * rowHeight)

	self._line:SetColorTexture(TSM.UI.HexToRGBA(self:_GetStyle("lineColor")))

	if self:_GetStyle("hideHeader") then
		self._line:Hide()
		self._header:SetHeight(0)
		self._header:SetBackgroundColor("#00000000")
		self._scrollFrame:SetPoint("TOPLEFT", 0, 0)
	else
		self._line:Show()
		self._scrollFrame:SetPoint("TOPLEFT", 0, -HEADER_HEIGHT - HEADER_LINE_HEIGHT)
		self._header:SetBackgroundColor(self:_GetStyle("headerBackground"))
		self._header:SetHeight(HEADER_HEIGHT)
	end

	if TSMAPI_FOUR.Util.Round(scrollOffset + visibleHeight) == totalHeight then
		-- we are at the bottom
		self._scrollFrame:SetVerticalScroll(numVisibleRows * rowHeight - visibleHeight)
	else
		self._scrollFrame:SetVerticalScroll(0)
	end

	while #self._rows < numVisibleRows do
		local row = self:_GetTableRow(false)
		row._frame:SetPoint("TOPLEFT", 0, -rowHeight * #self._rows)
		row._frame:SetPoint("TOPRIGHT", 0, -rowHeight * #self._rows)
		tinsert(self._rows, row)
	end

	local altBackground = self:_GetStyle("altBackground")
	for i, row in ipairs(self._rows) do
		local dataIndex = i + dataOffset
		local data = self._data[dataIndex]
		if i > numVisibleRows or not data then
			row:SetVisible(false)
			row:ClearData()
		else
			row:SetVisible(true)
			self:_SetRowData(row, data)
			row:SetBackgroundColor(dataIndex % 2 == 1 and "#00000000" or altBackground)
			row:SetHeight(rowHeight)
		end
	end

	self._header:SetHeaderData()
end



-- ============================================================================
-- ScrollingTable - Private Class Methods
-- ============================================================================

function ScrollingTable._CreateScrollingTableInfo(self)
	error("Must be implemented by the child class")
end

function ScrollingTable._GetTableRow(self, isHeader)
	local row = private.rowPool:Get()
	row:Acquire(self, isHeader)
	return row
end

function ScrollingTable._SetRowData(self, row, data)
	if data == self._selection then
		row:SetHighlightVisible(true)
	elseif not row:IsMouseOver() then
		row:SetHighlightVisible(false)
	end
	row:SetData(data)
end

function ScrollingTable._OnScrollValueChanged(self, value, noDraw)
	self._scrollValue = value
	if not noDraw then
		self:Draw()
	end
end

function ScrollingTable._GetMaxScroll(self)
	return max(#self._data * self:_GetStyle("rowHeight") - self._scrollFrame:GetHeight(), 0)
end

function ScrollingTable._UpdateData(self)
	error("Must be implemented by the child class")
end

function ScrollingTable._ToggleSort(self, id)
	error("Must be implemented by the child class")
end

function ScrollingTable._HandleRowClick(self, data, mouseButton)
	if self._onRowClickHandler then
		self:_onRowClickHandler(data, mouseButton)
	end
end



-- ============================================================================
-- ScrollingTable - Local Script Handlers
-- ============================================================================

function private.OnScrollbarValueChanged(scrollbar, value)
	local self = private.frameScrollingTableLookup[scrollbar:GetParent()]
	value = max(min(value, self:_GetMaxScroll()), 0)
	self:_OnScrollValueChanged(value)
end

function private.OnScrollbarValueChangedNoDraw(scrollbar, value)
	local self = private.frameScrollingTableLookup[scrollbar:GetParent()]
	value = max(min(value, self:_GetMaxScroll()), 0)
	self:_OnScrollValueChanged(value, true)
end

function private.FrameOnUpdate(frame)
	local self = private.frameScrollingTableLookup[frame]
	if (frame:IsMouseOver() and self:_GetMaxScroll() > 0) or self._scrollbar.dragging then
		self._scrollbar:Show()
	else
		self._scrollbar:Hide()
	end
end

function private.FrameOnMouseWheel(frame, direction)
	local self = private.frameScrollingTableLookup[frame]
	local scrollAmount = MOUSE_WHEEL_SCROLL_AMOUNT
	self._scrollbar:SetValue(self._scrollbar:GetValue() + -1 * direction * scrollAmount)
end
