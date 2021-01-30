--[[
##################
Inked: keivamp#
##################
]]--
-- local Inked = LibStub("AceAddon-3.0"):GetAddon("Inked")
-- local LSM = LibStub("LibSharedMedia-3.0")
local addonName, addon = ...
local _, ns = ...
local oUF = ns.oUF
local tags = oUF.Tags.Methods or oUF.Tags
local events = oUF.TagEvents or oUF.Tags.Events

function truncate(number, decimals)
    return number - (number % (0.1 ^ decimals))
end

oUF.Tags.Methods['Inked:MyHealth'] = function(unit, realUnit)
       local color = _TAGS['Keicolor'](unit)
        local name = _TAGS['curhp'](unit, realUnit)
		if name > 1000 then
        return string.format('%s%s|r', color,truncate(name/1000,1).." K" )
		else
		return string.format('%s%s|r', color,name)
		end
		
    end

    oUF.Tags.Events['Inked:MyHealth'] = 'UNIT_HEALTH UNIT_MAXHEALTH'
