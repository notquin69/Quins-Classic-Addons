-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- ViewContainer UI Element Class.
-- A view container allows the content to be changed depending on the selected view (called the path). It is a subclass of the @{Container} class.
-- @classmod ViewContainer

local _, TSM = ...
local ViewContainer = TSMAPI_FOUR.Class.DefineClass("ViewContainer", TSM.UI.Container)
TSM.UI.ViewContainer = ViewContainer



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ViewContainer.__init(self)
	local frame = CreateFrame("Frame", nil, nil, nil)
	self.__super:__init(frame)
	self._pathsList = {}
	self._contextTable = nil
	self._defaultContextTable = nil
end

function ViewContainer.Acquire(self)
	self._path = nil
	self._navCallback = nil
	self.__super:Acquire()
end

function ViewContainer.Release(self)
	wipe(self._pathsList)
	self.__super:Release()
	self._contextTable = nil
	self._defaultContextTable = nil
end

function ViewContainer.SetLayout(self, layout)
	error("ViewContainer doesn't support this method")
end

function ViewContainer.AddChild(self, child)
	error("ViewContainer doesn't support this method")
end

function ViewContainer.AddChildNoLayout(self, child)
	error("ViewContainer doesn't support this method")
end

--- Set the navigation callback.
-- @tparam ViewContainer self The view container object
-- @tparam function callback The function called when the selected path changes to get the new content
-- @treturn ViewContainer The view container object
function ViewContainer.SetNavCallback(self, callback)
	self._navCallback = callback
	return self
end

--- Add a path (view).
-- @tparam ViewContainer self The view container object
-- @tparam string path The path
-- @tparam[opt=false] boolean setSelected Set this as the selected path (view)
-- @treturn ViewContainer The view container object
function ViewContainer.AddPath(self, path, setSelected)
	tinsert(self._pathsList, path)
	if self._contextTable then
		assert(setSelected == nil, "Cannot set selected path when using a context table")
		local newPathIndex = TSMAPI_FOUR.Util.TableKeyByValue(self._pathsList, path)
		if self._contextTable.pathIndex == newPathIndex then
			self:SetPath(path)
		end
	elseif setSelected then
		self:SetPath(path)
	end
	return self
end

--- Renames a path (view).
-- @tparam ViewContainer self The view container object
-- @tparam string path The new path
-- @tparam number index The index of the path to change
-- @treturn ViewContainer The view container object
function ViewContainer.RenamePath(self, path, index)
	local changePath = self._pathsList[index] == self._path
	self._pathsList[index] = path

	if changePath then
		self:SetPath(path)
	end
	return self
end

--- Set the selected path (view).
-- @tparam ViewContainer self The view container object
-- @tparam string path The selected path
-- @tparam boolean redraw Whether or not to redraw the view container
-- @treturn ViewContainer The view container object
function ViewContainer.SetPath(self, path, redraw)
	if path ~= self._path then
		local child = self:_GetChild()
		if child then
			assert(#self._layoutChildren == 1)
			self:RemoveChild(child)
			child:Release()
		end
		self.__super:AddChild(self:_navCallback(path))
		self._path = path
		-- Save the path index of the new selected path to the context table
		if self._contextTable then
			self._contextTable.pathIndex = TSMAPI_FOUR.Util.TableKeyByValue(self._pathsList, path)
		end
	end
	if redraw then
		self:Draw()
	end
	return self
end

--- Reload the current view.
-- @tparam ViewContainer self The view container object
function ViewContainer.ReloadContent(self)
	local path = self._path
	self._path = nil
	self:SetPath(path, true)
end

--- Get the current path (view).
-- @tparam ViewContainer self The view container object
-- @treturn string The current path
function ViewContainer.GetPath(self)
	return self._path
end

--- Get a list of the paths for the view container.
-- @tparam ViewContainer self The view container object
-- @treturn table The path list
function ViewContainer.GetPathList(self)
	return self._pathsList
end

function ViewContainer.Draw(self)
	self.__super.__super:Draw()
	local child = self:_GetChild()
	local childFrame = child:_GetBaseFrame()

	-- set the child to be full-size
	childFrame:ClearAllPoints()
	local xOffset, yOffset = child:_GetMarginAnchorOffsets("BOTTOMLEFT")
	local paddingXOffset, paddingYOffset = self:_GetPaddingAnchorOffsets("BOTTOMLEFT")
	xOffset = xOffset + paddingXOffset - self:_GetContentPadding("LEFT")
	yOffset = yOffset + paddingYOffset - self:_GetContentPadding("BOTTOM")
	childFrame:SetPoint("BOTTOMLEFT", xOffset, yOffset)
	xOffset, yOffset = child:_GetMarginAnchorOffsets("TOPRIGHT")
	paddingXOffset, paddingYOffset = self:_GetPaddingAnchorOffsets("TOPRIGHT")
	xOffset = xOffset + paddingXOffset - self:_GetContentPadding("RIGHT")
	yOffset = yOffset + paddingYOffset - self:_GetContentPadding("TOP")
	childFrame:SetPoint("TOPRIGHT", xOffset, yOffset)
	child:Draw()

	-- draw the no-layout children
	for _, noLayoutChild in ipairs(self._noLayoutChildren) do
		noLayoutChild:Draw()
	end
end

--- Sets the context table.
-- This table can be used to save which tab is active, refrenced by the path index
-- @tparam ViewContainer self The view container object
-- @tparam table tbl The context table
-- @tparam table defaultTbl Default values
-- @treturn ViewContainer The view container object
function ViewContainer.SetContextTable(self, tbl, defaultTbl)
	tbl.pathIndex = tbl.pathIndex or defaultTbl.pathIndex
	assert(tbl.pathIndex ~= nil, "Path index for ViewContainer ContextTable is not set")
	self._contextTable = tbl
	self._defaultContextTable = defaultTbl
	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ViewContainer._GetMinimumDimension(self, dimension)
	if dimension == "WIDTH" then
		local width = self:_GetStyle("width")
		if width then
			return width, false
		else
			return self:_GetChild():_GetMinimumDimension(dimension)
		end
	elseif dimension == "HEIGHT" then
		local height = self:_GetStyle("height")
		if height then
			return height, false
		else
			return self:_GetChild():_GetMinimumDimension(dimension)
		end
	else
		error("Invalid dimension: "..tostring(dimension))
	end
end

function ViewContainer._GetContentPadding(self, side)
	if side == "TOP" then
		return 0
	elseif side == "BOTTOM" then
		return 0
	elseif side == "LEFT" then
		return 0
	elseif side == "RIGHT" then
		return 0
	else
		error("Invalid side: "..tostring(side))
	end
end

function ViewContainer._GetChild(self)
	return self._layoutChildren[1]
end
