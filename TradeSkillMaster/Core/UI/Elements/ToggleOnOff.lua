-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- ToggleOnOff UI Element Class.
-- This is a simple on/off toggle which uses different textures for the different states. It is a subclass of the
-- @{Element} class.
-- @classmod ToggleOnOff

local _, TSM = ...
local ToggleOnOff = TSMAPI_FOUR.Class.DefineClass("ToggleOnOff", TSM.UI.Element)
TSM.UI.ToggleOnOff = ToggleOnOff
local private = { buttonToggleOnOffLookup = {} }



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ToggleOnOff.__init(self)
	local frame = CreateFrame("Button", nil, nil, nil)
	private.buttonToggleOnOffLookup[frame] = self

	self.__super:__init(frame)

	-- set the click handler
	frame:SetScript("OnClick", private.OnClickHandler)

	-- create the background
	frame.backgroundTexture = frame:CreateTexture(nil, "BACKGROUND")

	self._value = false
	self._disabled = false
	self._settingTable = nil
	self._settingKey = nil
	self._onValueChangedHandler = nil
end

function ToggleOnOff.Release(self)
	self._value = false
	self._disabled = false
	self._settingTable = nil
	self._settingKey = nil
	self._onValueChangedHandler = nil
	self:_GetBaseFrame():Enable()
	self.__super:Release()
end

--- Sets the setting info.
-- This method is used to have the value of the toggle automatically correspond with the value of a field in a table.
-- This is useful for toggles which are tied directly to settings.
-- @tparam ToggleOnOff self The toggles object
-- @tparam table tbl The table which the field to set belongs to
-- @tparam string key The key into the table to be set based on the toggle's state
-- @treturn ToggleOnOff The toggles object
function ToggleOnOff.SetSettingInfo(self, tbl, key)
	self._settingTable = tbl
	self._settingKey = key
	self._value = tbl[key]
	return self
end

--- Sets whether or not the toggle is disabled.
-- @tparam ToggleOnOff self The toggles object
-- @tparam boolean disabled Whether or not the toggle is disabled
-- @tparam boolean redraw Whether or not to redraw the toggle
-- @treturn ToggleOnOff The toggles object
function ToggleOnOff.SetDisabled(self, disabled, redraw)
	self._disabled = disabled
	if disabled then
		self:_GetBaseFrame():Disable()
	else
		self:_GetBaseFrame():Enable()
	end
	if redraw then
		self:Draw()
	end
	return self
end

--- Set the value of the toggle.
-- @tparam ToggleOnOff self The toggles object
-- @tparam boolean value Whether the value is on (true) or off (false)
-- @tparam boolean redraw Whether or not to redraw the toggle
-- @treturn ToggleOnOff The toggles object
function ToggleOnOff.SetValue(self, value, redraw)
	if value ~= self._value then
		self._value = value
		if self._settingTable then
			self._settingTable[self._settingKey] = value
		end
		if self._onValueChangedHandler then
			self:_onValueChangedHandler(value)
		end
	end
	if redraw then
		self:Draw()
	end
	return self
end

--- Registers a script handler.
-- @tparam ToggleOnOff self The toggles object
-- @tparam string script The script to register for (supported scripts: `OnValueChanged`)
-- @tparam function handler The script handler which will be called with the toggles object followed by any
-- arguments to the script
-- @treturn ToggleOnOff The toggles object
function ToggleOnOff.SetScript(self, script, handler)
	if script == "OnValueChanged" then
		self._onValueChangedHandler = handler
	else
		error("Unknown ToggleOnOff script: "..tostring(script))
	end
	return self
end

--- Get the value of the toggle.
-- @tparam ToggleOnOff self The toggles object
-- @treturn boolean The value of the toggle
function ToggleOnOff.GetValue(self)
	return self._value
end

function ToggleOnOff.Draw(self)
	self.__super:Draw()
	if self:_GetBaseFrame():IsEnabled() then
		self:SetStyle("backgroundTexturePack", self._value and "uiFrames.ToggleOn" or "uiFrames.ToggleOff")
	else
		self:SetStyle("backgroundTexturePack", self._value and "uiFrames.ToggleDisabledOn" or "uiFrames.ToggleDisabledOff")
	end
	self:_ApplyFrameBackgroundTexture()
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.OnClickHandler(button)
	local self = private.buttonToggleOnOffLookup[button]
	self:SetValue(not self._value, true)
end
