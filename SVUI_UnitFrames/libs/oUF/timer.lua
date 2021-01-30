local _, ns = ...
local oUF = ns.oUF or oUF


local function pvpTimerFormat(left)
   mins = math.floor(left / 60)
   secs = math.floor(left - (mins * 60))
   return string.format("%d:%02d", mins, secs)
end

local function addPvPTimer(object)
   if not object.PvPIndicator or not object.PvPIndicator.Timer then return end
   local timer = object.PvPIndicator.Timer
   timer.last_update = 0
   object:SetScript("OnUpdate", function(self, elapsed)
      if UnitIsPVP(object.unit) then
         timer.last_update = timer.last_update + elapsed
         if timer.last_update > 0.5 then
            timer.last_update = 0

            local time = GetPVPTimer()
            if time < 301000 then
               timer:SetText(pvpTimerFormat(time / 1000))
               timer:SetAlpha(1)
               timer:Show()
            else
               timer:Hide()
            end
         end
      else
         timer:Hide()
      end
   end)
end

for k, object in ipairs(oUF.objects) do
   addPvPTimer(object)
end
oUF:RegisterInitCallback(addPvPTimer)
