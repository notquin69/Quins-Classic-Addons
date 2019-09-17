-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Auctioning = TSM.MainUI.Operations:NewPackage("Auctioning")
local L = TSM.L
local private = { currentOperationName = nil }
local IGNORE_DURATION_OPTIONS = {
	L["None"],
	AUCTION_TIME_LEFT1.." ("..AUCTION_TIME_LEFT1_DETAIL..")",
	AUCTION_TIME_LEFT2.." ("..AUCTION_TIME_LEFT2_DETAIL..")",
	AUCTION_TIME_LEFT3.." ("..AUCTION_TIME_LEFT3_DETAIL..")",
}
local BELOW_MIN = { ["none"] = L["Don't Post Items"], ["minPrice"] = L["Post at Minimum Price"], ["maxPrice"] = L["Post at Maximum Price"], ["normalPrice"] = L["Post at Normal Price"], ["ignore"] = L["Ignore Auctions Below Min"] }
local BELOW_MIN_ORDER = { "none", "minPrice", "maxPrice", "normalPrice", "ignore" }
local ABOVE_MAX = { ["none"] = L["Don't Post Items"], ["minPrice"] = L["Post at Minimum Price"], ["maxPrice"] = L["Post at Maximum Price"], ["normalPrice"] = L["Post at Normal Price"] }
local ABOVE_MAX_ORDER = { "none", "minPrice", "maxPrice", "normalPrice" }


-- ============================================================================
-- Module Functions
-- ============================================================================

function Auctioning.OnInitialize()
	TSM.MainUI.Operations.RegisterModule("Auctioning", private.GetAuctioningOperationSettings)
end



-- ============================================================================
-- Auctioning Operation Settings UI
-- ============================================================================

function private.GetAuctioningOperationSettings(operationName)
	TSM.UI.AnalyticsRecordPathChange("main", "operations", "auctioning")
	private.currentOperationName = operationName
	return TSMAPI_FOUR.UI.NewElement("TabGroup", "tabs")
		:SetStyle("margin.top", 16)
		:SetNavCallback(private.GetAuctioningSettings)
		:AddPath(L["Details"], true)
		:AddPath(L["Posting"])
		:AddPath(L["Canceling"])
end

function private.GetDetailsSettings()
	TSM.UI.AnalyticsRecordPathChange("main", "operations", "auctioning", "details")
	local operation = TSM.Operations.GetSettings("Auctioning", private.currentOperationName)
	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "content")
		:SetStyle("background", "#1e1e1e")
		:SetStyle("padding.left", 16)
		:SetStyle("padding.right", 16)
		:SetStyle("padding.top", -8)
		:AddChild(TSM.MainUI.Operations.CreateHeadingLine("generalOptions", L["General Options"]))
		:AddChild(private.CreateToggleLine("matchStackSize", L["Match stack size?"]))
		:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("ignoreLowDuration", L["Ignore auctions by duration?"])
			:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "dropdown")
				:SetDisabled(TSM.Operations.HasRelationship("Auctioning", private.currentOperationName, "ignoreLowDuration"))
				:SetItems(IGNORE_DURATION_OPTIONS, IGNORE_DURATION_OPTIONS[operation.ignoreLowDuration + 1])
				:SetScript("OnSelectionChanged", private.AuctioningIgnoreLowDuration)
			)
		)
		:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("blacklist", L["Blacklisted players:"])
			:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "nameInput")
				:SetDisabled(TSM.Operations.HasRelationship("Auctioning", private.currentOperationName, "blacklist"))
				:SetStyle("background", "#9d9d9d")
				:SetHintText(L["Enter player name"])
				:SetScript("OnEnterPressed", private.BlacklistInputOnEnterPressed)
			)
		)
		:AddChildrenWithFunction(private.AddBlacklistPlayers)
		:AddChild(TSM.MainUI.Operations.GetOperationManagementElements("Auctioning", private.currentOperationName))
end

function private.GetPostingSettings()
	TSM.UI.AnalyticsRecordPathChange("main", "operations", "auctioning", "posting")
	local operation = TSM.Operations.GetSettings("Auctioning", private.currentOperationName)
	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "content")
		:SetStyle("background", "#1e1e1e")
		:SetStyle("padding.left", 16)
		:SetStyle("padding.right", 16)
		:SetStyle("padding.top", -8)
		:AddChild(TSM.MainUI.Operations.CreateHeadingLine("postingSetingsTitle", L["Posting Settings"]))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "postingSetingsDesc")
			:SetStyle("margin.top", -12)
			:SetStyle("margin.bottom", 24)
			:SetStyle("height", 16)
			:SetStyle("fontHeight", 12)
			:SetText(L["Adjust the settings below to set how groups attached to this operation will be auctioned."])
		)
		:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("duration", L["Set auction duration to:"])
			:AddChild(TSMAPI_FOUR.UI.NewElement("Toggle", "durationToggle")
				:SetStyle("border", "#e2e2e2")
				:SetStyle("textColor", "#e2e2e2")
				:SetStyle("selectedBackground", "#e2e2e2")
				:SetStyle("height", 24)
				:SetDisabled(TSM.Operations.HasRelationship("Auctioning", private.currentOperationName, "duration"))
				:AddOption(TSM.CONST.AUCTION_DURATIONS[1], operation.duration == 1)
				:AddOption(TSM.CONST.AUCTION_DURATIONS[2], operation.duration == 2)
				:AddOption(TSM.CONST.AUCTION_DURATIONS[3], operation.duration == 3)
				:SetScript("OnValueChanged", private.SetAuctioningDuration)
			)
		)
		:AddChild(private.CreateNumericInputLine("postCap", L["Set post cap to:"], 200))
		:AddChild(private.CreateNumericInputLine("stackSize", L["Set posted stack size to:"], 1000))
		:AddChild(private.CreateToggleLine("stackSizeIsCap", L["Allow partial stack?"]))
		:AddChild(private.CreateNumericInputLine("keepQuantity", L["Keep this amount in bags:"], 5000))
		:AddChild(private.CreateNumericInputLine("maxExpires", L["Don't post after this many expires:"], 5000))
		:AddChild(TSM.MainUI.Operations.CreateHeadingLine("priceSettingsTitle", L["Price Settings"]))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "priceSettingsDesc")
			:SetStyle("margin.top", -12)
			:SetStyle("margin.bottom", 24)
			:SetStyle("height", 16)
			:SetStyle("fontHeight", 12)
			:SetText(L["Adjust the settings below to set how groups attached to this operation will be priced."])
		)
		:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("bidPercent", L["Set bid as percentage of buyout:"])
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "bidPercentInner")
				:SetLayout("HORIZONTAL")
				-- move the right by the width of the input box so this frame gets half the total width
				:SetStyle("margin.right", -96)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
					:SetStyle("width", 96)
					:SetStyle("font", TSM.UI.Fonts.MontserratBold)
					:SetStyle("fontHeight", 16)
					:SetStyle("justifyH", "CENTER")
					:SetDisabled(TSM.Operations.HasRelationship("Auctioning", private.currentOperationName, "bidPercent"))
					:SetText((operation.bidPercent * 100).."%")
					:SetScript("OnEnterPressed", private.BidPercentOnEnterPressed)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
			)
		)
		:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("undercut", L["Undercut amount:"])
			:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "undercutInner")
				:SetLayout("HORIZONTAL")
				-- move the right by the width of the input box so this frame gets half the total width
				:SetStyle("margin.right", -96)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
					:SetStyle("width", 180)
					:SetStyle("font", TSM.UI.Fonts.MontserratBold)
					:SetStyle("fontHeight", 16)
					:SetStyle("justifyH", "CENTER")
					:SetDisabled(TSM.Operations.HasRelationship("Auctioning", private.currentOperationName, "undercut"))
					:SetSettingInfo(operation, "undercut", TSM.MainUI.Operations.CheckCustomPrice)
					:SetText(TSM.Money.ToString(TSM.Money.FromString(operation.undercut)) or TSM.Money.ToString(operation.undercut) or operation.undercut)
					:SetScript("OnEnterPressed", private.UndercutOnChanged)
					:SetScript("OnTabPressed", private.UndercutOnChanged)
				)
				:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "minPriceOuterFrame")
			:SetLayout("VERTICAL")
			:SetStyle("margin.left", -16)
			:SetStyle("margin.right", -16)
			:SetStyle("margin.top", 8)
			:SetStyle("margin.bottom", 8)
			:SetStyle("padding.left", 16)
			:SetStyle("padding.right", 16)
			:SetStyle("padding.top", 12)
			:SetStyle("padding.bottom", -4)
			:SetStyle("background", "#2a2a2a")
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("minPrice", L["Set Minimum Price:"]))
			:AddChild(TSMAPI_FOUR.UI.NewElement("BorderedFrame", "minPrice")
				:SetLayout("HORIZONTAL")
				:SetStyle("borderTheme", "roundLight")
				:SetStyle("margin.bottom", 16)
				:AddChild(TSMAPI_FOUR.UI.NewElement("ScrollFrame", "scroll")
					:SetStyle("height", 99)
					:SetStyle("margin.bottom", 2)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
						:SetStyle("height", 97)
						:SetStyle("margin", { left = 2, right = 8 })
						:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
						:SetStyle("fontHeight", 14)
						:SetStyle("justifyH", "LEFT")
						:SetDisabled(TSM.Operations.HasRelationship("Auctioning", private.currentOperationName, "minPrice"))
						:SetSettingInfo(operation, "minPrice", TSM.MainUI.Operations.CheckCustomPrice)
						:SetText(TSM.Money.ToString(TSM.Money.FromString(operation.minPrice)) or TSM.Money.ToString(operation.minPrice) or operation.minPrice)
						:SetSpacing(6)
						:SetMultiLine(true, true)
						:SetScript("OnSizeChanged", private.OperationOnSizeChanged)
						:SetScript("OnCursorChanged", private.OperationOnCursorChanged)
						:SetScript("OnEnterPressed", private.MinPriceOnEnterPressed)
					)
				)
				:SetScript("OnMouseUp", private.OperationOnMouseUp)
			)
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("priceReset", L["When below minimum:"])
				:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "priceResetDropdown")
					:SetDisabled(TSM.Operations.HasRelationship("Auctioning", private.currentOperationName, "priceReset"))
					:SetDictionaryItems(BELOW_MIN, BELOW_MIN[operation.priceReset], BELOW_MIN_ORDER, false)
					:SetSettingInfo(operation, "priceReset")
				)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "maxPriceOuterFrame")
			:SetLayout("VERTICAL")
			:SetStyle("margin.left", -16)
			:SetStyle("margin.right", -16)
			:SetStyle("margin.top", 8)
			:SetStyle("margin.bottom", 8)
			:SetStyle("padding.left", 16)
			:SetStyle("padding.right", 16)
			:SetStyle("padding.top", 12)
			:SetStyle("padding.bottom", -4)
			:SetStyle("background", "#2a2a2a")
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("maxPrice", L["Set Maximum Price:"]))
			:AddChild(TSMAPI_FOUR.UI.NewElement("BorderedFrame", "maxPrice")
				:SetLayout("HORIZONTAL")
				:SetStyle("borderTheme", "roundLight")
				:SetStyle("margin.bottom", 16)
				:AddChild(TSMAPI_FOUR.UI.NewElement("ScrollFrame", "scroll")
					:SetStyle("height", 99)
					:SetStyle("margin.bottom", 2)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
						:SetStyle("height", 97)
						:SetStyle("margin", { left = 2, right = 8 })
						:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
						:SetStyle("fontHeight", 14)
						:SetStyle("justifyH", "LEFT")
						:SetDisabled(TSM.Operations.HasRelationship("Auctioning", private.currentOperationName, "maxPrice"))
						:SetSettingInfo(operation, "maxPrice", TSM.MainUI.Operations.CheckCustomPrice)
						:SetText(TSM.Money.ToString(TSM.Money.FromString(operation.maxPrice)) or TSM.Money.ToString(operation.maxPrice) or operation.maxPrice)
						:SetSpacing(6)
						:SetMultiLine(true, true)
						:SetScript("OnSizeChanged", private.OperationOnSizeChanged)
						:SetScript("OnCursorChanged", private.OperationOnCursorChanged)
						:SetScript("OnEnterPressed", private.MaxPriceOnEnterPressed)
					)
				)
				:SetScript("OnMouseUp", private.OperationOnMouseUp)
			)
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("aboveMax", L["When above maximum:"])
				:AddChild(TSMAPI_FOUR.UI.NewElement("Dropdown", "aboveMaxDropdown")
					:SetDisabled(TSM.Operations.HasRelationship("Auctioning", private.currentOperationName, "aboveMax"))
					:SetDictionaryItems(ABOVE_MAX, ABOVE_MAX[operation.aboveMax], ABOVE_MAX_ORDER)
					:SetSettingInfo(operation, "aboveMax")
				)
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "normalPriceOuterFrame")
			:SetLayout("VERTICAL")
			:SetStyle("margin.left", -16)
			:SetStyle("margin.right", -16)
			:SetStyle("margin.top", 8)
			:SetStyle("padding.left", 16)
			:SetStyle("padding.right", 16)
			:SetStyle("padding.top", 12)
			:SetStyle("padding.bottom", 12)
			:SetStyle("background", "#2a2a2a")
			:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("normalPrice", L["Set Normal Price:"]))
			:AddChild(TSMAPI_FOUR.UI.NewElement("BorderedFrame", "normalPrice")
				:SetLayout("HORIZONTAL")
				:SetStyle("borderTheme", "roundLight")
				:SetStyle("margin.bottom", 16)
				:AddChild(TSMAPI_FOUR.UI.NewElement("ScrollFrame", "scroll")
					:SetStyle("height", 99)
					:SetStyle("margin.bottom", 2)
					:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
						:SetStyle("height", 97)
						:SetStyle("margin", { left = 2, right = 8 })
						:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
						:SetStyle("fontHeight", 14)
						:SetStyle("justifyH", "LEFT")
						:SetDisabled(TSM.Operations.HasRelationship("Auctioning", private.currentOperationName, "normalPrice"))
						:SetSettingInfo(operation, "normalPrice", TSM.MainUI.Operations.CheckCustomPrice)
						:SetText(TSM.Money.ToString(TSM.Money.FromString(operation.normalPrice)) or TSM.Money.ToString(operation.normalPrice) or operation.normalPrice)
						:SetSpacing(6)
						:SetMultiLine(true, true)
						:SetScript("OnSizeChanged", private.OperationOnSizeChanged)
						:SetScript("OnCursorChanged", private.OperationOnCursorChanged)
						:SetScript("OnEnterPressed", private.NormalPriceOnEnterPressed)
					)
				)
				:SetScript("OnMouseUp", private.OperationOnMouseUp)
			)
		)
end

function private.GetCancelingSettings()
	TSM.UI.AnalyticsRecordPathChange("main", "operations", "auctioning", "canceling")
	local operation = TSM.Operations.GetSettings("Auctioning", private.currentOperationName)
	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "content")
		:SetStyle("background", "#1e1e1e")
		:SetStyle("padding.left", 16)
		:SetStyle("padding.right", 16)
		:SetStyle("padding.top", -8)
		:AddChild(TSM.MainUI.Operations.CreateHeadingLine("cancelSetingsTitle", L["Canceling Settings"]))
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "cancelSetingsDesc")
			:SetStyle("margin.top", -12)
			:SetStyle("margin.bottom", 24)
			:SetStyle("height", 16)
			:SetStyle("fontHeight", 12)
			:SetText(L["Adjust the settings below to set how groups attached to this operation will be cancelled."])
		)
		:AddChild(private.CreateToggleLine("cancelUndercut", L["Cancel undercut auctions?"]))
		:AddChild(private.CreateToggleLine("cancelRepost", L["Cancel to repost higher?"]))
		:AddChild(private.CreateNumericInputLine("keepPosted", L["Keep posted:"], 500))
		:AddChild(TSM.MainUI.Operations.CreateLinkedSettingLine("cancelRepostThreshold", L["Repost Higher Threshold"])
			:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "input")
				:SetStyle("background", "#5c5c5c")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 16)
				:SetStyle("justifyH", "LEFT")
				:SetStyle("textColor", "#ffffff")
				:SetDisabled(TSM.Operations.HasRelationship("Auctioning", private.currentOperationName, "cancelRepostThreshold"))
				:SetSettingInfo(operation, "cancelRepostThreshold", TSM.MainUI.Operations.CheckCustomPrice)
				:SetText(TSM.Money.ToString(TSM.Money.FromString(operation.cancelRepostThreshold)) or TSM.Money.ToString(operation.cancelRepostThreshold) or operation.cancelRepostThreshold)
				:SetScript("OnEnterPressed", private.CancelRepostThresholdOnChanged)
				:SetScript("OnTabPressed", private.CancelRepostThresholdOnChanged)
			)
		)
end

function private.GetAuctioningSettings(self, button)
	if button == L["Details"] then
		return private.GetDetailsSettings()
	elseif button == L["Posting"] then
		return private.GetPostingSettings()
	elseif button == L["Canceling"] then
		return private.GetCancelingSettings()
	else
		error("Unknown button!")
	end
end

function private.AddBlacklistPlayers(frame)
	local operation = TSM.Operations.GetSettings("Auctioning", private.currentOperationName)
	if operation.blacklist == "" then return end
	local containerFrame = TSMAPI_FOUR.UI.NewElement("Frame", "blacklistFrame")
		:SetLayout("FLOW")
	for index, player in TSMAPI_FOUR.Util.VarargIterator(strsplit(",", operation.blacklist)) do
		containerFrame:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "blacklist" .. index)
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:SetStyle("margin.bottom", 8)
			:SetStyle("margin.right", 12)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "text")
				:SetStyle("autoWidth", true)
				:SetStyle("font", TSM.UI.Fonts.MontserratBold)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#dd2222")
				:SetStyle("margin.right", 2)
				:SetText(player)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "removeBtn")
				:SetStyle("width", 14)
				:SetStyle("height", 14)
				:SetStyle("backgroundTexturePack", "iconPack.14x14/Close/Default")
				:SetContext(player)
				:SetScript("OnClick", private.RemoveBlacklistOnClick)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
		)
	end
	frame:AddChild(containerFrame)
end

function private.CreateNumericInputLine(key, label, max)
	local operation = TSM.Operations.GetSettings("Auctioning", private.currentOperationName)
	local hasRelationship = TSM.Operations.HasRelationship("Auctioning", private.currentOperationName, key)
	return TSM.MainUI.Operations.CreateLinkedSettingLine(key, label)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", key.."Frame")
			:SetLayout("HORIZONTAL")
			-- move the right by the width of the input box so this frame gets half the total width
			:SetStyle("margin.right", -112)
			:AddChild(TSMAPI_FOUR.UI.NewElement("InputNumeric", "input")
				:SetStyle("width", 96)
				:SetStyle("height", 24)
				:SetStyle("margin.right", 16)
				:SetStyle("justifyH", "CENTER")
				:SetStyle("font", TSM.UI.Fonts.MontserratBold)
				:SetStyle("fontHeight", 16)
				:SetDisabled(hasRelationship)
				:SetSettingInfo(operation, key)
				:SetMaxNumber(max)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "maxLabel")
				:SetStyle("fontHeight", 12)
				:SetText(format(L["(max %d)"], max))
				:SetStyle("textColor", hasRelationship and "#424242" or "#e2e2e2")
			)
		)
end

function private.CreateToggleLine(key, label)
	local operation = TSM.Operations.GetSettings("Auctioning", private.currentOperationName)
	return TSM.MainUI.Operations.CreateLinkedSettingLine(key, label)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", key.."Frame")
			:SetLayout("HORIZONTAL")
			-- move the right by the width of the toggle so this frame gets half the total width
			:SetStyle("margin.right", -TSM.UI.TexturePacks.GetWidth("uiFrames.ToggleOn"))
			:AddChild(TSMAPI_FOUR.UI.NewElement("ToggleOnOff", "toggle")
				:SetDisabled(TSM.Operations.HasRelationship("Auctioning", private.currentOperationName, key))
				:SetSettingInfo(operation, key)
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
		)
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.AuctioningIgnoreLowDuration(self, selection)
	local operation = TSM.Operations.GetSettings("Auctioning", private.currentOperationName)
	operation.ignoreLowDuration = TSMAPI_FOUR.Util.GetDistinctTableKey(IGNORE_DURATION_OPTIONS, selection) - 1
end

function private.BlacklistInputOnEnterPressed(input)
	local newPlayer = strtrim(input:GetText())
	if newPlayer == "" or strfind(newPlayer, ",") or newPlayer ~= TSMAPI_FOUR.Util.StrEscape(newPlayer) then
		-- this is an invalid player name
		return
	end
	local operation = TSM.Operations.GetSettings("Auctioning", private.currentOperationName)
	local found = false
	for _, player in TSMAPI_FOUR.Util.VarargIterator(strsplit(",", operation.blacklist)) do
		if newPlayer == player then
			-- this player is already added
			input:SetText("")
			found = true
		end
	end
	if found then
		return
	end
	operation.blacklist = (operation.blacklist == "") and newPlayer or (operation.blacklist..","..newPlayer)
	input:GetParentElement():GetParentElement():GetParentElement():ReloadContent()
end

function private.MoneyValueConvert(input)
	local text = gsub(strtrim(input:GetText()), TSMAPI_FOUR.Util.StrEscape(LARGE_NUMBER_SEPERATOR), "")
	local value = min(max(tonumber(text) or TSM.Money.FromString(text) or 0, 0), MAXIMUM_BID_PRICE)

	input:SetFocused(false)
	input:SetText(TSM.Money.ToString(value))
		:Draw()
end

function private.MoneyFocusGained(input)
	input:HighlightText()
end

function private.RemoveBlacklistOnClick(self)
	local player = self:GetContext()
	-- FIXME: This sort of logic should go within some Auctioning-specific operation setting wrapper code
	local operation = TSM.Operations.GetSettings("Auctioning", private.currentOperationName)
	if operation.blacklist == player then
		operation.blacklist = ""
	else
		-- handle cases where this entry is at the start, in the middle, and at the end
		operation.blacklist = gsub(operation.blacklist, "^"..player..",", "")
		operation.blacklist = gsub(operation.blacklist, ","..player..",", ",")
		operation.blacklist = gsub(operation.blacklist, ","..player.."$", "")
	end
	self:GetParentElement():GetParentElement():GetParentElement():GetParentElement():ReloadContent()
end

function private.SetAuctioningDuration(self, value)
	local operation = TSM.Operations.GetSettings("Auctioning", private.currentOperationName)
	operation.duration = TSMAPI_FOUR.Util.GetDistinctTableKey(TSM.CONST.AUCTION_DURATIONS, value)
end

function private.BidPercentOnEnterPressed(self)
	local value = strmatch(strtrim(self:GetText()), "^([0-9]+) *%%?$")
	local operation = TSM.Operations.GetSettings("Auctioning", private.currentOperationName)
	value = max(tonumber(value) or (operation.bidPercent and operation.bidPercent * 100 or 100), 0)
	value = min(value, 100)
	value = TSMAPI_FOUR.Util.Round(value)
	value = value / 100
	operation.bidPercent = value

	local percentValue = (value * 100) .. "%"
	self:SetText(percentValue)

	self:Draw()
end

function private.OperationOnSizeChanged(input, width, height)
	if input:HasFocus() then
		local text = input:GetText()
		input:SetText(TSM.Money.ToString(TSM.Money.FromString(text)) or TSM.Money.ToString(text) or text)
	end

	input:SetStyle("height", height)
	input:GetParentElement():Draw()
end

function private.OperationOnCursorChanged(input, _, y)
	local scrollFrame = input:GetParentElement()
	scrollFrame._scrollbar:SetValue(TSMAPI_FOUR.Util.Round(abs(y) / (input:_GetStyle("height") - 22) * scrollFrame:_GetMaxScroll()))
end

function private.OperationOnMouseUp(frame)
	frame:GetElement("scroll.input"):SetFocused(true)
end

function private.UndercutOnChanged(input)
	local text = input:GetText()
	if not TSM.MainUI.Operations.CheckCustomPrice(text, true) then
		local operation = TSM.Operations.GetSettings("Auctioning", private.currentOperationName)
		input:SetText(TSM.Money.ToString(TSM.Money.FromString(operation.undercut)) or TSM.Money.ToString(operation.undercut) or operation.undercut)
	else
		input:SetText(TSM.Money.ToString(TSM.Money.FromString(text)) or TSM.Money.ToString(text) or text)
			:Draw()
	end
end

function private.CancelRepostThresholdOnChanged(input)
	local text = input:GetText()
	if not TSM.MainUI.Operations.CheckCustomPrice(text, true) then
		local operation = TSM.Operations.GetSettings("Auctioning", private.currentOperationName)
		input:SetText(TSM.Money.ToString(TSM.Money.FromString(operation.cancelRepostThreshold)) or TSM.Money.ToString(operation.cancelRepostThreshold) or operation.cancelRepostThreshold)
	else
		input:SetText(TSM.Money.ToString(TSM.Money.FromString(text)) or TSM.Money.ToString(text) or text)
			:Draw()
	end
end

function private.MinPriceOnEnterPressed(input)
	local text = input:GetText()
	if not TSM.MainUI.Operations.CheckCustomPrice(text, true) then
		local operation = TSM.Operations.GetSettings("Auctioning", private.currentOperationName)
		input:SetText(TSM.Money.ToString(TSM.Money.FromString(operation.minPrice)) or TSM.Money.ToString(operation.minPrice) or operation.minPrice)
		input:SetFocused(true)

		private.OperationOnSizeChanged(input, nil, input:GetHeight())
	else
		input:SetText(TSM.Money.ToString(TSM.Money.FromString(text)) or TSM.Money.ToString(text) or text)
			:Draw()
	end
end

function private.MaxPriceOnEnterPressed(input)
	local text = input:GetText()
	if not TSM.MainUI.Operations.CheckCustomPrice(text, true) then
		local operation = TSM.Operations.GetSettings("Auctioning", private.currentOperationName)
		input:SetText(TSM.Money.ToString(TSM.Money.FromString(operation.maxPrice)) or TSM.Money.ToString(operation.maxPrice) or operation.maxPrice)
		input:SetFocused(true)

		private.OperationOnSizeChanged(input, nil, input:GetHeight())
	else
		input:SetText(TSM.Money.ToString(TSM.Money.FromString(text)) or TSM.Money.ToString(text) or text)
			:Draw()
	end
end

function private.NormalPriceOnEnterPressed(input)
	local text = input:GetText()
	if not TSM.MainUI.Operations.CheckCustomPrice(text, true) then
		local operation = TSM.Operations.GetSettings("Auctioning", private.currentOperationName)
		input:SetText(TSM.Money.ToString(TSM.Money.FromString(operation.normalPrice)) or TSM.Money.ToString(operation.normalPrice) or operation.normalPrice)
		input:SetFocused(true)

		private.OperationOnSizeChanged(input, nil, input:GetHeight())
	else
		input:SetText(TSM.Money.ToString(TSM.Money.FromString(text)) or TSM.Money.ToString(text) or text)
			:Draw()
	end
end
