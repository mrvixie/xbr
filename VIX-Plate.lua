local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ButtonsFrame = Instance.new("Frame")
local StairsFrame = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local HideButton = Instance.new("TextButton")
local Title = Instance.new("TextLabel")

-- Функция для удобного создания экземпляров
local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

-- Glass look функция
local function ApplyGlassEffect(frame)
    frame.BackgroundTransparency = 0.5
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = frame
    
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Thickness = 1
    uiStroke.Color = Color3.fromRGB(200, 200, 200)
    uiStroke.Parent = frame
    
    return frame
end

-- Создание кнопки
local function CreateButton(parent, name, text, position, size)
    local button = CreateInstance("TextButton", {
        Parent = parent,
        Name = name,
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        BorderSizePixel = 0,
        Position = position,
        Size = size,
        Font = Enum.Font.SourceSans,
        Text = text,
        TextColor3 = Color3.White,
        TextSize = 16,
    })
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    
    button.MouseButton1Click:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        wait(0.1)
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
    
    return button
end

-- Основное окно
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "VIX_Plate"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Главный фрейм с стеклянным эффектом
MainFrame = ApplyGlassEffect(CreateInstance("Frame", {
    Parent = ScreenGui,
    Position = UDim2.new(0.02, 0, 0.15, 0),
    Size = UDim2.new(0, 300, 0, 450),
    Draggable = true,
    Active = true,
    Selectable = true,
}))

-- Верхняя панель с заголовком и кнопками
local topBar = CreateInstance("Frame", {
    Parent = MainFrame,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(1, 0, 0, 35),
})

-- Заголовок
Title = CreateInstance("TextLabel", {
    Parent = topBar,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 0),
    Size = UDim2.new(0.6, -10, 1, 0),
    Text = "VIX Plate",
    TextColor3 = Color3.fromRGB(200, 200, 200),
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.SourceSansBold,
    TextSize = 18,
})

-- Кнопка скрытия
HideButton = CreateButton(topBar, "Hide", "_", UDim2.new(0.75, 5, 0.1, 0), UDim2.new(0.1, 0, 0.8, 0))
HideButton.TextColor3 = Color3.fromRGB(200, 200, 100)

-- Кнопка закрытия
CloseButton = CreateButton(topBar, "Close", "X", UDim2.new(0.85, 5, 0.1, 0), UDim2.new(0.1, 0, 0.8, 0))
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)

-- Фрейм для основных кнопок
ButtonsFrame = ApplyGlassEffect(CreateInstance("Frame", {
    Parent = MainFrame,
    Position = UDim2.new(0, 5, 0, 40),
    Size = UDim2.new(1, -10, 0.6, -50),
    BackgroundTransparency = 0.3,
}))

-- Фрейм для кнопок лестниц
StairsFrame = ApplyGlassEffect(CreateInstance("Frame", {
    Parent = MainFrame,
    Position = UDim2.new(0, 5, 0.6, 45),
    Size = UDim2.new(1, -10, 0.35, -50),
    BackgroundTransparency = 0.3,
    Visible = true,
}))

-- Создание кнопок
local platformButton = CreateButton(ButtonsFrame, "Platform", "Платформа", UDim2.new(0.02, 0, 0.05, 0), UDim2.new(0.46, 0, 0.45, 0))
local bigPlatformButton = CreateButton(ButtonsFrame, "BigPlatform", "Большая платформа", UDim2.new(0.52, 0, 0.05, 0), UDim2.new(0.46, 0, 0.45, 0))
local clearButton = CreateButton(ButtonsFrame, "Clear", "Очистить", UDim2.new(0.02, 0, 0.55, 0), UDim2.new(0.96, 0, 0.4, 0))

local upButton = CreateButton(StairsFrame, "Up", "Вверх ↗", UDim2.new(0.02, 0, 0.05, 0), UDim2.new(0.46, 0, 0.45, 0))
local downButton = CreateButton(StairsFrame, "Down", "Вниз ↘", UDim2.new(0.52, 0, 0.05, 0), UDim2.new(0.46, 0, 0.45, 0))
local forwardButton = CreateButton(StairsFrame, "Forward", "Прямо ➜", UDim2.new(0.27, 0, 0.55, 0), UDim2.new(0.46, 0, 0.4, 0))

-- Переменные состояния
local createdParts = {}
local platform = nil
local minecraftMode = false
local function toggleMinecraftMode()
    minecraftMode = not minecraftMode
    if minecraftMode then
        platformButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    else
        platformButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        if platform then
            platform:Destroy()
            platform = nil
        end
    end
end

local function clearAll()
    for _, part in ipairs(createdParts) do
        if part then
            part:Destroy()
        end
    end
    createdParts = {}
end

local function createInclinedPath(direction, length, angle)
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local startCF = character.HumanoidRootPart.CFrame
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = true
    part.Transparency = 0.7
    part.Material = Enum.Material.Neon
    part.BrickColor = BrickColor.new("Bright blue")
    
    local x, y, z = direction:components()
    local sizeX = math.abs(x * length) + 5
    local sizeY = 1
    local sizeZ = math.abs(z * length) + 5
    part.Size = Vector3.new(sizeX, sizeY, sizeZ)
    
    local height = y * length * math.sin(math.rad(45))
    local offset = direction * length / 2
    
    part.CFrame = CFrame.new(startCF.Position + offset + Vector3.new(0, -2.5, 0) + Vector3.new(0, height/2, 0)) * 
        CFrame.Angles(0, startCF:ToEulerAnglesXYZ().Y, 0) * 
        CFrame.Angles(math.rad(angle), 0, 0) * 
        CFrame.new(0, 0, 0)
        
    part.Parent = workspace
    table.insert(createdParts, part)
    
    local selectionBox = Instance.new("SelectionBox", part)
    selectionBox.Adornee = part
    selectionBox.Color3 = Color3.fromRGB(0, 255, 255)
    selectionBox.LineThickness = 0.05
end

local function createPlatform(size)
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local part = Instance.new("Part")
    part.Size = Vector3.new(size, 1, size)
    part.Position = (character.HumanoidRootPart.Position + Vector3.new(0, -3, 0))
    part.Anchored = true
    part.CanCollide = true
    part.Transparency = 0.8
    part.BrickColor = BrickColor.new("Bright green")
    part.Material = Enum.Material.Neon
    part.Parent = workspace
    table.insert(createdParts, part)
end

-- Функция для создания/удаления платформы
local function togglePlatform()
    if platform then
        platform:Destroy()
        platform = nil
    else
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            platform = Instance.new("Part")
            platform.Size = Vector3.new(15, 1, 15)
            platform.Position = Player.Character.HumanoidRootPart.Position - Vector3.new(0, 3.5, 0)
            platform.Anchored = true
            platform.CanCollide = true
            platform.Transparency = 0.7
            platform.BrickColor = BrickColor.new("Bright red")
            platform.Material = Enum.Material.Neon
            platform.Parent = workspace
            
            local selectionBox = Instance.new("SelectionBox", platform)
            selectionBox.Adornee = platform
            selectionBox.Color3 = Color3.fromRGB(255, 0, 0)
            selectionBox.LineThickness = 0.05
            
            -- Автообновление позиции платформы
            game:GetService("RunService").Heartbeat:Connect(function()
                if platform and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    local charPos = Player.Character.HumanoidRootPart.Position
                    platform.CFrame = CFrame.new(charPos.x, platform.Position.y, charPos.z)
                end
            end)
        end
    end
end

-- Minecraft-режим
local lastPlatform = nil
local function tryBuildPlatform()
    if minecraftMode and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local character = Player.Character
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character.HumanoidRootPart
        
        if not humanoid then return end
        
        -- Получаем направление взгляда игрока
        local lookDirection = rootPart.CFrame.LookVector
        local targetPosition = rootPart.Position + (lookDirection * 6)
        
        -- Проверяем падение игрока
        local isJumping = humanoid:GetState() == Enum.HumanoidStateType.Jumping
        local heightModifier = isJumping and 4 or 0
        
        -- Ищем существующую платформу под игроком
        local ray = Ray.new(character.HumanoidRootPart.Position, Vector3.new(0, -10, 0))
        local hit, position = workspace:FindPartOnRay(ray, character)
        
        local buildPosition
        if hit then
            -- Если под игроком есть платформа, строим на той же высоте
            local currentHeight
            if lastPlatform then
                currentHeight = lastPlatform.Position.Y
            else
                currentHeight = math.floor(position.Y)
            end
            
            buildPosition = Vector3.new(
                math.floor(targetPosition.X / 4 + 0.5) * 4,
                currentHeight + (isJumping and 4 or 0),
                math.floor(targetPosition.Z / 4 + 0.5) * 4
            )
        else
            -- Если нет платформы под ногами, просто строится на текущей высоте
            buildPosition = Vector3.new(
                math.floor(targetPosition.X / 4 + 0.5) * 4,
                math.floor((rootPart.Position.Y - 3) / 4 + 0.5) * 4,
                math.floor(targetPosition.Z / 4 + 0.5) * 4
            )
        end
        
        -- Создаем платформу
        local newPlatform = Instance.new("Part")
        newPlatform.Size = Vector3.new(4, 4, 4)
        newPlatform.Position = buildPosition
        newPlatform.Anchored = true
        newPlatform.CanCollide = true
        newPlatform.Transparency = 0.7
        newPlatform.BrickColor = isJumping and BrickColor.new("Bright blue") or BrickColor.new("Bright green")
        newPlatform.Material = Enum.Material.Neon
        newPlatform.Parent = workspace
        
        lastPlatform = newPlatform
        table.insert(createdParts, newPlatform)
        
        -- Добавляем подсветку краев
        local selectionBox = Instance.new("SelectionBox", newPlatform)
        selectionBox.Adornee = newPlatform
        selectionBox.Color3 = isJumping and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(0, 255, 0)
        selectionBox.LineThickness = 0.05
    end
end

-- Обработчики кнопок
HideButton.MouseButton1Click:Connect(function()
    ButtonsFrame.Visible = not ButtonsFrame.Visible
    StairsFrame.Visible = not StairsFrame.Visible
    
    if ButtonsFrame.Visible then
        MainFrame.Size = UDim2.new(0, 300, 0, 450)
    else
        MainFrame.Size = UDim2.new(0, 50, 0, 35)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

platformButton.MouseButton1Click:Connect(toggleMinecraftMode)
bigPlatformButton.MouseButton1Click:Connect(function() createPlatform(30) end)
clearButton.MouseButton1Click:Connect(clearAll)

upButton.MouseButton1Click:Connect(function() 
    createInclinedPath(Vector3.new(0, 1, 0), 30, 45) 
end)

downButton.MouseButton1Click:Connect(function() 
    createInclinedPath(Vector3.new(0, -1, 0), 30, -45) 
end)

forwardButton.MouseButton1Click:Connect(function() 
    createInclinedPath(Vector3.new(0, 0, 1), 50, 0) 
end)

Players.LocalPlayer:GetMouse().Button1Down:Connect(function()
    tryBuildPlatform()
end)

-- Автофокус на игрока при постройке
workspace.ChildAdded:Connect(function(child)
    if table.find(createdParts, child) and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        workspace.CurrentCamera.CameraSubject = Player.Character.HumanoidRootPart
    end
end)

print("VIX Plate загружен успешно!")
