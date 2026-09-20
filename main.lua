-- main.lua — ТЕСТ
local baseUrl = "https://raw.githubusercontent.com/him312/TFS2-Cheat/main/"

print("[Test] Загрузка Config...")
local Config = loadstring(game:HttpGet(baseUrl .. "config.lua"))()

print("[Test] Загрузка Utils...")
local Utils = loadstring(game:HttpGet(baseUrl .. "utils.lua"))()

print("[Test] Загрузка UI...")
local UI = loadstring(game:HttpGet(baseUrl .. "ui.lua"))()

print("[Test] Ждём Zombies...")
local Zombies = Utils.getZombies()

print("[Test] Создаём UI...")
local UIObjects = UI.createWindow(Config, Utils)

print("[Test] UI создан! ScrollFrame:", UIObjects and UIObjects.ScrollFrame)
print("[Test] Готово. Ошибок быть не должно.")
