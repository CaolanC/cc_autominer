function main()
    shell.run("clear")
    MODEM_S = modemSide()
    if MODEM_S then
        local command 
        while command ~= "exit()" do
            io.write("$ ")
            command = io.read()
            commands(command) 
        end
    else print("No modem connected.")
    end
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

function commands(Ucommand)

    local command = {}
    for i in string.gmatch(Ucommand, "%S+") do
        table.insert(command, i)
    end

    if command[1] == "help" then
        print("Help yourself lol.")
    elseif command[1] == "team" then
        if command[2] == 'create' then
            io.write("Team Name: ")
            local teamName = io.read()
            io.write("Enter IDs on each newline. Type DONE when all IDs entered.\n")
            local ID = io.read()
            local IDs = {}
            while ID ~= "DONE" do
                table.insert(IDs, tonumber(ID))
                ID = io.read()
            end
            createTeam(IDs, teamName) 
        elseif command[2] == "mine" then
            mineTeam(command[3], command[4], command[5], command[6])
        end
    end
    
end

function createTeam(IDs, teamName)
    rednet.open(MODEM_S)
    local teamIDs = ""
    local teamSize = #IDs
    for i, v in ipairs(IDs) do
        rednet.send(tonumber(IDs[i]), {teamName, i, teamSize}, "createTeam")
        teamIDs = teamIDs .. tostring(IDs[i] .. "\n")
    end
    local teamNameIDs = fs.open("./teams/" .. teamName .. ".txt", "w")
    teamNameIDs.write(teamIDs)
    teamNameIDs.close()
end

function mineTeam(teamName, x, y, z)
    rednet.open(MODEM_S)
    if fs.exists("./teams/" .. teamName .. ".txt") then
        for ID in io.lines("./teams/" .. teamName .. ".txt") do
            ID = tonumber(ID)
            rednet.send(ID, {x, y, z}, "mineTeam")
        end
    else
        print("Team doesn't exist.")
    end
end

main()