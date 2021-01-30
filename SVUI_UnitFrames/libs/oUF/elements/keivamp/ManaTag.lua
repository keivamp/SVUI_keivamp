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

oUF.Tags.Methods['Inked:MyPower'] = function(unit, realUnit)
       local color = _TAGS['Keicolor'](unit)

        local name = _TAGS['curpp'](unit, realUnit)
		if name > 1000 then
        return string.format('%s%s|r', color,truncate(name/1000,1).." K")
		else
		return string.format('%s%s|r', color,name)
		end
		
    end

    -- add the events
    oUF.Tags.Events['Inked:MyPower'] = 'UNIT_POWER_UPDATE UNIT_MAXPOWER'

    -- create the text widget
    -- local info = self.Health:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    -- info:SetPoint('LEFT')

    -- register the tag on the text widget with oUF
   -- self:Tag(info, '[Inked:MyPower]')