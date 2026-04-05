local component = require("component")
local sides = require("sides")

local redstone = component.redstone
local transposer = component.transposer

local slot = 9

while true do
    if redstone.getInput(sides.bottom) > 0 then
        transposer.transferItem(sides.bottom, sides.top, 1, 1, slot)
        if slot < 9 then
            slot = slot + 1
        else
            slot = 1
        end
        transposer.transferItem(sides.up, sides.bottom, 1, slot, 1)
    end
    os.sleep(1)
end