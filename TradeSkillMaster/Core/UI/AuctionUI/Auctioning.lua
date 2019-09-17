-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Auctioning = TSM.UI.AuctionUI:NewPackage("Auctioning")
local L = TSM.L
local private = {
	contentPath = "selection",
	hasLastScan = false,
	fsm = nil,
	scanContext = {},
	scanQuery = nil,
	groupSearch = "",
	selectionFrame = nil,
	logQuery = nil,
}
local DEFAULT_DIVIDED_CONTAINER_CONTEXT = {
	leftWidth = 272,
}
local DEFAULT_TAB_GROUP_CONTEXT = {
	pathIndex = 1
}
-- TODO: these should eventually go in the saved variables
private.dividedContainerContext = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Auctioning.OnInitialize()
	TSM.UI.AuctionUI.RegisterTopLevelPage(L["Auctioning"], "iconPack.24x24/Posting", private.GetAuctioningFrame, private.OnItemLinked)
	private.FSMCreate()
end



-- ============================================================================
-- Auctioning UI
-- ============================================================================

function private.GetAuctioningFrame()
	TSM.UI.AnalyticsRecordPathChange("auction", "auctioning")
	if not private.hasLastScan then
		private.contentPath = "selection"
	end
	return TSMAPI_FOUR.UI.NewElement("ViewContainer", "auctioning")
		:SetNavCallback(private.GetAuctioningContentFrame)
		:AddPath("selection")
		:AddPath("scan")
		:SetPath(private.contentPath)
end

function private.GetAuctioningContentFrame(_, path)
	private.contentPath = path
	if path == "selection" then
		return private.GetAuctioningSelectionFrame()
	elseif path == "scan" then
		return private.GetAuctioningScanFrame()
	else
		error("Unexpected path: "..tostring(path))
	end
end

function private.GetAuctioningSelectionFrame()
	TSM.UI.AnalyticsRecordPathChange("auction", "auctioning", "selection")
	local frame = TSMAPI_FOUR.UI.NewElement("DividedContainer", "selection")
		:SetStyle("background", "#272727")
		:SetContextTable(private.dividedContainerContext, DEFAULT_DIVIDED_CONTAINER_CONTEXT)
		:SetMinWidth(272, 300)
		:SetLeftChild(TSMAPI_FOUR.UI.NewElement("Frame", "groupSelection")
			:SetStyle("padding", { top = 33 })
			:SetLayout("VERTICAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "title")
				:SetLayout("HORIZONTAL")
				:SetStyle("margin", { left = 8, right = 8, bottom = 12 })
				:SetStyle("height", 20)
				:AddChild(TSMAPI_FOUR.UI.NewElement("SearchInput", "search")
					:SetStyle("margin", { right = 8 })
					:SetText(private.groupSearch)
					:SetHintText(L["Search Groups"])
					:SetScript("OnTextChanged", private.GroupSearchOnTextChanged)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "moreBtn")
					:SetStyle("width", 18)
					:SetStyle("height", 18)
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
				:SetContextTable(TSM.db.profile.internalData.auctioningGroupTreeContext)
				:SetSearchString(private.groupSearch)
				:SetScript("OnGroupSelectionChanged", private.GroupTreeOnGroupSelectionChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", 2)
				:SetStyle("color", "#9d9d9d")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "postScanBtn")
				:SetStyle("height", 26)
				:SetStyle("margin", 8)
				:SetText(L["RUN POST SCAN"])
				:SetScript("OnClick", private.RunPostButtonOnclick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "cancelScanBtn")
				:SetStyle("height", 26)
				:SetStyle("margin", { left = 8, right = 8, bottom = 8 })
				:SetText(L["RUN CANCEL SCAN"])
				:SetScript("OnClick", private.RunCancelButtonOnclick)
			)
		)
		:SetRightChild(TSMAPI_FOUR.UI.NewElement("Frame", "content")
			:SetLayout("VERTICAL")
			:SetStyle("margin", { top = 43 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("TabGroup", "buttons")
				:SetNavCallback(private.GetScansElement)
				:SetContextTable(TSM.db.profile.internalData.auctioningTabGroupContext, DEFAULT_TAB_GROUP_CONTEXT)
				:AddPath(L["Recent Scans"])
				:AddPath(L["Favorite Scans"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", 2)
				:SetStyle("color", "#9d9d9d")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
				:SetStyle("height", 22)
				:SetStyle("margin", { top = 8, left = 8, right = 8, bottom = 4 })
				:SetStyle("font", TSM.UI.Fonts.MontserratBold)
				:SetStyle("fontHeight", 16)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Items in Bags"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionScrollingTable", "bagScrollingTable")
				:SetStyle("headerBackground", "#272727")
				:GetScrollingTableInfo()
					:NewColumn("item")
						:SetTitles(L["Item"])
						:SetHeaderIndent(18)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetIconSize(12)
						:SetTextInfo("autoBaseItemString", TSM.UI.GetColoredItemName)
						:SetIconInfo("itemTexture")
						:SetTooltipInfo("autoBaseItemString")
						:SetSortInfo("name")
						:Commit()
					:NewColumn("operation")
						:SetTitles(L["Auctioning Operation"])
						:SetWidth(250)
						:SetFont(TSM.UI.Fonts.MontserratMedium)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo("firstOperation", private.BagGetOperationText)
						:SetSortInfo("firstOperation")
						:Commit()
					:Commit()
				:SetQuery(TSM.Auctioning.PostScan.CreateBagsQuery())
				:SetAutoReleaseQuery(true)
				:SetSelectionValidator(private.BagScrollingTableIsSelectionEnabled)
				:SetScript("OnSelectionChanged", private.BagScrollingTableOnSelectionChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", 2)
				:SetStyle("color", "#9d9d9d")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "buttonFrame")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 42)
				:SetStyle("padding", 8)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
				:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "postBagsBtn")
					:SetStyle("width", 246)
					:SetStyle("height", 26)
					:SetStyle("margin", { left = 8, right = 8 })
					:SetDisabled(true)
					:SetText(L["POST SELECTED"])
					:SetScript("OnClick", private.RunPostBagsButtonOnclick)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "clearSelectionBtn")
					:SetStyle("height", 20)
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 10)
					:SetStyle("textColor", "#ffffff")
					:SetText(L["Clear Selection"])
					:SetDisabled(true)
					:SetScript("OnClick", private.RunClearSelectionButtonOnclick)
				)
			)
		)
		:SetScript("OnUpdate", private.SelectionOnUpdate)
		:SetScript("OnHide", private.SelectionOnHide)
	local noGroupSelected = frame:GetElement("groupSelection.groupTree"):IsSelectionCleared(true)
	frame:GetElement("groupSelection.postScanBtn"):SetDisabled(noGroupSelected)
	frame:GetElement("groupSelection.cancelScanBtn"):SetDisabled(noGroupSelected)
	private.selectionFrame = frame
	return frame
end

function private.GetScansElement(_, button)
	if button == L["Recent Scans"] then
		return TSMAPI_FOUR.UI.NewElement("SearchList", "list")
			:SetQuery(TSM.Auctioning.SavedSearches.CreateRecentSearchesQuery())
			:SetEditButtonHidden(true)
			:SetScript("OnFavoriteChanged", private.SearchListOnFavoriteChanged)
			:SetScript("OnDelete", private.SearchListOnDelete)
			:SetScript("OnRowClick", private.SearchListOnRowClick)
	elseif button == L["Favorite Scans"] then
		return TSMAPI_FOUR.UI.NewElement("SearchList", "list")
			:SetQuery(TSM.Auctioning.SavedSearches.CreateFavoriteSearchesQuery())
			:SetEditButtonHidden(true)
			:SetScript("OnFavoriteChanged", private.SearchListOnFavoriteChanged)
			:SetScript("OnDelete", private.SearchListOnDelete)
			:SetScript("OnRowClick", private.SearchListOnRowClick)
	else
		error("Unexpected button: "..tostring(button))
	end
end

function private.GetAuctioningScanFrame()
	TSM.UI.AnalyticsRecordPathChange("auction", "auctioning", "scan")
	return TSMAPI_FOUR.UI.NewElement("Frame", "scan")
		:SetLayout("VERTICAL")
		:SetStyle("background", "#272727")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "backFrame")
			:SetLayout("HORIZONTAL")
			:SetStyle("margin", { left = 8, top = 6, bottom = 13 })
			:SetStyle("height", 18)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "backIcon")
				:SetStyle("width", 18)
				:SetStyle("backgroundTexturePack", "iconPack.18x18/SideArrow")
				:SetStyle("backgroundTextureRotation", 180)
				:SetScript("OnClick", private.ScanBackButtonOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer"))
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "header")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 75)
			:SetStyle("margin", { left = 10, right = 10, bottom = 12 })
			:SetStyle("padding", { bottom = 4, left = 10, right = 16 })
			:SetStyle("background", "#2f2f2f")
			:SetStyle("borderTexture", "Interface\\Addons\\TradeSkillMaster\\Media\\ItemPreviewEdgeFrame.blp")
			:SetStyle("borderSize", 8)
			:SetStyle("borderInset", 1)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "item")
				:SetLayout("VERTICAL")
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "content")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 32)
					:SetStyle("margin", { bottom = 6 })
					:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "icon")
						:SetStyle("width", 30)
						:SetStyle("height", 30)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
						:SetStyle("height", 32)
						:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
						:SetStyle("fontHeight", 16)
						:SetStyle("margin", { left = 8 })
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "cost")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 16)
					:SetStyle("margin", { left = 1 })
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc")
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 12)
						:SetStyle("textColor", "#e2e2e2")
						:SetStyle("autoWidth", true)
						:SetText(L["Deposit Cost"] .. ":")
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
						:SetStyle("margin", { left = 4 })
						:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
						:SetStyle("fontHeight", 12)
						:SetStyle("justifyH", "LEFT")
					)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "details1")
				:SetLayout("VERTICAL")
				:SetStyle("width", 230)
				:SetStyle("margin", { left = 10, right = 34, top = 0 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "header")
					:SetStyle("height", 15)
					:SetStyle("font", TSM.UI.Fonts.MontserratBold)
					:SetStyle("fontHeight", 10)
					:SetStyle("textColor", "#ffffff")
					:SetText(L["AUCTION DETAILS"])
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "bid")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 16)
					:SetStyle("margin", { bottom = 4, top = 4 })
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc")
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
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
						:SetScript("OnValueChanged", private.BidBuyoutTextOnValueChanged)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "editBtn")
						:SetStyle("width", 12)
						:SetStyle("height", 12)
						:SetStyle("margin", { left = 4 })
						:SetStyle("backgroundTexturePack", "iconPack.12x12/Edit")
						:SetScript("OnClick", private.EditBtnOnClick)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "buyout")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 16)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc")
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
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
						:SetScript("OnValueChanged", private.BidBuyoutTextOnValueChanged)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "editBtn")
						:SetStyle("width", 12)
						:SetStyle("height", 12)
						:SetStyle("margin", { left = 4 })
						:SetStyle("backgroundTexturePack", "iconPack.12x12/Edit")
						:SetScript("OnClick", private.EditBtnOnClick)
					)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "details2")
				:SetLayout("VERTICAL")
				:SetStyle("width", 230)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "header")
					:SetStyle("height", 15)
					:SetStyle("font", TSM.UI.Fonts.MontserratBold)
					:SetStyle("fontHeight", 10)
					:SetStyle("textColor", "#ffffff")
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "quantity")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 16)
					:SetStyle("margin", { bottom = 4, top = 4 })
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc")
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 12)
						:SetStyle("textColor", "#e2e2e2")
						:SetStyle("autoWidth", true)
						:SetText(L["Stack / Quantity"] .. ":")
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
						:SetStyle("margin.left", 4)
						:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
						:SetStyle("fontHeight", 12)
						:SetStyle("justifyH", "RIGHT")
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "duration")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 16)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc")
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 12)
						:SetStyle("textColor", "#e2e2e2")
						:SetStyle("autoWidth", true)
						:SetText(L["Auction Duration"] .. ":")
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
					:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "dropdown")
						:SetStyle("width", 100)
						:SetStyle("textPadding", 4)
						:SetStyle("background", "#00000000")
						:SetStyle("border", "#00000000")
						:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
						:SetStyle("fontHeight", 12)
						:SetStyle("openFont", TSM.UI.Fonts.RobotoMedium)
						:SetStyle("openFontHeight", 12)
						:SetItems(TSM.CONST.AUCTION_DURATIONS)
						:SetScript("OnSelectionChanged", private.DurationOnSelectionChanged)
					)
				)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("SimpleTabGroup", "tabs")
			:SetNavCallback(private.ScanNavCallback)
			:AddPath(L["Auctioning Log"], true)
			:AddPath(L["All Auctions"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "bottom")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 38)
			:SetStyle("padding.bottom", -2)
			:SetStyle("padding.top", 6)
			:SetStyle("background", "#363636")
			:AddChild(TSMAPI_FOUR.UI.NewElement("ProgressBar", "progressBar")
				:SetStyle("height", 28)
				:SetStyle("margin.right", 8)
				:SetProgress(0)
				:SetProgressIconHidden(false)
				:SetText(L["Starting Scan..."])
			)
			:AddChild(TSMAPI_FOUR.UI.NewNamedElement("ActionButton", "processBtn", "TSMAuctioningBtn")
				:SetStyle("width", 107)
				:SetStyle("height", 26)
				:SetStyle("margin.right", 8)
				:SetStyle("iconTexturePack", "iconPack.14x14/Post")
				:SetText(L["POST"])
				:SetDisabled(true)
				:DisableClickCooldown(true)
				:SetScript("OnClick", private.ProcessButtonOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "skipBtn")
				:SetStyle("width", 107)
				:SetStyle("height", 26)
				:SetStyle("margin.right", 8)
				:SetStyle("iconTexturePack", "iconPack.14x14/Skip")
				:SetText(L["SKIP"])
				:SetDisabled(true)
				:DisableClickCooldown(true)
				:SetScript("OnClick", private.SkipButtonOnClick)
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

function private.ScanNavCallback(_, path)
	if path == L["Auctioning Log"] then
		TSM.UI.AnalyticsRecordPathChange("auction", "auctioning", "scan", "log")
		private.logQuery = private.logQuery or TSM.Auctioning.Log.CreateQuery()
		return TSMAPI_FOUR.UI.NewElement("Frame", "logFrame")
			:SetLayout("VERTICAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("color", "#9d9d9d")
				:SetStyle("height", 1)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "log")
				:SetStyle("headerBackground", "#404040")
				:SetStyle("headerFontHeight", 12)
				:GetScrollingTableInfo()
					:NewColumn("index")
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("CENTER")
						:SetTextInfo("index", private.LogGetIndexText)
						:SetSortInfo("index")
						:SetWidth(20)
						:Commit()
					:NewColumn("item")
						:SetTitles(L["Item"])
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetIconSize(12)
						:SetTextInfo("itemString", TSM.UI.GetColoredItemName)
						:SetIconInfo("itemString", TSMAPI_FOUR.Item.GetTexture)
						:SetTooltipInfo("itemString")
						:SetSortInfo("name")
						:Commit()
					:NewColumn("buyout")
						:SetTitles(L["Your Buyout"])
						:SetWidth(110)
						:SetFont(TSM.UI.Fonts.RobotoMedium)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("buyout", private.LogGetBuyoutText)
						:SetSortInfo("buyout")
						:Commit()
					:NewColumn("operation")
						:SetTitles(L["Operation"])
						:SetWidth(100)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo("operation")
						:SetSortInfo("operation")
						:Commit()
					:NewColumn("seller")
						:SetTitles(L["Seller"])
						:SetWidth(90)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo("seller")
						:SetSortInfo("seller")
						:Commit()
					:NewColumn("info")
						:SetTitles(INFO)
						:SetWidth(222)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo("info")
						:SetSortInfo("info")
						:Commit()
					:Commit()
				:SetQuery(private.logQuery)
				:SetSelectionDisabled(true)
			)
	elseif path == L["All Auctions"] then
		TSM.UI.AnalyticsRecordPathChange("auction", "auctioning", "scan", "auctions")
		return TSMAPI_FOUR.UI.NewElement("Frame", "auctionsFrame")
			:SetLayout("VERTICAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("color", "#9d9d9d")
				:SetStyle("height", 1)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("AuctionScrollingTable", "auctions")
				:SetQuery(private.scanQuery)
				:SetMarketValueFunction(private.MarketValueFunction)
			)
	else
		error("Unexpected path: "..tostring(path))
	end
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.OnItemLinked(_, itemLink)
	if not private.selectionFrame or not TSM.UI.AuctionUI.StartingScan(L["Auctioning"]) then
		return false
	end
	wipe(private.scanContext)
	private.scanContext.isItems = true
	tinsert(private.scanContext, TSMAPI_FOUR.Item.ToBaseItemString(itemLink, true))
	private.selectionFrame:GetParentElement():SetPath("scan", true)
	private.fsm:ProcessEvent("EV_START_SCAN", "POST", private.scanContext)
	return true
end

function private.SelectionOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)
	frame:GetBaseElement():SetBottomPadding(nil)
end

function private.SelectionOnHide(frame)
	assert(frame == private.selectionFrame)
	private.selectionFrame = nil
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
	baseFrame:GetElement("content.auctioning.selection.groupSelection.groupTree"):SelectAll()
	baseFrame:HideDialog()
end

function private.DeselectAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.auctioning.selection.groupSelection.groupTree"):DeselectAll()
	baseFrame:HideDialog()
end

function private.ExpandAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.auctioning.selection.groupSelection.groupTree"):ExpandAll()
	baseFrame:HideDialog()
end

function private.CollapseAllBtnOnClick(button)
	local baseFrame = button:GetBaseElement()
	baseFrame:GetElement("content.auctioning.selection.groupSelection.groupTree"):CollapseAll()
	baseFrame:HideDialog()
end

function private.GroupTreeGetList(groups, headerNameLookup)
	TSM.UI.ApplicationGroupTreeGetGroupList(groups, headerNameLookup, "Auctioning")
end

function private.GroupTreeOnGroupSelectionChanged(groupTree)
	local postScanBtn = groupTree:GetElement("__parent.postScanBtn")
	postScanBtn:SetDisabled(groupTree:IsSelectionCleared())
	postScanBtn:Draw()
	local cancelScanBtn = groupTree:GetElement("__parent.cancelScanBtn")
	cancelScanBtn:SetDisabled(groupTree:IsSelectionCleared())
	cancelScanBtn:Draw()
end

function private.RunPostButtonOnclick(button)
	if not TSM.UI.AuctionUI.StartingScan(L["Auctioning"]) then
		return
	end
	wipe(private.scanContext)
	for _, groupPath in button:GetElement("__parent.groupTree"):SelectedGroupsIterator() do
		tinsert(private.scanContext, groupPath)
	end
	button:GetParentElement():GetParentElement():GetParentElement():SetPath("scan", true)
	private.fsm:ProcessEvent("EV_START_SCAN", "POST", private.scanContext)
end

function private.RunCancelButtonOnclick(button)
	if not TSM.UI.AuctionUI.StartingScan(L["Auctioning"]) then
		return
	end
	wipe(private.scanContext)
	for _, groupPath in button:GetElement("__parent.groupTree"):SelectedGroupsIterator() do
		tinsert(private.scanContext, groupPath)
	end
	button:GetParentElement():GetParentElement():GetParentElement():SetPath("scan", true)
	private.fsm:ProcessEvent("EV_START_SCAN", "CANCEL", private.scanContext)
end

function private.SearchListOnFavoriteChanged(_, dbRow, isFavorite)
	TSM.Auctioning.SavedSearches.SetSearchIsFavorite(dbRow, isFavorite)
end

function private.SearchListOnDelete(_, dbRow)
	TSM.Auctioning.SavedSearches.DeleteSearch(dbRow)
end

function private.SearchListOnRowClick(searchList, dbRow)
	if not TSM.UI.AuctionUI.StartingScan(L["Auctioning"]) then
		return
	end
	local scanType = dbRow:GetField("searchType")
	wipe(private.scanContext)
	private.scanContext.isItems = scanType == "postItems" or nil
	TSM.Auctioning.SavedSearches.FiltersToTable(dbRow, private.scanContext)
	searchList:GetParentElement():GetParentElement():GetParentElement():GetParentElement():SetPath("scan", true)
	private.fsm:ProcessEvent("EV_START_SCAN", scanType == "cancelGroups" and "CANCEL" or "POST", private.scanContext)
end

function private.ProcessButtonOnClick(button)
	private.fsm:ProcessEvent("EV_PROCESS_CLICKED")
end

function private.SkipButtonOnClick(button)
	private.fsm:ProcessEvent("EV_SKIP_CLICKED")
end

function private.StopButtonOnClick(button)
	private.fsm:ProcessEvent("EV_STOP_BUTTON_CLICKED")
end

function private.ScanFrameOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)
	frame:GetBaseElement():SetBottomPadding(38)
	private.fsm:ProcessEvent("EV_SCAN_FRAME_SHOWN", frame)
end

function private.ScanFrameOnHide(frame)
	private.fsm:ProcessEvent("EV_SCAN_FRAME_HIDDEN")
end

function private.BagScrollingTableOnSelectionChanged(table)
	local postBagsBtn = table:GetElement("__parent.buttonFrame.postBagsBtn")
	postBagsBtn:SetDisabled(table:IsSelectionCleared())
	postBagsBtn:Draw()
	local clearBtn = table:GetElement("__parent.buttonFrame.clearSelectionBtn")
	clearBtn:SetDisabled(table:IsSelectionCleared())
	clearBtn:Draw()
end

function private.RunClearSelectionButtonOnclick(button)
	local scrollFrame = button:GetParentElement():GetParentElement():GetElement("bagScrollingTable")
	scrollFrame:ClearSelection()
	scrollFrame:Draw()
end

function private.RunPostBagsButtonOnclick(button)
	if not TSM.UI.AuctionUI.StartingScan(L["Auctioning"]) then
		return
	end
	wipe(private.scanContext)
	private.scanContext.isItems = true
	for _, row in button:GetElement("__parent.__parent.bagScrollingTable"):SelectionIterator() do
		local autoBaseItemString, operation = row:GetFields("autoBaseItemString", "firstOperation")
		if operation then
			tinsert(private.scanContext, autoBaseItemString)
		end
	end
	button:GetParentElement():GetParentElement():GetParentElement():GetParentElement():SetPath("scan", true)
	private.fsm:ProcessEvent("EV_START_SCAN", "POST", private.scanContext)
end

function private.ScanBackButtonOnClick()
	ClearCursor()
	ClickAuctionSellItemButton(AuctionsItemButton, "LeftButton")
	ClearCursor()

	private.fsm:ProcessEvent("EV_BACK_BUTTON_CLICKED")
end

function private.EditBtnOnClick(button)
	button:GetElement("__parent.text"):SetEditing(true)
end

function private.BidBuyoutTextOnValueChanged(text, value)
	value = TSM.Money.FromString(value)
	if value then
		value = min(value, MAXIMUM_BID_PRICE)
		private.fsm:ProcessEvent("EV_POST_DETAIL_CHANGED", text:GetContext(), value)
	else
		text:Draw()
	end
end

function private.DurationOnSelectionChanged(dropdown, value)
	local postTime = TSMAPI_FOUR.Util.GetDistinctTableKey(TSM.CONST.AUCTION_DURATIONS, value)
	private.fsm:ProcessEvent("EV_POST_DETAIL_CHANGED", "postTime", postTime)
end



-- ============================================================================
-- FSM
-- ============================================================================

function private.FSMCreate()
	local fsmContext = {
		db = TSMAPI_FOUR.Auction.NewDatabase("AUCTIONING_AUCTIONS"),
		itemString = nil,
		scanFrame = nil,
		scanThreadId = nil,
		scanType = nil,
		auctionScan = nil,
		scanProgress = 0,
		scanProgressText = L["Starting Scan..."],
	}
	private.scanQuery = fsmContext.db:NewQuery()
	TSMAPI_FOUR.Event.Register("AUCTION_HOUSE_CLOSED", function()
		private.fsm:ProcessEvent("EV_AUCTION_HOUSE_CLOSED")
	end)
	TSMAPI_FOUR.Event.Register("CHAT_MSG_SYSTEM", function(_, msg)
		if msg == ERR_AUCTION_STARTED then
			private.fsm:ProcessEvent("EV_AUCTION_POST_CONFIRM", true)
		elseif msg == ERR_AUCTION_REMOVED then
			private.fsm:ProcessEvent("EV_AUCTION_CANCEL_CONFIRM", true)
		end
	end)
	local POST_ERR_MSGS = {
		-- errors where we can retry
		[ERR_ITEM_NOT_FOUND] = true,
		[ERR_AUCTION_DATABASE_ERROR] = true,
		-- errors where we can't retry
		[ERR_AUCTION_REPAIR_ITEM] = false,
		[ERR_AUCTION_LIMITED_DURATION_ITEM] = false,
		[ERR_AUCTION_USED_CHARGES] = false,
		[ERR_AUCTION_WRAPPED_ITEM] = false,
		[ERR_AUCTION_BAG] = false,
		[ERR_NOT_ENOUGH_MONEY] = false,
	}
	TSMAPI_FOUR.Event.Register("UI_ERROR_MESSAGE", function(_, _, msg)
		if POST_ERR_MSGS[msg] ~= nil then
			private.fsm:ProcessEvent("EV_AUCTION_POST_CONFIRM", false, POST_ERR_MSGS[msg])
		end
		if msg == ERR_ITEM_NOT_FOUND then
			private.fsm:ProcessEvent("EV_AUCTION_CANCEL_CONFIRM", false, true)
		end
	end)
	local function UpdateDepositCost(context)
		if context.scanType ~= "POST" then
			return
		end

		local header = context.scanFrame:GetElement("header")
		local detailsHeader1 = header:GetElement("details1")
		local detailsHeader2 = header:GetElement("details2")

		local currentRow = TSM.Auctioning.PostScan.GetCurrentRow()
		if not currentRow then
			return
		end

		local itemString = currentRow:GetField("itemString")

		local postBag, postSlot = nil, nil
		for _, bag, slot, bagItemString in TSMAPI_FOUR.Inventory.BagIterator(true, false, false, true) do
			if not postBag and not postSlot and bagItemString == itemString then
				postBag = bag
				postSlot = slot
			end
		end
		if postBag and postSlot then
			ClearCursor()
			PickupContainerItem(postBag, postSlot)
			ClickAuctionSellItemButton(AuctionsItemButton, "LeftButton")
			ClearCursor()
		end

		local postTime = TSMAPI_FOUR.Util.GetDistinctTableKey(TSM.CONST.AUCTION_DURATIONS, detailsHeader2:GetElement("duration.dropdown"):GetSelection())
		local bid = TSM.Money.FromString(detailsHeader1:GetElement("bid.text"):GetText())
		local buyout = TSM.Money.FromString(detailsHeader1:GetElement("buyout.text"):GetText())
		local stackSize = tonumber(currentRow:GetField("stackSize"))

		header:GetElement("item.cost.text"):SetText(TSM.Money.ToString(GetAuctionDeposit(postTime, bid, buyout, stackSize, 1)))
			:Draw()

		ClearCursor()
		ClickAuctionSellItemButton(AuctionsItemButton, "LeftButton")
		ClearCursor()
	end
	local function UpdateScanFrame(context)
		if not context.scanFrame then
			return
		end

		local header = context.scanFrame:GetElement("header")
		local currentRow, numProcessed, numConfirmed, _, totalNum = nil, nil, nil, nil, nil
		if context.scanType == "POST" then
			currentRow = TSM.Auctioning.PostScan.GetCurrentRow()
			numProcessed, numConfirmed, _, totalNum = TSM.Auctioning.PostScan.GetStatus()
			header:GetElement("item.cost")
				:Show()
				:Draw()
		elseif context.scanType == "CANCEL" then
			currentRow = TSM.Auctioning.CancelScan.GetCurrentRow()
			numProcessed, numConfirmed, _, totalNum = TSM.Auctioning.CancelScan.GetStatus()
			header:GetElement("item.cost")
				:Hide()
				:Draw()
		else
			error("Invalid scan type: "..tostring(context.scanType))
		end
		local itemContent = header:GetElement("item.content")
		local detailsHeader1 = header:GetElement("details1")
		local detailsHeader2 = header:GetElement("details2")
		if currentRow then
			local selectedRow = nil
			for _, row in private.logQuery:Iterator() do
				if currentRow:GetField("index") == row:GetField("index") then
					selectedRow = row
				end
			end
			if selectedRow and context.scanFrame:GetElement("tabs"):GetPath() == L["Auctioning Log"] then
				context.scanFrame:GetElement("tabs.logFrame.log")
					:SetSelection(selectedRow:GetUUID())
					:Draw()
			end

			local itemString = currentRow:GetField("itemString")
			local rowStacksRemaining = currentRow:GetField("numStacks") - currentRow:GetField("numProcessed")
			itemContent:GetElement("icon")
				:SetStyle("backgroundTexture", TSMAPI_FOUR.Item.GetTexture(itemString))
				:SetTooltip(itemString)
				:Draw()
			itemContent:GetElement("text")
				:SetText(TSM.UI.GetColoredItemName(itemString))
				:SetTooltip(itemString)
				:Draw()
			detailsHeader1:GetElement("bid.text")
				:SetText(TSM.Money.ToString(currentRow:GetField("bid")))
				:Draw()
			detailsHeader1:GetElement("buyout.text")
				:SetText(TSM.Money.ToString(currentRow:GetField("buyout")))
				:Draw()
			detailsHeader2:GetElement("quantity.text")
				:SetText(format(L["%d of %d"], rowStacksRemaining, currentRow:GetField("stackSize")))
				:Draw()
			if context.scanType == "POST" then
				detailsHeader1:GetElement("bid.editBtn")
					:Show()
					:Draw()
				detailsHeader1:GetElement("buyout.editBtn")
					:Show()
					:Draw()
				detailsHeader2:GetElement("duration.dropdown")
					:SetDisabled(false)
					:SetSelection(TSM.CONST.AUCTION_DURATIONS[currentRow:GetField("postTime")])
					:Draw()

				if context.itemString ~= itemString then
					UpdateDepositCost(context)
					context.itemString = itemString
				end
			else
				detailsHeader1:GetElement("bid.editBtn"):Hide()
				detailsHeader1:GetElement("buyout.editBtn"):Hide()
				detailsHeader2:GetElement("duration.dropdown"):SetDisabled(true)
			end
		else
			itemContent:GetElement("icon")
				:SetStyle("backgroundTexture", nil)
				:SetTooltip(nil)
				:Draw()
			itemContent:GetElement("text")
				:SetText("-")
				:SetTooltip(nil)
			header:GetElement("item.cost.text")
				:SetText("-")
				:Draw()
			detailsHeader1:GetElement("bid.text")
				:SetText("-")
				:Draw()
			detailsHeader1:GetElement("bid.editBtn")
				:Hide()
				:Draw()
			detailsHeader1:GetElement("buyout.text")
				:SetText("-")
				:Draw()
			detailsHeader1:GetElement("buyout.editBtn")
				:Hide()
				:Draw()
			detailsHeader2:GetElement("quantity.text")
				:SetText("-")
				:Draw()
			detailsHeader2:GetElement("duration.dropdown")
				:SetSelection("")
				:Draw()
			detailsHeader2:GetElement("duration.dropdown")
				:SetDisabled(true)
				:Draw()
			if context.scanFrame:GetElement("tabs"):GetPath() == L["Auctioning Log"] then
				context.scanFrame:GetElement("tabs.logFrame.log")
					:SetSelection(nil)
					:Draw()
			end
		end

		local processText, processIcon = nil, nil
		if context.scanType == "POST" then
			processText = L["POST"]
			processIcon = "iconPack.18x18/Post"
		elseif context.scanType == "CANCEL" then
			processText = strupper(CANCEL)
			processIcon = "iconPack.18x18/Close/Circle"
		else
			error("Invalid scan type: "..tostring(context.scanType))
		end
		local bottom = context.scanFrame:GetElement("bottom")
		bottom:GetElement("processBtn")
			:SetStyle("iconTexturePack", processIcon)
			:SetText(processText)
		bottom:GetElement("stopBtn"):SetDisabled(context.scanProgress == 1)
		if context.scanProgress == 1 then
			-- we're done scanning so start Posting/Canceling
			local doneStr, progressFmtStr = nil, nil
			if context.scanType == "POST" then
				doneStr = L["Done Posting"]
				progressFmtStr = L["Posting %d / %d"]
			elseif context.scanType == "CANCEL" then
				doneStr = L["Done Canceling"]
				progressFmtStr = L["Canceling %d / %d"]
			else
				error("Invalid scan type: "..tostring(context.scanType))
			end
			local progressText, iconHidden = nil, false
			if numConfirmed == totalNum then
				progressText = doneStr
				iconHidden = true
			elseif numProcessed == totalNum then
				progressText = format(L["Confirming %d / %d"], numConfirmed + 1, totalNum)
			elseif numProcessed == numConfirmed then
				progressText = format(progressFmtStr, numProcessed + 1, totalNum)
				iconHidden = true
			else
				progressText = format(progressFmtStr.." ("..L["Confirming %d / %d"]..")", numProcessed + 1, totalNum, numConfirmed + 1, totalNum)
			end
			bottom:GetElement("progressBar")
				:SetProgress(totalNum > 0 and (numProcessed / totalNum) or 1)
				:SetProgressIconHidden(iconHidden)
				:SetText(progressText)
			bottom:GetElement("processBtn"):SetDisabled(numProcessed == totalNum)
			bottom:GetElement("skipBtn"):SetDisabled(numProcessed == totalNum)
		else
			-- we're scanning
			bottom:GetElement("progressBar")
				:SetProgress(context.scanProgress)
				:SetProgressIconHidden(false)
				:SetText(context.scanProgressText or "")
			bottom:GetElement("processBtn"):SetDisabled(true)
			bottom:GetElement("skipBtn"):SetDisabled(true)
		end
		bottom:Draw()
	end
	private.fsm = TSMAPI_FOUR.FSM.New("AUCTIONING")
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_INIT")
			:SetOnEnter(function(context, ...)
				private.hasLastScan = false
				TSM.Auctioning.Log.Truncate()
				TSM.Auctioning.PostScan.Reset()
				TSM.Auctioning.CancelScan.Reset()

				context.db:Truncate()
				if context.scanThreadId then
					TSMAPI_FOUR.Thread.Kill(context.scanThreadId)
					context.scanThreadId = nil
				end
				context.itemString = nil
				context.scanProgress = 0
				context.scanProgressText = L["Starting Scan..."]
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
				TSM.UI.AuctionUI.EndedScan(L["Auctioning"])
			end)
			:AddTransition("ST_INIT")
			:AddTransition("ST_STARTING_SCAN")
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_STARTING_SCAN")
			:SetOnEnter(function(context, scanType, ...)
				private.hasLastScan = true
				context.scanType = scanType
				if context.scanType == "POST" then
					context.scanThreadId = TSM.Auctioning.PostScan.Prepare()
					private.logQuery:ResetOrderBy()
					private.logQuery:OrderBy("index", true)
				elseif context.scanType == "CANCEL" then
					context.scanThreadId = TSM.Auctioning.CancelScan.Prepare()
					private.logQuery:ResetOrderBy()
					private.logQuery:OrderBy("index", false)
				else
					error("Invalid scan type: "..tostring(context.scanType))
				end
				context.auctionScan = TSMAPI_FOUR.Auction.NewAuctionScan(context.db)
					:SetResolveSellers(true)
					:SetScript("OnProgressUpdate", private.FSMAuctionScanOnProgressUpdate)
				UpdateScanFrame(context)
				TSMAPI_FOUR.Thread.SetCallback(context.scanThreadId, private.FSMScanCallback)
				TSMAPI_FOUR.Thread.Start(context.scanThreadId, context.auctionScan, context.db, ...)
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
				TSMAPI_FOUR.Sound.PlaySound(TSM.db.global.auctioningOptions.scanCompleteSound)
				return "ST_RESULTS"
			end)
			:AddEvent("EV_STOP_BUTTON_CLICKED", function(context)
				TSMAPI_FOUR.Sound.PlaySound(TSM.db.global.auctioningOptions.scanCompleteSound)
				return "ST_RESULTS"
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
				context.scanProgress = progress
				context.scanProgressText = text
				UpdateScanFrame(context)
				return "ST_SCANNING"
			end)
			:AddTransition("ST_SCANNING")
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_HANDLING_CONFIRM")
			:SetOnEnter(function(context, success, canRetry)
				if context.scanType == "POST" then
					TSM.Auctioning.PostScan.HandleConfirm(success, canRetry)
					local _, numConfirmed, numFailed, totalNum = TSM.Auctioning.PostScan.GetStatus()
					if numConfirmed == totalNum then
						if numFailed > 0 then
							-- TODO: need to wait for the player's bags to settle
							TSM:Printf(L["Retrying %d auction(s) which failed."], numFailed)
							TSM.Auctioning.PostScan.PrepareFailedPosts()
						else
							return "ST_DONE"
						end
					end
				elseif context.scanType == "CANCEL" then
					TSM.Auctioning.CancelScan.HandleConfirm(success, canRetry)
					local _, _, numConfirmed, numFailed, totalNum = TSM.Auctioning.CancelScan.GetStatus()
					if numConfirmed == totalNum then
						if numFailed > 0 then
							-- TODO: need to wait for the player's auctions to settle
							TSM:Printf(L["Retrying %d auction(s) which failed."], numFailed)
							TSM.Auctioning.CancelScan.PrepareFailedCancels()
						else
							return "ST_DONE"
						end
					end
				else
					error("Invalid scan type: "..tostring(context.scanType))
				end
				return "ST_RESULTS"
			end)
			:AddTransition("ST_RESULTS")
			:AddTransition("ST_DONE")
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_RESULTS")
			:SetOnEnter(function(context)
				TSM.UI.AuctionUI.EndedScan(L["Auctioning"])
				TSMAPI_FOUR.Thread.Kill(context.scanThreadId)
				context.scanProgress = 1
				context.scanProgressText = L["Done Scanning"]
				UpdateScanFrame(context)
			end)
			:AddTransition("ST_INIT")
			:AddTransition("ST_HANDLING_CONFIRM")
			:AddEvent("EV_PROCESS_CLICKED", function(context)
				if context.scanType == "POST" then
					local success, noRetry = TSM.Auctioning.PostScan.DoProcess()
					if not success then
						-- we failed to post
						return "ST_HANDLING_CONFIRM", false, not noRetry
					end
				elseif context.scanType == "CANCEL" then
					if not TSM.Auctioning.CancelScan.DoProcess() then
						-- we failed to cancel but can retry
						return "ST_HANDLING_CONFIRM", false, true
					end
				else
					error("Invalid scan type: "..tostring(context.scanType))
				end
				UpdateScanFrame(context)
			end)
			:AddEvent("EV_SKIP_CLICKED", function(context)
				if context.scanType == "POST" then
					TSM.Auctioning.PostScan.DoSkip()
				elseif context.scanType == "CANCEL" then
					TSM.Auctioning.CancelScan.DoSkip()
				else
					error("Invalid scan type: "..tostring(context.scanType))
				end
				UpdateScanFrame(context)
			end)
			:AddEvent("EV_AUCTION_POST_CONFIRM", function(context, success, canRetry)
				if context.scanType == "POST" then
					return "ST_HANDLING_CONFIRM", success, canRetry
				end
			end)
			:AddEvent("EV_AUCTION_CANCEL_CONFIRM", function(context, success, canRetry)
				if context.scanType == "CANCEL" then
					return "ST_HANDLING_CONFIRM", success, canRetry
				end
			end)
			:AddEvent("EV_POST_DETAIL_CHANGED", function(context, field, value)
				assert(context.scanType == "POST")
				TSM.Auctioning.PostScan.ChangePostDetail(field, value)
				UpdateScanFrame(context)
				UpdateDepositCost(context)
			end)
		)
		:AddState(TSMAPI_FOUR.FSM.NewState("ST_DONE")
			:SetOnEnter(function(context)
				GetOwnerAuctionItems()
				TSMAPI_FOUR.Sound.PlaySound(TSM.db.global.auctioningOptions.confirmCompleteSound)
				UpdateScanFrame(context)
			end)
			:AddTransition("ST_INIT")
		)
		:AddDefaultEvent("EV_START_SCAN", function(context, ...)
			return "ST_INIT", ...
		end)
		:AddDefaultEvent("EV_SCAN_FRAME_SHOWN", function(context, scanFrame)
			context.scanFrame = scanFrame
			UpdateScanFrame(context)
		end)
		:AddDefaultEvent("EV_SCAN_FRAME_HIDDEN", function(context)
			context.scanFrame = nil
			context.itemString = nil
		end)
		:AddDefaultEvent("EV_BACK_BUTTON_CLICKED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_INIT"))
		:AddDefaultEvent("EV_AUCTION_HOUSE_CLOSED", TSMAPI_FOUR.FSM.SimpleTransitionEventHandler("ST_INIT"))
		:Init("ST_INIT", fsmContext)
end

function private.FSMAuctionScanOnProgressUpdate(auctionScan)
	private.fsm:ProcessEvent("EV_SCAN_PROGRESS_UPDATE")
end

function private.FSMScanCallback()
	private.fsm:ProcessEvent("EV_SCAN_COMPLETE")
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.BagScrollingTableIsSelectionEnabled(_, record)
	return record:GetField("firstOperation") and true or false
end

function private.BagGetOperationText(firstOperation)
	return firstOperation or ("|cfff72d20"..L["Skipped: No assigned operation"].."|r")
end

function private.LogGetBuyoutText(buyout)
	return buyout == 0 and "-" or TSM.Money.ToString(buyout)
end

function private.LogGetIndexText(index)
	return ""
end

function private.MarketValueFunction(row)
	return TSMAPI_FOUR.CustomPrice.GetValue("dbmarket", row:GetField("itemString"))
end
