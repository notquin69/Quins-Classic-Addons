-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Item Class functions
-- @submodule Item

local STATIC_DATA = { classes = {}, subClasses = {}, classLookup = {}, classIdLookup = {}, inventorySlotIdLookup = {} }



-- ============================================================================
-- Population of the Static Data
-- ============================================================================

do
	-- Needed because NUM_LE_ITEM_CLASSS contains an erroneous value
	local ITEM_CLASS_IDS = nil
	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		ITEM_CLASS_IDS = {
			LE_ITEM_CLASS_WEAPON,
			LE_ITEM_CLASS_ARMOR,
			LE_ITEM_CLASS_CONTAINER,
			LE_ITEM_CLASS_GEM,
			LE_ITEM_CLASS_ITEM_ENHANCEMENT,
			LE_ITEM_CLASS_CONSUMABLE,
			LE_ITEM_CLASS_GLYPH,
			LE_ITEM_CLASS_TRADEGOODS,
			LE_ITEM_CLASS_RECIPE,
			LE_ITEM_CLASS_BATTLEPET,
			LE_ITEM_CLASS_QUESTITEM,
			LE_ITEM_CLASS_MISCELLANEOUS,
		}
	else
		ITEM_CLASS_IDS = {
			LE_ITEM_CLASS_WEAPON,
			LE_ITEM_CLASS_ARMOR,
			LE_ITEM_CLASS_CONTAINER,
			LE_ITEM_CLASS_CONSUMABLE,
			LE_ITEM_CLASS_TRADEGOODS,
			LE_ITEM_CLASS_PROJECTILE,
			LE_ITEM_CLASS_QUIVER,
			LE_ITEM_CLASS_RECIPE,
			LE_ITEM_CLASS_REAGENT,
			LE_ITEM_CLASS_MISCELLANEOUS,
		}
	end

	for _, classId in ipairs(ITEM_CLASS_IDS) do
		local class = GetItemClassInfo(classId)
		if class then
			STATIC_DATA.classIdLookup[strlower(class)] = classId
			STATIC_DATA.classLookup[class] = {}
			STATIC_DATA.classLookup[class]._index = classId
			for _, subClassId in pairs({GetAuctionItemSubClasses(classId)}) do
				local subClassName = GetItemSubClassInfo(classId, subClassId)
				if not strfind(subClassName, "(OBSOLETE)") then
					STATIC_DATA.classLookup[class][subClassName] = subClassId
				end
			end
		end
	end

	for class, subClasses in pairs(STATIC_DATA.classLookup) do
		tinsert(STATIC_DATA.classes, class)
		STATIC_DATA.subClasses[class] = {}
		for subClass in pairs(subClasses) do
			if subClass ~= "_index" then
				tinsert(STATIC_DATA.subClasses[class], subClass)
			end
		end
		sort(STATIC_DATA.subClasses[class], function(a, b) return STATIC_DATA.classLookup[class][a] < STATIC_DATA.classLookup[class][b] end)
	end
	sort(STATIC_DATA.classes, function(a, b) return STATIC_DATA.classIdLookup[strlower(a)] < STATIC_DATA.classIdLookup[strlower(b)] end)

	for i = 0, NUM_LE_INVENTORY_TYPES do
		local invType = GetItemInventorySlotInfo(i)
		if invType then
			STATIC_DATA.inventorySlotIdLookup[strlower(invType)] = i
		end
	end
end



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

--- Get a list of item classes (localized names).
-- This list is read-only and should not be modified.
function TSMAPI_FOUR.Item.GetItemClasses()
	return STATIC_DATA.classes
end

--- Get a list of item sub classes (localized names) for the class.
-- This list is read-only and should not be modified.
-- @tparam string class The name of the class to get subclasses for
function TSMAPI_FOUR.Item.GetItemSubClasses(class)
	return STATIC_DATA.subClasses[class]
end

--- Get the id for the class.
-- @tparam string class The name of the class to get the id of
-- @treturn number The id of the class
function TSMAPI_FOUR.Item.GetClassIdFromClassString(class)
	return STATIC_DATA.classIdLookup[strlower(class)]
end

--- Get the id for the sub-class.
-- @tparam string subClass The name of the sub-class to get the id of
-- @tparam number classId The id of the class which this sub-class belongs to
-- @treturn number The id of the sub-class
function TSMAPI_FOUR.Item.GetSubClassIdFromSubClassString(subClass, classId)
	if not classId then return end
	local class = GetItemClassInfo(classId)
	if not STATIC_DATA.classLookup[class] then return end
	for str, index in pairs(STATIC_DATA.classLookup[class]) do
		if strlower(str) == strlower(subClass) then
			return index
		end
	end
end

--- Get the inventory slot id for the slot.
-- @tparam string slot The name of the slot to get the id of
-- @treturn number The id of the slot
function TSMAPI_FOUR.Item.GetInventorySlotIdFromInventorySlotString(slot)
	return STATIC_DATA.inventorySlotIdLookup[strlower(slot)]
end
