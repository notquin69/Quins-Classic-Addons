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
local PaperDollpoint, PaperDollrelativeTo, PaperDollrelativePoint, PaperDollxOffset, PaperDollyOffset = 0,0,0,0,0

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

	PaperDollFrame.ExpandButton = CreateFrame("Button", nil, PaperDollFrame)
	PaperDollFrame.ExpandButton:SetSize(32, 32)
	PaperDollFrame.ExpandButton:SetHighlightTexture("Interface\\BUTTONS\\UI-Common-MouseHilight")
	
	PaperDollFrame.ExpandButton:SetScript("OnEnter", DCS_ExpandCheck_OnEnter)
	PaperDollFrame.ExpandButton:SetScript("OnLeave", DCS_ExpandCheck_OnLeave)
			 
	PaperDollFrame.ExpandButton:SetScript("OnMouseUp", function (self)
		local checked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandChecked.ExpandSetChecked
		if checked == true then
			DCS_CharacterFrame_Collapse()
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
	end)

	PaperDollFrame:HookScript("OnShow", function(self)
		local checked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandChecked.ExpandSetChecked
		if checked == true then
			if TradeSkillFrame:IsVisible() or CraftFrame:IsVisible() or TalentFrame:IsVisible() then
				DCS_CharacterFrame_Collapse()	
			else
				DCS_CharacterFrame_Expand()
			end
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
--------------------------
-- Toggle Expand Button --
--------------------------

local DCS_ExpandButtonCheck = CreateFrame("CheckButton", "DCS_ExpandButtonCheck", DejaClassicStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ExpandButtonCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_ExpandButtonCheck:ClearAllPoints()
	DCS_ExpandButtonCheck:SetPoint("TOPLEFT", "dcsMiscPanelCategoryFS", 7, -55)
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
	DCS_ExpandButtonAltPlacementCheck:SetPoint("TOPLEFT", "dcsMiscPanelCategoryFS", 7, -75)
	DCS_ExpandButtonAltPlacementCheck:SetScale(1)
	DCS_ExpandButtonAltPlacementCheck.tooltipText = L["Displays the Expand button above the hands item slot."] --Creates a tooltip on mouseover.
	_G[DCS_ExpandButtonAltPlacementCheck:GetName() .. "Text"]:SetText(L["Alternate Expand"])
	
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


DCS_BLIZZ_SKILL_PANELS = {
	"TradeSkill",
	"Craft",
	"Talent",
}

local DejaClassicStatsExpandEventFrame = CreateFrame("Frame", "DejaClassicStatsExpandEventFrame", UIParent)
	-- DejaClassicStatsExpandEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	DejaClassicStatsExpandEventFrame:RegisterEvent("ADDON_LOADED")

	DejaClassicStatsExpandEventFrame:SetScript("OnEvent", function(self, event, arg1)
		if event == "ADDON_LOADED" and arg1 == "DejaClassicStats" then
			self:UnregisterEvent("ADDON_LOADED")
			for k, v in ipairs(DCS_BLIZZ_SKILL_PANELS) do
				if _G[v.."Frame"] == nil then
					LoadAddOn("Blizzard_"..v.."UI")
					_G[v.."Frame"]:HookScript("OnShow", function(self)
						if PaperDollFrame:IsVisible() then
							local checked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandChecked.ExpandSetChecked
							if checked == true then
								DCS_CharacterFrame_Collapse()
							end
						end
					end)
					_G[v.."Frame"]:HookScript("OnHide", function(self)
						if TradeSkillFrame:IsVisible() or CraftFrame:IsVisible() or TalentFrame:IsVisible() then return
						else
							local checked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsExpandChecked.ExpandSetChecked
							if checked == true then
								DCS_CharacterFrame_Expand()
							end
						end
					end)
				end
			end
			
		end
	end)