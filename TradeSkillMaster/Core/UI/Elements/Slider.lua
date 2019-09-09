-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Slider UI Element Class.
-- A slider allows for selecting a numerical range. It is a subclass of the @{Element} class.
-- @classmod Slider

local _, TSM = ...
local Slider = TSMAPI_FOUR.Class.DefineClass("Slider", TSM.UI.Element)
TSM.UI.Slider = Slider
local private = { frameSliderLookup = {} }
local THUMB_WIDTH = 8
local THUMB_TEXT_PADDING = 2
local INPUT_WIDTH = 70
local INPUT_AREA_SPACE = 190



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Slider.__init(self)
	local frame = CreateFrame("Frame", nil, nil, nil)
	frame:EnableMouse(true)
	frame:SetScript("OnMouseDown", private.FrameOnMouseDown)
	frame:SetScript("OnMouseUp", private.FrameOnMouseUp)
	frame:SetScript("OnUpdate", private.FrameOnUpdate)
	private.frameSliderLookup[frame] = self

	self.__super:__init(frame)

	-- create the textures
	frame.barTexture = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	frame.activeBarTexture = frame:CreateTexture(nil, "BACKGROUND", nil, 2)
	frame.thumbTextureLeft = frame:CreateTexture(nil, "ARTWORK")
	frame.thumbTextureRight = frame:CreateTexture(nil, "ARTWORK")

	frame.inputLeft = CreateFrame("EditBox", nil, frame, nil)
	frame.inputLeft:SetJustifyH("CENTER")
	frame.inputLeft:SetWidth(INPUT_WIDTH)
	frame.inputLeft:SetHeight(24)
	frame.inputLeft:SetAutoFocus(false)
	frame.inputLeft:SetNumeric(true)
	frame.inputLeft:SetScript("OnEscapePressed", private.InputOnEscapePressed)
	frame.inputLeft:SetScript("OnEnterPressed", private.InputOnEnterPressed)

	frame.dash = frame:CreateFontString()
	frame.dash:SetJustifyH("CENTER")
	frame.dash:SetWidth(20)

	frame.inputRight = CreateFrame("EditBox", nil, frame, nil)
	frame.inputRight:SetJustifyH("CENTER")
	frame.inputRight:SetWidth(INPUT_WIDTH)
	frame.inputRight:SetHeight(24)
	frame.inputRight:SetNumeric(true)
	frame.inputRight:SetAutoFocus(false)
	frame.inputRight:SetScript("OnEscapePressed", private.InputOnEscapePressed)
	frame.inputRight:SetScript("OnEnterPressed", private.InputOnEnterPressed)

	frame.leftBgLeft = frame:CreateTexture(nil, "BACKGROUND")
	frame.leftBgLeft:SetPoint("TOPLEFT", frame.inputLeft)
	frame.leftBgLeft:SetPoint("BOTTOMLEFT")

	frame.leftBgRight = frame:CreateTexture(nil, "BACKGROUND")
	frame.leftBgRight:SetPoint("TOPRIGHT", frame.inputLeft)
	frame.leftBgRight:SetPoint("BOTTOMRIGHT")

	frame.leftBgMiddle = frame:CreateTexture(nil, "BACKGROUND")
	frame.leftBgMiddle:SetPoint("TOPLEFT", frame.leftBgLeft, "TOPRIGHT")
	frame.leftBgMiddle:SetPoint("BOTTOMRIGHT", frame.leftBgRight, "BOTTOMLEFT")

	frame.rightBgLeft = frame:CreateTexture(nil, "BACKGROUND")
	frame.rightBgLeft:SetPoint("TOPLEFT", frame.inputRight)
	frame.rightBgLeft:SetPoint("BOTTOMLEFT")

	frame.rightBgRight = frame:CreateTexture(nil, "BACKGROUND")
	frame.rightBgRight:SetPoint("TOPRIGHT", frame.inputRight)
	frame.rightBgRight:SetPoint("BOTTOMRIGHT")

	frame.rightBgMiddle = frame:CreateTexture(nil, "BACKGROUND")
	frame.rightBgMiddle:SetPoint("TOPLEFT", frame.rightBgLeft, "TOPRIGHT")
	frame.rightBgMiddle:SetPoint("BOTTOMRIGHT", frame.rightBgRight, "BOTTOMLEFT")

	self._leftValue = nil
	self._rightValue = nil
	self._minValue = nil
	self._maxValue = nil
	self._dragging = nil
end

function Slider.Acquire(self)
	local frame = self:_GetBaseFrame()
	frame.dash:Show()
	frame.inputLeft:Show()
	frame.inputRight:Show()
	self.__super:Acquire()
end

function Slider.Release(self)
	self._leftValue = nil
	self._rightValue = nil
	self._minValue = nil
	self._maxValue = nil
	self._dragging = nil
	self.__super:Release()
end

--- Set the extends of the possible range.
-- @tparam Slider self The slider object
-- @tparam number minValue The minimum value
-- @tparam number maxValue The maxmimum value
-- @treturn Slider The slider object
function Slider.SetRange(self, minValue, maxValue)
	self._minValue = minValue
	self._maxValue = maxValue
	self._leftValue = minValue
	self._rightValue = maxValue
	return self
end

--- Sets the current value.
-- @tparam Slider self The slider object
-- @tparam number leftValue The lower end of the range
-- @tparam number rightValue The upper end of the range
-- @treturn Slider The slider object
function Slider.SetValue(self, leftValue, rightValue)
	assert(leftValue < rightValue and leftValue >= self._minValue and rightValue <= self._maxValue)
	self._leftValue = leftValue
	self._rightValue = rightValue
	return self
end

--- Gets the current value
-- @tparam Slider self The slider object
-- @treturn number The lower end of the range
-- @treturn number The upper end of the range
function Slider.GetValue(self)
	return self._leftValue, self._rightValue
end

function Slider.Draw(self)
	self.__super:Draw()
	local frame = self:_GetBaseFrame()

	local sliderHeight = self:_GetDimension("HEIGHT") / 2 - THUMB_TEXT_PADDING
	local width = self:_GetDimension("WIDTH") - INPUT_AREA_SPACE
	local leftPos = TSMAPI_FOUR.Util.Scale(self._leftValue, self._minValue, self._maxValue, 0, width - THUMB_WIDTH)
	local rightPos = TSMAPI_FOUR.Util.Scale(self._rightValue, self._minValue, self._maxValue, 0, width - THUMB_WIDTH)

	-- wow renders the font slightly bigger than the designs would indicate, so subtract one from the font height
	frame.inputRight:SetFont(self:_GetStyle("font"), self:_GetStyle("fontHeight") - 1)
	frame.inputRight:SetTextColor(TSM.UI.HexToRGBA(self:_GetStyle("textColor")))
	frame.inputRight:SetPoint("RIGHT", 0)
	frame.inputRight:SetNumber(self._rightValue)

	-- wow renders the font slightly bigger than the designs would indicate, so subtract one from the font height
	frame.dash:SetFont(self:_GetStyle("font"), self:_GetStyle("fontHeight") - 1)
	frame.dash:SetTextColor(TSM.UI.HexToRGBA(self:_GetStyle("textColor")))
	frame.dash:SetText("-")
	frame.dash:SetPoint("RIGHT", frame.inputRight, "LEFT", 0)

	-- wow renders the font slightly bigger than the designs would indicate, so subtract one from the font height
	frame.inputLeft:SetFont(self:_GetStyle("font"), self:_GetStyle("fontHeight") - 1)
	frame.inputLeft:SetTextColor(TSM.UI.HexToRGBA(self:_GetStyle("textColor")))
	frame.inputLeft:SetPoint("RIGHT", frame.dash, "LEFT", 0)
	frame.inputLeft:SetNumber(self._leftValue)

	frame.barTexture:ClearAllPoints()
	frame.barTexture:SetPoint("TOPLEFT", 0, -5)
	frame.barTexture:SetPoint("RIGHT", frame.inputLeft, "LEFT", -30, 0)
	frame.barTexture:SetHeight(sliderHeight / 2)
	frame.barTexture:SetColorTexture(TSM.UI.HexToRGBA("#22979797"))

	frame.thumbTextureLeft:SetHeight(sliderHeight)
	frame.thumbTextureLeft:SetWidth(THUMB_WIDTH)
	frame.thumbTextureLeft:SetColorTexture(TSM.UI.HexToRGBA("#ffffff"))
	frame.thumbTextureLeft:SetPoint("LEFT", frame.barTexture, leftPos, 0)

	frame.thumbTextureRight:SetHeight(sliderHeight)
	frame.thumbTextureRight:SetWidth(THUMB_WIDTH)
	frame.thumbTextureRight:SetColorTexture(TSM.UI.HexToRGBA("#ffffff"))
	frame.thumbTextureRight:SetPoint("LEFT", frame.barTexture, rightPos, 0)

	frame.activeBarTexture:SetPoint("LEFT", frame.thumbTextureLeft, "CENTER")
	frame.activeBarTexture:SetPoint("RIGHT", frame.thumbTextureRight, "CENTER")
	frame.activeBarTexture:SetHeight(sliderHeight / 2)
	frame.activeBarTexture:SetColorTexture(TSM.UI.HexToRGBA("#ffffff"))

	TSM.UI.TexturePacks.SetTextureAndWidth(frame.leftBgLeft, "uiFrames.ActiveInputFieldLeft")
	TSM.UI.TexturePacks.SetTexture(frame.leftBgMiddle, "uiFrames.ActiveInputFieldMiddle")
	TSM.UI.TexturePacks.SetTextureAndWidth(frame.leftBgRight, "uiFrames.ActiveInputFieldRight")

	TSM.UI.TexturePacks.SetTextureAndWidth(frame.rightBgLeft, "uiFrames.ActiveInputFieldLeft")
	TSM.UI.TexturePacks.SetTexture(frame.rightBgMiddle, "uiFrames.ActiveInputFieldMiddle")
	TSM.UI.TexturePacks.SetTextureAndWidth(frame.rightBgRight, "uiFrames.ActiveInputFieldRight")
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function Slider._GetCursorPositionValue(self)
	local frame = self:_GetBaseFrame()
	local x = GetCursorPosition() / frame:GetEffectiveScale()
	local left = frame:GetLeft() + THUMB_WIDTH / 2
	local right = frame:GetRight() - THUMB_WIDTH - INPUT_AREA_SPACE * 2 / 2
	x = min(max(x, left), right)
	local value = TSMAPI_FOUR.Util.Scale(x, left, right, self._minValue, self._maxValue)
	return min(max(TSMAPI_FOUR.Util.Round(value), self._minValue), self._maxValue)
end

function Slider._UpdateLeftValue(self, value)
	local newValue = max(min(value, self._rightValue), self._minValue)
	if newValue == self._leftValue then
		return
	end
	self._leftValue = newValue
	self:Draw()
end

function Slider._UpdateRightValue(self, value)
	local newValue = min(max(value, self._leftValue), self._maxValue)
	if newValue == self._rightValue then
		return
	end
	self._rightValue = newValue
	self:Draw()
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.InputOnEscapePressed(input)
	input:ClearFocus()
end

function private.InputOnEnterPressed(input)
	input:ClearFocus()
	local frame = input:GetParent()
	local self = private.frameSliderLookup[frame]
	if input == frame.inputLeft then
		self:_UpdateLeftValue(input:GetNumber())
	elseif input == frame.inputRight then
		self:_UpdateRightValue(input:GetNumber())
	else
		error("Unexpected input")
	end
end

function private.FrameOnMouseDown(frame)
	local self = private.frameSliderLookup[frame]
	private.InputOnEscapePressed(frame.inputLeft)
	private.InputOnEscapePressed(frame.inputRight)
	local value = self:_GetCursorPositionValue()
	local leftDiff = abs(value - self._leftValue)
	local rightDiff = abs(value - self._rightValue)
	if value < self._leftValue then
		-- clicked to the left of the left thumb, so drag that
		self._dragging = "left"
	elseif value > self._rightValue then
		-- clicked to the right of the right thumb, so drag that
		self._dragging = "right"
	elseif self._leftValue == self._rightValue then
		-- just ignore this click since they clicked on both thumbs
	elseif leftDiff < rightDiff then
		-- clicked closer to the left thumb, so drag that
		self._dragging = "left"
	else
		-- clicked closer to the right thumb (or right in the middle), so drag that
		self._dragging = "right"
	end
end

function private.FrameOnMouseUp(frame)
	local self = private.frameSliderLookup[frame]
	self._dragging = nil
end

function private.FrameOnUpdate(frame)
	local self = private.frameSliderLookup[frame]
	if not self._dragging then
		return
	end
	if self._dragging == "left" then
		self:_UpdateLeftValue(self:_GetCursorPositionValue())
	elseif self._dragging == "right" then
		self:_UpdateRightValue(self:_GetCursorPositionValue())
	else
		error("Unexpected dragging: "..tostring(self._dragging))
	end
end
