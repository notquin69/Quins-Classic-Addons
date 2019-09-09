-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

--- ObjectPool TSMAPI_FOUR Functions.
-- @module ObjectPool

TSMAPI_FOUR.ObjectPool = {}
local ObjectPool = TSMAPI_FOUR.Class.DefineClass("ObjectPool")
local private = { instances = {} }
local DEBUG_STATS_MIN_COUNT = 1



-- ============================================================================
-- TSMAPI_FOUR Functions
-- ============================================================================

--- Create a new object pool.
-- @tparam string name The name of the object pool for debug purposes
-- @tparam function createFunc The function which is called to create a new object
-- @?tparam number extraStackOffset The extra stack offset for tracking where objects are being used from or nil to disable stack info
-- @treturn ObjectPool The object pool object
function TSMAPI_FOUR.ObjectPool.New(name, createFunc, extraStackOffset)
	assert(not private.instances[name])
	private.instances[name] = ObjectPool(createFunc, extraStackOffset)
	return private.instances[name]
end

function TSMAPI_FOUR.ObjectPool.GetDebugInfo()
	local debugInfo = {}
	for name, pool in pairs(private.instances) do
		local numCreated, numInUse, info = pool:_GetDebugStats()
		debugInfo[name] = {
			numCreated = numCreated,
			numInUse = numInUse,
			info = info,
		}
	end
	return debugInfo
end



-- ============================================================================
-- ObjectPool Class
-- ============================================================================

function ObjectPool.__init(self, createFunc, extraStackOffset)
	assert(createFunc)
	self._createFunc = createFunc
	self._extraStackOffset = extraStackOffset
	self._freeList = {}
	self._state = {}
	self._numCreated = 0
end

function ObjectPool.Get(self)
	local obj = tremove(self._freeList)
	if not obj then
		self._numCreated = self._numCreated + 1
		obj = self._createFunc()
		assert(obj)
	end
	if self._extraStackOffset then
		self._state[obj] = (TSMAPI_FOUR.Util.GetDebugStackInfo(2 + self._extraStackOffset) or "?").." -> "..(TSMAPI_FOUR.Util.GetDebugStackInfo(3 + self._extraStackOffset) or "?")
	else
		self._state[obj] = "???"
	end
	return obj
end

function ObjectPool.Recycle(self, obj)
	assert(self._state[obj])
	self._state[obj] = nil
	tinsert(self._freeList, obj)
end

function ObjectPool._GetNumCreated(self)
	return self._numCreated
end

function ObjectPool._GetDebugStats(self)
	local counts = {}
	local totalCount = 0
	for _, caller in pairs(self._state) do
		counts[caller] = (counts[caller] or 0) + 1
		totalCount = totalCount + 1
	end
	local debugInfo = {}
	for info, count in pairs(counts) do
		if count > DEBUG_STATS_MIN_COUNT then
			tinsert(debugInfo, format("[%d] %s", count, info))
		end
	end
	if #debugInfo == 0 then
		tinsert(debugInfo, "<none>")
	end
	return self._numCreated, totalCount, debugInfo
end
