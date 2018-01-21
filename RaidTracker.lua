-- ----------------------------------------------------------------------------
-- Main File
--
-- Contains Utility Functions and Globals
-- ----------------------------------------------------------------------------
-- Globals
-- ----------------------------------------------------------------------------

-- trackedZones = {"Ironforge", "City of Ironforge", "Stormwind Stockade"}
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

numRaidMembers = 0
deleteRecords = false
addonPrefix = "RaidTracker"
me = UnitName("player")
bDebug = true
activeRaid = {}

-- ----------------------------------------------------------------------------
-- Initializing Saved Variables
-- ----------------------------------------------------------------------------

if(RaidAttendance == nil) then
  RaidAttendance = {}
end

-- ----------------------------------------------------------------------------
-- Event Handling
-- ----------------------------------------------------------------------------

function RaidTracker_OnLoad()
  registerEvents()
  registerSlashCommands()
  
  pPrint("Version " .. getVersion() .. " loaded.")
end

function RaidTracker_OnEvent(event)
  if(event == "ZONE_CHANGED_NEW_AREA") then
    trackAttendance()
  end
  
  if(event == "RAID_ROSTER_UPDATE") then
    rosterUpdateHandler()
  end
  
  if(event == "PLAYER_LOGOUT") then
    logoutHandler()
  end
  
  if(event == "ADDON_LOADED" and arg1 == "RaidTracker") then
    RaidTrackerGUI_Initialize()
  end
  
  if(event == "CHAT_MSG_ADDON") then
    chatMsgAddonHandler(arg1, arg2, arg3, arg4)
  end
end

function rosterUpdateHandler()
  if(didPlayerEnter()) then
    trackAttendance()
  end
end

function didPlayerEnter()
  return numRaidMembers < GetNumRaidMembers()
end

function logoutHandler()
  if(deleteRecords) then
    RaidAttendance = {}
  end
end

function chatMsgAddonHandler(prefix, message, channel, sender)
  local versions = {}
  
  -- version checking
  if prefix == addonPrefix and 
     message == "versioncheck" and
     sender ~= me then
    postVersion()
  elseif prefix == addonPrefix .. "Version" and
         sender ~= me then
    pPrint(message)
  
  -- syncing
  elseif prefix == addonPrefix and
         message == "sync" and
         sender ~= me then
    postRecordedRaids()
  elseif prefix == addonPrefix and
         string.sub(message, 1, 6) == "record" and
         sender ~= me then
    syncRecievedRaid(string.sub(message, 7))
  end
end

function postVersion()
  SendAddonMessage(addonPrefix .. "Version", me .. " - " .. getVersion())
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
  elseif(cmd == "check") then
    pPrint(me .. " - " .. getVersion());
    SendAddonMessage(addonPrefix, "versioncheck")
  elseif(cmd == "sync") then
    SendAddonMessage(addonPrefix, "sync")
  else
    pPrint("Version " .. getVersion() .. " Usage:");
    pPrint("/rt gui - Opens up the RaidTracker Window.");
    pPrint("/rt reset - Set flag to delete records on logout.");
    pPrint("/rt check - Checks other addons Versions.");
    pPrint("/rt sync - Syncs other players Raids into own Raids.");
  end
end

-- ----------------------------------------------------------------------------
-- Utility Functions
-- ----------------------------------------------------------------------------

function registerEvents()
  this:RegisterEvent("ZONE_CHANGED_NEW_AREA");
  this:RegisterEvent("RAID_ROSTER_UPDATE");
  this:RegisterEvent("PLAYER_LOGOUT");
  this:RegisterEvent("ADDON_LOADED");
  this:RegisterEvent("CHAT_MSG_ADDON");
end

function pPrint(text)
  DEFAULT_CHAT_FRAME:AddMessage("RaidTracker: " .. text);
end

function debugPrint(text)
  if bDebug then
    DEFAULT_CHAT_FRAME:AddMessage("RaidTrackerDebug: " .. text);
  end
end

function printTableKeys(tbl)
  for k, v in pairs(tbl) do
    pPrint(k)
  end
end

function printTableVals(tbl)
  for k, v in pairs(tbl) do
    if type(v) == "string" then
      pPrint(v);
    elseif type(v) == "table" then
      printTableKeys(v)
    end
  end
end

function getVersion()
  return GetAddOnMetadata("RaidTracker", "Version")
end