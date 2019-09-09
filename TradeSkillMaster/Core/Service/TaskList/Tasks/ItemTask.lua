-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local ItemTask = TSMAPI_FOUR.Class.DefineClass("ItemTask", TSM.TaskList.Task, "ABSTRACT")
TSM.TaskList.ItemTask = ItemTask
local private = {}



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function ItemTask.__init(self)
	self.__super:__init()
	self._itemList = {}
	self._itemNum = {}
end

function ItemTask.Release(self)
	self.__super:Release()
	self:WipeItems()
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ItemTask.WipeItems(self)
	wipe(self._itemList)
	wipe(self._itemNum)
end

function ItemTask.AddItem(self, itemString, quantity)
	if not self._itemNum[itemString] then
		tinsert(self._itemList, itemString)
		self._itemNum[itemString] = 0
	end
	self._itemNum[itemString] = self._itemNum[itemString] + quantity
end

function ItemTask.GetItems(self)
	return self._itemNum
end

function ItemTask.HasItems(self)
	return next(self._itemNum) and true or false
end

function ItemTask.HasSubTasks(self)
	assert(#self._itemList > 0)
	return true
end

function ItemTask.SubTaskIterator(self)
	assert(#self._itemList > 0)
	sort(self._itemList)
	return private.SubTaskIterator, self, 0
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ItemTask._RemoveItem(self, itemString, quantity)
	if not self._itemNum[itemString] then
		return false
	end
	self._itemNum[itemString] = TSMAPI_FOUR.Util.Round(self._itemNum[itemString] - quantity, 0.01)
	if self._itemNum[itemString] <= 0.01 then
		self._itemNum[itemString] = nil
		assert(TSMAPI_FOUR.Util.TableRemoveByValue(self._itemList, itemString) == 1)
	end
	if #self._itemList == 0 then
		self:_doneHandler()
	end
	return true
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.SubTaskIterator(self, index)
	index = index + 1
	local itemString = self._itemList[index]
	if not itemString then
		return
	end
	return index, format("%s (%d)", TSMAPI_FOUR.Item.GetLink(itemString), self._itemNum[itemString])
end
