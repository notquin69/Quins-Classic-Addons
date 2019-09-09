-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Button UI Element Class.
-- A button is a clickable element which has text drawn over top of it. It is a subclass of the @{Element} class.
-- @classmod Button

local _, TSM = ...
local Button = TSMAPI_FOUR.Class.DefineClass("Button", TSM.UI.Element)
TSM.UI.Button = Button
local ICON_PADDING = 2



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Button.__init(self)
	local frame = CreateFrame("Button")

	self.__super:__init(frame)

	frame.backgroundTexture = frame:CreateTexture(nil, "BACKGROUND")

	-- create the highlight
	frame.highlight = frame:CreateTexture(nil, "HIGHLIGHT")
	frame.highlight:SetAllPoints()
	frame.highlight:SetBlendMode("BLEND")

	-- create the text
	frame.text = frame:CreateFontString()

	-- create the icon
	frame.icon = frame:CreateTexture(nil, "ARTWORK")
	frame.icon:SetPoint("RIGHT", frame.text, "LEFT", -ICON_PADDING, 0)

	self._textStr = ""
end

function Button.Acquire(self)
	self._textStr = ""
	self:_GetBaseFrame():Enable()
	self:_GetBaseFrame():RegisterForClicks("LeftButtonUp")
	self:_GetBaseFrame():SetHitRectInsets(0, 0, 0, 0)
	self.__super:Acquire()
end

--- Set the text shown within the button.
-- @tparam Button self The button object
-- @tparam string text The text to be drawn within the button
-- @treturn Button The button object
function Button.SetText(self, text)
	self._textStr = text
	return self
end

--- Set the formatted text to be shown within the button.
-- @tparam Button self The button object
-- @tparam vararg ... The format string and arguments
-- @treturn Button The button object
function Button.SetFormattedText(self, ...)
	self._textStr = format(...)
	return self
end

--- Set whether or not the button is disabled.
-- @tparam Button self The button object
-- @tparam boolean disabled Whether or not the button should be disabled
-- @treturn Button The button object
function Button.SetDisabled(self, disabled)
	if disabled then
		self:_GetBaseFrame():Disable()
	else
		self:_GetBaseFrame():Enable()
	end
	return self
end

--- Registers the button for drag events.
-- @tparam Button self The button object
-- @tparam string button The mouse button to register for drag events from
-- @treturn Button The button object
function Button.RegisterForDrag(self, button)
	self:_GetBaseFrame():RegisterForDrag(button)
	return self
end

--- Get the button's text.
-- @tparam Button self The button object
-- @treturn string The current text of the button
function Button.GetText(self)
	return self._textStr
end

--- Show the button's text.
-- @tparam Button self The button object
function Button.ShowText(self)
	self:_GetBaseFrame().text:Show()
end

--- Hide the button's text.
-- @tparam Button self The button object
function Button.HideText(self)
	self:_GetBaseFrame().text:Hide()
end

--- Get the width of the button's text string.
-- @tparam Button self The button object
-- @treturn number The width of the text string
function Button.GetStringWidth(self)
	local text = self:_GetBaseFrame().text
	self:_ApplyTextStyle(text)
	text:SetText(self._textStr)
	return text:GetStringWidth()
end

--- Click on the button.
-- @tparam Button self The button object
function Button.Click(self)
	self:_GetBaseFrame():Click()
end

--- Enable right-click events for the button.
-- @tparam Button self The button object
-- @treturn Button The button object
function Button.EnableRightClick(self)
	self:_GetBaseFrame():RegisterForClicks("LeftButtonUp", "RightButtonUp")
	return self
end

--- Set the hit rectangle insets for the button.
-- @tparam Button self The button object
-- @tparam number left How much the left side of the hit rectangle is inset
-- @tparam number right How much the right side of the hit rectangle is inset
-- @tparam number top How much the top side of the hit rectangle is inset
-- @tparam number bottom How much the bottom side of the hit rectangle is inset
-- @treturn Button The button object
function Button.SetHitRectInsets(self, left, right, top, bottom)
	self:_GetBaseFrame():SetHitRectInsets(left, right, top, bottom)
	return self
end

function Button.Draw(self)
	self.__super:Draw()
	self:_ApplyFrameBackgroundTexture()
	local frame = self:_GetBaseFrame()
	self:_ApplyTextStyle(frame.text)

	-- set the text color
	local textColor = self:_GetStyle(frame:IsEnabled() and "textColor" or "disabledTextColor")
	frame.text:SetTextColor(TSM.UI.HexToRGBA(textColor))

	-- set the text
	frame.text:SetText(self._textStr)

	-- set the highlight texture
	local highlight = self:_GetStyle("highlight")
	if highlight then
		frame.highlight:SetColorTexture(TSM.UI.HexToRGBA(highlight))
		frame:SetHighlightTexture(frame.highlight)
	else
		frame:SetHighlightTexture(nil)
	end

	local iconTexturePack = self:_GetStyle("iconTexturePack")
	if iconTexturePack then
		local iconSize = self:_GetStyle("iconSize")
		if iconSize then
			frame.icon:SetWidth(iconSize)
			frame.icon:SetHeight(iconSize)
			TSM.UI.TexturePacks.SetTexture(frame.icon, iconTexturePack)
		else
			TSM.UI.TexturePacks.SetTextureAndSize(frame.icon, iconTexturePack)
		end
		frame.icon:Show()
		frame.icon:SetVertexColor(TSM.UI.HexToRGBA(textColor))
		local xOffset = ((iconSize or TSM.UI.TexturePacks.GetWidth(iconTexturePack)) + ICON_PADDING) / 2
		frame.text:ClearAllPoints()
		frame.text:SetPoint("TOP", xOffset, 0)
		frame.text:SetPoint("BOTTOM", xOffset, 0)
		frame.text:SetWidth(frame.text:GetStringWidth())
	else
		frame.icon:Hide()
		frame.text:ClearAllPoints()
		frame.text:SetPoint("TOPLEFT", self:_GetStyle("textIndent") or 0, 0)
		frame.text:SetPoint("BOTTOMRIGHT")
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function Button._GetMinimumDimension(self, dimension)
	if dimension == "WIDTH" and self:_GetStyle("autoWidth") then
		return self:GetStringWidth(), nil
	else
		return self.__super:_GetMinimumDimension(dimension)
	end
end
