local L = LibStub("AceLocale-3.0"):NewLocale("Spy", "ptFR")
if not L then return end


--Addon information
L ["Spy"] = "Spy"
L ["Version"] = "Version"
L ["LoadDescription"] = "Add |cff9933ffSpy chargé. Type |cffffffff/spy|cff9933ff pour les options."
L ["SpyEnabled"] = "Add |cff9933ffSpy activé."
L ["SpyDisabled"] = "Add |cff9933ffSpy désactivé. Tapez show|cff9933ff |cffffffff/espion pour permettre."
L ["UpgradeAvailable"] = "nouvelle version de |cff9933ffA d'espion est disponible. Il peut être téléchargé à partir : \n| cffffffffhttps://mods.curse.com/addons/wow/spy"
 
--Cordes configuration
L ["profils"] = "Profils"
 
L ["GeneralSettings"] = "Paramètres généraux"
L ["SpyDescription1"] = [[
Espion est un addon qui vous signalera la présence de joueurs ennemis à proximité.
]]
L ["SpyDescription2"] = [[
 
|cffffd000Nearby list|cffffffff
La liste dans les environs affiche tout les joueurs ennemis qui ont été détectés à proximité. En cliquant sur la liste vous permet de cibler le joueur, mais cela ne fonctionne pas. Les joueurs sont supprimés de la liste si elles n'ont pas été détectés après un laps de temps.
 
Le bouton effacer dans la barre de titre peut être utilisé pour effacer la liste, et la holding de contrôle lors du nettoyage de la liste vous permettra d'activer/désactiver rapidement le Spy.
 
|cffffd000Last heure list|cffffffff
La liste de la dernière heure affiche tous les ennemis qui ont été détectés dans la dernière heure.
 
|cffffd000Ignore list|cffffffff
Les joueurs qui sont ajoutés à la liste des exclusions ne sont pas signalés par Spy. Vous pouvez ajouter et supprimer des joueurs à partir de cette liste à l'aide du menu déroulant du bouton ou en maintenant la touche Contrôle enfoncée tout en cliquant sur le bouton.
 
|cffffd000Kill on Sight list|cffffffff
Joueurs sur votre liste de Kill On Sight rendre une alarme sonne quand détecté. Vous pouvez ajouter et supprimer des joueurs à partir de cette liste à l'aide du menu déroulant du bouton ou en tenant la touche Maj enfoncée tout en cliquant sur le bouton.
 
Le menu déroulant peut également servir à définir les raisons pourquoi vous avez quelqu'un ajouté à la liste de Kill On Sight. Si vous voulez entrer une raison particulière qui n'est pas dans la liste, puis utilisez la "Entrez votre propre raison..." dans L'autre liste.
 
 
|cffffd000Author : http://www.curse.com/users/slipjack |cffffffff
 
]]
L ["EnableSpy"] = "Activer le Spy"
L ["EnableSpyDescription"] = "active ou désactive Spy fois maintenant, mais aussi sur ouverture de session".
L ["EnabledInBattlegrounds"] = "Activer l'espion en champ de bataille"
L ["EnabledInBattlegroundsDescription"] = "Active ou désactive les espion lorsque vous êtes dans un champ de bataille."
L ["EnabledInArenas"] = "Activer l'espion dans les arènes"
L ["EnabledInArenasDescription"] = "Active ou désactive les espion lorsque vous êtes dans une arène."
L ["EnabledInWintergrasp"] = "Activer l'espion dans les zones de combat mondial"
L ["EnabledInWintergraspDescription"] = "Active ou désactive les espion lorsque vous êtes dans les zones de combat de monde comme le lac Joug-d'hiver en Norfendre."
L ["DisableWhenPVPUnflagged"] = "Disable espion lorsque le ne pas pour le PVP"
L ["DisableWhenPVPUnflaggedDescription"] = "Active ou désactive le Spy selon votre statut de PVP."
 
L ["DisplayOptions"] = "Affichage"
L ["DisplayOptionsDescription"] = [[
Espion peut être affichée ou masquée automatiquement.
]]
L ["ShowOnDetection"] = "Voir la Spy lorsque les joueurs ennemis sont détectés"
L ["ShowOnDetectionDescription"] = "DΘfinir ceci pour afficher la fenêtre Espion et la liste dans les environs si espion est masquée lorsque les joueurs ennemis sont détectés."
L ["HideSpy"] = "Hide espion lorsque aucun joueurs ennemis ne sont détectés"
L ["HideSpyDescription"] = "mettre à la masquer Spy lorsque la liste dans les environs s'affiche et il devient vide. Espion ne sera pas cachée si vous effacez la liste manuellement."
L ["LockSpy"] = "Verrouiller la fenêtre Espion"
L ["LockSpyDescription"] = "Bloquer la fenêtre Espion en place donc il ne bouge pas."
L ["InvertSpy"] = "Inverser la fenêtre Espion"
L ["InvertSpyDescription"] = "Renverse la fenêtre Espion à l'envers."
L ["ResizeSpy"] = "Redimensionner la fenêtre Espion automatiquement"
L ["ResizeSpyDescription"] = "Mettre à la redimensionner automatiquement la fenêtre Espion, comme les joueurs ennemis sont ajoutés et supprimés."
L ["TooltipDisplayWinLoss"] = "Afficher les statistiques de victoires/défaites dans l'info-bulle"
L ["TooltipDisplayWinLossDescription"] = "DΘfinir ceci pour afficher les statistiques de victoires/défaites d'un joueur dans l'info-bulle du joueur."
L ["TooltipDisplayKOSReason"] = "Affichage Kill On Sight raisons dans l'info-bulle"
L ["TooltipDisplayKOSReasonDescription"] = "DΘfinir ceci pour afficher la mise à mort sur les raisons de la vue d'un joueur dans l'info-bulle du joueur."
L ["TooltipDisplayLastSeen"] = "Détails Visualisez la dernière fois dans l'info-bulle"
L ["TooltipDisplayLastSeenDescription"] = "DΘfinir ceci pour afficher la dernière fois connue et l'emplacement d'un joueur dans l'info-bulle du joueur."
 
L ["AlertOptions"] = "Alertes"
L ["AlertOptionsDescription"] = [[
Vous pouvez annoncer les détails sur une rencontre sur un chat canaliser et contrôlent comment espion vous avertit lorsque les joueurs ennemis sont détectés.
]]
L ["Announce"] = "annoncer à:"
L ["None"] = "None"
L ["NoneDescription"] = "N'annoncent pas lorsque les joueurs ennemis sont détectées".
L ["Self"] = "Auto"
L ["SelfDescription"] = "Annonce à vous-même lorsque les joueurs ennemis sont détectés."
L ["Party"] = "Partie"
L ["PartyDescription"] = "Annonce à votre partie lorsque les joueurs ennemis sont détectés."
L ["Guild"] = "Guilde"
L ["GuildDescription"] = "Annonce à votre guilde lorsque les joueurs ennemis sont détectés."
L ["Raid"] = "Raid"
L ["RaidDescription"] = "Annonce à votre raid lorsque les joueurs ennemis sont détectés."
L ["LocalDefense"] = "La défense locale"
L ["LocalDefenseDescription"] = "Annonce sur le canal de défense locale lorsque les joueurs ennemis sont détectés."
L ["OnlyAnnounceKoS"] = "Seulement annoncer les joueurs ennemis qui sont tuer à vue"
L ["OnlyAnnounceKoSDescription"] = "Mettre à n'annoncer que les joueurs ennemis qui se trouvent sur votre Kill sur liste vue."
L ["WarnOnStealth"] = "Avertir en cas de détection furtif"
L ["WarnOnStealthDescription"] = "DΘfinir ceci pour afficher un avertissement et déclenche une alerte lorsque gains d'un joueur ennemi furtif."
L ["WarnOnKOS"] = "Avertir sur Kill sur la détection de la vue"
L ["WarnOnKOSDescription"] = "DΘfinir ceci pour afficher un avertissement et déclenche une alerte lorsqu'un joueur ennemi sur votre Kill sur liste vue est détecté."
L ["WarnOnKOSGuild"] = "Avertir sur Kill sur détection de guilde de vue"
L ["WarnOnKOSGuildDescription"] = "DΘfinir ceci pour afficher un avertissement et déclenche une alerte lorsqu'un joueur ennemi dans la même guilde que quelqu'un sur votre Kill sur liste vue est détecté."
L ["DisplayWarningsInErrorsFrame"] = "Afficher les mises en garde dans le cadre d'Erreurs"
L ["DisplayWarningsInErrorsFrameDescription"] = "DΘfinir cette option pour utiliser la trame d'erreurs pour afficher les avertissements au lieu d'utiliser les cadres popup graphique."
L ["EnableSound"] = "Activer les alertes audio"
L ["EnableSoundDescription"] = "mettre à activer les alertes audio lorsque les joueurs ennemis sont détectés. Différentes alertes sonores si un joueur ennemi acquiert le stealth ou si un joueur ennemi est sur votre liste de Kill On Sight."
 
L ["ListOptions"] = "À proximité de liste"
L ["ListOptionsDescription"] = [[
Vous pouvez configurer Comment espion ajoute et supprime des joueurs ennemis vers et à partir de la liste dans les environs.
]]
L ["RemoveUndetected"] = "supprimer les joueurs ennemis dans la liste dans les environs après:"
L ["1Min"] = "1 minute"
L ["1MinDescription"] = "Supprimer un joueur ennemi non détecté depuis plus d'une minute".
L ["2Min"] = "2 minutes"
L ["2MinDescription"] = "Supprimer un joueur ennemi qui a été non détecté pendant plus de 2 minutes".
L ["5Min"] = "5 minutes"
L ["5MinDescription"] = "Supprimer un joueur ennemi non détecté depuis plus de 5 minutes".
L ["10Min"] = "10 minutes"
L ["10MinDescription"] = "Supprimer un joueur ennemi non détecté depuis plus de 10 minutes".
L ["15Min"] = "15 minutes"
L ["15MinDescription"] = "Supprimer un joueur ennemi qui est depuis plus de 15 minutes non détecté".
L ["Never"] = "Jamais supprimer"
L ["NeverDescription"] = "ne jamais retirer les joueurs ennemis. La liste dans les environs peut encore être éliminée manuellement."
L ["ShowNearbyList"] = "Passer à la liste dans les environs lors de la détection de joueur ennemi"
L ["ShowNearbyListDescription"] = "DΘfinir ceci pour afficher la liste dans les environs, si ce n'est pas déjà visible lorsque les joueurs ennemis sont détectés."
L ["PrioritiseKoS"] = "Hiérarchisation Kill sur les joueurs ennemis vue dans la liste dans les environs"
L ["PrioritiseKoSDescription"] = "DΘfinir ce pour toujours montrer Kill sur les joueurs ennemis vue premier dans la liste dans les environs."
 
L ["MinimapOptions"] = "Carte"
L ["MinimapOptionsDescription"] = [[
Pour les joueurs qui peuvent suivre les humanoïdes de la minicarte peut être utilisée pour fournir des fonctionnalités supplémentaires.
 
Parmi les joueurs qui peuvent suivre les humanoïdes, chasseurs, les druides et ceux qui ont reçu la capacité par d'autres moyens tels que manger un Steak de Worg noirci.
]]
L ["MinimapTracking"] = "Activer le suivi de la minicarte"
L ["MinimapTrackingDescription"] = "dΘfinir ceci afin de permettre la minicarte suivi et détection. Les joueurs ennemis connus détectés sur la minicarte seront ajouteront à la liste dans les environs."
L ["MinimapDetails"] = "Afficher les détails niveau/classe dans les info-bulles"
L ["MinimapDetailsDescription"] = "Mettre à la mettre à jour les info-bulles de carte afin que le niveau/classe détails s'affichent aux côtés de noms ennemis."
L ["DisplayOnMap"] = "Afficher l'emplacement de l'ennemi sur la carte"
L ["DisplayOnMapDescription"] = "Mettre à afficher sur la carte du monde et de la minicarte l'emplacement des ennemis détectés par d'autres utilisateurs d'espion dans votre parti, le raid et la Guilde."
L["SwitchToZone"] = "Switch to current zone map on enemy detection"
L["SwitchToZoneDescription"] = "If the World Map is open this will change the map to the players current zone map when enemies are detected."
L ["MapDisplayLimit"] = "limite affiche des icônes de carte pour:"
L ["LimitNone"] = "Partout"
L ["LimitNoneDescription"] = "Affiche tous les détecté les ennemis sur la carte quel que soit votre lieu de résidence actuel".
L ["LimitSameZone"] = "Zone de même"
L ["LimitSameZoneDescription"] = "affiche seulement détecté ennemis sur la carte si vous êtes dans la même zone."
L ["LimitSameContinent"] = "Même continent"
L ["LimitSameContinentDescription"] = "affiche seulement détecté ennemis sur la carte si vous êtes sur le même continent."
 
L ["DataOptions"] = "Gestion des données"
L ["DataOptionsDescription"] = [[
Vous pouvez configurer Comment espion entretient et recueille ses données.
]]
L ["PurgeData"] = "Purge sans être détectés données joueur ennemi après:"
L ["OneDay"] = "1 jour"
L ["OneDayDescription"] = "Purger les données pour les joueurs ennemis qui ont été détectées pendant 1 jour."
L ["FiveDays"] = "5 jours"
L ["FiveDaysDescription"] = "Purger les données pour les joueurs ennemis qui ont été détectées pendant 5 jours."
L ["TenDays"] = "10 jours"
L ["TenDaysDescription"] = "Purger les données pour les joueurs ennemis qui ont été détectées pendant 10 jours."
L ["ThirtyDays"] = "30 jours"
L ["ThirtyDaysDescription"] = "Purger les données pour les joueurs ennemis qui ont été détectées pendant 30 jours."
L ["SixtyDays"] = "60 jours"
L ["SixtyDaysDescription"] = "Purger les données pour les joueurs ennemis qui ont été détectées pendant 60 jours".
L ["NinetyDays"] = "90 jours"
L ["NinetyDaysDescription"] = "Purger les données pour les joueurs ennemis qui ont été détectées pendant 90 jours".
L ["ShareData"] = "Partager des données avec d'autres utilisateurs d'addon de Spy"
L ["ShareDataDescription"] = "Mettre à partager les détails de votre joueur ennemi des rencontres avec d'autres utilisateurs d'espion dans votre parti, le raid et la Guilde."
L ["UseData"] = "Utiliser les données d'autres utilisateurs d'addon de Spy"
L ["UseDataDescription"] = [[définir cette option pour utiliser les données recueillies par d'autres utilisateurs d'espion dans votre parti, le raid et la Guilde.
 
Si un autre utilisateur d'espion détecte un joueur ennemi alors que le joueur ennemi s'ajouteront à votre liste de voisin si il y a place.
]]
L ["ShareKOSBetweenCharacters"] = "Part tuer sur les joueurs de vue entre vos personnages"
L ["ShareKOSBetweenCharactersDescription"] = "Mettre à partager les joueurs vous marquer comme Kill On Sight entre autres personnages que vous jouez sur le même serveur et de la faction."
 
L ["SlashCommand"] = "Barre oblique commande"
L ["SpySlashDescription"] = "ces boutons exécutent les mêmes fonctions que celles de la /spy de commande de barre oblique"
L ["Enable"] = "Enable"
L ["EnableDescription"] = "Permet Spy et montre la fenêtre principale."
L ["Reset"] = "Reset"
L ["ResetDescription"] = "Réinitialise la position et l'apparence de la fenêtre principale."
L ["Config"] = "Config"
L ["ConfigDescription"] = "Ouvrir la fenêtre de configuration d'Interface Addons pour espionnage."
L ["KOS"] = "KOS"
L ["KOSDescription"] = "Ajouter/supprimer un joueur à/de la tuer sur liste vue."
L ["Ignore"] = "Ignore"
L ["IgnoreDescription"] = "Ajouter/supprimer un joueur vers/depuis la liste des ignorés."
 
--Listes
L ["Nearby"] = "À proximité"
L ["LastHour"] = "Dernière heure"
L ["Ignore"] = "Ignore"
L ["KillOnSight"] = "Tuer à vue"
 
--Stats
--L["Last"] = "Last"
L["Time"] = "Time"	
L["List"] = "List"	
L["Show Only"] = "Show Only"
L["Won/Lost"] = "Won/Lost"
L["Reason"] = "Reason"	 
L["HonorKills"] = "Honor Kills"
L["PvPDeatchs"] = "PvP Deaths"

--++ Class descriptions
--L ["DEATHKNIGHt"] =" chevalier de la mort "
L ["DRUID"] = "Druide"
L ["HUNTER"] = "Chasseur"
L ["MAGE"] = "Mage"
--L ["MONK"] = "Monk"
L ["PALADIN"] = "Paladin"
L ["PRIEST"] = "Prêtre"
L ["ROGUE"] = "Rogue"
L ["SHAMAN"] = "Chaman"
L ["WARLOCK"] = "Warlock"
L ["WARRIOR"] = "Guerrier"
L ["UNKNOWN"] = "Inconnu"
 
--Capacités stealth
L ["Stealth"] = "Stealth"
L ["Prowl"] = "Vagabondage"
 
--Les noms de canal
L ["LocalDefenseChannelName"] = "LocalDefense"
 
--++ Codes couleurs minimap
--L ["MinimapClassTextDEATHKNIGHT"] = "|cffc41e3a"
L ["MinimapClassTextDRUID"] = "|cffff7c0a"
L ["MinimapClassTextHUNTER"] = "|cffaad372"
L ["MinimapClassTextMAGE"] = "|cff68ccef"
--L ["MinimapClassTextMONK"] = "|cff00ff96"
L ["MinimapClassTextPALADIN"] = "|cfff48cba"
L ["MinimapClassTextPRIEST"] = "|cffffffff"
L ["MinimapClassTextROGUE"] = "|cfffff468"
L ["MinimapClassTextSHAMAN"] = "|cff2359ff"
L ["MinimapClassTextWARLOCK"] = "|cff9382c9"
L ["MinimapClassTextWARRIOR"] = "|cffc69b6d"
L ["MinimapClassTextUNKNOWN"] = "|cff191919"
L ["MinimapGuildText"] = "|cffffffff"
 
--Les messages de sortie
L ["AlertStealthTitle"] = "Camouflé lecteur détecté!"
L ["AlertKOSTitle"] = "Tuer le joueur vue détecté!"
L ["AlertKOSGuildTitle"] = "Kill sur guild de joueur de vue détecté!"
L ["AlertTitle_kosaway"] = "player Kill On Sight placé par"
L ["AlertTitle_kosguildaway"] = "guilde player Kill On Sight placé par"
L ["StealthWarning"] = "|cff9933ffStealthed lecteur détecté : |cffffffff"
L ["KOSWarning"] = "|cffff0000Kill le joueur de vue détecté : |cffffffff"
L ["KOSGuildWarning"] = "|cffff0000Kill sur la Guilde de joueur de vue détecté : |cffffffff"
L ["SpySignatureColored"] = "|cff9933ff [Spy]"
L ["PlayerDetectedColored"] = "lecteur détecté : |cffffffff"
L ["PlayersDetectedColored"] = "joueurs détectés : |cffffffff"
L ["KillOnSightDetectedColored"] = "tuer le joueur vue détecté : |cffffffff"
L ["PlayerAddedToIgnoreColored"] = "joueur ajoutée à la liste des ignorés : |cffffffff"
L ["PlayerRemovedFromIgnoreColored"] = "lecteur supprimé de la liste des ignorés : |cffffffff"
L ["PlayerAddedToKOSColored"] = "joueur Added to Kill sur liste vue : |cffffffff"
L ["PlayerRemovedFromKOSColored"] = "Removed joueuse de Kill sur liste vue : |cffffffff"
L ["PlayerDetected"] = "[Spy] lecteur détecté:"
L ["KillOnSightDetected"] = "joueur [Spy] Kill On Sight détecté:"
L ["Level"] = "Niveau"
L ["LastSeen"] = "Dernière visite"
L ["LessThanOneMinuteAgo"] = "moins d'une minute il y a"
L ["MinutesAgo"] = "il y a des minutes"
L ["HoursAgo"] = "heures"
L ["DaysAgo"] = "jours"
L ["Close"] = "Fermer"
L ["CloseDescription"] = "|cffffffffHides la fenêtre Espion. Par défaut apparait de nouveau quand le prochain joueur ennemi est détecté."
L ["Left/Right"] = "Left/Right"
L ["Left/RightDescription"] = "|cffffffffNavigates entre dans les environs, dernière heure, ignorer et tuer sur les listes de la vue."
L ["Clear"] = "Clear"
L ["ClearDescription"] = "|cffffffffClears la liste des joueurs qui ont été détectés. CTRL-clic will Enable/Disable Spy alors qu'affichés."
L ["NearbyCount"] = "À proximité de Count"
L ["NearbyCountDescription"] = "|cffffffffSends le nombre de joueurs à proximité de chat."
L ["AddToIgnoreList"] = "Ajouter à la liste des ignorés"
L ["AddToKOSList"] = "Add to Kill sur liste vue"
L ["RemoveFromIgnoreList"] = "Supprimer de la liste des ignorés"
L ["RemoveFromKOSList"] = "Supprimer du Kill sur liste vue"
L ["AnnounceDropDownMenu"] = "Annoncer"
L ["KOSReasonDropDownMenu"] = "Set Kill sur la raison de la vue"
L ["PartyDropDownMenu"] = "Partie"
L ["RaidDropDownMenu"] = "Raid"
L ["GuildDropDownMenu"] = "Guilde"
L ["LocalDefenseDropDownMenu"] = "La défense locale"
L ["Player"] = "(joueur)"
L ["KOSReason"] = "Tuer à vue"
L ["KOSReasonIndent"] = ""
L ["KOSReasonOther"] = "Entrez votre propre raison..."
L ["KOSReasonClear"] = "Clear"
L ["StatsWins"] = "|cff40ff00Wins:"
L ["StatsSeparator"] = ""
L ["StatsLoses"] = "|cff0070ddLoses:"
L ["Located"] = "situé:"
L ["Yards"] = "mètres"
 
--Spy_KOSReasonListLength = 13
Spy_KOSReasonListLength = 6
Spy_KOSReasonList = {
[1] = {
["title"] = "Démarrer combat" ;
["content"] = {
--"Dans une embuscade de moi",
--"Toujours m'attaque à vue",
"M'a attaqué sans raison",
"M'a attaqué à un donneur de quête",--++
"M'a attaqué alors que je me battais PNJs",
"M'a attaqué alors que j'étais entrée/sortie d'une instance",
"M'a attaqué alors que j'étais AFK",
--"M'a attaqué alors que j'étais dans une bataille pour animaux de compagnie",--++
"M'a attaqué alors que j'étais monté/flying",
"M'a attaqué alors que j'avais faible santé/mana",
--"Écrasé me avec un groupe d'ennemis",
--"N'attaque pas sans sauvegarde",
--"Osé me défier",
                                };
                },
[2] = {
["title"] = "Style de combat" ;
["content"] = {
"Dans une embuscade de moi",
"Toujours m'attaque à vue",
"M'a tué moi avec un personnage de niveau plus élevé",--++
"Écrasé me avec un groupe d'ennemis ",
"N'attaque pas sans sauvegarde",
"Appelle toujours de l'aide",
--"M'a poussé une falaise",
--"Utilisations astuces d'ingénierie",
"Utilisations trop crowd control",
--"Spams en permanence une capacité",
--"M'a forcé à prendre des dégâts de durabilité",
--"M'a tué et mes amis ont fui",
--"Ran away puis tombé dans une embuscade me",
--"Parvient toujours à s'échapper",
--"Foyers de bulle à s'échapper",
--"Parvient à rester dans la plage de mêlée",
--"Parvient à rester au cerf-volant de plage",
--"Absorbe trop de dégâts",
--"Guérit trop",
--"DPS est trop",
                                };
                },
-- [3] = {
--["title"] = "Comportement général" ;
--["content"] = {}
--"Ennuyeux",
--"Grossièreté",
--"Lâcheté",
--"L'arrogance",
--"Excès de confiance",
--"Non fiable",
--"Emotes trop",
--"Pédonculées me / amis ",
--"Fait semblant d'être bon",
--"Emotes "qui ne va ne pas se produire"",
--"Goodbye de vagues à faible santé",
--"Essayé de me calmer avec une vague",
--"Actes fétide effectués sur mon cadavre",
--"Ri de moi",
--"Craché sur moi",
--                             };
--             },
[3] = {
["title"] = "Camping" ;
["content"] = {
"Campé me",
"Campé un alt",
"Campée lowbies",
"Campé de stealth",
"Membres de la Guilde campée",
"Campé jeu PNJ/objectifs",
"Campé un ville/site",
--"Appelé en aide me camper",
--"Fait un cauchemar de nivellement",
--"M'a forcé à se déconnecter",
--"Ne sera pas battre mon principal",
                                };
                },
[4] = {
["title"] = "Quêtes" ;
["content"] = {
"M'a attaqué alors que j'étais quêtes",
"M'a attaqué après que j'ai aidé avec une quête",
"Interféré avec les objectifs de quête",
"A commencé une quête que je voulais faire",
"Tué le PNJ de la faction",
"Tué une PNJ de quête",
                                };
                },
[5] = {
["title"] = "A volé les ressources" ;
["content"] = {
"Herbes recueillies je voulais",
"Minéraux réunis je voulais",
"Les ressources collectées je voulais",
--"Gaz extrait d'un nuage, j'ai voulu",
"M'a tué et a volé ma cible/rares NPC",
"Mon tue la peau",
"Récupéré mon Tue",
"Pêché dans ma piscine",
                                };
                },
--[[ [7] = {
["title"] = "Champs de bataille;"
["content"] = {
"Toujours les cadavres de loots",
"Coureur de très bon indicateur",
"Backcaps drapeaux ou bases",
"Stealth casquettes drapeaux ou bases",
"M'a tué et a pris le drapeau",
"Interfère avec les objectifs du champ de bataille",
"A pris un power-up, que j'ai voulu",
"Citerne forcé de perdre agro",
"Causé une lingette",
"Détruit les engins de siège",
"Chute des bombes",
"Désarme les bombes",
"Bombardier de la peur",
                                };
                },
[8] = {
["title"] = "Vraie vie" ;
["content"] = {
"Un ami dans la vraie vie",
"L'ennemi dans la vraie vie",
"Se répand les rumeurs à propos de moi",
"Se plaint sur les forums",
"Spy pour l'autre faction"
"Traître à ma faction",
"Revenue sur un accord",
"Nub prétentieux",
"Un autre Omniscient",
"Une autre Johnny-come-lately",
"Cross faction corbeille automate vocal",
                                };
                },
[9] = {
["title"] = "Difficulté" ;
["content"] = {
"Impossible de tuer",
"La plupart du temps des victoires",
"Semble être un match équitable",
"Perd la plupart du temps",
"Plaisir de tuer",
"Facile d'honneur",
                                };
                },
[10] = {}
["title"] = "Race" ;
["content"] = {
"Hate de course du joueur",
"Les elfes de sang sont narcissiques",
"Draeneï sont calmars espace visqueux",
"Les nains sont butées poilues courtes",
"Lutins vendraient leur propre mère pour un bénéfice",
"Gnomes appartiennent dans un jardin",
"Les humains sont intrigantes justes",
"Les elfes de la nuit embrasser trop d'arbres",
"Orcs sont barbares belliciste",
"Pandarens garder me disait de ralentir",--++
"Tauren devrait être sur mon burger",
"Trolls devraient rester sur les forums web",
"Morts-vivants sont des abominations contre naturels",
"Les worgens ont trop de puces",
                                };
                },
[11] = {}
["title"] = "Classe" ;
["content"] = {
"Classe du joueur de haine",
"Les Chevaliers de la mort sont maîtrisés",
"Les druides sont sales animaux",
"Les chasseurs sont mode facile",
"Mages sont trompés intellects",
"Chi de moines est faible",--++
"Les paladins sont des imbéciles moralisateurs"
"Les prêtres sont des prédicateurs pieux",
"Les voleurs n'ont aucun honneur",
"Chamans parlent aux animaux imaginaires",
"Les démonistes sont sadiques Nécromanciens",
"Guerriers ont des problèmes de colère",
                                };
                },
[12] = {}
["title"] = "Nom" ;
["content"] = {
"A un nom ridicule",
"Nom prétentieux",
"Variante de Legolas",
"Nom a des caractères bizarres",
"Nom de guilde est ridicule",
"Nom de guilde utilise uniquement des lettres majuscules",
"Nom de guilde utilise les majuscules et les espaces",
"Nom de guilde déclare qu'ils détestent ma faction",
                                };
                },]]--
-- [13] = {
[6] = {
["title"] = "Autre" ;
["content"] = {
--"Karma",
--"Rouge est mort",
--"Juste parce que",
--"Échoue au PvP",
"Marqué pour le PvP",
--"Ne veut pas PvP",
--"Perd les deux de notre temps",
--"Ce joueur est un noob",
--"Je déteste vraiment ce joueur",
--"N'est pas de niveau assez rapidement",
"M'a poussé une falaise",
"Utilise des astuces techniques",
"Toujours parvient à s'échapper",
"Utilise les éléments et les compétences pour échapper",
"Mécanismes de jeu exploits",
--"Hacker présumé",
--"Fermier",
--"Autre...",
"Entrez votre propre raison...",
                                };
                },
}
 
StaticPopupDialogs ["Spy_SetKOSReasonOther"] = {
	preferredIndex = STATICPOPUPS_NUMDIALOGS,--http://forums.wowace.com/showthread.php?p=320956
	text = "Entrez le tuer sur le motif de la vue de %s:",
	button1 = "Valeur",
	button2 = "Annuler",
	timeout = 20,
	hasEditBox = 1,
	whileDead = 1,
	hideOnEscape = 1,
	OnShow = function(self)
		self.editBox:SetText("") ;
	end,
		OnAccept = function(self)
		local reason = self.editBox:GetText()
--		Spy:SetKOSReason(self.playerName, "Other...", reason)
		Spy:SetKOSReason(self.playerName, "Entrez votre propre raison...", reason)
	end,
};
 
Spy_AbilityList = {
 
-----------------------------------------------------------
--Permet une estimation de la course, la classe et le niveau d'un
--joueur à être désigné de quelles capacités sont observés
--dans le journal de combat.
-----------------------------------------------------------

};
