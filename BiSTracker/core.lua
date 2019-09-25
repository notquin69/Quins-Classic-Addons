local MainFrame = CreateFrame("Frame", "BiSMainFrame", CharacterFrame, "BiSFrameTemplate");
MainFrame:RegisterEvent("PLAYER_LOGIN");
MainFrame:RegisterEvent("CHAT_MSG_LOOT");
MainFrame:RegisterEvent("ADDON_LOADED");
MainFrame:RegisterEvent("PLAYER_LOGOUT");

local NewCustomSpecFrame;
local ToastFrame;
local ExpandFrame;
local ConfirmDeleteFrame;

local addonVersion = "1.4.3";
local contributors = "Wizm-Mograine PvP";

local loadMessageStart = "|cFF00FFB0" .. "BiSTracker" .. ": |r";
local loadMessage = loadMessageStart .. "|cff00cc66Version |r" .. addonVersion .. "|cff00cc66, developed and maintained by|r Yekru-Mograine PvP";
local contributorMessage = loadMessageStart .. "|cff00cc66Contributors: |r" .. contributors;

local customSpecs = {
	"Add New Spec"
};
local customSpecData = {};
local editingSpec = false;


local backdrop = {
	bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
	tile = true, tileSize = 16, edgeSize = 16, 
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
};

local dropdownBackdrop = {
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
	tile = true, tileSize = 16, edgeSize = 16, 
	insets = { left = 10, right = 10, top = 10, bottom = 10 }
};

local localizedClass, englishClass, classIndex = UnitClass("player");

local stats = {};
local itemCount = 17;
local itemSlots = {
	"Head",
	"Neck",
	"Shoulder",
	"Cloak",
	"Chest",
	"Wrist",
	"Gloves",
	"Waist",
	"Legs",
	"Boots",
	"Ring1",
	"Ring2",
	"Trinket1",
	"Trinket2",
	"MainHand",
	"OffHand",
	"Ranged"
};
local items = {};
local dropdowns = {};
local specItems = {};
local phaseItems = {};

local class = "Druid";
local spec = "FeralDps";
local phase = "Phase1";
local newSpecPhase = "Phase1";

local classes = {
	"Druid",
	"Hunter",
	"Mage",
	"Paladin",
	"Priest",
	"Rogue",
	"Shaman",
	"Warlock",
	"Warrior",
	"Custom"
};

local classIcons = {
	134297,
	135495,
	135150,
	132325,
	135167,
	135428,
	133437,
	136020,
	135328,
	134400
};

local druidSpecs = {
	"FeralTank",
	"FeralDps" ,
	"Restoration",
	"Balance"
};
local hunterSpecs = {
	"All"
};
local mageSpecs = {
	"All"
};
local paladinSpecs = {
	"Holy",
	"Retribution",
	"Protection"
};
local priestSpecs = {
	"Holy",
	"Hybrid",
	"Shadow"
};
local rogueSpecs = {
	"Swords",
	"Daggers"
};
local shamanSpecs = {
	"Elemental",
	"Restoration",
	"Enhancement"
};
local warlockSpecs = {
	"All"
};
local warriorSpecs = {
	"Fury",
	"Protection"
};
local phases = {
	"Phase1",
	"Phase2PreRaid",
	"Phase2",
	"Phase3",
	"Phase4",
	"Phase5",
	"Phase6"
};

if englishClass == "DRUID" then
	class = "Druid";
	spec = "FeralTank";
elseif englishClass == "HUNTER" then
	class = "Hunter";
	spec = "All";
elseif englishClass == "MAGE" then
	class = "Mage";
	spec = "All";
elseif englishClass == "PALADIN" then
	class = "Paladin";
	spec = "Holy";
elseif englishClass == "PRIEST" then
	class = "Priest";
	spec = "Holy";
elseif englishClass == "ROGUE" then
	class = "Rogue";
	spec = "Swords";
elseif englishClass == "SHAMAN" then
	class = "Shaman";
	spec = "Elemental"
elseif englishClass == "WARLOCK" then
	class = "Warlock";
	spec = "All";
elseif englishClass == "WARRIOR" then
	class = "Warrior";
	spec = "Fury";
end

local bisCurrentClassSpecData = {};

local dropdownOpen = "none";

local showWindow = true;

local frameWidth, frameHeight = 250, 50 + table.getn(itemSlots)*15 + 35;

local function getItemData()
	if class == "Custom" then
		return customSpecData[spec][phase];
	else
		return BiSData[class][spec][phase];	
	end
end

local function updateTooltipWindowSize(width, height)
			MainFrame.tooltip:SetSize(width, height);
			MainFrame.tooltip.tooltipObtain:SetWidth(width);
end

local function getItemStats(itemId)
	stats = {};
	GetItemStats("item:"..itemId, stats);
	local statString = "";
	for key,value in pairs(stats) do 
		if key == "ITEM_MOD_AGILITY_SHORT" then
			statString = statString .. "+" .. value .. " Agility\n";
		elseif key == "ITEM_MOD_STRENGTH_SHORT" then
			statString = statString ..  "+" .. value .. " Strength\n";
		elseif key == "ITEM_MOD_INTELLECT_SHORT" then
			statString = statString ..  "+" .. value .. " Intellect\n";
		elseif key == "ITEM_MOD_SPIRIT_SHORT" then
			statString = statString ..  "+" .. value .. " Spirit\n";
		elseif key == "ITEM_MOD_STAMINA_SHORT" then
			statString = statString ..  "+" .. value .. " Stamina\n";
		elseif key == "ITEM_MOD_CRIT_RATING_SHORT" then
			statString = statString ..  "+" .. value .. " Crit Rating\n";
		elseif key == "ITEM_MOD_HASTE_RATING_SHORT" then
			statString = statString ..  "+" .. value .. " Haste\n";
		elseif key == "RESISTANCE0_NAME" then
			statString = statString ..  "+" .. value .. " Armor\n";
		elseif key == "RESISTANCE1_NAME" then
			statString = statString ..  "+" .. value .. " Holy Resistance\n";
		elseif key == "RESISTANCE2_NAME" then
			statString = statString ..  "+" .. value .. " Fire Resistance\n";
		elseif key == "RESISTANCE3_NAME" then
			statString = statString ..  "+" .. value .. " Nature Resistance\n";
		elseif key == "RESISTANCE4_NAME" then
			statString = statString ..  "+" .. value .. " Frost Resistance\n";
		elseif key == "RESISTANCE5_NAME" then
			statString = statString ..  "+" .. value .. " Shadow Resistance\n";
		elseif key == "RESISTANCE6_NAME" then
			statString = statString ..  "+" .. value .. " Arcane Resistance\n";
		elseif key == "RESISTANCE1_NAME" then
			statString = statString ..  "+" .. value .. " Holy Resistance\n";
		elseif key == "RESISTANCE1_NAME" then
			statString = statString ..  "+" .. value .. " Holy Resistance\n";
		elseif key == "RESISTANCE1_NAME" then
			statString = statString .. "+" .. value .. " Holy Resistance\n";
		end
	end
	return statString;
end

local function getWeaponDamage(itemId)
	stats = {};
	GetItemStats("item:"..itemId, stats);
	local damageTable = {dps = "", damage = ""};
	for key,value in pairs(stats) do 
		if key == "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" then
			damageTable.dps = math.ceil(value*100)*0.01;
		elseif key == "" then
			damageTable.damage = value;
		end
	end
	return damageTable;
end


local function updateItemList()
	if spec ~= customSpecs[1] then
		local itemData = getItemData();
		bisCurrentClassSpecData = {};

		if table.getn(items) == 0 then
			for itemIndex = 1, table.getn(itemSlots) do
				local listItemName = "";
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent;
				if itemData[itemSlots[itemIndex]].itemID ~= 0 and itemData[itemSlots[itemIndex]].itemID ~= "" then
					itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(itemData[itemSlots[itemIndex]].itemID);
				end


				if itemName ~= nil then
					itemName = "[" .. itemName .. "]";
					if string.len(itemName) > 23 then
						listItemName = itemName:sub(1, 23) .. "...]";
					else 
						listItemName = itemName;
					end
				end

				local item = CreateFrame("Frame", itemSlots[itemIndex], MainFrame, "BiSFrameTemplate");
				item:SetBackdropColor(1, 1, 1, 0.1);
				item:SetPoint("LEFT", MainFrame.TopLeft, "LEFT", 10, -1 * (20 + itemIndex * 16) - 30);
				item:SetSize(frameWidth, 17);

				item.icon = item:CreateTexture(itemSlots[itemIndex] .. "Icon", "ARTWORK");
				item.icon:SetPoint("LEFT", item.Left, "LEFT", 2, 0);
				item.icon:SetWidth(item:GetHeight());
				item.icon:SetHeight(item:GetHeight());
				item.icon:SetTexture(itemIcon);

				item.playerHasItem = item:CreateTexture(itemSlots[itemIndex] .. "playerHasItem", "ARTWORK");
				item.playerHasItem:SetPoint("RIGHT", item.Right, "RIGHT", -item:GetHeight() - 2, 0)
				item.playerHasItem:SetWidth(item:GetHeight());
				item.playerHasItem:SetHeight(item:GetHeight());
				item.playerHasItem:SetTexture(167334);

				if characterHasItem(itemData[itemSlots[itemIndex]].itemID) then
					item.playerHasItem:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready");
				else
					item.playerHasItem:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady");
				end

				if tostring(itemMinLevel) == "nil" then
					item.playerHasItem:Hide();
				else
					item.playerHasItem:Show();
				end

				if itemRarity == 2 then 
					item.titleRed = 0.1;
					item.titleGreen = 1;
					item.titleBlue = 0;
				elseif itemRarity == 3 then 
					item.titleRed = 0;
					item.titleGreen = 0.43;
					item.titleBlue = 0.86;
				elseif itemRarity == 4 then 
					item.titleRed = 0.63;
					item.titleGreen = 0.2;
					item.titleBlue = 0.92;
				elseif itemRarity == 5 then 
					item.titleRed = 1;
					item.titleGreen = 0.5;
					item.titleBlue = 0;
				end

				bisCurrentClassSpecData[itemData[itemSlots[itemIndex]].itemID] = {
					itemName = itemName, 
					itemIcon = itemIcon, 
					class = class, 
					spec = spec,
					titleRed = item.titleRed,
					titleGreen = item.titleGreen,
					titleBlue = item.titleBlue,
				};

				item.title = item:CreateFontString(itemSlots[itemIndex] .. "Name", "OVERLAY");
				item.title:SetFontObject("GameFontHighlight");
				item.title:SetPoint("LEFT", item.Left, "LEFT", 24, 0);
				item.title:SetText(listItemName);
				
				item.title:SetTextColor(item.titleRed, item.titleGreen, item.titleBlue, 1);
				--item.title:SetFont("Fonts\\FRIZQT__.TTF", 10);
				item:SetScript("OnEnter", function(self) 
					item:SetBackdropColor(0.2, 0.2, 0.2, 0.3);
					item.title:SetTextColor(0.86, 0.64, 0, 1);
					if (tostring(itemMinLevel) ~= "nil") then

						MainFrame.tip:SetOwner(MainFrame, "ANCHOR_NONE");
						MainFrame.tip:SetPoint("TOPLEFT", CharacterFrame, "TOPRIGHT", 220, -13);
						MainFrame.tip:SetHyperlink(itemLink);
						MainFrame.tip:AddLine("\nThis item can be obtained in: " .. itemData[itemSlots[itemIndex]].Obtain.Zone);
						if string.match(itemData[itemSlots[itemIndex]].Obtain.Type, "Profession") then
							MainFrame.tip:AddLine(itemData[itemSlots[itemIndex]].Obtain.Type);
							MainFrame.tip:AddLine(itemData[itemSlots[itemIndex]].Obtain.Method);
						else
							MainFrame.tip:AddLine(itemData[itemSlots[itemIndex]].Obtain.Type .. ": " .. itemData[itemSlots[itemIndex]].Obtain.Method);
						end
						if (string.len(itemData[itemSlots[itemIndex]].Obtain.Drop) > 0) then
							MainFrame.tip:AddLine("Drop chance: " .. itemData[itemSlots[itemIndex]].Obtain.Drop);
						else
							MainFrame.tip:AddLine(itemData[itemSlots[itemIndex]].Obtain.Drop);
						end
						MainFrame.tip:Show();
						--MainFrame.tooltip:Show();
						--MainFrame.tooltip.weaponDamage:SetText("");
						--MainFrame.tooltip.weaponSpeed:SetText("");
						--MainFrame.tooltip.dps:SetText("");
						--MainFrame.tooltip.weaponStats:SetText("");
						--MainFrame.tooltip.gearStats:SetText("");
						--MainFrame.tooltip.icon:SetTexture(itemIcon);
						--MainFrame.tooltip.title:SetText(itemName);
						--MainFrame.tooltip.title:SetTextColor(item.titleRed, item.titleGreen, item.titleBlue, 1);
						--MainFrame.tooltip.acquire:SetText("");
						--MainFrame.tooltip.levelRequirement:SetText("Required Level: " .. tostring(itemMinLevel));
						--MainFrame.tooltip.type:SetText(itemType);
						--MainFrame.tooltip.subType:SetText(itemSubType);

						MainFrame.tooltipObtain.zone:SetText(itemData[itemSlots[itemIndex]].Obtain.Zone);
						MainFrame.tooltipObtain.Type:SetText(itemData[itemSlots[itemIndex]].Obtain.Type .. ":");
						MainFrame.tooltipObtain.Method:SetText(itemData[itemSlots[itemIndex]].Obtain.Method);
						if (string.len(itemData[itemSlots[itemIndex]].Obtain.Drop) > 0) then
							MainFrame.tooltipObtain.Drop:SetText("Drop chance: " .. itemData[itemSlots[itemIndex]].Obtain.Drop);
						else
							MainFrame.tooltipObtain.Drop:SetText(itemData[itemSlots[itemIndex]].Obtain.Drop);
						end

						--if characterHasItem(itemData[itemSlots[itemIndex]].itemID) then
						--	MainFrame.tooltip.playerHasItem:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready");
						--else
						--	MainFrame.tooltip.playerHasItem:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady");
						--end

						--local nameLength = string.len(itemName);
						--if (nameLength * 13 < 230) then
						--	updateTooltipWindowSize(280, 300);
						--else
						--	updateTooltipWindowSize(nameLength * 13 + 50, 300);
						--end

						--if itemType == "Weapon" then
						--	local weapondmg = getWeaponDamage(itemData[itemSlots[itemIndex]].itemID);
						--	MainFrame.tooltip.weaponDamage:SetText(weapondmg.damage);
						--	MainFrame.tooltip.dps:SetText("(" .. weapondmg.dps .. " Damage Per Second)");
						--	MainFrame.tooltip.weaponStats:SetText(getItemStats(itemData[itemSlots[itemIndex]].itemID));
						--else
						--	MainFrame.tooltip.gearStats:SetText(getItemStats(itemData[itemSlots[itemIndex]].itemID));
						--end
					end
				end);

				item:SetScript("OnLeave", function(self) 
					item:SetBackdropColor(1, 1, 1, 0.1);
					item.title:SetTextColor(item.titleRed, item.titleGreen, item.titleBlue, 1);
					--MainFrame.tooltip:Hide();
					MainFrame.tip:Hide();
					MainFrame.tooltipObtain:Hide();
				end);

				item:SetScript("OnMouseDown", function(self)
					if itemName ~= nil then
						SetItemRef(itemLink, itemLink, "LeftButton");
					end
				end)

				item:Show();

				table.insert(items, item);

			end
		else
			for itemIndex = 1, table.getn(itemSlots) do
				local listItemName = "";
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent;
				if itemData[itemSlots[itemIndex]].itemID ~= 0 and itemData[itemSlots[itemIndex]].itemID ~= "" then
					itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(itemData[itemSlots[itemIndex]].itemID);
				end

				if itemName ~= nil then
					itemName = "[" .. itemName .. "]";
				end

				local item = items[itemIndex];
				if itemRarity == 2 then 
					item.titleRed = 0.1;
					item.titleGreen = 1;
					item.titleBlue = 0;
				elseif itemRarity == 3 then 
					item.titleRed = 0;
					item.titleGreen = 0.43;
					item.titleBlue = 0.86;
				elseif itemRarity == 4 then 
					item.titleRed = 0.63;
					item.titleGreen = 0.2;
					item.titleBlue = 0.92;
				elseif itemRarity == 5 then 
					item.titleRed = 1;
					item.titleGreen = 0.5;
					item.titleBlue = 0;
				end

				bisCurrentClassSpecData[itemData[itemSlots[itemIndex]].itemID] = {
					itemName = itemName, 
					itemIcon = itemIcon, 
					class = class, 
					spec = spec,
					titleRed = item.titleRed,
					titleGreen = item.titleGreen,
					titleBlue = item.titleBlue,
				};

				if characterHasItem(itemData[itemSlots[itemIndex]].itemID) then
					item.playerHasItem:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready");
				else
					item.playerHasItem:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady");
				end

				if tostring(itemMinLevel) == "nil" then
					item.playerHasItem:Hide();
				else
					item.playerHasItem:Show();
				end

				item:SetScript("OnEnter", function(self)
					item:SetBackdropColor(0.2, 0.2, 0.2, 0.3);
					item.title:SetTextColor(0.86, 0.64, 0, 1);
					if (tostring(itemMinLevel) ~= "nil") then
						

						

						MainFrame.tip:SetOwner(MainFrame, "ANCHOR_NONE");
						MainFrame.tip:SetPoint("TOPLEFT", CharacterFrame, "TOPRIGHT", 220, -13);
						MainFrame.tip:SetHyperlink(itemLink);
						MainFrame.tip:AddLine("\nThis item can be obtained in: " .. itemData[itemSlots[itemIndex]].Obtain.Zone);
						if string.match(itemData[itemSlots[itemIndex]].Obtain.Type, "Profession") then
							MainFrame.tip:AddLine(itemData[itemSlots[itemIndex]].Obtain.Type);
							MainFrame.tip:AddLine(itemData[itemSlots[itemIndex]].Obtain.Method);
						else
							MainFrame.tip:AddLine(itemData[itemSlots[itemIndex]].Obtain.Type .. ": " .. itemData[itemSlots[itemIndex]].Obtain.Method);
						end
						if (string.len(itemData[itemSlots[itemIndex]].Obtain.Drop) > 0) then
							MainFrame.tip:AddLine("Drop chance: " .. itemData[itemSlots[itemIndex]].Obtain.Drop);
						else
							MainFrame.tip:AddLine(itemData[itemSlots[itemIndex]].Obtain.Drop);
						end
						MainFrame.tip:Show();
						--MainFrame.tooltip:Show();
						--MainFrame.tooltip.weaponDamage:SetText("");
						--MainFrame.tooltip.weaponSpeed:SetText("");
						--MainFrame.tooltip.dps:SetText("");
						--MainFrame.tooltip.weaponStats:SetText("");
						--MainFrame.tooltip.gearStats:SetText("");
						--MainFrame.tooltip.icon:SetTexture(itemIcon);
						--MainFrame.tooltip.title:SetText(itemName);
						--MainFrame.tooltip.title:SetTextColor(item.titleRed, item.titleGreen, item.titleBlue, 1);
						--MainFrame.tooltip.acquire:SetText("");
						--MainFrame.tooltip.levelRequirement:SetText("Required Level: " .. tostring(itemMinLevel));
						--MainFrame.tooltip.type:SetText(itemType);
						--MainFrame.tooltip.subType:SetText(itemSubType);

						MainFrame.tooltipObtain.zone:SetText(itemData[itemSlots[itemIndex]].Obtain.Zone);
						MainFrame.tooltipObtain.Type:SetText(itemData[itemSlots[itemIndex]].Obtain.Type .. ":");
						MainFrame.tooltipObtain.Method:SetText(itemData[itemSlots[itemIndex]].Obtain.Method);
						if (string.len(itemData[itemSlots[itemIndex]].Obtain.Drop) > 0) then
							MainFrame.tooltipObtain.Drop:SetText("Drop chance: " .. itemData[itemSlots[itemIndex]].Obtain.Drop);
						else
							MainFrame.tooltipObtain.Drop:SetText(itemData[itemSlots[itemIndex]].Obtain.Drop);
						end

						--if characterHasItem(itemData[itemSlots[itemIndex]].itemID) then
						--	MainFrame.tooltip.playerHasItem:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready");
						--else
						--	MainFrame.tooltip.playerHasItem:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady");
						--end

						--local nameLength = string.len(itemName);
						--if (nameLength * 13 < 230) then
						--	updateTooltipWindowSize(280, 300);
						--else
						--	updateTooltipWindowSize(nameLength * 13 + 50, 300);
						--end

						--if itemType == "Weapon" then
						--	local weapondmg = getWeaponDamage(itemData[itemSlots[itemIndex]].itemID);
						--	MainFrame.tooltip.weaponDamage:SetText(weapondmg.damage);
						--	MainFrame.tooltip.dps:SetText("(" .. weapondmg.dps .. " Damage Per Second)");
						--	MainFrame.tooltip.weaponStats:SetText(getItemStats(itemData[itemSlots[itemIndex]].itemID));
						--else
						--	MainFrame.tooltip.gearStats:SetText(getItemStats(itemData[itemSlots[itemIndex]].itemID));
						--end
					end
				end)

				item:SetScript("OnLeave", function(self)
					item:SetBackdropColor(1, 1, 1, 0.1);
					item.title:SetTextColor(item.titleRed, item.titleGreen, item.titleBlue, 1);
					--MainFrame.tooltip:Hide();
					MainFrame.tip:Hide();
					MainFrame.tooltipObtain:Hide();
				end)
				item:SetScript("OnMouseDown", function(self)
					if itemName ~= nil then
						SetItemRef(itemLink, itemLink, "LeftButton");
					end
				end)
				if itemName ~= nil then
					if string.len(itemName) > 23 then
						listItemName = itemName:sub(1, 23) .. "...]";
					else 
						listItemName = itemName;
					end
				end

				item.title:SetText(listItemName);
				item.title:SetTextColor(item.titleRed, item.titleGreen, item.titleBlue, 1);
				item.icon:SetTexture(itemIcon);

			end
		end
	end

end

function toggleWindow()
	if showWindow then
		MainFrame:Hide();
		showWindow = false;
		ExpandFrame:SetNormalTexture("Interface\\AddOns\\BiSTracker\\assets\\ArrowRight");
		ExpandFrame:SetPushedTexture("Interface\\AddOns\\BiSTracker\\assets\\ArrowRight");
		ExpandFrame:SetHighlightTexture("Interface\\AddOns\\BiSTracker\\assets\\ArrowRightHover", "ADD");
	else
		MainFrame:Show();
		showWindow = true;
		ExpandFrame:SetNormalTexture("Interface\\AddOns\\BiSTracker\\assets\\ArrowLeft");
		ExpandFrame:SetPushedTexture("Interface\\AddOns\\BiSTracker\\assets\\ArrowLeft");
		ExpandFrame:SetHighlightTexture("Interface\\AddOns\\BiSTracker\\assets\\ArrowLeftHover", "ADD");
	end
end

local function dropdownClick(title, dropdown)

	dropdowns[1].dropdownList:Hide();
	dropdowns[2].dropdownList:Hide();
	dropdowns[3].dropdownList:Hide();

	if dropdownOpen == title then
		dropdownOpen = "none";
	else
		dropdown.dropdownList:Show();
		dropdownOpen = title;
	end
end

local function createDropdownListSpecItems(specs, dropdownlist)
	for itemIndex = 1, table.getn(specs) do
			local item = CreateFrame("Frame", nil, dropdownlist, "BiSFrameTemplate");
			item:SetBackdropColor(1, 1, 1, 0.1);
			item:SetPoint("LEFT", dropdownlist.TopLeft, "LEFT", -2, -1 * (itemIndex * 16) + 3);
			item:SetSize(frameWidth, 15);

			item.title = item:CreateFontString(nil, "OVERLAY");
			item.title:SetFontObject("GameFontHighlight");
			item.title:SetPoint("LEFT", item.Left, "CENTER", 14, 0);
			item.title:SetTextColor(1, 1, 1, 1);
			item.title:SetText(specs[itemIndex]);
			item:SetScript("OnEnter", function(self) 
				item:SetBackdropColor(0.2, 0.2, 0.2, 0.3);
				item.title:SetTextColor(0.86, 0.64, 0, 1);
			end);
			item:SetScript("OnLeave", function(self) 
				item:SetBackdropColor(1, 1, 1, 0.1);
				item.title:SetTextColor(1, 1, 1, 1);
			end);
			item:SetScript("OnMouseDown", function(self)
				if (item.title:GetText() == customSpecs[1]) then
					editSpec = false;
					NewCustomSpecFrame.title:SetText("Add a new custom spec");
					NewCustomSpecFrame.scrollFrame.content.addSpecBtn:SetText("Add Spec");

					NewCustomSpecFrame.nameEdit:SetText("");

					NewCustomSpecFrame.scrollFrame.content.Head.idEdit:SetNumber(0);
					NewCustomSpecFrame.scrollFrame.content.Head.zoneEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Head.typeEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Head.methodEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Head.dropEdit:SetText("");

					NewCustomSpecFrame.scrollFrame.content.Neck.idEdit:SetNumber(0);
					NewCustomSpecFrame.scrollFrame.content.Neck.zoneEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Neck.typeEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Neck.methodEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Neck.dropEdit:SetText("");

					NewCustomSpecFrame.scrollFrame.content.Shoulder.idEdit:SetNumber(0);
					NewCustomSpecFrame.scrollFrame.content.Shoulder.zoneEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Shoulder.typeEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Shoulder.methodEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Shoulder.dropEdit:SetText("");

					NewCustomSpecFrame.scrollFrame.content.Cloak.idEdit:SetNumber(0);
					NewCustomSpecFrame.scrollFrame.content.Cloak.zoneEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Cloak.typeEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Cloak.methodEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Cloak.dropEdit:SetText("");

					NewCustomSpecFrame.scrollFrame.content.Chest.idEdit:SetNumber(0);
					NewCustomSpecFrame.scrollFrame.content.Chest.zoneEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Chest.typeEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Chest.methodEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Chest.dropEdit:SetText("");

					NewCustomSpecFrame.scrollFrame.content.Wrist.idEdit:SetNumber(0);
					NewCustomSpecFrame.scrollFrame.content.Wrist.zoneEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Wrist.typeEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Wrist.methodEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Wrist.dropEdit:SetText("");

					NewCustomSpecFrame.scrollFrame.content.Gloves.idEdit:SetNumber(0);
					NewCustomSpecFrame.scrollFrame.content.Gloves.zoneEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Gloves.typeEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Gloves.methodEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Gloves.dropEdit:SetText("");

					NewCustomSpecFrame.scrollFrame.content.Waist.idEdit:SetNumber(0);
					NewCustomSpecFrame.scrollFrame.content.Waist.zoneEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Waist.typeEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Waist.methodEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Waist.dropEdit:SetText("");

					NewCustomSpecFrame.scrollFrame.content.Legs.idEdit:SetNumber(0);
					NewCustomSpecFrame.scrollFrame.content.Legs.zoneEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Legs.typeEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Legs.methodEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Legs.dropEdit:SetText("");

					NewCustomSpecFrame.scrollFrame.content.Boots.idEdit:SetNumber(0);
					NewCustomSpecFrame.scrollFrame.content.Boots.zoneEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Boots.typeEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Boots.methodEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Boots.dropEdit:SetText("");

					NewCustomSpecFrame.scrollFrame.content.Ring1.idEdit:SetNumber(0);
					NewCustomSpecFrame.scrollFrame.content.Ring1.zoneEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Ring1.typeEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Ring1.methodEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Ring1.dropEdit:SetText("");

					NewCustomSpecFrame.scrollFrame.content.Ring2.idEdit:SetNumber(0);
					NewCustomSpecFrame.scrollFrame.content.Ring2.zoneEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Ring2.typeEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Ring2.methodEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Ring2.dropEdit:SetText("");

					NewCustomSpecFrame.scrollFrame.content.Trinket1.idEdit:SetNumber(0);
					NewCustomSpecFrame.scrollFrame.content.Trinket1.zoneEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Trinket1.typeEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Trinket1.methodEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Trinket1.dropEdit:SetText("");

					NewCustomSpecFrame.scrollFrame.content.Trinket2.idEdit:SetNumber(0);
					NewCustomSpecFrame.scrollFrame.content.Trinket2.zoneEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Trinket2.typeEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Trinket2.methodEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Trinket2.dropEdit:SetText("");

					NewCustomSpecFrame.scrollFrame.content.MainHand.idEdit:SetNumber(0);
					NewCustomSpecFrame.scrollFrame.content.MainHand.zoneEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.MainHand.typeEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.MainHand.methodEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.MainHand.dropEdit:SetText("");

					NewCustomSpecFrame.scrollFrame.content.OffHand.idEdit:SetNumber(0);
					NewCustomSpecFrame.scrollFrame.content.OffHand.zoneEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.OffHand.typeEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.OffHand.methodEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.OffHand.dropEdit:SetText("");

					NewCustomSpecFrame.scrollFrame.content.Ranged.idEdit:SetNumber(0);
					NewCustomSpecFrame.scrollFrame.content.Ranged.zoneEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Ranged.typeEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Ranged.methodEdit:SetText("");
					NewCustomSpecFrame.scrollFrame.content.Ranged.dropEdit:SetText("");

					UIDropDownMenu_SetSelectedValue(NewCustomSpecFrame.scrollFrame.content.addBox.phaseDropdown, "Phase1");

					NewCustomSpecFrame:Show();
				else
					spec = item.title:GetText();
					for x = 1, table.getn(phaseItems) do
						if class == "Custom" then 
							if customSpecData[spec][phases[x]] ~= nil then
								phaseItems[x].title:SetTextColor(1, 1, 1, 1);
								phaseItems[x]:SetScript("OnEnter", function(self) 
									phaseItems[x]:SetBackdropColor(0.2, 0.2, 0.2, 0.3);
									phaseItems[x].title:SetTextColor(0.86, 0.64, 0, 1);
								end);
								phaseItems[x]:SetScript("OnLeave", function(self) 
									phaseItems[x]:SetBackdropColor(1, 1, 1, 0.1);
									phaseItems[x].title:SetTextColor(1, 1, 1, 1);
								end);
								phaseItems[x]:SetScript("OnMouseDown", function(self)
									phase = phaseItems[x].title:GetText();
									updateItemList();

								end);
							else
								phaseItems[x].title:SetTextColor(0.7, 0.7, 0.7, 1);
								phaseItems[x]:SetScript("OnEnter", function(self)
								end);
								phaseItems[x]:SetScript("OnLeave", function(self)
								end);
								phaseItems[x]:SetScript("OnMouseDown", function(self)
								end);
							end
						else
							if BiSData[class][spec][phases[x]] ~= nil then
								phaseItems[x].title:SetTextColor(1, 1, 1, 1);
								phaseItems[x]:SetScript("OnEnter", function(self) 
									phaseItems[x]:SetBackdropColor(0.2, 0.2, 0.2, 0.3);
									phaseItems[x].title:SetTextColor(0.86, 0.64, 0, 1);
								end);
								phaseItems[x]:SetScript("OnLeave", function(self) 
									phaseItems[x]:SetBackdropColor(1, 1, 1, 0.1);
									phaseItems[x].title:SetTextColor(1, 1, 1, 1);
								end);
								phaseItems[x]:SetScript("OnMouseDown", function(self)
									phase = phaseItems[x].title:GetText();
									updateItemList();

								end);
							else
								phaseItems[x].title:SetTextColor(0.7, 0.7, 0.7, 1);
								phaseItems[x]:SetScript("OnEnter", function(self)
								end);
								phaseItems[x]:SetScript("OnLeave", function(self)
								end);
								phaseItems[x]:SetScript("OnMouseDown", function(self)
								end);
							end
						end
					end
				end
				updateItemList();
			end);

			item:Show();

			table.insert(specItems, item);
			dropdownlist:SetSize(100, table.getn(specs) * 16 + 15);
			
		end
end

local function setDropdownListSize(specs, dropdownlist, minSize)

	dropdownlist:SetSize(minSize, table.getn(specs) * 16 + 15);
	for itemIndex = 1, table.getn(specs) do
		if (string.len(specs[itemIndex]) * 9) > dropdownlist:GetWidth() then
			dropdownlist:SetSize((string.len(specs[itemIndex]) * 9) + 5, table.getn(specs) * 16 + 15);
		end
	end
end

function characterHasItem(itemId)
	local hasItem = false;
	if IsEquippedItem(itemId) then
		hasItem = true;
	else
		for i = 0, NUM_BAG_SLOTS do
		    for z = 1, GetContainerNumSlots(i) do
		        if GetContainerItemID(i, z) == itemId then
		        	hasItem = true;
		            break
		        end
		    end
		end
	end
	return hasItem;
end

local function createTooltipString(fontSize, x, y, title, text, r, g, b, parent)
	local tooltipString = parent:CreateFontString("tooltip" .. title, "OVERLAY");
	tooltipString:SetFontObject("GameFontHighlight");
	tooltipString:SetPoint("TOPLEFT", parent.TopLeft, "CENTER", x, y);
	tooltipString:SetText(text);
	tooltipString:SetFont("Fonts\\FRIZQT__.TTF", fontSize);
	tooltipString:SetTextColor(r, g, b, 1);

	return tooltipString;
end

local function createDropdown(title, x, y, width, height)
	local dropdown = CreateFrame("Frame", "BiSDropdown" .. title, MainFrame, "BiSFrameTemplate");
	dropdown:SetSize(width, height);
	dropdown:SetPoint("TOPLEFT", MainFrame.TopLeft, "TOPLEFT", x, y);

	dropdown.title = dropdown:CreateFontString(nil, "OVERLAY");
	dropdown.title:SetFontObject("GameFontHighlight");
	dropdown.title:SetPoint("LEFT", dropdown.Left, "CENTER", 5, 0);
	dropdown.title:SetText(title);
	dropdown.title:Show();

	dropdown.arrow = CreateFrame("Button", "BiSDropdownClassButton", dropdown);
	dropdown.arrow:SetSize(18, 18);
	dropdown.arrow:SetPoint("RIGHT", dropdown.Right, "CENTER", -3, 1);
	dropdown.arrow:SetNormalTexture("Interface\\AddOns\\BiSTracker\\assets\\DropdownArrow");
	dropdown.arrow:SetPushedTexture("Interface\\AddOns\\BiSTracker\\assets\\DropdownArrow");
	dropdown.arrow:SetHighlightTexture("Interface\\AddOns\\BiSTracker\\assets\\DropdownArrow", "ADD");
	dropdown.arrow:Show();
	dropdown:SetScript("OnMouseDown", function(self, event, ...)
		dropdownClick(title, dropdown);
	end)
	dropdown.arrow:SetScript("OnClick", function(self, event, ...)
		dropdownClick(title, dropdown);
	end)

	dropdown.bottomBorder = dropdown:CreateTexture("bottomBorder", "ARTWORK");
	dropdown.bottomBorder:SetPoint("BOTTOMLEFT", dropdown.BottomLeft, "BOTTOMLEFT", 5, 0);
	dropdown.bottomBorder:SetSize(width - 5, 2);
	dropdown.bottomBorder:SetTexture(135030);

	dropdown.dropdownList = CreateFrame("Frame", "BiSDropdownList" .. title, dropdown, "BiSFrameTemplate");
	dropdown.dropdownList:SetPoint("TOPLEFT", dropdown.BottomLeft, "TOPLEFT", 5, -3);
	dropdown.dropdownList:SetBackdrop(backdrop);
	dropdown.dropdownList:Hide();
	if title == "Class" then
		for itemIndex = 1, table.getn(classes) do
			local item = CreateFrame("Frame", classes[itemIndex], dropdown.dropdownList, "BiSFrameTemplate");
			item:SetBackdropColor(1, 1, 1, 0.1);
			item:SetPoint("LEFT", dropdown.dropdownList.TopLeft, "LEFT", 10, -1 * (itemIndex * 16) + 3);
			item:SetSize(100, 15);

			item.icon = item:CreateTexture(classes[itemIndex] .. "Icon", "ARTWORK");
			item.icon:SetPoint("LEFT", item.Left, "LEFT", 2, 0);
			item.icon:SetWidth(item:GetHeight());
			item.icon:SetHeight(item:GetHeight());
			item.icon:SetTexture(classIcons[itemIndex]);

			item.title = item:CreateFontString(classes[itemIndex] .. "Name", "OVERLAY");
			item.title:SetFontObject("GameFontHighlight");
			item.title:SetPoint("LEFT", item.Left, "CENTER", 14, 0);
			item.title:SetText(classes[itemIndex]);
			item.title:SetTextColor(1, 1, 1, 1);
			item:SetScript("OnEnter", function(self) 
				item:SetBackdropColor(0.2, 0.2, 0.2, 0.3);
				item.title:SetTextColor(0.86, 0.64, 0, 1);
			end);
			item:SetScript("OnLeave", function(self) 
				item:SetBackdropColor(1, 1, 1, 0.1);
				item.title:SetTextColor(1, 1, 1, 1);
			end);

			item:SetScript("OnMouseDown", function(self)
				class = item.title:GetText();

				if class == "Druid" then
					setDropdownListSize(druidSpecs, dropdowns[2].dropdownList, 100);
					spec = druidSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(druidSpecs[itemIndex]);
					end
				elseif class == "Hunter" then
					setDropdownListSize(hunterSpecs, dropdowns[2].dropdownList, 100);
					spec = hunterSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(hunterSpecs[itemIndex]);
					end
				elseif class == "Mage" then
					setDropdownListSize(mageSpecs, dropdowns[2].dropdownList, 100);
					spec = mageSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(mageSpecs[itemIndex]);
					end
				elseif class == "Paladin" then
					setDropdownListSize(paladinSpecs, dropdowns[2].dropdownList, 100);
					spec = paladinSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(paladinSpecs[itemIndex]);
					end
				elseif class == "Priest" then
					setDropdownListSize(priestSpecs, dropdowns[2].dropdownList, 100);
					spec = priestSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(priestSpecs[itemIndex]);
					end
				elseif class == "Rogue" then
					setDropdownListSize(rogueSpecs, dropdowns[2].dropdownList, 100);
					spec = rogueSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(rogueSpecs[itemIndex]);
					end
				elseif class == "Shaman" then
					setDropdownListSize(shamanSpecs, dropdowns[2].dropdownList, 100);
					spec = shamanSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(shamanSpecs[itemIndex]);
					end
				elseif class == "Warlock" then
					setDropdownListSize(warlockSpecs, dropdowns[2].dropdownList, 100);
					spec = warlockSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(warlockSpecs[itemIndex]);
					end
				elseif class == "Warrior" then
					setDropdownListSize(warriorSpecs, dropdowns[2].dropdownList, 100);
					spec = warriorSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(warriorSpecs[itemIndex]);
					end					
				end
				if class == "Custom" then
					setDropdownListSize(customSpecs, dropdowns[2].dropdownList, 100);
					if table.getn(customSpecs) > 1 then
						spec = customSpecs[2];
					else
						spec = customSpecs[1];
					end
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(customSpecs[itemIndex]);
					end	
					MainFrame.editSpec:Show();
					MainFrame.deleteSpec:Show();
				else

					MainFrame.editSpec:Hide();
					MainFrame.deleteSpec:Hide();
				end


				updateItemList();
			end)
			
			item:Show();

			--table.insert(dropdownItems, item);
			dropdown.dropdownList:SetSize(100, table.getn(classes) * 16 + 15);
		end
	elseif title == "Spec" then
		if class == "Druid" then
			createDropdownListSpecItems(druidSpecs, dropdown.dropdownList);
		elseif class == "Hunter" then
			createDropdownListSpecItems(hunterSpecs, dropdown.dropdownList);
		elseif class == "Mage" then
			createDropdownListSpecItems(mageSpecs, dropdown.dropdownList);
		elseif class == "Paladin" then
			createDropdownListSpecItems(paladinSpecs, dropdown.dropdownList);
		elseif class == "Priest" then
			createDropdownListSpecItems(priestSpecs, dropdown.dropdownList);
		elseif class == "Rogue" then
			createDropdownListSpecItems(rogueSpecs, dropdown.dropdownList);
		elseif class == "Shaman" then
			createDropdownListSpecItems(shamanSpecs, dropdown.dropdownList);
		elseif class == "Warlock" then
			createDropdownListSpecItems(warlockSpecs, dropdown.dropdownList);
		elseif class == "Warrior" then
			createDropdownListSpecItems(warriorSpecs, dropdown.dropdownList);
		elseif class == "Custom" then
			createDropdownListSpecItems(customSpecs, dropdown.dropdownList);
		end

	elseif title == "Phase" then
		for itemIndex = 1, table.getn(phases) do
			local item = CreateFrame("Frame", phases[itemIndex], dropdown.dropdownList, "BiSFrameTemplate");
			item:SetBackdropColor(1, 1, 1, 0.1);
			item:SetPoint("LEFT", dropdown.dropdownList.TopLeft, "LEFT", -2, -1 * (itemIndex * 16) + 3);
			item:SetSize(frameWidth, 15);

			item.title = item:CreateFontString(classes[itemIndex] .. "Name", "OVERLAY");
			item.title:SetFontObject("GameFontHighlight");
			item.title:SetPoint("LEFT", item.Left, "CENTER", 14, 0);
			item.title:SetText(phases[itemIndex]);
			if BiSData[class][spec][phases[itemIndex]] ~= nil then
				item.title:SetTextColor(1, 1, 1, 1);
				item:SetScript("OnEnter", function(self) 
					item:SetBackdropColor(0.2, 0.2, 0.2, 0.3);
					item.title:SetTextColor(0.86, 0.64, 0, 1);
				end);
				item:SetScript("OnLeave", function(self) 
					item:SetBackdropColor(1, 1, 1, 0.1);
					item.title:SetTextColor(1, 1, 1, 1);
				end);
				item:SetScript("OnMouseDown", function(self)
					phase = item.title:GetText();
					updateItemList();

				end);
			else
				item.title:SetTextColor(0.7, 0.7, 0.7, 1);
			end
			
			item:Show();

			table.insert(phaseItems, item);
			dropdown.dropdownList:SetSize(120, table.getn(phases) * 16 + 15);
		end
	end


	dropdown:Show();
	table.insert(dropdowns, dropdown);
	return dropdown;

end

local function updateSpecDropdown()
	setDropdownListSize(customSpecs, dropdowns[2].dropdownList, 100);
	if table.getn(customSpecs) > 1 then
		spec = customSpecs[2];
	else
		spec = customSpecs[1];
	end
	for itemIndex = 1, table.getn(specItems) do
		specItems[itemIndex].title:SetText(customSpecs[itemIndex]);
	end	
	updateItemList();
end

local function createCustomSpecBlock(title, parent, left, y)
	local item;
	if left then
		item = CreateFrame("Frame", "newSpecContent"..title, parent, "BiSFrameTemplate");
		item:SetSize((NewCustomSpecFrame.scrollFrame.content:GetWidth()-24)/2, 170);
		item:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, y);
	else 
		item = CreateFrame("Frame", "newSpecContent"..title, parent, "BiSFrameTemplate");
		item:SetSize((NewCustomSpecFrame.scrollFrame.content:GetWidth()-24)/2, 170);
		item:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -15, y);
	end

	
	item.title = item:CreateFontString(nil, "OVERLAY");
	item.title:SetPoint("TOP", item.Top, "TOP", 0, 0);
	item.title:SetFontObject("GameFontHighlight");
	item.title:SetText(title);

	item.idText = item:CreateFontString(nil, "OVERLAY");
	item.idText:SetPoint("TOPLEFT", item.TopLeft, "TOPLEFT", 5, -25);
	item.idText:SetFontObject("GameFontHighlight");
	item.idText:SetText("Item ID:");

	item.idEdit = CreateFrame("EditBox", "headEditBox", item, "InputBoxTemplate");
	item.idEdit:SetPoint("TOPRIGHT", item.TopRight, "TOPRIGHT", -5, -18);
	item.idEdit:SetSize(110, 24);		
	item.idEdit:SetAutoFocus(false);
	item.idEdit:SetNumeric(true);

	item.idEdit:SetScript("OnEnterPressed", function(self, value)
		item.idEdit:ClearFocus();
	end)

	item.zoneText = item:CreateFontString(nil, "OVERLAY");
	item.zoneText:SetPoint("TOPLEFT", item.TopLeft, "TOPLEFT", 5, -55);
	item.zoneText:SetFontObject("GameFontHighlight");
	item.zoneText:SetText("Zone:");

	item.zoneEdit = CreateFrame("EditBox", "headEditBox", item, "InputBoxTemplate");
	item.zoneEdit:SetPoint("TOPRIGHT", item.TopRight, "TOPRIGHT", -5, -48);
	item.zoneEdit:SetSize(110, 24);		
	item.zoneEdit:SetAutoFocus(false);

	item.zoneEdit:SetScript("OnEnterPressed", function(self, value)
		item.zoneEdit:ClearFocus();
	end)

	item.typeText = item:CreateFontString(nil, "OVERLAY");
	item.typeText:SetPoint("TOPLEFT", item.TopLeft, "TOPLEFT", 5, -85);
	item.typeText:SetFontObject("GameFontHighlight");
	item.typeText:SetText("Method: ");

	item.typeEdit = CreateFrame("EditBox", "headEditBox", item, "InputBoxTemplate");
	item.typeEdit:SetPoint("TOPRIGHT", item.TopRight, "TOPRIGHT", -5, -78);
	item.typeEdit:SetSize(110, 24);		
	item.typeEdit:SetAutoFocus(false);

	item.typeEdit:SetScript("OnEnterPressed", function(self, value)
		item.typeEdit:ClearFocus();
	end)

	item.methodText = item:CreateFontString(nil, "OVERLAY");
	item.methodText:SetPoint("TOPLEFT", item.TopLeft, "TOPLEFT", 5, -115);
	item.methodText:SetFontObject("GameFontHighlight");
	item.methodText:SetText("Npc/Quest: ");

	item.methodEdit = CreateFrame("EditBox", "headEditBox", item, "InputBoxTemplate");
	item.methodEdit:SetPoint("TOPRIGHT", item.TopRight, "TOPRIGHT", -5, -108);
	item.methodEdit:SetSize(90, 24);		
	item.methodEdit:SetAutoFocus(false);

	item.methodEdit:SetScript("OnEnterPressed", function(self, value)
		item.methodEdit:ClearFocus();
	end)

	item.dropText = item:CreateFontString(nil, "OVERLAY");
	item.dropText:SetPoint("TOPLEFT", item.TopLeft, "TOPLEFT", 5, -145);
	item.dropText:SetFontObject("GameFontHighlight");
	item.dropText:SetText("Drop chance: ");

	item.dropEdit = CreateFrame("EditBox", "headEditBox", item, "InputBoxTemplate");
	item.dropEdit:SetPoint("TOPRIGHT", item.TopRight, "TOPRIGHT", -5, -138);
	item.dropEdit:SetSize(80, 24);		
	item.dropEdit:SetAutoFocus(false);

	item.dropEdit:SetScript("OnEnterPressed", function(self, value)
		item.dropEdit:ClearFocus();
	end)

	return item;

end

MainFrame:SetScript("OnEvent", function(self, event, ...)
	local args = {...}
	if event == "PLAYER_LOGIN" then

		if type(BiS_Settings) ~= "table" then
			BiS_Settings = {}
			BiS_Settings["CustomSpecsData"] = customSpecData;
			BiS_Settings["CustomSpecs"] = customSpecs;
		else
			if BiS_Settings["CustomSpecsData"] ~= nil and BiS_Settings["CustomSpecs"] ~= nil then
				customSpecData = BiS_Settings["CustomSpecsData"];
				customSpecs = BiS_Settings["CustomSpecs"];
			else
				BiS_Settings["CustomSpecsData"] = customSpecData;
				BiS_Settings["CustomSpecs"] = customSpecs;
			end
		end
		
		MainFrame:SetBackdrop(backdrop);
		MainFrame:SetBackdropBorderColor(1, 1, 1, 1);
		MainFrame:SetBackdropColor(0, 0, 0, 1);
		MainFrame:SetPoint("TOPRIGHT", CharacterFrame, "TOPRIGHT", 220, -13)
		MainFrame:SetSize(frameWidth, frameHeight);

		MainFrame.title = MainFrame:CreateFontString(nil, "OVERLAY");
		MainFrame.title:SetFontObject("GameFontHighlight");
		MainFrame.title:SetPoint("LEFT", MainFrame.TopLeft, "LEFT", 10, -12);
		MainFrame.title:SetText("BiS Tracker");
		MainFrame.title:SetFont("Fonts\\FRIZQT__.TTF", 12);

		ExpandFrame = CreateFrame("Button", "BiSExpandButton", CharacterFrame);
		ExpandFrame:SetPoint("TOPRIGHT", CharacterFrame, "TOPRIGHT", -38, -43);
		ExpandFrame:SetSize(24, 24);
		ExpandFrame:Show();

		toggleWindow();
		ExpandFrame:SetScript("OnClick", function(self, event, ...)
			toggleWindow();
		end)

		ToastFrame = CreateFrame("Frame", "BiSToast", UIParent, "BiSFrameTemplate");
		ToastFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 400);
		ToastFrame:SetSize(300, 60);
		ToastFrame:SetBackdrop(backdrop);
		ToastFrame:SetBackdropBorderColor(1, 1, 1, 1);
		ToastFrame:SetBackdropColor(0, 0, 0, 1);
		ToastFrame:Hide();


		ToastFrame.title = ToastFrame:CreateFontString(nil, "OVERLAY");
		ToastFrame.title:SetPoint("TOP", ToastFrame.Top, "TOP", 0, -15);
		ToastFrame.title:SetFontObject("GameFontHighlight");
		ToastFrame.title:SetText("You have acquired a BiS Item!");
		ToastFrame.title:SetFont("Fonts\\FRIZQT__.TTF", 12);

		ToastFrame.itemName = ToastFrame:CreateFontString(nil, "OVERLAY");
		ToastFrame.itemName:SetPoint("TOP", ToastFrame.Top, "TOP", 0, -30);
		ToastFrame.itemName:SetFontObject("GameFontHighlight");
		ToastFrame.itemName:SetText("[Some random item]");
		ToastFrame.itemName:SetFont("Fonts\\FRIZQT__.TTF", 17);

		ConfirmDeleteFrame = CreateFrame("Frame", "BiSConfirmDeleteFrame", UIParent, "BiSFrameTemplate");
		ConfirmDeleteFrame:SetPoint("TOP", UIParent, "TOP", 0, -150);
		ConfirmDeleteFrame:SetSize(400, 100);
		ConfirmDeleteFrame:SetBackdrop(backdrop);
		ConfirmDeleteFrame:SetBackdropBorderColor(1, 1, 1, 1);
		ConfirmDeleteFrame:SetBackdropColor(0, 0, 0, 1);
		ConfirmDeleteFrame:Hide();

		ConfirmDeleteFrame.title = ConfirmDeleteFrame:CreateFontString(nil, "OVERLAY");
		ConfirmDeleteFrame.title:SetPoint("TOP", ConfirmDeleteFrame.Top, "TOP", 0, -20);
		ConfirmDeleteFrame.title:SetFontObject("GameFontHighlight");
		ConfirmDeleteFrame.title:SetText("You are about to remove the following spec: ");
		ConfirmDeleteFrame.title:SetFont("Fonts\\FRIZQT__.TTF", 15);

		ConfirmDeleteFrame.specName = ConfirmDeleteFrame:CreateFontString(nil, "OVERLAY");
		ConfirmDeleteFrame.specName:SetPoint("TOP", ConfirmDeleteFrame.Top, "TOP", 0, -40);
		ConfirmDeleteFrame.specName:SetFontObject("GameFontHighlight");
		ConfirmDeleteFrame.specName:SetFont("Fonts\\FRIZQT__.TTF", 15);

		ConfirmDeleteFrame.accept = CreateFrame("Button", "BiSConfirmDeleteFrameAccept", ConfirmDeleteFrame, "UIPanelButtonTemplate");
		ConfirmDeleteFrame.accept:SetPoint("BOTTOMLEFT", ConfirmDeleteFrame.BottomLeft, "BOTTOMLEFT", 17, 10);
		ConfirmDeleteFrame.accept:SetText("Proceed");
		ConfirmDeleteFrame.accept:SetSize(180, 30);

		ConfirmDeleteFrame.accept:SetScript("OnClick", function(self, value, ...)
			for x = 1, table.getn(customSpecs) do
				if customSpecs[x] == spec then
					table.remove(customSpecs, x);
				end
			end
			customSpecData[spec] = nil;

			spec = customSpecs[table.getn(customSpecs)];
			for itemIndex = 1, table.getn(specItems) do
				specItems[itemIndex].title:SetText(customSpecs[itemIndex]);
			end

			setDropdownListSize(customSpecs, dropdowns[2].dropdownList, 100);

			updateItemList();

			ConfirmDeleteFrame:Hide();
		end)


		ConfirmDeleteFrame.deny = CreateFrame("Button", "BiSConfirmDeleteFrameCancel", ConfirmDeleteFrame, "UIPanelButtonTemplate");
		ConfirmDeleteFrame.deny:SetPoint("BOTTOMRIGHT", ConfirmDeleteFrame.BottomRight, "BOTTOMRIGHT", -17, 10);
		ConfirmDeleteFrame.deny:SetText("Cancel");
		ConfirmDeleteFrame.deny:SetSize(180, 30);

		ConfirmDeleteFrame.deny:SetScript("OnClick", function(self, value, ...)
			ConfirmDeleteFrame:Hide();
		end)

		NewCustomSpecFrame = CreateFrame("Frame", "BiSnewCustomSpecFrame", UIParent, "BiSFrameTemplate");
		NewCustomSpecFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 50);
		NewCustomSpecFrame:SetSize(400, 600);
		NewCustomSpecFrame:SetBackdrop(backdrop);
		NewCustomSpecFrame:SetBackdropBorderColor(1, 1, 1, 1);
		NewCustomSpecFrame:SetBackdropColor(0, 0, 0, 1);
		NewCustomSpecFrame:Hide();

		NewCustomSpecFrame.title = NewCustomSpecFrame:CreateFontString(nil, "OVERLAY");
		NewCustomSpecFrame.title:SetPoint("TOP", NewCustomSpecFrame.Top, "TOP", 0, -10);
		NewCustomSpecFrame.title:SetFontObject("GameFontHighlight");
		NewCustomSpecFrame.title:SetText("Add a new custom spec");
		NewCustomSpecFrame.title:SetFont("Fonts\\FRIZQT__.TTF", 15);

		NewCustomSpecFrame.close = CreateFrame("Button", "CustomSpecClose", NewCustomSpecFrame, "UIPanelCloseButton");
		NewCustomSpecFrame.close:SetSize(32, 32);
		NewCustomSpecFrame.close:SetPoint("TOPRIGHT", NewCustomSpecFrame.TopRight, "TOPRIGHT", -2, -2);

		NewCustomSpecFrame.nameText = NewCustomSpecFrame:CreateFontString(nil, "OVERLAY");
		NewCustomSpecFrame.nameText:SetPoint("TOPLEFT", NewCustomSpecFrame.TopLeft, "TOPLEFT", 15, -38);
		NewCustomSpecFrame.nameText:SetFontObject("GameFontHighlight");
		NewCustomSpecFrame.nameText:SetText("Name of the spec:");
		NewCustomSpecFrame.nameText:SetFont("Fonts\\FRIZQT__.TTF", 13)

		NewCustomSpecFrame.nameEdit = CreateFrame("EditBox", "nameEditBox", NewCustomSpecFrame, "InputBoxTemplate");
		NewCustomSpecFrame.nameEdit:SetPoint("TOPRIGHT", NewCustomSpecFrame.TopRight, "TOPRIGHT", -35, -32);
		NewCustomSpecFrame.nameEdit:SetSize(220, 24);		
		NewCustomSpecFrame.nameEdit:SetAutoFocus(false);

		NewCustomSpecFrame.nameEdit:SetScript("OnEnterPressed", function(self, value)
			NewCustomSpecFrame.nameEdit:ClearFocus();
		end)

		NewCustomSpecFrame.scrollFrame = CreateFrame("ScrollFrame", nil, NewCustomSpecFrame);
		NewCustomSpecFrame.scrollFrame:SetPoint("TOPLEFT", 10, -68);
		NewCustomSpecFrame.scrollFrame:SetPoint("BOTTOMRIGHT", -10, 10);
		NewCustomSpecFrame.scrollFrame.texture = NewCustomSpecFrame.scrollFrame:CreateTexture();
		NewCustomSpecFrame.scrollFrame.texture:SetAllPoints();
		NewCustomSpecFrame.scrollFrame.texture:SetTexture(.5,.5,.5,1);

		NewCustomSpecFrame.scrollFrame.scrollBar = CreateFrame("Slider", nil, NewCustomSpecFrame.scrollFrame, "UIPanelScrollBarTemplate");
		NewCustomSpecFrame.scrollFrame.scrollBar:SetPoint("TOPLEFT", NewCustomSpecFrame, "TOPRIGHT", -24, -82);
		NewCustomSpecFrame.scrollFrame.scrollBar:SetPoint("BOTTOMLEFT", NewCustomSpecFrame, "BOTTOMRIGHT", -24, 24);
		NewCustomSpecFrame.scrollFrame.scrollBar:SetMinMaxValues(1, 1012);
		NewCustomSpecFrame.scrollFrame.scrollBar:SetValueStep(10);
		NewCustomSpecFrame.scrollFrame.scrollBar.scrollStep = 10;
		NewCustomSpecFrame.scrollFrame.scrollBar:SetValue(0);
		NewCustomSpecFrame.scrollFrame.scrollBar:SetWidth(16);
		NewCustomSpecFrame.scrollFrame.scrollBar:SetScript("OnValueChanged", function(self, value)
			self:GetParent():SetVerticalScroll(value);
		end)
		NewCustomSpecFrame.scrollFrame.scrollBar.scrollbg = NewCustomSpecFrame.scrollFrame.scrollBar:CreateTexture(nil, "BACKGROUND");
		NewCustomSpecFrame.scrollFrame.scrollBar.scrollbg:SetAllPoints(NewCustomSpecFrame.scrollFrame.scrollBar);
		NewCustomSpecFrame.scrollFrame.scrollBar.scrollbg:SetTexture(0, 0, 0, 0.4);

		NewCustomSpecFrame.scrollFrame.content = CreateFrame("Frame", nil, NewCustomSpecFrame.scrollFrame);
		NewCustomSpecFrame.scrollFrame.content:SetSize(376, 2000);

		NewCustomSpecFrame.scrollFrame.content:SetScript("OnMouseWheel", function(self, value)
			local scrollValue = self:GetParent():GetVerticalScroll();
			local scrollBarValue = self:GetParent().scrollBar:GetValue();
			if scrollValue - value*10 > 0 and scrollValue - value*10 < 1012 then 
				self:GetParent().scrollBar:SetValue(scrollBarValue - value*10);
				self:GetParent():SetVerticalScroll(scrollValue - value*10);
			else
				if (value == 1) then
					self:GetParent().scrollBar:SetValue(0);
					self:GetParent():SetVerticalScroll(0);
				else
					self:GetParent().scrollBar:SetValue(1012);
					self:GetParent():SetVerticalScroll(1012);
				end
			end
		end)

		NewCustomSpecFrame.scrollFrame.content.Head = createCustomSpecBlock("Head", NewCustomSpecFrame.scrollFrame.content, true, -5);
		NewCustomSpecFrame.scrollFrame.content.Neck = createCustomSpecBlock("Neck", NewCustomSpecFrame.scrollFrame.content, false, -5);
		NewCustomSpecFrame.scrollFrame.content.Shoulder = createCustomSpecBlock("Shoulder", NewCustomSpecFrame.scrollFrame.content, true, -175);
		NewCustomSpecFrame.scrollFrame.content.Cloak = createCustomSpecBlock("Cloak", NewCustomSpecFrame.scrollFrame.content, false, -175);
		NewCustomSpecFrame.scrollFrame.content.Chest = createCustomSpecBlock("Chest", NewCustomSpecFrame.scrollFrame.content, true, -345);
		NewCustomSpecFrame.scrollFrame.content.Wrist = createCustomSpecBlock("Wrist", NewCustomSpecFrame.scrollFrame.content, false, -345);
		NewCustomSpecFrame.scrollFrame.content.Gloves = createCustomSpecBlock("Gloves", NewCustomSpecFrame.scrollFrame.content, true, -515);
		NewCustomSpecFrame.scrollFrame.content.Waist = createCustomSpecBlock("Waist", NewCustomSpecFrame.scrollFrame.content, false, -515);
		NewCustomSpecFrame.scrollFrame.content.Legs = createCustomSpecBlock("Legs", NewCustomSpecFrame.scrollFrame.content, true, -685);
		NewCustomSpecFrame.scrollFrame.content.Boots = createCustomSpecBlock("Boots", NewCustomSpecFrame.scrollFrame.content, false, -685);
		NewCustomSpecFrame.scrollFrame.content.Ring1 = createCustomSpecBlock("Ring 1", NewCustomSpecFrame.scrollFrame.content, true, -855);
		NewCustomSpecFrame.scrollFrame.content.Ring2 = createCustomSpecBlock("Ring 2", NewCustomSpecFrame.scrollFrame.content, false, -855);
		NewCustomSpecFrame.scrollFrame.content.Trinket1 = createCustomSpecBlock("Trinket 1", NewCustomSpecFrame.scrollFrame.content, true, -1025);
		NewCustomSpecFrame.scrollFrame.content.Trinket2 = createCustomSpecBlock("Trinket 2", NewCustomSpecFrame.scrollFrame.content, false, -1025);
		NewCustomSpecFrame.scrollFrame.content.MainHand = createCustomSpecBlock("Main-hand", NewCustomSpecFrame.scrollFrame.content, true, -1195);
		NewCustomSpecFrame.scrollFrame.content.OffHand = createCustomSpecBlock("Off-hand", NewCustomSpecFrame.scrollFrame.content, false, -1195);
		NewCustomSpecFrame.scrollFrame.content.Ranged = createCustomSpecBlock("Ranged", NewCustomSpecFrame.scrollFrame.content, true, -1365);
		--NewCustomSpecFrame.scrollFrame.content.addBox = createCustomSpecBlock("Ranged", NewCustomSpecFrame.scrollFrame.content, false, -1365);

		NewCustomSpecFrame.scrollFrame.content.addBox = CreateFrame("Frame", nil, NewCustomSpecFrame.scrollFrame.content, "BiSFrameTemplate");
		NewCustomSpecFrame.scrollFrame.content.addBox:SetSize((NewCustomSpecFrame.scrollFrame.content:GetWidth()-24)/2, 170);
		NewCustomSpecFrame.scrollFrame.content.addBox:SetPoint("TOPRIGHT", NewCustomSpecFrame.scrollFrame.content, "TOPRIGHT", -15, -1365);

		NewCustomSpecFrame.scrollFrame.content.addBox.idText = NewCustomSpecFrame.scrollFrame.content.addBox:CreateFontString(nil, "OVERLAY");
		NewCustomSpecFrame.scrollFrame.content.addBox.idText:SetPoint("TOPLEFT", NewCustomSpecFrame.scrollFrame.content.addBox.TopLeft, "TOPLEFT", 5, -25);
		NewCustomSpecFrame.scrollFrame.content.addBox.idText:SetFontObject("GameFontHighlight");
		NewCustomSpecFrame.scrollFrame.content.addBox.idText:SetText("Phase:");

		NewCustomSpecFrame.scrollFrame.content.addBox.phaseDropdown = CreateFrame("Frame", "newSpecPhaseDropdown", NewCustomSpecFrame.scrollFrame.content.addBox, "UIDropDownMenuTemplate");
		NewCustomSpecFrame.scrollFrame.content.addBox.phaseDropdown:SetPoint("TOPRIGHT", NewCustomSpecFrame.scrollFrame.content.addBox, "TOPRIGHT", 15, -14);
		UIDropDownMenu_SetWidth(NewCustomSpecFrame.scrollFrame.content.addBox.phaseDropdown, 110);
		UIDropDownMenu_SetText(NewCustomSpecFrame.scrollFrame.content.addBox.phaseDropdown, "Phase1");

		--[[item.idEdit = CreateFrame("EditBox", "headEditBox", item, "InputBoxTemplate");
		item.idEdit:SetPoint("TOPRIGHT", item.TopRight, "TOPRIGHT", -5, -18);
		item.idEdit:SetSize(110, 24);		
		item.idEdit:SetAutoFocus(false);
		item.idEdit:SetNumeric(true);]]

		local function UIDropDownMenu_OnClick(self, arg1, arg2, checked)
			UIDropDownMenu_SetSelectedValue(NewCustomSpecFrame.scrollFrame.content.addBox.phaseDropdown, self.value);
			newSpecPhase = arg1;
		end

		UIDropDownMenu_Initialize(NewCustomSpecFrame.scrollFrame.content.addBox.phaseDropdown, function(self, level, menuList)
			local info = UIDropDownMenu_CreateInfo();
			info.func = UIDropDownMenu_OnClick;
			info.text, info.arg1, info.checked = "Phase1", "Phase1", false;
			UIDropDownMenu_AddButton(info);
			info.text, info.arg1, info.checked = "Phase2PreRaid", "Phase2PreRaid", false;
			UIDropDownMenu_AddButton(info);
			info.text, info.arg1, info.checked = "Phase2", "Phase2", false;
			UIDropDownMenu_AddButton(info);
			info.text, info.arg1, info.checked = "Phase3", "Phase3", false;
			UIDropDownMenu_AddButton(info);
			info.text, info.arg1, info.checked = "Phase4", "Phase4", false;
			UIDropDownMenu_AddButton(info);
			info.text, info.arg1, info.checked = "Phase5", "Phase5", false;
			UIDropDownMenu_AddButton(info);
			info.text, info.arg1, info.checked = "Phase6", "Phase6", false;
			UIDropDownMenu_AddButton(info);
			
		end)
		UIDropDownMenu_SetSelectedValue(NewCustomSpecFrame.scrollFrame.content.addBox.phaseDropdown, "Phase1");





		NewCustomSpecFrame.scrollFrame.content.addSpecBtn = CreateFrame("Button", "test", NewCustomSpecFrame.scrollFrame.content, "UIPanelButtonTemplate");
		NewCustomSpecFrame.scrollFrame.content.addSpecBtn:SetSize(120, 32);
		NewCustomSpecFrame.scrollFrame.content.addSpecBtn:SetPoint("TOPRIGHT", NewCustomSpecFrame.scrollFrame.content, "TOPRIGHT", -40, -1435);
		NewCustomSpecFrame.scrollFrame.content.addSpecBtn:SetText("Add Spec");
		NewCustomSpecFrame.scrollFrame.content.addSpecBtn:SetScript("OnClick", function(self)
			local name = NewCustomSpecFrame.nameEdit:GetText();

			local items = {
				Head = {
					itemID = 0,
					Obtain = {
						Zone = "",
						Type = "",
						Method = "",
						Drop = "",
					}
				},Neck = {
					itemID = 0,
					Obtain = {
						Zone = "",
						Type = "",
						Method = "",
						Drop = "",
					}
				},
				Shoulder = {
					itemID = 0,
					Obtain = {
						Zone = "",
						Type = "",
						Method = "",
						Drop = "",
					}
				},
				Cloak = {
					itemID = 0,
					Obtain = {
						Zone = "",
						Type = "",
						Method = "",
						Drop = "",
					}
				},
				Chest = {
					itemID = 0,
					Obtain = {
						Zone = "",
						Type = "",
						Method = "",
						Drop = "",
					}
				},
				Wrist = {
					itemID = 0,
					Obtain = {
						Zone = "",
						Type = "",
						Method = "",
						Drop = "",
					}
				},
				Gloves = {
					itemID = 0,
					Obtain = {
						Zone = "",
						Type = "",
						Method = "",
						Drop = "",
					}
				},
				Waist = {
					itemID = 0,
					Obtain = {
						Zone = "",
						Type = "",
						Method = "",
						Drop = "",
					}
				},
				Legs = {
					itemID = 0,
					Obtain = {
						Zone = "",
						Type = "",
						Method = "",
						Drop = "",
					}
				},
				Boots = {
					itemID = 0,
					Obtain = {
						Zone = "",
						Type = "",
						Method = "",
						Drop = "",
					}
				},
				Ring1 = {
					itemID = 0,
					Obtain = {
						Zone = "",
						Type = "",
						Method = "",
						Drop = "",
					}
				},
				Ring2 = {
					itemID = 0,
					Obtain = {
						Zone = "",
						Type = "",
						Method = "",
						Drop = "",
					}
				},
				Trinket1 = {
					itemID = 0,
					Obtain = {
						Zone = "",
						Type = "",
						Method = "",
						Drop = "",
					}
				},
				Trinket2 = {
					itemID = 0,
					Obtain = {
						Zone = "",
						Type = "",
						Method = "",
						Drop = "",
					}
				},
				MainHand = {
					itemID = 0,
					Obtain = {
						Zone = "",
						Type = "",
						Method = "",
						Drop = "",
					}
				},
				OffHand = {
					itemID = 0,
					Obtain = {
						Zone = "",
						Type = "",
						Method = "",
						Drop = "",
					}
				},
				Ranged = {
					itemID = 0,
					Obtain = {
						Zone = "",
						Type = "",
						Method = "",
						Drop = "",
					}
				},
			}

			items["Head"]["itemID"] = NewCustomSpecFrame.scrollFrame.content.Head.idEdit:GetNumber();
			items["Head"]["Obtain"]["Zone"] = NewCustomSpecFrame.scrollFrame.content.Head.zoneEdit:GetText();
			items["Head"]["Obtain"]["Type"] = NewCustomSpecFrame.scrollFrame.content.Head.typeEdit:GetText();
			items["Head"]["Obtain"]["Method"] = NewCustomSpecFrame.scrollFrame.content.Head.methodEdit:GetText();
			items["Head"]["Obtain"]["Drop"] = NewCustomSpecFrame.scrollFrame.content.Head.dropEdit:GetText();

			items["Neck"]["itemID"] = NewCustomSpecFrame.scrollFrame.content.Neck.idEdit:GetNumber();
			items["Neck"]["Obtain"]["Zone"] = NewCustomSpecFrame.scrollFrame.content.Neck.zoneEdit:GetText();
			items["Neck"]["Obtain"]["Type"] = NewCustomSpecFrame.scrollFrame.content.Neck.typeEdit:GetText();
			items["Neck"]["Obtain"]["Method"] = NewCustomSpecFrame.scrollFrame.content.Neck.methodEdit:GetText();
			items["Neck"]["Obtain"]["Drop"] = NewCustomSpecFrame.scrollFrame.content.Neck.dropEdit:GetText();

			items["Shoulder"]["itemID"] = NewCustomSpecFrame.scrollFrame.content.Shoulder.idEdit:GetNumber();
			items["Shoulder"]["Obtain"]["Zone"] = NewCustomSpecFrame.scrollFrame.content.Shoulder.zoneEdit:GetText();
			items["Shoulder"]["Obtain"]["Type"] = NewCustomSpecFrame.scrollFrame.content.Shoulder.typeEdit:GetText();
			items["Shoulder"]["Obtain"]["Method"] = NewCustomSpecFrame.scrollFrame.content.Shoulder.methodEdit:GetText();
			items["Shoulder"]["Obtain"]["Drop"] = NewCustomSpecFrame.scrollFrame.content.Shoulder.dropEdit:GetText();

			items["Cloak"]["itemID"] = NewCustomSpecFrame.scrollFrame.content.Cloak.idEdit:GetNumber();
			items["Cloak"]["Obtain"]["Zone"] = NewCustomSpecFrame.scrollFrame.content.Cloak.zoneEdit:GetText();
			items["Cloak"]["Obtain"]["Type"] = NewCustomSpecFrame.scrollFrame.content.Cloak.typeEdit:GetText();
			items["Cloak"]["Obtain"]["Method"] = NewCustomSpecFrame.scrollFrame.content.Cloak.methodEdit:GetText();
			items["Cloak"]["Obtain"]["Drop"] = NewCustomSpecFrame.scrollFrame.content.Cloak.dropEdit:GetText();

			items["Chest"]["itemID"] = NewCustomSpecFrame.scrollFrame.content.Chest.idEdit:GetNumber();
			items["Chest"]["Obtain"]["Zone"] = NewCustomSpecFrame.scrollFrame.content.Chest.zoneEdit:GetText();
			items["Chest"]["Obtain"]["Type"] = NewCustomSpecFrame.scrollFrame.content.Chest.typeEdit:GetText();
			items["Chest"]["Obtain"]["Method"] = NewCustomSpecFrame.scrollFrame.content.Chest.methodEdit:GetText();
			items["Chest"]["Obtain"]["Drop"] = NewCustomSpecFrame.scrollFrame.content.Chest.dropEdit:GetText();

			items["Wrist"]["itemID"] = NewCustomSpecFrame.scrollFrame.content.Wrist.idEdit:GetNumber();
			items["Wrist"]["Obtain"]["Zone"] = NewCustomSpecFrame.scrollFrame.content.Wrist.zoneEdit:GetText();
			items["Wrist"]["Obtain"]["Type"] = NewCustomSpecFrame.scrollFrame.content.Wrist.typeEdit:GetText();
			items["Wrist"]["Obtain"]["Method"] = NewCustomSpecFrame.scrollFrame.content.Wrist.methodEdit:GetText();
			items["Wrist"]["Obtain"]["Drop"] = NewCustomSpecFrame.scrollFrame.content.Wrist.dropEdit:GetText();

			items["Gloves"]["itemID"] = NewCustomSpecFrame.scrollFrame.content.Gloves.idEdit:GetNumber();
			items["Gloves"]["Obtain"]["Zone"] = NewCustomSpecFrame.scrollFrame.content.Gloves.zoneEdit:GetText();
			items["Gloves"]["Obtain"]["Type"] = NewCustomSpecFrame.scrollFrame.content.Gloves.typeEdit:GetText();
			items["Gloves"]["Obtain"]["Method"] = NewCustomSpecFrame.scrollFrame.content.Gloves.methodEdit:GetText();
			items["Gloves"]["Obtain"]["Drop"] = NewCustomSpecFrame.scrollFrame.content.Gloves.dropEdit:GetText();

			items["Waist"]["itemID"] = NewCustomSpecFrame.scrollFrame.content.Waist.idEdit:GetNumber();
			items["Waist"]["Obtain"]["Zone"] = NewCustomSpecFrame.scrollFrame.content.Waist.zoneEdit:GetText();
			items["Waist"]["Obtain"]["Type"] = NewCustomSpecFrame.scrollFrame.content.Waist.typeEdit:GetText();
			items["Waist"]["Obtain"]["Method"] = NewCustomSpecFrame.scrollFrame.content.Waist.methodEdit:GetText();
			items["Waist"]["Obtain"]["Drop"] = NewCustomSpecFrame.scrollFrame.content.Waist.dropEdit:GetText();

			items["Legs"]["itemID"] = NewCustomSpecFrame.scrollFrame.content.Legs.idEdit:GetNumber();
			items["Legs"]["Obtain"]["Zone"] = NewCustomSpecFrame.scrollFrame.content.Legs.zoneEdit:GetText();
			items["Legs"]["Obtain"]["Type"] = NewCustomSpecFrame.scrollFrame.content.Legs.typeEdit:GetText();
			items["Legs"]["Obtain"]["Method"] = NewCustomSpecFrame.scrollFrame.content.Legs.methodEdit:GetText();
			items["Legs"]["Obtain"]["Drop"] = NewCustomSpecFrame.scrollFrame.content.Legs.dropEdit:GetText();

			items["Boots"]["itemID"] = NewCustomSpecFrame.scrollFrame.content.Boots.idEdit:GetNumber();
			items["Boots"]["Obtain"]["Zone"] = NewCustomSpecFrame.scrollFrame.content.Boots.zoneEdit:GetText();
			items["Boots"]["Obtain"]["Type"] = NewCustomSpecFrame.scrollFrame.content.Boots.typeEdit:GetText();
			items["Boots"]["Obtain"]["Method"] = NewCustomSpecFrame.scrollFrame.content.Boots.methodEdit:GetText();
			items["Boots"]["Obtain"]["Drop"] = NewCustomSpecFrame.scrollFrame.content.Boots.dropEdit:GetText();

			items["Ring1"]["itemID"] = NewCustomSpecFrame.scrollFrame.content.Ring1.idEdit:GetNumber();
			items["Ring1"]["Obtain"]["Zone"] = NewCustomSpecFrame.scrollFrame.content.Ring1.zoneEdit:GetText();
			items["Ring1"]["Obtain"]["Type"] = NewCustomSpecFrame.scrollFrame.content.Ring1.typeEdit:GetText();
			items["Ring1"]["Obtain"]["Method"] = NewCustomSpecFrame.scrollFrame.content.Ring1.methodEdit:GetText();
			items["Ring1"]["Obtain"]["Drop"] = NewCustomSpecFrame.scrollFrame.content.Ring1.dropEdit:GetText();

			items["Ring2"]["itemID"] = NewCustomSpecFrame.scrollFrame.content.Ring2.idEdit:GetNumber();
			items["Ring2"]["Obtain"]["Zone"] = NewCustomSpecFrame.scrollFrame.content.Ring2.zoneEdit:GetText();
			items["Ring2"]["Obtain"]["Type"] = NewCustomSpecFrame.scrollFrame.content.Ring2.typeEdit:GetText();
			items["Ring2"]["Obtain"]["Method"] = NewCustomSpecFrame.scrollFrame.content.Ring2.methodEdit:GetText();
			items["Ring2"]["Obtain"]["Drop"] = NewCustomSpecFrame.scrollFrame.content.Ring2.dropEdit:GetText();

			items["Trinket1"]["itemID"] = NewCustomSpecFrame.scrollFrame.content.Trinket1.idEdit:GetNumber();
			items["Trinket1"]["Obtain"]["Zone"] = NewCustomSpecFrame.scrollFrame.content.Trinket1.zoneEdit:GetText();
			items["Trinket1"]["Obtain"]["Type"] = NewCustomSpecFrame.scrollFrame.content.Trinket1.typeEdit:GetText();
			items["Trinket1"]["Obtain"]["Method"] = NewCustomSpecFrame.scrollFrame.content.Trinket1.methodEdit:GetText();
			items["Trinket1"]["Obtain"]["Drop"] = NewCustomSpecFrame.scrollFrame.content.Trinket1.dropEdit:GetText();

			items["Trinket2"]["itemID"] = NewCustomSpecFrame.scrollFrame.content.Trinket2.idEdit:GetNumber();
			items["Trinket2"]["Obtain"]["Zone"] = NewCustomSpecFrame.scrollFrame.content.Trinket2.zoneEdit:GetText();
			items["Trinket2"]["Obtain"]["Type"] = NewCustomSpecFrame.scrollFrame.content.Trinket2.typeEdit:GetText();
			items["Trinket2"]["Obtain"]["Method"] = NewCustomSpecFrame.scrollFrame.content.Trinket2.methodEdit:GetText();
			items["Trinket2"]["Obtain"]["Drop"] = NewCustomSpecFrame.scrollFrame.content.Trinket2.dropEdit:GetText();

			items["MainHand"]["itemID"] = NewCustomSpecFrame.scrollFrame.content.MainHand.idEdit:GetNumber();
			items["MainHand"]["Obtain"]["Zone"] = NewCustomSpecFrame.scrollFrame.content.MainHand.zoneEdit:GetText();
			items["MainHand"]["Obtain"]["Type"] = NewCustomSpecFrame.scrollFrame.content.MainHand.typeEdit:GetText();
			items["MainHand"]["Obtain"]["Method"] = NewCustomSpecFrame.scrollFrame.content.MainHand.methodEdit:GetText();
			items["MainHand"]["Obtain"]["Drop"] = NewCustomSpecFrame.scrollFrame.content.MainHand.dropEdit:GetText();

			items["OffHand"]["itemID"] = NewCustomSpecFrame.scrollFrame.content.OffHand.idEdit:GetNumber();
			items["OffHand"]["Obtain"]["Zone"] = NewCustomSpecFrame.scrollFrame.content.OffHand.zoneEdit:GetText();
			items["OffHand"]["Obtain"]["Type"] = NewCustomSpecFrame.scrollFrame.content.OffHand.typeEdit:GetText();
			items["OffHand"]["Obtain"]["Method"] = NewCustomSpecFrame.scrollFrame.content.OffHand.methodEdit:GetText();
			items["OffHand"]["Obtain"]["Drop"] = NewCustomSpecFrame.scrollFrame.content.OffHand.dropEdit:GetText();

			items["Ranged"]["itemID"] = NewCustomSpecFrame.scrollFrame.content.Ranged.idEdit:GetNumber();
			items["Ranged"]["Obtain"]["Zone"] = NewCustomSpecFrame.scrollFrame.content.Ranged.zoneEdit:GetText();
			items["Ranged"]["Obtain"]["Type"] = NewCustomSpecFrame.scrollFrame.content.Ranged.typeEdit:GetText();
			items["Ranged"]["Obtain"]["Method"] = NewCustomSpecFrame.scrollFrame.content.Ranged.methodEdit:GetText();
			items["Ranged"]["Obtain"]["Drop"] = NewCustomSpecFrame.scrollFrame.content.Ranged.dropEdit:GetText();


			if type(customSpecData[name]) ~= "table" then
				table.insert(customSpecs, name);
				customSpecData[name] = {};
				spec = name;

				if (table.getn(customSpecs) > table.getn(specItems)) then

					local listItem = CreateFrame("Frame", nil, dropdowns[2].dropdownList, "BiSFrameTemplate");
					listItem:SetBackdropColor(1, 1, 1, 0.1);
					listItem:SetPoint("LEFT", dropdowns[2].dropdownList.TopLeft, "LEFT", -2, -1 * ((table.getn(specItems) + 1) * 16) + 3);
					listItem:SetSize(frameWidth, 15);

					listItem.title = listItem:CreateFontString(nil, "OVERLAY");
					listItem.title:SetFontObject("GameFontHighlight");
					listItem.title:SetPoint("LEFT", listItem.Left, "CENTER", 14, 0);
					listItem.title:SetTextColor(1, 1, 1, 1);
					listItem.title:SetText(name);
					listItem:SetScript("OnEnter", function(self) 
						listItem:SetBackdropColor(0.2, 0.2, 0.2, 0.3);
						listItem.title:SetTextColor(0.86, 0.64, 0, 1);
					end);
					listItem:SetScript("OnLeave", function(self) 
						listItem:SetBackdropColor(1, 1, 1, 0.1);
						listItem.title:SetTextColor(1, 1, 1, 1);
					end);
					listItem:SetScript("OnMouseDown", function(self)
						if (listItem.title:GetText() == customSpecs[1]) then
							editSpec = false;
							NewCustomSpecFrame.title:SetText("Add a new custom spec");
							NewCustomSpecFrame.scrollFrame.content.addSpecBtn:SetText("Add Spec");

							NewCustomSpecFrame.nameEdit:SetText("");

							NewCustomSpecFrame.scrollFrame.content.Head.idEdit:SetNumber(0);
							NewCustomSpecFrame.scrollFrame.content.Head.zoneEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Head.typeEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Head.methodEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Head.dropEdit:SetText("");

							NewCustomSpecFrame.scrollFrame.content.Neck.idEdit:SetNumber(0);
							NewCustomSpecFrame.scrollFrame.content.Neck.zoneEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Neck.typeEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Neck.methodEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Neck.dropEdit:SetText("");

							NewCustomSpecFrame.scrollFrame.content.Shoulder.idEdit:SetNumber(0);
							NewCustomSpecFrame.scrollFrame.content.Shoulder.zoneEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Shoulder.typeEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Shoulder.methodEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Shoulder.dropEdit:SetText("");

							NewCustomSpecFrame.scrollFrame.content.Cloak.idEdit:SetNumber(0);
							NewCustomSpecFrame.scrollFrame.content.Cloak.zoneEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Cloak.typeEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Cloak.methodEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Cloak.dropEdit:SetText("");

							NewCustomSpecFrame.scrollFrame.content.Chest.idEdit:SetNumber(0);
							NewCustomSpecFrame.scrollFrame.content.Chest.zoneEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Chest.typeEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Chest.methodEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Chest.dropEdit:SetText("");

							NewCustomSpecFrame.scrollFrame.content.Wrist.idEdit:SetNumber(0);
							NewCustomSpecFrame.scrollFrame.content.Wrist.zoneEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Wrist.typeEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Wrist.methodEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Wrist.dropEdit:SetText("");

							NewCustomSpecFrame.scrollFrame.content.Gloves.idEdit:SetNumber(0);
							NewCustomSpecFrame.scrollFrame.content.Gloves.zoneEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Gloves.typeEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Gloves.methodEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Gloves.dropEdit:SetText("");

							NewCustomSpecFrame.scrollFrame.content.Waist.idEdit:SetNumber(0);
							NewCustomSpecFrame.scrollFrame.content.Waist.zoneEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Waist.typeEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Waist.methodEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Waist.dropEdit:SetText("");

							NewCustomSpecFrame.scrollFrame.content.Legs.idEdit:SetNumber(0);
							NewCustomSpecFrame.scrollFrame.content.Legs.zoneEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Legs.typeEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Legs.methodEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Legs.dropEdit:SetText("");

							NewCustomSpecFrame.scrollFrame.content.Boots.idEdit:SetNumber(0);
							NewCustomSpecFrame.scrollFrame.content.Boots.zoneEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Boots.typeEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Boots.methodEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Boots.dropEdit:SetText("");

							NewCustomSpecFrame.scrollFrame.content.Ring1.idEdit:SetNumber(0);
							NewCustomSpecFrame.scrollFrame.content.Ring1.zoneEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Ring1.typeEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Ring1.methodEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Ring1.dropEdit:SetText("");

							NewCustomSpecFrame.scrollFrame.content.Ring2.idEdit:SetNumber(0);
							NewCustomSpecFrame.scrollFrame.content.Ring2.zoneEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Ring2.typeEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Ring2.methodEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Ring2.dropEdit:SetText("");

							NewCustomSpecFrame.scrollFrame.content.Trinket1.idEdit:SetNumber(0);
							NewCustomSpecFrame.scrollFrame.content.Trinket1.zoneEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Trinket1.typeEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Trinket1.methodEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Trinket1.dropEdit:SetText("");

							NewCustomSpecFrame.scrollFrame.content.Trinket2.idEdit:SetNumber(0);
							NewCustomSpecFrame.scrollFrame.content.Trinket2.zoneEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Trinket2.typeEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Trinket2.methodEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Trinket2.dropEdit:SetText("");

							NewCustomSpecFrame.scrollFrame.content.MainHand.idEdit:SetNumber(0);
							NewCustomSpecFrame.scrollFrame.content.MainHand.zoneEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.MainHand.typeEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.MainHand.methodEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.MainHand.dropEdit:SetText("");

							NewCustomSpecFrame.scrollFrame.content.OffHand.idEdit:SetNumber(0);
							NewCustomSpecFrame.scrollFrame.content.OffHand.zoneEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.OffHand.typeEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.OffHand.methodEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.OffHand.dropEdit:SetText("");

							NewCustomSpecFrame.scrollFrame.content.Ranged.idEdit:SetNumber(0);
							NewCustomSpecFrame.scrollFrame.content.Ranged.zoneEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Ranged.typeEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Ranged.methodEdit:SetText("");
							NewCustomSpecFrame.scrollFrame.content.Ranged.dropEdit:SetText("");

							UIDropDownMenu_SetSelectedValue(NewCustomSpecFrame.scrollFrame.content.addBox.phaseDropdown, "Phase1");

							NewCustomSpecFrame:Show();



						else
							spec = listItem.title:GetText();
						end
						for x = 1, table.getn(phaseItems) do
							if class == "Custom" then 
								if customSpecData[spec][phases[x]] ~= nil then
									phaseItems[x].title:SetTextColor(1, 1, 1, 1);
									phaseItems[x]:SetScript("OnEnter", function(self) 
										phaseItems[x]:SetBackdropColor(0.2, 0.2, 0.2, 0.3);
										phaseItems[x].title:SetTextColor(0.86, 0.64, 0, 1);
									end);
									phaseItems[x]:SetScript("OnLeave", function(self) 
										phaseItems[x]:SetBackdropColor(1, 1, 1, 0.1);
										phaseItems[x].title:SetTextColor(1, 1, 1, 1);
									end);
									phaseItems[x]:SetScript("OnMouseDown", function(self)
										phase = phaseItems[x].title:GetText();
										updateItemList();

									end);
								else
									phaseItems[x].title:SetTextColor(0.7, 0.7, 0.7, 1);
									phaseItems[x]:SetScript("OnEnter", function(self)
									end);
									phaseItems[x]:SetScript("OnLeave", function(self)
									end);
									phaseItems[x]:SetScript("OnMouseDown", function(self)
									end);
								end
							else
								if BiSData[class][spec][phases[x]] ~= nil then
									phaseItems[x].title:SetTextColor(1, 1, 1, 1);
									phaseItems[x]:SetScript("OnEnter", function(self) 
										phaseItems[x]:SetBackdropColor(0.2, 0.2, 0.2, 0.3);
										phaseItems[x].title:SetTextColor(0.86, 0.64, 0, 1);
									end);
									phaseItems[x]:SetScript("OnLeave", function(self) 
										phaseItems[x]:SetBackdropColor(1, 1, 1, 0.1);
										phaseItems[x].title:SetTextColor(1, 1, 1, 1);
									end);
									phaseItems[x]:SetScript("OnMouseDown", function(self)
										phase = phaseItems[x].title:GetText();
										updateItemList();

									end);
								else
									phaseItems[x].title:SetTextColor(0.7, 0.7, 0.7, 1);
									phaseItems[x]:SetScript("OnEnter", function(self)
									end);
									phaseItems[x]:SetScript("OnLeave", function(self)
									end);
									phaseItems[x]:SetScript("OnMouseDown", function(self)
									end);
								end
							end
						end
						updateItemList();
					end);
					listItem:Show();

					table.insert(specItems, listItem);
				else
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(customSpecs[itemIndex]);
					end
				end

				if string.len(name) * 9 > dropdowns[2].dropdownList:GetWidth() then
					dropdowns[2].dropdownList:SetSize(string.len(name) * 9 + 10, table.getn(customSpecs) * 16 + 15);
				else
					dropdowns[2].dropdownList:SetHeight(table.getn(customSpecs) * 16 + 15);
				end
			end
			customSpecData[name][newSpecPhase] = items;
			for x = 1, table.getn(phaseItems) do
				if class == "Custom" then 
					if customSpecData[spec][phases[x]] ~= nil then
						phaseItems[x].title:SetTextColor(1, 1, 1, 1);
						phaseItems[x]:SetScript("OnEnter", function(self) 
							phaseItems[x]:SetBackdropColor(0.2, 0.2, 0.2, 0.3);
							phaseItems[x].title:SetTextColor(0.86, 0.64, 0, 1);
						end);
						phaseItems[x]:SetScript("OnLeave", function(self) 
							phaseItems[x]:SetBackdropColor(1, 1, 1, 0.1);
							phaseItems[x].title:SetTextColor(1, 1, 1, 1);
						end);
						phaseItems[x]:SetScript("OnMouseDown", function(self)
							phase = phaseItems[x].title:GetText();
							updateItemList();

						end);
					else
						phaseItems[x].title:SetTextColor(0.7, 0.7, 0.7, 1);
						phaseItems[x]:SetScript("OnEnter", function(self)
						end);
						phaseItems[x]:SetScript("OnLeave", function(self)
						end);
						phaseItems[x]:SetScript("OnMouseDown", function(self)
						end);
					end
				else
					if BiSData[class][spec][phases[x]] ~= nil then
						phaseItems[x].title:SetTextColor(1, 1, 1, 1);
						phaseItems[x]:SetScript("OnEnter", function(self) 
							phaseItems[x]:SetBackdropColor(0.2, 0.2, 0.2, 0.3);
							phaseItems[x].title:SetTextColor(0.86, 0.64, 0, 1);
						end);
						phaseItems[x]:SetScript("OnLeave", function(self) 
							phaseItems[x]:SetBackdropColor(1, 1, 1, 0.1);
							phaseItems[x].title:SetTextColor(1, 1, 1, 1);
						end);
						phaseItems[x]:SetScript("OnMouseDown", function(self)
							phase = phaseItems[x].title:GetText();
							updateItemList();

						end);
					else
						phaseItems[x].title:SetTextColor(0.7, 0.7, 0.7, 1);
						phaseItems[x]:SetScript("OnEnter", function(self)
						end);
						phaseItems[x]:SetScript("OnLeave", function(self)
						end);
						phaseItems[x]:SetScript("OnMouseDown", function(self)
						end);
					end
				end
			end
			updateItemList();
			NewCustomSpecFrame:Hide();
		end)

		NewCustomSpecFrame.scrollFrame:SetScrollChild(NewCustomSpecFrame.scrollFrame.content);



		MainFrame.tip = CreateFrame("GAMETOOLTIP", "$parentToolTip", UIParent, "GameTooltipTemplate");
		MainFrame.tip:SetOwner(MainFrame, "ANCHOR_NONE");
		MainFrame.tip:SetPoint("TOPLEFT", CharacterFrame, "TOPRIGHT", 220, -13);


		MainFrame.tooltip = CreateFrame("Frame", "BiSTooltip", MainFrame, "BiSFrameTemplate");
		MainFrame.tooltip:SetSize(250, 300);
		MainFrame.tooltip:SetPoint("TOPLEFT", CharacterFrame, "TOPRIGHT", 220, -13);
		MainFrame.tooltip:SetBackdrop(backdrop);
		MainFrame.tooltip:SetBackdropBorderColor(1, 1, 1, 1);
		MainFrame.tooltip:SetBackdropColor(0, 0, 0, 1);
		MainFrame.tooltip:Hide();

		MainFrame.tooltip.icon = MainFrame.tooltip:CreateTexture("toolTipIcon", "ARTWORK");
		MainFrame.tooltip.icon:SetPoint("TOPRIGHT", MainFrame.tooltip.TopRight, "TOPRIGHT", -8, -8);
		MainFrame.tooltip.icon:SetSize(64,64);
		MainFrame.tooltip.icon:SetTexture(133176);

		MainFrame.tooltip.playerHasItem = MainFrame.tooltip:CreateTexture("tooltipPlayerHasIcon", "OVERLAY");
		MainFrame.tooltip.playerHasItem:SetPoint("TOPRIGHT", MainFrame.tooltip.TopRight, "TOPRIGHT", -16, -16);
		MainFrame.tooltip.playerHasItem:SetSize(12,12);
		MainFrame.tooltip.playerHasItem:SetTexture(137564);

		MainFrame.tooltip.title = createTooltipString(18, 8, -16, "Title", "Item Name", 0.63, 0.2, 0.92, MainFrame.tooltip);
		MainFrame.tooltip.acquire = createTooltipString(13, 8, -40, "Acquire", "Binds when equipped", 1, 1, 1, MainFrame.tooltip);
		MainFrame.tooltip.levelRequirement = createTooltipString(13, 8, -56, "LevelRequirement", "Requires level 43", 1, 1, 1, MainFrame.tooltip);
		MainFrame.tooltip.type = createTooltipString(13, 8, -72, "Type", "Two-Hand", 1, 1, 1, MainFrame.tooltip);
		MainFrame.tooltip.subType = createTooltipString(13, 120, -72, "SubType", "Staff", 1, 1, 1, MainFrame.tooltip);
		MainFrame.tooltip.weaponDamage = createTooltipString(13, 8, -88, "WeaponDamage", "89 - 134 Damage", 1, 1, 1, MainFrame.tooltip);
		MainFrame.tooltip.weaponSpeed = createTooltipString(13, 150, -88, "Speed", "Speed 2.40", 1, 1, 1, MainFrame.tooltip);
		MainFrame.tooltip.dps = createTooltipString(13, 8, -104, "WeaponDps", "(46.46 Damage per second)", 1, 1, 1, MainFrame.tooltip);
		MainFrame.tooltip.weaponStats = createTooltipString(13, 8, -120, "WeaponStats", "260 Armor \n +11 Stamina", 1, 1, 1, MainFrame.tooltip);
		MainFrame.tooltip.gearStats = createTooltipString(13, 8, -88, "GearStats", "260 Armor\n+11 Stamina\n+5 Agility\n+50 intellect\n+5 Agility", 1, 1, 1, MainFrame.tooltip);

		MainFrame.tooltipObtain = CreateFrame("Frame", "BiSTooltipObtain", MainFrame, "BiSFrameTemplate");
		MainFrame.tooltipObtain:SetSize(250, 100);
		MainFrame.tooltipObtain:SetPoint("TOPLEFT", MainFrame.BottomLeft, "BOTTOMLEFT", 3, 2);
		MainFrame.tooltipObtain:SetBackdrop(backdrop);
		MainFrame.tooltipObtain:SetBackdropBorderColor(1, 1, 1, 1);
		MainFrame.tooltipObtain:SetBackdropColor(0, 0, 0, 1);

		MainFrame.tooltipObtain.title = createTooltipString(13, 8, -8, "ObtainTitle", "This item is acquired in:", 0.54, 0, 0.32, MainFrame.tooltipObtain);
		MainFrame.tooltipObtain.zone = createTooltipString(13, 8, -28, "ObtainZone", "Hillsbrad Foothills", 0, 0.87, 0, MainFrame.tooltipObtain);
		MainFrame.tooltipObtain.Type = createTooltipString(13, 8, -42, "ObtainType", "By Quest:", 0, 0.87, 0, MainFrame.tooltipObtain);
		MainFrame.tooltipObtain.Method = createTooltipString(13, 8, -58, "ObtainType", "Some Quest", 0, 0.87, 0, MainFrame.tooltipObtain);
		MainFrame.tooltipObtain.Drop = createTooltipString(13, 8, -74, "ObtainType", "Drop Chance: Guaranteed", 0, 0.87, 0, MainFrame.tooltipObtain);
		MainFrame.tooltipObtain:Hide();


		MainFrame.editSpec = CreateFrame("Button", "BiSEditSpecButton", MainFrame);
		MainFrame.editSpec:SetSize(18, 18);
		MainFrame.editSpec:SetPoint("RIGHT", MainFrame.TopRight, "CENTER", -50, -14);
		MainFrame.editSpec:SetNormalTexture("Interface\\AddOns\\BiSTracker\\assets\\pentest");
		MainFrame.editSpec:SetPushedTexture("Interface\\AddOns\\BiSTracker\\assets\\pentest");
		MainFrame.editSpec:SetHighlightTexture("Interface\\AddOns\\BiSTracker\\assets\\pen50", "ADD");
		MainFrame.editSpec:Hide();

		MainFrame.editSpec:SetScript("OnClick", function(self, event, ...)
			if table.getn(customSpecs) > 1 then
				editSpec = true;
				NewCustomSpecFrame.title:SetText("Edit spec");
				NewCustomSpecFrame.scrollFrame.content.addSpecBtn:SetText("Apply Changes");

				NewCustomSpecFrame.nameEdit:SetText(spec);

				NewCustomSpecFrame.scrollFrame.content.Head.idEdit:SetNumber(customSpecData[spec][phase]["Head"]["itemID"]);
				NewCustomSpecFrame.scrollFrame.content.Head.zoneEdit:SetText(customSpecData[spec][phase]["Head"]["Obtain"]["Zone"]);
				NewCustomSpecFrame.scrollFrame.content.Head.typeEdit:SetText(customSpecData[spec][phase]["Head"]["Obtain"]["Type"]);
				NewCustomSpecFrame.scrollFrame.content.Head.methodEdit:SetText(customSpecData[spec][phase]["Head"]["Obtain"]["Method"]);
				NewCustomSpecFrame.scrollFrame.content.Head.dropEdit:SetText(customSpecData[spec][phase]["Head"]["Obtain"]["Drop"]);

				NewCustomSpecFrame.scrollFrame.content.Neck.idEdit:SetNumber(customSpecData[spec][phase]["Neck"]["itemID"]);
				NewCustomSpecFrame.scrollFrame.content.Neck.zoneEdit:SetText(customSpecData[spec][phase]["Neck"]["Obtain"]["Zone"]);
				NewCustomSpecFrame.scrollFrame.content.Neck.typeEdit:SetText(customSpecData[spec][phase]["Neck"]["Obtain"]["Type"]);
				NewCustomSpecFrame.scrollFrame.content.Neck.methodEdit:SetText(customSpecData[spec][phase]["Neck"]["Obtain"]["Method"]);
				NewCustomSpecFrame.scrollFrame.content.Neck.dropEdit:SetText(customSpecData[spec][phase]["Neck"]["Obtain"]["Drop"]);

				NewCustomSpecFrame.scrollFrame.content.Shoulder.idEdit:SetNumber(customSpecData[spec][phase]["Shoulder"]["itemID"]);
				NewCustomSpecFrame.scrollFrame.content.Shoulder.zoneEdit:SetText(customSpecData[spec][phase]["Shoulder"]["Obtain"]["Zone"]);
				NewCustomSpecFrame.scrollFrame.content.Shoulder.typeEdit:SetText(customSpecData[spec][phase]["Shoulder"]["Obtain"]["Type"]);
				NewCustomSpecFrame.scrollFrame.content.Shoulder.methodEdit:SetText(customSpecData[spec][phase]["Shoulder"]["Obtain"]["Method"]);
				NewCustomSpecFrame.scrollFrame.content.Shoulder.dropEdit:SetText(customSpecData[spec][phase]["Shoulder"]["Obtain"]["Drop"]);

				NewCustomSpecFrame.scrollFrame.content.Cloak.idEdit:SetNumber(customSpecData[spec][phase]["Cloak"]["itemID"]);
				NewCustomSpecFrame.scrollFrame.content.Cloak.zoneEdit:SetText(customSpecData[spec][phase]["Cloak"]["Obtain"]["Zone"]);
				NewCustomSpecFrame.scrollFrame.content.Cloak.typeEdit:SetText(customSpecData[spec][phase]["Cloak"]["Obtain"]["Type"]);
				NewCustomSpecFrame.scrollFrame.content.Cloak.methodEdit:SetText(customSpecData[spec][phase]["Cloak"]["Obtain"]["Method"]);
				NewCustomSpecFrame.scrollFrame.content.Cloak.dropEdit:SetText(customSpecData[spec][phase]["Cloak"]["Obtain"]["Drop"]);

				NewCustomSpecFrame.scrollFrame.content.Chest.idEdit:SetNumber(customSpecData[spec][phase]["Chest"]["itemID"]);
				NewCustomSpecFrame.scrollFrame.content.Chest.zoneEdit:SetText(customSpecData[spec][phase]["Chest"]["Obtain"]["Zone"]);
				NewCustomSpecFrame.scrollFrame.content.Chest.typeEdit:SetText(customSpecData[spec][phase]["Chest"]["Obtain"]["Type"]);
				NewCustomSpecFrame.scrollFrame.content.Chest.methodEdit:SetText(customSpecData[spec][phase]["Chest"]["Obtain"]["Method"]);
				NewCustomSpecFrame.scrollFrame.content.Chest.dropEdit:SetText(customSpecData[spec][phase]["Chest"]["Obtain"]["Drop"]);

				NewCustomSpecFrame.scrollFrame.content.Wrist.idEdit:SetNumber(customSpecData[spec][phase]["Wrist"]["itemID"]);
				NewCustomSpecFrame.scrollFrame.content.Wrist.zoneEdit:SetText(customSpecData[spec][phase]["Wrist"]["Obtain"]["Zone"]);
				NewCustomSpecFrame.scrollFrame.content.Wrist.typeEdit:SetText(customSpecData[spec][phase]["Wrist"]["Obtain"]["Type"]);
				NewCustomSpecFrame.scrollFrame.content.Wrist.methodEdit:SetText(customSpecData[spec][phase]["Wrist"]["Obtain"]["Method"]);
				NewCustomSpecFrame.scrollFrame.content.Wrist.dropEdit:SetText(customSpecData[spec][phase]["Wrist"]["Obtain"]["Drop"]);

				NewCustomSpecFrame.scrollFrame.content.Gloves.idEdit:SetNumber(customSpecData[spec][phase]["Gloves"]["itemID"]);
				NewCustomSpecFrame.scrollFrame.content.Gloves.zoneEdit:SetText(customSpecData[spec][phase]["Gloves"]["Obtain"]["Zone"]);
				NewCustomSpecFrame.scrollFrame.content.Gloves.typeEdit:SetText(customSpecData[spec][phase]["Gloves"]["Obtain"]["Type"]);
				NewCustomSpecFrame.scrollFrame.content.Gloves.methodEdit:SetText(customSpecData[spec][phase]["Gloves"]["Obtain"]["Method"]);
				NewCustomSpecFrame.scrollFrame.content.Gloves.dropEdit:SetText(customSpecData[spec][phase]["Gloves"]["Obtain"]["Drop"]);

				NewCustomSpecFrame.scrollFrame.content.Waist.idEdit:SetNumber(customSpecData[spec][phase]["Waist"]["itemID"]);
				NewCustomSpecFrame.scrollFrame.content.Waist.zoneEdit:SetText(customSpecData[spec][phase]["Waist"]["Obtain"]["Zone"]);
				NewCustomSpecFrame.scrollFrame.content.Waist.typeEdit:SetText(customSpecData[spec][phase]["Waist"]["Obtain"]["Type"]);
				NewCustomSpecFrame.scrollFrame.content.Waist.methodEdit:SetText(customSpecData[spec][phase]["Waist"]["Obtain"]["Method"]);
				NewCustomSpecFrame.scrollFrame.content.Waist.dropEdit:SetText(customSpecData[spec][phase]["Waist"]["Obtain"]["Drop"]);

				NewCustomSpecFrame.scrollFrame.content.Legs.idEdit:SetNumber(customSpecData[spec][phase]["Legs"]["itemID"]);
				NewCustomSpecFrame.scrollFrame.content.Legs.zoneEdit:SetText(customSpecData[spec][phase]["Legs"]["Obtain"]["Zone"]);
				NewCustomSpecFrame.scrollFrame.content.Legs.typeEdit:SetText(customSpecData[spec][phase]["Legs"]["Obtain"]["Type"]);
				NewCustomSpecFrame.scrollFrame.content.Legs.methodEdit:SetText(customSpecData[spec][phase]["Legs"]["Obtain"]["Method"]);
				NewCustomSpecFrame.scrollFrame.content.Legs.dropEdit:SetText(customSpecData[spec][phase]["Legs"]["Obtain"]["Drop"]);

				NewCustomSpecFrame.scrollFrame.content.Boots.idEdit:SetNumber(customSpecData[spec][phase]["Boots"]["itemID"]);
				NewCustomSpecFrame.scrollFrame.content.Boots.zoneEdit:SetText(customSpecData[spec][phase]["Boots"]["Obtain"]["Zone"]);
				NewCustomSpecFrame.scrollFrame.content.Boots.typeEdit:SetText(customSpecData[spec][phase]["Boots"]["Obtain"]["Type"]);
				NewCustomSpecFrame.scrollFrame.content.Boots.methodEdit:SetText(customSpecData[spec][phase]["Boots"]["Obtain"]["Method"]);
				NewCustomSpecFrame.scrollFrame.content.Boots.dropEdit:SetText(customSpecData[spec][phase]["Boots"]["Obtain"]["Drop"]);

				NewCustomSpecFrame.scrollFrame.content.Ring1.idEdit:SetNumber(customSpecData[spec][phase]["Ring1"]["itemID"]);
				NewCustomSpecFrame.scrollFrame.content.Ring1.zoneEdit:SetText(customSpecData[spec][phase]["Ring1"]["Obtain"]["Zone"]);
				NewCustomSpecFrame.scrollFrame.content.Ring1.typeEdit:SetText(customSpecData[spec][phase]["Ring1"]["Obtain"]["Type"]);
				NewCustomSpecFrame.scrollFrame.content.Ring1.methodEdit:SetText(customSpecData[spec][phase]["Ring1"]["Obtain"]["Method"]);
				NewCustomSpecFrame.scrollFrame.content.Ring1.dropEdit:SetText(customSpecData[spec][phase]["Ring1"]["Obtain"]["Drop"]);

				NewCustomSpecFrame.scrollFrame.content.Ring2.idEdit:SetNumber(customSpecData[spec][phase]["Ring2"]["itemID"]);
				NewCustomSpecFrame.scrollFrame.content.Ring2.zoneEdit:SetText(customSpecData[spec][phase]["Ring2"]["Obtain"]["Zone"]);
				NewCustomSpecFrame.scrollFrame.content.Ring2.typeEdit:SetText(customSpecData[spec][phase]["Ring2"]["Obtain"]["Type"]);
				NewCustomSpecFrame.scrollFrame.content.Ring2.methodEdit:SetText(customSpecData[spec][phase]["Ring2"]["Obtain"]["Method"]);
				NewCustomSpecFrame.scrollFrame.content.Ring2.dropEdit:SetText(customSpecData[spec][phase]["Ring2"]["Obtain"]["Drop"]);

				NewCustomSpecFrame.scrollFrame.content.Trinket1.idEdit:SetNumber(customSpecData[spec][phase]["Trinket1"]["itemID"]);
				NewCustomSpecFrame.scrollFrame.content.Trinket1.zoneEdit:SetText(customSpecData[spec][phase]["Trinket1"]["Obtain"]["Zone"]);
				NewCustomSpecFrame.scrollFrame.content.Trinket1.typeEdit:SetText(customSpecData[spec][phase]["Trinket1"]["Obtain"]["Type"]);
				NewCustomSpecFrame.scrollFrame.content.Trinket1.methodEdit:SetText(customSpecData[spec][phase]["Trinket1"]["Obtain"]["Method"]);
				NewCustomSpecFrame.scrollFrame.content.Trinket1.dropEdit:SetText(customSpecData[spec][phase]["Trinket1"]["Obtain"]["Drop"]);

				NewCustomSpecFrame.scrollFrame.content.Trinket2.idEdit:SetNumber(customSpecData[spec][phase]["Trinket2"]["itemID"]);
				NewCustomSpecFrame.scrollFrame.content.Trinket2.zoneEdit:SetText(customSpecData[spec][phase]["Trinket2"]["Obtain"]["Zone"]);
				NewCustomSpecFrame.scrollFrame.content.Trinket2.typeEdit:SetText(customSpecData[spec][phase]["Trinket2"]["Obtain"]["Type"]);
				NewCustomSpecFrame.scrollFrame.content.Trinket2.methodEdit:SetText(customSpecData[spec][phase]["Trinket2"]["Obtain"]["Method"]);
				NewCustomSpecFrame.scrollFrame.content.Trinket2.dropEdit:SetText(customSpecData[spec][phase]["Trinket2"]["Obtain"]["Drop"]);

				NewCustomSpecFrame.scrollFrame.content.MainHand.idEdit:SetNumber(customSpecData[spec][phase]["MainHand"]["itemID"]);
				NewCustomSpecFrame.scrollFrame.content.MainHand.zoneEdit:SetText(customSpecData[spec][phase]["MainHand"]["Obtain"]["Zone"]);
				NewCustomSpecFrame.scrollFrame.content.MainHand.typeEdit:SetText(customSpecData[spec][phase]["MainHand"]["Obtain"]["Type"]);
				NewCustomSpecFrame.scrollFrame.content.MainHand.methodEdit:SetText(customSpecData[spec][phase]["MainHand"]["Obtain"]["Method"]);
				NewCustomSpecFrame.scrollFrame.content.MainHand.dropEdit:SetText(customSpecData[spec][phase]["MainHand"]["Obtain"]["Drop"]);

				NewCustomSpecFrame.scrollFrame.content.OffHand.idEdit:SetNumber(customSpecData[spec][phase]["OffHand"]["itemID"]);
				NewCustomSpecFrame.scrollFrame.content.OffHand.zoneEdit:SetText(customSpecData[spec][phase]["OffHand"]["Obtain"]["Zone"]);
				NewCustomSpecFrame.scrollFrame.content.OffHand.typeEdit:SetText(customSpecData[spec][phase]["OffHand"]["Obtain"]["Type"]);
				NewCustomSpecFrame.scrollFrame.content.OffHand.methodEdit:SetText(customSpecData[spec][phase]["OffHand"]["Obtain"]["Method"]);
				NewCustomSpecFrame.scrollFrame.content.OffHand.dropEdit:SetText(customSpecData[spec][phase]["OffHand"]["Obtain"]["Drop"]);

				NewCustomSpecFrame.scrollFrame.content.Ranged.idEdit:SetNumber(customSpecData[spec][phase]["Ranged"]["itemID"]);
				NewCustomSpecFrame.scrollFrame.content.Ranged.zoneEdit:SetText(customSpecData[spec][phase]["Ranged"]["Obtain"]["Zone"]);
				NewCustomSpecFrame.scrollFrame.content.Ranged.typeEdit:SetText(customSpecData[spec][phase]["Ranged"]["Obtain"]["Type"]);
				NewCustomSpecFrame.scrollFrame.content.Ranged.methodEdit:SetText(customSpecData[spec][phase]["Ranged"]["Obtain"]["Method"]);
				NewCustomSpecFrame.scrollFrame.content.Ranged.dropEdit:SetText(customSpecData[spec][phase]["Ranged"]["Obtain"]["Drop"]);

				UIDropDownMenu_SetSelectedValue(NewCustomSpecFrame.scrollFrame.content.addBox.phaseDropdown, phase);

				NewCustomSpecFrame:Show();
			end

		end)

		MainFrame.deleteSpec = CreateFrame("Button", "BiSDeleteSpecButton", MainFrame);
		MainFrame.deleteSpec:SetSize(18, 18);
		MainFrame.deleteSpec:SetPoint("RIGHT", MainFrame.TopRight, "CENTER", -27, -14);
		MainFrame.deleteSpec:SetNormalTexture("Interface\\AddOns\\BiSTracker\\assets\\delete");
		MainFrame.deleteSpec:SetPushedTexture("Interface\\AddOns\\BiSTracker\\assets\\delete");
		MainFrame.deleteSpec:SetHighlightTexture("Interface\\AddOns\\BiSTracker\\assets\\delete", "ADD");
		MainFrame.deleteSpec:Hide();

		MainFrame.deleteSpec:SetScript("OnClick", function(self, event, ...)
			if table.getn(customSpecs) > 1 then
				ConfirmDeleteFrame.specName:SetText(spec);
				ConfirmDeleteFrame:Show();
			end
		end)

		MainFrame.reload = CreateFrame("Button", "BiSReloadButton", MainFrame);
		MainFrame.reload:SetSize(18, 18);
		MainFrame.reload:SetPoint("RIGHT", MainFrame.TopRight, "CENTER", -6, -14);
		MainFrame.reload:SetNormalTexture("Interface\\AddOns\\BiSTracker\\assets\\reload");
		MainFrame.reload:SetPushedTexture("Interface\\AddOns\\BiSTracker\\assets\\reload");
		MainFrame.reload:SetHighlightTexture("Interface\\AddOns\\BiSTracker\\assets\\reload", "ADD");
		MainFrame.reload:Show();

		MainFrame.reload:SetScript("OnClick", function(self, event, ...)
			updateItemList();
		end)

		MainFrame.dropdownClass = createDropdown("Class", 10, -33, 75, 18);
		MainFrame.dropdownSpec = createDropdown("Spec", 90, -33, 75, 18);
		MainFrame.dropdownPhase = createDropdown("Phase", 170, -33, 75, 18);


		updateItemList()
	elseif event == "CHAT_MSG_LOOT" then
    
        local lootstring, _, _, _, player = ...
        local itemLink = string.match(lootstring,"|%x+|Hitem:.-|h.-|h|r");
        local itemString = string.match(itemLink, "item[%-?%d:]+");
        local newItemString = string.sub(itemString, 6);
        local itemId = string.match(newItemString, "%d+");
 
        if UnitName("player") == player then
        	if bisCurrentClassSpecData[itemId] ~= nil then
        		if string.len(bisCurrentClassSpecData[itemId].itemName) * 14 < 300 then
        			ToastFrame:SetSize(300, 60)
        		else
        			ToastFrame:SetSize(50 + (string.len(bisCurrentClassSpecData[itemId].itemName) * 14), 60)
        		end
        		ToastFrame.itemName:SetText(bisCurrentClassSpecData[itemId].itemName);
        		ToastFrame.itemName:SetTextColor(bisCurrentClassSpecData[itemId].titleRed, bisCurrentClassSpecData[itemId].titleGreen, bisCurrentClassSpecData[itemId].titleBlue);
		        UIFrameFadeIn(ToastFrame, .300, 0, 1);
		        C_Timer.After(2.5, function()
					UIFrameFadeOut(ToastFrame, 1, 1, 0);
		    	end)
        	end
        end

		updateItemList();
	elseif event == "ADDON_LOADED" then
        if args[1] == "BiSTracker" then
            print(loadMessage);
            print(contributorMessage);
        end
    elseif event == "PLAYER_LOGOUT" then
		BiS_Settings["CustomSpecsData"] = customSpecData;
		BiS_Settings["CustomSpecs"] = customSpecs;
    end
end);
