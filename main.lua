-- main.lua — CLEANUP + все модули
local CoreGui = game:GetService("CoreGui")

-- Удаляем ВСЕ старые окна TFS2CheatMenu
local removed = 0
for _, gui in ipairs(CoreGui:GetChildren()) do
    if gui.Name == "TFS2CheatMenu" then
        gui:Destroy()
        removed = removed + 1
    end
end
print("[Cleanup] Удалено старых окон:", removed)

task.wait(0.5)

-- Загрузка модулей
local baseUrl = "https://raw.githubusercontent.com/him312/TFS2-Cheat/main/"

local Config = loadstring(game:HttpGet(baseUrl .. "config.lua"))()
local Utils = loadstring(game:HttpGet(baseUrl .. "utils.lua"))()
local UI = loadstring(game:HttpGet(baseUrl .. "ui.lua"))()
local BigHead = loadstring(game:HttpGet(baseUrl .. "bighead.lua"))()
local Aim = loadstring(game:HttpGet(baseUrl .. "aim.lua"))()
local Highlight = loadstring(game:HttpGet(baseUrl .. "highlight.lua"))()

local Zombies = Utils.getZombies()
local UIObjects = UI.createWindow(Config, Utils)

-- Инициализация модулей (каждый в pcall, чтобы один не сломал другие)
print("[Test] BigHead Init...")
local ok1, err1 = pcall(function() BigHead.Init(Config, Utils, UI, UIObjects) end)
print("[Test] BigHead:", ok1, err1)

print("[Test] Aim Init...")
local ok2, err2 = pcall(function() Aim.Init(Config, Utils, UI, UIObjects) end)
print("[Test] Aim:", ok2, err2)

print("[Test] Highlight Init...")
local ok3, err3 = pcall(function() Highlight.Init(Config, Utils, UI, UIObjects) end)
print("[Test] Highlight:", ok3, err3)

print("[TFS2 Cheat] Загружено. Старых окон удалено:", removed)
