-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Class TSMAPI_FOUR Functions
-- @module Class

TSMAPI_FOUR.Class = {}
local private = { classInfo = {}, instInfo = {}, constructTbl = nil }
-- Set the keys as weak so that instances of classes can be GC'd (classes are never GC'd)
setmetatable(private.instInfo, { __mode = "k" })
local SPECIAL_PROPERTIES = {
	__init = true,
	__tostring = true,
	__class = true,
	__isa = true,
	__super = true,
	__name = true,
}
local DEFAULT_INST_FIELDS = {
	__init = function(self)
		-- do nothing
	end,
	__tostring = function(self)
		return private.instInfo[self].str
	end,
	__dump = function(self)
		return private.InstDump(self)
	end,
}



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

--- Defines a new class.
-- @tparam string name The name of the class
-- @tparam[opt] class superclass The class to make this class a subclass of
-- @param[opt] ... Modifiers for the class (currently supports: `ABSTRACT`)
-- @treturn class The new class
function TSMAPI_FOUR.Class.DefineClass(name, superclass, ...)
	assert(type(name) == "string", "Invalid class name: "..tostring(name), 1)
	local abstract = false
	for i = 1, select('#', ...) do
		local modifier = select(i, ...)
		if modifier == "ABSTRACT" then
			abstract = true
		else
			error("Invalid modifier: "..tostring(modifier))
		end
	end

	local class = setmetatable({}, private.CLASS_MT)
	private.classInfo[class] = {
		name = name,
		static = {},
		superStatic = {},
		superclass = superclass,
		abstract = abstract,
	}
	while superclass do
		for key, value in pairs(private.classInfo[superclass].static) do
			if not private.classInfo[class].superStatic[key] then
				private.classInfo[class].superStatic[key] = { class = superclass, value = value }
			end
		end
		superclass = superclass.__super
	end
	return class
end


--- Instantiates a class using an existing table.
-- This can be used to preserve existing fields in the table while upgrading it to an instance of a class.
-- @tparam table tbl The table to use for the instantiated object
-- @tparam class class The class to instantiate
-- @param[opt] ... Parameters to pass to the class construtor
-- @treturn object The new class instance
function TSMAPI_FOUR.Class.ConstructWithTable(tbl, class, ...)
	private.constructTbl = tbl
	local inst = class(...)
	assert(not private.constructTbl and inst == tbl)
	return inst
end



-- ============================================================================
-- Instance Metatable
-- ============================================================================

private.INST_MT = {
	__newindex = function(self, key, value)
		assert(key ~= "__super" and key ~= "__isa" and key ~= "__class", "Can't set reserved key: "..tostring(key))
		if private.classInfo[self.__class].static[key] ~= nil then
			private.classInfo[self.__class].static[key] = value
		elseif not private.instInfo[self].hasSuperclass then
			-- we just set this directly on the instance table for better performance
			rawset(self, key, value)
		else
			private.instInfo[self].fields[key] = value
		end
	end,
	__index = function(self, key)
		-- This method is super optimized since it's used for every class instance access, meaning function calls and
		-- table lookup is kept to an absolute minimum, at the expense of readability and code reuse.
		local instInfo = private.instInfo[self]

		-- check if this key is an instance field first, since this is the most common case
		local res = instInfo.fields[key]
		if res ~= nil then
			instInfo.currentClass = nil
			return res
		end

		-- check if it's the special __super field
		if key == "__super" then
			-- The class of the current class method we are in, or nil if we're not in a class method.
			local methodClass = instInfo.methodClass
			-- We can only access the superclass within a class method and will use the class which defined that method
			-- as the base class to jump to the superclass of, regardless of what class the instance actually is.
			if not methodClass then
				error("The superclass can only be referenced within a class method.")
			end
			instInfo.currentClass = private.classInfo[instInfo.currentClass or methodClass].superclass
			if not instInfo.currentClass then
				error("No super class found.")
			end
			return self
		end

		-- reset the current class since we're not continuing the __super chain
		local class = instInfo.currentClass or instInfo.class
		instInfo.currentClass = nil

		-- check if this is a static key
		local classInfo = private.classInfo[class]
		res = classInfo.static[key]
		if res ~= nil then
			return res
		end

		-- check if it's a static field in the superclass
		local superStaticRes = classInfo.superStatic[key]
		if superStaticRes then
			res = superStaticRes.value
			return res
		end

		-- check if this field has a default value
		res = DEFAULT_INST_FIELDS[key]
		if res ~= nil then
			return res
		end

		return nil
	end,
	__tostring = function(self)
		return self:__tostring()
	end,
	__metatable = false,
}



-- ============================================================================
-- Class Metatable
-- ============================================================================

private.CLASS_MT = {
	__newindex = function(self, key, value)
		assert(not private.classInfo[self].static[key], "Can't modify or override static members")
		assert(key ~= "__super" and key ~= "__isa" and key ~= "__class", "Reserved word: "..key)
		if type(value) == "function" then
			-- We wrap class methods so that within them, the instance appears to be of the defining class
			private.classInfo[self].static[key] = function(inst, ...)
				local instInfo = private.instInfo[inst]
				if not instInfo.isClassLookup[self] then
					error(format("Attempt to call class method on non-object (%s)!", tostring(inst)))
				end
				if not instInfo.hasSuperclass then
					-- don't need to worry about methodClass so just call the function directly
					return value(inst, ...)
				else
					local prevMethodClass = instInfo.methodClass
					instInfo.methodClass = self
					return private.InstMethodReturnHelper(prevMethodClass, instInfo, value(inst, ...))
				end
			end
		else
			private.classInfo[self].static[key] = value
		end
	end,
	__index = function(self, key)
		-- check if it's the special __isa method which all classes implicitly have
		if key == "__isa" then
			return private.ClassIsA
		elseif key == "__name" then
			return private.classInfo[self].name
		elseif key == "__super" then
			return private.classInfo[self].superclass
		end
		error("Class type is write-only")
	end,
	__tostring = function(self)
		return "class:"..private.classInfo[self].name
	end,
	__call = function(self, ...)
		assert(not private.classInfo[self].abstract, "Attempting to instantiate an abstract class!")
		-- Create a new instance of this class
		local inst = private.constructTbl or {}
		local instStr = strmatch(tostring(inst), "table:[^0-9a-fA-F]*([0-9a-fA-F]+)")
		setmetatable(inst, private.INST_MT)
		local hasSuperclass = private.classInfo[self].superclass and true or false
		private.instInfo[inst] = {
			class = self,
			fields = {
				__class = self,
				__isa = private.InstIsA,
			},
			str = private.classInfo[self].name..":"..instStr,
			isClassLookup = {},
			hasSuperclass = hasSuperclass,
		}
		if not hasSuperclass then
			-- set the static members directly on this object for better performance
			for key, value in pairs(private.classInfo[self].static) do
				if not SPECIAL_PROPERTIES[key] then
					rawset(inst, key, value)
				end
			end
		end
		local c = self
		while c do
			private.instInfo[inst].isClassLookup[c] = true
			c = private.classInfo[c].superclass
		end
		if private.constructTbl then
			-- re-set all the object attributes through the proper metamethod
			for k, v in pairs(inst) do
				rawset(inst, k, nil)
				inst[k] = v
			end
			private.constructTbl = nil
		end
		assert(select("#", inst:__init(...)) == 0, "__init must not return any values")
		return inst
	end,
	__metatable = false,
}



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.InstMethodReturnHelper(class, instInfo, ...)
	-- reset methodClass now that the function returned
	instInfo.methodClass = class
	return ...
end

function private.InstIsA(inst, targetClass)
	return private.instInfo[inst].isClassLookup[targetClass]
end

function private.ClassIsA(class, targetClass)
	while class do
		if class == targetClass then return true end
		class = class.__super
	end
end

function private.InstDump(inst)
	local instInfo = private.instInfo[inst]
	local tbl = instInfo.hasSuperclass and instInfo.fields or inst
	print(instInfo.str.." {")
	for key, value in pairs(tbl) do
		local valueStr = nil
		if type(value) == "table" then
			if private.classInfo[value] or private.instInfo[value] then
				-- this is a class or instance of a class
				valueStr = tostring(value)
			elseif next(value) then
				valueStr = "{ ... }"
			else
				valueStr = "{}"
			end
		elseif type(value) == "string" or type(value) == "number" or type(value) == "boolean" then
			valueStr = tostring(value)
		end
		if valueStr then
			print(format("  |cff88ccff%s|r=%s", tostring(key), valueStr))
		end
	end
	print("}")
end
