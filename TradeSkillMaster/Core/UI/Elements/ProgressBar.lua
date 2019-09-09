-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- ProgressBar UI Element Class.
-- The progress bar element is a left-to-right progress bar with an anaimated progress indicator and text. It is a
-- subclass of the @{Element} class.
-- @classmod ProgressBar

local _, TSM = ...
local ProgressBar = TSMAPI_FOUR.Class.DefineClass("ProgressBar", TSM.UI.Element)
TSM.UI.ProgressBar = ProgressBar
local PROGRESS_PADDING = 4
local PROGRESS_ICON_PADDING = 4



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ProgressBar.__init(self)
	local frame = CreateFrame("Frame", nil, nil, nil)

	self.__super:__init(frame)

	frame.bgLeft = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgLeft:SetPoint("TOPLEFT")
	frame.bgLeft:SetPoint("BOTTOMLEFT")
	TSM.UI.TexturePacks.SetWidth(frame.bgLeft, "uiFrames.LoadingBarLeft")

	frame.bgRight = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgRight:SetPoint("TOPRIGHT")
	frame.bgRight:SetPoint("BOTTOMRIGHT")
	TSM.UI.TexturePacks.SetWidth(frame.bgRight, "uiFrames.LoadingBarRight")

	frame.bgMiddle = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgMiddle:SetPoint("TOPLEFT", frame.bgLeft, "TOPRIGHT")
	frame.bgMiddle:SetPoint("BOTTOMRIGHT", frame.bgRight, "BOTTOMLEFT")

	-- create the progress texture
	frame.progress = frame:CreateTexture(nil, "ARTWORK")
	frame.progress:SetPoint("TOPLEFT", PROGRESS_PADDING, -PROGRESS_PADDING)
	frame.progress:SetPoint("BOTTOMLEFT", PROGRESS_PADDING, PROGRESS_PADDING)
	frame.progress:SetBlendMode("BLEND")

	-- create the text
	frame.text = frame:CreateFontString()

	-- create the progress icon
	frame.progressIcon = frame:CreateTexture(nil, "OVERLAY")
	frame.progressIcon:SetPoint("RIGHT", frame.text, "LEFT", -PROGRESS_ICON_PADDING, 0)

	frame.progressIcon.ag = frame.progressIcon:CreateAnimationGroup()
	local spin = frame.progressIcon.ag:CreateAnimation("Rotation")
	spin:SetDuration(2)
	spin:SetDegrees(360)
	frame.progressIcon.ag:SetLooping("REPEAT")

	self._progress = 0
	self._textStr = ""
	self._progressIconHidden = false
end

function ProgressBar.Acquire(self)
	self._progress = 0
	self._textStr = ""
	self._progressIconHidden = false
	self:_GetBaseFrame().progressIcon:Hide()
	self.__super:Acquire()
end

--- Sets the progress text.
-- @tparam ProgressBar self The progress bar object
-- @tparam string text The progress text
-- @treturn ProgressBar The progress bar object
function ProgressBar.SetText(self, text)
	self._textStr = text
	return self
end

--- Sets the progress.
-- @tparam ProgressBar self The progress bar object
-- @tparam number progress The progress from a value of 0 to 1 (inclusive)
-- @tparam boolean isDone Whether or not the progress is finished
-- @treturn ProgressBar The progress bar object
function ProgressBar.SetProgress(self, progress, isDone)
	self._progress = progress
	return self
end

--- Sets whether or not the progress indicator is hidden.
-- @tparam ProgressBar self The progress bar object
-- @tparam boolean hidden Whether or not the progress indicator is hidden
-- @treturn ProgressBar The progress bar object
function ProgressBar.SetProgressIconHidden(self, hidden)
	self._progressIconHidden = hidden
	return self
end

function ProgressBar.Draw(self)
	self.__super:Draw()
	local frame = self:_GetBaseFrame()

	TSM.UI.TexturePacks.SetTexture(frame.bgLeft, "uiFrames.LoadingBarLeft")
	TSM.UI.TexturePacks.SetTexture(frame.bgMiddle, "uiFrames.LoadingBarMiddle")
	TSM.UI.TexturePacks.SetTexture(frame.bgRight, "uiFrames.LoadingBarRight")

	self:_ApplyTextStyle(frame.text)
	frame.text:SetWidth(self:_GetDimension("WIDTH"))
	frame.text:SetText(self._textStr)
	frame.text:SetWidth(frame.text:GetStringWidth())
	frame.text:SetHeight(self:_GetDimension("HEIGHT"))
	frame.text:SetPoint("CENTER", self._progressIconHidden and 0 or ((TSM.UI.TexturePacks.GetWidth("iconPack.18x18/Running") + PROGRESS_ICON_PADDING) / 2), 0)

	TSM.UI.TexturePacks.SetTextureAndSize(frame.progressIcon, "iconPack.18x18/Running")
	frame.progressIcon:SetVertexColor(TSM.UI.HexToRGBA(self:_GetStyle("textColor")))
	if self._progressIconHidden and frame.progressIcon:IsVisible() then
		frame.progressIcon.ag:Stop()
		frame.progressIcon:Hide()
	elseif not self._progressIconHidden and not frame.progressIcon:IsVisible() then
		frame.progressIcon:Show()
		frame.progressIcon.ag:Play()
	end

	if self._progress == 0 then
		frame.progress:Hide()
	else
		frame.progress:Show()
		frame.progress:SetColorTexture(TSM.UI.HexToRGBA(self:_GetStyle("progressBackground")))
		frame.progress:SetWidth((self:_GetDimension("WIDTH") - PROGRESS_PADDING * 2) * self._progress)
	end
end
