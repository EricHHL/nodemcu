--Servidor básico
--[[srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
    conn:on("receive", function(conn, payload)
        print("Recebeu: ", payload)
        conn:send("<h1> Hello, NodeMcu. <\h1>")
    end)
end)]]

--TODO: Colocar esse tipo de coisa num arquivo config
local APName = "NodeMCU"

--TODO: Não colocar a senha da minha wifi na internet pra qualquer um ver
conectaWifi("I am the one who pings", "iamtherouter", true)

function conectaWifi(nome, pwd, ap)
    print("Conectando na rede '"..nome.."'")
    wifi.setmode(wifi.STATION)
    wifi.sta.config({ssid = nome, pwd = pwd})

    wifi.sta.eventMonReg(wifi.STA_CONNECTING, function() print("Conectando..") end)
    wifi.sta.eventMonReg(wifi.STA_WRONGPWD, function() print("Falha: senha incorreta") end)
    wifi.sta.eventMonReg(wifi.STA_APNOTFOUND, function() 
        print("Falha: AP inexistente")
        if ap then 
            print("Iniciando AP")
            iniciaAP(APName, true)
        end
    end)
    wifi.sta.eventMonReg(wifi.STA_FAIL, function() 
        print("Falha ao conectar no AP")
        
    end)
    wifi.sta.eventMonReg(wifi.STA_GOTIP, function() print("Conectado. IP: "..wifi.sta.getip()) end)
    wifi.sta.eventMonStart()
end

function iniciaAP(nome, debug)
    wifi.setmode(wifi.SOFTAP)
    wifi.ap.config({ssid = nome})
    print("AP "..nome)
    if debug then
        wifi.eventmon.register(wifi.eventmon.AP_STACONNECTED, function(T)
           print("Cliente conectado: ".."\n\tMAC: "..T.MAC.."\n\tAID: "..T.AID)
        end)
        wifi.eventmon.register(wifi.eventmon.AP_STADISCONNECTED, function(T)
           print("Cliente desconectado: ".."\n\tMAC: "..T.MAC.."\n\tAID: "..T.AID)
        end)
    end
end
