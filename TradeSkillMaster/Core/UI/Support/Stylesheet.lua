-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Stylesheet = TSM.UI:NewPackage("Stylesheet")
local private = { defaultStyleCache = {} }
local DEFAULT_STYLESHEET = {
	-- Element
	[TSM.UI.Element] = {
		font = TSM.UI.Fonts.MontserratRegular,
		fontHeight = 18,
		justifyH = "LEFT",
		justifyV = "MIDDLE",
		textColor = "#e2e2e2",
		backgroundVertexColor = "#ffffff",
	},
	-- Element -> Spacer
	[TSM.UI.Spacer] = {
	},
	-- Element -> Texture
	[TSM.UI.Texture] = {
	},
	-- Element -> Text
	[TSM.UI.Text] = {
	},
	-- Element -> PlayerGoldText
	[TSM.UI.PlayerGoldText] = {
		font =  TSM.UI.Fonts.RobotoMedium,
		textColor =  "#ffffff",
	},
	-- Element -> Button
	[TSM.UI.Button] = {
		justifyH = "CENTER",
		disabledTextColor = "#424242",
	},
	-- Element -> ActionButton
	[TSM.UI.ActionButton] = {
		font = TSM.UI.Fonts.MontserratMedium,
		fontHeight = 14,
		justifyH = "CENTER",
		textColor = "#ffffff",
		pressedTextColor = "#2e2e2e",
		inactiveTextColor = "#888888",
	},
	-- Element -> ActionButton -> SecureMacroActionButton
	[TSM.UI.SecureMacroActionButton] = {
	},
	-- Element -> Graph
	[TSM.UI.Graph] = {
		xAxisFont = TSM.UI.Fonts.MontserratBold,
		xAxisFontHeight = 10,
		yAxisFont = TSM.UI.Fonts.RobotoRegular,
		yAxisFontHeight = 10,
		textColor = "#ffffff",
		lineThickness = 2,
		gridLineThickness = 1,
		gridLineColor = "#26e2e2e2",
		fillColor = "#40ffd839",
		lineColor = "#ffd839",
	},
	-- Element -> Slider
	[TSM.UI.Slider] = {
		fontHeight = 16,
	},
	-- Element -> Dropdown
	[TSM.UI.Dropdown] = {
		fontHeight = 12,
		openFont = TSM.UI.Fonts.MontserratBold,
		openFontHeight = 12,
		openBackground = "#404040",
		openBorder = "#585858",
		openBorderSize = 2,
		textPadding = 8,
		textColor = "#e2e2e2",
		inactiveTextColor = "#9d9d9d",
		expanderSize = 18,
		expanderPadding = 8,
		expanderBackgroundTexturePack = "iconPack.18x18/Chevron/Expanded",
		inactiveExpanderBackgroundTexturePack = "iconPack.18x18/Chevron/Inactive",
	},
	-- Element -> BaseDropdown
	[TSM.UI.BaseDropdown] = {
		fontHeight = 12,
		openFont = TSM.UI.Fonts.MontserratBold,
		openFontHeight = 12,
		openBackground = "#404040",
		openBorder = "#585858",
		openBorderSize = 2,
		textPadding = 8,
		textColor = "#e2e2e2",
		inactiveTextColor = "#9d9d9d",
		expanderSize = 18,
		expanderPadding = 8,
		expanderBackgroundTexturePack = "iconPack.18x18/Chevron/Expanded",
		inactiveExpanderBackgroundTexturePack = "iconPack.18x18/Chevron/Inactive",
	},
	-- Element -> BaseDropdown -> SelectionDropdown
	[TSM.UI.SelectionDropdown] = {
	},
	-- Element -> BaseDropdown -> MultiselectionDropdown
	[TSM.UI.MultiselectionDropdown] = {
	},
	-- Element -> Checkbox
	[TSM.UI.Checkbox] = {
		fontHeight = 14,
		checkedTexturePack = "iconPack.Misc/Checkbox/Checked",
		uncheckedTexturePack = "iconPack.Misc/Checkbox/Unchecked",
		checkboxSpacing = 0,
	},
	-- Element -> EditableText
	[TSM.UI.EditableText] = {
	},
	-- Element -> Input
	[TSM.UI.Input] = {
		backgroundTexturePacks = "uiFrames.ActiveInputField",
		font = TSM.UI.Fonts.MontserratBold,
		fontHeight = 12,
		textColor = "#ffffff",
		background = "#5c5c5c",
		hintTextColor = "#ffffff",
		highlightColor = "#535353",
		hintJustifyH = "CENTER",
		hintJustifyV = "MIDDLE",
		textInset = 5,
	},
	-- Element -> Input -> SearchInput
	[TSM.UI.SearchInput] = {
		font = TSM.UI.Fonts.MontserratMedium,
		fontHeight = 12,
		textColor = "#2e2e2e",
		hintTextColor = "#2e2e2e",
		hintJustifyH = "CENTER",
	},
	-- Element -> Input -> InputNumeric
	[TSM.UI.InputNumeric] = {
	},
	-- Element -> ProgressBar
	[TSM.UI.ProgressBar] = {
		font = TSM.UI.Fonts.MontserratMedium,
		fontHeight = 16,
		textColor = "#ffd839",
		justifyH = "CENTER",
		background = "#2e2e2e",
		progressBackground = "#494949",
	},
	-- Element -> ToggleOnOff
	[TSM.UI.ToggleOnOff] = {
		width = TSM.UI.TexturePacks.GetWidth("uiFrames.ToggleOff"),
		height = TSM.UI.TexturePacks.GetHeight("uiFrames.ToggleOff"),
	},
	-- Element -> FastScrollingList
	[TSM.UI.FastScrollingList] = {
		rowHeight = 24,
		hoverHighlight = "#434343",
		selectedHighlight = "#30290B",
		background = "#000000",
		altBackground = "#171717",
		scrollbarMargin = 4,
		scrollbarWidth = 4,
		scrollbarThumbBackground = "#bfe2e2e2",
		scrollbarThumbWidth = 4,
		scrollbarThumbHeight = 95,
	},
	-- Element -> FastScrollingList -> CraftingQueueList
	[TSM.UI.CraftingQueueList] = {
		rowHeight = 20,
		altBackground = "#000000",
	},
	-- Element -> FastScrollingList -> ItemList
	[TSM.UI.ItemList] = {
		rowHeight = 20,
		altBackground = "#101010",
		headerFont = TSM.UI.Fonts.FRIZQT,
		headerFontHeight = 14,
		regularFont = TSM.UI.Fonts.FRIZQT,
		regularFontHeight = 12,
		expanderCollapsedBackgroundTexturePack = "iconPack.18x18/Carot/Collapsed",
		expanderExpandedBackgroundTexturePack = "iconPack.18x18/Carot/Expanded",
		checkTexturePack = "iconPack.18x18/Checkmark/Default",
	},
	-- Element -> FastScrollingList -> GroupTree
	[TSM.UI.GroupTree] = {
		rowHeight = 24,
		font = TSM.UI.Fonts.MontserratMedium,
		fontHeight = 14,
		treeIndentWidth = 14,
		expanderSize = 18,
		expanderCollapsedBackgroundTexturePack = "iconPack.18x18/Carot/Collapsed",
		expanderExpandedBackgroundTexturePack = "iconPack.18x18/Carot/Expanded",
	},
	-- Element -> FastScrollingList -> GroupTree -> ManagementGroupTree
	[TSM.UI.ManagementGroupTree] = {
		moveFramePadding = 10,
		selectedRowIconPadding = 4,
		selectedRowButtonSize = 18,
		moveBackgroundTexturePack = "iconPack.18x18/DragHandle",
		plusBackgroundTexturePack = "iconPack.18x18/Add/Circle",
		editBackgroundTexturePack = "iconPack.18x18/Edit",
		deleteBackgroundTexturePack = "iconPack.18x18/Delete",
	},
	-- Element -> FastScrollingList -> GroupTree -> ApplicationGroupTree
	[TSM.UI.ApplicationGroupTree] = {
	},
	-- Element -> FastScrollingList -> GroupTree -> SelectionGroupTree
	[TSM.UI.SelectionGroupTree] = {
	},
	-- Element -> FastScrollingList -> ImportConfirmationList
	[TSM.UI.ImportConfirmationList] = {
		rowHeight = 24,
		headerFont = TSM.UI.Fonts.FRIZQT,
		headerFontHeight = 14,
		regularFont = TSM.UI.Fonts.FRIZQT,
		regularFontHeight = 12,
		expanderCollapsedBackgroundTexturePack = "iconPack.18x18/Carot/Collapsed",
		expanderExpandedBackgroundTexturePack = "iconPack.18x18/Carot/Expanded",
	},
	-- Element -> ScrollingTable
	[TSM.UI.ScrollingTable] = {
		rowHeight = 20,
		highlight = "#996f6f6f",
		headerBackground = "#585858",
		lineColor = "#585858",
		headerFont = TSM.UI.Fonts.MontserratBold,
		headerFontHeight = 14,
		background = "#000000",
		altBackground = "#171717",
		scrollbarMargin = 4,
		scrollbarWidth = 4,
		scrollbarThumbBackground = "#bfe2e2e2",
		scrollbarThumbWidth = 4,
		scrollbarThumbHeight = 95,
		colSpacing = 16,
	},
	-- Element -> ScrollingTable -> QueryScrollingTable
	[TSM.UI.QueryScrollingTable] = {
	},
	-- Element -> ScrollingTable -> QueryScrollingTable -> SelectionScrollingTable
	[TSM.UI.SelectionScrollingTable] = {
	},
	-- Element -> ScrollingTable -> ProfessionScrollingTable
	[TSM.UI.ProfessionScrollingTable] = {
		altBackground = "#000000",
		headerBackground = "#404040",
		headerFont = TSM.UI.Fonts.MontserratMedium,
		headerFontHeight = 12,
		colSpacing = 10,
	},
	-- Element -> ScrollingTable -> AuctionScrollingTable
	[TSM.UI.AuctionScrollingTable] = {
		headerFontHeight = 12,
	},
	-- Element -> ScrollingTable -> AuctionScrollingTable -> ShoppingScrollingTable
	[TSM.UI.ShoppingScrollingTable] = {
	},
	-- Element -> ScrollingTable -> AuctionScrollingTable -> SniperScrollingTable
	[TSM.UI.SniperScrollingTable] = {
	},
	-- Element -> Container
	[TSM.UI.Container] = {
	},
	-- Element -> Container -> Toggle
	[TSM.UI.Toggle] = {
		fontHeight = 16,
		border = "#ffd839",
		borderSize = 1,
		justifyH = "CENTER",
		textColor = "#ffd839",
		selectedBackground = "#ffd839",
		selectedTextColor = "#000000",
	},
	-- Element -> Container -> ScrollFrame
	[TSM.UI.ScrollFrame] = {
		scrollbarMargin = 4,
		scrollbarWidth = 4,
		scrollbarThumbBackground = "#bfe2e2e2",
		scrollbarThumbWidth = 4,
		scrollbarThumbHeight = 95,
	},
	-- Element -> Container -> Frame
	[TSM.UI.Frame] = {
	},
	-- Element -> Container -> Frame -> BorderedFrame
	[TSM.UI.BorderedFrame] = {
		borderTheme = "roundLight"
	},
	-- Element -> Container -> Frame -> AlphaAnimatedFrame
	[TSM.UI.AlphaAnimatedFrame] = {
	},
	-- Element -> Container -> Frame -> OverlayApplicationFrame
	[TSM.UI.OverlayApplicationFrame] = {
	},
	-- Element -> Container -> Frame -> MenuDialogFrame
	[TSM.UI.MenuDialogFrame] = {
	},
	-- Element -> Container -> Frame -> ApplicationFrame
	[TSM.UI.ApplicationFrame] = {
		titleStyle = "TITLE_ONLY",
	},
	-- Element -> Container -> Frame -> ApplicationFrame -> LargeApplicationFrame
	[TSM.UI.LargeApplicationFrame] = {
		titleStyle = "FULL",
		selectedTextColor = "#ffd839",
		buttonFont = TSM.UI.Fonts.MontserratMedium,
		buttonFontHeight = 16,
	},
	-- Element -> Container -> Frame -> DividedContainer
	[TSM.UI.DividedContainer] = {
		dividerWidth = 16,
		dividerBackground = "#2e2e2e",
		dividerBorder = "#202020",
		dividerBorderSize = 2,
		dividerHandleTexturePack = "uiFrames.DividerHandle",
	},
	-- Element -> Container -> ViewContainer
	[TSM.UI.ViewContainer] = {
	},
	-- Element -> Container -> ViewContainer -> ButtonGroup
	[TSM.UI.ButtonGroup] = {
		fontHeight = 16,
		border = "#979797",
		borderSize = 1.5,
		buttonWidth = 200,
		buttonHeight = 23,
		selectedBackground = "#c2c2c2",
		selectedTextColor = "#000000",
	},
	-- Element -> Container -> ViewContainer -> SimpleTabGroup
	[TSM.UI.SimpleTabGroup] = {
		font = TSM.UI.Fonts.MontserratBold,
		fontHeight = 14,
		buttonHeight = 20,
		selectedTextColor = "#ffd839",
	},
	-- Element -> Container -> ViewContainer -> TabGroup
	[TSM.UI.TabGroup] = {
		font = TSM.UI.Fonts.MontserratBold,
		fontHeight = 14,
		buttonHeight = 20,
		selectedTextColor = "#ffd839",
	},
	-- Element -> Container -> ViewContainer -> VerticalNav
	[TSM.UI.VerticalNav] = {
		fontHeight = 16,
		buttonWidth = 200,
		buttonHeight = 23,
		selectedTextColor = "#ffd839",
		verticalSpacing = 15,
	},
	-- Element -> Container -> ScrollList
	[TSM.UI.ScrollList] = {
		rowHeight = 20,
		highlight = "#996f6f6f",
		background = "#000000",
		altBackground = "#171717",
		scrollbarThumbBackground = "#bfe2e2e2",
		scrollbarThumbWidth = 4,
		scrollbarThumbHeight = 95,
	},
	-- Element -> Container -> ScrollList -> CraftingMatList
	[TSM.UI.CraftingMatList] = {
		background = "#1c1c1c",
		altBackground = "#1c1c1c",
	},
	-- Element -> Container -> ScrollList -> SearchList
	[TSM.UI.SearchList] = {
		favoriteActiveBackgroundTexturePack = "iconPack.18x18/Star/Filled",
		favoriteInactiveBackgroundTexturePack = "iconPack.18x18/Star/Unfilled",
		editBackgroundTexturePack = "iconPack.18x18/Edit",
		deleteBackgroundTexturePack = "iconPack.18x18/Delete",
	},
	-- Element -> Container -> ScrollList -> DropdownList
	[TSM.UI.DropdownList] = {
		background = "#404040",
		altBackground = "#585858",
		border = "#585858",
		borderSize = 2,
		font = TSM.UI.Fonts.MontserratMedium,
		fontHeight = 12,
		scrollbarThumbHeight = 60,
		checkTexturePack = "iconPack.18x18/Checkmark/Default",
		highlight = "#9d9d9d",
	},
	-- Element -> Container -> ScrollList -> OperationTree
	[TSM.UI.OperationTree] = {
		fontHeight = 14,
		rowHeight = 28,
		expanderSize = 18,
		addNewBtnFont = TSM.UI.Fonts.MontserratBold,
		headerFont = TSM.UI.Fonts.MontserratBold,
		headerTextColor = "#79a2ff",
		selectedRowIconPadding = 4,
		selectedRowButtonSize = 18,
		plusBackgroundTexturePack = "iconPack.18x18/Add/Circle",
		duplicateBackgroundTexturePack = "iconPack.18x18/Duplicate",
		deleteBackgroundTexturePack = "iconPack.18x18/Delete",
		expanderCollapsedBackgroundTexturePack = "iconPack.18x18/Carot/Collapsed",
		expanderExpandedBackgroundTexturePack = "iconPack.18x18/Carot/Expanded",
	},
	-- Element -> Container -> ScrollList -> SelectionList
	[TSM.UI.SelectionList] = {
		rowHeight = 40,
		fontHeight = 18,
	},
	[TSM.UI.ExportConfirmationList] = {
		cancelButtonFont = TSM.UI.Fonts.title,
		cancelButtonFontHeight = 14,
		cancelButtonHeight = 15,
		collapsableFont = TSM.UI.Fonts.semibold,
		collapsableFontHeight = 18,
		collapsableTextColor = "#ffd839",
		groupFont = TSM.UI.Fonts.semibold,
		groupFontHeight = 18,
		moduleFont = TSM.UI.Fonts.semibold,
		moduleFontHeight = 18,
		operationFont = TSM.UI.Fonts.regular,
		operationFontHeight = 14,
		rowHeight = 28,
		textColor = "#e2e2e2",
		expanderCollapsedBackgroundTexturePack = "iconPack.18x18/Carot/Collapsed",
		expanderExpandedBackgroundTexturePack = "iconPack.18x18/Carot/Expanded",
	},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Stylesheet.OnInitialize()
	for class, defaultStyle in pairs(DEFAULT_STYLESHEET) do
		-- load the defaults for this class
		private.defaultStyleCache[class] = CopyTable(defaultStyle)
		-- load the inherited defaults
		local superclass = class.__super
		while superclass do
			for i, v in pairs(DEFAULT_STYLESHEET[superclass]) do
				private.defaultStyleCache[class][i] = private.defaultStyleCache[class][i] or v
			end
			superclass = superclass.__super
		end
	end
end

function Stylesheet.GetDefaultStyle(class, key)
	assert(private.defaultStyleCache[class], "Invalid class: "..tostring(class))
	return private.defaultStyleCache[class][key]
end
