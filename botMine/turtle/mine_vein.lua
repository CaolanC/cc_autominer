function DFS()

    local back = false

    if insF() then
        turtle.dig()
        turtle.forward()
        DFS()
        turtle.back()

    end

    if insD() then
        turtle.digDown()
        turtle.down()
        DFS()
        turtle.up()

    end


    if insU() then
        turtle.digUp()
        turtle.up()
        DFS()
        turtle.down()

    end
    
    if insR() then
        turtle.dig()
        turtle.forward()
        DFS()
        turtle.back()
        turtle.turnLeft()

    end

    if insL() then
        turtle.dig()
        turtle.forward()
        DFS()

        turtle.back()
        turtle.turnRight()
    
    end
    

    if insBH() then
        turtle.dig()
        turtle.forward()
        DFS()
        turtle.back()
        turtle.turnRight()
        turtle.turnRight()

    end
end

function insF()
    local bf, b = turtle.inspect()
    if bf and b.name == 'minecraft:diamond_ore' then
        return true
    else
        return false
    end
    
end

function insU()
    local bf, b = turtle.inspectUp()
    print(b.name)
    if bf and b.name == 'minecraft:diamond_ore' then
        return true
    else
        return false
    end
    
end

function insD()
    local bf, b = turtle.inspectDown()
    if bf and b.name == 'minecraft:diamond_ore' then
        return true
    else
        return false
    end
    
end

function insR()
    turtle.turnRight()
    local bf, b = turtle.inspect()
    if bf and b.name == 'minecraft:diamond_ore' then
        return true
    else
        turtle.turnLeft()
        return false
    end
    
end

function insL()
    turtle.turnLeft()
    local bf, b = turtle.inspect()
    if bf and b.name == 'minecraft:diamond_ore' then
        return true
    else
        turtle.turnRight()
        return false
    end
    
end

function insBH()
    turtle.turnLeft()
    turtle.turnLeft()
    local bf, b = turtle.inspect()
    if bf and b.name == 'minecraft:diamond_ore' then
        return true
    else
        turtle.turnRight()
        turtle.turnRight()
        return false
    end
    
end