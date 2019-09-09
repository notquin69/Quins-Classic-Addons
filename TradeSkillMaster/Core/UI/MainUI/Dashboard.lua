-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Dashboard = TSM.MainUI:NewPackage("Dashboard")
local L = TSM.L
local private = {
	xData = {},
	yData = {},
	xDataValue = {},
	xStep = nil,
	xInterval = nil,
	xNumInterval = nil,
	playerList = {},
	charGuildList = {},
	selectedGraphCharacter = L["All Characters and Guilds"],
	selectedGraphTime = L["Past Year"],
	selectedSummaryCharacter = nil,
	selectedSummaryTime = L["Past Year"]
}
local TIMELIST = { halfMonth = L["Past Year"], month = L["Past Month"], sevenDays = L["Past 7 Days"], hour = L["Past Day"] }
local TIMELISTORDER = { "halfMonth", "month", "sevenDays", "hour" }
local GOLD_GRAPH_SUFFIX = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and "g" or "k"
local DEFAULT_DIVIDED_CONTAINER_CONTEXT = {
	leftWidth = 300,
}
-- TODO: this should eventually go in the saved variables
private.dividedContainerContext = {}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Dashboard.OnInitialize()
	TSM.MainUI.RegisterTopLevelPage("Dashboard", "iconPack.24x24/Dashboard", private.GetDashboardFrame)
end


-- ============================================================================
-- Dashboard UI
-- ============================================================================

function private.GetDashboardFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "dashboard")
	private.SetGraphSettings()
	private.PopulateData()

	wipe(private.playerList)
	tinsert(private.playerList, L["All Characters and Guilds"])
	for characterGuild in TSM.Accounting.GoldTracker.CharacterGuildIterator() do
		tinsert(private.playerList, characterGuild)
	end

	wipe(private.charGuildList)
	tinsert(private.charGuildList, L["All Characters and Guilds"])
	for character in pairs(TSMAPI_FOUR.PlayerInfo.GetCharacters()) do
		tinsert(private.charGuildList, character)
	end
	for guild in pairs(TSMAPI_FOUR.PlayerInfo.GetGuilds()) do
		tinsert(private.charGuildList, guild)
	end

	local frame = TSMAPI_FOUR.UI.NewElement("DividedContainer", "dashboard")
		:SetContextTable(private.dividedContainerContext, DEFAULT_DIVIDED_CONTAINER_CONTEXT)
		:SetMinWidth(350, 250)
		:SetLeftChild(TSMAPI_FOUR.UI.NewElement("Frame", "news")
			:SetLayout("VERTICAL")
			:SetStyle("background", "#171717")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "title")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 60)
				:SetStyle("margin", { top = 37, bottom = 8 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "leftSpacer"))
				:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "logo")
					:SetStyle("width", 60)
					:SetStyle("texturePack", "uiFrames.TSMLogo")
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
					:SetStyle("margin", { left = 8 })
					:SetStyle("autoWidth", true)
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 16)
					:SetText(L["NEWS AND INFORMATION"])
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "rightSpacer"))
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ScrollFrame", "content")
				:SetStyle("margin", { top = 16, bottom = 4 })
				:SetStyle("padding", { left = 16, right = 16 })
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "bannerBg")
				:SetLayout("HORIZONTAL")
				:SetStyle("margin", { left = 8, right = 8, bottom = 8 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "left")
					:SetStyle("texturePack", "uiFrames.PromoTextureLeft")
					:SetStyle("width", TSM.UI.TexturePacks.GetWidth("uiFrames.PromoTextureLeft"))
					:SetStyle("height", TSM.UI.TexturePacks.GetHeight("uiFrames.PromoTextureLeft"))
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "middle")
					:SetStyle("texturePack", "uiFrames.PromoTextureMiddle")
					:SetStyle("height", TSM.UI.TexturePacks.GetHeight("uiFrames.PromoTextureMiddle"))
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "right")
					:SetStyle("texturePack", "uiFrames.PromoTextureRight")
					:SetStyle("width", TSM.UI.TexturePacks.GetWidth("uiFrames.PromoTextureRight"))
					:SetStyle("height", TSM.UI.TexturePacks.GetHeight("uiFrames.PromoTextureRight"))
				)
			)
			:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Frame", "banner")
				:SetLayout("VERTICAL")
				:SetStyle("anchors", { { "TOPLEFT", "bannerBg" }, { "BOTTOMRIGHT", "bannerBg" } })
				:SetStyle("padding", { left = 59, right = 59, top = 16 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "title")
					:SetStyle("font", TSM.UI.Fonts.MontserratBold)
					:SetStyle("fontHeight", 18)
					:SetStyle("justifyH", "CENTER")
					:SetStyle("textColor", "#ffd839")
					:SetText("TradeSkillMaster.com")
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "subTitle")
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 13)
					:SetStyle("justifyH", "CENTER")
					:SetText(L["Elevate your gold-making!"])
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
			)
		)
		:SetRightChild(TSMAPI_FOUR.UI.NewElement("Frame", "content")
			:SetLayout("VERTICAL")
			:SetStyle("background", "#272727")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "goldHeader")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 61)
				:SetStyle("padding", { top = 31, bottom = 8, left = 8, right = 8 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
					:SetStyle("autoWidth", true)
					:SetStyle("fontHeight", 16)
					:SetText(L["Player Gold"])
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
					:SetStyle("width", 1)
					:SetStyle("margin", { left = 8, right = 8 })
					:SetStyle("color", "#80e2e2e2")
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "playerDropdown")
					:SetStyle("width", 200)
					:SetStyle("textPadding", 5)
					:SetStyle("background", "#00000000")
					:SetStyle("border", "#00000000")
					:SetStyle("font", TSM.UI.Fonts.MontserratBold)
					:SetStyle("fontHeight", 12)
					:SetStyle("openFont", TSM.UI.Fonts.MontserratBold)
					:SetStyle("openFontHeight", 12)
					:SetItems(private.playerList, L["All Characters and Guilds"])
					:SetScript("OnSelectionChanged", private.UpdateGraphCharacter)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer")
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "timeDropdown")
					:SetStyle("width", 150)
					:SetStyle("textPadding", 5)
					:SetStyle("background", "#00000000")
					:SetStyle("border", "#00000000")
					:SetStyle("font", TSM.UI.Fonts.MontserratBold)
					:SetStyle("fontHeight", 12)
					:SetStyle("openFont", TSM.UI.Fonts.MontserratBold)
					:SetStyle("openFontHeight", 12)
					:SetDictionaryItems(TIMELIST, private.selectedGraphTime, TIMELISTORDER)
					:SetScript("OnSelectionChanged", private.UpdateGraphTime)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", 2)
				:SetStyle("color", "#9d9d9d")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Graph", "goldGraph")
				:SetStyle("background", "#404040")
				:SetAxisStepSize(private.xStep, 1)
				:SetDataIteratorFunction(private.GraphDataIterator)
				:SetLabelFunctions(private.GraphGetXLabel, private.GraphGetYLabel)
				:SetTooltipFunction(private.TooltipLabel)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "summaryHeader")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 40)
				:SetStyle("padding", { top = 8, bottom = 8, left = 8, right = 8 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
					:SetStyle("autoWidth", true)
					:SetStyle("fontHeight", 16)
					:SetText(L["Sales Summary"])
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
					:SetStyle("width", 1)
					:SetStyle("margin", { left = 8, right = 8 })
					:SetStyle("color", "#80e2e2e2")
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "playerDropdown")
					:SetStyle("width", 200)
					:SetStyle("textPadding", 5)
					:SetStyle("background", "#00000000")
					:SetStyle("border", "#00000000")
					:SetStyle("font", TSM.UI.Fonts.MontserratBold)
					:SetStyle("fontHeight", 12)
					:SetStyle("openFont", TSM.UI.Fonts.MontserratBold)
					:SetStyle("openFontHeight", 12)
					:SetHintText(L["All Characters and Guilds"])
					:SetItems(private.charGuildList, L["All Characters and Guilds"])
					:SetScript("OnSelectionChanged", private.UpdateSummaryCharacter)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer")
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "timeDropdown")
					:SetStyle("width", 150)
					:SetStyle("textPadding", 5)
					:SetStyle("background", "#00000000")
					:SetStyle("border", "#00000000")
					:SetStyle("font", TSM.UI.Fonts.MontserratBold)
					:SetStyle("fontHeight", 12)
					:SetStyle("openFont", TSM.UI.Fonts.MontserratBold)
					:SetStyle("openFontHeight", 12)
					:SetDictionaryItems(TIMELIST, private.selectedGraphTime, TIMELISTORDER)
					:SetScript("OnSelectionChanged", private.UpdateSummaryTime)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", 2)
				:SetStyle("color", "#9d9d9d")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "summary")
				:SetLayout("VERTICAL")
				:SetStyle("height", 309)
				:SetStyle("background", "#171717")
				:SetStyle("padding", 12)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "sales")
					:SetLayout("VERTICAL")
					:SetStyle("height", 87)
					:SetStyle("background", "#2e2e2e")
					:SetStyle("padding", { left = 8, right = 8, top = 6, bottom = 6 })
					:SetStyle("borderTexture", "Interface\\Addons\\TradeSkillMaster\\Media\\DashboardCellEdgeFrame.blp")
					:SetStyle("borderSize", 8)
					:SetStyle("borderInset", 1)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "header")
						:SetStyle("height", 15)
						:SetStyle("margin", { bottom = 2 })
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 12)
						:SetText(L["SALES"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "total")
						:SetLayout("HORIZONTAL")
						:SetStyle("height", 20)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
							:SetStyle("autoWidth", true)
							:SetStyle("fontHeight", 12)
							:SetText(L["Total Gold Earned:"])
						)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "totalAmount")
							:SetStyle("autoWidth", true)
							:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
							:SetStyle("fontHeight", 12)
							:SetStyle("justifyH", "RIGHT")
						)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "perDay")
						:SetLayout("HORIZONTAL")
						:SetStyle("height", 20)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
							:SetStyle("autoWidth", true)
							:SetStyle("fontHeight", 12)
							:SetText(L["Average Earned Per Day:"])
						)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "perDayAmount")
							:SetStyle("autoWidth", true)
							:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
							:SetStyle("fontHeight", 12)
							:SetStyle("justifyH", "RIGHT")
						)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "top")
						:SetLayout("HORIZONTAL")
						:SetStyle("height", 20)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
							:SetStyle("autoWidth", true)
							:SetStyle("fontHeight", 12)
							:SetText(L["Top Item:"])
						)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "topItem")
							:SetStyle("autoWidth", true)
							:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
							:SetStyle("fontHeight", 12)
							:SetStyle("justifyH", "RIGHT")
						)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "expenses")
					:SetLayout("VERTICAL")
					:SetStyle("height", 87)
					:SetStyle("margin", { top = 12, bottom = 12 })
					:SetStyle("background", "#2e2e2e")
					:SetStyle("padding", { left = 8, right = 8, top = 6, bottom = 6 })
					:SetStyle("borderTexture", "Interface\\Addons\\TradeSkillMaster\\Media\\DashboardCellEdgeFrame.blp")
					:SetStyle("borderSize", 8)
					:SetStyle("borderInset", 1)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "header")
						:SetStyle("height", 15)
						:SetStyle("margin", { bottom = 2 })
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 12)
						:SetText(L["EXPENSES"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "total")
						:SetLayout("HORIZONTAL")
						:SetStyle("height", 20)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
							:SetStyle("autoWidth", true)
							:SetStyle("fontHeight", 12)
							:SetText(L["Total Gold Spent:"])
						)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "totalSpent")
							:SetStyle("autoWidth", true)
							:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
							:SetStyle("fontHeight", 12)
							:SetStyle("justifyH", "RIGHT")
						)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "perDay")
						:SetLayout("HORIZONTAL")
						:SetStyle("height", 20)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
							:SetStyle("autoWidth", true)
							:SetStyle("fontHeight", 12)
							:SetText(L["Average Spent Per Day:"])
						)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "perDayExpense")
							:SetStyle("autoWidth", true)
							:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
							:SetStyle("fontHeight", 12)
							:SetStyle("justifyH", "RIGHT")
						)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "top")
						:SetLayout("HORIZONTAL")
						:SetStyle("height", 20)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
							:SetStyle("autoWidth", true)
							:SetStyle("fontHeight", 12)
							:SetText(L["Top Item:"])
						)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "topItem")
							:SetStyle("autoWidth", true)
							:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
							:SetStyle("fontHeight", 12)
							:SetStyle("justifyH", "RIGHT")
						)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "balance")
					:SetLayout("VERTICAL")
					:SetStyle("height", 87)
					:SetStyle("background", "#2e2e2e")
					:SetStyle("padding", { left = 8, right = 8, top = 6, bottom = 6 })
					:SetStyle("borderTexture", "Interface\\Addons\\TradeSkillMaster\\Media\\DashboardCellEdgeFrame.blp")
					:SetStyle("borderSize", 8)
					:SetStyle("borderInset", 1)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "header")
						:SetStyle("height", 15)
						:SetStyle("margin", { bottom = 2 })
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 12)
						:SetText(L["PROFIT"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "total")
						:SetLayout("HORIZONTAL")
						:SetStyle("height", 20)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
							:SetStyle("autoWidth", true)
							:SetStyle("fontHeight", 12)
							:SetText(L["Total Profit:"])
						)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "totalProfit")
							:SetStyle("autoWidth", true)
							:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
							:SetStyle("fontHeight", 12)
							:SetStyle("justifyH", "RIGHT")
						)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "perDay")
						:SetLayout("HORIZONTAL")
						:SetStyle("height", 20)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
							:SetStyle("autoWidth", true)
							:SetStyle("fontHeight", 12)
							:SetText(L["Average Profit Per Day:"])
						)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "perDayProfit")
							:SetStyle("autoWidth", true)
							:SetStyle("font", TSM.UI.Fonts.RobotoMedium)
							:SetStyle("fontHeight", 12)
							:SetStyle("justifyH", "RIGHT")
						)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "top")
						:SetLayout("HORIZONTAL")
						:SetStyle("height", 20)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
							:SetStyle("autoWidth", true)
							:SetStyle("fontHeight", 12)
							:SetText(L["Most Profitable Item:"])
						)
						:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
						:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "topItem")
							:SetStyle("autoWidth", true)
							:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
							:SetStyle("fontHeight", 12)
							:SetStyle("justifyH", "RIGHT")
						)
					)
				)
			)
		)

	private.PopulateSalesSummary(frame)
	local newsContent = frame:GetElement("news.content")
	local newsEntries = TSM:GetAppNews()
	if newsEntries then
		for i, info in ipairs(TSM:GetAppNews()) do
			newsContent:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "news"..i)
				:SetLayout("VERTICAL")
				:SetStyle("padding", { top = i == 1 and 0 or 24 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "title")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 22)
					:SetStyle("padding", { bottom = 8 })
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 16)
						:SetStyle("textColor", "#ffffff")
						:SetText(info.title)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "date")
						:SetStyle("width", 65)
						:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
						:SetStyle("fontHeight", 10)
						:SetStyle("justifyH", "RIGHT")
						:SetStyle("textColor", "#ffffff")
						:SetText(date("%b %d, %Y", info.timestamp))
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "content")
					:SetStyle("height", 48)
					:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
					:SetStyle("fontHeight", 12)
					:SetStyle("fontSpacing", 4)
					:SetStyle("textColor", "#ffffff")
					:SetText(info.content)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "readMore")
					:SetStyle("height", 16)
					:SetStyle("font", TSM.UI.Fonts.MontserratBold)
					:SetStyle("fontHeight", 12)
					:SetStyle("justifyH", "LEFT")
					:SetStyle("textColor", "#ffd839")
					:SetContext(info)
					:SetText(L["Read More"])
				)
			)
			:AddChildNoLayout(TSMAPI_FOUR.UI.NewElement("Button", "btn")
				:SetStyle("anchors", { { "TOPLEFT", "news"..i }, { "BOTTOMRIGHT", "news"..i } })
				:SetContext(info)
				:SetScript("OnClick", private.ButtonOnClick)
			)
			if time() - info.timestamp < 48 * 60 * 60 then
				newsContent:GetElement("news"..i..".title"):AddChildBeforeById("text", TSMAPI_FOUR.UI.NewElement("Texture", "icon")
					:SetStyle("width", 18)
					:SetStyle("height", 18)
					:SetStyle("margin", { right = 4 })
					:SetStyle("texturePack", "iconPack.18x18/New")
					:SetStyle("vertexColor", "#ffd839")
				)
			end
		end
	end

	return frame
end


-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.ButtonOnClick(button)
	local info = button:GetContext()
	button:GetBaseElement():ShowDialogFrame(TSMAPI_FOUR.UI.NewElement("Frame", "frame")
		:SetLayout("VERTICAL")
		:SetStyle("width", 600)
		:SetStyle("height", 188)
		:SetStyle("anchors", { { "CENTER" } })
		:SetStyle("background", "#2e2e2e")
		:SetStyle("border", "#e2e2e2")
		:SetStyle("borderSize", 2)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "title")
			:SetStyle("height", 44)
			:SetStyle("margin", { top = 24, left = 16, right = 16, bottom = 16 })
			:SetStyle("font", TSM.UI.Fonts.MontserratBold)
			:SetStyle("fontHeight", 18)
			:SetStyle("justifyH", "CENTER")
			:SetText(info.title)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "linkInput")
			:SetStyle("height", 26)
			:SetStyle("margin", { left = 16, right = 16, bottom = 25 })
			:SetStyle("background", "#5c5c5c")
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 12)
			:SetStyle("justifyH", "LEFT")
			:SetStyle("textColor", "#ffffff")
			:SetText(info.link)
			:SetScript("OnEditFocusGained", private.LinkInputOnEditFocusGained)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "buttons")
			:SetLayout("HORIZONTAL")
			:SetStyle("margin", { left = 16, right = 16, bottom = 16 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "spacer")
				-- spacer
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "confirmBtn")
				:SetStyle("width", 126)
				:SetStyle("height", 26)
				:SetText(CLOSE)
				:SetScript("OnClick", private.DialogCloseBtnOnClick)
			)
		)
	)
end

function private.LinkInputOnEditFocusGained(input)
	input:HighlightText()
end

function private.DialogCloseBtnOnClick(button)
	button:GetBaseElement():HideDialog()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

local function GraphDataIteratorInternal(_, index)
	index = index + 1
	if index > #private.xData then
		return
	end
	return index, private.xData[index], private.yData[index]
end
function private.GraphDataIterator()
	return GraphDataIteratorInternal, nil, 0
end

function private.GraphGetXLabel(_, xValue)
	if private.xInterval == "halfMonth" then
		return strupper(date("%b\n%Y", private.xDataValue[xValue]))
	elseif private.xInterval == "hour" then
		local dateFormat = "%a\n"..gsub(date("%I", private.xDataValue[xValue]), "^0?", "").."%p"
		return strupper(date(dateFormat, private.xDataValue[xValue]))
	elseif private.xInterval == "month" then
		return strupper(date("%b\n%d", private.xDataValue[xValue]))
	elseif private.xInterval == "sevenDays" then
		return strupper(date("%b\n%d", private.xDataValue[xValue]))
	end
end

function private.TooltipLabel(xValue, yValue)
	local dateFormat
	if private.xInterval == "halfMonth" then
		dateFormat = "%b %Y"
	elseif private.xInterval == "hour" then
		dateFormat = "%a  "..gsub(date("%I", private.xDataValue[xValue]), "^0?", "").."%p"
	elseif private.xInterval == "month" then
		dateFormat = "%b %d"
	elseif private.xInterval == "sevenDays" then
		dateFormat = "%b %d "..gsub(date("%I", private.xDataValue[xValue]), "^0?", "").."%p"
	end

	return strupper(date(dateFormat, private.xDataValue[xValue])).."\n"..TSM.Money.ToString(yValue * (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and 1 or 1000) * COPPER_PER_GOLD, nil, "OPT_TRIM")
end

function private.GraphGetYLabel(_, yValue)
	return yValue..GOLD_GRAPH_SUFFIX
end

function private.PopulateData()
	wipe(private.xData)
	wipe(private.yData)
	wipe(private.xDataValue)
	TSM.Accounting.GoldTracker.PopulateGraphData(private.xData, private.xDataValue, private.yData, private.xInterval, private.xNumInterval, private.selectedGraphCharacter)
end

function private.UpdateGraphCharacter(self, selectedItem)
	private.selectedGraphCharacter = selectedItem
	private.PopulateData()
	self:GetElement("__parent.__parent.goldGraph"):Draw()
end

function private.UpdateGraphTime(self, selectedItem)
	private.selectedGraphTime = selectedItem
	private.SetGraphSettings()
	private.PopulateData()
	self:GetElement("__parent.__parent.goldGraph"):Draw()
end

function private.SetGraphSettings()
	if private.selectedGraphTime == L["Past Year"] then
		private.xInterval = "halfMonth"
		private.xStep = 2
		private.xNumInterval = 24
	elseif private.selectedGraphTime == L["Past Month"] then
		private.xInterval = "month"
		private.xStep = 1
		private.xNumInterval = 30
	elseif private.selectedGraphTime == L["Past 7 Days"] then
		private.xInterval = "sevenDays"
		private.xStep = 4
		private.xNumInterval = 24
	elseif private.selectedGraphTime == L["Past Day"] then
		private.xInterval = "hour"
		private.xStep = 1
		private.xNumInterval = 24
	end
end

function private.UpdateSummaryCharacter(self, selectedItem)
	private.selectedSummaryCharacter = selectedItem ~= L["All Characters and Guilds"] and selectedItem or nil
	private.PopulateSalesSummary(self:GetElement("__parent.__parent.__parent"), true)
end

function private.UpdateSummaryTime(self, selectedItem)
	private.selectedSummaryTime = selectedItem
	private.PopulateSalesSummary(self:GetElement("__parent.__parent.__parent"), true)
end

function private.PopulateSalesSummary(frame, redraw)
	local salesTotal, salesPerDay, salesTopItem = TSM.Accounting.GetSummarySalesInfo(private.selectedSummaryTime, private.selectedSummaryCharacter)
	local expensesTotal, expensesPerDay, expensesTopItem = TSM.Accounting.GetSummaryExpensesInfo(private.selectedSummaryTime, private.selectedSummaryCharacter)
	local profitTotal = salesTotal - expensesTotal
	local profitPerDay = salesPerDay - expensesPerDay
	local profitTopItem = TSM.Accounting.GetSummaryProfitTopItem(private.selectedSummaryTime, private.selectedSummaryCharacter)
	local profitPerDayText = TSM.Money.ToString(profitPerDay, profitPerDay < 0 and "|cffff0000" or nil)
	local profitTotalText = TSM.Money.ToString(profitTotal, profitTotal < 0 and "|cffff0000" or nil)

	local salesFrame = frame:GetElement("content.summary.sales")
	salesFrame:GetElement("total.totalAmount"):SetText(TSM.Money.ToString(salesTotal))
	salesFrame:GetElement("perDay.perDayAmount"):SetText(TSM.Money.ToString(salesPerDay))
	salesFrame:GetElement("top.topItem"):SetText(TSM.UI.GetColoredItemName(salesTopItem)):SetTooltip(salesTopItem)

	local expensesFrame = frame:GetElement("content.summary.expenses")
	expensesFrame:GetElement("total.totalSpent"):SetText(TSM.Money.ToString(expensesTotal))
	expensesFrame:GetElement("perDay.perDayExpense"):SetText(TSM.Money.ToString(expensesPerDay))
	expensesFrame:GetElement("top.topItem"):SetText(TSM.UI.GetColoredItemName(expensesTopItem)):SetTooltip(expensesTopItem)

	local profitFrame = frame:GetElement("content.summary.balance")
	profitFrame:GetElement("total.totalProfit"):SetText(profitTotalText)
	profitFrame:GetElement("perDay.perDayProfit"):SetText(profitPerDayText)
	profitFrame:GetElement("top.topItem"):SetText(TSM.UI.GetColoredItemName(profitTopItem)):SetTooltip(profitTopItem)

	if redraw then
		frame:Draw()
	end
end
