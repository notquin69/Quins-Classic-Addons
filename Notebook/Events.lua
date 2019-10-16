local AddonName, Addon = ...

Addon.Events = CreateFrame("Frame")
Addon.Events:RegisterEvent("ADDON_LOADED")
Addon.Events:SetScript("OnEvent", function(self, event, ...)
	if self[event] then
		self[event](self, ...)
	end
end)

function Addon.Events:ADDON_LOADED(name)
	if name == AddonName then
		if Addon.debug then print("Notebook:", "ADDON_LOADED") end
		if NotebookDB == nil then
			Addon:NotebookDB_Init("NotebookDB")
		end
		if NotebookDBGeneral == nil then
			Addon:NotebookDB_Init("NotebookDBGeneral")
		end
		NotebookFrame.notebook = NotebookDB
	end
end
