--- **OneCore-1.0** provides common code used by the onebag suite
-- @class file
-- @name OneCore-1.0.lua
local MAJOR, MINOR = "OneCore-1.0", tonumber("56") or 9999
local OneCore, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not OneCore then return end -- No Upgrade needed.

-- Upgrading Library Variables

--- This will setup the embed function on the library as well as upgrade any old embeds will also upgrade the store
-- @param lib the library being setup
-- @param store a table used to keep track of what was previously embedded, this is for upgrading.
-- @param mixins a table of what needs to be mixed in    
local function setup_embed_and_upgrade(lib, store, mixins)        
    
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
    
    for target, v in pairs(store) do
       lib:Embed(target)
    end
end

-- BAGTYPE_QUIVER = Quiver + Ammo
-- BAGTYPE_SOUL = Soul Bags                                                                   
-- BAGTYPE_PROFESSION = Leather + Inscription + Herb + Enchanting + Engineering + Gem + Mining
local BAGTYPE_QUIVER = 0x0001 + 0x0002 
local BAGTYPE_SOUL = 0x004
local BAGTYPE_PROFESSION = 0x0008 + 0x0010 + 0x0020 + 0x0040 + 0x0080 + 0x0200 + 0x0400 

local BagHelpers = {}

--- Returns whether the bag is an ammo bag
function BagHelpers:IsAmmoBag()
	if not self.type or self.type == 0 then return false end
	return bit.band(self.type, BAGTYPE_QUIVER) > 0
end
                                          
--- Returns whether the bag is a soul bag
function BagHelpers:IsSoulBag()
	if not self.type or self.type == 0 then return false end
	return bit.band(self.type, BAGTYPE_SOUL) > 0
end
                                         
--- Returns whether the bag is a profression/trade bag
function BagHelpers:IsProfessionBag()
	if not self.type or self.type == 0 then return false end
	return bit.band(self.type, BAGTYPE_PROFESSION) > 0
end                
                                                      
setup_embed_and_upgrade(BagHelpers, "bagEmbeded", {
    "IsAmmoBag",
    "IsSoulBag",
    "IsProfessionBag",
})
 

local SlotHelpers = {}

--- Determines if the given slot should show be shown.
function SlotHelpers:ShouldShow()
	local bag = self:GetParent()
	
	if bag:IsAmmoBag() and not self.handler.db.profile.show.ammo then 
		return false 
	end
	
	if bag:IsSoulBag() and not self.handler.db.profile.show.soul then 
		return false 
	end
	
	if bag:IsProfessionBag() and not self.handler.db.profile.show.profession then 
		return false 
	end
	
	return self.handler.db.profile.show[bag:GetID()]
end
   
setup_embed_and_upgrade(SlotHelpers, "slotEmbeded", {
    "ShouldShow",
})

--- Simple function to build a OneBag style bag object.
-- @param parent the parent frame for the bag
-- @param id the bag's numeric id
function OneCore:CreateBagFrame(parent, id)
	local bag = CreateFrame("Frame", parent:GetName().."Bag"..id, parent)
	bag:SetID(id)
	
	bag.meta = {}
	bag.slots = {}
	bag.handler = self
	
    BagHelpers:Embed(bag)
	
	return bag
end            

--- Simple function to build a OneBag style slot object
-- @param parent the parent frame for the slot, should be a OneBag bag object
-- @param id the slots's numeric id
function OneCore:CreateSlotFrame(parent, id)
	local bagID = parent:GetID()
	local slotType = "ContainerFrameItemButtonTemplate"
	
	if bagID == -1 then
		slotType = "BankItemButtonGenericTemplate"
	end
	
	local slot = CreateFrame("Button", parent:GetName().."Item"..id, parent, slotType)
	
	slot:SetID(id)
	slot:SetFrameLevel(parent:GetParent():GetFrameLevel()+5)
	
	slot.meta = {}
	slot.handler = self
	
	parent.slots[id] = slot
	
    SlotHelpers:Embed(slot) 
	
	return slot
end 

--- This function is responsible for creating all the children of the frame, this makes lazy creation possible
function OneCore:BuildFrame()
	for _, bag in pairs(self.bagIndexes) do
		local size = self:GetContainerNumSlots(bag)
		local bagType = select(2, GetContainerNumFreeSlots(bag))
		
		if not self.frame.bags then
			self.frame.bags = {}
		end
		
		if not self.frame.bags[bag] then
			self.frame.bags[bag] = self:CreateBagFrame(self.frame, bag)
		end		
		
		self.frame.bags[bag].type = bagType
		
		if self.frame.bags[bag].size ~= size then
			self.frame.bags[bag].size = size
			self.doOrganization = true
		end
		
		for slot = 1, size do
			slotkey = ('%s:%s'):format(bag, slot)
			if not self.frame.slots[slotkey] then
				self.frame.slots[slotkey] = self:CreateSlotFrame(self.frame.bags[bag], slot)
				self.frame.slots[slotkey]:SetFrameStrata(self.stratas[self.db.profile.behavior.strata])
				self.doOrganization = true
			end
		end
	end
end          

--- Organizes the frame to reflect the current available slots and options.       
-- @param force this will cause the frame to reorganize even if the slots haven't changed.
function OneCore:OrganizeFrame(force)
	if (not self.doOrganization and not force) or not self.frame.slots then
		return 
	end
	
	local cols, curCol, curRow, maxCol, justinc = self.forcedCols or self.db.profile.appearance.cols, 1, 1, 0, false
	
	for slotkey, slot in pairs(self.frame.slots) do
		slot:Hide()
	end
	
	for slotkey, slot in pairs(self:GetSlotOrder()) do
		if type(slot) == 'string' or slot:ShouldShow() then
			if slot.ClearAllPoints then
				justinc = false
				slot:ClearAllPoints()
				slot:SetPoint("TOPLEFT", self.frame:GetName(), "TOPLEFT", self.leftBorder + self.colWidth * (curCol - 1), 0 - self.topBorder - (self.rowHeight * curRow))
				slot:SetFrameLevel(self.frame:GetFrameLevel()+20)
				slot:Show()
				curCol = curCol + 1
			end
		
			if slot == "BLANK" then
				curCol = curCol + 1
			end
		
			maxCol = math.max(maxCol, curCol-1)
		
			if (curCol > cols or slot == "NEWLINE") and not justinc then
				curCol, curRow, justinc = 1, curRow + 1, true
			end
		end
	end
	
	if not justinc then curRow = curRow + 1 end
	self.frame:SetHeight(curRow * self.rowHeight + self.bottomBorder + self.topBorder) 
	self.frame:SetWidth(maxCol * self.colWidth + self.leftBorder + self.rightBorder)

	self.frame:SetPosition(self.db.profile.position)	

	self.doOrganization = false
end
                
--- This function will update a single bag and it's contents
-- @param bag the numeric id of the bag
function OneCore:UpdateBag(bag)
	if not self.frame.bags or not self.frame.bags[bag] then
		return
	end
	
	self:BuildFrame()
	self:OrganizeFrame()
	
	if not self.frame.bags[bag].colorLocked then
		for slot=1, self.frame.bags[bag].size do
			self:ColorSlotBorder(self:GetSlot(bag, slot))
		end
	end
	
	if self.frame.bags[bag].size and self.frame.bags[bag].size > 0 then
		ContainerFrame_Update(self.frame.bags[bag])
	end
end
       
--- This updates all bags and their contents
function OneCore:UpdateFrame()
	for _, bag in pairs(self.bagIndexes) do
		self:UpdateBag(bag)
	end
	
	for _, childFrame in pairs(self.frame.childrenFrames) do 
	    if childFrame:IsVisible() and childFrame.handler and childFrame.handler.UpdateFrame then
            childFrame.handler:UpdateFrame()
        end
	end	
end    

--- Helper function that returns a single slot
-- @param bag the bag's numeric id
-- @param slot the slot's numeric id
function OneCore:GetSlot(bag, slot)
	key = ('%s:%s'):format(bag, slot)
	return self.frame.slots[key]
end                         

local colorCache = {}
local plain = {r = .05, g = .05, b = .05}  
--- This will color the border of a single slot
-- @param slot this is the slot frame to color
-- @param fcolor this is the color table to use, is optional, defaults to {r = .05, g = .05, b = .05}  
function OneCore:ColorSlotBorder(slot, fcolor)
	local bag = slot:GetParent()
	local color = fcolor or plain
	
	if not slot.border then
		-- Thanks to oglow for this method
		local border = slot:CreateTexture(nil, "OVERLAY")
		border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
		border:SetBlendMode("ADD")
        border:SetAlpha(.5)
		
		border:SetPoint('CENTER', slot, 'CENTER', 0, 1)
		border:SetWidth(slot:GetWidth() * 2 - 5)
		border:SetHeight(slot:GetHeight() * 2 - 5)
		slot.border = border
	end
	
	local bcolor = nil
	if not fcolor and bag.type then
		if bag:IsAmmoBag() then
			bcolor = self.db.profile.colors.ammo
		elseif bag:IsSoulBag() then
			bcolor = self.db.profile.colors.soul
		elseif bag:IsProfessionBag() then
			bcolor = self.db.profile.colors.profession
		end
		
		if bcolor then color = bcolor end
	end
	
	if self.db.profile.appearance.rarity and not fcolor and not bcolor then
		local link = GetContainerItemLink(bag:GetID(), slot:GetID())
		if link then
			local rarity = select(3, GetItemInfo(link))
			if rarity and (rarity > 1 or self.db.profile.appearance.lowlevel) then
				-- going with this method as it should never produce a point where I don't have a color to work with.
				color = colorCache[rarity]
				if not color then
					local r, g, b, hex = GetItemQualityColor(rarity)
					color = {r = r, g = g, b = b}
					colorCache[rarity] = color --caching to prevent me from generating dozens of tables per pass
				end
			end
		end
	end
	
	local texture = slot:GetNormalTexture()		
	if self.db.profile.appearance.glow and color ~= plain then
		texture:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
        texture:SetBlendMode("ADD")
        texture:SetAlpha(.8)
        texture:SetPoint("CENTER", slot, "CENTER", 0, 1)

		slot.border:Hide()
		slot.glowing = true
	elseif slot.glowing then
		texture:SetTexture("Interface\\Buttons\\UI-Quickslot2")
		texture:SetBlendMode("BLEND")
        texture:SetPoint("CENTER", slot, "CENTER", 0, 0)
		texture:SetAlpha(1)
		texture:SetVertexColor(1, 1, 1)
		
		slot.border:Show()
		slot.glowing = false
	end
	
	local target = slot.glowing and texture or slot.border
	target:SetVertexColor(color.r, color.g, color.b)
end                                      

--- A helper function that colors a whole bags slots borders
-- @param bagid the numeric id of the bag
-- @param color the color to use when highlighting, optional
function OneCore:ColorManySlotBorders(bagid, color)
    if bagid and not self.frame.bags[bagid] then
        return
    end
    
    for slotid = 1, self.frame.bags[bagid].size do
		self:ColorSlotBorder(self:GetSlot(bagid, slotid), color)
	end
end

--- Used to highlight a bag's slots on mouseover
-- @param bagid the numeric id of the bag
function OneCore:HighlightBagSlots(bagid)
    self:ColorManySlotBorders(bagid, self.db.profile.colors.mouseover)
end
                                         
--- Used to unhighlight a bag's slots on mouseover
-- @param bagid the numeric id of the bag
function OneCore:UnhighlightBagSlots(bagid)
	self:ColorManySlotBorders(bagid)
end

--- This function returns the order of slots
function OneCore:GetSlotOrder()    
    for name, plugin in self:IterateActivePluginsByType('sorting') do
        return plugin:GetSlotOrder()
    end

    return {}
end                          

--- Sets up the plugin types
function OneCore:InitializePluginSystem()
    self:NewPluginType('sorting', 1, 1)     
    
    self.defaultSortPlugin = LibStub("OneSuite-SimpleSort-1.0"):LoadPluginForAddon(self)
end
                                                                                        
--- Replacement for GetContainerNumSlots
function OneCore:GetContainerNumSlots(bagId)
    if bagId == KEYRING_CONTAINER then
        local numKeyringSlots = _G.GetContainerNumSlots(KEYRING_CONTAINER);
        local maxSlotNumberFilled = 0;
        for i=1, numKeyringSlots do
            local texture = GetContainerItemInfo(KEYRING_CONTAINER, i);
            if ( texture and i > maxSlotNumberFilled) then
                maxSlotNumberFilled = i;
            end
        end

        -- Round to the nearest 4 rows that will hold the keys
        local modulo = maxSlotNumberFilled % 4;
        local size = maxSlotNumberFilled + (4 - modulo);
        if ( modulo == 3 ) then
            size = size + 4;
        end
        size = min(size, numKeyringSlots);

        return size;
    else
        return _G.GetContainerNumSlots(bagId)
    end    
end                         
   
--- Updates a slot's locked status.
-- @param event the event fired
-- @param bagid the numeric id of the bag
-- @param slotid the numeric id of the slot
function OneCore:UpdateItemLock(event, bagid, slotid)  
    if bagid == nil or slotid == nil then
        return
    end       

    local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bagid, slotid);
    SetItemButtonDesaturated(self:GetSlot(bagid, slotid), locked, 0.5, 0.5, 0.5);
end

-- slight bastardization of the embed system, using this to setup a lot of static values on the object.
-- It's important that anything included this way doesn't need to be upgraded, as embedding just forces these values.
setup_embed_and_upgrade(OneCore, "embedded", {      
    "CreateBagFrame",
    "CreateSlotFrame",
    "BuildFrame",    
    "OrganizeFrame", 
    "UpdateBag",
    "UpdateFrame",
    "GetSlot",
    "ColorSlotBorder", 
    "ColorManySlotBorders",
    "HighlightBagSlots",
    "UnhighlightBagSlots",
    "GetSlotOrder",   
    "InitializePluginSystem",   
    "GetContainerNumSlots",
    "UpdateItemLock",
    
    colWidth = 39,
    rowHeight = 39,
    topBorder = 2,
    bottomBorder = 24,
    rightBorder = 5,
    leftBorder = 8,

    bagIndexes = {},

    stratas = {
        "LOW",
        "MEDIUM",
        "HIGH",
        "DIALOG",
        "FULLSCREEN",
        "FULLSCREEN_DIALOG",
        "TOOLTIP",
    },
    
    defaults = {
		profile = {
			colors = {
				mouseover = {r = 0, g = .7, b = 1, a = 1},
				ammo = {r = 1, g = 1, b = 0, a = 1},
				soul = {r = .5, g = .5, b = 1, a = 1}, 
				profession = {r = 1, g = 0, b = 1, a = 1},
				background = {r = 0, g = 0, b = 0, a = .45},
			},
			show = {
				['*'] = true
			},
			appearance = {
				cols = 10,
				scale = 1,
				alpha = 1,
				glow = false,
				rarity = true,
				white = false,
			},
			behavior = {
				strata = 2,
				locked = false,
				clamped = true,
				bagbreak = false,
				valign = 1,
				bagorder = 1,
			},
			position = { 
				parent = "UIParent",
				left = 600,
				top = 450,
			},
			plugins = {},
		},
	},   
})
