-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Ledger = TSM.MainUI:NewPackage("Ledger")
local L = TSM.L
local SECONDS_PER_DAY = 24 * 60 * 60
local private = {
	pages = {},
	childPages = {},
	callback = {},
	contextPath = nil,
	contextItemString = nil,
}
local PAGE_PATH_SEP = "`"
local BASE_STYLESHEET = TSM.UI.Util.Stylesheet()
	:SetStyleTable("Text", "SUMMARY_NUM", {
		width = 125,
		font = TSM.UI.Fonts.RobotoMedium,
		fontHeight = 12,
		justifyH = "RIGHT",
	})
	:SetStyleTable("Text", "TOTAL_LINE", {
		width = 125,
		font = TSM.UI.Fonts.MontserratBold,
		fontHeight = 10,
		justifyH = "RIGHT",
		textColor = "#6ebae6"
	})
	:SetStyleTable("Text", "TOP_SELLER_BUYER", {
		width = 225,
		font = TSM.UI.Fonts.MontserratMedium,
		fontHeight = 12,
		justifyV = "TOP",
	})



-- ============================================================================
-- Module Functions
-- ============================================================================

function Ledger.OnInitialize()
	TSM.MainUI.RegisterTopLevelPage("Ledger", "iconPack.24x24/Inventory", private.GetLedgerFrame)
end

function Ledger.RegisterPage(name, callback)
	tinsert(private.pages, name)
	private.callback[name] = callback
end

function Ledger.RegisterChildPage(parentName, childName, callback)
	local path = parentName..PAGE_PATH_SEP..childName
	private.childPages[parentName] = private.childPages[parentName] or {}
	tinsert(private.childPages[parentName], childName)
	private.callback[path] = callback
end



-- ============================================================================
-- Ledger UI
-- ============================================================================

function private.GetLedgerFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "ledger")
	local defaultPage = private.pages[1]
	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "ledger")
		:SetLayout("HORIZONTAL")
		:SetStyle("background", "#272727")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "navigation")
			:SetLayout("VERTICAL")
			:SetStyle("background", "#585858")
			:SetStyle("width", 160)
			:SetStyle("padding.top", 31)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "shadow")
			:SetStyle("width", TSM.UI.TexturePacks.GetWidth("uiFrames.SettingsNavShadow"))
			:SetStyle("texturePack", "uiFrames.SettingsNavShadow")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "contentFrame")
			:SetLayout("VERTICAL")
			:SetStyle("padding.left", -4)
			:SetStyle("padding.top", 39)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ViewContainer", "content")
				:SetNavCallback(private.ContentNavCallback)
				:AddPath("itemDetail")
			)
		)
		:SetScript("OnHide", private.NavButtonOnHide)


	local content = frame:GetElement("contentFrame.content")
	local navFrame = frame:GetElement("navigation")
	for _, pageName in ipairs(private.pages) do
		navFrame:AddChild(TSMAPI_FOUR.UI.NewElement("Button", pageName)
			:SetStyle("height", 20)
			:SetStyle("justifyH", "LEFT")
			:SetStyle("margin.top", 8)
			:SetStyle("margin.left", 16)
			:SetStyle("fontHeight", 14)
			:SetContext(pageName)
			:SetText(pageName)
			:SetScript("OnClick", private.NavButtonOnClick)
		)
		content:AddPath(pageName, pageName == defaultPage)
		if private.childPages[pageName] then
			for _, childPageName in ipairs(private.childPages[pageName]) do
				local path = pageName..PAGE_PATH_SEP..childPageName
				navFrame:AddChild(TSMAPI_FOUR.UI.NewElement("Button", path)
					:SetStyle("height", 20)
					:SetStyle("justifyH", "LEFT")
					:SetStyle("margin.top", 4)
					:SetStyle("margin.left", 24)
					:SetStyle("fontHeight", 10)
					:SetContext(path)
					:SetText(strupper(childPageName))
					:SetScript("OnClick", private.NavButtonOnClick)
				)
				content:AddPath(path, path == defaultPage)
			end
		end
	end
	-- make all the navigation align to the top
	navFrame:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))

	private.UpdateNavFrame(navFrame, defaultPage)
	private.contextPath = L["Inventory"]
	return frame
end

function private.ContentNavCallback(self, path)
	if path == "itemDetail" then
		private.contextItemString = self:GetContext()
		return private.GetItemDetail()
	else
		return private.callback[path]()
	end
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.NavButtonOnClick(button)
	local path = button:GetContext()
	if private.contextPath == path then
		return
	end
	if private.childPages[path] then
		-- select the first child
		path = path..PAGE_PATH_SEP..private.childPages[path][1]
	end

	local ledgerFrame = button:GetParentElement():GetParentElement()
	local contentFrame = ledgerFrame:GetElement("contentFrame")
	local navFrame = ledgerFrame:GetElement("navigation")
	private.UpdateNavFrame(navFrame, path)
	navFrame:Draw()
	contentFrame:GetElement("content"):SetPath(path, private.contextPath ~= path)
	private.contextPath = path
end

function private.NavButtonOnHide(button)
	private.contextPath = nil
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.UpdateNavFrame(navFrame, selectedPath)
	local selectedPage = strsplit(PAGE_PATH_SEP, selectedPath)
	for _, pageName in ipairs(private.pages) do
		navFrame:GetElement(pageName)
			:SetStyle("font", pageName == selectedPage and TSM.UI.Fonts.MontserratBold or TSM.UI.Fonts.MontserratRegular)
			:SetStyle("textColor", pageName == selectedPage and "#ffffff" or "#e2e2e2")
		if private.childPages[pageName] then
			for _, childPageName in ipairs(private.childPages[pageName]) do
				local path = pageName..PAGE_PATH_SEP..childPageName
				if pageName == selectedPage then
					navFrame:GetElement(path)
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("textColor", path == selectedPath and "#ffd839" or "#e2e2e2")
						:Show()
				else
					navFrame:GetElement(path):Hide()
				end
			end
		end
	end
end

function private.GetItemDetail()
	local query = TSM.Accounting.Transactions.CreateQuery()
		:Equal("itemString", private.contextItemString)
		:OrderBy("time", false)

	local topBuyersTemp = TSMAPI_FOUR.Util.AcquireTempTable()
	local topSellersTemp = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, row in query:Iterator() do
		local recordType = row:GetField("type")
		local otherPlayer = row:GetField("otherPlayer")
		local quantity = row:GetField("quantity")
		if recordType == "sale" then
			if not topBuyersTemp[otherPlayer] then
				topBuyersTemp[otherPlayer] = 0
			end
			topBuyersTemp[otherPlayer] = topBuyersTemp[otherPlayer] +  quantity
		else
			if not topSellersTemp[otherPlayer] then
				topSellersTemp[otherPlayer] = 0
			end
			topSellersTemp[otherPlayer] = topSellersTemp[otherPlayer] + quantity
		end
	end

	local topSellers = private.TopSellerBuyerText(topSellersTemp)
	local topBuyers = private.TopSellerBuyerText(topBuyersTemp)

	TSMAPI_FOUR.Util.ReleaseTempTable(topBuyersTemp)
	TSMAPI_FOUR.Util.ReleaseTempTable(topSellersTemp)

	return TSMAPI_FOUR.UI.NewElement("Frame", "content")
		:SetStylesheet(BASE_STYLESHEET)
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "top")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:SetStyle("margin", { left = 7, bottom = 5 })
			:SetStyle("background", "#272727")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "backIcon")
				:SetStyle("width", 18)
				:SetStyle("backgroundTexturePack", "iconPack.14x14/SideArrow")
				:SetStyle("backgroundTextureRotation", 180)
				:SetScript("OnClick", private.ItemDetailBackButtonOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "backBtn")
				:SetStyle("width", 85)
				:SetText(L["Back to List"])
				:SetStyle("fontHeight", 13)
				:SetScript("OnClick", private.ItemDetailBackButtonOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer"))
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "top")
			:SetLayout("HORIZONTAL")
			:SetStyle("background", "#2e2e2e")
			:SetStyle("padding", { left = 8, right = 8, top = 6, bottom = 6 })
			:SetStyle("margin", { left = 7, right = 7, bottom = 6 })
			:SetStyle("borderTexture", "Interface\\Addons\\TradeSkillMaster\\Media\\DashboardCellEdgeFrame.blp")
			:SetStyle("borderSize", 8)
			:SetStyle("borderInset", 1)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "left")
				:SetLayout("VERTICAL")
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "frame")
					:SetLayout("HORIZONTAL")
					:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "icon")
						:SetStyle("width", 30)
						:SetStyle("height", 30)
						:SetStyle("margin", { top = 0, left = 0, right = 8, bottom = 7 })
						:SetStyle("backgroundTexture", TSMAPI_FOUR.Item.GetTexture(private.contextItemString))
						:SetTooltip(private.contextItemString)
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "itemName")
						:SetStyle("height", 15)
						:SetStyle("margin", { bottom = 2, right = 6 })
						:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
						:SetStyle("fontHeight", 16)
						:SetText(TSM.UI.GetColoredItemName(private.contextItemString))
						:SetTooltip(private.contextItemString)
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "topBuyers", "TOP_SELLER_BUYER")
					:SetStyle("margin.bottom", 2)
					:SetStyle("height", 60)
					:SetStyle("padding.right", 6)
					:SetText("|cffffd839" .. L["Top Buyers:"] .. " |r" .. topBuyers)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "topSellers", "TOP_SELLER_BUYER")
					:SetStyle("margin.bottom", 2)
					:SetStyle("height", 60)
					:SetStyle("padding.right", 6)
					:SetText("|cffffd839" .. L["Top Sellers:"] .. " |r" .. topSellers)
				)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "right")
				:SetLayout("VERTICAL")
				:SetStyle("padding", { right = 10 })
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "total")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 20)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "header")
						:SetStyle("width", 125)
						:SetStyle("margin.bottom", 2)
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 13)
						:SetStyle("textColor", "#ffd839")
						:SetText(L["SALE DATA"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "totalAmount", "TOTAL_LINE")
						:SetText(strupper(TOTAL))
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "totalAmount", "TOTAL_LINE")
						:SetText(L["LAST 30 DAYS"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "totalAmount", "TOTAL_LINE")
						:SetText(L["LAST 7 DAYS"])
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "total")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 20)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
						:SetStyle("width", 125)
						:SetStyle("fontHeight", 12)
						:SetText(L["Quantity Sold:"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "totalAmount", "SUMMARY_NUM")
						:SetText(TSM.Accounting.Transactions.GetQuantity(private.contextItemString, nil, "sale"))
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "totalAmount", "SUMMARY_NUM")
						:SetText(TSM.Accounting.Transactions.GetQuantity(private.contextItemString, SECONDS_PER_DAY * 30, "sale"))
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "totalAmount", "SUMMARY_NUM")
						:SetText(TSM.Accounting.Transactions.GetQuantity(private.contextItemString, SECONDS_PER_DAY * 7, "sale"))
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "perDay")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 20)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
						:SetStyle("width", 125)
						:SetStyle("fontHeight", 12)
						:SetText(L["Average Prices:"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "perDayAmount", "SUMMARY_NUM")
						:SetText(TSM.Money.ToString(TSM.Accounting.Transactions.GetAveragePrice(private.contextItemString, nil, "sale")))
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "perDayAmount", "SUMMARY_NUM")
						:SetText(TSM.Money.ToString(TSM.Accounting.Transactions.GetAveragePrice(private.contextItemString, SECONDS_PER_DAY * 30, "sale")))
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "perDayAmount", "SUMMARY_NUM")
						:SetText(TSM.Money.ToString(TSM.Accounting.Transactions.GetAveragePrice(private.contextItemString, SECONDS_PER_DAY * 7, "sale")))
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "top")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 20)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
						:SetStyle("width", 125)
						:SetStyle("fontHeight", 12)
						:SetText(L["Gold Earned:"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "perDayAmount", "SUMMARY_NUM")
						:SetText(TSM.Money.ToString(TSM.Accounting.Transactions.GetTotalPrice(private.contextItemString, nil, "sale")))
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "perDayAmount", "SUMMARY_NUM")
						:SetText(TSM.Money.ToString(TSM.Accounting.Transactions.GetTotalPrice(private.contextItemString, SECONDS_PER_DAY * 30, "sale")))
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "perDayAmount", "SUMMARY_NUM")
						:SetText(TSM.Money.ToString(TSM.Accounting.Transactions.GetTotalPrice(private.contextItemString, SECONDS_PER_DAY * 7, "sale")))
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "total")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 20)
					:SetStyle("margin", { top = 10 })
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "header")
						:SetStyle("width", 125)
						:SetStyle("margin.bottom", 2)
						:SetStyle("font", TSM.UI.Fonts.MontserratBold)
						:SetStyle("fontHeight", 13)
						:SetStyle("textColor", "#ffd839")
						:SetText(L["PURCHASE DATA"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "totalAmount", "TOTAL_LINE")
						:SetText(strupper(TOTAL))
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "totalAmount", "TOTAL_LINE")
						:SetText(L["LAST 30 DAYS"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "totalAmount", "TOTAL_LINE")
						:SetText(L["LAST 7 DAYS"])
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "total")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 20)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
						:SetStyle("width", 125)
						:SetStyle("fontHeight", 12)
						:SetText(L["Quantity Bought:"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "totalAmount", "SUMMARY_NUM")
						:SetText(TSM.Accounting.Transactions.GetQuantity(private.contextItemString, nil, "buy"))
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "totalAmount", "SUMMARY_NUM")
						:SetText(TSM.Accounting.Transactions.GetQuantity(private.contextItemString, SECONDS_PER_DAY * 30, "buy"))
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "totalAmount", "SUMMARY_NUM")
						:SetText(TSM.Accounting.Transactions.GetQuantity(private.contextItemString, SECONDS_PER_DAY * 7, "buy"))
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "perDay")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 20)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
						:SetStyle("width", 125)
						:SetStyle("fontHeight", 12)
						:SetText(L["Average Prices:"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "perDayAmount", "SUMMARY_NUM")
						:SetText(TSM.Money.ToString(TSM.Accounting.Transactions.GetAveragePrice(private.contextItemString, nil, "buy")))
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "perDayAmount", "SUMMARY_NUM")
						:SetText(TSM.Money.ToString(TSM.Accounting.Transactions.GetAveragePrice(private.contextItemString, SECONDS_PER_DAY * 30, "buy")))
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "perDayAmount", "SUMMARY_NUM")
						:SetText(TSM.Money.ToString(TSM.Accounting.Transactions.GetAveragePrice(private.contextItemString, SECONDS_PER_DAY * 7, "buy")))
					)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "top")
					:SetLayout("HORIZONTAL")
					:SetStyle("height", 20)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
						:SetStyle("width", 125)
						:SetStyle("fontHeight", 12)
						:SetText(L["Gold Spent:"])
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "perDayAmount", "SUMMARY_NUM")
						:SetText(TSM.Money.ToString(TSM.Accounting.Transactions.GetTotalPrice(private.contextItemString, nil, "buy")))
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "perDayAmount", "SUMMARY_NUM")
						:SetText(TSM.Money.ToString(TSM.Accounting.Transactions.GetTotalPrice(private.contextItemString, SECONDS_PER_DAY * 30, "buy")))
					)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "perDayAmount", "SUMMARY_NUM")
						:SetText(TSM.Money.ToString(TSM.Accounting.Transactions.GetTotalPrice(private.contextItemString, SECONDS_PER_DAY * 7, "buy")))
					)
				)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "bottom")
			:SetLayout("VERTICAL")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line")
				:SetStyle("height", 2)
				:SetStyle("color", "#9d9d9d")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "scrollingTable")
				:SetStyle("headerBackground", "#404040")
				:SetStyle("headerFont", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("headerFontHeight", 14)
				:GetScrollingTableInfo()
					:NewColumn("activityType")
						:SetTitles(L["Activity Type"])
						:SetWidth(100)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo("type", private.TableGetActivityTypeText)
						:Commit()
					:NewColumn("source")
						:SetTitles(L["Source"])
						:SetWidth(70)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo("source")
						:Commit()
					:NewColumn("buyerSeller")
						:SetTitles(L["Buyer/Seller"])
						:SetWidth(100)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("LEFT")
						:SetTextInfo("otherPlayer")
						:Commit()
					:NewColumn("qty")
						:SetTitles(L["Qty"])
						:SetWidth(45)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("quantity")
						:Commit()
					:NewColumn("perItem")
						:SetTitles(L["Per Item"])
						:SetWidth(120)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo(nil, private.TableGetPerItemText)
						:Commit()
					:NewColumn("totalPrice")
						:SetTitles(L["Total Price"])
						:SetWidth(120)
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo(nil, private.TableGetTotalPriceText)
						:Commit()
					:NewColumn("time")
						:SetTitles(L["Time"])
						:SetFont(TSM.UI.Fonts.FRIZQT)
						:SetFontHeight(12)
						:SetJustifyH("RIGHT")
						:SetTextInfo("time", private.TableGetTimeframeText)
						:Commit()
					:Commit()
				:SetQuery(query)
				:SetAutoReleaseQuery(true)
				:SetSelectionDisabled(true)
				:SetScript("OnRowClick", private.ItemDetailScrollingTableOnRowClick)
			)
		)
end

function private.TopSellerBuyerText(topSellerBuyer)
	local top = ""
	local players = TSMAPI_FOUR.Util.AcquireTempTable()

	for player in pairs(topSellerBuyer) do
		tinsert(players, player)
	end

	TSMAPI_FOUR.Util.TableSortWithValueLookup(players, topSellerBuyer)

	local count = 0
	for i = #players, 1, -1 do
		if count >= 3 then break end
		if count ~= 0 then
			top = top .. ", "
		end
		top = top .. players[i] .. " |cff6fbae6(" .. topSellerBuyer[players[i]] .. ")|r"
		count = count + 1
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(players)

	if count == 0 then
		return L["None"]
	end

	return top
end

function private.ItemDetailBackButtonOnClick(button)
	button:GetParentElement():GetParentElement():GetParentElement():SetPath(private.contextPath, true)
end

function private.ItemDetailScrollingTableOnRowClick(scrollingTable, row, button)
	if button ~= "RightButton" then
		return
	end
	local subtitle = nil
	local recordType, itemString, quantity, otherPlayer, price = row:GetFields("type", "itemString", "quantity", "otherPlayer", "price")
	local name = TSM.UI.GetColoredItemName(itemString) or "?"
	local amount = TSM.Money.ToString(price * quantity)
	if recordType == "sale" then
		subtitle = format(L["Sold %d of %s to %s for %s"], quantity, name, otherPlayer, amount)
	elseif recordType == "buy" then
		subtitle = format(L["Bought %d of %s from %s for %s"], quantity, name, otherPlayer, amount)
	else
		error("Unexpected Type: "..tostring(recordType))
	end
	scrollingTable:GetBaseElement():ShowConfirmationDialog(L["Delete this record?"], subtitle, strupper(DELETE), private.DeleteRecordConfirmed, row:GetUUID())
end

function private.DeleteRecordConfirmed(uuid)
	TSM.Accounting.Transactions.RemoveRowByUUID(uuid)
end



-- ============================================================================
-- Scrolling Table Helper Functions
-- ============================================================================

function private.TableGetActivityTypeText(recordType)
	if recordType == "sale" then
		return L["Sale"]
	elseif recordType == "buy" then
		return L["Buy"]
	else
		error("Unexpected Type: "..tostring(recordType))
	end
end

function private.TableGetTimeframeText(timestamp)
	return SecondsToTime(time() - timestamp)
end

function private.TableGetTotalPriceText(row)
	return TSM.Money.ToString(row:GetField("price") * row:GetField("quantity"))
end

function private.TableGetPerItemText(row)
	return TSM.Money.ToString(row:GetField("price"))
end
