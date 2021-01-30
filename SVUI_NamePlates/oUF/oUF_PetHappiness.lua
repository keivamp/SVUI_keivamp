--[[
# Element: Pet Happiness

Toggles the visibility of an indicator based on the Pets Happiness

## Widget

.texture - A `Texture` used to display the group role icon.

PetHappiness - A `Frame` used to display the group role icon.

## Notes

A default texture will be applied if the widget is a Texture and doesn't have a texture or a color set.

oUF Element: .PetHappiness

Options regarding visual layout:
	-	<element>.Texture
		Texture to display the pets happiness

	- <element>.Override

## Examples

    -- Position and size
    local PetHappiness = CreateFrame('Frame', nil, self)
	PetHappiness:SetSize(16, 16)

    -- Register it with oUF
    self.PetHappiness = PetHappiness
--]]
local _, ns = ...
local oUF = (ns.oUF or oUF) or (ns.SUF or SUF)
assert(oUF, 'oUF_PetHappiness was unable to locate oUF install.')

local function Update(self, event)
	local element = self.PetHappiness

	--[[ Callback: PetHappiness:PreUpdate()
	Called before the element has been updated.

	* self - the PetHappiness element
	--]]
	if (element.PreUpdate) then
		element:PreUpdate()
	end

	if self.unit ~= 'pet' then
		return
	end

	local happiness, damagePercentage, loyaltyRate = GetPetHappiness()
	local hasPetUI, isHunterPet = HasPetUI()
	if (not happiness or not isHunterPet) then
		element:Hide()
		return
	end
	element:Show()

	if (happiness == 1) then
		element.texture:SetTexCoord(0.375, 0.5625, 0, 0.359375)
	elseif (happiness == 2) then
		element.texture:SetTexCoord(0.1875, 0.375, 0, 0.359375)
	elseif (happiness == 3) then
		element.texture:SetTexCoord(0, 0.1875, 0, 0.359375)
	end

	element.tooltip = _G['PET_HAPPINESS' .. happiness]
	element.tooltipDamage = format(PET_DAMAGE_PERCENTAGE, damagePercentage)
	if (loyaltyRate < 0) then
		element.tooltipLoyalty = _G['LOSING_LOYALTY']
	elseif (loyaltyRate > 0) then
		element.tooltipLoyalty = _G['GAINING_LOYALTY']
	else
		element.tooltipLoyalty = nil
	end

	--[[ Callback: PetHappiness:PostUpdate(role)
	Called after the element has been updated.

	* self - the PetHappiness element
	* role - the role as returned by [UnitGroupRolesAssigned](http://wowprogramming.com/docs/api/UnitGroupRolesAssigned.html)
	--]]
	if (element.PostUpdate) then
		return element:PostUpdate(role)
	end
end

local function Path(self, ...)
	--[[ Override: PetHappiness.Override(self, event, ...)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* ...   - the arguments accompanying the event
	--]]
	return (self.PetHappiness.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self)
	local element = self.PetHappiness
	if (element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		if (self.unit == 'pet') then
			self:RegisterEvent('UNIT_HAPPINESS', Path, true)
			self:RegisterEvent('PET_UI_UPDATE', Path, true)
		end

		if not element.texture then
			element.texture = element:CreateTexture(nil, 'OVERLAY')
			element.texture:SetAllPoints(element)
		end

		if (element.texture:IsObjectType('Texture') and not element.texture:GetTexture()) then
			element.texture:SetTexture([[Interface\PetPaperDollFrame\UI-PetHappiness]])
		end

		element:SetScript(
			'OnEnter',
			function()
				local element = self.PetHappiness
				if (element.tooltip) then
					GameTooltip:SetOwner(element, 'ANCHOR_RIGHT')
					GameTooltip:SetText(element.tooltip)
					if (element.tooltipDamage) then
						GameTooltip:AddLine(element.tooltipDamage, '', 1, 1, 1)
					end
					if (element.tooltipLoyalty) then
						GameTooltip:AddLine(element.tooltipLoyalty, '', 1, 1, 1)
					end
					GameTooltip:Show()
				end
			end
		)

		element:SetScript(
			'OnLeave',
			function()
				GameTooltip:Hide()
			end
		)

		return true
	end
end

local function Disable(self)
	local element = self.PetHappiness
	if (element) then
		element:Hide()

		self:UnregisterEvent('UNIT_HAPPINESS', Path)
		self:UnregisterEvent('PET_UI_UPDATE', Path, true)
	end
end

oUF:AddElement('PetHappiness', Path, Enable, Disable)
