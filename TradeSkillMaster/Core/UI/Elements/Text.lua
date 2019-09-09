-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Text UI Element Class.
-- A text element simply holds a text string. It is a subclass of the @{Element} class.
-- @classmod Text

local _, TSM = ...
local Text = TSMAPI_FOUR.Class.DefineClass("Text", TSM.UI.Element)
TSM.UI.Text = Text



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Text.__init(self)
	local frame = CreateFrame("Frame", nil, nil, nil)

	self.__super:__init(frame)

	frame.text = frame:CreateFontString()
	frame.text:SetAllPoints()
end

function Text.Acquire(self)
	self._textStr = ""
	self:_GetBaseFrame():EnableMouse(false)
	self:_GetBaseFrame().text:SetSpacing(0)
	self.__super:Acquire()
end

--- Set the text.
-- @tparam Text self The text object
-- @tparam string text The text
-- @treturn Text The text object
function Text.SetText(self, text)
	self._textStr = text
	return self
end

--- Set formatted text.
-- @tparam Text self The text object
-- @tparam vararg ... The format string and parameters
-- @treturn Text The text object
function Text.SetFormattedText(self, ...)
	self._textStr = format(...)
	return self
end

--- Gets the text string
-- @tparam Text self The text object
-- @treturn string The text string
function Text.GetText(self)
	return self._textStr
end

--- Get the rendered text string width.
-- @tparam Text self The text object
-- @treturn number The rendered text string width
function Text.GetStringWidth(self)
	local frame = self:_GetBaseFrame()
	self:_ApplyTextStyle(frame.text)
	frame.text:SetText(self._textStr)
	return frame.text:GetStringWidth()
end

--- Get the rendered text string height.
-- @tparam Text self The text object
-- @treturn number The rendered text string height
function Text.GetStringHeight(self)
	local frame = self:_GetBaseFrame()
	self:_ApplyTextStyle(frame.text)
	frame.text:SetText(self._textStr)
	return frame.text:GetStringHeight()
end

function Text.Draw(self)
	self.__super:Draw()
	local frame = self:_GetBaseFrame()
	self:_ApplyTextStyle(frame.text)

	-- set the text
	frame.text:SetText(self._textStr)

	local spacing = self:_GetStyle("fontSpacing")
	if spacing then
		frame.text:SetSpacing(spacing)
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function Text._GetMinimumDimension(self, dimension)
	if dimension == "WIDTH" and self:_GetStyle("autoWidth") then
		return self:GetStringWidth(), nil
	else
		return self.__super:_GetMinimumDimension(dimension)
	end
end
