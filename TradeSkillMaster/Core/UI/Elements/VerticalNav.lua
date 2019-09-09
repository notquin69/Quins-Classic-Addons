-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- VerticalNav UI Element Class.
-- The vertical navigation element is currently used for the ledger in the main UI. It is a subclass of the
-- @{ViewContainer} class.
-- @classmod VerticalNav

local _, TSM = ...
local VerticalNav = TSMAPI_FOUR.Class.DefineClass("VerticalNav", TSM.UI.ViewContainer)
TSM.UI.VerticalNav = VerticalNav
local private = {}
local LEFT_NAV_PADDING = 40
local TOP_NAV_PADDING = -40
local CONTENT_PADDING = -200



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function VerticalNav.__init(self)
	self.__super:__init()
	self._buttons = {}
end

function VerticalNav.Acquire(self)
	self.__super.__super:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Frame", "verticalNavFrame")
		:SetStyle("background", "#1ae2e2e2")
		:SetStyle("width", 185)
		:SetStyle("height", 680)
		:SetLayout("VERTICAL")
		:SetStyle("anchors", { { "TOPLEFT", 0, 0 } })
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "divider")
			:SetStyle("background", "#ff2a2a2a")
			:SetStyle("border", "#ff000000")
			:SetStyle("borderSize", 1)
			:SetStyle("width", 5)
			:SetStyle("anchors", { { "TOPRIGHT", 0, 0 } })
		)
	)
	self.__super:Acquire()
end

function VerticalNav.Release(self)
	wipe(self._buttons)
	self.__super:Release()
end

function VerticalNav.Draw(self)
	self.__super.__super.__super:Draw()

	-- add new buttons if necessary
	while #self._buttons < #self._pathsList do
		local num = #self._buttons + 1
		local button = TSMAPI_FOUR.UI.NewElement("Button", self._id.."_Button"..num)
			:SetContext(self)
			:SetScript("OnClick", private.OnButtonClicked)
		self.__super.__super:AddChildNoLayout(button)
		tinsert(self._buttons, button)
	end

	local selectedPath = self:GetPath()
	local buttonWidth = self:_GetStyle("buttonWidth")
	local buttonHeight = self:_GetStyle("buttonHeight")
	local verticalSpacing = buttonHeight + self:_GetStyle("verticalSpacing")
	local offsetY = TOP_NAV_PADDING
	for i, button in ipairs(self._buttons) do
		if i <= #self._pathsList then
			local buttonPath = self._pathsList[i]
			button:SetStyle("fontHeight", self:_GetStyle("fontHeight"))
			if buttonPath == selectedPath then
				button:SetStyle("background", self:_GetStyle("selectedBackground"))
				button:SetStyle("textColor", self:_GetStyle("selectedTextColor"))
			else
				button:SetStyle("background", nil)
				button:SetStyle("textColor", nil)
			end
			button:SetText(buttonPath)
			button:SetStyle("justifyH", "LEFT")
			button:SetStyle("height", buttonHeight)
			button:SetStyle("width", buttonWidth)
			button:SetStyle("anchors", { { "TOPLEFT", LEFT_NAV_PADDING, offsetY } })
			offsetY = offsetY - verticalSpacing
		else
			button:Hide()
		end
	end

	self.__super:Draw()
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function VerticalNav._GetContentPadding(self, side)
	if side == "LEFT" then
		return CONTENT_PADDING
	end
	return self.__super:_GetContentPadding(side)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.OnButtonClicked(button)
	local self = button:GetContext()
	local path = button:GetText()
	self:SetPath(path, true)
end
