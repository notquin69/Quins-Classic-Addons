-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local DBViewer = TSM.UI:NewPackage("DBViewer")
local private = {
	frame = nil,
	frameContext = nil,
	dividedContainerContext = nil,
	selectedDBName = nil,
}
local DEFAULT_FRAME_CONTEXT = {
	width = 900,
	height = 600,
	centerX = 500,
	centerY = 0,
	scale = 1,
}
local MIN_FRAME_SIZE = {
	width = 900,
	height = 600
}
local DEFAULT_DIVIDED_CONTAINER_CONTEXT = {
	leftWidth = 200,
}



-- ============================================================================
-- Module Functions
-- ============================================================================

function DBViewer.OnInitialize()
	private.frameContext = CopyTable(DEFAULT_FRAME_CONTEXT)
	private.dividedContainerContext = CopyTable(DEFAULT_DIVIDED_CONTAINER_CONTEXT)
end

function DBViewer.OnDisable()
	-- hide the frame
	if private.frame then
		DBViewer.Toggle()
	end
end

function DBViewer.Toggle()
	if not private.frame then
		private.frame = private.CreateMainFrame()
		private.frame:Draw()
		private.frame:Show()
	else
		private.frame:Hide()
		assert(not private.frame)
	end
end



-- ============================================================================
-- UI Functions
-- ============================================================================

function private.CreateMainFrame()
	private.selectedDBName = nil
	return TSMAPI_FOUR.UI.NewElement("ApplicationFrame", "base")
		:SetTextureSet("SMALL", "SMALL")
		:SetParent(UIParent)
		:SetMinResize(MIN_FRAME_SIZE.width, MIN_FRAME_SIZE.height)
		:SetContextTable(private.frameContext, DEFAULT_FRAME_CONTEXT)
		:SetStyle("strata", "HIGH")
		:SetTitle("TSM DB Viewer")
		:SetScript("OnHide", private.FrameOnHide)
		:SetContentFrame(TSMAPI_FOUR.UI.NewElement("DividedContainer", "container")
			:SetStyle("background", "#000000")
			:SetContextTable(private.dividedContainerContext, DEFAULT_DIVIDED_CONTAINER_CONTEXT)
			:SetMinWidth(100, 100)
			:SetLeftChild(TSMAPI_FOUR.UI.NewElement("ScrollFrame", "left")
				:AddChildrenWithFunction(private.AddTableRows)
			)
			:SetRightChild(TSMAPI_FOUR.UI.NewElement("Frame", "right")
				:SetLayout("VERTICAL")
			)
		)
end

function private.AddTableRows(frame)
	for _, name in TSM.Database.InfoNameIterator() do
		frame:AddChild(TSMAPI_FOUR.UI.NewElement("Button", "nav_"..name)
			:SetStyle("height", 20)
			:SetStyle("margin", { left = 4, right = 4 })
			:SetStyle("highlight", "#669d9d9d")
			:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
			:SetStyle("fontHeight", 12)
			:SetStyle("justifyH", "LEFT")
			:SetStyle("textColor", "#ffffff")
			:SetText(name)
			:SetScript("OnClick", private.NavButtonOnClick)
		)
	end
end

function private.CreateTableContent()
	local contentFrame = private.frame:GetElement("container.right")
	contentFrame:ReleaseAllChildren()
	contentFrame:AddChild(TSMAPI_FOUR.UI.NewElement("TabGroup", "tabs")
		:SetNavCallback(private.ContentNavCallback)
		:AddPath("Structure", true)
		:AddPath("Browse")
	)
	contentFrame:Draw()
end

function private.ContentNavCallback(_, path)
	if path == "Structure" then
		return private.CreateStructureFrame()
	elseif path == "Browse" then
		return private.CreateBrowseFrame()
	else
		error("Invalid path: "..tostring(path))
	end
end

function private.CreateStructureFrame()
	local query = TSM.Database.CreateInfoFieldQuery(private.selectedDBName)
		:OrderBy("order", true)
	return TSMAPI_FOUR.UI.NewElement("Frame", "structure")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "info")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:SetStyle("margin", 4)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "numRows")
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 14)
				:SetStyle("justifyH", "LEFT")
				:SetStyle("textColor", "#ffffff")
				:SetText("Total Rows: "..TSM.Database.GetNumRows(private.selectedDBName))
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "numRows")
				:SetStyle("font", TSM.UI.Fonts.MontserratRegular)
				:SetStyle("fontHeight", 14)
				:SetStyle("justifyH", "LEFT")
				:SetStyle("textColor", "#ffffff")
				:SetText("Active Queries: "..TSM.Database.GetNumActiveQueries(private.selectedDBName))
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "table")
			:SetStyle("headerBackground", "#404040")
			:SetStyle("headerFontHeight", 12)
			:GetScrollingTableInfo()
				:NewColumn("order")
					:SetTitles("#")
					:SetWidth(20)
					:SetFont(TSM.UI.Fonts.FRIZQT)
					:SetFontHeight(12)
					:SetJustifyH("LEFT")
					:SetTextInfo("order")
					:SetSortInfo("order")
					:Commit()
				:NewColumn("field")
					:SetTitles("Name")
					:SetFont(TSM.UI.Fonts.FRIZQT)
					:SetFontHeight(12)
					:SetJustifyH("LEFT")
					:SetTextInfo("field")
					:SetSortInfo("field")
					:Commit()
				:NewColumn("type")
					:SetTitles("Type")
					:SetWidth(60)
					:SetFont(TSM.UI.Fonts.FRIZQT)
					:SetFontHeight(12)
					:SetJustifyH("LEFT")
					:SetTextInfo("type")
					:SetSortInfo("type")
					:Commit()
				:NewColumn("attributes")
					:SetTitles("Attributes")
					:SetWidth(80)
					:SetFont(TSM.UI.Fonts.FRIZQT)
					:SetFontHeight(12)
					:SetJustifyH("LEFT")
					:SetTextInfo("attributes")
					:SetSortInfo("attributes")
					:Commit()
				:Commit()
			:SetQuery(query)
			:SetAutoReleaseQuery(true)
			:SetSelectionDisabled(true)
		)
end

function private.CreateBrowseFrame()
	local query = TSM.Database.CreateDBQuery(private.selectedDBName)
	local frame = TSMAPI_FOUR.UI.NewElement("Frame", "browse")
		:SetLayout("VERTICAL")
		:AddChild(TSMAPI_FOUR.UI.NewElement("Input", "queryInput")
			:SetStyle("height", 26)
			:SetStyle("margin", 8)
			:SetStyle("background", "#525252")
			:SetStyle("border", "#9d9d9d")
			:SetStyle("borderSize", 2)
			:SetStyle("fontHeight", 11)
			:SetStyle("textColor", "#e2e2e2")
			:SetText("query")
			:SetScript("OnEnterPressed", private.QueryInputOnEnterPressed)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("QueryScrollingTable", "table")
			:SetStyle("headerBackground", "#404040")
			:SetStyle("headerFontHeight", 8)
			:SetStyle("colSpacing", 8)
			:SetContext(query)
			:SetQuery(query)
			:SetAutoReleaseQuery(true)
			:SetSelectionDisabled(true)
		)

	local tableElement = frame:GetElement("table")
	local stInfo = tableElement:GetScrollingTableInfo()
	local fieldQuery = TSM.Database.CreateInfoFieldQuery(private.selectedDBName)
		:Select("field")
		:OrderBy("order", true)
	local numFields = fieldQuery:Count()
	local width = (600 - (numFields * 8)) / numFields
	local isFirst = true
	for _, field in fieldQuery:Iterator() do
		stInfo:NewColumn(field)
			:SetTitles(field)
			:SetWidth(not isFirst and width or nil)
			:SetFont(TSM.UI.Fonts.FRIZQT)
			:SetFontHeight(10)
			:SetJustifyH("LEFT")
			:SetTextInfo(field, tostring)
			:SetTooltipInfo(field, private.TooltipFunc)
			:Commit()
		isFirst = false
	end
	fieldQuery:Release()
	stInfo:Commit()

	return frame
end



-- ============================================================================
-- Local Script Handlers
-- ============================================================================

function private.FrameOnHide(frame)
	assert(frame == private.frame)
	private.frame:Release()
	private.frame = nil
end

function private.NavButtonOnClick(button)
	local navFrame = button:GetParentElement()
	private.selectedDBName = button:GetText()
	for _, name in TSM.Database.InfoNameIterator() do
		navFrame:GetElement("nav_"..name)
			:SetStyle("textColor", name == private.selectedDBName and "#79a2ff" or "#ffffff")
			:Draw()
	end
	private.CreateTableContent()
end

function private.QueryInputOnEnterPressed(input)
	local func, errStr = loadstring(input:GetText())
	if not func then
		TSM:Printf("Failed to compile code: "..errStr)
		return
	end
	local tableElement = input:GetElement("__parent.table")
	local query = tableElement:GetContext()
	query:Reset()
	setfenv(func, { query = query })
	local ok, funcErrStr = pcall(func)
	if not ok then
		TSM:Printf("Failed to execute code: "..funcErrStr)
		return
	end
	tableElement:UpdateData(true)
end



-- ============================================================================
-- Private Helper Functions
-- ============================================================================

function private.TooltipFunc(value)
	value = tostring(value)
	if strmatch(value, "item:") or strmatch(value, "battlepet:") or strmatch(value, "[ip]:") then
		-- this is an item string or item link
		return value
	else
		return "Value: "..value
	end
end
