-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Base UI Element Class.
-- This the base class for all other UI element classes.
-- @classmod Element

local _, TSM = ...
local Element = TSMAPI_FOUR.Class.DefineClass("Element", nil, "ABSTRACT")
TSM.UI.Element = Element
local private = { elementLookup = {}, scriptWrappers = {} }
local SCRIPT_CALLBACK_TIME_WARNING_THRESHOLD_MS = 20



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Element.__init(self, frame)
	self._tags = {}
	self._frame = frame
	self._style = {}
	self._stylesheet = nil
	self._scripts = {}
	self._baseElementCache = nil
	self._parent = nil
	self._context = nil
	self._acquired = nil
	self._tooltip = nil
end

function Element.SetId(self, id)
	-- should only be called by core UI code before acquiring the element
	assert(not self._acquired)
	self._id = id or tostring(self)
end

function Element.SetTags(self, ...)
	-- should only be called by core UI code before acquiring the element
	assert(not self._acquired)
	assert(#self._tags == 0)
	for i = 1, select("#", ...) do
		local tag = select(i, ...)
		tinsert(self._tags, tag)
	end
end

function Element.Acquire(self)
	assert(not self._acquired)
	self._acquired = true
	self:Show()
end

function Element.Release(self)
	assert(self._acquired)

	self:Hide()

	local frame = self:_GetBaseFrame()
	frame:ClearAllPoints()
	frame:SetParent(nil)
	frame:SetScale(1)
	-- clear scripts
	for script in pairs(self._scripts) do
		frame:SetScript(script, nil)
	end

	wipe(self._tags)
	wipe(self._style)
	wipe(self._scripts)
	self._stylesheet = nil
	self._baseElementCache = nil
	self._parent = nil
	self._context = nil
	self._acquired = nil
	self._tooltip = nil

	TSM.UI.RecyleElement(self)
end

--- Shows the element.
-- @tparam Element self The element object
function Element.Show(self)
	self:_GetBaseFrame():Show()
	return self
end

--- Hides the element.
-- @tparam Element self The element object
function Element.Hide(self)
	self:_GetBaseFrame():Hide()
	return self
end

--- Returns whether or not the element is visible.
-- @tparam Element self The element object
-- @treturn boolean Whether or not the element is currently visible
function Element.IsVisible(self)
	return self:_GetBaseFrame():IsVisible()
end

--- Sets a style attribute for the element.
-- @tparam Element self The element object
-- @tparam string key The style key to set
-- @param value The value to set the style key to
-- @treturn Element The element object
function Element.SetStyle(self, key, value)
	self._style[key] = value
	return self
end

--- Set the @{Stylesheet} for this element.
-- @tparam Element self The element object
-- @tparam Stylesheet stylesheet The stylesheet object
-- @treturn Element The element object
function Element.SetStylesheet(self, stylesheet)
	self._stylesheet = stylesheet
	return self
end

--- Gets the top-most element in the tree.
-- @tparam Element self The element object
-- @treturn Element The top-most element object
function Element.GetBaseElement(self)
	if not self._baseElementCache then
		local element = self
		local parent = element:GetParentElement()
		while parent do
			local temp = element
			element = parent
			parent = temp:GetParentElement()
		end
		self._baseElementCache = element
	end
	return self._baseElementCache
end

--- Gets the parent element.
-- @tparam Element self The element object
-- @treturn Element The parent element object
function Element.GetParentElement(self)
	return self._parent
end

--- Gets another element in the tree by relative path.
-- The path consists of element ids separated by `.`. `__parent` may also be used to indicate the parent element.
-- @tparam Element self The element object
-- @tparam string path The relative path to the element
-- @treturn Element The desired element
function Element.GetElement(self, path)
	-- First try to find the element as a child of self, then try from the base element
	return private.GetElementHelper(self, path) or private.GetElementHelper(self:GetBaseElement(), path)
end

--- Sets the tooltip of the element.
-- @tparam Element self The element object
-- @param tooltip The value passed to @{UI.ShowTooltip} when the user hovers over the element, or nil to clear it
-- @treturn Element The element object
function Element.SetTooltip(self, tooltip)
	self._tooltip = tooltip
	if tooltip then
		self:SetScript("OnEnter", private.OnEnter)
		self:SetScript("OnLeave", private.OnLeave)
	else
		self:SetScript("OnEnter", nil)
		self:SetScript("OnLeave", nil)
	end
	return self
end

--- Sets the context value of the element.
-- @tparam Element self The element object
-- @param context The context value
-- @treturn Element The element object
function Element.SetContext(self, context)
	self._context = context
	return self
end

--- Gets the context value from the element.
-- @tparam Element self The element object
-- @return The context value
function Element.GetContext(self)
	return self._context
end

--- Registers a script handler.
-- @tparam Element self The element object
-- @tparam string script The script to register for
-- @tparam function handler The script handler which will be called with the element object followed by any arguments to
-- the script
-- @treturn Element The element object
function Element.SetScript(self, script, handler)
	self._scripts[script] = handler
	local frame = self:_GetBaseFrame()
	private.elementLookup[frame] = self
	if not private.scriptWrappers[script] then
		private.scriptWrappers[script] = function(...)
			private.ScriptHandlerCommon(script, ...)
		end
	end
	frame:SetScript(script, handler and private.scriptWrappers[script] or nil)
	return self
end

function private.ScriptHandlerCommon(script, frame, ...)
	local self = private.elementLookup[frame]
	local startTime = debugprofilestop()
	self._scripts[script](self, ...)
	local timeTaken = debugprofilestop() - startTime
	if timeTaken > SCRIPT_CALLBACK_TIME_WARNING_THRESHOLD_MS then
		TSM:LOG_WARN("Script handler (%s) for frame (%s) took %0.2fms", script, self._id or tostring(self), timeTaken)
	end
end

--- Propogates a script event to the parent element.
-- @tparam Element self The element object
-- @tparam string script The script to propogate
-- @tparam varag ... The script handler arguments
function Element.PropagateScript(self, script, ...)
	local parentFrame = self:GetParentElement():_GetBaseFrame()
	local parentScript = parentFrame:GetScript(script)
	if not parentScript then
		return
	end
	parentScript(parentFrame, ...)
end

function Element.Draw(self)
	assert(self._acquired)
	local frame = self:_GetBaseFrame()
	local scale = self:_GetStyle("scale")
	if scale then
		self:_GetBaseFrame():SetScale(scale)
	end
	local anchors = self:_GetStyle("anchors")
	if anchors then
		frame:ClearAllPoints()
		for i, anchor in ipairs(anchors) do
			local point, relativeFrame, relativePoint, x, y = nil, nil, nil, nil, nil
			if #anchor == 1 then
				-- point
				point = unpack(anchor)
			elseif #anchor == 2 then
				-- point, relativeFrame
				point, relativeFrame = unpack(anchor)
			elseif #anchor == 3 then
				if type(anchor[2]) == "number" then
					point, x, y = unpack(anchor)
				else
					point, relativeFrame, relativePoint = unpack(anchor)
				end
			elseif #anchor == 5 then
				point, relativeFrame, relativePoint, x, y = unpack(anchor)
			else
				error(format("Invalid anchor %d!", i), 1)
			end
			-- apply default values to fields which weren't explicitly set
			relativeFrame = relativeFrame or frame:GetParent()
			relativePoint = relativePoint or point
			x = x or 0
			y = y or 0
			if type(relativeFrame) == "string" then
				-- this is a relative element
				relativeFrame = self:GetParentElement():GetElement(relativeFrame):_GetBaseFrame()
			end
			frame:SetPoint(point, relativeFrame, relativePoint, x, y)
		end
	end
	local width = self:_GetStyle("width")
	if width then
		self:_SetDimension("WIDTH", width)
	end
	local height = self:_GetStyle("height")
	if height then
		self:_SetDimension("HEIGHT", height)
	end
	local relativeLevel = self:_GetStyle("relativeLevel")
	if relativeLevel then
		frame:SetFrameLevel(frame:GetParent():GetFrameLevel() + relativeLevel)
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function Element._GetStyle(self, key)
	-- check if we already have this key set directly or cached
	local res = self._style[key]
	if res ~= nil then
		return res
	end

	-- check if this key is part of a stylesheet
	local element = self
	while element do
		if element._stylesheet then
			res = element._stylesheet:_GetStyle(self.__class.__name, self._tags, key)
			if res ~= nil then
				self._style[key] = res
				return res
			end
		end
		element = element:GetParentElement()
	end

	-- use the default style
	res = TSM.UI.Stylesheet.GetDefaultStyle(self.__class, key)
	self._style[key] = res
	return res
end

function Element._SetParentElement(self, parent)
	self._parent = parent
	self._baseElementCache = nil
end

function Element._GetMinimumDimension(self, dimension)
	if dimension == "WIDTH" then
		local width = self:_GetStyle("width")
		return width or 0, width == nil
	elseif dimension == "HEIGHT" then
		local height = self:_GetStyle("height")
		return height or 0, height == nil
	else
		error("Invalid dimension: " .. tostring(dimension))
	end
end

function Element._GetPreferredDimension(self, dimension)
	if dimension == "WIDTH" then
		return nil
	elseif dimension == "HEIGHT" then
		return nil
	else
		error("Invalid dimension: " .. tostring(dimension))
	end
end

function Element._GetDimension(self, dimension)
	if dimension == "WIDTH" then
		return self:_GetBaseFrame():GetWidth()
	elseif dimension == "HEIGHT" then
		return self:_GetBaseFrame():GetHeight()
	else
		error("Invalid dimension: " .. tostring(dimension))
	end
end

function Element._SetDimension(self, dimension, ...)
	if dimension == "WIDTH" then
		self:_GetBaseFrame():SetWidth(...)
	elseif dimension == "HEIGHT" then
		self:_GetBaseFrame():SetHeight(...)
	else
		error("Invalid dimension: " .. tostring(dimension))
	end
end

function Element._GetBaseFrame(self)
	return self._frame
end

function Element._GetBoxPartSize(self, key, side)
	side = strlower(side)
	local value = self:_GetStyle(key.."."..side) or self:_GetStyle(key)
	if not value then return 0 end
	if type(value) == "number" then
		return value or 0
	elseif type(value) == "table" then
		return value[side] or 0
	else
		error()
	end
end

function Element._GetPadding(self, side)
	return self:_GetBoxPartSize("padding", side)
end

function Element._GetPaddingAnchorOffsets(self, anchor)
	local xPart, yPart = private.SplitAnchor(anchor)
	local x = xPart and ((xPart == "LEFT" and 1 or -1) * self:_GetPadding(xPart)) or 0
	local y = yPart and ((yPart == "BOTTOM" and 1 or -1) * self:_GetPadding(yPart)) or 0
	return x, y
end

function Element._GetMargin(self, side)
	return self:_GetBoxPartSize("margin", side)
end

function Element._GetMarginAnchorOffsets(self, anchor)
	local xPart, yPart = private.SplitAnchor(anchor)
	local x = xPart and ((xPart == "LEFT" and 1 or -1) * self:_GetMargin(xPart)) or 0
	local y = yPart and ((yPart == "BOTTOM" and 1 or -1) * self:_GetMargin(yPart)) or 0
	return x, y
end

function Element._ApplyFrameBackgroundTexture(self)
	local texturePack = self:_GetStyle("backgroundTexturePack")
	local texture = self:_GetStyle("backgroundTexture")
	local frame = self:_GetBaseFrame()
	if texture or texturePack then
		frame:SetBackdrop(nil)
		frame:SetBackdropColor(0, 0, 0, 0)
		frame:SetBackdropBorderColor(0, 0, 0, 0)
		frame.backgroundTexture:ClearAllPoints()
		if texturePack then
			frame.backgroundTexture:SetPoint("CENTER")
			local rotateAngle = self:_GetStyle("backgroundTextureRotation")
			if rotateAngle then
				TSM.UI.TexturePacks.SetTextureAndSizeRotated(frame.backgroundTexture, texturePack, rotateAngle)
			else
				TSM.UI.TexturePacks.SetTextureAndSize(frame.backgroundTexture, texturePack)
			end
		else
			frame.backgroundTexture:SetAllPoints()
			frame.backgroundTexture:SetTexture(texture)
			frame.backgroundTexture:SetTexCoord(0, 1, 0, 1)
		end
		frame.backgroundTexture:SetVertexColor(TSM.UI.HexToRGBA(self:_GetStyle("backgroundVertexColor")))
		frame.backgroundTexture:Show()
	else
		frame.backgroundTexture:Hide()
		self:_ApplyFrameStyle(frame)
	end
end

function Element._ApplyFrameStyle(self, frame)
	-- set the background and border
	local background = self:_GetStyle("background")
	local border = self:_GetStyle("border")
	local borderTexture = self:_GetStyle("borderTexture")
	if background or border or borderTexture then
		local borderSize = self:_GetStyle("borderSize")
		borderSize = borderSize or nil
		local backdrop = {
			bgFile = background and "Interface\\Buttons\\WHITE8X8" or nil,
			edgeFile = borderTexture or (border and "Interface\\Buttons\\WHITE8X8") or nil,
			edgeSize = borderSize,
		}
		local borderInset = self:_GetStyle("borderInset")
		local borderInsets = self:_GetStyle("borderInsets")
		if borderInset then
			backdrop.insets = { left = borderInset, right = borderInset, top = borderInset, bottom = borderInset }
		elseif borderInsets then
			backdrop.insets = borderInsets
		end
		frame:SetBackdrop(backdrop)
		if background then
			frame:SetBackdropColor(TSM.UI.HexToRGBA(background))
		end
		if border then
			frame:SetBackdropBorderColor(TSM.UI.HexToRGBA(border))
		end
	else
		frame:SetBackdrop(nil)
	end
end

function Element._ApplyTextStyle(self, text, disabled)
	-- set the font
	-- wow renders the font slightly bigger than the designs would indicate, so subtract one from the font height
	local fontHeight = self:_GetStyle("fontHeight") - 1
	if self:_GetStyle("font") == "Fonts\\ARKai_C.ttf" then
		fontHeight = fontHeight + 2
	end

	text:SetFont(self:_GetStyle("font"), fontHeight)

	-- set the justification
	text:SetJustifyH(self:_GetStyle("justifyH") or "CENTER")
	text:SetJustifyV(self:_GetStyle("justifyV") or "MIDDLE")

	-- set the text color
	if disabled then
		text:SetTextColor(TSM.UI.HexToRGBA(self:_GetStyle("disabledTextColor") or "#60ffffff"))
	else
		text:SetTextColor(TSM.UI.HexToRGBA(self:_GetStyle("textColor")))
	end
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.GetElementHelper(element, path)
	local numParts = select("#", strsplit(".", path))
	local partIndex = 1
	while partIndex <= numParts do
		local part = select(partIndex, strsplit(".", path))
		if part == "__parent" then
			local parentElement = element:GetParentElement()
			if not parentElement then
				error(format("Element (%s) has no parent", tostring(element._id)))
			end
			element = parentElement
		elseif part == "__base" then
			local baseElement = element:GetBaseElement()
			if not baseElement then
				error(format("Element (%s) has no base element", tostring(element._id)))
			end
			element = baseElement
		else
			local found = false
			for _, child in ipairs(element._children) do
				if child._id == part then
					element = child
					found = true
					break
				end
			end
			if not found then
				element = nil
				break
			end
		end
		partIndex = partIndex + 1
	end
	return element
end

function private.SplitAnchor(anchor)
	if anchor == "BOTTOMLEFT" then
		return "LEFT", "BOTTOM"
	elseif anchor == "BOTTOM" then
		return nil, "BOTTOM"
	elseif anchor == "BOTTOMRIGHT" then
		return "RIGHT", "BOTTOM"
	elseif anchor == "RIGHT" then
		return "RIGHT", nil
	elseif anchor == "TOPRIGHT" then
		return "RIGHT", "TOP"
	elseif anchor == "TOP" then
		return nil, "TOP"
	elseif anchor == "TOPLEFT" then
		return "LEFT", "TOP"
	elseif anchor == "LEFT" then
		return "LEFT", nil
	else
		error("Invalid anchor: "..tostring(anchor))
	end
end

function private.OnEnter(element)
	TSM.UI.ShowTooltip(element:_GetBaseFrame(), element._tooltip)
end

function private.OnLeave(element)
	TSM.UI.HideTooltip()
end
