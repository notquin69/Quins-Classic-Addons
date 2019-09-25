-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local ProfessionUtil = TSM.Crafting:NewPackage("ProfessionUtil")
local private = {
	craftQuantity = nil,
	craftSpellId = nil,
	craftCallback = nil,
	craftName = nil,
	preparedSpellId = nil,
	preparedTime = 0,
	categoryInfoTemp = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function ProfessionUtil.OnInitialize()
	TSMAPI_FOUR.Event.Register("UNIT_SPELLCAST_SUCCEEDED", function(_, unit, _, spellId)
		if unit ~= "player" then
			return
		end
		if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and GetSpellInfo(spellId) ~= private.craftName) or (WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC and spellId ~= private.craftSpellId) then
			return
		end

		-- check if we need to update bank quantity manually
		for _, itemString, quantity in TSM.Crafting.MatIterator(private.craftSpellId) do
			local bankUsed = quantity - (TSMAPI_FOUR.Inventory.GetBagQuantity(itemString) + TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString))
			if bankUsed > 0 and bankUsed <= TSMAPI_FOUR.Inventory.GetBankQuantity(itemString) then
				TSM:LOG_INFO("Used %d from bank", bankUsed)
				TSM.Inventory.BagTracking.ForceBankQuantityDeduction(itemString, bankUsed)
			end
		end

		local callback = private.craftCallback
		assert(callback)
		private.craftQuantity = private.craftQuantity - 1
		local isDone = private.craftQuantity == 0
		if isDone then
			private.craftQuantity = nil
			private.craftSpellId = nil
			private.craftCallback = nil
			private.craftName = nil
		end
		callback(true, isDone)
		-- ignore profession updates from crafting something
		TSM.Crafting.ProfessionScanner.IgnoreNextProfessionUpdates()
	end)
	local function SpellcastFailedEventHandler(_, unit, _, spellId)
		if unit ~= "player" then
			return
		end
		if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and GetSpellInfo(spellId) ~= private.craftName) or (WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC and spellId ~= private.craftSpellId) then
			return
		end
		local callback = private.craftCallback
		assert(callback)
		private.craftQuantity = nil
		private.craftSpellId = nil
		private.craftCallback = nil
		private.craftName = nil
		callback(false, true)
	end
	TSMAPI_FOUR.Event.Register("UNIT_SPELLCAST_INTERRUPTED", SpellcastFailedEventHandler)
	TSMAPI_FOUR.Event.Register("UNIT_SPELLCAST_FAILED", SpellcastFailedEventHandler)
	TSMAPI_FOUR.Event.Register("UNIT_SPELLCAST_FAILED_QUIET", SpellcastFailedEventHandler)
end

function ProfessionUtil.GetCurrentProfessionName()
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		local name = TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftSkillLine(1) or GetTradeSkillLine()
		return name
	else
		local _, name, _, _, _, _, parentName = C_TradeSkillUI.GetTradeSkillLine()
		return parentName or name
	end
end

function ProfessionUtil.GetResultInfo(spellId)
	-- get the links
	local itemLink = ProfessionUtil.GetRecipeInfo(spellId)
	assert(itemLink, "Invalid craft: "..tostring(spellId))

	if strfind(itemLink, "enchant:") then
		-- result of craft is not an item
		local itemString = TSM.CONST.ENCHANT_ITEM_STRINGS[spellId] or TSM.CONST.MASS_MILLING_RECIPES[spellId]
		if itemString and WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
			return TSM.UI.GetColoredItemName(itemString), itemString, TSMAPI_FOUR.Item.GetTexture(itemString)
		elseif TSM.CONST.ENGINEER_TINKERS[spellId] then
			local name, _, icon = GetSpellInfo(spellId)
			return name, nil, icon
		else
			local name, _, icon = GetSpellInfo(TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftInfo(WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and TSM.Crafting.ProfessionScanner.GetIndexBySpellId(spellId) or spellId) or spellId)
			return name, nil, icon
		end
	elseif strfind(itemLink, "item:") then
		-- result of craft is an item
		return TSM.UI.GetColoredItemName(itemLink), TSMAPI_FOUR.Item.ToItemString(itemLink), TSMAPI_FOUR.Item.GetTexture(itemLink)
	else
		error("Invalid craft: "..tostring(spellId))
	end
end

function ProfessionUtil.GetNumCraftable(spellId)
	local num, numAll = math.huge, math.huge
	for i = 1, ProfessionUtil.GetNumMats(spellId) do
		local matItemLink, _, _, quantity = TSM.Crafting.ProfessionUtil.GetMatInfo(spellId, i)
		local itemString = TSMAPI_FOUR.Item.ToItemString(matItemLink)
		if not itemString or not quantity then
			return 0, 0
		end
		local bagQuantity = TSMAPI_FOUR.Inventory.GetBagQuantity(itemString)
		if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
			bagQuantity = bagQuantity + TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString) + TSMAPI_FOUR.Inventory.GetBankQuantity(itemString)
		end
		num = min(num, floor(bagQuantity / quantity))
		numAll = min(numAll, floor(TSMAPI_FOUR.Inventory.GetTotalQuantity(itemString) / quantity))
	end
	if num == math.huge or numAll == math.huge then
		return 0, 0
	end
	return num, numAll
end

function ProfessionUtil.GetNumCraftableFromDB(spellId)
	local num = math.huge
	for _, itemString, quantity in TSM.Crafting.MatIterator(spellId) do
		local bagQuantity = TSMAPI_FOUR.Inventory.GetBagQuantity(itemString)
		if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
			bagQuantity = bagQuantity + TSMAPI_FOUR.Inventory.GetReagentBankQuantity(itemString) + TSMAPI_FOUR.Inventory.GetBankQuantity(itemString)
		end
		num = min(num, floor(bagQuantity / quantity))
	end
	if num == math.huge then
		return 0
	end
	return num
end

function ProfessionUtil.IsEnchant(spellId)
	local name = ProfessionUtil.GetCurrentProfessionName()
	if name ~= GetSpellInfo(7411) or WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		return false
	end
	if not strfind(C_TradeSkillUI.GetRecipeItemLink(spellId), "enchant:") then
		return false
	end
	local recipeInfo = TSMAPI_FOUR.Util.AcquireTempTable()
	assert(C_TradeSkillUI.GetRecipeInfo(spellId, recipeInfo) == recipeInfo)
	local altVerb = recipeInfo.alternateVerb
	TSMAPI_FOUR.Util.ReleaseTempTable(recipeInfo)
	return altVerb and true or false
end

function ProfessionUtil.OpenProfession(profession)
	if profession == GetSpellInfo(TSM.CONST.MINING_SPELLID) then
		-- mining needs to be opened as smelting
		profession = GetSpellInfo(TSM.CONST.SMELTING_SPELLID)
	elseif profession == GetSpellInfo(TSM.CONST.HERBALISM_SPELLID) then
		-- herbalism needs to be opened as herbalism skills
		profession = GetSpellInfo(TSM.CONST.HERBALISM_SKILLS_SPELLID)
	elseif profession == GetSpellInfo(TSM.CONST.SKINNING_SPELLID) then
		-- skinning needs to be opened as skinning skills
		profession = GetSpellInfo(TSM.CONST.SKINNING_SKILLS_SPELLID)
	end
	CastSpellByName(profession)
end

function ProfessionUtil.PrepareToCraft(spellId, quantity)
	quantity = min(quantity, ProfessionUtil.GetNumCraftable(spellId))
	if quantity == 0 then
		return
	end
	if ProfessionUtil.IsEnchant(spellId) then
		quantity = 1
	end

	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		C_TradeSkillUI.SetRecipeRepeatCount(spellId, quantity)
	end
	private.preparedSpellId = spellId
	private.preparedTime = GetTime()
end

function ProfessionUtil.Craft(spellId, quantity, useVellum, callback)
	assert(TSM.Crafting.ProfessionScanner.HasSpellId(spellId))
	if private.craftSpellId then
		callback(false, true)
		return 0
	end
	quantity = min(quantity, ProfessionUtil.GetNumCraftable(spellId))
	if quantity == 0 then
		return 0
	end
	local isEnchant = ProfessionUtil.IsEnchant(spellId)
	if isEnchant then
		quantity = 1
	elseif spellId ~= private.preparedSpellId or private.preparedTime == GetTime() then
		-- We can only craft one of this item due to a bug on Blizzard's end
		quantity = 1
	end
	private.craftQuantity = quantity
	private.craftSpellId = spellId
	private.craftCallback = callback
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		spellId = TSM.Crafting.ProfessionScanner.GetIndexBySpellId(spellId)
		if TSM.Crafting.ProfessionState.IsClassicCrafting() then
			private.craftName = GetCraftInfo(spellId)
		else
			private.craftName = GetTradeSkillInfo(spellId)
			DoTradeSkill(spellId, quantity)
		end
	else
		C_TradeSkillUI.CraftRecipe(spellId, quantity)
	end
	if useVellum and isEnchant then
		UseItemByName(TSMAPI_FOUR.Item.GetName(TSM.CONST.VELLUM_ITEM_STRING))
	end
	return quantity
end

function ProfessionUtil.IsDataStable()
	return WOW_PROJECT_ID == WOW_PROJECT_CLASSIC or (C_TradeSkillUI.IsTradeSkillReady() and not C_TradeSkillUI.IsDataSourceChanging())
end

function ProfessionUtil.HasCooldown(spellId)
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		return GetTradeSkillCooldown(spellId) and true or false
	else
		return select(2, C_TradeSkillUI.GetRecipeCooldown(spellId)) and true or false
	end
end

function ProfessionUtil.GetRemainingCooldown(spellId)
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		return GetTradeSkillCooldown(spellId)
	else
		return C_TradeSkillUI.GetRecipeCooldown(spellId)
	end
end

function ProfessionUtil.GetRecipeInfo(spellId)
	local itemLink, lNum, hNum, toolsStr, hasTools = nil, nil, nil, nil, nil
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		spellId = TSM.Crafting.ProfessionScanner.GetIndexBySpellId(spellId) or spellId
		itemLink = TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftItemLink(spellId) or GetTradeSkillItemLink(spellId)
		if TSM.Crafting.ProfessionState.IsClassicCrafting() then
			lNum, hNum = 1, 1
			toolsStr, hasTools = GetCraftSpellFocus(spellId)
		else
			lNum, hNum = GetTradeSkillNumMade(spellId)
			toolsStr, hasTools = GetTradeSkillTools(spellId)
		end
	else
		itemLink = C_TradeSkillUI.GetRecipeItemLink(spellId)
		lNum, hNum = C_TradeSkillUI.GetRecipeNumItemsProduced(spellId)
		toolsStr, hasTools = C_TradeSkillUI.GetRecipeTools(spellId)
	end
	return itemLink, lNum, hNum, toolsStr, hasTools
end

function ProfessionUtil.GetNumMats(spellId)
	local numMats = nil
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		spellId = TSM.Crafting.ProfessionScanner.GetIndexBySpellId(spellId) or spellId
		numMats = TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftNumReagents(spellId) or GetTradeSkillNumReagents(spellId)
	else
		numMats = C_TradeSkillUI.GetRecipeNumReagents(spellId)
	end
	return numMats
end

function ProfessionUtil.GetMatInfo(spellId, index)
	local itemLink, name, texture, quantity = nil, nil, nil, nil
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		spellId = TSM.Crafting.ProfessionScanner.GetIndexBySpellId(spellId) or spellId
		itemLink = TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftReagentItemLink(spellId, index) or GetTradeSkillReagentItemLink(spellId, index)
		if TSM.Crafting.ProfessionState.IsClassicCrafting() then
			name, texture, quantity = GetCraftReagentInfo(spellId, index)
		else
			name, texture, quantity = GetTradeSkillReagentInfo(spellId, index)
		end
	else
		itemLink = C_TradeSkillUI.GetRecipeReagentItemLink(spellId, index)
		name, texture, quantity = C_TradeSkillUI.GetRecipeReagentInfo(spellId, index)
	end
	return itemLink, name, texture, quantity
end

function ProfessionUtil.CloseTradeSkill(closeBoth)
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		if closeBoth then
			CloseCraft()
			CloseTradeSkill()
		else
			if TSM.Crafting.ProfessionState.IsClassicCrafting() then
				CloseCraft()
			else
				CloseTradeSkill()
			end
		end
	else
		C_TradeSkillUI.CloseTradeSkill()
		C_Garrison.CloseGarrisonTradeskillNPC()
	end
end

function ProfessionUtil.IsNPCProfession()
	return WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC and C_TradeSkillUI.IsNPCCrafting()
end

function ProfessionUtil.IsLinkedProfession()
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		return nil, nil
	else
		return C_TradeSkillUI.IsTradeSkillLinked()
	end
end

function ProfessionUtil.IsGuildProfession()
	return WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC and C_TradeSkillUI.IsTradeSkillGuild()
end

function ProfessionUtil.GetCategoryInfo(categoryId)
	local name, numIndents, parentCategoryId = nil, nil, nil
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		name = TSM.Crafting.ProfessionState.IsClassicCrafting() and GetCraftDisplaySkillLine() or (categoryId and GetTradeSkillInfo(categoryId) or nil)
		numIndents = 0
		parentCategoryId = nil
	else
		C_TradeSkillUI.GetCategoryInfo(categoryId, private.categoryInfoTemp)
		assert(private.categoryInfoTemp.numIndents)
		name = private.categoryInfoTemp.name
		numIndents = private.categoryInfoTemp.numIndents
		parentCategoryId = private.categoryInfoTemp.numIndents ~= 0 and private.categoryInfoTemp.parentCategoryID or nil
		wipe(private.categoryInfoTemp)
	end
	return name, numIndents, parentCategoryId
end
