-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Groups = TSM:NewPackage("Groups")
local private = {
	itemDB = nil,
	operationsTemp = {},
	itemStringMap = nil,
	itemStringMapReader = nil,
}



-- ============================================================================
-- New Modules Functions
-- ============================================================================

function Groups.OnInitialize()
	private.itemDB = TSMAPI_FOUR.Database.NewSchema("GROUP_ITEMS")
		:AddUniqueStringField("itemString")
		:AddStringField("groupPath")
		:AddIndex("groupPath")
		:Commit()
	private.itemStringMapReader = private.itemStringMap:CreateReader()
	Groups.RebuildDatabase()
end

function Groups.RebuildDatabase()
	-- convert ignoreRandomEnchants to ignoreItemVariations
	for _, info in pairs(TSM.db.profile.userData.groups) do
		if info.ignoreRandomEnchants ~= nil then
			info.ignoreItemVariations = info.ignoreRandomEnchants
			info.ignoreRandomEnchants = nil
		end
	end

	for groupPath, groupInfo in pairs(TSM.db.profile.userData.groups) do
		if type(groupPath) == "string" and not strmatch(groupPath, TSM.CONST.GROUP_SEP..TSM.CONST.GROUP_SEP) then
			-- check the contents of groupInfo
			for _, moduleName in TSM.Operations.ModuleIterator() do
				groupInfo[moduleName] = groupInfo[moduleName] or {}
				if groupPath == TSM.CONST.ROOT_GROUP_PATH then
					-- root group should have override flag set
					groupInfo[moduleName].override = true
				end
			end
			for key in pairs(groupInfo) do
				if TSM.Operations.ModuleExists(key) then
					-- this is a set of module operations
					local operations = groupInfo[key]
					while #operations > TSM.Operations.GetMaxNumber(key) do
						-- remove extra operations
						tremove(operations)
					end
					for key2 in pairs(operations) do
						if key2 == "override" then
							-- ensure the override field is either true or nil
							operations.override = operations.override and true or nil
						elseif type(key2) ~= "number" or key2 <= 0 or key2 > #operations then
							-- this is an invalid key
							TSM:LOG_ERR("Removing invalid operations key (%s, %s): %s", groupPath, key, tostring(key2))
							operations[key2] = nil
						end
					end
					for i = #operations, 1, -1 do
						if type(operations[i]) ~= "string" or operations[i] == "" or not TSM.Operations.Exists(key, operations[i]) then
							-- remove operations which no longer exist
							-- we used to have a bunch of placeholder "" operations, so don't log for those
							if operations[i] ~= "" then
								TSM:LOG_ERR("Removing invalid operation from group (%s): %s, %s", groupPath, key, tostring(operations[i]))
							end
							tremove(operations, i)
						end
					end
				elseif key ~= "ignoreItemVariations" then
					-- invalid key
					TSM:LOG_ERR("Removing invalid groupInfo key (%s): %s", groupPath, tostring(key))
					groupInfo[key] = nil
				end
			end
		else
			-- remove invalid group paths
			TSM:LOG_ERR("Removing invalid group path: %s", tostring(groupPath))
			TSM.db.profile.userData.groups[groupPath] = nil
		end
	end

	if not TSM.db.profile.userData.groups[TSM.CONST.ROOT_GROUP_PATH] then
		-- set the override flag for all top-level groups and then create it
		for groupPath, moduleOperations in pairs(TSM.db.profile.userData.groups) do
			if not strfind(groupPath, TSM.CONST.GROUP_SEP) then
				for _, moduleName in TSM.Operations.ModuleIterator() do
					moduleOperations[moduleName].override = true
				end
			end
		end
		-- create the root group manually with default operations
		TSM.db.profile.userData.groups[TSM.CONST.ROOT_GROUP_PATH] = {}
		for _, moduleName in TSM.Operations.ModuleIterator() do
			assert(TSM.Operations.Exists(moduleName, "#Default"))
			TSM.db.profile.userData.groups[TSM.CONST.ROOT_GROUP_PATH][moduleName] = { "#Default", override = true }
		end
	end

	for _, groupPath in Groups.GroupIterator() do
		local parentPath = TSM.Groups.Path.GetParent(groupPath)
		if not TSM.db.profile.userData.groups[parentPath] then
			-- the parent group doesn't exist, so remove this group
			TSM:LOG_ERR("Removing group with non-existent parent: %s", tostring(groupPath))
			TSM.db.profile.userData.groups[groupPath] = nil
		else
			for _, moduleName in TSM.Operations.ModuleIterator() do
				if not Groups.HasOperationOverride(groupPath, moduleName) then
					private.InheritParentOperations(groupPath, moduleName)
				end
			end
		end
	end

	-- fix up any invalid items
	local newPaths = TSMAPI_FOUR.Util.AcquireTempTable()
	for itemString, groupPath in pairs(TSM.db.profile.userData.items) do
		local newItemString = TSMAPI_FOUR.Item.ToItemString(itemString)
		if not newItemString then
			-- this itemstring is invalid
			TSM:LOG_ERR("Itemstring (%s) is invalid", tostring(itemString))
			TSM.db.profile.userData.items[itemString] = nil
		elseif groupPath == TSM.CONST.ROOT_GROUP_PATH or not TSM.db.profile.userData.groups[groupPath] then
			-- this group doesn't exist
			TSM:LOG_ERR("Group (%s) doesn't exist, so removing item (%s)", groupPath, itemString)
			TSM.db.profile.userData.items[itemString] = nil
		elseif newItemString ~= itemString then
			-- remove this invalid itemstring from this group
			TSM:LOG_ERR("Itemstring changed (%s -> %s), so removing it from group (%s)", itemString, newItemString, groupPath)
			TSM.db.profile.userData.items[itemString] = nil
			-- add this new item to this group if it's not already in one
			if not TSM.db.profile.userData.items[newItemString] then
				newPaths[newItemString] = groupPath
				TSM:LOG_ERR("Adding to group instead (%s)", groupPath)
			end
		end
	end
	for itemString, groupPath in pairs(newPaths) do
		TSM.db.profile.userData.items[itemString] = groupPath
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(newPaths)

	-- populate our database
	private.itemDB:TruncateAndBulkInsertStart()
	for itemString, groupPath in pairs(TSM.db.profile.userData.items) do
		private.itemDB:BulkInsertNewRow(itemString, groupPath)
	end
	private.itemDB:BulkInsertEnd()
	private.itemStringMap:SetCallbacksPaused(true)
	for key in private.itemStringMap:KeyIterator() do
		private.itemStringMap:ValueChanged(key)
	end
	private.itemStringMap:SetCallbacksPaused(false)
end

function Groups.TranslateItemString(itemString)
	return private.itemStringMapReader[itemString]
end

function Groups.GetAutoBaseItemStringSmartMap()
	return private.itemStringMap
end

function Groups.GetItemDBForJoin()
	return private.itemDB
end

function Groups.Create(groupPath)
	assert(not TSM.db.profile.userData.groups[groupPath])
	local parentPath = TSM.Groups.Path.GetParent(groupPath)
	assert(parentPath)
	if parentPath ~= TSM.CONST.ROOT_GROUP_PATH and not TSM.db.profile.userData.groups[parentPath] then
		-- recursively create the parent group first
		Groups.Create(parentPath)
	end
	TSM.db.profile.userData.groups[groupPath] = {}
	for _, moduleName in TSM.Operations.ModuleIterator() do
		TSM.db.profile.userData.groups[groupPath][moduleName] = {}
		-- assign all parent operations to this group
		for _, operationName in ipairs(TSM.db.profile.userData.groups[parentPath][moduleName]) do
			tinsert(TSM.db.profile.userData.groups[groupPath][moduleName], operationName)
		end
	end
end

function Groups.Move(groupPath, newGroupPath)
	assert(not TSM.db.profile.userData.groups[newGroupPath], "Target group already exists")
	assert(groupPath ~= TSM.CONST.ROOT_GROUP_PATH, "Can't move root group")
	assert(TSM.db.profile.userData.groups[groupPath], "Group doesn't exist")
	local newParentPath = TSM.Groups.Path.GetParent(newGroupPath)
	assert(newParentPath and TSM.db.profile.userData.groups[newParentPath], "Parent of target is invalid")

	local changes = TSMAPI_FOUR.Util.AcquireTempTable()
	private.itemDB:SetQueryUpdatesPaused(true)

	-- get a list of group path changes for this group and all its subgroups
	local gsubEscapedNewGroupPath = gsub(newGroupPath, "%%", "%%%%")
	for path in pairs(TSM.db.profile.userData.groups) do
		if path == groupPath or TSM.Groups.Path.IsChild(path, groupPath) then
			changes[path] = gsub(path, "^"..TSMAPI_FOUR.Util.StrEscape(groupPath), gsubEscapedNewGroupPath)
		end
	end

	for oldPath, newPath in pairs(changes) do
		-- move the group
		assert(TSM.db.profile.userData.groups[oldPath] and not TSM.db.profile.userData.groups[newPath])
		TSM.db.profile.userData.groups[newPath] = TSM.db.profile.userData.groups[oldPath]
		TSM.db.profile.userData.groups[oldPath] = nil

		-- move the items
		local query = private.itemDB:NewQuery()
			:Equal("groupPath", oldPath)
		for _, row in query:Iterator() do
			local itemString = row:GetField("itemString")
			assert(TSM.db.profile.userData.items[itemString])
			TSM.db.profile.userData.items[itemString] = newPath
			row:SetField("groupPath", newPath)
				:Update()
		end
		query:Release()
	end

	-- update the operations all groups which were moved
	for _, moduleName in TSM.Operations.ModuleIterator() do
		if not Groups.HasOperationOverride(newGroupPath, moduleName) then
			private.InheritParentOperations(newGroupPath, moduleName)
			private.UpdateChildGroupOperations(newGroupPath, moduleName)
		end
	end

	TSMAPI_FOUR.Util.ReleaseTempTable(changes)
	private.itemDB:SetQueryUpdatesPaused(false)
end

function Groups.Delete(groupPath)
	assert(groupPath ~= TSM.CONST.ROOT_GROUP_PATH and TSM.db.profile.userData.groups[groupPath])
	local parentPath = TSM.Groups.Path.GetParent(groupPath)
	assert(parentPath)
	if parentPath == TSM.CONST.ROOT_GROUP_PATH then
		parentPath = nil
	end

	-- delete this group and all subgroups
	for path in pairs(TSM.db.profile.userData.groups) do
		if path == groupPath or TSM.Groups.Path.IsChild(path, groupPath) then
			-- delete this group
			TSM.db.profile.userData.groups[path] = nil
		end
	end
	-- remove all items from our DB
	private.itemDB:SetQueryUpdatesPaused(true)
	local query = private.itemDB:NewQuery()
		:Or()
			:Equal("groupPath", groupPath)
			:Matches("groupPath", "^"..TSMAPI_FOUR.Util.StrEscape(groupPath)..TSM.CONST.GROUP_SEP)
		:End()
	local updateMapItems = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, row in query:Iterator() do
		local itemString = row:GetField("itemString")
		assert(TSM.db.profile.userData.items[itemString])
		TSM.db.profile.userData.items[itemString] = nil
		private.itemDB:DeleteRow(row)
		updateMapItems[itemString] = true
	end
	query:Release()
	private.itemStringMap:SetCallbacksPaused(true)
	for itemString in private.itemStringMap:KeyIterator() do
		if updateMapItems[itemString] or updateMapItems[TSMAPI_FOUR.Item.ToBaseItemStringFast(itemString)] then
			-- either this item itself was removed from a group, or the base item was - in either case trigger an update
			private.itemStringMap:ValueChanged(itemString)
		end
	end
	private.itemStringMap:SetCallbacksPaused(false)
	TSMAPI_FOUR.Util.ReleaseTempTable(updateMapItems)
	private.itemDB:SetQueryUpdatesPaused(false)
end

function Groups.Exists(groupPath)
	return TSM.db.profile.userData.groups[groupPath] and true or false
end

function Groups.SetItemGroup(itemString, groupPath)
	assert(not groupPath or (groupPath ~= TSM.CONST.ROOT_GROUP_PATH and TSM.db.profile.userData.groups[groupPath]))

	local row = private.itemDB:GetUniqueRow("itemString", itemString)
	local updateMap = false
	if row then
		if groupPath then
			row:SetField("groupPath", groupPath)
				:Update()
			row:Release()
		else
			private.itemDB:DeleteRow(row)
			row:Release()
			-- we just removed an item from a group, so update the map
			updateMap = true
		end
	else
		assert(groupPath)
		private.itemDB:NewRow()
			:SetField("itemString", itemString)
			:SetField("groupPath", groupPath)
			:Create()
		-- we just added a new item to a group, so update the map
		updateMap = true
	end
	TSM.db.profile.userData.items[itemString] = groupPath
	if updateMap then
		private.itemStringMap:SetCallbacksPaused(true)
		private.itemStringMap:ValueChanged(itemString)
		if itemString == TSMAPI_FOUR.Item.ToBaseItemStringFast(itemString) then
			-- this is a base item string, so need to also update all other items whose base item is equal to this item
			for mapItemString in private.itemStringMap:KeyIterator() do
				if TSMAPI_FOUR.Item.ToBaseItemStringFast(mapItemString) == itemString then
					private.itemStringMap:ValueChanged(mapItemString)
				end
			end
		end
		private.itemStringMap:SetCallbacksPaused(false)
	end
end

function Groups.GetPathByItem(itemString)
	itemString = TSMAPI_FOUR.Item.ToBaseItemString(itemString, true)
	assert(itemString)
	local groupPath = private.itemDB:GetUniqueRowField("itemString", itemString, "groupPath") or TSM.CONST.ROOT_GROUP_PATH
	assert(TSM.db.profile.userData.groups[groupPath])
	return groupPath
end

function Groups.IsItemInGroup(itemString)
	return private.itemDB:HasUniqueRow("itemString", itemString)
end

function Groups.ItemIterator(groupPathFilter)
	assert(groupPathFilter ~= TSM.CONST.ROOT_GROUP_PATH)
	local query = private.itemDB:NewQuery()
		:Select("itemString", "groupPath")
	if groupPathFilter then
		query:Equal("groupPath", groupPathFilter)
	end
	return query:IteratorAndRelease()
end

function Groups.GroupIterator()
	local groups = TSMAPI_FOUR.Util.AcquireTempTable()
	for groupPath in pairs(TSM.db.profile.userData.groups) do
		if groupPath ~= TSM.CONST.ROOT_GROUP_PATH then
			tinsert(groups, groupPath)
		end
	end
	Groups.SortGroupList(groups)
	return TSMAPI_FOUR.Util.TempTableIterator(groups)
end

function Groups.SortGroupList(list)
	sort(list, private.GroupSortFunction)
end

function Groups.SetOperationOverride(groupPath, moduleName, override)
	assert(TSM.db.profile.userData.groups[groupPath])
	assert(groupPath ~= TSM.CONST.ROOT_GROUP_PATH)
	if override == (TSM.db.profile.userData.groups[groupPath][moduleName].override and true or false) then
		return
	end

	if not override then
		TSM.db.profile.userData.groups[groupPath][moduleName].override = nil
		private.InheritParentOperations(groupPath, moduleName)
		private.UpdateChildGroupOperations(groupPath, moduleName)
	else
		wipe(TSM.db.profile.userData.groups[groupPath][moduleName])
		TSM.db.profile.userData.groups[groupPath][moduleName].override = true
		private.UpdateChildGroupOperations(groupPath, moduleName)
	end
end

function Groups.HasOperationOverride(groupPath, moduleName)
	return TSM.db.profile.userData.groups[groupPath][moduleName].override
end

function Groups.OperationIterator(groupPath, moduleName)
	return ipairs(TSM.db.profile.userData.groups[groupPath][moduleName])
end

function Groups.AppendOperation(groupPath, moduleName, operationName)
	assert(TSM.Operations.Exists(moduleName, operationName))
	local groupOperations = TSM.db.profile.userData.groups[groupPath][moduleName]
	assert(groupOperations.override and #groupOperations < TSM.Operations.GetMaxNumber(moduleName))
	tinsert(groupOperations, operationName)
	private.UpdateChildGroupOperations(groupPath, moduleName)
end

function Groups.RemoveOperation(groupPath, moduleName, operationIndex)
	local groupOperations = TSM.db.profile.userData.groups[groupPath][moduleName]
	assert(groupOperations.override and groupOperations[operationIndex])
	tremove(groupOperations, operationIndex)
	private.UpdateChildGroupOperations(groupPath, moduleName)
end

function Groups.RemoveOperationByName(groupPath, moduleName, operationName)
	local groupOperations = TSM.db.profile.userData.groups[groupPath][moduleName]
	assert(groupOperations.override)
	assert(TSMAPI_FOUR.Util.TableRemoveByValue(groupOperations, operationName) > 0)
	private.UpdateChildGroupOperations(groupPath, moduleName)
end

function Groups.RemoveOperationFromAllGroups(moduleName, operationName)
	-- just blindly remove from all groups - no need to check for override
	TSMAPI_FOUR.Util.TableRemoveByValue(TSM.db.profile.userData.groups[TSM.CONST.ROOT_GROUP_PATH][moduleName], operationName)
	for _, groupPath in Groups.GroupIterator() do
		TSMAPI_FOUR.Util.TableRemoveByValue(TSM.db.profile.userData.groups[groupPath][moduleName], operationName)
	end
end

function Groups.OperationRenamed(moduleName, oldName, newName)
	-- just blindly rename in all groups - no need to check for override
	for _, info in pairs(TSM.db.profile.userData.groups) do
		for i = 1, #info[moduleName] do
			if info[moduleName][i] == oldName then
				info[moduleName][i] = newName
			end
		end
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GroupSortFunction(a, b)
	return strlower(gsub(a, TSM.CONST.GROUP_SEP, "\001")) < strlower(gsub(b, TSM.CONST.GROUP_SEP, "\001"))
end

function private.InheritParentOperations(groupPath, moduleName)
	local parentGroupPath = TSM.Groups.Path.GetParent(groupPath)
	local override = TSM.db.profile.userData.groups[groupPath][moduleName].override
	wipe(TSM.db.profile.userData.groups[groupPath][moduleName])
	TSM.db.profile.userData.groups[groupPath][moduleName].override = override
	for _, operationName in ipairs(TSM.db.profile.userData.groups[parentGroupPath][moduleName]) do
		tinsert(TSM.db.profile.userData.groups[groupPath][moduleName], operationName)
	end
end

function private.UpdateChildGroupOperations(groupPath, moduleName)
	for _, childGroupPath in Groups.GroupIterator() do
		if TSM.Groups.Path.IsChild(childGroupPath, groupPath) and not Groups.HasOperationOverride(childGroupPath, moduleName) then
			private.InheritParentOperations(childGroupPath, moduleName)
		end
	end
end



-- ============================================================================
-- Item String Smart Map
-- ============================================================================

do
	private.itemStringMap = TSM.SmartMap.New("string", "string", function(itemString)
		if Groups.IsItemInGroup(itemString) then
			-- this item is in a group, so just return it
			return itemString
		end
		local baseItemString = TSMAPI_FOUR.Item.ToBaseItemStringFast(itemString)
		-- return the base item if it's in a group; otherwise return the original item
		return Groups.IsItemInGroup(baseItemString) and baseItemString or itemString
	end)
end
