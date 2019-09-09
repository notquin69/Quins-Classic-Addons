-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local TaskList = TSM:NewPackage("TaskList")
local Task = TSMAPI_FOUR.Class.DefineClass("TASK", nil, "ABSTRACT")
TaskList.Task = Task
local private = {
	updateCallback = nil,
	iterFuncs = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function TaskList.RegisterTaskPool(iterFunc)
	tinsert(private.iterFuncs, iterFunc)
end

function TaskList.SetUpdateCallback(func)
	assert(func and not private.updateCallback)
	private.updateCallback = func
end

function TaskList.GetNumTasks()
	local num = 0
	for _, iterFunc in ipairs(private.iterFuncs) do
		for _ in iterFunc() do
			num = num + 1
		end
	end
	return num
end

function TaskList.Iterator()
	local tasks = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, iterFunc in ipairs(private.iterFuncs) do
		for _, task in iterFunc() do
			tinsert(tasks, task)
		end
	end
	return TSMAPI_FOUR.Util.TempTableIterator(tasks)
end

function TaskList.OnTaskUpdated()
	private.updateCallback()
end
