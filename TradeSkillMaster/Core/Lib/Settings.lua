-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--          http://www.curse.com/addons/wow/tradeskillmaster_warehousing          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Settings = TSM:NewPackage("Settings")
local private = {
	context = {},
	proxies = {},
	profileWarning = nil,
	protectedAccessAllowed = {},
	cachedConnectedRealms = nil,
	upgradeContext = {},
}
local LibRealmInfo = LibStub("LibRealmInfo")
local KEY_SEP = "@"
local SCOPE_KEY_SEP = " - "
local GLOBAL_SCOPE_KEY = " "
local DEFAULT_PROFILE_NAME = "Default"
local PLAYER = UnitName("player")
local FACTION = UnitFactionGroup("player")
local REALM = GetRealmName()
local VALID_TYPES = {
	boolean = true,
	string = true,
	table = true,
	number = true,
}
local SCOPE_TYPES = {
	global = "g",
	profile = "p",
	realm = "r",
	factionrealm = "f",
	char = "c",
	sync = "s",
}
local SCOPE_KEYS = {
	global = " ",
	profile = nil, -- set per-DB
	realm = REALM,
	factionrealm = strjoin(SCOPE_KEY_SEP, FACTION, REALM),
	char = strjoin(SCOPE_KEY_SEP, PLAYER, REALM),
	sync = strjoin(SCOPE_KEY_SEP, PLAYER, FACTION, REALM),
}
local DEFAULT_DB = {
	_version = -math.huge, -- DB version
	_currentProfile = {}, -- lookup table of the current profile name by character
	_syncAccountKey = {}, -- lookup table of the sync account key by factionrealm
	_syncOwner = {}, -- lookup table of the owner sync account key by character
	_hash = 0,
	_scopeKeys = {
		profile = {},
		realm = {},
		factionrealm = {},
		char = {},
		sync = {},
	},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Settings.New(svTableName, settingsInfo)
	return private.Constructor(svTableName, settingsInfo)
end



-- ============================================================================
-- Main SettingsDB Class
-- ============================================================================

local PROTECTED_TABLE_MT = {
	__newindex = function(self, key, value)
		assert(private.protectedAccessAllowed[self], "Attempting to modify a protected table")
		rawset(self, key, value)
	end,
	__metatable = false
}

local SETTINGS_MT = {
	-- getter
	__index = function(self, key)
		if private.SettingsDBMethods[key] then
			return private.SettingsDBMethods[key]
		elseif SCOPE_TYPES[key] then
			return private.context[self].scopeProxies[key]
		else
			error("Invalid scope: "..tostring(key))
		end
	end,

	-- setter
	__newindex = function(self, key, value)
		error("You cannot set values in this table! You're probably missing a scope.")
	end,

	__metatable = false,
}

function private.Constructor(name, rawSettingsInfo)
	assert(type(name) == "string")
	assert(type(rawSettingsInfo) == "table")
	local version = rawSettingsInfo.version
	assert(type(version) == "number" and version >= 1)

	-- get (and create if necessary) the global table
	local db = _G[name]
	if not db then
		db = {}
		_G[name] = db
	end

	-- flatten and validate rawSettingsInfo and generate hash data
	local settingsInfo = CopyTable(rawSettingsInfo)
	local hashDataParts = TSMAPI_FOUR.Util.AcquireTempTable()
	for scope, scopeSettingsInfo in pairs(rawSettingsInfo) do
		if scope ~= "version" then
			assert(SCOPE_TYPES[scope], "Invalid scope: "..tostring(scope))
			for namespace, namespaceSettingsInfo in pairs(scopeSettingsInfo) do
				assert(type(namespace) == "string" and type(namespaceSettingsInfo) == "table")
				assert(not strfind(namespace, KEY_SEP))
				for key, info in pairs(namespaceSettingsInfo) do
					assert(type(key) == "string" and type(info) == "table", "Invalid type for key: "..tostring(key))
					assert(not strfind(key, KEY_SEP))
					for k, v in pairs(info) do
						if k == "type" then
							assert(VALID_TYPES[info.type], "Invalid type for key: "..key)
						elseif k == "default" then
							assert(v == nil or type(v) == info.type, "Invalid default for key: "..key)
							-- if the default is a table, it must not contain non-empty tables
							if type(v) == "table" then
								for k2, v2 in pairs(v) do
									assert(type(k2) == "string" or type(k2) == "number")
									assert(type(v2) ~= "table" or not next(v2), "Default has non-empty table attribute: "..k2)
								end
							end
						elseif k == "lastModifiedVersion" then
							assert(type(v) == "number" and v <= version, "Invalid lastModifiedVersion for key: "..key)
						else
							error("Unexpected key in settingsInfo for key: "..key)
						end
					end
					tinsert(hashDataParts, strjoin(",", key, scope, namespace, info.type, type(info.default) == "table" and "table" or tostring(info.default)))
				end
			end
		end
	end
	sort(hashDataParts)
	local hash = TSMAPI_FOUR.Util.CalculateHash(table.concat(hashDataParts, ";"))
	TSMAPI_FOUR.Util.ReleaseTempTable(hashDataParts)

	-- reset the DB if it's not valid
	local isValid = true
	if not next(db) then
		-- new DB
		isValid = false
	elseif not private.ValidateDB(db) then
		-- corrupted DB
		assert(not TSMAPI_FOUR.Util.IsDevVersion("TradeSkillMaster"), "DB is not valid!")
		isValid = false
	elseif db._version == version and db._hash ~= hash then
		-- the hash didn't match
		assert(not TSMAPI_FOUR.Util.IsDevVersion("TradeSkillMaster"), "Invalid settings hash! Did you forget to increase the version?")
		isValid = false
	elseif db._version > version then
		-- this is a downgrade
		assert(not TSMAPI_FOUR.Util.IsDevVersion("TradeSkillMaster"), "Unexpected DB version! If you really want to downgrade, comment out this line (remember to uncomment before committing).")
		isValid = false
	elseif db._syncOwner and db._syncOwner[SCOPE_KEYS.sync] and db._syncOwner[SCOPE_KEYS.sync] ~= db._syncAccountKey[SCOPE_KEYS.factionrealm] then
		-- we aren't the owner of this character, so wipe the DB and show a manual error
		TSM.Sync.ShowSVCopyError()
		assert(not TSMAPI_FOUR.Util.IsDevVersion("TradeSkillMaster"), "Settings are corrupted due to manual copying of saved variables file")
		isValid = false
	end
	if not isValid then
		-- wipe the DB and start over
		wipe(db)
		for key, value in pairs(DEFAULT_DB) do
			db[key] = private.CopyData(value)
		end
	end
	db._hash = hash

	if not db._syncOwner then
		-- we just upgraded to the first version with the sync scope
		db._syncOwner = {}
		db._syncAccountKey = {}
		db._scopeKeys.sync = {}
	end


	-- make sure we have sync acocunt keys for every factionrealm
	for _, factionrealm in ipairs(db._scopeKeys.factionrealm) do
		db._syncAccountKey[factionrealm] = db._syncAccountKey[factionrealm] or strjoin(SCOPE_KEY_SEP, factionrealm, random(time()))
	end
	-- create the sync account key for this factionrealm if necessary
	db._syncAccountKey[SCOPE_KEYS.factionrealm] = db._syncAccountKey[SCOPE_KEYS.factionrealm] or strjoin(SCOPE_KEY_SEP, SCOPE_KEYS.factionrealm, random(time()))
	-- set the sync owner of the current sync scope key to this account
	db._syncOwner[SCOPE_KEYS.sync] = db._syncOwner[SCOPE_KEYS.sync] or db._syncAccountKey[SCOPE_KEYS.factionrealm]

	-- setup current scope keys and set defaults for new keys
	db._currentProfile[SCOPE_KEYS.char] = db._currentProfile[SCOPE_KEYS.char] or DEFAULT_PROFILE_NAME
	local currentScopeKeys = CopyTable(SCOPE_KEYS)
	currentScopeKeys.profile = db._currentProfile[SCOPE_KEYS.char]
	for scopeType, scopeKey in pairs(currentScopeKeys) do
		if scopeType ~= "global" and not tContains(db._scopeKeys[scopeType], scopeKey) then
			tinsert(db._scopeKeys[scopeType], scopeKey)
			private.SetScopeDefaults(db, settingsInfo, strjoin(KEY_SEP, SCOPE_TYPES[scopeType], TSMAPI_FOUR.Util.StrEscape(scopeKey), ".+", ".+"))
		end
	end

	-- do any necessary upgrading or downgrading if the version changed
	local removedSettings, prevVersion = nil, nil
	if version ~= db._version then
		-- clear any settings which no longer exist, and set new/updated settings to their default values
		removedSettings = {}
		for key in pairs(db) do
			-- ignore metadata (keys starting with "_")
			if strsub(key, 1, 1) ~= "_" then
				local scopeTypeShort, namespace, settingKey = strmatch(key, "^(.+)"..KEY_SEP..".+"..KEY_SEP.."(.+)"..KEY_SEP.."(.+)$")
				local scopeType = scopeTypeShort and private.ScopeReverseLookup(scopeTypeShort)
				local info = settingKey and settingsInfo[scopeType] and settingsInfo[scopeType][namespace] and settingsInfo[scopeType][namespace][settingKey]
				if not info then
					-- this setting was removed so remove it from the db
					removedSettings[key] = db[key]
					db[key] = nil
				elseif info.lastModifiedVersion > db._version or version < db._version then
					-- this will be reset to the default value in the next for loop below
					removedSettings[key] = db[key]
				end
			end
		end
		for scope, scopeInfo in pairs(settingsInfo) do
			if scope ~= "version" then
				for namespace, namespaceInfo in pairs(scopeInfo) do
					for settingKey, info in pairs(namespaceInfo) do
						if info.lastModifiedVersion > db._version or version < db._version then
							-- this is either a new setting or was changed or this is a downgrade - either way set it to the default value
							private.SetScopeDefaults(db, settingsInfo, strjoin(KEY_SEP, SCOPE_TYPES[scope], ".+", namespace, settingKey))
						end
					end
				end
			end
		end
		if version > db._version then
			prevVersion = db._version
		else
			removedSettings = nil
		end
		db._version = version
	end

	-- make the db table protected
	setmetatable(db, PROTECTED_TABLE_MT)

	-- create the new object and return it
	local new = setmetatable({}, SETTINGS_MT)
	private.context[new] = {
		db = db,
		settingsInfo = settingsInfo,
		currentScopeKeys = currentScopeKeys,
		callbacks = {},
		scopeProxies = {},
		namespaceProxies = {},
	}
	for scopeType, scopeInfo in pairs(rawSettingsInfo) do
		if scopeType ~= "version" then
			for namespace in pairs(scopeInfo) do
				private.context[new].namespaceProxies[scopeType..KEY_SEP..namespace] = private.CreateNamespace(new, namespace, scopeType)
			end
			private.context[new].scopeProxies[scopeType] = private.CreateScope(new, scopeType)
		end
	end
	local upgradeObj = nil
	if removedSettings then
		upgradeObj = setmetatable({}, private.SettingsDBUpgradeObjMT)
		assert(prevVersion)
		private.upgradeContext[upgradeObj] = {
			removedSettings = removedSettings,
			prevVersion = prevVersion,
		}
	end
	return new, upgradeObj
end



-- ============================================================================
-- Class for upgrade object
-- ============================================================================

private.SettingsDBUpgradeObjMT = {
	-- getter
	__index = {
		GetPrevVersion = function(self)
			return private.upgradeContext[self].prevVersion
		end,

		RemovedSettingIterator = function(self)
			return next, private.upgradeContext[self].removedSettings, nil
		end,

		GetKeyInfo = function(self, key)
			local scopeType, scopeKey, namespace, settingKey = nil, nil, nil, nil
			local parts = TSMAPI_FOUR.Util.AcquireTempTable(strsplit(KEY_SEP, key))
			if #parts == 4 then
				scopeType, scopeKey, namespace, settingKey = TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(parts)
				scopeType = private.ScopeReverseLookup(scopeType)
			elseif #parts == 3 then
				scopeType, scopeKey, settingKey = TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(parts)
				scopeType = private.ScopeReverseLookup(scopeType)
			else
				error("Unknown key: "..tostring(key))
			end
			return scopeType, scopeKey, namespace, settingKey
		end,
	},

	-- setter
	__newindex = function(self)
		error("You cannot set values in this table!")
	end,

	__metatable = false,
}



-- ============================================================================
-- SettingsDB Object Methods
-- ============================================================================

private.SettingsDBMethods = {
	Get = function(self, scope, scopeKey, namespace, key)
		assert(SCOPE_TYPES[scope] and type(namespace) == "string" and type(key) == "string", "Invalid parameters!")
		local context = private.context[self]
		assert(context.settingsInfo[scope][namespace][key], "Setting does not exist!")
		scopeKey = scopeKey or context.currentScopeKeys[scope]
		return context.db[strjoin(KEY_SEP, SCOPE_TYPES[scope], scopeKey, namespace, key)]
	end,

	Set = function(self, scope, scopeKey, namespace, key, value)
		assert(SCOPE_TYPES[scope] and type(namespace) == "string" and type(key) == "string", "Invalid parameters!")
		local context = private.context[self]
		local info = context.settingsInfo[scope][namespace][key]
		assert(info, "Setting does not exist!")
		assert(value == nil or type(value) == info.type, "Value is of wrong type.")
		scopeKey = scopeKey or context.currentScopeKeys[scope]
		private.SetDBKeyValue(context.db, strjoin(KEY_SEP, SCOPE_TYPES[scope], scopeKey, namespace, key), value)
	end,

	GetDefaultReadOnly = function(self, scope, namespace, key)
		local context = private.context[self]
		return context.settingsInfo[scope][namespace][key].default
	end,

	GetDefault = function(self, scope, namespace, key)
		return private.CopyData(self:GetDefaultReadOnly(scope, namespace, key))
	end,

	RegisterCallback = function(self, event, callback)
		assert(event == "OnProfileUpdated")
		assert(type(callback) == "function")
		private.context[self].callbacks[event] = callback
	end,

	IsValidProfileName = function(self, name)
		return name ~= "" and not strfind(name, KEY_SEP)
	end,

	ProfileExists = function(self, name)
		return tContains(private.context[self].db._scopeKeys.profile, name) and true or false
	end,

	GetCurrentProfile = function(self)
		return private.context[self].currentScopeKeys.profile
	end,

	GetScopeKeys = function(self, scope)
		return CopyTable(private.context[self].db._scopeKeys[scope])
	end,

	GetProfiles = function(self)
		return self:GetScopeKeys("profile")
	end,

	ProfileIterator = function(self)
		return ipairs(private.context[self].db._scopeKeys.profile)
	end,

	SetProfile = function(self, profileName)
		assert(type(profileName) == "string", tostring(profileName))
		assert(not strfind(profileName, KEY_SEP))
		local context = private.context[self]

		-- change the current profile for this character
		context.db._currentProfile[SCOPE_KEYS.char] = profileName
		context.currentScopeKeys.profile = context.db._currentProfile[SCOPE_KEYS.char]

		local isNew = false
		if not tContains(context.db._scopeKeys.profile, profileName) then
			tinsert(context.db._scopeKeys.profile, profileName)
			-- this is a new profile, so set all the settings to their default values
			private.SetScopeDefaults(context.db, context.settingsInfo, strjoin(KEY_SEP, SCOPE_TYPES.profile, TSMAPI_FOUR.Util.StrEscape(profileName), ".+", ".+"))
			isNew = true
		end

		if context.callbacks.OnProfileUpdated then
			context.callbacks.OnProfileUpdated(isNew)
		end
	end,

	ResetProfile = function(self)
		local context = private.context[self]
		private.SetScopeDefaults(context.db, context.settingsInfo, strjoin(KEY_SEP, SCOPE_TYPES.profile, TSMAPI_FOUR.Util.StrEscape(context.currentScopeKeys.profile), ".+", ".+"))
		if context.callbacks.OnProfileUpdated then
			context.callbacks.OnProfileUpdated(true)
		end
	end,

	CopyProfile = function(self, sourceProfileName)
		assert(type(sourceProfileName) == "string")
		assert(not strfind(sourceProfileName, KEY_SEP))
		local context = private.context[self]
		assert(sourceProfileName ~= context.currentScopeKeys.profile)

		-- copy all the settings from the source profile to the current one
		for namespace, namespaceInfo in pairs(context.settingsInfo.profile) do
			for settingKey in pairs(namespaceInfo) do
				local srcKey = strjoin(KEY_SEP, SCOPE_TYPES.profile, sourceProfileName, namespace, settingKey)
				local destKey = strjoin(KEY_SEP, SCOPE_TYPES.profile, context.currentScopeKeys.profile, namespace, settingKey)
				private.SetDBKeyValue(context.db, destKey, private.CopyData(context.db[srcKey]))
			end
		end

		if context.callbacks.OnProfileUpdated then
			context.callbacks.OnProfileUpdated(false)
		end
	end,

	DeleteScope = function(self, scopeType, scopeKey)
		assert(SCOPE_TYPES[scopeType])
		assert(type(scopeKey) == "string")
		local context = private.context[self]
		assert(scopeKey ~= context.currentScopeKeys[scopeType])

		-- remove all settings for the specified profile
		local searchPattern = strjoin(KEY_SEP, SCOPE_TYPES[scopeType], TSMAPI_FOUR.Util.StrEscape(scopeKey), ".+", ".+")
		for key in pairs(context.db) do
			if strmatch(key, searchPattern) then
				private.SetDBKeyValue(context.db, key, nil)
			end
		end

		-- remove the scope key from the list
		TSMAPI_FOUR.Util.TableRemoveByValue(context.db._scopeKeys[scopeType], scopeKey)
	end,

	DeleteProfile = function(self, profileName)
		self:DeleteScope("profile", profileName)
	end,

	GetConnectedRealmIterator = function(self, scope)
		assert(scope == "factionrealm" or scope == "realm")
		return private.ConnectedRealmIterator, self, scope
	end,

	GetSyncAccountKey = function(self, factionrealm)
		factionrealm = factionrealm or SCOPE_KEYS.factionrealm
		return private.context[self].db._syncAccountKey[factionrealm]
	end,

	SyncAccountIterator = function(self)
		local result = TSMAPI_FOUR.Util.AcquireTempTable()
		local used = TSMAPI_FOUR.Util.AcquireTempTable()
		for _, syncOwner in pairs(private.context[self].db._syncOwner) do
			if strmatch(syncOwner, "^"..TSMAPI_FOUR.Util.StrEscape(SCOPE_KEYS.factionrealm..SCOPE_KEY_SEP).."(%d+)$") and not used[syncOwner] and syncOwner ~= self:GetSyncAccountKey() then
				used[syncOwner] = true
				tinsert(result, syncOwner)
			end
		end
		TSMAPI_FOUR.Util.ReleaseTempTable(used)
		return TSMAPI_FOUR.Util.TempTableIterator(result)
	end,

	NewSyncCharacter = function(self, character, accountKey, factionrealm)
		factionrealm = factionrealm or SCOPE_KEYS.factionrealm
		assert(strmatch(accountKey, "^"..TSMAPI_FOUR.Util.StrEscape(factionrealm..SCOPE_KEY_SEP).."(%d+)$"), "Invalid account key")
		local scopeKey = self:GetSyncScopeKeyByCharacter(character, factionrealm)
		local context = private.context[self]
		context.db._syncOwner[scopeKey] = accountKey
		if not tContains(context.db._scopeKeys.sync, scopeKey) then
			tinsert(context.db._scopeKeys.sync, scopeKey)
		end
		private.SetScopeDefaults(context.db, context.settingsInfo, strjoin(KEY_SEP, SCOPE_TYPES.sync, TSMAPI_FOUR.Util.StrEscape(scopeKey), ".+", ".+"))
	end,

	RemoveSyncAccount = function(self, accountKey)
		local settingsDB = private.context[self].db
		assert(accountKey ~= self:GetSyncAccountKey())
		local scopeKeysToRemove = TSMAPI_FOUR.Util.AcquireTempTable()
		for scopeKey, ownerAccountKey in pairs(settingsDB._syncOwner) do
			if ownerAccountKey == accountKey then
				tinsert(scopeKeysToRemove, scopeKey)
			end
		end
		for _, scopeKey in ipairs(scopeKeysToRemove) do
			self:DeleteScope("sync", scopeKey)
			settingsDB._syncOwner[scopeKey] = nil
		end
		TSMAPI_FOUR.Util.ReleaseTempTable(scopeKeysToRemove)
	end,

	RemoveSyncCharacter = function(self, character)
		local settingsDB = private.context[self].db
		local scopeKey = self:GetSyncScopeKeyByCharacter(character)
		self:DeleteScope("sync", scopeKey)
		settingsDB._syncOwner[scopeKey] = nil
	end,

	GetSyncOwnerAccountKey = function(self, character)
		return private.context[self].db._syncOwner[self:GetSyncScopeKeyByCharacter(character)]
	end,

	FactionrealmCharacterIterator = function(self, factionrealm)
		factionrealm = factionrealm or SCOPE_KEYS.factionrealm
		local result = TSMAPI_FOUR.Util.AcquireTempTable()
		for scopeKey in pairs(private.context[self].db._syncOwner) do
			local character = strmatch(scopeKey, "^(.+)"..TSMAPI_FOUR.Util.StrEscape(SCOPE_KEY_SEP..factionrealm))
			if character then
				tinsert(result, character)
			end
		end
		return TSMAPI_FOUR.Util.TempTableIterator(result)
	end,

	FactionrealmCharacterByAccountIterator = function(self, account, factionrealm)
		factionrealm = factionrealm or SCOPE_KEYS.factionrealm
		account = account or self:GetSyncAccountKey(factionrealm)
		local result = TSMAPI_FOUR.Util.AcquireTempTable()
		for scopeKey, ownerAccount in pairs(private.context[self].db._syncOwner) do
			if ownerAccount == account then
				local character = strmatch(scopeKey, "^(.+)"..TSMAPI_FOUR.Util.StrEscape(SCOPE_KEY_SEP..factionrealm))
				if character then
					tinsert(result, character)
				end
			end
		end
		return TSMAPI_FOUR.Util.TempTableIterator(result)
	end,

	SyncSettingSortedIterator = function(self)
		local syncSettingsInfo = private.context[self].settingsInfo.sync
		local result = TSMAPI_FOUR.Util.AcquireTempTable()
		for namespace, settings in pairs(syncSettingsInfo) do
			for settingKey in pairs(settings) do
				tinsert(result, namespace..KEY_SEP..settingKey)
			end
		end
		sort(result)
		return private.SyncSettingIteratorHelper, result, 0
	end,

	GetSyncScopeKeyByCharacter = function(self, character, factionrealm)
		return character..SCOPE_KEY_SEP..(factionrealm or SCOPE_KEYS.factionrealm)
	end,

	FactionrealmByRealmIterator = function(self, realm)
		return private.FactionrealmByRealmIteratorHelper, realm
	end,
}



-- ============================================================================
-- Proxy Class for Scopes (TSM.db.XXXXX)
-- ============================================================================

local SCOPE_MT = {
	-- getter
	__index = function(self, namespace)
		assert(type(namespace) == "string", "Invalid namespace type!")
		local proxyInfo = private.proxies[self]
		local context = private.context[proxyInfo.settingsDB]
		assert(context.settingsInfo[proxyInfo.scope][namespace], "Namespace does not exist!")
		local namespaceProxy = context.namespaceProxies[proxyInfo.scope..KEY_SEP..namespace]
		assert(namespaceProxy)
		return namespaceProxy
	end,

	-- setter
	__newindex = function(self, key, value)
		error("You cannot set values in this table! You're probably missing a namespace.")
	end,

	__metatable = false,
}



-- ============================================================================
-- Proxy Class for Namespaces (TSM.db.<scope>.XXXXX)
-- ============================================================================

local NAMESPACE_MT = {
	-- getter
	__index = function(self, key)
		assert(type(key) == "string", "Invalid setting key type!")
		local proxyInfo = private.proxies[self]
		return proxyInfo.settingsDB:Get(proxyInfo.scope, nil, proxyInfo.namespace, key)
	end,

	-- setter
	__newindex = function(self, key, value)
		local proxyInfo = private.proxies[self]
		proxyInfo.settingsDB:Set(proxyInfo.scope, nil, proxyInfo.namespace, key, value)
	end,

	__metatable = false,
}



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.CreateScope(settingsDB, scope)
	assert(private.context[settingsDB])
	local new = setmetatable({}, SCOPE_MT)
	private.proxies[new] = {
		settingsDB = settingsDB,
		scope = scope,
	}
	return new
end

function private.CreateNamespace(settingsDB, namespace, scope)
	assert(private.context[settingsDB])
	local new = setmetatable({}, NAMESPACE_MT)
	private.proxies[new] = {
		settingsDB = settingsDB,
		namespace = namespace,
		scope = scope,
	}
	return new
end

function private.SetDBKeyValue(db, key, value)
	private.protectedAccessAllowed[db] = true
	db[key] = value
	private.protectedAccessAllowed[db] = nil
end

function private.CopyData(data)
	if type(data) == "table" then
		return CopyTable(data)
	elseif VALID_TYPES[type(data)] or type(data) == nil then
		return data
	end
end

function private.ScopeReverseLookup(scopeTypeShort)
	for key, value in pairs(SCOPE_TYPES) do
		if value == scopeTypeShort then
			return key
		end
	end
end

function private.ValidateDB(db)
	-- make sure the DB we are loading from is valid
	if #db > 0 then return end
	if type(db._version) ~= "number" then return end
	if type(db._hash) ~= "number" then return end
	if type(db._scopeKeys) ~= "table" then return end
	for scopeType, keys in pairs(db._scopeKeys) do
		if not SCOPE_TYPES[scopeType] then return end
		for i, name in pairs(keys) do
			if type(i) ~= "number" or i > #keys or i <= 0 or type(name) ~= "string" then return end
		end
	end
	if type(db._currentProfile) ~= "table" then return end
	for key, value in pairs(db._currentProfile) do
		if type(key) ~= "string" or type(value) ~= "string" then return end
	end
	return true
end

function private.SetScopeDefaults(db, settingsInfo, searchPattern)
	-- remove any existing entries for matching keys
	for key in pairs(db) do
		if strmatch(key, searchPattern) then
			private.SetDBKeyValue(db, key, nil)
		end
	end

	local scopeTypeShort = strsub(searchPattern, 1, 1)
	local scopeType = private.ScopeReverseLookup(scopeTypeShort)
	assert(scopeType, "Couldn't find scopeType: "..tostring(scopeTypeShort))
	local scopeKeys = nil
	if scopeTypeShort == SCOPE_TYPES.global then
		scopeKeys = {GLOBAL_SCOPE_KEY}
	else
		scopeKeys = db._scopeKeys[scopeType]
		assert(scopeKeys, "Couldn't find scopeKeys for type: "..tostring(scopeTypeShort))
	end

	-- set any matching keys to their default values
	if not settingsInfo[scopeType] then return end
	for namespace, namespaceInfo in pairs(settingsInfo[scopeType]) do
		for settingKey, info in pairs(namespaceInfo) do
			for _, scopeKey in ipairs(scopeKeys) do
				local key = strjoin(KEY_SEP, scopeTypeShort, scopeKey, namespace, settingKey)
				if strmatch(key, searchPattern) then
					private.SetDBKeyValue(db, key, private.CopyData(info.default))
				end
			end
		end
	end
end

function private.ConnectedRealmIterator(self, prevScopeKey)
	if not private.cachedConnectedRealms then
		local connectedRealms = {}
		if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
			local realmId, _, _, _, _, _, _, _, connectedRealmIds = LibRealmInfo:GetRealmInfo(REALM)
			if connectedRealmIds then
				for _, id in ipairs(connectedRealmIds) do
					if id ~= realmId then
						local _, connectedRealmName = LibRealmInfo:GetRealmInfoByID(id)
						tinsert(connectedRealms, connectedRealmName)
					end
				end
			end
		end
		private.cachedConnectedRealms = connectedRealms
	end
	local scope = nil
	if prevScopeKey == "factionrealm" or prevScopeKey == "realm" then
		-- this is the first time
		scope = prevScopeKey
		prevScopeKey = nil
	else
		scope = strmatch(prevScopeKey, TSMAPI_FOUR.Util.StrEscape(FACTION.." - ")) and "factionrealm" or "realm"
	end
	local foundPrev = prevScopeKey == nil
	local index = 0
	while true do
		local realm = index == 0 and SCOPE_KEYS.realm or private.cachedConnectedRealms[index]
		if not realm then return end
		index = index + 1
		local scopeKey = (scope == "factionrealm") and (FACTION..SCOPE_KEY_SEP..realm) or realm
		if scopeKey == prevScopeKey then
			foundPrev = true
		elseif foundPrev and tContains(private.context[self].db._scopeKeys[scope], scopeKey) then
			return scopeKey
		end
	end
end

function private.SyncSettingIteratorHelper(tbl, index)
	index = index + 1
	if index > #tbl then
		TSMAPI_FOUR.Util.ReleaseTempTable(tbl)
		return
	end
	return index, strsplit(KEY_SEP, tbl[index])
end

function private.FactionrealmByRealmIteratorHelper(realm, prevValue)
	if not prevValue then
		return strjoin(SCOPE_KEY_SEP, "Horde", realm)
	elseif strmatch(prevValue, "^Horde") then
		return strjoin(SCOPE_KEY_SEP, "Alliance", realm)
	elseif strmatch(prevValue, "^Alliance") then
		return strjoin(SCOPE_KEY_SEP, "Neutral", realm)
	end
end
