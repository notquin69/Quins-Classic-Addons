-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local MainUI = TSM:NewPackage("MainUI")
local private = { topLevelPages = {}, frame = nil }
local MIN_FRAME_SIZE = { width = 948, height = 757 }



-- ============================================================================
-- Module Functions
-- ============================================================================

function MainUI.OnDisable()
	-- hide the frame
	if private.frame then
		MainUI.Toggle()
	end
end

function MainUI.RegisterTopLevelPage(name, texturePack, callback)
	tinsert(private.topLevelPages, { name = name, texturePack = texturePack, callback = callback })
end

function MainUI.Toggle()
	if private.frame then
		-- it's already shown, so hide it
		private.frame:Hide()
		assert(not private.frame)
	else
		private.frame = private.CreateMainFrame()
		private.frame:Draw()
		private.frame:Show()
	end
end



-- ============================================================================
-- Main Frame
-- ============================================================================

function private.CreateMainFrame()
	TSM.UI.AnalyticsRecordPathChange("main")
	-- Always show the Dashboard first
	TSM.db.global.internalData.mainUIFrameContext.page = 1
	local frame = TSMAPI_FOUR.UI.NewElement("LargeApplicationFrame", "base")
		:SetParent(UIParent)
		:SetMinResize(MIN_FRAME_SIZE.width, MIN_FRAME_SIZE.height)
		:SetContextTable(TSM.db.global.internalData.mainUIFrameContext, TSM.db:GetDefaultReadOnly("global", "internalData", "mainUIFrameContext"))
		:SetStyle("strata", "HIGH")
		:SetTitle("TSM Core")
		:SetScript("OnHide", private.BaseFrameOnHide)
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
	TSM.UI.AnalyticsRecordClose("main")
end
