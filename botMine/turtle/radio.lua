function main()
    rednet.open(modemSide())
    while true do
        local sID, message, protocol = rednet.receive()
        print("MESSAGE RECEIVED\nTYPE: " .. protocol)
        if protocol == "createTeam" then
            joinTeam(message)
        elseif protocol == "mineTeam" then
            shell.run("bg mineTeam " .. message[1] .. " " .. message[2] .. " " .. message[3])
        else
            print("INCOMPATIBLE PROTOCOL: IGNORING")
        end
    end
end

function joinTeam(info)
    local teamName = info[1]
    local botNumber = info[2]
    local teamSize = info[3]
    shell.run("label set " .. teamName .. botNumber)
    turtle.teamName = teamName
    turtle.teamBotNo = botNumber
    local config = fs.open("team-config.txt", "w")
    config.write(teamName .. "\n" .. botNumber .. "\n" .. teamSize)
    config.close()
end

function modemSide()

    local modem = peripheral.find('modem')

    if modem then
        local sides = peripheral.getNames()
    
        for i = 1, #sides do
            if peripheral.getType(sides[i]) == "modem" then
                return sides[i]
            end
        end
    
    end
end

main()