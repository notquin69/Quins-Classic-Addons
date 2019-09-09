-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- Stylesheet Class.
-- A stylesheet allows for setting style attributes which all children of a @{Container} should inherit.
-- @classmod Stylesheet

local _, TSM = ...
local Stylesheet = TSMAPI_FOUR.Class.DefineClass("Stylesheet")
TSM.UI.Util.Stylesheet = Stylesheet
local TYPE_TAG_SEP = "."



-- ============================================================================
-- Meta Class Methods
-- ============================================================================

function Stylesheet.__init(self)
	self._tables = {}
end



-- ============================================================================
-- Public Class Methods
-- ============================================================================

--- Set the style table for a specific elementType and tag (optionally).
-- @tparam Stylesheet self The stylesheet object
-- @tparam string elementType The name of the element type to apply these style attributes to
-- @tparam[opt] string tag The tag to apply these style attributes to or nil to apply to elements of the given type
-- which don't otherwise have a matching stylesheet table
-- @tparam table tbl A table containing style attributes
-- @treturn Stylesheet The stylesheet object
function Stylesheet.SetStyleTable(self, elementType, tag, tbl)
	assert(elementType and TSM.UI[elementType])
	assert(tbl)
	local tablesKey = tag and (elementType..TYPE_TAG_SEP..tag) or elementType
	assert(not self._tables[tablesKey])
	self._tables[tablesKey] = tbl
	return self
end



-- ============================================================================
-- Private Class Methods
-- ============================================================================

function Stylesheet._GetStyle(self, elementType, tags, key)
	-- check if we can look up by type + tag
	local result = nil
	for _, tag in ipairs(tags) do
		local tbl = self._tables[elementType..TYPE_TAG_SEP..tag]
		if tbl and tbl[key] ~= nil then
			if result ~= nil then
				error(format("Overlapping styles set: (%s,%s,%s)", tostring(elementType), tostring(tag), tostring(key)))
			end
			result = tbl[key]
		end
	end
	if result ~= nil then
		return result
	end

	-- try looking up by type
	return self._tables[elementType] and self._tables[elementType][key]
end
