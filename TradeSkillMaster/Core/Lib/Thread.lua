-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Thread TSMAPI_FOUR Functions
-- @module Thread

local _, TSM = ...
TSMAPI_FOUR.Thread = {}
local private = {
	threads = {},
	queue = {},
	runningThread = nil,
	schedulerFrame = nil,
}
local MAX_TIME_USAGE_RATIO = 0.25
local EXCESSIVE_TIME_USED_RATIO = 1.2
local EXCESSIVE_TIME_LOG_THRESHOLD_MS = 100
local MAX_QUANTUM_MS = 10
local SEND_MSG_SYNC_TIMEOUT_MS = 3000
local YIELD_VALUE_START = {}
local YIELD_VALUE = {}
local SCHEDULER_TIME_WARNING_THRESHOLD_MS = 100
local Thread = TSMAPI_FOUR.Class.DefineClass("Thread")



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

--- Create a new thread.
-- @tparam string name The name of the thread (for debugging purposes)
-- @tparam function func The thread's main function
-- @treturn string The thread id
function TSMAPI_FOUR.Thread.New(name, func)
	local thread = Thread(name, func, false)
	local threadId = strjoin("-", tostringall(thread, func))
	private.threads[threadId] = thread
	return threadId
end

--- Create a new immortal thread.
-- An immortal thread should never return and will be restarted if it does.
-- @tparam string name The name of the thread (for debugging purposes)
-- @tparam function func The thread's main function
-- @treturn string The thread id
function TSMAPI_FOUR.Thread.NewImmortal(name, func)
	local thread = Thread(name, func, true)
	local threadId = strjoin("-", tostringall(thread, func))
	private.threads[threadId] = thread
	return threadId
end

--- Set the callback for a thread.
-- The callback is called when a thread finishes running and is passed all values returned by the thread's main function.
-- @tparam string threadId The thread id
-- @tparam function callback The callback function
function TSMAPI_FOUR.Thread.SetCallback(threadId, callback)
	private.threads[threadId]:_SetCallback(callback)
end

--- Start a thread.
-- The thread will not actually be run until the next run of the scheduler (next frame).
-- @tparam string threadId The thread id
-- @tparam vararg ... Arguments to pass to the thread's main function
function TSMAPI_FOUR.Thread.Start(threadId, ...)
	local thread = private.threads[threadId]
	assert(not thread:_IsAlive())
	-- make sure the scheduler is running
	private.StartScheduler()
	thread:_Start(...)
end

--- Send a message to a thread.
-- @tparam string threadId The thread id
-- @tparam vararg ... The contents of the message
function TSMAPI_FOUR.Thread.SendMessage(threadId, ...)
	local thread = private.threads[threadId]
	assert(thread:_IsAlive())
	tinsert(thread._messages, TSMAPI_FOUR.Util.AcquireTempTable(...))
end

--- Send a synchronous message to a thread.
-- The current execution context will be blocked until the message is delivered.
-- @tparam string threadId The thread id
-- @tparam vararg ... The contents of the message
function TSMAPI_FOUR.Thread.SendSyncMessage(threadId, ...)
	if TSMAPI_FOUR.Thread.IsThreadContext() then
		-- we can't (sanely) run a thread from within a thread context, so we'll yield from the current thread first
		private.runningThread:_SendSyncMessage(threadId, ...)
	else
		local errMsg = private.threads[threadId]:_HandleSyncMessage(...)
		if errMsg then
			error(errMsg)
		end
	end
end

--- Kill a thread.
-- @tparam string threadId The thread id
function TSMAPI_FOUR.Thread.Kill(threadId)
	local thread = private.threads[threadId]
	if thread:_IsAlive() then
		thread:_Exit()
	end
end

--- Check if we're currently in a thread context.
-- @treturn boolean Whether or not we're currently in a thread context
function TSMAPI_FOUR.Thread.IsThreadContext()
	return private.runningThread ~= nil
end

--- Get the name of the current thread.
-- @treturn ?string The name of the currently-running thread or nil if no thread is running
function TSMAPI_FOUR.Thread.GetCurrentThreadName()
	return private.runningThread and private.runningThread._name or nil
end

--- Check if the current thread has any pending messages.
-- This must be called from a thread context.
-- @treturn boolean Whether or not this thread has any pending messages
function TSMAPI_FOUR.Thread.HasPendingMessage()
	return private.runningThread:_HasPendingMessage()
end

--- Receive the next message.
-- This must be called from a thread context.
-- @return The context of the message
function TSMAPI_FOUR.Thread.ReceiveMessage()
	return private.runningThread:_ReceiveMessage()
end

--- Performs a yield.
-- This must be called from a thread context. This function should be called regularly by threads to allow them the
-- scheduler to switch to another thread if this thread's quantum is up. If this thread has not exceeded its quantum,
-- this function will return right away.
-- @tparam[opt=false] boolean force If true, forces this thread to yield, regardless of whether or not it needs to
function TSMAPI_FOUR.Thread.Yield(force)
	private.runningThread:_Yield(force)
end

--- Sleep the thread.
-- This must be called from a thread context.
-- @tparam number seconds The number of seconds to sleep for (may be a deciaml number)
function TSMAPI_FOUR.Thread.Sleep(seconds)
	private.runningThread:_Sleep(seconds)
end

--- Wait for a WoW event.
-- This must be called from a thread context.
-- @tparam string event The WoW event to wait for
function TSMAPI_FOUR.Thread.WaitForEvent(...)
	return private.runningThread:_WaitForEvent(...)
end

--- Wait for a function.
-- This must be called from a thread context. It will block the thread until the specified function returns a true value.
-- @tparam function func The function to wait for
-- @tparam vararg ... Additional arguments to pass to the function
function TSMAPI_FOUR.Thread.WaitForFunction(func, ...)
	return private.runningThread:_WaitForFunction(func, ...)
end

--- Acquire a temp table.
-- This must be called from a thread context. Any time a thread needs to maintain a temp table across a potential yield,
-- it should use this API. This API will release the temp tables in the case that the thread gets killed.
-- @see Util.AcquireTempTable
-- @tparam vararg ... Values to insert into the temp table
function TSMAPI_FOUR.Thread.AcquireSafeTempTable(...)
	return private.runningThread:_AcquireSafeTempTable(...)
end

--- Release a temp table.
-- This must be called from a thread context. This is used to release temp tables acquired with
-- @{TSMAPI_FOUR.Thread.AcquireSafeTempTable}.
-- @see Util.ReleaseTempTable
-- @tparam table tbl The temp table to release
function TSMAPI_FOUR.Thread.ReleaseSafeTempTable(tbl)
	return private.runningThread:_ReleaseSafeTempTable(tbl)
end

--- Release a temp table and returns its contents.
-- This must be called from a thread context. This is used to release and unpack temp tables acquired with
-- @{TSMAPI_FOUR.Thread.AcquireSafeTempTable}.
-- @see Util.UnpackAndReleaseTempTable
-- @tparam table tbl The temp table to release and unpack
-- @return The contents of the temp table
function TSMAPI_FOUR.Thread.UnpackAndReleaseSafeTempTable(tbl)
	return private.runningThread:_UnpackAndReleaseSafeTempTable(tbl)
end

function TSMAPI_FOUR.Thread.GetDebugInfo()
	local threadInfo = {}
	for _, thread in pairs(private.threads) do
		if thread._startCaller then
			local temp = { backtrace = {} }
			local level = 2
			local line = TSMAPI_FOUR.Util.GetDebugStackInfo(level, thread._co)
			while line do
				tinsert(temp.backtrace, line)
				level = level + 1
				line = TSMAPI_FOUR.Util.GetDebugStackInfo(level, thread._co)
			end
			temp.state = thread._state
			temp.sleepTime = thread._sleepTime
			temp.numMessages = (#thread._messages > 0) and #thread._messages or nil
			temp.eventNames = thread._eventNames
			temp.eventArgs = thread._eventArgs
			temp.waitFunction = thread._waitFunction
			temp.waitFunctionArgs = thread._waitFunctionArgs
			temp.waitFunctionResult = thread._waitFunctionResult
			temp.syncMessageDest = thread._syncMessageDest and private.threads[thread._syncMessageDest]._name or nil
			temp.isImmortal = thread._isImmortal
			temp.createCaller = thread._createCaller
			temp.startCaller = thread._startCaller
			if thread._startTime then
				temp.realTimeUsed = debugprofilestop() - thread._startTime
				temp.cpuTimeUsed = thread._cpuTimeUsed
				temp.cpuPct = format("%.1f%%", TSMAPI_FOUR.Util.Round(thread._cpuTimeUsed / temp.realTimeUsed, 0.001) * 100)
			end
			local key = thread._name
			while threadInfo[key] do
				key = key.."#"..random(1, 100000)
			end
			threadInfo[key] = temp
		end
	end
	return TSMAPI_FOUR.Debug.DumpTable(threadInfo, true)
end



-- ============================================================================
-- Thread Class - General Methods
-- ============================================================================

function Thread.__init(self, name, func, isImmortal)
	-- core fields
	self._isImmortal = isImmortal
	self._func = func
	self._co = nil
	self._state = "DEAD"
	self._endTime = nil
	self._sleepTime = nil
	self._eventNames = {}
	self._eventArgs = nil
	self._waitFunction = nil
	self._waitFunctionArgs = nil
	self._waitFunctionResult = nil
	self._syncMessage = nil
	self._syncMessageDest = nil
	self._messages = {}
	self._callback = nil
	self._returnValue = nil
	self._safeTempTables = {}

	-- debug fields
	self._startTime = 0
	self._cpuTimeUsed = 0
	self._realTimeUsed = 0
	self._name = name
	self._createCaller = TSMAPI_FOUR.Util.GetDebugStackInfo(4)
	self._startCaller = nil
end

function Thread._Start(self, ...)
	self._co = coroutine.create(self._Main)
	self._state = "READY"
	self._endTime = 0
	self._sleepTime = nil
	wipe(self._eventNames)
	self._eventArgs = nil
	self._waitFunction = nil
	self._waitFunctionArgs = nil
	self._waitFunctionResult = nil
	self._syncMessage = nil
	self._syncMessageDest = nil
	assert(not next(self._messages))
	assert(not next(self._safeTempTables))
	self._startTime = 0
	self._cpuTimeUsed = 0
	self._realTimeUsed = 0
	self._startCaller = self._startCaller or TSMAPI_FOUR.Util.GetDebugStackInfo(3)

	-- run the thread once (will yield right away) to pass in self and the arguments
	local noErr, retValue = coroutine.resume(self._co, self, ...)
	assert(noErr and retValue == YIELD_VALUE_START)
end

function Thread._SetCallback(self, callback)
	assert(not self._isImmortal)
	self._callback = callback
end

function Thread._IsAlive(self)
	return self._state ~= "DEAD"
end

function Thread._ToLogStr(self)
	if self._startTime then
		self._realTimeUsed = debugprofilestop() - self._startTime
		local pctStr = format("%.1f%%", TSMAPI_FOUR.Util.Round(self._cpuTimeUsed / self._realTimeUsed, 0.001) * 100)
		return format("%s [%s,%s]", self._name, self._state, pctStr)
	else
		return format("%s [%s]", self._name, self._state)
	end
end

function Thread._Cleanup(self)
	for _, msg in ipairs(self._messages) do
		TSMAPI_FOUR.Util.ReleaseTempTable(msg)
	end
	wipe(self._messages)
	for tbl in pairs(self._safeTempTables) do
		TSMAPI_FOUR.Util.ReleaseTempTable(tbl)
	end
	wipe(self._safeTempTables)
	if self._waitFunctionArgs then
		TSMAPI_FOUR.Util.ReleaseTempTable(self._waitFunctionArgs)
		self._waitFunctionArgs = nil
	end
	if self._syncMessage then
		TSMAPI_FOUR.Util.ReleaseTempTable(self._syncMessage)
		self._syncMessage = nil
		self._syncMessageDest = nil
	end
end



-- ============================================================================
-- Thread Class - Scheduler Helper Methods
-- ============================================================================

function Thread._CanRun(self)
	return self._state == "READY"
end

function Thread._Run(self, quantum)
	assert(not TSMAPI_FOUR.Thread.IsThreadContext())
	if not self:_CanRun() then return 0 end
	private.runningThread = self
	self._state = "RUNNING"
	local startTime = debugprofilestop()
	self._endTime = startTime + quantum
	local noErr, returnVal = coroutine.resume(self._co)
	local elapsedTime = debugprofilestop() - startTime
	private.runningThread = nil

	assert(not noErr or returnVal == YIELD_VALUE)
	if noErr and self._state == "SENDING_SYNC_MESSAGE" then
		-- yielded to send a sync message to another thread
		local destThread = private.threads[self._syncMessageDest]
		local msg = self._syncMessage
		self._syncMessage = nil
		self._syncMessageDest = nil
		local errMsg = destThread:_HandleSyncMessage(TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(msg))
		if errMsg then
			noErr = false
			returnVal = errMsg
		elseif self._state == "SENDING_SYNC_MESSAGE" then
			self._state = "READY"
		end
	end
	if not noErr then
		returnVal = returnVal or "UNKNOWN ERROR"
		TSM.ShowError(returnVal, self._co)
		if self._isImmortal then
			-- restart the immortal thread
			TSM:LOG_WARN("Restarting immortal thread: %s", self:_ToLogStr())
			self:_Start()
		else
			self._state = "DEAD"
		end
	end
	if self._state == "DEAD" then
		self:_Cleanup()
		if self._callback and self._returnValue then
			self._callback(TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(self._returnValue))
			self._returnValue = nil
		elseif self._returnValue then
			TSMAPI_FOUR.Util.ReleaseTempTable(self._returnValue)
			self._returnValue = nil
		end
	end
	return elapsedTime
end

function Thread._UpdateState(self, elapsed)
	-- check what the thread state is
	if self._state == "SLEEPING" then
		self._sleepTime = self._sleepTime - elapsed
		if self._sleepTime <= 0 then
			self._sleepTime = nil
			self._state = "READY"
		end
	elseif self._state == "WAITING_FOR_MSG" then
		if #self._messages > 0 then
			self._state = "READY"
		end
	elseif self._state == "WAITING_FOR_EVENT" then
		assert(self._eventNames or self._eventArgs)
		if self._eventArgs then
			self._state = "READY"
		end
	elseif self._state == "WAITING_FOR_FUNCTION" then
		assert(self._waitFunction, "Waiting for function without waitFunction set")
		local result = TSMAPI_FOUR.Util.AcquireTempTable(self._waitFunction(unpack(self._waitFunctionArgs)))
		if result[1] then
			self._waitFunctionResult = result
			self._state = "READY"
		else
			TSMAPI_FOUR.Util.ReleaseTempTable(result)
		end
	elseif self._state == "FORCED_YIELD" then
		self._state = "READY"
	elseif self._state == "RUNNING" then
		-- this shouldn't happen, so just kill this thread
		self:_Exit()
	elseif self._state == "DEAD" then
		-- pass
	elseif self._state == "READY" then
		-- pass
	else
		error("Invalid thread state: "..tostring(self._state))
	end
end

function Thread._ProcessEvent(self, event, ...)
	if self._state == "WAITING_FOR_EVENT" then
		assert(self._eventNames or self._eventArgs)
		if self._eventNames[event] then
			wipe(self._eventNames) -- only trigger the event once then clear all
			self._eventArgs = TSMAPI_FOUR.Util.AcquireTempTable(event, ...)
		end
	end
end

function Thread._HandleSyncMessage(self, ...)
	assert(not TSMAPI_FOUR.Thread.IsThreadContext())
	local msg = TSMAPI_FOUR.Util.AcquireTempTable(...)
	tinsert(self._messages, 1, msg) -- this message should be received first
	-- run the thread for up to 3 seconds to get it to process the sync message
	local startTime = debugprofilestop()
	while self._messages[1] == msg do
		if debugprofilestop() - startTime > SEND_MSG_SYNC_TIMEOUT_MS or not self:_IsAlive() then
			-- want to error from the sending context, so just return the error
			return format("ERROR: A sync message was not able to be delivered! (%s)", tostring(self._name))
		end
		assert(self._state ~= "SENDING_SYNC_MESSAGE", "Circular sync message detected")
		if self._state == "WAITING_FOR_MSG" then
			self._state = "READY"
		end
		self:_Run(0)
	end
end



-- ============================================================================
-- Thread Class - Thread Context Methods
-- ============================================================================

function Thread._Main(self, ...)
	self._startTime = debugprofilestop()
	coroutine.yield(YIELD_VALUE_START)
	self._returnValue = TSMAPI_FOUR.Util.AcquireTempTable(self._func(...))
	self:_Exit()
end

function Thread._Yield(self, force)
	if force or self._state ~= "RUNNING" or debugprofilestop() > self._endTime then
		-- only change the state if it's currently set to RUNNING
		if self._state == "RUNNING" then
			self._state = force and "FORCED_YIELD" or "READY"
		end
		coroutine.yield(YIELD_VALUE)
	end
end

function Thread._Sleep(self, seconds)
	self._state = "SLEEPING"
	self._sleepTime = seconds
	self:_Yield()
end

function Thread._HasPendingMessage(self)
	return #self._messages > 0
end

function Thread._ReceiveMessage(self)
	if #self._messages == 0 then
		-- change the state if there's no messages ready
		self._state = "WAITING_FOR_MSG"
	elseif debugprofilestop() > self._endTime then
		-- If we're about to yield, set the state to WAITING_FOR_MSG even if we have messages in the queue
		-- to allow sync messages to be sent to us.
		self._state = "WAITING_FOR_MSG"
	end
	self:_Yield()
	return TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(tremove(self._messages, 1))
end

function Thread._SendSyncMessage(self, destThread, ...)
	assert(destThread ~= self)
	self._state = "SENDING_SYNC_MESSAGE"
	self._syncMessageDest = destThread
	self._syncMessage = TSMAPI_FOUR.Util.AcquireTempTable(...)
	self:_Yield()
end

function Thread._WaitForEvent(self, ...)
	self._state = "WAITING_FOR_EVENT"
	self._eventArgs = nil
	for _, event in TSMAPI_FOUR.Util.VarargIterator(...) do
		self._eventNames[event] = true
		private.schedulerFrame:RegisterEvent(event)
	end
	self:_Yield()
	local result = self._eventArgs
	self._eventArgs = nil
	return TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(result)
end

function Thread._WaitForFunction(self, func, ...)
	-- try the function once before yielding
	local result = TSMAPI_FOUR.Util.AcquireTempTable(func(...))
	if result[1] then
		return TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(result)
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(result)
	-- do the yield
	self._state = "WAITING_FOR_FUNCTION"
	self._waitFunction = func
	self._waitFunctionArgs = TSMAPI_FOUR.Util.AcquireTempTable(...)
	self:_Yield()
	result = self._waitFunctionResult
	self.waitFunction = nil
	TSMAPI_FOUR.Util.ReleaseTempTable(self._waitFunctionArgs)
	self._waitFunctionArgs = nil
	self._waitFunctionResult = nil
	return TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(result)
end

function Thread._AcquireSafeTempTable(self, ...)
	local tbl = TSMAPI_FOUR.Util.AcquireTempTable(...)
	assert(not self._safeTempTables[tbl])
	self._safeTempTables[tbl] = true
	return tbl
end

function Thread._ReleaseSafeTempTable(self, tbl)
	assert(self._safeTempTables[tbl])
	self._safeTempTables[tbl] = nil
	return TSMAPI_FOUR.Util.ReleaseTempTable(tbl)
end

function Thread._UnpackAndReleaseSafeTempTable(self, tbl)
	assert(self._safeTempTables[tbl])
	self._safeTempTables[tbl] = nil
	return TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(tbl)
end

function Thread._Exit(self)
	assert(not self._isImmortal) -- immortal threads should never return
	assert(self:_IsAlive())
	self._state = "DEAD"
	self:_Cleanup()
	TSM:LOG_INFO("Thread finished: %s", self:_ToLogStr())
	if self == private.runningThread then
		coroutine.yield(YIELD_VALUE)
		error("Shouldn't get here")
	elseif self._returnValue then
		TSMAPI_FOUR.Util.ReleaseTempTable(self._returnValue)
		self._returnValue = nil
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.StartScheduler()
	if private.schedulerFrame:IsVisible() then
		return
	end
	TSM:LOG_INFO("Starting scheduler")
	private.schedulerFrame:Show()
end

function private.RunScheduler(_, elapsed)
	-- don't run any threads while in combat
	if InCombatLockdown() then
		return
	end
	local startTime = debugprofilestop()
	local numReadyThreads = 0
	wipe(private.queue)

	-- go through all the threads, update their state, and add the ready ones into the queue
	for _, thread in pairs(private.threads) do
		thread:_UpdateState(elapsed)
		if thread:_CanRun() then
			numReadyThreads = numReadyThreads + 1
			tinsert(private.queue, thread)
		end
	end

	local remainingTime = min(elapsed * 1000 * MAX_TIME_USAGE_RATIO, MAX_QUANTUM_MS)
	while remainingTime > 0.01 do
		local ranThread = false
		for i = #private.queue, 1, -1 do
			local thread = private.queue[i]
			if thread:_CanRun() then
				local quantum = remainingTime / numReadyThreads
				local elapsedTime = thread:_Run(quantum)
				thread._cpuTimeUsed = thread._cpuTimeUsed + elapsedTime
				remainingTime = remainingTime - min(elapsedTime, quantum)
				-- any thread which ran excessively long should be ignored for future loops
				if elapsedTime > EXCESSIVE_TIME_USED_RATIO * quantum and elapsedTime > quantum + 1 then
					if elapsedTime > EXCESSIVE_TIME_LOG_THRESHOLD_MS then
						local line = TSMAPI_FOUR.Util.GetDebugStackInfo(2, thread._co)
						TSM:LOG_WARN("Thread %s ran too long (%.1f/%.1f): %s", thread._name, elapsedTime, quantum, line or "?")
					end
					tremove(private.queue, i)
				end
				ranThread = true
			end
		end
		if not ranThread then
			break
		end
	end

	local hasAliveThread = false
	for _, thread in pairs(private.threads) do
		if thread:_IsAlive() then
			hasAliveThread = true
			break
		end
	end
	if not hasAliveThread then
		TSM:LOG_INFO("Stopping the scheduler")
		private.schedulerFrame:Hide()
	end

	local timeTaken = debugprofilestop() - startTime
	if timeTaken > SCHEDULER_TIME_WARNING_THRESHOLD_MS then
		TSM:LOG_WARN("Scheduler took %.2fms", timeTaken)
	end
end

function private.ProcessEvent(self, event, ...)
	local startTime = debugprofilestop()
	for _, thread in pairs(private.threads) do
		thread:_ProcessEvent(event, ...)
	end
	local timeTaken = debugprofilestop() - startTime
	if timeTaken > SCHEDULER_TIME_WARNING_THRESHOLD_MS then
		TSM:LOG_WARN("Scheduler took %.2fms to process %s", timeTaken, tostring(event))
	end
end



-- ============================================================================
-- Driver Frame
-- ============================================================================

do
	private.schedulerFrame = CreateFrame("Frame")
	private.schedulerFrame:Hide()
	private.schedulerFrame:SetScript("OnUpdate", private.RunScheduler)
	private.schedulerFrame:SetScript("OnEvent", private.ProcessEvent)
end
