local ADDON_NAME, namespace = ... 	--localization
local L = namespace.L 				--localization
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local addoninfo = 'v'..version
--------------------------
-- SavedVariables Setup --
--------------------------
local _, addon = ...
local DejaClassicStats, gdbprivate = ...

gdbprivate.gdbdefaults = {
}
gdbprivate.gdbdefaults.gdbdefaults = {
}

----------------------------
-- Saved Variables Loader --
----------------------------
local loader = CreateFrame("Frame")
	loader:RegisterEvent("ADDON_LOADED")
	loader:SetScript("OnEvent", function(self, event, arg1)
		if event == "ADDON_LOADED" and arg1 == "DejaClassicStats" then
			local function initDB(gdb, gdbdefaults)
				if type(gdb) ~= "table" then gdb = {} end
				if type(gdbdefaults) ~= "table" then return gdb end
				for k, v in pairs(gdbdefaults) do
					if type(v) == "table" then
						gdb[k] = initDB(gdb[k], v)
					elseif type(v) ~= type(gdb[k]) then
						gdb[k] = v
					end
				end
				return gdb
			end

			DejaClassicStatsDBPC = initDB(DejaClassicStatsDBPC, gdbprivate.gdbdefaults) --the first per account saved variable. The second per-account variable DCS_ClassSpecDB is handled in DCS_Layouts.lua
			gdbprivate.gdb = DejaClassicStatsDBPC --fast access for checkbox states
			self:UnregisterEvent("ADDON_LOADED")
		end
	end)

local DejaClassicStats, private = ...

private.defaults = {
}
private.defaults.dcsdefaults = {
}

DejaClassicStats = {}

----------------------------
-- Saved Variables Loader --
----------------------------
local loader = CreateFrame("Frame")
	loader:RegisterEvent("ADDON_LOADED")
	loader:SetScript("OnEvent", function(self, event, arg1)
		if event == "ADDON_LOADED" and arg1 == "DejaClassicStats" then
			local function initDB(db, defaults)
				if type(db) ~= "table" then db = {} end
				if type(defaults) ~= "table" then return db end
				for k, v in pairs(defaults) do
					if type(v) == "table" then
						db[k] = initDB(db[k], v)
					elseif type(v) ~= type(db[k]) then
						db[k] = v
					end
				end
				return db
			end

			DejaClassicStatsDBPCPC = initDB(DejaClassicStatsDBPCPC, private.defaults) --saved variable per character, currently not used.
			private.db = DejaClassicStatsDBPCPC

			self:UnregisterEvent("ADDON_LOADED")
		end
	end)

-- Uncomment below the following three database saved variables setup lines for DejaView integration.
-- SavedVariables Setup
-- local DejaClassicStats, private = ...
-- private.defaults = {}
-- DejaClassicStats = {}

---------------------
-- DCS Slash Setup --
---------------------
local RegisteredEvents = {}
local dcsslash = CreateFrame("Frame", "DejaClassicStatsSlash", UIParent)

dcsslash:SetScript("OnEvent", function (self, event, ...) 
	if (RegisteredEvents[event]) then 
	return RegisteredEvents[event](self, event, ...) 
	end
end)

function RegisteredEvents:ADDON_LOADED(event, addon, ...)
	if (addon == "DejaClassicStats") then
		--SLASH_DejaClassicStats1 = (L["/dcstats"])
		SLASH_DejaClassicStats1 = "/dcstats"
		SlashCmdList["DejaClassicStats"] = function (msg, editbox)
			DejaClassicStats.SlashCmdHandler(msg, editbox)	
	end
	--	DEFAULT_CHAT_FRAME:AddMessage("DejaClassicStats loaded successfully. For options: Esc>Interface>AddOns or type /dcstats.",0,192,255)
	end
end

for k, v in pairs(RegisteredEvents) do
	dcsslash:RegisterEvent(k)
end

function DejaClassicStats.ShowHelp()
	print(addoninfo)
	print(L["DejaClassicStats Slash commands (/dcstats):"])
	print(L["  /dcstats config: Opens the DejaClassicStats addon config menu."])
	print(L["  /dcstats reset:  Resets DejaClassicStats options to default."])
end

function DejaClassicStats.SlashCmdHandler(msg, editbox)
    msg = string.lower(msg)
	--print("command is " .. msg .. "\n")
	--if (string.lower(msg) == L["config"]) then --I think string.lowermight not work for Russian letters
	if (msg == "config") then
		InterfaceOptionsFrame_OpenToCategory("DejaClassicStats")
		InterfaceOptionsFrame_OpenToCategory("DejaClassicStats")
		InterfaceOptionsFrame_OpenToCategory("DejaClassicStats")
	elseif (msg == "reset") then
		--DejaClassicStatsDBPCPC = private.defaults
		gdbprivate.gdb.gdbdefaults = gdbprivate.gdbdefaults.gdbdefaults
		ReloadUI()
	else
		DejaClassicStats.ShowHelp()
	end
end
	SlashCmdList["DejaClassicStats"] = DejaClassicStats.SlashCmdHandler

-----------------------
-- DCS Options Panel --
-----------------------
DejaClassicStats.panel = CreateFrame( "Frame", "DejaClassicStatsPanel", UIParent )
DejaClassicStats.panel.name = "DejaClassicStats"
InterfaceOptions_AddCategory(DejaClassicStats.panel)

-- DCS, DejaView Child Panel
-- DejaViewPanel.DejaClassicStatsPanel = CreateFrame( "Frame", "DejaClassicStatsPanel", DejaViewPanel)
-- DejaViewPanel.DejaClassicStatsPanel.name = "DejaClassicStats"
-- Specify childness of this panel (this puts it under the little red [+], instead of giving it a normal AddOn category)
-- DejaViewPanel.DejaClassicStatsPanel.parent = DejaViewPanel.name
-- Add the child to the Interface Options
-- InterfaceOptions_AddCategory(DejaViewPanel.DejaClassicStatsPanel)

local dcstitle=CreateFrame("Frame", "DCSTitle", DejaClassicStatsPanel)
	dcstitle:SetPoint("TOPLEFT", 10, -10)
	--dcstitle:SetScale(2.0)
	dcstitle:SetWidth(300)
	dcstitle:SetHeight(100)
	dcstitle:Show()

local dcstitleFS = dcstitle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	dcstitleFS:SetText('|cff00c0ffDejaClassicStats|r')
	dcstitleFS:SetPoint("TOPLEFT", 0, 0)
	dcstitleFS:SetFont("Fonts\\FRIZQT__.TTF", 20)

local dcsversionFS = DejaClassicStatsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	dcsversionFS:SetText('|cff00c0ff' .. addoninfo .. '|r')
	dcsversionFS:SetPoint("BOTTOMRIGHT", -10, 10)
	dcsversionFS:SetFont("Fonts\\FRIZQT__.TTF", 12)
	
local dcsresetcheck = CreateFrame("Button", "DCSResetButton", DejaClassicStatsPanel, "UIPanelButtonTemplate")
	dcsresetcheck:ClearAllPoints()
	dcsresetcheck:SetPoint("BOTTOMLEFT", 5, 5)
	dcsresetcheck:SetScale(1.25)

	--local LOCALE = GetLocale()
	local LOCALE = namespace.locale
		--print (LOCALE)
	local altWidth = {
		["ptBR"] = {},
		["frFR"] = {},
		["deDE"] = {},
		["ruRU"] = {},
	}
	local altWidth2 = {
		["esES"] = {},
	}

	if altWidth[LOCALE] then
		LOCALE = 175
	elseif altWidth2[LOCALE] then
		LOCALE = 200
	else
		--print ("enUS = 125")
		LOCALE = 125
	end
	dcsresetcheck:SetWidth(LOCALE)

	dcsresetcheck:SetHeight(30)
	_G[dcsresetcheck:GetName() .. "Text"]:SetText(L["Reset to Default"])
	dcsresetcheck:SetScript("OnClick", function(self, button, down)
 		gdbprivate.gdb.gdbdefaults = gdbprivate.gdbdefaults.gdbdefaults
		ReloadUI()
	end)
		
	----------------------
	-- Panel Categories --
	----------------------
	
	-- --Average Item Level
	-- local dcsILvlPanelCategoryFS = DejaClassicStatsPanel:CreateFontString("dcsILvlPanelCategoryFS", "OVERLAY", "GameFontNormal")
	-- dcsILvlPanelCategoryFS:SetText('|cffffffff' .. L["Average Item Level:"] .. '|r') --wouldn't be more efficient through format?
	-- dcsILvlPanelCategoryFS:SetPoint("TOPLEFT", 25, -40)
	-- dcsILvlPanelCategoryFS:SetFontObject("GameFontNormalLarge") --Use instead of SetFont("Fonts\\FRIZQT__.TTF", 15) or Russian, Korean and Chinese characters won't work.
	
	-- --Character Stats 
	-- local dcsStatsPanelcategoryFS = DejaClassicStatsPanel:CreateFontString("dcsStatsPanelcategoryFS", "OVERLAY", "GameFontNormal")
	-- dcsStatsPanelcategoryFS:SetText('|cffffffff' .. L["Character Stats:"] .. '|r')
	-- dcsStatsPanelcategoryFS:SetPoint("TOPLEFT", 25, -150)
	-- dcsStatsPanelcategoryFS:SetFontObject("GameFontNormalLarge") --Use instead of SetFont("Fonts\\FRIZQT__.TTF", 15) or Russian, Korean and Chinese characters won't work.
	
	--Item Slots
	local dcsItemsPanelCategoryFS = DejaClassicStatsPanel:CreateFontString("dcsItemsPanelCategoryFS", "OVERLAY", "GameFontNormal")
	dcsItemsPanelCategoryFS:SetText('|cffffffff' .. L["Item Slots:"] .. '|r')
	dcsItemsPanelCategoryFS:SetPoint("TOPLEFT", 25, -40)
	dcsItemsPanelCategoryFS:SetFontObject("GameFontNormalLarge") --Use instead of SetFont("Fonts\\FRIZQT__.TTF", 15) or Russian, Korean and Chinese characters won't work.
	
	-- --Miscellaneous
	local dcsMiscPanelCategoryFS = DejaClassicStatsPanel:CreateFontString("dcsMiscPanelCategoryFS", "OVERLAY", "GameFontNormal")
	dcsMiscPanelCategoryFS:SetText('|cffffffff' .. L["Miscellaneous:"] .. '|r')
	dcsMiscPanelCategoryFS:SetPoint("LEFT", 25, -125)
	dcsMiscPanelCategoryFS:SetFontObject("GameFontNormalLarge") --Use instead of SetFont("Fonts\\FRIZQT__.TTF", 15) or Russian, Korean and Chinese characters won't work.
	
-------------------
-- Frame Offsets --
-------------------
local DCS_FrameWidth, DCS_FrameHeight = 192, 424
local DCS_HeaderWidth, DCS_HeaderHeight = 192, 28
local DCS_RframeInset = 25
local DCS_HeaderInsetX = 0
local DCS_StatScale = 1.25

------------------
-- Scroll Frame --
------------------
local scrollbarchecked

gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsScrollbarChecked = {
	ScrollbarSetChecked = false,
}

local DCS_StatScrollFrame = CreateFrame("ScrollFrame", "DCS_StatScrollFrame", CharacterFrame, "UIPanelScrollFrameTemplate")
	DCS_StatScrollFrame:ClearAllPoints()
	DCS_StatScrollFrame:SetSize( DCS_HeaderWidth, 400 )
	DCS_StatScrollFrame:SetPoint("TOPLEFT", "CharacterFrame", "TOPRIGHT", -34, -26) -- This is (-40, -14) for Classic, different for dry development
	DCS_StatScrollFrame:SetFrameStrata("BACKGROUND")
	DCS_StatScrollFrame.ScrollBar:ClearAllPoints()
	DCS_StatScrollFrame.ScrollBar:SetPoint("TOPLEFT", DCS_StatScrollFrame, "TOPRIGHT", 0, -16)
	DCS_StatScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", DCS_StatScrollFrame, "BOTTOMRIGHT", 0, 16)
	-- DCS_StatScrollFrame.ScrollBar:Hide() -- This will not hide the ScrollBar if the "OnScrollRangeChanged" script has a SetShown and is not hidden. 
	
	local t=DCS_StatScrollFrame:CreateTexture(nil,"ARTWORK")
	t:SetAllPoints(DCS_StatScrollFrame)
	t:SetColorTexture(0, 0, 0, 1)

	local DCS_TopTexture=DCS_StatScrollFrame:CreateTexture(nil,"ARTWORK")
	local DCS_TopRightTexture=DCS_StatScrollFrame:CreateTexture(nil,"ARTWORK")
	local DCS_LeftTexture=DCS_StatScrollFrame:CreateTexture(nil,"ARTWORK")
	local DCS_RightTexture=DCS_StatScrollFrame:CreateTexture(nil,"ARTWORK")
	local DCS_BottomRightTexture=DCS_StatScrollFrame:CreateTexture(nil,"ARTWORK")
	local DCS_BottomTexture=DCS_StatScrollFrame:CreateTexture(nil,"ARTWORK")

local scrollFrameTextureXinsets

local function DCS_SetScrollTextures()
	if scrollbarchecked then
		scrollFrameTextureXinsets = 60
		-- DCS_StatScrollFrame.ScrollBar:SetShown(floor(yrange) ~= 0)
		DCS_StatScrollFrame.ScrollBar:Show()
	else
		scrollFrameTextureXinsets = 44
		DCS_StatScrollFrame.ScrollBar:Hide()
	end

	DCS_TopTexture:SetPoint("TOPLEFT", DCS_StatScrollFrame, "TOPLEFT", -4, 86)
	DCS_TopTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight")
	DCS_TopTexture:SetTexCoord(0.69, 0, 1, 0)

	DCS_TopRightTexture:SetPoint("TOPRIGHT", DCS_StatScrollFrame, "TOPRIGHT", scrollFrameTextureXinsets, 86)
	DCS_TopRightTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight")
	DCS_TopRightTexture:SetTexCoord(0, 1, 1, 0)

	DCS_LeftTexture:SetPoint("LEFT", DCS_StatScrollFrame, "LEFT", 0, -20)
	DCS_LeftTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight")
	DCS_LeftTexture:SetTexCoord(0, 0.6, 0.6, 0)

	DCS_RightTexture:SetPoint("RIGHT", DCS_StatScrollFrame, "RIGHT", scrollFrameTextureXinsets, 0)
	DCS_RightTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight")
	DCS_RightTexture:SetTexCoord(0, 1, 0.6, 0)

	DCS_BottomRightTexture:SetPoint("BOTTOMRIGHT", DCS_StatScrollFrame, "BOTTOMRIGHT", scrollFrameTextureXinsets, -86)
	DCS_BottomRightTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight")

	DCS_BottomTexture:SetPoint("BOTTOMLEFT", DCS_StatScrollFrame, "BOTTOMLEFT", -4, -86)
	DCS_BottomTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight")
	DCS_BottomTexture:SetTexCoord(0.69, 0, 0, 1)
end

	local t=DCS_StatScrollFrame.ScrollBar:CreateTexture(nil,"ARTWORK")
		t:SetAllPoints(DCS_StatScrollFrame.ScrollBar)
		t:SetColorTexture(0, 0, 0, 1)

	DCS_StatScrollFrame:HookScript("OnScrollRangeChanged", function(self, xrange, yrange)
		self.ScrollBar:SetShown(floor(yrange) ~= 0)
		-- self.ScrollBar:Hide() -- This is what will hide the ScrollBar
		if scrollbarchecked then
			self.ScrollBar:SetShown(floor(yrange) ~= 0)
			self.ScrollBar:Show()
		else
			self.ScrollBar:Hide()
		end
	end)

local DejaClassicStatsPane = CreateFrame("Frame", "DejaClassicStatsPane", CharacterFrame)
	DejaClassicStatsPane:RegisterEvent("PLAYER_LOGIN")

	DejaClassicStatsPane:SetScript("OnEvent", function(self, event, ...)
		DejaClassicStatsPane:SetSize( DCS_FrameWidth, 650 )
		DejaClassicStatsPane:ClearAllPoints()
		DejaClassicStatsPane:SetAllPoints("DCS_StatScrollFrame") -- This is (-40, -14) for Classic, different for dry development
		-- DejaClassicStatsPane:SetFrameStrata("BACKGROUND")
		DejaClassicStatsPane:Show()

		DCS_StatScrollFrame:SetScrollChild(DejaClassicStatsPane)
	end)

----------------------------
-- Scrollbar Check Button --
----------------------------
local HideScrollBar

local DCS_ScrollbarCheck = CreateFrame("CheckButton", "DCS_ScrollbarCheck", DejaClassicStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ScrollbarCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_ScrollbarCheck:ClearAllPoints()
	--DCS_ScrollbarCheck:SetPoint("LEFT", 30, -225)
	DCS_ScrollbarCheck:SetPoint("TOPLEFT", "dcsMiscPanelCategoryFS", 7, -95)
	DCS_ScrollbarCheck:SetScale(1)
	DCS_ScrollbarCheck.tooltipText = L["Displays the DCS scrollbar."] --Creates a tooltip on mouseover.
	_G[DCS_ScrollbarCheck:GetName() .. "Text"]:SetText(L["Scrollbar"])
	
	DCS_ScrollbarCheck:SetScript("OnEvent", function(self, event)
		scrollbarchecked = gdbprivate.gdb.gdbdefaults.dejacharacterstatsScrollbarChecked.ScrollbarSetChecked
		self:SetChecked(scrollbarchecked)
		DCS_SetScrollTextures()	
	end)

	DCS_ScrollbarCheck:SetScript("OnClick", function(self) 
		scrollbarchecked = not scrollbarchecked
		gdbprivate.gdb.gdbdefaults.dejacharacterstatsScrollbarChecked.ScrollbarSetChecked = scrollbarchecked
		DCS_SetScrollTextures()
	end)

------------------
-- Class Colors --
------------------
local className, classFilename, classID = UnitClass("player") --Players Class Color (In case I want to use it)
local rPerc, gPerc, bPerc, argbHex = GetClassColor(classFilename)
-- print(className, classFilename,classID, rPerc, gPerc, bPerc, argbHex)

--------------------
-- Primary Header --
--------------------
local DCSPrimaryStatsHeader = CreateFrame("Frame", "DCSPrimaryStatsHeader", DejaClassicStatsPane)
	DCSPrimaryStatsHeader:SetSize( DCS_HeaderWidth, DCS_HeaderHeight )
	DCSPrimaryStatsHeader:SetPoint("TOPLEFT", "DejaClassicStatsPane", "TOPLEFT", DCS_HeaderInsetX, -10)
	-- DCSPrimaryStatsHeader:SetFrameStrata("BACKGROUND")
	-- DCSPrimaryStatsHeader:Show()

local DCSPrimaryStatsFS = DCSPrimaryStatsHeader:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	DCSPrimaryStatsFS:SetText(L["Primary"])
	DCSPrimaryStatsFS:SetTextColor(1, 1, 1)
	DCSPrimaryStatsFS:SetPoint("CENTER", 0, 0)
	-- DCSPrimaryStatsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
	DCSPrimaryStatsFS:SetJustifyH("CENTER")

local t=DCSPrimaryStatsHeader:CreateTexture(nil,"ARTWORK")
		t:SetAllPoints(DCSPrimaryStatsHeader)
		-- t:SetColorTexture(1, 1, 1, 0)
		t:SetTexture("Interface\\PaperDollInfoFrame\\PaperDollInfoPart1")
		t:SetTexCoord(0, 0.193359375, 0.69921875, 0.736328125)

-- Update our primary stats (Strength, Agility, etc.).
local function DCS_PaperDollFrame_SetPrimaryStats()
	for i=1, NUM_STATS, 1 do
		local text = _G["CharacterStatFrame"..i.."StatText"] --Classic = CharacterStatFrame  Retail = CharacterStatsPane
		local frame = _G["CharacterStatFrame"..i]
		local stat
		local effectiveStat
		local posBuff
		local negBuff
		stat, effectiveStat, posBuff, negBuff = UnitStat("player", i)

		-- Set the tooltip text
		local tooltipText = HIGHLIGHT_FONT_COLOR_CODE.._G["SPELL_STAT"..i.."_NAME"].." "
		
		-- Get class specific tooltip for that stat
		local temp, classFileName = UnitClass("player")
		local classStatText = _G[strupper(classFileName).."_"..frame.stat.."_".."TOOLTIP"]
		-- If can't find one use the default
		if ( not classStatText ) then
			classStatText = _G["DEFAULT".."_"..frame.stat.."_".."TOOLTIP"]
		end

		if ( ( posBuff == 0 ) and ( negBuff == 0 ) ) then
			text:SetText(effectiveStat)
			frame.tooltip = tooltipText..effectiveStat..FONT_COLOR_CODE_CLOSE
			frame.tooltip2 = classStatText
		else 
			tooltipText = tooltipText..effectiveStat
			if ( posBuff > 0 or negBuff < 0 ) then
				tooltipText = tooltipText.." ("..(stat - posBuff - negBuff)..FONT_COLOR_CODE_CLOSE
			end
			if ( posBuff > 0 ) then
				tooltipText = tooltipText..FONT_COLOR_CODE_CLOSE..GREEN_FONT_COLOR_CODE.."+"..posBuff..FONT_COLOR_CODE_CLOSE
			end
			if ( negBuff < 0 ) then
				tooltipText = tooltipText..RED_FONT_COLOR_CODE.." "..negBuff..FONT_COLOR_CODE_CLOSE
			end
			if ( posBuff > 0 or negBuff < 0 ) then
				tooltipText = tooltipText..HIGHLIGHT_FONT_COLOR_CODE..")"..FONT_COLOR_CODE_CLOSE
			end
			frame.tooltip = tooltipText
			frame.tooltip2= classStatText
			
			-- If there are any negative buffs then show the main number in red even if there are
			-- positive buffs. Otherwise show in green.
			if ( negBuff < 0 ) then
				text:SetText(RED_FONT_COLOR_CODE..effectiveStat..FONT_COLOR_CODE_CLOSE)
			else
				text:SetText(GREEN_FONT_COLOR_CODE..effectiveStat..FONT_COLOR_CODE_CLOSE)
			end
		end
		
		frame:SetParent(DejaClassicStatsPane)
		frame:SetScale(DCS_StatScale)
		frame:SetWidth( (DCS_FrameWidth / DCS_StatScale) - DCS_RframeInset)
		if (i==1) then
			frame:SetPoint("TOPLEFT", DCSPrimaryStatsHeader, "BOTTOMLEFT", 12,0)--Not TOP and BOTTOM becasue of a parenting issue that centers it over the Characterframe...
		else
			frame:SetPoint("TOP", _G["CharacterStatFrame"..(i-1)], "BOTTOM", 0,0)
		end
		--print(tooltipText)
	end
end

local function DCS_PaperDollFrame_SetArmor(unit, prefix)
	if ( not unit ) then
		unit = "player"
	end
	if ( not prefix ) then
		prefix = "Character"
	end

	local base, effectiveArmor, armor, posBuff, negBuff = UnitArmor(unit)

	if (unit ~= "player") then
		--[[ In 1.12.0, UnitArmor didn't report positive / negative buffs for units that weren't the active player.
			 This hack replicates that behavior for the UI. ]]
		base = effectiveArmor
		armor = effectiveArmor
		posBuff = 0
		negBuff = 0
	end

	local totalBufs = posBuff + negBuff

	local frame = _G[prefix.."ArmorFrame"]
	local text = _G[prefix.."ArmorFrameStatText"]

	PaperDollFormatStat(ARMOR, base, posBuff, negBuff, frame, text)
	local playerLevel = UnitLevel(unit)
	local armorReduction = effectiveArmor/((85 * playerLevel) + 400)
	armorReduction = 100 * (armorReduction/(armorReduction + 1))
	
	frame.tooltip2 = format(ARMOR_TOOLTIP, playerLevel, armorReduction)
	
	frame:SetParent(DejaClassicStatsPane)
	frame:SetScale(DCS_StatScale)
	frame:SetWidth( (DCS_FrameWidth / DCS_StatScale) - DCS_RframeInset)
	frame:SetPoint("TOP", CharacterStatFrame5, "BOTTOM", 0,0)
	--print("Armor", effectiveArmor)
end

-----------
--Offense--
-----------
local DCSOffenseStatsHeader = CreateFrame("Frame", "DCSOffenseStatsHeader", DejaClassicStatsPane)
	DCSOffenseStatsHeader:SetSize( DCS_HeaderWidth, DCS_HeaderHeight )
	DCSOffenseStatsHeader:SetPoint("TOPLEFT", "DejaClassicStatsPane", "TOPLEFT", DCS_HeaderInsetX, -180)
	-- DCSOffenseStatsHeader:SetFrameStrata("BACKGROUND")
	-- DCSOffenseStatsHeader:Show()

local DCSOffenseStatsFS = DCSOffenseStatsHeader:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	DCSOffenseStatsFS:SetText(L["Offense"])
	DCSOffenseStatsFS:SetTextColor(1, 1, 1)
	DCSOffenseStatsFS:SetPoint("CENTER", 0, 0) --This is -2 to center the header "Offense" better.
	-- DCSOffenseStatsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
	DCSOffenseStatsFS:SetJustifyH("CENTER")

local t=DCSOffenseStatsHeader:CreateTexture(nil,"ARTWORK")
	t:SetAllPoints(DCSOffenseStatsHeader)
	t:SetColorTexture(1, 1, 1, 0)
	t:SetTexture("Interface\\PaperDollInfoFrame\\PaperDollInfoPart1")
	t:SetTexCoord(0, 0.193359375, 0.69921875, 0.736328125)

-- Note: while this function was historically named "BothHands",
-- it looks like it only ever displayed attack rating for the main hand.
local function DCS_PaperDollFrame_SetAttackBothHands(unit, prefix)
	if ( not unit ) then
		unit = "player"
	end
	if ( not prefix ) then
		prefix = "Character"
	end

	local mainHandAttackBase, mainHandAttackMod = UnitAttackBothHands(unit)

	local frame = _G[prefix.."AttackFrame"]
	local text = _G[prefix.."AttackFrameStatText"]

	if( mainHandAttackMod == 0 ) then
		text:SetText(mainHandAttackBase)
	else
		local color = RED_FONT_COLOR_CODE
		if( mainHandAttackMod > 0 ) then
			color = GREEN_FONT_COLOR_CODE
		end
		text:SetText(color..(mainHandAttackBase + mainHandAttackMod)..FONT_COLOR_CODE_CLOSE)
	end

	frame.tooltip = ATTACK_TOOLTIP
	frame.tooltip2 = ATTACK_TOOLTIP_SUBTEXT
	
	frame:SetParent(DejaClassicStatsPane)
	frame:SetScale(DCS_StatScale)
	frame:SetWidth( (DCS_FrameWidth / DCS_StatScale) - DCS_RframeInset)
	frame:SetPoint("TOPLEFT", DCSOffenseStatsHeader, "BOTTOMLEFT", 12,0)--Not TOP and BOTTOM becasue of a parenting issue that centers it over the Characterframe...
	--print(frame.tooltip)
end

local function DCS_PaperDollFrame_SetAttackPower(unit, prefix)
	if ( not unit ) then
		unit = "player"
	end
	if ( not prefix ) then
		prefix = "Character"
	end
	
	local base, posBuff, negBuff = UnitAttackPower(unit)

	local frame = _G[prefix.."AttackPowerFrame"] 
	local text = _G[prefix.."AttackPowerFrameStatText"]

	PaperDollFormatStat(MELEE_ATTACK_POWER, base, posBuff, negBuff, frame, text)
	frame.tooltip2 = format(MELEE_ATTACK_POWER_TOOLTIP, max((base+posBuff+negBuff), 0)/ATTACK_POWER_MAGIC_NUMBER)
	
	frame:SetParent(DejaClassicStatsPane)
	frame:SetScale(DCS_StatScale)
	frame:SetWidth( ( (DCS_FrameWidth / DCS_StatScale) - DCS_RframeInset) -10) --Inset 10 becasue it is a substat
	frame:SetPoint("TOPLEFT", CharacterAttackFrame, "BOTTOMLEFT", 10,0)--Inset 10 as it is a sub stat
	--print(frame.tooltip)
end

local function DCS_PaperDollFrame_SetDamage(unit, prefix)
	if ( not unit ) then
		unit = "player"
	end
	if ( not prefix ) then
		prefix = "Character"
	end

	local damageText = _G[prefix.."DamageFrameStatText"]
	local damageFrame = _G[prefix.."DamageFrame"]

	local speed, offhandSpeed = UnitAttackSpeed(unit)
	
	local minDamage
	local maxDamage 
	local minOffHandDamage
	local maxOffHandDamage 
	local physicalBonusPos
	local physicalBonusNeg
	local percent
	minDamage, maxDamage, minOffHandDamage, maxOffHandDamage, physicalBonusPos, physicalBonusNeg, percent = UnitDamage(unit)
	local displayMin = max(floor(minDamage),1)
	local displayMax = max(ceil(maxDamage),1)

	minDamage = (minDamage / percent) - physicalBonusPos - physicalBonusNeg
	maxDamage = (maxDamage / percent) - physicalBonusPos - physicalBonusNeg

	local baseDamage = (minDamage + maxDamage) * 0.5
	local fullDamage = (baseDamage + physicalBonusPos + physicalBonusNeg) * percent
	local totalBonus = (fullDamage - baseDamage)
	local damagePerSecond = (max(fullDamage,1) / speed)
	local damageTooltip = max(floor(minDamage),1).." - "..max(ceil(maxDamage),1)
	
	local colorPos = "|cff20ff20"
	local colorNeg = "|cffff2020"
	if ( totalBonus == 0 ) then
		if ( ( displayMin < 100 ) and ( displayMax < 100 ) ) then 
			damageText:SetText(displayMin.." - "..displayMax)	
		else
			damageText:SetText(displayMin.."-"..displayMax)
		end
	else
		
		local color
		if ( totalBonus > 0 ) then
			color = colorPos
		else
			color = colorNeg
		end
		if ( ( displayMin < 100 ) and ( displayMax < 100 ) ) then 
			damageText:SetText(color..displayMin.." - "..displayMax.."|r")	
		else
			damageText:SetText(color..displayMin.."-"..displayMax.."|r")
		end
		if ( physicalBonusPos > 0 ) then
			damageTooltip = damageTooltip..colorPos.." +"..physicalBonusPos.."|r"
		end
		if ( physicalBonusNeg < 0 ) then
			damageTooltip = damageTooltip..colorNeg.." "..physicalBonusNeg.."|r"
		end
		if ( percent > 1 ) then
			damageTooltip = damageTooltip..colorPos.." x"..floor(percent*100+0.5).."%|r"
		elseif ( percent < 1 ) then
			damageTooltip = damageTooltip..colorNeg.." x"..floor(percent*100+0.5).."%|r"
		end
		
	end
	damageFrame.damage = damageTooltip
	damageFrame.attackSpeed = speed
	damageFrame.dps = damagePerSecond
	
	-- If there's an offhand speed then add the offhand info to the tooltip
	if ( offhandSpeed ) then
		minOffHandDamage = (minOffHandDamage / percent) - physicalBonusPos - physicalBonusNeg
		maxOffHandDamage = (maxOffHandDamage / percent) - physicalBonusPos - physicalBonusNeg

		local offhandBaseDamage = (minOffHandDamage + maxOffHandDamage) * 0.5
		local offhandFullDamage = (offhandBaseDamage + physicalBonusPos + physicalBonusNeg) * percent
		local offhandDamagePerSecond = (max(offhandFullDamage,1) / offhandSpeed)
		local offhandDamageTooltip = max(floor(minOffHandDamage),1).." - "..max(ceil(maxOffHandDamage),1)
		if ( physicalBonusPos > 0 ) then
			offhandDamageTooltip = offhandDamageTooltip..colorPos.." +"..physicalBonusPos.."|r"
		end
		if ( physicalBonusNeg < 0 ) then
			offhandDamageTooltip = offhandDamageTooltip..colorNeg.." "..physicalBonusNeg.."|r"
		end
		if ( percent > 1 ) then
			offhandDamageTooltip = offhandDamageTooltip..colorPos.." x"..floor(percent*100+0.5).."%|r"
		elseif ( percent < 1 ) then
			offhandDamageTooltip = offhandDamageTooltip..colorNeg.." x"..floor(percent*100+0.5).."%|r"
		end
		damageFrame.offhandDamage = offhandDamageTooltip
		damageFrame.offhandAttackSpeed = offhandSpeed
		damageFrame.offhandDps = offhandDamagePerSecond
	else
		damageFrame.offhandAttackSpeed = nil
	end
	
	damageFrame:SetParent(DejaClassicStatsPane)
	damageFrame:SetScale(DCS_StatScale)
	damageFrame:SetWidth( ( (DCS_FrameWidth / DCS_StatScale) - DCS_RframeInset) -10) --Inset 10 becasue it is a substat
	damageFrame:SetPoint("TOPLEFT", CharacterAttackPowerFrame, "BOTTOMLEFT", 0,0)
	--print(damageFrame.offhandAttackSpeed)
end

local function DCS_PaperDollFrame_SetRangedAttack(unit, prefix)
	if ( not unit ) then
		unit = "player"
	elseif ( unit == "pet" ) then
		return
	end
	if ( not prefix ) then
		prefix = "Character"
	end

	local hasRelic = UnitHasRelicSlot(unit)

	local rangedAttackBase, rangedAttackMod = UnitRangedAttack(unit)
	local frame = _G[prefix.."RangedAttackFrame"] 
	local text = _G[prefix.."RangedAttackFrameStatText"]

	-- If no ranged texture then set stats to n/a
	local rangedTexture = GetInventoryItemTexture("player", 18)
	local oldValue = PaperDollFrame.noRanged
	if ( rangedTexture and not hasRelic ) then
		PaperDollFrame.noRanged = nil
	else
		text:SetText(NOT_APPLICABLE)
		PaperDollFrame.noRanged = 1
		frame.tooltip = nil
	end
	if ( not rangedTexture or hasRelic ) then
		return
	end
	
	if( rangedAttackMod == 0 ) then
		text:SetText(rangedAttackBase)
	else
		local color = RED_FONT_COLOR_CODE
		if( rangedAttackMod > 0 ) then
			color = GREEN_FONT_COLOR_CODE
		end
		text:SetText(color..(rangedAttackBase + rangedAttackMod)..FONT_COLOR_CODE_CLOSE)
	end

	frame.tooltip = RANGED_ATTACK_TOOLTIP
	frame.tooltip2 = ATTACK_TOOLTIP_SUBTEXT

	frame:SetParent(DejaClassicStatsPane)
	frame:SetScale(DCS_StatScale)
	frame:SetWidth( ( (DCS_FrameWidth / DCS_StatScale) - DCS_RframeInset) ) 
	frame:SetPoint("TOPLEFT", CharacterDamageFrame, "BOTTOMLEFT", -10, 0)
	-- print(frame.tooltip)
end

local function DCS_PaperDollFrame_SetRangedAttackPower(unit, prefix)
	if ( not unit ) then
		unit = "player"
	elseif ( unit == "pet" ) then
		return
	end
	if ( not prefix ) then
		prefix = "Character"
	end
	local frame = getglobal(prefix.."RangedAttackPowerFrame") 
	local text = getglobal(prefix.."RangedAttackPowerFrameStatText")
	
	-- If no ranged attack then set to n/a
	if ( PaperDollFrame.noRanged ) then
		text:SetText(NOT_APPLICABLE)
		frame.tooltip = nil
		return
	end
	if ( HasWandEquipped() ) then
		text:SetText("--")
		frame.tooltip = nil
		return
	end

	local base, posBuff, negBuff = UnitRangedAttackPower(unit)
	PaperDollFormatStat(RANGED_ATTACK_POWER, base, posBuff, negBuff, frame, text)
	frame.tooltip2 = format(RANGED_ATTACK_POWER_TOOLTIP, base/ATTACK_POWER_MAGIC_NUMBER)

	frame:SetParent(DejaClassicStatsPane)
	frame:SetScale(DCS_StatScale)
	frame:SetWidth( ( (DCS_FrameWidth / DCS_StatScale) - DCS_RframeInset) -10) --Inset 10 becasue it is a substat
	frame:SetPoint("TOPLEFT", CharacterRangedAttackFrame, "BOTTOMLEFT", 10, 0)--Inset 10 as it is a sub stat
	-- print(frame.tooltip)
end

local function DCS_PaperDollFrame_SetRangedDamage(unit, prefix)
	if ( not unit ) then
		unit = "player"
	elseif ( unit == "pet" ) then
		return
	end
	if ( not prefix ) then
		prefix = "Character"
	end

	local damageText = getglobal(prefix.."RangedDamageFrameStatText")
	local damageFrame = getglobal(prefix.."RangedDamageFrame")

	-- If no ranged attack then set to n/a
	if ( PaperDollFrame.noRanged ) then
		damageText:SetText(NOT_APPLICABLE)
		damageFrame.damage = nil
		return
	end

	local rangedAttackSpeed, minDamage, maxDamage, physicalBonusPos, physicalBonusNeg, percent = UnitRangedDamage(unit)
	local displayMin = max(floor(minDamage),1)
	local displayMax = max(ceil(maxDamage),1)

	minDamage = (minDamage / percent) - physicalBonusPos - physicalBonusNeg
	maxDamage = (maxDamage / percent) - physicalBonusPos - physicalBonusNeg

	local baseDamage = (minDamage + maxDamage) * 0.5
	local fullDamage = (baseDamage + physicalBonusPos + physicalBonusNeg) * percent
	local totalBonus = (fullDamage - baseDamage)
	local damagePerSecond = (max(fullDamage,1) / rangedAttackSpeed)
	local tooltip = max(floor(minDamage),1).." - "..max(ceil(maxDamage),1)

	if ( totalBonus == 0 ) then
		if ( ( displayMin < 100 ) and ( displayMax < 100 ) ) then 
			damageText:SetText(displayMin.." - "..displayMax)	
		else
			damageText:SetText(displayMin.."-"..displayMax)
		end
	else
		local colorPos = "|cff20ff20"
		local colorNeg = "|cffff2020"
		local color
		if ( totalBonus > 0 ) then
			color = colorPos
		else
			color = colorNeg
		end
		if ( ( displayMin < 100 ) and ( displayMax < 100 ) ) then 
			damageText:SetText(color..displayMin.." - "..displayMax.."|r")	
		else
			damageText:SetText(color..displayMin.."-"..displayMax.."|r")
		end
		if ( physicalBonusPos > 0 ) then
			tooltip = tooltip..colorPos.." +"..physicalBonusPos.."|r"
		end
		if ( physicalBonusNeg < 0 ) then
			tooltip = tooltip..colorNeg.." "..physicalBonusNeg.."|r"
		end
		if ( percent > 1 ) then
			tooltip = tooltip..colorPos.." x"..floor(percent*100+0.5).."%|r"
		elseif ( percent < 1 ) then
			tooltip = tooltip..colorNeg.." x"..floor(percent*100+0.5).."%|r"
		end
		damageFrame.tooltip = tooltip.." "..format(DPS_TEMPLATE, damagePerSecond)
	end
	damageFrame.attackSpeed = rangedAttackSpeed
	damageFrame.damage = tooltip
	damageFrame.dps = damagePerSecond

	damageFrame:SetParent(DejaClassicStatsPane)
	damageFrame:SetScale(DCS_StatScale)
	damageFrame:SetWidth( ( (DCS_FrameWidth / DCS_StatScale) - DCS_RframeInset) -10) --Inset 10 becasue it is a substat
	damageFrame:SetPoint("TOPLEFT", CharacterRangedAttackPowerFrame, "BOTTOMLEFT", 0, 0)
	-- print(damageFrame.damage)
end

-----------
--Defense--
-----------
local DCSDefenseStatsHeader = CreateFrame("Frame", "DCSDefenseStatsHeader", DejaClassicStatsPane)
	DCSDefenseStatsHeader:SetSize( DCS_HeaderWidth, DCS_HeaderHeight )
	DCSDefenseStatsHeader:SetPoint("TOPLEFT", "DejaClassicStatsPane", "TOPLEFT", DCS_HeaderInsetX, -310)
	-- DCSDefenseStatsHeader:SetFrameStrata("BACKGROUND")
	-- DCSDefenseStatsHeader:Show()

local DCSDefenseStatsFS = DCSDefenseStatsHeader:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	DCSDefenseStatsFS:SetText(L["Defense"])
	DCSDefenseStatsFS:SetTextColor(1, 1, 1)
	DCSDefenseStatsFS:SetPoint("CENTER", 0, 0) --This is -2 to center the header "Offense" better.
	-- DCSDefenseStatsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
	DCSDefenseStatsFS:SetJustifyH("CENTER")

local t=DCSDefenseStatsHeader:CreateTexture(nil,"ARTWORK")
	t:SetAllPoints(DCSDefenseStatsHeader)
	t:SetColorTexture(1, 1, 1, 0)
	t:SetTexture("Interface\\PaperDollInfoFrame\\PaperDollInfoPart1")
	t:SetTexCoord(0, 0.193359375, 0.69921875, 0.736328125)

local function DCS_PaperDollFrame_SetResistances()
	for i=1, NUM_RESISTANCE_TYPES, 1 do
		local resistance
		local positive
		local negative
		local base
		local text = _G["MagicResText"..i]
		local frame = _G["MagicResFrame"..i]
		
		base, resistance, positive, negative = UnitResistance("player", frame:GetID())

		-- resistances can now be negative. Show Red if negative, Green if positive, white otherwise
		if( abs(negative) > positive ) then
			text:SetText(RED_FONT_COLOR_CODE..resistance..FONT_COLOR_CODE_CLOSE)
		elseif( abs(negative) == positive ) then
			text:SetText(resistance)
		else
			text:SetText(GREEN_FONT_COLOR_CODE..resistance..FONT_COLOR_CODE_CLOSE)
		end

		local resistanceName = _G["RESISTANCE"..(frame:GetID()).."_NAME"]
		frame.tooltip = resistanceName.." "..resistance
		if ( positive ~= 0 or negative ~= 0 ) then
			-- Otherwise build up the formula
			frame.tooltip = frame.tooltip.. " ( "..HIGHLIGHT_FONT_COLOR_CODE..base
			if( positive > 0 ) then
				frame.tooltip = frame.tooltip..GREEN_FONT_COLOR_CODE.." +"..positive
			end
			if( negative < 0 ) then
				frame.tooltip = frame.tooltip.." "..RED_FONT_COLOR_CODE..negative
			end
			frame.tooltip = frame.tooltip..FONT_COLOR_CODE_CLOSE.." )"
		end

		local unitLevel = UnitLevel("player")
		unitLevel = max(unitLevel, 20)
		local magicResistanceNumber = resistance/unitLevel
		if ( magicResistanceNumber > 5 ) then
			resistanceLevel = RESISTANCE_EXCELLENT
		elseif ( magicResistanceNumber > 3.75 ) then
			resistanceLevel = RESISTANCE_VERYGOOD
		elseif ( magicResistanceNumber > 2.5 ) then
			resistanceLevel = RESISTANCE_GOOD
		elseif ( magicResistanceNumber > 1.25 ) then
			resistanceLevel = RESISTANCE_FAIR
		elseif ( magicResistanceNumber > 0 ) then
			resistanceLevel = RESISTANCE_POOR
		else
			resistanceLevel = RESISTANCE_NONE
		end
		frame.tooltip2 = format(RESISTANCE_TOOLTIP_SUBTEXT, _G["RESISTANCE_TYPE"..frame:GetID()], unitLevel, resistanceLevel)

		frame:SetParent(DejaClassicStatsPane)
		-- frame:SetScale(DCS_StatScale)
		-- frame:SetWidth( (DCS_FrameWidth / DCS_StatScale) - DCS_RframeInset)
		if (i==1) then
			frame:SetPoint("TOPLEFT", DCSDefenseStatsHeader, "BOTTOMLEFT", 12, 0)--Not TOP and BOTTOM becasue of a parenting issue that centers it over the Characterframe...
		else
			frame:SetPoint("TOPLEFT", _G["MagicResFrame"..(i-1)], "TOPRIGHT", 2,0)
		end
		--print(tooltipText)
	end

end

-------------------------------
-- Melee Enhancements Header --
-------------------------------
local DCSMeleeEnhancementsStatsHeader = CreateFrame("Frame", "DCSMeleeEnhancementsStatsHeader", DejaClassicStatsPane)
	DCSMeleeEnhancementsStatsHeader:SetSize( DCS_HeaderWidth, DCS_HeaderHeight )
	DCSMeleeEnhancementsStatsHeader:SetPoint("TOPLEFT", "DejaClassicStatsPane", "TOPLEFT", DCS_HeaderInsetX, -430)
	-- DCSMeleeEnhancementsStatsHeader:SetFrameStrata("BACKGROUND")
	-- DCSMeleeEnhancementsStatsHeader:Show()

local DCSPrimaryStatsFS = DCSMeleeEnhancementsStatsHeader:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	DCSPrimaryStatsFS:SetText(L["Melee Enhancements"])
	DCSPrimaryStatsFS:SetTextColor(1, 1, 1)
	DCSPrimaryStatsFS:SetPoint("CENTER", 0, 0)
	-- DCSPrimaryStatsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
	DCSPrimaryStatsFS:SetJustifyH("CENTER")

local t=DCSMeleeEnhancementsStatsHeader:CreateTexture(nil,"ARTWORK")
		t:SetAllPoints(DCSMeleeEnhancementsStatsHeader)
		-- t:SetColorTexture(1, 1, 1, 0)
		t:SetTexture("Interface\\PaperDollInfoFrame\\PaperDollInfoPart1")
		t:SetTexCoord(0, 0.193359375, 0.69921875, 0.736328125)

-------------------------------
-- Spell Enhancements Header --
-------------------------------
local DCSSpellEnhancementsStatsHeader = CreateFrame("Frame", "DCSSpellEnhancementsStatsHeader", DejaClassicStatsPane)
	DCSSpellEnhancementsStatsHeader:SetSize( DCS_HeaderWidth, DCS_HeaderHeight )
	DCSSpellEnhancementsStatsHeader:SetPoint("TOPLEFT", "DejaClassicStatsPane", "TOPLEFT", DCS_HeaderInsetX, -520)
	-- DCSSpellEnhancementsStatsHeader:SetFrameStrata("BACKGROUND")
	-- DCSSpellEnhancementsStatsHeader:Show()

local DCSPrimaryStatsFS = DCSSpellEnhancementsStatsHeader:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	DCSPrimaryStatsFS:SetText(L["Spell Enhancements"])
	DCSPrimaryStatsFS:SetTextColor(1, 1, 1)
	DCSPrimaryStatsFS:SetPoint("CENTER", 0, 0)
	-- DCSPrimaryStatsFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
	DCSPrimaryStatsFS:SetJustifyH("CENTER")

local t=DCSSpellEnhancementsStatsHeader:CreateTexture(nil,"ARTWORK")
		t:SetAllPoints(DCSSpellEnhancementsStatsHeader)
		-- t:SetColorTexture(1, 1, 1, 0)
		t:SetTexture("Interface\\PaperDollInfoFrame\\PaperDollInfoPart1")
		t:SetTexCoord(0, 0.193359375, 0.69921875, 0.736328125)

---------------------
-- Primary/General --
---------------------		
local function DCS_Durability()
	local displayDura
	if (addon.duraMean == 100) then
		displayDura = format("%.0f%%", addon.duraMean);
	else
		displayDura = format("%.2f%%", addon.duraMean);
	end
	return displayDura, "", "", "", ""
end
local function DCS_RepairTotal()
	if (not DejaClassicStatsPane.scanTooltip) then
		DejaClassicStatsPane.scanTooltip = CreateFrame("GameTooltip", "StatRepairCostTooltip", DejaClassicStatsPane, "GameTooltipTemplate")
		DejaClassicStatsPane.scanTooltip:SetOwner(DejaClassicStatsPane, "ANCHOR_NONE")
	end
	local totalCost = 0
	local _, repairCost
	for _, index in ipairs({1,3,5,6,7,8,9,10,16,17}) do
		_, _, repairCost = DejaClassicStatsPane.scanTooltip:SetInventoryItem("player", index)
		if (repairCost and repairCost > 0) then
			totalCost = totalCost + repairCost
		end
	end
	-- totalCost = 7890 -- Debugging
	local totalRepairCost = GetCoinTextureString(totalCost)
	return totalRepairCost, "", "", "", ""
end
-- Player Movement Speed
local function MovementSpeed()
	local currentSpeed, runSpeed, flightSpeed, swimSpeed = GetUnitSpeed("player")
	local playerSpeed
	if IsSwimming() then
		playerSpeed = (swimSpeed)
	else
		playerSpeed = runSpeed
	end
    return format("%.0f%%", ((playerSpeed/7)*100)), "", "", "", ""
end
---------------------------
-- Melee/Ranged/Physical --
---------------------------
-- Melee Critical Strike Chance
local function MeleeCrit()
    return math.floor(GetCritChance()) .. "%", "", "", "", ""
end
-- Ranged Critical Strike Chance
local function RangedCrit()
    return math.floor(GetRangedCritChance()) .. "%", "", "", "", ""
end
-- Melee Plus Damage Bonus
local function MeleePlusDamage()
    return math.floor(GetSpellBonusDamage(1)), "", "", "", ""
end
-- Physical Critical Strike Chance
-- local function PhysicalicalCrit()
--     return math.floor(GetSpellCritChance(1)) .. "%", "", "", "", ""
-- end
-- Bonus Hit Chance Modifier
local function HitModifier()
	local hit = GetHitModifier()
	if hit == nil then hit = 0 end
    return math.floor(hit) .. "%", "", "", "", ""
end
-------------
-- Defense --
-------------
-- Dodge Chance
local function Dodge()
	return math.floor(GetDodgeChance()) .. "%", "", "", "", ""
end
-- Parry Chance
local function Parry()
	return math.floor(GetParryChance()) .. "%", "", "", "", ""
end
-- Block Chance
local function Block()
	return math.floor(GetBlockChance()) .. "%", "", "", "", ""
end
-- Defense
local function Defense()
	local baseDefense, armorDefense = UnitDefense("player")
	local TooltipLine1 = L["Base Defense including talents such as Warrior's Anticipation is "]..baseDefense.."."
	local TooltipLine2 = L["Bonus Defense from items and enhancements is "]..armorDefense.."."
	local TooltipLine3 = L["Total Defense is "]..(baseDefense + armorDefense)..L[". Critical Hit immunity for a level 60 player against a raid boss occurs at 440 Defense and requires a defense skill of 140 from items and enhancements to achieve."]
	local total = "("..baseDefense.." |cff00c0ff+ "..armorDefense.."|r)"
	return math.floor(baseDefense + armorDefense), TooltipLine1, TooltipLine2, TooltipLine3, total
end
------------------
-- Spellcasting --
------------------
-- Current Mana Regen
-- local function ManaRegenCurrent() --This appears to be power regen like rage, energy, runes, focus, etc.
--     return math.floor(GetPowerRegen()), "", "", "", ""
-- end
-- Mana Regen while not casting
local function ManaRegenNotCasting()
    local base, casting = GetManaRegen()
    return math.floor(base * 2), "", "", "", ""
end
-- MP5
local function MP5()
    local base, casting = GetManaRegen()
	return math.floor(casting * 2), "", "", "", ""
end
-- Spell Critical Strike Chance
local function SpellCrit()
    return math.floor(GetSpellCritChance()) .. "%", "", "", "", ""
end
-- Bonus Spell Hit Chance Modifier
local function SpellHitModifier()
	local spellhit = GetSpellHitModifier()
	if spellhit == nil then spellhit = 0 end
    return math.floor(spellhit) .. "%", "", "", "", ""
end
-- Bonus Spell Damage
local function PlusSpellDamage()
    return math.floor(GetSpellBonusHealing()), "", "", "", ""
end
-- Bonus Healing
local function PlusHealing()
    return math.floor(GetSpellBonusHealing()), "", "", "", ""
end

DCS_STAT_DATA = {
	---------------------
	-- Primary/General --
	---------------------
	MovementSpeed ={
		statName = "MovementSpeed",
		StatValue = 0,
		isShown = true,
		Label = L["Movement Speed: "],
		statFunction = MovementSpeed,
		relativeTo = DCSPrimaryStatsHeader,
	},
	DCS_Durability ={
		statName = "DCS_Durability",
		StatValue = 0,
		isShown = true,
		Label = L["Durability: "],
		statFunction = DCS_Durability,
		relativeTo = DCSPrimaryStatsHeader,
	},
	DCS_RepairTotal ={
		statName = "DCS_RepairTotal",
		StatValue = 0,
		isShown = true,
		Label = L["Repair Total: "],
		statFunction = DCS_RepairTotal,
		relativeTo = DCSPrimaryStatsHeader,
	},
	---------------------------
	-- Melee/Ranged/Physical --
	---------------------------
	MeleeCrit ={
		statName = "MeleeCrit",
		StatValue = 0,
		isShown = true,
		Label = L["Melee Crit: "],
		statFunction = MeleeCrit,
		relativeTo = DCSMeleeEnhancementsStatsHeader,
	},
	MeleeHitChance ={
		statName = "MeleeHitChance",
		StatValue = 0,
		isShown = true,
		Label = L["Melee Hit: "],
		statFunction = HitModifier,
		relativeTo = DCSMeleeEnhancementsStatsHeader,
	},
	RangedCrit = {
		statName = "RangedCrit",
		StatValue = 0,
		isShown = true,
		Label = L["Ranged Crit: "],	
		statFunction = RangedCrit,
		relativeTo = DCSMeleeEnhancementsStatsHeader,
	},
	MeleePlusDamage = {
		statName = "MeleePlusDamage",
		StatValue = 0,
		isShown = true,
		Label = L["Melee +Damage: "],	
		statFunction = MeleePlusDamage,
		relativeTo = DCSMeleeEnhancementsStatsHeader,
	},
	-- PhysicalCrit = {
	-- 	statName = "PhysicalCrit",
	-- 	StatValue = 0,
	-- 	isShown = true,
	-- 	Label = L["Physical Critical Strike: "],	
	-- 	statFunction = PhysicalicalCrit,
	-- 	relativeTo = DCSMeleeEnhancementsStatsHeader,
	-- },
	DodgeChance = {
		isShown = true,
		Label = L["Dodge: "],	
		statFunction = Dodge,
		relativeTo = DCSDefenseStatsHeader,
	},
	Defense = {
		isShown = true,
		Label = L["Defense: "],	
		statFunction = Defense,
		relativeTo = DCSDefenseStatsHeader,
		Description = "Defense, baby!",
	},
	ParryChance = {
		isShown = true,
		Label = L["Parry: "],	
		statFunction = Parry,
		relativeTo = DCSDefenseStatsHeader,
	},
	BlockChance = {
		isShown = true,
		Label = L["Block: "],	
		statFunction = Block,
		relativeTo = DCSDefenseStatsHeader,
	},
	-- ManaRegenCurrent = { --This appears to be power regen like rage, energy, runes, focus, etc.
	-- 	isShown = true,
	-- 	Label = L["Mana Regen Current: "],	
	-- 	statFunction = ManaRegenCurrent,
	-- 	relativeTo = DCSSpellEnhancementsStatsHeader,
	-- },
	ManaRegenNotCasting = {
		isShown = true,
		Label = L["Mana Regen: "],	
		statFunction = ManaRegenNotCasting,
		relativeTo = DCSSpellEnhancementsStatsHeader,
	},
	MP5 = {
		isShown = true,
		Label = L["MP5: "],	
		statFunction = MP5,
		relativeTo = DCSSpellEnhancementsStatsHeader,
	},
	SpellCritChance = {
		isShown = true,
		Label = L["Spell Crit: "],	
		statFunction = SpellCrit,
		relativeTo = DCSSpellEnhancementsStatsHeader,
	},
	SpellHitChance = {
		isShown = true,
		Label = L["Spell Hit: "],	
		statFunction = SpellHitModifier,
		relativeTo = DCSSpellEnhancementsStatsHeader,
	},
	PlusSpellDamage = {
		isShown = true,
		Label = L["Spell +Damage: "],	
		statFunction = PlusSpellDamage,
		relativeTo = DCSSpellEnhancementsStatsHeader,
	},
	PlusHealing = {
		isShown = true,
		Label = L["+Healing: "],	
		statFunction = PlusHealing,
		relativeTo = DCSSpellEnhancementsStatsHeader,
	},
}

DCS_PRIMARY_STAT_LIST = {
	-- "Health",
	-- "Mana",
	"MovementSpeed",
	"DCS_Durability",
	"DCS_RepairTotal",
	}

DCS_MELEE_STAT_LIST = {
	"MeleeHitChance",
	"MeleePlusDamage",
	"MeleeCrit",
	"RangedCrit",
	-- "PhysicalCrit",
	}

DCS_DEFENSE_STAT_LIST = {
	"DodgeChance",
	"ParryChance",
	"BlockChance",
	"Defense",
	}

DCS_SPELL_STAT_LIST = {
	-- "ManaRegenCurrent", --This appears to be power regen like rage, energy, runes, focus, etc.
	"SpellHitChance",
	"PlusSpellDamage",
	"SpellCritChance",
	"PlusHealing",
	"ManaRegenNotCasting",
	"MP5",
	}

local function DCS_CreateStatText(StatKey, StatValue, XoffSet, YoffSet)
	DejaClassicStatsPane.statFrame = CreateFrame("Frame", "DCS"..StatKey.."StatFrame", DejaClassicStatsPane)
	DejaClassicStatsPane.statFrame:SetPoint("TOPLEFT", DCS_STAT_DATA[StatKey].relativeTo, "BOTTOMLEFT", (15 + XoffSet), (-14 * (YoffSet - 1)))
	DejaClassicStatsPane.statFrame:SetSize(160, 16)

	DejaClassicStatsPane.stat = DejaClassicStatsPane.statFrame:CreateFontString(StatKey.."NameFS", "GameFontNormal")
	DejaClassicStatsPane.stat:SetPoint("LEFT", DejaClassicStatsPane.statFrame, "LEFT")
	if (namespace.locale == "zhCN") or (namespace.locale == "zhTW") or (namespace.locale == "koKR") then
		DejaClassicStatsPane.stat:SetFontObject("GameFontNormalLarge")
	else
		DejaClassicStatsPane.stat:SetFontObject("GameFontNormal")
	end	
	DejaClassicStatsPane.stat:SetJustifyH("LEFT")
	DejaClassicStatsPane.stat:SetShadowOffset(1, -1) 
	DejaClassicStatsPane.stat:SetShadowColor(0, 0, 0)
	DejaClassicStatsPane.stat:SetTextColor(1, 0.8, 0.1)
	DejaClassicStatsPane.stat:SetText("")

	DejaClassicStatsPane.value = DejaClassicStatsPane.statFrame:CreateFontString(StatKey.."ValueFS", "GameFontNormal")
	DejaClassicStatsPane.value:SetPoint("RIGHT", DejaClassicStatsPane.statFrame, "RIGHT")
	if (namespace.locale == "zhCN") or (namespace.locale == "zhTW") or (namespace.locale == "koKR") then
		DejaClassicStatsPane.value:SetFontObject("GameFontNormalLarge")
	else
		DejaClassicStatsPane.value:SetFontObject("GameFontNormal")
	end
	DejaClassicStatsPane.value:SetJustifyH("RIGHT")
	DejaClassicStatsPane.value:SetShadowOffset(1, -1) 
	DejaClassicStatsPane.value:SetShadowColor(0, 0, 0)
	DejaClassicStatsPane.value:SetTextColor(1,1,1,1)
	DejaClassicStatsPane.value:SetText("")
end

local function DCS_SetStatText(StatKey, StatValue1, StatValue2, StatValue3, StatValue4, StatValue5, XoffSet, YoffSet)
	_G[StatKey.."NameFS"]:SetText(DCS_STAT_DATA[StatKey].Label)
	_G[StatKey.."ValueFS"]:SetText(StatValue1)

	_G["DCS"..StatKey.."StatFrame"]:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(_G["DCS"..StatKey.."StatFrame"], "ANCHOR_RIGHT");
		GameTooltip:SetText(DCS_STAT_DATA[StatKey].Label..StatValue1.." "..StatValue5.."", 1, 1, 1, 1, true)
		GameTooltip:AddLine(StatValue2, 1, 0.8, 0.1, true)
		GameTooltip:AddLine(StatValue3, 1, 0.8, 0.1, true)
		GameTooltip:AddLine(StatValue4, 1, 0.8, 0.1, true)
		GameTooltip:Show()
	end)

	_G["DCS"..StatKey.."StatFrame"]:SetScript("OnLeave", function(self)
		GameTooltip_Hide()
	end)	
end

local function DCS_CREATE_STATS()
	for k, v in ipairs(DCS_PRIMARY_STAT_LIST) do
		local XoffSet = (0) 
		local YoffSet = (7 + k) 
		DCS_CreateStatText(v, 0, XoffSet, YoffSet)
	end
	for k, v in ipairs(DCS_MELEE_STAT_LIST) do
		DCS_CreateStatText(v, 0, 0, k)
	end
	for k, v in ipairs(DCS_DEFENSE_STAT_LIST) do
		local YoffSet = (2.2 + k) 
		DCS_CreateStatText(v, 0, 0, YoffSet)	
	end
	for k, v in ipairs(DCS_SPELL_STAT_LIST) do
		DCS_CreateStatText(v, 0, 0, k)
	end
end

local function DCS_SET_STATS_TEXT()
	for k, v in ipairs(DCS_PRIMARY_STAT_LIST) do
		local StatValue1, StatValue2, StatValue3, StatValue4, StatValue5 = DCS_STAT_DATA[v].statFunction()
		DCS_SetStatText(v, StatValue1, StatValue2, StatValue3, StatValue4, StatValue5, 0, 0)
	end
	for k, v in ipairs(DCS_MELEE_STAT_LIST) do
		local StatValue1, StatValue2, StatValue3, StatValue4, StatValue5 = DCS_STAT_DATA[v].statFunction()
		DCS_SetStatText(v, StatValue1, StatValue2, StatValue3, StatValue4, StatValue5, 0, 0)
	end
	for k, v in ipairs(DCS_DEFENSE_STAT_LIST) do
		local StatValue1, StatValue2, StatValue3, StatValue4, StatValue5 = DCS_STAT_DATA[v].statFunction()
		DCS_SetStatText(v, StatValue1, StatValue2, StatValue3, StatValue4, StatValue5, 0, 0)
	end
	for k, v in ipairs(DCS_SPELL_STAT_LIST) do
		local StatValue1, StatValue2, StatValue3, StatValue4, StatValue5 = DCS_STAT_DATA[v].statFunction()
		DCS_SetStatText(v, StatValue1, StatValue2, StatValue3, StatValue4, StatValue5, 0, 0)
	end
end

DCS_CLASSIC_SPECS = { -- These are not default UI/API positions organized to attatch specs to appropriate headings (Primary, Offense, Defense)
	DRUID = {
		spec = {
			tree1 = "DruidRestoration",
			tree2 = "DruidBalance",
			tree3 = "DruidFeralCombat",
		},
	},
	HUNTER = {
		spec = {
			tree1 = "HunterBeastMastery",
			tree2 = "HunterMarksmanship",
			tree3 = "HunterSurvival",
		},
	},
	MAGE = {
		spec = {
			tree1 = "MageArcane",
			tree2 = "MageFire",
			tree3 = "MageFrost",
		},
	},
	PALADIN = {
		spec = {
			tree1 = "PaladinHoly",
			tree2 = "PaladinCombat",
			tree3 = "PaladinProtection",
		},
	},
	PRIEST = {
		spec = {
			tree1 = "PriestHoly",
			tree2 = "PriestShadow",
			tree3 = "PriestDiscipline",
		},
	},
	ROGUE = {
		spec = {
			tree1 = "RogueAssassination",
			tree2 = "RogueCombat",
			tree3 = "RogueSubtlety",
		},
	},
	SHAMAN = {
		spec = {
			tree1 = "ShamanElementalCombat",
			tree2 = "ShamanEnhancement",
			tree3 = "ShamanRestoration",
		},
	},
	WARLOCK = {
		spec = {
			tree1 = "WarlockSummoning",
			tree2 = "WarlockDestruction",
			tree3 = "WarlockCurses",
		},
	},
	WARRIOR = {
		spec = {
			tree1 = "WarriorArms",
			tree2 = "WarriorFury",
			tree3 = "WarriorProtection",
		},
	},
}

DCS_CATEGORIES = {
	"Primary",
	"Offense",
	"Defense",
}
local DCS_PrimaryTalentSpec = 1
local DCS_OffenseTalentSpec = 2
local DCS_DefenseTalentSpec = 3

-- This may work to get talents in Classic. Use most points spent as Primary header art and adjsut others.
-- for i = 1, GetNumTalentTabs() do
-- 	local _, name, _, _, pointsSpent = GetTalentTabInfo(i)
-- 	print(i, name, pointsSpent)
-- end

-- This is dry coding from retail. 
-- In Classic I'll have to get each trees spent points and compare them to determin the "spec".
-- local currentSpec = GetSpecialization()
-- if (className == "Druid") then
-- 	if (currentSpec == 3) then currentSpec = 2 elseif (currentSpec == 4) then currentSpec = 3 end -- Druid adjustments for 4 trees
-- end
-- 	DCS_PrimaryTalentSpec = currentSpec
-- -- print(currentSpec)

-- if (currentSpec == 2) then
-- 	DCS_OffenseTalentSpec = 1
-- elseif (currentSpec == 3) then
-- 	DCS_DefenseTalentSpec = 1
-- end

-- print(DCS_CLASSIC_SPECS[className].spec["tree"..DCS_PrimaryTalentSpec])
----------------------
-- Talent Scroll Art --
----------------------
gdbprivate.gdbdefaults.gdbdefaults.DejaClassicStatsShowHideScrollArtBackground = {
	ShowHideScrollArtBackgroundChecked = true,
}

local TalentArtScale = 0.55
local TalentArtoffsetX, TalentArtoffsetY = 25, 20
local ShowHideScrollArt
local DesaturateScrollArtBackground

local function DCS_TalentArtFrames(v, frameTL, frameTR, frameBL, frameBR, drawLayer, DCS_TalentSpec, frameTLrelativeTo, relativePoint)
	ShowHideScrollArt = gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowHideScrollArtBackground.ShowHideScrollArtBackgroundChecked
	DesaturateScrollArtBackground = gdbprivate.gdb.gdbdefaults.DejaClassicStatsDesaturateScrollArtBackground.DesaturateScrollArtBackgroundChecked
	local frameexists = _G[frameTL.."Frame"]
	if (frameexists) then --Check for first frame, assume others unless errors occur
		if (ShowHideScrollArt == false) then
			_G[frameTL.."Frame"]:Hide()
			_G[frameTR.."Frame"]:Hide()
			_G[frameBL.."Frame"]:Hide()
			_G[frameBR.."Frame"]:Hide()
			_G[frameTL.."Frame"]:SetDesaturated(DesaturateScrollArtBackground);
			_G[frameTR.."Frame"]:SetDesaturated(DesaturateScrollArtBackground);
			_G[frameBL.."Frame"]:SetDesaturated(DesaturateScrollArtBackground);
			_G[frameBR.."Frame"]:SetDesaturated(DesaturateScrollArtBackground);
		end
		if (ShowHideScrollArt == true) then
			_G[frameTL.."Frame"]:Show()
			_G[frameTR.."Frame"]:Show()
			_G[frameBL.."Frame"]:Show()
			_G[frameBR.."Frame"]:Show()
			_G[frameTL.."Frame"]:SetDesaturated(DesaturateScrollArtBackground);
			_G[frameTR.."Frame"]:SetDesaturated(DesaturateScrollArtBackground);
			_G[frameBL.."Frame"]:SetDesaturated(DesaturateScrollArtBackground);
			_G[frameBR.."Frame"]:SetDesaturated(DesaturateScrollArtBackground);
		end
	else 
		local frameTL=DejaClassicStatsPane:CreateTexture(frameTL.."Frame","ARTWORK", nil, drawLayer)
		-- print(v, drawLayer, DCS_TalentSpec)
		frameTL:ClearAllPoints()
		frameTL:SetScale(TalentArtScale)
		frameTL:SetTexture("Interface\\TALENTFRAME\\"..DCS_CLASSIC_SPECS[classFilename].spec["tree"..DCS_TalentSpec].."-TopLeft")
		frameTL:SetDesaturated(DesaturateScrollArtBackground);
		frameTL:SetPoint("TOPLEFT", frameTLrelativeTo, "BOTTOMLEFT", TalentArtoffsetX, TalentArtoffsetY)
		local frameTR=DejaClassicStatsPane:CreateTexture(frameTR.."Frame","ARTWORK", nil, drawLayer)
		frameTR:ClearAllPoints()
		frameTR:SetScale(TalentArtScale)
		frameTR:SetTexture("Interface\\TALENTFRAME\\"..DCS_CLASSIC_SPECS[classFilename].spec["tree"..DCS_TalentSpec].."-TopRight")
		frameTR:SetDesaturated(DesaturateScrollArtBackground);
		frameTR:SetPoint("TOPLEFT", frameTL, "TOPRIGHT")
		local frameBL=DejaClassicStatsPane:CreateTexture(frameBL.."Frame","ARTWORK", nil, drawLayer)
		frameBL:ClearAllPoints()
		frameBL:SetScale(TalentArtScale)
		frameBL:SetTexture("Interface\\TALENTFRAME\\"..DCS_CLASSIC_SPECS[classFilename].spec["tree"..DCS_TalentSpec].."-BottomLeft")
		frameBL:SetDesaturated(DesaturateScrollArtBackground);
		frameBL:SetPoint("TOPLEFT", frameTL, "BOTTOMLEFT")
		local frameBR=DejaClassicStatsPane:CreateTexture(frameBR.."Frame","ARTWORK", nil, drawLayer)
		frameBR:ClearAllPoints()
		frameBR:SetScale(TalentArtScale)
		frameBR:SetTexture("Interface\\TALENTFRAME\\"..DCS_CLASSIC_SPECS[classFilename].spec["tree"..DCS_TalentSpec].."-BottomRight")
		frameBR:SetDesaturated(DesaturateScrollArtBackground);
		frameBR:SetPoint("TOPLEFT", frameTL, "BOTTOMRIGHT")
		if (ShowHideScrollArt == false) then
			frameTL:Hide()
			frameTR:Hide()
			frameBL:Hide()
			frameBR:Hide()
		end
	end
end

local function DCS_SetTalentArtFrames()
	for k, v in ipairs(DCS_CATEGORIES) do
		local DCS_TalentSpec
		if (v == "Primary") then
			DCS_TalentSpec = DCS_PrimaryTalentSpec
		elseif (v == "Offense") then
			DCS_TalentSpec = DCS_OffenseTalentSpec
		elseif (v == "Defense") then
			DCS_TalentSpec = DCS_DefenseTalentSpec
		end
		DCS_TalentArtFrames(v, v.."TopLeftTalentTexture", v.."TopRightTalentTexture", v.."BottomLeftTalentTexture", v.."BottomRightTalentTexture", k, DCS_TalentSpec, "DCS"..v.."StatsHeader", "BOTTOMLEFT")
	end
end

local DejaClassicStatsEventFrame = CreateFrame("Frame", "DejaClassicStatsEventFrame", UIParent)
-- DejaClassicStatsEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
DejaClassicStatsEventFrame:RegisterEvent("ADDON_LOADED")

	DejaClassicStatsEventFrame:SetScript("OnEvent", function(self, event, ...)
		CharacterAttributesFrame:Hide()
		-- CharacterModelFrame:SetScale(1.5)
		CharacterModelFrame:SetPoint("TOPLEFT", CharacterHeadSlot, "TOPRIGHT")
		CharacterModelFrame:SetPoint("BOTTOMRIGHT", CharacterTrinket1Slot, "BOTTOMLEFT")
		DCS_CREATE_STATS()
		DCS_PaperDollFrame_SetPrimaryStats()
		DCS_PaperDollFrame_SetArmor("player", "Character")
		DCS_PaperDollFrame_SetAttackBothHands("player", "Character")
		DCS_PaperDollFrame_SetAttackPower("player", "Character")
		DCS_PaperDollFrame_SetDamage("player", "Character")
		DCS_PaperDollFrame_SetRangedAttack("player", "Character")
		DCS_PaperDollFrame_SetRangedAttackPower("player", "Character")
		DCS_PaperDollFrame_SetRangedDamage("player", "Character")
		DCS_PaperDollFrame_SetResistances()
	end)

	hooksecurefunc("PaperDollFrame_UpdateStats", function()
		DCS_SET_STATS_TEXT()
		DCS_RepairTotal()
	end)

	CHAR_ROTATE_BUTTONS = {
		"CharacterModelFrameRotateRightButton",
		"CharacterModelFrameRotateLeftButton",
		}
	
	local ignoreDCSRBAlpha
	local DCSRBAlphaTimer
	
	local function SetAlpha(frame)
		if ignoreDCSRBAlpha then return end
		ignoreDCSRBAlpha = true
		if frame:IsMouseOver() then
			frame:SetAlpha(1)
		else
			frame:SetAlpha(0)
		end
		ignoreDCSRBAlpha = nil
	end
	
	local function showDCSRB(self)
		if DCSRBAlphaTimer then DCSRBAlphaTimer:Cancel() end
		for _, v in ipairs(CHAR_ROTATE_BUTTONS) do
			ignoreDCSRBAlpha = true
			_G[v]:SetAlpha(1)
			ignoreDCSRBAlpha = nil
		end
	end
	
	local function hideDCSRB(self)
		for _, v in ipairs(CHAR_ROTATE_BUTTONS) do
			ignoreDCSRBAlpha = true
			_G[v]:SetAlpha(0)
			ignoreDCSRBAlpha = nil
		end
	end
	
	local function delayHideDCSRB(self)
		DCSRBAlphaTimer = C_Timer.NewTimer(0.75, hideDCSRB)
	end
	
	for _, v in ipairs(CHAR_ROTATE_BUTTONS) do
		v = _G[v]
		hooksecurefunc(v, "SetAlpha", SetAlpha)
		v:HookScript("OnEnter", showDCSRB)
		v:HookScript("OnLeave", delayHideDCSRB)
		v:SetAlpha(0)
	end

	local DCS_ShowHideScrollArtBackgroundCheckedCheck = CreateFrame("CheckButton", "DCS_ShowHideScrollArtBackgroundCheckedCheck", DejaClassicStatsPanel, "InterfaceOptionsCheckButtonTemplate")
		DCS_ShowHideScrollArtBackgroundCheckedCheck:RegisterEvent("PLAYER_LOGIN")
		DCS_ShowHideScrollArtBackgroundCheckedCheck:ClearAllPoints()
		--DCS_ShowHideScrollArtBackgroundCheckedCheck:SetPoint("TOPLEFT", 30, -255)
		DCS_ShowHideScrollArtBackgroundCheckedCheck:SetPoint("TOPLEFT", "dcsMiscPanelCategoryFS", 7, -15)
		DCS_ShowHideScrollArtBackgroundCheckedCheck:SetScale(1)
		_G[DCS_ShowHideScrollArtBackgroundCheckedCheck:GetName() .. "Text"]:SetText(L["Background Art"])
		DCS_ShowHideScrollArtBackgroundCheckedCheck.tooltipText = L["Displays the class talents background art."] --Creates a tooltip on mouseover.
	
	DCS_ShowHideScrollArtBackgroundCheckedCheck:SetScript("OnEvent", function(self, event, ...)
		ShowHideScrollArt = gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowHideScrollArtBackground.ShowHideScrollArtBackgroundChecked
		self:SetChecked(ShowHideScrollArt)
		DCS_SetTalentArtFrames()
	end)
	
	DCS_ShowHideScrollArtBackgroundCheckedCheck:SetScript("OnClick", function(self)
		ShowHideScrollArt = not ShowHideScrollArt
		gdbprivate.gdb.gdbdefaults.DejaClassicStatsShowHideScrollArtBackground.ShowHideScrollArtBackgroundChecked = ShowHideScrollArt
		DCS_SetTalentArtFrames()
	end)

	gdbprivate.gdbdefaults.gdbdefaults.DejaClassicStatsDesaturateScrollArtBackground = {
		DesaturateScrollArtBackgroundChecked = true,
	}
	local DesaturateScrollArtBackground --alternate display position of item repair cost, durability, and ilvl
	
	local DCS_DesaturateScrollArtBackgroundCheckedCheck = CreateFrame("CheckButton", "DCS_DesaturateScrollArtBackgroundCheckedCheck", DejaClassicStatsPanel, "InterfaceOptionsCheckButtonTemplate")
		DCS_DesaturateScrollArtBackgroundCheckedCheck:RegisterEvent("PLAYER_LOGIN")
		DCS_DesaturateScrollArtBackgroundCheckedCheck:ClearAllPoints()
		--DCS_DesaturateScrollArtBackgroundCheckedCheck:SetPoint("TOPLEFT", 30, -255)
		DCS_DesaturateScrollArtBackgroundCheckedCheck:SetPoint("TOPLEFT", "dcsMiscPanelCategoryFS", 7, -35)
		DCS_DesaturateScrollArtBackgroundCheckedCheck:SetScale(1)
		_G[DCS_DesaturateScrollArtBackgroundCheckedCheck:GetName() .. "Text"]:SetText(L["Monochrome Background Art"])
		DCS_DesaturateScrollArtBackgroundCheckedCheck.tooltipText = L["Displays black and white class talents background art."] --Creates a tooltip on mouseover.
	
	DCS_DesaturateScrollArtBackgroundCheckedCheck:SetScript("OnEvent", function(self, event, ...)
		DesaturateScrollArtBackground = gdbprivate.gdb.gdbdefaults.DejaClassicStatsDesaturateScrollArtBackground.DesaturateScrollArtBackgroundChecked
		self:SetChecked(DesaturateScrollArtBackground)
	end)
	
	DCS_DesaturateScrollArtBackgroundCheckedCheck:SetScript("OnClick", function(self)
		DesaturateScrollArtBackground = not DesaturateScrollArtBackground
		gdbprivate.gdb.gdbdefaults.DejaClassicStatsDesaturateScrollArtBackground.DesaturateScrollArtBackgroundChecked = DesaturateScrollArtBackground
		DCS_SetTalentArtFrames()
	end)