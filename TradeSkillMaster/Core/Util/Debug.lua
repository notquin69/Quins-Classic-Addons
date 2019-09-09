-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Debug TSMAPI_FOUR Functions
-- @module Debug

TSMAPI_FOUR.Debug = {}
local private = {
	functionSymbols = {},
	userdataSymbols = {},
	uCache = {},
	fCache = {},
	tCache = {},
	profilingContext = {
		startTime = nil,
		nodes = {},
		nodeRuns = {},
		nodeStart = {},
		nodeTotal = {},
		nodeMaxContext = {},
		nodeMaxTime = {},
	},
}

do
	-- populate private tables with globals
	for k, v in pairs(getfenv(0)) do
		if type(v) == "function" then
			tinsert(private.functionSymbols, k)
		elseif type(v) == "table" then
			if type(rawget(v,0)) == "userdata" then
				tinsert(private.userdataSymbols, k)
			end
		end
	end
end



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

--- Dumps the contents of a table.
-- @tparam string tbl The table to be dumped
-- @tparam[opt=false] boolean returnResult Return the result as a string rather than printing to chat
-- @within General
function TSMAPI_FOUR.Debug.DumpTable(tbl, returnResult)
	if returnResult then
		local result = {}
		private.Dump(tbl, result)
		return result
	else
		private.Dump(tbl)
	end
end

function TSMAPI_FOUR.Debug.GetUIPath(element)
	local path = {}
	local e = element
	while e do
		tinsert(path, 1, e._id)
		e = e:GetElement("__parent")
	end
	return table.concat(path, ":")
end

function TSMAPI_FOUR.Debug.TreeTraversal(from, to)
	local startPaths = TSMAPI_FOUR.Util.SafeStrSplit(from, ":")
	local destinationPaths = TSMAPI_FOUR.Util.SafeStrSplit(to, ":")
	while(startPaths[1] == destinationPaths[1]) do
		table.remove(startPaths, 1)
		table.remove(destinationPaths, 1)
	end

	local result = {}
	for _ = 1, #startPaths do
		tinsert(result, "__parent")
	end
	for i = 1, #destinationPaths do
		tinsert(result, destinationPaths[i])
	end
	return strjoin(":", unpack(result))
end

function TSMAPI_FOUR.Debug.SearchUIUp(element, pathFragment, limit)
	print("searching from")
	print(TSMAPI_FOUR.Debug.GetUIPath(element))
	print("Trying "..pathFragment)
	limit = limit or 20
	limit = limit - 1
	if limit > 0 then
		local path = "__parent."..pathFragment
		local result = pcall(element.GetElement, element, path)
		if result then
			print("The path to "..pathFragment)
			print(path)
			--local sourcePath = TSMAPI_FOUR.Debug.GetUIPath(element)
			--local destinationPath = TSMAPI_FOUR.Debug.GetUIPath(element:GetElement(path))
			--local short_path = TSMAPI_FOUR.Debug.TreeTaversal(sourcePath, destinationPath)
			--print("Which has a shortest relative path of ")
			--print(short_path)
			return path
		end
		return TSMAPI_FOUR.Debug.SearchUIUp(element, path, limit)
	end
end

--- Starts profiling.
-- @within Profiling
function TSMAPI_FOUR.Debug.StartProfiling()
	assert(not private.profilingContext.startTime)
	private.profilingContext.startTime = debugprofilestop()
end

--- Starts profiling of a node.
-- Profiling must have been started for this to have any effect.
-- @tparam string node The name of the profiling node
-- @within Profiling
function TSMAPI_FOUR.Debug.StartProfilingNode(node)
	if not private.profilingContext.startTime then
		-- profiling is not running
		return
	end
	assert(not private.profilingContext.nodeStart[node])
	if not private.profilingContext.nodeTotal[node] then
		tinsert(private.profilingContext.nodes, node)
		private.profilingContext.nodeTotal[node] = 0
		private.profilingContext.nodeRuns[node] = 0
		private.profilingContext.nodeMaxContext[node] = nil
		private.profilingContext.nodeMaxTime[node] = 0
	end
	private.profilingContext.nodeStart[node] = debugprofilestop()
end

--- Ends profiling of a node.
-- Profiling of this node must have been started for this to have any effect.
-- @tparam string node The name of the profiling node
-- @within Profiling
function TSMAPI_FOUR.Debug.EndProfilingNode(node, arg)
	if not private.profilingContext.startTime or not private.profilingContext.nodeStart[node] then
		-- profiling is not running
		return
	end
	local nodeTime = debugprofilestop() - private.profilingContext.nodeStart[node]
	private.profilingContext.nodeRuns[node] = private.profilingContext.nodeRuns[node] + 1
	private.profilingContext.nodeTotal[node] = private.profilingContext.nodeTotal[node] + nodeTime
	private.profilingContext.nodeStart[node] = nil
	if nodeTime > private.profilingContext.nodeMaxTime[node] then
		private.profilingContext.nodeMaxContext[node] = arg
		private.profilingContext.nodeMaxTime[node] = nodeTime
	end
end

--- Ends profiling and prints the results to chat.
-- @within Profiling
function TSMAPI_FOUR.Debug.EndProfiling()
	if not private.profilingContext.startTime then
		-- profiling is not running
		return
	end
	local totalTime = debugprofilestop() - private.profilingContext.startTime
	print(format("Total: %.03f", TSMAPI_FOUR.Util.Round(totalTime, 0.001)))
	for _, node in ipairs(private.profilingContext.nodes) do
		local nodeTotalTime = TSMAPI_FOUR.Util.Round(private.profilingContext.nodeTotal[node], 0.001)
		local nodeRuns = private.profilingContext.nodeRuns[node]
		local nodeMaxContext = private.profilingContext.nodeMaxContext[node]
		if nodeMaxContext ~= nil then
			local nodeMaxTime = private.profilingContext.nodeMaxTime[node]
			print(format("  %s: %.03f (%d) | Max %.03f (%s)", node, nodeTotalTime, nodeRuns, nodeMaxTime, tostring(nodeMaxContext)))
		else
			print(format("  %s: %.03f (%d)", node, nodeTotalTime, nodeRuns))
		end
	end
	private.profilingContext.startTime = nil
	wipe(private.profilingContext.nodes)
	wipe(private.profilingContext.nodeRuns)
	wipe(private.profilingContext.nodeStart)
	wipe(private.profilingContext.nodeTotal)
	wipe(private.profilingContext.nodeMaxContext)
	wipe(private.profilingContext.nodeMaxTime)
end

--- Checks whether or not we're currently profiling.
-- @treturn boolean Whether or not we're currently profiling.
-- @within Profiling
function TSMAPI_FOUR.Debug.IsProfiling()
	return private.profilingContext.startTime and true or false
end



-- ============================================================================
-- Local copy of Blizzard's /dump command with some added features
-- ============================================================================

function private.CacheFunction(value, newName)
	if not next(private.fCache) then
		for _, k in ipairs(private.functionSymbols) do
			local v = getglobal(k)
			if type(v) == "function" then
				private.fCache[v] = "["..k.."]"
			end
		end
		for k, v in pairs(getfenv(0)) do
			if type(v) == "function" then
				if not private.fCache[v] then
					private.fCache[v] = "["..k.."]"
				end
			end
		end
	end
	local name = private.fCache[value]
	if not name and newName then
		private.fCache[value] = newName
	end
	return name
end

function private.CacheUserdata(value, newName)
	if not next(private.uCache) then
		for _, k in ipairs(private.userdataSymbols) do
			local v = getglobal(k)
			if type(v) == "table" then
				local u = rawget(v,0)
				if type(u) == "userdata" then
					private.uCache[u] = k.."[0]"
				end
			end
		end
		for k, v in pairs(getfenv(0)) do
			if type(v) == "table" then
				local u = rawget(v, 0)
				if type(u) == "userdata" then
					if not private.uCache[u] then
						private.uCache[u] = k.."[0]"
					end
				end
			end
		end
	end
	local name = private.uCache[value]
	if not name and newName then
		private.uCache[value] = newName
	end
	return name
end

function private.CacheTable(value, newName)
	local name = private.tCache[value]
	if not name and newName then
		private.tCache[value] = newName
	end
	return name
end

function private.Write(msg)
	if private.result then
		tinsert(private.result, msg)
	else
		print(msg)
	end
end

function private.PrepSimple(val)
	local valType = type(val)
	if valType == "nil" then
		return "nil"
	elseif valType == "number" then
		return val
	elseif valType == "boolean" then
		return val and "true" or "false"
	elseif valType == "string" then
		local len = #val
		if len > 200 then
			local more = len - 200
			val = strsub(val, 1, 200)
			return gsub(format("%q...+%s", val, more), "[|]", "||")
		else
			return gsub(format("%q", val), "[|]", "||")
		end
	elseif valType == "function" then
		local fName = private.CacheFunction(val)
		return fName and format("<%s %s>", valType, fName) or format("<%s>", valType)
	elseif valType == "userdata" then
		local uName = private.CacheUserdata(val)
		return uName and format("<%s %s>", valType, uName) or format("<%s>", valType)
	elseif valType == "table" then
		local tName = private.CacheTable(val)
		return tName and format("<%s %s>", valType, tName) or format("<%s>", valType)
	else
		error("Bad type '"..valType.."' to private.PrepSimple")
	end
end

function private.PrepSimpleKey(val)
	if type(val) == "string" and #val <= 200 and strmatch(val, "^[a-zA-Z_][a-zA-Z0-9_]*$") then
		return val
	end
	return format("[%s]", private.PrepSimple(val))
end

function private.DumpTableContents(val, prefix, firstPrefix, key)
	local showCount = 0
	local oldDepth = private.depth
	local oldKey = key

	-- Use this to set the cache name
	private.CacheTable(val, oldKey or "value")

	local iter = pairs(val)
	local nextK, nextV = iter(val, nil)

	while nextK do
		local k,v = nextK, nextV
		nextK, nextV = iter(val, k)
		showCount = showCount + 1
		if showCount <= 30 then
			local prepKey = private.PrepSimpleKey(k)
			if oldKey == nil then
				key = prepKey
			elseif strsub(prepKey, 1, 1) == "[" then
				key = oldKey..prepKey
			else
				key = oldKey.."."..prepKey
			end
			private.depth = oldDepth + 1

			local rp = format("|cff88ccff%s%s|r=", firstPrefix, prepKey)
			firstPrefix = prefix
			private.DumpValue(v, prefix, rp, (nextK and ",") or "", key)
		end
	end
	local cutoff = showCount - 30
	if cutoff > 0 then
		private.Write(format("%s|cffff0000<skipped %s>|r", firstPrefix, cutoff))
	end
	private.depth = oldDepth
end

-- Return the specified value
function private.DumpValue(val, prefix, firstPrefix, suffix, key)
	local valType = type(val)

	if valType == "userdata" then
		local uName = private.CacheUserdata(val, "value")
		if uName then
			private.Write(format("%s|cff88ff88<%s %s>|r%s", firstPrefix, valType, uName, suffix))
		else
			private.Write(format("%s|cff88ff88<%s>|r%s", firstPrefix, valType, suffix))
		end
		return
	elseif valType == "function" then
		local fName = private.CacheFunction(val, "value")
		if fName then
			private.Write(format("%s|cff88ff88<%s %s>|r%s", firstPrefix, valType, fName, suffix))
		else
			private.Write(format("%s|cff88ff88<%s>|r%s", firstPrefix, valType, suffix))
		end
		return
	elseif valType ~= "table" then
		private.Write(format("%s%s%s", firstPrefix, private.PrepSimple(val), suffix))
		return
	end

	local cacheName = private.CacheTable(val)
	if cacheName then
		private.Write(format("%s|cffffcc00%s|r%s", firstPrefix, cacheName, suffix))
		return
	end

	if private.depth >= 10 then
		private.Write(format("%s|cffff0000<table (too deep)>|r%s", firstPrefix, suffix))
		return
	end

	local oldPrefix = prefix
	prefix = prefix.."  "
	private.Write(firstPrefix.."{")
	private.DumpTableContents(val, prefix, prefix, key)
	private.Write(oldPrefix.."}"..suffix)
end

-- Dump the specified list of value
function private.Dump(value, result)
	private.depth = 0
	private.result = result
	wipe(private.uCache)
	wipe(private.fCache)
	wipe(private.tCache)

	if type(value) == "table" and not next(value) then
		private.Write("empty result")
		return
	end

	private.DumpValue(value, "", "", "")
end
