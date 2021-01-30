--[[
##########################################################
S V U I   By: Munglunch
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local string 	= _G.string;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G['SVUI'];
local L = SV.L;
local MOD = SV.Skins;
local Schema = MOD.Schema;
--[[ 
########################################################## 
WeakAuras
##########################################################
]]--
local function StyleWeakAuras()
  assert(WeakAuras, "AddOn Not Loaded")
 -- print("Weak Auras")
  SV.API:Set("Window2", WeakAurasOptions)
    SV.API:Set("!_Frame", WeakAurasFilterInput)
	SV.API:Set("!_Frame", WeakAuras_DropDownMenu)

 -- SV.API:Set("Button", AceGUITabGroup1Tab1)
 --ClassTrainerScrollFrame:SetStyle("!_Frame", "Inset")
end
		-- local SVUILoginFrame=CreateFrame("Frame")
		-- SVUILoginFrame:RegisterEvent("PLAYER_LOGIN")
		-- SVUILoginFrame:SetScript("OnEvent", function(self, event) 
			-- StyleWeakAuras()	
		-- end)
MOD:SaveAddonStyle("WeakAuras", StyleWeakAuras)