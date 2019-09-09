-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Selection Dropdown UI Element Class.
-- A dropdown element allows the user to select from a dialog list. It is a subclass of the @{BaseDropdown} class.
-- @classmod SelectionDropdown

local _, TSM = ...
local SelectionDropdown = TSMAPI_FOUR.Class.DefineClass("SelectionDropdown", TSM.UI.BaseDropdown)
TSM.UI.SelectionDropdown = SelectionDropdown



-- ============================================================================
-- Meta Class Methods
-- ============================================================================

function SelectionDropdown.__init(self)
	self.__super:__init()
	self._selectedItem = nil
	self._settingTable = nil
	self._settingKey = nil
end

function SelectionDropdown.Release(self)
	self._selectedItem = nil
	self._settingTable = nil
	self._settingKey = nil
	self.__super:Release()
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

--- Set the currently selected item.
-- @tparam SelectionDropdown self The dropdown object
-- @tparam ?string item The selected item or nil if nothing should be selected
-- @tparam[opt=false] boolean silent Don't call the OnSelectionChanged callback
-- @treturn SelectionDropdown The dropdown object
function SelectionDropdown.SetSelectedItem(self, item, silent)
	self._selectedItem = item
	if self._settingTable then
		self._settingTable[self._settingKey] = self._itemKeyLookup[item]
	end
	if not silent and self._onSelectionChangedHandler then
		self:_onSelectionChangedHandler()
	end
	return self
end

--- Set the currently selected item by key.
-- @tparam SelectionDropdown self The dropdown object
-- @tparam ?string item The key for the selected item or nil if nothing should be selected
-- @tparam[opt=false] boolean silent Don't call the OnSelectionChanged callback
-- @treturn SelectionDropdown The dropdown object
function SelectionDropdown.SetSelectedItemByKey(self, itemKey, silent)
	local item = itemKey and TSMAPI_FOUR.Util.GetDistinctTableKey(self._itemKeyLookup, itemKey) or nil
	self:SetSelectedItem(item, silent)
	return self
end

--- Get the currently selected item.
-- @tparam SelectionDropdown self The dropdown object
-- @treturn ?string The selected item
function SelectionDropdown.GetSelectedItem(self)
	return self._selectedItem
end

--- Get the currently selected item.
-- @tparam SelectionDropdown self The dropdown object
-- @treturn ?string The selected item key
function SelectionDropdown.GetSelectedItemKey(self)
	return self._selectedItem and self._itemKeyLookup[self._selectedItem] or nil
end

--- Sets the setting info.
-- This method is used to have the value of the dropdown automatically correspond with the value of a field in a table.
-- This is useful for dropdowns which are tied directly to settings.
-- @tparam SelectionDropdown self The dropdown object
-- @tparam table tbl The table which the field to set belongs to
-- @tparam string key The key into the table to be set based on the dropdown state
-- @treturn SelectionDropdown The dropdown object
function SelectionDropdown.SetSettingInfo(self, tbl, key)
	self._settingTable = tbl
	self._settingKey = key
	self:SetSelectedItemByKey(tbl[key])
	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function SelectionDropdown._CreateDropdownList(self)
	return TSMAPI_FOUR.UI.NewElement("DropdownList", "list")
		:SetMultiselect(false)
		:SetItems(self._items, self._selectedItem)
end

function SelectionDropdown._GetCurrentSelectionString(self)
	return self._selectedItem or self._hintText
end

function SelectionDropdown._OnListSelectionChanged(self, _, selection)
	self:SetOpen(false)
	self:SetSelectedItem(selection)
end
