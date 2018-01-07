-- ----------------------------------------------------------------------------
-- Main File
--
-- Contains Utility Functions and Globals
-- ----------------------------------------------------------------------------
-- Globals
-- ----------------------------------------------------------------------------

-- {"Ironforge", "City of Ironforge"}
local trackedZones = {"The Molten Core",
                      "Onyxia's Lair",
                      "Blackwing Lair",
                      "Zul'Gurub",
                      "Ruins of Ahn'Qiraj",
                      "The Temple of Ahn'Qiraj",
                      "Naxxramas"}
local starttime = ""
local raidZone = ""
local numRaidMembers = 0
local reset = false

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
end

function zoneChangeEventHandler()
  if(raidZone ~= GetZoneText() and
     searchInTable(GetZoneText(), trackedZones)) then
    starttime = ""
    raidZone = ""
  end
  trackAttendance();
end

function rosterUpdateHandler()
  if(playerLeaveOrEnter()) then
    trackAttendance();
  end
end

function logoutHandler()
  if(reset) then
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

  if(cmd == "gui") then
    RaidTrackerUI_ToggleRaidTrackerWindow();
  else
    pPrint("Version " .. getVersion() .. " Usage:");
    pPrint("/rt gui - Opens up the RaidTracker Window.");
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