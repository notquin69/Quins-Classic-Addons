-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Crafting = TSM.MainUI.Settings:NewPackage("Crafting")
local L = TSM.L
local private = { altCharacters = {}, altGuilds = {} }



-- ============================================================================
-- Module Functions
-- ============================================================================

function Crafting.OnInitialize()
	TSM.MainUI.Settings.RegisterSettingPage(L["Crafting"], "middle", private.GetCraftingSettingsFrame)
end



-- ============================================================================
-- Crafting Settings UI
-- ============================================================================

function private.GetCraftingSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "crafting")
	wipe(private.altCharacters)
	wipe(private.altGuilds)
	for name in pairs(TSMAPI_FOUR.PlayerInfo.GetCharacters(true)) do
		tinsert(private.altCharacters, name)
	end
	for name in pairs(TSMAPI_FOUR.PlayerInfo.GetGuilds()) do
		tinsert(private.altGuilds, name)
	end

	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "craftingSettings")
		:SetStyle("padding.left", 12)
		:SetStyle("padding.right", 12)
		:AddChild(TSM.MainUI.Settings.CreateHeading("generalOptionsTitle", L["Inventory Options"])
			:SetStyle("margin.bottom", 15)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "inventoryOptionsFrame1")
			:SetLayout("HORIZONTAL")
			:SetStyle("margin.bottom", 4)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
				:SetStyle("height", 18)
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Ignore Characters"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
				:SetStyle("height", 18)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Ignore Guilds"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "inventoryOptionsFrame2")
			:SetLayout("HORIZONTAL")
			:SetStyle("margin.bottom", 24)
			:AddChild(TSMAPI_FOUR.UI.NewElement("MultiselectionDropdown", "charDropdown")
				:SetStyle("height", 26)
				:SetStyle("margin.right", 16)
				:SetItems(private.altCharacters, private.altCharacters)
				:SetSettingInfo(TSM.db.global.craftingOptions, "ignoreCharacters")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("MultiselectionDropdown", "guildDropdown")
				:SetStyle("height", 26)
				:SetItems(private.altGuilds, private.altGuilds)
				:SetSettingInfo(TSM.db.global.craftingOptions, "ignoreGuilds")
			)
		)
		:AddChild(TSM.MainUI.Settings.CreateHeading("priceTitle", L["Default Price Configuration"])
			:SetStyle("margin.bottom", 16)
		)
		:AddChild(TSM.MainUI.Settings.CreateInputWithReset("matCostMethodField", L["Default Material Cost Method:"], "global.craftingOptions.defaultMatCostMethod", private.CheckMatPrice))
		:AddChild(TSM.MainUI.Settings.CreateInputWithReset("craftValueField", L["Default Craft Value Method:"], "global.craftingOptions.defaultCraftPriceMethod", private.CheckMatPrice))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "excludeCooldownsCheckbox")
			:SetStyle("height", 28)
			:SetStyle("margin.left", -5)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 12)
			:SetText(L["Exclude crafts with cooldowns"])
			:SetSettingInfo(TSM.db.global.craftingOptions, "ignoreCDCraftCost")
		)
		:AddChild(TSM.MainUI.Settings.CreateHeading("ignoredCooldownsTitle", L["Ignored Cooldowns"])
			:SetStyle("margin.top", 24)
			:SetStyle("margin.bottom", 6)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "cooldowns")
			:SetStyle("height", 150)
			:SetStyle("headerFontHeight", 12)
			:SetStyle("margin.bottom", 12)
			:SetStyle("rowHeight", 20)
			:GetScrollingTableInfo()
				:NewColumn("item")
					:SetTitles(L["Cooldown"])
					:SetFont(TSM.UI.Fonts.MontserratRegular)
					:SetFontHeight(12)
					:SetJustifyH("LEFT")
					:SetTextInfo(nil, private.CooldownGetText)
					:Commit()
				:Commit()
			:SetQuery(TSM.Crafting.CreateIgnoredCooldownQuery())
			:SetAutoReleaseQuery(true)
			:SetSelectionDisabled(true)
			:SetScript("OnRowClick", private.IgnoredCooldownOnRowClick)
		)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.CheckMatPrice(value)
	local isValid, err = TSMAPI_FOUR.CustomPrice.Validate(value, "matprice")
	if(isValid) then
		return true
	else
		TSM:Print(L["Invalid custom price."].." "..err)
	end
end

function private.CooldownGetText(row)
	return row:GetField("characterKey").." - "..TSM.Crafting.GetName(row:GetField("spellId"))
end

function private.IgnoredCooldownOnRowClick(_, row)
	TSM.Crafting.RemoveIgnoredCooldown(row:GetFields("characterKey", "spellId"))
end
