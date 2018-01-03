-- local track = false
-- local trackedZones = {"Molten Core", "Blackwing Lair"}

function RaidTracker_OnLoad()
	-- this:RegisterEvent("ZONE_CHANGED_INDOORS");
  DEFAULT_CHAT_FRAME:AddMessage("Foo");
end

-- function RaidTracker_OnEvent()
--   local zoneName
-- 
--   if(event == "ZONE_CHANGED_INDOORS") then
--     zoneName = GetZoneText()
--     if(searchZone(zoneName)) then
--       track = true
--     end
--   end
-- end
-- 
-- function trackAttendance()
--   
--   -- onGrpSizeChange if track do track
-- end

-- function searchZone(zoneName)
--   for _, v in pairs(trackedZones) do
--     if(v == zoneName) then
--       return true
--     end
--   end
--   return false
-- end