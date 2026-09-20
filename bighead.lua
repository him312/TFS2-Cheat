-- bighead.lua
local BigHead = {}

function BigHead.Init(Config, Utils, UI, UIObjects)
    local Zombies = Utils.getZombies()
    
    UI.createHeader(UIObjects.ScrollFrame, Utils, "Big Head")
    
    -- 1. StatusLabel
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
    
    -- 2. Кнопка вкл/выкл
    UI.createButton(UIObjects.ScrollFrame, Utils, "Big Head: ВКЛ/ВЫКЛ", 25, Color3.fromRGB(180, 50, 50), function()
        Config.SETTINGS.BIGHEAD_ENABLED = not Config.SETTINGS.BIGHEAD_ENABLED
        if Config.SETTINGS.BIGHEAD_ENABLED then
            BigHead.updateAll(Zombies, Config)
        else
            BigHead.resetAll(Zombies)
        end
        print("[BigHead] Статус:", Config.SETTINGS.BIGHEAD_ENABLED and "ВКЛ" or "ВЫКЛ")
    end)
    
    -- 3. Размер (TextBox)
    local SizeLabel = Instance.new("TextLabel")
    SizeLabel.Size = UDim2.new(1, -10, 0, 18)
    SizeLabel.BackgroundTransparency = 1
    SizeLabel.Text = "Размер головы (1-15):"
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
    
    local SizeTextBox = Instance.new("TextBox")
    SizeTextBox.Size = UDim2.new(1, 0, 1, 0)
    SizeTextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    SizeTextBox.BorderSizePixel = 0
    SizeTextBox.Text = tostring(Config.SETTINGS.HEAD_SCALE)
    SizeTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SizeTextBox.TextSize = 13
    SizeTextBox.Font = Enum.Font.GothamBold
    SizeTextBox.PlaceholderText = "Введи число (1-15)"
    SizeTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    SizeTextBox.ClearTextOnFocus = false
    SizeTextBox.Parent = SizeContainer
    
    -- 4. Прозрачность (TextBox)
    local TransLabel = Instance.new("TextLabel")
    TransLabel.Size = UDim2.new(1, -10, 0, 18)
    TransLabel.BackgroundTransparency = 1
    TransLabel.Text = "Прозрачность (0.0-1.0):"
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
    
    local TransTextBox = Instance.new("TextBox")
    TransTextBox.Size = UDim2.new(1, 0, 1, 0)
    TransTextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    TransTextBox.BorderSizePixel = 0
    TransTextBox.Text = string.format("%.1f", Config.SETTINGS.TRANSPARENCY)
    TransTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TransTextBox.TextSize = 13
    TransTextBox.Font = Enum.Font.GothamBold
    TransTextBox.PlaceholderText = "Введи число (0.0-1.0)"
    TransTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    TransTextBox.ClearTextOnFocus = false
    TransTextBox.Parent = TransContainer
    
    -- === ОБРАБОТЧИКИ ВВОДА ===
    
    -- Размер
    SizeTextBox.FocusLost:Connect(function(enterPressed)
        local value = tonumber(SizeTextBox.Text)
        if value then
            value = math.clamp(value, 1, 15)
            Config.SETTINGS.HEAD_SCALE = value
            SizeTextBox.Text = tostring(value)
            if Config.SETTINGS.BIGHEAD_ENABLED then BigHead.updateAll(Zombies, Config) end
            print("[BigHead] Размер:", value)
        else
            SizeTextBox.Text = tostring(Config.SETTINGS.HEAD_SCALE)
        end
    end)
    
    -- Прозрачность
    TransTextBox.FocusLost:Connect(function(enterPressed)
        local value = tonumber(TransTextBox.Text)
        if value then
            value = math.clamp(value, 0, 1)
            Config.SETTINGS.TRANSPARENCY = value
            TransTextBox.Text = string.format("%.1f", value)
            if Config.SETTINGS.BIGHEAD_ENABLED then BigHead.updateAll(Zombies, Config) end
            print("[BigHead] Прозрачность:", value)
        else
            TransTextBox.Text = string.format("%.1f", Config.SETTINGS.TRANSPARENCY)
        end
    end)
    
    -- Обновление UI через цикл
    task.spawn(function()
        while task.wait(0.1) do
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
