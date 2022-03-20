component = require("component")
event = require("event")
os = require("os")
door1 = component.proxy("015fc9a1-db04-41a3-af5e-f77f8876c5bd")
door2 = component.proxy("b226518a-5993-4dc1-925e-663d56cceae6")
door3 = component.proxy("c4ec2c64-bef2-4be3-afb7-6bdb3bbbe128")
door4 = component.proxy("b8fa9f46-3af7-4b3a-9e3b-3bcbe3219188")
door5 = component.proxy("276747ca-8fa9-4b81-9c5f-1f5402b5c79f")
door6 = component.proxy("4fcf810f-c3cc-468a-90ff-b40a022f5f01")
door7 = component.proxy("e01695bc-c6ad-4a5b-915b-14d4a9e37275")
door8 = component.proxy("ad2f93ed-14f4-4599-81a9-58444d5ac931")
door9 = component.proxy("40010559-859a-430d-9c7c-ad7ed939f668")
keypad1 = component.proxy("3187d470-afd7-4f85-825f-e8651192ef2c")
color = 2
 
customButtons = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "<", "0", "ok"} 
customButtonColor = {color,color,color,color,color,color,color,color,color,color,color,color} 
keypad1.setKey(customButtons, customButtonColor)
 
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
end
