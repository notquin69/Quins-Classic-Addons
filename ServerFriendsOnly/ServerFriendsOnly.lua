local SERVERFRIENDSONLY, L = ...
SERVERFRIENDSONLY_NAME = GetAddOnMetadata(SERVERFRIENDSONLY, "Title")
SERVERFRIENDSONLY_VERSION = GetAddOnMetadata(SERVERFRIENDSONLY, "Version")

local BASE_MAX_FRIENDS = 50
local MAX_FRIENDS = BASE_MAX_FRIENDS
local MAX_FRIENDS_SHOWN = 9
local FIRST_LOAD = 0
local ADDON_LOADED = false
local ServerFriendsOnlyData = {}
local FriendNames = {}
local ServerFriendsOnlyDataConnected = {}
local db

--local BNFriend = {hasFocus=nil, characterName=nil, client=nil, realmName=nil, realmID=nil, faction=nil, race=nil, class=nil, guild=nil, zoneName=nil, level=nil, gameText=nil, broadcastText=nil, broadcastTime=nil, canSoR=nil, bnetIDGameAccount=nil, presenceID=nil, characterGUID=nil}

local friendsFound = 0
local bNetFriendsFoundOnRealm = 0
local tabID = 1
while _G["FriendsTabHeaderTab"..tabID] do
	tabID = tabID + 1
end
local SERVERFRIENDSONLY_TAB_ID = tabID
local tab = CreateFrame("Button", "FriendsTabHeaderTab"..tabID, FriendsTabHeader, "TabButtonTemplate")

tab:SetPoint("LEFT", _G["FriendsTabHeaderTab"..(tabID-1)]:IsShown() and _G["FriendsTabHeaderTab"..(tabID-1)] or _G["FriendsTabHeaderTab"..(tabID-2)], "RIGHT", 0, 0)
tab:SetText("ServerFriends")
tab:SetID(tabID)

tab:SetScript("OnClick", function(self)
	PanelTemplates_Tab_OnClick(self, FriendsTabHeader)
	ServerFriendsOnly_Update()
	FriendsFrame_Update()
end)



local wowClasses = {"WARRIOR","HUNTER","ROGUE","WARLOCK","MAGE","DRUID","PALADIN","SHAMAN","PRIEST"}
local isInParty = false
local targetIsInParty = false
local targetIsIgnored = false
local textTabOffset = "    "
local bNetNoteId = -1
local friendNoteName = ""
local addFriendButtonText = "Add Friend"
local bAddFriend = CreateFrame("Button", "bAddFriend", FriendsFrame, "UIPanelButtonTemplate")
local bSendMessage = CreateFrame("Button", "bSendMessage", FriendsFrame, "UIPanelButtonTemplate")
local ServerFriendsOnlyHeaderFrame = CreateFrame("Frame",nil,FriendsFrame)
local hiddenOptionsButton =  nil

local fsSFOHeader = ServerFriendsOnlyHeaderFrame:CreateFontString("myButton3[B]Text[/B]", nil, "GameFontNormal")
local fsAddFriend = bAddFriend:CreateFontString("myButton3[B]Text[/B]", nil, "GameFontNormal")
local fsSendMessage = bSendMessage:CreateFontString("myButton3[B]Text[/B]", nil, "GameFontNormal")

lastClicked = ""

local friendsTable = {}
local friendsTableLength = 0


--https://wowwiki.fandom.com/wiki/API_EasyMenu



function HideTab()
	ServerFriendsOnlyFrame:Hide()
	if(hiddenOptionsButton~=nil) then
		hiddenOptionsButton:Hide()
	end
	bSendMessage:Hide()
	bAddFriend:Hide()
	ServerFriendsOnlyHeaderFrame:Hide()
end


PanelTemplates_TabResize(tab, 0)
tab:SetWidth(tab:GetTextWidth() + 31)

PanelTemplates_SetNumTabs(FriendsTabHeader, tabID)
PanelTemplates_SetTab(FriendsTabHeader, tabID)

local hook_FriendsFrame_Update = FriendsFrame_Update


function FriendsFrame_Update()
	if FriendsFrame.selectedTab ~= 1 or FriendsTabHeader.selectedTab ~= tabID then
		HideTab()
		return hook_FriendsFrame_Update()
	end
	FriendsFrameTitleText:SetText(L.TITLETEXT)
	FriendsFrame_ShowSubFrame("ServerFriendsOnlyFrame")
	FriendsTabHeader:Show() -- not sure why it sometimes hides itself
	if(FIRST_LOAD==0) then
		ServerFriendsOnly_OnLoad()
	end
	
	if(hiddenOptionsButton~=nil) then
		hiddenOptionsButton:Show()
	end
	if not ServerFriendsOnlyFrame:IsShown() then
		ServerFriendsOnly_Update()
	end
end

function GetFriendIndex(name)
	local foundIndex = -1
	for i=1,MAX_FRIENDS do
		if(C_FriendList.GetFriendInfoByIndex(i)==nil) then
			return -1
		end
		if(C_FriendList.GetFriendInfoByIndex(i).name == name) then
			return i
		end
	end
	return -1
end

function UpdateFriendTextButton()
	if(UnitGUID("target")~=nil and C_FriendList.IsFriend(UnitGUID("target"))) then
		addFriendButtonText = "Remove Friend"
	else
		addFriendButtonText = "Add Friend"
	end
	fsAddFriend:SetText(addFriendButtonText)
end





local BNFriend = {}
local BNFriend_metatab = {}

function BNFriend.new(hasFocus, characterName, client, realmName, realmID, faction, race, class, guild, zoneName, level, gameText, broadcastText, broadcastTime, canSoR, bnetIDGameAccount, presenceID, characterGUID, isAFK, isDND, noteText, noteTextBN, isReferAFriend, canSummonFriend, connected, isRealmFriend, isBNFriend, bNIndex, bNetUniqueID,bNetAccountName)
	local info = {}
	info.hasFocus = hasFocus
	info.characterName = characterName
	info.client = client;
	info.realmName = realmName;
	info.realmID = realmID;
	info.faction = faction;
	info.race = race;
	info.class = class;
	info.guild = guild;
	info.zoneName = zoneName;
	info.level = level;
	info.gameText = gameText;
	info.broadcastText = broadcastText;
	info.broadcastTime = broadcastTime;
	info.canSoR = canSoR;
	info.bnetIDGameAccount = bnetIDGameAccount;
	info.presenceID = presenceID;
	info.characterGUID = characterGUID;
	info.isAFK = isAFK;
	info.isDND = isDND;
	info.noteText = noteText;
	info.noteTextBN = noteTextBN;
	info.isReferAFriend = isReferAFriend;
	info.canSummonFriend = canSummonFriend;
	info.connected = connected;
	info.isRealmFriend = isRealmFriend;
	info.isBNFriend = isBNFriend;
	info.bNIndex = bNIndex;
	info.bNetUniqueID = bNetUniqueID;
	info.bNetAccountName = bNetAccountName
	setmetatable(info,BNFriend_metatab)
	-- "and it behaves like a box!"
	return info
end

function BNFriend.getvolume(which)
        return which.characterName
end

function compareCharacterName(a,b)
  return a.characterName < b.characterName
end

function FindFriendIndexInTable(name,maxI)

	for i=1,maxI-1 do
		if(friendsTable[i].characterName==name) then
			return i
		end
	end

	return -1
end

function FillFriendsTable()
	friendsTable = {}
	friendsTableLength = 1
	--B.NET
	bNetFriendsFoundOnRealm = 0
	local bNetNumFriends = BNGetNumFriends()
	if(db.showBNetFriends) then
		for i=1,bNetNumFriends do
			hasFocus, characterName, client, realmName, realmID, faction, race, class, guild, zoneName, level, gameText, broadcastText, broadcastTime, canSoR, bnetIDGameAccount, presenceID, _, _, characterGUID = BNGetFriendGameAccountInfo(i, 1)
			bNetUniqueID, accountName, _, _, _, _, _, _, _, isAFK, isDND, _, noteTextBN, _, _, _, isReferAFriend, canSummonFriend = BNGetFriendInfo(i)
			
			if(realmName~=nil and realmName==GetRealmName() and faction==UnitFactionGroup("player")) then --ADD FACTION TOGGLE LATER!?!?!?
				local zzz = BNFriend.new(hasFocus, characterName, client, realmName, realmID, faction, race, class, guild, zoneName, level, gameText, broadcastText, broadcastTime, canSoR, bnetIDGameAccount, presenceID, characterGUID, isAFK, isDND, "", noteTextBN, isReferAFriend, canSummonFriend, true, false, true, i, bNetUniqueID, accountName)
				friendsTable[friendsTableLength] = zzz
				ServerFriendsOnlyDataConnected[friendsTableLength] = connected
				friendsTableLength = friendsTableLength+1
			end
			
		end
	end
	--How many are BNetFriends
	bNetFriendsFoundOnRealm = friendsTableLength
	--Realm
	local offlineFriends = {}
	local friendIndex = 1
	local offlineCount = 1
	while friendIndex<=MAX_FRIENDS and friendIndex<=C_FriendList.GetNumFriends() do
		local friendInfo = C_FriendList.GetFriendInfoByIndex(friendIndex)
		local connected = friendInfo["connected"]
		local characterGUID = friendInfo["guid"]
		local characterName = friendInfo["name"]
		local isAFK = friendInfo["afk"]
		local isReferAFriend = friendInfo["referAFriend"]
		local level = friendInfo["level"]
		local class = friendInfo["className"]
		local isDND = friendInfo["dnd"]
		local zoneName = friendInfo["area"]
		local noteText = friendInfo["notes"]
		
	
		if characterName ~= nil then
			foundFriendIndex = FindFriendIndexInTable(characterName,friendsTableLength)
			if(foundFriendIndex == -1) then
				--print(friendsTable[friendsTableLength-1].characterName)
				local zzz = BNFriend.new(hasFocus, characterName, client, realmName, realmID, faction, race, class, guild, zoneName, level, gameText, broadcastText, broadcastTime, canSoR, bnetIDGameAccount, presenceID, characterGUID, isAFK, isDND, noteText, "", isReferAFriend, canSummonFriend, connected, true, false, -1, -1, "")
				if(not connected) then
					if(db.showOffline) then
						offlineFriends[offlineCount] = zzz
						offlineCount = offlineCount + 1
					end
				else
					friendsTable[friendsTableLength] = zzz
					friendsTableLength = friendsTableLength+1
					friendsFound = friendsTableLength
				end
				ServerFriendsOnlyDataConnected[friendsTableLength] = connected
			else
				friendsTable[foundFriendIndex].noteText = noteText
				friendsTable[foundFriendIndex].isRealmFriend = true
			end
			friendIndex = friendIndex+1
		else
			MAX_FRIENDS = BASE_MAX_FRIENDS+bNetFriendsFoundOnRealm
			friendIndex = MAX_FRIENDS
		end
	end
	
	table.sort(friendsTable, compareCharacterName)
	table.sort(offlineFriends, compareCharacterName)
	for i=1,offlineCount do
		friendsTable[friendsTableLength] = offlineFriends[i]
		friendsTableLength = friendsTableLength+1
		friendsFound = friendsTableLength
	end
	friendsFound = friendsTableLength-1
	friendIndex = MAX_FRIENDS
end

local defaults = {
	showBNetName = true,
	showBNetFriends = true,
	showNameColors = true,
	showOffline = true,
}

function ServerFriendsOnly_OnLoad()
	if(not ADDON_LOADED) then
		ADDON_LOADED = true
		if not ServerFriendsOnlyDB then
			ServerFriendsOnlyDB = CopyTable(defaults)
		end
		--initialize new parameters if uninitialized
		for key,_ in pairs(defaults) do
			if ServerFriendsOnlyDB[key] == nil then ServerFriendsOnlyDB[key] = true end
		end
		
		db = ServerFriendsOnlyDB
		ServerFriendsOnlyScrollBar:RegisterEvent("FRIENDLIST_UPDATE")
		ServerFriendsOnlyScrollBar:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
		ServerFriendsOnlyScrollBar:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
		ServerFriendsOnlyScrollBar:RegisterEvent("BN_FRIEND_INFO_CHANGED")
		ServerFriendsOnlyScrollBar:RegisterEvent("BN_FRIEND_LIST_SIZE_CHANGED")
		ServerFriendsOnlyScrollBar:RegisterEvent("PLAYER_TARGET_CHANGED")
		ServerFriendsOnlyScrollBar:SetScript("OnEvent", function(self, event, ...)
			if( event=="FRIENDLIST_UPDATE" or 
				event=="BN_FRIEND_ACCOUNT_OFFLINE" or 
				event=="BN_FRIEND_ACCOUNT_ONLINE" or 
				event=="BN_FRIEND_INFO_CHANGED" or 
				event=="BN_FRIEND_LIST_SIZE_CHANGED") then
				if(FriendsTabHeader.selectedTab == tabID and ServerFriendsOnlyFrame:IsShown()) then
					ServerFriendsOnly_Update()
				end
				UpdateFriendTextButton()
			elseif(event=="PLAYER_TARGET_CHANGED") then
				UpdateFriendTextButton()
			end
		end)
		--Create friend frames
		for i=1,9 do
			CreateFrame("Button","ServerFriendsOnlyEntry"..i,ServerFriendsOnlyScrollBar,"ServerFriendsOnlyEntryTemplate")
		end
		
		--Create header
		ServerFriendsOnlyHeaderFrame:SetWidth(250) 
		ServerFriendsOnlyHeaderFrame:SetHeight(16) 
		ServerFriendsOnlyHeaderFrame:SetAlpha(.90);
		ServerFriendsOnlyHeaderFrame:SetPoint("TOP",0,-3)
		fsSFOHeader:SetText("Server Friends Only")
		fsSFOHeader:SetPoint("CENTER",0,0)
		
		--Create options button
		hiddenOptionsButton = CreateFrame("Button", "ServerFriendsOnlyOptionsButton", FriendsTabHeader, "ServerFriendsOnlyEntryTemplate")
		hiddenOptionsButton:SetPoint("LEFT", _G["FriendsTabHeaderTab"..(tabID-1)]:IsShown() and _G["FriendsTabHeaderTab"..(tabID-1)] or _G["FriendsTabHeaderTab"..(tabID-2)], "RIGHT", 4, -5)
		hiddenOptionsButton:SetText("")
		hiddenOptionsButton:SetID(tabID)
		hiddenOptionsButton:SetFrameStrata("HIGH")
		hiddenOptionsButton:SetWidth(90)
		hiddenOptionsButton:SetHeight(25)
		hiddenOptionsButton:SetBackdrop({
											bgFile="Interface\\ChatFrame\\ChatFrameBackground",
											--edgeFile="Interface\\ChatFrame\\ChatFrameBackground",
											tile=true,
											tileSize=5,
											edgeSize= 2,
										})
		hiddenOptionsButton:SetBackdropColor(0,0,0,0)
		hiddenOptionsButton:RegisterForClicks("LeftButtonUp","RightButtonUp");
		hiddenOptionsButton:SetScript("OnClick", function(...)
			local self,button = ...
			if button == "RightButton" then
				local menu = {
					{ text = "Options", isTitle = true, notCheckable = true},
					{ text = "Show BattleNet friends?", checked=db.showBNetFriends, func = function()
						db.showBNetFriends = not db.showBNetFriends
						ServerFriendsOnly_Update()
					end },
					{ text = "Show BattleNet names?", checked=db.showBNetName and db.showBNetFriends, disabled=not db.showBNetFriends, func = function()
						db.showBNetName = not db.showBNetName
						ServerFriendsOnly_Update()
					end },
					{ text = "Class color friend names?", checked=db.showNameColors, func = function()
						db.showNameColors = not db.showNameColors
						ServerFriendsOnly_Update()
					end },
					{ text = "Show offline friends?", checked=db.showOffline, func = function()
						db.showOffline = not db.showOffline
						ServerFriendsOnly_Update()
					end },
							
				}
				--menu[1]["text"] = self:GetText()
				menuFrame = CreateFrame("Frame", "ServerFriendsOnlyOptionsMenuFrame", UIParent, "UIDropDownMenuTemplate")
				EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU", 2000);
			end
		end)
	end
end

function ServerFriendsOnly_Update()
	FillFriendsTable()
	
	
	
	local friendIndex = 1
	--local name, level, class, area, connected, status, note = C_FriendList.GetFriendInfoByIndex(friendIndex)
	
	StaticPopupDialogs["FRIEND_NOTE_POPUP"] = {
	  text = "Set Notes for "..friendNoteName,
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function (self, data)
					self.text:SetText("Set Notes for "..friendNoteName)
					local note = ""
					local frIndex = GetFriendIndex(friendNoteName)
					if(frIndex>=0)then
						note = C_FriendList.GetFriendInfoByIndex(GetFriendIndex(friendNoteName))["notes"]
					end
					if(note~=nil) then
						self.editBox:SetText(note)
					else
						self.editBox:SetText("")
					end
				end,
	OnAccept = function (self, data, data2)
			local text = self.editBox:GetText()
			C_FriendList.SetFriendNotesByIndex(GetFriendIndex(friendNoteName),text)
		end,
		hasEditBox = true,
		EditBoxOnEnterPressed = function(self,data, data2)
			local text = self:GetParent().editBox:GetText()
			C_FriendList.SetFriendNotesByIndex(GetFriendIndex(friendNoteName),text)
			self:GetParent():Hide();
		end,
		EditBoxOnEscapePressed = function(self,data, data2)
			self:GetParent():Hide();
		end,
	  editBoxWidth = 350,
	  timeout = 0,
	  whileDead = true,
	  hideOnEscape = 1,
	  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}
	
	StaticPopupDialogs["FRIEND_NOTE_AUTO_ADD_POPUP"] = {
	  text = friendNoteName.." must be added to friends set character note",
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function (self, data)
					self.text:SetText(friendNoteName.." must be added to friends set character note")
				end,
	  OnAccept = function (self)
			C_FriendList.AddFriend(friendNoteName)
			StaticPopup_Show("FRIEND_NOTE_POPUP")
		end,
	  timeout = 0,
	  whileDead = true,
	  hideOnEscape = 1,
	  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}
	
	StaticPopupDialogs["FRIEND_NOTE_BN_POPUP"] = {
	  text = "Set BattleNet Notes for "..friendNoteName,
	  button1 = "Accept",
	  button2 = "Cancel",
	  OnShow = function (self, data)
					local note = friendsTable[bNetNoteId].noteTextBN
					if(note~=nil) then
						self.editBox:SetText(note)
					else
						self.editBox:SetText("")
					end
				end,
	OnAccept = function (self, data, data2)
			local text = self.editBox:GetText()
			BNSetFriendNote(friendsTable[bNetNoteId].bNetUniqueID, text)
			friendsTable[bNetNoteId].noteTextBN = text
		end,
		hasEditBox = true,
		EditBoxOnEnterPressed = function(self,data, data2)
			local text = self:GetParent().editBox:GetText()
			BNSetFriendNote(friendsTable[bNetNoteId].bNetUniqueID, text)
			friendsTable[bNetNoteId].noteTextBN = text
			self:GetParent():Hide();
		end,
		EditBoxOnEscapePressed = function(self,data, data2)
			self:GetParent():Hide();
		end,
	  editBoxWidth = 350,
	  timeout = 0,
	  whileDead = true,
	  hideOnEscape = 1,
	  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}
	
	
	
	while friendIndex<friendsFound do
		--local friendInfo = C_FriendList.GetFriendInfoByIndex(friendIndex)
		local connected = friendsTable[friendIndex].connected
		local guid = friendsTable[friendIndex].characterGUID
		local name = friendsTable[friendIndex].characterName
		local afk = friendsTable[friendIndex].isAFK
		local referAFriend = friendsTable[friendIndex].referAFriend
		local level = friendsTable[friendIndex].level
		local class = friendsTable[friendIndex].class
		local dnd = friendsTable[friendIndex].isDND
		local area = friendsTable[friendIndex].zoneName
		local notes = friendsTable[friendIndex].noteText
		local notesBN = friendsTable[friendIndex].noteTextBN

		if connected then 
			if(db.showNameColors) then
				for i=1,9 do
					if(string.upper(class)==wowClasses[i]) then
						name = "|c"..RAID_CLASS_COLORS[string.upper(class)].colorStr..name.."|c00ffffff"
					end
				end
			end
			if(friendsTable[friendIndex].bNetAccountName~="" and db.showBNetFriends)then
				if(db.showBNetName) then
					ServerFriendsOnlyData[friendIndex] = textTabOffset..name.." |c0058aadd("..friendsTable[friendIndex].bNetAccountName..")|c00ffffff, "..level.." "..class.."\n"..textTabOffset.."|c00808080"..area..	"|c00ffffff"
				else
					ServerFriendsOnlyData[friendIndex] = textTabOffset..name..", "..level.." "..class.."\n"..textTabOffset.."|c00808080"..area..	"|c00ffffff"
				end
			else
				ServerFriendsOnlyData[friendIndex] = textTabOffset..name..", "..level.." "..class.."\n"..textTabOffset.."|c00808080"..area.."|c00ffffff "
			end
		else
			ServerFriendsOnlyData[friendIndex] = textTabOffset.."|c00A0A0A0"..name.." (OFFLINE)|c00ffffff"
		end
		
		
		FriendNames[friendIndex] = friendsTable[friendIndex].characterName
		local friendInvite = "Invite"
		local friendIgnore = "Ignore"
		if(friendIndex<=MAX_FRIENDS_SHOWN) then
			local frFrame = getglobal("ServerFriendsOnlyEntry"..friendIndex)--CreateFrame("Button","ServerFriendsOnlyEntry"..friendIndex,ServerFriendsOnlyScrollBar,"ServerFriendsOnlyEntryTemplate")
			frFrame:SetID(friendIndex)
			frFrame:RegisterForClicks("LeftButtonUp","RightButtonUp");
			frFrame:SetNormalFontObject("GameFontHighlightLeft")
			frFrame:SetNormalTexture(nil)
			frFrame:SetScript("OnEnter",function(self)
				GameTooltip:SetOwner(self,"ANCHOR_CURSOR")
				local nameTooltipString = ""
				local frameID = frFrame:GetID() + FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)
				if(friendsTable[frameID]~=nil) then
					if(friendsTable[frameID].bNetAccountName~="" and db.showBNetFriends and db.showBNetName)then
						GameTooltip:AddLine("|c0058aadd("..friendsTable[frameID].bNetAccountName..")|c00ffffff")
					end
					if friendsTable[frameID].connected then
						if(db.showNameColors) then
							for i=1,9 do
								if(string.upper(friendsTable[frameID].class)==wowClasses[i]) then
									friendsTable[frameID].characterName = "|c"..RAID_CLASS_COLORS[string.upper(friendsTable[frameID].class)].colorStr..friendsTable[frameID].characterName.."|c00ffffff"
								end
							end
						end
						local tooltipNameText = friendsTable[frameID].characterName..", Level "..friendsTable[frameID].level.." "..friendsTable[frameID].class.."\n".."|c00808080"..friendsTable[frameID].zoneName.."|c00ffffff"
						GameTooltip:AddLine(tooltipNameText)
					else
						GameTooltip:AddLine("|c00A0A0A0"..friendsTable[frameID].characterName.." (OFFLINE)|c00ffffff")
					end
					
					
					if(friendsTable[frameID].noteText~=nil and friendsTable[frameID].noteText~="")then
						GameTooltip:AddLine("Character note: "..friendsTable[frameID].noteText)
					else
						--GameTooltip:AddLine("Character note: ")
					end
					if(friendsTable[frameID].noteTextBN~=nil and friendsTable[frameID].noteTextBN~="") then
						GameTooltip:AddLine("BN note: "..friendsTable[frameID].noteTextBN)
					else
						--GameTooltip:AddLine("BN note: ")
					end
					
					GameTooltip:Show()
				end
			  end)
			frFrame:SetScript("OnLeave",function(self)
				GameTooltip:Hide()
			  end)
			frFrame:SetScript("OnClick", function(...)
				local self,button = ...
				if button == "LeftButton" then
					if(FriendNames[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)]~=nil) then
						lastClicked = FriendNames[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)]
					end
					ServerFriendsOnlyScrollBar_Update()
					
				else
					if(UnitInParty("player")) then
						isInParty = true
					else
						isInParty = false
					end
					
					if(UnitInParty(FriendNames[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)])) then
						friendInvite = "Uninvite"
						targetIsInParty = true
					else
						friendInvite = "Invite"
						targetIsInParty = false
					end
					
					local foundName = false
					for i=1, C_FriendList.GetNumIgnores() do
						if(not foundName and C_FriendList.GetIgnoreName(i)==FriendNames[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)]) then
							targetIsIgnored = true
							friendIgnore = "Remove from Ignore"
							foundName = true
						end
					end
					if (not foundName) then
						targetIsIgnored = false
						friendIgnore = "Add to Ignore"
					end

					
					
					local noteText = ""
					if(friendsTable[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)].noteText~=nil) then
						noteText = friendsTable[frFrame:GetID()].noteText
					end
					local noteTextBN = ""
					if(friendsTable[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)].noteTextBN~=nil) then
						noteTextBN = friendsTable[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)].noteTextBN
					end
					local addRemoveLocalFriend = "Remove Character Friend"
					local addRemoveLocalFriendBool = false
					if(not friendsTable[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)].isRealmFriend) then
						addRemoveLocalFriend = "Add Character Friend"
						addRemoveLocalFriendBool = true
					end
					
					
					local menu = {
						{ text = "Select an Option", isTitle = true, notCheckable = true},
						{ text = "Interact", isTitle = true, notCheckable = true},
						{ text = friendInvite, func = function(text)					
						if(targetIsInParty) then
							UninviteUnit(FriendNames[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)]);
						else
							InviteUnit(FriendNames[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)]);
						end 
						end },
						{ text = "Whisper", func = function() ChatFrame_OpenChat("/w "..FriendNames[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)].." ") ; end },
						--{ text = "Target", func = function() Target(menu[0]["text"]); end },
						{ text = "Character note: "..noteText, isTitle = true, notCheckable = true},
						{ text = "Set Character Note", func = function()
							friendNoteName=FriendNames[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)];
							if(not friendsTable[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)].isRealmFriend) then
								StaticPopup_Show("FRIEND_NOTE_AUTO_ADD_POPUP")
							else
								StaticPopup_Show("FRIEND_NOTE_POPUP")
							end
						
						end },
						{ text = "BN note: "..noteTextBN, isTitle = true, notCheckable = true},
						{ text = "Set BN Note", disabled=(not friendsTable[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)].isBNFriend), func = function()
							friendNoteName=FriendNames[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)];
							bNetNoteId = frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar);
							StaticPopup_Show("FRIEND_NOTE_BN_POPUP")
						end },
						{ text = "Other Options", isTitle = true, notCheckable = true},
						{ text = addRemoveLocalFriend, func = function()
							if(addRemoveLocalFriendBool) then
								C_FriendList.AddFriend(FriendNames[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)]);
							else
								C_FriendList.RemoveFriend(FriendNames[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)]);
							end

							end },
						{ text = "Remove BN Friend", disabled=(not friendsTable[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)].isBNFriend), func = function()
								BNRemoveFriend(friendsTable[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)].bNetUniqueID);
							end },
						{ text = "Who Is?", func = function()
							C_FriendList.SendWho(FriendNames[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)].." z-"..area.." c-"..class.." "..level)
						 end },
						{ text = "Cancel", func = function() return end },
						{ text = friendIgnore, func = function() 
						if(targetIsIgnored) then
							DelIgnore(FriendNames[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)]);
						else
							AddIgnore(FriendNames[frFrame:GetID()+FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar)]);
						end end },
					}
					menu[1]["text"] = self:GetText()
					menuFrame = CreateFrame("Frame", "ServerFriendsOnlyRightClickMenuFrame", UIParent, "UIDropDownMenuTemplate")
					
					EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU", 2000);
				end
			end)
			
			if friendIndex == 1 then
				frFrame:SetPoint("TOPLEFT","ServerFriendsOnlyScrollBar","TOPLEFT",0,0)
			else
				frFrame:SetPoint("TOPLEFT","ServerFriendsOnlyEntry"..(friendIndex-1),"BOTTOMLEFT",0,0)
			end
		end
		friendIndex = friendIndex + 1
		--name, level, class, area, connected, status, note = C_FriendList.GetFriendInfoByIndex(friendIndex)
	end
	--for i=1,50 do
	--	ServerFriendsOnlyData[i] = "Test "..math.random(100)
	--end
	ServerFriendsOnlyFrame:SetBackdrop({
					bgFile="Interface\\ChatFrame\\ChatFrameBackground",
					--edgeFile="Interface\\ChatFrame\\ChatFrameBackground",
					tile=true,
					tileSize=5,
					edgeSize= 2,
				})
	ServerFriendsOnlyFrame:SetBackdropColor(0,0,0,0)
	ServerFriendsOnlyFrame:SetWidth(FriendsFrameInset:GetWidth())
	ServerFriendsOnlyFrame:SetHeight(314.99996948242)
	
	ServerFriendsOnlyFrame:Show()
	
	
	
	bAddFriend:SetSize(131 ,21) -- width, height
	StaticPopupDialogs["ADD_FRIEND_POPUP"] = {
	  text = "Add Friend",
	  button1 = "Add Friend",
	  button2 = "Cancel",
	  OnShow = function (self, data)
					self.editBox:SetText("")
				end,
	OnAccept = function (self, data, data2)
		local text = self.editBox:GetText()
			C_FriendList.AddFriend(text);
		end,
		hasEditBox = true,
		EditBoxOnEnterPressed = function(self,data, data2)
			local text = self:GetParent().editBox:GetText()
			C_FriendList.AddFriend(text);
			self:GetParent():Hide();
		end,
		EditBoxOnEscapePressed = function(self,data, data2)
			self:GetParent():Hide();
		end,
	  
	  timeout = 0,
	  whileDead = true,
	  hideOnEscape = 1,
	  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}
	
	--b:SetText("Add Friend")
	bAddFriend:SetPoint("BOTTOMLEFT", 4, 4)
	bAddFriend:SetScript("OnClick", function()
		if(UnitExists("target") and UnitPlayerControlled("target") and UnitFactionGroup("target")==UnitFactionGroup("player")) then
			C_FriendList.AddOrRemoveFriend(UnitName("target"),"")
		else
			StaticPopup_Show ("ADD_FRIEND_POPUP")
		end
	end)
	
	
	fsAddFriend:SetText(addFriendButtonText)
	fsAddFriend:SetPoint("CENTER",0,0)
	bAddFriend.text = fsAddFriend
	bAddFriend:Show()
	
	bSendMessage:SetSize(131 ,21) -- width, height
	
	--b:SetText("Add Friend")
	bSendMessage:SetPoint("BOTTOMRIGHT", -6, 4)
	bSendMessage:SetScript("OnClick", function()
		if(lastClicked~="") then
			ChatFrame_OpenChat("/w "..lastClicked.." ")
		end
	end)
	
	
	fsSendMessage:SetText("Send Message")
	fsSendMessage:SetPoint("CENTER",0,0)
	bSendMessage.text = fsSendMessage
	bSendMessage:Show()
	ServerFriendsOnlyScrollBar_Update()
	
	ServerFriendsOnlyHeaderFrame:Show()
	ServerFriendsOnlyScrollBar:Show()
end

function ServerFriendsOnlyScrollBar_Update()
	local line; -- 1 through 5 of our window to scroll
	local lineplusoffset; -- an index into our data calculated from the scroll offset
	local maxShow = 9;
	if(friendsFound<10) then
		maxShow = friendsFound-1
	end
	FauxScrollFrame_Update(ServerFriendsOnlyScrollBar,friendsFound,maxShow,16);
	
	for line=1,9 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(ServerFriendsOnlyScrollBar);
		if getglobal("ServerFriendsOnlyEntry"..line)~=nil then
			if lineplusoffset < friendsFound then
				--plus 20 for 2 x hex
				local txt = ServerFriendsOnlyData[lineplusoffset]--string.sub(ServerFriendsOnlyData[lineplusoffset],0,44+20)
				--if(string.len(txt)>=44+20) then
				--	txt = txt.."(...)"
				--end
				fr = getglobal("ServerFriendsOnlyEntry"..line)
				fr:SetText(txt);
				fr:Show();
				if(lastClicked~="" and txt~=nil and string.match(txt,lastClicked)) then
					fr:SetBackdrop({
						bgFile="Interface\\ChatFrame\\ChatFrameBackground",
						--edgeFile="Interface\\ChatFrame\\ChatFrameBackground",
						tile=true,
						tileSize=5,
						edgeSize= 2,
					})
					fr:SetBackdropColor(0.5,0.5,0.5,0.5)
				else
					fr:SetBackdrop({
									bgFile="Interface\\ChatFrame\\ChatFrameBackground",
									--edgeFile="Interface\\ChatFrame\\ChatFrameBackground",
									tile=true,
									tileSize=5,
									edgeSize= 2,
								})
					fr:SetBackdropColor(0,0,0,0)
				end
			else
				getglobal("ServerFriendsOnlyEntry"..line):Hide();
			end
		end
	end
end




function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
