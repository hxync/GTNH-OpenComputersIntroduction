local function doUntil(func, errMessage)
    local result = func()
	if not result and errMessage then
		print(errMessage)
	end
    while not result do
        os.sleep(1)
        result = func()
    end
    return result
end


-- 用法1
local robot = require("robot")
--[[
    robot.dropUp()
    if robot.count(1) > 0 then
        print("输出容器已满！")
    end
    while robot.count(1) > 0 do
        os.sleep(2)
        robot.dropUp()
    end
]]
doUntil(function()
    robot.dropUp()
    return robot.count(1) == 0
end, "输出容器已满！")


-- 用法2（不推荐）
--[[
    while not robot.forward() do
        os.sleep(0)
    end
]]
doUntil(function() return robot.forward() end)


-- 用法3
local function searchItem(filterTable)
    -- 搜索物品，返回槽位(实现过程不重要)
    return slot--没找到返回nil
end

doUntil(function()
    robot.select(
    doUntil(function()
        return searchItem({name = "minecraft:stone"})
    end, "未找到石头"))
    return robot.place()
end, "放置石头失败")
--[[
    robot.select(
    doUntil(function()
        return searchItem({name = "minecraft:stone"})
    end, "未找到石头"))
    doUntil(function()
        return robot.place()
    end, "放置石头失败")
]]