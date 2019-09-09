-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local ImportConfirmationList = TSMAPI_FOUR.Class.DefineClass("ImportConfirmationList", TSM.UI.FastScrollingList)
local L = TSM.L
TSM.UI.ImportConfirmationList = ImportConfirmationList
local private = { rowFrameLookup = {} }
local EXPANDER_PADDING_LEFT = 7
local CATEGORY_EXPANDER_PADDING_LEFT = 23
local TEXT_PADDING_RIGHT = 38
local HEADER_TEXT_PADDING = 29
local CATEGORY_TEXT_PADDING = 48
local ITEM_TEXT_PADDING = 66
local REMOVE_BTN_RIGHT_PADDING = 12
local DATA_SEP = "\001"



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ImportConfirmationList.__init(self)
	self.__super:__init()
	self._import = nil
	self._numChildren = {}
	self._collapsed = {}
end


function ImportConfirmationList.Release(self)
	self._import = nil
	wipe(self._numChildren)
	wipe(self._collapsed)
	for _, row in ipairs(self._rows) do
		private.rowFrameLookup[row._frame] = nil
	end
	self.__super:Release()
end


function ImportConfirmationList.SetImport(self, import)
	self._import = import
	self:_UpdateData()
	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ImportConfirmationList._UpdateData(self)
	wipe(self._data)
	wipe(self._numChildren)

	-- add the groups
	for _, groupPath in self._import:GroupIterator() do
		-- add the group header
		local groupHeader = GROUP..": "..TSM.Groups.Path.Format(groupPath)
		tinsert(self._data, groupHeader)

		if not self._collapsed[groupHeader] then
			-- add the items category and items
			local itemsCategory = groupPath..DATA_SEP..L["Items"]
			tinsert(self._data, itemsCategory)
			local numItems = 0
			for _, itemString in self._import:GroupItemIterator(groupPath) do
				if not self._collapsed[itemsCategory] then
					tinsert(self._data, itemsCategory..DATA_SEP..itemString)
				end
				numItems = numItems + 1
			end
			if numItems > 0 then
				self._numChildren[itemsCategory] = numItems
			else
				-- remove this category
				tremove(self._data)
			end

			-- add the operations categories and operations
			for _, moduleName in TSM.Operations.ModuleIterator() do
				local moduleOperationsCategory = groupPath..DATA_SEP..format(L["%s Operations"], moduleName)
				tinsert(self._data, moduleOperationsCategory)
				local numOperations = 0
				for _, operationName in self._import:GroupModuleOperationIterator(groupPath, moduleName) do
					if not self._collapsed[moduleOperationsCategory] then
						tinsert(self._data, moduleOperationsCategory..DATA_SEP..operationName)
					end
					numOperations = numOperations + 1
				end
				if numOperations > 0 then
					self._numChildren[moduleOperationsCategory] = numOperations
				else
					-- remove this category
					tremove(self._data)
				end
			end
		end
	end

	-- add the operations
	for _, moduleName in TSM.Operations.ModuleIterator() do
		-- add the operation header
		local operationHeader = format(L["%s Operations"], moduleName)
		tinsert(self._data, operationHeader)
		local numOperations = 0
		for _, operationName in self._import:ModuleOperationIterator(moduleName) do
			if not self._collapsed[operationHeader] then
				tinsert(self._data, operationHeader..DATA_SEP..operationName)
			end
			numOperations = numOperations + 1
		end
		if numOperations > 0 then
			self._numChildren[operationHeader] = numOperations
		else
			-- remove this category
			tremove(self._data)
		end
	end
end

function ImportConfirmationList._GetListRow(self)
	local row = self.__super:_GetListRow()
	private.rowFrameLookup[row._frame] = row

	local expander = row:_GetTexture()
	expander:SetDrawLayer("ARTWORK", 2)
	expander:SetPoint("LEFT", EXPANDER_PADDING_LEFT, 0)
	row._icons.expander = expander

	local expanderBtn = row:_GetButton()
	expanderBtn:SetAllPoints(expander)
	expanderBtn:SetScript("OnEnter", private.ExpanderBtnOnEnter)
	expanderBtn:SetScript("OnLeave", private.ExpanderBtnOnLeave)
	expanderBtn:SetScript("OnClick", private.ExpanderBtnOnClick)
	row._buttons.expander = expanderBtn

	local text = row:_GetFontString()
	text:SetPoint("LEFT", 0, 0)
	text:SetPoint("TOPRIGHT", -TEXT_PADDING_RIGHT, 0)
	text:SetPoint("BOTTOMRIGHT", -TEXT_PADDING_RIGHT, 0)
	text:SetJustifyH("LEFT")
	text:SetJustifyV("MIDDLE")
	row._texts.text = text

	-- add the remove button before the first col
	local remove = row:_GetTexture()
	TSM.UI.TexturePacks.SetTextureAndSize(remove, "iconPack.14x14/Close/Default")
	remove:SetPoint("RIGHT", -REMOVE_BTN_RIGHT_PADDING, 0)
	row._icons.remove = remove

	local removeBtn = row:_GetButton()
	removeBtn:SetAllPoints(remove)
	removeBtn:SetScript("OnEnter", private.RemoveBtnOnEnter)
	removeBtn:SetScript("OnLeave", private.RemoveBtnOnLeave)
	removeBtn:SetScript("OnClick", private.RemoveBtnOnClick)
	row._buttons.remove = removeBtn

	return row
end

function ImportConfirmationList._SetRowData(self, row, data)
	local header, category, item = strsplit(DATA_SEP, data)

	local text = row._texts.text
	text:SetFont(self:_GetStyle(category and "regularFont" or "headerFont"), self:_GetStyle(category and "regularFontHeight" or "headerFontHeight"))
	text:SetPoint("LEFT", (item and ITEM_TEXT_PADDING) or (category and CATEGORY_TEXT_PADDING) or HEADER_TEXT_PADDING, 0)
	if item and category == L["Items"] then
		text:SetText(TSM.UI.GetColoredItemName(item))
	elseif item then
		text:SetText(item)
	else
		local textStr = category or header
		if self._numChildren[data] then
			textStr = textStr.." |cffffd839("..self._numChildren[data]..")|r"
		end
		text:SetText(textStr)
	end

	local expander = row._icons.expander
	if self._numChildren[data] or not category then
		local texturePack = self:_GetStyle(self._collapsed[data] and "expanderCollapsedBackgroundTexturePack" or "expanderExpandedBackgroundTexturePack")
		TSM.UI.TexturePacks.SetTextureAndSize(expander, texturePack)
		expander:SetPoint("LEFT", category and CATEGORY_EXPANDER_PADDING_LEFT or EXPANDER_PADDING_LEFT, 0)
		expander:Show()
	else
		expander:Hide()
	end

	self.__super:_SetRowData(row, data)
end

function ImportConfirmationList._ModuleNameFromText(self, text)
	local result = nil
	for _, moduleName in TSM.Operations.ModuleIterator() do
		if text == format(L["%s Operations"], moduleName) then
			assert(not result)
			result = moduleName
		end
	end
	return result
end

function ImportConfirmationList._RemoveRow(self, data)
	local header, category, item = strsplit(DATA_SEP, data)
	local moduleName = self:_ModuleNameFromText(header)
	if moduleName then
		assert(not item)
		if category then
			-- remove this operation
			self._import:RemoveOperation(moduleName, category)
		else
			-- remove all operations for this module
			self._import:RemoveModuleOperations(moduleName)
		end
	else
		local groupPath = strmatch(header, TSMAPI_FOUR.Util.StrEscape(GROUP..": ").."(.+)") or header
		assert(groupPath)
		if not category then
			-- remove the group
			self._import:RemoveGroup(groupPath)
		elseif category == L["Items"] then
			if item then
				-- remove this item from the group
				self._import:RemoveGroupItem(groupPath, item)
			else
				-- remove all the items from the group
				self._import:RemoveGroupItems(groupPath)
			end
		else
			moduleName = self:_ModuleNameFromText(category)
			assert(moduleName)
			if item then
				-- remove this operation from the group
				self._import:RemoveGroupOperation(groupPath, moduleName, item)
			else
				-- remove all operations for this module from the group
				self._import:RemoveGroupOperations(groupPath, moduleName)
			end
		end
	end
	self:_UpdateData()
	self:Draw()
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.ExpanderBtnOnEnter(button)
	local row = button:GetParent()
	row:GetScript("OnEnter")(row)
end

function private.ExpanderBtnOnLeave(button)
	local row = button:GetParent()
	row:GetScript("OnLeave")(row)
end

function private.ExpanderBtnOnClick(button)
	local row = private.rowFrameLookup[button:GetParent()]
	local data = row:GetData()
	local self = row._scrollingList
	self._collapsed[data] = not self._collapsed[data] or nil
	self:_UpdateData()
	self:Draw()
end

function private.RemoveBtnOnEnter(button)
	local row = button:GetParent()
	row:GetScript("OnEnter")(row)
end

function private.RemoveBtnOnLeave(button)
	local row = button:GetParent()
	row:GetScript("OnLeave")(row)
end

function private.RemoveBtnOnClick(button)
	local row = private.rowFrameLookup[button:GetParent()]
	local data = row:GetData()
	local self = row._scrollingList
	self:_RemoveRow(data)
end
