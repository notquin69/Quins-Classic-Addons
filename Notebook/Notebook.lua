local AddonName, Addon = ...

Addon.debug = false

function Addon:NotebookDB_Init(notebookName)
	if Addon.debug then print("Notebook:", "NotebookDB_Init", notebookName) end
	_G[notebookName] = {}
	local notebook = _G[notebookName]
	notebook.currentPage = 1
	notebook.pages = {}
	tinsert(notebook.pages, "") -- first page, blank
	notebook.bookmarks = {}
	notebook.font = MailTextFontNormal:GetName()
	if Addon.debug then print(notebook.pages) end
end
local function NotebookDB_TrimEmptyTrailingPages(notebook)
	if Addon.debug then print("Notebook:", "NotebookDB_TrimEmptyPages", notebook) end
	local pagesBeforeTrimming = #notebook.pages -- debug
	-- reverse iterate (last pages first)
	for i = #notebook.pages, 1, -1 do
		local text = notebook.pages[i]
		local textIsEmpty = not text or text:match("%S") == nil
		if not textIsEmpty then
			break -- encountered first non-empty page, so we're done with trailing pages
		end
		tremove(notebook.pages, i)
		if Addon.debug then print("Notebook:", "removed empty page #"..i, text) end
	end
	if Addon.debug then print("Notebook:", "pages before/after trimming", pagesBeforeTrimming, "/", #notebook.pages) end
end
local function NotebookDB_SaveTextForPage(notebook, pageIndex, text)
	if Addon.debug then print("Notebook:", "NotebookDB_SaveTextForPage", notebook, pageIndex) end
	notebook.pages[pageIndex] = text
	NotebookDB_TrimEmptyTrailingPages(notebook)
end
local function NotebookDB_GoToPage(notebook, pageIndex)
	if Addon.debug then print("Notebook:", "NotebookDB_GoToPage", notebook, pageIndex) end
	if notebook.pages[pageIndex] == nil then
		tinsert(notebook.pages, pageIndex, "") -- for now, we just make new pages whenever we need to
	end
	notebook.currentPage = pageIndex
	NotebookDB_OnPageChanged(notebook, pageIndex)
end
local function NotebookDB_CanGoToNextPage(notebook)
	local lastPageIndex = max(1, #notebook.pages)
	local nextPageIndex = notebook.currentPage + 1
	local canGoToNextPage = (nextPageIndex <= lastPageIndex)
	return true, nextPageIndex -- can always go to next page, since it creates a new page
end
local function NotebookDB_GoToNextPage(notebook)
	if Addon.debug then print("Notebook:", "NotebookDB_GoToNextPage", notebook) end
	local pageIndexChanged = false
	local canGoToNextPage, nextPageIndex = NotebookDB_CanGoToNextPage(notebook)
	if canGoToNextPage then
		NotebookDB_GoToPage(notebook, nextPageIndex)
		pageIndexChanged = true
	end
	return pageIndexChanged
end
local function NotebookDB_CanGoToPreviousPage(notebook)
	local firstPageIndex = 1
	local previousPageIndex =  notebook.currentPage - 1
	local canGoToPreviousPage = (previousPageIndex >= firstPageIndex)
	return canGoToPreviousPage, previousPageIndex
end
local function NotebookDB_GoToPreviousPage(notebook)
	if Addon.debug then print("Notebook:", "NotebookDB_GoToPreviousPage", notebook) end
	local pageIndexChanged = false
	local canGoToPreviousPage, previousPageIndex = NotebookDB_CanGoToPreviousPage(notebook)
	if canGoToPreviousPage then
		NotebookDB_GoToPage(notebook, previousPageIndex)
		pageIndexChanged = true
	end
	return pageIndexChanged
end

function NotebookDB_OnPageChanged(notebook, pageIndex)
	if Addon.debug then print("Notebook:", "NotebookDB_OnPageChanged") end
	NotebookFrame.editBox:SetText(notebook.pages[pageIndex])
	NotebookFrame.editBox:ClearFocus()
	NotebookFrame.editBox:SetFontObject(_G[notebook.font])
	NotebookFrame.previousPageButton:SetEnabled(NotebookDB_CanGoToPreviousPage(notebook))
	NotebookFrame.nextPageButton:SetEnabled(NotebookDB_CanGoToNextPage(notebook))
	NotebookFrame.pageNumber:SetText(notebook.currentPage)
end

function NotebookFrame_OnLoad(self)
	if Addon.debug then print("Notebook:", "NotebookFrame_OnLoad") end
	UIPanelWindows["NotebookFrame"] = { area = "left", pushable = 5 };
	NotebookFrame_InitTabs(self)
	SetPortraitToTexture(self.portrait, "Interface\\Spellbook\\Spellbook-Icon")
	self.TitleText:SetText("Notebook")
	self.doneButton:SetEnabled(self.editBox:HasFocus())
	--ButtonFrameTemplate_HideButtonBar(self)
	--ButtonFrameTemplate_HideAttic(self)
	--self.Inset.Bg:SetTexture("Interface\\QuestFrame\\QuestBG")
end
function NotebookFrame_OnUpdate(self, elapsed)
	-- any mouse click anywhere else will remove focus from edit box
	local isDown = IsMouseButtonDown("LeftButton") or IsMouseButtonDown("RightButton")
	if not self:IsMouseOver() and isDown then
		self.editBox:ClearFocus()
	end
end
function NotebookFrame_OnShow(self)
	if Addon.debug then print("Notebook:", "NotebookFrame_OnShow") end
	NotebookFrame:SetScript("OnUpdate", NotebookFrame_OnUpdate)
	NotebookFrameTab_OnClick(self.characterTab) -- chooses tab (i.e. notebook) & sends OnPageChanged, which loads page text
	PlaySound(SOUNDKIT.IG_SPELLBOOK_OPEN)
	self.previousPageButton:SetEnabled(NotebookDB_CanGoToPreviousPage(self.notebook))
	self.nextPageButton:SetEnabled(NotebookDB_CanGoToNextPage(self.notebook))
end
function NotebookFrame_OnHide(self)
	if Addon.debug then print("Notebook:", "NotebookFrame_OnHide") end
	NotebookFrame:SetScript("OnUpdate", nil)
	PlaySound(SOUNDKIT.IG_SPELLBOOK_CLOSE)
end
function NotebookFrame_OnMouseDown(self, button)
	if Addon.debug then print("Notebook:", "NotebookFrame_OnMouseDown", button) end
	self.editBox:ClearFocus()
end
function NotebookFrame_OnMouseWheel(self, direction)
	if Addon.debug then print("Notebook:", "NotebookFrame_OnMouseWheel", direction) end
	if direction > 0 and NotebookDB_CanGoToPreviousPage(self.notebook) then
		NotebookFramePreviousPageButton_OnClick()
	elseif direction < 0 and NotebookDB_CanGoToNextPage(self.notebook) then
		NotebookFrameNextPageButton_OnClick()
	end
end

function NotebookFrameEditBox_OnTextChanged(self)
	if Addon.debug then print("Notebook:", "NotebookFrameEditBox_OnTextChanged") end
	local editBoxText = self:GetText()
	if editBoxText ~= NotebookFrame.notebook.pages[NotebookFrame.notebook.currentPage] then
		NotebookDB_SaveTextForPage(NotebookFrame.notebook, NotebookFrame.notebook.currentPage, editBoxText)
	end
end
function NotebookFrameEditBox_OnEditFocusGained(self)
	if Addon.debug then print("Notebook:", "NotebookFrameEditBox_OnEditFocusGained") end
	NotebookFrame.doneButton:SetEnabled(self:HasFocus())
end
function NotebookFrameEditBox_OnEditFocusLost(self)
	if Addon.debug then print("Notebook:", "NotebookFrameEditBox_OnEditFocusLost") end
	NotebookFrame.doneButton:SetEnabled(self:HasFocus())
end

function NotebookFramePreviousPageButton_OnClick(button)
	if Addon.debug then print("Notebook:", "NotebookFramePreviousPageButton_OnClick") end
	NotebookDB_GoToPreviousPage(NotebookFrame.notebook)
	PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN)
end
function NotebookFrameNextPageButton_OnClick(button)
	if Addon.debug then print("Notebook:", "NotebookFrameNextPageButton_OnClick") end
	NotebookDB_GoToNextPage(NotebookFrame.notebook)
	PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN)
end

function NotebookFrameDoneButton_OnClick(button)
	if Addon.debug then print("Notebook:", "NotebookFrameDoneButton_OnClick") end
	NotebookFrame.editBox:ClearFocus()
end

function NotebookFrameFontButton_OnClick(button)
	if NotebookFrame.editBox:GetFontObject() == GameFontNormal_NoShadow then
		NotebookFrame.notebook.font = MailTextFontNormal:GetName()
	else
		NotebookFrame.notebook.font = GameFontNormal_NoShadow:GetName()
	end
	NotebookFrame.editBox:SetFontObject(_G[NotebookFrame.notebook.font])
end
function NotebookFrameFontButton_OnEnter(button)
	button.text:SetFontObject(GameFontHighlightLarge)
end
function NotebookFrameFontButton_OnLeave(button)
	button.text:SetFontObject(GameFontNormalLarge)
end

function NotebookFrame_InitTabs(self)
	if Addon.debug then print("Notebook:", "NotebookFrame_InitTabs") end
	self.Tabs = { self.characterTab, self.generalTab }
	self.characterTab:SetText(UnitName("player").."'s Notebook")
	PanelTemplates_TabResize(self.characterTab, 0)
	self.generalTab:SetText("Notebook")
    PanelTemplates_TabResize(self.generalTab, 0)
    PanelTemplates_SetNumTabs(self, 2)
	PanelTemplates_SetTab(self, 1)
end
function NotebookFrameTab_OnClick(tabButton)
	if Addon.debug then print("Notebook:", "NotebookFrameTab_OnClick") end
    local tab = tabButton:GetID()
	PanelTemplates_SetTab(NotebookFrame, tab)
	if tab == 1 then
		NotebookFrame.notebook = NotebookDB
	elseif tab == 2 then
		NotebookFrame.notebook = NotebookDBGeneral
	else
		error("Got unknown tabID for notebookDB")
	end
	NotebookDB_OnPageChanged(NotebookFrame.notebook, NotebookFrame.notebook.currentPage)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end
