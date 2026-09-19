-- main.lua
local baseUrl = "https://raw.githubusercontent.com/ТВОЙ_НИК/TFS2-Cheat/main/"

local Config = loadstring(game:HttpGet(baseUrl .. "config.lua"))()
local Utils = loadstring(game:HttpGet(baseUrl .. "utils.lua"))()
local UI = loadstring(game:HttpGet(baseUrl .. "ui.lua"))()
local Aim = loadstring(game:HttpGet(baseUrl .. "aim.lua"))()
local BigHead = loadstring(game:HttpGet(baseUrl .. "bighead.lua"))()
local Highlight = loadstring(game:HttpGet(baseUrl .. "highlight.lua"))()

-- Инициализация
UI:Init()
Aim:Init(Config, Utils)
BigHead:Init(Config, Utils)
Highlight:Init(Config, Utils)

print("[TFS2 Cheat] Все модули загружены")
