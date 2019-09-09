-- ------------------------------------------------------------------------------ --
--                           TradeSkillMaster_Accounting                          --
--           http://www.curse.com/addons/wow/tradeskillmaster_accounting          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Trade = TSM.Accounting:NewPackage("Trade")
local L = TSM.L
local private = { tradeInfo = nil, popupContext = nil }



-- ============================================================================
-- Module Functions
-- ============================================================================

function Trade.OnInitialize()
	TSMAPI_FOUR.Event.Register("TRADE_ACCEPT_UPDATE", private.OnAcceptUpdate)
	TSMAPI_FOUR.Event.Register("UI_INFO_MESSAGE", private.OnChatMsg)
end



-- ============================================================================
-- Trade Functions
-- ============================================================================

function private.OnAcceptUpdate(_, player, target)
	if (player == 1 or target == 1) and not (GetTradePlayerItemLink(7) or GetTradeTargetItemLink(7)) then
		-- update tradeInfo
		private.tradeInfo = { player = {}, target = {} }
		private.tradeInfo.player.money = tonumber(GetPlayerTradeMoney())
		private.tradeInfo.target.money = tonumber(GetTargetTradeMoney())
		private.tradeInfo.target.name = UnitName("NPC")

		for i = 1, 6 do
			local targetLink = GetTradeTargetItemLink(i)
			local _, _, targetCount = GetTradeTargetItemInfo(i)
			if targetLink then
				tinsert(private.tradeInfo.target, { itemString = TSMAPI_FOUR.Item.ToItemString(targetLink), count = targetCount })
			end

			local playerLink = GetTradePlayerItemLink(i)
			local _, _, playerCount = GetTradePlayerItemInfo(i)
			if playerLink then
				tinsert(private.tradeInfo.player, { itemString = TSMAPI_FOUR.Item.ToItemString(playerLink), count = playerCount })
			end
		end
	else
		private.tradeInfo = nil
	end
end

function private.OnChatMsg(_, msg)
	if not TSM.db.global.accountingOptions.trackTrades then
		return
	end
	if msg == LE_GAME_ERR_TRADE_COMPLETE and private.tradeInfo then
		-- trade went through
		local tradeType, itemString, count, money = nil, nil, nil, nil
		if private.tradeInfo.player.money > 0 and #private.tradeInfo.player == 0 and private.tradeInfo.target.money == 0 and #private.tradeInfo.target > 0 then
			-- player bought items
			for i = 1, #private.tradeInfo.target do
				local data = private.tradeInfo.target[i]
				if not itemString then
					itemString = data.itemString
					count = data.count
				elseif itemString == data.itemString then
					count = count + data.count
				else
					return
				end
			end
			tradeType = "buy"
			money = private.tradeInfo.player.money
		elseif private.tradeInfo.player.money == 0 and #private.tradeInfo.player > 0 and private.tradeInfo.target.money > 0 and #private.tradeInfo.target == 0 then
			-- player sold items
			for i = 1, #private.tradeInfo.player do
				local data = private.tradeInfo.player[i]
				if not itemString then
					itemString = data.itemString
					count = data.count
				elseif itemString == data.itemString then
					count = count + data.count
				else
					return
				end
			end
			tradeType = "sale"
			money = private.tradeInfo.target.money
		end

		if not tradeType or not itemString or not count then
			return
		end
		local insertInfo = TSMAPI_FOUR.Util.AcquireTempTable()
		insertInfo.type = tradeType
		insertInfo.itemString = itemString
		insertInfo.price = money / count
		insertInfo.count = count
		insertInfo.name = private.tradeInfo.target.name
		local gotText, gaveText = nil, nil
		if tradeType == "buy" then
			gotText = format("%sx%d", TSMAPI_FOUR.Item.GetLink(itemString), count)
			gaveText = TSM.Money.ToString(money)
		elseif tradeType == "sale" then
			gaveText = format("%sx%d", TSMAPI_FOUR.Item.GetLink(itemString), count)
			gotText = TSM.Money.ToString(money)
		else
			error("Invalid tradeType: "..tostring(tradeType))
		end

		if TSM.db.global.accountingOptions.autoTrackTrades then
			private.DoInsert(insertInfo)
			TSMAPI_FOUR.Util.ReleaseTempTable(insertInfo)
		else
			if private.popupContext then
				-- popup already visible so ignore this
				TSMAPI_FOUR.Util.ReleaseTempTable(insertInfo)
				return
			end
			private.popupContext = insertInfo
			if not StaticPopupDialogs["TSMAccountingOnTrade"] then
				StaticPopupDialogs["TSMAccountingOnTrade"] = {
					button1 = YES,
					button2 = NO,
					timeout = 0,
					whileDead = true,
					hideOnEscape = true,
					OnAccept = function()
						private.DoInsert(private.popupContext)
						TSMAPI_FOUR.Util.ReleaseTempTable(private.popupContext)
						private.popupContext = nil
					end,
					OnCancel = function()
						TSMAPI_FOUR.Util.ReleaseTempTable(private.popupContext)
						private.popupContext = nil
					end,
				}
			end
			StaticPopupDialogs["TSMAccountingOnTrade"].text = format(L["TSM_Accounting detected that you just traded %s %s in return for %s. Would you like Accounting to store a record of this trade?"], insertInfo.name, gaveText, gotText)
			TSMAPI_FOUR.Util.ShowStaticPopupDialog("TSMAccountingOnTrade")
		end
	end
end

function private.DoInsert(info)
	if info.type == "sale" then
		TSM.Accounting.Transactions.InsertTradeSale(info.itemString, info.count, info.price, info.name)
	elseif info.type == "buy" then
		TSM.Accounting.Transactions.InsertTradeBuy(info.itemString, info.count, info.price, info.name)
	else
		error("Unknown type: "..tostring(info.type))
	end
end
