-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Operations = TSM.MainUI:NewPackage("Operations")
local L = TSM.L
local private = {
	moduleNames = {},
	moduleCallbacks = {},
	currentModule = nil,
	currentOperationName = nil,
	playerList = {},
	groupList = {},
	linkMenuEntries = {},
}
local HEADER_LINE_MARGIN = { top = 24, bottom = 16 }
local SETTING_LINE_MARGIN = { bottom = 16 }
local DEFAULT_DIVIDED_CONTAINER_CONTEXT = {
	leftWidth = 300,
}
-- TODO: this should eventually go in the saved variables
private.dividedContainerContext = {}
local DEFAULT_OPERATION_TREE_CONTEXT = {
}
-- TODO: this should eventually go in the saved variables
private.operationTreeContext = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Operations.OnInitialize()
	TSM.MainUI.RegisterTopLevelPage(L["Operations"], "iconPack.24x24/Operations", private.GetOperationsFrame)
end

function Operations.RegisterModule(name, callback)
	tinsert(private.moduleNames, name)
	private.moduleCallbacks[name] = callback
end

function Operations.ShowOperationSettings(baseFrame, moduleName, operationName)
	baseFrame:SetSelectedNavButton(L["Operations"], true)
	baseFrame:GetElement("content.operations.selection.operationTree"):SetSelectedOperation(moduleName, operationName)
end

function Operations.GetOperationManagementElements()
	local operation = TSM.Operations.GetSettings(private.currentModule, private.currentOperationName)
	wipe(private.playerList)
	for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
		for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
			tinsert(private.playerList, character.." - "..factionrealm)
		end
	end
	-- TODO: make the group dropdown more usable (i.e. not raw group paths)
	wipe(private.groupList)
	for _, groupPath in TSM.Groups.GroupIterator() do
		tinsert(private.groupList, groupPath)
	end
	return TSMAPI_FOUR.UI.NewElement("Frame", "management")
		:SetLayout("VERTICAL")
		:AddChild(Operations.CreateHeadingLine("managementOptions", L["Management Options"]))
		:AddChild(Operations.CreateSettingLine("ignoreFactionRealms", L["Ignore operation on faction-realms:"])
			:AddChild(TSMAPI_FOUR.UI.NewElement("MultiselectionDropdown", "ignoreFactionRealmDropdown")
				:SetHintText(L["None"])
				:SetItems(TSM.db:GetScopeKeys("factionrealm"), TSM.db:GetScopeKeys("factionrealm"))
				:SetSettingInfo(operation, "ignoreFactionrealm")
			)
		)
		:AddChild(Operations.CreateSettingLine("ignoreCharacters", L["Ignore operation on characters:"])
			:AddChild(TSMAPI_FOUR.UI.NewElement("MultiselectionDropdown", "ignoreCharacterDropdown")
				:SetHintText(L["None"])
				:SetItems(private.playerList, private.playerList)
				:SetSettingInfo(operation, "ignorePlayer")
			)
		)
		:AddChild(Operations.CreateHeadingLine("groupManagement", L["Group Management"]))
		:AddChild(Operations.CreateSettingLine("applyNewGroup", L["Apply operation to group:"])
			:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "dropdown")
				:SetHintText(L["Select operation"])
				:SetItems(private.groupList)
				:SetScript("OnSelectionChanged", private.ApplyNewOnSelectionChanged)
			)
		)
		:AddChildrenWithFunction(private.AddOperationGroups)
end

function Operations.CreateHeadingLine(id, text)
	return TSMAPI_FOUR.UI.NewElement("Frame", id)
		:SetLayout("HORIZONTAL")
		:SetStyle("height", 19)
		:SetStyle("margin", HEADER_LINE_MARGIN)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
			:SetStyle("textColor", "#ffffff")
			:SetStyle("font", TSM.UI.Fonts.MontserratBold)
			:SetStyle("fontHeight", 16)
			:SetText(text)
		)
end

function Operations.CreateLinkedSettingLine(settingKey, labelText, disabled)
	local relationshipSet = TSM.Operations.HasRelationship(private.currentModule, private.currentOperationName, settingKey)
	return TSMAPI_FOUR.UI.NewElement("Frame", settingKey)
		:SetLayout("HORIZONTAL")
		:SetStyle("height", 26)
		:SetStyle("margin", SETTING_LINE_MARGIN)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "left")
			-- move the right in 22px (size + margin of link button) so this frame gets half the total width
			:SetStyle("margin", { right = -22 })
			:SetLayout("HORIZONTAL")
			:AddChild(private.CreateLinkButton(disabled, settingKey))
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", (relationshipSet or disabled) and "#424242" or "#e2e2e2")
				:SetText(labelText)
			)
		)
end

function Operations.CreateSettingLine(id, labelText, disabled)
	return TSMAPI_FOUR.UI.NewElement("Frame", id)
		:SetLayout("HORIZONTAL")
		:SetStyle("height", 26)
		:SetStyle("margin", SETTING_LINE_MARGIN)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", disabled and "#424242" or "#e2e2e2")
			:SetText(labelText)
		)
end

function Operations.CheckCustomPrice(value, ignoreError)
	if TSMAPI_FOUR.CustomPrice.Validate(value) then
		return true
	else
		-- TODO: better error message
		if not ignoreError then
			TSM:Print("Your custom price was incorrect. Please try again.")
		end
		return false
	end
end



-- ============================================================================
-- Operations UI
-- ============================================================================

function private.GetOperationsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "operations")
	local frame = TSMAPI_FOUR.UI.NewElement("DividedContainer", "operations")
		:SetStyle("background", "#272727")
		:SetContextTable(private.dividedContainerContext, DEFAULT_DIVIDED_CONTAINER_CONTEXT)
		:SetMinWidth(250, 250)
		:SetLeftChild(TSMAPI_FOUR.UI.NewElement("Frame", "selection")
			:SetLayout("VERTICAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("SearchInput", "search")
				:SetStyle("height", 20)
				:SetStyle("margin", { left = 12, right = 12, top = 35, bottom = 12 })
				:SetHintText(L["Search Operations"])
				:SetScript("OnTextChanged", private.OperationSearchOnTextChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", 2)
				:SetStyle("color", "#9d9d9d")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("OperationTree", "operationTree")
				:SetContextTable(private.operationTreeContext, DEFAULT_OPERATION_TREE_CONTEXT)
				:SetScript("OnOperationAdded", private.OperationTreeOnOperationAdded)
				:SetScript("OnOperationDeleted", private.OperationTreeOnOperationConfirmDelete)
				:SetScript("OnOperationSelected", private.OperationTreeOnOperationSelected)
			)
		)
		:SetRightChild(TSMAPI_FOUR.UI.NewElement("Frame", "settings")
			:SetLayout("VERTICAL")
			:SetStyle("padding", { top = 37 })
			:SetStyle("background", "#272727")
			:SetStyle("expandWidth", true)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "title")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 32)
				:SetStyle("expandWidth", true)
				:SetStyle("margin", { left = 16, right = 16 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("EditableText", "text")
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 24)
					:SetStyle("autoWidth", true)
					:SetText(L["No Operation Selected"])
					:SetScript("OnValueChanged", private.TitleOnValueChanged)
					:SetScript("OnEditingChanged", private.TitleOnEditingChanged)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "editBtn")
					:SetStyle("width", 18)
					:SetStyle("height", 18)
					:SetStyle("backgroundTexturePack", "iconPack.18x18/Edit")
					:SetScript("OnClick", private.EditBtnOnClick)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer")
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "moreBtn")
					:SetStyle("width", 18)
					:SetStyle("height", 18)
					:SetStyle("backgroundTexturePack", "iconPack.18x18/More")
					:SetStyle("margin", { right = 8 })
					:SetScript("OnClick", private.OperationMoreBtnOnClick)

				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "content")
				:SetLayout("VERTICAL")
				-- will be filled in by the operation selection callback
			)
		)
	frame:GetElement("settings.title.editBtn"):Hide()
	frame:GetElement("settings.title.moreBtn"):Hide()
	return frame
end

local function OperationMoreDialogRowIterator(_, prevIndex)
	if prevIndex == nil then
		return 1, L["Reset All"], private.OperationSettingsOnOperationConfirmReset
	end
end

function private.OperationMoreBtnOnClick(button)
	button:GetBaseElement():ShowMoreButtonDialog(button, OperationMoreDialogRowIterator)
end

function private.OperationResetAllBtnOnClick(baseFrame)
	TSM.Operations.Reset(private.currentModule, private.currentOperationName)
	local settingsFrame = baseFrame:GetElement("content.operations.settings")
	local contentFrame = settingsFrame:GetElement("content")
	--Clear down settings page
	contentFrame:ReleaseAllChildren()
	-- Add the updated values to the page
	TSM.Operations.Update(private.currentModule, private.currentOperationName)
	contentFrame:AddChild(private.moduleCallbacks[private.currentModule](private.currentOperationName))
	settingsFrame:Draw()
end

function private.AddOperationGroups(frame)
	-- need to filter out the groups without operations
	for _, groupPath in TSM.Groups.GroupIterator() do
		if TSM.Groups.HasOperationOverride(groupPath, private.currentModule) then
			local hasCurrentOperation = false
			for _, operationName in TSM.Operations.GroupOperationIterator(private.currentModule, groupPath) do
				if operationName == private.currentOperationName then
					hasCurrentOperation = true
				end
			end
			if hasCurrentOperation then
				frame:AddChild(private.CreateGroupOperationLine(groupPath))
			end
		end
	end
end

function private.CreateGroupOperationLine(groupPath)
	local groupName = groupPath == TSM.CONST.ROOT_GROUP_PATH and L["Base Group"] or TSM.Groups.Path.GetName(groupPath)
	local level = select('#', strsplit(TSM.CONST.GROUP_SEP, groupPath))
	return TSMAPI_FOUR.UI.NewElement("Frame", "group")
		:SetLayout("HORIZONTAL")
		:SetStyle("height", 20)
		:SetStyle("margin", { bottom = 8, right = 12 })
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
			:SetStyle("autoWidth", true)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", TSM.UI.GetGroupLevelColor(level))
			:SetText(groupName)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "viewBtn")
			:SetStyle("width", 14)
			:SetStyle("height", 14)
			:SetStyle("margin", { left = 2, right = 2 })
			:SetStyle("backgroundTexturePack", "iconPack.14x14/Groups")
			:SetContext(groupPath)
			:SetScript("OnClick", private.ViewGroupOnClick)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "removeBtn")
			:SetStyle("width", 14)
			:SetStyle("height", 14)
			:SetStyle("backgroundTexturePack", "iconPack.14x14/Close/Default")
			:SetContext(groupPath)
			:SetScript("OnClick", private.RemoveOperationGroupOnClick)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
end

function private.CreateLinkButton(disabled, settingKey)
	local vertexColor = nil
	local relationshipSet = TSM.Operations.HasRelationship(private.currentModule, private.currentOperationName, settingKey)
	if disabled and relationshipSet then
		vertexColor = "#6f5819"
	elseif disabled then
		vertexColor = "#424242"
	elseif relationshipSet then
		vertexColor = "#ffd839"
	else
		vertexColor = "#ffffff"
	end
	return TSMAPI_FOUR.UI.NewElement("Button", "linkBtn")
		:SetStyle("width", 18)
		:SetStyle("height", 18)
		:SetStyle("margin", { right = 4 })
		:SetStyle("backgroundTexturePack", "iconPack.18x18/Link")
		:SetStyle("backgroundVertexColor", vertexColor)
		:SetDisabled(disabled)
		:SetContext(settingKey)
		:SetScript("OnClick", private.LinkBtnOnClick)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.OperationSearchOnTextChanged(input)
	local filter = strlower(strtrim(input:GetText()))
	input:GetElement("__parent.operationTree"):SetOperationNameFilter(filter)
end

function private.OperationTreeOnOperationAdded(_, moduleName, operationName, copyOperationName)
	TSM.Operations.Create(moduleName, operationName)
	if copyOperationName then
		TSM.Operations.Copy(moduleName, operationName, copyOperationName)
	end
end

function private.OperationTreeOnOperationConfirmDelete(self, moduleName, operationName)
	self:GetBaseElement():ShowConfirmationDialog(L["Are you sure you want to delete this operation?"], nil, strupper(DELETE), private.OperationTreeOnOperationDeleted, self, moduleName, operationName)
end

function private.OperationSettingsOnOperationConfirmReset(self)
	local baseFrame = self:GetBaseElement()
	-- Close the dropdown dialog
	baseFrame:HideDialog()
	baseFrame:GetBaseElement():ShowConfirmationDialog(L["Are you sure you want to reset all operation settings?"], nil, L["RESET"], private.OperationResetAllBtnOnClick, baseFrame)
end

function private.OperationTreeOnOperationDeleted(self, moduleName, operationName)
	TSM.Operations.Delete(moduleName, operationName)
	local operationTree = self:GetElement("__parent.operationTree")
	operationTree:Draw()
end

function private.OperationTreeOnOperationSelected(self, moduleName, operationName)
	private.currentModule = moduleName
	private.currentOperationName = operationName

	local settingsFrame = self:GetElement("__parent.__parent.settings")
	local contentFrame = settingsFrame:GetElement("content")
	contentFrame:ReleaseAllChildren()
	local titleFrame = settingsFrame:GetElement("title")
	if moduleName and operationName then
		TSM.Operations.Update(moduleName, operationName)
		titleFrame:GetElement("text"):SetText(operationName)
		titleFrame:GetElement("editBtn"):Show()
		titleFrame:GetElement("moreBtn"):Show()
		contentFrame:AddChild(private.moduleCallbacks[moduleName](operationName))
	else
		TSM.UI.AnalyticsRecordPathChange("main", "operations", "none")
		titleFrame:GetElement("text"):SetText(L["No Operation Selected"])
		titleFrame:GetElement("editBtn"):Hide()
		titleFrame:GetElement("moreBtn"):Hide()
	end
	settingsFrame:Draw()
end

function private.TitleOnValueChanged(text, newValue)
	newValue = strtrim(newValue)
	if newValue == private.currentOperationName then
		-- didn't change
		text:Draw()
	elseif newValue == "" then
		TSM:Print(L["Invalid operation name."])
		text:Draw()
	elseif TSM.Operations.Exists(private.currentModule, newValue) then
		TSM:Print(L["Group already exists."])
		text:Draw()
	else
		TSM.Operations.Rename(private.currentModule, private.currentOperationName, newValue)
		text:GetElement("__parent.__parent.__parent.selection.operationTree")
			:SetSelectedOperation(private.currentModule, newValue)
			:Draw()
	end
end

function private.TitleOnEditingChanged(text, editing)
	if editing then
		text:GetElement("__parent.editBtn"):Hide()
	else
		text:GetElement("__parent.editBtn"):Show()
	end
end

function private.EditBtnOnClick(button)
	assert(private.currentModule and private.currentOperationName)
	button:GetElement("__parent.text"):SetEditing(true)
end

function private.ApplyNewOnSelectionChanged(dropdown, groupPath)
	local hasOperation = false
	for _, operationName in TSM.Operations.GroupOperationIterator(private.currentModule, groupPath) do
		if operationName == private.currentOperationName then
			hasOperation = true
			break
		end
	end
	local parentElement = dropdown:GetParentElement():GetParentElement()
	if not hasOperation then
		TSM.Groups.SetOperationOverride(groupPath, private.currentModule, true)
		local numOperations = 0
		local lastOperationName = nil
		for _, operationName in TSM.Groups.OperationIterator(groupPath, private.currentModule) do
			lastOperationName = operationName
			numOperations = numOperations + 1
		end
		if numOperations == TSM.Operations.GetMaxNumber(private.currentModule) then
			-- replace the last operation since we're already at the max number of operations
			TSM.Groups.RemoveOperation(groupPath, private.currentModule, numOperations)
			TSM:Printf(L["%s previously had the max number of operations, so removed %s."], TSM.Groups.Path.Format(groupPath, true), "|cff99ffff"..lastOperationName.."|r")
		end
		TSM.Groups.AppendOperation(groupPath, private.currentModule, private.currentOperationName)
		TSM:Printf(L["Added %s to %s."], "|cff99ffff"..private.currentOperationName.."|r", TSM.Groups.Path.Format(groupPath, true))
		parentElement:AddChild(private.CreateGroupOperationLine(groupPath))
	end

	dropdown:SetSelection(nil)
	parentElement:Draw()
end

function private.ViewGroupOnClick(button)
	local baseFrame = button:GetBaseElement()
	TSM.MainUI.Groups.ShowGroupSettings(baseFrame, button:GetContext())
end

function private.RemoveOperationGroupOnClick(self)
	local groupPath = self:GetContext()
	TSM.Groups.RemoveOperationByName(groupPath, private.currentModule, private.currentOperationName)

	-- remove the line for this group
	local removeElement = self:GetParentElement()
	local removeElementParent = removeElement:GetParentElement()
	removeElementParent:RemoveChild(removeElement)
	removeElement:Release()
	removeElementParent:GetParentElement():Draw()
end

function private.LinkBtnOnClick(button)
	local settingKey = button:GetContext()
	wipe(private.linkMenuEntries)
	for _, operationName in TSM.Operations.OperationIterator(private.currentModule) do
		if operationName ~= private.currentOperationName and not TSM.Operations.IsCircularRelationship(private.currentModule, private.currentOperationName, settingKey) then
			tinsert(private.linkMenuEntries, operationName)
		end
	end
	sort(private.linkMenuEntries)
	button:GetBaseElement():ShowDialogFrame(TSMAPI_FOUR.UI.NewElement("MenuDialogFrame", "linkDialog")
		:SetLayout("VERTICAL")
		:SetStyle("width", 263)
		:SetStyle("height", 243)
		:SetStyle("anchors", { { "TOPRIGHT", button:_GetBaseFrame(), "BOTTOM", 22, -16 } })
		:SetStyle("background", "#2e2e2e")
		:SetStyle("borderInset", 8)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "titleFrame")
			:SetLayout("VERTICAL")
			:SetStyle("height", 37)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "title")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetStyle("justifyH", "CENTER")
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Link to Another Operation"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
			:SetStyle("height", 2)
			:SetStyle("color", "#e2e2e2")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionList", "list")
			:SetContext(settingKey)
			:SetStyle("margin", { left = 2, right = 2, bottom = 3 })
			:SetStyle("rowHeight", 20)
			:SetEntries(private.linkMenuEntries, TSM.Operations.GetRelationship(private.currentModule, private.currentOperationName, settingKey))
			:SetScript("OnEntrySelected", private.ListOnEntrySelected)
		)
	)
end

function private.ListOnEntrySelected(list, operationName)
	local settingKey = list:GetContext()
	local previousValue = TSM.Operations.GetRelationship(private.currentModule, private.currentOperationName, settingKey)
	if operationName == previousValue then
		TSM.Operations.SetRelationship(private.currentModule, private.currentOperationName, settingKey, nil)
	else
		TSM.Operations.SetRelationship(private.currentModule, private.currentOperationName, settingKey, operationName)
	end

	local baseFrame = list:GetBaseElement()
	baseFrame:HideDialog()
	Operations.ShowOperationSettings(baseFrame, private.currentModule, private.currentOperationName)
end
