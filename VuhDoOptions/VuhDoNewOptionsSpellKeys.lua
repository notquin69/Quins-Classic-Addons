

--
function VUHDO_newOptionsSpellEditBoxSpellId(anEditBox)
	local tText, tR, tG, tB = VUHDO_isActionValid(anEditBox:GetText(), anIsCustom);
	local tLabel = _G[anEditBox:GetName() .. "Hint"];
	if (tText ~= nil) then
		anEditBox:SetTextColor(1, 1, 1, 1);
		tLabel:SetText(tText);
		tLabel:SetTextColor(tR, tG, tB, 1);
	else
		anEditBox:SetTextColor(0.8, 0.8, 1, 1);
		tLabel:SetText("");
	end
end

