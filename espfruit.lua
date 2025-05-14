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

-- 🧱 Hàm tạo ESP với khoảng cách
function CreateESP(target, labelBase, color)
    if target:FindFirstChild("ESP") then return end

    local esp = Instance.new("BillboardGui", target)
    esp.Name = "ESP"
    esp.Size = UDim2.new(0, 150, 0, 40)
    esp.AlwaysOnTop = true
    esp.StudsOffset = Vector3.new(0, 3, 0)

    local text = Instance.new("TextLabel", esp)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = color
    text.TextStrokeTransparency = 0.3
    text.Font = Enum.Font.SourceSansBold
    text.TextScaled = true
    text.Text = labelBase .. " - ???m"

    -- Cập nhật liên tục
    spawn(function()
        while esp and esp.Parent and target and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
            local localChar = game.Players.LocalPlayer.Character
            if localChar and localChar:FindFirstChild("HumanoidRootPart") and target:IsA("BasePart") then
                local dist = (localChar.HumanoidRootPart.Position - target.Position).Magnitude
                text.Text = labelBase .. string.format(" - %.0fm", dist)
            end
            wait(0.1)  -- Cập nhật nhanh hơn, mỗi 0.1 giây
        end
    end)
end

-- 🍇 ESP Trái Ác Quỷ
spawn(function()
    while wait(2) do
        if getgenv().espFruitEnabled then
            for _, obj in pairs(game:GetService("Workspace"):GetChildren()) do
                if obj:IsA("Tool") and obj:FindFirstChild("Handle") and not obj:FindFirstChild("ESP") then
                    CreateESP(obj.Handle, "🍇 Trái Ác Quỷ", Color3.fromRGB(255, 0, 0))
                end
            end
        end
    end
end)

-- 👤 ESP Người Chơi
spawn(function()
    while wait(2) do
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

-- 🎨 GUI Giao Diện có thể di chuyển
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ESP_GUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0, 10, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2

local UICorner = Instance.new("UICorner", frame)
UICorner.CornerRadius = UDim.new(0, 8)

local UIListLayout = Instance.new("UIListLayout", frame)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- 🟢 Tạo nút Toggle
local function createToggle(name, stateRef)
    local toggle = Instance.new("TextButton", frame)
    toggle.Size = UDim2.new(0, 180, 0, 40)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggle.BorderSizePixel = 0
    toggle.Font = Enum.Font.SourceSansBold
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.TextSize = 18
    toggle.Text = "🔘 " .. name .. ": OFF"

    local corner = Instance.new("UICorner", toggle)
    corner.CornerRadius = UDim.new(0, 6)

    toggle.MouseButton1Click:Connect(function()
        getgenv()[stateRef] = not getgenv()[stateRef]
        toggle.Text = (getgenv()[stateRef] and "✅ " or "🔘 ") .. name .. ": " .. (getgenv()[stateRef] and "ON" or "OFF")
    end)
end

-- 🧭 Các nút công tắc
createToggle("ESP Trái Ác Quỷ", "espFruitEnabled")
createToggle("ESP Người Chơi", "espPlayerEnabled")

-- 🖱️ Thêm tính năng di chuyển menu
local dragging, dragInput, dragStart, startPos
local function dragFrame(input)
    if dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragFrame(input)
    end
end)
