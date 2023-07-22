function safeGoTo(tx, ty, tz)
    local x1, y1, z1 = gps.locate()
    local x, y, z = gps.locate()

    while y ~= 80 do
        print("Ascending", y)
        if turtle.detectUp() then
        turtle.digUp()
        end

        turtle.up()
        x, y, z = gps.locate()
    end

    while x <= x1 do
        print("Orienting", x)
         turtle.turnLeft()
         if turtle.detect() then
            turtle.dig()
    end
        turtle.forward()
        x, y, z = gps.locate()
        turtle.back()
    end

    -- We are now facing East.

    x, y, z = gps.locate()

    if x < tx then
        while x ~= tx do
            print("Moving +X", x)
            if turtle.detect() then
                turtle.dig()
            end
            turtle.forward()
            x = x + 1
        end
    elseif x > tx then
        turtle.turnLeft()
        turtle.turnLeft()
        while x ~= tx do
            print("Moving -X", x)
            if turtle.detect() then turtle.dig() end
            turtle.forward()
            x = x - 1
        end
        turtle.turnLeft()
        turtle.turnLeft()
    end

    if z < tz then
        turtle.turnRight()
        while z ~= tz do
            print("Moving +Z", x)
            if turtle.detect() then turtle.dig() end
            turtle.forward()
            z = z + 1
        end
        turtle.turnLeft()
    elseif z > tz then
        turtle.turnLeft()
        while z ~= tz do
            print("Moving -Z", x)
            if turtle.detect() then turtle.dig() end
            turtle.forward()
            z = z - 1
        end
        turtle.turnRight()
    end

    while y ~= ty do
        if turtle.detectDown() then turtle.digDown() end
        turtle.down()
        y = y - 1
    end

    ENTRANCE = {x, y, z}
end

function directGoTo(tx, ty, tz)
    local x1, y1, z1 = gps.locate()
    local x, y, z = gps.locate()

    while x <= x1 do
         turtle.turnLeft()
         if turtle.detect() then
            turtle.dig()
    end
        turtle.forward()
        x, y, z = gps.locate()
        turtle.back()
    end

    -- We are now facing East.

    -- Add up detection as well

    
    while y ~= ty do
        if turtle.detectDown() then turtle.digDown() end
        turtle.down()
        x, y, z = gps.locate()
    end

    if tx >= x then
        while x ~= tx do
            if turtle.detect() then
                turtle.dig()
            end
            turtle.forward()
            x, y, z = gps.locate()
        end
    else
        turtle.turnLeft()
        turtle.turnLeft()
        while x ~= tx do
            if turtle.detect() then turtle.dig() end
            turtle.forward()
            x, y, z = gps.locate()
        end
        turtle.turnLeft()
        turtle.turnLeft()
    end

    if tz > z then
        turtle.turnRight()
        while z ~= tz do
            if turtle.detect() then turtle.dig() end
            turtle.forward()
            x, y, z = gps.locate()
        end
        turtle.turnLeft()
    else
        turtle.turnLeft()
        while z ~= tz do
            if turtle.detect() then turtle.dig() end
            turtle.forward()
            x, y, z = gps.locate()
        end
        turtle.turnRight()
    end

    ENTRANCE = gps.locate()
end