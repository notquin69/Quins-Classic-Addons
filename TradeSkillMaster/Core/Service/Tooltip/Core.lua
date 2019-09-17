-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Tooltip = TSM:NewPackage("Tooltip")
local L = TSM.L
local CachedTooltip = TSMAPI_FOUR.Class.DefineClass("CachedTooltip")
local TOOLTIP_CACHE_TIME = 5
local private = {
	tooltipInfo = {},
	tooltip = nil,
}
local LINE_COLOR = { r = 130 / 255, g = 130 / 255, b = 250 / 255 }
local HEADING_COLOR_STR = "|cffffff00"



-- ============================================================================
-- Module Functions
-- ============================================================================

function Tooltip.OnInitialize()
	private.tooltip = CachedTooltip()
	TSM.TooltipLib:Initialize(private.LoadTooltip)
	local orig = OpenMailAttachment_OnEnter
	OpenMailAttachment_OnEnter = function(self, index)
		private.lastMailTooltipUpdate = private.lastMailTooltipUpdate or 0
		if private.lastMailTooltipIndex ~= index or private.lastMailTooltipUpdate + 0.1 < GetTime() then
			private.lastMailTooltipUpdate = GetTime()
			private.lastMailTooltipIndex = index
			orig(self, index)
		end
	end
end

function Tooltip.Register(module, defaults, callback)
	TSM.db.global.tooltipOptions.moduleTooltips[module] = TSM.db.global.tooltipOptions.moduleTooltips[module] or defaults
	tinsert(private.tooltipInfo, {
		module = module,
		callback = callback,
	})
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.LoadTooltip(tipFrame, link, quantity)
	if not TSM.db.global.tooltipOptions.enabled then
		return
	end
	if (TSM.db.global.tooltipOptions.tooltipShowModifier == "alt" and not IsAltKeyDown()) or (TSM.db.global.tooltipOptions.tooltipShowModifier == "ctrl" and not IsControlKeyDown()) then
		return
	end
	local itemString = TSMAPI_FOUR.Item.ToItemString(link)
	if not itemString then return end

	quantity = max(IsShiftKeyDown() and quantity or 1, 1)
	private.tooltip:_Populate(itemString, quantity)
	private.tooltip:_Draw(tipFrame)
end



-- ============================================================================
-- CachedTooltip - Class Meta Methods
-- ============================================================================

function CachedTooltip.__init(self)
	self._rootLines = {}
	self._currentLines = self._rootLines
	self._lastUpdate = 0
	self._modifier = nil
	self._inCombat = false
	self._itemString = nil
	self._quantity = nil
end



-- ============================================================================
-- CachedTooltip - Public Methods
-- ============================================================================

function CachedTooltip.FormatMoney(self, value, color)
	color = color or "|cffffffff"
	if TSM.db.global.tooltipOptions.tooltipPriceFormat == "icon" then
		return TSM.Money.ToString(value, color, "OPT_ICON")
	else
		return TSM.Money.ToString(value, color)
	end
end

function CachedTooltip.AddLine(self, lineLeft, lineRight)
	local indent = self:_GetIndent()
	if lineRight then
		lineLeft = lineLeft.."\t"..lineRight
	end
	tinsert(self._currentLines, strrep("  ", indent)..lineLeft)
end

function CachedTooltip.AddItemValueLine(self, label, value)
	if self._quantity > 1 then
		label = label.." x"..self._quantity
		value = value * self._quantity
	end
	self:AddLine(label, self:FormatMoney(value))
end

function CachedTooltip.AddSubItemValueLine(self, itemString, value, multiplier, matRate, minAmount, maxAmount)
	local name = TSMAPI_FOUR.Item.GetName(itemString)
	local quality = TSMAPI_FOUR.Item.GetQuality(itemString)
	if not name or not quality then
		return
	end
	multiplier = TSMAPI_FOUR.Util.Round(multiplier * self._quantity, 0.001)
	matRate = matRate and matRate * 100
	matRate = matRate and matRate.."% " or ""
	local range = (minAmount and maxAmount) and (minAmount ~= maxAmount and "|cffffff00 ["..minAmount.."-"..maxAmount.."]|r" or "|cffffff00 ["..minAmount.."]|r") or ""
	value = value * multiplier
	self:AddLine("|c"..select(4, GetItemQualityColor(quality))..matRate..name.." x"..multiplier.."|r"..range, self:FormatMoney(value))
end

function CachedTooltip.StartSection(self)
	local lines = TSMAPI_FOUR.Util.AcquireTempTable()
	lines._parent = self._currentLines
	self._currentLines = lines
end

function CachedTooltip.EndSection(self, headingTextLeft, headingTextRight)
	local lines = self._currentLines
	assert(lines ~= self._rootLines)
	self._currentLines = lines._parent
	if #lines > 0 then
		if headingTextLeft and self._currentLines == self._rootLines then
			headingTextLeft = HEADING_COLOR_STR..headingTextLeft.."|r"
		end
		if headingTextRight then
			self:AddLine(headingTextLeft, headingTextRight)
		elseif headingTextLeft then
			self:AddLine(headingTextLeft)
		end
		for _, line in ipairs(lines) do
			self:AddLine(line)
		end
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(lines)
end



-- ============================================================================
-- CachedTooltip - Private Methods
-- ============================================================================

function CachedTooltip._GetIndent(self)
	local indent = 0
	local tbl = self._currentLines
	while tbl._parent do
		indent = indent + 1
		tbl = tbl._parent
	end
	assert(tbl == self._rootLines)
	return indent
end

function CachedTooltip._GetModifierHash(self)
	return (IsShiftKeyDown() and 4 or 0) + (IsAltKeyDown() and 2 or 0) + (IsControlKeyDown() and 1 or 0)
end

function CachedTooltip._IsCached(self, itemString, quantity)
	if self:_GetModifierHash() ~= self._modifier then
		return false
	end
	if self._itemString ~= itemString or self._quantity ~= quantity then
		return false
	end
	if GetTime() - self._lastUpdate >= TOOLTIP_CACHE_TIME then
		return false
	end
	if InCombatLockdown() ~= self._inCombat then
		return false
	end
	return true
end

function CachedTooltip._Populate(self, itemString, quantity)
	if self:_IsCached(itemString, quantity) then
		-- have the lines cached already
		return
	end

	assert(self._currentLines == self._rootLines)
	wipe(self._rootLines)
	self._lastUpdate = GetTime()
	self._modifier = self:_GetModifierHash()
	self._inCombat = InCombatLockdown()
	self._itemString = itemString
	self._quantity = quantity

	if InCombatLockdown() then
		self:AddLine(L["Can't load TSM tooltip while in combat"])
	else
		-- The general tooltip code isn't registered like the others
		self:StartSection()
		TSM.Tooltip.General.LoadTooltip(self, itemString)
		self:EndSection(L["TradeSkillMaster Info"])
		-- insert module lines
		for _, info in ipairs(private.tooltipInfo) do
			self:StartSection()
			local headingTextRight = info.callback(self, itemString, TSM.db.global.tooltipOptions.moduleTooltips[info.module])
			self:EndSection("TSM "..info.module, headingTextRight)
		end
	end
end

function CachedTooltip._Draw(self, tipFrame)
	assert(self._currentLines == self._rootLines)
	if #self._rootLines == 0 then
		return
	end

	TSM.TooltipLib:AddLine(tipFrame, " ", 1, 1, 0)
	for i = 1, #self._rootLines do
		local left, right = strsplit("\t", self._rootLines[i])
		if right then
			TSM.TooltipLib:AddDoubleLine(tipFrame, left, right, LINE_COLOR.r, LINE_COLOR.g, LINE_COLOR.b, LINE_COLOR.r, LINE_COLOR.g, LINE_COLOR.b)
		else
			TSM.TooltipLib:AddLine(tipFrame, left, LINE_COLOR.r, LINE_COLOR.g, LINE_COLOR.b)
		end
	end
	TSM.TooltipLib:AddLine(tipFrame, " ", 1, 1, 0)
end
