-- ** Buffwatch Classic
-- **

-- Changes
--
-- 1.00 Initial version for Classic based on Buffwatch++ v8.11

-- 1.01
-- Fixed checking missing buff events after combat
-- Fixed loading options on login/reload

-- 1.02
-- Optimisation when checking buffs
-- Fixed toggling Hide cooldown text when OmniCC is installed

-- 1.03
-- Hotfix for buff frames not hiding correctly

-- 1.04
-- Fixed UnitBuff filtering that was removed in retail v4.03
--  (Some buffs that were incorrectly shown with 'Show only castable buffs'
--   will no longer show with this option selected)
-- Added caster name to tooltips
-- Optimisations for checking locked buffs and when looking for group buffs
-- Added special rules for buffs that should only match to the original caster

-- 1.05
-- Added support for LibClassicDurations, to show cooldown spirals for all

-- 1.06
-- Added check to only load LibClassicDurations version 1.8 or newer

-- 1.07
-- Added checking for Temporary Weapon Enchants
-- Added group buffs for Intellect, Fortitude, Spirit, MotW, Shadow Prot,
--  Might, Wisdom, Salvation, Kings, Light & Sanctuary

-- 1.08
-- Fixed temp enchant alignment when player has no normal buffs
-- Fixed alt-rightclick error on another player when we have temp enchant

-- 1.09
-- Added support for buff ranks

-- 1.10
-- Fixed issue with buff rank localization
-- Fixed buff names for Flasks & Elixirs

-- 1.11
-- Changed method for buff rank localization as rank information wasn't always
--  returned by the api and was getting lost at initial login
-- Buff ranks are enabled for locales: enUS, enGB, deDE, esES, esMX, frFR,
--  ptBR and ruRU
-- Other localizations will always cast max rank until they can be added

-- ****************************************************************************
-- **                                                                        **
-- **  Variables                                                             **
-- **                                                                        **
-- ****************************************************************************
-- Local vars and funcs
local addonName, BUFFWATCHADDON = ...;
-- Globally required vars and funcs
BUFFWATCHADDON_G = { };

BUFFWATCHADDON.NAME = "Buffwatch Classic";
BUFFWATCHADDON.VERSION = "1.11";
BUFFWATCHADDON.RELEASE_DATE = "11 Oct 2019";
BUFFWATCHADDON.HELPFRAMENAME = "Buffwatch Help";
BUFFWATCHADDON.MODE_DROPDOWN_LIST = {
    "Solo",
    "Party",
    "Raid"
};
BUFFWATCHADDON.SORTORDER_DROPDOWN_LIST = {
    "Raid Order",
    "Class",
    "Name"
};
BUFFWATCHADDON.ANCHORPOINT_DROPDOWN_LIST = {
    "Auto",
    "Top Left",
    "Top Right",
    "Bottom Left",
    "Bottom Right",
    "Center"
};
BUFFWATCHADDON.ANCHORPOINT_DROPDOWN_MAP = {
    ["Auto"] = "",
    ["Top Left"] = "TOPLEFT",
    ["Top Right"] = "TOPRIGHT",
    ["Bottom Left"] = "BOTTOMLEFT",
    ["Bottom Right"] = "BOTTOMRIGHT",
    ["Center"] = "CENTER"
};

BUFFWATCHADDON.DEFAULTS = {
    Alpha             = 0.5,
    CooldownTextScale = 0.45,
    ExpiredSound      = false,
    ExpiredWarning    = true,
    HideCooldownText  = true,
    Spirals           = true,
    Version           = BUFFWATCHADDON.VERSION,
    debug             = false
};

BUFFWATCHADDON.PLAYER_DEFAULTS = {
    AnchorPoint             = "Auto",
    AnchorX                 = 200,
    AnchorY                 = 200,
    HideUnmonitored         = false, -- Whether to show locked frames that have no buffs
    Minimized               = false, -- Is window minimized
    Mode                    = BUFFWATCHADDON.MODE_DROPDOWN_LIST[3],
    Scale                   = 1.0,
    ShowOnlyMine            = false,
    ShowCastableBuffs       = false,
    ShowAllForPlayer        = false,
    ShowPets                = true,
    SortOrder               = BUFFWATCHADDON.SORTORDER_DROPDOWN_LIST[1],
    Version                 = BUFFWATCHADDON.VERSION,
    WindowLocked            = false
};

local grouptype;                -- solo, raid or party
local maxnamewidth = 0;         -- Width of the longest player name, to set buff button alignment
local maxnameid = 1;            -- The frame ID with the longest player name
BUFFWATCHADDON.framePositioned = false; -- Flag whether frame has been positioned correctly on login
local initialSetupComplete = false; -- Flag whether we have completed the setup of the addon on login
local maxBuffCount = 32;       -- Maximum number of buffs to check for on a single player

local Player_Info = { };        -- Details of each player, see BUFFWATCHADDON.GetPlayerInfo()
local Player_Left = { };        -- Retained Player_Info for players that have left group
local Player_Order = { };       -- Sorted order of players
local Current_Order = { };      -- Currently visible order of players
local UNIT_IDs = { };           -- UnitIDs, based on grouptype and whether we want pets
local UNIT_IDs_Keyed = { };     -- Same as above but keyed by UnitID. Used to ensure we only check
                                --  events for units we are interested in, and dont duplicate checks
                                --  in cases such as when our target or focus is in the group
local InCombat_Events = { };    -- Events that occur in combat lockdown, to sort out after combat
local GroupBuffs = { };         -- Relationship list of buffs that can automatically replace each other
local SpecialBuffs = { };       -- List of buffs with special rules
local dropdowninfo = { };       -- Info for dropdown menu buttons

-- Save global options
BuffwatchConfig = CopyTable(BUFFWATCHADDON.DEFAULTS);

-- Save player options
BuffwatchPlayerConfig = CopyTable(BUFFWATCHADDON.PLAYER_DEFAULTS);

local BuffwatchPlayerBuffs = { };       -- List of buffs that are shown for each player
local BuffwatchPlayerTempEnch = { };    -- List of temporary enchants that are shown for this player
BuffwatchSaveBuffs = { };               -- List of locked buffs that we save between sessions for each player
BuffwatchSaveTempEnch = { };            -- List of locked temporary enchants that we save between sessions for this player

local debugchatframe = DEFAULT_CHAT_FRAME;  -- Frame to output debug messages to

local tempEnchantMapping = {
    [1] = 16,	--Main hand
    [2] = 17,	--Off-hand
    [3] = 18,	--Ranged
};
local tempEnchantSlotMapping = {
    [1] = "Main hand",
    [2] = "Off hand",
    [3] = "Ranged",
};

local UnitAura = _G.UnitAura; -- Use local copy, to be replaced if LibClassicDurations is present

-- ****************************************************************************
-- **                                                                        **
-- **  Events & Related                                                      **
-- **                                                                        **
-- ****************************************************************************

function BUFFWATCHADDON_G.OnLoad(self)

    self:RegisterEvent("PLAYER_LOGIN");
    self:RegisterEvent("GROUP_ROSTER_UPDATE");
    -- UNIT_FLAGS Used for connects/dcs too instead of UNIT_CONNECTED, since it also triggers on unit death
    self:RegisterEvent("UNIT_FLAGS");
    self:RegisterEvent("PLAYER_FLAGS_CHANGED");
    self:RegisterEvent("UNIT_PET");
    self:RegisterEvent("UNIT_AURA");
    self:RegisterEvent("ADDON_LOADED");
    self:RegisterEvent("PLAYER_REGEN_ENABLED");
    self:RegisterEvent("PLAYER_REGEN_DISABLED");
    self:RegisterEvent("UNIT_INVENTORY_CHANGED");

    SlashCmdList["BUFFWATCH"] = BUFFWATCHADDON.SlashHandler;
    SLASH_BUFFWATCH1 = "/buffwatch";
    SLASH_BUFFWATCH2 = "/bfw";

    GroupBuffs.Buff = { };
    GroupBuffs.GroupName = { };

    GroupBuffs.GroupName[1] = "Mage Armor";
    GroupBuffs.Buff["Mage Armor"] = 1;
    GroupBuffs.Buff["Frost Armor"] = 1;
    GroupBuffs.Buff["Ice Armor"] = 1;

    GroupBuffs.GroupName[2] = "Intellect";
    GroupBuffs.Buff["Arcane Intellect"] = 2;
    GroupBuffs.Buff["Arcane Brilliance"] = 2;

    GroupBuffs.GroupName[3] = "Fortitude";
    GroupBuffs.Buff["Power Word: Fortitude"] = 3;
    GroupBuffs.Buff["Prayer of Fortitude"] = 3;

    GroupBuffs.GroupName[4] = "Spirit";
    GroupBuffs.Buff["Divine Spirit"] = 4;
    GroupBuffs.Buff["Prayer of Spirit"] = 4;

    GroupBuffs.GroupName[5] = "Mark of the Wild";
    GroupBuffs.Buff["Mark of the Wild"] = 5;
    GroupBuffs.Buff["Gift of the Wild"] = 5;

    GroupBuffs.GroupName[6] = "Shadow Protection";
    GroupBuffs.Buff["Shadow Protection"] = 6;
    GroupBuffs.Buff["Prayer of Shadow Protection"] = 6;

    GroupBuffs.GroupName[7] = "Might";
    GroupBuffs.Buff["Blessing of Might"] = 7;
    GroupBuffs.Buff["Greater Blessing of Might"] = 7;

    GroupBuffs.GroupName[8] = "Wisdom";
    GroupBuffs.Buff["Blessing of Wisdom"] = 8;
    GroupBuffs.Buff["Greater Blessing of Wisdom"] = 8;

    GroupBuffs.GroupName[9] = "Salvation";
    GroupBuffs.Buff["Blessing of Salvation"] = 9;
    GroupBuffs.Buff["Greater Blessing of Salvation"] = 9;

    GroupBuffs.GroupName[10] = "Kings";
    GroupBuffs.Buff["Blessing of Kings"] = 10;
    GroupBuffs.Buff["Greater Blessing of Kings"] = 10;

    GroupBuffs.GroupName[11] = "Light";
    GroupBuffs.Buff["Blessing of Light"] = 11;
    GroupBuffs.Buff["Greater Blessing of Light"] = 11;

    GroupBuffs.GroupName[12] = "Sanctuary";
    GroupBuffs.Buff["Blessing of Sanctuary"] = 12;
    GroupBuffs.Buff["Greater Blessing of Sanctuary"] = 12;

    GroupBuffs.GroupName[13] = "Flasks";
    GroupBuffs.Buff["Supreme Power"] = 13;
    GroupBuffs.Buff["Flask of the Titans"] = 13;
    GroupBuffs.Buff["Distilled Wisdom"] = 13;
    GroupBuffs.Buff["Chromatic Resistance"] = 13;
    GroupBuffs.Buff["Petrification"] = 13;

    GroupBuffs.GroupName[14] = "Agility Elixirs";
    GroupBuffs.Buff["Elixir of the Mongoose"] = 14;
    GroupBuffs.Buff["Greater Agility"] = 14;

    GroupBuffs.GroupName[15] = "Armor Elixirs";
    GroupBuffs.Buff["Greater Armor"] = 15; -- Elixir of Superior Defense
    GroupBuffs.Buff["Armor"] = 15; -- Elixir of Greater Defense / Elixir of Defense / Scroll of Protection

    GroupBuffs.Group = { };

    -- Transform all the GroupBuffs.Buffs into their respective GroupBuffs.Groups
    --  which we can iterate through to check for a replacement
    for k, v in pairs(GroupBuffs.Buff) do

        if GroupBuffs.Group[v] == nil then
            GroupBuffs.Group[v] = { };
        end

        table.insert(GroupBuffs.Group[v], k);

    end

end

function BUFFWATCHADDON_G.OnEvent(self, event, ...)
--[[
if event ~= "ADDON_LOADED" or select(1, ...) == addonName then
    BUFFWATCHADDON.Debug("Event "..event.." fired. Vars :");
    for i = 1, select("#", ...) do
        BUFFWATCHADDON.Debug("i="..i..", v="..select(i, ...));
    end
end
]]

    -- Set default values, if unset
    if event == "ADDON_LOADED" and select(1, ...) == addonName then
        -- Check version and setup config
        BUFFWATCHADDON.VersionCheck();
        BUFFWATCHADDON.Options_Init();
    end

    if event == "PLAYER_LOGIN" then
        -- Ensure correct repositioning and anchoring of the frame
        BUFFWATCHADDON.SetPoint(BuffwatchFrame, BUFFWATCHADDON.ANCHORPOINT_DROPDOWN_MAP[BuffwatchPlayerConfig.AnchorPoint], BuffwatchPlayerConfig.AnchorX, BuffwatchPlayerConfig.AnchorY);
        BUFFWATCHADDON.framePositioned = true;

        -- Look for a chatframe called 'BWDebug' on login for sending debug messsages to
        local windowname;

        for i = 1, 10 do
            windowname = GetChatWindowInfo(i);
            if windowname and windowname == "BWDebug" then
                debugchatframe = _G["ChatFrame"..i];
                break;
            end
        end

        local LibClassicDurations, libversion = LibStub("LibClassicDurations", true);
        if LibClassicDurations then
            if libversion >= 18 then
                LibClassicDurations:Register(addonName);
                UnitAura = LibClassicDurations.UnitAuraWrapper;
            else
                BUFFWATCHADDON.Print("Buffwatch requires LibClassicDurations version 1.8 or newer. Other player cooldown spirals will not be shown.");
            end
        end

    end

    if event == "PLAYER_REGEN_ENABLED" then
        BuffwatchFrame_HeaderCombatIcon:Hide();
        BuffwatchFrame_LockAll:Show();
    elseif event == "PLAYER_REGEN_DISABLED" then
        BuffwatchFrame_HeaderCombatIcon:Show();
        BuffwatchFrame_LockAll:Hide();
    end

    if BuffwatchFrame_PlayerFrame:IsVisible() then

        if event == "PLAYER_LOGIN" or event == "GROUP_ROSTER_UPDATE"
            or (event == "UNIT_PET" and BuffwatchPlayerConfig.ShowPets == true) then

            BUFFWATCHADDON.Set_UNIT_IDs();
            BUFFWATCHADDON.ResizeWindow();

            if event == "PLAYER_LOGIN" then
                -- Check the 'Check All' checkbox, if all players are now locked
                if BUFFWATCHADDON.InspectPlayerLocks() then
                    BuffwatchFrame_LockAll:SetChecked(true);
                end

                BUFFWATCHADDON.HideUnmonitored(nil, BuffwatchPlayerConfig.HideUnmonitored);
                BUFFWATCHADDON.SetMinimized(nil, BuffwatchPlayerConfig.Minimized);

                initialSetupComplete = true;
            end

        elseif event == "UNIT_AURA" and UNIT_IDs_Keyed[select(1, ...)] ~= nil then

            -- Someone gained or lost a buff
            local player = Player_Info[UnitName(select(1, ...))];

            if player ~= nil then
                BUFFWATCHADDON.Player_GetBuffs(player);
                BUFFWATCHADDON.ResizeWindow();
            end

        elseif event == "UNIT_INVENTORY_CHANGED" and UnitIsUnit(select(1, ...), "player") then

            -- Check if player gained or lost a temporary enchant
            local player = Player_Info[UnitName("player")];

            if player ~= nil then
                BUFFWATCHADDON.Player_GetTemporaryEnchants(player);
                BUFFWATCHADDON.ResizeWindow();
            end

        elseif event == "PLAYER_REGEN_ENABLED" then

            -- We have come out of combat, remove combat restrictions and process any pending events
            for _, v in pairs(Player_Info) do
                local curr_lock = _G["BuffwatchFrame_PlayerFrame" .. v.ID .. "_Lock"];
                curr_lock:Enable();
            end

            BUFFWATCHADDON.Process_InCombat_Events();

        elseif event == "PLAYER_REGEN_DISABLED" then

            -- We have entered combat, enforce combat restrictions
            for _, v in pairs(Player_Info) do
                local curr_lock = _G["BuffwatchFrame_PlayerFrame" .. v.ID .. "_Lock"];
                curr_lock:Disable();
            end

        -- UNIT_FLAGS fires for group members dying and ressing,
        --   however it only fires for the player when they die, get ressurected by another player
        --   and when they release to ghost form, but not when they unghost.
        -- We can use PLAYER_FLAGS_CHANGED or PLAYER_UNGHOST for when they unghost
        elseif (event == "UNIT_FLAGS" or event == "PLAYER_FLAGS_CHANGED") and UNIT_IDs_Keyed[select(1, ...)] ~= nil then

            local player = Player_Info[UnitName(select(1, ...))];

            if player ~= nil then

                local DeadorDC = 0;

                if UnitIsDeadOrGhost(player.UNIT_ID) or UnitIsConnected(player.UNIT_ID) == false then
                    DeadorDC = 1;
                end

                if DeadorDC ~= player.DeadorDC then
                    player.DeadorDC = DeadorDC;
                    BUFFWATCHADDON.Player_ColourName(player);
                    BUFFWATCHADDON.Player_GetBuffs(player);
                    BUFFWATCHADDON.Player_GetTemporaryEnchants(player);
                end

            end

        end

    end

end

function BUFFWATCHADDON_G.MouseDown(self, button)
    if button == "LeftButton" and BuffwatchPlayerConfig.WindowLocked == false then
        self:StartMoving();
    end
end

function BUFFWATCHADDON_G.MouseUp(self, button)
    if button == "LeftButton" then
        self:StopMovingOrSizing();
        -- Save new X and Y position
        BUFFWATCHADDON.GetPoint(BuffwatchFrame, BUFFWATCHADDON.ANCHORPOINT_DROPDOWN_MAP[BuffwatchPlayerConfig.AnchorPoint]);
    end
end

function BUFFWATCHADDON_G.Set_AllChecks(checked)

    -- Toggle all checkboxes on or off
    for _, v in pairs(Player_Info) do

        local curr_lock = _G["BuffwatchFrame_PlayerFrame" .. v.ID .. "_Lock"];

        if curr_lock:GetChecked() ~= checked then
            curr_lock:SetChecked(checked);

            -- Show or Hide any frames affected by the HideUnmonitored flag
            if BuffwatchPlayerConfig.HideUnmonitored and (next(BuffwatchPlayerBuffs[v.Name]["Buffs"], nil) == nil) then
                BUFFWATCHADDON.PositionPlayerFrame(v.ID);
                BUFFWATCHADDON.ResizeWindow();
            end

            if not checked then
                -- Unchecked, so refresh buff list
                BUFFWATCHADDON.Player_GetBuffs(v);
                BUFFWATCHADDON.Player_GetTemporaryEnchants(v);
            else
                -- Checked, so save buff list
                BuffwatchSaveBuffs[v.Name] = { };
                BuffwatchSaveBuffs[v.Name]["Buffs"] = BuffwatchPlayerBuffs[v.Name]["Buffs"];

                if v.IsUnitPlayer then
                    BuffwatchSaveTempEnch = BuffwatchPlayerTempEnch;
                end

            end

        end

    end

    -- If we have unchecked anything, then we will probably have to resize the window
    if not checked then
        BUFFWATCHADDON.ResizeWindow();
    end

end

function BUFFWATCHADDON_G.Header_Clicked(button, down)

    -- Show the dropdown menu
    if button == "RightButton" then
        ToggleDropDownMenu(1, nil, BuffwatchFrame_HeaderDropDown, "BuffwatchFrame_Header", 40, 0);
    end

end

function BUFFWATCHADDON_G.HeaderDropDown_OnLoad(self)
    -- Prepare the dropdown menu
    UIDropDownMenu_Initialize(self, BUFFWATCHADDON.Buffwatch_HeaderDropDown_Initialize, "MENU");
    UIDropDownMenu_SetAnchor(self, 0, 0, "TOPLEFT", "BuffwatchFrame_Header", "CENTER");
end

function BUFFWATCHADDON.Buffwatch_HeaderDropDown_Initialize()

    -- Add items to the dropdown menu
    dropdowninfo.text = "Lock Window";
    dropdowninfo.notCheckable = false;
    dropdowninfo.checked = BuffwatchPlayerConfig.WindowLocked;
    dropdowninfo.func = function()
        BuffwatchPlayerConfig.WindowLocked = not BuffwatchPlayerConfig.WindowLocked;
    end
    UIDropDownMenu_AddButton(dropdowninfo);

    dropdowninfo.text = "Refresh";
    dropdowninfo.checked = nil;
    dropdowninfo.notCheckable = true;
    dropdowninfo.func = function()
        BUFFWATCHADDON.GetPlayerInfo();
        BUFFWATCHADDON.GetAllBuffs();
    end
    UIDropDownMenu_AddButton(dropdowninfo);

    dropdowninfo.text = "Options";
    dropdowninfo.func = BUFFWATCHADDON_G.OptionsToggle;
    UIDropDownMenu_AddButton(dropdowninfo);

    dropdowninfo.text = "Help";
    dropdowninfo.func = BUFFWATCHADDON_G.ShowHelp;
    UIDropDownMenu_AddButton(dropdowninfo);

    dropdowninfo.text = "Close Buffwatch";
    dropdowninfo.func = BUFFWATCHADDON_G.Toggle;
    UIDropDownMenu_AddButton(dropdowninfo);

    dropdowninfo.disabled = 1;
    dropdowninfo.text = nil;
    dropdowninfo.func = nil;
    UIDropDownMenu_AddButton(dropdowninfo);

    dropdowninfo.disabled = nil;
    dropdowninfo.text = "Close Menu";
    dropdowninfo.func = function()
        BuffwatchFrame_HeaderDropDown:Hide();
    end
    UIDropDownMenu_AddButton(dropdowninfo);

end

function BUFFWATCHADDON_G.MinimizeButton_Clicked(self)

    if InCombatLockdown() then

        BUFFWATCHADDON.Print("Cannot hide or show buffs while in combat.");

    else

        BuffwatchPlayerConfig.Minimized = not BuffwatchPlayerConfig.Minimized;
        BUFFWATCHADDON.SetMinimized(self, BuffwatchPlayerConfig.Minimized);

    end

end

function BUFFWATCHADDON_G.MinimizeButton_Enter(self)

    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    if BuffwatchPlayerConfig.Minimized then
        GameTooltip:SetText("Max");
    else
        GameTooltip:SetText("Min");
    end

end

function BUFFWATCHADDON_G.HideButton_Clicked(self)

    if InCombatLockdown() then

        BUFFWATCHADDON.Print("Cannot hide or show buffs while in combat.");

    else

        BuffwatchPlayerConfig.HideUnmonitored = not BuffwatchPlayerConfig.HideUnmonitored;
        BUFFWATCHADDON.HideUnmonitored(self, BuffwatchPlayerConfig.HideUnmonitored);

    end

end

function BUFFWATCHADDON_G.HideButton_Enter(self)

    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    if BuffwatchPlayerConfig.HideUnmonitored then
        GameTooltip:SetText("Show All");
    else
        GameTooltip:SetText("Hide Unmonitored");
    end

end

function BUFFWATCHADDON_G.Check_Clicked(self, button, down)

    local playerid = self:GetParent():GetID();
    local checked = self:GetChecked();
    local playername = _G["BuffwatchFrame_PlayerFrame"..playerid.."_NameText"]:GetText();
    local player = Player_Info[playername];

    if checked then

        -- Checked, so save buff list
        BuffwatchSaveBuffs[playername] = { };
        BuffwatchSaveBuffs[playername]["Buffs"] = BuffwatchPlayerBuffs[playername]["Buffs"];

        if player.IsUnitPlayer then
            BuffwatchSaveTempEnch = BuffwatchPlayerTempEnch;
        end

        -- Check the 'Check All' checkbox, if all players are now locked
        if BUFFWATCHADDON.InspectPlayerLocks() then
            BuffwatchFrame_LockAll:SetChecked(true);
        end

        -- Hide any frames affected by the HideUnmonitored flag
        if BuffwatchPlayerConfig.HideUnmonitored and (next(BuffwatchPlayerBuffs[playername]["Buffs"], nil) == nil) then
            BUFFWATCHADDON.PositionPlayerFrame(playerid);
            BUFFWATCHADDON.ResizeWindow();
        end

    else
        -- Unchecked, so refresh buff list
        BuffwatchFrame_LockAll:SetChecked(false);
        BUFFWATCHADDON.Player_GetBuffs(player);
        BUFFWATCHADDON.Player_GetTemporaryEnchants(player);
        BUFFWATCHADDON.ResizeWindow();
    end

end

function BUFFWATCHADDON_G.Buff_Clicked(self, button, down)

    local playerid = self:GetParent():GetID();
    local playerframe = "BuffwatchFrame_PlayerFrame"..playerid;

    if _G[playerframe.."_Lock"]:GetChecked() and IsAltKeyDown() then

        if InCombatLockdown() then

            BUFFWATCHADDON.Print("Cannot hide buffs while in combat.");

        else

            local buffid = self:GetID();
            local playername = _G[playerframe.."_NameText"]:GetText();

            if button == "LeftButton" then

                -- Hide all but the clicked buff and adjust positions
                for i = 1, maxBuffCount do
                    local curr_buff = _G[playerframe.."_Buff"..i];
                    if curr_buff then
                        if i ~= buffid then
                            curr_buff:Hide();
                            BuffwatchPlayerBuffs[playername]["Buffs"][i] = nil;
                        else
                            self:SetPoint("TOPLEFT", playerframe.."_Name", "TOPLEFT", maxnamewidth + 5, 4);
                        end
                    else
                        break;
                    end
                end

                -- Temporary Enchants are always shown last, so just hide them
                if Player_Info[playername].IsUnitPlayer then
                    if BUFFWATCHADDON.GetLen(BuffwatchPlayerTempEnch) > 0 then
                        for i = 1, 3 do
                            local curr_buff = _G[playerframe.."_TemporaryEnchant"..i];
                            if curr_buff then
                                curr_buff:Hide();
                                BuffwatchPlayerTempEnch[i] = nil;
                            end
                        end
                    end

                    BuffwatchSaveTempEnch = { };

                end

                BuffwatchSaveBuffs[playername]["Buffs"] = BuffwatchPlayerBuffs[playername]["Buffs"];

                BUFFWATCHADDON.ResizeWindow();

            elseif button == "RightButton" then

                local nextbuffid = next(BuffwatchPlayerBuffs[playername]["Buffs"], buffid);

                -- Hide the clicked buff
                self:Hide();
                BuffwatchPlayerBuffs[playername]["Buffs"][buffid] = nil;
                BuffwatchSaveBuffs[playername]["Buffs"][buffid] = nil;

                -- Re-anchor any following buff
                if nextbuffid then
                    local curr_buff = _G[playerframe.."_Buff"..nextbuffid];
                    curr_buff:ClearAllPoints();
                    curr_buff:SetPoint(self:GetPoint());
                elseif Player_Info[playername].IsUnitPlayer then
                    -- Last buff, check for Temp Enchants and re-anchor first
                    local firsttempenchid = next(BuffwatchPlayerTempEnch, nil);
                    if firsttempenchid then
                        local curr_buff = _G[playerframe.."_TemporaryEnchant"..firsttempenchid];
                        curr_buff:ClearAllPoints();
                        curr_buff:SetPoint(self:GetPoint());
                    end
                end

                if BuffwatchPlayerConfig.HideUnmonitored then
                    if _G[playerframe.."_Lock"]:GetChecked() and next(BuffwatchPlayerBuffs[playername]["Buffs"], nil) == nil then
                        BUFFWATCHADDON.PositionPlayerFrame(playerid);
                    end
                end

                BUFFWATCHADDON.ResizeWindow();

            end

        end
--[[
    else

if BuffwatchConfig.debug == true then
local buffid = self:GetID();
local playername = _G[playerframe.."_NameText"]:GetText();
local curr_buff = _G[playerframe.."_Buff"..buffid];

BUFFWATCHADDON.Debug("Casting spell :");
BUFFWATCHADDON.Debug("Array : Player="..playername..", Buff="..BuffwatchPlayerBuffs[playername]["Buffs"][buffid]["Buff"]);
BUFFWATCHADDON.Debug("Attribute : Player="..UnitName(curr_buff:GetAttribute("unit1"))..", Buff="..curr_buff:GetAttribute("spell1"));
end ]]
    end
end

function BUFFWATCHADDON_G.TemporaryEnchant_Clicked(self, button, down)

    local playerid = self:GetParent():GetID();
    local playerframe = "BuffwatchFrame_PlayerFrame"..playerid;

    if _G[playerframe.."_Lock"]:GetChecked() and IsAltKeyDown() then

        if InCombatLockdown() then

            BUFFWATCHADDON.Print("Cannot hide buffs while in combat.");

        else

            local buffid = self:GetID();
            local playername = _G[playerframe.."_NameText"]:GetText();

            if button == "LeftButton" then

                -- Hide all normal buffs
                for i = 1, maxBuffCount do
                    local curr_buff = _G[playerframe.."_Buff"..i];
                    if curr_buff then
                        curr_buff:Hide();
                        BuffwatchPlayerBuffs[playername]["Buffs"][i] = nil;
                    else
                        break;
                    end
                end

                -- Hide all but the clicked temporary enchant, and adjust positions
                for i = 1, 3 do
                    local curr_buff = _G[playerframe.."_TemporaryEnchant"..i];
                    if curr_buff then
                        if i ~= buffid then
                            curr_buff:Hide();
                            BuffwatchPlayerTempEnch[i] = nil;
                        else
                            self:SetPoint("TOPLEFT", playerframe.."_Name", "TOPLEFT", maxnamewidth + 5, 4);
                        end
                    end
                end

                BuffwatchSaveBuffs[playername]["Buffs"] = BuffwatchPlayerBuffs[playername]["Buffs"];
                BuffwatchSaveTempEnch = BuffwatchPlayerTempEnch;

                BUFFWATCHADDON.ResizeWindow();

            elseif button == "RightButton" then

                local nextbuffid = next(BuffwatchPlayerTempEnch, buffid);

                -- Hide the clicked buff
                self:Hide();
                BuffwatchPlayerTempEnch[buffid] = nil;

                -- Re-anchor any following buff
                if nextbuffid then
                    _G[playerframe.."_TemporaryEnchant"..nextbuffid]:ClearAllPoints();
                    _G[playerframe.."_TemporaryEnchant"..nextbuffid]:SetPoint(self:GetPoint());
                end

                if BuffwatchPlayerConfig.HideUnmonitored then
                    if _G[playerframe.."_Lock"]:GetChecked()
                        and next(BuffwatchPlayerBuffs[playername]["Buffs"], nil) == nil
                        and next(BuffwatchPlayerTempEnch, nil) == nil then

                        BUFFWATCHADDON.PositionPlayerFrame(playerid);
                    end
                end

                BUFFWATCHADDON.ResizeWindow();

            end

        end

    end

end

function BUFFWATCHADDON_G.Buff_Tooltip(self)

    local playername = _G["BuffwatchFrame_PlayerFrame"..self:GetParent():GetID().."_NameText"]:GetText();
    local unit = Player_Info[playername]["UNIT_ID"];
    local buff = BuffwatchPlayerBuffs[playername]["Buffs"][self:GetID()]["Buff"];
    local rank = BuffwatchPlayerBuffs[playername]["Buffs"][self:GetID()]["Rank"];

    local buffbuttonid = BUFFWATCHADDON.UnitHasBuff(unit, buff, rank);

    if buffbuttonid ~= 0 then

        -- If the buff is present, show the tooltip for it
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
        GameTooltip:SetUnitBuff(unit, buffbuttonid);
        if rank then
            GameTooltip:AddLine(rank, 1, 0.82, 0);
        end

    else

        -- If the buff isn't present, create a tooltip
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
        if rank then
            GameTooltip:SetText(buff.." ("..rank..")", 1, 0.82, 0);
        else
            GameTooltip:SetText(buff, 1, 0.82, 0);
        end

    end

    local castername = BuffwatchPlayerBuffs[playername]["Buffs"][self:GetID()]["CasterName"];
    if castername then

        if Player_Info[castername] then
            local class = Player_Info[castername]["Class"];
            if class and class ~= "" then
                castername = RAID_CLASS_COLORS[class]:WrapTextInColorCode(castername);
            end
        end

        GameTooltip:AddLine("Caster: "..castername, 0.2, 1, 0.2);
    end

    if GroupBuffs.Buff[buff] ~= nil then
        GameTooltip:AddLine("Group: "..GroupBuffs.GroupName[GroupBuffs.Buff[buff]], 0.2, 1, 0.2);
    end

    GameTooltip:Show();
end

function BUFFWATCHADDON_G.TemporaryEnchant_Tooltip(self)

    local i = self:GetID();
    local tempenchants = { GetWeaponEnchantInfo() };

    if tempenchants[4 * (i - 1) + 1] == true then
        -- If the temporary enchant is present, show the tooltip for it
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
        GameTooltip:SetInventoryItem("player", tempEnchantMapping[i]);
    else
        -- If the buff isn't present, create a tooltip
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT");
        GameTooltip:SetText(BuffwatchPlayerTempEnch[i]["Buff"], 1, 1, 0);
    end

end

-- ****************************************************************************
-- **                                                                        **
-- **  Main Functions                                                        **
-- **                                                                        **
-- ****************************************************************************

function BUFFWATCHADDON.SlashHandler(msg)

    msg = string.lower(msg);

    if msg == "toggle" then

        BUFFWATCHADDON_G.Toggle();

    elseif msg == "options" then

        BUFFWATCHADDON_G.OptionsToggle();

    elseif msg == "debug" then

        BuffwatchConfig.debug = not BuffwatchConfig.debug;

        if BuffwatchConfig.debug == true then
            BUFFWATCHADDON.Print("Buffwatch debugging ON");
        else
            BUFFWATCHADDON.Print("Buffwatch debugging OFF");
        end

    elseif msg == "help" then

        BUFFWATCHADDON_G.ShowHelp();

    elseif msg == "reset" then

        BuffwatchFrame:ClearAllPoints();
        BuffwatchFrame:SetPoint("CENTER", 200, 200);

    else

        BUFFWATCHADDON.Print("Buffwatch commands (/buffwatch or /bfw):");
        BUFFWATCHADDON.Print("/bfw help - Show the help page");
        BUFFWATCHADDON.Print("/bfw toggle - Toggle the Buffwatch window on or off");
        BUFFWATCHADDON.Print("/bfw options - Toggle the options window on or off");
        BUFFWATCHADDON.Print("/bfw reset - Reset the window position");
        BUFFWATCHADDON.Print("Right click the Buffwatch header for more options");

    end

end

-- Config changes :
--  1.00 -- First version, none as yet!
function BUFFWATCHADDON.VersionCheck()

    if BuffwatchConfig.Version == BUFFWATCHADDON.VERSION then
        -- Nothing to do
    else

        BUFFWATCHADDON.CopyDefaults(BUFFWATCHADDON.DEFAULTS, BuffwatchConfig);

        BuffwatchConfig.Version = BUFFWATCHADDON.VERSION;

    end

    if BuffwatchPlayerConfig.Version == BUFFWATCHADDON.VERSION then
        -- Nothing to do
    else

        BUFFWATCHADDON.CopyDefaults(BUFFWATCHADDON.PLAYER_DEFAULTS, BuffwatchPlayerConfig);

        BuffwatchPlayerConfig.Version = BUFFWATCHADDON.VERSION;
    end

end

-- Setup basic list of possible UNIT_IDs
function BUFFWATCHADDON.Set_UNIT_IDs(forced)

    if BuffwatchPlayerConfig.Mode == BUFFWATCHADDON.MODE_DROPDOWN_LIST[1] then  -- "Solo"

        UNIT_IDs = table.wipe(UNIT_IDs);
        UNIT_IDs_Keyed = table.wipe(UNIT_IDs_Keyed);

        UNIT_IDs[1] = "player";
        UNIT_IDs_Keyed["player"] = 1;

        if BuffwatchPlayerConfig.ShowPets == true then
            UNIT_IDs[2] = "pet";
            UNIT_IDs_Keyed["pet"] = 2;
        end

        grouptype = "solo";

    else

        if GetNumGroupMembers() > 5 and BuffwatchPlayerConfig.Mode == BUFFWATCHADDON.MODE_DROPDOWN_LIST[3] then  -- "Raid"

            if grouptype ~= "raid" or forced == true then

                UNIT_IDs = table.wipe(UNIT_IDs);
                UNIT_IDs_Keyed = table.wipe(UNIT_IDs_Keyed);

                for i = 1, 40 do
                    UNIT_IDs[i] = "raid"..i;
                    UNIT_IDs_Keyed["raid"..i] = i;
                end

                if BuffwatchPlayerConfig.ShowPets == true then
                    for i = 1, 40 do
                        UNIT_IDs[i+40] = "raidpet"..i;
                        UNIT_IDs_Keyed["raidpet"..i] = i+40;
                    end
                end

                grouptype = "raid";

            end

        elseif grouptype ~= "party" or forced == true then

            --UNIT_IDs = { };
            UNIT_IDs = table.wipe(UNIT_IDs);
            UNIT_IDs_Keyed = table.wipe(UNIT_IDs_Keyed);

            UNIT_IDs[1] = "player";
            UNIT_IDs[2] = "party1";
            UNIT_IDs[3] = "party2";
            UNIT_IDs[4] = "party3";
            UNIT_IDs[5] = "party4";
            UNIT_IDs_Keyed["player"] = 1;
            UNIT_IDs_Keyed["party1"] = 2;
            UNIT_IDs_Keyed["party2"] = 3;
            UNIT_IDs_Keyed["party3"] = 4;
            UNIT_IDs_Keyed["party4"] = 5;

            if BuffwatchPlayerConfig.ShowPets == true then
                UNIT_IDs[6] = "pet";
                UNIT_IDs[7] = "partypet1";
                UNIT_IDs[8] = "partypet2";
                UNIT_IDs[9] = "partypet3";
                UNIT_IDs[10] = "partypet4";
                UNIT_IDs_Keyed["pet"] = 6;
                UNIT_IDs_Keyed["partypet1"] = 7;
                UNIT_IDs_Keyed["partypet2"] = 8;
                UNIT_IDs_Keyed["partypet3"] = 9;
                UNIT_IDs_Keyed["partypet4"] = 10;
            end

            grouptype = "party";

        end

    end

    BUFFWATCHADDON.GetPlayerInfo();

end

--[[ Get details of each player we find in the UNIT_IDs list

    Player_Info[Name] props :

    ID - Unique number for this player, determines which playerframe to use
    UNIT_ID - UNIT_ID of this player
    Name - Players name (same as key, but useful if we are just looping array)
    Class - Players Class (for colouring name and sorting)
    IsPet - true if a pet (pets are sorted last, and can be hidden)
    SubGroup - 1 if in party, or 1-8 if in raid (Used for sorting)
    DeadorDC - For greying out player frames if dead or disconnected
    LastBuffId - Last visible buffbuttonid for attaching Temp Enchant buffbuttons
    IsUnitPlayer - Is this our player
    Checked - Used only in this function to determine players that are no longer present
]]--
function BUFFWATCHADDON.GetPlayerInfo()

    if InCombatLockdown() then

        BUFFWATCHADDON.Add_InCombat_Events({"GetPlayerInfo"});

    else

        local getnewalignpos = false;
        local positionframe;
        local foundunknownunit = false;

        for i = 1, #UNIT_IDs do

            local unitname = UnitName(UNIT_IDs[i]);

            positionframe = false;

            if unitname ~= nil and unitname ~= "Unknown" then

                -- Check if we know about this person already, if not capture basic details
                if not Player_Info[unitname] then

                    local id = BUFFWATCHADDON.GetNextID(unitname);

                    -- Check if frame has been created
                    if not _G["BuffwatchFrame_PlayerFrame"..id] then

                        local f = CreateFrame("Frame", "BuffwatchFrame_PlayerFrame"..id,
                            BuffwatchFrame_PlayerFrame, "Buffwatch_Player_Template");
                        f:SetID(id);

                    end

                    Player_Info[unitname] = { };
                    Player_Info[unitname]["ID"] = id;
                    Player_Info[unitname]["Name"] = unitname;

                    local _, classname = UnitClass(UNIT_IDs[i]);

                    if classname then
                        Player_Info[unitname]["Class"] = classname;
                    else
                        Player_Info[unitname]["Class"] = "";
                    end

                    if (grouptype == "party" and i > 5) or (grouptype == "raid" and i > 40) or (grouptype == "solo" and i == 2) then
                        Player_Info[unitname]["IsPet"] = 1;
                        Player_Info[unitname]["Class"] = "";
                    else
                        Player_Info[unitname]["IsPet"] = 0;
                    end

                    if UnitIsDeadOrGhost(UNIT_IDs[i]) or UnitIsConnected(UNIT_IDs[i]) == false then
                        Player_Info[unitname]["DeadorDC"] = 1;
                    else
                        Player_Info[unitname]["DeadorDC"] = 0;
                    end

                    local namebutton = _G["BuffwatchFrame_PlayerFrame"..id.."_Name"];
                    local nametext = _G["BuffwatchFrame_PlayerFrame"..id.."_NameText"];

                    nametext:SetText(unitname);
                    namebutton:SetWidth(nametext:GetStringWidth());

                    -- If this is now the longest name, reset the buff button alignment
                    if maxnamewidth < nametext:GetStringWidth() then
                        maxnamewidth = nametext:GetStringWidth();
                        maxnameid = id;
                        BUFFWATCHADDON.SetBuffAlignment();
                    end

                    Player_Info[unitname]["UNIT_ID"] = UNIT_IDs[i];
                    if UnitIsUnit(UNIT_IDs[i], "player") then
                        Player_Info[unitname]["IsUnitPlayer"] = true;
                    end

                    -- Setup left and right click actions on the name button
                    namebutton:SetAttribute("type1", "target");
                    namebutton:SetAttribute("type2", "assist");
                    namebutton:SetAttribute("unit", UNIT_IDs[i]);

                    BUFFWATCHADDON.Player_ColourName(Player_Info[unitname]);

                    if not BuffwatchPlayerBuffs[unitname] then
                        BuffwatchPlayerBuffs[unitname] = { };
                        BuffwatchPlayerBuffs[unitname]["Buffs"] = { };
                        BUFFWATCHADDON.Player_LoadBuffs(Player_Info[unitname]);
                        BUFFWATCHADDON.Player_GetBuffs(Player_Info[unitname]);
                        BUFFWATCHADDON.Player_GetTemporaryEnchants(Player_Info[unitname]);
                    end

                    positionframe = true;

                end

                -- Update any information that may have changed about this person,
                --    whether we captured before, or are taking for first time
                if Player_Info[unitname]["UNIT_ID"] ~= UNIT_IDs[i] then

                    -- UNIT_ID has changed, so update secure button attributes
                    local namebutton = _G["BuffwatchFrame_PlayerFrame"..Player_Info[unitname]["ID"].."_Name"];

                    Player_Info[unitname]["UNIT_ID"] = UNIT_IDs[i];
                    namebutton:SetAttribute("unit", UNIT_IDs[i]);

                    for j = 1, maxBuffCount do
                        local curr_buff = _G["BuffwatchFrame_PlayerFrame"..Player_Info[unitname]["ID"].."_Buff"..j];

                        if curr_buff then
                            if curr_buff:IsShown() then
                                curr_buff:SetAttribute("unit1", UNIT_IDs[i]);
                            end
                        else
                            break;
                        end
                    end

                end

                if grouptype == "raid" then
                    local j = math.fmod(i, 40);
                    if j == 0 then j = 40 end;
                    local _, _, subgroup = GetRaidRosterInfo(j);

                    if subgroup ~= Player_Info[unitname]["SubGroup"] then
                        Player_Info[unitname]["SubGroup"] = subgroup;
                        if BuffwatchPlayerConfig.SortOrder == BUFFWATCHADDON.SORTORDER_DROPDOWN_LIST[1] then  -- "Raid Order"
                            positionframe = true;
                        end
                    end
                else
                    Player_Info[unitname]["SubGroup"] = 1;
                end

                Player_Info[unitname]["Checked"] = 1;

            elseif (unitname == "Unknown") then
                foundunknownunit = true;
            end

            if positionframe == true then
--BUFFWATCHADDON.Debug("Showing player frame "..Player_Info[unitname].ID.." for "..unitname);
                BUFFWATCHADDON.PositionPlayerFrame(Player_Info[unitname].ID);
            end

        end

        -- A unit wasn't fully loaded into the game yet, make a callback to try again
        if foundunknownunit == true then
--BUFFWATCHADDON.Debug("Found an unknown unit, firing off a refresh in 5sec...");
            BUFFWATCHADDON.Wait(5, BUFFWATCHADDON.GetPlayerInfo);
            BUFFWATCHADDON.Wait(5, BUFFWATCHADDON.ResizeWindow);
        end

        -- Remove players that are no longer in the group
        for k, v in pairs(Player_Info) do

            if v.Checked == 1 then
                v.Checked = 0;
            else

                if v.ID == maxnameid then
                    getnewalignpos = true;
                end

                -- Add ID to temp array in case they come back
                -- (useful for dismissed or dead pets, or if a player leaves group briefly)
                Player_Left[v.Name] = v.ID;
                Player_Info[k] = nil;
                BuffwatchPlayerBuffs[k] = nil;

--BUFFWATCHADDON.Debug("Hiding player frame "..v.ID.." for "..v.Name);
                BUFFWATCHADDON.PositionPlayerFrame(v.ID);

            end

        end

        if getnewalignpos == true then

            maxnamewidth = 0;

            for _, v in pairs(Player_Info) do

                local nametext = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_NameText"];

                if maxnamewidth < nametext:GetStringWidth() then
                    maxnamewidth = nametext:GetStringWidth();
                    maxnameid = v.ID;
                end

            end

            BUFFWATCHADDON.SetBuffAlignment();

        end

    end

end

function BUFFWATCHADDON.PositionAllPlayerFrames()

    BUFFWATCHADDON.GetPlayerSortOrder();

    for _, v in ipairs(Player_Order) do
        BUFFWATCHADDON.PositionPlayerFrame(v.ID);
    end

end

function BUFFWATCHADDON.PositionPlayerFrame(playerid)

    local playerframe = _G["BuffwatchFrame_PlayerFrame"..playerid];
    local arraypos;
    local fpos;
    local playerdata;

    -- Find playerframe in current order
    for i, v in ipairs(Current_Order) do

        if playerid == v.ID then
            arraypos = i;
            break;
        end

    end

    -- See if there is a frame attached to this one
    if arraypos and Current_Order[arraypos+1] then

        local nextplayer = _G["BuffwatchFrame_PlayerFrame"..Current_Order[arraypos+1].ID];

        -- Remove next frame from order and reattach it to where our player frame was attached
        if nextplayer then
            nextplayer:ClearAllPoints();
            nextplayer:SetPoint(playerframe:GetPoint());
        end

    end

    -- Unattach our player frame, and remove from our current order list
    playerframe:ClearAllPoints();

    if arraypos then
        table.remove(Current_Order, arraypos);
    end

    -- Find out where our player frame should now sit in the order
    fpos, playerdata = BUFFWATCHADDON.GetPlayerFramePosition(playerid);

    -- Insert frame into new order if it should be visible (ie. hide it if it is locked with no buffs and HideUnmonitored is set)
    if fpos and (not BuffwatchPlayerConfig.HideUnmonitored or not _G["BuffwatchFrame_PlayerFrame"..playerid.."_Lock"]:GetChecked()
        or next(BuffwatchPlayerBuffs[playerdata.Name]["Buffs"], nil) ~= nil
        or (playerdata.IsUnitPlayer and next(BuffwatchPlayerTempEnch, nil) ~= nil)) then

        -- Insert back into current order in new position
        table.insert(Current_Order, fpos,  playerdata);

        -- Reattach into player frames in new position
        if fpos == 1 then

            -- Player frame is first so attach to parent frame
            playerframe:SetPoint("TOPLEFT", BuffwatchFrame_PlayerFrame);

        else

            -- Attach to previous frame in order
            playerframe:SetPoint("TOPLEFT", "BuffwatchFrame_PlayerFrame"..Current_Order[fpos-1].ID, "BOTTOMLEFT");

        end

        -- Reattach next frame in order to our player frame, if there is one
        if Current_Order[fpos+1] then

            local nextplayer = _G["BuffwatchFrame_PlayerFrame"..Current_Order[fpos+1].ID];

            if nextplayer then
                nextplayer:ClearAllPoints();
                nextplayer:SetPoint("TOPLEFT", playerframe, "BOTTOMLEFT");
            end

        end

        playerframe:Show();

    else

        playerframe:Hide();

        -- If the LockAll checkbox is unchecked and the player we are hiding was unchecked, check whether all players are now checked
        if not BuffwatchFrame_LockAll:GetChecked() and not _G["BuffwatchFrame_PlayerFrame"..playerid.."_Lock"]:GetChecked() then

            -- Check the 'Check All' checkbox, if all players are now locked
            if BUFFWATCHADDON.InspectPlayerLocks() then
                BuffwatchFrame_LockAll:SetChecked(true);
            end

        end

    end

end

function BUFFWATCHADDON.GetPlayerFramePosition(playerid)

    local hiddencount = 0;

    BUFFWATCHADDON.GetPlayerSortOrder();

    for i, v in ipairs(Player_Order) do

        if BuffwatchPlayerConfig.HideUnmonitored then

            -- Adjust final player count, if any frames are hidden
            if _G["BuffwatchFrame_PlayerFrame"..v.ID.."_Lock"]:GetChecked()
                and next(BuffwatchPlayerBuffs[v.Name]["Buffs"], nil) == nil
                and next(BuffwatchPlayerTempEnch, nil) == nil then

                hiddencount = hiddencount + 1;
            end

        end

        if playerid == v.ID then

            -- Return adjusted player frame position with player data
            return (i - hiddencount), v;

        end

    end

end

function BUFFWATCHADDON.GetPlayerSortOrder()

    -- Only bother to sort player frames if we can see them, but always sort during the initial addon setup
    if not BuffwatchPlayerConfig.Minimized or initialSetupComplete == false then

        --Player_Order = { };
        Player_Order = table.wipe(Player_Order);

        for _, v in pairs(Player_Info) do
            table.insert(Player_Order, v);
        end

        -- Sort the player list in temp array
        if BuffwatchPlayerConfig.SortOrder == BUFFWATCHADDON.SORTORDER_DROPDOWN_LIST[2] then -- "Class"

            table.sort(Player_Order,
            function(a,b)

                if a.IsPet == b.IsPet then

                    if a.Class == b.Class then
                        return a.Name < b.Name;
                    else
                        return a.Class < b.Class;
                    end

                else
                    return a.IsPet < b.IsPet;
                end

            end);

        elseif BuffwatchPlayerConfig.SortOrder == BUFFWATCHADDON.SORTORDER_DROPDOWN_LIST[3] then -- "Name"

            table.sort(Player_Order,
            function(a,b)

                if a.IsPet == b.IsPet then
                    return a.Name < b.Name;
                else
                    return a.IsPet < b.IsPet;
                end

            end);

        else -- Default

            table.sort(Player_Order,
            function(a,b)

                if a.IsPet == b.IsPet then

                    if a.SubGroup == b.SubGroup then
                        return a.UNIT_ID < b.UNIT_ID;
                    else
                        return a.SubGroup < b.SubGroup;
                    end

                else
                    return a.IsPet < b.IsPet;
                end

            end);

        end

    end

end

function BUFFWATCHADDON.GetAllBuffs()

    for _, v in pairs(Player_Info) do
        BUFFWATCHADDON.Player_GetBuffs(v);
        BUFFWATCHADDON.Player_GetTemporaryEnchants(v);
    end

    BUFFWATCHADDON.ResizeWindow();

end

function BUFFWATCHADDON.Player_GetBuffs(v)

    local curr_lock = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_Lock"];

    if not curr_lock:GetChecked() then

        if InCombatLockdown() then

            BUFFWATCHADDON.Add_InCombat_Events({"GetBuffs", v});

        else

            -- Reset list of buffs for the player
            BuffwatchPlayerBuffs[v.Name]["Buffs"] = { };
            BuffwatchSaveBuffs[v.Name] = nil;

            -- Setup buff filter
            local showbuffs = "HELPFUL";
            if BuffwatchPlayerConfig.ShowAllForPlayer == false or not v.IsUnitPlayer then
                if BuffwatchPlayerConfig.ShowCastableBuffs == true then
                    if BuffwatchPlayerConfig.ShowOnlyMine == true then
                        showbuffs = "HELPFUL|RAID|PLAYER";
                    else
                        showbuffs = "HELPFUL|RAID";
                    end
                elseif BuffwatchPlayerConfig.ShowOnlyMine == true then
                    showbuffs = "HELPFUL|PLAYER";
                end
            end

            local lastbuffid = 0;

            for i = 1, maxBuffCount do

                local buff, icon, _, _, duration, expTime, caster, _, _, spellId = UnitAura(v.UNIT_ID, i, showbuffs);
                local curr_buff = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_Buff"..i];

                if not buff and not curr_buff then break; end

                if buff then

                    local rank = BUFFWATCHADDON.GetSpellRankText(spellId);

                    -- Check if buff button has been created
                    if curr_buff == nil then
                        curr_buff = BUFFWATCHADDON.CreateBuffButton(v.ID, i);
                    end

                    if lastbuffid == 0 then
                        curr_buff:SetPoint("TOPLEFT", "BuffwatchFrame_PlayerFrame"..v.ID.."_Name", "TOPLEFT", maxnamewidth + 5, 4);
                    else
                        curr_buff:SetPoint("TOPLEFT", "BuffwatchFrame_PlayerFrame"..v.ID.."_Buff"..lastbuffid, "TOPRIGHT");
                    end

                    lastbuffid = i;

                    local curr_buff_icon = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_Buff"..i.."Icon"];

                    curr_buff_icon:SetVertexColor(1,1,1);
                    curr_buff_icon:SetTexture(icon);
                    curr_buff:Show();
                    BuffwatchPlayerBuffs[v.Name]["Buffs"][i] = { };
                    BuffwatchPlayerBuffs[v.Name]["Buffs"][i]["Buff"] = buff;
                    BuffwatchPlayerBuffs[v.Name]["Buffs"][i]["Rank"] = rank;
                    BuffwatchPlayerBuffs[v.Name]["Buffs"][i]["Icon"] = icon;
                    if caster then
                        BuffwatchPlayerBuffs[v.Name]["Buffs"][i]["CasterName"] = UnitName(caster);
                    end

                    -- Setup action for this buff button
                    curr_buff:SetAttribute("type", "spell");
                    curr_buff:SetAttribute("unit1", v.UNIT_ID);
                    curr_buff:SetAttribute("spell1", buff.."("..(rank or "")..")");

--BUFFWATCHADDON.Debug("GetBuffs1: Player="..v.Name)
                    if BuffwatchConfig.Spirals == true and duration and duration > 0 then
--BUFFWATCHADDON.Debug("GetBuffs1: BuffID="..i..", expTime="..expTime..",duration="..duration)
                        curr_buff.cooldown:Show();
                        curr_buff.cooldown:SetHideCountdownNumbers(BuffwatchConfig.HideCooldownText); -- For Blizz text
                        curr_buff.cooldown:SetCooldown(expTime - duration, duration);
                    else
--BUFFWATCHADDON.Debug("GetBuffs1: BuffID="..i..", Hiding")
                        curr_buff.cooldown:Hide();
                    end

                else

                    local curr_buff_icon = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_Buff"..i.."Icon"];

                    curr_buff:Hide();
                    curr_buff_icon:SetTexture(nil);

                end

            end

            if v.IsUnitPlayer then
                Player_Info[v.Name]["LastBuffId"] = lastbuffid;

                -- Re-attach the first temp enchant
                local i = next(BuffwatchPlayerTempEnch);
                if i then
                    local curr_buff = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_TemporaryEnchant"..i];
                    if lastbuffid == 0 then
                        curr_buff:SetPoint("TOPLEFT", "BuffwatchFrame_PlayerFrame"..v.ID.."_Name", "TOPLEFT", maxnamewidth + 5, 4);
                    else
                        curr_buff:SetPoint("TOPLEFT", "BuffwatchFrame_PlayerFrame"..v.ID.."_Buff"..lastbuffid, "TOPRIGHT");
                    end
                end
            end

        end

    else

        local lockedbuffcount = BUFFWATCHADDON.GetLen(BuffwatchPlayerBuffs[v.Name]["Buffs"]);

        if lockedbuffcount > 0 then

            local playerbuffs = BUFFWATCHADDON.GetPlayerBuffs(v.UNIT_ID);

            -- Refresh currently locked buffs
            for i = 1, maxBuffCount do

                local curr_buff = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_Buff"..i];
                if not curr_buff then break; end

                if curr_buff:IsShown() then

                    local curr_buff_icon = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_Buff"..i.."Icon"];

                    -- Set buff icon to grey if player is dead or offline
                    if v.DeadorDC == 1 then

                        curr_buff_icon:SetVertexColor(0.4,0.4,0.4);

                    else

                        local buff = BuffwatchPlayerBuffs[v.Name]["Buffs"][i]["Buff"];
                        local rank = BuffwatchPlayerBuffs[v.Name]["Buffs"][i]["Rank"];

                        local castername;
                        if SpecialBuffs[buff] == 1 then
                            castername = BuffwatchPlayerBuffs[v.Name]["Buffs"][i]["CasterName"];
                        end

                        local buffid = BUFFWATCHADDON.FindBuff(playerbuffs, buff, rank, castername);

                        if buffid ~= 0 then
                            -- Set buff icon to its normal colour if it exists
                            curr_buff_icon:SetVertexColor(1,1,1);

                            local caster = playerbuffs[buffid]["Caster"];
                            if caster then
                                BuffwatchPlayerBuffs[v.Name]["Buffs"][i]["CasterName"] = UnitName(caster);
                            end
                        else

                            -- Buff has expired, start by checking for different rank of same buff
                            buffid = BUFFWATCHADDON.FindBuff(playerbuffs, buff, nil, castername);

                            if buffid == 0 then

                                -- Still nothing, Check if there is an automatic replacement
                                local buffGroup = GroupBuffs.Buff[buff];

                                if buffGroup then

                                    -- Iterate Group for this buff
                                    for _, val in ipairs(GroupBuffs.Group[buffGroup]) do

                                        if val ~= buff then

                                            buffid = BUFFWATCHADDON.FindBuff(playerbuffs, val, nil, castername);

                                            if buffid ~= 0 then
                                                buff = val;
                                                break;
                                            end

                                        end

                                    end

                                end

                            end

                            if buffid ~= 0 then

                                -- Set buff icon to its normal colour as it has an automatic replacement
                                curr_buff_icon:SetVertexColor(1,1,1);

                                if InCombatLockdown() then

                                    BUFFWATCHADDON.Add_InCombat_Events({"GetBuffs", v});

                                else

                                    -- Replace buff button with auto replacement
                                    rank = playerbuffs[buffid]["Rank"];
                                    local icon = playerbuffs[buffid]["Icon"];
                                    curr_buff_icon:SetTexture(icon);
                                    BuffwatchPlayerBuffs[v.Name]["Buffs"][i] = { };
                                    BuffwatchPlayerBuffs[v.Name]["Buffs"][i]["Buff"] = buff;
                                    BuffwatchPlayerBuffs[v.Name]["Buffs"][i]["Rank"] = rank;
                                    BuffwatchPlayerBuffs[v.Name]["Buffs"][i]["Icon"] = icon;

                                    -- Setup action for this buff button
                                    curr_buff:SetAttribute("type", "spell");
                                    curr_buff:SetAttribute("unit1", v.UNIT_ID);
                                    curr_buff:SetAttribute("spell1", buff.."("..(rank or "")..")");

                                end

                                local caster = playerbuffs[buffid]["Caster"];
                                if caster then
                                    BuffwatchPlayerBuffs[v.Name]["Buffs"][i]["CasterName"] = UnitName(caster);
                                end

                            else

                                -- Buff expired and no possible replacement buff, so set icon to red
                                curr_buff_icon:SetVertexColor(1,0,0);

                            end

                        end

                        if buffid ~= 0 then

                            local duration = playerbuffs[buffid]["Duration"];
--BUFFWATCHADDON.Debug("GetBuffs2: Player="..v.Name)
                            if BuffwatchConfig.Spirals == true and duration and duration > 0 then
                                local expTime = playerbuffs[buffid]["ExpTime"];
--BUFFWATCHADDON.Debug("GetBuffs2: BuffID="..i..", expTime="..expTime..",duration="..duration)
                                curr_buff.cooldown:Show();
                                curr_buff.cooldown:SetHideCountdownNumbers(BuffwatchConfig.HideCooldownText); -- For Blizz text
                                curr_buff.cooldown:SetCooldown(expTime - duration, duration);
                            else
--BUFFWATCHADDON.Debug("GetBuffs2: BuffID="..i..", Hiding")
                                curr_buff.cooldown:Hide();
                            end

                        else
                            curr_buff.cooldown:Hide();
                        end

                    end

                end

            end

        end

    end

end

function BUFFWATCHADDON.Player_GetTemporaryEnchants(v)

    if not v.IsUnitPlayer then return; end

    local player_lock = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_Lock"];

    if not player_lock:GetChecked() then

        if InCombatLockdown() then
            BUFFWATCHADDON.Add_InCombat_Events({"Player_GetTemporaryEnchants", v});
        else
            BUFFWATCHADDON.Player_CreateTemporaryEnchants(v, GetWeaponEnchantInfo());
        end

    else

        local lockedbuffcount = BUFFWATCHADDON.GetLen(BuffwatchPlayerTempEnch);

        if lockedbuffcount > 0 then

            local tempenchants = { GetWeaponEnchantInfo() };

            for i = 1, 3 do

                local curr_buff = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_TemporaryEnchant"..i];
                if curr_buff and curr_buff:IsShown() then

                    local curr_buff_icon = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_TemporaryEnchant"..i.."Icon"];

                    -- Set buff icon to grey if player is dead or offline
                    if v.DeadorDC == 1 then

                        curr_buff_icon:SetVertexColor(0.4,0.4,0.4);

                    else

                        if tempenchants[4 * (i - 1) + 1] == true then
                            -- Set buff icon to its normal colour if it exists
                            curr_buff_icon:SetVertexColor(1,1,1);
                            -- Reset the icon in case the weapon has changed
                            local icon = GetInventoryItemTexture(v.UNIT_ID, tempEnchantMapping[i]);
                            curr_buff_icon:SetTexture(icon);
                            BuffwatchPlayerTempEnch[i]["Icon"] = icon;
                        else
                            curr_buff_icon:SetVertexColor(1,0,0);
                        end

                    end

                end

            end

        end

    end

end

function BUFFWATCHADDON.Player_CreateTemporaryEnchants(v, ...)

    local numVals = select("#", ...);
    local numItems = numVals / 4;
    local attachFrame;
    local teid = 0;

    if numItems ~= 0 then
        local lastbuffid = Player_Info[v.Name]["LastBuffId"];
        if lastbuffid == 0 then
            attachFrame = { "TOPLEFT", "BuffwatchFrame_PlayerFrame"..v.ID.."_Name", "TOPLEFT", maxnamewidth + 5, 4 };
        else
            attachFrame = { "TOPLEFT", "BuffwatchFrame_PlayerFrame"..v.ID.."_Buff"..lastbuffid, "TOPRIGHT" };
        end
    end

    BuffwatchPlayerTempEnch = { };
    BuffwatchSaveTempEnch = { };

    for i = 1, 3 do
        -- Check for temporary weapon enchant
        local hasEnchant, enchantExpiration = select(4 * (i - 1) + 1, ...);
        local curr_buff = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_TemporaryEnchant"..i];

        if hasEnchant then

            if curr_buff == nil then
                curr_buff = BUFFWATCHADDON.CreateTemporaryEnchantButton(v.ID, i);
            end
            if teid == 0 then
                curr_buff:SetPoint(unpack(attachFrame));
            else
                curr_buff:SetPoint("TOPLEFT", "BuffwatchFrame_PlayerFrame"..v.ID.."_TemporaryEnchant"..teid, "TOPRIGHT");
            end

            teid = i;

            local curr_buff_icon = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_TemporaryEnchant"..i.."Icon"];

            curr_buff_icon:SetVertexColor(1,1,1);
            local icon = GetInventoryItemTexture(v.UNIT_ID, tempEnchantMapping[i]);
            curr_buff_icon:SetTexture(icon);
            curr_buff:Show();
            BuffwatchPlayerTempEnch[i] = { };
            BuffwatchPlayerTempEnch[i]["Buff"] = tempEnchantSlotMapping[i].." temporary enchant";
            BuffwatchPlayerTempEnch[i]["Icon"] = icon;

        else

            if curr_buff then
                local curr_buff_icon = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_TemporaryEnchant"..i.."Icon"];

                curr_buff:Hide();
                curr_buff_icon:SetTexture(nil);
            end

        end
    end
end

function BUFFWATCHADDON.GetPlayerBuffs(unitid)

    local playerbuffs = { };

    for i = 1, maxBuffCount do

        local buff, icon, _, _, duration, expTime, caster, _, _, spellId = UnitAura(unitid, i, "HELPFUL");

        if not buff then break; end

        playerbuffs[i] = { };
        playerbuffs[i]["Buff"] = buff;
        playerbuffs[i]["Rank"] = BUFFWATCHADDON.GetSpellRankText(spellId);
        playerbuffs[i]["Icon"] = icon;
        playerbuffs[i]["Duration"] = duration;
        playerbuffs[i]["ExpTime"] = expTime;
        playerbuffs[i]["Caster"] = caster;

    end

    return playerbuffs;

end

-- Set buff button alignment based on longest player name
function BUFFWATCHADDON.SetBuffAlignment()

    for _, v in pairs(Player_Info) do

        if BuffwatchPlayerBuffs[v.Name] then

            local i = next(BuffwatchPlayerBuffs[v.Name]["Buffs"]);

            if i then

                local curr_buff = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_Buff"..i];

                curr_buff:SetPoint("TOPLEFT", "BuffwatchFrame_PlayerFrame"..v.ID.."_Name", "TOPLEFT", maxnamewidth + 5, 4);

            elseif Player_Info[v.Name].IsUnitPlayer then

                local firsttempenchid = next(BuffwatchPlayerTempEnch, nil);

                if firsttempenchid then

                    local curr_buff = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_TemporaryEnchant"..firsttempenchid];

                    curr_buff:SetPoint("TOPLEFT", "BuffwatchFrame_PlayerFrame"..v.ID.."_Name", "TOPLEFT", maxnamewidth + 5, 4);

                end

            end

        end

    end

end

-- Setup buff list for the player based on our BuffwatchSaveBuffs & BuffwatchSaveTempEnch lists
function BUFFWATCHADDON.Player_LoadBuffs(v)

    local lastbuffid = 0;
    local savedbuffs = false;

    if BuffwatchSaveBuffs[v.Name] then

        savedbuffs = true;

        local tmp = BuffwatchSaveBuffs[v.Name]["Buffs"];

        BuffwatchSaveBuffs[v.Name]["Buffs"] = { };

        -- remove nil values
        for _, val in pairs(tmp) do

            if val then
                table.insert(BuffwatchSaveBuffs[v.Name]["Buffs"], val);
            end

        end

        BuffwatchPlayerBuffs[v.Name]["Buffs"] = BuffwatchSaveBuffs[v.Name]["Buffs"];

        for i = 1, maxBuffCount do

            local curr_buff = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_Buff"..i];

            if BuffwatchSaveBuffs[v.Name]["Buffs"][i] then

                -- Check if buff button has been created
                if curr_buff == nil then
                    curr_buff = BUFFWATCHADDON.CreateBuffButton(v.ID, i);
                end

                if i == 1 then
                    curr_buff:SetPoint("TOPLEFT", "BuffwatchFrame_PlayerFrame"..v.ID.."_Name", "TOPLEFT", maxnamewidth + 5, 4);
                else
                    curr_buff:SetPoint("TOPLEFT", "BuffwatchFrame_PlayerFrame"..v.ID.."_Buff"..(i-1), "TOPRIGHT");
                end

                lastbuffid = i;

                local curr_buff_icon = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_Buff"..i.."Icon"];

                curr_buff_icon:SetVertexColor(0.4,0.4,0.4);
                curr_buff_icon:SetTexture(BuffwatchSaveBuffs[v.Name]["Buffs"][i]["Icon"]);
                curr_buff:Show();

                local buff = BuffwatchSaveBuffs[v.Name]["Buffs"][i]["Buff"];
                local rank = BuffwatchSaveBuffs[v.Name]["Buffs"][i]["Rank"];

                curr_buff:SetAttribute("type", "spell");
                curr_buff:SetAttribute("unit1", v.UNIT_ID);
                curr_buff:SetAttribute("spell1", buff.."("..(rank or "")..")");

            else

                if curr_buff then

                    local curr_buff_icon = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_Buff"..i.."Icon"];

                    curr_buff:Hide();
                    curr_buff_icon:SetTexture(nil);

                else
                    break;
                end

            end

        end

    end

    local teid = 0;

    if v.IsUnitPlayer and next(BuffwatchSaveTempEnch) then
        -- Load temporary enchants
        local attachFrame;

        if lastbuffid == 0 then
            attachFrame = { "TOPLEFT", "BuffwatchFrame_PlayerFrame"..v.ID.."_Name", "TOPLEFT", maxnamewidth + 5, 4 };
        else
            attachFrame = { "TOPLEFT", "BuffwatchFrame_PlayerFrame"..v.ID.."_Buff"..lastbuffid, "TOPRIGHT" };
        end

        BuffwatchPlayerTempEnch = BuffwatchSaveTempEnch;

        for i = 1, 3 do
            if BuffwatchSaveTempEnch[i] then
                local curr_buff = BUFFWATCHADDON.CreateTemporaryEnchantButton(v.ID, i);
                if teid == 0 then
                    curr_buff:SetPoint(unpack(attachFrame));
                else
                    curr_buff:SetPoint("TOPLEFT", "BuffwatchFrame_PlayerFrame"..v.ID.."_TemporaryEnchant"..teid, "TOPRIGHT");
                end

                teid = i;

                local curr_buff_icon = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_TemporaryEnchant"..i.."Icon"];

                curr_buff_icon:SetVertexColor(0.4,0.4,0.4);
                curr_buff_icon:SetTexture(BuffwatchSaveTempEnch[i]["Icon"]);
                curr_buff:Show();
            end
        end
    end

    if savedbuffs or teid > 0 then
        _G["BuffwatchFrame_PlayerFrame"..v.ID.."_Lock"]:SetChecked(true);
    else
        _G["BuffwatchFrame_PlayerFrame"..v.ID.."_Lock"]:SetChecked(false);
        BuffwatchFrame_LockAll:SetChecked(false);
    end

end

function BUFFWATCHADDON.CreateBuffButton(playerframeid, buffbuttonid)
    local buffbutton = CreateFrame("Button", "BuffwatchFrame_PlayerFrame"..playerframeid.."_Buff"..buffbuttonid,
        _G["BuffwatchFrame_PlayerFrame"..playerframeid], "Buffwatch_BuffButton_Template");
    buffbutton:SetID(buffbuttonid);

    local cooldown = CreateFrame("Cooldown", "BuffwatchFrame_PlayerFrame"..playerframeid.."_Buff"..buffbuttonid.."_Cooldown",
        buffbutton, "CooldownFrameTemplate");
    cooldown:SetAllPoints(buffbutton);
    cooldown:SetReverse(true);
    cooldown:SetScale(BuffwatchConfig.CooldownTextScale);
    buffbutton.cooldown = cooldown;

    return buffbutton;
end

function BUFFWATCHADDON.CreateTemporaryEnchantButton(playerframeid, tebuttonid)
    local tebutton = CreateFrame("Button", "BuffwatchFrame_PlayerFrame"..playerframeid.."_TemporaryEnchant"..tebuttonid,
        _G["BuffwatchFrame_PlayerFrame"..playerframeid], "Buffwatch_TemporaryEnchant_Template");
    tebutton:SetID(tebuttonid);

    local cooldown = CreateFrame("Cooldown", "BuffwatchFrame_PlayerFrame"..playerframeid.."_TemporaryEnchant"..tebuttonid.."_Cooldown",
        tebutton, "CooldownFrameTemplate");
    cooldown:SetAllPoints(tebutton);
    cooldown:SetReverse(true);
    cooldown:SetScale(BuffwatchConfig.CooldownTextScale);
    tebutton.cooldown = cooldown;

    return tebutton;
end

function BUFFWATCHADDON.SetMinimized(self, minimized)

    if self == nil then
        self = _G["BuffwatchFrame_MinimizeButton"];
    end

    if minimized then
        BuffwatchFrame_PlayerFrame:Hide();
        BuffwatchFrame_LockAll:Disable();
        self:SetNormalTexture("Interface\\AddOns\\BuffwatchClassic\\MinimizeButton-Max");
        GameTooltip:SetText("Max");
    else
        BuffwatchFrame_PlayerFrame:Show();
        BuffwatchFrame_LockAll:Enable();
        self:SetNormalTexture("Interface\\AddOns\\BuffwatchClassic\\MinimizeButton-Min");
        GameTooltip:SetText("Min");
        -- Do a refresh
        BUFFWATCHADDON.GetPlayerInfo();
        BUFFWATCHADDON.GetAllBuffs();
    end

    BUFFWATCHADDON.ResizeWindow();

end

function BUFFWATCHADDON.HideUnmonitored(self, hidden)

    if self == nil then
        self = _G["BuffwatchFrame_HideButton"];
    end

    if hidden == true then
        self:SetNormalTexture("Interface\\AddOns\\BuffwatchClassic\\MinimizeButton-Show");
        GameTooltip:SetText("Show All");
    else
        self:SetNormalTexture("Interface\\AddOns\\BuffwatchClassic\\MinimizeButton-Hide");
        GameTooltip:SetText("Hide Unmonitored");
    end

    BUFFWATCHADDON.PositionAllPlayerFrames();
    BUFFWATCHADDON.ResizeWindow();

end

function BUFFWATCHADDON.ResizeWindow()

    if not InCombatLockdown() and BUFFWATCHADDON.framePositioned == true then

        local x, y = BUFFWATCHADDON.GetPoint(BuffwatchFrame, BUFFWATCHADDON.ANCHORPOINT_DROPDOWN_MAP[BuffwatchPlayerConfig.AnchorPoint]);

        if not BuffwatchPlayerConfig.Minimized then

            local len, width;

            if BuffwatchPlayerConfig.HideUnmonitored == false then
                BuffwatchFrame:SetHeight(24 + (#Player_Order * 18));
            else

                local players = 0;

                -- Only count player frames that are not hidden
                for _, v in pairs(Player_Info) do
                    if not _G["BuffwatchFrame_PlayerFrame"..v.ID.."_Lock"]:GetChecked()
                        or next(BuffwatchPlayerBuffs[v.Name]["Buffs"], nil) ~= nil
                        or next(BuffwatchPlayerTempEnch, nil) ~= nil then

                        players = players + 1;
                    end
                end

                BuffwatchFrame:SetHeight(24 + (players * 18));

            end

            local maxbuffs = 0;
  -- ***** may need to move this to only check when buffs actually get hidden or shown
            for k, v in pairs(BuffwatchPlayerBuffs) do

                len = BUFFWATCHADDON.GetLen(v.Buffs);
                if Player_Info[k].IsUnitPlayer then
                    len = len + BUFFWATCHADDON.GetLen(BuffwatchPlayerTempEnch);
                end

                if maxbuffs < len then
                    maxbuffs = len;
  --                maxbuffid = v.ID;
                end

            end

            width = math.max(32 + maxnamewidth + (maxbuffs * 18), 115);

            BuffwatchFrame:SetWidth(width);

        else

            BuffwatchFrame:SetHeight(20);
            BuffwatchFrame:SetWidth(115);

        end

        BUFFWATCHADDON.SetPoint(BuffwatchFrame, BUFFWATCHADDON.ANCHORPOINT_DROPDOWN_MAP[BuffwatchPlayerConfig.AnchorPoint], x, y);

    end

end

-- Inspect all visible player locks, return true if they are all checked
function BUFFWATCHADDON.InspectPlayerLocks()

        local allchecked = true;

        -- Iterate through each player
        for _, v in pairs(Player_Info) do

            local curr_lock = _G["BuffwatchFrame_PlayerFrame" .. v.ID .. "_Lock"];

            if not curr_lock:GetChecked() then
                allchecked = false;
                break;
            end

        end

        return allchecked;

end

-- Add a function call to the queue to run after combat
function BUFFWATCHADDON.Add_InCombat_Events(value)

    local found;

    -- Check to see if this event has already been queued
    for _, v in pairs(InCombat_Events) do

        if value[1] == v[1] then

            if value[1] == "GetBuffs" or value[1] == "Player_GetTemporaryEnchants" then

                if value[2].ID == v[2].ID then
                    found = true;
                    break;
                end

            elseif value[1] == "GetPlayerInfo" then
                found = true;
                break;
            end

        end

    end

    -- Add it to the queue, if its not already on it
    if not found then
        table.insert(InCombat_Events, value);
    end

end

-- Combat lockdown is over, process any queued events
function BUFFWATCHADDON.Process_InCombat_Events()

    local t = table.remove(InCombat_Events, 1);

    local eventfired;

    while t do

        if t[1] == "GetPlayerInfo" then

            BUFFWATCHADDON.GetPlayerInfo();

        elseif t[1] == "GetBuffs" then

            if Player_Info[t[2].Name] ~= nil then
                BUFFWATCHADDON.Player_GetBuffs(t[2]);
            end

        elseif t[1] == "Player_GetTemporaryEnchants" then

            if Player_Info[t[2].Name] ~= nil then
                BUFFWATCHADDON.Player_GetTemporaryEnchants(t[2]);
            end

        end

        t = table.remove(InCombat_Events, 1);

        eventfired = true;

    end

    if eventfired then
        BUFFWATCHADDON.ResizeWindow();
    end

end

function BUFFWATCHADDON_G.Toggle()

    if InCombatLockdown() then

        BUFFWATCHADDON.Print("Cannot hide Buffwatch while in combat.");

    else

        if BuffwatchFrame:IsVisible() then
            BuffwatchFrame:Hide();
            BUFFWATCHADDON.Print("Type '/bfw toggle' to show the Buffwatch window again.");
        else
            BUFFWATCHADDON.Set_UNIT_IDs();
            BuffwatchFrame:Show();
        end

    end

end

function BUFFWATCHADDON_G.OptionsToggle()

    -- Call twice to get around issue of correct panel not opening on first try
    InterfaceOptionsFrame_OpenToCategory(BUFFWATCHADDON.NAME);
    InterfaceOptionsFrame_OpenToCategory(BUFFWATCHADDON.NAME);

end

function BUFFWATCHADDON_G.ShowHelp()

    -- Call twice to get around issue of correct panel not opening on first try
    InterfaceOptionsFrame_OpenToCategory(BUFFWATCHADDON.HELPFRAMENAME);
    InterfaceOptionsFrame_OpenToCategory(BUFFWATCHADDON.HELPFRAMENAME);

end

-- ****************************************************************************
-- **                                                                        **
-- **  Misc Functions                                                        **
-- **                                                                        **
-- ****************************************************************************

-- Get's a Unique ID for a new player, also to be used as the player's frame ID
--   If player was recently in the group, and their ID has not yet been replaced
--   then we resupply it.
function BUFFWATCHADDON.GetNextID(unitname)

    local i = 1;

    if BUFFWATCHADDON.GetLen(Player_Info) == 0 then

        return i;

    else

        local oldID = Player_Left[unitname];

        -- Player was here before, check if id is still free
        if oldID then

            local found = false;

            for _, v in pairs(Player_Info) do
                if v.ID == oldID then
                    -- Someone else has this id now :(
                    found = true;
                    break;
                end
            end

            Player_Left[unitname] = nil;

            if found == false then
                return oldID;
            end

        end

        local Player_Copy = { };

        for _, v in pairs(Player_Info) do
            table.insert(Player_Copy, v);
        end

        table.sort(Player_Copy, function(a,b)
            return a.ID < b.ID;
            end)

        for _, v in pairs(Player_Copy) do

            if i ~= v.ID then
                break;
            end

            i = i + 1;

        end

    end

    return i;

end

function BUFFWATCHADDON.FindBuff(playerbuffs, buff, rank, castername)

    for i = 1, #playerbuffs do

        if playerbuffs[i]["Buff"] == buff then

            if (not rank or playerbuffs[i]["Rank"] == rank)
                and (not castername or UnitName(playerbuffs[i]["Caster"]) == castername) then

                return i;

            end

        end

    end

    return 0;

end

function BUFFWATCHADDON.UnitHasBuff(unit, buff, rank)

    for i = 1, maxBuffCount do

        local thisbuff, _, _, _, _, _, _, _, _, spellId = UnitAura(unit, i, "HELPFUL");

        if not thisbuff then break; end

        if thisbuff == buff then

            if rank then

                local thisrank = BUFFWATCHADDON.GetSpellRankText(spellId);
                if thisrank == rank then
                    return i;
                else
                    return 0;
                end

            else
                return i;
            end

        end

    end

    return 0;

end

function BUFFWATCHADDON.ColourAllNames()

    for _, v in pairs(Player_Info) do
        BUFFWATCHADDON.Player_ColourName(v);
    end

end

function BUFFWATCHADDON.Player_ColourName(v)

    local nametext = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_NameText"];

    if v.DeadorDC == 1 then
        nametext:SetTextColor(0.4, 0.4, 0.4);
    elseif v.Class ~= "" then

        local color = RAID_CLASS_COLORS[v.Class];

        if color then
            nametext:SetTextColor(color.r, color.g, color.b);
        else
            nametext:SetTextColor(1.0, 0.9, 0.8);
        end

    else
        nametext:SetTextColor(1.0, 0.9, 0.8);
    end

end

function BUFFWATCHADDON_G.Set_CooldownTextScale()

    for _, v in pairs(Player_Info) do

        for i = 1, maxBuffCount do

            local cooldown = _G["BuffwatchFrame_PlayerFrame"..v.ID.."_Buff"..i.."_Cooldown"];

            if cooldown then
                cooldown:SetScale(BuffwatchConfig.CooldownTextScale);
            else
                break;
            end

        end

    end

end

function BUFFWATCHADDON.GetLen(arr)

    local len = 0;

    if arr ~= nil then

        for _, _ in pairs(arr) do
            len = len + 1;
        end

    end

    return len;
end

function BUFFWATCHADDON.GetPoint(frame, point)

    local x, y;

    if point == "TOPRIGHT" then
        x = frame:GetRight();
        y = frame:GetTop();
    elseif point == "TOPLEFT" then
        x = frame:GetLeft();
        y = frame:GetTop();
    elseif point == "BOTTOMLEFT" then
        x = frame:GetLeft();
        y = frame:GetBottom();
    elseif point == "BOTTOMRIGHT" then
        x = frame:GetRight();
        y = frame:GetBottom();
    elseif point == "CENTER" then
        x = (frame:GetLeft() + frame:GetRight())/2;
        y = (frame:GetTop() + frame:GetBottom())/2;
    end

    BuffwatchPlayerConfig.AnchorX = x;
    BuffwatchPlayerConfig.AnchorY = y;

    return x, y;
end

function BUFFWATCHADDON.SetPoint(frame, point, x, y)

    if point ~= "" then

        frame:ClearAllPoints();
        frame:SetPoint(point, UIParent, "BOTTOMLEFT", x, y);

    end

end

local waitTable = {};
local waitFrame = nil;

function BUFFWATCHADDON.Wait(delay, func, ...)

    if (type(delay) ~= "number" or type(func) ~= "function") then
        return false;
    end

    if (waitFrame == nil) then
        waitFrame = CreateFrame("Frame", "BuffwatchWaitFrame", UIParent);
        waitFrame:SetScript("onUpdate", function (self, elapse)
            local count = #waitTable;
            local i = 1;
            while (i <= count) do
                local waitRecord = tremove(waitTable, i);
                local d = tremove(waitRecord, 1);
                local f = tremove(waitRecord, 1);
                local p = tremove(waitRecord, 1);

                if (d > elapse) then
                    tinsert(waitTable, i, {d-elapse, f, p});
                    i = i + 1;
                else
                    count = count - 1;
                    f(unpack(p));
                end
            end
        end);
    end

    -- Check if this has already been added
    local skipinsert = false;
    for _, v in pairs(waitTable) do
        if v[2] == func then
            skipinsert = true;
            break;
        end
    end

    if (not skipinsert) then
        tinsert(waitTable, {delay, func, {...}});
    end

    return true;
end

function BUFFWATCHADDON.CopyDefaults(from, to)
    if not from then return { }; end
    if not to then to = { }; end

    for k, v in pairs(from) do
        if type(v) == "table" then
            to[k] = BUFFWATCHADDON.CopyDefaults(v, to[k]);
        elseif type(v) ~= type(to[k]) then
            to[k] = v;
        end
    end

    return to;
end

function BUFFWATCHADDON.Print(msg, R, G, B)

    if R == nil then
        R, G, B = 0.2, 0.9, 0.9;
    end

    DEFAULT_CHAT_FRAME:AddMessage(msg, R, G, B);

end

function BUFFWATCHADDON.Debug(msg, R, G, B)

    if BuffwatchConfig.debug == true then
        debugchatframe:AddMessage(msg, R, G, B);
    end

end

function BUFFWATCHADDON.OutputTable(tbl, indent)

    if not indent then indent = 0 end;

    local toprint = string.rep(" ", indent) .. "{\r\n";
    indent = indent + 2;

    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(" ", indent);

        if (type(k) == "number") then
            toprint = toprint .. "[" .. k .. "] = ";
        elseif (type(k) == "string") then
            toprint = toprint  .. k ..  "= ";
        end

        if (type(v) == "number") then
            toprint = toprint .. v .. ",\r\n";
        elseif (type(v) == "string") then
            toprint = toprint .. "\"" .. v .. "\",\r\n";
        elseif (type(v) == "table") then
            toprint = toprint .. BUFFWATCHADDON.OutputTable(v, indent + 2) .. ",\r\n";
        else
            toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n";
        end
    end

    toprint = toprint .. string.rep(" ", indent-2) .. "}";

    return toprint;

end

-- for debugging
--[[

function BUFFWATCHADDON_G.DebugPosition()

    if BuffwatchPlayerConfig.debugleft ~= nil then
        BUFFWATCHADDON.Debug("Buffwatch Old Position Top : "..BuffwatchPlayerConfig.debugtop..", Left : "..BuffwatchPlayerConfig.debugleft, 1, 0.2, 0.2);
    end
    BuffwatchPlayerConfig.debugtop = BuffwatchFrame:GetTop();
    BuffwatchPlayerConfig.debugleft = BuffwatchFrame:GetLeft();
    BUFFWATCHADDON.Debug("Buffwatch New Position Top : "..BuffwatchPlayerConfig.debugtop..", Left : "..BuffwatchPlayerConfig.debugleft, 0.2, 1, 0.2);

end

function BUFFWATCHADDON_G.GetUNIT_IDs()

    return UNIT_IDs;

end

function BUFFWATCHADDON_G.GetPlayer_Info()

    return Player_Info;

end

function BUFFWATCHADDON_G.GetPlayer_Left()

    return Player_Left;

end

function BUFFWATCHADDON_G.GetPlayer_Order()

    return Player_Order;

end

function BUFFWATCHADDON_G.GetBuffwatchConfig()

    return BuffwatchConfig;

end

function BUFFWATCHADDON_G.GetBuffwatchPlayerConfig()

    return BuffwatchPlayerConfig;

end

function BUFFWATCHADDON_G.GetBuffwatchPlayerBuffs()

    return BuffwatchPlayerBuffs;

end

function BUFFWATCHADDON_G.GetBuffwatchPlayerTempEnch()

    return BuffwatchPlayerTempEnch;

end

function BUFFWATCHADDON_G.GetInCombat_Events()

    return InCombat_Events;

end

function BUFFWATCHADDON_G.GetGroupBuffs()

    return GroupBuffs;

end

function BUFFWATCHADDON_G.GetSpellRank(spellId)

    return BUFFWATCHADDON.GetSpellRank(spellId);
end

function BUFFWATCHADDON_G.GetSpellRankText(spellId)

    return BUFFWATCHADDON.GetSpellRankText(spellId);
end
--]]
