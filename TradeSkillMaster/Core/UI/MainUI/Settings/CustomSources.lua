-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local CustomSources = TSM.MainUI.Settings:NewPackage("CustomSources")
local L = TSM.L
local private = { selectedRow = nil, isEditing = nil, editingElement = nil }



-- ============================================================================
-- Module Functions
-- ============================================================================

function CustomSources.OnInitialize()
	TSM.MainUI.Settings.RegisterSettingPage(L["Custom Sources"], "middle", private.GetCustomSourcesSettingsFrame)
end



-- ============================================================================
-- Custom Sources Settings UI
-- ============================================================================

function private.GetCustomSourcesSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "custom_sources")
	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "content")
		:SetStyle("padding.left", 12)
		:SetStyle("padding.right", 12)
		:SetScript("OnHide", private.FrameOnHide)
		:AddChild(TSM.MainUI.Settings.CreateHeading("heading", L["Price Variables"]))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "desc")
			:SetStyle("height", 54)
			:SetStyle("margin.bottom", 24)
			:SetStyle("fontHeight", 14)
			:SetText(L["Price Variables allow you to create more advanced custom prices for use throughout the addon. You'll be able to use these new variables in the same way you can use the built-in price sources such as 'vendorsell' and 'vendorbuy'."])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line1")
			:SetStyle("height", 1)
			:SetStyle("margin.left", -12)
			:SetStyle("margin.right", -12)
			:SetStyle("color", "#585858")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "tableHeading")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 22)
			:SetStyle("margin.left", -16)
			:SetStyle("margin.right", -12)
			:SetStyle("padding.left", 16)
			:SetStyle("padding.right", 12)
			:SetStyle("background", "#404040")
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "col1")
				:SetStyle("width", 192)
				:SetStyle("margin.right", 8)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 12)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Variable Name"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "col2")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 12)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Custom Price Source"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Texture", "line1")
			:SetStyle("height", 1)
			:SetStyle("margin.left", -12)
			:SetStyle("margin.right", -12)
			:SetStyle("color", "#585858")
		)
		:AddChildrenWithFunction(private.AddCustomPriceRows)
		:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "addNewBtn")
			:SetStyle("margin.top", 24)
			:SetStyle("height", 20)
			:SetText(L["ADD NEW CUSTOM PRICE SOURCE"])
			:SetScript("OnClick", private.AddNewButtonOnClick)
		)
end

function private.CreateCustomPriceRow(name)
	local priceString = TSM.db.global.userData.customPriceSources[name]
	local row = TSMAPI_FOUR.UI.NewElement("Frame", "row_"..name)
		:SetLayout("HORIZONTAL")
		:SetStyle("height", 28)
		:SetStyle("margin.left", -16)
		:SetStyle("margin.right", -12)
		:SetStyle("padding.left", 16)
		:SetStyle("padding.right", 12)
		:SetContext(name)
		:SetScript("OnEnter", private.CustomPriceRowOnEnter)
		:SetScript("OnLeave", private.CustomPriceRowOnLeave)
		:AddChild(TSMAPI_FOUR.UI.NewElement("EditableText", "nameText")
			:SetStyle("width", 192)
			:SetStyle("margin.right", 8)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 12)
			:SetStyle("textColor", "#ffffff")
			:SetText(name)
			:SetScript("OnEnter", TSM.UI.GetPropagateScriptFunc("OnEnter"))
			:SetScript("OnLeave", TSM.UI.GetPropagateScriptFunc("OnLeave"))
			:SetScript("OnMouseDown", private.NameValueTextOnClick)
			:SetScript("OnValueChanged", private.NameOnValueChanged)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("EditableText", "valueText")
			:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
			:SetStyle("fontHeight", 12)
			:SetStyle("textColor", "#ffffff")
			:SetText(priceString)
			:SetScript("OnEnter", TSM.UI.GetPropagateScriptFunc("OnEnter"))
			:SetScript("OnLeave", TSM.UI.GetPropagateScriptFunc("OnLeave"))
			:SetScript("OnMouseDown", private.NameValueTextOnClick)
			:SetScript("OnValueChanged", private.ValueOnValueChanged)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("ActionButton", "deleteBtn")
			:SetStyle("width", 90)
			:SetStyle("height", 20)
			:SetText(strupper(DELETE))
			:SetScript("OnClick", private.DeleteCustomPriceOnClick)
			:SetScript("OnEnter", TSM.UI.GetPropagateScriptFunc("OnEnter"))
			:SetScript("OnLeave", TSM.UI.GetPropagateScriptFunc("OnLeave"))
		)
	row:GetElement("deleteBtn"):Hide()
	return row
end

function private.AddCustomPriceRows(frame)
	local names = TSMAPI_FOUR.Util.AcquireTempTable()
	for name in pairs(TSM.db.global.userData.customPriceSources) do
		tinsert(names, name)
	end
	sort(names)
	for _, name in ipairs(names) do
		frame:AddChild(private.CreateCustomPriceRow(name))
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(names)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FrameOnHide(frame)
	private.editingElement = nil
end

function private.CustomPriceRowOnEnter(frame)
	frame:GetElement("deleteBtn"):Show()
	frame:Draw()
end

function private.CustomPriceRowOnLeave(frame)
	frame:GetElement("deleteBtn"):Hide()
	frame:Draw()
end

function private.NameValueTextOnClick(text)
	if private.editingElement then
		private.editingElement
			:SetEditing(false)
			:Draw()
		private.editingElement = nil
	end
	text:SetEditing(true)
	text:Draw()
	private.editingElement = text
end

function private.NameOnValueChanged(text, newName)
	local oldName = text:GetText()
	newName = strlower(strtrim(newName))
	if newName == "" then
		newName = oldName
	elseif gsub(newName, "([a-z]+)", "") ~= "" then
		TSM:Print(L["The name can ONLY contain letters. No spaces, numbers, or special characters."])
		newName = oldName
	elseif not TSMAPI_FOUR.CustomPrice.ValidateName(newName) then
		TSM:Printf(L["Price source with name '%s' already exists."], newName)
		newName = oldName
	else
		TSM.CustomPrice.RenameCustomPriceSource(oldName, newName)
	end
	text:GetParentElement():SetContext(newName)
	text:SetText(newName)
		:Draw()
end

function private.ValueOnValueChanged(text, newValue)
	local oldValue = text:GetText()
	newValue = strlower(strtrim(newValue))
	local isValid, errText = TSMAPI_FOUR.CustomPrice.Validate(newValue)
	if not isValid then
		TSM:Print(L["Invalid price source."].." "..errText)
		newValue = oldValue
	else
		TSM.db.global.userData.customPriceSources[text:GetParentElement():GetContext()] = newValue
	end
	text:SetText(newValue)
		:Draw()
end

function private.DeleteCustomPriceOnClick(button)
	if private.editingElement then
		private.editingElement
			:SetEditing(false)
			:Draw()
		private.editingElement = nil
	end
	TSM.db.global.userData.customPriceSources[button:GetParentElement():GetContext()] = nil
	local rowFrame = button:GetParentElement()
	local parentFrame = rowFrame:GetParentElement()
	parentFrame:RemoveChild(rowFrame)
	rowFrame:Release()
	parentFrame:Draw()
end

function private.AddNewButtonOnClick(button)
	-- generate a placeholder name
	local newName = nil
	local suffix = ""
	while not newName do
		for i = strbyte("a"), strbyte("z") do
			newName = "customprice"..suffix..strchar(i)
			if not TSM.db.global.userData.customPriceSources[newName] then
				break
			end
			newName = nil
		end
		suffix = suffix..strchar(random(strbyte("a"), strbyte("z")))
	end

	TSM.CustomPrice.CreateCustomPriceSource(newName, "")
	button:GetParentElement()
		:AddChildBeforeById("addNewBtn", private.CreateCustomPriceRow(newName))
		:Draw()
end
