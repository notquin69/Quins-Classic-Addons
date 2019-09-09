-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- TabGroup UI Element Class.
-- A tab group uses text and a horizontal line to denote the tabs, with coloring indicating the one which is selected.
-- It is a subclass of the @{ViewContainer} class.
-- @classmod TabGroup

local _, TSM = ...
local TabGroup = TSMAPI_FOUR.Class.DefineClass("TabGroup", TSM.UI.ViewContainer)
TSM.UI.TabGroup = TabGroup
local private = {}
local BUTTON_PADDING_BOTTOM = 2
local LINE_THICKNESS = 2
local BUTTON_MARGIN = { bottom = BUTTON_PADDING_BOTTOM }



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function TabGroup.__init(self)
	self.__super:__init()
	self._buttons = {}
end

function TabGroup.Acquire(self)
	self.__super.__super:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Frame", "buttons")
		:SetLayout("HORIZONTAL")
		:SetStyle("anchors", { { "TOPLEFT" }, { "TOPRIGHT" } })
	)
	self.__super:Acquire()
end

function TabGroup.Release(self)
	wipe(self._buttons)
	self.__super:Release()
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function TabGroup._GetContentPadding(self, side)
	if side == "TOP" then
		return self:_GetStyle("buttonHeight") + BUTTON_PADDING_BOTTOM + LINE_THICKNESS
	end
	return self.__super:_GetContentPadding(side)
end

function TabGroup.Draw(self)
	self.__super.__super.__super:Draw()

	local selectedPath = self:GetPath()
	local buttons = self:GetElement("buttons")
	buttons:SetStyle("height", self:_GetStyle("buttonHeight") + BUTTON_PADDING_BOTTOM + LINE_THICKNESS)
	buttons:ReleaseAllChildren()
	for i, buttonPath in ipairs(self._pathsList) do
		local isSelected = buttonPath == selectedPath
		buttons:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", self._id.."_Tab"..i)
			:SetLayout("VERTICAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "button")
				:SetStyle("margin", BUTTON_MARGIN)
				:SetStyle("justifyH", "CENTER")
				:SetStyle("font", self:_GetStyle("font"))
				:SetStyle("fontHeight", self:_GetStyle("fontHeight"))
				:SetStyle("textColor", isSelected and self:_GetStyle("selectedTextColor") or nil)
				:SetContext(self)
				:SetText(buttonPath)
				:SetScript("OnClick", private.OnButtonClicked)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", LINE_THICKNESS)
				:SetStyle("color", isSelected and self:_GetStyle("selectedTextColor") or "#e2e2e2")
			)
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
	self:SetPath(path, self:GetPath() ~= path)
end
