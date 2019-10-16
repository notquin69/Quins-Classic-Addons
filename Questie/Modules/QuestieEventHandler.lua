local function _Hack_prime_log() -- this seems to make it update the data much quicker
  for i=1,GetNumQuestLogEntries()+1 do
    GetQuestLogTitle(i)
    QuestieQuest:GetRawLeaderBoardDetails(i)
  end
end

--- GLOBAL ---
QuestieEventHandler = {}
__UPDATEFIX_IDX = 1; -- temporary bad fix

--- LOCAL ---
--False -> true -> nil
local playerEntered = false;
local hasFirstQLU = false;
local runQLU = false

function QuestieEventHandler:PLAYER_ENTERING_WORLD()
    C_Timer.After(1, function()
        QuestieDB:Initialize()
    end)
    C_Timer.After(4, function()
        -- We want the framerate to be HIGH!!!
        QuestieMap:InitializeQueue();
        _Hack_prime_log()
        QuestiePlayer:Initialize();
        QuestieQuest:Initialize()
        QuestieQuest:GetAllQuestIdsNoObjectives()
        QuestieQuest:CalculateAvailableQuests()
        QuestieQuest:DrawAllAvailableQuests()
        QuestieNameplate:Initialize();
        Questie:Debug(DEBUG_ELEVATED, "PLAYER_ENTERED_WORLD")
        playerEntered = true
        -- manually fire QLU since enter has been delayed past the first QLU
        if hasFirstQLU then
            QuestieEventHandler:QUEST_LOG_UPDATE()
        end
    end)
end

--Fires when a quest is accepted in anyway.
function QuestieEventHandler:QUEST_ACCEPTED(questLogIndex, questId)
    Questie:Debug(DEBUG_DEVELOP, "EVENT: QUEST_ACCEPTED", "QLogIndex: "..questLogIndex,  "QuestID: "..questId);
    _Hack_prime_log()

    QuestieQuest:AcceptQuest(questId)
    QuestieJourney:AcceptQuest(questId)
end

-- Needed to distinguish finished quests from abandoned quests
local finishedEventReceived = false

-- Fires when a quest is removed from the questlog, this includes turning it in
-- and abandoning it.
function QuestieEventHandler:QUEST_REMOVED(questID)
    Questie:Debug(DEBUG_DEVELOP, "EVENT: QUEST_REMOVED", questID);
    _Hack_prime_log()
    if finishedEventReceived == questID then
        finishedEventReceived = false
        runQLU = true
        QuestieQuest:CompleteQuest(questID)
        QuestieJourney:CompleteQuest(questID)
        return
    end
    QuestieQuest:AbandonedQuest(questID)
    QuestieJourney:AbandonQuest(questID)
end

-- Fires when a quest is turned in, but before it is remove from the quest log.
-- We need to save the ID of the finished quest to check it in QR event.
function QuestieEventHandler:QUEST_TURNED_IN(questID, xpReward, moneyReward)
    Questie:Debug(DEBUG_DEVELOP, "EVENT: QUEST_TURNED_IN", questID, xpReward, moneyReward)
    _Hack_prime_log()
    finishedEventReceived = questID
end

-- Fires when the quest log changes. That includes visual changes and
-- client/server communication, so not every event really updates the log data.
function QuestieEventHandler:QUEST_LOG_UPDATE()
    Questie:Debug(DEBUG_DEVELOP, "QUEST_LOG_UPDATE")
    hasFirstQLU = true
    if playerEntered then
        Questie:Debug(DEBUG_DEVELOP, "---> Player entered world, START.")
        C_Timer.After(1, function ()
            Questie:Debug(DEBUG_DEVELOP, "---> Player entered world, DONE.")
            QuestieQuest:GetAllQuestIds()
            QuestieTracker:Initialize()
            QuestieTracker:Update()
        end)
        playerEntered = nil;
    end

    -- QR or UQLC events have set the flag, so we need to update Questie state.
    if runQLU then
        QuestieQuest:CompareQuestHashes()
        runQLU = false
    end
end

-- Fired before data for quest log changes, including other players.
function QuestieEventHandler:UNIT_QUEST_LOG_CHANGED(unitTarget)
    -- If the unitTarget is "player" the changed log is from "our" player and
    -- we need to tell the next QLU event to check the quest log for updated
    -- data.
    if unitTarget == "player" then
        Questie:Debug(DEBUG_DEVELOP, "UNIT_QUEST_LOG_CHANGED: player")
        runQLU = true
    end
end

function QuestieEventHandler:PLAYER_LEVEL_UP(level, hitpoints, manapoints, talentpoints, ...)
    Questie:Debug(DEBUG_DEVELOP, "EVENT: PLAYER_LEVEL_UP", level);

    QuestiePlayer:SetPlayerLevel(level);

    -- deferred update (possible desync fix?)
    C_Timer.After(3, function()
        QuestiePlayer:SetPlayerLevel(level);

        QuestieQuest:CalculateAvailableQuests();
        QuestieQuest:DrawAllAvailableQuests();
    end)
    QuestieJourney:PlayerLevelUp(level);
end

function QuestieEventHandler:MODIFIER_STATE_CHANGED(key, down)
    if GameTooltip and GameTooltip:IsShown() and GameTooltip._Rebuild then
        GameTooltip:Hide()
        GameTooltip:ClearLines()
        GameTooltip:SetOwner(GameTooltip._owner, "ANCHOR_CURSOR");
        GameTooltip:_Rebuild() -- rebuild the tooltip
        GameTooltip:SetFrameStrata("TOOLTIP");
        GameTooltip:Show()
    end
end

-- Fired when some chat messages about skills are displayed
function QuestieEventHandler:CHAT_MSG_SKILL()
    Questie:Debug(DEBUG_DEVELOP, "CHAT_MSG_SKILL")
    QuestieProfessions:Update()
end

-- Fired when some chat messages about reputations are displayed
function QuestieEventHandler:CHAT_MSG_COMBAT_FACTION_CHANGE()
    Questie:Debug(DEBUG_DEVELOP, "CHAT_MSG_COMBAT_FACTION_CHANGE")
    QuestieReputation:Update()
end

local numOfMembers = -1;
function QuestieEventHandler:GROUP_ROSTER_UPDATE()
    local currentMembers = GetNumGroupMembers();
    -- Only want to do logic when number increases, not decreases.
    if(numOfMembers < currentMembers) then
        -- Tell comms to send information to members.
        --Questie:SendMessage("QC_ID_BROADCAST_FULL_QUESTLIST");
        numOfMembers = currentMembers;
    else
        -- We do however always want the local to be the current number to allow up and down.
        numOfMembers = currentMembers;
    end
end


--Old unused code

--This is used to see if they acually completed the quest or just fucking with us...
local NumberOfQuestInLog = -1

function QuestieEventHandler:QUEST_COMPLETE()
    local numEntries, numQuests = GetNumQuestLogEntries();
    NumberOfQuestInLog = numQuests;
    --Questie:Debug(DEBUG_CRITICAL, "EVENT: QUEST_COMPLETE", "Quests: "..numQuests);
end

function QuestieEventHandler:QUEST_FINISHED()
    local numEntries, numQuests = GetNumQuestLogEntries();
    if (NumberOfQuestInLog ~= numQuests) then
        --Questie:Debug(DEBUG_CRITICAL, "EVENT: QUEST_FINISHED", "CHANGE");
        NumberOfQuestInLog = -1
    end
    --Questie:Debug(DEBUG_CRITICAL, "EVENT: QUEST_FINISHED", "NO CHANGE");
end

function QuestieEventHandler:QUEST_LOG_CRITERIA_UPDATE(questID, specificTreeID, description, numFulfilled, numRequired)
    Questie:Debug(DEBUG_DEVELOP, "EVENT: QUEST_LOG_CRITERIA_UPDATE", questID, specificTreeID, description, numFulfilled, numRequired);
end

function QuestieEventHandler:CUSTOM_QUEST_COMPLETE()
    local numEntries, numQuests = GetNumQuestLogEntries();
    --Questie:Debug(DEBUG_CRITICAL, "CUSTOM_QUEST_COMPLETE", "Quests: "..numQuests);
end

-- DO NOT PUT CODE UNDER HERE!!!!!
