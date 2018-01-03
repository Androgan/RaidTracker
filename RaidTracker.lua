local track = false
local trackedZones = {"Molten Core", "Blackwing Lair", "Ironforge"}

local frame = CreateFrame("FRAME", "RaidTrackerFrame");
frame:RegisterEvent("ZONE_CHANGED_INDOORS");
frame:RegisterEvent("ZONE_CHANGED");
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
frame:RegisterEvent("RAID_ROSTER_UPDATE");

function eventHandler(self, event, ...)
  if(event == "ZONE_CHANGED_NEW_AREA") then
    myPrint("0");
    -- checkTracking();
    myPrint("0.5");
  end
  
  if (event == "RAID_ROSTER_UPDATE") then
    myPrint("1");
    trackAttendance();
  end
end
frame:SetScript("OnEvent", eventHandler);

-- ----------------------------------------------------------------------------

function trackAttendance()
  if(track) then
    myPrint("2");
  end
end

function checkTracking()
  track = searchZone(GetZoneName());
end

function searchZone(zoneName)
  for _, v in pairs(trackedZones) do
    if(v == zoneName) then
      return true
    end
  end
  return false
end

function myPrint(text)
  DEFAULT_CHAT_FRAME:AddMessage("RaidTracker: " ..text);
end