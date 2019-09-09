---------------------------------------------------------------------------------
--
-- Prat - A framework for World of Warcraft chat mods
--
-- Copyright (C) 2006-2018  Prat Development Team
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to:
--
-- Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor,
-- Boston, MA  02110-1301, USA.
--
--
-------------------------------------------------------------------------------

Prat:AddModuleToLoad(function()

    local PRAT_MODULE = Prat:RequestModuleName("Invites")

    if PRAT_MODULE == nil then
        return
    end

    local module = Prat:NewModule(PRAT_MODULE, "AceHook-3.0")

    -- define localized strings
    local PL = module.PL

    --[===[@debug@
    PL:AddLocale(PRAT_MODULE, "enUS", {
        module_name = "Invites",
        module_desc = "Options for easy inviting of players to groups",
        ["Enable Alt-Invite"] = true,
        ["Toggle group invites by alt-clicking on player name."] = true,
        ["Enable Invite Links"] = true,
        ["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."] = true,
    })
    --@end-debug@]===]

    -- These Localizations are auto-generated. To help with localization
    -- please go to http://www.wowace.com/projects/prat-3-0/localization/
    --@non-debug@
    do
        local L

    
  L = {
	["Invites"] = {
		["Enable Alt-Invite"] = true,
		["Enable Invite Links"] = true,
		["module_desc"] = "Options for easy inviting of players to groups",
		["module_name"] = "Invites",
		["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."] = true,
		["Toggle group invites by alt-clicking on player name."] = true,
	}
}


      PL:AddLocale(PRAT_MODULE, "enUS",L)


    
  L = {
	["Invites"] = {
		--[[Translation missing --]]
		["Enable Alt-Invite"] = "Enable Alt-Invite",
		["Enable Invite Links"] = "Activer les liens d'invitation",
		--[[Translation missing --]]
		["module_desc"] = "Options for easy inviting of players to groups",
		--[[Translation missing --]]
		["module_name"] = "Invites",
		--[[Translation missing --]]
		["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."] = "Toggle group invites by alt-clicking hyperlinked keywords like 'invite'.",
		--[[Translation missing --]]
		["Toggle group invites by alt-clicking on player name."] = "Toggle group invites by alt-clicking on player name.",
	}
}


      PL:AddLocale(PRAT_MODULE, "frFR",L)


    
  L = {
	["Invites"] = {
		["Enable Alt-Invite"] = "Aktiviere Alt-Einladen",
		["Enable Invite Links"] = "Aktiviere Einladungs-Links",
		["module_desc"] = "Optionen zum einfachen Einladen von Spielern für Gruppen",
		["module_name"] = "Einladungen",
		["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."] = "Zum Umschalten der Gruppeneinladungen, klicke bei gedrückter Alt-Taste auf Hyperlink-Schlüsselwörter wie \"einladen\".",
		["Toggle group invites by alt-clicking on player name."] = "Zum Umschalten der Gruppeneinladungen, klicke bei gedrückter Alt-Taste auf den Spielernamen.",
	}
}


      PL:AddLocale(PRAT_MODULE, "deDE",L)


    
  L = {
	["Invites"] = {
		--[[Translation missing --]]
		["Enable Alt-Invite"] = "Enable Alt-Invite",
		--[[Translation missing --]]
		["Enable Invite Links"] = "Enable Invite Links",
		--[[Translation missing --]]
		["module_desc"] = "Options for easy inviting of players to groups",
		--[[Translation missing --]]
		["module_name"] = "Invites",
		--[[Translation missing --]]
		["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."] = "Toggle group invites by alt-clicking hyperlinked keywords like 'invite'.",
		--[[Translation missing --]]
		["Toggle group invites by alt-clicking on player name."] = "Toggle group invites by alt-clicking on player name.",
	}
}


      PL:AddLocale(PRAT_MODULE, "koKR",L)


    
  L = {
	["Invites"] = {
		--[[Translation missing --]]
		["Enable Alt-Invite"] = "Enable Alt-Invite",
		--[[Translation missing --]]
		["Enable Invite Links"] = "Enable Invite Links",
		--[[Translation missing --]]
		["module_desc"] = "Options for easy inviting of players to groups",
		--[[Translation missing --]]
		["module_name"] = "Invites",
		--[[Translation missing --]]
		["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."] = "Toggle group invites by alt-clicking hyperlinked keywords like 'invite'.",
		--[[Translation missing --]]
		["Toggle group invites by alt-clicking on player name."] = "Toggle group invites by alt-clicking on player name.",
	}
}


      PL:AddLocale(PRAT_MODULE, "esMX",L)


    
  L = {
	["Invites"] = {
		["Enable Alt-Invite"] = "включить Alt-приглашение",
		["Enable Invite Links"] = "Показать ссылку \"приглашения\"",
		["module_desc"] = "Опции простого приглашения игроков в группу",
		["module_name"] = "Приглашения",
		--[[Translation missing --]]
		["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."] = "Toggle group invites by alt-clicking hyperlinked keywords like 'invite'.",
		--[[Translation missing --]]
		["Toggle group invites by alt-clicking on player name."] = "Toggle group invites by alt-clicking on player name.",
	}
}


      PL:AddLocale(PRAT_MODULE, "ruRU",L)


    
  L = {
	["Invites"] = {
		--[[Translation missing --]]
		["Enable Alt-Invite"] = "Enable Alt-Invite",
		--[[Translation missing --]]
		["Enable Invite Links"] = "Enable Invite Links",
		--[[Translation missing --]]
		["module_desc"] = "Options for easy inviting of players to groups",
		--[[Translation missing --]]
		["module_name"] = "Invites",
		--[[Translation missing --]]
		["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."] = "Toggle group invites by alt-clicking hyperlinked keywords like 'invite'.",
		--[[Translation missing --]]
		["Toggle group invites by alt-clicking on player name."] = "Toggle group invites by alt-clicking on player name.",
	}
}


      PL:AddLocale(PRAT_MODULE, "zhCN",L)


    
  L = {
	["Invites"] = {
		--[[Translation missing --]]
		["Enable Alt-Invite"] = "Enable Alt-Invite",
		--[[Translation missing --]]
		["Enable Invite Links"] = "Enable Invite Links",
		--[[Translation missing --]]
		["module_desc"] = "Options for easy inviting of players to groups",
		--[[Translation missing --]]
		["module_name"] = "Invites",
		--[[Translation missing --]]
		["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."] = "Toggle group invites by alt-clicking hyperlinked keywords like 'invite'.",
		--[[Translation missing --]]
		["Toggle group invites by alt-clicking on player name."] = "Toggle group invites by alt-clicking on player name.",
	}
}


      PL:AddLocale(PRAT_MODULE, "esES",L)


    
  L = {
	["Invites"] = {
		--[[Translation missing --]]
		["Enable Alt-Invite"] = "Enable Alt-Invite",
		--[[Translation missing --]]
		["Enable Invite Links"] = "Enable Invite Links",
		--[[Translation missing --]]
		["module_desc"] = "Options for easy inviting of players to groups",
		--[[Translation missing --]]
		["module_name"] = "Invites",
		--[[Translation missing --]]
		["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."] = "Toggle group invites by alt-clicking hyperlinked keywords like 'invite'.",
		--[[Translation missing --]]
		["Toggle group invites by alt-clicking on player name."] = "Toggle group invites by alt-clicking on player name.",
	}
}


      PL:AddLocale(PRAT_MODULE, "zhTW",L)


    end
    --@end-non-debug@

    Prat:SetModuleOptions(module, {
        name = PL.module_name,
        desc = PL.module_desc,
        type = "group",
        args = {
            altinvite = {
                name = PL["Enable Alt-Invite"],
                desc = PL["Toggle group invites by alt-clicking on player name."],
                type = "toggle",
                order = 151,
            },
            linkinvite = {
                name = PL["Enable Invite Links"],
                desc = PL["Toggle group invites by alt-clicking hyperlinked keywords like 'invite'."],
                type = "toggle",
                order = 152,
            },
        }
    })


    Prat:SetModuleDefaults(module.name, {
        profile = {
            on = true,
            altinvite = true,
            linkinvite = true,
        }
    })

    function module:OnModuleEnable()
        self:SetAltInvite()

        Prat.RegisterLinkType({ linkid = "invplr", linkfunc = self.Invite_Link, handler = self }, self.name)
        Prat.RegisterLinkType({ linkid = "player", linkfunc = self.Player_Link, handler = self }, self.name)
    end

    function module:OnValueChanged(info, b)
        local field = info[#info]
        if field == "altinvite" or field == "linkinvite" then
            self:SetAltInvite()
        end
    end


    function module:SetAltInvite()
        if (self.db.profile.altinvite) then
            self:SecureHook("SetItemRef")
        else
            self:Unhook("SetItemRef")
        end
    end

    local EVENTS_FOR_INVITE = {
        ["CHAT_MSG_GUILD"] = true,
        ["CHAT_MSG_OFFICER"] = true,
        ["CHAT_MSG_PARTY"] = true,
        ["CHAT_MSG_RAID"] = true,
        ["CHAT_MSG_RAID_LEADER"] = true,
        ["CHAT_MSG_RAID_WARNING"] = true,
        ["CHAT_MSG_SAY"] = true,
        ["CHAT_MSG_YELL"] = true,
        ["CHAT_MSG_WHISPER"] = true,
        ["CHAT_MSG_CHANNEL"] = true,
    }

    local function Invite(text, ...)
        if module.db.profile.linkinvite then
            return module:ScanForLinks(text, Prat.SplitMessage.PLAYERLINK)
        end
    end

    local INVALID_NAMES = {
        ["meh"] = true,
        ["now"] = true,
        ["plz"] = true,
        ["pls"] = true,
        ["please"] = true,
        ["when"] = true,
        ["group"] = true,
        ["raid"] = true,
        ["grp"] = true,
    }

    local INVALID_NAME_REFERENCE = {
        ["him"] = true,
        ["her"] = true,
        ["them"] = true,
        ["someone"] = true,
    }

    local function InviteSomone(text, name)
        if module.db.profile.linkinvite and name then
            name = name:lower() -- TODO Use UTF8Lib
            if name:len() > 2 and not INVALID_NAMES[name] then
                if INVALID_NAME_REFERENCE[name] then
                    return Prat:RegisterMatch(text)
                else
                    return module:ScanForLinks(text, name)
                end
            end
        end
    end


    Prat:SetModulePatterns(module, {
        { pattern = "(send%s+invite%s+to%s+" .. Prat.AnyNamePattern .. ")", matchfunc = InviteSomone },
        { pattern = "(invi?t?e?%s+" .. Prat.AnyNamePattern .. ")", matchfunc = InviteSomone },
        { pattern = "(" .. Prat.GetNamePattern("invites?%??") .. ")", matchfunc = Invite },
        { pattern = "(" .. Prat.GetNamePattern("inv%??") .. ")", matchfunc = Invite },
        { pattern = "(초대)", matchfunc = Invite },
        { pattern = "(組%??)$", matchfunc = Invite },
        { pattern = "(組我%??)$", matchfunc = Invite },
    })

    function module:Invite_Link(link, text, button, ...)
        if self.db.profile.linkinvite then
            local name = strsub(link, 8);
            if (name and (strlen(name) > 0)) then
                local begin = string.find(name, "%s[^%s]+$");
                if (begin) then
                    name = strsub(name, begin + 1);
                end

                InviteUnit(name);
            end
        end

        return false
    end

    function module:SetItemRef(link, ...)
        if (strsub(link, 1, 6) == "player") then
            self:Player_Link(link, ...)
        end
    end

    function module:Player_Link(link, text, button, ...)
        if self.db.profile.altinvite then
            local name = strsub(link, 8);
            if (name and (strlen(name) > 0)) then
                local begin, nend = string.find(name, "%s*[^%s:]+");
                if (begin) then
                    name = strsub(name, begin, nend);
                end
                if (IsAltKeyDown()) then
                    InviteUnit(name);
                    if ChatEdit_GetActiveWindow() then
                        ChatEdit_OnEscapePressed(ChatEdit_GetActiveWindow())
                    end
                    return false;
                end
            end
        end

        return true
    end

    function module:ScanForLinks(text, name)
        if text == nil then
            return ""
        end

        local enabled = self.db.profile.linkinvite

        if enabled and CanGroupInvite() then
            if Prat.CurrentMessage then
                if EVENTS_FOR_INVITE[Prat.CurrentMessage.EVENT] then
                    return self:InviteLink(text, name)
                end
            end
        end

        return text
    end

    function module:InviteLink(link, name)
        return Prat:RegisterMatch(("|cff%s|Hinvplr:%s|h[%s]|h|r"):format("ffff00", name, link))
    end
end)