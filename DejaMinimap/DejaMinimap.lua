local DMM_isClassic
local _, _, _, tocversion = GetBuildInfo()
if (tocversion < 20000) then
	DMM_isClassic = true
end

--SavedVariables Setup
local DejaMinimap, private = ...

private.defaults = {
    -- If you have any general settings for you addon,
    -- list them here, or just leave the table empty.
}

local loader = CreateFrame("Frame")
	loader:RegisterEvent("ADDON_LOADED")
	loader:SetScript("OnEvent", function(self, addon)
		if addon ~= DejaMinimap then 
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

		DejaMinimapDBPC = initDB(DejaMinimapDBPC, private.defaults)
		private.db = DejaMinimapDBPC -- add this
		self:UnregisterEvent("ADDON_LOADED")
		-- Don't place any frames here
		end
	end)

DejaMinimap = {};

local _, private = ...
	private.defaults.optpanelDefaults = {
		point = "RIGHT", 
		relativeTo = "UIParent", 
		relativePoint = "RIGHT", 
		xOffset = 0, 
		yOffset = 0,
	}	
	
DejaMinimap.panel = CreateFrame( "Frame", "DejaMinimapPanel", UIParent );
-- Register in the Interface Addon Options GUI
-- Set the name for the Category for the Options Panel
DejaMinimap.panel.name = "DejaMinimap";
-- Add the panel to the Interface Options
InterfaceOptions_AddCategory(DejaMinimap.panel);

-- Make a child panel
-- DejaMinimap.childpanel = CreateFrame( "Frame", "DejaMinimapChild", DejaMinimap.panel);
-- DejaMinimap.childpanel.name = "MyChild";
-- Specify childness of this panel (this puts it under the little red [+], instead of giving it a normal AddOn category)
-- DejaMinimap.childpanel.parent = DejaMinimap.panel.name;
-- Add the child to the Interface Options
-- InterfaceOptions_AddCategory(DejaMinimap.childpanel);

--Panel Title
local dvMMtitle=CreateFrame("Frame", "dvMMtitle", DejaMinimapPanel)
	dvMMtitle:SetPoint("TOPLEFT", 5, -5)
	dvMMtitle:SetScale(2.0)
	dvMMtitle:SetWidth(150)
	dvMMtitle:SetHeight(50)
	dvMMtitle:Show()

local dvMMtitleFS = dvMMtitle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	dvMMtitleFS:SetText('|cff00c0ffDejaMinimap|r')
	dvMMtitleFS:SetPoint("TOPLEFT", 0, 0)
	dvMMtitleFS:SetFont("Fonts\\FRIZQT__.TTF", 10)
	
dvMMresetcheck = CreateFrame("Button", "dvMMResetButton", DejaMinimapPanel, "UIPanelButtonTemplate")
	dvMMresetcheck:ClearAllPoints()
	dvMMresetcheck:SetPoint("BOTTOMLEFT", 5, 5)
	dvMMresetcheck:SetScale(1.25)
	dvMMresetcheck:SetWidth(125)
	dvMMresetcheck:SetHeight(30)
	_G[dvMMresetcheck:GetName() .. "Text"]:SetText("Reset to Default")
	dvMMresetcheck:SetScript("OnClick", function (self, button, down)
 		DejaMinimapDBPC = private.defaults;
		ReloadUI();
end)

 dvMMlockcheck = CreateFrame("CheckButton", "DejaMinimapLockAll", DejaMinimapPanel, "InterfaceOptionsCheckButtonTemplate")
	dvMMlockcheck:ClearAllPoints()
	dvMMlockcheck:SetPoint("TOPLEFT", 25, -50)
	dvMMlockcheck:SetScale(1.25)
	_G[dvMMlockcheck:GetName() .. "Text"]:SetText("Lock all frames")
	dvMMlockcheck.tooltipText = 'Checked locks all DejaMinimap frames. Unchecked unlocks all DejaMinimap frames.' --Creates a tooltip on mouseover.
	dvMMlockcheck:SetChecked(true)
	
	dvMMlockcheckframe=CreateFrame("Frame", "dvMMlockcheckframe", UIParent)
	dvMMlockcheckframe:SetClampedToScreen(1)
	dvMMlockcheckframe:SetFrameStrata("BACKGROUND")
	dvMMlockcheckframe:SetFrameLevel("1")
	dvMMlockcheckframe:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT")
	dvMMlockcheckframe:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT")
	dvMMlockcheckframe:Hide()
	
	-- Lock/Unlock Frames
	dvMMlockcheck:SetScript("OnClick", function(self,button,down) 
		if self:GetChecked(true) then
			dvMMlockcheckframe:Hide()
		else
			dvMMlockcheckframe:Show()
		end
	end)
	
--Open Categaories Fix
do
	local function get_panel_name(panel)
		local tp = type(panel)
		local cat = INTERFACEOPTIONS_ADDONCATEGORIES
		if tp == "string" then
			for i = 1, #cat do
				local p = cat[i]
				if p.name == panel then
					if p.parent then
						return get_panel_name(p.parent)
					else
						return panel
					end
				end
			end
		elseif tp == "table" then
			for i = 1, #cat do
				local p = cat[i]
				if p == panel then
					if p.parent then
						return get_panel_name(p.parent)
					else
						return panel.name
					end
				end
			end
		end
	end

	local function InterfaceOptionsFrame_OpenToCategory_Fix(panel)
		if doNotRun or InCombatLockdown() then return end
		local panelName = get_panel_name(panel)
		if not panelName then return end -- if its not part of our list return early
		local noncollapsedHeaders = {}
		local shownpanels = 0
		local mypanel
		local t = {}
		local cat = INTERFACEOPTIONS_ADDONCATEGORIES
		for i = 1, #cat do
			local panel = cat[i]
			if not panel.parent or noncollapsedHeaders[panel.parent] then
				if panel.name == panelName then
					panel.collapsed = true
					t.element = panel
					InterfaceOptionsListButton_ToggleSubCategories(t)
					noncollapsedHeaders[panel.name] = true
					mypanel = shownpanels + 1
				end
				if not panel.collapsed then
					noncollapsedHeaders[panel.name] = true
				end
				shownpanels = shownpanels + 1
			end
		end
		local Smin, Smax = InterfaceOptionsFrameAddOnsListScrollBar:GetMinMaxValues()
		if shownpanels > 15 and Smin < Smax then 
		  local val = (Smax/(shownpanels-15))*(mypanel-2)
		  InterfaceOptionsFrameAddOnsListScrollBar:SetValue(val)
		end
		doNotRun = true
		InterfaceOptionsFrame_OpenToCategory(panel)
		doNotRun = false
	end

	hooksecurefunc("InterfaceOptionsFrame_OpenToCategory", InterfaceOptionsFrame_OpenToCategory_Fix)
end

--dvMM Slash Setup
local RegisteredEvents = {};
local dvMMslash = CreateFrame("Frame", "DejaMinimapSlash", UIParent)

dvMMslash:SetScript("OnEvent", function (self, event, ...) 
	if (RegisteredEvents[event]) then 
	return RegisteredEvents[event](self, event, ...) 
	end
end)

function RegisteredEvents:ADDON_LOADED(event, addon, ...)
	if (addon == "DejaMinimap") then
		SLASH_DEJAMINIMAP1 = '/dejaminimap'
		SlashCmdList["DejaMinimap"] = function (msg, editbox)
			DejaMinimap.SlashCmdHandler(msg, editbox)	
		end
		-- DEFAULT_CHAT_FRAME:AddMessage("DejaMinimap loaded successfully. Type /dejaminimap for usage",0,192,255)
	end
end

for k, v in pairs(RegisteredEvents) do
	dvMMslash:RegisterEvent(k)
end

function DejaMinimap.ShowHelp()
	print("DejaMinimap Slash commands (/dejaminimap):")
	print("  /dejaminimap lock: Locks all DejaMinimap movable frames.")
	print("  /dejaminimap unlock: Unlocks all DejaMinimap movable frames.")
	print("  /dejaminimap config: Open the DejaMinimap addon config menu.")
	print("  /dejaminimap reset:  Resets DejaMinimap frames to default positions.")
end

function DejaMinimap.SetConfigToDefaults()
	print("Resetting config to defaults")
	DejaMinimapDBPC = DefaultConfig
	RELOADUI()
end

function DejaMinimap.GetConfigValue(key)
	return DejaMinimapDBPC[key]
end

function DejaMinimap.PrintPerformanceData()
	UpdateAddOnMemoryUsage()
	local mem = GetAddOnMemoryUsage("DejaMinimap")
	print("DejaMinimap is currently using " .. mem .. " kbytes of memory")
	collectgarbage(collect)
	UpdateAddOnMemoryUsage()
	mem = GetAddOnMemoryUsage("DejaMinimap")
	print("DejaMinimap is currently using " .. mem .. " kbytes of memory after garbage collection")
end

function DejaMinimap.SlashCmdHandler(msg, editbox)
	--print("command is " .. msg .. "\n")
	if (string.lower(msg) == "config") then
		InterfaceOptionsFrame_OpenToCategory("DejaMinimap");
	elseif (string.lower(msg) == "dumpconfig") then
		print("With defaults")
		for k,v in pairs(dvMMDefaultConfig) do
			print(k,DejaMinimap.GetConfigValue(k))
		end
		print("Direct table")
		for k,v in pairs(dvMMDefaultConfig) do
			print(k,v)
		end
	elseif (string.lower(msg) == "lock") then
		dvMMlockcheckframe:Hide()
		dvMMlockcheck:SetChecked(true)
	elseif (string.lower(msg) == "unlock") then
		dvMMlockcheckframe:Show()
		dvMMlockcheck:SetChecked(false)
	elseif (string.lower(msg) == "reset") then
		DejaMinimapDBPC = private.defaults;
		ReloadUI();
	elseif (string.lower(msg) == "perf") then
		DejaMinimap.PrintPerformanceData()
	else
		DejaMinimap.ShowHelp()
	end
end
	SlashCmdList["DEJAMINIMAP"] = DejaMinimap.SlashCmdHandler;

-- dvMMMinimapFrame
local dvMMminimapframe=CreateFrame("Frame", "dvMMminimapframe", dvMMlockcheckframe)
	dvMMminimapframe:RegisterEvent("PLAYER_LOGIN")
	dvMMminimapframe:SetFrameStrata("HIGH")
	dvMMminimapframe:SetClampedToScreen(true)
	dvMMminimapframe:SetMovable(true)
	dvMMminimapframe:EnableMouse(true)
	dvMMminimapframe:RegisterForDrag("LeftButton")
	dvMMminimapframe:SetWidth(120)
	dvMMminimapframe:SetHeight(120)
	dvMMminimapframe:Show()
	
	dvMMminimapframe:SetScript("OnEvent", function(self, event, arg1)
		if event == "PLAYER_LOGIN" then
		local slideValue = private.db.mmsliderSetScale
			self:SetScale(slideValue.minimapScale)	

		local point = private.db.minimapSetPoints
			self:ClearAllPoints()		
			self:SetPoint(
				point.point, 
				point.relativeTo, 
				point.relativePoint, 
				point.xOffset, 
				point.yOffset)
		end
		Minimap:ClearAllPoints()
		Minimap:SetPoint("BOTTOMRIGHT", dvMMminimapframe, "BOTTOMRIGHT", 0, 0)
	end)

	dvMMminimapframe:SetScript("OnDragStart", dvMMminimapframe.StartMoving) 
	
	dvMMminimapframe:SetScript("OnDragStop", function(self) 
		self:StopMovingOrSizing() 
		self:SetUserPlaced(false) 
		
		point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(1)
			if ( relativeTo ) then
				relativeTo = relativeTo:GetName();
			else
				relativeTo = self:GetParent():GetName();
			end
	
		-- These are debugging messages for the frame points
		-- Un-comment them to help debug
		-- DEFAULT_CHAT_FRAME:AddMessage(point)
		-- DEFAULT_CHAT_FRAME:AddMessage(relativeTo)
		-- DEFAULT_CHAT_FRAME:AddMessage(relativePoint)
		-- DEFAULT_CHAT_FRAME:AddMessage(xOfs)
		-- DEFAULT_CHAT_FRAME:AddMessage(yOfs)

		private.db.minimapSetPoints.point = point
		private.db.minimapSetPoints.relativeTo = relativeTo
		private.db.minimapSetPoints.relativePoint = relativePoint
		private.db.minimapSetPoints.xOffset = xOfs
		private.db.minimapSetPoints.yOffset = yOfs			
	end)
	
local dvMMminimapframeFS = dvMMminimapframe:CreateFontString("FontString","OVERLAY","GameTooltipText")
local dvMMminimapFS = dvMMminimapframe:CreateFontString("FontString","OVERLAY","GameTooltipText")

	dvMMminimapFS:SetPoint("CENTER",dvMMminimapframe,"CENTER",0,0)
	dvMMminimapFS:SetFont("Fonts\\FRIZQT__.TTF", 10, "THINOUTLINE")
	dvMMminimapFS:SetText("MiniMap");
	dvMMminimapFS:SetTextColor(1, 1, 1);
	
local t=dvMMminimapframe:CreateTexture(nil,"ARTWORK")
	t:SetAllPoints(dvMMminimapframe)
	t:SetColorTexture(0, 192, 255, 0.7)

-- 	
local _, private = ...
	private.defaults.mmsliderSetScale = {
		minimapScale = 1.16,
	}	
	
-- Minimap Slider:
local MMSlider = CreateFrame("Slider", "MMSlider", DejaMinimapPanel, "OptionsSliderTemplate")
	MMSlider:RegisterEvent("PLAYER_LOGIN")
	MMSlider:RegisterEvent("PLAYER_ENTERING_WORLD")
	MMSlider:RegisterEvent("ADDON_LOADED")
	MMSlider:SetPoint("CENTER", DejaMinimapPanel, "CENTER", 0, 0)
	MMSlider:SetWidth(200)
	MMSlider:SetHeight(10)
	MMSlider:SetOrientation('HORIZONTAL')
	MMSlider:SetMinMaxValues(0.50, 3.0)
	MMSlider.minValue, MMSlider.maxValue = MMSlider:GetMinMaxValues() 
	MMSlider:SetValueStep(0.05)
	MMSlider:SetObeyStepOnDrag(true)

	MMSlider.tooltipText = 'Scale the minimap in increments or decrements of 5' --Creates a tooltip on mouseover.

	getglobal(MMSlider:GetName() .. 'Low'):SetText(MMSlider.minValue); --Sets the left-side slider text (default is "Low").
	getglobal(MMSlider:GetName() .. 'High'):SetText(MMSlider.maxValue); --Sets the right-side slider text (default is "High").

	MMSlider:Show()
			
	MMSlider:SetScript("OnEvent", function(self, event, arg1)
		if event == "PLAYER_LOGIN" then
		local slideValue = private.db.mmsliderSetScale.minimapScale
			self:SetValue(slideValue)
			Minimap:SetScale(slideValue)
			dvMMminimapframe:SetScale(slideValue)

			getglobal(MMSlider:GetName() .. 'Text'):SetFormattedText("Minimap Scale = (%.2f)", (slideValue)); --Sets the "title" text (top-centre of slider).
		end
	end)

	MMSlider:SetScript("OnValueChanged", function(self, value) 
	local slideValue = MMSlider:GetValue()
		Minimap:SetScale(slideValue)
		dvMMminimapframe:SetScale(slideValue)
					
		getglobal(MMSlider:GetName() .. 'Text'):SetFormattedText("Minimap Scale = (%.2f)", (slideValue)); --Sets the "title" text (top-centre of slider).
		private.db.mmsliderSetScale.minimapScale = slideValue
	end)	

-- Deja Minimap

local _, private = ...
	private.defaults.minimapSetPoints = {
		point = "TOPRIGHT", 
		relativeTo = "dvMMlockcheckframe", 
		relativePoint = "TOPRIGHT", 
		xOffset = 0, 
		yOffset = 0,
	}	
	
-- Minimap

--Hide Minimap Frames
	MinimapBorder:Hide()
	MinimapBorderTop:Hide()
	MinimapZoomIn:Hide()
	MinimapZoomOut:Hide()
	MinimapNorthTag:Hide()
	if not DMM_isClassic then MiniMapTracking:SetAlpha(0) end

--Hide Minimap Clock
local mm = CreateFrame("Frame", "DejaMinimapFrame")

	mm:RegisterEvent("PLAYER_LOGIN")
	mm:RegisterEvent("PLAYER_ENTERING_WORLD")
	mm:RegisterEvent("ADDON_LOADED")
	if not DMM_isClassic then mm:RegisterEvent("PET_BATTLE_OVER") end
	mm:RegisterEvent("UPDATE_INSTANCE_INFO")

local function eventHandler(self, event, ...)
	for i = 1, 1 do
		if TimeManagerClockButton then
			TimeManagerClockButton:SetAlpha(0)
		end
	end
end

mm:SetScript("OnEvent",eventHandler)

-- Make Minimap Movable
	Minimap:RegisterEvent("PLAYER_LOGIN")
	Minimap:SetFrameStrata("MEDIUM")
	Minimap:SetFrameLevel("5")
	Minimap:SetClampedToScreen(true)
	Minimap:SetMovable(true)
	Minimap:EnableMouse(true)
	Minimap:RegisterForDrag("LeftButton")
	Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')
	Minimap:EnableMouseWheel(true)

	Minimap:SetScript("OnEvent", function(self, event, arg1)
		if event == "PLAYER_LOGIN" then
		local slideValue = private.db.mmsliderSetScale
			self:SetScale(slideValue.minimapScale)	
		end
	end)

	Minimap:SetScript("OnMouseWheel", function(mp, input)
	local zoom = Minimap:GetZoom()
		if input > 0 and zoom < 5 then
			mp:SetZoom(zoom +1)
		elseif input < 0 and zoom > 0 then
			mp:SetZoom(zoom -1)
		end
	end)
	
-- Move Minimap Icons
	MiniMapMailBorder:SetAlpha(0)
	MiniMapMailFrame:SetScale(1.25)
	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 7, 5)

	GameTimeFrame:SetAlpha(0)
	GameTimeFrame:ClearAllPoints()
	GameTimeFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 0)

	MiniMapWorldMapButton:SetScale(1.5)
	MiniMapWorldMapButton:SetAlpha(0)
	MiniMapWorldMapButton:ClearAllPoints()
	MiniMapWorldMapButton:SetPoint("TOP", Minimap, "TOP", 0, 10)

	MinimapBackdrop:ClearAllPoints()
	MinimapBackdrop:SetParent(Minimap)
	MinimapBackdrop:SetPoint("TOP", Minimap, "TOP", 0, 0)

	--Zone Text
	MinimapCompassTexture:SetParent("Minimap")
	MinimapZoneTextButton:ClearAllPoints()
	MinimapZoneTextButton:SetParent("Minimap")
	MinimapZoneTextButton:SetPoint("TOP", Minimap, "TOP", 0, 0)

	if (MiniMapRecordingBorder~=nil) then
		MiniMapRecordingBorder:SetAlpha(0)
		MiniMapRecordingButton:ClearAllPoints()
		MiniMapRecordingButton:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 0, 0)
	end
	
	if DMM_isClassic then
		MinimapToggleButton:Hide()
	end

	if not DMM_isClassic then
		MiniMapTracking:ClearAllPoints()
		MiniMapTracking:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)
		
		QueueStatusMinimapButton:ClearAllPoints()
		QueueStatusMinimapButton:SetParent("Minimap")
		QueueStatusMinimapButton:SetPoint("CENTER", Minimap, "LEFT", 0, 0)
		
		QueueStatusFrame:ClearAllPoints()
		QueueStatusFrame:SetFrameStrata("TOOLTIP")
		QueueStatusFrame:SetParent("Minimap")
		QueueStatusFrame:SetPoint("BOTTOMRIGHT", Minimap, "TOPRIGHT", -2, 2)
		
		MiniMapInstanceDifficulty_AdjustPosition = function() end
		MiniMapInstanceDifficulty:SetParent(UIParent)
		MiniMapInstanceDifficulty:SetScale(0.5)
		MiniMapInstanceDifficulty:ClearAllPoints()
		MiniMapInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)
		
		GuildInstanceDifficulty_AdjustPosition = function() end
		GuildInstanceDifficulty:SetParent(UIParent)
		GuildInstanceDifficulty:SetScale(0.5)
		GuildInstanceDifficulty:ClearAllPoints()
		GuildInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)

		GarrisonLandingPageMinimapButton:SetParent(MinimapBackdrop)
		GarrisonLandingPageMinimapButton:SetScale(1.0)
		GarrisonLandingPageMinimapButton:ClearAllPoints()	
		GarrisonLandingPageMinimapButton:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", -10, -10)
		GarrisonLandingPageMinimapButton:SetScale(0.75)
		GarrisonLandingPageMinimapButton:SetAlpha(0.5)
	end
	
-- Create New Minimap Clock
local use24hformat = false

local mmclock = CreateFrame("Frame", nil, Minimap)
	mmclock:RegisterEvent("PLAYER_LOGIN")
	mmclock:RegisterEvent("PLAYER_ENTERING_WORLD")
	mmclock:RegisterEvent("ADDON_LOADED")
	mmclock:RegisterEvent("PLAYER_REGEN_DISABLED")
	mmclock:RegisterEvent("PLAYER_REGEN_ENABLED")
	mmclock:RegisterEvent("UNIT_COMBAT")
	if not DMM_isClassic then 
		mmclock:RegisterEvent("PET_BATTLE_OVER")
		mmclock:RegisterEvent("PET_BATTLE_OPENING_START")
	end
	mmclock:SetFrameStrata("MEDIUM")
	mmclock:SetFrameLevel("9")
	mmclock:SetWidth(100)
	mmclock:SetHeight(26)
	mmclock:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, 0)
	mmclock:Show()

local clockFS = mmclock:CreateFontString("FontString","OVERLAY","GameTooltipText")

	clockFS:SetPoint("BOTTOM",mmclock,"BOTTOM",0,0)

local elapsed = 0
	mmclock:SetScript("OnUpdate", function(self, e)
	   elapsed = elapsed + e
	   if elapsed >= 1 then
		   MinimapClockRefresh()
		   elapsed = 0
	   end
end)

	mmclock:SetScript("OnEvent", function()
		clockFS:SetTextColor(1, 1, 1);
		MinimapClockRefresh()
	end)
	
function MinimapClockRefresh()
	if use24hformat then
		clockFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
		clockFS:SetText(date("%H:%M"))
	else
		clockFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
		clockFS:SetText(("%d:%s"):format(tonumber(date("%I")),((date("%M%p")))))
	end
end

-- -- Minimap Coordinates
local coordframe = CreateFrame("Frame", nil, Minimap)
	coordframe:SetFrameStrata("MEDIUM")
	coordframe:SetFrameLevel("9")
	coordframe:SetWidth(100)
	coordframe:SetHeight(26)
	coordframe:SetPoint("TOP", MinimapZoneTextButton, "BOTTOM", 0, 0)
	coordframe:Show()

local elapsed = 0
local coordframeFS = coordframe:CreateFontString("FontString","OVERLAY","GameTooltipText")
local coordFS = coordframe:CreateFontString("FontString","OVERLAY","GameTooltipText")
function coordRefresh()
	local posX, posY = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY()
		coordFS:SetFont("Fonts\\FRIZQT__.TTF", 12, "THINOUTLINE")
		coordFS:SetFormattedText("%.1f, %.1f", posX*100, posY*100)
end

	coordFS:SetPoint("TOP",coordframe,"TOP",0,0)

	coordframe:SetScript("OnEvent", function()
		coordFS:SetTextColor(1, 1, 1);
		coordRefresh()
	end)
	
	coordframe:SetScript("OnUpdate", function(self, e)
		local inInstance, instanceType = IsInInstance()
		if not IsInInstance(player) then
		elapsed = elapsed + e
		if elapsed >= 1 then
			coordRefresh()
			elapsed = 0
		end
		else
			coordFS:SetFormattedText("")
		end
	end)
