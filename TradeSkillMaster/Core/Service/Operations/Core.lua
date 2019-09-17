-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Operations = TSM:NewPackage("Operations")
local private = {
	operations = nil,
	operationInfo = {},
	operationModules = {},
	shouldCreateDefaultOperations = false,
	ignoreProfileUpdate = false,
}
local COMMON_OPERATION_INFO = {
	ignorePlayer = { type = "table", default = {} },
	ignoreFactionrealm = { type = "table", default = {} },
	relationships = { type = "table", default = {} },
}
local FACTION_REALM = UnitFactionGroup("player").." - "..GetRealmName()
local PLAYER_KEY = UnitName("player").." - "..FACTION_REALM



-- ============================================================================
-- Modules Functions
-- ============================================================================

function Operations.OnInitialize()
	if TSM.db.global.coreOptions.globalOperations then
		private.operations = TSM.db.global.userData.operations
	else
		private.operations = TSM.db.profile.userData.operations
	end
	private.shouldCreateDefaultOperations = not TSM.db.profile.internalData.createdDefaultOperations
	TSM.db.profile.internalData.createdDefaultOperations = true
	TSM.db:RegisterCallback("OnProfileUpdated", private.OnProfileUpdated)
end

function Operations.Register(moduleName, localizedName, operationInfo, maxOperations, infoCallback)
	for key, info in pairs(operationInfo) do
		assert(type(key) == "string" and type(info) == "table")
		assert(info.type == type(info.default))
	end
	for key, info in pairs(COMMON_OPERATION_INFO) do
		assert(not operationInfo[key])
		operationInfo[key] = info
	end
	tinsert(private.operationModules, moduleName)
	private.operationInfo[moduleName] = {
		info = operationInfo,
		localizedName = localizedName,
		maxOperations = maxOperations,
		infoCallback = infoCallback,
	}

	local shouldCreateDefaultOperations = private.shouldCreateDefaultOperations or not private.operations[moduleName]
	private.operations[moduleName] = private.operations[moduleName] or {}

	if shouldCreateDefaultOperations and not private.operations[moduleName]["#Default"] then
		-- create default operation
		Operations.Create(moduleName, "#Default")
	end
	private.ValidateOperations(moduleName)
end

function Operations.SetStoredGlobally(storeGlobally)
	-- we shouldn't be running the OnProfileUpdated callback while switching profiles
	private.ignoreProfileUpdate = true
	if storeGlobally then
		-- move current profile to global
		TSM.db.global.userData.operations = CopyTable(TSM.db.profile.userData.operations)
		-- clear out old operations
		for _ in TSM.GetTSMProfileIterator() do
			TSM.db.profile.userData.operations = nil
		end
	else
		-- move global to all profiles
		for _ in TSM.GetTSMProfileIterator() do
			TSM.db.profile.userData.operations = CopyTable(TSM.db.global.userData.operations)
		end
		-- clear out old operations
		TSM.db.global.userData.operations = nil
	end
	private.ignoreProfileUpdate = false
	private.OnProfileUpdated()
	TSM.Groups.RebuildDatabase()
end

function Operations.ModuleIterator()
	return ipairs(private.operationModules)
end

function Operations.ModuleExists(moduleName)
	return private.operationInfo[moduleName] and true or false
end

function Operations.GetLocalizedName(moduleName)
	return private.operationInfo[moduleName].localizedName
end

function Operations.GetMaxNumber(moduleName)
	return private.operationInfo[moduleName].maxOperations
end

function Operations.GetSettingDefault(moduleName, key)
	local info = private.operationInfo[moduleName].info[key]
	return info.type == "table" and CopyTable(info.default) or info.default
end

function Operations.OperationIterator(moduleName)
	local operations = TSMAPI_FOUR.Util.AcquireTempTable()
	for operationName in pairs(private.operations[moduleName]) do
		tinsert(operations, operationName)
	end
	sort(operations)
	return TSMAPI_FOUR.Util.TempTableIterator(operations)
end

function Operations.Exists(moduleName, operationName)
	return private.operations[moduleName][operationName] and true or false
end

function Operations.GetSettings(moduleName, operationName)
	return private.operations[moduleName][operationName]
end

function Operations.Create(moduleName, operationName)
	assert(not private.operations[moduleName][operationName])
	private.operations[moduleName][operationName] = {}
	Operations.Reset(moduleName, operationName)
end

function Operations.Rename(moduleName, oldName, newName)
	assert(private.operations[moduleName][oldName])
	private.operations[moduleName][newName] = private.operations[moduleName][oldName]
	private.operations[moduleName][oldName] = nil
	-- redirect relationships
	for _, operation in pairs(private.operations[moduleName]) do
		for key, target in pairs(operation.relationships) do
			if target == oldName then
				operation.relationships[key] = newName
			end
		end
	end
	TSM.Groups.OperationRenamed(moduleName, oldName, newName)
end

function Operations.Copy(moduleName, operationName, sourceOperationName)
	assert(private.operations[moduleName][operationName] and private.operations[moduleName][sourceOperationName])
	for key, info in pairs(private.operationInfo[moduleName].info) do
		local sourceValue = private.operations[moduleName][sourceOperationName][key]
		private.operations[moduleName][operationName][key] = info.type == "table" and CopyTable(sourceValue) or sourceValue
	end
	private.RemoveDeadRelationships(moduleName)
end

function Operations.Delete(moduleName, operationName)
	assert(private.operations[moduleName][operationName])
	private.operations[moduleName][operationName] = nil
	private.RemoveDeadRelationships(moduleName)
	TSM.Groups.RemoveOperationFromAllGroups(moduleName, operationName)
end

function Operations.Reset(moduleName, operationName)
	for key in pairs(private.operationInfo[moduleName].info) do
		private.operations[moduleName][operationName][key] = Operations.GetSettingDefault(moduleName, key)
	end
end

function Operations.Update(moduleName, operationName)
	for key in pairs(private.operations[moduleName][operationName].relationships) do
		local operation = private.operations[moduleName][operationName]
		while operation.relationships[key] do
			local newOperation = private.operations[moduleName][operation.relationships[key]]
			if not newOperation then break end
			operation = newOperation
		end
		private.operations[moduleName][operationName][key] = operation[key]
	end
end

function Operations.IsCircularRelationship(moduleName, operationName, key)
	local visited = TSMAPI_FOUR.Util.AcquireTempTable()
	while operationName do
		if visited[operationName] then
			TSMAPI_FOUR.Util.ReleaseTempTable(visited)
			return true
		end
		visited[operationName] = true
		operationName = private.operations[moduleName][operationName].relationships[key]
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(visited)
	return false
end

function Operations.GetFirstOperationByItem(moduleName, itemString)
	local groupPath = TSM.Groups.GetPathByItem(itemString)
	for _, operationName in TSM.Groups.OperationIterator(groupPath, moduleName) do
		Operations.Update(moduleName, operationName)
		if not private.IsIgnored(moduleName, operationName) then
			return operationName, private.operations[moduleName][operationName]
		end
	end
end

function Operations.GroupOperationIterator(moduleName, groupPath)
	local operations = TSMAPI_FOUR.Util.AcquireTempTable()
	operations.moduleName = moduleName
	for _, operationName in TSM.Groups.OperationIterator(groupPath, moduleName) do
		Operations.Update(moduleName, operationName)
		if not private.IsIgnored(moduleName, operationName) then
			tinsert(operations, operationName)
		end
	end
	return private.GroupOperationIteratorHelper, operations, 0
end

function Operations.GetDescription(moduleName, operationName)
	local operationSettings = private.operations[moduleName][operationName]
	assert(operationSettings)
	Operations.Update(moduleName, operationName)
	return private.operationInfo[moduleName].infoCallback(operationSettings)
end

function Operations.SanitizeSettings(moduleName, operationName, operationSettings)
	local operationInfo = private.operationInfo[moduleName].info
	for key, value in pairs(operationSettings) do
		if not operationInfo[key] then
			operationSettings[key] = nil
		elseif type(value) ~= operationInfo[key].type then
			if operationInfo[key].type == "string" and type(value) == "number" then
				-- some custom price settings were potentially stored as numbers previously, so just convert them
				operationSettings[key] = tostring(value)
			else
				TSM:LOG_ERR("Resetting operation setting %s,%s,%s (%s)", moduleName, operationName, tostring(key), tostring(value))
				operationSettings[key] = operationInfo[key].type == "table" and CopyTable(operationInfo[key].default) or operationInfo[key].default
			end
		elseif operationInfo[key].customSanitizeFunction then
			operationSettings[key] = operationInfo[key].customSanitizeFunction(value)
		end
	end
	for key in pairs(operationInfo) do
		if operationSettings[key] == nil then
			-- this key was missing
			if operationInfo[key].type == "boolean" then
				-- we previously stored booleans as nil instead of false
				operationSettings[key] = false
			else
				TSM:LOG_ERR("Resetting missing operation setting %s,%s,%s", moduleName, operationName, tostring(key))
				operationSettings[key] = operationInfo[key].type == "table" and CopyTable(operationInfo[key].default) or operationInfo[key].default
			end
		end
	end
end

function Operations.HasRelationship(moduleName, operationName, settingKey)
	return Operations.GetRelationship(moduleName, operationName, settingKey) and true or false
end

function Operations.GetRelationship(moduleName, operationName, settingKey)
	assert(private.operationInfo[moduleName].info[settingKey])
	return private.operations[moduleName][operationName].relationships[settingKey]
end

function Operations.SetRelationship(moduleName, operationName, settingKey, targetOperationName)
	assert(targetOperationName == nil or private.operations[moduleName][targetOperationName])
	assert(private.operationInfo[moduleName].info[settingKey])
	private.operations[moduleName][operationName].relationships[settingKey] = targetOperationName
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.OnProfileUpdated()
	if private.ignoreProfileUpdate then
		return
	end
	if TSM.db.global.coreOptions.globalOperations then
		private.operations = TSM.db.global.userData.operations
	else
		private.operations = TSM.db.profile.userData.operations
	end
	for _, moduleName in Operations.ModuleIterator() do
		private.ValidateOperations(moduleName)
	end
	TSM.Groups.RebuildDatabase()
end

function private.ValidateOperations(moduleName)
	if not private.operations[moduleName] then
		-- this is a new profile
		private.operations[moduleName] = {}
		Operations.Create(moduleName, "#Default")
		return
	end
	for operationName, operationSettings in pairs(private.operations[moduleName]) do
		if type(operationName) ~= "string" or strmatch(operationName, TSM.CONST.OPERATION_SEP) then
			TSM:LOG_ERR("Removing %s operation with invalid name: ", moduleName, tostring(operationName))
			private.operations[moduleName][operationName] = nil
		else
			Operations.SanitizeSettings(moduleName, operationName, operationSettings)
			for key, target in pairs(operationSettings.relationships) do
				if not private.operations[moduleName][target] then
					TSM:LOG_ERR("Removing invalid relationship %s,%s,%s -> %s", moduleName, operationName, tostring(key), tostring(target))
					operationSettings.relationships[key] = nil
				end
			end
		end
	end
end

function private.IsIgnored(moduleName, operationName)
	local operationSettings = private.operations[moduleName][operationName]
	assert(operationSettings)
	return operationSettings.ignorePlayer[PLAYER_KEY] or operationSettings.ignoreFactionrealm[FACTION_REALM]
end

function private.GroupOperationIteratorHelper(operations, index)
	index = index + 1
	if index > #operations then
		TSMAPI_FOUR.Util.ReleaseTempTable(operations)
		return
	end
	local operationName = operations[index]
	return index, operationName, private.operations[operations.moduleName][operationName]
end

function private.RemoveDeadRelationships(moduleName)
	for _, operation in pairs(private.operations[moduleName]) do
		for key, target in pairs(operation.relationships) do
			if not private.operations[moduleName][target] then
				operation.relationships[key] = nil
			end
		end
	end
end
