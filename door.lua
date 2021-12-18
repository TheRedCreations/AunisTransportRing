component = require("component")
event = require("event")

local gate_iter = component.list('os_keypad')
local keypad1, keypad2 = component.proxy(gate_iter()), component.proxy(gate_iter())

local pin = "170902"
local keypadInput = ""

-- set this to true if you want to run the script as daemon
local runScriptInBackground = false

function updateDisplay()
    local displayString = ""
    for i=1,#keypadInput do
        displayString = displayString .. "*"
    end

    keypad1.setDisplay(displayString, 7)
    keypad2.setDisplay(displayString, 7)
end

function checkPin()
    if keypadInput == pin then
        keypad1.setDisplay("granted", 2)
	keypad2.setDisplay("granted", 2)
    else
        keypad1.setDisplay("denied", 4)
	keypad2.setDisplay("denied", 4)
    end    
    keypadInput = ""
    os.sleep(1)
end

function keypadEvent(eventName, address, button, button_label)
    print("button pressed: " .. button_label)
  
    if button_label == "*" then
        -- remove last character from input cache
        keypadInput = string.sub(keypadInput, 1, -2)
    elseif button_label == "#" then
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
keypad2.setDisplay("")
