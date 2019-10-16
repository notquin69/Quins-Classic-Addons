local _;

VUHDO_DEBUFF_BLACKLIST_SORTABLE = { };
VUHDO_DEBUFF_IGNORE_COMBO_MODEL = { };
VUHDO_SELECTED_DEBUFF_IGNORE = "";



--
local tSpellNameById;
function VUHDO_initDebuffIgnoreComboModel()

	table.wipe(VUHDO_DEBUFF_BLACKLIST_SORTABLE);
	for tName, _ in pairs(VUHDO_DEBUFF_BLACKLIST) do
		tinsert(VUHDO_DEBUFF_BLACKLIST_SORTABLE, tName);
	end
	
	table.sort(VUHDO_DEBUFF_BLACKLIST_SORTABLE,
	    function(aDebuff, anotherDebuff)
		    return VUHDO_resolveSpellId(aDebuff) < VUHDO_resolveSpellId(anotherDebuff);
	    end
	);

	table.wipe(VUHDO_DEBUFF_IGNORE_COMBO_MODEL);
	for _, tName in pairs(VUHDO_DEBUFF_BLACKLIST_SORTABLE) do 
		tSpellNameById = VUHDO_resolveSpellId(tName);

		if (tSpellNameById ~= tName) then
			tinsert(VUHDO_DEBUFF_IGNORE_COMBO_MODEL, { tName, "[" .. tName .. "] " .. tSpellNameById });
		else
			tinsert(VUHDO_DEBUFF_IGNORE_COMBO_MODEL, { tName, tName });
		end
	end
end



--
local tText;
function VUHDO_saveDebuffIgnoreClicked(aButton)
	local tText = _G[aButton:GetParent():GetName() .. "IgnoreComboBoxEditBox"]:GetText();
	if (tText ~= nil) then
		VUHDO_DEBUFF_BLACKLIST[strtrim(tText)] = true;
		VUHDO_initDebuffIgnoreComboModel();
		_G[aButton:GetParent():GetName() .. "IgnoreComboBox"]:Hide();
		_G[aButton:GetParent():GetName() .. "IgnoreComboBox"]:Show();
	end
end



--
function VUHDO_deleteDebuffIgnoreClicked(aButton)
	local tText = _G[aButton:GetParent():GetName() .. "IgnoreComboBoxEditBox"]:GetText();

	if (tText ~= nil) then
		if (VUHDO_DEBUFF_BLACKLIST[strtrim(tText)]) then
			VUHDO_DEBUFF_BLACKLIST[strtrim(tText)] = nil;
		else
			local tSpellId = string.match(tText, [[([^\]\[]+)]]);

			if (tSpellId ~= nil and VUHDO_DEBUFF_BLACKLIST[tSpellId]) then
				VUHDO_DEBUFF_BLACKLIST[tSpellId] = nil;
			end
		end


		VUHDO_initDebuffIgnoreComboModel();
		_G[aButton:GetParent():GetName() .. "IgnoreComboBox"]:Hide();
		_G[aButton:GetParent():GetName() .. "IgnoreComboBox"]:Show();
	end
end



--
function VUHDO_addDebuffToBlacklist(aCuDeIconFrame)

	if not aCuDeIconFrame then
		return;
	end

	local debuffName = aCuDeIconFrame["debuffInfo"];
				
	if debuffName then
		local debuffSpellId = strtrim(aCuDeIconFrame["debuffSpellId"]);

		if not VUHDO_DEBUFF_BLACKLIST[debuffSpellId] then
			VUHDO_DEBUFF_BLACKLIST[debuffSpellId] = true;
	
			VUHDO_updateAllDebuffIcons(false);
			VUHDO_initDebuffIgnoreComboModel();
	
			VUHDO_Msg(format(VUHDO_I18N_DEBUFF_BLACKLIST_ADDED, debuffSpellId, debuffName), 1, 0.4, 0.4);
		end
	end

end

