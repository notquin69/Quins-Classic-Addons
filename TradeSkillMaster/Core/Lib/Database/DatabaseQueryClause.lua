-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local DatabaseQueryClause = TSMAPI_FOUR.Class.DefineClass("DatabaseQueryClause")
TSM.Database.classes.DatabaseQueryClause = DatabaseQueryClause



-- ============================================================================
-- Class Method Methods
-- ============================================================================

function DatabaseQueryClause.__init(self)
	self._query = nil
	self._operation = nil
	self._parent = nil
	-- comparison
	self._field = nil
	self._value = nil
	self._boundValue = nil
	self._otherField = nil
	-- or / and
	self._subClauses = {}
end

function DatabaseQueryClause._Acquire(self, query, parent)
	self._query = query
	self._parent = parent
end

function DatabaseQueryClause._Release(self)
	self._query = nil
	self._operation = nil
	self._parent = nil
	self._field = nil
	self._value = nil
	self._boundValue = nil
	self._otherField = nil
	for _, clause in ipairs(self._subClauses) do
		clause:_Release()
	end
	wipe(self._subClauses)
	TSM.Database.RecycleDatabaseQueryClause(self)
end



-- ============================================================================
-- Public Class Method
-- ============================================================================

function DatabaseQueryClause.Equal(self, field, value, otherField)
	return self:_SetComparisonOperation("EQUAL", field, value, otherField)
end

function DatabaseQueryClause.NotEqual(self, field, value, otherField)
	return self:_SetComparisonOperation("NOT_EQUAL", field, value, otherField)
end

function DatabaseQueryClause.LessThan(self, field, value, otherField)
	return self:_SetComparisonOperation("LESS", field, value, otherField)
end

function DatabaseQueryClause.LessThanOrEqual(self, field, value, otherField)
	return self:_SetComparisonOperation("LESS_OR_EQUAL", field, value, otherField)
end

function DatabaseQueryClause.GreaterThan(self, field, value, otherField)
	return self:_SetComparisonOperation("GREATER", field, value, otherField)
end

function DatabaseQueryClause.GreaterThanOrEqual(self, field, value, otherField)
	return self:_SetComparisonOperation("GREATER_OR_EQUAL", field, value, otherField)
end

function DatabaseQueryClause.Matches(self, field, value)
	return self:_SetComparisonOperation("MATCHES", field, value)
end

function DatabaseQueryClause.IsNil(self, field)
	return self:_SetComparisonOperation("IS_NIL", field)
end

function DatabaseQueryClause.IsNotNil(self, field)
	return self:_SetComparisonOperation("IS_NOT_NIL", field)
end

function DatabaseQueryClause.Custom(self, func, arg)
	return self:_SetComparisonOperation("CUSTOM", func, arg)
end

function DatabaseQueryClause.HashEqual(self, fields, value)
	return self:_SetComparisonOperation("HASH_EQUAL", fields, value)
end

function DatabaseQueryClause.Or(self)
	return self:_SetSubClauseOperation("OR")
end

function DatabaseQueryClause.And(self)
	return self:_SetSubClauseOperation("AND")
end



-- ============================================================================
-- Private Class Method
-- ============================================================================

function DatabaseQueryClause._GetParent(self)
	return self._parent
end

function DatabaseQueryClause._IsTrue(self, row)
	local value = self._value
	if value == TSM.CONST.BOUND_QUERY_PARAM then
		value = self._boundValue
	elseif value == TSM.CONST.OTHER_FIELD_QUERY_PARAM then
		value = row:GetField(self._otherField)
	end
	local operation = self._operation
	if operation == "EQUAL" then
		return row[self._field] == value
	elseif operation == "NOT_EQUAL" then
		return row[self._field] ~= value
	elseif operation == "LESS" then
		return row[self._field] < value
	elseif operation == "LESS_OR_EQUAL" then
		return row[self._field] <= value
	elseif operation == "GREATER" then
		return row[self._field] > value
	elseif operation == "GREATER_OR_EQUAL" then
		return row[self._field] >= value
	elseif operation == "MATCHES" then
		return strmatch(strlower(row[self._field]), value) and true or false
	elseif operation == "IS_NIL" then
		return row[self._field] == nil
	elseif operation == "IS_NOT_NIL" then
		return row[self._field] ~= nil
	elseif operation == "CUSTOM" then
		return self._field(row, value) and true or false
	elseif operation == "HASH_EQUAL" then
		return row:CalculateHash(self._field) == value
	elseif operation == "OR" then
		for i = 1, #self._subClauses do
			if self._subClauses[i]:_IsTrue(row) then
				return true
			end
		end
		return false
	elseif operation == "AND" then
		for i = 1, #self._subClauses do
			if not self._subClauses[i]:_IsTrue(row) then
				return false
			end
		end
		return true
	else
		error("Invalid operation: " .. tostring(operation))
	end
end

function DatabaseQueryClause._GetIndexValue(self, indexField)
	if self._operation == "EQUAL" then
		if self._field ~= indexField then
			return
		end
		if self._value == TSM.CONST.OTHER_FIELD_QUERY_PARAM then
			return
		elseif self._value == TSM.CONST.BOUND_QUERY_PARAM then
			return self._boundValue
		else
			return self._value
		end
	elseif self._operation == "OR" then
		-- all of the subclauses needs to support this index (with the same value as long as we only support indexing on EQUAL clauses)
		local value = nil
		for _, subClause in ipairs(self._subClauses) do
			local subClauseValue = subClause:_GetIndexValue(indexField)
			if value == nil then
				value = subClauseValue
			elseif subClauseValue ~= value then
				return
			end
		end
		return value
	elseif self._operation == "AND" then
		-- just one of the subclauses needs to support this index
		for _, subClause in ipairs(self._subClauses) do
			local value = subClause:_GetIndexValue(indexField)
			if value ~= nil then
				return value
			end
		end
	end
end

function DatabaseQueryClause._IsStrictIndex(self, indexField, indexValue)
	if self._operation == "EQUAL" and self._field == indexField and self._value ~= TSM.CONST.OTHER_FIELD_QUERY_PARAM then
		if self._value == TSM.CONST.BOUND_QUERY_PARAM then
			return self._boundValue == indexValue
		else
			return self._value == indexValue
		end
	elseif (self._operation == "OR" or self._operation == "AND") and #self._subClauses == 1 then
		return self._subClauses[1]:_IsStrictIndex(indexField, indexValue)
	end
	return false
end

function DatabaseQueryClause._InsertSubClause(self, subClause)
	assert(self._operation == "OR" or self._operation == "AND")
	tinsert(self._subClauses, subClause)
	self._query:_MarkResultStale()
	return self
end

function DatabaseQueryClause._SetComparisonOperation(self, operation, field, value, otherField)
	assert(not self._operation)
	assert(value == TSM.CONST.OTHER_FIELD_QUERY_PARAM or not otherField)
	self._operation = operation
	self._field = field
	self._value = value
	self._otherField = otherField
	self._query:_MarkResultStale()
	return self
end

function DatabaseQueryClause._SetSubClauseOperation(self, operation)
	assert(not self._operation)
	self._operation = operation
	assert(#self._subClauses == 0)
	self._query:_MarkResultStale()
	return self
end

function DatabaseQueryClause._BindParams(self, ...)
	if self._value == TSM.CONST.BOUND_QUERY_PARAM then
		self._boundValue = ...
		self._query:_MarkResultStale()
		return 1
	end
	local valuesUsed = 0
	for _, clause in ipairs(self._subClauses) do
		valuesUsed = valuesUsed + clause:_BindParams(select(valuesUsed + 1, ...))
	end
	self._query:_MarkResultStale()
	return valuesUsed
end
