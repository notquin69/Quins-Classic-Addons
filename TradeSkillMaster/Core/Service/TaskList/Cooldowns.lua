-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Cooldowns = TSM.TaskList:NewPackage("Cooldowns")
local L = TSM.L
local private = {
	query = nil,
	taskPool = TSMAPI_FOUR.ObjectPool.New("COOLDOWN_TASK", TSM.TaskList.CooldownCraftingTask, 0),
	activeTasks = {},
	activeTaskByProfession = {},
	currentlyCrafting = nil,
	ignoredQuery = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Cooldowns.OnEnable()
	TSM.TaskList.RegisterTaskPool(private.ActiveTaskIterator)
	private.query = TSM.Crafting.CreateCooldownSpellsQuery()
		:Select("profession", "spellId")
		:Custom(private.QueryPlayerFilter, UnitName("player"))
		:SetUpdateCallback(private.PopulateTasks)
	private.ignoredQuery = TSM.Crafting.CreateIgnoredCooldownQuery()
		:SetUpdateCallback(private.PopulateTasks)
	private.PopulateTasks()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ActiveTaskIterator()
	return ipairs(private.activeTasks)
end

function private.QueryPlayerFilter(row, player)
	return TSMAPI_FOUR.Util.SeparatedStrContains(row:GetField("players"), ",", player)
end

function private.PopulateTasks()
	-- clean DB entries with expired times
	for spellId, expireTime in pairs(TSM.db.char.internalData.craftingCooldowns) do
		if expireTime <= time() then
			TSM.db.char.internalData.craftingCooldowns[spellId] = nil
		end
	end

	-- clear out the existing tasks
	for _, task in pairs(private.activeTaskByProfession) do
		task:WipeSpellIds()
	end

	local minPendingCooldown = math.huge
	for _, profession, spellId in private.query:Iterator() do
		if TSM.Crafting.IsCooldownIgnored(spellId) then
			-- this is ignored
		elseif TSM.db.char.internalData.craftingCooldowns[spellId] then
			-- this is on CD
			minPendingCooldown = min(minPendingCooldown, TSM.db.char.internalData.craftingCooldowns[spellId] - time())
		else
			-- this is a new CD task
			local task = private.activeTaskByProfession[profession]
			if not task then
				task = private.taskPool:Get()
				task:Acquire(private.RemoveTask, L["Cooldowns"], profession)
				private.activeTaskByProfession[profession] = task
			end
			if not task:HasSpellId(spellId) then
				task:AddSpellId(spellId, 1)
			end
		end
	end

	-- update our tasks
	wipe(private.activeTasks)
	for profession, task in pairs(private.activeTaskByProfession) do
		if task:HasSpellIds() then
			tinsert(private.activeTasks, task)
			task:Update()
		else
			private.activeTaskByProfession[profession] = nil
			task:Release()
			private.taskPool:Recycle(task)
		end
	end
	TSM.TaskList.OnTaskUpdated()

	if minPendingCooldown ~= math.huge then
		TSMAPI_FOUR.Delay.AfterTime("COOLDOWN_UPDATE", minPendingCooldown, private.PopulateTasks)
	else
		TSMAPI_FOUR.Delay.Cancel("COOLDOWN_UPDATE")
	end
end

function private.RemoveTask(task)
	local profession = task:GetProfession()
	assert(TSMAPI_FOUR.Util.TableRemoveByValue(private.activeTasks, task) == 1)
	assert(private.activeTaskByProfession[profession] == task)
	private.activeTaskByProfession[profession] = nil
	task:Release()
	private.taskPool:Recycle(task)
	TSM.TaskList.OnTaskUpdated()
end
