local _;
--
local smatch = string.match;

local InCombatLockdown = InCombatLockdown;

local VUHDO_updateAllHoTs;
local VUHDO_updateAllCyclicBouquets;
local VUHDO_initGcd;
local VUHDO_strempty;

local VUHDO_ACTIVE_HOTS;
local VUHDO_RAID_NAMES;
local VUHDO_CONFIG = { };

local sIsShowGcd;
local sUniqueSpells = { };
local sFirstRes, sSecondRes, sThirdRes;
local sEmpty = { };


function VUHDO_spellEventHandlerInitLocalOverrides()
	VUHDO_updateAllHoTs = _G["VUHDO_updateAllHoTs"];
	VUHDO_updateAllCyclicBouquets = _G["VUHDO_updateAllCyclicBouquets"];
	VUHDO_initGcd = _G["VUHDO_initGcd"];
	VUHDO_strempty = _G["VUHDO_strempty"];

	VUHDO_ACTIVE_HOTS = _G["VUHDO_ACTIVE_HOTS"];
	VUHDO_RAID_NAMES = _G["VUHDO_RAID_NAMES"];
	VUHDO_CONFIG = _G["VUHDO_CONFIG"];

	sIsShowGcd = VUHDO_isShowGcd();

	table.wipe(sUniqueSpells);
	local tUnique, tUniqueCategs = VUHDO_getAllUniqueSpells();
	for _, tSpellName in pairs(tUnique) do
		sUniqueSpells[tSpellName] = tUniqueCategs[tSpellName];
	end

	sFirstRes, sSecondRes, sThirdRes = VUHDO_getResurrectionSpells();
end



--
function VUHDO_activateSpellForSpec(aSpecId)
	local tName = VUHDO_SPEC_LAYOUTS[aSpecId];
	if not VUHDO_strempty(tName) then
		if VUHDO_SPELL_LAYOUTS[tName] then VUHDO_activateLayout(tName);
		else VUHDO_Msg(format(VUHDO_I18N_SPELL_LAYOUT_NOT_EXIST, tName), 1, 0.4, 0.4); end
	end
end



--
function VUHDO_activateSpecc(aSpecNum)
	local tProfile = VUHDO_getBestProfileAfterSpecChange();
	if tProfile then VUHDO_loadProfile(tProfile); end
	VUHDO_activateSpellForSpec(aSpecNum);
	VUHDO_aoeUpdateTalents();
end



--
local tSpellName;
function VUHDO_spellcastSucceeded(aUnit, aSpellId)

	if "player" ~= aUnit and VUHDO_PLAYER_RAID_ID ~= aUnit then 
		return;
	end

	if aSpellId then
		tSpellName = GetSpellInfo(aSpellId);
	end

	if tSpellName and VUHDO_ACTIVE_HOTS[tSpellName] then
		VUHDO_updateAllHoTs();
		VUHDO_updateAllCyclicBouquets(true);
	end

	VUHDO_aoeUpdateAll();

end



--
local tTargetUnit;
local tCateg;
local tSpellName;
function VUHDO_spellcastSent(aUnit, aTargetName, aSpellId)
	if "player" ~= aUnit then 
		return;
	end

	if sIsShowGcd then 
		VUHDO_initGcd(); 
	end

	if aSpellId then
		tSpellName = GetSpellInfo(aSpellId);
	end

	if not tSpellName then
		return;
	end

	-- Resurrection?
	if tSpellName == sFirstRes or tSpellName == sSecondRes or tSpellName == sThirdRes then
		if aTargetName and not VUHDO_strempty(aTargetName) then 
			aTargetName = smatch(aTargetName, "^[^-]*");

			if not VUHDO_RAID_NAMES[aTargetName] then
				return;
			end
		end

		if VUHDO_CONFIG["RES_IS_SHOW_TEXT"] then
			local tChannel = (UnitInBattleground("player") or HasLFGRestrictions()) and "INSTANCE_CHAT"
				or IsInRaid() and "RAID" or IsInGroup() and "PARTY" or nil;

			if tChannel then
				SendChatMessage((gsub(VUHDO_strempty(aTargetName) and VUHDO_CONFIG["RES_ANNOUNCE_MASS_TEXT"] or VUHDO_CONFIG["RES_ANNOUNCE_TEXT"], "[Vv][Uu][Hh][Dd][Oo]", aTargetName or "")), tChannel);
			end
		end

		return;
	end

	if not aTargetName then return; end

	aTargetName = smatch(aTargetName, "^[^-]*");
	tTargetUnit = VUHDO_RAID_NAMES[aTargetName];

	if not tTargetUnit then return; end

	tCateg = sUniqueSpells[tSpellName];
	if tCateg and not InCombatLockdown()
		and (VUHDO_BUFF_SETTINGS or sEmpty)[tCateg] and aTargetName ~= VUHDO_BUFF_SETTINGS[tCateg]["name"] then

		VUHDO_BUFF_SETTINGS[tCateg]["name"] = aTargetName;
		VUHDO_reloadBuffPanel();
	end
end
