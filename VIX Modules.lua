--[[ VIX Modules - Unified Mobile GUI ]]
-- Creator: VIXIE

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ============== MAIN GUI CREATION ==============

local MainGui = Instance.new("ScreenGui")
MainGui.Name = "VIX Modules"
MainGui.ResetOnSpawn = false
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGui.Parent = player.PlayerGui

-- Blur Effect for Glass Look
local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 10
BlurEffect.Name = "BlurEffect"

-- ============== HELPER FUNCTIONS ==============

local function addUICorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or UDim.new(0, 10)
    corner.Parent = instance
    return corner
end

local function addStroke(instance, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = thickness or 2
    stroke.Parent = instance
    return stroke
end

local function createGlassFrame(parent, size, pos, bgColor)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = pos
    frame.BackgroundColor3 = bgColor or Color3.fromRGB(40, 40, 40)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = parent
    addUICorner(frame)
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    })
    gradient.Rotation = 45
    gradient.Parent = frame
    
    return frame
end

local function createDraggable(frame, isMobile)
    local dragStart, startPos, dragging
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position
            startPos = frame.Position
            dragging = true
            
            local inputChanged = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    inputChanged:Disconnect()
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                        input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ============== TOGGLE BUTTON (Main Show/Hide) ==============

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.95, -25, 0.5, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ToggleButton.Image = "rbxassetid://6031091004"
ToggleButton.ImageRectOffset = Vector2.new(464, 404)
ToggleButton.ImageRectSize = Vector2.new(36, 36)
ToggleButton.ScaleType = Enum.ScaleType.Fit
ToggleButton.Parent = MainGui
addUICorner(ToggleButton, UDim.new(0.5, 0))
addStroke(ToggleButton, Color3.fromRGB(255, 255, 255), 2)

local modulesVisible = true
local toggleRotation = 0

ToggleButton.MouseButton1Click:Connect(function()
    modulesVisible = not modulesVisible
    
    local targetRotation = modulesVisible and 0 or 180
    
    spawn(function()
        for i = 1, 10 do
            toggleRotation = toggleRotation + (targetRotation - toggleRotation) * 0.3
            ToggleButton.Rotation = toggleRotation
            wait(0.03)
        end
    end)
    
    if not modulesVisible then
        AllModulesFrame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3, true)
        ToggleButton.Position = UDim2.new(0.5, -25, 0.5, -25)
    else
        AllModulesFrame:TweenSize(UDim2.new(0, 200, 0, 0), "Out", "Quad", 0.3, true)
        wait(0.1)
        AllModulesFrame:TweenSize(UDim2.new(0, 200, 0, 500), "Out", "Quad", 0.3, true)
        ToggleButton.Position = UDim2.new(0.95, -25, 0.5, -25)
    end
end)

-- ============== MAIN MODULES FRAME ==============

local AllModulesFrame = Instance.new("Frame")
AllModulesFrame.Name = "AllModulesFrame"
AllModulesFrame.Size = UDim2.new(0, 200, 0, 500)
AllModulesFrame.Position = UDim2.new(0.95, -200, 0.5, -250)
AllModulesFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
AllModulesFrame.BackgroundTransparency = 0.1
AllModulesFrame.BorderSizePixel = 0
AllModulesFrame.Parent = MainGui
addUICorner(AllModulesFrame, UDim.new(0, 15))
addStroke(AllModulesFrame, Color3.fromRGB(100, 50, 50), 2)

local modulesScroll = Instance.new("ScrollingFrame")
modulesScroll.Name = "ModulesScroll"
modulesScroll.Size = UDim2.new(1, 0, 1, 0)
modulesScroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
modulesScroll.ScrollBarThickness = 5
modulesScroll.BackgroundTransparency = 1
modulesScroll.BorderSizePixel = 0
modulesScroll.Parent = AllModulesFrame

local modulesLayout = Instance.new("UIListLayout")
modulesLayout.SortOrder = Enum.SortOrder.LayoutOrder
modulesLayout.Padding = UDim.new(0, 5)
modulesLayout.Parent = modulesScroll

local currentYOffset = 0

local function createModule(name, order)
    local moduleFrame = Instance.new("Frame")
    moduleFrame.Name = name
    moduleFrame.Size = UDim2.new(1, -10, 0, 30)
    moduleFrame.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
    moduleFrame.BackgroundTransparency = 0.2
    moduleFrame.BorderSizePixel = 0
    moduleFrame.LayoutOrder = order
    moduleFrame.Parent = modulesScroll
    addUICorner(moduleFrame, UDim.new(0, 8))
    
    local moduleToggle = Instance.new("TextButton")
    moduleToggle.Name = "Toggle"
    moduleToggle.Size = UDim2.new(0, 25, 0, 25)
    moduleToggle.Position = UDim2.new(1, -30, 0, 2.5)
    moduleToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    moduleToggle.Text = "✓"
    moduleToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    moduleToggle.Font = Enum.Font.GothamBold
    moduleToggle.TextSize = 14
    moduleToggle.Parent = moduleFrame
    addUICorner(moduleToggle, UDim.new(0, 5))
    
    local moduleTitle = Instance.new("TextLabel")
    moduleTitle.Name = "Title"
    moduleTitle.Size = UDim2.new(1, -40, 1, 0)
    moduleTitle.Position = UDim2.new(0, 5, 0, 0)
    moduleTitle.BackgroundTransparency = 1
    moduleTitle.Text = name
    moduleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    moduleTitle.Font = Enum.Font.GothamBold
    moduleTitle.TextSize = 14
    moduleTitle.TextXAlignment = Enum.TextXAlignment.Left
    moduleTitle.Parent = moduleFrame
    
    local moduleContent = Instance.new("Frame")
    moduleContent.Name = "Content"
    moduleContent.Size = UDim2.new(1, -10, 0, 0)
    moduleContent.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    moduleContent.BackgroundTransparency = 0.3
    moduleContent.BorderSizePixel = 0
    moduleContent.LayoutOrder = order + 0.5
    moduleContent.Visible = false
    moduleContent.Parent = modulesScroll
    addUICorner(moduleContent, UDim.new(0, 8))
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 3)
    contentLayout.Parent = moduleContent
    
    local enabled = true
    moduleToggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        moduleToggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        moduleToggle.Text = enabled and "✓" or "✗"
        
        for _, child in pairs(moduleContent:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextBox") then
                child.Visible = enabled
            end
        end
    end)
    
    moduleFrame.MouseButton1Click:Connect(function()
        moduleContent.Visible = not moduleContent.Visible
        
        if moduleContent.Visible then
            moduleContent:TweenSize(UDim2.new(1, -10, 0, 150), "Out", "Quad", 0.2, true)
        else
            moduleContent:TweenSize(UDim2.new(1, -10, 0, 0), "Out", "Quad", 0.2, true)
        end
    end)
    
    return moduleContent
end

-- ============== VFLY MODULE ==============

local VFlyContent = createModule("VIX | VFly", 1)

local Flymguiv2 = Instance.new("ScreenGui")
Flymguiv2.Name = "VFlyGui"
Flymguiv2.Parent = player.PlayerGui
Flymguiv2.ResetOnSpawn = false

local Drag = Instance.new("Frame")
Drag.Name = "Drag"
Drag.Size = UDim2.new(0, 130, 0, 32)
Drag.Position = UDim2.new(0.48, 0, 0.45, 0)
Drag.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Drag.BackgroundTransparency = 0.3
Drag.Active = true
Drag.Parent = Flymguiv2
createDraggable(Drag, true)
addUICorner(Drag)

local FlyFrame = Instance.new("Frame")
FlyFrame.Name = "FlyFrame"
FlyFrame.Size = UDim2.new(0, 130, 0, 90)
FlyFrame.Position = UDim2.new(-0.002, 0, 1.6, 0)
FlyFrame.BackgroundColor3 = Color3.fromRGB(125, 0, 0)
FlyFrame.BackgroundTransparency = 0.3
FlyFrame.Parent = Drag
addUICorner(FlyFrame)

local VflyLabel = Instance.new("TextLabel")
VflyLabel.Name = "VIX | Vfly"
VflyLabel.Size = UDim2.new(0, 57, 0, 27)
VflyLabel.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
VflyLabel.BackgroundTransparency = 0.3
VflyLabel.Text = "VIX | Vfly"
VflyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
VflyLabel.TextScaled = true
VflyLabel.Parent = Drag
addUICorner(VflyLabel)

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 27, 0, 27)
Close.Position = UDim2.new(0.78, 0, 0, 0)
Close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Close.BackgroundTransparency = 0.3
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextScaled = true
Close.Parent = Drag
Close.MouseButton1Click:Connect(function()
    Flymguiv2:Destroy()
end)
addUICorner(Close)

local Minimize = Instance.new("TextButton")
Minimize.Name = "Minimize"
Minimize.Size = UDim2.new(0, 27, 0, 27)
Minimize.Position = UDim2.new(0.55, 0, 0, 0)
Minimize.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Minimize.BackgroundTransparency = 0.3
Minimize.Text = "-"
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.TextScaled = true
Minimize.Parent = Drag
addUICorner(Minimize)

Minimize.MouseButton1Click:Connect(function()
    if Minimize.Text == "-" then
        Minimize.Text = "+"
        FlyFrame.Visible = false
    else
        Minimize.Text = "-"
        FlyFrame.Visible = true
    end
end)

local Speed = Instance.new("TextBox")
Speed.Name = "Speed"
Speed.Size = UDim2.new(1, -5, 0, 30)
Speed.Position = UDim2.new(0, 2.5, 0, 5)
Speed.BackgroundColor3 = Color3.fromRGB(163, 0, 0)
Speed.BackgroundTransparency = 0.3
Speed.Text = "300"
Speed.TextColor3 = Color3.fromRGB(255, 255, 255)
Speed.TextScaled = true
Speed.Parent = FlyFrame
addUICorner(Speed)

local Fly = Instance.new("TextButton")
Fly.Name = "Fly"
Fly.Size = UDim2.new(1, -10, 0, 25)
Fly.Position = UDim2.new(0, 5, 0, 40)
Fly.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Fly.BackgroundTransparency = 0.3
Fly.Text = "Fly ON"
Fly.TextColor3 = Color3.fromRGB(255, 255, 255)
Fly.TextScaled = true
Fly.Parent = FlyFrame
addUICorner(Fly)

local Unfly = Instance.new("TextButton")
Unfly.Name = "Unfly"
Unfly.Size = UDim2.new(1, -10, 0, 25)
Unfly.Position = UDim2.new(0, 5, 0, 40)
Unfly.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
Unfly.BackgroundTransparency = 0.3
Unfly.Text = "Fly OFF"
Unfly.TextColor3 = Color3.fromRGB(255, 255, 255)
Unfly.TextScaled = true
Unfly.Visible = false
Unfly.Parent = FlyFrame
addUICorner(Unfly)

local Stat2 = Instance.new("TextLabel")
Stat2.Name = "Status"
Stat2.Size = UDim2.new(1, -10, 0, 15)
Stat2.Position = UDim2.new(0, 5, 0, 68)
Stat2.BackgroundTransparency = 1
Stat2.Text = "OFF"
Stat2.TextColor3 = Color3.fromRGB(255, 0, 0)
Stat2.TextScaled = true
Stat2.Parent = FlyFrame

local isFlying = false
local isLooping = false
local currentLoopDirection = nil
local loopConnection = nil
local isBoostMode = false

Fly.MouseButton1Click:Connect(function()
    if isFlying then return end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    isFlying = true
    Fly.Visible = false
    Unfly.Visible = true
    Stat2.Text = "ON"
    Stat2.TextColor3 = Color3.fromRGB(0, 255, 0)
    
    local BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.Parent = hrp
    
    local BG = Instance.new("BodyGyro")
    BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    BG.D = 5000
    BG.P = 100000
    BG.Parent = hrp
    
    RunService.RenderStepped:Connect(function()
        if BG and hrp then
            BG.CFrame = workspace.CurrentCamera.CFrame
        end
    end)
end)

Unfly.MouseButton1Click:Connect(function()
    isFlying = false
    Fly.Visible = true
    Unfly.Visible = false
    Stat2.Text = "OFF"
    Stat2.TextColor3 = Color3.fromRGB(255, 0, 0)
    
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, v in pairs(hrp:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                v:Destroy()
            end
        end
    end
end)

-- Add VFly to module
local VFlyStatus = Instance.new("TextLabel")
VFlyStatus.Name = "VFly Status"
VFlyStatus.Size = UDim2.new(1, -10, 0, 20)
VFlyStatus.BackgroundTransparency = 1
VFlyStatus.Text = "VFLY Module: " .. (isFlying and "Active" or "Inactive")
VFlyStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
VFlyStatus.TextScaled = true
VFlyStatus.Parent = VFlyContent

local VFlyOpen = Instance.new("TextButton")
VFlyOpen.Name = "Open VFly"
VFlyOpen.Size = UDim2.new(1, -10, 0, 30)
VFlyOpen.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
VFlyOpen.BackgroundTransparency = 0.3
VFlyOpen.Text = "Open VFly"
VFlyOpen.TextColor3 = Color3.fromRGB(255, 255, 255)
VFlyOpen.TextScaled = true
VFlyOpen.Parent = VFlyContent
addUICorner(VFlyOpen)
VFlyOpen.MouseButton1Click:Connect(function()
    Drag.Visible = true
end)

-- ============== NOCLIP MODULE ==============

local NoclipContent = createModule("VIX | Clips", 2)

local noclip = false
local autoNoclipEnabled = false
local invincibilityToggled = false

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

local NoclipStatus = Instance.new("TextLabel")
NoclipStatus.Size = UDim2.new(1, -10, 0, 20)
NoclipStatus.BackgroundTransparency = 1
NoclipStatus.Text = "NoClip: OFF"
NoclipStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipStatus.TextScaled = true
NoclipStatus.Parent = NoclipContent

local NoclipOn = Instance.new("TextButton")
NoclipOn.Size = UDim2.new(0.45, -3, 0, 35)
NoclipOn.Position = UDim2.new(0, 5, 0, 25)
NoclipOn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
NoclipOn.BackgroundTransparency = 0.3
NoclipOn.Text = "NOCLIP"
NoclipOn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipOn.TextScaled = true
NoclipOn.Parent = NoclipContent
addUICorner(NoclipOn)

local NoclipOff = Instance.new("TextButton")
NoclipOff.Size = UDim2.new(0.45, -3, 0, 35)
NoclipOff.Position = UDim2.new(0.5, 0, 0, 25)
NoclipOff.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
NoclipOff.BackgroundTransparency = 0.3
NoclipOff.Text = "RECLIP"
NoclipOff.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipOff.TextScaled = true
NoclipOff.Parent = NoclipContent
addUICorner(NoclipOff)

local AutoToggle = Instance.new("TextButton")
AutoToggle.Size = UDim2.new(0.45, -3, 0, 30)
AutoToggle.Position = UDim2.new(0, 5, 0, 65)
AutoToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 0)
AutoToggle.BackgroundTransparency = 0.3
AutoToggle.Text = "AUTO: OFF"
AutoToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoToggle.TextScaled = true
AutoToggle.Parent = NoclipContent
addUICorner(AutoToggle)

local InvisToggle = Instance.new("TextButton")
InvisToggle.Size = UDim2.new(0.45, -3, 0, 30)
InvisToggle.Position = UDim2.new(0.5, 0, 0, 65)
InvisToggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
InvisToggle.BackgroundTransparency = 0.3
InvisToggle.Text = "INVIS"
InvisToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
InvisToggle.TextScaled = true
InvisToggle.Parent = NoclipContent
addUICorner(InvisToggle)

NoclipOn.MouseButton1Click:Connect(function()
    setNoclip(true)
    NoclipStatus.Text = "NoClip: ON"
    NoclipStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
end)

NoclipOff.MouseButton1Click:Connect(function()
    setNoclip(false)
    NoclipStatus.Text = "NoClip: OFF"
    NoclipStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

AutoToggle.MouseButton1Click:Connect(function()
    autoNoclipEnabled = not autoNoclipEnabled
    AutoToggle.Text = "AUTO: " .. (autoNoclipEnabled and "ON" or "OFF")
    AutoToggle.BackgroundColor3 = autoNoclipEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 80, 0)
end)

InvisToggle.MouseButton1Click:Connect(function()
    invincibilityToggled = not invincibilityToggled
    local char = player.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanTouch = not invincibilityToggled
            end
        end
    end
    InvisToggle.BackgroundColor3 = invincibilityToggled and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
    InvisToggle.Text = invincibilityToggled and "INVIS ON" or "INVIS"
end)

spawn(function()
    while wait(1) do
        if autoNoclipEnabled then
            setNoclip(true)
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    if noclip or autoNoclipEnabled then
        wait(0.5)
        setNoclip(true)
    end
end)

-- ============== PLATE MODULE (Enhanced) ==============

local PlateContent = createModule("VIX | Plate", 3)

local createdObjects = {}

local function addRedBorder(part)
    local topSurface = Instance.new("SurfaceGui", part)
    topSurface.Face = Enum.NormalId.Top
    local border = Instance.new("Frame", topSurface)
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundTransparency = 1
    local uiStroke = Instance.new("UIStroke", border)
    uiStroke.Color = Color3.fromRGB(255, 0, 0)
    uiStroke.Thickness = 4
end

local PlateStatus = Instance.new("TextLabel")
PlateStatus.Size = UDim2.new(1, -10, 0, 20)
PlateStatus.BackgroundTransparency = 1
PlateStatus.Text = "Create platforms and stairs"
PlateStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
PlateStatus.TextScaled = true
PlateStatus.Parent = PlateContent

local PlateRow1 = Instance.new("Frame")
PlateRow1.Size = UDim2.new(1, -10, 0, 30)
PlateRow1.BackgroundTransparency = 1
PlateRow1.Parent = PlateContent

local PlateRow2 = Instance.new("Frame")
PlateRow2.Size = UDim2.new(1, -10, 0, 30)
PlateRow2.BackgroundTransparency = 1
PlateRow2.Parent = PlateContent

local PlateRow3 = Instance.new("Frame")
PlateRow3.Size = UDim2.new(1, -10, 0, 30)
PlateRow3.BackgroundTransparency = 1
PlateRow3.Parent = PlateContent

local function createPlateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.3, -2, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Parent = parent
    addUICorner(btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createPlateButton(PlateRow1, "Up /", function()
    for i = 1, 50 do
        local part = Instance.new("Part", workspace)
        part.Size = Vector3.new(5, 0.5, 2)
        part.CFrame = (player.Character.HumanoidRootPart.CFrame * CFrame.new(0, i * 0.5 - 3.5, -i * 0.5))
        part.Transparency = 0.8
        part.Anchored = true
        part.BrickColor = BrickColor.new("Bright red")
        addRedBorder(part)
        table.insert(createdObjects, part)
    end
end)

createPlateButton(PlateRow1, "Down \\", function()
    for i = 1, 50 do
        local part = Instance.new("Part", workspace)
        part.Size = Vector3.new(5, 0.5, 2)
        part.CFrame = (player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -i * 0.5 - 3.5, -i * 0.5))
        part.Transparency = 0.8
        part.Anchored = true
        part.BrickColor = BrickColor.new("Bright red")
        addRedBorder(part)
        table.insert(createdObjects, part)
    end
end)

createPlateButton(PlateRow1, "Small", function()
    local part = Instance.new("Part", workspace)
    part.Size = Vector3.new(15, 1, 15)
    part.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)
    part.Transparency = 0.8
    part.Anchored = true
    part.BrickColor = BrickColor.new("Bright red")
    addRedBorder(part)
    table.insert(createdObjects, part)
end)

createPlateButton(PlateRow2, "Big", function()
    local part = Instance.new("Part", workspace)
    part.Size = Vector3.new(40, 1, 40)
    part.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)
    part.Transparency = 0.8
    part.Anchored = true
    part.BrickColor = BrickColor.new("Bright red")
    addRedBorder(part)
    table.insert(createdObjects, part)
end)

createPlateButton(PlateRow2, "H-Stairs", function()
    for i = 1, 50 do
        local part = Instance.new("Part", workspace)
        part.Size = Vector3.new(5, 0.5, 2)
        part.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(i * 0.5 - 3.5, 0, -i * 0.5)
        part.Transparency = 0.8
        part.Anchored = true
        part.BrickColor = BrickColor.new("Bright red")
        addRedBorder(part)
        table.insert(createdObjects, part)
    end
end)

createPlateButton(PlateRow2, "V-Stairs", function()
    for i = 1, 15 do
        local part = Instance.new("Part", workspace)
        part.Size = Vector3.new(5, 0.5, 5)
        part.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2 - 3.5, 0)
        part.Transparency = 0.8
        part.Anchored = true
        part.BrickColor = BrickColor.new("Bright red")
        addRedBorder(part)
        table.insert(createdObjects, part)
        if i ~= 15 then
            part.Size = Vector3.new(5, 5, 5)
            delay(0.8, function()
                if part then part:Destroy() end
            end)
        end
        wait(0.4)
    end
end)

-- NEW: Huge platforms + Boxes
createPlateButton(PlateRow3, "Huge", function()
    local part = Instance.new("Part", workspace)
    part.Size = Vector3.new(100, 1, 100)
    part.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)
    part.Transparency = 0.8
    part.Anchored = true
    part.BrickColor = BrickColor.new("Bright red")
    addRedBorder(part)
    table.insert(createdObjects, part)
end)

createPlateButton(PlateRow3, "Giant", function()
    local part = Instance.new("Part", workspace)
    part.Size = Vector3.new(300, 1, 300)
    part.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)
    part.Transparency = 0.8
    part.Anchored = true
    part.BrickColor = BrickColor.new("Bright red")
    addRedBorder(part)
    table.insert(createdObjects, part)
end)

createPlateButton(PlateRow3, "Clear", function()
    for _, obj in ipairs(createdObjects) do
        if obj then obj:Destroy() end
    end
    createdObjects = {}
end)

-- NEW: Box creation system
local BoxRow = Instance.new("Frame")
BoxRow.Size = UDim2.new(1, -10, 0, 30)
BoxRow.BackgroundTransparency = 1
BoxRow.Parent = PlateContent

createPlateButton(BoxRow, "Box S", function()
    local hrp = player.Character.HumanoidRootPart
    local size = 100
    
    local function createBoxPart(pos, sizeVec)
        local part = Instance.new("Part", workspace)
        part.Size = sizeVec
        part.CFrame = hrp.CFrame * CFrame.new(pos)
        part.Transparency = 0.7
        part.Anchored = true
        part.BrickColor = BrickColor.new("Bright red")
        addRedBorder(part)
        table.insert(createdObjects, part)
        return part
    end
    
    -- Floor
    createBoxPart(Vector3.new(0, -size/2 - 0.5, 0), Vector3.new(size, 1, size))
    -- Ceiling
    createBoxPart(Vector3.new(0, size/2 + 0.5, 0), Vector3.new(size, 1, size))
    -- Walls
    createBoxPart(Vector3.new(0, 0, size/2 + 0.5), Vector3.new(size, size, 1))
    createBoxPart(Vector3.new(0, 0, -size/2 - 0.5), Vector3.new(size, size, 1))
    createBoxPart(Vector3.new(size/2 + 0.5, 0, 0), Vector3.new(1, size, size))
    createBoxPart(Vector3.new(-size/2 - 0.5, 0, 0), Vector3.new(1, size, size))
end)

createPlateButton(BoxRow, "Box M", function()
    local hrp = player.Character.HumanoidRootPart
    local size = 300
    
    local function createBoxPart(pos, sizeVec)
        local part = Instance.new("Part", workspace)
        part.Size = sizeVec
        part.CFrame = hrp.CFrame * CFrame.new(pos)
        part.Transparency = 0.7
        part.Anchored = true
        part.BrickColor = BrickColor.new("Bright red")
        addRedBorder(part)
        table.insert(createdObjects, part)
        return part
    end
    
    createBoxPart(Vector3.new(0, -size/2 - 0.5, 0), Vector3.new(size, 1, size))
    createBoxPart(Vector3.new(0, size/2 + 0.5, 0), Vector3.new(size, 1, size))
    createBoxPart(Vector3.new(0, 0, size/2 + 0.5), Vector3.new(size, size, 1))
    createBoxPart(Vector3.new(0, 0, -size/2 - 0.5), Vector3.new(size, size, 1))
    createBoxPart(Vector3.new(size/2 + 0.5, 0, 0), Vector3.new(1, size, size))
    createBoxPart(Vector3.new(-size/2 - 0.5, 0, 0), Vector3.new(1, size, size))
end)

createPlateButton(BoxRow, "Box L", function()
    local hrp = player.Character.HumanoidRootPart
    local size = 3000
    
    local function createBoxPart(pos, sizeVec)
        local part = Instance.new("Part", workspace)
        part.Size = sizeVec
        part.CFrame = hrp.CFrame * CFrame.new(pos)
        part.Transparency = 0.7
        part.Anchored = true
        part.BrickColor = BrickColor.new("Bright red")
        addRedBorder(part)
        table.insert(createdObjects, part)
        return part
    end
    
    createBoxPart(Vector3.new(0, -size/2 - 0.5, 0), Vector3.new(size, 1, size))
    createBoxPart(Vector3.new(0, size/2 + 0.5, 0), Vector3.new(size, 1, size))
    createBoxPart(Vector3.new(0, 0, size/2 + 0.5), Vector3.new(size, size, 1))
    createBoxPart(Vector3.new(0, 0, -size/2 - 0.5), Vector3.new(size, size, 1))
    createBoxPart(Vector3.new(size/2 + 0.5, 0, 0), Vector3.new(1, size, size))
    createBoxPart(Vector3.new(-size/2 - 0.5, 0, 0), Vector3.new(1, size, size))
end)

-- ============== RECTP MODULE ==============

local RecTPContent = createModule("VIX | RecTP", 4)

local isRecording = false
local points = {}
local teleportDelay = 1
local autoTeleport = false
local cycleEnabled = false

local RecTPStatus = Instance.new("TextLabel")
RecTPStatus.Size = UDim2.new(1, -10, 0, 20)
RecTPStatus.BackgroundTransparency = 1
RecTPStatus.Text = "Record & Teleport"
RecTPStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
RecTPStatus.TextScaled = true
RecTPStatus.Parent = RecTPContent

local RecTPRow1 = Instance.new("Frame")
RecTPRow1.Size = UDim2.new(1, -10, 0, 30)
RecTPRow1.BackgroundTransparency = 1
RecTPRow1.Parent = RecTPContent

local RecTPRow2 = Instance.new("Frame")
RecTPRow2.Size = UDim2.new(1, -10, 0, 30)
RecTPRow2.BackgroundTransparency = 1
RecTPRow2.Parent = RecTPContent

local function createRecTPButton(parent, text, callback, bgColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.3, -2, 1, 0)
    btn.BackgroundColor3 = bgColor or Color3.fromRGB(150, 0, 0)
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Parent = parent
    addUICorner(btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local RecordBtn = nil
createRecTPButton(RecTPRow1, "Rec", function()
    isRecording = not isRecording
    RecordBtn = RecTPRow1:FindFirstChild("Rec")
    if RecordBtn then
        RecordBtn.Text = isRecording and "Stop" or "Rec"
        RecordBtn.BackgroundColor3 = isRecording and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(150, 0, 0)
    end
end)

createRecTPButton(RecTPRow1, "+", function()
    if isRecording then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            table.insert(points, hrp.Position)
        end
    end
end)

createRecTPButton(RecTPRow1, "-", function()
    table.remove(points)
end)

createRecTPButton(RecTPRow2, "Play", function()
    autoTeleport = true
    for _, point in ipairs(points) do
        if autoTeleport and player.Character then
            player.Character:SetPrimaryPartCFrame(CFrame.new(point))
            wait(teleportDelay)
        end
    end
    if cycleEnabled then
        spawn(function()
            while cycleEnabled and autoTeleport do
                wait(1)
                for _, point in ipairs(points) do
                    if autoTeleport and player.Character then
                        player.Character:SetPrimaryPartCFrame(CFrame.new(point))
                        wait(teleportDelay)
                    end
                end
            end
        end)
    end
end)

createRecTPButton(RecTPRow2, "Stop", function()
    autoTeleport = false
end)

createRecTPButton(RecTPRow2, "Loop", function()
    cycleEnabled = not cycleEnabled
end)

local DelayInput = Instance.new("TextBox")
DelayInput.Size = UDim2.new(1, -10, 0, 25)
DelayInput.Position = UDim2.new(0, 5, 0, 65)
DelayInput.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
DelayInput.BackgroundTransparency = 0.3
DelayInput.Text = "1"
DelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayInput.TextScaled = true
DelayInput.Parent = RecTPContent
addUICorner(DelayInput)
DelayInput.FocusLost:Connect(function()
    local val = tonumber(DelayInput.Text)
    if val then teleportDelay = val end
end)

local RandTeleportBtn = Instance.new("TextButton")
RandTeleportBtn.Size = UDim2.new(1, -10, 0, 30)
RandTeleportBtn.Position = UDim2.new(0, 5, 0, 95)
RandTeleportBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
RandTeleportBtn.BackgroundTransparency = 0.3
RandTeleportBtn.Text = "Random TP"
RandTeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RandTeleportBtn.TextScaled = true
RandTeleportBtn.Parent = RecTPContent
addUICorner(RandTeleportBtn)
RandTeleportBtn.MouseButton1Click:Connect(function()
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

-- ============== SPEEDS MODULE ==============

local SpeedsContent = createModule("VIX | Speeds", 5)

local initialSpeed = 16
local initialJumpPower = 50
local currentSpeed = initialSpeed
local currentJumpPower = initialJumpPower
local savedSpeed = initialSpeed
local savedJumpPower = initialJumpPower
local targetSpeed = initialSpeed
local targetJumpPower = initialJumpPower
local isCustomSpeed = false

local SpeedStatus = Instance.new("TextLabel")
SpeedStatus.Size = UDim2.new(1, -10, 0, 20)
SpeedStatus.BackgroundTransparency = 1
SpeedStatus.Text = "Speed: " .. initialSpeed
SpeedStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedStatus.TextScaled = true
SpeedStatus.Parent = SpeedsContent

local SpeedInput = Instance.new("TextBox")
SpeedInput.Size = UDim2.new(1, -10, 0, 30)
SpeedInput.Position = UDim2.new(0, 5, 0, 25)
SpeedInput.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
SpeedInput.BackgroundTransparency = 0.3
SpeedInput.Text = "25"
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.TextScaled = true
SpeedInput.Parent = SpeedsContent
addUICorner(SpeedInput)

local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(1, -10, 0, 30)
SpeedBtn.Position = UDim2.new(0, 5, 0, 60)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
SpeedBtn.BackgroundTransparency = 0.3
SpeedBtn.Text = "Set Speed"
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBtn.TextScaled = true
SpeedBtn.Parent = SpeedsContent
addUICorner(SpeedBtn)

local ResetSpeedBtn = Instance.new("TextButton")
ResetSpeedBtn.Size = UDim2.new(1, -10, 0, 25)
ResetSpeedBtn.Position = UDim2.new(0, 5, 0, 95)
ResetSpeedBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 0)
ResetSpeedBtn.BackgroundTransparency = 0.3
ResetSpeedBtn.Text = "Reset"
ResetSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetSpeedBtn.TextScaled = true
ResetSpeedBtn.Parent = SpeedsContent
addUICorner(ResetSpeedBtn)

SpeedBtn.MouseButton1Click:Connect(function()
    local speedValue = tonumber(SpeedInput.Text) or 25
    if speedValue < initialSpeed then speedValue = 25 end
    
    if isCustomSpeed then
        targetSpeed = initialSpeed
        targetJumpPower = initialJumpPower
        isCustomSpeed = false
        SpeedBtn.Text = "Set Speed"
    else
        savedSpeed = currentSpeed
        savedJumpPower = currentJumpPower
        targetSpeed = speedValue
        targetJumpPower = initialJumpPower + speedValue / 1.5
        isCustomSpeed = true
        SpeedBtn.Text = "Reset"
    end
end)

ResetSpeedBtn.MouseButton1Click:Connect(function()
    targetSpeed = initialSpeed
    targetJumpPower = initialJumpPower
    isCustomSpeed = false
    SpeedBtn.Text = "Set Speed"
end)

spawn(function()
    while wait() do
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = isCustomSpeed and targetSpeed or savedSpeed
            humanoid.JumpPower = isCustomSpeed and targetJumpPower or savedJumpPower
            currentSpeed = humanoid.WalkSpeed
            currentJumpPower = humanoid.JumpPower
            SpeedStatus.Text = "Speed: " .. math.floor(humanoid.WalkSpeed)
        end
    end
end)

-- ============== TPSAVE MODULE ==============

local TPSaveContent = createModule("VIX | TPSave", 6)

local savedPosition = nil
local autoTeleportEnabled = false

local TPSaveStatus = Instance.new("TextLabel")
TPSaveStatus.Size = UDim2.new(1, -10, 0, 20)
TPSaveStatus.BackgroundTransparency = 1
TPSaveStatus.Text = "Save & Teleport Position"
TPSaveStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
TPSaveStatus.TextScaled = true
TPSaveStatus.Parent = TPSaveContent

local TPSaveRow = Instance.new("Frame")
TPSaveRow.Size = UDim2.new(1, -10, 0, 30)
TPSaveRow.BackgroundTransparency = 1
TPSaveRow.Parent = TPSaveContent

local TPSaveBtn = Instance.new("TextButton")
TPSaveBtn.Size = UDim2.new(0.45, -3, 1, 0)
TPSaveBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
TPSaveBtn.BackgroundTransparency = 0.3
TPSaveBtn.Text = "Save"
TPSaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TPSaveBtn.TextScaled = true
TPSaveBtn.Parent = TPSaveRow
addUICorner(TPSaveBtn)

local TPTeleportBtn = Instance.new("TextButton")
TPTeleportBtn.Size = UDim2.new(0.45, -3, 1, 0)
TPTeleportBtn.Position = UDim2.new(0.5, 0, 0, 0)
TPTeleportBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
TPTeleportBtn.BackgroundTransparency = 0.3
TPTeleportBtn.Text = "Teleport"
TPTeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TPTeleportBtn.TextScaled = true
TPTeleportBtn.Parent = TPSaveRow
addUICorner(TPTeleportBtn)

local TPAutoBtn = Instance.new("TextButton")
TPAutoBtn.Size = UDim2.new(1, -10, 0, 30)
TPAutoBtn.Position = UDim2.new(0, 5, 0, 35)
TPAutoBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 0)
TPAutoBtn.BackgroundTransparency = 0.3
TPAutoBtn.Text = "Auto: OFF"
TPAutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TPAutoBtn.TextScaled = true
TPAutoBtn.Parent = TPSaveContent
addUICorner(TPAutoBtn)

TPSaveBtn.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        savedPosition = hrp.Position
        TPSaveStatus.Text = "Position Saved!"
    end
end)

TPTeleportBtn.MouseButton1Click:Connect(function()
    if savedPosition and player.Character then
        player.Character:SetPrimaryPartCFrame(CFrame.new(savedPosition))
    end
end)

TPAutoBtn.MouseButton1Click:Connect(function()
    autoTeleportEnabled = not autoTeleportEnabled
    TPAutoBtn.Text = "Auto: " .. (autoTeleportEnabled and "ON" or "OFF")
    TPAutoBtn.BackgroundColor3 = autoTeleportEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 80, 0)
end)

spawn(function()
    while wait(1) do
        if autoTeleportEnabled and savedPosition and player.Character then
            player.Character:SetPrimaryPartCFrame(CFrame.new(savedPosition))
        end
    end
end)

-- ============== UTILS MODULE ==============

local UtilsContent = createModule("VIX | Utils", 7)

-- FullBright & DarkMode
local originalAmbient = Lighting.Ambient
local originalOutdoorAmbient = Lighting.OutdoorAmbient
local originalBrightness = Lighting.Brightness
local originalFogEnd = Lighting.FogEnd
local originalFogColor = Lighting.FogColor

local fullbrightEnabled = false
local darkmodeEnabled = false
local fullbrightLoop = nil
local darkmodeLoop = nil

local UtilsStatus = Instance.new("TextLabel")
UtilsStatus.Size = UDim2.new(1, -10, 0, 20)
UtilsStatus.BackgroundTransparency = 1
UtilsStatus.Text = "Various Utilities"
UtilsStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
UtilsStatus.TextScaled = true
UtilsStatus.Parent = UtilsContent

local UtilsRow1 = Instance.new("Frame")
UtilsRow1.Size = UDim2.new(1, -10, 0, 30)
UtilsRow1.BackgroundTransparency = 1
UtilsRow1.Parent = UtilsContent

local FullBrightBtn = Instance.new("TextButton")
FullBrightBtn.Size = UDim2.new(0.45, -3, 1, 0)
FullBrightBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 0)
FullBrightBtn.BackgroundTransparency = 0.3
FullBrightBtn.Text = "FullBright"
FullBrightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FullBrightBtn.TextScaled = true
FullBrightBtn.Parent = UtilsRow1
addUICorner(FullBrightBtn)

local DarkModeBtn = Instance.new("TextButton")
DarkModeBtn.Size = UDim2.new(0.45, -3, 1, 0)
DarkModeBtn.Position = UDim2.new(0.5, 0, 0, 0)
DarkModeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
DarkModeBtn.BackgroundTransparency = 0.3
DarkModeBtn.Text = "DarkMode"
DarkModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DarkModeBtn.TextScaled = true
DarkModeBtn.Parent = UtilsRow1
addUICorner(DarkModeBtn)

FullBrightBtn.MouseButton1Click:Connect(function()
    fullbrightEnabled = not fullbrightEnabled
    if fullbrightEnabled then
        if darkmodeEnabled then
            darkmodeEnabled = false
            if darkmodeLoop then darkmodeLoop:Disconnect() end
        end
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.FogEnd = 100000
        Lighting.ClockTime = 12
        FullBrightBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 0)
    else
        Lighting.Ambient = originalAmbient
        Lighting.OutdoorAmbient = originalOutdoorAmbient
        Lighting.Brightness = originalBrightness
        FullBrightBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 0)
    end
end)

DarkModeBtn.MouseButton1Click:Connect(function()
    darkmodeEnabled = not darkmodeEnabled
    if darkmodeEnabled then
        if fullbrightEnabled then
            fullbrightEnabled = false
            if fullbrightLoop then fullbrightLoop:Disconnect() end
        end
        Lighting.Ambient = Color3.new(0, 0, 0)
        Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        Lighting.Brightness = 0
        Lighting.FogEnd = 10
        Lighting.FogColor = Color3.new(0, 0, 0)
        DarkModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    else
        Lighting.Ambient = originalAmbient
        Lighting.OutdoorAmbient = originalOutdoorAmbient
        Lighting.Brightness = originalBrightness
        Lighting.FogEnd = originalFogEnd
        Lighting.FogColor = originalFogColor
        DarkModeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    end
end)

-- Gravity Controls
local UtilsRow2 = Instance.new("Frame")
UtilsRow2.Size = UDim2.new(1, -10, 0, 30)
UtilsRow2.BackgroundTransparency = 1
UtilsRow2.Parent = UtilsContent

local GravityLabel = Instance.new("TextLabel")
GravityLabel.Size = UDim2.new(1, -10, 1, 0)
GravityLabel.BackgroundTransparency = 1
GravityLabel.Text = "Gravity: " .. math.floor(workspace.Gravity)
GravityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GravityLabel.TextScaled = true
GravityLabel.Parent = UtilsRow2

local UtilsRow3 = Instance.new("Frame")
UtilsRow3.Size = UDim2.new(1, -10, 0, 30)
UtilsRow3.BackgroundTransparency = 1
UtilsRow3.Parent = UtilsContent

local GravMinus = Instance.new("TextButton")
GravMinus.Size = UDim2.new(0.3, -2, 1, 0)
GravMinus.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
GravMinus.BackgroundTransparency = 0.3
GravMinus.Text = "-10"
GravMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
GravMinus.TextScaled = true
GravMinus.Parent = UtilsRow3
addUICorner(GravMinus)

local GravReset = Instance.new("TextButton")
GravReset.Size = UDim2.new(0.3, -2, 1, 0)
GravReset.Position = UDim2.new(0.35, 0, 0, 0)
GravReset.BackgroundColor3 = Color3.fromRGB(100, 100, 0)
GravReset.BackgroundTransparency = 0.3
GravReset.Text = "Reset"
GravReset.TextColor3 = Color3.fromRGB(255, 255, 255)
GravReset.TextScaled = true
GravReset.Parent = UtilsRow3
addUICorner(GravReset)

local GravPlus = Instance.new("TextButton")
GravPlus.Size = UDim2.new(0.3, -2, 1, 0)
GravPlus.Position = UDim2.new(0.7, 0, 0, 0)
GravPlus.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
GravPlus.BackgroundTransparency = 0.3
GravPlus.Text = "+10"
GravPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
GravPlus.TextScaled = true
GravPlus.Parent = UtilsRow3
addUICorner(GravPlus)

GravMinus.MouseButton1Click:Connect(function()
    workspace.Gravity = math.max(0, workspace.Gravity - 10)
    GravityLabel.Text = "Gravity: " .. math.floor(workspace.Gravity)
end)

GravReset.MouseButton1Click:Connect(function()
    workspace.Gravity = 196.2
    GravityLabel.Text = "Gravity: 196.2"
end)

GravPlus.MouseButton1Click:Connect(function()
    workspace.Gravity = workspace.Gravity + 10
    GravityLabel.Text = "Gravity: " .. math.floor(workspace.Gravity)
end)

-- X-Ray
local XRayRow = Instance.new("Frame")
XRayRow.Size = UDim2.new(1, -10, 0, 30)
XRayRow.BackgroundTransparency = 1
XRayRow.Parent = UtilsContent

local XRayBtn = Instance.new("TextButton")
XRayBtn.Size = UDim2.new(0.45, -3, 1, 0)
XRayBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
XRayBtn.BackgroundTransparency = 0.3
XRayBtn.Text = "X-Ray"
XRayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
XRayBtn.TextScaled = true
XRayBtn.Parent = XRayRow
addUICorner(XRayBtn)

local XRayResetBtn = Instance.new("TextButton")
XRayResetBtn.Size = UDim2.new(0.45, -3, 1, 0)
XRayResetBtn.Position = UDim2.new(0.5, 0, 0, 0)
XRayResetBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
XRayResetBtn.BackgroundTransparency = 0.3
XRayResetBtn.Text = "Reset"
XRayResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
XRayResetBtn.TextScaled = true
XRayResetBtn.Parent = XRayRow
addUICorner(XRayResetBtn)

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

XRayBtn.MouseButton1Click:Connect(function()
    xRayEnabled = not xRayEnabled
    if xRayEnabled then
        updateXRayObjects()
        for part, trans in pairs(xRayObjects) do
            if part and part.Parent then
                part.Transparency = 0.7
            end
        end
        XRayBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    else
        for part, trans in pairs(xRayObjects) do
            if part and part.Parent then
                part.Transparency = trans
            end
        end
        XRayBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

XRayResetBtn.MouseButton1Click:Connect(function()
    for part, trans in pairs(xRayObjects) do
        if part and part.Parent then
            part.Transparency = trans
        end
    end
    xRayEnabled = false
    XRayBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

-- ============== INITIALIZATION ==============

-- Start with modules visible
AllModulesFrame.Size = UDim2.new(0, 200, 0, 500)

print("VIX Modules Loaded!")
