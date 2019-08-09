-- Author: Ketho (EU-Boulderfist)
-- License: Public Domain

local manager = CompactRaidFrameManager
manager:SetAlpha(0)

-- look through a frame's parents
local function FindParent(frame, target)
	if frame == target then
		return true
	elseif frame then
		return FindParent(frame:GetParent(), target)
	end
end

manager:HookScript("OnEnter", function(self)
	self:SetAlpha(1)
end)

manager:HookScript("OnLeave", function(self)
	if manager.collapsed and not FindParent(GetMouseFocus(), self) then
		self:SetAlpha(0)
	end
end)

manager.toggleButton:HookScript("OnClick", function()
	if manager.collapsed then
		manager:SetAlpha(0)
	end
end)

-- keep the container frame visible
manager.container:SetIgnoreParentAlpha(true)
manager.containerResizeFrame:SetIgnoreParentAlpha(true)
