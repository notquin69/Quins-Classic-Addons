-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local SavedSearches = TSM.Shopping:NewPackage("SavedSearches")
local private = { db = nil }



-- ============================================================================
-- Module Functions
-- ============================================================================

function SavedSearches.OnInitialize()
	-- remove duplicates
	local keepSearch = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, data in ipairs(TSM.db.global.userData.savedShoppingSearches) do
		local filter = strlower(data.filter)
		if not keepSearch[filter] then
			keepSearch[filter] = data
		else
			if data.isFavorite == keepSearch[filter].isFavorite then
				if data.lastSearch > keepSearch[filter].lastSearch then
					keepSearch[filter] = data
				end
			elseif data.isFavorite then
				keepSearch[filter] = data
			end
		end
	end
	for i = #TSM.db.global.userData.savedShoppingSearches, 1, -1 do
		if not keepSearch[strlower(TSM.db.global.userData.savedShoppingSearches[i].filter)] then
			tremove(TSM.db.global.userData.savedShoppingSearches, i)
		end
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(keepSearch)

	private.db = TSMAPI_FOUR.Database.NewSchema("SHOPPING_SAVED_SEARCHES")
		:AddUniqueNumberField("index")
		:AddStringField("name")
		:AddNumberField("lastSearch")
		:AddBooleanField("isFavorite")
		:AddStringField("mode")
		:AddStringField("filter")
		:AddIndex("index")
		:AddIndex("lastSearch")
		:AddIndex("name")
		:Commit()
	private.db:BulkInsertStart()
	for index, data in pairs(TSM.db.global.userData.savedShoppingSearches) do
		assert(data.searchMode == "normal" or data.searchMode == "crafting")
		private.db:BulkInsertNewRow(index, data.name, data.lastSearch, data.isFavorite and true or false, data.searchMode, data.filter)
	end
	private.db:BulkInsertEnd()
end

function SavedSearches.CreateRecentSearchesQuery()
	return private.db:NewQuery()
		:OrderBy("lastSearch", false)
end

function SavedSearches.CreateFavoriteSearchesQuery()
	return private.db:NewQuery()
		:Equal("isFavorite", true)
		:OrderBy("name", true)
end

function SavedSearches.SetSearchIsFavorite(dbRow, isFavorite)
	TSM.db.global.userData.savedShoppingSearches[dbRow:GetField("index")].isFavorite = isFavorite or nil
	dbRow:SetField("isFavorite",  isFavorite)
		:Update()
end

function SavedSearches.RenameSearch(dbRow, newName)
	TSM.db.global.userData.savedShoppingSearches[dbRow:GetField("index")].name = newName
	dbRow:SetField("name", newName)
		:Update()
end

function SavedSearches.DeleteSearch(dbRow)
	local index = dbRow:GetField("index")
	tremove(TSM.db.global.userData.savedShoppingSearches, index)
	private.db:SetQueryUpdatesPaused(true)
	private.db:DeleteRow(dbRow)
	-- need to decrement the index fields of all the rows which got shifted up
	local query = private.db:NewQuery()
		:GreaterThan("index", index)
		:OrderBy("index", true)
	for _, row in query:Iterator() do
		row:SetField("index", row:GetField("index") - 1)
			:Update()
	end
	query:Release()
	private.db:SetQueryUpdatesPaused(false)
end

function SavedSearches.RecordFilterSearch(filter)
	local found = false
	for i, data in ipairs(TSM.db.global.userData.savedShoppingSearches) do
		if strlower(data.filter) == strlower(filter) then
			data.lastSearch = time()
			local row = private.db:GetUniqueRow("index", i)
			row:SetField("lastSearch", data.lastSearch)
				:Update()
			row:Release()
			found = true
			break
		end
	end
	if not found then
		local data = {
			name = filter,
			filter = filter,
			lastSearch = time(),
			searchMode = strfind(strlower(filter), "/crafting$") and "crafting" or "normal",
			isFavorite = nil,
		}
		tinsert(TSM.db.global.userData.savedShoppingSearches, data)
		private.db:NewRow()
			:SetField("index", #TSM.db.global.userData.savedShoppingSearches)
			:SetField("name", data.name)
			:SetField("lastSearch", data.lastSearch)
			:SetField("isFavorite", data.isFavorite and true or false)
			:SetField("mode", data.searchMode)
			:SetField("filter", data.filter)
			:Create()
	end
end
