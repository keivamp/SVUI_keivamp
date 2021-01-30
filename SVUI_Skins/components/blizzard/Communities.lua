--[[
##############################################################################
S V U I   By: Munglunch
##############################################################################
--]]
--[[ GLOBALS ]]--
local _G = _G;
local unpack  	= _G.unpack;
local select  	= _G.select;
local ipairs  	= _G.ipairs;
local pairs   	= _G.pairs;
local type 		= _G.type;
--[[ ADDON ]]--
local SV = _G['SVUI'];
local L = SV.L;
local MOD = SV.Skins;
local Schema = MOD.Schema;
--[[
##########################################################
HELPERS
##########################################################
]]--
local CommunitiesFrameList = {
	"CommunitiesFrame"
	
};
local CommunitiesTextureList = {
--	"ClassTrainerFrameInset",
--	"ClassTrainerFramePortrait"

};
--[[
##########################################################
Communities MODR
##########################################################
]]--
local function GuildFrameStyle()
	if SV.db.Skins.blizzard.enable ~= true or SV.db.Skins.blizzard.guild ~= true then
		return
	end


	 SV.API:Set("Window", CommunitiesFrame, true,true)
	 SV.API:Set("CloseButton", CommunitiesFrameCloseButton)

	local InviteButton = CommunitiesFrame.InviteButton
	SV.API:Set("Button", InviteButton)
	
	local GRButton = CommunitiesFrame.CommunitiesControlFrame.GuildRecruitmentButton
	SV.API:Set("Button", GRButton)
	
	local RecruitmentDialog = CommunitiesFrame.RecruitmentDialog
	SV.API:Set("Window", RecruitmentDialog)
	
	local RecruitmentDialogAccept = CommunitiesFrame.RecruitmentDialog.Accept
	SV.API:Set("Button", RecruitmentDialogAccept)
	
	local RecruitmentDialogCancel = CommunitiesFrame.RecruitmentDialog.Cancel
	SV.API:Set("Button", RecruitmentDialogCancel)
	
	local CommunitiesFrameGCB = CommunitiesFrame.CommunitiesControlFrame.GuildControlButton
	SV.API:Set("Button", CommunitiesFrameGCB)
	
	local CommunitiesFrameGL = CommunitiesFrame.GuildLogButton
	SV.API:Set("Button", CommunitiesFrameGL)
	
	SV.API:Set("Window", CommunitiesGuildLogFrame)
	SV.API:Set("CloseButton", CommunitiesGuildLogFrameCloseButton)
	SV.API:Set("Button", CommunitiesGuildLogFrameCloseButton)
	
	local CFCAGFFSearchButton = ClubFinderCommunityAndGuildFinderFrame.OptionsList.Search
	SV.API:Set("Button", CFCAGFFSearchButton)
	
	local RequestToJoin = ClubFinderCommunityAndGuildFinderFrame.RequestToJoinFrame
	SV.API:Set("Window", RequestToJoin)
	
	local CFCAGFFRequestToJoinCancel = ClubFinderCommunityAndGuildFinderFrame.RequestToJoinFrame.Cancel
	SV.API:Set("Button", CFCAGFFRequestToJoinCancel)
	
	local CFCAGFFRequestToJoinApply = ClubFinderCommunityAndGuildFinderFrame.RequestToJoinFrame.Apply
	SV.API:Set("Button", CFCAGFFRequestToJoinApply)
	
	CommunitiesFrame.NineSlice:Hide()

	for _,frame in pairs(CommunitiesFrameList)do
		_G[frame]:RemoveTextures()
	end

	for _,texture in pairs(CommunitiesTextureList)do
		_G[texture]:Die()
	end

	
	

	
	
	
end
--[[
##########################################################
MOD LOADING
##########################################################
]]--
		-- local SVUILoginFrame=CreateFrame("Frame")
		-- SVUILoginFrame:RegisterEvent("PLAYER_LOGIN")
		-- SVUILoginFrame:SetScript("OnEvent", function(self, event) 
			-- GuildFrameStyle()	
		-- end)
MOD:SaveBlizzardStyle("Blizzard_Communities",GuildFrameStyle)

