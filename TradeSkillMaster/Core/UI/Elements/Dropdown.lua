-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Dropdown UI Element Class.
-- A dropdown element allows the user to select from a dialog list. It is a subclass of the @{Element} class.
-- @classmod Dropdown

local _, TSM = ...
local Dropdown = TSMAPI_FOUR.Class.DefineClass("Dropdown", TSM.UI.Element)
TSM.UI.Dropdown = Dropdown
local private = { dropdownLookup = {} }



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Dropdown.__init(self)
	local frame = CreateFrame("Button", nil, nil, nil)

	self.__super:__init(frame)

	frame.bgLeft = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgLeft:SetPoint("TOPLEFT")
	frame.bgLeft:SetPoint("BOTTOMLEFT")

	frame.bgRight = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgRight:SetPoint("TOPRIGHT")
	frame.bgRight:SetPoint("BOTTOMRIGHT")

	frame.bgMiddle = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgMiddle:SetPoint("TOPLEFT", frame.bgLeft, "TOPRIGHT")
	frame.bgMiddle:SetPoint("BOTTOMRIGHT", frame.bgRight, "BOTTOMLEFT")

	frame:SetScript("OnClick", private.FrameOnClick)
	private.dropdownLookup[frame] = self
	frame.text = frame:CreateFontString()
	frame.arrow = frame:CreateTexture()

	self._items = {}
	self._selection = {}
	self._settingTable = nil
	self._settingKey = nil
	self._order = {}
	self._disabled = false
	self._isOpen = false

	self._hintText = ""
	self._multiselect = false
	self._onSelectionChangedHandler = nil
end

function Dropdown.Acquire(self)
	self._textStr = ""
	local frame = self:_GetBaseFrame()
	frame:Enable()
	self.__super:Acquire()
end

function Dropdown.Release(self)
	self._hintText = ""
	self._multiselect = false
	self._onSelectionChangedHandler = nil
	self._settingTable = nil
	self._settingKey = nil
	wipe(self._order)
	wipe(self._items)
	wipe(self._selection)
	self._disabled = false
	self._isOpen = false
	self.__super:Release()
end

--- Sets the hint text which is shown when there's no selection.
-- @tparam Dropdown self The dropdown object
-- @tparam string text The hint text string
-- @treturn Dropdown The dropdown object
function Dropdown.SetHintText(self, text)
	self._hintText = text
	return self
end

--- Sets whether or not multiple items can be selected.
-- @tparam Dropdown self The dropdown object
-- @tparam boolean multiselect Whether or not multiple items can be selected
-- @treturn Dropdown The dropdown object
function Dropdown.SetMultiselect(self, multiselect)
	self._multiselect = multiselect
	return self
end

--- Sets the items to show in the dropdown dialog list.
-- @tparam Dropdown self The dropdown object
-- @tparam table items The items to be shown in the dropdown list
-- @tparam string selection The selected item or a the selection table if this is a multiselect dropdown
-- @tparam[opt=false] boolean redraw Whether or not to redraw the dropdown
-- @treturn Dropdown The dropdown object
function Dropdown.SetItems(self, items, selection, redraw)
	wipe(self._items)
	wipe(self._order)
	for key, value in ipairs(items) do
		tinsert(self._order, key)
		self._items[value] = key
	end
	self:SetSelection(selection)
	if redraw then
		self:Draw()
	end
	return self
end

--- Sets the items to show in the dropdown dialog list.
-- @tparam Dropdown self The dropdown object
-- @tparam table items The items to be shown in the dropdown list
-- @tparam string selection The selected item or a the selection table if this is a multiselect dropdown
-- @tparam table order The order in which to list the items
-- @tparam[opt=false] boolean redraw Whether or not to redraw the dropdown
-- @treturn Dropdown The dropdown object
function Dropdown.SetDictionaryItems(self, items, selection, order, redraw)
	wipe(self._items)
	wipe(self._order)
	for _, key in ipairs(order) do
		tinsert(self._order, key)
		self._items[items[key]] = key
	end
	self:SetSelection(selection)
	if redraw then
		self:Draw()
	end
	return self
end

--- Sets the currently selected item.
-- @tparam Dropdown self The dropdown object
-- @tparam string selection The selected item or a the selection table if this is a multiselect dropdown
-- @treturn Dropdown The dropdown object
function Dropdown.SetSelection(self, selection)
	wipe(self._selection)
	if selection then
		if self._multiselect then
			assert(type(selection) == "table")
			for item, selected in pairs(selection) do
				self._selection[item] = selected
			end
		else
			assert(type(selection) == "string" or type(selection) == "number")
			self._selection[selection] = true
		end
	end
	return self
end

--- Gets the currently selected item.
-- @tparam Dropdown self The dropdown object
-- @treturn ?string|table The selected item or a the selection table if this is a multiselect dropdown
function Dropdown.GetSelection(self)
	if self._multiselect then
		return self._selection
	else
		local selectedItem = next(self._selection)
		return selectedItem
	end
end

--- Sets whether or not the dropdown is disabled.
-- @tparam Dropdown self The dropdown object
-- @tparam boolean disabled Whether or not to disable the dropdown
-- @treturn Dropdown The dropdown object
function Dropdown.SetDisabled(self, disabled)
	self._disabled = disabled
	if disabled then
		self:_GetBaseFrame():Disable()
	else
		self:_GetBaseFrame():Enable()
	end
	return self
end

--- Registers a script handler.
-- @tparam Dropdown self The dropdown object
-- @tparam string script The script to register for (supported scripts: `OnSelectionChanged`)
-- @tparam function handler The script handler which will be called with the dropdown object followed by any arguments
-- to the script
-- @treturn Dropdown The dropdown object
function Dropdown.SetScript(self, script, handler)
	if script == "OnSelectionChanged" then
		self._onSelectionChangedHandler = handler
	else
		error("Invalid Dropdown script: "..tostring(script))
	end
	return self
end

--- Sets the setting info.
-- This method is used to have the value of the dropdown automatically correspond with the value of a field in a table.
-- This is useful for dropdowns which are tied directly to settings.
-- @tparam Dropdown self The dropdown object
-- @tparam table tbl The table which the field to set belongs to
-- @tparam string key The key into the table to be set based on the dropdown state
-- @treturn Dropdown The dropdown object
function Dropdown.SetSettingInfo(self, tbl, key)
	self._settingTable = tbl
	self._settingKey = key
	return self
end

--- Sets whether or not the dropdown is open.
-- @tparam Dropdown self The dropdown object
-- @tparam boolean open Whether or not the dropdown is open
-- @treturn Dropdown The dropdown object
function Dropdown.SetOpen(self, open)
	assert(type(open) == "boolean")
	if open == self._isOpen then
		return self
	end
	self._isOpen = open
	if open then
		local selection = nil
		if self._multiselect then
			selection = TSMAPI_FOUR.Util.AcquireTempTable()
			for item, value in pairs(self._selection) do
				selection[TSMAPI_FOUR.Util.GetDistinctTableKey(self._items, item)] = value
			end
		else
			selection = next(self._selection)
		end
		local itemTable = TSMAPI_FOUR.Util.AcquireTempTable()
		local itemKeyLookup = TSMAPI_FOUR.Util.AcquireTempTable()
		for key, value in pairs(self._items) do
			itemKeyLookup[value] = key
		end
		for _, key in ipairs(self._order) do
			tinsert(itemTable, itemKeyLookup[key])
		end
		TSMAPI_FOUR.Util.ReleaseTempTable(itemKeyLookup)
		local dropdownFrame = TSMAPI_FOUR.UI.NewElement("Frame", "dropdown")
			:SetLayout("VERTICAL")
			:SetStyle("anchors", { { "TOPLEFT", self:_GetBaseFrame() }, { "TOPRIGHT", self:_GetBaseFrame() } })
			:SetStyle("height", 26 + min(8, #itemTable) * 20)
			:SetStyle("border", self:_GetStyle("openBorder"))
			:SetStyle("borderSize", self:_GetStyle("openBorderSize"))
			:SetStyle("background", self:_GetStyle("openBackground"))
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "topRow")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 26)
				:SetStyle("margin", { left = 8 })
				:SetScript("OnMouseUp", private.DropdownTopRowOnClick)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "current")
					:SetStyle("font", self:_GetStyle("openFont"))
					:SetStyle("fontHeight", self:_GetStyle("openFontHeight"))
					:SetText(self:_GetCurrentSelectionString())
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "icon")
					:SetStyle("width", self:_GetStyle("expanderSize"))
					:SetStyle("height", self:_GetStyle("expanderSize"))
					:SetStyle("margin", { right = self:_GetStyle("expanderPadding") })
					:SetStyle("backgroundTexturePack", self:_GetStyle("expanderBackgroundTexturePack"))
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("DropdownList", "list")
				:SetMultiselect(self._multiselect)
				:SetItems(itemTable, selection)
				:SetScript("OnSelectionChanged", private.OnSelectionChanged)
			)
			:SetScript("OnHide", private.DropdownFrameOnHide)
		if self._multiselect then
			TSMAPI_FOUR.Util.ReleaseTempTable(selection)
		end
		TSMAPI_FOUR.Util.ReleaseTempTable(itemTable)
		private.dropdownLookup[dropdownFrame] = self
		self:GetBaseElement():ShowDialogFrame(dropdownFrame)
	else
		self:GetBaseElement():HideDialog()
	end
	return self
end

function Dropdown.Draw(self)
	self.__super:Draw()
	local frame = self:_GetBaseFrame()
	self:_ApplyFrameStyle(frame)
	self:_ApplyTextStyle(frame.text)
	frame.text:SetText(self:_GetCurrentSelectionString())
	local expanderSize = self:_GetStyle("expanderSize")
	local frameHeight = frame:GetHeight()
	local paddingX = self:_GetStyle("expanderPadding")
	local paddingY = (frameHeight - expanderSize) / 2
	frame.text:ClearAllPoints()
	frame.arrow:ClearAllPoints()
	frame.text:SetPoint("TOPLEFT", self:_GetStyle("textPadding"), 0)
	frame.text:SetPoint("BOTTOMRIGHT", -expanderSize, 0)
	frame.arrow:SetPoint("BOTTOMLEFT", frame.text, "BOTTOMRIGHT", -paddingX, paddingY)
	frame.arrow:SetPoint("TOPRIGHT", -paddingX, -paddingY)

	-- set textures and text color depending on the state
	if self._disabled then
		frame.text:SetTextColor(TSM.UI.HexToRGBA(self:_GetStyle("inactiveTextColor")))
		TSM.UI.TexturePacks.SetTextureAndWidth(frame.bgLeft, "uiFrames.RegularInactiveDropdownLeft")
		TSM.UI.TexturePacks.SetTexture(frame.bgMiddle, "uiFrames.RegularInactiveDropdownMiddle")
		TSM.UI.TexturePacks.SetTextureAndWidth(frame.bgRight, "uiFrames.RegularInactiveDropdownRight")
		TSM.UI.TexturePacks.SetTexture(frame.arrow, self:_GetStyle("inactiveExpanderBackgroundTexturePack"))
	else
		frame.text:SetTextColor(TSM.UI.HexToRGBA(self:_GetStyle("textColor")))
		TSM.UI.TexturePacks.SetTextureAndWidth(frame.bgLeft, "uiFrames.RegularActiveDropdownLeft")
		TSM.UI.TexturePacks.SetTexture(frame.bgMiddle, "uiFrames.RegularActiveDropdownMiddle")
		TSM.UI.TexturePacks.SetTextureAndWidth(frame.bgRight, "uiFrames.RegularActiveDropdownRight")
		TSM.UI.TexturePacks.SetTexture(frame.arrow, self:_GetStyle("expanderBackgroundTexturePack"))
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function Dropdown._GetCurrentSelectionString(self)
	local selectedItems = TSMAPI_FOUR.Util.AcquireTempTable()
	if self._multiselect then
		for item, selected in pairs(self._selection) do
			if selected then
				tinsert(selectedItems, TSMAPI_FOUR.Util.GetDistinctTableKey(self._items, item))
			end
		end
	else
		local selectedItem = next(self._selection)
		if selectedItem then
			tinsert(selectedItems, selectedItem)
		end
	end
	local selectedText = (#selectedItems > 0) and table.concat(selectedItems, ", ") or self._hintText
	TSMAPI_FOUR.Util.ReleaseTempTable(selectedItems)
	return selectedText
end

function Dropdown._UpdateSettingTable(self)
	if self._settingTable and self._settingKey then
		if self._multiselect then
			wipe(self._settingTable[self._settingKey])

			for item, selectedValue in pairs(self:GetSelection()) do
				self._settingTable[self._settingKey][item] = selectedValue
			end
		else
			self._settingTable[self._settingKey] = self._items[self:GetSelection()]
		end
	end
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FrameOnClick(frame)
	local self = private.dropdownLookup[frame]
	self:SetOpen(true)
end

function private.DropdownTopRowOnClick(frame)
	local self = private.dropdownLookup[frame:GetParentElement()]
	self:SetOpen(false)
end

function private.OnSelectionChanged(dropdownList, selection)
	local self = private.dropdownLookup[dropdownList:GetParentElement()]
	if not self._multiselect then
		self:SetOpen(false)
	end
	wipe(self._selection)
	if self._multiselect then
		for item, selected in pairs(selection) do
			self._selection[self._items[item]] = selected
		end
	else
		self._selection[selection] = true
	end
	self:_UpdateSettingTable()
	if self._multiselect then
		dropdownList:GetElement("__parent.topRow.current")
			:SetText(self:_GetCurrentSelectionString())
			:Draw()
	end
	self:Draw()
	if self._onSelectionChangedHandler then
		self:_onSelectionChangedHandler(selection)
	end
end

function private.DropdownFrameOnHide(frame)
	local self = private.dropdownLookup[frame]
	private.dropdownLookup[frame] = nil
	self._isOpen = false
end
