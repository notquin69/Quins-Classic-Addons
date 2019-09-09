-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- OverlayApplicationFrame UI Element Class.
-- The overlay application frame is currently just used for the TaskListUI. It is a subclass of the @{Frame} class.
-- @classmod OverlayApplicationFrame

local _, TSM = ...
local OverlayApplicationFrame = TSMAPI_FOUR.Class.DefineClass("OverlayApplicationFrame", TSM.UI.Frame)
TSM.UI.OverlayApplicationFrame = OverlayApplicationFrame
local private = {}
local TITLE_HEIGHT = 40
local CONTENT_PADDING_BOTTOM = 16



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function OverlayApplicationFrame.__init(self)
	self.__super:__init()
	self._mouseOver = nil
	self._contentFrame = nil
	self._contextTable = nil
	self._defaultContextTable = nil
end

function OverlayApplicationFrame.Acquire(self)
	local frame = self:_GetBaseFrame()
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	self:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Button", "closeBtn")
		:SetStyle("anchors", { { "TOPRIGHT", -8, -11 } })
		:SetStyle("width", 18)
		:SetStyle("height", 18)
		:SetStyle("backgroundTexturePack", "iconPack.18x18/Close/Circle")
		:SetScript("OnClick", private.CloseButtonOnClick)
	)
	self:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Button", "minimizeBtn")
		:SetStyle("anchors", { { "TOPRIGHT", -26, -11 } })
		:SetStyle("width", 18)
		:SetStyle("height", 18)
		:SetStyle("backgroundTexturePack", "iconPack.18x18/Subtract/Circle")
		:SetScript("OnClick", private.MinimizeBtnOnClick)
	)
	self:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Text", "title")
		:SetStyle("anchors", { { "TOPLEFT", 8, -8 }, { "TOPRIGHT", -52, -8 } })
		:SetStyle("height", 24)
		:SetStyle("font", TSM.UI.Fonts.MontserratBold)
		:SetStyle("fontHeight", 18)
	)
	self:SetStyle("borderSize", 8)
	self:SetStyle("borderInset", 1)
	self:SetScript("OnUpdate", private.FrameOnUpdate)
	self:SetScript("OnDragStart", private.FrameOnDragStart)
	self:SetScript("OnDragStop", private.FrameOnDragStop)

	self._mouseOver = nil

	self.__super:Acquire()
end

function OverlayApplicationFrame.Release(self)
	self._contentFrame = nil
	self._contextTable = nil
	self._defaultContextTable = nil
	self:_GetBaseFrame():SetMinResize(0, 0)
	self.__super:Release()
end

--- Sets the title text.
-- @tparam OverlayApplicationFrame self The overlay application frame object
-- @tparam string title The title text
-- @treturn OverlayApplicationFrame The overlay application frame object
function OverlayApplicationFrame.SetTitle(self, title)
	self:GetElement("title"):SetText(title)
	return self
end

--- Sets the content frame.
-- @tparam OverlayApplicationFrame self The overlay application frame object
-- @tparam Element frame The content frame
-- @treturn OverlayApplicationFrame The overlay application frame object
function OverlayApplicationFrame.SetContentFrame(self, frame)
	frame:SetStyle("anchors", { { "TOPLEFT", 0, -TITLE_HEIGHT }, { "BOTTOMRIGHT", 0, CONTENT_PADDING_BOTTOM } })
	self._contentFrame = frame
	self:AddChildNoLayout(frame)
	return self
end

--- Sets the context table.
-- This table can be used to preserve position information across lifecycles of the frame and even WoW sessions if it's
-- within the settings DB.
-- @tparam OverlayApplicationFrame self The overlay application frame object
-- @tparam table tbl The context table
-- @tparam table defaultTbl The default values (required fields: `minimized`, `topRightX`, `topRightY`)
-- @treturn OverlayApplicationFrame The overlay application frame object
function OverlayApplicationFrame.SetContextTable(self, tbl, defaultTbl)
	assert(defaultTbl.minimized ~= nil and defaultTbl.topRightX and defaultTbl.topRightY)
	if tbl.minimized == nil then
		tbl.minimized = defaultTbl.minimized
	end
	tbl.topRightX = tbl.topRightX or defaultTbl.topRightX
	tbl.topRightY = tbl.topRightY or defaultTbl.topRightY
	self._contextTable = tbl
	self._defaultContextTable = defaultTbl
	return self
end

function OverlayApplicationFrame.Draw(self)
	if self._contextTable.minimized then
		self:GetElement("minimizeBtn"):SetStyle("backgroundTexturePack", "iconPack.18x18/Add/Circle")
		self:GetElement("content"):Hide()
		self:SetStyle("height", TITLE_HEIGHT)
	else
		self:GetElement("minimizeBtn"):SetStyle("backgroundTexturePack", "iconPack.18x18/Subtract/Circle")
		self:GetElement("content"):Show()
		-- set the height of the frame based on the height of the children
		local contentHeight, contentHeightExpandable = self:GetElement("content"):_GetMinimumDimension("HEIGHT")
		assert(not contentHeightExpandable)
		self:SetStyle("height", contentHeight + TITLE_HEIGHT + CONTENT_PADDING_BOTTOM)
	end

	-- make sure the frame is on the screen
	self._contextTable.topRightX = max(min(self._contextTable.topRightX, 0), -UIParent:GetWidth() + 100)
	self._contextTable.topRightY = max(min(self._contextTable.topRightY, 0), -UIParent:GetHeight() + 100)

	-- set the frame position from the contextTable
	local anchors = self:_GetStyle("anchors") or { { "TOPRIGHT" } }
	anchors[1][2] = self._contextTable.topRightX
	anchors[1][3] = self._contextTable.topRightY
	self:SetStyle("anchors", anchors)

	self.__super:Draw()
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function OverlayApplicationFrame._SavePosition(self)
	local frame = self:_GetBaseFrame()
	local parentFrame = frame:GetParent()
	self._contextTable.topRightX = frame:GetRight() - parentFrame:GetRight()
	self._contextTable.topRightY = frame:GetTop() - parentFrame:GetTop()
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FrameOnDragStart(self)
	self:_GetBaseFrame():StartMoving()
end

function private.FrameOnDragStop(self)
	local frame = self:_GetBaseFrame()
	frame:StopMovingOrSizing()
	self:_SavePosition()
end

function private.FrameOnUpdate(self)
	local mouseOver = self:_GetBaseFrame():IsMouseOver() and true or false
	if self._mouseOver == nil or mouseOver ~= self._mouseOver then
		self:SetStyle("background", mouseOver and "#b3363636" or nil)
		self:SetStyle("borderTexture", mouseOver and "Interface\\Addons\\TradeSkillMaster\\Media\\ItemPreviewEdgeFrame.blp" or nil)
		self:Draw()
		self._mouseOver = mouseOver
	end
end

function private.CloseButtonOnClick(button)
	button:GetParentElement():Hide()
end

function private.MinimizeBtnOnClick(button)
	local self = button:GetParentElement()
	self._contextTable.minimized = not self._contextTable.minimized
	self:Draw()
end
