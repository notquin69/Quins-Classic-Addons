-- Translate RCLootCouncil to your language at:
-- http://wow.curseforge.com/addons/rclootcouncil/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("RCLootCouncil", "frFR")
if not L then return end

L[" is not active in this raid."] = "n'est pas activé pour ce raid."
L[" you are now the Master Looter and RCLootCouncil is now handling looting."] = "vous êtes le maître du butin et RCLootCouncil gère à présent le butin."
L["&p was awarded with &i for &r!"] = "&p a reçu &i pour &r !"
L["A format to copy/paste to another player."] = "Format à copier/coller à un autre joueur."
L["A new session has begun, type '/rc open' to open the voting frame."] = "Une nouvelle session a débuté, tapez '/rc open' pour ouvrir la fenêtre de vote."
L["A tab delimited output for Excel. Might work with other spreadsheets."] = "Format pour Excel, délimité par des onglets. Peut également fonctionner avec d'autres tableurs."
L["Abort"] = "Annuler"
L["Accept Whispers"] = "Autoriser les chuchotements"
L["accept_whispers_desc"] = "Permet aux joueurs de vous chuchoter leur(s) objet(s) équipé(s) pour qu'il(s) soit(-ent) ajouté à la fenêtre de vote."
L["Active"] = "Activé"
L["active_desc"] = "Décocher pour désactiver RCLootCouncil. Cette option est utile si vous faites partie d'un groupe de raid, mais que vous n'y participez pas. Remarque : cette option est réinitialisée après chaque déconnexion."
L["Add Item"] = "Ajouter un objet"
L["Add Note"] = "Ajouter une note"
L["Add ranks"] = "Ajouter des rangs"
L["Add rolls"] = "Ajouter un lancer de dés"
--[[Translation missing --]]
L["Add Rolls"] = "Add Rolls"
L["add_ranks_desc"] = "Définir le rang minimum pour pouvoir participer au conseil du butin :"
L["add_ranks_desc2"] = [=[Sélectionnez un rang ci-dessus pour ajouter au conseil tous les membres de ce rang et au-dessus.
Cliquez sur les rangs à gauche pour ajouter des joueurs précis au conseil.
Cliquez sur l'onglet 'Conseil actuel' pour afficher votre sélection.]=]
--[[Translation missing --]]
L["add_rolls_desc"] = "Automatically add random 1 - 100 rolls to all sessions."
--[[Translation missing --]]
L["Additional Buttons"] = "Additional Buttons"
L["All items"] = "Tous les objets"
--[[Translation missing --]]
L["All items have been awarded and the loot session concluded"] = "All items have been awarded and the loot session concluded"
--[[Translation missing --]]
L["All items usable by the candidate"] = "All items usable by the candidate"
--[[Translation missing --]]
L["All unawarded items"] = "All unawarded items"
L["Alt click Looting"] = "Butin en Alt-clic"
L["alt_click_looting_desc"] = "Active le butin en Alt-clic, c.-à-d. qu'une session sera lancée en laissant appuyer le bouton Alt et en cliquant (clic gauche) avec la souris sur un objet."
L["Alternatively, flag the loot as award later."] = "Sinon, désigner le butin comme devant être attribué plus tard."
--[[Translation missing --]]
L["Always use RCLootCouncil with Personal Loot"] = "Always use RCLootCouncil with Personal Loot"
--[[Translation missing --]]
L["always_show_tooltip_howto"] = "Double click to toggle tooltip"
L["Announce Awards"] = "Annoncer les attributions"
L["Announce Considerations"] = "Annoncer les objets en examen"
--[[Translation missing --]]
L["announce_&i_desc"] = "|cfffcd400 &i|r: item link."
--[[Translation missing --]]
L["announce_&l_desc"] = "|cfffcd400 &l|r: item level."
--[[Translation missing --]]
L["announce_&m_desc"] = "|cfffcd400 &m|r: candidates note."
--[[Translation missing --]]
L["announce_&n_desc"] = "|cfffcd400 &n|r: roll, if supplied."
--[[Translation missing --]]
L["announce_&o_desc"] = "|cfffcd400 &o|r: item owner, if applicable."
--[[Translation missing --]]
L["announce_&p_desc"] = "|cfffcd400 &p|r: name of the player getting the loot."
--[[Translation missing --]]
L["announce_&r_desc"] = "|cfffcd400 &r|r: reason."
--[[Translation missing --]]
L["announce_&s_desc"] = "|cfffcd400 &s|r: session id."
--[[Translation missing --]]
L["announce_&t_desc"] = "|cfffcd400 &t|r: item type."
L["announce_awards_desc"] = "Active l'annonce des attributions dans la fenêtre de discussion."
L["announce_awards_desc2"] = [=[Choisissez dans quel(s) canal(-aux) vous voulez que les annonces soient faites et quel message y soit annoncé.
Utilisez &p en lieu du nom du joueur à qui l'objet est attribué, &i pour l'objet attribué et &r pour le motif.]=]
L["announce_considerations_desc"] = "Active, à chaque début de session, l'annonce des objets en train d'être examinés."
L["announce_considerations_desc2"] = [=[Définissez le canal dans lequel vous voulez que les annonces soient faites et quel message y soit annoncé.
Votre message servira d'en-tête à la liste d'objets.]=]
--[[Translation missing --]]
L["announce_item_string_desc"] = [=[
Enter the text to announce for each item. The following keyword substitutions are available:
]=]
L["Announcements"] = "Annonces"
L["Anonymous Voting"] = "Vote anonyme"
L["anonymous_voting_desc"] = "Activer le vote anonyme, c.-à-d. que les joueurs ne verront pas qui a voté pour qui."
L["Append realm names"] = "Ajouter le nom du royaume"
L["Are you sure you want to abort?"] = "Êtes-vous certain de vouloir quitter ?"
L["Are you sure you want to give #item to #player?"] = "Êtes-vous certain de vouloir attribuer %s à %s ?"
--[[Translation missing --]]
L["Are you sure you want to reannounce all unawarded items to %s?"] = "Are you sure you want to reannounce all unawarded items to %s?"
--[[Translation missing --]]
L["Are you sure you want to request rolls for all unawarded items from %s?"] = "Are you sure you want to request rolls for all unawarded items from %s?"
L["Armor Token"] = "Jeton d'armure"
--[[Translation missing --]]
L["Ask me every time Personal Loot is enabled"] = "Ask me every time Personal Loot is enabled"
L["Auto Award"] = "Attribution automatique"
L["Auto Award to"] = "Attribuer automatiquement à"
L["Auto awarded 'item'"] = "%s a été attribué automatiquement"
L["Auto Close"] = "Fermeture Auto"
L["Auto Enable"] = "Activation automatique"
--[[Translation missing --]]
L["Auto extracted from whisper"] = "Auto extracted from whisper"
L["Auto Open"] = "Ouverture automatique"
L["Auto Pass"] = "Passer automatiquement"
L["Auto pass BoE"] = "Passer automatiquement sur les objets LqE"
--[[Translation missing --]]
L["Auto Pass Trinkets"] = "Auto Pass Trinkets"
L["Auto Start"] = "Lancement automatique"
--[[Translation missing --]]
L["Auto Trade"] = "Auto Trade"
L["auto_award_desc"] = "Active l'attribution automatique."
L["auto_award_to_desc"] = "Joueur à qui les objets seront automatiquement attribués. Une liste de sélection des membres du raid s'affichera si vous êtes dans un groupe de raid. "
L["auto_close_desc"] = "Cocher pour fermer la fenêtre de vote automatiquement lorsque le Maître de Butin termine la session"
L["auto_enable_desc"] = "Cochez cette case pour que le butin soit toujours géré par RCLootCouncil. En laissant cette case vide, l'add-on vous demandera à chaque fois que vous entrez dans un raid ou que vous êtes nommé maître du butin si vous voulez l'utiliser."
L["auto_loot_desc"] = "Active la fouille automatique de tous les objets pouvant être équipés"
L["auto_open_desc"] = "Cochez cette case pour que la fenêtre de vote s'ouvre automatiquement lorsque nécessaire. La fenêtre de vote peut indifféremment être ouverte en tapant /rc open. Remarque : cette option nécessite la permission du maître du butin."
L["auto_pass_boe_desc"] = "Décocher pour ne jamais passer automatiquement sur des objets liés quand équipés."
L["auto_pass_desc"] = "Cocher pour passer automatiquement sur les objets inutilisables par votre classe."
--[[Translation missing --]]
L["auto_pass_trinket_desc"] = "Check to autopass trinkets that's not listed in the Dungeon Journal for your class."
L["auto_start_desc"] = "Active le lancement automatique, c.-à-d. qu'une session sera lancée avec tous les objets éligibles. En désactivant cette option, une liste d'objets modifiable s'affichera avant chaque début de session. "
--[[Translation missing --]]
L["Autoloot all BoE"] = "Autoloot all BoE"
L["Autoloot BoE"] = "Butin automatique des LqE"
L["autoloot_BoE_desc"] = "Active la fouille automatique des objets LqE (liés quand équipés)."
--[[Translation missing --]]
L["autoloot_others_BoE_desc"] = "Enable to automatically add BoE items looted by others into a session."
--[[Translation missing --]]
L["autoloot_others_item_combat"] = "%s has looted %s. This item will be added to the session frame once combat ends."
L["Autopass"] = "Passer automatiquement"
L["Autopassed on 'item'"] = "Vous avez automatiquement passé sur %s"
L["Autostart isn't supported when testing"] = "Le lancement automatique n'est pas pris en charge dans la fonction de test"
L["award"] = "attribuer"
L["Award"] = "Attribuer"
L["Award Announcement"] = "Annonces des attributions"
L["Award for ..."] = "Attribuer à ..."
--[[Translation missing --]]
L["Award later"] = "Award later"
--[[Translation missing --]]
L["Award later isn't supported when testing."] = "Award later isn't supported when testing."
L["Award later?"] = "Attribuer plus tard ?"
L["Award Reasons"] = "Motifs de l'attribution"
L["award_reasons_desc"] = [=[Motifs d'attribution ne pouvant être choisis lors de la sélection d'une réponse.
Utilisés lorsque vous modifiez une réponse en passant par le menu du clic droit ou en cas d'attribution automatique.]=]
--[[Translation missing --]]
L["Awarded"] = "Awarded"
--[[Translation missing --]]
L["Awarded item cannot be awarded later."] = "Awarded item cannot be awarded later."
L["Awards"] = "Attributions"
--[[Translation missing --]]
L["Azerite Armor"] = "Azerite Armor"
L["Background"] = "Fond"
L["Background Color"] = "Couleur de fond"
L["Banking"] = "La banque"
L["BBCode export, tailored for SMF."] = "Exporter en BBCode, adapté pour SMF."
L["Border"] = "Bordure"
L["Border Color"] = "Couleur de bordure"
L["Button"] = "Bouton"
L["Buttons and Responses"] = "Boutons et réponses"
L["buttons_and_responses_desc"] = [=[Configurer les boutons de réponse qui s'afficheront dans la fenêtre de butin des joueurs.
L'ordre des réponses ci-dessous détermine l'ordre dans lequel seront triées les réponses dans la fenêtre de vote, et s'affiche de gauche à droite dans la fenêtre de butin. Utilisez le curseur pour définir le nombre de boutons que vous voulez voire apparaître (max. %d).
Un bouton 'Passer' est automatiquement ajouté tout à droite.]=]
L["Candidate didn't respond on time"] = "Le candidat n'a pas répondu dans le temps imparti."
L["Candidate has disabled RCLootCouncil"] = "Le candidat a désactivé RCLootCouncil"
L["Candidate is not in the instance"] = "Le candidat n'est pas dans l'instance"
L["Candidate is selecting response, please wait"] = "Le candidat est en train de répondre, veuillez patienter."
L["Candidate removed"] = "Candidat retiré"
--[[Translation missing --]]
L["Candidates that can't use the item"] = "Candidates that can't use the item"
L["Cannot autoaward:"] = "Attribution automatique impossible :"
L["Cannot give 'item' to 'player' due to Blizzard limitations. Gave it to you for distribution."] = "Impossible d'attribuer %s à %s en raisons des restrictions fixées par Blizzard. L'objet vous a été attribué pour que vous puissiez le distribuer."
--[[Translation missing --]]
L["Change Award"] = "Change Award"
L["Change Response"] = "Modifier la réponse"
L["Changing loot threshold to enable Auto Awarding"] = "Le seuil de qualité est en train d'être modifié afin que l'attribution automatique puisse être activée"
L["Changing LootMethod to Master Looting"] = "Le système de butin a été changé en Maître du butin"
L["channel_desc"] = "Le canal dans lequel sera envoyé le message."
--[[Translation missing --]]
L["Chat print"] = "Chat print"
L["chat tVersion string"] = "|cFF87CEFARCLootCouncil |cFFFFFFFFversion |cFFFFA500 %s - %s"
L["chat version String"] = "|cFF87CEFARCLootCouncil |cFFFFFFFFversion |cFFFFA500 %s"
--[[Translation missing --]]
L["chat_cmd_add_invalid_owner"] = "The player %s was either invalid or not a candidate."
--[[Translation missing --]]
L["chat_commands_add"] = "Add an item to the session frame"
--[[Translation missing --]]
L["chat_commands_award"] = "Start a session with items looted to your inventory"
--[[Translation missing --]]
L["chat_commands_config"] = "Open the options interface"
--[[Translation missing --]]
L["chat_commands_council"] = "Open the council interface"
--[[Translation missing --]]
L["chat_commands_history"] = "Open the Loot History (alt. 'h' or 'his')"
--[[Translation missing --]]
L["chat_commands_open"] = "Open the voting frame"
--[[Translation missing --]]
L["chat_commands_reset"] = "Resets the addon's frames' positions"
--[[Translation missing --]]
L["chat_commands_sync"] = "Open the synchronizer view"
--[[Translation missing --]]
L["chat_commands_test"] = "Emulate a loot session with # items, 1 if omitted"
--[[Translation missing --]]
L["chat_commands_version"] = "Open the Version Checker (alt. 'v' or 'ver')"
--[[Translation missing --]]
L["chat_commands_whisper"] = "Displays help to whisper commands"
--[[Translation missing --]]
L["chat_commands_winners"] = "Display the winners of awarded items looted to your inventory"
L["Check this to loot the items and distribute them later."] = "Cocher cette case pour récupérer les objets et les attribuer plus tard."
L["Check to append the realmname of a player from another realm"] = "Cocher pour ajouter le nom du royaume d'un joueur provenant d'un autre royaume"
L["Check to have all frames minimize when entering combat"] = "Cocher pour minimiser toutes les fenêtres en entrant en combat. "
L["Choose timeout length in seconds"] = "Fixer le délai de vote (en secondes)"
L["Choose when to use RCLootCouncil"] = "Choisir quand utiliser RCLootCouncil"
L["Clear Loot History"] = "Effacer l'historique du butin"
L["Clear Selection"] = "Effacer la sélection"
L["clear_loot_history_desc"] = "Supprimer la totalité de l'historique du butin."
L["Click to add note to send to the council."] = "Cliquer pour ajouter une note qui sera transmise au conseil."
--[[Translation missing --]]
L["Click to change your note."] = "Click to change your note."
L["Click to expand/collapse more info"] = "Cliquer pour afficher ou masquer des informations supplémentaires"
L["Click to switch to 'item'"] = "Cliquer pour passer à %s"
L["config"] = "configuration"
--[[Translation missing --]]
L["confirm_award_later_text"] = "Are you sure you want to award %s later? The item will be recorded in the addon's award later list and you will loot the item if the item is in a loot slot. You can use '/rc award' to distribute this item later."
L["confirm_usage_text"] = [=[|cFF87CEFA RCLootCouncil |r
Souhaitez-vous utiliser RCLootCouncil avec ce groupe ?]=]
--[[Translation missing --]]
L["Conqueror Token"] = "Conqueror Token"
L["Could not Auto Award i because the Loot Threshold is too high!"] = "Attribution automatique de %s impossible car le seuil de qualité est trop élevé !"
L["Could not find 'player' in the group."] = "Le joueur %s n'a pas été trouvé dans le groupe."
L["Couldn't find any councilmembers in the group"] = "Aucun membre du conseil n'a été trouvé dans le groupe"
L["council"] = "conseil"
L["Council"] = "Conseil"
L["Current Council"] = "Conseil actuel"
L["current_council_desc"] = "Cliquer pour retirer certains joueurs du conseil."
L["Customize appearance"] = "Personnaliser l'apparence"
L["customize_appearance_desc"] = "Dans ce menu, vous pouvez entièrement personnaliser l'apparence de RCLootCouncil. Utilisez la fonction sauvegarder ci-dessus pour changer rapidement d'apparence."
--[[Translation missing --]]
L["Data Received"] = "Data Received"
L["Date"] = true
L["days and x months"] = "%s et %d mois"
L["days, x months, y years"] = "%s, %d mois et %d ans"
L["Delete Skin"] = "Supprimer l'apparence"
L["delete_skin_desc"] = "Supprimer l'apparence sélectionnée dans la liste."
L["Deselect responses to filter them"] = "Désélectionner les réponses avant de pouvoir les filtrer"
L["Diff"] = true
--[[Translation missing --]]
L["Discord friendly output."] = "Discord friendly output."
L["disenchant_desc"] = "Sélectionner cette option pour que ce motif soit choisi lorsque vous attribuez un objet par le biais du bouton 'Désenchanter'"
--[[Translation missing --]]
L["Do you want to keep %s for yourself?"] = "Do you want to keep %s for yourself?"
--[[Translation missing --]]
L["Done syncing"] = "Done syncing"
L["Double click to delete this entry."] = "Double cliquez pour supprimer cette occurence."
L["Dropped by:"] = "Dépouillé sur :"
--[[Translation missing --]]
L["Edit Entry"] = "Edit Entry"
L["Enable Loot History"] = "Activer l'historique du butin"
L["Enable Timeout"] = "Activer le délai de vote"
L["enable_loot_history_desc"] = "Active l'historique. RCLootCouncil ne répertoriera rien si cette option est désactivée."
L["enable_timeout_desc"] = "Cocher pour activer le délai de vote dans la fenêtre de butin"
L["Enter your note:"] = "Saisissez votre note"
L["EQdkp-Plus XML output, tailored for Enjin import."] = "Exporter en EQdkp-Plus XML, adapté pour être importé sur Enjin."
--[[Translation missing --]]
L["error_test_as_non_leader"] = "You cannot initiate a test while in a group without being the group leader."
--[[Translation missing --]]
L["Everybody is up to date."] = "Everybody is up to date."
L["Everyone have voted"] = "Tout le monde a voté"
L["Export"] = "Exporter"
--[[Translation missing --]]
L["Fake Loot"] = "Fake Loot"
--[[Translation missing --]]
L["Following items were registered in the award later list:"] = "Following items were registered in the award later list:"
L["Following winners was registered:"] = "Les vainqueurs suivants ont été répertoriés :"
--[[Translation missing --]]
L["Found the following outdated versions"] = "Found the following outdated versions"
--[[Translation missing --]]
L["Frame options"] = "Frame options"
L["Free"] = "Gratuit"
--[[Translation missing --]]
L["Full Bags"] = "Full Bags"
L["g1"] = true
L["g2"] = true
--[[Translation missing --]]
L["Gave the item to you for distribution."] = "Gave the item to you for distribution."
L["General options"] = "Paramètres généraux"
L["Group Council Members"] = "Membres du groupe au conseil"
L["group_council_members_desc"] = "Ajouter au conseil des joueurs provenant d'un autre royaume ou d'une autre guilde."
L["group_council_members_head"] = "Ajouter au conseil des membres de votre groupe actuel."
L["Guild Council Members"] = "Membres de la guilde au conseil"
L["Hide Votes"] = "Masquer les votes"
L["hide_votes_desc"] = "Seuls les joueurs ayant déjà voté pourront voir le résultat des votes."
--[[Translation missing --]]
L["How to sync"] = "How to sync"
--[[Translation missing --]]
L["huge_export_desc"] = "Huge Export. Only show first line to avoid freezing the game. Ctrl+C to copy full content."
L["Ignore List"] = "Objets ignorés"
L["Ignore Options"] = "Paramètres des objets ignorés"
L["ignore_input_desc"] = "Introduisez l'ID d'un objet pour l'ajouter à la liste des objets ignorés, empêchant ainsi à RCLootCouncil de l'ajouter à l'avenir à une session"
L["ignore_input_usage"] = "Cette fonction n'accepte que l'ID des objets (numéro)"
L["ignore_list_desc"] = "Objets ignorés par RCLootCouncil. Cliquez sur un objet pour le retirer de la liste."
L["ignore_options_desc"] = "Gérez quels objets devraient être ignorés par RCLootCouncil. Si vous ajoutez un objet qui n'a pas été mis en cache, vous devez changer d'onglet puis revenir dans celui-ci pour que vous puissiez voir l'objet en question apparaître dans la liste."
--[[Translation missing --]]
L["import_desc"] = "Paste data here. Only show first 2500 characters to avoid freezing the game."
--[[Translation missing --]]
L["Invalid selection"] = "Invalid selection"
L["Item"] = "Objet"
--[[Translation missing --]]
L["'Item' is added to the award later list."] = "%s is added to the award later list."
--[[Translation missing --]]
L["Item quality is below the loot threshold"] = "Item quality is below the loot threshold"
L["Item received and added from 'player'"] = "Objet reçu de %s et ajouté."
--[[Translation missing --]]
L["Item was awarded to"] = "Item was awarded to"
L["Item(s) replaced:"] = "Objet(s) remplacés :"
--[[Translation missing --]]
L["item_in_bags_low_trade_time_remaining_reminder"] = "The following bind on pick up items in your inventory are in the award later list and have less than %s trade time remaining. To avoid this reminder, trade the item, or '/rc remove [index]' to remove the item from the list, or '/rc clear' to clear the award later list, or equip the item to make the item untradable."
--[[Translation missing --]]
L["Items stored in the loot master's bag for award later cannot be awarded later."] = "Items stored in the loot master's bag for award later cannot be awarded later."
L["Items under consideration:"] = "Objets en train d'être examinés"
L["Latest item(s) won"] = "Dernier(s) objet(s) attribué(s)."
L["Length"] = "Durée"
L["Log"] = "Journal"
L["log_desc"] = "Active le répertoriage dans l'historique du butin."
L["Loot announced, waiting for answer"] = "Butin divulgué, en attente d'une réponse"
L["Loot Everything"] = "Tout fouiller"
L["Loot History"] = "Historique du butin"
--[[Translation missing --]]
L["Loot Status"] = "Loot Status"
L["Loot won:"] = "Butin remporté :"
L["loot_everything_desc"] = "Active la fouille automatique des non-objets (p. ex. les montures, les jetons de sets de tier)"
L["loot_history_desc"] = [=[RCLootCouncil enregistre automatiquement les informations pertinentes durant les sessions.
Les données brutes sont enregistrées dans le fichier ".../SavedVariables/RCLootCouncil.lua".
Remarque : les joueurs autres que le maître du butin peuvent uniquement enregistrer les données qui leur sont envoyées par ce dernier.]=]
--[[Translation missing --]]
L["Looted"] = "Looted"
--[[Translation missing --]]
L["Looted by:"] = "Looted by:"
L["Looting options"] = "Paramètres de fouille"
L["Lower Quality Limit"] = "Seuil inférieur de qualité"
L["lower_quality_limit_desc"] = [=[Déterminez le seuil inférieur de qualité des objets qui seront automatiquement attribués (cette qualité est comprise).
Remarque : cette option prime le seuil de qualité par défaut. ]=]
L["Mainspec/Need"] = "Spécialisation principale / besoin"
--[[Translation missing --]]
L["Mass deletion of history entries."] = "Mass deletion of history entries."
L["Master Looter"] = "Maître du butin"
L["master_looter_desc"] = "Remarque : ces paramètres ne sont utilisés que lorsque vous êtes maître du butin."
L["Message"] = true
--[[Translation missing --]]
L["Message for each item"] = "Message for each item"
L["message_desc"] = "Message à envoyer au canal prédéfini."
L["Minimize in combat"] = "Minimiser en combat"
L["Minor Upgrade"] = "Légère amél."
L["ML sees voting"] = "MdB voit les votes"
L["ml_sees_voting_desc"] = "Permet au maître du butin de voir qui a voté pour qui."
--[[Translation missing --]]
L["module_tVersion_outdated_msg"] = "Newest module %s test version is: %s"
--[[Translation missing --]]
L["module_version_outdated_msg"] = "The module %s version %s is outdated. Newer version is %s."
L["Modules"] = true
L["More Info"] = "Plus d'info"
--[[Translation missing --]]
L["more_info_desc"] = "Select how many of your responses you want to see the latest awarded items for. E.g. selecting 2 will (with default settings) show the latest awarded Mainspec and Offspec items, along with how long ago they were awarded."
L["Multi Vote"] = "Vote multiple"
L["multi_vote_desc"] = "Active le vote multiple, ce qui permet aux votants de voter pour plusieurs candidats."
L["'n days' ago"] = "il y a %s"
L["Never use RCLootCouncil"] = "Ne jamais utiliser RCLootCouncil"
--[[Translation missing --]]
L["new_ml_bagged_items_reminder"] = "There are recent items in your award later list. '/rc list' to view the list, '/rc clear' to clear the list, '/rc remove [index]' to remove selected entry from the list. '/rc award' to start a session from the award later list, '/rc add' with award later checked to add the item into the list."
L["No (dis)enchanters found"] = "Aucun (dés)enchanteur trouvé"
L["No entries in the Loot History"] = "Aucune entrée dans l'historique du butin"
--[[Translation missing --]]
L["No entry in the award later list is removed."] = "No entry in the award later list is removed."
L["No items to award later registered"] = "Aucun objet devant être attribué plus tard enregistré"
--[[Translation missing --]]
L["No recipients available"] = "No recipients available"
L["No session running"] = "Aucune session en cours"
L["No winners registered"] = "Aucun vainqueur répertorié"
--[[Translation missing --]]
L["non_tradeable_reason_nil"] = "Unknown"
--[[Translation missing --]]
L["non_tradeable_reason_not_tradeable"] = "Not Tradeable"
--[[Translation missing --]]
L["non_tradeable_reason_rejected_trade"] = "Wanted to keep item"
--[[Translation missing --]]
L["Non-tradeable reason:"] = "Non-tradeable reason:"
L["Not announced"] = "Non annoncé"
L["Not cached, please reopen."] = "Pas gardé en cache, veuillez rouvrir."
L["Not Found"] = "Introuvable"
--[[Translation missing --]]
L["Not in your guild"] = "Not in your guild"
L["Not installed"] = "Pas installé"
L["Notes"] = true
L["notes_desc"] = "Permet aux candidats d'envoyer une note au conseil en plus du choix de leur réponse."
L["Now handles looting"] = "Gère à présent l'attribution du butin"
L["Number of buttons"] = "Nombre de boutons"
--[[Translation missing --]]
L["Number of raids received loot from:"] = "Number of raids received loot from:"
L["Number of reasons"] = "Nombre de motifs"
L["Number of responses"] = "Nombre de réponses"
L["number_of_buttons_desc"] = "Glisser pour modifier le nombre de boutons."
L["number_of_reasons_desc"] = "Glisser pour modifier le nombre de motifs."
L["Observe"] = "Observateurs"
L["observe_desc"] = "Autorise aux joueurs qui ne sont pas membres du conseil de voir la fenêtre de vote. Ils ne pourront néanmoins pas prendre part au vote."
L["Offline or RCLootCouncil not installed"] = "Hors ligne ou RCLootCouncil n'est pas installé"
L["Offspec/Greed"] = "Spécialisation secondaire / cupidité"
L["Only use in raids"] = "N'utiliser qu'en raid"
L["onlyUseInRaids_desc"] = "Cocher pour que RCLootCouncil soit automatiquement désactivé en groupe."
L["open"] = "ouvrir"
L["Open the Loot History"] = "Ouvrir l'historique du butin"
L["open_the_loot_history_desc"] = "Cliquer pour ouvrir l'historique du butin."
--[[Translation missing --]]
L["Opens the synchronizer"] = "Opens the synchronizer"
--[[Translation missing --]]
L["opt_addButton_desc"] = "Add a new button group for the selected slot."
--[[Translation missing --]]
L["opt_autoTrade_desc"] = "Check to automatically add awarded items to the trade window when trading with the winner. If disabled, you'll see a popup before items are added."
--[[Translation missing --]]
L["opt_buttonsGroup_desc"] = [=[Options group for %s buttons and responses.
See above for a detailed explanation.]=]
--[[Translation missing --]]
L["opt_deleteDate_confirm"] = [=[Are you sure you want to delete everything older than the selected?
This cannot be undone.]=]
--[[Translation missing --]]
L["opt_deleteDate_desc"] = "Delete anything older than the selected number of days."
--[[Translation missing --]]
L["opt_deleteName_confirm"] = [=[Are you sure you want to delete all entries from %s?
This cannot be undone.]=]
--[[Translation missing --]]
L["opt_deleteName_desc"] = "Delete all entries from the selected candidate."
--[[Translation missing --]]
L["opt_deletePatch_confirm"] = [=[Are you sure you want to delete everything older than the selected patch?
 This cannot be undone.]=]
--[[Translation missing --]]
L["opt_deletePatch_desc"] = "Delete all entries added before the selected patch."
--[[Translation missing --]]
L["opt_moreButtons_desc"] = "Add a new set of buttons for a specific gear slot. The most specific type is used, i.e. adding buttons for 'Head' and 'Azerite Armor' will make head type armor use the head buttons instead of azerite armor."
--[[Translation missing --]]
L["opt_printCompletedTrade_Desc"] = "Check to enable a message every time a candidate trades an awarded item to the winner."
--[[Translation missing --]]
L["opt_printCompletedTrade_Name"] = "Trade Messages"
--[[Translation missing --]]
L["opt_rejectTrade_Desc"] = "Check to enable candidates to choose whether they want to 'give' the item to the council or not. If unchecked, all tradeable PL items are added automatically."
--[[Translation missing --]]
L["opt_rejectTrade_Name"] = "Allow Keeping"
--[[Translation missing --]]
L["Original Owner"] = "Original Owner"
--[[Translation missing --]]
L["Out of instance"] = "Out of instance"
--[[Translation missing --]]
L["Patch"] = "Patch"
--[[Translation missing --]]
L["Personal Loot - Non tradeable"] = "Personal Loot - Non tradeable"
--[[Translation missing --]]
L["Personal Loot - Rejected Trade"] = "Personal Loot - Rejected Trade"
--[[Translation missing --]]
L["'player' can't receive 'type'"] = "%s can't receive %s - version mismatch?"
--[[Translation missing --]]
L["'player' declined your sync request"] = "%s declined your sync request"
L["'player' has asked you to reroll"] = "%s a demandé que vous relanciez les dés"
L["'player' has ended the session"] = "%s a mis fin à la session"
--[[Translation missing --]]
L["'player' has rolled 'roll' for: 'item'"] = "%s has rolled %d for: %s"
--[[Translation missing --]]
L["'player' hasn't opened the sync window"] = "%s hasn't opened the sync window (/rc sync)"
--[[Translation missing --]]
L["Player is ineligible for this item"] = "Player is ineligible for this item"
--[[Translation missing --]]
L["Player is not in the group"] = "Player is not in the group"
--[[Translation missing --]]
L["Player is not in this instance"] = "Player is not in this instance"
--[[Translation missing --]]
L["Player is offline"] = "Player is offline"
--[[Translation missing --]]
L["Please wait a few seconds until all data has been synchronized."] = "Please wait a few seconds until all data has been synchronized."
--[[Translation missing --]]
L["Please wait before trying to sync again."] = "Please wait before trying to sync again."
--[[Translation missing --]]
L["Print Responses"] = "Print Responses"
--[[Translation missing --]]
L["print_response_desc"] = "Print your response in the chat window"
--[[Translation missing --]]
L["Protector Token"] = "Protector Token"
L["Raw lua output. Doesn't work well with date selection."] = "Exporter données lua brutes. Ne fonctionne pas bien avec la sélection de dates."
--[[Translation missing --]]
L["RCLootCouncil - Synchronizer"] = "RCLootCouncil - Synchronizer"
L["RCLootCouncil Loot Frame"] = "Fenêtre du butin de RCLootCouncil"
L["RCLootCouncil Loot History"] = "Historique du butin de RCLootCouncil"
L["RCLootCouncil Session Setup"] = "Paramétrage de session de RCLootCouncil"
L["RCLootCouncil Version Checker"] = "Vérificateur de version de RCLootCouncil"
L["RCLootCouncil Voting Frame"] = "Fenêtre de vote de RCLootCouncil"
--[[Translation missing --]]
L["rclootcouncil_trade_add_item_confirm"] = "RCLootCouncil detects %d tradable items in your bags are awarded to %s. Do you want to add the items to the trade window?"
L["Reannounce ..."] = "Réannoncer ..."
--[[Translation missing --]]
L["Reannounced 'item' to 'target'"] = "Reannounced %s to %s"
L["Reason"] = "Motif"
L["reason_desc"] = "Motif d'attribution qui sera indiqué dans l'historique du butin lorsqu'un objet sera automatiquement attribué."
L["Remove All"] = "Retirer tous les joueurs"
L["Remove from consideration"] = "Retirer de la liste"
L["remove_all_desc"] = "Retirer tous les membres du conseil"
--[[Translation missing --]]
L["Requested rolls for 'item' from 'target'"] = "Requested rolls for %s from %s"
L["Reset Skin"] = "Réinitialiser l'apparence"
L["Reset skins"] = "Réinitialiser les apparences"
L["reset_announce_to_default_desc"] = "Réinitialise tous les paramètres des annonces avec les paramètres par défaut."
L["reset_buttons_to_default_desc"] = "Réinitialise tous les boutons, les couleurs et les réponses avec les paramètres par défaut."
L["reset_skin_desc"] = "Réinitialiser les couleurs et le fond de l'apparence sélectionnée."
L["reset_skins_desc"] = "Réinitialiser les apparences par défaut."
L["reset_to_default_desc"] = "Réinitialise les motifs d'attribution avec les paramètres par défaut."
L["Response"] = "Réponse"
L["Response color"] = "Couleur de la réponse"
--[[Translation missing --]]
L["Response isn't available. Please upgrade RCLootCouncil."] = "Response isn't available. Please upgrade RCLootCouncil."
--[[Translation missing --]]
L["Response options"] = "Response options"
--[[Translation missing --]]
L["Response to 'item'"] = "Response to %s"
--[[Translation missing --]]
L["Response to 'item' acknowledged as 'response'"] = "Response to %s acknowledged as \" %s \""
L["response_color_desc"] = "Définir une couleur pour la réponse."
--[[Translation missing --]]
L["Responses"] = "Responses"
L["Responses from Chat"] = "Réponses de la fenêtre de discussion"
L["responses_from_chat_desc"] = [=[Dans le cas où un joueur n'a pas installé l'add-on (le bouton 1 sera utilisé par défaut si aucun mot-clef n'a été saisi).
Par exemple : "/w Nom_du_maître_du_butin [Objet] cupidité" indiquera que vous avez choisi l'option cupidité pour un objet.
Vous pouvez définir ci-dessous les mots-clef qui pourront être utilisés pour chaque bouton. Seuls les caractères A-Z, a-z et 0-9 sont acceptés dans les mots-clef. Tous les autres caractères sont considérés comme une séparation.
Les joueurs peuvent afficher une liste des mots-clef en chuchotant 'rchelp' au maître du butin une fois l'add-on activé (p. ex. dans un raid).
]=]
L["Save Skin"] = "Sauvegarder l'apparence"
L["save_skin_desc"] = "Donnez un nom à votre apparence puis appuyez sur \"Okay\" pour la sauvegarder. Vous pouvez écraser n'importe quelle autre apparence que celles par défaut."
L["Self Vote"] = "Vote pour soi"
L["self_vote_desc"] = "Permet aux votants de voter pour eux."
L["Send History"] = "Envoyer l'historique"
L["send_history_desc"] = "Envoyer les données à tous les membres du raid, que vous enregistriez vous-même les données ou non. RCLootCouncil n'enverra de données que si vous êtes le maître du butin."
--[[Translation missing --]]
L["Sending 'type' to 'player'..."] = "Sending %s to %s..."
L["Sent whisper help to 'player'"] = "Chuchotement d'aide envoyé à %s"
L["session_error"] = "Une erreur est survenue, veuillez relancer la session"
--[[Translation missing --]]
L["session_help_from_bag"] = "After the session ends, you can use '/rc winners' to see who you should trade the items to."
--[[Translation missing --]]
L["session_help_not_direct"] = "Items in this session are not given to the candidates directly. Items needs to be traded."
L["Set the text for button i's response."] = "Définir le texte pour la réponse du bouton %d"
L["Set the text on button 'number'"] = "Définir le texte du bouton %i"
L["Set the whisper keys for button i."] = "Définissez les mots-clef de chuchotement du bouton &d."
--[[Translation missing --]]
L["Show Spec Icon"] = "Show Spec Icon"
--[[Translation missing --]]
L["show_spec_icon_desc"] = "Check to replace candidates' class icons with their spec icon, if available."
L["Silent Auto Pass"] = "Passer automatiquement (silencieux)"
L["silent_auto_pass_desc"] = "Cocher pour masquer les messages liés à la fonction \"passer automatiquement\""
L["Simple BBCode output."] = "Exporter en BBCode simple."
L["Skins"] = "Apparences"
L["skins_description"] = "Sélectionnez une des apparences par défaut ou créez en une vous-même. Ces options sont purement esthétiques. Ouvrez le vérificateur de version pour immédiatement voir les changements (\"/rc version\")."
--[[Translation missing --]]
L["Slot"] = "Slot"
--[[Translation missing --]]
L["Socket"] = "Socket"
L["Something went wrong :'("] = "Une erreur s'est produite :'("
--[[Translation missing --]]
L["Something went wrong during syncing, please try again."] = "Something went wrong during syncing, please try again."
--[[Translation missing --]]
L["Sort Items"] = "Sort Items"
--[[Translation missing --]]
L["sort_items_desc"] = "Sort sessions by item type and item level."
L["Standard .csv output."] = "Exporter en .csv standard."
L["Status texts"] = "Textes de statut"
--[[Translation missing --]]
L["Store in bag and award later"] = "Store in bag and award later"
--[[Translation missing --]]
L["Succesfully deleted %d entries"] = "Succesfully deleted %d entries"
--[[Translation missing --]]
L["Succesfully deleted %d entries from %s"] = "Succesfully deleted %d entries from %s"
--[[Translation missing --]]
L["Successfully imported 'number' entries."] = "Successfully imported %d entries."
--[[Translation missing --]]
L["Successfully received 'type' from 'player'"] = "Successfully received %s from %s."
--[[Translation missing --]]
L["Sync"] = "Sync"
--[[Translation missing --]]
L["sync_detailed_description"] = [=[
1. Both of you should have the sync frame open (/rc sync).
2. Select the type of data you want to send.
3. Select the player you want to receive the data.
4. Hit 'Sync' - you'll now see a statusbar with the data being sent.

This window needs to be open to initiate a sync,
but closing it won't stop a sync in progress.

Targets include online guild- and groupmembers, friends and your current friendly target.]=]
L["test"] = true
L["Test"] = true
L["test_desc"] = "Cliquer pour simuler pour vous et tous les membres de votre raid une session de butin où vous êtes le maître du butin."
L["Text color"] = "Couleur du texte"
L["Text for reason #i"] = "Texte du motif #"
L["text_color_desc"] = "Couleur du texte lorsqu'il sera affiché."
--[[Translation missing --]]
L["The award later list has been cleared."] = "The award later list has been cleared."
--[[Translation missing --]]
L["The award later list is empty."] = "The award later list is empty."
L["The following council members have voted"] = "Les membres du conseil suivants ont voté"
--[[Translation missing --]]
L["The following entries are removed from the award later list:"] = "The following entries are removed from the award later list:"
--[[Translation missing --]]
L["The following items are removed from the award later list and traded to 'player'"] = "The following items are removed from the award later list and are traded to %s"
--[[Translation missing --]]
L["The item can only be looted by you but it is not bind on pick up"] = "The item can only be looted by you but it is not bind on pick up"
--[[Translation missing --]]
L["The item will be awarded later"] = "The item will be awarded later"
L["The item would now be awarded to 'player'"] = "L'objet serait attribué à %s dans ces conditions"
L["The loot is already on the list"] = "Le butin fait déjà partie de la liste"
--[[Translation missing --]]
L["The loot master"] = "The loot master"
L["The Master Looter doesn't allow multiple votes."] = "Le maître du butin n'a pas autorisé le vote multiple."
L["The Master Looter doesn't allow votes for yourself."] = "Le maître du butin n'a pas autorisé de voter pour soi."
L["The session has ended."] = "La session est terminée."
L["This item"] = "Cet objet"
L["This item has been awarded"] = "Cet objet a été attribué"
L["Tier 19"] = true
L["Tier 20"] = true
--[[Translation missing --]]
L["Tier 21"] = "Tier 21"
--[[Translation missing --]]
L["Tier Tokens ..."] = "Tier Tokens ..."
L["Tier tokens received from here:"] = "Jetons d'armure obtenus dans cette instance :"
L["tier_token_heroic"] = "Héroïque"
L["tier_token_mythic"] = "Mythique"
L["tier_token_normal"] = "Normal"
L["Time"] = "Temps"
--[[Translation missing --]]
L["time_remaining_warning"] = "Warning - The following items in your bags cannot be traded in less than %d minutes:"
L["Timeout"] = "Délai de vote"
--[[Translation missing --]]
L["Timeout when giving 'item' to 'player'"] = "Timeout when giving %s to %s"
--[[Translation missing --]]
L["To target"] = "To target"
L["Tokens received"] = "Jetons obtenus"
--[[Translation missing --]]
L["Total awards"] = "Total awards"
L["Total items received:"] = "Nombre total d'objets reçus :"
L["Total items won:"] = "Nombre total d'objets remportés :"
--[[Translation missing --]]
L["trade_complete_message"] = "%s traded %s to %s."
--[[Translation missing --]]
L["trade_item_to_trade_not_found"] = "WARNING: Item to trade: %s couldn't be found in your inventory!"
--[[Translation missing --]]
L["trade_wrongwinner_message"] = "WARNING: %s traded %s to %s instead of %s!"
L["tVersion_outdated_msg"] = "La dernière version de test de RCLootCouncil est : %s"
--[[Translation missing --]]
L["Unable to give 'item' to 'player'"] = "Unable to give %s to %s"
L["Unable to give 'item' to 'player' - (player offline, left group or instance?)"] = "Impossible d'attribuer %s à %s - (joueur déconnecté, a quitté le groupe ou l'instance ?)"
L["Unable to give out loot without the loot window open."] = "Impossible d'attribuer d'objet sans que la fenêtre de butin ne soit ouverte."
--[[Translation missing --]]
L["Unawarded"] = "Unawarded"
L["Unguilded"] = "Sans guilde"
L["Unknown date"] = "Date inconnue"
L["Unknown/Chest"] = "Inconnu / Plastron"
--[[Translation missing --]]
L["Unlooted"] = "Unlooted"
L["Unvote"] = "Annuler"
L["Upper Quality Limit"] = "Seuil supérieur de qualité"
L["upper_quality_limit_desc"] = [=[Déterminez le seuil supérieur de qualité des objets qui seront automatiquement attribués (cette qualité est comprise).
Remarque : cette option prime le seuil de qualité par défaut. ]=]
L["Usage"] = "Utilisation"
L["Usage Options"] = "Options d'utilisation"
--[[Translation missing --]]
L["Vanquisher Token"] = "Vanquisher Token"
L["version"] = true
L["Version"] = true
L["Version Check"] = "Vérifier la version"
L["version_check_desc"] = "Lance le module du vérificateur de version."
L["version_outdated_msg"] = "Votre version %s est dépassée. La dernière version est %s, veuillez mettre à jour RCLootCouncil."
L["Vote"] = "Voter"
L["Voters"] = "Votants"
L["Votes"] = true
L["Voting options"] = "Paramètres de vote"
L["Waiting for response"] = "En attente d'une réponse"
L["whisper_guide"] = "[RCLootCouncil] : numéro réponse [objet1] [objet2]. Numéro : numéro de l'objet que vous désirez. Réponse : un des mots-clef prédéfinis. Insérez le lien de(s) l'objet(s) en question (numéro) dans la fenêtre de discussion en ajoutant le mot-clef adéquat. Par exemple : en tapant '1 cupidité [objet1]', vous auriez choisi cupidité pour l'objet numéro 1."
L["whisper_guide2"] = "[RCLootCouncil] : vous recevrez un message de confirmation si vous avez été ajouté à la session."
L["whisper_help"] = [=[Les membres du raid peuvent utiliser le système de chuchotement si un joueur n'a pas installé cet add-on.
En chuchotant 'rchelp' au maître du butin, ils verront s'afficher un guide en plus d'une liste de mots-clef, qui peuvent être modifiés dans l'onglet 'Boutons et réponses'.
Le maître du butin est conseillé d'activer l'option 'Annoncer les objets en examen', puisque le numéro de chaque objet est nécessaire pour pouvoir utiliser le système de chuchotement.
Remarque : les joueurs devraient malgré tout installer l'add-on, sans quoi toutes les informations concernant les joueurs ne seront pas disponibles.]=]
L["whisperKey_greed"] = "cupidité, spésecondaire, offspé, os, 2"
L["whisperKey_minor"] = "petitup, petit, 3"
L["whisperKey_need"] = "besoin, spéprincipale, mainspé, ms, 1"
L["Windows reset"] = "Réinitialisation des fenêtres"
L["winners"] = "vainqueurs"
L["x days"] = "%d jours"
L["x out of x have voted"] = "%d sur %d ont voté"
L["You are not allowed to see the Voting Frame right now."] = "Vous n'êtes pas autorisé à voir la fenêtre de vote pour le moment."
--[[Translation missing --]]
L["You are not in an instance"] = "You are not in an instance"
L["You can only auto award items with a quality lower than 'quality' to yourself due to Blizaard restrictions"] = "En raison des restrictions fixées par Blizzard, vous ne pouvez vous attribuer automatiquement que des objets de qualité inférieure à %s."
L["You cannot start an empty session."] = "Impossible de lancer une session vide."
L["You cannot use the menu when the session has ended."] = "Vous ne pouvez utiliser le menu si la session est terminée."
L["You cannot use this command without being the Master Looter"] = "Vous ne pouvez utiliser cette commande sans être le maître du butin"
L["You can't start a loot session while in combat."] = "Impossible de débuter une session de butin en combat."
L["You can't start a session before all items are loaded!"] = "Impossible de lancer une session tant que tous les objets n'ont pas été chargés !"
--[[Translation missing --]]
L["You haven't selected an award reason to use for disenchanting!"] = "You haven't selected an award reason to use for disenchanting!"
L["You haven't set a council! You can edit your council by typing '/rc council'"] = "Vous n'avez pas choisi de conseil ! Vous pouvez modifier votre conseil en tapant '/rc council'"
--[[Translation missing --]]
L["You must select a target"] = "You must select a target"
L["Your note:"] = "Votre note :"
L["You're already running a session."] = "Une session est déjà en cours"

