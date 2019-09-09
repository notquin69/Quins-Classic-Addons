-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Container UI Element Class.
-- A container is an abstract element class which simply contains other elements. It is a subclass of the @{Element} class.
-- @classmod Container

local _, TSM = ...
local Container = TSMAPI_FOUR.Class.DefineClass("Container", TSM.UI.Element, "ABSTRACT")
TSM.UI.Container = Container
local private = {}



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Container.__init(self, frame)
	self.__super:__init(frame)

	self._children = {}
	self._layoutChildren = {}
	self._noLayoutChildren = {}
end

function Container.Release(self)
	self:ReleaseAllChildren()
	self.__super:Release()
end

--- Release all child elements.
-- @tparam Container self The container object
function Container.ReleaseAllChildren(self)
	for _, child in ipairs(self._children) do
		child:Release()
	end
	wipe(self._children)
	wipe(self._layoutChildren)
	wipe(self._noLayoutChildren)
end

--- Add a child element.
-- @tparam Container self The container object
-- @tparam Element child The child element
-- @treturn Container The container object
function Container.AddChild(self, child)
	self:_AddChildHelper(child, true)
	return self
end

--- Add a child element before another one.
-- @tparam Container self The container object
-- @tparam string beforeId The id of the child element to add this one before
-- @tparam Element child The child element
-- @treturn Container The container object
function Container.AddChildBeforeById(self, beforeId, child)
	self:_AddChildHelper(child, true, beforeId)
	return self
end

--- Add child elements using a function.
-- @tparam Container self The container object
-- @tparam function func The function to call and pass this container object
-- @tparam vararg ... Additional arguments to pass to the function
-- @treturn Container The container object
function Container.AddChildrenWithFunction(self, func, ...)
	func(self, ...)
	return self
end

--- Add a child element which is not involved in layout.
-- The layout of this child must be explicitly done by the application code.
-- @tparam Container self The container object
-- @tparam Element child The child element
-- @treturn Container The container object
function Container.AddChildNoLayout(self, child)
	self:_AddChildHelper(child, false)
	return self
end

--- Remove a child element.
-- @tparam Container self The container object
-- @tparam Element child The child element to remove
function Container.RemoveChild(self, child)
	assert(child:__isa(TSM.UI.Element) and child:_GetBaseFrame():GetParent())
	child:_GetBaseFrame():SetParent(nil)
	TSMAPI_FOUR.Util.TableRemoveByValue(self._children, child)
	TSMAPI_FOUR.Util.TableRemoveByValue(self._layoutChildren, child)
	TSMAPI_FOUR.Util.TableRemoveByValue(self._noLayoutChildren, child)
	child:_SetParentElement(nil)
end

--- Gets the number of child elements involved in layout.
-- @tparam Container self The container object
-- @treturn number The number of elements
function Container.GetNumLayoutChildren(self)
	local count = 0
	for _ in self:LayoutChildrenIterator() do
		count = count + 1
	end
	return count
end

--- Iterates through the child elements involved in layout.
-- @tparam Container self The container object
-- @return An iterator with the following fields: `index, child`
function Container.LayoutChildrenIterator(self)
	local children = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, child in ipairs(self._layoutChildren) do
		if child:IsVisible() then
			tinsert(children, child)
		end
	end
	return TSMAPI_FOUR.Util.TempTableIterator(children)
end

function Container.Draw(self)
	self.__super:Draw()
	for _, child in ipairs(self._children) do
		child:Draw()
	end
end



-- ============================================================================
-- Container - Private Class Methods
-- ============================================================================

function Container._AddChildHelper(self, child, layout, beforeId)
	assert(child:__isa(TSM.UI.Element) and not child:_GetBaseFrame():GetParent())
	child:_GetBaseFrame():SetParent(self:_GetBaseFrame())
	tinsert(self._children, private.GetElementInsertIndex(self._children, beforeId), child)
	if layout then
		tinsert(self._layoutChildren, private.GetElementInsertIndex(self._layoutChildren, beforeId), child)
	else
		tinsert(self._noLayoutChildren, private.GetElementInsertIndex(self._noLayoutChildren, beforeId), child)
	end
	child:_SetParentElement(self)
	child:Show()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetElementInsertIndex(tbl, beforeId)
	if not beforeId then
		return #tbl + 1
	end
	for i, element in ipairs(tbl) do
		if element._id == beforeId then
			return i
		end
	end
	error("Invalid beforeId: "..tostring(beforeId))
end
