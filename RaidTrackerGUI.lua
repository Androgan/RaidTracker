-- contains all functions for RaidTracker UI 





function RaidTrackerUI_TestButton()
	
	pPrint("Test button")
	--RaidTrackerUI_CreateFontstring("TestString 1", "-180", "100")
	--RaidTrackerUI_CreateFontstring("TestString 2", "-180", "85")
	
	local offset = 0
	for k, v in pairs(RaidAttendance) do
		local line = v.date .. " - " .. v.zone
		RaidTrackerUI_CreateFontstring( line, "-290", 100 - offset )
		offset = offset + 15
	end
	--printTableVals(RaidAttendance)
end

function empty()

  for k, v in pairs(tbl) do
    pPrint(k);
  end
  end
  
function RaidTrackerUI_CreateFontstring(text, x, y)
	
	local DummyFrame = CreateFrame("Frame",nil,RaidTrackerGUI)
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
	TemplateFrame:SetScript("OnClick",  RaidTrackerUI_SelectDate )	
	TemplateFrame:SetFont("Fonts\\FRIZQT__.TTF", 9)
	TemplateFrame:SetFontString(TemplateFontString)


 
end

function RaidTrackerUI_SelectDate()
	pPrint(this:GetText())
end

--	["01/06/18 17:54:54"] = {
--		["zone"] = "Ironforge",
--		["date"] = "01/06/18 17:54:54",
--		["member"] = {
--			["Earnil"] = true,
--			["Androgan"] = true,
--		},
--	},