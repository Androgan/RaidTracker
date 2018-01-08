-- ----------------------------------------------------------------------------
-- RaidTracker Recorder for tracking and saving Raids
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
  RaidTrackerUI_UpdateRaidlist();
end

function fillSaved(raidMembers)
  local newRaid = {}
  
  newRaid["zone"] = raidZone;
  newRaid["member"] = raidMembers;
  newRaid["date"] = starttime;
  
  RaidAttendance[starttime] = newRaid;
end

function mergeDuplicates()
  local datetime = ""
  local zone = ""
  local firstMembers = {}
  local secondMembers = {}
  local additionalMembers = {}
  
  for k, tbl in pairs(RaidAttendance) do
    zone = tbl["zone"]
    datetime = findOldestRaidOfDay(k, zone);
    
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

-- ----------------------------------------------------------------------------
-- Helpers
-- ----------------------------------------------------------------------------

function checkTracking()
  local track = false
  
  track = searchInTable(GetZoneText(), trackedZones);
  track = track and (GetNumRaidMembers() > 0);
  
  return track
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