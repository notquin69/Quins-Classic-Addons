-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- PlayerGoldText UI Element Class.
-- A text element which contains player gold info which automatically updates when the player's gold amount changes. It
-- is a subclass of the @{Text} class.
-- @classmod PlayerGoldText

local _, TSM = ...
local L = TSM.L
local PlayerGoldText = TSMAPI_FOUR.Class.DefineClass("PlayerGoldText", TSM.UI.Text)
TSM.UI.PlayerGoldText = PlayerGoldText
local private = { registered = false, elements = {} }



-- ============================================================================
-- Meta Class Methods
-- ============================================================================

function PlayerGoldText.__init(self)
	self.__super:__init()

	if not private.registered then
		TSMAPI_FOUR.Event.Register("PLAYER_MONEY", private.MoneyOnUpdate)
		private.registered = true
	end
end

function PlayerGoldText.Acquire(self)
	private.elements[self] = true
	self.__super:Acquire()
	self:SetText(TSM.Money.ToString(GetMoney()))
	self:SetTooltip(private.MoneyTooltipFunc)
end

function PlayerGoldText.Release(self)
	private.elements[self] = nil
	self.__super:Release()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.MoneyOnUpdate()
	for element in pairs(private.elements) do
		element:SetText(TSM.Money.ToString(GetMoney()))
		element:Draw()
	end
end

function private.MoneyTooltipFunc()
	local tooltipLines = TSMAPI_FOUR.Util.AcquireTempTable()
	tinsert(tooltipLines, strjoin(TSM.CONST.TOOLTIP_SEP, L["Player Gold"]..":", TSM.Money.ToString(GetMoney())))
	local numPosted, numSold, postedGold, soldGold = TSM.MyAuctions.GetAuctionInfo()
	if numPosted then
		tinsert(tooltipLines, strjoin(TSM.CONST.TOOLTIP_SEP, format(L["%d Sold Auctions"], numSold)..":", TSM.Money.ToString(soldGold)))
		tinsert(tooltipLines, strjoin(TSM.CONST.TOOLTIP_SEP, format(L["%d Posted Auctions"], numPosted)..":", TSM.Money.ToString(postedGold)))
	end
	return strjoin("\n", TSMAPI_FOUR.Util.UnpackAndReleaseTempTable(tooltipLines))
end
