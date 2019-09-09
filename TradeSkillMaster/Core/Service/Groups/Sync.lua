-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Sync = TSM.Groups:NewPackage("Sync")
local L = TSM.L
local private = {}



-- ============================================================================
-- New Modules Functions
-- ============================================================================

function Sync.OnInitialize()
	TSM.Sync.RPC.Register("CREATE_PROFILE", private.RPCCreateProfile)
end

function Sync.SendCurrentProfile(targetPlayer)
	local profileName = TSM.db:GetCurrentProfile()
	local data = TSMAPI_FOUR.Util.AcquireTempTable()
	data.groups = TSMAPI_FOUR.Util.AcquireTempTable()
	for groupPath, moduleOperations in pairs(TSM.db:Get("profile", profileName, "userData", "groups")) do
		data.groups[groupPath] = {}
		for _, module in TSM.Operations.ModuleIterator() do
			local operations = moduleOperations[module]
			if operations.override then
				data.groups[groupPath][module] = operations
			end
		end
	end
	data.items = TSM.db:Get("profile", profileName, "userData", "items")
	data.operations = TSM.db:Get("profile", profileName, "userData", "operations")
	local result, estimatedTime = TSM.Sync.RPC.Call("CREATE_PROFILE", targetPlayer, private.RPCCreateProfileResultHandler, profileName, UnitName("player"), data)
	if result then
		estimatedTime = max(TSMAPI_FOUR.Util.Round(estimatedTime, 60), 60)
		TSM:Printf(L["Sending your '%s' profile to %s. Please keep both characters online until this completes. This will take approximately: %s"], profileName, targetPlayer, SecondsToTime(estimatedTime))
	else
		TSM:Print(L["Failed to send profile. Ensure both characters are online and try again."])
	end
	TSMAPI_FOUR.Util.ReleaseTempTable(data.groups)
	TSMAPI_FOUR.Util.ReleaseTempTable(data)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.CopyTable(srcTbl, dstTbl)
	for k, v in pairs(srcTbl) do
		dstTbl[k] = v
	end
end

function private.RPCCreateProfile(profileName, playerName, data)
	assert(TSM.db:IsValidProfileName(profileName))
	if TSM.db:ProfileExists(profileName) then
		return false, L["A profile with that name already exists on the target account. Rename it first and try again."]
	end

	-- create and switch to the new profile
	local currentProfile = TSM.db:GetCurrentProfile()
	TSM.db:SetProfile(profileName)

	-- copy all the data into this profile
	private.CopyTable(data.groups, TSM.db.profile.userData.groups)
	private.CopyTable(data.items, TSM.db.profile.userData.items)
	private.CopyTable(data.operations, TSM.db.profile.userData.operations)

	-- switch back to our previous profile
	TSM.db:SetProfile(currentProfile)

	TSM:Printf(L["Added '%s' profile which was received from %s."], profileName, playerName)

	return true, profileName, UnitName("player")
end

function private.RPCCreateProfileResultHandler(success, ...)
	if success == nil then
		TSM:Print(L["Failed to send profile."].." "..L["Ensure both characters are online and try again."])
		return
	elseif not success then
		local errMsg = ...
		TSM:Print(L["Failed to send profile."].." "..errMsg)
		return
	end

	local profileName, targetPlayer = ...
	TSM:Printf(L["Successfully sent your '%s' profile to %s!"], profileName, targetPlayer)
end
