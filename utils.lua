--Print table
function printt(t)
    for k,v in pairs(t) do
        print(k,v)
    end
end

--Mostra conteudo de um arquivo
function show(f)
    if file.open(f) then
        print(file.read())
        file.close()
    else
        print("Unable to open file")
    end
end

function dir()
    printt(file.list())
end

function led(on)
    if on == nil then
        led(true)
        tmr.delay(10000)
        led(false)
        return
    end
    gpio.mode(4, gpio.OUTPUT)
    if on then
        gpio.write(4, gpio.LOW)
    else
        gpio.write(4, gpio.HIGH)
    end
end
