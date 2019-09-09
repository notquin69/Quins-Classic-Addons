-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Texture UI Element Class.
-- This is a simple, light-weight element which is used to display a texture. It is a subclass of the @{Element} class.
-- @classmod Texture

local _, TSM = ...
local Texture = TSMAPI_FOUR.Class.DefineClass("Texture", TSM.UI.Element)
TSM.UI.Texture = Texture
local private = {}



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Texture.__init(self)
	local texture = UIParent:CreateTexture()
	-- hook SetParent/GetParent since textures can't have a nil parent
	texture._oldSetParent = texture.SetParent
	texture.SetParent = private.SetParent
	texture.GetParent = private.GetParent
	self.__super:__init(texture)
end

function Texture.Draw(self)
	self.__super:Draw()

	local texture = self:_GetBaseFrame()
	texture:SetTexture(nil)
	texture:SetTexCoord(0, 1, 0, 1)
	texture:SetVertexColor(1, 1, 1, 1)

	local color = self:_GetStyle("color")
	local rawTexture = self:_GetStyle("texture")
	local texturePack = self:_GetStyle("texturePack")
	if color then
		assert(not texturePack)
		texture:SetColorTexture(TSM.UI.HexToRGBA(color))
	elseif rawTexture then
		texture:SetTexture(rawTexture)
	elseif texturePack then
		assert(not color)
		local rotateAngle = self:_GetStyle("textureRotation")
		if rotateAngle then
			TSM.UI.TexturePacks.SetTextureRotated(texture, texturePack, rotateAngle)
		else
			TSM.UI.TexturePacks.SetTexture(texture, texturePack)
		end
		local vertexColor = self:_GetStyle("vertexColor")
		if vertexColor then
			texture:SetVertexColor(TSM.UI.HexToRGBA(vertexColor))
		end
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.SetParent(self, parent)
	self._parent = parent
	if parent then
		self:Show()
	else
		self:Hide()
	end
	self:_oldSetParent(parent or UIParent)
end

function private.GetParent(self)
	return self._parent
end
