local _, addon = ...
local VotingFrame = addon:GetModule("RCVotingFrame")


function VotingFrame:UpdateLootStatus ()
   -- Do nothing
end

-- We don't handle spec icons in classic
function VotingFrame.SetCellClass(rowFrame, frame, data, cols, row, realrow, column, fShow, table, ...)
   local name = data[realrow].name
   -- The orignal function fetches the class from the lootTable with session, both of which we can't access.
   -- Luckily we only need the class, so we can fetch it from a random session:
   local class = VotingFrame:GetCandidateData(1, name, "class")
	addon.SetCellClassIcon(rowFrame, frame, data, cols, row, realrow, column, fShow, table, class)
	data[realrow].cols[column].value = class or ""
end
