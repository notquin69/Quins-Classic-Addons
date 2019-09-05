local _;

VUHDO_KEY_LAYOUT_SHARE_VERSION = 1;

VUHDO_KEY_LAYOUT_COMBO_MODEL = { };
VUHDO_CURR_LAYOUT = "";
VUHDO_IS_DEFAULT_LAYOUT = false;



--
function VUHDO_initKeyLayoutComboModel()
	table.wipe(VUHDO_KEY_LAYOUT_COMBO_MODEL);

	for tName, _ in pairs(VUHDO_SPELL_LAYOUTS) do
		tinsert(VUHDO_KEY_LAYOUT_COMBO_MODEL, { tName, tName });
	end

	table.sort(VUHDO_KEY_LAYOUT_COMBO_MODEL,
		function(anInfo, anotherInfo)
			return anInfo[1] < anotherInfo[1];
		end
	);

	tinsert(VUHDO_KEY_LAYOUT_COMBO_MODEL, 1, {"", " -- " .. VUHDO_I18N_KEY_NONE .. " --" });
end



--
function VUHDO_keyLayoutComboChanged(aComboBox, aValue)
	local tParentName = aComboBox:GetParent():GetName();

	local tSpec1CheckButton = _G[tParentName .. "Spec1CheckButton"];
	tSpec1CheckButton:SetChecked(aValue == VUHDO_SPEC_LAYOUTS["1"]);
	VUHDO_lnfCheckButtonClicked(tSpec1CheckButton);

	local tSpec2CheckButton =  _G[tParentName .. "Spec2CheckButton"];
	tSpec2CheckButton:SetChecked(aValue == VUHDO_SPEC_LAYOUTS["2"]);
	VUHDO_lnfCheckButtonClicked(tSpec2CheckButton);

	local tSpec2CheckButton =  _G[tParentName .. "Spec3CheckButton"];
	tSpec2CheckButton:SetChecked(aValue == VUHDO_SPEC_LAYOUTS["3"]);
	VUHDO_lnfCheckButtonClicked(tSpec2CheckButton);

	local tSpec2CheckButton =  _G[tParentName .. "Spec4CheckButton"];
	tSpec2CheckButton:SetChecked(aValue == VUHDO_SPEC_LAYOUTS["4"]);
	VUHDO_lnfCheckButtonClicked(tSpec2CheckButton);

	VUHDO_updateDefaultLayoutCheckButton(aComboBox:GetParent():GetParent());
end



--
function VUHDO_keyLayoutSpecOnClick(aCheckButton, aSpecId)
	if (not VUHDO_strempty(VUHDO_CURR_LAYOUT)) then
		VUHDO_SPEC_LAYOUTS[aSpecId] = aCheckButton:GetChecked() and VUHDO_CURR_LAYOUT or "";
	else
		VUHDO_Msg(VUHDO_I18N_SELECT_KEY_LAYOUT_FIRST, 1, 0.4, 0.4);
	end
end



--
function VUHDO_keyLayoutInitSpecCheckButton(aCheckButton, aSpecId)
								
	aCheckButton:SetChecked(VUHDO_CURR_LAYOUT == VUHDO_SPEC_LAYOUTS[aSpecId]);
	VUHDO_lnfCheckButtonClicked(aCheckButton);

	local tIndexName;
	local tSpecId = tonumber(aSpecId) or 0;

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
		local _, tSpecName = GetSpecializationInfo(tSpecId);

		if tSpecName then
			_G[aCheckButton:GetName() .. "Label"]:SetText(tIndexName .. "\n(" .. string.sub(tSpecName,1,4) .. ")");
		end
	end

end



--
function VUHDO_deleteKeyLayoutCallback(aDecision)
	if (VUHDO_YES == aDecision) then
		VUHDO_Msg(format(VUHDO_I18N_DELETED_KEY_LAYOUT, VUHDO_CURR_LAYOUT));
		VUHDO_SPELL_LAYOUTS[VUHDO_CURR_LAYOUT] = nil;
		if (VUHDO_CURR_LAYOUT == VUHDO_SPEC_LAYOUTS["selected"]) then
			if (VUHDO_CURR_LAYOUT == VUHDO_DEFAULT_LAYOUT) then
				VUHDO_DEFAULT_LAYOUT = nil;
				VUHDO_IS_DEFAULT_LAYOUT = false;
			end

			VUHDO_SPEC_LAYOUTS["selected"] = "";
			VUHDO_CURR_LAYOUT = "";
		else
			VUHDO_CURR_LAYOUT = VUHDO_SPEC_LAYOUTS["selected"];
		end

		VUHDO_initKeyLayoutComboModel();
		VuhDoNewOptionsToolsKeyLayouts:Hide();
		VuhDoNewOptionsToolsKeyLayouts:Show();
	end
end



--
function VUHDO_keyLayoutDeleteOnClick(aButton)
	if (VUHDO_CURR_LAYOUT ~= nil and VUHDO_CURR_LAYOUT ~= "") then
		VuhDoYesNoFrameText:SetText(format(VUHDO_I18N_DELETE_KEY_LAYOUT_QUESTION, VUHDO_CURR_LAYOUT));
		VuhDoYesNoFrame:SetAttribute("callback", VUHDO_deleteKeyLayoutCallback);
		VuhDoYesNoFrame:Show();
	else
		VUHDO_Msg(VUHDO_I18N_SELECT_KEY_LAYOUT_FIRST, 1, 0.4, 0.4);
	end
end



--
function VUHDO_applyKeyLayoutCallback(aDecision)
	if (VUHDO_YES == aDecision) then
		VUHDO_SPEC_LAYOUTS["selected"] = VUHDO_CURR_LAYOUT;
		VUHDO_activateLayout(VUHDO_CURR_LAYOUT);
	end
end



--
function VUHDO_keyLayoutApplyOnClick(aButton)
	if (VUHDO_CURR_LAYOUT ~= nil and VUHDO_CURR_LAYOUT ~= "" and VUHDO_SPELL_LAYOUTS[VUHDO_CURR_LAYOUT] ~= nil) then
		VuhDoYesNoFrameText:SetText(VUHDO_I18N_OVERWRITE_CURR_KEY_LAYOUT_QUESTION);
		VuhDoYesNoFrame:SetAttribute("callback", VUHDO_applyKeyLayoutCallback);
		VuhDoYesNoFrame:Show();
	else
		VUHDO_Msg(VUHDO_I18N_SELECT_KEY_LAYOUT_FIRST, 1, 0.4, 0.4);
	end
end


--
function VUHDO_saveKeyLayoutCallback(aDecision)
	if (VUHDO_YES == aDecision) then
		VUHDO_SPELL_LAYOUTS[VUHDO_CURR_LAYOUT] = {
			["NAME"] = VUHDO_CURR_LAYOUT, 
			["MOUSE"] = VUHDO_compressTable(VUHDO_SPELL_ASSIGNMENTS),
			["HOSTILE_MOUSE"] = VUHDO_compressTable(VUHDO_HOSTILE_SPELL_ASSIGNMENTS),
			["KEYS"] = VUHDO_compressTable(VUHDO_SPELLS_KEYBOARD),
			["FIRE"] = {
				["T1"] = VUHDO_SPELL_CONFIG["IS_FIRE_TRINKET_1"],
				["T2"] = VUHDO_SPELL_CONFIG["IS_FIRE_TRINKET_2"],
				["I1"] = VUHDO_SPELL_CONFIG["IS_FIRE_CUSTOM_1"],
				["I2"] = VUHDO_SPELL_CONFIG["IS_FIRE_CUSTOM_2"],
				["I1N"] = VUHDO_SPELL_CONFIG["FIRE_CUSTOM_1_SPELL"],
				["I2N"] = VUHDO_SPELL_CONFIG["FIRE_CUSTOM_2_SPELL"],
				["T3"] = VUHDO_SPELL_CONFIG["IS_FIRE_GLOVES"],
			},
			["HOTS"] = VUHDO_compressTable(VUHDO_PANEL_SETUP["HOTS"]),
		};

		VUHDO_SPEC_LAYOUTS["selected"] = VUHDO_CURR_LAYOUT;

		if VUHDO_IS_DEFAULT_LAYOUT then
			VUHDO_DEFAULT_LAYOUT = VUHDO_CURR_LAYOUT;
		elseif VUHDO_DEFAULT_LAYOUT == VUHDO_CURR_LAYOUT then
			VUHDO_DEFAULT_LAYOUT = nil;
		end

		VUHDO_Msg(format(VUHDO_I18N_KEY_LAYOUT_SAVED, VUHDO_CURR_LAYOUT));

		VUHDO_initKeyLayoutComboModel();
		VUHDO_lnfComboBoxInitFromModel(VuhDoNewOptionsToolsKeyLayoutsStorePanelLayoutCombo);
	end
end



--
function VUHDO_saveKeyLayoutOnClick(aButton)
	local tEditBox = _G[aButton:GetParent():GetName() .. "SaveAsEditBox"];
	VUHDO_CURR_LAYOUT = strtrim(tEditBox:GetText());

	if #VUHDO_CURR_LAYOUT == 0 then
		VUHDO_Msg(VUHDO_I18N_ENTER_KEY_LAYOUT_NAME, 1, 0.4, 0.4);
		return;
	end

	if VUHDO_SPELL_LAYOUTS[VUHDO_CURR_LAYOUT] then
		VuhDoYesNoFrameText:SetText(format(VUHDO_I18N_OVERWRITE_KEY_LAYOUT_QUESTION, VUHDO_CURR_LAYOUT));
		VuhDoYesNoFrame:SetAttribute("callback", VUHDO_saveKeyLayoutCallback);
		VuhDoYesNoFrame:Show();
	else
		VUHDO_saveKeyLayoutCallback(VUHDO_YES);
	end
end



--
local tKeyLayoutString;
local tKeyLayoutTable;
local function VUHDO_keyLayoutTableToString(aKeyLayout)
	if (aKeyLayout ~= nil) then
		tKeyLayoutTable = {
			["keyLayoutVersion"] = VUHDO_KEY_LAYOUT_SHARE_VERSION, 
			["playerName"] = GetUnitName("player", true),
			["keyLayout"] = aKeyLayout,
		};

		tKeyLayoutString = VUHDO_compressAndPackTable(tKeyLayoutTable);
		tKeyLayoutString = VUHDO_LibBase64.Encode(tKeyLayoutString);

		return tKeyLayoutString;
	end
end



--
local tDecodedKeyLayoutString;
local tKeyLayoutTable;
local function VUHDO_keyLayoutStringToTable(aKeyLayoutString)
	tDecodedKeyLayoutString = VUHDO_LibBase64.Decode(aKeyLayoutString);

	tKeyLayoutTable = VUHDO_decompressIfCompressed(tDecodedKeyLayoutString);

	return tKeyLayoutTable;
end



--
local tEditBox;
local tSelectedKeyLayout;
local tKeyLayout;
function VUHDO_exportKeyLayoutOnClick(aButton)
	tEditBox = _G[aButton:GetParent():GetName() .. "SaveAsEditBox"];
	tSelectedKeyLayout = strtrim(tEditBox:GetText());

	if (#tSelectedKeyLayout == 0 or not VUHDO_SPELL_LAYOUTS[tSelectedKeyLayout]) then
		VUHDO_Msg(VUHDO_I18N_SELECT_KEY_LAYOUT_FIRST, 1, 0.4, 0.4);
		return;
	end

	_G[aButton:GetParent():GetParent():GetName() .. "ExportFrame"]:Show();
end



--
function VUHDO_importKeyLayoutOnClick(aButton)
	_G[aButton:GetParent():GetParent():GetName() .. "ImportFrame"]:Show();
end



--
local tEditBox;
local tSelectedKeyLayout;
local tKeyLayout;
function VUHDO_keyLayoutExportButtonShown(aEditBox)
	tEditBox = _G[aEditBox:GetParent():GetParent():GetParent():GetParent():GetName() .. "StorePanelSaveAsEditBox"];
	tSelectedKeyLayout = strtrim(tEditBox:GetText());

	tKeyLayout = VUHDO_SPELL_LAYOUTS[tSelectedKeyLayout];

	if (#tSelectedKeyLayout == 0 or not tKeyLayout) then
		VUHDO_Msg(VUHDO_I18N_SELECT_KEY_LAYOUT_FIRST, 1, 0.4, 0.4);
		return;
	end

	if ((tKeyLayout["NAME"] or "") == "") then
		tKeyLayout["NAME"] = tSelectedKeyLayout;
	end

	tEditText = VUHDO_keyLayoutTableToString(tKeyLayout);

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
function VUHDO_keyLayoutImport(aEditBoxName)
	tImportString = _G[aEditBoxName]:GetText();
	tImportTable = VUHDO_keyLayoutStringToTable(tImportString);

	if (tImportTable == nil or tImportTable["keyLayoutVersion"] == nil or tonumber(tImportTable["keyLayoutVersion"]) == nil or 
		tonumber(tImportTable["keyLayoutVersion"]) ~= VUHDO_KEY_LAYOUT_SHARE_VERSION or tImportTable["playerName"] == nil or 
		tImportTable["keyLayout"] == nil or tImportTable["keyLayout"]["NAME"] == nil) then
		VUHDO_Msg(VUHDO_I18N_IMPORT_STRING_INVALID);

		return;
	end

	tKeyLayout = tImportTable["keyLayout"];
	tName = tKeyLayout["NAME"];

	if (VUHDO_SPELL_LAYOUTS[tName] ~= nil) then
		tPos = strfind(tName, ": ", 1, true);
		
		if (tPos ~= nil) then
			tName = strsub(tName, tPos + 2);
		end

		tKeyLayout["NAME"] = VUHDO_createNewLayoutName(tName, tImportTable["playerName"]);
	end

	VUHDO_SPELL_LAYOUTS[tKeyLayout["NAME"]] = tKeyLayout;

	VUHDO_Msg(format(VUHDO_I18N_KEY_LAYOUT_SAVED, tKeyLayout["NAME"]));
end



--
function VUHDO_yesNoImportKeyLayoutCallback(aDecision)
	if (VUHDO_YES == aDecision) then
		local tEditBoxName = VuhDoYesNoFrame:GetAttribute("importStringEditBoxName"); 

		VUHDO_keyLayoutImport(tEditBoxName);

		VUHDO_initKeyLayoutComboModel();
		VUHDO_lnfComboBoxInitFromModel(VuhDoNewOptionsToolsKeyLayoutsStorePanelLayoutCombo);

		_G[tEditBoxName]:GetParent():GetParent():GetParent():Hide();
	end
end



--
function VUHDO_importKeyLayoutOkayClicked(aButton)
	VuhDoYesNoFrameText:SetText(VUHDO_I18N_REALLY_IMPORT);
	
	VuhDoYesNoFrame:SetAttribute("callback", VUHDO_yesNoImportKeyLayoutCallback);
	VuhDoYesNoFrame:SetAttribute("importStringEditBoxName", aButton:GetParent():GetName() .. "StringScrollFrameStringEditBox");

	VuhDoYesNoFrame:Show();
end



--
function VUHDO_shareCurrentKeyLayout(aUnitName, aKeyLayoutName)
	local tLayout = VUHDO_SPELL_LAYOUTS[aKeyLayoutName];
	if not tLayout then
		VUHDO_Msg("There is no key layout named \"" .. (aKeyLayoutName or "") .. "\"", 1, 0.4, 0.4);
		return;
	end

	local tQuestion = VUHDO_PLAYER_NAME .. " requests to transmit\nKey Layout " .. aKeyLayoutName .. " to you.\nProceed?"
	VUHDO_startShare(aUnitName, { aKeyLayoutName, tLayout }, sCmdKeyLayoutDataChunk, sCmdKeyLayoutDataEnd, tQuestion);
end



--
function VUHDO_keyLayoutDefaultLayoutCheckButtonClicked(aButton)
	local tEditBox = _G[aButton:GetParent():GetName() .. "SaveAsEditBox"];

	local tLayout = VUHDO_SPELL_LAYOUTS[VUHDO_CURR_LAYOUT];

	if (tLayout ~= nil or (strtrim(tEditBox:GetText()) or "") ~= "") then
		VUHDO_IS_DEFAULT_LAYOUT = VUHDO_forceBooleanValue(aButton:GetChecked());
	else
		VUHDO_Msg(VUHDO_I18N_SELECT_KEY_LAYOUT_FIRST, 1, 0.4, 0.4);
	end
end



--
function VUHDO_keyLayoutInitDefaultLayoutCheckButton(aButton)
	local tLayout = VUHDO_SPELL_LAYOUTS[VUHDO_CURR_LAYOUT];

	if (tLayout ~= nil and VUHDO_CURR_LAYOUT == VUHDO_DEFAULT_LAYOUT) then
		VUHDO_IS_DEFAULT_LAYOUT = true;

		aButton:SetChecked(true);
	else
		VUHDO_IS_DEFAULT_LAYOUT = false;

		aButton:SetChecked(false);
	end

	VUHDO_lnfCheckButtonClicked(aButton);
end



--
function VUHDO_updateDefaultLayoutCheckButton(aPanel)
	VUHDO_keyLayoutInitDefaultLayoutCheckButton(_G[aPanel:GetName() .. "StorePanelDefaultLayoutCheckButton"]);
end

