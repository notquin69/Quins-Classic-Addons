-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local ROW_HORIZONTAL_PADDING = 8
local CHECK_SIZE = 18
local CHECK_TO_TEXT_SPACING = 4
local DropdownList = TSMAPI_FOUR.Class.DefineClass("DropdownList", TSM.UI.ScrollList)
TSM.UI.DropdownList = DropdownList
local private = {}



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function DropdownList.__init(self)
	self.__super:__init()

	self._selectedItems = {}
	self._multiselect = false
	self._onSelectionChangedHandler = nil
end

function DropdownList.Release(self)
	wipe(self._selectedItems)
	self._multiselect = false
	self._onSelectionChangedHandler = nil
	self.__super:Release()
end

function DropdownList.SetMultiselect(self, multiselect)
	self._multiselect = multiselect
	return self
end

function DropdownList.SetItems(self, items, selection, redraw)
	wipe(self._data)
	for _, item in ipairs(items) do
		tinsert(self._data, item)
	end
	self:_SetSelectionHelper(selection)

	if redraw then
		self:_DrawRows()
	end

	return self
end

function DropdownList.ItemIterator(self)
	return private.ItemIterator, self, 0
end

function DropdownList.SetSelection(self, selection)
	self:_SetSelectionHelper(selection)
	if self._onSelectionChangedHandler then
		self:_onSelectionChangedHandler(self._multiselect and self._selectedItems or selection)
	end
	return self
end

function DropdownList.GetSelection(self)
	if self._multiselect then
		return self._selectedItems
	else
		local selectedItem = next(self._selectedItems)
		return selectedItem
	end
end

function DropdownList.SetScript(self, script, handler)
	if script == "OnSelectionChanged" then
		self._onSelectionChangedHandler = handler
	else
		error("Invalid DropdownList script: "..tostring(script))
	end
	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function DropdownList._SetSelectionHelper(self, selection)
	wipe(self._selectedItems)
	if selection then
		if self._multiselect then
			assert(type(selection) == "table")
			for item, selected in pairs(selection) do
				self._selectedItems[item] = selected
			end
		else
			assert(type(selection) == "string" or type(selection) == "number")
			self._selectedItems[selection] = true
		end
	end
end

function DropdownList._CreateRow(self)
	local row = self.__super:_CreateRow()
		:SetScript("OnUpdate", private.RowOnUpdate)
		:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Button", "button")
			:SetStyle("textIndent", 8)
			:SetStyle("anchors", { { "TOPLEFT" }, { "BOTTOMRIGHT" } })
			:SetScript("OnClick", private.RowOnClick)
		)
		:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Frame", "check")
			:SetStyle("anchors", { { "LEFT" } })
			:SetStyle("width", CHECK_SIZE)
			:SetStyle("height", CHECK_SIZE)
			:SetStyle("backgroundTexturePack", self:_GetStyle("checkTexturePack"))
		)
		:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Text", "text")
			:SetStyle("anchors", { { "TOPLEFT", 0, 0 }, { "BOTTOMRIGHT", -ROW_HORIZONTAL_PADDING, 0 } })
			:SetStyle("justifyH", "LEFT")
		)
		:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Frame", "highlight")
			:SetStyle("anchors", { { "TOPLEFT" }, { "BOTTOMRIGHT" } })
		)

	-- hide the highlight
	row:GetElement("highlight"):Hide()
	return row
end

function DropdownList._SetRowHitRectInsets(self, row, top, bottom)
	row:GetElement("button"):SetHitRectInsets(0, 0, top, bottom)
	self.__super:_SetRowHitRectInsets(row, top, bottom)
end

function DropdownList._DrawRow(self, row)
	local rowText = row:GetContext()

	local text = row:GetElement("text")
	text:SetText(rowText)
	text:SetStyle("font", self:_GetStyle("font"))
	text:SetStyle("fontHeight", self:_GetStyle("fontHeight"))

	local check = row:GetElement("check")
	if self._multiselect then
		text:_GetStyle("anchors")[1][2] = CHECK_SIZE + CHECK_TO_TEXT_SPACING
		if self._selectedItems[rowText] then
			check:Show()
		else
			check:Hide()
		end
	else
		text:_GetStyle("anchors")[1][2] = ROW_HORIZONTAL_PADDING
		check:Hide()
	end

	row:GetElement("highlight"):SetStyle("background", self:_GetStyle("highlight"))
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.RowOnClick(button)
	local row = button:GetParentElement()
	local self = row:GetParentElement()
	local rowText = row:GetContext()
	if self._multiselect then
		self._selectedItems[rowText] = not self._selectedItems[rowText] or nil
		if self._onSelectionChangedHandler then
			self:_onSelectionChangedHandler(self._selectedItems)
		end
		self:Draw()
	else
		self:SetSelection(rowText)
	end
end

function private.RowOnUpdate(frame)
	if frame:IsMouseOver() then
		frame:GetElement("highlight"):Show()
	else
		frame:GetElement("highlight"):Hide()
	end
end

function private.ItemIterator(self, index)
	index = index + 1
	local item = self._data[index]
	if not item then return end
	return index, item, self._selectedItems[item]
end
