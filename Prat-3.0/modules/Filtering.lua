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

local PRAT_MODULE = Prat:RequestModuleName("Filtering")

if PRAT_MODULE == nil then 
    return 
end

local module = Prat:NewModule(PRAT_MODULE, "AceEvent-3.0")

local PL = module.PL

--[===[@debug@
PL:AddLocale(PRAT_MODULE, "enUS", {
	["Filtering"] = true,
	["A module to provide basic chat filtering."] = true,
    ["leavejoin_name"] = "Filter Channel Leave/Join",
    ["leavejoin_desc"] = "Filter out channel leave/join spam",
    ["notices_name"] = "Filter Channel Notices",
    ["notices_desc"] = "Filter out other custom channel notification messages, e.g. moderator changes.",
    ["bgjoin_name"] = "Filter BG Leave/Join",
    ["bgjoin_desc"] = "Filter out channel Battleground leave/join spam",
    ["tradespam_name"] = "Throttle Spam",
    ["tradespam_desc"] = "Throttle messages to prevent the same message from being repeated multiple times",
    ["afkdnd_name"] = "Throttle AFK and DND messages.",
    ["afkdnd_desc"] = "Throttle AFK and DND messages."
})
--@end-debug@]===]

-- These Localizations are auto-generated. To help with localization
-- please go to http://www.wowace.com/projects/prat-3-0/localization/


  --@non-debug@
do
    local L


L = {
	["Filtering"] = {
		["A module to provide basic chat filtering."] = true,
		["afkdnd_desc"] = "Throttle AFK and DND messages.",
		["afkdnd_name"] = "Throttle AFK and DND messages.",
		["bgjoin_desc"] = "Filter out channel Battleground leave/join spam",
		["bgjoin_name"] = "Filter BG Leave/Join",
		["Filtering"] = true,
		["leavejoin_desc"] = "Filter out channel leave/join spam",
		["leavejoin_name"] = "Filter Channel Leave/Join",
		["notices_desc"] = "Filter out other custom channel notification messages, e.g. moderator changes.",
		["notices_name"] = "Filter Channel Notices",
		["tradespam_desc"] = "Throttle messages to prevent the same message from being repeated multiple times",
		["tradespam_name"] = "Throttle Spam",
	}
}

PL:AddLocale(PRAT_MODULE, "enUS", L)



L = {
	["Filtering"] = {
		--[[Translation missing --]]
		["A module to provide basic chat filtering."] = "A module to provide basic chat filtering.",
		--[[Translation missing --]]
		["afkdnd_desc"] = "Throttle AFK and DND messages.",
		--[[Translation missing --]]
		["afkdnd_name"] = "Throttle AFK and DND messages.",
		--[[Translation missing --]]
		["bgjoin_desc"] = "Filter out channel Battleground leave/join spam",
		--[[Translation missing --]]
		["bgjoin_name"] = "Filter BG Leave/Join",
		--[[Translation missing --]]
		["Filtering"] = "Filtering",
		--[[Translation missing --]]
		["leavejoin_desc"] = "Filter out channel leave/join spam",
		--[[Translation missing --]]
		["leavejoin_name"] = "Filter Channel Leave/Join",
		--[[Translation missing --]]
		["notices_desc"] = "Filter out other custom channel notification messages, e.g. moderator changes.",
		--[[Translation missing --]]
		["notices_name"] = "Filter Channel Notices",
		--[[Translation missing --]]
		["tradespam_desc"] = "Throttle messages to prevent the same message from being repeated multiple times",
		--[[Translation missing --]]
		["tradespam_name"] = "Throttle Spam",
	}
}

PL:AddLocale(PRAT_MODULE, "itIT", L)



L = {
	["Filtering"] = {
		--[[Translation missing --]]
		["A module to provide basic chat filtering."] = "A module to provide basic chat filtering.",
		--[[Translation missing --]]
		["afkdnd_desc"] = "Throttle AFK and DND messages.",
		--[[Translation missing --]]
		["afkdnd_name"] = "Throttle AFK and DND messages.",
		--[[Translation missing --]]
		["bgjoin_desc"] = "Filter out channel Battleground leave/join spam",
		--[[Translation missing --]]
		["bgjoin_name"] = "Filter BG Leave/Join",
		--[[Translation missing --]]
		["Filtering"] = "Filtering",
		--[[Translation missing --]]
		["leavejoin_desc"] = "Filter out channel leave/join spam",
		--[[Translation missing --]]
		["leavejoin_name"] = "Filter Channel Leave/Join",
		--[[Translation missing --]]
		["notices_desc"] = "Filter out other custom channel notification messages, e.g. moderator changes.",
		--[[Translation missing --]]
		["notices_name"] = "Filter Channel Notices",
		--[[Translation missing --]]
		["tradespam_desc"] = "Throttle messages to prevent the same message from being repeated multiple times",
		--[[Translation missing --]]
		["tradespam_name"] = "Throttle Spam",
	}
}

PL:AddLocale(PRAT_MODULE, "ptBR", L)


L = {
	["Filtering"] = {
		["A module to provide basic chat filtering."] = "Un module pour fournir un filtrage basique",
		--[[Translation missing --]]
		["afkdnd_desc"] = "Throttle AFK and DND messages.",
		--[[Translation missing --]]
		["afkdnd_name"] = "Throttle AFK and DND messages.",
		["bgjoin_desc"] = "Filtrer les messages du canal Champ de bataille: \"quitte/rejoint\"",
		["bgjoin_name"] = "Filtrer BG quitte/rejoint",
		["Filtering"] = "Filtrage",
		["leavejoin_desc"] = "Filtrer les messages: \"quitte/rejoint le canal\"",
		["leavejoin_name"] = "Filtre Rejoindre/Quitte",
		--[[Translation missing --]]
		["notices_desc"] = "Filter out other custom channel notification messages, e.g. moderator changes.",
		["notices_name"] = "Notifications de filtrage",
		--[[Translation missing --]]
		["tradespam_desc"] = "Throttle messages to prevent the same message from being repeated multiple times",
		--[[Translation missing --]]
		["tradespam_name"] = "Throttle Spam",
	}
}

PL:AddLocale(PRAT_MODULE, "frFR",L)




L = {
	["Filtering"] = {
		["A module to provide basic chat filtering."] = "Ein Modul, welches das elementare Filtern von Chat ermöglicht.",
		["afkdnd_desc"] = "AFK- und DND-Mitteilungen unterdrücken",
		["afkdnd_name"] = "AFK- und DND-Mitteilungen unterdrücken",
		["bgjoin_desc"] = "Filtert bzw. entfernt Schlachtzugsverlassens- und -beitrittsnachrichten.",
		["bgjoin_name"] = "Filter BG Verlassen/Betreten",
		["Filtering"] = "Filtert",
		["leavejoin_desc"] = "Filtert bzw. entfernt Kanalbeitritts- und -verlassensnachrichten.",
		["leavejoin_name"] = "Filter Kanal Verlassen/Beitreten",
		["notices_desc"] = "Die allgemein üblichen Benachrichtigungen in Kanälen verhindern, z.B. Moderatorenwechsel.",
		["notices_name"] = "Kanal-Meldungen filtern",
		["tradespam_desc"] = "Begrenze die Nachrichten um zu verhindern das gleiche Nachrichten ständig wiederholt werden",
		["tradespam_name"] = "Spam begrenzen",
	}
}

PL:AddLocale(PRAT_MODULE, "deDE", L)


L = {
	["Filtering"] = {
		["A module to provide basic chat filtering."] = "대화 내용을 필터링하는 모듈입니다.",
		["afkdnd_desc"] = "자리비움과 다른 용무중 메시지를 조절합니다.",
		["afkdnd_name"] = "자리비움과 다른 용무중 메시지를 조절합니다.",
		["bgjoin_desc"] = "전장 채널 입장/퇴장 메시지를 숨깁니다.",
		["bgjoin_name"] = "전장 입장/퇴장 필터링",
		["Filtering"] = "필터링",
		["leavejoin_desc"] = "채널 입장/퇴장 메시지를 숨깁니다.",
		["leavejoin_name"] = "채널 입장/퇴장 필터링",
		["notices_desc"] = "사설 채널의 알림 메시지를 숨깁니다, ex. 관리자 변경.",
		["notices_name"] = "채널 알림 메시지 필터링",
		["tradespam_desc"] = "같은 메시지가 여러번 반복되지 않게 방지합니다.",
		["tradespam_name"] = "스팸 조절",
	}
}

PL:AddLocale(PRAT_MODULE, "koKR",L)

L = {
	["Filtering"] = {
		--[[Translation missing --]]
		["A module to provide basic chat filtering."] = "A module to provide basic chat filtering.",
		--[[Translation missing --]]
		["afkdnd_desc"] = "Throttle AFK and DND messages.",
		--[[Translation missing --]]
		["afkdnd_name"] = "Throttle AFK and DND messages.",
		--[[Translation missing --]]
		["bgjoin_desc"] = "Filter out channel Battleground leave/join spam",
		--[[Translation missing --]]
		["bgjoin_name"] = "Filter BG Leave/Join",
		--[[Translation missing --]]
		["Filtering"] = "Filtering",
		--[[Translation missing --]]
		["leavejoin_desc"] = "Filter out channel leave/join spam",
		--[[Translation missing --]]
		["leavejoin_name"] = "Filter Channel Leave/Join",
		--[[Translation missing --]]
		["notices_desc"] = "Filter out other custom channel notification messages, e.g. moderator changes.",
		--[[Translation missing --]]
		["notices_name"] = "Filter Channel Notices",
		--[[Translation missing --]]
		["tradespam_desc"] = "Throttle messages to prevent the same message from being repeated multiple times",
		--[[Translation missing --]]
		["tradespam_name"] = "Throttle Spam",
	}
}

PL:AddLocale(PRAT_MODULE, "esMX",L)

L = {
	["Filtering"] = {
		["A module to provide basic chat filtering."] = "Модуль для обеспечения базовый фильтрации чата.",
		["afkdnd_desc"] = "Заглушать сообщения AFK и DND.",
		["afkdnd_name"] = "Заглушать сообщения AFK и DND.",
		["bgjoin_desc"] = "Отфильтровывать сообщения входа и выхода на/из Поля Сражения (БГ)",
		["bgjoin_name"] = "Отфильтровывать вход/выход на ПС",
		["Filtering"] = "Фильтрование",
		["leavejoin_desc"] = "Отфильтровывать сообщения входа и выхода из/в канал.",
		["leavejoin_name"] = "Вход/выход в/из канала",
		["notices_desc"] = "Отфильтровывать извещения в каналах (такие как смета модератора и т.п.).",
		["notices_name"] = "Извещения в канале",
		["tradespam_desc"] = "Скрывать повторяющиеся сообщения",
		["tradespam_name"] = "Скрывать спам",
	}
}

PL:AddLocale(PRAT_MODULE, "ruRU",L)

L = {
	["Filtering"] = {
		["A module to provide basic chat filtering."] = "提供基础的聊天过滤的模块",
		["afkdnd_desc"] = "节流AFK和DND消息.",
		["afkdnd_name"] = "节流AFK和DND消息.",
		["bgjoin_desc"] = "过滤战场频道离开/加入信息",
		["bgjoin_name"] = "过滤战场出/入",
		["Filtering"] = "过滤",
		["leavejoin_desc"] = "滤掉频道离开/加入信息",
		["leavejoin_name"] = "过滤频道离开/加入",
		["notices_desc"] = "滤掉其他自定义频道通知信息,例如改变频道所有者",
		["notices_name"] = "频道通知过滤",
		["tradespam_desc"] = "节流消息以防止连续多次收到同样的消息",
		["tradespam_name"] = "屏蔽垃圾",
	}
}

PL:AddLocale(PRAT_MODULE, "zhCN",L)

L = {
	["Filtering"] = {
		["A module to provide basic chat filtering."] = "Un módulo que proporciona el filtrado básico del chat.",
		--[[Translation missing --]]
		["afkdnd_desc"] = "Throttle AFK and DND messages.",
		--[[Translation missing --]]
		["afkdnd_name"] = "Throttle AFK and DND messages.",
		["bgjoin_desc"] = "Filtrar en canal Campo de Batlla spam ha abandonado/se ha unido",
		["bgjoin_name"] = "Filtrar mensajes de unión/dejadas de Campos de Batalla",
		["Filtering"] = "Filtrado",
		["leavejoin_desc"] = "Filtrar en canal spam ha abandonado/se ha unido",
		["leavejoin_name"] = "Filtro de Canal  Ha abandonado / Se ha unido",
		["notices_desc"] = "Filtrar otros mensajes de notificación de canal personalizado, por ejemplo, los cambios de moderador.",
		["notices_name"] = "Filtrar Noticias del Canal",
		--[[Translation missing --]]
		["tradespam_desc"] = "Throttle messages to prevent the same message from being repeated multiple times",
		--[[Translation missing --]]
		["tradespam_name"] = "Throttle Spam",
	}
}

PL:AddLocale(PRAT_MODULE, "esES",L)

L = {
	["Filtering"] = {
		["A module to provide basic chat filtering."] = "模組：提供基本聊天過濾。",
		--[[Translation missing --]]
		["afkdnd_desc"] = "Throttle AFK and DND messages.",
		--[[Translation missing --]]
		["afkdnd_name"] = "Throttle AFK and DND messages.",
		["bgjoin_desc"] = "濾除戰場頻道離開/加入訊息",
		["bgjoin_name"] = "過濾戰場離開/參加",
		["Filtering"] = "過濾",
		["leavejoin_desc"] = "濾除頻道離開/加入訊息",
		["leavejoin_name"] = "過濾頻道離開/加入",
		["notices_desc"] = "濾除自訂頻道通知訊息，像是主持人變動",
		["notices_name"] = "過濾頻道通知",
		--[[Translation missing --]]
		["tradespam_desc"] = "Throttle messages to prevent the same message from being repeated multiple times",
		--[[Translation missing --]]
		["tradespam_name"] = "Throttle Spam",
	}
}

PL:AddLocale(PRAT_MODULE, "zhTW",L)
end
--@end-non-debug@



Prat:SetModuleDefaults(module, {
	profile = {
		on	= false,
	    leavejoin = true,
	    notices = true,
		tradespam = false,
        afkdnd = true,
	}
} )

Prat:SetModuleOptions(module, {
        name = PL["Filtering"] ,
        desc = PL["A module to provide basic chat filtering."],
        type = "group",
        args = {
--		    leavejoin = { 
--				name = PL["leavejoin_name"],
--				desc = PL["leavejoin_desc"],
--				type = "toggle",
--				order = 100 
--			},
		    notices = { 
				name = PL["notices_name"],
				desc = PL["notices_desc"],
				type = "toggle",
				order = 110 
			},
		    tradespam = { 
				name = PL["tradespam_name"],
				desc = PL["tradespam_desc"],
				type = "toggle",
				order = 115 
			},
            afkdnd = {
                name = PL["afkdnd_name"],
                desc = PL["afkdnd_desc"],
                type = "toggle",
                order = 115
            }

--		    bgjoin = { 
--				name = PL["bgjoin_name"],
--				desc = PL["bgjoin_desc"],
--				type = "toggle",
--				order = 111 
--			},	
        }
    }
)

local THROTTLE_TIME = 120
 
MessageTime = {}

local function cleanText(msg, author)
	local cleanmsg = msg:gsub("...hic!",""):gsub("%d",""):gsub("%c",""):gsub("%p",""):gsub("%s",""):upper():gsub("SH","S");
	return (author and author:upper() or "") .. cleanmsg;
end

--function tradeSpamFilter(frame, event, ...)
--    local arg1, arg2 = ...
--	local block = false;
--	local msg = cleanText(arg1, arg2);
--	
--	if arg2 == UnitName("player") then 
--		return false, ...
--	end
--
--	if MessageTime[msg] then
--		if difftime(time(), MessageTime[msg]) <= THROTTLE_TIME then
--			block = true;
--		else 
--		    MessageTime[msg] = nil 
--		end
--	else
--    	MessageTime[msg] = time();
--	end
--
--	if block then
--	    print("Filtered: "..msg)
--		return true
--	end
--
--    
--
--	return false, ...
--end

--[[------------------------------------------------
    Module Event Functions
------------------------------------------------]]--
function module:OnModuleEnable()
    self.throttleFrame = self.throttleFrame or CreateFrame("FRAME");
    
    self.throttle = THROTTLE_TIME
    
    self.throttleFrame:SetScript("OnUpdate", 
        function(frame, elapsed) 
            self.throttle = self.throttle - elapsed
            if frame:IsShown() and self.throttle < 0 then
                self.throttle = THROTTLE_TIME
                self:PruneMessages()
            end
        end)
    
--    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", tradeSpamFilter)
--    ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", tradeSpamFilter)
       
	Prat.RegisterChatEvent(self, "Prat_FrameMessage")
end

-- things to do when the module is disabled
function module:OnModuleDisable()
--    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", tradeSpamFilter)
--    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_YELL", tradeSpamFilter)


	Prat.UnregisterAllChatEvents(self)
end

--[[------------------------------------------------
    Core Functions
------------------------------------------------]]--

function module:GetDescription()
    return PL["A module to provide basic chat filtering."]
end

function module:PruneMessages()
    for k,v in pairs(MessageTime) do
        if difftime(time(), v) > THROTTLE_TIME then
            MessageTime[k] = nil
        end
    end
end




function module:Prat_FrameMessage(arg, message, frame, event)
    local newEvent = true
    if Prat.EVENT_ID and 
       Prat.EVENT_ID == self.lastevent and 
       self.lasteventtype == event then 
       newEvent = false
    end
     
    if self.db.profile.tradespam then
        if event == "CHAT_MSG_CHANNEL" or event == "CHAT_MSG_YELL" then          
        	local msg = cleanText(message.ORG.MESSAGE, message.ORG.PLAYER)

        	if message.ORG.PLAYER ~= UnitName("player") then     
            	if newEvent and MessageTime[msg] then
            		if difftime(time(), MessageTime[msg]) <= THROTTLE_TIME then            		  
            			message.DONOTPROCESS = true
            		else 
            		    MessageTime[msg] = nil 
            		end
            	else
      	            self.lasteventtype = event
                    self.lastevent = Prat.EVENT_ID
                	MessageTime[msg] = time();
            	end    
            end
        end
    end

    if self.db.profile.afkdnd then
        if event == "CHAT_MSG_AFK" or event == "CHAT_MSG_DND" then
        	local msg = cleanText(message.ORG.MESSAGE, message.ORG.PLAYER)

            if newEvent and MessageTime[msg] then
                if difftime(time(), MessageTime[msg]) <= THROTTLE_TIME then
                    message.DONOTPROCESS = true
                else
                    MessageTime[msg] = nil
                end
            else
                self.lasteventtype = event
                self.lastevent = Prat.EVENT_ID
                MessageTime[msg] = time();
            end
        end
    end



    if self.db.profile.notices then 
    	if  event == "CHAT_MSG_CHANNEL_NOTICE_USER" or event == "CHAT_MSG_CHANNEL_NOTICE"  then
    		message.DONOTPROCESS = true
    	end
    end
     
end

  return
end ) -- Prat:AddModuleToLoad