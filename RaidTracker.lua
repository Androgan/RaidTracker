local raidTrackerVersion = "0.0.1"

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
	
	--register / comands
	SlashCmdList["RAIDTRACKER"] = RaidTracker_Command;
	SLASH_RAIDTRACKER1 = "/rt"
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
  local datetime = ""
  local zone = ""
  local firstMembers = {}
  local secondMembers = {}
  local additionalMembers = {}
  
  for k, tbl in pairs(RaidAttendance) do
    zone = tbl["zone"]
    datetime = findOldestRaidOfDay(k, zone)
    
    for kx, tblx in pairs(RaidAttendance) do
      if(isSameDay(datetime, kx) and
         zone == tblx["zone"] and
         not isSameTime(datetime, kx)) then
        firstMembers = RaidAttendance[datetime].member
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

function findOldestRaidOfDay(datetime, zone)
  local oldest = datetime

  for k, tbl in pairs(RaidAttendance) do
    if(isSameDay(oldest, k) and
       zone == tbl["zone"] and
       not isSameTime(oldest, k)) then
      if(isOlder(k, oldest)) then
        oldest = k
      end 
    end
  end
  
  return oldest
end

function isSameDay(dateX, dateY)
  return (string.sub(dateX, 1, 8) == string.sub(dateY, 1, 8))
end

function isSameTime(dateX, dateY)
  return (dateX == dateY)
end

function isOlder(k, oldest)
  local hour = ""
  local minute = ""
  local second = ""
  
  local ohour = ""
  local ominute = ""
  local osecond = ""
  
  hour = string.sub(k, 10, 11);
  minute = string.sub(k, 13, 14);
  second = string.sub(k, 16, 17);
  
  ohour = string.sub(oldest, 10, 11);
  ominute = string.sub(oldest, 13, 14);
  osecond = string.sub(oldest, 16, 17);
  
  if(hour < ohour) then
    return true
  elseif(minute < ominute) then
    return true
  elseif(second < osecond) then
    return true
  else
    return false
  end
end

function RaidTracker_ToggleRaidTrackerWindow()
	if RaidTrackerGUI:IsVisible() then RaidTrackerGUI:Hide() else RaidTrackerGUI:Show() end
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

function RaidTracker_Command(msg)

    local cmd = string.lower(msg)

    if cmd == "gui" then
        RaidTracker_ToggleRaidTrackerWindow();
        return;
    end


    -- Print usage information
    pPrint("RaidTracker VErsion: " .. raidTrackerVersion .. " Usage:");
    pPrint("/rt gui - Opens up the RaidTracker Window.");

end