-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- ActionButton UI Element Class.
-- An action button is a button which uses specific background textures and has a pressed state. It is a subclass of the
-- @{Element} class.
-- @classmod ActionButton

local _, TSM = ...
local ActionButton = TSMAPI_FOUR.Class.DefineClass("ActionButton", TSM.UI.Element)
TSM.UI.ActionButton = ActionButton
local private = { frameButtonLookup = {} }
local ICON_PADDING = 2
local CLICK_COOLDOWN = 0.2



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ActionButton.__init(self, name, isSecure)
	local frame = CreateFrame("Button", name, nil, isSecure and "SecureActionButtonTemplate" or nil)
	frame:SetScript(isSecure and "PostClick" or "OnClick", private.OnClick)
	frame:SetScript("OnEnter", private.OnEnter)
	frame:SetScript("OnLeave", private.OnLeave)
	private.frameButtonLookup[frame] = self

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

	-- create the text
	frame.text = frame:CreateFontString()

	-- create the icon
	frame.icon = frame:CreateTexture(nil, "ARTWORK")
	frame.icon:SetPoint("RIGHT", frame.text, "LEFT", -ICON_PADDING, 0)

	self._pressed = false
	self._disabled = false
	self._hover = false
	self._textStr = ""
	self._onClickHandler = nil
	self._onEnterHandler = nil
	self._onLeaveHandler = nil
	self._clickCooldown = nil
	self._clickCooldownDisabled = false
end

function ActionButton.Acquire(self)
	self._pressed = false
	self._disabled = false
	self._hover = false
	self._textStr = ""
	self:_GetBaseFrame():Enable()
	self:_GetBaseFrame():RegisterForClicks("LeftButtonUp")
	self.__super:Acquire()
end

function ActionButton.Release(self)
	self._onClickHandler = nil
	self._onEnterHandler = nil
	self._onLeaveHandler = nil
	self._clickCooldown = nil
	self._clickCooldownDisabled = false
	self:_GetBaseFrame():SetScript("OnUpdate", nil)
	self.__super:Release()
end

--- Sets a script handler.
-- @see Element.SetScript
-- @tparam ActionButton self The action button object
-- @tparam string script The script to register for (currently only supports `OnClick`)
-- @tparam function handler The script handler which will be called with the action button object followed by any
-- arguments to the script
-- @treturn ActionButton The action button object
function ActionButton.SetScript(self, script, handler)
	if script == "OnClick" then
		self._onClickHandler = handler
	elseif script == "OnEnter" then
		self._onEnterHandler = handler
	elseif script == "OnLeave" then
		self._onLeaveHandler = handler
	elseif script == "OnMouseDown" or script == "OnMouseUp" then
		self.__super:SetScript(script, handler)
	else
		error("Unknown ActionButton script: "..tostring(script))
	end
	return self
end

--- Set the text shown within the action button.
-- @tparam ActionButton self The action button object
-- @tparam string text The text to be drawn within the action button
-- @treturn ActionButton The action button object
function ActionButton.SetText(self, text)
	self._textStr = text
	return self
end

--- Set whether or not the action button is disabled.
-- @tparam ActionButton self The action button object
-- @tparam boolean disabled Whether or not the action button should be disabled
-- @treturn ActionButton The action button object
function ActionButton.SetDisabled(self, disabled)
	self._disabled = disabled
	self:_UpdateDisabled()
	return self
end

--- Set whether or not the action button is pressed.
-- @tparam ActionButton self The action button object
-- @tparam boolean pressed Whether or not the action button should be pressed
-- @treturn ActionButton The action button object
function ActionButton.SetPressed(self, pressed)
	self._pressed = pressed
	self:_UpdateDisabled()
	return self
end

--- Disables the default click cooldown to allow the button to be spammed (i.e. for macro-able buttons).
-- @tparam ActionButton self The action button object
-- @treturn ActionButton The action button object
function ActionButton.DisableClickCooldown(self)
	self._clickCooldownDisabled = true
	return self
end

--- Click on the action button.
-- @tparam ActionButton self The action button object
function ActionButton.Click(self)
	local frame = self:_GetBaseFrame()
	if frame:IsEnabled() and frame:IsVisible() then
		private.OnClick(frame)
	end
end

function ActionButton.Draw(self)
	self.__super:Draw()

	local frame = self:_GetBaseFrame()
	self:_ApplyFrameStyle(frame)
	self:_ApplyTextStyle(frame.text)
	frame.text:SetText(self._textStr)

	local height = TSMAPI_FOUR.Util.Round(self:_GetDimension("HEIGHT"))
	local size = nil
	if height == 15 or height == 16 then
		size = "Small"
	elseif height == 20 then
		size = "Medium"
	elseif height == 26 then
		size = "Large"
	else
		error("Invalid ActionButton height: "..tostring(height))
	end

	-- set textures and text color depending on the state
	local textColor = nil
	if self._pressed or self._clickCooldown then
		textColor = self:_GetStyle("pressedTextColor")
		TSM.UI.TexturePacks.SetTextureAndWidth(frame.bgLeft, "uiFrames."..size.."ClickedButtonLeft")
		TSM.UI.TexturePacks.SetTexture(frame.bgMiddle, "uiFrames."..size.."ClickedButtonMiddle")
		TSM.UI.TexturePacks.SetTextureAndWidth(frame.bgRight, "uiFrames."..size.."ClickedButtonRight")
	elseif self._disabled then
		textColor = self:_GetStyle("inactiveTextColor")
		TSM.UI.TexturePacks.SetTextureAndWidth(frame.bgLeft, "uiFrames."..size.."InactiveButtonLeft")
		TSM.UI.TexturePacks.SetTexture(frame.bgMiddle, "uiFrames."..size.."InactiveButtonMiddle")
		TSM.UI.TexturePacks.SetTextureAndWidth(frame.bgRight, "uiFrames."..size.."InactiveButtonRight")
	elseif frame:IsMouseOver() then
		textColor = self:_GetStyle("textColor")
		TSM.UI.TexturePacks.SetTextureAndWidth(frame.bgLeft, "uiFrames."..size.."HoverButtonLeft")
		TSM.UI.TexturePacks.SetTexture(frame.bgMiddle, "uiFrames."..size.."HoverButtonMiddle")
		TSM.UI.TexturePacks.SetTextureAndWidth(frame.bgRight, "uiFrames."..size.."HoverButtonRight")
	else
		textColor = self:_GetStyle("textColor")
		TSM.UI.TexturePacks.SetTextureAndWidth(frame.bgLeft, "uiFrames."..size.."ActiveButtonLeft")
		TSM.UI.TexturePacks.SetTexture(frame.bgMiddle, "uiFrames."..size.."ActiveButtonMiddle")
		TSM.UI.TexturePacks.SetTextureAndWidth(frame.bgRight, "uiFrames."..size.."ActiveButtonRight")
	end
	frame.text:SetTextColor(TSM.UI.HexToRGBA(textColor))

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

function ActionButton._UpdateDisabled(self)
	local frame = self:_GetBaseFrame()
	if self._disabled or self._pressed or self._clickCooldown then
		self._hover = false
		frame:Disable()
	else
		frame:Enable()
	end
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.OnClick(frame)
	local self = private.frameButtonLookup[frame]
	if not self._acquired then
		return
	end
	if not self._clickCooldownDisabled then
		self._clickCooldown = CLICK_COOLDOWN
		self:_UpdateDisabled()
		self:_GetBaseFrame():SetScript("OnUpdate", private.OnUpdate)
	end
	self:Draw()
	if self._onClickHandler then
		self:_onClickHandler()
	end
end

function private.OnEnter(frame)
	local self = private.frameButtonLookup[frame]
	if self._onEnterHandler then
		self:_onEnterHandler()
	end
	if self._disabled or self._pressed or self._clickCooldown then
		return
	end
	self._hover = true
	self:Draw()
end

function private.OnLeave(frame)
	local self = private.frameButtonLookup[frame]
	if self._onLeaveHandler then
		self:_onLeaveHandler()
	end
	if self._disabled or self._pressed or self._clickCooldown then
		return
	end
	self._hover = false
	self:Draw()
end

function private.OnUpdate(frame, elapsed)
	local self = private.frameButtonLookup[frame]
	self._clickCooldown = self._clickCooldown - elapsed
	if self._clickCooldown <= 0 then
		frame:SetScript("OnUpdate", nil)
		self._clickCooldown = nil
		self:_UpdateDisabled()
		self:Draw()
	end
end
