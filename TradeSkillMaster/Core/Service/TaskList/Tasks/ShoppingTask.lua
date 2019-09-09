-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local ShoppingTask = TSMAPI_FOUR.Class.DefineClass("ShoppingTask", TSM.TaskList.ItemTask)
local L = TSM.L
TSM.TaskList.ShoppingTask = ShoppingTask
local private = {
	registeredCallbacks = false,
	currentlyScanning = nil,
	activeTasks = {},
}



-- ============================================================================
-- Class Meta Methods
-- ============================================================================

function ShoppingTask.__init(self, searchType)
	self.__super:__init()
	self._isScanning = false
	self._isShowingResults = false
	assert(searchType == "NORMAL" or searchType == "DISENCHANT" or searchType == "CRAFTING")
	self._searchType = searchType

	if not private.registeredCallbacks then
		TSM.UI.AuctionUI.RegisterUpdateCallback(private.UIUpdateCallback)
		TSM.UI.AuctionUI.Shopping.RegisterUpdateCallback(private.UIUpdateCallback)
		private.registeredCallbacks = true
	end
end

function ShoppingTask.Acquire(self, doneHandler, category)
	self.__super:Acquire(doneHandler, category, L["Buy from AH"])
	private.activeTasks[self] = true
end

function ShoppingTask.Release(self)
	self.__super:Release()
	self._isScanning = false
	self._isShowingResults = false
	private.activeTasks[self] = nil
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

function ShoppingTask.OnButtonClick(self)
	private.currentlyScanning = self
	TSM.UI.AuctionUI.Shopping.StartGatheringSearch(self:GetItems(), private.StateCallback, private.BuyCallback, self._searchType)
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function ShoppingTask._UpdateState(self)
	if not TSM.UI.AuctionUI.Shopping.IsVisible() then
		return self:_SetButtonState(false, L["NOT OPEN"])
	elseif self._isScanning then
		return self:_SetButtonState(false, L["SCANNING"])
	elseif self._isShowingResults then
		return self:_SetButtonState(false, L["BUY"])
	elseif TSM.UI.AuctionUI.IsScanning() or private.currentlyScanning then
		return self:_SetButtonState(false, L["AH BUSY"])
	else
		return self:_SetButtonState(true, L["SCAN ALL"])
	end
end

function ShoppingTask._OnSearchStateChanged(self, state)
	if state == "SCANNING" then
		self._isScanning = true
		self._isShowingResults = false
	elseif state == "RESULTS" then
		self._isScanning = false
		self._isShowingResults = true
	elseif state == "DONE" then
		assert(private.currentlyScanning == self)
		private.currentlyScanning = nil
		self._isScanning = false
		self._isShowingResults = false
	else
		error("Unexpected state: "..tostring(state))
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.UIUpdateCallback()
	TSMAPI_FOUR.Delay.AfterFrame("SHOPPING_TASK_UPDATE_CALLBACK", 1, private.UIUpdateCallbackDelayed)
end

function private.UIUpdateCallbackDelayed()
	for task in pairs(private.activeTasks) do
		task:Update()
	end
end

function private.StateCallback(state)
	TSM:LOG_INFO("State changed (%s)", state)
	local self = private.currentlyScanning
	assert(self)
	self:_OnSearchStateChanged(state)
	TSM.TaskList.OnTaskUpdated()
end

function private.BuyCallback(itemString, quantity)
	TSM:LOG_INFO("Bought item (%s,%d)", itemString, quantity)
	local self = private.currentlyScanning
	assert(self)
	if self:_RemoveItem(itemString, quantity) then
		TSM.TaskList.OnTaskUpdated()
	end
end
