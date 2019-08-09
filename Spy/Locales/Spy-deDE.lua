local L = LibStub("AceLocale-3.0"):NewLocale("Spy", "deDE")
if not L then return end
-- TOC Note: Detektiert und warnt Sie vor, in der Nähe befindlichen, Gegnern.

--Addon-Informationen
L["Spy"] = "Spy"
L["Version"] = "Version"
L["LoadDescription"] = "|cff9933ffSpy-Addon geladen. Tippen Sie |cffffffff/spy|cff9933ff für Optionen."
L["SpyEnabled"] = "|cff9933ffSpy-Addon aktiviert."
L["SpyDisabled"] = "|cff9933ffSpy-Addon deaktiviert. Tippen Sie |cffffffff/Spy enable|cff9933ff um es zu aktivieren."
L["UpgradeAvailable"] = "|cff9933ffEine neue Version von Spy ist verfügbar. Es kann von: \n| cffffffffhttps://www.curseforge.com/wow/addons/spy-classic heruntergeladen werden."

-- Configuration frame name
L["Spy Option"] = "Spy"

--Konfiguration Zeichenfolgen
L["Profiles"] = "Profile"

L["GeneralSettings"] = "Allgemeine Einstellungen"
L["SpyDescription1"] = [[
Spy ist ein Addon, das Sie über das Vorhandensein von, in der Nähe befindlichen, feindlichen Spielern benachrichtigt.
]]
L["SpyDescription2"] = [[

|cffffd000In der Nähe-Liste|cffffffff
Die "In der Nähe"-Liste zeigt alle feindlichen Spieler, die in der Nähe entdeckt wurden. Durch Klicken auf die Liste können Sie den Spieler als Ziel erfassen, allerdings funktioniert dies nur außerhalb des Kampfes . Spieler, die für eine gewisse Zeit nicht erkannt wurden, werden aus der Liste entfernt.

Mit dem Löschen-Button in der Titelleiste kann die Liste gelöscht werden. Indem Sie Ctrl beim Löschen der Liste gedrückt halten, können Sie schnell den Spy aktivieren/deaktivieren .

|cffffd000Letzte Stunde-Liste|cffffffff
Die "Letzte Stunde"-Liste zeigt alle Feinde, die in der letzten Stunde erkannt wurden.

|cffffd000Ignorierliste|cffffffff
Spieler, die der Ignorierliste hinzugefügt werden, werden nicht vom Spy gemeldet. Mithilfe des Dropdown-Menüs der Schaltfläche oder Halten der STRG-Taste beim Klicken auf die Schaltfläche können Sie Spieler zu der Liste hinzufügen oder entfernen.

|cffffd000Bei Sichtkontakt zu Töten-Liste|cffffffff
Wird ein Spieler der "Bei Sichtkontakt zu Töten"-Liste erkannt, erklingt ein Alarm. Mithilfe des Dropdown-Menüs der Schaltfläche oder Halten der STRG-Taste beim Klicken auf die Schaltfläche können Sie Spieler zu der Liste hinzufügen oder entfernen.

Ausserdem können Sie mithilfe des Dropdown-Menüs die Gründe hinterlegen, warum Sie jemanden zu der "Bei Sichtkontakt zu Töten"-Liste hinzugefügt haben. Möchten Sie einen nicht in der Liste hinterlegten Grund eingeben, verwenden Sie "Geben Sie Ihren eigenen Grund..." in der anderen Liste.


|cffffd000Autor: Slipjack |cffffffff

]]
L["EnableSpy"] = "Aktiviert Spy"
L["EnableSpyDescription"] = "Aktiviert oder deaktiviert Spy sowohl jetzt als auch bei Login."
L["EnabledInBattlegrounds"] = "Aktiviert Spy in Schlachtfeldern"
L["EnabledInBattlegroundsDescription"] = "Aktiviert oder deaktiviert Spy, wenn Sie in einer Arena sind."
L["EnabledInArenas"] = "Aktiviert Spy in Arenen"
L["EnabledInArenasDescription"] = "Aktiviert oder deaktiviert Spy, wenn Sie in einer Arena sind."
L["EnabledInWintergrasp"] = "Aktiviert Spy in Kampfgebieten der Welt"
L["EnabledInWintergraspDescription"] = "Aktiviert oder deaktiviert Spy, wenn Sie in Kampfgebieten der Welt, wie z.B. Wintergrasp in Northrend, sind."
L["DisableWhenPVPUnflagged"] = "Deaktiviert Spy, wenn PVP nicht eingeschaltet ist"
L["DisableWhenPVPUnflaggedDescription"] = "Aktiviert oder deaktiviert Spy, abhängig von Ihrem PVP-Status."
 
L["DisplayOptions"] = "Anzeigen"
L["DisplayOptionsDescription"] = [[
Spy kann automatisch ein- und ausgeblendet werden.
]]
L["ShowOnDetection"] = "Blendet Spy ein, wenn feindliche Spieler erkannt werden"
L["ShowOnDetectionDescription"] = "Wählen Sie diese Einstellung, um das Spy-Fenster und In der Nähe-Liste anzuzeigen, wenn Spy verborgen ist und feindliche Spieler erkannt werden."
L["HideSpy"] = "Spy ausblenden, wenn keine feindlichen Spieler erkannt werden"
L["HideSpyDescription"] = "Wählen Sie diese Einstellung, um Spy auszublenden, wenn die In der Nähe-Liste angezeigt wird und leer wird. Spy wird nicht ausgeblendet, wenn Sie die Liste manuell löschen."
L["ShowOnlyPvPFlagged"] = "Zeige nur gegnerische Spieler, die im PvP-Modus sind"
L["ShowOnlyPvPFlaggedDescription"] = "Wählen Sie diese Einstellung, um nur die gegnerischen Spieler der In der Nähe-Liste anzuzeigen, die im PvP-Modus sind."
L["ShowKoSButton"] = "Zeigen Sie die Schaltfläche bei Sichtkontakt töten auf dem feindlichen Zielrahmen"
L["ShowKoSButtonDescription"] = "Stellen Sie dies ein, um die Schaltfläche bei Sichtkontakt töten im Zielrahman des Feindes anzuzeigen."
L["LockSpy"] = "Sperrt das Spy-Fenster"
L["LockSpyDescription"] = "Fixiert das Spy-Fenster an einem Ort, so dass es sich nicht bewegt."
L["InvertSpy"] = "Dreht das Spy-Fenster um"
L["InvertSpyDescription"] = "Kippt das Spy-Fenster verkehrt herum."
L["Reload"] = "Neu laden UI"
L["ReloadDescription"] = "Erforderlich beim Wechseln des SPY-Fenster."
L["ResizeSpy"] = "Adaptiert die Größe des Spy-Fensters automatisch."
L["ResizeSpyDescription"] = "Wählen Sie diese Einstellung, um die Größe des Spy-Fensters automatisch anzupassen, wenn feindliche Spieler hinzugefügt oder entfernt werden."
L["ResizeSpyLimit"] = "Listenlimit"
L["ResizeSpyLimitDescription"] = "Begrenzen Sie die Anzahl der im Spy-Fenster angezeigten gegnerischen Spieler."
L["TooltipDisplayWinLoss"] = "Zeigt die Gewinn/Verlust-Statistik im Tooltip an."
L["TooltipDisplayWinLossDescription"] = "Wählen Sie diese Einstellung, um die Gewinn/Verlust-Statistik eines Spielers in dessen QuickInfo anzuzeigen."
L["TooltipDisplayKOSReason"] = "Zeigt die Gründe für das Töten bei Sichtkontakt im Tooltip an."
L["TooltipDisplayKOSReasonDescription"] = "Wählen Sie diese Einstellung, um die Gründe für das Töten eines Spielers bei Sichtkontakt in der QuickInfo des Spielers anzuzeigen."
L["TooltipDisplayLastSeen"] = "Zeigt die zuletzt angesehenen Details in der QuickInfo an."
L["TooltipDisplayLastSeenDescription"] = "Wählen Sie diese Einstellung, um die letzte bekannte Zeit und den letzten bekannten Ort eines Spielers in der QuickInfo des Spielers anzuzeigen."
L["SelectFont"] = "Wählen Sie eine Schriftart"
L["SelectFontDescription"] = "Wählen Sie eine Schriftart für das Spy-Fenster."
L["RowHeight"] = "Wählen Sie die Zeilenhöhe aus"
L["RowHeightDescription"] = "Wählen Sie die Zeilenhöhe für das Spy-Fenster aus."
 
L["AlertOptions"] = "Warnungen"
L["AlertOptionsDescription"] = [[
Sie können die Details einer Begegnung in einem Chat-Kanal bekannt machen und festlegen, wie Spy Sie warnt, wenn feindliche Spieler erkannt werden.
]]
L["Announce"] = "Melden:"
L["None"] = "Nichts"
L["NoneDescription"] = "Melde nichts, wenn feindliche Spieler erkannt werden."
L["Self"] = "Selbst"
L["SelfDescription"] = "Melde dir selbst, wenn feindliche Spieler erkannt werden."
L["Party"] = "Gruppe"
L["PartyDescription"] = "Melde deiner Gruppe, wenn feindliche Spieler erkannt werden."
L["Guild"] = "Gilde"
L["GuildDescription"] = "Melde deiner Gilde, wenn feindliche Spieler erkannt werden."
L["Raid"] = "Angriff"
L["RaidDescription"] = "Melde deiner Raid, wenn feindliche Spieler erkannt werden."
L["LocalDefense"] = "Lokale Verteidigung"
L["LocalDefenseDescription"] = "Gebe dem lokalen Verteidigungskanal bekannt, wenn feindliche Spieler erkannt werden."
L["OnlyAnnounceKoS"] = "Gebe nur Gegner bekannt, die bei Sichtkontakt zu töten sind"
L["OnlyAnnounceKoSDescription"] = "Wählen Sie diese Einstellung, um nur die gegnerischen Spielern bekannt zu geben, die auf Ihrer Bei Sichtkontakt zu Töten-Liste sind."
L["WarnOnStealth"] = "Warnt, wenn Tarnungen erkannt werden"
L["WarnOnStealthDescription"] = "Wählen Sie diese Einstellung, um eine Warnung und einen Alarmton wiederzugeben, wenn ein feindlicher Spieler sich tarnt."
L["WarnOnKOS"] = "Warnt bei Erkennung eines Töten bei Sichtkontakts."
L["WarnOnKOSDescription"] = "Wählen Sie diese Einstellung, um eine Warnung und einen Alarmton wiederzugeben, wenn ein feindlicher Spieler von Ihrer Bei Sichtkontakt zu Töten-Liste erkannt wird"
L["WarnOnKOSGuild"] = "Warnt bei Erkennung einer Gilde der Bei Sichtkontakt zu Töten-Liste"
L["WarnOnKOSGuildDescription"] = "Wählen Sie diese Einstellung, um eine Warnung und einen Alarmton wiederzugeben, wenn ein feindlicher Spieler der gleichen Gilde wie jemand auf Ihrer Bei Sichtkontakt zu Töten-Liste erkannt wird."
L["WarnOnRace"] = "Warnt bei Erkennung einer Rasse"
L["WarnOnRaceDescription"] = "Wählen Sie diese Einstellung, um einen Alarmton wiederzugeben, wenn die ausgewählte Rasse detektiert wurde"
L["SelectWarnRace"] = "Wähle die Rasse, welche detektiert werden soll."
L["SelectWarnRaceDescription"] = "Wählen Sie eine Rasse, welche mittels akustischen Alarm angezeigt werden soll."
L["WarnRaceNote"] = "Hinweis: Sie müssen den Feind mindestens einmal ins Visier genommen haben, damit dessen Rasse in die Datenbank aufgenommen werden kann. Bei der nächsten Detektion ertönt ein Alarm. Das funktioniert nicht genauso, wie die Detektion von kämpfenden Gegnern in der Nähe."
L["DisplayWarningsInErrorsFrame"] = "Zeigt Warnungen im Fehler-Fenster an."
L["DisplayWarningsInErrorsFrameDescription"] = "Wählen Sie diese Einstellung, um eine Warnung wiederzugeben, anstatt grafische Popup-Frames anzuzeigen."
L["EnableSound"] = "Aktiviert akustische Warnungen."
L["EnableSoundDescription"] = "Wählen Sie diese Einstellung, um akustische Warnungen zu aktivieren, wenn feindliche Spieler erkannt werden. Es erklingen unterschiedliche Warnungen, wenn ein feindlicher Spieler sich tarnt oder wenn ein feindlicher Spieler auf deiner Bei Sichtkontakt zu Töten-Liste ist."
L["OnlySoundKoS"] = "Es ertönen nur akustische Alarme fuer die Bei Sichtkontakt zu Töten-Liste"
L["OnlySoundKoSDescription"] = "Wählen Sie diese Einstellung, so dass nur akustische Warnungen ertönen, wenn feindliche Spieler von der Bei Sichtkontakt zu Töten-Liste erkannt werden."
 
L["ListOptions"] = "In der Nähe-Liste"
L["ListOptionsDescription"] = [[
Sie können einstellen, wie Spy feindliche Spieler zu der In der Nähe-Liste hinzufügt und entfernt .
]]
L["RemoveUndetected"] = "Entfernt feindliche Spieler aus der In der Nähe-Liste nach:"
L["1Min"] = "1 Minute"
L["1MinDescription"] = "Entfernt einen feindlichen Spieler, der seit über 1 Minute unentdeckt geblieben ist."
L["2Min"] = "2 Minuten"
L["2MinDescription"] = "Entfernt einen feindlichen Spieler, der seit über 2 Minuten unentdeckt geblieben ist."
L["5 Minuten"] = "5 Minuten"
L["5MinDescription"] = "Entfernt einen feindlichen Spieler, der seit über 5 Minuten unentdeckt geblieben ist."
L["10Min"] = "10 Minuten"
L["10MinDescription"] = "Entfernt einen feindlichen Spieler, der seit über 10 Minuten unentdeckt geblieben ist."
L["15Min"] = "15 Minuten"
L["15MinDescription"] = "Entfernt einen feindlichen Spieler, der seit über 15 Minuten unentdeckt geblieben ist."
L["Never"] = "Niemals entfernen"
L["NeverDescription"] = "Entfernt niemals feindliche Spieler. Die In der Nähe-Liste kann weiterhin manuell gelöscht werden."
L["ShowNearbyList"] = "Wechselt auf die In der Nähe-Liste bei Entdeckung feindlicher Spieler."
L["ShowNearbyListDescription"] = "Stellen Sie hier die Anzeige der In der Nähe-Liste ein, wenn sie nicht bereits bei Entdeckung feindlicher Spieler sichtbar ist."
L["PrioritiseKoS"] = "Priorisiere feindliche Spieler auf der In der Nähe-Liste, die sofort getötet werden sollen."
L["PrioritiseKoSDescription"] = "Stellen Sie hier ein, das feindliche Spieler, die sofort getötet werden sollen, immer zuerst  auf der In der Nähe-Liste erscheinen."
 
L["MinimapOptions"] = "Karte"
L["MinimapOptionsDescription"] = [[
Spieler, die Humanoide verfolgen können, können die Minikarte für zusätzliche Features nutzen.
 
Spieler, die Humanoide verfolgen können, inklusive Jäger, Druiden, und Diejenigen, die die Fähigkeit mit anderen Mitteln, wie z.B. Essen eines geschwärztem Worgsteaks, erhalten haben.
]]
L["MinimapTracking"] = "Aktiviere Minimap-Tracking"
L["MinimapTrackingDescription"] = "Stellen Sie hier die Verfolgung und Entdeckung auf der Minikarte ein. Bekannte feindliche Spieler, die auf der Minikarte entdeckt werden, werden der In der Nähe-Liste hinzugefügt."
L["MinimapDetails"] = "Zeige die Details der Level/Klassen in QuickInfos an."
L["MinimapDetailsDescription"] = "Aktualisieren Sie hier die QuickInfo der Karte, sodass die Details der Level/Klassen neben feindlichen Namen angezeigt werden."
L["DisplayOnMap"] = "Zeigt die Lokalisation der Feinde auf der Karte an."
L["DisplayOnMapDescription"] = "Zeigt die Lokalisation der Feinde auf der Weltkarte und der Minikarte an, welche von anderen Spy-Benutzern Ihrer Gruppe und Gilde entdeckt wurden."
L["SwitchToZone"] = "Wechseln Sie in der aktuellen Zonenkarte auf feindliche Erkennung"
L["SwitchToZoneDescription"] = "Wenn die Weltkarte  geöffnet ist, wird diese Einstellung die Karte auf die aktuelle Zonenkarte des Spielers ändern, sobald Feinde entdeckt werden."
L["MapDisplayLimit"] = "Limitiert angezeigte Kartensymbole auf:"
L["LimitNone"] = "Überall"
L["LimitNoneDescription"] = "Zeigt, unabhängig von Ihrem aktuellen Standort, alle erkannten Feinde auf der Karte an."
L["LimitSameZone"] = "Gleiche Zone"
L["LimitSameZoneDescription"] = "Zeigt nur die entdeckten Feinde auf der Karte an, die sich in der gleichen Zone befinden."
L["LimitSameContinent"] = "Gleicher Kontinent"
L["LimitSameContinentDescription"] = "Zeigt nur die entdeckten Feinde auf der Karte an, die sich auf dem gleichen Kontinent befinden."
 
L["DataOptions"] = "Datenmanagement"
L["DataOptionsDescription"] = [[
Hier können Sie konfigurieren, wie Spy ihre Daten verwaltet und sammelt.
]]
L["PurgeData"] = "Eliminiert unentdeckte feindliche Spieler-Daten nach:"
L["OneDay"] = "1 Tag"
L["OneDayDescription"] = "Eliminiert Daten feindlicher Spieler, die für 1 Tag unentdeckt geblieben sind."
L["FiveDays"] = "5 Tage"
L["FiveDaysDescription"] = "Eliminiert Daten feindlicher Spieler, die für 5 Tage unentdeckt geblieben sind."
L["TenDays"] = "10 Tage"
L["TenDaysDescription"] = "Eliminiert Daten feindlicher Spieler, die für 10 Tage unentdeckt geblieben sind."
L["ThirtyDays"] = "30 Tage"
L["ThirtyDaysDescription"] = "Eliminiert Daten feindlicher Spieler, die für 30 Tage unentdeckt geblieben sind."
L["SixtyDays"] = "60 Tage"
L["SixtyDaysDescription"] = "Eliminiert Daten feindlicher Spieler, die für 60 Tage unentdeckt geblieben sind."
L["NinetyDays"] = "90 Tage"
L["NinetyDaysDescription"] = "Eliminiert Daten feindlicher Spieler, die für 90 Tage unentdeckt geblieben sind."
L["PurgeKoS"] = "Eliminiert feindliche Spieler, basierend auf der Zeit, die sie unentdeckt geblieben sind."
L["PurgeKoSDescription"] = "Eliminiert Sofort zu tötende Spieler, welche unentdeckt geblieben sind, basierend auf den Zeiteinstellungen für unentdeckte Spieler."
L["PurgeWinLossData"] = "Eliminiert Sieg/Verlust-Daten, basierend auf der unentdeckten Zeit."
L["PurgeWinLossDataDescription"] = "Stellt die Eliminierung der Sieg/Verlust-Daten Ihrer feindlichen Spieler-Begegnungen ein, basierend auf den Zeiteinstellungen für unentdeckte Spieler."
L["ShareData"] = "Teile die Daten mit anderen Spy-Benutzern."
L["ShareDataDescription"] = "Stellt ein, dass Details Ihrer feindlichen Spieler-Begegnungen mit anderen Spy-Benutzern Ihrer Gruppe und Gilde geteilt werden."
L["UseData"] = "Verwende Daten anderer Spy-Benutzer."
L["UseDataDescription"] = [[Stelle dies ein, um gesammelte Daten anderer Spy-Benutzer Ihrer Gruppe und Gilde zu verwenden.
 
Entdeckt ein anderer Spy-Benutzer einen feindlichen Spieler, wird dieser Spieler zu Ihrer In der Nähe-Liste hinzugefügt, falls Platz vorhanden ist.
]]
L["ShareKOSBetweenCharacters"] = "Teile Sofort zu tötende Spieler mit Ihren anderen Charakteren."
L["ShareKOSBetweenCharactersDescription"] = "Wählen Sie diese Einstellung, um die Sofort zu tötende Spieler mit Ihren anderen Charakteren auf dem gleichen Server und Lager zu teilen."
 
L["SlashCommand"] = "Slash Befehl"
L["SpySlashDescription"] = "Diese Schaltflächen führen die gleichen Funktionen aus, wie die in den Slash Befehl /spy"
L["Enable"] = "Aktivieren"
L["EnableDescription"] = "Aktiviert Spy und zeigt das Hauptfenster."
L["Show"] = "Zeigen"
L["ShowDescription"] = "Zeigt das Hauptfenster."
L["Reset"] = "Zurücksetzen"
L["ResetDescription"] = "Setzt die Position und die Darstellung des Hauptfensters zurück."
L["ClearSlash"] = "Löschen"
L["ClearSlashDescription"] = "Löscht die Liste der Spieler, die entdeckt wurden."
L["Config"] = "Konfigurieren"
L["ConfigDescription"] = "Öffnet das Interface-Konfigurationsfenster für Spy."
L["KOS"] = "KOS"
L["KOSDescription"] = "Fügt hinzu/entfernt einen Spieler von der Sofort zu Töten-Liste."
L["InvalidInput"] = "Ungültige Eingabe"
L["Ignore"] = "Ignorieren"
L["IgnoreDescription"] = "Fügt hinzu/entfernt einen Spieler von der Zu Ignorieren-Liste."
 
--Listen
L["Nearby"] = "In der Nähe"
L["LastHour"] = "Letzte Stunde"
L["Ignore"] = "Ignorieren"
L["KillOnSight"] = "Sofort zu Töten"
 
--Stats
L["Time"] = "Zeit"	
L["List"] = "Liste"	
L["Filter"] = "Filter"
L["Show Only"] = "Zeige nur"
L["Wins/Loses"] = "Gewonnen/Verloren"
L["KOS"] = "KOS"
L["Reason"] = "Grund"	
L["HonorKills"] = "Ehrenvolle Siege"
L["PvPDeatchs"] = "PvP Tode"

--Ausgabemeldungen
L["AlertStealthTitle"] = "Getarnte Spieler erkannt!"
L["AlertKOSTitle"] = "Sofort zu tötenden Spieler erkannt!"
L["AlertKOSGuildTitle"] = "Gilde eines Sofort zu tötenden Spielers erkannt!"
L["AlertTitle_kosaway"] = "Sofort zu tötenden Spieler lokalisiert bei "
L["AlertTitle_kosguildaway"] = "Gilde eines Sofort zu tötenden Spielers lokalisiert bei"
L["StealthWarning"] = "|cff9933ffGetarnten Spieler erkannt: |cffffffff"
L["KOSWarning"] = "|cffff0000Sofort zu töten-Spieler erkannt: |cffffffff"
L["KOSGuildWarning"] = "|cffff0000Gilde eines Sofort zu tötenden Spielers erkannt: |cffffffff"
L["SpySignatureColored"] = "|cff9933ff [Spy]"
L["PlayerDetectedColored"] = "Spieler erkannt: |cffffffff"
L["PlayersDetectedColored"] = "Spieler erkannt: |cffffffff"
L["KillOnSightDetectedColored"] = "Sofort zu tötenden Spieler erkannt: |cffffffff"
L["PlayerAddedToIgnoreColored"] = "Zur Ignorieren-Liste hinzugefügter Spieler: |cffffffff"
L["PlayerRemovedFromIgnoreColored"] = "Von der Ignorieren-Liste entfernter Spieler: |cffffffff"
L["PlayerAddedToKOSColored"] = "Fügt Spieler der Sofort zu töten-Liste hinzu: |cffffffff"
L["PlayerRemovedFromKOSColored"] = "Von der Sofort zu töten-Liste entfernter Spieler: |cffffffff"
L["PlayerDetected"] = "[Spy] Spieler erkannt:"
L["KillOnSightDetected"] = "[Spy] Sofort zu tötenden Spieler erkannt:"
L["Level"] = "Level"
L["LastSeen"] = "Zuletzt gesehen"
L["LessThanOneMinuteAgo"] = "vor weniger als einer minute"
L["MinutesAgo"] = "vor Minuten"
L["HoursAgo"] = "vor Stunden"
L["DaysAgo"] = "vor Tagen"
L["Close"] = "Schließen"
L["CloseDescription"] = "|cffffffffVerbirgt das Spy-Fenster. Es wird standardmäßig wieder gezeigt, wenn der nächste feindliche Spieler erkannt wird."
L["Left/Right"] = "Links/Rechts"
L["Left/RightDescription"] = "|cffffffffNavigiert zwischen den Listen: In der Nähe, Letzte Stunde, Ignorieren und Sofort zu töten."
L["Clear"] = "Löschen"
L["ClearDescription"] = "|cffffffffLöscht die Liste der Spieler, die gefunden wurden. Strg-Klick aktiviert/deaktiviert Spion während angezeigt."
L["NearbyCount"] = "Anzahl der Spieler in der Nähe "
L["NearbyCountDescription"] = "|cffffffffSendet die Anzahl der in der Nähe befindlichen Spieler zum chatten"
L["Statistics"] = "Statistiken"
L["StatsDescription"] = "|cffffffffZeigt eine Liste der angetroffenen feindlichen Spieler,  Aufzeichnungen über Gewinne/Niederlagen und wo sie zuletzt gesehen wurden"
L["AddToIgnoreList"] = "Fügt zur Ignorieren-Liste hinzu"
L["AddToKOSList"] = "Fügt zur Sofort zu töten-Liste hinzu"
L["RemoveFromIgnoreList"] = "Entfernt von der zu Ignorieren-Liste"
L["RemoveFromKOSList"] = "Entfernt von der Sofort zu töten-Liste"
L["RemoveFromStatsList"] = "Entfernt von der Statistikliste"   
L["AnnounceDropDownMenu"] = "Melden"
L["KOSReasonDropDownMenu"] = "Hinterlegt Grund für Sofort zu töten"
L["PartyDropDownMenu"] = "Gruppe"
L["RaidDropDownMenu"] = "Raid"
L["GuildDropDownMenu"] = "Gilde"
L["LocalDefenseDropDownMenu"] = "Lokale Verteidigung"
L["Player"] = "(Spieler)"
L["KOSReason"] = "Sofort zu töten"
L["KOSReasonIndent"] = "    "
L["KOSReasonOther"] = "Geben Sie Ihren eigenen Grund ein ..."
L["KOSReasonClear"] = "Löschen"
L["StatsWins"] = "|cff40ff00Gewinne:"
L["StatsSeparator"] = ""
L["StatsLoses"] = "|cff0070ddNiederlagen:"
L["Located"] = "lokalisiert:"
L["Yards"] = "Yards"
 
Spy_KOSReasonListLength = 6
Spy_KOSReasonList = {
	[1] = {
		["title"] = "Gestarteter Kampf";
		["content"] = {
			"Griff mich ohne Grund an",
			"Griff mich auf einer Suche an",
			"Griff mich an, während ich NSCs bekämpfte",
			"Griff mich an, während ich in der Nähe einer Instanz war",
			"Griff mich an, während ich AFK war",
			"Griff mich an, während ich ritt/flog",
			"Griff mich an, während ich schlechter Gesundheit/Mana war",
		};
	},
	[2] = {
		["title"] = "Stil des Kampfes";
		["content"] = {
			"Überfiel mich",
			"Attackiert mich immer, wenn es mich sieht",
			"Tötete mich mit einem Charakter höheren Levels",
			"Überwältigte mich mit einer Gruppe von Feinden",
			"Attackiert nicht ohne Backup",
			"Ruft immer um Hilfe",
			"Nutzt zu viel Menschenmengenkontrolle",
		};
	},
	[3] = {
		["title"] = "camping";
		["content"] = {
			"Camped mich",
			"Camped meinen anderen Charakter",
			"Camped untere Charaktere",
			"Camped durch Unsichtbare",
			"Camped Gildenmitglieder",
			"Camped Spiel NPCs/Ziele",
			"Camped eine/n Stadt/Ort ",
		};
	},
	[4] = {
		["title"] = "Suchen";
		["content"] = {
			"Griff mich an, während ich suchte.",
			"Griff mich an, nachdem ich mit der Suche geholfen hatte.",
			"Störte mit einen Suchobjekt.",
			"Startete eine Suche, die ich durchführen wollte",
			"Tötete meine Fraktion NPCs",
			"Tötete eine NPC Suche",
		};
	},
	[5] = {
		["title"] = "Diebstahl Ressourcen";
		["content"] = {
			"Gesammelte Kräuter, die ich wollte",
			"Gefundene Mineralien, die ich wollte",
			"Gesammelte Ressourcen, die ich wollte",
			"Tötete mich und stahl meine Ziele/seltene NPC",
			"Enthäutete meine Kills",
			"Barg meine Kills",
			"In meinem Pool gefischt",
		};
	},
	[6] = {
		["title"] = "Andere";
		["content"] = {
		"Markiert für PvP",
		"Stie mich von einer Klippe",
		"Verwendete Engineering-Tricks",
		"Gelingt es immer, zu entkommen",
		"Benutzt Gegenstände und Fähigkeiten um zu entkommen",
		"Nutzt Spielmechanism en aus",
		"Geben Sie Ihren eigenen Grund ein ...",
		};
	},
}
 
StaticPopupDialogs ["Spy_SetKOSReasonOther"] = {
	PreferredIndex = STATICPOPUPS_NUMDIALOGS,--http://forums.wowace.com/showthread.php?p=320956
	text = "Geben Sie den Grund für das Sofort zu töten %s ein",
	button1 = "Einstellen",
	button2 = "Abbrechen",
	timeout = 20,
	hasEditBox = 1,
	editBoxWidth = 260,		
	whileDead = 1,
	hideOnEscape = 1,
	OnShow = function(self)
		self.editBox:SetText("");
	end,
		OnAccept = function(self)
		local reason = Self.editBox:GetText()
		Spy:SetKOSReason(self.playerName, "Geben Sie Ihren eigenen Grund ein ...", reason)
	end,
};

--++ Class descriptions
--L["DEATHKNIGHT"] = "Todesritter"
--L["DEMONHUNTER"] = "Dämonenjäger"
L["DRUID"] = "Druide"
L["HUNTER"] = "Jäger"
L["MAGE"] = "Magier"
--L["MONK"] = "Mönch"
L["PALADIN"] = "Paladin"
L["PREIST"] = "Priester"
L["ROGUE"] = "Schurke"
L["SHAMAN"] = "Schamane"
L["WARLOCK"] = "Hexenmeister"
L["WARRIOR"] = "Krieger"
L["UNKNOWN"] = "Unbekannt"
 
 --++ Race descriptions
L["HUMAN"] = "Mensch"
L["ORC"] = "Orc"
L["DWARF"] = "Zwerg"
L["NIGHT ELF"] = "Nachtelf"
L["UNDEAD"] = "Untoter"
L["TAUREN"] = "Tauren"
L["GNOME"] = "Gnom"
L["TROLL"] = "Troll"
--L["GOBLIN"] = "Goblin"
--L["BLOOD ELF"] = "Blutelf"
--L["DRAENEI"] = "Draenei"
--L["WORGEN"] = "Worgen"
--L["PANDAREN"] = "Pandaren"
--L["NIGHTBORNE"] = "Nachtgeborener"
--L["HIGHMOUNTAIN TAUREN"] = "Hochbergtauren"
--L["VOID ELF"] = "Leerenelf"	
--L["LIGHTFORGED DRAENEI"] = "Lichtgeschmiedeter Draenei"
--L["ZANDALARI TROLL"] = "Zandalaritroll"
--L["KUL TIRAN"] = "Kul Tiran"
--L["DARK IRON DWARF"] = "Dunkeleisenzwerg"
--L["MAG'HAR ORC"] = "Mag'har"
 
--++ Font descriptions
L["2002"] = "2002"
L["2002 BOLD"] = "2002 Bold"
L["ARIAL NARROW"] = "Arial Narrow" -- default chat font
L["FRIZ QUADRATA TT"] = "Friz Quadrata TT" -- default main UI font
L["FRIZQUADRATACTT"] = "FrizQuadrataCTT"
L["MOK"] = "MoK"
L["MORPHEUS"] = "Morpheus" -- default in game mail font
L["NIMROD MT"] = "Nimrod MT"
L["SKURRI"] = "Skurri" -- default unit frame combat font

 --Stealth Fähigkeiten
L["Stealth"] = "tarnen"
L["Prowl"] = "schleichen"
 
--Kanalnamen
L["LocalDefenseChannelName"] = "Lokale Verteidigung"
 
--++ Minimap-Farbcodes
--L["MinimapClassTextDEATHKNIGHT"] = "|cffc41e3a"
--L["MinimapClassTextDEMONHUNTER"] = "|cffa330c9"
L["MinimapClassTextDRUID"] = "|cffff7c0a"
L["MinimapClassTextHUNTER"] = "|cffaad372"
L["MinimapClassTextMAGE"] = "|cff68ccef"
--L["MinimapClassTextMONK"] = "|cff00ff96"
L["MinimapClassTextPALADIN"] = "|cfff48cba"
L["MinimapClassTextPRIEST"] = "|cffffffff"
L["MinimapClassTextROGUE"] = "|cfffff468"
L["MinimapClassTextSHAMAN"] = "|cff2359ff"
L["MinimapClassTextWARLOCK"] = "|cff9382c9"
L["MinimapClassTextWARRIOR"] = "|cffc69b6d"
L["MinimapClassTextUNKNOWN"] = "|cff191919"
L["MinimapGuildText"] = "|cffffffff"
 
Spy_AbilityList = {
 
-----------------------------------------------------------
--Ermöglicht eine Abschätzung der Rasse, Klasse und Niveau ein
--Spieler bestimmt, welche Fähigkeiten beobachtet werden
--im Kampflog angezeigt.
-----------------------------------------------------------
 
};

Spy_IgnoreList = {
	["Briefkasten"]=true, ["Schreddermeister Mk1"]=true, ["Schrott-o-matik 1000"]=true,
	["Boat to Stormwind City"]=true, ["Boat to Boralus Harbor, Tiragarde Sound"]=true,
	["Schatztruhe"]=true, ["Kleine Schatztruhe"]=true,
	["Akundas Biss"]=true, ["Ankerkraut"]=true, ["Flussknospe"]=true,    
	["Meeresstängel"]=true, ["Sirenenpollen"]=true, ["Sternmoos"]=true,   
	["Winterkuss"]=true, ["War Headquarters (PvP)"]=true,
	["Allianzattentäter"]=true, ["Hordeattentäter"]=true,	
	["Mystiker Vogelhut"]=true, ["Cousin Träghand"]=true,	
};