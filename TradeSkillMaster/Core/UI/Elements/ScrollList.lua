-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- ScrollList UI Element Class.
-- A scroll list is an abstract scrollable element with a list of rows. It is a subclass of the @{ScrollFrame} class.
-- @classmod ScrollList

local _, TSM = ...
local ScrollList = TSMAPI_FOUR.Class.DefineClass("ScrollList", TSM.UI.ScrollFrame, "ABSTRACT")
TSM.UI.ScrollList = ScrollList



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ScrollList.__init(self)
	self.__super:__init()
	self._rows = {}
	self._data = {}
end

function ScrollList.Acquire(self)
	self:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "topSpacer")
		:SetStyle("height", 0)
	)
	self:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "bottomSpacer")
		:SetStyle("height", 0)
	)
	self.__super:Acquire()
end

function ScrollList.Release(self)
	wipe(self._rows)
	wipe(self._data)
	self.__super:Release()
end

function ScrollList.Draw(self)
	self:_DrawRows()
	self.__super:Draw()
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ScrollList._VisibleDataIterator(self)
	local visibleData = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, data in ipairs(self._data) do
		if not self:_IsDataHidden(data) then
			tinsert(visibleData, data)
		end
	end
	return TSMAPI_FOUR.Util.TempTableIterator(visibleData)
end

function ScrollList._GetNumVisibleData(self)
	local numData = 0
	for _ in self:_VisibleDataIterator() do
		numData = numData + 1
	end
	return numData
end

function ScrollList._IsDataHidden(self, data)
	return false
end

function ScrollList._CreateRow(self)
	local index = #self._rows + 1
	return TSMAPI_FOUR.UI.NewElement("Frame", self._id.."_Row"..index)
end

function ScrollList._SetRowHitRectInsets(self, row, top, bottom)
	row:SetHitRectInsets(0, 0, top, bottom)
end

function ScrollList._GetVisibleRowRange(self)
	local visibleHeight = self:_GetDimension("HEIGHT")
	local rowHeight = self:_GetStyle("rowHeight")
	local numData = self:_GetNumVisibleData()
	local offset = self._scrollbar:GetValue()
	local numVisibleRows, firstVisibleRow = 0, nil
	for i = 1, numData do
		if i * rowHeight > offset and (i - 1) * rowHeight < (offset + visibleHeight) then
			numVisibleRows = numVisibleRows + 1
			firstVisibleRow = firstVisibleRow or i
		end
	end
	return firstVisibleRow, numVisibleRows
end

function ScrollList._DrawRows(self)
	local rowHeight = self:_GetStyle("rowHeight")
	local firstVisibleRow, numVisibleRows = self:_GetVisibleRowRange()

	if numVisibleRows > 0 then
		local numData = self:_GetNumVisibleData()
		local topSpacerHeight = (firstVisibleRow - 1) * rowHeight
		self:GetElement("topSpacer"):SetStyle("height", topSpacerHeight)
		self:GetElement("bottomSpacer"):SetStyle("height", (numData - numVisibleRows) * rowHeight - topSpacerHeight)
	else
		self:GetElement("topSpacer"):SetStyle("height", 0)
		self:GetElement("bottomSpacer"):SetStyle("height", 0)
	end

	-- Create new rows if necessary
	while #self._rows < numVisibleRows do
		local row = self:_CreateRow()
		self:AddChildBeforeById("bottomSpacer", row)
		tinsert(self._rows, row)
	end

	-- Show only the rows we need, clear the context, and set the height
	local scrollBarValue = self._scrollbar:GetValue()
	local visibleHeight = self:_GetDimension("HEIGHT")
	for i, row in ipairs(self._rows) do
		local topInset, bottomInset = 0, 0
		if numVisibleRows > 0 and i == 1 then
			-- this is the first visible row so might have an inset at the top
			topInset = max(scrollBarValue % rowHeight, 0)
		end
		if numVisibleRows > 0 and i == numVisibleRows then
			-- this is the last visible row so might have an inset at the bottom
			bottomInset = max((numVisibleRows + firstVisibleRow - 1) * rowHeight - (scrollBarValue + visibleHeight), 0)
		end
		row:SetContext(nil)
		row:SetStyle("height", rowHeight)
		if i > numVisibleRows then
			row:Hide()
		else
			self:_SetRowHitRectInsets(row, topInset, bottomInset)
			row:Show()
		end
	end

	-- Populate the rows with the correct content
	local dataRowsDrawn = 0
	local rowIndex = 1
	for i, data in self:_VisibleDataIterator() do
		if dataRowsDrawn < numVisibleRows and i >= firstVisibleRow then
			local row = self._rows[rowIndex]
			row:SetContext(data)
			self:_DrawRow(row, i)
			dataRowsDrawn = dataRowsDrawn + 1
			rowIndex = rowIndex + 1
		end
	end
end

function ScrollList._DrawRow(self, row, dataIndex)
	row:SetStyle("background", dataIndex % 2 == 1 and self:_GetStyle("altBackground") or nil)
end

function ScrollList._OnScrollValueChanged(self, value, noDraw)
	self.__super:_OnScrollValueChanged(value, noDraw)
	if not noDraw then
		self:Draw()
	end
end
