-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- FSM Class.
-- This class allows implementing event-driving finite state machines.
-- @classmod FSM

local _, TSM = ...
local FSM = TSMAPI_FOUR.Class.DefineClass("FSM")
TSM.FSM.classes.FSM = FSM



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function FSM.__init(self, name)
	self._name = name
	self._currentState = nil
	self._context = nil
	self._stateObjs = {}
	self._defaultEvents = {}
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

--- Add an FSM state.
-- @tparam FSM self The FSM object
-- @tparam FSMState stateObj The FSM state object to add
-- @treturn FSM The FSM object
function FSM.AddState(self, stateObj)
	assert(stateObj:__isa(TSM.FSM.classes.FSMState))
	local name = stateObj:_GetName()
	assert(not self._stateObjs[name], "state already exists")
	self._stateObjs[stateObj:_GetName()] = stateObj
	return self
end

--- Add a default event handler.
-- @tparam FSM self The FSM object
-- @tparam string event The event name
-- @tparam function handler The default event handler
-- @treturn FSM The FSM object
function FSM.AddDefaultEvent(self, event, handler)
	assert(not self._defaultEvents[event], "event already exists")
	self._defaultEvents[event] = handler
	return self
end

--- Initialize the FSM.
-- @tparam FSM self The FSM object
-- @tparam string initialState The name of the initial state
-- @param[opt={}] context The FSM context table which gets passed to all state and event handlers
-- @treturn FSM The FSM object
function FSM.Init(self, initialState, context)
	assert(self._stateObjs[initialState], "invalid initial state")
	self._currentState = initialState
	self._context = context or {}
	-- validate all the transitions
	for name, obj in pairs(self._stateObjs) do
		for _, toState in obj:_ToStateIterator() do
			assert(self._stateObjs[toState], format("toState doesn't exist (%s -> %s)", name, toState))
		end
	end
	return self
end

--- Process an event.
-- @tparam FSM self The FSM object
-- @tparam string event The name of the event
-- @tparam[opt] vararg ... Additional arguments to pass to the handler function
-- @treturn FSM The FSM object
function FSM.ProcessEvent(self, event, ...)
	assert(self._currentState, "FSM not initialized")
	if self._handlingEvent then
		TSM:LOG_INFO("[%s] %s (ignored - handling event)", self._name, event)
		return self
	elseif self._inTransition then
		TSM:LOG_INFO("[%s] %s (ignored - in transition)", self._name, event)
		return self
	end

	TSM:LOG_INFO("[%s] %s", self._name, event)
	self._handlingEvent = true
	local currentStateObj = self._stateObjs[self._currentState]
	if currentStateObj:_HasEventHandler(event) then
		self:_Transition(TSMAPI_FOUR.Util.AcquireTempTable(currentStateObj:_ProcessEvent(event, self._context, ...)))
	elseif self._defaultEvents[event] then
		self:_Transition(TSMAPI_FOUR.Util.AcquireTempTable(self._defaultEvents[event](self._context, ...)))
	end
	self._handlingEvent = false
	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function FSM._Transition(self, eventResult)
	local result = eventResult
	while result[1] do
		-- perform the transition
		local currentStateObj = self._stateObjs[self._currentState]
		local toState = tremove(result, 1)
		local toStateObj = self._stateObjs[toState]
		TSM:LOG_INFO("[%s] %s -> %s", self._name, self._currentState, toState)
		assert(toStateObj and currentStateObj:_IsTransitionValid(toState), "invalid transition")
		self._inTransition = true
		currentStateObj:_Exit(self._context)
		self._currentState = toState
		result = TSMAPI_FOUR.Util.AcquireTempTable(toStateObj:_Enter(self._context, TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(result)))
		self._inTransition = false
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(result)
end
