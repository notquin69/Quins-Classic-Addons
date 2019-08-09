local L = LibStub("AceLocale-3.0"):NewLocale("Spy", "ptES")
if not L then return end


-Información Addon
L ["Spy"] = "Spy"
L ["versión"] = "Versión"
L ["LoadDescription"] = "|cff9933ffSpy addon cargado. Tipo |cffffffff/spy|cff9933ff para las opciones".
L ["SpyEnabled"] = "|cff9933ffSpy addon habilitado."
L ["SpyDisabled"] = "|cff9933ffSpy addon deshabilitado. Tipo show|cff9933ff |cffffffff/Spy a permitir".
L ["UpgradeAvailable"] = "|cff9933ffA nueva versión de Spy está disponible. Puede descargarse desde: \n| cffffffffhttps://mods.curse.com/addons/wow/spy"

--Cuerdas configuración
L ["perfiles"] = "Perfiles"

L ["GeneralSettings"] = "Configuración General"
L ["SpyDescription1"] = [[[]
Spy es un addon que le avisará de la presencia de los jugadores enemigos cercanos.
]]
L ["SpyDescription2"] = [[[]

|cffffd000Nearby list|cffffffff
La lista cercana muestra cualquier jugador enemigo que ha sido detectados cerca. Haga clic en la lista permite concentrarse en el jugador, sin embargo esto sólo funciona fuera de combate. Los jugadores se eliminan de la lista si no han sido detectadas después de un período de tiempo.
 
El botón Borrar en la barra de título puede utilizarse para borrar la lista, y sosteniendo el Control mientras limpiaba la lista le permite rápidamente habilitar/deshabilitar la Spy.
 
|cffffd000Last hora list|cffffffff
La lista de última hora muestra todos los enemigos que han sido detectados en la última hora.
 
|cffffd000Ignore list|cffffffff
Los jugadores que se agregan a la lista de ignorar no serán denunciados por Spy. Puede agregar y quitar jugadores de esta lista utilizando el menú desplegable del botón o manteniendo pulsada la tecla Control mientras hace clic en el botón.
 
|cffffd000Kill on Sight list|cffffffff
Los jugadores en su lista de matar On Sight causan una alarma que suene cuando detecta. Puede agregar y quitar jugadores de esta lista utilizando el menú desplegable del botón o manteniendo pulsada la tecla Mayús mientras hace clic en el botón.
 
El menú desplegable también puede utilizarse para establecer las razones de por qué alguien ha agregado a la lista de matar en vista. Si desea ingresar una razón específica que no está en la lista, utilice "Escriba su propia razón..." en la Otra lista.
 
 
|cffffd000Author: http://www.curse.com/users/slipjack |cffffffff
 
]]
L ["EnableSpy"] = "Habilitar Spy"
L ["EnableSpyDescription"] = "habilita o deshabilita veo tanto ahora como en Inicio de sesión".
L ["EnabledInBattlegrounds"] = "Habilitar Spy en los campos de batalla"
L ["EnabledInBattlegroundsDescription"] = "Habilita o deshabilita Spy cuando estás en un campo de batalla".
L ["EnabledInArenas"] = "Habilitar Spy en arenas"
L ["EnabledInArenasDescription"] = "Habilita o deshabilita Spy cuando estás en un escenario".
L ["EnabledInWintergrasp"] = "Habilitar Spy en zonas de combate del mundo"
L ["EnabledInWintergraspDescription"] = "Habilita o deshabilita Spy cuando estás en zonas de combate mundial como Lago conquista del invierno en Rasganorte".
L ["DisableWhenPVPUnflagged"] = "Deshabilitar Spy cuando no marcados para PVP"
L ["DisableWhenPVPUnflaggedDescription"] = "Habilita o deshabilita Spy dependiendo de su estatus PVP".
 
L ["DisplayOptions"] = "Display"
L ["DisplayOptionsDescription"] = [[[]
Spy puede ser mostrado u oculta automáticamente.
]]
L ["ShowOnDetection"] = "Programa Spy cuando se detectan los jugadores enemigos"
L ["ShowOnDetectionDescription"] = "Poner esto para mostrar la ventana Spy y la lista cercana si está oculto Spy cuando se detectan los jugadores enemigos."
L ["HideSpy"] = "Hide Spy cuando no se detectan jugadores enemigos"
L ["HideSpyDescription"] = "Set para ocultar Spy cuando se muestre la lista cercana y se convierte en vacío. Spy no se ocultará si desactiva manualmente la lista."
L ["LockSpy"] = "Cierre la ventana Spy"
L ["LockSpyDescription"] = "Bloquea la ventana Spy en su lugar para que no se mueve".
L ["InvertSpy"] = "Invertir la ventana Spy"
L ["InvertSpyDescription"] = "Cambia la ventana Spy hacia abajo".
L ["ResizeSpy"] = "Redimensionar automáticamente la ventana de Spy"
L ["ResizeSpyDescription"] = "Set para redimensionar automáticamente la ventana Spy como añadir o eliminar los jugadores enemigos."
L ["TooltipDisplayWinLoss"] = "Mostrar las estadísticas de ganancias y pérdidas en la descripción"
L ["TooltipDisplayWinLossDescription"] = "Set esto para mostrar las estadísticas de ganancias y pérdidas de un jugador en la descripción del jugador".
L ["TooltipDisplayKOSReason"] = "Razones pantalla matar a la vista en la descripción"
L ["TooltipDisplayKOSReasonDescription"] = "Set para mostrar la matanza en razones de vista de un jugador en la descripción del jugador".
L ["TooltipDisplayLastSeen"] = "Datos de pantalla por última vez en la descripción"
L ["TooltipDisplayLastSeenDescription"] = "Set esto para mostrar el último tiempo conocido y la ubicación de un jugador en la descripción del jugador".
 
L ["AlertOptions"] = "Alertas"
L ["AlertOptionsDescription"] = [[[]
Usted puede anunciar los detalles de un encuentro con una charla del canal y controlan cómo Spy le avisa cuando se detectan los jugadores enemigos.
]]
L ["anunciar"] = "anunciar que:"
L ["None"] = "None"
L ["NoneDescription"] = "No anuncian cuando se detectan los jugadores enemigos."
L ["Self"] = "Self"
L ["SelfDescription"] = "Anuncian a sí mismo cuando se detectan los jugadores enemigos."
L ["Party"] = "Party"
L ["PartyDescription"] = "Anunciar a su partido cuando se detectan los jugadores enemigos."
L ["gremio"] = "Gremio"
L ["GuildDescription"] = "Anuncian que su gremio cuando se detectan los jugadores enemigos."
L ["Raid"] = "Raid"
L ["RaidDescription"] = "Anuncian su RAID cuando se detectan los jugadores enemigos."
L ["LocalDefense"] = "Defensa Local"
L ["LocalDefenseDescription"] = "Anunciar al canal Local de defensa cuando se detectan los jugadores enemigos."
L ["OnlyAnnounceKoS"] = "Sólo anunciar los jugadores enemigos que matar a la vista"
L ["OnlyAnnounceKoSDescription"] = "Puesto que sólo anuncian jugadores enemigos que se encuentran en su muerte en lista vista."
L ["WarnOnStealth"] = "Advertir sobre detección de sigilo"
L ["WarnOnStealthDescription"] = "Set para mostrar una advertencia y sonar una alerta cuando un jugador enemigo gana sigilo".
L ["WarnOnKOS"] = "Advertir al matar en la detección de vista"
L ["WarnOnKOSDescription"] = "Set para mostrar una advertencia y sonar una alerta cuando se detecta un enemigo sobre su muerte en lista vista."
L ["WarnOnKOSGuild"] = "Advertir al matar en la detección de gremio vista"
L ["WarnOnKOSGuildDescription"] = "Set para mostrar una advertencia y sonar una alerta cuando se detecta un enemigo en el mismo gremio como alguien de su muerte en lista vista."
L ["DisplayWarningsInErrorsFrame"] = "Mostrar las advertencias en el marco de errores"
L ["DisplayWarningsInErrorsFrameDescription"] = "Set esto utilizar el marco errores para mostrar avisos en lugar de utilizar los marcos de gráficos emergente".
L ["EnableSound"] = "Habilitar las alertas de audio"
L ["EnableSoundDescription"] = "Set para habilitar las alertas de audio cuando se detectan los jugadores enemigos. Diferentes alertas de sonido si un enemigo gana sigilo o si un enemigo está en tu lista de matar en vista."
 
L ["ListOptions"] = "Cerca de lista"
L ["ListOptionsDescription"] = [[[]
Puede configurar cómo Spy agrega y elimina los jugadores enemigos de la lista de cercana.
]]
L ["RemoveUndetected"] = "quitar jugadores enemigos de la lista cercana después:"
L ["1 minuto"] = "1 minuto"
L ["1MinDescription"] = "Eliminar un enemigo que ha sido detectado por durante 1 minuto."
L ["2 minutos"] = "2 minutos"
L ["2MinDescription"] = "Elimina a un enemigo que ha sido detectado por más de 2 minutos".
L ["5min"] = "5 minutos"
L ["5MinDescription"] = "Elimina a un enemigo que ha sido detectado por más de 5 minutos."
L ["10 minutos"] = "diez minutos"
L ["10MinDescription"] = "Elimina a un enemigo que ha sido detectado por más de 10 minutos".
L ["15 minutos"] = "15 minutos"
L ["15MinDescription"] = "Elimina a un enemigo que ha sido detectado por más de 15 minutos".
L ["nunca"] = "Nunca quitar"
L ["NeverDescription"] = "Nunca retire los jugadores enemigos. La lista cercana puede todavía ser eliminada manualmente."
L ["ShowNearbyList"] = "Cambiar a la lista cercana tras la detección de enemigo"
L ["ShowNearbyListDescription"] = "Set para visualizar la lista cercana si no está visible cuando se detectan los jugadores enemigos."
L ["PrioritiseKoS"] = "Kill decidirá sobre los jugadores enemigos vista en la lista cercana"
L ["PrioritiseKoSDescription"] = "Puesto que siempre Mostrar matar jugadores enemigos vista primero en la lista cercana."
 
L ["MinimapOptions"] = "Mapa"
L ["MinimapOptionsDescription"] = [[[]
Para los jugadores que pueden rastrear a humanoides el minimapa puede utilizarse para proporcionar características adicionales.
 
Los jugadores que pueden rastrear a humanoides son cazadores, los druidas y aquellos que han recibido la capacidad a través de otros medios tales como comer un filete de huargo ennegrecido.
]]
L ["MinimapTracking"] = "Activar el seguimiento de minimapa"
L ["MinimapTrackingDescription"] = "Set este control para activar el minimapa de seguimiento y detección. Los jugadores enemigos conocidos detectados en el minimapa se añadirá a la lista cercana."
L ["MinimapDetails"] = "Mostrar datos de nivel o clase en tooltips"
L ["MinimapDetailsDescription"] = "Set para actualizar la información sobre herramientas del mapa para que se muestran detalles de nivel/clase junto a nombres de enemigos".
L ["DisplayOnMap"] = "Mostrar enemigo ubicación en mapa"
L ["DisplayOnMapDescription"] = "poner esto para mostrar en el mapa del mundo y minimapa la localización de enemigos detectados por otros usuarios de Spy en su partido, raid y Gremio".
L["SwitchToZone"] = "Switch to current zone map on enemy detection"
L["SwitchToZoneDescription"] = "If the World Map is open this will change the map to the players current zone map when enemies are detected."
L ["MapDisplayLimit"] = "límite muestra iconos del mapa para:"
L ["LimitNone"] = "En todas partes"
L ["LimitNoneDescription"] = "Muestra todos detectada enemigos en el mapa independientemente de su ubicación actual".
L ["LimitSameZone"] = "Misma zona"
L ["LimitSameZoneDescription"] = "muestra sólo detecta enemigos en el mapa si estás en la misma zona".
L ["LimitSameContinent"] = "Mismo continente"
L ["LimitSameContinentDescription"] = "muestra sólo detecta enemigos en el mapa si usted está en el mismo continente."
 
L ["DataOptions"] = "Gestión de datos"
L ["DataOptionsDescription"] = [[[]
Puede configurar cómo Spy mantiene y recoge sus datos.
]]
L ["PurgeData"] = "purga sin ser detectado datos del jugador enemigo después:"
L ["un día"] = "día 1"
L ["OneDayDescription"] = "Purgar los datos para los jugadores enemigos que han sido detectados por un día".
L ["FiveDays"] = "5 días"
L ["FiveDaysDescription"] = "Purgar los datos para los jugadores enemigos que han sido detectados durante 5 días".
L ["TenDays"] = "10 días"
L ["TenDaysDescription"] = "Purgar los datos para los jugadores enemigos que han sido detectados durante 10 días".
L ["ThirtyDays"] = "30 días"
L ["ThirtyDaysDescription"] = "Purgar los datos para los jugadores enemigos que han sido detectados por 30 días".
L ["SixtyDays"] = "60 días"
L ["SixtyDaysDescription"] = "Purgar los datos para los jugadores enemigos que han sido detectados por 60 días".
L ["NinetyDays"] = "90 días"
L ["NinetyDaysDescription"] = "Purgar los datos para los jugadores enemigos que han sido detectados durante 90 días".
L ["ShareData"] = "Compartir datos con otros usuarios de addon Spy"
L ["ShareDataDescription"] = "Set para compartir los detalles de tus enemigo encuentros con otros usuarios de Spy en su partido, raid y gremio".
L ["UseData"] = "Usar datos de otros usuarios de addon Spy"
L ["UseDataDescription"] = [[Set para usar los datos recogidos por otros usuarios de Spy en su partido, raid y Gremio.
 
Si otro usuario Spy detecta un enemigo entonces ese jugador enemigo se añadirán a la lista de cerca si hay espacio.
]]
L ["ShareKOSBetweenCharacters"] = "Share Kill en reproductores de vista entre los personajes"
L ["ShareKOSBetweenCharactersDescription"] = "Set para compartir los jugadores marque como matar a la vista entre otros personajes que juega en el mismo servidor y facción".
 
L ["SlashCommand"] = "Barra de comandos"
L ["SpySlashDescription"] = "estos botones ejecutan las mismas funciones que los de la barra comando /spy"
L ["Enable"] = "Enable"
L ["EnableDescription"] = "Permite Spy y muestra la ventana principal."
L ["Reset"] = "Reset"
L ["ResetDescription"] = "Restablece la posición y el aspecto de la ventana principal."
L ["Config"] = "Config"
L ["ConfigDescription"] = "Abrir la ventana de configuración de interfaz Addons para Spy."
L ["KOS"] = "KOS"
L ["KOSDescription"] = "Agregar o quitar un jugador desde la matanza en lista vista."
L ["Ignore"] = "Ignore"
L ["IgnoreDescription"] = "Agregar o quitar un jugador de la lista de ignorar."
 
--Listas
L ["Nearby"] "Cerca"
L ["LastHour"] = "Última hora"
L ["Ignore"] = "Ignorar"
L ["KillOnSight"] = "Matar a la vista"
 
--Stats
--L["Last"] = "Last"
L["Time"] = "Time"	
L["List"] = "List"	
L["Show Only"] = "Show Only"
L["Won/Lost"] = "Won/Lost"
L["Reason"] = "Reason"	 
L["HonorKills"] = "Honor Kills"
L["PvPDeatchs"] = "PvP Deaths"

--++ Descripciones de clase
--L ["DEATHKNIGHT"] = "caballero de la muerte"
L ["DRUID"] = "Druida"
L ["HUNTER"] = "Cazador"
L ["MAGE"] = "Mago"
--L ["MONK"] = "Monk"
L ["PALADIN"] = "Paladín"
L ["PRIEST"] = "Sacerdote"
L ["ROGUE"] = "Pícaro"
L ["SHAMAN"] = "Shaman"
L ["WARLOCK"] = "Brujo"
L ["WARRIOR"] = "Guerrero"
L ["UNKNOWN"] = "Desconocido"
 
: Habilidades sigilosa
L ["Stealth"] = "Stealth"
L ["Acechar"] = "Acechar"
 
--Nombres de canales
L ["LocalDefenseChannelName"] = "LocalDefense"
 
--++ Los códigos de color minimapa
--L ["MinimapClassTextDEATHKNIGHT"] = "|cffc41e3a"
--L ["MinimapClassTextDRUID"] = "|cffff7c0a"
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
 
--Los mensajes de salida
L ["AlertStealthTitle"] = "Jugador en sigilo detectado!"
L ["AlertKOSTitle"] = "Matar el jugador vista detectado!"
L ["AlertKOSGuildTitle"] = "Mata en gremio de jugador vista detectado!"
L ["AlertTitle_kosaway"] = "mata On Sight jugador situado por"
L ["AlertTitle_kosguildaway"] = "gremio jugador matar On Sight ubicado por"
L ["StealthWarning"] = "|cff9933ffStealthed jugador detectado: |cffffffff"
L ["KOSWarning"] = "|cffff0000Kill reproductor de vista detectados: |cffffffff"
L ["KOSGuildWarning"] = "|cffff0000Kill en gremio de jugador vista detectado: |cffffffff"
L ["SpySignatureColored"] = "|cff9933ff [Spy]"
L ["PlayerDetectedColored"] = "jugador detectado: |cffffffff"
L ["PlayersDetectedColored"] = "jugadores detectados: |cffffffff"
L ["KillOnSightDetectedColored"] = "matar el jugador vista detectada: |cffffffff"
L ["PlayerAddedToIgnoreColored"] = "jugador añadido a la lista de ignorar: |cffffffff"
L ["PlayerRemovedFromIgnoreColored"] = "jugador eliminado de la lista de ignorar: |cffffffff"
L ["PlayerAddedToKOSColored"] = "jugador añadido a matar en lista vista: |cffffffff"
L ["PlayerRemovedFromKOSColored"] = "jugador eliminado de matar en lista vista: |cffffffff"
L ["PlayerDetected"] = "[Spy] reproductor detectada:"
L ["KillOnSightDetected"] = "jugador matar [Spy] On Sight detectada:"
L ["nivel"] = "Llano"
L ["LastSeen"] = "Visto por última vez"
L ["LessThanOneMinuteAgo"] = "hace menos de un minuto"
L ["MinutesAgo"] = "minutos"
L ["creiamos"] = "horas"
L ["hace días"] = "hace días"
L ["cerrar"] = "Cerrar"
L ["CloseDescription"] = "|cffffffffHides la ventana Spy. Por defecto mostrará otra vez cuando se detecta el siguiente jugador enemigo."
L ["Left/Right"] = "Left/Right"
L ["izquierda/RightDescription"] = "|cffffffffNavigates entre cercana, última hora, ignorar y matar en las listas de la vista."
L ["Clear"] = "Clear"
L ["cleardescripción"] = "|cffffffffClears la lista de jugadores que han sido detectados. CTRL clic será habilitar/deshabilitar la Spy mientras muestra".
L ["NearbyCount"] = "Cercanas"Conteo"
L ["NearbyCountDescription"] = "|cffffffffSends la cuenta de los jugadores cercanos a charlar".
L ["AddToIgnoreList"] = "Añadir a la lista de ignorar"
L ["AddToKOSList"] = "Add to Kill en lista vista"
L ["RemoveFromIgnoreList"] = "Eliminar de la lista de ignorar"
L ["RemoveFromKOSList"] = "Retire de matar en lista vista"
L ["AnnounceDropDownMenu"] = "Anunciar"
L ["KOSReasonDropDownMenu"] = "Set Kill en razón de la vista"
L ["PartyDropDownMenu"] = "Party"
L ["RaidDropDownMenu"] = "Raid"
L ["GuildDropDownMenu"] = "Gremio"
L ["LocalDefenseDropDownMenu"] = "Defensa Local"
L ["Player"] = "(jugador)"
L ["KOSReason"] = "Matar a la vista"
L ["KOSReasonIndent"] = ""
L ["KOSReasonOther"] = "Escriba su propia razón..."
L ["KOSReasonClear"] = "Clear"
L ["StatsWins"] = "|cff40ff00Wins:"
L ["StatsSeparator"] = ""
L ["StatsLoses"] = "|cff0070ddLoses:"
L ["ubicado"] = "situado:"
L ["yardas"] = "m"
 
--Spy_KOSReasonListLength = 13
Spy_KOSReasonListLength = 6
Spy_KOSReasonList = {
[1] = {
["title"] = "Empezar combate";
["contenido"] = {
--"Me detuvo,"
--"Siempre me ataca a la vista",
"Me atacó sin motivo",
"Me atacó en un PNJ,"--++
"Me atacaron mientras luchaba NPCs",
"Me atacaron mientras estaba entrar/salir una instancia",
"Me atacaron mientras estaba AFK",
--"Me atacaron mientras yo estaba en una batalla para mascotas",--++
"Me atacaron mientras estaba montado/volando",
"Me atacaron mientras tenía poca salud/maná",
--"Aplanó con un grupo de enemigos",
--"No ataca sin respaldo",
--"Se atrevió a desafiarme",
                                };
                },
[2] = {
["title"] = "Estilo de combate";
["contenido"] = {
"Me detuvo"
"Siempre me ataca a la vista",
"Me mató con un personaje de nivel superior",--++
"Aplanó con un grupo de enemigos",
"No ataca sin respaldo",
"Siempre pide ayuda",
--"Me empujó a un precipicio",
--"Utiliza trucos de ingeniería",
"Usos demasiado control de multitudes",
--"Spams una habilidad todo el tiempo",
--"Me forzó a tomar daño durabilidad",
--"Me mató y escapó de mis amigos",
--"Ran lejos entonces me detuvo",
--"Siempre se las arregla para escapar",
--"Hogares de burbuja para escapar",
--"Logra permanecer en el rango de cuerpo a cuerpo",
--"Logra alojarte en Kite gama",
--"Absorbe mucho daño",
--"Demasiado sana",
--"DPS es demasiado",
                                };
                },
-- [3] = {
--["title"] = "Conducta General";
--["contenido"] = {
--"Molesto",
--"Grosería",
--"Cobardía",
--"Arrogancia",
--"Exceso de confianza",
--"No confiables",
--"Emociones demasiado",
--"Me acosó / amigos",
--"Pretende ser buena",
--"Emotes 'no va a pasar'",
--"Adiós las ondas con poca vida",
--"Trató de mantenerme con una ola",
--"Realizados actos malos sobre mi cadáver",
--"Se rieron de mí",
--"Escupieron",
--                             };
--             },
[3] = {
["title"] = "Camping";
["contenido"] = {
"Me acampados",
"Acampado una alternativa",
"Acampaban lowbies",
"Acampado de sigilo",
"Los miembros del gremio acampados",
"Acampado juegos NPCs y objetivos",
"Acampado un ciudad/del sitio",
--"Llamado en ayuda al campamento me",
--"Hecho una pesadilla de nivelación",
--"Me obligó a salir",
--"No luchar contra mi principal",
                                };
                },
[4] = {
["title"] = "Questing";
["contenido"] = {
"Me atacaron mientras yo estaba buscada",
"Me atacó después ayudé con una misión",
"Interfirió con los objetivos de la misión",
"Comenzó una búsqueda que quería hacer",
"Muertos CPN de mi facción",
"Muertos una búsqueda NPC",
                                };
                },
[5] = {
["title"] = "Robar recursos";
["contenido"] = {
"Las hierbas recogidas quería",
"Minerales reunidos quería",
"Los recursos reunidos quería",
--"Gas extraído de una nube que quería",
"Me mató y robó mi destino/rara NPC"
"Mi mata de piel",
"Salvar mi mata",
"Pescaban en mi piscina",
                                };
                },
--[[ [7] = {
["title"] = "Campos de batalla";
["contenido"] = {
"Siempre los cadáveres saquea",
"Corredor de la bandera muy buena",
"Backcaps banderas o bases",
"Stealth tapas banderas o bases",
"Me mató y tomó la bandera",
"Interfiere con los objetivos del campo de batalla",
"Tomó un power-up que quería",
"Tanque forzado a perder agro",
"Causó un trapo",
"Destruye el asedio",
"Gotas de bombas",
"Desarma bombas",
"Bombardero del miedo",
                                };
                },
[8] = {
["title"] = "Vida Real";
["contenido"] = {
"Amigo en la vida real",
"El enemigo en la vida real",
"Se propaga rumores sobre mí",
"Se queja en los foros",
"Spy para la otra facción",
"Traidor a mi facción",
"Incumplido un acuerdo",
"Nub pretencioso",
"Otro sabelotodo",
"Otro Fortachón llegaste tarde",
"Cruz facción hablador de basura",
                                };
                },
[9] = {
["title"] = "Dificultad";
["contenido"] = {
"Imposible de matar",
"Gana la mayor parte del tiempo",
"Parece un partido justo",
"Pierde la mayor parte del tiempo",
"Divertido matar",
"Fácil de honor",
                                };
                },
[10] = {
["title"] = "Raza";
["contenido"] = {
"Odio la carrera del jugador",
"Elfos de sangre son narcisistas",
"Los Draenei son calamares fangoso espacio",
"Los enanos son doorstops peludos cortos",
"Los duendes vendería a sus madres para obtener ganancias",
"Los gnomos son en un jardín",
"Los seres humanos son entrometidos justos",
"Elfos de la noche abrazan demasiados árboles",
"Los orcos son bárbaros belicista",
"Pandarens sigue diciéndome que más despacio",--++
"Tauren debería ser mi hamburguesa",
"Los trolls deberían quedarse en los foros del web",
"Undead son abominaciones antinaturales",
"Huargen tiene demasiadas pulgas",
                                };
                },
[11] = {
["title"] = "Class";
["contenido"] = {
"Odio de clase del jugador",
"Caballeros de la muerte se superó",
"Los druidas son animales sucios",
"Los cazadores son modo fácil",
"Magos son ilusos intelectos",
"Los monjes chi es débil",--++
"Los paladines son tontos moralista",
"Los sacerdotes son predicadores piadosos",
"Los pícaros no tienen honor",
"Los chamanes hablan con los animales imaginarios",
"Los brujos son nigrománticos sádicos",
"Guerreros tienen problemas de ira",
                                };
                },
[12] = {
["title"] = "Nombre";
["contenido"] = {
"Tiene un nombre ridículo",
"Nombre pretencioso",
"Variante de Legolas",
"El nombre tiene caracteres extraños",
"Nombre del gremio es ridícula",
"El nombre del gremio usa sólo letras mayúsculas",
"Nombre del gremio utiliza mayúsculas y espacios",
"Nombre del gremio afirma que odian a mi facción",
                                };
                },]]--
-- [13] = {
[6] = {
["title"] = "Otro";
["contenido"] = {
--"Karma",
--"Rojo está muerto",
--"Porque",
--"Falla en PvP",
"Marcado para PvP",
--"No quiere PvP",
--"Los desechos tanto nuestro tiempo",
--"Este jugador es un noob",
--"¡ Odio este jugador",
--"No nivel lo suficientemente rápido",
"Me empujó a un precipicio",
"Utiliza trucos de ingeniería",
"Siempre se las arregla escapar",
"Utiliza elementos y habilidades para escapar",
"Hazañas mecánica de juego",
--"Presunto hacker",
--"Agricultor",
--"Otros..."
"Escriba su propia razón...",
                                };
                },
}
 
StaticPopupDialogs ["Spy_SetKOSReasonOther"] = {
	preferredIndex = STATICPOPUPS_NUMDIALOGS,--http://forums.wowace.com/showthread.php?p=320956
	text = "Enter the Kill en razón de la vista de % s:",
	button1 = "Set",
	button2 = "Cancelar",
	timeout = 20,
	hasEditBox = 1,
	whileDead = 1,
	hideOnEscape = 1,
	OnShow = function(self)
		self.editBox:SetText("");
	end,
		OnAccept = function(self)
		local reason = self.editBox:GetText()
--		Spy:SetKOSReason(self.playerName, "Other...", reason)
		Spy:SetKOSReason(self.playerName, "Escriba su propia razón...", reason)
	end,
};
 
Spy_AbilityList = {
 
-----------------------------------------------------------
--Permite una estimación de la raza, la clase y el nivel de un
--jugador ser determinado de qué habilidades se observan
--en el registro de combate.
-----------------------------------------------------------
 
};
