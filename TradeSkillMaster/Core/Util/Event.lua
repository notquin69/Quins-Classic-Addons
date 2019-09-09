-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Event TSMAPI_FOUR Functions
-- @module Event

TSMAPI_FOUR.Event = {}
local _, TSM = ...
local private = {
	eventCallbacks = {},
	eventFrame = nil,
	temp = {},
	eventQueue = {},
	processingEvent = false,
}
local CALLBACK_TIME_WARNING_THRESHOLD_MS = 20



-- ============================================================================
-- Event Frame
-- ============================================================================

function private.ProcessEvent(event, ...)
	-- NOTE: the registered events may change within the callback, so copy them to a temp table
	wipe(private.temp)
	for i, callback in ipairs(private.eventCallbacks[event]) do
		private.temp[i] = callback
	end
	for _, callback in ipairs(private.temp) do
		local startTime = debugprofilestop()
		callback(event, ...)
		local timeTaken = debugprofilestop() - startTime
		if timeTaken > CALLBACK_TIME_WARNING_THRESHOLD_MS then
			TSM:LOG_WARN("Event (%s) callback took %.2fms", event, timeTaken)
		end
	end
end

function private.EventHandler(_, event, ...)
	if private.processingEvent then
		-- we are already in the middle of processing another event, so queue this one up
		tinsert(private.eventQueue, TSMAPI_FOUR.Util.AcquireTempTable(event, ...))
		assert(#private.eventQueue < 50)
		return
	end
	private.processingEvent = true
	private.ProcessEvent(event, ...)
	-- process queued events
	while #private.eventQueue > 0 do
		local tbl = tremove(private.eventQueue, 1)
		private.ProcessEvent(TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(tbl))
	end
	private.processingEvent = false
end

private.eventFrame = CreateFrame("Frame")
private.eventFrame:SetScript("OnEvent", private.EventHandler)
private.eventFrame:Show()



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

--- Registers an event callback.
-- @tparam string event The WoW event to register for (i.e. BAG_UPDATE)
-- @tparam function callback The function to be called from the event handler
function TSMAPI_FOUR.Event.Register(event, callback)
	private.eventFrame:RegisterEvent(event)
	private.eventCallbacks[event] = private.eventCallbacks[event] or {}
	tinsert(private.eventCallbacks[event], callback)
end

--- Unregisters an event callback.
-- @tparam string event The WoW event which the callback was registered for
-- @tparam function callback The function which was passed to @{TSMAPI_FOUR.Event.Register} for this event
function TSMAPI_FOUR.Event.Unregister(event, callback)
	assert(private.eventCallbacks[event])
	local index = nil
	for i = 1, #private.eventCallbacks[event] do
		if private.eventCallbacks[event][i] == callback then
			index = i
			break
		end
	end
	assert(index)
	tremove(private.eventCallbacks[event], index)
	if #private.eventCallbacks[event] == 0 then
		private.eventFrame:UnregisterEvent(event)
	end
end
