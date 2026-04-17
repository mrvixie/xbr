local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Удаление старой версии, если есть
local oldGui = game.CoreGui:FindFirstChild("VIX_Plate_Pro")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VIX_Plate_Pro"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Переменные состояния
local isHidden = false
local followPlatform = nil
local mcBuildEnabled = false
local lastPlatform = nil
local createdObjects = {}

-- Вспомогательные функции
local function applyGlass(obj)
    obj.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    obj.BackgroundTransparency = 0.4
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    stroke.Thickness = 1
    stroke.Parent = obj
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = obj
end

local function createSquareButton(name, text, parent)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Text = text
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent
    applyGlass(btn)
    
    local aspect = Instance.new("UIAspectRatioConstraint")
    aspect.AspectRatio = 1
    aspect.Parent = btn
    
    return btn
end

-- Основной фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 70)
MainFrame.Position = UDim2.new(0.5, -200, 0.8, 0)
MainFrame.Parent = ScreenGui
applyGlass(MainFrame)

-- Контейнер для кнопок (Слева)
local ButtonGrid = Instance.new("Frame")
ButtonGrid.Size = UDim2.new(1, -60, 1, 0)
ButtonGrid.BackgroundTransparency = 1
ButtonGrid.Parent = MainFrame

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.Padding = UDim.new(0, 10)
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = ButtonGrid

-- Правая панель (Хэадер/Управление)
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 50, 1, 0)
SideBar.Position = UDim2.new(1, -50, 0, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
SideBar.BackgroundTransparency = 0.7
SideBar.Parent = MainFrame
local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 8)
sideCorner.Parent = SideBar

-- Делаем SideBar перетаскиваемым (для телефонов)
local dragging, dragInput, dragStart, startPos
SideBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Кнопки управления справа
local CloseBtn = createSquareButton("Close", "X", SideBar)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(0.5, -12, 0.1, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

local HideBtn = createSquareButton("Hide", "<", SideBar)
HideBtn.Size = UDim2.new(0, 25, 0, 25)
HideBtn.Position = UDim2.new(0.5, -12, 0.6, 0)

-- Функциональные кнопки
local RampUp = createSquareButton("RampUp", "▲", ButtonGrid)
local RampDown = createSquareButton("RampDown", "▼", ButtonGrid)
local Straight = createSquareButton("Straight", "➡", ButtonGrid)
local Follow = createSquareButton("Follow", "⚖", ButtonGrid)
local Clear = createSquareButton("Clear", "🗑", ButtonGrid)

-- Логика строительства
local function addPart(size, cframe, color)
    local p = Instance.new("Part")
    p.Size = size
    p.CFrame = cframe
    p.Anchored = true
    p.Material = Enum.Material.Neon
    p.Color = color or Color3.fromRGB(200, 0, 0)
    p.Transparency = 0.5
    p.Parent = workspace
    
    local stroke = Instance.new("SelectionBox")
    stroke.Adornee = p
    stroke.LineThickness = 0.05
    stroke.Color3 = Color3.new(1,0,0)
    stroke.Parent = p
    
    table.insert(createdObjects, p)
    return p
end

RampUp.MouseButton1Click:Connect(function()
    local hrp = player.Character.HumanoidRootPart
    local cf = hrp.CFrame * CFrame.new(0, 10, -15) * CFrame.Angles(math.rad(45), 0, 0)
    addPart(Vector3.new(10, 1, 42), cf)
end)

RampDown.MouseButton1Click:Connect(function()
    local hrp = player.Character.HumanoidRootPart
    local cf = hrp.CFrame * CFrame.new(0, -10, -15) * CFrame.Angles(math.rad(-45), 0, 0)
    addPart(Vector3.new(10, 1, 42), cf)
end)

Straight.MouseButton1Click:Connect(function()
    local hrp = player.Character.HumanoidRootPart
    local cf = hrp.CFrame * CFrame.new(0, -3.5, -25)
    addPart(Vector3.new(10, 1, 60), cf)
end)

Follow.MouseButton1Click:Connect(function()
    if followPlatform then
        followPlatform:Destroy()
        followPlatform = nil
        Follow.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    else
        local hrp = player.Character:WaitForChild("HumanoidRootPart")
        local initialY = hrp.Position.Y - 3.5
        followPlatform = Instance.new("Part")
        followPlatform.Size = Vector3.new(12, 1, 12)
        followPlatform.Anchored = true
        followPlatform.Material = Enum.Material.Glass
        followPlatform.Color = Color3.new(1, 1, 1)
        followPlatform.Transparency = 0.5
        followPlatform.Parent = workspace
        Follow.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        task.spawn(function()
            while followPlatform do
                local pos = hrp.Position
                followPlatform.CFrame = CFrame.new(pos.X, initialY, pos.Z)
                task.wait()
            end
        end)
    end
end)

Clear.MouseButton1Click:Connect(function()
    for _, v in pairs(createdObjects) do v:Destroy() end
    createdObjects = {}
end)

-- Скрытие меню
HideBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    if isHidden then
        MainFrame:TweenSize(UDim2.new(0, 60, 0, 70), "Out", "Quad", 0.3, true)
        ButtonGrid.Visible = false
        HideBtn.Text = ">"
    else
        MainFrame:TweenSize(UDim2.new(0, 400, 0, 70), "Out", "Quad", 0.3, true)
        task.delay(0.2, function() ButtonGrid.Visible = true end)
        HideBtn.Text = "<"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    if followPlatform then followPlatform:Destroy() end
end)
