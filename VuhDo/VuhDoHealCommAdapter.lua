----------------------------------------------------
local sIsOthers, sIsOwn, sIsNoInc;
function VUHDO_healCommAdapterInitLocalOverrides()
	sIsOthers = VUHDO_CONFIG["SHOW_INCOMING"];
	sIsOwn = VUHDO_CONFIG["SHOW_OWN_INCOMING"];
	sIsNoInc = not sIsOwn and not sIsOthers;
end
----------------------------------------------------


local VUHDO_INC_HEAL = { };



--
function VUHDO_getIncHealOnUnit(aUnit)
	return VUHDO_INC_HEAL[aUnit] or 0;
end



--
local tAllIncoming;
function VUHDO_determineIncHeal(aUnit)
	if sIsNoInc then return; end

	if sIsOthers then
		if sIsOwn then
			VUHDO_INC_HEAL[aUnit] = VUHDO_unitGetIncomingHeals(aUnit);
		else
			tAllIncoming = (VUHDO_unitGetIncomingHeals(aUnit) or 0) - (VUHDO_unitGetIncomingHeals(aUnit, "player") or 0);
			VUHDO_INC_HEAL[aUnit] = tAllIncoming < 0 and 0 or tAllIncoming;
		end
	else
		VUHDO_INC_HEAL[aUnit] = VUHDO_unitGetIncomingHeals(aUnit, "player");
	end
end
