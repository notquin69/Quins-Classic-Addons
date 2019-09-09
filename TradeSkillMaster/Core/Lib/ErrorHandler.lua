-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- TSM's error handler

local _, TSM = ...
local L = TSM.L
local private = {
	errorFrame = nil,
	isSilent = nil,
	errorSuppressed = nil,
	errorReports = {},
	num = 0,
	localLinesTemp = {},
	hitInternalError = false,
}
local TSM_VERSION = GetAddOnMetadata("TradeSkillMaster", "Version")
-- use strmatch so this string doesn't itself get replaced when we deploy
local IS_DEV_VERSION = strmatch(TSM_VERSION, "^@tsm%-project%-version@$") and true or false
local MAX_ERROR_REPORT_AGE = 7 * 24 * 60 * 60 -- 1 week
local MAX_STACK_DEPTH = 50
local ADDON_SUITES = {
	"ArkInventory",
	"AtlasLoot",
	"Altoholic",
	"Auc-",
	"Bagnon",
	"BigWigs",
	"Broker",
	"ButtonFacade",
	"Carbonite",
	"DataStore",
	"DBM",
	"Dominos",
	"DXE",
	"EveryQuest",
	"Forte",
	"FuBar",
	"GatherMate2",
	"Grid",
	"LightHeaded",
	"LittleWigs",
	"Masque",
	"MogIt",
	"Odyssey",
	"Overachiever",
	"PitBull4",
	"Prat-3.0",
	"RaidAchievement",
	"Skada",
	"SpellFlash",
	"TidyPlates",
	"TipTac",
	"Titan",
	"UnderHood",
	"WowPro",
	"ZOMGBuffs",
}
local ERROR_HEADING_COLOR = "|cff99ffff"



-- ============================================================================
-- Module Functions
-- ============================================================================

function TSM.ShowManualError()
	private.isManual = true
	TSM.ShowError("Manually triggered error")
end

function TSM.ShowError(err, thread)
	if thread then
		local stackLine = debugstack(thread, 0, 1, 0)
		local oldModule = strmatch(stackLine, "(lMaster_[A-Za-z]+)")
		if oldModule and tContains(TSM.CONST.OLD_TSM_MODULES, "TradeSkil"..oldModule) then
			-- ignore errors from old modules
			return
		end
	end
	-- show an error, but don't cause an exception to be thrown
	private.isSilent = true
	private.ErrorHandler(err, thread)
end

function TSM.SaveErrorReports(appDB)
	private.errorFrame:Hide()
	appDB.errorReports = appDB.errorReports or { updateTime = 0, data = {} }
	if #private.errorReports > 0 then
		appDB.errorReports.updateTime = private.errorReports[#private.errorReports].timestamp
	end
	-- remove any events which are too old
	for i = #appDB.errorReports.data, 1, -1 do
		local timestamp = strmatch(appDB.errorReports.data[i], "([0-9]+)%]$") or ""
		if (tonumber(timestamp) or 0) < time() - MAX_ERROR_REPORT_AGE then
			tremove(appDB.errorReports.data, i)
		end
	end
	for _, report in ipairs(private.errorReports) do
		local line = format("[%s,\"%s\",%d]", TSMAPI_FOUR.JSON.Encode(report.errorInfo), report.details, report.timestamp)
		tinsert(appDB.errorReports.data, line)
	end
end



-- ============================================================================
-- Error Handler
-- ============================================================================

function private.ErrorHandler(msg, thread)
	-- ignore errors while we are handling this error
	private.ignoreErrors = true
	local isSilent = private.isSilent
	private.isSilent = nil
	local isManual = private.isManual
	private.isManual = nil

	if type(thread) ~= "thread" then
		thread = nil
	end

	if private.errorFrame:IsVisible() and private.errorSuppressed then
		-- already showing an error and suppressed another one, so silently ignore this one
		private.ignoreErrors = false
		return true
	end

	-- shorten the paths in the error message
	msg = gsub(msg, "%.%.%.T?r?a?d?e?S?k?i?l?lM?a?ster([_A-Za-z]*)\\", "TradeSkillMaster%1\\")
	msg = strsub(msg, strfind(msg, "TradeSkillMaster") or 1)
	msg = gsub(msg, "TradeSkillMaster([^%.])", "TSM%1")

	-- build stack trace with locals and get addon name
	local stackInfo = private.GetStackInfo(msg, thread)
	local addonName = isSilent and "TradeSkillMaster" or nil
	for _, info in ipairs(stackInfo) do
		if not addonName then
			addonName = strmatch(info.file, "[A-Za-z]+%.lua") and private.IsTSMAddon(info.file) or nil
		end
	end
	if not isManual and addonName ~= "TradeSkillMaster" then
		-- not a TSM error
		private.ignoreErrors = false
		return false
	end

	if TSM.LOG_ERR and not IS_DEV_VERSION and not isManual then
		-- use a format string in case there are '%' characters in the msg
		TSM:LOG_ERR("%s", msg)
	end

	if private.errorFrame:IsVisible() then
		-- already showing an error, so suppress this one and return
		private.errorSuppressed = true
		print("|cffff0000TradeSkillMaster:|r "..L["Additional error suppressed"])
		return true
	end

	private.num = private.num + 1
	local errorInfo = {
		msg = #stackInfo > 0 and gsub(msg, TSMAPI_FOUR.Util.StrEscape(stackInfo[1].file)..":"..stackInfo[1].line..": ", "") or msg,
		stackInfo = stackInfo,
		time = time(),
		debugTime = floor(debugprofilestop()),
		client = GetBuildInfo(),
		locale = GetLocale(),
		inCombat = tostring(InCombatLockdown() and true or false),
		version = IS_DEV_VERSION and "Dev" or TSM_VERSION,
	}

	-- temp table info
	local status, tempTableInfo = pcall(TSMAPI_FOUR.Util.GetTempTableDebugInfo)
	local tempTableLines = {}
	if status then
		for _, info in ipairs(tempTableInfo) do
			tinsert(tempTableLines, info)
		end
	end
	errorInfo.tempTableStr = table.concat(tempTableLines, "\n")

	-- object pool info
	local objectPoolInfo = nil
	status, objectPoolInfo = pcall(TSMAPI_FOUR.ObjectPool.GetDebugInfo)
	local objectPoolLines = {}
	if status then
		for name, objectInfo in pairs(objectPoolInfo) do
			tinsert(objectPoolLines, format("%s (%d created, %d in use)", name, objectInfo.numCreated, objectInfo.numInUse))
			for _, info in ipairs(objectInfo.info) do
				tinsert(objectPoolLines, "  "..info)
			end
		end
	end
	errorInfo.objectPoolStr = table.concat(objectPoolLines, "\n")

	-- TSM thread info
	local threadInfo = nil
	status, threadInfo = pcall(TSMAPI_FOUR.Thread.GetDebugInfo)
	errorInfo.threadInfoStr = status and table.concat(threadInfo, "\n") or ""

	-- recent debug log entries
	local logEntries = nil
	status, logEntries = pcall(function() return TSMAPI_FOUR.Logger.GetRecentLogEntries(200, 150) end)
	errorInfo.debugLogStr = status and table.concat(logEntries, "\n") or ""

	-- addons
	local hasAddonSuite = {}
	local addonsLines = {}
	for i = 1, GetNumAddOns() do
		local name, _, _, loadable = GetAddOnInfo(i)
		if loadable then
			local version = strtrim(GetAddOnMetadata(name, "X-Curse-Packaged-Version") or GetAddOnMetadata(name, "Version") or "")
			local loaded = IsAddOnLoaded(i)
			local isSuite = nil
			for _, commonTerm in ipairs(ADDON_SUITES) do
				if strsub(name, 1, #commonTerm) == commonTerm then
					isSuite = commonTerm
					break
				end
			end
			local commonTerm = "TradeSkillMaster"
			if isSuite then
				if not hasAddonSuite[isSuite] then
					tinsert(addonsLines, name.." ("..version..")"..(loaded and "" or " [Not Loaded]"))
					hasAddonSuite[isSuite] = true
				end
			elseif strsub(name, 1, #commonTerm) == commonTerm then
				name = gsub(name, "TradeSkillMaster", "TSM")
				tinsert(addonsLines, name.." ("..version..")"..(loaded and "" or " [Not Loaded]"))
			else
				tinsert(addonsLines, name.." ("..version..")"..(loaded and "" or " [Not Loaded]"))
			end
		end
	end
	errorInfo.addonsStr = table.concat(addonsLines, "\n")

	-- show this error
	local stackInfoLines = {}
	for _, info in ipairs(errorInfo.stackInfo) do
		local localsStr = info.locals ~= "" and ("\n  |cffaaaaaa"..gsub(info.locals, "\n", "\n  ").."|r") or ""
		local locationStr = info.line ~= 0 and strjoin(":", info.file, info.line) or info.file
		tinsert(stackInfoLines, locationStr.." <"..info.func..">"..localsStr)
	end
	private.errorFrame.errorStr = strjoin("\n",
		private.FormatErrorMessageSection("Message", msg),
		private.FormatErrorMessageSection("Time", date("%m/%d/%y %H:%M:%S", errorInfo.time).." ("..floor(errorInfo.debugTime)..")"),
		private.FormatErrorMessageSection("Client", errorInfo.client),
		private.FormatErrorMessageSection("Locale", errorInfo.locale),
		private.FormatErrorMessageSection("Combat", errorInfo.inCombat),
		private.FormatErrorMessageSection("Error Count", private.num),
		private.FormatErrorMessageSection("Stack Trace", table.concat(stackInfoLines, "\n"), true),
		private.FormatErrorMessageSection("Temp Tables", errorInfo.tempTableStr, true),
		private.FormatErrorMessageSection("Object Pools", errorInfo.objectPoolStr, true),
		private.FormatErrorMessageSection("Threads", errorInfo.threadInfoStr, true),
		private.FormatErrorMessageSection("Debug Log", errorInfo.debugLogStr, true),
		private.FormatErrorMessageSection("Addons", errorInfo.addonsStr, true)
	)
	-- remove unprintable characters
	private.errorFrame.errorStr = gsub(private.errorFrame.errorStr, "[%z\001-\008\011-\031]", "?")
	private.errorFrame.errorInfo = errorInfo
	private.errorFrame.isManual = isManual
	private.errorFrame:Show()
	print("|cffff0000TradeSkillMaster:|r "..L["Looks like TradeSkillMaster has encountered an error. Please help the author fix this error by following the instructions shown."])

	private.ignoreErrors = false
	return true
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.GetStackInfo(msg, thread)
	-- build stack trace with locals and get addon name
	local errLocation = strmatch(msg, "[A-Za-z]+%.lua:[0-9]+")
	local stackInfo = {}
	local stackStarted = false
	for i = 0, MAX_STACK_DEPTH do
		local prevStackFunc = #stackInfo > 0 and stackInfo[#stackInfo].func or nil
		local file, line, func, localsStr, newPrevStackFunc = TSMAPI_FOUR.Util.GetStackLevelInfo(i, thread, prevStackFunc)
		if newPrevStackFunc then
			stackInfo[#stackInfo].func = newPrevStackFunc
		end
		if file then
			if not stackStarted then
				if errLocation then
					stackStarted = strmatch(file..":"..line, "[A-Za-z]+%.lua:[0-9]+") == errLocation
				else
					stackStarted = i > (thread and 1 or 4) and file ~= "[C]"
				end
			end
			if stackStarted then
				tinsert(stackInfo, {
					file = file,
					line = line,
					func = func,
					locals = localsStr,
				})
			end
		end
	end
	return stackInfo
end

function private.IsTSMAddon(str)
	if strfind(str, "Auc-Adcanced\\CoreScan.lua") then
		-- ignore auctioneer errors
		return nil
	elseif strfind(str, "Master\\Libs\\") then
		-- ignore errors from libraries
		return nil
	elseif strfind(str, "Master\\Core\\API.lua") then
		-- ignore errors from public APIs
		return nil
	elseif strfind(str, "Master_AppHelper\\") then
		return "TradeSkillMaster_AppHelper"
	elseif strfind(str, "lMaster\\") then
		return "TradeSkillMaster"
	elseif strfind(str, "ster\\Core\\UI\\") then
		return "TradeSkillMaster"
	elseif strfind(str, "^TSM\\") then
		return "TradeSkillMaster"
	end
	return nil
end

function private.AddonBlockedEvent(event, addonName, addonFunc)
	if not strmatch(addonName, "TradeSkillMaster") then return end
	-- just log it - it might not be TSM
	if TSM.LOG_ERR then
		TSM:LOG_ERR("[%s] AddOn '%s' tried to call the protected function '%s'.", event, addonName or "<name>", addonFunc or "<func>")
	end
end

function private.SanitizeString(str)
	str = gsub(str, "\124cff[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]([^\124]+)\124r", "%1")
	str = gsub(str, "[\\]+", "/")
	str = gsub(str, "\"", "'")
	return str
end

function private.FormatErrorMessageSection(heading, info, isMultiLine)
	local prefix = nil
	if isMultiLine then
		prefix = info ~= "" and "\n  " or ""
		info = gsub(info, "\n", "\n  ")
	else
		prefix = info ~= "" and " " or ""
	end
	return ERROR_HEADING_COLOR..heading..":|r"..prefix..info
end



-- ============================================================================
-- Create Error Frame
-- ============================================================================

do
	local STEPS_TEXT = "Steps leading up to the error:\n1) List\n2) Steps\n3) Here"
	local frame = CreateFrame("Frame", nil, UIParent)
	private.errorFrame = frame
	frame:Hide()
	frame:SetWidth(500)
	frame:SetHeight(400)
	frame:SetFrameStrata("FULLSCREEN_DIALOG")
	frame:SetPoint("RIGHT", -100, 0)
	frame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		edgeSize = 2,
	})
	frame:SetBackdropColor(0, 0, 0, 1)
	frame:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
	frame:SetScript("OnShow", function(self)
		self.showingError = self.isManual or IS_DEV_VERSION
		self.details = STEPS_TEXT
		if self.showingError then
			-- this is a dev version so show the error (only)
			self.text:SetText("Looks like TradeSkillMaster has encountered an error.")
			self.switchBtn:SetText("Hide Error")
			self.editBox:SetText(self.errorStr)
		else
			self.text:SetText("Looks like TradeSkillMaster has encountered an error. Please provide the steps which lead to this error to help the TSM team fix it, then click either button at the bottom of the window to automatically report this error.")
			self.switchBtn:SetText("Show Error")
			self.editBox:SetText(self.details)
		end
	end)
	frame:SetScript("OnHide", function()
		local details = private.errorFrame.showingError and private.errorFrame.details or private.errorFrame.editBox:GetText()
		local changedDetails = details ~= STEPS_TEXT
		if (not IS_DEV_VERSION and not private.errorFrame.isManual and (changedDetails or private.num == 1)) or IsShiftKeyDown() then
			tinsert(private.errorReports, {
				errorInfo = private.errorFrame.errorInfo,
				details = private.SanitizeString(details),
				timestamp = time(),
			})
		end
		private.errorSuppressed = nil
	end)

	local title = frame:CreateFontString()
	title:SetHeight(20)
	title:SetPoint("TOPLEFT", 0, -10)
	title:SetPoint("TOPRIGHT", 0, -10)
	title:SetFontObject(GameFontNormalLarge)
	title:SetTextColor(1, 1, 1, 1)
	title:SetJustifyH("CENTER")
	title:SetJustifyV("MIDDLE")
	title:SetText("TSM Error Window")

	local hLine = frame:CreateTexture(nil, "ARTWORK")
	hLine:SetHeight(2)
	hLine:SetColorTexture(0.3, 0.3, 0.3, 1)
	hLine:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)
	hLine:SetPoint("TOPRIGHT", title, "BOTTOMRIGHT", 0, -10)

	local text = frame:CreateFontString()
	frame.text = text
	text:SetHeight(45)
	text:SetPoint("TOPLEFT", hLine, "BOTTOMLEFT", 8, -8)
	text:SetPoint("TOPRIGHT", hLine, "BOTTOMRIGHT", -8, -8)
	text:SetFontObject(GameFontNormal)
	text:SetTextColor(1, 1, 1, 1)
	text:SetJustifyH("LEFT")
	text:SetJustifyV("MIDDLE")

	local switchBtn = CreateFrame("Button", nil, frame)
	frame.switchBtn = switchBtn
	switchBtn:SetPoint("TOPRIGHT", -4, -10)
	switchBtn:SetWidth(100)
	switchBtn:SetHeight(20)
	local fontString = switchBtn:CreateFontString()
	fontString:SetFontObject(GameFontNormalSmall)
	fontString:SetJustifyH("CENTER")
	fontString:SetJustifyV("MIDDLE")
	switchBtn:SetFontString(fontString)
	switchBtn:SetScript("OnClick", function(self)
		private.errorFrame.showingError = not private.errorFrame.showingError
		if private.errorFrame.showingError then
			private.errorFrame.details = private.errorFrame.editBox:GetText()
			self:SetText("Hide Error")
			private.errorFrame.editBox:SetText(private.errorFrame.errorStr)
		else
			self:SetText("Show Error")
			private.errorFrame.editBox:SetText(private.errorFrame.details)
		end
	end)

	local hLine2 = frame:CreateTexture(nil, "ARTWORK")
	hLine2:SetHeight(2)
	hLine2:SetColorTexture(0.3, 0.3, 0.3, 1)
	hLine2:SetPoint("TOPLEFT", text, "BOTTOMLEFT", -8, -4)
	hLine2:SetPoint("TOPRIGHT", text, "BOTTOMRIGHT", 8, -4)

	local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", hLine2, "BOTTOMLEFT", 8, -4)
	scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -26, 38)

	local editBox = CreateFrame("EditBox", nil, scrollFrame)
	frame.editBox = editBox
	editBox:SetWidth(scrollFrame:GetWidth())
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetMultiLine(true)
	editBox:SetAutoFocus(false)
	editBox:SetMaxLetters(0)
	editBox:SetTextColor(1, 1, 1, 1)
	editBox:SetScript("OnUpdate", function(self)
		local offset = scrollFrame:GetVerticalScroll()
		self:SetHitRectInsets(0, 0, offset, self:GetHeight() - offset - scrollFrame:GetHeight())
	end)
	editBox:SetScript("OnEditFocusGained", function(self)
		self:HighlightText()
	end)
	editBox:SetScript("OnCursorChanged", function(self)
		if private.errorFrame.showingError and self:HasFocus() then
			self:HighlightText()
		end
	end)
	editBox:SetScript("OnEscapePressed", function(self)
		if private.errorFrame.showingError then
			self:HighlightText(0, 0)
		end
		self:ClearFocus()
	end)
	scrollFrame:SetScrollChild(editBox)

	local hLine3 = frame:CreateTexture(nil, "ARTWORK")
	hLine3:SetHeight(2)
	hLine3:SetColorTexture(0.3, 0.3, 0.3, 1)
	hLine3:SetPoint("BOTTOMLEFT", frame, 0, 35)
	hLine3:SetPoint("BOTTOMRIGHT", frame, 0, 35)

	local reloadBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.reloadBtn = reloadBtn
	reloadBtn:SetPoint("BOTTOMLEFT", 4, 4)
	reloadBtn:SetWidth(120)
	reloadBtn:SetHeight(30)
	reloadBtn:SetText(RELOADUI)
	reloadBtn:SetScript("OnClick", function()
		frame:Hide()
		ReloadUI()
	end)

	local closeBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.closeBtn = closeBtn
	closeBtn:SetPoint("BOTTOMRIGHT", -4, 4)
	closeBtn:SetWidth(120)
	closeBtn:SetHeight(30)
	closeBtn:SetText(DONE)
	closeBtn:SetScript("OnClick", function()
		frame:Hide()
	end)

	local stepsText = frame:CreateFontString()
	frame.stepsText = stepsText
	stepsText:SetWidth(200)
	stepsText:SetHeight(30)
	stepsText:SetPoint("BOTTOM", 0, 4)
	stepsText:SetFontObject(GameFontNormal)
	stepsText:SetTextColor(1, 0, 0, 1)
	stepsText:SetJustifyH("CENTER")
	stepsText:SetJustifyV("MIDDLE")
	stepsText:SetText("Please enter steps before submitting")
end



-- ============================================================================
-- Register Error Handler
-- ============================================================================

do
	private.origErrorHandler = geterrorhandler()
	seterrorhandler(function(errMsg)
		local tsmErrMsg = strtrim(tostring(errMsg))
		if private.ignoreErrors then
			-- we're ignoring errors
			tsmErrMsg = nil
		elseif strmatch(tsmErrMsg, "auc%-stat%-wowuction") or strmatch(tsmErrMsg, "TheUndermineJournal%.lua") or strmatch(tsmErrMsg, "\\SavedVariables\\TradeSkillMaster") or strmatch(tsmErrMsg, "AddOn TradeSkillMaster[_a-zA-Z]* attempted") then
			-- explicitly ignore these errors
			tsmErrMsg = nil
		end
		if tsmErrMsg then
			-- look at the stack trace to see if this is a TSM error
			for i = 2, MAX_STACK_DEPTH do
				local stackLine = debugstack(i, 1, 0)
				local oldModule = strmatch(stackLine, "(lMaster_[A-Za-z]+)")
				if oldModule and tContains(TSM.CONST.OLD_TSM_MODULES, "TradeSkil"..oldModule) then
					-- ignore errors from old modules
					return
				end
				if not strmatch(stackLine, "^%[C%]:") and not strmatch(stackLine, "^%(tail call%):") and not strmatch(stackLine, "^%[string \"") then
					if not private.IsTSMAddon(stackLine) then
						tsmErrMsg = nil
					end
					break
				end
			end
		end
		if tsmErrMsg then
			local status, ret = pcall(private.ErrorHandler, tsmErrMsg)
			if status and ret then
				return ret
			elseif not status and not private.hitInternalError then
				private.hitInternalError = true
				TSM:Print("Internal TSM error: "..tostring(ret))
			end
		end
		local oldModule = strmatch(errMsg, "(lMaster_[A-Za-z]+)")
		if oldModule and tContains(TSM.CONST.OLD_TSM_MODULES, "TradeSkil"..oldModule) then
			-- ignore errors from old modules
			return
		end
		return private.origErrorHandler and private.origErrorHandler(errMsg) or nil
	end)
	TSMAPI_FOUR.Event.Register("ADDON_ACTION_FORBIDDEN", private.AddonBlockedEvent)
	TSMAPI_FOUR.Event.Register("ADDON_ACTION_BLOCKED", private.AddonBlockedEvent)
end
