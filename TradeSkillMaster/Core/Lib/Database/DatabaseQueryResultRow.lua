-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local DatabaseQueryResultRow = TSM.Database:NewPackage("DatabaseQueryResultRow")
local private = { context = {} }

local ROW_PROTOTYPE = {
	_Acquire = function(self, db, query, isNewRow)
		local context = private.context[self]
		context.db = db
		context.query = query
		context.isNewRow = isNewRow
		if isNewRow then
			context.uuid = TSM.Database.GetNextUUID()
		end
	end,

	_Release = function(self)
		local context = private.context[self]
		context.db = nil
		context.query = nil
		context.isNewRow = nil
		context.uuid = nil
		for i = 1, context.numJoins or 0 do
			context["joinDB"..i] = nil
			context["joinField"..i] = nil
		end
		context.numJoins = nil
		assert(not context.pendingChanges)
		wipe(self)
	end,

	Release = function(self)
		self:_Release()
		TSM.Database.RecycleDatabaseQueryResultRow(self)
	end,

	_SetUUID = function(self, uuid)
		local context = private.context[self]
		context.uuid = uuid
		for i = 1, context.numJoins or 0 do
			context["joinDB"..i] = nil
			context["joinField"..i] = nil
		end
		context.numJoins = nil
		wipe(self)
	end,

	_AddJoinInfo = function(self, joinDB, joinField)
		local context = private.context[self]
		context.numJoins = (context.numJoins or 0) + 1
		context["joinDB"..context.numJoins] = joinDB
		context["joinField"..context.numJoins] = joinField
	end,

	GetUUID = function(self)
		local uuid = private.context[self].uuid
		assert(uuid)
		return uuid
	end,

	GetField = function(self, field, ...)
		if ... then
			error("GetField() only supports 1 field")
		end
		return self[field]
	end,

	GetFields = function(self, ...)
		local numFields = select("#", ...)
		local field1, field2, field3, field4, field5, field6, field7, field8 = ...
		if numFields == 0 then
			return
		elseif numFields == 1 then
			return self[field1]
		elseif numFields == 2 then
			return self[field1], self[field2]
		elseif numFields == 3 then
			return self[field1], self[field2], self[field3]
		elseif numFields == 4 then
			return self[field1], self[field2], self[field3], self[field4]
		elseif numFields == 5 then
			return self[field1], self[field2], self[field3], self[field4], self[field5]
		elseif numFields == 6 then
			return self[field1], self[field2], self[field3], self[field4], self[field5], self[field6]
		elseif numFields == 7 then
			return self[field1], self[field2], self[field3], self[field4], self[field5], self[field6], self[field7]
		elseif numFields == 8 then
			return self[field1], self[field2], self[field3], self[field4], self[field5], self[field6], self[field7], self[field8]
		else
			error("GetFields() only supports up to 8 fields")
		end
	end,

	CalculateHash = function(self, fields)
		local hash = nil
		for _, field in ipairs(fields) do
			hash = TSMAPI_FOUR.Util.CalculateHash(self[field], hash)
		end
		return hash
	end,

	SetField = function(self, field, value)
		local context = private.context[self]
		local isSameValue = not context.isNewRow and value == self[field]
		if isSameValue and not context.pendingChanges then
			-- setting to the same value, so ignore this call
			return self
		end
		if context.db:_IsSmartMapField(field) then
			error(format("Cannot set smart map field (%s)", tostring(field)), 3)
		end
		local fieldType = context.db:_GetFieldType(field)
		if not fieldType then
			error(format("Field %s doesn't exist", tostring(field)), 3)
		elseif fieldType ~= type(value) then
			error(format("Field %s should be a %s, got %s", tostring(field), tostring(fieldType), type(value)), 2)
		end
		if isSameValue then
			-- setting the field to its original value, so clear any pending change
			context.pendingChanges[field] = nil
			if not next(context.pendingChanges) then
				TSMAPI_FOUR.Util.ReleaseTempTable(context.pendingChanges)
				context.pendingChanges = nil
			end
		else
			context.pendingChanges = context.pendingChanges or TSMAPI_FOUR.Util.AcquireTempTable()
			context.pendingChanges[field] = value
		end
		return self
	end,

	_CreateHelper = function(self)
		local context = private.context[self]
		assert(context.isNewRow and context.pendingChanges)

		-- make sure all the fields are set
		for field in context.db:FieldIterator() do
			assert(context.pendingChanges[field] ~= nil)
		end

		-- apply all the pending changes
		for field, value in pairs(context.pendingChanges) do
			-- cache this new value
			rawset(self, field, value)
		end

		TSMAPI_FOUR.Util.ReleaseTempTable(context.pendingChanges)
		context.pendingChanges = nil
		context.isNewRow = nil
	end,

	Create = function(self)
		self:_CreateHelper()
		private.context[self].db:_InsertRow(self)
	end,

	CreateAndClone = function(self)
		self:_CreateHelper()
		local clonedRow = self:Clone()
		private.context[self].db:_InsertRow(self)
		return clonedRow
	end,

	Update = function(self)
		local context = private.context[self]
		assert(not context.isNewRow)
		if not context.pendingChanges then
			return
		end

		-- apply all the pending changes
		local oldValues = TSMAPI_FOUR.Util.AcquireTempTable()
		for field, value in pairs(context.pendingChanges) do
			oldValues[field] = self[field]
			-- cache this new value
			rawset(self, field, value)
		end

		TSMAPI_FOUR.Util.ReleaseTempTable(context.pendingChanges)
		context.pendingChanges = nil
		context.db:_UpdateRow(self, oldValues)
		TSMAPI_FOUR.Util.ReleaseTempTable(oldValues)
		return self
	end,

	CreateOrUpdateAndRelease = function(self)
		local context = private.context[self]
		if context.isNewRow then
			self:Create()
		else
			self:Update()
			self:Release()
		end
	end,

	Clone = function(self)
		local context = private.context[self]
		assert(not context.isNewRow and not context.pendingChanges)
		local newRow = TSM.Database.GetDatabaseQueryResultRow()
		newRow:_Acquire(context.db)
		newRow:_SetUUID(context.uuid)
		for i = 1, context.numJoins or 0 do
			newRow:_AddJoinInfo(context["joinDB"..i], context["joinField"..i])
		end
		return newRow
	end,
}

local ROW_MT = {
	-- getter
	__index = function(self, key)
		if key == nil then
			error("Attempt to get nil key")
		end
		if ROW_PROTOTYPE[key] then
			return ROW_PROTOTYPE[key]
		end
		-- cache the value
		local context = private.context[self]
		if context.isNewRow then
			error("Getting value on a new row: "..tostring(key))
		end
		local result = nil
		if context.query then
			-- use the query to lookup the result
			result = context.query:_GetResultRowData(context.uuid, key)
		else
			-- we're not tied to a query so this should be a local DB field
			if not context.db:_GetFieldType(key) then
				error("Invalid field: "..tostring(key), 2)
			end
			result = context.db:_GetRowData(context.uuid, key)
		end
		if result ~= nil then
			rawset(self, key, result)
		end
		return result
	end,
	-- setter
	__newindex = function(self, key, value)
		error("Table is read-only", 2)
	end,
	__eq = function(self, other)
		return self:GetUUID() == other:GetUUID()
	end,
	__tostring = function(self)
		local context = private.context[self]
		return "DatabaseQueryResultRow:"..strmatch(tostring(context), "table:[^0-9a-fA-F]*([0-9a-fA-F]+)")..":"..self:GetUUID()
	end,
	__metatable = false,
}

function DatabaseQueryResultRow.New()
	local row = setmetatable({}, ROW_MT)
	private.context[row] = {
		db = nil,
		query = nil,
		isNewRow = nil,
		uuid = nil,
		numJoins = nil,
	}
	return row
end
