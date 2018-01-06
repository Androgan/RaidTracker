local trackedZones = {"The Molten Core", "Blackwing Lair"}
local starttime = ""
local raidZone = ""
local numRaidMembers = 0

function RaidTracker_OnLoad()
  this:RegisterEvent("ZONE_CHANGED_NEW_AREA");
  this:RegisterEvent("ZONE_CHANGED_INDOORS");
  this:RegisterEvent("ZONE_CHANGED");
  
  this:RegisterEvent("RAID_ROSTER_UPDATE");
end

function RaidTracker_OnEvent(event)
  if(event == "ZONE_CHANGED_NEW_AREA" or
     event == "ZONE_CHANGED_INDOORS" or
     event == "ZONE_CHANGED") then
    trackAttendance();
  end
  
  if(event == "RAID_ROSTER_UPDATE") then
    if(playerLeaveOrEnter()) then
      trackAttendance();
    end
  end
end

-- ----------------------------------------------------------------------------

function trackAttendance()
  local raidMembers = {}
  local name = ""
  
  if(checkTracking()) then
    if(starttime == "") then
      starttime = date();
    end
    
    if(raidZone == "") then
      raidZone = GetZoneText();
    end
    
    numRaidMembers = GetNumRaidMembers();
    for x = 1, numRaidMembers, 1 do
      name = GetRaidRosterInfo(x);
      raidMembers[name] = true
    end
    fillSaved(raidMembers);
  end
end

function checkTracking()
  local track = false
  
  track = searchInTable(GetZoneText(), trackedZones);
  track = track and (GetNumRaidMembers() > 0);
  
  return track
end

function fillSaved(raidMembers)
  local newRaid = {}
  
  newRaid["zone"] = raidZone;
  newRaid["member"] = raidMembers;
  
  RaidAttendance[starttime] = newRaid;
end

function searchInTable(search, tbl)
  for _, v in pairs(tbl) do
    if(v == search) then
      return true
    end
  end
  return false
end

function playerLeaveOrEnter()
  return numRaidMembers ~= GetNumRaidMembers()
end

-- ----------------------------------------------------------------------------

function pPrint(text)
  DEFAULT_CHAT_FRAME:AddMessage("RaidTracker: " .. text);
end

function printTable(tbl)
  for k, v in pairs(tbl) do
    pPrint(k);
  end
end