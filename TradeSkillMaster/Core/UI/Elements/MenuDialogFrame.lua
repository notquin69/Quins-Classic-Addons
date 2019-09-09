-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- MenuDialogFrame UI Element Class.
-- The menu dialog frame is generally used with "more" buttons and simply uses specific textures. It is a subclass of the @{Frame} class.
-- @classmod MenuDialogFrame

local _, TSM = ...
local MenuDialogFrame = TSMAPI_FOUR.Class.DefineClass("MenuDialogFrame", TSM.UI.Frame)
TSM.UI.MenuDialogFrame = MenuDialogFrame



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function MenuDialogFrame.__init(self)
	self.__super:__init()
	local frame = self:_GetBaseFrame()

	frame.bottomLeftCorner = frame:CreateTexture(nil, "BACKGROUND")
	frame.bottomLeftCorner:SetPoint("BOTTOMLEFT")
	TSM.UI.TexturePacks.SetTextureAndSize(frame.bottomLeftCorner, "uiFrames.PopupBottomLeftCorner")

	frame.bottomRightCorner = frame:CreateTexture(nil, "BACKGROUND")
	frame.bottomRightCorner:SetPoint("BOTTOMRIGHT")
	TSM.UI.TexturePacks.SetTextureAndSize(frame.bottomRightCorner, "uiFrames.PopupBottomRightCorner")

	frame.bottomEdge = frame:CreateTexture(nil, "BACKGROUND")
	frame.bottomEdge:SetPoint("BOTTOMLEFT", frame.bottomLeftCorner, "BOTTOMRIGHT")
	frame.bottomEdge:SetPoint("BOTTOMRIGHT", frame.bottomRightCorner, "BOTTOMLEFT")
	TSM.UI.TexturePacks.SetTextureAndHeight(frame.bottomEdge, "uiFrames.PopupBottomEdge")

	frame.topLeftCorner = frame:CreateTexture(nil, "BACKGROUND")
	frame.topLeftCorner:SetPoint("TOPLEFT")
	TSM.UI.TexturePacks.SetTextureAndSize(frame.topLeftCorner, "uiFrames.PopupTopLeftCorner")

	frame.topRightCorner = frame:CreateTexture(nil, "BACKGROUND")
	frame.topRightCorner:SetPoint("TOPRIGHT", 0, 10)
	TSM.UI.TexturePacks.SetTextureAndSize(frame.topRightCorner, "uiFrames.PopupTopRightCorner")

	frame.topEdge = frame:CreateTexture(nil, "BACKGROUND")
	frame.topEdge:SetPoint("BOTTOMLEFT", frame.topLeftCorner, "BOTTOMRIGHT")
	frame.topEdge:SetPoint("BOTTOMRIGHT", frame.topRightCorner, "BOTTOMLEFT")
	TSM.UI.TexturePacks.SetTextureAndHeight(frame.topEdge, "uiFrames.PopupTopEdge")

	frame.leftEdge = frame:CreateTexture(nil, "BACKGROUND")
	frame.leftEdge:SetPoint("TOPLEFT", frame.topLeftCorner, "BOTTOMLEFT")
	frame.leftEdge:SetPoint("BOTTOMLEFT", frame.bottomLeftCorner, "TOPLEFT")
	TSM.UI.TexturePacks.SetTextureAndWidth(frame.leftEdge, "uiFrames.PopupLeftEdge")

	frame.rightEdge = frame:CreateTexture(nil, "BACKGROUND")
	frame.rightEdge:SetPoint("TOPRIGHT", frame.topRightCorner, "BOTTOMRIGHT")
	frame.rightEdge:SetPoint("BOTTOMRIGHT", frame.bottomRightCorner, "TOPRIGHT")
	TSM.UI.TexturePacks.SetTextureAndWidth(frame.rightEdge, "uiFrames.PopupRightEdge")
end
