-- main.lua
local baseUrl = "https://raw.githubusercontent.com/him312/TFS2-Cheat/main/"

print("[TFS2 Cheat] Загрузка модулей...")

local Config = loadstring(game:HttpGet(baseUrl .. "config.lua"))()
local Utils = loadstring(game:HttpGet(baseUrl .. "utils.lua"))()
local UI = loadstring(game:HttpGet(baseUrl .. "ui.lua"))()
local Aim = loadstring(game:HttpGet(baseUrl .. "aim.lua"))()
local BigHead = loadstring(game:HttpGet(baseUrl .. "bighead.lua"))()
local Highlight = loadstring(game:HttpGet(baseUrl .. "highlight.lua"))()

-- Ждём Zombies
local Zombies = Utils.getZombies()
if not Zombies then
    warn("[TFS2 Cheat] Zombies не найден")
    return
end

-- Создаём UI
local UIObjects = UI.createWindow(Config, Utils)

-- Инициализация модулей
Aim.Init(Config, Utils, UI, UIObjects)
BigHead.Init(Config, Utils, UI, UIObjects)
Highlight.Init(Config, Utils, UI, UIObjects)

print("[TFS2 Cheat] Все модули загружены!")
print("  RightAlt — вкл/выкл Aim Assist")
print("  Big Head — секция в меню")
print("  Highlight — секция в меню")
