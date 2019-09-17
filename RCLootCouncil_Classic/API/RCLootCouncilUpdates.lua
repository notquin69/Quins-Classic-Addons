--- Fixed for retail RCLootCouncil function that doesn't function properly in Classic
local _, addon = ...
local private = {}
local RCClassic = addon:GetModule("RCClassic")
local L = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil")
local LC = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil_Classic")

----------------------------------------------
-- Core
----------------------------------------------
addon.coreEvents["ENCOUNTER_LOOT_RECEIVED"] = nil -- Doens't exist in Classic
-- Defaults updates:
-- -- Removed:
addon.defaults.profile.ignoredItems = {} -- Remove all retail ignores
addon.defaults.profile.printCompletedTrades = nil
addon.defaults.profile.rejectTrade = nil
-- -- Usage options:
addon.defaults.profile.usage = {
   never = false,
   ml = false,
   ask_ml = true,
   state = "ask_ml"
}

-- Some Main Hand weapons are "Ranged" in Classic
addon.INVTYPE_Slots.INVTYPE_RANGED = "RangedSlot"
addon.INVTYPE_Slots.INVTYPE_RANGEDRIGHT = "RangedSlot"
addon.INVTYPE_Slots.INVTYPE_THROWN = "RangedSlot"

function addon:UpdatePlayersData()
   self:DebugLog("UpdatePlayersData()")
   -- GetSpecialization doesn't exist, and there's no real need for it in classic
	--playersData.specID = GetSpecialization() and GetSpecializationInfo(GetSpecialization())
   self.playersData.specID = 0
	self.playersData.ilvl = private.GetAverageItemLevel()

	self:UpdatePlayersGears()
end

function addon:GetLootStatusData ()
   -- Do nothing
end

-- fullTest is used with Dungeon Journal, and thus is ignored
function addon:Test (num, fullTest, trinketTest)
   self:Debug("Test", num, fullTest, trinketTest)
   num = num or 3
   local testItems = {
      17076,12590,14555,11684,22691,871, -- Weapons
      12640,14551,14153,12757, -- Armor
      18821,19140,19148,1980,942,18813,13143 -- Rings
   }
   local trinkets = {
      19406,17064,18820,19395,19289, -- Trinkets
   }

   if not trinketTest then
		for _, t in ipairs(trinkets) do
			tinsert(testItems, t)
		end
	end

   local items = {}
   for i = 1, num do
		local j = math.random(1, #testItems)
		tinsert(items, testItems[j])
	end
	if trinketTest then -- Always test all trinkets.
		items = trinkets
	end
   self.testMode = true;
	self.isMasterLooter, self.masterLooter = self:GetML()
	-- We must be in a group and not the ML
	if not self.isMasterLooter then
		self:Print(L.error_test_as_non_leader)
		self.testMode = false
		return
	end
	-- Call ML module and let it handle the rest
	self:CallModule("masterlooter")
	self:GetActiveModule("masterlooter"):NewML(self.masterLooter)
	self:GetActiveModule("masterlooter"):Test(items)

	self:ScheduleTimer(function()
		self:SendCommand("group", "looted", 1234)
	end, 5)
end

local enchanting_localized_name = nil
function addon:GetPlayerInfo ()
   local enchant, lvl = nil, 0
   if not enchanting_localized_name then
      enchanting_localized_name = GetSpellInfo(7411)
   end
   if GetSpellBookItemInfo(enchanting_localized_name) then
      -- We know enchanting, thus are an enchanter. We don't know our lvl though.
      enchant = true
      lvl = "< 300"
   end
   -- GetAverageItemLevel() isn't implemented
   local ilvl = private.GetAverageItemLevel()
   return self.playerName, self.playerClass, nil --[[self.Utils:GetPlayerRole()]], self.guildRank, enchant, lvl, ilvl, nil--self.playersData.specID
end


----------------------------------------------
-- Utils
----------------------------------------------
function addon.Utils:GetPlayerRole ()
   return "" -- Unused
end

----------------------------------------------
-- Options Menu
----------------------------------------------
local old_options_func = addon.OptionsTable
function addon:OptionsTable ()
   local options = old_options_func(addon)
   -- Inject RCClassic version in the description
   options.args.settings.args.version.name = function ()
      local desc = "Classic: "
      -- Classic version
      if RCClassic.tVersion then
         desc = desc .. "|cFF87CEFAv"..RCClassic.version.."|r-"..RCClassic.tVersion
      else
         desc = desc .. "|cFF87CEFAv"..RCClassic.version.."|r"
      end
      -- Core version
      desc = desc .. " - Core: "
      if RCClassic.RCLootCouncil.tVersion then
         desc = desc .. "|cFF87CEFAv"..addon.version.."|r-"..RCClassic.RCLootCouncil.tVersion
      else
         desc = desc .. "|cFF87CEFAv"..addon.version.."|r"
      end
      return desc
   end
   -- Usage options
   options.args.mlSettings.args.generalTab.args.usageOptions.args.usage.values = {
      	ml 			= LC["opt_usage_ml"],
			ask_ml		= LC["opt_usage_ask_ml"],
		--	leader 		= "Always use RCLootCouncil when I'm the group leader and enter a raid",
		--	ask_leader	= "Ask me every time I'm the group leader and enter a raid",
			never			= L["Never use RCLootCouncil"],
   }
   options.args.mlSettings.args.generalTab.args.usageOptions.args.leaderUsage = { -- Add leader options here since we can only make a single select dropdown
		order = 3,
		name = function() return self.db.profile.usage.ml and LC["opt_usage_leader_always"] or LC["opt_usage_leader_ask"] end,
		desc = LC["leaderUsage_desc"],
		type = "toggle",
		get = function() return self.db.profile.usage.leader or self.db.profile.usage.ask_leader end,
		set = function(_, val)
			self.db.profile.usage.leader, self.db.profile.usage.ask_leader = false, false -- Reset for zzzzz
			if self.db.profile.usage.ml then self.db.profile.usage.leader = val end
			if self.db.profile.usage.ask_ml then self.db.profile.usage.ask_leader = val end
		end,
		disabled = function() return self.db.profile.usage.never end,
	}

   -- Disable "Allow Keeping" and "Trade Messages" options
   options.args.mlSettings.args.generalTab.args.lootingOptions.args.printCompletedTrades = nil
   options.args.mlSettings.args.generalTab.args.lootingOptions.args.rejectTrade = nil

   -- Remove "Azerite Armor" as a category for more buttons
   options.args.mlSettings.args.buttonsTab.args.moreButtons.args.selector.values.AZERITE = nil

   -- Remove "Spec Icon" as there's no clear definition of a spec REVIEW We could invent one..
   options.args.settings.args.generalSettingsTab.args.frameOptions.args.showSpecIcon = nil

   -- Update "Patch" values in delete history
   options.args.settings.args.generalSettingsTab.args.lootHistoryOptions.args.deletePatch.values =
   {
      [1566900000] = "Phase 1 (Classic Launch)",
   }
   -- "_G.INSTANCE" isn't available for localization - use our own
   options.args.settings.args.generalSettingsTab.args.lootHistoryOptions.args.deleteRaid.name = LC["Instance"]

   return options
end

----------------------------------------------
-- Private helper functions
----------------------------------------------
--- Recreates functionality of GetAverageItemLevel()
function private.GetAverageItemLevel()
   local sum, count = 0, 0
   for i=_G.INVSLOT_FIRST_EQUIPPED, _G.INVSLOT_LAST_EQUIPPED do
      local iLink = _G.GetInventoryItemLink("player", i)
      if iLink and iLink ~= "" then
         local ilvl = select(4, _G.GetItemInfo(iLink)) or 0
         sum = sum + ilvl
         count = count + 1
      end
   end
   return sum / count
end
