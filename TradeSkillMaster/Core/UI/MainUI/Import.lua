-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Import = TSM.MainUI:NewPackage("ImportExport")
local L = TSM.L
local private = {
	groupSearch = "",
	importText = "",
	newImport = nil,
	importRootPath = TSM.CONST.ROOT_GROUP_PATH,
	importOptions = {
		moveGroupedItems = true,
		includeOperations = true,
		replaceDuplicateOperations = true,
		skipConfirmation = false,
	},
}
-- TODO: this should eventually go in the saved variables
private.dividedContainerContext = {}
local DEFAULT_DIVIDED_CONTAINER_CONTEXT = {
	leftWidth = 300,
}
local SETTING_LINE_MARGIN = {
	bottom = 16
}
local VALID_OUTER_VIEW_STATES = {
	["import"] = true,
	["exportSelection"] = true,
	["exportResult"] = true
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Import.OnInitialize()
	TSM.MainUI.RegisterTopLevelPage("Import/Export", "iconPack.24x24/Import", private.GetOuterFrame)
end



-- ============================================================================
-- Import UI
-- ============================================================================

function private.ImportGroupSelectionChangedHandler(element, groupPath)
	private.importRootPath = groupPath
end

function private.CreateImportOptionToggle(name, labelText, optionTable)
	return TSMAPI_FOUR.UI.NewElement("Frame", name)
		:SetLayout("HORIZONTAL")
		:SetStyle("height", 26)
		:SetStyle("margin", SETTING_LINE_MARGIN)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "left")
			:SetLayout("HORIZONTAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#e2e2e2")
				:SetText(labelText)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", name.."Frame")
			:SetLayout("HORIZONTAL")
			-- move the right by the width of the toggle so this frame gets half the total width
			:SetStyle("margin.right", -TSM.UI.TexturePacks.GetWidth("uiFrames.ToggleOn"))
			:AddChild(TSMAPI_FOUR.UI.NewElement("ToggleOnOff", "toggle")
				:SetSettingInfo(optionTable, name)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
		)
end

function private.GetOuterFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "import_export")
	return TSMAPI_FOUR.UI.NewElement("ViewContainer", "ImportExportOuterViewContainer")
		:SetNavCallback(private.GetImportExportOuterViewContainerCallback)
		:AddPath("import", true)
		:AddPath("importConfirmation")
		:AddPath("exportSelection")
		:AddPath("exportResult")
end

function private.GetImportExportOuterViewContainerCallback(self, path)
	if path == "importConfirmation" then
		return private.GetImporterConfirmationFrame()
	elseif VALID_OUTER_VIEW_STATES[path] then
		return private.GetImportExportFrame()
	else
		error("Unexpected path for ImportExportOuterViewContainer: " .. path)
	end
end

function private.GetImportExportFrame()
	local frame = TSMAPI_FOUR.UI.NewElement("DividedContainer", "groups")
		:SetStyle("background", "#272727")
		:SetContextTable(private.dividedContainerContext, DEFAULT_DIVIDED_CONTAINER_CONTEXT)
		:SetMinWidth(250, 250)
		:SetLeftChild(TSMAPI_FOUR.UI.NewElement("ViewContainer", "ImportExportLeftPane")
			:SetNavCallback(private.GetImportExportLeftPaneCallback)
			:AddPath("leftPaneImportSelection", true)
			:AddPath("leftPaneExportSelection")
		)
		:SetRightChild(TSMAPI_FOUR.UI.NewElement("Frame", "content")
			:SetLayout("VERTICAL")
			:SetStyle("padding", { top = 30 })
			:SetStyle("background", "#272727")
			:AddChild(TSMAPI_FOUR.UI.NewElement("TabGroup", "buttons")
				:SetStyle("margin", { top = 16 })
				:SetNavCallback(private.GetImportExportRightPaneCallback)
				:AddPath(L["Import"], true)
				:AddPath(L["Export"])
			)
		)
	return frame
end

function private.GetImportExportLeftPaneCallback(self, path)
	if path == "leftPaneImportSelection" then
		return private.GetImportExportLeftPaneImportSelection()
	elseif path == "leftPaneExportSelection" then
		return private.GetImportExportLeftPaneExportSelection()
	else
		error("Unknown path for GetImportExportLeftPaneCallback: " .. path)
	end
end

function private.GetImportExportLeftPaneImportSelection(self)
	return TSMAPI_FOUR.UI.NewElement("Frame", "groupSelection")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "search")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:SetStyle("margin", { left = 12, right = 12, top = 35, bottom = 12 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("SearchInput", "input")
				:SetStyle("height", 20)
				:SetText(private.groupSearch)
				:SetHintText(L["Search Groups"])
				:SetScript("OnTextChanged", private.GroupSearchOnTextChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "moreBtn")
				:SetStyle("width", 18)
				:SetStyle("height", 18)
				:SetStyle("margin.left", 8)
				:SetStyle("backgroundTexturePack", "iconPack.18x18/More")
				:SetScript("OnClick", private.ImportMoreBtnOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
			:SetStyle("height", 2)
			:SetStyle("color", "#9d9d9d")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionGroupTree", "groupTree")
			:SetGroupListFunc(private.GroupTreeGetList)
			:SetContextTable(TSM.db.profile.internalData.importGroupTreeContext)
			:SetStyle("background", "#131313")
			:SetScript("OnGroupSelectionChanged", private.ImportGroupSelectionChangedHandler)
		)
end

function private.GetImportExportLeftPaneExportSelection(self)
	return TSMAPI_FOUR.UI.NewElement("Frame", "groupSelection")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "search")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:SetStyle("margin", { left = 12, right = 12, top = 35, bottom = 12 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("SearchInput", "input")
				:SetStyle("height", 20)
				:SetText(private.groupSearch)
				:SetHintText(L["Search Groups"])
				:SetScript("OnTextChanged", private.GroupSearchOnTextChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "moreBtn")
				:SetStyle("width", 18)
				:SetStyle("height", 18)
				:SetStyle("margin.left", 8)
				:SetStyle("backgroundTexturePack", "iconPack.18x18/More")
				:SetScript("OnClick", private.ExportMoreBtnOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
			:SetStyle("height", 2)
			:SetStyle("color", "#9d9d9d")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("ApplicationGroupTree", "groupTree")
			:SetGroupListFunc(private.GroupTreeGetList)
			:SetContextTable(TSM.db.profile.internalData.exportGroupTreeContext)
			:SetStyle("background", "#131313")
			:SetScript("OnGroupSelectionChanged", private.ExportGroupsSelectionChanged)
		)
end

function private.GetImportExportRightPaneCallback(self, button)
	if button == L["Import"] then
		-- at initial draw time parent won't exist, so we can't tell it to be the import left pane
		local parent = self:GetParentElement()
		if parent then
			parent:GetElement("__parent.ImportExportLeftPane")
				:SetPath("leftPaneImportSelection", true)
		end
		return private.GetImportEntryFrame()
	elseif button == L["Export"] then
		private.exporter = TSMAPI_FOUR.Exporter.New()

		local leftPane = self:GetElement("__parent.__parent.ImportExportLeftPane")
		leftPane:SetPath("leftPaneExportSelection", true)
		return TSMAPI_FOUR.UI.NewElement("ViewContainer", "ExportRightPane")
			:SetNavCallback(private.ExportRightPaneCallback)
			:AddPath("selectedGroups", true)
			:AddPath("exportOutput")
	else
		error("Unknown path for GetImportExportRightPane: " .. button)
	end
end

function private.ExportRightPaneCallback(self, path)
	if path == "selectedGroups" then
		return private.GetExporterGroupsFrameSelectedGroups()
	elseif path == "exportOutput" then
		return private.GetExporterGroupsFrameExportOutput()
	else
		error("Unexpected path for ExportRightFrameCallback: " .. path)
	end
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

local function ImportMoreDialogRowIterator(_, prevIndex)
	if prevIndex == nil then
		return 1, L["Expand All Groups"], private.ExportExpandAllBtnOnClick
	elseif prevIndex == 1 then
		return 2, L["Collapse All Groups"], private.ExportCollapseAllBtnOnClick
	end
end

function private.ImportMoreBtnOnClick(button)
	button:GetBaseElement():ShowMoreButtonDialog(button, ImportMoreDialogRowIterator)
end

function private.ImportExpandAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.ImportExportOuterViewContainer.groups.ImportExportLeftPane.groupSelection.groupTree"):ExpandAll()
	baseFrame:HideDialog()
end

function private.ImportCollapseAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.ImportExportOuterViewContainer.groups.ImportExportLeftPane.groupSelection.groupTree"):CollapseAll()
	baseFrame:HideDialog()
end

local function ExportMoreDialogRowIterator(_, prevIndex)
	if prevIndex == nil then
		return 1, L["Select All Groups"], private.ExportSelectAllBtnOnClick
	elseif prevIndex == 1 then
		return 2, L["Deselect All Groups"], private.ExportDeselectAllBtnOnClick
	elseif prevIndex == 2 then
		return 3, L["Expand All Groups"], private.ExportExpandAllBtnOnClick
	elseif prevIndex == 3 then
		return 4, L["Collapse All Groups"], private.ExportCollapseAllBtnOnClick
	end
end

function private.ExportMoreBtnOnClick(button)
	button:GetBaseElement():ShowMoreButtonDialog(button, ExportMoreDialogRowIterator)
end

function private.ExportSelectAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.ImportExportOuterViewContainer.groups.ImportExportLeftPane.groupSelection.groupTree"):SelectAll()
	baseFrame:HideDialog()
end

function private.ExportDeselectAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.ImportExportOuterViewContainer.groups.ImportExportLeftPane.groupSelection.groupTree"):DeselectAll()
	baseFrame:HideDialog()
end

function private.ExportExpandAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.ImportExportOuterViewContainer.groups.ImportExportLeftPane.groupSelection.groupTree"):ExpandAll()
	baseFrame:HideDialog()
end

function private.ExportCollapseAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.ImportExportOuterViewContainer.groups.ImportExportLeftPane.groupSelection.groupTree"):CollapseAll()
	baseFrame:HideDialog()
end

function private.GroupTreeGetList(groups, headerNameLookup)
	if strmatch(strlower(L["Base Group"]), TSMAPI_FOUR.Util.StrEscape(private.groupSearch)) then
		tinsert(groups, TSM.CONST.ROOT_GROUP_PATH)
		headerNameLookup[TSM.CONST.ROOT_GROUP_PATH] = L["Base Group"]
	end

	for _, path in TSM.Groups.GroupIterator() do
		if strmatch(strlower(TSM.Groups.Path.GetName(path)), TSMAPI_FOUR.Util.StrEscape(private.groupSearch)) then
			tinsert(groups, path)
		end
	end
end

function private.GetImportEntryFrame()
	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "importContent")
		:SetStyle("padding", 16)
		:SetStyle("background", "#ff1e1e1e")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "instructions")
			:SetStyle("height", 54)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 14)
			:SetStyle("fontSpacing", 2)
			:SetStyle("textColor", "#ffe2e2e2")
			:SetStyle("margin", { bottom = 44 })
			:SetText(L["Paste your import string in the field below and then press 'IMPORT'. You can import everything from item lists (comma delineated please) to whole group & operation structures."])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
			:SetStyle("height", 19)
			:SetStyle("fontHeight", 16)
			:SetStyle("font", TSM.UI.Fonts.MontserratBold)
			:SetStyle("textColor", "#ffffffff")
			:SetStyle("margin.bottom", 8)
			:SetText(L["Import Groups & Operations"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("BorderedFrame", "import")
			:SetLayout("HORIZONTAL")
			:SetStyle("borderTheme", "roundLight")
			:SetStyle("margin.bottom", 16)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ScrollFrame", "scroll")
				:SetStyle("height", 175)
				:SetStyle("margin.bottom", 2)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
					:SetStyle("height", 173)
					:SetStyle("margin", { left = 2, right = 8 })
					:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
					:SetStyle("fontHeight", 14)
					:SetStyle("justifyH", "LEFT")
					:SetStyle("hintTextColor", "#ffe2e2e2")
					:SetStyle("hintJustifyH", "LEFT")
					:SetHintText(L["Paste string here"])
					:SetSpacing(6)
					:SetMultiLine(true)
					:SetScript("OnTextChanged", private.ImportOnTextChanged)
					:SetScript("OnSizeChanged", private.ImportOnSizeChanged)
					:SetScript("OnCursorChanged", private.ImportOnCursorChanged)
				)
			)
			:SetScript("OnMouseUp", private.ImportOnMouseUp)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "layout")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "IMPORT")
				:SetStyle("width", 160)
				:SetStyle("height", 26)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetText(L["IMPORT"])
				:SetScript("OnClick", private.ImportOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "generalOptionsTitle")
			:SetStyle("height", 19)
			:SetStyle("margin.top", 32)
			:SetStyle("margin.bottom", 8)
			:SetStyle("fontHeight", 16)
			:SetStyle("font", TSM.UI.Fonts.MontserratBold)
			:SetStyle("textColor", "#ffffffff")
			:SetText(L["Advanced Options"])
		)
		:AddChild(private.CreateImportOptionToggle("moveGroupedItems", L["Move already grouped items?"], private.importOptions))
		:AddChild(private.CreateImportOptionToggle("includeOperations", L["Include operations?"], private.importOptions))
		:AddChild(private.CreateImportOptionToggle("replaceDuplicateOperations", L["Replace duplicate operations?"], private.importOptions))
		:AddChild(private.CreateImportOptionToggle("skipConfirmation", L["Skip Import confirmation?"], private.importOptions))
end

function private.GetExporterGroupsFrameSelectedGroups()
	return TSMAPI_FOUR.UI.NewElement("Frame", "exportFeedback")
		:SetLayout("VERTICAL")
		:SetStyle("background", "#ff1e1e1e")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "instructions")
			:SetStyle("height", 54)
			:SetStyle("font", TSM.UI.Fonts.title)
			:SetStyle("fontHeight", 16)
			:SetStyle("fontSpacing", 2)
			:SetStyle("textColor", "#ffe2e2e2")
			:SetStyle("margin", { top = 16, left = 16, right = 16, bottom = 0})
			:SetText(L["Use the list to the left to select groups, & operations you'd like to create export strings for."])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "CheckBoxesLine")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 28)
			:SetStyle("padding", 10)
			:SetStyle("margin", { top = 16 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "includeAttachedOperationsCheckbox")
				:SetText(L["Include Attached Operations"])
				:SetSettingInfo(private.exporter.options, "includeAttachedOperations")
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "buttonLayout")
			:SetLayout("HORIZONTAL")
			:SetStyle("margin", { top = 16 })
			:SetStyle("height", 30)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "CancelButton")
				:SetText(RESET)
				:SetScript("OnClick", private.ExporterResetSelectedGroupsOnClick)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "ExportLabel")
				:SetStyle("height", 30)
				:SetStyle("width", 200)
				:SetStyle("fontHeight", 24)
				:SetStyle("justifyH", "CENTER")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetText(L["Export List"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "ConfirmButton")
				:SetText(NEXT)
				:SetStyle("textColor", "#ffd839")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetScript("OnClick", private.ExporterExportSelectedGroupsOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
			:SetStyle("height", 2)
			:SetStyle("color", "#9d9d9d")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("ExportConfirmationList", "exportConfirmationList")
			:SetExporter(private.exporter, true)
			:SetStyle("autoWidth", true)
			:SetStyle("autoHeight", true)
			:SetStyle("background", "#ff1e1e1e")
		)
end

function private.GetExportViewContainerCallback(element, path)
	if path == "blank" then
		return TSMAPI_FOUR.UI.NewElement("Text", "title")
			:SetStyle("height", 40)
			:SetStyle("fontHeight", 20)
			:SetStyle("justifyH", "CENTER")
			:SetText(L["Please select a group to export"])
	elseif path == "show_selection" then
		return TSMAPI_FOUR.UI.NewElement("ExportConfirmationList", "ExportConfirmationList")
			:SetExporter(private.exporter, true)
			:SetStyle("autoWidth", true)
			:SetStyle("autoHeight", true)
	elseif path == "show_export_string" then
		return TSMAPI_FOUR.UI.NewElement("Text", "exportString")
			:SetText(private.exporter:GetExportString())
	else
		error("Unknown path "..path.." for exportViewContainer")
	end
end

function private.ExportGroupsSelectionChanged(element, selectedGroups)
	private.exporter:ResetSelection()
	for path, isSelected in pairs(selectedGroups) do
		if isSelected then
			private.exporter:SelectGroup(path)
		end
	end
	private.exporter:FinalizeGroupSelections()

	local rightPane = element:GetElement("__parent.__parent.__parent.__parent.groups.content.buttons.ExportRightPane")
	if rightPane:GetPath() == "exportOutput" then
		return
	end
	local exportConfirmationList = rightPane:GetElement("exportFeedback.exportConfirmationList")
	exportConfirmationList:SetExporter(private.exporter, true)
end

function private.GetExporterGroupsFrameExportOutput()
	local frame = TSMAPI_FOUR.UI.NewElement("BorderedFrame", "export")
		:SetLayout("HORIZONTAL")
		:SetStyle("borderTheme", "roundLight")
		:SetStyle("margin", { top = 16, left = 16, right = 16, bottom = 17 })
		:AddChild(TSMAPI_FOUR.UI.NewElement("ScrollFrame", "scroll")
			:SetStyle("margin.bottom", 2)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
				:SetStyle("margin", { left = 2, right = 8 })
				:SetStyle("height", 145)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 14)
				:SetStyle("justifyH", "LEFT")
				:SetSpacing(6)
				:SetMultiLine(true)
				:SetText(private.exporter:GetExportString())
				:SetScript("OnTextChanged", nil)
				:SetScript("OnSizeChanged", private.ExportOnSizeChanged)
				:SetScript("OnEditFocusGained", private.ExportFocusGained)
			)
		)
		:SetScript("OnMouseUp", private.ExportOnMouseUp)

	return frame
end

function private.ExportFocusGained(input)
	input:HighlightText()
end

function private.ExportOnMouseUp(frame)
	frame:GetElement("scroll.input"):SetFocused(true)
end

function private.ExportOnSizeChanged(input, width, height)
	input:SetStyle("height", height)
	input:GetParentElement():Draw()

	local scrollframe = input:GetParentElement()
	scrollframe._scrollbar:SetValue(scrollframe:_GetMaxScroll())
end

function private.CountOperations(operations)
	local total = 0
	for _, module in pairs(operations) do
		total = total + TSMAPI_FOUR.Util.Count(module)
	end
	return total
end

function private.ImportOnMouseUp(frame)
	frame:GetElement("scroll.input"):SetFocused(true)
end

function private.ImportOnTextChanged(input)
	local text = input:GetText()
	if input:GetText() == private.importText then
		return
	end
	private.importText = text
	input:SetText(private.importText)
end

function private.ImportOnSizeChanged(input, width, height)
	private.ImportOnTextChanged(input)

	input:SetStyle("height", height)
	input:GetParentElement():Draw()
end

function private.ImportOnCursorChanged(input, _, y)
	local scrollFrame = input:GetParentElement()
	scrollFrame._scrollbar:SetValue(TSMAPI_FOUR.Util.Round(abs(y) / (input:_GetStyle("height") - 22) * scrollFrame:_GetMaxScroll()))
end

function private.ConfirmImportOnClick(element)
	private.newImport:Commit(private.importRootPath)
	private.newImport:Release()
	private.newImport = nil
	local importViewContainer = element:GetElement("__parent.__parent.__parent")
	importViewContainer:SetPath("import", true)
end

function private.GetImporterConfirmationFrame()
	local numItems, numOperations = private.newImport:GetInfo()
	return TSMAPI_FOUR.UI.NewElement("Frame", "ImportConfirmation")
		:SetLayout("VERTICAL")
		:SetStyle("background", "#272727")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer")
			:SetStyle("height", 25)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "ButtonLine")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 50)
			:SetStyle("textColor", "#ffe2e2e2")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "CancelButton")
				:SetText(CANCEL)
				:SetStyle("font", TSM.UI.Fonts.MontserratBold)
				:SetStyle("fontHeight", 16)
				:SetStyle("fontSpacing", 2)
				:SetScript("OnClick", private.CancelConfirmOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "ImportPrompt")
				:SetText(format(L["Import %d Items and %s Operations?"], numItems, numOperations))
				:SetStyle("autoWidth", true)
				:SetStyle("fontHeight", 18)
				:SetStyle("font", TSM.UI.Fonts.MontserratBold)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "ConfirmButton")
				:SetText(L["Confirm"])
				:SetStyle("font", TSM.UI.Fonts.MontserratBold)
				:SetStyle("fontHeight", 16)
				:SetStyle("fontSpacing", 2)
				:SetStyle("textColor", "#ffd839")
				:SetScript("OnClick", private.ConfirmImportOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "divider")
			:SetStyle("background", "#9d9d9d")
			:SetStyle("height", 1)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("ImportConfirmationList")
			:SetImport(private.newImport)
		)
end

function private.CancelConfirmOnClick(element)
	local importViewContainer = element:GetElement("__parent.__parent.__parent")
	importViewContainer:SetPath("import", true)
end

function private.ExporterExportSelectedGroupsOnClick(element)
	local path = "__parent.__parent.__parent.__parent.__parent.__parent.content.buttons.ExportRightPane"
	local exportViewContainer = element:GetElement(path)
	exportViewContainer:SetPath("exportOutput", true)
end

function private.ExporterResetSelectedGroupsOnClick(element)
	local outerViewContainer = element:GetElement("__parent.__parent.__parent.__parent")
	outerViewContainer:SetPath(L["Import"], false)
	outerViewContainer:SetPath(L["Export"], true)
end

function private.ImportOnClick(element)
	local input = element:GetElement("__parent.__parent.import.scroll.input")
	private.newImport = TSM.Groups.Import.ParseString(input:GetText())
	input:SetText("")
	input:Draw()
	if not private.newImport then
		TSM:Print(L["Invalid import string."])
		return
	end

	-- apply our options
	if not private.importOptions.includeOperations then
		private.newImport:RemoveOperations()
	end
	if not private.importOptions.moveGroupedItems then
		private.newImport:RemoveExistingGroupedItems()
	end
	if not private.importOptions.replaceDuplicateOperations then
		private.newImport:RemoveExistingOperations()
	end

	local importViewContainer = element:GetElement("__parent.__parent.__parent.__parent.__parent.__parent.__parent.ImportExportOuterViewContainer")
	if private.importOptions.skipConfirmation then
		private.newImport:Commit(private.importRootPath)
		private.newImport:Release()
		private.newImport = nil
		-- Redraw the groups pane with the new data
		local groupSelectionPane = importViewContainer:GetElement("groups.ImportExportLeftPane.groupSelection.groupTree")
		groupSelectionPane:_UpdateData()
		groupSelectionPane:Draw()
		return
	end

	importViewContainer:SetPath("importConfirmation", true)
end
