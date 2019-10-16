--
local UnitPower = UnitPower;
local pairs = pairs;
local ipairs = ipairs;
local floor = floor;
local twipe = table.wipe;
local select = select;
local _;

local sIsIncoming;
local sIsCooldown;
local sIsIncCastTimeOnly;
local sIsPerGroup;

local VUHDO_AOE_FOR_UNIT = { };

local VUHDO_getCustomDestCluster;
local VUHDO_RAID;
function VUHDO_aoeAdvisorInitLocalOverrides()
	VUHDO_getCustomDestCluster = _G["VUHDO_getCustomDestCluster"];
	sIsIncoming = VUHDO_CONFIG["AOE_ADVISOR"]["subInc"];
	sIsCooldown = VUHDO_CONFIG["AOE_ADVISOR"]["isCooldown"];
	sIsIncCastTimeOnly = VUHDO_CONFIG["AOE_ADVISOR"]["subIncOnlyCastTime"];
	sIsPerGroup = VUHDO_CONFIG["AOE_ADVISOR"]["isGroupWise"];

	VUHDO_RAID = _G["VUHDO_RAID"];
end



local VUHDO_SPELL_ID_COH = 34861;
local VUHDO_SPELL_ID_POH = 596;
local VUHDO_SPELL_ID_CH = 1064;
local VUHDO_SPELL_ID_WG = 48438;
local VUHDO_SPELL_ID_TQ = 740;
local VUHDO_SPELL_ID_LOD = 85222;
local VUHDO_SPELL_ID_HR = 82327;
local VUHDO_SPELL_ID_CB = 123986;

VUHDO_AOE_SPELLS = {

	-- Circle of Healing
	["coh"] = {
		--["present"] = false,
		["id"] = VUHDO_SPELL_ID_COH,
		["base"] = (4599 + 5082) * 0.5, -- MOPok
		["divisor"] = 10365,
		["icon"] = (GetSpellTexture(VUHDO_SPELL_ID_COH)),
		["name"] = (GetSpellInfo(VUHDO_SPELL_ID_COH)),
		["avg"] = 0,
		["max_targets"] = 5,
		["degress"] = 1,
		["rangePow"] = 30 * 30, -- MOPok
		["isRadial"] = true,
		["areTargetsRandom"] = true,
		--["isSourcePlayer"] = false,
		["isDestRaid"] = true,
		["thresh"] = 15000,
		["cone"] = 360,
		["checkCd"] = true,
		["time"] = select(7, GetSpellInfo(VUHDO_SPELL_ID_COH)) or 0,
	},

	-- Prayer of Healing
	["poh"] = {
		--["present"] = false,
		["id"] = VUHDO_SPELL_ID_POH,
		["base"] = (8450 + 8927) * 0.5, -- MOP
		["divisor"] = 10368,
		["icon"] = (GetSpellTexture(VUHDO_SPELL_ID_POH)),
		["name"] = (GetSpellInfo(VUHDO_SPELL_ID_POH)),
		["avg"] = 0,
		["max_targets"] = 5,
		["degress"] = 1,
		["rangePow"] = 20 * 20,
		["isRadial"] = true,
		["areTargetsRandom"] = true,
		--["isSourcePlayer"] = false,
		["isDestRaid"] = false,
		["thresh"] = 20000,
		["cone"] = 360,
		--["checkCd"] = false,
		["time"] = select(7, GetSpellInfo(VUHDO_SPELL_ID_POH)) or 0,
	},

	-- Chain Heal
	["ch"] = {
		--["present"] = false,
		["id"] = VUHDO_SPELL_ID_CH,
		["base"] = (5135  + 5865) * 0.5, -- MOP
		["divisor"] = 10035,
		["icon"] = (GetSpellTexture(VUHDO_SPELL_ID_CH)),
		["name"] = (GetSpellInfo(VUHDO_SPELL_ID_CH)),
		["avg"] = 0,
		["max_targets"] = 4,
		["degress"] = 0.66,
		["rangePow"] = 40 * 40,
		["jumpRangePow"] = 11 * 11,
		--["isRadial"] = false,
		["areTargetsRandom"] = false,
		--["isSourcePlayer"] = false,
		["isDestRaid"] = true,
		["thresh"] = 15000,
		["cone"] = 360,
		--["checkCd"] = false,
		["time"] = select(7, GetSpellInfo(VUHDO_SPELL_ID_CH)) or 0,
	},

	-- Wild Growth
	["wg"] = {
		--["present"] = false,
		["id"] = VUHDO_SPELL_ID_WG,
		["base"] = 6930,
		["divisor"] = 9345, -- MOP
		["icon"] = (GetSpellTexture(VUHDO_SPELL_ID_WG)),
		["name"] = (GetSpellInfo(VUHDO_SPELL_ID_WG)),
		["avg"] = 0,
		["max_targets"] = 6,
		["degress"] = 1,
		["rangePow"] = 30 * 30,
		["isRadial"] = true,
		["areTargetsRandom"] = true,
		--["isSourcePlayer"] = false,
		["isDestRaid"] = true,
		["thresh"] = 15000,
		["cone"] = 360,
		["checkCd"] = true,
		["time"] = select(7, GetSpellInfo(VUHDO_SPELL_ID_WG)) or 0,
	},

	-- Tranqulity
	["tq"] = {
		--["present"] = false,
		["id"] = VUHDO_SPELL_ID_TQ,
		["base"] = 9037, -- MOP
		["divisor"] = 9345,
		["icon"] = (GetSpellTexture(VUHDO_SPELL_ID_TQ)),
		["name"] = (GetSpellInfo(VUHDO_SPELL_ID_TQ)),
		["avg"] = 0,
		["max_targets"] = 40,
		["degress"] = 1,
		["rangePow"] = 40 * 40,
		["isRadial"] = true,
		["areTargetsRandom"] = false,
		["isSourcePlayer"] = true,
		["isDestRaid"] = true,
		["thresh"] = 15000,
		["cone"] = 360,
		["checkCd"] = true,
		["time"] = select(7, GetSpellInfo(VUHDO_SPELL_ID_TQ)) or 0,
	},

	-- Light of Dawn
	["lod"] = {
		--["present"] = false,
		["id"] = VUHDO_SPELL_ID_LOD,
		["base"] = (2027 + 2257) * 3 * 0.5, -- MOP
		["divisor"] = 4859,
		["icon"] = (GetSpellTexture(VUHDO_SPELL_ID_LOD)),
		["name"] = (GetSpellInfo(VUHDO_SPELL_ID_LOD)),
		["avg"] = 0,
		["max_targets"] = 5,
		["degress"] = 1,
		["rangePow"] = 30 * 30,
		["isRadial"] = true,
		["areTargetsRandom"] = true,
		["isSourcePlayer"] = true,
		["isDestRaid"] = true,
		["thresh"] = 8000,
		["cone"] = 180,
		--["checkCd"] = false,
		["time"] = select(7, GetSpellInfo(VUHDO_SPELL_ID_LOD)) or 0,
	},

	-- Chi Burst
	["cb"] = {
		--["present"] = false,
		["id"] = VUHDO_SPELL_ID_CB,
		["base"] = (325 + 972) * 0.5,
		["divisor"] = 1.267, -- 1/78,9% Atk
		["icon"] = (GetSpellTexture(VUHDO_SPELL_ID_CB)),
		["name"] = (GetSpellInfo(VUHDO_SPELL_ID_CB)),
		["avg"] = 0,
		["max_targets"] = 6,
		["degress"] = 1,
		["rangePow"] = 4, -- not POW actually
		--["isRadial"] = true,
		["areTargetsRandom"] = false,
		["isLinear"] = true,
		["isSourcePlayer"] = true,
		["isDestRaid"] = true,
		["thresh"] = 10000,
		["isHealsPlayer"] = true,
		--["cone"] = 15,
		["checkCd"] = true,
		["time"] = select(7, GetSpellInfo(VUHDO_SPELL_ID_CB)) or 0,
	},
};
local VUHDO_AOE_SPELLS = VUHDO_AOE_SPELLS;



--
local tAltPower;
local function VUHDO_getPlayerHealingMod()
	if "PALADIN" == VUHDO_PLAYER_CLASS then
		tAltPower = UnitPower("player", 9);
		if (tAltPower or 6) ~= 6 then
			return 1 / (6 - tAltPower);
		end
	end

	return 1;
end



--
function VUHDO_aoeUpdateSpellAverages()
	local tBonus = GetSpellBonusHealing();
	local tSpellModi;

	for tName, tInfo in pairs(VUHDO_AOE_SPELLS) do
		if "cb" == tName then
			tInfo["avg"] = 80000; -- @TODO
		else
			tSpellModi = tInfo["base"] / tInfo["divisor"];
			tInfo["avg"] = floor((tInfo["base"] + tBonus * tSpellModi) + 0.5);
		end
		tInfo["thresh"] = VUHDO_CONFIG["AOE_ADVISOR"]["config"][tName]["thresh"];
		--print("VUHDO_aoeUpdateSpellAverages(): name = " .. tName .. ", avg = floor((base + bonus * spellMod) + 0.5) | " .. tInfo["avg"] .. " = floor((" .. tInfo["base"] .. " + " .. tBonus .. " * " .. tSpellModi .. ") + 0.5)");
	end
end



--
local function VUHDO_isAoeSpellEnabled(aSpell)
	if not VUHDO_CONFIG["AOE_ADVISOR"]["config"][aSpell]["enable"] then
		return false;
	elseif not VUHDO_CONFIG["AOE_ADVISOR"]["knownOnly"] then
		return true;
	else
		if VUHDO_AOE_SPELLS[aSpell]["name"] then
			return VUHDO_isSpellKnown(VUHDO_AOE_SPELLS[aSpell]["name"]);
		else
			return false;
		end
	end
end



--
function VUHDO_aoeUpdateTalents()
	for tName, tInfo in pairs(VUHDO_AOE_SPELLS) do
		tInfo["present"] = VUHDO_isAoeSpellEnabled(tName);
	end

	VUHDO_aoeUpdateSpellAverages();
end



--
local function VUHDO_aoeGetIncHeals(aUnit, aCastTime)
	if not sIsIncoming or (sIsIncCastTimeOnly and aCastTime == 0) then
		return 0;
	end

	return (VUHDO_unitGetIncomingHeals(aUnit) or 0) - (VUHDO_unitGetIncomingHeals(aUnit, "player") or 0);
end



--
local function VUHDO_getAverageExpectedHeals(aCluster, aMaxHealAmount, aDegression, aCastTime, aMaxTargets, tTargetPlayer)
	local tHealingTotal = 0;
	local tNumPlayersHealed = 0;

	-- Find the sum total healed
	for tCnt = 1, #aCluster do
		local tUnit = aCluster[tCnt];
		local tInfo = VUHDO_RAID[tUnit];

		if tInfo["healthmax"] > 0 and tInfo["health"] > 0 then
			local tHPDeficit = tInfo["healthmax"] - tInfo["health"] - VUHDO_aoeGetIncHeals(tUnit, aCastTime);
			local tHealingDonePotential = aMaxHealAmount + (1 - tInfo["health"] / tInfo["healthmax"]); -- Give slight priority to users with the least HP%
			local tHealingDoneActual = math.min(tHPDeficit, tHealingDonePotential);
			tHealingTotal = tHealingTotal + tHealingDoneActual;
			tNumPlayersHealed = tNumPlayersHealed + 1;
		end
	end
	if tHealingTotal == 0 or tNumPlayersHealed == 0 then
		return 0;
	end
	
	-- Find out how much the aDegression multiplier has reduced our expected heals.
	-- The heal-amount gets multiplied by aDegression on each jump.  So the average degression multiplier is
	-- (1 + 1*aDegression + 1*aDegression^2 + ... + 1*aDegression^(tNumHealTargets-1))/tNumHealTargets
	-- This is a geometric series, equal to the following:
	local tNumHealTargets = math.min(aMaxTargets, tNumPlayersHealed)
	local tDegressionAverage = 1;
	if aDegression < 1 then
		tDegressionAverage = (1-aDegression^tNumHealTargets)/((1-aDegression)*tNumHealTargets);
	end
	
	--Find the average expected healed
	local tAverageHealedPerPlayer = tHealingTotal / tNumPlayersHealed;
	return tAverageHealedPerPlayer * tNumHealTargets * tDegressionAverage;
end

--
local tBestUnit, tBestTotal;
local tCurrTotal;
local tCluster = { };
local tInfo;

local tIsSourcePlayer;
local tIsDestRaid;
local tIsRadial;
local tIsLinear;
local tRangePow;
local tJumpRangePow;
local tMaxTargets;
local tCdSpell;
local tCone;
local tSpellHeal;
local tTime;
local tDegress;
local tThresh;
local tIsHealsPlayer;
local tAreTargetsRandom;



local function VUHDO_getBestUnitForAoeGroup(anAoeInfo, aPlayerModi, aGroup)
	tBestUnit = nil;
	tBestTotal = -1;

	for tCnt = 1, #aGroup do
		tInfo = aGroup[tCnt];
		if VUHDO_RAID[tInfo] then	tInfo = VUHDO_RAID[tInfo]; end

		if tInfo["baseRange"] and tInfo["health"] > 0 then
			if tIsLinear then
				VUHDO_getUnitsInLinearCluster(tInfo["unit"], tCluster, tRangePow, tMaxTargets, tIsHealsPlayer, tCdSpell);
			else
				VUHDO_getCustomDestCluster(tInfo["unit"], tCluster,
					tIsSourcePlayer, tIsRadial, tRangePow,
					tMaxTargets, 101, tIsDestRaid, -- 101% = no health limit
					tCdSpell,	tCone, tJumpRangePow, tAreTargetsRandom
				);
			end

			if #tCluster > 1 then
				tCurrTotal = VUHDO_getAverageExpectedHeals(tCluster, tSpellHeal, tDegress, tTime, tMaxTargets, tInfo["unit"]);

				if tCurrTotal > tBestTotal and tCurrTotal >= tThresh then
					tBestTotal = tCurrTotal;
					tBestUnit = tInfo["unit"];
				end
			end

		end
	end

	return tBestUnit, tBestTotal;
end



--
local tSingleUnit = {
	[0] = { }
};

local tGroupUnit = {
	[1] = { }, [2] = { }, [3] = { }, [4] = { }, [5] = { }, [6] = { }, [7] = { }, [8] = { }
};

local function VUHDO_getBestUnitsForAoe(anAoeInfo, aPlayerModi)
	tIsSourcePlayer = anAoeInfo["isSourcePlayer"];
	tIsDestRaid = anAoeInfo["isDestRaid"];
	tIsRadial = anAoeInfo["isRadial"];
	tIsLinear = anAoeInfo["isLinear"];
	tRangePow = anAoeInfo["rangePow"];
	tJumpRangePow = anAoeInfo["jumpRangePow"];
	tMaxTargets = anAoeInfo["max_targets"];
	tCdSpell = sIsCooldown and anAoeInfo["checkCd"] and anAoeInfo["name"] or nil;
	tCone = anAoeInfo["cone"];
	tSpellHeal = anAoeInfo["avg"] * aPlayerModi;
	tTime = anAoeInfo["time"];
	tDegress = anAoeInfo["degress"];
	tThresh = anAoeInfo["thresh"];
	tIsHealsPlayer = anAoeInfo["isHealsPlayer"];
	tAreTargetsRandom = anAoeInfo["areTargetsRandom"];
	--tThresh = 1000;

	if sIsPerGroup and not tIsDestRaid then
		for tCnt = 1, 8 do
			tGroupUnit[tCnt]["u"], tGroupUnit[tCnt]["h"] = VUHDO_getBestUnitForAoeGroup(anAoeInfo, aPlayerModi, VUHDO_GROUPS[tCnt]);
		end
		return tGroupUnit;
	else
		tSingleUnit[0]["u"], tSingleUnit[0]["h"] = VUHDO_getBestUnitForAoeGroup(anAoeInfo, aPlayerModi, VUHDO_CLUSTER_BASE_RAID);
		return tSingleUnit;
	end
end



--
local tUnitForAoe = { [0] = {}, [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {}, [6] = {}, [7] = {}, [8] = {} };
local function VUHDO_setBestUnitsForAoeInGroups(anAoeName, aGroupNum, aUnit, anAoeHealed, ...)
	for tCnt = 1, select('#', ...) do
		if (tUnitForAoe[select(tCnt, ...)][aUnit] or 0) >= anAoeHealed then
			return;
		end
	end

	tUnitForAoe[aGroupNum][aUnit] = anAoeHealed;
	VUHDO_AOE_FOR_UNIT[aUnit] = VUHDO_AOE_SPELLS[anAoeName];
end



--
local tUnit;
local tPlayerModi;
local tBestUnits;
local tOldAoeForUnit = {};
local tAoeChangedForUnit = { };
function VUHDO_aoeUpdateAll()
	if not VUHDO_INTERNAL_TOGGLES[32] then return; end -- VUHDO_UPDATE_AOE_ADVICE

	tPlayerModi = VUHDO_getPlayerHealingMod();

	for tCnt = 0, 8 do twipe(tUnitForAoe[tCnt]); end

	twipe(tOldAoeForUnit);
	for tUnit, tAoeSpell in pairs(VUHDO_AOE_FOR_UNIT) do tOldAoeForUnit[tUnit] = tAoeSpell; end
	twipe(VUHDO_AOE_FOR_UNIT);

	for tName, tInfo in pairs(VUHDO_AOE_SPELLS) do
		if tInfo["present"] then
			tBestUnits = VUHDO_getBestUnitsForAoe(tInfo, tPlayerModi);

			for tIndex, tUnitInfo in pairs(tBestUnits) do

				tUnit = tUnitInfo["u"];
				if tUnit then
					if 0 == tIndex then -- raid wide => best units in all groups or the raid?
						VUHDO_setBestUnitsForAoeInGroups(tName, tIndex, tUnit, tUnitInfo["h"], 0, 1, 2, 3, 4, 5, 6, 7, 8);
					else -- per group => best units in this group or the raid?
						VUHDO_setBestUnitsForAoeInGroups(tName, tIndex, tUnit, tUnitInfo["h"], 0, tIndex);
					end
				end

			end
		end
	end

	twipe(tAoeChangedForUnit);
	for tUnit, tAoeSpell in pairs(tOldAoeForUnit) do
		if VUHDO_AOE_FOR_UNIT[tUnit] ~= tAoeSpell then tAoeChangedForUnit[tUnit] = true; end
	end
	for tUnit, tAoeSpell in pairs(VUHDO_AOE_FOR_UNIT) do
		if tOldAoeForUnit[tUnit] ~= tAoeSpell then tAoeChangedForUnit[tUnit] = true; end
	end

	for tUnit, _ in pairs(tAoeChangedForUnit) do
		VUHDO_updateBouquetsForEvent(tUnit, VUHDO_UPDATE_AOE_ADVICE);
	end
end



--
function VUHDO_getAoeAdviceForUnit(aUnit)
	return VUHDO_AOE_FOR_UNIT[aUnit];
end
