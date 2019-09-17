-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Auctioning = TSM.Operations:NewPackage("Auctioning")
local private = {}
local L = TSM.L
local OPERATION_INFO = {
	-- general
	matchStackSize = { type = "boolean", default = false },
	blacklist = { type = "string", default = "" },
	ignoreLowDuration = { type = "number", default = 0 },
	-- post
	stackSize = { type = "number", default = 1 },
	stackSizeIsCap = { type = "boolean", default = false },
	postCap = { type = "number", default = 5 },
	keepQuantity = { type = "number", default = 0 },
	keepQtySources = { type = "table", default = {} },
	maxExpires = { type = "number", default = 0 },
	duration = { type = "number", default = 24, customSanitizeFunction = nil },
	bidPercent = { type = "number", default = 1 },
	undercut = { type = "string", default = "1c" },
	minPrice = { type = "string", default = "check(first(crafting,dbmarket,dbregionmarketavg),max(0.25*avg(crafting,dbmarket,dbregionmarketavg),1.5*vendorsell))" },
	maxPrice = { type = "string", default = "check(first(crafting,dbmarket,dbregionmarketavg),max(5*avg(crafting,dbmarket,dbregionmarketavg),30*vendorsell))" },
	normalPrice = { type = "string", default = "check(first(crafting,dbmarket,dbregionmarketavg),max(2*avg(crafting,dbmarket,dbregionmarketavg),12*vendorsell))" },
	priceReset = { type = "string", default = "none" },
	aboveMax = { type = "string", default = "normalPrice" },
	-- cancel
	cancelUndercut = { type = "boolean", default = true },
	keepPosted = { type = "number", default = 0 },
	cancelRepost = { type = "boolean", default = true },
	cancelRepostThreshold = { type = "string", default = "1g" },
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Auctioning.OnInitialize()
	OPERATION_INFO.duration.customSanitizeFunction = private.SanitizeDuration
	TSM.Operations.Register("Auctioning", L["Auctioning"], OPERATION_INFO, 20, private.GetOperationInfo)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.SanitizeDuration(value)
	-- convert from 12/24/48 durations to 1/2/3 API values
	if value == 12 then
		return 1
	elseif value == 24 then
		return 2
	elseif value == 48 then
		return 3
	else
		return value
	end
end

function private.GetOperationInfo(operationSettings)
	local parts = TSMAPI_FOUR.Util.AcquireTempTable()

	-- get the post string
	if operationSettings.postCap == 0 then
		tinsert(parts, L["No posting."])
	else
		tinsert(parts, format(L["Posting %d stack(s) of %d for %d hours."], operationSettings.postCap, operationSettings.stackSize, operationSettings.duration))
	end

	-- get the cancel string
	if operationSettings.cancelUndercut and operationSettings.cancelRepost then
		tinsert(parts, format(L["Canceling undercut auctions and to repost higher."]))
	elseif operationSettings.cancelUndercut then
		tinsert(parts, format(L["Canceling undercut auctions."]))
	elseif operationSettings.cancelRepost then
		tinsert(parts, format(L["Canceling to repost higher."]))
	else
		tinsert(parts, L["Not canceling."])
	end

	local result = table.concat(parts, " ")
	TSMAPI_FOUR.Util.ReleaseTempTable(parts)
	return result
end
