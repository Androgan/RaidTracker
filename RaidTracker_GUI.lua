-- ----------------------------------------------------------------------------
-- RaidTracker GUI for viewing recorded Raids
-- ----------------------------------------------------------------------------

local TemplateRaidMemberFontString = {}
local RaidlistFontStringButton = {}

-- update raid participants
function RaidTrackerUI_SelectDate()
  local raidDate = ""
  local raidMember = 1
  local fontStringListLength = 0

  raidDate = string.sub(this:GetText(),0, 17)
  
  for k, v in pairs(RaidAttendance[raidDate].member) do
    if TemplateRaidMemberFontString[raidMember] == nil then
      -- define FintString template for raid participants names
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

function RaidTrackerUI_UpdateRaidlist()
  local raidNr = 1
  local DummyFrame = nil
  
  for k, v in pairs(RaidAttendance) do
    local line = v.date .. " - " .. v.zone
    
    local TemplateRaidlistFontString = RaidTrackerGUI:CreateFontString(nil, "OVERLAY")
    TemplateRaidlistFontString:SetPoint("LEFT", RaidTrackerGUI, "CENTER", -290, (110 - 15 * raidNr))
    TemplateRaidlistFontString:SetFont("Fonts\\FRIZQT__.TTF", 9)
    TemplateRaidlistFontString:SetWidth(200)
    TemplateRaidlistFontString:SetJustifyH("LEFT")
    TemplateRaidlistFontString:SetText(line)
    
    if RaidlistFontStringButton[raidNr] == nil then
      DummyFrame = CreateFrame("Frame",nil,RaidTrackerGUI) -- create frame to ?
      DummyFrame:Hide()
    
      RaidlistFontStringButton[raidNr] = CreateFrame("Button",nil,RaidTrackerGUI)
      RaidlistFontStringButton[raidNr]:SetPoint("LEFT",RaidTrackerGUI, "CENTER", -290 , (110 - 15 * raidNr))
      RaidlistFontStringButton[raidNr]:SetWidth(200)
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

function RaidTrackerUI_CreateRaidMemberListFrame()
  RaidMemberListFrame = CreateFrame("Frame","RaidMemberListFrame",RaidTrackerGUI, RaidTrackerGUI)
  RaidMemberListFrame:SetPoint("TOPLEFT",RaidTrackerGUI, "CENTER", -40 , 110)
  RaidMemberListFrame:SetWidth(250)
  RaidMemberListFrame:SetHeight(300)
  RaidMemberListFrame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background"})
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