-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- EditableText UI Element Class.
-- A text element which has an editing state. It is a subclass of the @{Element} class.
-- @classmod EditableText

local _, TSM = ...
local private = { frameEditableTextLookup = {} }
local EditableText = TSMAPI_FOUR.Class.DefineClass("EditableText", TSM.UI.Element)
TSM.UI.EditableText = EditableText
local STRING_RIGHT_PADDING = 16



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function EditableText.__init(self)
	local frame = CreateFrame("EditBox", nil, nil, nil)

	self.__super:__init(frame)

	frame:SetShadowColor(0, 0, 0, 0)
	frame:SetAutoFocus(false)
	frame:SetScript("OnEscapePressed", private.OnEscapePressed)
	frame:SetScript("OnEnterPressed", private.OnEnterPressed)
	frame:SetScript("OnEditFocusGained", private.OnEditFocusGained)
	frame:SetScript("OnEditFocusLost", private.OnEditFocusLost)
	private.frameEditableTextLookup[frame] = self

	frame.text = frame:CreateFontString()
	frame.text:SetAllPoints()

	self._textStr = ""
	self._editing = false
	self._onValueChangedHandler = nil
	self._onEditingChangedHandler = nil
end

function EditableText.Acquire(self)
	self:_GetBaseFrame():Disable()
	self.__super:Acquire()
end

function EditableText.Release(self)
	self:_GetBaseFrame():ClearFocus()
	self._textStr = ""
	self._editing = false
	self._onValueChangedHandler = nil
	self._onEditingChangedHandler = nil
	self.__super:Release()
end

--- Sets the text string.
-- @tparam EditableText self The editable text object
-- @tparam string text The text string
-- @treturn EditableText The editable text object
function EditableText.SetText(self, text)
	assert(text)
	self._textStr = text
	return self
end

--- Gets the text string.
-- @tparam EditableText self The editable text object
-- @treturn string The text string
function EditableText.GetText(self)
	return self._textStr
end

--- Registers a script handler.
-- @tparam EditableText self The editable text object
-- @tparam string script The script to register for (supported scripts: `OnValueChanged`, `OnEditingChanged`)
-- @tparam function handler The script handler which will be called with the editable text object followed by any
-- arguments to the script
-- @treturn EditableText The editable text object
function EditableText.SetScript(self, script, handler)
	if script == "OnValueChanged" then
		self._onValueChangedHandler = handler
	elseif script == "OnEditingChanged" then
		self._onEditingChangedHandler = handler
	elseif script == "OnEnter" or script == "OnLeave" or script == "OnMouseDown" then
		self.__super:SetScript(script, handler)
	else
		error("Unknown EditableText script: "..tostring(script))
	end
	return self
end

--- Sets whether or not the text is currently being edited.
-- @tparam EditableText self The editable text object
-- @tparam boolean editing The editing state to set
-- @treturn EditableText The editable text object
function EditableText.SetEditing(self, editing)
	self._editing = editing
	if self._onEditingChangedHandler then
		self:_onEditingChangedHandler(editing)
	end
	if self:_GetStyle("autoWidth") then
		self:GetParentElement():Draw()
	else
		self:Draw()
	end
	return self
end

--- Gets the rendered text string width.
-- @tparam EditableText self The editable text object
-- @treturn number Text width
function EditableText.GetStringWidth(self)
	local text = self:_GetBaseFrame().text
	self:_ApplyTextStyle(text)
	text:SetText(self._textStr)
	return text:GetStringWidth()
end

function EditableText.Draw(self)
	self.__super:Draw()
	local frame = self:_GetBaseFrame()
	self:_ApplyFrameStyle(frame)
	self:_ApplyTextStyle(frame)
	self:_ApplyTextStyle(frame.text)
	frame.text:SetText(self._textStr)
	if self._editing then
		frame:Enable()
		frame:SetText(self._textStr)
		frame:SetFocus()
		frame:HighlightText(0, -1)
		frame.text:Hide()
	else
		frame:SetText("")
		frame:ClearFocus()
		frame:HighlightText(0, 0)
		frame:Disable()
		frame.text:Show()
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function EditableText._GetMinimumDimension(self, dimension)
	if dimension == "WIDTH" and self:_GetStyle("autoWidth") then
		return 0, true
	else
		return self.__super:_GetMinimumDimension(dimension)
	end
end

function EditableText._GetPreferredDimension(self, dimension)
	if dimension == "WIDTH" and self:_GetStyle("autoWidth") and not self._editing then
		return self:GetStringWidth() + STRING_RIGHT_PADDING
	else
		return self.__super:_GetPreferredDimension(dimension)
	end
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.OnEscapePressed(frame)
	local self = private.frameEditableTextLookup[frame]
	self:SetEditing(false)
end

function private.OnEnterPressed(frame)
	local newText = frame:GetText()
	local self = private.frameEditableTextLookup[frame]
	self:SetEditing(false)
	self:_onValueChangedHandler(newText)
end
