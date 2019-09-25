-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Crafting = TSM.UI.CraftingUI:NewPackage("Crafting")
local L = TSM.L
local private = {
	db = nil,
	fsm = nil,
	professionsOrder = {},
	professions = {},
	groupSearch = "",
	showDelayFrame = 0,
	filterText = "",
	haveSkillUp = false,
	haveMaterials = false,
	professionFrame = nil,
}
local SHOW_DELAY_FRAMES = 2
local KEY_SEP = "\001"
local DEFAULT_DIVIDED_CONTAINER_CONTEXT = {
	leftWidth = 496,
}
local MAX_NUM_INPUT_VALUE = 999
-- TODO: this should eventually go in the saved variables
private.dividedContainerContext = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Crafting.OnInitialize()
	TSMAPI_FOUR.Util.RegisterItemLinkedCallback(private.ItemLinkedCallback)
	TSM.UI.CraftingUI.RegisterTopLevelPage("Crafting", "iconPack.24x24/Crafting", private.GetCraftingFrame)
	private.FSMCreate()
end

function Crafting.GatherCraftNext(spellId, quantity)
	private.fsm:ProcessEvent("EV_CRAFT_NEXT_BUTTON_CLICKED", spellId, quantity)
end



-- ============================================================================
-- Crafting UI
-- ============================================================================

function private.GetCraftingFrame()
	TSM.UI.AnalyticsRecordPathChange("crafting", "crafting")
	return TSMAPI_FOUR.UI.NewElement("DividedContainer", "crafting")
		:SetContextTable(private.dividedContainerContext, DEFAULT_DIVIDED_CONTAINER_CONTEXT)
		:SetMinWidth(450, 250)
		:SetLeftChild(TSMAPI_FOUR.UI.NewElement("Frame", "left")
			:SetLayout("VERTICAL")
			:SetStyle("background", "#272727")
			:AddChild(TSMAPI_FOUR.UI.NewElement("ViewContainer", "viewContainer")
				:SetNavCallback(private.GetCraftingMainScreen)
				:AddPath("main", true)
				:AddPath("filters")
			)
		)
		:SetRightChild(TSMAPI_FOUR.UI.NewElement("Frame", "right")
			:SetLayout("VERTICAL")
			:SetStyle("background", "#000000")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "queue")
				:SetLayout("VERTICAL")
				:SetStyle("background", "#404040")
				:SetStyle("padding.top", 37)
				:SetStyle("padding.left", 4)
				:SetStyle("padding.right", 4)
				:SetStyle("padding.bottom", 4)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
					:SetStyle("height", 20)
					:SetStyle("margin.bottom", 6)
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 14)
					:SetText(L["Crafting Queue"])
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("CraftingQueueList", "queueList")
					:SetStyle("margin.bottom", 10)
					:SetQuery(TSM.Crafting.CreateCraftsQuery()
						:IsNotNil("num")
						:GreaterThan("num", 0)
						:VirtualField("numCraftable", "number", TSM.Crafting.ProfessionUtil.GetNumCraftableFromDB, "spellId")
					)
					:SetScript("OnRowClick", private.QueueOnRowClick)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "queueCost")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 16)
					:SetStyle("margin.bottom", 2)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
						:SetStyle("autoWidth", true)
						:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
						:SetStyle("fontHeight", 12)
						:SetStyle("textColor", "#ffffff")
						:SetText(L["Estimated Cost:"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
						:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
						:SetStyle("fontHeight", 12)
						:SetStyle("textColor", "#ffffff")
						:SetStyle("justifyH", "RIGHT")
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "queueProfit")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 16)
						:SetStyle("margin.bottom", 2)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
						:SetStyle("autoWidth", true)
						:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
						:SetStyle("fontHeight", 12)
						:SetStyle("textColor", "#ffffff")
						:SetText(L["Estimated Profit:"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
						:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
						:SetStyle("fontHeight", 12)
						:SetStyle("justifyH", "RIGHT")
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "craft")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 26)
					:SetStyle("margin.top", 4)
					:SetStyle("margin.bottom", 2)
					:AddChild(TSMAPI_FOUR.UI.NewNamedElement("ActionButton", "craftNextBtn", "TSMCraftingBtn")
						:SetStyle("margin.right", 12)
						:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
						:SetStyle("fontHeight", 14)
						:SetText(L["CRAFT NEXT"])
						:SetScript("OnClick", private.CraftNextOnClick)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "clearBtn")
						:SetStyle("margin.right", 8)
						:SetStyle("width", 80)
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 12)
						:SetStyle("textColor", "#ffffff")
						:SetText(L["Clear Queue"])
						:SetScript("OnClick", private.ClearOnClick)
					)
				)
			)
		)
		:SetScript("OnUpdate", private.FrameOnUpdate)
		:SetScript("OnHide", private.FrameOnHide)
end

function private.GetCraftingMainScreen(self, button)
	if button == "main" then
		return TSMAPI_FOUR.UI.NewElement("Frame", "main")
			:SetLayout("VERTICAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "header")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 20)
				:SetStyle("margin", 8)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Toggle", "pageToggle")
					:SetStyle("width", 124)
					:SetStyle("height", 20)
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 12)
					:SetStyle("textColor", "#e2e2e2")
					:SetStyle("border", "#e2e2e2")
					:SetStyle("selectedBackground", "#e2e2e2")
					:SetStyle("selectedTextColor", "#2e2e2e")
					:AddOption(L["Crafts"], true)
					:AddOption(L["Groups"])
					:SetScript("OnValueChanged", private.PageToggleOnValueChanged)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ViewContainer", "content")
				:SetNavCallback(private.GetCraftingElements)
				:AddPath("profession", true)
				:AddPath("group")
			)
	elseif button == "filters" then
		return TSMAPI_FOUR.UI.NewElement("Frame", "filters")
			:SetLayout("VERTICAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "header")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 20)
				:SetStyle("margin", 8)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "backBtn")
					:SetStyle("width", 124)
					:SetStyle("height", 20)
					:SetText(L["BACK TO LIST"])
					:SetStyle("fontHeight", 12)
					:SetScript("OnClick", private.BackToCraftingListButton)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "professionFilters")
				:SetStyle("height", 15)
				:SetStyle("margin.bottom", 10)
				:SetStyle("margin.right", 6)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 16)
				:SetStyle("justifyH", "CENTER")
				:SetText(L["Profession Filters"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "body")
				:SetLayout("VERTICAL")
				:SetStyle("background", "#2e2e2e")
				:SetStyle("padding.top", 15)
				:SetStyle("padding.left", 10)
				:SetStyle("padding.right", 10)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "frame")
					:SetLayout("HORIZONTAL")
					:SetStyle("margin.bottom", 10)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "haveSkillUp")
						:SetStyle("height", 24)
						:SetCheckboxPosition("LEFT")
						:SetText(L["Have Skill Up"])
						:SetStyle("fontHeight", 12)
						:SetStyle("checkboxSpacing", 1)
						:SetChecked(private.haveSkillUp)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "haveMaterials")
						:SetStyle("height", 24)
						:SetCheckboxPosition("LEFT")
						:SetText(L["Have Materials"])
						:SetStyle("fontHeight", 12)
						:SetStyle("checkboxSpacing", 1)
						:SetChecked(private.haveMaterials)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer"))
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "header")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 30)
				:SetStyle("margin", 7)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "applyFilters")
					:SetStyle("height", 25)
					:SetStyle("background", "#585858")
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 16)
					:SetStyle("justifyH", "CENTER")
					:SetText(L["APPLY FILTERS"])
					:SetScript("OnClick", private.ApplyFilters)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "applyFilters")
					:SetStyle("width", 80)
					:SetStyle("height", 20)
					:SetStyle("background", "#272727")
					:SetStyle("margin.left", 20)
					:SetStyle("margin.right", 20)
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 12)
					:SetStyle("justifyH", "CENTER")
					:SetText(L["Reset Filters"])
					:SetScript("OnClick", private.ResetFilters)
				)
			)
	end
end

function private.GetCraftingElements(self, button)
	if button == "profession" then
		private.filterText = ""
		private.professionFrame = TSMAPI_FOUR.UI.NewElement("Frame", "profession")
			:SetLayout("VERTICAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "dropdownFilterFrame")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 20)
				:SetStyle("margin.left", 8)
				:SetStyle("margin.right", 8)
				:SetStyle("margin.bottom", 8)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "professionDropdown")
					:SetStyle("margin.right", 8)
					:SetHintText(L["No Profession Opened"])
					:SetScript("OnSelectionChanged", private.ProfessionDropdownOnSelectionChanged)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "filterBtn")
					:SetStyle("width", 40)
					:SetStyle("height", 14)
					:SetStyle("margin.right", 4)
					:SetStyle("font", TSM.UI.Fonts.MontserratBold)
					:SetStyle("fontHeight", 12)
					:SetStyle("justifyH", "RIGHT")
					:SetText(FILTERS)
					:SetScript("OnClick", private.FilterButtonOnClick)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "filterBtnIcon")
					:SetStyle("width", 14)
					:SetStyle("height", 14)
					:SetStyle("backgroundTexturePack", "iconPack.14x14/Filter")
					:SetScript("OnClick", private.FilterButtonOnClick)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SearchInput", "filterInput")
				:SetStyle("height", 20)
				:SetStyle("margin.left", 8)
				:SetStyle("margin.right", 8)
				:SetStyle("margin.bottom", 8)
				:SetHintText(L["Search Patterns"])
				:SetScript("OnTextChanged", private.FilterSearchInputOnTextChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", 2)
				:SetStyle("color", "#585858")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "recipeContent")
				:SetLayout("VERTICAL")
				:AddChild(TSMAPI_FOUR.UI.NewElement("ProfessionScrollingTable", "recipeList")
					:SetScript("OnSelectionChanged", private.RecipeListOnSelectionChanged)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
					:SetStyle("height", 2)
					:SetStyle("color", "#585858")
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "details")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 138)
					:SetStyle("background", "#2e2e2e")
					:SetStyle("padding", 8)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "left")
						:SetLayout("VERTICAL")
						:SetStyle("width", 194)
						:SetStyle("margin.right", 6)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "title")
							:SetLayout("HORIZONTAL")
							:SetStyle("height", 50)
							:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "icon")
								:SetStyle("width", 32)
								:SetStyle("height", 32)
								:SetStyle("margin.left", 2)
								:SetStyle("margin.right", 8)
								:SetScript("OnClick", private.ItemOnClick)
							)
							:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "name")
								:SetStyle("justifyH", "LEFT")
								:SetStyle("font", TSM.UI.Fonts.FRIZQT)
								:SetStyle("fontHeight", 16)
							)
						)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "num")
							:SetStyle("height", 18)
							:SetStyle("margin.left", 42)
							:SetStyle("margin.bottom", 4)
							:SetStyle("textColor", "#ffffff")
							:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
							:SetStyle("fontHeight", 10)
						)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "error")
							:SetStyle("height", 18)
							:SetStyle("margin.bottom", 8)
							:SetStyle("margin.left", 42)
							:SetStyle("textColor", "#f72d20")
							:SetStyle("font", TSM.UI.Fonts.MontserratBold)
							:SetStyle("fontHeight", 10)
						)
						:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "craftAllBtn")
							:SetStyle("height", 26)
							:SetText(L["CRAFT ALL"])
							:SetScript("OnMouseDown", private.CraftAllBtnOnMouseDown)
							:SetScript("OnClick", private.CraftAllBtnOnClick)
						)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "right")
						:SetLayout("VERTICAL")
						:AddChild(TSMAPI_FOUR.UI.NewElement("CraftingMatList", "matList")
							:SetStyle("height", 90)
							:SetStyle("margin.bottom", 8)
							:SetStyle("rowHeight", 18)
							:SetStyle("borderTexture", "Interface\\Addons\\TradeSkillMaster\\Media\\matListEdgeFrame.blp")
							:SetStyle("borderSize", 8)
							:SetStyle("borderInset", 1)
						)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "buttons")
							:SetLayout("HORIZONTAL")
							:SetStyle("height", 26)
							:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "number")
								:SetLayout("HORIZONTAL")
								:SetStyle("border", "#6d6d6d")
								:SetStyle("borderSize", 1)
								:AddChild(TSMAPI_FOUR.UI.NewElement("InputNumeric", "input")
									:SetStyle("margin.left", 8)
									:SetStyle("margin.right", 12)
									:SetStyle("backgroundTexturePacks", false)
									:SetStyle("background", "#00000000")
									:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
									:SetStyle("fontHeight", 12)
									:SetStyle("textColor", "#ffffff")
									:SetStyle("textInset", 0)
									:SetStyle("justifyH", "CENTER")
									:SetText(1)
									:SetMaxNumber(MAX_NUM_INPUT_VALUE)
								)
								:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "minusBtn")
									:SetStyle("width", 14)
									:SetStyle("height", 14)
									:SetStyle("margin.right", 6)
									:SetStyle("backgroundTexturePack", "iconPack.14x14/Subtract/Default")
									:SetScript("OnClick", private.MinusBtnOnClick)
								)
								:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "plusBtn")
									:SetStyle("width", 14)
									:SetStyle("height", 14)
									:SetStyle("margin.right", 8)
									:SetStyle("backgroundTexturePack", "iconPack.14x14/Add/Default")
									:SetScript("OnClick", private.PlusBtnOnClick)
								)
							)
							:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "craftBtn")
								:SetStyle("width", 90)
								:SetStyle("height", 26)
								:SetStyle("margin.left", 6)
								:SetStyle("margin.right", 6)
								:SetText(L["CRAFT"])
								:SetScript("OnMouseDown", private.CraftBtnOnMouseDown)
								:SetScript("OnClick", private.CraftBtnOnClick)
							)
							:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "queueBtn")
								:SetStyle("width", 90)
								:SetStyle("height", 26)
								:SetText(L["QUEUE"])
								:SetScript("OnClick", private.QueueBtnOnClick)
							)
						)
					)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "recipeListLoadingText")
				:SetStyle("justifyH", "CENTER")
				:SetText(L["Profession loading..."])
			)
			:SetScript("OnHide", private.ProfessionFrameOnHide)
		private.professionFrame:GetElement("recipeContent"):Hide()
		return private.professionFrame
	elseif button == "group" then
		local frame = TSMAPI_FOUR.UI.NewElement("Frame", "group")
			:SetLayout("VERTICAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "search")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 20)
				:SetStyle("margin.left", 8)
				:SetStyle("margin.right", 8)
				:SetStyle("margin.bottom", 8)
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
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", 2)
				:SetStyle("color", "#9d9d9d")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ApplicationGroupTree", "groupTree")
				:SetGroupListFunc(private.GroupTreeGetList)
				:SetSearchString(private.groupSearch)
				:SetContextTable(TSM.db.profile.internalData.craftingGroupTreeContext)
				:SetScript("OnGroupSelectionChanged", private.GroupTreeOnGroupSelectionChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", 2)
				:SetStyle("color", "#9d9d9d")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "addBtn")
				:SetStyle("height", 26)
				:SetStyle("margin", 8)
				:SetText(L["RESTOCK SELECTED GROUPS"])
				:SetScript("OnClick", private.QueueAddBtnOnClick)
			)
		frame:GetElement("addBtn"):SetDisabled(frame:GetElement("groupTree"):IsSelectionCleared())
		return frame
	else
		error("Unexpected button: "..tostring(button))
	end
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FrameOnUpdate(frame)
	-- delay the FSM event by a few frames to give textures a chance to load
	if private.showDelayFrame == SHOW_DELAY_FRAMES then
		frame:SetScript("OnUpdate", nil)
		private.fsm:ProcessEvent("EV_FRAME_SHOW", frame)
	else
		private.showDelayFrame = private.showDelayFrame + 1
	end
end

function private.FrameOnHide()
	private.showDelayFrame = 0
	private.fsm:ProcessEvent("EV_FRAME_HIDE")
end

function private.ProfessionFrameOnHide(frame)
	assert(private.professionFrame == frame)
	private.professionFrame = nil
end

function private.GroupSearchOnTextChanged(input)
	private.groupSearch = strlower(strtrim(input:GetText()))
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
	elseif prevIndex == 4 then
		return 5, L["Create Profession Group"], private.CreateProfessionBtnOnClick
	end
end
function private.MoreBtnOnClick(button)
	button:GetBaseElement():ShowMoreButtonDialog(button, MoreDialogRowIterator)
end

function private.SelectAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.crafting.left.viewContainer.main.content.group.groupTree"):SelectAll()
	baseFrame:HideDialog()
end

function private.DeselectAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.crafting.left.viewContainer.main.content.group.groupTree"):DeselectAll()
	baseFrame:HideDialog()
end

function private.ExpandAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.crafting.left.viewContainer.main.content.group.groupTree"):ExpandAll()
	baseFrame:HideDialog()
end

function private.CollapseAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.crafting.left.viewContainer.main.content.group.groupTree"):CollapseAll()
	baseFrame:HideDialog()
end

function private.CreateProfessionBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	local profName = TSM.Crafting.ProfessionState.GetCurrentProfession()
	local items = profName..TSM.CONST.GROUP_SEP..L["Items"]
	local mats = profName..TSM.CONST.GROUP_SEP..L["Materials"]
	if TSM.Groups.Exists(profName) then
		if not TSM.Groups.Exists(items) then
			TSM.Groups.Create(items)
		end
		if not TSM.Groups.Exists(mats) then
			TSM.Groups.Create(mats)
		end
	else
		TSM.Groups.Create(profName)
		TSM.Groups.Create(items)
		TSM.Groups.Create(mats)
	end

	local numMats, numItems = 0, 0
	local query = TSM.Crafting.CreateRawMatItemQuery()
		:Matches("professions", profName)
		:Select("itemString")

	for _, itemString in query:IteratorAndRelease() do
		local classId = TSMAPI_FOUR.Item.GetClassId(itemString)
		if itemString and not TSM.Groups.IsItemInGroup(itemString) and not TSMAPI_FOUR.Item.IsSoulbound(itemString) and classId ~= LE_ITEM_CLASS_WEAPON and classId ~= LE_ITEM_CLASS_ARMOR then
			TSM.Groups.SetItemGroup(itemString, mats)
			numMats = numMats + 1
		end
	end

	query = TSM.Crafting.ProfessionScanner.CreateQuery()
		:Select("spellId")

	for _, spellId in query:IteratorAndRelease() do
		local itemString = TSM.Crafting.GetItemString(spellId)
		if itemString and not TSM.Groups.IsItemInGroup(itemString) and not TSMAPI_FOUR.Item.IsSoulbound(itemString) then
			TSM.Groups.SetItemGroup(itemString, items)
			numItems = numItems + 1
		end
	end

	if numMats > 0 or numItems > 0 then
		TSM:Printf(L["%s group updated with %d items and %d materials."], profName, numItems, numMats)
	else
		TSM:Printf(L["%s group is already up to date."], profName)
	end

	baseFrame:GetElement("content.crafting.left.viewContainer.main.content.group.groupTree"):UpdateData(true)
	baseFrame:HideDialog()
end

function private.GroupTreeGetList(groups, headerNameLookup)
	TSM.UI.ApplicationGroupTreeGetGroupList(groups, headerNameLookup, "Crafting")
end

function private.GroupTreeOnGroupSelectionChanged(groupTree)
	local addBtn = groupTree:GetElement("__parent.addBtn")
	addBtn:SetDisabled(groupTree:IsSelectionCleared())
	addBtn:Draw()
end

function private.PageToggleOnValueChanged(toggle, value)
	local page = nil
	if value == L["Crafts"] then
		page = "profession"
	elseif value == L["Groups"] then
		page = "group"
	else
		error("Unexpected value: "..tostring(value))
	end
	TSM.UI.AnalyticsRecordPathChange("crafting", "crafting", page)
	toggle:GetElement("__parent.__parent.content"):SetPath(page, true)
	private.fsm:ProcessEvent("EV_PAGE_CHANGED", page)
end

function private.ProfessionDropdownOnSelectionChanged(_, value)
	if not value then
		-- nothing selected
	else
		local key = TSMAPI_FOUR.Util.GetDistinctTableKey(private.professions, value)
		local player, profession = strsplit(KEY_SEP, key)
		if not profession then
			-- the current linked / guild / NPC profession was re-selected, so just ignore this change
			return
		end
		-- TODO: support showing of other player's professions?
		assert(player == UnitName("player"))
		TSM.Crafting.ProfessionUtil.OpenProfession(profession)
	end
end

function private.FilterSearchInputOnTextChanged(input, userInput)
	local text = strtrim(input:GetText())
	if text == private.filterText then
		return
	end
	private.filterText = text
	input:SetText(private.filterText)

	private.fsm:ProcessEvent("EV_RECIPE_FILTER_CHANGED", private.filterText)
end

function private.RecipeListOnSelectionChanged(list)
	local selection = list:GetSelection()
	if not selection then
		return
	end

	if CraftFrame_SetSelection and TSM.Crafting.ProfessionState.IsClassicCrafting() then
		CraftFrame_SetSelection(TSM.Crafting.ProfessionScanner.GetIndexBySpellId(selection))
	end

	private.fsm:ProcessEvent("EV_RECIPE_SELECTION_CHANGED", selection)
	if IsShiftKeyDown() then
		local item = TSM.Crafting.ProfessionUtil.GetRecipeInfo(selection)
		ChatEdit_InsertLink(item)
	end
end

function private.MinusBtnOnClick(button)
	local input = button:GetElement("__parent.input")
	local value = max(input:GetNumber() or 0, 2) - 1
	input:SetText(value)
	input:Draw()
end

function private.PlusBtnOnClick(button)
	local input = button:GetElement("__parent.input")
	local value = min(max(input:GetNumber() or 0, 0) + 1, MAX_NUM_INPUT_VALUE)
	input:SetText(value)
	input:Draw()
end

function private.QueueBtnOnClick(button)
	local value = max(button:GetElement("__parent.number.input"):GetNumber() or 0, 1)
	private.fsm:ProcessEvent("EV_QUEUE_BUTTON_CLICKED", value)
end

function private.ItemOnClick(text)
	local spellId = tonumber(text:GetElement("__parent.name"):GetContext())
	if spellId then
		if TSM.Crafting.ProfessionState.IsClassicCrafting() then
			if IsShiftKeyDown() and ChatEdit_GetActiveWindow() then
				ChatEdit_InsertLink(GetCraftItemLink(TSM.Crafting.ProfessionScanner.GetIndexBySpellId(spellId)))
			end
		else
			if IsShiftKeyDown() and ChatEdit_GetActiveWindow() then
				if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
					ChatEdit_InsertLink(GetTradeSkillItemLink(TSM.Crafting.ProfessionScanner.GetIndexBySpellId(spellId)))
				else
					ChatEdit_InsertLink(C_TradeSkillUI.GetRecipeItemLink(spellId))
				end
			end
		end
	else
		TSMAPI_FOUR.Util.SafeItemRef(TSMAPI_FOUR.Item.GetLink(text:GetElement("__parent.name"):GetContext()))
	end
end

function private.CraftBtnOnMouseDown(button)
	local quantity = max(button:GetElement("__parent.number.input"):GetNumber() or 0, 1)
	private.fsm:ProcessEvent("EV_CRAFT_BUTTON_MOUSE_DOWN", quantity)
end

function private.CraftBtnOnClick(button)
	button:SetPressed(true)
	button:Draw()
	local quantity = max(button:GetElement("__parent.number.input"):GetNumber() or 0, 1)
	private.fsm:ProcessEvent("EV_CRAFT_BUTTON_CLICKED", quantity)
end

function private.CraftAllBtnOnMouseDown(button)
	private.fsm:ProcessEvent("EV_CRAFT_BUTTON_MOUSE_DOWN", math.huge)
end

function private.CraftAllBtnOnClick(button)
	button:SetPressed(true)
	button:Draw()
	private.fsm:ProcessEvent("EV_CRAFT_BUTTON_CLICKED", math.huge)
end

function private.QueueOnRowClick(button, data, mouseButton)
	local spellId = data:GetField("spellId")
	if mouseButton == "RightButton" then
		private.fsm:ProcessEvent("EV_QUEUE_RIGHT_CLICKED", spellId)
	elseif TSM.Crafting.ProfessionScanner.HasSpellId(spellId) then
		private.fsm:ProcessEvent("EV_CRAFT_NEXT_BUTTON_CLICKED", spellId, TSM.Crafting.Queue.GetNum(spellId))
	end
end

function private.CraftNextOnClick(button)
	button:SetPressed(true)
	button:Draw()
	local spellId = button:GetElement("__parent.__parent.queueList"):GetFirstData():GetField("spellId")
	private.fsm:ProcessEvent("EV_CRAFT_NEXT_BUTTON_CLICKED", spellId, TSM.Crafting.Queue.GetNum(spellId))
end

function private.ClearOnClick(button)
	TSM.Crafting.Queue.Clear()
	button:GetElement("__parent.__parent.queueCost.text"):SetText("")
		:Draw()
	button:GetElement("__parent.__parent.queueProfit.text"):SetText("")
		:Draw()
	button:GetElement("__parent.craftNextBtn"):SetDisabled(true)
		:Draw()
end

function private.QueueAddBtnOnClick(button)
	local groups = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, groupPath in button:GetElement("__parent.groupTree"):SelectedGroupsIterator() do
		tinsert(groups, groupPath)
	end
	TSM.Crafting.Queue.RestockGroups(groups)
	TSMAPI_FOUR.Util.ReleaseTempTable(groups)
end

function private.HandleOnTitleClick(button)
	if IsShiftKeyDown() then
		local data = button:GetContext()
		ChatEdit_InsertLink(TSMAPI_FOUR.Item.GetLink(data))
	end
end

function private.FilterButtonOnClick(button)
	private.fsm:ProcessEvent("EV_PAGE_CHANGED", "filters")
	button:GetElement("__parent.__parent.__parent.__parent.__parent"):SetPath("filters", true)
end

function private.BackToCraftingListButton(button)
	button:GetElement("__parent.__parent.__parent"):SetPath("main", true)
	private.fsm:ProcessEvent("EV_PAGE_CHANGED", "profession")
end

function private.ApplyFilters(button)
	local body = button:GetParentElement():GetParentElement():GetElement("body")
	private.haveSkillUp = body:GetElement("frame"):GetElement("haveSkillUp"):IsChecked()
	private.haveMaterials = body:GetElement("frame"):GetElement("haveMaterials"):IsChecked()
	button:GetElement("__parent.__parent.__parent"):SetPath("main", true)
	private.fsm:ProcessEvent("EV_PAGE_CHANGED", "profession")
	private.fsm:ProcessEvent("EV_RECIPE_FILTER_CHANGED", private.filterText)
end

function private.ResetFilters(button)
	local body = button:GetParentElement():GetParentElement():GetElement("body")
	body:GetElement("frame"):GetElement("haveSkillUp"):SetChecked(false)
	body:GetElement("frame"):GetElement("haveMaterials"):SetChecked(false)
	private.ApplyFilters(button)
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.FSMCreate()
	local fsmContext = {
		frame = nil,
		recipeQuery = nil,
		professionQuery = nil,
		page = "profession",
		selectedRecipeSpellId = nil,
		queueQuery = nil,
		craftingSpellId = nil,
		craftingType = nil,
		craftingQuantity = nil,
	}

	TSMAPI_FOUR.Event.Register("BAG_UPDATE_DELAYED", function()
		private.fsm:ProcessEvent("EV_BAG_UPDATE_DELAYED")
	end)

	TSM.Crafting.ProfessionState.RegisterUpdateCallback(function()
		private.fsm:ProcessEvent("EV_PROFESSION_STATE_UPDATE")
	end)
	TSM.Crafting.ProfessionScanner.RegisterHasScannedCallback(function()
		private.fsm:ProcessEvent("EV_PROFESSION_STATE_UPDATE")
	end)

	local fsmPrivate = {
		success = nil,
		isDone = nil,
	}
	local function CraftCallback()
		private.fsm:ProcessEvent("EV_SPELLCAST_COMPLETE", fsmPrivate.success, fsmPrivate.isDone)
		fsmPrivate.success = nil
		fsmPrivate.isDone = nil
	end
	function fsmPrivate.CraftCallback(success, isDone)
		fsmPrivate.success = success
		fsmPrivate.isDone = isDone
		TSMAPI_FOUR.Delay.AfterFrame(1, CraftCallback)
	end
	function fsmPrivate.QueueUpdateCallback()
		private.fsm:ProcessEvent("EV_QUEUE_UPDATE")
	end
	function fsmPrivate.SkillUpdateCallback()
		private.fsm:ProcessEvent("EV_SKILL_UPDATE")
	end
	function fsmPrivate.UpdateMaterials(context)
		if context.page == "profession" then
			context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.recipeList"):UpdateData(true)
			context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.details.right.matList"):UpdateData(true)
		end
		fsmPrivate.UpdateCraftButtons(context)
	end
	function fsmPrivate.UpdateSkills(context)
		if context.page ~= "profession" then
			return
		end

		-- update the professions dropdown info
		local dropdownSelection = nil
		local currentProfession = TSM.Crafting.ProfessionState.GetCurrentProfession()
		local isCurrentProfessionPlayer = private.IsPlayerProfession()
		wipe(private.professions)
		wipe(private.professionsOrder)
		if currentProfession and not isCurrentProfessionPlayer then
			assert(WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC)
			local playerName = nil
			local linked, linkedName = TSM.Crafting.ProfessionUtil.IsLinkedProfession()
			if linked then
				playerName = linkedName or "?"
			elseif TSM.Crafting.ProfessionUtil.IsNPCProfession() then
				playerName = L["NPC"]
			elseif TSM.Crafting.ProfessionUtil.IsGuildProfession() then
				playerName = L["Guild"]
			end
			assert(playerName)
			local key = currentProfession
			tinsert(private.professionsOrder, key)
			private.professions[key] = format("%s - %s", currentProfession, playerName)
			dropdownSelection = key
		end

		for _, player, profession, level, maxLevel in TSM.Crafting.PlayerProfessions.Iterator() do
			-- TODO: support showing of other player's professions?
			if player == UnitName("player") then
				local key = player..KEY_SEP..profession
				tinsert(private.professionsOrder, key)
				private.professions[key] = format("%s %d/%d - %s", profession, level, maxLevel, player)
				if isCurrentProfessionPlayer and profession == currentProfession then
					assert(not dropdownSelection)
					dropdownSelection = key
				end
			end
		end

		context.frame:GetElement("left.viewContainer.main.content.profession.dropdownFilterFrame.professionDropdown")
			:SetDictionaryItems(private.professions, private.professions[dropdownSelection], private.professionsOrder, true)
			:Draw()
	end
	function fsmPrivate.UpdateContentPage(context)
		if context.page ~= "profession" and context.page ~= "filters" then
			-- nothing to update
			return
		end

		-- update the professions dropdown info
		local dropdownSelection = nil
		local currentProfession = TSM.Crafting.ProfessionState.GetCurrentProfession()
		local isCurrentProfessionPlayer = private.IsPlayerProfession()
		wipe(private.professions)
		wipe(private.professionsOrder)
		if currentProfession and not isCurrentProfessionPlayer then
			assert(WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC)
			local playerName = nil
			local linked, linkedName = TSM.Crafting.ProfessionUtil.IsLinkedProfession()
			if linked then
				playerName = linkedName or "?"
			elseif TSM.Crafting.ProfessionUtil.IsNPCProfession() then
				playerName = L["NPC"]
			elseif TSM.Crafting.ProfessionUtil.IsGuildProfession() then
				playerName = L["Guild"]
			end
			assert(playerName)
			local key = currentProfession
			tinsert(private.professionsOrder, key)
			private.professions[key] = format("%s - %s", currentProfession, playerName)
			dropdownSelection = key
		end

		for _, player, profession, level, maxLevel in TSM.Crafting.PlayerProfessions.Iterator() do
			-- TODO: support showing of other player's professions?
			if player == UnitName("player") then
				local key = player..KEY_SEP..profession
				tinsert(private.professionsOrder, key)
				private.professions[key] = format("%s %d/%d - %s", profession, level, maxLevel, player)
				if isCurrentProfessionPlayer and profession == currentProfession then
					assert(not dropdownSelection)
					dropdownSelection = key
				end
			end
		end

		context.frame:GetElement("left.viewContainer.main.content.profession.dropdownFilterFrame.professionDropdown")
			:SetDictionaryItems(private.professions, private.professions[dropdownSelection], private.professionsOrder, true)
			:Draw()

		local craftingContentFrame = context.frame:GetElement("left.viewContainer.main.content.profession")
		if not private.IsProfessionLoaded() then
			local text = nil
			if private.IsProfessionClosed() then
				text = L["No Profession Selected"]
			elseif private.IsProfessionLoadedNoSkills() then
				text = L["No Crafts"]
			else
				text = L["Loading..."]
			end
			craftingContentFrame:GetElement("recipeContent"):Hide()
			craftingContentFrame:GetElement("recipeListLoadingText")
				:SetText(text)
				:Show()
			craftingContentFrame:Draw()
			return
		end

		local recipeContent = craftingContentFrame:GetElement("recipeContent")
		local recipeList = recipeContent:GetElement("recipeList")
		recipeContent:Show()
		craftingContentFrame:GetElement("recipeListLoadingText"):Hide()

		recipeList:SetQuery(fsmContext.recipeQuery)
		recipeList:UpdateData()
		if recipeList:GetSelection() ~= context.selectedRecipeSpellId then
			recipeList:SetSelection(context.selectedRecipeSpellId)
		end
		local resultName, resultItemString, resultTexture = TSM.Crafting.ProfessionUtil.GetResultInfo(context.selectedRecipeSpellId)
		local detailsFrame = recipeContent:GetElement("details")
		-- engineer tinkers can't be crafted, multi-crafted or queued
		if not resultItemString then
			detailsFrame:GetElement("right.buttons.craftBtn")
				:SetText(currentProfession == GetSpellInfo(7411) and L["ENCHANT"] or L["TINKER"])
			detailsFrame:GetElement("right.buttons.queueBtn")
				:Hide()
			detailsFrame:GetElement("right.buttons.number")
				:Hide()
			detailsFrame:GetElement("left.craftAllBtn")
				:Hide()
		else
			detailsFrame:GetElement("right.buttons.craftBtn")
				:SetText(L["CRAFT"])
			detailsFrame:GetElement("right.buttons.queueBtn")
				:Show()
			detailsFrame:GetElement("right.buttons.number")
				:Show()
			detailsFrame:GetElement("left.craftAllBtn")
				:Show()
		end
		detailsFrame:GetElement("left.title.name")
			:SetText(resultName)
			:SetContext(resultItemString or tostring(context.selectedRecipeSpellId))
		detailsFrame:GetElement("left.title.icon")
			:SetStyle("backgroundTexture", resultTexture)
			:SetTooltip(resultItemString or tostring(context.selectedRecipeSpellId))
		detailsFrame:GetElement("left.num")
			:SetFormattedText(L["Crafts %d"], TSM.Crafting.GetNumResult(context.selectedRecipeSpellId))
		local _, _, _, toolsStr, hasTools = TSM.Crafting.ProfessionUtil.GetRecipeInfo(context.selectedRecipeSpellId)
		local errorText = detailsFrame:GetElement("left.error")
		local canCraft = false
		if toolsStr and not hasTools then
			errorText:SetText(REQUIRES_LABEL..toolsStr)
		elseif (not toolsStr or hasTools) and TSM.Crafting.ProfessionUtil.GetNumCraftable(context.selectedRecipeSpellId) == 0 then
			errorText:SetText(L["Missing Materials"])
		elseif TSM.Crafting.ProfessionUtil.GetRemainingCooldown(context.selectedRecipeSpellId) then
			errorText:SetText(L["On Cooldown"])
		else
			canCraft = true
			errorText:SetText("")
		end
		local isEnchant = TSM.Crafting.ProfessionUtil.IsEnchant(context.selectedRecipeSpellId)
		detailsFrame:GetElement("right.buttons.craftBtn")
			:SetDisabled(not canCraft or context.craftingSpellId)
			:SetPressed(context.craftingSpellId and context.craftingType == "craft")
		detailsFrame:GetElement("left.craftAllBtn")
			:SetText(isEnchant and L["Enchant Vellum"] or L["Craft All"])
			:SetDisabled(not canCraft or context.craftingSpellId)
			:SetPressed(context.craftingSpellId and context.craftingType == "all")
		detailsFrame:GetElement("right.matList")
			:SetRecipe(context.selectedRecipeSpellId)
			:SetContext(context.selectedRecipeSpellId)
		craftingContentFrame:Draw()
		if TSM.Crafting.ProfessionState.IsClassicCrafting() and CraftCreateButton then
			CraftCreateButton:SetParent(detailsFrame:GetElement("right.buttons.craftBtn"):_GetBaseFrame())
			CraftCreateButton:ClearAllPoints()
			CraftCreateButton:SetAllPoints(detailsFrame:GetElement("right.buttons.craftBtn"):_GetBaseFrame())
			CraftCreateButton:SetFrameLevel(200)
			CraftCreateButton:DisableDrawLayer("BACKGROUND")
			CraftCreateButton:DisableDrawLayer("ARTWORK")
			CraftCreateButton:SetHighlightTexture(nil)
			if canCraft then
				CraftCreateButton:Enable()
			else
				CraftCreateButton:Disable()
			end
		end
	end
	function fsmPrivate.UpdateQueueFrame(context)
		local queueFrame = context.frame:GetElement("right.queue")
		local totalCost, totalProfit = TSM.Crafting.Queue.GetTotalCostAndProfit()
		local totalCostText = totalCost and TSM.Money.ToString(totalCost) or ""
		queueFrame:GetElement("queueCost.text"):SetText(totalCostText)
		local totalProfitText = totalProfit and TSM.Money.ToString(totalProfit, totalProfit >= 0 and "|cff2cec0d" or "|cffd50000") or ""
		queueFrame:GetElement("queueProfit.text"):SetText(totalProfitText)
		queueFrame:GetElement("queueList"):Draw()

		local professionLoaded = private.IsProfessionLoaded()
		local nextCraftRecord = queueFrame:GetElement("queueList"):GetFirstData()
		local nextCraftSpellId = nextCraftRecord and nextCraftRecord:GetField("spellId")
		if nextCraftRecord and (not professionLoaded or not TSM.Crafting.ProfessionScanner.HasSpellId(nextCraftSpellId) or TSM.Crafting.ProfessionUtil.GetNumCraftable(nextCraftSpellId) == 0) then
			nextCraftRecord = nil
		end
		local canCraftFromQueue = professionLoaded and private.IsPlayerProfession()
		queueFrame:GetElement("craft.craftNextBtn")
			:SetDisabled(not canCraftFromQueue or not nextCraftRecord or context.craftingSpellId)
			:SetPressed(context.craftingSpellId and context.craftingType == "queue")
		if nextCraftRecord and canCraftFromQueue then
			TSM.Crafting.ProfessionUtil.PrepareToCraft(nextCraftSpellId, nextCraftRecord:GetField("num"))
		end
		queueFrame:Draw()
	end
	function fsmPrivate.UpdateCraftButtons(context)
		if context.page == "profession" and private.IsProfessionLoaded() then
			local _, _, _, toolsStr, hasTools = TSM.Crafting.ProfessionUtil.GetRecipeInfo(context.selectedRecipeSpellId)
			local detailsFrame = context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.details")
			local errorText = detailsFrame:GetElement("left.error")
			local canCraft = false
			if toolsStr and not hasTools then
				errorText:SetText(REQUIRES_LABEL..toolsStr)
			elseif (not toolsStr or hasTools) and TSM.Crafting.ProfessionUtil.GetNumCraftable(context.selectedRecipeSpellId) == 0 then
				errorText:SetText(L["Missing Materials"])
			else
				canCraft = true
				errorText:SetText("")
			end
			errorText:Draw()
			local isEnchant = TSM.Crafting.ProfessionUtil.IsEnchant(context.selectedRecipeSpellId)
			detailsFrame:GetElement("right.buttons.craftBtn")
				:SetPressed(context.craftingSpellId and context.craftingType == "craft")
				:SetDisabled(not canCraft or context.craftingSpellId)
				:Draw()
			detailsFrame:GetElement("left.craftAllBtn")
				:SetText(isEnchant and L["Enchant Vellum"] or L["Craft All"])
				:SetPressed(context.craftingSpellId and context.craftingType == "all")
				:SetDisabled(not canCraft or context.craftingSpellId)
				:Draw()
			if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and CraftCreateButton then
				if canCraft then
					CraftCreateButton:Enable()
				else
					CraftCreateButton:Disable()
				end
			end
		end

		local nextCraftRecord = context.frame:GetElement("right.queue.queueList"):GetFirstData()
		if nextCraftRecord and (TSM.Crafting.GetProfession(nextCraftRecord:GetField("spellId")) ~= TSM.Crafting.ProfessionState.GetCurrentProfession() or TSM.Crafting.ProfessionUtil.GetNumCraftable(nextCraftRecord:GetField("spellId")) == 0) then
			nextCraftRecord = nil
		end
		local canCraftFromQueue = private.IsProfessionLoaded() and private.IsPlayerProfession()
		context.frame:GetElement("right.queue.craft.craftNextBtn")
			:SetPressed(context.craftingSpellId and context.craftingType == "queue")
			:SetDisabled(not canCraftFromQueue or not nextCraftRecord or context.craftingSpellId)
			:Draw()
	end
	function fsmPrivate.StartCraft(context, spellId, quantity)
		local numCrafted = TSM.Crafting.ProfessionUtil.Craft(spellId, quantity, context.craftingType ~= "craft", fsmPrivate.CraftCallback)
		TSM:LOG_INFO("Crafting %d (requested %s) of %d", numCrafted, quantity == math.huge and "all" or quantity, spellId)
		if numCrafted == 0 then
			return
		end
		context.craftingSpellId = spellId
		context.craftingQuantity = numCrafted
		fsmPrivate.UpdateCraftButtons(context)
	end

	private.fsm = TSMAPI_FOUR.FSM.New("CRAFTING_UI_CRAFTING")
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_FRAME_CLOSED")
			:SetOnEnter(function(context)
				context.page = "profession"
				context.frame = nil
				context.craftingSpellId = nil
				context.craftingQuantity = nil
				context.craftingType = nil
				if not context.queueQuery then
					context.queueQuery = TSM.Crafting.Queue.CreateQuery()
					context.queueQuery:SetUpdateCallback(fsmPrivate.QueueUpdateCallback)
				end
			end)
			:AddTransition("ST_FRAME_CLOSED")
			:AddTransition("ST_FRAME_OPEN_NO_PROFESSION")
			:AddTransition("ST_FRAME_OPEN_WITH_PROFESSION")
			:AddEvent("EV_FRAME_SHOW", function(context, frame)
				context.frame = frame
				if private.IsProfessionLoaded() then
					return "ST_FRAME_OPEN_WITH_PROFESSION"
				else
					return "ST_FRAME_OPEN_NO_PROFESSION"
				end
			end)
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_FRAME_OPEN_NO_PROFESSION")
			:SetOnEnter(function(context)
				fsmPrivate.UpdateContentPage(context)
				fsmPrivate.UpdateQueueFrame(context)
			end)
			:AddTransition("ST_FRAME_OPEN_NO_PROFESSION")
			:AddTransition("ST_FRAME_OPEN_WITH_PROFESSION")
			:AddTransition("ST_FRAME_CLOSED")
			:AddEvent("EV_PROFESSION_STATE_UPDATE", function(context)
				if private.IsProfessionLoaded() then
					return "ST_FRAME_OPEN_WITH_PROFESSION"
				end
				fsmPrivate.UpdateContentPage(context)
			end)
			:AddEvent("EV_PAGE_CHANGED", function(context, page)
				context.page = page
				fsmPrivate.UpdateContentPage(context)
			end)
			:AddEvent("EV_QUEUE_UPDATE", function(context)
				fsmPrivate.UpdateQueueFrame(context)
			end)
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_FRAME_OPEN_WITH_PROFESSION")
			:SetOnEnter(function(context)
				context.recipeQuery = TSM.Crafting.ProfessionScanner.CreateQuery()
					:Select("spellId", "categoryId")
					:OrderBy("index", true)
					:VirtualField("matNames", "string", TSM.Crafting.GetMatNames, "spellId")
				context.professionQuery = TSM.Crafting.PlayerProfessions.CreateQuery()
				context.professionQuery:SetUpdateCallback(fsmPrivate.SkillUpdateCallback)
				if context.page == "profession" then
					private.filterText = ""
				end
				context.selectedRecipeSpellId = TSM.Crafting.ProfessionScanner.GetFirstSpellId()

				assert(context.selectedRecipeSpellId)
				fsmPrivate.UpdateContentPage(context)
				fsmPrivate.UpdateQueueFrame(context)
			end)
			:SetOnExit(function(context)
				context.selectedRecipeSpellId = nil
				context.recipeQuery:Release()
				context.recipeQuery = nil
				context.professionQuery:Release()
				context.professionQuery = nil
			end)
			:AddTransition("ST_FRAME_OPEN_NO_PROFESSION")
			:AddTransition("ST_FRAME_CLOSED")
			:AddEvent("EV_PROFESSION_STATE_UPDATE", function(context)
				if not private.IsProfessionLoaded() then
					return "ST_FRAME_OPEN_NO_PROFESSION"
				end
				fsmPrivate.UpdateContentPage(context)
			end)
			:AddEvent("EV_RECIPE_FILTER_CHANGED", function(context, filter)
				context.recipeQuery:Reset()
					:Select("spellId", "categoryId")
					:OrderBy("index", true)
					:VirtualField("matNames", "string", TSM.Crafting.GetMatNames, "spellId")
				if filter ~= "" then
					filter = TSMAPI_FOUR.Util.StrEscape(filter)
					context.recipeQuery
						:Or()
							:Matches("name", filter)
							:Matches("matNames", filter)
						:End()
				end
				if private.haveSkillUp then
					context.recipeQuery:NotEqual("difficulty", "trivial")
				end
				if private.haveMaterials then
					context.recipeQuery:Custom(private.HaveMaterialsFilterHelper)
				end
				context.frame:GetElement("left.viewContainer.main.content.profession.recipeContent.recipeList"):UpdateData(true)
			end)
			:AddEvent("EV_PAGE_CHANGED", function(context, page)
				context.recipeQuery:ResetFilters()
				context.page = page
				fsmPrivate.UpdateContentPage(context)
			end)
			:AddEvent("EV_QUEUE_BUTTON_CLICKED", function(context, quantity)
				assert(context.selectedRecipeSpellId)
				TSM.Crafting.Queue.Add(context.selectedRecipeSpellId, quantity)
				fsmPrivate.UpdateQueueFrame(context)
			end)
			:AddEvent("EV_QUEUE_RIGHT_CLICKED", function(context, spellId)
				if context.page ~= "profession" or TSM.Crafting.GetProfession(spellId) ~= TSM.Crafting.ProfessionState.GetCurrentProfession() then
					return
				end
				context.selectedRecipeSpellId = spellId
				fsmPrivate.UpdateContentPage(context)
			end)
			:AddEvent("EV_RECIPE_SELECTION_CHANGED", function(context, spellId)
				context.selectedRecipeSpellId = spellId
				fsmPrivate.UpdateContentPage(context)
			end)
			:AddEvent("EV_BAG_UPDATE_DELAYED", function(context)
				fsmPrivate.UpdateMaterials(context)
			end)
			:AddEvent("EV_QUEUE_UPDATE", function(context)
				fsmPrivate.UpdateQueueFrame(context)
			end)
			:AddEvent("EV_SKILL_UPDATE", function(context)
				fsmPrivate.UpdateSkills(context)
			end)
			:AddEvent("EV_CRAFT_BUTTON_MOUSE_DOWN", function(context, quantity)
				context.craftingType = quantity == math.huge and "all" or "craft"
				TSM.Crafting.ProfessionUtil.PrepareToCraft(context.selectedRecipeSpellId, quantity)
			end)
			:AddEvent("EV_CRAFT_BUTTON_CLICKED", function(context, quantity)
				context.craftingType = quantity == math.huge and "all" or "craft"
				fsmPrivate.StartCraft(context, context.selectedRecipeSpellId, quantity)
			end)
			:AddEvent("EV_CRAFT_NEXT_BUTTON_CLICKED", function(context, spellId, quantity)
				context.craftingType = "queue"
				fsmPrivate.StartCraft(context, spellId, quantity)
			end)
			:AddEvent("EV_SPELLCAST_COMPLETE", function(context, success, isDone)
				if success then
					TSM:LOG_INFO("Crafted %d", context.craftingSpellId)
					TSM.Crafting.Queue.Remove(context.craftingSpellId, 1)
					context.craftingQuantity = context.craftingQuantity - 1
					assert(context.craftingQuantity >= 0)
					if context.craftingQuantity == 0 then
						assert(isDone)
						context.craftingSpellId = nil
						context.craftingQuantity = nil
						context.craftingType = nil
					end
				else
					context.craftingSpellId = nil
					context.craftingQuantity = nil
					context.craftingType = nil
				end
				fsmPrivate.UpdateCraftButtons(context)
				fsmPrivate.UpdateQueueFrame(context)
			end)
		)
		:AddDefaultEvent("EV_FRAME_HIDE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_FRAME_CLOSED"))
		:Init("ST_FRAME_CLOSED", fsmContext)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.IsProfessionClosed()
	return TSM.Crafting.ProfessionState.GetIsClosed()
end

function private.IsProfessionLoadedNoSkills()
	return not private.IsProfessionClosed() and TSM.Crafting.ProfessionState.GetCurrentProfession() and TSM.Crafting.ProfessionScanner.HasScanned() and not TSM.Crafting.ProfessionScanner.HasSkills()
end

function private.IsProfessionLoaded()
	return not private.IsProfessionClosed() and TSM.Crafting.ProfessionState.GetCurrentProfession() and TSM.Crafting.ProfessionScanner.HasScanned() and TSM.Crafting.ProfessionScanner.HasSkills()
end

function private.IsPlayerProfession()
	return not (TSM.Crafting.ProfessionUtil.IsNPCProfession() or TSM.Crafting.ProfessionUtil.IsLinkedProfession() or TSM.Crafting.ProfessionUtil.IsGuildProfession())
end

function private.HaveMaterialsFilterHelper(row)
	return TSM.Crafting.ProfessionUtil.GetNumCraftable(row:GetField("spellId")) > 0
end

function private.ItemLinkedCallback(name, itemLink)
	if not private.professionFrame then
		return
	end
	private.professionFrame:GetElement("filterInput")
		:SetText(name)
		:Draw()
	return true
end
