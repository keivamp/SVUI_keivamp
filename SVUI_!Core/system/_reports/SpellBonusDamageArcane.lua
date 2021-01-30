--[[
###############################################################################################
#S U P E R - V I L L A I N - ORIGINALLY  By: Failcoder | SVUI (SUPER VILLAIN) Updated By: keivamp #
###############################################################################################

##########################################################
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;

local select 	= _G.select;
local collectgarbage    = _G.collectgarbage;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ MATH METHODS ]]--
local floor = math.floor
--[[ TABLE METHODS ]]--
local tsort = table.sort;
local IsShiftKeyDown        = _G.IsShiftKeyDown;
local IsAddOnLoaded         = _G.IsAddOnLoaded;
--[[
##########################################################
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L;
local Reports = SV.Reports;
--[[
##########################################################
SYSTEM STATS (Credit: Richy004)
##########################################################
]]--
local REPORT_NAME = "Arcane Spell Damage";
local HEX_COLOR = "22FFFF";
local TEXT_PATTERN = "|cff%s%s|r";
local int, int2 = 6, 5
local statusColors = {
    "|cff0CD809",
    "|cffE8DA0F",
    "|cffFF9000",
    "|cffD80909"
}
local enteredFrame = false;

local Report = Reports:NewReport(REPORT_NAME, {
    type = "data source",
    text = REPORT_NAME .. " Info",
    icon = [[Interface\Addons\SVUI\assets\icons\SVUI]]
});

Report.OnEnter = function(self)
    enteredFrame = true;
    Reports:SetDataTip(self)
end

Report.OnLeave = function(self, button)
    enteredFrame = false;
    Reports.ToolTip:Hide()
end

Report.OnUpdate = function(self, elapsed)
    local spellDmg = GetSpellBonusDamage(7);
    self.text:SetText("Arcane Dam: " ..  "|cff22CFFF" .. spellDmg .. "");

    if enteredFrame then
        Report.OnEnter(self)
    end
end
