-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Groups = TSM.MainUI:NewPackage("Groups")
local L = TSM.L
local private = {
	currentGroupPath = TSM.CONST.ROOT_GROUP_PATH,
	itemFilter = TSMAPI_FOUR.ItemFilter.New(),
	groupedItemList = {},
	ungroupedItemList = { {}, {} },
	moduleOperationList = {},
	descriptionShown = {},
	moduleCollapsed = {},
	groupSearch = "",
	itemSearch = "",
}
local DEFAULT_DIVIDED_CONTAINER_CONTEXT = {
	leftWidth = 300,
}
-- TODO: this should eventually go in the saved variables
private.dividedContainerContext = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Groups.OnInitialize()
	TSM.MainUI.RegisterTopLevelPage(L["Groups"], "iconPack.24x24/Groups", private.GetGroupsFrame)
	private.itemFilter:ParseStr("")
end

function Groups.ShowGroupSettings(baseFrame, groupPath)
	baseFrame:SetSelectedNavButton(L["Groups"], true)
	baseFrame:GetElement("content.groups.groupSelection.groupTree"):SetSelectedGroup(groupPath)
end



-- ============================================================================
-- Groups UI
-- ============================================================================

function private.GetGroupsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "groups")
	private.currentGroupPath = TSM.CONST.ROOT_GROUP_PATH
	local frame = TSMAPI_FOUR.UI.NewElement("DividedContainer", "groups")
		:SetStyle("background", "#272727")
		:SetContextTable(private.dividedContainerContext, DEFAULT_DIVIDED_CONTAINER_CONTEXT)
		:SetMinWidth(250, 250)
		:SetLeftChild(TSMAPI_FOUR.UI.NewElement("Frame", "groupSelection")
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
					:SetScript("OnClick", private.MoreBtnOnClick)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", 2)
				:SetStyle("color", "#9d9d9d")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ManagementGroupTree", "groupTree")
				:SetGroupListFunc(private.GroupTreeGetList)
				:SetSelectedGroup(private.currentGroupPath)
				:SetContextTable(TSM.db.profile.internalData.managementGroupTreeContext)
				:SetSearchString(private.groupSearch)
				:SetScript("OnGroupSelected", private.GroupTreeOnGroupSelected)
			)
		)
		:SetRightChild(TSMAPI_FOUR.UI.NewElement("Frame", "content")
			:SetLayout("VERTICAL")
			:SetStyle("padding", { top = 30 })
			:SetStyle("background", "#272727")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "header")
				:SetLayout("VERTICAL")
				:SetStyle("height", 32)
				:SetStyle("expandWidth", true)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "title")
					:SetLayout("HORIZONTAL")
					:SetStyle("expandWidth", true)
					:SetStyle("margin", { left = 16, right = 16 })
					:AddChild(TSMAPI_FOUR.UI.NewElement("EditableText", "text")
						:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
						:SetStyle("fontHeight", 24)
						:SetStyle("autoWidth", true)
						:SetText(L["Base Group"])
						:SetScript("OnValueChanged", private.TitleOnValueChanged)
						:SetScript("OnEditingChanged", private.TitleOnEditingChanged)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "editBtn")
						:SetStyle("width", 18)
						:SetStyle("height", 18)
						:SetStyle("backgroundTexturePack", "iconPack.18x18/Edit")
						:SetScript("OnClick", private.EditBtnOnClick)
					)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("TabGroup", "buttons")
				:SetStyle("margin", { top = 16 })
				:SetNavCallback(private.GetGroupsPage)
				:AddPath(L["Information"], true)
				:AddPath(L["Group Operations"])
			)
		)
	frame:GetElement("content.header.title.editBtn"):Hide()
	return frame
end

function private.GetGroupsPage(self, button)
	if button == L["Information"] then
		TSM.UI.AnalyticsRecordPathChange("main", "groups", "information")
		return TSMAPI_FOUR.UI.NewElement("Frame", "items")
			:SetLayout("VERTICAL")
			:SetStyle("background", "#1e1e1e")
			:SetStyle("padding", { left = 10, right = 10})
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
				:SetStyle("justifyH", "LEFT")
				:SetText(L["By default, this group houses all items that aren't assigned to a group. You cannot modify or delete this group."])
				:SetStyle("height", 80)
				:SetStyle("fontHeight", 15)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
	elseif button == L["Add / Remove Items"] then
		TSM.UI.AnalyticsRecordPathChange("main", "groups", "items")
		assert(private.currentGroupPath ~= TSM.CONST.ROOT_GROUP_PATH)
		return TSMAPI_FOUR.UI.NewElement("Frame", "items")
			:SetLayout("VERTICAL")
			:SetStyle("background", "#171717")
			:SetStyle("padding", { left = 8, right = 8, top = 8, bottom = 8 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "filter")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 24)
				:SetStyle("margin", { bottom = 8 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("SearchInput", "filter")
					:SetStyle("height", 20)
					:SetStyle("margin", { right = 16 })
					:SetHintText(L["Filter Items"])
					:SetScript("OnTextChanged", private.ItemFilterOnTextChanged)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "ignoreItemVariations")
					:SetStyle("width", 220)
					:SetStyle("height", 24)
					:SetStyle("margin", { right = -4 })
					:SetCheckboxPosition("RIGHT")
					:SetText(L["Ignore item variations?"])
					:SetSettingInfo(TSM.db.profile.userData.groups[private.currentGroupPath], "ignoreItemVariations")
					:SetScript("OnValueChanged", private.IgnoreRandomOnValueChanged)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "content")
				:SetLayout("HORIZONTAL")
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "ungrouped")
					:SetLayout("VERTICAL")
					:SetStyle("margin", { right = 8 })
					:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "content")
						:SetLayout("VERTICAL")
						:SetStyle("borderTexture", "Interface\\Addons\\TradeSkillMaster\\Media\\ItemPreviewEdgeFrame.blp")
						:SetStyle("borderSize", 8)
						:SetStyle("borderInset", 1)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "header")
							:SetLayout("VERTICAL")
							:SetStyle("background", "#1e1e1e")
							:SetStyle("borderInsets", { left = 2, right = 2, top = 3 })
							:SetStyle("height", 33)
							:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "title")
								:SetLayout("HORIZONTAL")
								:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
									:SetStyle("margin", { left = 26, right = 4 })
									:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
									:SetStyle("fontHeight", 16)
									:SetStyle("justifyH", "CENTER")
									:SetText(L["Ungrouped Items"])
								)
								:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "moreBtn")
									:SetStyle("width", 18)
									:SetStyle("height", 18)
									:SetStyle("backgroundTexturePack", "iconPack.18x18/More")
									:SetStyle("backgroundTextureRotation", 0)
									:SetStyle("margin", { right = 8 })
									:SetScript("OnClick", private.UngroupedMoreBtnOnClick)
								)
							)
							:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
								:SetStyle("height", 1)
								:SetStyle("color", "#585858")
								:SetStyle("margin", { left = 2, right = 2 })
							)
						)
						:AddChild(TSMAPI_FOUR.UI.NewElement("ItemList", "itemList")
							:SetStyle("margin", { left = 2, right = 2, bottom = 3, top = 1 })
							:SetItems(private.GetUngroupedItemList())
							:SetFilterFunction(private.ItemListItemIsFiltered)
							:SetScript("OnSelectionChanged", private.UngroupedItemsOnSelectionChanged)
						)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "btn")
						:SetStyle("height", 26)
						:SetStyle("margin", { top = 10 })
						:SetText(L["Select Items to Add"])
						:SetDisabled(true)
						:SetScript("OnClick", private.AddItemsOnClick)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "grouped")
					:SetLayout("VERTICAL")
					:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "content")
						:SetLayout("VERTICAL")
						:SetStyle("borderTexture", "Interface\\Addons\\TradeSkillMaster\\Media\\ItemPreviewEdgeFrame.blp")
						:SetStyle("borderSize", 8)
						:SetStyle("borderInset", 1)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "header")
							:SetLayout("VERTICAL")
							:SetStyle("background", "#1e1e1e")
							:SetStyle("borderInsets", { left = 2, right = 2, top = 3 })
							:SetStyle("height", 33)
							:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "title")
								:SetLayout("HORIZONTAL")
								:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
									:SetStyle("margin", { left = 26, right = 4 })
									:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
									:SetStyle("fontHeight", 16)
									:SetStyle("justifyH", "CENTER")
									:SetText(L["Grouped Items"])
								)
								:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "moreBtn")
									:SetStyle("width", 18)
									:SetStyle("height", 18)
									:SetStyle("backgroundTexturePack", "iconPack.18x18/More")
									:SetStyle("backgroundTextureRotation", 0)
									:SetStyle("margin", { right = 8 })
									:SetScript("OnClick", private.GroupedMoreBtnOnClick)
								)
							)
							:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
								:SetStyle("height", 1)
								:SetStyle("color", "#585858")
								:SetStyle("margin", { left = 2, right = 2 })
							)
						)
						:AddChild(TSMAPI_FOUR.UI.NewElement("ItemList", "itemList")
							:SetStyle("margin", { left = 2, right = 2, bottom = 3, top = 1 })
							:SetItems(private.GetGroupedItemList())
							:SetFilterFunction(private.ItemListItemIsFiltered)
							:SetScript("OnSelectionChanged", private.GroupedItemsOnSelectionChanged)
						)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "btn")
						:SetStyle("height", 26)
						:SetStyle("margin", { top = 10 })
						:SetText(L["Select Items to Remove"])
						:SetDisabled(true)
						:SetScript("OnClick", private.RemoveItemsOnClick)
						:SetTooltip(L["Hold shift to move the items to the parent group instead of removing them."])
					)
				)
			)
	elseif button == L["Group Operations"] then
		TSM.UI.AnalyticsRecordPathChange("main", "groups", "operations")
		return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "operations")
			:SetStyle("background", "#1e1e1e")
			:SetStyle("padding.top", 10)
			:AddChild(private.GetModuleOperationFrame("Auctioning"))
			:AddChild(private.GetModuleOperationFrame("Crafting"))
			:AddChild(private.GetModuleOperationFrame("Mailing"))
			:AddChild(private.GetModuleOperationFrame("Shopping"))
			:AddChild(private.GetModuleOperationFrame("Sniper"))
			:AddChild(private.GetModuleOperationFrame("Vendoring"))
			:AddChild(private.GetModuleOperationFrame("Warehousing"))
	else
		error("Unknown button!")
	end
end

function private.GetModuleOperationFrame(moduleName)
	local override = TSM.Groups.HasOperationOverride(private.currentGroupPath, moduleName)

	-- populate our list of operations for this module
	if not private.moduleOperationList[moduleName] then
		private.moduleOperationList[moduleName] = {}
	end
	wipe(private.moduleOperationList[moduleName])
	tinsert(private.moduleOperationList[moduleName], "|cffffd839"..L["Create New Operation"].."|r")
	for _, operationName in TSM.Operations.OperationIterator(moduleName) do
		tinsert(private.moduleOperationList[moduleName], operationName)
	end

	local numGroupOperations = 0
	for _ in TSM.Groups.OperationIterator(private.currentGroupPath, moduleName) do
		numGroupOperations = numGroupOperations + 1
	end

	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "operationInfo"..moduleName)
		:SetContext(moduleName)
		:SetLayout("VERTICAL")
		:SetStyle("padding", { left = 8, right = 4, top = 4, bottom = 0 })

	frame:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "moduleTitle")
		:SetLayout("HORIZONTAL")
		:SetStyle("height", 24)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "expander")
			:SetStyle("backgroundTexturePack", private.moduleCollapsed[moduleName] and "iconPack.18x18/Carot/Collapsed" or "iconPack.18x18/Carot/Expanded")
			:SetStyle("width", TSM.UI.TexturePacks.GetWidth("iconPack.18x18/Carot/Expanded"))
			:SetStyle("height", TSM.UI.TexturePacks.GetHeight("iconPack.18x18/Carot/Expanded"))
			:SetScript("OnClick", private.OperationExpanderOnClick)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "moduleName")
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#79a2ff")
			:SetStyle("margin", { left = 4, right = 2 })
			:SetStyle("autoWidth", true)
			:SetText(moduleName)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "numGroupOperations")
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetStyle("margin", { left = 2 })
			:SetFormattedText("("..L["%d Operations"]..")", numGroupOperations)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "overrideCheckbox")
			:SetStyle("height", 24)
			:SetStyle("margin", { right = 4 })
			:SetCheckboxPosition("RIGHT")
			:SetText(L["Override parent operations"])
			:SetChecked(override)
			:SetScript("OnValueChanged", private.OverrideToggleOnValueChanged)
		)
	)

	local moduleTitle = frame:GetElement("moduleTitle")
	if private.currentGroupPath == TSM.CONST.ROOT_GROUP_PATH then
		moduleTitle:GetElement("overrideCheckbox"):Hide()
	else
		moduleTitle:GetElement("numGroupOperations"):SetStyle("autoWidth", true)
	end

	if private.moduleCollapsed[moduleName] then
		return frame
	end

	for i, operationName in TSM.Groups.OperationIterator(private.currentGroupPath, moduleName) do
		frame:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "operation"..i)
			:SetLayout("VERTICAL")
			:SetStyle("margin", { left = 20, right = 8, top = 8 })
			:SetStyle("padding", 8)
			:SetStyle("background", "#992e2e2e")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "title")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 20)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "name")
					:SetStyle("font", TSM.UI.Fonts.MontserratBold)
					:SetStyle("textColor", "#ffd839")
					:SetStyle("fontHeight", 14)
					:SetStyle("autoWidth", true)
					:SetText(operationName)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "descBtn")
					:SetStyle("margin", { left = 8 })
					:SetStyle("font", TSM.UI.Fonts.MontserratBold)
					:SetStyle("fontHeight", 11)
					:SetStyle("autoWidth", true)
					:SetContext(operationName)
					:SetText(private.descriptionShown[operationName] and L["Hide Description"] or L["Show Description"])
					:SetScript("OnClick", private.DescriptionButtonOnClick)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "spacer"))
				:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "configBtn")
					:SetStyle("width", TSM.UI.TexturePacks.GetWidth("iconPack.18x18/Configure"))
					:SetStyle("backgroundTexturePack", "iconPack.18x18/Configure")
					:SetContext(operationName)
					:SetScript("OnClick", private.ConfigOperationOnClick)
				)
			)
		)
		if override or private.currentGroupPath == TSM.CONST.ROOT_GROUP_PATH then
			frame:GetElement("operation"..i..".title"):AddChild(TSMAPI_FOUR.UI.NewElement("Button", "removeBtn")
				:SetStyle("margin", { left = 4 })
				:SetStyle("width", TSM.UI.TexturePacks.GetWidth("iconPack.18x18/Close/Circle"))
				:SetStyle("backgroundTexturePack", "iconPack.18x18/Close/Circle")
				:SetContext(i)
				:SetScript("OnClick", private.RemoveOperationOnClick)
			)
		end
		if private.descriptionShown[operationName] then
			frame:GetElement("operation"..i):AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc")
				:SetStyle("height", 16)
				:SetStyle("margin", { top = 8, bottom = 4 })
				:SetStyle("fontHeight", 12)
				:SetStyle("fontSpacing", 4)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("textColor", "#ffffff")
				:SetText(TSM.Operations.GetDescription(moduleName, operationName))
			)
		end
	end

	if numGroupOperations < TSM.Operations.GetMaxNumber(moduleName) then
		frame:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "moduleTitle")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 29)
			:SetStyle("margin", { top = 6, bottom = 10 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "dropdownDesc")
				:SetStyle("height", 14)
				:SetStyle("width", 120)
				:SetStyle("margin", { left = 24, top = 5, bottom = 4 })
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 12)
				:SetStyle("textColor", "#e2e2e2")
				:SetText(L["ADD OPERATION"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "dropdown")
				:SetStyle("height", 26)
				:SetStyle("autoWidth", true)
				:SetStyle("margin", { right = 8, left = -4 })
				:SetHintText(L["Select Operation"])
				:SetItems(private.moduleOperationList[moduleName])
				:SetDisabled(private.currentGroupPath ~= TSM.CONST.ROOT_GROUP_PATH and not override)
				:SetScript("OnSelectionChanged", private.NewOperationSelectionChanged)
			)
		)
	else
		frame:SetStyle("margin.bottom", 10)
	end

	return frame
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.GroupSearchOnTextChanged(input)
	local groupsContentFrame = input:GetElement("__parent.__parent.__parent.content")
	-- Copy search filter
	local text = strlower(strtrim(input:GetText()))

	if private.groupSearch == text then
		return
	end

	private.groupSearch = text
	local searchStr = TSMAPI_FOUR.Util.StrEscape(private.groupSearch)
	-- Check selection is being filtered out
	if not strmatch(strlower(private.currentGroupPath), searchStr) then
		local titleFrame = groupsContentFrame:GetElement("header.title")
		local buttonsFrame = groupsContentFrame:GetElement("buttons")
		input:GetElement("__parent.__parent.groupTree"):SetSelectedGroup(TSM.CONST.ROOT_GROUP_PATH)
		titleFrame:GetElement("text")
			:SetText(L["No group selected"])
			:SetEditing(false)
		-- Hide the content
		titleFrame:GetElement("editBtn"):Hide()
		buttonsFrame:Hide()
		buttonsFrame:Draw()
		titleFrame:Draw()
	end
	input:GetElement("__parent.__parent.groupTree")
		:SetSearchString(private.groupSearch)
		:Draw()
end

local function MoreDialogRowIterator(_, prevIndex)
	if prevIndex == nil then
		return 1, L["Expand All Groups"], private.ExpandAllBtnOnClick
	elseif prevIndex == 1 then
		return 2, L["Collapse All Groups"], private.CollapseAllBtnOnClick
	end
end

function private.MoreBtnOnClick(button)
	button:GetBaseElement():ShowMoreButtonDialog(button, MoreDialogRowIterator)
end

function private.ExpandAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.groups.groupSelection.groupTree"):ExpandAll()
	baseFrame:HideDialog()
end

function private.CollapseAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.groups.groupSelection.groupTree"):CollapseAll()
	baseFrame:HideDialog()
end

function private.GroupTreeGetList(groups, headerNameLookup)
	for _, groupPath in TSM.Groups.GroupIterator() do
		tinsert(groups, groupPath)
	end
	tinsert(groups, 1, TSM.CONST.ROOT_GROUP_PATH)
	headerNameLookup[TSM.CONST.ROOT_GROUP_PATH] = L["Base Group"]
end

function private.GroupTreeOnGroupSelected(self, path)
	private.currentGroupPath = path
	local contentFrame = self:GetElement("__parent.__parent.content")
	local titleFrame = contentFrame:GetElement("header.title")
	local buttonsFrame = contentFrame:GetElement("buttons")

	if path == TSM.CONST.ROOT_GROUP_PATH then
		titleFrame:GetElement("text")
			:SetText(L["Base Group"])
			:SetEditing(false)
		titleFrame:GetElement("editBtn"):Hide()
		buttonsFrame:RenamePath(L["Information"], 1)
	else
		titleFrame:GetElement("text")
			:SetText(TSM.Groups.Path.GetName(path))
			:SetEditing(false)
		titleFrame:GetElement("editBtn"):Show()
		buttonsFrame:RenamePath(L["Add / Remove Items"], 1)
	end
	-- Show the frame in case it is hidden by filter
	buttonsFrame:Show()
	buttonsFrame:Draw()
	titleFrame:Draw()
	contentFrame:GetElement("buttons"):ReloadContent()
end

function private.TitleOnValueChanged(text, newValue)
	newValue = strtrim(newValue)
	local parent = TSM.Groups.Path.GetParent(private.currentGroupPath)
	local newPath = parent and parent ~= TSM.CONST.ROOT_GROUP_PATH and (parent..TSM.CONST.GROUP_SEP..newValue) or newValue
	if newPath == private.currentGroupPath then
		-- didn't change
		text:Draw()
	elseif strfind(newValue, TSM.CONST.GROUP_SEP) or newValue == "" then
		TSM:Print(L["Invalid group name."])
		text:Draw()
	elseif TSM.Groups.Exists(newPath) then
		TSM:Print(L["Group already exists."])
		text:Draw()
	else
		TSM.Groups.Move(private.currentGroupPath, newPath)
		TSM.Analytics.Action("MOVED_GROUP", private.currentGroupPath, newPath)
		text:GetElement("__parent.__parent.__parent.__parent.groupSelection.groupTree"):SetSelectedGroup(newPath, true)
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
	assert(private.currentGroupPath ~= TSM.CONST.ROOT_GROUP_PATH)
	button:GetElement("__parent.text"):SetEditing(true)
end

function private.ItemFilterOnTextChanged(self)
	local text = strtrim(self:GetText())

	if private.itemSearch == text then
		return
	end

	private.itemSearch = text

	private.itemFilter:ParseStr(self:GetText())
	self:GetElement("__parent.__parent.content.ungrouped.content.itemList")
		:SetFilterFunction(private.ItemListItemIsFiltered)
		:Draw()
	self:GetElement("__parent.__parent.content.grouped.content.itemList")
		:SetFilterFunction(private.ItemListItemIsFiltered)
		:Draw()
end

function private.IgnoreRandomOnValueChanged(self, checked)
	-- update the ungrouped item list
	self:GetElement("__parent.__parent.content.ungrouped.content.itemList"):SetItems(private.GetUngroupedItemList(), true)
end

function private.AddItemsOnClick(self)
	local itemList = self:GetElement("__parent.content.itemList")
	local numAdded = 0
	for _, items in ipairs(private.GetUngroupedItemList()) do
		for _, itemLink in ipairs(items) do
			if itemList:IsItemSelected(itemLink) then
				local itemString = TSMAPI_FOUR.Item.ToItemString(itemLink)
				TSM.Groups.SetItemGroup(itemString, private.currentGroupPath)
				numAdded = numAdded + 1
			end
		end
	end
	TSM.Analytics.Action("ADDED_GROUP_ITEMS", private.currentGroupPath, numAdded)

	-- update the item lists
	itemList:SetItems(private.GetUngroupedItemList(), true)
	local otherItemList = self:GetElement("__parent.__parent.grouped.content.itemList")
	otherItemList:SetItems(private.GetGroupedItemList(), true)
end

local function UngroupedMoreDialogRowIterator(_, prevIndex)
	if prevIndex == nil then
		return 1, L["Select All Items"], private.UngroupedSelectAllBtnOnClick
	elseif prevIndex == 1 then
		return 2, L["Deselect All Items"], private.UngroupedDeselectAllBtnOnClick
	end
end

function private.UngroupedMoreBtnOnClick(button)
	button:GetBaseElement():ShowMoreButtonDialog(button, UngroupedMoreDialogRowIterator)
end

function private.UngroupedSelectAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.groups.content.buttons.items.content.ungrouped.content.itemList"):SelectAll()
	baseFrame:HideDialog()
end

function private.UngroupedDeselectAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.groups.content.buttons.items.content.ungrouped.content.itemList"):ClearSelection()
	baseFrame:HideDialog()
end

function private.UngroupedItemsOnSelectionChanged(self, numSelected)
	local button = self:GetElement("__parent.__parent.btn")
	local noneSelected = numSelected == 0
	button:SetDisabled(noneSelected)
	button:SetText(noneSelected and L["Select Items to Add"] or format(L["ADD %d ITEMS"], numSelected))
	button:Draw()
end

local function GroupedMoreDialogRowIterator(_, prevIndex)
	if prevIndex == nil then
		return 1, L["Select All Items"], private.GroupedSelectAllBtnOnClick
	elseif prevIndex == 1 then
		return 2, L["Deselect All Items"], private.GroupedDeselectAllBtnOnClick
	end
end

function private.GroupedMoreBtnOnClick(button)
	button:GetBaseElement():ShowMoreButtonDialog(button, GroupedMoreDialogRowIterator)
end

function private.GroupedSelectAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.groups.content.buttons.items.content.grouped.content.itemList"):SelectAll()
	baseFrame:HideDialog()
end

function private.GroupedDeselectAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.groups.content.buttons.items.content.grouped.content.itemList"):ClearSelection()
	baseFrame:HideDialog()
end

function private.GroupedItemsOnSelectionChanged(self, numSelected)
	local button = self:GetElement("__parent.__parent.btn")
	local noneSelected = numSelected == 0
	button:SetDisabled(noneSelected)
	button:SetText(noneSelected and L["Select Items to Remove"] or format(L["REMOVE %d |4ITEM:ITEMS;"], numSelected))
	button:Draw()
end

function private.RemoveItemsOnClick(self)
	local itemList = self:GetElement("__parent.content.itemList")
	local numRemoved = 0
	local targetGroup = IsShiftKeyDown() and TSM.Groups.Path.GetParent(private.currentGroupPath) or nil
	for _, itemLink in ipairs(private.GetGroupedItemList()) do
		if itemList:IsItemSelected(itemLink) then
			TSM.Groups.SetItemGroup(TSMAPI_FOUR.Item.ToItemString(itemLink), targetGroup)
			numRemoved = numRemoved + 1
		end
	end
	TSM.Analytics.Action("REMOVED_GROUP_ITEMS", private.currentGroupPath, numRemoved, targetGroup or "")

	-- update the item lists
	itemList:SetItems(private.GetGroupedItemList(), true)
	local otherItemList = self:GetElement("__parent.__parent.ungrouped.content.itemList")
	otherItemList:SetItems(private.GetUngroupedItemList(), true)
end

function private.OperationExpanderOnClick(button)
	local moduleOperationFrame = button:GetParentElement():GetParentElement()
	local moduleName = moduleOperationFrame:GetContext()
	private.moduleCollapsed[moduleName] = not private.moduleCollapsed[moduleName]
	moduleOperationFrame:GetParentElement():GetParentElement():ReloadContent()
end

function private.OverrideToggleOnValueChanged(self, value)
	assert(private.currentGroupPath ~= TSM.CONST.ROOT_GROUP_PATH)
	local moduleOperationFrame = self:GetParentElement():GetParentElement()
	local moduleName = moduleOperationFrame:GetContext()
	TSM.Groups.SetOperationOverride(private.currentGroupPath, moduleName, value)
	TSM.Analytics.Action("CHANGED_GROUP_OVERRIDE", private.currentGroupPath, moduleName, value)
	moduleOperationFrame:GetParentElement():GetParentElement():ReloadContent()
end

function private.NewOperationSelectionChanged(self, operationName)
	local moduleOperationFrame = self:GetParentElement():GetParentElement()
	local moduleName = moduleOperationFrame:GetContext()
	if operationName == "|cffffd839"..L["Create New Operation"].."|r" then
		operationName = L["New Operation"]
		local extra = ""
		local num = 0
		while TSM.Operations.Exists(moduleName, operationName..extra) do
			num = num + 1
			extra = " "..num
		end
		operationName = operationName..extra
		TSM.Operations.Create(moduleName, operationName)
		TSM.Groups.AppendOperation(private.currentGroupPath, moduleName, operationName)
		TSM.Analytics.Action("ADDED_GROUP_OPERATION", private.currentGroupPath, moduleName, operationName)
		TSM.MainUI.Operations.ShowOperationSettings(self:GetBaseElement(), moduleName, operationName)
	else
		TSM.Groups.AppendOperation(private.currentGroupPath, moduleName, operationName)
		TSM.Analytics.Action("ADDED_GROUP_OPERATION", private.currentGroupPath, moduleName, operationName)
		moduleOperationFrame:GetParentElement():GetParentElement():ReloadContent()
	end
end

function private.ConfigOperationOnClick(button)
	local moduleName = button:GetParentElement():GetParentElement():GetParentElement():GetContext()
	local operationName = button:GetContext()
	local baseFrame = button:GetBaseElement()
	TSM.MainUI.Operations.ShowOperationSettings(baseFrame, moduleName, operationName)
end

function private.RemoveOperationOnClick(button)
	local moduleOperationFrame = button:GetParentElement():GetParentElement():GetParentElement()
	local moduleName = moduleOperationFrame:GetContext()
	local operationIndex = button:GetContext()
	local operationName = nil
	for index, name in TSM.Groups.OperationIterator(private.currentGroupPath, moduleName) do
		if index == operationIndex then
			operationName = name
		end
	end
	assert(operationName)
	TSM.Groups.RemoveOperation(private.currentGroupPath, moduleName, operationIndex)
	TSM.Analytics.Action("REMOVED_GROUP_OPERATION", private.currentGroupPath, moduleName, operationName)
	moduleOperationFrame:GetParentElement():GetParentElement():ReloadContent()
end

function private.DescriptionButtonOnClick(button)
	local operationName = button:GetContext()
	private.descriptionShown[operationName] = not private.descriptionShown[operationName] or nil
	button:GetParentElement():GetParentElement():GetParentElement():GetParentElement():GetParentElement():ReloadContent()
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.ItemSortHelper(a, b)
	return (TSMAPI_FOUR.Item.GetName(a) or "") < (TSMAPI_FOUR.Item.GetName(b) or "")
end

function private.GetUngroupedItemList()
	wipe(private.ungroupedItemList[1])
	wipe(private.ungroupedItemList[2])

	-- items in bags
	local addedItems = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, _, _, itemString in TSMAPI_FOUR.Inventory.BagIterator(false, false, true) do
		if TSM.db.profile.userData.groups[private.currentGroupPath].ignoreItemVariations then
			itemString = TSMAPI_FOUR.Item.ToBaseItemString(itemString)
		end
		if not TSM.Groups.IsItemInGroup(itemString) and not addedItems[itemString] then
			local itemLink = TSMAPI_FOUR.Item.GetLink(itemString)
			tinsert(private.ungroupedItemList[1], itemLink)
			addedItems[itemString] = true
		end
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(addedItems)
	private.ungroupedItemList[1].header = "|cff79a2ff" .. L["Ungrouped Items"] .. "|r"

	-- items in the parent group
	local parentGroupPath = TSM.Groups.Path.GetParent(private.currentGroupPath)
	for _, itemString, path in TSM.Groups.ItemIterator() do
		if path == parentGroupPath and parentGroupPath ~= TSM.CONST.ROOT_GROUP_PATH then
			local itemLink = TSMAPI_FOUR.Item.GetLink(itemString)
			tinsert(private.ungroupedItemList[2], itemLink)
		end
	end
	private.ungroupedItemList[2].header = "|cff79a2ff" .. L["Parent Items"] .. "|r"

	sort(private.ungroupedItemList[1], private.ItemSortHelper)
	sort(private.ungroupedItemList[2], private.ItemSortHelper)
	return private.ungroupedItemList
end

function private.GetGroupedItemList()
	wipe(private.groupedItemList)

	-- items in this group or a subgroup
	local itemNames = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, itemString, path in TSM.Groups.ItemIterator() do
		if path == private.currentGroupPath or strfind(path, "^"..TSMAPI_FOUR.Util.StrEscape(private.currentGroupPath)..TSM.CONST.GROUP_SEP) then
			local link = TSMAPI_FOUR.Item.GetLink(itemString)
			tinsert(private.groupedItemList, link)
			itemNames[link] = TSMAPI_FOUR.Item.GetName(itemString) or ""
		end
	end

	TSMAPI_FOUR.Util.TableSortWithValueLookup(private.groupedItemList, itemNames)
	TSMAPI_FOUR.Util.ReleaseTempTable(itemNames)
	return private.groupedItemList
end

function private.ItemListItemIsFiltered(itemLink)
	local basePrice = TSMAPI_FOUR.CustomPrice.GetValue(TSM.db.global.coreOptions.groupPriceSource, itemLink)
	return not private.itemFilter:Matches(itemLink, basePrice)
end
