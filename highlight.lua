-- highlight.lua
local Highlight = {}

function Highlight.Init(Config, Utils, UI, UIObjects)
    local Zombies = Utils.getZombies()
    local highlights = {}
    local activeColorMenu = nil
    
    local function closeColorMenu()
        if activeColorMenu then
            activeColorMenu:Destroy()
            activeColorMenu = nil
        end
    end
    
    local function applyHighlight(zombie)
        if not Config.SETTINGS.HIGHLIGHT_ENABLED then
            if highlights[zombie] then
                highlights[zombie]:Destroy()
                highlights[zombie] = nil
            end
            return
        end
        
        local zType = Utils.getZombieType(zombie, Config.ALL_ZOMBIE_TYPES)
        local settings = Config.SETTINGS.TYPE_SETTINGS[zType]
        
        if not settings or not settings.enabled then
            if highlights[zombie] then
                highlights[zombie]:Destroy()
                highlights[zombie] = nil
            end
            return
        end
        
        if highlights[zombie] then
            highlights[zombie].FillColor = settings.color
            highlights[zombie].FillTransparency = Config.SETTINGS.HIGHLIGHT_TRANSPARENCY
            highlights[zombie].OutlineColor = settings.color
            return
        end
        
        local highlight = Instance.new("Highlight")
        highlight.Adornee = zombie
        highlight.FillColor = settings.color
        highlight.FillTransparency = Config.SETTINGS.HIGHLIGHT_TRANSPARENCY
        highlight.OutlineColor = settings.color
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = zombie
        
        highlights[zombie] = highlight
    end
    
    local function updateAll()
        for _, zombie in ipairs(Zombies:GetChildren()) do
            applyHighlight(zombie)
        end
    end
    
    UI.createHeader(UIObjects.ScrollFrame, Utils, "Highlight")
    
    local HighlightToggle = UI.createButton(UIObjects.ScrollFrame, Utils, "Highlight: ВЫКЛ", 25, Color3.fromRGB(180, 50, 50), function()
        Config.SETTINGS.HIGHLIGHT_ENABLED = not Config.SETTINGS.HIGHLIGHT_ENABLED
        if Config.SETTINGS.HIGHLIGHT_ENABLED then
            HighlightToggle.Text = "Highlight: ВКЛ"
            HighlightToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
        else
            HighlightToggle.Text = "Highlight: ВЫКЛ"
            HighlightToggle.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        end
        updateAll()
    end)
    
    -- Прозрачность
    local HTransLabel = Instance.new("TextLabel")
    HTransLabel.Size = UDim2.new(1, -10, 0, 18)
    HTransLabel.BackgroundTransparency = 1
    HTransLabel.Text = "Прозрачность подсветки: 0.5"
    HTransLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    HTransLabel.TextSize = 11
    HTransLabel.Font = Enum.Font.Gotham
    HTransLabel.TextXAlignment = Enum.TextXAlignment.Left
    HTransLabel.LayoutOrder = Utils.nextOrder()
    HTransLabel.Parent = UIObjects.ScrollFrame
    
    local HTransContainer = Instance.new("Frame")
    HTransContainer.Size = UDim2.new(1, -10, 0, 25)
    HTransContainer.BackgroundTransparency = 1
    HTransContainer.LayoutOrder = Utils.nextOrder()
    HTransContainer.Parent = UIObjects.ScrollFrame
    
    local HTransMinus = Instance.new("TextButton")
    HTransMinus.Size = UDim2.new(0, 30, 1, 0)
    HTransMinus.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    HTransMinus.BorderSizePixel = 0
    HTransMinus.Text = "−"
    HTransMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
    HTransMinus.TextSize = 16
    HTransMinus.Font = Enum.Font.GothamBold
    HTransMinus.Parent = HTransContainer
    
    local HTransValue = Instance.new("TextLabel")
    HTransValue.Size = UDim2.new(0, 100, 1, 0)
    HTransValue.Position = UDim2.new(0, 35, 0, 0)
    HTransValue.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    HTransValue.BorderSizePixel = 0
    HTransValue.Text = "0.5"
    HTransValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    HTransValue.TextSize = 13
    HTransValue.Font = Enum.Font.GothamBold
    HTransValue.Parent = HTransContainer
    
    local HTransPlus = Instance.new("TextButton")
    HTransPlus.Size = UDim2.new(0, 30, 1, 0)
    HTransPlus.Position = UDim2.new(0, 140, 0, 0)
    HTransPlus.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    HTransPlus.BorderSizePixel = 0
    HTransPlus.Text = "+"
    HTransPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
    HTransPlus.TextSize = 16
    HTransPlus.Font = Enum.Font.GothamBold
    HTransPlus.Parent = HTransContainer
    
    HTransMinus.MouseButton1Click:Connect(function()
        Config.SETTINGS.HIGHLIGHT_TRANSPARENCY = math.max(0, Config.SETTINGS.HIGHLIGHT_TRANSPARENCY - 0.1)
        HTransValue.Text = string.format("%.1f", Config.SETTINGS.HIGHLIGHT_TRANSPARENCY)
        HTransLabel.Text = "Прозрачность подсветки: " .. string.format("%.1f", Config.SETTINGS.HIGHLIGHT_TRANSPARENCY)
        updateAll()
    end)
    
    HTransPlus.MouseButton1Click:Connect(function()
        Config.SETTINGS.HIGHLIGHT_TRANSPARENCY = math.min(1, Config.SETTINGS.HIGHLIGHT_TRANSPARENCY + 0.1)
        HTransValue.Text = string.format("%.1f", Config.SETTINGS.HIGHLIGHT_TRANSPARENCY)
        HTransLabel.Text = "Прозрачность подсветки: " .. string.format("%.1f", Config.SETTINGS.HIGHLIGHT_TRANSPARENCY)
        updateAll()
    end)
    
    -- Типы с RGB
    UI.createHeader(UIObjects.ScrollFrame, Utils, "Типы и цвета (RGB)")
    
    for _, zType in ipairs(Config.ALL_ZOMBIE_TYPES) do
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -10, 0, 22)
        container.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        container.BorderSizePixel = 0
        container.LayoutOrder = Utils.nextOrder()
        container.Parent = UIObjects.ScrollFrame
        
        local checkbox = Instance.new("TextButton")
        checkbox.Size = UDim2.new(0, 20, 1, 0)
        checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        checkbox.BorderSizePixel = 0
        checkbox.Text = "☐"
        checkbox.TextColor3 = Color3.fromRGB(180, 180, 180)
        checkbox.TextSize = 14
        checkbox.Font = Enum.Font.Gotham
        checkbox.Parent = container
        
        local typeName = Instance.new("TextLabel")
        typeName.Size = UDim2.new(1, -60, 1, 0)
        typeName.Position = UDim2.new(0, 25, 0,
