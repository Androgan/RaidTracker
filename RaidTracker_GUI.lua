-- ----------------------------------------------------------------------------
-- RaidTracker GUI for viewing recorded Raids
-- ----------------------------------------------------------------------------

local TemplateRaidMemberFontString = {}
local RaidlistFontStringButton = {}

-- update raid participants
function RaidTrackerUI_SelectDate()
  local raidDate = ""
  local raidMember = 1
  local line = 0
  local row = 0
  local fontStringListLength = 0

  raidDate = string.sub(this:GetText(),0, 17)
  
  for k, v in pairs(RaidAttendance[raidDate].member) do
    if TemplateRaidMemberFontString[raidMember] == nil then
      if line > 19 then
        line = 0
        row = row + 1
      end
      -- define FintString template for raid participants names
      TemplateRaidMemberFontString[raidMember] = RaidTrackerGUI_MemberListSubframe:CreateFontString(nil, "OVERLAY")
      TemplateRaidMemberFontString[raidMember]:SetPoint("TOPLEFT", RaidTrackerGUI_MemberListSubframe, "TOPLEFT", (15 + row * 152), (-8 - 15 * line))
      TemplateRaidMemberFontString[raidMember]:SetFont("Fonts\\FRIZQT__.TTF", 9)
      TemplateRaidMemberFontString[raidMember]:SetWidth(200)
      TemplateRaidMemberFontString[raidMember]:SetJustifyH("LEFT")
      TemplateRaidMemberFontString[raidMember]:SetText(k)
    else
      TemplateRaidMemberFontString[raidMember]:SetText(k)
    end
    raidMember = raidMember + 1
    line = line + 1
  end
  
  fontStringListLength = RaidTrackerGUI_MemberListSubframe:GetNumRegions()
  for i = raidMember, fontStringListLength - 8, 1 do
    TemplateRaidMemberFontString[i]:SetText("")
  end
end

function RaidTrackerUI_UpdateRaidlist()
  local raidNr = 1
  local DummyFrame = nil
  
  for k, v in pairs(RaidAttendance) do
    local line = v.date .. " - " .. v.zone
    
    local TemplateRaidlistFontString = RaidTrackerGUI_RaidListSubframe:CreateFontString(nil, "OVERLAY")
    TemplateRaidlistFontString:SetPoint("TOPLEFT", RaidTrackerGUI_RaidListSubframe, "TOPLEFT", 5, (10 - 15 * raidNr))
    TemplateRaidlistFontString:SetFont("Fonts\\FRIZQT__.TTF", 9)
    TemplateRaidlistFontString:SetWidth(206)
    TemplateRaidlistFontString:SetJustifyH("LEFT")
    TemplateRaidlistFontString:SetText(line)
    
    if RaidlistFontStringButton[raidNr] == nil then
      DummyFrame = CreateFrame("Frame",nil,RaidTrackerGUI_RaidListSubframe) -- create frame to ?
      DummyFrame:Hide()
    
      RaidlistFontStringButton[raidNr] = CreateFrame("Button",nil,RaidTrackerGUI_RaidListSubframe)
      RaidlistFontStringButton[raidNr]:SetPoint("TOPLEFT",RaidTrackerGUI_RaidListSubframe, "TOPLEFT", 3 , (12 - 15 * raidNr))
      RaidlistFontStringButton[raidNr]:SetWidth(206)
      RaidlistFontStringButton[raidNr]:SetHeight(15)
      RaidlistFontStringButton[raidNr]:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background"})
      RaidlistFontStringButton[raidNr]:SetScript("OnClick",  RaidTrackerUI_SelectDate)
      RaidlistFontStringButton[raidNr]:SetFont("Fonts\\FRIZQT__.TTF", 9)
      RaidlistFontStringButton[raidNr]:SetFontString(TemplateRaidlistFontString)
    else
      RaidlistFontStringButton[raidNr]:SetFontString(TemplateRaidlistFontString)
    end
    raidNr = raidNr + 1
  end
end

-- ----------------------------------------------------------------------------
-- UI Element Creation
-- ----------------------------------------------------------------------------


-- ----------------------------------------------------------------------------
-- Helper
-- ----------------------------------------------------------------------------

function RaidTrackerUI_TestButton()
  pPrint("Test button")
end

function RaidTrackerUI_ToggleRaidTrackerWindow()
  if RaidTrackerGUI:IsVisible() then
    RaidTrackerGUI:Hide();
  else
    RaidTrackerGUI:Show();
  end
end

function RaidTrackerUI_UpdateRelativePosition(obj, parent, strName)
  local x = 0
  local y = 0
  local a = 0
  local b = 0
  
  x, y = obj:GetCenter()
  a, b = parent:GetCenter()
  x = x - a
  y = y - b
  x = math.floor(x)
  y = math.floor(y)
  getglobal(strName):SetText(x .. " | " ..  y)
end