local L = LibStub("AceLocale-3.0"):NewLocale("Spy", "ptIT")
if not L then return end


--Informazioni Addon
L ["Spy"] = "Spy"
L ["versione"] = "Versione"
L ["LoadDescription"] = "addon |cff9933ffSpy caricato. Tipo |cffffffff/spy|cff9933ff per le opzioni".
L ["SpyEnabled"] = "|cff9933ffSpy addon abilitato."
L ["SpyDisabled"] = "addon |cff9933ffSpy disabilitato. Tipo show|cff9933ff |cffffffff/spia per abilitare".
L ["UpgradeAvailable"] = "|cff9933ffA nuova versione di Spy è disponibile. Può essere scaricato da: \n| cffffffffhttps://mods.curse.com/addons/wow/spy"

--Stringhe di configurazione
L ["profili"] = "Profili"

L ["GeneralSettings"] = "Impostazioni generali"
L ["SpyDescription1"] = [[
Spy è un addon che vi avviserà della presenza di giocatori nemici nelle vicinanze.
]]
L ["SpyDescription2"] = [[
 
|cffffd000Nearby list|cffffffff
Nell'elenco nelle vicinanze vengono visualizzati eventuali giocatori nemici che sono stati rilevati nelle vicinanze. Facendo clic su elenco consente di indirizzare il giocatore, però questo funziona solo fuori di combattimento. I giocatori vengono rimossi dall'elenco se non sono stati rilevati dopo un periodo di tempo.

Il pulsante Annulla nella barra del titolo può essere utilizzato per cancellare l'elenco, e tenendo premuto Control mentre cancellare la lista vi permetterà di attivare o disattivare rapidamente Spy.

|cffffd000Last ore list|cffffffff
La lista di ultima ora Visualizza tutti i nemici che sono stati rilevati nell'ultima ora.

|cffffd000Ignore list|cffffffff
I giocatori che sono aggiunti alla lista Ignore non verranno segnalati da spia. È possibile aggiungere e rimuovere i giocatori da questo elenco utilizzando il menu a discesa del pulsante o tenendo premuto il tasto Control mentre si fa clic sul pulsante.

|cffffd000Kill in vista list|cffffffff
I giocatori nella tua lista di uccidere su vista causano un allarme sonoro quando rilevato. È possibile aggiungere e rimuovere i giocatori da questa lista utilizzando il menu a discesa del pulsante o tenendo premuto il tasto MAIUSC mentre si fa clic sul pulsante.

Utilizzabile anche il menu a discesa per impostare le ragioni perché hai qualcuno aggiunto all'elenco di uccidere su vista. Se volete inserire un motivo specifico che non è nell'elenco, quindi utilizzare il "Inserisci il tuo motivo..." in Altro elenco.
 
 
|cffffd000Author: http://www.curse.com/users/slipjack |cffffffff
 
]]
L ["EnableSpy"] = "Attiva spia"
L ["EnableSpyDescription"] = "attiva o disattiva Spy sia ora che anche in login".
L ["EnabledInBattlegrounds"] = "Attiva spia in campi di battaglia"
L ["EnabledInBattlegroundsDescription"] = "Attiva o disattiva la spia quando sei in un campo di battaglia."
L ["EnabledInArenas"] = "Attiva spia nelle arene"
L ["EnabledInArenasDescription"] = "Attiva o disattiva la spia quando siete in un arena."
L ["EnabledInWintergrasp"] = "Attiva spia in zone di combattimento mondiale"
L ["EnabledInWintergraspDescription"] = "Attiva o disattiva la spia quando si è in zone di combattimento mondiale quali Lake Wintergrasp in Northrend."
L ["DisableWhenPVPUnflagged"] = "Disable spia quando non contrassegnati per PVP"
L ["DisableWhenPVPUnflaggedDescription"] = "Attiva o disattiva la spia a seconda del tuo stato PVP."
 
L ["DisplayOptions"] = "Display"
L ["DisplayOptionsDescription"] = [[
Spia può essere visualizzata o nascosta automaticamente.
]]
L ["ShowOnDetection"] = "Visualizza Spy quando vengono rilevati i giocatori nemici"
L ["ShowOnDetectionDescription"] = "Imposta questo per visualizzare la finestra di Spy e l'elenco nelle vicinanze se la spia è nascosto quando vengono rilevati i giocatori nemici."
L ["HideSpy"] = "Nascondi Spy quando non vengono rilevati giocatori nemici"
L ["HideSpyDescription"] = "imposta questo nascondere Spy quando viene visualizzato l'elenco nelle vicinanze e diventa vuota. Spy sarà non nascosto se si cancella la lista manualmente."
L ["LockSpy"] = "Blocca la finestra spia"
L ["LockSpyDescription"] = "Blocca la finestra spia in posto così non si muove".
L ["InvertSpy"] = "Inverti la finestra spia"
L ["InvertSpyDescription"] = "Capovolge sottosopra la finestra spia."
L ["ResizeSpy"] = "Ridimensionare automaticamente la finestra spia"
L ["ResizeSpyDescription"] = "Imposta questo per ridimensionare automaticamente la finestra spia come giocatori nemici vengono aggiunti e rimossi".
L ["TooltipDisplayWinLoss"] = "Visualizza statistiche di vincita/perdita nel tooltip"
L ["TooltipDisplayWinLossDescription"] = "Imposta questo per visualizzare le statistiche di vincita/perdita di un giocatore nel tooltip del giocatore".
L ["TooltipDisplayKOSReason"] = "Motivi di Display di uccidere a vista nel tooltip"
L ["TooltipDisplayKOSReasonDescription"] = "Imposta questo per visualizzare il Kill su motivi di vista di un giocatore nel tooltip del giocatore".
L ["TooltipDisplayLastSeen"] = "Dettagli Display visto l'ultima volta nel tooltip"
L ["TooltipDisplayLastSeenDescription"] = "Imposta questo per visualizzare l'ultima volta di noto e la posizione di un giocatore nel tooltip del giocatore".
 
L ["AlertOptions"] = "Avvisi"
L ["AlertOptionsDescription"] = [[
Si può annunciare i dettagli su un incontro a una chat di canale e controllano come spia avvisa l'utente quando vengono rilevati i giocatori nemici.
]]
L ["annunciare"] = "annunciare a:"
L ["nessuno"] = "None"
L ["NoneDescription"] = "non annunciare quando vengono rilevati i giocatori nemici."
L ["Self"] = "Auto"
L ["SelfDescription"] = "Annuncio a te stesso quando vengono rilevati i giocatori nemici."
L ["Party"] = "Party"
L ["PartyDescription"] = "Annunciare al vostro partito quando vengono rilevati i giocatori nemici."
L ["Gilda"] = "Guild"
L ["GuildDescription"] = "Annuncio alla tua gilda quando vengono rilevati i giocatori nemici."
L ["Raid"] = "Raid"
L ["RaidDescription"] = "Annuncio a vostro raid quando vengono rilevati i giocatori nemici."
L ["LocalDefense"] = "Difesa locale"
L ["LocalDefenseDescription"] = "Annuncio per il canale di difesa locale quando vengono rilevati i giocatori nemici."
L ["OnlyAnnounceKoS"] = "Annunciare solo giocatori nemici che sono di uccidere a vista"
L ["OnlyAnnounceKoSDescription"] = "Imposta questo per annunciare solo giocatori nemici che sono sul tuo uccidere lista vista."
L ["WarnOnStealth"] = "Avvisa al momento della rilevazione stealth"
L ["WarnOnStealthDescription"] = "Imposta questo per visualizzare un avviso e suonare un allarme quando un giocatore nemico guadagna stealth."
L ["WarnOnKOS"] = "Avvisa su Kill su rilevazione vista"
L ["WarnOnKOSDescription"] = "Imposta questo per visualizzare un avviso e suonare un allarme quando viene rilevato un giocatore nemico sul tuo uccidere lista vista."
L ["WarnOnKOSGuild"] = "Avvisa a uccidere il rilevamento Gilda Sight"
L ["WarnOnKOSGuildDescription"] = "Imposta questo per visualizzare un avviso e suonare un allarme quando viene rilevato un giocatore nemico nella stessa gilda come qualcuno sul tuo uccidere lista vista."
L ["DisplayWarningsInErrorsFrame"] = "Visualizza avvisi nella cornice errori"
L ["DisplayWarningsInErrorsFrameDescription"] = "Imposta questo utilizzare la cornice di errori per visualizzare avvisi anziché utilizzare le cornici grafiche pop-up".
L ["EnableSound"] = "Attiva gli avvisi audio"
L ["EnableSoundDescription"] = "imposta questo comando per attivare gli avvisi audio quando vengono rilevati i giocatori nemici. Avvisi diversi sound se un giocatore nemico guadagna stealth o se un giocatore nemico è sulla vostra lista di uccidere su vista."
 
L ["ListOptions"] = "Nelle vicinanze di lista"
L ["ListOptionsDescription"] = [[
È possibile configurare come Spy aggiunge e rimuove i giocatori nemici da e per l'elenco nelle vicinanze.
]]
L ["RemoveUndetected"] = "rimuovere giocatori nemici dall'elenco nelle vicinanze dopo:"
L ["1Min"] = "1 minuto"
L ["1MinDescription"] = "Rimuovi un giocatore nemico che è stato non rilevato per più di 1 minuto".
L ["2Min"] = "2 minuti"
L ["2MinDescription"] = "Rimuovi un giocatore nemico che è stato non rilevato per oltre 2 minuti."
L ["5Min"] = "5 minuti"
L ["5MinDescription"] = "Rimuovi un giocatore nemico che è stato non rilevato per oltre 5 minuti."
L ["10Min"] = "10 minuti"
L ["10MinDescription"] = "Rimuovi un giocatore nemico che è stato non rilevato da più di 10 minuti."
L ["15Min"] = "15 minuti"
L ["15MinDescription"] = "Rimuovi un giocatore nemico che è stato non rilevato per oltre 15 minuti".
L ["mai"] = "Non rimuovere mai"
L ["NeverDescription"] = "non rimuovere mai giocatori nemici. L'elenco nelle vicinanze può ancora essere cancellato manualmente."
L ["ShowNearbyList"] = "Cambia l'elenco nelle vicinanze al momento della rilevazione del giocatore nemico"
L ["ShowNearbyListDescription"] = "Impostare questo per visualizzare l'elenco nelle vicinanze se non è già visibile quando vengono rilevati i giocatori nemici."
L ["PrioritiseKoS"] = "Kill Prioritise su giocatori nemici vista nell'elenco nelle vicinanze"
L ["PrioritiseKoSDescription"] = "Imposta questo per mostrare sempre uccidere su giocatori nemici vista prima nell'elenco nelle vicinanze".
 
L ["MinimapOptions"] = "Mappa"
L ["MinimapOptionsDescription"] = [[
Per i giocatori che possono rintracciare umanoidi minimappa può essere utilizzata per fornire funzionalità aggiuntive.
 
I giocatori che possono rintracciare umanoidi includono cacciatori, druidi e coloro che hanno ricevuto la capacità attraverso altri mezzi, come mangiare una bistecca di Worg annerito.
]]
L ["MinimapTracking"] = "Attiva rilevamento minimappa"
L ["MinimapTrackingDescription"] = "impostare questo per abilitare la minimappa tracciamento e rilevazione. Noti giocatori nemici rilevati sulla minimappa verranno aggiunto all'elenco nelle vicinanze."
L ["MinimapDetails"] = "Dettagli di classe a livello di Display nelle descrizioni comandi"
L ["MinimapDetailsDescription"] = "Imposta questo per aggiornare la mappa tooltips dettagli a livello di classe e vengono visualizzati accanto a nomi nemici."
L ["DisplayOnMap"] = "Posizione nemica di visualizzare su mappa"
L ["DisplayOnMapDescription"] = "Imposta questo per visualizzare sulla mappa del mondo e minimappa la posizione dei nemici, rilevato da altri utenti spia nel vostro partito, raid e Gilda".
L["SwitchToZone"] = "Switch to current zone map on enemy detection"
L["SwitchToZoneDescription"] = "If the World Map is open this will change the map to the players current zone map when enemies are detected."
L ["MapDisplayLimit"] = "limite visualizzato mappa delle icone:"
L ["LimitNone"] = "Ovunque"
L ["LimitNoneDescription"] = "Nemici Displayes tutte rilevato sulla mappa indipendentemente dalla vostra attuale posizione."
L ["LimitSameZone"] = "Stessa zona"
L ["LimitSameZoneDescription"] = "unico display rilevati nemici sulla mappa, se siete nella stessa zona".
L ["LimitSameContinent"] = "Stesso continente"
L ["LimitSameContinentDescription"] = "Visualizza solo rilevati i nemici sulla mappa se sei del continente stesso."
 
L ["DataOptions"] = "Gestione dati"
L ["DataOptionsDescription"] = [[
È possibile configurare come spia mantiene e raccoglie i suoi dati.
]]
L ["PurgeData"] = "Purge non rilevati dati giocatore nemico dopo:"
L ["OneDay"] = "1 giorno"
L ["OneDayDescription"] = "Elimina dati per giocatori nemici che sono stati rilevati per 1 giorno".
L ["FiveDays"] = "5 giorni"
L ["FiveDaysDescription"] = "Elimina dati per giocatori nemici che sono stati rilevati per 5 giorni".
L ["franchigia"] = "10 giorni"
L ["TenDaysDescription"] = "Elimina dati per giocatori nemici che sono stati rilevati per 10 giorni."
L ["ThirtyDays"] = "30 giorni"
L ["ThirtyDaysDescription"] = "Elimina dati per giocatori nemici che sono stati rilevati per 30 giorni."
L ["SixtyDays"] = "60 giorni"
L ["SixtyDaysDescription"] = "Elimina dati per giocatori nemici che sono stati rilevati per 60 giorni."
L ["NinetyDays"] = "90 giorni"
L ["NinetyDaysDescription"] = "Elimina dati per giocatori nemici che sono stati rilevati per 90 giorni".
L ["ShareData"] = "Condividere i dati con altri utenti di addon Spy"
L ["ShareDataDescription"] = "Imposta questo per condividere i dettagli del vostro giocatore nemico incontri con altri utenti spia nel vostro partito, raid e Gilda".
L ["UseData"] = "Usa dati da altri utenti di addon Spy"
L ["UseDataDescription"] = [[impostare questa opzione per utilizzare i dati raccolti da altri utenti spia nel vostro partito, raid e Gilda.
 
Se un altro utente spia rileva un giocatore nemico allora quel giocatore nemico verrà aggiunto alla tua lista vicina se c'è spazio.
]]
L ["ShareKOSBetweenCharacters"] = "Kill Condividi su giocatori vista tra i tuoi personaggi"
L ["ShareKOSBetweenCharactersDescription"] = "Imposta questo per condividere i giocatori si contrassegna come uccidere a vista tra fazione e altri personaggi che si gioca sul server stesso."
 
L ["SlashCommand"] = "Barra di comando"
L ["SpySlashDescription"] = "questi pulsanti eseguono le stesse funzioni di quelli il /spy comando slash"
L ["Enable"] = "Enable"
L ["EnableDescription"] = "Abilita Spy e mostra la finestra principale."
L ["Reset"] = "Reset"
L ["ResetDescription"] = "Reimposta la posizione e l'aspetto della finestra principale."
L ["Config"] = "Config"
L ["ConfigDescription"] = "Aprire la finestra di configurazione interfaccia Addons per spia."
L ["KO"] = "KOS"
L ["KOSDescription"] = "Aggiungi/Rimuovi un giocatore da/per l'uccidere lista vista."
L ["Ignore"] = "Ignore"
L ["IgnoreDescription"] = "Aggiungi/Rimuovi un giocatore da/per la lista Ignora."
 
--Elenchi
L ["Nearby"] = "Vicino"
L ["LastHour"] = "Ultima ora"
L ["Ignore"] = "Ignorare"
L ["KillOnSight"] = "Uccidere a vista"

--Stats
--L["Last"] = "Last"
L["Time"] = "Time"	
L["List"] = "List"	
L["Show Only"] = "Show Only"
L["Won/Lost"] = "Won/Lost"
L["Reason"] = "Reason"	 
L["HonorKills"] = "Honor Kills"
L["PvPDeatchs"] = "PvP Deaths"
 
--+ + Descrizioni di classe
--L ["DEATHKNIGHT"] = "cavaliere della morte"
L ["DRUID"] = "Druido"
L ["HUNTER"] = "Cacciatore"
L ["MAGE"] = "Mago"
--L ["MONK"] = "Monk"
L ["PALADIN"] = "Paladino"
L ["PRIEST"] = "Sacerdote"
L ["ROGUE"] = "Canaglia"
L ["SHAMAN"] = "Sciamano"
L ["WARLOCK"] = "Stregone"
L ["WARRIOR"] = "Guerriero"
L ["UNKNOWN"] = "Unknown"
 
--Abilità stealth
L ["Stealth"] = "Stealth"
L ["Prowl"] = "Agguato"
 
--I nomi dei canali
L ["LocalDefenseChannelName"] = "LocalDefense"
 
--++ Codici colore minimappa
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
 
--I messaggi di output
L ["AlertStealthTitle"] = "Rilevato furtivo giocatore!"
L ["AlertKOSTitle"] = "Uccidere Player vista rilevato!"
L ["AlertKOSGuildTitle"] = "Uccidere su Gilda di giocatore vista rilevato!"
L ["AlertTitle_kosaway"] = "trova giocatore uccidere su vista"
L ["AlertTitle_kosguildaway"] = "trova Gilda giocatore uccidere su vista"
L ["StealthWarning"] = "lettore di |cff9933ffStealthed rilevato: |cffffffff"
L ["KOSWarning"] = "|cffff0000Kill lettore di vista rilevati: |cffffffff"
L ["KOSGuildWarning"] = "|cffff0000Kill su Gilda di giocatore vista rilevato: |cffffffff"
L ["SpySignatureColored"] = "|cff9933ff [Spy]"
L ["PlayerDetectedColored"] = "lettore rilevato: |cffffffff"
L ["PlayersDetectedColored"] = "i giocatori rilevati: |cffffffff"
L ["KillOnSightDetectedColored"] = "uccidere Player vista rilevati: |cffffffff"
L ["PlayerAddedToIgnoreColored"] = "giocatore aggiunto alla lista Ignora: |cffffffff"
L ["PlayerRemovedFromIgnoreColored"] = "lettore rimosso dalla lista Ignora: |cffffffff"
L ["PlayerAddedToKOSColored"] = "giocatore aggiunto per uccidere lista vista: |cffffffff"
L ["PlayerRemovedFromKOSColored"] = "lettore rimosso da uccidere lista vista: |cffffffff"
L ["PlayerDetected"] = "[Spy] giocatore rilevato:"
L ["KillOnSightDetected"] = "lettore di uccidere [Spy] su vista rilevato:"
L ["livello"] = "Livello"
L ["LastSeen"] = "Visto l'ultima volta"
L ["LessThanOneMinuteAgo"] = "meno di un minuto fa"
L ["MinutesAgo"] = "minuti fa"
L ["HoursAgo"] = "ore"
L ["DaysAgo"] = "giorni fa"
L ["chiudere"] = "Chiudi"
L ["CloseDescription"] = "|cffffffffHides la finestra spia. Per impostazione predefinita mostrerà nuovamente quando viene rilevato il prossimo giocatore nemico."
L [destra/sinistra"] =" Destra/sinistra"
L ["sinistra/RightDescription"] = "|cffffffffNavigates tra nelle vicinanze, ultima ora, Ignore e Kill su liste di vista."
L ["Clear"] = "Cancella"
L ["ClearDescription"] = "|cffffffffClears la lista dei giocatori che sono stati rilevati. CTRL + clic sarà spia attiva/disattiva mentre visualizzato."
L ["NearbyCount"] = "È vicino a Conte"
L ["NearbyCountDescription"] = "il conteggio dei giocatori vicini alla chat di |cffffffffSends."
L ["AddToIgnoreList"] = "Aggiungi a lista Ignora"
L ["AddToKOSList"] = "Aggiungi a uccidere lista vista"
L ["RemoveFromIgnoreList"] = "Rimuovi dalla lista Ignora"
L ["RemoveFromKOSList"] = "Rimuovi da uccidere lista vista"
L ["AnnounceDropDownMenu"] = "Annunciare"
L ["KOSReasonDropDownMenu"] = "Set Kill sul motivo della vista"
L ["PartyDropDownMenu"] = "Party"
L ["RaidDropDownMenu"] = "Raid"
L ["GuildDropDownMenu"] = "Guild"
L ["LocalDefenseDropDownMenu"] = "Difesa locale"
L ["Player"] = "(giocatore)"
L ["KOSReason"] = "Uccidere a vista"
L ["KOSReasonIndent"] = ""
L ["KOSReasonOther"] = "Inserisci il tuo motivo..."
L ["KOSReasonClear"] = "Cancella"
L ["StatsWins"] = "|cff40ff00Wins:"
L ["StatsSeparator"] = ""
L ["StatsLoses"] = "|cff0070ddLoses:"
L ["situato"] = "trova:"
L ["cantieri"] = "cantieri"
 
--Spy_KOSReasonListLength = 13
Spy_KOSReasonListLength = 6
Spy_KOSReasonList = {
[1] = {
["title"] = "Started combattimento";
["content"] = {
--"Un'imboscata me",
--"Sempre mi attacca a vista",
"Mi attaccato senza motivo",
"Mi ha attaccato a un quest donatore",--++
"Mi attaccato mentre combattevo NPC",
"Attaccato me mentre stavo entrando/lasciando un'istanza",
"Mi attaccato mentre ero AFK",
--"Mi attaccato mentre ero in una battaglia dell'animale domestico",-- + +
"Mi attaccato mentre ero montato/volante",
"Mi attaccato mentre ho avuto scarsa salute/mana",
--"Steamrolled me con un gruppo di nemici",
--"Non attacca senza backup",
--"Osato sfidarmi",
                                };
                },
[2] = {
["title"] = "Stile di combattimento";
["content"] = {
"Un'imboscata me",
"Sempre mi attacca a vista",
"Mi ha ucciso me con un personaggio di livello superiore", --+ +
"Steamrolled me con un gruppo di nemici",
"Non attacca senza backup",
"Sempre chiede aiuto",
--"Mi ha spinto giù da una rupe",
--"Usi trucchi di ingegneria",
"Usi troppo folla controllo",
--"Una capacità di spam tutto il tempo",
--"Mi ha costretto a prendere danni di durata",
--"Mi ha ucciso e fuoriuscito dai miei amici",
--"Ran via allora un'imboscata me",
--"Riesce sempre a fuggire",
--"Focolari di bolla di fuggire",
--"Riesce a rimanere nella gamma di mischia",
--"Riesce a rimanere al kite gamma",
--"Assorbe troppi danni",
--"Troppo guarisce",
--"DPS s troppo",
                                };
                },
-- [3] = {
--["title"] = "Comportamento generale";
--["content"] = {
--"Fastidioso",
--"Maleducazione",
--"Codardia",
--"Arroganza",
--"Overconfidence",
--"Inaffidabile",
--"Emotes troppo",
--"Inseguito me / gli amici",
--"Finge di essere buona,"
--"Emotes 'non accadra'",
--"Addio onde presso salute bassa",
--"Tentò di placare me con un'onda",
--"Atti fallo eseguite sul mio cadavere»,
--	"Rise con me",
--"Sputato su di me",
--                             };
--             },
[3] = {
["title"] = "Camping";
["content"] = {
"Accampati me",
"Accampato un alt",
"Accampata lowbies",
"Accampati da stealth",
"Membri della Gilda accampata",
"Accampati giochi NPC/obiettivi",
"Accampato un sito di città",
--"Chiamato in aiuto al campo di me",
--"Made livellamento un incubo",
--"Mi ha costretto a logout",
--"Non vuole combattere il mio principale",
                                };
                },
[4] = {
["title"] = "Questing";
["content"] = {
"Mi attaccato mentre io stavo questua",
"Attaccato me dopo che aiutato con una missione",
"Ha interferito con gli obiettivi di missione",
"Ha iniziato una ricerca che volevo fare",
"Ha ucciso la NPC mia fazione",
"Ucciso una missione NPC",
                                };
                },
[5] = {
["title"] = "Ha rubato le risorse";
["content"] = {
"Erbe raccolte volevo",
"Minerali raccolti volevo",
"Risorse raccolte volevo",
--"Gas estratte da una nube che volevo",
"Mi ha ucciso e rubato la mia destinazione/rara NPC",
"Dalla pelle mia uccide",
"Salvato il mio uccide",
"Pescato nella mia piscina",
                                };
                },
--[[ [7] = {
["title"] = "Battlegrounds";
["content"] = {
"Sempre cadaveri saccheggia",
"Corridore bandiera molto buona",
"Backcaps flag o basi",
"Stealth Cappelli con bandiere o basi",
"Mi ha ucciso e ha preso la bandiera",
"Interferisce con gli obiettivi del campo di battaglia",
"Ha preso un power-up che ho voluto",
"Forzata serbatoio a perdere agro",
"Ha causato un wipe",
"Distrugge d'assedio",
"Gocce di bombe",
"Disarma bombe",
"Bombardiere della paura",
                                };
                },
[8] = {
["title"] = "Vita reale";
["content"] = {
"Amico nella vita reale",
"Nemico nella vita reale",
"Si diffonde voci su di me",
"Si lamenta sul forum",
"Spy per l'altra fazione",
"Traditore alla mia fazione",
"Rinnegato un affare",
"Pretenzioso nocciolo",
"Un altro saputella",
"Un altro Johnny-come-lately",
"Attraversare fazione trash talker",
                                };
                },
[9] = {
["title"] = "Difficoltà";
["content"] = {
"Impossibile da uccidere",
"Vince la maggior parte del tempo",
"Sembra una fiera partita",
"Perde la maggior parte del tempo",
"Divertimento uccidere",
"Facile onorare",
                                };
                },
[10] = {
["title"] = "Gara";
["content"] = {
"Odio la corsa del giocatore",
"Elfi del sangue sono narcisiste",
"Draenei sono calamari spazio viscido",
"I nani sono brevi battute Pelosi",
"Goblin avrebbe venduto le proprie madri per un profitto",
"Gnomi appartengono in un giardino",
"Gli esseri umani sono giusti ficcanaso",
"Notte Elfi abbracciano troppi alberi",
"Gli orchi sono guerrafondai barbari",
"Pandarens continuano a dirmi di rallentare",-- + +
"Tauren dovrebbe essere il mio hamburger",
"Troll dovrebbe stare sui forum web",
"Non-morti sono abominazioni innaturale",
"Worgen hanno troppe pulci",
                                };
                },
[11] = {
["title"] = "Classe";
["content"] = {
"Odio la classe del giocatore",
"I cavalieri della morte sono sopraffatto",
"I Druidi sono animali sporchi",
"Cacciatori sono easy mode",
"Maghi sono illusi intelletti",
"Monaci chi è debole",-- + +
"Paladini sono sciocchi bigotti",
"I sacerdoti sono pii predicatori",
"Ladri non hanno nessun onore",
"Sciamani parlare agli animali immaginari",
"Stregoni sono sadici necromantiche",
"Guerrieri hanno problemi di rabbia",
                                };
                },
[12] = {
["title"] = "Nome";
["content"] = {
"Ha un nome ridicolo",
"Nome pretenzioso",
"Variante di Legolas",
"Nome ha caratteri strani",
"Nome della Gilda è ridicolo",
"Nome Gilda utilizza solo lettere maiuscole",
"Nome Gilda usa lettere maiuscole e spazi",
"Nome Gilda afferma che odio la mia fazione",
                                };
                },]]--
-- [13] = {
[6] = {
["title"] = "Altro";
["content"] = {
--"Karma",
--"Rosso è morto",
--"Solo perché",
--"Ha esito negativo in PvP",
"Contrassegnati per PvP",
--"Non vuole PvP",
--"Perde sia il nostro tempo",
--"Questo giocatore è un noob",
--"Io odio davvero questo giocatore",
--"Non abbastanza veloce livello",
"Mi ha spinto giù da una rupe",
"Utilizza trucchi engineering",
"Riesce sempre a fuggire",
"Utilizza oggetti e abilità di fuga",
"Exploit meccanica di gioco",
--"Sospetto hacker",
--"Agricoltore",
--"Altro...",
"Inserisci il tuo motivo...",
		};
	},
}

StaticPopupDialogs ["Spy_SetKOSReasonOther"] = {
	preferredIndex = STATICPOPUPS_NUMDIALOGS,--http://forums.wowace.com/showthread.php?p=320956
	text = "Inserire il Kill sul motivo della vista per % s:",
	button1 = "Imposta",
	button2 = "Annulla",
	timeout = 20,
	hasEditBox = 1,
	whileDead = 1,
	hideOnEscape = 1,
	OnShow = function(self)
		self.editBox:SetText("");
	end,
		OnAccept = function(self)
		local reason = self.editBox:GetText()
		Spy:SetKOSReason(self.playerName, "Other...", reason)
		Spy:SetKOSReason(self.playerName, "Inserisci il tuo motivo...", reason)
	end,
};
 
Spy_AbilityList = {
 
-----------------------------------------------------------
--Permette una stima del livello di razza, classe e un
--giocatore di essere determinato da quali abilità sono osservati
--nel registro di combattimento.
-----------------------------------------------------------
 
};
