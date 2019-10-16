--
VUHDO_DEBUFF_TYPE_NONE = 0;
VUHDO_DEBUFF_TYPE_POISON = 1;
VUHDO_DEBUFF_TYPE_DISEASE = 2;
VUHDO_DEBUFF_TYPE_MAGIC = 3;
VUHDO_DEBUFF_TYPE_CURSE = 4;
VUHDO_DEBUFF_TYPE_CUSTOM = 6;
VUHDO_DEBUFF_TYPE_MISSING_BUFF = 7;



--
VUHDO_INIT_DEBUFF_ABILITIES = {
	["WARRIOR"] = { },
	["ROGUE"] = { },
	["HUNTER"] = { },
	["MAGE"] = { 
		[VUHDO_DEBUFF_TYPE_CURSE] = { VUHDO_SPELL_ID.REMOVE_LESSER_CURSE },
	},
	["DRUID"] = {
		[VUHDO_DEBUFF_TYPE_POISON] = { VUHDO_SPELL_ID.ABOLISH_POISON, VUHDO_SPELL_ID.CURE_POISON_DRUID },
		[VUHDO_DEBUFF_TYPE_CURSE] = { VUHDO_SPELL_ID.REMOVE_CURSE },
	},
	["PALADIN"] = {
		[VUHDO_DEBUFF_TYPE_POISON] = { VUHDO_SPELL_ID.PURIFY, VUHDO_SPELL_ID.PALA_CLEANSE },
		[VUHDO_DEBUFF_TYPE_DISEASE] = { VUHDO_SPELL_ID.PURIFY, VUHDO_SPELL_ID.PALA_CLEANSE },
		[VUHDO_DEBUFF_TYPE_MAGIC] = { VUHDO_SPELL_ID.PALA_CLEANSE },
	},
	["PRIEST"] = {
		[VUHDO_DEBUFF_TYPE_DISEASE] = { VUHDO_SPELL_ID.ABOLISH_DISEASE, VUHDO_SPELL_ID.CURE_DISEASE_PRIEST },
		[VUHDO_DEBUFF_TYPE_MAGIC] = { VUHDO_SPELL_ID.DISPEL_MAGIC },
	},
	["SHAMAN"] = {
		[VUHDO_DEBUFF_TYPE_DISEASE] = { VUHDO_SPELL_ID.CURE_DISEASE_SHAMAN },
		[VUHDO_DEBUFF_TYPE_POISON] = { VUHDO_SPELL_ID.CURE_POISON_SHAMAN },
	},
	["WARLOCK"] = {
		[VUHDO_DEBUFF_TYPE_MAGIC] = { "*" },
	},
	["DEATHKNIGHT"] = { },
	["MONK"] ={ },
	["DEMONHUNTER"] = { },
};



VUHDO_SPEC_TO_DEBUFF_ABIL = { };



VUHDO_INIT_IGNORE_DEBUFFS_BY_CLASS = {
	["WARRIOR"] = {
		[VUHDO_SPELL_ID.DEBUFF_ANCIENT_HYSTERIA] = true,
		[VUHDO_SPELL_ID.DEBUFF_IGNITE_MANA] = true,
		[VUHDO_SPELL_ID.DEBUFF_TAINTED_MIND] = true,
		[VUHDO_SPELL_ID.DEBUFF_VIPER_STING] = true,
		[VUHDO_SPELL_ID.DEBUFF_IMPOTENCE] = true,
		[VUHDO_SPELL_ID.DEBUFF_DECAYED_INT] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
	["ROGUE"] = {
		[VUHDO_SPELL_ID.DEBUFF_SILENCE] = true,
		[VUHDO_SPELL_ID.DEBUFF_ANCIENT_HYSTERIA] = true,
		[VUHDO_SPELL_ID.DEBUFF_IGNITE_MANA] = true,
		[VUHDO_SPELL_ID.DEBUFF_TAINTED_MIND] = true,
		[VUHDO_SPELL_ID.DEBUFF_VIPER_STING] = true,
		[VUHDO_SPELL_ID.DEBUFF_IMPOTENCE] = true,
		[VUHDO_SPELL_ID.DEBUFF_DECAYED_INT] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
		[VUHDO_SPELL_ID.DEBUFF_SONIC_BURST] = true,
	},
	["HUNTER"] = {
		[VUHDO_SPELL_ID.DEBUFF_MAGMA_SHACKLES] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
		[VUHDO_SPELL_ID.DEBUFF_SONIC_BURST] = true,
	},
	["MAGE"] = {
		[VUHDO_SPELL_ID.DEBUFF_MAGMA_SHACKLES] = true,
		[VUHDO_SPELL_ID.DEBUFF_DECAYED_STR] = true,
		[VUHDO_SPELL_ID.DEBUFF_CRIPPLE] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
--		[(GetSpellInfo(87923))] = true, -- MOP okay Wind Blast
	},
	["DRUID"] = {
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
	["PALADIN"] = {
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
	["PRIEST"] = {
		[VUHDO_SPELL_ID.DEBUFF_DECAYED_STR] = true,
		[VUHDO_SPELL_ID.DEBUFF_CRIPPLE] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
--		[(GetSpellInfo(87923))] = true, -- MOP okay Wind Blast
	},
	["SHAMAN"] = {
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
	["WARLOCK"] = {
		[VUHDO_SPELL_ID.DEBUFF_DECAYED_STR] = true,
		[VUHDO_SPELL_ID.DEBUFF_CRIPPLE] = true,
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
--		[(GetSpellInfo(87923))] = true, -- MOP okay Wind Blast
	},
	["DEATHKNIGHT"] = {
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
	["MONK"] = {
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
	["DEMONHUNTER"] = {
		[VUHDO_SPELL_ID.DEBUFF_UNSTABLE_AFFL] = true,
	},
};



--
VUHDO_INIT_IGNORE_DEBUFFS_MOVEMENT = {
	[VUHDO_SPELL_ID.DEBUFF_FROSTBOLT] = true,
	[VUHDO_SPELL_ID.DEBUFF_MAGMA_SHACKLES] = true,
	[VUHDO_SPELL_ID.DEBUFF_SLOW] = true,
	[VUHDO_SPELL_ID.DEBUFF_CHILLED] = true,
	[VUHDO_SPELL_ID.DEBUFF_CONEOFCOLD] = true,
	[VUHDO_SPELL_ID.DEBUFF_CONCUSSIVESHOT] = true,
	[VUHDO_SPELL_ID.DEBUFF_THUNDERCLAP] = true,
	[VUHDO_SPELL_ID.DEBUFF_DAZED] = true,
	[VUHDO_SPELL_ID.DEBUFF_FROST_SHOCK] = true,
	[VUHDO_SPELL_ID.FROSTBOLT_VOLLEY] = true,
--	[(GetSpellInfo(88184))] = true, -- MOP okay Lethargic Poison
--	[(GetSpellInfo(87759))] = true, -- MOP okay Shockwave
--	[(GetSpellInfo(88075))] = true, -- MOP okay Typhoon
--	[(GetSpellInfo(90938))] = true, -- MOP okay Bloodbolt
--	[(GetSpellInfo(92007))] = true, -- MOP okay Swirling Vapor
--	[(GetSpellInfo(88169))] = true, -- MOP okay Frost Blossom
--	[(GetSpellInfo(87861))] = true, -- MOP okay Fists of Frost
--	[(GetSpellInfo(83776))] = true, -- MOP okay Dragon's Breath
--	[(GetSpellInfo(7964))] = true, --  MOP okay Smoke Bomb
--	[(GetSpellInfo(83785))] = true, -- MOP okay Shockwave
--	[(GetSpellInfo(81630))] = true, -- MOP okay Viscous Poison
--	[(GetSpellInfo(82764))] = true, -- MOP okay Wing Clip
--	[(GetSpellInfo(76825))] = true, -- MOP okay Ice Blast
--	[(GetSpellInfo(73963))] = true, -- MOP okay Blinding Toxin
--	[(GetSpellInfo(76508))] = true, -- MOP okay Frostbolt
--	[(GetSpellInfo(76682))] = true, -- MOP okay Frostbomb
--	[(GetSpellInfo(12611))] = true, -- MOP okay Cone of Cold
--	[(GetSpellInfo(76094))] = true, -- MOP okay Curse of Fatigue
--	[(GetSpellInfo(76604))] = true, -- MOP okay Void Rip
};



--
VUHDO_INIT_IGNORE_DEBUFFS_DURATION = {
	[VUHDO_SPELL_ID.DEBUFF_PSYCHIC_HORROR] = true,
	[VUHDO_SPELL_ID.DEBUFF_CHILLED] = true,
	[VUHDO_SPELL_ID.DEBUFF_CONEOFCOLD] = true,
	[VUHDO_SPELL_ID.DEBUFF_CONCUSSIVESHOT] = true,
	[VUHDO_SPELL_ID.DEBUFF_FALTER] = true,
--	[(GetSpellInfo(87759))] = true, -- MOP okay Shockwave
--	[(GetSpellInfo(90938))] = true, -- MOP okay Bloodbolt
--	[(GetSpellInfo(92007))] = true, -- MOP pkay Swirling Vapor
--	[(GetSpellInfo(83776))] = true, -- MOP okay Dragon's Breath
--	[(GetSpellInfo(7964))] = true, -- MOP okay Smoke Bomb
--	[(GetSpellInfo(83785))] = true, -- MOP okay Shockwave
--	[(GetSpellInfo(81630))] = true, -- MOP okay Viscous Poison
--	[(GetSpellInfo(82670))] = true, -- MOP okay Skull Crack
--	[(GetSpellInfo(73963))] = true, -- MOP okay Blinding Toxin
--	[(GetSpellInfo(76508))] = true, -- MOP okay Frostbolt
--	[(GetSpellInfo(76185))] = true, -- MOP okay Stone Blow
};



VUHDO_INIT_IGNORE_DEBUFFS_NO_HARM = {
	[VUHDO_SPELL_ID.DEBUFF_HUNTERS_MARK] = true,
	[VUHDO_SPELL_ID.DEBUFF_ARCANE_CHARGE] = true,
	[VUHDO_SPELL_ID.DEBUFF_MAJOR_DREAMLESS] = true,
	[VUHDO_SPELL_ID.DEBUFF_GREATER_DREAMLESS] = true,
	[VUHDO_SPELL_ID.DEBUFF_DREAMLESS_SLEEP] = true,
	[VUHDO_SPELL_ID.MISDIRECTION] = true,
	[VUHDO_SPELL_ID.DEBUFF_DELUSIONS_OF_JINDO] = true,
	[VUHDO_SPELL_ID.DEBUFF_MIND_VISION] = true,
	[VUHDO_SPELL_ID.DEBUFF_MUTATING_INJECTION] = true,
	[VUHDO_SPELL_ID.DEBUFF_BANISH] = true,
	[VUHDO_SPELL_ID.DEBUFF_PHASE_SHIFT] = true,
--	[(GetSpellInfo(41425))] = true, -- Hypothermia
--	[(GetSpellInfo(123981))] = true, -- Perdition
--	[(GetSpellInfo(53753))] = true, -- Nightmare Slumber
--	[(GetSpellInfo(78993))] = true, -- Concentration
--	[(GetSpellInfo(105701))] = true, -- Potion of Focus
--	[(GetSpellInfo(57724))] = true, -- Sated
--	[(GetSpellInfo(57723))] = true, -- Exhaustion
--	[(GetSpellInfo(80354))] = true, -- Temporal Displacement
--	[(GetSpellInfo(95809))] = true, -- Insanity
--	[(GetSpellInfo(12292))] = true, -- Bloodbath
};

