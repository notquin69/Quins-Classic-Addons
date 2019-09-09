-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Settings = TSM.MainUI:NewPackage("Settings")
local L = TSM.L
local private = {
	settingPages = {
		top = {},
		middle = {},
		bottom = {},
	},
	callback = {},
	childSettingsPages = {},
	frame = nil
}
local SECTIONS = { "top", "middle" }
local SETTING_PATH_SEP = "`"
local HEADER_LINE_TEXT_MARGIN = { right = 8 }
local HEADER_LINE_MARGIN = { top = 16, bottom = 16 }
local SETTING_LINE_MARGIN = { bottom = 16 }
local SETTING_LABEL_WIDTH = 400



-- ============================================================================
-- Module Functions
-- ============================================================================

function Settings.OnInitialize()
	TSM.MainUI.RegisterTopLevelPage("Settings", "iconPack.24x24/Settings", private.GetSettingsFrame)
end

function Settings.RegisterSettingPage(name, section, callback)
	assert(tContains(SECTIONS, section))
	tinsert(private.settingPages[section], name)
	private.callback[name] = callback
end

function Settings.RegisterChildSettingPage(parentName, childName, callback)
	local path = parentName..SETTING_PATH_SEP..childName
	private.childSettingsPages[parentName] = private.childSettingsPages[parentName] or {}
	tinsert(private.childSettingsPages[parentName], childName)
	private.callback[path] = callback
end

function Settings.CreateHeadingLine(id, text)
	return TSMAPI_FOUR.UI.NewElement("Frame", id)
		:SetLayout("HORIZONTAL")
		:SetStyle("height", 34)
		:SetStyle("margin", HEADER_LINE_MARGIN)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
			:SetStyle("textColor", "#79a2ff")
			:SetStyle("fontHeight", 24)
			:SetStyle("margin", HEADER_LINE_TEXT_MARGIN)
			:SetStyle("autoWidth", true)
			:SetText(text)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "vline")
			:SetStyle("color", "#e2e2e2")
			:SetStyle("height", 2)
		)
end

function Settings.CreateSettingLine(id, labelText, width)
	width = width or SETTING_LABEL_WIDTH

	return TSMAPI_FOUR.UI.NewElement("Frame", id)
		:SetLayout("HORIZONTAL")
		:SetStyle("height", 26)
		:SetStyle("margin", SETTING_LINE_MARGIN)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
			:SetStyle("width", width)
			:SetStyle("textColor", "#e2e2e2")
			:SetStyle("fontHeight", 18)
			:SetText(labelText)
		)
end

function Settings.CreateHeading(id, text)
	return TSMAPI_FOUR.UI.NewElement("Text", id)
		:SetStyle("height", 19)
		:SetStyle("margin.bottom", 4)
		:SetStyle("font", TSM.UI.Fonts.MontserratBold)
		:SetStyle("fontHeight", 16)
		:SetStyle("textColor", "#ffffff")
		:SetText(text)
end

function Settings.CreateInputWithReset(id, label, context, validationFunction)
	local scope, namespace, key = strsplit(".", context)

	return TSMAPI_FOUR.UI.NewElement("Frame", id)
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("textColor", "#e2e2e2")
			:SetStyle("height", 18)
			:SetStyle("fontHeight", 14)
			:SetStyle("margin.bottom", 4)
			:SetText(label)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("textColor", "#ffffff")
			:SetStyle("background", "#5c5c5c")
			:SetStyle("height", 32)
			:SetStyle("fontHeight", 16)
			:SetStyle("margin.bottom", 8)
			:SetSettingInfo(TSM.db[scope][namespace], key, validationFunction)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "buttonFrame")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
			:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "resetButton")
				:SetStyle("width", 120)
				:SetStyle("height", 26)
				:SetText(L["RESET"])
				:SetScript("OnClick", private.ResetBtnOnClick)
				:SetContext(context)
			)
		)
end

function Settings.PromptToReload()
	StaticPopupDialogs["TSMReloadPrompt"] = StaticPopupDialogs["TSMReloadPrompt"] or {
		text = L["You must reload your UI for these settings to take effect. Reload now?"],
		button1 = YES,
		button2 = NO,
		timeout = 0,
		OnAccept = ReloadUI,
	}
	TSMAPI_FOUR.Util.ShowStaticPopupDialog("TSMReloadPrompt")
end



-- ============================================================================
-- Settings UI
-- ============================================================================

function private.GetSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings")
	local defaultPage = private.settingPages.top[1]
	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "settings")
		:SetLayout("HORIZONTAL")
		:SetStyle("background", "#2e2e2e")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "settingNavigation")
			:SetLayout("VERTICAL")
			:SetStyle("background", "#585858")
			:SetStyle("width", 160)
			:SetStyle("padding.top", 31)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "top")
				:SetLayout("VERTICAL")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "vline")
				:SetStyle("color", "#e2e2e2")
				:SetStyle("height", 1)
				:SetStyle("margin.left", 16)
				:SetStyle("margin.right", 24)
				:SetStyle("margin.top", 12)
				:SetStyle("margin.bottom", 4)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "middle")
				:SetLayout("VERTICAL")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer")
				-- make all the navigation align to the top
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "shadow")
			:SetStyle("width", TSM.UI.TexturePacks.GetWidth("uiFrames.SettingsNavShadow"))
			:SetStyle("texturePack", "uiFrames.SettingsNavShadow")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "contentFrame")
			:SetLayout("VERTICAL")
			:SetStyle("padding.top", 39)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ViewContainer", "content")
				:SetNavCallback(private.ContentNavCallback)
			)
		)
	local content = frame:GetElement("contentFrame.content")
	local settingNav = frame:GetElement("settingNavigation")
	for _, location in ipairs(SECTIONS) do
		local navFrame = settingNav:GetElement(location)
	    for _, settingName in ipairs(private.settingPages[location]) do
			navFrame:AddChild(TSMAPI_FOUR.UI.NewElement("Button", settingName)
				:SetStyle("height", 20)
				:SetStyle("justifyH", "LEFT")
				:SetStyle("margin.top", 8)
				:SetStyle("margin.left", 16)
				:SetStyle("fontHeight", 14)
				:SetContext(settingName)
				:SetText(settingName)
				:SetScript("OnClick", private.NavButtonOnClick)
			)
			content:AddPath(settingName, settingName == defaultPage)
			if private.childSettingsPages[settingName] then
				for _, childSettingName in ipairs(private.childSettingsPages[settingName]) do
					local path = settingName..SETTING_PATH_SEP..childSettingName
					navFrame:AddChild(TSMAPI_FOUR.UI.NewElement("Button", path)
						:SetStyle("height", 20)
						:SetStyle("justifyH", "LEFT")
						:SetStyle("margin.top", 4)
						:SetStyle("margin.left", 24)
						:SetStyle("fontHeight", 10)
						:SetContext(path)
						:SetText(strupper(childSettingName))
						:SetScript("OnClick", private.NavButtonOnClick)
					)
					content:AddPath(path, path == defaultPage)
				end
			end
		end
	end
	private.UpdateNavFrame(settingNav, defaultPage)
	return frame
end

function private.ContentNavCallback(content, path)
	return private.callback[path]()
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.NavButtonOnClick(button)
	local path = button:GetContext()
	if private.childSettingsPages[path] then
		-- select the first child
		path = path..SETTING_PATH_SEP..private.childSettingsPages[path][1]
	end

	local contentFrame = button:GetElement("__parent.__parent.__parent.contentFrame")
	local navFrame = contentFrame:GetElement("__parent.settingNavigation")
	private.UpdateNavFrame(navFrame, path)
	navFrame:Draw()
	contentFrame:GetElement("content"):SetPath(path, true)
end

function private.ResetBtnOnClick(button)
    local scope, namespace, key = strsplit(".", button:GetContext())
    local defaultValue = TSM.db:GetDefault(scope, namespace, key)
    TSM.db:Set(scope, nil, namespace, key, defaultValue)
    button:GetElement("__parent.__parent.input")
        :SetText(defaultValue)
        :Draw()
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.UpdateNavFrame(navFrame, selectedPath)
	local selectedSetting = strsplit(SETTING_PATH_SEP, selectedPath)
	for _, location in ipairs(SECTIONS) do
		for _, settingName in ipairs(private.settingPages[location]) do
			navFrame:GetElement(location ..".".. settingName)
				:SetStyle("font", settingName == selectedSetting and TSM.UI.Fonts.MontserratBold or TSM.UI.Fonts.MontserratRegular)
				:SetStyle("textColor", settingName == selectedSetting and "#ffffff" or "#e2e2e2")
			if private.childSettingsPages[settingName] then
				for _, childSettingName in ipairs(private.childSettingsPages[settingName]) do
					local path = settingName..SETTING_PATH_SEP..childSettingName
					if settingName == selectedSetting then
						navFrame:GetElement(location ..".".. path)
							:SetStyle("font", path == selectedPath and TSM.UI.Fonts.MontserratBold or TSM.UI.Fonts.MontserratBold)
							:SetStyle("textColor", path == selectedPath and "#ffd839" or "#e2e2e2")
							:Show()
					else
						navFrame:GetElement(location ..".".. path):Hide()
					end
				end
			end
		end
	end
end
