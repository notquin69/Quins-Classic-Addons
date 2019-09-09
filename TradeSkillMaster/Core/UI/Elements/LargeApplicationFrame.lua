-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- LargeApplicationFrame UI Element Class.
-- This is the base frame of the large TSM windows which have tabs along the top (i.e. MainUI, AuctionUI, CraftingUI).
-- It is a subclass of the @{ApplicationFrame} class.
-- @classmod LargeApplicationFrame

local _, TSM = ...
local LargeApplicationFrame = TSMAPI_FOUR.Class.DefineClass("LargeApplicationFrame", TSM.UI.ApplicationFrame)
TSM.UI.LargeApplicationFrame = LargeApplicationFrame
local private = {}
local ICON_SIZE = 22
local ICON_PADDING = 4
local NAV_BAR_HEIGHT = 26
local NAV_BAR_RELATIVE_LEVEL = 21
local NAV_BAR_TOP_OFFSET = -49
local CONTENT_PADDING = 2



-- ============================================================================
-- Meta Class Methods
-- ============================================================================

function LargeApplicationFrame.__init(self)
	self.__super:__init()
	local frame = self:_GetBaseFrame()

	frame.topEdge = frame:CreateTexture(nil, "BACKGROUND")
	frame.topEdge:SetPoint("BOTTOMLEFT", frame.innerBorderFrame, "TOPLEFT")
	frame.topEdge:SetPoint("BOTTOMRIGHT", frame.innerBorderFrame, "TOPRIGHT")
	frame.topEdge:SetPoint("TOP", frame.headerBgCenter, "BOTTOM")
	frame.topEdge:SetColorTexture(TSM.UI.HexToRGBA("#363636"))

	self._buttons = {}
	self._selectedButton = nil
	self._buttonIndex = {}
end

function LargeApplicationFrame.Acquire(self)
	self:SetContentFrame(TSMAPI_FOUR.UI.NewElement("Frame", "content")
		:SetLayout("VERTICAL")
		:SetStyle("background", "#363636")
		:SetStyle("padding", CONTENT_PADDING)
	)
	self.__super:Acquire()
	self:SetTextureSet("LARGE", "LARGE")
end

function LargeApplicationFrame.Release(self)
	wipe(self._buttons)
	wipe(self._buttonIndex)
	self._selectedButton = nil
	self.__super:Release()
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

--- Sets the context table.
-- This table can be used to preserve position, size, and current page information across lifecycles of the frame and
-- even WoW sessions if it's within the settings DB.
-- @see ApplicationFrame.SetContextTable
-- @tparam LargeApplicationFrame self The large application frame object
-- @tparam table tbl The context table
-- @tparam table defaultTbl Default values (see @{ApplicationFrame.SetContextTable} for fields)
-- @treturn LargeApplicationFrame The large application frame object
function LargeApplicationFrame.SetContextTable(self, tbl, defaultTbl)
	assert(defaultTbl.page)
	tbl.page = tbl.page or defaultTbl.page
	self.__super:SetContextTable(tbl, defaultTbl)
	return self
end

--- Adds a top-level navigation button.
-- @tparam LargeApplicationFrame self The large application frame object
-- @tparam string text The button text
-- @tparam string texturePack The texture pack for the button icon
-- @tparam function drawCallback The function called when the button is clicked to get the corresponding content
-- @treturn LargeApplicationFrame The large application frame object
function LargeApplicationFrame.AddNavButton(self, text, texturePack, drawCallback)
	local button = TSMAPI_FOUR.UI.NewElement("AlphaAnimatedFrame", "NavBar_"..text)
		:SetRange(1, 0.3)
		:SetDuration(1)
		:SetLayout("HORIZONTAL")
		:SetStyle("relativeLevel", NAV_BAR_RELATIVE_LEVEL)
		:SetContext(drawCallback)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "button")
			:SetStyle("justifyH", "LEFT")
			:SetText(text)
			:SetScript("OnClick", private.OnNavBarButtonClicked)
		)
		:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Frame", "icon")
			:SetStyle("anchors", { { "LEFT" } })
			:SetContext(texturePack)
		)
	self:AddChildNoLayout(button)
	tinsert(self._buttons, button)
	self._buttonIndex[text] = #self._buttons
	if self._buttonIndex[text] == self._contextTable.page then
		self:SetSelectedNavButton(text)
	end
	return self
end

--- Set the selected nav button.
-- @tparam LargeApplicationFrame self The large application frame object
-- @tparam string buttonText The button text
-- @tparam boolean redraw Whether or not to redraw the frame
function LargeApplicationFrame.SetSelectedNavButton(self, buttonText, redraw)
	if buttonText == self._selectedButton then
		return
	end
	local index = self._buttonIndex[buttonText]
	self._contextTable.page = index
	self._selectedButton = buttonText
	self._contentFrame:ReleaseAllChildren()
	self._contentFrame:AddChild(self._buttons[index]:GetContext()(self))
	if redraw then
		self:Draw()
	end
	return self
end

--- Get the selected nav button.
-- @tparam LargeApplicationFrame self The large application frame object
-- @treturn string The text of the selected button
function LargeApplicationFrame.GetSelectedNavButton(self)
	return self._selectedButton
end

--- Sets which nav button is pulsing.
-- @tparam LargeApplicationFrame self The large application frame object
-- @tparam ?string buttonText The button text or nil if no nav button should be pulsing
function LargeApplicationFrame.SetPulsingNavButton(self, buttonText)
	local index = buttonText and self._buttonIndex[buttonText]
	for i, button in ipairs(self._buttons) do
		if not index or i ~= index then
			button:SetPlaying(false)
		elseif not button:IsPlaying() then
			button:SetPlaying(true)
		end
	end
end

function LargeApplicationFrame.Draw(self)
	self.__super:Draw()
	local smallNavArea = self:_GetStyle("smallNavArea")
	local sidePadding = smallNavArea and 170 or 80
	local textColor = self:_GetStyle("textColor")
	local selectedTextColor = self:_GetStyle("selectedTextColor")
	local extraWidth = self:_GetDimension("WIDTH") - sidePadding * 2
	for i, buttonFrame in ipairs(self._buttons) do
		local button = buttonFrame:GetElement("button")
		local icon = buttonFrame:GetElement("icon")
		local color = i == self._contextTable.page and selectedTextColor or textColor
		button:SetStyle("font", self:_GetStyle("buttonFont"))
		button:SetStyle("fontHeight", self:_GetStyle("buttonFontHeight"))
		button:SetStyle("textColor", color)
		button:SetStyle("textIndent", ICON_SIZE + ICON_PADDING)
		button:Draw()
		local buttonWidth = ICON_SIZE + button:GetStringWidth() + ICON_PADDING
		icon:SetStyle("backgroundVertexColor", color)
		icon:SetStyle("backgroundTexturePack", icon:GetContext())
		icon:SetStyle("width", ICON_SIZE)
		icon:SetStyle("height", ICON_SIZE)
		buttonFrame:SetStyle("height", NAV_BAR_HEIGHT)
		buttonFrame:SetStyle("width", buttonWidth)
		extraWidth = extraWidth - buttonWidth
	end

	local spacing = extraWidth / #self._buttons
	local offsetX = spacing / 2 + sidePadding
	for _, buttonFrame in ipairs(self._buttons) do
		local buttonWidth = buttonFrame:GetElement("button"):GetStringWidth() + ICON_SIZE + ICON_PADDING
		buttonFrame:SetStyle("width", buttonWidth)
		buttonFrame:SetStyle("height", NAV_BAR_HEIGHT)
		local anchors = buttonFrame:_GetStyle("anchors")
		if anchors then
			anchors[1][2] = offsetX
		else
			buttonFrame:SetStyle("anchors", { { "TOPLEFT", offsetX, NAV_BAR_TOP_OFFSET } })
		end
		offsetX = offsetX + buttonWidth + spacing
		-- draw the buttons again now that we know their dimensions
		buttonFrame:Draw()
	end

	local frame = self:_GetBaseFrame()
	if smallNavArea then
		TSM.UI.TexturePacks.SetTextureAndSize(frame.innerTopRightCorner, "uiFrames.CraftingApplicationInnerFrameTopRightCorner")
		TSM.UI.TexturePacks.SetTextureAndSize(frame.innerTopLeftCorner, "uiFrames.CraftingApplicationInnerFrameTopLeftCorner")
	else
		TSM.UI.TexturePacks.SetTextureAndSize(frame.innerTopRightCorner, "uiFrames.LargeApplicationInnerFrameTopRightCorner")
		TSM.UI.TexturePacks.SetTextureAndSize(frame.innerTopLeftCorner, "uiFrames.LargeApplicationInnerFrameTopLeftCorner")
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function LargeApplicationFrame._SetResizing(self, resizing)
	for _, button in ipairs(self._buttons) do
		if resizing then
			button:Hide()
		else
			button:Show()
		end
	end
	self.__super:_SetResizing(resizing)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.OnNavBarButtonClicked(button)
	local self = button:GetParentElement():GetParentElement()
	self:SetSelectedNavButton(button:GetText(), true)
end
