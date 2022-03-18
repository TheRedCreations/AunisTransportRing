component = require("component")
event = require("event")
os = require("os")
door1 = component.proxy("dd2e37cd-cf43-4f0b-84ac-5e79ef342d54")
door2 = component.proxy("544e5e64-bc00-4cb0-85fc-60fff06d66fc")
door3 = component.proxy("a92e295d-9811-4a60-81e2-6ae8d6457374")
door4 = component.proxy("c6b96d32-66a7-429c-a61b-2b32b77ab26a")
door5 = component.proxy("3315401d-8913-49f0-9059-71a8e7d17f9d")
door6 = component.proxy("872eca36-8c52-4f19-b893-0428d9d23cb0")
door7 = component.proxy("7f5bac49-e0c8-41e4-88d7-af819d75186f")
door8 = component.proxy("7e6edfa6-ace0-43bc-afd2-ffd7749349d2")
door9 = component.proxy("924f7658-e85f-4f17-87a8-a760fd57716a")
keypad1 = component.proxy("eea1ecd6-7a20-42c9-9e9e-d545557a65b0")
color = 2
 
customButtons = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "<", "0", "ok"} 
customButtonColor = {color,color,color,color,color,color,color,color,color,color,color,color} 
keypad1.setKey(customButtons, customButtonColor)
door1.close()
door2.close()
door3.close()
door4.close()
door5.close()
door6.close()
door7.close()
door8.close()
door9.close()
 
local pin1 = "0001"
local pin2 = "0002"
local pin3 = "0003"
local pin4 = "0004"
local pin5 = "0005"
local pin6 = "0006"
local pin7 = "0007"
local pin8 = "0008"
local pin9 = "0009"
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
    if keypadInput == pin1 then
      if (door1.getPosition() == 4) then
        keypad1.setDisplay("OPENING", 2)
        door1.open()
   os.sleep(2)
      else
        keypad1.setDisplay("CLOSING", 4)
        door1.close()
   os.sleep(2)
      end
    elseif keypadInput == pin2 then
      if (door2.getPosition() == 4) then
        keypad1.setDisplay("OPENING", 2)
        door2.open()
   os.sleep(2)
      else
        keypad1.setDisplay("CLOSING", 4)
        door2.close()
   os.sleep(2)
      end
    elseif keypadInput == pin3 then
      if (door3.getPosition() == 4) then
        keypad1.setDisplay("OPENING", 2)
        door3.open()
   os.sleep(2)
      else
        keypad1.setDisplay("CLOSING", 4)
        door3.close()
   os.sleep(2)
      end
    elseif keypadInput == pin4 then
      if (door4.getPosition() == 4) then
        keypad1.setDisplay("OPENING", 2)
        door4.open()
   os.sleep(2)
      else
        keypad1.setDisplay("CLOSING", 4)
        door4.close()
   os.sleep(2)
      end
    elseif keypadInput == pin5 then
      if (door5.getPosition() == 4) then
        keypad1.setDisplay("OPENING", 2)
        door5.open()
   os.sleep(2)
      else
        keypad1.setDisplay("CLOSING", 4)
        door5.close()
   os.sleep(2)
      end
    elseif keypadInput == pin6 then
      if (door6.getPosition() == 4) then
        keypad1.setDisplay("OPENING", 2)
        door6.open()
   os.sleep(2)
      else
        keypad1.setDisplay("CLOSING", 4)
        door6.close()
   os.sleep(2)
      end
    elseif keypadInput == pin7 then
      if (door7.getPosition() == 4) then
        keypad1.setDisplay("OPENING", 2)
        door7.open()
   os.sleep(2)
      else
        keypad1.setDisplay("CLOSING", 4)
        door7.close()
   os.sleep(2)
      end
    elseif keypadInput == pin8 then
      if (door8.getPosition() == 4) then
        keypad1.setDisplay("OPENING", 2)
        door8.open()
   os.sleep(2)
      else
        keypad1.setDisplay("CLOSING", 4)
        door8.close()
   os.sleep(2)
      end
    elseif keypadInput == pin9 then
      if (door9.getPosition() == 4) then
        keypad1.setDisplay("OPENING", 2)
        door9.open()
   os.sleep(2)
      else
        keypad1.setDisplay("CLOSING", 4)
        door9.close()
   os.sleep(2)
      end
    else
        keypad1.setDisplay("denied", 4)
   os.sleep(2)
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
    color2 = 0
    customButtonColor2 = {color2,color2,color2,color2,color2,color2,color2,color2,color2,color2,color2,color2} 
    keypad1.setKey(customButtons, customButtonColor2)
    door1.open()
    door2.open()
    door3.open()
    door4.open()
    door5.open()
    door6.open()
    door7.open()
    door8.open()
    door9.open()
end
