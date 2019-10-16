-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Shopping = TSM.UI.AuctionUI:NewPackage("Shopping")
local L = TSM.L
local private = {
	singleItemSearchType = "normal",
	fsm = nil,
	rarityList = nil,
	frame = nil,
	hasLastScan = false,
	contentPath = "selection",
	selectedGroups = {},
	groupSearch = "",
	itemInfo = {
		itemString = nil,
		seller = nil,
		stackSize = nil,
		displayedBid = nil,
		buyout = nil,
	},
	itemString = nil,
	postQuantity = nil,
	postStack = nil,
	postTimeStr = nil,
	perItem = true,
	updateCallbacks = {},
}
local SINGLE_ITEM_SEARCH_TYPES = {
	normal = "|cffffd839" .. L["Normal"] .. "|r",
	crafting = "|cffffd839" .. L["Crafting"] .. "|r"
}
local SINGLE_ITEM_SEARCH_TYPES_ORDER = { "normal", "crafting" }
local MAX_ITEM_LEVEL = 1000
local DEFAULT_DIVIDED_CONTAINER_CONTEXT = {
	leftWidth = 272,
}
local DEFAULT_TAB_GROUP_CONTEXT = {
	pathIndex = 1
}
local PLAYER_NAME = UnitName("player")
local POST_TIME_STRS = {
	WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and L["2 hr"] or L["12 hr"],
	WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and L["8 hr"] or L["24 hr"],
	WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and L["24 hr"] or L["48 hr"],
}
local function NoOp()
	-- do nothing - what did you expect?
end
-- TODO: this should eventually go in the saved variables
private.dividedContainerContext = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Shopping.OnInitialize()
	private.postTimeStr = POST_TIME_STRS[2]
	TSM.UI.AuctionUI.RegisterTopLevelPage(L["Shopping"], "iconPack.24x24/Shopping", private.GetShoppingFrame, private.OnItemLinked)
	private.FSMCreate()
end

function Shopping.StartGatheringSearch(items, stateCallback, buyCallback, mode)
	assert(Shopping.IsVisible())
	private.frame:SetPath("selection")
	private.StartGatheringSearchHelper(private.frame, items, stateCallback, buyCallback, mode)
end

function Shopping.StartItemSearch(item)
	private.OnItemLinked(TSMAPI_FOUR.Item.GetName(item), item)
end

function Shopping.IsVisible()
	return TSM.UI.AuctionUI.IsPageOpen(L["Shopping"])
end

function Shopping.RegisterUpdateCallback(callback)
	tinsert(private.updateCallbacks, callback)
end



-- ============================================================================
-- Shopping UI
-- ============================================================================

function private.GetShoppingFrame()
	TSM.UI.AnalyticsRecordPathChange("auction", "shopping")
	if not private.hasLastScan then
		private.contentPath = "selection"
	end
	local frame = TSMAPI_FOUR.UI.NewElement("ViewContainer", "shopping")
		:SetNavCallback(private.GetShoppingContentFrame)
		:AddPath("selection")
		:AddPath("scan")
		:SetPath(private.contentPath)
		:SetScript("OnHide", private.FrameOnHide)
	private.frame = frame
	for _, callback in ipairs(private.updateCallbacks) do
		callback()
	end
	return frame
end

function private.GetShoppingContentFrame(viewContainer, path)
	private.contentPath = path
	if path == "selection" then
		return private.GetSelectionFrame()
	elseif path == "scan" then
		return private.GetScanFrame()
	else
		error("Unexpected path: "..tostring(path))
	end
end

function private.GetSelectionFrame()
	TSM.UI.AnalyticsRecordPathChange("auction", "shopping", "selection")
	local frame = TSMAPI_FOUR.UI.NewElement("DividedContainer", "selection")
		:SetStyle("background", "#272727")
		:SetContextTable(private.dividedContainerContext, DEFAULT_DIVIDED_CONTAINER_CONTEXT)
		:SetMinWidth(250, 250)
		:SetLeftChild(TSMAPI_FOUR.UI.NewElement("Frame", "groupSelection")
			:SetLayout("VERTICAL")
			:SetStyle("padding", { top = 21 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "title")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 44)
				:SetStyle("padding", { top = 12, bottom = 12, left = 8, right = 8 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("SearchInput", "search")
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
				:SetContextTable(TSM.db.profile.internalData.shoppingGroupTreeContext)
				:SetSearchString(private.groupSearch)
				:SetScript("OnGroupSelectionChanged", private.GroupTreeOnGroupSelectionChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", 2)
				:SetStyle("color", "#9d9d9d")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "scanBtn")
				:SetStyle("height", 26)
				:SetStyle("margin", 12)
				:SetText(L["RUN SHOPPING SCAN"])
				:SetDisabled(true)
				:SetScript("OnClick", private.ScanButtonOnClick)
			)
		)
		:SetRightChild(TSMAPI_FOUR.UI.NewElement("ViewContainer", "content")
			:SetNavCallback(private.GetSelectionContent)
			:AddPath("search", true)
			:AddPath("advanced")
		)
		:SetScript("OnUpdate", private.SelectionFrameOnUpdate)

	return frame
end

function private.SelectionFrameOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)
	frame:GetBaseElement():SetBottomPadding(nil)
	frame:GetElement("groupSelection.scanBtn"):SetDisabled(frame:GetElement("groupSelection.groupTree"):IsSelectionCleared(true)):Draw()
end

function private.GetSelectionContent(viewContainer, path)
	if path == "search" then
		return private.GetSelectionSearchFrame()
	elseif path == "advanced" then
		return private.GetAdvancedFrame()
	else
		error("Unexpected path: "..tostring(path))
	end
end

function private.GetSelectionSearchFrame()
	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "search")
		:SetStyle("padding", { top = 43, left = 8, right = 8, bottom = 8 })
		:AddChild(TSMAPI_FOUR.UI.NewElement("TabGroup", "buttons")
			:SetStyle("height", 152)
			:SetStyle("margin", { left = -8, right = -8 })
			:SetNavCallback(private.GetSearchesElement)
			:SetContextTable(TSM.db.profile.internalData.shoppingTabGroupContext, DEFAULT_TAB_GROUP_CONTEXT)
			:AddPath(L["Recent Searches"])
			:AddPath(L["Favorite Searches"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
			:SetStyle("height", 2)
			:SetStyle("margin", { left = -8, right = -8 })
			:SetStyle("color", "#9d9d9d")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "itemHeader")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 22)
			:SetStyle("margin", { top = 16, bottom = 4 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
				:SetStyle("font", TSM.UI.Fonts.MontserratBold)
				:SetStyle("fontHeight", 16)
				:SetStyle("autoWidth", true)
				:SetText(L["Filter Shopping"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "dropdown")
				:SetStyle("width", 80)
				:SetStyle("height", 14)
				:SetStyle("margin.left", 8)
				:SetStyle("background", "#00000000")
				:SetStyle("border", "#00000000")
				:SetStyle("font", TSM.UI.Fonts.MontserratBold)
				:SetStyle("fontHeight", 11)
				:SetStyle("openFont", TSM.UI.Fonts.MontserratBold)
				:SetStyle("openFontHeight", 11)
				:SetDictionaryItems(SINGLE_ITEM_SEARCH_TYPES, SINGLE_ITEM_SEARCH_TYPES[private.singleItemSearchType], SINGLE_ITEM_SEARCH_TYPES_ORDER)
				:SetSettingInfo(private, "singleItemSearchType")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
			:SetStyle("height", 14)
			:SetStyle("fontHeight", 11)
			:SetText(L["Use the field below to search the auction house by filter"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "filterInput")
			:SetStyle("height", 26)
			:SetStyle("margin", { top = 16, bottom = 16 })
			:SetStyle("background", "#525252")
			:SetStyle("border", "#9d9d9d")
			:SetStyle("borderSize", 2)
			:SetStyle("fontHeight", 11)
			:SetStyle("textColor", "#e2e2e2")
			:SetStyle("hintJustifyH", "LEFT")
			:SetStyle("hintTextColor", "#e2e2e2")
			:SetHintText(L["Enter Filter"])
			:SetScript("OnEnterPressed", private.FilterSearchInputOnEnterPressed)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "advanced")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 18)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "textBtn")
				:SetStyle("font", TSM.UI.Fonts.MontserratBold)
				:SetStyle("fontHeight", 11)
				:SetStyle("autoWidth", true)
				:SetText(L["Advanced Item Search"])
				:SetScript("OnClick", private.AdvancedButtonOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "iconBtn")
				:SetStyle("width", 18)
				:SetStyle("height", 18)
				:SetStyle("backgroundTexturePack", "iconPack.18x18/Chevron/Collapsed")
				:SetScript("OnClick", private.AdvancedButtonOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
			:SetStyle("height", 22)
			:SetStyle("margin.top", 27)
			:SetStyle("font", TSM.UI.Fonts.MontserratBold)
			:SetStyle("fontHeight", 16)
			:SetText(L["Other Shopping Searches"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "buttonsLine1")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin", { top = 16, bottom = 16 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "dealsBtn")
				:SetStyle("margin.right", 16)
				:SetText(L["GREAT DEALS SEARCH"])
				:SetDisabled(not TSM.Shopping.GreatDealsSearch.GetFilter())
				:SetScript("OnClick", private.DealsButtonOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "vendorBtn")
				:SetText(L["VENDOR SEARCH"])
				:SetScript("OnClick", private.VendorButtonOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "buttonsLine1")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "disenchantBtn")
				:SetStyle("margin.right", 16)
				:SetText(L["DISENCHANT SEARCH"])
				:SetScript("OnClick", private.DisenchantButtonOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
		)
end

function private.GetAdvancedFrame()
	if not private.rarityList then
		private.rarityList = {}
		for i = 1, 7 do
			tinsert(private.rarityList, _G["ITEM_QUALITY"..i.."_DESC"])
		end
	end
	return TSMAPI_FOUR.UI.NewElement("Frame", "search")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("ScrollFrame", "search")
			:SetStyle("padding", { top = 18 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "header")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 45)
				:SetStyle("margin", { left = 7, top = 3 })
				:SetStyle("background", "#272727")
				:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "backIcon")
					:SetStyle("width", 18)
					:SetStyle("backgroundTexturePack", "iconPack.14x14/SideArrow")
					:SetStyle("backgroundTextureRotation", 180)
					:SetScript("OnClick", private.AdvancedBackButtonOnClick)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "backBtn")
					:SetStyle("width", 40)
					:SetText(strupper(BACK))
					:SetStyle("fontHeight", 13)
					:SetScript("OnClick", private.AdvancedBackButtonOnClick)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "title")
					:SetStyle("margin.right", 100)
					:SetStyle("fontHeight", 16)
					:SetStyle("justifyH", "CENTER")
					:SetText(L["Advanced Item Search"])
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", 2)
				:SetStyle("color", "#9d9d9d")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "body")
				:SetLayout("VERTICAL")
				:SetStyle("padding", { left = 10, right = 10 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
					:SetText(L["FILTER BY KEYWORD"])
					:SetStyle("height", 18)
					:SetStyle("font", TSM.UI.Fonts.bold)
					:SetStyle("fontHeight", 11)
					:SetStyle("margin.top", 15)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "filterInput")
					:SetStyle("height", 26)
					:SetStyle("margin.bottom", 10)
					:SetStyle("background", "#404040")
					:SetStyle("border", "#585858")
					:SetStyle("borderSize", 2)
					:SetStyle("fontHeight", 11)
					:SetStyle("textColor", "#e2e2e2")
					:SetStyle("hintJustifyH", "LEFT")
					:SetStyle("hintTextColor", "#e2e2e2")
					:SetHintText(L["Enter Keyword"])
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "classAndSubClassLabels")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 18)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "classLabel")
						:SetText(L["ITEM CLASS"])
						:SetStyle("font", TSM.UI.Fonts.bold)
						:SetStyle("fontHeight", 11)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "subClassLabel")
						:SetStyle("margin.left", 20)
						:SetText(L["ITEM SUBCLASS"])
						:SetStyle("font", TSM.UI.Fonts.bold)
						:SetStyle("fontHeight", 11)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "classAndSubClass")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 18)
					:SetStyle("margin.bottom", 10)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "classDropdown")
						:SetStyle("height", 20)
						:SetStyle("margin.right", 20)
						:SetItems(TSMAPI_FOUR.Item.GetItemClasses())
						:SetScript("OnSelectionChanged", private.ClassDropdownOnSelectionChanged)
						:SetHintText(L["All Item Classes"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "subClassDropdown")
						:SetStyle("height", 20)
						:SetDisabled(true)
						:SetItems(TSMAPI_FOUR.Item.GetItemClasses())
						:SetHintText(L["All Subclasses"])
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "frame")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 30)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
						:SetText(L["REQUIRED LEVEL RANGE"])
						:SetStyle("font", TSM.UI.Fonts.bold)
						:SetStyle("fontHeight", 11)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "level")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 18)
					:SetStyle("margin.bottom", 10)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Slider", "slider")
						:SetRange(0, MAX_PLAYER_LEVEL)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "frame")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 30)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
						:SetText(L["ITEM LEVEL RANGE"])
						:SetStyle("font", TSM.UI.Fonts.bold)
						:SetStyle("fontHeight", 11)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "itemLevel")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 18)
					:SetStyle("margin.bottom", 10)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Slider", "slider")
						:SetRange(0, MAX_ITEM_LEVEL)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "quantityLabel")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 26)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
						:SetText(L["MAXIMUM QUANTITY TO BUY:"])
						:SetStyle("font", TSM.UI.Fonts.bold)
						:SetStyle("fontHeight", 11)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "quantity")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 18)
					:SetStyle("margin.bottom", 10)
					:AddChild(TSMAPI_FOUR.UI.NewElement("InputNumeric", "input")
						:SetStyle("backgroundTexturePacks", "uiFrames.ActiveInputField")
						:SetStyle("width", 64)
						:SetStyle("height", 24)
						:SetMaxNumber(2000)
						:SetStyle("justifyH", "CENTER")
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
						:SetText(L["(minimum 0 - maximum 2000)"])
						:SetStyle("margin.left", 10)
						:SetStyle("fontHeight", 14)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "rarityLabel")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 26)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
						:SetText(L["MINIMUM RARITY"])
						:SetStyle("font", TSM.UI.Fonts.bold)
						:SetStyle("fontHeight", 11)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "rarity")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 18)
					:SetStyle("margin.bottom", 10)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "dropdown")
						:SetStyle("height", 20)
						:SetItems(private.rarityList)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "usableFrame")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 18)
					:SetStyle("margin.bottom", 10)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "usableCheckbox")
						:SetStyle("height", 24)
						:SetCheckboxPosition("LEFT")
						:SetText(L["Search Usable Items Only?"])
						:SetStyle("fontHeight", 12)
						:SetStyle("checkboxSpacing", 1)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "exactFrame")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 25)
					:SetStyle("margin.bottom", 12)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "exactCheckbox")
						:SetStyle("height", 24)
						:SetCheckboxPosition("LEFT")
						:SetText(L["Exact Match Only?"])
						:SetStyle("fontHeight", 12)
						:SetStyle("checkboxSpacing", 1)
					)
				)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
			:SetStyle("height", 2)
			:SetStyle("color", "#9d9d9d")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "buttons")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 50)
			:SetStyle("background", "#272727")
			:SetStyle("padding", { left = 10, right = 10})
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "startBtn")
				:SetStyle("height", 26)
				:SetText(L["RUN ADVANCED ITEM SEARCH"])
				:SetScript("OnClick", private.AdvancedStartOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "resetBtn")
				:SetStyle("height", 24)
				:SetStyle("width", 100)
				:SetStyle("fontHeight", 11)
				:SetText(L["Reset Filters"])
				:SetScript("OnClick", private.ResetButtonOnClick)
			)
		)
end

function private.GetSearchesElement(self, button)
	if button == L["Recent Searches"] then
		return TSMAPI_FOUR.UI.NewElement("SearchList", "list")
			:SetQuery(TSM.Shopping.SavedSearches.CreateRecentSearchesQuery())
			:SetEditButtonHidden(true)
			:SetScript("OnFavoriteChanged", private.SearchListOnFavoriteChanged)
			:SetScript("OnDelete", private.SearchListOnDelete)
			:SetScript("OnRowClick", private.SearchListOnRowClick)
	elseif button == L["Favorite Searches"] then
		return TSMAPI_FOUR.UI.NewElement("SearchList", "list")
			:SetQuery(TSM.Shopping.SavedSearches.CreateFavoriteSearchesQuery())
			:SetScript("OnFavoriteChanged", private.SearchListOnFavoriteChanged)
			:SetScript("OnNameChanged", private.SearchListOnNameChanged)
			:SetScript("OnDelete", private.SearchListOnDelete)
			:SetScript("OnRowClick", private.SearchListOnRowClick)
	else
		error("Unexpected button: "..tostring(button))
	end
end

function private.GetScanFrame()
	TSM.UI.AnalyticsRecordPathChange("auction", "shopping", "scan")
	return TSMAPI_FOUR.UI.NewElement("Frame", "scan")
		:SetLayout("VERTICAL")
		:SetStyle("background", "#272727")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "backFrame")
			:SetLayout("HORIZONTAL")
			:SetStyle("margin", { left = 8, top = 6, bottom = 4 })
			:SetStyle("height", 18)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "backIcon")
				:SetStyle("width", 18)
				:SetStyle("backgroundTexturePack", "iconPack.18x18/SideArrow")
				:SetStyle("backgroundTextureRotation", 180)
				:SetScript("OnClick", private.ScanBackButtonOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer"))
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "searchText")
			:SetStyle("margin.left", 8)
			:SetStyle("margin.bottom", 2)
			:SetStyle("margin.top", 4)
			:SetStyle("height", 13)
			:SetStyle("font", TSM.UI.Fonts.MontserratBold)
			:SetStyle("fontHeight", 10)
			:SetText(L["CURRENT SEARCH"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "searchFrame")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin.left", 8)
			:SetStyle("margin.right", 8)
			:SetStyle("margin.bottom", 8)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "filterInput")
				:SetStyle("height", 26)
				:SetStyle("background", "#404040")
				:SetStyle("border", "#585858")
				:SetStyle("borderSize", 1)
				:SetStyle("fontHeight", 11)
				:SetStyle("textColor", "#e2e2e2")
				:SetStyle("hintJustifyH", "LEFT")
				:SetStyle("hintTextColor", "#e2e2e2")
				:SetHintText(L["Enter Filter"])
				:SetScript("OnEnterPressed", private.ScanFilterInputOnEnterPressed)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "rescanBtn")
				:SetStyle("width", 150)
				:SetStyle("margin.left", 8)
				:SetText(L["RESCAN"])
				:SetScript("OnClick", private.RescanBtnOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
			:SetStyle("height", 2)
			:SetStyle("color", "#9d9d9d")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("ShoppingScrollingTable", "auctions")
			:SetScript("OnSelectionChanged", private.AuctionsOnSelectionChanged)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "bottom")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 38)
			:SetStyle("padding.bottom", -2)
			:SetStyle("padding.top", 6)
			:SetStyle("background", "#363636")
			:AddChild(TSMAPI_FOUR.UI.NewElement("ProgressBar", "progressBar")
				:SetStyle("margin.right", 8)
				:SetStyle("height", 28)
				:SetProgress(0)
				:SetProgressIconHidden(false)
				:SetText(L["Starting Scan..."])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "postBtn")
				:SetStyle("width", 107)
				:SetStyle("height", 26)
				:SetStyle("margin.right", 8)
				:SetStyle("iconTexturePack", "iconPack.14x14/Post")
				:SetText(L["POST"])
				:SetDisabled(true)
				:SetScript("OnClick", private.AuctionsOnPostButtonClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("width", 3)
				:SetStyle("height", 23)
				:SetStyle("margin.right", 8)
				:SetStyle("color", "#9d9d9d")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "bidBtn")
				:SetStyle("width", 107)
				:SetStyle("height", 26)
				:SetStyle("margin.right", 8)
				:SetStyle("iconTexturePack", "iconPack.14x14/Bid")
				:SetText(strupper(BID))
				:SetDisabled(true)
				:SetScript("OnClick", private.BidBtnOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewNamedElement("ActionButton", "buyoutBtn", "TSMShoppingBuyoutBtn")
				:SetStyle("width", 107)
				:SetStyle("height", 26)
				:SetStyle("margin.right", 8)
				:SetStyle("iconTexturePack", "iconPack.14x14/Post")
				:SetText(strupper(BUYOUT))
				:SetDisabled(true)
				:DisableClickCooldown(true)
				:SetScript("OnClick", private.BuyoutBtnOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "stopBtn")
				:SetStyle("width", 107)
				:SetStyle("height", 26)
				:SetStyle("iconTexturePack", "iconPack.14x14/Stop")
				:SetText(L["STOP"])
				:SetDisabled(true)
				:SetScript("OnClick", private.StopButtonOnClick)
			)
		)
		:SetScript("OnUpdate", private.ScanFrameOnUpdate)
		:SetScript("OnHide", private.ScanFrameOnHide)
end

function private.BidBtnOnClick(button)
	private.fsm:ProcessEvent("EV_BID_CONFIRMATION")
end

function private.BuyoutBtnOnClick(button)
	private.fsm:ProcessEvent("EV_BUY_CONFIRMATION")
end

function private.BuyoutConfirmationShow(context, isBuy)
	if context.scanFrame:GetBaseElement():IsDialogVisible() then
		return
	end

	local record = context.scanFrame:GetElement("auctions"):GetSelectedRecord()
	local buyout = isBuy and record:GetField("buyout") or TSM.Auction.Util.GetRequiredBidByScanResultRow(record)
	local stackSize = record:GetField("stackSize")
	local itemString = record:GetField("itemString")

	local numConfirmed = context.numConfirmed + 1

	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "frame")
		:SetLayout("VERTICAL")
		:SetStyle("width", 290)
		:SetStyle("height", 156)
		:SetStyle("anchors", { { "CENTER" } })
		:SetStyle("background", "#2e2e2e")
		:SetStyle("border", "#e2e2e2")
		:SetStyle("borderSize", 1)
		:SetStyle("padding", 8)
		:SetMouseEnabled(true)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "item")
			:SetLayout("HORIZONTAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "icon")
				:SetStyle("width", 22)
				:SetStyle("height", 22)
				:SetStyle("margin", { right = 8, bottom = 2 })
				:SetStyle("backgroundTexture", TSMAPI_FOUR.Item.GetTexture(itemString))
				:SetTooltip(itemString)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "name")
				:SetStyle("height", 22)
				:SetStyle("margin", { bottom = 2, right = 16 })
				:SetStyle("font", TSM.UI.Fonts.FRIZQT)
				:SetStyle("fontHeight", 16)
				:SetStyle("justifyH", "LEFT")
				:SetText(TSM.UI.GetColoredItemName(itemString))
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "stack")
			:SetStyle("height", 20)
			:SetStyle("margin.bottom", 4)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 12)
			:SetStyle("justifyH", "LEFT")
			:SetText(L["Qty"]..": "..stackSize)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "price")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
				:SetStyle("height", 20)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 12)
				:SetStyle("justifyH", "LEFT")
				:SetStyle("textColor", "#e2e2e2")
				:SetText(L["Price Per Item"]..":")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "money")
				:SetStyle("height", 20)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 12)
				:SetStyle("justifyH", "RIGHT")
				:SetStyle("textColor", "#e2e2e2")
				:SetText(TSM.Money.ToString(ceil(buyout / stackSize)))
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "buyout")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
				:SetStyle("height", 20)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 12)
				:SetStyle("justifyH", "LEFT")
				:SetStyle("textColor", "#e2e2e2")
				:SetText(isBuy and L["Auction Buyout"]..":" or L["Auction Bid"]..":")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "money")
				:SetStyle("height", 20)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 12)
				:SetStyle("justifyH", "RIGHT")
				:SetStyle("textColor", "#e2e2e2")
				:SetText(TSM.Money.ToString(buyout))
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "stacks")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
				:SetStyle("height", 20)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 12)
				:SetStyle("justifyH", "LEFT")
				:SetStyle("textColor", "#e2e2e2")
				:SetText(isBuy and L["Purchasing Auction"]..":" or L["Bidding Auction"]..":")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "number")
				:SetStyle("height", 20)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 12)
				:SetStyle("justifyH", "RIGHT")
				:SetStyle("textColor", "#e2e2e2")
				:SetText(numConfirmed.."/"..context.numFound)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "TSMShoppingConfirmBuyoutBtn")
			:SetStyle("margin.top", 6)
			:SetStyle("width", 276)
			:SetStyle("height", 26)
			:SetText(isBuy and L["BUYOUT"] or L["BID"])
			:SetScript("OnClick", isBuy and private.ConfirmBuyoutBtnOnClick or private.ConfirmBidBtnOnClick)
		)
		:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Button", "closeBtn")
			:SetStyle("width", 18)
			:SetStyle("height", 18)
			:SetStyle("anchors", { { "TOPRIGHT", -4, -4 } })
			:SetStyle("backgroundTexturePack", "iconPack.18x18/Close/Default")
			:SetScript("OnClick", private.BuyoutConfirmCloseBtnOnClick)
		)

	context.scanFrame:GetBaseElement():ShowDialogFrame(frame)
end

function private.BuyoutConfirmCloseBtnOnClick(button)
	button:GetBaseElement():HideDialog()
end

function private.ConfirmBidBtnOnClick(button)
	button:GetBaseElement():HideDialog()
	private.fsm:ProcessEvent("EV_BID_AUCTION")
end

function private.ConfirmBuyoutBtnOnClick(button)
	button:GetBaseElement():HideDialog()
	private.fsm:ProcessEvent("EV_BUY_AUCTION")
end

function private.PostDialogShow(baseFrame, record)
	baseFrame:ShowDialogFrame(TSMAPI_FOUR.UI.NewElement("Frame", "frame")
		:SetLayout("VERTICAL")
		:SetStyle("width", 264)
		:SetStyle("height", 252)
		:SetStyle("anchors", { { "CENTER" } })
		:SetStyle("background", "#2e2e2e")
		:SetStyle("border", "#e2e2e2")
		:SetStyle("borderSize", 1)
		:SetStyle("padding", 8)
		:SetMouseEnabled(true)
		:AddChild(TSMAPI_FOUR.UI.NewElement("ViewContainer", "view")
			:SetNavCallback(private.GetViewContentFrame)
			:AddPath("posting")
			:AddPath("selection")
			:SetPath("posting")
			:SetContext(record)
		)
		:SetScript("OnHide", private.PostDialogOnHide)
	)
end

function private.PostDialogOnHide(frame)
	private.itemString = nil
end

function private.GetViewContentFrame(viewContainer, path)
	if path == "posting" then
		return private.GetPostingFrame()
	elseif path == "selection" then
		return private.GetPostSelectionFrame()
	else
		error("Unexpected path: "..tostring(path))
	end
end

function private.GetPostingFrame()
	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "posting")
		:SetLayout("VERTICAL")
		:SetMouseEnabled(true)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "header")
			:SetLayout("HORIZONTAL")
			:SetStyle("margin.bottom", 8)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "title")
				:SetStyle("width", 124)
				:SetStyle("height", 13)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 10)
				:SetStyle("justifyH", "LEFT")
				:SetStyle("textColor", "#e2e2e2")
				:SetText(L["CUSTOM POST"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "closeBtn")
				:SetStyle("width", 18)
				:SetStyle("height", 18)
				:SetStyle("margin", { top = -4, left = 110, right = -4 })
				:SetStyle("backgroundTexturePack", "iconPack.18x18/Close/Default")
				:SetScript("OnClick", private.PostDialogCloseBtnOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "item")
			:SetLayout("HORIZONTAL")
			:SetStyle("margin.top", -6)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "icon")
				:SetStyle("width", 28)
				:SetStyle("height", 28)
				:SetStyle("margin", { top = 2, right = 8, bottom = 7 })
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "name")
				:SetStyle("height", 40)
				:SetStyle("margin.top", -5)
				:SetStyle("font", TSM.UI.Fonts.FRIZQT)
				:SetStyle("fontHeight", 16)
				:SetStyle("justifyH", "LEFT")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "editBtn")
				:SetStyle("width", 14)
				:SetStyle("height", 14)
				:SetStyle("margin", { top = -5, left = 4 })
				:SetStyle("backgroundTexturePack", "iconPack.14x14/Edit")
				:SetScript("OnClick", private.ItemBtnOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "quantity")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc")
				:SetStyle("width", 110)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 12)
				:SetStyle("textColor", "#e2e2e2")
				:SetText(L["Stack / Quantity"] .. ":")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("InputNumeric", "num")
				:SetStyle("height", 18)
				:SetStyle("margin.left", 8)
				:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
				:SetStyle("fontHeight", 12)
				:SetStyle("justifyH", "RIGHT")
				:SetMinNumber(1)
				:SetMaxNumber(9999)
				:SetMaxLetters(4)
				:SetText("1")
				:SetScript("OnTextChanged", private.QuantityNumInputOnTextChanged)
				:SetScript("OnTabPressed", private.QuantityNumInputOnTabPressed)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "ofText")
				:SetStyle("width", 20)
				:SetStyle("margin", 4)
				:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
				:SetStyle("fontHeight", 12)
				:SetStyle("justifyH", "CENTER")
				:SetText(L["of"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("InputNumeric", "stackSize")
				:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
				:SetStyle("fontHeight", 12)
				:SetStyle("height", 18)
				:SetStyle("justifyH", "RIGHT")
				:SetMinNumber(1)
				:SetMaxNumber(9999)
				:SetMaxLetters(4)
				:SetScript("OnTextChanged", private.QuantityStackInputOnTextChanged)
				:SetScript("OnTabPressed", private.QuantityStackInputOnTabPressed)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "maxBtns")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:SetStyle("margin.bottom", 8)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer1")
				:SetStyle("width", 118)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "numBtn")
				:SetStyle("height", 15)
				:SetStyle("margin.left", 4)
				:SetStyle("margin.right", 4)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 12)
				:SetText(L["MAX"])
				:SetScript("OnClick", private.MaxNumBtnOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer2")
				:SetStyle("width", 20)
				:SetStyle("margin", 4)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "stackSizeBtn")
				:SetStyle("height", 15)
				:SetStyle("margin.left", 4)
				:SetStyle("margin.right", 4)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 12)
				:SetText(L["MAX"])
				:SetScript("OnClick", private.MaxStackSizeBtnOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "duration")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc")
				:SetStyle("width", 110)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 12)
				:SetStyle("textColor", "#e2e2e2")
				:SetText(L["Auction Duration"] .. ":")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Toggle", "toggle")
				:SetStyle("height", 16)
				:SetStyle("margin.left", 8)
				:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
				:SetStyle("border", "#e2e2e2")
				:SetStyle("textColor", "#e2e2e2")
				:SetStyle("selectedBackground", "#e2e2e2")
				:SetStyle("fontHeight", 12)
				:AddOption(POST_TIME_STRS[1])
				:AddOption(POST_TIME_STRS[2])
				:AddOption(POST_TIME_STRS[3])
				:SetOption(private.postTimeStr, true)
				:SetScript("OnValueChanged", private.DurationOnValueChanged)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "stack")
			:SetStyle("width", 49)
			:SetStyle("height", 14)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("margin", { left = 199, bottom = 4 })
			:SetStyle("fontHeight", 10)
			:SetStyle("justifyH", "RIGHT")
			:SetStyle("textColor", "#ffd839")
			:SetText(L["Per Unit"])
			:SetScript("OnClick", private.StackBtnOnClick)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "bid")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc")
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 12)
				:SetStyle("textColor", "#e2e2e2")
				:SetStyle("autoWidth", true)
				:SetText(L["Bid Price"] .. ":")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("EditableText", "text")
				:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
				:SetStyle("fontHeight", 12)
				:SetStyle("justifyH", "RIGHT")
				:SetContext("bid")
				:SetScript("OnValueChanged", private.BidTextOnValueChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "editBtn")
				:SetStyle("width", 12)
				:SetStyle("height", 12)
				:SetStyle("margin.left", 4)
				:SetStyle("backgroundTexturePack", "iconPack.12x12/Edit")
				:SetScript("OnClick", private.BidEditBtnOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "buyout")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:SetStyle("margin.bottom", 6)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc")
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 12)
				:SetStyle("textColor", "#e2e2e2")
				:SetStyle("autoWidth", true)
				:SetText(L["Buyout Price"] .. ":")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("EditableText", "text")
				:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
				:SetStyle("fontHeight", 12)
				:SetStyle("justifyH", "RIGHT")
				:SetContext("buyout")
				:SetScript("OnValueChanged", private.BuyoutTextOnValueChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "editBtn")
				:SetStyle("width", 12)
				:SetStyle("height", 12)
				:SetStyle("margin.left", 4)
				:SetStyle("backgroundTexturePack", "iconPack.12x12/Edit")
				:SetScript("OnClick", private.BuyoutEditBtnOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "deposit")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:SetStyle("margin.bottom", 4)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc")
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 12)
				:SetStyle("textColor", "#e2e2e2")
				:SetStyle("autoWidth", true)
				:SetText(L["Deposit Price"] .. ":")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
				:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
				:SetStyle("fontHeight", 12)
				:SetStyle("justifyH", "RIGHT")
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "confirmBtn")
			:SetStyle("margin.top", 0)
			:SetStyle("height", 248)
			:SetStyle("height", 26)
			:SetText(L["POST"])
			:SetScript("OnClick", private.PostButtonOnClick)
		)
		:SetScript("OnUpdate", private.PostingFrameOnUpdate)

	return frame
end

function private.GetPostSelectionFrame()
	local query = TSM.Inventory.BagTracking.CreateQuery()
		:GreaterThanOrEqual("bag", 0)
		:LessThanOrEqual("bag", NUM_BAG_SLOTS)
		:Equal("baseItemString", TSMAPI_FOUR.Item.ToBaseItemString(private.itemString))
		:Equal("isBoP", false)
		:Equal("isBoA", false)
		:Equal("usedCharges", false)

	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "selection")
		:SetLayout("VERTICAL")
		:SetMouseEnabled(true)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "header")
			:SetLayout("HORIZONTAL")
			:SetStyle("margin.bottom", 6)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "title")
				:SetStyle("width", 124)
				:SetStyle("height", 13)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 10)
				:SetStyle("justifyH", "LEFT")
				:SetStyle("textColor", "#e2e2e2")
				:SetText(L["ITEM SELECTION"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "closeBtn")
				:SetStyle("width", 18)
				:SetStyle("height", 18)
				:SetStyle("margin", { top = -4, left = 110, right = -4, bottom = 1 })
				:SetStyle("backgroundTexturePack", "iconPack.18x18/Close/Default")
				:SetScript("OnClick", private.PostDialogCloseBtnOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "items")
			:SetStyle("lineColor", "#000000")
			:SetStyle("hideHeader", true)
			:SetStyle("headerBackground", "#00000000")
			:SetStyle("background", "#000000")
			:SetStyle("altBackground", "#1b1b1b")
			:SetStyle("headerFont", TSM.UI.Fonts.MontserratRegular)
			:SetStyle("headerFontHeight", 12)
			:GetScrollingTableInfo()
				:NewColumn("item")
					:SetTitles(L["Item"])
					:SetFont(TSM.UI.Fonts.FRIZQT)
					:SetFontHeight(12)
					:SetJustifyH("LEFT")
					:SetIconSize(14)
					:SetTextInfo("itemString", TSM.UI.GetColoredItemName)
					:SetIconInfo("itemString", TSMAPI_FOUR.Item.GetTexture)
					:SetTooltipInfo("itemString")
					:Commit()
				:Commit()
			:SetQuery(query)
			:SetAutoReleaseQuery(true)
			:SetScript("OnRowClick", private.ItemQueryOnRowClick)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "backBtn")
			:SetStyle("margin.top", 9)
			:SetStyle("height", 248)
			:SetStyle("height", 26)
			:SetText(L["BACK"])
			:SetScript("OnClick", private.ViewBackButtonOnClick)
		)

	return frame
end

function private.PostingFrameOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)

	local record = frame:GetParentElement():GetContext()
	if not private.itemString then
		assert(record.itemString)
		local foundItem = false
		local backupItemString = nil
		for _, _, _, itemString in TSMAPI_FOUR.Inventory.BagIterator(false, false, false, true) do
			if itemString == record.itemString then
				foundItem = true
			elseif not backupItemString and TSMAPI_FOUR.Item.ToBaseItemString(itemString) == TSMAPI_FOUR.Item.ToBaseItemString(record.itemString) then
				backupItemString = itemString
			end
		end
		private.itemString = foundItem and record.itemString or backupItemString

		if not private.itemString then
			frame:GetBaseElement():HideDialog()
			TSM:Printf(L["Failed to post %sx%d as the item no longer exists in your bags."], TSMAPI_FOUR.Item.GetLink(record.itemString), record.stackSize)
			private.frame:GetElement("scan.bottom.postBtn")
				:SetDisabled(true)
				:Draw()
			return
		end
	end
	local undercut = TSMAPI_FOUR.PlayerInfo.IsPlayer(record.seller, true, true, true) and 0 or 1
	local bid = floor(record.displayedBid / record.stackSize) - undercut
	if bid <= 0 then
		bid = 1
	elseif bid > MAXIMUM_BID_PRICE then
		bid = MAXIMUM_BID_PRICE
	end
	local buyout = floor(record.buyout / record.stackSize) - undercut
	if buyout < 0 then
		buyout = 0
	elseif buyout > MAXIMUM_BID_PRICE then
		buyout = MAXIMUM_BID_PRICE
	end
	local cagedPet = strfind(private.itemString, "^p")
	private.perItem = true

	frame:GetElement("item.icon")
		:SetStyle("backgroundTexture", TSMAPI_FOUR.Item.GetTexture(private.itemString))
		:SetTooltip(private.itemString)
	frame:GetElement("item.name")
		:SetText(TSM.UI.GetColoredItemName(private.itemString))
	frame:GetElement("quantity.num")
		:SetDisabled(cagedPet)
	frame:GetElement("quantity.stackSize")
		:SetDisabled(cagedPet)
		:SetText(record.stackSize)
	frame:GetElement("maxBtns.numBtn")
		:SetDisabled(cagedPet)
	frame:GetElement("maxBtns.stackSizeBtn")
		:SetDisabled(cagedPet)
	frame:GetElement("bid.text")
		:SetText(TSM.Money.ToString(bid))
	frame:GetElement("buyout.text")
		:SetText(TSM.Money.ToString(buyout))
	frame:GetElement("confirmBtn")
		:SetContext(private.itemString)

	frame:Draw()

	private.UpdateDepositCost(frame)
end

function private.ItemQueryOnRowClick(scrollingtable, row)
	private.itemString = row:GetField("itemString")
	scrollingtable:GetElement("__parent.__parent"):SetPath("posting", true)
end

function private.ViewBackButtonOnClick(button)
	button:GetElement("__parent.__parent"):SetPath("posting", true)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.OnItemLinked(name, itemLink)
	local itemString = TSMAPI_FOUR.Item.ToItemString(itemLink)
	local baseItemString = TSMAPI_FOUR.Item.ToBaseItemString(itemString)
	local baseName = TSMAPI_FOUR.Item.GetName(baseItemString)
	private.frame:SetPath("selection")
	if itemString == baseItemString and private.singleItemSearchType ~= "crafting" then
		baseName = baseName.."/exact"
	end
	private.itemInfo.itemString = itemString
	private.itemInfo.seller = PLAYER_NAME
	private.itemInfo.stackSize = 1
	private.itemInfo.displayedBid = TSMAPI_FOUR.CustomPrice.GetValue("first(dbmarket, 100g)", itemString)
	private.itemInfo.buyout = TSMAPI_FOUR.CustomPrice.GetValue("first(dbmarket, 100g)", itemString)
	private.frame:GetBaseElement():HideDialog()
	private.StartFilterSearchHelper(private.frame, baseName, nil, private.itemInfo)
	return true
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
	end
end
function private.MoreBtnOnClick(button)
	button:GetBaseElement():ShowMoreButtonDialog(button, MoreDialogRowIterator)
end

function private.SelectAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.shopping.selection.groupSelection.groupTree"):SelectAll()
	baseFrame:HideDialog()
end

function private.DeselectAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.shopping.selection.groupSelection.groupTree"):DeselectAll()
	baseFrame:HideDialog()
end

function private.ExpandAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.shopping.selection.groupSelection.groupTree"):ExpandAll()
	baseFrame:HideDialog()
end

function private.CollapseAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.shopping.selection.groupSelection.groupTree"):CollapseAll()
	baseFrame:HideDialog()
end

function private.GroupTreeOnGroupSelectionChanged(groupTree, selectedGroups)
	local scanBtn = groupTree:GetElement("__parent.scanBtn")
	scanBtn:SetDisabled(not next(selectedGroups))
	scanBtn:Draw()
end

function private.FrameOnHide(frame)
	assert(frame == private.frame)
	private.frame = nil
	for _, callback in ipairs(private.updateCallbacks) do
		callback()
	end
end

function private.GroupTreeGetList(groups, headerNameLookup)
	TSM.UI.ApplicationGroupTreeGetGroupList(groups, headerNameLookup, "Shopping")
end

function private.ScanButtonOnClick(button)
	if not TSM.UI.AuctionUI.StartingScan(L["Shopping"]) then
		return
	end
	wipe(private.selectedGroups)
	for _, groupPath in button:GetElement("__parent.groupTree"):SelectedGroupsIterator() do
		if groupPath ~= "" and not strmatch(groupPath, "^`") then
			tinsert(private.selectedGroups, groupPath)
		end
	end

	button:GetParentElement():GetParentElement():GetParentElement():SetPath("scan", true)
	local threadId, marketValueFunc = TSM.Shopping.GroupSearch.GetScanContext()
	private.fsm:ProcessEvent("EV_START_SCAN", threadId, marketValueFunc, NoOp, NoOp, "", private.selectedGroups)
end

function private.SearchListOnFavoriteChanged(_, dbRow, isFavorite)
	TSM.Shopping.SavedSearches.SetSearchIsFavorite(dbRow, isFavorite)
end

function private.SearchListOnNameChanged(_, dbRow, newName)
	TSM.Shopping.SavedSearches.RenameSearch(dbRow, newName)
end

function private.SearchListOnDelete(_, dbRow)
	TSM.Shopping.SavedSearches.DeleteSearch(dbRow)
end

function private.SearchListOnRowClick(searchList, dbRow)
	local viewContainer = searchList:GetParentElement():GetParentElement():GetParentElement():GetParentElement():GetParentElement()
	private.StartFilterSearchHelper(viewContainer, dbRow:GetField("filter"))
end

function private.AdvancedButtonOnClick(button)
	button:GetParentElement():GetParentElement():GetParentElement():SetPath("advanced", true)
end

function private.AdvancedBackButtonOnClick(button)
	button:GetParentElement():GetParentElement():GetParentElement():GetParentElement():SetPath("search", true)
end

function private.ClassDropdownOnSelectionChanged(dropdown, selection)
	local subClassDropdown = dropdown:GetElement("__parent.subClassDropdown")
	if selection then
		subClassDropdown:SetItems(TSMAPI_FOUR.Item.GetItemSubClasses(selection))
		subClassDropdown:SetDisabled(false)
		subClassDropdown:SetSelection(nil)
			:Draw()
	else
		subClassDropdown:SetDisabled(true)
		subClassDropdown:SetSelection(nil)
			:Draw()
	end
end

function private.ResetButtonOnClick(button)
	local searchFrame = button:GetElement("__parent.__parent.search.body")
	searchFrame:GetElement("filterInput"):SetText("")
	searchFrame:GetElement("level.slider"):SetValue(0, MAX_PLAYER_LEVEL)
	searchFrame:GetElement("itemLevel.slider"):SetValue(0, MAX_ITEM_LEVEL)
	searchFrame:GetElement("classAndSubClass.classDropdown"):SetSelection(nil)
	searchFrame:GetElement("classAndSubClass.subClassDropdown"):SetSelection(nil)
	searchFrame:GetElement("rarity.dropdown"):SetSelection(nil)
	searchFrame:GetElement("quantity.input"):SetText("")
	searchFrame:GetElement("usableFrame.usableCheckbox"):SetChecked(false)
	searchFrame:GetElement("exactFrame.exactCheckbox"):SetChecked(false)
	searchFrame:Draw()
end

function private.AdvancedStartOnClick(button)
	local searchFrame = button:GetElement("__parent.__parent.search.body")
	local filterParts = TSMAPI_FOUR.Util.AcquireTempTable()

	tinsert(filterParts, strtrim(searchFrame:GetElement("filterInput"):GetText()))

	local levelMin, levelMax = searchFrame:GetElement("level.slider"):GetValue()
	if levelMin ~= 0 or levelMax ~= MAX_PLAYER_LEVEL then
		tinsert(filterParts, levelMin)
		tinsert(filterParts, levelMax)
	end

	local itemLevelMin, itemLevelMax = searchFrame:GetElement("itemLevel.slider"):GetValue()
	if itemLevelMin ~= 0 or itemLevelMax ~= MAX_ITEM_LEVEL then
		tinsert(filterParts, "i"..itemLevelMin)
		tinsert(filterParts, "i"..itemLevelMax)
	end

	local class = searchFrame:GetElement("classAndSubClass.classDropdown"):GetSelection()
	if class then
		tinsert(filterParts, class)
	end

	local subClass = searchFrame:GetElement("classAndSubClass.subClassDropdown"):GetSelection()
	if subClass then
		tinsert(filterParts, subClass)
	end

	local rarity = searchFrame:GetElement("rarity.dropdown"):GetSelection()
	if rarity then
		tinsert(filterParts, rarity)
	end

	local quantity = tonumber(searchFrame:GetElement("quantity.input"):GetText())
	if quantity then
		tinsert(filterParts, "x"..quantity)
	end

	if searchFrame:GetElement("usableFrame.usableCheckbox"):IsChecked() then
		tinsert(filterParts, "usable")
	end

	if searchFrame:GetElement("exactFrame.exactCheckbox"):IsChecked() then
		tinsert(filterParts, "exact")
	end

	local filter = table.concat(filterParts, "/")
	TSMAPI_FOUR.Util.ReleaseTempTable(filterParts)
	local viewContainer = searchFrame:GetParentElement():GetParentElement():GetParentElement():GetParentElement():GetParentElement()
	private.StartFilterSearchHelper(viewContainer, filter)
end

function private.FilterSearchInputOnEnterPressed(input)
	local filter = strtrim(input:GetText())
	if filter == "" then
		return
	end
	local viewContainer = input:GetParentElement():GetParentElement():GetParentElement():GetParentElement()
	private.StartFilterSearchHelper(viewContainer, filter)
end

function private.FilterSearchButtonOnClick(button)
	private.FilterSearchInputOnEnterPressed(button:GetElement("__parent.filterInput"))
end

function private.StartFilterSearchHelper(viewContainer, filter, isGreatDeals, itemInfo)
	if not TSM.UI.AuctionUI.StartingScan(L["Shopping"]) then
		return
	end
	local originalFilter = filter
	local mode = (private.singleItemSearchType == "crafting" and not isGreatDeals) and "CRAFTING" or "NORMAL"
	filter = TSM.Shopping.FilterSearch.PrepareFilter(strtrim(filter), mode, TSM.db.global.shoppingOptions.pctSource)
	if not filter or filter == "" then
		viewContainer:SetPath("scan", true)
		TSM:Print(L["Invalid search filter"]..": "..originalFilter)
		return
	end
	viewContainer:SetPath("scan", true)
	local threadId, marketValueFunc = TSM.Shopping.FilterSearch.GetScanContext(isGreatDeals)
	private.fsm:ProcessEvent("EV_START_SCAN", threadId, marketValueFunc, NoOp, NoOp, isGreatDeals and L["Great Deals Search"] or filter, filter, itemInfo)
end

function private.StartGatheringSearchHelper(viewContainer, items, stateCallback, buyCallback, mode)
	if not TSM.UI.AuctionUI.StartingScan(L["Shopping"]) then
		return
	end
	local filterList = TSMAPI_FOUR.Util.AcquireTempTable()
	for itemString, quantity in pairs(items) do
		tinsert(filterList, itemString.."/x"..quantity)
	end
	local filter = table.concat(filterList, ";")
	TSMAPI_FOUR.Util.ReleaseTempTable(filterList)
	filter = TSM.Shopping.FilterSearch.PrepareFilter(filter, mode, "matprice")
	assert(filter and filter ~= "")
	viewContainer:SetPath("scan", true)
	local threadId, marketValueFunc = TSM.Shopping.FilterSearch.GetScanContext(true)
	private.fsm:ProcessEvent("EV_START_SCAN", threadId, marketValueFunc, buyCallback, stateCallback, L["Gathering Search"], filter)
end

function private.DealsButtonOnClick(button)
	local viewContainer = button:GetParentElement():GetParentElement():GetParentElement():GetParentElement():GetParentElement()
	private.StartFilterSearchHelper(viewContainer, TSM.Shopping.GreatDealsSearch.GetFilter(), true)
end

function private.VendorButtonOnClick(button)
	if not TSM.UI.AuctionUI.StartingScan(L["Shopping"]) then
		return
	end
	button:GetParentElement():GetParentElement():GetParentElement():GetParentElement():GetParentElement():SetPath("scan", true)
	local threadId, marketValueFunc = TSM.Shopping.VendorSearch.GetScanContext()
	private.fsm:ProcessEvent("EV_START_SCAN", threadId, marketValueFunc, NoOp, NoOp, L["Vendor Search"])
end

function private.DisenchantButtonOnClick(button)
	if not TSM.UI.AuctionUI.StartingScan(L["Shopping"]) then
		return
	end
	button:GetParentElement():GetParentElement():GetParentElement():GetParentElement():GetParentElement():SetPath("scan", true)
	local threadId, marketValueFunc = TSM.Shopping.DisenchantSearch.GetScanContext()
	private.fsm:ProcessEvent("EV_START_SCAN", threadId, marketValueFunc, NoOp, NoOp, L["Disenchant Search"])
end

function private.ScanBackButtonOnClick(button)
	button:GetParentElement():GetParentElement():GetParentElement():SetPath("selection", true)
	private.fsm:ProcessEvent("EV_SCAN_BACK_BUTTON_CLICKED")
end

function private.AuctionsOnSelectionChanged()
	private.fsm:ProcessEvent("EV_AUCTION_SELECTION_CHANGED")
end

function private.AuctionsOnPostButtonClick()
	private.fsm:ProcessEvent("EV_POST_BUTTON_CLICK")
end

function private.StopButtonOnClick(button)
	private.fsm:ProcessEvent("EV_STOP_SCAN")
end

function private.ScanFrameOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)
	frame:GetBaseElement():SetBottomPadding(38)
	private.fsm:ProcessEvent("EV_SCAN_FRAME_SHOWN", frame)
end

function private.ScanFrameOnHide(frame)
	private.fsm:ProcessEvent("EV_SCAN_FRAME_HIDDEN")
end

function private.BidEditBtnOnClick(button)
	local frame = button:GetParentElement():GetParentElement()
	local buyoutText = frame:GetElement("buyout.text")
	buyoutText:SetEditing(false)
	button:GetElement("__parent.text"):SetEditing(true)
end

function private.BuyoutEditBtnOnClick(button)
	local frame = button:GetParentElement():GetParentElement()
	local bidText = frame:GetElement("bid.text")
	bidText:SetEditing(false)
	button:GetElement("__parent.text"):SetEditing(true)
end

function private.StackBtnOnClick(button)
	local frame = button:GetParentElement()
	local record = frame:GetParentElement():GetContext()
	local undercut = record.seller == PLAYER_NAME and 0 or 1
	local stackSize = record.stackSize
	local bidText = frame:GetElement("bid.text")
	local buyoutText = frame:GetElement("buyout.text")
	-- always update buyout first
	if private.perItem then
		private.perItem = nil
		local bid = TSM.Money.FromString(bidText:GetText())
		bid = bid and (bid * stackSize + undercut) or record.displayedBid
		local buyout = TSM.Money.FromString(buyoutText:GetText())
		buyout = buyout and (buyout * stackSize + undercut) or record.buyout
		local stackSizeEdit = frame:GetElement("quantity.stackSize"):GetText()
		stackSizeEdit = tonumber(stackSizeEdit)
		if stackSize == stackSizeEdit then
			private.BuyoutTextOnValueChanged(buyoutText, TSM.Money.ToString(buyout - undercut), true)
			private.BidTextOnValueChanged(bidText, TSM.Money.ToString(bid - undercut), true)
		else
			private.BuyoutTextOnValueChanged(buyoutText, TSM.Money.FromString(buyoutText:GetText()) > 0 and TSM.Money.ToString(floor(record.buyout / stackSize) * stackSizeEdit) or 0, true)
			private.BidTextOnValueChanged(bidText, TSM.Money.ToString(floor(record.displayedBid / stackSize) * stackSizeEdit), true)
		end
		button:SetText(L["Per Stack"])
	else
		private.perItem = true
		local bid = TSM.Money.FromString(bidText:GetText())
		bid = bid and (bid + undercut * stackSize) or record.displayedBid
		local buyout = TSM.Money.FromString(buyoutText:GetText())
		buyout = buyout and (buyout + undercut * stackSize) or record.buyout
		local stackSizeEdit = frame:GetElement("quantity.stackSize"):GetText()
		stackSizeEdit = tonumber(stackSizeEdit)
		if stackSize == stackSizeEdit then
			private.BuyoutTextOnValueChanged(buyoutText, TSM.Money.FromString(buyoutText:GetText()) > 0 and TSM.Money.ToString(floor(buyout / stackSizeEdit) - undercut) or 0, true)
			private.BidTextOnValueChanged(bidText, TSM.Money.ToString(floor(bid / stackSizeEdit) - undercut), true)
		else
			private.BuyoutTextOnValueChanged(buyoutText, TSM.Money.FromString(buyoutText:GetText()) > 0 and TSM.Money.ToString(floor(record.buyout / stackSize)) or 0, true)
			private.BidTextOnValueChanged(bidText, TSM.Money.ToString(floor(record.displayedBid / stackSize)), true)
		end
		button:SetText(L["Per Unit"])
	end
	button:Draw()
end

function private.BidTextOnValueChanged(text, value, skipUpdate)
	value = TSM.Money.FromString(value)
	if value then
		value = min(value, MAXIMUM_BID_PRICE)
		local frame = text:GetParentElement():GetParentElement()
		local buyout = TSM.Money.FromString(frame:GetElement("buyout.text"):GetText())
		if private.perItem and buyout > 0 and value > buyout then
			text:SetText(TSM.Money.ToString(buyout))
		elseif not private.perItem and buyout > 0 and value > buyout then
			text:SetText(TSM.Money.ToString(buyout))
		else
			text:SetText(TSM.Money.ToString(value))
		end
	end
	text:Draw()

	if not skipUpdate then
		private.UpdateDepositCost(text:GetParentElement():GetParentElement())
	end
end

function private.BuyoutTextOnValueChanged(text, value, skipUpdate)
	value = TSM.Money.FromString(value)
	if value then
		value = min(value, MAXIMUM_BID_PRICE)
		local frame = text:GetParentElement():GetParentElement()
		local bidText = frame:GetElement("bid.text")
		local bid = TSM.Money.FromString(bidText:GetText())
		if value > 0 and bid > value then
			private.BidTextOnValueChanged(bidText, TSM.Money.ToString(value), skipUpdate)
		end
		text:SetText(TSM.Money.ToString(value))
	end
	text:Draw()

	if not skipUpdate then
		private.UpdateDepositCost(text:GetParentElement():GetParentElement())
	end
end

function private.ItemBtnOnClick(button)
	button:GetElement("__parent.__parent.__parent"):SetPath("selection", true)
end

function private.QuantityNumInputOnTextChanged(input)
	local text = input:GetText()
	local textNum = tonumber(text)
	if not textNum then
		return
	end
	if textNum < 1 then
		return
	end
	if textNum == private.postQuantity then
		return
	end
	private.postQuantity = textNum

	input:SetText(text)

	private.UpdateDepositCost(input:GetParentElement():GetParentElement())
end

function private.QuantityNumInputOnTabPressed(input)
	local frame = input:GetParentElement()
	local stackInput = frame:GetElement("stackSize")
	stackInput:SetFocused(true)
	stackInput:HighlightText()
end

function private.QuantityStackInputOnTextChanged(input)
	local text = input:GetText()
	local textNum = tonumber(text)
	if not textNum then
		return
	end
	if textNum < 1 then
		return
	end
	if textNum == private.postStack then
		return
	end
	private.postStack = textNum

	input:SetText(text)

	private.UpdateDepositCost(input:GetParentElement():GetParentElement())

	if private.perItem then
		return
	end

	local frame = input:GetParentElement():GetParentElement()
	local record = frame:GetParentElement():GetContext()
	local undercut = record.seller == PLAYER_NAME and 0 or 1
	local stackSize = record.stackSize
	local bidText = frame:GetElement("bid.text")
	local buyoutText = frame:GetElement("buyout.text")
	local bid = record.displayedBid
	local buyout = record.buyout
	local stackSizeEdit = frame:GetElement("quantity.stackSize"):GetText()
	stackSizeEdit = tonumber(stackSizeEdit)
	-- always update buyout first
	if stackSize == stackSizeEdit then
		private.BuyoutTextOnValueChanged(buyoutText, TSM.Money.ToString(buyout - undercut))
		private.BidTextOnValueChanged(bidText, TSM.Money.ToString(bid - undercut))
	else
		private.BuyoutTextOnValueChanged(buyoutText, TSM.Money.ToString((floor(buyout / stackSize) * stackSizeEdit)))
		private.BidTextOnValueChanged(bidText, TSM.Money.ToString((floor(bid / stackSize) * stackSizeEdit)))
	end
end

function private.QuantityStackInputOnTabPressed(input)
	local frame = input:GetParentElement()
	local numInput = frame:GetElement("num")
	numInput:SetFocused(true)
	numInput:HighlightText()
end

function private.UpdateDepositCost(frame)
	local postBag, postSlot = nil, nil
	for _, bag, slot, itemString in TSMAPI_FOUR.Inventory.BagIterator(false, false, false, true) do
		if not postBag and not postSlot and itemString == frame:GetElement("confirmBtn"):GetContext() then
			postBag = bag
			postSlot = slot
		end
	end
	if postBag and postSlot then
		ClearCursor()
		PickupContainerItem(postBag, postSlot)
		ClickAuctionSellItemButton(AuctionsItemButton, "LeftButton")
		ClearCursor()
	else
		frame:GetElement("deposit.text")
			:SetText(TSM.Money.ToString(0))
			:Draw()
		frame:GetElement("confirmBtn")
			:SetDisabled(true)
			:Draw()
		return
	end

	private.postTimeStr = frame:GetElement("duration.toggle"):GetValue()
	local postTime = TSMAPI_FOUR.Util.GetDistinctTableKey(POST_TIME_STRS, private.postTimeStr)

	local bid = TSM.Money.FromString(frame:GetElement("bid.text"):GetText())
	local buyout = TSM.Money.FromString(frame:GetElement("buyout.text"):GetText())
	local num = tonumber(frame:GetElement("quantity.num"):GetText())
	local stackSize = tonumber(frame:GetElement("quantity.stackSize"):GetText())
	if private.perItem then
		bid = bid * stackSize
		buyout = buyout * stackSize
	end

	frame:GetElement("deposit.text")
		:SetText(TSM.Money.ToString(GetAuctionDeposit(postTime, bid, buyout, stackSize, num)))
		:Draw()
	frame:GetElement("confirmBtn")
		:SetDisabled(false)
		:Draw()

	ClearCursor()
	ClickAuctionSellItemButton(AuctionsItemButton, "LeftButton")
	ClearCursor()
end

function private.PostButtonOnClick(button)
	local frame = button:GetParentElement()
	local num = frame:GetElement("quantity.num"):GetText()
	local stackSize = frame:GetElement("quantity.stackSize"):GetText()
	num = tonumber(num)
	stackSize = tonumber(stackSize)
	local bid = TSM.Money.FromString(frame:GetElement("bid.text"):GetText())
	local buyout = TSM.Money.FromString(frame:GetElement("buyout.text"):GetText())
	if private.perItem then
		bid = bid * stackSize
		buyout = buyout * stackSize
	end

	local postBag, postSlot = nil, nil
	for _, bag, slot, itemString in TSMAPI_FOUR.Inventory.BagIterator(false, false, false, true) do
		if not postBag and not postSlot and itemString == button:GetContext() then
			postBag = bag
			postSlot = slot
		end
	end
	if postBag and postSlot then
		if strfind(button:GetContext(), "^p") then
			stackSize = 1
			num = 1
		end
		-- need to set the duration in the default UI to avoid Blizzard errors
		local postTime = TSMAPI_FOUR.Util.GetDistinctTableKey(POST_TIME_STRS, frame:GetElement("duration.toggle"):GetValue())
		AuctionFrameAuctions.duration = postTime
		ClearCursor()
		PickupContainerItem(postBag, postSlot)
		ClickAuctionSellItemButton(AuctionsItemButton, "LeftButton")
		PostAuction(bid, buyout, postTime, stackSize, num)
		ClearCursor()
	end
	frame:GetBaseElement():HideDialog()
end

function private.PostDialogCloseBtnOnClick(button)
	button:GetBaseElement():HideDialog()
end

function private.ScanFilterInputOnEnterPressed(input)
	local filter = strtrim(input:GetText())
	if filter == "" then
		return
	end
	local viewContainer = input:GetParentElement():GetParentElement():GetParentElement()
	viewContainer:SetPath("selection")
	private.StartFilterSearchHelper(viewContainer, filter)
end

function private.RescanBtnOnClick(button)
	if not TSM.UI.AuctionUI.StartingScan(L["Shopping"]) then
		return
	end
	private.fsm:ProcessEvent("EV_RESCAN_CLICKED")
end

function private.GetBagQuantity(itemString)
	local query = TSM.Inventory.BagTracking.CreateQuery()
		:Equal("baseItemString", TSMAPI_FOUR.Item.ToBaseItemString(itemString))
		:GreaterThanOrEqual("slotId", TSMAPI_FOUR.Util.JoinSlotId(0, 1))
		:LessThanOrEqual("slotId", TSMAPI_FOUR.Util.JoinSlotId(NUM_BAG_SLOTS + 1, 0))
		:Equal("usedCharges", false)
		:Equal("isBoP", false)
		:Equal("isBoA", false)
	local result = query:Sum("quantity")
	query:Release()
	return result or 0
end

function private.MaxNumBtnOnClick(button)
	button:GetElement("__parent.__parent.quantity.stackSize"):SetFocused(false)
	local itemString = button:GetElement("__parent.__parent.confirmBtn"):GetContext()
	local stackSize = tonumber(button:GetElement("__parent.__parent.quantity.stackSize"):GetText())
	local num = floor(private.GetBagQuantity(itemString) / stackSize)
	if num == 0 then
		return
	end
	button:GetElement("__parent.__parent.quantity.num")
		:SetText(num)
		:Draw()
end

function private.MaxStackSizeBtnOnClick(button)
	button:GetElement("__parent.__parent.quantity.num"):SetFocused(false)
	local itemString = button:GetElement("__parent.__parent.confirmBtn"):GetContext()
	local numHave = private.GetBagQuantity(itemString)
	local stackSize = min(TSMAPI_FOUR.Item.GetMaxStack(itemString), numHave)
	assert(stackSize > 0)
	button:GetElement("__parent.__parent.quantity.stackSize")
		:SetText(stackSize)
		:Draw()
	local numStacks = tonumber(button:GetElement("__parent.__parent.quantity.num"):GetText())
	local newStackSize = floor(numHave / stackSize)
	if numStacks > newStackSize then
		button:GetElement("__parent.__parent.quantity.num")
			:SetText(newStackSize)
			:Draw()
	end
end

function private.DurationOnValueChanged(toggle)
	private.UpdateDepositCost(toggle:GetParentElement():GetParentElement())
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.FSMCreate()
	local fsmContext = {
		db = TSMAPI_FOUR.Auction.NewDatabase("SHOPPING_AUCTIONS"),
		scanFrame = nil,
		scanName = "",
		itemInfo = nil,
		scanThreadId = nil,
		marketValueFunc = nil,
		auctionScan = nil,
		query = nil,
		progress = 0,
		progressText = L["Starting Scan..."],
		postDisabled = true,
		bidDisabled = true,
		buyoutDisabled = true,
		stopDisabled = true,
		findHash = nil,
		findAuction = nil,
		findResult = nil,
		numFound = 0,
		numBought = 0,
		numBid = 0,
		numConfirmed = 0,
		scanContext = nil,
		buyCallback = nil,
		stateCallback = nil,
	}

	TSMAPI_FOUR.Event.Register("CHAT_MSG_SYSTEM", private.FSMMessageEventHandler)
	TSMAPI_FOUR.Event.Register("UI_ERROR_MESSAGE", private.FSMMessageEventHandler)
	TSMAPI_FOUR.Event.Register("AUCTION_HOUSE_CLOSED", function()
		private.fsm:ProcessEvent("EV_AUCTION_HOUSE_CLOSED")
	end)
	local function UpdateScanFrame(context)
		if not context.scanFrame then
			return
		end
		context.scanFrame:GetElement("searchFrame.filterInput")
			:SetText(context.scanName)
		context.scanFrame:GetElement("searchFrame.rescanBtn")
			:SetDisabled(context.scanName == L["Gathering Search"])
		local bottom = context.scanFrame:GetElement("bottom")
		bottom:GetElement("postBtn"):SetDisabled(context.postDisabled)
		bottom:GetElement("bidBtn"):SetDisabled(context.bidDisabled)
		bottom:GetElement("buyoutBtn"):SetDisabled(context.buyoutDisabled)
		bottom:GetElement("stopBtn"):SetDisabled(context.stopDisabled)
		bottom:GetElement("progressBar"):SetProgress(context.progress)
			:SetText(context.progressText or "")
			:SetProgressIconHidden(context.progress == 1 or (context.findResult and context.numBought + context.numBid == context.numConfirmed))
		local auctionList = context.scanFrame:GetElement("auctions")
			:SetContext(context.auctionScan)
			:SetQuery(context.query)
			:SetMarketValueFunction(context.marketValueFunc)
			:SetSelectionDisabled(context.numBought + context.numBid ~= context.numConfirmed)
		if context.findAuction and not auctionList:GetSelectedRecord() then
			auctionList:SetSelectedRecord(context.findAuction)
		end
		context.scanFrame:Draw()
	end
	private.fsm = TSMAPI_FOUR.FSM.New("SHOPPING")
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_INIT")
			:SetOnEnter(function(context, ...)
				private.hasLastScan = false
				context.db:Truncate()
				context.scanName = ""
				context.itemInfo = nil
				if context.scanThreadId then
					TSMAPI_FOUR.Thread.Kill(context.scanThreadId)
					context.scanThreadId = nil
				end
				if context.query then
					context.query:Release()
				end
				if context.scanContext then
					TSMAPI_FOUR.Util.ReleaseTempTable(context.scanContext)
					context.scanContext = nil
				end
				if context.stateCallback then
					context.stateCallback("DONE")
				end
				context.query = nil
				context.marketValueFunc = nil
				context.progress = 0
				context.progressText = L["Starting Scan..."]
				context.postDisabled = true
				context.bidDisabled = true
				context.buyoutDisabled = true
				context.stopDisabled = true
				context.findHash = nil
				context.findAuction = nil
				context.findResult = nil
				context.numFound = 0
				context.numBought = 0
				context.numBid = 0
				context.numConfirmed = 0
				context.buyCallback = nil
				context.stateCallback = nil
				if context.auctionScan then
					context.auctionScan:Release()
					context.auctionScan = nil
				end
				if ... then
					return "ST_STARTING_SCAN", ...
				elseif context.scanFrame then
					context.scanFrame:GetParentElement():SetPath("selection", true)
					context.scanFrame = nil
				end
				TSM.UI.AuctionUI.EndedScan(L["Shopping"])
			end)
			:AddTransition("ST_INIT")
			:AddTransition("ST_STARTING_SCAN")
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_STARTING_SCAN")
			:SetOnEnter(function(context, scanThreadId, marketValueFunc, buyCallback, stateCallback, scanName, filterStr, itemInfo, ...)
				context.scanContext = TSMAPI_FOUR.Util.AcquireTempTable(scanThreadId, marketValueFunc, buyCallback, stateCallback, scanName, filterStr, itemInfo, ...)
				private.hasLastScan = true
				context.scanThreadId = scanThreadId
				context.marketValueFunc = marketValueFunc
				context.scanName = scanName
				context.itemInfo = itemInfo
				context.buyCallback = buyCallback
				context.stateCallback = stateCallback
				context.auctionScan = TSMAPI_FOUR.Auction.NewAuctionScan(context.db)
					:SetResolveSellers(true)
					:SetScript("OnProgressUpdate", private.FSMAuctionScanOnProgressUpdate)
				context.query = context.db:NewQuery()
				context.stopDisabled = false
				UpdateScanFrame(context)
				TSMAPI_FOUR.Thread.SetCallback(context.scanThreadId, private.FSMScanCallback)
				TSMAPI_FOUR.Thread.Start(context.scanThreadId, context.auctionScan, filterStr, itemInfo, ...)
				context.stateCallback("SCANNING")
				return "ST_SCANNING"
			end)
			:AddTransition("ST_SCANNING")
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_SCANNING")
			:AddTransition("ST_UPDATING_SCAN_PROGRESS")
			:AddTransition("ST_RESULTS")
			:AddTransition("ST_INIT")
			:AddEvent("EV_SCAN_PROGRESS_UPDATE", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_UPDATING_SCAN_PROGRESS"))
			:AddEvent("EV_SCAN_COMPLETE", function(context)
				TSM.UI.AuctionUI.EndedScan(L["Shopping"])
				if context.scanFrame then
					context.scanFrame:GetElement("auctions"):ExpandSingleResult()
				end
				context.stateCallback("RESULTS")
				return "ST_RESULTS"
			end)
			:AddEvent("EV_SCAN_FAILED", function(context)
				context.stateCallback("RESULTS")
				return "ST_RESULTS"
			end)
			:AddEvent("EV_STOP_SCAN", function(context)
				context.stateCallback("RESULTS")
				return "ST_RESULTS"
			end)
			:AddEvent("EV_RESCAN_CLICKED", function(context)
				if context.scanFrame then
					local viewContainer = context.scanFrame:GetParentElement()
					viewContainer:SetPath("selection", true)
					viewContainer:SetPath("scan", true)
					context.scanFrame = viewContainer:GetElement("scan")
				end
				local scanContext = context.scanContext
				context.scanContext = nil
				return "ST_INIT", TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(scanContext)
			end)
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_UPDATING_SCAN_PROGRESS")
			:SetOnEnter(function(context)
				local filtersScanned, numFilters, pagesScanned, numPages = context.auctionScan:GetProgress()
				local progress, text = nil, nil
				if filtersScanned == numFilters then
					progress = 1
					text = L["Done Scanning"]
				else
					if numPages == 0 then
						progress = filtersScanned / numFilters
						numPages = 1
					else
						progress = (filtersScanned + pagesScanned / numPages) / numFilters
					end
					text = format(L["Scanning %d / %d (Page %d / %d)"], filtersScanned + 1, numFilters, pagesScanned + 1, numPages)
				end
				context.progress = progress
				context.progressText = text
				UpdateScanFrame(context)
				return "ST_SCANNING"
			end)
			:AddTransition("ST_SCANNING")
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_RESULTS")
			:SetOnEnter(function(context)
				TSM.UI.AuctionUI.EndedScan(L["Shopping"])
				TSMAPI_FOUR.Thread.Kill(context.scanThreadId)
				context.findAuction = nil
				context.findResult = nil
				context.numFound = 0
				context.numBought = 0
				context.numBid = 0
				context.numConfirmed = 0
				context.progress = 1
				context.progressText = L["Done Scanning"]
				if context.itemInfo then
					local cheapest = context.db:NewQuery()
						:Equal("itemString", context.itemInfo.itemString)
						:OrderBy("itemBuyout", true)
						:GreaterThan("itemBuyout", 0)
						:GetFirstResultAndRelease()
					if cheapest then
						context.itemInfo.seller = cheapest:GetField("seller")
						context.itemInfo.displayedBid = cheapest:GetField("itemDisplayedBid")
						context.itemInfo.buyout = cheapest:GetField("itemBuyout")
						cheapest:Release()
					end
				end
				context.postDisabled = not context.itemInfo and true or private.GetBagQuantity(context.itemInfo.itemString) == 0
				context.bidDisabled = true
				context.buyoutDisabled = true
				context.stopDisabled = true
				UpdateScanFrame(context)
				if context.scanFrame and context.scanFrame:GetElement("auctions"):GetSelectedRecord() and TSM.UI.AuctionUI.StartingScan(L["Shopping"]) then
					return "ST_FINDING_AUCTION"
				end
			end)
			:AddTransition("ST_FINDING_AUCTION")
			:AddTransition("ST_INIT")
			:AddEvent("EV_AUCTION_SELECTION_CHANGED", function(context)
				assert(context.scanFrame)
				if context.scanFrame:GetElement("auctions"):GetSelectedRecord() and TSM.UI.AuctionUI.StartingScan(L["Shopping"]) then
					return "ST_FINDING_AUCTION"
				end
			end)
			:AddEvent("EV_POST_BUTTON_CLICK", function(context)
				private.PostDialogShow(context.scanFrame:GetBaseElement(), context.scanFrame:GetElement("auctions"):GetSelectedRecord() or private.itemInfo)
			end)
			:AddEvent("EV_RESCAN_CLICKED", function(context)
				if context.scanFrame then
					local viewContainer = context.scanFrame:GetParentElement()
					viewContainer:SetPath("selection", true)
					viewContainer:SetPath("scan", true)
					context.scanFrame = viewContainer:GetElement("scan")
				end
				local scanContext = context.scanContext
				context.scanContext = nil
				return "ST_INIT", TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(scanContext)
			end)
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_FINDING_AUCTION")
			:SetOnEnter(function(context)
				assert(context.scanFrame)
				context.findAuction = context.scanFrame:GetElement("auctions"):GetSelectedRecord()
				context.findHash = context.findAuction:GetField("hash")
				context.progress = 0
				context.progressText = L["Finding Selected Auction"]
				context.postDisabled = private.GetBagQuantity(context.scanFrame:GetElement("auctions"):GetSelectedRecord():GetField("itemString")) == 0
				context.bidDisabled = true
				context.buyoutDisabled = true
				UpdateScanFrame(context)
				TSM.Shopping.SearchCommon.StartFindAuction(context.auctionScan, context.findAuction, private.FSMFindAuctionCallback, false)
			end)
			:SetOnExit(function(context)
				TSM.Shopping.SearchCommon.StopFindAuction()
			end)
			:AddTransition("ST_FINDING_AUCTION")
			:AddTransition("ST_RESULTS")
			:AddTransition("ST_AUCTION_FOUND")
			:AddTransition("ST_AUCTION_NOT_FOUND")
			:AddTransition("ST_INIT")
			:AddEvent("EV_AUCTION_FOUND", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_AUCTION_FOUND"))
			:AddEvent("EV_AUCTION_NOT_FOUND", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_AUCTION_NOT_FOUND"))
			:AddEvent("EV_AUCTION_SELECTION_CHANGED", function(context)
				assert(context.scanFrame)
				if context.scanFrame:GetElement("auctions"):GetSelectedRecord() and TSM.UI.AuctionUI.StartingScan(L["Shopping"]) then
					return "ST_FINDING_AUCTION"
				else
					return "ST_RESULTS"
				end
			end)
			:AddEvent("EV_POST_BUTTON_CLICK", function(context)
				private.PostDialogShow(context.scanFrame:GetBaseElement(), context.scanFrame:GetElement("auctions"):GetSelectedRecord())
			end)
			:AddEvent("EV_RESCAN_CLICKED", function(context)
				if context.scanFrame then
					local viewContainer = context.scanFrame:GetParentElement()
					viewContainer:SetPath("selection", true)
					viewContainer:SetPath("scan", true)
					context.scanFrame = viewContainer:GetElement("scan")
				end
				local scanContext = context.scanContext
				context.scanContext = nil
				return "ST_INIT", TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(scanContext)
			end)
			:AddEvent("EV_SCAN_FRAME_HIDDEN", function(context)
				context.scanFrame = nil
				context.findAuction = nil
				return "ST_RESULTS"
			end)
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_AUCTION_FOUND")
			:SetOnEnter(function(context, result)
				TSM.UI.AuctionUI.EndedScan(L["Shopping"])
				context.findResult = result
				context.numFound = min(#result, context.auctionScan:GetNumCanBuy(context.findAuction) or math.huge)
				assert(context.numBought == 0 and context.numBid == 0 and context.numConfirmed == 0)
				return "ST_BUYING"
			end)
			:AddTransition("ST_BUYING")
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_AUCTION_NOT_FOUND")
			:SetOnEnter(function(context)
				TSM.UI.AuctionUI.EndedScan(L["Shopping"])
				local link = context.findAuction:GetField("rawLink")
				context.auctionScan:DeleteRowFromDB(context.findAuction)
				TSM:Printf(L["Failed to find auction for %s, so removing it from the results."], link)
				return "ST_RESULTS"
			end)
			:AddTransition("ST_RESULTS")
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_BUYING")
			:SetOnEnter(function(context, removeRecord)
				if removeRecord then
					if context.scanFrame then
						-- move to the next auction
						context.scanFrame:GetElement("auctions"):SelectNextRecord()
					end
					-- remove the one we just bought
					context.auctionScan:DeleteRowFromDB(context.findAuction, true)
					context.findAuction = context.scanFrame and context.scanFrame:GetElement("auctions"):GetSelectedRecord()
				end
				local selection = context.scanFrame and context.scanFrame:GetElement("auctions"):GetSelectedRecord()
				local auctionSelected = selection and context.findHash == selection:GetField("hash")
				local numCanBuy = not auctionSelected and 0 or (context.numFound - context.numBought - context.numBid)
				local numConfirming = context.numBought + context.numBid - context.numConfirmed
				local progressText = nil
				if numConfirming == 0 and numCanBuy == 0 then
					-- we're done buying and confirming this batch - try to select the next auction
					return "ST_RESULTS"
				elseif numConfirming == 0 then
					-- we can still buy more
					progressText = format(L["Buy %d / %d"], context.numBought + context.numBid + 1, context.numFound)
				elseif numCanBuy == 0 then
					-- we're just confirming
					progressText = format(L["Confirming %d / %d"], context.numConfirmed + 1, context.numFound)
				else
					-- we can buy more while confirming
					progressText = format(L["Buy %d / %d (Confirming %d / %d)"], context.numBought + context.numBid + 1, context.numFound, context.numConfirmed + 1, context.numFound)
				end
				context.progress = context.numConfirmed / context.numFound
				context.progressText = progressText
				context.postDisabled = private.GetBagQuantity(selection:GetField("itemString")) == 0
				local requiredBid = TSM.Auction.Util.GetRequiredBidByScanResultRow(selection)
				context.bidDisabled = selection:GetField("displayedBid") == selection:GetField("buyout") or numCanBuy == 0 or GetMoney() < requiredBid or TSMAPI_FOUR.PlayerInfo.IsPlayer(selection.seller, true, true, true) or selection:GetField("isHighBidder")
				context.buyoutDisabled = selection:GetField("buyout") == 0 or numCanBuy == 0 or GetMoney() < selection:GetField("buyout") or TSMAPI_FOUR.PlayerInfo.IsPlayer(selection.seller, true, true, true)
				UpdateScanFrame(context)
			end)
			:AddTransition("ST_BUYING")
			:AddTransition("ST_BUY_CONFIRMATION")
			:AddTransition("ST_BID_CONFIRMATION")
			:AddTransition("ST_PLACING_BUY")
			:AddTransition("ST_PLACING_BID")
			:AddTransition("ST_CONFIRMING_BUY")
			:AddTransition("ST_RESULTS")
			:AddTransition("ST_INIT")
			:AddEvent("EV_AUCTION_SELECTION_CHANGED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_BUYING"))
			:AddEvent("EV_BUY_CONFIRMATION", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_BUY_CONFIRMATION"))
			:AddEvent("EV_BID_CONFIRMATION", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_BID_CONFIRMATION"))
			:AddEvent("EV_BID_AUCTION", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_PLACING_BID"))
			:AddEvent("EV_BUY_AUCTION", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_PLACING_BUY"))
			:AddEvent("EV_MSG", function(context, msg)
				if not context.findAuction then
					return
				end
				if msg == LE_GAME_ERR_AUCTION_HIGHER_BID or msg == LE_GAME_ERR_ITEM_NOT_FOUND or msg == LE_GAME_ERR_AUCTION_BID_OWN or msg == LE_GAME_ERR_NOT_ENOUGH_MONEY then
					-- failed to buy an auction
					return "ST_CONFIRMING_BUY", false
				elseif msg == format(ERR_AUCTION_WON_S, context.findAuction:GetField("rawName")) or (context.numBid > 0 and msg == ERR_AUCTION_BID_PLACED) then
					-- bought an auction
					return "ST_CONFIRMING_BUY", true
				end
			end)
			:AddEvent("EV_POST_BUTTON_CLICK", function(context)
				private.PostDialogShow(context.scanFrame:GetBaseElement(), context.scanFrame:GetElement("auctions"):GetSelectedRecord())
			end)
			:AddEvent("EV_RESCAN_CLICKED", function(context)
				if context.scanFrame then
					local viewContainer = context.scanFrame:GetParentElement()
					viewContainer:SetPath("selection", true)
					viewContainer:SetPath("scan", true)
					context.scanFrame = viewContainer:GetElement("scan")
				end
				local scanContext = context.scanContext
				context.scanContext = nil
				return "ST_INIT", TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(scanContext)
			end)
			:AddEvent("EV_SCAN_FRAME_HIDDEN", function(context)
				context.scanFrame = nil
				context.findAuction = nil
				return "ST_RESULTS"
			end)
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_BUY_CONFIRMATION")
			:SetOnEnter(function(context)
				local selection = context.scanFrame:GetElement("auctions"):GetSelectedRecord()
				local price = TSMAPI_FOUR.CustomPrice.GetValue(TSM.db.global.shoppingOptions.buyoutAlertSource, selection:GetField("itemString"))
				if not TSM.db.global.shoppingOptions.buyoutConfirm or (price and ceil(selection:GetField("buyout") / selection:GetField("stackSize")) < price) then
					if selection:GetField("isHighBidder") then
						private.BuyoutConfirmationShow(context, true)
					else
						return "ST_PLACING_BUY"
					end
				else
					private.BuyoutConfirmationShow(context, true)
				end
				return "ST_BUYING"
			end)
			:AddTransition("ST_PLACING_BUY")
			:AddTransition("ST_BUYING")
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_BID_CONFIRMATION")
			:SetOnEnter(function(context)
				local selection = context.scanFrame:GetElement("auctions"):GetSelectedRecord()
				local price = TSMAPI_FOUR.CustomPrice.GetValue(TSM.db.global.shoppingOptions.buyoutAlertSource, selection:GetField("itemString"))
				local requiredBid = TSM.Auction.Util.GetRequiredBidByScanResultRow(selection)
				if not TSM.db.global.shoppingOptions.buyoutConfirm or (price and ceil(requiredBid / selection:GetField("stackSize")) < price) then
					return "ST_PLACING_BID"
				else
					private.BuyoutConfirmationShow(context, false)
				end
				return "ST_BUYING"
			end)
			:AddTransition("ST_PLACING_BID")
			:AddTransition("ST_BUYING")
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_PLACING_BUY")
			:SetOnEnter(function(context)
				local index = tremove(context.findResult, #context.findResult)
				assert(index)
				if context.auctionScan:ValidateIndex(index, context.findAuction) then
					-- buy the auction
					PlaceAuctionBid("list", index, context.findAuction:GetField("buyout"))
					context.numBought = context.numBought + 1
				else
					TSM:Printf(L["Failed to buy auction of %s."], context.findAuction:GetField("rawLink"))
				end
				return "ST_BUYING"
			end)
			:AddTransition("ST_BUYING")
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_CONFIRMING_BUY")
			:SetOnEnter(function(context, success)
				if success then
					context.buyCallback(context.findAuction:GetField("targetItem"), context.findAuction:GetField("stackSize") * context.findAuction:GetField("targetItemRate"))
				else
					TSM:Printf(L["Failed to buy auction of %s."], context.findAuction:GetField("rawLink"))
				end
				context.numConfirmed = context.numConfirmed + 1
				return "ST_BUYING", true
			end)
			:AddTransition("ST_BUYING")
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_PLACING_BID")
			:SetOnEnter(function(context)
				local index = tremove(context.findResult, #context.findResult)
				assert(index)
				if context.auctionScan:ValidateIndex(index, context.findAuction) then
					-- bid on the auction
					PlaceAuctionBid("list", index, TSM.Auction.Util.GetRequiredBidByScanResultRow(context.findAuction))
					context.numBid = context.numBid + 1
				else
					TSM:Printf(L["Failed to bid on auction of %s."], context.findAuction:GetField("rawLink"))
				end
				return "ST_BUYING"
			end)
			:AddTransition("ST_BUYING")
		)
		:AddDefaultEvent("EV_START_SCAN", function(context, ...)
			return "ST_INIT", ...
		end)
		:AddDefaultEvent("EV_SCAN_FRAME_SHOWN", function(context, scanFrame)
			context.scanFrame = scanFrame
			UpdateScanFrame(context)
			context.scanFrame:GetElement("auctions")
				:UpdateData(true)
				:ExpandSingleResult()
		end)
		:AddDefaultEvent("EV_SCAN_FRAME_HIDDEN", function(context)
			context.scanFrame = nil
			context.findAuction = nil
		end)
		:AddDefaultEvent("EV_AUCTION_HOUSE_CLOSED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_INIT"))
		:AddDefaultEvent("EV_SCAN_BACK_BUTTON_CLICKED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_INIT"))
		:Init("ST_INIT", fsmContext)
end

function private.FSMMessageEventHandler(_, msg)
	private.fsm:ProcessEvent("EV_MSG", msg)
end

function private.FSMAuctionScanOnProgressUpdate(auctionScan)
	private.fsm:ProcessEvent("EV_SCAN_PROGRESS_UPDATE")
end

function private.FSMScanCallback(success)
	if success then
		private.fsm:ProcessEvent("EV_SCAN_COMPLETE")
	else
		private.fsm:ProcessEvent("EV_SCAN_FAILED")
	end
end

function private.FSMFindAuctionCallback(result)
	if result then
		private.fsm:ProcessEvent("EV_AUCTION_FOUND", result)
	else
		private.fsm:ProcessEvent("EV_AUCTION_NOT_FOUND")
	end
end
