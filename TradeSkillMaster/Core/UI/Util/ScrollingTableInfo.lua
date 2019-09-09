-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local ScrollingTableInfo = TSMAPI_FOUR.Class.DefineClass("ScrollingTableInfo")
TSM.UI.Util.ScrollingTableInfo = ScrollingTableInfo
local private = { recycledColInfo = {} }



-- ============================================================================
-- ScrollingTableColumnInfo Class
-- ============================================================================

local ScrollingTableColumnInfo = TSMAPI_FOUR.Class.DefineClass("ScrollingTableColumnInfo")

function ScrollingTableColumnInfo.__init(self)
	-- general
	self._tableInfo = nil
	self._id = nil
	self._element = nil
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
	-- content functions
	self._textFunc = nil
	self._iconFunc = nil
	self._tooltipFunc = nil
	self._sortValueFunc = nil
end

function ScrollingTableColumnInfo._Acquire(self, tableInfo, id, element)
	self._tableInfo = tableInfo
	self._id = id
	self._element = element
end

function ScrollingTableColumnInfo._Release(self)
	self._tableInfo = nil
	self._id = nil
	self._element = nil
	self._titleIcon = nil
	self._width = nil
	self._justifyH = nil
	self._iconSize = nil
	self._font = nil
	self._fontHeight = nil
	self._headerIndent = nil
	self._textFunc = nil
	self._iconFunc = nil
	self._sortValueFunc = nil
	self._tooltipFunc = nil
	self._tooltipLinkingDisabled = false
	wipe(self._titles)
end

function ScrollingTableColumnInfo.SetTitles(self, ...)
	TSMAPI_FOUR.Util.VarargIntoTable(self._titles, ...)
	return self
end

function ScrollingTableColumnInfo.SetTitleIcon(self, icon)
	self._titleIcon = icon
	return self
end

function ScrollingTableColumnInfo.SetWidth(self, width)
	self._width = width
	return self
end

function ScrollingTableColumnInfo.SetJustifyH(self, justifyH)
	self._justifyH = justifyH
	return self
end

function ScrollingTableColumnInfo.SetIconSize(self, iconSize)
	self._iconSize = iconSize
	return self
end

function ScrollingTableColumnInfo.SetFont(self, font)
	self._font = font
	return self
end

function ScrollingTableColumnInfo.SetFontHeight(self, fontHeight)
	self._fontHeight = fontHeight
	return self
end

function ScrollingTableColumnInfo.SetHeaderIndent(self, headerIndent)
	self._headerIndent = headerIndent
	return self
end

function ScrollingTableColumnInfo.SetTextFunction(self, func)
	self._textFunc = func
	return self
end

function ScrollingTableColumnInfo.SetIconFunction(self, func)
	self._iconFunc = func
	return self
end

function ScrollingTableColumnInfo.SetSortValueFunction(self, func)
	self._sortValueFunc = func
	return self
end

function ScrollingTableColumnInfo.SetTooltipFunction(self, func)
	self._tooltipFunc = func
	return self
end

function ScrollingTableColumnInfo.SetTooltipLinkingDisabled(self, disabled)
	self._tooltipLinkingDisabled = disabled
	return self
end

function ScrollingTableColumnInfo.Commit(self)
	return self._tableInfo
end

function ScrollingTableColumnInfo._GetId(self)
	return self._id
end

function ScrollingTableColumnInfo._GetTitle(self)
	return self._titles[min(#self._titles, self._tableInfo._currentTitleIndex)]
end

function ScrollingTableColumnInfo._GetTitleIcon(self)
	return self._titleIcon
end

function ScrollingTableColumnInfo._GetWidth(self)
	return self._width
end

function ScrollingTableColumnInfo._GetJustifyH(self)
	return self._justifyH
end

function ScrollingTableColumnInfo._GetIconSize(self)
	return self._iconSize
end

function ScrollingTableColumnInfo._GetFont(self)
	return self._font
end

function ScrollingTableColumnInfo._GetFontHeight(self)
	return self._fontHeight
end

function ScrollingTableColumnInfo._GetHeaderIndent(self)
	return self._headerIndent
end

function ScrollingTableColumnInfo._HasText(self, context)
	return self._textFunc and true or false
end

function ScrollingTableColumnInfo._GetText(self, context)
	return self._textFunc and self._textFunc(self._element, context, min(#self._titles, self._tableInfo._currentTitleIndex)) or ""
end

function ScrollingTableColumnInfo._GetIcon(self, context)
	return self._iconFunc(self._element, context)
end

function ScrollingTableColumnInfo._GetSortValue(self, context)
	return self._sortValueFunc(self._element, context, min(#self._titles, self._tableInfo._currentTitleIndex))
end

function ScrollingTableColumnInfo._HasTooltip(self, context)
	return self._tooltipFunc and true or false
end

function ScrollingTableColumnInfo._GetTooltip(self, context)
	return self._tooltipFunc and self._tooltipFunc(self._element, context) or nil
end

function ScrollingTableColumnInfo._GetTooltipLinkingDisabled(self)
	return self._tooltipLinkingDisabled
end



-- ============================================================================
-- ScrollingTableInfo Class
-- ============================================================================

function ScrollingTableInfo.__init(self)
	self._cols = {}
	self._element = nil
	self._sortDefaultKey = nil
	self._sortDefaultAscending = nil
	self._currentTitleIndex = 1
	self._maxTitleIndex = nil
	self._cursor = nil
end

function ScrollingTableInfo._Acquire(self, element)
	self._element = element
end

function ScrollingTableInfo._Release(self)
	for _, col in ipairs(self._cols) do
		col:_Release()
		tinsert(private.recycledColInfo, col)
	end
	wipe(self._cols)
	self._element = nil
	self._sortDefaultKey = nil
	self._sortDefaultAscending = nil
	self._currentTitleIndex = 1
	self._maxTitleIndex = nil
	self._cursor = nil
end

function ScrollingTableInfo.NewColumn(self, id, prepend)
	local col = nil
	if #private.recycledColInfo > 0 then
		col = tremove(private.recycledColInfo)
	else
		col = ScrollingTableColumnInfo()
	end
	col:_Acquire(self, id, self._element)
	if prepend then
		tinsert(self._cols, 1, col)
	else
		tinsert(self._cols, col)
	end
	return col
end

function ScrollingTableInfo.RemoveColumn(self, id, prepend)
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

function ScrollingTableInfo.SetDefaultSort(self, key, ascending)
	self._sortDefaultKey = key
	self._sortDefaultAscending = ascending
	return self
end

function ScrollingTableInfo.SetCursor(self, cursor)
	self._cursor = cursor
	return self
end

function ScrollingTableInfo.Commit(self)
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

function ScrollingTableInfo._GetCols(self)
	return self._cols
end

function ScrollingTableInfo._GetSortInfo(self)
	return self._sortDefaultKey, self._sortDefaultAscending
end

function ScrollingTableInfo._GetSortColById(self, id)
	for _, col in ipairs(self._cols) do
		if col:_GetId() == id then
			return col
		end
	end
	error("Unknown id: "..tostring(id))
end

function ScrollingTableInfo._UpdateTitleIndex(self)
	self._currentTitleIndex = self._currentTitleIndex + 1
	if self._currentTitleIndex > self._maxTitleIndex then
		self._currentTitleIndex = 1
	end
end

function ScrollingTableInfo._GetTitleIndex(self)
	return self._currentTitleIndex
end

function ScrollingTableInfo._GetCursor(self)
	return self._cursor
end
