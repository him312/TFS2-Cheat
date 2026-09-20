-- utils.lua
local Utils = {}

-- Глобальный счётчик (используется и в ui.lua, и в модулях)
local layoutCounter = 0
function Utils.nextOrder()
    layoutCounter = layoutCounter + 1
    return layoutCounter
end

function Utils.getZombieType(zombie, ALL_ZOMBIE_TYPES)
    local name = zombie.Name
    name = name:gsub("Zombie$", ""):gsub("Zombie", "")
    name = name:gsub("_", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    
    if name == "" then return "Common" end
    
    if name:lower() == "heavyarmour" or name:lower() == "heavyarmor" then return "Heavy Armour" end
    if name:lower() == "armoured" or name:lower() == "armored" then return "Armour" end
    if name:lower() == "drenchwraith" then return "Drench Wraith" end
    if name:lower() == "frostwraith" then return "Frost Wraith" end
    if name:lower() == "swampgiant" then return "Swamp Giant" end
    if name:lower() == "longarm" then return "Long Arm" end
    
    for _, zType in pairs(ALL_ZOMBIE_TYPES) do
        if name:lower() == zType:lower() then return zType end
        if name:lower():gsub("%s", "") == zType:lower():gsub("%s", "") then return zType end
    end
    
    for _, zType in pairs(ALL_ZOMBIE_TYPES) do
        if name:lower():find(zType:lower():gsub("%s", "")) then return zType end
    end
    
    return name
end

function Utils.getZombies()
    local Zombies = workspace:FindFirstChild("Zombies")
    if not Zombies then
        print("[Utils] Ждём Zombies...")
        Zombies = workspace:WaitForChild("Zombies", 300)
    end
    return Zombies
end

return Utils
