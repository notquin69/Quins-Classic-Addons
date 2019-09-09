-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
TSMAPI_FOUR.Addon = {}
local private = {
	eventFrames = {},
	addonLookup = {},
	initializeQueue = {},
	enableQueue = {},
	disableQueue = {},
	totalInitializeTime = 0,
	totalEnableTime = 0,
}
local TIME_WARNING_THRESHOLD_MS = 20
local MAX_TIME_PER_EVENT_MS = 12000
local NUM_EVENT_FRAMES = 10



-- ============================================================================
-- Event Handling
-- ============================================================================

function private.DoInitialize()
	local eventStartTime = debugprofilestop()
	while #private.initializeQueue > 0 and debugprofilestop() < (eventStartTime + MAX_TIME_PER_EVENT_MS) do
		local addon = tremove(private.initializeQueue, 1)
		if addon.OnInitialize then
			local addonStartTime = debugprofilestop()
			addon.OnInitialize()
			local addonTimeTaken = debugprofilestop() - addonStartTime
			if addonTimeTaken > TIME_WARNING_THRESHOLD_MS then
				TSM:LOG_WARN("OnInitialize (%s) took %0.2fms", addon, addonTimeTaken)
			end
		end
		tinsert(private.enableQueue, addon)
	end
	private.totalInitializeTime = private.totalInitializeTime + debugprofilestop() - eventStartTime
	return #private.initializeQueue == 0
end

function private.DoEnable()
	local eventStartTime = debugprofilestop()
	while #private.enableQueue > 0 and debugprofilestop() < (eventStartTime + MAX_TIME_PER_EVENT_MS) do
		local addon = tremove(private.enableQueue, 1)
		if addon.OnEnable then
			local addonStartTime = debugprofilestop()
			addon.OnEnable()
			local addonTimeTaken = debugprofilestop() - addonStartTime
			if addonTimeTaken > TIME_WARNING_THRESHOLD_MS then
				TSM:LOG_WARN("OnEnable (%s) took %0.2fms", addon, addonTimeTaken)
			end
		end
		tinsert(private.disableQueue, addon)
	end
	private.totalEnableTime = private.totalEnableTime + debugprofilestop() - eventStartTime
	return #private.enableQueue == 0
end

function private.PlayerLogoutHandler()
	private.OnDisableHelper()
	wipe(private.disableQueue)
end

do
	-- Blizzard did something silly in 8.1 where scripts time throw an error after 19 seconds, but nothing prevents us
	-- from just splitting the processing across multiple script handlers, so we do that here.
	local function EventHandler(self, event, arg)
		if event == "ADDON_LOADED" and arg == "TradeSkillMaster" then
			if private.DoInitialize() then
				-- we're done
				for _, frame in ipairs(private.eventFrames) do
					frame:UnregisterEvent(event)
				end
				TSM.Analytics.Action("ADDON_INITIALIZE", floor(private.totalInitializeTime))
			elseif self == private.eventFrames[#private.eventFrames] then
				error("Ran out of event frames to initialize TSM")
			end
		elseif event == "PLAYER_LOGIN" then
			if private.DoEnable() then
				-- we're done
				for _, frame in ipairs(private.eventFrames) do
					frame:UnregisterEvent(event)
				end
				TSM.Analytics.Action("ADDON_ENABLE", floor(private.totalEnableTime))
			elseif self == private.eventFrames[#private.eventFrames] then
				error("Ran out of event frames to enable TSM")
			end
		end
	end
	for _ = 1, NUM_EVENT_FRAMES do
		local frame = CreateFrame("Frame")
		frame:SetScript("OnEvent", EventHandler)
		frame:RegisterEvent("ADDON_LOADED")
		frame:RegisterEvent("PLAYER_LOGIN")
		tinsert(private.eventFrames, frame)
	end
	TSMAPI_FOUR.Event.Register("PLAYER_LOGOUT", private.PlayerLogoutHandler)
end



-- ============================================================================
-- AddonPackage Class
-- ============================================================================

local AddonPackage = TSMAPI_FOUR.Class.DefineClass("AddonPackage")

function AddonPackage.__init(self, name, ...)
	self.name = name
	for i = 1, select("#", ...) do
		local embed = select(i, ...)
		LibStub(embed):Embed(self)
	end
	tinsert(private.initializeQueue, self)
end

function AddonPackage.__tostring(self)
	return self.name
end

function AddonPackage.NewPackage(self, name, ...)
	local package = AddonPackage(name, ...)
	assert(not self[name])
	self[name] = package
	return package
end



-- ============================================================================
-- Addon Class
-- ============================================================================

local Addon = TSMAPI_FOUR.Class.DefineClass("Addon", AddonPackage)

function Addon.__init(self, name, ...)
	self.__super:__init(name, ...)

	self._name = name
	self._shortName = gsub(name, "TradeSkillMaster_", "")
	self._logger = TSMAPI_FOUR.Logger.New(self:GetShortName())
end

function Addon.GetShortName(self)
	return self._shortName
end

function Addon.PrintRaw(self, str)
	TSM:GetChatFrame():AddMessage(str)
end

function Addon.PrintfRaw(self, ...)
	self:PrintRaw(format(...))
end

function Addon.Print(self, str)
	-- FIXME: hard-coded color
	self:PrintRaw("|cff33ff99"..tostring(self).."|r: "..str)
end

function Addon.Printf(self, ...)
	self:Print(format(...))
end

function Addon.LOG_INFO(self, ...)
	self._logger:LogMessage("INFO", ...)
end

function Addon.LOG_WARN(self, ...)
	self._logger:LogMessage("WARN", ...)
end

function Addon.LOG_ERR(self, ...)
	self._logger:LogMessage("ERR", ...)
end

function Addon.LOG_STACK_TRACE(self)
	self._logger:LogMessage("STACK", "Stack Trace:")
	local level = 2
	local line = TSMAPI_FOUR.Util.GetDebugStackInfo(level)
	while line do
		self._logger:LogMessage("STACK", "  " .. line)
		level = level + 1
		line = TSMAPI_FOUR.Util.GetDebugStackInfo(level)
	end
end



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

function TSMAPI_FOUR.Addon.New(name, tbl)
	assert(type(name) == "string" and type(tbl) == "table", "Invalid arguments")
	assert(not private.addonLookup[tbl], "Addon already created")

	local addon = TSMAPI_FOUR.Class.ConstructWithTable(tbl, Addon, name)
	private.addonLookup[tbl] = addon
	return addon
end



-- ============================================================================
-- Module Functions (Debug Only)
-- ============================================================================

function TSM.AddonTestLogout()
	private.OnDisableHelper()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.OnDisableHelper()
	local disableStartTime = debugprofilestop()
	for _, addon in ipairs(private.disableQueue) do
		-- defer the main TSM.OnDisable() call to the very end
		if addon.OnDisable and addon ~= TSM then
			local startTime = debugprofilestop()
			addon.OnDisable()
			local timeTaken = debugprofilestop() - startTime
			if timeTaken > TIME_WARNING_THRESHOLD_MS then
				TSM:LOG_WARN("OnDisable (%s) took %0.2fms", addon, timeTaken)
			end
		end
	end
	local totalDisableTime = debugprofilestop() - disableStartTime
	TSM.Analytics.Action("ADDON_DISABLE", floor(totalDisableTime))
	if TSM.OnDisable then
		TSM:OnDisable()
	end
end
