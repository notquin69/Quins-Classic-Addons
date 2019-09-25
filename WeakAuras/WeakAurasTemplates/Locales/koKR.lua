if not WeakAuras.IsCorrectVersion() then return end

if not(GetLocale() == "koKR") then
  return
end

local L = WeakAuras.L

-- WeakAuras/Templates
	L["Abilities"] = "능력"
	L["Ability Charges"] = "능력 충전량"
	L["Add Triggers"] = "활성 조건 추가"
	L["Always Active"] = "항상 활성화"
	L["Always Show"] = "항상 표시"
	L["Always show the aura, highlight it if debuffed."] = "효과를 항상 표시하고, 약화 효과면 강조합니다."
	L["Always show the aura, turns grey if on cooldown."] = "효과를 항상 표시하고 재사용 대기중이면 회색으로 변합니다."
	L["Always show the aura, turns grey if the debuff not active."] = "효과를 항상 표시하고, 약화 효과가 활성화되어 있지 않으면 회색으로 바뀝니다."
	L["Always shows the aura, grey if buff not active."] = "효과를 항상 표시하고, 강화 효과가 활성화되어 있지 않으면 회색으로 바뀝니다."
	L["Always shows the aura, highlight it if buffed."] = "효과를 항상 표시하고, 강화 효과면 강조합니다."
	--[[Translation missing --]]
	L["Always shows the aura, highlight when active, turns blue on insufficient resources."] = "Always shows the aura, highlight when active, turns blue on insufficient resources."
	--[[Translation missing --]]
	L["Always shows the aura, highlight while proc is active, blue on insufficient resources."] = "Always shows the aura, highlight while proc is active, blue on insufficient resources."
	--[[Translation missing --]]
	L["Always shows the aura, highlight while proc is active, blue when not usable."] = "Always shows the aura, highlight while proc is active, blue when not usable."
	--[[Translation missing --]]
	L["Always shows the aura, highlight while proc is active, turns red when out of range, blue on insufficient resources."] = "Always shows the aura, highlight while proc is active, turns red when out of range, blue on insufficient resources."
	--[[Translation missing --]]
	L["Always shows the aura, turns blue on insufficient resources."] = "Always shows the aura, turns blue on insufficient resources."
	L["Always shows the aura, turns blue when not usable."] = "효과를 항상 표시하고, 사용할 수 없을 때는 파란색으로 바뀝니다."
	--[[Translation missing --]]
	L["Always shows the aura, turns grey if on cooldown."] = "Always shows the aura, turns grey if on cooldown."
	--[[Translation missing --]]
	L["Always shows the aura, turns grey if the ability is not usable and red when out of range."] = "Always shows the aura, turns grey if the ability is not usable and red when out of range."
	--[[Translation missing --]]
	L["Always shows the aura, turns grey if the ability is not usable."] = "Always shows the aura, turns grey if the ability is not usable."
	--[[Translation missing --]]
	L["Always shows the aura, turns red when out of range, blue on insufficient resources."] = "Always shows the aura, turns red when out of range, blue on insufficient resources."
	--[[Translation missing --]]
	L["Always shows the aura, turns red when out of range."] = "Always shows the aura, turns red when out of range."
	L["Back"] = "뒤로"
	L["Basic Show On Cooldown"] = "재사용 대기 시간 표시"
	L["Bloodlust/Heroism"] = "피의 욕망/영웅심"
	L["buff"] = "강화 효과"
	L["Buffs"] = "강화 효과"
	L["Cancel"] = "취소"
	L["Cast"] = "시전"
	L["Charge and Buff Tracking"] = "충전량 및 강화 효과 추적"
	L["Charge and Debuff Tracking"] = "충전량 및 약화 효과 추적"
	--[[Translation missing --]]
	L["Charge and Duration Tracking"] = "Charge and Duration Tracking"
	--[[Translation missing --]]
	L["Charge Tracking"] = "Charge Tracking"
	L["cooldown"] = "재사용 대기시간"
	--[[Translation missing --]]
	L["Cooldown"] = "Cooldown"
	L["Cooldown Tracking"] = "재사용 대기시간 추적"
	L["Create Auras"] = "효과 생성"
	L["debuff"] = "약화 효과"
	L["Debuffs"] = "약화 효과"
	--[[Translation missing --]]
	L["debuiff"] = "debuiff"
	L["Enchants"] = "마법부여"
	L["General"] = "일반"
	L["General Azerite Traits"] = "일반 아제라이트 특성"
	L["Health"] = "생명력"
	--[[Translation missing --]]
	L["Highlight while active, red when out of range."] = "Highlight while active, red when out of range."
	--[[Translation missing --]]
	L["Highlight while active."] = "Highlight while active."
	--[[Translation missing --]]
	L["Highlight while buffed, red when out of range."] = "Highlight while buffed, red when out of range."
	L["Highlight while buffed."] = "강화 효과가 있는 동안 강조합니다."
	--[[Translation missing --]]
	L["Highlight while debuffed, red when out of range."] = "Highlight while debuffed, red when out of range."
	--[[Translation missing --]]
	L["Highlight while debuffed."] = "Highlight while debuffed."
	--[[Translation missing --]]
	L["Highlight while spell is active."] = "Highlight while spell is active."
	L["Hold CTRL to create multiple auras at once"] = "한 번에 여러 효과를 만드려면 CTRL 키를 누르세요"
	L["Keeps existing triggers intact"] = "활성 조건 그대로 유지"
	L["Next"] = "다음"
	--[[Translation missing --]]
	L["On Procc Trinkets (Aura)"] = "On Procc Trinkets (Aura)"
	--[[Translation missing --]]
	L["On Use Trinkets (Aura)"] = "On Use Trinkets (Aura)"
	--[[Translation missing --]]
	L["On Use Trinkets (CD)"] = "On Use Trinkets (CD)"
	L["Only show the aura if the target has the debuff."] = "대상에 약화 효과가 있는 경우 그 효과만 표시합니다."
	--[[Translation missing --]]
	L["Only show the aura when the item is on cooldown."] = "Only show the aura when the item is on cooldown."
	L["Only shows the aura if the target has the buff."] = "대상에 강화 효과가 있는 경우 그 효과만 표시합니다."
	L["Only shows the aura when the ability is on cooldown."] = "능력이 재사용 대기 중인 경우 그 효과만 표시합니다."
	L["Pet alive"] = "소환수 생존"
	L["Pet Behavior"] = "소환수 행동"
	L["PvP Azerite Traits"] = "PvP 아제라이트 특성"
	L["PvP Talents"] = "명예 특성"
	L["PVP Trinkets (Aura)"] = "PVP 장신구 (효과)"
	L["PVP Trinkets (CD)"] = "PVP 장신구 (재사용 대기시간)"
	L["Replace all existing triggers"] = "모든 활성 조건 교체"
	L["Replace Triggers"] = "활성 조건 교체"
	L["Resources"] = "자원"
	L["Resources and Shapeshift Form"] = "자원과 태세 변환"
	L["Runes"] = "룬"
	L["Shapeshift Form"] = "태세 변환"
	--[[Translation missing --]]
	L["Show Charges and Check Usable"] = "Show Charges and Check Usable"
	--[[Translation missing --]]
	L["Show Charges with Proc Tracking"] = "Show Charges with Proc Tracking"
	--[[Translation missing --]]
	L["Show Charges with Range Tracking"] = "Show Charges with Range Tracking"
	--[[Translation missing --]]
	L["Show Charges with Usable Check"] = "Show Charges with Usable Check"
	L["Show Cooldown and Buff"] = "재사용 대기시간 및 강화 효과 표시"
	L["Show Cooldown and Buff and Check for Target"] = "쿨 다운 및 버프 표시 및 대상 확인"
	--[[Translation missing --]]
	L["Show Cooldown and Buff and Check Usable"] = "Show Cooldown and Buff and Check Usable"
	--[[Translation missing --]]
	L["Show Cooldown and Check for Target"] = "Show Cooldown and Check for Target"
	--[[Translation missing --]]
	L["Show Cooldown and Check for Target & Proc Tracking"] = "Show Cooldown and Check for Target & Proc Tracking"
	--[[Translation missing --]]
	L["Show Cooldown and Check Usable"] = "Show Cooldown and Check Usable"
	--[[Translation missing --]]
	L["Show Cooldown and Check Usable & Target"] = "Show Cooldown and Check Usable & Target"
	--[[Translation missing --]]
	L["Show Cooldown and Check Usable, Proc Tracking"] = "Show Cooldown and Check Usable, Proc Tracking"
	--[[Translation missing --]]
	L["Show Cooldown and Check Usable, Target & Proc Tracking"] = "Show Cooldown and Check Usable, Target & Proc Tracking"
	L["Show Cooldown and Debuff"] = "재사용 대기시간 및 약화 효과 표시"
	--[[Translation missing --]]
	L["Show Cooldown and Debuff and Check for Target"] = "Show Cooldown and Debuff and Check for Target"
	--[[Translation missing --]]
	L["Show Cooldown and Duration"] = "Show Cooldown and Duration"
	--[[Translation missing --]]
	L["Show Cooldown and Duration and Check for Target"] = "Show Cooldown and Duration and Check for Target"
	--[[Translation missing --]]
	L["Show Cooldown and Duration and Check Usable"] = "Show Cooldown and Duration and Check Usable"
	--[[Translation missing --]]
	L["Show Cooldown and Proc Tracking"] = "Show Cooldown and Proc Tracking"
	--[[Translation missing --]]
	L["Show Cooldown and Totem Information"] = "Show Cooldown and Totem Information"
	L["Show Only if Buffed"] = "있는 강화 효과만 표시"
	L["Show Only if Debuffed"] = "있는 약화 효과만 표시"
	L["Show Only if on Cooldown"] = "재사용 대기 중일 때만 표시"
	--[[Translation missing --]]
	L["Show Totem and Charge Information"] = "Show Totem and Charge Information"
	--[[Translation missing --]]
	L["slow debuff"] = "slow debuff"
	L["Specific Azerite Traits"] = "특정 아제라이트 특성"
	--[[Translation missing --]]
	L["Stance"] = "Stance"
	--[[Translation missing --]]
	L["stun debuff"] = "stun debuff"
	--[[Translation missing --]]
	L["Track the charge and proc, highlight while proc is active, turns red when out of range, blue on insufficient resources."] = "Track the charge and proc, highlight while proc is active, turns red when out of range, blue on insufficient resources."
	--[[Translation missing --]]
	L["Tracks the charge and the buff, highlight while the buff is active, blue on insufficient resources."] = "Tracks the charge and the buff, highlight while the buff is active, blue on insufficient resources."
	--[[Translation missing --]]
	L["Tracks the charge and the debuff, highlight while the debuff is active, blue on insufficient resources."] = "Tracks the charge and the debuff, highlight while the debuff is active, blue on insufficient resources."
	--[[Translation missing --]]
	L["Tracks the charge and the duration of spell, highlight while the spell is active, blue on insufficient resources."] = "Tracks the charge and the duration of spell, highlight while the spell is active, blue on insufficient resources."
	L["Unknown Item"] = "알 수 없는 아이템"
	L["Unknown Spell"] = "알 수 없는 주문"

