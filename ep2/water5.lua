-- 版本1
local component = require("component")
local sides = require("sides")

local plasmaTransposer = component.proxy()
local coolantTransposer = component.proxy()
local gt_machine = component.gt_machine

local sidePlasmaIn = sides.up
local sidePlasmaOut = sides.north
local slotPlasma = 1
local sideCoolantIn = sides.up
local sideCoolantOut = sides.west
local slotCoolant = 1

if not plasmaTransposer then
    error("缺少可用的氦等离子体转运器")
end
if not coolantTransposer then
    error("缺少可用的超级冷却液转运器")
end
if not gt_machine or gt_machine.getName() ~= "multimachine.purificationunitplasmaheater" then
    error("未找到五级净化水单元")
end

while true do
    local workProgress = gt_machine.getWorkProgress()
    if workProgress > 0 and workProgress < 600 then
        for i = 1, 3 do
            plasmaTransposer.transferFluid(sidePlasmaIn, sidePlasmaOut, 100, slotPlasma)
            os.sleep(11)
            coolantTransposer.transferFluid(sideCoolantIn, sideCoolantOut, 2000, slotCoolant)
            os.sleep(21)
        end
    end
    os.sleep(5)
end


-- 版本2
local component = require("component")
local sides = require("sides")

local plasmaTransposer = component.proxy()
local coolantTransposer = component.proxy()
local gt_machine = component.gt_machine

local sidePlasmaIn = sides.up
local sidePlasmaOut = sides.north
local slotPlasma = 1
local sideCoolantIn = sides.up
local sideCoolantOut = sides.west
local slotCoolant = 1

if not plasmaTransposer then
    error("缺少可用的氦等离子体转运器")
end
if not coolantTransposer then
    error("缺少可用的超级冷却液转运器")
end
if not gt_machine or gt_machine.getName() ~= "multimachine.purificationunitplasmaheater" then
    error("未找到五级净化水单元")
end

local hasShutdown = false
while true do
    local workProgress = gt_machine.getWorkProgress()
    if workProgress > 0 and workProgress < 600  then
        for i = 1, 3 do
            plasmaTransposer.transferFluid(sidePlasmaIn, sidePlasmaOut, 100, slotPlasma)
            os.sleep(11)
            coolantTransposer.transferFluid(sideCoolantIn, sideCoolantOut, 2000, slotCoolant)
            os.sleep(21)
        end
        if plasmaTransposer.getFluidInTank(sidePlasmaIn)[slotPlasma].amount < 300 or coolantTransposer.getFluidInTank(sideCoolantIn)[slotCoolant].amount < 6000 then
            gt_machine.setWorkAllowed(false)
            hasShutdown = true
        end
    end
    if workProgress == 0 and hasShutdown and plasmaTransposer.getFluidInTank(sidePlasmaIn)[slotPlasma].amount >= 300 and coolantTransposer.getFluidInTank(sideCoolantIn)[slotCoolant].amount >= 6000 then
        gt_machine.setWorkAllowed(true)
        hasShutdown = false
    end
    os.sleep(5)
end

-- 版本3
local component = require("component")
local sides = require("sides")

local gt_machine = component.gt_machine

local plasmaTransposer, sidePlasmaIn, sidePlasmaOut, slotPlasma
local coolantTransposer, sideCoolantIn, sideCoolantOut, slotCoolant

for address, _ in component.list("transposer") do
    local proxy = component.proxy(address)
    local sideIn, sideOut, slot, liquid
    for side = 0, 5 do
        local inventoryName = proxy.getInventoryName(side)
        if inventoryName == "gt.blockmachines" then
            if sideOut then
                sideOut = nil
                break
            end
            sideOut = side
        elseif inventoryName == "tile.fluid_interface" then
            if sideIn then
                break
            end
            local err = false
            for tank, fluid in pairs(proxy.getFluidInTank(side)) do
                if fluid.name == "plasma.helium" or fluid.name == "supercoolant" then
                    if liquid and liquid ~= fluid.name then
                        liquid = nil
                        err = true
                        break
                    elseif not liquid then
                        liquid = fluid.name
                        sideIn = side
                    end
                        slot = tank
                end
            end
            if err then
                break
            end
        end
    end
    if sideOut and liquid then
        if liquid == "plasma.helium" then
            plasmaTransposer, sidePlasmaIn, sidePlasmaOut, slotPlasma = proxy, sideIn, sideOut, slot
        else
            coolantTransposer, sideCoolantIn, sideCoolantOut, slotCoolant = proxy, sideIn, sideOut, slot
        end
    end
end
if not plasmaTransposer then
    error("未找到可用的氦等离子体转运器")
end
if not coolantTransposer then
    error("未找到可用的超级冷却液转运器")
end
if not gt_machine or gt_machine.getName() ~= "multimachine.purificationunitplasmaheater" then
    error("未找到五级净化水单元")
end

local hasShutdown = false
while true do
    local workProgress = gt_machine.getWorkProgress()
    if workProgress > 0 and workProgress < 600  then
        for i = 1, 3 do
            plasmaTransposer.transferFluid(sidePlasmaIn, sidePlasmaOut, 100, slotPlasma)
            os.sleep(11)
            coolantTransposer.transferFluid(sideCoolantIn, sideCoolantOut, 2000, slotCoolant)
            os.sleep(21)
        end
        if plasmaTransposer.getFluidInTank(sidePlasmaIn)[slotPlasma].amount < 300 or coolantTransposer.getFluidInTank(sideCoolantIn)[slotCoolant].amount < 6000 then
            gt_machine.setWorkAllowed(false)
            hasShutdown = true
        end
    end
    if workProgress == 0 and hasShutdown and plasmaTransposer.getFluidInTank(sidePlasmaIn)[slotPlasma].amount >= 300 and coolantTransposer.getFluidInTank(sideCoolantIn)[slotCoolant].amount >= 6000 then
        gt_machine.setWorkAllowed(true)
        hasShutdown = false
    end
    os.sleep(5)
end