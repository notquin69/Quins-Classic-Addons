-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local TaskListUI = TSM.UI:NewPackage("TaskListUI")
local L = TSM.L
local private = {
	frame = nil,
	categoryCollapsed = {},
	taskCollapsed = {},
	didAutoShow = false,
	updateCallbacks = {},
}
local BASE_STYLESHEET = TSM.UI.Util.Stylesheet()
	:SetStyleTable("Texture", "HORIZONTAL_LINE", {
		color = "#9d9d9d",
		height = 2,
	})
	:SetStyleTable("Text", "CATEGORY", {
		margin = { left = 2, right = 4 },
		autoWidth = true,
		font = TSM.UI.Fonts.MontserratBold,
		fontHeight = 16,
		textColor = "#79a2ff",
	})
	:SetStyleTable("Text", "TASK", {
		margin = { left = 2, right = 4 },
		font = TSM.UI.Fonts.FRIZQT,
		fontHeight = 16,
		textColor = "#ffd839",
	})
	:SetStyleTable("Text", "COUNT", {
		font = TSM.UI.Fonts.MontserratMedium,
		fontHeight = 14,
		textColor = "#ffffff",
	})
	:SetStyleTable("Text", "SUB_TASK", {
		height = 20,
		margin = { left = 38, right = 8, bottom = 2 },
		font = TSM.UI.Fonts.MontserratBold,
		fontHeight = 14,
		textColor = "#ffffff",
	})
	:SetStyleTable("Text", "SUB_TASK_WITH_HIDE", {
		margin = { left = 2 },
		font = TSM.UI.Fonts.MontserratBold,
		fontHeight = 14,
		textColor = "#ffffff",
	})
	:SetStyleTable("Frame", "SUB_TASK_WITH_HIDE", {
		height = 20,
		margin = { left = 18, right = 8, bottom = 2 },
	})
	:SetStyleTable("Button", "EXPANDER", {
		width = 18,
		height = 18,
	})
	:SetStyleTable("ActionButton", "TASK", {
		width = 80,
		height = 15,
		font = TSM.UI.Fonts.MontserratBold,
		fontHeight = 12,
	})
	:SetStyleTable("SecureMacroActionButton", "TASK", {
		width = 80,
		height = 15,
		font = TSM.UI.Fonts.MontserratBold,
		fontHeight = 12,
	})



-- ============================================================================
-- Module Functions
-- ============================================================================

function TaskListUI.OnInitialize()
	TSM.TaskList.SetUpdateCallback(private.OnTaskListUpdate)
	if not TSM.db.global.internalData.taskListUIFrameContext.isOpen then
		private.didAutoShow = true
	end
end

function TaskListUI.OnDisable()
	if private.frame then
		-- hide the frame
		private.frame:Hide()
		assert(not private.frame)
	end
end

function TaskListUI.Toggle()
	if private.frame then
		private.frame:Hide()
		assert(not private.frame)
	else
		if TSM.TaskList.GetNumTasks() == 0 then
			TSM:Print(L["Your task list is currently empty."])
			return
		end
		TSM.db.global.internalData.taskListUIFrameContext.isOpen = true
		private.frame = private.CreateMainFrame()
		private.frame:Show()
		private.frame:Draw()
	end
	for _, callback in ipairs(private.updateCallbacks) do
		callback()
	end
end

function TaskListUI.IsVisible()
	return private.frame and true or false
end

function TaskListUI.RegisterUpdateCallback(callback)
	tinsert(private.updateCallbacks, callback)
end



-- ============================================================================
-- Task List UI
-- ============================================================================

function private.CreateMainFrame()
	TSM.UI.AnalyticsRecordPathChange("task_list")
	local frame = TSMAPI_FOUR.UI.NewElement("OverlayApplicationFrame", "base")
		:SetParent(UIParent)
		:SetStylesheet(BASE_STYLESHEET)
		:SetStyle("width", 307)
		:SetStyle("strata", "HIGH")
		:SetContextTable(TSM.db.global.internalData.taskListUIFrameContext, TSM.db:GetDefaultReadOnly("global", "internalData", "taskListUIFrameContext"))
		:SetTitle(L["TSM TASK LIST"])
		:SetScript("OnHide", private.BaseFrameOnHide)
		:SetContentFrame(TSMAPI_FOUR.UI.NewElement("Frame", "content")
			:SetLayout("VERTICAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "hline", "HORIZONTAL_LINE"))
			:AddChildrenWithFunction(private.CreateTaskListElements)
		)
	frame:GetElement("closeBtn"):SetScript("OnClick", private.CloseBtnOnClick)
	return frame
end

function private.CreateTaskListElements(frame)
	-- get all the category counts
	local categoryCount = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, task in TSM.TaskList.Iterator() do
		local category = task:GetCategory()
		categoryCount[category] = (categoryCount[category] or 0) + 1
	end

	local currentCategoryFrame, currentTaskFrame = nil, nil
	local lastCategory = nil
	for _, task in TSM.TaskList.Iterator() do
		local category = task:GetCategory()
		local taskDesc = task:GetTaskDesc()
		local buttonEnabled, buttonText = task:GetButtonState()
		-- draw a category row if this is the first task for a category
		local isNewCategory = category ~= lastCategory
		if isNewCategory then
			private.CreateCategoryLine(frame, category, categoryCount[category])
			local categoryFrame = TSMAPI_FOUR.UI.NewElement("Frame", "categoryChildren_"..category)
				:SetLayout("VERTICAL")
			frame:AddChild(categoryFrame)
			if private.categoryCollapsed[category] then
				categoryFrame:Hide()
			else
				categoryFrame:Show()
			end
			currentCategoryFrame = categoryFrame
		end
		lastCategory = category

		private.CreateTaskHeaderLine(currentCategoryFrame, taskDesc, buttonText, buttonEnabled, task)
		if task:HasSubTasks() then
			local taskFrame = TSMAPI_FOUR.UI.NewElement("Frame", "taskChildren_"..taskDesc)
				:SetLayout("VERTICAL")
			currentCategoryFrame:AddChild(taskFrame)
			if private.taskCollapsed[taskDesc] then
				taskFrame:Hide()
			else
				taskFrame:Show()
			end
			currentTaskFrame = taskFrame
		else
			currentTaskFrame = nil
		end

		if task:HasSubTasks() then
			-- draw the subtask rows
			for index, subTaskDesc in task:SubTaskIterator() do
				private.CreateSubTaskLine(currentTaskFrame, subTaskDesc, task, index)
			end
		end
	end

	TSMAPI_FOUR.Util.ReleaseTempTable(categoryCount)
end

function private.CreateCategoryLine(frame, category, count)
	frame:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "category_"..category)
		:SetLayout("HORIZONTAL")
		:SetStyle("height", 28)
		:SetStyle("margin", { left = 4, right = 4, bottom = 2 })
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "expanderBtn", "EXPANDER")
			:SetStyle("backgroundTexturePack", private.categoryCollapsed[category] and "iconPack.18x18/Carot/Collapsed" or "iconPack.18x18/Carot/Expanded")
			:SetContext(category)
			:SetScript("OnClick", private.CategoryExpanderOnClick)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc", "CATEGORY")
			:SetText(category)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "count", "COUNT")
			:SetText(format("(%d)", count))
		)
	)
end

function private.CreateTaskHeaderLine(frame, taskText, buttonText, buttonEnabled, task)
	local button = TSMAPI_FOUR.UI.NewElement(task:IsSecureMacro() and "SecureMacroActionButton" or "ActionButton", "button", "TASK")
		:SetContext(task)
		:SetDisabled(not buttonEnabled)
		:SetText(buttonText)
	if task:IsSecureMacro() then
		button:SetMacroText(task:GetSecureMacroText())
	else
		button:SetScript("OnClick", private.OnTaskButtonClicked)
	end
	frame:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "task_"..taskText)
		:SetLayout("HORIZONTAL")
		:SetStyle("height", 26)
		:SetStyle("padding", { left = 18, right = 8 })
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "expanderBtn", "EXPANDER")
			:SetStyle("backgroundTexturePack", private.taskCollapsed[taskText] and "iconPack.18x18/Carot/Collapsed" or "iconPack.18x18/Carot/Expanded")
			:SetContext(taskText)
			:SetScript("OnClick", private.TaskExpanderOnClick)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc", "TASK")
			:SetText(taskText)
		)
		:AddChild(button)
	)
	if not task:HasSubTasks() then
		frame:GetElement("task_"..taskText..".expanderBtn"):Hide()
	end
end

function private.CreateSubTaskLine(frame, subTask, task, index)
	if task:CanHideSubTasks() then
		frame:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "subTask", "SUB_TASK_WITH_HIDE")
			:SetLayout("HORIZONTAL")
			:SetContext(task)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "hideBtn")
				:SetStyle("width", 18)
				:SetStyle("height", 18)
				:SetStyle("backgroundTexturePack", "iconPack.18x18/Hide")
				:SetContext(index)
				:SetScript("OnClick", private.HideBtnOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text", "SUB_TASK_WITH_HIDE")
				:SetText(subTask)
			)
		)
	else
		frame:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text", "SUB_TASK")
			:SetText(subTask)
		)
	end
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.BaseFrameOnHide(frame)
	assert(frame == private.frame)
	frame:Release()
	private.frame = nil
	TSM.UI.AnalyticsRecordClose("task_list")
end

function private.CloseBtnOnClick(button)
	TSM:Print(L["Hiding the TSM Task List UI. Type '/tsm tasklist' to reopen it."])
	TSM.db.global.internalData.taskListUIFrameContext.isOpen = false
	TaskListUI.Toggle()
end

function private.CategoryExpanderOnClick(button)
	local contentFrame = button:GetParentElement():GetParentElement()
	local category = button:GetContext()
	private.categoryCollapsed[category] = not private.categoryCollapsed[category]
	if private.categoryCollapsed[category] then
		button:SetStyle("backgroundTexturePack", "iconPack.18x18/Carot/Collapsed")
		contentFrame:GetElement("categoryChildren_"..category):Hide()
	else
		button:SetStyle("backgroundTexturePack", "iconPack.18x18/Carot/Expanded")
		contentFrame:GetElement("categoryChildren_"..category):Show()
	end
	contentFrame:GetBaseElement():Draw()
end

function private.TaskExpanderOnClick(button)
	local contentFrame = button:GetParentElement():GetParentElement()
	local taskText = button:GetContext()
	private.taskCollapsed[taskText] = not private.taskCollapsed[taskText]
	if private.taskCollapsed[taskText] then
		button:SetStyle("backgroundTexturePack", "iconPack.18x18/Carot/Collapsed")
		contentFrame:GetElement("taskChildren_"..taskText):Hide()
	else
		button:SetStyle("backgroundTexturePack", "iconPack.18x18/Carot/Expanded")
		contentFrame:GetElement("taskChildren_"..taskText):Show()
	end
	contentFrame:GetBaseElement():Draw()
end

function private.OnTaskButtonClicked(button)
	local task = button:GetContext()
	task:OnButtonClick()
end

function private.HideBtnOnClick(button)
	local task = button:GetParentElement():GetContext()
	task:HideSubTask(button:GetContext())
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.OnTaskListUpdate()
	if private.frame then
		local numTasks = TSM.TaskList.GetNumTasks()
		if numTasks == 0 then
			private.didAutoShow = false
			TaskListUI.Toggle()
			return
		end
		private.frame:SetTitle(L["TSM TASK LIST"].." ("..numTasks..")")
		local contentFrame = private.frame:GetElement("content")
		contentFrame:ReleaseAllChildren()
		contentFrame:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "hline", "HORIZONTAL_LINE"))
		contentFrame:AddChildrenWithFunction(private.CreateTaskListElements)
		contentFrame:GetParentElement():Draw()
	elseif not private.didAutoShow and TSM.TaskList.GetNumTasks() > 0 then
		TaskListUI.Toggle()
		private.didAutoShow = true
	end
end
