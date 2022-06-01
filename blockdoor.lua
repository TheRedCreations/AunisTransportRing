component = require("component")
event = require("event")
os = require("os")
keypad1 = component.os_keypad
mag1=component.proxy("9c63aa07-ec9d-49ed-a6d6-614c44680127")
mag2=component.proxy("c8c22e72-ffa8-42dc-ac96-ad66f3ad2337")
mag3=component.proxy("c08082cf-6b40-4a79-aa0b-93f89b62194d")
mag4=component.proxy("e56c6150-af54-4f4d-b5d7-0114aee6ac6e")
door1=component.proxy("8e9491a1-c05a-4c1a-8559-c3513bf06b49")
door2=component.proxy("2a28725f-e461-4511-a190-5e98aa0b8857")
door3=component.proxy("cfc14af6-82e3-4caf-b917-49d2558995e7")
door4=component.proxy("81484f05-e354-472b-bf2b-439c81baeaeb")

color = 2
 
customButtons = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "<", "0", "ok"} 
customButtonColor = {color,color,color,color,color,color,color,color,color,color,color,color} 
keypad1.setKey(customButtons, customButtonColor)
 
local pin1 = "0000" --open rolldoors
local pin2 = "0001" --close rolldoors
local password = ""
local time = 5 --time the Rolldoor remains open
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
        keypad1.setDisplay("OPENING", 2)
        door1.open()
        door2.open()
        door3.open()
        door4.open()
        os.sleep(2)
    else if keypadInput == pin2 then
        keypad1.setDisplay("CLOSING", 4)
        door1.close()
        door2.close()
        door3.close()
        door4.close()
        os.sleep(2)
        else
        keypad1.setDisplay("denied", 4)
        os.sleep(5)
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

function keycardEvent(eventName, address, _, cardData, _, _, _)
  
  if(cardData==password) then
  print("keycard used")
   if(address == "9c63aa07-ec9d-49ed-a6d6-614c44680127") then
        door1.open()
        os.sleep(time)
        door1.close()
   end
   if(address == "c8c22e72-ffa8-42dc-ac96-ad66f3ad2337") then
        door2.open()
        os.sleep(time)
        door2.close()
   end
   if(address == "c08082cf-6b40-4a79-aa0b-93f89b62194d") then
        door3.open()
        os.sleep(time)
        door3.close()
   end
   if(address == "e56c6150-af54-4f4d-b5d7-0114aee6ac6e") then
        door4.open()
        os.sleep(time)
        door4.close()
   end
  end
  
 
 
-- listen to keypad events
event.listen("keypad", keypadEvent)
event.listen("magData", keycardEvent)
 
-- clear keypad display
keypad1.setDisplay("")
if not runScriptInBackground then
    -- sleep until the user interrupts the program with CTRL + C
    local stopMe = false
    event.listen("interrupted", function() stopMe = true; end)
    while not stopMe do os.sleep(0.1) end

    -- ignore keypad events on exit
    event.ignore("keypad", keypadEvent)
    event.ignore("magData", keycardEvent)

    -- show that the keypad is inactive
    keypad1.setDisplay("inactive", 6)
end
