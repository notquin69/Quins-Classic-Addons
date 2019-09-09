-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local CraftingReports = TSM.UI.CraftingUI:NewPackage("CraftingReports")
local L = TSM.L
local private = { craftsQuery = nil, matsQuery = nil, filterText = "", craftProfessions = {}, matProfessions = {}, MatPriceSources = {ALL, L["Default Price"], L["Custom Price"]} }



-- ============================================================================
-- Module Functions
-- ============================================================================

function CraftingReports.OnInitialize()
	TSM.UI.CraftingUI.RegisterTopLevelPage("Crafting Reports", "iconPack.24x24/Inventory", private.GetCraftingReportsFrame)
end



-- ============================================================================
-- CraftingReports UI
-- ============================================================================

function private.GetCraftingReportsFrame()
	TSM.UI.AnalyticsRecordPathChange("crafting", "crafting_reports")
	if not private.craftsQuery then
		private.craftsQuery = TSM.Crafting.CreateCraftsQuery()
		private.craftsQuery:VirtualField("firstOperation", "string", private.FirstOperationVirtualField, "itemString")
	end
	private.craftsQuery:ResetFilters()
	private.craftsQuery:ResetOrderBy()
	private.craftsQuery:OrderBy("itemName", true)
	private.matsQuery = private.matsQuery or TSM.Crafting.CreateMatItemQuery()
	private.matsQuery:ResetFilters()
	private.matsQuery:ResetOrderBy()
	private.matsQuery:OrderBy("name", true)
	return TSMAPI_FOUR.UI.NewElement("Frame", "craftingReportsContent")
		:SetLayout("VERTICAL")
		:SetStyle("padding", { top = 37 })
		:SetStyle("background", "#272727")
		:AddChild(TSMAPI_FOUR.UI.NewElement("TabGroup", "buttons")
			:SetNavCallback(private.GetTabElements)
			:AddPath(L["Crafts"], true)
			:AddPath(L["Materials"])
		)
end

function private.GetTabElements(self, path)
	if path == L["Crafts"] then
		TSM.UI.AnalyticsRecordPathChange("crafting", "crafting_reports", "crafts")
		private.filterText = ""
		wipe(private.craftProfessions)
		tinsert(private.craftProfessions, L["All Professions"])
		for _, player, profession in TSM.Crafting.PlayerProfessions.Iterator() do
			tinsert(private.craftProfessions, format("%s - %s", profession, player))
		end

		return TSMAPI_FOUR.UI.NewElement("Frame", "crafts")
			:SetLayout("VERTICAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "filters")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 44)
				:SetStyle("margin", { top = 8, bottom = 16, left = 12, right = 12 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "search")
					:SetLayout("VERTICAL")
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
						:SetStyle("height", 14)
						:SetStyle("margin", { bottom = 4 })
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 10)
						:SetText(strupper(SEARCH))
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
						:SetStyle("height", 26)
						:SetHintText(L["Filter by Keyword"])
						:SetScript("OnTextChanged", private.CraftsInputOnTextChanged)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "profession")
					:SetLayout("VERTICAL")
					:SetStyle("margin", { left = 16, right = 16 })
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
						:SetStyle("height", 14)
						:SetStyle("margin", { bottom = 4 })
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 10)
						:SetText(L["PROFESSION"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "dropdown")
						:SetStyle("height", 26)
						:SetItems(private.craftProfessions, private.craftProfessions[1])
						:SetScript("OnSelectionChanged", private.CraftsDropdownOnSelectionChanged)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "craftable")
					:SetLayout("HORIZONTAL")
					:SetStyle("width", 200)
					:SetStyle("margin", { top = 18 })
					:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "checkbox")
						:SetStyle("width", 24)
						:SetStyle("height", 24)
						:SetScript("OnValueChanged", private.CheckboxOnValueChanged)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
						:SetStyle("height", 20)
						:SetStyle("fontHeight", 14)
						:SetText(L["Only show craftable"])
					)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", 2)
				:SetStyle("color", "#9d9d9d")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "crafts")
				:SetStyle("headerFont", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("headerFontHeight", 12)
				:GetScrollingTableInfo()
					:NewColumn("queued")
						:SetTitleIcon("iconPack.18x18/Queue")
						:SetWidth(16)
						:SetFont(TSM.UI.Fonts.RobotoMedium)
						:SetFontHeight(12)
						:SetJustifyH("CENTER")
						:SetTextInfo("num")
						:SetSortInfo("num")
						:Commit()
					:NewColumn("craftName")
						:SetTitles(L["Craft Name"])
						:SetIconSize(12)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo(nil, private.CraftsGetCraftNameText)
						:SetIconInfo("itemString", TSMAPI_FOUR.Item.GetTexture)
						:SetTooltipInfo("itemString")
						:SetSortInfo("itemName")
						:Commit()
					:NewColumn("operation")
						:SetTitles(L["Operation"])
						:SetWidth(80)
						:SetFont(TSM.UI.Fonts.MontserratRegular)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo("firstOperation")
						:SetSortInfo("firstOperation")
						:Commit()
					:NewColumn("bags")
						:SetTitles(L["Bag"])
						:SetWidth(26)
						:SetFont(TSM.UI.Fonts.RobotoMedium)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("bagQuantity", private.CraftsGetBagsText)
						:SetSortInfo("bagQuantity")
						:Commit()
					:NewColumn("ah")
						:SetTitles(L["AH"])
						:SetWidth(24)
						:SetFont(TSM.UI.Fonts.RobotoMedium)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("auctionQuantity", private.CraftsGetAHText)
						:SetSortInfo("auctionQuantity")
						:Commit()
					:NewColumn("craftingCost")
						:SetTitles(L["Crafting Cost"])
						:SetWidth(100)
						:SetFont(TSM.UI.Fonts.RobotoMedium)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("craftingCost", private.CraftsGetCostItemValueText)
						:SetSortInfo("craftingCost")
						:Commit()
					:NewColumn("itemValue")
						:SetTitles(L["Item Value"])
						:SetWidth(100)
						:SetFont(TSM.UI.Fonts.RobotoMedium)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("itemValue", private.CraftsGetCostItemValueText)
						:SetSortInfo("itemValue")
						:Commit()
					:NewColumn("profit")
						:SetTitles(L["Profit"])
						:SetWidth(100)
						:SetFont(TSM.UI.Fonts.RobotoMedium)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("profit", private.CraftsGetProfitText)
						:SetSortInfo("profit")
						:Commit()
					:NewColumn("saleRate")
						:SetTitleIcon("iconPack.18x18/SaleRate")
						:SetWidth(32)
						:SetFont(TSM.UI.Fonts.RobotoMedium)
						:SetFontHeight(12)
						:SetJustifyH("CENTER")
						:SetTextInfo("saleRate", private.CraftsGetSaleRateText)
						:SetSortInfo("saleRate")
						:Commit()
					:Commit()
				:SetQuery(private.craftsQuery)
				:SetSelectionDisabled(true)
				:SetScript("OnRowClick", private.CraftsOnRowClick)
			)
	elseif path == L["Materials"] then
		TSM.UI.AnalyticsRecordPathChange("crafting", "crafting_reports", "materials")
		wipe(private.matProfessions)
		tinsert(private.matProfessions, L["All Professions"])
		for _, _, profession in TSM.Crafting.PlayerProfessions.Iterator() do
			if not private.matProfessions[profession] then
				tinsert(private.matProfessions, profession)
				private.matProfessions[profession] = true
			end
		end

		return TSMAPI_FOUR.UI.NewElement("Frame", "materials")
			:SetLayout("VERTICAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "filters")
				:SetLayout("HORIZONTAL")
				:SetStyle("height", 44)
				:SetStyle("margin", { top = 8, bottom = 16, left = 12, right = 12 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "search")
					:SetLayout("VERTICAL")
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
						:SetStyle("height", 14)
						:SetStyle("margin", { bottom = 4 })
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 10)
						:SetText(strupper(SEARCH))
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
						:SetStyle("height", 26)
						:SetHintText(L["Filter by Keyword"])
						:SetScript("OnEnterPressed", private.MatsInputOnEnterPressed)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "profession")
					:SetLayout("VERTICAL")
					:SetStyle("margin", { left = 16 })
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
						:SetStyle("height", 14)
						:SetStyle("margin", { bottom = 4 })
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 10)
						:SetText(L["PROFESSION"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "dropdown")
						:SetStyle("height", 26)
						:SetItems(private.matProfessions, private.matProfessions[1])
						:SetScript("OnSelectionChanged", private.MatsDropdownOnSelectionChanged)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "priceSource")
					:SetLayout("VERTICAL")
					:SetStyle("margin", { left = 16 })
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
						:SetStyle("height", 14)
						:SetStyle("margin", { bottom = 4 })
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 10)
						:SetText(L["PRICE SOURCE"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "dropdown")
						:SetStyle("height", 26)
						:SetItems(private.MatPriceSources, private.MatPriceSources[1])
						:SetScript("OnSelectionChanged", private.MatsDropdownOnSelectionChanged)
					)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", 2)
				:SetStyle("color", "#9d9d9d")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "mats")
				:SetStyle("headerFontHeight", 12)
				:GetScrollingTableInfo()
					:NewColumn("name")
						:SetTitles(L["Material Name"])
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo("itemString", TSM.UI.GetColoredItemName)
						:SetTooltipInfo("itemString")
						:SetSortInfo("name")
						:Commit()
					:NewColumn("price")
						:SetTitles(L["Mat Price"])
						:SetWidth(100)
						:SetFont(TSM.UI.Fonts.RobotoMedium)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("matCost", private.MatsGetPriceText)
						:SetSortInfo("matCost")
						:Commit()
					:NewColumn("professions")
						:SetTitles(L["Professions Used In"])
						:SetWidth(300)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo("professions")
						:SetSortInfo("professions")
						:Commit()
					:NewColumn("num")
						:SetTitles(L["Number Owned"])
						:SetWidth(120)
						:SetFont(TSM.UI.Fonts.RobotoMedium)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("totalQuantity", private.MatsGetNumText)
						:SetSortInfo("totalQuantity")
						:Commit()
					:Commit()
				:SetQuery(private.matsQuery)
				:SetSelectionDisabled(true)
				:SetScript("OnRowClick", private.MatsOnRowClick)
			)
	else
		error("Unknown path: "..tostring(path))
	end
end



-- ============================================================================
-- ScrollingTable Functions
-- ============================================================================

function private.CraftsGetCraftNameText(row)
	return TSM.UI.GetColoredItemName(row:GetField("itemString")) or row:GetField("name")
end

function private.CraftsGetBagsText(bagQuantity)
	return bagQuantity or "0"
end

function private.CraftsGetAHText(bagQuantity)
	return bagQuantity or "0"
end

function private.CraftsGetCraftingCostText(spellId)
	return TSM.Money.ToString(TSM.Crafting.Cost.GetCraftingCostBySpellId(spellId))
end

function private.CraftsGetCostItemValueText(costItemValue)
	if tostring(costItemValue) == tostring(math.huge * 0) then
		return ""
	end
	return TSM.Money.ToString(costItemValue)
end

function private.CraftsGetProfitText(profit)
	if tostring(profit) == tostring(math.huge * 0) then
		return ""
	end
	return TSM.Money.ToString(profit, profit >= 0 and "|cff2cec0d" or "|cffd50000")
end

function private.CraftsGetSaleRateText(saleRate)
	if tostring(saleRate) == tostring(math.huge * 0) then
		return ""
	end
	return format("%0.2f", saleRate)
end

function private.MatsGetPriceText(matCost)
	if tostring(matCost) == tostring(math.huge * 0) then
		return ""
	end
	return TSM.Money.ToString(matCost)
end

function private.MatsGetNumText(totalQuantity)
	return totalQuantity or "0"
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.CraftsInputOnTextChanged(input)
	local text = strtrim(input:GetText())
	if text == private.filterText then
		return
	end
	private.filterText = text
	input:SetText(private.filterText)

	private.UpdateCraftsQueryWithFilters(input:GetParentElement():GetParentElement())
end

function private.CraftsDropdownOnSelectionChanged(dropdown, selection)
	private.UpdateCraftsQueryWithFilters(dropdown:GetParentElement():GetParentElement())
end

function private.CheckboxOnValueChanged(checkbox)
	private.UpdateCraftsQueryWithFilters(checkbox:GetParentElement():GetParentElement())
end

function private.CraftsOnRowClick(scrollingTable, record, mouseButton)
	if mouseButton == "LeftButton" then
		TSM.Crafting.Queue.Add(record:GetField("spellId"), 1)
	elseif mouseButton == "RightButton" then
		TSM.Crafting.Queue.Remove(record:GetField("spellId"), 1)
	end
	scrollingTable:Draw()
end

function private.MatsInputOnEnterPressed(input)
	private.UpdateMatsQueryWithFilters(input:GetParentElement():GetParentElement())
end

function private.MatsDropdownOnSelectionChanged(dropdown, selection)
	private.UpdateMatsQueryWithFilters(dropdown:GetParentElement():GetParentElement())
end

function private.MatsOnRowClick(scrollingTable, row)
	local itemString = row:GetField("itemString")
	local priceStr = TSM.db.factionrealm.internalData.mats[itemString].customValue or TSM.db.global.craftingOptions.defaultMatCostMethod
	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "frame")
		:SetLayout("VERTICAL")
		:SetStyle("width", 600)
		:SetStyle("height", 187)
		:SetStyle("anchors", { { "CENTER" } })
		:SetStyle("background", "#2e2e2e")
		:SetStyle("border", "#e2e2e2")
		:SetStyle("borderSize", 2)
		:SetContext(itemString)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "title")
			:SetStyle("height", 44)
			:SetStyle("margin", { top = 24, left = 16, right = 16, bottom = 16 })
			:SetStyle("font", TSM.UI.Fonts.MontserratBold)
			:SetStyle("fontHeight", 18)
			:SetStyle("justifyH", "CENTER")
			:SetText(TSM.UI.GetColoredItemName(itemString))
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "normalPriceInput")
			:SetStyle("height", 26)
			:SetStyle("margin", { left = 16, right = 16, bottom = 25 })
			:SetStyle("background", "#5c5c5c")
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 12)
			:SetStyle("justifyH", "LEFT")
			:SetStyle("textColor", "#ffffff")
			:SetText(TSM.Money.ToString(priceStr) or priceStr)
			:SetScript("OnEnterPressed", private.MatPriceInputOnEnterPressed)
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
	scrollingTable:GetBaseElement():ShowDialogFrame(frame)
end

function private.DialogCloseBtnOnClick(button)
	button:GetBaseElement():HideDialog()
end

function private.MatPriceInputOnEnterPressed(input)
	local value = strtrim(input:GetText())
	if value ~= "" and TSMAPI_FOUR.CustomPrice.Validate(value) then
		local itemString = input:GetParentElement():GetContext()
		TSM.Crafting.SetMatCustomValue(itemString, value)
	else
		-- TODO: better error message
		TSM:Print(L["Invalid custom price entered."])
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.FirstOperationVirtualField(itemString)
	return TSM.Operations.GetFirstOperationByItem("Crafting", itemString) or ""
end

function private.UpdateCraftsQueryWithFilters(frame)
	private.craftsQuery:ResetFilters()
	-- apply search filter
	local filter = strtrim(frame:GetElement("search.input"):GetText())
	if filter ~= "" then
		private.craftsQuery:Matches("itemName", TSMAPI_FOUR.Util.StrEscape(filter))
	end
	-- apply dropdown filter
	local professionPlayer = frame:GetElement("profession.dropdown"):GetSelection()
	if professionPlayer ~= private.craftProfessions[1] then
		local profession, player = strmatch(professionPlayer, "^(.+) %- ([^ ]+)$")
		private.craftsQuery
			:Equal("profession", profession)
			:Or()
				:Equal("players", player)
				:Matches("players", "^"..player..",")
				:Matches("players", ","..player..",")
				:Matches("players", ","..player.."$")
			:End()
	end
	-- apply craftable filter
	local craftableOnly = frame:GetElement("craftable.checkbox"):IsChecked()
	if craftableOnly then
		private.craftsQuery:Custom(private.IsCraftableQueryFilter)
	end
	frame:GetElement("__parent.crafts"):SetQuery(private.craftsQuery, true)
end

function private.IsCraftableQueryFilter(record)
	return TSM.Crafting.ProfessionUtil.GetNumCraftableFromDB(record:GetField("spellId")) > 0
end

function private.UpdateMatsQueryWithFilters(frame)
	private.matsQuery:ResetFilters()
	-- apply search filter
	local filter = strtrim(frame:GetElement("search.input"):GetText())
	if filter ~= "" then
		private.matsQuery:Custom(private.MatItemNameQueryFilter, strlower(TSMAPI_FOUR.Util.StrEscape(filter)))
	end
	-- apply dropdown filters
	local profession = frame:GetElement("profession.dropdown"):GetSelection()
	if profession ~= private.matProfessions[1] then
		private.matsQuery
			:Or()
				:Equal("professions", profession)
				:Matches("professions", "^"..profession..",")
				:Matches("professions", ","..profession..",")
				:Matches("professions", ","..profession.."$")
			:End()
	end
	local priceSource = frame:GetElement("priceSource.dropdown"):GetSelection()
	if priceSource == private.MatPriceSources[2] then
		private.matsQuery:Equal("hasCustomValue", false)
	elseif priceSource == private.MatPriceSources[3] then
		private.matsQuery:Equal("hasCustomValue", true)
	end
	frame:GetElement("__parent.mats"):SetQuery(private.matsQuery, true)
end

function private.MatItemNameQueryFilter(row, filter)
	local name = TSMAPI_FOUR.Item.GetName(row:GetField("itemString"))
	if not name then return end
	return strmatch(strlower(name), filter)
end
