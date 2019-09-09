-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- FSMState Class.
-- This class represents a single state within an @{FSM}.
-- @classmod FSMState

local _, TSM = ...
local FSMState = TSMAPI_FOUR.Class.DefineClass("FSMState")
TSM.FSM.classes.FSMState = FSMState


-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function FSMState.__init(self, name)
	self._name = name
	self._onEnterHandler = nil
	self._onExitHandler = nil
	self._transitionValid = {}
	self._events = {}
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

--- Set the OnEnter handler.
-- This function is called upon entering the state.
-- @tparam FSMState self The FSM state object
-- @tparam function handler The handler function
-- @treturn FSMState The FSM state object
function FSMState.SetOnEnter(self, handler)
	self._onEnterHandler = handler
	return self
end

--- Set the OnExit handler.
-- This function is called upon existing the state.
-- @tparam FSMState self The FSM state object
-- @tparam function handler The handler function
-- @treturn FSMState The FSM state object
function FSMState.SetOnExit(self, handler)
	self._onExitHandler = handler
	return self
end

--- Add a transition.
-- @tparam FSMState self The FSM state object
-- @tparam string toState The state this transition goes to
-- @treturn FSMState The FSM state object
function FSMState.AddTransition(self, toState)
	assert(not self._transitionValid[toState], "transition already exists")
	self._transitionValid[toState] = true
	return self
end

--- Add a handled event.
-- @tparam FSMState self The FSM state object
-- @tparam string event The name of the event
-- @tparam function handler The function called when the event occurs
-- @treturn FSMState The FSM state object
function FSMState.AddEvent(self, event, handler)
	assert(not self._events[event], "event already exists")
	self._events[event] = handler
	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function FSMState._GetName(self)
	return self._name
end

function FSMState._ToStateIterator(self)
	local temp = TSMAPI_FOUR.Util.AcquireTempTable()
	for toState in pairs(self._transitionValid) do
		tinsert(temp, toState)
	end
	return TSMAPI_FOUR.Util.TempTableIterator(temp)
end

function FSMState._IsTransitionValid(self, toState)
	return self._transitionValid[toState]
end

function FSMState._HasEventHandler(self, event)
	return self._events[event] and true or false
end

function FSMState._ProcessEvent(self, event, context, ...)
	return self._events[event](context, ...)
end

function FSMState._Enter(self, context, ...)
	if self._onEnterHandler then
		return self._onEnterHandler(context, ...)
	end
end

function FSMState._Exit(self, context)
	if self._onExitHandler then
		return self._onExitHandler(context)
	end
end
