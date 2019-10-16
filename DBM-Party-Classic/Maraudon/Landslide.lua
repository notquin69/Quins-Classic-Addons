local mod	= DBM:NewMod(429, "DBM-Party-Classic", 8, 232)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20191001141144")
mod:SetCreatureID(12203)
mod:SetEncounterID(426)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 21808",
	"SPELL_CAST_SUCCESS 11130 5568"
)

--TODO, verify timers further, in classic timers are never very static
local warningLandSlide				= mod:NewSpellAnnounce(21808, 2)
local warningKnockAway				= mod:NewSpellAnnounce(11130, 2)
local warningTrample				= mod:NewSpellAnnounce(5568, 2)

local specWarnWrath					= mod:NewSpecialWarningInterrupt(21807, "HasInterrupt", nil, nil, 1, 2)

local timerLandslideCD				= mod:NewAITimer(180, 21808, 2, nil, nil, nil, 1)
local timerKnockAwayCD				= mod:NewCDTimer(15.9, 11130, nil, nil, nil, 2)
local timerTrampleCD				= mod:NewCDTimer(21.9, 5568, nil, nil, nil, 2)

function mod:OnCombatStart(delay)
	timerTrampleCD:Start(6-delay)--6
	timerKnockAwayCD:Start(9-delay)--9
	timerLandslideCD:Start(1-delay)
end

do
	local Landslide = DBM:GetSpellInfo(21808)
	function mod:SPELL_CAST_START(args)
		--if args.spellId == 21808 then
		if args.spellName == Landslide then
			warningLandSlide:Show()
			timerLandslideCD:Start()
		end
	end
end

do
	local KnockAway, Trample = DBM:GetSpellInfo(11130), DBM:GetSpellInfo(5568)
	function mod:SPELL_CAST_SUCCESS(args)
		--if args.spellId == 110762 or args.spellId == 11130 then--Retail, Classic (not confirmed, no actual data yet)
		if args.spellName == KnockAway then
			warningKnockAway:Show()
			timerKnockAwayCD:Start()
		--elseif args.spellId == 5568 then
		elseif args.spellName == Trample and args:IsSrcTypeHostile() then
			warningTrample:Show()
			timerTrampleCD:Start()
		end
	end
end
