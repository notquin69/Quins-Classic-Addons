-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Gathering = TSM.TaskList:NewPackage("Gathering")
local L = TSM.L
local private = {
	activeTasks = {},
	query = nil,
	sourceTasks = {},
	altTaskPool = TSMAPI_FOUR.ObjectPool.New("GATHERING_ALT_TASK", TSM.TaskList.AltTask, 0),
	professionTasks = {},
	prevHash = nil,
}
local ITEM_SOURCES = {
	"auction",
	"auctionDE",
	"auctionCrafting",
	"vendor",
	"bank",
	"guildBank",
	"sendMail",
	"openMail",
}
local SOURCE_CLASS_CONSTRUCTORS = {
	auction = function() return TSM.TaskList.ShoppingTask("NORMAL") end,
	auctionDE = function() return TSM.TaskList.ShoppingTask("DISENCHANT") end,
	auctionCrafting = function() return TSM.TaskList.ShoppingTask("CRAFTING") end,
	vendor = TSM.TaskList.VendoringTask,
	bank = function() return TSM.TaskList.BankingTask(false) end,
	guildBank = function() return TSM.TaskList.BankingTask(true) end,
	sendMail = TSM.TaskList.SendMailTask,
	openMail = TSM.TaskList.OpenMailTask,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Gathering.OnInitialize()
	for _, source in ipairs(ITEM_SOURCES) do
		private.sourceTasks[source] = SOURCE_CLASS_CONSTRUCTORS[source]()
		private.sourceTasks[source]:Acquire(private.SourceProfessionTaskDone, L["Gathering"])
	end
end

function Gathering.OnEnable()
	TSM.TaskList.RegisterTaskPool(private.ActiveTaskIterator)
	private.query = TSM.Crafting.Gathering.CreateQuery()
		:Select("itemString", "sourcesStr")
		:GreaterThan("numNeed", 0)
		:SetUpdateCallback(private.PopulateTasks)
	private.PopulateTasks()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.PopulateTasks()
	local hash = private.query:Hash()
	if hash == private.prevHash then
		-- nothing changed
		return
	end
	private.prevHash = hash

	for task in pairs(private.activeTasks) do
		if task:__isa(TSM.TaskList.AltTask) then
			private.RemoveAltTask(task)
		end
	end
	wipe(private.activeTasks)
	for _, task in pairs(private.sourceTasks) do
		task:WipeItems()
	end
	for _, task in pairs(private.professionTasks) do
		task:WipeSpellIds()
	end

	local alts = TSMAPI_FOUR.Util.AcquireTempTable()
	local sourceInfo = TSMAPI_FOUR.Util.AcquireTempTable()
	for _, itemString, sourcesStr in private.query:Iterator() do
		TSM.Crafting.Gathering.SourcesStrToTable(sourcesStr, sourceInfo, alts)
		sourceInfo.alt = nil
		sourceInfo.altGuildBank = nil
		for _, source in ipairs(ITEM_SOURCES) do
			if sourceInfo[source] then
				private.sourceTasks[source]:AddItem(itemString, sourceInfo[source])
				sourceInfo[source] = nil
			end
		end
		if sourceInfo.craftProfit or sourceInfo.craftNoProfit then
			local spellId = TSM.Crafting.GetMostProfitableSpellIdByItem(itemString, TSM.db.factionrealm.gatheringContext.crafter)
			assert(spellId)
			local profession = TSM.Crafting.GetProfession(spellId)
			if not private.professionTasks[profession] then
				private.professionTasks[profession] = TSM.TaskList.CraftingTask()
				private.professionTasks[profession]:Acquire(private.SourceProfessionTaskDone, L["Gathering"], profession)
			end
			private.professionTasks[profession]:AddSpellId(spellId, sourceInfo.craftProfit or sourceInfo.craftNoProfit)
			sourceInfo.craftProfit = nil
			sourceInfo.craftNoProfit = nil
		end
		-- make sure we processed everything from the sourceInfo table
		assert(not next(sourceInfo))
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(sourceInfo)

	for character in pairs(alts) do
		local task = private.altTaskPool:Get()
		task:Acquire(private.RemoveAltTask, L["Gathering"], character)
		private.activeTasks[task] = task
		task:Update()
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(alts)

	if TSM.db.factionrealm.gatheringContext.crafter then
		private.sourceTasks.sendMail:SetTarget(TSM.db.factionrealm.gatheringContext.crafter)
	end
	for _, task in pairs(private.sourceTasks) do
		if task:HasItems() then
			private.activeTasks[task] = task
			task:Update()
		end
	end
	for _, task in pairs(private.professionTasks) do
		if task:HasSpellIds() then
			private.activeTasks[task] = task
			task:Update()
		end
	end

	TSM.TaskList.OnTaskUpdated()
end

function private.ActiveTaskIterator()
	return pairs(private.activeTasks)
end

function private.RemoveAltTask(task)
	assert(private.activeTasks[task])
	private.activeTasks[task] = nil
	task:Release()
	private.altTaskPool:Recycle(task)
end

function private.SourceProfessionTaskDone(task)
	assert(private.activeTasks[task])
	private.activeTasks[task] = nil
	TSM.TaskList.OnTaskUpdated()
end
