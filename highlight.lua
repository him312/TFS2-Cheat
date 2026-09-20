-- Замени createRGBSlider на:
local function createRGBTextBox(name, yPos, initialValue, callback)
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
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 130, 0, 25)
    textBox.Position = UDim2.new(0, 30, 0, yPos)
    textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    textBox.BorderSizePixel = 0
    textBox.Text = tostring(initialValue)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextSize = 12
    textBox.Font = Enum.Font.GothamBold
    textBox.PlaceholderText = "0-255"
    textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    textBox.ClearTextOnFocus = false
    textBox.ZIndex = 101
    textBox.Parent = rgbMenu
    
    textBox.FocusLost:Connect(function()
        local v = tonumber(textBox.Text)
        if v then
            v = math.clamp(math.floor(v), 0, 255)
            textBox.Text = tostring(v)
            callback(v)
        else
            textBox.Text = tostring(initialValue)
        end
    end)
end

-- И в цикле заменяем:
createRGBSlider("R", 25, math.floor(Config.SETTINGS.TYPE_SETTINGS[zType].color.R * 255), function(v)
    ...
end)
-- на:
createRGBTextBox("R", 25, math.floor(Config.SETTINGS.TYPE_SETTINGS[zType].color.R * 255), function(v)
    Config.SETTINGS.TYPE_SETTINGS[zType].color = Color3.fromRGB(v, math.floor(Config.SETTINGS.TYPE_SETTINGS[zType].color.G * 255), math.floor(Config.SETTINGS.TYPE_SETTINGS[zType].color.B * 255))
    colorButton.BackgroundColor3 = Config.SETTINGS.TYPE_SETTINGS[zType].color
    updateAll()
end)
