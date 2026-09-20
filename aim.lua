-- aim.lua
local Aim = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local isShooting = false
local scriptEnabled = true

function Aim.Init(Config, Utils, UI, UIObjects)
    local Zombies = Utils.getZombies()
    
    UI.createHeader(UIObjects.ScrollFrame, Utils, "Aim Assist")
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -10, 0, 22)
    StatusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    StatusLabel.BorderSizePixel = 0
    StatusLabel.Text = "Статус: ВКЛ"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.LayoutOrder = Utils.nextOrder()
    StatusLabel.Parent = UIObjects.ScrollFrame
    
    UI.createButton(UIObjects.ScrollFrame, Utils, "ВКЛ / ВЫКЛ (" .. Config.SETTINGS.ACTIVATE_KEY.Name .. ")", 25, Color3.fromRGB(0, 150, 80), function()
        scriptEnabled = not scriptEnabled
        Config.SETTINGS.AIM_ENABLED = scriptEnabled
    end)
    
    -- FOV
    local FovLabel = Instance.new("TextLabel")
    FovLabel.Size = UDim2.new(1, -10, 0, 18)
    FovLabel.BackgroundTransparency = 1
    FovLabel.Text = "FOV (радиус поиска):"
    FovLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    FovLabel.TextSize = 11
    FovLabel.Font = Enum.Font.Gotham
    FovLabel.TextXAlignment = Enum.TextXAlignment.Left
    FovLabel.LayoutOrder = Utils.nextOrder()
    FovLabel.Parent = UIObjects.ScrollFrame
    
    local FovTextBox = Instance.new("TextBox")
    FovTextBox.Size = UDim2.new(1, -10, 0, 25)
    FovTextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    FovTextBox.BorderSizePixel = 0
    FovTextBox.Text = tostring(Config.SETTINGS.FOV or 500)
    FovTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    FovTextBox.TextSize = 13
    FovTextBox.Font = Enum.Font.GothamBold
    FovTextBox.PlaceholderText = "Введи число"
    FovTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    FovTextBox.ClearTextOnFocus = false
    FovTextBox.LayoutOrder = Utils.nextOrder()
    FovTextBox.Parent = UIObjects.ScrollFrame
    
    -- Smoothness
    local SmoothLabel = Instance.new("TextLabel")
    SmoothLabel.Size = UDim2.new(1, -10, 0, 18)
    SmoothLabel.BackgroundTransparency = 1
    SmoothLabel.Text = "Плавность (0.0-1.0):"
    SmoothLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    SmoothLabel.TextSize = 11
    SmoothLabel.Font = Enum.Font.Gotham
    SmoothLabel.TextXAlignment = Enum.TextXAlignment.Left
    SmoothLabel.LayoutOrder = Utils.nextOrder()
    SmoothLabel.Parent = UIObjects.ScrollFrame
    
    local SmoothTextBox = Instance.new("TextBox")
    SmoothTextBox.Size = UDim2.new(1, -10, 0, 25)
    SmoothTextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    SmoothTextBox.BorderSizePixel = 0
    SmoothTextBox.Text = tostring(Config.SETTINGS.SMOOTHNESS)
    SmoothTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SmoothTextBox.TextSize = 13
    SmoothTextBox.Font = Enum.Font.GothamBold
    SmoothTextBox.PlaceholderText = "Введи число"
    SmoothTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    SmoothTextBox.ClearTextOnFocus = false
    SmoothTextBox.LayoutOrder = Utils.nextOrder()
    SmoothTextBox.Parent = UIObjects.ScrollFrame
    
    -- Y_Offset
    local YLabel = Instance.new("TextLabel")
    YLabel.Size = UDim2.new(1, -10, 0, 18)
    YLabel.BackgroundTransparency = 1
    YLabel.Text = "Y-смещение (пиксели):"
    YLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    YLabel.TextSize = 11
    YLabel.Font = Enum.Font.Gotham
    YLabel.TextXAlignment = Enum.TextXAlignment.Left
    YLabel.LayoutOrder = Utils.nextOrder()
    YLabel.Parent = UIObjects.ScrollFrame
    
    local YTextBox = Instance.new("TextBox")
    YTextBox.Size = UDim2.new(1, -10, 0, 25)
    YTextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    YTextBox.BorderSizePixel = 0
    YTextBox.Text = tostring(Config.SETTINGS.Y_OFFSET)
    YTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    YTextBox.TextSize = 13
    YTextBox.Font = Enum.Font.GothamBold
    YTextBox.PlaceholderText = "Введи число"
    YTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    YTextBox.ClearTextOnFocus = false
    YTextBox.LayoutOrder = Utils.nextOrder()
    YTextBox.Parent = UIObjects.ScrollFrame
    
    -- Max Distance
    local MaxLabel = Instance.new("TextLabel")
    MaxLabel.Size = UDim2.new(1, -10, 0, 18)
    MaxLabel.BackgroundTransparency = 1
    MaxLabel.Text = "Макс. дистанция (studs):"
    MaxLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    MaxLabel.TextSize = 11
    MaxLabel.Font = Enum.Font.Gotham
    MaxLabel.TextXAlignment = Enum.TextXAlignment.Left
    MaxLabel.LayoutOrder = Utils.nextOrder()
    MaxLabel.Parent = UIObjects.ScrollFrame
    
    local MaxTextBox = Instance.new("TextBox")
    MaxTextBox.Size = UDim2.new(1, -10, 0, 25)
    MaxTextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    MaxTextBox.BorderSizePixel = 0
    MaxTextBox.Text = tostring(Config.SETTINGS.MAX_DISTANCE)
    MaxTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    MaxTextBox.TextSize = 13
    MaxTextBox.Font = Enum.Font.GothamBold
    MaxTextBox.PlaceholderText = "Введи число"
    MaxTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    MaxTextBox.ClearTextOnFocus = false
    MaxTextBox.LayoutOrder = Utils.nextOrder()
    MaxTextBox.Parent = UIObjects.ScrollFrame
    
    -- Обработчики
    FovTextBox.FocusLost:Connect(function()
        local v = tonumber(FovTextBox.Text)
        if v then
            v = math.clamp(v, 50, 2000)
            Config.SETTINGS.FOV = v
            FovTextBox.Text = tostring(v)
        else
            FovTextBox.Text = tostring(Config.SETTINGS.FOV or 500)
        end
    end)
    
    SmoothTextBox.FocusLost:Connect(function()
        local v = tonumber(SmoothTextBox.Text)
        if v then
            v = math.clamp(v, 0.05, 1)
            Config.SETTINGS.SMOOTHNESS = v
            SmoothTextBox.Text = tostring(v)
        else
            SmoothTextBox.Text = tostring(Config.SETTINGS.SMOOTHNESS)
        end
    end)
    
    YTextBox.FocusLost:Connect(function()
        local v = tonumber(YTextBox.Text)
        if v then
            v = math.clamp(v, -200, 200)
            Config.SETTINGS.Y_OFFSET = v
            YTextBox.Text = tostring(v)
        else
            YTextBox.Text = tostring(Config.SETTINGS.Y_OFFSET)
        end
    end)
    
    MaxTextBox.FocusLost:Connect(function()
        local v = tonumber(MaxTextBox.Text)
        if v then
            v = math.clamp(v, 50, 5000)
            Config.SETTINGS.MAX_DISTANCE = v
            MaxTextBox.Text = tostring(v)
        else
            MaxTextBox.Text = tostring(Config.SETTINGS.MAX_DISTANCE)
        end
    end)
    
    task.spawn(function()
        while task.wait(0.1) do
            if StatusLabel and StatusLabel.Parent then
                if scriptEnabled then
                    StatusLabel.Text = "Статус: ВКЛ"
                    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                else
                    StatusLabel.Text = "Статус: ВЫКЛ"
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                end
            end
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Config.SETTINGS.ACTIVATE_KEY then
            scriptEnabled = not scriptEnabled
            Config.SETTINGS.AIM_ENABLED = scriptEnabled
        end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isShooting = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isShooting = false
        end
    end)
    
    local function getClosestZombie()
        local closest = nil
        local closestDist = math.huge
        local cameraPos = Camera.CFrame.Position
        
        for _, zombie in pairs(Zombies:GetChildren()) do
            if zombie:FindFirstChild("Zombie") and zombie.Zombie.Health ~= 0 then
                local head = zombie:FindFirstChild("Head")
                if head then
                    local distStuds = (head.Position - cameraPos).Magnitude
                    if distStuds > Config.SETTINGS.MAX_DISTANCE then continue end
                    if distStuds < closestDist then
                        closestDist = distStuds
                        closest = {zombie = zombie, head = head}
                    end
                end
            end
        end
        return closest
    end
    
    local function getScreenPosition(worldPos)
        local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)
        if onScreen and screenPos.Z > 0 then
            return Vector2.new(screenPos.X, screenPos.Y)
        end
        local cameraCFrame = Camera.CFrame
        local relativePos = cameraCFrame:PointToObjectSpace(worldPos)
        if relativePos.Z > 0 then relativePos = -relativePos end
        local focalLength = Camera.ViewportSize.Y / 2 / math.tan(math.rad(Camera.FieldOfView / 2))
        local screenX = (relativePos.X / -relativePos.Z) * focalLength + Camera.ViewportSize.X / 2
        local screenY = (-relativePos.Y / -relativePos.Z) * focalLength + Camera.ViewportSize.Y / 2
        return Vector2.new(screenX, screenY)
    end
    
    RunService.RenderStepped:Connect(function()
        if not scriptEnabled or not isShooting then return end
        local target = getClosestZombie()
        if not target then return end
        local screenPos = getScreenPosition(target.head.Position)
        if mousemoveabs then
            local targetX = screenPos.X
            local targetY = screenPos.Y + Config.SETTINGS.Y_OFFSET
            local currentX, currentY = Mouse.X, Mouse.Y
            local newX = currentX + (targetX - currentX) * Config.SETTINGS.SMOOTHNESS
            local newY = currentY + (targetY - currentY) * Config.SETTINGS.SMOOTHNESS
            mousemoveabs(newX, newY)
        end
    end)
    
    print("[Aim] Загружен")
end

return Aim
