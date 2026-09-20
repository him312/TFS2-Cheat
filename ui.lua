-- ui.lua
local UI = {}

local CoreGui = game:GetService("CoreGui")

local layoutCounter = 0
local function nextOrder()
    layoutCounter = layoutCounter + 1
    return layoutCounter
end

function UI.createWindow(Config, Utils)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TFS2CheatMenu"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Защита: если CoreGui недоступен, используем PlayerGui
    local success, err = pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    
    if not success then
        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 600)
    MainFrame.Position = UDim2.new(0, 20, 0, 50)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -30, 0, 25)
    Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Title.BorderSizePixel = 0
    Title.Text = "TFS2 Cheat Menu"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 13
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    MinimizeButton.Position = UDim2.new(1, -25, 0, 0)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 16
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = MainFrame
    
    local MiniFrame = Instance.new("TextButton")
    MiniFrame.Size = UDim2.new(0, 45, 0, 45)
    MiniFrame.Position = UDim2.new(0, 20, 0, 50)
    MiniFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    MiniFrame.BorderSizePixel = 0
    MiniFrame.Text = "🎯"
    MiniFrame.TextSize = 22
    MiniFrame.Font = Enum.Font.GothamBold
    MiniFrame.Visible = false
    MiniFrame.Active = true
    MiniFrame.Draggable = true
    MiniFrame.Parent = ScreenGui
    
    local MiniCorner = Instance.new("UICorner")
    MiniCorner.CornerRadius = UDim.new(0, 8)
    MiniCorner.Parent = MiniFrame
    
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, -10, 1, -30)
    ScrollFrame.Position = UDim2.new(0, 5, 0, 27)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 2000)
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
    ScrollFrame.Parent = MainFrame
    
    local UIList = Instance.new("UIListLayout")
    UIList.Padding = UDim.new(0, 4)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Parent = ScrollFrame
    
    MinimizeButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        MiniFrame.Visible = true
        MiniFrame.Position = MainFrame.Position
    end)
    
    MiniFrame.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        MiniFrame.Visible = false
        MainFrame.Position = MiniFrame.Position
    end)
    
    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        ScrollFrame = ScrollFrame,
        MiniFrame = MiniFrame,
    }
end

function UI.createHeader(ScrollFrame, Utils, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = "─── " .. text .. " ───"
    label.TextColor3 = Color3.fromRGB(150, 150, 200)
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.LayoutOrder = nextOrder()
    label.Parent = ScrollFrame
    return label
end

function UI.createButton(ScrollFrame, Utils, text, height, color, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, height or 25)
    button.BackgroundColor3 = color or Color3.fromRGB(50, 50, 60)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.Gotham
    button.LayoutOrder = nextOrder()
    button.Parent = ScrollFrame
    button.MouseButton1Click:Connect(callback)
    return button
end

return UI
