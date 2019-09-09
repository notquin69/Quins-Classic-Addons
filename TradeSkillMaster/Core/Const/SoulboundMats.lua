-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...

TSM.CONST.SOULBOUND_CRAFTING_MATS = {
	["i:54440"] = true, -- Dreamcloth
	["i:79731"] = true, -- Scroll of Wisdom
	["i:82447"] = true, -- Imperial Silk
	["i:94111"] = true, -- Lightning Steel Ingot
	["i:94113"] = true, -- Jard's Peculiar Energy Source
	["i:98617"] = true, -- Hardened Magnificent Hide
	["i:98619"] = true, -- Celestial Cloth
	["i:98717"] = true, -- Balanced Trillium Ingot
	["i:108257"] = true, -- Truesteel Ingot
	["i:108995"] = true, -- Metamorphic Crystal
	["i:110611"] = true, -- Burnished Leather
	["i:111366"] = true, -- Gearspring Parts
	["i:111556"] = true, -- Hexweave Cloth
	["i:112377"] = true, -- War Paints
	["i:115524"] = true, -- Taladite Crystal
	["i:120945"] = true, -- Primal Spirit
	["i:124124"] = true, -- Blood of Sargeras
	["i:136629"] = true, -- Felgibber Shotgun
	["i:136630"] = true, -- Twirling Bottom Repeater
	["i:136631"] = true, -- Surface-to-Infernal Rocket Launcher
	["i:136632"] = true, -- Chaos Blaster
	["i:137595"] = true, -- Viscous Transmutagen
	["i:137596"] = true, -- Black Transmutagen
	["i:137597"] = true, -- Oily Transmutagen
	["i:140781"] = true, -- X-87 Battle Circuit
	["i:140782"] = true, -- Neural Net Detangler
	["i:140783"] = true, -- Predictive Combat Operations Databank
	["i:140784"] = true, -- Fel Piston Stabilizer
	["i:140785"] = true, -- Hardened Circuitboard Plating
	["i:151568"] = true, -- Primal Sargerite
	["i:152668"] = true, -- Expulsom
	["i:162460"] = true, -- Hydrocore
	["i:162461"] = true, -- Sanguricell
	["i:165703"] = true, -- Breath of Bwonsamdi
	["i:165948"] = true, -- Tidalcore
}
