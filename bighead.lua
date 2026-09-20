-- bighead.lua
local BigHead = {}

function BigHead.Init(Config, Utils, UI, UIObjects)
    local Zombies = Utils.getZombies()
    
    UI.createHeader(UIObjects.ScrollFrame, Utils, "Big Head")
    
    -- StatusLabel (работает)
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
    
    -- Кнопка через _G (чтобы callback видел)
    _G.TFS2_BigHeadToggle = UI.createButton(UIObjects.ScrollFrame, Utils, "ВКЛ / ВЫКЛ", 25, Color3.fromRGB(180, 50, 50), function()
        Config.SETTINGS.BIGHEAD_ENABLED = not Config.SETTINGS.BIGHEAD_ENABLED
        
        if Config.SETTINGS.BIGHEAD_ENABLED then
            StatusLabel.Text = "Статус: ВКЛ"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            _G.TFS2_BigHeadToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
            BigHead.updateAll(Zombies, Config)
        else
            StatusLabel.Text = "Статус: ВЫКЛ"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            _G.TFS2_BigHeadToggle.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
            BigHead.resetAll(Zombies)
        end
    end)
    
    -- Размер
    local SizeLabel = Instance.new("TextLabel")
    SizeLabel.Size = UDim2.new(1, -10, 0, 18)
    SizeLabel.BackgroundTransparency = 1
    SizeLabel.Text = "Размер головы: 4.5"
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
    SizeValue.Text = "4.5"
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
    
    SizeMinus.MouseButton1Click:Connect(function()
        Config.SETTINGS.HEAD_SCALE = math.max(1, Config.SETTINGS.HEAD_SCALE - 0.5)
        SizeValue.Text = tostring(Config.SETTINGS.HEAD_SCALE)
        SizeLabel.Text = "Размер головы: " .. Config.SETTINGS.HEAD_SCALE
        if Config.SETTINGS.BIGHEAD_ENABLED then BigHead.updateAll(Zombies, Config) end
    end)
    
    SizePlus.MouseButton1Click:Connect(function()
        Config.SETTINGS.HEAD_SCALE = math.min(15, Config.SETTINGS.HEAD_SCALE + 0.5)
        SizeValue.Text = tostring(Config.SETTINGS.HEAD_SCALE)
        SizeLabel.Text = "Размер головы: " .. Config.SETTINGS.HEAD_SCALE
        if Config.SETTINGS.BIGHEAD_ENABLED then BigHead.updateAll(Zombies, Config) end
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
