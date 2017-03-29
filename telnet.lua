if telnet_srv then
    --pcall(telnet_srv:close())
end
telnet_srv = net.createServer(net.TCP, 180)
telnet_srv:listen(23, function(socket)
    local fifo = {}
    local fifo_drained = true

    local function sender(c)
        if #fifo > 0 then
            c:send(table.remove(fifo, 1))
        else
            fifo_drained = true
        end
    end

    local function s_output(str)
        table.insert(fifo, str)
        if socket ~= nil and fifo_drained then
            fifo_drained = false
            sender(socket)
        end
    end

    node.output(s_output, 1)   -- re-direct output to function s_ouput.

    socket:on("receive", function(c,l)
        err, msg = pcall(loadstring(l))
        if not err then
            print("erro: "..msg)
        end
        --node.input(l)
    end)
    socket:on("disconnection", function(c)
        node.output(nil)        -- un-regist the redirect output function, output goes to serial
    end)
    socket:on("sent", sender)

    print("NodeMCU conectado.")
end)
