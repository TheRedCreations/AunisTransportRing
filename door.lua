local accessCode = "12345"

local component = require("component")
local gpu = component.gpu
local event = require("event")
local ser = require("serialization")
local term = require("term")
local computer = component.computer
local door = component.os_rolldoorcontroller
keypad1 = component.get("bb0b")
keypad2 = component.get("d2d2")

customButtons = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "<", "0", "ok"}
customButtonColor = {"1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"}
keypad1.setKey(customButtons, customButtonColor)
keypad2.setKey(customButtons, customButtonColor)

term.clear()
print("Security door")
print("---------------------------------------------------------------------------")

local inputStr = ""
while true do
  ev, address, button, button_label = event.pull("keypad")
  if ev then
    if button_label == "ok" then
      if inputStr == accessCode then
	term.write("Access granted\n")
	inputStr = "Welcome"
	keypad1.setDisplay(inputStr)
  keypad2.setDisplay(inputStr)
	computer.beep()
	door.toggle()
	os.sleep(5)
	door.toggle()
      else
	term.write("Access denied\n")
	inputStr = "ERROR"
	keypad1.setDisplay(inputStr)
  keypad2.setDisplay(inputStr)
	os.sleep(2)
      end
      inputStr = ""
    elseif button_label == "<" then
      if string.len(inputStr) > 0 then
	tmpStr = string.sub(inputStr, 1 , string.len(inputStr) -1)
	inputStr = tmpStr
      end
    else
      inputStr = inputStr .. button_label
    end
    keypad1.setDisplay(inputStr)
    keypad2.setDisplay(inputStr)
  end
  os.sleep(0)
end
