-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Sync = TSM.Crafting:NewPackage("Sync")
local L = TSM.L
local private = {
	hashesTemp = {},
	spellsTemp = {},
	spellsProfessionLookupTemp = {},
	spellInfoTemp = {
		spellIds = {},
		mats = {},
		itemStrings = {},
		names = {},
		numResults = {},
		hasCDs = {},
	},
	accountLookup = {},
	accountStatus = {},
}
local RETRY_DELAY = 5



-- ============================================================================
-- Module Functions
-- ============================================================================

function Sync.OnInitialize()
	TSM.Sync.Connection.RegisterConnectionChangedCallback(private.ConnectionChangedHandler)
	TSM.Sync.RPC.Register("CRAFTING_GET_HASHES", private.RPCGetHashes)
	TSM.Sync.RPC.Register("CRAFTING_GET_SPELLS", private.RPCGetSpells)
	TSM.Sync.RPC.Register("CRAFTING_GET_SPELL_INFO", private.RPCGetSpellInfo)
end

function Sync.GetStatus(account)
	local status = private.accountStatus[account]
	if not status then
		return "|cffff0000"..L["Not Connected"].."|r"
	elseif status == "UPDATING" then
		return "|cfffcf141"..L["Updating"].."|r"
	elseif status == "SYNCED" then
		return "|cff00ff00"..L["Up to date"].."|r"
	else
		error("Invalid status: "..tostring(status))
	end
end



-- ============================================================================
-- RPC Functions and Result Handlers
-- ============================================================================

function private.RPCGetHashes()
	wipe(private.hashesTemp)
	local player = UnitName("player")
	private.GetPlayerProfessionHashes(player, private.hashesTemp)
	return player, private.hashesTemp
end

function private.RPCGetHashesResultHandler(player, data)
	if not player then
		-- request timed out, so try again
		TSM:LOG_WARN("Getting hashes timed out")
		TSMAPI_FOUR.Delay.AfterTime(RETRY_DELAY, private.RPCGetHashes)
		return
	end
	local currentInfo = TSMAPI_FOUR.Util.AcquireTempTable()
	private.GetPlayerProfessionHashes(player, currentInfo)
	local requestProfessions = TSMAPI_FOUR.Util.AcquireTempTable()
	for profession, hash in pairs(data) do
		if hash == currentInfo[profession] then
			TSM:LOG_INFO("%s data for %s already up to date", profession, player)
		else
			TSM:LOG_INFO("Need updated %s data from %s (%s, %s)", profession, player, hash, tostring(currentInfo[hash]))
			requestProfessions[profession] = true
		end
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(currentInfo)
	if next(requestProfessions) then
		private.accountStatus[private.accountLookup[player]] = "UPDATING"
		TSM.Sync.RPC.Call("CRAFTING_GET_SPELLS", player, private.RPCGetSpellsResultHandler, requestProfessions)
	else
		private.accountStatus[private.accountLookup[player]] = "SYNCED"
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(requestProfessions)
end

function private.RPCGetSpells(professions)
	wipe(private.spellsProfessionLookupTemp)
	wipe(private.spellsTemp)
	local player = UnitName("player")
	local query = TSM.Crafting.CreateRawCraftsQuery()
		:Select("spellId", "profession")
		:Custom(private.QueryProfessionFilter, professions)
		:Custom(private.QueryPlayerFilter, player)
		:OrderBy("spellId", true)
	for _, spellId, profession in query:Iterator() do
		private.spellsProfessionLookupTemp[spellId] = profession
		tinsert(private.spellsTemp, spellId)
	end
	query:Release()
	return player, private.spellsProfessionLookupTemp, private.spellsTemp
end

function private.RPCGetSpellsResultHandler(player, professionLookup, spells)
	if not player then
		-- request timed out, so try again from the start
		TSM:LOG_WARN("Getting spells timed out")
		TSMAPI_FOUR.Delay.AfterTime(RETRY_DELAY, private.RPCGetHashes)
		return
	end

	for i = #spells, 1, -1 do
		local spellId = spells[i]
		if TSM.Crafting.HasSpellId(spellId) then
			-- already have this spell so just make sure this player is added
			TSM.Crafting.AddPlayer(spellId, player)
			tremove(spells, i)
		end
	end
	if #spells == 0 then
		TSM:LOG_INFO("Spells up to date for %s", player)
		private.accountStatus[private.accountLookup[player]] = "SYNCED"
	else
		TSM:LOG_INFO("Requesting %d spells from %s", #spells, player)
		TSM.Sync.RPC.Call("CRAFTING_GET_SPELL_INFO", player, private.RPCGetSpellInfoResultHandler, professionLookup, spells)
	end
end

function private.RPCGetSpellInfo(professionLookup, spells)
	for _, tbl in pairs(private.spellInfoTemp) do
		wipe(tbl)
	end
	for i, spellId in ipairs(spells) do
		private.spellInfoTemp.spellIds[i] = spellId
		private.spellInfoTemp.mats[i] = TSM.db.factionrealm.internalData.crafts[spellId].mats
		private.spellInfoTemp.itemStrings[i] = TSM.db.factionrealm.internalData.crafts[spellId].itemString
		private.spellInfoTemp.names[i] = TSM.db.factionrealm.internalData.crafts[spellId].name
		private.spellInfoTemp.numResults[i] = TSM.db.factionrealm.internalData.crafts[spellId].numResult
		private.spellInfoTemp.hasCDs[i] = TSM.db.factionrealm.internalData.crafts[spellId].hasCD
	end
	TSM:LOG_INFO("Sent %d spells", #private.spellInfoTemp.spellIds)
	return UnitName("player"), professionLookup, private.spellInfoTemp
end

function private.RPCGetSpellInfoResultHandler(player, professionLookup, spellInfo)
	if not player or not professionLookup or not spellInfo then
		-- request timed out, so try again from the start
		TSM:LOG_WARN("Getting spell info timed out")
		TSMAPI_FOUR.Delay.AfterTime(RETRY_DELAY, private.RPCGetHashes)
		return
	end

	for i, spellId in ipairs(spellInfo.spellIds) do
		TSM.Crafting.CreateOrUpdate(spellId, spellInfo.itemStrings[i], professionLookup[spellId], spellInfo.names[i], spellInfo.numResults[i], player, spellInfo.hasCDs[i] and true or false)
		for itemString in pairs(spellInfo.mats[i]) do
			TSM.db.factionrealm.internalData.mats[itemString] = TSM.db.factionrealm.internalData.mats[itemString] or {}
		end
		TSM.Crafting.SetMats(spellId, spellInfo.mats[i])
	end
	TSM:LOG_INFO("Added %d spells from %s", #spellInfo.spellIds, player)
	private.accountStatus[private.accountLookup[player]] = "SYNCED"
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ConnectionChangedHandler(account, player, connected)
	if connected then
		private.accountLookup[player] = account
		private.accountStatus[account] = "UPDATING"
		-- issue a request for profession info
		TSM.Sync.RPC.Call("CRAFTING_GET_HASHES", player, private.RPCGetHashesResultHandler)
	else
		private.accountLookup[player] = nil
		private.accountStatus[account] = nil
	end
end

function private.QueryProfessionFilter(row, professions)
	return professions[row:GetField("profession")]
end

function private.QueryPlayerFilter(row, player)
	return TSMAPI_FOUR.Util.SeparatedStrContains(row:GetField("players"), ",", player)
end

function private.GetPlayerProfessionHashes(player, resultTbl)
	local query = TSM.Crafting.CreateRawCraftsQuery()
		:Select("spellId", "profession")
		:Custom(private.QueryPlayerFilter, player)
		:OrderBy("spellId", true)
	for _, spellId, profession in query:Iterator() do
		resultTbl[profession] = TSMAPI_FOUR.Util.CalculateHash(spellId, resultTbl[profession])
	end
end
