	-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- BorderedFrame UI Element Class.
-- A frame is a container which supports automated layout of its children. It also supports being the base element of a UI and anchoring/parenting directly to a WoW frame. It is a subclass of the @{Container} class.
-- @classmod BorderedFrame

local _, TSM = ...
local BorderedFrame = TSMAPI_FOUR.Class.DefineClass("BorderedFrame", TSM.UI.Frame)
TSM.UI.BorderedFrame = BorderedFrame



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function BorderedFrame.__init(self)
	self.__super:__init()
	local frame = self:_GetBaseFrame()

	frame.bgTopLeft = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgTopLeft:SetPoint("TOPLEFT")
	frame.bgTopLeft:SetSize(8, 8)

	frame.bgTopRight = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgTopRight:SetPoint("TOPRIGHT")
	frame.bgTopRight:SetSize(8, 8)

	frame.bgBottomLeft = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgBottomLeft:SetPoint("BOTTOMLEFT")
	frame.bgBottomLeft:SetSize(8, 8)

	frame.bgBottomRight = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgBottomRight:SetPoint("BOTTOMRIGHT")
	frame.bgBottomRight:SetSize(8, 8)

	frame.bgTop = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgTop:SetPoint("TOPLEFT", frame.bgTopLeft, "TOPRIGHT")
	frame.bgTop:SetPoint("BOTTOMRIGHT", frame.bgTopRight, "BOTTOMLEFT")

	frame.bgRight = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgRight:SetPoint("TOPRIGHT", frame.bgTopRight, "BOTTOMRIGHT")
	frame.bgRight:SetPoint("BOTTOMRIGHT", frame.bgBottomRight, "TOPRIGHT")

	frame.bgBottom = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgBottom:SetPoint("BOTTOMLEFT", frame.bgBottomLeft, "BOTTOMRIGHT")
	frame.bgBottom:SetPoint("TOPRIGHT", frame.bgBottomRight, "TOPLEFT")

	frame.bgLeft = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgLeft:SetPoint("TOPLEFT", frame.bgTopLeft, "BOTTOMLEFT")
	frame.bgLeft:SetPoint("BOTTOMLEFT", frame.bgBottomLeft, "TOPLEFT")

	frame.bgCenter = frame:CreateTexture(nil, "BACKGROUND")
	frame.bgCenter:SetPoint("TOPLEFT", frame.bgTopLeft, "BOTTOMRIGHT")
	frame.bgCenter:SetPoint("BOTTOMRIGHT", frame.bgBottomRight, "TOPLEFT")
end

function BorderedFrame.Draw(self)
	self.__super:Draw()

	local frame = self:_GetBaseFrame()
	local border = self:_GetStyle("borderTheme")
	assert(border)
	local layoutName = nil
	if border == "roundDark" then
		layoutName = "Dark"

		frame.bgCenter:SetPoint("TOPLEFT", frame.bgTopLeft, "BOTTOMRIGHT", -3, 3)
		frame.bgCenter:SetPoint("BOTTOMRIGHT", frame.bgBottomRight, "TOPLEFT", 3, -3)
		frame.bgCenter:SetColorTexture(0.1568627450980392, 0.1568627450980392, 0.1568627450980392, 1.0)
		frame.bgCenter:SetDrawLayer("ARTWORK", 0)

		frame.bgTopLeft:SetVertexColor(1, 1, 1, 1.0)
		frame.bgTopRight:SetVertexColor(1, 1, 1, 1.0)
		frame.bgBottomLeft:SetVertexColor(1, 1, 1, 1.0)
		frame.bgBottomRight:SetVertexColor(1, 1, 1, 1.0)
		frame.bgTop:SetVertexColor(1, 1, 1, 1.0)
		frame.bgRight:SetVertexColor(1, 1, 1, 1.0)
		frame.bgBottom:SetVertexColor(1, 1, 1, 1.0)
		frame.bgLeft:SetVertexColor(1, 1, 1, 1.0)
		frame.bgCenter:SetVertexColor(1, 1, 1, 1.0)
	elseif border == "roundLight" then
		layoutName = "Light"

		frame.bgCenter:SetPoint("TOPLEFT", frame.bgTopLeft, "BOTTOMRIGHT")
		frame.bgCenter:SetPoint("BOTTOMRIGHT", frame.bgBottomRight, "TOPLEFT")
		frame.bgCenter:SetDrawLayer("BACKGROUND", 0)

		frame.bgTopLeft:SetVertexColor(0.34, 0.34, 0.34, 1.0)
		frame.bgTopRight:SetVertexColor(0.34, 0.34, 0.34, 1.0)
		frame.bgBottomLeft:SetVertexColor(0.34, 0.34, 0.34, 1.0)
		frame.bgBottomRight:SetVertexColor(0.34, 0.34, 0.34, 1.0)
		frame.bgTop:SetVertexColor(0.34, 0.34, 0.34, 1.0)
		frame.bgRight:SetVertexColor(0.34, 0.34, 0.34, 1.0)
		frame.bgBottom:SetVertexColor(0.34, 0.34, 0.34, 1.0)
		frame.bgLeft:SetVertexColor(0.34, 0.34, 0.34, 1.0)
		frame.bgCenter:SetVertexColor(0.34, 0.34, 0.34, 1.0)

		TSM.UI.TexturePacks.SetTextureAndSize(frame.bgCenter, "uiFrames.Round"..layoutName.."Center")
	else
		error("Invalid borderTheme: "..tostring(border))
	end

	TSM.UI.TexturePacks.SetTextureAndSize(frame.bgTopLeft, "uiFrames.Round"..layoutName.."TopLeft")
	TSM.UI.TexturePacks.SetTextureAndSize(frame.bgTopRight, "uiFrames.Round"..layoutName.."TopRight")
	TSM.UI.TexturePacks.SetTextureAndSize(frame.bgBottomLeft, "uiFrames.Round"..layoutName.."BottomLeft")
	TSM.UI.TexturePacks.SetTextureAndSize(frame.bgBottomRight, "uiFrames.Round"..layoutName.."BottomRight")
	TSM.UI.TexturePacks.SetTextureAndSize(frame.bgTop, "uiFrames.Round"..layoutName.."Top")
	TSM.UI.TexturePacks.SetTextureAndSize(frame.bgRight, "uiFrames.Round"..layoutName.."Right")
	TSM.UI.TexturePacks.SetTextureAndSize(frame.bgBottom, "uiFrames.Round"..layoutName.."Bottom")
	TSM.UI.TexturePacks.SetTextureAndSize(frame.bgLeft, "uiFrames.Round"..layoutName.."Left")
end
