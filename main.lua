-- main.lua — CLEANUP + BigHead
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

-- Дальше загрузка модулей
local baseUrl = "https://raw.githubusercontent.com/him312/TFS2-Cheat/main/"

local Config = loadstring(game:HttpGet(baseUrl .. "config.lua"))()
local Utils = loadstring(game:HttpGet(baseUrl .. "utils.lua"))()
local UI = loadstring(game:HttpGet(baseUrl .. "ui.lua"))()
local BigHead = loadstring(game:HttpGet(baseUrl .. "bighead.lua"))()

local Zombies = Utils.getZombies()
local UIObjects = UI.createWindow(Config, Utils)

BigHead.Init(Config, Utils, UI, UIObjects)

print("[TFS2 Cheat] Загружено. Старых окон удалено:", removed)
