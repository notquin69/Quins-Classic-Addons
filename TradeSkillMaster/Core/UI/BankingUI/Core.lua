-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local BankingUI = TSM.UI:NewPackage("BankingUI")
local L = TSM.L
local private = {
	fsm = nil,
	currentModule = nil,
	groupSearch = "",
}
local MIN_FRAME_SIZE = { width = 325, height = 600 }
local BASE_STYLESHEET = TSM.UI.Util.Stylesheet()
	:SetStyleTable("ActionButton", "NAV", {
		height = 20,
		margin = { left = 4 },
		font = TSM.UI.Fonts.MontserratMedium,
		fontHeight = 10,
	})
	:SetStyleTable("ActionButton", "FOOTER_FULL", {
		height = 26,
		margin = { top = 8, left = 2, right = 2 },
		fontHeight = 13,
	})
	:SetStyleTable("ActionButton", "FOOTER_LEFT", {
		height = 26,
		margin = { top = 8, left = 2, right = 8 },
		fontHeight = 13,
	})
	:SetStyleTable("ActionButton", "FOOTER_RIGHT", {
		height = 26,
		margin = { top = 8, right = 2 },
		fontHeight = 13,
	})
local MODULE_LIST = {
	"Warehousing",
	"Auctioning",
	"Mailing",
}
local BUTTON_TEXT_LOOKUP = {
	Warehousing = L["Warehousing"],
	Auctioning = L["Auctioning"],
	Mailing = L["Mailing"],
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function BankingUI.OnInitialize()
	private.currentModule = TSM.db.global.internalData.bankingUIFrameContext.tab
	private.FSMCreate()
end

function BankingUI.OnDisable()
	-- hide the frame
	private.fsm:ProcessEvent("EV_BANK_CLOSED")
end

function BankingUI.Toggle()
	private.fsm:ProcessEvent("EV_TOGGLE")
end



-- ============================================================================
-- Main Frame
-- ============================================================================

function private.CreateMainFrame()
	TSM.UI.AnalyticsRecordPathChange("banking")
	local frame = TSMAPI_FOUR.UI.NewElement("ApplicationFrame", "base")
		:SetTextureSet("LARGE", "SMALL")
		:SetParent(UIParent)
		:SetMinResize(MIN_FRAME_SIZE.width, MIN_FRAME_SIZE.height)
		:SetContextTable(TSM.db.global.internalData.bankingUIFrameContext, TSM.db:GetDefaultReadOnly("global", "internalData", "bankingUIFrameContext"))
		:SetStylesheet(BASE_STYLESHEET)
		:SetStyle("strata", "HIGH")
		:SetStyle("bottomPadding", 170)
		:SetTitle(L["TSM Banking"])
		:SetScript("OnHide", private.BaseFrameOnHide)
		:SetContentFrame(TSMAPI_FOUR.UI.NewElement("Frame", "content")
			:SetLayout("VERTICAL")
			:SetStyle("background", "#272727")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "navButtons")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 20)
				:SetStyle("margin", 8)
				:SetStyle("padding.left", -4) -- account for the left margin of the first button
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "search")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 20)
				:SetStyle("margin.left", 8)
				:SetStyle("margin.right", 8)
				:SetStyle("margin.bottom", 12)
				:AddChild(TSMAPI_FOUR.UI.NewElement("SearchInput", "input")
					:SetText(private.groupSearch)
					:SetHintText(L["Search Groups"])
					:SetScript("OnTextChanged", private.GroupSearchOnTextChanged)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "moreBtn")
					:SetStyle("width", 18)
					:SetStyle("height", 18)
					:SetStyle("margin.left", 8)
					:SetStyle("backgroundTexturePack", "iconPack.18x18/More")
					:SetScript("OnClick", private.MoreBtnOnClick)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ApplicationGroupTree", "groupTree")
				:SetGroupListFunc(private.GroupTreeGetList)
				:SetSearchString(private.groupSearch)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "footer")
				:SetLayout("VERTICAL")
				:SetStyle("background", "#373737")
				:SetStyle("height", 170)
				:AddChild(TSMAPI_FOUR.UI.NewElement("ProgressBar", "progressBar")
					:SetStyle("margin.top", 8)
					:SetStyle("height", 26)
					:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
					:SetStyle("fontHeight", 14)
					:SetProgress(0)
					:SetProgressIconHidden(true)
					:SetText(L["Select Action"])
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "buttons")
					:SetLayout("VERTICAL")
				)
			)
		)
	frame:GetElement("closeBtn"):SetScript("OnClick", private.CloseBtnOnClick)

	for _, module in ipairs(MODULE_LIST) do
		frame:GetElement("content.navButtons"):AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "navBtn_"..module, "NAV")
			:SetContext(module)
			:SetText(BUTTON_TEXT_LOOKUP[module])
			:SetScript("OnClick", private.NavBtnOnClick)
		)
	end

	private.UpdateCurrentModule(frame)

	return frame
end

function private.GroupTreeGetList(groups, headerNameLookup)
	TSM.UI.ApplicationGroupTreeGetGroupList(groups, headerNameLookup, private.currentModule)
end

function private.UpdateCurrentModule(frame)
	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		ReagentBankFrame_OnShow(ReagentBankFrame)
	end
	-- update nav buttons
	local navButtonsFrame = frame:GetElement("content.navButtons")
	for _, module in ipairs(MODULE_LIST) do
		navButtonsFrame:GetElement("navBtn_"..module)
			:SetPressed(module == private.currentModule)
	end
	navButtonsFrame:Draw()

	-- update group tree
	local contextTable = nil
	if private.currentModule == "Warehousing" then
		TSM.UI.AnalyticsRecordPathChange("banking", "warehousing")
		contextTable = TSM.db.profile.internalData.bankingWarehousingGroupTreeContext
	elseif private.currentModule == "Auctioning" then
		TSM.UI.AnalyticsRecordPathChange("banking", "auctioning")
		contextTable = TSM.db.profile.internalData.bankingAuctioningGroupTreeContext
	elseif private.currentModule == "Mailing" then
		TSM.UI.AnalyticsRecordPathChange("banking", "mailing")
		contextTable = TSM.db.profile.internalData.bankingMailingGroupTreeContext
	else
		error("Unexpected module: "..tostring(private.currentModule))
	end
	frame:GetElement("content.groupTree")
		:SetContextTable(contextTable)
		:Draw()

	-- update footer buttons
	local footerButtonsFrame = frame:GetElement("content.footer.buttons")
	footerButtonsFrame:ReleaseAllChildren()
	if private.currentModule == "Warehousing" then
		footerButtonsFrame:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "row1")
			:SetLayout("HORIZONTAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "moveBankBtn", "FOOTER_LEFT")
				:SetText(L["MOVE TO BANK"])
				:SetContext(TSM.Banking.Warehousing.MoveGroupsToBank)
				:SetScript("OnClick", private.GroupBtnOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "moveBagsBtn", "FOOTER_RIGHT")
				:SetText(L["MOVE TO BAGS"])
				:SetContext(TSM.Banking.Warehousing.MoveGroupsToBags)
				:SetScript("OnClick", private.GroupBtnOnClick)
			)
		)
		footerButtonsFrame:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "restockBagsBtn", "FOOTER_FULL")
			:SetText(L["RESTOCK BAGS"])
			:SetContext(TSM.Banking.Warehousing.RestockBags)
			:SetScript("OnClick", private.GroupBtnOnClick)
		)
		footerButtonsFrame:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "depositReagentsBtn", "FOOTER_FULL")
			:SetText(L["DEPOSIT REAGENTS"])
			:SetScript("OnClick", private.WarehousingDepositReagentsBtnOnClick)
		)
		footerButtonsFrame:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "row4")
			:SetLayout("HORIZONTAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "emptyBagsBtn", "FOOTER_LEFT")
				:SetText(L["EMPTY BAGS"])
				:SetContext(TSM.Banking.EmptyBags)
				:SetScript("OnClick", private.SimpleBtnOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "restoreBagsBtn", "FOOTER_RIGHT")
				:SetText(L["RESTORE BAGS"])
				:SetContext(TSM.Banking.RestoreBags)
				:SetScript("OnClick", private.SimpleBtnOnClick)
			)
		)
	elseif private.currentModule == "Auctioning" then
		footerButtonsFrame:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "moveBankBtn", "FOOTER_LEFT")
			:SetText(L["MOVE TO BANK"])
			:SetContext(TSM.Banking.Auctioning.MoveGroupsToBank)
			:SetScript("OnClick", private.GroupBtnOnClick)
		)
		footerButtonsFrame:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "postCapBagsBtn", "FOOTER_FULL")
			:SetText(L["POST CAP TO BAGS"])
			:SetContext(TSM.Banking.Auctioning.PostCapToBags)
			:SetScript("OnClick", private.GroupBtnOnClick)
		)
		footerButtonsFrame:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "shortfallBagsBtn", "FOOTER_FULL")
			:SetText(L["SHORTFALL TO BAGS"])
			:SetContext(TSM.Banking.Auctioning.ShortfallToBags)
			:SetScript("OnClick", private.GroupBtnOnClick)
		)
		footerButtonsFrame:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "maxExpBankBtn", "FOOTER_FULL")
			:SetText(L["MAX EXPIRES TO BANK"])
			:SetContext(TSM.Banking.Auctioning.MaxExpiresToBank)
			:SetScript("OnClick", private.GroupBtnOnClick)
		)
	elseif private.currentModule == "Mailing" then
		footerButtonsFrame:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "moveBankBtn", "FOOTER_LEFT")
			:SetText(L["MOVE TO BANK"])
			:SetContext(TSM.Banking.Mailing.MoveGroupsToBank)
			:SetScript("OnClick", private.GroupBtnOnClick)
		)
		footerButtonsFrame:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "nongroupBankBtn", "FOOTER_FULL")
			:SetText(L["NONGROUP TO BANK"])
			:SetContext(TSM.Banking.Mailing.NongroupToBank)
			:SetScript("OnClick", private.SimpleBtnOnClick)
		)
		footerButtonsFrame:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "targetShortfallBagsBtn", "FOOTER_FULL")
			:SetText(L["TARGET SHORTFALL TO BAGS"])
			:SetContext(TSM.Banking.Mailing.TargetShortfallToBags)
			:SetScript("OnClick", private.GroupBtnOnClick)
		)
		footerButtonsFrame:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "row4")
			:SetLayout("HORIZONTAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "emptyBagsBtn", "FOOTER_LEFT")
				:SetText(L["EMPTY BAGS"])
				:SetContext(TSM.Banking.EmptyBags)
				:SetScript("OnClick", private.SimpleBtnOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "restoreBagsBtn", "FOOTER_RIGHT")
				:SetText(L["RESTORE BAGS"])
				:SetContext(TSM.Banking.RestoreBags)
				:SetScript("OnClick", private.SimpleBtnOnClick)
			)
		)
	else
		error("Unexpected module: "..tostring(private.currentModule))
	end
	footerButtonsFrame:Draw()
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.BaseFrameOnHide()
	TSM.UI.AnalyticsRecordClose("banking")
end

function private.CloseBtnOnClick(button)
	TSM:Print(L["Hiding the TSM Banking UI. Type '/tsm bankui' to reopen it."])
	button:GetParentElement():Hide()
	private.fsm:ProcessEvent("EV_FRAME_HIDDEN")
end

function private.GroupSearchOnTextChanged(input)
	private.groupSearch = strlower(strtrim(input:GetText()))
	input:GetElement("__parent.__parent.groupTree")
		:SetSearchString(private.groupSearch)
		:Draw()
end

function private.NavBtnOnClick(button)
	private.currentModule = button:GetContext()
	private.UpdateCurrentModule(button:GetBaseElement())
	private.fsm:ProcessEvent("EV_NAV_CHANGED")
end

local function MoreDialogRowIterator(_, prevIndex)
	if prevIndex == nil then
		return 1, L["Select All Groups"], private.SelectAllBtnOnClick
	elseif prevIndex == 1 then
		return 2, L["Deselect All Groups"], private.DeselectAllBtnOnClick
	elseif prevIndex == 2 then
		return 3, L["Expand All Groups"], private.ExpandAllBtnOnClick
	elseif prevIndex == 3 then
		return 4, L["Collapse All Groups"], private.CollapseAllBtnOnClick
	end
end
function private.MoreBtnOnClick(button)
	button:GetBaseElement():ShowMoreButtonDialog(button, MoreDialogRowIterator)
end

function private.SelectAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.groupTree"):SelectAll()
	baseFrame:HideDialog()
end

function private.DeselectAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.groupTree"):DeselectAll()
	baseFrame:HideDialog()
end

function private.ExpandAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.groupTree"):ExpandAll()
	baseFrame:HideDialog()
end

function private.CollapseAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.groupTree"):CollapseAll()
	baseFrame:HideDialog()
end

function private.WarehousingDepositReagentsBtnOnClick()
	DepositReagentBank()
end

function private.SimpleBtnOnClick(button)
	private.fsm:ProcessEvent("EV_BUTTON_CLICKED", button, button:GetContext())
end

function private.GroupBtnOnClick(button)
	local groups = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, groupPath in button:GetElement("__base.content.groupTree"):SelectedGroupsIterator() do
		groups[groupPath] = true
	end
	private.fsm:ProcessEvent("EV_BUTTON_CLICKED", button, button:GetContext(), groups)
	TSMAPI_FOUR.Util.ReleaseTempTable(groups)
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.FSMCreate()
	TSM.Banking.RegisterFrameCallback(function(openFrame)
		private.fsm:ProcessEvent(openFrame and "EV_BANK_OPENED" or "EV_BANK_CLOSED")
	end)

	local fsmContext = {
		frame = nil,
		progress = nil,
		activeButton = nil,
	}
	local function UpdateFrame(context)
		if context.activeButton and not context.progress then
			context.activeButton
				:SetPressed(false)
				:Draw()
			context.activeButton = nil
		end

		-- update the nav button state
		local navButtonsFrame = context.frame:GetElement("content.navButtons")
		for _, module in ipairs(MODULE_LIST) do
			navButtonsFrame:GetElement("navBtn_"..module)
				:SetDisabled(context.progress)
		end
		navButtonsFrame:Draw()

		-- update the progress bar
		context.frame:GetElement("content.footer.progressBar")
			:SetProgress(context.progress or 0)
			:SetProgressIconHidden(not context.progress)
			:SetText(context.progress and L["Moving"] or L["Select Action"])
			:Draw()

		-- update the action button state
		local footerButtonsFrame = context.frame:GetElement("content.footer.buttons")
		if private.currentModule == "Warehousing" then
			footerButtonsFrame:GetElement("row1.moveBankBtn")
				:SetDisabled(context.progress)
			footerButtonsFrame:GetElement("row1.moveBagsBtn")
				:SetDisabled(context.progress)
			footerButtonsFrame:GetElement("restockBagsBtn")
				:SetDisabled(context.progress)
			footerButtonsFrame:GetElement("depositReagentsBtn")
				:SetDisabled(context.progress)
			footerButtonsFrame:GetElement("row4.emptyBagsBtn")
				:SetDisabled(context.progress)
			footerButtonsFrame:GetElement("row4.restoreBagsBtn")
				:SetDisabled(context.progress or not TSM.Banking.CanRestoreBags())
		elseif private.currentModule == "Auctioning" then
			footerButtonsFrame:GetElement("moveBankBtn")
				:SetDisabled(context.progress)
			footerButtonsFrame:GetElement("postCapBagsBtn")
				:SetDisabled(context.progress)
			footerButtonsFrame:GetElement("shortfallBagsBtn")
				:SetDisabled(context.progress)
			footerButtonsFrame:GetElement("maxExpBankBtn")
				:SetDisabled(context.progress)
		elseif private.currentModule == "Mailing" then
			footerButtonsFrame:GetElement("moveBankBtn")
				:SetDisabled(context.progress)
			footerButtonsFrame:GetElement("nongroupBankBtn")
				:SetDisabled(context.progress)
			footerButtonsFrame:GetElement("targetShortfallBagsBtn")
				:SetDisabled(context.progress)
			footerButtonsFrame:GetElement("row4.emptyBagsBtn")
				:SetDisabled(context.progress)
			footerButtonsFrame:GetElement("row4.restoreBagsBtn")
				:SetDisabled(context.progress or not TSM.Banking.CanRestoreBags())
		else
			error("Unexpected module: "..tostring(private.currentModule))
		end
		footerButtonsFrame:Draw()
	end
	private.fsm = TSMAPI_FOUR.FSM.New("BANKING_UI")
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_CLOSED")
			:SetOnEnter(function(context)
				if context.frame then
					context.frame:Hide()
					context.frame:Release()
					context.frame = nil
				end
				context.activeButton = nil
			end)
			:AddTransition("ST_CLOSED")
			:AddTransition("ST_FRAME_OPEN")
			:AddTransition("ST_FRAME_HIDDEN")
			:AddEvent("EV_BANK_OPENED", function(context)
				assert(not context.frame)
				if not TSM.db.global.internalData.bankingUIFrameContext.isOpen then
					return "ST_FRAME_HIDDEN"
				end
				return "ST_FRAME_OPEN"
			end)
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_FRAME_HIDDEN")
			:SetOnEnter(function(context)
				TSM.db.global.internalData.bankingUIFrameContext.isOpen = false
				if context.frame then
					context.frame:Hide()
					context.frame:Release()
					context.frame = nil
				end
				context.activeButton = nil
			end)
			:AddTransition("ST_FRAME_OPEN")
			:AddTransition("ST_CLOSED")
			:AddEvent("EV_TOGGLE", function()
				TSM.db.global.internalData.bankingUIFrameContext.isOpen = true
				return "ST_FRAME_OPEN"
			end)
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_FRAME_OPEN")
			:SetOnEnter(function(context)
				if not context.frame then
					context.frame = private.CreateMainFrame()
					context.frame:Show()
					context.frame:Draw()
				end
				UpdateFrame(context)
			end)
			:AddTransition("ST_FRAME_OPEN")
			:AddTransition("ST_FRAME_HIDDEN")
			:AddTransition("ST_PROCESSING")
			:AddTransition("ST_CLOSED")
			:AddEvent("EV_BUTTON_CLICKED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_PROCESSING"))
			:AddEvent("EV_TOGGLE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_FRAME_HIDDEN"))
			:AddEvent("EV_FRAME_HIDDEN", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_FRAME_HIDDEN"))
			:AddEvent("EV_NAV_CHANGED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_FRAME_OPEN"))
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_PROCESSING")
			:SetOnEnter(function(context, button, startFunc, ...)
				context.activeButton = button
				context.activeButton
					:SetPressed(true)
					:Draw()
				context.progress = 0
				startFunc(private.FSMThreadCallback, ...)
				UpdateFrame(context)
			end)
			:SetOnExit(function(context)
				context.progress = nil
			end)
			:AddTransition("ST_FRAME_OPEN")
			:AddTransition("ST_FRAME_HIDDEN")
			:AddTransition("ST_CLOSED")
			:AddEvent("EV_THREAD_PROGRESS", function(context, progress)
				context.progress = progress
				UpdateFrame(context)
			end)
			:AddEvent("EV_THREAD_DONE", function(context)
				if context.progress == 0 then
					TSM:Print(L["Nothing to move."])
				end
				return "ST_FRAME_OPEN"
			end)
			:AddEvent("EV_TOGGLE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_FRAME_HIDDEN"))
		)
		:AddDefaultEvent("EV_BANK_CLOSED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_CLOSED"))
		:Init("ST_CLOSED", fsmContext)
end

function private.FSMThreadCallback(event, ...)
	if event == "PROGRESS" then
		private.fsm:ProcessEvent("EV_THREAD_PROGRESS", ...)
	elseif event == "DONE" then
		private.fsm:ProcessEvent("EV_THREAD_DONE")
	elseif event == "MOVED" then
		-- ignore this event
	else
		error("Unexpected event: "..tostring(event))
	end
end
