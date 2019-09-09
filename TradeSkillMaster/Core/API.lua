-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Public TSM API functions
-- @module TSM_API

local _, TSM = ...
TSM_API = {}



-- ============================================================================
-- UI
-- ============================================================================

--- Checks if a TSM UI is currently visible.
-- @within UI
-- @tparam string uiName A string which represents the UI ("AUCTION", "CRAFTING", "MAILING", or "VENDORING")
-- @treturn boolean Whether or not the TSM UI is visible
function TSM_API.IsUIVisible(uiName)
	if uiName == "AUCTION" then
		return TSM.UI.AuctionUI.IsVisible()
	elseif uiName == "CRAFTING" then
		return TSM.UI.CraftingUI.IsVisible()
	elseif uiName == "MAILING" then
		return TSM.UI.MailingUI.IsVisible()
	elseif uiName == "VENDORING" then
		return TSM.UI.VendoringUI.IsVisible()
	else
		error("Invalid uiName: "..tostring(uiName), 2)
	end
end



-- ============================================================================
-- Groups
-- ============================================================================

--- Gets a current list of TSM group paths.
-- @within Group
-- @tparam table result A table to store the result in
-- @treturn table The passed table, populated with group paths
function TSM_API.GetGroupPaths(result)
	if type(result) ~= "table" then
		error("Invalid 'result' argument type (must be a table): "..tostring(result), 2)
	end
	for _, groupPath in TSM.Groups.GroupIterator() do
		tinsert(result, groupPath)
	end
	return result
end

--- Formats a TSM group path into a human-readable form
-- @within Group
-- @tparam string path The group path to be formatted
-- @treturn string The formatted group path
function TSM_API.FormatGroupPath(path)
	if type(path) ~= "string" then
		error("Invalid 'path' argument type (must be a string): "..tostring(path), 2)
	elseif path == "" then
		error("Invalid 'path' argument (empty string)", 2)
	end
	return TSM.Groups.Path.Format(path)
end

--- Splits a TSM group path into its parent path and group name components.
-- @within Group
-- @tparam string path The group path to be split
-- @?treturn string The path of the parent group or nil if the specified path has no parent
-- @treturn string The name of the group
function TSM_API.SplitGroupPath(path)
	if type(path) ~= "string" then
		error("Invalid 'path' argument type (must be a string): "..tostring(path), 2)
	elseif path == "" then
		error("Invalid 'path' argument (empty string)", 2)
	end
	local parentPath, groupName = TSM.Groups.Path.Split(path)
	if parentPath == TSM.CONST.ROOT_GROUP_PATH then
		parentPath = nil
	end
	return parentPath, groupName
end

--- Gets the path to the group which a specific item is in.
-- @within Group
-- @tparam string|number item The item in either itemLink, itemString, or itemId representation
-- @?treturn string The path to the group which the item is in, or nil if it's not in a group
function TSM_API.GetGroupPathByItem(item)
	if type(item) ~= "string" and type(item) ~= "number" then
		error("Invalid 'item' argument type (must be a string or number): "..tostring(item), 2)
	end
	local path = TSM.Groups.GetPathByItem(item)
	return path ~= TSM.CONST.ROOT_GROUP_PATH and path or nil
end



-- ============================================================================
-- Profiles
-- ============================================================================

--- Gets a current list of TSM profiles.
-- @within Profile
-- @tparam table result A table to store the result in
-- @treturn table The passed table, populated with group paths
function TSM_API.GetProfiles(result)
	for _, profileName in TSM.db:ProfileIterator() do
		tinsert(result, profileName)
	end
	return result
end

--- Gets the active TSM profile.
-- @within Profile
-- @treturn string The name of the currently active profile
function TSM_API.GetActiveProfile()
	return TSM.db:GetCurrentProfile()
end

--- Sets the active TSM profile.
-- @within Profile
-- @tparam string profile The name of the profile to make active
function TSM_API.SetActiveProfile(profile)
	if type(profile) ~= "string" then
		error("Invalid 'profile' argument type (must be a string): "..tostring(profile), 2)
	elseif not TSM.db:ProfileExists(profile) then
		error("Profile does not exist: "..profile, 2)
	elseif profile == TSM.db:GetCurrentProfile() then
		error("Profile is already active: "..profile, 2)
	end
	return TSM.db:SetProfile(profile)
end



-- ============================================================================
-- Prices
-- ============================================================================

--- Gets a list of price source keys which can be used in TSM custom prices.
-- @within Price
-- @tparam table result A table to store the result in
-- @treturn table The passed table, populated with price source keys
function TSM_API.GetPriceSourceKeys(result)
	if type(result) ~= "table" then
		error("Invalid 'result' argument type (must be a table): "..tostring(result), 2)
	end
	for key in TSMAPI_FOUR.CustomPrice.Iterator() do
		tinsert(result, key)
	end
	return result
end

--- Gets the localized description of a given price source key.
-- @within Price
-- @tparam string key The price source key
-- @treturn string The localized description
function TSM_API.GetPriceSourceDescription(key)
	if type(key) ~= "string" then
		error("Invalid 'key' argument type (must be a string): "..tostring(key), 2)
	end
	local result = TSM.CustomPrice.GetDescription(key)
	if not result then
		error("Unknown price source key: "..tostring(key), 2)
	end
	return result
end

--- Gets whether or not a custom price string is valid.
-- @within Price
-- @tparam string customPriceStr The custom price string
-- @treturn boolean Whether or not the custom price is valid
-- @?treturn string The (localized) error message or nil if the custom price was valid
function TSM_API.IsCustomPriceValid(customPriceStr)
	if type(customPriceStr) ~= "string" then
		error("Invalid 'customPriceStr' argument type (must be a string): "..tostring(customPriceStr), 2)
	end
	return TSMAPI_FOUR.CustomPrice.Validate(customPriceStr)
end

--- Evalulates a custom price string or price source key for a given item
-- @within Price
-- @tparam string customPriceStr The custom price string or price source key to get the value of
-- @tparam string itemString The TSM itemstring to get the value for
-- @?treturn number The value in copper or nil if the custom price string is not valid
-- @?treturn string The (localized) error message if the custom price string is not valid or nil if it is valid
function TSM_API.GetCustomPriceValue(customPriceStr, itemString)
	if type(customPriceStr) ~= "string" then
		error("Invalid 'customPriceStr' argument type (must be a string): "..tostring(customPriceStr), 2)
	end
	if type(itemString) ~= "string" then
		error("Invalid 'itemString' argument type (must be a string): "..tostring(itemString), 2)
	end
	return TSMAPI_FOUR.CustomPrice.GetValue(customPriceStr, itemString)
end



-- ============================================================================
-- Money
-- ============================================================================

--- Converts a money value to a formatted, human-readable string.
-- @within Money
-- @tparam number value The money value in copper to be converted
-- @treturn string The formatted money string
function TSM_API.FormatMoneyString(value)
	if type(value) ~= "number" then
		error("Invalid 'value' argument type (must be a number): "..tostring(value), 2)
	end
	local result = TSM.Money.ToString(value)
	assert(result)
	return result
end

--- Converts a formatted, human-readable money string to a value.
-- @within Money
-- @tparam string str The formatted money string
-- @treturn number The money value in copper
function TSM_API.ParseMoneyString(str)
	if type(str) ~= "string" then
		error("Invalid 'str' argument type (must be a string): "..tostring(str), 2)
	end
	local result = TSM.Money.FromString(str)
	assert(result)
	return result
end



-- ============================================================================
-- Item
-- ============================================================================

--- Converts an item to a TSM item string.
-- @within Item
-- @tparam string item Either an item link, TSM item string, or WoW item string
-- @?treturn string The TSM item string or nil if the specified item could not be converted
function TSM_API.ToItemString(item)
	if type(item) ~= "string" then
		error("Invalid 'item' argument type (must be a string): "..tostring(item), 2)
	end
	return TSMAPI_FOUR.Item.ToItemString(item)
end

--- Gets an item's name from a given TSM item string
-- @within Item
-- @tparam string itemString The TSM item string
-- @?treturn string The name of the item or nil if it couldn't be determined
function TSM_API.GetItemName(itemString)
	if type(itemString) ~= "string" then
		error("Invalid 'itemString' argument type (must be a string): "..tostring(itemString), 2)
	end
	return TSMAPI_FOUR.Item.GetName(itemString)
end

--- Gets an item link from a given TSM item string
-- @within Item
-- @tparam string itemString The TSM item string
-- @treturn string The item link or an "[Unknown Item]" link
function TSM_API.GetItemLink(itemString)
	if type(itemString) ~= "string" then
		error("Invalid 'itemString' argument type (must be a string): "..tostring(itemString), 2)
	end
	local result = TSMAPI_FOUR.Item.GetLink(itemString)
	assert(result)
	return result
end
