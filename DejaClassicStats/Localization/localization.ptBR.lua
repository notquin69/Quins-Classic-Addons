local ADDON_NAME, namespace = ... 	--localization
local L = namespace.L 				--localization

--local LOCALE = GetLocale()

if namespace.locale == "ptBR" then
	-- The EU English game client also
	-- uses the US English locale code.

-- #######################################################################################
-- ##	Português (Portuguese) translations provided by Othra and Rhyrol on Curseforge. ##
-- #######################################################################################

L["  /dcstats config: Opens the DejaClassicStats addon config menu."] = "  /dcstats config: Abrir o menu de configuração do DejaClassicStats."
--[[Translation missing --]]
--[[ L["  /dcstats reset:  Resets DejaClassicStats options to default."] = ""--]] 
--[[Translation missing --]]
--[[ L["%s of %s increases %s by %.2f%%"] = ""--]] 
--[[Translation missing --]]
--[[ L["About DCS"] = ""--]] 
--[[Translation missing --]]
--[[ L["All Stats"] = ""--]] 
L["Attack"] = "Atacar"
L["Average Durability"] = "Durabilidade Média"
L["Average equipped item durability percentage."] = "Percentagem média de durabilidade de item equipado."
L["Average Item Level:"] = "Nível de Item Médio:"
L["Avoidance Rating"] = "Taxa de Evasiva"
--[[Translation missing --]]
--[[ L["Blizzard's Hide At Zero"] = ""--]] 
L["Character Stats:"] = "Atributos do Personagem:"
L["Class Colors"] = "Cores de Classe"
--[[Translation missing --]]
--[[ L["Class Crest Background"] = ""--]] 
L["Critical Strike Rating"] = "Taxa de Acerto Crítico"
--[[Translation missing --]]
--[[ L["DCS's Hide At Zero"] = ""--]] 
L["Decimals"] = "Decimais"
L["Defense"] = "Defesa"
--[[Translation missing --]]
--[[ L["Dejablue's improved character stats panel view."] = ""--]] 
L["DejaClassicStats Slash commands (/dcstats):"] = "DejaClassicStats Comandos de consola (/dcstats):"
L["Displays a durability bar next to each item."] = "Apresentar uma barra de durabilidade próximo de cada item."
L["Displays average item durability on the character shirt slot and durability frames."] = "Apresentar durabilidade média de items no slot da camisa e na janela de durabilidade."
--[[Translation missing --]]
--[[ L["Displays average item level to one decimal place."] = ""--]] 
--[[Translation missing --]]
--[[ L["Displays average item level to two decimal places."] = ""--]] 
--[[Translation missing --]]
--[[ L["Displays average item level with class colors."] = ""--]] 
L["Displays each equipped item's durability."] = "Apresentar durabilidade de cada item equipado."
L["Displays each equipped item's repair cost."] = "Apresentar custo de reparação para cada item equipado."
L["Displays 'Enhancements' category stats to two decimal places."] = "Apresentar categoria 'Melhorias' com atributos em duas decimais."
L["Displays Equipped/Available item levels unless equal."] = "Apresentar Nível do Item Equipado / Apresentado excepto igual."
--[[Translation missing --]]
--[[ L["Displays the class crest background."] = ""--]] 
L["Displays the DCS scrollbar."] = "Apresentar a barra de rolagem para o DCS."
L["Displays the Expand button for the character stats frame."] = "Apresentar o botão Expandir para a janela de atributos do personagem."
--[[Translation missing --]]
--[[ L["Displays the item level of each equipped item."] = ""--]] 
L["Dodge Rating"] = "Taxa de Esquiva"
L["Durability"] = "Durabilidade."
L["Durability Bars"] = "Barras de Durabilidade"
L["Equipped/Available"] = "Equipado/Disponível"
L["Expand"] = "Expandir"
L["General"] = "Geral"
--[[Translation missing --]]
--[[ L["General global cooldown refresh time."] = ""--]] 
--[[Translation missing --]]
--[[ L["Global Cooldown"] = ""--]] 
L["Haste Rating"] = "Taxa de Aceleração"
L["Hide Character Stats"] = "Esconder Atributos de Personagem"
--[[Translation missing --]]
--[[ L["Hide low level mastery"] = ""--]] 
--[[Translation missing --]]
--[[ L["Hides 'Enhancements' stats if their displayed value would be zero. Checking 'Decimals' changes the displayed value."] = ""--]] 
--[[Translation missing --]]
--[[ L["Hides 'Enhancements' stats only if their numerical value is exactly zero. For example, if stat value is 0.001%, then it would be displayed as 0%."] = ""--]] 
--[[Translation missing --]]
--[[ L["Hides Mastery stat until the character starts to have benefit from it. Hiding Mastery with Select-A-Stat™ in the character panel has priority over this setting."] = ""--]] 
L["Item Durability"] = "Durabilidade de Item"
L["Item Level"] = "Nível de Item"
L["Item Repair Cost"] = "Custo de Reparação de Item"
L["Item Slots:"] = "Ítem Ranhuras:"
L["Leech Rating"] = "Taxa de Sorver"
--[[Translation missing --]]
--[[ L["Lock DCS"] = ""--]] 
L["Main Hand"] = "Mão Principal"
L["Mastery Rating"] = "Taxa de Maestria"
L["Miscellaneous:"] = "Diversos:"
L["Movement Speed"] = "Velocidade de Movimento"
L["Off Hand"] = "Mão Secundária"
--[[Translation missing --]]
--[[ L["Offense"] = ""--]] 
--[[Translation missing --]]
--[[ L["One Decimal Place"] = ""--]] 
--[[Translation missing --]]
--[[ L["Parry Rating"] = ""--]] 
--[[Translation missing --]]
--[[ L["Ratings"] = ""--]] 
L["Relevant Stats"] = "Atributos Relevantes"
L["Repair Total"] = "Total de Reparos"
--[[Translation missing --]]
--[[ L["Requires Level "] = ""--]] 
--[[Translation missing --]]
--[[ L["Reset Stats"] = ""--]] 
L["Reset to Default"] = "Reiniciar para default."
--[[Translation missing --]]
--[[ L["Resets order of stats."] = ""--]] 
--[[Translation missing --]]
--[[ L["Scrollbar"] = ""--]] 
L["Show all stats."] = "Mostrar todos os atributos."
L["Show Character Stats"] = "Mostrar Atributos de Personagem"
--[[Translation missing --]]
--[[ L["Show only stats relevant to your class spec."] = ""--]] 
L["Total equipped item repair cost before discounts."] = "Custo de reparo sem descontos de facção."
--[[Translation missing --]]
--[[ L["Two Decimal Places"] = ""--]] 
--[[Translation missing --]]
--[[ L["Unlock DCS"] = ""--]] 
L["Versatility Rating"] = "Taxa de Versatilidade"
--[[Translation missing --]]
--[[ L["weapon auto attack (white) DPS."] = ""--]] 
L["Weapon DPS"] = "Dano por Segundo da Arma"

----------------------------------------------------
-- DejaClassicStats specific translation phrases. --
----------------------------------------------------
L["Primary"] = "Primary"
L["Melee Enhancements"] = "Melee Enhancements"
L["Spell Enhancements"] = "Spell Enhancements"
L["Movement Speed: "] = "Movement Speed: "
L["Durability: "] = "Durability: "
L["Repair Total: "] = "Repair Total: "
L["Melee Crit: "] = "Melee Crit: "
L["Melee Hit: "] = "Melee Hit: "
L["Ranged Crit: "] = "Ranged Crit: "	
L["Melee +Damage: "] = "Melee +Damage: "	
L["Physical Critical Strike: "] = "Physical Critical Strike: "	
L["Dodge: "] = "Dodge: "	
L["Defense: "] = "Defense: "	
L["Parry: "] = "Parry: "	
L["Block: "] = "Block: "	
L["Mana Regen Current: "] = "Mana Regen Current: "	
L["Mana Regen: "] = "Mana Regen: "	
L["MP5: "] = "MP5: "	
L["Spell Crit: "] = "Spell Crit: "	
L["Spell Hit: "] = "Spell Hit: "	
L["Spell +Damage: "] = "Spell +Damage: "	
L["+Healing: "] = "+Healing: "	

L["Darken Item Icons"] = "Darken Item Icons"	
L["Darken item icons to make text more visible."] = "Darken item icons to make text more visible."	
L["Black Item Icons"] = "Black Item Icons"
L["Black item icons to make text more visible."] = "Black item icons to make text more visible."
L["Display Info Beside Items"] = "Display Info Beside Items"
L["Displays the item's info beside each item's slot."] = "Displays the item's info beside each item's slot."
L["Enchants"] = "Enchants"
L["Displays each equipped item's enchantment."] = "Displays each equipped item's enchantment."
L["Background Art"] = "Background Art"
L["Displays the class talents background art."] = "Displays the class talents background art."
L["Monochrome Background Art"] = "Monochrome Background Art"
L["Displays black and white class talents background art."] = "Displays black and white class talents background art."
L["Alternate Expand"] = "Alternate Expand"
L["Displays the Expand button above the hands item slot."] = "Displays the Expand button above the hands item slot."

L["Base Defense including talents such as Warrior's Anticipation is "] = "Base Defense including talents such as Warrior's Anticipation is "
L["Bonus Defense from items and enhancements is "] = "Bonus Defense from items and enhancements is "
L["Total Defense is "] = "Total Defense is "
L[". Critical Hit immunity for a level 60 player against a raid boss occurs at 440 Defense and requires a defense skill of 140 from items and enhancements to achieve."] = ". Critical Hit immunity for a level 60 player against a raid boss occurs at 440 Defense and requires a defense skill of 140 from items and enhancements to achieve."

return end
