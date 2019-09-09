-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Mailing = TSM.MainUI.Settings:NewPackage("Mailing")
local L = TSM.L
local private = { sounds = {}, soundkeys = {} }
local ITEM_QUALITY_DESCS = { ITEM_QUALITY2_DESC, ITEM_QUALITY3_DESC, ITEM_QUALITY4_DESC }
local ITEM_QUALITY_KEYS = { 2, 3, 4 }



-- ============================================================================
-- Module Functions
-- ============================================================================

function Mailing.OnInitialize()
	TSM.MainUI.Settings.RegisterSettingPage(L["Inventory / Mailing"], "middle", private.GetMailingSettingsFrame)
	for key, name in pairs(TSMAPI_FOUR.Sound.GetSounds()) do
		tinsert(private.sounds, name)
		tinsert(private.soundkeys, key)
	end
end



-- ============================================================================
-- Mailing Settings UI
-- ============================================================================

function private.GetMailingSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "mailing")
	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "mailingSettings")
		:SetStyle("padding.left", 12)
		:SetStyle("padding.right", 12)
		:AddChild(TSM.MainUI.Settings.CreateHeading("generalOptionsTitle", L["Inventory Options"])
			:SetStyle("margin.bottom", 4)
		)
		:AddChild(TSM.MainUI.Settings.CreateHeading("mailingOptionsTitle", L["Mailing Options"])
			:SetStyle("margin.bottom", 12)
		)
		:AddChild(TSM.MainUI.Settings.CreateHeading("sendingOptionsTitle", L["Inbox Settings"])
			:SetStyle("margin.left", 8)
			:SetStyle("margin.bottom", 4)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "mailOption2Checkbox")
			:SetStyle("height", 28)
			:SetStyle("fontHeight", 12)
			:SetStyle("margin.left", 12)
			:SetText(L["Enable inbox chat messages"])
			:SetSettingInfo(TSM.db.global.mailingOptions, "inboxMessages")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
			:SetStyle("height", 18)
			:SetStyle("margin.top", 4)
			:SetStyle("margin.left", 16)
			:SetStyle("margin.bottom", 8)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Amount of Bag Space to Keep Free"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "freeSpaceFrame")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:SetStyle("margin.left", 16)
			:SetStyle("margin.bottom", 8)
			:AddChild(TSMAPI_FOUR.UI.NewElement("InputNumeric", "keepMailInput")
				:SetStyle("height", 20)
				:SetStyle("width", 60)
				:SetStyle("margin.right", 8)
				:SetStyle("fontHeight", 14)
				:SetMaxNumber(20)
				:SetSettingInfo(TSM.db.global.mailingOptions, "keepMailSpace")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label2")
				:SetStyle("height", 16)
				:SetStyle("fontHeight", 12)
				:SetText(L["(minimum 0 - maximum 20)"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
			:SetStyle("height", 18)
			:SetStyle("margin.left", 16)
			:SetStyle("margin.bottom", 4)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Open Mail Complete Sound"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "soundDropdown")
			:SetStyle("height", 26)
			:SetStyle("width", 300)
			:SetStyle("margin.left", 16)
			:SetStyle("margin.bottom", 8)
			:SetItems(private.sounds, private.soundkeys)
			:SetSettingInfo(TSM.db.global.mailingOptions, "openMailSound")
			:SetScript("OnSelectionChanged", private.SoundOnSelectionChanged)
		)
		:AddChild(TSM.MainUI.Settings.CreateHeading("sendingOptionsTitle", L["Sending Settings"])
			:SetStyle("margin.left", 8)
			:SetStyle("margin.bottom", 4)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "sendMessagesCheckbox")
			:SetStyle("height", 28)
			:SetStyle("fontHeight", 12)
			:SetStyle("margin.left", 12)
			:SetText(L["Enable sending chat messages"])
			:SetSettingInfo(TSM.db.global.mailingOptions, "sendMessages")
		)
		:AddChild(TSM.MainUI.Settings.CreateHeading("sendingOptionsTitle", L["Group Settings"])
			:SetStyle("margin.left", 8)
			:SetStyle("margin.bottom", 4)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "sendItemsCheckbox")
			:SetStyle("height", 28)
			:SetStyle("margin.left", 12)
			:SetStyle("fontHeight", 12)
			:SetText(L["Send grouped items individually"])
			:SetSettingInfo(TSM.db.global.mailingOptions, "sendItemsIndividually")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
			:SetStyle("height", 18)
			:SetStyle("margin.top", 4)
			:SetStyle("margin.left", 16)
			:SetStyle("margin.bottom", 4)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Restart Delay (minutes)"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "restartDelayFrame")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:SetStyle("margin.left", 16)
			:SetStyle("margin.bottom", 8)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "restartDelay")
				:SetStyle("height", 20)
				:SetStyle("width", 60)
				:SetStyle("margin.right", 8)
				:SetText(TSM.db.global.mailingOptions.resendDelay)
				:SetScript("OnEscapePressed", private.RestartDelayOnEscapePressed)
				:SetScript("OnEnterPressed", private.RestartDelayOnEnterPressed)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label2")
				:SetStyle("height", 16)
				:SetStyle("fontHeight", 12)
				:SetText(L["(minimum 0.5 - maximum 10)"])
			)
		)
		:AddChild(TSM.MainUI.Settings.CreateHeading("sendingOptionsTitle", L["Other Settings"])
			:SetStyle("margin.left", 8)
			:SetStyle("margin.bottom", 4)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
			:SetStyle("height", 18)
			:SetStyle("margin.top", 4)
			:SetStyle("margin.left", 16)
			:SetStyle("margin.right", 8)
			:SetStyle("margin.bottom", 4)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Mail Disenchantables Max Quality"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "mailPageDropdown")
			:SetStyle("height", 26)
			:SetStyle("width", 300)
			:SetStyle("margin.left", 16)
			:SetStyle("margin.bottom", 8)
			:SetItems(ITEM_QUALITY_DESCS, ITEM_QUALITY_KEYS)
			:SetSettingInfo(TSM.db.global.mailingOptions, "deMaxQuality")
		)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.SoundOnSelectionChanged(self, selection)
	TSMAPI_FOUR.Sound.PlaySound(TSM.db.global.mailingOptions.openMailSound)
end

function private.RestartDelayOnEscapePressed(self)
	self:SetText(TSM.db.global.mailingOptions.resendDelay)
	self:Draw()
end

function private.RestartDelayOnEnterPressed(self)
	local value = tonumber(strtrim(self:GetText()))
	if value then
		value = TSMAPI_FOUR.Util.Round(value, 0.5)
		TSM.db.global.mailingOptions.resendDelay = value
	else
		value = TSM.db.global.mailingOptions.resendDelay
	end
	self:SetText(value)
	self:Draw()
end
