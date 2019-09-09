-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local ButtonGroup = TSMAPI_FOUR.Class.DefineClass("ButtonGroup", TSM.UI.ViewContainer)
TSM.UI.ButtonGroup = ButtonGroup
local private = {}


-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ButtonGroup.__init(self)
	self.__super:__init()
	self._buttons = {}
end

function ButtonGroup.Release(self)
	wipe(self._buttons)
	self.__super:Release()
end


-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ButtonGroup._GetContentPadding(self, side)
	if side == "TOP" then
		return self:_GetStyle("buttonHeight")
	end
	return self.__super:_GetContentPadding(side)
end

function ButtonGroup.Draw(self)
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
	local spacing = self:_GetDimension("WIDTH") - #self._buttons * buttonWidth
	local offsetX = spacing / 2
	for i, button in ipairs(self._buttons) do
		if i <= #self._pathsList then
			local buttonPath = self._pathsList[i]
			button:SetStyle("fontHeight", self:_GetStyle("fontHeight"))
			button:SetStyle("border", self:_GetStyle("border"))
			button:SetStyle("borderSize", self:_GetStyle("borderSize"))
			if buttonPath == selectedPath then
				button:SetStyle("background", self:_GetStyle("selectedBackground"))
				button:SetStyle("textColor", self:_GetStyle("selectedTextColor"))
			else
				button:SetStyle("background", nil)
				button:SetStyle("textColor", nil)
			end
			button:SetText(buttonPath)
			button:SetStyle("height", buttonHeight)
			button:SetStyle("width", buttonWidth)
			local anchors = button:_GetStyle("anchors")
			if anchors then
				anchors[1][2] = offsetX
			else
				button:SetStyle("anchors", { { "TOPLEFT", offsetX, 0 } })
			end
			offsetX = offsetX + buttonWidth
		else
			button:Hide()
		end
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
