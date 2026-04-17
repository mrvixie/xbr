--[[
    VIX Modules - Unified Mobile GUI
    Creator: VIXIE
    All modules combined with toggle system
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ==================== MAIN TOGGLE GUI ====================

local MainGui = Instance.new("ScreenGui")
MainGui.Name = "VIX Modules"
MainGui.ResetOnSpawn = false
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local suc, err = pcall(function()
    MainGui.Parent = player:WaitForChild("PlayerGui")
end)

if not suc then
    MainGui.Parent = game:GetService("CoreGui")
end

-- Toggle Button
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.95, -25, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ToggleBtn.Image = "rbxassetid://6031091004"
ToggleBtn.ImageRectOffset = Vector3.new(464, 404)
ToggleBtn.ScaleType = Enum.ScaleType.Fit
ToggleBtn.Parent = MainGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0.5, 0)
toggleCorner.Parent = ToggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(255, 100, 100)
toggleStroke.Thickness = 2
toggleStroke.Parent = ToggleBtn

-- Main Container (сворачивается по ширине)
local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Size = UDim2.new(0, 200, 0, 0)
Container.Position = UDim2.new(0.95, -200, 0.5, 0)
Container.BackgroundColor3 = Color3.fromRGB(45, 0, 0)
Container.BackgroundTransparency = 0.2
Container.BorderSizePixel = 0
Container.Parent = MainGui

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 12)
containerCorner.Parent = Container

local containerStroke = Instance.new("UIStroke")
containerStroke.Color = Color3.fromRGB(100, 30, 30)
containerStroke.Thickness = 2
containerStroke.Parent = Container

-- Module Toggle Frame
local ModuleToggleFrame = Instance.new("Frame")
ModuleToggleFrame.Name = "ModuleToggles"
ModuleToggleFrame.Size = UDim2.new(1, 0, 0, 0)
ModuleToggleFrame.AutomaticSize = Enum.AutomaticSize.Y
ModuleToggleFrame.BackgroundTransparency = 1
ModuleToggleFrame.Parent = Container

local toggleLayout = Instance.new("UIListLayout")
toggleLayout.SortOrder = Enum.SortOrder.LayoutOrder
toggleLayout.Padding = UDim.new(0, 5)
toggleLayout.Parent = ModuleToggleFrame

local togglePadding = Instance.new("UIPadding")
togglePadding.PaddingTop = UDim.new(0, 10)
togglePadding.PaddingBottom = UDim.new(0, 10)
togglePadding.PaddingLeft = UDim.new(0, 10)
togglePadding.PaddingRight = UDim.new(0, 10)
togglePadding.Parent = ModuleToggleFrame

-- Module states
local moduleStates = {}
local modulesContainer = {}
local modulesVisible = true

-- Create module toggle button
local function createModuleToggle(name, order)
    local toggle = Instance.new("Frame")
    toggle.Name = name
    toggle.Size = UDim2.new(1, 0, 0, 35)
    toggle.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    toggle.BackgroundTransparency = 0.3
    toggle.LayoutOrder = order
    toggle.Parent = ModuleToggleFrame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggle

    local statusDot = Instance.new("Frame")
    statusDot.Name = "StatusDot"
    statusDot.Size = UDim2.new(0, 12, 0, 12)
    statusDot.Position = UDim2.new(0, 5, 0.5, -6)
    statusDot.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    statusDot.Parent = toggle

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = statusDot

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -50, 1, 0)
    title.Position = UDim2.new(0, 25, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 12
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = toggle

    local switchFrame = Instance.new("Frame")
    switchFrame.Name = "SwitchFrame"
    switchFrame.Size = UDim2.new(0, 40, 0, 22)
    switchFrame.Position = UDim2.new(1, -45, 0.5, -11)
    switchFrame.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    switchFrame.Parent = toggle

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 11)
    switchCorner.Parent = switchFrame

    local switchKnob = Instance.new("Frame")
    switchKnob.Name = "Knob"
    switchKnob.Size = UDim2.new(0, 18, 0, 18)
    switchKnob.Position = UDim2.new(0, 2, 0.5, -9)
    switchKnob.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    switchKnob.Parent = switchFrame

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = switchKnob

    local enabled = true
    moduleStates[name] = true

    local function updateSwitch()
        if enabled then
            statusDot.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            switchKnob.Position = UDim2.new(1, -20, 0.5, -9)
            switchFrame.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        else
            statusDot.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            switchKnob.Position = UDim2.new(0, 2, 0.5, -9)
            switchFrame.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        end
    end

    switchFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            enabled = not enabled
            moduleStates[name] = enabled
            updateSwitch()
            
            local content = modulesContainer[name]
            if content then
                content.Visible = enabled
            end
        end
    end)

    updateSwitch()
    return toggle, statusDot, title
end

-- Mobile drag for container
local isDragging = false
local dragStart = nil
local startPos = nil

Container.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = Container.Position
    end
end)

Container.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

Container.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                      input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Container.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Toggle button rotation
local toggleRotation = 0
ToggleBtn.MouseButton1Click:Connect(function()
    modulesVisible = not modulesVisible
    
    spawn(function()
        for i = 1, 10 do
            toggleRotation = toggleRotation + ((modulesVisible and 0 or 180) - toggleRotation) * 0.3
            ToggleBtn.Rotation = toggleRotation
            wait(0.02)
        end
    end)
    
    if not modulesVisible then
        Container:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true)
        ToggleBtn.Position = UDim2.new(0.5, -25, 0.5, -25)
    else
        Container:TweenSize(UDim2.new(0, 200, 0, 0), "Out", "Quad", 0.1, true)
        wait(0.15)
        Container:TweenSize(UDim2.new(0, 200, 0, 500), "Out", "Quad", 0.3, true)
        ToggleBtn.Position = UDim2.new(0.95, -25, 0.5, -25)
    end
end)

-- ==================== HELPER FUNCTIONS ====================

local function addCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or UDim.new(0, 10)
    corner.Parent = instance
    return corner
end

local function addStroke(instance, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = thickness or 1
    stroke.Parent = instance
    return stroke
end

local function makeGlass(frame)
    frame.BackgroundColor3 = Color3.fromRGB(50, 10, 10)
    frame.BackgroundTransparency = 0.4
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
    })
    gradient.Rotation = 45
    gradient.Parent = frame
end

-- ==================== MODULE 1: VFLY ====================

local VFlyToggle = createModuleToggle("VIX | VFly", 1)

local VFlyGui = Instance.new("ScreenGui")
VFlyGui.Name = "VFlyGui"
VFlyGui.Parent = MainGui

local VFlyDrag = Instance.new("Frame")
VFlyDrag.Name = "Drag"
VFlyDrag.Size = UDim2.new(0, 130, 0, 32)
VFlyDrag.Position = UDim2.new(0.48, 0, 0.45, 0)
VFlyDrag.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
VFlyDrag.BackgroundTransparency = 0.3
VFlyDrag.Active = true
VFlyDrag.Parent = VFlyGui
addCorner(VFlyDrag)

local VFlyFrame = Instance.new("Frame")
VFlyFrame.Name = "FlyFrame"
VFlyFrame.Size = UDim2.new(0, 130, 0, 90)
VFlyFrame.Position = UDim2.new(-0.002, 0, 1.6, 0)
VFlyFrame.BackgroundColor3 = Color3.fromRGB(125, 0, 0)
VFlyFrame.BackgroundTransparency = 0.3
VFlyFrame.Parent = VFlyDrag
addCorner(VFlyFrame)

local VFlyLabel = Instance.new("TextLabel")
VFlyLabel.Size = UDim2.new(0, 57, 0, 27)
VFlyLabel.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
VFlyLabel.BackgroundTransparency = 0.3
VFlyLabel.Text = "VIX | Vfly"
VFlyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
VFlyLabel.TextScaled = true
VFlyLabel.Parent = VFlyDrag
addCorner(VFlyLabel)

local VFlyClose = Instance.new("TextButton")
VFlyClose.Size = UDim2.new(0, 27, 0, 27)
VFlyClose.Position = UDim2.new(0.78, 0, 0, 0)
VFlyClose.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
VFlyClose.BackgroundTransparency = 0.3
VFlyClose.Text = "X"
VFlyClose.TextColor3 = Color3.fromRGB(255, 255, 255)
VFlyClose.TextScaled = true
VFlyClose.Parent = VFlyDrag
addCorner(VFlyClose)

local VFlyMini = Instance.new("TextButton")
VFlyMini.Size = UDim2.new(0, 27, 0, 27)
VFlyMini.Position = UDim2.new(0.55, 0, 0, 0)
VFlyMini.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
VFlyMini.BackgroundTransparency = 0.3
VFlyMini.Text = "-"
VFlyMini.TextColor3 = Color3.fromRGB(255, 255, 255)
VFlyMini.TextScaled = true
VFlyMini.Parent = VFlyDrag
addCorner(VFlyMini)

local VFlySpeed = Instance.new("TextBox")
VFlySpeed.Size = UDim2.new(1, -5, 0, 30)
VFlySpeed.Position = UDim2.new(0, 2.5, 0, 5)
VFlySpeed.BackgroundColor3 = Color3.fromRGB(163, 0, 0)
VFlySpeed.BackgroundTransparency = 0.3
VFlySpeed.Text = "300"
VFlySpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
VFlySpeed.TextScaled = true
VFlySpeed.Parent = VFlyFrame
addCorner(VFlySpeed)

local VFlyOn = Instance.new("TextButton")
VFlyOn.Size = UDim2.new(1, -10, 0, 25)
VFlyOn.Position = UDim2.new(0, 5, 0, 40)
VFlyOn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
VFlyOn.BackgroundTransparency = 0.3
VFlyOn.Text = "Fly ON"
VFlyOn.TextColor3 = Color3.fromRGB(255, 255, 255)
VFlyOn.TextScaled = true
VFlyOn.Parent = VFlyFrame
addCorner(VFlyOn)

local VFlyOff = Instance.new("TextButton")
VFlyOff.Size = UDim2.new(1, -10, 0, 25)
VFlyOff.Position = UDim2.new(0, 5, 0, 40)
VFlyOff.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
VFlyOff.BackgroundTransparency = 0.3
VFlyOff.Text = "Fly OFF"
VFlyOff.TextColor3 = Color3.fromRGB(255, 255, 255)
VFlyOff.TextScaled = true
VFlyOff.Visible = false
VFlyOff.Parent = VFlyFrame
addCorner(VFlyOff)

local VFlyStatus = Instance.new("TextLabel")
VFlyStatus.Size = UDim2.new(1, -10, 0, 15)
VFlyStatus.Position = UDim2.new(0, 5, 0, 68)
VFlyStatus.BackgroundTransparency = 1
VFlyStatus.Text = "OFF"
VFlyStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
VFlyStatus.TextScaled = true
VFlyStatus.Parent = VFlyFrame

-- Fly controls frame
local FlyControls = Instance.new("Frame")
FlyControls.Name = "FlyControls"
FlyControls.Size = UDim2.new(0, 130, 0, 90)
FlyControls.Position = UDim2.new(0.12, 0, 0.55, 0)
FlyControls.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
FlyControls.BackgroundTransparency = 0.3
FlyControls.Visible = false
FlyControls.Parent = VFlyGui
addCorner(FlyControls)

-- W button
local VW = Instance.new("TextButton")
VW.Size = UDim2.new(0.4, 0, 0.4, 0)
VW.Position = UDim2.new(0.05, 0, 0.05, 0)
VW.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
VW.Text = "^"
VW.TextColor3 = Color3.fromRGB(255, 255, 255)
VW.TextScaled = true
VW.Parent = FlyControls
addCorner(VW)

-- S button
local VS = Instance.new("TextButton")
VS.Size = UDim2.new(0.4, 0, 0.4, 0)
VS.Position = UDim2.new(0.05, 0, 0.55, 0)
VS.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
VS.Text = "^"
VS.TextColor3 = Color3.fromRGB(255, 255, 255)
VS.TextScaled = true
VS.Rotation = 180
VS.Parent = FlyControls
addCorner(VS)

-- Loop button
local VLoop = Instance.new("TextButton")
VLoop.Size = UDim2.new(0.4, 0, 0.4, 0)
VLoop.Position = UDim2.new(0.55, 0, 0.05, 0)
VLoop.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
VLoop.Text = "LOOP"
VLoop.TextColor3 = Color3.fromRGB(255, 255, 255)
VLoop.TextScaled = true
VLoop.Parent = FlyControls
addCorner(VLoop)

-- Boost button
local VBoost = Instance.new("TextButton")
VBoost.Size = UDim2.new(0.4, 0, 0.4, 0)
VBoost.Position = UDim2.new(0.55, 0, 0.55, 0)
VBoost.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
VBoost.Text = "BOOST"
VBoost.TextColor3 = Color3.fromRGB(255, 255, 255)
VBoost.TextScaled = true
VBoost.Parent = FlyControls
addCorner(VBoost)

-- VFly logic
local isFlying = false
local isLooping = false
local loopConnection = nil
local currentLoopDir = nil

local function flyDirection(dir)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp and hrp:FindFirstChildOfClass("BodyVelocity") then
        hrp.BodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * dir * tonumber(VFlySpeed.Text)
    end
end

local function stopFly()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp and hrp:FindFirstChildOfClass("BodyVelocity") then
        hrp.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end

VFlyOn.MouseButton1Click:Connect(function()
    if isFlying then return end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    isFlying = true
    VFlyOn.Visible = false
    VFlyOff.Visible = true
    VFlyStatus.Text = "ON"
    VFlyStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
    FlyControls.Visible = true
    
    local BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.Parent = hrp
    
    local BG = Instance.new("BodyGyro")
    BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    BG.D = 5000
    BG.P = 100000
    BG.Parent = hrp
    
    RunService.RenderStepped:Connect(function()
        if BG and hrp and hrp.Parent then
            BG.CFrame = workspace.CurrentCamera.CFrame
        end
    end)
end)

VFlyOff.MouseButton1Click:Connect(function()
    isFlying = false
    VFlyOn.Visible = true
    VFlyOff.Visible = false
    VFlyStatus.Text = "OFF"
    VFlyStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
    FlyControls.Visible = false
    
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, v in pairs(hrp:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                v:Destroy()
            end
        end
    end
end)

VW.MouseButton1Click:Connect(function()
    currentLoopDir = 1
    if isLooping then
        if loopConnection then loopConnection:Disconnect() end
        loopConnection = RunService.RenderStepped:Connect(function() flyDirection(1) end)
    else
        flyDirection(1)
        wait(0.1)
        stopFly()
    end
end)

VS.MouseButton1Click:Connect(function()
    currentLoopDir = -1
    if isLooping then
        if loopConnection then loopConnection:Disconnect() end
        loopConnection = RunService.RenderStepped:Connect(function() flyDirection(-1) end)
    else
        flyDirection(-1)
        wait(0.1)
        stopFly()
    end
end)

VLoop.MouseButton1Click:Connect(function()
    isLooping = not isLooping
    VLoop.BackgroundColor3 = isLooping and Color3.fromRGB(150, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

VBoost.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp and hrp:FindFirstChildOfClass("BodyVelocity") then
        for i = 1, 20 do
            hrp.BodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * tonumber(VFlySpeed.Text) * 2
            wait(0.02)
        end
        hrp.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end)

VFlyMini.MouseButton1Click:Connect(function()
    VFlyMini.Text = VFlyMini.Text == "-" and "+" or "-"
    VFlyFrame.Visible = VFlyMini.Text == "-"
end)

VFlyClose.MouseButton1Click:Connect(function()
    if isFlying then
        VFlyOff.MouseButton1Click:Fire()
    end
    VFlyGui.Visible = false
end)

-- Store for toggle
local VFlyContentFrame = Instance.new("Frame")
VFlyContentFrame.Name = "VFlyContent"
VFlyContentFrame.Size = UDim2.new(1, 0, 0, 40)
VFlyContentFrame.BackgroundTransparency = 1
VFlyContentFrame.Visible = moduleStates["VIX | VFly"]
VFlyContentFrame.Parent = ModuleToggleFrame
modulesContainer["VIX | VFly"] = VFlyContentFrame

local VFlyOpenBtn = Instance.new("TextButton")
VFlyOpenBtn.Size = UDim2.new(1, -10, 0, 30)
VFlyOpenBtn.Position = UDim2.new(0, 5, 0, 5)
VFlyOpenBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
VFlyOpenBtn.Text = "Open VFly"
VFlyOpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VFlyOpenBtn.TextScaled = true
VFlyOpenBtn.Parent = VFlyContentFrame
addCorner(VFlyOpenBtn)
VFlyOpenBtn.MouseButton1Click:Connect(function()
    VFlyGui.Visible = true
end)

-- ==================== MODULE 2: CLIPS (NOCLIP) ====================

local ClipsToggle = createModuleToggle("VIX | Clips", 2)

local ClipsGui = Instance.new("ScreenGui")
ClipsGui.Name = "ClipsGui"
ClipsGui.Parent = MainGui

local ClipsFrame = Instance.new("Frame")
ClipsFrame.Size = UDim2.new(0, 70, 0, 45)
ClipsFrame.Position = UDim2.new(0.5, -50, 0.5, -75)
ClipsFrame.BackgroundColor3 = Color3.fromRGB(45, 0, 0)
ClipsFrame.BackgroundTransparency = 0.3
ClipsFrame.Active = true
ClipsFrame.Parent = ClipsGui
addCorner(ClipsFrame)

local ClipsTitle = Instance.new("TextLabel")
ClipsTitle.Size = UDim2.new(1, 0, -0.1, 0)
ClipsTitle.Position = UDim2.new(0, 0, -0.05, 0)
ClipsTitle.BackgroundTransparency = 1
ClipsTitle.Text = "VIX | Clips"
ClipsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ClipsTitle.TextScaled = true
ClipsTitle.Parent = ClipsFrame

local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(0.8, 0, 0.3, 0)
NoclipBtn.Position = UDim2.new(0.1, 0, 0)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(75, 0, 0)
NoclipBtn.Text = "NoClip"
NoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipBtn.TextWrapped = true
NoclipBtn.Parent = ClipsFrame
addCorner(NoclipBtn)

local ReclipBtn = Instance.new("TextButton")
ReclipBtn.Size = UDim2.new(0.8, 0, 0.3, 0)
ReclipBtn.Position = UDim2.new(0.1, 0, 0.33)
ReclipBtn.BackgroundColor3 = Color3.fromRGB(75, 0, 0)
ReclipBtn.Text = "ReClip"
ReclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ReclipBtn.TextWrapped = true
ReclipBtn.Parent = ClipsFrame
addCorner(ReclipBtn)

local InvisBtn = Instance.new("TextButton")
InvisBtn.Size = UDim2.new(0.8, 0, 0.3, 0)
InvisBtn.Position = UDim2.new(0.1, 0, 0.66)
InvisBtn.BackgroundColor3 = Color3.fromRGB(75, 0, 0)
InvisBtn.Text = "Invis"
InvisBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
InvisBtn.TextWrapped = true
InvisBtn.Parent = ClipsFrame
addCorner(InvisBtn)

local ClipsCloseBtn = Instance.new("TextButton")
ClipsCloseBtn.Size = UDim2.new(0.2, 0, 0.2, 0)
ClipsCloseBtn.Position = UDim2.new(0.8, 0, 0)
ClipsCloseBtn.BackgroundColor3 = Color3.fromRGB(55, 0, 0)
ClipsCloseBtn.Text = "X"
ClipsCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClipsCloseBtn.TextWrapped = true
ClipsCloseBtn.Parent = ClipsFrame
addCorner(ClipsCloseBtn)

local AutoToggleBtn = Instance.new("TextButton")
AutoToggleBtn.Size = UDim2.new(0.2, 0, 0.5, 0)
AutoToggleBtn.Position = UDim2.new(0.8, 0, 0.25)
AutoToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 0)
AutoToggleBtn.Text = "A"
AutoToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoToggleBtn.Parent = ClipsFrame
addCorner(AutoToggleBtn)

-- Clips logic
local noclip = false
local autoNoclip = false
local invisToggled = false

local function setNoclip(state)
    noclip = state
    local char = player.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

NoclipBtn.MouseButton1Click:Connect(function()
    setNoclip(true)
end)

ReclipBtn.MouseButton1Click:Connect(function()
    setNoclip(false)
end)

InvisBtn.MouseButton1Click:Connect(function()
    invisToggled = not invisToggled
    local char = player.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanTouch = not invisToggled
            end
        end
    end
    InvisBtn.BackgroundColor3 = invisToggled and Color3.fromRGB(0, 75, 0) or Color3.fromRGB(75, 0, 0)
end)

AutoToggleBtn.MouseButton1Click:Connect(function()
    autoNoclip = not autoNoclip
    AutoToggleBtn.BackgroundColor3 = autoNoclip and Color3.fromRGB(0, 75, 0) or Color3.fromRGB(80, 80, 0)
end)

ClipsCloseBtn.MouseButton1Click:Connect(function()
    ClipsGui.Visible = false
end)

spawn(function()
    while wait(1) do
        if autoNoclip then
            setNoclip(true)
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    if noclip or autoNoclip then
        wait(0.5)
        setNoclip(true)
    end
end)

-- Store for toggle
local ClipsContentFrame = Instance.new("Frame")
ClipsContentFrame.Name = "ClipsContent"
ClipsContentFrame.Size = UDim2.new(1, 0, 0, 40)
ClipsContentFrame.BackgroundTransparency = 1
ClipsContentFrame.Visible = moduleStates["VIX | Clips"]
ClipsContentFrame.Parent = ModuleToggleFrame
modulesContainer["VIX | Clips"] = ClipsContentFrame

local ClipsOpenBtn = Instance.new("TextButton")
ClipsOpenBtn.Size = UDim2.new(1, -10, 0, 30)
ClipsOpenBtn.Position = UDim2.new(0, 5, 0, 5)
ClipsOpenBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ClipsOpenBtn.Text = "Open Clips"
ClipsOpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClipsOpenBtn.TextScaled = true
ClipsOpenBtn.Parent = ClipsContentFrame
addCorner(ClipsOpenBtn)
ClipsOpenBtn.MouseButton1Click:Connect(function()
    ClipsGui.Visible = true
end)

-- ==================== MODULE 3: PLATE ====================

local PlateToggle = createModuleToggle("VIX | Plate", 3)

local PlateGui = Instance.new("ScreenGui")
PlateGui.Name = "PlateGui"
PlateGui.Parent = MainGui

local PlateMainFrame = Instance.new("Frame")
PlateMainFrame.Size = UDim2.new(0, 200, 0, 145)
PlateMainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
PlateMainFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
PlateMainFrame.BackgroundTransparency = 0.3
PlateMainFrame.Active = true
PlateMainFrame.Parent = PlateGui
addCorner(PlateMainFrame)

local PlateTopBar = Instance.new("Frame")
PlateTopBar.Size = UDim2.new(1, 0, 0, 35)
PlateTopBar.BackgroundColor3 = Color3.fromRGB(90, 0, 0)
PlateTopBar.BackgroundTransparency = 0.3
PlateTopBar.Parent = PlateMainFrame
addCorner(PlateTopBar)

local PlateTitle = Instance.new("TextLabel")
PlateTitle.Size = UDim2.new(0.8, 0, 1, 0)
PlateTitle.BackgroundTransparency = 1
PlateTitle.Text = "VIX | Plate"
PlateTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PlateTitle.Font = Enum.Font.GothamBold
PlateTitle.TextSize = 18
PlateTitle.TextWrapped = true
PlateTitle.Parent = PlateTopBar

local PlateHideBtn = Instance.new("TextButton")
PlateHideBtn.Size = UDim2.new(0, 25, 0, 25)
PlateHideBtn.Position = UDim2.new(0.8, 0, 0, 5)
PlateHideBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
PlateHideBtn.Text = "-"
PlateHideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlateHideBtn.TextWrapped = true
PlateHideBtn.Parent = PlateTopBar
addCorner(PlateHideBtn)

local PlateCloseBtn = Instance.new("TextButton")
PlateCloseBtn.Size = UDim2.new(0, 25, 0, 25)
PlateCloseBtn.Position = UDim2.new(0.9, 0, 0, 5)
PlateCloseBtn.BackgroundColor3 = Color3.fromRGB(155, 0, 0)
PlateCloseBtn.Text = "X"
PlateCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlateCloseBtn.TextWrapped = true
PlateCloseBtn.Parent = PlateTopBar
addCorner(PlateCloseBtn)

local PlateButtonsFrame = Instance.new("Frame")
PlateButtonsFrame.Size = UDim2.new(1, 0, 0, 110)
PlateButtonsFrame.Position = UDim2.new(0, 0, 0, 35)
PlateButtonsFrame.BackgroundTransparency = 1
PlateButtonsFrame.Parent = PlateMainFrame

local plateBtnColor = Color3.fromRGB(175, 0, 0)
local plateTextColor = Color3.fromRGB(255, 255, 255)

local function createPlateBtn(text, pos, size, callback)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = plateBtnColor
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = plateTextColor
    btn.TextWrapped = true
    btn.Parent = PlateButtonsFrame
    addCorner(btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Row 1
createPlateBtn("Up /", UDim2.new(0.05, 0, 0.1, 0), UDim2.new(0.425, 0, 0.2, 0), function()
    for i = 1, 50 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(5, 0.5, 2)
        part.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, i * 0.5 - 3.5, -i * 0.5)
        part.Transparency = 0.8
        part.Anchored = true
        part.BrickColor = BrickColor.new("Bright red")
        part.Parent = workspace
    end
end)

createPlateBtn("Down \\", UDim2.new(0.525, 0, 0.1, 0), UDim2.new(0.425, 0, 0.2, 0), function()
    for i = 1, 50 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(5, 0.5, 2)
        part.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -i * 0.5 - 3.5, -i * 0.5)
        part.Transparency = 0.8
        part.Anchored = true
        part.BrickColor = BrickColor.new("Bright red")
        part.Parent = workspace
    end
end)

-- Row 2
createPlateBtn("Small", UDim2.new(0.05, 0, 0.4, 0), UDim2.new(0.425, 0, 0.2, 0), function()
    local part = Instance.new("Part")
    part.Size = Vector3.new(15, 1, 15)
    part.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)
    part.Transparency = 0.8
    part.Anchored = true
    part.BrickColor = BrickColor.new("Bright red")
    part.Parent = workspace
end)

createPlateBtn("Clear", UDim2.new(0.525, 0, 0.4, 0), UDim2.new(0.425, 0, 0.2, 0), function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "VIXPlate" then
            obj:Destroy()
        end
    end
end)

-- Row 3
createPlateBtn("Big", UDim2.new(0.05, 0, 0.7, 0), UDim2.new(0.425, 0, 0.2, 0), function()
    local part = Instance.new("Part")
    part.Size = Vector3.new(40, 1, 40)
    part.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)
    part.Transparency = 0.8
    part.Anchored = true
    part.BrickColor = BrickColor.new("Bright red")
    part.Parent = workspace
end)

createPlateBtn("H-Stairs", UDim2.new(0.525, 0, 0.7, 0), UDim2.new(0.425, 0, 0.2, 0), function()
    for i = 1, 50 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(5, 0.5, 2)
        part.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(i * 0.5 - 3.5, 0, -i * 0.5)
        part.Transparency = 0.8
        part.Anchored = true
        part.BrickColor = BrickColor.new("Bright red")
        part.Parent = workspace
    end
end)

PlateHideBtn.MouseButton1Click:Connect(function()
    PlateHideBtn.Text = PlateHideBtn.Text == "-" and "+" or "-"
    PlateButtonsFrame.Visible = PlateHideBtn.Text == "-"
    PlateMainFrame.Size = PlateHideBtn.Text == "-" and UDim2.new(0, 200, 0, 145) or UDim2.new(0, 200, 0, 35)
end)

PlateCloseBtn.MouseButton1Click:Connect(function()
    PlateGui.Visible = false
end)

-- Store for toggle
local PlateContentFrame = Instance.new("Frame")
PlateContentFrame.Name = "PlateContent"
PlateContentFrame.Size = UDim2.new(1, 0, 0, 40)
PlateContentFrame.BackgroundTransparency = 1
PlateContentFrame.Visible = moduleStates["VIX | Plate"]
PlateContentFrame.Parent = ModuleToggleFrame
modulesContainer["VIX | Plate"] = PlateContentFrame

local PlateOpenBtn = Instance.new("TextButton")
PlateOpenBtn.Size = UDim2.new(1, -10, 0, 30)
PlateOpenBtn.Position = UDim2.new(0, 5, 0, 5)
PlateOpenBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
PlateOpenBtn.Text = "Open Plate"
PlateOpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlateOpenBtn.TextScaled = true
PlateOpenBtn.Parent = PlateContentFrame
addCorner(PlateOpenBtn)
PlateOpenBtn.MouseButton1Click:Connect(function()
    PlateGui.Visible = true
end)

-- ==================== MODULE 4: RECTP ====================

local RecTPToggle = createModuleToggle("VIX | RecTP", 4)

local RecTPGui = Instance.new("ScreenGui")
RecTPGui.Name = "RecTPGui"
RecTPGui.Parent = MainGui

local RecTPFrame = Instance.new("Frame")
RecTPFrame.Size = UDim2.new(0, 150, 0, 140)
RecTPFrame.Position = UDim2.new(0, 5, 0, 5)
RecTPFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
RecTPFrame.BackgroundTransparency = 0.3
RecTPFrame.Active = true
RecTPFrame.Parent = RecTPGui
addCorner(RecTPFrame)

local RecTPTopBar = Instance.new("Frame")
RecTPTopBar.Size = UDim2.new(1, 0, 0, 30)
RecTPTopBar.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
RecTPTopBar.BackgroundTransparency = 0.3
RecTPTopBar.Parent = RecTPFrame
addCorner(RecTPTopBar)

local RecTPTitle = Instance.new("TextLabel")
RecTPTitle.Size = UDim2.new(1, -70, 1, 0)
RecTPTitle.Position = UDim2.new(0, 5, 0, 0)
RecTPTitle.BackgroundTransparency = 1
RecTPTitle.Text = "VIX | RecTP"
RecTPTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
RecTPTitle.TextSize = 9
RecTPTitle.Parent = RecTPTopBar

local RecTPCloseBtn = Instance.new("TextButton")
RecTPCloseBtn.Size = UDim2.new(0, 25, 0, 25)
RecTPCloseBtn.Position = UDim2.new(1, -30, 0, 2.5)
RecTPCloseBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
RecTPCloseBtn.Text = "X"
RecTPCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RecTPCloseBtn.Parent = RecTPTopBar
addCorner(RecTPCloseBtn)

local RecTPHideBtn = Instance.new("TextButton")
RecTPHideBtn.Size = UDim2.new(0, 25, 0, 25)
RecTPHideBtn.Position = UDim2.new(1, -58, 0, 2.5)
RecTPHideBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
RecTPHideBtn.Text = "-"
RecTPHideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RecTPHideBtn.Parent = RecTPTopBar
addCorner(RecTPHideBtn)

local function createRecTPBtn(text, pos, size, callback)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Parent = RecTPFrame
    addCorner(btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Row 1
createRecTPBtn("▶", UDim2.new(0, 5, 0, 35), UDim2.new(0, 30, 0, 30), function()
    autoTeleport = true
    for _, point in ipairs(points) do
        if autoTeleport and player.Character then
            player.Character:SetPrimaryPartCFrame(CFrame.new(point))
            wait(teleportDelay)
        end
    end
end)

createRecTPBtn("||", UDim2.new(0, 40, 0, 35), UDim2.new(0, 30, 0, 30), function()
    autoTeleport = false
end)

createRecTPBtn("▶||", UDim2.new(0, 75, 0, 35), UDim2.new(0, 30, 0, 30), function()
    autoTeleport = true
end)

-- Row 2
local RecordBtn = createRecTPBtn("Rec", UDim2.new(0, 5, 0, 70), UDim2.new(0, 70, 0, 30), function()
    isRecording = not isRecording
    RecordBtn.Text = isRecording and "Stop" or "Rec"
    RecordBtn.BackgroundColor3 = isRecording and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(70, 0, 0)
end)

createRecTPBtn("+", UDim2.new(0, 80, 0, 70), UDim2.new(0, 30, 0, 30), function()
    if isRecording then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            table.insert(points, hrp.Position)
        end
    end
end)

createRecTPBtn("–", UDim2.new(0, 115, 0, 70), UDim2.new(0, 30, 0, 30), function()
    table.remove(points)
end)

-- Row 3
createRecTPBtn("Loop", UDim2.new(0, 80, 0, 105), UDim2.new(0, 30, 0, 30), function()
    cycleEnabled = not cycleEnabled
end)

local DelayInput = Instance.new("TextBox")
DelayInput.Size = UDim2.new(0, 30, 0, 30)
DelayInput.Position = UDim2.new(0, 115, 0, 105)
DelayInput.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
DelayInput.BackgroundTransparency = 0.3
DelayInput.Text = "1"
DelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayInput.TextScaled = true
DelayInput.Parent = RecTPFrame
addCorner(DelayInput)
DelayInput.FocusLost:Connect(function()
    local val = tonumber(DelayInput.Text)
    if val then teleportDelay = val end
end)

createRecTPBtn("→👤", UDim2.new(0, 5, 0, 105), UDim2.new(0, 40, 0, 30), function()
    local players = Players:GetPlayers()
    if #players > 1 then
        local randomPlayer
        repeat
            randomPlayer = players[math.random(#players)]
        until randomPlayer ~= player
        local hrp = randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and player.Character then
            player.Character:SetPrimaryPartCFrame(CFrame.new(hrp.Position))
        end
    end
end)

-- RecTP variables
local isRecording = false
local points = {}
local teleportDelay = 1
local autoTeleport = false
local cycleEnabled = false

RecTPHideBtn.MouseButton1Click:Connect(function()
    RecTPHideBtn.Text = RecTPHideBtn.Text == "-" and "+" or "-"
    for _, child in pairs(RecTPFrame:GetChildren()) do
        if child ~= RecTPTopBar then
            child.Visible = RecTPHideBtn.Text == "-"
        end
    end
    RecTPFrame.Size = RecTPHideBtn.Text == "-" and UDim2.new(0, 150, 0, 140) or UDim2.new(0, 150, 0, 30)
end)

RecTPCloseBtn.MouseButton1Click:Connect(function()
    RecTPGui.Visible = false
end)

-- Store for toggle
local RecTPContentFrame = Instance.new("Frame")
RecTPContentFrame.Name = "RecTPContent"
RecTPContentFrame.Size = UDim2.new(1, 0, 0, 40)
RecTPContentFrame.BackgroundTransparency = 1
RecTPContentFrame.Visible = moduleStates["VIX | RecTP"]
RecTPContentFrame.Parent = ModuleToggleFrame
modulesContainer["VIX | RecTP"] = RecTPContentFrame

local RecTPOpenBtn = Instance.new("TextButton")
RecTPOpenBtn.Size = UDim2.new(1, -10, 0, 30)
RecTPOpenBtn.Position = UDim2.new(0, 5, 0, 5)
RecTPOpenBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
RecTPOpenBtn.Text = "Open RecTP"
RecTPOpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RecTPOpenBtn.TextScaled = true
RecTPOpenBtn.Parent = RecTPContentFrame
addCorner(RecTPOpenBtn)
RecTPOpenBtn.MouseButton1Click:Connect(function()
    RecTPGui.Visible = true
end)

-- ==================== MODULE 5: SPEEDS ====================

local SpeedsToggle = createModuleToggle("VIX | Speeds", 5)

local SpeedsGui = Instance.new("ScreenGui")
SpeedsGui.Name = "SpeedsGui"
SpeedsGui.Parent = MainGui

local SpeedsFrame = Instance.new("Frame")
SpeedsFrame.Size = UDim2.new(0, 70, 0, 60)
SpeedsFrame.Position = UDim2.new(0.5, -50, 0.5, -25)
SpeedsFrame.BackgroundColor3 = Color3.fromRGB(45, 0, 0)
SpeedsFrame.BackgroundTransparency = 0.3
SpeedsFrame.Active = true
SpeedsFrame.Parent = SpeedsGui
addCorner(SpeedsFrame)

local SpeedsTitle = Instance.new("TextLabel")
SpeedsTitle.Size = UDim2.new(0.8, 0, 0.2, 0)
SpeedsTitle.Position = UDim2.new(0.1, 0, -0.2, 0)
SpeedsTitle.BackgroundTransparency = 1
SpeedsTitle.Text = "VIX | Speeds"
SpeedsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedsTitle.TextScaled = true
SpeedsTitle.Parent = SpeedsFrame

local SpeedsCloseBtn = Instance.new("TextButton")
SpeedsCloseBtn.Size = UDim2.new(0.2, 0, 0.2, 0)
SpeedsCloseBtn.Position = UDim2.new(0.8, 0, 0)
SpeedsCloseBtn.BackgroundColor3 = Color3.fromRGB(55, 0, 0)
SpeedsCloseBtn.Text = "X"
SpeedsCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedsCloseBtn.TextWrapped = true
SpeedsCloseBtn.TextSize = 7
SpeedsCloseBtn.Parent = SpeedsFrame
addCorner(SpeedsCloseBtn)

local SpeedsInput = Instance.new("TextBox")
SpeedsInput.Size = UDim2.new(0.8, 0, 0.2, 0)
SpeedsInput.Position = UDim2.new(0.1, 0, 0.3)
SpeedsInput.BackgroundColor3 = Color3.fromRGB(75, 0, 0)
SpeedsInput.BackgroundTransparency = 0.3
SpeedsInput.Text = "25"
SpeedsInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedsInput.TextWrapped = true
SpeedsInput.TextSize = 7
SpeedsInput.Parent = SpeedsFrame
addCorner(SpeedsInput)

local SpeedsBtn = Instance.new("TextButton")
SpeedsBtn.Size = UDim2.new(0.8, 0, 0.3, 0)
SpeedsBtn.Position = UDim2.new(0.1, 0, 0.6)
SpeedsBtn.BackgroundColor3 = Color3.fromRGB(75, 0, 0)
SpeedsBtn.BackgroundTransparency = 0.3
SpeedsBtn.Text = "Set Speed"
SpeedsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedsBtn.TextWrapped = true
SpeedsBtn.TextSize = 7
SpeedsBtn.Parent = SpeedsFrame
addCorner(SpeedsBtn)

local SpeedsLabel = Instance.new("TextLabel")
SpeedsLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
SpeedsLabel.Position = UDim2.new(0.1, 0, 0.1)
SpeedsLabel.BackgroundColor3 = Color3.fromRGB(45, 0, 0)
SpeedsLabel.BackgroundTransparency = 0.3
SpeedsLabel.Text = "Now: 16"
SpeedsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedsLabel.TextSize = 7
SpeedsLabel.Parent = SpeedsFrame
addCorner(SpeedsLabel)

-- Speeds logic
local initialSpeed = 16
local initialJumpPower = 50
local currentSpeed = initialSpeed
local currentJumpPower = initialJumpPower
local savedSpeed = initialSpeed
local savedJumpPower = initialJumpPower
local targetSpeed = initialSpeed
local targetJumpPower = initialJumpPower
local isCustomSpeed = false

SpeedsBtn.MouseButton1Click:Connect(function()
    local speedValue = tonumber(SpeedsInput.Text)
    if speedValue and speedValue < initialSpeed then
        SpeedsInput.Text = "25"
        speedValue = 25
    end

    if isCustomSpeed then
        targetSpeed = initialSpeed
        targetJumpPower = initialJumpPower
        isCustomSpeed = false
        SpeedsBtn.Text = "Set Speed"
    else
        if speedValue and speedValue > 0 then
            savedSpeed = currentSpeed
            savedJumpPower = currentJumpPower
            targetSpeed = speedValue
            targetJumpPower = initialJumpPower + speedValue / 1.5
            isCustomSpeed = true
            SpeedsBtn.Text = "Reset"
        end
    end
end)

SpeedsCloseBtn.MouseButton1Click:Connect(function()
    SpeedsGui.Visible = false
end)

spawn(function()
    while wait() do
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = isCustomSpeed and targetSpeed or savedSpeed
            humanoid.JumpPower = isCustomSpeed and targetJumpPower or savedJumpPower
            currentSpeed = humanoid.WalkSpeed
            currentJumpPower = humanoid.JumpPower
            SpeedsLabel.Text = "Now: " .. math.floor(humanoid.WalkSpeed)
        end
    end
end)

-- Store for toggle
local SpeedsContentFrame = Instance.new("Frame")
SpeedsContentFrame.Name = "SpeedsContent"
SpeedsContentFrame.Size = UDim2.new(1, 0, 0, 40)
SpeedsContentFrame.BackgroundTransparency = 1
SpeedsContentFrame.Visible = moduleStates["VIX | Speeds"]
SpeedsContentFrame.Parent = ModuleToggleFrame
modulesContainer["VIX | Speeds"] = SpeedsContentFrame

local SpeedsOpenBtn = Instance.new("TextButton")
SpeedsOpenBtn.Size = UDim2.new(1, -10, 0, 30)
SpeedsOpenBtn.Position = UDim2.new(0, 5, 0, 5)
SpeedsOpenBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
SpeedsOpenBtn.Text = "Open Speeds"
SpeedsOpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedsOpenBtn.TextScaled = true
SpeedsOpenBtn.Parent = SpeedsContentFrame
addCorner(SpeedsOpenBtn)
SpeedsOpenBtn.MouseButton1Click:Connect(function()
    SpeedsGui.Visible = true
end)

-- ==================== MODULE 6: TPSAVE ====================

local TPSaveToggle = createModuleToggle("VIX | TPSave", 6)

local TPSaveGui = Instance.new("ScreenGui")
TPSaveGui.Name = "TPSaveGui"
TPSaveGui.Parent = MainGui

local TPSaveFrame = Instance.new("Frame")
TPSaveFrame.Size = UDim2.new(0, 70, 0, 50)
TPSaveFrame.Position = UDim2.new(0.5, -50, 0.5, -25)
TPSaveFrame.BackgroundColor3 = Color3.fromRGB(145, 0, 0)
TPSaveFrame.BackgroundTransparency = 0.3
TPSaveFrame.Active = true
TPSaveFrame.Parent = TPSaveGui
addCorner(TPSaveFrame)

local TPSaveTitle = Instance.new("TextLabel")
TPSaveTitle.Size = UDim2.new(1, 0, -0.2, 0)
TPSaveTitle.Position = UDim2.new(0, 0, -0.05, 0)
TPSaveTitle.BackgroundTransparency = 1
TPSaveTitle.Text = "VIX | TpSave"
TPSaveTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
TPSaveTitle.TextScaled = true
TPSaveTitle.Parent = TPSaveFrame

local TPSaveCloseBtn = Instance.new("TextButton")
TPSaveCloseBtn.Size = UDim2.new(0.2, 0, 0.2, 0)
TPSaveCloseBtn.Position = UDim2.new(0.8, 0, 0)
TPSaveCloseBtn.BackgroundColor3 = Color3.fromRGB(155, 0, 0)
TPSaveCloseBtn.Text = "X"
TPSaveCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TPSaveCloseBtn.TextWrapped = true
TPSaveCloseBtn.Parent = TPSaveFrame
addCorner(TPSaveCloseBtn)

local TPSaveBtn = Instance.new("TextButton")
TPSaveBtn.Size = UDim2.new(0.8, 0, 0.4, 0)
TPSaveBtn.Position = UDim2.new(0.1, 0, 0)
TPSaveBtn.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
TPSaveBtn.BackgroundTransparency = 0.3
TPSaveBtn.Text = "Save"
TPSaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TPSaveBtn.TextWrapped = true
TPSaveBtn.TextScaled = true
TPSaveBtn.Parent = TPSaveFrame
addCorner(TPSaveBtn)

local TPTeleportBtn = Instance.new("TextButton")
TPTeleportBtn.Size = UDim2.new(0.8, 0, 0.35, 0)
TPTeleportBtn.Position = UDim2.new(0.1, 0, 0.51, 0)
TPTeleportBtn.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
TPTeleportBtn.BackgroundTransparency = 0.3
TPTeleportBtn.Text = "Teleport"
TPTeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TPTeleportBtn.TextWrapped = true
TPTeleportBtn.TextScaled = true
TPTeleportBtn.Parent = TPSaveFrame
addCorner(TPTeleportBtn)

local TPAutoBtn = Instance.new("TextButton")
TPAutoBtn.Size = UDim2.new(0.2, 0, 0.2, 0)
TPAutoBtn.Position = UDim2.new(0.8, 0, 0.51, 0)
TPAutoBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 0)
TPAutoBtn.BackgroundTransparency = 0.3
TPAutoBtn.Text = "A"
TPAutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TPAutoBtn.TextScaled = true
TPAutoBtn.Parent = TPSaveFrame
addCorner(TPAutoBtn)

-- TPSave logic
local savedPosition = nil
local autoTPEnabled = false

TPSaveBtn.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        savedPosition = hrp.Position
    end
end)

TPTeleportBtn.MouseButton1Click:Connect(function()
    if savedPosition and player.Character then
        player.Character:SetPrimaryPartCFrame(CFrame.new(savedPosition))
    end
end)

TPAutoBtn.MouseButton1Click:Connect(function()
    autoTPEnabled = not autoTPEnabled
    TPAutoBtn.BackgroundColor3 = autoTPEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 80, 0)
end)

TPSaveCloseBtn.MouseButton1Click:Connect(function()
    TPSaveGui.Visible = false
end)

spawn(function()
    while wait(1) do
        if autoTPEnabled and savedPosition and player.Character then
            player.Character:SetPrimaryPartCFrame(CFrame.new(savedPosition))
        end
    end
end)

-- Store for toggle
local TPSaveContentFrame = Instance.new("Frame")
TPSaveContentFrame.Name = "TPSaveContent"
TPSaveContentFrame.Size = UDim2.new(1, 0, 0, 40)
TPSaveContentFrame.BackgroundTransparency = 1
TPSaveContentFrame.Visible = moduleStates["VIX | TPSave"]
TPSaveContentFrame.Parent = ModuleToggleFrame
modulesContainer["VIX | TPSave"] = TPSaveContentFrame

local TPSaveOpenBtn = Instance.new("TextButton")
TPSaveOpenBtn.Size = UDim2.new(1, -10, 0, 30)
TPSaveOpenBtn.Position = UDim2.new(0, 5, 0, 5)
TPSaveOpenBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
TPSaveOpenBtn.Text = "Open TPSave"
TPSaveOpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TPSaveOpenBtn.TextScaled = true
TPSaveOpenBtn.Parent = TPSaveContentFrame
addCorner(TPSaveOpenBtn)
TPSaveOpenBtn.MouseButton1Click:Connect(function()
    TPSaveGui.Visible = true
end)

-- ==================== MODULE 7: UTILS ====================

local UtilsToggle = createModuleToggle("VIX | Utils", 7)

local UtilsGui = Instance.new("ScreenGui")
UtilsGui.Name = "UtilsGui"
UtilsGui.Parent = MainGui

local UtilsFrame = Instance.new("Frame")
UtilsFrame.Size = UDim2.new(0, 125, 0, 30)
UtilsFrame.Position = UDim2.new(0, 5, 0, 5)
UtilsFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
UtilsFrame.BackgroundTransparency = 0.3
UtilsFrame.Active = true
UtilsFrame.Parent = UtilsGui
addCorner(UtilsFrame)

local UtilsTopBar = Instance.new("Frame")
UtilsTopBar.Size = UDim2.new(1, 0, 0, 30)
UtilsTopBar.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
UtilsTopBar.BackgroundTransparency = 0.3
UtilsTopBar.Parent = UtilsFrame
addCorner(UtilsTopBar)

local UtilsTitle = Instance.new("TextLabel")
UtilsTitle.Size = UDim2.new(1, -75, 1, 0)
UtilsTitle.Position = UDim2.new(0, 10, 0, 0)
UtilsTitle.BackgroundTransparency = 1
UtilsTitle.Text = "VIX | Utils"
UtilsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
UtilsTitle.TextSize = 9
UtilsTitle.Parent = UtilsTopBar

local UtilsCloseBtn = Instance.new("TextButton")
UtilsCloseBtn.Size = UDim2.new(0, 25, 0, 25)
UtilsCloseBtn.Position = UDim2.new(1, -30, 0, 2.5)
UtilsCloseBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
UtilsCloseBtn.Text = "X"
UtilsCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UtilsCloseBtn.Parent = UtilsTopBar
addCorner(UtilsCloseBtn)

local UtilsMoreBtn = Instance.new("TextButton")
UtilsMoreBtn.Size = UDim2.new(0, 25, 0, 25)
UtilsMoreBtn.Position = UDim2.new(1, -60, 0, 2.5)
UtilsMoreBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
UtilsMoreBtn.Text = "▼"
UtilsMoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UtilsMoreBtn.Parent = UtilsTopBar
addCorner(UtilsMoreBtn)

-- Utils expanded content
local UtilsExpanded = Instance.new("Frame")
UtilsExpanded.Size = UDim2.new(0, 190, 0, 150)
UtilsExpanded.Position = UDim2.new(0, 0, 0, 30)
UtilsExpanded.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
UtilsExpanded.BackgroundTransparency = 0.3
UtilsExpanded.Visible = false
UtilsExpanded.Parent = UtilsFrame
addCorner(UtilsExpanded)

local function createUtilsBtn(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Parent = UtilsExpanded
    addCorner(btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- FullBright & DarkMode
createUtilsBtn("💡", UDim2.new(0, 5, 0, 5), function()
    fullbrightEnabled = not fullbrightEnabled
    if fullbrightEnabled then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.FogEnd = 100000
        Lighting.ClockTime = 12
    else
        Lighting.Ambient = originalAmbient
        Lighting.OutdoorAmbient = originalOutdoorAmbient
        Lighting.Brightness = originalBrightness
    end
end)

createUtilsBtn("🧥", UDim2.new(0, 40, 0, 5), function()
    darkmodeEnabled = not darkmodeEnabled
    if darkmodeEnabled then
        Lighting.Ambient = Color3.new(0, 0, 0)
        Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        Lighting.Brightness = 0
        Lighting.FogEnd = 10
        Lighting.FogColor = Color3.new(0, 0, 0)
    else
        Lighting.Ambient = originalAmbient
        Lighting.OutdoorAmbient = originalOutdoorAmbient
        Lighting.Brightness = originalBrightness
        Lighting.FogEnd = originalFogEnd
        Lighting.FogColor = originalFogColor
    end
end)

-- Gravity
local GravDisplay = Instance.new("TextLabel")
GravDisplay.Size = UDim2.new(0, 80, 0, 25)
GravDisplay.Position = UDim2.new(0, 75, 0, 5)
GravDisplay.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
GravDisplay.BackgroundTransparency = 0.3
GravDisplay.Text = "Grav: " .. math.floor(workspace.Gravity)
GravDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
GravDisplay.TextScaled = true
GravDisplay.Parent = UtilsExpanded
addCorner(GravDisplay)

createUtilsBtn("-", UDim2.new(0, 5, 0, 40), function()
    workspace.Gravity = math.max(0, workspace.Gravity - 10)
    GravDisplay.Text = "Grav: " .. math.floor(workspace.Gravity)
end)

createUtilsBtn("R", UDim2.new(0, 40, 0, 40), function()
    workspace.Gravity = 196.2
    GravDisplay.Text = "Grav: 196.2"
end)

createUtilsBtn("+", UDim2.new(0, 75, 0, 40), function()
    workspace.Gravity = workspace.Gravity + 10
    GravDisplay.Text = "Grav: " .. math.floor(workspace.Gravity)
end)

-- X-Ray
createUtilsBtn("X", UDim2.new(0, 5, 0, 75), function()
    xRayEnabled = not xRayEnabled
    if xRayEnabled then
        updateXRayObjects()
        for part, _ in pairs(xRayObjects) do
            if part and part.Parent then
                part.Transparency = 0.7
            end
        end
    else
        for part, trans in pairs(xRayObjects) do
            if part and part.Parent then
                part.Transparency = trans
            end
        end
    end
end)

createUtilsBtn("R", UDim2.new(0, 40, 0, 75), function()
    for part, trans in pairs(xRayObjects) do
        if part and part.Parent then
            part.Transparency = trans
        end
    end
    xRayEnabled = false
end)

createUtilsBtn("↑", UDim2.new(0, 75, 0, 75), UDim2.new(0, 50, 0, 30), function()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Utils logic
local originalAmbient = Lighting.Ambient
local originalOutdoorAmbient = Lighting.OutdoorAmbient
local originalBrightness = Lighting.Brightness
local originalFogEnd = Lighting.FogEnd
local originalFogColor = Lighting.FogColor
local fullbrightEnabled = false
local darkmodeEnabled = false
local xRayEnabled = false
local xRayObjects = {}

local function updateXRayObjects()
    xRayObjects = {}
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:FindFirstAncestorOfClass("Model") then
            xRayObjects[part] = part.Transparency
        end
    end
end

UtilsMoreBtn.MouseButton1Click:Connect(function()
    UtilsMoreBtn.Text = UtilsMoreBtn.Text == "▼" and "▲" or "▼"
    UtilsExpanded.Visible = UtilsMoreBtn.Text == "▲"
    UtilsFrame.Size = UtilsMoreBtn.Text == "▲" and UDim2.new(0, 190, 0, 183) or UDim2.new(0, 125, 0, 30)
end)

UtilsCloseBtn.MouseButton1Click:Connect(function()
    UtilsGui.Visible = false
end)

-- Store for toggle
local UtilsContentFrame = Instance.new("Frame")
UtilsContentFrame.Name = "UtilsContent"
UtilsContentFrame.Size = UDim2.new(1, 0, 0, 40)
UtilsContentFrame.BackgroundTransparency = 1
UtilsContentFrame.Visible = moduleStates["VIX | Utils"]
UtilsContentFrame.Parent = ModuleToggleFrame
modulesContainer["VIX | Utils"] = UtilsContentFrame

local UtilsOpenBtn = Instance.new("TextButton")
UtilsOpenBtn.Size = UDim2.new(1, -10, 0, 30)
UtilsOpenBtn.Position = UDim2.new(0, 5, 0, 5)
UtilsOpenBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
UtilsOpenBtn.Text = "Open Utils"
UtilsOpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UtilsOpenBtn.TextScaled = true
UtilsOpenBtn.Parent = UtilsContentFrame
addCorner(UtilsOpenBtn)
UtilsOpenBtn.MouseButton1Click:Connect(function()
    UtilsGui.Visible = true
end)

-- ==================== INIT ====================

Container.Size = UDim2.new(0, 200, 0, 500)

print("VIX Modules Loaded!")
