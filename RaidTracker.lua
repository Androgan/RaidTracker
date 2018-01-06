local trackedZones = {"The Molten Core", "Blackwing Lair", "Ironforge", "City of Ironforge"}
local starttime = ""
local raidZone = ""
local numRaidMembers = 0

local reset = false

if(RaidAttendance == nil) then
  RaidAttendance = {};
end

function RaidTracker_OnLoad()
  this:RegisterEvent("ZONE_CHANGED_NEW_AREA");
  this:RegisterEvent("ZONE_CHANGED_INDOORS");
  this:RegisterEvent("ZONE_CHANGED");
  
  this:RegisterEvent("RAID_ROSTER_UPDATE");
  
  this:RegisterEvent("PLAYER_LOGOUT");
end

function RaidTracker_OnEvent(event)
  if(event == "ZONE_CHANGED_NEW_AREA" or
     event == "ZONE_CHANGED_INDOORS" or
     event == "ZONE_CHANGED") then
    zoneChangeEventHandler();
  end
  
  if(event == "RAID_ROSTER_UPDATE") then
    if(playerLeaveOrEnter()) then
      trackAttendance();
    end
  end
  
  if(event == "PLAYER_LOGOUT" and
     reset) then
    RaidAttendance = {}
  elseif(event == "PLAYER_LOGOUT") then
    mergeDuplicates();
  end
end

-- ----------------------------------------------------------------------------

function zoneChangeEventHandler()
  if(raidZone ~= GetZoneText() and
     searchInTable(GetZoneText(), trackedZones)) then
    starttime = ""
    raidZone = ""
  end

  trackAttendance();
end

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
  newRaid["date"] = starttime;
  
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

function mergeDuplicates()
  local datetime
  local zone
  local firstMembers = {}
  local secondMembers = {}
  local additionalMembers = {}
  
  for k, tbl in pairs(RaidAttendance) do
    datetime = tbl["date"]
    zone = tbl["zone"]
    
    for kx, tblx in pairs(RaidAttendance) do
      if(isSameDay(datetime, kx) and
         zone == tblx["zone"] and
         not isSameTime(datetime, kx)) then
        firstMembers = tbl["member"]
        secondMembers = tblx["member"]
        for member, _ in pairs(secondMembers) do
          if not(firstMembers[member]) then
            firstMembers[member] = true
          end
        end
        RaidAttendance[kx] = nil
      end
    end
  end
end

function isSameDay(dateX, dateY)
  return (string.sub(dateX, 1, 8) == string.sub(dateY, 1, 8))
end

function isSameTime(dateX, dateY)
  return (dateX == dateY)
end

-- ----------------------------------------------------------------------------

function pPrint(text)
  DEFAULT_CHAT_FRAME:AddMessage("RaidTracker: " .. text);
end

function printTableKeys(tbl)
  for k, v in pairs(tbl) do
    pPrint(k);
  end
end

function printTableVals(tbl)
  for k, v in pairs(tbl) do
    pPrint(v);
  end
end