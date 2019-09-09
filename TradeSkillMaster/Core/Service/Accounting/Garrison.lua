-- ------------------------------------------------------------------------------ --
--                           TradeSkillMaster_Accounting                          --
--           http://www.curse.com/addons/wow/tradeskillmaster_accounting          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Garrison = TSM.Accounting:NewPackage("Garrison")
local private = {}
local GOLD_TRAIT_ID = 256 -- traitId for the treasure hunter trait which increases gold from missions



-- ============================================================================
-- Module Functions
-- ============================================================================

function Garrison.OnInitialize()
	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		TSMAPI_FOUR.Event.Register("GARRISON_MISSION_COMPLETE_RESPONSE", private.MissionComplete)
	end
end



-- ============================================================================
-- Misson Reward Tracking
-- ============================================================================

function private.MissionComplete(_, missionId)
	local moneyAward = 0
	local info = C_Garrison.GetBasicMissionInfo(missionId)
	if not info then
		return
	end
	local rewards = info.rewards or info.overMaxRewards
	for _, reward in pairs(rewards) do
		if reward.title == GARRISON_REWARD_MONEY and reward.currencyID == 0 then
			moneyAward = moneyAward + reward.quantity
		end
	end
	if moneyAward > 0 then
		-- check for followers which give bonus gold
		local multiplier = 1
		for _, followerId in ipairs(info.followers) do
			for _, trait in ipairs(C_Garrison.GetFollowerAbilities(followerId)) do
				if trait.id == GOLD_TRAIT_ID then
					multiplier = multiplier + 1
				end
			end
		end
		moneyAward = moneyAward * multiplier
		TSM.Accounting.Money.InsertGarrisonIncome(moneyAward)
	end
end
