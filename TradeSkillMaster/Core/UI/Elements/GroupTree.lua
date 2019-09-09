-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- GroupTree UI Element Class.
-- A group tree is an abstract element which displays TSM groups. It is a subclass of the @{FastScrollingList} class.
-- @classmod GroupTree

local _, TSM = ...
local GroupTree = TSMAPI_FOUR.Class.DefineClass("GroupTree", TSM.UI.FastScrollingList, "ABSTRACT")
TSM.UI.GroupTree = GroupTree
local private = { rowFrameLookup = {} }
local COLOR_WIDTH = 6
local COLOR_PADDING_LEFT = 2
local COLOR_PADDING_TOP_BOTTOM = 2
local EXPANDER_PADDING_LEFT = 4
local HEADER_INDENT = 8



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function GroupTree.__init(self)
	self.__super:__init()

	self._allData = {}
	self._defaultContextTbl = { collapsed = {} }
	self._contextTbl = self._defaultContextTbl
	self._hasChildrenLookup = {}
	self._headerNameLookup = {}
	self._groupFunc = nil
	self._searchStr = ""
end

function GroupTree.Release(self)
	wipe(self._allData)
	self._groupFunc = nil
	self._searchStr = ""
	wipe(self._defaultContextTbl.collapsed)
	self._contextTbl = self._defaultContextTbl
	wipe(self._hasChildrenLookup)
	wipe(self._headerNameLookup)
	for _, row in ipairs(self._rows) do
		row._frame:SetScript("OnClick", nil)
		row._frame:SetScript("OnEnter", nil)
		row._frame:SetScript("OnLeave", nil)
		private.rowFrameLookup[row._frame] = nil
	end
	self.__super:Release()
end

--- Sets the context table.
-- This table can be used to preserve collapsed state across lifecycles of the group tree and even WoW sessions if it's
-- within the settings DB.
-- @tparam GroupTree self The group tree object
-- @tparam table tbl The context table
-- @treturn GroupTree The group tree object
function GroupTree.SetContextTable(self, tbl)
	if tbl then
		tbl.collapsed = tbl.collapsed or {}
		self._contextTbl = tbl
	else
		self._contextTbl = self._defaultContextTbl
		wipe(self._contextTbl)
	end
	self:_UpdateData()
	return self
end

--- Sets the group list function.
-- @tparam GroupTree self The group tree object
-- @tparam function groupFunc A function which tables groups table and a headerNameLookup table and populates them
-- @treturn GroupTree The group tree object
function GroupTree.SetGroupListFunc(self, groupFunc)
	self._groupFunc = groupFunc
	self:_UpdateData()
	return self
end

function GroupTree.SetScript(self, script, handler)
	-- GroupTree doesn't support any scripts
	error("Unknown GroupTree script: "..tostring(script))
	return self
end

--- Sets the search string.
-- This search string is used to filter the groups which are displayed in the group tree.
-- @tparam GroupTree self The group tree object
-- @tparam string searchStr The search string which filters the displayed groups
-- @treturn GroupTree The group tree object
function GroupTree.SetSearchString(self, searchStr)
	self._searchStr = TSMAPI_FOUR.Util.StrEscape(searchStr)
	self:_UpdateData()
	return self
end

--- Forces an update of the group data.
-- @tparam GroupTree self The group tree object
-- @tparam[opt=false] bool redraw Whether or not to redraw the group tree
-- @treturn GroupTree The group tree object
function GroupTree.UpdateData(self, redraw)
	self:_UpdateData()
	if redraw then
		self:Draw()
	end
	return self
end

--- Expand every group.
-- @tparam GroupTree self The application group tree object
-- @treturn GroupTree The application group tree object
function GroupTree.ExpandAll(self)
	for _, groupPath in ipairs(self._allData) do
		if groupPath ~= TSM.CONST.ROOT_GROUP_PATH and self._hasChildrenLookup[groupPath] and self._contextTbl.collapsed[groupPath] then
			self:_SetCollapsed(groupPath, false)
		end
	end
	for _, row in ipairs(self._rows) do
		local groupPath = row:GetData()
		if groupPath ~= TSM.CONST.ROOT_GROUP_PATH and self._hasChildrenLookup[groupPath] then
			local scrollingList = row._scrollingList
			scrollingList:_UpdateData()
			scrollingList:Draw()
		end
	end
	return self
end

--- Collapse every group.
-- @tparam GroupTree self The application group tree object
-- @treturn GroupTree The application group tree object
function GroupTree.CollapseAll(self)
	for _, groupPath in ipairs(self._allData) do
		if groupPath ~= TSM.CONST.ROOT_GROUP_PATH and self._hasChildrenLookup[groupPath] and not self._contextTbl.collapsed[groupPath] then
			self:_SetCollapsed(groupPath, true)
		end
	end
	for _, row in ipairs(self._rows) do
		local groupPath = row:GetData()
		if groupPath ~= TSM.CONST.ROOT_GROUP_PATH and self._hasChildrenLookup[groupPath] then
			local scrollingList = row._scrollingList
			scrollingList:_UpdateData()
			scrollingList:Draw()
		end
	end
	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function GroupTree._UpdateData(self)
	-- update our groups list
	wipe(self._hasChildrenLookup)
	wipe(self._allData)
	wipe(self._data)
	local groups = TSMAPI_FOUR.Util.AcquireTempTable()
	self._groupFunc(groups, self._headerNameLookup)

	for i, groupPath in ipairs(groups) do
		tinsert(self._allData, groupPath)
		if not self:_IsGroupHidden(groupPath) then
			local groupName = TSM.Groups.Path.GetName(groupPath)
			groupName = self._headerNameLookup[groupPath] or groupName
			if strmatch(strlower(groupName), self._searchStr) then
				tinsert(self._data, groupPath)
			end
		end
		local nextGroupPath = groups[i + 1]
		self._hasChildrenLookup[groupPath] = nextGroupPath and TSM.Groups.Path.IsChild(nextGroupPath, groupPath) or nil
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(groups)
end

function GroupTree._GetListRow(self)
	local row = self.__super:_GetListRow()
	row._frame:SetScript("OnClick", private.RowOnClick)
	row._frame:SetScript("OnEnter", private.RowOnEnter)
	row._frame:SetScript("OnLeave", private.RowOnLeave)
	private.rowFrameLookup[row._frame] = row

	local text = row:_GetFontString()
	text:SetPoint("LEFT", 0, 0)
	text:SetPoint("TOPRIGHT")
	text:SetPoint("BOTTOMRIGHT")
	text:SetFont(self:_GetStyle("font"), self:_GetStyle("fontHeight"))
	text:SetJustifyH("LEFT")
	text:SetJustifyV("MIDDLE")
	row._texts.text = text

	local color = row:_GetTexture()
	color:SetPoint("TOPLEFT", COLOR_PADDING_LEFT, -COLOR_PADDING_TOP_BOTTOM)
	color:SetPoint("BOTTOMLEFT", COLOR_PADDING_LEFT, COLOR_PADDING_TOP_BOTTOM)
	color:SetWidth(COLOR_WIDTH)
	row._icons.color = color

	local expander = row:_GetTexture()
	expander:SetDrawLayer("ARTWORK", 2)
	expander:SetPoint("RIGHT", text, "LEFT")
	row._icons.expander = expander

	local expanderBtn = row:_GetButton()
	expanderBtn:SetAllPoints(expander)
	expanderBtn:SetScript("OnClick", private.ExpanderOnClick)
	expanderBtn:SetScript("OnEnter", private.ExpanderOnEnter)
	expanderBtn:SetScript("OnLeave", private.ExpanderOnLeave)
	row._buttons.expanderBtn = expanderBtn
	return row
end

function GroupTree._SetRowData(self, row, data)
	local color = row._icons.color
	local text = row._texts.text
	local indentWidth = nil
	if data == TSM.CONST.ROOT_GROUP_PATH then
		indentWidth = HEADER_INDENT
		color:Hide()
		text:SetTextColor(1, 1, 1, 1)
	else
		local level = select('#', strsplit(TSM.CONST.GROUP_SEP, data))
		indentWidth = (level - 1) * self:_GetStyle("treeIndentWidth") + COLOR_WIDTH + COLOR_PADDING_LEFT + EXPANDER_PADDING_LEFT + TSM.UI.TexturePacks.GetWidth(self:_GetStyle("expanderCollapsedBackgroundTexturePack"))
		if self:_IsSelected(data) or row:IsMouseOver() then
			color:SetColorTexture(TSM.UI.HexToRGBA(TSM.UI.GetGroupLevelColor(level)))
		else
			color:SetColorTexture(TSM.UI.HexToRGBA("#2e2e2e"))
		end
		color:Show()
		text:SetTextColor(TSM.UI.HexToRGBA(TSM.UI.GetGroupLevelColor(level)))
	end

	local lastPart = TSM.Groups.Path.GetName(data)
	text:SetText(data == TSM.CONST.ROOT_GROUP_PATH and self._headerNameLookup[data] or lastPart)
	text:SetPoint("LEFT", indentWidth, 0)

	local expander = row._icons.expander
	if data ~= TSM.CONST.ROOT_GROUP_PATH and self._hasChildrenLookup[data] then
		TSM.UI.TexturePacks.SetTextureAndSize(expander, self:_GetStyle(self._contextTbl.collapsed[data] and "expanderCollapsedBackgroundTexturePack" or "expanderExpandedBackgroundTexturePack"))
		expander:Show()
	else
		expander:Hide()
	end

	self.__super:_SetRowData(row, data)
	if self:_IsSelected(data) and not row:IsMouseOver() then
		row:SetHighlightState("selected")
	end
end

function GroupTree._IsGroupHidden(self, data)
	if data == TSM.CONST.ROOT_GROUP_PATH then
		return false
	elseif self._contextTbl.collapsed[TSM.CONST.ROOT_GROUP_PATH] then
		return true
	end
	local parent = TSM.Groups.Path.GetParent(data)
	while parent and parent ~= TSM.CONST.ROOT_GROUP_PATH do
		if self._contextTbl.collapsed[parent] then
			return true
		end
		parent = TSM.Groups.Path.GetParent(parent)
	end
	return false
end

function GroupTree._SetCollapsed(self, data, collapsed)
	self._contextTbl.collapsed[data] = collapsed or nil
end

function GroupTree._IsSelected(self, data)
	return false
end

function GroupTree._HandleRowClick(self, data)
	-- this should be overridden
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.RowOnClick(frame)
	local self = private.rowFrameLookup[frame]
	self._scrollingList:_HandleRowClick(self:GetData())
end

function private.RowOnEnter(frame)
	local self = private.rowFrameLookup[frame]
	local groupPath = self:GetData()
	if groupPath ~= TSM.CONST.ROOT_GROUP_PATH then
		local level = select('#', strsplit(TSM.CONST.GROUP_SEP, groupPath))
		self._icons.color:SetColorTexture(TSM.UI.HexToRGBA(TSM.UI.GetGroupLevelColor(level)))
	end
	self:SetHighlightState("hover")
end

function private.RowOnLeave(frame)
	local self = private.rowFrameLookup[frame]
	if self._scrollingList:_IsSelected(self:GetData()) then
		self:SetHighlightState("selected")
	else
		self._icons.color:SetColorTexture(TSM.UI.HexToRGBA("#2e2e2e"))
		self:SetHighlightState()
	end
end

function private.ExpanderOnClick(button)
	local row = private.rowFrameLookup[button:GetParent()]
	local scrollingList = row._scrollingList
	scrollingList:_SetCollapsed(row:GetData(), not scrollingList._contextTbl.collapsed[row:GetData()])
	scrollingList:_UpdateData()
	scrollingList:Draw()
end

function private.ExpanderOnEnter(button)
	local row = button:GetParent()
	row:GetScript("OnEnter")(row)
end

function private.ExpanderOnLeave(button)
	local row = button:GetParent()
	row:GetScript("OnLeave")(row)
end
