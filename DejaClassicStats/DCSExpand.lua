local _, namespace = ... 	--localization
local L = namespace.L 				--localization

local _, gdbprivate = ...
gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsExpandChecked = {
		ExpandSetChecked = true,
}

gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsExpandButtonChecked = {
		ExpandButtonSetChecked = true,
}

gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsExpandButtonAltPlacementChecked = {
	ExpandButtonAltPlacementSetChecked = false,
}

-- ------------------------------------------------
-- -- DCS Character Frame Expand/Collapse Button --
-- ------------------------------------------------
local DCS_tooltipText
local PaperDollFrame = PaperDollFrame
local CharacterFrame = CharacterFrame

local function DCS_CharacterFrame_Expand()
	DCS_StatScrollFrame:Show()
end

local function DCS_CharacterFrame_Collapse()
	DCS_StatScrollFrame:Hide()
end

local function DCS_ExpandCheck_OnEnter(self)
	GameTooltip:SetOwner(PaperDollFrame.ExpandButton, "ANCHOR_RIGHT");
	GameTooltip:SetText(DCS_tooltipText, 1, 1, 1, 1, true)
	GameTooltip:Show()
end

local function DCS_ExpandCheck_OnLeave(self)
	GameTooltip_Hide()
 end
 
local function DCS_ShownMoveTalentFrame()
	if TalentFrame then
		local checked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandChecked.ExpandSetChecked
		if checked == true then
			local point, relativeTo, relativePoint, xOffset, yOffset = TalentFrame:GetPoint(1)
			-- print(point, relativeTo, relativePoint, xOffset, yOffset)
			if ( relativeTo ) then
				relativeTo = relativeTo:GetName();
			else
				relativeTo = TalentFrame:GetParent():GetName();
			end
			
			-- These are debugging messages for the frame points
			-- Un-comment them to help debug
			-- DEFAULT_CHAT_FRAME:AddMessage(point)
			-- DEFAULT_CHAT_FRAME:AddMessage(relativeTo)
			-- DEFAULT_CHAT_FRAME:AddMessage(relativePoint)
			-- DEFAULT_CHAT_FRAME:AddMessage(xOffset)
			-- DEFAULT_CHAT_FRAME:AddMessage(yOffset)

			TalentFrame:ClearAllPoints()		
			TalentFrame:SetPoint(
				point,
				relativeTo, 
				relativePoint, 
				(xOffset + 200), 
				yOffset)
		end
	end
end

local function DCS_HiddenMoveTalentFrameBack()
	if TalentFrame then
		TalentFrame:ClearAllPoints()		
		TalentFrame:SetPoint(
			"TOPLEFT",
			UIParent, 
			"TOPLEFT", 
			369.00003051758, 
			-104.00000762939)
	end
end

	PaperDollFrame.ExpandButton = CreateFrame("Button", nil, PaperDollFrame)
	PaperDollFrame.ExpandButton:SetSize(32, 32)
	PaperDollFrame.ExpandButton:SetHighlightTexture("Interface\\BUTTONS\\UI-Common-MouseHilight")
	
	PaperDollFrame.ExpandButton:SetScript("OnEnter", DCS_ExpandCheck_OnEnter)
	PaperDollFrame.ExpandButton:SetScript("OnLeave", DCS_ExpandCheck_OnLeave)
			 
	PaperDollFrame.ExpandButton:SetScript("OnMouseUp", function (self)
		local checked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandChecked.ExpandSetChecked
		if checked == true then
			DCS_CharacterFrame_Collapse()
			DCS_HiddenMoveTalentFrameBack()
			self:SetNormalTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
			self:SetPushedTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Down")
			DCS_tooltipText = L['Show Character Stats'] --Creates a tooltip on mouseover.
			gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandChecked.ExpandSetChecked = false
		else
			DCS_CharacterFrame_Expand()
			self:SetNormalTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up")
			self:SetPushedTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Down")
			DCS_tooltipText = L['Hide Character Stats'] --Creates a tooltip on mouseover.
			gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandChecked.ExpandSetChecked = true
		end
		DCS_ExpandCheck_OnEnter()
		DCS_ShownMoveTalentFrame()
	end)

	PaperDollFrame:HookScript("OnShow", function(self)
		local checked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandChecked.ExpandSetChecked
		if checked == true then
			DCS_CharacterFrame_Expand()
			DCS_ShownMoveTalentFrame()
			PaperDollFrame.ExpandButton:SetNormalTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up")
			PaperDollFrame.ExpandButton:SetPushedTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Down")
			DCS_tooltipText = L['Hide Character Stats'] --Creates a tooltip on mouseover.
		else
			DCS_CharacterFrame_Collapse()
			PaperDollFrame.ExpandButton:SetNormalTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
			PaperDollFrame.ExpandButton:SetPushedTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Down")
			DCS_tooltipText = L['Show Character Stats'] --Creates a tooltip on mouseover.
		end
	end)

	-- Move Talent Frame if DCS is shown.	
	TalentMicroButton:HookScript("OnClick", function(self)
		if PaperDollFrame:IsVisible() then
			DCS_ShownMoveTalentFrame()
		end
	end)

--------------------------
-- Toggle Expand Button --
--------------------------

local DCS_ExpandButtonCheck = CreateFrame("CheckButton", "DCS_ExpandButtonCheck", DejaClassicStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ExpandButtonCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_ExpandButtonCheck:ClearAllPoints()
	DCS_ExpandButtonCheck:SetPoint("LEFT", 30, -205)
	DCS_ExpandButtonCheck:SetScale(1)
	DCS_ExpandButtonCheck.tooltipText = L['Displays the Expand button for the character stats frame.'] --Creates a tooltip on mouseover.
	_G[DCS_ExpandButtonCheck:GetName() .. "Text"]:SetText(L["Expand"])
	
	DCS_ExpandButtonCheck:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_LOGIN" then
			local checked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandButtonChecked.ExpandButtonSetChecked
			self:SetChecked(checked)
			if checked then
				PaperDollFrame.ExpandButton:Show()
			else
				PaperDollFrame.ExpandButton:Hide()
			end
		end
	end)

	DCS_ExpandButtonCheck:SetScript("OnClick", function(self)
		local checked = self:GetChecked()
		gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandButtonChecked.ExpandButtonSetChecked = checked
		if checked then
			PaperDollFrame.ExpandButton:Show()
		else
			PaperDollFrame.ExpandButton:Hide()
		end
	end)

----------------------------------------------
-- Toggle Expand Button Alternate Placement --
----------------------------------------------

local DCS_ExpandButtonAltPlacementCheck = CreateFrame("CheckButton", "DCS_ExpandButtonAltPlacementCheck", DejaClassicStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ExpandButtonAltPlacementCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_ExpandButtonAltPlacementCheck:ClearAllPoints()
	DCS_ExpandButtonAltPlacementCheck:SetPoint("LEFT", 30, -185)
	DCS_ExpandButtonAltPlacementCheck:SetScale(1)
	DCS_ExpandButtonAltPlacementCheck.tooltipText = L["Moves the Expand button for the character stats frame above the gloves' item slot."] --Creates a tooltip on mouseover.
	_G[DCS_ExpandButtonAltPlacementCheck:GetName() .. "Text"]:SetText(L["Expand Alternate Placement"])
	
	DCS_ExpandButtonAltPlacementCheck:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_LOGIN" then
			local checked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandButtonAltPlacementChecked.ExpandButtonAltPlacementSetChecked
			self:SetChecked(checked)
			if checked then
				PaperDollFrame.ExpandButton:SetPoint("BOTTOMRIGHT", CharacterHandsSlot, "TOPRIGHT", 2, -3)
			else
				PaperDollFrame.ExpandButton:SetPoint("TOPRIGHT", CharacterTrinket1Slot, "BOTTOMRIGHT", 2, -3)
			end
		end
	end)

	DCS_ExpandButtonAltPlacementCheck:SetScript("OnClick", function(self)
		local checked = self:GetChecked()
		gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandButtonAltPlacementChecked.ExpandButtonAltPlacementSetChecked = checked
		if checked then
			PaperDollFrame.ExpandButton:ClearAllPoints()
			PaperDollFrame.ExpandButton:SetPoint("BOTTOMRIGHT", CharacterHandsSlot, "TOPRIGHT", 2, 3)
		else
			PaperDollFrame.ExpandButton:ClearAllPoints()
			PaperDollFrame.ExpandButton:SetPoint("TOPRIGHT", CharacterTrinket1Slot, "BOTTOMRIGHT", 2, -3)
		end
	end)