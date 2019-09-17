-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Database Class.
-- This class represents a database which has a defined schema, contains rows which follow the schema, and allows for
-- queries to made against it. It also supports more advanced features such as indexes (including unique).
-- @classmod Database

local _, TSM = ...
local Database = TSMAPI_FOUR.Class.DefineClass("Database")
TSM.Database.classes.Database = Database
local private = {
	indexListSortValues = nil,
	bulkInsertTemp = {},
	smartMapReaderDatabaseLookup = {},
	smartMapReaderFieldLookup = {},
}



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function Database.__init(self, schema)
	assert(schema:__isa(TSM.Database.classes.DatabaseSchema))
	self._queries = {}
	self._indexLists = {}
	self._uniques = {}
	self._indexOrUniqueFields = {}
	self._multiFieldIndexFields = {}
	self._queryUpdatesPaused = 0
	self._queuedQueryUpdate = false
	self._bulkInsertContext = nil
	self._fieldOffsetLookup = {}
	self._fieldTypeLookup = {}
	self._storedFieldList = {}
	self._numStoredFields = 0
	self._data = {}
	self._uuids = {}
	self._uuidToDataOffsetLookup = {}
	self._newRowTemp = TSM.Database.GetDatabaseQueryResultRow()
	self._newRowTempInUse = false
	self._smartMapInputLookup = {}
	self._smartMapInputFields = {}
	self._smartMapReaderLookup = {}

	-- process all the fields and grab the indexFields for further processing
	local indexFields = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, fieldName, fieldType, isIndex, isUnique, smartMap, smartMapInput in schema:_FieldIterator() do
		if smartMap then
			-- smart map fields aren't actually stored in the DB
			assert(self._fieldOffsetLookup[smartMapInput], "SmartMap field must be based on a stored field")
			local reader = smartMap:CreateReader(private.SmartMapReaderCallback)
			private.smartMapReaderDatabaseLookup[reader] = self
			private.smartMapReaderFieldLookup[reader] = fieldName
			self._smartMapInputLookup[fieldName] = smartMapInput
			self._smartMapInputFields[smartMapInput] = self._smartMapInputFields[smartMapInput] or {}
			tinsert(self._smartMapInputFields[smartMapInput], fieldName)
			self._smartMapReaderLookup[fieldName] = reader
		else
			self._numStoredFields = self._numStoredFields + 1
			self._fieldOffsetLookup[fieldName] = self._numStoredFields
			tinsert(self._storedFieldList, fieldName)
		end
		self._fieldTypeLookup[fieldName] = fieldType
		if isIndex then
			self._indexLists[fieldName] = {}
			tinsert(indexFields, fieldName)
		end
		if isUnique then
			self._uniques[fieldName] = {}
			-- insert uniques first since they are most efficient to query on
			tinsert(self._indexOrUniqueFields, fieldName)
		end
	end

	-- add multi-field indexes to our indexFields list
	for fieldName in schema:_MultiFieldIndexIterator() do
		self._indexLists[fieldName] = {}
		tinsert(indexFields, fieldName)
	end

	-- sort the multi-column indexes first since they are more efficient
	sort(indexFields, private.IndexSortHelper)

	-- process the index fields
	for _, field in ipairs(indexFields) do
		if strmatch(field, TSM.CONST.DB_INDEX_FIELD_SEP) then
			tinsert(self._multiFieldIndexFields, field)
			self._multiFieldIndexFields[field] = { strsplit(TSM.CONST.DB_INDEX_FIELD_SEP, field) }
			for i, subField in ipairs(self._multiFieldIndexFields[field]) do
				self._multiFieldIndexFields[field][i] = self._fieldOffsetLookup[subField]
			end
		end
		tinsert(self._indexOrUniqueFields, field)
	end

	TSMAPI_FOUR.Util.ReleaseTempTable(indexFields)
	schema:_Release()
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

--- Iterate over the fields.
-- @tparam Database self The database object
-- @return An iterator which iterates over the database's fields and has the following values: `field`
function Database.FieldIterator(self)
	return TSMAPI_FOUR.Util.TableKeyIterator(self._fieldOffsetLookup)
end

--- Create a new row.
-- @tparam Database self The database object
-- @treturn DatabaseRow The new database row object
function Database.NewRow(self)
	assert(not self._bulkInsertContext)
	local row = nil
	if not self._newRowTempInUse then
		row = self._newRowTemp
		self._newRowTempInUse = true
	else
		row = TSM.Database.GetDatabaseQueryResultRow()
	end
	row:_Acquire(self, nil, true)
	return row
end

--- Create a new query.
-- @tparam Database self The database object
-- @treturn DatabaseQuery The new database query object
function Database.NewQuery(self)
	assert(not self._bulkInsertContext)
	local query = TSM.Database.GetDatabaseQuery()
	query:_Acquire(self)
	return query
end

--- Delete a row by UUID.
-- @tparam Database self The database object
-- @tparam number uuid The UUID of the row to delete
function Database.DeleteRowByUUID(self, uuid)
	assert(not self._bulkInsertContext)
	assert(self._uuidToDataOffsetLookup[uuid])
	for indexField, indexList in pairs(self._indexLists) do
		local indexValue = self:_GetRowIndexValue(uuid, indexField)
		local deleteIndex = nil
		local lowIndex, highIndex = self:_GetIndexListIndexRange(indexField, indexValue)
		for i = lowIndex, highIndex do
			if indexList[i] == uuid then
				deleteIndex = i
				break
			end
		end
		assert(deleteIndex)
		tremove(indexList, deleteIndex)
	end
	for field, uniqueValues in pairs(self._uniques) do
		uniqueValues[self:_GetRowData(uuid, field)] = nil
	end

	-- lookup the index of the row being deleted
	local uuidIndex = ((self._uuidToDataOffsetLookup[uuid] - 1) / self._numStoredFields) + 1
	local rowIndex = self._uuidToDataOffsetLookup[uuid]
	assert(rowIndex)

	-- get the index of the last row
	local lastUUIDIndex = #self._data / self._numStoredFields
	local lastRowIndex = #self._data - self._numStoredFields + 1
	assert(lastRowIndex > 0 and lastUUIDIndex > 0)

	-- remove this row from both lookups
	self._uuidToDataOffsetLookup[uuid] = nil

	if rowIndex == lastRowIndex then
		-- this is the last row so just remove it
		for _ = 1, self._numStoredFields do
			tremove(self._data)
		end
		assert(uuidIndex == #self._uuids)
		self._uuids[#self._uuids] = nil
	else
		-- this row is in the middle, so move the last row into this slot
		local moveRowUUID = tremove(self._uuids)
		self._uuids[uuidIndex] = moveRowUUID
		self._uuidToDataOffsetLookup[moveRowUUID] = rowIndex
		for i = self._numStoredFields, 1, -1 do
			local moveDataIndex = lastRowIndex + i - 1
			assert(moveDataIndex == #self._data)
			self._data[rowIndex + i - 1] = self._data[moveDataIndex]
			tremove(self._data)
		end
	end

	self:_UpdateQueries()
end

--- Delete a row.
-- @tparam Database self The database object
-- @tparam DatabaseRow deleteRow The database row object to delete
function Database.DeleteRow(self, deleteRow)
	assert(not self._bulkInsertContext)
	self:DeleteRowByUUID(deleteRow:GetUUID())
end

--- Remove all rows.
-- @tparam Database self The database object
function Database.Truncate(self)
	wipe(self._uuids)
	wipe(self._uuidToDataOffsetLookup)
	wipe(self._data)
	for _, indexList in pairs(self._indexLists) do
		wipe(indexList)
	end
	for _, uniqueValues in pairs(self._uniques) do
		wipe(uniqueValues)
	end
	self:_UpdateQueries()
end

--- Pauses or unpauses query updates.
-- Query updates should be paused while performing batch row updates to improve performance and avoid spamming callbacks.
-- @tparam Database self The database object
-- @tparam boolean paused Whether or not query updates should be paused
function Database.SetQueryUpdatesPaused(self, paused)
	self._queryUpdatesPaused = self._queryUpdatesPaused + (paused and 1 or -1)
	assert(self._queryUpdatesPaused >= 0)
	if self._queryUpdatesPaused == 0 and self._queuedQueryUpdate then
		self:_UpdateQueries()
	end
end

--- Get a unique row.
-- @tparam Database self The database object
-- @tparam string field The unique field
-- @param value The value of the unique field
-- @treturn ?DatabaseRow The result row
function Database.GetUniqueRow(self, field, value)
	local fieldType = self:_GetFieldType(field)
	if not fieldType then
		error(format("Field %s doesn't exist", tostring(field)), 3)
	elseif fieldType ~= type(value) then
		error(format("Field %s should be a %s, got %s", tostring(field), tostring(fieldType), type(value)), 3)
	elseif not self:_IsUnique(field) then
		error(format("Field %s is not unique", tostring(field)), 3)
	end
	local uuid = self:_GetUniqueRow(field, value)
	if not uuid then
		return
	end
	local row = TSM.Database.GetDatabaseQueryResultRow()
	row:_Acquire(self)
	row:_SetUUID(uuid)
	return row
end

--- Get a single field from a unique row.
-- @tparam Database self The database object
-- @tparam string uniqueField The unique field
-- @param uniqueValue The value of the unique field
-- @tparam string field The field to get
-- @return The value of the field
function Database.GetUniqueRowField(self, uniqueField, uniqueValue, field)
	local fieldType = self:_GetFieldType(uniqueField)
	if not fieldType then
		error(format("Field %s doesn't exist", tostring(uniqueField)), 3)
	elseif fieldType ~= type(uniqueValue) then
		error(format("Field %s should be a %s, got %s", tostring(uniqueField), tostring(fieldType), type(uniqueValue)), 3)
	elseif not self:_IsUnique(uniqueField) then
		error(format("Field %s is not unique", tostring(uniqueField)), 3)
	end
	local uuid = self:_GetUniqueRow(uniqueField, uniqueValue)
	if not uuid then
		return
	end
	return self:_GetRowData(uuid, field)
end

--- Set a single field within a unique row.
-- @tparam Database self The database object
-- @tparam string uniqueField The unique field
-- @param uniqueValue The value of the unique field
-- @tparam string field The field to set
-- @param value The value to set the field to
function Database.SetUniqueRowField(self, uniqueField, uniqueValue, field, value)
	local uniqueFieldType = self:_GetFieldType(uniqueField)
	local fieldType = self:_GetFieldType(field)
	if not uniqueFieldType then
		error(format("Field %s doesn't exist", tostring(uniqueField)), 3)
	elseif uniqueFieldType ~= type(uniqueValue) then
		error(format("Field %s should be a %s, got %s", tostring(uniqueField), tostring(uniqueFieldType), type(uniqueValue)), 3)
	elseif not self:_IsUnique(uniqueField) then
		error(format("Field %s is not unique", tostring(uniqueField)), 3)
	elseif not fieldType then
		error(format("Field %s doesn't exist", tostring(field)), 3)
	elseif fieldType ~= type(value) then
		error(format("Field %s should be a %s, got %s", tostring(field), tostring(fieldType), type(value)), 3)
	elseif self:_IsUnique(field) or self:_IsIndex(field) then
		error(format("Field %s is unique or an index and cannot be updated using this method", field))
	end
	local uuid = self:_GetUniqueRow(uniqueField, uniqueValue)
	assert(uuid)
	local dataOffset = self._uuidToDataOffsetLookup[uuid]
	local fieldOffset = self._fieldOffsetLookup[field]
	if not dataOffset then
		error("Invalid UUID: "..tostring(uuid))
	elseif not fieldOffset then
		error("Invalid field: "..tostring(field))
	end
	self._data[dataOffset + fieldOffset - 1] = value
	self:_UpdateQueries()
end

--- Check whether or not a row with a unique value exists.
-- @tparam Database self The database object
-- @tparam string uniqueField The unique field
-- @param uniqueValue The value of the unique field
-- @treturn boolean Whether or not a row with the unique value exists
function Database.HasUniqueRow(self, uniqueField, uniqueValue)
	local fieldType = self:_GetFieldType(uniqueField)
	if not fieldType then
		error(format("Field %s doesn't exist", tostring(uniqueField)), 3)
	elseif fieldType ~= type(uniqueValue) then
		error(format("Field %s should be a %s, got %s", tostring(uniqueField), tostring(fieldType), type(uniqueValue)), 3)
	elseif not self:_IsUnique(uniqueField) then
		error(format("Field %s is not unique", tostring(uniqueField)), 3)
	end
	return self:_GetUniqueRow(uniqueField, uniqueValue) and true or false
end

--- Gets a row by it's UUID.
-- @tparam Database self The database object
-- @tparam number uuid The UUID of the row
-- @tparam string field The field
-- @return The value of the field
function Database.GetRowFieldByUUID(self, uuid, field)
	assert(not self._bulkInsertContext)
	assert(self._uuidToDataOffsetLookup[uuid])

	local fieldType = self:_GetFieldType(field)
	if not fieldType then
		error(format("Field %s doesn't exist", tostring(field)), 3)
	end
	return self:_GetRowData(uuid, field)
end

--- Starts a bulk insert into the database.
-- @tparam Database self The database object
function Database.BulkInsertStart(self)
	assert(not self._bulkInsertContext)
	self._bulkInsertContext = TSMAPI_FOUR.Util.AcquireTempTable()
	self._bulkInsertContext.hasNewData = false
	self._bulkInsertContext.indexValues = TSMAPI_FOUR.Util.AcquireTempTable()
	for field in pairs(self._indexLists) do
		self._bulkInsertContext.indexValues[field] = TSMAPI_FOUR.Util.AcquireTempTable()
		for i = 1, #self._uuids do
			local uuid = self._uuids[i]
			self._bulkInsertContext.indexValues[field][uuid] = self:_GetRowIndexValue(uuid, field)
		end
	end
	if not next(self._uniques) and #self._multiFieldIndexFields == 0 and TSMAPI_FOUR.Util.Count(self._indexLists) == 1 and self._indexLists[self._storedFieldList[1]] then
		self._bulkInsertContext.fastNum = self._numStoredFields
	end
	self:SetQueryUpdatesPaused(true)
end

--- Truncates and then starts a bulk insert into the database.
-- @tparam Database self The database object
function Database.TruncateAndBulkInsertStart(self)
	self:SetQueryUpdatesPaused(true)
	self:Truncate()
	self:BulkInsertStart()
	-- :BulkInsertStart() pauses query updates, so undo our pausing
	self:SetQueryUpdatesPaused(false)
end

--- Inserts a new row as part of the on-going bulk insert.
-- @tparam Database self The database object
-- @param ... The fields which make up this new row (in `schema.fieldOrder` order)
function Database.BulkInsertNewRow(self, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, extraValue)
	if not self._bulkInsertContext then
		error("Bulk insert hasn't been started")
	elseif extraValue ~= nil then
		error("Too many values")
	elseif not self._bulkInsertContext.hasNewData then
		self._bulkInsertContext.hasNewData = true
		for _, indexList in pairs(self._indexLists) do
			wipe(indexList)
		end
	end

	local tempTbl = private.bulkInsertTemp
	tempTbl[1] = v1
	tempTbl[2] = v2
	tempTbl[3] = v3
	tempTbl[4] = v4
	tempTbl[5] = v5
	tempTbl[6] = v6
	tempTbl[7] = v7
	tempTbl[8] = v8
	tempTbl[9] = v9
	tempTbl[10] = v10
	tempTbl[11] = v11
	tempTbl[12] = v12
	tempTbl[13] = v13
	tempTbl[14] = v14
	tempTbl[15] = v15
	tempTbl[16] = v16
	tempTbl[17] = v17
	tempTbl[18] = v18
	tempTbl[19] = v19
	tempTbl[20] = v20
	tempTbl[21] = v21
	tempTbl[22] = v22
	local numFields = #tempTbl
	if numFields ~= self._numStoredFields then
		error("Invalid number of values")
	end
	local uuid = TSM.Database.GetNextUUID()
	local rowIndex = #self._data + 1
	self._uuidToDataOffsetLookup[uuid] = rowIndex
	self._uuids[#self._uuids + 1] = uuid

	for i = 1, numFields do
		local field = self._storedFieldList[i]
		local value = tempTbl[i]
		local fieldType = self._fieldTypeLookup[field]
		if type(value) ~= fieldType then
			error(format("Field %s should be a %s, got %s", tostring(field), tostring(fieldType), type(value)), 2)
		end
		self._data[rowIndex + i - 1] = value
		local uniqueValues = self._uniques[field]
		if uniqueValues then
			if uniqueValues[value] ~= nil then
				error("A row with this unique value already exists", 2)
			end
			uniqueValues[value] = uuid
		end
		if self._indexLists[field] then
			self._bulkInsertContext.indexValues[field][uuid] = value
		end
		local smartMapFields = self._smartMapInputFields[field]
		if smartMapFields then
			for j = 1, #smartMapFields do
				local smartMapField = smartMapFields[j]
				if self._indexLists[smartMapField] then
					self._bulkInsertContext.indexValues[smartMapField][uuid] = self._smartMapReaderLookup[smartMapField][value]
				end
			end
		end
	end

	-- insert this uuid into each index list and get the multi-field index values
	for i = 1, #self._multiFieldIndexFields do
		-- currently just support multi-field indexes consisting of 2 fields
		local field = self._multiFieldIndexFields[i]
		local f1 = self._multiFieldIndexFields[field][1]
		local f2 = self._multiFieldIndexFields[field][2]
		self._bulkInsertContext.indexValues[field][uuid] = tempTbl[f1]..TSM.CONST.DB_INDEX_VALUE_SEP..tempTbl[f2]
	end
	return uuid
end

function Database.BulkInsertNewRowFast6(self, v1, v2, v3, v4, v5, v6, extraValue)
	if not self._bulkInsertContext then
		error("Bulk insert hasn't been started")
	elseif self._bulkInsertContext.fastNum ~= 6 then
		error("Invalid usage of fast insert")
	elseif v6 == nil or extraValue ~= nil then
		error("Wrong number of values")
	elseif not self._bulkInsertContext.hasNewData then
		self._bulkInsertContext.hasNewData = true
		for _, indexList in pairs(self._indexLists) do
			wipe(indexList)
		end
	end

	local uuid = TSM.Database.GetNextUUID()
	local rowIndex = #self._data + 1
	self._uuidToDataOffsetLookup[uuid] = rowIndex
	self._uuids[#self._uuids + 1] = uuid

	self._data[rowIndex] = v1
	self._data[rowIndex + 1] = v2
	self._data[rowIndex + 2] = v3
	self._data[rowIndex + 3] = v4
	self._data[rowIndex + 4] = v5
	self._data[rowIndex + 5] = v6

	-- the first field is always an index (and the only index)
	self._bulkInsertContext.indexValues[self._storedFieldList[1]][uuid] = v1
end

function Database.BulkInsertNewRowFast8(self, v1, v2, v3, v4, v5, v6, v7, v8, extraValue)
	if not self._bulkInsertContext then
		error("Bulk insert hasn't been started")
	elseif self._bulkInsertContext.fastNum ~= 8 then
		error("Invalid usage of fast insert")
	elseif v8 == nil or extraValue ~= nil then
		error("Wrong number of values")
	elseif not self._bulkInsertContext.hasNewData then
		self._bulkInsertContext.hasNewData = true
		for _, indexList in pairs(self._indexLists) do
			wipe(indexList)
		end
	end

	local uuid = TSM.Database.GetNextUUID()
	local rowIndex = #self._data + 1
	self._uuidToDataOffsetLookup[uuid] = rowIndex
	self._uuids[#self._uuids + 1] = uuid

	self._data[rowIndex] = v1
	self._data[rowIndex + 1] = v2
	self._data[rowIndex + 2] = v3
	self._data[rowIndex + 3] = v4
	self._data[rowIndex + 4] = v5
	self._data[rowIndex + 5] = v6
	self._data[rowIndex + 6] = v7
	self._data[rowIndex + 7] = v8

	-- the first field is always an index (and the only index)
	self._bulkInsertContext.indexValues[self._storedFieldList[1]][uuid] = v1
end

function Database.BulkInsertNewRowFast11(self, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, extraValue)
	if not self._bulkInsertContext then
		error("Bulk insert hasn't been started")
	elseif self._bulkInsertContext.fastNum ~= 11 then
		error("Invalid usage of fast insert")
	elseif v11 == nil or extraValue ~= nil then
		error("Wrong number of values")
	elseif not self._bulkInsertContext.hasNewData then
		self._bulkInsertContext.hasNewData = true
		for _, indexList in pairs(self._indexLists) do
			wipe(indexList)
		end
	end

	local uuid = TSM.Database.GetNextUUID()
	local rowIndex = #self._data + 1
	self._uuidToDataOffsetLookup[uuid] = rowIndex
	self._uuids[#self._uuids + 1] = uuid

	self._data[rowIndex] = v1
	self._data[rowIndex + 1] = v2
	self._data[rowIndex + 2] = v3
	self._data[rowIndex + 3] = v4
	self._data[rowIndex + 4] = v5
	self._data[rowIndex + 5] = v6
	self._data[rowIndex + 6] = v7
	self._data[rowIndex + 7] = v8
	self._data[rowIndex + 8] = v9
	self._data[rowIndex + 9] = v10
	self._data[rowIndex + 10] = v11

	-- the first field is always an index (and the only index)
	self._bulkInsertContext.indexValues[self._storedFieldList[1]][uuid] = v1
end

--- Ends a bulk insert into the database.
-- @tparam Database self The database object
function Database.BulkInsertEnd(self)
	assert(self._bulkInsertContext)
	if self._bulkInsertContext.hasNewData then
		for field, indexList in pairs(self._indexLists) do
			private.indexListSortValues = self._bulkInsertContext.indexValues[field]
			for i, uuid in ipairs(self._uuids) do
				indexList[i] = uuid
				assert(private.indexListSortValues[uuid] ~= nil)
			end
			sort(indexList, private.IndexListSortHelper)
			private.indexListSortValues = nil
		end
		self:_UpdateQueries()
	end
	for _, tbl in pairs(self._bulkInsertContext.indexValues) do
		TSMAPI_FOUR.Util.ReleaseTempTable(tbl)
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(self._bulkInsertContext.indexValues)
	TSMAPI_FOUR.Util.ReleaseTempTable(self._bulkInsertContext)
	self._bulkInsertContext = nil
	self:SetQueryUpdatesPaused(false)
end

--- Returns a raw iterator over all rows in the database.
-- @tparam Database self The database object
-- @return The iterator with fields (index, <DB_FIELDS...>)
function Database.RawIterator(self)
	return private.RawIterator, self, 1 - self._numStoredFields
end

--- Gets the number of rows in the database.
-- @tparam Database self The database object
-- @treturn number The number of rows
function Database.GetNumRows(self)
	return #self._data / self._numStoredFields
end

--- Gets the number of rows in the database with a specific index value.
-- @tparam Database self The database object
-- @tparam string indexField The index field
-- @param indexValue The index value
-- @treturn number The number of rows
function Database.GetNumRowsByIndex(self, indexField, indexValue)
	local firstIndex, lastIndex = self:_GetIndexListIndexRange(indexField, indexValue)
	return firstIndex and (lastIndex - firstIndex + 1) or 0
end

function Database.GetRawData(self)
	return self._data
end

function Database.GetNumStoredFields(self)
	return self._numStoredFields
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function Database._UUIDIterator(self)
	return pairs(self._uuidToDataOffsetLookup)
end

function Database._GetFieldType(self, field)
	return self._fieldTypeLookup[field]
end

function Database._IsIndex(self, field)
	return self._indexLists[field] and true or false
end

function Database._IsUnique(self, field)
	return self._uniques[field] and true or false
end

function Database._GetIndexAndUniqueList(self)
	return self._indexOrUniqueFields
end

function Database._GetAllRowsByIndex(self, indexField)
	return self._indexLists[indexField]
end

function Database._IsSmartMapField(self, field)
	return self._smartMapReaderLookup[field] and true or false
end

function Database._GetIndexListIndexRange(self, indexField, indexValue)
	local indexList = self._indexLists[indexField]
	local lowerBound = nil
	local low, high = 1, #indexList
	local firstMatchLow, firstMatchHigh = nil, nil
	while low <= high do
		local mid = floor((low + high) / 2)
		local rowValue = self:_GetRowIndexValue(indexList[mid], indexField)
		if rowValue == indexValue then
			-- found a match, but keep inspecting lower indexes to find the lower bound
			-- cache the first low and high values which contain a match to make the search for the upper bound faster
			firstMatchLow = firstMatchLow or low
			firstMatchHigh = firstMatchHigh or high
			lowerBound = mid
			high = mid - 1
		elseif rowValue < indexValue then
			-- we're too low
			low = mid + 1
		else
			-- we're too high
			high = mid - 1
		end
	end
	if not lowerBound then
		return
	end

	local upperBound = nil
	low = firstMatchLow
	high = firstMatchHigh
	while low <= high do
		local mid = floor((low + high) / 2)
		local rowValue = self:_GetRowIndexValue(indexList[mid], indexField)
		if rowValue == indexValue then
			-- found a match, but keep inspecting higher indexes to find the upper bound
			upperBound = mid
			low = mid + 1
		elseif rowValue < indexValue then
			-- we're too low
			low = mid + 1
		else
			-- we're too high
			high = mid - 1
		end
	end
	if not upperBound then
		error("Failed to find upper bound")
	end

	return lowerBound, upperBound
end

function Database._GetUniqueRow(self, field, value)
	return self._uniques[field][value]
end

function Database._RegisterQuery(self, query)
	tinsert(self._queries, query)
end

function Database._RemoveQuery(self, query)
	assert(TSMAPI_FOUR.Util.TableRemoveByValue(self._queries, query) == 1)
end

function Database._UpdateQueries(self)
	if self._queryUpdatesPaused > 0 then
		self._queuedQueryUpdate = true
	else
		self._queuedQueryUpdate = false
		-- We need to mark all the queries stale first as an update callback may cause another of the queries to run which may not have yet been marked stale
		for _, query in ipairs(self._queries) do
			assert(not query._isIterating)
			query:_MarkResultStale()
		end
		for _, query in ipairs(self._queries) do
			assert(not query._isIterating)
			query:_DoUpdateCallback()
		end
	end
end

function Database._GetIndexListInsertIndex(self, indexList, indexValue, field)
	-- binary search for index
	local index = 1
	local low, mid, high = 1, 0, #indexList
	while low <= high do
		mid = floor((low + high) / 2)
		local rowValue = self:_GetRowIndexValue(indexList[mid], field)
		if rowValue == indexValue then
			-- found a match
			index = mid
			break
		elseif rowValue < indexValue then
			-- we're too low
			low = mid + 1
		else
			-- we're too high
			high = mid - 1
		end
		index = low
	end
	return index
end

function Database._IndexListInsert(self, field, uuid)
	local indexList = self._indexLists[field]
	local indexValue = self:_GetRowIndexValue(uuid, field)
	local index = self:_GetIndexListInsertIndex(indexList, indexValue, field)
	tinsert(indexList, index, uuid)
end

function Database._InsertRow(self, row)
	local uuid = row:GetUUID()
	local rowIndex = #self._data + 1
	self._uuidToDataOffsetLookup[uuid] = rowIndex
	tinsert(self._uuids, uuid)
	for i = 1, self._numStoredFields do
		local field = self._storedFieldList[i]
		local value = row:GetField(field)
		tinsert(self._data, value)
		local uniqueValues = self._uniques[field]
		if uniqueValues then
			if uniqueValues[value] ~= nil then
				error("A row with this unique value already exists", 2)
			end
			uniqueValues[value] = uuid
		end
	end
	for indexField in pairs(self._indexLists) do
		self:_IndexListInsert(indexField, uuid)
	end
	self:_UpdateQueries()
	if row == self._newRowTemp then
		row:_Release()
		assert(self._newRowTempInUse)
		self._newRowTempInUse = false
	else
		-- auto release this row after creation
		row:Release()
	end
end

function Database._UpdateRow(self, row, oldValues)
	local uuid = row:GetUUID()
	local index = self._uuidToDataOffsetLookup[uuid]
	for i = 1, self._numStoredFields do
		self._data[index + i - 1] = row:GetField(self._storedFieldList[i])
	end
	for indexField, indexList in pairs(self._indexLists) do
		local didChange = false
		for field in gmatch(indexField, "[^"..TSM.CONST.DB_INDEX_FIELD_SEP.."]+") do
			if oldValues[field] then
				didChange = true
				break
			elseif self:_IsSmartMapField(field) and oldValues[self._smartMapInputLookup[field]] then
				didChange = true
				break
			end
		end
		if didChange then
			-- remove and re-add row to the index list since the index value changed
			TSMAPI_FOUR.Util.TableRemoveByValue(indexList, uuid)
			self:_IndexListInsert(indexField, uuid)
		end
	end
	for field, uniqueValues in pairs(self._uniques) do
		local oldValue = oldValues[field]
		if oldValue ~= nil then
			assert(uniqueValues[oldValue] == uuid)
			uniqueValues[oldValue] = nil
			uniqueValues[self:_GetRowData(uuid, field)] = uuid
		end
	end
	self:_UpdateQueries()
end

function Database._GetRowIndexValue(self, uuid, field)
	-- currently just support indexes consisting of 1 or 2 fields
	local f1, f2, extraField = strsplit(TSM.CONST.DB_INDEX_FIELD_SEP, field)
	if extraField or not f1 then
		error("Unsupported number of fields in multi-field index")
	elseif f2 then
		return self:_GetRowData(uuid, f1)..TSM.CONST.DB_INDEX_VALUE_SEP..self:_GetRowData(uuid, f2)
	elseif f1 then
		return self:_GetRowData(uuid, field)
	end
end

function Database._GetRowData(self, uuid, field)
	local smartMapReader = self._smartMapReaderLookup[field]
	if smartMapReader then
		return smartMapReader[self:_GetRowData(uuid, self._smartMapInputLookup[field])]
	end
	local dataOffset = self._uuidToDataOffsetLookup[uuid]
	local fieldOffset = self._fieldOffsetLookup[field]
	if not dataOffset then
		error("Invalid UUID: "..tostring(uuid))
	elseif not fieldOffset then
		error("Invalid field: "..tostring(field))
	end
	local result = self._data[dataOffset + fieldOffset - 1]
	if result == nil then
		error("Failed to get row data")
	end
	return result
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.IndexSortHelper(a, b)
	return select(2, gsub(a, TSM.CONST.DB_INDEX_FIELD_SEP, "")) > select(2, gsub(b, TSM.CONST.DB_INDEX_FIELD_SEP, ""))
end

function private.IndexListSortHelper(a, b)
	local aValue = private.indexListSortValues[a]
	local bValue = private.indexListSortValues[b]
	if aValue == bValue then
		return a < b
	end
	return aValue < bValue
end

function private.RawIterator(self, index)
	index = index + self._numStoredFields
	if index > #self._data then
		return
	end
	return index, unpack(self._data, index, index + self._numStoredFields - 1)
end

function private.SmartMapReaderCallback(reader, changes)
	local self = private.smartMapReaderDatabaseLookup[reader]
	local fieldName = private.smartMapReaderFieldLookup[reader]
	if reader ~= self._smartMapReaderLookup[fieldName] then
		error("Invalid smart map context")
	end

	local indexList = self._indexLists[fieldName]
	if indexList then
		-- re-build the index
		wipe(indexList)
		private.indexListSortValues = TSMAPI_FOUR.Util.AcquireTempTable()
		for i, uuid in ipairs(self._uuids) do
			indexList[i] = uuid
			private.indexListSortValues[uuid] = self:_GetRowIndexValue(uuid, fieldName)
		end
		sort(indexList, private.IndexListSortHelper)
		TSMAPI_FOUR.Util.ReleaseTempTable(private.indexListSortValues)
		private.indexListSortValues = nil
	end

	local uniqueValues = self._uniques[fieldName]
	if uniqueValues then
		for key, prevValue in pairs(changes) do
			local uuid = uniqueValues[prevValue]
			assert(uuid)
			uniqueValues[prevValue] = nil
			uniqueValues[reader[key]] = uuid
		end
	end

	self:_UpdateQueries()
end
