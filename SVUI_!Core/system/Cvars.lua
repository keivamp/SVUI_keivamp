--[[
###############
SVUI: keivamp#
###############
]]--
local function keivampCvars()	
		SetCVar("autoLootDefault",1);
		SetCVar("buffDurations",1);
		SetCVar("predictedHealth",1);
		SetCVar("countdownForCooldowns",1);
		SetCVar("NameplatePersonalShowAlways",0);
		SetCVar("NameplatePersonalShowInCombat",0);
		SetCVar("NameplatePersonalShowWithTarget",0);
		SetCVar("showNPETutorials", 0)
		SetCVar("showTutorials",0);				
end
local function HelpFrames()	
		for i = 1, NUM_LE_FRAME_TUTORIALS do
		C_CVar.SetCVarBitfield("closedInfoFrames", i, true)
		end
		for i = 1, NUM_LE_FRAME_TUTORIAL_ACCCOUNTS do
			C_CVar.SetCVarBitfield("closedInfoFramesAccountWide", i, true)
		end		
end

local SVUILoginFrame=CreateFrame("Frame")
		SVUILoginFrame:RegisterEvent("PLAYER_LOGIN")
		SVUILoginFrame:RegisterEvent("CINEMATIC_STOP")
		SVUILoginFrame:SetScript("OnEvent", function(self, event) 
			keivampCvars()	
			HelpFrames()
		end)