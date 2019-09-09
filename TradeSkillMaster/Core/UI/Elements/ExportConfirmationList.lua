-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local ExportConfirmationList = TSMAPI_FOUR.Class.DefineClass("ExportConfirmationList", TSM.UI.ScrollList)
local L = TSM.L
TSM.UI.ExportConfirmationList = ExportConfirmationList
local private = {}



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ExportConfirmationList.__init(self)
	self.__super:__init()

	self._sections = {}
	self._hidden = {}
	self._itemGroup = {}
	self._groupLabel = {}
	self._moduleLabel = {}
	self._sectionLabel = {}
	self._operationModule = {}
	self._operationName = {}
	self._exporter = nil
	self._onSelectionChangedHandler = nil
end

function ExportConfirmationList.Release(self)
	self:_WipeTables()
	wipe(self._hidden)
	self._onSelectionChangedHandler = nil
	self._exporter = nil
	self.__super:Release()
end

function ExportConfirmationList.SetExporter(self, exporter, redraw)
	wipe(self._data)
	self:_WipeTables()

	self._exporter = exporter

	self:_AddSectionLabel("GROUPS_HEADER", L["Selected Groups"])
	local groups = exporter.groups
	for _, groupPath in pairs(groups) do
		self:_AddGroupLabel(groupPath)
	end

	self:_AddSectionLabel("OPERATIONS_HEADER", L["Selected Operations"])
	for _, module in TSM.Operations.ModuleIterator() do
		self:_AddModuleHeader(module)
		local operations = self._exporter.operations[module]
		for name, details in pairs(operations) do
			if not self._exporter.operationsBlacklist[module][name] then
				self:_AddOperation(module, name, details)
			end
		end
	end

	if redraw then
		self:Draw()
	end

	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ExportConfirmationList._WipeTables(self)
	wipe(self._sections)
	wipe(self._sectionLabel)
	wipe(self._moduleLabel)
	wipe(self._groupLabel)
	wipe(self._itemGroup)
	wipe(self._operationModule)
	wipe(self._operationName)
end

function ExportConfirmationList._AddSectionLabel(self, marker, label)
	tinsert(self._data, marker)
	self._sections[marker] = marker
	self._sectionLabel[marker] = label
	self._lastSection = marker
end

function ExportConfirmationList._AddGroupLabel(self, path)
	tinsert(self._data, path)
	local fullPath = self._exporter.groupTargets[path]
	self._groupLabel[path] = gsub(fullPath, TSM.CONST.GROUP_SEP, " > ")
	self._sections[path] = self._lastSection
	self._lastGroup = path
end

function ExportConfirmationList._AddModuleHeader(self, name)
	tinsert(self._data, name)
	self._moduleLabel[name] = name
	self._sections[name] = self._lastSection
end

function ExportConfirmationList._AddOperation(self, module, name, details)
	local key = private._GetOperationKey(module, name)
	tinsert(self._data, key)
	self._operationName[key] = name
	self._operationModule[key] = module
	self._sections[key] = self._lastSection
end

function private._GetOperationKey(module, label)
	return module..TSM.CONST.GROUP_SEP..label
end

function ExportConfirmationList._IsDataHidden(self, data)
	local section = self._sections[data]

	if section == data then
		return self.__super:_IsDataHidden(data)
	end

	-- this whole block is for items
	local group = self._itemGroup[data]
	if group then
		if self._hidden[group] then
			return true
		end
		if self._hidden[self._sections[group]] then
			return true
		end
		return self.__super:_IsDataHidden(data)
	end

	local operation = self._operationName[data]
	if operation then
		if self._hidden[self._sections[data]] then
			return true
		end
		return self.__super:_IsDataHidden(data)
	end

	if section and self._hidden[section] then
		return true
	end

	return self.__super:_IsDataHidden(data)
end

function ExportConfirmationList._CreateRow(self)
	local row = self.__super:_CreateRow()
		:SetLayout("HORIZONTAL")
		:SetStyle("padding", 10)
		:SetStyle("height", self:_GetStyle("rowHeight"))
		:SetScript("OnUpdate", private.RowOnUpdate)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "expander")
			:SetScript("OnClick", private.RowOnClick)
			:SetStyle("margin", { right = 4 })
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
			:SetStyle("justifyH", "LEFT")
			:SetStyle("autoWidth", true)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
		:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "cancelButton")
			:SetStyle("width", 68)
			:SetStyle("height", 26)
			:SetText(CANCEL)
			:SetStyle("font", self:_GetStyle("cancelButtonFont"))
			:SetStyle("fontHeight", self:_GetStyle("cancelButtonFontHeight"))
			:SetStyle("height", 15)
			:SetScript("OnClick", private.CancelOperationOnClick)
		)

	return row
end

function ExportConfirmationList._DrawRow(self, row, dataIndex)
	local item = row:GetContext()

	local isSection = self._sections[item] == item
	local isGroup = self._groupLabel[item]
	local isModule = self._moduleLabel[item]
	local isOperation = self._operationName[item]
	local isCollapsable = isSection
	local isCollapsed = isCollapsable and self._hidden[item]
	local text = row:GetElement("text")
		:SetStyle("height", self:_GetStyle("rowHeight"))
	local texturePack = self:_GetStyle(isCollapsed and "expanderCollapsedBackgroundTexturePack" or "expanderExpandedBackgroundTexturePack")
	local expander = row:GetElement("expander")
		:SetStyle("width", TSM.UI.TexturePacks.GetWidth(texturePack))
		:SetStyle("height", TSM.UI.TexturePacks.GetHeight(texturePack))
	local cancelButton = row:GetElement("cancelButton")

	if isGroup then
		text:SetText(self._groupLabel[item])
			:SetStyle("textColor", self:_GetStyle("textColor"))
			:SetStyle("font", self:_GetStyle("groupFont"))
			:SetStyle("fontHeight", self:_GetStyle("groupFontHeight"))
		expander:SetStyle("backgroundTexturePack", nil)
			:Show()
		cancelButton:Hide()
	elseif isCollapsable then
		text:SetStyle("font", self:_GetStyle("collapsableFont"))
			:SetText(self._sectionLabel[item])
			:SetStyle("textColor", self:_GetStyle("collapsableTextColor"))
			:SetStyle("fontHeight", self:_GetStyle("collapsableFontHeight"))
		expander:SetStyle("backgroundTexturePack", texturePack)
			:Show()
		cancelButton:Hide()
	elseif isModule then
		text:SetText(self._moduleLabel[item])
			:SetStyle("textColor", self:_GetStyle("textColor"))
			:SetStyle("font", self:_GetStyle("moduleFont"))
			:SetStyle("fontHeight", self:_GetStyle("moduleFontHeight"))
		expander:SetStyle("backgroundTexturePack", nil)
			:Show()
		cancelButton:Hide()
	elseif isOperation then
		text:SetStyle("font", self:_GetStyle("operationFont"))
			:SetText(self._operationName[item])
			:SetStyle("fontHeight", self:_GetStyle("operationFontHeight"))
			:SetStyle("textColor", self:_GetStyle("textColor"))
		cancelButton:Show()
		row:GetElement("expander")
			:SetStyle("width", TSM.UI.TexturePacks.GetWidth(self:_GetStyle("expanderCollapsedBackgroundTexturePack")) * 2)
			:SetStyle("backgroundTexturePack", nil)
			:Show()
		-- FIXME set text to white color and set correct font size
	else
		error("Impossible row in ExportConfirmationList")
	end

	self.__super:_DrawRow(row, dataIndex)
end


-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.CancelOperationOnClick(button)
	local row = button:GetParentElement()
	local self = row:GetParentElement()
	local data = row:GetContext()
	local module = self._operationModule[data]
	local name = self._operationName[data]

	self._exporter:BlacklistOperation(module, name)
	self:SetExporter(self._exporter, true)
end

function private.RowOnClick(button)
	local row = button:GetParentElement()
	local self = row:GetParentElement()
	local data = row:GetContext()

	if (self._sections[data] == data) or self._groupLabel[data] or self._operationName[data] then
		self._hidden[data] = not self._hidden[data]
	end
	self:Draw()
end
