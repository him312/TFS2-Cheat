-- bighead.lua
local BigHead = {}

function BigHead.Init(Config, Utils, UI, UIObjects)
    local Zombies = Utils.getZombies()
    
    -- 1. Header
    UI.createHeader(UIObjects.ScrollFrame, Utils, "Big Head")
    
    -- 2. StatusLabel (ПЕРЕД кнопкой!)
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -10, 0, 22)
    StatusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    StatusLabel.BorderSizePixel = 0
    StatusLabel.Text = "Статус: ВЫКЛ"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.LayoutOrder = Utils.nextOrder()
    StatusLabel.Parent = UIObjects.ScrollFrame
    
    -- 3. Кнопка вкл/выкл
    UI.createButton(UIObjects.ScrollFrame, Utils, "Big Head: ВКЛ/ВЫКЛ", 25, Color3.fromRGB(180, 50, 50), function()
        Config.SETTINGS.BIGHEAD_ENABLED = not Config.SETTINGS.BIGHEAD_ENABLED
        if Config.SETTINGS.BIGHEAD_ENABLED then
            BigHead.updateAll(Zombies, Config)
        else
            BigHead.resetAll(Zombies)
        end
        print("[BigHead] Статус:", Config.SETTINGS.BIGHEAD_ENABLED and "ВКЛ" or "ВЫКЛ")
    end)
    
    -- 4. Размер
    local SizeLabel = Instance.new("TextLabel")
    SizeLabel.Size = UDim2.new(1, -10, 0, 18)
    SizeLabel.BackgroundTransparency = 1
    SizeLabel.Text = "Размер головы: " .. Config.SETTINGS.HEAD_SCALE
    SizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    SizeLabel.TextSize = 11
    SizeLabel.Font = Enum.Font.Gotham
    SizeLabel.TextXAlignment = Enum.TextXAlignment.Left
    SizeLabel.LayoutOrder = Utils.nextOrder()
    SizeLabel.Parent = UIObjects.ScrollFrame
    
    local SizeContainer = Instance.new("Frame")
    SizeContainer.Size = UDim2.new(1, -10, 0, 25)
    SizeContainer.BackgroundTransparency = 1
    SizeContainer.LayoutOrder = Utils.nextOrder()
    SizeContainer.Parent = UIObjects.ScrollFrame
    
    local SizeMinus = Instance.new("TextButton")
    SizeMinus.Size = UDim2.new(0, 30, 1, 0)
    SizeMinus.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    SizeMinus.BorderSizePixel = 0
    SizeMinus.Text = "−"
    SizeMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
    SizeMinus.TextSize = 16
    SizeMinus.Font = Enum.Font.GothamBold
    SizeMinus.Parent = SizeContainer
    
    local SizeValue = Instance.new("TextLabel")
    SizeValue.Size = UDim2.new(0, 100, 1, 0)
    SizeValue.Position = UDim2.new(0, 35, 0, 0)
    SizeValue.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    SizeValue.BorderSizePixel = 0
    SizeValue.Text = tostring(Config.SETTINGS.HEAD_SCALE)
    SizeValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    SizeValue.TextSize = 13
    SizeValue.Font = Enum.Font.GothamBold
    SizeValue.Parent = SizeContainer
    
    local SizePlus = Instance.new("TextButton")
    SizePlus.Size = UDim2.new(0, 30, 1, 0)
    SizePlus.Position = UDim2.new(0, 140, 0, 0)
    SizePlus.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    SizePlus.BorderSizePixel = 0
    SizePlus.Text = "+"
    SizePlus.TextColor3 = Color3.fromRGB(255, 255, 255)
    SizePlus.TextSize = 16
    SizePlus.Font = Enum.Font.GothamBold
    SizePlus.Parent = SizeContainer
    
    -- 5. Прозрачность
    local TransLabel = Instance.new("TextLabel")
    TransLabel.Size = UDim2.new(1, -10, 0, 18)
    TransLabel.BackgroundTransparency = 1
    TransLabel.Text = "Прозрачность: " .. string.format("%.1f", Config.SETTINGS.TRANSPARENCY)
    TransLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    TransLabel.TextSize = 11
    TransLabel.Font = Enum.Font.Gotham
    TransLabel.TextXAlignment = Enum.TextXAlignment.Left
    TransLabel.LayoutOrder = Utils.nextOrder()
    TransLabel.Parent = UIObjects.ScrollFrame
    
    local TransContainer = Instance.new("Frame")
    TransContainer.Size = UDim2.new(1, -10, 0, 25)
    TransContainer.BackgroundTransparency = 1
    TransContainer.LayoutOrder = Utils.nextOrder()
    TransContainer.Parent = UIObjects.ScrollFrame
    
    local TransMinus = Instance.new("TextButton")
    TransMinus.Size = UDim2.new(0, 30, 1, 0)
    TransMinus.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    TransMinus.BorderSizePixel = 0
    TransMinus.Text = "−"
    TransMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
    TransMinus.TextSize = 16
    TransMinus.Font = Enum.Font.GothamBold
    TransMinus.Parent = TransContainer
    
    local TransValue = Instance.new("TextLabel")
    TransValue.Size = UDim2.new(0, 100, 1, 0)
    TransValue.Position = UDim2.new(0, 35, 0, 0)
    TransValue.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    TransValue.BorderSizePixel = 0
    TransValue.Text = string.format("%.1f", Config.SETTINGS.TRANSPARENCY)
    TransValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    TransValue.TextSize = 13
    TransValue.Font = Enum.Font.GothamBold
    TransValue.Parent = TransContainer
    
    local TransPlus = Instance.new("TextButton")
    TransPlus.Size = UDim2.new(0, 30, 1, 0)
    TransPlus.Position = UDim2.new(0, 140, 0, 0)
    TransPlus.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    TransPlus.BorderSizePixel = 0
    TransPlus.Text = "+"
    TransPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
    TransPlus.TextSize = 16
    TransPlus.Font = Enum.Font.GothamBold
    TransPlus.Parent = TransContainer
    
    -- Обработчики размера
    SizeMinus.MouseButton1Click:Connect(function()
        Config.SETTINGS.HEAD_SCALE = math.max(1, Config.SETTINGS.HEAD_SCALE - 0.5)
        if Config.SETTINGS.BIGHEAD_ENABLED then BigHead.updateAll(Zombies, Config) end
    end)
    
    SizePlus.MouseButton1Click:Connect(function()
        Config.SETTINGS.HEAD_SCALE = math.min(15, Config.SETTINGS.HEAD_SCALE + 0.5)
        if Config.SETTINGS.BIGHEAD_ENABLED then BigHead.updateAll(Zombies, Config) end
    end)
    
    -- Обработчики прозрачности
    TransMinus.MouseButton1Click:Connect(function()
        Config.SETTINGS.TRANSPARENCY = math.max(0, Config.SETTINGS.TRANSPARENCY - 0.1)
        if Config.SETTINGS.BIGHEAD_ENABLED then BigHead.updateAll(Zombies, Config) end
    end)
    
    TransPlus.MouseButton1Click:Connect(function()
        Config.SETTINGS.TRANSPARENCY = math.min(1, Config.SETTINGS.TRANSPARENCY + 0.1)
        if Config.SETTINGS.BIGHEAD_ENABLED then BigHead.updateAll(Zombies, Config) end
    end)
    
    -- Обновление UI через цикл
    task.spawn(function()
        while task.wait(0.1) do
            if SizeValue and SizeValue.Parent then
                SizeValue.Text = tostring(Config.SETTINGS.HEAD_SCALE)
                SizeLabel.Text = "Размер головы: " .. Config.SETTINGS.HEAD_SCALE
            end
            if TransValue and TransValue.Parent then
                TransValue.Text = string.format("%.1f", Config.SETTINGS.TRANSPARENCY)
                TransLabel.Text = "Прозрачность: " .. string.format("%.1f", Config.SETTINGS.TRANSPARENCY)
            end
            if StatusLabel and StatusLabel.Parent then
                if Config.SETTINGS.BIGHEAD_ENABLED then
                    StatusLabel.Text = "Статус: ВКЛ"
                    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                else
                    StatusLabel.Text = "Статус: ВЫКЛ"
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                end
            end
        end
    end)
    
    Zombies.ChildAdded:Connect(function(zombie)
        task.wait(0.1)
        if Config.SETTINGS.BIGHEAD_ENABLED then BigHead.apply(zombie, Config) end
    end)
    
    print("[BigHead] Загружен")
end

function BigHead.apply(zombie, Config)
    local head = zombie:FindFirstChild("Head")
    if not head then return end
    head.Size = Vector3.new(Config.SETTINGS.HEAD_SCALE, Config.SETTINGS.HEAD_SCALE, Config.SETTINGS.HEAD_SCALE)
    head.Transparency = Config.SETTINGS.TRANSPARENCY
    head.CanCollide = false
end

function BigHead.updateAll(Zombies, Config)
    for _, zombie in ipairs(Zombies:GetChildren()) do
        BigHead.apply(zombie, Config)
    end
end

function BigHead.resetAll(Zombies)
    for _, zombie in ipairs(Zombies:GetChildren()) do
        local head = zombie:FindFirstChild("Head")
        if head then
            head.Size = Vector3.new(1, 1, 1)
            head.Transparency = 0
        end
    end
end

return BigHead
