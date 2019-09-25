if not WeakAuras.IsCorrectVersion() then return end

if not(GetLocale() == "ruRU") then
  return
end

local L = WeakAuras.L

-- WeakAuras/Templates
	L["Abilities"] = "Способности"
	L["Ability Charges"] = "Заряды способности"
	L["Add Triggers"] = "Добавить триггеры"
	L["Always Active"] = "Всегда активный триггер"
	L["Always Show"] = "Показывать всегда"
	L["Always show the aura, highlight it if debuffed."] = "Всегда показывает индикацию; выделяет ее, если на цели есть дебафф."
	L["Always show the aura, turns grey if on cooldown."] = "Всегда показывает индикацию; становится серой, если предмет восстанавливается."
	L["Always show the aura, turns grey if the debuff not active."] = "Всегда показывает индикацию; становится серой, если на цели нет дебаффа."
	L["Always shows the aura, grey if buff not active."] = "Всегда показывает индикацию; становится серой, если на цели нет баффа."
	L["Always shows the aura, highlight it if buffed."] = "Всегда показывает индикацию; выделяет ее, если на цели есть бафф."
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
	--[[Translation missing --]]
	L["Always shows the aura, turns blue when not usable."] = "Always shows the aura, turns blue when not usable."
	--[[Translation missing --]]
	L["Always shows the aura, turns grey if on cooldown."] = "Always shows the aura, turns grey if on cooldown."
	--[[Translation missing --]]
	L["Always shows the aura, turns grey if the ability is not usable and red when out of range."] = "Always shows the aura, turns grey if the ability is not usable and red when out of range."
	--[[Translation missing --]]
	L["Always shows the aura, turns grey if the ability is not usable."] = "Always shows the aura, turns grey if the ability is not usable."
	--[[Translation missing --]]
	L["Always shows the aura, turns red when out of range, blue on insufficient resources."] = "Always shows the aura, turns red when out of range, blue on insufficient resources."
	L["Always shows the aura, turns red when out of range."] = "Всегда показывает индикацию; становится красной, если цель вне зоны действия."
	L["Back"] = "Назад"
	L["Basic Show On Cooldown"] = "Показать восстановление"
	L["Bloodlust/Heroism"] = "Жажда крови / Героизм"
	L["buff"] = "(бафф)"
	L["Buffs"] = "Баффы"
	L["Cancel"] = "Отмена"
	L["Cast"] = "Применение заклинания (каст)"
	--[[Translation missing --]]
	L["Charge and Buff Tracking"] = "Charge and Buff Tracking"
	--[[Translation missing --]]
	L["Charge and Debuff Tracking"] = "Charge and Debuff Tracking"
	--[[Translation missing --]]
	L["Charge and Duration Tracking"] = "Charge and Duration Tracking"
	--[[Translation missing --]]
	L["Charge Tracking"] = "Charge Tracking"
	L["cooldown"] = "(восстановление)"
	--[[Translation missing --]]
	L["Cooldown"] = "Cooldown"
	L["Cooldown Tracking"] = "Отслеживание восстановления"
	--[[Translation missing --]]
	L["Create Auras"] = "Create Auras"
	--[[Translation missing --]]
	L["debuff"] = "debuff"
	L["Debuffs"] = "Дебаффы"
	--[[Translation missing --]]
	L["debuiff"] = "debuiff"
	L["Enchants"] = "Чары"
	L["General"] = "Общие"
	L["General Azerite Traits"] = "Общие азеритовые таланты"
	L["Health"] = "Здоровье"
	--[[Translation missing --]]
	L["Highlight while active, red when out of range."] = "Highlight while active, red when out of range."
	--[[Translation missing --]]
	L["Highlight while active."] = "Highlight while active."
	L["Highlight while buffed, red when out of range."] = "Выделяет индикацию, если бафф активен; становится красной, если цель вне зоны действия."
	L["Highlight while buffed."] = "Выделяет индикацию, когда на цели есть бафф."
	L["Highlight while debuffed, red when out of range."] = "Выделяет индикацию, если дебафф активен; становится красной, если цель вне зоны действия."
	L["Highlight while debuffed."] = "Выделяет индикацию, когда на цели есть дебафф."
	--[[Translation missing --]]
	L["Highlight while spell is active."] = "Highlight while spell is active."
	--[[Translation missing --]]
	L["Hold CTRL to create multiple auras at once"] = "Hold CTRL to create multiple auras at once"
	L["Keeps existing triggers intact"] = "Сохраняет существующие триггеры нетронутыми"
	L["Next"] = "Далее"
	--[[Translation missing --]]
	L["On Procc Trinkets (Aura)"] = "On Procc Trinkets (Aura)"
	--[[Translation missing --]]
	L["On Use Trinkets (Aura)"] = "On Use Trinkets (Aura)"
	L["On Use Trinkets (CD)"] = "Активир-е аксессуары (CD)"
	L["Only show the aura if the target has the debuff."] = "Показывает индикацию, только когда на цели есть дебафф."
	L["Only show the aura when the item is on cooldown."] = "Показывает индикацию, только когда предмет восстанавливается."
	L["Only shows the aura if the target has the buff."] = "Показывает индикацию, только когда на цели есть бафф."
	L["Only shows the aura when the ability is on cooldown."] = "Показывает индикацию, только когда способность восстанавливается."
	L["Pet alive"] = "Питомец жив"
	L["Pet Behavior"] = "Поведение питомца"
	L["PvP Azerite Traits"] = "Азеритовые PvP таланты"
	L["PvP Talents"] = "PvP таланты"
	--[[Translation missing --]]
	L["PVP Trinkets (Aura)"] = "PVP Trinkets (Aura)"
	L["PVP Trinkets (CD)"] = "Аксессуары PvP (CD)"
	L["Replace all existing triggers"] = "Заменяет все существующие триггеры"
	L["Replace Triggers"] = "Заменить триггеры"
	L["Resources"] = "Ресурсы"
	L["Resources and Shapeshift Form"] = "Форма Друида и ресурсы"
	L["Runes"] = "Руны"
	L["Shapeshift Form"] = "Форма Друида"
	--[[Translation missing --]]
	L["Show Charges and Check Usable"] = "Show Charges and Check Usable"
	--[[Translation missing --]]
	L["Show Charges with Proc Tracking"] = "Show Charges with Proc Tracking"
	--[[Translation missing --]]
	L["Show Charges with Range Tracking"] = "Show Charges with Range Tracking"
	--[[Translation missing --]]
	L["Show Charges with Usable Check"] = "Show Charges with Usable Check"
	L["Show Cooldown and Buff"] = "Показать восстановление и бафф"
	L["Show Cooldown and Buff and Check for Target"] = "Показать восстановление, бафф и проверку зоны действия"
	--[[Translation missing --]]
	L["Show Cooldown and Buff and Check Usable"] = "Show Cooldown and Buff and Check Usable"
	L["Show Cooldown and Check for Target"] = "Показать восстановление и проверку зоны действия"
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
	L["Show Cooldown and Debuff"] = "Показать восстановление и дебафф"
	L["Show Cooldown and Debuff and Check for Target"] = "Показать восстановление, дебафф и проверку зоны действия"
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
	L["Show Only if Buffed"] = "Показать бафф"
	L["Show Only if Debuffed"] = "Показать дебафф"
	L["Show Only if on Cooldown"] = "Показать восстановление"
	--[[Translation missing --]]
	L["Show Totem and Charge Information"] = "Show Totem and Charge Information"
	--[[Translation missing --]]
	L["slow debuff"] = "slow debuff"
	L["Specific Azerite Traits"] = "Специальные азеритовые таланты"
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
	L["Unknown Item"] = "Неизвестный предмет"
	L["Unknown Spell"] = "Неизвестное заклинание"

