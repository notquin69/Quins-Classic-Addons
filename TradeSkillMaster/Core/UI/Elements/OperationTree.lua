-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- OperationTree UI Element Class.
-- The operation tree is used to display operations grouped by module and allows for adding, duplicating, and deleting
-- them. Only one module is allowed to be expanded at a time. It is a subclass of the @{ScrollList} class.
-- @classmod OperationTree

local _, TSM = ...
local OperationTree = TSMAPI_FOUR.Class.DefineClass("OperationTree", TSM.UI.ScrollList)
TSM.UI.OperationTree = OperationTree
local private = {}
local EXPANDER_PADDING_LEFT = 8
local SCROLLBAR_WIDTH = 16
local TEXT_INDENT = 30
local DATA_SEP = "\001"


-- ============================================================================
-- Public Class Methods
-- ============================================================================

function OperationTree.__init(self)
	self.__super:__init()

	self._operationNameFilter = ""
	self._selected = nil
	self._contextTable = nil
	self._defaultContextTable = nil
	self._selectedOperation = nil
	self._prevSelectedOperation = nil
	self._onOperationSelectedHandler = nil
	self._onOperationAddedHandler = nil
	self._onOperationDeletedHandler = nil
end

function OperationTree.Acquire(self)
	self._selectedRowFrame = TSMAPI_FOUR.UI.NewElement("Frame", self._id.."_SelectedRowIcons")
		:SetLayout("HORIZONTAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "duplicateButton")
			:SetScript("OnClick", private.CopyButtonOnClick)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "deleteButton")
			:SetScript("OnClick", private.DeleteButtonOnClick)
		)

	self.__super:Acquire()
end

function OperationTree.Release(self)
	if not self._selected then
		self._selectedRowFrame:Release()
	end
	self._selected = nil
	self._operationNameFilter = ""
	self._contextTable = nil
	self._defaultContextTable = nil
	self._selectedOperation = nil
	self._prevSelectedOperation = nil
	self._onOperationSelectedHandler = nil
	self._onOperationAddedHandler = nil
	self._onOperationDeletedHandler = nil
	self._selectedRowFrame = nil
	self.__super:Release()
end

--- Sets the context table.
-- This table can be used to preserve the expanded module information across lifecycles of the operation tree and even
-- WoW sessions if it's within the settings DB.
-- @tparam OperationTree self The operation tree object
-- @tparam table tbl The context table
-- @tparam table defaultTbl Default values (required fields: `expandedModule`)
-- @treturn OperationTree The operation tree object
function OperationTree.SetContextTable(self, tbl, defaultTbl)
	tbl.expandedModule = tbl.expandedModule or defaultTbl.expandedModule
	self._contextTable = tbl
	self._defaultContextTable = defaultTbl
	return self
end

--- Sets the operation name filter.
-- @tparam OperationTree self The operation tree object
-- @tparam string filter The filter string (any operations which don't match this are hidden)
function OperationTree.SetOperationNameFilter(self, filter)
	self._operationNameFilter = filter
	if filter == "" and self._prevSelectedOperation and not self._selectedOperation then
		-- restore any previous selection if we don't have something selected
		self:SetSelectedOperation(self:_SplitOperationKey(self._prevSelectedOperation))
		self._prevSelectedOperation = nil
	elseif filter ~= "" and self._selectedOperation then
		local _, operationName = self:_SplitOperationKey(self._selectedOperation)
		if not strmatch(strlower(operationName), filter) then
			-- save the current selection to restore after the filter is cleared and then clear the current selection
			self._prevSelectedOperation = self._selectedOperation
			self:SetSelectedOperation()
		end
	end
	self:Draw()
end

--- Registers a script handler.
-- @tparam OperationTree self The operation tree object
-- @tparam string script The script to register for (supported scripts: `OnOperationSelected`, `OnOperationAdded`,
-- `OnOperationDeleted`)
-- @tparam function handler The script handler which will be called with the operation tree object followed by any
-- arguments to the script
-- @treturn OperationTree The operation tree object
function OperationTree.SetScript(self, script, handler)
	if script == "OnOperationSelected" then
		self._onOperationSelectedHandler = handler
	elseif script == "OnOperationAdded" then
		self._onOperationAddedHandler = handler
	elseif script == "OnOperationDeleted" then
		self._onOperationDeletedHandler = handler
	else
		error("Unknown OperationTree script: "..tostring(script))
	end
	return self
end

--- Sets the selected operation.
-- @tparam OperationTree self The operation tree object
-- @tparam string moduleName The name of the module which the operation belongs to
-- @tparam string operationName The name of the operation
-- @treturn OperationTree The operation tree object
function OperationTree.SetSelectedOperation(self, moduleName, operationName)
	if moduleName and operationName then
		self._selectedOperation = moduleName..DATA_SEP..operationName
		self._contextTable.expandedModule = moduleName
	else
		self._selectedOperation = nil
	end
	if self._onOperationSelectedHandler then
		self:_onOperationSelectedHandler(moduleName, operationName)
	end
	self:Draw()
	return self
end

function OperationTree.Draw(self)
	self._selectedRowFrame:GetElement("duplicateButton"):SetStyle("backgroundTexturePack", self:_GetStyle("duplicateBackgroundTexturePack"))
	self._selectedRowFrame:GetElement("deleteButton"):SetStyle("backgroundTexturePack", self:_GetStyle("deleteBackgroundTexturePack"))
	self.__super:Draw()
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function OperationTree._CreateRow(self)
	local row = self.__super:_CreateRow()
		:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Button", "button")
			:SetStyle("anchors", { { "TOPLEFT" }, { "BOTTOMRIGHT" } })
			:SetStyle("justifyH", "LEFT")
			:SetScript("OnClick", private.RowButtonOnClick)
			:SetScript("OnEnter", private.RowButtonOnEnter)
			:SetScript("OnLeave", private.RowButtonOnLeave)
		)
		:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Texture", "highlight")
			:SetStyle("anchors", { { "TOPLEFT" }, { "BOTTOMRIGHT" } })
		)
		:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Texture", "expander")
			:SetStyle("anchors", { { "LEFT", EXPANDER_PADDING_LEFT, 0 } })
		)
		:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Button", "addBtn")
			:SetStyle("relativeLevel", 2)
			:SetStyle("width", 18)
			:SetStyle("height", 18)
			:SetStyle("anchors", { { "TOPRIGHT", -SCROLLBAR_WIDTH, 0 }, { "BOTTOMRIGHT", -SCROLLBAR_WIDTH, 0 } })
			:SetStyle("backgroundTexturePack", self:_GetStyle("plusBackgroundTexturePack"))
			:SetScript("OnClick", private.AddNewOnClick)
			:SetScript("OnEnter", private.RowButtonOnEnter)
			:SetScript("OnLeave", private.RowButtonOnLeave)
		)
		:SetScript("OnEnter", private.RowOnEnter)
		:SetScript("OnLeave", private.RowOnLeave)

	-- hide the highlight
	row:GetElement("highlight"):Hide()
	return row
end

function OperationTree._SetRowHitRectInsets(self, row, top, bottom)
	row:GetElement("button"):SetHitRectInsets(0, 0, top, bottom)
	row:GetElement("addBtn"):SetHitRectInsets(0, 0, top, bottom)
	self.__super:_SetRowHitRectInsets(row, top, bottom)
end

function OperationTree._DrawRow(self, row, dataIndex)
	local moduleName, operationName = self:_SplitOperationKey(row:GetContext())
	local isCollapsed = self._contextTable.expandedModule ~= moduleName

	local expanderSize = self:_GetStyle("expanderSize")
	row:GetElement("button")
		:SetStyle("textIndent", TEXT_INDENT)
		:SetStyle("fontHeight", self:_GetStyle("fontHeight"))
		:SetStyle("font", self:_GetStyle(operationName and "font" or "headerFont"))
		:SetStyle("textColor", self:_GetStyle(operationName and "textColor" or "headerTextColor"))
		:SetText(operationName or moduleName)
	row:GetElement("expander"):SetStyle("width", expanderSize)
	row:GetElement("expander"):SetStyle("height", expanderSize)
	row:GetElement("highlight"):SetStyle("color", self:_GetStyle("highlight"))
	if operationName then
		row:GetElement("expander"):SetStyle("texturePack", nil)
		row:GetElement("addBtn"):Hide()
	else
		row:GetElement("expander"):SetStyle("texturePack", self:_GetStyle(isCollapsed and "expanderCollapsedBackgroundTexturePack" or "expanderExpandedBackgroundTexturePack"))
		row:GetElement("addBtn")
			:SetStyle("font", self:_GetStyle("headerFont"))
			:SetStyle("fontHeight", self:_GetStyle("fontHeight"))
			:Show()
	end
	row:Draw()

	self.__super:_DrawRow(row, dataIndex)
end

function OperationTree._IsDataHidden(self, data)
	local moduleName, operationName = self:_SplitOperationKey(data)
	if operationName and not strmatch(strlower(operationName), self._operationNameFilter) then
		return true
	elseif operationName and moduleName ~= self._contextTable.expandedModule then
		return true
	else
		return self.__super:_IsDataHidden(data)
	end
end

function OperationTree._SplitOperationKey(self, data)
	local moduleName, operationName = strmatch(data, "([^"..DATA_SEP.."]+)"..DATA_SEP.."?(.*)")
	operationName = operationName ~= "" and operationName or nil
	return moduleName, operationName
end

function OperationTree._UpdateData(self)
	wipe(self._data)
	for _, moduleName in TSM.Operations.ModuleIterator() do
		tinsert(self._data, moduleName)
		for _, operationName in TSM.Operations.OperationIterator(moduleName) do
			tinsert(self._data, moduleName..DATA_SEP..operationName)
		end
	end
end

function OperationTree._DrawRows(self)
	self:_UpdateData()
	self.__super:_DrawRows()
	self:_UpdateSelectedRowIcons()
end

function OperationTree._UpdateSelectedRowIcons(self)
	local selectedRow = nil
	for _, row in ipairs(self._rows) do
		local rowData = row:GetContext()
		if rowData and rowData == self._selectedOperation then
			selectedRow = row
			break
		end
	end
	local currentParentRow = self._selectedRowFrame:GetParentElement()
	if currentParentRow then
		currentParentRow:RemoveChild(self._selectedRowFrame)
	end
	if self._selected then
		self._selected:GetElement("highlight"):Hide()
	end
	if selectedRow then
		selectedRow:AddChildNoLayout(self._selectedRowFrame)
		local buttonSize = self:_GetStyle("selectedRowButtonSize")
		local horizontalPadding = self:_GetStyle("selectedRowIconPadding")
		self._selectedRowFrame:SetStyle("width", buttonSize * 2 + horizontalPadding)
		self._selectedRowFrame:SetStyle("height", self:_GetStyle("rowHeight"))
		self._selectedRowFrame:SetStyle("anchors", { { "TOPRIGHT", -SCROLLBAR_WIDTH, 0 } })
		self._selectedRowFrame:GetElement("duplicateButton")
			:SetStyle("height", buttonSize)
			:SetStyle("width", buttonSize)
			:SetStyle("margin", { right = horizontalPadding })
		self._selectedRowFrame:GetElement("deleteButton")
			:SetStyle("height", buttonSize)
			:SetStyle("width", buttonSize)
		self._selectedRowFrame:Show()
		selectedRow:GetElement("highlight"):Show()
		self._selected = selectedRow
		self._selectedRowFrame:Draw()
	else
		self._selected = nil
		self._selectedRowFrame:Hide()
	end
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.RowButtonOnClick(button)
	local row = button:GetParentElement()
	local self = row:GetParentElement()
	local moduleName, operationName = self:_SplitOperationKey(row:GetContext())
	if not operationName then
		if self._contextTable.expandedModule == moduleName then
			self._contextTable.expandedModule = nil
		else
			self._contextTable.expandedModule = moduleName
		end
		self:Draw()
		self:SetSelectedOperation()
	else
		self:SetSelectedOperation(moduleName, operationName)
	end
end

function private.AddNewOnClick(button)
	local row = button:GetParentElement()
	local self = row:GetParentElement()
	local moduleName = row:GetContext()
	local operationName = "New Operation"
	local num = 1
	while TSM.Operations.Exists(moduleName, operationName.." "..num) do
		num = num + 1
	end
	operationName = operationName .. " " .. num
	self:_onOperationAddedHandler(moduleName, operationName)
	self:Draw()
	self:SetSelectedOperation(moduleName, operationName)
end

function private.RowOnEnter(frame)
	local self = frame:GetParentElement()
	if self._selected == frame then
		return
	end
	frame:GetElement("highlight"):Show()
end

function private.RowOnLeave(frame)
	local self = frame:GetParentElement()
	if self._selected == frame then
		return
	end
	frame:GetElement("highlight"):Hide()
end

function private.RowButtonOnEnter(frame)
	frame = frame:GetParentElement()
	local self = frame:GetParentElement()
	if self._selected == frame then
		return
	end
	frame:GetElement("highlight"):Show()
end

function private.RowButtonOnLeave(frame)
	frame = frame:GetParentElement()
	local self = frame:GetParentElement()
	if self._selected == frame then
		return
	end
	frame:GetElement("highlight"):Hide()
end

function private.CopyButtonOnClick(button)
	local row = button:GetParentElement():GetParentElement()
	local self = row:GetParentElement()
	local moduleName, operationName = self:_SplitOperationKey(row:GetContext())
	local num = 1
	while TSM.Operations.Exists(moduleName, operationName.." "..num) do
		num = num + 1
	end
	local newOperationName = operationName.." "..num
	self:_onOperationAddedHandler(moduleName, newOperationName, operationName)
	self:Draw()
	self:SetSelectedOperation(moduleName, newOperationName)
end

function private.DeleteButtonOnClick(button)
	local self = button:GetParentElement():GetParentElement():GetParentElement()
	self:_onOperationDeletedHandler(self:_SplitOperationKey(self._selectedOperation))
	self:Draw()
	self:SetSelectedOperation()
end
