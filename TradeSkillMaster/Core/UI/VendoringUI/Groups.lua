-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Groups = TSM.UI.VendoringUI:NewPackage("Groups")
local L = TSM.L
local private = {
	groupSearch = "",
	fsm = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Groups.OnInitialize()
	private.FSMCreate()
	TSM.UI.VendoringUI.RegisterTopLevelPage(L["Groups"], "iconPack.24x24/Boxes", private.GetFrame)
end



-- ============================================================================
-- Groups UI
-- ============================================================================

function private.GetFrame()
	TSM.UI.AnalyticsRecordPathChange("vendoring", "groups")
	return TSMAPI_FOUR.UI.NewElement("Frame", "buy")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "groupsText")
			:SetStyle("height", 15)
			:SetStyle("margin.top", 33)
			:SetStyle("margin.left", 8)
			:SetStyle("margin.right", 8)
			:SetStyle("margin.bottom", 8)
			:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
			:SetStyle("fontHeight", 12)
			:SetStyle("textColor", "#ffffff")
			:SetFormattedText(L["%d |4Group:Groups; Selected (%d |4Item:Items;)"], 0, 0)
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
			:SetContextTable(TSM.db.profile.internalData.vendoringGroupTreeContext)
			:SetScript("OnGroupSelectionChanged", private.GroupTreeOnGroupSelectionChanged)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "footer")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin.top", 8)
			:SetStyle("margin.bottom", -2)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "gold")
				:SetLayout("HORIZONTAL")
				:SetStyle("width", 167)
				:SetStyle("margin.right", 8)
				:SetStyle("padding", 4)
				:SetStyle("background", "#171717")
				:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "icon")
					:SetStyle("width", 18)
					:SetStyle("height", 18)
					:SetStyle("texturePack", "iconPack.18x18/Coins")
					:SetStyle("vertexColor", "#ffd839")
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("PlayerGoldText", "text")
					:SetStyle("justifyH", "RIGHT")
					:SetStyle("fontHeight", 12)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "buyBtn")
				:SetStyle("margin.right", 8)
				:SetText(L["BUY GROUPS"])
				:SetScript("OnClick", private.BuyBtnOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "sellBtn")
				:SetText(L["SELL GROUPS"])
				:SetScript("OnClick", private.SellBtnOnClick)
			)
		)
		:SetScript("OnUpdate", private.FrameOnUpdate)
		:SetScript("OnHide", private.FrameOnHide)
end

function private.GroupTreeGetList(groups, headerNameLookup)
	TSM.UI.ApplicationGroupTreeGetGroupList(groups, headerNameLookup, "Vendoring")
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FrameOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)
	frame:GetBaseElement():SetBottomPadding(32)

	private.GroupTreeOnGroupSelectionChanged(frame:GetElement("groupTree"))

	private.fsm:ProcessEvent("EV_FRAME_SHOW", frame)
end

function private.FrameOnHide(frame)
	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function private.GroupSearchOnTextChanged(input)
	local text = strlower(strtrim(input:GetText()))
	if text == private.groupSearch then
		return
	end
	private.groupSearch = text

	input:GetElement("__parent.__parent.groupTree")
		:SetSearchString(private.groupSearch)
		:Draw()
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
	baseFrame:GetElement("content.buy.groupTree"):SelectAll()
	baseFrame:HideDialog()
end

function private.DeselectAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.buy.groupTree"):DeselectAll()
	baseFrame:HideDialog()
end

function private.ExpandAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.buy.groupTree"):ExpandAll()
	baseFrame:HideDialog()
end

function private.CollapseAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.buy.groupTree"):CollapseAll()
	baseFrame:HideDialog()
end

function private.GroupTreeOnGroupSelectionChanged(groupTree)
	local footerFrame = groupTree:GetElement("__parent.footer")
	footerFrame:GetElement("sellBtn")
		:SetDisabled(groupTree:IsSelectionCleared())
	footerFrame:GetElement("buyBtn")
		:SetDisabled(groupTree:IsSelectionCleared())
	footerFrame:Draw()

	local numGroups, numItems = 0, 0
	for _, groupPath in groupTree:SelectedGroupsIterator() do
		numGroups = numGroups + 1
		if groupPath == TSM.CONST.ROOT_GROUP_PATH then
			-- TODO
		else
			for _ in TSM.Groups.ItemIterator(groupPath) do
				numItems = numItems + 1
			end
		end
	end
	groupTree:GetElement("__parent.groupsText")
		:SetFormattedText(L["%d |4Group:Groups; Selected (%d |4Item:Items;)"], numGroups, numItems)
		:Draw()
end

function private.BuyBtnOnClick(button)
	private.fsm:ProcessEvent("EV_BUTTON_CLICKED", "BUY")
end

function private.SellBtnOnClick(button)
	private.fsm:ProcessEvent("EV_BUTTON_CLICKED", "SELL")
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.FSMCreate()
	local fsmContext = {
		frame = nil,
		currentOperation = nil,
	}
	local function UpdateFrame(context)
		local footer = context.frame:GetElement("footer")
		footer:GetElement("buyBtn")
			:SetPressed(context.currentOperation == "BUY")
			:SetDisabled(context.currentOperation)
		footer:GetElement("sellBtn")
			:SetPressed(context.currentOperation == "SELL")
			:SetDisabled(context.currentOperation)
		footer:Draw()
	end
	private.fsm = TSMAPI_FOUR.FSM.New("VENDORING_GROUPS")
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_FRAME_CLOSED")
			:SetOnEnter(function(context)
				context.frame = nil
				assert(not context.currentOperation)
			end)
			:AddTransition("ST_FRAME_OPEN")
			:AddTransition("ST_FRAME_CLOSED")
			:AddEvent("EV_FRAME_SHOW", function(context, frame)
				context.frame = frame
				return "ST_FRAME_OPEN"
			end)
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_FRAME_OPEN")
			:SetOnEnter(function(context)
				UpdateFrame(context)
			end)
			:AddTransition("ST_BUSY")
			:AddTransition("ST_FRAME_CLOSED")
			:AddEvent("EV_BUTTON_CLICKED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_BUSY"))
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_BUSY")
			:SetOnEnter(function(context, operation)
				assert(not context.currentOperation)
				context.currentOperation = operation
				local groups = TSMAPI_FOUR.Util.AcquireTempTable()
				for _, groupPath in context.frame:GetElement("groupTree"):SelectedGroupsIterator() do
					tinsert(groups, groupPath)
				end
				if operation == "BUY" then
					TSM.Vendoring.Groups.BuyGroups(groups, private.FSMSellCallback)
				elseif operation == "SELL" then
					TSM.Vendoring.Groups.SellGroups(groups, private.FSMSellCallback)
				else
					error("Unexpected operation: "..tostring(operation))
				end
				TSMAPI_FOUR.Util.ReleaseTempTable(groups)
				UpdateFrame(context)
			end)
			:SetOnExit(function(context)
				context.currentOperation = nil
				TSM.Vendoring.Groups.StopBuySell()
			end)
			:AddTransition("ST_FRAME_OPEN")
			:AddTransition("ST_FRAME_CLOSED")
			:AddEvent("EV_SELL_DONE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_FRAME_OPEN"))
		)
		:AddDefaultEvent("EV_FRAME_HIDE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_FRAME_CLOSED"))
		:Init("ST_FRAME_CLOSED", fsmContext)
end

function private.FSMSellCallback()
	private.fsm:ProcessEvent("EV_SELL_DONE")
end
