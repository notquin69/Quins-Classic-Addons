-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local L = TSM.L
local Import = TSM.Groups:NewPackage("Import")
local private = { groupImports = nil, operationsTemp = {} }
local AceSerializer = LibStub("AceSerializer-3.0")
local GroupImport = TSMAPI_FOUR.Class.DefineClass("GroupImport")



-- ============================================================================
-- Module Functions
-- ============================================================================

function Import.OnInitialize()
	private.groupImports = TSMAPI_FOUR.ObjectPool.New("GROUP_IMPORTS", GroupImport, 1)
end

function Import.ParseString(str)
	local groupImport = private.groupImports:Get()
	if not groupImport:ParseString(str) then
		groupImport:Release()
		return
	end
	return groupImport
end



-- ============================================================================
-- GroupImport - Class Meta Methods
-- ============================================================================

function GroupImport.__init(self)
	self._items = {}
	self._groups = {}
	self._operations = {}
end

function GroupImport.Release(self)
	wipe(self._items)
	wipe(self._groups)
	wipe(self._operations)
	private.groupImports:Recycle(self)
end



-- ============================================================================
-- GroupImport - Public Methods
-- ============================================================================

function GroupImport.ParseString(self, str)
	assert(type(str) == "string")
	TSM:LOG_INFO("Processing import string (%d characters)", #str)
	local isValid, data = nil, nil
	if strsub(str, 1, 1) == "^" then
		isValid, data = AceSerializer:Deserialize(str)
		if not isValid or type(data) ~= "table" then
			TSM:LOG_ERR("Invalid import string")
			return false
		end
		if type(data.operations) ~= "table" and type(data.groupExport) ~= "string" then
			TSM:LOG_ERR("Doesn't contain operations or groupExport")
			return false
		end
		if data.operations then
			TSM:LOG_INFO("Parsing operations")
			self:_ParseOperations(data.operations)
		end
		if data.groupExport then
			TSM:LOG_INFO("Parsing group export")
			self:_ParseGroupExport(data.groupExport)
		end
		if type(data.groupOperations) == "table" then
			TSM:LOG_INFO("Parsing group operations")
			self:_ParseGroupOperations(data.groupOperations)
		end
	else
		self:_ParseGroupExport(str)
	end

	-- remove any items which have nonexistent groups
	for itemString, groupPath in pairs(self._items) do
		if not self._groups[groupPath] then
			self._items[itemString] = nil
		end
	end

	-- make sure the import isn't empty
	if not next(self._items) and not next(self._operations) then
		TSM:LOG_ERR("Invalid import string")
		return false
	end

	return true
end

function GroupImport.GetInfo(self)
	local numItems = TSMAPI_FOUR.Util.Count(self._items)
	local numOperations = 0
	for _, moduleOperations in pairs(self._operations) do
		numOperations = numOperations + TSMAPI_FOUR.Util.Count(moduleOperations)
	end
	return numItems, numOperations
end

function GroupImport.Commit(self, rootGroup)
	if not TSM.Groups.Exists(rootGroup) then
		TSM:Printf(L["Unable to process import because the target group (%s) no longer exists. Please try again."], TSM.Groups.Path.Format(rootGroup))
		return
	end

	-- add operations
	for moduleName, moduleOperations in pairs(self._operations) do
		for operationName, newOperationSettings in pairs(moduleOperations) do
			if not TSM.Operations.Exists(moduleName, operationName) then
				-- create a new operation
				TSM.Operations.Create(moduleName, operationName)
			end
			-- copy over the settings
			local operationSettings = TSM.Operations.GetSettings(moduleName, operationName)
			for k, v in pairs(newOperationSettings) do
				operationSettings[k] = v
			end
			TSM.Operations.Update(moduleName, operationName)
		end
	end

	-- check if we're trying to import items directly into the root group, in which case we should create a new top-level group
	local hasRootItems = false
	if rootGroup == TSM.CONST.ROOT_GROUP_PATH then
		for _, relativeGroupPath in pairs(self._items) do
			if relativeGroupPath == TSM.CONST.ROOT_GROUP_PATH then
				hasRootItems = true
				break
			end
		end
	end
	if hasRootItems then
		local newGroupName = L["Imported Items"]
		local num = 2
		while TSM.Groups.Exists(newGroupName) do
			newGroupName = L["Imported Items"].." "..num
			num = num + 1
		end
		TSM.Groups.Create(newGroupName)
		rootGroup = newGroupName
	end

	-- get the list of valid groups
	local newGroups = TSMAPI_FOUR.Util.AcquireTempTable()
	for relativeGroupPath in pairs(self._groups) do
		local groupPath = relativeGroupPath == TSM.CONST.ROOT_GROUP_PATH and rootGroup or TSM.Groups.Path.Join(rootGroup, relativeGroupPath)
		if not newGroups[groupPath] and groupPath ~= TSM.CONST.ROOT_GROUP_PATH and not TSM.Groups.Exists(groupPath) then
			newGroups[groupPath] = relativeGroupPath
			tinsert(newGroups, groupPath)
		end
	end
	TSM.Groups.SortGroupList(newGroups)

	-- create new groups
	for _, groupPath in ipairs(newGroups) do
		local relativeGroupPath = newGroups[groupPath]
		-- create a new group
		TSM.Groups.Create(groupPath)
		-- if we have operations included in the import string, apply them to this group
		if next(self._operations) and self._groups[relativeGroupPath] then
			for moduleName, moduleOperations in pairs(self._groups[relativeGroupPath]) do
				TSM.Groups.SetOperationOverride(groupPath, moduleName, moduleOperations.override)
				if moduleOperations.override then
					for _, operationName in ipairs(moduleOperations) do
						TSM.Groups.AppendOperation(groupPath, moduleName, operationName)
					end
				end
			end
		end
	end

	-- add items to groups
	for itemString, relativeGroupPath in pairs(self._items) do
		local groupPath = relativeGroupPath == TSM.CONST.ROOT_GROUP_PATH and rootGroup or TSM.Groups.Path.Join(rootGroup, relativeGroupPath)
		TSM.Groups.SetItemGroup(itemString, groupPath)
	end
end

function GroupImport.GroupIterator(self)
	local groups = TSMAPI_FOUR.Util.AcquireTempTable()
	for groupPath in pairs(self._groups) do
		tinsert(groups, groupPath)
	end
	TSM.Groups.SortGroupList(groups)
	return TSMAPI_FOUR.Util.TempTableIterator(groups)
end

function GroupImport.GroupItemIterator(self, groupPath)
	local items = TSMAPI_FOUR.Util.AcquireTempTable()
	local itemNameLookup = TSMAPI_FOUR.Util.AcquireTempTable()
	for itemString, itemGroupPath in pairs(self._items) do
		if itemGroupPath == groupPath then
			tinsert(items, itemString)
			itemNameLookup[itemString] = TSMAPI_FOUR.Item.GetName(itemString) or itemString
		end
	end
	TSMAPI_FOUR.Util.TableSortWithValueLookup(items, itemNameLookup)
	TSMAPI_FOUR.Util.ReleaseTempTable(itemNameLookup)
	return TSMAPI_FOUR.Util.TempTableIterator(items)
end

function GroupImport.GroupModuleOperationIterator(self, groupPath, moduleName)
	local operations = TSMAPI_FOUR.Util.AcquireTempTable()
	if self._groups[groupPath][moduleName] and self._groups[groupPath][moduleName].override then
		for _, operationName in ipairs(self._groups[groupPath][moduleName]) do
			tinsert(operations, operationName)
		end
	end
	return TSMAPI_FOUR.Util.TempTableIterator(operations)
end

function GroupImport.ModuleOperationIterator(self, moduleName)
	local operations = TSMAPI_FOUR.Util.AcquireTempTable()
	if self._operations[moduleName] then
		for operationName in pairs(self._operations[moduleName]) do
			tinsert(operations, operationName)
		end
		sort(operations)
	end
	return TSMAPI_FOUR.Util.TempTableIterator(operations)
end

function GroupImport.RemoveOperation(self, moduleName, operationName)
	self._operations[moduleName][operationName] = nil
	for groupPath in pairs(self._groups) do
		self:RemoveGroupOperation(groupPath, moduleName, operationName)
	end
end

function GroupImport.RemoveModuleOperations(self, moduleName)
	self._operations[moduleName] = nil
	for groupPath in pairs(self._groups) do
		self:RemoveGroupOperations(groupPath, moduleName)
	end
end

function GroupImport.RemoveOperations(self)
	for moduleName in pairs(self._operations) do
		self:RemoveModuleOperations(moduleName)
	end
end

function GroupImport.RemoveExistingOperations(self)
	for moduleName, moduleOperations in pairs(self._operations) do
		for operationName in pairs(moduleOperations) do
			if TSM.Operations.Exists(moduleName, operationName) then
				self:RemoveOperation(moduleName, operationName)
			end
		end
	end
end

function GroupImport.RemoveGroup(self, groupPath)
	self._groups[groupPath] = nil
	self:RemoveGroupItems(groupPath)
	-- recurse for child groups
	for childGroupPath in pairs(self._groups) do
		if TSM.Groups.Path.IsChild(childGroupPath, groupPath) then
			self:RemoveGroup(childGroupPath)
		end
	end
end

function GroupImport.RemoveGroupItem(self, groupPath, itemString)
	assert(self._items[itemString] == groupPath)
	self._items[itemString] = nil
end

function GroupImport.RemoveGroupItems(self, groupPath)
	for itemString, itemGroupPath in pairs(self._items) do
		if itemGroupPath == groupPath then
			self:RemoveGroupItem(groupPath, itemString)
		end
	end
end

function GroupImport.RemoveExistingGroupedItems(self)
	for itemString in pairs(self._items) do
		if TSM.Groups.GetPathByItem(itemString) ~= TSM.CONST.ROOT_GROUP_PATH then
			self._items[itemString] = nil
		end
	end
end

function GroupImport.RemoveGroupOperation(self, groupPath, moduleName, operationName)
	TSMAPI_FOUR.Util.TableRemoveByValue(self._groups[groupPath][moduleName], operationName)
end

function GroupImport.RemoveGroupOperations(self, groupPath, moduleName)
	wipe(self._groups[groupPath][moduleName])
end



-- ============================================================================
-- GroupImport - Private Methods
-- ============================================================================

function GroupImport._ParseOperations(self, operations)
	for moduleName, moduleOperations in pairs(operations) do
		if type(moduleName) ~= "string" and type(moduleOperations) ~= "table" then
			TSM:LOG_WARN("Removing entry of invalid type (%s, %s)", tostring(moduleName), tostring(moduleOperations))
			operations[moduleName] = nil
		elseif not TSM.Operations.ModuleExists(moduleName) then
			TSM:LOG_WARN("Removing module which doesn't exist (%s)", moduleName)
			operations[moduleName] = nil
		elseif not next(moduleOperations) then
			TSM:LOG_INFO("Removing empty module (%s)", moduleName)
			operations[moduleName] = nil
		end
	end
	for moduleName, moduleOperations in pairs(operations) do
		for operationName, operationSettings in pairs(moduleOperations) do
			if type(operationName) ~= "string" or type(operationSettings) ~= "table" then
				TSM:LOG_WARN("Ignoring entry of invalid type (%s, %s, %s)", moduleName, tostring(operationName), tostring(operationSettings))
			elseif strmatch(operationName, TSM.CONST.OPERATION_SEP) then
				TSM:LOG_WARN("Ignoring invalid operation name (%s, %s)", moduleName, operationName)
			else
				operationSettings.ignorePlayer = {}
				operationSettings.ignoreFactionrealm = {}
				operationSettings.relationships = {}
				TSM.Operations.SanitizeSettings(moduleName, operationName, operationSettings)
				self._operations[moduleName] = self._operations[moduleName] or {}
				self._operations[moduleName][operationName] = operationSettings
			end
		end
	end
end

function GroupImport._CreateGroup(self, groupPath)
	self._groups[groupPath] = {}
	for _, moduleName in TSM.Operations.ModuleIterator() do
		self._groups[groupPath][moduleName] = {}
	end
end

function GroupImport._ParseGroupExport(self, str)
	if strmatch(str, "^[ip0-9%-:;]+$") then
		-- this is likely a list of itemStrings separated by semicolons instead of commas, so attempt to fix it
		str = gsub(str, ";", ",")
	end
	local relativePath = TSM.CONST.ROOT_GROUP_PATH
	for part in TSMAPI_FOUR.Util.StrSplitIterator(str, ",") do
		part = strtrim(part)
		local groupPath = strmatch(part, "^group:(.+)$")
		local itemString = strmatch(part, "^[ip]?:?[0-9%-:]+$")
		itemString = itemString and TSMAPI_FOUR.Item.ToItemString(itemString) or nil
		assert(not groupPath or not itemString)
		if groupPath then
			-- We export a "," in a group path as "``"
			groupPath = gsub(groupPath, "``", ",")
			relativePath = groupPath
			-- create the groups all the way up to the root
			while groupPath and groupPath ~= TSM.CONST.ROOT_GROUP_PATH do
				self:_CreateGroup(groupPath)
				groupPath = TSM.Groups.Path.GetParent(groupPath)
			end
		elseif itemString then
			if relativePath == TSM.CONST.ROOT_GROUP_PATH and not self._groups[TSM.CONST.ROOT_GROUP_PATH] then
				self:_CreateGroup(TSM.CONST.ROOT_GROUP_PATH)
			end
			self._items[itemString] = relativePath
		else
			TSM:LOG_ERR("Unknown part: %s", part)
		end
	end
end

function GroupImport._ParseGroupOperations(self, groupOperations)
	for groupPath, operations in pairs(groupOperations) do
		-- We export a "," in a group path as "``"
		groupPath = gsub(groupPath, "``", ",")
		if type(groupPath) ~= "string" or type(operations) ~= "table" then
			TSM:LOG_WARN("Ignoring entry of invalid type (%s, %s)", tostring(groupPath), tostring(operations))
		elseif not self._groups[groupPath] then
			TSM:LOG_WARN("Ignoring operations assigned to unknown group (%s)", groupPath)
		else
			-- add any missing modules
			for _, moduleName in TSM.Operations.ModuleIterator() do
				if not operations[moduleName] then
					operations[moduleName] = {}
				end
			end
			for moduleName, moduleOperations in pairs(operations) do
				if type(moduleName) ~= "string" or type(moduleOperations) ~= "table" then
					TSM:LOG_WARN("Ignoring entry of invalid type (%s, %s)", tostring(moduleName), tostring(moduleOperations))
				elseif not self._groups[groupPath][moduleName] then
					TSM:LOG_WARN("Ignoring module which doesn't exist (%s)", moduleName)
				elseif next(self._groups[groupPath][moduleName]) then
					TSM:LOG_WARN("Ignoring duplicate operations assigned to group (%s, %s)", groupPath, moduleName)
				else
					local override = moduleOperations.override and true or nil
					moduleOperations.override = nil
					if TSM.Groups.Path.GetParent(groupPath) == TSM.CONST.ROOT_GROUP_PATH then
						-- this is a top-level group, so override should be set
						override = true
					end
					local numOperations = min(#moduleOperations, TSM.Operations.GetMaxNumber(moduleName))
					for k, v in pairs(moduleOperations) do
						if type(k) ~= "number" or k < 1 or k > numOperations then
							TSM:LOG_WARN("Ignorning unknown key (%s, %s, %s, %s)", groupPath, moduleName, tostring(k), tostring(v))
							moduleOperations[k] = nil
						elseif type(v) ~= "string" then
							TSM:LOG_WARN("Ignorning invalid value (%s, %s, %s, %s)", groupPath, moduleName, k, tostring(v))
							moduleOperations[k] = nil
						elseif v == "" then
							-- ignore empty operation names from old exports
							moduleOperations[k] = nil
						end
					end
					wipe(private.operationsTemp)
					for _, operationName in ipairs(moduleOperations) do
						if not self._operations[moduleName][operationName] then
							TSM:LOG_WARN("Ignorning unknown operation (%s, %s, %s)", groupPath, moduleName, operationName)
						else
							tinsert(private.operationsTemp, operationName)
						end
					end
					wipe(moduleOperations)
					moduleOperations.override = override
					for _, operationName in ipairs(private.operationsTemp) do
						tinsert(moduleOperations, operationName)
					end
					self._groups[groupPath][moduleName] = moduleOperations
				end
			end
		end
	end
end
