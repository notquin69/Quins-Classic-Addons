local MainFrame = CreateFrame("Frame", "BiSMainFrame", CharacterFrame, "BiSFrameTemplate")--, "ThinBorderTemplate")
MainFrame:RegisterEvent("PLAYER_LOGIN")
MainFrame:RegisterEvent("CHAT_MSG_LOOT");
MainFrame:RegisterEvent("ADDON_LOADED");

local addonVersion = "1.2.0";
local contributors = "Wizm-Mograine PvP";

local loadMessageStart = "|cFF00FFB0" .. "BiSTracker" .. ": |r";
local loadMessage = loadMessageStart .. "|cff00cc66Version |r" .. addonVersion .. "|cff00cc66, developed and maintained by|r Yekru-Mograine PvP";
local contributorMessage = loadMessageStart .. "|cff00cc66Contributors: |r" .. contributors;







if type(BiS_Settings) ~= "table" then
	BiS_Settings = {}
else

end


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

local class = "Druid";
local spec = "FeralDps";
local phase = "Phase1";

local classes = {
	"Druid",
	"Hunter",
	"Mage",
	"Paladin",
	"Priest",
	"Rogue",
	"Shaman",
	"Warlock",
	"Warrior"
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
	135328
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
			if class == "Druid" then

				if spec == "FeralTank" then

					if phase == "Phase1" then

						return BiSData.Druid.FeralTank.Phase1;

					elseif phase == "Phase2PreRaid" then 

						return BiSData.Druid.FeralTank.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Druid.FeralTank.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Druid.FeralTank.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Druid.FeralTank.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Druid.FeralTank.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Druid.FeralTank.Phase6;

					else 

						return "Error";

					end

				elseif spec == "FeralDps" then

					if phase == "Phase1" then

						return BiSData.Druid.FeralDps.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Druid.FeralDps.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Druid.FeralDps.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Druid.FeralDps.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Druid.FeralDps.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Druid.FeralDps.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Druid.FeralDps.Phase6;

					else 

						return "Error";

					end

				elseif spec == "Restoration" then

					if phase == "Phase1" then

						return BiSData.Druid.Restoration.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Druid.Restoration.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Druid.Restoration.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Druid.Restoration.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Druid.Restoration.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Druid.Restoration.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Druid.Restoration.Phase6;

					else 

						return "Error";

					end

				elseif spec == "Balance" then

					if phase == "Phase1" then

						return BiSData.Druid.Balance.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Druid.Balance.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Druid.Balance.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Druid.Balance.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Druid.Balance.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Druid.Balance.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Druid.Balance.Phase6;

					else 

						return "Error";

					end

				end

			elseif class == "Hunter" then
				if spec == "All" then

					if phase == "Phase1" then

						return BiSData.Hunter.All.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Hunter.All.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Hunter.All.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Hunter.All.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Hunter.All.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Hunter.All.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Hunter.All.Phase6;

					else 

						return "Error";

					end

				end

			elseif class == "Mage" then
				if spec == "All" then

					if phase == "Phase1" then

						return BiSData.Mage.All.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Mage.All.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Mage.All.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Mage.All.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Mage.All.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Mage.All.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Mage.All.Phase6;

					else 

						return "Error";

					end

				end

			elseif class == "Paladin" then
				if spec == "Holy" then

					if phase == "Phase1" then

						return BiSData.Paladin.Holy.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Paladin.Holy.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Paladin.Holy.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Paladin.Holy.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Paladin.Holy.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Paladin.Holy.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Paladin.Holy.Phase6;

					else 

						return "Error";

					end

				elseif spec == "Retribution" then

					if phase == "Phase1" then

						return BiSData.Paladin.Retribution.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Paladin.Retribution.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Paladin.Retribution.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Paladin.Retribution.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Paladin.Retribution.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Paladin.Retribution.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Paladin.Retribution.Phase6;

					else 

						return "Error";

					end

				elseif spec == "Protection" then

					if phase == "Phase1" then

						return BiSData.Paladin.Protection.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Paladin.Protection.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Paladin.Protection.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Paladin.Protection.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Paladin.Protection.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Paladin.Protection.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Paladin.Protection.Phase6;

					else 

						return "Error";

					end

				end

			elseif class == "Priest" then
				if spec == "Holy" then

					if phase == "Phase1" then

						return BiSData.Priest.Holy.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Priest.Holy.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Priest.Holy.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Priest.Holy.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Priest.Holy.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Priest.Holy.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Priest.Holy.Phase6;

					else 

						return "Error";

					end

				elseif spec == "Hybrid" then

					if phase == "Phase1" then

						return BiSData.Priest.Hybrid.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Priest.Hybrid.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Priest.Hybrid.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Priest.Hybrid.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Priest.Hybrid.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Priest.Hybrid.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Priest.Hybrid.Phase6;

					else 

						return "Error";

					end

				elseif spec == "Shadow" then

					if phase == "Phase1" then

						return BiSData.Priest.Shadow.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Priest.Shadow.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Priest.Shadow.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Priest.Shadow.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Priest.Shadow.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Priest.Shadow.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Priest.Shadow.Phase6;

					else 

						return "Error";

					end

				end


			elseif class == "Rogue" then
				if spec == "Swords" then

					if phase == "Phase1" then

						return BiSData.Rogue.Swords.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Rogue.Swords.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Rogue.Swords.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Rogue.Swords.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Rogue.Swords.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Rogue.Swords.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Rogue.Swords.Phase6;

					else 

						return "Error";

					end

				elseif spec == "Daggers" then

					if phase == "Phase1" then

						return BiSData.Rogue.Daggers.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Rogue.Daggers.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Rogue.Daggers.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Rogue.Daggers.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Rogue.Daggers.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Rogue.Daggers.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Rogue.Daggers.Phase6;

					else 

						return "Error";

					end

				end

			elseif class == "Shaman" then
				if spec == "Elemental" then

					if phase == "Phase1" then

						return BiSData.Shaman.Elemental.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Shaman.Elemental.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Shaman.Elemental.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Shaman.Elemental.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Shaman.Elemental.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Shaman.Elemental.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Shaman.Elemental.Phase6;

					else 

						return "Error";

					end

				elseif spec == "Restoration" then

					if phase == "Phase1" then

						return BiSData.Shaman.Restoration.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Shaman.Restoration.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Shaman.Restoration.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Shaman.Restoration.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Shaman.Restoration.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Shaman.Restoration.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Shaman.Restoration.Phase6;

					else 

						return "Error";

					end

				elseif spec == "Enhancement" then

					if phase == "Phase1" then

						return BiSData.Shaman.Enhancement.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Shaman.Enhancement.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Shaman.Enhancement.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Shaman.Enhancement.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Shaman.Enhancement.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Shaman.Enhancement.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Shaman.Enhancement.Phase6;

					else 

						return "Error";

					end

				end

			elseif class == "Warlock" then
				if spec == "All" then

					if phase == "Phase1" then

						return BiSData.Warlock.All.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Warlock.All.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Warlock.All.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Warlock.All.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Warlock.All.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Warlock.All.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Warlock.All.Phase6;

					else 

						return "Error";

					end

				end

			elseif class == "Warrior" then
				if spec == "Fury" then

					if phase == "Phase1" then

						return BiSData.Warrior.Fury.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Warrior.Fury.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Warrior.Fury.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Warrior.Fury.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Warrior.Fury.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Warrior.Fury.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Warrior.Fury.Phase6;

					else 

						return "Error";

					end

				elseif spec == "Protection" then

					if phase == "Phase1" then

						return BiSData.Warrior.Protection.Phase1;

					elseif phase == "Phase2PreRaid" then

						return BiSData.Warrior.Protection.Phase2PreRaid;

					elseif phase == "Phase2" then

						return BiSData.Warrior.Protection.Phase2;

					elseif phase == "Phase3" then

						return BiSData.Warrior.Protection.Phase3;

					elseif phase == "Phase4" then

						return BiSData.Warrior.Protection.Phase4;

					elseif phase == "Phase5" then

						return BiSData.Warrior.Protection.Phase5;

					elseif phase == "Phase6" then

						return BiSData.Warrior.Protection.Phase6;

					else 

						return "Error";

					end

				end

			else 

				return "Error";

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
		--print(key .. " - " .. value);
		if key == "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" then
			damageTable.dps = math.ceil(value*100)*0.01;
		elseif key == "" then
			damageTable.damage = value;
		end
	end
	return damageTable;
end


local function updateItemList()
	local itemData = getItemData();
	bisCurrentClassSpecData = {};

	if table.getn(items) == 0 then
		for itemIndex = 1, table.getn(itemSlots) do
			local listItemName = "";
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent;
			if itemData[itemSlots[itemIndex]].itemID ~= 0 then
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
						MainFrame.tip:AddLine(itemData[itemSlots[itemIndex]].Obtain.Type)
;						MainFrame.tip:AddLine(itemData[itemSlots[itemIndex]].Obtain.Method);
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
					--print(getItemStats(itemData[itemSlots[itemIndex]].itemID));
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
				SetItemRef(itemLink, itemLink, "LeftButton");
			end)

			item:Show();

			table.insert(items, item);

		end
	else
		for itemIndex = 1, table.getn(itemSlots) do
			local listItemName = "";
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent;
			if itemData[itemSlots[itemIndex]].itemID ~= 0 then
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
						MainFrame.tip:AddLine(itemData[itemSlots[itemIndex]].Obtain.Type)
;						MainFrame.tip:AddLine(itemData[itemSlots[itemIndex]].Obtain.Method);
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
					--print(getItemStats(itemData[itemSlots[itemIndex]].itemID));
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
				SetItemRef(itemLink, itemLink, "LeftButton");
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
	--print(title .." Pushed");

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
				spec = item.title:GetText();
				updateItemList();
			end);

			item:Show();

			table.insert(specItems, item);
			dropdownlist:SetSize(100, table.getn(specs) * 16 + 15);
			
		end
end

function characterHasItem(itemId)
	local hasItem = false;
	if IsEquippedItem(itemId) then
		hasItem = true;
		--print("Equipped");
	else
		for i = 0, NUM_BAG_SLOTS do
		    for z = 1, GetContainerNumSlots(i) do
		        if GetContainerItemID(i, z) == itemId then
		        	hasItem = true;
		        	--print("In Bagslot" .. i);
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
					dropdowns[2].dropdownList:SetSize(100, table.getn(druidSpecs) * 16 + 15);
					spec = druidSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(druidSpecs[itemIndex]);
					end
				elseif class == "Hunter" then
					dropdowns[2].dropdownList:SetSize(100, table.getn(hunterSpecs) * 16 + 15);
					spec = hunterSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(hunterSpecs[itemIndex]);
					end
				elseif class == "Mage" then
					dropdowns[2].dropdownList:SetSize(100, table.getn(mageSpecs) * 16 + 15);
					spec = mageSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(mageSpecs[itemIndex]);
					end
				elseif class == "Paladin" then
					dropdowns[2].dropdownList:SetSize(100, table.getn(paladinSpecs) * 16 + 15);
					spec = paladinSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(paladinSpecs[itemIndex]);
					end
				elseif class == "Priest" then
					dropdowns[2].dropdownList:SetSize(100, table.getn(priestSpecs) * 16 + 15);
					spec = priestSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(priestSpecs[itemIndex]);
					end
				elseif class == "Rogue" then
					dropdowns[2].dropdownList:SetSize(100, table.getn(rogueSpecs) * 16 + 15);
					spec = rogueSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(rogueSpecs[itemIndex]);
					end
				elseif class == "Shaman" then
					dropdowns[2].dropdownList:SetSize(100, table.getn(shamanSpecs) * 16 + 15);
					spec = shamanSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(shamanSpecs[itemIndex]);
					end
				elseif class == "Warlock" then
					dropdowns[2].dropdownList:SetSize(100, table.getn(warlockSpecs) * 16 + 15);
					spec = warlockSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(warlockSpecs[itemIndex]);
					end
				elseif class == "Warrior" then
					dropdowns[2].dropdownList:SetSize(100, table.getn(warriorSpecs) * 16 + 15);
					spec = warriorSpecs[1];
					for itemIndex = 1, table.getn(specItems) do
						specItems[itemIndex].title:SetText(warriorSpecs[itemIndex]);
					end					
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
			if phases[itemIndex] == "Phase1" then
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

			--table.insert(dropdownItems, item);
			dropdown.dropdownList:SetSize(120, table.getn(phases) * 16 + 15);
		end
	end


	dropdown:Show();
	table.insert(dropdowns, dropdown);
	return dropdown;

end

MainFrame:SetScript("OnEvent", function(self, event, ...)
	local args = {...}
	if event == "PLAYER_LOGIN" then
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
        		print(string.len(bisCurrentClassSpecData[itemId].itemName));
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
    end
end);
