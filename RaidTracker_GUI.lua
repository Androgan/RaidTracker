-- ----------------------------------------------------------------------------
-- RaidTracker GUI for viewing recorded Raids
-- ----------------------------------------------------------------------------

-- update raid participants
function RaidTrackerUI_SelectDate()
  local raidDate = ""
  local raidMember = 1
  local fontStringListLength = 0

  raidDate = string.sub(this:GetText(),0, 17)
  
  for k, v in pairs(RaidAttendance[raidDate].member) do
    if TemplateRaidMemberFontString[raidMember] == nil then
      TemplateRaidMemberFontString[raidMember] = RaidMemberListFrame:CreateFontString(nil, "OVERLAY")
      TemplateRaidMemberFontString[raidMember]:SetPoint("LEFT", RaidTrackerGUI, "CENTER", -40, (110 - 15 * raidMember))
      TemplateRaidMemberFontString[raidMember]:SetFont("Fonts\\FRIZQT__.TTF", 9)
      TemplateRaidMemberFontString[raidMember]:SetWidth(200)
      TemplateRaidMemberFontString[raidMember]:SetJustifyH("LEFT")
      TemplateRaidMemberFontString[raidMember]:SetText(k)
    else
      TemplateRaidMemberFontString[raidMember]:SetText(k)
    end
    raidMember = raidMember + 1
  end
  
  fontStringListLength = RaidMemberListFrame:GetNumRegions()
  for i = raidMember, fontStringListLength - 1, 1 do
    TemplateRaidMemberFontString[i]:SetText("")
  end
end

-- ----------------------------------------------------------------------------
-- UI Element Creation
-- ----------------------------------------------------------------------------

function RaidTrackerUI_CreateWindowRaidlist()
  local offset = 0
  for k, v in pairs(RaidAttendance) do
    local line = v.date .. " - " .. v.zone
    RaidTrackerUI_CreateFontstring(line, "-290", 100 - offset)
    offset = offset + 15
  end
end

function RaidTrackerUI_CreateRaidMemberListFrame()
  RaidMemberListFrame = CreateFrame("Frame","RaidMemberListFrame",RaidTrackerGUI, RaidTrackerGUI)
  RaidMemberListFrame:SetPoint("TOPLEFT",RaidTrackerGUI, "CENTER", -40 , 110)
  RaidMemberListFrame:SetWidth(250)
  RaidMemberListFrame:SetHeight(300)
  RaidMemberListFrame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background"})
  TemplateRaidMemberFontString = {}
end

function RaidTrackerUI_CreateFontstring(text, x, y)
  local DummyFrame = nil
  
  DummyFrame = CreateFrame("Frame",nil,RaidTrackerGUI)
  DummyFrame:Hide()
  
  local TemplateFontString = DummyFrame:CreateFontString(nil, "OVERLAY", RaidTrackerGUI)
  TemplateFontString:SetPoint("LEFT", RaidTrackerGUI, "CENTER", x, y)
  TemplateFontString:SetFont("Fonts\\FRIZQT__.TTF", 9)
  TemplateFontString:SetWidth(200)
  TemplateFontString:SetJustifyH("LEFT")
  TemplateFontString:SetText(text)
  
  local TemplateFrame = CreateFrame("Button",nil,RaidTrackerGUI)
  TemplateFrame:SetPoint("LEFT",RaidTrackerGUI, "CENTER", x , y)
  TemplateFrame:SetWidth(200)
  TemplateFrame:SetHeight(15)
  TemplateFrame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background"})
  TemplateFrame:SetScript("OnClick",  RaidTrackerUI_SelectDate)
  TemplateFrame:SetFont("Fonts\\FRIZQT__.TTF", 9)
  TemplateFrame:SetFontString(TemplateFontString)
end

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