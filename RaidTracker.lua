-- ----------------------------------------------------------------------------
-- Main File
--
-- Contains Utility Functions and Globals
-- ----------------------------------------------------------------------------
-- Globals
-- ----------------------------------------------------------------------------

--trackedZones = {"Ironforge", "City of Ironforge"}
trackedZones = {"The Molten Core",
                "Onyxia's Lair",
                "Blackwing Lair",
                "Zul'Gurub",
                "Ruins of Ahn'Qiraj",
                "The Temple of Ahn'Qiraj",
                "Naxxramas"}
raidTags =       {"Guild Raid",
                  "Twink Raid",
                  "Pug Raid",
                  "Private Raid",
                  ""}

starttime = ""
raidZone = ""
numRaidMembers = 0
deleteRecords = false

-- ----------------------------------------------------------------------------
-- Initializing Saved Variables
-- ----------------------------------------------------------------------------

if(RaidAttendance == nil) then
  RaidAttendance = {};
end

-- ----------------------------------------------------------------------------
-- Event Handling
-- ----------------------------------------------------------------------------

function RaidTracker_OnLoad()
  registerEvents();
  registerSlashCommands();
  
  pPrint("Version " .. getVersion() .. " loaded.");
end

function RaidTracker_OnEvent(event)
  if(event == "ZONE_CHANGED_NEW_AREA" or
     event == "ZONE_CHANGED_INDOORS" or
     event == "ZONE_CHANGED") then
    zoneChangeEventHandler();
  end
  
  if(event == "RAID_ROSTER_UPDATE") then
    rosterUpdateHandler();
  end
  
  if(event == "PLAYER_LOGOUT") then
    logoutHandler();
  end
  
  if(event == "ADDON_LOADED") then
    RaidTrackerUI_UpdateRaidlist();
  end
end

function zoneChangeEventHandler()
  if(raidZone ~= GetZoneText() and
     searchInTable(GetZoneText(), trackedZones)) then
    starttime = ""
    raidZone = ""    
  end
  trackAttendance();
  if checkTracking() == true and (RaidAttendance[starttime].tag == "" or RaidAttendance[starttime].tag == nil) then
    RaidTrackerGUI_RaidTagPopup:Show()
  end
    
end

function rosterUpdateHandler()
  if(playerLeaveOrEnter()) then
    trackAttendance();
  end
end

function logoutHandler()
  if(deleteRecords) then
    RaidAttendance = {}
  else
    mergeDuplicates();
  end
end

-- ----------------------------------------------------------------------------
-- Time Functions
-- ----------------------------------------------------------------------------

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

-- ----------------------------------------------------------------------------
-- Slash Commands
-- ----------------------------------------------------------------------------

function registerSlashCommands()
  SlashCmdList["RAIDTRACKER"] = RaidTracker_Command;
  SLASH_RAIDTRACKER1 = "/rt"
  SLASH_RAIDTRACKER2 = "/raidtracker"
end

function RaidTracker_Command(msg)
  local cmd = ""
  
  cmd = string.lower(msg)

  if(cmd == "gui") or (cmd == "") then
    RaidTrackerUI_ToggleRaidTrackerWindow();
  elseif(cmd == "reset") then
    if not(deleteRecords) then
      deleteRecords = true
      pPrint("Deleting all records on next logout.");
    else
      deleteRecords = false
      pPrint("No longer deleting records on next logout.");
    end
  else
    pPrint("Version " .. getVersion() .. " Usage:");
    pPrint("/rt gui - Opens up the RaidTracker Window.");
    pPrint("/rt reset - Set flag to delete records on logout.");
  end
end

-- ----------------------------------------------------------------------------
-- Utility Functions
-- ----------------------------------------------------------------------------

function registerEvents()
  this:RegisterEvent("ZONE_CHANGED_NEW_AREA");
  this:RegisterEvent("ZONE_CHANGED_INDOORS");
  this:RegisterEvent("ZONE_CHANGED");
  this:RegisterEvent("RAID_ROSTER_UPDATE");
  this:RegisterEvent("PLAYER_LOGOUT");
  this:RegisterEvent("ADDON_LOADED");
end

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

function getVersion()
  return GetAddOnMetadata("RaidTracker", "Version")
end