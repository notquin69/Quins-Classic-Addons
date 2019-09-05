local _;

VUHDO_COMBO_MODEL = nil;
VUHDO_SPELL_TRACE_TEMP_MODEL = nil;
local VUHDO_SPELL_TRACE_SORTABLE = { };



--
local tStoredName;
local tIndex;
local tSpellNameById;
function VUHDO_initSpellTraceComboModel()

	VUHDO_SPELL_TRACE_SORTABLE = { };

	for _, tStoredName in pairs(VUHDO_CONFIG["SPELL_TRACE"]["STORED"]) do
		tinsert(VUHDO_SPELL_TRACE_SORTABLE, tStoredName);
	end
	
	table.sort(VUHDO_SPELL_TRACE_SORTABLE,
		function(tSpell, tAnotherSpell)
			return VUHDO_resolveSpellId(tSpell) < VUHDO_resolveSpellId(tAnotherSpell);
		end
	);

	VUHDO_COMBO_MODEL = { };

	for tIndex, tStoredName in ipairs(VUHDO_SPELL_TRACE_SORTABLE) do
		tSpellNameById = VUHDO_resolveSpellId(tStoredName);

		if (tSpellNameById ~= tStoredName) then
			VUHDO_COMBO_MODEL[tIndex] = { tStoredName, "[" .. tStoredName .. "] " .. tSpellNameById };
		else
			VUHDO_COMBO_MODEL[tIndex] = { tStoredName, tStoredName };
		end
	end

end



--
function VUHDO_setupSpellTraceComboModel(aComboBox)

	VUHDO_initSpellTraceComboModel();
	VUHDO_notifySpellTraceSelect(aComboBox, VUHDO_CONFIG.SPELL_TRACE.SELECTED);

	VUHDO_setComboModel(aComboBox, "VUHDO_CONFIG.SPELL_TRACE.SELECTED", VUHDO_COMBO_MODEL);
	VUHDO_lnfComboBoxInitFromModel(aComboBox);

end



--
function VUHDO_notifySpellTraceSelect(aComboBox, aValue)

	if (VuhDoNewOptionsGeneralSpellTraceStorePanelEditBox ~= nil and aValue ~= nil) then
		VuhDoNewOptionsGeneralSpellTraceStorePanelEditBox:SetText(aValue);
	else
		VuhDoNewOptionsGeneralSpellTraceStorePanelEditBox:SetText("");
	end

end



--
local tValue;
local tIndex;
local tModel;
local tPanelName;
local tCheckButton;
local tComboBox;
local tDurationFrame;
local tSlider;
function VUHDO_spellTraceUpdateEditBox(anEditBox)

	tValue = anEditBox:GetText();
	tIndex = VUHDO_tableGetKeyFromValue(VUHDO_CONFIG["SPELL_TRACE"]["STORED"], tValue);

	if (tIndex ~= nil) then
		tModel = "VUHDO_CONFIG.SPELL_TRACE.STORED_SETTINGS." .. tValue;
	else
		VUHDO_SPELL_TRACE_TEMP_MODEL = {
			["isMine"] = VUHDO_CONFIG["SPELL_TRACE"]["isMine"],
			["isOthers"] = VUHDO_CONFIG["SPELL_TRACE"]["isOthers"],
			["duration"] = VUHDO_CONFIG["SPELL_TRACE"]["duration"],
		};

		tModel = "VUHDO_SPELL_TRACE_TEMP_MODEL";
	end

	anEditBox:SetTextColor(1, 1, 1, 1);

	tPanelName = anEditBox:GetParent():GetName();

	tCheckButton = _G[tPanelName .. "MineCheckButton"];
	VUHDO_lnfSetModel(tCheckButton, tModel .. ".isMine");
	VUHDO_lnfCheckButtonInitFromModel(tCheckButton);

	tCheckButton = _G[tPanelName .. "OthersCheckButton"];
	VUHDO_lnfSetModel(tCheckButton, tModel .. ".isOthers");
	VUHDO_lnfCheckButtonInitFromModel(tCheckButton);

	tDurationFrame = _G[tPanelName .. "DurationFrame"];

	tSlider = _G[tDurationFrame:GetName() .. "Slider"];
	VUHDO_lnfSliderOnLoad(tSlider, VUHDO_I18N_DURATION, 0, 30, " " .. VUHDO_I18N_SEC);
	VUHDO_lnfSetModel(tSlider, tModel .. ".duration");
	VUHDO_lnfSliderInitFromModel(tSlider);

	tDurationFrame:Hide();
	tDurationFrame:Show();

	anEditBox:GetParent():Show();

end



--
local tEditBox;
local tValue;
local tIndex;
local tCheckButton;
local tPanelName;
local tSlider;
function VUHDO_saveSpellTraceOnClick(aButton)

	tEditBox = _G[aButton:GetParent():GetName() .. "EditBox"];
	tValue = strtrim(tEditBox:GetText());
	tIndex = VUHDO_tableGetKeyFromValue(VUHDO_CONFIG["SPELL_TRACE"]["STORED"], tValue);

	if (tIndex == nil and #tValue > 0) then
		tinsert(VUHDO_CONFIG["SPELL_TRACE"]["STORED"], tValue);
		VuhDoNewOptionsGeneralSpellTraceStorePanelEditBox:SetText(tValue);
		VuhDoNewOptionsGeneralSpellTraceStorePanelEditBox:SetTextColor(1, 1, 1);
	end

	tPanelName = aButton:GetParent():GetName();

	if (VUHDO_CONFIG["SPELL_TRACE"]["STORED_SETTINGS"][tValue] == nil) then
		VUHDO_CONFIG["SPELL_TRACE"]["STORED_SETTINGS"][tValue] = { };
	end

	tCheckButton = _G[tPanelName .. "MineCheckButton"];
	VUHDO_CONFIG["SPELL_TRACE"]["STORED_SETTINGS"][tValue].isMine = VUHDO_forceBooleanValue(tCheckButton:GetChecked());

	tCheckButton = _G[tPanelName .. "OthersCheckButton"];
	VUHDO_CONFIG["SPELL_TRACE"]["STORED_SETTINGS"][tValue].isOthers = VUHDO_forceBooleanValue(tCheckButton:GetChecked());

	tSlider = _G[tPanelName .. "DurationFrameSliderSlider"];
	VUHDO_CONFIG["SPELL_TRACE"]["STORED_SETTINGS"][tValue].duration = tSlider:GetValue() or VUHDO_CONFIG["SPELL_TRACE"].duration;

	VUHDO_CONFIG["SPELL_TRACE"]["SELECTED"] = tValue;
	VUHDO_initSpellTraceComboModel();

	VUHDO_spellTraceUpdateEditBox(VuhDoNewOptionsGeneralSpellTraceStorePanelEditBox);

	VuhDoNewOptionsGeneralSpellTrace:Hide();
	VuhDoNewOptionsGeneralSpellTrace:Show();
end



--
function VUHDO_deleteSpellTraceOnClick(aButton)

	local tEditBox = _G[aButton:GetParent():GetName() .. "EditBox"];
	local tValue = strtrim(tEditBox:GetText());

	local tIndex = VUHDO_tableGetKeyFromValue(VUHDO_CONFIG["SPELL_TRACE"]["STORED"], tValue);

	if (tIndex ~= nil and #tValue > 0) then
		tremove(VUHDO_CONFIG["SPELL_TRACE"]["STORED"], tIndex);
		VUHDO_CONFIG["SPELL_TRACE"]["STORED_SETTINGS"][tValue] = nil;
		VUHDO_Msg(VUHDO_I18N_SPELL_TRACE .. " on spell \"" .. tValue .. "\" removed.", 1, 0.4, 0.4);
	else
		VUHDO_Msg(VUHDO_I18N_SPELL_TRACE .. " on spell \"" .. tValue .. "\" doesn't exist.", 1, 0.4, 0.4);
	end

	VUHDO_initSpellTraceComboModel();
	VUHDO_spellTraceUpdateEditBox(VuhDoNewOptionsGeneralSpellTraceStorePanelEditBox);
	
	VuhDoNewOptionsGeneralSpellTrace:Hide();
	VuhDoNewOptionsGeneralSpellTrace:Show();

	VuhDoNewOptionsGeneralSpellTraceStorePanelEditBox:SetText("");

end

