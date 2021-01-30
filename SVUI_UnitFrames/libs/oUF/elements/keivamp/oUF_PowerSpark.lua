if not oUF then return end

local GetTime = GetTime
local UnitMana = UnitMana
local UnitManaMax = UnitManaMax
local GetSpellInfo = GetSpellInfo
local UnitCanAttack = UnitCanAttack
local UnitPowerType = UnitPowerType

local power, lastPower, maxPower
local pending, fsrtimer, timer
local playerGUID, lastSpellTime
local obj, bar, barWidth, spark, spark_SetPoint
local manatick, direction -- Settings for manatick and Right-to-Left
local highAlpha, lowAlpha
local inCombat, haveTarget

local mode, powerEvent, powerMaxEvent
local addon, reapplySettings, OnEventOther, OnEventActive, OnUpdateFSR, OnUpdateTST, OnUpdateGetWidth

-------------------------------------------------
--  Event-handlers  -----------------------------
-------------------------------------------------

-- "default" event-handler
function OnEventOther(self, event, unit)
	-- Only "UNIT_DISPLAYPOWER" or "PLAYER_ENTERING_WORLD" will be registered here
	if unit and unit ~= "player" then return end
	local powerType = UnitPowerType("player")
	--DEFAULT_CHAT_FRAME:AddMessage("PowerType: " .. powerType)
	-- Reset stuff
	mode = nil
	self:UnregisterAllEvents()
	self:RegisterEvent("UNIT_DISPLAYPOWER")
	pending = 0
	fsrtimer = 0
	lastSpellTime = nil
	spark:Hide()
	-- Make sure we have the GUID
	playerGUID = playerGUID or UnitGUID("player")
	if powerType == 0 then
		power = UnitMana("player")
		lastPower = power
		maxPower = UnitManaMax("player")
		mode = 0 -- Mana
		powerEvent = "UNIT_MANA"
		powerMaxEvent = "UNIT_MAXMANA"
		if manatick then
			self:SetScript("OnUpdate", OnUpdateTST)
			spark:SetAlpha(lowAlpha)
			if power < maxPower then
				spark:Show()
			end
		end
	elseif powerType == 3 then
		power = UnitMana("player")
		lastPower = power
		maxPower = UnitManaMax("player")
		mode = 3 -- Energy
		powerEvent = "UNIT_ENERGY"
		powerMaxEvent = "UNIT_MAXENERGY"
		inCombat = not not InCombatLockdown() -- true/false > 1/nil
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		if not inCombat then self:RegisterEvent("PLAYER_TARGET_CHANGED") end
		self:SetScript("OnUpdate", OnUpdateTST)
		spark:SetAlpha(highAlpha)
		if inCombat or power < maxPower then
			spark:Show()
		end
	else
		self:SetScript("OnEvent", OnEventOther)
		self:SetScript("OnUpdate", nil)
		return
	end
	-- bar:GetWidth() returns 0 at login for quite a while :(
	if barWidth == 0 then
		self:SetScript("OnUpdate", OnUpdateGetWidth)
	end
	self:RegisterEvent(powerEvent)
	self:RegisterEvent(powerMaxEvent)
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	-- The CLEU event SPELL_CAST_SUCCESS only works for instant spells :(
	-- Using good old UNIT_SPELLCAST_SUCCEEDED instead
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("PLAYER_DEAD")
	self:SetScript("OnEvent", OnEventActive)
end

-- Event-handler for mana and energy
function OnEventActive(self, event, unit, combatEvent, sourceGUID, _, _, destGUID, _, _, spellId, _, _, amount)
	if unit then
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			if destGUID ~= playerGUID then return end
			if combatEvent == "SPELL_ENERGIZE" or combatEvent == "SPELL_PERIODIC_ENERGIZE" then
				pending = pending + amount
				-- Test when this happens (for periodic)
				--if combatEvent == "SPELL_PERIODIC_ENERGIZE" then
					--DEFAULT_CHAT_FRAME:AddMessage("Periodic! "..amount)
				--end
			end
		elseif unit ~= "player" then
			return
		elseif event == powerEvent then
			local anticipated = power + pending
			power = UnitMana("player")
			-- Was there a spell cast recently?
			if lastSpellTime then
				if power < lastPower then
					local elapsed = GetTime() - lastSpellTime
					if elapsed < 1 then
						spark:SetAlpha(highAlpha)
						spark:Show()
						fsrtimer = elapsed
						self:SetScript("OnUpdate", OnUpdateFSR)
					end
				end
				lastSpellTime = nil
			end
			
			if mode == 0 then
				if manatick then
					-- Hide at full mana for mana ticker
					if power == maxPower then
						spark:Hide()
					else
						spark:Show()
					end
				end
			else
				-- Hide at full mana, out of combat and without target for energy ticker
				if power == maxPower and not inCombat and not haveTarget then
					spark:Hide()
				else
					spark:Show()
				end
			end
			
			if power ~= anticipated and (power ~= maxPower or anticipated < maxPower) then
				-- This should be a tick
				timer = 0 -- Resync timer
				--DEFAULT_CHAT_FRAME:AddMessage(power .. " - " .. anticipated .. " = " .. power-anticipated)
			end
			pending = 0
			lastPower = power
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			local _, _, _, cost, _, powerType, castTime = GetSpellInfo(combatEvent, sourceGUID) -- spell name is in combatEvent, rank in sourceGUID
			--DEFAULT_CHAT_FRAME:AddMessage(combatEvent .. ", " .. cost .. ", " .. powerType .. ", " .. castTime)
			if powerType == mode then
				pending = pending - cost
				if mode == 0 then
					lastSpellTime = GetTime()
				end
			end
		elseif event == powerMaxEvent then
			maxPower = UnitManaMax("player")
			if mode == 0 and not manatick then return end
			-- Show the spark if we no longer have full mana
			if power < maxPower then
				spark:Show()
			end
		elseif event == "UNIT_DISPLAYPOWER" then
			OnEventOther(self, "UNIT_DISPLAYPOWER", "player")
		end
	elseif event == "PLAYER_TARGET_CHANGED" then
		haveTarget = UnitCanAttack("player", "target") -- Can't attack notarget
		if haveTarget then
			spark:Show()
		elseif not inCombat and power == maxPower then
			spark:Hide()
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		inCombat = true
		self:UnregisterEvent("PLAYER_TARGET_CHANGED") -- There's alot of target changing in combat.
		spark:Show() -- It's ok, this event isn't registered for mana
	elseif event == "PLAYER_REGEN_ENABLED" then
		inCombat = false
		haveTarget = UnitCanAttack("player", "target") -- Change this if above change!
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		if not haveTarget and power == maxPower then
			spark:Hide()
		end
	elseif event == "PLAYER_DEAD" then
		pending = -power
	end
end

-------------------------------------------------
-- OnUpdates  -----------------------------------
-------------------------------------------------

-- OnUpdate for Five Second Rule
function OnUpdateFSR(self, elapsed)
	local f = fsrtimer + elapsed
	local t = timer + elapsed
	if t > 2 then t = t - 2 end -- Keep timer in check
	if f > 5 then -- 5 is for lenght of "five sec rule", duh!
		if manatick then
			spark:SetAlpha(lowAlpha)
			self:SetScript("OnUpdate", OnUpdateTST)
		else
			spark:Hide()
			self:SetScript("OnUpdate", nil)
		end
	else
		spark_SetPoint(spark, "CENTER", bar, direction, f * 0.2 * barWidth, 0) -- Haxx spark:SetPoint(...) to the maxx
	end
	fsrtimer = f
	timer = t
end

-- OnUpdate for the Two Second Ticker
function OnUpdateTST(self, elapsed)
	local t = timer + elapsed
	if t > 2 then -- 2 is the time between ticks
		t = t - 2 -- Subtracting 2 instead of setting to 0 to not accumulate small errors wich could lead to timer running out of sync
	end
	spark_SetPoint(spark, "CENTER", bar, direction, t * 0.5 * barWidth, 0) -- Haxx spark:SetPoint(...) to the maxx
	timer = t
end

-- OnUpdate to get the bar width after login
-- Shouldn't run more than once or twice
function OnUpdateGetWidth(self, elapsed)
	local t = timer + elapsed
	local w = bar:GetWidth()
	if w ~= 0 then
		--DEFAULT_CHAT_FRAME:AddMessage("Got " .. w .. " after " .. t)
		barWidth = spark.rtl and -w or w
		if mode == 0 and manatick or mode == 3 then
			self:SetScript("OnUpdate", OnUpdateTST)
		else
			self:SetScript("OnUpdate", nil)
		end
		return
	end
	--DEFAULT_CHAT_FRAME:AddMessage("Got " .. w .. " after " .. t)
	timer = t
end

-------------------------------------------------
-- Init stuff  ----------------------------------
-------------------------------------------------

function reapplySettings(object)
	object = object or oUF.units["player"]
	if not object then error("Must pass an object to oUF_PowerSpark_ReapplySettings") return end
	local s = object.Spark
	if not s then error("The object passed to oUF_PowerSpark_ReapplySettings must have a Spark") return end -- object must have Spark
	obj = object
	spark = object.Spark
	s:ClearAllPoints()
	spark_SetPoint = s.SetPoint
	bar = s:GetParent() or object.Power -- default to object.Power if someone fucks up and don't parent their spark to something
	barWidth = bar:GetWidth()
	--DEFAULT_CHAT_FRAME:AddMessage(barWidth)
	if s.rtl then -- Right-to-Left
		direction = "RIGHT"
		barWidth = -barWidth
	else
		direction = "LEFT"
	end
	manatick = s.manatick and true or false -- Wether or not to tick every 2 sec for mana (out of 5sr)
	highAlpha = s.highAlpha or s:GetAlpha()
	lowAlpha = s.lowAlpha or highAlpha * 0.25
end
-- Global function to call if you change sparkframe/barwidth/settings
oUF_PowerSpark_ReapplySettings = reapplySettings

local function addTicker(object)
	if addon then return end -- Only one spark is supported.
	object = object or oUF.units["player"]
	if not object then return true end -- return true if no player frame was found at startup
	local s = object.Spark
	if not s then return true end -- object must have Spark
	reapplySettings(object)
	timer = 0
	addon = CreateFrame("Frame")
	-- UnitGUID("player") don't work right away at login
	if IsLoggedIn() then
		OnEventOther(addon, "UNIT_DISPLAYPOWER", "player")
	else
		addon:SetScript("OnEvent", OnEventOther)
		addon:RegisterEvent("PLAYER_ENTERING_WORLD")
	end
end

-- If you're looking at this code to figure out
-- how to init your own oUF module you probably
-- don't want to do it like this :P
if addTicker() then -- if addTicker() returns true no Spark was found
	oUF:RegisterInitCallback(addTicker)
end
