i = turtle.inspect()

function stripmine()
    while turtle.getFuelLevel > 200 do
        local blockFound, block = turtle.inspect()
        if blockFound and block.name == 'minecraft:stone' then
            turtle.dig()
            
        end
    end
end