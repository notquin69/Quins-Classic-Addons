-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Expirations = TSM.TaskList:NewPackage("Expirations")
local L = TSM.L
local private = {
	query = nil,
	mailTaskPool = TSMAPI_FOUR.ObjectPool.New("EXPIRING_MAIL_TASK", TSM.TaskList.ExpiringMailTask, 0),
	auctionTaskPool = TSMAPI_FOUR.ObjectPool.New("EXPIRED_AUCTION_TASK", TSM.TaskList.ExpiredAuctionTask, 0),
	activeTasks = {},
	expiringMailTasks = {},
	expiredAuctionTasks = {},
}
local PLAYER_NAME = UnitName("player")
local DAYS_LEFT_LIMIT = 1



-- ============================================================================
-- Module Functions
-- ============================================================================

function Expirations.OnEnable()
	TSM.TaskList.RegisterTaskPool(private.ActiveTaskIterator)
	private.PopulateTasks()
end

function Expirations.Update()
	private.PopulateTasks()
end

function Expirations.UpdateDelayed()
	TSMAPI_FOUR.Delay.AfterTime("EXPIRATION_UPDATE_DELAYED", 0.5, private.PopulateTasks)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.ActiveTaskIterator()
	return ipairs(private.activeTasks)
end

function private.PopulateTasks()
	local minPendingCooldown = math.huge

	wipe(private.activeTasks)

	for _, task in pairs(private.expiringMailTasks) do
		task:WipeCharacters()
	end
	for _, task in pairs(private.expiredAuctionTasks) do
		task:WipeCharacters()
	end

	-- expiring mails
	for k, v in pairs(TSM.db.factionrealm.internalData.expiringMail) do
		local task = private.expiringMailTasks["ExpiringMails"]
		if not task then
			task = private.mailTaskPool:Get()
			task:Acquire(private.RemoveMailTask, L["Expirations"])
			private.expiringMailTasks["ExpiringMails"] = task
		end

		local expiration = (v - time()) / 24 / 60 / 60
		if expiration <= DAYS_LEFT_LIMIT * -1 then
			TSM.db.factionrealm.internalData.expiringMail[PLAYER_NAME] = nil
		else
			if not task:HasCharacter(k) and expiration <= DAYS_LEFT_LIMIT then
				task:AddCharacter(k, expiration)
			end
			if expiration > 0 and expiration <= DAYS_LEFT_LIMIT then
				minPendingCooldown = min(minPendingCooldown, expiration * 24 * 60 * 60)
			else
				minPendingCooldown = min(minPendingCooldown, (expiration + DAYS_LEFT_LIMIT) * 24 * 60 * 60)
			end
		end
	end

	for character, task in pairs(private.expiringMailTasks) do
		if task:HasCharacters() then
			tinsert(private.activeTasks, task)
			task:Update()
		else
			private.expiringMailTasks[character] = nil
			task:Release()
			private.mailTaskPool:Recycle(task)
		end
	end

	-- expired auctions
	for k, v in pairs(TSM.db.factionrealm.internalData.expiringAuction) do
		local task = private.expiredAuctionTasks["ExpiredAuctions"]
		if not task then
			task = private.auctionTaskPool:Get()
			task:Acquire(private.RemoveAuctionTask, L["Expirations"])
			private.expiredAuctionTasks["ExpiredAuctions"] = task
		end

		local expiration = (v - time()) / 24 / 60 / 60
		if expiration > 0 and expiration <= DAYS_LEFT_LIMIT then
			minPendingCooldown = min(minPendingCooldown, expiration * 24 * 60 * 60)
		else
			if not task:HasCharacter(k) then
				task:AddCharacter(k, expiration)
			end
		end
	end

	for character, task in pairs(private.expiredAuctionTasks) do
		if task:HasCharacters() then
			tinsert(private.activeTasks, task)
			task:Update()
		else
			private.expiredAuctionTasks[character] = nil
			task:Release()
			private.auctionTaskPool:Recycle(task)
		end
	end

	TSM.TaskList.OnTaskUpdated()

	if minPendingCooldown ~= math.huge and minPendingCooldown < DAYS_LEFT_LIMIT then
		TSMAPI_FOUR.Delay.AfterTime("EXPIRATION_UPDATE", minPendingCooldown, private.PopulateTasks)
	else
		TSMAPI_FOUR.Delay.Cancel("EXPIRATION_UPDATE")
	end
end

function private.RemoveMailTask(task)
	assert(TSMAPI_FOUR.Util.TableRemoveByValue(private.activeTasks, task) == 1)
	task:Release()
	private.mailTaskPool:Recycle(task)
	TSM.TaskList.OnTaskUpdated()
end

function private.RemoveAuctionTask(task)
	assert(TSMAPI_FOUR.Util.TableRemoveByValue(private.activeTasks, task) == 1)
	task:Release()
	private.auctionTaskPool:Recycle(task)
	TSM.TaskList.OnTaskUpdated()
end
