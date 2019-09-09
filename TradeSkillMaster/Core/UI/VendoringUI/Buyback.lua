-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Buyback = TSM.UI.VendoringUI:NewPackage("Buyback")
local L = TSM.L
local private = {
	query = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Buyback.OnInitialize()
	TSM.UI.VendoringUI.RegisterTopLevelPage(BUYBACK, "iconPack.24x24/Buyout", private.GetFrame)
end



-- ============================================================================
-- Buy UI
-- ============================================================================

function private.GetFrame()
	TSM.UI.AnalyticsRecordPathChange("vendoring", "buyback")
	private.query = private.query or TSM.Vendoring.Buyback.CreateQuery()
	private.query:ResetOrderBy()
	private.query:OrderBy("name", true)

	return TSMAPI_FOUR.UI.NewElement("Frame", "buy")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
			:SetStyle("margin.top", 33)
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
					:SetTextInfo("quantity")
					:SetSortInfo("quantity")
					:Commit()
				:NewColumn("item")
					:SetTitles(L["Item"])
					:SetIconSize(12)
					:SetFont(TSM.UI.Fonts.FRIZQT)
					:SetFontHeight(12)
					:SetJustifyH("LEFT")
					:SetTextInfo("itemString", private.GetItemText)
					:SetIconInfo("itemString", TSMAPI_FOUR.Item.GetTexture)
					:SetTooltipInfo("itemString")
					:SetSortInfo("name")
					:SetTooltipLinkingDisabled(true)
					:Commit()
				:NewColumn("cost")
					:SetTitles(L["Cost"])
					:SetWidth(100)
					:SetFont(TSM.UI.Fonts.RobotoMedium)
					:SetFontHeight(12)
					:SetJustifyH("RIGHT")
					:SetTextInfo("price", TSM.Money.ToString)
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
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "buybackAllBtn")
				:SetText(L["BUYBACK ALL"])
				:SetScript("OnClick", private.BuybackAllBtnOnClick)
			)
		)
		:SetScript("OnUpdate", private.FrameOnUpdate)
end

function private.GetItemText(itemString)
	return TSM.UI.GetColoredItemName(itemString) or "?"
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FrameOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)
	frame:GetBaseElement():SetBottomPadding(32)
end

function private.RowOnClick(_, row, mouseButton)
	if mouseButton == "RightButton" then
		TSM.Vendoring.Buyback.BuybackItem(row:GetField("index"))
	end
end

function private.BuybackAllBtnOnClick(button)
	for _, row in private.query:Iterator() do
		TSM.Vendoring.Buyback.BuybackItem(row:GetField("index"))
	end
end
