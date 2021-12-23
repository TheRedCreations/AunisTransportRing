component = require("component")
event = require("event")
os = require("os")
door = component.os_rolldoorcontroller
alarm = component.os_alarm
 
local keypad1 = component.os_keypad
alarm.setAlarm("area51_alert")
alarm.setRange(0.5)
color = 2
 
customButtons = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "<", "0", "ok"} 
customButtonColor = {color,color,color,color,color,color,color,color,color,color,color,color} 
keypad1.setKey(customButtons, customButtonColor)
 
local pin = "0000"
local tpin = "0001"
local keypadInput = ""
 
-- set this to true if you want to run the script as daemon
local runScriptInBackground = false
 
function updateDisplay()
    local displayString = ""
    for i=1,#keypadInput do
        displayString = displayString .. "*"
    end
 
    keypad1.setDisplay(displayString, 7)
end
 
function checkPin()
    if keypadInput == pin then
        keypad1.setDisplay("granted", 2)
        door.open()
        os.sleep(5)
        keypad1.setDisplay("CLOSING", 4)
        door.close()
        os.sleep(2)
    else if (keypadInput == tpin) then
        keypad1.setDisplay("toggled", 2)
        door.toggle()
        os.sleep(2)
        else
        keypad1.setDisplay("denied", 4)
        alarm.activate()
        os.sleep(5)
        alarm.deactivate()
    end
    end    
    keypadInput = ""
    os.sleep(1)
end
 
function keypadEvent(eventName, address, button, button_label)
    print("button pressed: " .. button_label)
  
    if button_label == "<" then
        -- remove last character from input cache
        keypadInput = string.sub(keypadInput, 1, -2)
    elseif button_label == "ok" then
        -- check the pin when the user confirmed the input
        checkPin()
    else
        -- add key to input cache if none of the above action apply
        keypadInput = keypadInput .. button_label
    end
 
    updateDisplay()  
end
 
-- listen to keypad events
event.listen("keypad", keypadEvent)
 
-- clear keypad display
keypad1.setDisplay("")
if not runScriptInBackground then
    -- sleep until the user interrupts the program with CTRL + C
    local stopMe = false
    event.listen("interrupted", function() stopMe = true; end)
    while not stopMe do os.sleep(0.1) end

    -- ignore keypad events on exit
    event.ignore("keypad", keypadEvent)

    -- show that the keypad is inactive
    keypad1.setDisplay("inactive", 6)
end
