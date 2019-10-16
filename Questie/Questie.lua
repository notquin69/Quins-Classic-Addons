
Questie = LibStub("AceAddon-3.0"):NewAddon("Questie", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0", "AceBucket-3.0")
_Questie = {...}
local AceGUI = LibStub("AceGUI-3.0")
if not QuestieConfigCharacter then
    QuestieConfigCharacter = {}
end


DEBUG_CRITICAL = "|cff00f2e6[CRITICAL]|r"
DEBUG_ELEVATED = "|cffebf441[ELEVATED]|r"
DEBUG_INFO = "|cff00bc32[INFO]|r"
DEBUG_DEVELOP = "|cff7c83ff[DEVELOP]|r"
DEBUG_SPAM = "|cffff8484[SPAM]|r"


-- check if user has updated but not restarted the game (todo: add future new source files to this)
if (not QuestieTracker) or (not LQuestie_EasyMenu) then
    if QuestieLocale.locale['enUS'] and QuestieLocale.locale['enUS']['QUESTIE_UPDATED_RESTART'] then -- sometimes locale doesnt update without restarting also
        print(QuestieLocale:GetUIString('QUESTIE_UPDATED_RESTART'))
    else
        print("|cFFFF0000WARNING!|r You have updated questie without restarting the game, this will likely cause problems. Please restart the game before continuing")
    end
end




function Questie:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("QuestieConfig", QuestieOptions:GetDefaults(), true)

    -- Set proper locale. Either default to client Locale or override based on user.
    if Questie.db.global.questieLocaleDiff then
        QuestieLocale:SetUILocale(Questie.db.global.questieLocale);
    else
        QuestieLocale:SetUILocale(GetLocale());
    end

    Questie:Debug(DEBUG_CRITICAL, "Questie addon loaded")
    Questie:RegisterEvent("PLAYER_ENTERING_WORLD", QuestieEventHandler.PLAYER_ENTERING_WORLD)

    --Accepted Events
    Questie:RegisterEvent("QUEST_ACCEPTED", QuestieEventHandler.QUEST_ACCEPTED)
    Questie:RegisterEvent("UNIT_QUEST_LOG_CHANGED", QuestieEventHandler.UNIT_QUEST_LOG_CHANGED);
    Questie:RegisterEvent("QUEST_TURNED_IN", QuestieEventHandler.QUEST_TURNED_IN)
    Questie:RegisterEvent("QUEST_REMOVED", QuestieEventHandler.QUEST_REMOVED)
    Questie:RegisterEvent("PLAYER_LEVEL_UP", QuestieEventHandler.PLAYER_LEVEL_UP);
    -- Use bucket for QUEST_LOG_UPDATE to let information propagate through to the blizzard API
    -- Might be able to change this to 0.5 seconds instead, further testing needed.
    Questie:RegisterBucketEvent("QUEST_LOG_UPDATE", 1, QuestieEventHandler.QUEST_LOG_UPDATE);
    Questie:RegisterEvent("MODIFIER_STATE_CHANGED", QuestieEventHandler.MODIFIER_STATE_CHANGED);

    -- Events to update a players professions and reputations
    Questie:RegisterEvent("CHAT_MSG_SKILL", QuestieEventHandler.CHAT_MSG_SKILL)
    Questie:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE", QuestieEventHandler.CHAT_MSG_COMBAT_FACTION_CHANGE)

    -- Party join event for QuestieComms, Use bucket to hinder this from spamming (Ex someone using a raid invite addon etc)
    Questie:RegisterBucketEvent("GROUP_ROSTER_UPDATE", 1, QuestieEventHandler.GROUP_ROSTER_UPDATE);

    --TODO: QUEST_QUERY_COMPLETE Will get all quests the character has finished, need to be implemented!

    -- Nameplate / Tar5get Frame Objective Events
    Questie:RegisterEvent("NAME_PLATE_UNIT_ADDED", QuestieNameplate.NameplateCreated);
    Questie:RegisterEvent("NAME_PLATE_UNIT_REMOVED", QuestieNameplate.NameplateDestroyed);
    Questie:RegisterEvent("PLAYER_TARGET_CHANGED", QuestieNameplate.DrawTargetFrame);

    -- Initialize Coordinates
    QuestieCoords.Initialize();

    -- Initialize questiecomms
    --C_ChatInfo.RegisterAddonMessagePrefix("questie")
    -- JoinTemporaryChannel("questie")
    --Questie:RegisterEvent("CHAT_MSG_ADDON", QuestieComms.MessageReceived)

    -- Initialize Journey Window
    QuestieJourney.Initialize();

    -- Disable QuestieComms
    QuestieComms = nil;
    -- Initialize Questie Comms
    if(QuestieComms) then
        QuestieComms:Initialize();
    end


    -- Register Slash Commands
    Questie:RegisterChatCommand("questieclassic", "QuestieSlash")
    Questie:RegisterChatCommand("questie", "QuestieSlash")

    QuestieOptions:Initialize();

    --Initialize the DB settings.
    Questie:debug(DEBUG_DEVELOP, QuestieLocale:GetUIString('DEBUG_CLUSTER', Questie.db.global.clusterLevel))
    QUESTIE_NOTES_CLUSTERMUL_HACK = Questie.db.global.clusterLevel;


    -- Creating the minimap config icon
    Questie.minimapConfigIcon = LibStub("LibDBIcon-1.0");
    Questie.minimapConfigIcon:Register("MinimapIcon", QuestieOptions:GetMinimapIconLDB(), Questie.db.profile.minimap);

    -- Update the default text on the map show/hide button for localization
    if Questie.db.char.enabled then
        Questie_Toggle:SetText(QuestieLocale:GetUIString('QUESTIE_MAP_BUTTON_HIDE'));
    else
        Questie_Toggle:SetText(QuestieLocale:GetUIString('QUESTIE_MAP_BUTTON_SHOW'));
        QuestieQuest:ToggleNotes(false)
    end

    -- Update status of Map button on hide between play sessions
    if Questie.db.global.mapShowHideEnabled then
        Questie_Toggle:Show();
    else
        Questie_Toggle:Hide();
    end
    if Questie.db.global.dbmHUDEnable then
        QuestieDBMIntegration:EnableHUD()
    end
    -- init config frame
    if not QuestieConfigFrame then
        QuestieOptions.configFrame = AceGUI:Create("Frame");
        LibStub("AceConfigDialogQuestie-3.0"):SetDefaultSize("Questie", 625, 700)
        LibStub("AceConfigDialogQuestie-3.0"):Open("Questie", QuestieOptions.configFrame)
        QuestieOptions.configFrame:Hide();                
        _G["QuestieConfigFrame"] = QuestieOptions.configFrame.frame;
        table.insert(UISpecialFrames, "QuestieConfigFrame");
    end
end

function Questie:OnUpdate()

end

function Questie:OnEnable()
    -- Called when the addon is enabled
end

function Questie:OnDisable()
    -- Called when the addon is disabled
end

function Questie:QuestieSlash(input)

    input = string.trim(input, " ");

    -- /questie
    if input == "" or not input then
        QuestieOptions:OpenConfigWindow();

        if QuestieJourney:IsShown() then
            QuestieJourney.ToggleJourneyWindow();
        end
        return ;
    end

    -- /questie help || /questie ?
    if input == "help" or input == "?" then
        print(Questie:Colorize(QuestieLocale:GetUIString('SLASH_HEAD'), 'yellow'));
        print(Questie:Colorize(QuestieLocale:GetUIString('SLASH_CONFIG'), 'yellow'));
        print(Questie:Colorize(QuestieLocale:GetUIString('SLASH_TOGGLE_QUESTIE'), 'yellow'));
        print(Questie:Colorize(QuestieLocale:GetUIString('SLASH_MINIMAP'), 'yellow'));
        print(Questie:Colorize(QuestieLocale:GetUIString('SLASH_JOURNEY'), 'yellow'));
        return;
    end

    -- /questie toggle
    if input == "toggle" then
        QuestieQuest:ToggleNotes();

        -- CLose config window if it's open to avoid desyncing the Checkbox
        QuestieOptions:HideFrame();
        return;
    end
    
    if input == "reload" then
        QuestieQuest:SmoothReset()
        return
    end

    -- /questie minimap
    if input == "minimap" then
        Questie.db.profile.minimap.hide = not Questie.db.profile.minimap.hide;

        if Questie.db.profile.minimap.hide then
            Questie.minimapConfigIcon:Hide("MinimapIcon");
        else
            Questie.minimapConfigIcon:Show("MinimapIcon");
        end
        return;
    end

    -- /questie journey
    if input == "journey" then
        QuestieJourney.ToggleJourneyWindow();
        QuestieOptions:HideFrame();
        return;
    end

    print(Questie:Colorize("[Questie] :: ", 'yellow') .. QuestieLocale:GetUIString('SLASH_INVALID') .. Questie:Colorize('/questie help', 'yellow'));
end

function Questie:Colorize(str, color)
    local c = '';

    if color == 'red' then
        c = '|cffff0000';
    elseif color == 'gray' then
        c = '|cFFCFCFCF';
    elseif color == 'purple' then
        c = '|cFFB900FF';
    elseif color == 'blue' then
        c = '|cB900FFFF';
    elseif color == 'yellow' then
        c = '|cFFFFB900';
    end

    return c .. str .. "|r"
end

function Questie:GetClassColor(class)

    class = string.lower(class);

    if class == 'druid' then
        return '|cFFFF7D0A';
    elseif class == 'hunter' then
        return '|cFFABD473';
    elseif class == 'mage' then
        return '|cFF69CCF0';
    elseif class == 'paladin' then
        return '|cFFF58CBA';
    elseif class == 'priest' then
        return '|cFFFFFFFF';
    elseif class == 'rogue' then
        return '|cFFFFF569';
    elseif class == 'shaman' then
        return '|cFF0070DE';
    elseif class == 'warlock' then
        return '|cFF9482C9';
    elseif class == 'warrior' then
        return '|cFFC79C6E';
    else
        return '|cffff0000'; -- error red
    end
end

function Questie:Error(...)
    Questie:Print("|cffff0000[ERROR]|r", ...)
end

function Questie:error(...)
    Questie:Error(...)
end

--debuglevel = 5 --1 Critical, 2 ELEVATED, 3 Info, 4, Develop, 5 SPAM THAT SHIT YO
--DEBUG_CRITICAL = "1DEBUG"
--DEBUG_ELEVATED = "2DEBUG"
--DEBUG_INFO = "3DEBUG"
--DEBUG_DEVELOP = "4DEBUG"
--DEBUG_SPAM = "5DEBUG"

function Questie:Debug(...)
    if(Questie.db.global.debugEnabled) then
        if(Questie.db.global.debugLevel < 5 and select(1, ...) == DEBUG_SPAM)then return; end
        if(Questie.db.global.debugLevel < 4 and select(1, ...) == DEBUG_DEVELOP)then return; end
        if(Questie.db.global.debugLevel < 3 and select(1, ...) == DEBUG_INFO)then return; end
        if(Questie.db.global.debugLevel < 2 and select(1, ...) == DEBUG_ELEVATED)then return; end
        if(Questie.db.global.debugLevel < 1 and select(1, ...) == DEBUG_CRITICAL)then return; end
        --Questie:Print(...)
        if not Questie.debugSession then
            Questie.debugSession = GetTime()
            if not QuestieConfigCharacter.log then QuestieConfigCharacter.log = {} end
            QuestieConfigCharacter.log[Questie.debugSession] = {};
        end
        local entry = {}
        entry.time = GetTime()
        entry.data = {...}
        table.insert(QuestieConfigCharacter.log[Questie.debugSession], entry)
        if Questie.db.global.debugEnabledPrint then
            Questie:Print(...)
        end
    end
end

function Questie:debug(...)
    Questie:Debug(...)
end
