local gpu = component.proxy(component.list("gpu")())
local screen = component.proxy(component.list("screen")())
gpu.bind(screen.address)

local depth = gpu.maxDepth()
gpu.setDepth(depth)

gpu.fill(1, 1, 100, 50, " ")

for i = 1, 8 do
    if depth == 4 then
        -- 2级屏幕
        gpu.setForeground(i, true)
        gpu.set(1, i, "Hello World!")
    elseif depth == 8 then
        -- 3级屏幕
        gpu.setForeground(math.random(0x100000, 0xFFFFFF))
        gpu.set(1, i, "Hello ")
        gpu.setForeground(math.random(0x100000, 0xFFFFFF))
        gpu.set(7, i, "World")
        gpu.setForeground(math.random(0x100000, 0xFFFFFF))
        gpu.set(12, i, "!")
    else
        -- 1级屏幕
        gpu.setForeground(0xFFFFFF)
        gpu.set(1, i, "Hello World!")
    end
end
while true do
    computer.pullSignal()
end