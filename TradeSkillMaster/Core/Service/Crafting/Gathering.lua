-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Gathering = TSM.Crafting:NewPackage("Gathering")
local private = {
	db = nil,
	queuedCraftsUpdateQuery = nil,
	crafterList = {},
	professionList = {},
	contextChangedCallback = nil,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Gathering.OnInitialize()
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		TSMAPI_FOUR.Util.TableRemoveByValue(TSM.db.profile.gatheringOptions.sources, "guildBank")
		TSMAPI_FOUR.Util.TableRemoveByValue(TSM.db.profile.gatheringOptions.sources, "altGuildBank")
	end
end

function Gathering.OnEnable()
	private.db = TSMAPI_FOUR.Database.NewSchema("GATHERING_MATS")
		:AddUniqueStringField("itemString")
		:AddNumberField("numNeed")
		:AddNumberField("numHave")
		:AddStringField("sourcesStr")
		:Commit()
	private.queuedCraftsUpdateQuery = TSM.Crafting.CreateQueuedCraftsQuery()
		:SetUpdateCallback(private.OnQueuedCraftsUpdated)
	private.OnQueuedCraftsUpdated()
	TSM.Inventory.BagTracking.RegisterCallback(function()
		TSMAPI_FOUR.Delay.AfterTime("GATHERING_BAG_UPDATE", 1, private.UpdateDB)
	end)
end

function Gathering.SetContextChangedCallback(callback)
	private.contextChangedCallback = callback
end

function Gathering.CreateQuery()
	return private.db:NewQuery()
end

function Gathering.SetCrafter(crafter)
	if crafter == TSM.db.factionrealm.gatheringContext.crafter then
		return
	end
	TSM.db.factionrealm.gatheringContext.crafter = crafter
	private.UpdateProfessionList()
	private.UpdateDB()
end

function Gathering.SetProfessions(professions)
	local numProfessions = TSMAPI_FOUR.Util.Count(TSM.db.factionrealm.gatheringContext.professions)
	local didChange = false
	if numProfessions ~= #professions then
		didChange = true
	else
		for _, profession in ipairs(professions) do
			if not TSM.db.factionrealm.gatheringContext.professions[profession] then
				didChange = true
			end
		end
	end
	if not didChange then
		return
	end
	wipe(TSM.db.factionrealm.gatheringContext.professions)
	for _, profession in ipairs(professions) do
		assert(private.professionList[profession])
		TSM.db.factionrealm.gatheringContext.professions[profession] = true
	end
	private.UpdateDB()
end

function Gathering.GetCrafterList()
	return private.crafterList
end

function Gathering.GetCrafter()
	return TSM.db.factionrealm.gatheringContext.crafter
end

function Gathering.GetProfessionList()
	return private.professionList
end

function Gathering.GetProfessions()
	return TSM.db.factionrealm.gatheringContext.professions
end

function Gathering.SourcesStrToTable(sourcesStr, info, alts)
	for source, num, characters in gmatch(sourcesStr, "([a-zA-Z]+)/([0-9]+)/([^,]*)") do
		info[source] = tonumber(num)
		if source == "alt" or source == "altGuildBank" then
			for character in gmatch(characters, "([^`]+)") do
				alts[character] = true
			end
		end
	end
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.UpdateCrafterList()
	local query = TSM.Crafting.CreateQueuedCraftsQuery()
		:Select("players")
		:Distinct("players")
	wipe(private.crafterList)
	for _, players in query:Iterator() do
		for character in gmatch(players, "[^,]+") do
			if not private.crafterList[character] then
				private.crafterList[character] = true
				tinsert(private.crafterList, character)
			end
		end
	end
	query:Release()

	if TSM.db.factionrealm.gatheringContext.crafter and not private.crafterList[TSM.db.factionrealm.gatheringContext.crafter] then
		-- the crafter which was selected no longer exists, so clear the selection
		TSM.db.factionrealm.gatheringContext.crafter = nil
	elseif #private.crafterList == 1 then
		-- there is only one crafter in the list, so select it
		TSM.db.factionrealm.gatheringContext.crafter = private.crafterList[1]
	end
	if not TSM.db.factionrealm.gatheringContext.crafter then
		wipe(TSM.db.factionrealm.gatheringContext.professions)
	end
end

function private.UpdateProfessionList()
	-- update the professionList
	wipe(private.professionList)
	if TSM.db.factionrealm.gatheringContext.crafter then
		-- populate the list of professions
		local query = TSM.Crafting.CreateQueuedCraftsQuery()
			:Select("profession")
			:Custom(private.QueryPlayerFilter, TSM.db.factionrealm.gatheringContext.crafter)
			:Distinct("profession")
		for _, profession in query:Iterator() do
			private.professionList[profession] = true
			tinsert(private.professionList, profession)
		end
		query:Release()
	end

	-- remove selected professions which are no longer in the list
	for profession in pairs(TSM.db.factionrealm.gatheringContext.professions) do
		if not private.professionList[profession] then
			TSM.db.factionrealm.gatheringContext.professions[profession] = nil
		end
	end

	-- if there's a single profession in the list, select it
	if #private.professionList == 1 then
		TSM.db.factionrealm.gatheringContext.professions[private.professionList[1]] = true
	end
end

function private.OnQueuedCraftsUpdated()
	private.UpdateCrafterList()
	private.UpdateProfessionList()
	private.UpdateDB()
	private.contextChangedCallback()
end

function private.UpdateDB()
	-- delay the update if we're in combat
	if InCombatLockdown() then
		TSMAPI_FOUR.Delay.AfterTime("DELAYED_GATHERING_UPDATE", 1, private.UpdateDB)
		return
	end
	local crafter = TSM.db.factionrealm.gatheringContext.crafter
	if not crafter or not next(TSM.db.factionrealm.gatheringContext.professions) then
		private.db:Truncate()
		return
	end

	local matsNumNeed = TSMAPI_FOUR.Util.AcquireTempTable()
	local query = TSM.Crafting.CreateQueuedCraftsQuery()
		:Select("spellId", "num")
		:Custom(private.QueryPlayerFilter, crafter)
		:Or()
	for profession in pairs(TSM.db.factionrealm.gatheringContext.professions) do
		query:Equal("profession", profession)
	end
	query:End()
	for _, spellId, numQueued in query:Iterator() do
		for _, itemString, quantity in TSM.Crafting.MatIterator(spellId) do
			matsNumNeed[itemString] = (matsNumNeed[itemString] or 0) + quantity * numQueued
		end
	end
	query:Release()

	local matQueue = TSMAPI_FOUR.Util.AcquireTempTable()
	local matsNumHave = TSMAPI_FOUR.Util.AcquireTempTable()
	local matsNumHaveExtra = TSMAPI_FOUR.Util.AcquireTempTable()
	for itemString, numNeed in pairs(matsNumNeed) do
		matsNumHave[itemString] = private.GetCrafterInventoryQuantity(itemString)
		local numUsed = nil
		numNeed, numUsed = private.HandleNumHave(itemString, numNeed, matsNumHave[itemString])
		if numUsed < matsNumHave[itemString] then
			matsNumHaveExtra[itemString] = matsNumHave[itemString] - numUsed
		end
		if numNeed > 0 then
			matsNumNeed[itemString] = numNeed
			tinsert(matQueue, itemString)
		else
			matsNumNeed[itemString] = nil
		end
	end

	local sourceList = TSMAPI_FOUR.Util.AcquireTempTable()
	local matSourceList = TSMAPI_FOUR.Util.AcquireTempTable()
	while #matQueue > 0 do
		local itemString = tremove(matQueue)
		wipe(sourceList)
		local numNeed = matsNumNeed[itemString]
		-- always add a task to get mail on the crafter if possible
		numNeed = private.ProcessSource(itemString, numNeed, "openMail", sourceList)
		assert(numNeed >= 0)
		for _, source in ipairs(TSM.db.profile.gatheringOptions.sources) do
			local isCraftSource = source == "craftProfit" or source == "craftNoProfit"
			local ignoreSource = false
			if isCraftSource then
				-- check if we are already crafting some materials of this craft so shouldn't craft this item
				local spellId = TSM.Crafting.GetMostProfitableSpellIdByItem(itemString, crafter)
				if spellId then
					for _, matItemString in TSM.Crafting.MatIterator(spellId) do
						if not ignoreSource and matSourceList[matItemString] and strmatch(matSourceList[matItemString], "craft[a-zA-Z]+/[^,]+/") then
							ignoreSource = true
						end
					end
				else
					-- can't craft this item
					ignoreSource = true
				end
			end
			if not ignoreSource then
				local prevNumNeed = numNeed
				numNeed = private.ProcessSource(itemString, numNeed, source, sourceList)
				assert(numNeed >= 0)
				if numNeed == 0 then
					if isCraftSource then
						-- we are crafting these, so add the necessary mats
						local spellId = TSM.Crafting.GetMostProfitableSpellIdByItem(itemString, crafter)
						assert(spellId)
						local numToCraft = ceil(prevNumNeed / TSM.Crafting.GetNumResult(spellId))
						for _, intMatItemString, intMatQuantity in TSM.Crafting.MatIterator(spellId) do
							local intMatNumNeed, numUsed = private.HandleNumHave(intMatItemString, numToCraft * intMatQuantity, matsNumHaveExtra[intMatItemString] or 0)
							if numUsed > 0 then
								matsNumHaveExtra[intMatItemString] = matsNumHaveExtra[intMatItemString] - numUsed
							end
							if intMatNumNeed > 0 then
								if not matsNumNeed[intMatItemString] then
									local intMatNumHave = private.GetCrafterInventoryQuantity(intMatItemString)
									if intMatNumNeed > intMatNumHave then
										matsNumHave[intMatItemString] = intMatNumHave
										matsNumNeed[intMatItemString] = intMatNumNeed - intMatNumHave
										tinsert(matQueue, intMatItemString)
									elseif intMatNumHave > intMatNumNeed then
										matsNumHaveExtra[intMatItemString] = intMatNumHave - intMatNumNeed
									end
								else
									matsNumNeed[intMatItemString] = (matsNumNeed[intMatItemString] or 0) + intMatNumNeed
									if matSourceList[intMatItemString] then
										-- already processed this item, so queue it again
										tinsert(matQueue, intMatItemString)
									end
								end
							end
						end
					end
					break
				end
			end
		end
		sort(sourceList)
		matSourceList[itemString] = table.concat(sourceList, ",")
	end
	private.db:TruncateAndBulkInsertStart()
	for itemString, numNeed in pairs(matsNumNeed) do
		private.db:BulkInsertNewRow(itemString, numNeed, matsNumHave[itemString], matSourceList[itemString])
	end
	private.db:BulkInsertEnd()

	TSMAPI_FOUR.Util.ReleaseTempTable(sourceList)
	TSMAPI_FOUR.Util.ReleaseTempTable(matSourceList)
	TSMAPI_FOUR.Util.ReleaseTempTable(matsNumNeed)
	TSMAPI_FOUR.Util.ReleaseTempTable(matsNumHave)
	TSMAPI_FOUR.Util.ReleaseTempTable(matsNumHaveExtra)
	TSMAPI_FOUR.Util.ReleaseTempTable(matQueue)
end

function private.ProcessSource(itemString, numNeed, source, sourceList)
	local crafter = TSM.db.factionrealm.gatheringContext.crafter
	local playerName = UnitName("player")
	if source == "openMail" then
		local crafterMailQuantity = TSMAPI_FOUR.Inventory.GetMailQuantity(itemString, crafter)
		if crafterMailQuantity > 0 then
			crafterMailQuantity = min(crafterMailQuantity, numNeed)
			if crafter == playerName then
				tinsert(sourceList, "openMail/"..crafterMailQuantity.."/")
			else
				tinsert(sourceList, "alt/"..crafterMailQuantity.."/"..crafter)
			end
			return numNeed - crafterMailQuantity
		end
	elseif source == "vendor" then
		if TSMAPI_FOUR.Item.GetVendorBuy(itemString) then
			-- assume we can buy all we need from the vendor
			tinsert(sourceList, "vendor/"..numNeed.."/")
			return 0
		end
	elseif source == "guildBank" then
		local guild = TSMAPI_FOUR.PlayerInfo.GetPlayerGuild(crafter)
		local guildBankQuantity = guild and TSMAPI_FOUR.Inventory.GetGuildQuantity(itemString, guild) or 0
		if guildBankQuantity > 0 then
			guildBankQuantity = min(guildBankQuantity, numNeed)
			if crafter == playerName then
				-- we are on the crafter
				tinsert(sourceList, "guildBank/"..guildBankQuantity.."/")
			else
				-- need to switch to the crafter to get items from the guild bank
				tinsert(sourceList, "altGuildBank/"..guildBankQuantity.."/"..crafter)
			end
			return numNeed - guildBankQuantity
		end
	elseif source == "alt" then
		if TSMAPI_FOUR.Item.IsSoulbound(itemString) then
			-- can't mail soulbound items
			return numNeed
		end
		if crafter ~= playerName then
			-- we are on the alt, so see if we can gather items from this character
			local bagQuantity = TSMAPI_FOUR.Inventory.GetBagQuantity(itemString)
			local bankQuantity = TSMAPI_FOUR.Inventory.GetBankQuantity(itemString) + TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString)
			local mailQuantity = TSMAPI_FOUR.Inventory.GetMailQuantity(itemString)

			if bagQuantity > 0 then
				bagQuantity = min(numNeed, bagQuantity)
				tinsert(sourceList, "sendMail/"..bagQuantity.."/")
				numNeed = numNeed - bagQuantity
				if numNeed == 0 then
					return 0
				end
			end
			if mailQuantity > 0 then
				mailQuantity = min(numNeed, mailQuantity)
				tinsert(sourceList, "openMail/"..mailQuantity.."/")
				numNeed = numNeed - mailQuantity
				if numNeed == 0 then
					return 0
				end
			end
			if bankQuantity > 0 then
				bankQuantity = min(numNeed, bankQuantity)
				tinsert(sourceList, "bank/"..bankQuantity.."/")
				numNeed = numNeed - bankQuantity
				if numNeed == 0 then
					return 0
				end
			end
		end

		-- check alts
		local altNum = 0
		local altCharacters = TSMAPI_FOUR.Util.AcquireTempTable()
		for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
			for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
				local characterKey = nil
				if factionrealm == UnitFactionGroup("player").." - "..GetRealmName() then
					characterKey = character
				else
					characterKey = character.." - "..factionrealm
				end
				if characterKey ~= crafter and characterKey ~= playerName then
					local num = 0
					num = num + TSMAPI_FOUR.Inventory.GetBagQuantity(itemString, character, factionrealm)
					num = num + TSMAPI_FOUR.Inventory.GetBankQuantity(itemString, character, factionrealm)
					num = num + TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString, character, factionrealm)
					num = num + TSMAPI_FOUR.Inventory.GetMailQuantity(itemString, character, factionrealm)
					if num > 0 then
						tinsert(altCharacters, characterKey)
						altNum = altNum + num
					end
				end
			end
		end

		local altCharactersStr = table.concat(altCharacters, "`")
		TSMAPI_FOUR.Util.ReleaseTempTable(altCharacters)
		if altNum > 0 then
			altNum = min(altNum, numNeed)
			tinsert(sourceList, "alt/"..altNum.."/"..altCharactersStr)
			return numNeed - altNum
		end
	elseif source == "altGuildBank" then
		local currentGuild = TSMAPI_FOUR.PlayerInfo.GetPlayerGuild(playerName)
		if currentGuild and crafter ~= playerName then
			-- we are on an alt, so see if we can gather items from this character's guild bank
			local guildBankQuantity = TSMAPI_FOUR.Inventory.GetGuildQuantity(itemString)
			if guildBankQuantity > 0 then
				guildBankQuantity = min(numNeed, guildBankQuantity)
				tinsert(sourceList, "guildBank/"..guildBankQuantity.."/")
				numNeed = numNeed - guildBankQuantity
				if numNeed == 0 then
					return 0
				end
			end
		end

		-- check alts
		local totalGuildBankQuantity = 0
		local altCharacters = TSMAPI_FOUR.Util.AcquireTempTable()
		for _, character in TSMAPI_FOUR.PlayerInfo.CharacterIterator(true) do
			local guild = TSMAPI_FOUR.PlayerInfo.GetPlayerGuild(character)
			if guild and guild ~= currentGuild then
				local guildBankQuantity = TSMAPI_FOUR.Inventory.GetGuildQuantity(itemString, guild)
				if guildBankQuantity > 0 then
					tinsert(altCharacters, character)
					totalGuildBankQuantity = totalGuildBankQuantity + guildBankQuantity
				end
			end
		end
		local altCharactersStr = table.concat(altCharacters, "`")
		TSMAPI_FOUR.Util.ReleaseTempTable(altCharacters)
		if totalGuildBankQuantity > 0 then
			totalGuildBankQuantity = min(totalGuildBankQuantity, numNeed)
			tinsert(sourceList, "altGuildBank/"..totalGuildBankQuantity.."/"..altCharactersStr)
			return numNeed - totalGuildBankQuantity
		end
	elseif source == "craftProfit" or source == "craftNoProfit" then
		local spellId, maxProfit = TSM.Crafting.GetMostProfitableSpellIdByItem(itemString, crafter)
		if spellId and (source == "craftNoProfit" or (maxProfit and maxProfit > 0)) then
			-- assume we can craft all we need
			local numToCraft = ceil(numNeed / TSM.Crafting.GetNumResult(spellId))
			tinsert(sourceList, source.."/"..numToCraft.."/")
			return 0
		end
	elseif source == "auction" then
		if TSMAPI_FOUR.Item.IsSoulbound(itemString) then
			-- can't buy soulbound items
			return numNeed
		end
		-- assume we can buy all we need from the AH
		tinsert(sourceList, "auction/"..numNeed.."/")
		return 0
	elseif source == "auctionCrafting" then
		if TSMAPI_FOUR.Item.IsSoulbound(itemString) then
			-- can't buy soulbound items
			return numNeed
		end
		local conversionInfo = TSMAPI_FOUR.Conversions.GetSourceItems(itemString)
		if not conversionInfo or not conversionInfo.convert or not next(conversionInfo.convert) then
			-- can't convert to get this item
			return numNeed
		end
		-- assume we can buy all we need from the AH
		tinsert(sourceList, "auctionCrafting/"..numNeed.."/")
		return 0
	elseif source == "auctionDE" then
		if TSMAPI_FOUR.Item.IsSoulbound(itemString) then
			-- can't buy soulbound items
			return numNeed
		end
		local conversionInfo = TSMAPI_FOUR.Conversions.GetSourceItems(itemString)
		if not conversionInfo or not conversionInfo.disenchant then
			-- can't disenchant to get this item
			return numNeed
		end
		-- assume we can buy all we need from the AH
		tinsert(sourceList, "auctionDE/"..numNeed.."/")
		return 0
	else
		error("Unkown source: "..tostring(source))
	end
	return numNeed
end

function private.QueryPlayerFilter(row, player)
	return TSMAPI_FOUR.Util.SeparatedStrContains(row:GetField("players"), ",", player)
end

function private.GetCrafterInventoryQuantity(itemString)
	local crafter = TSM.db.factionrealm.gatheringContext.crafter
	return TSMAPI_FOUR.Inventory.GetBagQuantity(itemString, crafter) + TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString, crafter) + TSMAPI_FOUR.Inventory.GetBankQuantity(itemString, crafter)
end

function private.HandleNumHave(itemString, numNeed, numHave)
	if numNeed > numHave then
		-- use everything we have
		numNeed = numNeed - numHave
		return numNeed, numHave
	else
		-- we have at least as many as we need, so use all of them
		return 0, numNeed
	end
end
