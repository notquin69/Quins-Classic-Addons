UIPanelWindows["Notebook"] = { area = "left", pushable = 5 };



SLASH_NOTEBOOK1 = "/notebook"
SLASH_NOTEBOOK2 = "/nb"
SlashCmdList["NOTEBOOK"] = function(msg)
	ShowUIPanel(Notebook)
end



local MyAddonName, _ = ...

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:HookScript("OnEvent", function(self, event, arg1, ...)
	if event == "ADDON_LOADED" and arg1 == MyAddonName then
		if NotebookDB == nil then
			Notebook_Init()
		end
		Notebook_GoToPage(NotebookDB.currentPage)
		Notebook:SetScript("OnUpdate", Notebook_OnUpdate)
	end
end)



local debug = false

function Notebook_Init()
	if debug then print("Notebook_Init") end
	NotebookDB = {}
	NotebookDB.currentPage = 1
	NotebookDB.pages = {}
	NotebookDB.bookmarks = {}
	tinsert(NotebookDB.pages, "") -- first page, blank
	if debug then print(NotebookDB.pages) end
end
function Notebook_SaveTextForPage(pageIndex, text)
	if debug then print("Notebook_SaveTextForPage", pageIndex) end
	NotebookDB.pages[pageIndex] = text
end
function Notebook_GoToPage(pageIndex)
	if debug then print("Notebook_GoToPage", pageIndex) end

	if NotebookDB.pages[pageIndex] == nil then
		tinsert(NotebookDB.pages, pageIndex, "") -- for now, we just make new pages whenever we need to
	end

	NotebookDB.currentPage = pageIndex
	Notebook_OnPageChanged(Notebook)
end
function Notebook_GoToNextPage()
	if debug then print("Notebook_GoToNextPage") end
	local pageIndexChanged = false
	local canGoToNextPage, nextPageIndex = Notebook_CanGoToNextPage()
	if canGoToNextPage then
		Notebook_GoToPage(nextPageIndex)
		pageIndexChanged = true
	end
	return pageIndexChanged
end
function Notebook_CanGoToNextPage()
	local lastPageIndex = max(1, #NotebookDB.pages)
	local nextPageIndex = NotebookDB.currentPage + 1
	local canGoToNextPage = (nextPageIndex <= lastPageIndex)
	return true, nextPageIndex -- can always go to next page, since it creates a new page
end
function Notebook_GoToPreviousPage()
	if debug then print("Notebook_GoToPreviousPage") end
	local pageIndexChanged = false
	local canGoToPreviousPage, previousPageIndex = Notebook_CanGoToPreviousPage()
	if canGoToPreviousPage then
		Notebook_GoToPage(previousPageIndex)
		pageIndexChanged = true
	end
	return pageIndexChanged
end
function Notebook_CanGoToPreviousPage()
	local firstPageIndex = 1
	local previousPageIndex =  NotebookDB.currentPage - 1
	local canGoToPreviousPage = (previousPageIndex >= firstPageIndex)
	return canGoToPreviousPage, previousPageIndex
end


function Notebook_OnLoad(self)
	if debug then print("Notebook_OnLoad") end
	SetPortraitToTexture(self.portrait, "Interface\\Spellbook\\Spellbook-Icon")
	self.TitleText:SetText("Notebook")
	self.doneButton:SetEnabled(self.editBox:HasFocus())
	--ButtonFrameTemplate_HideButtonBar(self)
	--ButtonFrameTemplate_HideAttic(self)
	--self.Inset.Bg:SetTexture("Interface\\QuestFrame\\QuestBG")
end
function Notebook_OnUpdate(self, elapsed)
	--if true then return end
	-- any mouse click anywhere else will remove focus from edit box
	isDown = IsMouseButtonDown("LeftButton") or IsMouseButtonDown("RightButton")
	if not self:IsMouseOver() and isDown then
		self.editBox:ClearFocus()
	end
end
function Notebook_OnShow(self)
	if debug then print("Notebook_OnShow") end
	PlaySound(SOUNDKIT.IG_SPELLBOOK_OPEN)
	NotebookPreviousPageButton:SetEnabled(Notebook_CanGoToPreviousPage())
	NotebookNextPageButton:SetEnabled(Notebook_CanGoToNextPage())
end
function Notebook_OnHide(self)
	if debug then print("Notebook_OnHide") end
	PlaySound(SOUNDKIT.IG_SPELLBOOK_CLOSE)
end
function Notebook_OnMouseDown(self, button)
	if debug then print("Notebook_OnMouseDown", button) end
	self.editBox:ClearFocus()
end
function Notebook_OnMouseWheel(self, direction)
	if debug then print("Notebook_OnMouseWheel", direction) end
	if direction > 0 and Notebook_CanGoToPreviousPage() then
		NotebookPreviousPageButton_OnClick()
	elseif direction < 0 and Notebook_CanGoToNextPage() then
		NotebookNextPageButton_OnClick()
	end
end
function Notebook_OnPageChanged(self)
	if debug then print("Notebook_OnPageChanged") end
	self.editBox:SetText(NotebookDB.pages[NotebookDB.currentPage])
	NotebookPreviousPageButton:SetEnabled(Notebook_CanGoToPreviousPage())
	NotebookNextPageButton:SetEnabled(Notebook_CanGoToNextPage())
	self.editBox:ClearFocus()
	self.pageNumber:SetText(NotebookDB.currentPage)
end


function NotebookEditBox_OnTextChanged(self)
	--if debug then print("NotebookEditBox_OnTextChanged") end
	Notebook_SaveTextForPage(NotebookDB.currentPage, self:GetText())
end
function NotebookEditBox_OnEditFocusGained(self)
	if debug then print("NotebookEditBox_OnEditFocusGained") end
	Notebook.doneButton:SetEnabled(self:HasFocus())
end
function NotebookEditBox_OnEditFocusLost(self)
	if debug then print("NotebookEditBox_OnEditFocusLost") end
	Notebook.doneButton:SetEnabled(self:HasFocus())
end



function NotebookPreviousPageButton_OnClick()
	if debug then print("NotebookPreviousPageButton_OnClick") end
	Notebook_GoToPreviousPage()
	PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN)
end
function NotebookNextPageButton_OnClick()
	if debug then print("NotebookNextPageButton_OnClick") end
	Notebook_GoToNextPage()
	PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN)
end

function NotebookDoneButton_OnClick()
	--print("NotebookDoneButton_OnClick")
	Notebook.editBox:ClearFocus()
end