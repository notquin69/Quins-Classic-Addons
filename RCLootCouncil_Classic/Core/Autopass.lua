--- autopass.lua	Contains everything related to autopassing in Classic
-- @author	Potdisc
-- Create Date : 6/9/2019
local _,addon = ...

--- Never autopass these armor types.
-- @table autopassOverride
local autopassOverride = {
	"INVTYPE_CLOAK",
}
-- "WARRIOR",  "PALADIN", "DRUID", "ROGUE", "PRIEST", "MAGE", "WARLOCK", "HUNTER", "SHAMAN",
--- Classes that should autopass a subtype.
-- @table autopassTable
local autopassTable = {
	[LE_ITEM_CLASS_ARMOR] = {
		[LE_ITEM_ARMOR_CLOTH]		= {"WARRIOR",  "PALADIN", "DRUID",  "ROGUE",   "HUNTER", "SHAMAN", },
		[LE_ITEM_ARMOR_LEATHER] 	= {"WARRIOR",  "PALADIN", "PRIEST", "MAGE",    "WARLOCK"}, -- "HUNTER", "SHAMAN",
		[LE_ITEM_ARMOR_MAIL] 		= {"DRUID",  "ROGUE",   "PRIEST", "MAGE",    "WARLOCK", }, -- "WARRIOR",  "PALADIN",
		[LE_ITEM_ARMOR_PLATE]		= {"DRUID",    "ROGUE",   "HUNTER", "SHAMAN",  "PRIEST", "MAGE",    "WARLOCK", },
		[LE_ITEM_ARMOR_SHIELD] 		= { "DRUID",   "ROGUE",   "HUNTER", "PRIEST",  "MAGE",   "WARLOCK", },
      -- "Relic" types seem to be coming in phase 5
      [LE_ITEM_ARMOR_LIBRAM]     = {"WARRIOR", "DRUID", "ROGUE", "PRIEST", "MAGE", "WARLOCK", "HUNTER", "SHAMAN"},
      [LE_ITEM_ARMOR_IDOL]       = {"WARRIOR",  "PALADIN", "ROGUE", "PRIEST", "MAGE", "WARLOCK", "HUNTER", "SHAMAN",},
      [LE_ITEM_ARMOR_TOTEM]      = {"WARRIOR",  "PALADIN", "DRUID", "ROGUE", "PRIEST", "MAGE", "WARLOCK", "HUNTER",},
      [LE_ITEM_ARMOR_SIGIL]      = {"WARRIOR",  "PALADIN", "DRUID", "ROGUE", "PRIEST", "MAGE", "WARLOCK", "HUNTER", "SHAMAN",}, -- Deathknight only?
	},
	[LE_ITEM_CLASS_WEAPON] = {
		[LE_ITEM_WEAPON_AXE1H]		= {"DRUID", "PRIEST", "MAGE", "WARLOCK"},
		[LE_ITEM_WEAPON_AXE2H]		= {"DRUID", "ROGUE",   "PRIEST", "MAGE", "WARLOCK", },
		[LE_ITEM_WEAPON_BOWS] 		= {"PALADIN", "DRUID",   "SHAMAN", "PRIEST", "MAGE", "WARLOCK"},
		[LE_ITEM_WEAPON_CROSSBOW] 	= {"PALADIN", "DRUID",   "SHAMAN", "PRIEST", "MAGE", "WARLOCK"},
		[LE_ITEM_WEAPON_DAGGER]		= {"PALADIN" },
		[LE_ITEM_WEAPON_GUNS]		= {"PALADIN", "DRUID",  "SHAMAN", "PRIEST", "MAGE", "WARLOCK"},
		[LE_ITEM_WEAPON_MACE1H]		= {"HUNTER", "MAGE", "WARLOCK", },
		[LE_ITEM_WEAPON_MACE2H]		= {"ROGUE", "HUNTER", "PRIEST", "MAGE", "WARLOCK", },
		[LE_ITEM_WEAPON_POLEARM] 	= {"ROGUE", "SHAMAN", "PRIEST", "MAGE", "WARLOCK", },
		[LE_ITEM_WEAPON_SWORD1H] 	= {"DRUID", "SHAMAN", "PRIEST",},
		[LE_ITEM_WEAPON_SWORD2H]	= {"DRUID",   "ROGUE", "SHAMAN", "PRIEST", "MAGE", "WARLOCK", },
		[LE_ITEM_WEAPON_STAFF]		= {"PALADIN",  "ROGUE", },
		[LE_ITEM_WEAPON_WAND]		= {"WARRIOR",  "PALADIN", "DRUID",   "ROGUE", "HUNTER", "SHAMAN", },
		[LE_ITEM_WEAPON_WARGLAIVE]	= {"WARRIOR",  "PALADIN", "DRUID",   "ROGUE", "PRIEST", "MAGE", "WARLOCK", "HUNTER", "SHAMAN",}, -- Retail only?
		[LE_ITEM_WEAPON_UNARMED] 	= { "PALADIN",  "PRIEST", "MAGE", "WARLOCK"}, -- Fist weapons
      [LE_ITEM_WEAPON_THROWN]    = {"PALADIN", "DRUID", "PRIEST", "MAGE", "WARLOCK", "HUNTER", "SHAMAN",},
	},
}

--- Checks if the player should autopass on a given item.
-- All params are supplied by the lootTable from the ML.
-- Checks for a specific class if 'class' arg is provided, otherwise the player's class.
--	@return true if the player should autopass the given item.
function addon:AutoPassCheck(link, equipLoc, typeID, subTypeID, classesFlag, isToken, isRelic, class)
	local class = class or self.playerClass
	local classID = self.classTagNameToID[class]
	if bit.band(classesFlag, bit.lshift(1, classID-1)) == 0 then -- The item tooltip writes the allowed clases, but our class is not in it.
		return true
	end
	local id = type(link) == "number" and link or self:GetItemIDFromLink(link) -- Convert to id if needed
	if equipLoc == "INVTYPE_TRINKET" then
		if self:Getdb().autoPassTrinket then
			if _G.RCTrinketSpecs and _G.RCTrinketSpecs[id] and _G.RCTrinketSpecs[id]:sub(-classID, -classID)=="0" then
				return true
			end
		end
	end
	if not tContains(autopassOverride, equipLoc) then
		if autopassTable[typeID] and autopassTable[typeID][subTypeID] then
			return tContains(autopassTable[typeID][subTypeID], class)
		end
	end
	return false
end
