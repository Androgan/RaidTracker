-- ----------------------------------------------------------------------------
-- RaidTracker GUI for viewing recorded Raids
-- ----------------------------------------------------------------------------

currentlySelectedRaid = ""
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
  currentlySelectedRaid = raidDate
  
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
  
  --update tag dropdown menu
  --local checking = RaidTrackerGUI_TagDropDown:GetBackdrop()
  --for k, v in pairs(checking) do
  --  if type(v) == "table" then
  --    pPrint("Table: " .. k)
  --    for l, w in pairs(checking) do
  --      pPrint("   Key: " .. l .. " Value: " .. w)
  --    end
  --  else
  --    pPrint("Key: " .. k .. " Value: " .. v)
  --  end
  --end
  --\test
  if RaidAttendance[currentlySelectedRaid].tag == nil then
    pPrint("No Tag ")
    RaidAttendance[currentlySelectedRaid].tag = ""
  end
  UIDropDownMenu_SetSelectedValue(RaidTrackerGUI_TagDropDown, RaidAttendance[currentlySelectedRaid].tag) --RaidAttendance[currentlySelectedRaid].tag);
  RaidTrackerGUI_TagDropDown:Show()
end

-- update list of all raids
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
-- Populate the RaidTrackerGUI_TagDropDown menue
function RaidTrackerGUI_TagDropDown_Fill()
  for k, v in pairs(raidTags) do
    UIDropDownMenu_AddButton{ text = v; func = RaidTracker_AddTag; value = v};
  end
    --UIDropDownMenu_AddButton{ text = "Healing (Green)"; func = QuickHeal_ComboBoxMessageConfigure_Click; value = "Healing" };
    --UIDropDownMenu_AddButton{ text = "Info (Blue)"; func = QuickHeal_ComboBoxMessageConfigure_Click; value = "Info" };
    --UIDropDownMenu_AddButton{ text = "Blacklist (Yellow)"; func = QuickHeal_ComboBoxMessageConfigure_Click; value = "Blacklist" };
    --UIDropDownMenu_AddButton{ text = "Error (Red)"; func = QuickHeal_ComboBoxMessageConfigure_Click; value = "Error" };
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