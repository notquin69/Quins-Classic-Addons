-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Groups = TSM.Mailing:NewPackage("Groups")
local private = {
	thread = nil,
	sendDone = false,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Groups.OnInitialize()
	private.thread = TSMAPI_FOUR.Thread.New("MAIL_GROUPS", private.GroupsMailThread)
end

function Groups.KillThread()
	TSMAPI_FOUR.Thread.Kill(private.thread)
end

function Groups.StartSending(callback, groupList, sendRepeat)
	TSMAPI_FOUR.Thread.Kill(private.thread)

	TSMAPI_FOUR.Thread.SetCallback(private.thread, callback)
	TSMAPI_FOUR.Thread.Start(private.thread, groupList, sendRepeat)
end



-- ============================================================================
-- Group Sending Thread
-- ============================================================================

function private.GroupsMailThread(groupList, sendRepeat)
	while true do
		local targets = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
		for _, groupPath in ipairs(groupList) do
			local reserved = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
			for _, _, operationSettings in TSM.Operations.GroupOperationIterator("Mailing", groupPath) do
				if groupPath == TSM.CONST.ROOT_GROUP_PATH then
					-- TODO
				else
					if operationSettings.target ~= "" then
						if not targets[operationSettings.target] then
							targets[operationSettings.target] = TSMAPI_FOUR.Thread.AcquireSafeTempTable()
						end
						for _, itemString in TSM.Groups.ItemIterator(groupPath) do
							itemString = TSMAPI_FOUR.Item.ToBaseItemString(itemString, true)
							local quantity = private.GetItemQuantity(itemString, reserved, operationSettings)
							if TSMAPI_FOUR.PlayerInfo.IsPlayer(operationSettings.target) then
								reserved[itemString] = quantity
							elseif quantity > 0 then
								targets[operationSettings.target][itemString] = quantity
							end
						end
					end
				end
			end

			TSMAPI_FOUR.Thread.ReleaseSafeTempTable(reserved)
		end

		for name, items in pairs(targets) do
			if not TSMAPI_FOUR.PlayerInfo.IsPlayer(name) and next(items) then
				private.SendItems(name, items)
				TSMAPI_FOUR.Thread.Sleep(0.5)
			end
			TSMAPI_FOUR.Thread.ReleaseSafeTempTable(items)
		end

		TSMAPI_FOUR.Thread.ReleaseSafeTempTable(targets)

		if sendRepeat then
			TSMAPI_FOUR.Thread.Sleep(TSM.db.global.mailingOptions.resendDelay * 60)
		else
			break
		end
	end
end

function private.SendItems(target, items)
	private.sendDone = false
	TSM.Mailing.Send.StartSending(private.SendCallback, target, "", "", 0, items, true)
	while not private.sendDone do
		TSMAPI_FOUR.Thread.Yield(true)
	end
end

function private.SendCallback()
	private.sendDone = true
end

function private.GetItemQuantity(itemString, reserved, operationSettings)
	local numToSend = 0
	local playerQty = TSMAPI_FOUR.Inventory.GetBagQuantity(itemString)
	local reservedQty = reserved[itemString] or 0
	local numAvailable = playerQty - operationSettings.keepQty - reservedQty
	if numAvailable > 0 then
		if operationSettings.maxQtyEnabled then
			if operationSettings.restock then
				local targetQty = private.GetTargetQuantity(operationSettings.target, itemString, operationSettings.restockSources)
				if TSMAPI_FOUR.PlayerInfo.IsPlayer(operationSettings.target) and targetQty <= operationSettings.maxQty then
					numToSend = numAvailable
				else
					numToSend = min(numAvailable, operationSettings.maxQty - targetQty)
				end
				if TSMAPI_FOUR.PlayerInfo.IsPlayer(operationSettings.target) then
					numToSend = numAvailable - (targetQty - operationSettings.maxQty)
				end
			else
				numToSend = min(numAvailable, operationSettings.maxQty)
			end
		else
			if TSMAPI_FOUR.PlayerInfo.IsPlayer(operationSettings.target) then
				numToSend = 0
			else
				numToSend = numAvailable
			end
		end
	end

	return numToSend
end

function private.GetTargetQuantity(player, itemString, sources)
	if player then
		player = strtrim(strmatch(player, "^[^-]+"))
	end
	local num = TSMAPI_FOUR.Inventory.GetBagQuantity(itemString, player) + TSMAPI_FOUR.Inventory.GetMailQuantity(itemString, player) + TSMAPI_FOUR.Inventory.GetAuctionQuantity(itemString, player)
	if sources then
		if sources.guild then
			num = num + TSMAPI_FOUR.Inventory.GetGuildQuantity(itemString, TSMAPI_FOUR.PlayerInfo.GetPlayerGuild(player))
		end
		if sources.bank then
			num = num + TSMAPI_FOUR.Inventory.GetBankQuantity(itemString, player) + TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString, player)
		end
	end

	return num
end
