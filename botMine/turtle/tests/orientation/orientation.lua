local x, y, z = gps.locate()

local x1 = x

while x <= x1 do
    print("Orienting", x,y,z)
     turtle.turnLeft()
     if turtle.detect() then
        turtle.dig()
    end
    turtle.forward()
    x, y, z = gps.locate()
    turtle.back()
end