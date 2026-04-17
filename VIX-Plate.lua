local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local oldGui = game.CoreGui:FindFirstChild("VIX_Fort")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VIX_Fort"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
 
local MAIN_WIDTH = 250
local MAIN_HEIGHT = 55
local BTN_SIZE = 35
local SIDE_WIDTH = 34

local isHidden = false
local followPlatform = nil
local createdObjects = {}

-- --- Функции строительства ---

local function spawnPart(size, cframe)
    local p = Instance.new("Part")
    p.Size = size
    p.CFrame = cframe
    p.Anchored = true
    p.Material = Enum.Material.Neon
    p.Color = Color3.fromRGB(200, 0, 0)
    p.Transparency = 0.5
    p.Parent = workspace
    
    local stroke = Instance.new("SelectionBox")
    stroke.Adornee = p
    stroke.LineThickness = 0.05
    stroke.Color3 = Color3.new(1, 0, 0)
    stroke.Parent = p
    
    table.insert(createdObjects, p)
    return p
end

local function buildRampUp()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        spawnPart(Vector3.new(10, 1, 42), hrp.CFrame * CFrame.new(0, 10, -15) * CFrame.Angles(math.rad(45), 0, 0))
    end
end

local function buildRampDown()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        spawnPart(Vector3.new(10, 1, 42), hrp.CFrame * CFrame.new(0, -10, -15) * CFrame.Angles(math.rad(-45), 0, 0))
    end
end

local function buildStraight()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        spawnPart(Vector3.new(10, 1, 60), hrp.CFrame * CFrame.new(0, -3.5, -25))
    end
end

local function toggleFollow(btn)
    if followPlatform then
        followPlatform:Destroy()
        followPlatform = nil
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    else
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local initialY = hrp.Position.Y - 3.5
            followPlatform = Instance.new("Part")
            followPlatform.Size = Vector3.new(12, 1, 12)
            followPlatform.Anchored = true
            followPlatform.Transparency = 0.5
            followPlatform.Parent = workspace
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            
            task.spawn(function()
                while followPlatform do
                    if hrp.Parent then
                        followPlatform.CFrame = CFrame.new(hrp.Position.X, initialY, hrp.Position.Z)
                    end
                    task.wait()
                end
            end)
        end
    end
end

local function clearObjects()
    for _, v in pairs(createdObjects) do
        if v then v:Destroy() end
    end
    createdObjects = {}
end

-- --- Интерфейс ---

local function applyGlass(obj)
    obj.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    obj.BackgroundTransparency = 0.4
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    stroke.Parent = obj
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = obj
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, MAIN_WIDTH, 0, MAIN_HEIGHT)
MainFrame.AnchorPoint = Vector2.new(1, 0.5)
MainFrame.Position = UDim2.new(0.5, MAIN_WIDTH/2, 0.8, 0)
MainFrame.Parent = ScreenGui
applyGlass(MainFrame)

-- Контейнер для контента (слева)
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -SIDE_WIDTH, 1, 0)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Сетка для кнопок (сверху)
local ButtonsArea = Instance.new("Frame")
ButtonsArea.Size = UDim2.new(1, 0, 0, BTN_SIZE + 5)
ButtonsArea.Position = UDim2.new(0, 0, 0, 5)
ButtonsArea.BackgroundTransparency = 1
ButtonsArea.Parent = Content

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.Padding = UDim.new(0, 6)
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = ButtonsArea

-- Правая панель управления
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, SIDE_WIDTH, 1, 0)
SideBar.Position = UDim2.new(1, -SIDE_WIDTH, 0, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
SideBar.BackgroundTransparency = 0.6
SideBar.Parent = MainFrame
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 6)

local function createBtn(text, parent, size)
    local b = Instance.new("TextButton")
    b.Size = size or UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.new(1, 1, 1)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.Parent = parent
    applyGlass(b)
    return b
end

-- Текст VIX Fort
local BrandLabel = Instance.new("TextLabel")
BrandLabel.Text = "VIX Fort"
BrandLabel.Size = UDim2.new(1, 0, 0, 14)
BrandLabel.Position = UDim2.new(0, 0, 1, -30)
BrandLabel.BackgroundTransparency = 0.2
BrandLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
BrandLabel.Font = Enum.Font.GothamBold
BrandLabel.TextSize = 38
BrandLabel.Parent = Content

local CloseBtn = createBtn("X", SideBar, UDim2.new(0, 20, 0, 20))
CloseBtn.Position = UDim2.new(0.5, -10, 0.15, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

local HideBtn = createBtn(">", SideBar, UDim2.new(0, 20, 0, 20))
HideBtn.Position = UDim2.new(0.5, -10, 0.65, 0)

-- Функциональные кнопки
local B1 = createBtn("▲", ButtonsArea)
local B2 = createBtn("▼", ButtonsArea)
local B3 = createBtn("➡", ButtonsArea)
local B4 = createBtn("⚖", ButtonsArea)
local B5 = createBtn("🗑", ButtonsArea)

-- Ивенты
B1.MouseButton1Click:Connect(buildRampUp)
B2.MouseButton1Click:Connect(buildRampDown)
B3.MouseButton1Click:Connect(buildStraight)
B4.MouseButton1Click:Connect(function() toggleFollow(B4) end)
B5.MouseButton1Click:Connect(clearObjects)

HideBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    if isHidden then
        MainFrame:TweenSize(UDim2.new(0, SIDE_WIDTH, 0, MAIN_HEIGHT), "Out", "Quad", 0.3, true)
        Content.Visible = false
        HideBtn.Text = "<"
    else
        MainFrame:TweenSize(UDim2.new(0, MAIN_WIDTH, 0, MAIN_HEIGHT), "Out", "Quad", 0.3, true)
        task.delay(0.2, function() Content.Visible = true end)
        HideBtn.Text = ">"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    if followPlatform then followPlatform:Destroy() end
end)

-- Dragging
local dragging, dragStart, startPos
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