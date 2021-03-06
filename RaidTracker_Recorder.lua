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
      activeRaid["zone"] = getInstanceID()
      activeRaid["date"] = time()
      activeRaid["member"] = {}
      activeRaid["tag"] = ""
      activeRaid["creator"] = me
    end
    
    numRaidMembers = GetNumGroupMembers()
    for x = 1, numRaidMembers, 1 do
      name = GetRaidRosterInfo(x)
      _, class = UnitClass(name)
      raidMembers[name] = {["class"] = class}
    end
    
    activeRaid["member"] = raidMembers
    
    RaidAttendance[activeRaid.date] = activeRaid
    
    if syncTag ~= "" then
      setSyncMsgTag()
    else
      C_ChatInfo.SendAddonMessage(addonPrefix .. "tagRequest", "", "RAID")
      raidTrackerWait(20, handleTagResponse)
    end
    
    RaidTrackerUI_UpdateRaidlist()
  end
end

function selectActiveRaid()
  for k, tbl in pairs(RaidAttendance) do
    if (k > (time() - 43200)) and
       (tbl["zone"] == getInstanceID()) then
      debugPrint("found previous raid" .. k)
      return k
    end
  end
  
  debugPrint("found no prev raid" .. time())
  return time()
end

function RaidTracker_AddTag(self)
  if currentlySelectedRaid ~= "" then
    UIDropDownMenu_SetSelectedValue(RaidTrackerGUI_TagDropDown, self.value) 
    RaidAttendance[currentlySelectedRaid].tag = self.value
  end
end

function RaidTracker_PopupAddTag(self)
  UIDropDownMenu_SetSelectedValue(RaidTrackerGUI_PopupTagDropDown, self.value)
  RaidAttendance[selectActiveRaid()].tag = self.value
  C_ChatInfo.SendAddonMessage(addonPrefix .. "tagProvide", self.value, "RAID")
end

function setSyncMsgTag()
  UIDropDownMenu_SetSelectedValue(RaidTrackerGUI_PopupTagDropDown, syncTag)
  RaidAttendance[selectActiveRaid()].tag = syncTag
end

function handleTagResponse()
  if syncTag ~= "" then
    setSyncMsgTag()
  else
    RaidTrackerGUI_RaidTagPopup:Show()
  end
end

-- ----------------------------------------------------------------------------
-- Helpers
-- ----------------------------------------------------------------------------

function checkTracking()
  local track = false
  
  track = searchInTable(getInstanceID(), trackedZones);
  track = track and (GetNumGroupMembers() > 0);
  
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