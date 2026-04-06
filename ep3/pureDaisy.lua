-- 版本1
local robot = require("robot")

local function operate(status)
    if status == 0 then
    robot.select(2)
    robot.placeDown()
    elseif status == 1 then
    robot.select(1)
    robot.swingDown()
    robot.select(2)
    robot.placeDown()
    elseif status == 2 then
    robot.select(1)
    robot.swingDown()
    end
end

local status = 0
local function workCycle()
    --根据从下方容器吸取的物品数量来判断状态
    robot.select(2)
    if robot.suckDown(8) == 0 then
        if status == 0 then
            return false
        elseif status == 1 then
            status = 2
        end
    end
    --执行一轮
    robot.forward()
    for i = 1, 4 do
        operate(status)
        robot.forward()
        operate(status)
        robot.forward()
        if i ~= 4 then
            robot.turnLeft()
        end
    end
    robot.turnRight()
    robot.forward()
    robot.turnAround()
    --将成品放入上方容器
    if status ~= 0 then
        robot.select(1)
        robot.dropUp()
        if robot.count(1) > 0 then
            print("输出容器已满！")
        end
        while robot.count(1) > 0 do
            os.sleep(4)
            robot.dropUp()
        end
    end
    --调整状态
    if status ~= 2 then
        status = 1
        return true
    else
        status = 0
        return false
    end
end

local function main()
    while true do
        workCycle()
        os.sleep(55)
    end
end

main()

-- 版本2
local robot = require("robot")

local function forward()
    while not robot.forward() do
        os.sleep(0)
    end
end

local function operate(status)
    if status == 0 then
    robot.select(2)
    robot.placeDown()
    elseif status == 1 then
    robot.select(1)
    robot.swingDown()
    robot.select(2)
    robot.placeDown()
    elseif status == 2 then
    robot.select(1)
    robot.swingDown()
    end
end

local status = 0
local function workCycle()
    --根据从下方容器吸取的物品数量来判断状态
    robot.select(2)
    if robot.suckDown(8) == 0 then
        if status == 0 then
            return false
        elseif status == 1 then
            status = 2
        end
    end
    --执行一轮
    forward()
    for i = 1, 4 do
        operate(status)
        forward()
        operate(status)
        forward()
        if i ~= 4 then
            robot.turnLeft()
        end
    end
    robot.turnRight()
    forward()
    robot.turnAround()
    --将成品放入上方容器
    if status ~= 0 then
        robot.select(1)
        robot.dropUp()
        if robot.count(1) > 0 then
            print("输出容器已满！")
        end
        while robot.count(1) > 0 do
            os.sleep(4)
            robot.dropUp()
        end
    end
    --调整状态
    if status ~= 2 then
        status = 1
        return true
    else
        status = 0
        return false
    end
end

local function main()
    while true do
        workCycle()
        os.sleep(55)
    end
end

main()