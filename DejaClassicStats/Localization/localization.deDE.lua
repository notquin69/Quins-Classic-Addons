--local ADDON_NAME, namespace = ... 	--localization
local ADDON_NAME, namespace = ... 	--localization
local L = namespace.L 				--localization

--local LOCALE = GetLocale()
--print("at deDE",namespace.locale)
if namespace.locale == "deDE" then
	-- The EU English game client also
	-- uses the US English locale code.

-- #######################################################################################################################
-- ##	Deutsche (German) translations provided by pas06, flow0284, Markurion, Branduril, and NekoNyaaaa on Curseforge.	##
-- #######################################################################################################################

L["  /dcstats config: Opens the DejaClassicStats addon config menu."] = "  /dcstats config: Öffnet das DejaClassicStats Konfigurationsfenster."
L["  /dcstats reset:  Resets DejaClassicStats options to default."] = "  /dcstats reset: Setzt DejaClassicStats zurück."
L["%s of %s increases %s by %.2f%%"] = "%s von %s erhöht die %s um %.2f%%."
L["About DCS"] = "Über DCS"
L["All Stats"] = "Alle Statistiken"
L["Attack"] = "Angriff"
L["Average Durability"] = "Durchschnittliche Haltbarkeit"
L["Average equipped item durability percentage."] = "Prozentuale Haltbarkeit der angelegten Gegenstände."
L["Average Item Level:"] = "Durchschnittliches Gegenstandslevel:"
L["Avoidance Rating"] = "Vermeidungsbewertung"
L["Blizzard's Hide At Zero"] = "Blizzard Verstecken bei Null"
L["Character Stats:"] = "Charakterwerte:"
L["Class Colors"] = "Klassenfarben"
L["Class Crest Background"] = "Klassenwappen Hintergrund"
L["Critical Strike Rating"] = "Kritische Trefferwertung"
L["DCS's Hide At Zero"] = "DCS Verstecken bei Null"
L["Decimals"] = "Nachkommastellen"
L["Defense"] = "Verteidigung"
--[[Translation missing --]]
--[[ L["Dejablue's improved character stats panel view."] = ""--]] 
L["DejaClassicStats Slash commands (/dcstats):"] = "DejaClassicStats Slashbefehle (/dcstats):"
L["Displays a durability bar next to each item."] = "Zeigt neben jedem Gegenstand eine Haltbarkeitsleiste an."
L["Displays average item durability on the character shirt slot and durability frames."] = "Zeigt die durchschnittliche Haltbarkeit im Hemdplatz und in der Liste unter Haltbarkeit an."
L["Displays average item level to one decimal place."] = "Zeigt die durchschnittliche Gegenstandsstufe mit einer Nachkommastelle an."
L["Displays average item level to two decimal places."] = "Zeigt die durchschnittliche Elementebene mit zwei Nachkommastellen an."
L["Displays average item level with class colors."] = "Zeigt das durchschnittliche Gegenstandslevel mit der Klassenfarbe an."
L["Displays each equipped item's durability."] = "Zeigt die Haltbarkeit von jedem ausgerüsteten Gegenstand an."
L["Displays each equipped item's repair cost."] = "Zeigt die Reparaturkosten von jedem ausgerüsteten Gegenstand an."
L["Displays 'Enhancements' category stats to two decimal places."] = "Zeigt die Werte in der Kategorie 'Verstärkungen' mit 2 Nachkommastellen an."
L["Displays Equipped/Available item levels unless equal."] = "Zeigt das Itemlevel von Ausgerüstet/Verfügbar an bis diese gleich sind."
L["Displays the class crest background."] = "Zeigt den Klassenwappen Hintergrund an."
L["Displays the DCS scrollbar."] = "Zeigt den DCS Scrollbalken."
L["Displays the Expand button for the character stats frame."] = "Zeigt die Erweiterungsschaltfläche für die Charakterwerte an. "
L["Displays the item level of each equipped item."] = "Zeigt das Gegenstandslevel jedes angelegten Gegenstandes."
L["Dodge Rating"] = "Ausweichwertung"
L["Durability"] = "Haltbarkeit"
L["Durability Bars"] = "Haltbarkeitsleisten"
L["Equipped/Available"] = "Ausgerüstet/Verfügbar"
L["Expand"] = "Erweitern"
L["General"] = "Allgemein"
L["General global cooldown refresh time."] = "Allgemeine Abklingzeit."
L["Global Cooldown"] = "Globale Abklingzeit"
L["Haste Rating"] = "Tempowertung"
L["Hide Character Stats"] = "Versteckt die Charakterwerte"
--[[Translation missing --]]
--[[ L["Hide low level mastery"] = ""--]] 
L["Hides 'Enhancements' stats if their displayed value would be zero. Checking 'Decimals' changes the displayed value."] = "Blendet 'Verstärkungen' Statistiken aus,wenn ihr angezeigter Wert gleich Null wäre. 'Nachkommastellen' auswählen verändert den angezeigten Wert."
L["Hides 'Enhancements' stats only if their numerical value is exactly zero. For example, if stat value is 0.001%, then it would be displayed as 0%."] = "Blendet 'Verstärkungen' Statistiken nur aus,wenn ihr numerischer Wert genau Null ist. Zum Beispiel,wenn der Wert 0,001% ist,dann würde er als 0% angezeigt werden."
--[[Translation missing --]]
--[[ L["Hides Mastery stat until the character starts to have benefit from it. Hiding Mastery with Select-A-Stat™ in the character panel has priority over this setting."] = ""--]] 
L["Item Durability"] = "Gegenstandshaltbarkeit"
L["Item Level"] = "Gegenstandslevel"
L["Item Repair Cost"] = "Gegenstandsreparaturkosten"
L["Item Slots:"] = "Gegenstandsfächer:"
L["Leech Rating"] = "Lebensraubwertung"
L["Lock DCS"] = "DCS sperren"
L["Main Hand"] = "Haupthand"
L["Mastery Rating"] = "Meisterschaftswertung"
L["Miscellaneous:"] = "Sonstiges:"
L["Movement Speed"] = "Lauftempo"
L["Off Hand"] = "Nebenhand"
L["Offense"] = "Angriff"
L["One Decimal Place"] = "Eine Nachkommastelle"
L["Parry Rating"] = "Parrierwertung"
L["Ratings"] = "Bewertungen"
L["Relevant Stats"] = "Relevante Werte"
L["Repair Total"] = "Ges. Reparaturkosten"
L["Requires Level "] = "Benötigt Stufe "
L["Reset Stats"] = "Werte zurücksetzen"
L["Reset to Default"] = "Standardeinstellungen"
L["Resets order of stats."] = "Setzt die Reihenfolge der Statistiken zurück."
L["Scrollbar"] = "Scrollbalken"
L["Show all stats."] = "Alle Werte anzeigen."
L["Show Character Stats"] = "Zeigt die Charakterwerte"
L["Show only stats relevant to your class spec."] = "Zeigen Sie nur Statistiken an, die für Ihre Klassenspezifikation relevant sind."
L["Total equipped item repair cost before discounts."] = "Reparaturkosten für angelegte Gegenstände ohne Abzug von Rabatt."
L["Two Decimal Places"] = "Zwei Nachkommastellen"
L["Unlock DCS"] = "DCS freischalten"
L["Versatility Rating"] = "Vielseitigkeitswertung"
L["weapon auto attack (white) DPS."] = "Schaden pro Sekunde der automatischen (weißen) Waffenangriffe."
L["Weapon DPS"] = "Waffen-SPS"

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