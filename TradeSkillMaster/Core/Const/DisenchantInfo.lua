-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local L = TSM.L
local WEAPON = GetItemClassInfo(LE_ITEM_CLASS_WEAPON)
local ARMOR = GetItemClassInfo(LE_ITEM_CLASS_ARMOR)

TSM.CONST.DISENCHANT_INFO = {
	{
		desc = L["Dust"],
		["i:10940"] = { -- Strange Dust
			minLevel = 0,
			maxLevel = 24,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 5, maxItemLevel = 15, amountOfMats = 1.222},
				{itemType = ARMOR, rarity = 2, minItemLevel = 16, maxItemLevel = 20, amountOfMats = 2.025},
				{itemType = ARMOR, rarity = 2, minItemLevel = 21, maxItemLevel = 25, amountOfMats = 5.008},
				{itemType = ARMOR, rarity = 3, minItemLevel = 16, maxItemLevel = 25, amountOfMats = 0.127},
				{itemType = WEAPON, rarity = 2, minItemLevel = 5, maxItemLevel = 15, amountOfMats = 0.302},
				{itemType = WEAPON, rarity = 2, minItemLevel = 16, maxItemLevel = 20, amountOfMats = 0.507},
				{itemType = WEAPON, rarity = 2, minItemLevel = 21, maxItemLevel = 25, amountOfMats = 0.753},
				{itemType = WEAPON, rarity = 3, minItemLevel = 16, maxItemLevel = 25, amountOfMats = 0.127},
			},
		},
		["i:16204"] = { -- Light Illusion Dust
			minLevel = 51,
			maxLevel = 60,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 26, maxItemLevel = 45, amountOfMats = 1.155},
				{itemType = ARMOR, rarity = 3, minItemLevel = 26, maxItemLevel = 45, amountOfMats = 0.127},
				{itemType = WEAPON, rarity = 2, minItemLevel = 26, maxItemLevel = 45, amountOfMats = 0.344},
				{itemType = WEAPON, rarity = 3, minItemLevel = 26, maxItemLevel = 45, amountOfMats = 0.127},
			},
		},
		["i:156930"] = { -- Rich Illusion Dust
			minLevel = 51,
			maxLevel = 60,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 46, maxItemLevel = 58, amountOfMats = 1.155},
				{itemType = ARMOR, rarity = 3, minItemLevel = 46, maxItemLevel = 58, amountOfMats = 0.127},
				{itemType = ARMOR, rarity = 4, minItemLevel = 58, maxItemLevel = 65, amountOfMats = 0.900},
				{itemType = WEAPON, rarity = 2, minItemLevel = 46, maxItemLevel = 58, amountOfMats = 0.344},
				{itemType = WEAPON, rarity = 3, minItemLevel = 46, maxItemLevel = 58, amountOfMats = 0.127},
				{itemType = WEAPON, rarity = 4, minItemLevel = 58, maxItemLevel = 65, amountOfMats = 0.900},
			},
		},
		["i:22445"] = { -- Arcane Dust
			minLevel = 57,
			maxLevel = 70,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 59, maxItemLevel = 70, amountOfMats = 1.933},
				{itemType = ARMOR, rarity = 2, minItemLevel = 71, maxItemLevel = 80, amountOfMats = 2.655},
				{itemType = WEAPON, rarity = 2, minItemLevel = 80, maxItemLevel = 99, amountOfMats = 0.750},
				{itemType = WEAPON, rarity = 2, minItemLevel = 71, maxItemLevel = 80, amountOfMats = 0.787},
			},
		},
		["i:34054"] = { -- Infinite Dust
			minLevel = 67,
			maxLevel = 80,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 80, maxItemLevel = 90, amountOfMats = 1.933},
				{itemType = ARMOR, rarity = 2, minItemLevel = 91, maxItemLevel = 100, amountOfMats = 4.155},
				{itemType = WEAPON, rarity = 2, minItemLevel = 80, maxItemLevel = 90, amountOfMats = 0.562},
				{itemType = WEAPON, rarity = 2, minItemLevel = 91, maxItemLevel = 100, amountOfMats = 1.200},
			},
		},
		["i:52555"] = { -- Hypnotic Dust
			minLevel = 77,
			maxLevel = 85,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 101, maxItemLevel = 103, amountOfMats = 1.556},
				{itemType = ARMOR, rarity = 2, minItemLevel = 104, maxItemLevel = 106, amountOfMats = 2.304},
				{itemType = ARMOR, rarity = 2, minItemLevel = 107, maxItemLevel = 108, amountOfMats = 2.628},
				{itemType = WEAPON, rarity = 2, minItemLevel = 101, maxItemLevel = 103, amountOfMats = 0.450},
				{itemType = WEAPON, rarity = 2, minItemLevel = 104, maxItemLevel = 106, amountOfMats = 0.677},
				{itemType = WEAPON, rarity = 2, minItemLevel = 107, maxItemLevel = 108, amountOfMats = 0.774},
			},
		},
		["i:74249"] = { -- Spirit Dust
			minLevel = 83,
			maxLevel = 88,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 108, maxItemLevel = 109, amountOfMats = 2.285},
				{itemType = ARMOR, rarity = 2, minItemLevel = 110, maxItemLevel = 113, amountOfMats = 2.710},
				{itemType = ARMOR, rarity = 2, minItemLevel = 114, maxItemLevel = 115, amountOfMats = 3.135},
				{itemType = WEAPON, rarity = 2, minItemLevel = 108, maxItemLevel = 109, amountOfMats = 2.245},
				{itemType = WEAPON, rarity = 2, minItemLevel = 110, maxItemLevel = 113, amountOfMats = 2.700},
				{itemType = WEAPON, rarity = 2, minItemLevel = 114, maxItemLevel = 115, amountOfMats = 3.560},
			},
		},
		["i:109693"] = { -- Draenic Dust
			minLevel = 90,
			maxLevel = 100,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 116, maxItemLevel = 136, amountOfMats = 2.600},
				{itemType = ARMOR, rarity = 3, minItemLevel = 116, maxItemLevel = 138, amountOfMats = 5.810},
				{itemType = WEAPON, rarity = 2, minItemLevel = 116, maxItemLevel = 136, amountOfMats = 2.600},
				{itemType = WEAPON, rarity = 3, minItemLevel = 116, maxItemLevel = 138, amountOfMats = 6.220},
			},
		},
		["i:124440"] = { -- Arkhana
			minLevel = 101,
			maxLevel = 110,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 138, maxItemLevel = 170, amountOfMats = 4.750},
				{itemType = WEAPON, rarity = 2, minItemLevel = 138, maxItemLevel = 170, amountOfMats = 4.750},
			},
		},
		["i:152875"] = { -- Gloom Dust
			minLevel = 111,
			maxLevel = 120,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 172, maxItemLevel = 225, amountOfMats = 4.130},
				{itemType = ARMOR, rarity = 2, minItemLevel = 226, maxItemLevel = 310, amountOfMats = 5.474},
				{itemType = ARMOR, rarity = 3, minItemLevel = 182, maxItemLevel = 999, amountOfMats = 1.425},
				{itemType = ARMOR, rarity = 4, minItemLevel = 300, maxItemLevel = 999, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 2, minItemLevel = 172, maxItemLevel = 225, amountOfMats = 4.130},
				{itemType = WEAPON, rarity = 2, minItemLevel = 226, maxItemLevel = 310, amountOfMats = 5.474},
				{itemType = WEAPON, rarity = 3, minItemLevel = 182, maxItemLevel = 999, amountOfMats = 1.425},
				{itemType = WEAPON, rarity = 4, minItemLevel = 300, maxItemLevel = 999, amountOfMats = 1.000},
			},
		},
	},
	{
		desc = L["Essences"],
		["i:10938"] = { -- lesser Magic Essence
			minLevel = 1,
			maxLevel = 15,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 5, maxItemLevel = 15, amountOfMats = 0.303},
				{itemType = WEAPON, rarity = 2, minItemLevel = 5, maxItemLevel = 15, amountOfMats = 1.218},
			},
		},
		["i:10939"] = { -- Greater Magic Essence
			minLevel = 1,
			maxLevel = 15,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 16, maxItemLevel = 25, amountOfMats = 0.307},
				{itemType = ARMOR, rarity = 3, minItemLevel = 16, maxItemLevel = 25, amountOfMats = 0.307},
				{itemType = WEAPON, rarity = 2, minItemLevel = 16, maxItemLevel = 25, amountOfMats = 2.000},
				{itemType = WEAPON, rarity = 3, minItemLevel = 16, maxItemLevel = 25, amountOfMats = 2.000},
			},
		},
		["i:16202"] = { -- Lesser Eternal Essence
			minLevel = 46,
			maxLevel = 60,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 26, maxItemLevel = 45, amountOfMats = 0.346},
				{itemType = ARMOR, rarity = 3, minItemLevel = 26, maxItemLevel = 45, amountOfMats = 0.500},
				{itemType = WEAPON, rarity = 2, minItemLevel = 26, maxItemLevel = 45, amountOfMats = 1.302},
				{itemType = WEAPON, rarity = 3, minItemLevel = 26, maxItemLevel = 45, amountOfMats = 0.500},
			},
		},
		["i:16203"] = { -- Greater Eternal Essence
			minLevel = 46,
			maxLevel = 60,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 46, maxItemLevel = 58, amountOfMats = 0.346},
				{itemType = ARMOR, rarity = 3, minItemLevel = 46, maxItemLevel = 58, amountOfMats = 0.550},
				{itemType = ARMOR, rarity = 4, minItemLevel = 58, maxItemLevel = 65, amountOfMats = 2.800},
				{itemType = WEAPON, rarity = 2, minItemLevel = 46, maxItemLevel = 58, amountOfMats = 1.182},
				{itemType = WEAPON, rarity = 3, minItemLevel = 46, maxItemLevel = 58, amountOfMats = 0.550},
				{itemType = WEAPON, rarity = 4, minItemLevel = 58, maxItemLevel = 65, amountOfMats = 2.800},
			},
		},
		["i:22447"] = { -- Lesser Planar Essence
			minLevel = 58,
			maxLevel = 70,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 59, maxItemLevel = 70, amountOfMats = 0.562},
				{itemType = WEAPON, rarity = 2, minItemLevel = 59, maxItemLevel = 70, amountOfMats = 1.932},
			},
		},
		["i:22446"] = { -- Greater Planar Essence
			minLevel = 58,
			maxLevel = 70,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 71, maxItemLevel = 80, amountOfMats = 0.339},
				{itemType = WEAPON, rarity = 2, minItemLevel = 71, maxItemLevel = 80, amountOfMats = 1.157},
			},
		},
		["i:34056"] = { -- Lesser Cosmic Essence
			minLevel = 67,
			maxLevel = 80,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 80, maxItemLevel = 90, amountOfMats = 0.562},
				{itemType = WEAPON, rarity = 2, minItemLevel = 80, maxItemLevel = 90, amountOfMats = 1.932},
			},
		},
		["i:34055"] = { -- Greater Cosmic Essence
			minLevel = 67,
			maxLevel = 80,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 91, maxItemLevel = 100, amountOfMats = 0.339},
				{itemType = WEAPON, rarity = 2, minItemLevel = 91, maxItemLevel = 100, amountOfMats = 1.157},
			},
		},
		["i:52718"] = { -- Lesser Celestial Essence
			minLevel = 77,
			maxLevel = 85,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 101, maxItemLevel = 103, amountOfMats = 0.562},
				{itemType = WEAPON, rarity = 2, minItemLevel = 101, maxItemLevel = 103, amountOfMats = 1.932},
			},
		},
		["i:52719"] = { -- Greater Celestial Essence
			minLevel = 77,
			maxLevel = 85,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 104, maxItemLevel = 108, amountOfMats = 0.339},
				{itemType = WEAPON, rarity = 2, minItemLevel = 104, maxItemLevel = 108, amountOfMats = 1.157},
			},
		},
		["i:74250"] = { -- Mysterious Essence
			minLevel = 83,
			maxLevel = 88,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 108, maxItemLevel = 111, amountOfMats = 0.178},
				{itemType = ARMOR, rarity = 2, minItemLevel = 112, maxItemLevel = 113, amountOfMats = 0.244},
				{itemType = ARMOR, rarity = 2, minItemLevel = 114, maxItemLevel = 115, amountOfMats = 0.244},
				{itemType = WEAPON, rarity = 2, minItemLevel = 108, maxItemLevel = 111, amountOfMats = 0.178},
				{itemType = WEAPON, rarity = 2, minItemLevel = 112, maxItemLevel = 113, amountOfMats = 0.244},
				{itemType = WEAPON, rarity = 2, minItemLevel = 114, maxItemLevel = 115, amountOfMats = 0.333},
			},
		},
	},
	{
		desc = L["Shards"],
		["i:14343"] = { -- Small Brilliant Shard
			minLevel = 46,
			maxLevel = 50,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 26, maxItemLevel = 45, amountOfMats = 0.033},
				{itemType = ARMOR, rarity = 3, minItemLevel = 26, maxItemLevel = 45, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 2, minItemLevel = 26, maxItemLevel = 45, amountOfMats = 0.033},
				{itemType = WEAPON, rarity = 3, minItemLevel = 26, maxItemLevel = 45, amountOfMats = 1.000},
			},
		},
		["i:14344"] = { -- Large Brilliant Shard
			minLevel = 56,
			maxLevel = 75,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 46, maxItemLevel = 58, amountOfMats = 0.033},
				{itemType = ARMOR, rarity = 3, minItemLevel = 46, maxItemLevel = 58, amountOfMats = 2.000},
				{itemType = ARMOR, rarity = 4, minItemLevel = 46, maxItemLevel = 65, amountOfMats = 3.500},
				{itemType = WEAPON, rarity = 2, minItemLevel = 46, maxItemLevel = 58, amountOfMats = 0.033},
				{itemType = WEAPON, rarity = 3, minItemLevel = 46, maxItemLevel = 58, amountOfMats = 2.000},
				{itemType = WEAPON, rarity = 4, minItemLevel = 46, maxItemLevel = 65, amountOfMats = 3.500},
			},
		},
		["i:22448"] = { -- Small Prismatic Shard
			minLevel = 56,
			maxLevel = 70,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 59, maxItemLevel = 70, amountOfMats = 0.033},
				{itemType = ARMOR, rarity = 3, minItemLevel = 59, maxItemLevel = 70, amountOfMats = 1.030},
				{itemType = WEAPON, rarity = 2, minItemLevel = 59, maxItemLevel = 70, amountOfMats = 0.033},
				{itemType = WEAPON, rarity = 3, minItemLevel = 59, maxItemLevel = 70, amountOfMats = 1.030},
			},
		},
		["i:22449"] = { -- Large Prismatic Shard
			minLevel = 56,
			maxLevel = 70,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 71, maxItemLevel = 80, amountOfMats = 0.033},
				{itemType = ARMOR, rarity = 3, minItemLevel = 71, maxItemLevel = 80, amountOfMats = 1.03},
				{itemType = WEAPON, rarity = 2, minItemLevel = 71, maxItemLevel = 80, amountOfMats = 0.033},
				{itemType = WEAPON, rarity = 3, minItemLevel = 71, maxItemLevel = 80, amountOfMats = 1.03},
			},
		},
		["i:34053"] = { -- Small Dream Shard
			minLevel = 68,
			maxLevel = 80,
			sourceInfo = {
				{itemType = ARMOR, rarity = 2, minItemLevel = 80, maxItemLevel = 90, amountOfMats = 0.033},
				{itemType = ARMOR, rarity = 3, minItemLevel = 80, maxItemLevel = 90, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 2, minItemLevel = 80, maxItemLevel = 90, amountOfMats = 0.033},
				{itemType = WEAPON, rarity = 3, minItemLevel = 80, maxItemLevel = 90, amountOfMats = 1.000},
			},
		},
		["i:34052"] = { -- Dream Shard
			minLevel = 68,
			maxLevel = 80,
			sourceInfo = {
				{itemType = ARMOR, rarity = 3, minItemLevel = 91, maxItemLevel = 100, amountOfMats = 0.033},
				{itemType = ARMOR, rarity = 3, minItemLevel = 91, maxItemLevel = 100, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 3, minItemLevel = 91, maxItemLevel = 100, amountOfMats = 0.033},
				{itemType = WEAPON, rarity = 3, minItemLevel = 91, maxItemLevel = 100, amountOfMats = 1.000},
			},
		},
		["i:52720"] = { -- Small Heavenly Shard
			minLevel = 78,
			maxLevel = 85,
			sourceInfo = {
				{itemType = ARMOR, rarity = 3, minItemLevel = 100, maxItemLevel = 106, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 3, minItemLevel = 100, maxItemLevel = 106, amountOfMats = 1.000},
			},
		},
		["i:52721"] = { -- Heavenly Shard
			minLevel = 78,
			maxLevel = 85,
			sourceInfo = {
				{itemType = ARMOR, rarity = 3, minItemLevel = 107, maxItemLevel = 108, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 3, minItemLevel = 107, maxItemLevel = 108, amountOfMats = 1.000},
			},
		},
		["i:74252"] = { --Small Ethereal Shard
			minLevel = 85,
			maxLevel = 90,
			sourceInfo = {
				{itemType = ARMOR, rarity = 3, minItemLevel = 110, maxItemLevel = 115, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 3, minItemLevel = 110, maxItemLevel = 115, amountOfMats = 1.000},
			},
		},
		["i:74247"] = { -- Ethereal Shard
			minLevel = 85,
			maxLevel = 90,
			sourceInfo = {
				{itemType = ARMOR, rarity = 3, minItemLevel = 110, maxItemLevel = 115, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 3, minItemLevel = 110, maxItemLevel = 115, amountOfMats = 1.000},
			},
		},
		["i:111245"] = { -- Luminous Shard
			minLevel = 90,
			maxLevel = 100,
			sourceInfo = {
				{itemType = ARMOR, rarity = 3, minItemLevel = 130, maxItemLevel = 138, amountOfMats = 0.100},
				{itemType = WEAPON, rarity = 3, minItemLevel = 130, maxItemLevel = 138, amountOfMats = 0.100},
			},
		},
		["i:124441"] = { -- Leylight Shard
			minLevel = 101,
			maxLevel = 110,
			sourceInfo = {
				{itemType = ARMOR, rarity = 3, minItemLevel = 138, maxItemLevel = 180, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 3, minItemLevel = 138, maxItemLevel = 180, amountOfMats = 1.000},
			},
		},
		["i:152876"] = { -- Umbra Shard
			minLevel = 111,
			maxLevel = 120,
			sourceInfo = {
				{itemType = ARMOR, rarity = 3, minItemLevel = 182, maxItemLevel = 999, amountOfMats = 1.500},
				{itemType = ARMOR, rarity = 4, minItemLevel = 300, maxItemLevel = 999, amountOfMats = 1.200},
				{itemType = WEAPON, rarity = 3, minItemLevel = 182, maxItemLevel = 999, amountOfMats = 1.500},
				{itemType = WEAPON, rarity = 4, minItemLevel = 300, maxItemLevel = 999, amountOfMats = 1.200},
			},
		},
	},
	{
		desc = L["Crystals"],
		["i:22450"] = { -- Void Crystal
			minLevel = 70,
			maxLevel = 70,
			sourceInfo = {
				{itemType = ARMOR, rarity = 4, minItemLevel = 73, maxItemLevel = 94, amountOfMats = 1.470},
				{itemType = WEAPON, rarity = 4, minItemLevel = 73, maxItemLevel = 94, amountOfMats = 1.470},
			},
		},
		["i:34057"] = { -- Abyss Crystal
			minLevel = 80,
			maxLevel = 80,
			sourceInfo = {
				{itemType = ARMOR, rarity = 4, minItemLevel = 100, maxItemLevel = 102, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 4, minItemLevel = 100, maxItemLevel = 102, amountOfMats = 1.000},
			},
		},
		["i:52722"] = { -- Maelstrom Crystal
			minLevel = 85,
			maxLevel = 85,
			sourceInfo = {
				{itemType = ARMOR, rarity = 4, minItemLevel = 108, maxItemLevel = 114, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 4, minItemLevel = 108, maxItemLevel = 114, amountOfMats = 1.000},
			},
		},
		["i:74248"] = { -- Sha Crystal
			minLevel = 85,
			maxLevel = 90,
			sourceInfo = {
				{itemType = ARMOR, rarity = 4, minItemLevel = 116, maxItemLevel = 130, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 4, minItemLevel = 116, maxItemLevel = 130, amountOfMats = 1.000},
			},
		},
		["i:115504"] = { -- Fractured Temporal Crystal
			minLevel = 90,
			maxLevel = 100,
			sourceInfo = {
				{itemType = ARMOR, rarity = 3, minItemLevel = 116, maxItemLevel = 138, amountOfMats = 0.300},
				{itemType = ARMOR, rarity = 4, minItemLevel = 132, maxItemLevel = 149, amountOfMats = 0.750},
				{itemType = WEAPON, rarity = 3, minItemLevel = 116, maxItemLevel = 138, amountOfMats = 0.150},
				{itemType = WEAPON, rarity = 4, minItemLevel = 132, maxItemLevel = 149, amountOfMats = 0.750},
			},
		},
		["i:113588"] = { -- Temporal Crystal
			minLevel = 90,
			maxLevel = 100,
			sourceInfo = {
				{itemType = ARMOR, rarity = 3, minItemLevel = 116, maxItemLevel = 138, amountOfMats = 0.050},
				{itemType = ARMOR, rarity = 4, minItemLevel = 132, maxItemLevel = 149, amountOfMats = 0.750},
				{itemType = WEAPON, rarity = 3, minItemLevel = 116, maxItemLevel = 138, amountOfMats = 0.050},
				{itemType = WEAPON, rarity = 4, minItemLevel = 132, maxItemLevel = 149, amountOfMats = 0.750},
			},
		},
		["i:124442"] = { -- Chaos Crystal
			minLevel = 101,
			maxLevel = 110,
			sourceInfo = {
				{itemType = ARMOR, rarity = 4, minItemLevel = 160, maxItemLevel = 265, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 4, minItemLevel = 160, maxItemLevel = 265, amountOfMats = 1.000},
			},
		},
		["i:152877"] = { -- Veiled Crystal
			minLevel = 111,
			maxLevel = 120,
			sourceInfo = {
				{itemType = ARMOR, rarity = 3, minItemLevel = 182, maxItemLevel = 999, amountOfMats = 0.050},
				{itemType = ARMOR, rarity = 4, minItemLevel = 300, maxItemLevel = 999, amountOfMats = 1.000},
				{itemType = WEAPON, rarity = 3, minItemLevel = 182, maxItemLevel = 999, amountOfMats = 0.050},
				{itemType = WEAPON, rarity = 4, minItemLevel = 300, maxItemLevel = 999, amountOfMats = 1.000},
			},
		},
	},
}
