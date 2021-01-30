
local _, ns = ...
local oUF = ns.oUF

local function Update(self, event)
	local element = self.InkedSVResting

	--[[ Callback: RestingIndicator:PreUpdate()
	Called before the element has been updated.

	* self - the RestingIndicator element
	--]]
	local CombatRestFrame = CreateFrame("Frame")
	CombatRestFrame:SetSize(32, 32)
	CombatRestFrame:SetPoint("TOPLEFT",self,"TOPLEFT",-30,30)
	CombatRestFrame:Hide()
	CombatRestFrame.Bg = CombatRestFrame:CreateTexture(nil, "BACKGROUND")
	CombatRestFrame.Bg:SetTexture("Interface\\Addons\\InkedSV\\assets\\textures\\resting")
	CombatRestFrame.Bg:SetPoint("TOPLEFT",self,"TOPLEFT",-30,30)
	CombatRestFrame.Bg:SetSize(32, 32)

	if(element.PreUpdate) then
		element:PreUpdate()
	end
	
	function RestMe()
	local isResting = IsResting()
		if IsResting() == true then
			CombatRestFrame:Show()
		end
		if IsResting() == false then
			CombatRestFrame:Hide()
		end
	end
	local RestMeframe = CreateFrame("Frame")
	 RestMeframe:HookScript("OnUpdate", RestMe)
	
	if(element.PostUpdate) then
		return element:PostUpdate(isResting)
	end
	
	
	
	

	-- local isResting = IsResting()
	-- if(isResting) then
		-- element:Show()
	-- else
		-- element:Hide()
	-- end

	--[[ Callback: RestingIndicator:PostUpdate(isResting)
	Called after the element has been updated.

	* self      - the RestingIndicator element
	* isResting - indicates if the player is resting (boolean)
	--]]
	
end

local function Path(self, ...)
	--[[ Override: RestingIndicator.Override(self, event)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	--]]
	return (self.InkedSVResting.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self, unit)
	local element = self.InkedSVResting
	if(element and UnitIsUnit(unit, 'player')) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('PLAYER_UPDATE_RESTING', Path, true)

		if(element:IsObjectType('Texture') and not element:GetTexture()) then
			element:SetTexture("Interface\\Addons\\InkedSV\\assets\\textures\\resting")
			--element:SetTexCoord(0, 0.5, 0, 0.421875)
		end

		return true
	end
end

local function Disable(self)
	local element = self.InkedSVResting
	if(element) then
		element:Hide()

		self:UnregisterEvent('PLAYER_UPDATE_RESTING', Path)
	end
end

oUF:AddElement('InkedSVResting', Path, Enable, Disable)
