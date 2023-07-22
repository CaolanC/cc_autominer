

function inventory_dic()
    i = 1
    inventory = {}
    while i <= 16 do
        local ITEM = turtle.getItemDetail(i)
        if ITEM then
            inventory[i] = {ITEM.name, ITEM.count}
        else
            inventory[i] = {nil}
        end
        print(inventory[i][1])
        i = i + 1
    end
    return inventory
end

function findItemSlot(item, inventory)
    i = 1
    while i <= 16 do
        if inventory[i][1] == item then
            return i
        end
        i = i + 1
    end
end

function findAndRefuel(item, inventory)
    i = 1
    while i <= 16 do
        if inventory[i][1] == item then
            turtle.select(i)
            turtle.refuel()
        end
        i = i + 1
    end
end

function autoRefuel()
    local fuels = {'minecraft:coal', 'minecraft:oak_log'}
    for i, v in ipairs(fuels) do
        findAndRefuel(fuels[i], inventory_dic())
    end
end

autoRefuel()