-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Buy = TSM.UI.VendoringUI:NewPackage("Buy")
local L = TSM.L
local private = {
	query = nil,
	filterText = "",
	splitFrame = CreateFrame("Frame"),
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Buy.OnInitialize()
	TSM.UI.VendoringUI.RegisterTopLevelPage(L["Buy"], "iconPack.24x24/Shopping", private.GetFrame)
	private.splitFrame.SplitStack = private.SplitStackCallback
end



-- ============================================================================
-- Buy UI
-- ============================================================================

function private.GetFrame()
	TSM.UI.AnalyticsRecordPathChange("vendoring", "buy")
	private.filterText = ""
	if not private.query then
		private.query = TSM.Vendoring.Buy.CreateMerchantQuery()
			:InnerJoin(TSM.ItemInfo.GetDBForJoin(), "itemString")
	end
	private.query:ResetFilters()
	private.query:NotEqual("numAvailable", 0)
	private.query:ResetOrderBy()
	private.query:OrderBy("name", true)

	return TSMAPI_FOUR.UI.NewElement("Frame", "buy")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "filters")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 65)
			:SetStyle("padding.top", 33)
			:SetStyle("padding.bottom", 12)
			:SetStyle("padding.left", 8)
			:SetStyle("padding.right", 8)
			:SetStyle("background", "#272727")
			:AddChild(TSMAPI_FOUR.UI.NewElement("SearchInput", "searchInput")
				:SetStyle("margin.right", 8)
				:SetHintText(L["Search Vendor"])
				:SetScript("OnTextChanged", private.SearchInputOnTextChanged)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture")
			:SetStyle("height", 2)
			:SetStyle("color", "#585858")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "items")
			:SetStyle("rowHeight", 20)
			:SetStyle("headerBackground", "#404040")
			:SetStyle("headerFont", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("headerFontHeight", 14)
			:GetScrollingTableInfo()
				:NewColumn("qty")
					:SetTitles(L["Qty"])
					:SetWidth(40)
					:SetFont(TSM.UI.Fonts.RobotoMedium)
					:SetFontHeight(12)
					:SetJustifyH("RIGHT")
					:SetTextInfo("stackSize")
					:SetSortInfo("stackSize")
					:Commit()
				:NewColumn("item")
					:SetTitles(L["Item"])
					:SetIconSize(12)
					:SetFont(TSM.UI.Fonts.FRIZQT)
					:SetFontHeight(12)
					:SetJustifyH("LEFT")
					:SetTextInfo(nil, private.GetItemText)
					:SetIconInfo("itemString", TSMAPI_FOUR.Item.GetTexture)
					:SetTooltipInfo("itemString")
					:SetSortInfo("name")
					:SetTooltipLinkingDisabled(true)
					:Commit()
				:NewColumn("cost")
					:SetTitles(L["Cost"])
					:SetWidth(150)
					:SetFont(TSM.UI.Fonts.RobotoMedium)
					:SetFontHeight(12)
					:SetJustifyH("RIGHT")
					:SetTextInfo(nil, private.GetCostText)
					:SetSortInfo("price")
					:Commit()
				:SetCursor("BUY_CURSOR")
				:Commit()
			:SetQuery(private.query)
			:SetScript("OnRowClick", private.RowOnClick)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "footer")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin.top", 8)
			:SetStyle("margin.bottom", -2)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "gold")
				:SetLayout("HORIZONTAL")
				:SetStyle("width", 167)
				:SetStyle("margin.right", 8)
				:SetStyle("padding", 4)
				:SetStyle("background", "#171717")
				:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "icon")
					:SetStyle("width", 18)
					:SetStyle("height", 18)
					:SetStyle("texturePack", "iconPack.18x18/Coins")
					:SetStyle("vertexColor", "#ffd839")
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("PlayerGoldText", "text")
					:SetStyle("justifyH", "RIGHT")
					:SetStyle("fontHeight", 12)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "repairBtn")
				:SetDisabled(not TSM.Vendoring.Buy.NeedsRepair())
				:SetText(L["REPAIR"])
				:SetTooltip(TSM.Vendoring.Buy.CanGuildRepair() and L["Hold ALT to repair from the guild bank."] or nil)
				:SetScript("OnClick", private.RepairOnClick)
			)
		)
		:SetScript("OnUpdate", private.FrameOnUpdate)
		:SetScript("OnHide", private.FrameOnHide)
end

function private.GetItemText(row)
	local itemString, numAvailable = row:GetFields("itemString", "numAvailable")
	local itemName = TSM.UI.GetColoredItemName(itemString) or "?"
	if numAvailable == -1 then
		return itemName
	elseif numAvailable > 0 then
		return itemName.." |cfff72d20("..numAvailable..")|r"
	else
		error("Invalid numAvailable: "..numAvailable)
	end
end

function private.GetCostText(row)
	local costItemString, price = row:GetFields("costItemString", "price")
	if costItemString == "" then
		-- just a price
		return TSM.Money.ToString(price)
	elseif price == 0 then
		-- just an extended cost string
		return costItemString
	else
		-- both
		return TSM.Money.ToString(price).." "..costItemString
	end
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FrameOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)
	frame:GetBaseElement():SetBottomPadding(32)
end

function private.FrameOnHide(frame)
	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		StackSplitFrame:Hide()
	else
		OpenStackSplitFrame()
	end
end

function private.SearchInputOnTextChanged(input)
	local text = strtrim(input:GetText())
	if text == private.filterText then
		return
	end
	private.filterText = text
	input:SetText(private.filterText)

	private.query:ResetFilters()
	private.query:NotEqual("numAvailable", 0)
	if text ~= "" then
		private.query:Matches("name", TSMAPI_FOUR.Util.StrEscape(text))
	end
	input:GetElement("__parent.__parent.items"):UpdateData(true)
end

function private.RowOnClick(table, row, mouseButton)
	if IsShiftKeyDown() then
		private.splitFrame:SetParent(table:_GetBaseFrame())
		private.splitFrame:SetAllPoints(table:_GetBaseFrame())
		private.splitFrame.item = row:GetField("index")
		if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
			StackSplitFrame:OpenStackSplitFrame(math.huge, private.splitFrame, "TOPLEFT", "TOPRIGHT", IsAltKeyDown() and row:GetField("stackSize") or nil)
		else
			OpenStackSplitFrame(math.huge, private.splitFrame, "TOPLEFT", "TOPRIGHT", IsAltKeyDown() and row:GetField("stackSize") or nil)
		end
	elseif mouseButton == "RightButton" then
		TSM.Vendoring.Buy.BuyItemIndex(row:GetFields("index", "stackSize"))
	end
end

function private.RepairOnClick(button)
	PlaySound(SOUNDKIT.ITEM_REPAIR)
	button:SetDisabled(true)

	if IsAltKeyDown() then
		if not TSM.Vendoring.Buy.CanGuildRepair() then
			TSM:Printf(L["Cannot repair from the guild bank!"])
			return
		end
		TSM.Vendoring.Buy.DoGuildRepair()
	else
		TSM.Vendoring.Buy.DoRepair()
	end
end

function private.SplitStackCallback(frame, num)
	assert(frame == private.splitFrame)
	local index = private.splitFrame.item
	assert(index)
	private.splitFrame.item = nil
	TSM.Vendoring.Buy.BuyItemIndex(index, num)
end
