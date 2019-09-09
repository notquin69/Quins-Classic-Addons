-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local Warehousing = TSM.Operations:NewPackage("Warehousing")
local private = {}
local L = TSM.L
local OPERATION_INFO = {
	moveQuantity = { type = "number", default = 0 },
	keepBagQuantity = { type = "number", default = 0 },
	keepBankQuantity = { type = "number", default = 0 },
	restockQuantity = { type = "number", default = 0 },
	stackSize = { type = "number", default = 0 },
	restockKeepBankQuantity = { type = "number", default = 0 },
	restockStackSize = { type = "number", default = 0 },
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function Warehousing.OnInitialize()
	-- migrate operation settings
	if TSM.db.global.userData.operations and TSM.db.global.userData.operations.Warehousing then
		for _, operationSettings in pairs(TSM.db.global.userData.operations.Warehousing) do
			private.MigrateOperationSettings(operationSettings)
		end
	end
	for _, profileName in TSM.db:ProfileIterator() do
		local operations = TSM.db:Get("profile", profileName, "userData", "operations")
		if operations and operations.Warehousing then
			for _, operationSettings in pairs(operations.Warehousing) do
				private.MigrateOperationSettings(operationSettings)
			end
		end
	end
	TSM.Operations.Register("Warehousing", L["Warehousing"], OPERATION_INFO, 12, private.GetOperationInfo)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.MigrateOperationSettings(operationSettings)
	if operationSettings.moveQtyEnabled == false then
		operationSettings.moveQuantity = 0
	end
	if operationSettings.keepBagQtyEnabled == false then
		operationSettings.keepBagQuantity = 0
	end
	if operationSettings.keepBankQtyEnabled == false then
		operationSettings.keepBankQuantity = 0
	end
	if operationSettings.restockQtyEnabled == false then
		operationSettings.restockQuantity = 0
	end
	if operationSettings.stackSizeEnabled == false then
		operationSettings.stackSize = 0
	end
	if operationSettings.restockKeepBankQtyEnabled == false then
		operationSettings.restockKeepBankQuantity = 0
	end
	if operationSettings.restockStackSizeEnabled == false then
		operationSettings.restockStackSize = 0
	end
end

function private.GetOperationInfo(operationSettings)
	if (operationSettings.keepBagQuantity ~= 0 or operationSettings.keepBankQuantity ~= 0) and operationSettings.moveQuantity == 0 then
		if operationSettings.keepBagQuantity ~= 0 then
			if operationSettings.keepBankQuantity ~= 0 then
				if operationSettings.restockQuantity ~= 0 then
					return format(L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."], operationSettings.keepBagQuantity, operationSettings.keepBankQuantity, operationSettings.restockQuantity)
				else
					return format(L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."], operationSettings.keepBagQuantity, operationSettings.keepBankQuantity)
				end
			else
				if operationSettings.restockQuantity ~= 0 then
					return format(L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."], operationSettings.keepBagQuantity, operationSettings.restockQuantity)
				else
					return format(L["Warehousing will move all of the items in this group keeping %d of each item back when bags > bank/gbank."], operationSettings.keepBagQuantity)
				end
			end
		else
			if operationSettings.restockQuantity ~= 0 then
				return format(L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."], operationSettings.keepBankQuantity, operationSettings.restockQuantity)
			else
				return format(L["Warehousing will move all of the items in this group keeping %d of each item back when bank/gbank > bags."], operationSettings.keepBankQuantity)
			end
		end
	elseif (operationSettings.keepBagQuantity ~= 0 or operationSettings.keepBankQuantity ~= 0) and operationSettings.moveQuantity ~= 0 then
		if operationSettings.keepBagQuantity ~= 0 then
			if operationSettings.keepBankQuantity ~= 0 then
				if operationSettings.restockQuantity ~= 0 then
					return format(L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."], operationSettings.moveQuantity, operationSettings.keepBagQuantity, operationSettings.keepBankQuantity, operationSettings.restockQuantity)
				else
					return format(L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank, %d of each item back when bank/gbank > bags."], operationSettings.moveQuantity, operationSettings.keepBagQuantity, operationSettings.keepBankQuantity)
				end
			else
				if operationSettings.restockQuantity ~= 0 then
					return format(L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank. Restock will maintain %d items in your bags."], operationSettings.keepBankQuantity, operationSettings.restockQuantity)
				else
					return format(L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bags > bank/gbank."], operationSettings.keepBankQuantity)
				end
			end
		else
			if operationSettings.restockQuantity ~= 0 then
				return format(L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags. Restock will maintain %d items in your bags."], operationSettings.moveQuantity, operationSettings.keepBankQuantity, operationSettings.restockQuantity)
			else
				return format(L["Warehousing will move a max of %d of each item in this group keeping %d of each item back when bank/gbank > bags."], operationSettings.moveQuantity, operationSettings.keepBankQuantity)
			end
		end
	elseif operationSettings.moveQuantity ~= 0 then
		if operationSettings.restockQuantity ~= 0 then
			return format(L["Warehousing will move a max of %d of each item in this group. Restock will maintain %d items in your bags."], operationSettings.moveQuantity, operationSettings.restockQuantity)
		else
			return format(L["Warehousing will move a max of %d of each item in this group."], operationSettings.moveQuantity)
		end
	else
		if operationSettings.restockQuantity ~= 0 then
			return format(L["Warehousing will move all of the items in this group. Restock will maintain %d items in your bags."], operationSettings.restockQuantity)
		else
			return L["Warehousing will move all of the items in this group."]
		end
	end
end
