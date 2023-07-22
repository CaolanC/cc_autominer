function STRIPMINE()

os.loadAPI("./mine_vein.lua")

local mine_vein = mine_vein

local desired_ores = {"minecraft:diamond_ore"}

function insB()
    turtle.turnLeft()
    local bf, b = turtle.inspect()
    if b then
        for i, v in ipairs(desired_ores) do
            if desired_ores[i] == b.name then
                turtle.turnRight()
                return true
            end
        end
    end
    turtle.turnRight()
    local bf, b = turtle.inspect()
    if b then
        for i, v in ipairs(desired_ores) do
            if desired_ores[i] == b.name then
                return true
            end
        end
    end

    turtle.turnRight()
    local bf, b = turtle.inspect()
    if b then
        for i, v in ipairs(desired_ores) do
            if desired_ores[i] == b.name then
                turtle.turnLeft()
                return true
            end
        end
    end

    turtle.turnLeft()

    local bf, b = turtle.inspectUp()
    if b then
        for i, v in ipairs(desired_ores) do
            if desired_ores[i] == b.name then
                return true
            end
        end
    end
    local bf, b = turtle.inspectDown()
    if b then
        for i, v in ipairs(desired_ores) do
            if desired_ores[i] == b.name then
                return true
            end
        end
    end
    return false
end

while true do
    if insB() then
        mine_vein.DFS()
    end

    if turtle.detect() then
        turtle.dig()
    end

    turtle.forward()

    if insB() then
        mine_vein.DFS()
    end

    if turtle.detectUp() then
        turtle.digUp()
    end

    turtle.up()

    if insB() then
        mine_vein.DFS()
    end

    if turtle.detect() then
        turtle.dig()
    end

    turtle.forward()

    if insB() then
        mine_vein.DFS()
    end

    if turtle.detectDown() then
        turtle.digDown()
    end

    turtle.down()
    
end

end