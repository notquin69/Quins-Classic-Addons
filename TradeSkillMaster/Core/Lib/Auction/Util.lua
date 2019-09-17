-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Util = TSM.Auction:NewPackage("Util")



-- ============================================================================
-- Module Functions
-- ============================================================================

function Util.GetRequiredBidByScanResultRow(row)
	local bid, minBid, minIncrement = row:GetFields("bid", "minBid", "minIncrement")
	return bid == 0 and minBid or (bid + minIncrement)
end
