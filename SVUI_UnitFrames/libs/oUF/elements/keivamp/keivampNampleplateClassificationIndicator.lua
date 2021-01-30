--[[
# Element: keivamp nameplate classicfication indicator

Toggles the visibility of an indicator based on the player's combat status.

## Widget

kNic - Any UI widget.

## Notes

A default texture will be applied if the widget is a Texture and doesn't have a texture or a color set.

## Examples

    -- Position and size
    local kNic = frame:CreateTexture(nil, 'OVERLAY')
    kNic:SetSize(32, 16)
    kNic:SetPoint('TOP', frame)

    -- Register it with oUF
    frame.kNic = kNic
--]]

local _, ns = ...
local oUF = ns.oUF

local function Update(self, event)
	local element = self.kNic

	--[[ Callback: kNic:PreUpdate()
	Called before the element has been updated.

	* self - the kNic element
	--]]
	if(element.PreUpdate) then
		element:PreUpdate()
	end

	-- local inCombat = UnitAffectingCombat('player')
	-- if(inCombat) then
		-- element:Show()
	-- else
		-- element:Hide()
	-- end
		local c = UnitClassification(self)
		if(c == 'rare') then
			element:SetTexture([[Interface\AddOns\Inked\Graphics\Nameplates\Rare]])
			--return 'R'
		elseif(c == 'rareelite') then
			element:SetTexture([[Interface\AddOns\Inked\Graphics\Nameplates\RareElite]])
			--return 'R+'
		elseif(c == 'elite') then
			element:SetTexture([[Interface\AddOns\Inked\Graphics\Nameplates\Elite]])
			print("Leet Boy")
			--return '+'
		elseif(c == 'worldboss') then
		element:SetTexture([[Interface\AddOns\Inked\Graphics\Nameplates\Boss]])
			--return 'B'
		elseif(c == 'minus') then
		element:SetTexture([[nil]])
			--return '-'
		end

	--[[ Callback: kNic:PostUpdate(inCombat)
	Called after the element has been updated.

	* self     - the kNic element
	* inCombat - indicates if the player is affecting combat (boolean)
	--]]
	-- if(element.PostUpdate) then
		-- return element:PostUpdate(inCombat)
	-- end
end

local function Path(self, ...)
	--[[ Override: kNic.Override(self, event)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	--]]
	return (self.kNic.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self, unit)

	local element = self.kNic
	print(unit)
	
	

	if(element and UnitIsUnit(unit, 'nameplate')) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		
		self:RegisterEvent('NAME_PLATE_CREATED', Path, true)
		self:RegisterEvent('NAME_PLATE_UNIT_ADDED', Path, true)
		self:RegisterEvent('NAME_PLATE_UNIT_REMOVED', Path, true)

		-- if(element:IsObjectType('Texture') and not element:GetTexture()) then
			-- element:SetTexture([[Interface\CharacterFrame\UI-StateIcon]])
			-- element:SetTexCoord(.5, 1, 0, .49)
		-- end
		-- if(element:IsObjectType('Texture') and not element:GetTexture()) then
			
		-- end

		return true
	end
end

local function Disable(self)
	local element = self.kNic
	if(element) then
		element:Hide()
		self:UnregisterEvent('NAME_PLATE_CREATED', Path)
		self:UnregisterEvent('NAME_PLATE_UNIT_ADDED', Path)
		self:UnregisterEvent('NAME_PLATE_UNIT_REMOVED', Path)
	end
end

oUF:AddElement('kNic', Path, Enable, Disable)
