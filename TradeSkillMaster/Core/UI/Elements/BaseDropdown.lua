-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Base Dropdown UI Element Class.
-- The base dropdown class is an abstract class which provides shared functionality between the @{SelectionDropdown} and
-- @{MultiselectionDropdown} classes. It is a subclass of the @{Element} class.
-- @classmod BaseDropdown

local _, TSM = ...
local BaseDropdown = TSMAPI_FOUR.Class.DefineClass("BaseDropdown", TSM.UI.Element, "ABSTRACT")
TSM.UI.BaseDropdown = BaseDropdown
local private = { dropdownLookup = {}, dialogDropdownLookup = {} }



-- ============================================================================
-- Meta Class Methods
-- ============================================================================

function BaseDropdown.__init(self)
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

	self._hintText = ""
	self._items = {}
	self._itemKeyLookup = {}
	self._settingTable = nil
	self._settingKey = nil
	self._disabled = false
	self._isOpen = false
	self._onSelectionChangedHandler = nil
end

function BaseDropdown.Acquire(self)
	self:_GetBaseFrame():Enable()
	self.__super:Acquire()
end

function BaseDropdown.Release(self)
	self._hintText = ""
	wipe(self._items)
	wipe(self._itemKeyLookup)
	self._settingTable = nil
	self._settingKey = nil
	self._disabled = false
	self._isOpen = false
	self._onSelectionChangedHandler = nil
	self.__super:Release()
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

--- Sets the hint text which is shown when there's no selection.
-- @tparam BaseDropdown self The dropdown object
-- @tparam string text The hint text string
-- @treturn BaseDropdown The dropdown object
function BaseDropdown.SetHintText(self, text)
	self._hintText = text
	return self
end

--- Add an item to be shown in the dropdown dialog list.
-- @tparam BaseDropdown self The dropdown object
-- @tparam string item The item to add to the list (localized string)
-- @tparam[opt] string|number itemKey The internal representation of the item (if not specified will be the index)
-- @treturn BaseDropdown The dropdown object
function BaseDropdown.AddItem(self, item, itemKey)
	tinsert(self._items, item)
	self._itemKeyLookup[item] = itemKey or #self._items
	return self
end

--- Set the items to show in the dropdown dialog list.
-- @tparam BaseDropdown self The dropdown object
-- @tparam table items A list of items to be shown in the dropdown list
-- @tparam[opt] table itemKeys A list of keys which go with the item at the corresponding index in the items list
-- @treturn BaseDropdown The dropdown object
function BaseDropdown.SetItems(self, items, itemKeys)
	wipe(self._items)
	wipe(self._itemKeyLookup)
	assert(not itemKeys or #itemKeys == #items)
	for i, item in ipairs(items) do
		self:AddItem(item, itemKeys and itemKeys[i])
	end
	return self
end

--- Set whether or not the dropdown is disabled.
-- @tparam BaseDropdown self The dropdown object
-- @tparam boolean disabled Whether or not to disable the dropdown
-- @treturn BaseDropdown The dropdown object
function BaseDropdown.SetDisabled(self, disabled)
	self._disabled = disabled
	if disabled then
		self:_GetBaseFrame():Disable()
	else
		self:_GetBaseFrame():Enable()
	end
	return self
end

--- Registers a script handler.
-- @tparam BaseDropdown self The dropdown object
-- @tparam string script The script to register for (supported scripts: `OnSelectionChanged`)
-- @tparam function handler The script handler which will be called with the dropdown object followed by any arguments
-- to the script
-- @treturn BaseDropdown The dropdown object
function BaseDropdown.SetScript(self, script, handler)
	if script == "OnSelectionChanged" then
		self._onSelectionChangedHandler = handler
	else
		error("Invalid BaseDropdown script: "..tostring(script))
	end
	return self
end

--- Sets whether or not the dropdown is open.
-- @tparam BaseDropdown self The dropdown object
-- @tparam boolean open Whether or not the dropdown is open
-- @treturn BaseDropdown The dropdown object
function BaseDropdown.SetOpen(self, open)
	assert(type(open) == "boolean")
	if open == self._isOpen then
		return self
	end
	self._isOpen = open
	if open then
		local dialogFrame = TSMAPI_FOUR.UI.NewElement("Frame", "dropdown")
			:SetLayout("VERTICAL")
			:SetStyle("anchors", { { "TOPLEFT", self:_GetBaseFrame() }, { "TOPRIGHT", self:_GetBaseFrame() } })
			:SetStyle("height", 26 + min(8, #self._items) * 20)
			:SetStyle("border", self:_GetStyle("openBorder"))
			:SetStyle("borderSize", self:_GetStyle("openBorderSize"))
			:SetStyle("background", self:_GetStyle("openBackground"))
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "topRow")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 26)
				:SetStyle("margin.left", 8)
				:SetScript("OnMouseUp", private.ListTopRowOnClick)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "current")
					:SetStyle("font", self:_GetStyle("openFont"))
					:SetStyle("fontHeight", self:_GetStyle("openFontHeight"))
					:SetText(self:_GetCurrentSelectionString())
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "icon")
					:SetStyle("width", self:_GetStyle("expanderSize"))
					:SetStyle("height", self:_GetStyle("expanderSize"))
					:SetStyle("margin.right", self:_GetStyle("expanderPadding"))
					:SetStyle("backgroundTexturePack", self:_GetStyle("expanderBackgroundTexturePack"))
				)
			)
			:AddChild(self:_CreateDropdownList()
				:SetScript("OnSelectionChanged", private.ListOnSelectionChanged)
			)
			:SetScript("OnHide", private.DialogOnHide)
		private.dialogDropdownLookup[dialogFrame] = self
		self:GetBaseElement():ShowDialogFrame(dialogFrame)
	else
		self:GetBaseElement():HideDialog()
	end
	return self
end

function BaseDropdown.Draw(self)
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
-- Local Script Handlers
-- ============================================================================

function private.FrameOnClick(frame)
	local self = private.dropdownLookup[frame]
	self:SetOpen(true)
end

function private.ListTopRowOnClick(frame)
	frame:GetBaseElement():HideDialog()
end

function private.ListOnSelectionChanged(dropdownList, selection)
	local self = private.dialogDropdownLookup[dropdownList:GetParentElement()]
	self:_OnListSelectionChanged(dropdownList, selection)
	self:Draw()
end

function private.DialogOnHide(frame)
	local self = private.dialogDropdownLookup[frame]
	private.dialogDropdownLookup[frame] = nil
	self._isOpen = false
end
