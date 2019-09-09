-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- ApplicationFrame UI Element Class.
-- An application frame is the base frame of all of the TSM UIs. It is a subclass of the @{Frame} class.
-- @classmod ApplicationFrame

local _, TSM = ...
local L = TSM.L
local ApplicationFrame = TSMAPI_FOUR.Class.DefineClass("ApplicationFrame", TSM.UI.Frame)
TSM.UI.ApplicationFrame = ApplicationFrame
local private = {}
local INNER_FRAME_OFFSET = 10
local INNER_BORDER_RELATIVE_LEVEL = 20
local TITLE_BG_OFFSET_TOP = -11
local TITLE_BG_LEFT_OFFSET = 19
local TITLE_BG_CLOSE_PADDING = 6
local MIN_SCALE = 0.3
local OUTER_TEXTURE_INFO = {
	SMALL = {
		titleBGRightOffset = -10,
		closeBackground = "uiFrames.SmallApplicationCloseFrameBackground",
		topLeft = "uiFrames.SmallApplicationOuterFrameTopLeftCorner",
		topRight = "uiFrames.SmallApplicationOuterFrameTopRightCorner",
		bottomLeft = "uiFrames.SmallApplicationOuterFrameBottomLeftCorner",
		bottomRight = "uiFrames.SmallApplicationOuterFrameBottomRightCorner",
		top = "uiFrames.SmallApplicationOuterFrameTopEdge",
		bottom = "uiFrames.SmallApplicationOuterFrameBottomEdge",
		left = "uiFrames.SmallApplicationOuterFrameLeftEdge",
		right = "uiFrames.SmallApplicationOuterFrameRightEdge",
	},
	LARGE = {
		titleBGRightOffset = -19,
		closeBackground = "uiFrames.LargeApplicationCloseFrameBackground",
		closeButtonWidth = 36,
		topLeft = "uiFrames.LargeApplicationOuterFrameTopLeftCorner",
		topRight = "uiFrames.LargeApplicationOuterFrameTopRightCorner",
		bottomLeft = "uiFrames.LargeApplicationOuterFrameBottomLeftCorner",
		bottomRight = "uiFrames.LargeApplicationOuterFrameBottomRightCorner",
		top = "uiFrames.LargeApplicationOuterFrameTopEdge",
		bottom = "uiFrames.LargeApplicationOuterFrameBottomEdge",
		left = "uiFrames.LargeApplicationOuterFrameLeftEdge",
		right = "uiFrames.LargeApplicationOuterFrameRightEdge",
	},
}
local INNER_TEXTURE_INFO = {
	SMALL = {
		topOffset = -46,
		topLeft = "uiFrames.SmallApplicationInnerFrameTopLeftCorner",
		topRight = "uiFrames.SmallApplicationInnerFrameTopRightCorner",
		bottomLeft = "uiFrames.SmallApplicationInnerFrameBottomLeftCorner",
		bottomRight = "uiFrames.SmallApplicationInnerFrameBottomRightCorner",
		top = "uiFrames.SmallApplicationInnerFrameTopEdge",
		bottom = "uiFrames.SmallApplicationInnerFrameBottomEdge",
		left = "uiFrames.SmallApplicationInnerFrameLeftEdge",
		right = "uiFrames.SmallApplicationInnerFrameRightEdge",
	},
	LARGE = {
		topOffset = -64,
		showTopEdge = true,
		topLeft = "uiFrames.LargeApplicationInnerFrameTopLeftCorner",
		topRight = "uiFrames.LargeApplicationInnerFrameTopRightCorner",
		bottomLeft = "uiFrames.LargeApplicationFrameInnerFrameBottomLeftCorner",
		bottomRight = "uiFrames.LargeApplicationFrameInnerFrameBottomRightCorner",
		top = "uiFrames.LargeApplicationInnerFrameTopEdge",
		bottom = "uiFrames.LargeApplicationFrameInnerFrameBottomEdge",
		left = "uiFrames.LargeApplicationFrameInnerFrameLeftEdge",
		right = "uiFrames.LargeApplicationFrameInnerFrameRightEdge",
	},
}



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ApplicationFrame.__init(self)
	self.__super:__init()
	self._contentFrame = nil
	self._contextTable = nil
	self._defaultContextTable = nil
	self._innerTextureInfo = nil
	self._outerTextureInfo = nil
	self._isScaling = nil
	self._minWidth = 0
	self._minHeight = 0

	local frame = self:_GetBaseFrame()
	local globalFrameName = tostring(frame)
	_G[globalFrameName] = frame
	tinsert(UISpecialFrames, globalFrameName)

	frame.headerBgLeft = frame:CreateTexture(nil, "BACKGROUND")
	frame.headerBgLeft:SetPoint("TOPLEFT")

	frame.headerBgRight = frame:CreateTexture(nil, "BACKGROUND")
	frame.headerBgRight:SetPoint("TOPRIGHT")

	frame.headerBgCenter = frame:CreateTexture(nil, "BACKGROUND")
	frame.headerBgCenter:SetPoint("TOPLEFT", frame.headerBgLeft, "TOPRIGHT")
	frame.headerBgCenter:SetPoint("TOPRIGHT", frame.headerBgRight, "TOPLEFT")

	frame.titleBgLeft = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	frame.titleBgLeft:SetPoint("TOPLEFT", TITLE_BG_LEFT_OFFSET, TITLE_BG_OFFSET_TOP)
	TSM.UI.TexturePacks.SetTextureAndSize(frame.titleBgLeft, "uiFrames.HeaderLeft")

	frame.titleBgClose = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	frame.titleBgClose:SetPoint("TOPRIGHT", 0, TITLE_BG_OFFSET_TOP) -- x offset set later

	frame.titleBgRight = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	frame.titleBgRight:SetPoint("TOPRIGHT", frame.titleBgClose, "TOPLEFT", -TITLE_BG_CLOSE_PADDING, 0)
	TSM.UI.TexturePacks.SetTextureAndSize(frame.titleBgRight, "uiFrames.HeaderRight")

	frame.titleBgCenter = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	frame.titleBgCenter:SetPoint("TOPLEFT", frame.titleBgLeft, "TOPRIGHT")
	frame.titleBgCenter:SetPoint("TOPRIGHT", frame.titleBgRight, "TOPLEFT")
	TSM.UI.TexturePacks.SetTextureAndHeight(frame.titleBgCenter, "uiFrames.HeaderMiddle")

	frame.bottomLeftCorner = frame:CreateTexture(nil, "BACKGROUND")
	frame.bottomLeftCorner:SetPoint("BOTTOMLEFT")

	frame.bottomRightCorner = frame:CreateTexture(nil, "BACKGROUND")
	frame.bottomRightCorner:SetPoint("BOTTOMRIGHT")

	frame.leftEdge = frame:CreateTexture(nil, "BACKGROUND")
	frame.leftEdge:SetPoint("TOPLEFT", frame.headerBgLeft, "BOTTOMLEFT")
	frame.leftEdge:SetPoint("BOTTOMLEFT", frame.bottomLeftCorner, "TOPLEFT")

	frame.rightEdge = frame:CreateTexture(nil, "BACKGROUND")
	frame.rightEdge:SetPoint("TOPRIGHT", frame.headerBgRight, "BOTTOMRIGHT")
	frame.rightEdge:SetPoint("BOTTOMRIGHT", frame.bottomRightCorner, "TOPRIGHT")

	frame.bottomEdge = frame:CreateTexture(nil, "BACKGROUND")
	frame.bottomEdge:SetPoint("BOTTOMLEFT", frame.bottomLeftCorner, "BOTTOMRIGHT")
	frame.bottomEdge:SetPoint("BOTTOMRIGHT", frame.bottomRightCorner, "BOTTOMLEFT")

	frame.innerBorderFrame = CreateFrame("Frame", nil, frame, nil)
	frame.innerBorderFrame:SetPoint("TOPLEFT", INNER_FRAME_OFFSET, 0) -- y offset set later
	frame.innerBorderFrame:SetPoint("BOTTOMRIGHT", -INNER_FRAME_OFFSET, INNER_FRAME_OFFSET)

	frame.innerBottomRightCorner = frame.innerBorderFrame:CreateTexture(nil, "BACKGROUND")
	frame.innerBottomRightCorner:SetPoint("BOTTOMRIGHT")

	frame.innerBottomLeftCorner = frame.innerBorderFrame:CreateTexture(nil, "BACKGROUND")
	frame.innerBottomLeftCorner:SetPoint("BOTTOMLEFT")

	frame.innerTopRightCorner = frame.innerBorderFrame:CreateTexture(nil, "BACKGROUND")
	frame.innerTopRightCorner:SetPoint("TOPRIGHT")

	frame.innerTopLeftCorner = frame.innerBorderFrame:CreateTexture(nil, "BACKGROUND")
	frame.innerTopLeftCorner:SetPoint("TOPLEFT")

	frame.innerLeftEdge = frame.innerBorderFrame:CreateTexture(nil, "BACKGROUND")
	frame.innerLeftEdge:SetPoint("TOPLEFT", frame.innerTopLeftCorner, "BOTTOMLEFT")
	frame.innerLeftEdge:SetPoint("BOTTOMLEFT", frame.innerBottomLeftCorner, "TOPLEFT")

	frame.innerRightEdge = frame.innerBorderFrame:CreateTexture(nil, "BACKGROUND")
	frame.innerRightEdge:SetPoint("TOPRIGHT", frame.innerTopRightCorner, "BOTTOMRIGHT")
	frame.innerRightEdge:SetPoint("BOTTOMRIGHT", frame.innerBottomRightCorner, "TOPRIGHT")

	frame.innerTopEdge = frame.innerBorderFrame:CreateTexture(nil, "BACKGROUND")
	frame.innerTopEdge:SetPoint("TOPLEFT", frame.innerTopLeftCorner, "TOPRIGHT")
	frame.innerTopEdge:SetPoint("TOPRIGHT", frame.innerTopRightCorner, "TOPLEFT")

	frame.innerBottomEdge = frame.innerBorderFrame:CreateTexture(nil, "BACKGROUND")
	frame.innerBottomEdge:SetPoint("BOTTOMLEFT", frame.innerBottomLeftCorner, "BOTTOMRIGHT")
	frame.innerBottomEdge:SetPoint("BOTTOMRIGHT", frame.innerBottomRightCorner, "BOTTOMLEFT")

	frame.resizingContent = CreateFrame("Frame", nil, frame.innerBorderFrame, nil)
	frame.resizingContent:SetAllPoints()
	frame.resizingContent:Hide()
	frame.resizingContent.texture = frame.resizingContent:CreateTexture(nil, "ARTWORK")
	frame.resizingContent.texture:SetAllPoints()
	frame.resizingContent.texture:SetColorTexture(TSM.UI.HexToRGBA("#373737"))
	frame.resizingContent.texture:Show()

	frame.topEdge = frame:CreateTexture(nil, "BACKGROUND")
	frame.topEdge:SetPoint("BOTTOMLEFT", frame.innerBorderFrame, "TOPLEFT")
	frame.topEdge:SetPoint("BOTTOMRIGHT", frame.innerBorderFrame, "TOPRIGHT")
	frame.topEdge:SetPoint("TOP", frame.headerBgCenter, "BOTTOM")
	frame.topEdge:SetColorTexture(TSM.UI.HexToRGBA("#373737"))
end

function ApplicationFrame.Acquire(self)
	local frame = self:_GetBaseFrame()
	self:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Button", "resizeBtn")
		:SetStyle("anchors", { { "BOTTOMRIGHT" } })
		:SetStyle("height", TSM.UI.TexturePacks.GetHeight("iconPack.14x14/Resize"))
		:SetStyle("width", TSM.UI.TexturePacks.GetWidth("iconPack.14x14/Resize"))
		:SetStyle("backgroundTexturePack", "iconPack.14x14/Resize")
		:EnableRightClick()
		:SetScript("OnMouseDown", private.ResizeButtonOnMouseDown)
		:SetScript("OnMouseUp", private.ResizeButtonOnMouseUp)
		:SetScript("OnClick", private.ResizeButtonOnClick)
	)
	local lastScan = TSM.AuctionDB.GetLastCompleteScanTime()
	self:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Frame", "titleFrame")
		:SetLayout("HORIZONTAL")
		:SetStyle("height", 15)
		:SetStyle("anchors", { { "LEFT", frame.titleBgLeft, "LEFT", 28, 0 }, { "RIGHT", frame.titleBgRight, "RIGHT", -8, 0 } })
		:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "leftSpacer"))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "title")
			:SetStyle("autoWidth", true)
			:SetStyle("font", TSM.UI.Fonts.MontserratBold)
			:SetStyle("fontHeight", 12)
			:SetStyle("textColor", "#ffffff")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "sep")
			:SetStyle("autoWidth", true)
			:SetStyle("font", TSM.UI.Fonts.MontserratBold)
			:SetStyle("fontHeight", 12)
			:SetStyle("textColor", "#ffffff")
			:SetText(" - ")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "version")
			:SetStyle("autoWidth", true)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 12)
			:SetStyle("textColor", "#ffffff")
			:SetText(TSM:GetVersion())
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
			:SetStyle("width", 1)
			:SetStyle("margin", { left = 8, right = 8 })
			:SetStyle("color", "#80e2e2e2")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "lastUpdate")
			:SetStyle("autoWidth", true)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 12)
			:SetText(L["Last Data Update:"].." "..(lastScan and date("%c", lastScan) or L["No Data"]))
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "middleSpacer"))
		:AddChild(TSMAPI_FOUR.UI.NewElement("PlayerGoldText", "money")
			:SetStyle("autoWidth", true)
			:SetStyle("fontHeight", 14)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "rightSpacer"))
	)
	self:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Button", "closeBtn")
		:SetStyle("anchors", { { "TOPLEFT", frame.titleBgClose } })
		:SetStyle("backgroundTexturePack", "iconPack.24x24/Close/Default")
		:SetScript("OnClick", private.CloseButtonOnClick)
	)
	self.__super:Acquire()
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetResizable(true)
	frame:RegisterForDrag("LeftButton")
	self:SetScript("OnDragStart", private.FrameOnDragStart)
	self:SetScript("OnDragStop", private.FrameOnDragStop)
end

function ApplicationFrame.Release(self)
	self._contentFrame = nil
	self._contextTable = nil
	self._defaultContextTable = nil
	self:_GetBaseFrame():SetMinResize(0, 0)
	self:_GetBaseFrame():SetMaxResize(0, 0)
	self._innerTextureInfo = nil
	self._outerTextureInfo = nil
	self._isScaling = nil
	self._minWidth = 0
	self._minHeight = 0
	self.__super:Release()
end

--- Sets the texture set to use.
-- @tparam ApplicationFrame self The application frame object
-- @tparam string outer The texture set to use for the outer textures
-- @tparam string inner The texture set to use for the inner textures
-- @treturn ApplicationFrame The application frame object
function ApplicationFrame.SetTextureSet(self, outer, inner)
	self._outerTextureInfo = OUTER_TEXTURE_INFO[outer]
	self._innerTextureInfo = INNER_TEXTURE_INFO[inner]

	-- update all the textures
	local frame = self:_GetBaseFrame()
	TSM.UI.TexturePacks.SetTextureAndSize(frame.headerBgLeft, self._outerTextureInfo.topLeft)
	TSM.UI.TexturePacks.SetTextureAndSize(frame.headerBgRight, self._outerTextureInfo.topRight)
	TSM.UI.TexturePacks.SetTextureAndHeight(frame.headerBgCenter, self._outerTextureInfo.top)
	frame.titleBgClose:SetPoint("TOPRIGHT", self._outerTextureInfo.titleBGRightOffset, TITLE_BG_OFFSET_TOP)
	TSM.UI.TexturePacks.SetTextureAndSize(frame.titleBgClose, self._outerTextureInfo.closeBackground)
	TSM.UI.TexturePacks.SetTextureAndSize(frame.bottomLeftCorner, self._outerTextureInfo.bottomLeft)
	TSM.UI.TexturePacks.SetTextureAndSize(frame.bottomRightCorner, self._outerTextureInfo.bottomRight)
	TSM.UI.TexturePacks.SetTextureAndWidth(frame.leftEdge, self._outerTextureInfo.left)
	TSM.UI.TexturePacks.SetTextureAndWidth(frame.rightEdge, self._outerTextureInfo.right)
	TSM.UI.TexturePacks.SetTextureAndHeight(frame.bottomEdge, self._outerTextureInfo.bottom)
	frame.innerBorderFrame:SetPoint("TOPLEFT", INNER_FRAME_OFFSET, self._innerTextureInfo.topOffset)
	TSM.UI.TexturePacks.SetTextureAndSize(frame.innerBottomRightCorner, self._innerTextureInfo.bottomRight)
	TSM.UI.TexturePacks.SetTextureAndSize(frame.innerBottomLeftCorner, self._innerTextureInfo.bottomLeft)
	TSM.UI.TexturePacks.SetTextureAndSize(frame.innerTopRightCorner, self._innerTextureInfo.topRight)
	TSM.UI.TexturePacks.SetTextureAndSize(frame.innerTopLeftCorner, self._innerTextureInfo.topLeft)
	TSM.UI.TexturePacks.SetTextureAndWidth(frame.innerLeftEdge, self._innerTextureInfo.left)
	TSM.UI.TexturePacks.SetTextureAndWidth(frame.innerRightEdge, self._innerTextureInfo.right)
	TSM.UI.TexturePacks.SetTextureAndHeight(frame.innerTopEdge, self._innerTextureInfo.top)
	TSM.UI.TexturePacks.SetTextureAndHeight(frame.innerBottomEdge, self._innerTextureInfo.bottom)

	if self._innerTextureInfo.showTopEdge then
		frame.topEdge:Show()
	else
		frame.topEdge:Hide()
	end

	return self
end

--- Adds a switch button to the title frame.
-- @tparam ApplicationFrame self The application frame object
-- @tparam function onClickHandler The handler for the OnClick script for the button
-- @treturn ApplicationFrame The application frame object
function ApplicationFrame.AddSwitchButton(self, onClickHandler)
	self:GetElement("titleFrame")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "switchBtn")
			:SetStyle("width", 131)
			:SetStyle("height", 16)
			:SetStyle("backgroundTexturePack", "uiFrames.DefaultUIButton")
			:SetStyle("margin.left", 8)
			:SetStyle("font", TSM.UI.Fonts.MontserratBold)
			:SetStyle("fontHeight", 10)
			:SetStyle("textColor", "#2e2e2e")
			:SetText(L["Switch to WoW UI"])
			:SetScript("OnClick", onClickHandler)
		)
	return self
end

--- Sets the title text.
-- @tparam ApplicationFrame self The application frame object
-- @tparam string title The title text
-- @treturn ApplicationFrame The application frame object
function ApplicationFrame.SetTitle(self, title)
	local titleFrame = self:GetElement("titleFrame")
	titleFrame:GetElement("title"):SetText(title)
	titleFrame:Draw()
	return self
end

--- Sets the content frame.
-- @tparam ApplicationFrame self The application frame object
-- @tparam Frame frame The frame's content frame
-- @treturn ApplicationFrame The application frame object
function ApplicationFrame.SetContentFrame(self, frame)
	assert(frame:__isa(TSM.UI.Frame))
	-- y offset of TOPLEFT is set later
	frame:SetStyle("anchors", { { "TOPLEFT", INNER_FRAME_OFFSET, 0 }, { "BOTTOMRIGHT", -INNER_FRAME_OFFSET, INNER_FRAME_OFFSET } })
	self._contentFrame = frame
	self:AddChildNoLayout(frame)
	return self
end

--- Sets the context table.
-- This table can be used to preserve position and size information across lifecycles of the application frame and even
-- WoW sessions if it's within the settings DB.
-- @tparam ApplicationFrame self The application frame object
-- @tparam table tbl The context table
-- @tparam table defaultTbl Default values (required attributes: `width`, `height`, `centerX`, `centerY`)
-- @treturn ApplicationFrame The application frame object
function ApplicationFrame.SetContextTable(self, tbl, defaultTbl)
	assert(defaultTbl.width > 0 and defaultTbl.height > 0)
	assert(defaultTbl.centerX and defaultTbl.centerY)
	tbl.width = tbl.width or defaultTbl.width
	tbl.height = tbl.height or defaultTbl.height
	tbl.centerX = tbl.centerX or defaultTbl.centerX
	tbl.centerY = tbl.centerY or defaultTbl.centerY
	self._contextTable = tbl
	self._defaultContextTable = defaultTbl
	return self
end

--- Sets the minimum size the application frame can be resized to.
-- @tparam ApplicationFrame self The application frame object
-- @tparam number minWidth The minimum width
-- @tparam number minHeight The minimum height
-- @treturn ApplicationFrame The application frame object
function ApplicationFrame.SetMinResize(self, minWidth, minHeight)
	self._minWidth = minWidth
	self._minHeight = minHeight
	return self
end

--- Shows a dialog frame.
-- @tparam ApplicationFrame self The application frame object
-- @tparam Element frame The element to show in a dialog
-- @param context The context to set on the dialog frame
function ApplicationFrame.ShowDialogFrame(self, frame, context)
	assert(not self:IsDialogVisible())
	self._contentFrame:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Frame", "_dialog")
		:SetStyle("relativeLevel", INNER_BORDER_RELATIVE_LEVEL - 2)
		:SetStyle("anchors", { { "TOPLEFT" }, { "BOTTOMRIGHT" } })
		:SetStyle("background", "#592e2e2e")
		:SetMouseEnabled(true)
		:SetContext(context)
		:SetScript("OnMouseUp", private.DialogOnMouseUp)
		:SetScript("OnHide", private.DialogOnHide)
		:AddChildNoLayout(frame)
	)
	local dialog = self._contentFrame:GetElement("_dialog")
	dialog:Show()
	dialog:Draw()
end

--- Returns whether or not the dialog frame is visible.
-- @tparam ApplicationFrame self The application frame object
-- @treturn boolean Whether or not the element is currently visible
function ApplicationFrame.IsDialogVisible(self)
	return self._contentFrame:GetElement("_dialog") and true or false
end

--- Show a confirmation dialog.
-- @tparam ApplicationFrame self The application frame object
-- @tparam string title The title of the dialog
-- @tparam string subTitle The sub-title of the dialog
-- @tparam string confirmBtnText The confirm button text
-- @tparam function callback The callback for when the dialog is closed
-- @tparam[opt] varag ... Arguments to pass to the callback
function ApplicationFrame.ShowConfirmationDialog(self, title, subTitle, confirmBtnText, callback, ...)
	local context = TSMAPI_FOUR.Util.AcquireTempTable(...)
	context.callback = callback
	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "frame")
		:SetLayout("VERTICAL")
		:SetStyle("width", 412)
		:SetStyle("height", 188)
		:SetStyle("anchors", { { "CENTER" } })
		:SetStyle("background", "#2e2e2e")
		:SetStyle("border", "#e2e2e2")
		:SetStyle("borderSize", 2)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "title")
			:SetStyle("height", 20)
			:SetStyle("margin", { top = 24, left = 16, right = 16, bottom = 16 })
			:SetStyle("font", TSM.UI.Fonts.bold)
			:SetStyle("fontHeight", 18)
			:SetStyle("justifyH", "CENTER")
			:SetText(title)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc")
			:SetStyle("height", 60)
			:SetStyle("margin", { left = 32, right = 32, bottom = 25 })
			:SetStyle("font", TSM.UI.Fonts.MontserratItalic)
			:SetStyle("fontHeight", 14)
			:SetStyle("justifyH", "CENTER")
			:SetText(subTitle)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "buttons")
			:SetLayout("HORIZONTAL")
			:SetStyle("margin", { left = 16, right = 16, bottom = 16 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "cancelBtn")
				:SetStyle("width", 80)
				:SetStyle("height", 26)
				:SetStyle("margin", { right = 16 })
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 16)
				:SetText(CANCEL)
				:SetScript("OnClick", private.DialogCancelBtnOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "deleteBtn")
				:SetStyle("width", 126)
				:SetStyle("height", 26)
				:SetText(confirmBtnText)
				:SetScript("OnClick", private.DialogConfirmBtnOnClick)
			)
		)
	self:ShowDialogFrame(frame, context)
end

--- Show a dialog triggered by a "more" button.
-- @tparam ApplicationFrame self The application frame object
-- @tparam Button moreBtn The "more" button
-- @tparam function iter A dialog menu row iterator with the following fields: `index, text, callback`
function ApplicationFrame.ShowMoreButtonDialog(self, moreBtn, iter)
	local frame = TSMAPI_FOUR.UI.NewElement("MenuDialogFrame", "moreDialog")
		:SetLayout("VERTICAL")
		:SetStyle("width", 200)
		:SetStyle("anchors", { { "TOPRIGHT", moreBtn:_GetBaseFrame(), "BOTTOM", 22, -16 } })
		:SetStyle("padding.top", 8)
		:SetStyle("padding.bottom", 4)
		:SetStyle("background", "#2e2e2e")
		:SetStyle("borderInset", 8)
	local numRows = 0
	for i, text, callback in iter do
		frame:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "row"..i)
			:SetStyle("height", 20)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 14)
			:SetStyle("justifyH", "CENTER")
			:SetStyle("textColor", "#ffffff")
			:SetText(text)
			:SetScript("OnClick", callback)
		)
		numRows = numRows + 1
	end
	frame:SetStyle("height", 12 + numRows * 20)
	self:ShowDialogFrame(frame)
end

--- Hides the current dialog.
-- @tparam ApplicationFrame self The application frame object
function ApplicationFrame.HideDialog(self)
	local dialog = self._contentFrame:GetElement("_dialog")
	if not dialog then
		return
	end
	dialog:GetParentElement():RemoveChild(dialog)
	dialog:Hide()
	dialog:Release()
end

function ApplicationFrame.Draw(self)
	local frame = self:_GetBaseFrame()
	frame:SetToplevel(true)
	frame.resizingContent:SetFrameLevel(frame:GetFrameLevel() + INNER_BORDER_RELATIVE_LEVEL + 5)

	local contentFrameAnchors = self._contentFrame:_GetStyle("anchors")
	contentFrameAnchors[1][3] = self._innerTextureInfo.topOffset

	self:GetElement("closeBtn")
		:SetStyle("width", self._outerTextureInfo.closeButtonWidth or TSM.UI.TexturePacks.GetWidth(self._outerTextureInfo.closeBackground))
		:SetStyle("height", TSM.UI.TexturePacks.GetHeight(self._outerTextureInfo.closeBackground))

	-- update the size if it's less than the set min size
	assert(self._minWidth > 0 and self._minHeight > 0)
	self._contextTable.width = max(self._contextTable.width, self._minWidth)
	self._contextTable.height = max(self._contextTable.height, self._minHeight)
	self._contextTable.scale = max(self._contextTable.scale, MIN_SCALE)

	-- set the frame size from the contextTable
	self:SetStyle("scale", self._contextTable.scale)
	self:SetStyle("width", self._contextTable.width)
	self:SetStyle("height", self._contextTable.height)

	-- make sure the center of the frame is on the screen
	local maxAbsCenterX = (UIParent:GetWidth() / self._contextTable.scale) / 2
	local maxAbsCenterY = (UIParent:GetHeight() / self._contextTable.scale) / 2
	self._contextTable.centerX = min(max(self._contextTable.centerX, -maxAbsCenterX), maxAbsCenterX)
	self._contextTable.centerY = min(max(self._contextTable.centerY, -maxAbsCenterY), maxAbsCenterY)

	-- set the frame position from the contextTable
	local anchors = self:_GetStyle("anchors") or { { "CENTER" } }
	anchors[1][2] = self._contextTable.centerX
	anchors[1][3] = self._contextTable.centerY
	self:SetStyle("anchors", anchors)

	frame.innerBorderFrame:SetFrameLevel(frame:GetFrameLevel() + INNER_BORDER_RELATIVE_LEVEL)
	frame.innerBorderFrame:SetPoint("BOTTOMRIGHT", -INNER_FRAME_OFFSET, INNER_FRAME_OFFSET + (self:_GetStyle("bottomPadding") or 0))

	self.__super:Draw()

	local titleFrame = self:GetElement("titleFrame")
	local titleStyle = self:_GetStyle("titleStyle")
	if titleStyle == "FULL" then
		titleFrame:GetElement("leftSpacer"):Hide()
		titleFrame:GetElement("line"):Show()
		titleFrame:GetElement("lastUpdate"):Show()
		titleFrame:GetElement("middleSpacer"):Show()
		titleFrame:GetElement("money"):Show()
		titleFrame:GetElement("rightSpacer"):Hide()
	elseif titleStyle == "TITLE_ONLY" then
		if self:GetElement("titleFrame.switchBtn") then
			-- left-align the text
			titleFrame:GetElement("leftSpacer"):Hide()
		else
			-- center the text
			titleFrame:GetElement("leftSpacer"):Show()
		end
		titleFrame:GetElement("line"):Hide()
		titleFrame:GetElement("lastUpdate"):Hide()
		titleFrame:GetElement("middleSpacer"):Hide()
		titleFrame:GetElement("money"):Hide()
		titleFrame:GetElement("rightSpacer"):Show()
	else
		error("Invalid titleStyle: "..tostring(titleStyle))
	end
	titleFrame:Draw()
end

function ApplicationFrame.SetBottomPadding(self, padding)
	self:SetStyle("bottomPadding", padding)
	local frame = self:_GetBaseFrame()
	frame.innerBorderFrame:SetPoint("BOTTOMRIGHT", -INNER_FRAME_OFFSET, INNER_FRAME_OFFSET + (padding or 0))
end




-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ApplicationFrame._SavePositionAndSize(self, wasScaling)
	local frame = self:_GetBaseFrame()
	local parentFrame = frame:GetParent()
	local width = frame:GetWidth()
	local height = frame:GetHeight()
	if wasScaling then
		-- the anchor is in our old frame's scale, so convert the parent measurements to our old scale and then the resuslt to our new scale
		local scaleAdjustment = width / self._contextTable.width
		local frameLeftOffset = frame:GetLeft()  - parentFrame:GetLeft() / self._contextTable.scale
		self._contextTable.centerX = (frameLeftOffset - (parentFrame:GetWidth() / self._contextTable.scale - width) / 2) / scaleAdjustment
		local frameBottomOffset = frame:GetBottom() - parentFrame:GetBottom() / self._contextTable.scale
		self._contextTable.centerY = (frameBottomOffset - (parentFrame:GetHeight() / self._contextTable.scale - height) / 2) / scaleAdjustment
		self._contextTable.scale = self._contextTable.scale * scaleAdjustment
	else
		self._contextTable.width = width
		self._contextTable.height = height
		-- the anchor is in our frame's scale, so convert the parent measurements to our scale
		local frameLeftOffset = frame:GetLeft() - parentFrame:GetLeft() / self._contextTable.scale
		self._contextTable.centerX = (frameLeftOffset - (parentFrame:GetWidth() / self._contextTable.scale - width) / 2)
		local frameBottomOffset = frame:GetBottom() - parentFrame:GetBottom() / self._contextTable.scale
		self._contextTable.centerY = (frameBottomOffset - (parentFrame:GetHeight() / self._contextTable.scale - height) / 2)
	end
end

function ApplicationFrame._SetResizing(self, resizing)
	local frame = self:_GetBaseFrame()
	if resizing then
		frame.resizingContent:Show()
	else
		frame.resizingContent:Hide()
	end
	if resizing then
		self:GetElement("titleFrame"):Hide()
		self._contentFrame:SetStyle("anchors", { { "CENTER" } })
		self._contentFrame:SetStyle("width", self._minWidth - 20)
		self._contentFrame:SetStyle("height", self._minHeight - 150)
		self._contentFrame:Draw()
	else
		self:GetElement("titleFrame"):Show()
		self._contentFrame:SetStyle("anchors", { { "TOPLEFT", INNER_FRAME_OFFSET, self._innerTextureInfo.topOffset }, { "BOTTOMRIGHT", -INNER_FRAME_OFFSET, INNER_FRAME_OFFSET } })
		self._contentFrame:SetStyle("width", nil)
		self._contentFrame:SetStyle("height", nil)
	end
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.CloseButtonOnClick(button)
	button:GetParentElement():Hide()
end

function private.ResizeButtonOnMouseDown(button, mouseButton)
	if mouseButton ~= "LeftButton" then
		return
	end
	local self = button:GetParentElement()
	self._isScaling = IsShiftKeyDown()
	local frame = self:_GetBaseFrame()
	local width = frame:GetWidth()
	local height = frame:GetHeight()
	if self._isScaling then
		local minWidth = width * MIN_SCALE / self._contextTable.scale
		local minHeight = height * MIN_SCALE / self._contextTable.scale
		frame:SetMinResize(minWidth, minHeight)
		frame:SetMaxResize(width * 10, height * 10)
	else
		frame:SetMinResize(self._minWidth, self._minHeight)
		frame:SetMaxResize(width * 10, height * 10)
	end
	self:_SetResizing(true)
	frame:StartSizing("BOTTOMRIGHT")
	-- force updating the size here, to prevent using cached values from previously opened application frames
	frame:SetWidth(width)
	frame:SetHeight(height)
end

function private.ResizeButtonOnMouseUp(button, mouseButton)
	if mouseButton ~= "LeftButton" then
		return
	end
	local self = button:GetParentElement()
	self:_GetBaseFrame():StopMovingOrSizing()
	self:_SetResizing(false)
	self:_SavePositionAndSize(self._isScaling)
	self._isScaling = nil
	self:Draw()
end

function private.ResizeButtonOnClick(button, mouseButton)
	if mouseButton ~= "RightButton" then
		return
	end
	local self = button:GetParentElement()
	self._contextTable.scale = self._defaultContextTable.scale
	self._contextTable.width = self._defaultContextTable.width
	self._contextTable.height = self._defaultContextTable.height
	self._contextTable.centerX = self._defaultContextTable.centerX
	self._contextTable.centerY = self._defaultContextTable.centerY
	self:Draw()
end

function private.FrameOnDragStart(self)
	self:_GetBaseFrame():StartMoving()
end

function private.FrameOnDragStop(self)
	self:_GetBaseFrame():StopMovingOrSizing()
	self:_SavePositionAndSize()
end

function private.DialogOnMouseUp(dialog)
	local self = dialog:GetParentElement():GetParentElement()
	self:HideDialog()
end

function private.DialogOnHide(dialog)
	local context = dialog:GetContext()
	if context then
		TSMAPI_FOUR.Util.ReleaseTempTable(context)
	end
end

function private.DialogCancelBtnOnClick(button)
	local self = button:GetBaseElement()
	self:HideDialog()
end

function private.DialogConfirmBtnOnClick(button)
	local self = button:GetBaseElement()
	local dialog = self._contentFrame:GetElement("_dialog")
	local context = dialog:GetContext()
	dialog:SetContext(nil)
	self:HideDialog()
	context.callback(TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(context))
end
