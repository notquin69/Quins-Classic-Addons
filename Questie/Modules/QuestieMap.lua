QuestieMap = {...}
QuestieMap.ICON_MAP_TYPE = "MAP";
QuestieMap.ICON_MINIMAP_TYPE = "MINIMAP";

-- List of frames sorted by quest ID (automatic notes)
-- E.g. {[questId] = {[frameName] = frame, ...}, ...}
-- For details about frame.data see calls to QuestieMap.DrawWorldIcon
QuestieMap.questIdFrames = {}
-- List of frames sorted by NPC/object ID (manual notes)
-- id > 0: NPC
-- id < 0: object
-- E.g. {[-objectId] = {[frameName] = frame, ...}, ...}
-- For details about frame.data see QuestieMap.ShowNPC and QuestieMap.ShowObject
QuestieMap.manualFrames = {}

local HBD = LibStub("HereBeDragonsQuestie-2.0")
local HBDPins = LibStub("HereBeDragonsQuestie-Pins-2.0")
local HBDMigrate = LibStub("HereBeDragonsQuestie-Migrate")


-- copypaste from old questie (clean up later)
QUESTIE_NOTES_CLUSTERMUL_HACK = 1; -- smaller numbers = less icons on map
QuestieMap.MapCache_ClutterFix = {};
QuestieMap.drawTimer = nil;

function QuestieMap:DrawWorldMap(QuestID)

end

--Get the frames for a quest, this returns all of the frames
function QuestieMap:GetFramesForQuest(QuestId)
    local frames = {}
    --If no frames exists or if the quest does not exist we just return an empty list
    if (QuestieMap.questIdFrames[QuestId]) then
        for i, name in ipairs(QuestieMap.questIdFrames[QuestId]) do
            table.insert(frames, _G[name])
        end
    end
    return frames
end

function QuestieMap:UnloadQuestFrames(questId, iconType)
    if(QuestieMap.questIdFrames[questId]) then
        if(iconType == nil) then
            for index, frame in ipairs(QuestieMap:GetFramesForQuest(questId)) do
                frame:Unload();
            end
            QuestieMap.questIdFrames[questId] = nil;
        else
            for index, frame in ipairs(QuestieMap:GetFramesForQuest(questId)) do
                if(frame and frame.data and frame.data.Icon == iconType) then
                    frame:Unload();
                end
            end
        end
        Questie:Debug(DEBUG_DEVELOP, "[QuestieMap]: ".. QuestieLocale:GetUIString('DEBUG_UNLOAD_QFRAMES', questId))
    end
end

--Get the frames for manual note, this returns all of the frames/spawns
---@param id integer @The ID of the NPC (>0) or object (<0)
function QuestieMap:GetManualFrames(id)
    local frames = {}
    --If no frames exists or if the quest does not exist we just return an empty list
    if (QuestieMap.manualFrames[id]) then
        for _, name in pairs(QuestieMap.manualFrames[id]) do
            table.insert(frames, _G[name])
        end
    end
    return frames
end

---@param id integer @The ID of the NPC (>0) or object (<0)
function QuestieMap:UnloadManualFrames(id)
    if(QuestieMap.manualFrames[id]) then
        for index, frame in ipairs(QuestieMap:GetManualFrames(id)) do
            frame:Unload();
        end
        QuestieMap.manualFrames[id] = nil;
    end
end

-- Rescale a single icon
---@param frameName string @The global name of the icon frame, e.g. "QuestieFrame1"
local function rescaleIcon(frameName)
    local frame = _G[frameName]
    if frame and frame.data then
        if(frame.data.GetIconScale) then
            frame.data.IconScale = frame.data:GetIconScale();
            local scale = nil
            if(frame.miniMapIcon) then
                scale = 16 * (frame.data.IconScale or 1) * (Questie.db.global.globalMiniMapScale or 0.7);
            else
                scale = 16 * (frame.data.IconScale or 1) * (Questie.db.global.globalScale or 0.7);
            end

            if scale > 1 then
                frame:SetWidth(scale)
                frame:SetHeight(scale)
            end
        else
            Questie:Error("A frame is lacking the GetIconScale function for resizing!", frame.data.Id);
        end
    end
end

-- Rescale all the icons
function QuestieMap:RescaleIcons()
    for _, framelist in pairs(QuestieMap.questIdFrames) do
        for _, frameName in ipairs(framelist) do
            rescaleIcon(frameName)
        end
    end
    for _, framelist in pairs(QuestieMap.manualFrames) do
        for _, frameName in ipairs(framelist) do
            rescaleIcon(frameName)
        end
    end
end

local tinsert = table.insert;
local tpack = table.pack;
local tremove = table.remove;
local tunpack = unpack;
local mapDrawQueue = {};
local minimapDrawQueue = {};
function QuestieMap:InitializeQueue()
    Questie:Debug(DEBUG_DEVELOP, "[QuestieMap] Starting draw queue timer!")
    QuestieMap.drawTimer = C_Timer.NewTicker(0.005, QuestieMap.ProcessQueue)
end

function QuestieMap:QueueDraw(drawType, ...)
  if(drawType == QuestieMap.ICON_MAP_TYPE) then
    tinsert(mapDrawQueue, {...});
  elseif(drawType == QuestieMap.ICON_MINIMAP_TYPE) then
    tinsert(minimapDrawQueue, {...});
  end
end

function QuestieMap:ProcessQueue()
  local mapDrawCall = tremove(mapDrawQueue, 1);
  if(mapDrawCall) then
    HBDPins:AddWorldMapIconMap(tunpack(mapDrawCall));
  end
  local minimapDrawCall = tremove(minimapDrawQueue, 1);
  if(minimapDrawCall) then
    HBDPins:AddMinimapIconMap(tunpack(minimapDrawCall));
  end
end

-- Show NPC on map
-- This function does the same for manualFrames as similar functions in
-- QuestieQuest do for questIdFrames
---@param npcID integer @The ID of the NPC
function QuestieMap:ShowNPC(npcID)
    if type(npcID) ~= "number" then return end
    -- get the NPC data
    local npc = QuestieDB:GetNPC(npcID)
    if npc == nil then return end

    -- create the icon data
    local data = {}
    data.id = npc.id
    data.Icon = "Interface\\WorldMap\\WorldMapPartyIcon"
    data.GetIconScale = function() return Questie.db.global.manualScale or 0.7 end
    data.IconScale = data:GetIconScale()
    data.Type = "manual"
    data.spawnType = "monster"
    data.npcData = npc
    data.Name = npc.name
    data.IsObjectiveNote = false
    data.ManualTooltipData = {}
    data.ManualTooltipData.Title = npc.name.." (NPC)"
    local level = tostring(npc.minLevel)
    local health = tostring(npc.minLevelHealth)
    if npc.minLevel ~= npc.maxLevel then
        level = level..'-'..tostring(npc.maxLevel)
        health = health..'-'..tostring(npc.maxLevelHealth)
    end
    data.ManualTooltipData.Body = {
        {'ID:', tostring(npc.id)},
        {'Level:', level},
        {'Health:', health},
    }

    -- draw the notes
    for zone, spawns in pairs(npc.spawns) do
        if(zone ~= nil and spawns ~= nil) then
            for _, coords in ipairs(spawns) do
                -- instance spawn, draw entrance on map
                if (instanceData[zone] ~= nil) then
                    for index, value in ipairs(instanceData[zone]) do
                        QuestieMap:DrawManualIcon(data, value[1], value[2], value[3])
                    end
                -- world spawn
                else
                    QuestieMap:DrawManualIcon(data, zone, coords[1], coords[2])
                end
            end
        end
    end
end

-- Show object on map
-- This function does the same for manualFrames as similar functions in
-- QuestieQuest do for questIdFrames
---@param objectID integer
function QuestieMap:ShowObject(objectID)
    if type(objectID) ~= "number" then return end
    -- get the gameobject data
    local object = QuestieDB:GetObject(objectID)
    if object == nil then return end

    -- create the icon data
    local data = {}
    data.id = -object.id
    data.Icon = "Interface\\WorldMap\\WorldMapPartyIcon"
    data.GetIconScale = function() return Questie.db.global.manualScale or 0.7 end
    data.IconScale = data:GetIconScale()
    data.Type = "manual"
    data.spawnType = "object"
    data.objectData = object
    data.Name = object.name
    data.IsObjectiveNote = false
    data.ManualTooltipData = {}
    data.ManualTooltipData.Title = object.name.." (object)"
    data.ManualTooltipData.Body = {
        {'ID:', tostring(object.id)},
    }

    -- draw the notes
    for zone, spawns in pairs(object.spawns) do
        if(zone ~= nil and spawns ~= nil) then
            for _, coords in ipairs(spawns) do
                -- instance spawn, draw entrance on map
                if (instanceData[zone] ~= nil) then
                    for index, value in ipairs(instanceData[zone]) do
                        QuestieMap:DrawManualIcon(data, value[1], value[2], value[3])
                    end
                -- world spawn
                else
                    QuestieMap:DrawManualIcon(data, zone, coords[1], coords[2])
                end
            end
        end
    end
end

-- Draw manually added NPC/object notes
-- TODO: item and custom notes
--@param data table<...> @A table created by the calling function, must contain `id`, `Name`, `GetIconScale()`, and `Type`
--@param AreaID integer @The zone ID from the raw data
--@param x float @The X coordinate in 0-100 format
--@param y float @The Y coordinate in 0-100 format
function QuestieMap:DrawManualIcon(data, AreaID, x, y)
    if type(data) ~= "table" then
        error(MAJOR..": AddWorldMapIconMap: must have some data")
    end
    if type(AreaID) ~= "number" or type(x) ~= "number" or type(y) ~= "number" then
        error(MAJOR..": AddWorldMapIconMap: 'AreaID', 'x' and 'y' must be numbers "..AreaID.." "..x.." "..y)
    end
    if type(data.id) ~= "number" or type(data.id) ~= "number"then
        error(MAJOR.."Data.id must be set to the NPC or object ID!")
    end
    if zoneDataAreaIDToUiMapID[AreaID] == nil then
        --Questie:Error("No UiMapID for ("..tostring(zoneDataClassic[AreaID])..") :".. AreaID .. tostring(data.Name))
        return nil, nil
    end
    -- set the icon
    local texture = "Interface\\WorldMap\\WorldMapPartyIcon"
    -- Save new zone ID format, used in QuestieFramePool
    data.UiMapID = zoneDataAreaIDToUiMapID[AreaID]
    -- create a list for all frames belonging to a NPC (id > 0) or an object (id < 0)
    if(QuestieMap.manualFrames[data.id] == nil) then
        QuestieMap.manualFrames[data.id] = {}
    end

    -- create the map icon
    local icon = QuestieFramePool:GetFrame()
    icon.data = data
    icon.x = x
    icon.y = y
    icon.AreaID = AreaID -- used by QuestieFramePool
    icon.miniMapIcon = false;
    icon.texture:SetTexture(texture)
    icon:SetWidth(16 * (data:GetIconScale() or 0.7))
    icon:SetHeight(16 * (data:GetIconScale() or 0.7))

    -- add the map icon
    QuestieMap:QueueDraw(QuestieMap.ICON_MAP_TYPE, Questie, icon, data.UiMapID, x/100, y/100, 3) -- showFlag)
    table.insert(QuestieMap.manualFrames[data.id], icon:GetName())

    -- create the minimap icon
    local iconMinimap = QuestieFramePool:GetFrame()
    local colorsMinimap = {1, 1, 1}
    if data.IconColor ~= nil and Questie.db.global.questMinimapObjectiveColors then
        colorsMinimap = data.IconColor
    end
    iconMinimap:SetWidth(16 * ((data:GetIconScale() or 1) * (Questie.db.global.globalMiniMapScale or 0.7)))
    iconMinimap:SetHeight(16 * ((data:GetIconScale() or 1) * (Questie.db.global.globalMiniMapScale or 0.7)))
    iconMinimap.data = data
    iconMinimap.x = x
    iconMinimap.y = y
    iconMinimap.AreaID = AreaID -- used by QuestieFramePool
    iconMinimap.texture:SetTexture(texture)
    iconMinimap.texture:SetVertexColor(colorsMinimap[1], colorsMinimap[2], colorsMinimap[3], 1);
    iconMinimap.miniMapIcon = true;

    -- add the minimap icon
    QuestieMap:QueueDraw(QuestieMap.ICON_MINIMAP_TYPE, Questie, iconMinimap, data.UiMapID, x / 100, y / 100, true, true);
    table.insert(QuestieMap.manualFrames[data.id], iconMinimap:GetName())

    -- make sure notes are only shown when they are supposed to
    if (QuestieQuest.NotesHidden) then -- TODO: or (not Questie.db.global.manualNotes)
        icon:FakeHide()
        iconMinimap:FakeHide()
    else
        if (not Questie.db.global.enableMapIcons) then
            icon:FakeHide()
        end
        if (not Questie.db.global.enableMiniMapIcons) then
            iconMinimap:FakeHide()
        end
    end

    -- return the frames in case they need to be stored seperately from QuestieMap.manualFrames
    return icon, iconMinimap;
end

--A layer to keep the area convertion away from the other parts of the code
--coordinates need to be 0-1 instead of 0-100
--showFlag isn't required but may want to be Modified
function QuestieMap:DrawWorldIcon(data, AreaID, x, y, showFlag)
    if type(data) ~= "table" then
        error(MAJOR..": AddWorldMapIconMap: must have some data")
    end
    if type(AreaID) ~= "number" or type(x) ~= "number" or type(y) ~= "number" then
        error(MAJOR..": AddWorldMapIconMap: 'AreaID', 'x' and 'y' must be numbers "..AreaID.." "..x.." "..y.." "..showFlag)
    end
    if type(data.Id) ~= "number" or type(data.Id) ~= "number"then
        error(MAJOR.."Data.Id must be set to the quests ID!")
    end
    if zoneDataAreaIDToUiMapID[AreaID] == nil then
        --Questie:Error("No UiMapID for ("..tostring(zoneDataClassic[AreaID])..") :".. AreaID .. tostring(data.Name))
        return nil, nil
    end
    if(showFlag == nil) then showFlag = HBD_PINS_WORLDMAP_SHOW_WORLD; end
    -- if(floatOnEdge == nil) then floatOnEdge = true; end
    local floatOnEdge = true

    -- check toggles (not anymore, we need to add then hide)
    --if data.Type then
    --   if (((not Questie.db.global.enableObjectives) and (data.Type == "monster" or data.Type == "object" or data.Type == "event" or data.Type == "item"))
    --     or ((not Questie.db.global.enableTurnins) and data.Type == "complete")
    --     or ((not Questie.db.global.enableAvailable) and data.Type == "available")) then
    --        return -- dont add icon
    --    end
    --end

    -- check clustering
    local xcell = math.floor((x * (QUESTIE_NOTES_CLUSTERMUL_HACK)));
    local ycell = math.floor((x * (QUESTIE_NOTES_CLUSTERMUL_HACK)));

    if QuestieMap.MapCache_ClutterFix[AreaID] == nil then QuestieMap.MapCache_ClutterFix[AreaID] = {}; end
    if QuestieMap.MapCache_ClutterFix[AreaID][xcell] == nil then QuestieMap.MapCache_ClutterFix[AreaID][xcell] = {}; end
    if QuestieMap.MapCache_ClutterFix[AreaID][xcell][ycell] == nil then QuestieMap.MapCache_ClutterFix[AreaID][xcell][ycell] = {}; end


    if (not data.ClusterId) or (not QuestieMap.MapCache_ClutterFix[AreaID][xcell][ycell][data.ClusterId]) then -- the reason why we only prevent adding to HBD is so its easy to "unhide" if we need to, and so the refs still exist
        if data.ClusterId then
            QuestieMap.MapCache_ClutterFix[AreaID][xcell][ycell][data.ClusterId] = true
        end
        --QuestieMap.MapCache_ClutterFix[AreaID][xcell][ycell][data.ObjectiveTargetId] = true
        local icon = QuestieFramePool:GetFrame()
        icon.data = data
        icon.x = x
        icon.y = y
        icon.AreaID = AreaID
        icon.miniMapIcon = false;
        if AreaID then
            data.UiMapID = zoneDataAreaIDToUiMapID[AreaID];
        end


        icon.texture:SetTexture(data.Icon) -- todo: implement .GlowIcon
        local colors = {1, 1, 1}
        if data.IconColor ~= nil and Questie.db.global.questObjectiveColors then
            colors = data.IconColor
        end
        icon.texture:SetVertexColor(colors[1], colors[2], colors[3], 1);
        -- because of how frames work, I cant seem to set the glow as being behind the note. So for now things are draw in reverse.
        if data.IconScale then
            local scale = 16 * (data:GetIconScale()*(Questie.db.global.globalScale or 0.7));
            icon:SetWidth(scale)
            icon:SetHeight(scale)
        else
            icon:SetWidth(16)
            icon:SetHeight(16)
        end

        local iconMinimap = QuestieFramePool:GetFrame()
        local colorsMinimap = {1, 1, 1}
        if data.IconColor ~= nil and Questie.db.global.questMinimapObjectiveColors then
            colorsMinimap = data.IconColor
        end
        iconMinimap:SetWidth(16 * ((data:GetIconScale() or 1) * (Questie.db.global.globalMiniMapScale or 0.7)))
        iconMinimap:SetHeight(16 * ((data:GetIconScale() or 1) * (Questie.db.global.globalMiniMapScale or 0.7)))
        iconMinimap.data = data
        iconMinimap.x = x
        iconMinimap.y = y
        iconMinimap.AreaID = AreaID
        --data.refMiniMap = iconMinimap -- used for removing
        iconMinimap.texture:SetTexture(data.Icon)
        iconMinimap.texture:SetVertexColor(colorsMinimap[1], colorsMinimap[2], colorsMinimap[3], 1);
        --Are we a minimap note?
        iconMinimap.miniMapIcon = true;

        if(not iconMinimap.FadeLogic) then
            function iconMinimap:FadeLogic()
                if self.miniMapIcon and self.x and self.y and self.texture and self.texture.SetVertexColor and Questie and Questie.db and Questie.db.global and Questie.db.global.fadeLevel and HBD and HBD.GetPlayerZonePosition and QuestieLib and QuestieLib.Euclid then
                    local playerX, playerY, playerInstanceID = HBD:GetPlayerZonePosition()
                    if(playerX and playerY) then
                        local distance = QuestieLib:Euclid(playerX, playerY, self.x / 100, self.y / 100);

                        --Very small value before, hard to work with.
                        distance = distance * 10
                        local NormalizedValue = 1 / (Questie.db.global.fadeLevel or 1.5);

                        if(distance > 0.6) then
                            local fadeAmount = (1 - NormalizedValue * distance) + 0.5
                            if self.faded and fadeAmount > Questie.db.global.iconFadeLevel then fadeAmount = Questie.db.global.iconFadeLevel end
                            local dr,dg,db = self.texture:GetVertexColor()
                            self.texture:SetVertexColor(dr, dg, db, fadeAmount)
                            if self.glowTexture and self.glowTexture.GetVertexColor then
                                local r,g,b = self.glowTexture:GetVertexColor()
                                self.glowTexture:SetVertexColor(r,g,b,fadeAmount)
                            end
                        elseif (distance < Questie.db.global.fadeOverPlayerDistance) and Questie.db.global.fadeOverPlayer then
                            local fadeAmount = QuestieLib:Remap(distance, 0, Questie.db.global.fadeOverPlayerDistance, Questie.db.global.fadeOverPlayerLevel, 1);
                           -- local fadeAmount = math.max(fadeAmount, 0.5);
                            if self.faded and fadeAmount > Questie.db.global.iconFadeLevel then fadeAmount = Questie.db.global.iconFadeLevel end
                            local dr,dg,db = self.texture:GetVertexColor()
                            self.texture:SetVertexColor(dr, dg, db, fadeAmount)
                            if self.glowTexture and self.glowTexture.GetVertexColor then
                                local r,g,b = self.glowTexture:GetVertexColor()
                                self.glowTexture:SetVertexColor(r,g,b,fadeAmount)
                            end
                        else
                            if self.faded then
                                local dr,dg,db = self.texture:GetVertexColor()
                                self.texture:SetVertexColor(dr, dg, db, Questie.db.global.iconFadeLevel)
                                if self.glowTexture and self.glowTexture.GetVertexColor then
                                    local r,g,b = self.glowTexture:GetVertexColor()
                                    self.glowTexture:SetVertexColor(r,g,b,Questie.db.global.iconFadeLevel)
                                end
                            else
                                local dr,dg,db = self.texture:GetVertexColor()
                                self.texture:SetVertexColor(dr, dg, db, 1)
                                if self.glowTexture and self.glowTexture.GetVertexColor then
                                    local r,g,b = self.glowTexture:GetVertexColor()
                                    self.glowTexture:SetVertexColor(r,g,b,1)
                                end
                            end
                        end
                    else
                        if self.faded then
                            local dr,dg,db = self.texture:GetVertexColor()
                            self.texture:SetVertexColor(dr, dg, db, Questie.db.global.iconFadeLevel)
                            if self.glowTexture and self.glowTexture.GetVertexColor then
                                local r,g,b = self.glowTexture:GetVertexColor()
                                self.glowTexture:SetVertexColor(r,g,b,Questie.db.global.iconFadeLevel)
                            end
                        else
                            local dr,dg,db = self.texture:GetVertexColor()
                            self.texture:SetVertexColor(dr, dg, db, 1)
                            if self.glowTexture and self.glowTexture.GetVertexColor then
                                local r,g,b = self.glowTexture:GetVertexColor()
                                self.glowTexture:SetVertexColor(r,g,b,1)
                            end
                        end
                    end
                end
            end
            iconMinimap.fadeLogicTimer = C_Timer.NewTicker(0.3, function()
                --Only run if these two are true!
                if (iconMinimap.FadeLogic and iconMinimap.miniMapIcon) then
                   iconMinimap:FadeLogic()
                end
                if iconMinimap.glowUpdate then
                    iconMinimap:glowUpdate()
                end
            end);
            -- We do not want to hook the OnUpdate again!
            -- iconMinimap:SetScript("OnUpdate", )
        end

        if Questie.db.global.enableMiniMapIcons then
            QuestieMap:QueueDraw(QuestieMap.ICON_MINIMAP_TYPE, Questie, iconMinimap, zoneDataAreaIDToUiMapID[AreaID], x / 100, y / 100, true, floatOnEdge);
            --HBDPins:AddMinimapIconMap(Questie, iconMinimap, zoneDataAreaIDToUiMapID[AreaID], x / 100, y / 100, true, floatOnEdge)
        end
        if Questie.db.global.enableMapIcons then
            QuestieMap:QueueDraw(QuestieMap.ICON_MAP_TYPE, Questie, icon, zoneDataAreaIDToUiMapID[AreaID], x / 100, y / 100, showFlag);
            QuestieDBMIntegration:RegisterHudQuestIcon(tostring(icon), data.Icon, zoneDataAreaIDToUiMapID[AreaID], x, y, colors[1], colors[2], colors[3])
            --HBDPins:AddWorldMapIconMap(Questie, icon, zoneDataAreaIDToUiMapID[AreaID], x / 100, y / 100, showFlag)
        end
        if(QuestieMap.questIdFrames[data.Id] == nil) then
            QuestieMap.questIdFrames[data.Id] = {}
        end

        table.insert(QuestieMap.questIdFrames[data.Id], icon:GetName())
        table.insert(QuestieMap.questIdFrames[data.Id], iconMinimap:GetName())

        -- preset hidden state when needed (logic from QuestieQuest:UpdateHiddenNotes
        -- we should add all this code to something like obj:CheckHide() instead of copying it
        if (QuestieQuest.NotesHidden or (((not Questie.db.global.enableObjectives) and (icon.data.Type == "monster" or icon.data.Type == "object" or icon.data.Type == "event" or icon.data.Type == "item"))
                 or ((not Questie.db.global.enableTurnins) and icon.data.Type == "complete")
                 or ((not Questie.db.global.enableAvailable) and icon.data.Type == "available"))
                 or ((not Questie.db.global.enableMapIcons) and (not icon.miniMapIcon))
                 or ((not Questie.db.global.enableMiniMapIcons) and (icon.miniMapIcon))) or (icon.data.ObjectiveData and icon.data.ObjectiveData.HideIcons) or (icon.data.QuestData and icon.data.QuestData.HideIcons and icon.data.Type ~= "complete") then
            icon:FakeHide()
            iconMinimap:FakeHide()
        end

        return icon, iconMinimap;
    end
    return nil, nil
end

--function QuestieMap:RemoveIcon(ref)
--    HBDPins:RemoveWorldMapIcon(Questie, ref)
--end


--DOES NOT WORK
--Temporary functions, will probably need to ge redone.
function QuestieMap:GetZoneDBMapIDFromRetail(Zoneid)
    --Need to manually fix the names above to match.
    for continentID, Zone in pairs(Map) do
        for ZoneIDClassic, NameClassic in pairs(zoneDataClassic) do
            if(Zone[Zoneid] == NameClassic) then
                return ZoneIDClassic
            end
        end
    end
    return nil --DunMorogh
end

--DOES NOT WORK
function QuestieMap:GetRetailMapIDFromZoneDB(Zoneid)
    --Need to manually fix the names above to match.
    for continentID, Zones in pairs(Map) do
        for ZoneIDRetail, NameRetail in pairs(Zones) do
            if(zoneDataClassic[Zoneid] == nil) then return nil; end
            if(NameRetail == zoneDataClassic[Zoneid]) then
                return continentID, ZoneIDRetail
            end
        end
    end
    return nil --DunMorogh
end

--DOES NOT WORK
function GetWorldContinentFromZone(ZoneID)
    if(Map[0][ZoneID] ~= nil)then
        return 0
    elseif(Map[1][ZoneID] ~= nil)then
        return 1
    end
end
