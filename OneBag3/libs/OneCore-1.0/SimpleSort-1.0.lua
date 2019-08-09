--- **OneSuite-SimpleSort-1.0** provides a simple sort plugin for the OneSuite
-- @class file
-- @name SimpleSort-1.0.lua
local MAJOR, MINOR = "OneSuite-SimpleSort-1.0", tonumber("56") or 9999
local SimpleSort, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not SimpleSort then return end -- No Upgrade needed.

--- This will setup the embed function on the library as well as upgrade any old embeds will also upgrade the store
-- @param lib the library being setup
-- @param store a table used to keep track of what was previously embedded, this is for upgrading.
-- @param mixins a table of what needs to be mixed in    
local function setup_load_embed_and_upgrade(lib, store, pluginType, pluginName, mixins)        
    
    if lib.embeded then
        lib.embedded = lib.embeded
        lib.embeded = nil
    end
    
    lib[store] = lib[store] or {}
    store = lib[store]
    
    local function Embed(self, target)
        for k, v in pairs(mixins) do
            if type(k) == "number" then
                target[v] = self[v]
            else
                target[k] = type(v) == "string" and self[v] or v
            end 
        end
        store[target] = true
    end                     
    
    lib.Embed = Embed
    
    local function LoadPluginForAddon(self, addon)
        local plugin = addon:NewPlugin(pluginType, pluginName)
        self:Embed(plugin)
        return plugin
    end              
    
    lib.LoadPluginForAddon = LoadPluginForAddon
    
    for target, v in pairs(store) do
       lib:Embed(target)
    end
end
   
setup_load_embed_and_upgrade(SimpleSort, 'embedded', 'sorting', 'SimpleSort', {
    description = 'Very simple sort, just puts the slot in order.  This is the default sort.', 
    defaults = {        
        profile = {       
            enabled = true,
            behavior = {
                bagbreak = false,
                valign = 1,
                bagorder = 1,
            },
        },
    },
    "OnInitialize",
    "OnEnable", 
    "OnDisable",  
    "IsEnabled",
    "SetEnabled",
    "LoadCustomConfig", 
    "UnloadCustomConfig", 
    "GetSlotOrder"
})

function SimpleSort:OnInitialize()
    self.db = self.pluginFor.db:GetNamespace(self.pluginName, true)
    
    if not self.db then
       self.db = self.pluginFor.db:RegisterNamespace(self.pluginName, self.defaults)
    end 
end     

function SimpleSort:IsEnabled()
   return self.db.profile.enabled
end                                  

function SimpleSort:SetEnabled(value)
   self.db.profile.enabled = value
end

function SimpleSort:OnEnable()
    if not self:IsEnabled() then        
        self:SetEnabledState(false)
        return false
    end
    
    if self.pluginFor.configs then
        self:LoadCustomConfig(self.pluginFor.configs.base)
    end
    
    return true
end                        

function SimpleSort:OnDisable()
    if self.pluginFor.configs then
        self:UnloadCustomConfig(self.pluginFor.configs.base)
    end
end

function SimpleSort:LoadCustomConfig(baseconfig)
    local db = self.db
    
    baseconfig.args.frame.args.bag.plugins['SimpleSort'] = {
        bagbreak = {
            order = 2,
            type = "toggle",
            name = "Bag Break",
            desc = "Forces a row break to happen at the end of each bag.",
            get = function(info)
                return db.profile.behavior.bagbreak
            end,
            set = function(info, value)
                db.profile.behavior.bagbreak = value
                self.pluginFor:OrganizeFrame(true)
            end
        },
        valign = {
            order = 11,
            type = 'select',
            name = 'Vertical Alignment',
            values = {'Top', 'Bottom'},
            style = 'radio',
            get = function(info)
                return db.profile.behavior.valign
            end,
            set = function(info, value)
                db.profile.behavior.valign = value
                self.pluginFor:OrganizeFrame(true)
            end
        },
        bagorder = {
            order = 12,
            type = 'select',
            name = "Bag Order",
            desc = "Controls the order which the bags are shown.",
            values = {'Normal', 'Backwards'},
            style = 'radio',
            get = function(info)
                return db.profile.behavior.bagorder
            end,
            set = function(info, value)
                db.profile.behavior.bagorder = value
                self.pluginFor:OrganizeFrame(true)
            end
        },
    } 
end  

function SimpleSort:UnloadCustomConfig(baseconfig)
    baseconfig.args.frame.args.bag.plugins['SimpleSort'] = nil
end

function SimpleSort:GetSlotOrder()
    local slots = {}
 
    if self.db.profile.behavior.bagorder == 2 then
        start, stop, step = #self.pluginFor.bagIndexes, 1, -1
    else
        start, stop, step = 1, #self.pluginFor.bagIndexes, 1
    end

    for i=start, stop, step do
        bagid = self.pluginFor.bagIndexes[i]

        for slotid = 1, self.pluginFor.frame.bags[bagid].size do
            table.insert(slots,  self.pluginFor.frame.slots[('%s:%s'):format(bagid, slotid)])
        end 
     
        if self.db.profile.behavior.bagbreak then
            table.insert(slots, "NEWLINE")
        end
    end
 
    if self.db.profile.behavior.valign == 2 and not self.db.profile.behavior.bagbreak then
        local totalSlots, cols = #slots, self.pluginFor.db.profile.appearance.cols
        local leftover = math.fmod(totalSlots, cols)
        local spaces = leftover > 0 and cols - leftover or 0
        for i=1, spaces do
            table.insert(slots, 1, "BLANK")
        end
    end
 
    return slots
end                           

if not oldminor then LibStub("OnePlugin-1.0"):RegisterPluginFactory(MAJOR, 'sorting') end
