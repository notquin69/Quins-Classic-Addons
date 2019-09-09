-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Database TSMAPI_FOUR Functions.
-- @module Database

TSMAPI_FOUR.Database = {}
local _, TSM = ...
local Database = TSM:NewPackage("Database")
Database.classes = {}
local private = {
	-- make the initial UUID a very big negative number so it doesn't conflict with other numbers
	lastUUID = -1000000,
	databaseSchemas = nil,
	databaseQueries = nil,
	databaseQueryClauses = nil,
	databaseQueryResultRows = nil,
	dbByNameLookup = {},
	infoNameDB = nil,
	infoFieldDB = nil,
}



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

--- Create a new database schema.
-- @tparam string name The name of the schema for debug use
-- @treturn DatabaseSchema The database schema object
function TSMAPI_FOUR.Database.NewSchema(name)
	local schema = private.databaseSchemas:Get()
	schema:_Acquire(name)
	return schema
end



-- ============================================================================
-- Module Functions (Internal)
-- ============================================================================

function Database.OnInitialize()
	private.databaseSchemas = TSMAPI_FOUR.ObjectPool.New("DATABASE_SCHEMAS", Database.classes.DatabaseSchema, 1)
	private.databaseQueries = TSMAPI_FOUR.ObjectPool.New("DATABASE_QUERIES", Database.classes.DatabaseQuery, 1)
	private.databaseQueryClauses = TSMAPI_FOUR.ObjectPool.New("DATABASE_QUERY_CLAUSES", Database.classes.DatabaseQueryClause, 3)
	private.databaseQueryResultRows = TSMAPI_FOUR.ObjectPool.New("DATABASE_QUERY_RESULT_ROWS", Database.DatabaseQueryResultRow.New)

	-- Create the information databases
	private.infoNameDB = Database.classes.Database(TSMAPI_FOUR.Database.NewSchema("DEBUG_INFO_NAME")
		:AddUniqueStringField("name")
		:AddIndex("name")
	)
	private.infoFieldDB = Database.classes.Database(TSMAPI_FOUR.Database.NewSchema("DEBUG_INFO_FIELD")
		:AddStringField("dbName")
		:AddStringField("field")
		:AddStringField("type")
		:AddStringField("attributes")
		:AddNumberField("order")
		:AddIndex("dbName")
	)
end

function Database.CreateDatabaseFromSchema(schema)
	local name = schema:_GetName()
	assert(not private.dbByNameLookup[name], "A database with this name already exists")
	private.infoNameDB:NewRow()
		:SetField("name", name)
		:Create()

	for index, fieldName, fieldType, isIndex, isUnique in schema:_FieldIterator() do
		local fieldAttributes = (isIndex and isUnique and "index,unique") or (isIndex and "index") or (isUnique and "unique") or ""
		private.infoFieldDB:NewRow()
			:SetField("dbName", name)
			:SetField("field", fieldName)
			:SetField("type", fieldType)
			:SetField("attributes", fieldAttributes)
			:SetField("order", index)
			:Create()
	end
	for fieldName in schema:_MultiFieldIndexIterator() do
		private.infoFieldDB:NewRow()
			:SetField("dbName", name)
			:SetField("field", fieldName)
			:SetField("type", "-")
			:SetField("attributes", "multi-field index")
			:SetField("order", -1)
			:Create()
	end

	local db = Database.classes.Database(schema)
	private.dbByNameLookup[name] = db
	return db
end

function Database.GetNextUUID()
	private.lastUUID = private.lastUUID - 1
	return private.lastUUID
end

function Database.RecycleDatabaseSchema(schema)
	private.databaseSchemas:Recycle(schema)
end

function Database.GetDatabaseQuery()
	return private.databaseQueries:Get()
end

function Database.RecycleDatabaseQuery(query)
	private.databaseQueries:Recycle(query)
end

function Database.GetDatabaseQueryClause()
	return private.databaseQueryClauses:Get()
end

function Database.RecycleDatabaseQueryClause(queryClause)
	private.databaseQueryClauses:Recycle(queryClause)
end

function Database.GetDatabaseQueryResultRow()
	return private.databaseQueryResultRows:Get()
end

function Database.RecycleDatabaseQueryResultRow(row)
	private.databaseQueryResultRows:Recycle(row)
end



-- ============================================================================
-- Debug Functions
-- ============================================================================

function Database.InfoNameIterator()
	return private.infoNameDB:NewQuery()
		:Select("name")
		:OrderBy("name", true)
		:IteratorAndRelease()
end

function Database.CreateInfoFieldQuery(dbName)
	return private.infoFieldDB:NewQuery()
		:Equal("dbName", dbName)
end

function Database.GetNumRows(dbName)
	return private.dbByNameLookup[dbName]:GetNumRows()
end

function Database.GetNumActiveQueries(dbName)
	return #private.dbByNameLookup[dbName]._queries
end

function Database.CreateDBQuery(dbName)
	return private.dbByNameLookup[dbName]:NewQuery()
end
