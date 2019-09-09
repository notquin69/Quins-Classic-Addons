-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local General = TSM.MainUI.Settings:NewPackage("General")
local L = TSM.L
local LibDBIcon = LibStub("LibDBIcon-1.0")
local private = {
	frame = nil,
	characterList = {},
	guildList = {},
	chatFrameList = {},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function General.OnInitialize()
	TSM.MainUI.Settings.RegisterSettingPage("General Settings", "top", private.GetGeneralSettingsFrame)
	TSM.Sync.Connection.RegisterConnectionChangedCallback(private.SyncConnectionChangedCallback)
end



-- ============================================================================
-- General Settings UI
-- ============================================================================

function private.GetGeneralSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "general")
	wipe(private.chatFrameList)
	local defaultChatFrame = nil
	for i = 1, NUM_CHAT_WINDOWS do
		local name = strlower(GetChatWindowInfo(i) or "")
		if DEFAULT_CHAT_FRAME == _G["ChatFrame"..i] then
			defaultChatFrame = name
		end
		if name ~= "" then
			tinsert(private.chatFrameList, name)
		end
	end
	if not tContains(private.chatFrameList, TSM.db.global.coreOptions.chatFrame) then
		TSM.db.global.coreOptions.chatFrame = defaultChatFrame
	end

	wipe(private.characterList)
	for _, character in TSMAPI_FOUR.PlayerInfo.CharacterIterator(true) do
		if character ~= UnitName("player") then
			tinsert(private.characterList, character)
		end
	end

	wipe(private.guildList)
	for guild in TSMAPI_FOUR.PlayerInfo.GuildIterator(true) do
		tinsert(private.guildList, guild)
	end

	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "generalSettings")
		:SetStyle("padding.left", 12)
		:SetStyle("padding.right", 12)
		:SetScript("OnUpdate", private.FrameOnUpdate)
		:SetScript("OnHide", private.FrameOnHide)
		:AddChild(TSM.MainUI.Settings.CreateHeading("generalHeading", L["General Options"])
			:SetStyle("margin.bottom", 16)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "checkboxLine")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 28)
			:SetStyle("margin.bottom", 8)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "minimapCheckbox")
				:SetStyle("autoWidth", true)
				:SetStyle("height", 24)
				:SetStyle("margin.left", -5)
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 12)
				:SetText(L["Hide minimap icon"])
				:SetSettingInfo(TSM.db.global.coreOptions.minimapIcon, "hide")
				:SetScript("OnValueChanged", private.MinimapOnValueChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "globalOperationCheckbox")
				:SetStyle("height", 24)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 12)
				:SetText(L["Store operations globally"])
				:SetChecked(TSM.db.global.coreOptions.globalOperations)
				:SetScript("OnValueChanged", private.GlobalOperationsOnValueChanged)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "groupPriceLabel")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 4)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Filter group item lists based on the following price source"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "groupPriceLine")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin.top", 8)
			:SetStyle("margin.bottom", 24)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 14)
				:SetStyle("justifyH", "LEFT")
				:SetSettingInfo(TSM.db.global.coreOptions, "groupPriceSource", private.CheckCustomPrice)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "btn")
				:SetStyle("width", 240)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetText(strupper(RESET))
				:SetScript("OnClick", private.GroupPriceResetBtnOnClick)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "dropdownLabelLine")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 4)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "chatTabLabel")
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Chat Tab"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "forgetLabel")
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Forget Character"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "ignoreLabel")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Ignore Guilds"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "dropdownLabelLine")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 24)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "chatTabDropdown")
				:SetStyle("margin.right", 16)
				:SetItems(private.chatFrameList, private.chatFrameList)
				:SetSettingInfo(TSM.db.global.coreOptions, "chatFrame")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "forgetDropdown")
				:SetStyle("margin.right", 16)
				:SetItems(private.characterList, private.characterList)
				:SetScript("OnSelectionChanged", private.ForgetCharacterOnSelectionChanged)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("MultiselectionDropdown", "ignoreDropdown")
				:SetItems(private.guildList, private.guildList)
				:SetSettingInfo(TSM.db.factionrealm.coreOptions, "ignoreGuilds")
			)
		)
		:AddChild(TSM.MainUI.Settings.CreateHeading("profilesHeading", L["Profiles"]))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "profilesDesc")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 16)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Below, you can manage your profiles which allow you to have entirely different sets of groups."])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "currentProfileHeading")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 4)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["Current Profiles"])
		)
		:AddChildrenWithFunction(private.AddProfileRows)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "newProfileLine")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin.top", 8)
			:SetStyle("margin.bottom", 24)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "newProfileInput")
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 14)
				:SetStyle("justifyH", "LEFT")
				:SetStyle("hintJustifyH", "LEFT")
				:SetHintText(L["Enter a name for the new profile"])
				:SetScript("OnEnterPressed", private.NewProfileInputOnEnterPressed)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "newProfileBtn")
				:SetStyle("width", 240)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetText(L["CREATE NEW PROFILE"])
				:SetScript("OnClick", private.NewProfileBtnOnClick)
			)
		)
		:AddChild(TSM.MainUI.Settings.CreateHeading("accountSyncHeader", L["Account Syncing"]))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "accountSyncDesc")
			:SetStyle("height", 36)
			:SetStyle("margin.bottom", 4)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetStyle("fontSpacing", 2)
			:SetText(L["TSM can sync data automatically between multiple accounts. Also, you can also send your currently active profile to connected accounts to quickly send your groups and operations to other accounts."])
		)
		:AddChildrenWithFunction(private.AddAccountSyncRows)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "accountSyncLine")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin.top", 8)
			:SetStyle("margin.bottom", 24)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "newAccountSyncInput")
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 14)
				:SetStyle("justifyH", "LEFT")
				:SetStyle("hintJustifyH", "LEFT")
				:SetHintText(L["Enter name of logged-in character from other account"])
				:SetScript("OnEnterPressed", private.NewAccountSyncInputOnEnterPressed)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "newAccountSyncBtn")
				:SetStyle("width", 240)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetText(L["SETUP ACCOUNT SYNC"])
				:SetScript("OnClick", private.NewAccountSyncBtnOnClick)
			)
		)
		:AddChild(TSM.MainUI.Settings.CreateHeading("twitterHeader", L["Twitter Integration"]))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "twitterDesc")
			:SetStyle("height", 36)
			:SetStyle("margin.bottom", 8)
			:SetStyle("fontHeight", 14)
			:SetStyle("textColor", "#ffffff")
			:SetStyle("fontSpacing", 2)
			:SetText(L["If you have WoW's Twitter integration setup, TSM will add a share link to its enhanced auction sale / purchase messages, as well as replace URLs with a TSM link."])
		)
		:AddChildrenWithFunction(private.AddTwitterSetting)
end

function private.AddProfileRows(frame)
	for index, profileName in TSM.db:ProfileIterator() do
		local isCurrentProfile = profileName == TSM.db:GetCurrentProfile()
		frame:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "profileRow_"..index)
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 28)
			:SetStyle("margin.left", -16)
			:SetStyle("margin.right", -12)
			:SetStyle("padding.left", 16)
			:SetStyle("padding.right", 12)
			:SetScript("OnEnter", private.ProfileRowOnEnter)
			:SetScript("OnLeave", private.ProfileRowOnLeave)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "checkbox")
				:SetStyle("autoWidth", true)
				:SetStyle("margin.left", -5)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 12)
				:SetText(profileName)
				:SetChecked(isCurrentProfile)
				:SetScript("OnValueChanged", private.ProfileCheckboxOnValueChanged)
				:SetScript("OnEnter", TSM.UI.GetPropagateScriptFunc("OnEnter"))
				:SetScript("OnLeave", TSM.UI.GetPropagateScriptFunc("OnLeave"))
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "duplicateRenameBtn")
				:SetStyle("width", 110)
				:SetStyle("height", 20)
				:SetStyle("margin.right", 8)
				:SetContext(profileName)
				:SetText(isCurrentProfile and L["Rename"] or L["Duplicate"])
				:SetScript("OnClick", isCurrentProfile and private.RenameProfileOnClick or private.DuplicateProfileOnClick)
				:SetScript("OnEnter", TSM.UI.GetPropagateScriptFunc("OnEnter"))
				:SetScript("OnLeave", TSM.UI.GetPropagateScriptFunc("OnLeave"))
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "deleteResetBtn")
				:SetStyle("width", 110)
				:SetStyle("height", 20)
				:SetContext(profileName)
				:SetText(isCurrentProfile and RESET or DELETE)
				:SetScript("OnClick", isCurrentProfile and private.ResetProfileOnClick or private.RemoveProfileOnClick)
				:SetScript("OnEnter", TSM.UI.GetPropagateScriptFunc("OnEnter"))
				:SetScript("OnLeave", TSM.UI.GetPropagateScriptFunc("OnLeave"))
			)
		)
		frame:GetElement("profileRow_"..index..".duplicateRenameBtn"):Hide()
		frame:GetElement("profileRow_"..index..".deleteResetBtn"):Hide()
	end
end

function private.AddAccountSyncRows(frame)
	local newAccountStatusText = TSM.Sync.Connection.GetNewAccountStatus()
	if newAccountStatusText then
		frame:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "accountSyncRow_New")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 28)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "status")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 12)
				:SetText(newAccountStatusText)
			)
		)
	end
	for _, account in TSM.db:SyncAccountIterator() do
		local characters = TSMAPI_FOUR.Util.AcquireTempTable()
		for _, character in TSM.db:FactionrealmCharacterByAccountIterator(account) do
			tinsert(characters, character)
		end
		sort(characters)
		local statusText = TSM.Sync.Connection.GetStatus(account).." | "..table.concat(characters, ", ")
		TSMAPI_FOUR.Util.ReleaseTempTable(characters)
		frame:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "accountSyncRow_"..account)
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 28)
			:SetStyle("margin.left", -16)
			:SetStyle("margin.right", -12)
			:SetStyle("padding.left", 16)
			:SetStyle("padding.right", 12)
			:SetContext(account)
			:SetScript("OnEnter", private.AccountSyncRowOnEnter)
			:SetScript("OnLeave", private.AccountSyncRowOnLeave)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "status")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 12)
				:SetText(statusText)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "sendProfileBtn")
				:SetStyle("width", 110)
				:SetStyle("height", 20)
				:SetStyle("margin.right", 4)
				:SetText(L["Send Profile"])
				:SetScript("OnClick", private.SendProfileOnClick)
				:SetScript("OnEnter", TSM.UI.GetPropagateScriptFunc("OnEnter"))
				:SetScript("OnLeave", TSM.UI.GetPropagateScriptFunc("OnLeave"))
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "removeBtn")
				:SetStyle("width", 110)
				:SetStyle("height", 20)
				:SetText(REMOVE)
				:SetScript("OnClick", private.RemoveAccountSyncOnClick)
				:SetScript("OnEnter", TSM.UI.GetPropagateScriptFunc("OnEnter"))
				:SetScript("OnLeave", TSM.UI.GetPropagateScriptFunc("OnLeave"))
			)
		)
		frame:GetElement("accountSyncRow_"..account..".sendProfileBtn"):Hide()
		frame:GetElement("accountSyncRow_"..account..".removeBtn"):Hide()
	end
end

function private.AddTwitterSetting(frame)
	if C_Social.IsSocialEnabled() or true then
		frame:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "checkbox")
			:SetStyle("height", 28)
			:SetStyle("margin.left", -5)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 12)
			:SetSettingInfo(TSM.db.global.coreOptions, "tsmItemTweetEnabled")
			:SetText(L["Enable tweet enhancement"])
		)
	else
		frame:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
			:SetStyle("textColor", "#c41f3b")
			:SetStyle("height", 20)
			:SetStyle("fontHeight", 18)
			:SetStyle("justifyH", "CENTER")
			:SetText(L["Twitter Integration Not Enabled"])
		)
	end
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.SyncConnectionChangedCallback()
	if private.frame then
		private.frame:GetParentElement():ReloadContent()
	end
end

function private.FrameOnUpdate(frame)
	frame:SetScript("OnUpdate", nil)
	private.frame = frame
end

function private.FrameOnHide(frame)
	private.frame = nil
end

function private.MinimapOnValueChanged(self, value)
	if value then
		LibDBIcon:Hide("TradeSkillMaster")
	else
		LibDBIcon:Show("TradeSkillMaster")
	end
end

function private.GlobalOperationsOnValueChanged(checkbox, value)
	-- restore the previous value until it's confirmed
	checkbox:SetChecked(not value, true)
	local desc = L["If you have multiple profile set up with operations, enabling this will cause all but the current profile's operations to be irreversibly lost. Are you sure you want to continue?"]
	checkbox:GetBaseElement():ShowConfirmationDialog(L["Global Operation Confirmation"], desc, OKAY, private.GlobalOperationsConfirmed, checkbox, value)
end

function private.GlobalOperationsConfirmed(checkbox, newValue)
	checkbox:SetChecked(newValue, true)
		:Draw()
	TSM.db.global.coreOptions.globalOperations = newValue
	TSM.Operations.SetStoredGlobally(newValue)
end

function private.ChatTabOnSelectionChanged(self, selection)
	TSM.db.global.coreOptions.chatFrame = selection
end

function private.ForgetCharacterOnSelectionChanged(self)
	local character = self:GetSelectedItem()
	if not character then return end
	TSM.db:RemoveSyncCharacter(character)
	TSM.db.factionrealm.internalData.pendingMail[character] = nil
	TSM.db.factionrealm.internalData.characterGuilds[character] = nil
	TSM:Printf(L["%s removed."], character)
	assert(TSMAPI_FOUR.Util.TableRemoveByValue(private.characterList, character) == 1)
	self:SetSelectedItem(nil)
		:SetItems(private.characterList)
		:Draw()
end

function private.ProfileRowOnEnter(frame)
	frame:SetStyle("background", "#30ffd839")
	frame:GetElement("duplicateRenameBtn"):Show()
	frame:GetElement("deleteResetBtn"):Show()
	frame:Draw()
end

function private.ProfileRowOnLeave(frame)
	frame:SetStyle("background", nil)
	frame:GetElement("duplicateRenameBtn"):Hide()
	frame:GetElement("deleteResetBtn"):Hide()
	frame:Draw()
end

function private.ProfileCheckboxOnValueChanged(checkbox, value)
	if not value then
		-- can't uncheck profile checkboxes
		checkbox:SetChecked(true,  true)
		checkbox:Draw()
		return
	end
	-- uncheck the current profile row
	local currentProfileIndex = nil
	for index, profileName in TSM.db:ProfileIterator() do
		if profileName == TSM.db:GetCurrentProfile() then
			assert(not currentProfileIndex)
			currentProfileIndex = index
		end
	end
	local currentProfileRow = checkbox:GetElement("__parent.__parent.profileRow_"..currentProfileIndex)
	currentProfileRow:GetElement("checkbox")
		:SetChecked(false, true)
	currentProfileRow:GetElement("duplicateRenameBtn")
		:SetText(L["Duplicate"])
		:SetScript("OnClick", private.DuplicateProfileOnClick)
	currentProfileRow:GetElement("deleteResetBtn")
		:SetText(DELETE)
		:SetScript("OnClick", private.RemoveProfileOnClick)
	currentProfileRow:Draw()
	-- set the profile
	TSM.db:SetProfile(checkbox:GetText())
	-- set this row as the current one
	checkbox:GetElement("__parent.duplicateRenameBtn")
		:SetText(L["Rename"])
		:SetScript("OnClick", private.RenameProfileOnClick)
		:Draw()
	checkbox:GetElement("__parent.deleteResetBtn")
		:SetText(RESET)
		:SetScript("OnClick", private.ResetProfileOnClick)
		:Draw()
end

function private.RenameProfileOnClick(button)
	local profileName = button:GetContext()
	button:GetBaseElement():ShowDialogFrame(TSMAPI_FOUR.UI.NewElement("Frame", "frame")
		:SetLayout("VERTICAL")
		:SetStyle("width", 600)
		:SetStyle("height", 187)
		:SetStyle("anchors", { { "CENTER" } })
		:SetStyle("background", "#2e2e2e")
		:SetStyle("border", "#e2e2e2")
		:SetStyle("borderSize", 2)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "title")
			:SetStyle("height", 44)
			:SetStyle("margin", { top = 24, left = 16, right = 16, bottom = 16 })
			:SetStyle("font", TSM.UI.Fonts.MontserratBold)
			:SetStyle("fontHeight", 18)
			:SetStyle("justifyH", "CENTER")
			:SetText(L["Rename Profile"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "nameInput")
			:SetStyle("height", 26)
			:SetStyle("margin", { left = 16, right = 16, bottom = 25 })
			:SetStyle("background", "#5c5c5c")
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 12)
			:SetStyle("justifyH", "LEFT")
			:SetStyle("textColor", "#ffffff")
			:SetText(profileName)
			:SetScript("OnEnterPressed", private.RenameProfileInputOnEnterPressed)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "buttons")
			:SetLayout("HORIZONTAL")
			:SetStyle("margin", { left = 16, right = 16, bottom = 16 })
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "spacer")
				-- spacer
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "closeBtn")
				:SetStyle("width", 126)
				:SetStyle("height", 26)
				:SetText(CLOSE)
				:SetScript("OnClick", private.DialogCloseBtnOnClick)
			)
		)
	)
end

function private.DialogCloseBtnOnClick(button)
	button:GetBaseElement():HideDialog()
end

function private.RenameProfileInputOnEnterPressed(input)
	local profileName = input:GetText()
	if not TSM.db:IsValidProfileName(profileName) then
		TSM:Print(L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."])
		return
	elseif TSM.db:ProfileExists(profileName) then
		TSM:Print(L["A profile with this name already exists."])
		return
	end

	-- create a new profile, copy over the settings, then delete the old one
	local prevProfileName = TSM.db:GetCurrentProfile()
	TSM.db:SetProfile(profileName)
	TSM.db:CopyProfile(prevProfileName)
	TSM.db:DeleteProfile(prevProfileName)

	-- hide the dialog and refresh the settings content
	local baseElement = input:GetBaseElement()
	baseElement:HideDialog()
	baseElement:GetElement("content.settings.contentFrame.content"):ReloadContent()
end

function private.DuplicateProfileOnClick(button)
	local profileName = button:GetContext()
	local desc = format(L["This will copy the settings from '%s' into your currently-active one."], profileName)
	button:GetBaseElement():ShowConfirmationDialog(L["Duplicate Profile Confirmation"], desc, OKAY, private.DuplicateProfileConfirmed, profileName)
end

function private.DuplicateProfileConfirmed(profileName)
	TSM.db:CopyProfile(profileName)
end

function private.ResetProfileOnClick(button)
	local desc = L["This will reset all groups and operations (if not stored globally) to be wiped from this profile."]
	button:GetBaseElement():ShowConfirmationDialog(L["Reset Profile Confirmation"], desc, OKAY, private.ResetProfileConfirmed)
end

function private.ResetProfileConfirmed()
	TSM.db:ResetProfile()
end

function private.RemoveProfileOnClick(button)
	local profileName = button:GetContext()
	local desc = format(L["This will permanently delete the '%s' profile."], profileName)
	button:GetBaseElement():ShowConfirmationDialog(L["Delete Profile Confirmation"], desc, OKAY, private.DeleteProfileConfirmed, button, profileName)
end

function private.DeleteProfileConfirmed(button, profileName)
	TSM.db:DeleteProfile(profileName)
	button:GetParentElement():GetParentElement():GetParentElement():ReloadContent()
end

function private.NewProfileInputOnEnterPressed(input)
	input:GetElement("__parent.newProfileBtn"):Click()
end

function private.NewProfileBtnOnClick(button)
	local profileName = strtrim(button:GetElement("__parent.newProfileInput"):GetText())
	if not TSM.db:IsValidProfileName(profileName) then
		TSM:Print(L["This is not a valid profile name. Profile names must be at least one character long and may not contain '@' characters."])
		return
	elseif TSM.db:ProfileExists(profileName) then
		TSM:Print(L["A profile with this name already exists."])
		return
	end
	TSM.db:SetProfile(profileName)
	button:GetParentElement():GetParentElement():GetParentElement():ReloadContent()
end

function private.AccountSyncRowOnEnter(frame)
	frame:GetElement("sendProfileBtn"):Show()
	frame:GetElement("removeBtn"):Show()
	frame:SetStyle("background", "#30ffd839")
	frame:Draw()

	local account = frame:GetContext()
	local tooltipLines = TSMAPI_FOUR.Util.AcquireTempTable()
	tinsert(tooltipLines, "|cffffff00"..L["Sync Status"].."|r")
	tinsert(tooltipLines, L["Inventory / Gold Graph"]..TSM.CONST.TOOLTIP_SEP..TSM.Sync.Mirror.GetStatus(account))
	tinsert(tooltipLines, L["Profession Info"]..TSM.CONST.TOOLTIP_SEP..TSM.Crafting.Sync.GetStatus(account))
	TSM.UI.ShowTooltip(frame:_GetBaseFrame(), table.concat(tooltipLines, "\n"))
	TSMAPI_FOUR.Util.ReleaseTempTable(tooltipLines)
end

function private.AccountSyncRowOnLeave(frame)
	TSM.UI.HideTooltip()
	frame:SetStyle("background", nil)
	frame:GetElement("sendProfileBtn"):Hide()
	frame:GetElement("removeBtn"):Hide()
	frame:Draw()
end

function private.SendProfileOnClick(button)
	local player = TSM.Sync.Connection.GetConnectedPlayerByAccount(button:GetParentElement():GetContext())
	if not player then
		return
	end
	TSM.Groups.Sync.SendCurrentProfile(player)
end

function private.RemoveAccountSyncOnClick(button)
	TSM.Sync.Connection.Remove(button:GetParentElement():GetContext())
	button:GetParentElement():GetParentElement():GetParentElement():ReloadContent()
	TSM:Print(L["Account sync removed. Please delete the account sync from the other account as well."])
end

function private.NewAccountSyncInputOnEnterPressed(input)
	input:GetElement("__parent.newAccountSyncBtn"):Click()
end

function private.NewAccountSyncBtnOnClick(button)
	local input = button:GetElement("__parent.newAccountSyncInput")
	local character = strtrim(input:GetText())
	if TSM.Sync.Connection.Establish(character) then
		TSM:Printf(L["Establishing connection to %s. Make sure that you've entered this character's name on the other account."], character)
		private.SyncConnectionChangedCallback()
	else
		input:SetText("")
		input:Draw()
	end
end

function private.CheckCustomPrice(value)
	local isValid, err = TSMAPI_FOUR.CustomPrice.Validate(value)
	if isValid then
		return true
	else
		TSM:Print(L["Invalid custom price."].." "..err)
		return false
	end
end

function private.GroupPriceResetBtnOnClick(button)
	TSM.db.global.coreOptions.groupPriceSource = TSM.db:GetDefault("global", "coreOptions", "groupPriceSource")
    button:GetElement("__parent.input")
        :SetText(TSM.db.global.coreOptions.groupPriceSource)
        :Draw()
end
