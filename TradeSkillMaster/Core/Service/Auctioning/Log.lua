-- ------------------------------------------------------------------------------ --
--                           TradeSkillMaster_Auctioning                          --
--           http://www.curse.com/addons/wow/tradeskillmaster_auctioning          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Log = TSM.Auctioning:NewPackage("Log")
local L = TSM.L
local private = { db = nil }
local RED = "|cffff2211"
local ORANGE = "|cffff8811"
local GREEN = "|cff22ff22"
local CYAN = "|cff99ffff"
local REASON_STRINGS = {
	-- general
	invalidItemGroup = RED .. L["Item/Group is invalid (see chat)."] .. "|r",
	invalidSeller = RED .. L["Invalid seller data returned by server."] .. "|r",
	-- post scan
	postDisabled = ORANGE .. L["Posting disabled."] .. "|r",
	postNotEnough = ORANGE .. L["Not enough items in bags."] .. "|r",
	postMaxExpires = ORANGE .. L["Above max expires."] .. "|r",
	postBelowMin = ORANGE .. L["Cheapest auction below min price."] .. "|r",
	postTooMany = CYAN .. L["Maximum amount already posted."] .. "|r",
	postNormal = GREEN .. L["Posting at normal price."] .. "|r",
	postResetMin = GREEN .. L["Below min price. Posting at min price."] .. "|r",
	postResetMax = GREEN .. L["Below min price. Posting at max price."] .. "|r",
	postResetNormal = GREEN .. L["Below min price. Posting at normal price."] .. "|r",
	postAboveMaxMin = GREEN .. L["Above max price. Posting at min price."] .. "|r",
	postAboveMaxMax = GREEN .. L["Above max price. Posting at max price."] .. "|r",
	postAboveMaxNormal = GREEN .. L["Above max price. Posting at normal price."] .. "|r",
	postAboveMaxNoPost = ORANGE .. L["Above max price. Not posting."] .. "|r",
	postUndercut = GREEN .. L["Undercutting competition."] .. "|r",
	postPlayer = GREEN .. L["Posting at your current price."] .. "|r",
	postWhitelist = GREEN .. L["Posting at whitelisted player's price."] .. "|r",
	postWhitelistNoPost = ORANGE .. L["Lowest auction by whitelisted player."] .. "|r",
	postBlacklist = GREEN .. L["Undercutting blacklisted player."] .. "|r",
	-- cancel scan
	cancelDisabled = ORANGE .. L["Canceling disabled."] .. "|r",
	cancelNotUndercut = GREEN .. L["Your auction has not been undercut."] .. "|r",
	cancelBid = CYAN .. L["Auction has been bid on."] .. "|r",
	cancelKeepPosted = CYAN .. L["Keeping undercut auctions posted."] .. "|r",
	cancelBelowMin = ORANGE .. L["Not canceling auction below min price."] .. "|r",
	cancelAtReset = GREEN .. L["Not canceling auction at reset price."] .. "|r",
	cancelAtNormal = GREEN .. L["At normal price and not undercut."] .. "|r",
	cancelAtAboveMax = GREEN .. L["At above max price and not undercut."] .. "|r",
	cancelAtWhitelist = GREEN .. L["Posted at whitelisted player's price."] .. "|r",
	cancelAll = CYAN .. L["Canceling all auctions."] .. "|r",
	cancelUndercut = RED .. L["You've been undercut."] .. "|r",
	cancelRepost = CYAN .. L["Canceling to repost at higher price."] .. "|r",
	cancelReset = CYAN .. L["Canceling to repost at reset price."] .. "|r",
	cancelWhitelistUndercut = RED .. L["Undercut by whitelisted player."] .. "|r",
	cancelPlayerUndercut = CYAN .. L["Canceling auction which you've undercut."] .. "|r",
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Log.OnInitialize()
	private.db = TSMAPI_FOUR.Database.NewSchema("AUCTIONING_LOG")
		:AddNumberField("index")
		:AddStringField("itemString")
		:AddStringField("seller")
		:AddNumberField("buyout")
		:AddStringField("operation")
		:AddStringField("info")
		:AddIndex("index")
		:Commit()
end

function Log.Truncate()
	private.db:Truncate()
end

function Log.CreateQuery()
	return private.db:NewQuery()
		:InnerJoin(TSM.ItemInfo.GetDBForJoin(), "itemString")
		:OrderBy("index", true)
end

function Log.SetQueryUpdatesPaused(paused)
	private.db:SetQueryUpdatesPaused(paused)
end

function Log.AddEntry(itemString, operationName, reasonKey, seller, buyout, index)
	local reasonStr = REASON_STRINGS[reasonKey]
	assert(reasonStr)
	private.db:NewRow()
		:SetField("itemString", itemString)
		:SetField("seller", seller)
		:SetField("buyout", buyout)
		:SetField("operation", operationName)
		:SetField("info", reasonStr)
		:SetField("index", index)
		:Create()
end
