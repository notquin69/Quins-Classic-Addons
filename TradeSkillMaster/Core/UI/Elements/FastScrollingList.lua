-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- FastScrollingList UI Element Class.
-- This is an abstract scrollable list element. It is a subclass of the @{Element} class.
-- @classmod FastScrollingList

local _, TSM = ...
local FastScrollingList = TSMAPI_FOUR.Class.DefineClass("FastScrollingList", TSM.UI.Element, "ABSTRACT")
TSM.UI.FastScrollingList = FastScrollingList
local ListRow = TSMAPI_FOUR.Class.DefineClass("ListRow")
local private = {
	recycledRows = {},
	frameFastScrollingListLookup = {},
	rowFrameLookup = {},
}
local MOUSE_WHEEL_SCROLL_AMOUNT = 60
local SCROLL_TO_DATA_TOTAL_TIME_S = 0.1



-- ============================================================================
-- FastScrollingList - Public Class Methods
-- ============================================================================

function FastScrollingList.__init(self)
	local frame = CreateFrame("Frame", nil, nil, nil)

	self.__super:__init(frame)

	frame.backgroundTexture = frame:CreateTexture(nil, "BACKGROUND")
	frame.backgroundTexture:SetAllPoints()

	self._scrollFrame = CreateFrame("ScrollFrame", nil, frame, nil)
	self._scrollFrame:SetAllPoints()
	self._scrollFrame:EnableMouseWheel(true)
	self._scrollFrame:SetClipsChildren(true)
	self._scrollFrame:SetScript("OnUpdate", private.FrameOnUpdate)
	self._scrollFrame:SetScript("OnMouseWheel", private.FrameOnMouseWheel)
	private.frameFastScrollingListLookup[self._scrollFrame] = self

	self._scrollbar = TSM.UI.CreateScrollbar(self._scrollFrame)

	self._content = CreateFrame("Frame", nil, self._scrollFrame)
	self._content:SetPoint("TOPLEFT")
	self._content:SetPoint("TOPRIGHT")
	self._scrollFrame:SetScrollChild(self._content)

	self._rows = {}
	self._data = {}
	self._scrollValue = 0
	self._targetScrollValue = nil
	self._totalScrollDistance = nil
end

function FastScrollingList.Acquire(self)
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

function FastScrollingList.Release(self)
	self._targetScrollValue = nil
	self._totalScrollDistance = nil
	for _, row in ipairs(self._rows) do
		row:Release()
		tinsert(private.recycledRows, row)
	end
	wipe(self._rows)
	wipe(self._data)
	self.__super:Release()
end

function FastScrollingList.SetScript(self, script, handler)
	error("Unknown FastScrollingList script: "..tostring(script))
	return self
end

function FastScrollingList.Draw(self)
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

	if TSMAPI_FOUR.Util.Round(scrollOffset + visibleHeight) == totalHeight then
		-- we are at the bottom
		self._scrollFrame:SetVerticalScroll(numVisibleRows * rowHeight - visibleHeight)
	else
		self._scrollFrame:SetVerticalScroll(0)
	end

	while #self._rows < numVisibleRows do
		local row = self:_GetListRow()
		if #self._rows == 0 then
			row._frame:SetPoint("TOPLEFT", self._content)
			row._frame:SetPoint("TOPRIGHT", self._content)
		else
			row._frame:SetPoint("TOPLEFT", self._rows[#self._rows]._frame, "BOTTOMLEFT")
			row._frame:SetPoint("TOPRIGHT", self._rows[#self._rows]._frame, "BOTTOMRIGHT")
		end
		tinsert(self._rows, row)
	end

	local altBackground = self:_GetStyle("altBackground")
	for i, row in ipairs(self._rows) do
		local dataIndex = i + dataOffset
		local data = self._data[dataIndex]
		if i > numVisibleRows or not data then
			row:SetVisible(false)
		else
			row:SetVisible(true)
			self:_SetRowData(row, data)
			row:SetBackgroundColor(dataIndex % 2 == 1 and "#00000000" or altBackground)
			row:SetHeight(rowHeight)
		end
	end
end



-- ============================================================================
-- FastScrollingList - Private Class Methods
-- ============================================================================

function FastScrollingList._SetRowData(self, row, data)
	if not row:IsMouseOver() then
		row:SetHighlightState(nil)
	end
	row:SetData(data)
end

function FastScrollingList._GetListRow(self)
	local row = tremove(private.recycledRows)
	if not row then
		row = ListRow()
	end
	row:Acquire(self)
	return row
end

function FastScrollingList._ScrollToData(self, data)
	-- Dont scroll up to root group (happens after deletion etc)
	if self._selectedGroup == TSM.CONST.ROOT_GROUP_PATH then
		return
	end

	local rowHeight = self:_GetStyle("rowHeight")
	local visibleHeight = self._scrollFrame:GetHeight()
	local currentOffset = self._scrollbar:GetValue()
	local dataIndex = TSMAPI_FOUR.Util.TableKeyByValue(self._data, data)
	-- if we are going to scroll up/down, we want to scroll such that the top of the passed row is in the visible area
	-- by at least 1 row height
	local scrollUpOffset = max(rowHeight * (dataIndex - 1) - rowHeight, 0)
	local scrollDownOffset = min(rowHeight * dataIndex + rowHeight - visibleHeight, self:_GetMaxScroll())
	if scrollUpOffset < currentOffset and scrollDownOffset > currentOffset then
		-- it's impossible to scroll to the right place, so do nothing
	elseif scrollUpOffset < currentOffset then
		-- we need to scroll up
		self._targetScrollValue = scrollUpOffset
		self._totalScrollDistance = currentOffset - scrollUpOffset
	elseif scrollDownOffset > currentOffset then
		-- we need to scroll down
		self._targetScrollValue = scrollDownOffset
		self._totalScrollDistance = scrollDownOffset - currentOffset
	else
		-- the data is already in the visible area, so do nothing
	end
end

function FastScrollingList._OnScrollValueChanged(self, value, noDraw)
	self._scrollValue = value
	if not noDraw then
		self:Draw()
		for _, row in ipairs(self._rows) do
			if row._frame:IsVisible() and row._frame:IsMouseOver() and not self._scrollbar:IsMouseOver(4, -4, -6, 10) then
				row._frame:GetScript("OnLeave")(row._frame)
				row._frame:GetScript("OnEnter")(row._frame)
			end
		end
	end
end

function FastScrollingList._GetMaxScroll(self)
	return max(#self._data * self:_GetStyle("rowHeight") - self._scrollFrame:GetHeight(), 0)
end



-- ============================================================================
-- FastScrollingList - Local Script Handlers
-- ============================================================================

function private.OnScrollbarValueChanged(scrollbar, value)
	local self = private.frameFastScrollingListLookup[scrollbar:GetParent()]
	value = max(min(value, self:_GetMaxScroll()), 0)
	self:_OnScrollValueChanged(value)
end

function private.OnScrollbarValueChangedNoDraw(scrollbar, value)
	local self = private.frameFastScrollingListLookup[scrollbar:GetParent()]
	value = max(min(value, self:_GetMaxScroll()), 0)
	self:_OnScrollValueChanged(value, true)
end

function private.FrameOnUpdate(frame, elapsed)
	elapsed = min(elapsed, 0.01)
	local self = private.frameFastScrollingListLookup[frame]

	local scrollValue = self._scrollbar:GetValue()
	if self._targetScrollValue then
		local direction = scrollValue < self._targetScrollValue and 1 or -1
		local newScrollValue = scrollValue + direction * self._totalScrollDistance * elapsed / SCROLL_TO_DATA_TOTAL_TIME_S
		self._scrollbar:SetValue(newScrollValue)
		if direction * newScrollValue >= direction * self._targetScrollValue or newScrollValue <= 0 or newScrollValue >= self:_GetMaxScroll() then
			-- we are done scrolling
			self._targetScrollValue = nil
			self._totalScrollDistance = nil
		end
	end

	if (frame:IsMouseOver() and self:_GetMaxScroll() > 0) or self._scrollbar.dragging then
		self._scrollbar:Show()
	else
		self._scrollbar:Hide()
	end
end

function private.FrameOnMouseWheel(frame, direction)
	local self = private.frameFastScrollingListLookup[frame]
	self._targetScrollValue = nil
	self._totalScrollDistance = nil
	local scrollAmount = MOUSE_WHEEL_SCROLL_AMOUNT
	self._scrollbar:SetValue(self._scrollbar:GetValue() + -1 * direction * scrollAmount)
end



-- ============================================================================
-- ListRow - Public Class Methods
-- ============================================================================

function ListRow.__init(self)
	self._scrollingList = nil
	self._rowData = nil
	self._texts = {}
	self._icons = {}
	self._buttons = {}
	self._recycled = { buttons = {}, texts = {}, icons = {} }

	local frame = CreateFrame("Button", nil, nil, nil)
	self._frame = frame
	private.rowFrameLookup[frame] = self

	frame.background = frame:CreateTexture(nil, "BACKGROUND")
	frame.background:SetAllPoints()

	frame.highlight = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	frame.highlight:SetAllPoints()
	frame.highlight:Hide()
end

function ListRow.Acquire(self, scrollingList)
	self._scrollingList = scrollingList

	self._frame:SetParent(self._scrollingList._content)
	self._frame:SetHitRectInsets(0, 0, 0, 0)
	self._frame:Show()
	self._frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	self._frame:SetScript("OnEnter", private.RowOnEnter)
	self._frame:SetScript("OnLeave", private.RowOnLeave)
	self._frame:SetScript("OnClick", private.RowOnClick)
end

function ListRow.Release(self)
	self._frame:Hide()
	for _, text in pairs(self._texts) do
		text:Hide()
		text:ClearAllPoints()
		text:SetWidth(0)
		text:SetHeight(0)
		text:SetTextColor(1, 1, 1, 1)
		tinsert(self._recycled.texts, text)
	end
	wipe(self._texts)
	for _, icon in pairs(self._icons) do
		icon:Hide()
		icon:SetTexture(nil)
		icon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		icon:SetColorTexture(0, 0, 0, 0)
		icon:SetVertexColor(1, 1, 1, 1)
		icon:ClearAllPoints()
		icon:SetWidth(0)
		icon:SetHeight(0)
		tinsert(self._recycled.icons, icon)
	end
	wipe(self._icons)
	for _, button in pairs(self._buttons) do
		button:Hide()
		button:SetScript("OnEnter", nil)
		button:SetScript("OnLeave", nil)
		button:SetScript("OnClick", nil)
		button:SetParent(nil)
		button:ClearAllPoints()
		button:SetWidth(0)
		button:SetHeight(0)
		tinsert(self._recycled.buttons, button)
	end
	wipe(self._buttons)

	self._scrollingList = nil
	self._rowData = nil
	self._frame:SetParent(nil)
	self._frame:ClearAllPoints()
	self._frame:SetScript("OnEnter", nil)
	self._frame:SetScript("OnLeave", nil)
	self._frame:SetScript("OnClick", nil)
end

function ListRow.SetData(self, data)
	self._rowData = data
end

function ListRow.GetData(self)
	return self._rowData
end

function ListRow.SetHeight(self, height)
	for _, text in pairs(self._texts) do
		text:SetHeight(height)
	end
	for _, btn in pairs(self._buttons) do
		btn:SetHeight(height)
	end
	self._frame:SetHeight(height)
end

function ListRow.SetBackgroundColor(self, color)
	self._frame.background:SetColorTexture(TSM.UI.HexToRGBA(color))
end

function ListRow.SetVisible(self, visible)
	if visible == self._frame:IsVisible() then
		return
	end
	if visible then
		self._frame:Show()
		self._frame.highlight:Hide()
	else
		self._frame:Hide()
	end
end

function ListRow.SetHighlightState(self, color)
	if color == "selected" then
		self._frame.highlight:Show()
		self._frame.highlight:SetColorTexture(TSM.UI.HexToRGBA(self._scrollingList:_GetStyle("selectedHighlight")))
	elseif color == "hover" then
		self._frame.highlight:Show()
		self._frame.highlight:SetColorTexture(TSM.UI.HexToRGBA(self._scrollingList:_GetStyle("hoverHighlight")))
	elseif color == nil then
		self._frame.highlight:Hide()
	else
		error("Invalid color: "..color)
	end
end

function ListRow.IsMouseOver(self)
	return self._frame:IsMouseOver()
end

function ListRow.SetHitRectInsets(self, left, right, top, bottom)
	for _, tooltipFrame in pairs(self._buttons) do
		tooltipFrame:SetHitRectInsets(left, right, top, bottom)
	end
	self._frame:SetHitRectInsets(left, right, top, bottom)
end



-- ============================================================================
-- ListRow - Private Class Methods
-- ============================================================================

function ListRow._GetFontString(self)
	local fontString = tremove(self._recycled.texts)
	if not fontString then
		fontString = self._frame:CreateFontString()
	end
	fontString:Show()
	return fontString
end

function ListRow._GetTexture(self)
	local texture = tremove(self._recycled.icons)
	if not texture then
		texture = self._frame:CreateTexture()
	end
	texture:Show()
	return texture
end

function ListRow._GetButton(self)
	local button = tremove(self._recycled.buttons)
	if not button then
		button = CreateFrame("Button", nil, self._frame, nil)
	end
	button:SetParent(self._frame)
	button:SetHitRectInsets(0, 0, 0, 0)
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:Show()
	return button
end



-- ============================================================================
-- ListRow - Local Script Handlers
-- ============================================================================

function private.RowOnEnter(frame)
	local self = private.rowFrameLookup[frame]
	self:SetHighlightState("hover")
end

function private.RowOnLeave(frame)
	local self = private.rowFrameLookup[frame]
	self:SetHighlightState()
end
