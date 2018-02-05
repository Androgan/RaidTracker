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
                "Ahn'Qiraj",
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
raidParts = {}
syncTag = ""

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
         message == "sync" then
    postRecordedRaids()
  elseif prefix == addonPrefix .. "raidID" and
         sender ~= me then
    requestIfMissing(message, sender)
  elseif prefix == addonPrefix .. "request" .. me and
         sender ~= me then
    sendRequestedRaid(message, sender)
  elseif prefix == addonPrefix .. "part" .. me and
         sender ~= me then
    if raidParts.sender == nil then
      raidParts.sender = ""
    end
    raidParts.sender = raidParts.sender .. message
    if string.find(message, "record_end") ~= nil then
      saveRecievedRaid(raidParts.sender)
      raidParts.sender = ""
    end
  
  -- tag sync
  elseif prefix == addonPrefix .. "tagProvide" and
         sender ~= me then
    syncTag = message
  elseif prefix == addonPrefix .. "tagRequest" and
         sender ~= me then
    if RaidAttendance[selectActiveRaid()] ~= nil then
      SendAddonMessage(addonPrefix .. "tagResponse" .. sender, RaidAttendance[selectActiveRaid()].tag, "RAID")
    end
  elseif prefix == addonPrefix .. "tagResponse" .. me and
       sender ~= me then
    if syncTag == "" then
      syncTag = message
    end
  end
end

function postVersion()
  SendAddonMessage(addonPrefix .. "Version", me .. " - " .. getVersion(), "RAID")
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
    SendAddonMessage(addonPrefix, "versioncheck", "RAID")
  
  elseif(cmd == "sync") then
    SendAddonMessage(addonPrefix, "sync", "RAID")
  
  elseif(cmd == "edittag") then
    if currentlySelectedRaid ~= "" then
      RaidTrackerGUI_TagDropDown:Show()
    else
      pPrint("Select a raid first")
    end
  
  else
    pPrint("Version " .. getVersion() .. " Usage:");
    pPrint("/rt gui - Opens up the RaidTracker Window.");
    pPrint("/rt reset - Set flag to delete records on logout.");
    pPrint("/rt check - Checks other addons Versions.");
    pPrint("/rt sync - Syncs other players Raids into own Raids.");
    pPrint("/rt edittag - Alowes to edit tags of recorded raids");
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
  -- SendChatMessage("RaidTracker: " .. text, "RAID")
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

local currDelay = 0
local currFunc = nil
local waitFrame = nil

function raidTrackerWait(delay, func, ...)
  if(waitFrame == nil) then
    waitFrame = CreateFrame("Frame","WaitFrame", UIParent)
  end
  currDelay = delay
  currFunc = func
  waitFrame.TimeSinceLastUpdate = 0
  waitFrame:SetScript("onUpdate", waitFunc)
end

function waitFunc(self,elapsed, ...)
  waitFrame.TimeSinceLastUpdate = waitFrame.TimeSinceLastUpdate + arg1
  
  if waitFrame.TimeSinceLastUpdate > currDelay then
    currFunc()
    currDelay = 0
    waitFrame.TimeSinceLastUpdate = 0
    currFunc = nil
    waitFrame:SetScript("onUpdate", nil)
  end
end