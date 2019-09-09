-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Analytics = TSM:NewPackage("Analytics")
local private = {
	events = {},
	lastEventTime = nil,
	argsTemp = {},
	session = time(),
	sequenceNumber = 1,
}
local MAX_ANALYTICS_AGE = 14 * 24 * 60 * 60 -- 2 weeks
local HIT_TYPE_IS_VALID = {
	AC = true,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Analytics.Action(name, ...)
	private.InsertHit("AC", name, ...)
end

function Analytics.Save(appDB)
	appDB.analytics = appDB.analytics or {updateTime=0, data={}}
	if private.lastEventTime then
		appDB.analytics.updateTime = private.lastEventTime
	end
	-- remove any events which are too old
	for i = #appDB.analytics.data, 1, -1 do
		local _, _, timeStr = strsplit(",", appDB.analytics.data[i])
		local eventTime = timeStr and (tonumber(timeStr) / 1000) or 0
		if eventTime < time() - MAX_ANALYTICS_AGE then
			tremove(appDB.analytics.data, i)
		end
	end
	for _, event in ipairs(private.events) do
		tinsert(appDB.analytics.data, event)
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.InsertHit(hitType, ...)
	assert(HIT_TYPE_IS_VALID[hitType])
	wipe(private.argsTemp)
	for i = 1, select("#", ...) do
		local arg = select(i, ...)
		local argType = type(arg)
		if argType == "string" then
			-- remove non-printable and non-ascii characters
			arg = gsub(arg, "[^ -~]", "")
			-- remove characters we don't want in the JSON
			arg = gsub(arg, "[\\\"]", "")
			arg = private.AddQuotes(arg)
		elseif argType == "number" then
			-- pass
		elseif argType == "boolean" then
			arg = tostring(arg)
		else
			error("Invalid arg type: "..argType)
		end
		tinsert(private.argsTemp, arg)
	end
	TSM:LOG_INFO("%s %s", hitType, strjoin(" ", tostringall(...)))
	hitType = private.AddQuotes(hitType)
	local version = private.AddQuotes(TSM:GetVersion() or "???")
	local timeMs = TSMAPI_FOUR.Util.GetTimeMilliseconds()
	local jsonStr = strjoin(",", hitType, version, timeMs, private.session, private.sequenceNumber, unpack(private.argsTemp))
	tinsert(private.events, "["..jsonStr.."]")
	private.sequenceNumber = private.sequenceNumber + 1
	private.lastEventTime = time()
end

function private.AddQuotes(str)
	return "\""..str.."\""
end
