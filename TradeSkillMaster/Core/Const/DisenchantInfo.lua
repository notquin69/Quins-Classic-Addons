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

if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
	TSM.CONST.DISENCHANT_INFO = {
		{
			desc = L["Dust"],
			["i:10940"] = { -- Strange Dust
				minLevel = 0,
				maxLevel = 20,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 5, maxItemLevel = 15, matRate = 0.800, minAmount = 1, maxAmount = 2, amountOfMats = 1.200},
					{itemType = ARMOR, rarity = 2, minItemLevel = 16, maxItemLevel = 20, matRate = 0.750, minAmount = 2, maxAmount = 3, amountOfMats = 1.850},
					{itemType = ARMOR, rarity = 2, minItemLevel = 21, maxItemLevel = 25, matRate = 0.750, minAmount = 4, maxAmount = 6, amountOfMats = 3.750},
					{itemType = WEAPON, rarity = 2, minItemLevel = 5, maxItemLevel = 15, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
					{itemType = WEAPON, rarity = 2, minItemLevel = 16, maxItemLevel = 20, matRate = 0.200, minAmount = 2, maxAmount = 3, amountOfMats = 0.500},
					{itemType = WEAPON, rarity = 2, minItemLevel = 21, maxItemLevel = 25, matRate = 0.150, minAmount = 4, maxAmount = 6, amountOfMats = 0.750},
				},
			},
			["i:11083"] = { -- Soul Dust
				minLevel = 21,
				maxLevel = 30,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 26, maxItemLevel = 30, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
					{itemType = ARMOR, rarity = 2, minItemLevel = 31, maxItemLevel = 35, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 2.550},
					{itemType = WEAPON, rarity = 2, minItemLevel = 26, maxItemLevel = 30, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
					{itemType = WEAPON, rarity = 2, minItemLevel = 31, maxItemLevel = 35, matRate = 0.200, minAmount = 2, maxAmount = 5, amountOfMats = 0.700},
				},
			},
			["i:11137"] = { -- Vision Dust
				minLevel = 31,
				maxLevel = 40,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 36, maxItemLevel = 40, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
					{itemType = ARMOR, rarity = 2, minItemLevel = 41, maxItemLevel = 45, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 2.550},
					{itemType = WEAPON, rarity = 2, minItemLevel = 36, maxItemLevel = 40, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
					{itemType = WEAPON, rarity = 2, minItemLevel = 41, maxItemLevel = 45, matRate = 0.200, minAmount = 2, maxAmount = 5, amountOfMats = 0.700},
				},
			},
			["i:11176"] = { -- Dream Dust
				minLevel = 41,
				maxLevel = 50,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 46, maxItemLevel = 50, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
					{itemType = ARMOR, rarity = 2, minItemLevel = 51, maxItemLevel = 55, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 2.550},
					{itemType = WEAPON, rarity = 2, minItemLevel = 46, maxItemLevel = 50, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
					{itemType = WEAPON, rarity = 2, minItemLevel = 51, maxItemLevel = 55, matRate = 0.200, minAmount = 2, maxAmount = 5, amountOfMats = 0.700},
				},
			},
			["i:16204"] = { -- Illusion Dust
				minLevel = 51,
				maxLevel = 60,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 56, maxItemLevel = 60, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
					{itemType = ARMOR, rarity = 2, minItemLevel = 61, maxItemLevel = 65, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 2.550},
					{itemType = WEAPON, rarity = 2, minItemLevel = 56, maxItemLevel = 60, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
					{itemType = WEAPON, rarity = 2, minItemLevel = 61, maxItemLevel = 65, matRate = 0.200, minAmount = 2, maxAmount = 5, amountOfMats = 0.700},
				},
			},
		},
		{
			desc = L["Essences"],
			["i:10938"] = { -- Lesser Magic Essence
				minLevel = 0,
				maxLevel = 10,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 5, maxItemLevel = 15, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
					{itemType = WEAPON, rarity = 2, minItemLevel = 5, maxItemLevel = 15, matRate = 0.800, minAmount = 1, maxAmount = 2, amountOfMats = 1.200},
				},
			},
			["i:10939"] = { -- Greater Magic Essence
				minLevel = 11,
				maxLevel = 15,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 16, maxItemLevel = 20, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
					{itemType = WEAPON, rarity = 2, minItemLevel = 16, maxItemLevel = 20, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				},
			},
			["i:10998"] = { -- Lesser Astral Essence
				minLevel = 16,
				maxLevel = 20,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 21, maxItemLevel = 25, matRate = 0.150, minAmount = 1, maxAmount = 2, amountOfMats = 0.200},
					{itemType = WEAPON, rarity = 2, minItemLevel = 21, maxItemLevel = 25, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				},
			},
			["i:11082"] = { -- Greater Astral Essence
				minLevel = 21,
				maxLevel = 25,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 26, maxItemLevel = 30, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
					{itemType = WEAPON, rarity = 2, minItemLevel = 26, maxItemLevel = 30, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				},
			},
			["i:11134"] = { -- Lesser Mystic Essence
				minLevel = 26,
				maxLevel = 30,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 31, maxItemLevel = 35, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
					{itemType = WEAPON, rarity = 2, minItemLevel = 31, maxItemLevel = 35, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				},
			},
			["i:11135"] = { -- Greater Mystic Essence
				minLevel = 31,
				maxLevel = 35,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 36, maxItemLevel = 40, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
					{itemType = WEAPON, rarity = 2, minItemLevel = 36, maxItemLevel = 40, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				},
			},
			["i:11174"] = { -- Lesser Nether Essence
				minLevel = 36,
				maxLevel = 40,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 41, maxItemLevel = 45, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
					{itemType = WEAPON, rarity = 2, minItemLevel = 41, maxItemLevel = 45, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				},
			},
			["i:11175"] = { -- Greater Nether Essence
				minLevel = 41,
				maxLevel = 45,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 46, maxItemLevel = 50, matRate = 0.250, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
					{itemType = WEAPON, rarity = 2, minItemLevel = 46, maxItemLevel = 50, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				},
			},
			["i:16202"] = { -- Lesser Eternal Essence
				minLevel = 46,
				maxLevel = 50,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 51, maxItemLevel = 55, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
					{itemType = WEAPON, rarity = 2, minItemLevel = 51, maxItemLevel = 55, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
				},
			},
			["i:16203"] = { -- Greater Eternal Essence
				minLevel = 51,
				maxLevel = 60,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 56, maxItemLevel = 60, matRate = 0.200, minAmount = 1, maxAmount = 2, amountOfMats = 0.300},
					{itemType = ARMOR, rarity = 2, minItemLevel = 61, maxItemLevel = 65, matRate = 0.200, minAmount = 2, maxAmount = 3, amountOfMats = 0.990},
					{itemType = WEAPON, rarity = 2, minItemLevel = 56, maxItemLevel = 60, matRate = 0.750, minAmount = 1, maxAmount = 2, amountOfMats = 1.100},
					{itemType = WEAPON, rarity = 2, minItemLevel = 61, maxItemLevel = 65, matRate = 0.750, minAmount = 2, maxAmount = 3, amountOfMats = 1.850},
				},
			},
		},
		{
			desc = L["Shards"],
			["i:10978"] = { -- Small Glimmering Shard
				minLevel = 0,
				maxLevel = 20,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 16, maxItemLevel = 20, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = ARMOR, rarity = 2, minItemLevel = 21, maxItemLevel = 25, matRate = 0.100, minAmount = 1, maxAmount = 1, amountOfMats = 0.100},
					{itemType = ARMOR, rarity = 3, minItemLevel = 11, maxItemLevel = 25, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 2, minItemLevel = 16, maxItemLevel = 20, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = WEAPON, rarity = 2, minItemLevel = 21, maxItemLevel = 25, matRate = 0.100, minAmount = 1, maxAmount = 1, amountOfMats = 0.100},
					{itemType = WEAPON, rarity = 3, minItemLevel = 11, maxItemLevel = 25, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				},
			},
			["i:11084"] = { -- Large Glimmering Shard
				minLevel = 21,
				maxLevel = 25,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 26, maxItemLevel = 30, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = ARMOR, rarity = 3, minItemLevel = 26, maxItemLevel = 30, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 2, minItemLevel = 26, maxItemLevel = 30, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = WEAPON, rarity = 3, minItemLevel = 26, maxItemLevel = 30, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				},
			},
			["i:11138"] = { -- Small Glowing Shard
				minLevel = 26,
				maxLevel = 30,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 31, maxItemLevel = 35, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = ARMOR, rarity = 3, minItemLevel = 31, maxItemLevel = 35, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 2, minItemLevel = 31, maxItemLevel = 35, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = WEAPON, rarity = 3, minItemLevel = 31, maxItemLevel = 35, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				},
			},
			["i:11139"] = { -- Large Glowing Shard
				minLevel = 31,
				maxLevel = 35,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 36, maxItemLevel = 40, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = ARMOR, rarity = 3, minItemLevel = 36, maxItemLevel = 40, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 2, minItemLevel = 36, maxItemLevel = 40, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = WEAPON, rarity = 3, minItemLevel = 36, maxItemLevel = 40, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				},
			},
			["i:11177"] = { -- Small Radiant Shard
				minLevel = 36,
				maxLevel = 40,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 41, maxItemLevel = 45, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = ARMOR, rarity = 3, minItemLevel = 41, maxItemLevel = 45, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = ARMOR, rarity = 4, minItemLevel = 40, maxItemLevel = 45, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
					{itemType = WEAPON, rarity = 2, minItemLevel = 41, maxItemLevel = 45, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = WEAPON, rarity = 3, minItemLevel = 41, maxItemLevel = 45, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 4, minItemLevel = 40, maxItemLevel = 45, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
				},
			},
			["i:11178"] = { -- Large Radiant Shard
				minLevel = 41,
				maxLevel = 45,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 46, maxItemLevel = 50, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = ARMOR, rarity = 3, minItemLevel = 46, maxItemLevel = 50, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = ARMOR, rarity = 4, minItemLevel = 46, maxItemLevel = 50, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
					{itemType = WEAPON, rarity = 2, minItemLevel = 46, maxItemLevel = 50, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = WEAPON, rarity = 3, minItemLevel = 46, maxItemLevel = 50, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 4, minItemLevel = 46, maxItemLevel = 50, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
				},
			},
			["i:14343"] = { -- Small Brilliant Shard
				minLevel = 46,
				maxLevel = 50,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 51, maxItemLevel = 55, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.030},
					{itemType = ARMOR, rarity = 3, minItemLevel = 51, maxItemLevel = 55, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = ARMOR, rarity = 4, minItemLevel = 51, maxItemLevel = 55, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
					{itemType = WEAPON, rarity = 2, minItemLevel = 51, maxItemLevel = 55, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.030},
					{itemType = WEAPON, rarity = 3, minItemLevel = 51, maxItemLevel = 55, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 4, minItemLevel = 51, maxItemLevel = 55, matRate = 1.000, minAmount = 2, maxAmount = 4, amountOfMats = 3.000},
				},
			},
			["i:14344"] = { -- Large Brilliant Shard
				minLevel = 51,
				maxLevel = 60,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 56, maxItemLevel = 65, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = ARMOR, rarity = 3, minItemLevel = 56, maxItemLevel = 65, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 0.995},
					{itemType = WEAPON, rarity = 2, minItemLevel = 56, maxItemLevel = 65, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = WEAPON, rarity = 3, minItemLevel = 56, maxItemLevel = 65, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 0.995},
				},
			},
		},
		{
			desc = L["Crystals"],
			["i:20725"] = { -- Nexus Crystal
				minLevel = 51,
				maxLevel = 60,
				sourceInfo = {
					{itemType = ARMOR, rarity = 3, minItemLevel = 56, maxItemLevel = 65, matRate = 0.005, minAmount = 1, maxAmount = 1, amountOfMats = 0.005},
					{itemType = ARMOR, rarity = 4, minItemLevel = 56, maxItemLevel = 60, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = ARMOR, rarity = 4, minItemLevel = 61, maxItemLevel = 95, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.666},
					{itemType = WEAPON, rarity = 3, minItemLevel = 56, maxItemLevel = 65, matRate = 0.005, minAmount = 1, maxAmount = 1, amountOfMats = 0.005},
					{itemType = WEAPON, rarity = 4, minItemLevel = 56, maxItemLevel = 60, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 4, minItemLevel = 61, maxItemLevel = 95, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.666},
				},
			},
		},
	}
else
	TSM.CONST.DISENCHANT_INFO = {
		{
			desc = L["Dust"],
			["i:10940"] = { -- Strange Dust
				minLevel = 0,
				maxLevel = 27,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 5, maxItemLevel = 15, matRate = 0.800, minAmount = 1, maxAmount = 6, amountOfMats = 1.222},
					{itemType = ARMOR, rarity = 2, minItemLevel = 16, maxItemLevel = 20, matRate = 0.800, minAmount = 2, maxAmount = 8, amountOfMats = 2.025},
					{itemType = ARMOR, rarity = 2, minItemLevel = 21, maxItemLevel = 25, matRate = 1.000, minAmount = 4, maxAmount = 10, amountOfMats = 5.008},
					{itemType = ARMOR, rarity = 3, minItemLevel = 16, maxItemLevel = 25, matRate = 0.030, minAmount = 3, maxAmount = 6, amountOfMats = 0.127},
					{itemType = WEAPON, rarity = 2, minItemLevel = 5, maxItemLevel = 15, matRate = 0.200, minAmount = 1, maxAmount = 4, amountOfMats = 0.302},
					{itemType = WEAPON, rarity = 2, minItemLevel = 16, maxItemLevel = 20, matRate = 0.200, minAmount = 2, maxAmount = 6, amountOfMats = 0.507},
					{itemType = WEAPON, rarity = 2, minItemLevel = 21, maxItemLevel = 25, matRate = 0.150, minAmount = 4, maxAmount = 8, amountOfMats = 0.753},
					{itemType = WEAPON, rarity = 3, minItemLevel = 16, maxItemLevel = 25, matRate = 0.030, minAmount = 3, maxAmount = 6, amountOfMats = 0.127},
				},
			},
			["i:16204"] = { -- Light Illusion Dust
				minLevel = 25,
				maxLevel = 50,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 26, maxItemLevel = 45, matRate = 0.750, minAmount = 1, maxAmount = 6, amountOfMats = 1.155},
					{itemType = ARMOR, rarity = 3, minItemLevel = 26, maxItemLevel = 45, matRate = 0.030, minAmount = 3, maxAmount = 6, amountOfMats = 0.127},
					{itemType = WEAPON, rarity = 2, minItemLevel = 26, maxItemLevel = 45, matRate = 0.220, minAmount = 1, maxAmount = 5, amountOfMats = 0.344},
					{itemType = WEAPON, rarity = 3, minItemLevel = 26, maxItemLevel = 45, matRate = 0.030, minAmount = 3, maxAmount = 6, amountOfMats = 0.127},
				},
			},
			["i:156930"] = { -- Rich Illusion Dust
				minLevel = 45,
				maxLevel = 60,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 46, maxItemLevel = 58, matRate = 0.750, minAmount = 1, maxAmount = 6, amountOfMats = 1.155},
					{itemType = ARMOR, rarity = 3, minItemLevel = 46, maxItemLevel = 58, matRate = 0.030, minAmount = 3, maxAmount = 6, amountOfMats = 0.127},
					{itemType = ARMOR, rarity = 4, minItemLevel = 58, maxItemLevel = 65, matRate = 0.200, minAmount = 3, maxAmount = 6, amountOfMats = 0.900},
					{itemType = WEAPON, rarity = 2, minItemLevel = 46, maxItemLevel = 58, matRate = 0.220, minAmount = 1, maxAmount = 6, amountOfMats = 0.344},
					{itemType = WEAPON, rarity = 3, minItemLevel = 46, maxItemLevel = 58, matRate = 0.030, minAmount = 3, maxAmount = 6, amountOfMats = 0.127},
					{itemType = WEAPON, rarity = 4, minItemLevel = 58, maxItemLevel = 65, matRate = 0.200, minAmount = 3, maxAmount = 6, amountOfMats = 0.900},
				},
			},
			["i:22445"] = { -- Arcane Dust
				minLevel = 57,
				maxLevel = 70,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 59, maxItemLevel = 70, matRate = 0.750, minAmount = 2, maxAmount = 7, amountOfMats = 1.933},
					{itemType = ARMOR, rarity = 2, minItemLevel = 71, maxItemLevel = 80, matRate = 0.750, minAmount = 2, maxAmount = 9, amountOfMats = 2.655},
					{itemType = WEAPON, rarity = 2, minItemLevel = 80, maxItemLevel = 99, matRate = 0.220, minAmount = 2, maxAmount = 5, amountOfMats = 0.750},
					{itemType = WEAPON, rarity = 2, minItemLevel = 71, maxItemLevel = 80, matRate = 0.220, minAmount = 2, maxAmount = 7, amountOfMats = 0.787},
				},
			},
			["i:34054"] = { -- Infinite Dust
				minLevel = 67,
				maxLevel = 80,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 80, maxItemLevel = 90, matRate = 0.750, minAmount = 2, maxAmount = 7, amountOfMats = 1.933},
					{itemType = ARMOR, rarity = 2, minItemLevel = 91, maxItemLevel = 100, matRate = 0.750, minAmount = 4, maxAmount = 11, amountOfMats = 4.155},
					{itemType = WEAPON, rarity = 2, minItemLevel = 80, maxItemLevel = 90, matRate = 0.220, minAmount = 2, maxAmount = 5, amountOfMats = 0.562},
					{itemType = WEAPON, rarity = 2, minItemLevel = 91, maxItemLevel = 100, matRate = 0.220, minAmount = 4, maxAmount = 9, amountOfMats = 1.200},
				},
			},
			["i:52555"] = { -- Hypnotic Dust
				minLevel = 77,
				maxLevel = 85,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 101, maxItemLevel = 103, matRate = 0.750, minAmount = 1, maxAmount = 8, amountOfMats = 1.556},
					{itemType = ARMOR, rarity = 2, minItemLevel = 104, maxItemLevel = 106, matRate = 0.750, minAmount = 1, maxAmount = 9, amountOfMats = 2.304},
					{itemType = ARMOR, rarity = 2, minItemLevel = 107, maxItemLevel = 108, matRate = 0.750, minAmount = 1, maxAmount = 10, amountOfMats = 2.628},
					{itemType = WEAPON, rarity = 2, minItemLevel = 101, maxItemLevel = 103, matRate = 0.220, minAmount = 1, maxAmount = 6, amountOfMats = 0.450},
					{itemType = WEAPON, rarity = 2, minItemLevel = 104, maxItemLevel = 106, matRate = 0.220, minAmount = 1, maxAmount = 9, amountOfMats = 0.677},
					{itemType = WEAPON, rarity = 2, minItemLevel = 107, maxItemLevel = 108, matRate = 0.220, minAmount = 1, maxAmount = 10, amountOfMats = 0.774},
				},
			},
			["i:74249"] = { -- Spirit Dust
				minLevel = 83,
				maxLevel = 88,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 108, maxItemLevel = 109, matRate = 0.850, minAmount = 1, maxAmount = 9, amountOfMats = 2.285},
					{itemType = ARMOR, rarity = 2, minItemLevel = 110, maxItemLevel = 113, matRate = 0.850, minAmount = 2, maxAmount = 9, amountOfMats = 2.710},
					{itemType = ARMOR, rarity = 2, minItemLevel = 114, maxItemLevel = 115, matRate = 0.850, minAmount = 2, maxAmount = 10, amountOfMats = 3.135},
					{itemType = WEAPON, rarity = 2, minItemLevel = 108, maxItemLevel = 109, matRate = 0.850, minAmount = 1, maxAmount = 8, amountOfMats = 2.245},
					{itemType = WEAPON, rarity = 2, minItemLevel = 110, maxItemLevel = 113, matRate = 0.850, minAmount = 2, maxAmount = 8, amountOfMats = 2.700},
					{itemType = WEAPON, rarity = 2, minItemLevel = 114, maxItemLevel = 115, matRate = 0.850, minAmount = 3, maxAmount = 10, amountOfMats = 3.560},
				},
			},
			["i:109693"] = { -- Draenic Dust
				minLevel = 90,
				maxLevel = 100,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 116, maxItemLevel = 136, matRate = 1.000, minAmount = 1, maxAmount = 4, amountOfMats = 2.600},
					{itemType = ARMOR, rarity = 3, minItemLevel = 116, maxItemLevel = 138, matRate = 0.750, minAmount = 5, maxAmount = 12, amountOfMats = 5.810},
					{itemType = WEAPON, rarity = 2, minItemLevel = 116, maxItemLevel = 136, matRate = 1.000, minAmount = 1, maxAmount = 4, amountOfMats = 2.600},
					{itemType = WEAPON, rarity = 3, minItemLevel = 116, maxItemLevel = 138, matRate = 0.800, minAmount = 5, maxAmount = 12, amountOfMats = 6.220},
				},
			},
			["i:124440"] = { -- Arkhana
				minLevel = 101,
				maxLevel = 110,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 138, maxItemLevel = 170, matRate = 1.000, minAmount = 4, maxAmount = 6, amountOfMats = 4.750},
					{itemType = WEAPON, rarity = 2, minItemLevel = 138, maxItemLevel = 170, matRate = 1.000, minAmount = 4, maxAmount = 6, amountOfMats = 4.750},
				},
			},
			["i:152875"] = { -- Gloom Dust
				minLevel = 111,
				maxLevel = 120,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 172, maxItemLevel = 225, matRate = 1.000, minAmount = 1, maxAmount = 6, amountOfMats = 4.130},
					{itemType = ARMOR, rarity = 2, minItemLevel = 226, maxItemLevel = 310, matRate = 1.000, minAmount = 4, maxAmount = 6, amountOfMats = 5.000},
					{itemType = ARMOR, rarity = 3, minItemLevel = 182, maxItemLevel = 999, matRate = 0.950, minAmount = 1, maxAmount = 2, amountOfMats = 1.425},
					{itemType = ARMOR, rarity = 4, minItemLevel = 300, maxItemLevel = 999, matRate = 0.200, minAmount = 4, maxAmount = 6, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 2, minItemLevel = 172, maxItemLevel = 225, matRate = 1.000, minAmount = 1, maxAmount = 6, amountOfMats = 4.130},
					{itemType = WEAPON, rarity = 2, minItemLevel = 226, maxItemLevel = 310, matRate = 1.000, minAmount = 4, maxAmount = 6, amountOfMats = 5.000},
					{itemType = WEAPON, rarity = 3, minItemLevel = 182, maxItemLevel = 999, matRate = 1.950, minAmount = 1, maxAmount = 2, amountOfMats = 1.425},
					{itemType = WEAPON, rarity = 4, minItemLevel = 300, maxItemLevel = 999, matRate = 1.200, minAmount = 4, maxAmount = 6, amountOfMats = 1.000},
				},
			},
		},
		{
			desc = L["Essences"],
			["i:10938"] = { -- Lesser Magic Essence
				minLevel = 0,
				maxLevel = 15,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 5, maxItemLevel = 15, matRate = 0.200, minAmount = 1, maxAmount = 6, amountOfMats = 0.303},
					{itemType = WEAPON, rarity = 2, minItemLevel = 5, maxItemLevel = 15, matRate = 0.800, minAmount = 1, maxAmount = 5, amountOfMats = 1.218},
				},
			},
			["i:10939"] = { -- Greater Magic Essence
				minLevel = 16,
				maxLevel = 25,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 16, maxItemLevel = 25, matRate = 0.200, minAmount = 1, maxAmount = 5, amountOfMats = 0.307},
					{itemType = ARMOR, rarity = 3, minItemLevel = 16, maxItemLevel = 25, matRate = 1.000, minAmount = 2, maxAmount = 2, amountOfMats = 2.000},
					{itemType = WEAPON, rarity = 2, minItemLevel = 16, maxItemLevel = 25, matRate = 0.200, minAmount = 1, maxAmount = 4, amountOfMats = 1.217},
					{itemType = WEAPON, rarity = 3, minItemLevel = 16, maxItemLevel = 25, matRate = 1.000, minAmount = 2, maxAmount = 2, amountOfMats = 2.000},
				},
			},
			["i:16202"] = { -- Lesser Eternal Essence
				minLevel = 26,
				maxLevel = 45,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 26, maxItemLevel = 45, matRate = 0.220, minAmount = 1, maxAmount = 5, amountOfMats = 0.346},
					{itemType = ARMOR, rarity = 3, minItemLevel = 26, maxItemLevel = 45, matRate = 0.220, minAmount = 1, maxAmount = 3, amountOfMats = 0.750},
					{itemType = WEAPON, rarity = 2, minItemLevel = 26, maxItemLevel = 45, matRate = 0.750, minAmount = 1, maxAmount = 4, amountOfMats = 1.302},
					{itemType = WEAPON, rarity = 3, minItemLevel = 26, maxItemLevel = 45, matRate = 1.000, minAmount = 1, maxAmount = 3, amountOfMats = 0.750},
				},
			},
			["i:16203"] = { -- Greater Eternal Essence
				minLevel = 46,
				maxLevel = 60,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 46, maxItemLevel = 58, matRate = 0.220, minAmount = 1, maxAmount = 5, amountOfMats = 0.346},
					{itemType = ARMOR, rarity = 3, minItemLevel = 46, maxItemLevel = 58, matRate = 0.220, minAmount = 1, maxAmount = 5, amountOfMats = 0.650},
					{itemType = ARMOR, rarity = 4, minItemLevel = 58, maxItemLevel = 65, matRate = 0.800, minAmount = 2, maxAmount = 5, amountOfMats = 2.800},
					{itemType = WEAPON, rarity = 2, minItemLevel = 46, maxItemLevel = 58, matRate = 0.750, minAmount = 1, maxAmount = 5, amountOfMats = 1.182},
					{itemType = WEAPON, rarity = 3, minItemLevel = 46, maxItemLevel = 58, matRate = 0.220, minAmount = 1, maxAmount = 5, amountOfMats = 0.650},
					{itemType = WEAPON, rarity = 4, minItemLevel = 58, maxItemLevel = 65, matRate = 0.800, minAmount = 2, maxAmount = 5, amountOfMats = 2.800},
				},
			},
			["i:22447"] = { -- Lesser Planar Essence
				minLevel = 58,
				maxLevel = 70,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 59, maxItemLevel = 70, matRate = 0.220, minAmount = 2, maxAmount = 5, amountOfMats = 0.562},
					{itemType = WEAPON, rarity = 2, minItemLevel = 59, maxItemLevel = 70, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 1.932},
				},
			},
			["i:22446"] = { -- Greater Planar Essence
				minLevel = 58,
				maxLevel = 70,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 71, maxItemLevel = 80, matRate = 0.220, minAmount = 1, maxAmount = 5, amountOfMats = 0.346},
					{itemType = WEAPON, rarity = 2, minItemLevel = 71, maxItemLevel = 80, matRate = 0.750, minAmount = 1, maxAmount = 5, amountOfMats = 1.170},
				},
			},
			["i:34056"] = { -- Lesser Cosmic Essence
				minLevel = 67,
				maxLevel = 80,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 80, maxItemLevel = 90, matRate = 0.220, minAmount = 2, maxAmount = 5, amountOfMats = 0.562},
					{itemType = WEAPON, rarity = 2, minItemLevel = 80, maxItemLevel = 90, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 1.932},
				},
			},
			["i:34055"] = { -- Greater Cosmic Essence
				minLevel = 67,
				maxLevel = 80,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 91, maxItemLevel = 100, matRate = 0.220, minAmount = 1, maxAmount = 5, amountOfMats = 0.346},
					{itemType = WEAPON, rarity = 2, minItemLevel = 91, maxItemLevel = 100, matRate = 0.750, minAmount = 1, maxAmount = 5, amountOfMats = 1.170},
				},
			},
			["i:52718"] = { -- Lesser Celestial Essence
				minLevel = 77,
				maxLevel = 85,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 101, maxItemLevel = 103, matRate = 0.220, minAmount = 2, maxAmount = 5, amountOfMats = 0.562},
					{itemType = WEAPON, rarity = 2, minItemLevel = 101, maxItemLevel = 103, matRate = 0.750, minAmount = 2, maxAmount = 5, amountOfMats = 1.932},
				},
			},
			["i:52719"] = { -- Greater Celestial Essence
				minLevel = 77,
				maxLevel = 85,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 104, maxItemLevel = 108, matRate = 0.220, minAmount = 1, maxAmount = 5, amountOfMats = 0.346},
					{itemType = WEAPON, rarity = 2, minItemLevel = 104, maxItemLevel = 108, matRate = 0.750, minAmount = 1, maxAmount = 5, amountOfMats = 1.157},
				},
			},
			["i:74250"] = { -- Mysterious Essence
				minLevel = 83,
				maxLevel = 88,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 108, maxItemLevel = 111, matRate = 0.150, minAmount = 1, maxAmount = 6, amountOfMats = 0.178},
					{itemType = ARMOR, rarity = 2, minItemLevel = 112, maxItemLevel = 113, matRate = 0.150, minAmount = 1, maxAmount = 6, amountOfMats = 0.244},
					{itemType = ARMOR, rarity = 2, minItemLevel = 114, maxItemLevel = 115, matRate = 0.150, minAmount = 1, maxAmount = 6, amountOfMats = 0.244},
					{itemType = WEAPON, rarity = 2, minItemLevel = 108, maxItemLevel = 111, matRate = 0.150, minAmount = 1, maxAmount = 6, amountOfMats = 0.178},
					{itemType = WEAPON, rarity = 2, minItemLevel = 112, maxItemLevel = 113, matRate = 0.150, minAmount = 1, maxAmount = 6, amountOfMats = 0.244},
					{itemType = WEAPON, rarity = 2, minItemLevel = 114, maxItemLevel = 115, matRate = 0.150, minAmount = 1, maxAmount = 6, amountOfMats = 0.333},
				},
			},
		},
		{
			desc = L["Shards"],
			["i:14343"] = { -- Small Brilliant Shard
				minLevel = 26,
				maxLevel = 50,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 26, maxItemLevel = 45, matRate = 0.050, minAmount = 1, maxAmount = 2, amountOfMats = 0.050},
					{itemType = ARMOR, rarity = 3, minItemLevel = 26, maxItemLevel = 45, matRate = 1.000, minAmount = 1, maxAmount = 3, amountOfMats = 2.000},
					{itemType = WEAPON, rarity = 2, minItemLevel = 26, maxItemLevel = 45, matRate = 0.050, minAmount = 1, maxAmount = 2, amountOfMats = 0.050},
					{itemType = WEAPON, rarity = 3, minItemLevel = 26, maxItemLevel = 45, matRate = 1.000, minAmount = 1, maxAmount = 3, amountOfMats = 2.000},
				},
			},
			["i:14344"] = { -- Large Brilliant Shard
				minLevel = 46,
				maxLevel = 60,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 46, maxItemLevel = 58, matRate = 0.050, minAmount = 1, maxAmount = 2, amountOfMats = 0.050},
					{itemType = ARMOR, rarity = 3, minItemLevel = 46, maxItemLevel = 58, matRate = 1.000, minAmount = 1, maxAmount = 3, amountOfMats = 2.000},
					{itemType = ARMOR, rarity = 4, minItemLevel = 46, maxItemLevel = 65, matRate = 1.000, minAmount = 2, maxAmount = 5, amountOfMats = 3.500},
					{itemType = WEAPON, rarity = 2, minItemLevel = 46, maxItemLevel = 58, matRate = 0.050, minAmount = 1, maxAmount = 2, amountOfMats = 0.050},
					{itemType = WEAPON, rarity = 3, minItemLevel = 46, maxItemLevel = 58, matRate = 1.000, minAmount = 1, maxAmount = 3, amountOfMats = 2.000},
					{itemType = WEAPON, rarity = 4, minItemLevel = 46, maxItemLevel = 65, matRate = 1.000, minAmount = 2, maxAmount = 5, amountOfMats = 3.500},
				},
			},
			["i:22448"] = { -- Small Prismatic Shard
				minLevel = 56,
				maxLevel = 70,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 59, maxItemLevel = 70, matRate = 0.030, minAmount = 1, maxAmount = 2, amountOfMats = 0.033},
					{itemType = ARMOR, rarity = 3, minItemLevel = 59, maxItemLevel = 70, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.030},
					{itemType = WEAPON, rarity = 2, minItemLevel = 59, maxItemLevel = 70, matRate = 0.030, minAmount = 1, maxAmount = 2, amountOfMats = 0.033},
					{itemType = WEAPON, rarity = 3, minItemLevel = 59, maxItemLevel = 70, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.030},
				},
			},
			["i:22449"] = { -- Large Prismatic Shard
				minLevel = 56,
				maxLevel = 70,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 71, maxItemLevel = 80, matRate = 0.030, minAmount = 1, maxAmount = 2, amountOfMats = 0.033},
					{itemType = ARMOR, rarity = 3, minItemLevel = 71, maxItemLevel = 80, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.03},
					{itemType = WEAPON, rarity = 2, minItemLevel = 71, maxItemLevel = 80, matRate = 0.030, minAmount = 1, maxAmount = 2, amountOfMats = 0.033},
					{itemType = WEAPON, rarity = 3, minItemLevel = 71, maxItemLevel = 80, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.03},
				},
			},
			["i:34053"] = { -- Small Dream Shard
				minLevel = 68,
				maxLevel = 80,
				sourceInfo = {
					{itemType = ARMOR, rarity = 2, minItemLevel = 80, maxItemLevel = 90, matRate = 0.030, minAmount = 1, maxAmount = 2, amountOfMats = 0.033},
					{itemType = ARMOR, rarity = 3, minItemLevel = 80, maxItemLevel = 90, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 2, minItemLevel = 80, maxItemLevel = 90, matRate = 0.030, minAmount = 1, maxAmount = 2, amountOfMats = 0.033},
					{itemType = WEAPON, rarity = 3, minItemLevel = 80, maxItemLevel = 90, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				},
			},
			["i:34052"] = { -- Dream Shard
				minLevel = 68,
				maxLevel = 80,
				sourceInfo = {
					{itemType = ARMOR, rarity = 3, minItemLevel = 91, maxItemLevel = 100, matRate = 0.030, minAmount = 1, maxAmount = 2, amountOfMats = 0.033},
					{itemType = ARMOR, rarity = 3, minItemLevel = 91, maxItemLevel = 100, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 3, minItemLevel = 91, maxItemLevel = 100, matRate = 0.030, minAmount = 1, maxAmount = 2, amountOfMats = 0.033},
					{itemType = WEAPON, rarity = 3, minItemLevel = 91, maxItemLevel = 100, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				},
			},
			["i:52720"] = { -- Small Heavenly Shard
				minLevel = 78,
				maxLevel = 85,
				sourceInfo = {
					{itemType = ARMOR, rarity = 3, minItemLevel = 100, maxItemLevel = 106, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 3, minItemLevel = 100, maxItemLevel = 106, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				},
			},
			["i:52721"] = { -- Heavenly Shard
				minLevel = 78,
				maxLevel = 85,
				sourceInfo = {
					{itemType = ARMOR, rarity = 3, minItemLevel = 107, maxItemLevel = 108, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 3, minItemLevel = 107, maxItemLevel = 108, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				},
			},
			["i:74252"] = { -- Small Ethereal Shard
				minLevel = 85,
				maxLevel = 90,
				sourceInfo = {
					{itemType = ARMOR, rarity = 3, minItemLevel = 110, maxItemLevel = 115, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 3, minItemLevel = 110, maxItemLevel = 115, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				},
			},
			["i:74247"] = { -- Ethereal Shard
				minLevel = 85,
				maxLevel = 90,
				sourceInfo = {
					{itemType = ARMOR, rarity = 3, minItemLevel = 110, maxItemLevel = 115, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 3, minItemLevel = 110, maxItemLevel = 115, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				},
			},
			["i:115502"] = { -- Small Luminous Shard
				minLevel = 90,
				maxLevel = 100,
				sourceInfo = {
					{itemType = ARMOR, rarity = 3, minItemLevel = 130, maxItemLevel = 138, matRate = 0.100, minAmount = 3, maxAmount = 6, amountOfMats = 0.430},
					{itemType = WEAPON, rarity = 3, minItemLevel = 130, maxItemLevel = 138, matRate = 0.100, minAmount = 3, maxAmount = 6, amountOfMats = 0.430},
				},
			},
			["i:111245"] = { -- Luminous Shard
				minLevel = 90,
				maxLevel = 100,
				sourceInfo = {
					{itemType = ARMOR, rarity = 3, minItemLevel = 130, maxItemLevel = 138, matRate = 0.220, minAmount = 1, maxAmount = 1, amountOfMats = 0.220},
					{itemType = WEAPON, rarity = 3, minItemLevel = 130, maxItemLevel = 138, matRate = 0.220, minAmount = 1, maxAmount = 1, amountOfMats = 0.220},
				},
			},
			["i:124441"] = { -- Leylight Shard
				minLevel = 101,
				maxLevel = 110,
				sourceInfo = {
					{itemType = ARMOR, rarity = 3, minItemLevel = 138, maxItemLevel = 180, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 3, minItemLevel = 138, maxItemLevel = 180, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				},
			},
			["i:152876"] = { -- Umbra Shard
				minLevel = 111,
				maxLevel = 120,
				sourceInfo = {
					{itemType = ARMOR, rarity = 3, minItemLevel = 182, maxItemLevel = 999, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.500},
					{itemType = ARMOR, rarity = 4, minItemLevel = 300, maxItemLevel = 999, matRate = 0.400, minAmount = 1, maxAmount = 2, amountOfMats = 0.600},
					{itemType = WEAPON, rarity = 3, minItemLevel = 182, maxItemLevel = 999, matRate = 1.000, minAmount = 1, maxAmount = 2, amountOfMats = 1.500},
					{itemType = WEAPON, rarity = 4, minItemLevel = 300, maxItemLevel = 999, matRate = 0.400, minAmount = 1, maxAmount = 2, amountOfMats = 0.600},
				},
			},
		},
		{
			desc = L["Crystals"],
			["i:22450"] = { -- Void Crystal
				minLevel = 70,
				maxLevel = 70,
				sourceInfo = {
					{itemType = ARMOR, rarity = 4, minItemLevel = 73, maxItemLevel = 94, matRate = 1.000, minAmount = 1, maxAmount = 3, amountOfMats = 1.530},
					{itemType = WEAPON, rarity = 4, minItemLevel = 73, maxItemLevel = 94, matRate = 1.000, minAmount = 1, maxAmount = 3, amountOfMats = 1.530},
				},
			},
			["i:34057"] = { -- Abyss Crystal
				minLevel = 80,
				maxLevel = 80,
				sourceInfo = {
					{itemType = ARMOR, rarity = 4, minItemLevel = 100, maxItemLevel = 102, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 4, minItemLevel = 100, maxItemLevel = 102, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				},
			},
			["i:52722"] = { -- Maelstrom Crystal
				minLevel = 85,
				maxLevel = 85,
				sourceInfo = {
					{itemType = ARMOR, rarity = 4, minItemLevel = 108, maxItemLevel = 114, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 4, minItemLevel = 108, maxItemLevel = 114, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				},
			},
			["i:74248"] = { -- Sha Crystal
				minLevel = 85,
				maxLevel = 90,
				sourceInfo = {
					{itemType = ARMOR, rarity = 4, minItemLevel = 116, maxItemLevel = 130, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 4, minItemLevel = 116, maxItemLevel = 130, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				},
			},
			["i:115504"] = { -- Fractured Temporal Crystal
				minLevel = 90,
				maxLevel = 100,
				sourceInfo = {
					{itemType = ARMOR, rarity = 3, minItemLevel = 116, maxItemLevel = 138, matRate = 0.100, minAmount = 3, maxAmount = 3, amountOfMats = 0.300},
					{itemType = ARMOR, rarity = 4, minItemLevel = 132, maxItemLevel = 149, matRate = 0.250, minAmount = 3, maxAmount = 3, amountOfMats = 0.750},
					{itemType = WEAPON, rarity = 3, minItemLevel = 116, maxItemLevel = 138, matRate = 0.050, minAmount = 3, maxAmount = 3, amountOfMats = 0.150},
					{itemType = WEAPON, rarity = 4, minItemLevel = 132, maxItemLevel = 149, matRate = 0.250, minAmount = 3, maxAmount = 3, amountOfMats = 0.750},
				},
			},
			["i:113588"] = { -- Temporal Crystal
				minLevel = 90,
				maxLevel = 100,
				sourceInfo = {
					{itemType = ARMOR, rarity = 3, minItemLevel = 116, maxItemLevel = 138, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = ARMOR, rarity = 4, minItemLevel = 132, maxItemLevel = 149, matRate = 0.750, minAmount = 1, maxAmount = 1, amountOfMats = 0.750},
					{itemType = WEAPON, rarity = 3, minItemLevel = 116, maxItemLevel = 138, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = WEAPON, rarity = 4, minItemLevel = 132, maxItemLevel = 149, matRate = 0.750, minAmount = 1, maxAmount = 1, amountOfMats = 0.750},
				},
			},
			["i:124442"] = { -- Chaos Crystal
				minLevel = 101,
				maxLevel = 110,
				sourceInfo = {
					{itemType = ARMOR, rarity = 4, minItemLevel = 160, maxItemLevel = 265, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 4, minItemLevel = 160, maxItemLevel = 265, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				},
			},
			["i:152877"] = { -- Veiled Crystal
				minLevel = 111,
				maxLevel = 120,
				sourceInfo = {
					{itemType = ARMOR, rarity = 3, minItemLevel = 182, maxItemLevel = 999, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = ARMOR, rarity = 4, minItemLevel = 300, maxItemLevel = 999, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
					{itemType = WEAPON, rarity = 3, minItemLevel = 182, maxItemLevel = 999, matRate = 0.050, minAmount = 1, maxAmount = 1, amountOfMats = 0.050},
					{itemType = WEAPON, rarity = 4, minItemLevel = 300, maxItemLevel = 999, matRate = 1.000, minAmount = 1, maxAmount = 1, amountOfMats = 1.000},
				},
			},
		},
	}
end
