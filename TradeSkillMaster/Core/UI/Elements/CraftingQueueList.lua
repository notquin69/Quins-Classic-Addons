-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Crafting Queue List UI Element Class.
-- The element used to show the queue in the Crafting UI. It is a subclass of the @{ScrollList} class.
-- @classmod CraftingQueueList

local _, TSM = ...
local CraftingQueueList = TSMAPI_FOUR.Class.DefineClass("CraftingQueueList", TSM.UI.FastScrollingList)
TSM.UI.CraftingQueueList = CraftingQueueList
local private = {
	queryCraftingQueueListLookup = {},
	categoryOrder = {},
	rowFrameLookup = {},
}
local CATEGORY_SEP = "\001"



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function CraftingQueueList.__init(self)
	self.__super:__init()
	self._collapsed = {}
	self._query = nil
	self._onRowClickHandler = nil
end

function CraftingQueueList.Release(self)
	self._onRowClickHandler = nil
	wipe(self._collapsed)
	if self._query then
		self._query:Release()
		private.queryCraftingQueueListLookup[self._query] = nil
		self._query = nil
	end
	for _, row in ipairs(self._rows) do
		private.rowFrameLookup[row._frame] = nil
	end
	self.__super:Release()
end

--- Gets the data of the first row.
-- @tparam CraftingMatList self The crafting queue list object
-- @treturn CraftingQueueList The crafting queue list object
function CraftingQueueList.GetFirstData(self)
	for _, data in ipairs(self._data) do
		if type(data) ~= "string" then
			return data
		end
	end
end

--- Registers a script handler.
-- @tparam CraftingQueueList self The crafting queue list object
-- @tparam string script The script to register for (supported scripts: `OnValueChanged`)
-- @tparam function handler The script handler which will be called with the crafting queue list object followed by any
-- arguments to the script
-- @treturn CraftingQueueList The crafting queue list object
function CraftingQueueList.SetScript(self, script, handler)
	if script == "OnRowClick" then
		self._onRowClickHandler = handler
	else
		error("Unknown CraftingQueueList script: "..tostring(script))
	end
	return self
end

--- Sets the @{DatabaseQuery} source for this list.
-- This query is used to populate the entries in the crafting queue list.
-- @tparam CraftingQueueList self The crafting queue list object
-- @tparam DatabaseQuery query The query object
-- @treturn CraftingQueueList The crafting queue list object
function CraftingQueueList.SetQuery(self, query)
	if self._query then
		self._query:Release()
		private.queryCraftingQueueListLookup[self._query] = nil
	end
	self._query = query
	self._query:SetUpdateCallback(private.QueryUpdateCallback)
	private.queryCraftingQueueListLookup[query] = self
	return self
end

function CraftingQueueList.Draw(self)
	self:_UpdateData()
	self.__super:Draw()
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function CraftingQueueList._UpdateData(self)
	wipe(self._data)
	if not self._query then
		return
	end
	local categories = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, row in self._query:Iterator() do
		local rawCategory = strjoin(CATEGORY_SEP, row:GetFields("profession", "players"))
		local category = strlower(rawCategory)
		if not categories[category] then
			tinsert(categories, category)
		end
		categories[category] = rawCategory
		if not self._collapsed[rawCategory] then
			tinsert(self._data, row)
		end
	end
	sort(categories, private.CategorySortComparator)
	wipe(private.categoryOrder)
	for i, category in ipairs(categories) do
		private.categoryOrder[category] = i
		tinsert(self._data, categories[category])
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(categories)
	sort(self._data, private.DataSortComparator)
end

function CraftingQueueList._GetListRow(self)
	local row = self.__super:_GetListRow()
	row._frame:SetScript("OnClick", private.RowOnClick)
	row._frame:SetScript("OnEnter", private.RowOnEnter)
	row._frame:SetScript("OnLeave", private.RowOnLeave)
	private.rowFrameLookup[row._frame] = row

	local expander = row:_GetTexture()
	expander:SetPoint("LEFT", 2, 0)
	row._icons.expander = expander

	local expanderBtn = row:_GetButton()
	expanderBtn:SetAllPoints(expander)
	expanderBtn:SetScript("OnClick", private.ExpanderOnClick)
	expanderBtn:SetScript("OnEnter", private.ChildBtnOnEnter)
	expanderBtn:SetScript("OnLeave", private.ChildBtnOnLeave)
	row._buttons.expander = expanderBtn

	local minus = row:_GetTexture()
	minus:SetPoint("LEFT", 4, 0)
	row._icons.minus = minus

	local minusBtn = row:_GetButton()
	minusBtn:SetAllPoints(minus)
	minusBtn:SetScript("OnClick", private.MinusBtnOnClick)
	minusBtn:SetScript("OnEnter", private.ChildBtnOnEnter)
	minusBtn:SetScript("OnLeave", private.ChildBtnOnLeave)
	row._buttons.minus = minusBtn

	local plus = row:_GetTexture()
	plus:SetPoint("LEFT", minus, "RIGHT")
	row._icons.plus = plus

	local plusBtn = row:_GetButton()
	plusBtn:SetAllPoints(plus)
	plusBtn:SetScript("OnClick", private.PlusBtnOnClick)
	plusBtn:SetScript("OnEnter", private.ChildBtnOnEnter)
	plusBtn:SetScript("OnLeave", private.ChildBtnOnLeave)
	row._buttons.plus = plusBtn

	local numText = row:_GetFontString()
	numText:SetPoint("LEFT", plus, "RIGHT", 4, 0)
	numText:SetWidth(24)
	numText:SetHeight(14)
	numText:SetFont(TSM.UI.Fonts.RobotoRegular, 12)
	numText:SetJustifyH("RIGHT")
	numText:SetJustifyV("MIDDLE")
	row._texts.num = numText

	local itemText = row:_GetFontString()
	itemText:SetPoint("LEFT", numText, "RIGHT", 4, 0)
	itemText:SetPoint("TOPRIGHT")
	itemText:SetPoint("BOTTOMRIGHT")
	itemText:SetFont(TSM.UI.Fonts.FRIZQT, 12)
	itemText:SetJustifyH("LEFT")
	itemText:SetJustifyV("MIDDLE")
	row._texts.item = itemText

	return row
end

function CraftingQueueList._SetRowData(self, row, data)
	if type(data) == "string" then
		row._icons.expander:Show()
		row._buttons.expander:Show()
		row._icons.minus:Hide()
		row._buttons.minus:Hide()
		row._icons.plus:Hide()
		row._buttons.plus:Hide()
		row._texts.num:Hide()
		TSM.UI.TexturePacks.SetTextureAndSize(row._icons.expander, self._collapsed[data] and "iconPack.18x18/Carot/Collapsed" or "iconPack.18x18/Carot/Expanded")
		row._texts.item:SetPoint("LEFT", row._icons.expander, "RIGHT", 2, 0)

		local currentProfession = TSM.Crafting.ProfessionUtil.GetCurrentProfessionName()
		local profession, players = strsplit(CATEGORY_SEP, data)
		if strlower(profession) ~= strlower(currentProfession or "") then
			profession = "|cfff21319"..profession.."|r"
		end
		if not private.PlayersContains(players, UnitName("player")) then
			players = "|cfff21319("..players..")|r"
		else
			players = "("..players..")"
		end
		row._texts.item:SetText(profession.." "..players)
	else
		row._icons.expander:Hide()
		row._buttons.expander:Hide()
		row._icons.minus:Show()
		row._buttons.minus:Show()
		row._icons.plus:Show()
		row._buttons.plus:Show()
		row._texts.num:Show()
		TSM.UI.TexturePacks.SetTextureAndSize(row._icons.plus, "iconPack.14x14/Add/Circle")
		TSM.UI.TexturePacks.SetTextureAndSize(row._icons.minus, "iconPack.14x14/Subtract/Circle")
		row._texts.item:SetPoint("LEFT", row._texts.num, "RIGHT", 4, 0)

		local spellId = data:GetField("spellId")
		local numCraftable = TSM.Crafting.ProfessionUtil.GetNumCraftableFromDB(spellId)
		local numQueued = data:GetField("num")
		local numTextColor = numCraftable >= numQueued and "|cff2cec0d" or numCraftable > 0 and "|cffff6600" or "|cfff21319"
		row._texts.num:SetText(numTextColor..numQueued.."|r")
		row._texts.num:Show()
		local itemString = TSM.Crafting.GetItemString(spellId)
		row._texts.item:SetText(itemString and TSM.UI.GetColoredItemName(itemString) or GetSpellInfo(spellId) or "?")
	end

	self.__super:_SetRowData(row, data)
end

function CraftingQueueList._SetCollapsed(self, data, collapsed)
	self._collapsed[data] = collapsed or nil
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.RowOnClick(frame, mouseButton)
	local self = private.rowFrameLookup[frame]
	local data = self:GetData()
	if type(data) ~= "string" and self._scrollingList._onRowClickHandler then
		self._scrollingList:_onRowClickHandler(data, mouseButton)
	end
end

function private.RowOnEnter(frame)
	local self = private.rowFrameLookup[frame]
	local data = self:GetData()
	if type(data) == "table" then
		self:SetHighlightState("hover")
		local spellId = data:GetField("spellId")
		local numQueued = data:GetField("num")
		local itemString = TSM.Crafting.GetItemString(spellId)
		local name = itemString and TSM.UI.GetColoredItemName(itemString) or GetSpellInfo(spellId) or "?"
		local tooltipLines = TSMAPI_FOUR.Util.AcquireTempTable()
		tinsert(tooltipLines, name)
		for _, matItemString, quantity in TSM.Crafting.MatIterator(spellId) do
			local numHave = TSMAPI_FOUR.Inventory.GetBagQuantity(matItemString) + TSMAPI_FOUR.Inventory.GetReagentBankQuantity(matItemString) + TSMAPI_FOUR.Inventory.GetBankQuantity(matItemString)
			local numNeed = quantity * numQueued
			local color = numHave >= numNeed and "|cff2cec0d" or "|cfff21319"
			tinsert(tooltipLines, format("%s%d/%d|r - %s", color, numHave, numNeed, TSMAPI_FOUR.Item.GetName(matItemString) or "?"))
		end
		TSM.UI.ShowTooltip(frame, strjoin("\n", TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(tooltipLines)))
	end
end

function private.RowOnLeave(frame)
	local self = private.rowFrameLookup[frame]
	TSM.UI.HideTooltip()
	self:SetHighlightState()
end

function private.ExpanderOnClick(button)
	local row = private.rowFrameLookup[button:GetParent()]
	local scrollingList = row._scrollingList
	scrollingList:_SetCollapsed(row:GetData(), not scrollingList._collapsed[row:GetData()])
	scrollingList:_UpdateData()
	scrollingList:Draw()
end

function private.ChildBtnOnEnter(button)
	local row = button:GetParent()
	row:GetScript("OnEnter")(row)
end

function private.ChildBtnOnLeave(button)
	local row = button:GetParent()
	row:GetScript("OnLeave")(row)
end

function private.MinusBtnOnClick(button)
	local row = private.rowFrameLookup[button:GetParent()]
	TSM.Crafting.Queue.Remove(row:GetData():GetField("spellId"), 1)
end

function private.PlusBtnOnClick(button)
	local row = private.rowFrameLookup[button:GetParent()]
	TSM.Crafting.Queue.Add(row:GetData():GetField("spellId"), 1)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.PlayersContains(players, player)
	players = strlower(players)
	player = strlower(player)
	return players == player or strmatch(players, "^"..player..",") or strmatch(players, ","..player..",") or strmatch(players, ","..player.."$")
end

function private.CategorySortComparator(a, b)
	local aProfession, aPlayers = strsplit(CATEGORY_SEP, a)
	local bProfession, bPlayers = strsplit(CATEGORY_SEP, b)
	if aProfession ~= bProfession then
		local currentProfession = TSM.Crafting.ProfessionUtil.GetCurrentProfessionName()
		currentProfession = strlower(currentProfession or "")
		if aProfession == currentProfession then
			return true
		elseif bProfession == currentProfession then
			return false
		else
			return aProfession < bProfession
		end
	end
	local playerName = UnitName("player")
	local aContainsPlayer = private.PlayersContains(aPlayers, playerName)
	local bContainsPlayer = private.PlayersContains(bPlayers, playerName)
	if aContainsPlayer and not bContainsPlayer then
		return true
	elseif bContainsPlayer and not aContainsPlayer then
		return false
	else
		return aPlayers < bPlayers
	end
end

function private.DataSortComparator(a, b)
	-- sort by category
	local aCategory, bCategory = nil, nil
	if type(a) == "string" and type(b) == "string" then
		return private.categoryOrder[strlower(a)] < private.categoryOrder[strlower(b)]
	elseif type(a) == "string" then
		aCategory = strlower(a)
		bCategory = strlower(strjoin(CATEGORY_SEP, b:GetFields("profession", "players")))
		if aCategory == bCategory then
			return true
		end
	elseif type(b) == "string" then
		aCategory = strlower(strjoin(CATEGORY_SEP, a:GetFields("profession", "players")))
		bCategory = strlower(b)
		if aCategory == bCategory then
			return false
		end
	else
		aCategory = strlower(strjoin(CATEGORY_SEP, a:GetFields("profession", "players")))
		bCategory = strlower(strjoin(CATEGORY_SEP, b:GetFields("profession", "players")))
	end
	if aCategory ~= bCategory then
		return private.categoryOrder[aCategory] < private.categoryOrder[bCategory]
	end
	-- sort spells within a category
	local aSpellId = a:GetField("spellId")
	local bSpellId = b:GetField("spellId")
	local aNumCraftable = a:GetField("numCraftable")
	local bNumCraftable = b:GetField("numCraftable")
	local aNumQueued = a:GetField("num")
	local bNumQueued = b:GetField("num")
	local aCanCraftAll = aNumCraftable >= aNumQueued
	local bCanCraftAll = bNumCraftable >= bNumQueued
	if aCanCraftAll and not bCanCraftAll then
		return true
	elseif not aCanCraftAll and bCanCraftAll then
		return false
	end
	if aNumCraftable ~= bNumCraftable then
		return aNumCraftable > bNumCraftable
	end
	return aSpellId < bSpellId
end

function private.QueryUpdateCallback(query)
	local self = private.queryCraftingQueueListLookup[query]
	self:Draw()
end
