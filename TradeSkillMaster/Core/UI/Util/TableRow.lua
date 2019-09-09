-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local TableRow = TSMAPI_FOUR.Class.DefineClass("TableRow")
TSM.UI.Util.TableRow = TableRow
local private = { rowFrameLookup = {} }
local ROW_PADDING = 8
local ICON_SPACING = 4



-- ============================================================================
-- TableRow - Public Class Methods
-- ============================================================================

function TableRow.__init(self)
	self._scrollingTable = nil
	self._tableInfo = nil
	self._rowData = nil
	self._texts = {}
	self._icons = {}
	self._buttons = {}
	self._sortIcons = {}
	self._recycled = { buttons = {}, texts = {}, icons = {}, sortIcons = {} }

	local frame = CreateFrame("Button", nil, nil, nil)
	frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	self._frame = frame
	private.rowFrameLookup[frame] = self

	frame.background = frame:CreateTexture(nil, "BACKGROUND")
	frame.background:SetAllPoints()

	frame.highlight = frame:CreateTexture(nil, "ARTWORK", -1)
	frame.highlight:SetAllPoints()
	frame.highlight:Hide()
end

function TableRow.Acquire(self, scrollingTable, isHeader)
	self._scrollingTable = scrollingTable
	self._tableInfo = self._scrollingTable._tableInfo

	self._frame:SetParent(isHeader and self._scrollingTable:_GetBaseFrame() or self._scrollingTable._content)
	self._frame:SetHitRectInsets(0, 0, 0, 0)
	self._frame:Show()
	self._frame.highlight:SetColorTexture(TSM.UI.HexToRGBA(self._scrollingTable:_GetStyle("highlight")))
	self._frame.highlight:Hide()

	if isHeader then
		self:_CreateHeaderRowCols()
		self._frame:SetPoint("TOPLEFT")
		self._frame:SetPoint("TOPRIGHT")
		self:_LayoutHeaderRow()
	else
		self:_CreateDataRowCols()
		self._frame:SetScript("OnEnter", private.RowOnEnter)
		self._frame:SetScript("OnLeave", private.RowOnLeave)
		self._frame:SetScript("OnClick", private.RowOnClick)
		self:_LayoutDataRow()
	end
end

function TableRow.Release(self)
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
		icon:SetDrawLayer("ARTWORK", 0)
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
		if button.isShowingTooltip then
			TSM.UI.HideTooltip()
			button.isShowingTooltip = nil
		end
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
	for _, icon in pairs(self._sortIcons) do
		icon.direction = nil
		icon:Hide()
		icon:ClearAllPoints()
		icon:SetWidth(0)
		icon:SetHeight(0)
		tinsert(self._recycled.sortIcons, icon)
	end
	wipe(self._sortIcons)

	self._scrollingTable = nil
	self._tableInfo = nil
	self._rowData = nil
	self._frame:SetParent(nil)
	self._frame:ClearAllPoints()
	self._frame:SetScript("OnEnter", nil)
	self._frame:SetScript("OnLeave", nil)
	self._frame:SetScript("OnClick", nil)
end

function TableRow.SetData(self, data)
	for _, col in ipairs(self._tableInfo:_GetCols()) do
		local id = col:_GetId()
		self._texts[id]:SetText(col:_GetText(data))
		if col:_GetIconSize() then
			self._icons[id]:SetTexture(col:_GetIcon(data))
		end
	end
	self._rowData = data
end

function TableRow.SetHeaderData(self)
	for _, col in ipairs(self._tableInfo:_GetCols()) do
		if not col:_GetTitleIcon() then
			self._texts[col:_GetId()]:SetText(col:_GetTitle())
		end
	end
end

function TableRow.GetData(self)
	return self._rowData
end

function TableRow.ClearData(self)
	self._rowData = nil
end

function TableRow.SetHeight(self, height)
	for _, text in pairs(self._texts) do
		text:SetHeight(height)
	end
	for _, btn in pairs(self._buttons) do
		btn:SetHeight(height)
	end
	self._frame:SetHeight(height)
end

function TableRow.SetBackgroundColor(self, color)
	self._frame.background:SetColorTexture(TSM.UI.HexToRGBA(color))
end

function TableRow.SetVisible(self, visible)
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

function TableRow.IsVisible(self)
	return self._frame:IsVisible()
end

function TableRow.SetHighlightVisible(self, visible)
	if visible then
		self._frame.highlight:Show()
	else
		self._frame.highlight:Hide()
	end
end

function TableRow.IsMouseOver(self)
	return self._frame:IsMouseOver()
end

function TableRow.SetHitRectInsets(self, left, right, top, bottom)
	for _, tooltipFrame in pairs(self._buttons) do
		tooltipFrame:SetHitRectInsets(left, right, top, bottom)
	end
	self._frame:SetHitRectInsets(left, right, top, bottom)
end

function TableRow.SetSort(self, sortId, sortAscending)
	local didChange = false
	-- clear all the other sorts
	for id, sortIcon in pairs(self._sortIcons) do
		if id ~= sortId then
			didChange = didChange or sortIcon.direction ~= nil
			sortIcon.direction = nil
		end
	end
	if sortId then
		-- set the sort
		local sortIcon = self._sortIcons[sortId]
		assert(sortIcon)
		didChange = didChange or sortIcon.direction ~= sortAscending
		sortIcon.direction = sortAscending
	end
	if didChange then
		self:_LayoutHeaderRow()
	end
end



-- ============================================================================
-- TableRow - Private Class Methods
-- ============================================================================

function TableRow._GetFontString(self)
	local fontString = tremove(self._recycled.texts)
	if not fontString then
		fontString = self._frame:CreateFontString()
	end
	fontString:Show()
	return fontString
end

function TableRow._GetTexture(self)
	local texture = tremove(self._recycled.icons)
	if not texture then
		texture = self._frame:CreateTexture()
	end
	texture:Show()
	return texture
end

function TableRow._GetSortTexture(self)
	local texture = tremove(self._recycled.sortIcons)
	if not texture then
		texture = self._frame:CreateTexture()
	end
	texture:Show()
	return texture
end

function TableRow._GetButton(self)
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

function TableRow._CreateHeaderRowCols(self)
	for _, col in ipairs(self._tableInfo:_GetCols()) do
		local id = col:_GetId()
		local button = self:_GetButton()
		button:SetScript("OnClick", private.HeaderColOnClick)
		self._buttons[id] = button
		local iconTexture = col:_GetTitleIcon()
		if iconTexture then
			local icon = self:_GetTexture()
			icon:SetDrawLayer("ARTWORK")
			TSM.UI.TexturePacks.SetTextureAndSize(icon, iconTexture)
			self._icons[id] = icon
		else
			local text = self:_GetFontString()
			text:SetFont(self._scrollingTable:_GetStyle("headerFont"), self._scrollingTable:_GetStyle("headerFontHeight"))
			text:SetJustifyH(col:_GetJustifyH())
			text:SetText(col:_GetTitle())
			self._texts[id] = text
		end
		local sortIcon = self:_GetSortTexture()
		sortIcon:Hide()
		self._sortIcons[id] = sortIcon
	end
end

function TableRow._CreateDataRowCols(self)
	for _, col in ipairs(self._tableInfo:_GetCols()) do
		local id = col:_GetId()
		local iconSize = col:_GetIconSize()
		if iconSize then
			local icon = self:_GetTexture()
			icon:SetDrawLayer("ARTWORK", 1)
			icon:SetWidth(iconSize)
			icon:SetHeight(iconSize)
			self._icons[id] = icon
		end
		local text = self:_GetFontString()
		text:SetFont(col:_GetFont(), col:_GetFontHeight())
		text:SetJustifyH(col:_GetJustifyH())
		self._texts[id] = text
		if col:_HasTooltip() then
			local tooltipFrame = self:_GetButton()
			tooltipFrame:SetScript("OnEnter", private.TooltipFrameOnEnter)
			tooltipFrame:SetScript("OnLeave", private.TooltipFrameOnLeave)
			tooltipFrame:SetScript("OnClick", private.TooltipFrameOnClick)
			self._buttons[id] = tooltipFrame
		end
	end
end

function TableRow._LayoutHeaderRow(self)
	for _, button in pairs(self._buttons) do
		button:ClearAllPoints()
	end

	-- build buttons from the left until we get to the col without a width
	local xOffsetLeft = ROW_PADDING
	for _, col in ipairs(self._tableInfo:_GetCols()) do
		local button = self._buttons[col:_GetId()]
		button:SetPoint("LEFT", xOffsetLeft, 0)
		local width = col:_GetWidth()
		if width then
			button:SetWidth(width)
		else
			break
		end
		xOffsetLeft = xOffsetLeft + width + self._scrollingTable:_GetStyle("colSpacing")
	end

	-- build buttons from the right until we get to the col without a width
	local xOffsetRight = -ROW_PADDING
	for i = #self._tableInfo:_GetCols(), 1, -1 do
		local col = self._tableInfo:_GetCols()[i]
		local button = self._buttons[col:_GetId()]
		button:SetPoint("RIGHT", xOffsetRight, 0)
		local width = col:_GetWidth()
		if width then
			button:SetWidth(width)
		else
			break
		end
		xOffsetRight = xOffsetRight - width - self._scrollingTable:_GetStyle("colSpacing")
	end

	-- update the text, icons, and sort icons
	for _, col in ipairs(self._tableInfo:_GetCols()) do
		local id = col:_GetId()
		local button = self._buttons[id]
		local sortIcon = self._sortIcons[id]
		sortIcon:ClearAllPoints()
		local iconTexture = col:_GetTitleIcon()
		if iconTexture then
			local icon = self._icons[id]
			icon:ClearAllPoints()
			icon:SetPoint(col:_GetJustifyH(), button)
			if sortIcon.direction ~= nil then
				TSM.UI.TexturePacks.SetTextureAndSize(sortIcon, sortIcon.direction and "iconPack.10x10/Arrow/Up" or "iconPack.10x10/Arrow/Down")
				sortIcon:SetPoint("LEFT", icon, "RIGHT", 2, 0)
				sortIcon:Show()
			else
				sortIcon:Hide()
			end
		else
			local text = self._texts[id]
			text:ClearAllPoints()
			if sortIcon.direction ~= nil then
				TSM.UI.TexturePacks.SetTextureAndSize(sortIcon, sortIcon.direction and "iconPack.10x10/Arrow/Up" or "iconPack.10x10/Arrow/Down")
				sortIcon:Show()
				local justifyH = col:_GetJustifyH()
				if justifyH == "LEFT" then
					text:SetAllPoints(button)
					sortIcon:SetPoint("LEFT", button, text:GetStringWidth() + 6, 0)
				elseif justifyH == "CENTER" then
					text:SetAllPoints(button)
					if not text:GetText() or text:GetText() == "" then
						sortIcon:SetPoint("CENTER", button)
					else
						sortIcon:SetPoint("LEFT", button, "CENTER", text:GetStringWidth() / 2 + 4, 0)
					end
				elseif justifyH == "RIGHT" then
					text:SetPoint("LEFT", button)
					text:SetPoint("RIGHT", button, -sortIcon:GetWidth(), 0)
					sortIcon:SetPoint("RIGHT", button)
				else
					error("Invalid justifyH: "..tostring(justifyH))
				end
			else
				text:SetAllPoints(button)
				sortIcon:Hide()
			end
		end
	end
end

function TableRow._LayoutDataRow(self)
	-- build from the left until we get to the col without a width
	local prevText = nil
	for _, col in ipairs(self._tableInfo:_GetCols()) do
		local id = col:_GetId()
		local width = col:_GetWidth()
		local icon = self._icons[id]
		if icon then
			if prevText then
				icon:SetPoint("LEFT", prevText, "RIGHT", self._scrollingTable:_GetStyle("colSpacing"), 0)
			else
				icon:SetPoint("LEFT", ROW_PADDING, 0)
			end
			local iconSize = col:_GetIconSize()
			width = width and (width - iconSize - ICON_SPACING) or nil
		end
		local text = self._texts[id]
		if icon then
			text:SetPoint("LEFT", icon, "RIGHT", ICON_SPACING, 0)
		elseif prevText then
			text:SetPoint("LEFT", prevText, "RIGHT", self._scrollingTable:_GetStyle("colSpacing"), 0)
		else
			text:SetPoint("LEFT", ROW_PADDING, 0)
		end
		if col:_HasTooltip() then
			local tooltipFrame = self._buttons[id]
			tooltipFrame:SetPoint("LEFT", icon or text)
			tooltipFrame:SetPoint("RIGHT", text)
		end
		if width then
			text:SetWidth(width)
		else
			break
		end
		prevText = text
	end

	-- build from the right until we get to the col without a width
	prevText = nil
	for i = #self._tableInfo:_GetCols(), 1, -1 do
		local col = self._tableInfo:_GetCols()[i]
		local id = col:_GetId()
		local width = col:_GetWidth()
		local text = self._texts[id]
		if prevText then
			text:SetPoint("RIGHT", prevText, "LEFT", -self._scrollingTable:_GetStyle("colSpacing"), 0)
		else
			text:SetPoint("RIGHT", -ROW_PADDING, 0)
		end
		if col:_HasTooltip() then
			local tooltipFrame = self._buttons[id]
			tooltipFrame:SetPoint("LEFT", text)
			tooltipFrame:SetPoint("RIGHT", text)
		end
		if width then
			text:SetWidth(width)
		else
			break
		end
		assert(not self._icons[id], "Not supported")
		prevText = text
	end
end



-- ============================================================================
-- TableRow - Local Script Handlers
-- ============================================================================

function private.HeaderColOnClick(button, mouseButton)
	local self = private.rowFrameLookup[button:GetParent()]
	if mouseButton == "LeftButton" then
		self._scrollingTable:_ToggleSort(TSMAPI_FOUR.Util.GetDistinctTableKey(self._buttons, button))
	elseif mouseButton == "RightButton" then
		self._scrollingTable._tableInfo:_UpdateTitleIndex()
		self._scrollingTable:UpdateData(true)
	end
end

function private.RowOnClick(frame, mouseButton)
	local self = private.rowFrameLookup[frame]
	if mouseButton == "LeftButton" and not self._scrollingTable._selectionDisabled then
		self._scrollingTable:SetSelection(self:GetData())
	end
	self._scrollingTable:_HandleRowClick(self:GetData(), mouseButton)
end

function private.RowOnEnter(frame)
	local self = private.rowFrameLookup[frame]
	self:SetHighlightVisible(true)
	local cursor = self._tableInfo:_GetCursor()
	if cursor then
		SetCursor(cursor)
	end
end

function private.RowOnLeave(frame)
	local self = private.rowFrameLookup[frame]
	if self._scrollingTable._selection ~= self:GetData() then
		self:SetHighlightVisible(false)
	end
	if self._tableInfo:_GetCursor() then
		ResetCursor()
	end
end

function private.TooltipFrameOnEnter(frame)
	frame.isShowingTooltip = true
	local self = private.rowFrameLookup[frame:GetParent()]
	self._frame:GetScript("OnEnter")(self._frame)
	local tooltip = nil
	for _, col in ipairs(self._tableInfo:_GetCols()) do
		if self._buttons[col:_GetId()] == frame then
			if col:_HasTooltip() then
				tooltip = col:_GetTooltip(self:GetData())
			end
			break
		end
	end
	TSM.UI.ShowTooltip(frame, tooltip)
end

function private.TooltipFrameOnLeave(frame)
	frame.isShowingTooltip = nil
	local self = private.rowFrameLookup[frame:GetParent()]
	self._frame:GetScript("OnLeave")(self._frame)
	TSM.UI.HideTooltip()
end

function private.TooltipFrameOnClick(frame, ...)
	local self = private.rowFrameLookup[frame:GetParent()]
	if IsShiftKeyDown() or IsControlKeyDown() then
		local tooltip = nil
		for _, col in ipairs(self._tableInfo:_GetCols()) do
			if self._buttons[col:_GetId()] == frame then
				if col:_HasTooltip() and not col:_GetTooltipLinkingDisabled() then
					tooltip = col:_GetTooltip(self:GetData())
				end
				break
			end
		end
		local link = tooltip and TSMAPI_FOUR.Item.GetLink(tooltip)
		if link then
			if IsShiftKeyDown() then
				TSMAPI_FOUR.Util.SafeItemRef(link)
			elseif IsControlKeyDown() then
				DressUpItemLink(link)
			end
			return
		end
	end
	self._frame:GetScript("OnClick")(self._frame, ...)
end
