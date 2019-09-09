-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Shopping = TSM.MainUI.Settings:NewPackage("Shopping")
local L = TSM.L
local private = { sounds = {}, soundkeys = {} }


-- ============================================================================
-- Module Functions
-- ============================================================================

function Shopping.OnInitialize()
	TSM.MainUI.Settings.RegisterSettingPage("Shopping / Sniper", "middle", private.GetShoppingSettingsFrame)
	for key, name in pairs(TSMAPI_FOUR.Sound.GetSounds()) do
		tinsert(private.sounds, name)
		tinsert(private.soundkeys, key)
	end
end



-- ============================================================================
-- Shopping Settings UI
-- ============================================================================

function private.GetShoppingSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "shopping")
	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "shoppingSettings")
		:SetStyle("padding.left", 12)
		:SetStyle("padding.right", 12)
		:AddChild(TSM.MainUI.Settings.CreateHeading("generalOptionsTitle", L["General Options"])
			:SetStyle("margin.bottom", 15)
		)
		:AddChild(TSM.MainUI.Settings.CreateInputWithReset("marketValueSourceField", L["Market Value Price Source"], "global.shoppingOptions.pctSource", private.CheckCustomPrice)
			:SetStyle("margin.bottom", 15)
		)
		:AddChild(TSM.MainUI.Settings.CreateInputWithReset("buyoutConfirmationAlert", L["Buyout Confirmation Alert"], "global.shoppingOptions.buyoutAlertSource", private.CheckCustomPrice)
			:SetStyle("margin.bottom", 0)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "showConfirm")
			:SetStyle("height", 24)
			:SetStyle("margin.top", -24)
			:SetStyle("margin.left", -4)
			:SetStyle("margin.bottom", 24)
			:SetCheckboxPosition("LEFT")
			:SetStyle("fontHeight", 12)
			:SetSettingInfo(TSM.db.global.shoppingOptions, "buyoutConfirm")
			:SetText(L["Show confirmation alert if buyout is above the alert price"])
		)
		:AddChild(TSM.MainUI.Settings.CreateHeading("disenchantSearchOptionsTitle", L["Disenchant Search Options"])
			:SetStyle("margin.bottom", 15)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "frame")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
				:SetStyle("height", 18)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#ffffff")
				:SetStyle("margin.bottom", 4)
				:SetText(L["Minimum disenchant level:"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
				:SetStyle("height", 18)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#ffffff")
				:SetStyle("margin.bottom", 4)
				:SetText(L["Maximum disenchant level:"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "minDeSearchLvlInputFrame")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:SetStyle("margin.bottom", 16)
			:AddChild(TSMAPI_FOUR.UI.NewElement("InputNumeric", "minDeSearchLvl")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("textColor", "#ffffff")
				:SetStyle("background", "#5c5c5c")
				:SetStyle("height", 20)
				:SetStyle("width", 50)
				:SetStyle("fontHeight", 14)
				:SetStyle("margin.right", 10)
				:SetStyle("justifyH", "CENTER")
				:SetSettingInfo(TSM.db.global.shoppingOptions, "minDeSearchLvl")
				:SetMaxNumber(905)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "minDeSearchLvlLabel")
				:SetStyle("fontHeight", 12)
				:SetText(L["(minimum 0 - maximum 905)"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("InputNumeric", "maxDeSearchLvl")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("textColor", "#ffffff")
				:SetStyle("background", "#5c5c5c")
				:SetStyle("height", 20)
				:SetStyle("width", 50)
				:SetStyle("fontHeight", 14)
				:SetStyle("margin.right", 10)
				:SetStyle("justifyH", "CENTER")
				:SetSettingInfo(TSM.db.global.shoppingOptions, "maxDeSearchLvl")
				:SetMaxNumber(905)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "maxDeSearchLvlLabel")
				:SetStyle("fontHeight", 12)
				:SetText(L["(minimum 0 - maximum 905)"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
			:SetStyle("height", 18)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetStyle("margin.bottom", 4)
			:SetText(L["Maximum disenchant search percentage:"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "maxDeSearchPercentInputFrame")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:SetStyle("margin.bottom", 16)
			:AddChild(TSMAPI_FOUR.UI.NewElement("InputNumeric", "maxDeSearchPercent")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("textColor", "#ffffff")
				:SetStyle("background", "#5c5c5c")
				:SetStyle("height", 20)
				:SetStyle("width", 50)
				:SetStyle("fontHeight", 14)
				:SetStyle("margin.right", 10)
				:SetStyle("justifyH", "CENTER")
				:SetSettingInfo(TSM.db.global.shoppingOptions, "maxDeSearchPercent")
				:SetMaxNumber(100)
			)
		)
		:AddChild(TSM.MainUI.Settings.CreateHeading("quicksellOptionsTitle", L["Sniper Options"])
			:SetStyle("margin.bottom", 10)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "foundAuctionSoundLabel")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 4)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Found auction sound"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "sniperSoundFrame")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin.bottom",8)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "dropdown")
				:SetItems(private.sounds, private.soundkeys)
				:SetSettingInfo(TSM.db.global.sniperOptions, "sniperSound")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
		)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.CheckCustomPrice(value)
	local isValid, err = TSMAPI_FOUR.CustomPrice.Validate(value)
	if isValid then
		return true
	else
		TSM:Print(L["Invalid custom price."].." "..err)
		return false
	end
end
