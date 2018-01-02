local track = false

function RaidTracker_OnLoad()
	this:RegisterEvent("ZONE_CHANGED_INDOORS");
end

function RaidTracker_OnEvent()
local zoneName
  if(event == "ZONE_CHANGED_INDOORS") then
    zoneName = GetZoneText();
    if(zoneName in trackedZones) then
      track = true
    end
  end
end

function trackAttendance()
  -- onGrpSizeChange if track do track
end