-- contains all functions for RaidTracker UI 

function RaidTrackerUI_TestButton()
	pPrint("Test button")

end


function RaidTrackerUI_CreateWindowRaidlist()	
	local offset = 0
	for k, v in pairs(RaidAttendance) do
		local line = v.date .. " - " .. v.zone
		RaidTrackerUI_CreateFontstring( line, "-290", 100 - offset )
		offset = offset + 15
	end
end

 
 
-- update raid participants
function RaidTrackerUI_SelectDate()
	local raidDate = string.sub(this:GetText(),0, 17)
	local raidMember = 1
	pPrint(raidDate)
	pPrint(RaidAttendance[raidDate].zone)
	
	for k, v in pairs(RaidAttendance[raidDate].member) do
		if TemplateRaidMemberFontString[raidMember] == nil then
			TemplateRaidMemberFontString[raidMember] = RaidMemberListFrame:CreateFontString(nil, "OVERLAY")
			TemplateRaidMemberFontString[raidMember]:SetPoint("LEFT", RaidTrackerGUI, "CENTER", -40, (60 + 15 * raidMember))
			TemplateRaidMemberFontString[raidMember]:SetFont("Fonts\\FRIZQT__.TTF", 9)
			TemplateRaidMemberFontString[raidMember]:SetWidth(200)
			TemplateRaidMemberFontString[raidMember]:SetJustifyH("LEFT")
			TemplateRaidMemberFontString[raidMember]:SetText(k)
		else
			TemplateRaidMemberFontString[raidMember]:SetText(k)
		end
		raidMember = raidMember + 1
	end
end 
 
-- construct elements UI

function RaidTrackerUI_CreateRaidMemberListFrame()
	
	RaidMemberListFrame = CreateFrame("Frame",RaidMemberListFrame,RaidTrackerGUI)
	RaidMemberListFrame:SetPoint("TOPLEFT",RaidTrackerGUI, "CENTER", -40 , 110)
	RaidMemberListFrame:SetWidth(250)
	RaidMemberListFrame:SetHeight(300)
	RaidMemberListFrame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background"})
	TemplateRaidMemberFontString = {}
	
	
	
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


--	["01/06/18 17:54:54"] = {
--		["zone"] = "Ironforge",
--		["date"] = "01/06/18 17:54:54",
--		["member"] = {
--			["Earnil"] = true,
--			["Androgan"] = true,
--		},
--	},