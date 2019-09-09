-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Groups = TSM.UI.MailingUI:NewPackage("Groups")
local L = TSM.L
local private = {
	filterText = "",
	fsm = nil
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Groups.OnInitialize()
	private.FSMCreate()
	TSM.UI.MailingUI.RegisterTopLevelPage(L["Groups"], "iconPack.24x24/Groups", private.GetGroupsFrame)
end



-- ============================================================================
-- Groups UI
-- ============================================================================

function private.GetGroupsFrame()
	TSM.UI.AnalyticsRecordPathChange("mailing", "groups")
	return TSMAPI_FOUR.UI.NewElement("Frame", "groups")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "container")
			:SetLayout("VERTICAL")
			:SetStyle("background", "#272727")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "groupsText")
				:SetStyle("height", 15)
				:SetStyle("margin", { top = 33, left = 10, right = 10, bottom = 8 })
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 12)
				:SetFormattedText(L["%d |4Group:Groups; Selected (%d |4Item:Items;)"], 0, 0)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "search")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 20)
				:SetStyle("margin", { left = 10, right = 8, bottom = 12 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("SearchInput", "input")
					:SetHintText(L["Search Groups"])
					:SetText(private.filterText)
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
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
			:SetStyle("height", 4)
			:SetStyle("color", "#3a3a3a")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("ApplicationGroupTree", "groupTree")
			:SetGroupListFunc(private.GroupTreeGetList)
			:SetSearchString(private.filterText)
			:SetContextTable(TSM.db.profile.internalData.mailingGroupTreeContext)
			:SetStyle("altBackground", "#060606")
			:SetScript("OnGroupSelectionChanged", private.GroupTreeOnGroupSelectionChanged)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "mailGroupBtn")
			:SetStyle("height", 26)
			:SetStyle("margin.top", 8)
			:SetText(L["MAIL SELECTED GROUPS"])
			:SetScript("OnClick", private.MailBtnOnClick)
		)
		:SetScript("OnUpdate", private.FrameOnUpdate)
		:SetScript("OnHide", private.FrameOnHide)
end

function private.GroupTreeGetList(groups, headerNameLookup)
	TSM.UI.ApplicationGroupTreeGetGroupList(groups, headerNameLookup, "Mailing")
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FrameOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)
	frame:GetBaseElement():SetBottomPadding(34)

	private.GroupTreeOnGroupSelectionChanged(frame:GetElement("groupTree"))

	private.fsm:ProcessEvent("EV_FRAME_SHOW", frame)
end

function private.FrameOnHide(frame)
	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function private.GroupSearchOnTextChanged(input)
	local text = strlower(strtrim(input:GetText()))
	if text == private.filterText then
		return
	end
	private.filterText = text

	input:GetElement("__parent.__parent.__parent.groupTree")
		:SetSearchString(private.filterText)
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
	baseFrame:GetElement("content.groups.groupTree"):SelectAll()
	baseFrame:HideDialog()
end

function private.DeselectAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.groups.groupTree"):DeselectAll()
	baseFrame:HideDialog()
end

function private.ExpandAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.groups.groupTree"):ExpandAll()
	baseFrame:HideDialog()
end

function private.CollapseAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.groups.groupTree"):CollapseAll()
	baseFrame:HideDialog()
end

function private.GroupTreeOnGroupSelectionChanged(groupTree)
	groupTree:GetElement("__parent.mailGroupBtn")
		:SetDisabled(groupTree:IsSelectionCleared())
		:Draw()

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
	groupTree:GetElement("__parent.container.groupsText")
		:SetFormattedText(L["%d |4Group:Groups; Selected (%d |4Item:Items;)"], numGroups, numItems)
		:Draw()
end

function private.MailBtnOnClick(button)
	private.fsm:ProcessEvent("EV_BUTTON_CLICKED", IsShiftKeyDown())
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.FSMCreate()
	local fsmContext = {
		frame = nil,
		sending = false
	}

	local function UpdateButton(context)
		context.frame:GetElement("mailGroupBtn")
			:SetText(context.sending and L["SENDING..."] or L["MAIL SELECTED GROUPS"])
			:SetPressed(context.sending)
			:Draw()
	end

	private.fsm = TSMAPI_FOUR.FSM.New("MAILING_GROUPS")
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_HIDDEN")
			:SetOnEnter(function(context)
				TSM.Mailing.Send.KillThread()
				TSM.Mailing.Groups.KillThread()
				context.frame = nil
			end)
			:AddTransition("ST_SHOWN")
			:AddTransition("ST_HIDDEN")
			:AddEvent("EV_FRAME_SHOW", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_SHOWN"))
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_SHOWN")
			:SetOnEnter(function(context, frame)
				if not context.frame then
					context.frame = frame
				end
				UpdateButton(context)
			end)
			:AddTransition("ST_HIDDEN")
			:AddTransition("ST_SENDING_START")
			:AddEvent("EV_BUTTON_CLICKED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_SENDING_START"))
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_SENDING_START")
			:SetOnEnter(function(context, sendRepeat)
				context.sending = true
				local groups = {}
				for _, groupPath in context.frame:GetElement("groupTree"):SelectedGroupsIterator() do
					tinsert(groups, groupPath)
				end
				TSM.Mailing.Groups.StartSending(private.FSMGroupsCallback, groups, sendRepeat)
				UpdateButton(context)
			end)
			:SetOnExit(function(context)
				context.sending = false
			end)
			:AddTransition("ST_SHOWN")
			:AddTransition("ST_HIDDEN")
			:AddEvent("EV_SENDING_DONE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_SHOWN"))
		)
		:AddDefaultEvent("EV_FRAME_HIDE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_HIDDEN"))
		:Init("ST_HIDDEN", fsmContext)
end

function private.FSMGroupsCallback()
	private.fsm:ProcessEvent("EV_SENDING_DONE")
end
