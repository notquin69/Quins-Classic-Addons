-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--          http://www.curse.com/addons/wow/tradeskillmaster_warehousing          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Util TSMAPI_FOUR Functions
-- @module Util

TSMAPI_FOUR.Util = {}
local private = {
	freeTempTables = {},
	tempTableState = {},
	filterTemp = {},
	sortComparator = nil,
	sortContext = nil,
	sortValueLookup = nil,
	keysTemp = {},
	itemLinkedCallbacks = {},
	localLinesTemp = {},
	iterContext = { arg = {}, index = {}, helperFunc = {}, cleanupFunc = {} },
}
setmetatable(private.iterContext.arg, { __mode = "k" })
setmetatable(private.iterContext.index, { __mode = "k" })
setmetatable(private.iterContext.helperFunc, { __mode = "k" })
setmetatable(private.iterContext.cleanupFunc, { __mode = "k" })
local NUM_TEMP_TABLES = 100
local MAGIC_CHARACTERS = { '[', ']', '(', ')', '.', '+', '-', '*', '?', '^', '$' }
local RELEASED_TEMP_TABLE_MT = {
	__newindex = function(self, key, value)
		error("Attempt to access temp table after release")
		rawset(self, key, value)
	end,
	__index = function(self, key)
		error("Attempt to access temp table after release")
		return rawget(self, key)
	end,
}
local SLOT_ID_MULTIPLIER = 1000

-- setup the temporary tables
do
	for _ = 1, NUM_TEMP_TABLES do
		local tempTbl = setmetatable({}, RELEASED_TEMP_TABLE_MT)
		tinsert(private.freeTempTables, tempTbl)
	end
end
-- setup hooks to handle shift-clicking on items
do
	local function HandleShiftClickItem(origFunc, itemLink)
		local putIntoChat = origFunc(itemLink)
		if putIntoChat then
			return putIntoChat
		end
		local name = TSMAPI_FOUR.Item.GetName(itemLink)
		if not name or not private.HandleItemLinked(name, itemLink) then
			return putIntoChat
		end
		return true
	end
	local origHandleModifiedItemClick = HandleModifiedItemClick
	HandleModifiedItemClick = function(link)
		return HandleShiftClickItem(origHandleModifiedItemClick, link)
	end
	local origChatEdit_InsertLink = ChatEdit_InsertLink
	ChatEdit_InsertLink = function(link)
		return HandleShiftClickItem(origChatEdit_InsertLink, link)
	end
end



-- ============================================================================
-- TSMAPI Functions - String
-- ============================================================================

--- Splits a string in a way which won't cause stack overflows for large inputs.
-- The lua strsplit function causes a stack overflow if passed large inputs. This API fixes that issue and also supports
-- separators which are more than one character in length.
-- @tparam string str The string to be split
-- @tparam string sep The separator to use to split the string
-- @treturn table The result as a list of substrings
-- @within String
function TSMAPI_FOUR.Util.SafeStrSplit(str, sep)
	local parts = {}
	local s = 1
	local sepLength = #sep
	if sepLength == 0 then
		tinsert(parts, str)
		return parts
	end
	while true do
		local e = strfind(str, sep, s)
		if not e then
			tinsert(parts, strsub(str, s))
			break
		end
		tinsert(parts, strsub(str, s, e - 1))
		s = e + sepLength
	end
	return parts
end

--- Escapes any magic characters used by lua's pattern matching.
-- @tparam string str The string to be escaped
-- @treturn string The escaped string
-- @within String
function TSMAPI_FOUR.Util.StrEscape(str)
	assert(not strmatch(str, "\001"), "Input string must not contain '\\001' characters")
	str = gsub(str, "%%", "\001")
	for _, char in ipairs(MAGIC_CHARACTERS) do
		str = gsub(str, "%"..char, "%%"..char)
	end
	str = gsub(str, "\001", "%%%%")
	return str
end

--- Check if a string which contains multiple values separated by a specific string contains the value.
-- @tparam string str The string to be searched
-- @tparam string sep The separating string
-- @tparam string value The value to search for
-- @treturn boolean Whether or not the value was found
-- @within String
function TSMAPI_FOUR.Util.SeparatedStrContains(str, sep, value)
	return str == value or strmatch(str, "^"..value..sep) or strmatch(str, sep..value..sep) or strmatch(str, sep..value.."$")
end

--- Iterates over the parts of a string which are separated by a character.
-- @tparam string str The string to be split
-- @tparam string sep The separator to use to split the string
-- @return An iterator with fields: `part`
-- @within String
function TSMAPI_FOUR.Util.StrSplitIterator(str, sep)
	assert(#sep == 1)
	for _, char in ipairs(MAGIC_CHARACTERS) do
		if char == sep then
			sep = "%"..char
		end
	end
	return gmatch(str, "([^"..sep.."]+)")
end



-- ============================================================================
-- TSMAPI Functions - Math
-- ============================================================================

--- Rounds a value to a specified significant value.
-- @tparam number value The number to be rounded
-- @tparam number sig The value to round to the nearest multiple of
-- @treturn number The rounded value
-- @within Math
function TSMAPI_FOUR.Util.Round(value, sig)
	sig = sig or 1
	return floor((value / sig) + 0.5) * sig
end

--- Rounds a value down to a specified significant value.
-- @tparam number value The number to be rounded
-- @tparam number sig The value to round down to the nearest multiple of
-- @treturn number The rounded value
-- @within Math
function TSMAPI_FOUR.Util.Floor(value, sig)
	sig = sig or 1
	return floor(value / sig) * sig
end

--- Rounds a value up to a specified significant value.
-- @tparam number value The number to be rounded
-- @tparam number sig The value to round up to the nearest multiple of
-- @treturn number The rounded value
-- @within Math
function TSMAPI_FOUR.Util.Ceil(value, sig)
	sig = sig or 1
	return ceil(value / sig) * sig
end

--- Scales a value from one range to another.
-- @tparam number value The number to be scaled
-- @tparam number fromMin The minimum value of the range to scale from
-- @tparam number fromMax The maximum value of the range to scale from
-- @tparam number toMin The minimum value of the range to scale to
-- @tparam number toMax The maximum value of the range to scale to
-- @treturn number The scaled value
-- @within Math
function TSMAPI_FOUR.Util.Scale(value, fromMin, fromMax, toMin, toMax)
	assert(fromMax > fromMin and toMax > toMin)
	assert(value >= fromMin and value <= fromMax)
	return toMin + ((value - fromMin) / (fromMax - fromMin)) * (toMax - toMin)
end

--- Calculates the has of the specified data
-- This data can handle data of type string or number. It can also handle a table being passed as the data assuming
-- all keys and values of the table are also hashable (strings, numbers, or tables with the same restriction). This
-- function uses the [djb2 algorithm](http://www.cse.yorku.ca/~oz/hash.html).
-- @param data The data to be hased
-- @tparam[opt] number hash The initial value of the hash
-- @treturn number The hash value
-- @within Math
function TSMAPI_FOUR.Util.CalculateHash(data, hash)
	hash = hash or 5381
	local maxValue = 2 ^ 24
	if type(data) == "string" then
		-- iterate through 8 bytes at a time
		for i = 1, ceil(#data / 8) do
			local b1, b2, b3, b4, b5, b6, b7, b8 = strbyte(data, (i - 1) * 8 + 1, i * 8)
			hash = (hash * 33 + b1) % maxValue
			if not b2 then break end
			hash = (hash * 33 + b2) % maxValue
			if not b3 then break end
			hash = (hash * 33 + b3) % maxValue
			if not b4 then break end
			hash = (hash * 33 + b4) % maxValue
			if not b5 then break end
			hash = (hash * 33 + b5) % maxValue
			if not b6 then break end
			hash = (hash * 33 + b6) % maxValue
			if not b7 then break end
			hash = (hash * 33 + b7) % maxValue
			if not b8 then break end
			hash = (hash * 33 + b8) % maxValue
		end
	elseif type(data) == "number" then
		assert(data == floor(data), "Invalid number")
		while data > 0 do
			hash = (hash * 33 + data % 256) % maxValue
			data = floor(data / 256)
		end
	elseif type(data) == "table" then
		local keys = nil
		if private.keysTemp.inUse then
			keys = TSMAPI_FOUR.Util.AcquireTempTable()
		else
			keys = private.keysTemp
			private.keysTemp.inUse = true
		end
		for k in pairs(data) do
			tinsert(keys, k)
		end
		sort(keys)
		for _, key in ipairs(keys) do
			hash = TSMAPI_FOUR.Util.CalculateHash(key, hash)
			hash = TSMAPI_FOUR.Util.CalculateHash(data[key], hash)
		end
		if keys == private.keysTemp then
			wipe(private.keysTemp)
		else
			TSMAPI_FOUR.Util.ReleaseTempTable(keys)
		end
	elseif type(data) == "boolean" then
		hash = (hash * 33 + (data and 1 or 0)) % maxValue
	else
		error("Invalid data")
	end
	return hash
end



-- ============================================================================
-- TSMAPI Functions - Vararg
-- ============================================================================

--- Stores a varag into a table.
-- @tparam table tbl The table to store the values in
-- @param ... Zero or more values to store in the table
-- @within Vararg
function TSMAPI_FOUR.Util.VarargIntoTable(tbl, ...)
	for i = 1, select("#", ...) do
		tbl[i] = select(i, ...)
	end
end

--- Creates an iterator from a vararg.
-- NOTE: This iterator must be run to completion and not interrupted (i.e. with a `break` or `return`).
-- @param ... The values to iterate over
-- @return An iterator with fields: `index, value`
-- @within Vararg
function TSMAPI_FOUR.Util.VarargIterator(...)
	return TSMAPI_FOUR.Util.TempTableIterator(TSMAPI_FOUR.Util.AcquireTempTable(...))
end



-- ============================================================================
-- TSMAPI Functions - Table
-- ============================================================================

--- Creates an iterator from a table.
-- NOTE: This iterator must be run to completion and not interrupted (i.e. with a `break` or `return`).
-- @tparam table tbl The table (numerically-indexed) to iterate over
-- @tparam[opt] function helperFunc A helper function which gets passed the current index, value, and user-specified arg
-- and returns nothing if an entry in the table should be skipped or the result of an iteration loop
-- @param[opt] arg A value to be passed to the helper function
-- @tparam[opt] function cleanupFunc A function to be called (passed `tbl`) to cleanup at the end of iterator
-- @return An iterator with fields: `index, value` or the return of `helperFunc`
-- @within Table
function TSMAPI_FOUR.Util.TableIterator(tbl, helperFunc, arg, cleanupFunc)
	local iterContext = TSMAPI_FOUR.Util.AcquireTempTable()
	iterContext.data = tbl
	iterContext.arg = arg
	iterContext.index = 0
	iterContext.helperFunc = helperFunc
	iterContext.cleanupFunc = cleanupFunc
	return private.TableIterator, iterContext
end

--- Creates an iterator from the keys of a table.
-- @tparam table tbl The table to iterate over the keys of
-- @return An iterator with fields: `key`
-- @within Table
function TSMAPI_FOUR.Util.TableKeyIterator(tbl)
	return private.TableKeyIterator, tbl, nil
end

--- Uses a function to filter the entries in a table.
-- @tparam table tbl The table to be filtered
-- @tparam function func The filter function which gets passed `key, value, ...` and returns true if that entry should
-- be removed from the table
-- @param[opt] ... Optional arguments to be passed to the filter function
-- @within Table
function TSMAPI_FOUR.Util.TableFilter(tbl, func, ...)
	assert(not next(private.filterTemp))
	for k, v in pairs(tbl) do
		if func(k, v, ...) then
			tinsert(private.filterTemp, k)
		end
	end
	for _, k in ipairs(private.filterTemp) do
		tbl[k] = nil
	end
	wipe(private.filterTemp)
end

--- Removes all occurences of the value in the table.
-- Only the numerically-indexed entries are checked.
-- @tparam table tbl The table to remove the value from
-- @param value The value to remove
-- @treturn number The number of values removed
-- @within Table
function TSMAPI_FOUR.Util.TableRemoveByValue(tbl, value)
	local numRemoved = 0
	for i = #tbl, 1, -1 do
		if tbl[i] == value then
			tremove(tbl, i)
			numRemoved = numRemoved + 1
		end
	end
	return numRemoved
end

--- Gets the table key by value.
-- @tparam table tbl The table to look through
-- @param value The value to get the key of
-- @return The key for the specified value or `nil`
-- @within Table
function TSMAPI_FOUR.Util.TableKeyByValue(tbl, value)
	for k, v in pairs(tbl) do
		if v == value then
			return k
		end
	end
end

--- Gets the number of entries in the table.
-- This can be used when the count of a non-numerically-indexed table is desired (i.e. `#tbl` wouldn't work).
-- @tparam table tbl The table to get the number of entries in
-- @treturn number The number of entries
-- @within Table
function TSMAPI_FOUR.Util.Count(tbl)
	local count = 0
	for _ in pairs(tbl) do
		count = count + 1
	end
	return count
end

--- Gets the distinct table key by value.
-- This function will assert if the value is not found in the table or if more than one key is found.
-- @tparam table tbl The table to look through
-- @param value The value to get the key of
-- @return The key for the specified value
-- @within Table
function TSMAPI_FOUR.Util.GetDistinctTableKey(tbl, value)
	local key = nil
	for k, v in pairs(tbl) do
		if v == value then
			assert(not key)
			key = k
		end
	end
	assert(key)
	return key
end

--- Checks if two tables have the same entries (non-recursively).
-- @tparam table tbl1 The first table to check
-- @tparam table tbl2 The second table to check
-- @treturn boolean Whether or not the tables are equal
-- @within Table
function TSMAPI_FOUR.Util.TablesEqual(tbl1, tbl2)
	if TSMAPI_FOUR.Util.Count(tbl1) ~= TSMAPI_FOUR.Util.Count(tbl2) then
		return false
	end
	for k, v in pairs(tbl1) do
		if tbl2[k] ~= v then
			return false
		end
	end
	return true
end

--- Does a table sort with extra arguments getting passed through to the comparator
-- @tparam table tbl The table to sort
-- @?tparam function comparator The comparasion function
-- @param ... Other arguments to pass through to the comparator
-- @within Table
function TSMAPI_FOUR.Util.TableSortWithContext(tbl, comparator, ...)
	assert(not private.sortComparator and not private.sortContext and comparator)
	private.sortComparator = comparator
	private.sortContext = TSMAPI_FOUR.Util.AcquireTempTable(...)
	sort(tbl, private.TableSortWithContextHelper)
	TSMAPI_FOUR.Util.ReleaseTempTable(private.sortContext)
	private.sortComparator = nil
	private.sortContext = nil
end

--- Does a table sort with an extra value lookup step
-- @tparam table tbl The table to sort
-- @tparam table valueLookup The sort value lookup table
-- @within Table
function TSMAPI_FOUR.Util.TableSortWithValueLookup(tbl, valueLookup)
	assert(not private.sortValueLookup and valueLookup)
	private.sortValueLookup = valueLookup
	sort(tbl, private.TableSortWithValueLookupHelper)
	private.sortValueLookup = nil
end



-- ============================================================================
-- TSMAPI Functions - Table Recycling
-- ============================================================================

--- Acquires a temporary table.
-- Temporary tables are recycled tables which can be used instead of creating a new table every time one is needed for a
-- defined lifecycle. This avoids relying on the garbage collector and improves overall performance.
-- @param ... Any number of valuse to insert into the table initially
-- @treturn table The temporary table
-- @within Temporary Table
function TSMAPI_FOUR.Util.AcquireTempTable(...)
	local tbl = tremove(private.freeTempTables, 1)
	assert(tbl, "Could not acquire temp table")
	setmetatable(tbl, nil)
	private.tempTableState[tbl] = (TSMAPI_FOUR.Util.GetDebugStackInfo(2) or "?").." -> "..(TSMAPI_FOUR.Util.GetDebugStackInfo(3) or "?")
	TSMAPI_FOUR.Util.VarargIntoTable(tbl, ...)
	return tbl
end

--- Iterators over a temporary table, releasing it when done.
-- NOTE: This iterator must be run to completion and not interrupted (i.e. with a `break` or `return`).
-- @tparam table tbl The temporary table to iterator over
-- @tparam[opt] function helperFunc A helper function for the iterator (see @{TSMAPI_FOUR.Util.TableIterator})
-- @param[opt] arg The argument to pass to `helperFunc` (see @{TSMAPI_FOUR.Util.TableIterator})
-- @return An iterator with fields: `index, value` or the return of `helperFunc`
-- @within Temporary Table
function TSMAPI_FOUR.Util.TempTableIterator(tbl, helperFunc, arg)
	assert(private.tempTableState[tbl])
	return TSMAPI_FOUR.Util.TableIterator(tbl, helperFunc, arg, TSMAPI_FOUR.Util.ReleaseTempTable)
end

--- Releases a temporary table.
-- The temporary table will be returned to the pool and must not be accessed after being released.
-- @tparam table tbl The temporary table to release
-- @within Temporary Table
function TSMAPI_FOUR.Util.ReleaseTempTable(tbl)
	private.TempTableReleaseHelper(tbl)
end

--- Releases a temporary table and returns its values.
-- Releases the temporary table (see @{TSMAPI_FOUR.Util.ReleaseTempTable}) and returns its unpacked values.
-- @tparam table tbl The temporary table to release and unpack
-- @return The result of calling `unpack` on the table
-- @within Temporary Table
function TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(tbl)
	return private.TempTableReleaseHelper(tbl, unpack(tbl))
end

function TSMAPI_FOUR.Util.GetTempTableDebugInfo()
	local counts = {}
	for _, info in pairs(private.tempTableState) do
		counts[info] = (counts[info] or 0) + 1
	end
	local debugInfo = {}
	for info, count in pairs(counts) do
		tinsert(debugInfo, format("[%d] %s", count, info))
	end
	if #debugInfo == 0 then
		tinsert(debugInfo, "<none>")
	end
	return debugInfo
end



-- ============================================================================
-- TSMAPI Functions - WoW Util
-- ============================================================================

--- Shows a WoW static popup dialog.
-- @tparam string name The unique (global) name of the dialog to be shown
-- @within WoW Util
function TSMAPI_FOUR.Util.ShowStaticPopupDialog(name)
	StaticPopupDialogs[name].preferredIndex = 4
	StaticPopup_Show(name)
	for i = 1, 100 do
		if _G["StaticPopup" .. i] and _G["StaticPopup" .. i].which == name then
			_G["StaticPopup" .. i]:SetFrameStrata("TOOLTIP")
			break
		end
	end
end

--- Sets the WoW tooltip to the specified link.
-- @tparam string link The itemLink or TSM itemString to show the tooltip for
-- @within WoW Util
function TSMAPI_FOUR.Util.SafeTooltipLink(link)
	if strmatch(link, "p:") then
		link = TSMAPI_FOUR.Item.GetLink(link)
	end
	if strmatch(link, "battlepet") then
		local _, speciesID, level, breedQuality, maxHealth, power, speed = strsplit(":", link)
		BattlePetToolTip_Show(tonumber(speciesID), tonumber(level) or 0, tonumber(breedQuality) or 0, tonumber(maxHealth) or 0, tonumber(power) or 0, tonumber(speed) or 0, gsub(gsub(link, "^(.*)%[", ""), "%](.*)$", ""))
	elseif strmatch(link, "currency") then
		local currencyID = strmatch(link, "currency:(%d+)")
		GameTooltip:SetCurrencyByID(currencyID)
	else
		GameTooltip:SetHyperlink(TSMAPI_FOUR.Item.GetLink(link))
	end
end

--- Sets the WoW item ref frame to the specified link.
-- @tparam string link The itemLink to show the item ref frame for
-- @within WoW Util
function TSMAPI_FOUR.Util.SafeItemRef(link)
	if type(link) ~= "string" then return end
	-- extract the Blizzard itemString for both items and pets
	local blizzItemString = strmatch(link, "^\124c[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]\124H(item:[^\124]+)\124.+$")
	blizzItemString = blizzItemString or strmatch(link, "^\124c[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]\124H(battlepet:[^\124]+)\124.+$")
	if blizzItemString then
		SetItemRef(blizzItemString, link)
	end
end

--- Checks if the version of an addon is a dev version.
-- @tparam string name The name of the addon
-- @treturn boolean Whether or not the addon is a dev version
-- @within WoW Util
function TSMAPI_FOUR.Util.IsDevVersion(addonName)
	-- use strmatch does this string doesn't itself get replaced when we deploy
	return strmatch(GetAddOnMetadata(addonName, "version"), "^@tsm%-project%-version@$") and true or false
end

--- Checks if an addon is installed.
-- This function only checks if the addon is installed, not if it's enabled.
-- @tparam string name The name of the addon
-- @treturn boolean Whether or not the addon is installed
-- @within WoW Util
function TSMAPI_FOUR.Util.IsAddonInstalled(name)
	return select(2, GetAddOnInfo(name)) and true or false
end

--- Checks if an addon is currently enabled.
-- @tparam string name The name of the addon
-- @treturn boolean Whether or not the addon is enabled
-- @within WoW Util
function TSMAPI_FOUR.Util.IsAddonEnabled(name)
	return GetAddOnEnableState(UnitName("player"), name) == 2 and select(4, GetAddOnInfo(name)) and true or false
end

--- Registers a function which is called when an item is linked.
-- @tparam function callback The function to be called
-- @within WoW Util
function TSMAPI_FOUR.Util.RegisterItemLinkedCallback(callback)
	tinsert(private.itemLinkedCallbacks, callback)
end

--- Gets the current time in milliseconds since epoch
-- @treturn number The current time in milliseconds since epoch
-- @within WoW Util
function TSMAPI_FOUR.Util.GetTimeMilliseconds()
	return time() * 1000 + (GetTime() * 1000) % 1000
end



-- ============================================================================
-- TSMAPI Functions - Misc.
-- ============================================================================

--- Returns whether not the value exists within the vararg.
-- @param value The value to search for
-- @param ... Any number of values to search in
-- @treturn boolean Whether or not the value was found in the vararg
-- @within Misc
function TSMAPI_FOUR.Util.In(value, ...)
	for i = 1, select("#", ...) do
		if value == select(i, ...) then
			return true
		end
	end
	return false
end

--- Gets debug stack info.
-- @tparam number targetLevel The stack level to get info for
-- @tparam[opt] thread thread The thread to get info for
-- @treturn string The stack frame info (file and line number) or `nil`
-- @within Misc
function TSMAPI_FOUR.Util.GetDebugStackInfo(targetLevel, thread)
	targetLevel = targetLevel + 1
	assert(targetLevel > 0)
	for level = 1, 100 do
		local stackLine = nil
		if thread then
			stackLine = debugstack(thread, level, 1, 0)
		else
			stackLine = debugstack(level, 1, 0)
		end
		if not stackLine then
			return
		end
		stackLine = strmatch(stackLine, "^%.*([^:]+:%d+):")
		-- ignore the class code's wrapper function
		if stackLine and not strmatch(stackLine, "Class%.lua:193") then
			targetLevel = targetLevel - 1
			if targetLevel == 0 then
				stackLine = gsub(stackLine, "/", "\\")
				stackLine = gsub(stackLine, ".-lMaster\\", "TSM\\")
				return stackLine
			end
		end
	end
end

--- Gets debug information about a given stack level.
-- @tparam number level The stack level to get info for
-- @tparam[opt] thread thread The thread to get info for
-- @tparam[opt] string prevStackFunc The previous level's function
-- @treturn string File path or `nil`
-- @treturn number Line number or `nil`
-- @treturn string Function name or `nil`
-- @treturn string New value of the previous level's function name `nil`
-- @within Misc
function TSMAPI_FOUR.Util.GetStackLevelInfo(level, thread, prevStackFunc)
	local stackLine = nil
	if thread then
		stackLine = debugstack(thread, level, 1, 0)
	else
		level = level + 1
		stackLine = debugstack(level, 1, 0)
	end
	local locals = debuglocals(level)
	stackLine = gsub(stackLine, "%.%.%.T?r?a?d?e?S?k?i?l?lM?a?ster([_A-Za-z]*)\\", "TradeSkillMaster%1\\")
	stackLine = gsub(stackLine, "%.%.%.", "")
	stackLine = gsub(stackLine, "`", "<", 1)
	stackLine = gsub(stackLine, "'", ">", 1)
	stackLine = strtrim(stackLine)
	if stackLine == "" then
		return
	end

	-- Parse out the file, line, and function name
	local locationStr, functionStr = strmatch(stackLine, "^(.-): in function (<[^\n]*>)")
	if not locationStr then
		locationStr, functionStr = strmatch(stackLine, "^(.-): in (main chunk)")
	end
	if not locationStr then
		return
	end
	locationStr = strsub(locationStr, strfind(locationStr, "TradeSkillMaster") or 1)
	locationStr = gsub(locationStr, "TradeSkillMaster([^%.])", "TSM%1")
	functionStr = functionStr and gsub(gsub(functionStr, ".*\\", ""), "[<>]", "") or ""
	local file, line = strmatch(locationStr, "^(.+):(%d+)$")
	file = file or locationStr
	line = tonumber(line) or 0

	local func = strsub(functionStr, strfind(functionStr, "`") and 2 or 1, -1) or "?"
	func = func ~= "" and func or "?"

	if strfind(locationStr, "Class%.lua:193") then
		-- ignore stack frames from the class code's wrapper function
		if func ~= "?" and prevStackFunc and not strmatch(func, "^.+:[0-9]+$") and strmatch(prevStackFunc, "^.+:[0-9]+$") then
			-- this stack frame includes the class method we were accessing in the previous one, so go back and fix it up
			local className = locals and strmatch(locals, "\n +str = \"([A-Za-z_0-9]+):[0-9A-F]+\"\n") or "?"
			prevStackFunc = className.."."..func
		end
		return nil, nil, nil, nil, prevStackFunc
	end

	-- add locals for addon functions (debuglocals() doesn't always work - or ever for threads)
	local localsStr = locals and private.ParseLocals(locals, file) or ""
	return file, line, func, localsStr, nil
end

--- Combines a container and slot into a slotId.
-- @tparam number container The container
-- @tparam number slot The slot
-- @treturn number The slotId
-- @within Misc
function TSMAPI_FOUR.Util.JoinSlotId(container, slot)
	return container * SLOT_ID_MULTIPLIER + slot
end

--- Splits a slotId into a container and slot
-- @tparam number The slotId
-- @treturn number container The container
-- @treturn number slot The slot
-- @within Misc
function TSMAPI_FOUR.Util.SplitSlotId(slotId)
	local container = floor(slotId / SLOT_ID_MULTIPLIER)
	local slot = slotId % SLOT_ID_MULTIPLIER
	return container, slot
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.TableKeyIterator(tbl, prevKey)
	local key = next(tbl, prevKey)
	return key
end

function private.TableIterator(iterContext)
	iterContext.index = iterContext.index + 1
	if iterContext.index > #iterContext.data then
		local data = iterContext.data
		local cleanupFunc = iterContext.cleanupFunc
		TSMAPI_FOUR.Util.ReleaseTempTable(iterContext)
		if cleanupFunc then
			cleanupFunc(data)
		end
		return
	end
	if iterContext.helperFunc then
		local result = TSMAPI_FOUR.Util.AcquireTempTable(iterContext.helperFunc(iterContext.index, iterContext.data[iterContext.index], iterContext.arg))
		if #result == 0 then
			TSMAPI_FOUR.Util.ReleaseTempTable(result)
			return private.TableIterator(iterContext)
		end
		return TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(result)
	else
		return iterContext.index, iterContext.data[iterContext.index]
	end
end

function private.TempTableReleaseHelper(tbl, ...)
	assert(private.tempTableState[tbl])
	wipe(tbl)
	tinsert(private.freeTempTables, tbl)
	private.tempTableState[tbl] = nil
	setmetatable(tbl, RELEASED_TEMP_TABLE_MT)
	return ...
end

function private.TableSortWithContextHelper(a, b)
	return private.sortComparator(a, b, unpack(private.sortContext))
end

function private.TableSortWithValueLookupHelper(a, b)
	return private.sortValueLookup[a] < private.sortValueLookup[b]
end

function private.HandleItemLinked(name, itemLink)
	for _, callback in ipairs(private.itemLinkedCallbacks) do
		if callback(name, itemLink) then
			return true
		end
	end
end

function private.ParseLocals(locals, file)
	if strmatch(file, "^%[") then
		return
	end

	local fileName = strmatch(file, "([A-Za-z]+)%.lua")
	local isBlizzardFile = strmatch(file, "Interface\\FrameXML\\")
	local isPrivateTable, isLocaleTable, isPackageTable, isSelfTable = false, false, false, false
	wipe(private.localLinesTemp)
	locals = gsub(locals, "<([a-z]+)> {[\n\t ]+}", "<%1> {}")
	locals = gsub(locals, " = <function> defined @", "@")
	locals = gsub(locals, "<table> {", "{")

	for localLine in gmatch(locals, "[^\n]+") do
		local shouldIgnoreLine = false
		if strmatch(localLine, "^ *%(") then
			shouldIgnoreLine = true
		elseif strmatch(localLine, "Class%.lua:182") then
			-- ignore class methods
			shouldIgnoreLine = true
		elseif strmatch(localLine, "<unnamed> {}$") then
			-- ignore internal WoW frame members
			shouldIgnoreLine = true
		end
		if not shouldIgnoreLine then
			local level = #strmatch(localLine, "^ *")
			localLine = strrep("  ", level)..strtrim(localLine)
			localLine = gsub(localLine, "Interface\\[aA]dd[Oo]ns\\TradeSkillMaster", "TSM")
			localLine = gsub(localLine, "\124", "\\124")
			if level > 0 then
				if isBlizzardFile then
					-- for Blizzard stack frames, only include level 0 locals
					shouldIgnoreLine = true
				elseif isPrivateTable and strmatch(localLine, "^ *[A-Z].+@TSM") then
					-- ignore functions within the private table
					shouldIgnoreLine = true
				elseif isLocaleTable then
					-- ignore everything within the locale table
					shouldIgnoreLine = true
				elseif isPackageTable then
					-- ignore the package table completely
					shouldIgnoreLine = true
				elseif (isSelfTable or isPrivateTable) and strmatch(localLine, "^ *[_a-zA-Z0-9]+ = {}") then
					-- ignore empty tables within objects or the private table
					shouldIgnoreLine = true
				end
			end
			if not shouldIgnoreLine then
				tinsert(private.localLinesTemp, localLine)
			end
			if level == 0 then
				isPackageTable = strmatch(localLine, "%s*"..fileName.." = {") and true or false
				isPrivateTable = strmatch(localLine, "%s*private = {") and true or false
				isLocaleTable = strmatch(localLine, "%s*L = {") and true or false
				isSelfTable = strmatch(localLine, "%s*self = {") and true or false
			end
		end
	end

	return #private.localLinesTemp > 0 and table.concat(private.localLinesTemp, "\n") or nil
end
