-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local CraftingTask = TSMAPI_FOUR.Class.DefineClass("CraftingTask", TSM.TaskList.Task)
local L = TSM.L
TSM.TaskList.CraftingTask = CraftingTask
local private = {
	currentlyCrafting = nil,
	registeredCallbacks = false,
	activeTasks = {},
}



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function CraftingTask.__init(self)
	self.__super:__init()
	self._profession = nil
	self._spellIds = {}
	self._spellQuantity = {}

	if not private.registeredCallbacks then
		TSM.Crafting.ProfessionState.RegisterUpdateCallback(private.UpdateTasks)
		TSM.Crafting.ProfessionScanner.RegisterHasScannedCallback(private.UpdateTasks)
		TSM.Inventory.BagTracking.RegisterCallback(private.UpdateTasks)
		private.registeredCallbacks = true
	end
end

function CraftingTask.Acquire(self, doneHandler, category, profession)
	self.__super:Acquire(doneHandler, category, format(L["%s Crafts"], profession))
	self._profession = profession
	private.activeTasks[self] = true
end

function CraftingTask.Release(self)
	self.__super:Release()
	self._profession = nil
	wipe(self._spellIds)
	wipe(self._spellQuantity)
	private.activeTasks[self] = nil
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function CraftingTask.WipeSpellIds(self)
	wipe(self._spellIds)
	wipe(self._spellQuantity)
end

function CraftingTask.HasSpellIds(self)
	return #self._spellIds > 0
end

function CraftingTask.GetProfession(self)
	return self._profession
end

function CraftingTask.HasSpellId(self, spellId)
	return self._spellQuantity[spellId] and true or false
end

function CraftingTask.AddSpellId(self, spellId, quantity)
	tinsert(self._spellIds, spellId)
	self._spellQuantity[spellId] = quantity
end

function CraftingTask.OnButtonClick(self)
	if self._buttonText == L["CRAFT"] then
		local spellId = self._spellIds[1]
		local quantity = self._spellQuantity[spellId]
		TSM:LOG_INFO("Crafting %d (%d)", spellId, quantity)
		private.currentlyCrafting = self
		local numCrafted = TSM.Crafting.ProfessionUtil.Craft(spellId, quantity, true, private.CraftCompleteCallback)
		if numCrafted == 0 then
			-- we're probably crafting something else already - so just bail
			TSM:LOG_ERR("Failed to craft")
			private.currentlyCrafting = nil
		end
	elseif self._buttonText == L["OPEN"] then
		TSM.Crafting.ProfessionUtil.OpenProfession(self._profession)
	else
		error("Invalid state: "..tostring(self._buttonText))
	end
	self:Update()
end

function CraftingTask.HasSubTasks(self)
	assert(self:HasSpellIds())
	return true
end

function CraftingTask.SubTaskIterator(self)
	assert(self:HasSpellIds())
	sort(self._spellIds, private.SpellIdSort)
	return private.SubTaskIterator, self, 0
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function CraftingTask._UpdateState(self)
	sort(self._spellIds, private.SpellIdSort)
	if TSM.Crafting.ProfessionUtil.GetNumCraftableFromDB(self._spellIds[1]) == 0 then
		-- don't have the mats to craft this
		return self:_SetButtonState(false, L["NEED MATS"])
	elseif self._profession ~= TSM.Crafting.ProfessionState.GetCurrentProfession() then
		-- the profession isn't opened
		return self:_SetButtonState(true, L["OPEN"])
	elseif not TSM.Crafting.ProfessionScanner.HasScanned() then
		-- the profession is opened, but we haven't yet fully scanned it
		return self:_SetButtonState(false, strupper(OPENING))
	elseif private.currentlyCrafting == self then
		return self:_SetButtonState(false, L["CRAFTING"])
	elseif private.currentlyCrafting then
		return self:_SetButtonState(false, L["BUSY"])
	else
		-- ready to craft
		return self:_SetButtonState(true, L["CRAFT"])
	end
end

function CraftingTask._RemoveSpellId(self, spellId)
	assert(TSMAPI_FOUR.Util.TableRemoveByValue(self._spellIds, spellId) == 1)
	self._spellQuantity[spellId] = nil
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.SubTaskIterator(self, index)
	index = index + 1
	local spellId = self._spellIds[index]
	if not spellId then
		return
	end
	return index, TSM.Crafting.GetName(spellId).." ("..self._spellQuantity[spellId]..")"
end

function private.CraftCompleteCallback(success, isDone)
	local self = private.currentlyCrafting
	assert(self)
	local spellId = self._spellIds[1]
	if isDone then
		private.currentlyCrafting = nil
		if success then
			self:_RemoveSpellId(spellId)
			if not self:HasSpellIds() then
				self:_doneHandler()
			end
		end
	elseif success then
		self._spellQuantity[spellId] = self._spellQuantity[spellId] - 1
		assert(self._spellQuantity[spellId] > 0)
	end
	if self:HasSpellIds() then
		self:Update()
	end
end

function private.UpdateTasks()
	for task in pairs(private.activeTasks) do
		if task:HasSpellIds() then
			task:Update()
		end
	end
end

function private.SpellIdSort(a, b)
	local aNumCraftable = TSM.Crafting.ProfessionUtil.GetNumCraftableFromDB(a)
	local bNumCraftable = TSM.Crafting.ProfessionUtil.GetNumCraftableFromDB(b)
	if aNumCraftable == bNumCraftable then
		return a < b
	end
	return aNumCraftable > bNumCraftable
end
