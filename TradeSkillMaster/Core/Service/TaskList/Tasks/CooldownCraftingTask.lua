-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local CooldownCraftingTask = TSMAPI_FOUR.Class.DefineClass("CooldownCraftingTask", TSM.TaskList.CraftingTask)
TSM.TaskList.CooldownCraftingTask = CooldownCraftingTask
local private = {
	registeredCallbacks = false,
	activeTasks = {},
}



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function CooldownCraftingTask.__init(self)
	self.__super:__init()
	if not private.registeredCallbacks then
		TSM.Crafting.CreateIgnoredCooldownQuery()
			:SetUpdateCallback(private.UpdateTasks)
		private.registeredCallbacks = true
	end
end

function CooldownCraftingTask.Acquire(self, ...)
	self.__super:Acquire(...)
	private.activeTasks[self] = true
end

function CooldownCraftingTask.Release(self)
	self.__super:Release()
	private.activeTasks[self] = nil
end

function CooldownCraftingTask.CanHideSubTasks(self)
	return true
end

function CooldownCraftingTask.HideSubTask(self, index)
	TSM.Crafting.IgnoreCooldown(self._spellIds[index])
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function CooldownCraftingTask._UpdateState(self)
	local result = self.__super:_UpdateState()
	if not self:HasSpellIds() then
		return result
	end
	for i = #self._spellIds, 1, -1 do
		if self:_IsOnCooldown(self._spellIds[i]) or TSM.Crafting.IsCooldownIgnored(self._spellIds[i]) then
			self:_RemoveSpellId(self._spellIds[i])
		end
	end
	if not self:HasSpellIds() then
		self:_doneHandler()
		return true
	end
	return result
end

function CooldownCraftingTask._IsOnCooldown(self, spellId)
	assert(not TSM.db.char.internalData.craftingCooldowns[spellId])
	local remainingCooldown = TSM.Crafting.ProfessionUtil.GetRemainingCooldown(spellId)
	if remainingCooldown then
		TSM.db.char.internalData.craftingCooldowns[spellId] = time() + TSMAPI_FOUR.Util.Round(remainingCooldown)
		return true
	end
	return false
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.UpdateTasks()
	for task in pairs(private.activeTasks) do
		if task:HasSpellIds() then
			task:Update()
		end
	end
end
