--[[
#################################
oUF_NamePlateAuras_SVUI: keivamp#
#################################
]]--

local _, ns = ...
local oUF = ns.oUF
local addonName, addon = ...

oUF:RegisterStyle("SVUIAuraStyle", function(frame, unit)
    if unit == "player" then
        -- your player-specific code here
    elseif unit == "boss1" then
        -- your boss1-specific code here
    elseif unit:match("nameplate") then
	
		frame:SetScript('OnEnter', UnitFrame_OnEnter)
		frame:SetScript('OnLeave', UnitFrame_OnLeave)
		
		frame:SetSize(88, 10)
        frame:SetPoint("CENTER", 0, 0)
				
		-----------
		-- Auras --
		-----------
		local Auras = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
		Auras:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0,15)
		Auras:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 128, 15)
		Auras:SetHeight(20 + 4)
		Auras.disableMouse = false

		Auras.size = 16
		Auras.onlyShowPlayer = false
		Auras.gap = 2
		Auras.spacing = 2
		Auras.showStealableAuras = true
		Auras.disableCooldown = false
		Auras.num = 40

		Auras.PostCreateIcon = Aura_PostCreateIcon
		Auras.PostUpdateIcon = PostUpdateIcon
		frame.Auras = Auras
		

		

    end
end)
oUF:Factory(function(self)

     self:SetActiveStyle("SVUIAuraStyle")

   local cvars = {
    -- important, strongly recommend to set these to 1
    -- nameplateGlobalScale = 1,
    -- NamePlateHorizontalScale = 1,
    -- NamePlateVerticalScale = 1,
    -- optional, you may use any values
    -- nameplateLargerScale = 1,
    -- nameplateMaxScale = 1,
    -- nameplateMinScale = 1,
    -- nameplateSelectedScale = 1,
    -- nameplateSelfScale = 1,
}
 
oUF:SpawnNamePlates(nil, nil,cvars)
end)
