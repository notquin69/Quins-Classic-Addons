-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...

TSM.CONST.CONVERSIONS = {
	-- ======================================= Common Pigments =======================================
	["i:39151"] = { -- Alabaster Pigment (Ivory / Moonglow Ink)
		{"i:765", 0.5, "mill"},
		{"i:2447", 0.5, "mill"},
		{"i:2449", 0.6, "mill"},
	},
	["i:39343"] = { -- Azure Pigment (Ink of the Sea)
		{"i:39969", 0.5, "mill"},
		{"i:36904", 0.5, "mill"},
		{"i:36907", 0.5, "mill"},
		{"i:36901", 0.5, "mill"},
		{"i:39970", 0.5, "mill"},
		{"i:37921", 0.5, "mill"},
		{"i:36905", 0.6, "mill"},
		{"i:36906", 0.6, "mill"},
		{"i:36903", 0.6, "mill"},
	},
	["i:61979"] = { -- Ashen Pigment (Blackfallow Ink)
		{"i:52983", 0.5, "mill"},
		{"i:52984", 0.5, "mill"},
		{"i:52985", 0.5, "mill"},
		{"i:52986", 0.5, "mill"},
		{"i:52987", 0.6, "mill"},
		{"i:52988", 0.6, "mill"},
	},
	["i:39334"] = { -- Dusky Pigment (Midnight Ink)
		{"i:785", 0.5, "mill"},
		{"i:2450", 0.5, "mill"},
		{"i:2452", 0.5, "mill"},
		{"i:2453", 0.6, "mill"},
		{"i:3820", 0.6, "mill"},
	},
	["i:39339"] = { -- Emerald Pigment (Jadefire Ink)
		{"i:3818", 0.5, "mill"},
		{"i:3821", 0.5, "mill"},
		{"i:3358", 0.6, "mill"},
		{"i:3819", 0.6, "mill"},
	},
	["i:39338"] = { -- Golden Pigment (Lion's Ink)
		{"i:3355", 0.5, "mill"},
		{"i:3369", 0.5, "mill"},
		{"i:3356", 0.6, "mill"},
		{"i:3357", 0.6, "mill"},
	},
	["i:39342"] = { -- Nether Pigment (Ethereal Ink)
		{"i:22785", 0.5, "mill"},
		{"i:22786", 0.5, "mill"},
		{"i:22787", 0.5, "mill"},
		{"i:22789", 0.5, "mill"},
		{"i:22790", 0.6, "mill"},
		{"i:22791", 0.6, "mill"},
		{"i:22792", 0.6, "mill"},
		{"i:22793", 0.6, "mill"},
	},
	["i:79251"] = { -- Shadow Pigment (Ink of Dreams)
		{"i:72237", 0.5, "mill"},
		{"i:72234", 0.5, "mill"},
		{"i:79010", 0.5, "mill"},
		{"i:72235", 0.5, "mill"},
		{"i:89639", 0.5, "mill"},
		{"i:79011", 0.6, "mill"},
	},
	["i:39341"] = { -- Silvery Pigment (Shimmering Ink)
		{"i:13463", 0.5, "mill"},
		{"i:13464", 0.5, "mill"},
		{"i:13465", 0.6, "mill"},
		{"i:13466", 0.6, "mill"},
		{"i:13467", 0.6, "mill"},
	},
	["i:39340"] = { -- Violet Pigment (Celestial Ink)
		{"i:4625", 0.5, "mill"},
		{"i:8831", 0.5, "mill"},
		{"i:8838", 0.5, "mill"},
		{"i:8839", 0.6, "mill"},
		{"i:8845", 0.6, "mill"},
		{"i:8846", 0.6, "mill"},
	},
	["i:114931"] = { -- Cerulean Pigment (Warbinder's Ink)
		{"i:109124", 0.42, "mill"},
		{"i:109125", 0.42, "mill"},
		{"i:109126", 0.42, "mill"},
		{"i:109127", 0.42, "mill"},
		{"i:109128", 0.42, "mill"},
		{"i:109129", 0.42, "mill"},
	},
	["i:129032"] = { -- Roseate Pigment (No Legion Ink)
		{"i:124101", 0.42, "mill"},
		{"i:124102", 0.42, "mill"},
		{"i:124103", 0.42, "mill"},
		{"i:124104", 0.47, "mill"},
		{"i:124105", 1.22, "mill"},
		{"i:124106", 0.42, "mill"},
		{"i:128304", 0.2, "mill"},
		{"i:151565", 0.43, "mill"},
	},
	-- ======================================= Rare Pigments =======================================
	["i:43109"] = { -- Icy Pigment (Snowfall Ink)
		{"i:39969", 0.05, "mill"},
		{"i:36904", 0.05, "mill"},
		{"i:36907", 0.05, "mill"},
		{"i:36901", 0.05, "mill"},
		{"i:39970", 0.05, "mill"},
		{"i:37921", 0.05, "mill"},
		{"i:36905", 0.1, "mill"},
		{"i:36906", 0.1, "mill"},
		{"i:36903", 0.1, "mill"},
	},
	["i:61980"] = { -- Burning Embers (Inferno Ink)
		{"i:52983", 0.05, "mill"},
		{"i:52984", 0.05, "mill"},
		{"i:52985", 0.05, "mill"},
		{"i:52986", 0.05, "mill"},
		{"i:52987", 0.1, "mill"},
		{"i:52988", 0.1, "mill"},
	},
	["i:43104"] = { -- Burnt Pigment (Dawnstar Ink)
		{"i:3356", 0.1, "mill"},
		{"i:3357", 0.1, "mill"},
		{"i:3369", 0.05, "mill"},
		{"i:3355", 0.05, "mill"},
	},
	["i:43108"] = { -- Ebon Pigment (Darkflame Ink)
		{"i:22792", 0.1, "mill"},
		{"i:22790", 0.1, "mill"},
		{"i:22791", 0.1, "mill"},
		{"i:22793", 0.1, "mill"},
		{"i:22786", 0.05, "mill"},
		{"i:22785", 0.05, "mill"},
		{"i:22787", 0.05, "mill"},
		{"i:22789", 0.05, "mill"},
	},
	["i:43105"] = { -- Indigo Pigment (Royal Ink)
		{"i:3358", 0.1, "mill"},
		{"i:3819", 0.1, "mill"},
		{"i:3821", 0.05, "mill"},
		{"i:3818", 0.05, "mill"},
	},
	["i:79253"] = { -- Misty Pigment (Starlight Ink)
		{"i:72237", 0.05, "mill"},
		{"i:72234", 0.05, "mill"},
		{"i:79010", 0.05, "mill"},
		{"i:72235", 0.05, "mill"},
		{"i:79011", 0.1, "mill"},
		{"i:89639", 0.05, "mill"},
	},
	["i:43106"] = { -- Ruby Pigment (Fiery Ink)
		{"i:4625", 0.05, "mill"},
		{"i:8838", 0.05, "mill"},
		{"i:8831", 0.05, "mill"},
		{"i:8845", 0.1, "mill"},
		{"i:8846", 0.1, "mill"},
		{"i:8839", 0.1, "mill"},
	},
	["i:43107"] = { -- Sapphire Pigment (Ink of the Sky)
		{"i:13463", 0.05, "mill"},
		{"i:13464", 0.05, "mill"},
		{"i:13465", 0.1, "mill"},
		{"i:13466", 0.1, "mill"},
		{"i:13467", 0.1, "mill"},
	},
	["i:43103"] = { -- Verdant Pigment (Hunter's Ink)
		{"i:2453", 0.1, "mill"},
		{"i:3820", 0.1, "mill"},
		{"i:2450", 0.05, "mill"},
		{"i:785", 0.05, "mill"},
		{"i:2452", 0.05, "mill"},
	},
	["i:129034"] = { -- Sallow Pigment (No Legion Ink)
		{"i:124101", 0.04, "mill"},
		{"i:124102", 0.04, "mill"},
		{"i:124103", 0.05, "mill"},
		{"i:124104", 0.05, "mill"},
		{"i:124105", 0.04, "mill"},
		{"i:124106", 2.14, "mill"},
		{"i:128304", 0.0018, "mill"},
		{"i:151565", 0.048, "mill"},
	},
	-- ======================================= BFA Pigments ========================================
	["i:153669"] = { -- Viridescent Pigment
		{"i:152505", 0.1325, "mill"},
		{"i:152506", 0.1325, "mill"},
		{"i:152507", 0.1325, "mill"},
		{"i:152508", 0.1325, "mill"},
		{"i:152509", 0.1325, "mill"},
		{"i:152511", 0.1325, "mill"},
		{"i:152510", 0.325, "mill"},
	},
	["i:153636"] = { -- Crimson Pigment
		{"i:152505", 0.315, "mill"},
		{"i:152506", 0.315, "mill"},
		{"i:152507", 0.315, "mill"},
		{"i:152508", 0.315, "mill"},
		{"i:152509", 0.315, "mill"},
		{"i:152511", 0.315, "mill"},
		{"i:152510", 0.315, "mill"},
	},
	["i:153635"] = { -- Ultramarine Pigment
		{"i:152505", 0.825, "mill"},
		{"i:152506", 0.825, "mill"},
		{"i:152507", 0.825, "mill"},
		{"i:152508", 0.825, "mill"},
		{"i:152509", 0.825, "mill"},
		{"i:152511", 0.825, "mill"},
		{"i:152510", 0.825, "mill"},
	},
	["i:168662"] = { -- Maroon Pigment
		{"i:152505", 0.825, "mill"},
	},
	-- ======================================== Vanilla Gems =======================================
	["i:774"] = { -- Malachite
		{"i:2770", 0.1, "prospect"},
	},
	["i:818"] = { -- Tigerseye
		{"i:2770", 0.1, "prospect"},
	},
	["i:1210"] = {  -- Shadowgem
		{"i:2771", 0.08, "prospect"},
		{"i:2770", 0.02, "prospect"},
	},
	["i:1206"] = { -- Moss Agate
		{"i:2771", 0.06, "prospect"},
	},
	["i:1705"] = { -- Lesser Moonstone
		{"i:2771", 0.08, "prospect"},
		{"i:2772", 0.06, "prospect"},
	},
	["i:1529"] = { -- Jade
		{"i:2772", 0.08, "prospect"},
		{"i:2771", 0.006, "prospect"},
	},
	["i:3864"] = { -- Citrine
		{"i:2772", 0.08, "prospect"},
		{"i:3858", 0.06, "prospect"},
		{"i:2771", 0.006, "prospect"},
	},
	["i:7909"] = { -- Aquamarine
		{"i:3858", 0.06, "prospect"},
		{"i:2772", 0.01, "prospect"},
		{"i:2771", 0.006, "prospect"},
	},
	["i:7910"] = { -- Star Ruby
		{"i:3858", 0.08, "prospect"},
		{"i:10620", 0.02, "prospect"},
		{"i:2772", 0.01, "prospect"},
	},
	["i:12361"] = { -- Blue Sapphire
		{"i:10620", 0.06, "prospect"},
		{"i:3858", 0.006, "prospect"},
	},
	["i:12799"] = { -- Large Opal
		{"i:10620", 0.06, "prospect"},
		{"i:3858", 0.006, "prospect"},
	},
	["i:12800"] = { -- Azerothian Diamond
		{"i:10620", 0.06, "prospect"},
		{"i:3858", 0.004, "prospect"},
	},
	["i:12364"] = { -- Huge Emerald
		{"i:10620", 0.06, "prospect"},
		{"i:3858", 0.004, "prospect"},
	},
	-- ======================================== Uncommon Gems ======================================
	["i:23117"] = { -- Azure Moonstone
		{"i:23424", 0.04, "prospect"},
		{"i:23425", 0.04, "prospect"},
	},
	["i:23077"] = { -- Blood Garnet
		{"i:23424", 0.04, "prospect"},
		{"i:23425", 0.04, "prospect"},
	},
	["i:23079"] = { -- Deep Peridot
		{"i:23424", 0.04, "prospect"},
		{"i:23425", 0.04, "prospect"},
	},
	["i:21929"] = { -- Flame Spessarite
		{"i:23424", 0.04, "prospect"},
		{"i:23425", 0.04, "prospect"},
	},
	["i:23112"] = { -- Golden Draenite
		{"i:23424", 0.04, "prospect"},
		{"i:23425", 0.04, "prospect"},
	},
	["i:23107"] = { -- Shadow Draenite
		{"i:23424", 0.04, "prospect"},
		{"i:23425", 0.04, "prospect"},
	},
	["i:36917"] = { -- Bloodstone
		{"i:36909", 0.05, "prospect"},
		{"i:36912", 0.04, "prospect"},
		{"i:36910", 0.05, "prospect"},
	},
	["i:36923"] = { -- Chalcedony
		{"i:36909", 0.05, "prospect"},
		{"i:36912", 0.04, "prospect"},
		{"i:36910", 0.05, "prospect"},
	},
	["i:36932"] = { -- Dark Jade
		{"i:36909", 0.05, "prospect"},
		{"i:36912", 0.04, "prospect"},
		{"i:36910", 0.05, "prospect"},
	},
	["i:36929"] = { -- Huge Citrine
		{"i:36909", 0.05, "prospect"},
		{"i:36912", 0.04, "prospect"},
		{"i:36910", 0.05, "prospect"},
	},
	["i:36926"] = { -- Shadow Crystal
		{"i:36909", 0.05, "prospect"},
		{"i:36912", 0.04, "prospect"},
		{"i:36910", 0.05, "prospect"},
	},
	["i:36920"] = { -- Sun Crystal
		{"i:36909", 0.05, "prospect"},
		{"i:36912", 0.04, "prospect"},
		{"i:36910", 0.04, "prospect"},
	},
	["i:52182"] = { -- Jasper
		{"i:53038", 0.05, "prospect"},
		{"i:52185", 0.04, "prospect"},
		{"i:52183", 0.04, "prospect"},
	},
	["i:52180"] = { -- Nightstone
		{"i:53038", 0.05, "prospect"},
		{"i:52185", 0.04, "prospect"},
		{"i:52183", 0.04, "prospect"},
	},
	["i:52178"] = { -- Zephyrite
		{"i:53038", 0.05, "prospect"},
		{"i:52185", 0.04, "prospect"},
		{"i:52183", 0.04, "prospect"},
	},
	["i:52179"] = { -- Alicite
		{"i:53038", 0.05, "prospect"},
		{"i:52185", 0.04, "prospect"},
		{"i:52183", 0.04, "prospect"},
	},
	["i:52177"] = { -- Carnelian
		{"i:53038", 0.05, "prospect"},
		{"i:52185", 0.04, "prospect"},
		{"i:52183", 0.04, "prospect"},
	},
	["i:52181"] = { -- Hessonite
		{"i:53038", 0.05, "prospect"},
		{"i:52185", 0.04, "prospect"},
		{"i:52183", 0.04, "prospect"},
	},
	["i:76130"] = { -- Tiger Opal
		{"i:72092", 0.05, "prospect"},
		{"i:72093", 0.05, "prospect"},
		{"i:72103", 0.04, "prospect"},
		{"i:72094", 0.04, "prospect"},
	},
	["i:76133"] = { -- Lapis Lazuli
		{"i:72092", 0.05, "prospect"},
		{"i:72093", 0.05, "prospect"},
		{"i:72103", 0.04, "prospect"},
		{"i:72094", 0.04, "prospect"},
	},
	["i:76134"] = { -- Sunstone
		{"i:72092", 0.05, "prospect"},
		{"i:72093", 0.05, "prospect"},
		{"i:72103", 0.04, "prospect"},
		{"i:72094", 0.04, "prospect"},
	},
	["i:76135"] = { -- Roguestone
		{"i:72092", 0.05, "prospect"},
		{"i:72093", 0.05, "prospect"},
		{"i:72103", 0.04, "prospect"},
		{"i:72094", 0.04, "prospect"},
	},
	["i:76136"] = { -- Pandarian Garnet
		{"i:72092", 0.05, "prospect"},
		{"i:72093", 0.05, "prospect"},
		{"i:72103", 0.04, "prospect"},
		{"i:72094", 0.04, "prospect"},
	},
	["i:76137"] = { -- Alexandrite
		{"i:72092", 0.05, "prospect"},
		{"i:72093", 0.05, "prospect"},
		{"i:72103", 0.04, "prospect"},
		{"i:72094", 0.04, "prospect"},
	},
	["i:130172"] = { -- Sangrite
		{"i:123918", 0.007, "prospect"},
		{"i:123919", 0.022, "prospect"},
	},
	["i:130173"] = { -- Deep Amber
		{"i:123918", 0.011, "prospect"},
		{"i:123919", 0.042, "prospect"},
	},
	["i:130174"] = { -- Azsunite
		{"i:123918", 0.012, "prospect"},
		{"i:123919", 0.043, "prospect"},
	},
	["i:130175"] = { -- Chaotic Spinel
		{"i:123918", 0.006, "prospect"},
		{"i:123919", 0.021, "prospect"},
	},
	["i:130176"] = { -- Skystone
		{"i:123918", 0.012, "prospect"},
		{"i:123919", 0.04, "prospect"},
	},
	["i:130177"] = { -- Queen's Opal
		{"i:123918", 0.012, "prospect"},
		{"i:123919", 0.045, "prospect"},
	},
	["i:129100"] = { -- Gem Chip - mostly trash but limited use in some professions
		{"i:123918", 0.2, "prospect"},
		{"i:123919", 0.2, "prospect"},
	},
	["i:153700"] = { -- Golden Beryl - BFA
		{"i:152579", 0.06, "prospect"},
		{"i:152512", 0.055, "prospect"},
		{"i:152513", 0.065, "prospect"},
	},
	["i:153701"] = { -- Rubellite - BFA
		{"i:152579", 0.06, "prospect"},
		{"i:152512", 0.055, "prospect"},
		{"i:152513", 0.065, "prospect"},
	},
	["i:153702"] = { -- Kubiline - BFA
		{"i:152579", 0.06, "prospect"},
		{"i:152512", 0.055, "prospect"},
		{"i:152513", 0.065, "prospect"},
	},
	["i:153703"] = { -- Solstone - BFA
		{"i:152579", 0.06, "prospect"},
		{"i:152512", 0.055, "prospect"},
		{"i:152513", 0.065, "prospect"},
	},
	["i:153704"] = { -- Viridium - BFA
		{"i:152579", 0.06, "prospect"},
		{"i:152512", 0.055, "prospect"},
		{"i:152513", 0.065, "prospect"},
	},
	["i:153705"] = { -- Kyanite - BFA
		{"i:152579", 0.06, "prospect"},
		{"i:152512", 0.055, "prospect"},
		{"i:152513", 0.065, "prospect"},
	},
	-- ========================================== Rare Gems ========================================
	["i:23440"] = { -- Dawnstone
		{"i:23424", 0.002, "prospect"},
		{"i:23425", 0.008, "prospect"},
	},
	["i:23436"] = { -- Living Ruby
		{"i:23424", 0.002, "prospect"},
		{"i:23425", 0.008, "prospect"},
	},
	["i:23441"] = { -- Nightseye
		{"i:23424", 0.002, "prospect"},
		{"i:23425", 0.008, "prospect"},
	},
	["i:23439"] = { -- Noble Topaz
		{"i:23424", 0.002, "prospect"},
		{"i:23425", 0.008, "prospect"},
	},
	["i:23438"] = { -- Star of Elune
		{"i:23424", 0.002, "prospect"},
		{"i:23425", 0.008, "prospect"},
	},
	["i:23437"] = { -- Talasite
		{"i:23424", 0.002, "prospect"},
		{"i:23425", 0.008, "prospect"},
	},
	["i:36921"] = { -- Autumn's Glow
		{"i:36909", 0.002, "prospect"},
		{"i:36912", 0.008, "prospect"},
		{"i:36910", 0.008, "prospect"},
	},
	["i:36933"] = { -- Forest Emerald
		{"i:36909", 0.002, "prospect"},
		{"i:36912", 0.008, "prospect"},
		{"i:36910", 0.008, "prospect"},
	},
	["i:36930"] = { -- Monarch Topaz
		{"i:36909", 0.002, "prospect"},
		{"i:36912", 0.008, "prospect"},
		{"i:36910", 0.008, "prospect"},
	},
	["i:36918"] = { -- Scarlet Ruby
		{"i:36909", 0.002, "prospect"},
		{"i:36912", 0.008, "prospect"},
		{"i:36910", 0.008, "prospect"},
	},
	["i:36924"] = { -- Sky Sapphire
		{"i:36909", 0.002, "prospect"},
		{"i:36912", 0.008, "prospect"},
		{"i:36910", 0.008, "prospect"},
	},
	["i:36927"] = { -- Twilight Opal
		{"i:36909", 0.002, "prospect"},
		{"i:36912", 0.008, "prospect"},
		{"i:36910", 0.008, "prospect"},
	},
	["i:52192"] = { -- Dream Emerald
		{"i:53038", 0.016, "prospect"},
		{"i:52185", 0.01, "prospect"},
		{"i:52183", 0.008, "prospect"},
	},
	["i:52193"] = { -- Ember Topaz
		{"i:53038", 0.016, "prospect"},
		{"i:52185", 0.01, "prospect"},
		{"i:52183", 0.008, "prospect"},
	},
	["i:52190"] = { -- Inferno Ruby
		{"i:53038", 0.016, "prospect"},
		{"i:52185", 0.01, "prospect"},
		{"i:52183", 0.008, "prospect"},
	},
	["i:52195"] = { -- Amberjewel
		{"i:53038", 0.016, "prospect"},
		{"i:52185", 0.01, "prospect"},
		{"i:52183", 0.008, "prospect"},
	},
	["i:52194"] = { -- Demonseye
		{"i:53038", 0.016, "prospect"},
		{"i:52185", 0.01, "prospect"},
		{"i:52183", 0.008, "prospect"},
	},
	["i:52191"] = { -- Ocean Sapphire
		{"i:53038", 0.016, "prospect"},
		{"i:52185", 0.01, "prospect"},
		{"i:52183", 0.008, "prospect"},
	},
	["i:76131"] = { -- Primordial Ruby
		{"i:72092", 0.008, "prospect"},
		{"i:72093", 0.008, "prospect"},
		{"i:72103", 0.03, "prospect"},
		{"i:72094", 0.03, "prospect"},
	},
	["i:76138"] = { -- River's Heart
		{"i:72092", 0.008, "prospect"},
		{"i:72093", 0.008, "prospect"},
		{"i:72103", 0.03, "prospect"},
		{"i:72094", 0.03, "prospect"},
	},
	["i:76139"] = { -- Wild Jade
		{"i:72092", 0.008, "prospect"},
		{"i:72093", 0.008, "prospect"},
		{"i:72103", 0.03, "prospect"},
		{"i:72094", 0.03, "prospect"},
	},
	["i:76140"] = { -- Vermillion Onyx
		{"i:72092", 0.008, "prospect"},
		{"i:72093", 0.008, "prospect"},
		{"i:72103", 0.03, "prospect"},
		{"i:72094", 0.03, "prospect"},
	},
	["i:76141"] = { -- Imperial Amethyst
		{"i:72092", 0.008, "prospect"},
		{"i:72093", 0.008, "prospect"},
		{"i:72103", 0.03, "prospect"},
		{"i:72094", 0.03, "prospect"},
	},
	["i:76142"] = { -- Sun's Radiance
		{"i:72092", 0.008, "prospect"},
		{"i:72093", 0.008, "prospect"},
		{"i:72103", 0.03, "prospect"},
		{"i:72094", 0.03, "prospect"},
	},
	["i:130178"] = { -- FuryStone
		{"i:123918", 0.001, "prospect"},
		{"i:123919", 0.005, "prospect"},
	},
	["i:130179"] = { -- Eye of Prophecy
		{"i:123918", 0.002, "prospect"},
		{"i:123919", 0.007, "prospect"},
	},
	["i:130180"] = { -- Dawnlight
		{"i:123918", 0.002, "prospect"},
		{"i:123919", 0.007, "prospect"},
	},
	["i:130181"] = { -- Pandemonite
		{"i:123918", 0.001, "prospect"},
		{"i:123919", 0.003, "prospect"},
	},
	["i:130182"] = { -- Maelstrom Sapphire
		{"i:123918", 0.002, "prospect"},
		{"i:123919", 0.007, "prospect"},
	},
	["i:130183"] = { -- Shadowruby
		{"i:123918", 0.002, "prospect"},
		{"i:123919", 0.006, "prospect"},
	},
	["i:154120"] = { -- Owlseye - BFA
		{"i:152579", 0.015, "prospect"},
		{"i:152512", 0.0085, "prospect"},
		{"i:152513", 0.0235, "prospect"},
	},
	["i:154121"] = { -- Scarlet Diamond - BFA
		{"i:152579", 0.015, "prospect"},
		{"i:152512", 0.0085, "prospect"},
		{"i:152513", 0.0235, "prospect"},
	},
	["i:154122"] = { -- Tidal Amethyst - BFA
		{"i:152579", 0.015, "prospect"},
		{"i:152512", 0.0085, "prospect"},
		{"i:152513", 0.0235, "prospect"},
	},
	["i:154123"] = { -- Amberblaze - BFA
		{"i:152579", 0.015, "prospect"},
		{"i:152512", 0.0085, "prospect"},
		{"i:152513", 0.0235, "prospect"},
	},
	["i:154124"] = { -- Laribole - BFA
		{"i:152579", 0.015, "prospect"},
		{"i:152512", 0.0085, "prospect"},
		{"i:152513", 0.0235, "prospect"},
	},
	["i:154125"] = { -- Royal Quartz - BFA
		{"i:152579", 0.015, "prospect"},
		{"i:152512", 0.0085, "prospect"},
		{"i:152513", 0.0235, "prospect"},
	},
	-- ========================================== Epic Gems ========================================
	["i:151579"] = { -- Labradorite
		{"i:151564", 0.0056, "prospect"},
	},
	["i:151719"] = { -- Lightsphene
		{"i:151564", 0.0064, "prospect"},
	},
	["i:151718"] = { -- Argulite
		{"i:151564", 0.0060, "prospect"},
	},
	["i:151720"] = { -- Chemirine
		{"i:151564", 0.0063, "prospect"},
	},
	["i:151722"] = { -- Florid Malachite
		{"i:151564", 0.0035, "prospect"},
	},
	["i:151721"] = { -- Hesselian
		{"i:151564", 0.0040, "prospect"},
	},
	["i:153706"] = { -- Kraken's Eye - BFA
		{"i:152579", 0.0065, "prospect"},
		{"i:152512", 0.006, "prospect"},
		{"i:152513", 0.0081, "prospect"},
	},
	["i:168635"] = { -- Leviathan's Eye - BFA
		{"i:168185", 0.032, "prospect"},
	},
	["i:168188"] = { -- Sage Agate - BFA
		{"i:168185", 0.012, "prospect"},
	},
	["i:168193"] = { -- Azsharine - BFA
		{"i:168185", 0.012, "prospect"},
	},
	["i:168189"] = { -- Dark Opal - BFA
		{"i:168185", 0.04, "prospect"},
	},
	["i:168190"] = { -- Lava Lazuli - BFA
		{"i:168185", 0.044, "prospect"},
	},
	["i:168191"] = { -- Sea Currant - BFA
		{"i:168185", 0.044, "prospect"},
	},
	["i:168192"] = { -- Sand Spinel - BFA
		{"i:168185", 0.044, "prospect"},
	},
	-- =========================================== Essences ========================================
	["i:52719"] = {{"i:52718", 1/3, "transform"}}, -- Greater Celestial Essence
	["i:52718"] = {{"i:52719", 3, "transform"}}, -- Lesser Celestial Essence
	["i:34055"] = {{"i:34056", 1/3, "transform"}}, -- Greater Cosmic Essence
	["i:34056"] = {{"i:34055", 3, "transform"}}, -- Lesser Cosmic Essence
	["i:22446"] = {{"i:22447", 1/3, "transform"}}, -- Greater Planar Essence
	["i:22447"] = {{"i:22446", 3, "transform"}}, -- Lesser Planar Essence
	["i:16203"] = {{"i:16202", 1/3, "transform"}}, -- Greater Eternal Essence
	["i:16202"] = {{"i:16203", 3, "transform"}}, -- Lesser Eternal Essence
	["i:11175"] = {{"i:11174", 1/3, "transform"}}, -- Greater Nether Essence
	["i:11174"] = {{"i:11175", 3, "transform"}}, -- Lesser Nether Essence
	["i:11135"] = {{"i:11134", 1/3, "transform"}}, -- Greater Mystic Essence
	["i:11134"] = {{"i:11135", 3, "transform"}}, -- Lesser Mystic Essence
	["i:11082"] = {{"i:10998", 1/3, "transform"}}, -- Greater Astral Essence
	["i:10998"] = {{"i:11082", 3, "transform"}}, -- Lesser Astral Essence
	["i:10939"] = {{"i:10938", 1/3, "transform"}}, -- Greater Magic Essence
	["i:10938"] = {{"i:10939", 3, "transform"}}, -- Lesser Magic Essence
	-- ============================================ Shards =========================================
	["i:52721"] = {{"i:52720", 1/3, "transform"}}, -- Heavenly Shard
	["i:34052"] = {{"i:34053", 1/3, "transform"}}, -- Dream Shard
	["i:74247"] = {{"i:74252", 1/3, "transform"}}, -- Ethereal Shard
	["i:111245"] = {{"i:115502", 0.1, "transform"}}, -- Luminous Shard
	-- =========================================== Crystals ========================================
	["i:113588"] = {{"i:115504", 0.1, "transform"}}, -- Temporal Crystal
	-- ======================================== Primals / Motes ====================================
	["i:21885"] = {{"i:22578", 0.1, "transform"}}, -- Water
	["i:22456"] = {{"i:22577", 0.1, "transform"}}, -- Shadow
	["i:22457"] = {{"i:22576", 0.1, "transform"}}, -- Mana
	["i:21886"] = {{"i:22575", 0.1, "transform"}}, -- Life
	["i:21884"] = {{"i:22574", 0.1, "transform"}}, -- Fire
	["i:22452"] = {{"i:22573", 0.1, "transform"}}, -- Earth
	["i:22451"] = {{"i:22572", 0.1, "transform"}}, -- Air
	-- ===================================== Crystalized / Eternal =================================
	["i:37700"] = {{"i:35623", 10, "transform"}}, -- Air
	["i:35623"] = {{"i:37700", 0.1, "transform"}}, -- Air
	["i:37701"] = {{"i:35624", 10, "transform"}}, -- Earth
	["i:35624"] = {{"i:37701", 0.1, "transform"}}, -- Earth
	["i:37702"] = {{"i:36860", 10, "transform"}}, -- Fire
	["i:36860"] = {{"i:37702", 0.1, "transform"}}, -- Fire
	["i:37703"] = {{"i:35627", 10, "transform"}}, -- Shadow
	["i:35627"] = {{"i:37703", 0.1, "transform"}}, -- Shadow
	["i:37704"] = {{"i:35625", 10, "transform"}}, -- Life
	["i:35625"] = {{"i:37704", 0.1, "transform"}}, -- Life
	["i:37705"] = {{"i:35622", 10, "transform"}}, -- Water
	["i:35622"] = {{"i:37705", 0.1, "transform"}}, -- Water
	-- ========================================= Wod Fish ==========================================
	["i:109137"] = {
		{"i:111601", 4, "transform"}, -- Enormous Crescent Saberfish
		{"i:111595", 2, "transform"}, -- Crescent Saberfish
		{"i:111589", 1, "transform"}, -- Small Crescent Saberfish
	},
	["i:109138"] = {
		{"i:111676", 4, "transform"}, -- Enormous Jawless Skulker
		{"i:111669", 2, "transform"}, -- Jawless Skulker
		{"i:111650", 1, "transform"}, -- Small Jawless Skulker
	},
	["i:109139"] = {
		{"i:111675", 4, "transform"}, -- Enormous Fat Sleeper
		{"i:111668", 2, "transform"}, -- Fat Sleeper
		{"i:111651", 1, "transform"}, -- Small Fat Sleeper
	},
	["i:109140"] = {
		{"i:111674", 4, "transform"}, -- Enormous Blind Lake Sturgeon
		{"i:111667", 2, "transform"}, -- Blind Lake Sturgeon
		{"i:111652", 1, "transform"}, -- Small Blind Lake Sturgeon
	},
	["i:109141"] = {
		{"i:111673", 4, "transform"}, -- Enormous Fire Ammonite
		{"i:111666", 2, "transform"}, -- Fire Ammonite
		{"i:111656", 1, "transform"}, -- Small Fire Ammonite
	},
	["i:109142"] = {
		{"i:111672", 4, "transform"}, -- Enormous Sea Scorpion
		{"i:111665", 2, "transform"}, -- Sea Scorpion
		{"i:111658", 1, "transform"}, -- Small Sea Scorpion
	},
	["i:109143"] = {
		{"i:111671", 4, "transform"}, -- Enormous Abyssal Gulper Eel
		{"i:111664", 2, "transform"}, -- Abyssal Gulper Eel
		{"i:111659", 1, "transform"}, -- Small Abyssal Gulper Eel
	},
	["i:109144"] = {
		{"i:111670", 4, "transform"}, -- Enormous Blackwater Whiptail
		{"i:111663", 2, "transform"}, -- Blackwater Whiptail
		{"i:111662", 1, "transform"}, -- Small Blackwater Whiptail
	},
	-- ========================================== Aromatic Fish Oil (BFA) ===========================
	["i:160711"] = {
		{"i:152545", 1, "transform"}, -- Frenzied Fangtooth
		{"i:152547", 1, "transform"}, -- Great Sea Catfish
		{"i:152546", 1, "transform"}, -- Lane Snapper
		{"i:152549", 1, "transform"}, -- Redtail Loach
		{"i:152543", 1, "transform"}, -- Sand Shifter
		{"i:152544", 1, "transform"}, -- Slimy Mackerel
		{"i:152548", 1, "transform"}, -- Tiragarde Perch
	},
	-- ========================================== Ore Nuggets =======================================
	["i:2771"] = {{"i:108295", 0.1, "transform"}},   -- Tin Ore
	["i:2772"] = {{"i:108297", 0.1, "transform"}},   -- Iron Ore
	["i:2775"] = {{"i:108294", 0.1, "transform"}},   -- Silver Ore
	["i:2776"] = {{"i:108296", 0.1, "transform"}},   -- Gold Ore
	["i:3858"] = {{"i:108300", 0.1, "transform"}},   -- Mithril Ore
	["i:7911"] = {{"i:108299", 0.1, "transform"}},   -- Truesilver Ore
	["i:10620"] = {{"i:108298", 0.1, "transform"}},  -- Thorium Ore
	["i:23424"] = {{"i:108301", 0.1, "transform"}},  -- Fel Iron Ore
	["i:23425"] = {{"i:108302", 0.1, "transform"}},  -- Adamantite Ore
	["i:23426"] = {{"i:108304", 0.1, "transform"}},  -- Khorium Ore
	["i:23427"] = {{"i:108303", 0.1, "transform"}},  -- Eternium Ore
	["i:36909"] = {{"i:108305", 0.1, "transform"}},  -- Cobalt Ore
	["i:36910"] = {{"i:108391", 0.1, "transform"}},  -- Titanium Ore
	["i:36912"] = {{"i:108306", 0.1, "transform"}},  -- Saronite Ore
	["i:52183"] = {{"i:108309", 0.1, "transform"}},  -- Pyrite Ore
	["i:52185"] = {{"i:108308", 0.1, "transform"}},  -- Elementium Ore
	["i:53038"] = {{"i:108307", 0.1, "transform"}},  -- Obsidium Ore
	["i:72092"] = {{"i:97512", 0.1, "transform"}},   -- Ghost Iron Ore
	["i:109119"] = {{"i:109991", 0.1, "transform"}}, -- True Iron Ore
	-- =========================================== Herb Parts ======================================
	["i:2449"] = {{"i:108319", 0.1, "transform"}}, -- Earthroot
	-- ========================================= Vendor Trades =====================================
	["i:37101"] = {{"i:129032", 1, "vendortrade"}},   -- Ivory Ink
	["i:39469"] = {{"i:129032", 1, "vendortrade"}},   -- Moonglow Ink
	["i:39774"] = {{"i:129032", 1, "vendortrade"}},   -- Midnight Ink
	["i:43116"] = {{"i:129032", 1, "vendortrade"}},   -- Lion's Ink
	["i:43118"] = {{"i:129032", 1, "vendortrade"}},   -- Jadefire Ink
	["i:43120"] = {{"i:129032", 1, "vendortrade"}},   -- Celestial Ink
	["i:43122"] = {{"i:129032", 1, "vendortrade"}},   -- Shimmering Ink
	["i:43124"] = {{"i:129032", 1, "vendortrade"}},   -- Ethereal Ink
	["i:43126"] = {{"i:129032", 1, "vendortrade"}},   -- Ink of the Sea
	["i:43127"] = {{"i:129032", 0.1, "vendortrade"}}, -- Snowfall Ink
	["i:61978"] = {{"i:129032", 1, "vendortrade"}},   -- Blackfallow Ink
	["i:61981"] = {{"i:129032", 0.1, "vendortrade"}}, -- Inferno Ink
	["i:79254"] = {{"i:129032", 1, "vendortrade"}},   -- Ink of Dreams
	["i:79255"] = {{"i:129032", 0.1, "vendortrade"}}, -- Starlight Ink
	["i:113111"] = {{"i:129032", 1, "vendortrade"}},  -- Warbinder's Ink
}
