-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- ShoppingScrollingTable UI Element Class.
-- The shopping scrolling table is a special subclass of auction scrolling table which has a column for triggering the posting of auctions. It is a subclass of the @{AuctionScrollingTable} class.
-- @classmod ShoppingScrollingTable

local _, TSM = ...
local ShoppingScrollingTable = TSMAPI_FOUR.Class.DefineClass("ShoppingScrollingTable", TSM.UI.AuctionScrollingTable)
TSM.UI.ShoppingScrollingTable = ShoppingScrollingTable



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ShoppingScrollingTable.__init(self)
	self.__super:__init()

	self._highestFilterId = 0
end

function ShoppingScrollingTable.Acquire(self)
	self._highestFilterId = 0
	self.__super:Acquire()
	self:GetScrollingTableInfo()
		:Commit()
end

--- Registers a script handler.
-- @tparam ShoppingScrollingTable self The shopping scrolling table object
-- @tparam string script The script to register for
-- @tparam function handler The script handler which will be called with the shopping scrolling table object followed by
-- any arguments to the script
-- @treturn ShoppingScrollingTable The shopping scrolling table object
function ShoppingScrollingTable.SetScript(self, script, handler)
	self.__super:SetScript(script, handler)
	return self
end

--- Selects the next record in the table.
-- @tparam ShoppingScrollingTable self The shopping scrolling table object
function ShoppingScrollingTable.SelectNextRecord(self)
	if not self._selection or self._numAuctionsByHash[self._selection] > 1 then
		return
	end
	local nextItemHash = nil
	for i = 2, #self._data do
		local hash = self._data[i]
		local prevHash = self._data[i - 1]
		if prevHash == self._selection then
			nextItemHash = hash
			while TSMAPI_FOUR.PlayerInfo.IsPlayer(self._baseRecordByHash[hash].seller, true, true, true) and self._data[i + 1] do
				hash = self._data[i + 1]
				i = i + 1
			end
			if self._baseRecordByHash[hash].baseItemString == self._baseRecordByHash[prevHash].baseItemString then
				-- found the next auction for this item
				self:SetSelection(hash)
				return
			end
			break
		end
	end
	local selectionRecord = self._baseRecordByHash[self._selection]
	if nextItemHash and selectionRecord == self._baseRecordByItem[selectionRecord.baseItemString] then
		-- select the next highest auction
		self:SetSelection(nextItemHash)
	end
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ShoppingScrollingTable._UpdateData(self, queryChanged)
	self.__super:_UpdateData(queryChanged)
	self._highestFilterId = 0
	for _, record in pairs(self._baseRecordByHash) do
		self._highestFilterId = max(self._highestFilterId, record:GetField("filterId"))
	end
end

function ShoppingScrollingTable._GetTableRow(self, isHeader)
	local row = self.__super:_GetTableRow(isHeader)
	if not isHeader then
		local badge = row:_GetTexture()
		TSM.UI.TexturePacks.SetTextureAndSize(badge, "uiFrames.AuctionCounterTexture")
		badge:SetPoint("LEFT", row._texts.item, "RIGHT", 0, 0)
		row._icons.badge = badge

		local num = row:_GetFontString()
		num:SetSize(23, 11)
		num:SetPoint("CENTER", row._icons.badge, "CENTER", 1, 0)
		num:SetFont(TSM.UI.Fonts.MontserratBold, 9)
		num:SetTextColor(0.18, 0.18, 0.18, 1.0)
		num:SetJustifyH("CENTER")
		num:SetJustifyV("MIDDLE")
		row._texts.num = num
	end
	return row
end

function ShoppingScrollingTable._SetRowData(self, row, data)
	local record = self._baseRecordByHash[data]
	local baseItemString = record:GetField("baseItemString")
	local numAuctions = self._numAuctionsByItem[baseItemString]
	local isIndented = self._expanded[baseItemString] and record ~= numAuctions
	if not isIndented and self._numAuctionsByItem[baseItemString] > 1 then
		if self._expanded[baseItemString] then
			row._icons.badge:Hide()
			row._texts.num:Hide()
		else
			row._icons.badge:Show()
			if numAuctions > 999 then
				row._texts.num:SetText("999+")
			else
				row._texts.num:SetText(numAuctions)
			end
			row._texts.num:Show()
		end
	else
		row._icons.badge:Hide()
		row._texts.num:Hide()
	end
	if TSMAPI_FOUR.PlayerInfo.IsPlayer(record.seller, true, true, true) then
		row._texts.seller:SetTextColor(0.3, 0.6, 1, 1.0)
	else
		row._texts.seller:SetTextColor(1, 1, 1, 1.0)
	end
	self.__super:_SetRowData(row, data)
end
