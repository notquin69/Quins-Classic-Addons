-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- ApplicationGroupTree UI Element Class.
-- An application group tree displays the group tree in a way which allows the user to select any number of them. This
-- element is used wherever the user needs to select groups to perform some action on. It is a subclass of the
-- @{GroupTree} class.
-- @classmod ApplicationGroupTree

local _, TSM = ...
local ApplicationGroupTree = TSMAPI_FOUR.Class.DefineClass("ApplicationGroupTree", TSM.UI.GroupTree)
TSM.UI.ApplicationGroupTree = ApplicationGroupTree



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ApplicationGroupTree.__init(self)
	self.__super:__init()
	self._defaultContextTbl.selected = {}
	self._selectedGroupsChangedHandler = nil
end

function ApplicationGroupTree.Release(self)
	self._selectedGroupsChangedHandler = nil
	self.__super:Release()
	wipe(self._defaultContextTbl.selected)
end

--- Registers a script handler.
-- @tparam ApplicationGroupTree self The application group tree object
-- @tparam string script The script to register for (supported scripts: `OnGroupSelectionChanged`)
-- @tparam function handler The script handler which will be called with the application group tree object followed by
-- any arguments to the script
-- @treturn ApplicationGroupTree The application group tree object
function ApplicationGroupTree.SetScript(self, script, handler)
	if script == "OnGroupSelectionChanged" then
		self._selectedGroupsChangedHandler = handler
	else
		error("Unknown ApplicationGroupTree script: "..tostring(script))
	end
	return self
end

--- Iterates through the selected groups.
-- @tparam ApplicationGroupTree self The application group tree object
-- @return Iterator with the following fields: `index, groupPath`
function ApplicationGroupTree.SelectedGroupsIterator(self)
	local groups = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, groupPath in ipairs(self._allData) do
		if self._contextTbl.selected[groupPath] then
			tinsert(groups, groupPath)
		end
	end
	return TSMAPI_FOUR.Util.TempTableIterator(groups)
end

--- Sets the context table.
-- This table can be used to preserve selection state across lifecycles of the application group tree and even WoW
-- sessions if it's within the settings DB.
-- @see GroupTree.SetContextTable
-- @tparam ApplicationGroupTree self The application group tree object
-- @tparam table tbl The context table
-- @treturn ApplicationGroupTree The application group tree object
function ApplicationGroupTree.SetContextTable(self, tbl)
	if tbl then
		tbl.selected = tbl.selected or {}
	end
	self.__super:SetContextTable(tbl)
	return self
end

--- Gets whether or not the selection is cleared.
-- @tparam ApplicationGroupTree self The application group tree object
-- @tparam[opt=false] boolean updateData Whether or not to update the data first
-- @treturn boolean Whether or not the selection is cleared
function ApplicationGroupTree.IsSelectionCleared(self, updateData)
	if updateData then
		self:_UpdateData()
	end
	return not next(self._contextTbl.selected)
end

--- Select every group.
-- @tparam ApplicationGroupTree self The application group tree object
-- @treturn ApplicationGroupTree The application group tree object
function ApplicationGroupTree.SelectAll(self)
	for _, groupPath in ipairs(self._allData) do
		self._contextTbl.selected[groupPath] = true
	end
	self:Draw()
	if self._selectedGroupsChangedHandler then
		self:_selectedGroupsChangedHandler(self._contextTbl.selected)
	end
	return self
end

--- Deselect every group.
-- @tparam ApplicationGroupTree self The application group tree object
-- @treturn ApplicationGroupTree The application group tree object
function ApplicationGroupTree.DeselectAll(self)
	for _, groupPath in ipairs(self._allData) do
		self._contextTbl.selected[groupPath] = nil
	end
	self:Draw()
	if self._selectedGroupsChangedHandler then
		self:_selectedGroupsChangedHandler(self._contextTbl.selected)
	end
	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ApplicationGroupTree._UpdateData(self)
	self.__super:_UpdateData()
	-- remove data which is no longer present from _contextTbl
	local selectedGroups = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, groupPath in ipairs(self._allData) do
		if self:_IsSelected(groupPath) then
			selectedGroups[groupPath] = true
		end
	end
	wipe(self._contextTbl.selected)
	for groupPath in pairs(selectedGroups) do
		self._contextTbl.selected[groupPath] = true
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(selectedGroups)
end

function ApplicationGroupTree._IsSelected(self, data)
	return self._contextTbl.selected[data]
end

function ApplicationGroupTree._HandleRowClick(self, data)
	self._contextTbl.selected[data] = not self._contextTbl.selected[data] or nil
	-- also set the selection for all child groups to the same as this group
	for _, groupPath in ipairs(self._allData) do
		if TSM.Groups.Path.IsChild(groupPath, data) and data ~= TSM.CONST.ROOT_GROUP_PATH then
			self._contextTbl.selected[groupPath] = self._contextTbl.selected[data]
		end
	end
	for _, row in ipairs(self._rows) do
		if row._frame:IsVisible() then
			local groupPath = row:GetData()
			if self._contextTbl.selected[row:GetData()] or row:IsMouseOver() then
				local level = select('#', strsplit(TSM.CONST.GROUP_SEP, groupPath))
				row._icons.color:SetColorTexture(TSM.UI.HexToRGBA(TSM.UI.GetGroupLevelColor(level)))
				row:SetHighlightState(row:IsMouseOver() and "hover" or "selected")
			else
				row._icons.color:SetColorTexture(TSM.UI.HexToRGBA("#2e2e2e"))
				row:SetHighlightState()
			end
		end
	end
	if self._selectedGroupsChangedHandler then
		self:_selectedGroupsChangedHandler(self._contextTbl.selected)
	end
end
