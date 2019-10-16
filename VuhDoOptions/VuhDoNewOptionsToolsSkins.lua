local _;

VUHDO_PROFILE_SHARE_VERSION = 1;

VUHDO_IS_DEFAULT_PROFILE = false;
VUHDO_CURRENT_PROFILE = "";
VUHDO_PROFILE_TABLE_MODEL = { };

--
function VUHDO_initProfileTableModels(aButton)
	table.wipe(VUHDO_PROFILE_TABLE_MODEL);
	VUHDO_PROFILE_TABLE_MODEL[1] = { "", "-- " .. VUHDO_I18N_EMPTY_HOTS .. " --" };
	for tIndex, tValue in ipairs(VUHDO_PROFILES) do
		VUHDO_PROFILE_TABLE_MODEL[tIndex + 1] = { tValue["NAME"], tValue["NAME"] };
	end

	table.sort(VUHDO_PROFILE_TABLE_MODEL,
		function(anInfo, anotherInfo)
			return anInfo[1] < anotherInfo[1];
		end
	);
end



local sProfileCombo = nil;
local sProfileEditBox = nil;



--
function VUHDO_setProfileCombo(aComboBox)
	sProfileCombo = aComboBox;
end



--
function VUHDO_setProfileEditBox(anEditBox)
	sProfileEditBox = anEditBox;
end



--
function VUHDO_updateProfileSelectCombo()
	VUHDO_initProfileTableModels();
	VUHDO_lnfComboBoxInitFromModel(sProfileCombo);
	VUHDO_lnfEditBoxInitFromModel(sProfileEditBox);
end



--
local function VUHDO_clearProfileIfInSlot(aProfileName, aSlot)
	if (VUHDO_CONFIG["AUTO_PROFILES"][aSlot] == aProfileName) then
		VUHDO_CONFIG["AUTO_PROFILES"][aSlot] = nil;
	end
end



--
local function VUHDO_deleteAutoProfile(aName)
	for tCnt = 1, 40 do
		VUHDO_clearProfileIfInSlot(aName, "" .. tCnt);
		VUHDO_clearProfileIfInSlot(aName, "SPEC_1_" .. tCnt);
		VUHDO_clearProfileIfInSlot(aName, "SPEC_2_" .. tCnt);
		VUHDO_clearProfileIfInSlot(aName, "SPEC_3_" .. tCnt);
		VUHDO_clearProfileIfInSlot(aName, "SPEC_4_" .. tCnt);
	end

	VUHDO_clearProfileIfInSlot(aName, "SPEC_1");
	VUHDO_clearProfileIfInSlot(aName, "SPEC_2");
	VUHDO_clearProfileIfInSlot(aName, "SPEC_3");
	VUHDO_clearProfileIfInSlot(aName, "SPEC_4");
end



--
local function VUHDO_isAutoProfileButtonEnabled(aButtonIndex)
	if (VUHDO_CONFIG["AUTO_PROFILES"][aButtonIndex] == VUHDO_CURRENT_PROFILE) then
		return true;
	elseif (strfind(aButtonIndex, "SPEC", 1, true) ~= nil) then
		for tCnt = 1, 40 do
			if (VUHDO_CONFIG["AUTO_PROFILES"][aButtonIndex .. "_" .. tCnt] == VUHDO_CURRENT_PROFILE) then
				return true;
			end
		end
		return false;
	else -- Gruppenbutton
		return VUHDO_CONFIG["AUTO_PROFILES"]["SPEC_1_" .. aButtonIndex] == VUHDO_CURRENT_PROFILE
			or VUHDO_CONFIG["AUTO_PROFILES"]["SPEC_2_" .. aButtonIndex] == VUHDO_CURRENT_PROFILE
			or VUHDO_CONFIG["AUTO_PROFILES"]["SPEC_3_" .. aButtonIndex] == VUHDO_CURRENT_PROFILE
			or VUHDO_CONFIG["AUTO_PROFILES"]["SPEC_4_" .. aButtonIndex] == VUHDO_CURRENT_PROFILE;
	end
end



--
function VUHDO_skinsInitAutoCheckButton(aButton, anIndex)
	aButton:SetChecked(VUHDO_isAutoProfileButtonEnabled(anIndex));
	VUHDO_lnfCheckButtonClicked(aButton);

	local tIndexStart, tIndexEnd = strfind(anIndex, "SPEC", 1, true);

	if ((tIndexStart == 1) and tIndexEnd) then
		local tIndexName;
		local tSpecId = tonumber(string.sub(anIndex, tIndexEnd + 2, tIndexEnd + 2));

		if (tSpecId == 1) then
			tIndexName = VUHDO_I18N_SPEC_1;
		elseif (tSpecId == 2) then
			tIndexName = VUHDO_I18N_SPEC_2;
		elseif (tSpecId == 3) then
			tIndexName = VUHDO_I18N_SPEC_3;
		elseif (tSpecId == 4) then
			tIndexName = VUHDO_I18N_SPEC_4;
		end

		if tIndexName then
			local _, tSpecName = VUHDO_getSpecializationInfo(tSpecId);

			if tSpecName then
				_G[aButton:GetName() .. "Label"]:SetText(tIndexName .. "\n(" .. string.sub(tSpecName,1,4) .. ")");
			end
		end
	end
end



--
function VUHDO_skinsLockCheckButtonClicked(aButton)
	local tIndex, tProfile = VUHDO_getProfileNamedCompressed(VUHDO_CURRENT_PROFILE);
	if (tIndex ~= nil) then
		tProfile["LOCKED"] = VUHDO_forceBooleanValue(aButton:GetChecked());
	end
end



--
function VUHDO_skinsInitLockCheckButton(aButton)
	local tIndex, tProfile = VUHDO_getProfileNamedCompressed(VUHDO_CURRENT_PROFILE);
	aButton:SetChecked(tIndex ~= nil and tProfile["LOCKED"]);
	VUHDO_lnfCheckButtonClicked(aButton);
end



--
function VUHDO_skinsDefaultProfileCheckButtonClicked(aButton)
	local tIndex, _ = VUHDO_getProfileNamedCompressed(VUHDO_CURRENT_PROFILE);

	if (tIndex ~= nil) then
		VUHDO_IS_DEFAULT_PROFILE = VUHDO_forceBooleanValue(aButton:GetChecked());
	else
		VUHDO_Msg(VUHDO_I18N_ERROR_NO_PROFILE .. "\"" .. VUHDO_CURRENT_PROFILE .. "\" !", 1, 0.4, 0.4);
	end
end



--
function VUHDO_skinsInitDefaultProfileCheckButton(aButton)
	local tIndex, _ = VUHDO_getProfileNamedCompressed(VUHDO_CURRENT_PROFILE);

	if (tIndex ~= nil and VUHDO_CURRENT_PROFILE == VUHDO_DEFAULT_PROFILE) then
		VUHDO_IS_DEFAULT_PROFILE = true;

		aButton:SetChecked(true);
	else
		VUHDO_IS_DEFAULT_PROFILE = false;

		aButton:SetChecked(false);
	end

	VUHDO_lnfCheckButtonClicked(aButton);
end



--
function VUHDO_updateDefaultProfileCheckButton(aPanel)
	VUHDO_skinsInitDefaultProfileCheckButton(_G[aPanel:GetName() .. "LoadSavePanelDefaultProfileCheckButton"]);
end



--
local tButton;
local function VUHDO_updateAllAutoProfiles(aPanel)
	for tCnt = 1, 40 do
		tButton = _G[aPanel:GetName() .. "AutoEnablePanel" .. tCnt .. "CheckButton"];
		if (tButton ~= nil) then
			VUHDO_skinsInitAutoCheckButton(tButton, "" .. tCnt);
		end
	end

	VUHDO_skinsInitAutoCheckButton(_G[aPanel:GetName() .. "AutoEnablePanelSpec1CheckButton"], "SPEC_1");
	VUHDO_skinsInitAutoCheckButton(_G[aPanel:GetName() .. "AutoEnablePanelSpec2CheckButton"], "SPEC_2");
	VUHDO_skinsInitAutoCheckButton(_G[aPanel:GetName() .. "AutoEnablePanelSpec3CheckButton"], "SPEC_3");
	VUHDO_skinsInitAutoCheckButton(_G[aPanel:GetName() .. "AutoEnablePanelSpec4CheckButton"], "SPEC_4");
	VUHDO_skinsInitLockCheckButton(_G[aPanel:GetName() .. "SettingsPanelLockCheckButton"]);
end



--
local tPrefix;
local function VUHDO_clearProfileFromPrefix(aProfileName, ...)
	for tCnt = 1, select('#', ...) do
		tPrefix = select(tCnt, ...);
		for tGroupSize = 1, 40 do
			VUHDO_clearProfileIfInSlot(aProfileName, tPrefix .. tGroupSize);
		end
	end
end




--
local tPrefixes = { "SPEC_1", "SPEC_2", "SPEC_3", "SPEC_4" };
local tExistIndex;
local tIsGroupFound;
local tIsSpecSelected;
function VUHDO_skinsSaveAutoProfileButtonEnablement(aPanel, aProfileName)

	tExistIndex, _ = VUHDO_getProfileNamedCompressed(aProfileName);
	if (tExistIndex == nil) then
		return;
	end

	local tSelectedPrefixes = {};

	for tCnt = 1, 4 do
		tIsSpecSelected = _G[aPanel:GetName() .. "AutoEnablePanelSpec" .. tCnt .. "CheckButton"]:GetChecked();

		tSelectedPrefixes["SPEC_" .. tCnt] = tIsSpecSelected and true or false;
	end

	tIsGroupFound = false;
	tIsSpecSelected = false;

	for tPrefix, tIsSelected in pairs(tSelectedPrefixes) do
		if (tIsSelected) then
			for tCnt = 1, 40 do
				tButton = _G[aPanel:GetName() .. "AutoEnablePanel" .. tCnt .. "CheckButton"];

				if (tButton ~= nil) then
					if (tButton:GetChecked()) then
						VUHDO_CONFIG["AUTO_PROFILES"][tPrefix .. "_" .. tCnt] = aProfileName;

						tIsGroupFound = true;
					elseif (VUHDO_CONFIG["AUTO_PROFILES"][tPrefix .. "_" .. tCnt] == aProfileName) then
						VUHDO_CONFIG["AUTO_PROFILES"][tPrefix .. "_" .. tCnt] = nil;
					end
				end
			end

			tIsSpecSelected = true;
		else
			VUHDO_clearProfileFromPrefix(aProfileName, tPrefix .. "_");
		end
	end

	if (tIsSpecSelected) then
		for tCnt = 1, 40 do
			tCnt = tostring(tCnt);

			if (VUHDO_CONFIG["AUTO_PROFILES"][tCnt] == aProfileName) then
				VUHDO_CONFIG["AUTO_PROFILES"][tCnt] = nil;
			end
		end
	else
		for tCnt = 1, 40 do
			tCnt = tostring(tCnt);

			tButton = _G[aPanel:GetName() .. "AutoEnablePanel" .. tCnt .. "CheckButton"];

			if (tButton ~= nil) then
				if (tButton:GetChecked()) then
					VUHDO_CONFIG["AUTO_PROFILES"][tCnt] = aProfileName;

					tIsGroupFound = true;
				elseif (VUHDO_CONFIG["AUTO_PROFILES"][tCnt] == aProfileName) then
					VUHDO_CONFIG["AUTO_PROFILES"][tCnt] = nil;
				end
			end
		end
	end

	if (tIsGroupFound) then
		for tPrefix, tIsSelected in pairs(tSelectedPrefixes) do
			if (tIsSelected) then
				VUHDO_clearProfileIfInSlot(aProfileName, tPrefix);
			end
		end
	else
		for tPrefix, tIsSelected in pairs(tSelectedPrefixes) do
			if (tIsSelected) then
				VUHDO_CONFIG["AUTO_PROFILES"][tPrefix] = aProfileName;
			else
				VUHDO_clearProfileIfInSlot(aProfileName, tPrefix);
			end
		end
	end

end



--
local tOldValue;
function VUHDO_profileComboValueChanged(aComboBox, aValue)
	tOldValue = VUHDO_lnfGetValueFromModel(aComboBox);
	if (aValue ~= tOldValue) then
		VUHDO_skinsSaveAutoProfileButtonEnablement(aComboBox:GetParent():GetParent(), tOldValue);
	end

	VUHDO_updateAllAutoProfiles(aComboBox:GetParent():GetParent());
	VUHDO_updateDefaultProfileCheckButton(aComboBox:GetParent():GetParent());
end



--
function VUHDO_skinsAutoCheckButtonClicked(aButton, anIndex)
	local tExistIndex, _ = VUHDO_getProfileNamedCompressed(VUHDO_CURRENT_PROFILE);
	if (tExistIndex == nil) then
		VUHDO_Msg(VUHDO_I18N_ERROR_NO_PROFILE .. "\"" .. VUHDO_CURRENT_PROFILE .. "\" !", 1, 0.4, 0.4);
		aButton:SetChecked(false);
		VUHDO_lnfCheckButtonClicked(aButton);
		return;
	end
end





-- Delete -------------------------------


--
function VUHDO_deleteProfile(aName)
	local tIndex, _ = VUHDO_getProfileNamedCompressed(aName);

	if (tIndex ~= nil) then
		tremove(VUHDO_PROFILES, tIndex);
		VUHDO_deleteAutoProfile(aName);
		if (VUHDO_CURRENT_PROFILE == VUHDO_CONFIG["CURRENT_PROFILE"]) then
			if (VUHDO_CURRENT_PROFILE == VUHDO_DEFAULT_PROFILE) then
				VUHDO_DEFAULT_PROFILE = nil;
				VUHDO_IS_DEFAULT_PROFILE = false;
			end

			VUHDO_CURRENT_PROFILE = "";
			VUHDO_CONFIG["CURRENT_PROFILE"] = "";
		else
			VUHDO_CURRENT_PROFILE = VUHDO_CONFIG["CURRENT_PROFILE"];
		end
		VUHDO_updateProfileSelectCombo();
		VUHDO_Msg(VUHDO_I18N_DELETED_PROFILE .. " \"" .. aName .."\".");
	end
end



--
function VUHDO_yesNoDeleteProfileCallback(aDecision)
	if (VUHDO_YES == aDecision) then
		VUHDO_deleteProfile(VuhDoYesNoFrame:GetAttribute("profileName"));
		VUHDO_updateProfileSelectCombo();
	end
end



--
function VUHDO_deleteProfileClicked(aButton)

	if ((VUHDO_CURRENT_PROFILE or "") == "") then
		VUHDO_Msg(VUHDO_I18N_MUST_ENTER_SELECT_PROFILE);
		return;
	end

	local tIndex, _ = VUHDO_getProfileNamedCompressed(VUHDO_CURRENT_PROFILE);
	if (tIndex == nil) then
		VUHDO_Msg(VUHDO_I18N_ERROR_NO_PROFILE .. "\"" .. VUHDO_CURRENT_PROFILE .. "\" !", 1, 0.4, 0.4);
		return;
	end

	VuhDoYesNoFrameText:SetText(VUHDO_I18N_REALLY_DELETE_PROFILE .. " \"" .. VUHDO_CURRENT_PROFILE .. "\"?");
	VuhDoYesNoFrame:SetAttribute("callback", VUHDO_yesNoDeleteProfileCallback);
	VuhDoYesNoFrame:SetAttribute("profileName", VUHDO_CURRENT_PROFILE);
	VuhDoYesNoFrame:Show();
end



--
function VUHDO_saveProfileClicked(aButton)
	if ((VUHDO_CURRENT_PROFILE or "") == "") then
		VUHDO_Msg(VUHDO_I18N_MUST_ENTER_SELECT_PROFILE);
		return;
	end

	local _, tProfile = VUHDO_getProfileNamedCompressed(VUHDO_CURRENT_PROFILE);
	if (tProfile ~= nil and tProfile["LOCKED"]) then
		VUHDO_Msg("Profile " .. VUHDO_CURRENT_PROFILE .. " is currently locked. Please unlock before saving.");
		return;
	end
	VUHDO_CONFIG["CURRENT_PROFILE"] = VUHDO_CURRENT_PROFILE;
	VUHDO_skinsSaveAutoProfileButtonEnablement(aButton:GetParent():GetParent(), VUHDO_CURRENT_PROFILE);
	VUHDO_saveProfile(VUHDO_CURRENT_PROFILE);
end



--
function VUHDO_loadProfileClicked(aButton)
	if ((VUHDO_CURRENT_PROFILE or "") == "") then
		VUHDO_Msg(VUHDO_I18N_MUST_ENTER_SELECT_PROFILE);
		return;
	end

	local tIndex, _ = VUHDO_getProfileNamedCompressed(VUHDO_CURRENT_PROFILE);
	if (tIndex == nil) then
		VUHDO_Msg(VUHDO_I18N_ERROR_NO_PROFILE .. "\"" .. VUHDO_CURRENT_PROFILE .. "\" !", 1, 0.4, 0.4);
		return;
	end

	VuhDoYesNoFrameText:SetText("Loading a profile will overwrite\nyour current settings. Proceed?");
	VuhDoYesNoFrame:SetAttribute("callback",
		function(aDecision)
			if (VUHDO_YES == aDecision) then
				VUHDO_CONFIG["CURRENT_PROFILE"] = VUHDO_CURRENT_PROFILE;
				VUHDO_loadProfile(VUHDO_CURRENT_PROFILE);
			end
		end
	);
	VuhDoYesNoFrame:Show();
end



--
local tProfileString;
local tProfileTable;
local function VUHDO_profileTableToString(aProfile)
	if (aProfile ~= nil) then
		tProfileTable = {
			["profileVersion"] = VUHDO_PROFILE_SHARE_VERSION, 
			["playerName"] = GetUnitName("player", true),
			["profile"] = aProfile,
		};

		tProfileString = VUHDO_compressAndPackTable(tProfileTable);
		tProfileString = VUHDO_LibBase64.Encode(tProfileString);

		return tProfileString;
	end
end



--
local tDecodedProfileString;
local tProfileTable;
local function VUHDO_profileStringToTable(aProfileString)
	tDecodedProfileString = VUHDO_LibBase64.Decode(aProfileString);
	
	tProfileTable = VUHDO_decompressIfCompressed(tDecodedProfileString);

	return tProfileTable;
end



--
function VUHDO_exportProfileClicked(aButton)
	if ((VUHDO_CURRENT_PROFILE or "") == "") then
		VUHDO_Msg(VUHDO_I18N_MUST_ENTER_SELECT_PROFILE);
		return;
	end

	local _, tProfile = VUHDO_getProfileNamedCompressed(VUHDO_CURRENT_PROFILE);

	if (tProfile == nil) then
		VUHDO_Msg(VUHDO_I18N_ERROR_NO_PROFILE .. "\"" .. VUHDO_CURRENT_PROFILE .. "\" !", 1, 0.4, 0.4);
		return;
	end

	if (tProfile["HARDLOCKED"]) then
		VUHDO_Msg("You cannot share hardlocked profiles. Please make a copy before.", 1, 0.4, 0.4);
		return;
	end

	_G[aButton:GetParent():GetParent():GetName() .. "ExportFrame"]:Show();
end



--
function VUHDO_importProfileClicked(aButton)
	_G[aButton:GetParent():GetParent():GetName() .. "ImportFrame"]:Show();
end



--
local tEditText;
function VUHDO_profileExportButtonShown(aEditBox)
	if ((VUHDO_CURRENT_PROFILE or "") == "") then
		VUHDO_Msg(VUHDO_I18N_MUST_ENTER_SELECT_PROFILE);
		return;
	end

	local _, tProfile = VUHDO_getProfileNamed(VUHDO_CURRENT_PROFILE);

	if (tProfile == nil) then
		VUHDO_Msg(VUHDO_I18N_ERROR_NO_PROFILE .. "\"" .. VUHDO_CURRENT_PROFILE .. "\" !", 1, 0.4, 0.4);
		return;
	end

	if (tProfile["HARDLOCKED"]) then
		VUHDO_Msg("You cannot share hardlocked profiles. Please make a copy before.", 1, 0.4, 0.4);
		return;
	end

	tEditText = VUHDO_profileTableToString(tProfile);

	aEditBox:SetText(tEditText);
	aEditBox:SetTextInsets(0, 10, 5, 5);

	aEditBox:Show();
end



--
local tImportString;
local tImportTable;
local tName;
local tProfile;
local tPos;
function VUHDO_profileImport(aEditBoxName)
	tImportString = _G[aEditBoxName]:GetText();
	tImportTable = VUHDO_profileStringToTable(tImportString);

	if (tImportTable == nil or tImportTable["profileVersion"] == nil or tonumber(tImportTable["profileVersion"]) == nil or 
		tonumber(tImportTable["profileVersion"]) ~= VUHDO_PROFILE_SHARE_VERSION or tImportTable["playerName"] == nil or 
		tImportTable["profile"] == nil or tImportTable["profile"]["NAME"] == nil) then
		VUHDO_Msg(VUHDO_I18N_IMPORT_STRING_INVALID);

		return;
	end

	tProfile = tImportTable["profile"];
	tName = tProfile["NAME"];

	if (VUHDO_getProfileNamedCompressed(tName) ~= nil) then
		tPos = strfind(tName, ": ", 1, true);
		
		if (tPos ~= nil) then
			tName = strsub(tName, tPos + 2);
		end

		tProfile["NAME"] = VUHDO_createNewProfileName(tName, tImportTable["playerName"]);
	end

	tinsert(VUHDO_PROFILES, tProfile);

	VUHDO_Msg(VUHDO_I18N_PROFILE_SAVED .. "\"" .. tProfile["NAME"] .. "\".");
end



--
function VUHDO_yesNoImportProfileCallback(aDecision)
	if (VUHDO_YES == aDecision) then
		local tEditBoxName = VuhDoYesNoFrame:GetAttribute("importStringEditBoxName"); 

		VUHDO_profileImport(tEditBoxName);
		VUHDO_updateProfileSelectCombo();

		_G[tEditBoxName]:GetParent():GetParent():GetParent():Hide();
	end
end



--
function VUHDO_importProfileOkayClicked(aButton)
	VuhDoYesNoFrameText:SetText(VUHDO_I18N_REALLY_IMPORT);
	
	VuhDoYesNoFrame:SetAttribute("callback", VUHDO_yesNoImportProfileCallback);
	VuhDoYesNoFrame:SetAttribute("importStringEditBoxName", aButton:GetParent():GetName() .. "StringScrollFrameStringEditBox");

	VuhDoYesNoFrame:Show();
end



--
function VUHDO_shareCurrentProfile(aUnitName, aProfileName)
	local _, tProfile = VUHDO_getProfileNamedCompressed(aProfileName);
	if (tProfile == nil) then
		VUHDO_Msg(VUHDO_I18N_ERROR_NO_PROFILE .. "\"" .. VUHDO_CURRENT_PROFILE .. "\" !", 1, 0.4, 0.4);
		return;
	end
	if (tProfile["HARDLOCKED"]) then
		VUHDO_Msg("You cannot share hardlocked profiles. Please make a copy before.", 1, 0.4, 0.4);
		return;
	end
	local tQuestion = VUHDO_PLAYER_NAME .. " requests to transmit\nProfile " .. aProfileName .. " to you.\nThis will take about 60 secs. Proceed?"
	VUHDO_startShare(aUnitName, tProfile, sCmdProfileDataChunk, sCmdProfileDataEnd, tQuestion);
end








