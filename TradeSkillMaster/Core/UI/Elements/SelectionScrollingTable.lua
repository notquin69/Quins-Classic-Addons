-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- SelectionScrollingTable UI Element Class.
-- A selection scrolling table is a scrolling table which allows for selecting and deselecting individual rows. It is a
-- subclass of the @{QueryScrollingTable} class.
-- @classmod SelectionScrollingTable

local _, TSM = ...
local SelectionScrollingTable = TSMAPI_FOUR.Class.DefineClass("SelectionScrollingTable", TSM.UI.QueryScrollingTable)
TSM.UI.SelectionScrollingTable = SelectionScrollingTable
local private = {}
local CHECK_LEFT_SPACING = 4
local CHECK_RIGHT_SPACING = 6
local ICON_SPACING = 4



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function SelectionScrollingTable.__init(self)
	self.__super:__init()

	self._selectedData = {}
	self._selectionEnabledFunc = nil
end

function SelectionScrollingTable.Release(self)
	wipe(self._selectedData)
	self._selectionEnabledFunc = nil
	self.__super:Release()
end

--- Clear the selection.
-- @tparam SelectionScrollingTable self The selection scrolling table object
function SelectionScrollingTable.ClearSelection(self)
	wipe(self._selectedData)
	if self._onSelectionChangedHandler then
		self._onSelectionChangedHandler(self)
	end
end

--- Sets a selection enabled function.
-- @tparam SelectionScrollingTable self The selection scrolling table object
-- @tparam function func A funciton which gets called with data to determine if it's selectable or not
-- @treturn SelectionScrollingTable The selection scrolling table object
function SelectionScrollingTable.SetIsSelectionEnabledFunc(self, func)
	self._selectionEnabledFunc = func
	return self
end

--- Toggles the selection of a record.
-- @tparam SelectionScrollingTable self The selection scrolling table object
-- @tparam ?table data The record to toggle the selection of
-- @treturn SelectionScrollingTable The selection scrolling table object
function SelectionScrollingTable.SetSelection(self, data)
	if data and self._selectionValidator and not self:_selectionValidator(self._query:GetResultRowByUUID(data)) then
		assert(not self._selectedData[data])
		return self
	end
	self._selectedData[data] = not self._selectedData[data] or nil
	for _, row in ipairs(self._rows) do
		if row:GetData() == data then
			if self._selectedData[data] then
				row._icons.check:Show()
			else
				row._icons.check:Hide()
			end
			break
		end
	end
	if self._onSelectionChangedHandler then
		self._onSelectionChangedHandler(self)
	end
	return self
end

--- Gets whether or not the selection is currently cleared.
-- @tparam SelectionScrollingTable self The selection scrolling table object
-- @treturn boolean Whether or not the selection is cleared
function SelectionScrollingTable.IsSelectionCleared(self)
	return not next(self._selectedData)
end

--- Gets the current selection table.
-- @tparam SelectionScrollingTable self The selection scrolling table object
-- @treturn table A table where the key is the data and the value is whether or not it's selected (only selected entries
-- are in the table)
function SelectionScrollingTable.SelectionIterator(self)
	return private.SelectionIteratorHelper, self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function SelectionScrollingTable._GetTableRow(self, isHeader)
	local row = self.__super:_GetTableRow(isHeader)
	if not isHeader then
		-- add the checkmark texture before the first col
		local id = self._tableInfo:_GetCols()[1]:_GetId()

		local check = row:_GetTexture()
		TSM.UI.TexturePacks.SetTextureAndSize(check, "iconPack.14x14/Checkmark/Default")
		check:SetPoint("LEFT", CHECK_LEFT_SPACING, 0)
		row._icons.check = check

		local icon = row._icons[id]
		icon:ClearAllPoints()
		icon:SetPoint("LEFT", check, "RIGHT", CHECK_RIGHT_SPACING, 0)

		local text = row._texts[id]
		text:SetPoint("LEFT", icon, "RIGHT", ICON_SPACING, 0)
	end
	return row
end

function SelectionScrollingTable._SetRowData(self, row, data)
	if self._selectedData[data] then
		row._icons.check:Show()
	else
		row._icons.check:Hide()
	end
	self.__super:_SetRowData(row, data)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.SelectionIteratorHelper(self, uuid)
	uuid = next(self._selectedData, uuid)
	if not uuid then
		return
	end
	return uuid, self._query:GetResultRowByUUID(uuid)
end
