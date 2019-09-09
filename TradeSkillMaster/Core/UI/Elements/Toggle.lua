-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Toggle UI Element Class.
-- A toggle element allows the user to select between a fixed set of options. It is a subclass of the @{Container} class.
-- @classmod Toggle

local _, TSM = ...
local Toggle = TSMAPI_FOUR.Class.DefineClass("Toggle", TSM.UI.Container)
TSM.UI.Toggle = Toggle
local private = {}



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Toggle.__init(self)
	local frame = CreateFrame("Frame", nil, nil, nil)

	self.__super:__init(frame)

	self._optionsList = {}
	self._buttons = {}
	self._onValueChangedHandler = nil
	self._selectedOption = nil
	self._booleanTable = nil
	self._booleanKey = nil
end

function Toggle.Release(self)
	wipe(self._optionsList)
	wipe(self._buttons)
	self._onValueChangedHandler = nil
	self._selectedOption = nil
	self._booleanTable = nil
	self._booleanKey = nil

	self.__super:Release()
end

--- Add an option.
-- @tparam Toggle self The toggle object
-- @tparam string option The text that goes with the option
-- @tparam boolean setSelected Whether or not to set this as the selected option
-- @treturn Toggle The toggle object
function Toggle.AddOption(self, option, setSelected)
	tinsert(self._optionsList, option)
	if setSelected then
		self:SetOption(option)
	end
	return self
end

--- Sets the currently selected option.
-- @tparam Toggle self The toggle object
-- @tparam string option The selected option
-- @tparam boolean redraw Whether or not to redraw the toggle
-- @treturn Toggle The toggle object
function Toggle.SetOption(self, option, redraw)
	if option ~= self._selectedOption then
		self._selectedOption = option
		if self._booleanTable and self._booleanKey then
			assert(option == YES or option == NO)
			self._booleanTable[self._booleanKey] = option == YES
		end
		if self._onValueChangedHandler then
			self:_onValueChangedHandler(option)
		end
	end
	if redraw then
		self:Draw()
	end
	return self
end

--- Sets whether or not the toggle is disabled.
-- @tparam Toggle self The toggle object
-- @tparam boolean disabled Whether or not the toggle is disabled
-- @treturn Toggle The toggle object
function Toggle.SetDisabled(self, disabled)
	self._disabled = disabled
	return self
end

--- Registers a script handler.
-- @tparam Toggle self The toggle object
-- @tparam string script The script to register for (supported scripts: `OnValueChanged`)
-- @tparam function handler The script handler which will be called with the toggle object followed by any arguments to
-- the script
-- @treturn Toggle The toggle object
function Toggle.SetScript(self, script, handler)
	if script == "OnValueChanged" then
		self._onValueChangedHandler = handler
	else
		error("Unknown Toggle script: "..tostring(script))
	end
	return self
end

--- Turns this into a simple Yes/No toggle.
-- @tparam Toggle self The toggle object
-- @tparam table tbl The table containing the field to toggle based on the value of this element
-- @tparam string key The key for the field to set
-- @treturn Toggle The toggle object
function Toggle.SetBooleanToggle(self, tbl, key)
	self._booleanTable = tbl
	self._booleanKey = key
	return self:AddOption(YES)
		:AddOption(NO)
		:SetOption(tbl[key] and YES or NO)
end

--- Get the selected option.
-- @tparam Toggle self The toggle object
-- @treturn string The selected option
function Toggle.GetValue(self)
	return self._selectedOption
end

function Toggle.Draw(self)
	self.__super.__super:Draw()
	-- add new buttons if necessary
	while #self._buttons < #self._optionsList do
		local num = #self._buttons + 1
		local button = TSMAPI_FOUR.UI.NewElement("Button", self._id.."_Button"..num)
			:SetScript("OnClick", private.ButtonOnClick)
		self:AddChildNoLayout(button)
		tinsert(self._buttons, button)
	end

	local selectedPath = self._selectedOption
	local height = self:_GetDimension("HEIGHT")
	local buttonWidth = self:_GetDimension("WIDTH") / #self._buttons
	local offsetX = 0
	for i, button in ipairs(self._buttons) do
		if i <= #self._optionsList then
			local buttonPath = self._optionsList[i]
			button:SetStyle("font", self:_GetStyle("font"))
			button:SetStyle("fontHeight", self:_GetStyle("fontHeight"))
			button:SetStyle("border", self:_GetStyle("border"))
			button:SetStyle("borderSize", self:_GetStyle("borderSize"))
			button:SetStyle("background", self:_GetStyle(buttonPath == selectedPath and "selectedBackground" or "background"))
			local textColor = self:_GetStyle(buttonPath == selectedPath and "selectedTextColor" or "textColor")
			button:SetStyle("textColor", textColor)
			button:SetStyle("disabledTextColor", textColor)
			button:SetText(buttonPath)
			button:SetStyle("height", height)
			button:SetStyle("width", buttonWidth)
			button:SetDisabled(self._disabled)
			local anchors = button:_GetStyle("anchors")
			if anchors then
				anchors[1][2] = offsetX
			else
				button:SetStyle("anchors", { { "TOPLEFT", offsetX, 0 } })
			end
			offsetX = offsetX + buttonWidth
		else
			button:Hide()
		end
	end

	self.__super:Draw()
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.ButtonOnClick(button)
	local self = button:GetParentElement()
	self:SetOption(button:GetText(), true)
end

function private.BooleanToggleHandler(self, value)
	assert(self._booleanTable and self._booleanKey)
	assert(value == YES or value == NO)
	self._booleanTable[self._booleanKey] = value == YES
end
