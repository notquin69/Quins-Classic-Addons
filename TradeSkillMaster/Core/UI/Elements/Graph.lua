-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Graph UI Element Class.
-- The graph element allows for generating line graphs. It is a subclass of the @{Element} class.
-- @classmod Graph

local _, TSM = ...
local Graph = TSMAPI_FOUR.Class.DefineClass("Graph", TSM.UI.Element)
TSM.UI.Graph = Graph
local private = { plotFrameGraphLookup = {} }
local PLOT_PADDING_LEFT = 12
local PLOT_PADDING_RIGHT = 24
local PLOT_MARGIN_TOP = 16
local PLOT_MARGIN_BOTTOM = 40
local PLOT_MARGIN_LEFT = 48
local PLOT_X_LABEL_WIDTH = 30
local PLOT_X_LABEL_HEIGHT = 22
local PLOT_Y_LABEL_WIDTH = 42
local PLOT_Y_LABEL_HEIGHT = 16
local PLOT_X_LINE_LENGTH = 4
local PLOT_X_LABEL_MARGIN = 6
local PLOT_Y_LABEL_MARGIN = 4
local LINE_THICKNESS_RATIO = 16
local PLOT_MIN_X_LINE_SPACING = PLOT_X_LABEL_WIDTH + 8
local PLOT_MIN_Y_LINE_SPACING = PLOT_Y_LABEL_HEIGHT + 8



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function Graph.__init(self)
	local frame = CreateFrame("Frame", nil, nil, nil)

	self.__super:__init(frame)

	frame.plot = CreateFrame("Frame", nil, frame, nil)
	frame.plot:SetPoint("BOTTOMLEFT", PLOT_MARGIN_LEFT + PLOT_PADDING_LEFT, PLOT_MARGIN_BOTTOM)
	frame.plot:SetPoint("TOPRIGHT", -PLOT_PADDING_RIGHT, -PLOT_MARGIN_TOP)
	frame.plot:EnableMouse(true)
	frame.plot:SetScript("OnEnter", private.PlotFrameOnEnter)
	frame.plot:SetScript("OnLeave", private.PlotFrameOnLeave)
	private.plotFrameGraphLookup[frame.plot] = self

	frame.plot.dot = frame.plot:CreateTexture(nil, "ARTWORK", nil, 3)
	TSM.UI.TexturePacks.SetTextureAndSize(frame.plot.dot, "uiFrames.HighlightDot")

	frame.plot.highlight = frame.plot:CreateTexture(nil, "ARTWORK", nil, 2)
	frame.plot.highlight:SetColorTexture(TSM.UI.HexToRGBA("#1cffd839"))

	self._textures = {}
	self._textureInUse = {}
	self._fontStrings = {}
	self._fontStringInUse = {}
	self._dataIterFunc = nil
	self._xLabelFunc = nil
	self._yLabelFunc = nil
	self._xStep = nil
	self._yStep = nil
	self._xMin = nil
	self._xMax = nil
	self._yMin = nil
	self._yMax = nil
	self._xDataStep = nil
	self._tooltipFunc = nil
end

function Graph.Release(self)
	self:_ReleaseAllTextures()
	self:_ReleaseAllFontStrings()
	self._dataIterFunc = nil
	self._xLabelFunc = nil
	self._yLabelFunc = nil
	self._xStep = nil
	self._yStep = nil
	self._xMin = nil
	self._xMax = nil
	self._yMin = nil
	self._yMax = nil
	self._xDataStep = nil
	self._tooltipFunc = nil
	self.__super:Release()
end

--- Sets the step size of the axes.
-- @tparam Graph self The graph object
-- @tparam number x The X-axis step size
-- @tparam number y The y-axis step size
-- @treturn Graph The graph object
function Graph.SetAxisStepSize(self, x, y)
	self._xStep = x
	self._yStep = y
	return self
end

--- Sets the data iterator function.
-- @tparam Graph self The graph object
-- @tparam function iterFunc A function which returns an iterator which iterates over the graph data (with fields: `index, xValue, yValue`)
-- @treturn Graph The graph object
function Graph.SetDataIteratorFunction(self, iterFunc)
	self._dataIterFunc = iterFunc
	return self
end

--- Sets functions for getting the axis labels.
-- @tparam Graph self The graph object
-- @tparam function xLabelFunc A function which is passed an x value and returns a label for the axis
-- @tparam function yLabelFunc A function which is passed a y value and returns a label for the axis
-- @treturn Graph The graph object
function Graph.SetLabelFunctions(self, xLabelFunc, yLabelFunc)
	self._xLabelFunc = xLabelFunc
	self._yLabelFunc = yLabelFunc
	return self
end

--- Sets the tooltip function.
-- @tparam Graph self The graph object
-- @tparam function tooltip A function which is passed an (x, y) pair and returns the tooltip
-- @treturn Graph The graph object
function Graph.SetTooltipFunction(self, tooltip)
	self._tooltipFunc = tooltip
	return self
end

function Graph.Draw(self)
	self.__super:Draw()
	self:_ReleaseAllTextures()
	self:_ReleaseAllFontStrings()
	local frame = self:_GetBaseFrame()
	self:_ApplyFrameStyle(frame)
	local plot = frame.plot

	local plotWidth = plot:GetWidth()
	local plotHeight = plot:GetHeight()

	-- determine the bounds of the plot data
	self._xMin = math.huge
	self._xMax = -math.huge
	self._yMin = math.huge
	self._yMax = -math.huge
	self._xDataStep = 0
	local xLastValue = nil
	for _, x, y in self:_dataIterFunc() do
		if not xLastValue then
			-- pass
		elseif self._xDataStep == 0 then
			self._xDataStep = x - xLastValue
		else
			assert(self._xDataStep == x - xLastValue, "X-axis data must be evenly spaced!")
		end
		xLastValue = x
		self._xMin = min(self._xMin, x)
		self._xMax = max(self._xMax, x)
		self._yMin = min(self._yMin, y)
		self._yMax = max(self._yMax, y)
	end
	-- add a bit of extra vertical space
	self._yMin = max(TSMAPI_FOUR.Util.Round(self._yMin, self._yStep) - self._yStep, 0)
	self._yMax = TSMAPI_FOUR.Util.Round(self._yMax, self._yStep) + self._yStep

	local gridLineThickness = self:_GetStyle("gridLineThickness")
	local gridLineColor = self:_GetStyle("gridLineColor")

	-- draw the y axis lines and labels
	local yDiff = self._yMax - self._yMin
	local yStep, ySpacing = private.GetAxisStep(yDiff, self._yStep, plotHeight, PLOT_MIN_Y_LINE_SPACING)
	for i = 0, floor(yDiff / yStep) do
		local yOffset = i * ySpacing
		local line = self:_DrawLine(-PLOT_PADDING_LEFT, yOffset, plotWidth + PLOT_PADDING_RIGHT, yOffset, gridLineThickness)
		line:SetVertexColor(TSM.UI.HexToRGBA(gridLineColor))
		line:SetDrawLayer("BACKGROUND", 0)
		local text = self:_AcquireFontString(self:_GetStyle("yAxisFont"), self:_GetStyle("yAxisFontHeight"))
		text:SetJustifyH("RIGHT")
		text:SetJustifyV("MIDDLE")
		text:SetPoint("RIGHT", line, "LEFT", -PLOT_Y_LABEL_MARGIN, 0)
		text:SetWidth(PLOT_Y_LABEL_WIDTH)
		text:SetHeight(PLOT_Y_LABEL_HEIGHT)
		text:SetText(self:_yLabelFunc(self._yMin + i * yStep))
	end

	local xDiff = self._xMax - self._xMin
	local xStep, xSpacing = private.GetAxisStep(xDiff, self._xStep, plotWidth, PLOT_MIN_X_LINE_SPACING)
	for i = 0, floor(xDiff / xStep) do
		local xOffset = i * xSpacing
		local line = self:_DrawLine(xOffset, -PLOT_X_LINE_LENGTH, xOffset, 0, gridLineThickness)
		line:SetVertexColor(TSM.UI.HexToRGBA(gridLineColor))
		line:SetDrawLayer("BACKGROUND", 0)
		local text = self:_AcquireFontString(self:_GetStyle("xAxisFont"), self:_GetStyle("xAxisFontHeight"))
		text:SetJustifyH("CENTER")
		text:SetJustifyV("TOP")
		text:SetPoint("TOP", line, "BOTTOM", 0, -PLOT_X_LABEL_MARGIN)
		text:SetWidth(PLOT_X_LABEL_WIDTH)
		text:SetHeight(PLOT_X_LABEL_HEIGHT)
		text:SetText(self:_xLabelFunc(self._xMin + i * xStep))
	end

	-- draw all the lines
	local xPrev, yPrev = nil, nil
	for _, x, y in self:_dataIterFunc() do
		local xCoord = TSMAPI_FOUR.Util.Scale(x, self._xMin, self._xMax, 0, plotWidth)
		local yCoord = TSMAPI_FOUR.Util.Scale(y, self._yMin, self._yMax, 0, plotHeight)
		if xPrev then
			self:_DrawFillLine(xPrev, yPrev, xCoord, yCoord, self:_GetStyle("lineThickness"))
		end
		xPrev = xCoord
		yPrev = yCoord
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function Graph._DrawLine(self, xFrom, yFrom, xTo, yTo, thickness)
	assert(xFrom <= xTo)
	local textureHeight = thickness * LINE_THICKNESS_RATIO
	local xDiff = xTo - xFrom
	local yDiff = yTo - yFrom
	local length = sqrt(xDiff * xDiff + yDiff * yDiff)
	local sinValue = -yDiff / length
	local cosValue = xDiff / length
	local aspectRatio = length / textureHeight
	local invAspectRatio = textureHeight / length
	local line = self:_AcquireLine(self:_GetStyle("lineColor"), "ARTWORK")

	-- calculate and set tex coords
	local LLx, LLy, ULx, ULy, URx, URy, LRx, LRy
	if yDiff >= 0 then
		ULx = sinValue * sinValue
		ULy = 1 - aspectRatio * sinValue * cosValue
		LLx = invAspectRatio * sinValue * cosValue
		LLy = sinValue * sinValue
		URx = 1 - invAspectRatio * sinValue * cosValue
		URy = 1 - sinValue * sinValue
		LRx = 1 - sinValue * sinValue
		LRy = aspectRatio * sinValue * cosValue
	else
		LLx = sinValue * sinValue
		LLy = -aspectRatio * sinValue * cosValue
		LRx = 1 + invAspectRatio * sinValue * cosValue
		LRy = LLx
		ULx = 1 - LRx
		ULy = 1 - LLx
		URy = 1 - LLy
		URx = ULy
	end
	line:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)

	-- calculate and set texture anchors
	local xCenter = (xFrom + xTo) / 2
	local yCenter = (yFrom + yTo) / 2
	local halfWidth = (xDiff + invAspectRatio * abs(yDiff) + thickness) / 2
	local halfHeight = (abs(yDiff) + invAspectRatio * xDiff + thickness) / 2
	line:SetPoint("BOTTOMLEFT", xCenter - halfWidth, yCenter - halfHeight)
	line:SetPoint("TOPRIGHT", line:GetParent(), "BOTTOMLEFT", xCenter + halfWidth, yCenter + halfHeight)

	return line
end

function Graph._DrawFillLine(self, xFrom, yFrom, xTo, yTo, thickness)
	local line = self:_DrawLine(xFrom, yFrom, xTo, yTo, thickness)
	local fillColor = self:_GetStyle("fillColor")

	local fillTop = self:_AcquireTriangle(yFrom < yTo and "ASCENDING" or "DESCENDING", fillColor, "ARTWORK", -1)
	fillTop:SetPoint("BOTTOMLEFT", xFrom, min(yFrom, yTo))
	fillTop:SetPoint("TOPRIGHT", fillTop:GetParent(), "BOTTOMLEFT", xTo, max(yFrom, yTo))

	local fillBar = self:_AcquireRectangle(fillColor, "ARTWORK", -1)
	fillBar:SetPoint("BOTTOMLEFT", xFrom, 0)
	fillBar:SetPoint("TOPRIGHT", fillBar:GetParent(), "BOTTOMLEFT", xTo, min(yFrom, yTo))

	return line
end

function Graph._AcquireLine(self, color, layer, subLayer)
	local line = self:_AcquireTexture(layer, subLayer)
	line:SetTexture("Interface\\AddOns\\TradeSkillMaster\\Media\\line")
	line:SetVertexColor(TSM.UI.HexToRGBA(color))
	return line
end

function Graph._AcquireTriangle(self, orientation, color, layer, subLayer)
	local triangle = self:_AcquireTexture(layer, subLayer)
	triangle:SetTexture("Interface\\AddOns\\TradeSkillMaster\\Media\\triangle")
	if orientation == "ASCENDING" then
		triangle:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	elseif orientation == "DESCENDING" then
		triangle:SetTexCoord(1, 0, 1, 1, 0, 0, 0, 1)
	else
		error("Invalid orientation: "..tostring(orientation))
	end
	triangle:SetVertexColor(TSM.UI.HexToRGBA(color))
	return triangle
end

function Graph._AcquireRectangle(self, color, layer, subLayer)
	local rect = self:_AcquireTexture(layer, subLayer)
	rect:SetTexture("Interface\\Buttons\\WHITE8X8")
	rect:SetVertexColor(TSM.UI.HexToRGBA(color))
	return rect
end

function Graph._AcquireTexture(self, layer, subLayer)
	local plot = self:_GetBaseFrame().plot
	local result = nil
	for _, texture in ipairs(self._textures) do
		if not self._textureInUse[texture] then
			result = texture
			break
		end
	end
	if not result then
		result = plot:CreateTexture()
		tinsert(self._textures, result)
	end
	self._textureInUse[result] = true
	result:SetParent(plot)
	result:Show()
	result:SetDrawLayer(layer, subLayer)
	return result
end

function Graph._ReleaseAllTextures(self)
	for _, texture in ipairs(self._textures) do
		if self._textureInUse[texture] then
			texture:SetTexture(nil)
			texture:SetVertexColor(0, 0, 0, 0)
			texture:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
			texture:SetWidth(0)
			texture:SetHeight(0)
			texture:ClearAllPoints()
			texture:Hide()
			self._textureInUse[texture] = nil
		end
	end
end

function Graph._AcquireFontString(self, font, fontHeight)
	local plot = self:_GetBaseFrame().plot
	local result = nil
	for _, texture in ipairs(self._fontStrings) do
		if not self._fontStringInUse[texture] then
			result = texture
			break
		end
	end
	if not result then
		result = plot:CreateFontString()
		tinsert(self._fontStrings, result)
	end
	self._fontStringInUse[result] = true
	result:SetParent(plot)
	result:Show()
	result:SetFont(font, fontHeight)
	result:SetTextColor(TSM.UI.HexToRGBA(self:_GetStyle("textColor")))
	return result
end

function Graph._ReleaseAllFontStrings(self)
	for _, fontString in ipairs(self._fontStrings) do
		if self._fontStringInUse[fontString] then
			fontString:SetWidth(0)
			fontString:SetHeight(0)
			fontString:ClearAllPoints()
			fontString:Hide()
			self._fontStringInUse[fontString] = nil
		end
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetAxisStep(diff, stepSize, totalSize, minSpacing)
	local maxNumSteps = floor(totalSize / minSpacing)
	local numSteps = nil
	local step = 0
	while not numSteps or numSteps > maxNumSteps do
		step = step + stepSize
		numSteps = diff / step
	end
	local spacing = totalSize / numSteps
	return step, spacing
end

function private.PlotFrameOnEnter(plotFrame)
	plotFrame:SetScript("OnUpdate", private.PlotFrameOnUpdate)
end

function private.PlotFrameOnLeave(plotFrame)
	plotFrame:SetScript("OnUpdate", nil)

	plotFrame.dot:Hide()
	plotFrame.highlight:Hide()
	TSM.UI.HideTooltip()
end

function private.PlotFrameOnUpdate(plotFrame)
	local self = private.plotFrameGraphLookup[plotFrame]

	local xPos = GetCursorPosition() / plotFrame:GetEffectiveScale()
	local fromMin = plotFrame:GetLeft()
	local fromMax = plotFrame:GetRight()
	if xPos < fromMin then
		xPos = fromMin
	end
	if xPos > fromMax then
		xPos = fromMax
	end
	local x = TSMAPI_FOUR.Util.Scale(xPos, fromMin, fromMax, self._xMin, self._xMax)
	x = TSMAPI_FOUR.Util.Round(x - self._xMin, self._xDataStep) + self._xMin
	local y = nil
	for _, xVal, yVal in self:_dataIterFunc() do
		if xVal == x then
			assert(not y)
			y = yVal
		end
	end
	assert(y)
	plotFrame.dot:Show()
	plotFrame.dot:ClearAllPoints()
	local xCoord = TSMAPI_FOUR.Util.Scale(x, self._xMin, self._xMax, 0, plotFrame:GetWidth())
	local yCoord = TSMAPI_FOUR.Util.Scale(y, self._yMin, self._yMax, 0, plotFrame:GetHeight())
	plotFrame.dot:SetPoint("CENTER", plotFrame, "BOTTOMLEFT", xCoord, yCoord)

	plotFrame.highlight:Show()
	plotFrame.highlight:ClearAllPoints()
	plotFrame.highlight:SetWidth(plotFrame:GetWidth() / ((self._xMax - self._xMin) / self._xDataStep))
	plotFrame.highlight:SetHeight(plotFrame:GetHeight())
	plotFrame.highlight:SetPoint("BOTTOM", plotFrame, "BOTTOMLEFT", xCoord, 0)

	TSM.UI.ShowTooltip(plotFrame.dot, self._tooltipFunc(x, y))
end



-- Testing code that never really worked out but I (Sapu) would like to revisit at some point
--[[
local texture = UIParent:CreateTexture(nil, "ARTWORK")
local bg = UIParent:CreateTexture(nil, "BACKGROUND")
function TSMTEST(yDiff)
	local xDiff = 200
	-- local yDiff = 20

	bg:SetColorTexture(0, 0, 0, 1)
	-- texture:SetTexture("Interface\\Addons\\TradeSkillMaster\\Media\\TSM_Icon_Big.blp")
	texture:SetTexture("Interface\\AddOns\\TradeSkillMaster\\Media\\line")
	texture:SetVertexColor(1, 0, 0, 1)
	texture:SetPoint("CENTER", 400, 0)
	texture:SetWidth(xDiff)
	texture:SetHeight(yDiff)
	bg:SetAllPoints(texture)

	local thickness = 48 * 4

	-- transform each coord point
	local length = sqrt(xDiff * xDiff + yDiff * yDiff)
	local xScale = length / xDiff
	local yScale = thickness / length
	local cosResult = xDiff / length
	local sinResult = yDiff / length
	local aspectRatio = xDiff / yDiff
	local ULx, ULy = private.TransformCoordPoint(0, 0, cosResult, sinResult, aspectRatio, xScale, yScale)
	local LLx, LLy = private.TransformCoordPoint(0, 1, cosResult, sinResult, aspectRatio, xScale, yScale)
	local URx, URy = private.TransformCoordPoint(1, 0, cosResult, sinResult, aspectRatio, xScale, yScale)
	local LRx, LRy = private.TransformCoordPoint(1, 1, cosResult, sinResult, aspectRatio, xScale, yScale)

	texture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
end

function private.ScaleCoordValue(value, scale)
	-- we divide by the scale since the coord is setting the point within the original texture
	-- so a coord closer to 0.5 (the center) would make the texture appear bigger
	return 0.5 + (value - 0.5) / scale
end

function private.TransformCoordPoint(x, y, cosResult, sinResult, aspectRatio, xScale, yScale)
	local originX = 0.5
	local originY = 0.5

	-- translate so we can rotate around the origin
	x = x - originX
	y = y - originY

	-- apply the aspect ratio scaling
	y = y / aspectRatio

	-- perform the rotation
	x, y = originX + x * cosResult - y * sinResult, originY + y * cosResult + x * sinResult

	-- perform the scaling
	x = private.ScaleCoordValue(x, xScale)
	y = private.ScaleCoordValue(y, yScale)

	return x, y
end
]]
