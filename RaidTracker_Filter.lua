-- ----------------------------------------------------------------------------
-- RaidTracker Filter for filtering different statistics
-- ----------------------------------------------------------------------------
local FilterFrame = {}
local filtersCreated = false

filterList = {
  [1] = {
    ["filterName"] = "All Raids\nGuildRaids",
    ["filterZone"] = {
      "The Molten Core",
      "Onyxia's Lair",
      "Blackwing Lair",
      "Zul'Gurub",
      "Ruins of Ahn'Qiraj",
      "The Temple of Ahn'Qiraj",
      "Naxxramas",
    },
    ["filterTag"] = {
      "Guild Raid"
    },
  },
  [2] = {
    ["filterName"] = "Ahn'Qiraj\nGuildRaid",
    ["filterZone"] = {
      "Ahn'Qiraj",
    },
    ["filterTag"] = {
      "Guild Raid"
    },
  },
  [3] = {
    ["filterName"] = "Blackwing Lair\nGuildRaid",
    ["filterZone"] = {
      "Blackwing Lair",
    },
    ["filterTag"] = {
      "Guild Raid"
    },
  },
  [4] = {
    ["filterName"] = "The Molten Core\nGuildRaid",
    ["filterZone"] = {
      "The Molten Core",
    },
    ["filterTag"] = {
      "Guild Raid"
    },
  },
  [5] = {
    ["filterName"] = "Ahn'Qiraj + Blackwing Lair\nGuildRaid",
    ["filterZone"] = {
      "Ruins of Ahn'Qiraj",      
      "Blackwing Lair",
    },
    ["filterTag"] = {
      "Guild Raid"
    },
  },
  [6] = {
    ["filterName"] = "Ruins of Ahn'Qiraj\nGuildRaid",
    ["filterZone"] = {
      "Ruins of Ahn'Qiraj",
    },
    ["filterTag"] = {
      "Guild Raid"
    },
  },
  [7] = {
    ["filterName"] = "Zul'Gurub\nGuildRaid",
    ["filterZone"] = {
      "Zul'Gurub",
    },
    ["filterTag"] = {
      "Guild Raid"
    },
  },
}









function RaidTrackerUI_CreateFilters()


  if not filtersCreated then
      for k, v in pairs(filterList) do
        RaidTrackerUI_CreateFilterFrame(k)
      end
      filtersCreated = true
  end



end


function RaidTrackerUI_CreateFilterFrame(filterNr)

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
  FilterFrame[filterNr]:SetFont("Fonts\\FRIZQT__.TTF", 11)
  FilterFrame[filterNr]:SetText(filterList[filterNr].filterName)
  FilterFrame[filterNr]:SetID(filterNr)



end