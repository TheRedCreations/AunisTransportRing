--[[
Auspex Transport Rings Control Program
v1.0.0
Created By: Augur ShicKla
 
System Requirements:
Tier 2 GPU
Tier 2 Screen
]]--
 
local AdminList = {
"ShicKla",
}
 
local component = require("component")
local unicode = require("unicode")
local event = require("event")
local term = require("term")
local computer = require("computer")
local gpu = component.gpu
local screen = component.screen
 
-- Checking System Requirements are Met --------------------------------------------
if gpu.maxResolution() < 80 then
  io.stderr:write("Tier 2 GPU and Screen Required")
  os.exit(1)
end
if not component.isAvailable("transportrings") then
  io.stderr:write("No Transport Rings Connected.")
  os.exit(1)
end
-- End of Checking System Requirements ---------------------------------------------
 
local rings = component.transportrings
local ActiveButtons = {}
local MainLoop = true
local OriginalResolution = {gpu.getResolution()}
local OrignalColorDepth = gpu.getDepth()
local DestinationButtons = {}
local AvailableRings = {}
local TransportInterlock = false
local User = ""
local resultMessages = {
OK = "OK", 
BUSY = "BUSY", 
BUSY_TARGET = "Target Ring Platform is Busy", 
OBSTRUCTED = "Ring Platform is Obstructed", 
OBSTRUCTED_TARGET = "Target Ring Platform is Obstructed", 
NO_SUCH_ADDRESS = "NO_SUCH_ADDRESS"}
 
-- Button Object -------------------------------------------------------------------
local Button = {}
Button.__index = Button
function Button.new(xPos, yPos, width, height, label, func, border)
  local self = setmetatable({}, Button)
  if xPos < 1 or xPos > term.window.width then xPos = 1 end
  if yPos < 1 or yPos > term.window.height then yPos = 1 end
  if (width-2) < unicode.len(label) then width = unicode.len(label)+2 end
  if height < 3 then height = 3 end
  if border == nil then
    self.border = true
  else
    self.border = border
  end
  self.xPos = xPos
  self.yPos = yPos
  self.width = width
  self.height = height
  self.label = label
  self.func = func
  self.visible = false
  self.disabled = false
  return self
end
 
function Button.display(self, x, y)
  table.insert(ActiveButtons, 1, self)
  if (self.width-2) < unicode.len(self.label) then self.width = unicode.len(self.label)+2 end
  if x ~= nil and y ~= nil then
    self.xPos = x
    self.yPos = y
  end
  if self.border then
    gpu.fill(self.xPos+1, self.yPos, self.width-2, 1, "─")
    gpu.fill(self.xPos+1, self.yPos+self.height-1, self.width-2, 1, "─")
    gpu.fill(self.xPos, self.yPos+1, 1, self.height-2, "│")
    gpu.fill(self.xPos+self.width-1, self.yPos+1, 1, self.height-2, "│")
    gpu.set(self.xPos, self.yPos, "┌")
    gpu.set(self.xPos+self.width-1, self.yPos, "┐")
    gpu.set(self.xPos, self.yPos+self.height-1, "└")
    gpu.set(self.xPos+self.width-1, self.yPos+self.height-1, "┘")
  end
  -- gpu.set(self.xPos+1, self.yPos+1, self.label)
  gpu.set(self.xPos+(math.ceil((self.width)/2)-math.ceil(unicode.len(self.label)/2)), self.yPos+1, self.label)
  self.visible = true
end
 
function Button.hide(self)
  self.visible = false
  for i,v in ipairs(ActiveButtons) do
    if v == self then table.remove(ActiveButtons, i) end
  end
  if self.border then
    gpu.fill(self.xPos, self.yPos, self.width, self.height, " ")
  else
    gpu.fill(self.xPos+1, self.yPos+1, self.width-2, 1, " ")
  end
end
 
function Button.disable(self, bool)
  if bool == nil then
    self.disabled = false
  else
    self.disabled = bool
  end
  if self.disabled then gpu.setForeground(0x3C3C3C) end
  if self.visible then self:display() end
  gpu.setForeground(0xFFFFFF)
end
 
function Button.touch(self, x, y)
  local wasTouched = false
  if self.visible and not self.disabled then  
    if self.border then
      if x >= self.xPos and x <= (self.xPos+self.width-1) and y >= self.yPos and y <= (self.yPos+self.height-1) then wasTouched = true end
    else
      if x >= self.xPos+1 and x <= (self.xPos+self.width-2) and y >= self.yPos+1 and y <= (self.yPos+self.height-2) then wasTouched = true end
    end
  end
  if wasTouched then
    gpu.setBackground(0x3C3C3C)
    gpu.fill(self.xPos+1, self.yPos+1, self.width-2, self.height-2, " ")
    gpu.set(self.xPos+(math.ceil((self.width)/2)-math.ceil(unicode.len(self.label)/2)), self.yPos+1, self.label)
    gpu.setBackground(0x000000)
    local success, msg = pcall(self.func)
    if self.visible then
      gpu.fill(self.xPos+1, self.yPos+1, self.width-2, self.height-2, " ")
      gpu.set(self.xPos+(math.ceil((self.width)/2)-math.ceil(unicode.len(self.label)/2)), self.yPos+1, self.label)
    end
    if not success then
      HadNoError = false
      ErrorMessage = debug.traceback(msg)
    end
  end
  return wasTouched
end
-- End of Button Object ------------------------------------------------------------
 
-- Event Handlers ------------------------------------------------------------------
local Events = {}
 
Events.transportrings_teleport_start = event.listen("transportrings_teleport_start", function(_, address, caller, initiating)
  TransportInterlock = true
  for i,v in ipairs(DestinationButtons) do
    v:disable(true)
  end
end)
 
Events.transportrings_teleport_finished = event.listen("transportrings_teleport_finished", function(_, address, caller, initiating)
  TransportInterlock = false
  for i,v in ipairs(DestinationButtons) do
    v:disable(false)
  end
end)
 
Events.touch = event.listen("touch", function(_, screenAddress, x, y, button, playerName)
  if button == 0 then
    for i,v in ipairs(ActiveButtons) do
      if v:touch(x,y) then break end
    end
  end
end)
 
Events.key_down = event.listen("key_down", function(_, keyboardAddress, chr, code, playerName)
  User = playerName
end)
 
Events.interrupted = event.listen("interrupted", function()
  local shouldExit = false
  for i,v in ipairs(AdminList) do
    if v == User then shouldExit = true end
  end
  if shouldExit then MainLoop = false end
end)
-- End of Event Handlers -----------------------------------------------------------
 
-- Main Procedures -----------------------------------------------------------------
local ringName = rings.getName()
if ringName == "NOT_IN_GRID" then error("Transport Rings Missing Address and Name", 0) end
if ringName == "" then ringName = tostring("Ring Platform "..rings.getAddress()) end
gpu.setResolution(36,18)
gpu.setDepth(4)
term.clear()
screen.setTouchModeInverted(true)
AvailableRings = rings.getAvailableRings()
gpu.setBackground(0x4B4B4B)
gpu.fill(1,1,36,3," ")
gpu.set(19-math.ceil(unicode.len(ringName)/2), 2, ringName)
gpu.setBackground(0x000000)
 
local function updateButtons()
  local buttonCount = 1
  for k,v in pairs(AvailableRings) do
    if v == "" then v = "Ring Platform "..tostring(k) end
    DestinationButtons[buttonCount] = Button.new(1, (buttonCount-1)*3+4, 36, 0, v, function()
      local result = rings.attemptTransportTo(k)
      if result ~= "OK" then
        computer.beep()
        local msgString = resultMessages[result]
        gpu.setBackground(0xFF0000)
        gpu.fill(1,1,36,3," ")
        gpu.set(19-math.ceil(unicode.len(msgString)/2), 2, msgString)
        gpu.setBackground(0x000000)
        os.sleep(3)
        gpu.setBackground(0x4B4B4B)
        gpu.fill(1,1,36,3," ")
        gpu.set(19-math.ceil(unicode.len(ringName)/2), 2, ringName)
        gpu.setBackground(0x000000)
      end
    end)
    buttonCount = buttonCount + 1
  end
 
  for i,v in ipairs(DestinationButtons) do
    v:display()
  end
end
 
updateButtons()
 
while MainLoop do
  os.sleep(0.05)
end
-- End Main Procedures -------------------------------------------------------------
 
-- Closing Procedures --------------------------------------------------------------
for k,v in pairs(Events) do
  event.cancel(v)
end
screen.setTouchModeInverted(false)
gpu.setResolution(table.unpack(OriginalResolution))
gpu.setDepth(OrignalColorDepth)
term.clear()
