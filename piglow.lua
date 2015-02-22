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

  G.all=function(self, v)
    G.bus:transfer(
        0x54, {{0x01, 
          self:_real_value(1,v),
          self:_real_value(2,v),
          self:_real_value(3,v),
          self:_real_value(4,v),
          self:_real_value(5,v),
          self:_real_value(6,v),
          self:_real_value(7,v),
          self:_real_value(8,v),
          self:_real_value(9,v),
          self:_real_value(10,v),
          self:_real_value(11,v),
          self:_real_value(12,v),
          self:_real_value(13,v),
          self:_real_value(14,v),
          self:_real_value(15,v),
          self:_real_value(16,v),
          self:_real_value(17,v),
          self:_real_value(18,v)}})
    G.bus:transfer(0x54, {{0x16, 0xFF}})
  end

  G.arm=function(self, arm, value)
    if arm == 1 then
      G.bus:transfer(0x54, {{0x07, self:_real_value(0x07,value)}})
      G.bus:transfer(0x54, {{0x08, self:_real_value(0x08,value)}})
      G.bus:transfer(0x54, {{0x09, self:_real_value(0x09,value)}})
      G.bus:transfer(0x54, {{0x06, self:_real_value(0x06,value)}})
      G.bus:transfer(0x54, {{0x05, self:_real_value(0x05,value)}})
      G.bus:transfer(0x54, {{0x0A, self:_real_value(0x0A,value)}})
      G.bus:transfer(0x54, {{0x16, 0xFF}})
    elseif arm == 2 then
      G.bus:transfer(0x54, {{0x0B, self:_real_value(0x0B,value)}})
      G.bus:transfer(0x54, {{0x0C, self:_real_value(0x0C,value)}})
      G.bus:transfer(0x54, {{0x0E, self:_real_value(0x0E,value)}})
      G.bus:transfer(0x54, {{0x10, self:_real_value(0x10,value)}})
      G.bus:transfer(0x54, {{0x11, self:_real_value(0x11,value)}})
      G.bus:transfer(0x54, {{0x12, self:_real_value(0x12,value)}})
      G.bus:transfer(0x54, {{0x16, 0xFF}})
    elseif arm == 3 then
      G.bus:transfer(0x54, {{0x01, self:_real_value(0x01,value)}})
      G.bus:transfer(0x54, {{0x02, self:_real_value(0x02,value)}})
      G.bus:transfer(0x54, {{0x03, self:_real_value(0x03,value)}})
      G.bus:transfer(0x54, {{0x04, self:_real_value(0x04,value)}})
      G.bus:transfer(0x54, {{0x0F, self:_real_value(0x0F,value)}})
      G.bus:transfer(0x54, {{0x0D, self:_real_value(0x0D,value)}})
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
      value=self:_real_value(0x0A,value)
      G.bus:transfer(0x54, {{0x0A, value}})
      G.bus:transfer(0x54, {{0x0B, value}})
      G.bus:transfer(0x54, {{0x0D, value}})
      G.bus:transfer(0x54, {{0x16, 0xFF}})
    elseif colour == 2 or colour == "blue" then
      value=self:_real_value(0x05,value)
        G.bus:transfer(0x54, {{0x05, value}})
        G.bus:transfer(0x54, {{0x0C, value}})
        G.bus:transfer(0x54, {{0x0F, value}})
        G.bus:transfer(0x54, {{0x16, 0xFF}})
    elseif colour == 3 or colour == "green" then
        value=self:_real_value(0x06,value)
        G.bus:transfer(0x54, {{0x06, value}})
        G.bus:transfer(0x54, {{0x04, value}})
        G.bus:transfer(0x54, {{0x0E, value}})
        G.bus:transfer(0x54, {{0x16, 0xFF}})
    elseif colour == 4 or colour == "yellow" then
        value=self:_real_value(0x09,value)
        G.bus:transfer(0x54, {{0x09, value}})
        G.bus:transfer(0x54, {{0x03, value}})
        G.bus:transfer(0x54, {{0x10, value}})
        G.bus:transfer(0x54, {{0x16, 0xFF}})
    elseif colour == 5 or colour == "orange" then
        value=self:_real_value(0x08,value)
        G.bus:transfer(0x54, {{0x08, value}})
        G.bus:transfer(0x54, {{0x02, value}})
        G.bus:transfer(0x54, {{0x11, value}})
        G.bus:transfer(0x54, {{0x16, 0xFF}})
    elseif colour == 6 or colour == "red" then
        value=self:_real_value(0x07,value)
        G.bus:transfer(0x54, {{0x07, value}})
        G.bus:transfer(0x54, {{0x01, value}})
        G.bus:transfer(0x54, {{0x12, value}})
        G.bus:transfer(0x54, {{0x16, 0xFF}})
    else
        print("Only colours 1 - 6 or color names are allowed")
    end
  end
    
  G._leds = {
        0x07, 0x08, 0x09, 0x06, 0x05, 0x0A, 0x12, 0x11,
        0x10, 0x0E, 0x0C, 0x0B, 0x01, 0x02, 0x03, 0x04, 0x0F, 0x0D}
  
  G.led=function(self, led, value)
    local ledid=G._leds[led]
    value=self:_real_value(ledid,value)
    G.bus:transfer(0x54, {{ledid, value}})
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
  
  G.set_gamma_correction=function(self,v)
    self._do_gamma=v
  end
  
  G._dimming={}
  
  G.set_dimmer=function(self,color,v)
    self._dimming[color]=v
  end
  
  G.GAMMA_TABLE = {
    0, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1,
    2, 2, 2, 2, 2, 2, 2, 2,
    2, 2, 2, 2, 2, 2, 2, 2,
    2, 2, 2, 3, 3, 3, 3, 3,
    3, 3, 3, 3, 3, 3, 3, 3,
    4, 4, 4, 4, 4, 4, 4, 4,
    4, 4, 4, 5, 5, 5, 5, 5,
    5, 5, 5, 6, 6, 6, 6, 6,
    6, 6, 7, 7, 7, 7, 7, 7,
    8, 8, 8, 8, 8, 8, 9, 9,
    9, 9, 10, 10, 10, 10, 10, 11,
    11, 11, 11, 12, 12, 12, 13, 13,
    13, 13, 14, 14, 14, 15, 15, 15,
    16, 16, 16, 17, 17, 18, 18, 18,
    19, 19, 20, 20, 20, 21, 21, 22,
    22, 23, 23, 24, 24, 25, 26, 26,
    27, 27, 28, 29, 29, 30, 31, 31,
    32, 33, 33, 34, 35, 36, 36, 37,
    38, 39, 40, 41, 42, 42, 43, 44,
    45, 46, 47, 48, 50, 51, 52, 53,
    54, 55, 57, 58, 59, 60, 62, 63,
    64, 66, 67, 69, 70, 72, 74, 75,
    77, 79, 80, 82, 84, 86, 88, 90,
    91, 94, 96, 98, 100, 102, 104, 107,
    109, 111, 114, 116, 119, 122, 124, 127,
    130, 133, 136, 139, 142, 145, 148, 151,
    155, 158, 161, 165, 169, 172, 176, 180,
    184, 188, 192, 196, 201, 205, 210, 214,
    219, 224, 229, 234, 239, 244, 250, 255}
  

  G.COLOR_TABLE={
        [0x07]="red", 
        [0x08]="orange",
        [0x09]="yellow", 
        [0x06]="green", 
        [0x05]="blue", 
        [0x0A]="white", 
        [0x12]="red", 
        [0x11]="orange",
        [0x10]="yellow", 
        [0x0E]="green", 
        [0x0C]="blue", 
        [0x0B]="white", 
        [0x01]="red", 
        [0x02]="orange", 
        [0x03]="yellow", 
        [0x04]="green", 
        [0x0F]="blue", 
        [0x0D]="white"
  }
    

  G.gamma=function(self,v) return self.GAMMA_TABLE[v+1] end
  
  G._real_value=function(self,ledid,v)
    local color=self.COLOR_TABLE[ledid]
    if self._do_gamma then v=self:gamma(v) end
    if self._dimming[color] then
      v=v*self._dimming[color]
    end
    return v
  end
    
  
  G.close=function(self)
    G.bus:transfer(0x54, { {0x00, 0x00}})    
  end
  return G
end
return PiGlow()
