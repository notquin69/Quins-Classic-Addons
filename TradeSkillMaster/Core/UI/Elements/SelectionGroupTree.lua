-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- SelectionGroupTree UI Element Class.
-- A selection group tree allows for selecting a single group within the tree. It is a subclass of the @{GroupTree} class.
-- @classmod SelectionGroupTree

local _, TSM = ...
local SelectionGroupTree = TSMAPI_FOUR.Class.DefineClass("SelectionGroupTree", TSM.UI.GroupTree)
TSM.UI.SelectionGroupTree = SelectionGroupTree



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function SelectionGroupTree.__init(self)
	self.__super:__init()

	self._selectedGroup = TSM.CONST.ROOT_GROUP_PATH
	self._selectedGroupChangedHandler = nil
end

function SelectionGroupTree.Release(self)
	self._selectedGroupChangedHandler = nil
	self._selectedGroup = TSM.CONST.ROOT_GROUP_PATH
	self.__super:Release()
end

--- Registers a script handler.
-- @tparam SelectionGroupTree self The selection group tree object
-- @tparam string script The script to register for (supported scripts: `OnGroupSelectionChanged`)
-- @tparam function handler The script handler which will be called with the selection group tree object followed by any
-- arguments to the script
-- @treturn SelectionGroupTree The selection group tree object
function SelectionGroupTree.SetScript(self, script, handler)
	if script == "OnGroupSelectionChanged" then
		self._selectedGroupChangedHandler = handler
	else
		error("Unknown SelectionGroupTree script: "..tostring(script))
	end
	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function SelectionGroupTree._HandleRowClick(self, data)
	self._selectedGroup = data
	self:Draw()
	if self._selectedGroupChangedHandler then
		self:_selectedGroupChangedHandler(data)
	end
end

function SelectionGroupTree._IsSelected(self, data)
	return data == self._selectedGroup
end
