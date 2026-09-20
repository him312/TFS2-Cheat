-- main.lua — ТЕСТ + BigHead с pcall
local baseUrl = "https://raw.githubusercontent.com/him312/TFS2-Cheat/main/"

local Config = loadstring(game:HttpGet(baseUrl .. "config.lua"))()
local Utils = loadstring(game:HttpGet(baseUrl .. "utils.lua"))()
local UI = loadstring(game:HttpGet(baseUrl .. "ui.lua"))()
local BigHead = loadstring(game:HttpGet(baseUrl .. "bighead.lua"))()

local Zombies = Utils.getZombies()
local UIObjects = UI.createWindow(Config, Utils)

print("[Test] BigHead Init...")
local success, err = pcall(function()
    BigHead.Init(Config, Utils, UI, UIObjects)
end)
print("[Test] BigHead:", success, err)

task.wait(0.5)
local children = UIObjects.ScrollFrame:GetChildren()
print("[Test] Элементов в ScrollFrame:", #children)
for i, child in ipairs(children) do
    print("  " .. i .. ". " .. child.ClassName .. " | " .. child.Name)
end
