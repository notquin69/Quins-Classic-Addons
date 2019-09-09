-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Input UI Element Class.
-- The input element allows the user to enter text. It is a subclass of the @{Element} class.
-- @classmod Input

local _, TSM = ...
local private = { frameInputLookup = {} }
local Input = TSMAPI_FOUR.Class.DefineClass("Input", TSM.UI.Element)
TSM.UI.Input = Input
local IS_SCRIPT_HOOKED = { OnEscapePressed = true, OnEnterPressed = true, OnEditFocusGained = true, OnEditFocusLost = true }



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Input.__init(self)
	local frame = CreateFrame("EditBox", nil, nil, nil)

	self.__super:__init(frame)

	self._textStr = nil
	self._settingTable = nil
	self._settingKey = nil
	self._validation = nil
	self._clearBtn = nil
	self._allowEnter = nil
	self._spacing = nil
	self._multiLine = nil
	self._compStart = nil
	self._userScriptHandlers = {}

	frame:SetShadowColor(0, 0, 0, 0)
	frame:SetAutoFocus(false)
	frame:SetScript("OnSizeChanged", private.OnSizeChanged)
	frame:SetScript("OnEscapePressed", private.OnEscapePressed)
	frame:SetScript("OnEnterPressed", private.OnEnterPressed)
	frame:SetScript("OnEditFocusGained", private.OnEditFocusGained)
	frame:SetScript("OnEditFocusLost", private.OnEditFocusLost)
	frame:SetScript("OnChar", private.OnChar)
	frame:SetScript("OnTabPressed", private.OnTabPressed)

	frame.bgLeft = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgLeft:SetPoint("TOPLEFT")
	frame.bgLeft:SetPoint("BOTTOMLEFT")

	frame.bgRight = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgRight:SetPoint("TOPRIGHT")
	frame.bgRight:SetPoint("BOTTOMRIGHT")

	frame.bgMiddle = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgMiddle:SetPoint("TOPLEFT", frame.bgLeft, "TOPRIGHT")
	frame.bgMiddle:SetPoint("BOTTOMRIGHT", frame.bgRight, "BOTTOMLEFT")

	private.frameInputLookup[frame] = self
end

function Input.Acquire(self)
	self._hintText = TSMAPI_FOUR.UI.NewElement("Text", self._id.."_HintText")
	self._hintText:_GetBaseFrame():SetParent(self:_GetBaseFrame())
	self._hintText:_GetBaseFrame():SetPoint("TOPLEFT", 8, 0)
	self._hintText:_GetBaseFrame():SetPoint("BOTTOMRIGHT", -8, 0)
	self._clearBtn = TSMAPI_FOUR.UI.NewElement("Button", self._id.."_ClearBtn")
	self._clearBtn:_SetParentElement(self)
	self._clearBtn:_GetBaseFrame():SetParent(self:_GetBaseFrame())
	self._clearBtn:_GetBaseFrame():SetPoint("RIGHT", -5, 0)
	self._clearBtn:SetScript("OnClick", private.ClearBtnOnClick)
	self._textStr = ""
	self:_GetBaseFrame():SetScript("OnEnterPressed", private.OnEnterPressed)
	self.__super:Acquire()
end

function Input.Release(self)
	wipe(self._userScriptHandlers)
	self:_GetBaseFrame():ClearFocus()
	self:_GetBaseFrame():Enable()
	self:_GetBaseFrame():EnableMouse(true)
	self:_GetBaseFrame():EnableKeyboard(true)
	self:_GetBaseFrame():SetSpacing(0)
	self:_GetBaseFrame():SetMultiLine(false)
	self:_GetBaseFrame():SetHitRectInsets(0, 0, 0, 0)
	self:_GetBaseFrame():SetMaxLetters(2147483647)
	self._hintText:Release()
	self._hintText = nil
	self._clearBtn:Release()
	self._clearBtn = nil
	self._allowEnter = nil
	self._spacing = nil
	self._multiLine = nil
	self._compStart = nil
	self._settingTable = nil
	self._settingKey = nil
	self._validation = nil
	self.__super:Release()
end

--- Enables mouse interactivity for the input.
-- @tparam Input self The input object
-- @tparam boolean enable Enable or disable the mouse
-- @treturn Input The input object
function Input.EnableMouse(self, enable)
	self:_GetBaseFrame():EnableMouse(enable)
	return self
end

--- Enables keyboard interactivity for the input.
-- @tparam Input self The input object
-- @tparam boolean enable Enable or disable the keyboard
-- @treturn Input The input object
function Input.EnableKeyboard(self, enable)
	self:_GetBaseFrame():EnableKeyboard(enable)
	return self
end

--- Set the highlight to all or some of the input's text.
-- @tparam Input self The input object
-- @tparam number the position at which to start the highlight
-- @tparam number the position at which to stop the highlight
-- @treturn Input The input object
function Input.HighlightText(self, starting, ending)
	if starting and ending then
		self:_GetBaseFrame():HighlightText(starting, ending)
	else
		self:_GetBaseFrame():HighlightText()
	end
	return self
end

--- Sets the current text.
-- @tparam Input self The input object
-- @tparam string text The current text
-- @treturn Input The input object
function Input.SetText(self, text)
	self._textStr = text
	return self
end

--- Sets the hint text.
-- The hint text is shown when there's no other text in the input.
-- @tparam Input self The input object
-- @tparam string text The hint text
-- @treturn Input The input object
function Input.SetHintText(self, text)
	self._hintText:SetText(text)
	return self
end


--- Returns the input's focus state.
-- @tparam Input self The input object
function Input.HasFocus(self)
	return self:_GetBaseFrame():HasFocus()
end

--- Sets whether or not this input is focused.
-- @tparam Input self The input object
-- @tparam boolean focused Whether or not this input is focused
-- @treturn Input The input object
function Input.SetFocused(self, focused)
	if focused then
		self:_GetBaseFrame():SetFocus()
	else
		self:_GetBaseFrame():ClearFocus()
	end
	return self
end

--- Set the maximum number of letters for the input's entered text.
-- @tparam Input self The input object
-- @tparam number the number of letters for entered text
-- @treturn Input The input object
function Input.SetMaxLetters(self, number)
	self:_GetBaseFrame():SetMaxLetters(number)
	return self
end

--- Sets whether or not this input is multiline
-- @tparam Input self The input object
-- @tparam boolean multiLine Whether or not this input is multiline
-- @treturn Input The input object
function Input.SetMultiLine(self, multiLine, allowEnter)
	local frame = self:_GetBaseFrame()
	self._multiLine = multiLine
	self._allowEnter = allowEnter
	frame:SetText("")
	frame:SetMultiLine(multiLine)
	if self._multiLine and not self._allowEnter then
		frame:SetScript("OnEnterPressed", nil)
	end
	frame:SetText(self._textStr)
	return self
end

--- Set the hit rectangle insets.
-- @tparam Input self The input object
-- @tparam number left How much the left side of the hit rectangle is inset
-- @tparam number right How much the right side of the hit rectangle is inset
-- @tparam number top How much the top side of the hit rectangle is inset
-- @tparam number bottom How much the bottom side of the hit rectangle is inset
-- @treturn Input The input object
function Input.SetHitRectInsets(self, left, right, top, bottom)
	self:_GetBaseFrame():SetHitRectInsets(left, right, top, bottom)
	return self
end

--- Gets the input height.
-- @tparam Input self The input object
-- @treturn number The input height
function Input.GetHeight(self)
	return self:_GetBaseFrame():GetHeight()
end

--- Gets the input text.
-- @tparam Input self The input object
-- @treturn string The input text
function Input.GetText(self)
	return self:_GetBaseFrame():GetText()
end

--- Sets the input spacing.
-- @tparam Input self The input object
-- @treturn Input The input object
function Input.SetSpacing(self, spacing)
	self._spacing = spacing
	self:_GetBaseFrame():SetSpacing(spacing)
	return self
end

function Input.SetScript(self, script, handler)
	if IS_SCRIPT_HOOKED[script] then
		self._userScriptHandlers[script] = handler
		return self
	else
		return self.__super:SetScript(script, handler)
	end
end

--- Gets the height of the text string.
-- @tparam Input self The input object
-- @treturn number The text string height
function Input.GetStringHeight(self)
	-- use the hint text in order to get the string height since EditBox doesn't support it directly
	local prev = self._hintText:GetText() or ""
	self._hintText:SetText(self._textStr)
	local result = self._hintText:GetStringHeight() + self:_GetStyle("textInset") * 2
	self._hintText:SetText(prev)
	self._hintText:Draw()
	return result
end

--- Sets the setting info.
-- This method is used to have the value of the input automatically correspond with the value of a field in a table.
-- This is useful for inputs which are tied directly to settings.
-- @tparam Input self The input object
-- @tparam table tbl The table which the field to set belongs to
-- @tparam string key The key into the table to be set based on the input state
-- @tparam function validation A function which is used to validate the text value before setting it
-- @treturn Input The input object
function Input.SetSettingInfo(self, tbl, key, validation)
	self._settingTable = tbl
	self._settingKey = key
	self._validation = validation
	self:SetText(tbl[key])
	return self
end

function Input.Draw(self)
	self.__super:Draw()
	local frame = self:_GetBaseFrame()

	local inset = self:_GetStyle("textInset")
	frame:SetTextInsets(inset, inset, inset, inset)

	local texturePacks = self:_GetStyle("backgroundTexturePacks")
	if texturePacks and not self._multiLine then
		TSM.UI.TexturePacks.SetTextureAndWidth(frame.bgLeft, texturePacks.."Left")
		TSM.UI.TexturePacks.SetTexture(frame.bgMiddle, texturePacks.."Middle")
		TSM.UI.TexturePacks.SetTextureAndWidth(frame.bgRight, texturePacks.."Right")
		frame.bgLeft:Show()
		frame.bgMiddle:Show()
		frame.bgRight:Show()
		self:SetStyle("background", "#00000000")
		self:SetStyle("border", "#00000000")
	else
		frame.bgLeft:Hide()
		frame.bgMiddle:Hide()
		frame.bgRight:Hide()
		if self._multiLine then
			self:SetStyle("background", "#00000000")
			self:SetStyle("border", "#00000000")
		end
	end
	self:_ApplyFrameStyle(frame)
	self:_ApplyTextStyle(frame)

	-- set the highlight color
	frame:SetHighlightColor(TSM.UI.HexToRGBA(self:_GetStyle("highlightColor")))

	-- set the text
	frame:SetText(self._textStr)

	if self._textStr == "" and not frame:HasFocus() and self._hintText:GetText() ~= "" then
		self._hintText:SetStyle("font", self:_GetStyle("font"))
		self._hintText:SetStyle("fontHeight", self:_GetStyle("fontHeight"))
		self._hintText:SetStyle("justifyH", self:_GetStyle("hintJustifyH"))
		self._hintText:SetStyle("justifyV", self:_GetStyle("hintJustifyV"))
		self._hintText:SetStyle("textColor", self:_GetStyle("hintTextColor"))
		self._hintText:Show()
		self._hintText:Draw()
	else
		self._hintText:Hide()
	end

	if self._textStr == "" then
		self._clearBtn:Hide()
	else
		if self:_GetStyle("clearButton") then
			self._clearBtn:SetStyle("width", TSM.UI.TexturePacks.GetWidth("iconPack.14x14/Close/Circle"))
			self._clearBtn:SetStyle("height", TSM.UI.TexturePacks.GetHeight("iconPack.14x14/Close/Circle"))
			self._clearBtn:SetStyle("backgroundTexturePack", "iconPack.14x14/Close/Circle")
			self._clearBtn:SetStyle("backgroundVertexColor", self:_GetStyle("textColor"))
			self._clearBtn:Show()
			self._clearBtn:Draw()
		else
			self._clearBtn:Hide()
		end
	end
end

--- Sets whether or not the input is disabled.
-- @tparam Input self The input object
-- @tparam boolean disabled Whether or not the input is disabled
-- @treturn Input The input object
function Input.SetDisabled(self, disabled)
	if disabled then
		self:_GetBaseFrame():Disable()
	else
		self:_GetBaseFrame():Enable()
	end
	return self
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.OnSizeChanged(frame)
	local self = private.frameInputLookup[frame]

	if self._userScriptHandlers.OnSizeChanged then
		self._userScriptHandlers.OnSizeChanged(self)
	end
end

function private.OnEscapePressed(frame)
	frame:ClearFocus()
	frame:HighlightText(0, 0)

	local self = private.frameInputLookup[frame]

	if self._settingTable and self._settingKey then
		self:Draw()
	end

	if self._userScriptHandlers.OnEscapePressed then
		self._userScriptHandlers.OnEscapePressed(self)
	end
end

function private.OnEnterPressed(frame)
	local self = private.frameInputLookup[frame]
	local text = self:GetText()
	frame:ClearFocus()
	frame:HighlightText(0, 0)

	if self._settingTable and self._settingKey then
		local value = strtrim(text)
		if not self._validation or self._validation(value) then
			self._settingTable[self._settingKey] = value
			self:SetText(value)
		end
	else
		self:SetText(text)
	end
	self:Draw()

	if self._userScriptHandlers.OnEnterPressed then
		self._userScriptHandlers.OnEnterPressed(self)
	end
end

function private.OnEditFocusGained(frame)
	local self = private.frameInputLookup[frame]
	self:Draw()
	if self._userScriptHandlers.OnEditFocusGained then
		self._userScriptHandlers.OnEditFocusGained(self)
	end
end

function private.OnEditFocusLost(frame)
	local self = private.frameInputLookup[frame]
	self:Draw()
	if self._userScriptHandlers.OnEditFocusLost then
		self._userScriptHandlers.OnEditFocusLost(self)
	end
end

function private.OnChar(frame)
	local self = private.frameInputLookup[frame]
	if not self:_GetStyle("autoComplete") then
		return
	end
	local text = self:GetText()
	local match = nil
	for k in pairs(self:_GetStyle("autoComplete")) do
		local start, ending = strfind(strlower(k), "^"..TSMAPI_FOUR.Util.StrEscape(strlower(text)))
		if start and ending and ending == #text then
			match = k
			break
		end
	end
	if match and not IsControlKeyDown() then
		self._compStart = #text
		self:SetText(match)
	else
		self._compStart = nil
		self:SetText(text)
	end
	self:Draw()
	if self._userScriptHandlers.OnChar then
		self._userScriptHandlers.OnChar(self)
	end
end

function private.OnTabPressed(frame)
	local self = private.frameInputLookup[frame]
	self:Draw()
	if self._userScriptHandlers.OnTabPressed then
		self._userScriptHandlers.OnTabPressed(self)
	end
end

function private.ClearBtnOnClick(button)
	local self = button:GetParentElement()
	self:SetFocused(false)
	self:SetText("")
	self:Draw()
	if self._userScriptHandlers.OnEnterPressed then
		self._userScriptHandlers.OnEnterPressed(self)
	end
end
