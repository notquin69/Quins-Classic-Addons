-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Revenue = TSM.MainUI.Ledger:NewPackage("Revenue")
local L = TSM.L



-- ============================================================================
-- Module Functions
-- ============================================================================

function Revenue.OnInitialize()
	TSM.MainUI.Ledger.RegisterPage(L["Revenue"])
end

function Revenue.RegisterPage(name, callback)
	TSM.MainUI.Ledger.RegisterChildPage(L["Revenue"], name, callback)
end
