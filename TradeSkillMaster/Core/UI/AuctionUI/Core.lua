-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local AuctionUI = TSM.UI:NewPackage("AuctionUI")
local L = TSM.L
local private = {
	topLevelPages = {},
	frame = nil,
	hasShown = false,
	isSwitching = false,
	scanningPage = nil,
	updateCallbacks = {},
}
local HEADER_LINE_TEXT_MARGIN = { right = 8 }
local HEADER_LINE_MARGIN = { top = 16, bottom = 16 }
local MIN_FRAME_SIZE = { width = 830, height = 587 }



-- ============================================================================
-- Module Functions
-- ============================================================================

function AuctionUI.OnInitialize()
	UIParent:UnregisterEvent("AUCTION_HOUSE_SHOW")
	TSMAPI_FOUR.Event.Register("AUCTION_HOUSE_SHOW", private.AuctionFrameInit)
	TSMAPI_FOUR.Event.Register("AUCTION_HOUSE_CLOSED", private.HideAuctionFrame)
	TSMAPI_FOUR.Delay.AfterTime(1, function() LoadAddOn("Blizzard_AuctionUI") end)
	TSMAPI_FOUR.Util.RegisterItemLinkedCallback(private.ItemLinkedCallback)
end

function AuctionUI.OnDisable()
	if private.frame then
		-- hide the frame
		private.frame:Hide()
		assert(not private.frame)
	end
end

function AuctionUI.RegisterTopLevelPage(name, texturePack, callback, itemLinkedHandler)
	tinsert(private.topLevelPages, { name = name, texturePack = texturePack, callback = callback, itemLinkedHandler = itemLinkedHandler })
end

function AuctionUI.CreateHeadingLine(id, text)
	return TSMAPI_FOUR.UI.NewElement("Frame", id)
		:SetLayout("HORIZONTAL")
		:SetStyle("height", 34)
		:SetStyle("margin", HEADER_LINE_MARGIN)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
			:SetStyle("textColor", "#79a2ff")
			:SetStyle("fontHeight", 24)
			:SetStyle("margin", HEADER_LINE_TEXT_MARGIN)
			:SetStyle("autoWidth", true)
			:SetText(text)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "vline")
			:SetStyle("color", "#e2e2e2")
			:SetStyle("height", 2)
		)
end

function AuctionUI.StartingScan(pageName)
	if private.scanningPage and private.scanningPage ~= pageName then
		TSM:Printf(L["A scan is already in progress. Please stop that scan before starting another one."])
		return false
	end
	private.scanningPage = pageName
	TSM:LOG_INFO("Starting scan %s", pageName)
	if private.frame then
		private.frame:SetPulsingNavButton(private.scanningPage)
	end
	for _, callback in ipairs(private.updateCallbacks) do
		callback()
	end
	return true
end

function AuctionUI.EndedScan(pageName)
	if private.scanningPage == pageName then
		TSM:LOG_INFO("Ended scan %s", pageName)
		private.scanningPage = nil
		if private.frame then
			private.frame:SetPulsingNavButton()
		end
		for _, callback in ipairs(private.updateCallbacks) do
			callback()
		end
	end
end

function AuctionUI.SetOpenPage(name)
	private.frame:SetSelectedNavButton(name, true)
end

function AuctionUI.IsPageOpen(name)
	if not private.frame then
		return false
	end
	return private.frame:GetSelectedNavButton() == name
end

function AuctionUI.IsScanning()
	return private.scanningPage and true or false
end

function AuctionUI.RegisterUpdateCallback(callback)
	tinsert(private.updateCallbacks, callback)
end

function AuctionUI.IsVisible()
	return private.frame and true or false
end



-- ============================================================================
-- Main Frame
-- ============================================================================

function private.AuctionFrameInit()
	if not private.hasShown then
		private.hasShown = true
		local tabId = AuctionFrame.numTabs + 1
		local tab = CreateFrame("Button", "AuctionFrameTab"..tabId, AuctionFrame, "AuctionTabTemplate")
		tab:Hide()
		tab:SetID(tabId)
		tab:SetText("|cff99ffffTSM4|r")
		tab:SetNormalFontObject(GameFontHighlightSmall)
		tab:SetPoint("LEFT", _G["AuctionFrameTab"..tabId - 1], "RIGHT", -8, 0)
		tab:Show()
		PanelTemplates_SetNumTabs(AuctionFrame, tabId)
		PanelTemplates_EnableTab(AuctionFrame, tabId)
		tab:SetScript("OnClick", private.TSMTabOnClick)
	end
	if TSM.db.global.internalData.auctionUIFrameContext.showDefault then
		UIParent_OnEvent(UIParent, "AUCTION_HOUSE_SHOW")
	else
		private.ShowAuctionFrame()
	end
end

function private.ShowAuctionFrame()
	if private.frame then
		return
	end
	private.frame = private.CreateMainFrame()
	private.frame:Show()
	private.frame:Draw()
	for _, callback in ipairs(private.updateCallbacks) do
		callback()
	end
end

function private.HideAuctionFrame()
	if not private.frame then
		return
	end
	private.frame:Hide()
	assert(not private.frame)
	for _, callback in ipairs(private.updateCallbacks) do
		callback()
	end
end

function private.CreateMainFrame()
	TSM.UI.AnalyticsRecordPathChange("auction")
	local frame = TSMAPI_FOUR.UI.NewElement("LargeApplicationFrame", "base")
		:SetParent(UIParent)
		:SetMinResize(MIN_FRAME_SIZE.width, MIN_FRAME_SIZE.height)
		:SetContextTable(TSM.db.global.internalData.auctionUIFrameContext, TSM.db:GetDefaultReadOnly("global", "internalData", "auctionUIFrameContext"))
		:SetStyle("strata", "HIGH")
		:SetTitle("TSM Auction House")
		:SetScript("OnHide", private.BaseFrameOnHide)
	frame:GetElement("titleFrame")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "switchBtn")
			:SetStyle("width", 131)
			:SetStyle("height", 16)
			:SetStyle("backgroundTexturePack", "uiFrames.DefaultUIButton")
			:SetStyle("margin", { left = 8 })
			:SetStyle("font", TSM.UI.Fonts.MontserratBold)
			:SetStyle("fontHeight", 10)
			:SetStyle("textColor", "#2e2e2e")
			:SetText(L["Switch to WoW UI"])
			:SetScript("OnClick", private.SwitchBtnOnClick)
		)
	for _, info in ipairs(private.topLevelPages) do
		frame:AddNavButton(info.name, info.texturePack, info.callback)
	end
	return frame
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.BaseFrameOnHide(frame)
	assert(frame == private.frame)
	frame:Release()
	private.frame = nil
	if not private.isSwitching then
		CloseAuctionHouse()
	end
	TSM.UI.AnalyticsRecordClose("auction")
end

function private.SwitchBtnOnClick(button)
	private.isSwitching = true
	TSM.db.global.internalData.auctionUIFrameContext.showDefault = true
	private.HideAuctionFrame()
	UIParent_OnEvent(UIParent, "AUCTION_HOUSE_SHOW")
	private.isSwitching = false
end

local function NoOp()
	-- do nothing - what did you expect?
end
function private.TSMTabOnClick()
	-- Replace CloseAuctionHouse() with a no-op while hiding the AH frame so we don't stop interacting with the AH NPC
	local origCloseAuctionHouse = CloseAuctionHouse
	TSM.db.global.internalData.auctionUIFrameContext.showDefault = false
	ClearCursor()
	ClickAuctionSellItemButton(AuctionsItemButton, "LeftButton")
	ClearCursor()
	CloseAuctionHouse = NoOp
	AuctionFrame_Hide()
	CloseAuctionHouse = origCloseAuctionHouse
	private.ShowAuctionFrame()
end

function private.ItemLinkedCallback(name, itemLink)
	if not private.frame then
		return
	end
	local path = private.frame:GetSelectedNavButton()
	for _, info in ipairs(private.topLevelPages) do
		if info.name == path then
			if info.itemLinkedHandler(name, itemLink) then
				return true
			else
				return
			end
		end
	end
	error("Invalid frame path")
end
