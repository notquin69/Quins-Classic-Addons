-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Expenses = TSM.MainUI.Ledger:NewPackage("Expenses")
local L = TSM.L



-- ============================================================================
-- Module Functions
-- ============================================================================

function Expenses.OnInitialize()
	TSM.MainUI.Ledger.RegisterPage(L["Expenses"])
end

function Expenses.RegisterPage(name, callback)
	TSM.MainUI.Ledger.RegisterChildPage(L["Expenses"], name, callback)
end
