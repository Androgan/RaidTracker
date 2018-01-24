-- ----------------------------------------------------------------------------
-- RaidTracker Recorder for tracking and saving Raids
-- ----------------------------------------------------------------------------

function trackAttendance()
  local name = ""
  local class = ""
  local raidMembers = {}
  
  if(checkTracking()) then
    activeRaid = RaidAttendance[selectActiveRaid()]
    
    if activeRaid == nil then
      activeRaid = {}
      activeRaid["zone"] = GetRealZoneText()
      activeRaid["date"] = time()
      activeRaid["member"] = {}
      activeRaid["tag"] = ""
      activeRaid["creator"] = me
      
      RaidTrackerGUI_RaidTagPopup:Show()
    end
    
    numRaidMembers = GetNumRaidMembers()
    pPrint(numRaidMembers)
    for x = 1, numRaidMembers, 1 do
      name, _, _, _, class = GetRaidRosterInfo(x)
      raidMembers[name] = {["class"] = class}
    end
    
    activeRaid["member"] = raidMembers
    
    RaidAttendance[activeRaid.date] = activeRaid
    RaidTrackerUI_UpdateRaidlist()
  end
end

function selectActiveRaid()
  for k, tbl in pairs(RaidAttendance) do
    if (k > (time() - 43200)) and
       (tbl["zone"] == GetRealZoneText()) then
      debugPrint("found previous raid" .. k)
      return k
    end
  end
  
  debugPrint("found no prev raid" .. time())
  return time()
end

function RaidTracker_AddTag()
  if currentlySelectedRaid ~= "" then
    UIDropDownMenu_SetSelectedValue(RaidTrackerGUI_TagDropDown, this.value) 
    RaidAttendance[currentlySelectedRaid].tag = this.value
  end
end

function RaidTracker_PopupAddTag()
  UIDropDownMenu_SetSelectedValue(RaidTrackerGUI_PopupTagDropDown, this.value)
  RaidAttendance[selectActiveRaid()].tag = this.value
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