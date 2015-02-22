-- test-glow.lua
-- Created 2015-01-25 by Helmut Gruber
-- Put in the public domain


local periphery=require"periphery"
local glow = require"piglow"

local sleep=periphery.sleep
local sleep_ms=periphery.sleep_ms

glow:all(0)

glow:set_dimmer("white",0.1)
glow:set_dimmer("blue",0.7)
glow:set_dimmer("green",0.7)
glow:set_gamma_correction(true)

while true do
  for c=1,5 do
    for t=1,6 do
      glow:colour(t,255)
      sleep_ms(100)
      glow:colour(t,0)
    end
  end

  local ms=600
  for m=1,50 do
    for t=1,3 do
      glow:arm(t,255)
      sleep_ms(ms)
      glow:arm(t,0)
      ms=ms-ms/20
      if ms<5 then ms=5 end
    end
  end
  for c=1,5 do
    for t=0,255 do
      glow:all(t)
      sleep_ms(3)
    end
    for t=255,0,-1 do
      glow:all(t)
      sleep_ms(3)
    end
  end
end
glow:all(0)

glow:close()

