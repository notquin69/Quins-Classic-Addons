-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--          http://www.curse.com/addons/wow/tradeskillmaster_warehousing          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Player Info TSMAPI_FOUR Functions
-- @module PlayerInfo

TSMAPI_FOUR.PlayerInfo = {}
local _, TSM = ...
local private = {
	isPlayerCache = {},
}
local PLAYER_NAME = UnitName("player")
local PLAYER_LOWER = strlower(UnitName("player"))
local FACTION_LOWER = strlower(UnitFactionGroup("player"))
local REALM_LOWER = strlower(GetRealmName())
local PLAYER_REALM_LOWER = PLAYER_LOWER.." - "..REALM_LOWER



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

--- Iterate over all characters on this factionrealm.
-- @tparam[opt=false] boolean currentAccountOnly If true, will only include the current account
-- @return An iterator with the following fields: `index, name`
function TSMAPI_FOUR.PlayerInfo.CharacterIterator(currentAccountOnly)
	if currentAccountOnly then
		return TSM.db:FactionrealmCharacterByAccountIterator()
	else
		return TSM.db:FactionrealmCharacterIterator()
	end
end

--- Get all alts on this factionrealm.
-- @tparam[opt=false] boolean currentAccountOnly If true, will only include the current account
-- @treturn table A table containing all character names as keys
function TSMAPI_FOUR.PlayerInfo.GetAlts(currentAccountOnly)
	local characters = {}
	for _, name in TSMAPI_FOUR.PlayerInfo.CharacterIterator(currentAccountOnly) do
		if name ~= PLAYER_NAME then
			characters[name] = true
		end
	end
	return characters
end

--- Get all characters on this factionrealm.
-- @tparam[opt=false] boolean currentAccountOnly If true, will only include the current account
-- @treturn table A table containing all character names as keys
function TSMAPI_FOUR.PlayerInfo.GetCharacters(currentAccountOnly)
	local characters = {}
	for _, name in TSMAPI_FOUR.PlayerInfo.CharacterIterator(currentAccountOnly) do
		characters[name] = true
	end
	return characters
end

--- Iterate over all guilds on this factionrealm.
-- @tparam[opt=false] boolean includeIgnored If true, will include guilds which have been set to be ignored
-- @return An iterator with the following fields: `index, guildName`
function TSMAPI_FOUR.PlayerInfo.GuildIterator(includeIgnored)
	if includeIgnored then
		return private.GuildIteratorIgnoreIncluded, TSM.db.factionrealm.internalData.guildVaults
	else
		return private.GuildIterator, TSM.db.factionrealm.internalData.guildVaults
	end
end

--- Get all guilds on this functionrealm.
-- @tparam[opt=false] boolean includeIgnored If true, will include guild the player has set to be ignored
-- @treturn table A table containing all guild names as keys
function TSMAPI_FOUR.PlayerInfo.GetGuilds(includeIgnored)
	local guilds = {}
	for name in TSMAPI_FOUR.PlayerInfo.GuildIterator(includeIgnored) do
		guilds[name] = true
	end
	return guilds
end

--- Get the player's guild.
-- @tparam string player The name of the player
-- @treturn ?string The name of the player's guilde or nil if it's not in one
function TSMAPI_FOUR.PlayerInfo.GetPlayerGuild(player)
	return player and TSM.db.factionrealm.internalData.characterGuilds[player] or nil
end

--- Check whether or not a player belongs to the user.
-- @tparam string target The name of the player
-- @tparam boolean includeAlts Whether or not to include alts
-- @tparam boolean includeOtherFaction Whether or not to include players on the other faction
-- @tparam boolean includeOtherAccounts Whether or not to include connected accounts
-- @treturn boolean Whether or not the player belongs to the user
function TSMAPI_FOUR.PlayerInfo.IsPlayer(target, includeAlts, includeOtherFaction, includeOtherAccounts)
	local cacheKey = strjoin("%", target, includeAlts and "1" or "0", includeOtherFaction and "1" or "0", includeOtherAccounts and "1" or "0")
	if private.isPlayerCache.lastUpdate ~= GetTime() then
		wipe(private.isPlayerCache)
		private.isPlayerCache.lastUpdate = GetTime()
	end
	if private.isPlayerCache[cacheKey] == nil then
		private.isPlayerCache[cacheKey] = private.IsPlayerHelper(target, includeAlts, includeOtherFaction, includeOtherAccounts)
	end
	return private.isPlayerCache[cacheKey]
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.IsPlayerHelper(target, includeAlts, includeOtherFaction, includeOtherAccounts)
	target = strlower(target)
	if not strfind(target, " %- ") then
		target = gsub(target, "%-", " - ", 1)
	end
	if target == PLAYER_LOWER then
		return true
	elseif strfind(target, " %- ") and target == PLAYER_REALM_LOWER then
		return true
	end
	if not strfind(target, " %- ") then
		target = target.." - "..REALM_LOWER
	end
	if includeAlts then
		for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
			local factionKey, realmKey = strmatch(factionrealm, "(.+) %- (.+)")
			factionKey = strlower(factionKey)
			realmKey = strlower(realmKey)
			if includeOtherFaction or factionKey == FACTION_LOWER then
				local found = false
				if includeOtherAccounts then
					for _, charKey in TSM.db:FactionrealmCharacterIterator(factionrealm) do
						if target == (strlower(charKey).." - "..realmKey) then
							found = true
						end
					end
				else
					for _, charKey in TSM.db:FactionrealmCharacterByAccountIterator(nil, factionrealm) do
						if target == (strlower(charKey).." - "..realmKey) then
							found = true
						end
					end
				end
				if found then
					return true
				end
			end
		end
	end
	return false
end

function private.GuildIterator(tbl, prevName)
	while true do
		local name = next(tbl, prevName)
		if not name then
			return nil
		end
		if not TSM.db.factionrealm.coreOptions.ignoreGuilds[name] then
			return name
		end
		prevName = name
	end
end

function private.GuildIteratorIgnoreIncluded(tbl, prevName)
	local name = next(tbl, prevName)
	return name
end
