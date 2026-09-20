-- main.lua
local baseUrl = "https://raw.githubusercontent.com/him312/TFS2-Cheat/main/"

print("[TFS2 Cheat] Загрузка модулей...")

local Config = loadstring(game:HttpGet(baseUrl .. "config.lua"))()
local Utils = loadstring(game:HttpGet(baseUrl .. "utils.lua"))()
local UI = loadstring(game:HttpGet(baseUrl .. "ui.lua"))()
local BigHead = loadstring(game:HttpGet(baseUrl .. "bighead.lua"))()
local Highlight = loadstring(game:HttpGet(baseUrl .. "highlight.lua"))()

local Zombies = Utils.getZombies()
if not Zombies then
    warn("[TFS2 Cheat] Zombies не найден")
    return
end

local UIObjects = UI.createWindow(Config, Utils)

-- Только BigHead и Highlight — без Aim
BigHead.Init(Config, Utils, UI, UIObjects)
Highlight.Init(Config, Utils, UI, UIObjects)

print("[TFS2 Cheat] Модули загружены (Aim отключён)")
