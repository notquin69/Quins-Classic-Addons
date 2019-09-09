-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Multiselection Dropdown UI Element Class.
-- A dropdown element allows the user to select from a dialog list. It is a subclass of the @{BaseDropdown} class.
-- @classmod MultiselectionDropdown

local _, TSM = ...
local MultiselectionDropdown = TSMAPI_FOUR.Class.DefineClass("MultiselectionDropdown", TSM.UI.BaseDropdown)
TSM.UI.MultiselectionDropdown = MultiselectionDropdown



-- ============================================================================
-- Meta Class Methods
-- ============================================================================

function MultiselectionDropdown.__init(self)
	self.__super:__init()
	self._itemIsSelected = {}
	self._settingTable = nil
	self._settingKey = nil
end

function MultiselectionDropdown.Release(self)
	wipe(self._itemIsSelected)
	self._settingTable = nil
	self._settingKey = nil
	self.__super:Release()
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

--- Set whether the item is selected.
-- @tparam MultiselectionDropdown self The dropdown object
-- @tparam string item The item
-- @tparam boolean selected Whether or not the item should be selected
-- @treturn MultiselectionDropdown The dropdown object
function MultiselectionDropdown.SetItemSelected(self, item, selected)
	self:_SetItemSelectedHelper(item, selected)
	if self._onSelectionChangedHandler then
		self:_onSelectionChangedHandler()
	end
	return self
end

--- Set whether the item is selected by key.
-- @tparam MultiselectionDropdown self The dropdown object
-- @tparam string itemKey The key for the item
-- @tparam boolean selected Whether or not the item should be selected
-- @treturn MultiselectionDropdown The dropdown object
function MultiselectionDropdown.SetItemSelectedByKey(self, itemKey, selected)
	self:SetItemSelected(TSMAPI_FOUR.Util.GetDistinctTableKey(self._itemKeyLookup, itemKey), selected)
	return self
end

--- Set the selected items.
-- @tparam MultiselectionDropdown self The dropdown object
-- @tparam table selected A table where the keys are the items to be selected
-- @treturn MultiselectionDropdown The dropdown object
function MultiselectionDropdown.SetSelectedItems(self, selected)
	wipe(self._itemIsSelected)
	if self._settingTable then
		wipe(self._settingTable[self._settingKey])
	end
	for _, item in ipairs(self._items) do
		self:_SetItemSelectedHelper(item, selected[item])
	end
	if self._onSelectionChangedHandler then
		self:_onSelectionChangedHandler()
	end
	return self
end

--- Get the currently selected item.
-- @tparam MultiselectionDropdown self The dropdown object
-- @tparam string item The item
-- @treturn ?string The selected item
function MultiselectionDropdown.ItemIsSelected(self, item)
	return self._itemIsSelected[item]
end

--- Get the currently selected item.
-- @tparam MultiselectionDropdown self The dropdown object
-- @tparam itemKey string|number The key for the item
-- @treturn boolean Whether or not the item is selected
function MultiselectionDropdown.ItemIsSelectedByKey(self, itemKey)
	return self:ItemIsSelected(TSMAPI_FOUR.Util.GetDistinctTableKey(self._itemKeyLookup, itemKey))
end

--- Sets the setting info.
-- This method is used to have the value of the dropdown automatically correspond with the value of a field in a table.
-- This is useful for dropdowns which are tied directly to settings.
-- @tparam MultiselectionDropdown self The dropdown object
-- @tparam table tbl The table which the field to set belongs to
-- @tparam string key The key into the table to be set based on the dropdown state
-- @treturn MultiselectionDropdown The dropdown object
function MultiselectionDropdown.SetSettingInfo(self, tbl, key)
	-- this function wipes our settingTable, so set the selected items first
	self:SetSelectedItems(tbl[key])
	self._settingTable = tbl
	self._settingKey = key
	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function MultiselectionDropdown._CreateDropdownList(self)
	return TSMAPI_FOUR.UI.NewElement("DropdownList", "list")
		:SetMultiselect(true)
		:SetItems(self._items, self._itemIsSelected)
end

function MultiselectionDropdown._GetCurrentSelectionString(self)
	local tbl = TSMAPI_FOUR.Util.AcquireTempTable()
	for item in pairs(self._itemIsSelected) do
		tinsert(tbl, item)
	end
	sort(tbl)
	local result = #tbl > 0 and table.concat(tbl, ", ") or self._hintText
	TSMAPI_FOUR.Util.ReleaseTempTable(tbl)
	return result
end

function MultiselectionDropdown._OnListSelectionChanged(self, dropdownList, selection)
	self:SetSelectedItems(selection)
	dropdownList:GetElement("__parent.topRow.current")
		:SetText(self:_GetCurrentSelectionString())
		:Draw()
end

function MultiselectionDropdown._SetItemSelectedHelper(self, item, selected)
	self._itemIsSelected[item] = selected and true or nil
	if self._settingTable then
		self._settingTable[self._settingKey][self._itemKeyLookup[item]] = self._itemIsSelected[item]
	end
end
