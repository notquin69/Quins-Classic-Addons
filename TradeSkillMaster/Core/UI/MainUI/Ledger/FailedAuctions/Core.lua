-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local FailedAuctions = TSM.MainUI.Ledger:NewPackage("FailedAuctions")
local L = TSM.L



-- ============================================================================
-- Module Functions
-- ============================================================================

function FailedAuctions.OnInitialize()
	TSM.MainUI.Ledger.RegisterPage(L["Failed Auctions"])
end

function FailedAuctions.RegisterPage(name, callback)
	TSM.MainUI.Ledger.RegisterChildPage(L["Failed Auctions"], name, callback)
end
