local mod	= DBM:NewMod("Gelihast", "DBM-Party-Classic", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190817015300")
mod:SetCreatureID(6243)
--mod:SetEncounterID(1667)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 6533",
	"SPELL_AURA_APPLIED 6533"
)

local warningNet			= mod:NewTargetNoFilterAnnounce(6533, 2)

local timerNetCD			= mod:NewAITimer(180, 6533, nil, nil, nil, 5, nil, DBM_CORE_TANK_ICON)

function mod:OnCombatStart(delay)
	timerNetCD:Start(1-delay)
end

do
	local Net = DBM:GetSpellInfo(6533)
	function mod:SPELL_CAST_SUCCESS(args)
		--if args.spellId == 6533 then
		if args.spellName == Net then
			timerNetCD:Start()
		end
	end

	function mod:SPELL_AURA_APPLIED(args)
		--if args.spellId == 6533 then
		if args.spellName == Net then
			warningNet:Show(args.destName)
		end
	end
end
