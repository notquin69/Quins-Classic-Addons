-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Custom Price Functions
-- @module CustomPrice

TSMAPI_FOUR.CustomPrice = {}
local _, TSM = ...
TSM:NewPackage("CustomPrice")
local L = TSM.L
local private = { context = {}, priceSourceKeys = {}, priceSourceInfo = {}, customPriceCache = {}, priceCache = {}, priceCacheActive = nil, proxyData = {}, mappedWarning = {} }
local ITEM_STRING_PATTERN = "[ip]:[0-9:%-]+"
local MONEY_PATTERNS = {
	"([0-9]+g[ ]*[0-9]+s[ ]*[0-9]+c)", -- g/s/c
	"([0-9]+g[ ]*[0-9]+s)", -- g/s
	"([0-9]+g[ ]*[0-9]+c)", -- g/c
	"([0-9]+s[ ]*[0-9]+c)", -- s/c
	"([0-9]+g)", -- g
	"([0-9]+s)", -- s
	"([0-9]+c)", -- c
}
local MATH_FUNCTIONS = {
	["avg"] = "self._avg",
	["min"] = "self._min",
	["max"] = "self._max",
	["first"] = "self._first",
	["check"] = "self._check",
	["ifgt"] = "self._ifgt",
	["ifgte"] = "self._ifgte",
	["iflt"] = "self._iflt",
	["iflte"] = "self._iflte",
	["ifeq"] = "self._ifeq",
	["round"] = "self._round",
	["roundup"] = "self._roundup",
	["rounddown"] = "self._rounddown",
}
local CUSTOM_PRICE_FUNC_TEMPLATE = [[
	return function(self, _item, _baseitem)
		local isTop
		local context = self.globalContext
		if not context.num then
			context.num = 0
			isTop = true
		end
		context.num = context.num + 1
		if context.num > 100 then
			if (context.lastPrint or 0) + 1 < time() then
				context.lastPrint = time()
				self.loopError(self.origStr)
			end
			return
		end

		local result = floor((%s) + 0.5)
		if context.num then
			context.num = context.num - 1
		end
		if isTop then
			context.num = nil
		end
		if not result or self.IsInvalid(result) or result <= 0 then return end
		return result
	end
]]
local MAPPED_PRICES = {
	dbglobalminbuyoutavg = "dbregionminbuyoutavg",
	dbglobalmarketavg = "dbregionmarketavg",
	dbglobalhistorical = "dbregionhistorical",
	dbglobalsaleavg = "dbregionsaleavg",
	dbglobalsalerate = "dbregionsalerate",
	dbglobalsoldperday = "dbregionsoldperday",
}
local NAN = math.huge * 0
local NAN_STR = tostring(NAN)
local function IsInvalid(num)
	-- We want to treat math.huge/-math.huge/NAN as invalid.
	return num == math.huge or num == -math.huge or tostring(num) == NAN_STR
end
-- Make sure our IsInvalid function continues to work as expected
assert(IsInvalid(NAN) and IsInvalid(math.huge) and IsInvalid(math.huge) and not IsInvalid(0) and not IsInvalid(1000))
local COMPARISONS = {
	["gt"] = 1,
	["gte"] = 2,
	["lt"] = 3,
	["lte"] = 4,
	["eq"] = 5,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

--- Register a built-in price source.
-- @tparam string moduleName The name of the module which provides this source
-- @tparam string key The key for this price source (i.e. DBMarket)
-- @tparam string label The label which describes this price source for display to the user
-- @tparam function callback The price source callback
-- @tparam[opt=false] boolean fullLink Whether or not the full itemLink is required instead of just the itemString
-- @param[opt] arg An additional argument which is passed to the callback
function TSM.CustomPrice.RegisterSource(moduleName, key, label, callback, fullLink, arg)
	tinsert(private.priceSourceKeys, strlower(key))
	private.priceSourceInfo[strlower(key)] = {
		moduleName = moduleName,
		key = key,
		label = label,
		callback = callback,
		takeItemString = not fullLink,
		arg = arg,
	}
end

--- Create a new custom price source.
-- @tparam string name The name of the custom price source
-- @tparam string value The value of the custom price source
function TSM.CustomPrice.CreateCustomPriceSource(name, value)
	assert(name ~= "")
	assert(gsub(name, "([a-z]+)", "") == "")
	assert(not TSM.db.global.userData.customPriceSources[name])
	TSM.db.global.userData.customPriceSources[name] = value
	wipe(private.customPriceCache)
end

--- Rename a custom price source.
-- @tparam string oldName The old name of the custom price source
-- @tparam string newName The new name of the custom price source
function TSM.CustomPrice.RenameCustomPriceSource(oldName, newName)
	if oldName == newName then return end
	assert(TSM.db.global.userData.customPriceSources[oldName])
	TSM.db.global.userData.customPriceSources[newName] = TSM.db.global.userData.customPriceSources[oldName]
	TSM.db.global.userData.customPriceSources[oldName] = nil
	wipe(private.customPriceCache)
end

--- Delete a custom price source.
-- @tparam string name The name of the custom price source
function TSM.CustomPrice.DeleteCustomPriceSource(name)
	assert(TSM.db.global.userData.customPriceSources[name])
	TSM.db.global.userData.customPriceSources[name] = nil
	wipe(private.customPriceCache)
end

--- Print built-in price sources to chat.
function TSM.CustomPrice.PrintSources()
	TSM:Printf(L["Below are your currently available price sources organized by module. The %skey|r is what you would type into a custom price box."], "|cff99ffff")
	local moduleList = TSMAPI_FOUR.Util.AcquireTempTable()

	for _, info in pairs(private.priceSourceInfo) do
		if not tContains(moduleList, info.moduleName) then
			tinsert(moduleList, info.moduleName)
		end
	end
	sort(moduleList, private.ModuleSortFunc)

	for _, module in ipairs(moduleList) do
		TSM:PrintRaw("|cffffff00"..module..":|r")
		local lines = TSMAPI_FOUR.Util.AcquireTempTable()
		for _, info in pairs(private.priceSourceInfo) do
			if info.moduleName == module then
				tinsert(lines, format("  %s%s|r (%s)", "|cff99ffff", info.key, info.label))
			end
		end
		sort(lines)
		for _, line in ipairs(lines) do
			TSM:PrintRaw(line)
		end
		TSMAPI_FOUR.Util.ReleaseTempTable(lines)
	end

	TSMAPI_FOUR.Util.ReleaseTempTable(moduleList)
end

function TSM.CustomPrice.GetDescription(key)
	local info = private.priceSourceInfo[key]
	return info and info.label or nil
end



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

--- Validate a custom price string.
-- @tparam string customPriceStr The custom price string
-- @tparam ?string badPriceSource A price source which isn't allowed to existing within the one being validated
-- @treturn boolean Whether or not the custom price string is valid
-- @treturn ?string The error message if the custom price string was invalid
function TSMAPI_FOUR.CustomPrice.Validate(customPriceStr, badPriceSource)
	local func, err = private.ParseCustomPrice(customPriceStr, badPriceSource)
	return func and true or false, err
end

--- Validate a custom price name.
-- @tparam string customPriceName The custom price name
-- @treturn boolean Whether or not the custom price name is valid
function TSMAPI_FOUR.CustomPrice.ValidateName(customPriceName)
	-- User defined price sources
	if TSM.db.global.userData.customPriceSources[customPriceName] then
		return false
	end
	-- TSM defined price sources
	for source in TSMAPI_FOUR.CustomPrice.Iterator() do
		if strlower(source) == strlower(customPriceName) then
			return false
		end
	end
	-- Math Functions
	for mathFunction in pairs(MATH_FUNCTIONS) do
		if strlower(mathFunction) == strlower(customPriceName) then
			return false
		end
	end
	-- Comparisons
	for comparison in pairs(COMPARISONS) do
		if strlower(comparison) == strlower(customPriceName) then
			return false
		end
	end
	return true
end

--- Evaulates a custom price source for an item.
-- @tparam string customPriceStr The custom price string
-- @tparam string itemString The item to evalulate the custom price string for
-- @tparam ?string badPriceSource A price source which isn't allowed to existing within the one being validated
-- @treturn ?number The resulting value or nil if the custom price string is invalid
-- @treturn ?string The error message if the custom price string was invalid
function TSMAPI_FOUR.CustomPrice.GetValue(customPriceStr, itemString, badPriceSource)
	local func, err = private.ParseCustomPrice(customPriceStr, badPriceSource)
	if not func then
		return nil, err
	end
	local value = nil
	if not private.priceCacheActive then
		assert(not next(private.priceCache))
		private.priceCacheActive = true
		value = func(itemString)
		wipe(private.priceCache)
		private.priceCacheActive = nil
	else
		value = func(itemString)
	end
	return value
end

--- Gets a built-in price source's value for an item.
-- @tparam string itemString The item to evalulate the price source for
-- @tparam string key The key of the price source
-- @treturn ?number The resulting value or nil if no price was found for the item
function TSMAPI_FOUR.CustomPrice.GetItemPrice(itemString, key)
	itemString = TSMAPI_FOUR.Item.ToItemString(itemString)
	if not itemString then return end

	local info = private.priceSourceInfo[strlower(key)]
	if not info then return end
	if not info.takeItemString then
		-- this price source does not take an itemString, so pass it an itemLink instead
		itemString = TSMAPI_FOUR.Item.GetLink(itemString)
		if not itemString then return end
	end
	local value = info.callback(itemString, info.arg)
	return type(value) == "number" and value or nil
end

local function CustomPriceIteratorHelper(_, key)
	local info = private.priceSourceInfo[key]
	return info.key, info.moduleName, info.label
end
--- Iterate over the price sources.
-- @return An iterator which provides the following fields: `key, moduleName, label`
function TSMAPI_FOUR.CustomPrice.Iterator()
	return TSMAPI_FOUR.Util.TableIterator(private.priceSourceKeys, CustomPriceIteratorHelper)
end

--- Iterate over the custom price sources needed to make this custom price string calculable.
-- @param string customPriceStr The custom price string
-- @return An iterator of custom price names
function TSMAPI_FOUR.CustomPrice.DependentCustomPriceSourceIterator(customPriceStr)
	local queue = TSMAPI_FOUR.Util.AcquireTempTable()
	local results = TSMAPI_FOUR.Util.AcquireTempTable()

	private.AddToCustomPriceDependencyQueue(queue, customPriceStr)
	local name, value = next(queue)
	while value do
		queue[name] = nil
		if TSM.db.global.userData.customPriceSources[name] and not results[name] then
			results[name] = true
			private.AddToCustomPriceDependencyQueue(queue, TSM.db.global.userData.customPriceSources[name])
			tinsert(results, name)
		end
		name, value = next(queue)
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(queue)
	return TSMAPI_FOUR.Util.TempTableIterator(results)
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

private.customPriceFunctions = {
	IsInvalid = IsInvalid,
	loopError = function(str)
		TSM:Printf("%s |cff99ffff%s|r", L["Loop detected in the following custom price:"], str)
	end,
	_avg = function(...)
		local total, count = 0, 0
		for i = 1, select('#', ...) do
			local num = select(i, ...)
			if type(num) == "number" and not IsInvalid(num) then
				total = total + num
				count = count + 1
			end
		end
		return count == 0 and NAN or (total / count)
	end,
	_min = function(...)
		local minVal
		for i = 1, select('#', ...) do
			local num = select(i, ...)
			if type(num) == "number" and not IsInvalid(num) and (not minVal or num < minVal) then
				minVal = num
			end
		end
		return minVal or NAN
	end,
	_max = function(...)
		local maxVal
		for i = 1, select('#', ...) do
			local num = select(i, ...)
			if type(num) == "number" and not IsInvalid(num) and (not maxVal or num > maxVal) then
				maxVal = num
			end
		end
		return maxVal or NAN
	end,
	_first = function(...)
		for i = 1, select('#', ...) do
			local num = select(i, ...)
			if type(num) == "number" and not IsInvalid(num) then
				return num
			end
		end
		return NAN
	end,
	_check = function(check, ...)
		return private.RunComparison(COMPARISONS.gt, check, 0, ...)
	end,
	_ifgt = function(...)
		return private.RunComparison(COMPARISONS.gt, ...)
	end,
	_ifgte = function(...)
		return private.RunComparison(COMPARISONS.gte, ...)
	end,
	_iflt = function(...)
		return private.RunComparison(COMPARISONS.lt, ...)
	end,
	_iflte = function(...)
		return private.RunComparison(COMPARISONS.lte, ...)
	end,
	_ifeq = function(...)
		return private.RunComparison(COMPARISONS.eq, ...)
	end,
	_round = function(...)
		if select('#', ...) < 1 or select('#', ...) > 2 then return NAN end
		return TSMAPI_FOUR.Util.Round(...)
	end,
	_roundup = function(...)
		if select('#', ...) < 1 or select('#', ...) > 2 then return NAN end
		return TSMAPI_FOUR.Util.Ceil(...)
	end,
	_rounddown = function(...)
		if select('#', ...) < 1 or select('#', ...) > 2 then return NAN end
		return TSMAPI_FOUR.Util.Floor(...)
	end,
	_priceHelper = function(itemString, key, extraParam)
		itemString = TSMAPI_FOUR.Item.ToItemString(itemString)
		if not itemString then
			return NAN
		end
		local cacheKey = itemString..key..tostring(extraParam)
		if not private.priceCache[cacheKey] then
			if key == "convert" then
				private.priceCache[cacheKey] = TSM.Conversions.GetConvertCost(itemString, extraParam) or NAN
			elseif extraParam == "custom" then
				private.priceCache[cacheKey] = TSMAPI_FOUR.CustomPrice.GetValue(TSM.db.global.userData.customPriceSources[key], itemString) or NAN
			elseif extraParam == "map" then
				local targetKey = MAPPED_PRICES[key]
				if MAPPED_PRICES[key] and not private.mappedWarning[key] then
					StaticPopupDialogs["TSM_PRICE_MAP_"..key] = {
						text = format("The |cff99ffff%s|r price source is currently implicitly mapped to |cff99ffff%s|r. Would you like TSM to make this permanent by creating a custom price source?", key, targetKey),
						button1 = YES,
						button2 = NO,
						timeout = 0,
						OnAccept = function()
							TSM.CustomPrice.CreateCustomPriceSource(key, targetKey)
							TSM:Printf(L["Created custom price source: |cff99ffff%s|r"], key)
						end,
					}
					TSMAPI_FOUR.Util.ShowStaticPopupDialog("TSM_PRICE_MAP_"..key)
					private.mappedWarning[key] = true
				end
				private.priceCache[cacheKey] = TSMAPI_FOUR.CustomPrice.GetValue(targetKey, itemString) or NAN
			else
				private.priceCache[cacheKey] = TSMAPI_FOUR.CustomPrice.GetItemPrice(itemString, key) or NAN
			end
		end
		return private.priceCache[cacheKey] or NAN
	end,
}
private.proxyMT = {
	__index = function(self, index)
		local data = private.proxyData[self]
		if private.customPriceFunctions[index] then
			return private.customPriceFunctions[index]
		elseif index == "globalContext" or index == "origStr" then
			-- these keys can always be accessed
			return data[index]
		end
		if not data.isUnlocked then error("Attempt to access a hidden table", 2) end
		return data[index]
	end,
	__newindex = function(self, index, value)
		local data = private.proxyData[self]
		if not data.isUnlocked then error("Attempt to modify a hidden table", 2) end
		data[index] = value
	end,
	__call = function(self, item)
		local data = private.proxyData[self]
		data.isUnlocked = true
		local result = self.func(self, item, TSMAPI_FOUR.Item.ToBaseItemString(item))
		data.isUnlocked = false
		return result
	end,
	__metatable = false,
}

function private.RunComparison(comparison, ...)
	if select('#', ...) > 4 then return NAN end

	local leftCheck, rightCheck, ifValue, elseValue = ...
	leftCheck = leftCheck or NAN
	rightCheck = rightCheck or NAN
	ifValue = ifValue or NAN
	elseValue = elseValue or NAN

	if IsInvalid(leftCheck) or IsInvalid(rightCheck) then
		return NAN
	elseif comparison == COMPARISONS.gt then
		return leftCheck > rightCheck and ifValue or elseValue
	elseif comparison == COMPARISONS.gte then
		return leftCheck >= rightCheck and ifValue or elseValue
	elseif comparison == COMPARISONS.lt then
		return leftCheck < rightCheck and ifValue or elseValue
	elseif comparison == COMPARISONS.lte then
		return leftCheck <= rightCheck and ifValue or elseValue
	elseif comparison == COMPARISONS.eq then
		return leftCheck == rightCheck and ifValue or elseValue
	else
		error("Error in custom price comparison")
	end
end

function private.CreateCustomPriceObj(func, origStr)
	local proxy = newproxy(true)
	private.proxyData[proxy] = {
		isUnlocked = false,
		globalContext = private.context,
		origStr = origStr,
		func = func,
	}
	local mt = getmetatable(proxy)
	for key, value in pairs(private.proxyMT) do
		mt[key] = value
	end
	return proxy
end

function private.ParsePriceString(str, badPriceSource)
	if tonumber(str) then
		return private.CreateCustomPriceObj(function() return tonumber(str) end, str)
	end

	local origStr = str
	-- put a space at the start and end
	str = " "..str.." "
	-- remove any colors around gold/silver/copper
	while true do
		local num1, num2, num3
		str, num1 = gsub(str, "\124cff[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]g\124r", "g")
		str, num2 = gsub(str, "\124cff[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]s\124r", "s")
		str, num3 = gsub(str, "\124cff[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]c\124r", "c")
		if num1 + num2 + num3 == 0 then break end
	end
	-- replace old itemStrings with the new format
	str = gsub(str, "([^h]i)tem:([0-9:%-]+)", "%1:%2")

	-- replace all formatted gold amount with their copper value
	local start = 1
	local goldAmountContinue = true
	while goldAmountContinue do
		goldAmountContinue = false
		local minFindStart, minFindEnd, minFindSub = nil, nil, nil
		for _, pattern in ipairs(MONEY_PATTERNS) do
			local s, e, sub = strfind(str, pattern, start)
			if s and (not minFindStart or minFindStart > s) then
				minFindStart = s
				minFindEnd = e
				minFindSub = sub
			end
		end
		if minFindStart then
			if strmatch(strsub(str, minFindStart-1, minFindStart-1), "[0-9a-zA-Z]") or strmatch(strsub(str, minFindEnd+1, minFindEnd+1), "[0-9a-zA-Z]") then
				return nil, L["Invalid gold value."]
			end
			local value = TSM.Money.FromString(minFindSub)
			if not value then
				-- sanity check
				return nil, L["Invalid function."]
			end
			local preStr = strsub(str, 1, minFindStart - 1)
			local postStr = strsub(str, minFindEnd + 1)
			str = preStr .. value .. postStr
			start = #str - #postStr + 1
			goldAmountContinue = true
		end
	end

	-- remove up to 1 occurance of convert(priceSource[, item])
	local convertPriceSource, convertItem
	local convertParams = strmatch(str, "[^a-z]convert%((.-)%)")
	if convertParams then
		local convertItemLink = strmatch(convertParams, "\124c.-\124r")
		local convertItemString = strmatch(convertParams, ITEM_STRING_PATTERN)
		if convertItemLink then -- check for itemLink in convert params
			convertItem = TSMAPI_FOUR.Item.ToItemString(convertItemLink)
			if not convertItem then
				return nil, L["Invalid item link."]  -- there's an invalid item link in the convertParams
			end
			convertPriceSource = strmatch(convertParams, "^ *(.-) *,")
		elseif convertItemString then -- check for itemString in convert params
			convertItem = convertItemString
			convertPriceSource = strmatch(convertParams, "^ *(.-) *,")
		else
			convertPriceSource = gsub(convertParams, ", *$", "")
			convertPriceSource = strtrim(convertPriceSource)
		end
		if convertPriceSource and convertPriceSource == badPriceSource or convertPriceSource == "matprice" then
			return nil, format(L["You cannot use %s within convert() as part of this custom price."], convertPriceSource)
		end

		-- can't allow custom price sources in convert, so just check regular ones
		if not private.priceSourceInfo[convertPriceSource] then
			return nil, L["Invalid price source in convert."]
		end
		local num = 0
		str, num = gsub(str, "([^a-z])convert%(.-%)", "%1~convert~")
		if num > 1 then
			return nil, L["A maximum of 1 convert() function is allowed."]
		end
	end

	while true do
		local itemLink = strmatch(str, "\124c.*\124r")
		if not itemLink then break end
		local _, endIndex = strfind(itemLink, "\124r")
		itemLink = strsub(itemLink, 1, endIndex)
		local itemString = TSMAPI_FOUR.Item.ToItemString(itemLink)
		if not itemString then
			-- there's an invalid item link in the str
			return nil, L["Invalid item link."]
		end
		str = gsub(str, TSMAPI_FOUR.Util.StrEscape(itemLink), itemString)
	end

	-- make sure there's spaces on either side of math operators
	str = gsub(str, "[%-%+%/%*%^]", " %1 ")
	-- make sure there's a space to the right of % signs
	str = gsub(str, "[%%]", "%1 ")
	-- convert percentages to decimal numbers
	str = gsub(str, "([0-9%.]+)%%", "( %1 / 100 ) *")
	-- ensure a space on either side of item strings and remove parentheses around them
	str = gsub(str, "%([ ]*("..ITEM_STRING_PATTERN..")[ ]*%)", " %1 ")
	-- ensure a space on either side of baseitem arguments and remove parentheses around them
	str = gsub(str, "%([ ]*(baseitem)[ ]*%)", " ~baseitem~ ")
	-- ensure a space on either side of parentheses and commas
	str = gsub(str, "[%(%),]", " %1 ")
	-- remove any occurances of more than one consecutive space
	str = gsub(str, " [ ]+", " ")

	-- ensure equal number of left/right parenthesis
	if select(2, gsub(str, "%(", "")) ~= select(2, gsub(str, "%)", "")) then
		return nil, L["Unbalanced parentheses."]
	end

	-- validate all words in the string
	local parts = TSMAPI_FOUR.Util.SafeStrSplit(strtrim(str), " ")
	local i = 1
	while i <= #parts do
		local word = parts[i]
		if strmatch(word, "^[%-%+%/%*%^]$") then
			if i == #parts then
				return nil, L["Invalid operator at end of custom price."]
			end
			-- valid math operator
		elseif badPriceSource == word then
			-- price source that's explicitly invalid
			return nil, format(L["You cannot use %s as part of this custom price."], word)
		elseif private.priceSourceInfo[word] or TSM.db.global.userData.customPriceSources[word] then
			-- make sure we're not trying to take the price source of a number
			if parts[i+1] == "(" and type(parts[i+2]) == "string" and not strfind(parts[i+2], "^[ip].*:") then
				return nil, L["Invalid parameter to price source."]
			end
			-- valid price source
		elseif tonumber(word) then
			-- make sure it's not an itemID (incorrect)
			if i > 2 and parts[i-1] == "(" and (private.priceSourceInfo[parts[i-2]] or TSM.db.global.userData.customPriceSources[parts[i-2]]) then
				return nil, L["Invalid parameter to price source."]
			end
			-- valid number
		elseif strmatch(word, "^"..ITEM_STRING_PATTERN.."$") or word == "~baseitem~" then
			-- make sure previous word was a price source
			if i > 1 and (private.priceSourceInfo[parts[i-1]] or TSM.db.global.userData.customPriceSources[parts[i-1]]) then
				-- valid item parameter
			else
				return nil, L["Item links may only be used as parameters to price sources."]
			end
		elseif word == "(" then
			-- empty parenthesis are not allowed
			if not parts[i+1] or parts[i+1] == ")" then
				return nil, L["Empty parentheses are not allowed"]
			end
			-- should never have ") ("
			if i > 1 and parts[i-1] == ")" then
				return nil, L["Missing operator between sets of parenthesis"]
			end
		elseif word == ")" then
			-- valid parenthesis
		elseif word == "," then
			if not parts[i+1] or parts[i+1] == ")" then
				return nil, L["Misplaced comma"]
			else
				-- we're hoping this is a valid comma within a function, will be caught by loadstring otherwise
			end
		elseif MATH_FUNCTIONS[word] then
			if not parts[i+1] or parts[i+1] ~= "(" then
				return nil, format(L["Invalid word: '%s'"], word)
			end
			-- valid math function
		elseif word == "~convert~" then
			-- valid convert statement
		elseif strtrim(word) == "" then
			-- harmless extra spaces
		elseif word == "disenchant" then
			return nil, format(L["The 'disenchant' price source has been replaced by the more general 'destroy' price source. Please update your custom prices."])
		elseif not MAPPED_PRICES[word] then
			-- check if this is an operation export that they tried to use as a custom price
			if strfind(word, "^%^1%^t%^") then
				return nil, L["This looks like an exported operation and not a custom price."]
			end
			return nil, format(L["Invalid word: '%s'"], word)
		end
		i = i + 1
	end

	for key in pairs(TSM.db.global.userData.customPriceSources) do
		str = private.PriceSourceParsingHelper(str, strlower(key), "custom")
	end

	for key in pairs(MAPPED_PRICES) do
		str = private.PriceSourceParsingHelper(str, key, "map")
	end

	for key in pairs(private.priceSourceInfo) do
		str = private.PriceSourceParsingHelper(str, key)
	end

	-- replace "~convert~" appropriately
	if convertPriceSource then
		convertItem = convertItem and ('"'..convertItem..'"') or "_item"
		str = gsub(str, "~convert~", format("self._priceHelper(%s, \"convert\", \"%s\")", convertItem, convertPriceSource))
	end

	-- replace math functions with special custom function names
	for word, funcName in pairs(MATH_FUNCTIONS) do
		str = gsub(str, " "..word.." ", " "..funcName.." ")
	end

	-- finally, create and return the function
	local func, loadErr = loadstring(format(CUSTOM_PRICE_FUNC_TEMPLATE, str), "TSMCustomPrice: "..origStr)
	if loadErr then
		loadErr = gsub(strtrim(loadErr), "([^:]+):.", "")
		return nil, L["Invalid function."].." "..L["Details"]..": "..loadErr
	end
	local success = nil
	success, func = pcall(func)
	if not success then
		return nil, L["Invalid function."]
	end
	return private.CreateCustomPriceObj(func, origStr)
end

function private.PriceSourceParsingHelper(str, key, extraArg)
	extraArg = extraArg and (",\""..extraArg.."\"") or ""
	-- replace all "<priceSource> <itemString>" occurances with the proper parameters (with the itemString)
	str = gsub(str, format(" %s (%s) ", key, ITEM_STRING_PATTERN), format(" self._priceHelper(\"%%1\",\"%s\"%s) ", key, extraArg))
	-- replace all "<priceSource> baseitem" occurances with the proper parameters (with _baseitem for the item)
	str = gsub(str, format(" %s ~baseitem~ ", key), format(" self._priceHelper(_baseitem,\"%s\"%s) ", key, extraArg))
	-- replace all "<priceSource>" occurances with the proper parameters (with _item for the item)
	str = gsub(str, format(" %s ", key), format(" self._priceHelper(_item,\"%s\"%s) ", key, extraArg))
	return str
end

function private.ParseCustomPrice(customPriceStr, badPriceSource)
	customPriceStr = customPriceStr and strlower(strtrim(tostring(customPriceStr)))
	customPriceStr = TSM.Money.FromString(customPriceStr) and gsub(customPriceStr, TSMAPI_FOUR.Util.StrEscape(LARGE_NUMBER_SEPERATOR), "") or customPriceStr
	if not customPriceStr or customPriceStr == "" then
		return nil, L["Empty price string."]
	end

	if not private.customPriceCache[customPriceStr] then
		private.customPriceCache[customPriceStr] = {private.ParsePriceString(customPriceStr, badPriceSource)}
	end
	return unpack(private.customPriceCache[customPriceStr])
end

function private.ModuleSortFunc(a, b)
	if a == "TradeSkillMaster" then
		return true
	elseif b == "TradeSkillMaster" then
		return false
	else
		return a < b
	end
end

function private.AddToCustomPriceDependencyQueue(queue, value)
	value = strlower(value)
	for piece in gmatch(value, "[a-z]+") do
		queue[piece] = true
	end
end
