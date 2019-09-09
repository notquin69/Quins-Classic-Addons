-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- CSV TSMAPI_FOUR Functions
-- @module CSV

TSMAPI_FOUR.CSV = {}
local private = {}



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

function TSMAPI_FOUR.CSV.EncodeStart(keys)
	return { keys = keys, lines = {}, lineParts = {} }
end

function TSMAPI_FOUR.CSV.EncodeAddRowData(context, data)
	wipe(context.lineParts)
	for _, key in ipairs(context.keys) do
		tinsert(context.lineParts, data[key] or "")
	end
	tinsert(context.lines, table.concat(context.lineParts, ","))
end

function TSMAPI_FOUR.CSV.EncodeAddRowDataRaw(context, ...)
	tinsert(context.lines, strjoin(",", ...))
end

function TSMAPI_FOUR.CSV.EncodeSortLines(context)
	return sort(context.lines)
end

function TSMAPI_FOUR.CSV.EncodeEnd(context)
	local result = table.concat(context.keys, ",")
	if #context.lines > 0 then
		result = result.."\n"..table.concat(context.lines, "\n")
	end
	return result
end

function TSMAPI_FOUR.CSV.Encode(keys, data)
	local context = TSMAPI_FOUR.CSV.EncodeStart(keys)
	for _, row in ipairs(data) do
		TSMAPI_FOUR.CSV.EncodeAddRowData(context, row)
	end
	return TSMAPI_FOUR.CSV.EncodeEnd(context)
end

function TSMAPI_FOUR.CSV.Decode(str)
	local keys = nil
	local result = {}
	local numResult = 0
	for line in gmatch(str, "[^\n]+") do
		if not keys then
			keys = { strsplit(",", line) }
		else
			local entry = {}
			local lineParts = { strsplit(",", line) }
			for i, key in ipairs(keys) do
				local linePart = lineParts[i]
				if linePart ~= "" then
					entry[key] = tonumber(linePart) or linePart
				end
			end
			numResult = numResult + 1
			result[numResult] = entry
		end
	end
	return keys, result
end

function TSMAPI_FOUR.CSV.DecodeStart(str, fields)
	local func = gmatch(str, strrep("([^\n,]+),", #fields - 1).."([^\n,]+)(,?[^\n,]*)")
	if strjoin(",", func()) ~= table.concat(fields, ",").."," then
		return
	end
	local context = TSMAPI_FOUR.Util.AcquireTempTable()
	context.func = func
	context.extraArgPos = #fields + 1
	context.result = true
	return context
end

function TSMAPI_FOUR.CSV.DecodeIterator(context)
	return private.DecodeIteratorHelper, context
end

function TSMAPI_FOUR.CSV.DecodeEnd(context)
	local result = context.result
	TSMAPI_FOUR.Util.ReleaseTempTable(context)
	return result
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.DecodeIteratorHelper(context)
	return private.DecodeIteratorHelper2(context, context.func())
end

function private.DecodeIteratorHelper2(context, v1, ...)
	if not v1 then
		return
	end
	if select(context.extraArgPos, v1, ...) ~= "" then
		context.result = false
		return
	end
	return v1, ...
end
