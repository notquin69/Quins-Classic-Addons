-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Item String functions
-- @submodule Item

local _, TSM = ...
TSM.Item = {}
local Item = TSM.Item
local private = {
	bonusIdCache = {},
	bonusIdTemp = {},
	filteredItemStringCache = {},
	itemStringCache = {},
	baseItemStringMap = nil,
	baseItemStringReader = nil,
}
local ITEM_UPGRADE_VALUE_SHIFT = 1000000



-- ============================================================================
-- Module Functions
-- ============================================================================

function Item.GetBaseItemStringMap()
	return private.baseItemStringMap
end



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

--- Converts the parameter into an itemString.
-- @tparam ?number|string item Either an itemId, itemLink, or itemString to be converted
-- @treturn string The itemString
function TSMAPI_FOUR.Item.ToItemString(item)
	if not item then
		return nil
	end
	if not private.itemStringCache[item] then
		private.itemStringCache[item] = private.ToItemString(item)
	end
	return private.itemStringCache[item]
end

function TSMAPI_FOUR.Item.FilterItemString(itemString)
	if not private.filteredItemStringCache[itemString] then
		private.filteredItemStringCache[itemString] = private.FilterBonusIds(itemString, TSM.CONST.IMPORTANT_BONUS_ID_MAP)
	end
	return private.filteredItemStringCache[itemString]
end

--- Converts the parameter into an itemId.
-- @tparam string item An item to get the id of
-- @treturn number The itemId
function TSMAPI_FOUR.Item.ToItemID(item)
	local itemString = TSMAPI_FOUR.Item.ToItemString(item)
	if type(itemString) ~= "string" then return end
	return tonumber(strmatch(itemString, "^i:(%d+)"))
end

--- Converts the parameter into a base itemString.
-- @tparam string item An item to get the base itemString of
-- @treturn string The base itemString
function TSMAPI_FOUR.Item.ToBaseItemStringFast(itemString)
	if not itemString then
		return nil
	end
	return private.baseItemStringReader[itemString]
end

--- Converts the parameter into a base itemString.
-- @tparam string item An item to get the base itemString of
-- @tparam[opt=false] boolean doGroupLookup If true, will decide whether or not to convert to a baseItemString based on
-- whether or not this specific item is in a group (preserve the full itemString) or not (convert to a baseItemString)
-- @treturn string The base itemString
function TSMAPI_FOUR.Item.ToBaseItemString(item, doGroupLookup)
	-- make sure it's a valid itemString
	local itemString = TSMAPI_FOUR.Item.ToItemString(item)
	if not itemString then return end

	-- quickly return if we're certain it's already a valid baseItemString
	if type(itemString) == "string" and strmatch(itemString, "^[ip]:[0-9]+$") then return itemString end

	if doGroupLookup then
		return TSM.Groups.TranslateItemString(itemString)
	else
		return TSMAPI_FOUR.Item.ToBaseItemStringFast(itemString)
	end
end

--- Converts the parameter into a WoW itemString.
-- @tparam string itemString An itemString to get the WoW itemString of
-- @treturn number The WoW itemString
function TSMAPI_FOUR.Item.ToWowItemString(itemString)
	local _, itemId, rand, numBonus = (":"):split(itemString)
	local level = UnitLevel("player")
	local spec = WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC and GetSpecialization() or nil
	spec = spec and GetSpecializationInfo(spec) or ""
	local upgradeValue = private.GetUpgradeValue(itemString)
	local bonusIds = upgradeValue and numBonus and strmatch(itemString, "i:[0-9]+:[0-9%-]*:[0-9]+:(.+):"..upgradeValue.."$")
	if bonusIds then
		upgradeValue = upgradeValue - ITEM_UPGRADE_VALUE_SHIFT
		return "item:"..itemId.."::::::"..(rand or "").."::"..level..":"..spec..":512::"..numBonus..":"..bonusIds..":"..upgradeValue..":::"
	end
	return "item:"..itemId.."::::::"..(rand or "").."::"..level..":"..spec..":::"..(numBonus and strmatch(itemString, "i:[0-9]+:[0-9%-]*:(.*)") or "")..":::"
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.ToItemString(item)
	local paramType = type(item)
	if paramType == "string" then
		item = strtrim(item)
		local itemId = strmatch(item, "^[ip]:([0-9]+)$")
		if itemId then
			if tonumber(itemId) > TSM.CONST.ITEM_MAX_ID then
				return nil
			end
			-- this is already an itemString
			return item
		end
		itemId = strmatch(item, "item:(%d+)")
		if itemId and tonumber(itemId) > TSM.CONST.ITEM_MAX_ID then
			return nil
		end
	elseif paramType == "number" or tonumber(item) then
		local itemId = tonumber(item)
		if itemId > TSM.CONST.ITEM_MAX_ID then
			return nil
		end
		-- assume this is an itemId
		return "i:"..item
	else
		error("Invalid item parameter type: "..tostring(item))
	end

	-- test if it's already (likely) an item string or battle pet string
	local result = nil
	if strmatch(item, "^i:([0-9%-:]+)$") then
		return private.FixItemString(item)
	elseif strmatch(item, "^p:([0-9%-:]+)$") then
		result = strjoin(":", strmatch(item, "^(p):(%d+:%d+:%d+)"))
		if result then
			return result
		end
		return item
	end

	result = strmatch(item, "^\124cff[0-9a-z]+\124[Hh](.+)\124h%[.+%]\124h\124r$")
	if result then
		-- it was a full item link which we've extracted the itemString from
		item = result
	end

	-- test if it's an old style item string
	result = strjoin(":", strmatch(item, "^(i)tem:([0-9%-]+):[0-9%-]+:[0-9%-]+:[0-9%-]+:[0-9%-]+:[0-9%-]+:([0-9%-]+)$"))
	if result then
		return private.FixItemString(result)
	end

	-- test if it's an old style battle pet string (or if it was a link)
	result = strjoin(":", strmatch(item, "^battle(p)et:(%d+:%d+:%d+)"))
	if result then
		return private.RemoveExtra(result)
	end
	result = strjoin(":", strmatch(item, "^battle(p)et:(%d+)[:]*$"))
	if result then
		return result
	end
	result = strjoin(":", strmatch(item, "^(p):(%d+:%d+:%d+)"))
	if result then
		return private.RemoveExtra(result)
	end

	-- test if it's a long item string
	result = strjoin(":", strmatch(item, "(i)tem:([0-9%-]+):[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:([0-9%-]*):[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:([0-9%-:]+)"))
	if result and result ~= "" then
		return private.FixItemString(result)
	end

	-- test if it's a shorter item string (without bonuses)
	result = strjoin(":", strmatch(item, "(i)tem:([0-9%-]+):[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:([0-9%-]*)"))
	if result and result ~= "" then
		return result
	end
end

function private.RemoveExtra(itemString)
	local num = 1
	while num > 0 do
		itemString, num = gsub(itemString, ":0?$", "")
	end
	return itemString
end

function private.FixItemString(itemString)
	itemString = gsub(itemString, ":0:", "::")-- remove 0s which are in the middle
	itemString = private.RemoveExtra(itemString)
	return private.CheckBonusIds(itemString, strsplit(":", itemString))
end

function private.CheckBonusIds(itemString, _, _, _, count, ...)
	if not count then
		return itemString
	end

	-- make sure we have the correct number of bonusIds
	count = tonumber(count) or 0
	local numParts = select("#", ...)
	local numExtraParts = numParts - count
	local lastExtraPart = select(numParts, ...)
	lastExtraPart = tonumber(lastExtraPart)
	for _ = 1, numExtraParts do
		itemString = gsub(itemString, ":[0-9]*$", "")
	end

	-- we might have already applied the upgrade value shift
	if numExtraParts == 1 and ((lastExtraPart >= 98 and lastExtraPart <= MAX_PLAYER_LEVEL) or (lastExtraPart - ITEM_UPGRADE_VALUE_SHIFT >= 90 and lastExtraPart - ITEM_UPGRADE_VALUE_SHIFT <= MAX_PLAYER_LEVEL)) then
		-- this extra part is likely the upgradeValue which we want to keep so increase it by UPGRADE_VALUE_SHIFT
		if lastExtraPart < ITEM_UPGRADE_VALUE_SHIFT then
			lastExtraPart = lastExtraPart + ITEM_UPGRADE_VALUE_SHIFT
		end
		itemString = itemString..":"..lastExtraPart
	end

	itemString = private.RemoveExtra(itemString)
	itemString = private.FilterBonusIds(itemString, TSM.CONST.ALL_BONUS_ID_MAP)
	return itemString
end

function private.FilterBonusIds(itemString, map)
	local itemStringPrefix, bonusIds = strmatch(itemString, "(i:[0-9]+:[0-9%-]*):[0-9]*:(.+)$")
	if not bonusIds then
		return itemString
	end
	private.bonusIdCache[map] = private.bonusIdCache[map] or {}
	private.bonusIdCache[map][bonusIds] = private.bonusIdCache[map][bonusIds] or {}
	local cache = private.bonusIdCache[map][bonusIds]
	if not cache.num then
		wipe(private.bonusIdTemp)
		local adjust = 0
		for id in gmatch(bonusIds, "[0-9]+") do
			id = tonumber(id)
			if id > ITEM_UPGRADE_VALUE_SHIFT then
				if not tContains(private.bonusIdTemp, id) then
					tinsert(private.bonusIdTemp, id)
					adjust = adjust + 1
				end
			else
				id = map[id]
				if id and not tContains(private.bonusIdTemp, id) then
					tinsert(private.bonusIdTemp, id)
				end
			end
		end
		sort(private.bonusIdTemp)
		cache.num = #private.bonusIdTemp - adjust
		cache.bonusIds = table.concat(private.bonusIdTemp, ":")
		cache.value = strjoin(":", "", cache.num, cache.bonusIds)
	end
	if cache.num == 0 then
		local baseItemString, rand = strmatch(itemString, "(i:[0-9]+)(:[0-9%-]*)")
		rand = rand and rand ~= "" and rand ~= ":" and tonumber(rand) or 0
		if rand == 0 then
			return baseItemString
		else
			return baseItemString..rand
		end
	elseif cache.bonusIds == bonusIds then
		return itemString
	else
		return itemStringPrefix..cache.value
	end
end

function private.GetUpgradeValue(itemString)
	local bonusIds = strmatch(itemString, "i:[0-9]+:[0-9%-]*:[0-9]*:(.+)$")
	if not bonusIds then return end
	for id in gmatch(bonusIds, "[0-9]+") do
		id = tonumber(id)
		if id > ITEM_UPGRADE_VALUE_SHIFT then
			return id
		end
	end
end

function private.ToBaseItemString(itemString)
	return strmatch(itemString, "[ip]:%d+")
end



-- ============================================================================
-- Caches
-- ============================================================================

do
	private.baseItemStringMap = TSM.SmartMap.New("string", "string", private.ToBaseItemString)
	private.baseItemStringReader = private.baseItemStringMap:CreateReader()
end
