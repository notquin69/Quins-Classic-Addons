-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- SearchInput UI Element Class.
-- A search input is an special style of input which is used for searching. It is a subclass of the @{Input} class.
-- @classmod SearchInput

local _, TSM = ...
local SearchInput = TSMAPI_FOUR.Class.DefineClass("SearchInput", TSM.UI.Input)
TSM.UI.SearchInput = SearchInput
local SEARCH_ICON_SIZE = 14
local SEARCH_ICON_PADDING = 1
local TEXT_PADDING = 5
local TEXT_PADDING_RIGHT = 28



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function SearchInput.__init(self)
	self.__super:__init()
	local frame = self:_GetBaseFrame()

	frame.searchIcon = frame:CreateTexture(nil, "ARTWORK")
end

function SearchInput.Acquire(self)
	self.__super:Acquire()
	self:SetStyle("clearButton", true)
	self:SetStyle("backgroundTexturePacks", "uiFrames.Search")
	self._hintText:SetStyle("anchors", { { "CENTER", (SEARCH_ICON_SIZE + SEARCH_ICON_PADDING) / 2, 0 } })
end

function SearchInput.Release(self)
	self:_GetBaseFrame():ClearFocus()
	self.__super:Release()
end

function SearchInput.Draw(self)
	self.__super:Draw()
	local frame = self:_GetBaseFrame()
	frame:SetTextInsets(TEXT_PADDING, TEXT_PADDING_RIGHT, TEXT_PADDING, TEXT_PADDING)

	if self._hintText:IsVisible() then
		self._hintText:SetStyle("width", self._hintText:GetStringWidth())
		self._hintText:SetStyle("height", self:_GetDimension("HEIGHT"))
		self._hintText:Draw()

		TSM.UI.TexturePacks.SetTexture(frame.searchIcon, "iconPack.18x18/Search")
		frame.searchIcon:ClearAllPoints()
		frame.searchIcon:SetHeight(SEARCH_ICON_SIZE)
		frame.searchIcon:SetWidth(SEARCH_ICON_SIZE)
		frame.searchIcon:SetPoint("RIGHT", self._hintText:_GetBaseFrame(), "LEFT", -SEARCH_ICON_PADDING, 0)
		frame.searchIcon:SetVertexColor(TSM.UI.HexToRGBA(self:_GetStyle("textColor")))
		frame.searchIcon:Show()

		self._clearBtn:Hide()
	else
		frame.searchIcon:Hide()

		self._clearBtn:SetStyle("width", TSM.UI.TexturePacks.GetWidth("iconPack.18x18/Close/Circle"))
		self._clearBtn:SetStyle("height", TSM.UI.TexturePacks.GetHeight("iconPack.18x18/Close/Circle"))
		self._clearBtn:SetStyle("backgroundTexturePack", "iconPack.18x18/Close/Circle")
		self._clearBtn:SetStyle("backgroundVertexColor", self:_GetStyle("textColor"))
		self._clearBtn:Show()
		self._clearBtn:Draw()
	end
end
