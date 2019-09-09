-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local L = TSM.L
TSMAPI_FOUR.ItemFilter = {}
local ItemFilter = TSMAPI_FOUR.Class.DefineClass("ItemFilter")



-- ============================================================================
-- ItemFilter Class
-- ============================================================================

function ItemFilter.__init(self)
	self._isValid = nil
	self._str = nil
	self._escapedStr = nil
	self._class = nil
	self._subClass = nil
	self._invSlotId = nil
	self._quality = nil
	self._minLevel = nil
	self._maxLevel = nil
	self._minItemLevel = nil
	self._maxItemLevel = nil
	self._minPrice = nil
	self._maxPrice = nil
	self._maxQuantity = nil
	self._usableOnly = nil
	self._unlearned = nil
	self._canlearn = nil
	self._exactOnly = nil
	self._evenOnly = nil
	self._crafting = nil
	self._disenchant = nil
	self._item = nil

	self:_Reset()
end

function ItemFilter._Reset(self)
	self._isValid = false
	self._str = ""
	self._escapedStr = ""
	self._class = nil
	self._subClass = nil
	self._invSlotId = nil
	self._quality = nil
	self._minLevel = 0
	self._maxLevel = math.huge
	self._minItemLevel = 0
	self._maxItemLevel = math.huge
	self._minPrice = 0
	self._maxPrice = math.huge
	self._maxQuantity = math.huge
	self._usableOnly = nil
	self._unlearned = nil
	self._canlearn = nil
	self._exactOnly = nil
	self._evenOnly = nil
	self._crafting = nil
	self._disenchant = nil
	self._item = nil
end

function ItemFilter._ItemQualityToIndex(self, str)
	for i = 0, 4 do
		local text =  _G["ITEM_QUALITY"..i.."_DESC"]
		if strlower(str) == strlower(text) then
			return i
		end
	end
end

function ItemFilter.ParseStr(self, str)
	self:_Reset()
	local numLevelParts, numItemLevelParts, numPriceParts = 0, 0, 0
	self._isValid = nil
	local hasNonCraftingPart = false
	for i, part in TSMAPI_FOUR.Util.VarargIterator(strsplit("/", strtrim(str))) do
		part = strtrim(part)
		if self._isValid ~= nil then
			-- already done iterating, but can't break / return out of a VarargIterator
		elseif i == 1 then
			-- first part must be a filter string or an item
			if strmatch(part, "^[ip]:[0-9]+") then
				local name = TSMAPI_FOUR.Item.GetName(part)
				local level = TSMAPI_FOUR.Item.GetMinLevel(part)
				local quality = TSMAPI_FOUR.Item.GetQuality(part)
				if not name or not level or not quality then
					self._isValid = false
				else
					self._exactOnly = true
					self._item = part
					self._str = strlower(name)
					self._escapedStr = TSMAPI_FOUR.Util.StrEscape(self._str)
					self._quality = quality
					self._minLevel = level
					self._maxLevel = level
					self._class = TSMAPI_FOUR.Item.GetClassId(self._item) or 0
					self._subClass = TSMAPI_FOUR.Item.GetSubClassId(self._item) or 0
				end
			else
				self._str = strlower(part)
				self._escapedStr = TSMAPI_FOUR.Util.StrEscape(self._str)
			end
		elseif part == "" then
			-- ignore an empty part
		elseif tonumber(part) then
			if numLevelParts == 0 then
				self._minLevel = tonumber(part)
			elseif numLevelParts == 1 then
				self._maxLevel = tonumber(part)
			else
				-- already have min / max level
				self._isValid = false
			end
			numLevelParts = numLevelParts + 1
			hasNonCraftingPart = true
		elseif tonumber(strmatch(part, "^i(%d+)$")) then
			if numItemLevelParts == 0 then
				self._minItemLevel = tonumber(strmatch(part, "^i(%d+)$"))
			elseif numItemLevelParts == 1 then
				self._maxItemLevel = tonumber(strmatch(part, "^i(%d+)$"))
			else
				-- already have min / max item level
				self._isValid = false
			end
			numItemLevelParts = numItemLevelParts + 1
			hasNonCraftingPart = true
		elseif TSMAPI_FOUR.Item.GetClassIdFromClassString(part) then
			self._class = TSMAPI_FOUR.Item.GetClassIdFromClassString(part)
			hasNonCraftingPart = true
		elseif self._class and TSMAPI_FOUR.Item.GetSubClassIdFromSubClassString(part, self._class) then
			self._subClass = TSMAPI_FOUR.Item.GetSubClassIdFromSubClassString(part, self._class)
			hasNonCraftingPart = true
		elseif TSMAPI_FOUR.Item.GetInventorySlotIdFromInventorySlotString(part) then
			self._invSlotId = TSMAPI_FOUR.Item.GetInventorySlotIdFromInventorySlotString(part)
			hasNonCraftingPart = true
		elseif self:_ItemQualityToIndex(part) then
			self._quality = self:_ItemQualityToIndex(part)
			hasNonCraftingPart = true
		elseif TSM.Money.FromString(part) then
			if numPriceParts == 0 then
				self._maxPrice = TSM.Money.FromString(part)
			elseif numPriceParts == 1 then
				self._minPrice = self._maxPrice
				self._maxPrice = TSM.Money.FromString(part)
			else
				-- already have min / max price
				self._isValid = false
			end
			numPriceParts = numPriceParts + 1
			hasNonCraftingPart = true
		elseif strlower(part) == "usable" then
			if self._usableOnly then
				self._isValid = false
			end
			self._usableOnly = true
			hasNonCraftingPart = true
		elseif strlower(part) == "unlearned" then
			if self._unlearned then
				self._isValid = false
			end
			if CanIMogIt and CanIMogIt.PlayerKnowsTransmog then
				self._unlearned = true
			else
				TSM:Print(L["The unlearned filter was ignored because the CanIMogIt addon was not found."])
			end
			hasNonCraftingPart = true
		elseif strlower(part) == "canlearn" then
			if self._canlearn then
				self._isValid = false
			end
			if CanIMogIt and CanIMogIt.CharacterCanLearnTransmog then
				self._canlearn = true
			else
				TSM:Print(L["The canlearn filter was ignored because the CanIMogIt addon was not found."])
			end
			hasNonCraftingPart = true
		elseif strlower(part) == "exact" then
			if self._exactOnly then
				self._isValid = false
			end
			self._exactOnly = true
			hasNonCraftingPart = true
		elseif strlower(part) == "even" then
			if self._evenOnly then
				self._isValid = false
			end
			self._evenOnly = true
			hasNonCraftingPart = true
		elseif tonumber(strmatch(part, "^x(%d+)$")) then
			self._maxQuantity = tonumber(strmatch(part, "^x(%d+)$"))
		elseif strlower(part) == "crafting" then
			if self._crafting or self._disenchant then
				self._isValid = false
			end
			self._crafting = true
		elseif strlower(part) == "disenchant" then
			if self._disenchant or self._crafting then
				self._isValid = false
			end
			self._disenchant = true
		else
			-- invalid part
			self._isValid = false
		end
	end

	if (self._crafting or self._disenchant) and hasNonCraftingPart then
		-- we have a filter which can't be used with /crafting or /disenchant
		self._isValid = false
	end

	if self._isValid == nil then
		self._isValid = true
	end
	return self._isValid
end

function ItemFilter.GetStr(self)
	return self._str ~= "" and self._str or nil
end

function ItemFilter.GetItem(self)
	return self._item
end

function ItemFilter.GetQuality(self)
	return self._quality
end

function ItemFilter.GetClass(self)
	return self._class
end

function ItemFilter.GetSubClass(self)
	return self._subClass
end

function ItemFilter.GetInvSlotId(self)
	return self._invSlotId
end

function ItemFilter.GetMinLevel(self)
	return self._minLevel ~= 0 and self._minLevel or nil
end

function ItemFilter.GetMaxLevel(self)
	return self._maxLevel ~= math.huge and self._maxLevel or nil
end

function ItemFilter.GetMinItemLevel(self)
	return self._minItemLevel ~= 0 and self._minItemLevel or nil
end

function ItemFilter.GetMaxItemLevel(self)
	return self._maxItemLevel ~= math.huge and self._maxItemLevel or nil
end

function ItemFilter.GetUsableOnly(self)
	return self._usableOnly
end

function ItemFilter.GetUnlearned(self)
	return self._unlearned
end

function ItemFilter.GetCanLearn(self)
	return self._canlearn
end

function ItemFilter.GetExactOnly(self)
	return self._exactOnly
end

function ItemFilter.GetEvenOnly(self)
	return self._evenOnly
end

function ItemFilter.GetMaxQuantity(self)
	return self._maxQuantity ~= math.huge and self._maxQuantity or nil
end

function ItemFilter.GetMinPrice(self)
	return self._minPrice ~= 0 and self._minPrice or nil
end

function ItemFilter.GetMaxPrice(self)
	return self._maxPrice ~= math.huge and self._maxPrice or nil
end

function ItemFilter.GetCrafting(self)
	return self._crafting
end

function ItemFilter.GetDisenchant(self)
	return self._disenchant
end

function ItemFilter.Matches(self, item, price)
	if not self._isValid then
		return false
	end

	-- check the name
	local name = TSMAPI_FOUR.Item.GetName(item)
	name = name and strlower(name)
	if not name or not strfind(name, self._escapedStr) or (self._exactOnly and name ~= self._str) then
		return
	end

	-- check the quality
	if self._quality and TSMAPI_FOUR.Item.GetQuality(item) ~= self._quality then
		return
	end

	-- check the item level
	local itemLevel = TSMAPI_FOUR.Item.GetItemLevel(item)
	if not itemLevel or itemLevel < self._minItemLevel or itemLevel > self._maxItemLevel then
		return
	end

	-- check the required level
	local level = TSMAPI_FOUR.Item.GetMinLevel(item)
	if not level or level < self._minLevel or level > self._maxLevel then
		return
	end

	-- check the item class
	if self._class and TSMAPI_FOUR.Item.GetClassId(item) ~= self._class then
		return
	end

	-- check the item subclass
	if self._subClass and TSMAPI_FOUR.Item.GetSubClassId(item) ~= self._subClass then
		return
	end

	-- check the inventory slot
	if self._invSlotId and TSMAPI_FOUR.Item.GetInvSlotId(item) ~= self._invSlotId then
		return
	end

	-- check unlearned
	if self._unlearned and CanIMogIt:PlayerKnowsTransmog(TSMAPI_FOUR.Item.GetLink(item)) then
		return
	end

	-- check canlearn
	if self._canlearn and CanIMogIt:CharacterCanLearnTransmog(TSMAPI_FOUR.Item.GetLink(item)) then
		return
	end

	-- check the price
	price = price or 0
	if price < self._minPrice or price > self._maxPrice then
		return
	end

	-- it passed!
	return true
end



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

function TSMAPI_FOUR.ItemFilter.New()
	return ItemFilter()
end
