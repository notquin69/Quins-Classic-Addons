local HBDP = LibStub("HereBeDragons-Pins-2.0")
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("Spy")
local _

function Spy:RefreshCurrentList(player, source)
	local MainWindow = Spy.MainWindow
	if not MainWindow:IsShown() then
		return
	end

	local mode = Spy.db.profile.CurrentList
	local manageFunction = Spy.ListTypes[mode][2]
	if manageFunction then manageFunction() end

	local button = 1
	for index, data in pairs(Spy.CurrentList) do
		if button <= Spy.ButtonLimit then
			local level = "??"
			local class = "UNKNOWN"
			local opacity = 1

			local playerData = SpyPerCharDB.PlayerData[data.player]
			if playerData then
				if playerData.level then
					level = playerData.level
					if playerData.isGuess == true and tonumber(playerData.level) < Spy.MaximumPlayerLevel then level = level.."+" end
				end
				if playerData.class then class = playerData.class end
			end

			local description = level.." "
			if L[class] and type(L[class]) == "string" then description = description..L[class] end

			if mode == 1 and Spy.InactiveList[data.player] then
				opacity = 0.5
			end
			if player == data.player then
				if not source or source ~= Spy.CharacterName then
					Spy:AlertPlayer(player, source)
					if not source then Spy:AnnouncePlayer(player) end
				end
			end

			Spy:SetBar(button, data.player, description, 100, "Class", class, nil, opacity)
			Spy.ButtonName[button] = data.player
			button = button + 1
		end
	end
	Spy.ListAmountDisplayed = button - 1

	if Spy.db.profile.ResizeSpy then
		Spy:AutomaticallyResize()
	else if not InCombatLockdown() and Spy.MainWindow:GetHeight()< 34 then 
		Spy:RestoreMainWindowPosition(Spy.MainWindow:GetLeft(), Spy.MainWindow:GetTop(), Spy.MainWindow:GetWidth(), 34) end	 			
	end
	Spy:ManageBarsDisplayed()
end

function Spy:ManageNearbyList()
	local prioritiseKoS = Spy.db.profile.PrioritiseKoS

	local activeKoS = {}
	local active = {}
	for player in pairs(Spy.ActiveList) do
		local position = Spy.NearbyList[player]
		if position ~= nil then
			if prioritiseKoS and SpyPerCharDB.KOSData[player] then
				table.insert(activeKoS, { player = player, time = position })
			else
				table.insert(active, { player = player, time = position })
			end
		end
	end

	local inactiveKoS = {}
	local inactive = {}
	for player in pairs(Spy.InactiveList) do
		local position = Spy.NearbyList[player]
		if position ~= nil then
			if prioritiseKoS and SpyPerCharDB.KOSData[player] then
				table.insert(inactiveKoS, { player = player, time = position })
			else
				table.insert(inactive, { player = player, time = position })
			end
		end
	end

	table.sort(activeKoS, function(a, b) return a.time < b.time end)
	table.sort(inactiveKoS, function(a, b) return a.time < b.time end)
	table.sort(active, function(a, b) return a.time < b.time end)
	table.sort(inactive, function(a, b) return a.time < b.time end)

	local list = {}
	for player in pairs(activeKoS) do table.insert(list, activeKoS[player]) end
	for player in pairs(inactiveKoS) do table.insert(list, inactiveKoS[player]) end
	for player in pairs(active) do table.insert(list, active[player]) end
	for player in pairs(inactive) do table.insert(list, inactive[player]) end
	Spy.CurrentList = list
end

function Spy:ManageLastHourList()
	local list = {}
	for player in pairs(Spy.LastHourList) do
		table.insert(list, { player = player, time = Spy.LastHourList[player] })
	end
	table.sort(list, function(a, b) return a.time > b.time end)
	Spy.CurrentList = list
end

function Spy:ManageIgnoreList()
	local list = {}
	for player in pairs(SpyPerCharDB.IgnoreData) do
		local playerData = SpyPerCharDB.PlayerData[player]
		local position = time()
		if playerData then position = playerData.time end
		table.insert(list, { player = player, time = position })
	end
	table.sort(list, function(a, b) return a.time > b.time end)
	Spy.CurrentList = list
end

function Spy:ManageKillOnSightList()
	local list = {}
	for player in pairs(SpyPerCharDB.KOSData) do
		local playerData = SpyPerCharDB.PlayerData[player]
		local position = time()
		if playerData then position = playerData.time end
		table.insert(list, { player = player, time = position })
	end
	table.sort(list, function(a, b) return a.time > b.time end)
	Spy.CurrentList = list
end

function Spy:GetNearbyListSize()
	local entries = 0
	for v in pairs(Spy.NearbyList) do
		entries = entries + 1
	end
	return entries
end

function Spy:UpdateActiveCount()
    local activeCount = 0
    for k in pairs(Spy.ActiveList) do
        activeCount = activeCount + 1
    end
	local theFrame = Spy.MainWindow
    if activeCount > 0 then 
		theFrame.CountFrame.Text:SetText("|cFF0070DE" .. activeCount .. "|r") 
    else 
        theFrame.CountFrame.Text:SetText("|cFF0070DE0|r")
    end
end

function Spy:ManageExpirations()
	local mode = Spy.db.profile.CurrentList
	local expirationFunction = Spy.ListTypes[mode][3]
	if expirationFunction then expirationFunction() end
end

function Spy:ManageNearbyListExpirations()
	local expired = false
	local currentTime = time()
	for player in pairs(Spy.ActiveList) do
		if (currentTime - Spy.ActiveList[player]) > Spy.ActiveTimeout then
			Spy.InactiveList[player] = Spy.ActiveList[player]
			Spy.ActiveList[player] = nil
			expired = true
		end
	end
	if Spy.db.profile.RemoveUndetected ~= "Never" then
		for player in pairs(Spy.InactiveList) do
			if (currentTime - Spy.InactiveList[player]) > Spy.InactiveTimeout then
				if Spy.PlayerCommList[player] ~= nil then
					Spy.MapNoteList[Spy.PlayerCommList[player]].displayed = false
					Spy.MapNoteList[Spy.PlayerCommList[player]].worldIcon:Hide()
					HBDP:RemoveMinimapIcon(self, Spy.MapNoteList[Spy.PlayerCommList[player]].miniIcon)
					Spy.PlayerCommList[player] = nil
				end
				Spy.InactiveList[player] = nil
				Spy.NearbyList[player] = nil
				expired = true
			end
		end
	end
	if expired then
		Spy:RefreshCurrentList()
		Spy:UpdateActiveCount()
		if Spy.db.profile.HideSpy and Spy:GetNearbyListSize() == 0 then 
			if not InCombatLockdown() then
				Spy.MainWindow:Hide()
			else	
				Spy:HideSpyCombatCheck()
			end
		end
	end
end

function Spy:ManageLastHourListExpirations()
	local expired = false
	local currentTime = time()
	for player in pairs(Spy.LastHourList) do
		if (currentTime - Spy.LastHourList[player]) > 3600 then
			Spy.LastHourList[player] = nil
			expired = true
		end
	end
	if expired then
		Spy:RefreshCurrentList()
	end
end

function Spy:RemovePlayerFromList(player)
	Spy.NearbyList[player] = nil
	Spy.ActiveList[player] = nil
	Spy.InactiveList[player] = nil
	if Spy.PlayerCommList[player] ~= nil then
		Spy.MapNoteList[Spy.PlayerCommList[player]].displayed = false
		Spy.MapNoteList[Spy.PlayerCommList[player]].worldIcon:Hide()
		HBDP:RemoveMinimapIcon(self, Spy.MapNoteList[Spy.PlayerCommList[player]].miniIcon)
		Spy.PlayerCommList[player] = nil
	end
	Spy:RefreshCurrentList()
	Spy:UpdateActiveCount()	
end

function Spy:ClearList()
	Spy.NearbyList = {}
	Spy.ActiveList = {}
	Spy.InactiveList = {}
	Spy.PlayerCommList = {}
	Spy.ListAmountDisplayed = 0
	for i = 1, Spy.MapNoteLimit do
		Spy.MapNoteList[i].displayed = false
		Spy.MapNoteList[i].worldIcon:Hide()
		HBDP:RemoveMinimapIcon(self, Spy.MapNoteList[i].miniIcon)
	end
	Spy:SetCurrentList(1)
	if IsControlKeyDown() then
		Spy:EnableSpy(not Spy.db.profile.Enabled, false)
	end
	Spy:UpdateActiveCount()
end

function Spy:AddPlayerData(name, class, level, race, guild, isEnemy, isGuess)
	local info = {}
	info.name = name  --++ added to normalize data
	info.class = class
	if type(level) == "number" then info.level = level end
	info.race = race
	info.guild = guild
	info.isEnemy = isEnemy
	info.isGuess = isGuess
	SpyPerCharDB.PlayerData[name] = info
	return SpyPerCharDB.PlayerData[name]
end

function Spy:UpdatePlayerData(name, class, level, race, guild, isEnemy, isGuess)
	local detected = true
	local playerData = SpyPerCharDB.PlayerData[name]
	if not playerData then
		playerData = Spy:AddPlayerData(name, class, level, race, guild, isEnemy, isGuess)
	else
		if name ~= nil then playerData.name = name end  --++ added to merge addons
		if class ~= nil then playerData.class = class end
		if type(level) == "number" then playerData.level = level end
		if race ~= nil then playerData.race = race end
		if guild ~= nil then playerData.guild = guild end
		if isEnemy ~= nil then playerData.isEnemy = isEnemy end
		if isGuess ~= nil then playerData.isGuess = isGuess end
	end
	if playerData then
		playerData.time = time()
		if not Spy.ActiveList[name] then
			if (WorldMapFrame:IsVisible() and Spy.db.profile.SwitchToZone) then
				WorldMapFrame:SetMapID(C_Map.GetBestMapForUnit("player"))
			end
			if (nil == C_Map.GetBestMapForUnit("player")) or (nil == C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player")) then -- 8.0 Changes
			local x,y = 0,0
				local InsName = GetInstanceInfo()
				playerData.zone = InsName
				playerData.subZone = ""
			else
				local mapX, mapY = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY() -- 8.0 Change			
					if mapX ~= 0 and mapY ~= 0 then
					mapX = math.floor(tonumber(mapX) * 100) / 100
					mapY = math.floor(tonumber(mapY) * 100) / 100
					playerData.mapX = mapX
					playerData.mapY = mapY
					playerData.zone = GetZoneText()
					playerData.mapID = C_Map.GetBestMapForUnit("player") --++8.0
					playerData.subZone = GetSubZoneText()
				else
					detected = false
				end
			end
		end	
	end
	return detected
end

function Spy:RemovePlayerData(name)
	SpyPerCharDB.PlayerData[name] = nil
end

function Spy:AddIgnoreData(name)
	SpyPerCharDB.IgnoreData[name] = true
end

function Spy:RemoveIgnoreData(name)
	if SpyPerCharDB.IgnoreData[name] then
		SpyPerCharDB.IgnoreData[name] = nil
	end
end

function Spy:AddKOSData(name)
	SpyPerCharDB.KOSData[name] = time()
--	SpyPerCharDB.PlayerData[name].kos = 1 
	if Spy.db.profile.ShareKOSBetweenCharacters then SpyDB.removeKOSData[Spy.RealmName][Spy.FactionName][name] = nil end
end

function Spy:RemoveKOSData(name)
	if SpyPerCharDB.KOSData[name] then
		local playerData = SpyPerCharDB.PlayerData[name]
		if playerData and playerData.reason then playerData.reason = nil end
		SpyPerCharDB.KOSData[name] = nil
		SpyPerCharDB.PlayerData[name].kos = nil		
		if Spy.db.profile.ShareKOSBetweenCharacters then SpyDB.removeKOSData[Spy.RealmName][Spy.FactionName][name] = time() end
	end
end

function Spy:SetKOSReason(name, reason, other)
	local playerData = SpyPerCharDB.PlayerData[name]
	if playerData then
		if not reason then
			playerData.reason = nil
		else
			if not playerData.reason then playerData.reason = {} end
			if reason == L["KOSReasonOther"] then
				if not other then 
					local dialog = StaticPopup_Show("Spy_SetKOSReasonOther", name)
					if dialog then dialog.playerName = name end
				else
					if other == "" then
						playerData.reason[L["KOSReasonOther"]] = nil
					else
						playerData.reason[L["KOSReasonOther"]] = other
					end
					Spy:RegenerateKOSCentralList(name)
				end
			else
				if playerData.reason[reason] then
					playerData.reason[reason] = nil
				else
					playerData.reason[reason] = true
				end
				Spy:RegenerateKOSCentralList(name)
			end
		end
	end
end

function Spy:AlertPlayer(player, source)
	local playerData = SpyPerCharDB.PlayerData[player]
	if SpyPerCharDB.KOSData[player] and Spy.db.profile.WarnOnKOS then
		if Spy.db.profile.DisplayWarningsInErrorsFrame then
			local text = Spy.db.profile.Colors.Warning["Warning Text"]
			local msg = L["KOSWarning"]..player
			UIErrorsFrame:AddMessage(msg, text.r, text.g, text.b, 1.0, UIERRORS_HOLD_TIME)
		else
			if source ~= nil and source ~= Spy.CharacterName then
				Spy:ShowAlert("kosaway", player, source, Spy:GetPlayerLocation(playerData))
			else
				local reasonText = ""
				if playerData.reason then
					for reason in pairs(playerData.reason) do
						if reasonText ~= "" then reasonText = reasonText..", " end
						if reason == L["KOSReasonOther"] then
							reasonText = reasonText..playerData.reason[reason]
						else
							reasonText = reasonText..reason
						end
					end
				end
				Spy:ShowAlert("kos", player, nil, reasonText)
			end
		end
		if Spy.db.profile.EnableSound then
			if source ~= nil and source ~= Spy.CharacterName then
				PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-kosaway.mp3")
			else
				PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-kos.mp3")
			end
		end
		if Spy.db.profile.ShareKOSBetweenCharacters then Spy:RegenerateKOSCentralList(player) end
	elseif Spy.db.profile.WarnOnKOSGuild then
		if playerData and playerData.guild and Spy.KOSGuild[playerData.guild] then
			if Spy.db.profile.DisplayWarningsInErrorsFrame then
				local text = Spy.db.profile.Colors.Warning["Warning Text"]
				local msg = L["KOSGuildWarning"].."<"..playerData.guild..">"
				UIErrorsFrame:AddMessage(msg, text.r, text.g, text.b, 1.0, UIERRORS_HOLD_TIME)				
			else
				if source ~= nil and source ~= Spy.CharacterName then
					Spy:ShowAlert("kosguildaway", "<"..playerData.guild..">", source, Spy:GetPlayerLocation(playerData))
				else
					Spy:ShowAlert("kosguild", "<"..playerData.guild..">")
				end
			end
			if Spy.db.profile.EnableSound then
				if source ~= nil and source ~= Spy.CharacterName then
					PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-kosaway.mp3")
				else
					PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-kosguild.mp3")
				end
			end
		else
			if Spy.db.profile.EnableSound and not Spy.db.profile.OnlySoundKoS then 
				if source == nil or source == Spy.CharacterName then
					if playerData and Spy.db.profile.WarnOnRace and playerData.race == Spy.db.profile.SelectWarnRace then --++
						PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-race.mp3") 
					else
						PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-nearby.mp3")
					end
				end
			end
		end
	elseif Spy.db.profile.EnableSound and not Spy.db.profile.OnlySoundKoS then 	--++
		if source == nil or source == Spy.CharacterName then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-nearby.mp3")
		end
	end
end

function Spy:AlertStealthPlayer(player)
	if Spy.db.profile.WarnOnStealth then
		if Spy.db.profile.DisplayWarningsInErrorsFrame then
			local text = Spy.db.profile.Colors.Warning["Warning Text"]
			local msg = L["StealthWarning"]..player
			UIErrorsFrame:AddMessage(msg, text.r, text.g, text.b, 1.0, UIERRORS_HOLD_TIME)						
		else
			Spy:ShowAlert("stealth", player)
		end
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-stealth.mp3")
		end
	end
end

function Spy:AlertProwlPlayer(player)
	if Spy.db.profile.WarnOnStealth then
		if Spy.db.profile.DisplayWarningsInErrorsFrame then
			local text = Spy.db.profile.Colors.Warning["Warning Text"]
			local msg = L["StealthWarning"]..player
			UIErrorsFrame:AddMessage(msg, text.r, text.g, text.b, 1.0, UIERRORS_HOLD_TIME)						
		else
			Spy:ShowAlert("prowl", player)
		end
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\detected-stealth.mp3")
		end
	end
end

function Spy:AnnouncePlayer(player, channel)
	if not Spy_IgnoreList[player] then
		local msg = ""
		local isKOS = SpyPerCharDB.KOSData[player]
		local playerData = SpyPerCharDB.PlayerData[player]

		local announce = Spy.db.profile.Announce  
		if channel or announce == "Self" or announce == "LocalDefense" or (announce == "Guild" and GetGuildInfo("player") ~= nil and not Spy.InInstance) or (announce == "Party" and GetNumGroupMembers() > 0) or (announce == "Raid" and UnitInRaid("player")) then --++
			if announce == "Self" and not channel then
				if isKOS then
					msg = msg..L["SpySignatureColored"]..L["KillOnSightDetectedColored"]..player.." "
				else
					msg = msg..L["SpySignatureColored"]..L["PlayerDetectedColored"]..player.." "
				end
			else
				if isKOS then
					msg = msg..L["KillOnSightDetected"]..player.." "
				else
					msg = msg..L["PlayerDetected"]..player.." "
				end
			end
			if playerData then
				if playerData.guild and playerData.guild ~= "" then
					msg = msg.."<"..playerData.guild.."> "
				end
				if playerData.level or playerData.race or (playerData.class and playerData.class ~= "") then
					msg = msg.."- "
					if playerData.level and playerData.isGuess == false then msg = msg..L["Level"].." "..playerData.level.." " end
					if playerData.race and playerData.race ~= "" then msg = msg..playerData.race.." " end
					if playerData.class and playerData.class ~= "" then msg = msg..L[playerData.class].." " end
				end
				if playerData.zone then
					if playerData.subZone and playerData.subZone ~= "" and playerData.subZone ~= playerData.zone then
						msg = msg.."- "..playerData.subZone..", "..playerData.zone
					else
						msg = msg.."- "..playerData.zone
					end
				end
				if playerData.mapX and playerData.mapY then msg = msg.." ("..math.floor(tonumber(playerData.mapX) * 100)..","..math.floor(tonumber(playerData.mapY) * 100)..")" end
			end

			if channel then
				-- announce to selected channel
				if (channel == "PARTY" and GetNumGroupMembers() > 0) or (channel == "RAID" and UnitInRaid("player")) or (channel == "GUILD" and GetGuildInfo("player") ~= nil) then --++
					SendChatMessage(msg, channel)
				elseif channel == "LOCAL" then
					SendChatMessage(msg, "CHANNEL", nil, GetChannelName(L["LocalDefenseChannelName"].." - "..GetZoneText()))
				end
			else
				-- announce to standard channel
				if isKOS or not Spy.db.profile.OnlyAnnounceKoS then
					if announce == "Self" then
						DEFAULT_CHAT_FRAME:AddMessage(msg)
					elseif announce == "LocalDefense" then
						SendChatMessage(msg, "CHANNEL", nil, GetChannelName(L["LocalDefenseChannelName"].." - "..GetZoneText()))
					else
						SendChatMessage(msg, strupper(announce))
					end
				end
			end
		end

		-- announce to other Spy users
		if Spy.db.profile.ShareData then
			local class, level, race, zone, subZone, mapX, mapY, guild, mapID = "", "", "", "", "", "", "", "", ""	 --++8.0			
			if playerData then
				if playerData.class then class = playerData.class end
				if playerData.level and playerData.isGuess == false then level = playerData.level end
				if playerData.race then race = playerData.race end
				if playerData.zone then zone = playerData.zone end
				if playerData.mapID then mapID = playerData.mapID end		--++8.0				
				if playerData.subZone then subZone = playerData.subZone end
				if playerData.mapX then mapX = playerData.mapX end
				if playerData.mapY then mapY = playerData.mapY end
				if playerData.guild then guild = playerData.guild end
			end
			local details = Spy.Version.."|"..player.."|"..class.."|"..level.."|"..race.."|"..zone.."|"..subZone.."|"..mapX.."|"..mapY.."|"..guild.."|"..mapID	 --++8.0
			if strlen(details) < 240 then
				if channel then
					if (channel == "PARTY" and GetNumGroupMembers() > 0) or (channel == "RAID" and UnitInRaid("player")) or (channel == "GUILD" and GetGuildInfo("player") ~= nil) then --++
						Spy:SendCommMessage(Spy.Signature, details, channel)
					end
				else
					if GetNumGroupMembers() > 0 then Spy:SendCommMessage(Spy.Signature, details, "PARTY") end --++
					if UnitInRaid("player") then Spy:SendCommMessage(Spy.Signature, details, "RAID") end
					if Spy.InInstance == false and GetGuildInfo("player") ~= nil then Spy:SendCommMessage(Spy.Signature, details, "GUILD") end
				end
			end
		end
	end	
end

function Spy:ToggleIgnorePlayer(ignore, player)
	if ignore then
		Spy:AddIgnoreData(player)
		Spy:RemoveKOSData(player)
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\list-add.mp3")
		end
		DEFAULT_CHAT_FRAME:AddMessage(L["SpySignatureColored"]..L["PlayerAddedToIgnoreColored"]..player)
	else
		Spy:RemoveIgnoreData(player)
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\list-remove.mp3")
		end
		DEFAULT_CHAT_FRAME:AddMessage(L["SpySignatureColored"]..L["PlayerRemovedFromIgnoreColored"]..player)
	end
	Spy:RegenerateKOSGuildList()
	if Spy.db.profile.ShareKOSBetweenCharacters then Spy:RegenerateKOSCentralList() end
	Spy:RefreshCurrentList()
end

function Spy:ToggleKOSPlayer(kos, player)
	if kos then
		Spy:AddKOSData(player)
		Spy:RemoveIgnoreData(player)
		if player ~= SpyPerCharDB.PlayerData[name] then --++
			Spy:UpdatePlayerData(player, nil, nil, nil, nil, true, nil) --++
			SpyPerCharDB.PlayerData[player].kos = 1 
		end	
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\list-add.mp3")
		end
		DEFAULT_CHAT_FRAME:AddMessage(L["SpySignatureColored"]..L["PlayerAddedToKOSColored"]..player)
	else
		Spy:RemoveKOSData(player)
		if Spy.db.profile.EnableSound then
			PlaySoundFile("Interface\\AddOns\\Spy\\Sounds\\list-remove.mp3")
		end
		DEFAULT_CHAT_FRAME:AddMessage(L["SpySignatureColored"]..L["PlayerRemovedFromKOSColored"]..player)
	end
	Spy:RegenerateKOSGuildList()
	if Spy.db.profile.ShareKOSBetweenCharacters then Spy:RegenerateKOSCentralList() end
	Spy:RefreshCurrentList()
end

function Spy:PurgeUndetectedData()
	local secondsPerDay = 60 * 60 * 24
	local timeout = 90 * secondsPerDay
	if Spy.db.profile.PurgeData == "OneDay" then
		timeout = secondsPerDay
	elseif Spy.db.profile.PurgeData == "FiveDays" then
		timeout = 5 * secondsPerDay
	elseif Spy.db.profile.PurgeData == "TenDays" then
		timeout = 10 * secondsPerDay
	elseif Spy.db.profile.PurgeData == "ThirtyDays" then
		timeout = 30 * secondsPerDay
	elseif Spy.db.profile.PurgeData == "SixtyDays" then
		timeout = 60 * secondsPerDay
	elseif Spy.db.profile.PurgeData == "NinetyDays" then
		timeout = 90 * secondsPerDay
	end

	-- remove expired players held in character data
	local currentTime = time()
	for player in pairs(SpyPerCharDB.PlayerData) do
		local playerData = SpyPerCharDB.PlayerData[player]
		if Spy.db.profile.PurgeWinLossData then -- Added v3.2.9
			if not playerData.time or (currentTime - playerData.time) > timeout or not playerData.isEnemy then
				Spy:RemoveIgnoreData(player)
				Spy:RemoveKOSData(player)
				SpyPerCharDB.PlayerData[player] = nil
			end
		else
			if ((playerData.loses == nil) and (playerData.wins == nil)) then -- Added v3.2.9
				if not playerData.time or (currentTime - playerData.time) > timeout or not playerData.isEnemy then
					Spy:RemoveIgnoreData(player)
					if Spy.db.profile.PurgeKoS then -- Added v3.2.9	
						Spy:RemoveKOSData(player)
						SpyPerCharDB.PlayerData[player] = nil
					else
						if (playerData.kos == nil) then
							SpyPerCharDB.PlayerData[player] = nil  -- Added v3.4.0
						end	
					end	
				end
			end
		end
	end
	
	-- remove expired kos players held in central data
	local kosData = SpyDB.kosData[Spy.RealmName][Spy.FactionName]
	for characterName in pairs(kosData) do
		local characterKosData = kosData[characterName]
		for player in pairs(characterKosData) do
			local kosPlayerData = characterKosData[player]
			if Spy.db.profile.PurgeKoS then -- Added v3.2.9
				if not kosPlayerData.time or (currentTime - kosPlayerData.time) > timeout or not kosPlayerData.isEnemy then
					SpyDB.kosData[Spy.RealmName][Spy.FactionName][characterName][player] = nil
					SpyDB.removeKOSData[Spy.RealmName][Spy.FactionName][player] = nil
				end
			end
		end
	end
	if not Spy.db.profile.AppendUnitNameCheck then 	
		Spy:AppendUnitNames() end
	if not Spy.db.profile.AppendUnitKoSCheck then
		Spy:AppendUnitKoS() end
end

function Spy:RegenerateKOSGuildList()
	Spy.KOSGuild = {}
	for player in pairs(SpyPerCharDB.KOSData) do
		local playerData = SpyPerCharDB.PlayerData[player]
		if playerData and playerData.guild then
			Spy.KOSGuild[playerData.guild] = true
		end
	end
end

function Spy:RemoveLocalKOSPlayers()
	for player in pairs(SpyPerCharDB.KOSData) do
		if SpyDB.removeKOSData[Spy.RealmName][Spy.FactionName][player] then
			Spy:RemoveKOSData(player)
		end
	end
end

function Spy:RegenerateKOSCentralList(player)
	if player then
		local playerData = SpyPerCharDB.PlayerData[player]
		SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player] = {}
		if playerData then SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player] = playerData end
		SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player].added = SpyPerCharDB.KOSData[player]
	else
		for player in pairs(SpyPerCharDB.KOSData) do
			local playerData = SpyPerCharDB.PlayerData[player]
			SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player] = {}
			if playerData then SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player] = playerData end
			SpyDB.kosData[Spy.RealmName][Spy.FactionName][Spy.CharacterName][player].added = SpyPerCharDB.KOSData[player]
		end
	end
end

function Spy:RegenerateKOSListFromCentral()
	local kosData = SpyDB.kosData[Spy.RealmName][Spy.FactionName]
	for characterName in pairs(kosData) do
		if characterName ~= Spy.CharacterName then
			local characterKosData = kosData[characterName]
			for player in pairs(characterKosData) do
				if not SpyDB.removeKOSData[Spy.RealmName][Spy.FactionName][player] then
					local playerData = SpyPerCharDB.PlayerData[player]
					if not playerData then
						playerData = Spy:AddPlayerData(player, class, level, race, guild, isEnemy, isGuess)
					end
					local kosPlayerData = characterKosData[player]
					if kosPlayerData.time and (not playerData.time or (playerData.time and playerData.time < kosPlayerData.time)) then
						playerData.time = kosPlayerData.time
						if kosPlayerData.class then playerData.class = kosPlayerData.class end
						if type(kosPlayerData.level) == "number" and (type(playerData.level) ~= "number" or playerData.level < kosPlayerData.level) then playerData.level = kosPlayerData.level end
						if kosPlayerData.race then playerData.race = kosPlayerData.race end
						if kosPlayerData.guild then playerData.guild = kosPlayerData.guild end
						if kosPlayerData.isEnemy then playerData.isEnemy = kosPlayerData.isEnemy end
						if kosPlayerData.isGuess then playerData.isGuess = kosPlayerData.isGuess end
						if type(kosPlayerData.wins) == "number" and (type(playerData.wins) ~= "number" or playerData.wins < kosPlayerData.wins) then playerData.wins = kosPlayerData.wins end
						if type(kosPlayerData.loses) == "number" and (type(playerData.loses) ~= "number" or playerData.loses < kosPlayerData.loses) then playerData.loses = kosPlayerData.loses end
						if kosPlayerData.mapX then playerData.mapX = kosPlayerData.mapX end
						if kosPlayerData.mapY then playerData.mapY = kosPlayerData.mapY end
						if kosPlayerData.zone then playerData.zone = kosPlayerData.zone end
						if kosPlayerData.mapID then playerData.mapID = kosPlayerData.mapID end			 --++8.0						
						if kosPlayerData.subZone then playerData.subZone = kosPlayerData.subZone end
						if kosPlayerData.reason then
							playerData.reason = {}
							for reason in pairs(kosPlayerData.reason) do
								playerData.reason[reason] = kosPlayerData.reason[reason]
							end
						end
					end
					local characterKOSPlayerData = SpyPerCharDB.KOSData[player]
					if kosPlayerData.added and (not characterKOSPlayerData or characterKOSPlayerData < kosPlayerData.added) then
						SpyPerCharDB.KOSData[player] = kosPlayerData.added
					end
				end
			end
		end
	end
end

function Spy:ButtonClicked(self, button)
	local name = Spy.ButtonName[self.id]
	if name and name ~= "" then
		if button == "LeftButton" then
			if IsShiftKeyDown() then
				if SpyPerCharDB.KOSData[name] then
					Spy:ToggleKOSPlayer(false, name)
				else
					Spy:ToggleKOSPlayer(true, name)
				end
			elseif IsControlKeyDown() then
				if SpyPerCharDB.IgnoreData[name] then
					Spy:ToggleIgnorePlayer(false, name)
				else
					Spy:ToggleIgnorePlayer(true, name)
				end
			else
				if not InCombatLockdown() then
					self:SetAttribute("macrotext", "/targetexact "..name)
				end	
			end
		elseif button == "RightButton" then
			Spy:BarDropDownOpen(self)
			CloseDropDownMenus(1)
			ToggleDropDownMenu(1, nil, Spy_BarDropDownMenu)
		end
	end
end

function Spy:ParseMinimapTooltip(tooltip)
	local newTooltip = ""
	local newLine = false
	for text in string.gmatch(tooltip, "[^\n]*") do
		local name = text
		if string.len(text) > 0 then
			if strsub(text, 1, 2) == "|T" then
			name = strtrim(gsub(gsub(text, "|T.-|t", ""), "|r", ""))
			end
			local playerData = SpyPerCharDB.PlayerData[name]
			if not playerData then
				for index, v in pairs(Spy.LastHourList) do
					local realmSeparator = strfind(index, "-")
					if realmSeparator and realmSeparator > 1 and strsub(index, 1, realmSeparator - 1) == strsub(name, 1, realmSeparator - 1) then
						playerData = SpyPerCharDB.PlayerData[index]
						break
					end
				end
			end
			if playerData and playerData.isEnemy then
				local desc = ""
				if playerData.class and playerData.level then
					desc = L["MinimapClassText"..playerData.class].." ["..playerData.level.." "..L[playerData.class].."]|r"
				elseif playerData.class then
					desc = L["MinimapClassText"..playerData.class].." ["..L[playerData.class].."]|r"
				elseif playerData.level then
					desc = " ["..playerData.level.."]|r"
				end
				if (newTooltip and desc == "") then
					newTooltip = text 
				elseif (newTooltip == "") then	
					newTooltip = text.."|r"..desc
				else
					newTooltip = newTooltip.."\r"..text.."|r"..desc
				end	
				if not SpyPerCharDB.IgnoreData[name] and not Spy.InInstance then
					local detected = Spy:UpdatePlayerData(name, nil, nil, nil, nil, true, nil)
					if detected and Spy.db.profile.MinimapTracking then
						Spy:AddDetected(name, time(), false)
					end
				end
			else
				if (newTooltip == "") then
					newTooltip = text
				else	
					newTooltip = newTooltip.."\n"..text
				end
			end
			newLine = false
		elseif not newLine then
			newTooltip = newTooltip
			newLine = true
		end
	end
	return newTooltip
end

function Spy:ParseUnitAbility(analyseSpell, event, player, flags, spellId, spellName)
	local learnt = false
	if player then
		local class = nil
		local level = nil
		local race = nil
		local isEnemy = true
		local isGuess = true

		local playerData = SpyPerCharDB.PlayerData[player]
		if not playerData or playerData.isEnemy == nil then
			learnt = true
		end

		if analyseSpell then
			local abilityType = strsub(event, 1, 5)
			if abilityType == "SWING" or abilityType == "SPELL" or abilityType == "RANGE" then
--				local ability = Spy_AbilityList[spellName]
				local ability = Spy_AbilityList[spellId]				
				if ability then
					if ability.class and not (playerData and playerData.class) then
						class = ability.class
						learnt = true
					end
					if ability.level then
						local playerLevelNumber = nil
						if playerData and playerData.level then playerLevelNumber = tonumber(playerData.level) end
						if type(playerLevelNumber) ~= "number" or playerLevelNumber < ability.level then
							level = ability.level
							learnt = true
						end
					end
					if ability.race and not (playerData and playerData.race) then
						race = ability.race
						learnt = true
					end
				end
				if class and race and level == Spy.MaximumPlayerLevel then
					isGuess = false
					learnt = true
				end
			end
		end

		Spy:UpdatePlayerData(player, class, level, race, nil, isEnemy, isGuess)
		return learnt, playerData
	end
	return learnt, nil
end

function Spy:ParseUnitDetails(player, class, level, race, zone, subZone, mapX, mapY, guild, mapID) --++ P8.0
	if player then
		local playerData = SpyPerCharDB.PlayerData[player]
		if not playerData then
			playerData = Spy:AddPlayerData(player, class, level, race, guild, true, true)
		else
			if not playerData.class then playerData.class = class end
			if level then
				local levelNumber = tonumber(level)
				if type(levelNumber) == "number" then
					if playerData.level then
						local playerLevelNumber = tonumber(playerData.level)
						if type(playerLevelNumber) == "number" and playerLevelNumber < levelNumber then playerData.level = levelNumber end
					else
						playerData.level = levelNumber
					end
				end
			end
			if not playerData.race then playerData.race = race end
			if not playerData.guild then playerData.guild = guild end
		end
		playerData.isEnemy = true
		playerData.time = time()
		playerData.zone = zone
		playerData.mapID = mapID --++ P8.0		
		playerData.subZone = subZone
		playerData.mapX = mapX
		playerData.mapY = mapY

		return true, playerData
	end
	return true, nil
end

function Spy:AddDetected(player, timestamp, learnt, source)
	if Spy.db.profile.ShowOnlyPvPFlagged then
		if UnitIsPVP("player") then
			Spy:AddDetectedToLists(player, timestamp, learnt, source)
		else
		end	
	else
		Spy:AddDetectedToLists(player, timestamp, learnt, source)
	end	
end

function Spy:AddDetectedToLists(player, timestamp, learnt, source)
	if not Spy.NearbyList[player] then
		if Spy.db.profile.ShowOnDetection and not Spy.db.profile.MainWindowVis then
			Spy:SetCurrentList(1)
			Spy:EnableSpy(true, true, true)
		end
		if Spy.db.profile.CurrentList ~= 1 and Spy.db.profile.MainWindowVis and Spy.db.profile.ShowNearbyList then
			Spy:SetCurrentList(1)
		end

		if source and source ~= Spy.CharacterName and not Spy.ActiveList[player] then
			Spy.NearbyList[player] = timestamp
			Spy.LastHourList[player] = timestamp
			Spy.InactiveList[player] = timestamp
		else
			Spy.NearbyList[player] = timestamp
			Spy.LastHourList[player] = timestamp
			Spy.ActiveList[player] = timestamp
			Spy.InactiveList[player] = nil
		end

		if Spy.db.profile.CurrentList == 1 then
			Spy:RefreshCurrentList(player, source)
			Spy:UpdateActiveCount()			
		else
			if not source or source ~= Spy.CharacterName then
				Spy:AlertPlayer(player, source)
				if not source then Spy:AnnouncePlayer(player) end
			end
		end
	elseif not Spy.ActiveList[player] then
		if Spy.db.profile.ShowOnDetection and not Spy.db.profile.MainWindowVis then
			Spy:SetCurrentList(1)
			Spy:EnableSpy(true, true, true)
		end
		if Spy.db.profile.CurrentList ~= 1 and Spy.db.profile.MainWindowVis and Spy.db.profile.ShowNearbyList then
			Spy:SetCurrentList(1)
		end

		Spy.LastHourList[player] = timestamp
		Spy.ActiveList[player] = timestamp
		Spy.InactiveList[player] = nil

		if Spy.PlayerCommList[player] ~= nil then
			if Spy.db.profile.CurrentList == 1 then
				Spy:RefreshCurrentList(player, source)
			else
				if not source or source ~= Spy.CharacterName then
					Spy:AlertPlayer(player, source)
					if not source then Spy:AnnouncePlayer(player) end
				end
			end
		else
			if Spy.db.profile.CurrentList == 1 then
				Spy:RefreshCurrentList()
				Spy:UpdateActiveCount()						
			end
		end
	else
		Spy.ActiveList[player] = timestamp
		Spy.LastHourList[player] = timestamp
		if learnt and Spy.db.profile.CurrentList == 1 then
			Spy:RefreshCurrentList()
			Spy:UpdateActiveCount()	
		end
	end
end

function Spy:AppendUnitNames()
	for key, unit in pairs(SpyPerCharDB.PlayerData) do	
		-- find any units without a name
		if not unit.name then			
			local name = key
		-- if unit.name does not exist update info
			if (not unit.name) and name then
				unit.name = key
			end		
		end
    end
	Spy.db.profile.AppendUnitNameCheck=true --sets profile so it only runs once
end

function Spy:AppendUnitKoS()
	for kosName, value in pairs(SpyPerCharDB.KOSData) do	
		if kosName then	
			local playerData = SpyPerCharDB.PlayerData[kosName]
			if not playerData then 
				Spy:UpdatePlayerData(kosName, nil, nil, nil, nil, true, nil) 
				SpyPerCharDB.PlayerData[kosName].kos = 1 
				SpyPerCharDB.PlayerData[kosName].time = value			
			end		
		end
    end
	Spy.db.profile.AppendUnitKoSCheck=true --sets profile so it only runs once
end

Spy.ListTypes = {
	{L["Nearby"], Spy.ManageNearbyList, Spy.ManageNearbyListExpirations},
	{L["LastHour"], Spy.ManageLastHourList, Spy.ManageLastHourListExpirations},
	{L["Ignore"], Spy.ManageIgnoreList},
	{L["KillOnSight"], Spy.ManageKillOnSightList},
}

Spy_AbilityList = {

--++ Racial Traits ++	
	[20580]={ race = "Night Elf", level = 1, },
	[20572]={ race = "Orc", level = 1, },
	[7744]={ race = "Undead", level = 1, },
	[20594]={ race = "Dwarf", level = 1, },
	[20554]={ race = "Troll", level = 1, },
	[20573]={ race = "Orc", level = 1, },
	[20597]={ race = "Human", level = 1, },
	[20589]={ race = "Gnome", level = 1, },
	[26297]={ race = "Troll", level = 1, },
	[20598]={ race = "Human", level = 1, },
	[20591]={ race = "Gnome", level = 1, },
	[26296]={ race = "Troll", level = 1, },
	[20555]={ race = "Troll", level = 1, },
	[20600]={ race = "Human", level = 1, },
	[20550]={ race = "Tauren", level = 1, },
	[26290]={ race = "Troll", level = 1, },
	[20552]={ race = "Tauren", level = 1, },
	[20593]={ race = "Gnome", level = 1, },
	[20549]={ race = "Tauren", level = 1, },
	[20557]={ race = "Troll", level = 1, },
	[2481]={ race = "Dwarf", level = 1, },
	[20574]={ race = "Orc", level = 1, },
	[20577]={ race = "Undead", level = 1, },
	[20599]={ race = "Human", level = 1, },
	[20582]={ race = "Night Elf", level = 1, },
	[20558]={ race = "Troll", level = 1, },
	[20864]={ race = "Human", level = 1, },
	[20595]={ race = "Dwarf", level = 1, },
	[5227]={ race = "Undead", level = 1, },
	[20575]={ race = "Orc", level = 1, },
	[20583]={ race = "Night Elf", level = 1, },
	[20596]={ race = "Dwarf", level = 1, },
	[20579]={ race = "Undead", level = 1, },
	[20592]={ race = "Gnome", level = 1, },
	[20551]={ race = "Tauren", level = 1, },
	[20585]={ race = "Night Elf", level = 1, },

--++ Druid Abilities ++	
	[5185]={ class = "DRUID", level = 1, },
	[1126]={ class = "DRUID", level = 1, },
	[5176]={ class = "DRUID", level = 1, },
	[8921]={ class = "DRUID", level = 4, },
	[774]={ class = "DRUID", level = 4, },
	[22570]={ class = "DRUID", level = 6, },
	[467]={ class = "DRUID", level = 6, },
	[5177]={ class = "DRUID", level = 6, },
	[339]={ class = "DRUID", level = 8, },
	[5186]={ class = "DRUID", level = 8, },
	[5487]={ class = "DRUID", level = 10, },
	[99]={ class = "DRUID", level = 10, },
	[6795]={ class = "DRUID", level = 10, },
	[5232]={ class = "DRUID", level = 10, },
	[6807]={ class = "DRUID", level = 10, },
	[8924]={ class = "DRUID", level = 10, },
	[1058]={ class = "DRUID", level = 10, },
	[18960]={ class = "DRUID", level = 10, },
	[5229]={ class = "DRUID", level = 12, },
	[8936]={ class = "DRUID", level = 12, },
	[5211]={ class = "DRUID", level = 14, },
	[8946]={ class = "DRUID", level = 14, },
	[5187]={ class = "DRUID", level = 14, },
	[782]={ class = "DRUID", level = 14, },
	[5178]={ class = "DRUID", level = 14, },
	[1066]={ class = "DRUID", level = 16, },
	[8925]={ class = "DRUID", level = 16, },
	[1430]={ class = "DRUID", level = 16, },
	[779]={ class = "DRUID", level = 16, },
	[1062]={ class = "DRUID", level = 18, },
	[770]={ class = "DRUID", level = 18, },
	[2637]={ class = "DRUID", level = 18, },
	[6808]={ class = "DRUID", level = 18, },
	[16810]={ class = "DRUID", level = 18, },
	[8938]={ class = "DRUID", level = 18, },
	[768]={ class = "DRUID", level = 20, },
	[1082]={ class = "DRUID", level = 20, },
	[1735]={ class = "DRUID", level = 20, },
	[5188]={ class = "DRUID", level = 20, },
	[6756]={ class = "DRUID", level = 20, },
	[5215]={ class = "DRUID", level = 20, },
	[20484]={ class = "DRUID", level = 20, },
	[1079]={ class = "DRUID", level = 20, },
	[2912]={ class = "DRUID", level = 20, },
	[8926]={ class = "DRUID", level = 22, },
	[2090]={ class = "DRUID", level = 22, },
	[5221]={ class = "DRUID", level = 22, },
	[2908]={ class = "DRUID", level = 22, },
	[5179]={ class = "DRUID", level = 22, },
	[1822]={ class = "DRUID", level = 24, },
	[8939]={ class = "DRUID", level = 24, },
	[2782]={ class = "DRUID", level = 24, },
	[780]={ class = "DRUID", level = 24, },
	[1075]={ class = "DRUID", level = 24, },
	[5217]={ class = "DRUID", level = 24, },
	[2893]={ class = "DRUID", level = 26, },
	[1850]={ class = "DRUID", level = 26, },
	[5189]={ class = "DRUID", level = 26, },
	[6809]={ class = "DRUID", level = 26, },
	[8949]={ class = "DRUID", level = 26, },
	[5209]={ class = "DRUID", level = 28, },
	[3029]={ class = "DRUID", level = 28, },
	[8998]={ class = "DRUID", level = 28, },
	[5195]={ class = "DRUID", level = 28, },
	[8927]={ class = "DRUID", level = 28, },
	[16811]={ class = "DRUID", level = 28, },
	[2091]={ class = "DRUID", level = 28, },
	[9492]={ class = "DRUID", level = 28, },
	[6798]={ class = "DRUID", level = 30, },
	[778]={ class = "DRUID", level = 30, },
	[17390]={ class = "DRUID", level = 30, },
	[24974]={ class = "DRUID", level = 30, },
	[5234]={ class = "DRUID", level = 30, },
	[20739]={ class = "DRUID", level = 30, },
	[8940]={ class = "DRUID", level = 30, },
	[6800]={ class = "DRUID", level = 30, },
	[740]={ class = "DRUID", level = 30, },
	[783]={ class = "DRUID", level = 30, },
	[5180]={ class = "DRUID", level = 30, },
	[9490]={ class = "DRUID", level = 32, },
	[22568]={ class = "DRUID", level = 32, },
	[6778]={ class = "DRUID", level = 32, },
	[6785]={ class = "DRUID", level = 32, },
	[5225]={ class = "DRUID", level = 32, },
	[8972]={ class = "DRUID", level = 34, },
	[8928]={ class = "DRUID", level = 34, },
	[1823]={ class = "DRUID", level = 34, },
	[3627]={ class = "DRUID", level = 34, },
	[8950]={ class = "DRUID", level = 34, },
	[769]={ class = "DRUID", level = 34, },
	[8914]={ class = "DRUID", level = 34, },
	[22842]={ class = "DRUID", level = 36, },
	[9005]={ class = "DRUID", level = 36, },
	[8941]={ class = "DRUID", level = 36, },
	[9493]={ class = "DRUID", level = 36, },
	[6793]={ class = "DRUID", level = 36, },
	[5201]={ class = "DRUID", level = 38, },
	[5196]={ class = "DRUID", level = 38, },
	[8903]={ class = "DRUID", level = 38, },
	[18657]={ class = "DRUID", level = 38, },
	[16812]={ class = "DRUID", level = 38, },
	[8992]={ class = "DRUID", level = 38, },
	[8955]={ class = "DRUID", level = 38, },
	[6780]={ class = "DRUID", level = 38, },
	[9000]={ class = "DRUID", level = 40, },
	[9634]={ class = "DRUID", level = 40, },
	[22827]={ class = "DRUID", level = 40, },
	[29166]={ class = "DRUID", level = 40, },
	[24975]={ class = "DRUID", level = 40, },
	[8907]={ class = "DRUID", level = 40, },
	[8929]={ class = "DRUID", level = 40, },
	[6783]={ class = "DRUID", level = 40, },
	[20742]={ class = "DRUID", level = 40, },
	[8910]={ class = "DRUID", level = 40, },
	[8918]={ class = "DRUID", level = 40, },
	[9747]={ class = "DRUID", level = 42, },
	[9749]={ class = "DRUID", level = 42, },
	[17391]={ class = "DRUID", level = 42, },
	[9745]={ class = "DRUID", level = 42, },
	[6787]={ class = "DRUID", level = 42, },
	[9750]={ class = "DRUID", level = 42, },
	[8951]={ class = "DRUID", level = 42, },
	[22812]={ class = "DRUID", level = 44, },
	[22839]={ class = "DRUID", level = 44, },
	[9758]={ class = "DRUID", level = 44, },
	[1824]={ class = "DRUID", level = 44, },
	[9752]={ class = "DRUID", level = 44, },
	[9754]={ class = "DRUID", level = 44, },
	[9756]={ class = "DRUID", level = 44, },
	[8983]={ class = "DRUID", level = 46, },
	[9821]={ class = "DRUID", level = 46, },
	[22895]={ class = "DRUID", level = 46, },
	[9833]={ class = "DRUID", level = 46, },
	[9823]={ class = "DRUID", level = 46, },
	[9839]={ class = "DRUID", level = 46, },
	[9829]={ class = "DRUID", level = 46, },
	[8905]={ class = "DRUID", level = 46, },
	[9849]={ class = "DRUID", level = 48, },
	[9852]={ class = "DRUID", level = 48, },
	[22828]={ class = "DRUID", level = 48, },
	[16813]={ class = "DRUID", level = 48, },
	[9856]={ class = "DRUID", level = 48, },
	[9845]={ class = "DRUID", level = 48, },
	[21849]={ class = "DRUID", level = 50, },
	[9888]={ class = "DRUID", level = 50, },
	[17401]={ class = "DRUID", level = 50, },
	[24976]={ class = "DRUID", level = 50, },
	[9884]={ class = "DRUID", level = 50, },
	[9880]={ class = "DRUID", level = 50, },
	[9866]={ class = "DRUID", level = 50, },
	[20747]={ class = "DRUID", level = 50, },
	[9875]={ class = "DRUID", level = 50, },
	[9862]={ class = "DRUID", level = 50, },
	[9892]={ class = "DRUID", level = 52, },
	[9898]={ class = "DRUID", level = 52, },
	[9834]={ class = "DRUID", level = 52, },
	[9840]={ class = "DRUID", level = 52, },
	[9894]={ class = "DRUID", level = 52, },
	[9907]={ class = "DRUID", level = 54, },
	[17392]={ class = "DRUID", level = 54, },
	[9904]={ class = "DRUID", level = 54, },
	[9857]={ class = "DRUID", level = 54, },
	[9830]={ class = "DRUID", level = 54, },
	[9901]={ class = "DRUID", level = 54, },
	[9908]={ class = "DRUID", level = 54, },
	[9910]={ class = "DRUID", level = 54, },
	[9912]={ class = "DRUID", level = 54, },
	[22829]={ class = "DRUID", level = 56, },
	[22896]={ class = "DRUID", level = 56, },
	[9889]={ class = "DRUID", level = 56, },
	[9827]={ class = "DRUID", level = 56, },
	[9850]={ class = "DRUID", level = 58, },
	[9853]={ class = "DRUID", level = 58, },
	[18658]={ class = "DRUID", level = 58, },
	[9881]={ class = "DRUID", level = 58, },
	[9835]={ class = "DRUID", level = 58, },
	[17329]={ class = "DRUID", level = 58, },
	[9867]={ class = "DRUID", level = 58, },
	[9841]={ class = "DRUID", level = 58, },
	[9876]={ class = "DRUID", level = 58, },
	[31018]={ class = "DRUID", level = 60, },
	[21850]={ class = "DRUID", level = 60, },
	[25297]={ class = "DRUID", level = 60, },
	[17402]={ class = "DRUID", level = 60, },
	[24977]={ class = "DRUID", level = 60, },
	[9885]={ class = "DRUID", level = 60, },
	[9913]={ class = "DRUID", level = 60, },
	[20748]={ class = "DRUID", level = 60, },
	[9858]={ class = "DRUID", level = 60, },
	[25299]={ class = "DRUID", level = 60, },
	[9896]={ class = "DRUID", level = 60, },
	[25298]={ class = "DRUID", level = 60, },
	[9846]={ class = "DRUID", level = 60, },
	[9863]={ class = "DRUID", level = 60, },
--++ Druid Talents ++	
	[16689]={ class = "DRUID", level = 10, },
	[16979]={ class = "DRUID", level = 20, },
	[5570]={ class = "DRUID", level = 20, },
	[16864]={ class = "DRUID", level = 20, },
	[16857]={ class = "DRUID", level = 30, },
	[17116]={ class = "DRUID", level = 30, },
	[24858]={ class = "DRUID", level = 40, },
	[18562]={ class = "DRUID", level = 40, },
--++ Hunter Abilities ++	
	[23989]={ class = "HUNTER", level = 1, },
	[75]={ class = "HUNTER", level = 1, },
	[2973]={ class = "HUNTER", level = 1, },
	[1494]={ class = "HUNTER", level = 1, },
	[13163]={ class = "HUNTER", level = 4, },
	[1978]={ class = "HUNTER", level = 4, },
	[3044]={ class = "HUNTER", level = 6, },
	[1130]={ class = "HUNTER", level = 6, },
	[5116]={ class = "HUNTER", level = 8, },
	[14260]={ class = "HUNTER", level = 8, },
	[13165]={ class = "HUNTER", level = 10, },
	[883]={ class = "HUNTER", level = 10, },
	[2641]={ class = "HUNTER", level = 10, },
	[6991]={ class = "HUNTER", level = 10, },
	[982]={ class = "HUNTER", level = 10, },
	[13549]={ class = "HUNTER", level = 10, },
	[1515]={ class = "HUNTER", level = 10, },
	[19883]={ class = "HUNTER", level = 10, },
	[14281]={ class = "HUNTER", level = 12, },
	[20736]={ class = "HUNTER", level = 12, },
	[136]={ class = "HUNTER", level = 12, },
	[2974]={ class = "HUNTER", level = 12, },
	[6197]={ class = "HUNTER", level = 14, },
	[1002]={ class = "HUNTER", level = 14, },
	[1513]={ class = "HUNTER", level = 14, },
	[13795]={ class = "HUNTER", level = 16, },
	[1495]={ class = "HUNTER", level = 16, },
	[14261]={ class = "HUNTER", level = 16, },
	[14318]={ class = "HUNTER", level = 18, },
	[2643]={ class = "HUNTER", level = 18, },
	[13550]={ class = "HUNTER", level = 18, },
	[19884]={ class = "HUNTER", level = 18, },
	[14282]={ class = "HUNTER", level = 20, },
	[5118]={ class = "HUNTER", level = 20, },
	[781]={ class = "HUNTER", level = 20, },
	[14274]={ class = "HUNTER", level = 20, },
	[1499]={ class = "HUNTER", level = 20, },
	[3111]={ class = "HUNTER", level = 20, },
	[14323]={ class = "HUNTER", level = 22, },
	[3043]={ class = "HUNTER", level = 22, },
	[1462]={ class = "HUNTER", level = 24, },
	[14262]={ class = "HUNTER", level = 24, },
	[19885]={ class = "HUNTER", level = 24, },
	[14302]={ class = "HUNTER", level = 26, },
	[3045]={ class = "HUNTER", level = 26, },
	[13551]={ class = "HUNTER", level = 26, },
	[19880]={ class = "HUNTER", level = 26, },
	[20900]={ class = "HUNTER", level = 28, },
	[14283]={ class = "HUNTER", level = 28, },
	[14319]={ class = "HUNTER", level = 28, },
	[13809]={ class = "HUNTER", level = 28, },
	[3661]={ class = "HUNTER", level = 28, },
	[13161]={ class = "HUNTER", level = 30, },
	[15629]={ class = "HUNTER", level = 30, },
	[5384]={ class = "HUNTER", level = 30, },
	[14269]={ class = "HUNTER", level = 30, },
	[14288]={ class = "HUNTER", level = 30, },
	[14326]={ class = "HUNTER", level = 30, },
	[1543]={ class = "HUNTER", level = 32, },
	[14263]={ class = "HUNTER", level = 32, },
	[14275]={ class = "HUNTER", level = 32, },
	[19878]={ class = "HUNTER", level = 32, },
	[14272]={ class = "HUNTER", level = 34, },
	[13813]={ class = "HUNTER", level = 34, },
	[13552]={ class = "HUNTER", level = 34, },
	[20901]={ class = "HUNTER", level = 36, },
	[14284]={ class = "HUNTER", level = 36, },
	[14303]={ class = "HUNTER", level = 36, },
	[3662]={ class = "HUNTER", level = 36, },
	[3034]={ class = "HUNTER", level = 36, },
	[14320]={ class = "HUNTER", level = 38, },
	[14267]={ class = "HUNTER", level = 38, },
	[13159]={ class = "HUNTER", level = 40, },
	[15630]={ class = "HUNTER", level = 40, },
	[14310]={ class = "HUNTER", level = 40, },
	[14324]={ class = "HUNTER", level = 40, },
	[14264]={ class = "HUNTER", level = 40, },
	[19882]={ class = "HUNTER", level = 40, },
	[1510]={ class = "HUNTER", level = 40, },
	[20909]={ class = "HUNTER", level = 42, },
	[14289]={ class = "HUNTER", level = 42, },
	[14276]={ class = "HUNTER", level = 42, },
	[13553]={ class = "HUNTER", level = 42, },
	[20902]={ class = "HUNTER", level = 44, },
	[14285]={ class = "HUNTER", level = 44, },
	[14316]={ class = "HUNTER", level = 44, },
	[13542]={ class = "HUNTER", level = 44, },
	[14270]={ class = "HUNTER", level = 44, },
	[20043]={ class = "HUNTER", level = 46, },
	[14304]={ class = "HUNTER", level = 46, },
	[14327]={ class = "HUNTER", level = 46, },
	[14279]={ class = "HUNTER", level = 46, },
	[14321]={ class = "HUNTER", level = 48, },
	[14273]={ class = "HUNTER", level = 48, },
	[14265]={ class = "HUNTER", level = 48, },
	[3674]={ class = "HUNTER", level = 50, },
	[15631]={ class = "HUNTER", level = 50, },
	[13554]={ class = "HUNTER", level = 50, },
	[19879]={ class = "HUNTER", level = 50, },
	[14294]={ class = "HUNTER", level = 50, },
	[24132]={ class = "HUNTER", level = 50, },
	[20903]={ class = "HUNTER", level = 52, },
	[14286]={ class = "HUNTER", level = 52, },
	[13543]={ class = "HUNTER", level = 52, },
	[14277]={ class = "HUNTER", level = 52, },
	[20910]={ class = "HUNTER", level = 54, },
	[14317]={ class = "HUNTER", level = 54, },
	[14290]={ class = "HUNTER", level = 54, },
	[20190]={ class = "HUNTER", level = 56, },
	[14305]={ class = "HUNTER", level = 56, },
	[14266]={ class = "HUNTER", level = 56, },
	[14280]={ class = "HUNTER", level = 56, },
	[14322]={ class = "HUNTER", level = 58, },
	[14325]={ class = "HUNTER", level = 58, },
	[14271]={ class = "HUNTER", level = 58, },
	[13555]={ class = "HUNTER", level = 58, },
	[14295]={ class = "HUNTER", level = 58, },
	[20904]={ class = "HUNTER", level = 60, },
	[14287]={ class = "HUNTER", level = 60, },
	[25296]={ class = "HUNTER", level = 60, },
	[15632]={ class = "HUNTER", level = 60, },
	[14311]={ class = "HUNTER", level = 60, },
	[13544]={ class = "HUNTER", level = 60, },
	[25294]={ class = "HUNTER", level = 60, },
	[25295]={ class = "HUNTER", level = 60, },
	[19801]={ class = "HUNTER", level = 60, },
	[14268]={ class = "HUNTER", level = 60, },
	[24133]={ class = "HUNTER", level = 60, },
--++ Hunter Talents ++	
	[19434]={ class = "HUNTER", level = 20, },
	[19263]={ class = "HUNTER", level = 20, },
	[19306]={ class = "HUNTER", level = 30, },
	[19577]={ class = "HUNTER", level = 30, },
	[19503]={ class = "HUNTER", level = 30, },
	[19574]={ class = "HUNTER", level = 40, },
	[19506]={ class = "HUNTER", level = 40, },
	[19386]={ class = "HUNTER", level = 40, },
--++ Mage Abilities ++	
	[1459]={ class = "MAGE", level = 1, },
	[133]={ class = "MAGE", level = 1, },
	[168]={ class = "MAGE", level = 1, },
	[116]={ class = "MAGE", level = 4, },
	[5504]={ class = "MAGE", level = 4, },
	[2136]={ class = "MAGE", level = 6, },
	[143]={ class = "MAGE", level = 6, },
	[587]={ class = "MAGE", level = 6, },
	[5143]={ class = "MAGE", level = 8, },
	[205]={ class = "MAGE", level = 8, },
	[118]={ class = "MAGE", level = 8, },
	[7300]={ class = "MAGE", level = 10, },
	[122]={ class = "MAGE", level = 10, },
	[5505]={ class = "MAGE", level = 10, },
	[604]={ class = "MAGE", level = 12, },
	[145]={ class = "MAGE", level = 12, },
	[130]={ class = "MAGE", level = 12, },
	[597]={ class = "MAGE", level = 12, },
	[1449]={ class = "MAGE", level = 14, },
	[1460]={ class = "MAGE", level = 14, },
	[2137]={ class = "MAGE", level = 14, },
	[837]={ class = "MAGE", level = 14, },
	[5144]={ class = "MAGE", level = 16, },
	[2855]={ class = "MAGE", level = 16, },
	[2120]={ class = "MAGE", level = 16, },
	[1008]={ class = "MAGE", level = 18, },
	[3140]={ class = "MAGE", level = 18, },
	[475]={ class = "MAGE", level = 18, },
	[1953]={ class = "MAGE", level = 20, },
	[10]={ class = "MAGE", level = 20, },
	[12051]={ class = "MAGE", level = 20, },
	[543]={ class = "MAGE", level = 20, },
	[7301]={ class = "MAGE", level = 20, },
	[7322]={ class = "MAGE", level = 20, },
	[1463]={ class = "MAGE", level = 20, },
	[12824]={ class = "MAGE", level = 20, },
	[3562]={ class = "MAGE", level = 20, },
	[3567]={ class = "MAGE", level = 20, },
	[3561]={ class = "MAGE", level = 20, },
	[3563]={ class = "MAGE", level = 20, },
	[5506]={ class = "MAGE", level = 20, },
	[8437]={ class = "MAGE", level = 22, },
	[2138]={ class = "MAGE", level = 22, },
	[6143]={ class = "MAGE", level = 22, },
	[2948]={ class = "MAGE", level = 22, },
	[990]={ class = "MAGE", level = 22, },
	[5145]={ class = "MAGE", level = 24, },
	[2139]={ class = "MAGE", level = 24, },
	[8450]={ class = "MAGE", level = 24, },
	[8400]={ class = "MAGE", level = 24, },
	[2121]={ class = "MAGE", level = 24, },
	[12505]={ class = "MAGE", level = 24, },
	[120]={ class = "MAGE", level = 26, },
	[865]={ class = "MAGE", level = 26, },
	[8406]={ class = "MAGE", level = 26, },
	[1461]={ class = "MAGE", level = 28, },
	[6141]={ class = "MAGE", level = 28, },
	[8494]={ class = "MAGE", level = 28, },
	[8444]={ class = "MAGE", level = 28, },
	[759]={ class = "MAGE", level = 28, },
	[8455]={ class = "MAGE", level = 30, },
	[8438]={ class = "MAGE", level = 30, },
	[8412]={ class = "MAGE", level = 30, },
	[8457]={ class = "MAGE", level = 30, },
	[8401]={ class = "MAGE", level = 30, },
	[7302]={ class = "MAGE", level = 30, },
	[12522]={ class = "MAGE", level = 30, },
	[3565]={ class = "MAGE", level = 30, },
	[3566]={ class = "MAGE", level = 30, },
	[6127]={ class = "MAGE", level = 30, },
	[8416]={ class = "MAGE", level = 32, },
	[8422]={ class = "MAGE", level = 32, },
	[8461]={ class = "MAGE", level = 32, },
	[8407]={ class = "MAGE", level = 32, },
	[6129]={ class = "MAGE", level = 32, },
	[8492]={ class = "MAGE", level = 34, },
	[6117]={ class = "MAGE", level = 34, },
	[8445]={ class = "MAGE", level = 34, },
	[13018]={ class = "MAGE", level = 36, },
	[8427]={ class = "MAGE", level = 36, },
	[8451]={ class = "MAGE", level = 36, },
	[8402]={ class = "MAGE", level = 36, },
	[8495]={ class = "MAGE", level = 36, },
	[12523]={ class = "MAGE", level = 36, },
	[8439]={ class = "MAGE", level = 38, },
	[8413]={ class = "MAGE", level = 38, },
	[8408]={ class = "MAGE", level = 38, },
	[3552]={ class = "MAGE", level = 38, },
	[8417]={ class = "MAGE", level = 40, },
	[8458]={ class = "MAGE", level = 40, },
	[8423]={ class = "MAGE", level = 40, },
	[6131]={ class = "MAGE", level = 40, },
	[7320]={ class = "MAGE", level = 40, },
	[12825]={ class = "MAGE", level = 40, },
	[11416]={ class = "MAGE", level = 40, },
	[11417]={ class = "MAGE", level = 40, },
	[10059]={ class = "MAGE", level = 40, },
	[11418]={ class = "MAGE", level = 40, },
	[8446]={ class = "MAGE", level = 40, },
	[10138]={ class = "MAGE", level = 40, },
	[10169]={ class = "MAGE", level = 42, },
	[10156]={ class = "MAGE", level = 42, },
	[10159]={ class = "MAGE", level = 42, },
	[10148]={ class = "MAGE", level = 42, },
	[8462]={ class = "MAGE", level = 42, },
	[12524]={ class = "MAGE", level = 42, },
	[10144]={ class = "MAGE", level = 42, },
	[13019]={ class = "MAGE", level = 44, },
	[10185]={ class = "MAGE", level = 44, },
	[10179]={ class = "MAGE", level = 44, },
	[10191]={ class = "MAGE", level = 44, },
	[10201]={ class = "MAGE", level = 46, },
	[10197]={ class = "MAGE", level = 46, },
	[13031]={ class = "MAGE", level = 46, },
	[22782]={ class = "MAGE", level = 46, },
	[10205]={ class = "MAGE", level = 46, },
	[10211]={ class = "MAGE", level = 48, },
	[10173]={ class = "MAGE", level = 48, },
	[10149]={ class = "MAGE", level = 48, },
	[10215]={ class = "MAGE", level = 48, },
	[12525]={ class = "MAGE", level = 48, },
	[10053]={ class = "MAGE", level = 48, },
	[10160]={ class = "MAGE", level = 50, },
	[10223]={ class = "MAGE", level = 50, },
	[10180]={ class = "MAGE", level = 50, },
	[10219]={ class = "MAGE", level = 50, },
	[11419]={ class = "MAGE", level = 50, },
	[11420]={ class = "MAGE", level = 50, },
	[10139]={ class = "MAGE", level = 50, },
	[13020]={ class = "MAGE", level = 52, },
	[10186]={ class = "MAGE", level = 52, },
	[10177]={ class = "MAGE", level = 52, },
	[13032]={ class = "MAGE", level = 52, },
	[10192]={ class = "MAGE", level = 52, },
	[10206]={ class = "MAGE", level = 52, },
	[10145]={ class = "MAGE", level = 52, },
	[10170]={ class = "MAGE", level = 54, },
	[10202]={ class = "MAGE", level = 54, },
	[10199]={ class = "MAGE", level = 54, },
	[10150]={ class = "MAGE", level = 54, },
	[10230]={ class = "MAGE", level = 54, },
	[12526]={ class = "MAGE", level = 54, },
	[23028]={ class = "MAGE", level = 56, },
	[10157]={ class = "MAGE", level = 56, },
	[10212]={ class = "MAGE", level = 56, },
	[25345]={ class = "MAGE", level = 56, },
	[10216]={ class = "MAGE", level = 56, },
	[10181]={ class = "MAGE", level = 56, },
	[10161]={ class = "MAGE", level = 58, },
	[13033]={ class = "MAGE", level = 58, },
	[22783]={ class = "MAGE", level = 58, },
	[10207]={ class = "MAGE", level = 58, },
	[10054]={ class = "MAGE", level = 58, },
	[13021]={ class = "MAGE", level = 60, },
	[10187]={ class = "MAGE", level = 60, },
	[10174]={ class = "MAGE", level = 60, },
	[10225]={ class = "MAGE", level = 60, },
	[10151]={ class = "MAGE", level = 60, },
	[25306]={ class = "MAGE", level = 60, },
	[28609]={ class = "MAGE", level = 60, },
	[25304]={ class = "MAGE", level = 60, },
	[10220]={ class = "MAGE", level = 60, },
	[10193]={ class = "MAGE", level = 60, },
	[12826]={ class = "MAGE", level = 60, },
	[28270]={ class = "MAGE", level = 60, },
	[28272]={ class = "MAGE", level = 60, },
	[28271]={ class = "MAGE", level = 60, },
	[18809]={ class = "MAGE", level = 60, },
	[28612]={ class = "MAGE", level = 60, },
	[10140]={ class = "MAGE", level = 60, },
--++ Mage Talents ++	
	[12472]={ class = "MAGE", level = 20, },
	[11366]={ class = "MAGE", level = 20, },
	[11113]={ class = "MAGE", level = 30, },
	[11958]={ class = "MAGE", level = 30, },
	[12043]={ class = "MAGE", level = 30, },
	[12042]={ class = "MAGE", level = 40, },
	[11129]={ class = "MAGE", level = 40, },
	[11426]={ class = "MAGE", level = 40, },
--++ Paladin Abilities ++	
	[465]={ class = "PALADIN", level = 1, },
	[635]={ class = "PALADIN", level = 1, },
	[20154]={ class = "PALADIN", level = 1, },
	[21084]={ class = "PALADIN", level = 1, },
	[19740]={ class = "PALADIN", level = 4, },
	[20271]={ class = "PALADIN", level = 4, },
	[498]={ class = "PALADIN", level = 6, },
	[639]={ class = "PALADIN", level = 6, },
	[21082]={ class = "PALADIN", level = 6, },
	[853]={ class = "PALADIN", level = 8, },
	[1152]={ class = "PALADIN", level = 8, },
	[1022]={ class = "PALADIN", level = 10, },
	[10290]={ class = "PALADIN", level = 10, },
	[633]={ class = "PALADIN", level = 10, },
	[20287]={ class = "PALADIN", level = 10, },
	[19834]={ class = "PALADIN", level = 12, },
	[7328]={ class = "PALADIN", level = 12, },
	[20162]={ class = "PALADIN", level = 12, },
	[19742]={ class = "PALADIN", level = 14, },
	[647]={ class = "PALADIN", level = 14, },
	[7294]={ class = "PALADIN", level = 16, },
	[25780]={ class = "PALADIN", level = 16, },
	[1044]={ class = "PALADIN", level = 18, },
	[5573]={ class = "PALADIN", level = 18, },
	[20288]={ class = "PALADIN", level = 18, },
	[643]={ class = "PALADIN", level = 20, },
	[879]={ class = "PALADIN", level = 20, },
	[19750]={ class = "PALADIN", level = 20, },
	[5502]={ class = "PALADIN", level = 20, },
	[19835]={ class = "PALADIN", level = 22, },
	[19746]={ class = "PALADIN", level = 22, },
	[1026]={ class = "PALADIN", level = 22, },
	[20164]={ class = "PALADIN", level = 22, },
	[20305]={ class = "PALADIN", level = 22, },
	[5599]={ class = "PALADIN", level = 24, },
	[19850]={ class = "PALADIN", level = 24, },
	[5588]={ class = "PALADIN", level = 24, },
	[10322]={ class = "PALADIN", level = 24, },
	[2878]={ class = "PALADIN", level = 24, },
	[1038]={ class = "PALADIN", level = 26, },
	[19939]={ class = "PALADIN", level = 26, },
	[10298]={ class = "PALADIN", level = 26, },
	[20289]={ class = "PALADIN", level = 26, },
	[5614]={ class = "PALADIN", level = 28, },
	[19876]={ class = "PALADIN", level = 28, },
	[20116]={ class = "PALADIN", level = 30, },
	[10291]={ class = "PALADIN", level = 30, },
	[19752]={ class = "PALADIN", level = 30, },
	[1042]={ class = "PALADIN", level = 30, },
	[2800]={ class = "PALADIN", level = 30, },
	[20915]={ class = "PALADIN", level = 30, },
	[20165]={ class = "PALADIN", level = 30, },
	[19836]={ class = "PALADIN", level = 32, },
	[19888]={ class = "PALADIN", level = 32, },
	[20306]={ class = "PALADIN", level = 32, },
	[19852]={ class = "PALADIN", level = 34, },
	[642]={ class = "PALADIN", level = 34, },
	[19940]={ class = "PALADIN", level = 34, },
	[20290]={ class = "PALADIN", level = 34, },
	[5615]={ class = "PALADIN", level = 36, },
	[19891]={ class = "PALADIN", level = 36, },
	[10324]={ class = "PALADIN", level = 36, },
	[10299]={ class = "PALADIN", level = 36, },
	[10278]={ class = "PALADIN", level = 38, },
	[3472]={ class = "PALADIN", level = 38, },
	[20166]={ class = "PALADIN", level = 38, },
	[5627]={ class = "PALADIN", level = 38, },
	[19977]={ class = "PALADIN", level = 40, },
	[20912]={ class = "PALADIN", level = 40, },
	[20922]={ class = "PALADIN", level = 40, },
	[1032]={ class = "PALADIN", level = 40, },
	[5589]={ class = "PALADIN", level = 40, },
	[20918]={ class = "PALADIN", level = 40, },
	[20347]={ class = "PALADIN", level = 40, },
	[19895]={ class = "PALADIN", level = 40, },
	[13819]={ class = "PALADIN", level = 40, },
	[19837]={ class = "PALADIN", level = 42, },
	[4987]={ class = "PALADIN", level = 42, },
	[19941]={ class = "PALADIN", level = 42, },
	[20291]={ class = "PALADIN", level = 42, },
	[20307]={ class = "PALADIN", level = 42, },
	[19853]={ class = "PALADIN", level = 44, },
	[10312]={ class = "PALADIN", level = 44, },
	[19897]={ class = "PALADIN", level = 44, },
	[24275]={ class = "PALADIN", level = 44, },
	[6940]={ class = "PALADIN", level = 46, },
	[10328]={ class = "PALADIN", level = 46, },
	[10300]={ class = "PALADIN", level = 46, },
	[19899]={ class = "PALADIN", level = 48, },
	[20929]={ class = "PALADIN", level = 48, },
	[20772]={ class = "PALADIN", level = 48, },
	[20356]={ class = "PALADIN", level = 48, },
	[19978]={ class = "PALADIN", level = 50, },
	[20913]={ class = "PALADIN", level = 50, },
	[20923]={ class = "PALADIN", level = 50, },
	[10292]={ class = "PALADIN", level = 50, },
	[1020]={ class = "PALADIN", level = 50, },
	[19942]={ class = "PALADIN", level = 50, },
	[20927]={ class = "PALADIN", level = 50, },
	[2812]={ class = "PALADIN", level = 50, },
	[10310]={ class = "PALADIN", level = 50, },
	[20919]={ class = "PALADIN", level = 50, },
	[20348]={ class = "PALADIN", level = 50, },
	[20292]={ class = "PALADIN", level = 50, },
	[19838]={ class = "PALADIN", level = 52, },
	[10313]={ class = "PALADIN", level = 52, },
	[25782]={ class = "PALADIN", level = 52, },
	[24274]={ class = "PALADIN", level = 52, },
	[20308]={ class = "PALADIN", level = 52, },
	[19896]={ class = "PALADIN", level = 52, },
	[10326]={ class = "PALADIN", level = 52, },
	[20729]={ class = "PALADIN", level = 54, },
	[19854]={ class = "PALADIN", level = 54, },
	[25894]={ class = "PALADIN", level = 54, },
	[10308]={ class = "PALADIN", level = 54, },
	[10329]={ class = "PALADIN", level = 54, },
	[19898]={ class = "PALADIN", level = 56, },
	[20930]={ class = "PALADIN", level = 56, },
	[10301]={ class = "PALADIN", level = 56, },
	[19943]={ class = "PALADIN", level = 58, },
	[20293]={ class = "PALADIN", level = 58, },
	[20357]={ class = "PALADIN", level = 58, },
	[19979]={ class = "PALADIN", level = 60, },
	[25291]={ class = "PALADIN", level = 60, },
	[20914]={ class = "PALADIN", level = 60, },
	[25290]={ class = "PALADIN", level = 60, },
	[20924]={ class = "PALADIN", level = 60, },
	[10293]={ class = "PALADIN", level = 60, },
	[10314]={ class = "PALADIN", level = 60, },
	[19900]={ class = "PALADIN", level = 60, },
	[25898]={ class = "PALADIN", level = 60, },
	[25890]={ class = "PALADIN", level = 60, },
	[25916]={ class = "PALADIN", level = 60, },
	[25895]={ class = "PALADIN", level = 60, },
	[25899]={ class = "PALADIN", level = 60, },
	[25918]={ class = "PALADIN", level = 60, },
	[24239]={ class = "PALADIN", level = 60, },
	[25292]={ class = "PALADIN", level = 60, },
	[20928]={ class = "PALADIN", level = 60, },
	[10318]={ class = "PALADIN", level = 60, },
	[20773]={ class = "PALADIN", level = 60, },
	[20920]={ class = "PALADIN", level = 60, },
	[20349]={ class = "PALADIN", level = 60, },
	[23214]={ class = "PALADIN", level = 60, },
--++ Paladin Talents ++	
	[20217]={ class = "PALADIN", level = 20, },
	[26573]={ class = "PALADIN", level = 20, },
	[20375]={ class = "PALADIN", level = 20, },
	[20911]={ class = "PALADIN", level = 30, },
	[20216]={ class = "PALADIN", level = 30, },
	[20218]={ class = "PALADIN", level = 30, },
	[20925]={ class = "PALADIN", level = 40, },
	[20473]={ class = "PALADIN", level = 40, },
	[20066]={ class = "PALADIN", level = 40, },
--++ Priest Abilities ++	
	[2050]={ class = "PRIEST", level = 1, },
	[1243]={ class = "PRIEST", level = 1, },
	[585]={ class = "PRIEST", level = 1, },
	[2052]={ class = "PRIEST", level = 4, },
	[589]={ class = "PRIEST", level = 4, },
	[17]={ class = "PRIEST", level = 6, },
	[591]={ class = "PRIEST", level = 6, },
	[586]={ class = "PRIEST", level = 8, },
	[139]={ class = "PRIEST", level = 8, },
	[13908]={ class = "PRIEST", level = 10, },
	[9035]={ class = "PRIEST", level = 10, },
	[2053]={ class = "PRIEST", level = 10, },
	[8092]={ class = "PRIEST", level = 10, },
	[2006]={ class = "PRIEST", level = 10, },
	[594]={ class = "PRIEST", level = 10, },
	[10797]={ class = "PRIEST", level = 10, },
	[2652]={ class = "PRIEST", level = 10, },
	[588]={ class = "PRIEST", level = 12, },
	[1244]={ class = "PRIEST", level = 12, },
	[592]={ class = "PRIEST", level = 12, },
	[528]={ class = "PRIEST", level = 14, },
	[8122]={ class = "PRIEST", level = 14, },
	[6074]={ class = "PRIEST", level = 14, },
	[598]={ class = "PRIEST", level = 14, },
	[2054]={ class = "PRIEST", level = 16, },
	[8102]={ class = "PRIEST", level = 16, },
	[19236]={ class = "PRIEST", level = 18, },
	[527]={ class = "PRIEST", level = 18, },
	[600]={ class = "PRIEST", level = 18, },
	[970]={ class = "PRIEST", level = 18, },
	[19296]={ class = "PRIEST", level = 18, },
	[2944]={ class = "PRIEST", level = 20, },
	[2651]={ class = "PRIEST", level = 20, },
	[9578]={ class = "PRIEST", level = 20, },
	[6346]={ class = "PRIEST", level = 20, },
	[13896]={ class = "PRIEST", level = 20, },
	[2061]={ class = "PRIEST", level = 20, },
	[19281]={ class = "PRIEST", level = 20, },
	[14914]={ class = "PRIEST", level = 20, },
	[7128]={ class = "PRIEST", level = 20, },
	[453]={ class = "PRIEST", level = 20, },
	[6075]={ class = "PRIEST", level = 20, },
	[9484]={ class = "PRIEST", level = 20, },
	[18137]={ class = "PRIEST", level = 20, },
	[19261]={ class = "PRIEST", level = 20, },
	[2055]={ class = "PRIEST", level = 22, },
	[8103]={ class = "PRIEST", level = 22, },
	[2096]={ class = "PRIEST", level = 22, },
	[2010]={ class = "PRIEST", level = 22, },
	[984]={ class = "PRIEST", level = 22, },
	[15262]={ class = "PRIEST", level = 24, },
	[8129]={ class = "PRIEST", level = 24, },
	[1245]={ class = "PRIEST", level = 24, },
	[3747]={ class = "PRIEST", level = 24, },
	[19238]={ class = "PRIEST", level = 26, },
	[9472]={ class = "PRIEST", level = 26, },
	[6076]={ class = "PRIEST", level = 26, },
	[992]={ class = "PRIEST", level = 26, },
	[19299]={ class = "PRIEST", level = 26, },
	[19276]={ class = "PRIEST", level = 28, },
	[6063]={ class = "PRIEST", level = 28, },
	[15430]={ class = "PRIEST", level = 28, },
	[8104]={ class = "PRIEST", level = 28, },
	[17311]={ class = "PRIEST", level = 28, },
	[8124]={ class = "PRIEST", level = 28, },
	[19308]={ class = "PRIEST", level = 28, },
	[19289]={ class = "PRIEST", level = 30, },
	[9579]={ class = "PRIEST", level = 30, },
	[19271]={ class = "PRIEST", level = 30, },
	[19282]={ class = "PRIEST", level = 30, },
	[15263]={ class = "PRIEST", level = 30, },
	[602]={ class = "PRIEST", level = 30, },
	[605]={ class = "PRIEST", level = 30, },
	[6065]={ class = "PRIEST", level = 30, },
	[596]={ class = "PRIEST", level = 30, },
	[976]={ class = "PRIEST", level = 30, },
	[1004]={ class = "PRIEST", level = 30, },
	[19262]={ class = "PRIEST", level = 30, },
	[552]={ class = "PRIEST", level = 32, },
	[9473]={ class = "PRIEST", level = 32, },
	[8131]={ class = "PRIEST", level = 32, },
	[6077]={ class = "PRIEST", level = 32, },
	[19240]={ class = "PRIEST", level = 34, },
	[6064]={ class = "PRIEST", level = 34, },
	[1706]={ class = "PRIEST", level = 34, },
	[8105]={ class = "PRIEST", level = 34, },
	[10880]={ class = "PRIEST", level = 34, },
	[2767]={ class = "PRIEST", level = 34, },
	[19302]={ class = "PRIEST", level = 34, },
	[19277]={ class = "PRIEST", level = 36, },
	[988]={ class = "PRIEST", level = 36, },
	[15264]={ class = "PRIEST", level = 36, },
	[15431]={ class = "PRIEST", level = 36, },
	[17312]={ class = "PRIEST", level = 36, },
	[8192]={ class = "PRIEST", level = 36, },
	[2791]={ class = "PRIEST", level = 36, },
	[6066]={ class = "PRIEST", level = 36, },
	[19309]={ class = "PRIEST", level = 36, },
	[9474]={ class = "PRIEST", level = 38, },
	[6078]={ class = "PRIEST", level = 38, },
	[6060]={ class = "PRIEST", level = 38, },
	[14818]={ class = "PRIEST", level = 40, },
	[19291]={ class = "PRIEST", level = 40, },
	[9592]={ class = "PRIEST", level = 40, },
	[19273]={ class = "PRIEST", level = 40, },
	[2060]={ class = "PRIEST", level = 40, },
	[19283]={ class = "PRIEST", level = 40, },
	[1006]={ class = "PRIEST", level = 40, },
	[10874]={ class = "PRIEST", level = 40, },
	[8106]={ class = "PRIEST", level = 40, },
	[996]={ class = "PRIEST", level = 40, },
	[9485]={ class = "PRIEST", level = 40, },
	[19264]={ class = "PRIEST", level = 40, },
	[19241]={ class = "PRIEST", level = 42, },
	[15265]={ class = "PRIEST", level = 42, },
	[10898]={ class = "PRIEST", level = 42, },
	[10888]={ class = "PRIEST", level = 42, },
	[10957]={ class = "PRIEST", level = 42, },
	[10892]={ class = "PRIEST", level = 42, },
	[19303]={ class = "PRIEST", level = 42, },
	[19278]={ class = "PRIEST", level = 44, },
	[10915]={ class = "PRIEST", level = 44, },
	[27799]={ class = "PRIEST", level = 44, },
	[10911]={ class = "PRIEST", level = 44, },
	[17313]={ class = "PRIEST", level = 44, },
	[10909]={ class = "PRIEST", level = 44, },
	[10927]={ class = "PRIEST", level = 44, },
	[19310]={ class = "PRIEST", level = 44, },
	[10963]={ class = "PRIEST", level = 46, },
	[10945]={ class = "PRIEST", level = 46, },
	[10881]={ class = "PRIEST", level = 46, },
	[10933]={ class = "PRIEST", level = 46, },
	[15266]={ class = "PRIEST", level = 48, },
	[10875]={ class = "PRIEST", level = 48, },
	[10937]={ class = "PRIEST", level = 48, },
	[10899]={ class = "PRIEST", level = 48, },
	[21562]={ class = "PRIEST", level = 48, },
	[19242]={ class = "PRIEST", level = 50, },
	[14819]={ class = "PRIEST", level = 50, },
	[19292]={ class = "PRIEST", level = 50, },
	[10941]={ class = "PRIEST", level = 50, },
	[19274]={ class = "PRIEST", level = 50, },
	[10916]={ class = "PRIEST", level = 50, },
	[19284]={ class = "PRIEST", level = 50, },
	[10951]={ class = "PRIEST", level = 50, },
	[27870]={ class = "PRIEST", level = 50, },
	[10960]={ class = "PRIEST", level = 50, },
	[10928]={ class = "PRIEST", level = 50, },
	[10893]={ class = "PRIEST", level = 50, },
	[19304]={ class = "PRIEST", level = 50, },
	[19265]={ class = "PRIEST", level = 50, },
	[19279]={ class = "PRIEST", level = 52, },
	[10964]={ class = "PRIEST", level = 52, },
	[27800]={ class = "PRIEST", level = 52, },
	[10946]={ class = "PRIEST", level = 52, },
	[17314]={ class = "PRIEST", level = 52, },
	[10953]={ class = "PRIEST", level = 52, },
	[19311]={ class = "PRIEST", level = 52, },
	[15267]={ class = "PRIEST", level = 54, },
	[10900]={ class = "PRIEST", level = 54, },
	[10934]={ class = "PRIEST", level = 54, },
	[10917]={ class = "PRIEST", level = 56, },
	[10876]={ class = "PRIEST", level = 56, },
	[27683]={ class = "PRIEST", level = 56, },
	[10890]={ class = "PRIEST", level = 56, },
	[10929]={ class = "PRIEST", level = 56, },
	[10958]={ class = "PRIEST", level = 56, },
	[19243]={ class = "PRIEST", level = 58, },
	[10965]={ class = "PRIEST", level = 58, },
	[10947]={ class = "PRIEST", level = 58, },
	[10912]={ class = "PRIEST", level = 58, },
	[20770]={ class = "PRIEST", level = 58, },
	[10894]={ class = "PRIEST", level = 58, },
	[19305]={ class = "PRIEST", level = 58, },
	[19280]={ class = "PRIEST", level = 60, },
	[27841]={ class = "PRIEST", level = 60, },
	[19293]={ class = "PRIEST", level = 60, },
	[10942]={ class = "PRIEST", level = 60, },
	[19275]={ class = "PRIEST", level = 60, },
	[25314]={ class = "PRIEST", level = 60, },
	[19285]={ class = "PRIEST", level = 60, },
	[15261]={ class = "PRIEST", level = 60, },
	[27801]={ class = "PRIEST", level = 60, },
	[10952]={ class = "PRIEST", level = 60, },
	[27871]={ class = "PRIEST", level = 60, },
	[18807]={ class = "PRIEST", level = 60, },
	[10938]={ class = "PRIEST", level = 60, },
	[10901]={ class = "PRIEST", level = 60, },
	[21564]={ class = "PRIEST", level = 60, },
	[10961]={ class = "PRIEST", level = 60, },
	[25316]={ class = "PRIEST", level = 60, },
	[27681]={ class = "PRIEST", level = 60, },
	[25315]={ class = "PRIEST", level = 60, },
	[10955]={ class = "PRIEST", level = 60, },
	[19312]={ class = "PRIEST", level = 60, },
	[19266]={ class = "PRIEST", level = 60, },
--++ Priest Talents ++	
	[15237]={ class = "PRIEST", level = 20, },
	[14751]={ class = "PRIEST", level = 20, },
	[15407]={ class = "PRIEST", level = 20, },
	[14752]={ class = "PRIEST", level = 30, },
	[15487]={ class = "PRIEST", level = 30, },
	[15286]={ class = "PRIEST", level = 30, },
	[724]={ class = "PRIEST", level = 40, },
	[10060]={ class = "PRIEST", level = 40, },
	[15473]={ class = "PRIEST", level = 40, },
--++ Rogue Abilities ++	
	[2098]={ class = "ROGUE", level = 1, },
	[1804]={ class = "ROGUE", level = 1, },
	[1752]={ class = "ROGUE", level = 1, },
	[1784]={ class = "ROGUE", level = 1, },
	[53]={ class = "ROGUE", level = 4, },
	[921]={ class = "ROGUE", level = 4, },
	[1776]={ class = "ROGUE", level = 6, },
	[1757]={ class = "ROGUE", level = 6, },
	[5277]={ class = "ROGUE", level = 8, },
	[6760]={ class = "ROGUE", level = 8, },
	[6770]={ class = "ROGUE", level = 10, },
	[5171]={ class = "ROGUE", level = 10, },
	[2983]={ class = "ROGUE", level = 10, },
	[2589]={ class = "ROGUE", level = 12, },
	[1766]={ class = "ROGUE", level = 12, },
	[8647]={ class = "ROGUE", level = 14, },
	[703]={ class = "ROGUE", level = 14, },
	[1758]={ class = "ROGUE", level = 14, },
	[6761]={ class = "ROGUE", level = 16, },
	[1966]={ class = "ROGUE", level = 16, },
	[8676]={ class = "ROGUE", level = 18, },
	[1777]={ class = "ROGUE", level = 18, },
	[2590]={ class = "ROGUE", level = 20, },
	[2842]={ class = "ROGUE", level = 20, },
	[1943]={ class = "ROGUE", level = 20, },
	[1785]={ class = "ROGUE", level = 20, },
	[3420]={ class = "ROGUE", level = 20, },
	[8681]={ class = "ROGUE", level = 20, },
	[1725]={ class = "ROGUE", level = 22, },
	[8631]={ class = "ROGUE", level = 22, },
	[1759]={ class = "ROGUE", level = 22, },
	[1856]={ class = "ROGUE", level = 22, },
	[2836]={ class = "ROGUE", level = 24, },
	[6762]={ class = "ROGUE", level = 24, },
	[5763]={ class = "ROGUE", level = 24, },
	[8724]={ class = "ROGUE", level = 26, },
	[1833]={ class = "ROGUE", level = 26, },
	[8649]={ class = "ROGUE", level = 26, },
	[1767]={ class = "ROGUE", level = 26, },
	[2591]={ class = "ROGUE", level = 28, },
	[6768]={ class = "ROGUE", level = 28, },
	[8639]={ class = "ROGUE", level = 28, },
	[2070]={ class = "ROGUE", level = 28, },
	[8687]={ class = "ROGUE", level = 28, },
	[1842]={ class = "ROGUE", level = 30, },
	[8632]={ class = "ROGUE", level = 30, },
	[408]={ class = "ROGUE", level = 30, },
	[1760]={ class = "ROGUE", level = 30, },
	[2835]={ class = "ROGUE", level = 30, },
	[8623]={ class = "ROGUE", level = 32, },
	[8629]={ class = "ROGUE", level = 32, },
	[13220]={ class = "ROGUE", level = 32, },
	[8725]={ class = "ROGUE", level = 34, },
	[2094]={ class = "ROGUE", level = 34, },
	[8696]={ class = "ROGUE", level = 34, },
	[6510]={ class = "ROGUE", level = 34, },
	[8721]={ class = "ROGUE", level = 36, },
	[8650]={ class = "ROGUE", level = 36, },
	[8640]={ class = "ROGUE", level = 36, },
	[8691]={ class = "ROGUE", level = 36, },
	[8633]={ class = "ROGUE", level = 38, },
	[8621]={ class = "ROGUE", level = 38, },
	[2837]={ class = "ROGUE", level = 38, },
	[8694]={ class = "ROGUE", level = 38, },
	[8624]={ class = "ROGUE", level = 40, },
	[8637]={ class = "ROGUE", level = 40, },
	[1860]={ class = "ROGUE", level = 40, },
	[1786]={ class = "ROGUE", level = 40, },
	[13228]={ class = "ROGUE", level = 40, },
	[11267]={ class = "ROGUE", level = 42, },
	[1768]={ class = "ROGUE", level = 42, },
	[6774]={ class = "ROGUE", level = 42, },
	[1857]={ class = "ROGUE", level = 42, },
	[11279]={ class = "ROGUE", level = 44, },
	[11273]={ class = "ROGUE", level = 44, },
	[11341]={ class = "ROGUE", level = 44, },
	[11197]={ class = "ROGUE", level = 46, },
	[11289]={ class = "ROGUE", level = 46, },
	[11285]={ class = "ROGUE", level = 46, },
	[17347]={ class = "ROGUE", level = 46, },
	[11293]={ class = "ROGUE", level = 46, },
	[11357]={ class = "ROGUE", level = 46, },
	[11299]={ class = "ROGUE", level = 48, },
	[11297]={ class = "ROGUE", level = 48, },
	[13229]={ class = "ROGUE", level = 48, },
	[11268]={ class = "ROGUE", level = 50, },
	[8643]={ class = "ROGUE", level = 50, },
	[3421]={ class = "ROGUE", level = 50, },
	[11280]={ class = "ROGUE", level = 52, },
	[11303]={ class = "ROGUE", level = 52, },
	[11274]={ class = "ROGUE", level = 52, },
	[11342]={ class = "ROGUE", level = 52, },
	[11400]={ class = "ROGUE", level = 52, },
	[11290]={ class = "ROGUE", level = 54, },
	[11294]={ class = "ROGUE", level = 54, },
	[11358]={ class = "ROGUE", level = 54, },
	[11300]={ class = "ROGUE", level = 56, },
	[11198]={ class = "ROGUE", level = 56, },
	[13230]={ class = "ROGUE", level = 56, },
	[11269]={ class = "ROGUE", level = 58, },
	[17348]={ class = "ROGUE", level = 58, },
	[1769]={ class = "ROGUE", level = 58, },
	[11305]={ class = "ROGUE", level = 58, },
	[11281]={ class = "ROGUE", level = 60, },
	[25300]={ class = "ROGUE", level = 60, },
	[31016]={ class = "ROGUE", level = 60, },
	[25302]={ class = "ROGUE", level = 60, },
	[11286]={ class = "ROGUE", level = 60, },
	[11275]={ class = "ROGUE", level = 60, },
	[1787]={ class = "ROGUE", level = 60, },
	[25347]={ class = "ROGUE", level = 60, },
	[11343]={ class = "ROGUE", level = 60, },
--++ Rogue Talents ++	
	[14278]={ class = "ROGUE", level = 20, },
	[14251]={ class = "ROGUE", level = 20, },
	[13877]={ class = "ROGUE", level = 30, },
	[14177]={ class = "ROGUE", level = 30, },
	[16511]={ class = "ROGUE", level = 30, },
	[14185]={ class = "ROGUE", level = 30, },
	[13750]={ class = "ROGUE", level = 40, },
	[14183]={ class = "ROGUE", level = 40, },
--++ Shaman Abilities ++	
	[331]={ class = "SHAMAN", level = 1, },
	[403]={ class = "SHAMAN", level = 1, },
	[8017]={ class = "SHAMAN", level = 1, },
	[8042]={ class = "SHAMAN", level = 4, },
	[8071]={ class = "SHAMAN", level = 4, },
	[2484]={ class = "SHAMAN", level = 6, },
	[332]={ class = "SHAMAN", level = 6, },
	[8044]={ class = "SHAMAN", level = 8, },
	[529]={ class = "SHAMAN", level = 8, },
	[324]={ class = "SHAMAN", level = 8, },
	[8018]={ class = "SHAMAN", level = 8, },
	[5730]={ class = "SHAMAN", level = 8, },
	[8050]={ class = "SHAMAN", level = 10, },
	[8024]={ class = "SHAMAN", level = 10, },
	[3599]={ class = "SHAMAN", level = 10, },
	[8075]={ class = "SHAMAN", level = 10, },
	[2008]={ class = "SHAMAN", level = 12, },
	[1535]={ class = "SHAMAN", level = 12, },
	[547]={ class = "SHAMAN", level = 12, },
	[370]={ class = "SHAMAN", level = 12, },
	[8045]={ class = "SHAMAN", level = 14, },
	[548]={ class = "SHAMAN", level = 14, },
	[8154]={ class = "SHAMAN", level = 14, },
	[526]={ class = "SHAMAN", level = 16, },
	[325]={ class = "SHAMAN", level = 16, },
	[8019]={ class = "SHAMAN", level = 16, },
	[8052]={ class = "SHAMAN", level = 18, },
	[8027]={ class = "SHAMAN", level = 18, },
	[913]={ class = "SHAMAN", level = 18, },
	[6390]={ class = "SHAMAN", level = 18, },
	[8143]={ class = "SHAMAN", level = 18, },
	[8056]={ class = "SHAMAN", level = 20, },
	[8033]={ class = "SHAMAN", level = 20, },
	[2645]={ class = "SHAMAN", level = 20, },
	[5394]={ class = "SHAMAN", level = 20, },
	[8004]={ class = "SHAMAN", level = 20, },
	[915]={ class = "SHAMAN", level = 20, },
	[6363]={ class = "SHAMAN", level = 20, },
	[2870]={ class = "SHAMAN", level = 22, },
	[8498]={ class = "SHAMAN", level = 22, },
	[8166]={ class = "SHAMAN", level = 22, },
	[131]={ class = "SHAMAN", level = 22, },
	[20609]={ class = "SHAMAN", level = 24, },
	[8046]={ class = "SHAMAN", level = 24, },
	[8181]={ class = "SHAMAN", level = 24, },
	[939]={ class = "SHAMAN", level = 24, },
	[905]={ class = "SHAMAN", level = 24, },
	[10399]={ class = "SHAMAN", level = 24, },
	[8155]={ class = "SHAMAN", level = 24, },
	[8160]={ class = "SHAMAN", level = 24, },
	[6196]={ class = "SHAMAN", level = 26, },
	[8030]={ class = "SHAMAN", level = 26, },
	[943]={ class = "SHAMAN", level = 26, },
	[8190]={ class = "SHAMAN", level = 26, },
	[5675]={ class = "SHAMAN", level = 26, },
	[8184]={ class = "SHAMAN", level = 28, },
	[8053]={ class = "SHAMAN", level = 28, },
	[8227]={ class = "SHAMAN", level = 28, },
	[8038]={ class = "SHAMAN", level = 28, },
	[8008]={ class = "SHAMAN", level = 28, },
	[6391]={ class = "SHAMAN", level = 28, },
	[546]={ class = "SHAMAN", level = 28, },
	[556]={ class = "SHAMAN", level = 30, },
	[8177]={ class = "SHAMAN", level = 30, },
	[6375]={ class = "SHAMAN", level = 30, },
	[10595]={ class = "SHAMAN", level = 30, },
	[20608]={ class = "SHAMAN", level = 30, },
	[6364]={ class = "SHAMAN", level = 30, },
	[8232]={ class = "SHAMAN", level = 30, },
	[421]={ class = "SHAMAN", level = 32, },
	[8499]={ class = "SHAMAN", level = 32, },
	[959]={ class = "SHAMAN", level = 32, },
	[6041]={ class = "SHAMAN", level = 32, },
	[945]={ class = "SHAMAN", level = 32, },
	[8012]={ class = "SHAMAN", level = 32, },
	[8512]={ class = "SHAMAN", level = 32, },
	[8058]={ class = "SHAMAN", level = 34, },
	[16314]={ class = "SHAMAN", level = 34, },
	[6495]={ class = "SHAMAN", level = 34, },
	[10406]={ class = "SHAMAN", level = 34, },
	[20610]={ class = "SHAMAN", level = 36, },
	[10412]={ class = "SHAMAN", level = 36, },
	[16339]={ class = "SHAMAN", level = 36, },
	[8010]={ class = "SHAMAN", level = 36, },
	[10585]={ class = "SHAMAN", level = 36, },
	[10495]={ class = "SHAMAN", level = 36, },
	[15107]={ class = "SHAMAN", level = 36, },
	[8170]={ class = "SHAMAN", level = 38, },
	[8249]={ class = "SHAMAN", level = 38, },
	[10478]={ class = "SHAMAN", level = 38, },
	[10456]={ class = "SHAMAN", level = 38, },
	[10391]={ class = "SHAMAN", level = 38, },
	[6392]={ class = "SHAMAN", level = 38, },
	[8161]={ class = "SHAMAN", level = 38, },
	[1064]={ class = "SHAMAN", level = 40, },
	[930]={ class = "SHAMAN", level = 40, },
	[10447]={ class = "SHAMAN", level = 40, },
	[6377]={ class = "SHAMAN", level = 40, },
	[8005]={ class = "SHAMAN", level = 40, },
	[8134]={ class = "SHAMAN", level = 40, },
	[6365]={ class = "SHAMAN", level = 40, },
	[8235]={ class = "SHAMAN", level = 40, },
	[11314]={ class = "SHAMAN", level = 42, },
	[10537]={ class = "SHAMAN", level = 42, },
	[8835]={ class = "SHAMAN", level = 42, },
	[10613]={ class = "SHAMAN", level = 42, },
	[10466]={ class = "SHAMAN", level = 44, },
	[10392]={ class = "SHAMAN", level = 44, },
	[10600]={ class = "SHAMAN", level = 44, },
	[16315]={ class = "SHAMAN", level = 44, },
	[10407]={ class = "SHAMAN", level = 44, },
	[10622]={ class = "SHAMAN", level = 46, },
	[16341]={ class = "SHAMAN", level = 46, },
	[10472]={ class = "SHAMAN", level = 46, },
	[10586]={ class = "SHAMAN", level = 46, },
	[10496]={ class = "SHAMAN", level = 46, },
	[15111]={ class = "SHAMAN", level = 46, },
	[20776]={ class = "SHAMAN", level = 48, },
	[2860]={ class = "SHAMAN", level = 48, },
	[10413]={ class = "SHAMAN", level = 48, },
	[10526]={ class = "SHAMAN", level = 48, },
	[16355]={ class = "SHAMAN", level = 48, },
	[10395]={ class = "SHAMAN", level = 48, },
	[10431]={ class = "SHAMAN", level = 48, },
	[17354]={ class = "SHAMAN", level = 48, },
	[10427]={ class = "SHAMAN", level = 48, },
	[10462]={ class = "SHAMAN", level = 50, },
	[15207]={ class = "SHAMAN", level = 50, },
	[10437]={ class = "SHAMAN", level = 50, },
	[25908]={ class = "SHAMAN", level = 50, },
	[10486]={ class = "SHAMAN", level = 50, },
	[11315]={ class = "SHAMAN", level = 52, },
	[10448]={ class = "SHAMAN", level = 52, },
	[10467]={ class = "SHAMAN", level = 52, },
	[10442]={ class = "SHAMAN", level = 52, },
	[10614]={ class = "SHAMAN", level = 52, },
	[10623]={ class = "SHAMAN", level = 54, },
	[10479]={ class = "SHAMAN", level = 54, },
	[16316]={ class = "SHAMAN", level = 54, },
	[10408]={ class = "SHAMAN", level = 54, },
	[10605]={ class = "SHAMAN", level = 56, },
	[16342]={ class = "SHAMAN", level = 56, },
	[10627]={ class = "SHAMAN", level = 56, },
	[10396]={ class = "SHAMAN", level = 56, },
	[15208]={ class = "SHAMAN", level = 56, },
	[10432]={ class = "SHAMAN", level = 56, },
	[10587]={ class = "SHAMAN", level = 56, },
	[10497]={ class = "SHAMAN", level = 56, },
	[15112]={ class = "SHAMAN", level = 56, },
	[10538]={ class = "SHAMAN", level = 58, },
	[16387]={ class = "SHAMAN", level = 58, },
	[10473]={ class = "SHAMAN", level = 58, },
	[16356]={ class = "SHAMAN", level = 58, },
	[17359]={ class = "SHAMAN", level = 58, },
	[10428]={ class = "SHAMAN", level = 58, },
	[20777]={ class = "SHAMAN", level = 60, },
	[10414]={ class = "SHAMAN", level = 60, },
	[29228]={ class = "SHAMAN", level = 60, },
	[25359]={ class = "SHAMAN", level = 60, },
	[10463]={ class = "SHAMAN", level = 60, },
	[25357]={ class = "SHAMAN", level = 60, },
	[10468]={ class = "SHAMAN", level = 60, },
	[10601]={ class = "SHAMAN", level = 60, },
	[10438]={ class = "SHAMAN", level = 60, },
	[25361]={ class = "SHAMAN", level = 60, },
	[16362]={ class = "SHAMAN", level = 60, },
--++ Shaman Talents ++	
	[16188]={ class = "SHAMAN", level = 30, },
	[16268]={ class = "SHAMAN", level = 30, },
	[16166]={ class = "SHAMAN", level = 40, },
	[16190]={ class = "SHAMAN", level = 40, },
	[17364]={ class = "SHAMAN", level = 40, },
--++ Warlock Abilities ++	
	[687]={ class = "WARLOCK", level = 1, },
	[348]={ class = "WARLOCK", level = 1, },
	[686]={ class = "WARLOCK", level = 1, },
	[688]={ class = "WARLOCK", level = 1, },
	[172]={ class = "WARLOCK", level = 4, },
	[702]={ class = "WARLOCK", level = 4, },
	[1454]={ class = "WARLOCK", level = 6, },
	[695]={ class = "WARLOCK", level = 6, },
	[980]={ class = "WARLOCK", level = 8, },
	[5782]={ class = "WARLOCK", level = 8, },
	[6201]={ class = "WARLOCK", level = 10, },
	[696]={ class = "WARLOCK", level = 10, },
	[1120]={ class = "WARLOCK", level = 10, },
	[707]={ class = "WARLOCK", level = 10, },
	[697]={ class = "WARLOCK", level = 10, },
	[1108]={ class = "WARLOCK", level = 12, },
	[755]={ class = "WARLOCK", level = 12, },
	[705]={ class = "WARLOCK", level = 12, },
	[6222]={ class = "WARLOCK", level = 14, },
	[704]={ class = "WARLOCK", level = 14, },
	[689]={ class = "WARLOCK", level = 14, },
	[1455]={ class = "WARLOCK", level = 16, },
	[5697]={ class = "WARLOCK", level = 16, },
	[1014]={ class = "WARLOCK", level = 18, },
	[5676]={ class = "WARLOCK", level = 18, },
	[693]={ class = "WARLOCK", level = 18, },
	[706]={ class = "WARLOCK", level = 20, },
	[3698]={ class = "WARLOCK", level = 20, },
	[1094]={ class = "WARLOCK", level = 20, },
	[5740]={ class = "WARLOCK", level = 20, },
	[698]={ class = "WARLOCK", level = 20, },
	[1088]={ class = "WARLOCK", level = 20, },
	[712]={ class = "WARLOCK", level = 20, },
	[6202]={ class = "WARLOCK", level = 22, },
	[6205]={ class = "WARLOCK", level = 22, },
	[699]={ class = "WARLOCK", level = 22, },
	[126]={ class = "WARLOCK", level = 22, },
	[6223]={ class = "WARLOCK", level = 24, },
	[5138]={ class = "WARLOCK", level = 24, },
	[8288]={ class = "WARLOCK", level = 24, },
	[5500]={ class = "WARLOCK", level = 24, },
	[18867]={ class = "WARLOCK", level = 24, },
	[1714]={ class = "WARLOCK", level = 26, },
	[132]={ class = "WARLOCK", level = 26, },
	[1456]={ class = "WARLOCK", level = 26, },
	[17919]={ class = "WARLOCK", level = 26, },
	[710]={ class = "WARLOCK", level = 28, },
	[6217]={ class = "WARLOCK", level = 28, },
	[7658]={ class = "WARLOCK", level = 28, },
	[3699]={ class = "WARLOCK", level = 28, },
	[1106]={ class = "WARLOCK", level = 28, },
	[6366]={ class = "WARLOCK", level = 28, },
	[1086]={ class = "WARLOCK", level = 30, },
	[709]={ class = "WARLOCK", level = 30, },
	[1098]={ class = "WARLOCK", level = 30, },
	[1949]={ class = "WARLOCK", level = 30, },
	[2941]={ class = "WARLOCK", level = 30, },
	[691]={ class = "WARLOCK", level = 30, },
	[20752]={ class = "WARLOCK", level = 30, },
	[1490]={ class = "WARLOCK", level = 32, },
	[7646]={ class = "WARLOCK", level = 32, },
	[6213]={ class = "WARLOCK", level = 32, },
	[6229]={ class = "WARLOCK", level = 32, },
	[18868]={ class = "WARLOCK", level = 32, },
	[7648]={ class = "WARLOCK", level = 34, },
	[5699]={ class = "WARLOCK", level = 34, },
	[6226]={ class = "WARLOCK", level = 34, },
	[6219]={ class = "WARLOCK", level = 34, },
	[17920]={ class = "WARLOCK", level = 34, },
	[3700]={ class = "WARLOCK", level = 36, },
	[11687]={ class = "WARLOCK", level = 36, },
	[7641]={ class = "WARLOCK", level = 36, },
	[17951]={ class = "WARLOCK", level = 36, },
	[2362]={ class = "WARLOCK", level = 36, },
	[11711]={ class = "WARLOCK", level = 38, },
	[2970]={ class = "WARLOCK", level = 38, },
	[7651]={ class = "WARLOCK", level = 38, },
	[8289]={ class = "WARLOCK", level = 38, },
	[18879]={ class = "WARLOCK", level = 38, },
	[11733]={ class = "WARLOCK", level = 40, },
	[5484]={ class = "WARLOCK", level = 40, },
	[11665]={ class = "WARLOCK", level = 40, },
	[18869]={ class = "WARLOCK", level = 40, },
	[5784]={ class = "WARLOCK", level = 40, },
	[20755]={ class = "WARLOCK", level = 40, },
	[7659]={ class = "WARLOCK", level = 42, },
	[11707]={ class = "WARLOCK", level = 42, },
	[6789]={ class = "WARLOCK", level = 42, },
	[11683]={ class = "WARLOCK", level = 42, },
	[17921]={ class = "WARLOCK", level = 42, },
	[11739]={ class = "WARLOCK", level = 42, },
	[11671]={ class = "WARLOCK", level = 44, },
	[17862]={ class = "WARLOCK", level = 44, },
	[11703]={ class = "WARLOCK", level = 44, },
	[11725]={ class = "WARLOCK", level = 44, },
	[11693]={ class = "WARLOCK", level = 44, },
	[11659]={ class = "WARLOCK", level = 44, },
	[11729]={ class = "WARLOCK", level = 46, },
	[11721]={ class = "WARLOCK", level = 46, },
	[11699]={ class = "WARLOCK", level = 46, },
	[11688]={ class = "WARLOCK", level = 46, },
	[11677]={ class = "WARLOCK", level = 46, },
	[17952]={ class = "WARLOCK", level = 46, },
	[18647]={ class = "WARLOCK", level = 48, },
	[18930]={ class = "WARLOCK", level = 48, },
	[11712]={ class = "WARLOCK", level = 48, },
	[18870]={ class = "WARLOCK", level = 48, },
	[18880]={ class = "WARLOCK", level = 48, },
	[6353]={ class = "WARLOCK", level = 48, },
	[17727]={ class = "WARLOCK", level = 48, },
	[11719]={ class = "WARLOCK", level = 50, },
	[18937]={ class = "WARLOCK", level = 50, },
	[17925]={ class = "WARLOCK", level = 50, },
	[11734]={ class = "WARLOCK", level = 50, },
	[11743]={ class = "WARLOCK", level = 50, },
	[11667]={ class = "WARLOCK", level = 50, },
	[1122]={ class = "WARLOCK", level = 50, },
	[17922]={ class = "WARLOCK", level = 50, },
	[20756]={ class = "WARLOCK", level = 50, },
	[11708]={ class = "WARLOCK", level = 52, },
	[11675]={ class = "WARLOCK", level = 52, },
	[11694]={ class = "WARLOCK", level = 52, },
	[11660]={ class = "WARLOCK", level = 52, },
	[11740]={ class = "WARLOCK", level = 52, },
	[18931]={ class = "WARLOCK", level = 54, },
	[11672]={ class = "WARLOCK", level = 54, },
	[11700]={ class = "WARLOCK", level = 54, },
	[11704]={ class = "WARLOCK", level = 54, },
	[11684]={ class = "WARLOCK", level = 54, },
	[17928]={ class = "WARLOCK", level = 54, },
	[11717]={ class = "WARLOCK", level = 56, },
	[17937]={ class = "WARLOCK", level = 56, },
	[6215]={ class = "WARLOCK", level = 56, },
	[11689]={ class = "WARLOCK", level = 56, },
	[18871]={ class = "WARLOCK", level = 56, },
	[17924]={ class = "WARLOCK", level = 56, },
	[17953]={ class = "WARLOCK", level = 56, },
	[11730]={ class = "WARLOCK", level = 58, },
	[11713]={ class = "WARLOCK", level = 58, },
	[17926]={ class = "WARLOCK", level = 58, },
	[11726]={ class = "WARLOCK", level = 58, },
	[11678]={ class = "WARLOCK", level = 58, },
	[17923]={ class = "WARLOCK", level = 58, },
	[18881]={ class = "WARLOCK", level = 58, },
	[18932]={ class = "WARLOCK", level = 60, },
	[25311]={ class = "WARLOCK", level = 60, },
	[603]={ class = "WARLOCK", level = 60, },
	[11722]={ class = "WARLOCK", level = 60, },
	[18938]={ class = "WARLOCK", level = 60, },
	[11735]={ class = "WARLOCK", level = 60, },
	[11695]={ class = "WARLOCK", level = 60, },
	[11668]={ class = "WARLOCK", level = 60, },
	[25309]={ class = "WARLOCK", level = 60, },
	[18540]={ class = "WARLOCK", level = 60, },
	[11661]={ class = "WARLOCK", level = 60, },
	[25307]={ class = "WARLOCK", level = 60, },
	[28610]={ class = "WARLOCK", level = 60, },
	[23161]={ class = "WARLOCK", level = 60, },
	[20757]={ class = "WARLOCK", level = 60, },
	[17728]={ class = "WARLOCK", level = 60, },
--++ Warlock Talents ++	
	[18288]={ class = "WARLOCK", level = 20, },
	[18708]={ class = "WARLOCK", level = 20, },
	[17877]={ class = "WARLOCK", level = 20, },
	[18223]={ class = "WARLOCK", level = 30, },
	[18788]={ class = "WARLOCK", level = 30, },
	[18265]={ class = "WARLOCK", level = 30, },
	[17962]={ class = "WARLOCK", level = 40, },
	[18220]={ class = "WARLOCK", level = 40, },
	[19028]={ class = "WARLOCK", level = 40, },
--++ Warrior Abilities ++	
	[6673]={ class = "WARRIOR", level = 1, },
	[2457]={ class = "WARRIOR", level = 1, },
	[78]={ class = "WARRIOR", level = 1, },
	[12288]={ class = "WARRIOR", level = 1, },
	[12707]={ class = "WARRIOR", level = 1, },
	[12708]={ class = "WARRIOR", level = 1, },
	[100]={ class = "WARRIOR", level = 4, },
	[772]={ class = "WARRIOR", level = 4, },
	[6343]={ class = "WARRIOR", level = 6, },
	[1715]={ class = "WARRIOR", level = 8, },
	[284]={ class = "WARRIOR", level = 8, },
	[2687]={ class = "WARRIOR", level = 10, },
	[71]={ class = "WARRIOR", level = 10, },
	[6546]={ class = "WARRIOR", level = 10, },
	[7386]={ class = "WARRIOR", level = 10, },
	[355]={ class = "WARRIOR", level = 10, },
	[5242]={ class = "WARRIOR", level = 12, },
	[7384]={ class = "WARRIOR", level = 12, },
	[72]={ class = "WARRIOR", level = 12, },
	[1160]={ class = "WARRIOR", level = 14, },
	[6572]={ class = "WARRIOR", level = 14, },
	[285]={ class = "WARRIOR", level = 16, },
	[694]={ class = "WARRIOR", level = 16, },
	[2565]={ class = "WARRIOR", level = 16, },
	[676]={ class = "WARRIOR", level = 18, },
	[8198]={ class = "WARRIOR", level = 18, },
	[845]={ class = "WARRIOR", level = 20, },
	[6547]={ class = "WARRIOR", level = 20, },
	[20230]={ class = "WARRIOR", level = 20, },
	[6192]={ class = "WARRIOR", level = 22, },
	[5246]={ class = "WARRIOR", level = 22, },
	[7405]={ class = "WARRIOR", level = 22, },
	[6190]={ class = "WARRIOR", level = 24, },
	[5308]={ class = "WARRIOR", level = 24, },
	[1608]={ class = "WARRIOR", level = 24, },
	[6574]={ class = "WARRIOR", level = 24, },
	[1161]={ class = "WARRIOR", level = 26, },
	[6178]={ class = "WARRIOR", level = 26, },
	[7400]={ class = "WARRIOR", level = 26, },
	[7887]={ class = "WARRIOR", level = 28, },
	[871]={ class = "WARRIOR", level = 28, },
	[8204]={ class = "WARRIOR", level = 28, },
	[2458]={ class = "WARRIOR", level = 30, },
	[7369]={ class = "WARRIOR", level = 30, },
	[20252]={ class = "WARRIOR", level = 30, },
	[6548]={ class = "WARRIOR", level = 30, },
	[1464]={ class = "WARRIOR", level = 30, },
	[11549]={ class = "WARRIOR", level = 32, },
	[18499]={ class = "WARRIOR", level = 32, },
	[20658]={ class = "WARRIOR", level = 32, },
	[7372]={ class = "WARRIOR", level = 32, },
	[11564]={ class = "WARRIOR", level = 32, },
	[1671]={ class = "WARRIOR", level = 32, },
	[11554]={ class = "WARRIOR", level = 34, },
	[7379]={ class = "WARRIOR", level = 34, },
	[8380]={ class = "WARRIOR", level = 34, },
	[7402]={ class = "WARRIOR", level = 36, },
	[1680]={ class = "WARRIOR", level = 36, },
	[6552]={ class = "WARRIOR", level = 38, },
	[8820]={ class = "WARRIOR", level = 38, },
	[8205]={ class = "WARRIOR", level = 38, },
	[11608]={ class = "WARRIOR", level = 40, },
	[20660]={ class = "WARRIOR", level = 40, },
	[11565]={ class = "WARRIOR", level = 40, },
	[11572]={ class = "WARRIOR", level = 40, },
	[11550]={ class = "WARRIOR", level = 42, },
	[20616]={ class = "WARRIOR", level = 42, },
	[11555]={ class = "WARRIOR", level = 44, },
	[11584]={ class = "WARRIOR", level = 44, },
	[11600]={ class = "WARRIOR", level = 44, },
	[11578]={ class = "WARRIOR", level = 46, },
	[20559]={ class = "WARRIOR", level = 46, },
	[11604]={ class = "WARRIOR", level = 46, },
	[11596]={ class = "WARRIOR", level = 46, },
	[23892]={ class = "WARRIOR", level = 48, },
	[20661]={ class = "WARRIOR", level = 48, },
	[11566]={ class = "WARRIOR", level = 48, },
	[21551]={ class = "WARRIOR", level = 48, },
	[23923]={ class = "WARRIOR", level = 48, },
	[11580]={ class = "WARRIOR", level = 48, },
	[11609]={ class = "WARRIOR", level = 50, },
	[1719]={ class = "WARRIOR", level = 50, },
	[11573]={ class = "WARRIOR", level = 50, },
	[11551]={ class = "WARRIOR", level = 52, },
	[20617]={ class = "WARRIOR", level = 52, },
	[1672]={ class = "WARRIOR", level = 52, },
	[23893]={ class = "WARRIOR", level = 54, },
	[11556]={ class = "WARRIOR", level = 54, },
	[7373]={ class = "WARRIOR", level = 54, },
	[21552]={ class = "WARRIOR", level = 54, },
	[11601]={ class = "WARRIOR", level = 54, },
	[23924]={ class = "WARRIOR", level = 54, },
	[11605]={ class = "WARRIOR", level = 54, },
	[20662]={ class = "WARRIOR", level = 56, },
	[11567]={ class = "WARRIOR", level = 56, },
	[20560]={ class = "WARRIOR", level = 56, },
	[6554]={ class = "WARRIOR", level = 58, },
	[11597]={ class = "WARRIOR", level = 58, },
	[11581]={ class = "WARRIOR", level = 58, },
	[25289]={ class = "WARRIOR", level = 60, },
	[23894]={ class = "WARRIOR", level = 60, },
	[20569]={ class = "WARRIOR", level = 60, },
	[25286]={ class = "WARRIOR", level = 60, },
	[21553]={ class = "WARRIOR", level = 60, },
	[11585]={ class = "WARRIOR", level = 60, },
	[11574]={ class = "WARRIOR", level = 60, },
	[25288]={ class = "WARRIOR", level = 60, },
	[23925]={ class = "WARRIOR", level = 60, },
--++ Warrior Talents ++	
	[12975]={ class = "WARRIOR", level = 20, },
	[12323]={ class = "WARRIOR", level = 20, },
	[12809]={ class = "WARRIOR", level = 30, },
	[12328]={ class = "WARRIOR", level = 30, },
	[12292]={ class = "WARRIOR", level = 30, },
	[23881]={ class = "WARRIOR", level = 40, },
	[12294]={ class = "WARRIOR", level = 40, },
	[23922]={ class = "WARRIOR", level = 40, },
};