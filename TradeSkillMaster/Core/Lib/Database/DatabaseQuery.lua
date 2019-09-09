-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Database Query Class.
-- This class represents a database query which is used for reading data out of a @{Database} in a structured and
-- efficient manner.
-- @classmod DatabaseQuery

local _, TSM = ...
local DatabaseQuery = TSMAPI_FOUR.Class.DefineClass("DatabaseQuery")
TSM.Database.classes.DatabaseQuery = DatabaseQuery
local private = {}
local NAN = math.huge * 0
local NAN_STR = tostring(NAN)



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function DatabaseQuery.__init(self)
	self._db = nil
	self._rootClause = nil
	self._currentClause = nil
	self._orderBy = {}
	self._orderByAscending = {}
	self._distinct = nil
	self._updateCallback = nil
	self._updatesPaused = 0
	self._queuedUpdate = false
	self._select = {}
	self._isIterating = false
	self._result = {}
	self._resultRowLookup = {}
	self._iterDistinctUsed = {}
	self._tempResultRow = nil
	self._tempVirtualResultRow = nil
	self._autoRelease = nil
	self._resultIsStale = false
	self._joinTypes = {}
	self._joinDBs = {}
	self._joinFields = {}
	self._virtualFieldFunc = {}
	self._virtualFieldArgField = {}
	self._virtualFieldType = {}
	self._genericSortWrapper = function(a, b)
		return private.DatabaseQuerySortGeneric(self, a, b)
	end
	self._singleSortWrapper = function(a, b)
		return private.DatabaseQuerySortSingle(self, a, b)
	end
	self._sortValueCache = {}
end

function DatabaseQuery._Acquire(self, db)
	self._db = db
	self._db:_RegisterQuery(self)
	-- implicit root AND clause
	self._rootClause = private.NewDatabaseQueryClause(self)
		:And()
	self._currentClause = self._rootClause
	self._tempResultRow = TSM.Database.GetDatabaseQueryResultRow()
	self._tempResultRow:_Acquire(self._db, self)
end

function DatabaseQuery._Release(self)
	assert(not self._isIterating)
	-- remove from the database
	self._db:_RemoveQuery(self)
	self._db = nil
	self._rootClause:_Release()
	self._rootClause = nil
	self._currentClause = nil
	self._updateCallback = nil
	self._updatesPaused = 0
	self._queuedUpdate = false
	wipe(self._iterDistinctUsed)
	self._tempResultRow:Release()
	self._tempResultRow = nil
	if self._tempVirtualResultRow then
		self._tempVirtualResultRow:Release()
		self._tempVirtualResultRow = nil
	end
	self._autoRelease = nil
	self:_WipeResults()
	self:ResetOrderBy()
	self:ResetDistinct()
	self:ResetSelect()
	self:ResetJoins()
	self:ResetVirtualFields()
	self._resultIsStale = false
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

--- Releases the database query.
-- The database query object will be recycled and must not be accessed after calling this method.
-- @tparam DatabaseQuery self The database query object
function DatabaseQuery.Release(self)
	self:_Release()
	TSM.Database.RecycleDatabaseQuery(self)
end

--- Whether or not the database has the field.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The name of the field
-- @treturn boolean Whether or not the query has the specified field
function DatabaseQuery.HasField(self, field)
	return self:_GetFieldType(field) and true or false
end

--- Adds a virtual field to the query.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The name of the new virtual field
-- @tparam string fieldType The type of the virtual field
-- @tparam function func A function which takes a row and returns the value of the virtual field
-- @?tparam[opt=nil] string argField The field to pass into the function (otherwise passes the entire row)
-- @tparam vararg ... Up to 4 fields to pass the values of to the function
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.VirtualField(self, field, fieldType, func, argField)
	if self:HasField(field) or self._virtualFieldFunc[field] then
		error("Field already exists: "..tostring(field))
	elseif type(func) ~= "function" then
		error("Invalid func: "..tostring(func))
	elseif fieldType ~= "number" and fieldType ~= "string" and fieldType ~= "boolean" then
		error("Field type must be string, number, or boolean")
	elseif argField and not self:HasField(argField) then
		error("Arg field doesn't exist: "..tostring(argField))
	end
	self._virtualFieldFunc[field] = func
	self._virtualFieldArgField[field] = argField
	self._virtualFieldType[field] = fieldType
	return self
end

--- Where a field equals a value.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The name of the field
-- @param value The value to compare to
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.Equal(self, field, value, otherField)
	if value == TSM.CONST.OTHER_FIELD_QUERY_PARAM then
		local fieldType = self:_GetFieldType(field)
		assert(fieldType and fieldType == self:_GetFieldType(otherField))
	elseif value ~= TSM.CONST.BOUND_QUERY_PARAM then
		assert(self:_GetFieldType(field) == type(value))
	end
	self:_NewClause()
		:Equal(field, value, otherField)
	return self
end

--- Where a field does not equals a value.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The name of the field
-- @param value The value to compare to
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.NotEqual(self, field, value, otherField)
	if value == TSM.CONST.OTHER_FIELD_QUERY_PARAM then
		local fieldType = self:_GetFieldType(field)
		assert(fieldType and fieldType == self:_GetFieldType(otherField))
	elseif value ~= TSM.CONST.BOUND_QUERY_PARAM then
		assert(self:_GetFieldType(field) == type(value))
	end
	self:_NewClause()
		:NotEqual(field, value, otherField)
	return self
end

--- Where a field is less than a value.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The name of the field
-- @param value The value to compare to
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.LessThan(self, field, value, otherField)
	if value == TSM.CONST.OTHER_FIELD_QUERY_PARAM then
		local fieldType = self:_GetFieldType(field)
		assert(fieldType and fieldType == self:_GetFieldType(otherField))
	elseif value ~= TSM.CONST.BOUND_QUERY_PARAM then
		assert(self:_GetFieldType(field) == type(value))
	end
	self:_NewClause()
		:LessThan(field, value, otherField)
	return self
end

--- Where a field is less than or equal to a value.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The name of the field
-- @param value The value to compare to
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.LessThanOrEqual(self, field, value, otherField)
	if value == TSM.CONST.OTHER_FIELD_QUERY_PARAM then
		local fieldType = self:_GetFieldType(field)
		assert(fieldType and fieldType == self:_GetFieldType(otherField))
	elseif value ~= TSM.CONST.BOUND_QUERY_PARAM then
		assert(self:_GetFieldType(field) == type(value))
	end
	self:_NewClause()
		:LessThanOrEqual(field, value, otherField)
	return self
end

--- Where a field is greater than a value.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The name of the field
-- @param value The value to compare to
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.GreaterThan(self, field, value, otherField)
	if value == TSM.CONST.OTHER_FIELD_QUERY_PARAM then
		local fieldType = self:_GetFieldType(field)
		assert(fieldType and fieldType == self:_GetFieldType(otherField))
	elseif value ~= TSM.CONST.BOUND_QUERY_PARAM then
		assert(self:_GetFieldType(field) == type(value))
	end
	self:_NewClause()
		:GreaterThan(field, value, otherField)
	return self
end

--- Where a field is greater than or equal to a value.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The name of the field
-- @param value The value to compare to
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.GreaterThanOrEqual(self, field, value, otherField)
	if value == TSM.CONST.OTHER_FIELD_QUERY_PARAM then
		local fieldType = self:_GetFieldType(field)
		assert(fieldType and fieldType == self:_GetFieldType(otherField))
	elseif value ~= TSM.CONST.BOUND_QUERY_PARAM then
		assert(self:_GetFieldType(field) == type(value))
	end
	self:_NewClause()
		:GreaterThanOrEqual(field, value, otherField)
	return self
end

--- Where a string field matches a pattern.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The name of the field
-- @tparam string value The pattern to match
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.Matches(self, field, value)
	assert(value ~= TSM.CONST.BOUND_QUERY_PARAM, "This method does not support bound values")
	assert(self:_GetFieldType(field) == "string" and type(value) == "string")
	self:_NewClause()
		:Matches(field, strlower(value))
	return self
end

--- Where a foreign field (obtained via a left join) is nil.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The name of the field
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.IsNil(self, field)
	assert(self:_GetJoinType(field) == "LEFT", "Must be a left join")
	self:_NewClause()
		:IsNil(field)
	return self
end

--- Where a foreign field (obtained via a left join) is not nil.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The name of the field
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.IsNotNil(self, field)
	assert(self:_GetJoinType(field) == "LEFT", "Must be a left join")
	self:_NewClause()
		:IsNotNil(field)
	return self
end

--- A custom query clause.
-- @tparam DatabaseQuery self The database query object
-- @tparam function func The function which gets passed the row being evaulated and returns true/false if the query
-- should include it
-- @param[opt] arg An argument to pass to the function
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.Custom(self, func, arg)
	assert(type(func) == "function")
	self:_NewClause()
		:Custom(func, arg)
	return self
end

--- Where the hash of a row equals a value.
-- @tparam DatabaseQuery self The database query object
-- @tparam function fields An ordered list of fields to hash
-- @tparam number value The hash value to compare to
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.HashEqual(self, fields, value)
	assert(value ~= TSM.CONST.BOUND_QUERY_PARAM, "This method does not support bound values")
	assert(type(fields) == "table")
	for _, field in ipairs(fields) do
		local fieldType = self:_GetFieldType(field)
		if not fieldType then
			error(format("Field %s doesn't exist", tostring(field)))
		elseif fieldType ~= "number" and fieldType ~= "string" then
			error(format("Cannot hash field of type %s", fieldType))
		end
	end
	self:_NewClause()
		:HashEqual(fields, value)
	return self
end

--- Starts a nested AND clause.
-- All of the clauses following this (until the matching @{DatabaseQuery.End}) must be true for the OR clause to be true.
-- @tparam DatabaseQuery self The database query object
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.And(self)
	self._currentClause = self:_NewClause()
		:And()
	return self
end

--- Starts a nested OR clause.
-- At least one of the clauses following this (until the matching @{DatabaseQuery.End}) must be true for the OR clause
-- to be true.
-- @tparam DatabaseQuery self The database query object
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.Or(self)
	self._currentClause = self:_NewClause()
		:Or()
	return self
end

--- Ends a nested AND/OR clause.
-- @tparam DatabaseQuery self The database query object
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.End(self)
	assert(self._currentClause ~= self._rootClause, "No current clause to end")
	self._currentClause = self._currentClause:_GetParent()
	assert(self._currentClause)
	return self
end

function DatabaseQuery.LeftJoin(self, db, field)
	self:_JoinHelper(db, field, "LEFT")
	return self
end

function DatabaseQuery.InnerJoin(self, db, field)
	self:_JoinHelper(db, field, "INNER")
	return self
end

--- Order the results by a field.
-- This may be called multiple times to provide additional ordering constraints. The priority of the ordering will be
-- descending as this method is called additional times (meaning the first OrderBy will have highest priority).
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The name of the field to order by
-- @tparam boolean ascending Whether to order in ascending order (descending otherwise)
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.OrderBy(self, field, ascending)
	assert(ascending == true or ascending == false)
	local fieldType = self:_GetFieldType(field)
	if not fieldType then
		error(format("Field %s doesn't exist", tostring(field)))
	elseif fieldType ~= "number" and fieldType ~= "string" and fieldType ~= "boolean" then
		error(format("Cannot order by field of type %s", tostring(fieldType)))
	end
	tinsert(self._orderBy, field)
	tinsert(self._orderByAscending, ascending)
	return self
end

--- Only return distinct results based on a field.
-- This method can be used to ensure that only the first row for each distinct value of the field is returned.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The field to ensure is distinct in the results
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.Distinct(self, field)
	assert(self:_GetFieldType(field), format("Field %s doesn't exist within local DB", tostring(field)))
	self._distinct = field
	return self
end

--- Select specific fields in the result.
-- @tparam DatabaseQuery self The database query object
-- @tparam vararg ... The fields to select
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.Select(self, ...)
	assert(#self._select == 0)
	local numFields = select("#", ...)
	assert(numFields > 0, "Must select at least 1 field")
	-- DatabaseRow.GetFields() only supports 8 fields, so we can only support 8 here as well
	assert(numFields <= 8, "Select() only supports up to 8 fields")
	for i = 1, numFields do
		local field = select(i, ...)
		tinsert(self._select, field)
	end
	return self
end

--- Binds parameters to a prepared query.
-- The number of arguments should match the number of TSM.CONST.BOUND_QUERY_PARAM values in the query's clauses.
-- @tparam DatabaseQuery self The database query object
-- @tparam vararg ... The fields to select
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.BindParams(self, ...)
	local numFields = select("#", ...)
	assert(self._rootClause:_BindParams(...) == numFields, "Invalid number of bound parameters")
	return self
end

--- Set an update callback.
-- This callback gets called whenever any rows in the underlying database change.
-- @tparam DatabaseQuery self The database query object
-- @tparam function func The callback function
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.SetUpdateCallback(self, func)
	self._updateCallback = func
	return self
end

--- Pauses or unpauses callbacks for query updates.
-- @tparam DatabaseQuery self The database query object
-- @tparam boolean paused Whether or not updates should be paused
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.SetUpdatesPaused(self, paused)
	self._updatesPaused = self._updatesPaused + (paused and 1 or -1)
	assert(self._updatesPaused >= 0)
	if self._updatesPaused == 0 and self._queuedUpdate then
		self:_DoUpdateCallback()
	end
	return self
end

--- Results iterator.
-- Note that the iterator must run to completion (don't use `break` or `return` to escape it early).
-- @tparam DatabaseQuery self The database query object
-- @return An iterator for the results of the query
function DatabaseQuery.Iterator(self)
	self:_Execute()
	assert(self._rootClause and self._currentClause == self._rootClause, "Did not end sub-clause")
	assert(not self._isIterating)
	self._isIterating = true
	self._autoRelease = false
	return private.QueryResultIterator, self, 0
end

--- Iterates through the results as uuids.
-- @tparam DatabaseQuery self The database query object
-- @return An iterator for the results of the query as UUIDs
function DatabaseQuery.UUIDIterator(self)
	self:_Execute()
	assert(self._rootClause and self._currentClause == self._rootClause, "Did not end sub-clause")
	assert(not self._isIterating)
	self._isIterating = true
	self._autoRelease = false
	return private.QueryResultAsUUIDIterator, self, 0
end

--- Results iterator which releases upon completion.
-- Note that the iterator must run to completion (don't use `break` or `return` to escape it early).
-- @tparam DatabaseQuery self The database query object
-- @return An iterator for the results of the query
function DatabaseQuery.IteratorAndRelease(self)
	self:_Execute()
	assert(self._rootClause and self._currentClause == self._rootClause, "Did not end sub-clause")
	assert(not self._isIterating)
	self._isIterating = true
	self._autoRelease = true
	return private.QueryResultIterator, self, 0
end

--- Populates a table with the results.
-- The query must have a select clause with at least one or two fields. In the former case, the table will be populated
-- as a list, and in the latter case, the first field must be unique in the results, and will be used as the key for the
-- table with the second field being the value.
-- @tparam DatabaseQuery self The database query object
-- @tparam table tbl The table to store the result in
function DatabaseQuery.AsTable(self, tbl)
	self:_Execute()
	if #self._select == 1 then
		for _, uuid in ipairs(self._result) do
			tinsert(tbl, self:_GetResultRowData(uuid, self._select[1]))
		end
	elseif #self._select == 2 then
		for _, uuid in ipairs(self._result) do
			local key = self:_GetResultRowData(uuid, self._select[1])
			assert(key ~= nil and not tbl[key])
			tbl[key] = self:_GetResultRowData(uuid, self._select[2])
		end
	else
		error("Invalid select clause")
	end
end

--- Get the number of resulting rows.
-- @tparam DatabaseQuery self The database query object
-- @treturn number The number of rows
function DatabaseQuery.Count(self)
	self:_Execute()
	return #self._result
end

--- Get the number of resulting rows and release.
-- @tparam DatabaseQuery self The database query object
-- @treturn number The number of rows
function DatabaseQuery.CountAndRelease(self)
	self:_Execute()
	local count = #self._result
	self:Release()
	return count
end

--- Get a single result.
-- This method will assert that there is exactly one result from the query and return it.
-- @tparam DatabaseQuery self The database query object
-- @return The result row or the selected fields
function DatabaseQuery.GetSingleResult(self)
	self:_Execute()
	assert(self:Count() == 1)
	return self:GetFirstResult()
end

--- Get a single result and release.
-- This method will assert that there is exactly one result from the query and return it.
-- @tparam DatabaseQuery self The database query object
-- @return The result row or the selected fields
function DatabaseQuery.GetSingleResultAndRelease(self)
	assert(#self._select > 0)
	local result = self:GetSingleResult()
	self:Release()
	return result
end

--- Get the first result.
-- Note that this method internally iterates over all the results.
-- @tparam DatabaseQuery self The database query object
-- @return The result row or the selected fields
function DatabaseQuery.GetFirstResult(self)
	self:_Execute()
	assert(not self._isIterating)
	if self:Count() == 0 then
		return
	end
	local uuid = self._result[1]
	if not self._resultRowLookup[uuid] then
		self:_CreateResultRow(uuid)
	end
	local row = self._resultRowLookup[uuid]
	if #self._select > 0 then
		return row:GetFields(unpack(self._select))
	else
		return row
	end
end

--- Get the first result and release.
-- Note that this method internally iterates over all the results.
-- @tparam DatabaseQuery self The database query object
-- @return The result row or the selected fields
function DatabaseQuery.GetFirstResultAndRelease(self)
	self:_Execute()
	assert(not self._isIterating)
	if self:Count() == 0 then
		self:Release()
		return
	end
	local uuid = self._result[1]
	if not self._resultRowLookup[uuid] then
		self:_CreateResultRow(uuid)
	end
	local row = self._resultRowLookup[uuid]
	if #self._select > 0 then
		return self:_PassThroughReleaseHelper(row:GetFields(unpack(self._select)))
	else
		row = row:Clone()
		self:Release()
		return row
	end
end

--- Gets the minimum value of a specific field within the query results.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The field within the results
-- @?treturn number The minimum value or nil if there are no results
function DatabaseQuery.Min(self, field)
	self:_Execute()
	local result = nil
	for _, uuid in ipairs(self._result) do
		local value = self:_GetResultRowData(uuid, field)
		result = min(result or math.huge, value)
	end
	return result
end

--- Gets the maximum value of a specific field within the query results.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The field within the results
-- @?treturn number The maximum value or nil if there are no results
function DatabaseQuery.Max(self, field)
	self:_Execute()
	local result = nil
	for _, uuid in ipairs(self._result) do
		local value = self:_GetResultRowData(uuid, field)
		result = max(result or -math.huge, value)
	end
	return result
end

--- Gets the summed value of a specific field within the query results.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The field within the results
-- @?treturn number The summed value or nil if there are no results
function DatabaseQuery.Sum(self, field)
	self:_Execute()
	local result = nil
	for _, uuid in ipairs(self._result) do
		local value = self:_GetResultRowData(uuid, field)
		result = (result or 0) + value
	end
	return result
end

--- Gets the average value of a specific field within the query results.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The field within the results
-- @?treturn number The average value or nil if there are no results
function DatabaseQuery.Avg(self, field)
	local sum = self:Sum(field)
	local num = self:Count()
	return sum and (sum / num) or nil
end

--- Gets the sum of the products of two fields within the query results.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field1 The first field within the results
-- @tparam string field2 The second field within the results
-- @?treturn number The summed value or nil if there are no results
function DatabaseQuery.SumOfProduct(self, field1, field2)
	self:_Execute()
	local result = nil
	for _, uuid in ipairs(self._result) do
		local value1 = self:_GetResultRowData(uuid, field1)
		local value2 = self:_GetResultRowData(uuid, field2)
		result = (result or 0) + value1 * value2
	end
	return result
end

--- Joins the string values of a field with a given separator.
-- @tparam DatabaseQuery self The database query object
-- @tparam string field The field within the results
-- @tparam string sep The separator (can be any number of characters, including an empty string)
-- @treturn string The joined string
function DatabaseQuery.JoinedString(self, field, sep)
	self:_Execute()
	local parts = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, uuid in ipairs(self._result) do
		tinsert(parts, self:_GetResultRowData(uuid, field))
	end
	local result = table.concat(parts, sep)
	TSMAPI_FOUR.Util.ReleaseTempTable(parts)
	return result
end

--- Calculates the hash of the query results.
-- Note that the query must have a select colum with at most 2 fields.
-- @tparam DatabaseQuery self The database query object
-- @?treturn number The hash value or nil if there are no results
function DatabaseQuery.Hash(self)
	self:_Execute()
	local keyField, valueField, extra = unpack(self._select)
	assert(keyField and not extra)
	local hashContext = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, uuid in ipairs(self._result) do
		tinsert(hashContext, self:_GetResultRowData(uuid, keyField))
		if valueField then
			tinsert(hashContext, self:_GetResultRowData(uuid, valueField))
		end
	end
	sort(hashContext)
	local result = nil
	for _, value in ipairs(hashContext) do
		result = TSMAPI_FOUR.Util.CalculateHash(value, result)
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(hashContext)
	return result
end

--- Calculates the hash of the query results and release.
-- Note that the query must have a select colum with at most 2 fields.
-- @tparam DatabaseQuery self The database query object
-- @?treturn number The hash value or nil if there are no results
function DatabaseQuery.HashAndRelease(self)
	self:_Execute()
	local keyField, valueField, extra = unpack(self._select)
	assert(keyField and not extra)
	local hashContext = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, uuid in ipairs(self._result) do
		tinsert(hashContext, self:_GetResultRowData(uuid, keyField))
		if valueField then
			tinsert(hashContext, self:_GetResultRowData(uuid, valueField))
		end
	end
	sort(hashContext)
	local result = nil
	for _, value in ipairs(hashContext) do
		result = TSMAPI_FOUR.Util.CalculateHash(value, result)
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(hashContext)
	self:Release()
	return result
end

--- Resets the database query.
-- @tparam DatabaseQuery self The database query object
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.Reset(self)
	self:ResetDistinct()
	self:ResetSelect()
	self:ResetOrderBy()
	self:ResetJoins()
	self:ResetFilters()
	self:ResetVirtualFields()
	self:_WipeResults()
	self._resultIsStale = true
	return self
end

--- Resets any virtual fields added to the database query.
-- @tparam DatabaseQuery self The database query object
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.ResetVirtualFields(self)
	wipe(self._virtualFieldFunc)
	wipe(self._virtualFieldArgField)
	wipe(self._virtualFieldType)
	self._resultIsStale = true
	return self
end

--- Resets any filtering clauses of the database query.
-- @tparam DatabaseQuery self The database query object
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.ResetFilters(self)
	self._rootClause:_Release()
	self._rootClause = private.NewDatabaseQueryClause(self)
		:And()
	self._currentClause = self._rootClause
	self._resultIsStale = true
	return self
end

--- Resets any ordering clauses of the database query.
-- @tparam DatabaseQuery self The database query object
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.ResetOrderBy(self)
	wipe(self._orderBy)
	wipe(self._orderByAscending)
	self._resultIsStale = true
	return self
end

--- Resets any joins of the database query.
-- @tparam DatabaseQuery self The database query object
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.ResetJoins(self)
	for _, db in ipairs(self._joinDBs) do
		db:_RemoveQuery(self)
	end
	wipe(self._joinTypes)
	wipe(self._joinDBs)
	wipe(self._joinFields)
	self._resultIsStale = true
	return self
end

--- Resets any distinct clauses of the database query.
-- @tparam DatabaseQuery self The database query object
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.ResetDistinct(self)
	self._distinct = nil
	self._resultIsStale = true
	return self
end

--- Resets any select clauses of the database query.
-- @tparam DatabaseQuery self The database query object
-- @treturn DatabaseQuery The database query object
function DatabaseQuery.ResetSelect(self)
	wipe(self._select)
	return self
end

--- Gets info on the first order by clause.
-- @tparam DatabaseQuery self The database query object
-- @?treturn string The field name
-- @?treturn boolean Whether or not the sort is ascending
function DatabaseQuery.GetFirstOrderBy(self)
	return self._orderBy[1], self._orderByAscending[1]
end

--- Get a result row by its UUID.
-- @tparam DatabaseQuery self The database query object
-- @tparam number uuid The UUID of the row to get
-- @return DatabaseQueryResultRow The result row name
function DatabaseQuery.GetResultRowByUUID(self, uuid)
	if not self._resultRowLookup[uuid] then
		self:_CreateResultRow(uuid)
	end
	return self._resultRowLookup[uuid]
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function DatabaseQuery._GetJoinType(self, field)
	for i, db in ipairs(self._joinDBs) do
		if db:_GetFieldType(field) then
			return self._joinTypes[i]
		end
	end
end

function DatabaseQuery._GetFieldType(self, field)
	local fieldType = self._virtualFieldType[field] or self._db:_GetFieldType(field)
	if fieldType then
		return fieldType
	end
	for _, db in ipairs(self._joinDBs) do
		fieldType = db:_GetFieldType(field)
		if fieldType then
			return fieldType
		end
	end
end

function DatabaseQuery._MarkResultStale(self)
	self._resultIsStale = true
end

function DatabaseQuery._DoUpdateCallback(self)
	if not self._updateCallback then
		return
	end
	if self._updatesPaused > 0 then
		self._queuedUpdate = true
	else
		self._queuedUpdate = false
		self:_updateCallback()
	end
end

function DatabaseQuery._NewClause(self)
	local newClause = private.NewDatabaseQueryClause(self, self._currentClause)
	self._currentClause:_InsertSubClause(newClause)
	return newClause
end

function DatabaseQuery._WipeResults(self)
	for _, row in pairs(self._resultRowLookup) do
		if row ~= false then
			row:Release()
		end
	end
	wipe(self._result)
	wipe(self._resultRowLookup)
end

function DatabaseQuery._Execute(self, force)
	if not self._resultIsStale and not force then
		return
	end
	assert(self._rootClause and self._currentClause == self._rootClause, "Did not end sub-clause")
	assert(not self._isIterating)
	assert(not next(self._iterDistinctUsed))

	-- clear the current result
	self:_WipeResults()

	-- try to find the best index to use to optimize this query
	local indexField, indexValue = nil, nil
	for _, field in ipairs(self._db:_GetIndexAndUniqueList()) do
		local value = self:_IndexValueHelper(strsplit(TSM.CONST.DB_INDEX_FIELD_SEP, field))
		if value ~= nil then
			indexField = field
			indexValue = value
			break
		end
	end

	-- get all the rows which we need to iterate over
	local firstOrderBy = self._orderBy[1]
	local sortNeeded = firstOrderBy and true or false
	if indexField and self._db:_IsUnique(indexField) then
		-- we are looking for a unique row
		self._result._queryOptimizationResult = "unique"
		self._result._queryOptimizationField = indexField
		local uuid = self._db:_GetUniqueRow(indexField, indexValue)
		if uuid then
			self:_AddResultRow(uuid)
		end
		sortNeeded = false
	elseif indexField then
		-- we're querying on an index, so use that index to populate the result
		local isAscending = true
		if firstOrderBy and indexField == firstOrderBy then
			-- we're also ordering by this field so can skip the first OrderBy field
			self._result._queryOptimizationResult = "indexAndOrderBy"
			self._result._queryOptimizationField = indexField
			sortNeeded = #self._orderBy > 1
			isAscending = self._orderByAscending[1]
		else
			self._result._queryOptimizationResult = "index"
			self._result._queryOptimizationField = indexField
		end
		local firstIndex, lastIndex = self._db:_GetIndexListIndexRange(indexField, indexValue)
		if firstIndex then
			local indexList = self._db:_GetAllRowsByIndex(indexField)
			local noQuery = self._rootClause:_IsStrictIndex(indexField, indexValue)
			for i = isAscending and firstIndex or lastIndex, isAscending and lastIndex or firstIndex, isAscending and 1 or -1 do
				self:_AddResultRow(indexList[i], noQuery)
			end
		end -- else, empty result
	elseif firstOrderBy and self._db:_IsIndex(firstOrderBy) then
		-- we're ordering on an index, so use that index to iterate through all the rows in order to skip the first OrderBy field
		self._result._queryOptimizationResult = "orderBy"
		self._result._queryOptimizationField = firstOrderBy
		sortNeeded = #self._orderBy > 1
		local isAscending = self._orderByAscending[1]
		local indexList = self._db:_GetAllRowsByIndex(firstOrderBy)
		for i = isAscending and 1 or #indexList, isAscending and #indexList or 1, isAscending and 1 or -1 do
			self:_AddResultRow(indexList[i])
		end
	else
		-- no optimizations
		self._result._queryOptimizationResult = "none"
		self._result._queryOptimizationField = nil
		for uuid in self._db:_UUIDIterator() do
			self:_AddResultRow(uuid)
		end
	end
	wipe(self._iterDistinctUsed)

	-- sort the results if necessary
	if sortNeeded then
		if #self._orderBy == 1 then
			assert(not next(self._sortValueCache))
			for _, uuid in ipairs(self._result) do
				local value = self:_GetResultRowData(uuid, self._orderBy[1])
				local fieldType = self:_GetFieldType(self._orderBy[1])
				if value ~= nil then
					if fieldType == "string" then
						value = strlower(value)
					elseif fieldType == "boolean" then
						value = value and 1 or 0
					elseif fieldType == "number" and tostring(value) == NAN_STR then
						value = nil
					end
				end
				self._sortValueCache[uuid] = value
			end
			sort(self._result, self._singleSortWrapper)
			wipe(self._sortValueCache)
		else
			sort(self._result, self._genericSortWrapper)
		end
	end

	self._resultIsStale = false
end

function DatabaseQuery._AddResultRow(self, uuid, skipQuery)
	if not skipQuery then
		self._tempResultRow:_SetUUID(uuid)
	end
	for i = 1, #self._joinDBs do
		local joinType = self._joinTypes[i]
		local joinDB = self._joinDBs[i]
		local joinField = self._joinFields[i]
		if joinType == "INNER" and not joinDB:_GetUniqueRow(joinField, self._db:_GetRowData(uuid, joinField)) then
			return
		elseif not skipQuery then
			self._tempResultRow:_AddJoinInfo(joinDB, joinField)
		end
	end
	if not skipQuery and not self._rootClause:_IsTrue(self._tempResultRow) then
		return
	end
	if self._distinct then
		local distinctValue = self:_GetResultRowData(uuid, self._distinct)
		if self._iterDistinctUsed[distinctValue] then
			return
		end
		self._iterDistinctUsed[distinctValue] = true
	end
	tinsert(self._result, uuid)
	self._resultRowLookup[uuid] = false
end

function DatabaseQuery._CreateResultRow(self, uuid)
	assert(self._resultRowLookup[uuid] == false)
	local row = TSM.Database.GetDatabaseQueryResultRow()
	row:_Acquire(self._db, self)
	row:_SetUUID(uuid)
	for i = 1, #self._joinDBs do
		row:_AddJoinInfo(self._joinDBs[i], self._joinFields[i])
	end
	self._resultRowLookup[uuid] = row
	return row
end

function DatabaseQuery._IndexValueHelper(self, ...)
	local num = select("#", ...)
	local value = nil
	for i = 1, num do
		local fieldPart = select(i, ...)
		local partValue = self._rootClause:_GetIndexValue(fieldPart)
		if not partValue then
			return
		end
		if value then
			value = value .. TSM.CONST.DB_INDEX_VALUE_SEP .. partValue
		else
			value = partValue
		end
	end
	return value
end

function DatabaseQuery._PassThroughReleaseHelper(self, ...)
	self:Release()
	return ...
end

function DatabaseQuery._GetResultRowData(self, uuid, field)
	if self._virtualFieldFunc[field] then
		local argField = self._virtualFieldArgField[field]
		local argValue = nil
		if argField then
			argValue = self:_GetResultRowData(uuid, argField)
		else
			if not self._tempVirtualResultRow then
				self._tempVirtualResultRow = TSM.Database.GetDatabaseQueryResultRow()
				self._tempVirtualResultRow:_Acquire(self._db, self)
			end
			self._tempVirtualResultRow:_SetUUID(uuid)
			for i = 1, #self._joinDBs do
				self._tempVirtualResultRow:_AddJoinInfo(self._joinDBs[i], self._joinFields[i])
			end
			argValue = self._tempVirtualResultRow
		end
		local value = self._virtualFieldFunc[field](argValue)
		if type(value) ~= self._virtualFieldType[field] then
			error("Virtual field value not the correct type")
		end
		return value
	elseif #self._joinDBs == 0 or self._db:_GetFieldType(field) then
		-- this is a local field
		return self._db:_GetRowData(uuid, field)
	else
		-- this is a foreign field
		local joinDB = nil
		local joinField = nil
		for i = 1, #self._joinDBs do
			local testDB = self._joinDBs[i]
			if testDB:_GetFieldType(field) then
				if joinDB then
					error("Multiple joined DBs have this field", 2)
				end
				joinDB = testDB
				joinField = self._joinFields[i]
			end
		end
		if not joinDB then
			error("Invalid field: "..tostring(field), 2)
		end
		local foreignUUID = joinDB:_GetUniqueRow(joinField, self._db:_GetRowData(uuid, joinField))
		if foreignUUID then
			return joinDB:_GetRowData(foreignUUID, field)
		end
	end
end

function DatabaseQuery._JoinHelper(self, db, field, joinType)
	assert(db:__isa(TSM.Database.classes.Database) and type(field) == "string")
	local localFieldType = self._db:_GetFieldType(field)
	local foreignFieldType = db:_GetFieldType(field)
	assert(localFieldType, "Local field doesn't exist: "..tostring(field))
	assert(foreignFieldType, "Foreign field doesn't exist: "..tostring(field))
	assert(localFieldType == foreignFieldType, format("Field types don't match (%s, %s)", tostring(localFieldType), tostring(foreignFieldType)))
	assert(db:_IsUnique(field), "Field must be unique in foreign DB")
	assert(not TSMAPI_FOUR.Util.TableKeyByValue(self._joinDBs, db), "Already joining with this DB")
	for foreignField in db:FieldIterator() do
		if foreignField ~= field then
			assert(not self._db:_GetFieldType(foreignField), "Foreign field conflicts with local DB: "..tostring(foreignField))
		end
	end
	for virtualField in pairs(self._virtualFieldFunc) do
		assert(not db:_GetFieldType(virtualField), "Virtual field conflicts with foreign DB: "..tostring(virtualField))
	end
	db:_RegisterQuery(self)
	tinsert(self._joinTypes, joinType)
	tinsert(self._joinDBs, db)
	tinsert(self._joinFields, field)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.DatabaseQuerySortSingle(self, aUUID, bUUID)
	local aValue = self._sortValueCache[aUUID]
	local bValue = self._sortValueCache[bUUID]
	if aValue == bValue then
		-- make the sort stable
		return aUUID < bUUID
	elseif aValue == nil then
		-- sort nil to the end
		return false
	elseif bValue == nil then
		-- sort nil to the end
		return true
	elseif self._orderByAscending[1] then
		return aValue < bValue
	else
		return aValue > bValue
	end
end

function private.DatabaseQuerySortGeneric(self, aUUID, bUUID)
	for i = 1, #self._orderBy do
		local orderByField = self._orderBy[i]
		local aValue = self:_GetResultRowData(aUUID, orderByField)
		local bValue = self:_GetResultRowData(bUUID, orderByField)
		if (aValue == nil and bValue == nil) or (tostring(aValue) == NAN_STR and tostring(bValue) == NAN_STR) then
			-- continue looping
		elseif aValue == nil or tostring(aValue) == NAN_STR then
			-- sort nil/NAN to the end
			return false
		elseif bValue == nil or tostring(bValue) == NAN_STR then
			-- sort nil to the end
			return true
		else
			local fieldType = self:_GetFieldType(orderByField)
			if fieldType == "string" then
				aValue = strlower(aValue)
				bValue = strlower(bValue)
			elseif fieldType == "boolean" then
				aValue = aValue and 1 or 0
				bValue = bValue and 1 or 0
			end
			if aValue == bValue then
				-- continue looping
			elseif self._orderByAscending[i] then
				return aValue < bValue
			else
				return aValue > bValue
			end
		end
	end
	-- make the sort stable
	return aUUID < bUUID
end

function private.NewDatabaseQueryClause(query, parent)
	local clause = TSM.Database.GetDatabaseQueryClause()
	clause:_Acquire(query, parent)
	return clause
end

function private.QueryResultAsUUIDIterator(self, index)
	index = index + 1
	local uuid = self._result[index]
	if not uuid then
		assert(self._isIterating)
		self._isIterating = false
		if self._autoRelease then
			self:Release()
		end
		return
	end
	return index, uuid
end

function private.QueryResultIterator(self, index)
	index = index + 1
	local uuid = self._result[index]
	if not uuid then
		assert(self._isIterating)
		self._isIterating = false
		if self._autoRelease then
			self:Release()
		end
		return
	end
	local numSelectFields = #self._select
	if numSelectFields == 0 then
		local row = self._resultRowLookup[uuid]
		if not row then
			row = self:_CreateResultRow(uuid)
		end
		return index, row
	elseif #self._joinDBs == 0 and numSelectFields <= 2 then
		-- as an optimization, we don't need to create a result row
		if numSelectFields == 1 then
			return index, self:_GetResultRowData(uuid, self._select[1])
		elseif numSelectFields == 2 then
			return index, self:_GetResultRowData(uuid, self._select[1]), self:_GetResultRowData(uuid, self._select[2])
		else
			error("Invalid numSelectFields: "..tostring(numSelectFields))
		end
	else
		local row = self._resultRowLookup[uuid]
		if not row then
			row = self:_CreateResultRow(uuid)
		end
		return index, row:GetFields(unpack(self._select))
	end
end
