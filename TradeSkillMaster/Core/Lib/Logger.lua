-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
TSMAPI_FOUR.Logger = {}
local LOG_BUFFER_SIZE = 200
local private = { startDebugTime = debugprofilestop(), startTime = time(), temp = {}, loggers = {} }
local DEBUG_COLORS = {
	STACK = "|cff0000ff",
	INFO = "|cff00ff00",
	WARN = "|cffffff00",
	ERR = "|cffff0000",
}



-- ============================================================================
-- Logger Class
-- ============================================================================

local Logger = TSMAPI_FOUR.Class.DefineClass("Logger")

function Logger.__init(self)
	self._buffer = {}
	self._max = LOG_BUFFER_SIZE
	self._len = 0
	self._cursor = 1
end

function Logger.GetLength(self)
	return self._len
end

function Logger.Append(self, entry)
	self._buffer[self._cursor] = entry
	self._cursor = (self._cursor < self._max) and (self._cursor + 1) or 1
	self._len = min(self._len + 1, self._max)
end

function Logger.Get(self, index)
	local c = self._cursor - self._len + index - 1
	if c < 1 then
		c = c + self._max
	end
	return self._buffer[c]
end

function Logger.Iterator(self)
	return private.IteratorFunc, self, 0
end

function Logger.LogMessage(self, severity, ...)
	wipe(private.temp)
	for i = 1, select("#", ...) do
		local arg = select(i, ...)
		if type(arg) == "boolean" then
			arg = arg and "T" or "F"
		elseif type(arg) ~= "string" and type(arg) ~= "number" then
			arg = tostring(arg)
		end
		private.temp[i] = arg
	end
	local file, line = strmatch(TSMAPI_FOUR.Util.GetDebugStackInfo(3) or "", "([^\\/]+%.lua):([0-9]+)")
	file = file or "?"
	line = line or "?"
	local timestamp = (debugprofilestop() - private.startDebugTime) / 1000 + private.startTime
	local msg = format(unpack(private.temp))
	local timestampStr = format("%s.%03d", date("%H:%M:%S", floor(timestamp)), floor((timestamp % 1) * 1000))
	self:Append({
		severity = severity,
		file = file,
		line = line,
		timestamp = timestamp,
		timestampStr = timestampStr,
		msg = msg
	})

	if TSM.db and TSM.db.global.debug.chatLoggingEnabled then
		local threadName = TSMAPI_FOUR.Thread.GetCurrentThreadName()
		if threadName then
			print(format("%s %s{%s:%s|%s}|r %s", timestampStr, DEBUG_COLORS[severity], file, line, threadName, msg))
		else
			print(format("%s %s{%s:%s}|r %s", timestampStr, DEBUG_COLORS[severity], file, line, msg))
		end
	end
end



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

function TSMAPI_FOUR.Logger.New(name)
	if name == "TradeSkillMaster" then
		name = "TSM (Core)"
	end
	-- the logger might be already created when going from TSM3 -> TSM4, so just return
	if private.loggers[name] then
		return private.loggers[name]
	end
	private.loggers[name] = Logger()
	return private.loggers[name]
end

function TSMAPI_FOUR.Logger.GetRecentLogEntries(numEntries, maxLineLength)
	local entries = {}
	for _, buffer in pairs(private.loggers) do
		for _, logInfo in buffer:Iterator() do
			if logInfo.timestamp >= private.startTime then
				tinsert(entries, logInfo)
			end
		end
	end
	sort(entries, private.SortFunc)
	local result = {}
	for i = 1, min(#entries, numEntries) do
		local msg = ("\n"):split(entries[i].msg)
		if #msg > maxLineLength then
			msg = strsub(msg, 1, maxLineLength - 3).."..."
		end
		tinsert(result, format("%s [%s:%d] %s", entries[i].timestampStr, entries[i].severity, entries[i].line, msg))
	end
	return result
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.IteratorFunc(buffer, index)
	index = index + 1
	if index <= buffer:GetLength() then
		return index, buffer:Get(index)
	else
		return nil
	end
end

function private.SortFunc(a, b)
	return a.timestamp > b.timestamp
end
