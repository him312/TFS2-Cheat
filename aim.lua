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
    
    -- Функция обновления UI
    local function updateUI()
        if not StatusLabel or not StatusLabel.Parent then return end
        if scriptEnabled then
            StatusLabel.Text = "Статус: ВКЛ"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        else
            StatusLabel.Text = "Статус: ВЫКЛ"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
    end
    
    local ToggleButton = UI.createButton(UIObjects.ScrollFrame, Utils, "ВЫКЛ", 25, Color3.fromRGB(0, 150, 80), function()
        scriptEnabled = not scriptEnabled
        updateUI()
        if ToggleButton then
            if scriptEnabled then
                ToggleButton.Text = "ВЫКЛ"
                ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
            else
                ToggleButton.Text = "ВКЛ"
                ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
            end
        end
    end)
    
    -- Активация
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Config.SETTINGS.ACTIVATE_KEY then
    scriptEnabled = not scriptEnabled
    updateUI()
    pcall(function()
        if ToggleButton then
            if scriptEnabled then
                ToggleButton.Text = "ВЫКЛ"
                ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
            else
                ToggleButton.Text = "ВКЛ"
                ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
            end
        end
    end)
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
    
    -- Логика
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
