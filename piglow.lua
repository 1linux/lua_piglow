--[[

 Lua translation by Helmut Gruber
#####################################################
## Python module to control the PiGlow by Pimoroni ##
##                                                 ##
## Written by Jason - @Boeeerb  -  v0.5  17/08/13  ##
##            jase@boeeerb.co.uk                   ##
#####################################################
##
## v0.5 - Add RPI VER 3 for model B+         - 26/08/14
## v0.4 - Auto detect Raspberry Pi revision  - 17/08/13
## v0.3 - Added fix from topshed             - 17/08/13
## v0.2 - Code cleanup by iiSeymour          - 15/08/13
## v0.1 - Initial release                    - 15/08/13
##
--]]



local PiGlow=function()
  local I2C = require('periphery').I2C
  local RPI_REVISION=2
  local i2c_bus
  
  local G={}

  if RPI_REVISION == 1 then
    i2c_bus = 0
  elseif RPI_REVISION == 2 then
    i2c_bus = 1
  elseif RPI_REVISION == 3 then
    i2c_bus = 1
  else
    error("Unable to determine Raspberry Pi revision.")
  end  
  
  G.bus = I2C("/dev/i2c-"..i2c_bus)
--  G.bus.write_i2c_block_data(0x54, 0x00, [0x01])
  G.bus:transfer(0x54, { {0x00, 0x01}})
  G.bus:transfer(0x54, { {0x13, 0xFF}})
  G.bus:transfer(0x54, { {0x14, 0xFF}})
  G.bus:transfer(0x54, { {0x15, 0xFF}})

  G.white=  function(self, value)   self:colour("white", value) end
  G.blue=   function(self, value)   self:colour("blue", value)  end
  G.green=  function(self, value)   self:colour("green", value) end
  G.yellow= function(self, value)   self:colour("yellow", value)end
  G.orange= function(self, value)   self:colour("orange", value)end
  G.red=    function(self, value)   self:colour("red", value)   end

  G.all=function(self, value)
    local v = value
    G.bus:transfer(
        0x54, {{0x01, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v, v}})
    G.bus:transfer(0x54, {{0x16, 0xFF}})
  end

  G.arm=function(self, arm, value)
    if arm == 1 then
      G.bus:transfer(0x54, {{0x07, value}})
      G.bus:transfer(0x54, {{0x08, value}})
      G.bus:transfer(0x54, {{0x09, value}})
      G.bus:transfer(0x54, {{0x06, value}})
      G.bus:transfer(0x54, {{0x05, value}})
      G.bus:transfer(0x54, {{0x0A, value}})
      G.bus:transfer(0x54, {{0x16, 0xFF}})
    elseif arm == 2 then
      G.bus:transfer(0x54, {{0x0B, value}})
      G.bus:transfer(0x54, {{0x0C, value}})
      G.bus:transfer(0x54, {{0x0E, value}})
      G.bus:transfer(0x54, {{0x10, value}})
      G.bus:transfer(0x54, {{0x11, value}})
      G.bus:transfer(0x54, {{0x12, value}})
      G.bus:transfer(0x54, {{0x16, 0xFF}})
    elseif arm == 3 then
      G.bus:transfer(0x54, {{0x01, value}})
      G.bus:transfer(0x54, {{0x02, value}})
      G.bus:transfer(0x54, {{0x03, value}})
      G.bus:transfer(0x54, {{0x04, value}})
      G.bus:transfer(0x54, {{0x0F, value}})
      G.bus:transfer(0x54, {{0x0D, value}})
      G.bus:transfer(0x54, {{0x16, 0xFF}})
    else
      print("Unknown number, expected only 1, 2 or 3")
    end
  end


  G.arm1=function(self, value)    self:arm(1,value)   end
  G.arm2=function(self, value)    self:arm(2,value)   end
  G.arm3=function(self, value)    self:arm(3,value)   end

  G.colour=function(self, colour, value)
    if colour == 1 or colour == "white" then
      G.bus:transfer(0x54, {{0x0A, value}})
      G.bus:transfer(0x54, {{0x0B, value}})
      G.bus:transfer(0x54, {{0x0D, value}})
      G.bus:transfer(0x54, {{0x16, 0xFF}})
    elseif colour == 2 or colour == "blue" then
        G.bus:transfer(0x54, {{0x05, value}})
        G.bus:transfer(0x54, {{0x0C, value}})
        G.bus:transfer(0x54, {{0x0F, value}})
        G.bus:transfer(0x54, {{0x16, 0xFF}})
    elseif colour == 3 or colour == "green" then
        G.bus:transfer(0x54, {{0x06, value}})
        G.bus:transfer(0x54, {{0x04, value}})
        G.bus:transfer(0x54, {{0x0E, value}})
        G.bus:transfer(0x54, {{0x16, 0xFF}})
    elseif colour == 4 or colour == "yellow" then
        G.bus:transfer(0x54, {{0x09, value}})
        G.bus:transfer(0x54, {{0x03, value}})
        G.bus:transfer(0x54, {{0x10, value}})
        G.bus:transfer(0x54, {{0x16, 0xFF}})
    elseif colour == 5 or colour == "orange" then
        G.bus:transfer(0x54, {{0x08, value}})
        G.bus:transfer(0x54, {{0x02, value}})
        G.bus:transfer(0x54, {{0x11, value}})
        G.bus:transfer(0x54, {{0x16, 0xFF}})
    elseif colour == 6 or colour == "red" then
        G.bus:transfer(0x54, {{0x07, value}})
        G.bus:transfer(0x54, {{0x01, value}})
        G.bus:transfer(0x54, {{0x12, value}})
        G.bus:transfer(0x54, {{0x16, 0xFF}})
    else
        print("Only colours 1 - 6 or color names are allowed")
    end
  end
  G.led=function(self, led, value)
    local leds = {
        0x00, 0x07, 0x08, 0x09, 0x06, 0x05, 0x0A, 0x12, 0x11,
        0x10, 0x0E, 0x0C, 0x0B, 0x01, 0x02, 0x03, 0x04, 0x0F, 0x0D}
    G.bus:transfer(0x54, {{leds[led], value}})
    G.bus:transfer(0x54, {{0x16, 0xFF}})
  end

  G.led1 =function(self, value)    self:led(1 ,value)   end
  G.led2 =function(self, value)    self:led(2 ,value)   end
  G.led3 =function(self, value)    self:led(3 ,value)   end
  G.led4 =function(self, value)    self:led(4 ,value)   end
  G.led5 =function(self, value)    self:led(5 ,value)   end
  G.led6 =function(self, value)    self:led(6 ,value)   end
  G.led7 =function(self, value)    self:led(7 ,value)   end
  G.led8 =function(self, value)    self:led(8 ,value)   end
  G.led9 =function(self, value)    self:led(9 ,value)   end
  G.led10=function(self, value)    self:led(10,value)   end
  G.led11=function(self, value)    self:led(11,value)   end
  G.led12=function(self, value)    self:led(12,value)   end
  G.led13=function(self, value)    self:led(13,value)   end
  G.led14=function(self, value)    self:led(14,value)   end
  G.led15=function(self, value)    self:led(15,value)   end
  G.led16=function(self, value)    self:led(16,value)   end
  G.led17=function(self, value)    self:led(17,value)   end
  G.led18=function(self, value)    self:led(18,value)   end
  
  G.close=function(self)
    G.bus:transfer(0x54, { {0x00, 0x00}})    
  end
  return G
end
return PiGlow()
