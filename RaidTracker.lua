local track = false
local trackedZones = {"Molten Core", "Blackwing Lair", "Ironforge"}
local daytime = ""

function RaidTracker_OnLoad()
  this:RegisterEvent("ZONE_CHANGED_NEW_AREA");
  this:RegisterEvent("ZONE_CHANGED_INDOORS");
  this:RegisterEvent("ZONE_CHANGED");
  
  this:RegisterEvent("RAID_ROSTER_UPDATE");
end

function RaidTracker_OnEvent(event)
  pPrint("event Occured");
  if(event == "ZONE_CHANGED_NEW_AREA" or
     event == "ZONE_CHANGED_INDOORS" or
     event == "ZONE_CHANGED") then
    pPrint("zone change");
    trackAttendance();
  end
  
  if(event == "RAID_ROSTER_UPDATE") then
    pPrint("roster update");
    trackAttendance();
  end
end

-- ----------------------------------------------------------------------------

function trackAttendance()
  local numRaidMembers = 0
  local raidMembers = {}
  local name = ""
  
  checkTracking();
  
  if(track) then
    pPrint("tracking");
    
    if(daytime == "") then
      daytime = date();
    end
    
    numRaidMembers = GetNumRaidMembers();
    for x = 1, numRaidMembers, 1 do
      name = GetRaidRosterInfo(x);
      raidMembers[x] = name
    end
    
  else
    pPrint("not tracking");
  end
end

function checkTracking()
  track = searchZone(GetZoneText());
end

function searchZone(zoneName)
  for _, v in pairs(trackedZones) do
    if(v == zoneName) then
      return true
    end
  end
  return false
end

function pPrint(text)
  DEFAULT_CHAT_FRAME:AddMessage("RaidTracker: " .. text);
end