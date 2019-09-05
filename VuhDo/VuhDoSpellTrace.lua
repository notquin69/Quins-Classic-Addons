local pairs = pairs;
local tostring = tostring;
local tonumber = tonumber;
local tinsert = table.insert;
local twipe = table.wipe;

local VUHDO_ACTIVE_TRACE_SPELLS = { 
	-- [<unit GUID>] = {
	--	["latest"] = <latest trace spell ID>,
	--	["spells"] = {
	--		[<spell ID>] = {
	--			["icon"] = <spell icon>,
	--			["startTime"] = <epoch time event received>,
	--		},
	--	},
	-- },
};

local VUHDO_TRAIL_OF_LIGHT_SPELL_ID = 200128;
local VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT = { };

local sIsPlayerKnowsTrailOfLight = false;
local sCurrentPlayerTrailOfLight = nil;
local sTrailOfLightIcon = nil;



--
local VUHDO_PLAYER_GUID = -1;
local VUHDO_RAID_GUIDS = { };
local VUHDO_INTERNAL_TOGGLES = { };
local sShowSpellTrace = nil;
local sShowTrailOfLight = nil;
local sSpellTraceStoredSettings = nil;
local sSpellTraceDefaultDuration = nil;
function VUHDO_spellTraceInitLocalOverrides()

	VUHDO_PLAYER_GUID = UnitGUID("player");
	VUHDO_RAID_GUIDS = _G["VUHDO_RAID_GUIDS"];
	VUHDO_INTERNAL_TOGGLES = _G["VUHDO_INTERNAL_TOGGLES"];

	sShowSpellTrace = VUHDO_CONFIG["SHOW_SPELL_TRACE"];
	sSpellTraceStoredSettings = VUHDO_CONFIG["SPELL_TRACE"]["STORED_SETTINGS"];
	sSpellTraceDefaultDuration = VUHDO_CONFIG["SPELL_TRACE"]["duration"];
	sShowTrailOfLight = VUHDO_CONFIG["SPELL_TRACE"]["showTrailOfLight"];

	VUHDO_setKnowsTrailOfLight(VUHDO_isTalentKnown(VUHDO_SPELL_ID.TRAIL_OF_LIGHT));

end



--
function VUHDO_setKnowsTrailOfLight(aKnowsTrailOfLight)

	sIsPlayerKnowsTrailOfLight = aKnowsTrailOfLight;

	if aKnowsTrailOfLight then
		_, _, sTrailOfLightIcon = GetSpellInfo(VUHDO_TRAIL_OF_LIGHT_SPELL_ID);
	else
		twipe(VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT);

		local tPreviousPlayerTrailOfLight = sCurrentPlayerTrailOfLight;
		sCurrentPlayerTrailOfLight = nil;

		if tPreviousPlayerTrailOfLight and VUHDO_RAID_GUIDS[tPreviousPlayerTrailOfLight] then
			VUHDO_updateBouquetsForEvent(
				VUHDO_RAID_GUIDS[tPreviousPlayerTrailOfLight],
				VUHDO_UPDATE_SPELL_TRACE
			);
		end

		VUHDO_updateBouquetsForEvent("target", VUHDO_UPDATE_SPELL_TRACE);
		VUHDO_updateBouquetsForEvent("focus", VUHDO_UPDATE_SPELL_TRACE);
	end

end



--
function VUHDO_parseCombatLogSpellTrace(aMessage, aSrcGuid, aDstGuid, aSpellName, aSpellId, anAmount)

	-- ensure table keys are always strings
	local tSpellId = tostring(aSpellId);

	if not VUHDO_INTERNAL_TOGGLES[37] or not sShowSpellTrace or 
		(aMessage ~= "SPELL_HEAL" and aMessage ~= "SPELL_PERIODIC_HEAL") then
		return;
	end

	-- special tracking for Holy Priest "Trail of Light"
	if sShowTrailOfLight and sIsPlayerKnowsTrailOfLight and 
		aSrcGuid == VUHDO_PLAYER_GUID and 
		(aSpellName == VUHDO_SPELL_ID.FLASH_HEAL or aSpellName == VUHDO_SPELL_ID.HEAL) then
		if not VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT[1] or 
			(VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT[1] and VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT[1][2] ~= aDstGuid) then
			tinsert(
				VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT, 
				{
					anAmount,
					aDstGuid
				}
			);
		end

		local flashHeal1 = VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT[1];
		local flashHeal2 = VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT[2];

		if flashHeal1 and flashHeal2 then
			local tPreviousPlayerTrailOfLight = sCurrentPlayerTrailOfLight;

			sCurrentPlayerTrailOfLight = flashHeal1[2];

			tremove(VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT, 2);
			VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT[1] = flashHeal2;

			if VUHDO_RAID_GUIDS[sCurrentPlayerTrailOfLight] then
				VUHDO_updateBouquetsForEvent(
					VUHDO_RAID_GUIDS[sCurrentPlayerTrailOfLight], 
					VUHDO_UPDATE_SPELL_TRACE
				);
			end

			if tPreviousPlayerTrailOfLight and 
				tPreviousPlayerTrailOfLight ~= sCurrentPlayerTrailOfLight and 
				VUHDO_RAID_GUIDS[tPreviousPlayerTrailOfLight] then
				VUHDO_updateBouquetsForEvent(
					VUHDO_RAID_GUIDS[tPreviousPlayerTrailOfLight],
					VUHDO_UPDATE_SPELL_TRACE
				);
			end

			VUHDO_updateBouquetsForEvent("target", VUHDO_UPDATE_SPELL_TRACE);
			VUHDO_updateBouquetsForEvent("focus", VUHDO_UPDATE_SPELL_TRACE);
		end
	end

	-- spells can be traced by name or spell ID
	if not sSpellTraceStoredSettings[tSpellId] then
		tSpellId = aSpellName;

		if not sSpellTraceStoredSettings[tSpellId] then
			return;
		end
	end

	if not VUHDO_RAID_GUIDS[aDstGuid] or 
		(aSrcGuid ~= VUHDO_PLAYER_GUID and not sSpellTraceStoredSettings[tSpellId]["isOthers"]) or 
		(aSrcGuid == VUHDO_PLAYER_GUID and not sSpellTraceStoredSettings[tSpellId]["isMine"]) then
		return;
	end

	if not VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid] or not VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["spells"] or 
		not VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["spells"][tSpellId] then
		local tName, _, tIcon = GetSpellInfo(aSpellId);

		if not tName then
			return;
		end

		if not VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid] then
			VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid] = { 
				["spells"] = { },
			};
		end

		VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["spells"][tSpellId] = {
			["icon"] = tIcon,
		};
	end

	VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["spells"][tSpellId]["startTime"] = GetTime();

	VUHDO_ACTIVE_TRACE_SPELLS[aDstGuid]["latest"] = tSpellId;

	VUHDO_updateBouquetsForEvent(VUHDO_RAID_GUIDS[aDstGuid], VUHDO_UPDATE_SPELL_TRACE);

end



--
function VUHDO_updateSpellTrace()

	for tUnitGuid, tActiveTrace in pairs(VUHDO_ACTIVE_TRACE_SPELLS) do
		local i = 0;
		local tActiveTraceSpells = tActiveTrace["spells"];
		local tCurrentTime = GetTime();

		for tSpellId, tActiveTraceSpell in pairs(tActiveTraceSpells) do
			if tActiveTraceSpell then
				local tDuration = tonumber(sSpellTraceStoredSettings[tSpellId]["duration"] or sSpellTraceDefaultDuration) or sSpellTraceDefaultDuration;

				local tRemaining = tDuration - (tCurrentTime - tActiveTraceSpell["startTime"]);

				if tRemaining <= 0 then
					VUHDO_ACTIVE_TRACE_SPELLS[tUnitGuid]["spells"][tSpellId] = nil;

					if tActiveTrace["latest"] == tSpellId then
						VUHDO_ACTIVE_TRACE_SPELLS[tUnitGuid]["latest"] = nil;
					end

					local tUnit = VUHDO_RAID_GUIDS[tUnitGuid];

					if tUnit then
						VUHDO_updateBouquetsForEvent(tUnit, VUHDO_UPDATE_SPELL_TRACE);
					end
				end

				i = i + 1;
			end
		end

		if i == 0 then
			VUHDO_ACTIVE_TRACE_SPELLS[tUnitGuid] = nil;
		end
	end

end



--
function VUHDO_getSpellTraceForUnit(aUnit)

	if not VUHDO_INTERNAL_TOGGLES[37] or not sShowSpellTrace or not aUnit then
		return;
	end

	local tUnitGuid = UnitGUID(aUnit);

	if not tUnitGuid or not VUHDO_ACTIVE_TRACE_SPELLS[tUnitGuid] then
		return;
	end

	local tLatestTraceSpellId = VUHDO_ACTIVE_TRACE_SPELLS[tUnitGuid]["latest"];

	if tLatestTraceSpellId then
		return VUHDO_ACTIVE_TRACE_SPELLS[tUnitGuid]["spells"][tLatestTraceSpellId];
	end

end



--
function VUHDO_getActiveSpellTraceSpells()

	return VUHDO_ACTIVE_TRACE_SPELLS;

end



--
function VUHDO_getSpellTraceTrailOfLight()

	return VUHDO_SPELL_TRACE_TRAIL_OF_LIGHT;

end



--
function VUHDO_getSpellTraceTrailOfLightForUnit(aUnit)

	if not VUHDO_INTERNAL_TOGGLES[37] or not sShowSpellTrace or 
		not sShowTrailOfLight or not sIsPlayerKnowsTrailOfLight or 
		not aUnit then
		return;
	end

	local tUnitGuid = UnitGUID(aUnit);

	if not tUnitGuid or tUnitGuid ~= sCurrentPlayerTrailOfLight then
		return;
	end

	return { ["icon"] = sTrailOfLightIcon, };

end

