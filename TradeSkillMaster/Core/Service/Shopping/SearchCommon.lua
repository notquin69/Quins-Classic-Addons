-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local SearchCommon = TSM.Shopping:NewPackage("SearchCommon")
local private = { findThreadId = nil }



-- ============================================================================
-- Module Functions
-- ============================================================================

function SearchCommon.OnInitialize()
	-- initialize threads
	private.findThreadId = TSMAPI_FOUR.Thread.New("FIND_SEARCH", private.FindThread)
end

function SearchCommon.StartFindAuction(auctionScan, auction, callback, noSeller)
	TSMAPI_FOUR.Thread.SetCallback(private.findThreadId, callback)
	TSMAPI_FOUR.Thread.Start(private.findThreadId, auctionScan, auction, noSeller)
end

function SearchCommon.StopFindAuction()
	TSMAPI_FOUR.Thread.Kill(private.findThreadId)
end



-- ============================================================================
-- Find Thread
-- ============================================================================

function private.FindThread(auctionScan, row, noSeller)
	return auctionScan:FindAuctionThreaded(row, noSeller)
end
