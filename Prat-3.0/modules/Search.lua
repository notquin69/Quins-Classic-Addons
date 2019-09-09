Prat:AddModuleToLoad(function()
    local PRAT_MODULE = Prat:RequestModuleName("Search")

    if PRAT_MODULE == nil then
        return
    end

    local module = Prat:NewModule(PRAT_MODULE)

    local PL = module.PL

    --[===[@debug@
    PL:AddLocale(PRAT_MODULE, "enUS", {
        module_name = "Search",
        module_desc = "Adds the ability to search the chatframes.",
        module_info = "This module adds the /find and /findall commands to search the chat history\n\nUsage:\n\n /find <text> \n\n /findall <text>",
        err_tooshort = "Search term is too short",
        err_notfound = "Not Found",
        find_results = "Find Results:",
    })
    --@end-debug@]===]

    -- These Localizations are auto-generated. To help with localization
    -- please go to http://www.wowace.com/projects/prat-3-0/localization/
    --@non-debug@
   do
       local L

   
L = {
	["Search"] = {
		["err_notfound"] = "Not Found",
		["err_tooshort"] = "Search term is too short",
		["find_results"] = "Find Results:",
		["module_desc"] = "Adds the ability to search the chatframes.",
		["module_info"] = [=[This module adds the /find and /findall commands to search the chat history

Usage:

 /find <text> 

 /findall <text>]=],
		["module_name"] = "Search",
	}
}


     PL:AddLocale(PRAT_MODULE, "enUS",L)

   
L = {
	["Search"] = {
		--[[Translation missing --]]
		["err_notfound"] = "Not Found",
		--[[Translation missing --]]
		["err_tooshort"] = "Search term is too short",
		["find_results"] = "Résultats trouvés :",
		--[[Translation missing --]]
		["module_desc"] = "Adds the ability to search the chatframes.",
		--[[Translation missing --]]
		["module_info"] = [=[This module adds the /find and /findall commands to search the chat history

Usage:

 /find <text> 

 /findall <text>]=],
		--[[Translation missing --]]
		["module_name"] = "Search",
	}
}


     PL:AddLocale(PRAT_MODULE, "frFR",L)

   
L = {
	["Search"] = {
		["err_notfound"] = "Nicht gefunden",
		["err_tooshort"] = "Suchbegriff ist zu kurz",
		["find_results"] = "Gefundene Ergebnisse:",
		["module_desc"] = [=[Aktiviert die Suchfunktion in Chatfenstern.

Suche]=],
		["module_info"] = [=[Aktiviert die Textbefehle /find und /findall, um die Chathistorie zu durchsuchen

Benutzung:

/find <text>

/findall <text>

Suche]=],
		["module_name"] = "Suche",
	}
}


     PL:AddLocale(PRAT_MODULE, "deDE",L)

   
L = {
	["Search"] = {
		["err_notfound"] = "찾을 수 없음",
		["err_tooshort"] = "검색 구문이 너무 짧습니다",
		["find_results"] = "검색 결과:",
		["module_desc"] = "대화창 검색 기능을 추가합니다.",
		["module_info"] = [=[이 모듈은 대화 기록을 검색하는 /find 와 /findall 명령어를 추가합니다

사용법:

/find <문자열>

/findall <문자열>]=],
		["module_name"] = "검색",
	}
}


     PL:AddLocale(PRAT_MODULE, "koKR",L)

   
L = {
	["Search"] = {
		--[[Translation missing --]]
		["err_notfound"] = "Not Found",
		--[[Translation missing --]]
		["err_tooshort"] = "Search term is too short",
		--[[Translation missing --]]
		["find_results"] = "Find Results:",
		--[[Translation missing --]]
		["module_desc"] = "Adds the ability to search the chatframes.",
		--[[Translation missing --]]
		["module_info"] = [=[This module adds the /find and /findall commands to search the chat history

Usage:

 /find <text> 

 /findall <text>]=],
		--[[Translation missing --]]
		["module_name"] = "Search",
	}
}


     PL:AddLocale(PRAT_MODULE, "esMX",L)

   
L = {
	["Search"] = {
		["err_notfound"] = "Не Найденно",
		["err_tooshort"] = "Критерий поиска слишком короток",
		["find_results"] = "Найти Результаты:",
		["module_desc"] = "Добавляет возможность поиска текста в чате.",
		["module_info"] = [=[Этот модуль добавляет команды /find и /findall для поиска в истории чата

Использование:

/find <текст>

/findall <текст>]=],
		["module_name"] = "Поиск",
	}
}


     PL:AddLocale(PRAT_MODULE, "ruRU",L)

   
L = {
	["Search"] = {
		["err_notfound"] = "没找到",
		["err_tooshort"] = "搜索文字太短",
		["find_results"] = "查找结果：",
		["module_desc"] = "增加搜索聊天框的能力",
		["module_info"] = [=[此模块增加 /find 和 /findall 命令搜索聊天历史

用法:

 /find <文字>

 /findall <文字>]=],
		["module_name"] = "搜索",
	}
}


     PL:AddLocale(PRAT_MODULE, "zhCN",L)

   
L = {
	["Search"] = {
		["err_notfound"] = "No encontrado",
		["err_tooshort"] = "Termino de búsqueda demasiado corto",
		--[[Translation missing --]]
		["find_results"] = "Find Results:",
		--[[Translation missing --]]
		["module_desc"] = "Adds the ability to search the chatframes.",
		--[[Translation missing --]]
		["module_info"] = [=[This module adds the /find and /findall commands to search the chat history

Usage:

 /find <text> 

 /findall <text>]=],
		--[[Translation missing --]]
		["module_name"] = "Search",
	}
}


     PL:AddLocale(PRAT_MODULE, "esES",L)

   
L = {
	["Search"] = {
		["err_notfound"] = "找不到",
		["err_tooshort"] = "尋找物品太短",
		["find_results"] = "找到結果:",
		--[[Translation missing --]]
		["module_desc"] = "Adds the ability to search the chatframes.",
		--[[Translation missing --]]
		["module_info"] = [=[This module adds the /find and /findall commands to search the chat history

Usage:

 /find <text> 

 /findall <text>]=],
		["module_name"] = "尋找",
	}
}


     PL:AddLocale(PRAT_MODULE, "zhTW",L)

   end
   --@end-non-debug@




    Prat:SetModuleDefaults(module.name, {
        profile = {
            on = true,
        }
    } )

    
    Prat:SetModuleOptions(module.name, {
        name = PL.module_name,
        desc = PL.module_desc,
        type = "group",
        args = {
            info = {
                name = PL.module_info,
                type = "description",
            }
        }
    })


    SLASH_FIND1 = "/find"
    SlashCmdList["FIND"] = function(msg) module:Find(msg, false) end

    SLASH_FINDALL1 = "/findall"
    SlashCmdList["FINDALL"] = function(msg) module:Find(msg, true) end

    local MAX_SCRAPE_TIME = 30
    local foundlines = {}
    local scrapelines = {}

    local function out(frame, msg)
        frame:print(frame, msg)
    end

    function module:Find(word, all, frame)
        if not self.db.profile.on then
            return
        end

        if frame == nil then
            frame = SELECTED_CHAT_FRAME
        end

        if not word then return end

        if #word <= 1 then
            frame:ScrollToBottom()
            out(frame, PL.err_tooshorL)
            return
        end

        if frame:GetNumMessages() == 0 then
             out(frame, PL.err_notfound)
             return
        end

        local starttime = time()
        local runtime = 0

        if not all and self.lastsearch == word then
            frame:PageUp()
        end

        if all then
            frame:ScrollToBottom()
        end

        self.lastsearch = word

        repeat
            self:ScrapeFrame(frame, nil, true)

            for _,v in ipairs(scrapelines) do
                if v.message:find(word) then
                    if all then
                        table.insert(foundlines, v)
                    else
                        return
                    end
                end
            end

            frame:PageUp()
            runtime = time() - starttime
            if runtime >= MAX_SCRAPE_TIME then
                out(frame, "Frame scraping timeout exceeded, results will be incomplete.")
                break;
            end

        until frame:AtTop() or runtime >= MAX_SCRAPE_TIME

        self.lastsearch = nil

        frame:ScrollToBottom()

        if all and #foundlines > 0 then
            out(frame, PL.find_results)

            Prat.loading = true
            for _,v in ipairs(foundlines) do
                frame:AddMessage(v.message, v.r, v.g, v.b)
            end
            Prat.loading = nil

        else
            out(frame, PL.err_notfound)
        end

        wipe(foundlines)
    end

    function module:ScrapeFrame(frame)
        wipe(scrapelines)

        for _,v in ipairs(frame.visibleLines) do
            local msg = v.messageInfo
            if msg then
                table.insert(scrapelines, 1, msg)
            end
        end
    end

    return
end) -- Prat:AddModuleToLoad