-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Search List UI Element Class.
-- A search list contains a list of recent or favorite searches. It is a subclass of the @{ScrollList} class.
-- @classmod SearchList

local _, TSM = ...
local L = TSM.L
local SearchList = TSMAPI_FOUR.Class.DefineClass("SearchList", TSM.UI.ScrollList)
TSM.UI.SearchList = SearchList
local private = { querySearchListLookup = {} }



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function SearchList.__init(self)
	self.__super:__init()
	self._onRowClickHandler = nil
	self._onFavoriteChangedHandler = nil
	self._onNameChangedHandler = nil
	self._onDeleteHandler = nil
	self._query = nil
	self._editBtnHidden = nil
end

function SearchList.Release(self)
	self._onRowClickHandler = nil
	self._onFavoriteChangedHandler = nil
	self._onNameChangedHandler = nil
	self._onDeleteHandler = nil
	if self._query then
		private.querySearchListLookup[self._query] = nil
		self._query:Release()
		self._query = nil
	end
	self._editBtnHidden = false
	self.__super:Release()
end

--- Sets whether or not the edit button is hidden.
-- @tparam SearchList self The search list object
-- @tparam boolean hidden Whether or not the edit button is hidden
-- @treturn SearchList The search list object
function SearchList.SetEditButtonHidden(self, hidden)
	self._editBtnHidden = hidden
	return self
end

--- Sets the @{DatabaseQuery} source for this list.
-- This query is used to populate the entries in the search list.
-- @tparam SearchList self The search list object
-- @tparam DatabaseQuery query The query object
-- @tparam[opt=false] bool redraw Whether or not to redraw the search list
-- @treturn SearchList The search list object
function SearchList.SetQuery(self, query, redraw)
	assert(query:HasField("name") and query:HasField("isFavorite"))
	if self._query then
		self._query:Release()
		private.querySearchListLookup[self._query] = nil
	end
	self._query = query
	self._query:SetUpdateCallback(private.QueryUpdateCallback)
	private.querySearchListLookup[query] = self
	self:_UpdateDataFromQuery(redraw)
	return self
end

--- Registers a script handler.
-- @tparam SearchList self The search list object
-- @tparam string script The script to register for (supported scripts: `OnRowClick`, `OnFavoriteChanged`,
-- `OnNameChanged`, `OnDelete`)
-- @tparam function handler The script handler which will be called with the search list object followed by any
-- arguments to the script
-- @treturn SearchList The search list object
function SearchList.SetScript(self, script, handler)
	if script == "OnRowClick" then
		self._onRowClickHandler = handler
	elseif script == "OnFavoriteChanged" then
		self._onFavoriteChangedHandler = handler
	elseif script == "OnNameChanged" then
		self._onNameChangedHandler = handler
	elseif script == "OnDelete" then
		self._onDeleteHandler = handler
	else
		error("Unknown SearchList script: "..tostring(script))
	end
	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function SearchList._UpdateDataFromQuery(self, redraw)
	wipe(self._data)
	for _, row in self._query:Iterator() do
		tinsert(self._data, row)
	end

	if redraw then
		self:Draw()
	end
end

function SearchList._CreateRow(self)
	local row = self.__super:_CreateRow()
		:SetLayout("HORIZONTAL")
		:SetScript("OnEnter", private.RowOnEnter)
		:SetScript("OnLeave", private.RowOnLeave)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "modeIcon")
			:SetStyle("width", 60)
			:SetStyle("height", 12)
			:SetStyle("margin", { left = 4 })
		)
		:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Text", "modeIconText")
			:SetStyle("relativeLevel", 1)
			:SetStyle("anchors", { { "TOPLEFT", "modeIcon" }, { "BOTTOMRIGHT", "modeIcon" } })
			:SetStyle("justifyH", "CENTER")
			:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
			:SetStyle("fontHeight", 11)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
			:SetStyle("margin", { left = 4 })
			:SetStyle("justifyH", "LEFT")
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 12)
			:SetStyle("textColor", "#ffffff")
		)
		:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Button", "button")
			:SetStyle("anchors", { { "TOPLEFT" }, { "BOTTOMRIGHT", "text" } })
			:SetScript("OnClick", private.RowOnClick)
			:SetScript("OnEnter", private.RowButtonOnEnter)
			:SetScript("OnLeave", private.RowButtonOnLeave)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "favoriteBtn")
			:SetStyle("width", 15)
			:SetStyle("margin", 4)
			:SetScript("OnClick", private.FavoriteButtonOnClick)
			:SetScript("OnEnter", private.RowButtonOnEnter)
			:SetScript("OnLeave", private.RowButtonOnLeave)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "editBtn")
			:SetStyle("width", 15)
			:SetStyle("margin", 4)
			:SetScript("OnClick", private.EditButtonOnClick)
			:SetScript("OnEnter", private.RowButtonOnEnter)
			:SetScript("OnLeave", private.RowButtonOnLeave)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "deleteBtn")
			:SetStyle("width", 15)
			:SetStyle("margin", { top = 4, left = 4, right = 25, bottom = 4 })
			:SetScript("OnClick", private.DeleteButtonOnClick)
			:SetScript("OnEnter", private.RowButtonOnEnter)
			:SetScript("OnLeave", private.RowButtonOnLeave)
		)
		:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Input", "input")
			:SetStyle("relativeLevel", 2)
			:SetStyle("anchors", { { "TOPLEFT", "button" }, { "BOTTOMRIGHT", "button" } })
			:SetScript("OnEditFocusLost", private.RowInputOnEditFocusLost)
			:SetScript("OnEnterPressed", private.RowInputOnEnterPressed)
		)
		:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Frame", "highlight")
			:SetStyle("anchors", { { "TOPLEFT" }, { "BOTTOMRIGHT" } })
		)

	-- hide the highlight
	row:GetElement("highlight"):Hide()
	return row
end

function SearchList._SetRowHitRectInsets(self, row, top, bottom)
	row:GetElement("button"):SetHitRectInsets(0, 0, top, bottom)
	row:GetElement("favoriteBtn"):SetHitRectInsets(0, 0, top, bottom)
	row:GetElement("editBtn"):SetHitRectInsets(0, 0, top, bottom)
	row:GetElement("deleteBtn"):SetHitRectInsets(0, 0, top, bottom)
	row:GetElement("input"):SetHitRectInsets(0, 0, top, bottom)
	self.__super:_SetRowHitRectInsets(row, top, bottom)
end

function SearchList._DrawRow(self, row, dataIndex)
	local dbRow = row:GetContext()
	local favoriteTexturePack = self:_GetStyle(dbRow:GetField("isFavorite") and "favoriteActiveBackgroundTexturePack" or "favoriteInactiveBackgroundTexturePack")
	row:GetElement("favoriteBtn"):SetStyle("backgroundTexturePack", favoriteTexturePack)
	local editBtn = row:GetElement("editBtn")
	if self._editBtnHidden then
		editBtn:Hide()
	else
		editBtn:Show()
		editBtn:SetStyle("backgroundTexturePack", self:_GetStyle("editBackgroundTexturePack"))
	end
	row:GetElement("deleteBtn"):SetStyle("backgroundTexturePack", self:_GetStyle("deleteBackgroundTexturePack"))

	local modeIcon = row:GetElement("modeIcon")
	if self._query:HasField("mode") then
		modeIcon:Show()
		local mode = dbRow:GetField("mode")
		if mode == "normal" then
			modeIcon:SetStyle("vertexColor", "#ffd839")
				:SetStyle("texturePack", "uiFrames.SearchTypeIndicator")
			row:GetElement("modeIconText")
				:SetStyle("textColor", "#2e2e2e")
				:SetText(L["Normal"])
		elseif mode == "crafting" then
			modeIcon:SetStyle("vertexColor", "#79a2ff")
				:SetStyle("texturePack", "uiFrames.SearchTypeIndicator")
			row:GetElement("modeIconText")
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Crafting"])
		else
			error("Invalid mode: "..tostring(mode))
		end
	else
		modeIcon:Hide()
	end

	row:GetElement("text")
		:SetStyle("height", self:_GetStyle("rowHeight"))
		:SetText(dbRow:GetField("name"))
	row:GetElement("highlight"):SetStyle("background", self:_GetStyle("highlight"))
	row:GetElement("input"):Hide()

	self.__super:_DrawRow(row, dataIndex)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.RowOnClick(button)
	local row = button:GetParentElement()
	local self = row:GetParentElement()
	local text = row:GetContext()
	if self._onRowClickHandler then
		self:_onRowClickHandler(text)
	end
end

function private.RowButtonOnEnter(button)
	local frame = button:GetParentElement()
	frame:GetElement("highlight"):Show()
end

function private.RowButtonOnLeave(button)
	local frame = button:GetParentElement()
	frame:GetElement("highlight"):Hide()
end

function private.RowOnEnter(frame)
	frame:GetElement("highlight"):Show()
end

function private.RowOnLeave(frame)
	frame:GetElement("highlight"):Hide()
end

function private.RowInputOnEditFocusLost(input)
	input:Hide()
	input:GetParentElement():GetElement("button"):ShowText()
end

function private.RowInputOnEnterPressed(input)
	local newName = strtrim(input:GetText())
	input:SetFocused(false)
	if newName == "" then
		-- invalid name
		-- TODO: show an error message?
		return
	end
	-- change the search name
	local row = input:GetParentElement()
	local self = row:GetParentElement()
	self:_onNameChangedHandler(row:GetContext(), newName)
end

function private.FavoriteButtonOnClick(button)
	local row = button:GetParentElement()
	local dbRow = row:GetContext()
	local self = row:GetParentElement()
	self:_onFavoriteChangedHandler(dbRow, not dbRow:GetField("isFavorite"))
end

function private.EditButtonOnClick(button)
	local row = button:GetParentElement()
	local input = row:GetElement("input")
	input:SetText(row:GetContext():GetField("name"))
	input:Show()
	input:Draw()
	input:SetFocused(true)
	row:GetElement("button"):HideText()
end

function private.DeleteButtonOnClick(button)
	local row = button:GetParentElement()
	local self = row:GetParentElement()
	self:_onDeleteHandler(row:GetContext())
end

function private.QueryUpdateCallback(query)
	local self = private.querySearchListLookup[query]
	self:_UpdateDataFromQuery(true)
end
