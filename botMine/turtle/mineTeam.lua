os.loadAPI("./travel.lua")
os.loadAPI("./stripmine.lua")

TRV = travel
STM = stripmine

function main()
    print("Going To:" .. arg[1], arg[2], arg[3])
    local x, y, z = gps.locate()
    local origin = {x, y, z}
    local coords = ""
    for i in ipairs(origin) do
        coords = origin[i] .. "\n"
    end
    origin = fs.open("current_trip_origin", "w")
    origin.write(coords)
    origin.close()
    local botNo
    local teamSize
    local teamName
    local line_no = 1
    for i in io.lines("team-config.txt") do
        if line_no == 1 then
            teamName = i
        elseif line_no == 2 then
            botNo = tonumber(i)
        elseif line_no == 3 then 
            teamSize = tonumber(i)
            break
        end
        line_no = line_no + 1
    end
    sleep((botNo - 1) * 7)
    local oX, oY, oZ = positionOffset(botNo, tonumber(arg[1]), tonumber(arg[2]), tonumber(arg[3]))
    TRV.safeGoTo(oX, oY, oZ)
    if botNo == 1 then
        LEADER(teamSize, oX, oY, oZ, teamName)
    else
        FOLLOWER(botNo, teamName, teamSize)
    end
end

function LEADER(teamSize, x, y, z, teamName)
    waitForTeam(teamSize, teamName)
    local safeDistance = 4
    local dCovered = 0
    while dCovered < safeDistance do
        while turtle.detect() do
            turtle.dig()
            sleep(0.3)
        end
        turtle.forward()
        x = x + 1
        dCovered = dCovered + 1
    end
    local minesOpened = 2
    declareMine(minesOpened, x, y, z)
    while minesOpened < teamSize do
        local bCovered = 0
        while bCovered <= 3 do
            while turtle.detect() do
                turtle.dig()
                sleep(0.3)
            end
            turtle.forward()
            x = x + 1
            bCovered = bCovered + 1
        end
        minesOpened = minesOpened + 1
        declareMine(minesOpened, x, y, z)
    end
    turtle.turnLeft()
    STM.STRIPMINE()
end

function waitForTeam(teamSize, teamName)
    local arrived = 1
    while arrived < teamSize do
        local _, message = rednet.receive("mineArrive")
        if message == teamName then
            arrived = arrived + 1 
        end
    end
end

function declareMine(mineNumber, x, y ,z)
    rednet.open(modemSide())
    local ACK = false
    while not ACK do
        print("No ACK")
        rednet.broadcast({mineNumber, x, y, z}, "mineOpened")
        local REC, message = rednet.receive("ACKmineAvailable", 1)
        if REC and tonumber(message) == tonumber(mineNumber) then
            ACK = true
        end
    end
end

function FOLLOWER(botNo, teamName, teamSize)
    rednet.open(modemSide())
    rednet.broadcast(teamName, "mineArrive")
    local botCalled = false
    local mineAvailable = false
    local instructions
    while not botCalled or not mineAvailable do
        local sID, message, protocol = rednet.receive()
        if sID and protocol == "mineOpened" then
            print(message[1], botNo)
        elseif sID and protocol == "stripArrive" then
            print("Predecessor Contacted:", message, "Predecessor Expected:", botNo -1)
        end
        if not botCalled and protocol == "mineOpened" and tonumber(message[1]) == botNo then
            print("Mine Available: True")
            local msgE = 0
            while msgE < 5 do
                rednet.broadcast(botNo, "ACKmineAvailable")
                msgE = msgE + 1
            end
            instructions = message[2]
            botCalled = true
        elseif not mineAvailable and (protocol == "stripArrive" and tonumber(message) == botNo - 1) or botNo == 2 then
            print("Predecessor Arrived: True")
            mineAvailable = true
            local msgE = 0
            while msgE < 5 do
                rednet.broadcast(botNo, "ACKstripArrive")
                msgE = msgE + 1
            end
        end
    end
    sleep(4)
    goToMine(botNo, instructions, teamSize)
end

function waitForFollower(botNo)
    rednet.open(modemSide())
    local predecessor_arrived = false
    while not predecessor_arrived do
        local _, message = rednet.receive("stripArrive")
        if tonumber(message) == botNo - 1 then
            predecessor_arrived = true
        end
    end
end

function goToMine(botNo, co, teamSize)
    local level = math.floor((botNo - 1) / 5)
    local botNo = (botNo - 1) % 5
    local safeDistance
    local bDescended = 0
    while bDescended < level do
        turtle.down()
        bDescended = bDescended + 1
    end
    if botNo == 1 then
        safeDistance = 5

    elseif botNo == 0 then
        safeDistance = 4
    
    elseif botNo == 2 then
        safeDistance = 6
    elseif botNo == 4 then
        turtle.turnRight()
        turtle.forward()
        turtle.turnLeft()
        safeDistance = 5
    elseif botNo == 3 then
        turtle.turnLeft()
        turtle.forward()
        turtle.turnRight()
        safeDistance = 5
    end

    local sCovered = 0
    while sCovered < safeDistance do
        turtle.forward()
        sCovered = sCovered + 1
    end

    local bCovered = 0
    local distance = (botNo - 1) * 3
    while bCovered < distance do
        turtle.forward()
        bCovered = bCovered + 1
    end
    turtle.turnLeft()

    if (botNo + 1) < teamSize then
        local ACK = false
        while not ACK do
            rednet.broadcast(botNo + 1, "stripArrive")
            local REC, message = rednet.receive("ACKstripArrive", 1)
            if REC and tonumber(message) == tonumber(botNo + 2) then
                ACK = true
            end
        end 
    end
    STM.STRIPMINE()
end

function positionOffset(botNo, x, y, z)
    local level = math.floor((botNo - 1) / 5)
    local pos = (botNo - 1) % 5
    print(pos)
    if pos == 0 then
        x = x + 1
    elseif pos == 2 then
        x = x - 1
    elseif pos == 3 then
        z = z + 1
    elseif pos == 4 then 
        z = z - 1 
    end

    y = y + level
    print("OFF: ", x, y, z)
    return x, y, z
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