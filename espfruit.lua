-- 🛡 Anti-Ban Basic Bypass
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local namecall = mt.__namecall

    mt.__namecall = newcclosure(function(...)
        local args = {...}
        local method = getnamecallmethod()
        if method == "Kick" then
            return warn("[Antiban] Kick attempt blocked.")
        end
        return namecall(unpack(args))
    end)

    game:GetService("Players").LocalPlayer.Kick = function()
        warn("[Antiban] Kick attempt blocked.")
    end
end)

-- ✅ Cờ bật/tắt
getgenv().espFruitEnabled = false
getgenv().espPlayerEnabled = false

-- 🧱 Hàm tạo ESP Billboard
function CreateESP(target, labelText, color)
    if target:FindFirstChild("ESP") then return end

    local esp = Instance.new("BillboardGui", target)
    esp.Name = "ESP"
    esp.Size = UDim2.new(0, 100, 0, 40)
    esp.AlwaysOnTop = true
    esp.StudsOffset = Vector3.new(0, 3, 0)

    local text = Instance.new("TextLabel", esp)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = labelText
    text.TextColor3 = color
    text.TextStrokeTransparency = 0.5
    text.Font = Enum.Font.SourceSansBold
    text.TextScaled = true
end

-- 🍇 ESP Trái Ác Quỷ (loop theo toggle)
spawn(function()
    while wait(5) do
        if getgenv().espFruitEnabled then
            for _, obj in pairs(game:GetService("Workspace"):GetChildren()) do
                if obj:IsA("Tool") and obj:FindFirstChild("Handle") and not obj:FindFirstChild("ESP") then
                    CreateESP(obj, "🍇 Devil Fruit 🍇", Color3.fromRGB(255, 0, 0))
                end
            end
        end
    end
end)

-- 👤 ESP Người Chơi (loop theo toggle)
spawn(function()
    while wait(5) do
        if getgenv().espPlayerEnabled then
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    if not player.Character.Head:FindFirstChild("ESP") then
                        CreateESP(player.Character.Head, "👤 " .. player.Name, Color3.fromRGB(0, 255, 0))
                    end
                end
            end
        end
    end
end)

-- 🎮 Giao diện GUI đơn giản
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ESP_GUI"

-- Hàm tạo nút
local function createButton(text, position, callback)
    local button = Instance.new("TextButton", gui)
    button.Size = UDim2.new(0, 180, 0, 40)
    button.Position = position
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 20
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Nút toggle ESP trái
createButton("🍇 Toggle ESP Trái", UDim2.new(0, 10, 0, 200), function()
    getgenv().espFruitEnabled = not getgenv().espFruitEnabled
end)

-- Nút toggle ESP người
createButton("👤 Toggle ESP Người", UDim2.new(0, 10, 0, 250), function()
    getgenv().espPlayerEnabled = not getgenv().espPlayerEnabled
end)
