-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local SavedSearches = TSM.Auctioning:NewPackage("SavedSearches")
local L = TSM.L
local private = { db = nil }
local FILTER_SEP = "\001"



-- ============================================================================
-- Module Functions
-- ============================================================================

function SavedSearches.OnInitialize()
	-- remove duplicates
	local keepSearch = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, data in ipairs(TSM.db.global.userData.savedAuctioningSearches) do
		local filter = data.filter
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
	for i = #TSM.db.global.userData.savedAuctioningSearches, 1, -1 do
		if not keepSearch[TSM.db.global.userData.savedAuctioningSearches[i].filter] then
			tremove(TSM.db.global.userData.savedAuctioningSearches, i)
		end
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(keepSearch)

	private.db = TSMAPI_FOUR.Database.NewSchema("AUCTIONING_SAVED_SEARCHES")
		:AddUniqueNumberField("index")
		:AddNumberField("lastSearch")
		:AddBooleanField("isFavorite")
		:AddStringField("searchType")
		:AddStringField("filter")
		:AddStringField("name")
		:AddIndex("index")
		:Commit()
	private.db:BulkInsertStart()
	for index, data in pairs(TSM.db.global.userData.savedAuctioningSearches) do
		assert(data.searchType == "postItems" or data.searchType == "postGroups" or data.searchType == "cancelGroups")
		private.db:BulkInsertNewRow(index, data.lastSearch, data.isFavorite and true or false, data.searchType, data.filter, private.GetSearchName(data.filter, data.searchType))
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
		:OrderBy("lastSearch", false)
end

function SavedSearches.SetSearchIsFavorite(dbRow, isFavorite)
	local data = TSM.db.global.userData.savedAuctioningSearches[dbRow:GetField("index")]
	data.isFavorite = isFavorite or nil
	dbRow:SetField("isFavorite",  isFavorite)
		:Update()
end

function SavedSearches.DeleteSearch(dbRow)
	local index = dbRow:GetField("index")
	tremove(TSM.db.global.userData.savedAuctioningSearches, index)
	private.db:DeleteRow(dbRow)
	-- need to decrement the index fields of all the rows which got shifted up
	private.db:SetQueryUpdatesPaused(true)
	local query = private.db:NewQuery()
		:GreaterThanOrEqual("index", index)
		:OrderBy("index", true)
	for _, row in query:Iterator() do
		row:SetField("index", row:GetField("index") - 1)
			:Update()
	end
	query:Release()
	private.db:SetQueryUpdatesPaused(false)
end

function SavedSearches.RecordSearch(searchList, searchType)
	assert(searchType == "postItems" or searchType == "postGroups" or searchType == "cancelGroups")
	local filter = table.concat(searchList, FILTER_SEP)
	for i, data in ipairs(TSM.db.global.userData.savedAuctioningSearches) do
		if data.filter == filter and data.searchType == searchType then
			data.lastSearch = time()
			local row = private.db:GetUniqueRow("index", i)
			row:SetField("lastSearch", data.lastSearch)
				:Update()
			row:Release()
			return
		end
	end
	local data = {
		filter = filter,
		lastSearch = time(),
		searchType = searchType,
		isFavorite = nil,
	}
	tinsert(TSM.db.global.userData.savedAuctioningSearches, data)
	private.db:NewRow()
		:SetField("index", #TSM.db.global.userData.savedAuctioningSearches)
		:SetField("lastSearch", data.lastSearch)
		:SetField("isFavorite", data.isFavorite and true or false)
		:SetField("searchType", data.searchType)
		:SetField("filter", data.filter)
		:SetField("name", private.GetSearchName(data.filter, data.searchType))
		:Create()
end

function SavedSearches.FiltersToTable(dbRow, tbl)
	for filter in gmatch(dbRow:GetField("filter"), "[^"..FILTER_SEP.."]+") do
		tinsert(tbl, filter)
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetSearchName(filter, searchType)
	local filters = TSMAPI_FOUR.Util.AcquireTempTable()
	local searchTypeStr, numFiltersStr = nil, nil
	if filter == "" or string.sub(filter, 1, 1) == FILTER_SEP then
		tinsert(filters, L["Base Group"])
	end
	if searchType == "postGroups" or searchType == "cancelGroups" then
		for groupPath in gmatch(filter, "[^"..FILTER_SEP.."]+") do
			local groupName = TSM.Groups.Path.GetName(groupPath)
			local level = select('#', strsplit(TSM.CONST.GROUP_SEP, groupPath))
			local color = gsub(TSM.UI.GetGroupLevelColor(level), "#", "|cff")
			tinsert(filters, color..groupName.."|r")
			if #filters == 11 then
				break
			end
		end
		searchTypeStr = searchType == "postGroups" and L["Post Scan"] or L["Cancel Scan"]
		numFiltersStr = #filters == 1 and L["1 Group"] or format(L["%d Groups"], #filters)
	elseif searchType == "postItems" then
		local numItems = 0
		for itemString in gmatch(filter, "[^"..FILTER_SEP.."]+") do
			numItems = numItems + 1
			local coloredName = TSM.UI.GetColoredItemName(itemString)
			if coloredName then
				tinsert(filters, coloredName)
				if #filters == 11 then
					break
				end
			end
		end
		searchTypeStr = L["Post Scan"]
		numFiltersStr = numItems == 1 and L["1 Item"] or format(L["%d Items"], numItems)
	else
		error("Unknown searchType: "..tostring(searchType))
	end
	local groupList = nil
	if #filters > 10 then
		groupList = table.concat(filters, ", ", 1, 10)..",..."
		TSMAPI_FOUR.Util.ReleaseTempTable(filters)
	else
		groupList = strjoin(", ", TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(filters))
	end
	return format("%s (%s): %s", searchTypeStr, numFiltersStr, groupList)
end
