-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

TSMAPI_FOUR.Auction = {}
local _, TSM = ...
local Auction = TSM:NewPackage("Auction")
Auction.classes = {}
local private = {
	auctionFilters = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Auction.OnInitialize()
	private.auctionFilters = TSMAPI_FOUR.ObjectPool.New("AUCTION_FILTERS", Auction.classes.AuctionFilter, 1)
end

function Auction.NewAuctionFilter()
	return private.auctionFilters:Get()
end

function Auction.RecycleAuctionFilter(filter)
	private.auctionFilters:Recycle(filter)
end
