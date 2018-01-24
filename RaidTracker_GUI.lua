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
  local sortTable = {Druid = {}, Hunter = {}, Mage = {}, Paladin = {}, Priest = {}, Rogue = {}, Shaman = {}, Warlock = {}, Warrior = {}}
  
  raidDate = this:GetID()
  currentlySelectedRaid = raidDate
  
  for k, v in pairs(RaidAttendance[raidDate].member) do
    table.insert(sortTable[v.class], k)
  end
  
  for k, v in pairs(sortTable) do
    table.sort(v)
  end
  
  for w, v in pairs(sortTable) do
      for l, k in pairs(v) do
  
      if line > 19 then
        line = 0
        row = row + 1
      end
      if TemplateRaidMemberFontString[raidMember] == nil then
        -- define FintString template for raid participants names
        TemplateRaidMemberFontString[raidMember] = RaidTrackerGUI_MemberListSubframe:CreateFontString(nil, "OVERLAY")
        TemplateRaidMemberFontString[raidMember]:SetPoint("TOPLEFT", RaidTrackerGUI_MemberListSubframe, "TOPLEFT", (15 + row * 152), (-8 - 15 * line))
        TemplateRaidMemberFontString[raidMember]:SetFont("Fonts\\FRIZQT__.TTF", 9)
        TemplateRaidMemberFontString[raidMember]:SetWidth(200)
        TemplateRaidMemberFontString[raidMember]:SetJustifyH("LEFT")
      end
      TemplateRaidMemberFontString[raidMember]:SetText(k)
      TemplateRaidMemberFontString[raidMember]:SetTextColor(RaidTrackerGUI_GetClassClolor(RaidAttendance[raidDate].member[k].class))
      
      raidMember = raidMember + 1
      line = line + 1
    end
  end
  fontStringListLength = RaidTrackerGUI_MemberListSubframe:GetNumRegions()
  for i = raidMember, fontStringListLength - 8, 1 do
    TemplateRaidMemberFontString[i]:SetText("")
  end
  
    --update tag dropdown menu
  if RaidAttendance[currentlySelectedRaid].tag == nil then
    RaidAttendance[currentlySelectedRaid].tag = ""
  end
  UIDropDownMenu_SetSelectedValue(RaidTrackerGUI_TagDropDown, RaidAttendance[currentlySelectedRaid].tag) --RaidAttendance[currentlySelectedRaid].tag);
  --RaidTrackerGUI_TagDropDown:Show()
  
  RaidTrackerGUI_RaidlistCreatorFontstring:Show()
  RaidTrackerGUI_RaidlistCreatorFontstring:SetText("Creator: " .. RaidAttendance[raidDate].creator)
end

-- update list of all raids
function RaidTrackerUI_UpdateRaidlist()
  local raidNr = 1
  local sortTable = {}
  
  for k, v in pairs(RaidAttendance) do
    table.insert(sortTable, v.date)
  end
  table.sort(sortTable, function(a,b) return a>b end)
  
  
  --for k, v in pairs(RaidAttendance) do
  for k, v in pairs(sortTable) do
    local line = date("%a %d.%m.%y", v) .. " - " .. RaidAttendance[v].zone
    
    -- align text to left
    for l = 1, (38.5 - string.len(line)) do
         line = line .. " "
    end
    
    if RaidlistFontStringButton[raidNr] == nil then
    
      RaidlistFontStringButton[raidNr] = CreateFrame("Button",nil,RaidTrackerGUI_RaidListSubframe)
      RaidlistFontStringButton[raidNr]:SetPoint("TOPLEFT",RaidTrackerGUI_RaidListSubframe, "TOPLEFT", 3 , (12 - 15 * raidNr))
      RaidlistFontStringButton[raidNr]:SetWidth(208)
      RaidlistFontStringButton[raidNr]:SetHeight(15)
      RaidlistFontStringButton[raidNr]:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background"})
      RaidlistFontStringButton[raidNr]:SetScript("OnClick", RaidTrackerUI_SelectDate)
      RaidlistFontStringButton[raidNr]:SetFont("Interface\\AddOns\\RaidTracker\\fonts\\Anonymous Pro.ttf", 9)
      RaidlistFontStringButton[raidNr]:SetText(line)
      RaidlistFontStringButton[raidNr]:SetID(v)
    else
      RaidlistFontStringButton[raidNr]:SetText(line)
      RaidlistFontStringButton[raidNr]:SetID(v)
    end        
        
       -- not needed with new font
--    TemplateRaidlistFontString = RaidTrackerGUI_RaidListSubframe:CreateFontString(nil, "OVERLAY")
--    TemplateRaidlistFontString:SetPoint("TOPLEFT", RaidTrackerGUI_RaidListSubframe, "TOPLEFT", 5, (10 - 15 * raidNr))
--    TemplateRaidlistFontString:SetFont("Fonts\\FRIZQT__.TTF", 9)
--    TemplateRaidlistFontString:SetWidth(206)
--    TemplateRaidlistFontString:SetJustifyH("LEFT")
--    TemplateRaidlistFontString:SetText(line)
--    
--    
--    if RaidlistFontStringButton[raidNr] == nil then
--      --DummyFrame = CreateFrame("Frame",nil,RaidTrackerGUI_RaidListSubframe) -- create frame to ?
--      --DummyFrame:Hide()
--    
--      RaidlistFontStringButton[raidNr] = CreateFrame("Button",nil,RaidTrackerGUI_RaidListSubframe)
--      RaidlistFontStringButton[raidNr]:SetPoint("TOPLEFT",RaidTrackerGUI_RaidListSubframe, "TOPLEFT", 3 , (12 - 15 * raidNr))
--      RaidlistFontStringButton[raidNr]:SetWidth(206)
--      RaidlistFontStringButton[raidNr]:SetHeight(15)
--      RaidlistFontStringButton[raidNr]:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background"})
--      RaidlistFontStringButton[raidNr]:SetScript("OnClick", RaidTrackerUI_SelectDate)
--      RaidlistFontStringButton[raidNr]:SetFont("Fonts\\FRIZQT__.TTF", 9)
--      RaidlistFontStringButton[raidNr]:SetFontString(TemplateRaidlistFontString)
--      RaidlistFontStringButton[raidNr]:SetID(v.date)
--    else
--      RaidlistFontStringButton[raidNr]:SetFontString(TemplateRaidlistFontString)
--      RaidlistFontStringButton[raidNr]:SetID(v.date)
--    end
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
end
-- Populate the RaidTrackerGUI_PopupTagDropDown menue
function RaidTrackerGUI_PopupTagDropDown_Fill()
  for k, v in pairs(raidTags) do
    if v ~= "" then
      UIDropDownMenu_AddButton{ text = v; func = RaidTracker_PopupAddTag; value = v};
    end
  end
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

function RaidTrackerUI_HideAllTabs()
    RaidTrackerGUI_MemberListSubframe:Hide()
    RaidTrackerGUI_RaidListSubframe:Hide()
    RaidTrackerGUI_TagDropDown:Hide()
    RaidTrackerGUI_StatsSubframe:Hide()
    RaidTrackerGUI_FiltersSubframe:Hide()
end


function RaidTrackerGUI_Initialize()
  if RaidAttendance ~= nil then
    RaidTrackerUI_UpdateRaidlist()
  end
end

function RaidTrackerGUI_GetClassClolor(class)
  if class == "Warlock"  then
    return 0.58, 0.51, 0.79,1
  elseif class == "Druid"  then
    return 1.00, 0.49, 0.04,1
  elseif class == "Rogue"  then
    return 1.00, 0.96, 0.41,1
  elseif class == "Hunter"  then
    return 0.67, 0.83, 0.45,1
  elseif class == "Mage"  then
    return 0.41, 0.80, 0.94,1
  elseif class == "Shaman"  then
    return 0.00, 0.44, 0.87,1
  elseif class == "Priest"  then
    return 1.00, 1.00, 1.00,1
  elseif class == "Paladin"  then
    return 0.96, 0.55, 0.73,1
  elseif class == "Warrior"  then
    return 0.78, 0.61, 0.43,1
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