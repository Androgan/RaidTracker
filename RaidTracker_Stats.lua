-- ----------------------------------------------------------------------------
-- Logic for Building Stats Data
-- ----------------------------------------------------------------------------

local TemplateAttendanceStatsFontString = {}
local TemplateAttendanceStatsFrame = {}
local TemplateAttendanceStatsLeftFrame = {}
local TemplateAttendanceStatsLeftFontString = {}











function RaidTrackerUI_UpdateStats()

  local entryNr = 0
  local line = 0
  local row = 0
  local maxAttendences = 0
  local attendanceStats = {}

  for k, v in pairs(RaidAttendance) do
  
    if (v.tag ~= "Guild Raid" and v.tag ~= "Twink Raid") then
      break
    end
    
    for l, w in pairs(RaidAttendance[k].member) do
      if attendanceStats[l] == nil then 
        attendanceStats[l] = {}
        attendanceStats[l].count = 1
        attendanceStats[l].class = RaidAttendance[k].member[l].class
      else
        attendanceStats[l].count = attendanceStats[l].count + 1
      end      
    end
  end

  for k, v in pairs(attendanceStats) do
    if attendanceStats[k].count > maxAttendences then
      maxAttendences = attendanceStats[k].count
    end
  end
  
  for i = maxAttendences, 1, -1 do
      
    for k, v in pairs(attendanceStats) do
      if v.count == i then
        local text = k
        local pct = (math.floor(v.count / maxAttendences * 100) .. "%") --(v.count .. " - " .. math.floor(v.count / maxAttendences * 100) .. "%")
 
        if line > 18 then
          line = 0
          row = row + 1
        end


 
        if TemplateAttendanceStatsFontString[entryNr] == nil then
        
          TemplateAttendanceStatsFrame[entryNr] = CreateFrame("Frame",nil,RaidTrackerGUI_StatsSubframe)
          TemplateAttendanceStatsFrame[entryNr]:SetPoint("TOPLEFT",RaidTrackerGUI_StatsSubframe, "TOPLEFT", (3 + row * 125) , (-3 - 16 * line))
          TemplateAttendanceStatsFrame[entryNr]:SetHeight(16)
          TemplateAttendanceStatsFrame[entryNr]:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
          TemplateAttendanceStatsFrame[entryNr]:SetBackdropColor(0.1, 0.9, 0.2)
          TemplateAttendanceStatsFrame[entryNr]:SetFrameLevel(0)
        
          TemplateAttendanceStatsLeftFrame[entryNr] = CreateFrame("Frame",nil,RaidTrackerGUI_StatsSubframe)
          TemplateAttendanceStatsLeftFrame[entryNr]:SetPoint("TOPRIGHT",RaidTrackerGUI_StatsSubframe, "TOPLEFT", (123 + row * 125) , (-3 - 16 * line))
          TemplateAttendanceStatsLeftFrame[entryNr]:SetHeight(16)
          TemplateAttendanceStatsLeftFrame[entryNr]:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
          TemplateAttendanceStatsLeftFrame[entryNr]:SetBackdropColor(0.01, 0.16, 0.04) --(0.5, 0.2, 0.2)
          TemplateAttendanceStatsLeftFrame[entryNr]:SetFrameLevel(1)
          
          
          -- define FintString template for stat entry
          TemplateAttendanceStatsFontString[entryNr] = RaidTrackerGUI_StatsSubframe:CreateFontString(nil, "OVERLAY")
          TemplateAttendanceStatsFontString[entryNr]:SetPoint("TOPLEFT", RaidTrackerGUI_StatsSubframe, "TOPLEFT", (4 + row * 125), (-4 - 16 * line))
          TemplateAttendanceStatsFontString[entryNr]:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
          TemplateAttendanceStatsFontString[entryNr]:SetWidth(120)
          TemplateAttendanceStatsFontString[entryNr]:SetJustifyH("LEFT")
          
          TemplateAttendanceStatsLeftFontString[entryNr] = RaidTrackerGUI_StatsSubframe:CreateFontString(nil, "OVERLAY")
          TemplateAttendanceStatsLeftFontString[entryNr]:SetPoint("TOPLEFT", RaidTrackerGUI_StatsSubframe, "TOPLEFT", (3 + row * 125), (-6 - 16 * line))
          TemplateAttendanceStatsLeftFontString[entryNr]:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
          TemplateAttendanceStatsLeftFontString[entryNr]:SetWidth(120)
          TemplateAttendanceStatsLeftFontString[entryNr]:SetJustifyH("RIGHT")
          
        end
        TemplateAttendanceStatsFontString[entryNr]:SetText(text)
        TemplateAttendanceStatsLeftFontString[entryNr]:SetText(pct)
        TemplateAttendanceStatsFontString[entryNr]:SetTextColor(RaidTrackerGUI_GetClassClolor(v.class))
        TemplateAttendanceStatsFrame[entryNr]:SetWidth(120 * v.count / maxAttendences)
        TemplateAttendanceStatsLeftFrame[entryNr]:SetWidth(120 * (1 - v.count / maxAttendences))
        
        entryNr = entryNr + 1
        line = line + 1
      end
    end
  end
  
  
  --for i = maxAttendences, 1, -1 do
  --    local line = 0
  --  for k, v in pairs(attendanceStats) do
  --    if v.count == i then
  --      local text = k .. " (" .. v.count .. " - " .. math.floor(v.count / maxAttendences * 100) .. "%)"
  --  
  --      if TemplateAttendanceStatsFontString[entryNr] == nil then
  --        -- define FintString template for stat entry
  --        TemplateAttendanceStatsFontString[entryNr] = RaidTrackerGUI_StatsSubframe:CreateFontString(nil, "OVERLAY")
  --        TemplateAttendanceStatsFontString[entryNr]:SetPoint("TOPLEFT", RaidTrackerGUI_StatsSubframe, "TOPLEFT", (15 + 120 * entryNr ), (-295 + 15 * line))
  --        TemplateAttendanceStatsFontString[entryNr]:SetFont("Fonts\\FRIZQT__.TTF", 9)
  --        TemplateAttendanceStatsFontString[entryNr]:SetWidth(200)
  --        TemplateAttendanceStatsFontString[entryNr]:SetJustifyH("LEFT")
  --      end
  --      TemplateAttendanceStatsFontString[entryNr]:SetText(text)
  --      TemplateAttendanceStatsFontString[entryNr]:SetTextColor(RaidTrackerGUI_GetClassClolor(v.class))
  --      
  --      line = line + 1
  --    end
  --  end
  --  entryNr = entryNr + 1
  --end
  
end

