-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- FSM TSMAPI_FOUR Functions.
-- @module FSM

TSMAPI_FOUR.FSM = {}
local _, TSM = ...
local FSM = TSM:NewPackage("FSM")
FSM.classes = {}
local private = { simpleTransitionEventHandlerCache = {} }



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

--- Create a new FSM.
-- @tparam string name The name of the FSM (for debugging purposes)
-- @treturn FSM The FSM object
function TSMAPI_FOUR.FSM.New(name)
	return FSM.classes.FSM(name)
end

--- Create a new FSM state.
-- @tparam string state The name of the state
-- @treturn FSMState The FSMState object
function TSMAPI_FOUR.FSM.NewState(state)
	return FSM.classes.FSMState(state)
end

--- Get a simple event handler function.
-- The handler will simply transition to a state and pass through any additional arguments.
-- @tparam string toState The state to transition to
-- @treturn function The event handler function
function TSMAPI_FOUR.FSM.SimpleTransitionEventHandler(toState)
	if not private.simpleTransitionEventHandlerCache[toState] then
		private.simpleTransitionEventHandlerCache[toState] = function(context, ...)
			return toState, ...
		end
	end
	return private.simpleTransitionEventHandlerCache[toState]
end
