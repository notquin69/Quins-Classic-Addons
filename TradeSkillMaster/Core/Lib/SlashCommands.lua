-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local SlashCommands = TSM:NewPackage("SlashCommands")
local L = TSM.L
local private = { commandInfo = {}, commandOrder = {} }



-- ============================================================================
-- Module Functions
-- ============================================================================

function SlashCommands.OnInitialize()
	-- register the TSM slash commands
	SlashCmdList["TSM"] = private.OnChatCommand
	SlashCmdList["TRADESKILLMASTER"] = private.OnChatCommand
	_G["SLASH_TSM1"] = "/tsm"
	_G["SLASH_TRADESKILLMASTER1"] = "/tradeskillmaster"
end

function SlashCommands.Register(key, callback, label)
	local keyLower = strlower(key)
	private.commandInfo[keyLower] = {
		key = key,
		label = label,
		callback = callback,
	}
	tinsert(private.commandOrder, keyLower)
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private.OnChatCommand(input)
	local cmd, args = strmatch(strtrim(input), "^([^ ]*) ?(.*)$")
	if cmd == "" then
		TSM.MainUI.Toggle()
	else
		cmd = strlower(cmd)
		if private.commandInfo[cmd] then
			private.commandInfo[cmd].callback(args)
		else
			-- We weren't able to handle this command so print out the help
			TSM:Print(L["Slash Commands:"])
			TSM:PrintRaw("|cffffaa00" .. L["/tsm|r - opens the main TSM window."])
			TSM:PrintRaw("|cffffaa00" .. L["/tsm help|r - Shows this help listing"])
			for _, key in ipairs(private.commandOrder) do
				local info = private.commandInfo[key]
				if info.label then
					TSM:PrintfRaw("|cffffaa00/tsm %s|r - %s", info.key, info.label)
				end
			end
		end
	end
end
