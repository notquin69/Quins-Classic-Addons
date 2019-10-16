-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local ProfessionScanner = TSM.Crafting:NewPackage("ProfessionScanner")
local private = {
	db = nil,
	hasScanned = false,
	callbacks = {},
	disabled = false,
	ignoreUpdatesUntil = 0,
}
-- don't want to scan a bunch of times when the profession first loads so add a 10 frame debounce to update events
local SCAN_DEBOUNCE_FRAMES = 10



-- ============================================================================
-- Module Functions
-- ============================================================================

function ProfessionScanner.OnInitialize()
	private.db = TSMAPI_FOUR.Database.NewSchema("CRAFTING_RECIPES")
		:AddUniqueNumberField("index")
		:AddUniqueNumberField("spellId")
		:AddStringField("name")
		:AddNumberField("categoryId")
		:AddStringField("difficulty")
		:AddNumberField("rank")
		:AddNumberField("numSkillUps")
		:Commit()
	TSM.Crafting.ProfessionState.RegisterUpdateCallback(private.ProfessionStateUpdate)
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		TSMAPI_FOUR.Event.Register("CRAFT_UPDATE", private.OnTradeSkillUpdateEvent)
		TSMAPI_FOUR.Event.Register("TRADE_SKILL_UPDATE", private.OnTradeSkillUpdateEvent)
	else
		TSMAPI_FOUR.Event.Register("TRADE_SKILL_LIST_UPDATE", private.OnTradeSkillUpdateEvent)
	end
end

function ProfessionScanner.SetDisabled(disabled)
	private.disabled = disabled
	private.ScanProfession()
end

function ProfessionScanner.HasScanned()
	return private.hasScanned
end

function ProfessionScanner.HasSkills()
	return private.hasScanned and private.db:GetNumRows() > 0
end

function ProfessionScanner.RegisterHasScannedCallback(callback)
	tinsert(private.callbacks, callback)
end

function ProfessionScanner.IgnoreNextProfessionUpdates()
	private.ignoreUpdatesUntil = GetTime() + 1
end

function ProfessionScanner.CreateQuery()
	return private.db:NewQuery()
end

function ProfessionScanner.GetIndexBySpellId(spellId)
	return private.db:GetUniqueRowField("spellId", spellId, "index")
end

function ProfessionScanner.GetNameBySpellId(spellId)
	assert(private.hasScanned)
	return private.db:GetUniqueRowField("spellId", spellId, "name")
end

function ProfessionScanner.GetRankBySpellId(spellId)
	assert(private.hasScanned)
	return private.db:GetUniqueRowField("spellId", spellId, "rank")
end

function ProfessionScanner.GetNumSkillupsBySpellId(spellId)
	assert(private.hasScanned)
	return private.db:GetUniqueRowField("spellId", spellId, "numSkillUps")
end

function ProfessionScanner.GetDifficultyBySpellId(spellId)
	assert(private.hasScanned)
	return private.db:GetUniqueRowField("spellId", spellId, "difficulty")
end

function ProfessionScanner.GetFirstSpellId()
	if not private.hasScanned then
		return
	end
	return private.db:NewQuery()
		:Select("spellId")
		:OrderBy("index", true)
		:GetFirstResultAndRelease()
end

function ProfessionScanner.HasSpellId(spellId)
	return private.hasScanned and private.db:GetUniqueRowField("spellId", spellId, "index") and true or false
end



-- ============================================================================
-- Event Handlers
-- ============================================================================

function private.ProfessionStateUpdate()
	private.hasScanned = false
	for _, callback in ipairs(private.callbacks) do
		callback()
	end
	if TSM.Crafting.ProfessionState.GetCurrentProfession() then
		private.db:Truncate()
		private.OnTradeSkillUpdateEvent()
	else
		TSMAPI_FOUR.Delay.Cancel("PROFESSION_SCAN_DELAY")
	end
end

function private.OnTradeSkillUpdateEvent()
	TSMAPI_FOUR.Delay.Cancel("PROFESSION_SCAN_DELAY")
	TSMAPI_FOUR.Delay.AfterFrame("PROFESSION_SCAN_DELAY", SCAN_DEBOUNCE_FRAMES, private.ScanProfession)
end



-- ============================================================================
-- Profession Scan Thread
-- ============================================================================

function private.ScanProfession()
	if InCombatLockdown() then
		-- we are in combat, so try again in a bit
		TSMAPI_FOUR.Delay.AfterFrame("PROFESSION_SCAN_DELAY", SCAN_DEBOUNCE_FRAMES, private.ScanProfession)
		return
	elseif private.disabled then
		return
	elseif GetTime() < private.ignoreUpdatesUntil then
		return
	end

	local professionName = TSM.Crafting.ProfessionState.GetCurrentProfession()
	if not professionName then
		-- profession hasn't fully opened yet
		TSMAPI_FOUR.Delay.AfterFrame("PROFESSION_SCAN_DELAY", SCAN_DEBOUNCE_FRAMES, private.ScanProfession)
		return
	end

	assert(professionName and TSM.Crafting.ProfessionUtil.IsDataStable())
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		-- TODO: check and clear filters on classic
	else
		local hadFilter = false
		if C_TradeSkillUI.GetOnlyShowUnlearnedRecipes() then
			C_TradeSkillUI.SetOnlyShowLearnedRecipes(true)
			C_TradeSkillUI.SetOnlyShowUnlearnedRecipes(false)
			hadFilter = true
		end
		if C_TradeSkillUI.GetOnlyShowMakeableRecipes() then
			C_TradeSkillUI.SetOnlyShowMakeableRecipes(false)
			hadFilter = true
		end
		if C_TradeSkillUI.GetOnlyShowSkillUpRecipes() then
			C_TradeSkillUI.SetOnlyShowSkillUpRecipes(false)
			hadFilter = true
		end
		if C_TradeSkillUI.AnyRecipeCategoriesFiltered() then
			C_TradeSkillUI.ClearRecipeCategoryFilter()
			hadFilter = true
		end
		if C_TradeSkillUI.AreAnyInventorySlotsFiltered() then
			C_TradeSkillUI.ClearInventorySlotFilter()
			hadFilter = true
		end
		for i = 1, C_PetJournal.GetNumPetSources() do
			if C_TradeSkillUI.IsAnyRecipeFromSource(i) and C_TradeSkillUI.IsRecipeSourceTypeFiltered(i) then
				C_TradeSkillUI.ClearRecipeSourceTypeFilter()
				hadFilter = true
				break
			end
		end
		if C_TradeSkillUI.GetRecipeItemNameFilter() ~= "" then
			C_TradeSkillUI.SetRecipeItemNameFilter(nil)
			hadFilter = true
		end
		local minItemLevel, maxItemLevel = C_TradeSkillUI.GetRecipeItemLevelFilter()
		if minItemLevel ~= 0 or maxItemLevel ~= 0 then
			C_TradeSkillUI.SetRecipeItemLevelFilter(0, 0)
			hadFilter = true
		end

		if hadFilter then
			-- an update event will be triggered
			return
		end
	end

	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		local lastHeaderIndex = 0
		private.db:TruncateAndBulkInsertStart()
		for i = 1, TSM.Crafting.ProfessionState.IsClassicCrafting() and GetNumCrafts() or GetNumTradeSkills() do
			local name, _, skillType, hash = nil, nil, nil, nil
			if TSM.Crafting.ProfessionState.IsClassicCrafting() then
				name, _, skillType = GetCraftInfo(i)
				if skillType ~= "header" then
					hash = TSMAPI_FOUR.Util.CalculateHash(name)
					for j = 1, GetCraftNumReagents(i) do
						local _, _, quantity = GetCraftReagentInfo(i, j)
						hash = TSMAPI_FOUR.Util.CalculateHash(TSMAPI_FOUR.Item.ToItemString(GetCraftReagentItemLink(i, j)), hash)
						hash = TSMAPI_FOUR.Util.CalculateHash(quantity, hash)
					end
				end
			else
				name, skillType = GetTradeSkillInfo(i)
				if skillType ~= "header" then
					hash = TSMAPI_FOUR.Util.CalculateHash(name)
					for j = 1, GetTradeSkillNumReagents(i) do
						local _, _, quantity = GetTradeSkillReagentInfo(i, j)
						hash = TSMAPI_FOUR.Util.CalculateHash(TSMAPI_FOUR.Item.ToItemString(GetTradeSkillReagentItemLink(i, j)), hash)
						hash = TSMAPI_FOUR.Util.CalculateHash(quantity, hash)
					end
				end
			end
			if skillType == "header" then
				lastHeaderIndex = i
			else
				if name then
					private.db:BulkInsertNewRow(i, hash, name, lastHeaderIndex, skillType, -1, 1)
				end
			end
		end
		private.db:BulkInsertEnd()
	else
		local prevRecipeIds = TSMAPI_FOUR.Util.AcquireTempTable()
		local nextRecipeIds = TSMAPI_FOUR.Util.AcquireTempTable()
		local recipeLearned = TSMAPI_FOUR.Util.AcquireTempTable()
		local recipes = TSMAPI_FOUR.Util.AcquireTempTable()
		assert(C_TradeSkillUI.GetFilteredRecipeIDs(recipes) == recipes)
		local spellIdIndex = TSMAPI_FOUR.Util.AcquireTempTable()
		for index, spellId in ipairs(recipes) do
			-- There's a Blizzard bug where First Aid duplicates spellIds, so check that we haven't seen this before
			if not spellIdIndex[spellId] then
				spellIdIndex[spellId] = index
				local info = TSMAPI_FOUR.Util.AcquireTempTable()
				assert(C_TradeSkillUI.GetRecipeInfo(spellId, info) == info)
				if info.previousRecipeID then
					prevRecipeIds[spellId] = info.previousRecipeID
					nextRecipeIds[info.previousRecipeID] = spellId
				end
				recipeLearned[spellId] = info.learned
				TSMAPI_FOUR.Util.ReleaseTempTable(info)
			end
		end
		private.db:TruncateAndBulkInsertStart()
		for index, spellId in ipairs(recipes) do
			local hasHigherRank = nextRecipeIds[spellId] and recipeLearned[nextRecipeIds[spellId]]
			-- TODO: show unlearned recipes in the TSM UI
			-- There's a Blizzard bug where First Aid duplicates spellIds, so check that this is the right index
			if spellIdIndex[spellId] == index and recipeLearned[spellId] and not hasHigherRank then
				local info = TSMAPI_FOUR.Util.AcquireTempTable()
				assert(C_TradeSkillUI.GetRecipeInfo(spellId, info) == info)
				local rank = -1
				if prevRecipeIds[spellId] or nextRecipeIds[spellId] then
					rank = 1
					local tempSpellId = spellId
					while prevRecipeIds[tempSpellId] do
						rank = rank + 1
						tempSpellId = prevRecipeIds[tempSpellId]
					end
				end
				local numSkillUps = info.difficulty == "optimal" and info.numSkillUps or 1
				private.db:BulkInsertNewRow(index, spellId, info.name, info.categoryID, info.difficulty, rank, numSkillUps)
				TSMAPI_FOUR.Util.ReleaseTempTable(info)
			end
		end
		private.db:BulkInsertEnd()
		TSMAPI_FOUR.Util.ReleaseTempTable(spellIdIndex)
		TSMAPI_FOUR.Util.ReleaseTempTable(recipes)
		TSMAPI_FOUR.Util.ReleaseTempTable(prevRecipeIds)
		TSMAPI_FOUR.Util.ReleaseTempTable(nextRecipeIds)
		TSMAPI_FOUR.Util.ReleaseTempTable(recipeLearned)
	end

	if TSM.Crafting.ProfessionUtil.IsNPCProfession() or TSM.Crafting.ProfessionUtil.IsLinkedProfession() or TSM.Crafting.ProfessionUtil.IsGuildProfession() then
		-- we don't want to store this profession in our DB, so we're done
		if not private.hasScanned then
			private.hasScanned = true
			for _, callback in ipairs(private.callbacks) do
				callback()
			end
		end
		return
	end

	if not TSM.db.sync.internalData.playerProfessions[professionName] then
		-- we are in combat or the player's professions haven't been scanned yet by PlayerProfessions.lua, so try again in a bit
		TSMAPI_FOUR.Delay.AfterFrame("PROFESSION_SCAN_DELAY", SCAN_DEBOUNCE_FRAMES, private.ScanProfession)
		return
	end

	-- update the link for this profession
	TSM.db.sync.internalData.playerProfessions[professionName].link = WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC and C_TradeSkillUI.GetTradeSkillListLink() or nil

	-- scan all the recipes
	TSM.Crafting.SetSpellDBQueryUpdatesPaused(true)
	local query = private.db:NewQuery()
		:Select("spellId")
	local numFailed = 0
	for _, spellId in query:Iterator() do
		if not private.ScanRecipe(professionName, spellId) then
			numFailed = numFailed + 1
		end
	end
	query:Release()
	TSM.Crafting.SetSpellDBQueryUpdatesPaused(false)

	TSM:LOG_INFO("Scanned %s (failed to scan %d)", professionName, numFailed)
	if numFailed > 0 then
		-- didn't completely scan, so we'll try again
		TSMAPI_FOUR.Delay.AfterFrame("PROFESSION_SCAN_DELAY", SCAN_DEBOUNCE_FRAMES, private.ScanProfession)
	end
	if not private.hasScanned then
		private.hasScanned = true
		for _, callback in ipairs(private.callbacks) do
			callback()
		end
	end
end

function private.ScanRecipe(professionName, spellId)
	-- get the links
	local itemLink, lNum, hNum = TSM.Crafting.ProfessionUtil.GetRecipeInfo(WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and ProfessionScanner.GetIndexBySpellId(spellId) or spellId)
	assert(itemLink, "Invalid craft: "..tostring(spellId))

	-- get the itemString and craft name
	local itemString, craftName = nil, nil
	if strfind(itemLink, "enchant:") then
		if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
			return true
		else
			-- result of craft is not an item
			itemString = TSM.CONST.ENCHANT_ITEM_STRINGS[spellId] or TSM.CONST.MASS_MILLING_RECIPES[spellId]
			if not itemString then
				-- we don't care about this craft
				return true
			end
			craftName = GetSpellInfo(spellId)
		end
	elseif strfind(itemLink, "item:") then
		-- result of craft is item
		itemString = TSMAPI_FOUR.Item.ToBaseItemString(itemLink)
		craftName = TSMAPI_FOUR.Item.GetName(itemLink)
	else
		error("Invalid craft: "..tostring(spellId))
	end
	if not itemString or not craftName then
		return false
	end

	-- get the result number
	local numResult = nil
	local isEnchant = professionName == GetSpellInfo(7411) and strfind(itemLink, "enchant:")
	if isEnchant then
		numResult = 1
	else
		-- workaround for incorrect values returned for Temporal Crystal
		if spellId == 169092 and itemString == "i:113588" then
			lNum, hNum = 1, 1
		end
		-- workaround for incorrect values returned for new mass milling recipes
		if TSM.CONST.MASS_MILLING_RECIPES[spellId] then
			if spellId == 210116 then -- Yseralline
				lNum, hNum = 4, 4 -- always four
			elseif spellId == 209664 then -- Felwort
				lNum, hNum = 42, 42 -- amount is variable but the values are conservative
			elseif spellId == 247861 then -- Astral Glory
				lNum, hNum = 4, 4 -- amount is variable but the values are conservative
			else
				lNum, hNum = 8, 8.8
			end
		end
		numResult = floor(((lNum or 1) + (hNum or 1)) / 2)
	end

	-- store general info about this recipe
	local hasCD = TSM.Crafting.ProfessionUtil.HasCooldown(spellId)
	TSM.Crafting.CreateOrUpdate(spellId, itemString, professionName, craftName, numResult, UnitName("player"), hasCD)

	-- get the mat quantities and add mats to our DB
	local matQuantities = TSMAPI_FOUR.Util.AcquireTempTable()
	local haveInvalidMats = false
	local numReagents = TSM.Crafting.ProfessionUtil.GetNumMats(spellId)
	for i = 1, numReagents do
		local matItemLink, name, _, quantity = TSM.Crafting.ProfessionUtil.GetMatInfo(spellId, i)
		local matItemString = TSMAPI_FOUR.Item.ToBaseItemString(matItemLink)
		if not matItemString then
			haveInvalidMats = true
			break
		end
		if not name or not quantity then
			haveInvalidMats = true
			break
		end
		TSM.ItemInfo.StoreItemName(matItemString, name)
		TSM.db.factionrealm.internalData.mats[matItemString] = TSM.db.factionrealm.internalData.mats[matItemString] or {}
		matQuantities[matItemString] = quantity
	end
	-- if this is an enchant, add a vellum to the list of mats
	if isEnchant then
		local matItemString = TSM.CONST.VELLUM_ITEM_STRING
		TSM.db.factionrealm.internalData.mats[matItemString] = TSM.db.factionrealm.internalData.mats[matItemString] or {}
		matQuantities[matItemString] = 1
	end

	if not haveInvalidMats then
		TSM.Crafting.SetMats(spellId, matQuantities)
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(matQuantities)
	return not haveInvalidMats
end
