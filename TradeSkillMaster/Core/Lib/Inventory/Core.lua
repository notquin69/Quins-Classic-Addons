-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Inventory TSMAPI_FOUR Functions
-- @module Inventory

TSMAPI_FOUR.Inventory = {}
local _, TSM = ...
local Inventory = TSM:NewPackage("Inventory")
local private = {}
local PLAYER_NAME = UnitName("player")



-- ============================================================================
-- Module Functions
-- ============================================================================

function Inventory.OnInitialize()
	private.db = TSMAPI_FOUR.Database.NewSchema("INVENTORY_SUMMARY")
		:AddUniqueStringField("itemString")
		:AddNumberField("bagQuantity")
		:AddNumberField("bankQuantity")
		:AddNumberField("reagentBankQuantity")
		:AddNumberField("auctionQuantity")
		:AddNumberField("mailQuantity")
		:AddNumberField("guildQuantity")
		:AddNumberField("altQuantity")
		:AddNumberField("totalQuantity")
		:Commit()

	local items = TSMAPI_FOUR.Util.AcquireTempTable()
	local itemQuantities = TSMAPI_FOUR.Util.AcquireTempTable()
	itemQuantities.bagQuantity = TSMAPI_FOUR.Util.AcquireTempTable()
	itemQuantities.bankQuantity = TSMAPI_FOUR.Util.AcquireTempTable()
	itemQuantities.reagentBankQuantity = TSMAPI_FOUR.Util.AcquireTempTable()
	itemQuantities.auctionQuantity = TSMAPI_FOUR.Util.AcquireTempTable()
	itemQuantities.mailQuantity = TSMAPI_FOUR.Util.AcquireTempTable()
	local altItemQuantity = TSMAPI_FOUR.Util.AcquireTempTable()

	for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
		local isFactionrealm = factionrealm == (UnitFactionGroup("player").." - "..GetRealmName())
		for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
			local isPlayer = isFactionrealm and TSMAPI_FOUR.PlayerInfo.IsPlayer(character) and character == UnitName("player")
			for key, tbl in pairs(itemQuantities) do
				local dbTbl = private.GetCharacterInventoryData(key, character, factionrealm)
				for itemString, quantity in pairs(dbTbl) do
					if type(quantity) ~= "number" or quantity <= 0 then
						dbTbl[itemString] = nil
					elseif isPlayer then
						tbl[itemString] = (tbl[itemString] or 0) + quantity
						items[itemString] = true
					else
						altItemQuantity[itemString] = (altItemQuantity[itemString] or 0) + quantity
						items[itemString] = true
					end
				end
			end
			local pendingMail = TSM.db:Get("factionrealm", factionrealm, "internalData", "pendingMail")[character]
			if pendingMail then
				for itemString, quantity in pairs(pendingMail) do
					if type(quantity) ~= "number" or quantity <= 0 then
						pendingMail[itemString] = nil
					elseif isPlayer then
						itemQuantities.mailQuantity[itemString] = (itemQuantities.mailQuantity[itemString] or 0) + quantity
						items[itemString] = true
					else
						altItemQuantity[itemString] = (altItemQuantity[itemString] or 0) + quantity
						items[itemString] = true
					end
				end
			end
		end
	end

	private.db:BulkInsertStart()
	for itemString in pairs(items) do
		local bagQuantity = itemQuantities.bagQuantity[itemString] or 0
		local bankQuantity = itemQuantities.bankQuantity[itemString] or 0
		local reagentBankQuantity = itemQuantities.reagentBankQuantity[itemString] or 0
		local auctionQuantity = itemQuantities.auctionQuantity[itemString] or 0
		local mailQuantity = itemQuantities.mailQuantity[itemString] or 0
		local altQuantity = altItemQuantity[itemString] or 0
		local totalQuantity = bagQuantity + bankQuantity + reagentBankQuantity + auctionQuantity + mailQuantity + altQuantity
		assert(totalQuantity > 0)
		-- guildQuantity is set later, so just set it to 0 for now
		private.db:BulkInsertNewRow(itemString, bagQuantity, bankQuantity, reagentBankQuantity, auctionQuantity, mailQuantity, 0, altQuantity, totalQuantity)
	end
	private.db:BulkInsertEnd()

	for _, tbl in pairs(itemQuantities) do
		TSMAPI_FOUR.Util.ReleaseTempTable(tbl)
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(itemQuantities)
	TSMAPI_FOUR.Util.ReleaseTempTable(altItemQuantity)
	TSMAPI_FOUR.Util.ReleaseTempTable(items)
end

function Inventory.OnGuildLoaded()
	local guildName = GetGuildInfo("player")
	private.WipeQuantity("guildQuantity")
	for itemString, quantity in pairs(TSM.db.factionrealm.internalData.guildVaults[guildName]) do
		if quantity > 0 then
			private.UpdateQuantity(itemString, "guildQuantity", quantity)
		else
			TSM.db.factionrealm.internalData.guildVaults[guildName][itemString] = nil
		end
	end
end

function Inventory.ChangeBagItemTotal(bag, itemString, changeQuantity)
	local totalsTable = nil
	local field = nil
	if bag >= BACKPACK_CONTAINER and bag <= NUM_BAG_SLOTS then
		totalsTable = TSM.db.sync.internalData.bagQuantity
		field = "bagQuantity"
	elseif bag == BANK_CONTAINER or (bag > NUM_BAG_SLOTS and bag <= NUM_BAG_SLOTS + NUM_BANKBAGSLOTS) then
		totalsTable = TSM.db.sync.internalData.bankQuantity
		field = "bankQuantity"
	elseif bag == REAGENTBANK_CONTAINER then
		totalsTable = TSM.db.sync.internalData.reagentBankQuantity
		field = "reagentBankQuantity"
	else
		error("Unexpected bag: "..tostring(bag))
	end
	totalsTable[itemString] = (totalsTable[itemString] or 0) + changeQuantity
	private.UpdateQuantity(itemString, field, changeQuantity)
	assert(totalsTable[itemString] >= 0)
	if totalsTable[itemString] == 0 then
		totalsTable[itemString] = nil
	end
end

function Inventory.ChangeAuctionQuantity(itemString, qtyToAdd)
	assert(itemString)
	TSM.db.sync.internalData.auctionQuantity[itemString] = (TSM.db.sync.internalData.auctionQuantity[itemString] or 0) + qtyToAdd
	private.UpdateQuantity(itemString, "auctionQuantity", qtyToAdd)
end

function Inventory.ChangeMailQuantity(itemString, qtyToAdd)
	assert(itemString)
	TSM.db.sync.internalData.mailQuantity[itemString] = (TSM.db.sync.internalData.mailQuantity[itemString] or 0) + qtyToAdd
	private.UpdateQuantity(itemString, "mailQuantity", qtyToAdd)
end

function Inventory.ChangePendingMailQuantity(itemString, qtyToAdd, playerName)
	assert(itemString)
	if not playerName then
		playerName = UnitName("player")
	end
	TSM.db.factionrealm.internalData.pendingMail[playerName][itemString] = (TSM.db.factionrealm.internalData.pendingMail[playerName][itemString] or 0) + qtyToAdd
	private.UpdateQuantity(itemString, "mailQuantity", qtyToAdd)
end

function Inventory.ChangeGuildQuantity(itemString, qtyToAdd, guild)
	guild = guild or GetGuildInfo("player")
	assert(guild)
	TSM.db.factionrealm.internalData.guildVaults[guild][itemString] = (TSM.db.factionrealm.internalData.guildVaults[guild][itemString] or 0) + qtyToAdd
	private.UpdateQuantity(itemString, "guildQuantity", qtyToAdd)
end

function Inventory.WipeBagQuantity()
	wipe(TSM.db.sync.internalData.bagQuantity)
	private.WipeQuantity("bagQuantity")
end

function Inventory.WipeAuctionQuantity()
	wipe(TSM.db.sync.internalData.auctionQuantity)
	private.WipeQuantity("auctionQuantity")
end

function Inventory.WipeBankQuantity()
	wipe(TSM.db.sync.internalData.bankQuantity)
	private.WipeQuantity("bankQuantity")
end

function Inventory.WipeReagentBankQuantity()
	wipe(TSM.db.sync.internalData.reagentBankQuantity)
	private.WipeQuantity("reagentBankQuantity")
end

function Inventory.WipeMailQuantity()
	wipe(TSM.db.sync.internalData.mailQuantity)
	private.WipeQuantity("mailQuantity")
end

function Inventory.WipeGuildQuantity(guild)
	assert(guild)
	wipe(TSM.db.factionrealm.internalData.guildVaults[guild])
	private.WipeQuantity("guildQuantity")
end

function Inventory.WipePendingMail(characterName)
	assert(characterName)
	wipe(TSM.db.factionrealm.internalData.pendingMail[characterName])
	private.WipeQuantity("mailQuantity")
end

function Inventory.CreateQuery()
	return private.db:NewQuery()
end



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

function TSMAPI_FOUR.Inventory.GetBagQuantity(itemString, character, factionrealm)
	return private.InventoryQuantityHelper(itemString, "bagQuantity", character, factionrealm)
end

function TSMAPI_FOUR.Inventory.GetBankQuantity(itemString, character, factionrealm)
	return private.InventoryQuantityHelper(itemString, "bankQuantity", character, factionrealm)
end

function TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString, character, factionrealm)
	return private.InventoryQuantityHelper(itemString, "reagentBankQuantity", character, factionrealm)
end

function TSMAPI_FOUR.Inventory.GetAuctionQuantity(itemString, character, factionrealm)
	return private.InventoryQuantityHelper(itemString, "auctionQuantity", character, factionrealm)
end

function TSMAPI_FOUR.Inventory.GetMailQuantity(itemString, character, factionrealm)
	itemString = TSMAPI_FOUR.Item.ToBaseItemString(itemString)
	character = character or PLAYER_NAME
	local pendingQuantity = itemString and TSM.db.factionrealm.internalData.pendingMail[character] and TSM.db.factionrealm.internalData.pendingMail[character][itemString] or 0
	return private.InventoryQuantityHelper(itemString, "mailQuantity", character, factionrealm) + pendingQuantity
end

function TSMAPI_FOUR.Inventory.GetGuildQuantity(itemString, guild)
	itemString = TSMAPI_FOUR.Item.ToBaseItemString(itemString)
	if not itemString then
		return 0
	end
	guild = guild or (IsInGuild() and GetGuildInfo("player") or nil)
	if not guild or TSM.db.factionrealm.coreOptions.ignoreGuilds[guild] then
		return 0
	end
	return TSM.db.factionrealm.internalData.guildVaults[guild] and TSM.db.factionrealm.internalData.guildVaults[guild][itemString] or 0
end

function TSMAPI_FOUR.Inventory.GetPlayerTotals(itemString)
	local numPlayer, numAlts, numAuctions, numAltAuctions = 0, 0, 0, 0
	for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
		for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
			if character == PLAYER_NAME and factionrealm == UnitFactionGroup("player").." - "..GetRealmName() then
				numPlayer = numPlayer + TSMAPI_FOUR.Inventory.GetBagQuantity(itemString)
				numPlayer = numPlayer + TSMAPI_FOUR.Inventory.GetBankQuantity(itemString)
				numPlayer = numPlayer + TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString)
				numPlayer = numPlayer + TSMAPI_FOUR.Inventory.GetMailQuantity(itemString)
			else
				numAlts = numAlts + TSMAPI_FOUR.Inventory.GetBagQuantity(itemString, character, factionrealm)
				numAlts = numAlts + TSMAPI_FOUR.Inventory.GetBankQuantity(itemString, character, factionrealm)
				numAlts = numAlts + TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString, character, factionrealm)
				numAlts = numAlts + TSMAPI_FOUR.Inventory.GetMailQuantity(itemString, character, factionrealm)
				numAltAuctions = numAltAuctions + TSMAPI_FOUR.Inventory.GetAuctionQuantity(itemString, character, factionrealm)
			end
			numAuctions = numAuctions + TSMAPI_FOUR.Inventory.GetAuctionQuantity(itemString, character, factionrealm)
		end
	end
	return numPlayer, numAlts, numAuctions, numAltAuctions
end

function TSMAPI_FOUR.Inventory.GetGuildTotal(itemString)
	itemString = TSMAPI_FOUR.Item.ToBaseItemString(itemString)
	if not itemString then
		return 0
	end
	local numGuild = 0
	for guild, data in pairs(TSM.db.factionrealm.internalData.guildVaults) do
		if not TSM.db.factionrealm.coreOptions.ignoreGuilds[guild] then
			numGuild = numGuild + (data[itemString] or 0)
		end
	end
	return numGuild
end

function TSMAPI_FOUR.Inventory.GetTotalQuantity(itemString)
	itemString = TSMAPI_FOUR.Item.ToBaseItemString(itemString)
	if not itemString then
		return 0
	end
	local numPlayer, numAlts, numAuctions = TSMAPI_FOUR.Inventory.GetPlayerTotals(itemString)
	local numGuild = TSMAPI_FOUR.Inventory.GetGuildTotal(itemString)
	return numPlayer + numAlts + numAuctions + numGuild
end

function TSMAPI_FOUR.Inventory.GetCraftingTotals(ignoreCharacters, otherItems)
	local bagTotal, auctionTotal, otherTotal, total = {}, {}, {}, {}

	for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
		for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
			if not ignoreCharacters[character] then
				for itemString, quantity in pairs(private.GetCharacterInventoryData("bagQuantity", character, factionrealm)) do
					if character == PLAYER_NAME then
						bagTotal[itemString] = (bagTotal[itemString] or 0) + quantity
						total[itemString] = (total[itemString] or 0) + quantity
					else
						otherTotal[itemString] = (otherTotal[itemString] or 0) + quantity
						total[itemString] = (total[itemString] or 0) + quantity
					end
				end
				for itemString, quantity in pairs(private.GetCharacterInventoryData("bankQuantity", character, factionrealm)) do
					otherTotal[itemString] = (otherTotal[itemString] or 0) + quantity
					total[itemString] = (total[itemString] or 0) + quantity
				end
				for itemString, quantity in pairs(private.GetCharacterInventoryData("reagentBankQuantity", character, factionrealm)) do
					if character == PLAYER_NAME then
						if otherItems[itemString] then
							otherTotal[itemString] = (otherTotal[itemString] or 0) + quantity
						else
							bagTotal[itemString] = (bagTotal[itemString] or 0) + quantity
						end
					else
						otherTotal[itemString] = (otherTotal[itemString] or 0) + quantity
					end
					total[itemString] = (total[itemString] or 0) + quantity
				end
				for itemString, quantity in pairs(private.GetCharacterInventoryData("mailQuantity", character, factionrealm)) do
					otherTotal[itemString] = (otherTotal[itemString] or 0) + quantity
					total[itemString] = (total[itemString] or 0) + quantity
				end
				for itemString, quantity in pairs(private.GetCharacterInventoryData("auctionQuantity", character, factionrealm)) do
					auctionTotal[itemString] = (auctionTotal[itemString] or 0) + quantity
					total[itemString] = (total[itemString] or 0) + quantity
				end
			end
		end
	end

	for _, data in pairs(TSM.db.factionrealm.internalData.pendingMail) do
		for itemString, quantity in pairs(data) do
			otherTotal[itemString] = (otherTotal[itemString] or 0) + quantity
			total[itemString] = (total[itemString] or 0) + quantity
		end
	end

	for guild, data in pairs(TSM.db.factionrealm.internalData.guildVaults) do
		if not TSM.db.factionrealm.coreOptions.ignoreGuilds[guild] then
			for itemString, quantity in pairs(data) do
				otherTotal[itemString] = (otherTotal[itemString] or 0) + quantity
				total[itemString] = (total[itemString] or 0) + quantity
			end
		end
	end

	return bagTotal, auctionTotal, otherTotal, total
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetCharacterInventoryData(settingKey, character, factionrealm)
	local scopeKey = character and TSM.db:GetSyncScopeKeyByCharacter(character, factionrealm) or nil
	return TSM.db:Get("sync", scopeKey, "internalData", settingKey)
end

function private.InventoryQuantityHelper(itemString, settingKey, character, factionrealm)
	itemString = TSMAPI_FOUR.Item.ToBaseItemString(itemString)
	if not itemString then
		return 0
	end
	local tbl = private.GetCharacterInventoryData(settingKey, character, factionrealm)
	return tbl and tbl[itemString] or 0
end

function private.UpdateQuantity(itemString, field, quantity)
	assert(itemString and field and quantity)
	assert(quantity ~= 0)

	if not private.db:HasUniqueRow("itemString", itemString) then
		-- create a new row
		private.db:NewRow()
			:SetField("itemString", itemString)
			:SetField("bagQuantity", 0)
			:SetField("bankQuantity", 0)
			:SetField("reagentBankQuantity", 0)
			:SetField("auctionQuantity", 0)
			:SetField("mailQuantity", 0)
			:SetField("guildQuantity", 0)
			:SetField("altQuantity", 0)
			:SetField("totalQuantity", 0)
			:Create()
	end

	local row = private.db:GetUniqueRow("itemString", itemString)
	local oldValue = row:GetField(field)
	local newValue = oldValue + quantity
	assert(newValue >= 0)
	if newValue == 0 and row:GetField("totalQuantity") == oldValue then
		-- remove this row
		private.db:DeleteRow(row)
	else
		-- update this row
		row:SetField(field, oldValue + quantity)
		row:SetField("totalQuantity", row:GetField("totalQuantity") + quantity)
		row:Update()
	end
	row:Release()
end

function private.WipeQuantity(field)
	private.db:SetQueryUpdatesPaused(true)
	local query = private.db:NewQuery()
	for _, row in query:Iterator() do
		local oldValue = row:GetField(field)
		local totalQuantity = row:GetField("totalQuantity")
		if oldValue == totalQuantity then
			-- remove this row
			assert(oldValue > 0)
			private.db:DeleteRow(row)
		elseif oldValue ~= 0 then
			-- update this row
			assert(totalQuantity - oldValue > 0)
			row:SetField(field, 0)
				:SetField("totalQuantity", totalQuantity - oldValue)
				:Update()
		end
	end
	query:Release()
	private.db:SetQueryUpdatesPaused(false)
end
