-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Gathering = TSM.UI.CraftingUI:NewPackage("Gathering")
local L = TSM.L
local private = {
	frame = nil,
	query = nil,
}
-- TODO: move to TSM.db
private.dividedContainerContext = {}
local DEFAULT_DIVIDED_CONTAINER_CONTEXT = {
	leftWidth = 272
}
local SOURCE_LIST = {
	"vendor",
	"guildBank",
	"alt",
	"altGuildBank",
	"craftProfit",
	"craftNoProfit",
	"auction",
	"auctionDE",
	"auctionCrafting"
}
local SOURCE_TEXT_LIST = {
	L["Vendor"],
	L["Guild Bank"],
	L["Alts"],
	L["Alt Guild Bank"],
	L["Craft (When Profitable)"],
	L["Craft (Unprofitable)"],
	L["AH"],
	L["AH (Disenchanting)"],
	L["AH (Crafting)"],
}
if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
	TSMAPI_FOUR.Util.TableRemoveByValue(SOURCE_LIST, "guildBank")
	TSMAPI_FOUR.Util.TableRemoveByValue(SOURCE_LIST, "altGuildBank")
	TSMAPI_FOUR.Util.TableRemoveByValue(SOURCE_TEXT_LIST, L["Guild Bank"])
	TSMAPI_FOUR.Util.TableRemoveByValue(SOURCE_TEXT_LIST, L["Alt Guild Bank"])
end
assert(#SOURCE_LIST == #SOURCE_TEXT_LIST)
local BASE_STYLESHEET = TSM.UI.Util.Stylesheet()
	:SetStyleTable("Text", "TITLE", {
		height = 22,
		font = TSM.UI.Fonts.MontserratRegular,
		fontHeight = 16,
		textColor = "#e2e2e2",
	})
	:SetStyleTable("Text", "CATEGORY", {
		height = 14,
		font = TSM.UI.Fonts.MontserratMedium,
		fontHeight = 10,
		textColor = "#ffd839",
	})
	:SetStyleTable("Text", "DESC", {
		font = TSM.UI.Fonts.MontserratRegular,
		fontHeight = 10,
		fontSpacing = 2,
		textColor = "#e2e2e2",
	})
	:SetStyleTable("Text", "SOURCE_LABEL", {
		width = 65,
		font = TSM.UI.Fonts.MontserratMedium,
		fontHeight = 10,
		textColor = "#ffffff",
	})
	:SetStyleTable("Text", "MATS_HEADER", {
		font = TSM.UI.Fonts.MontserratMedium,
		fontHeight = 12,
		textColor = "#e2e2e2",
	})
	:SetStyleTable("Texture", "HORIZONTAL_LINE_HEADER", {
		height = 2,
		color = "#585858",
	})
	:SetStyleTable("Texture", "HORIZONTAL_LINE", {
		height = 2,
		color = "#9d9d9d",
	})



-- ============================================================================
-- Module Functions
-- ============================================================================

function Gathering.OnInitialize()
	TSM.UI.CraftingUI.RegisterTopLevelPage("Gathering", "iconPack.24x24/Boxes", private.GetGatheringFrame)
	TSM.Crafting.Gathering.SetContextChangedCallback(private.ContextChangedCallback)
	TSM.UI.TaskListUI.RegisterUpdateCallback(private.UpdateButtonState)
end



-- ============================================================================
-- Gathering UI
-- ============================================================================

function private.GetGatheringFrame()
	TSM.UI.AnalyticsRecordPathChange("crafting", "gathering")
	assert(not private.query)
	private.query = TSM.Crafting.Gathering.CreateQuery()
		:SetUpdateCallback(private.UpdateButtonState)
	local frame = TSMAPI_FOUR.UI.NewElement("DividedContainer", "gathering")
		:SetStylesheet(BASE_STYLESHEET)
		:SetMinWidth(270, 200)
		:SetContextTable(private.dividedContainerContext, DEFAULT_DIVIDED_CONTAINER_CONTEXT)
		:SetLeftChild(TSMAPI_FOUR.UI.NewElement("ScrollFrame", "setup")
			:SetStyle("background", "#171717")
			:SetStyle("padding.top", 6)
			:SetStyle("padding.left", 8)
			:SetStyle("padding.right", 8)
			:SetStyle("padding.bottom", 6)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "title", "TITLE")
				:SetText(L["Setup"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "crafterDropdownLabel", "CATEGORY")
				:SetStyle("margin.top", 8)
				:SetStyle("margin.bottom", 4)
				:SetText(L["CRAFTER"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "crafterDropdown")
				:SetStyle("height", 26)
				:SetHintText(L["Select crafter"])
				:SetScript("OnSelectionChanged", private.CrafterDropdownOnSelectionChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "professionDropdownLabel", "CATEGORY")
				:SetStyle("margin.top", 8)
				:SetStyle("margin.bottom", 4)
				:SetText(L["PROFESSION"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("MultiselectionDropdown", "professionDropdown")
				:SetStyle("height", 26)
				:SetHintText(L["Select professions"])
				:SetScript("OnSelectionChanged", private.ProfessionDropdownOnSelectionChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "sourcesCategoryText", "CATEGORY")
				:SetStyle("margin.top", 12)
				:SetText(L["SOURCES"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "sourcesDesc", "DESC")
				:SetStyle("height", 28)
				:SetStyle("margin.bottom", -2)
				:SetText(L["Define what priority Gathering gives certain sources."])
			)
			:AddChildrenWithFunction(private.CreateSourceRows)
		)
		:SetRightChild(TSMAPI_FOUR.UI.NewElement("Frame", "mats")
			:SetLayout("VERTICAL")
			:SetStyle("background", "#272727")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "title", "TITLE")
				:SetStyle("margin.top", 24)
				:SetStyle("margin.bottm", 8)
				:SetStyle("justifyH", "CENTER")
				:SetText(L["Materials to Gather"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "headerTopLine", "HORIZONTAL_LINE_HEADER"))
			:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "table")
				:SetStyle("background", "#171717")
				:SetStyle("headerBackground", "#404040")
				:SetStyle("headerFontHeight", 12)
				:GetScrollingTableInfo()
					:NewColumn("name")
						:SetTitles(NAME)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetIconSize(12)
						:SetTextInfo("itemString", TSM.UI.GetColoredItemName)
						:SetIconInfo("itemString", TSMAPI_FOUR.Item.GetTexture)
						:SetTooltipInfo("itemString")
						:SetSortInfo("name")
						:Commit()
					:NewColumn("sources")
						:SetTitles(L["Sources"])
						:SetWidth(160)
						:SetFont(TSM.UI.Fonts.MontserratRegular)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo("sourcesStr", private.MatsGetSourcesStrText)
						:SetSortInfo("sourcesStr")
						:Commit()
					:NewColumn("have")
						:SetTitles(L["Have"])
						:SetWidth(50)
						:SetFont(TSM.UI.Fonts.RobotoMedium)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("numHave")
						:SetSortInfo("numHave")
						:Commit()
					:NewColumn("need")
						:SetTitles(NEED)
						:SetWidth(50)
						:SetFont(TSM.UI.Fonts.RobotoMedium)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("numNeed")
						:SetSortInfo("numNeed")
						:Commit()
					:Commit()
				:SetQuery(TSM.Crafting.Gathering.CreateQuery()
					:InnerJoin(TSM.ItemInfo.GetDBForJoin(), "itemString")
					:OrderBy("name", true)
				)
				:SetAutoReleaseQuery(true)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "headerTopLine", "HORIZONTAL_LINE_HEADER"))
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "openTaskListBtn")
				:SetStyle("height", 26)
				:SetStyle("margin", 8)
				:SetStyle("width", 350)
				:SetScript("OnClick", TSM.UI.TaskListUI.Toggle)
			)
		)
		:SetScript("OnUpdate", private.FrameOnUpdate)
		:SetScript("OnHide", private.FrameOnHide)
	private.frame = frame
	private.UpdateButtonState()
	return frame
end

function private.MatsGetSourcesStrText(str)
	str = gsub(str, "/[^,]+", "")
	for i = 1, #SOURCE_LIST do
		str = gsub(str, SOURCE_LIST[i], SOURCE_TEXT_LIST[i])
	end
	return str
end

function private.CreateSourceRows(frame)
	for i = 1, #SOURCE_LIST do
		frame:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "sourceFrame"..i)
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin.top", 8)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label", "SOURCE_LABEL")
				:SetFormattedText(L["SOURCE %d"], i)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "dropdown")
				:SetContext(i)
				:SetHintText(L["Select a Source"])
				:SetScript("OnSelectionChanged", private.SourceDropdownOnSelectionChanged)
			)
		)
	end
	private.UpdateSourceRows(frame)
end

function private.UpdateSourceRows(setupFrame)
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		TSMAPI_FOUR.Util.TableRemoveByValue(TSM.db.profile.gatheringOptions.sources, "guildBank")
		TSMAPI_FOUR.Util.TableRemoveByValue(TSM.db.profile.gatheringOptions.sources, "altGuildBank")
	end
	local texts = TSMAPI_FOUR.Util.AcquireTempTable()
	local sources = TSMAPI_FOUR.Util.AcquireTempTable()
	for i = 1, #SOURCE_LIST do
		wipe(texts)
		wipe(sources)
		for j = 1, #SOURCE_LIST do
			local index = TSMAPI_FOUR.Util.TableKeyByValue(TSM.db.profile.gatheringOptions.sources, SOURCE_LIST[j])
			if not index or index >= i then
				tinsert(texts, SOURCE_TEXT_LIST[j])
				tinsert(sources, SOURCE_LIST[j])
			end
		end
		if i <= #TSM.db.profile.gatheringOptions.sources then
			tinsert(texts, "<"..strupper(REMOVE)..">")
			tinsert(sources, "")
		end
		setupFrame:GetElement("sourceFrame"..i..".dropdown")
			:SetItems(texts, sources)
			:SetDisabled(i > #TSM.db.profile.gatheringOptions.sources + 1)
			:SetHintText(L["Select a Source"])
			:SetSelectedItemByKey(TSM.db.profile.gatheringOptions.sources[i], true)
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(texts)
	TSMAPI_FOUR.Util.ReleaseTempTable(sources)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FrameOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)
	private.ContextChangedCallback()
end

function private.FrameOnHide(frame)
	assert(frame == private.frame)
	private.frame = nil
	private.query:Release()
	private.query = nil
end

function private.CrafterDropdownOnSelectionChanged(dropdown)
	TSM.Crafting.Gathering.SetCrafter(dropdown:GetSelectedItem())
	dropdown:GetElement("__parent.professionDropdown")
		:SetItems(TSM.Crafting.Gathering.GetProfessionList())
		:SetSelectedItems(TSM.Crafting.Gathering.GetProfessions())
		:Draw()
end

function private.ProfessionDropdownOnSelectionChanged(dropdown)
	local professions = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, profession in ipairs(TSM.Crafting.Gathering.GetProfessionList()) do
		if dropdown:ItemIsSelected(profession) then
			tinsert(professions, profession)
		end
	end
	TSM.Crafting.Gathering.SetProfessions(professions)
	TSMAPI_FOUR.Util.ReleaseTempTable(professions)
end

function private.SourceDropdownOnSelectionChanged(dropdown)
	local index = dropdown:GetContext()
	local source = dropdown:GetSelectedItemKey()
	if source == "" then
		tremove(TSM.db.profile.gatheringOptions.sources, index)
	else
		TSM.db.profile.gatheringOptions.sources[index] = source
		for i = #TSM.db.profile.gatheringOptions.sources, index + 1, -1 do
			if TSM.db.profile.gatheringOptions.sources[i] == source then
				tremove(TSM.db.profile.gatheringOptions.sources, i)
			end
		end
	end
	local setupFrame = dropdown:GetParentElement():GetParentElement()
	private.UpdateSourceRows(setupFrame)
	setupFrame:Draw()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ContextChangedCallback()
	if not private.frame then
		return
	end

	private.frame:GetElement("setup.crafterDropdown")
		:SetItems(TSM.Crafting.Gathering.GetCrafterList())
		:SetSelectedItem(TSM.Crafting.Gathering.GetCrafter())
		:Draw()
	private.frame:GetElement("setup.professionDropdown")
		:SetItems(TSM.Crafting.Gathering.GetProfessionList())
		:SetSelectedItems(TSM.Crafting.Gathering.GetProfessions())
		:Draw()
end

function private.UpdateButtonState()
	if not private.frame then
		return
	end
	local button = private.frame:GetElement("mats.openTaskListBtn")
	if private.query:Count() == 0 then
		button:SetText(L["No Materials to Gather"])
		button:SetDisabled(true)
	elseif TSM.UI.TaskListUI.IsVisible() then
		button:SetText(L["Tasks Added to Task List"])
		button:SetDisabled(true)
	else
		button:SetText(L["Open Task List"])
		button:SetDisabled(false)
	end
	button:Draw()
end

function private.QueryPlayerFilter(row, player)
	return TSMAPI_FOUR.Util.SeparatedStrContains(row:GetField("players"), ",", player)
end
