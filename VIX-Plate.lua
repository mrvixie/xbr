local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Header = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local HideButton = Instance.new("TextButton")
local ButtonsFrame = Instance.new("Frame")
local GlassBackground = Instance.new("Frame")

local createdObjects = {}
local platform = nil
local stairsModel = nil

local function makeCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
end

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

ScreenGui.Name = "VIX Plate"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 50)
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.BackgroundTransparency = 1

GlassBackground.Name = "GlassBackground"
GlassBackground.Parent = MainFrame
GlassBackground.Size = UDim2.new(1, 0, 1, 0)
GlassBackground.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
GlassBackground.BackgroundTransparency = 0.2
makeCorner(GlassBackground, 12)

local bgGradient = Instance.new("UIGradient", GlassBackground)
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 0, 0))
})
bgGradient.Rotation = 90

local bgStroke = Instance.new("UIStroke", GlassBackground)
bgStroke.Color = Color3.fromRGB(255, 40, 40)
bgStroke.Thickness = 1.5
bgStroke.Transparency = 0.6

Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(90, 0, 0)
Header.Size = UDim2.new(0, 80, 1, -10)
Header.Position = UDim2.new(1, -85, 0, 5)
Header.BackgroundTransparency = 0.3
makeCorner(Header, 8)

local headerGradient = Instance.new("UIGradient", Header)
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 0, 0))
})
headerGradient.Rotation = 90

local headerStroke = Instance.new("UIStroke", Header)
headerStroke.Color = Color3.fromRGB(255, 60, 60)
headerStroke.Thickness = 1
headerStroke.Transparency = 0.5

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        MainFrame.Draggable = true
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        MainFrame.Draggable = false
    end
end)

local buttonColor = Color3.fromRGB(170, 0, 0)
local buttonHoverColor = Color3.fromRGB(200, 0, 0)
local textColor = Color3.fromRGB(255, 255, 255)

CloseButton.Name = "CloseButton"
CloseButton.Parent = Header
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Position = UDim2.new(0.5, -16, 0.5, -16)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
CloseButton.TextColor3 = textColor
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 16
CloseButton.AutoButtonColor = true
makeCorner(CloseButton, 6)

local closeStroke = Instance.new("UIStroke", CloseButton)
closeStroke.Color = Color3.fromRGB(255, 80, 80)
closeStroke.Thickness = 1

HideButton.Name = "HideButton"
HideButton.Parent = Header
HideButton.Size = UDim2.new(0, 32, 0, 32)
HideButton.Position = UDim2.new(0.5, -48, 0.5, -16)
HideButton.BackgroundColor3 = Color3.fromRGB(130, 0, 0)
HideButton.TextColor3 = textColor
HideButton.Text = "<"
HideButton.Font = Enum.Font.SourceSansBold
HideButton.TextSize = 16
HideButton.AutoButtonColor = true
makeCorner(HideButton, 6)

local hideStroke = Instance.new("UIStroke", HideButton)
hideStroke.Color = Color3.fromRGB(255, 80, 80)
hideStroke.Thickness = 1

ButtonsFrame.Name = "ButtonsFrame"
ButtonsFrame.Parent = MainFrame
ButtonsFrame.Size = UDim2.new(1, -95, 1, -10)
ButtonsFrame.Position = UDim2.new(0, 5, 0, 5)
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.ClipsDescendants = true

local function createSquareButton(parent, name, text, posX)
    local btn = Instance.new("TextButton", parent)
    btn.Name = name
    btn.Size = UDim2.new(0, 36, 0, 36)
    btn.Position = UDim2.new(0, posX, 0.5, -18)
    btn.BackgroundColor3 = buttonColor
    btn.TextColor3 = textColor
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.TextWrapped = true
    btn.AutoButtonColor = true
    makeCorner(btn, 6)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(255, 50, 50)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.6
    
    return btn
end

local btn1 = createSquareButton(ButtonsFrame, "UpStairs", "/", 5)
local btn2 = createSquareButton(ButtonsFrame, "DownStairs", "\\", 46)
local btn3 = createSquareButton(ButtonsFrame, "Platform", "[]", 87)
local btn4 = createSquareButton(ButtonsFrame, "BigPlatform", "[>]", 128)
local btn5 = createSquareButton(ButtonsFrame, "Clear", "CLR", 169)

local function createStairsPath(direction)
    if stairsModel then
        stairsModel:Destroy()
        stairsModel = nil
        return
    end
    
    stairsModel = Instance.new("Model", workspace)
    
    local part = Instance.new("Part", stairsModel)
    part.Name = "StairsPath"
    part.Size = Vector3.new(5, 0.5, 8)
    part.Transparency = 0.7
    part.Anchored = true
    part.BrickColor = BrickColor.new("Bright red")
    addRedBorder(part)
    
    local startCF = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    local distance = 200
    local heightOffset = distance * math.tan(math.rad(45)) * direction
    local endPos = startCF.Position + startCF.LookVector * distance + Vector3.new(0, heightOffset, 0)
    
    part.Size = Vector3.new(5, 0.5, distance + 10)
    part.CFrame = CFrame.lookAt(startCF.Position + Vector3.new(0, -3.5, 0), endPos) * CFrame.Angles(math.rad(90), 0, math.rad(45 * direction))
end

local function createPlatform(size)
    if platform then
        platform:Destroy()
        platform = nil
        return
    end
    
    platform = Instance.new("Part", workspace)
    platform.Size = size == "big" and Vector3.new(40, 1, 40) or Vector3.new(15, 1, 15)
    platform.Anchored = true
    platform.BrickColor = BrickColor.new("Bright red")
    platform.Transparency = 0.7
    addRedBorder(platform)
    
    local runService = game:GetService("RunService")
    local connection
    
    connection = runService.Heartbeat:Connect(function()
        if platform and game.Players.LocalPlayer.Character then
            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
            platform.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3.5, hrp.Position.Z)
        else
            connection:Disconnect()
        end
    end)
end

local function clearAll()
    if platform then
        platform:Destroy()
        platform = nil
    end
    if stairsModel then
        stairsModel:Destroy()
        stairsModel = nil
    end
    for _, obj in ipairs(createdObjects) do
        if obj then
            obj:Destroy()
        end
    end
    createdObjects = {}
end

btn1.MouseButton1Click:Connect(function()
    createStairsPath(1)
end)

btn2.MouseButton1Click:Connect(function()
    createStairsPath(-1)
end)

btn3.MouseButton1Click:Connect(function()
    createPlatform("small")
end)

btn4.MouseButton1Click:Connect(function()
    createPlatform("big")
end)

btn5.MouseButton1Click:Connect(function()
    clearAll()
end)

CloseButton.MouseButton1Click:Connect(function()
    clearAll()
    ScreenGui:Destroy()
end)

local isHidden = false
HideButton.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    if isHidden then
        HideButton.Text = ">"
        MainFrame:TweenSize(UDim2.new(0, 85, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        ButtonsFrame:TweenPosition(UDim2.new(-1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
    else
        HideButton.Text = "<"
        MainFrame:TweenSize(UDim2.new(0, 250, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        ButtonsFrame:TweenPosition(UDim2.new(0, 5, 0, 5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
    end
end)

local function addHoverEffect(btn, stroke, defaultColor)
    btn.MouseEnter:Connect(function()
        stroke.Color = Color3.fromRGB(255, 150, 150)
        stroke.Thickness = 2
    end)
    btn.MouseLeave:Connect(function()
        stroke.Color = defaultColor
        stroke.Thickness = 1
    end)
end

addHoverEffect(CloseButton, closeStroke, Color3.fromRGB(255, 80, 80))
addHoverEffect(HideButton, hideStroke, Color3.fromRGB(255, 80, 80))
