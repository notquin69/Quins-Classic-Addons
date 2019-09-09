-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Auctioning = TSM.MainUI.Settings:NewPackage("Auctioning")
local L = TSM.L
local private = { sounds = {}, soundkeys = {} }



-- ============================================================================
-- Module Functions
-- ============================================================================

function Auctioning.OnInitialize()
	TSM.MainUI.Settings.RegisterSettingPage("Auctioning", "middle", private.GetAuctioningSettingsFrame)
	for key, name in pairs(TSMAPI_FOUR.Sound.GetSounds()) do
		tinsert(private.sounds, name)
		tinsert(private.soundkeys, key)
	end
end



-- ============================================================================
-- Auctioning Settings UI
-- ============================================================================

function private.GetAuctioningSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "auctioning")
	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "auctioningSettings")
		:SetStyle("padding.left", 12)
		:SetStyle("padding.right", 12)
		:AddChild(TSM.MainUI.Settings.CreateHeading("generalOptionsTitle", L["General Options"])
			:SetStyle("margin.bottom", 15)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "ahOption1Checkbox")
			:SetStyle("height", 28)
			:SetStyle("fontHeight", 12)
			:SetText(L["Cancel auctions with bids"])
			:SetSettingInfo(TSM.db.global.auctioningOptions, "cancelWithBid")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "ahOption2Checkbox")
			:SetStyle("height", 28)
			:SetStyle("fontHeight", 12)
			:SetText(L["Round normal price"])
			:SetSettingInfo(TSM.db.global.auctioningOptions, "roundNormalPrice")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "ahOption3Checkbox")
			:SetStyle("height", 28)
			:SetStyle("margin.bottom", 24)
			:SetStyle("fontHeight", 12)
			:SetText(L["Disable invalid price warnings"])
			:SetSettingInfo(TSM.db.global.auctioningOptions, "disableInvalidMsg")
		)
		:AddChild(TSM.MainUI.Settings.CreateHeading("generalOptionsTitle", L["AH Frame Options"])
			:SetStyle("margin.bottom", 15)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "soundFrame1")
			:SetLayout("HORIZONTAL")
			:SetStyle("margin.bottom", 4)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
				:SetStyle("height", 18)
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Scan Complete Sound"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
				:SetStyle("height", 18)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Confirm Complete Sound"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "soundFrame2")
			:SetLayout("HORIZONTAL")
			:SetStyle("margin.bottom", 16)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "scanCompleteSoundDropdown")
				:SetStyle("height", 26)
				:SetStyle("margin.right", 16)
				:SetItems(private.sounds, private.soundkeys)
				:SetSettingInfo(TSM.db.global.auctioningOptions, "scanCompleteSound")
				:SetScript("OnSelectionChanged", private.SoundOnSelectionChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "confirmCompleteSoundDropdown")
				:SetStyle("height", 26)
				:SetItems(private.sounds, private.soundkeys)
				:SetSettingInfo(TSM.db.global.auctioningOptions, "confirmCompleteSound")
				:SetScript("OnSelectionChanged", private.SoundOnSelectionChanged)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
			:SetStyle("height", 18)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Auction Sale Sound"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "auctionSaleSoundDropdown")
			:SetStyle("height", 26)
			:SetStyle("margin",  { top = 4, bottom = 16 })
			:SetItems(private.sounds, private.soundkeys)
			:SetSettingInfo(TSM.db.global.coreOptions, "auctionSaleSound")
			:SetScript("OnSelectionChanged", private.SoundOnSelectionChanged)
		)
		:AddChild(TSM.MainUI.Settings.CreateHeading("whitelistOptionsTitle", L["Whitelist"])
			:SetStyle("margin.bottom", 4)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "whitelistHelpFrame")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 70)
			:SetStyle("margin", { bottom = 16 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
				:SetStyle("textColor", "#e2e2e2")
				:SetStyle("fontHeight", 14)
				:SetText(L["If you don't want to undercut another player, you can add them to your whitelist and TSM will not undercut them. Note that if somebody on your whitelist matches your buyout but lists a lower bid, TSM will still consider them undercutting you."])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "whitelistToggleRow")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:SetStyle("margin.bottom", 24)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
				:SetStyle("autoWidth", true)
				:SetStyle("margin.right", 8)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 12)
				:SetText(L["Match whitelisted players"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ToggleOnOff", "enableToggle")
				:SetSettingInfo(TSM.db.global.auctioningOptions, "matchWhitelist")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
			:SetStyle("height", 18)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Whitelisted Players"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "whitelistPlayersInputFrame")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin", { bottom = 16 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "nameInput")
				:SetStyle("height", 26)
				:SetStyle("margin", { right = 10 })
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "addBtn")
				:SetStyle("height", 26)
				:SetStyle("width", 238)
				:SetStyle("fontHeight", 14)
				:SetText(L["Add Player"])
				:SetScript("OnClick", private.AddWhitelistOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "whitelistFrame")
			:SetLayout("FLOW")
			:SetStyle("height", 60)
			:AddChildrenWithFunction(private.AddWhitelistRows)
		)
end

function private.AddWhitelistRows(containerFrame)
	for player in pairs(TSM.db.factionrealm.auctioningOptions.whitelist) do
		private.AddWhitelistRow(containerFrame, player)
	end
end

function private.AddWhitelistRow(frame, player)
	frame:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "whitelist_"..player)
		:SetLayout("HORIZONTAL")
		:SetStyle("height", 20)
		:SetStyle("margin", { bottom = 8, right = 12 })
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
			:SetStyle("height", 20)
			:SetStyle("autoWidth", true)
			:SetStyle("font", TSM.UI.Fonts.MontserratBold)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#dd2222")
			:SetStyle("margin", { right = 2 })
			:SetText(player)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "removeBtn")
			:SetStyle("width", 14)
			:SetStyle("height", 14)
			:SetStyle("backgroundTexturePack", "iconPack.14x14/Close/Default")
			:SetContext(player)
			:SetScript("OnClick", private.RemoveWhitelistOnClick)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
	)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.SoundOnSelectionChanged(self)
	TSMAPI_FOUR.Sound.PlaySound(self:GetSelectedItemKey())
end

function private.AddWhitelistOnClick(self)
	local newPlayer = strlower(strtrim(self:GetElement("__parent.nameInput"):GetText()))
	if newPlayer == "" or strfind(newPlayer, ",") or newPlayer ~= TSMAPI_FOUR.Util.StrEscape(newPlayer) then
		TSM:Printf(L["Invalid player name."])
		return
	elseif TSM.db.factionrealm.auctioningOptions.whitelist[newPlayer] then
		TSM:Printf(L["The player \"%s\" is already on your whitelist."], TSM.db.factionrealm.auctioningOptions.whitelist[newPlayer])
		return
	end

	local isAlt = false
	for factionrealm in TSM.db:GetConnectedRealmIterator("factionrealm") do
		for _, character in TSM.db:FactionrealmCharacterIterator(factionrealm) do
			if strlower(newPlayer) == strlower(character) then
				TSM:Printf(L["You do not need to add \"%s\", alts are whitelisted automatically."], newPlayer)
				isAlt = true
			end
		end
	end

	if isAlt then
		return
	end

	TSM.db.factionrealm.auctioningOptions.whitelist[newPlayer] = newPlayer

	-- add a new row to the UI
	local frame = self:GetElement("__parent.__parent.whitelistFrame")
	private.AddWhitelistRow(frame, newPlayer)
	frame:Draw()
end

function private.RemoveWhitelistOnClick(self)
	local player = self:GetContext()
	TSM.db.factionrealm.auctioningOptions.whitelist[player] = nil

	-- remove this row
	local row = self:GetParentElement()
	local frame = row:GetParentElement()
	frame:RemoveChild(row)
	row:Release()
	frame:Draw()
end
