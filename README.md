# lua_piglow
A PiGlow library written in Lua

piglow.lua relies on Vanya Sergeev´s "periphery" library ( https://github.com/vsergeev/lua-periphery ). It´s a rather straight translation of Jason Barnett´s python library found on https://github.com/Boeeerb/PiGlow

It can be used without root privileges after you add group membership to "pi" like as `usermod -a -G i2c pi`. Currently only Rev2 / Rev3 Boards work, automatic detection coming soon.

As the leds have different brighnesses ( especially blue and white are EXTREMELY bright), now you can dim these down to reasonable values.
Example: Dim down white to 50%
    local glow = require"piglow"
    glow:set_dimmer("white",0.5)

