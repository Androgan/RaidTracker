-- ----------------------------------------------------------------------------
-- RaidTracker Filter for filtering different statistics
-- ----------------------------------------------------------------------------
local FilterFrame = {}
local filtersCreated = false

TheMoltenCore = 409
OnyxiasLair = 249
BlackwingLair = 469
ZulGurub = 309
RuinsOfAhnQiraj = 509
TempleOfAhnQiraj = 531
Naxxramas = 533

filterList = {
  [1] = {
    ["filterName"] = "All Raids\nGuildRaids",
    ["filterZone"] = {
      TheMoltenCore,
      OnyxiasLair,
      BlackwingLair,
      ZulGurub,
      RuinsOfAhnQiraj,
      TempleOfAhnQiraj,
      Naxxramas,
    },
    ["filterTag"] = {
      "Guild Raid"
    },
  },
  [2] = {
    ["filterName"] = "The Molten Core\nGuildRaid",
    ["filterZone"] = {
      TheMoltenCore,
    },
    ["filterTag"] = {
      "Guild Raid"
    },
  },
  [3] = {
    ["filterName"] = "Blackwing Lair\nGuildRaid",
    ["filterZone"] = {
      BlackwingLair,
    },
    ["filterTag"] = {
      "Guild Raid"
    },
  },
  [4] = {
    ["filterName"] = "Ahn'Qiraj\nGuildRaid",
    ["filterZone"] = {
      TempleOfAhnQiraj,
    },
    ["filterTag"] = {
      "Guild Raid"
    },
  },
  [5] = {
    ["filterName"] = "Onyxia's Lair\nGuildRaid",
    ["filterZone"] = {
      OnyxiasLair,
    },
    ["filterTag"] = {
      "Guild Raid"
    },
  },
  [6] = {
    ["filterName"] = "Blackwing Lair + Ahn'Qiraj\nGuildRaid",
    ["filterZone"] = {
      BlackwingLair,
      TempleOfAhnQiraj,
    },
    ["filterTag"] = {
      "Guild Raid"
    },
  },
  [7] = {
    ["filterName"] = "Ruins of Ahn'Qiraj\nGuildRaid",
    ["filterZone"] = {
      RuinsOfAhnQiraj,
    },
    ["filterTag"] = {
      "Guild Raid"
    },
  },
  [8] = {
    ["filterName"] = "Zul'Gurub\nGuildRaid",
    ["filterZone"] = {
      ZulGurub,
    },
    ["filterTag"] = {
      "Guild Raid"
    },
  },
  [9] = {
    ["filterName"] = "Naxxramas\nGuildRaid",
    ["filterZone"] = {
      Naxxramas,
    },
    ["filterTag"] = {
      "Guild Raid"
    },
  },
}


function RaidTrackerUI_CreateFilters(self)
  if not filtersCreated then
      for k, v in pairs(filterList) do
        RaidTrackerUI_CreateFilterFrame(self, k)
      end
      filtersCreated = true
  end
end


function RaidTrackerUI_CreateFilterFrame(self, filterNr)
  local fontString
  local row = math.floor( (filterNr - 1) / 4)
  local backdrop = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 8,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
  }
  
  FilterFrame[filterNr] = CreateFrame("Button",nil,RaidTrackerGUI_FiltersSubframe)
  FilterFrame[filterNr]:SetPoint("TOPLEFT",RaidTrackerGUI_FiltersSubframe, "TOPLEFT", (-150 +156 * filterNr - (624*row)) , (-18 -55 * row))
  FilterFrame[filterNr]:SetWidth(150)
  FilterFrame[filterNr]:SetHeight(50)
  FilterFrame[filterNr]:SetBackdrop(backdrop)
  FilterFrame[filterNr]:SetScript("OnClick", RaidTrackerUI_UpdateStats)
  fontString = FilterFrame[filterNr]:CreateFontString("HIGHLIGHT")
  fontString:SetFont("Fonts\\FRIZQT__.TTF", 10)
  fontString:SetPoint("CENTER")
  fontString:SetText(filterList[filterNr].filterName)
  FilterFrame[filterNr].Text = fontString
  FilterFrame[filterNr]:SetID(filterNr)
end