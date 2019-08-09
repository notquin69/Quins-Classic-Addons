--- **OneFrame.lua** provies frame creation and handling code for OneSuite
-- @class file
-- @name OneFrame.lua
local MAJOR, MINOR = "OneFrame-1.0", tonumber("56") or 9999
local OneFrame, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not OneFrame then return end -- No Upgrade needed.

--- This will setup the embed function on the library as well as upgrade any old embeds will also upgrade the store
-- @param lib the library being setup
-- @param store a table used to keep track of what was previously embedded, this is for upgrading.
-- @param mixins a table of what needs to be mixed in    
local function setup_embed_and_upgrade(lib, store, mixins)        
    
    if lib.embeded then
        lib.embedded = lib.embeded
        lib.embeded = nil
    end
    
    if lib.embededFrames then
        lib.embeddedFrames = lib.embededFrames
        lib.embededFrames = nil
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
 
-- Helpers to make my code that manipulates frames shorter
local FrameHelpers = {
    stratas = {
        "LOW",
        "MEDIUM",
        "HIGH",
        "DIALOG",
        "FULLSCREEN",
        "FULLSCREEN_DIALOG",
        "TOOLTIP",
    },
}                

--- Wraper for SetWidth and SetHeight
-- @param width passed into SetWidth
-- @param height passed into SetHeight
function FrameHelpers:SetSize(width, height)
	self:SetWidth(width)
	self:SetHeight(height)
end

--- Wrapper for setting of position, will also ClearAllPoints first
-- @param position represents a position
-- @usage
-- -- Only parent is required, all other values are defaults
-- frame:SetPosition({ parent=frame, attachAt="TOPLEFT", attachTo="TOPRIGHT", left=0, top=0 })
function FrameHelpers:SetPosition(position)             
    
    parent = type(position.parent) == "string" and getglobal(position.parent) or position.parent
    
	self:ClearAllPoints()
	self:SetPoint(position.attachAt or "TOPLEFT", parent, position.attachTo or "BOTTOMLEFT", position.left or 0, position.top or 0)
end            

--- Gets the current positionTable of the frame, returns a string for parent
function FrameHelpers:GetPosition()
	return {
		top = self:GetTop(),
		left = self:GetLeft(),
		parent = self:GetParent():GetName(),    
	}
end

--- Will customize a frame based on the values stored in a db table
-- @param db the database table on which to base the customization.
-- @note the function assumes the db table has several subtables: appearance, colors, & behavior
function FrameHelpers:CustomizeFrame(db)
	self:SetScale(db.appearance.scale or 1)
	self:SetAlpha(db.appearance.alpha or 1)
	
	local c = db.colors.background or { r=1, g=1, b=1, a=1 }
	self:SetBackdropColor(c.r, c.g, c.b, c.a)
	
	self:SetClampedToScreen(db.behavior.clamped or true)
	
	local strata = self.stratas[db.behavior.strata or 2]

	self:SetFrameStrata(strata)
	if self.slots then
		for _, slot in pairs(self.slots) do
			slot:SetFrameStrata(strata)
		end
	end
	
	if self.childrenFrames then
	    for _, frame in pairs(self.childrenFrames) do
            frame:CustomizeFrame(db)
	    end
	end
end
    
setup_embed_and_upgrade(FrameHelpers, "embeddedFrames", {   
    "stratas",
    "SetSize",
    "SetPosition",
    "GetPosition",      
    "CustomizeFrame",
})

--- Creates a fontstring object
-- @param parent the frame the fontstring is created on
-- @param color the text color, a rgb table, defaults to white
-- @param size the size of the font, defaults to 13
function OneFrame:CreateFontString(parent, color, size)
	local c = color or {r=1, g=1, b=1}
	local fontstring = parent:CreateFontString(nil, "OVERLAY")
    
    fontstring:SetWidth(365)
    fontstring:SetHeight(15)

    fontstring:SetShadowOffset(.8, -.8)
    fontstring:SetShadowColor(0, 0, 0, .5)
    fontstring:SetTextColor(c.r, c.g, c.b)

    fontstring:SetJustifyH("LEFT")
    fontstring:SetFont("Fonts\\FRIZQT__.TTF", size or 13)
    
    return fontstring
end        

--- Creates a small money frame that's slightly customized
-- @param framename the name used when creating the moneyframe
-- @param parent the frame this moneyframe will belong to
-- @param type the type of money frame we're making
function OneFrame:CreateSmallMoneyFrame(framename, parent, type)
	local moneyframe = CreateFrame("Frame", parent:GetName()..framename, parent, "SmallMoneyFrameTemplate")

	SmallMoneyFrame_OnLoad(moneyframe, type)
		
	return moneyframe
end


--- Creates a simple empty frame with the appropriate attributes and backgrounds
-- @param framename used as the frame's name in CreateFrame   
-- @param width the width of the frame, defaults to 200     
-- @param height the height of the frame, defaults to 200
function OneFrame:CreateBaseFrame(framename, width, height)
	local frame = CreateFrame('Frame', framename, UIParent)
                             
    FrameHelpers:Embed(frame)
	
	frame:SetToplevel(true)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	
	frame:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground", tile = true, tileSize = 16,
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
        insets = {left = 5, right = 5, top = 5, bottom = 5},
    })
		
    frame:SetSize(width or 200, height or 200)

	return frame
end
   
--- Creates a sidebar frame and attaches it to the given base frame.
-- @param framename used as the frame's name in CreateFrame   
-- @param parent the frame to attach to
-- @param width the width of the frame, defaults to 60     
-- @param height the height of the frame, defaults to 223
function OneFrame:CreateSideBar(framename, parent, width, height)
    local sidebar = self:CreateBaseFrame(framename, width or 60, height or 223)
	
	sidebar:SetPosition({ parent=parent, attachAt="TOPRIGHT", attachTo="TOPLEFT" })
	
	return sidebar
end            

--- Creates a main frame, complete with fixins and widgets and stuff.   
-- @param framename the name of the frame, passed into CreateFrame
-- @param moneyType the type of moneyframe to use on this frame.
function OneFrame:CreateMainFrame(framename, moneyType)
	local frame = self:CreateBaseFrame(framename)
	
	frame.title = self:CreateFontString(frame)
	frame.title:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -14)
	
	frame.info = self:CreateFontString(frame, {r=1, g=1, b=0}, 11)
	frame.info:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 8)
	
	frame.moneyframe = self:CreateSmallMoneyFrame("MoneyFrame", frame, moneyType)
	frame.moneyframe:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 5, 7)
	
	-- Default Behaviors
	tinsert(UISpecialFrames, frame:GetName())
	frame:SetScript("OnDragStart", function(self)
		if not self.handler.db.profile.behavior.locked then
            frame:StartMoving()
            frame.isMoving = true
            
            for _, slot in pairs(frame.slots) do
				slot:EnableMouse(false)
			end
        end
	end)
	
	frame:SetScript("OnDragStop", function()
		frame:StopMovingOrSizing(self)
        if frame.isMoving then
            frame.handler.db.profile.position = frame:GetPosition() 
            frame.handler.db.profile.moved = true
            for _, slot in pairs(frame.slots) do
				slot:EnableMouse(true)
			end
        end
        self.isMoving = false
	end)
	
	local sidebarButton = CreateFrame('CheckButton', nil, frame)
	sidebarButton:SetHeight(30)
	sidebarButton:SetWidth(32)
	
	sidebarButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -7)
	sidebarButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
	sidebarButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
	sidebarButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	
	sidebarButton:SetScript("OnClick", function()
		if sidebarButton:GetChecked() then
			sidebarButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
			frame.sidebar:Show()  
		else
			sidebarButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
			frame.sidebar:Hide()
		end
	end)
	
	frame.sidebarButton = sidebarButton
	
	local name = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	name:SetJustifyH("LEFT")
	name:SetPoint("LEFT", sidebarButton, "RIGHT", 5, 1)
	frame.name = name
	
	local closeButton = CreateFrame('Button', nil, frame, "UIPanelCloseButton")
	closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -5)
	frame.closeButton = closeButton
	
	local configButton = CreateFrame('Button', nil, frame, "UIPanelButtonTemplate")
	configButton:SetHeight(20)
	configButton:SetWidth(65)
	
	configButton:SetText("Config")
	configButton:SetPoint("RIGHT", closeButton, "LEFT", 0, 0)
	
	configButton:SetScript("OnClick", function()
		frame.handler:OpenConfig()
	end)
	
	frame.configButton = configButton
    
    frame.childrenFrames = {}
	
	return frame
end 

--- Creates a keyring button
--function OneFrame:CreateKeyringButton(parent)
    --local button = CreateFrame("CheckButton", parent:GetName().."KeyringButton", parent)

    --button:SetHeight(39)
    --button:SetWidth(18)
    
    --button:SetScript("OnClick", function()
    	--if (CursorHasItem()) then
    		--PutKeyInKeyRing()
    	--else
    		--ToggleKeyRing()
    	--end
    --end)
    
    --button:SetScript("OnReceiveDrag", function()
        --if (CursorHasItem()) then
            --PutKeyInKeyRing()
	    --end
    --end)
    
    --button:SetScript("OnEnter", function()
    	--GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
    	--GameTooltip:SetText(KEYRING, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
    	--GameTooltip:AddLine()
    --end)         
    
    --button:SetScript("OnLeave", function()
        --GameTooltip:Hide()
    --end)                                                    
    
	--button:SetID(KEYRING_CONTAINER)
	--button:RegisterForClicks("LeftButtonUp", "RightButtonUp") 
	
    --function createTexture(path, mode, left, right, top, bottom)
        --local texture = button:CreateTexture(path, "OVERLAY")
        --texture:SetTexture(path)
        --texture:SetTexCoord(left, right, top, bottom) 
        
        --if mode then
            --texture:SetBlendMode(mode)
        --end
        
        --return texture
    --end
	                        
	--button:SetNormalTexture([[Interface\Buttons\UI-Button-KeyRing]])
	--button:SetHighlightTexture([[Interface\Buttons\UI-Button-KeyRing-Highlight]])
	--button:SetPushedTexture([[Interface\Buttons\UI-Button-KeyRing-Down]])
--	button:SetNormalTexture(createTexture([[Interface\Buttons\UI-Button-KeyRing]], nil, 0, 0.5625, 0, 0.609375))
--	button:SetHighlightTexture(createTexture([], "ADD", 0, 0.5625, 0, 0.609375))
--	button:SetPushedTexture(createTexture([[Interface\Buttons\UI-Button-KeyRing-Down]], nil, 0, 0.5625, 0, 0.609375))	                                                                                                            
	
	--return button
--end         

setup_embed_and_upgrade(OneFrame, "embedded", {     
    "CreateFontString",
    "CreateSmallMoneyFrame",
    "CreateBaseFrame",
    "CreateSideBar",   
    "CreateMainFrame",
    "CreateKeyringButton"
})
