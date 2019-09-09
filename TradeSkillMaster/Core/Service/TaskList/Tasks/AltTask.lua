-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local AltTask = TSMAPI_FOUR.Class.DefineClass("AltTask", TSM.TaskList.Task)
local L = TSM.L
TSM.TaskList.AltTask = AltTask



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function AltTask.Acquire(self, doneHandler, category, character)
	self.__super:Acquire(doneHandler, category, format(L["Switch to %s"], character))
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function AltTask.IsSecureMacro(self)
	return true
end

function AltTask.GetSecureMacroText(self)
	return "/logout"
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function AltTask._UpdateState(self)
	return self:_SetButtonState(true, strupper(LOGOUT))
end
