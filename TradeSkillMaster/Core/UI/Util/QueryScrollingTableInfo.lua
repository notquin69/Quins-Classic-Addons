-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local QueryScrollingTableInfo = TSMAPI_FOUR.Class.DefineClass("QueryScrollingTableInfo")
TSM.UI.Util.QueryScrollingTableInfo = QueryScrollingTableInfo
local private = { recycledColInfo = {} }



-- ============================================================================
-- QueryScrollingTableColumnInfo Class
-- ============================================================================

local QueryScrollingTableColumnInfo = TSMAPI_FOUR.Class.DefineClass("QueryScrollingTableColumnInfo")

function QueryScrollingTableColumnInfo.__init(self)
	-- general
	self._tableInfo = nil
	self._id = nil
	self._tooltipLinkingDisabled = false
	-- style
	self._width = nil
	self._justifyH = nil
	self._iconSize = nil
	self._font = nil
	self._fontHeight = nil
	self._headerIndent = nil
	-- header
	self._titles = {}
	self._titleIcon = nil
	-- content fields and functions
	self._textField = nil
	self._textFunc = nil
	self._iconField = nil
	self._iconFunc = nil
	self._tooltipField = nil
	self._tooltipFunc = nil
	self._sortField = nil
end

function QueryScrollingTableColumnInfo._Acquire(self, tableInfo, id)
	self._tableInfo = tableInfo
	self._id = id
end

function QueryScrollingTableColumnInfo._Release(self)
	self._tableInfo = nil
	self._id = nil
	self._tooltipLinkingDisabled = false
	self._width = nil
	self._justifyH = nil
	self._iconSize = nil
	self._font = nil
	self._fontHeight = nil
	self._headerIndent = nil
	wipe(self._titles)
	self._titleIcon = nil
	self._textField = nil
	self._textFunc = nil
	self._iconField = nil
	self._iconFunc = nil
	self._tooltipField = nil
	self._tooltipFunc = nil
	self._sortField = nil
end

function QueryScrollingTableColumnInfo.SetTitles(self, ...)
	TSMAPI_FOUR.Util.VarargIntoTable(self._titles, ...)
	return self
end

function QueryScrollingTableColumnInfo.SetTitleIcon(self, icon)
	self._titleIcon = icon
	return self
end

function QueryScrollingTableColumnInfo.SetWidth(self, width)
	self._width = width
	return self
end

function QueryScrollingTableColumnInfo.SetJustifyH(self, justifyH)
	self._justifyH = justifyH
	return self
end

function QueryScrollingTableColumnInfo.SetIconSize(self, iconSize)
	self._iconSize = iconSize
	return self
end

function QueryScrollingTableColumnInfo.SetFont(self, font)
	self._font = font
	return self
end

function QueryScrollingTableColumnInfo.SetFontHeight(self, fontHeight)
	self._fontHeight = fontHeight
	return self
end

function QueryScrollingTableColumnInfo.SetHeaderIndent(self, headerIndent)
	self._headerIndent = headerIndent
	return self
end

function QueryScrollingTableColumnInfo.SetTextInfo(self, field, func)
	self._textField = field
	self._textFunc = func
	return self
end

function QueryScrollingTableColumnInfo.SetIconInfo(self, field, func)
	self._iconField = field
	self._iconFunc = func
	return self
end

function QueryScrollingTableColumnInfo.SetTooltipInfo(self, field, func)
	self._tooltipField = field
	self._tooltipFunc = func
	return self
end

function QueryScrollingTableColumnInfo.SetSortInfo(self, field)
	self._sortField = field
	return self
end

function QueryScrollingTableColumnInfo.SetTooltipLinkingDisabled(self, disabled)
	self._tooltipLinkingDisabled = disabled
	return self
end

function QueryScrollingTableColumnInfo.Commit(self)
	return self._tableInfo
end

function QueryScrollingTableColumnInfo._GetId(self)
	return self._id
end

function QueryScrollingTableColumnInfo._GetSortField(self)
	return self._sortField
end

function QueryScrollingTableColumnInfo._GetTitle(self)
	return self._titles[min(#self._titles, self._tableInfo._currentTitleIndex)]
end

function QueryScrollingTableColumnInfo._GetTitleIcon(self)
	return self._titleIcon
end

function QueryScrollingTableColumnInfo._GetWidth(self)
	return self._width
end

function QueryScrollingTableColumnInfo._GetJustifyH(self)
	return self._justifyH
end

function QueryScrollingTableColumnInfo._GetIconSize(self)
	return self._iconSize
end

function QueryScrollingTableColumnInfo._GetFont(self)
	return self._font
end

function QueryScrollingTableColumnInfo._GetFontHeight(self)
	return self._fontHeight
end

function QueryScrollingTableColumnInfo._GetHeaderIndent(self)
	return self._headerIndent
end

function QueryScrollingTableColumnInfo._GetValue(self, uuid, field, func)
	local row = self._tableInfo._element._query:GetResultRowByUUID(uuid)
	local context = nil
	if field then
		context = row:GetField(field)
	else
		context = row
	end
	if func then
		return func(context)
	else
		return context
	end
end

function QueryScrollingTableColumnInfo._GetText(self, uuid)
	return self:_GetValue(uuid, self._textField, self._textFunc)
end

function QueryScrollingTableColumnInfo._GetIcon(self, uuid)
	return self:_GetValue(uuid, self._iconField, self._iconFunc)
end

function QueryScrollingTableColumnInfo._HasTooltip(self)
	return (self._tooltipField or self._tooltipFunc) and true or false
end

function QueryScrollingTableColumnInfo._GetTooltip(self, uuid)
	return self:_GetValue(uuid, self._tooltipField, self._tooltipFunc)
end

function QueryScrollingTableColumnInfo._GetTooltipLinkingDisabled(self)
	return self._tooltipLinkingDisabled
end



-- ============================================================================
-- QueryScrollingTableInfo Class
-- ============================================================================

function QueryScrollingTableInfo.__init(self)
	self._cols = {}
	self._element = nil
	self._currentTitleIndex = 1
	self._maxTitleIndex = nil
	self._cursor = nil
end

function QueryScrollingTableInfo._Acquire(self, element)
	self._element = element
end

function QueryScrollingTableInfo._Release(self)
	for _, col in ipairs(self._cols) do
		col:_Release()
		tinsert(private.recycledColInfo, col)
	end
	wipe(self._cols)
	self._element = nil
	self._currentTitleIndex = 1
	self._maxTitleIndex = nil
	self._cursor = nil
end

function QueryScrollingTableInfo.NewColumn(self, id, prepend)
	local col = nil
	if #private.recycledColInfo > 0 then
		col = tremove(private.recycledColInfo)
	else
		col = QueryScrollingTableColumnInfo()
	end
	col:_Acquire(self, id)
	if prepend then
		tinsert(self._cols, 1, col)
	else
		tinsert(self._cols, col)
	end
	return col
end

function QueryScrollingTableInfo.RemoveColumn(self, id)
	local index = nil
	for i, col in ipairs(self._cols) do
		if col:_GetId() == id then
			assert(not index)
			index = i
		end
	end
	assert(index)
	local col = tremove(self._cols, index)
	col:_Release()
	tinsert(private.recycledColInfo, col)
	return self
end

function QueryScrollingTableInfo.SetCursor(self, cursor)
	self._cursor = cursor
	return self
end

function QueryScrollingTableInfo.Commit(self)
	for _, col in ipairs(self._cols) do
		local numTitles = #col._titles
		if numTitles > 1 then
			assert(not self._maxTitleIndex or numTitles == self._maxTitleIndex)
			self._maxTitleIndex = numTitles
		end
	end
	self._maxTitleIndex = self._maxTitleIndex or 1
	return self._element:CommitTableInfo()
end

function QueryScrollingTableInfo._GetCols(self)
	return self._cols
end

function QueryScrollingTableInfo._IsSortEnabled(self)
	for _, col in ipairs(self._cols) do
		if col:_GetSortField() then
			return true
		end
	end
	return false
end

function QueryScrollingTableInfo._GetSortFieldById(self, id)
	for _, col in ipairs(self._cols) do
		if col:_GetId() == id then
			return col:_GetSortField()
		end
	end
	error("Unknown id: "..tostring(id))
end

function QueryScrollingTableInfo._GetIdBySortField(self, field)
	for _, col in ipairs(self._cols) do
		if col:_GetSortField() == field then
			return col:_GetId()
		end
	end
	error("Unknown field: "..tostring(field))
end

function QueryScrollingTableInfo._UpdateTitleIndex(self)
	self._currentTitleIndex = self._currentTitleIndex + 1
	if self._currentTitleIndex > self._maxTitleIndex then
		self._currentTitleIndex = 1
	end
end

function QueryScrollingTableInfo._GetTitleIndex(self)
	return self._currentTitleIndex
end

function QueryScrollingTableInfo._GetCursor(self)
	return self._cursor
end
