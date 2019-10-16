-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local PlayerProfessions = TSM.Crafting:NewPackage("PlayerProfessions")
local private = { playerProfessionsThread = nil, db = nil, query = nil }
local MINING = GetSpellInfo(TSM.CONST.MINING_SPELLID)
local SMELTING = GetSpellInfo(TSM.CONST.SMELTING_SPELLID)
local POISONS = GetSpellInfo(TSM.CONST.POISONS_SPELLID)
local ARTISAN_ZHCN = "大师级"
local ARTISAN_RUS = "Мастеровой"



-- ============================================================================
-- Module Functions
-- ============================================================================

function PlayerProfessions.OnInitialize()
	private.db = TSMAPI_FOUR.Database.NewSchema("PLAYER_PROFESSIONS")
		:AddStringField("player")
		:AddStringField("profession")
		:AddNumberField("level")
		:AddNumberField("maxLevel")
		:AddBooleanField("isSecondary")
		:AddIndex("player")
		:Commit()
	private.query = private.db:NewQuery()
		:Select("player", "profession", "level", "maxLevel")
		:OrderBy("isSecondary", true)
		:OrderBy("level", false)
		:OrderBy("profession", true)
	private.playerProfessionsThread = TSMAPI_FOUR.Thread.New("PLAYER_PROFESSIONS", private.PlayerProfessionsThread)
	private.StartPlayerProfessionsThread()
	TSMAPI_FOUR.Event.Register("SKILL_LINES_CHANGED", private.PlayerProfessionsSkillUpdate)
	TSMAPI_FOUR.Event.Register("LEARNED_SPELL_IN_TAB", private.StartPlayerProfessionsThread)
end

function PlayerProfessions.CreateQuery()
	return private.db:NewQuery()
end

function PlayerProfessions.Iterator()
	return private.query:Iterator()
end



-- ============================================================================
-- Player Professions Thread
-- ============================================================================

function private.StartPlayerProfessionsThread()
	if private.playerProfessionsThreadRunning then
		TSMAPI_FOUR.Thread.Kill(private.playerProfessionsThread)
	end
	private.playerProfessionsThreadRunning = true
	TSMAPI_FOUR.Thread.Start(private.playerProfessionsThread)
end

function private.UpdatePlayerProfessionInfo(name, level, maxLevel, isSecondary)
	local professionInfo = TSM.db.sync.internalData.playerProfessions[name] or {}
	TSM.db.sync.internalData.playerProfessions[name] = professionInfo
	-- preserve whether or not we've prompted to create groups and the profession link if possible
	local oldPrompted = professionInfo.prompted or nil
	local oldLink = professionInfo.link or nil
	wipe(professionInfo)
	professionInfo.level = level
	professionInfo.maxLevel = maxLevel
	professionInfo.isSecondary = isSecondary
	professionInfo.prompted = oldPrompted
	professionInfo.link = oldLink
end

function private.PlayerProfessionsSkillUpdate()
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		local _, _, offset, numSpells = GetSpellTabInfo(1)
		for i = offset + 1, offset + numSpells do
			local name, subName = GetSpellBookItemName(i, BOOKTYPE_SPELL)
			if not subName then
				TSMAPI_FOUR.Delay.AfterTime(0.05, private.PlayerProfessionsSkillUpdate)
				return
			end
			if name and subName and (TSMAPI_FOUR.Util.In(strtrim(subName, " "), APPRENTICE, JOURNEYMAN, EXPERT, ARTISAN, ARTISAN_ZHCN, ARTISAN_RUS) or name == SMELTING or name == POISONS) and not TSM.UI.CraftingUI.IsProfessionIgnored(name) then
				local level, maxLevel = nil, nil
				for j = 1, GetNumSkillLines() do
					local skillName, _, _, skillRank, _, _, skillMaxRank = GetSkillLineInfo(j)
					if skillName == name then
						level = skillRank
						maxLevel = skillMaxRank
						break
					elseif name == SMELTING and skillName == MINING then
						name = MINING
						level = skillRank
						maxLevel = skillMaxRank
						break
					end
				end
				if level and maxLevel and not TSM.UI.CraftingUI.IsProfessionIgnored(name) then -- exclude ignored professions
					private.UpdatePlayerProfessionInfo(name, level, maxLevel, name == GetSpellInfo(129))
				end
			end
		end
	else
		local professionIds = TSMAPI_FOUR.Util.AcquireTempTable(GetProfessions())
		for i, id in pairs(professionIds) do -- needs to be pairs since there might be holes
			if id ~= 8 and id ~= 9 then -- ignore fishing and arheology
				local name, _, level, maxLevel = GetProfessionInfo(id)
				if not TSM.UI.CraftingUI.IsProfessionIgnored(name) then -- exclude ignored professions
					private.UpdatePlayerProfessionInfo(name, level, maxLevel, i > 2)
				end
			end
		end
		TSMAPI_FOUR.Util.ReleaseTempTable(professionIds)
	end

	-- update our DB
	private.db:TruncateAndBulkInsertStart()
	for _, character in TSM.db:FactionrealmCharacterIterator() do
		local playerProfessions = TSM.db:Get("sync", TSM.db:GetSyncScopeKeyByCharacter(character), "internalData", "playerProfessions")
		if playerProfessions then
			for name, info in pairs(playerProfessions) do
				private.db:BulkInsertNewRow(character, name, info.level, info.maxLevel, info.isSecondary)
			end
		end
	end
	private.db:BulkInsertEnd()
end

function private.PlayerProfessionsThread()
	-- get the player's tradeskills
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		SpellBookFrame_UpdateSkillLineTabs()
	else
		SpellBook_UpdateProfTab()
	end
	local forgetProfession = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
	for name in pairs(TSM.db.sync.internalData.playerProfessions) do
		forgetProfession[name] = true
	end
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		local _, _, offset, numSpells = GetSpellTabInfo(1)
		for i = offset + 1, offset + numSpells do
			local name, subName = GetSpellBookItemName(i, BOOKTYPE_SPELL)
			if name and subName and (TSMAPI_FOUR.Util.In(strtrim(subName, " "), APPRENTICE, JOURNEYMAN, EXPERT, ARTISAN, ARTISAN_RUS) or name == SMELTING or name == POISONS) and not TSM.UI.CraftingUI.IsProfessionIgnored(name) then
				local level, maxLevel = nil, nil
				for j = 1, GetNumSkillLines() do
					local skillName, _, _, skillRank, _, _, skillMaxRank = GetSkillLineInfo(j)
					if skillName == name then
						level = skillRank
						maxLevel = skillMaxRank
						break
					elseif name == SMELTING and skillName == MINING then
						name = MINING
						level = skillRank
						maxLevel = skillMaxRank
						break
					end
				end
				if level and maxLevel and not TSM.UI.CraftingUI.IsProfessionIgnored(name) then -- exclude ignored professions
					forgetProfession[name] = nil
					private.UpdatePlayerProfessionInfo(name, level, maxLevel, name == GetSpellInfo(129))
				end
			end
		end
	else
		TSMAPI_FOUR.Thread.WaitForFunction(GetProfessions)
		local professionIds = TSMAPI_FOUR.Thread.AcquireSafeTempTable(GetProfessions())
		-- ignore archeology and fishing which are in the 3rd and 4th slots respectively
		professionIds[3] = nil
		professionIds[4] = nil
		for i, id in pairs(professionIds) do -- needs to be pairs since there might be holes
			local name, _, level, maxLevel = TSMAPI_FOUR.Thread.WaitForFunction(GetProfessionInfo, id)
			if not TSM.UI.CraftingUI.IsProfessionIgnored(name) then -- exclude ignored professions
				forgetProfession[name] = nil
				private.UpdatePlayerProfessionInfo(name, level, maxLevel, i > 2)
			end
		end
		TSMAPI_FOUR.Thread.ReleaseSafeTempTable(professionIds)
	end
	for name in pairs(forgetProfession) do
		TSM.db.sync.internalData.playerProfessions[name] = nil
	end
	TSMAPI_FOUR.Thread.ReleaseSafeTempTable(forgetProfession)

	-- clean up crafts which are no longer known
	local matUsed = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
	local spellIds = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
	for _, spellId in TSM.Crafting.SpellIterator() do
		tinsert(spellIds, spellId)
	end
	for _, spellId in ipairs(spellIds) do
		local playersToRemove = TSMAPI_FOUR.Util.AcquireTempTable()
		for _, player in TSMAPI_FOUR.Util.VarargIterator(TSM.Crafting.GetPlayers(spellId)) do
			-- check if the player still exists and still has this profession
			local playerProfessions = TSM.db:Get("sync", TSM.db:GetSyncScopeKeyByCharacter(player), "internalData", "playerProfessions")
			if not playerProfessions or not playerProfessions[TSM.Crafting.GetProfession(spellId)] then
				tinsert(playersToRemove, player)
			end
		end
		local stillExists = true
		if #playersToRemove > 0 then
			stillExists = TSM.Crafting.RemovePlayers(spellId, playersToRemove)
		end
		TSMAPI_FOUR.Util.ReleaseTempTable(playersToRemove)
		if stillExists then
			for _, itemString in TSM.Crafting.MatIterator(spellId) do
				matUsed[itemString] = true
			end
		end
		TSMAPI_FOUR.Thread.Yield()
	end
	TSMAPI_FOUR.Thread.ReleaseSafeTempTable(spellIds)

	-- clean up mats which aren't used anymore
	local toRemove = TSMAPI_FOUR.Util.AcquireTempTable()
	for itemString, matInfo in pairs(TSM.db.factionrealm.internalData.mats) do
		-- clear out old names
		matInfo.name = nil
		if not matUsed[itemString] then
			tinsert(toRemove, itemString)
		end
	end
	TSMAPI_FOUR.Thread.ReleaseSafeTempTable(matUsed)
	for _, itemString in ipairs(toRemove) do
		TSM.db.factionrealm.internalData.mats[itemString] = nil
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(toRemove)

	-- update our DB
	private.db:TruncateAndBulkInsertStart()
	for _, character in TSM.db:FactionrealmCharacterIterator() do
		local playerProfessions = TSM.db:Get("sync", TSM.db:GetSyncScopeKeyByCharacter(character), "internalData", "playerProfessions")
		if playerProfessions then
			for name, info in pairs(playerProfessions) do
				private.db:BulkInsertNewRow(character, name, info.level, info.maxLevel, info.isSecondary)
			end
		end
	end
	private.db:BulkInsertEnd()

	private.playerProfessionsThreadRunning = false
end
