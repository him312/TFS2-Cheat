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
        typeName.Position = UDim2.new(0, 25, 0, 0)
        typeName.BackgroundTransparency = 1
        typeName.Text = zType
        typeName.TextColor3 = Color3.fromRGB(200, 200, 200)
        typeName.TextSize = 11
        typeName.Font = Enum.Font.Gotham
        typeName.TextXAlignment = Enum.TextXAlignment.Left
        typeName.Parent = container
        
        local colorButton = Instance.new("TextButton")
        colorButton.Size = UDim2.new(0, 25, 1, 0)
        colorButton.Position = UDim2.new(1, -27, 0, 0)
        colorButton.BackgroundColor3 = Config.SETTINGS.TYPE_SETTINGS[zType].color
        colorButton.BorderSizePixel = 0
        colorButton.Text = ""
        colorButton.Parent = container
        
        checkbox.MouseButton1Click:Connect(function()
            Config.SETTINGS.TYPE_SETTINGS[zType].enabled = not Config.SETTINGS.TYPE_SETTINGS[zType].enabled
            if Config.SETTINGS.TYPE_SETTINGS[zType].enabled then
                checkbox.Text = "☑"
                checkbox.TextColor3 = Color3.fromRGB(0, 255, 100)
            else
                checkbox.Text = "☐"
                checkbox.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
            updateAll()
        end)
        
        colorButton.MouseButton1Click:Connect(function()
            closeColorMenu()
            
            local rgbMenu = Instance.new("Frame")
            rgbMenu.Size = UDim2.new(0, 180, 0, 130)
            rgbMenu.Position = UDim2.new(0.5, -90, 0.5, -65)
            rgbMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            rgbMenu.BorderSizePixel = 0
            rgbMenu.ZIndex = 100
            rgbMenu.Parent = UIObjects.ScreenGui
            
            local rgbTitle = Instance.new("TextLabel")
            rgbTitle.Size = UDim2.new(1, 0, 0, 20)
            rgbTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            rgbTitle.BorderSizePixel = 0
            rgbTitle.Text = "RGB: " .. zType
            rgbTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            rgbTitle.TextSize = 11
            rgbTitle.Font = Enum.Font.GothamBold
            rgbTitle.ZIndex = 101
            rgbTitle.Parent = rgbMenu
            
            local function createRGBSlider(name, yPos, initialValue, callback)
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0, 20, 0, 25)
                label.Position = UDim2.new(0, 5, 0, yPos)
                label.BackgroundTransparency = 1
                label.Text = name
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = 12
                label.Font = Enum.Font.GothamBold
                label.ZIndex = 101
                label.Parent = rgbMenu
                
                local minus = Instance.new("TextButton")
                minus.Size = UDim2.new(0, 20, 0, 25)
                minus.Position = UDim2.new(0, 30, 0, yPos)
                minus.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                minus.BorderSizePixel = 0
                minus.Text = "−"
                minus.TextColor3 = Color3.fromRGB(255, 255, 255)
                minus.TextSize = 12
                minus.Font = Enum.Font.GothamBold
                minus.ZIndex = 101
                minus.Parent = rgbMenu
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0, 40, 0, 25)
                valueLabel.Position = UDim2.new(0, 55, 0, yPos)
                valueLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                valueLabel.BorderSizePixel = 0
                valueLabel.Text = tostring(initialValue)
                valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                valueLabel.TextSize = 12
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.ZIndex = 101
                valueLabel.Parent = rgbMenu
                
                local plus = Instance.new("TextButton")
                plus.Size = UDim2.new(0, 20, 0, 25)
                plus.Position = UDim2.new(0, 100, 0, yPos)
                plus.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                plus.BorderSizePixel = 0
                plus.Text = "+"
                plus.TextColor3 = Color3.fromRGB(255, 255, 255)
                plus.TextSize = 12
                plus.Font = Enum.Font.GothamBold
                plus.ZIndex = 101
                plus.Parent = rgbMenu
                
                local currentValue = initialValue
                
                minus.MouseButton1Click:Connect(function()
                    currentValue = math.max(0, currentValue - 5)
                    valueLabel.Text = tostring(currentValue)
                    callback(currentValue)
                end)
                
                plus.MouseButton1Click:Connect(function()
                    currentValue = math.min(255, currentValue + 5)
                    valueLabel.Text = tostring(currentValue)
                    callback(currentValue)
                end)
            end
            
            createRGBSlider("R", 25, math.floor(Config.SETTINGS.TYPE_SETTINGS[zType].color.R * 255), function(v)
                Config.SETTINGS.TYPE_SETTINGS[zType].color = Color3.fromRGB(v, math.floor(Config.SETTINGS.TYPE_SETTINGS[zType].color.G * 255), math.floor(Config.SETTINGS.TYPE_SETTINGS[zType].color.B * 255))
                colorButton.BackgroundColor3 = Config.SETTINGS.TYPE_SETTINGS[zType].color
                updateAll()
            end)
            
            createRGBSlider("G", 55, math.floor(Config.SETTINGS.TYPE_SETTINGS[zType].color.G * 255), function(v)
                Config.SETTINGS.TYPE_SETTINGS[zType].color = Color3.fromRGB(math.floor(Config.SETTINGS.TYPE_SETTINGS[zType].color.R * 255), v, math.floor(Config.SETTINGS.TYPE_SETTINGS[zType].color.B * 255))
                colorButton.BackgroundColor3 = Config.SETTINGS.TYPE_SETTINGS[zType].color
                updateAll()
            end)
            
            createRGBSlider("B", 85, math.floor(Config.SETTINGS.TYPE_SETTINGS[zType].color.B * 255), function(v)
                Config.SETTINGS.TYPE_SETTINGS[zType].color = Color3.fromRGB(math.floor(Config.SETTINGS.TYPE_SETTINGS[zType].color.R * 255), math.floor(Config.SETTINGS.TYPE_SETTINGS[zType].color.G * 255), v)
                colorButton.BackgroundColor3 = Config.SETTINGS.TYPE_SETTINGS[zType].color
                updateAll()
            end)
            
            local closeButton = Instance.new("TextButton")
            closeButton.Size = UDim2.new(1, -10, 0, 20)
            closeButton.Position = UDim2.new(0, 5, 0, 110)
            closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
            closeButton.BorderSizePixel = 0
            closeButton.Text = "Закрыть"
            closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            closeButton.TextSize = 11
            closeButton.Font = Enum.Font.GothamBold
            closeButton.ZIndex = 101
            closeButton.Parent = rgbMenu
            closeButton.MouseButton1Click:Connect(closeColorMenu)
            
            activeColorMenu = rgbMenu
        end)
    end
    
    Zombies.ChildAdded:Connect(function(zombie)
        task.wait(0.1)
        if Config.SETTINGS.HIGHLIGHT_ENABLED then applyHighlight(zombie) end
    end)
    
    Zombies.ChildRemoved:Connect(function(zombie)
        if highlights[zombie] then
            highlights[zombie]:Destroy()
            highlights[zombie] = nil
        end
    end)
    
    print("[Highlight] Загружен")
end

return Highlight
