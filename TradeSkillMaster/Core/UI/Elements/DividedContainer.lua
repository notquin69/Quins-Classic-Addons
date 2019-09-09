-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Divided Container UI Element Class.
-- A divided container is a container with two children with a divider between them. It is a subclass of the @{Frame} class.
-- @classmod DividedContainer

local _, TSM = ...
local DividedContainer = TSMAPI_FOUR.Class.DefineClass("DividedContainer", TSM.UI.Frame)
TSM.UI.DividedContainer = DividedContainer
local private = {}



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function DividedContainer.__init(self)
	self.__super:__init()
	self._leftChild = nil
	self._rightChild = nil
	self._resizeStartX = nil
	self._resizeOffset = 0
	self._contextTable = nil
	self._defaultContextTable = nil
	self._minLeftWidth = nil
	self._minRightWidth = nil
end

function DividedContainer.Acquire(self)
	self:SetScript("OnUpdate", private.OnUpdate)
	self.__super:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "leftEmpty"))
	self.__super:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "divider")
	)
	self.__super:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "rightEmpty"))
	self.__super:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Button", "handle")
		:SetStyle("anchors", { { "CENTER", "divider" } })
		:SetStyle("relativeLevel", 2)
		:EnableRightClick()
		-- :SetScript("OnMouseDown", private.HandleOnMouseDown)
		-- :SetScript("OnMouseUp", private.HandleOnMouseUp)
		:SetScript("OnClick", private.HandleOnClick)
	)
	self.__super:Acquire()
	self.__super:SetLayout("HORIZONTAL")
end

function DividedContainer.Release(self)
	self._leftChild = nil
	self._rightChild = nil
	self._resizeStartX = nil
	self._resizeOffset = 0
	self._contextTable = nil
	self._defaultContextTable = nil
	self._minLeftWidth = nil
	self._minRightWidth = nil
	self.__super:Release()
end

function DividedContainer.SetLayout(self, layout)
	error("DividedContainer doesn't support this method")
end

function DividedContainer.AddChild(self, child)
	error("DividedContainer doesn't support this method")
end

function DividedContainer.AddChildBeforeById(self, beforeId, child)
	error("DividedContainer doesn't support this method")
end

function DividedContainer.AddChildNoLayout(self, child)
	error("DividedContainer doesn't support this method")
end

--- Sets the context table.
-- This table can be used to preserve the divider position across lifecycles of the divided container and even WoW
-- sessions if it's within the settings DB. The position is stored as the width of the left child element.
-- @tparam DividedContainer self The divided container object
-- @tparam table tbl The context table
-- @tparam table defaultTbl The default table (required fields: `leftWidth`)
-- @treturn DividedContainer The divided container object
function DividedContainer.SetContextTable(self, tbl, defaultTbl)
	assert(defaultTbl.leftWidth > 0)
	tbl.leftWidth = tbl.leftWidth or defaultTbl.leftWidth
	self._contextTable = tbl
	self._defaultContextTable = defaultTbl
	return self
end

--- Sets the minimum width of the child element.
-- @tparam DividedContainer self The divided container object
-- @tparam number minLeftWidth The minimum width of the left child element
-- @tparam number minRightWidth The minimum width of the right child element
-- @treturn DividedContainer The divided container object
function DividedContainer.SetMinWidth(self, minLeftWidth, minRightWidth)
	self._minLeftWidth = minLeftWidth
	self._minRightWidth = minRightWidth
	return self
end

--- Sets the left child element.
-- @tparam DividedContainer self The divided container object
-- @tparam Element child The left child element
-- @treturn DividedContainer The divided container object
function DividedContainer.SetLeftChild(self, child)
	assert(not self._leftChild and child)
	self._leftChild = child
	self.__super:AddChildBeforeById("divider", child)
	return self
end

--- Sets the right child element.
-- @tparam DividedContainer self The divided container object
-- @tparam Element child The right child element
-- @treturn DividedContainer The divided container object
function DividedContainer.SetRightChild(self, child)
	assert(not self._rightChild and child)
	self._rightChild = child
	self.__super:AddChild(child)
	return self
end

function DividedContainer.Draw(self)
	assert(self._contextTable and self._minLeftWidth and self._minRightWidth)
	self.__super.__super.__super:Draw()

	local dividerWidth = self:_GetStyle("dividerWidth")
	local divider = self:GetElement("divider")
	divider:SetStyle("width", dividerWidth)
	divider:SetStyle("background", self:_GetStyle("dividerBackground"))
	divider:SetStyle("border", self:_GetStyle("dividerBorder"))
	divider:SetStyle("borderSize", self:_GetStyle("dividerBorderSize"))

	local handleTexturePack = self:_GetStyle("dividerHandleTexturePack")
	local handle = self:GetElement("handle")
	handle:SetStyle("width", TSM.UI.TexturePacks.GetWidth(handleTexturePack))
	handle:SetStyle("height", TSM.UI.TexturePacks.GetHeight(handleTexturePack))
	handle:SetStyle("backgroundTexturePack", self:_GetStyle("dividerHandleTexturePack"))

	local width = self:_GetDimension("WIDTH") - dividerWidth
	local leftWidth = self._contextTable.leftWidth + self._resizeOffset
	local rightWidth = width - leftWidth
	if rightWidth < self._minRightWidth then
		leftWidth = width - self._minRightWidth
		assert(leftWidth >= self._minLeftWidth)
	elseif leftWidth < self._minLeftWidth then
		leftWidth = self._minLeftWidth
	end
	self._contextTable.leftWidth = leftWidth - self._resizeOffset

	local leftEmpty = self:GetElement("leftEmpty")
	local rightEmpty = self:GetElement("rightEmpty")
	leftEmpty:SetStyle("width", leftWidth)
	self._leftChild:SetStyle("width", leftWidth)
	if self._resizeStartX then
		self._leftChild:Hide()
		self._rightChild:Hide()
		leftEmpty:Show()
		rightEmpty:Show()
	else
		self._leftChild:Show()
		self._rightChild:Show()
		leftEmpty:Hide()
		rightEmpty:Hide()
	end

	self.__super:Draw()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.OnUpdate(self)
	if self._resizeStartX then
		local currX = GetCursorPosition() / self:_GetBaseFrame():GetEffectiveScale()
		self._resizeOffset = currX - self._resizeStartX
		self:Draw()
	end
end

function private.HandleOnMouseDown(handle, mouseButton)
	if mouseButton ~= "LeftButton" then
		return
	end
	local self = handle:GetParentElement()
	self._resizeStartX = GetCursorPosition() / self:_GetBaseFrame():GetEffectiveScale()
	self._resizeOffset = 0
end

function private.HandleOnMouseUp(handle, mouseButton)
	if mouseButton ~= "LeftButton" then
		return
	end
	local self = handle:GetParentElement()
	self._contextTable.leftWidth = max(self._contextTable.leftWidth + self._resizeOffset, self._minLeftWidth)
	self._resizeOffset = 0
	self._resizeStartX = nil
	self:Draw()
end

function private.HandleOnClick(handle, mouseButton)
	if mouseButton ~= "RightButton" then
		return
	end
	local self = handle:GetParentElement()
	self._contextTable.leftWidth = self._defaultContextTable.leftWidth
	self:Draw()
end
