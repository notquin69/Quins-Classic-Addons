-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- ManagementGroupTree UI Element Class.
-- The management group tree allows for moving, adding, and deleting groups. It also only allows for a single group to
-- be selected. It is a subclass of the @{GroupTree} class.
-- @classmod ManagementGroupTree

local _, TSM = ...
local L = TSM.L
local ManagementGroupTree = TSMAPI_FOUR.Class.DefineClass("ManagementGroupTree", TSM.UI.GroupTree)
TSM.UI.ManagementGroupTree = ManagementGroupTree
local private = { rowFrameLookup = {} }
local SCROLLBAR_WIDTH = 16
local DRAG_SCROLL_SPEED_FACTOR = 12



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ManagementGroupTree.__init(self)
	self.__super:__init()

	self._selectedGroup = nil
	self._onGroupSelectedHandler = nil
	self._scrollAmount = 0
end

function ManagementGroupTree.Acquire(self)
	self._moveFrame = TSMAPI_FOUR.UI.NewElement("Frame", self._id.."_MoveFrame")
		:SetStyle("strata", "TOOLTIP")
		:SetLayout("VERTICAL")
		:SetContext(self)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
		)
	self._moveFrame:SetParent(self:_GetBaseFrame())
	self._moveFrame:Hide()
	self._moveFrame:SetScript("OnShow", private.MoveFrameOnShow)
	self._moveFrame:SetScript("OnUpdate", private.MoveFrameOnUpdate)
	self._selectedRowFrame = TSMAPI_FOUR.UI.NewElement("Frame", self._id.."_SelectedRowIcons")
		:SetLayout("HORIZONTAL")
		:SetContext(self)
		:SetStyle("anchors", { { "TOPLEFT", nil, "TOPLEFT", 0, 0 }, { "BOTTOMRIGHT" } })
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "moveIcon")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "spacer")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "plusButton")
			:SetScript("OnClick", private.PlusButtonOnClick)
			:SetScript("OnDragStart", TSM.UI.GetPropagateScriptFunc("OnDragStart"))
			:SetScript("OnDragStop", TSM.UI.GetPropagateScriptFunc("OnDragStop"))
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "deleteButton")
			:SetScript("OnClick", private.DeleteButtonOnClick)
			:SetScript("OnDragStart", TSM.UI.GetPropagateScriptFunc("OnDragStart"))
			:SetScript("OnDragStop", TSM.UI.GetPropagateScriptFunc("OnDragStop"))
		)
		:SetScript("OnDragStart", private.SelectedRowOnDragStart)
		:SetScript("OnDragStop", private.SelectedRowOnDragStop)
	self._selectedRowFrame:RegisterForDrag("LeftButton")
	self._selectedRowFrame:GetElement("plusButton"):RegisterForDrag("LeftButton")
	self._selectedRowFrame:GetElement("deleteButton"):RegisterForDrag("LeftButton")

	self.__super:Acquire()
end

function ManagementGroupTree.Release(self)
	self._selectedGroup = nil
	self._onGroupSelectedHandler = nil
	self._selectedRowFrame:Release()
	self._selectedRowFrame = nil
	self._moveFrame:Release()
	self._moveFrame = nil
	for _, row in ipairs(self._rows) do
		row._frame:RegisterForDrag()
		row._frame:SetScript("OnDragStart", nil)
		row._frame:SetScript("OnDragStop", nil)
		private.rowFrameLookup[row._frame] = nil
	end
	self.__super:Release()
end

--- Sets the selected group.
-- @tparam ManagementGroupTree self The management group tree object
-- @tparam string groupPath The selected group's path
-- @tparam boolean redraw Whether or not to redraw the management group tree
-- @treturn ManagementGroupTree The management group tree object
function ManagementGroupTree.SetSelectedGroup(self, groupPath, redraw)
	self._selectedGroup = groupPath
	if self._onGroupSelectedHandler then
		self:_onGroupSelectedHandler(groupPath)
	end
	if redraw then
		-- make sure this group is visible (its parent is expanded)
		local parent = TSM.Groups.Path.GetParent(groupPath)
		self._contextTbl.collapsed[TSM.CONST.ROOT_GROUP_PATH] = nil
		while parent and parent ~= TSM.CONST.ROOT_GROUP_PATH do
			self._contextTbl.collapsed[parent] = nil
			parent = TSM.Groups.Path.GetParent(parent)
		end
		self:_UpdateData()
		self:Draw()
		self:_ScrollToData(self._selectedGroup)
	end
	return self
end

--- Registers a script handler.
-- @tparam ManagementGroupTree self The management group tree object
-- @tparam string script The script to register for (supported scripts: `OnGroupSelected`)
-- @tparam function handler The script handler which will be called with the management group tree object followed by
-- any arguments to the script
-- @treturn ManagementGroupTree The management group tree object
function ManagementGroupTree.SetScript(self, script, handler)
	if script == "OnGroupSelected" then
		self._onGroupSelectedHandler = handler
	else
		error("Unknown ManagementGroupTree script: "..tostring(script))
	end
	return self
end

function ManagementGroupTree.Draw(self)
	self._selectedRowFrame:GetElement("moveIcon"):SetStyle("backgroundTexturePack", self:_GetStyle("moveBackgroundTexturePack"))
	self._selectedRowFrame:GetElement("plusButton"):SetStyle("backgroundTexturePack", self:_GetStyle("plusBackgroundTexturePack"))
	self._selectedRowFrame:GetElement("deleteButton"):SetStyle("backgroundTexturePack", self:_GetStyle("deleteBackgroundTexturePack"))
	self.__super:Draw()
	self:_UpdateSelectedRowIcons()
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ManagementGroupTree._GetListRow(self)
	local row = self.__super:_GetListRow()
	private.rowFrameLookup[row._frame] = row
	row._frame:RegisterForDrag("LeftButton")
	row._frame:SetScript("OnDragStart", private.RowOnDragStart)
	row._frame:SetScript("OnDragStop", private.RowOnDragStop)
	return row
end

function ManagementGroupTree._SetRowData(self, row, data)
	self.__super:_SetRowData(row, data)
	local text = row._texts.text
	if data == self._selectedGroup then
		local minSelectedFrameWidth = self:_GetStyle("selectedRowButtonSize") * 4 + self:_GetStyle("selectedRowIconPadding") * 3 + SCROLLBAR_WIDTH + 23
		text:SetPoint("TOPRIGHT", -minSelectedFrameWidth, 0)
		text:SetPoint("BOTTOMRIGHT", -minSelectedFrameWidth, 0)
	else
		text:SetPoint("TOPRIGHT")
		text:SetPoint("BOTTOMRIGHT")
	end
end

function ManagementGroupTree._UpdateSelectedRowIcons(self)
	local selectedRow = nil
	for _, row in ipairs(self._rows) do
		if row:GetData() == self._selectedGroup then
			selectedRow = row
			break
		end
	end
	local currentParentRow = self._selectedRowFrame:GetParentElement()
	if currentParentRow then
		currentParentRow:RemoveChild(self._selectedRowFrame)
	end
	if selectedRow then
		self._selectedRowFrame:SetParent(selectedRow._frame)
		local text = selectedRow._texts.text
		local iconSize = self:_GetStyle("selectedRowButtonSize")
		local horizontalPadding = self:_GetStyle("selectedRowIconPadding")
		self._selectedRowFrame:_GetStyle("anchors")[1][2] = text
		self._selectedRowFrame:_GetStyle("anchors")[1][3] = min(text:GetStringWidth(), text:GetWidth()) + horizontalPadding
		if self._selectedGroup == TSM.CONST.ROOT_GROUP_PATH then
			-- hide the delete button for the root group
			self._selectedRowFrame:GetElement("plusButton")
				:SetStyle("width", iconSize)
				:SetStyle("height", iconSize)
				:SetStyle("margin", { right = SCROLLBAR_WIDTH })
			self._selectedRowFrame:GetElement("deleteButton"):Hide()
			self._selectedRowFrame:GetElement("moveIcon"):Hide()
		else
			self._selectedRowFrame:GetElement("plusButton")
				:SetStyle("width", iconSize)
				:SetStyle("height", iconSize)
				:SetStyle("margin", { right = horizontalPadding })
			self._selectedRowFrame:GetElement("deleteButton")
				:SetStyle("width", iconSize)
				:SetStyle("height", iconSize)
				:SetStyle("margin", { right = SCROLLBAR_WIDTH })
				:Show()
			self._selectedRowFrame:GetElement("moveIcon")
				:SetStyle("width", iconSize)
				:SetStyle("height", iconSize)
				:Show()
		end
		self._selectedRowFrame:Show()
		self._selectedRowFrame:Draw()
	else
		self._selectedRowFrame:Hide()
	end
end

function ManagementGroupTree._SetCollapsed(self, data, collapsed)
	self.__super:_SetCollapsed(data, collapsed)
	if collapsed and self._selectedGroup ~= data and strmatch(self._selectedGroup, "^"..TSMAPI_FOUR.Util.StrEscape(data)) then
		-- we collapsed a parent of the selected group, so select the group we just collapsed instead
		self:SetSelectedGroup(data, true)
	end
end

function ManagementGroupTree._IsSelected(self, data)
	return data == self._selectedGroup
end

function ManagementGroupTree._HandleRowClick(self, data)
	self:SetSelectedGroup(data, true)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.MoveFrameOnShow(frame)
	local self = frame:GetContext()
	self._scrollAmount = 0
end

function private.MoveFrameOnUpdate(frame)
	local self = frame:GetContext()
	local uiScale = UIParent:GetEffectiveScale()
	local x, y = GetCursorPosition()
	x = x / uiScale
	y = y / uiScale
	frame:_GetBaseFrame():SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)

	-- figure out if we're above or below the frame for scrolling while dragging
	local top = self:_GetBaseFrame():GetTop()
	local bottom = self:_GetBaseFrame():GetBottom()
	if y > top then
		self._scrollAmount = top - y
	elseif y < bottom then
		self._scrollAmount = bottom - y
	else
		self._scrollAmount = 0
	end

	self._scrollbar:SetValue(self._scrollbar:GetValue() + self._scrollAmount / DRAG_SCROLL_SPEED_FACTOR)
end

function private.PlusButtonOnClick(button)
	local self = button:GetParentElement():GetContext()
	local newGroupPath = TSM.Groups.Path.Join(self._selectedGroup, L["New Group"])
	if TSM.Groups.Exists(newGroupPath) then
		local num = 1
		while TSM.Groups.Exists(newGroupPath.." "..num) do
			num = num + 1
		end
		newGroupPath = newGroupPath.." "..num
	end
	TSM.Groups.Create(newGroupPath)
	TSM.Analytics.Action("CREATED_GROUP", newGroupPath)
	self:SetSelectedGroup(newGroupPath, true)
end

function private.DeleteButtonOnClick(button)
	local self = button:GetParentElement():GetContext()
	self:GetBaseElement():ShowConfirmationDialog(L["Are you sure you want to delete this group?"], L["Doing so will also remove any sub-groups attached to this group."], strupper(DELETE), private.DeleteConfirmed, self)
end

function private.DeleteConfirmed(self)
	TSM.Groups.Delete(self._selectedGroup)
	TSM.Analytics.Action("DELETED_GROUP", self._selectedGroup)
	self:SetSelectedGroup(TSM.CONST.ROOT_GROUP_PATH, true)
end

function private.SelectedRowOnDragStart(selectedRow, ...)
	local rowFrame = selectedRow:_GetBaseFrame():GetParent()
	rowFrame:GetScript("OnDragStart")(rowFrame, ...)
end

function private.SelectedRowOnDragStop(selectedRow, ...)
	local rowFrame = selectedRow:_GetBaseFrame():GetParent()
	rowFrame:GetScript("OnDragStop")(rowFrame, ...)
end

function private.RowOnDragStart(frame)
	local self = private.rowFrameLookup[frame]
	local scrollingList = self._scrollingList
	local groupPath = self:GetData()
	if groupPath == TSM.CONST.ROOT_GROUP_PATH then
		-- don't do anything for the root group
		return
	end
	local text = self._texts.text
	scrollingList._dragGroupPath = groupPath
	scrollingList._moveFrame:Show()
	scrollingList._moveFrame:SetStyle("height", scrollingList:_GetStyle("rowHeight"))
	local moveFrameText = scrollingList._moveFrame:GetElement("text")
	moveFrameText:SetStyle("justifyH", "CENTER")
	moveFrameText:SetStyle("textColor", scrollingList:_GetStyle("dragTextColor"))
	local font, fontHeight = text:GetFont()
	moveFrameText:SetStyle("font", font)
	moveFrameText:SetStyle("fontHeight", fontHeight)
	moveFrameText:SetText(TSM.Groups.Path.GetName(groupPath))
	scrollingList._moveFrame:SetStyle("width", text:GetStringWidth() + scrollingList:_GetStyle("moveFramePadding"))
	scrollingList._moveFrame:Draw()
end

function private.RowOnDragStop(frame)
	local self = private.rowFrameLookup[frame]
	local scrollingList = self._scrollingList
	local groupPath = self:GetData()
	if groupPath == TSM.CONST.ROOT_GROUP_PATH then
		-- don't do anything for the root group
		return
	end
	scrollingList._moveFrame:Hide()

	local destPath = nil
	for _, row in ipairs(scrollingList._rows) do
		if row:IsMouseOver() then
			destPath = row:GetData()
			break
		end
	end
	local oldPath = scrollingList._dragGroupPath
	scrollingList._dragGroupPath = nil
	if not destPath or destPath == oldPath or TSM.Groups.Path.IsChild(destPath, oldPath) then
		return
	end
	local newPath = TSM.Groups.Path.Join(destPath, TSM.Groups.Path.GetName(oldPath))
	if oldPath == newPath then
		return
	elseif TSM.Groups.Exists(newPath) then
		return
	end

	TSM.Groups.Move(oldPath, newPath)
	TSM.Analytics.Action("MOVED_GROUP", oldPath, newPath)
	scrollingList:SetSelectedGroup(newPath, true)
end
