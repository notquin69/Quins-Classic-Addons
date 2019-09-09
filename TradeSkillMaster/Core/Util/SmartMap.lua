-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Smart Map.
-- @module SmartMap

local _, TSM = ...
TSM.SmartMap = {}
local SmartMap = TSM.SmartMap
local private = {
	mapContext = {},
	readerContext = {},
}
local VALID_FIELD_TYPES = {
	string = true,
	number = true,
	boolean = true,
}



-- ============================================================================
-- Metatable Methods
-- ============================================================================

local SMART_MAP_MT = {
	-- getter
	__index = function(self, key)
		if key == nil then
			error("Attempt to get nil key")
		end
		if key == "ValueChanged" then
			return private.MapValueChanged
		elseif key == "SetCallbacksPaused" then
			return private.MapSetCallbacksPaused
		elseif key == "CreateReader" then
			return private.MapCreateReader
		elseif key == "GetKeyType" then
			return private.MapGetKeyType
		elseif key == "GetValueType" then
			return private.MapGetValueType
		elseif key == "KeyIterator" then
			return private.MapKeyIterator
		else
			error("Invalid map method: "..tostring(key), 2)
		end
	end,

	-- setter
	__newindex = function(self, key, value)
		error("Map cannot be written to directly", 2)
	end,

	__tostring = function(self)
		return "SmartMap:"..strmatch(tostring(private.mapContext[self]), "table:[^0-9a-fA-F]*([0-9a-fA-F]+)")
	end,

	__metatable = false,
}

local READER_MT = {
	-- getter
	__index = function(self, key)
		-- check if the map already has the value for this key cached
		local readerContext = private.readerContext[self]
		local map = readerContext.map
		local mapContext = private.mapContext[map]
		if mapContext.data[key] ~= nil then
			return mapContext.data[key]
		end

		-- get the value for this key
		local value = mapContext.func(key)
		if value == nil then
			error(format("No value for key (%s)", tostring(key)))
		elseif type(value) ~= mapContext.valueType then
			error(format("Invalid type of value (got %s, expected %s): %s", type(value), mapContext.valueType, tostring(value)))
		end

		-- cache the value both on the map and on this reader
		mapContext.data[key] = value
		rawset(self, key, value)

		return value
	end,

	-- setter
	__newindex = function(self, key, value)
		error("Reader is read-only", 2)
	end,

	__tostring = function(self)
		return "SmartMapReader:"..strmatch(tostring(private.readerContext[self]), "table:[^0-9a-fA-F]*([0-9a-fA-F]+)")
	end,

	__metatable = false,
}



-- ============================================================================
-- Module Methods
-- ============================================================================

function SmartMap.New(keyType, valueType, func)
	assert(VALID_FIELD_TYPES[keyType] and VALID_FIELD_TYPES[valueType] and type(func) == "function")
	local map = setmetatable({}, SMART_MAP_MT)
	private.mapContext[map] = {
		keyType = keyType,
		valueType = valueType,
		func = func,
		data = {},
		readers = {},
		callbacksPaused = 0,
	}
	return map
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.MapValueChanged(self, key)
	local mapContext = private.mapContext[self]
	local oldValue = mapContext.data[key]
	if oldValue == nil then
		-- nobody cares about this value
		return
	end

	-- get the new value
	local newValue = mapContext.func(key)
	if type(newValue) ~= mapContext.valueType then
		error(format("Invalid type (got %s, expected %s)", type(newValue), mapContext.valueType))
	end
	if oldValue == newValue then
		-- the value didn't change
		return
	end

	-- update the data
	mapContext.data[key] = newValue

	for _, reader in ipairs(mapContext.readers) do
		local readerContext = private.readerContext[reader]
		local prevValue = rawget(reader, key)
		if prevValue ~= nil then
			rawset(reader, key, newValue)
			if readerContext.callback then
				readerContext.pendingChanges[key] = prevValue
				if mapContext.callbacksPaused == 0 then
					readerContext.callback(reader, readerContext.pendingChanges)
					wipe(readerContext.pendingChanges)
				end
			end
		end
	end
end

function private.MapSetCallbacksPaused(self, paused)
	local mapContext = private.mapContext[self]
	if paused then
		mapContext.callbacksPaused = mapContext.callbacksPaused + 1
	else
		mapContext.callbacksPaused = mapContext.callbacksPaused - 1
		assert(mapContext.callbacksPaused >= 0)
		if mapContext.callbacksPaused == 0 then
			for _, reader in ipairs(mapContext.readers) do
				local readerContext = private.readerContext[reader]
				if readerContext.callback and next(readerContext.pendingChanges) then
					readerContext.callback(reader, readerContext.pendingChanges)
					wipe(readerContext.pendingChanges)
				end
			end
		end
	end
end

function private.MapCreateReader(self, callback)
	assert(callback == nil or type(callback) == "function")
	local reader = setmetatable({}, READER_MT)
	tinsert(private.mapContext[self].readers, reader)
	private.readerContext[reader] = {
		map = self,
		callback = callback,
		pendingChanges = {},
	}
	return reader
end

function private.MapGetKeyType(self)
	return private.mapContext[self].keyType
end

function private.MapGetValueType(self)
	return private.mapContext[self].valueType
end

function private.MapKeyIterator(self)
	return TSMAPI_FOUR.Util.TableKeyIterator(private.mapContext[self].data)
end
