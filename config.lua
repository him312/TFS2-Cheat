-- config.lua
local Config = {}

-- === ZOMBIE TYPES ===
Config.ALL_ZOMBIE_TYPES = {
    "Common", "Armour", "Heavy Armour",
    "Assassin", "Berserker", "Boomer", "Crawler", "Destroyer",
    "Drench Wraith", "Electric", "Flamer", "Frost Wraith",
    "Guardian", "Headless", "Hunter", "Long Arm", "Lurker",
    "Miner", "Annihilator", "Riot", "Slasher", "Sniper",
    "Spitter", "Sponger", "Swamp Giant", "Toxic", "Wraith",
    "Boss", "Radioactive", "Easter"
}

-- === НАСТРОЙКИ ===
Config.SETTINGS = {
    -- Aim Assist
    AIM_ENABLED = true,
    MAX_DISTANCE = 600,
    SMOOTHNESS = 0.5,
    Y_OFFSET = 58,
    ACTIVATE_KEY = Enum.KeyCode.RightAlt,
    
    -- Big Head
    BIGHEAD_ENABLED = false,
    HEAD_SCALE = 4.5,
    TRANSPARENCY = 0.8,
    
    -- Highlight
    HIGHLIGHT_ENABLED = false,
    HIGHLIGHT_TRANSPARENCY = 0.5,
    
    -- Типы (индивидуальные)
    TYPE_SETTINGS = {},
}

-- Инициализация типов
for _, zType in ipairs(Config.ALL_ZOMBIE_TYPES) do
    Config.SETTINGS.TYPE_SETTINGS[zType] = {
        enabled = false,
        color = Color3.fromRGB(255, 0, 0)
    }
end

return Config
