--[[
########################
keivamp's quest tracker#
########################
]]--

local playerColor = RAID_CLASS_COLORS[select(2, UnitClass('player'))]
local InkedColors = {r = playerColor.r * 0.95, g = playerColor.g * 0.95,b = playerColor.b * 0.95,a = 1}

local function SetQuestFrame()

	 

	ObjectiveTrackerFrame.HeaderMenu.Title:SetFontObject(SVUI_Font_Header)
	ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetFontObject(SVUI_Font_Header)

				ObjectiveTrackerFrame.HeaderMenu.Title:SetTextColor(.41,.80,.85)

	
	ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:SetScale(1.35)
	ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:ClearAllPoints() 
	ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:SetPoint("TOPRIGHT", ObjectiveTrackerFrame.HeaderMenu,100,7)


	ObjectiveTrackerBlocksFrame:SetScale(1)
	ObjectiveTrackerBlocksFrame:SetPoint("TOPLEFT", Minimap,"TOPLEFT", -50, -345)
	ObjectiveTrackerBlocksFrame:SetClampedToScreen(true)
	ObjectiveTrackerBlocksFrame:SetClampRectInsets(0, 0, 0,0)

end

local QTF = ObjectiveTrackerFrame

local function moveQuestObjectiveItems(self)
 
	local a = {self:GetPoint()}  
	self:ClearAllPoints()
	self:SetPoint("LEFT", a[2], "LEFT", -50, 0)
	self:SetScale(1.1)
	self:SetFrameLevel(50)
end

local qitime = 0
local qiinterval = 1

hooksecurefunc("QuestObjectiveItem_OnUpdate", function(self, elapsed)
   	qitime = qitime + elapsed
	moveQuestObjectiveItems(self)
    qitime = 0
end)

    if IsAddOnLoaded("Blizzard_ObjectiveTracker") then
        hooksecurefunc("ObjectiveTracker_Update", function(reason, id)
		
            if QTF.MODULES then  
                for i = 1, #QTF.MODULES do  
					QTF.MODULES[i].Header.MinimizeButton:SetScale(1.25)	
					QTF.MODULES[i].Header.MinimizeButton:ClearAllPoints() 	
					QTF.MODULES[i].Header.MinimizeButton:SetPoint("RIGHT", QTF.MODULES[i].Header, 85,0)	
					QTF.MODULES[i].Header:SetSize(50,25)				
		            QTF.MODULES[i].Header.Background:SetAtlas(nil)
		            QTF.MODULES[i].Header.Text:SetFontObject(SVUI_Font_Header)
		            QTF.MODULES[i].Header.Text:ClearAllPoints()
		            QTF.MODULES[i].Header.Text:SetPoint("Left", QTF.MODULES[i].Header, 0, 0)
					
								QTF.MODULES[i].Header.Text:SetTextColor(.41,.80,.85)
					
		            QTF.MODULES[i].Header.Text:SetJustifyH("Left")
	            end
	        end
	    end)
	end
     
local QuestLevelPatch = {}

function SetBlockHeader_hook()
	
	-- for i = 1, C_QuestLog.GetNumWorldQuestWatches() do
		-- local questID, title, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(i)
		-- if ( not questID ) then
			-- break
		-- end
		-- local oldBlock = QUEST_TRACKER_MODULE:GetExistingBlock(questID)
		-- if oldBlock then
			-- local oldHeight = QUEST_TRACKER_MODULE:SetStringText(oldBlock.HeaderText, title, nil, OBJECTIVE_TRACKER_COLOR["Header"])
			-- local newTitle = "["..select(2, GetQuestLogTitle(questLogIndex)).."] "..title
			-- local newHeight = QUEST_TRACKER_MODULE:SetStringText(oldBlock.HeaderText, newTitle, nil, OBJECTIVE_TRACKER_COLOR["Header"])

		-- end
	-- end
end
hooksecurefunc(QUEST_TRACKER_MODULE, "Update", SetBlockHeader_hook)

    local QTFBoss = CreateFrame("Frame", nil)
    QTFBoss:RegisterEvent("PLAYER_ENTERING_WORLD")
	QTFBoss:RegisterEvent("CINEMATIC_STOP")
    QTFBoss:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
    QTFBoss:RegisterEvent("UNIT_TARGETABLE_CHANGED")
    QTFBoss:RegisterEvent("PLAYER_REGEN_ENABLED")
    --QTFBoss:RegisterEvent("UPDATE_WORLD_STATES")

    local function bossexists()
	    for i = 1, MAX_BOSS_FRAMES do
		    if UnitExists("boss"..i) then
			    return true
		    end
	    end
    end

    QTFBoss:SetScript("OnEvent", function(self, event)
        local _, instanceType = IsInInstance()
        local bar = _G["WorldStateCaptureBar1"]
        
	    if instanceType=="raid" and bossexists() then
		    if not QTF.collapsed then
			    ObjectiveTracker_Collapse()
		    end

	    elseif instanceType=="arena" or instanceType=="pvp" then
            if not QTF.collapsed then
			    ObjectiveTracker_Collapse()
		    end

		elseif bar and bar:IsVisible() then
		    if not QTF.collapsed then
			    ObjectiveTracker_Collapse()
		    end

	    elseif QTF.collapsed and instanceType=="raid" and not InCombatLockdown() then
		    ObjectiveTracker_Expand()
		
	    end

    end)

	ObjectiveTrackerFrame:HookScript("OnUpdate", SetQuestFrame)
