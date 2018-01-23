requestedRaids = {}

function postRecordedRaids()
  local raidIDAsMessage = ""
  
  for k, tbl in pairs(RaidAttendance) do
    if tbl.tag == "Guild Raid" or tbl.tag == "Twink Raid" then
      raidIDAsMessage = raidIDAsMessage .. "key:" .. k
      raidIDAsMessage = raidIDAsMessage .. "zone:" .. tbl.zone
      
      pPrint("SYNC: posting raid" .. k)
      SendAddonMessage(addonPrefix .. "raidID", raidIDAsMessage .. "record_end", "RAID")
      raidIDAsMessage = ""
    end
  end
end

function requestIfMissing(record, sender)
  local key = ""
  local zone = ""
  
  key = string.sub(record, string.find(record, "key:") + 4, string.find(record, "zone:") - 1)
  zone = string.sub(record, string.find(record, "zone:") + 5, string.find(record, "record_end") - 1)
  
  for _, v in pairs(requestedRaids) do
    if v == record then
      pPrint("SYNC: already requested" .. key)
      return
    end
  end
  
  pPrint("SYNC: requestIfMissing " .. key)
  
  for k, tbl in pairs(RaidAttendance) do
    if ((k - 21600) < tonumber(key)) and
       ((k + 21600) > tonumber(key)) and
       tbl.zone == zone then
      pPrint("SYNC: got raid " .. key)
      return
    end
  end
  
  table.insert(requestedRaids, record)
  pPrint("SYNC: requesting " .. key)
  SendAddonMessage(addonPrefix .. "request" .. sender, record, "RAID")
end

function sendRequestedRaid(record, sender)
  local recordAsMessage = ""
  local numMember = 1
  local key = ""
  local zone = ""
  
  key = string.sub(record, string.find(record, "key:") + 4, string.find(record, "zone:") - 1)
  key = tonumber(key)
  zone = string.sub(record, string.find(record, "zone:") + 5, string.find(record, "record_end") - 1)
  
  recordAsMessage = "key:" .. key .. "zone:" .. zone .. "date:" .. RaidAttendance[key].date ..
                    "tag:" .. RaidAttendance[key].tag
  SendAddonMessage(addonPrefix .. "part" .. sender, "record" .. recordAsMessage, "RAID")
  recordAsMessage = ""
  
  for member, tbl in pairs(RaidAttendance[key].member) do
    recordAsMessage = recordAsMessage .. "member:" .. numMember .. member .. ";" .. tbl.class
    numMember = numMember + 1
    if string.len(recordAsMessage) > 226 then
      SendAddonMessage(addonPrefix .. "part" .. sender, recordAsMessage, "RAID")
      recordAsMessage = ""
    end
  end
  SendAddonMessage(addonPrefix .. "part" .. sender, recordAsMessage .. "record_end", "RAID")
end

function saveRecievedRaid(record)
  local numMember = 1
  local key = ""
  local zone = ""
  local datetime = ""
  local tag = ""
  local members = ""
  local player = ""
  local class = ""
  local offset = 0
  local fullRaid = {}
  local raidMembers = {}
  
  key = string.sub(record, string.find(record, "key:") + 4, string.find(record, "zone:") - 1)
  zone = string.sub(record, string.find(record, "zone:") + 5, string.find(record, "date:") - 1)
  datetime = string.sub(record, string.find(record, "date:") + 5, string.find(record, "tag:") - 1)
  tag = string.sub(record, string.find(record, "tag:") + 4, string.find(record, "member:") - 1)
  
  fullRaid["zone"] = zone
  fullRaid["date"] = tonumber(datetime)
  fullRaid["tag"] = tag
  
  members = string.sub(record, string.find(record, "member:"), string.find(record, "record_end") + 9)
  
  while string.find(members, "member:") ~= nil do
    offset = memberOffset(numMember)
    
    player = string.sub(members,
                        string.find(members, "member:" .. numMember) + offset,
                        findNextMember(members, numMember + 1))
    
    class = string.sub(player, string.find(player, ";") + 1, string.len(player))
    player = string.sub(player, 1, string.find(player, ";") - 1)
    
    raidMembers[player] = {}
    raidMembers[player].class = class
    
    if string.find(members, "member:" .. (numMember + 1)) ~= nil then
      members = string.sub(members,
                           string.find(members, "member:" .. (numMember + 1)),
                           string.find(members, "record_end") + 9)
    else
      members = ""
    end
    numMember = numMember + 1
  end
  
  fullRaid["member"] = raidMembers
  
  RaidAttendance[tonumber(key)] = fullRaid
  RaidTrackerUI_UpdateRaidlist()
end

function findNextMember(members, numNextMember)
  local indexNext = 0
  indexNext = string.find(members, "member:" .. (numNextMember))
  
  if indexNext == nil then
    indexNext = string.find(members, "record_end")
  end
  
  return indexNext - 1
end

function memberOffset(num)
  if num > 9 then
    return 9
  else
    return 8
  end
end