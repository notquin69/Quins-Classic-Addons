-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local OpenMailTask = TSMAPI_FOUR.Class.DefineClass("OpenMailTask", TSM.TaskList.ItemTask)
local L = TSM.L
TSM.TaskList.OpenMailTask = OpenMailTask



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function OpenMailTask.Acquire(self, doneHandler, category)
	self.__super:Acquire(doneHandler, category, L["Open Mail"])
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function OpenMailTask.OnButtonClick(self)
	-- TODO
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function OpenMailTask._UpdateState(self)
	if not TSM.UI.MailingUI.IsVisible() then
		return self:_SetButtonState(false, L["NOT OPEN"])
	else
		return self:_SetButtonState(true, L["OPEN"])
	end
end
