-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- SimpleTabGroup UI Element Class.
-- A simple table group uses text to denote tabs with the selected one colored differently. It is a subclass of the
-- @{ViewContainer} class.
-- @classmod SimpleTabGroup

local _, TSM = ...
local SimpleTabGroup = TSMAPI_FOUR.Class.DefineClass("SimpleTabGroup", TSM.UI.ViewContainer)
TSM.UI.SimpleTabGroup = SimpleTabGroup
local private = {}
local BUTTON_PADDING_BOTTOM = 2
local BUTTON_MARGIN = { bottom = BUTTON_PADDING_BOTTOM, left = 8, right = 8 }



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function SimpleTabGroup.__init(self)
	self.__super:__init()
	self._buttons = {}
end

function SimpleTabGroup.Acquire(self)
	self.__super.__super:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Frame", "buttons")
		:SetLayout("HORIZONTAL")
		:SetStyle("anchors", { { "TOPLEFT" }, { "TOPRIGHT" } })
	)
	self.__super:Acquire()
end

function SimpleTabGroup.Release(self)
	wipe(self._buttons)
	self.__super:Release()
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function SimpleTabGroup._GetContentPadding(self, side)
	if side == "TOP" then
		return self:_GetStyle("buttonHeight") + BUTTON_PADDING_BOTTOM
	end
	return self.__super:_GetContentPadding(side)
end

function SimpleTabGroup.Draw(self)
	self.__super.__super.__super:Draw()

	local selectedPath = self:GetPath()
	local buttons = self:GetElement("buttons")
	buttons:SetStyle("height", self:_GetStyle("buttonHeight") + BUTTON_PADDING_BOTTOM)
	buttons:ReleaseAllChildren()
	for i, buttonPath in ipairs(self._pathsList) do
		local isSelected = buttonPath == selectedPath
		buttons:AddChild(TSMAPI_FOUR.UI.NewElement("Button", self._id.."_Tab"..i)
			:SetStyle("autoWidth", true)
			:SetStyle("margin", BUTTON_MARGIN)
			:SetStyle("justifyH", "Left")
			:SetStyle("font", self:_GetStyle("font"))
			:SetStyle("fontHeight", self:_GetStyle("fontHeight"))
			:SetStyle("textColor", isSelected and self:_GetStyle("selectedTextColor") or nil)
			:SetContext(self)
			:SetText(buttonPath)
			:SetScript("OnClick", private.OnButtonClicked)
		)
	end

	self.__super:Draw()
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.OnButtonClicked(button)
	local self = button:GetContext()
	local path = button:GetText()
	self:SetPath(path, true)
end
