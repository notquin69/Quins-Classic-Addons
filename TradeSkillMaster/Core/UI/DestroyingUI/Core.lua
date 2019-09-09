-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local DestroyingUI = TSM.UI:NewPackage("DestroyingUI")
local L = TSM.L
local private = { fsm = nil, query = nil }
local MIN_FRAME_SIZE = { width = 280, height = 280 }
local BASE_STYLESHEET = TSM.UI.Util.Stylesheet()
	:SetStyleTable("Text", nil, {
		height = 16,
		fontHeight = 12,
		justifyH = "CENTER",
	})
	:SetStyleTable("QueryScrollingTable", nil, {
		rowHeight = 20,
	})
	:SetStyleTable("Texture", "HORIZONTAL_LINE", {
		height = 2,
		color = "#9d9d9d",
	})



-- ============================================================================
-- Module Functions
-- ============================================================================

function DestroyingUI.OnInitialize()
	private.FSMCreate()
end

function DestroyingUI.OnDisable()
	-- hide the frame
	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function DestroyingUI.Toggle()
	private.fsm:ProcessEvent("EV_FRAME_TOGGLE")
end



-- ============================================================================
-- Main Frame
-- ============================================================================

function private.CreateMainFrame()
	TSM.UI.AnalyticsRecordPathChange("destroying")
	private.query = private.query or TSM.Destroying.CreateBagQuery()
	private.query:ResetOrderBy()
	private.query:OrderBy("name", true)
	local frame = TSMAPI_FOUR.UI.NewElement("ApplicationFrame", "base")
		:SetTextureSet("SMALL", "SMALL")
		:SetParent(UIParent)
		:SetStylesheet(BASE_STYLESHEET)
		:SetMinResize(MIN_FRAME_SIZE.width, MIN_FRAME_SIZE.height)
		:SetContextTable(TSM.db.global.internalData.destroyingUIFrameContext, TSM.db:GetDefaultReadOnly("global", "internalData", "destroyingUIFrameContext"))
		:SetStyle("strata", "DIALOG")
		:SetTitle(L["TSM Destroying"])
		:SetScript("OnHide", private.FrameOnHide)
		:SetContentFrame(TSMAPI_FOUR.UI.NewElement("Frame", "content")
			:SetLayout("VERTICAL")
			:SetStyle("background", "#2e2e2e")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "header")
				:SetLayout("VERTICAL")
				:SetStyle("height", 70)
				:SetStyle("background", "#404040")
				:SetStyle("padding", { left = 13, right = 13, top = 13 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc")
					:SetText(L["|cffffd839Left-Click|r to ignore an item this session."])
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc2")
					:SetText(L["|cffffd839Shift-Left-Click|r to ignore it permanently."])
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc3")
					:SetStyle("margin", { top = 4 })
					:SetStyle("height", 13)
					:SetStyle("font", TSM.UI.Fonts.MontserratItalic)
					:SetStyle("fontHeight", 10)
					:SetText(L["View ignored items in the Destroying options."])
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line", "HORIZONTAL_LINE"))
			:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "items")
				:GetScrollingTableInfo()
					:NewColumn("item")
						:SetTitles(L["Item"])
						:SetIconSize(12)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo("itemString", TSM.UI.GetColoredItemName)
						:SetIconInfo("itemString", TSMAPI_FOUR.Item.GetTexture)
						:SetTooltipInfo("itemString")
						:SetSortInfo("name")
						:SetTooltipLinkingDisabled(true)
						:Commit()
					:NewColumn("num")
						:SetTitles("#")
						:SetWidth(30)
						:SetFont(TSM.UI.Fonts.RobotoMedium)
						:SetFontHeight(12)
						:SetJustifyH("CENTER")
						:SetTextInfo("quantity")
						:SetSortInfo("quantity")
						:Commit()
					:Commit()
				:SetQuery(private.query)
				:SetSelectionDisabled(true)
				:SetScript("OnRowClick", private.ItemsOnRowClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line", "HORIZONTAL_LINE"))
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "combineBtn")
				:SetStyle("height", 26)
				:SetStyle("margin", { left = 24, right = 24, top = 12 })
				:SetText(L["Combine Partial Stacks"])
				:SetScript("OnClick", private.CombineButtonOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewNamedElement("SecureMacroActionButton", "destroyBtn", "TSMDestroyBtn")
				:SetStyle("height", 26)
				:SetStyle("margin", { left = 24, right = 24, top = 8, bottom = 15 })
				:SetText(L["Destroy Next"])
				:SetScript("PreClick", private.DestroyButtonPreClick)
			)
		)
	frame:GetElement("closeBtn"):SetScript("OnClick", private.CloseButtonOnClick)
	return frame
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FrameOnHide()
	TSM.UI.AnalyticsRecordClose("destroying")
	private.fsm:ProcessEvent("EV_FRAME_TOGGLE")
end

function private.ItemsOnRowClick(_, record, mouseButton)
	if mouseButton ~= "LeftButton" then
		return
	end
	if IsShiftKeyDown() then
		TSM.Destroying.IgnoreItemPermanent(record:GetField("itemString"))
	else
		TSM.Destroying.IgnoreItemSession(record:GetField("itemString"))
	end
	if private.query:Count() == 0 then
		private.fsm:ProcessEvent("EV_FRAME_TOGGLE")
	end
end

function private.CloseButtonOnClick(button)
	private.fsm:ProcessEvent("EV_FRAME_TOGGLE")
end

function private.CombineButtonOnClick(button)
	button:SetPressed(true)
	button:Draw()
	private.fsm:ProcessEvent("EV_COMBINE_BUTTON_CLICKED")
end

function private.DestroyButtonPreClick(button)
	button:SetPressed(true)
	button:Draw()
	private.fsm:ProcessEvent("EV_DESTROY_BUTTON_PRE_CLICK")
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.FSMCreate()
	TSM.Destroying.SetBagUpdateCallback(private.FSMBagUpdate)
	local fsmContext = {
		frame = nil,
		combineThread = false,
		destroyThread = false,
		didShowOnce = false,
		didAutoCombine = false,
	}
	local function UpdateDestroyingFrame(context, redraw)
		if not context.frame then
			return
		end

		local combineBtn = context.frame:GetElement("content.combineBtn")
		combineBtn:SetText(context.combineThread and L["Combining..."] or L["Combine Partial Stacks"])
		combineBtn:SetDisabled(context.combineThread or context.destroyThread or not TSM.Destroying.CanCombine())
		local destroyBtn = context.frame:GetElement("content.destroyBtn")
		destroyBtn:SetText(context.destroyThread and L["Destroying..."] or L["Destroy Next"])
		destroyBtn:SetDisabled(context.combineThread or context.destroyThread or private.query:Count() == 0)
		if redraw then
			context.frame:Draw()
		end
	end
	private.fsm = TSMAPI_FOUR.FSM.New("DESTROYING")
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_FRAME_CLOSED")
			:SetOnEnter(function(context)
				if context.frame then
					context.frame:Hide()
					context.frame:Release()
					context.frame = nil
				end
				if context.combineThread then
					TSMAPI_FOUR.Thread.Kill(context.combineThread)
					context.combineThread = nil
				end
				if context.destroyThread then
					TSM.Destroying.KillDestroyThread()
					context.destroyThread = nil
				end
				context.didAutoCombine = false
			end)
			:AddTransition("ST_FRAME_OPENING")
			:AddEvent("EV_FRAME_TOGGLE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_FRAME_OPENING"))
			:AddEvent("EV_BAG_UPDATE", function(context)
				if not context.didShowOnce and TSM.db.global.destroyingOptions.autoShow then
					return "ST_FRAME_OPENING"
				end
			end)
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_FRAME_OPENING")
			:SetOnEnter(function(context)
				context.didShowOnce = true
				context.frame = private.CreateMainFrame()
				context.frame:Show()
				return "ST_FRAME_OPEN"
			end)
			:AddTransition("ST_FRAME_OPEN")
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_FRAME_OPEN")
			:SetOnEnter(function(context)
				UpdateDestroyingFrame(context, true)
				if TSM.db.global.destroyingOptions.autoStack and not context.didAutoCombine and TSM.Destroying.CanCombine() then
					context.didAutoCombine = true
					context.frame:GetElement("content.combineBtn")
						:SetPressed(true)
						:Draw()
					return "ST_COMBINING_STACKS"
				elseif not TSM.Destroying.CanCombine() and private.query:Count() == 0 then
					-- nothing left to destroy or combine
					return "ST_FRAME_CLOSED"
				end
				context.didAutoCombine = true
			end)
			:AddTransition("ST_FRAME_OPEN")
			:AddTransition("ST_COMBINING_STACKS")
			:AddTransition("ST_DESTROYING")
			:AddTransition("ST_FRAME_CLOSED")
			:AddEvent("EV_COMBINE_BUTTON_CLICKED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_COMBINING_STACKS"))
			:AddEvent("EV_DESTROY_BUTTON_PRE_CLICK", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_DESTROYING"))
			:AddEvent("EV_BAG_UPDATE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_FRAME_OPEN"))
			:AddEvent("EV_FRAME_HIDE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_FRAME_CLOSED"))
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_COMBINING_STACKS")
			:SetOnEnter(function(context)
				assert(not context.combineThread)
				context.combineThread = TSM.Destroying.GetCombineThread()
				TSMAPI_FOUR.Thread.SetCallback(context.combineThread, private.FSMCombineCallback)
				TSMAPI_FOUR.Thread.Start(context.combineThread)
				UpdateDestroyingFrame(context)
			end)
			:AddTransition("ST_COMBINING_DONE")
			:AddTransition("ST_FRAME_CLOSED")
			:AddEvent("EV_COMBINE_DONE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_COMBINING_DONE"))
			:AddEvent("EV_FRAME_HIDE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_FRAME_CLOSED"))
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_COMBINING_DONE")
			:SetOnEnter(function(context)
				context.combineThread = nil
				context.frame:GetElement("content.combineBtn")
					:SetPressed(false)
					:Draw()
				return "ST_FRAME_OPEN"
			end)
			:AddTransition("ST_FRAME_OPEN")
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_DESTROYING")
			:SetOnEnter(function(context)
				assert(not context.destroyThread)
				context.destroyThread = TSM.Destroying.GetDestroyThread()
				TSMAPI_FOUR.Thread.SetCallback(context.destroyThread, private.FSMDestroyCallback)
				TSMAPI_FOUR.Thread.Start(context.destroyThread, context.frame:GetElement("content.destroyBtn"), private.query:GetFirstResult())
				-- we need the thread to run now so send it a sync message
				TSMAPI_FOUR.Thread.SendSyncMessage(context.destroyThread)
				UpdateDestroyingFrame(context)
			end)
			:AddTransition("ST_DESTROYING_DONE")
			:AddTransition("ST_FRAME_CLOSED")
			:AddEvent("EV_DESTROY_DONE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_DESTROYING_DONE"))
			:AddEvent("EV_FRAME_HIDE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_FRAME_CLOSED"))
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_DESTROYING_DONE")
			:SetOnEnter(function(context)
				context.destroyThread = nil
				context.frame:GetElement("content.destroyBtn")
					:SetPressed(false)
					:Draw()
				return "ST_FRAME_OPEN"
			end)
			:AddTransition("ST_FRAME_OPEN")
		)
		:AddDefaultEvent("EV_FRAME_TOGGLE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_FRAME_CLOSED"))
		:Init("ST_FRAME_CLOSED", fsmContext)
end

function private.FSMBagUpdate()
	private.fsm:ProcessEvent("EV_BAG_UPDATE")
end

function private.FSMCombineCallback()
	private.fsm:ProcessEvent("EV_COMBINE_DONE")
end

function private.FSMDestroyCallback()
	private.fsm:ProcessEvent("EV_DESTROY_DONE")
end
