-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- This is the main TSM file that holds the majority of the APIs that modules will use.

local TSM = TSMAPI_FOUR.Addon.New(...)
local LibRealmInfo = LibStub("LibRealmInfo")
local LibDBIcon = LibStub("LibDBIcon-1.0")
local L = TSM.L
local private = { appInfo = nil }
TSMAPI = {Operations={}, Settings={}}
local APP_INFO_REQUIRED_KEYS = { "version", "lastSync", "message", "news" }
local LOGOUT_TIME_WARNING_THRESHOLD_MS = 20
do
	-- show a message if we were updated
	if GetAddOnMetadata("TradeSkillMaster", "Version") ~= "v4.8.14" then
		message("TSM was just updated and may not work properly until you restart WoW.")
	end
end

-- Changelog:
-- [6] added 'global.locale' key
-- [7] changed default value of 'tsmItemTweetEnabled' to false
-- [8] added 'global.itemCacheVersion' key
-- [9] removed 'global.itemCacheVersion' key, added 'global.clientVersion' key
-- [10] first TSM4 version - combined all module settings into a single DB
-- [11] added profile.internalData.createdDefaultOperations
-- [12] added global.shoppingOptions.pctSource
-- [13] added profile.internalData.{managementGroupTreeContext,auctioningGroupTreeContext,shoppingGroupTreeContext}
-- [14] added global.userData.savedAuctioningSearches
-- [15] added global.coreOptions.bankUITab, profile.coreOptions.{bankUIBankFramePosition,bankUIGBankFramePosition}
-- [16] moved profile.coreOptions.{bankUIBankFramePosition,bankUIGBankFramePosition} to profile.internalData.{bankUIBankFramePosition,bankUIGBankFramePosition}
-- [17] added global.internalData.{mainUIFrameContext,auctionUIFrameContext,craftingUIFrameContext}
-- [18] removed global.internalData.itemStringLookup
-- [19] added sync scope (initially with internalData.{classKey,bagQuantity,bankQuantity,reagentBankQuantity,auctionQuantity,mailQuantity}), removed factionrealm.internalData.{syncMetadata,accountKey,inventory,characters} and factionrealm.coreOptions.syncAccounts, added global.debug.chatLoggingEnabled
-- [20] added global.tooltipOptions.enabled
-- [21] added global.craftingOptions.{profitPercent,questSmartCrafting,queueSort}
-- [22] added global.coreOptions.cleanGuildBank
-- [23] changed global.shoppingOptions.maxDeSearchPercent default to 100
-- [24] added global.auctioningOptions.{showAuctionDBTab,openAllBags,ahRowDisplay}
-- [25] split realm.internalData.goldLog into sync.internalData.goldLog and factionrealm.internalData.guildGoldLog
-- [26] added profile.internalData.{shoppingTabGroupContext,auctioningTabGroupContext}
-- [27] added char.internalData.craftingCooldowns
-- [28] added global.internalData.mailingUIFrameContext
-- [29] added global.internalData.vendoringUIFrameContext
-- [30] added global.internalData.bankingUIFrameContext
-- [31] changed global.internalData.bankingUIFrameContext default (isOpen = true), added profile.internalData.{bankingWarehousingGroupTreeContext,bankingAuctioningGroupTreeContext,bankingMailingGroupTreeContext}
-- [32] removed factionrealm.internalData.gathering, added factionrealm.internalData.gatheringContext.{crafter,professions}, added profile.gatheringOptions.sources
-- [33] added global.internalData.taskListUIFrameContext
-- [34] removed realm.internalData.{lastAuctionDBCompleteScan,lastAuctionDBSaveTime,auctionDBScanData}
-- [35] added factionrealm.userData.craftingCooldownIgnore
-- [36] removed factionrealm.internalData.playerProfessions and added sync.internalData.playerProfessions
-- [37] removed global.auctioningOptions.showAuctionDBTab
-- [38] removed global.mailingOptions.{defaultMailTab,autoCheck,displayMoneyCollected,deleteEmptyNPCMail,showReloadBtn,sendDelay,defaultPage}, added global.mailingOptions.recentlyMailedList
-- [39] added profile.internalData.{craftingGroupTreeContext,mailingGroupTreeContext,vendoringGroupTreeContext,importGroupTreeContext}
-- [40] removed global.accountingOptions.{timeFormat,mvSource}
-- [41] removed global.coreOptions.groupPriceSource
-- [42] removed global.vendoringOptions.defaultMerchantTab
-- [43] removed global.coreOptions.{moveDelay,bankUITab}, removed global.auctioningOptions.{openAllBags,ahRowDisplay}, removed global.craftingOptions.{profitPercent,questSmartCrafting,queueSort}, removed global.destroyingOptions.{logDays,timeFormat}, removed global.vendoringOptions.{autoSellTrash,qsHideGrouped,qsHideSoulbound,qsBatchSize,defaultPage,qsMaxMarketValue,qsDestroyValue}, removed profile.coreOptions.{cleanBags,cleanBank,cleanReagentBank,cleanGuildBank}
-- [44] changed global.internalData.{mainUIFrameContext,auctionUIFrameContext,craftingUIFrameContext,destroyingUIFrameContext,mailingUIFrameContext,vendoringUIFrameContext,bankingUIFrameContext} default (added "scale = 1")
-- [45] added char.internalData.auctionSaleHints
-- [46] added global.shoppingOptions.{buyoutConfirm,buyoutAlertSource}
-- [47] added factionrealm.internalData.expiringMail and factionrealm.internalData.expiringAuction
-- [48] added profile.internalData.exportGroupTreeContext
-- [49] added factionrealm.internalData.{mailDisenchantablesChar,mailExcessGoldChar,mailExcessGoldLimit}
-- [50] added factionrealm.internalData.{csvAuctionDBScan,auctionDBScanTime,auctionDBScanHash}
-- [51-53] resetting factionrealm.internalData.crafts

local SETTINGS_INFO = {
	version = 53,
	global = {
		debug = {
			chatLoggingEnabled = { type = "boolean", default = false, lastModifiedVersion = 19 },
		},
		internalData = {
			vendorItems = { type = "table", default = {}, lastModifiedVersion = 10 },
			appMessageId = { type = "number", default = 0, lastModifiedVersion = 10 },
			destroyingHistory = { type = "table", default = {}, lastModifiedVersion = 10 },
			mainUIFrameContext = { type = "table", default = { width = 948, height = 757, centerX = 0, centerY = 0, page = 1, scale = 1 }, lastModifiedVersion = 44 },
			auctionUIFrameContext = { type = "table", default = { width = 830, height = 587, centerX = -300, centerY = 100, page = 1, scale = 1 }, lastModifiedVersion = 44 },
			craftingUIFrameContext = { type = "table", default = { width = 820, height = 587, centerX = -200, centerY = 0, page = 1, scale = 1 }, lastModifiedVersion = 44 },
			destroyingUIFrameContext = { type = "table", default = { width = 296, height = 442, centerX = 0, centerY = 0, scale = 1 }, lastModifiedVersion = 44 },
			mailingUIFrameContext = { type = "table", default = { width = 560, height = 500, centerX = -200, centerY = 0, page = 1, scale = 1 }, lastModifiedVersion = 44 },
			vendoringUIFrameContext = { type = "table", default = { width = 560, height = 500, centerX = -200, centerY = 0, page = 1, scale = 1 }, lastModifiedVersion = 44 },
			bankingUIFrameContext = { type = "table", default = { width = 325, height = 600, centerX = 500, centerY = 0, tab = "Warehousing", isOpen = true, scale = 1 }, lastModifiedVersion = 44 },
			taskListUIFrameContext = { type = "table", default = { topRightX = -220, topRightY = -10, minimized = false, isOpen = true }, lastModifiedVersion = 33 },
		},
		coreOptions = {
			globalOperations = { type = "boolean", default = false, lastModifiedVersion = 10 },
			chatFrame = { type = "string", default = "", lastModifiedVersion = 10 },
			auctionSaleEnabled = { type = "boolean", default = true, lastModifiedVersion = 10 },
			auctionSaleSound = { type = "string", default = TSM.CONST.NO_SOUND_KEY, lastModifiedVersion = 10 },
			auctionBuyEnabled = { type = "boolean", default = true, lastModifiedVersion = 10 },
			tsmItemTweetEnabled = { type = "boolean", default = false, lastModifiedVersion = 10 },
			minimapIcon = { type = "table", default = { hide = false, minimapPos = 220, radius = 80 }, lastModifiedVersion = 10 },
			destroyValueSource = { type = "string", default = "dbmarket", lastModifiedVersion = 10 },
			groupPriceSource = { type = "string", default = "dbmarket", lastModifiedVersion = 41 },
		},
		accountingOptions = {
			trackTrades = { type = "boolean", default = true, lastModifiedVersion = 10 },
			autoTrackTrades = { type = "boolean", default = false, lastModifiedVersion = 10 },
			smartBuyPrice = { type = "boolean", default = false, lastModifiedVersion = 10 },
		},
		auctioningOptions = {
			cancelWithBid = { type = "boolean", default = false, lastModifiedVersion = 10 },
			disableInvalidMsg = { type = "boolean", default = false, lastModifiedVersion = 10 },
			roundNormalPrice = { type = "boolean", default = false, lastModifiedVersion = 10 },
			matchWhitelist = { type = "boolean", default = true, lastModifiedVersion = 10 },
			scanCompleteSound = { type = "string", default = TSM.CONST.NO_SOUND_KEY, lastModifiedVersion = 10 },
			confirmCompleteSound = { type = "string", default = TSM.CONST.NO_SOUND_KEY, lastModifiedVersion = 10 },
		},
		craftingOptions = {
			ignoreCDCraftCost = { type = "boolean", default = true, lastModifiedVersion = 10 },
			defaultMatCostMethod = { type = "string", default = "min(dbmarket, crafting, vendorbuy, convert(dbmarket))", lastModifiedVersion = 10 },
			defaultCraftPriceMethod = { type = "string", default = "first(dbminbuyout, dbmarket)", lastModifiedVersion = 10 },
			ignoreCharacters = { type = "table", default = {}, lastModifiedVersion = 10 },
			ignoreGuilds = { type = "table", default = {}, lastModifiedVersion = 10 },
		},
		destroyingOptions = {
			autoStack = { type = "boolean", default = true, lastModifiedVersion = 10 },
			includeSoulbound = { type = "boolean", default = false, lastModifiedVersion = 10 },
			autoShow = { type = "boolean", default = true, lastModifiedVersion = 10 },
			deMaxQuality = { type = "number", default = 3, lastModifiedVersion = 10 },
			deAbovePrice = { type = "string", default = "0c", lastModifiedVersion = 10 },
		},
		mailingOptions = {
			sendItemsIndividually = { type = "boolean", default = false, lastModifiedVersion = 10 },
			inboxMessages = { type = "boolean", default = true, lastModifiedVersion = 10 },
			sendMessages = { type = "boolean", default = true, lastModifiedVersion = 10 },
			resendDelay = { type = "number", default = 1, lastModifiedVersion = 10 },
			keepMailSpace = { type = "number", default = 0, lastModifiedVersion = 10 },
			deMaxQuality = { type = "number", default = 2, lastModifiedVersion = 10 },
			openMailSound = { type = "string", default = TSM.CONST.NO_SOUND_KEY, lastModifiedVersion = 10 },
			recentlyMailedList = { type = "table", default = {}, lastModifiedVersion = 38 },
		},
		shoppingOptions = {
			minDeSearchLvl = { type = "number", default = 1, lastModifiedVersion = 10 },
			maxDeSearchLvl = { type = "number", default = 735, lastModifiedVersion = 10 },
			maxDeSearchPercent = { type = "number", default = 100, lastModifiedVersion = 23 },
			pctSource  = { type = "string", default = "dbmarket", lastModifiedVersion = 12 },
			buyoutConfirm  = { type = "boolean", default = false, lastModifiedVersion = 46 },
			buyoutAlertSource  = { type = "string", default = "min(100000g, 200% dbmarket)", lastModifiedVersion = 46 },
		},
		sniperOptions = {
			sniperSound = { type = "string", default = TSM.CONST.NO_SOUND_KEY, lastModifiedVersion = 10 },
		},
		vendoringOptions = {
			displayMoneyCollected = { type = "boolean", default = false, lastModifiedVersion = 10 },
			qsMarketValue = { type = "string", default = "dbmarket", lastModifiedVersion = 10 },
		},
		tooltipOptions = {
			enabled = { type = "boolean", default = true, lastModifiedVersion = 20 },
			embeddedTooltip = { type = "boolean", default = true, lastModifiedVersion = 10 },
			customPriceTooltips = { type = "table", default = {}, lastModifiedVersion = 10 },
			moduleTooltips = { type = "table", default = {}, lastModifiedVersion = 10 },
			vendorBuyTooltip = { type = "boolean", default = true, lastModifiedVersion = 10 },
			vendorSellTooltip = { type = "boolean", default = true, lastModifiedVersion = 10 },
			groupNameTooltip = { type = "boolean", default = true, lastModifiedVersion = 10 },
			detailedDestroyTooltip = { type = "boolean", default = false, lastModifiedVersion = 10 },
			millTooltip = { type = "boolean", default = true, lastModifiedVersion = 10 },
			prospectTooltip = { type = "boolean", default = true, lastModifiedVersion = 10 },
			deTooltip = { type = "boolean", default = true, lastModifiedVersion = 10 },
			transformTooltip = { type = "boolean", default = true, lastModifiedVersion = 10 },
			operationTooltips = { type = "table", default = {}, lastModifiedVersion = 10 },
			tooltipShowModifier = { type = "string", default = "none", lastModifiedVersion = 10 },
			inventoryTooltipFormat = { type = "string", default = "full", lastModifiedVersion = 10 },
			tooltipPriceFormat = { type = "string", default = "text", lastModifiedVersion = 10 },
		},
		userData = {
			operations = { type = "table", default = {}, lastModifiedVersion = 10 },
			customPriceSources = { type = "table", default = {}, lastModifiedVersion = 10 },
			destroyingIgnore = { type = "table", default = {}, lastModifiedVersion = 10 },
			savedShoppingSearches = { type = "table", default = {}, lastModifiedVersion = 10 },
			vendoringIgnore = { type = "table", default = {}, lastModifiedVersion = 10 },
			savedAuctioningSearches = { type = "table", default = {}, lastModifiedVersion = 14 },
		},
	},
	profile = {
		internalData = {
			createdDefaultOperations = { type = "boolean", default = false, lastModifiedVersion = 11 },
			managementGroupTreeContext = { type = "table", default = {}, lastModifiedVersion = 13 },
			auctioningGroupTreeContext = { type = "table", default = {}, lastModifiedVersion = 13 },
			shoppingGroupTreeContext = { type = "table", default = {}, lastModifiedVersion = 13 },
			shoppingTabGroupContext = { type = "table", default = {}, lastModifiedVersion = 26 },
			auctioningTabGroupContext = { type = "table", default = {}, lastModifiedVersion = 26 },
			bankUIBankFramePosition = { type = "table", default = { 100, 300 }, lastModifiedVersion = 16 },
			bankUIGBankFramePosition = { type = "table", default = { 100, 300 }, lastModifiedVersion = 16 },
			bankingWarehousingGroupTreeContext = { type = "table", default = {}, lastModifiedVersion = 31 },
			bankingAuctioningGroupTreeContext = { type = "table", default = {}, lastModifiedVersion = 31 },
			bankingMailingGroupTreeContext = { type = "table", default = {}, lastModifiedVersion = 31 },
			craftingGroupTreeContext = { type = "table", default = {}, lastModifiedVersion = 39 },
			mailingGroupTreeContext = { type = "table", default = {}, lastModifiedVersion = 39 },
			vendoringGroupTreeContext = { type = "table", default = {}, lastModifiedVersion = 39 },
			importGroupTreeContext = { type = "table", default = {}, lastModifiedVersion = 39 },
			exportGroupTreeContext = { type = "table", default = {}, lastModifiedVersion = 48 },
		},
		userData = {
			groups = { type = "table", default = {}, lastModifiedVersion = 10 },
			items = { type = "table", default = {}, lastModifiedVersion = 10 },
			operations = { type = "table", default = {}, lastModifiedVersion = 10 },
		},
		gatheringOptions = {
			sources = { type = "table", default = { "vendor", "guildBank", "alt", "altGuildBank", "craftProfit", "auction", "craftNoProfit" }, lastModifiedVersion = 32 },
		},
	},
	factionrealm = {
		internalData = {
			characterGuilds = { type = "table", default = {}, lastModifiedVersion = 10 },
			guildVaults = { type = "table", default = {}, lastModifiedVersion = 10 },
			pendingMail = { type = "table", default = {}, lastModifiedVersion = 10 },
			expiringMail = { type = "table", default = {}, lastModifiedVersion = 47 },
			expiringAuction = { type = "table", default = {}, lastModifiedVersion = 47 },
			mailDisenchantablesChar = { type = "string", default = "", lastModifiedVersion = 49 },
			mailExcessGoldChar = { type = "string", default = "", lastModifiedVersion = 49 },
			mailExcessGoldLimit = { type = "number", default = 10000000000, lastModifiedVersion = 49 },
			crafts = { type = "table", default = {}, lastModifiedVersion = 53 },
			mats = { type = "table", default = {}, lastModifiedVersion = 10 },
			guildGoldLog = { type = "table", default = {}, lastModifiedVersion = 25 },
			csvAuctionDBScan = { type = "string", default = "", lastModifiedVersion = 50 },
			auctionDBScanTime = { type = "number", default = 0, lastModifiedVersion = 50 },
			auctionDBScanHash = { type = "number", default = 0, lastModifiedVersion = 50 },
		},
		coreOptions = {
			ignoreGuilds = { type = "table", default = {}, lastModifiedVersion = 10 },
		},
		auctioningOptions = {
			whitelist = { type = "table", default = {}, lastModifiedVersion = 10 },
		},
		gatheringContext = {
			crafter = { type = "string", default = "", lastModifiedVersion = 32 },
			professions = { type = "table", default = {}, lastModifiedVersion = 32 },
		},
		userData = {
			craftingCooldownIgnore = { type = "table", default = {}, lastModifiedVersion = 35 },
		},
	},
	realm = {
		internalData = {
			csvSales = { type = "string", default = "", lastModifiedVersion = 10 },
			csvBuys = { type = "string", default = "", lastModifiedVersion = 10 },
			csvIncome = { type = "string", default = "", lastModifiedVersion = 10 },
			csvExpense = { type = "string", default = "", lastModifiedVersion = 10 },
			csvExpired = { type = "string", default = "", lastModifiedVersion = 10 },
			csvCancelled = { type = "string", default = "", lastModifiedVersion = 10 },
			saveTimeSales = { type = "string", default = "", lastModifiedVersion = 10 },
			saveTimeBuys = { type = "string", default = "", lastModifiedVersion = 10 },
			saveTimeExpires = { type = "string", default = "", lastModifiedVersion = 10 },
			saveTimeCancels = { type = "string", default = "", lastModifiedVersion = 10 },
			accountingTrimmed = { type = "table", default = {}, lastModifiedVersion = 10 },
		},
	},
	char = {
		internalData = {
			auctionPrices = { type = "table", default = {}, lastModifiedVersion = 10 },
			auctionMessages = { type = "table", default = {}, lastModifiedVersion = 10 },
			craftingCooldowns = { type = "table", default = {}, lastModifiedVersion = 27 },
			auctionSaleHints = { type = "table", default = {}, lastModifiedVersion = 45 },
		},
	},
	sync = {
		-- NOTE: whenever these are changed, the sync version needs to be increased in Core/Lib/Sync/Core.lua
		internalData = {
			classKey = { type = "string", default = "", lastModifiedVersion = 19 },
			bagQuantity = { type = "table", default = {}, lastModifiedVersion = 19 },
			bankQuantity = { type = "table", default = {}, lastModifiedVersion = 19 },
			reagentBankQuantity = { type = "table", default = {}, lastModifiedVersion = 19 },
			auctionQuantity = { type = "table", default = {}, lastModifiedVersion = 19 },
			mailQuantity = { type = "table", default = {}, lastModifiedVersion = 19 },
			goldLog = { type = "string", default = "", lastModifiedVersion = 25 },
			playerProfessions = { type = "table", default = {}, lastModifiedVersion = 36 },
		},
	},
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function TSM.OnInitialize()
	-- create setting migration table
	TradeSkillMasterModulesDB = TradeSkillMasterModulesDB or {}
	for _, moduleName in ipairs(TSM.CONST.OLD_TSM_MODULES) do
		moduleName = gsub(moduleName, "TradeSkillMaster_", "")
		TradeSkillMasterModulesDB[moduleName] = TradeSkillMasterModulesDB[moduleName] or {}
	end

	-- load settings
	local db, upgradeObj = TSM.Settings.New("TradeSkillMasterDB", SETTINGS_INFO)
	TSM.db = db
	if upgradeObj then
		local prevVersion = upgradeObj:GetPrevVersion()
		if prevVersion < 10 then
			-- migrate all the old settings to their new namespaces
			for key, value in upgradeObj:RemovedSettingIterator() do
				local scopeType, scopeKey, _, settingKey = upgradeObj:GetKeyInfo(key)
				for namespace, namespaceInfo in pairs(SETTINGS_INFO[scopeType]) do
					if namespaceInfo[settingKey] then
						TSM.db:Set(scopeType, scopeKey, namespace, settingKey, value)
					end
				end
			end
			-- migrade all old module settings into the core settings
			local MIGRATION_INFO = {
				Accounting = {
					["global.trackTrades"] = "global.accountingOptions.trackTrades",
					["global.autoTrackTrades"] = "global.accountingOptions.autoTrackTrades",
					["realm.csvSales"] = "realm.internalData.csvSales",
					["realm.csvBuys"] = "realm.internalData.csvBuys",
					["realm.csvIncome"] = "realm.internalData.csvIncome",
					["realm.csvExpense"] = "realm.internalData.csvExpense",
					["realm.csvExpired"] = "realm.internalData.csvExpired",
					["realm.csvCancelled"] = "realm.internalData.csvCancelled",
					["realm.saveTimeSales"] = "realm.internalData.saveTimeSales",
					["realm.saveTimeBuys"] = "realm.internalData.saveTimeBuys",
					["realm.saveTimeExpires"] = "realm.internalData.saveTimeExpires",
					["realm.saveTimeCancels"] = "realm.internalData.saveTimeCancels",
					["realm.accountingTrimmed"] = "realm.internalData.accountingTrimmed",
				},
				Auctioning = {
					["global.cancelWithBid"] = "global.auctioningOptions.cancelWithBid",
					["global.disableInvalidMsg"] = "global.auctioningOptions.disableInvalidMsg",
					["global.roundNormalPrice"] = "global.auctioningOptions.roundNormalPrice",
					["global.matchWhitelist"] = "global.auctioningOptions.matchWhitelist",
					["global.scanCompleteSound"] = "global.auctioningOptions.scanCompleteSound",
					["global.confirmCompleteSound"] = "global.auctioningOptions.confirmCompleteSound",
					["factionrealm.whitelist"] = "factionrealm.auctioningOptions.whitelist",
				},
				Crafting = {
					["global.ignoreCDCraftCost"] = "global.craftingOptions.ignoreCDCraftCost",
					["global.defaultMatCostMethod"] = "global.craftingOptions.defaultMatCostMethod",
					["global.defaultCraftPriceMethod"] = "global.craftingOptions.defaultCraftPriceMethod",
					["global.ignoreCharacters"] = "global.craftingOptions.ignoreCharacters",
					["global.ignoreGuilds"] = "global.craftingOptions.ignoreGuilds",
					["factionrealm.crafts"] = "factionrealm.internalData.crafts",
					["factionrealm.mats"] = "factionrealm.internalData.mats",
				},
				Destroying = {
					["global.history"] = "global.internalData.destroyingHistory",
					["global.autoStack"] = "global.destroyingOptions.autoStack",
					["global.includeSoulbound"] = "global.destroyingOptions.includeSoulbound",
					["global.autoShow"] = "global.destroyingOptions.autoShow",
					["global.deMaxQuality"] = "global.destroyingOptions.deMaxQuality",
					["global.deAbovePrice"] = "global.destroyingOptions.deAbovePrice",
					["global.ignore"] = "global.userData.destroyingIgnore",
				},
				Mailing = {
					["global.sendItemsIndividually"] = "global.mailingOptions.sendItemsIndividually",
					["global.inboxMessages"] = "global.mailingOptions.inboxMessages",
					["global.sendMessages"] = "global.mailingOptions.sendMessages",
					["global.resendDelay"] = "global.mailingOptions.resendDelay",
					["global.keepMailSpace"] = "global.mailingOptions.keepMailSpace",
					["global.deMaxQuality"] = "global.mailingOptions.deMaxQuality",
					["global.openMailSound"] = "global.mailingOptions.openMailSound",
				},
				Shopping = {
					["global.minDeSearchLvl"] = "global.shoppingOptions.minDeSearchLvl",
					["global.maxDeSearchLvl"] = "global.shoppingOptions.maxDeSearchLvl",
					["global.maxDeSearchPercent"] = "global.shoppingOptions.maxDeSearchPercent",
					["global.sniperSound"] = "global.sniperOptions.sniperSound",
					["global.savedSearches"] = "global.userData.savedShoppingSearches",
				},
				Vendoring = {
					["global.displayMoneyCollected"] = "global.vendoringOptions.displayMoneyCollected",
					["global.qsMarketValue"] = "global.vendoringOptions.qsMarketValue",
					["global.ignore"] = "global.userData.vendoringIgnore",
				},
			}
			for module, migrations in pairs(MIGRATION_INFO) do
				for key, value in pairs(TradeSkillMasterModulesDB[module]) do
					if strsub(key, 1, 1) ~= "_" then
						local scopeType, scopeKey, _, settingKey = upgradeObj:GetKeyInfo(key)
						local oldPath = strjoin(".", scopeType, settingKey)
						local newPath = migrations[oldPath]
						if newPath then
							local newScopeType, newNamespace, newSettingKey = strsplit(".", newPath)
							assert(newScopeType == scopeType)
							TSM.db:Set(newScopeType, scopeKey, newNamespace, newSettingKey, value)
						end
					end
				end
			end
		end
		if prevVersion < 19 then
			-- migrate inventory data to the sync scope
			local oldInventoryData = TSMAPI_FOUR.Util.AcquireTempTable()
			local oldSyncMetadata = TSMAPI_FOUR.Util.AcquireTempTable()
			local oldAccountKey = TSMAPI_FOUR.Util.AcquireTempTable()
			local oldCharacters = TSMAPI_FOUR.Util.AcquireTempTable()
			for key, value in upgradeObj:RemovedSettingIterator() do
				local scopeType, scopeKey, _, settingKey = upgradeObj:GetKeyInfo(key)
				if scopeType == "factionrealm" then
					if settingKey == "inventory" then
						oldInventoryData[scopeKey] = value
					elseif settingKey == "syncMetadata" then
						oldSyncMetadata[scopeKey] = value
					elseif settingKey == "accountKey" then
						oldAccountKey[scopeKey] = value
					elseif settingKey == "characters" then
						oldCharacters[scopeKey] = value
					end
				end
			end
			for factionrealm, characters in pairs(oldInventoryData) do
				local syncMetadata = oldSyncMetadata[factionrealm] and oldSyncMetadata[factionrealm].TSM_CHARACTERS
				for character, inventoryData in pairs(characters) do
					if not syncMetadata or not syncMetadata[character] or syncMetadata[character].owner == oldAccountKey[factionrealm] then
						TSM.db:NewSyncCharacter(character, TSM.db:GetSyncAccountKey(factionrealm), factionrealm)
						local syncScopeKey = TSM.db:GetSyncScopeKeyByCharacter(character, factionrealm)
						local class = oldCharacters[factionrealm] and oldCharacters[factionrealm][character]
						if type(class) == "string" then
							TSM.db:Set("sync", syncScopeKey, "internalData", "classKey", class)
						end
						TSM.db:Set("sync", syncScopeKey, "internalData", "bagQuantity", inventoryData.bag)
						TSM.db:Set("sync", syncScopeKey, "internalData", "bankQuantity", inventoryData.bank)
						TSM.db:Set("sync", syncScopeKey, "internalData", "reagentBankQuantity", inventoryData.reagentBank)
						TSM.db:Set("sync", syncScopeKey, "internalData", "auctionQuantity", inventoryData.auction)
						TSM.db:Set("sync", syncScopeKey, "internalData", "mailQuantity", inventoryData.mail)
					end
				end
			end
			TSMAPI_FOUR.Util.ReleaseTempTable(oldInventoryData)
			TSMAPI_FOUR.Util.ReleaseTempTable(oldSyncMetadata)
			TSMAPI_FOUR.Util.ReleaseTempTable(oldAccountKey)
			TSMAPI_FOUR.Util.ReleaseTempTable(oldCharacters)
		end
		if prevVersion < 25 then
			-- migrate gold log info
			local NEW_CSV_COLS = { "minute", "copper" }
			local function ConvertGoldLogFormat(data)
				local decodedData = select(2, TSMAPI_FOUR.CSV.Decode(data))
				if not decodedData then
					return
				end
				for _, entry in ipairs(decodedData) do
					local minute = entry.startMinute
					local copper = entry.copper
					wipe(entry)
					entry.minute = minute
					entry.copper = copper
				end
				return TSMAPI_FOUR.CSV.Encode(NEW_CSV_COLS, decodedData)
			end
			local function ProcessGoldLogData(character, data, scopeKey)
				if type(data) ~= "string" then
					return
				end
				-- check if we know about this character and under what faction
				local syncScopeKey = nil
				for factionrealm in TSM.db:FactionrealmByRealmIterator(scopeKey) do
					local testSyncScopeKey = TSM.db:GetSyncScopeKeyByCharacter(character, factionrealm)
					if TSM.db:Get("sync", testSyncScopeKey, "internalData", "classKey") then
						syncScopeKey = testSyncScopeKey
					end
				end
				if syncScopeKey then
					TSM.db:Set("sync", syncScopeKey, "internalData", "goldLog", ConvertGoldLogFormat(data))
				else
					-- check if this is a known guild
					local found = false
					for factionrealm in TSM.db:FactionrealmByRealmIterator(scopeKey) do
						local characterGuilds = TSM.db:Get("factionrealm", factionrealm, "internalData", "characterGuilds")
						if not found and characterGuilds and TSMAPI_FOUR.Util.TableKeyByValue(characterGuilds, character) then
							local guildGoldLog = TSM.db:Get("factionrealm", factionrealm, "internalData", "guildGoldLog") or {}
							guildGoldLog[character] = ConvertGoldLogFormat(data)
							TSM.db:Set("factionrealm", factionrealm, "internalData", "guildGoldLog", guildGoldLog)
							found = true
						end
					end
				end
			end
			if prevVersion < 10 then
				for key, value in pairs(TradeSkillMasterModulesDB.Accounting) do
					if strmatch(key,"^r@.+@goldLog$") then
						local _, scopeKey = upgradeObj:GetKeyInfo(key)
						for character, data in pairs(value) do
							ProcessGoldLogData(character, data, scopeKey)
						end
					end
				end
			else
				for key, value in upgradeObj:RemovedSettingIterator() do
					local scopeType, scopeKey, _, settingKey = upgradeObj:GetKeyInfo(key)
					if scopeType == "realm" and settingKey == "goldLog" then
						for character, data in pairs(value) do
							ProcessGoldLogData(character, data, scopeKey)
						end
					end
				end
			end
		end
		if prevVersion < 36 then
			for key, value in upgradeObj:RemovedSettingIterator() do
				local scopeType, factionrealm, _, settingKey = upgradeObj:GetKeyInfo(key)
				if scopeType == "factionrealm" and settingKey == "playerProfessions" then
					for character, data in pairs(value) do
						-- check if we know about this character
						local syncScopeKey = TSM.db:GetSyncScopeKeyByCharacter(character, factionrealm)
						if TSM.db:Get("sync", syncScopeKey, "internalData", "classKey") then
							TSM.db:Set("sync", syncScopeKey, "internalData", "playerProfessions", data)
						end
					end
				end
			end
		end
		if prevVersion < 53 and WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
			for key, value in upgradeObj:RemovedSettingIterator() do
				local scopeType, factionrealm, namespace, settingKey = upgradeObj:GetKeyInfo(key)
				if scopeType == "factionrealm" and namespace == "internalData" and settingKey == "crafts" then
					TSM.db:Set("factionrealm", factionrealm, "internalData", "crafts", value)
				end
			end
		end
	end

	-- store the class of this character
	TSM.db.sync.internalData.classKey = select(2, UnitClass("player"))

	-- core price sources
	TSM.CustomPrice.RegisterSource("TradeSkillMaster", "VendorBuy", L["Buy from Vendor"], TSMAPI_FOUR.Item.GetVendorBuy)
	TSM.CustomPrice.RegisterSource("TradeSkillMaster", "VendorSell", L["Sell to Vendor"], TSMAPI_FOUR.Item.GetVendorSell)
	TSM.CustomPrice.RegisterSource("TradeSkillMaster", "Destroy", L["Destroy Value"], function(itemString) return TSMAPI_FOUR.Conversions.GetValue(itemString, TSM.db.global.coreOptions.destroyValueSource) end)
	TSM.CustomPrice.RegisterSource("TradeSkillMaster", "ItemQuality", L["Item Quality"], TSMAPI_FOUR.Item.GetQuality)
	TSM.CustomPrice.RegisterSource("TradeSkillMaster", "ItemLevel", L["Item Level"], TSMAPI_FOUR.Item.GetItemLevel)
	TSM.CustomPrice.RegisterSource("TradeSkillMaster", "RequiredLevel", L["Required Level"], TSMAPI_FOUR.Item.GetMinLevel)

	-- Auctioneer price sources
	if TSMAPI_FOUR.Util.IsAddonEnabled("Auc-Advanced") and AucAdvanced then
		if AucAdvanced.Modules.Util.Appraiser and AucAdvanced.Modules.Util.Appraiser.GetPrice then
			TSM.CustomPrice.RegisterSource("External", "AucAppraiser", L["Auctioneer - Appraiser"], AucAdvanced.Modules.Util.Appraiser.GetPrice, true)
		end
		if AucAdvanced.Modules.Util.SimpleAuction and AucAdvanced.Modules.Util.SimpleAuction.Private.GetItems then
			local function GetAucMinBuyout(itemLink)
				return select(6, AucAdvanced.Modules.Util.SimpleAuction.Private.GetItems(itemLink)) or nil
			end
			TSM.CustomPrice.RegisterSource("External", "AucMinBuyout", L["Auctioneer - Minimum Buyout"], GetAucMinBuyout, true)
		end
		if AucAdvanced.API.GetMarketValue then
			TSM.CustomPrice.RegisterSource("External", "AucMarket", L["Auctioneer - Market Value"], AucAdvanced.API.GetMarketValue, true)
		end
	end

	-- Auctionator price sources
	if TSMAPI_FOUR.Util.IsAddonEnabled("Auctionator") and Atr_GetAuctionBuyout then
		TSM.CustomPrice.RegisterSource("External", "AtrValue", L["Auctionator - Auction Value"], Atr_GetAuctionBuyout, true)
	end

	-- TheUndermineJournal and BootyBayGazette price sources
	if TSMAPI_FOUR.Util.IsAddonEnabled("TheUndermineJournal") and TUJMarketInfo then
		local function GetTUJPrice(itemLink, arg)
			local data = TUJMarketInfo(itemLink)
			return data and data[arg] or nil
		end
		TSM.CustomPrice.RegisterSource("External", "TUJRecent", L["TUJ 3-Day Price"], GetTUJPrice, true, "recent")
		TSM.CustomPrice.RegisterSource("External", "TUJMarket", L["TUJ 14-Day Price"], GetTUJPrice, true, "market")
		TSM.CustomPrice.RegisterSource("External", "TUJGlobalMean", L["TUJ Global Mean"], GetTUJPrice, true, "globalMean")
		TSM.CustomPrice.RegisterSource("External", "TUJGlobalMedian", L["TUJ Global Median"], GetTUJPrice, true, "globalMedian")
	elseif TSMAPI_FOUR.Util.IsAddonEnabled("BootyBayGazette") and TUJMarketInfo then
		local function GetBBGPrice(itemLink, arg)
			local data = TUJMarketInfo(itemLink)
			return data and data[arg] or nil
		end
		TSM.CustomPrice.RegisterSource("External", "BBGRecent", L["BBG 3-Day Price"], GetBBGPrice, true, "recent")
		TSM.CustomPrice.RegisterSource("External", "BBGMarket", L["BBG 14-Day Price"], GetBBGPrice, true, "market")
		TSM.CustomPrice.RegisterSource("External", "BBGGlobalMean", L["BBG Global Mean"], GetBBGPrice, true, "globalMean")
		TSM.CustomPrice.RegisterSource("External", "BBGGlobalMedian", L["BBG Global Median"], GetBBGPrice, true, "globalMedian")
	end

	-- AHDB price sources
	if TSMAPI_FOUR.Util.IsAddonEnabled("AuctionDB") and AuctionDB and AuctionDB.AHGetAuctionInfoByLink then
		local function GetAHDBPrice(itemLink, arg)
			local info = AuctionDB:AHGetAuctionInfoByLink(itemLink)
			return info and info[arg] or nil
		end
		TSM.CustomPrice.RegisterSource("External", "AHDBMinBuyout", L["AHDB Minimum Buyout"], GetAHDBPrice, true, "minBuyout")
		TSM.CustomPrice.RegisterSource("External", "AHDBMinBid", L["AHDB Minimum Bid"], GetAHDBPrice, true, "minBid")
	end

	-- module price sources
	TSM.CustomPrice.RegisterSource("Accounting", "avgSell", L["Avg Sell Price"], TSM.Accounting.Transactions.GetAverageSalePrice)
	TSM.CustomPrice.RegisterSource("Accounting", "avgSell", L["Avg Sell Price"], TSM.Accounting.Transactions.GetAverageSalePrice)
	TSM.CustomPrice.RegisterSource("Accounting", "maxSell", L["Max Sell Price"], TSM.Accounting.Transactions.GetMaxSalePrice)
	TSM.CustomPrice.RegisterSource("Accounting", "minSell", L["Min Sell Price"], TSM.Accounting.Transactions.GetMinSalePrice)
	TSM.CustomPrice.RegisterSource("Accounting", "avgBuy", L["Avg Buy Price"], TSM.Accounting.Transactions.GetAverageBuyPrice)
	TSM.CustomPrice.RegisterSource("Accounting", "maxBuy", L["Max Buy Price"], TSM.Accounting.Transactions.GetMaxBuyPrice)
	TSM.CustomPrice.RegisterSource("Accounting", "minBuy", L["Min Buy Price"], TSM.Accounting.Transactions.GetMinBuyPrice)
	TSM.CustomPrice.RegisterSource("Accounting", "NumExpires", L["Expires Since Last Sale"], TSM.Accounting.Auctions.GetNumExpiresSinceSale)
	TSM.CustomPrice.RegisterSource("AuctionDB", "DBMarket", L["AuctionDB - Market Value"], TSM.AuctionDB.GetRealmItemData, false, "marketValue")
	TSM.CustomPrice.RegisterSource("AuctionDB", "DBMinBuyout", L["AuctionDB - Minimum Buyout"], TSM.AuctionDB.GetRealmItemData, false, "minBuyout")
	TSM.CustomPrice.RegisterSource("AuctionDB", "DBHistorical", L["AuctionDB - Historical Price (via TSM App)"], TSM.AuctionDB.GetRealmItemData, false, "historical")
	TSM.CustomPrice.RegisterSource("AuctionDB", "DBRegionMinBuyoutAvg", L["AuctionDB - Region Minimum Buyout Average (via TSM App)"], TSM.AuctionDB.GetRegionItemData, false, "regionMinBuyout")
	TSM.CustomPrice.RegisterSource("AuctionDB", "DBRegionMarketAvg", L["AuctionDB - Region Market Value Average (via TSM App)"], TSM.AuctionDB.GetRegionItemData, false, "regionMarketValue")
	TSM.CustomPrice.RegisterSource("AuctionDB", "DBRegionHistorical", L["AuctionDB - Region Historical Price (via TSM App)"], TSM.AuctionDB.GetRegionItemData, false, "regionHistorical")
	TSM.CustomPrice.RegisterSource("AuctionDB", "DBRegionSaleAvg", L["AuctionDB - Region Sale Average (via TSM App)"], TSM.AuctionDB.GetRegionItemData, false, "regionSale")
	TSM.CustomPrice.RegisterSource("AuctionDB", "DBRegionSaleRate", L["AuctionDB - Region Sale Rate (via TSM App)"], TSM.AuctionDB.GetRegionSaleInfo, false, "regionSalePercent")
	TSM.CustomPrice.RegisterSource("AuctionDB", "DBRegionSoldPerDay", L["AuctionDB - Region Sold Per Day (via TSM App)"], TSM.AuctionDB.GetRegionSaleInfo, false, "regionSoldPerDay")
	TSM.CustomPrice.RegisterSource("Crafting", "Crafting", L["Crafting Cost"], TSM.Crafting.Cost.GetLowestCostByItem)
	TSM.CustomPrice.RegisterSource("Crafting", "matPrice", L["Crafting Material Cost"], TSM.Crafting.Cost.GetMatCost)

	-- slash commands
	TSM.SlashCommands.Register("version", private.PrintVersions, L["Prints out the version numbers of all installed modules"])
	TSM.SlashCommands.Register("sources", TSM.CustomPrice.PrintSources, L["Prints out the available price sources for use in custom prices"])
	TSM.SlashCommands.Register("price", private.TestPriceSource, L["Allows for testing of custom prices"])
	TSM.SlashCommands.Register("profile", private.ChangeProfile, L["Changes to the specified profile (i.e. '/tsm profile Default' changes to the 'Default' profile)"])
	TSM.SlashCommands.Register("debug", private.DebugSlashCommandHandler)
	TSM.SlashCommands.Register("destroy", TSM.UI.DestroyingUI.Toggle, L["Opens the Destroying frame if there's stuff in your bags to be destroyed."])
	TSM.SlashCommands.Register("crafting", TSM.UI.CraftingUI.Toggle, L["Toggles the TSM Crafting UI."])
	TSM.SlashCommands.Register("tasklist", TSM.UI.TaskListUI.Toggle, L["Toggles the TSM Task List UI"])
	TSM.SlashCommands.Register("bankui", TSM.UI.BankingUI.Toggle, L["Toggles the TSM Banking UI if either the bank or guild bank is currently open."])
	TSM.SlashCommands.Register("get", TSM.Banking.GetByFilter, L["Gets items from the bank or guild bank matching the item or partial text entered."])
	TSM.SlashCommands.Register("put", TSM.Banking.PutByFilter, L["Puts items matching the item or partial text entered into the bank or guild bank."])
	TSM.SlashCommands.Register("restock_help", TSM.Crafting.RestockHelp, L["Tells you why a specific item is not being restocked and added to the queue."])
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		TSM.SlashCommands.Register("scan", TSM.AuctionDB.RunScan, L["Performs a full, manual scan of the AH to populate some AuctionDB data if none is otherwise available."])
	end

	-- create / register the minimap button
	local dataObj = LibStub("LibDataBroker-1.1"):NewDataObject("TradeSkillMaster", {
		type = "launcher",
		icon = "Interface\\Addons\\TradeSkillMaster\\Media\\TSM_Icon2",
		OnClick = function(_, button)
			if button ~= "LeftButton" then return end
			TSM.MainUI.Toggle()
		end,
		OnTooltipShow = function(tooltip)
			local cs = "|cffffffcc"
			local ce = "|r"
			tooltip:AddLine("TradeSkillMaster " .. TSM:GetVersion())
			tooltip:AddLine(format(L["%sLeft-Click%s to open the main window"], cs, ce))
			tooltip:AddLine(format(L["%sDrag%s to move this button"], cs, ce))
		end,
	})
	LibDBIcon:Register("TradeSkillMaster", dataObj, TSM.db.global.coreOptions.minimapIcon)

	-- cache battle pet names
	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		for i = 1, C_PetJournal.GetNumPets() do
			C_PetJournal.GetPetInfoByIndex(i)
		end
	end

	-- force a garbage collection
	collectgarbage()
end

function TSM.OnEnable()
	-- disable old TSM modules
	local didDisable = false
	for _, name in ipairs(TSM.CONST.OLD_TSM_MODULES) do
		if TSMAPI_FOUR.Util.IsAddonEnabled(name) then
			didDisable = true
			DisableAddOn(name, true)
		end
	end
	if didDisable then
		StaticPopupDialogs["TSM_OLD_MODULE_DISABLE"] = {
			text = L["Welcome to TSM4! All of the old TSM3 modules (i.e. Crafting, Shopping, etc) are now built-in to the main TSM addon, so you only need TSM and TSM_AppHelper installed. TSM has disabled the old modules and requires a reload."],
			button1 = L["Reload"],
			timeout = 0,
			whileDead = true,
			OnAccept = ReloadUI,
		}
		TSMAPI_FOUR.Util.ShowStaticPopupDialog("TSM_OLD_MODULE_DISABLE")
	else
		TradeSkillMasterModulesDB = nil
	end

	TSM.LoadAppData()
end

function TSM.OnDisable()
	local originalProfile = TSM.db:GetCurrentProfile()
	-- erroring here would cause the profile to be reset, so use pcall
	local startTime = debugprofilestop()
	local success, errMsg = pcall(private.SaveAppData)
	local timeTaken = debugprofilestop() - startTime
	if timeTaken > LOGOUT_TIME_WARNING_THRESHOLD_MS then
		TSM:LOG_WARN("private.SaveAppData took %0.2fms", timeTaken)
	end
	if not success then
		TSM:LOG_ERR("private.SaveAppData hit an error: %s", tostring(errMsg))
	end
	-- ensure we're back on the correct profile
	TSM.db:SetProfile(originalProfile)
end

function TSM.LoadAppData()
	if not TSMAPI_FOUR.Util.IsAddonInstalled("TradeSkillMaster_AppHelper") then
		return
	end

	if not TSMAPI_FOUR.Util.IsAddonEnabled("TradeSkillMaster_AppHelper") then
		-- TSM_AppHelper is disabled
		StaticPopupDialogs["TSM_APP_DATA_ERROR"] = {
			text = L["The TradeSkillMaster_AppHelper addon is installed, but not enabled. TSM has enabled it and requires a reload."],
			button1 = L["Reload"],
			timeout = 0,
			whileDead = true,
			OnAccept = function()
				EnableAddOn("TradeSkillMaster_AppHelper")
				ReloadUI()
			end,
		}
		TSMAPI_FOUR.Util.ShowStaticPopupDialog("TSM_APP_DATA_ERROR")
		return
	end

	assert(TSMAPI.AppHelper)
	local appInfo = TSMAPI.AppHelper:FetchData("APP_INFO")
	if not appInfo then
		-- The app hasn't run yet or isn't pointing at the right WoW directory
		StaticPopupDialogs["TSM_APP_DATA_ERROR"] = {
			text = L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."],
			button1 = OKAY,
			timeout = 0,
			whileDead = true,
		}
		TSMAPI_FOUR.Util.ShowStaticPopupDialog("TSM_APP_DATA_ERROR")
		return
	end

	-- load the app info
	assert(#appInfo == 1 and #appInfo[1] == 2 and appInfo[1][1] == "Global")
	private.appInfo = assert(loadstring(appInfo[1][2]))()
	for _, key in ipairs(APP_INFO_REQUIRED_KEYS) do
		assert(private.appInfo[key])
	end

	if private.appInfo.message and private.appInfo.message.id > TSM.db.global.internalData.appMessageId then
		-- show the message from the app
		TSM.db.global.internalData.appMessageId = private.appInfo.message.id
		StaticPopupDialogs["TSM_APP_MESSAGE"] = {
			text = private.appInfo.message.msg,
			button1 = OKAY,
			timeout = 0,
		}
		TSMAPI_FOUR.Util.ShowStaticPopupDialog("TSM_APP_MESSAGE")
	end

	if time() - private.appInfo.lastSync > 60 * 60 then
		-- the app hasn't been running for over an hour
		StaticPopupDialogs["TSM_APP_DATA_ERROR"] = {
			text = L["TSM is missing important information from the TSM Desktop Application. Please ensure the TSM Desktop Application is running and is properly configured."],
			button1 = OKAY,
			timeout = 0,
			whileDead = true,
		}
		TSMAPI_FOUR.Util.ShowStaticPopupDialog("TSM_APP_DATA_ERROR")
	end
end



-- ============================================================================
-- General Slash-Command Handlers
-- ============================================================================

function private.TestPriceSource(price)
	local _, endIndex, link = strfind(price, "(\124c[0-9a-f]+\124H[^\124]+\124h%[[^%]]+%]\124h\124r)")
	price = link and strtrim(strsub(price, endIndex + 1))
	if not price or price == "" then
		TSM:Print(L["Usage: /tsm price <ItemLink> <Price String>"])
		return
	end

	local isValid, err = TSMAPI_FOUR.CustomPrice.Validate(price)
	if not isValid then
		TSM:Printf(L["%s is not a valid custom price and gave the following error: %s"], "|cff99ffff"..price.."|r", err)
		return
	end

	local itemString = TSMAPI_FOUR.Item.ToItemString(link)
	if not itemString then
		TSM:Printf(L["%s is a valid custom price but %s is an invalid item."], "|cff99ffff"..price.."|r", link)
		return
	end

	local value = TSMAPI_FOUR.CustomPrice.GetValue(price, itemString)
	if not value then
		TSM:Printf(L["%s is a valid custom price but did not give a value for %s."], "|cff99ffff"..price.."|r", link)
		return
	end

	TSM:Printf(L["A custom price of %s for %s evaluates to %s."], "|cff99ffff"..price.."|r", link, TSM.Money.ToString(value))
end

function private.ChangeProfile(targetProfile)
	targetProfile = strtrim(targetProfile)
	local profiles = TSM.db:GetProfiles()
	if targetProfile == "" then
		TSM:Printf(L["No profile specified. Possible profiles: '%s'"], table.concat(profiles, "', '"))
	else
		for _, profile in ipairs(profiles) do
			if profile == targetProfile then
				if profile ~= TSM.db:GetCurrentProfile() then
					TSM.db:SetProfile(profile)
				end
				TSM:Printf(L["Profile changed to '%s'."], profile)
				return
			end
		end
		TSM:Printf(L["Could not find profile '%s'. Possible profiles: '%s'"], targetProfile, table.concat(profiles, "', '"))
	end
end

function private.DebugSlashCommandHandler(arg)
	if arg == "fstack" then
		TSM.UI.ToggleFrameStack()
	elseif arg == "error" then
		TSM.ShowManualError()
	elseif arg == "logging" then
		TSM.db.global.debug.chatLoggingEnabled = not TSM.db.global.debug.chatLoggingEnabled
		if TSM.db.global.debug.chatLoggingEnabled then
			TSM:Printf("Logging to chat enabled")
		else
			TSM:Printf("Logging to chat disabled")
		end
	elseif arg == "db" then
		TSM.UI.DBViewer.Toggle()
	elseif arg == "logout" then
		TSM.AddonTestLogout()
	elseif arg == "clearitemdb" then
		TSMItemInfoDB = nil
		ReloadUI()
	end
end

function private.PrintVersions()
	TSM:Print(L["TSM Version Info:"])
	TSM:PrintfRaw("TradeSkillMaster |cff99ffff%s|r", TSM:GetVersion())
	local appHelperVersion = GetAddOnMetadata("TradeSkillMaster_AppHelper", "Version")
	if appHelperVersion then
		-- use strmatch so that our sed command doesn't replace this string
		if strmatch(appHelperVersion, "^@tsm%-project%-version@$") then
			appHelperVersion = "Dev"
		end
		TSM:PrintfRaw("TradeSkillMaster_AppHelper |cff99ffff%s|r", appHelperVersion)
	end
end

function private.SaveAppData()
	if not TSMAPI.AppHelper then
		return
	end

	TradeSkillMaster_AppHelperDB = TradeSkillMaster_AppHelperDB or {}
	local appDB = TradeSkillMaster_AppHelperDB

	-- store region
	local region = TSM.GetRegion()
	appDB.region = region

	-- save errors
	TSM.SaveErrorReports(appDB)

	local function GetShoppingMaxPrice(itemString)
		local operation = TSM.Operations.GetFirstOperationByItem("Shopping", itemString)
		if not operation or type(operation.maxPrice) ~= "string" then
			return
		end
		local value = TSMAPI_FOUR.CustomPrice.GetValue(operation.maxPrice, itemString)
		if not value or value <= 0 then
			return
		end
		return value
	end

	-- save TSM_Shopping max prices in the app DB
	appDB.shoppingMaxPrices = {}
	for profile in TSM.GetTSMProfileIterator() do
		local profileGroupData = {}
		for _, itemString, groupPath in TSM.Groups.ItemIterator() do
			local itemId = tonumber(strmatch(itemString, "^i:([0-9]+)$"))
			if itemId then
				local maxPrice = GetShoppingMaxPrice(itemString)
				if maxPrice then
					if not profileGroupData[groupPath] then
						profileGroupData[groupPath] = {}
					end
					tinsert(profileGroupData[groupPath], "["..table.concat({itemId, maxPrice}, ",").."]")
				end
			end
		end
		if next(profileGroupData) then
			appDB.shoppingMaxPrices[profile] = {}
			for groupPath, data in pairs(profileGroupData) do
				appDB.shoppingMaxPrices[profile][groupPath] = "["..table.concat(data, ",").."]"
			end
			appDB.shoppingMaxPrices[profile].updateTime = time()
		end
	end

	-- save black market data
	local realmName = GetRealmName()
	appDB.blackMarket = appDB.blackMarket or {}
	if TSM.Features.blackMarket then
		local hash = TSMAPI_FOUR.Util.CalculateHash(TSM.Features.blackMarket..":"..TSM.Features.blackMarketTime)
		appDB.blackMarket[realmName] = {data=TSM.Features.blackMarket, key=hash, updateTime=TSM.Features.blackMarketTime}
	end

	-- save analytics
	TSM.Analytics.Save(appDB)
end



-- ============================================================================
-- General Module Functions
-- ============================================================================

function TSM:GetAppNews()
	return private.appInfo and private.appInfo.news
end

function TSM:GetChatFrame()
	local chatFrame = DEFAULT_CHAT_FRAME
	for i = 1, NUM_CHAT_WINDOWS do
		local name = strlower(GetChatWindowInfo(i) or "")
		if name ~= "" and (not TSM.db or name == strlower(TSM.db.global.coreOptions.chatFrame)) then
			chatFrame = _G["ChatFrame" .. i]
			break
		end
	end
	return chatFrame
end

function TSM:GetVersion()
	return TSMAPI_FOUR.Util.IsDevVersion("TradeSkillMaster") and "Dev" or GetAddOnMetadata("TradeSkillMaster", "Version")
end



-- ============================================================================
-- General TSMAPI Functions
-- ============================================================================

function TSM.GetRegion()
	local cVar = GetCVar("Portal")
	local region = WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC and LibRealmInfo:GetCurrentRegion() or (cVar ~= "public-test" and cVar) or "PTR"
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		region = region.."-Classic"
	end
	return region
end

function TSM.GetTSMProfileIterator()
	local originalProfile = TSM.db:GetCurrentProfile()
	local profiles = TSM.db:GetProfiles()

	return function()
		local profile = tremove(profiles)
		if profile then
			TSM.db:SetProfile(profile)
			return profile
		end
		TSM.db:SetProfile(originalProfile)
	end
end



-- ============================================================================
-- FIXME: this is all just temporary code which should eventually be removed
-- ============================================================================

do
	TSMAPI.Settings.Init = function(_, name)
		local moduleName = gsub(name, "DB$", "")
		local AceAddon = LibStub("AceAddon-3.0")
		local obj = AceAddon and AceAddon:GetAddon(gsub(moduleName, "TradeSkillMaster", "TSM"))
		if obj and tContains(TSM.CONST.OLD_TSM_MODULES, moduleName) then
			obj.OnInitialize = nil
			obj.OnEnable = nil
			obj.OnDisable = nil
			for _, module in ipairs(obj.modules) do
				module.OnInitialize = nil
				module.OnEnable = nil
				module.OnDisable = nil
			end
			wipe(obj.modules)
			wipe(obj.orderedModules)
		end
		error(moduleName, 2)
	end
end
