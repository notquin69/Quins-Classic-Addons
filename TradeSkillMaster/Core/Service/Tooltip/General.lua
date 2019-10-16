-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local General = TSM.Tooltip:NewPackage("General")
local L = TSM.L



-- ============================================================================
-- Module Functions
-- ============================================================================

function General.LoadTooltip(tooltip, itemString)
	-- add group / operation info
	if TSM.db.global.tooltipOptions.groupNameTooltip then
		local groupPath = TSM.Groups.GetPathByItem(itemString)
		if groupPath ~= TSM.CONST.ROOT_GROUP_PATH then
			local leftText = nil
			if TSM.Groups.IsItemInGroup(itemString) then
				leftText = GROUP
			else
				leftText = GROUP.."("..L["Base Item"]..")"
			end
			tooltip:AddLine(leftText, "|cffffffff"..TSM.Groups.Path.Format(groupPath).."|r")
			for _, moduleName in TSM.Operations.ModuleIterator() do
				if TSM.db.global.tooltipOptions.operationTooltips[moduleName] then
					local operations = TSMAPI_FOUR.Util.AcquireTempTable()
					for _, operationName in TSM.Groups.OperationIterator(groupPath, moduleName) do
						tinsert(operations, operationName)
					end
					if #operations > 0 then
						tooltip:AddLine(format(#operations == 1 and L["%s operation"] or L["%s operations"], TSM.Operations.GetLocalizedName(moduleName)), "|cffffffff"..table.concat(operations, ", ").."|r")
					end
					TSMAPI_FOUR.Util.ReleaseTempTable(operations)
				end
			end
		end
	end

	-- add disenchant value info
	if TSM.db.global.tooltipOptions.deTooltip then
		local value = TSMAPI_FOUR.Conversions.GetValue(itemString, TSM.db.global.coreOptions.destroyValueSource, "disenchant")
		if value then
			tooltip:AddItemValueLine(L["Disenchant Value"], value)
			tooltip:StartSection()
			if TSM.db.global.tooltipOptions.detailedDestroyTooltip then
				local rarity = TSMAPI_FOUR.Item.GetQuality(itemString)
				local ilvl = TSMAPI_FOUR.Item.GetItemLevel(TSMAPI_FOUR.Item.ToBaseItemString(itemString))
				local iType = GetItemClassInfo(TSMAPI_FOUR.Item.GetClassId(itemString))
				for _, data in ipairs(TSM.CONST.DISENCHANT_INFO) do
					for targetItem, itemData in pairs(data) do
						if targetItem ~= "desc" then
							for _, deData in ipairs(itemData.sourceInfo) do
								if deData.itemType == iType and deData.rarity == rarity and ilvl >= deData.minItemLevel and ilvl <= deData.maxItemLevel then
									local matValue = TSMAPI_FOUR.CustomPrice.GetValue(TSM.db.global.coreOptions.destroyValueSource, targetItem) or 0
									if matValue > 0 then
										tooltip:AddSubItemValueLine(targetItem, matValue, deData.amountOfMats, deData.matRate, deData.minAmount, deData.maxAmount)
									end
								end
							end
						end
					end
				end
			end
			tooltip:EndSection()
		end
	end

	-- add mill value info
	if TSM.db.global.tooltipOptions.millTooltip then
		local value = TSMAPI_FOUR.Conversions.GetValue(itemString, TSM.db.global.coreOptions.destroyValueSource, "mill")
		if value then
			tooltip:AddItemValueLine(L["Mill Value"], value)
			tooltip:StartSection()
			if TSM.db.global.tooltipOptions.detailedDestroyTooltip then
				for _, targetItem in ipairs(TSMAPI_FOUR.Conversions.GetTargetItemsByMethod("mill")) do
					local herbs = TSMAPI_FOUR.Conversions.GetData(targetItem)
					if herbs[itemString] then
						local millValue = TSMAPI_FOUR.CustomPrice.GetValue(TSM.db.global.coreOptions.destroyValueSource, targetItem) or 0
						if millValue > 0 then
							tooltip:AddSubItemValueLine(targetItem, millValue, herbs[itemString].rate)
						end
					end
				end
			end
			tooltip:EndSection()
		end
	end

	-- add prospect value info
	if TSM.db.global.tooltipOptions.prospectTooltip then
		local value = TSMAPI_FOUR.Conversions.GetValue(itemString, TSM.db.global.coreOptions.destroyValueSource, "prospect")
		if value then
			tooltip:AddItemValueLine(L["Prospect Value"], value)
			tooltip:StartSection()
			if TSM.db.global.tooltipOptions.detailedDestroyTooltip then
				for _, targetItem in ipairs(TSMAPI_FOUR.Conversions.GetTargetItemsByMethod("prospect")) do
					local gems = TSMAPI_FOUR.Conversions.GetData(targetItem)
					if gems[itemString] then
						local prospectValue = TSMAPI_FOUR.CustomPrice.GetValue(TSM.db.global.coreOptions.destroyValueSource, targetItem) or 0
						if prospectValue > 0 then
							tooltip:AddSubItemValueLine(targetItem, prospectValue, gems[itemString].rate)
						end
					end
				end
			end
			tooltip:EndSection()
		end
	end

	-- add transform value info
	if TSM.db.global.tooltipOptions.transformTooltip then
		local value = TSMAPI_FOUR.Conversions.GetValue(itemString, TSM.db.global.coreOptions.destroyValueSource, "transform")
		if value then
			tooltip:AddItemValueLine(L["Transform Value"], value)
			tooltip:StartSection()
			if TSM.db.global.tooltipOptions.detailedDestroyTooltip then
				for _, targetItem in ipairs(TSMAPI_FOUR.Conversions.GetTargetItemsByMethod("transform")) do
					local srcItems = TSMAPI_FOUR.Conversions.GetData(targetItem)
					if srcItems[itemString] then
						local transformValue = TSMAPI_FOUR.CustomPrice.GetValue(TSM.db.global.coreOptions.destroyValueSource, targetItem) or 0
						if transformValue > 0 then
							tooltip:AddSubItemValueLine(targetItem, transformValue, srcItems[itemString].rate)
						end
					end
				end
			end
			tooltip:EndSection()
		end
	end

	-- add vendor buy price
	if TSM.db.global.tooltipOptions.vendorBuyTooltip then
		local value = TSMAPI_FOUR.Item.GetVendorBuy(itemString) or 0
		if value > 0 then
			tooltip:AddItemValueLine(L["Vendor Buy Price"], value)
		end
	end

	-- add vendor sell price
	if TSM.db.global.tooltipOptions.vendorSellTooltip then
		local value = TSMAPI_FOUR.Item.GetVendorSell(itemString) or 0
		if value > 0 then
			tooltip:AddItemValueLine(L["Vendor Sell Price"], value)
		end
	end

	-- add custom price sources
	for name in pairs(TSM.db.global.userData.customPriceSources) do
		if TSM.db.global.tooltipOptions.customPriceTooltips[name] then
			local price = TSMAPI_FOUR.CustomPrice.GetValue(name, itemString) or 0
			if price > 0 then
				tooltip:AddItemValueLine(L["Custom Price Source"].." '"..name.."'", price)
			end
		end
	end

	-- add inventory information
	if TSM.db.global.tooltipOptions.inventoryTooltipFormat == "full" then
		tooltip:StartSection()
		local totalNum = 0
		for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
			for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
				local realm = strmatch(factionrealm, "^.* "..TSMAPI_FOUR.Util.StrEscape("-").." (.*)")
				if realm == GetRealmName() then
					realm = ""
				else
					realm = " - "..realm
				end
				local bag = TSMAPI_FOUR.Inventory.GetBagQuantity(itemString, character, factionrealm)
				local bank = TSMAPI_FOUR.Inventory.GetBankQuantity(itemString, character, factionrealm)
				local reagentBank = TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString, character, factionrealm)
				local auction = TSMAPI_FOUR.Inventory.GetAuctionQuantity(itemString, character, factionrealm)
				local mail = TSMAPI_FOUR.Inventory.GetMailQuantity(itemString, character, factionrealm)
				local playerTotal = bag + bank + reagentBank + auction + mail
				if playerTotal > 0 then
					totalNum = totalNum + playerTotal
					local classColor = RAID_CLASS_COLORS[TSM.db:Get("sync", TSM.db:GetSyncScopeKeyByCharacter(character), "internalData", "classKey")]
					local rightText = format(L["%s (%s bags, %s bank, %s AH, %s mail)"], "|cffffffff"..playerTotal.."|r", "|cffffffff"..bag.."|r", "|cffffffff"..(bank+reagentBank).."|r", "|cffffffff"..auction.."|r", "|cffffffff"..mail.."|r")
					if classColor then
						tooltip:AddLine("|c"..classColor.colorStr..character..realm.."|r", rightText)
					else
						tooltip:AddLine(character..realm, rightText)
					end
				end
			end
		end
		for guildName in pairs(TSM.db.factionrealm.internalData.guildVaults) do
			local guildQuantity = TSMAPI_FOUR.Inventory.GetGuildQuantity(itemString, guildName)
			if guildQuantity > 0 then
				totalNum = totalNum + guildQuantity
				tooltip:AddLine(guildName, format(L["%s in guild vault"], "|cffffffff"..guildQuantity.."|r"))
			end
		end
		tooltip:EndSection(L["Inventory"], format(L["%s total"], "|cffffffff"..totalNum.."|r"))
	elseif TSM.db.global.tooltipOptions.inventoryTooltipFormat == "simple" then
		local totalPlayer, totalAlt, totalGuild, totalAuction = 0, 0, 0, 0
		for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
			for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
				local bag = TSMAPI_FOUR.Inventory.GetBagQuantity(itemString, character, factionrealm)
				local bank = TSMAPI_FOUR.Inventory.GetBankQuantity(itemString, character, factionrealm)
				local reagentBank = TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString, character, factionrealm)
				local auction = TSMAPI_FOUR.Inventory.GetAuctionQuantity(itemString, character, factionrealm)
				local mail = TSMAPI_FOUR.Inventory.GetMailQuantity(itemString, character, factionrealm)
				if character == UnitName("player") then
					totalPlayer = totalPlayer + bag + bank + reagentBank + mail
					totalAuction = totalAuction + auction
				else
					totalAlt = totalAlt + bag + bank + reagentBank + mail
					totalAuction = totalAuction + auction
				end
			end
		end
		for guildName in pairs(TSM.db.factionrealm.internalData.guildVaults) do
			totalGuild = totalGuild + TSMAPI_FOUR.Inventory.GetGuildQuantity(itemString, guildName)
		end
		local totalNum = totalPlayer + totalAlt + totalGuild + totalAuction
		if totalNum > 0 then
			local rightText = nil
			if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
				rightText = format(L["%s (%s player, %s alts, %s guild, %s AH)"], "|cffffffff"..totalNum.."|r", "|cffffffff"..totalPlayer.."|r", "|cffffffff"..totalAlt.."|r", "|cffffffff"..totalGuild.."|r", "|cffffffff"..totalAuction.."|r")
			else
				rightText = format(L["%s (%s player, %s alts, %s AH)"], "|cffffffff"..totalNum.."|r", "|cffffffff"..totalPlayer.."|r", "|cffffffff"..totalAlt.."|r", "|cffffffff"..totalAuction.."|r")
			end
			tooltip:AddLine(L["Inventory"], rightText)
		end
	end
end
