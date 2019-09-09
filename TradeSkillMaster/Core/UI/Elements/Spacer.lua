-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Spacer UI Element Class.
-- A spacer is a light-weight element which doesn't have any content but can be used to assist with layouts. It is a
-- subclass of the @{Element} class.
-- @classmod Spacer

local _, TSM = ...
local Spacer = TSMAPI_FOUR.Class.DefineClass("Spacer", TSM.UI.Element)
TSM.UI.Spacer = Spacer



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Spacer.__init(self)
	self.__super:__init(self)
	self._fakeParent = nil
	self._scale = 1
	self._width = 0
	self._height = 0
	self._visible = false
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function Spacer._GetBaseFrame(self)
	return self
end



-- ============================================================================
-- Fake Frame Methods
-- ============================================================================

function Spacer.SetParent(self, parent)
	self._fakeParent = parent
end

function Spacer.GetParent(self)
	return self._fakeParent
end

function Spacer.SetScale(self, scale)
	self._scale = scale
end

function Spacer.GetScale(self)
	return self._scale
end

function Spacer.SetWidth(self, width)
	self._width = width
end

function Spacer.GetWidth(self)
	return self._width
end

function Spacer.SetHeight(self, height)
	self._height = height
end

function Spacer.GetHeight(self)
	return self._height
end

function Spacer.Show(self)
	self._visible = true
end

function Spacer.Hide(self)
	self._visible = false
end

function Spacer.IsVisible(self)
	return self._visible
end

function Spacer.ClearAllPoints(self)
	-- do nothing
end

function Spacer.SetPoint(self, ...)
	-- do nothing
end
