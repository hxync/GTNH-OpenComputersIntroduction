for i=1,4 do
    computer.beep(1000,0.5)
    local t = computer.uptime()
    while computer.uptime() - t < 1 do
        computer.pullSignal(0.1)
    end
end
computer.shutdown()

--print("helloworld")