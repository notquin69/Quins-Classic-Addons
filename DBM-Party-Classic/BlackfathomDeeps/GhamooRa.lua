local mod	= DBM:NewMod("GhamooRa", "DBM-Party-Classic", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190817015300")
mod:SetCreatureID(4887)
--mod:SetEncounterID(1667)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 5568"
)

local warningTrample			= mod:NewSpellAnnounce(5568, 2)

local timerTrampleCD			= mod:NewAITimer(180, 5568, nil, nil, nil, 3)

function mod:OnCombatStart(delay)
	timerTrampleCD:Start(1-delay)
end

do
	local Trample = DBM:GetSpellInfo(5568)
	function mod:SPELL_CAST_SUCCESS(args)
		--if args.spellId == 5568 then
		if args.spellName == Trample then
			warningTrample:Show()
			timerTrampleCD:Start()
		end
	end
end
