-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local DatabaseSchema = TSMAPI_FOUR.Class.DefineClass("DatabaseSchema")
TSM.Database.classes.DatabaseSchema = DatabaseSchema
local private = {}
local FIELD_TYPE_IS_VALID = {
	string = true,
	number = true,
	boolean = true,
}
local MAX_MULTI_FIELD_INDEX_PARTS = 2



-- ============================================================================
-- Class Method Methods
-- ============================================================================

function DatabaseSchema.__init(self)
	self._name = nil
	self._fieldList = {}
	self._fieldTypeLookup = {}
	self._isIndex = {}
	self._isUnique = {}
	self._smartMapLookup = {}
	self._smartMapInputLookup = {}
end

function DatabaseSchema._Acquire(self, name)
	assert(type(name) == "string")
	self._name = name
end

function DatabaseSchema._Release(self)
	self._name = nil
	wipe(self._fieldList)
	wipe(self._fieldTypeLookup)
	wipe(self._isIndex)
	wipe(self._isUnique)
	wipe(self._smartMapLookup)
	wipe(self._smartMapInputLookup)
	TSM.Database.RecycleDatabaseSchema(self)
end



-- ============================================================================
-- Public Class Method
-- ============================================================================

function DatabaseSchema.AddStringField(self, fieldName)
	self:_AddField("string", fieldName)
	return self
end

function DatabaseSchema.AddNumberField(self, fieldName)
	self:_AddField("number", fieldName)
	return self
end

function DatabaseSchema.AddBooleanField(self, fieldName)
	self:_AddField("boolean", fieldName)
	return self
end

function DatabaseSchema.AddUniqueStringField(self, fieldName)
	self:_AddField("string", fieldName, true)
	self._isUnique[fieldName] = true
	return self
end

function DatabaseSchema.AddUniqueNumberField(self, fieldName)
	self:_AddField("number", fieldName, true)
	return self
end

function DatabaseSchema.AddSmartMapField(self, fieldName, map, inputFieldName)
	assert(self._fieldTypeLookup[inputFieldName] == map:GetKeyType())
	self:_AddField(map:GetValueType(), fieldName)
	self._smartMapLookup[fieldName] = map
	self._smartMapInputLookup[fieldName] = inputFieldName
	return self
end

function DatabaseSchema.AddIndex(self, ...)
	local numFields = select("#", ...)
	assert(numFields > 0)
	assert(numFields <= MAX_MULTI_FIELD_INDEX_PARTS, "Unsupported number of fields in index")
	for i = 1, numFields do
		local fieldName = select(i, ...)
		assert(self._fieldTypeLookup[fieldName])
	end
	self._isIndex[strjoin(TSM.CONST.DB_INDEX_FIELD_SEP, ...)] = true
	return self
end

function DatabaseSchema.Commit(self)
	return TSM.Database.CreateDatabaseFromSchema(self)
end



-- ============================================================================
-- Private Class Method
-- ============================================================================

function DatabaseSchema._GetName(self)
	return self._name
end

function DatabaseSchema._AddField(self, fieldType, fieldName, isUnique)
	assert(FIELD_TYPE_IS_VALID[fieldType])
	assert(type(fieldName) == "string" and strsub(fieldName, 1, 1) ~= "_" and not strmatch(fieldName, TSM.CONST.DB_INDEX_FIELD_SEP))
	assert(not self._fieldTypeLookup[fieldName])
	tinsert(self._fieldList, fieldName)
	self._fieldTypeLookup[fieldName] = fieldType
	if isUnique then
		self._isUnique[fieldName] = true
	end
end

function DatabaseSchema._FieldIterator(self)
	return private.FieldIterator, self, 0
end

function DatabaseSchema._MultiFieldIndexIterator(self)
	return private.MultiFieldIndexIterator, self, nil
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.FieldIterator(self, index)
	index = index + 1
	if index > #self._fieldList then
		return
	end
	local fieldName = self._fieldList[index]
	return index, fieldName, self._fieldTypeLookup[fieldName], self._isIndex[fieldName], self._isUnique[fieldName], self._smartMapLookup[fieldName], self._smartMapInputLookup[fieldName]
end

function private.MultiFieldIndexIterator(self, fieldName)
	while true do
		fieldName = next(self._isIndex, fieldName)
		if not fieldName then
			return
		end
		if strmatch(fieldName, TSM.CONST.DB_INDEX_FIELD_SEP) then
			return fieldName
		end
	end
end
