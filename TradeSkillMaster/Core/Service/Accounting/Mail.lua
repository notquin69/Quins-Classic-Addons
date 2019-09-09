-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Mail = TSM.Accounting:NewPackage("Mail", "AceHook-3.0")
local private = {}
local SECONDS_PER_DAY = 24 * 60 * 60
local EXPIRED_MATCH_TEXT = AUCTION_EXPIRED_MAIL_SUBJECT:gsub("%%s", "")
local CANCELLED_MATCH_TEXT = AUCTION_REMOVED_MAIL_SUBJECT:gsub("%%s", "")
local OUTBID_MATCH_TEXT = AUCTION_OUTBID_MAIL_SUBJECT:gsub("%%s", "(.+)")



-- ============================================================================
-- Module Functions
-- ============================================================================

function Mail.OnInitialize()
	TSMAPI_FOUR.Event.Register("MAIL_SHOW", function() TSMAPI_FOUR.Delay.AfterTime("ACCOUNTING_GET_SELLERS", 0.1, private.RequestSellerInfo, 0.1) end)
	TSMAPI_FOUR.Event.Register("MAIL_CLOSED", function() TSMAPI_FOUR.Delay.Cancel("ACCOUNTING_GET_SELLERS") end)
	Mail:RawHook("TakeInboxItem", function(...) Mail:ScanCollectedMail("TakeInboxItem", 1, ...) end, true)
	Mail:RawHook("TakeInboxMoney", function(...) Mail:ScanCollectedMail("TakeInboxMoney", 1, ...) end, true)
	Mail:RawHook("AutoLootMailItem", function(...) Mail:ScanCollectedMail("AutoLootMailItem", 1, ...) end, true)
	Mail:RawHook("SendMail", private.CheckSendMail, true)
end



-- ============================================================================
-- Inbox Functions
-- ============================================================================

function private.RequestSellerInfo()
	local isDone = true
	for i = 1, GetInboxNumItems() do
		local invoiceType, _, seller = GetInboxInvoiceInfo(i)
		if invoiceType and seller == "" then
			isDone = false
		end
	end
	if isDone and GetInboxNumItems() > 0 then
		TSMAPI_FOUR.Delay.Cancel("ACCOUNTING_GET_SELLERS")
	end
end

function private:CanLootMailIndex(index, copper)
	local currentMoney = GetMoney()
	assert(currentMoney <= MAXIMUM_BID_PRICE)
	-- check if this would put them over the gold cap
	if currentMoney + copper > MAXIMUM_BID_PRICE then return end
	local _, _, _, _, _, _, _, itemCount = GetInboxHeaderInfo(index)
	if not itemCount or itemCount == 0 then return true end
	for j = 1, ATTACHMENTS_MAX_RECEIVE do
		-- TODO: prevent items that you can't loot because of internal mail error
		if CalculateTotalNumberOfFreeBagSlots() <= 0 then
			return
		end
		local link = GetInboxItemLink(index, j)
		local itemString = TSMAPI_FOUR.Item.ToItemString(link)
		local _, _, _, count = GetInboxItem(index, j)
		local quantity = count or 0
		local maxUnique = private.GetInboxMaxUnique(index, j)
		-- dont record unique items that we can't loot
		if maxUnique > 0 and maxUnique < TSMAPI_FOUR.Inventory.GetPlayerTotals(itemString) + quantity then
			return
		end
		if itemString then
			for bag = 0, NUM_BAG_SLOTS do
				if TSMAPI_FOUR.Inventory.ItemWillGoInBag(link, bag) then
					for slot = 1, GetContainerNumSlots(bag) do
						local iString = TSMAPI_FOUR.Item.ToItemString(GetContainerItemLink(bag, slot))
						if iString == itemString then
							local _, stackSize = GetContainerItemInfo(bag, slot)
							local maxStackSize = TSMAPI_FOUR.Item.GetMaxStack(itemString) or 1
							if (maxStackSize - stackSize) >= quantity then
								return true
							end
						elseif not iString then
							return true
						end
					end
				end
			end
		end
	end
end

function private.GetInboxMaxUnique(index, num)
	if not num then
		num = 1
	end

	if not TSMScanTooltip then
		CreateFrame("GameTooltip", "TSMScanTooltip", UIParent, "GameTooltipTemplate")
	end

	TSMScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	TSMScanTooltip:ClearLines()

	local _, speciesId = TSMScanTooltip:SetInboxItem(index, num)
	if (speciesId or 0) > 0 then
		return 0
	else
		for id = 2, TSMScanTooltip:NumLines() do
			local text = private.GetTooltipText(_G["TSMScanTooltipTextLeft"..id])
			if text then
				if text == ITEM_UNIQUE then
					return 1
				else
					local match = text and strmatch(text, "^"..ITEM_UNIQUE.." %((%d+)%)$")
					if match then
						return tonumber(match)
					end
				end
			end
		end
	end

	return 0
end

function private.GetTooltipText(text)
	local textStr = strtrim(text and text:GetText() or "")
	if textStr == "" then return end

	return textStr
end

-- scans the mail that the player just attempted to collected (Pre-Hook)
function Mail:ScanCollectedMail(oFunc, attempt, index, subIndex)
	local invoiceType, itemName, buyer, bid, _, _, ahcut, _, _, _, quantity = GetInboxInvoiceInfo(index)
	local _, stationeryIcon, sender, subject, money, codAmount, daysLeft = GetInboxHeaderInfo(index)
	if not subject then return end
	if attempt > 2 then
		if buyer == "" then
			buyer = "?"
		elseif sender == "" then
			sender = "?"
		end
	end

	local success = false
	if invoiceType == "seller" and buyer and buyer ~= "" then -- AH Sales
		local saleTime = (time() + (daysLeft - 30) * SECONDS_PER_DAY)
		local itemString = TSM.ItemInfo.ItemNameToItemString(itemName)
		if not itemString or itemString == TSM.CONST.UNKNOWN_ITEM_ITEMSTRING then
			itemString = TSM.Inventory.AuctionTracking.GetSaleHintItemString(itemName, quantity, bid)
		end
		if private:CanLootMailIndex(index, (bid - ahcut)) then
			if itemString then
				local copper = floor((bid - ahcut) / quantity + 0.5)
				TSM.Accounting.Transactions.InsertAuctionSale(itemString, quantity, copper, buyer, saleTime)
			end
			success = true
		end
	elseif invoiceType == "buyer" and buyer and buyer ~= "" then -- AH Buys
		local link = (subIndex or 1) == 1 and private:GetFirstInboxItemLink(index) or GetInboxItemLink(index, subIndex or 1)
		local itemString = TSMAPI_FOUR.Item.ToItemString(link)
		if itemString and private:CanLootMailIndex(index, 0) then
			local copper = floor(bid / quantity + 0.5)
			local buyTime = (time() + (daysLeft - 30) * SECONDS_PER_DAY)
			TSM.Accounting.Transactions.InsertAuctionBuy(itemString, quantity, copper, buyer, buyTime)
			success = true
		end
	elseif codAmount > 0 then -- COD Buys (only if all attachments are same item)
		local link = (subIndex or 1) == 1 and private:GetFirstInboxItemLink(index) or GetInboxItemLink(index, subIndex or 1)
		local itemString = TSMAPI_FOUR.Item.ToItemString(link)
		if itemString and sender then
			local name = TSMAPI_FOUR.Item.GetName(link)
			local total = 0
			local stacks = 0
			local ignore = false
			for i = 1, ATTACHMENTS_MAX_RECEIVE do
				local nameCheck, _, _, count = GetInboxItem(index, i)
				if nameCheck and count then
					if nameCheck == name then
						total = total + count
						stacks = stacks + 1
					else
						ignore = true
					end
				end
			end

			if total ~= 0 and not ignore and private:CanLootMailIndex(index, codAmount) then
				local copper = floor(codAmount / total + 0.5)
				local buyTime = (time() + (daysLeft - 3) * SECONDS_PER_DAY)
				local maxStack = TSMAPI_FOUR.Item.GetMaxStack(link)
				for _ = 1, stacks do
					local stackSize = (total >= maxStack) and maxStack or total
					TSM.Accounting.Transactions.InsertCODBuy(itemString, stackSize, copper, sender, buyTime)
					total = total - stackSize
					if total <= 0 then
						break
					end
				end
			end
			success = true
		end
	elseif money > 0 and invoiceType ~= "seller" and not strfind(subject, OUTBID_MATCH_TEXT) then
		local str = nil
		if GetLocale() == "deDE" then
			str = gsub(subject, gsub(COD_PAYMENT, TSMAPI_FOUR.Util.StrEscape("%1$s"), ""), "")
		else
			str = gsub(subject, gsub(COD_PAYMENT, TSMAPI_FOUR.Util.StrEscape("%s"), ""), "")
		end
		local saleTime = (time() + (daysLeft - 31) * SECONDS_PER_DAY)
		if sender and private:CanLootMailIndex(index, money) then
			if str and strfind(str, "TSM$") then -- payment for a COD the player sent
				local codName = strtrim(strmatch(str, "([^%(]+)"))
				local qty = strmatch(str, "%(([0-9]+)%)")
				qty = tonumber(qty)
				local itemString = TSM.ItemInfo.ItemNameToItemString(codName)
				if itemString then
					local copper = floor(money / qty + 0.5)
					local maxStack = TSMAPI_FOUR.Item.GetMaxStack(itemString) or 1
					local stacks = ceil(qty / maxStack)

					for _ = 1, stacks do
						local stackSize = (qty >= maxStack) and maxStack or qty
						TSM.Accounting.Transactions.InsertCODSale(itemString, stackSize, copper, sender, saleTime)
						qty = qty - stackSize
						if qty <= 0 then
							break
						end
					end
				end
			else -- record a money transfer
				TSM.Accounting.Money.InsertMoneyTransferIncome(money, sender, saleTime)
			end
			success = true
		end
	elseif strfind(subject, EXPIRED_MATCH_TEXT) then -- expired auction
		local expiredTime = (time() + (daysLeft - 30) * SECONDS_PER_DAY)
		local link = (subIndex or 1) == 1 and private:GetFirstInboxItemLink(index) or GetInboxItemLink(index, subIndex or 1)
		local _, _, _, count = GetInboxItem(index, subIndex or 1)
		local qty = count or 0
		local itemString = TSMAPI_FOUR.Item.ToItemString(link)
		if private:CanLootMailIndex(index, 0) and itemString and qty then
			TSM.Accounting.Auctions.InsertExpire(itemString, qty, expiredTime)
			success = true
		end
	elseif strfind(subject, CANCELLED_MATCH_TEXT) then -- cancelled auction
		local cancelledTime = (time() + (daysLeft - 30) * SECONDS_PER_DAY)
		local link = (subIndex or 1) == 1 and private:GetFirstInboxItemLink(index) or GetInboxItemLink(index, subIndex or 1)
		local _, _, _, count = GetInboxItem(index, subIndex or 1)
		local qty = count or 0
		local itemString = TSMAPI_FOUR.Item.ToItemString(link)
		if private:CanLootMailIndex(index, 0) and itemString and qty then
			TSM.Accounting.Auctions.InsertCancel(itemString, qty, cancelledTime)
			success = true
		end
	end

	if success then
		Mail.hooks[oFunc](index, subIndex)
	elseif (not stationeryIcon or (invoiceType and (not buyer or buyer == ""))) and attempt <= 5 then
		TSMAPI_FOUR.Delay.AfterTime("accountingHookDelay", 0.2, function() Mail:ScanCollectedMail(oFunc, attempt + 1, index, subIndex) end)
	elseif attempt > 5 then
		Mail.hooks[oFunc](index, subIndex)
	else
		Mail.hooks[oFunc](index, subIndex)
	end
end



-- ============================================================================
-- Sending Functions
-- ============================================================================

-- scans the mail that the player just attempted to send (Pre-Hook) to see if COD
function private.CheckSendMail(destination, currentSubject, ...)
	local codAmount = GetSendMailCOD()
	local moneyAmount = GetSendMailMoney()
	local mailCost = GetSendMailPrice()
	local subject
	local total = 0
	local ignore = false

	if codAmount ~= 0 then
		for i = 1, 12 do
			local itemName, _, _, count = GetSendMailItem(i)
			if itemName and count then
				if not subject then
					subject = itemName
				end

				if subject == itemName then
					total = total + count
				else
					ignore = true
				end
			end
		end
	else
		ignore = true
	end

	if moneyAmount > 0 then
		-- add a record for the money transfer
		TSM.Accounting.Money.InsertMoneyTransferExpense(moneyAmount, destination)
		mailCost = mailCost - moneyAmount
	end
	TSM.Accounting.Money.InsertPostageExpense(mailCost, destination)

	if not ignore then
		Mail.hooks.SendMail(destination, subject .. " (" .. total .. ") TSM", ...)
	else
		Mail.hooks.SendMail(destination, currentSubject, ...)
	end
end

function private:GetFirstInboxItemLink(index)
	if not TSMAccountingMailTooltip then
		CreateFrame("GameTooltip", "TSMAccountingMailTooltip", UIParent, "GameTooltipTemplate")
	end
	TSMAccountingMailTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	TSMAccountingMailTooltip:ClearLines()
	local _, speciesId, level, breedQuality, maxHealth, power, speed = TSMAccountingMailTooltip:SetInboxItem(index)
	local link = nil
	if (speciesId or 0) > 0 then
		link = TSMAPI_FOUR.Item.GetLink(strjoin(":", "p", speciesId, level, breedQuality, maxHealth, power, speed))
	else
		link = GetInboxItemLink(index, 1)
	end
	TSMAccountingMailTooltip:Hide()
	return link
end
