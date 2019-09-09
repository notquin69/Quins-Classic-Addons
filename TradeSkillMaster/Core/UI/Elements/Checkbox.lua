-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Checkbox UI Element Class.
-- This is a simple checkbox element with an attached description text. It is a subclass of the @{Element} class.
-- @classmod Checkbox

local _, TSM = ...
local Checkbox = TSMAPI_FOUR.Class.DefineClass("Checkbox", TSM.UI.Element)
TSM.UI.Checkbox = Checkbox
local private = { checkboxLookup = {} }



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Checkbox.__init(self)
	local frame = CreateFrame("Button", nil, nil, nil)

	self.__super:__init(frame)

	frame:SetScript("OnClick", private.FrameOnClick)
	private.checkboxLookup[frame] = self

	-- create the text and check texture
	frame.text = frame:CreateFontString()
	frame.text:SetJustifyV("MIDDLE")
	frame.check = frame:CreateTexture()

	self._textStr = ""
	self._position = "LEFT"
	self._disabled = false
	self._value = false
	self._onValueChangedHandler = nil
	self._settingTable = nil
	self._settingKey = nil
end

function Checkbox.Acquire(self)
	self._textStr = ""
	self._position = "LEFT"
	self._disabled = false
	self._value = false
	self.__super:Acquire()
end

function Checkbox.Release(self)
	self._onValueChangedHandler = nil
	self._settingTable = nil
	self._settingKey = nil
	self.__super:Release()
end

--- Sets the position of the checkbox relative to the text.
-- This method can be used to set the checkbox to be either on the left or right side of the text.
-- @tparam Checkbox self The checkbox object
-- @tparam string position The position of the checkbox relative to the text
-- @treturn Checkbox The checkbox object
function Checkbox.SetCheckboxPosition(self, position)
	if position == "LEFT" or position == "RIGHT" then
		self._position = position
	else
		error("Invalid checkbox position: "..tostring(position))
	end
	return self
end

--- Sets whether or not the checkbox is disabled.
-- @tparam Input self The checkbox object
-- @tparam boolean disabled Whether or not the checkbox is disabled
-- @treturn Input The checkbox object
function Checkbox.SetDisabled(self, disabled)
	self._disabled = disabled
	return self
end

--- Sets the text string.
-- @tparam Checkbox self The checkbox object
-- @tparam string text The text string to be displayed
-- @treturn Checkbox The checkbox object
function Checkbox.SetText(self, text)
	self._textStr = text
	return self
end

--- Gets the text string.
-- @tparam Checkbox self The checkbox object
-- @treturn string The text string
function Checkbox.GetText(self)
	return self._textStr
end

--- Sets a formatted text string.
-- @tparam Checkbox self The checkbox object
-- @tparam vararg ... The format string and arguments
-- @treturn Checkbox The checkbox object
function Checkbox.SetFormattedText(self, ...)
	self._textStr = format(...)
	return self
end

--- Sets whether or not the checkbox is checked.
-- @tparam Checkbox self The checkbox object
-- @tparam boolean value Whether or not the checkbox is checked
-- @tparam[opt=false] boolean silent If true, will not trigger the `OnValueChanged` script
-- @treturn Checkbox The checkbox object
function Checkbox.SetChecked(self, value, silent)
	self._value = value and true or false
	if self._onValueChangedHandler and not silent then
		self:_onValueChangedHandler(value)
	end
	return self
end

--- Sets the setting info.
-- This method is used to have the state of the checkbox automatically correspond with the boolean state of a field in
-- a table. This is useful for checkboxes which are tied directly to settings.
-- @tparam Checkbox self The checkbox object
-- @tparam table tbl The table which the field to set belongs to
-- @tparam string key The key into the table to be set based on the checkbox state
-- @treturn Checkbox The checkbox object
function Checkbox.SetSettingInfo(self, tbl, key)
	self._settingTable = tbl
	self._settingKey = key
	self:SetChecked(tbl[key])
	return self
end

--- Gets the checked state.
-- @tparam Checkbox self The checkbox object
-- @treturn boolean Whether or not the checkbox is checked
function Checkbox.IsChecked(self)
	return self._value
end

--- Registers a script handler.
-- @tparam Checkbox self The checkbox object
-- @tparam string script The script to register for (supported scripts: `OnValueChanged`)
-- @tparam function handler The script handler which will be called with the checkbox object followed by any arguments
-- to the script
-- @treturn Checkbox The checkbox object
function Checkbox.SetScript(self, script, handler)
	if script == "OnValueChanged" then
		self._onValueChangedHandler = handler
	elseif script == "OnEnter" or script == "OnLeave" then
		return self.__super:SetScript(script, handler)
	else
		error("Unknown Checkbox script: "..tostring(script))
	end
	return self
end

--- Get the width of the checkbox's text string.
-- @tparam Checkbox self The checkbox object
-- @treturn number The width of the text string
function Checkbox.GetStringWidth(self)
	local text = self:_GetBaseFrame().text
	self:_ApplyTextStyle(text)
	text:SetText(self._textStr)
	return text:GetStringWidth()
end

function Checkbox.Draw(self)
	self.__super:Draw()
	local frame = self:_GetBaseFrame()
	self:_ApplyFrameStyle(frame)
	self:_ApplyTextStyle(frame.text, self._disabled)

	frame.text:SetText(self._textStr)
	TSM.UI.TexturePacks.SetTextureAndSize(frame.check, self:_GetStyle(self._value and "checkedTexturePack" or "uncheckedTexturePack"))

	frame.text:ClearAllPoints()
	frame.check:ClearAllPoints()
	if self._position == "LEFT" then
		frame.check:SetPoint("LEFT")
		frame.text:SetJustifyH("LEFT")
		frame.text:SetPoint("LEFT", frame.check, "RIGHT", self:_GetStyle("checkboxSpacing"), 0)
		frame.text:SetPoint("TOPRIGHT")
		frame.text:SetPoint("BOTTOMRIGHT")
	elseif self._position == "RIGHT" then
		frame.check:SetPoint("RIGHT")
		frame.text:SetJustifyH("RIGHT")
		frame.text:SetPoint("BOTTOMLEFT")
		frame.text:SetPoint("TOPLEFT")
		frame.text:SetPoint("RIGHT", frame.check, "LEFT", -self:_GetStyle("checkboxSpacing"), 0)
	else
		error("Invalid position: "..tostring(self._position))
	end
	if self._disabled then
		frame.check:SetAlpha(0.3)
		self:_GetBaseFrame():Disable()
	else
		frame.check:SetAlpha(1)
		self:_GetBaseFrame():Enable()
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function Checkbox._GetMinimumDimension(self, dimension)
	if dimension == "WIDTH" and self:_GetStyle("autoWidth") then
		local checkboxSpacing = self:_GetStyle("checkboxSpacing")
		local checkboxWidth = TSM.UI.TexturePacks.GetWidth(self:_GetStyle("checkedTexturePack"))
		return self:GetStringWidth() + checkboxSpacing + checkboxWidth, nil
	else
		return self.__super:_GetMinimumDimension(dimension)
	end
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FrameOnClick(frame)
	local self = private.checkboxLookup[frame]
	local value = not self._value

	if self._settingTable and self._settingKey then
		self._settingTable[self._settingKey] = value
	end

	self:SetChecked(value)
	self:Draw()
end
