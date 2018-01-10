-- ----------------------------------------------------------------------------
-- RaidTracker Recorder for tracking and saving Raids
-- ----------------------------------------------------------------------------

function trackAttendance()
  local raidMembers = {}
  local name = ""
  
  if(checkTracking()) then
    if(starttime == "") then
      starttime = date();
      starttime = string.gsub(starttime, "/", ".");
    end
    
    if(raidZone == "") then
      raidZone = GetZoneText();
    end
    
    numRaidMembers = GetNumRaidMembers();
    for x = 1, numRaidMembers, 1 do
      name, _, _, _, class = GetRaidRosterInfo(x);
      raidMembers[name] = class
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
        for member, class in pairs(secondMembers) do
          if not(firstMembers[member]) then
            firstMembers[member] = class
          end
        end
        RaidAttendance[kx] = nil
      end
    end
  end
end

function RaidTracker_AddTag()
  if currentlySelectedRaid == "" then
  else
    UIDropDownMenu_SetSelectedValue(RaidTrackerGUI_TagDropDown, this.value) 
    RaidAttendance[currentlySelectedRaid].tag = this.value
  end
end

function RaidTracker_PopupAddTag()
  tag = this.value
  UIDropDownMenu_SetSelectedValue(RaidTrackerGUI_PopupTagDropDown, this.value)
  RaidAttendance[starttime].tag = this.value
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