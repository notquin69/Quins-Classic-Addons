local _, addon = ...

local Classic = addon:GetModule("RCClassic")
local VotingFrame = addon:GetModule("RCVotingFrame")
local SessionFrame = addon:GetModule("RCSessionFrame")
local hooks = {}

function Classic:DoHooks ()
   for num, data in pairs(hooks) do
      if data.type == "raw" then
         Classic:RawHook(data.object, data.ref, data.func)
      elseif data.type == "script" then

      else
         Classic:Hook(data.object, data.ref, data.func)
      end
   end
end

tinsert(hooks, {
   object = SessionFrame,
   ref = "GetFrame",
   type = "raw",
   func = function()
      local frame = Classic.hooks[SessionFrame].GetFrame(SessionFrame)
      if frame.lootStatus then
         frame.lootStatus:Hide()
         frame.lootStatus = nil
      end
      return frame
   end,
})

tinsert(hooks, {
   object = VotingFrame,
   ref = "OnEnable",
   type = "raw",
   func = function()
      -- Call original
      Classic.hooks[VotingFrame].OnEnable(VotingFrame)
      VotingFrame.frame.lootStatus:Hide()
      VotingFrame.frame.lootStatus = nil
   end,
})

tinsert(hooks, {
   object = addon,
   ref = "GetInstalledModulesFormattedData",
   type = "raw",
   func = function()
      local modules = Classic.hooks[addon].GetInstalledModulesFormattedData(addon)
      -- Insert core RCLootCouncil version
      local coreVersion = "RCLootCouncil Core - "..Classic.RCLootCouncil.version
      if Classic.RCLootCouncil.tVersion then
         coreVersion = coreVersion .. "-" .. Classic.RCLootCouncil.tVersion
      end
      tinsert(modules, coreVersion)
      return modules
   end,
})
