-- extras.lua
local Extras = {}

function Extras.Init(Config, Utils, UI, UIObjects)
    UI.createHeader(UIObjects.ScrollFrame, Utils, "Extras")
    
    UI.createButton(UIObjects.ScrollFrame, Utils, "Melee Aura", 25, Color3.fromRGB(180, 120, 50), function()
        print("[Melee Aura] Загрузка...")
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/GOLDEN1092/Roblox-script/main/Gold_Aura"))()
        end)
        if success then
            print("[Melee Aura] Загружен")
        else
            warn("[Melee Aura] Ошибка:", err)
        end
    end)
    
    print("[Extras] Загружен")
end

return Extras
