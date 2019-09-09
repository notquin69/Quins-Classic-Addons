-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- InputNumeric UI Element Class.
-- This is a special type of input box which only allows for numeric text to be entered. It is a subclass of the
-- @{Input} class.
-- @classmod InputNumeric

local _, TSM = ...
local private = { frameInputLookup = {} }
local InputNumeric = TSMAPI_FOUR.Class.DefineClass("InputNumeric", TSM.UI.Input)
TSM.UI.InputNumeric = InputNumeric



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function InputNumeric.__init(self)
	self.__super:__init()
	self._minNumber = nil
	self._maxNumber = nil

	local frame = self:_GetBaseFrame()
	frame:SetNumeric(true)
	frame:SetScript("OnEnterPressed", private.OnEnterPressed)

	private.frameInputLookup[frame] = self
end

function InputNumeric.Acquire(self)
	self.__super:Acquire()
	self:_GetBaseFrame():SetScript("OnEnterPressed", private.OnEnterPressed)
end

function InputNumeric.Release(self)
	self._minNumber = nil
	self._maxNumber = nil
	self.__super:Release()
end

--- Gets the current number entered.
-- @tparam InputNumeric self The input numeric object
-- @treturn number The current number entered
function InputNumeric.GetNumber(self)
	return self:_GetBaseFrame():GetNumber()
end

--- Sets the maximum number.
-- @tparam InputNumeric self The input numeric object
-- @tparam number maxNumber The maximum number
-- @treturn InputNumeric The input numeric object
function InputNumeric.SetMaxNumber(self, maxNumber)
	self._maxNumber = maxNumber
	return self
end

--- Sets the minimum number.
-- @tparam InputNumeric self The input numeric object
-- @tparam number minNumber The minimum number
-- @treturn InputNumeric The input numeric object
function InputNumeric.SetMinNumber(self, minNumber)
	self._minNumber = minNumber
	return self
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.OnEnterPressed(frame)
	frame:HighlightText(0, 0)
	local self = private.frameInputLookup[frame]

	local value = max(min(self:GetNumber(), self._maxNumber or math.huge), self._minNumber or -math.huge)

	if self._settingTable and self._settingKey then
		if self._validation and self._validation(value) or not self._validation then
			self._settingTable[self._settingKey] = value
			self:SetText(value)
		end
	else
		self:SetText(value)
	end

	self:Draw()
	frame:ClearFocus()

	if self._userScriptHandlers.OnEnterPressed then
		self._userScriptHandlers.OnEnterPressed(self)
	end
end
