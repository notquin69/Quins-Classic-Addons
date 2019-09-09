-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- SelectionList UI Element Class.
-- A selection list is a scrollable list of entries which allows selecting a single one. It is a subclass of the
-- @{ScrollList} class.
-- @classmod SelectionList

local _, TSM = ...
local SelectionList = TSMAPI_FOUR.Class.DefineClass("SelectionList", TSM.UI.ScrollList)
TSM.UI.SelectionList = SelectionList
local private = {}



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function SelectionList.__init(self)
	self.__super:__init()
	self._selectedEntry = nil
	self._onEntrySelectedHandler = nil
end

function SelectionList.Release(self)
	self._selectedEntry = nil
	self._onEntrySelectedHandler = nil
	self.__super:Release()
end

--- Sets the entries.
-- @tparam SelectionList self The selection list object
-- @tparam table entries A list of entries
-- @tparam string selectedEntry The selected entry
-- @treturn SelectionList The selection list object
function SelectionList.SetEntries(self, entries, selectedEntry)
	wipe(self._data)
	for _, entry in ipairs(entries) do
		tinsert(self._data, entry)
	end
	self._selectedEntry = selectedEntry
	return self
end

--- Registers a script handler.
-- @tparam SelectionList self The selection list object
-- @tparam string script The script to register for (supported scripts: `OnEntrySelected`)
-- @tparam function handler The script handler which will be called with the selection list object followed by any
-- arguments to the script
-- @treturn SelectionList The selection list object
function SelectionList.SetScript(self, script, handler)
	if script == "OnEntrySelected" then
		self._onEntrySelectedHandler = handler
	else
		error("Unknown SelectionList script: "..tostring(script))
	end
	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function SelectionList._CreateRow(self)
	local color = self:_GetStyle("textColor") or "#e2e2e2"
	local row = self.__super:_CreateRow()
		:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Texture", "highlight")
			:SetStyle("anchors", { { "TOPLEFT" }, { "BOTTOMRIGHT" } })
			:SetStyle("color", "#30290b")
		)

		:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Button", "button")
			:SetStyle("anchors", { { "TOPLEFT" }, { "BOTTOMRIGHT" } })
			:SetScript("OnEnter", private.RowOnEnter)
			:SetScript("OnLeave", private.RowOnLeave)
			:SetScript("OnClick", private.RowOnClick)
		)

		:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Text", "text")
			:SetStyle("fontHeight", 12)
			:SetStyle("textColor", color)
			:SetStyle("anchors", { { "TOPLEFT", 8, 0 }, { "BOTTOMRIGHT", -8, 0 } })
		)

	row:GetElement("highlight"):Hide()

	return row
end

function SelectionList._SetRowHitRectInsets(self, row, top, bottom)
	row:GetElement("button"):SetHitRectInsets(0, 0, top, bottom)
	self.__super:_SetRowHitRectInsets(row, top, bottom)
end

function SelectionList._DrawRow(self, row, dataIndex)
	local operationName = row:GetContext()
	local isSelected = operationName == self._selectedEntry

	local color = self:_GetStyle("textColor") or "#e2e2e2"

	row:GetElement("text")
		:SetStyle("textColor", isSelected and "#ffd839" or color)
		:SetStyle("font", isSelected and TSM.UI.Fonts.bold or TSM.UI.Fonts.MontserratRegular)
		:SetText(operationName)

	self.__super:_DrawRow(row, dataIndex)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.RowOnEnter(button)
	button:GetParentElement():GetElement("highlight"):Show()
end

function private.RowOnLeave(button)
	button:GetParentElement():GetElement("highlight"):Hide()
end

function private.RowOnClick(button)
	local row = button:GetParentElement()
	local self = row:GetParentElement()
	if self._onEntrySelectedHandler then
		self:_onEntrySelectedHandler(row:GetContext())
	end
end
