--[[
    ============================================================
    VIX MODULES - COMPLETE UNIFIED MOBILE GUI
    ============================================================
    Creator: VIXIE
    Version: 3.0 Ultimate
    ============================================================
    FEATURES:
    - 7 Integrated Modules
    - Mobile-First Design
    - Glass/Blur Effects
    - Toggle System
    - Drag & Drop
    - Animations
    - Settings Panels
    - History System
    - Customization
    - Hotkeys Support
    - Performance Optimization
    ============================================================
]]

-- ============================================================
-- SECTION 1: CORE SERVICES AND VARIABLES
-- ============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- Global State Variables
local GlobalState = {
    GUIVisible = true,
    CurrentTheme = "DarkRed",
    AnimationSpeed = 0.3,
    IsMobile = UserInputService.TouchEnabled,
    GlobalScale = 1.0,
    DebugMode = false,
    PerformanceMode = false,
    LastAction = {},
    ActionHistory = {},
    MaxHistorySize = 50,
    SoundEnabled = true,
    VibrationEnabled = true,
}

-- Module States
local ModuleStates = {
    VFly = {Enabled = true, Position = {}, Settings = {}},
    Clips = {Enabled = true, Position = {}, Settings = {}},
    Plate = {Enabled = true, Position = {}, Settings = {}},
    RecTP = {Enabled = true, Position = {}, Settings = {}},
    Speeds = {Enabled = true, Position = {}, Settings = {}},
    TPSave = {Enabled = true, Position = {}, Settings = {}},
    Utils = {Enabled = true, Position = {}, Settings = {}},
}

-- ============================================================
-- SECTION 2: THEME AND STYLE DEFINITIONS
-- ============================================================

local Themes = {
    DarkRed = {
        Primary = Color3.fromRGB(150, 0, 0),
        Secondary = Color3.fromRGB(100, 0, 0),
        Background = Color3.fromRGB(45, 0, 0),
        Surface = Color3.fromRGB(60, 0, 0),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        Accent = Color3.fromRGB(255, 100, 100),
        Success = Color3.fromRGB(0, 200, 0),
        Warning = Color3.fromRGB(255, 200, 0),
        Error = Color3.fromRGB(200, 0, 0),
        Border = Color3.fromRGB(100, 30, 30),
        GlassTint = Color3.fromRGB(50, 10, 10),
    },
    DarkBlue = {
        Primary = Color3.fromRGB(0, 100, 150),
        Secondary = Color3.fromRGB(0, 60, 100),
        Background = Color3.fromRGB(0, 20, 40),
        Surface = Color3.fromRGB(0, 30, 60),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        Accent = Color3.fromRGB(100, 200, 255),
        Success = Color3.fromRGB(0, 200, 0),
        Warning = Color3.fromRGB(255, 200, 0),
        Error = Color3.fromRGB(200, 0, 0),
        Border = Color3.fromRGB(30, 60, 100),
        GlassTint = Color3.fromRGB(10, 20, 50),
    },
    DarkGreen = {
        Primary = Color3.fromRGB(0, 150, 50),
        Secondary = Color3.fromRGB(0, 100, 30),
        Background = Color3.fromRGB(0, 20, 10),
        Surface = Color3.fromRGB(0, 30, 15),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        Accent = Color3.fromRGB(100, 255, 150),
        Success = Color3.fromRGB(0, 200, 0),
        Warning = Color3.fromRGB(255, 200, 0),
        Error = Color3.fromRGB(200, 0, 0),
        Border = Color3.fromRGB(30, 100, 50),
        GlassTint = Color3.fromRGB(10, 30, 15),
    },
    DarkPurple = {
        Primary = Color3.fromRGB(150, 0, 150),
        Secondary = Color3.fromRGB(100, 0, 100),
        Background = Color3.fromRGB(30, 0, 30),
        Surface = Color3.fromRGB(50, 0, 50),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        Accent = Color3.fromRGB(255, 150, 255),
        Success = Color3.fromRGB(0, 200, 0),
        Warning = Color3.fromRGB(255, 200, 0),
        Error = Color3.fromRGB(200, 0, 0),
        Border = Color3.fromRGB(100, 30, 100),
        GlassTint = Color3.fromRGB(40, 10, 40),
    },
}

local CurrentTheme = Themes.DarkRed

-- ============================================================
-- SECTION 3: UTILITY FUNCTIONS - PART 1
-- ============================================================

local function log(message, level)
    if GlobalState.DebugMode then
        level = level or "INFO"
        print(string.format("[VIX %s] %s", level, message))
    end
end

local function warn(message)
    log(message, "WARN")
end

local function error(message)
    log(message, "ERROR")
end

local function assert(condition, message)
    if not condition then
        error(message or "Assertion failed!")
        return false
    end
    return true
end

local function pcallSafe(func, ...)
    local args = {...}
    return pcall(function()
        return func(unpack(args))
    end)
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function lerpColor(color1, color2, t)
    return Color3.new(
        lerp(color1.R, color2.R, t),
        lerp(color1.G, color2.G, t),
        lerp(color1.B, color2.B, t)
    )
end

local function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

local function round(value)
    return math.floor(value + 0.5)
end

local function formatNumber(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(round(num))
    end
end

local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    
    if hours > 0 then
        return string.format("%d:%02d:%02d", hours, minutes, secs)
    else
        return string.format("%d:%02d", minutes, secs)
    end
end

local function isPointInRect(point, rect)
    return point.X >= rect.X and point.X <= rect.X + rect.Width and
           point.Y >= rect.Y and point.Y <= rect.Y + rect.Height
end

local function getElementAbsolutePosition(element)
    local position = element.Position
    local parent = element.Parent
    
    while parent and parent ~= game do
        if parent:IsA("GuiObject") then
            local parentPosition = parent.Position
            position = UDim2.new(
                position.X.Scale + position.X.Offset / parent.AbsoluteSize.X,
                position.Y.Scale + position.Y.Offset / parent.AbsoluteSize.Y,
                0, 0
            )
        end
        parent = parent.Parent
    end
    
    return {
        X = position.X.Offset,
        Y = position.Y.Offset,
        Width = element.AbsoluteSize.X,
        Height = element.AbsoluteSize.Y
    }
end

-- ============================================================
-- SECTION 4: ANIMATION UTILITIES
-- ============================================================

local Animations = {}

function Animations.tween(instance, properties, duration, easingStyle, easingDirection)
    duration = duration or GlobalState.AnimationSpeed
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    
    return tween
end

function Animations.fadeIn(instance, duration)
    local tween = Animations.tween(instance, {BackgroundTransparency = 0}, duration)
    tween:Play()
    return tween
end

function Animations.fadeOut(instance, duration)
    local tween = Animations.tween(instance, {BackgroundTransparency = 1}, duration)
    tween:Play()
    return tween
end

function Animations.scale(instance, scale, duration)
    duration = duration or GlobalState.AnimationSpeed
    local tween = Animations.tween(instance, {Size = UDim2.new(scale.X.Scale, scale.X.Offset * GlobalState.GlobalScale, scale.Y.Scale, scale.Y.Offset * GlobalState.GlobalScale)}, duration)
    tween:Play()
    return tween
end

function Animations.move(instance, position, duration)
    local tween = Animations.tween(instance, {Position = position}, duration)
    tween:Play()
    return tween
end

function Animations.pulse(instance, scale, duration)
    duration = duration or 0.5
    local originalSize = instance.Size
    
    spawn(function()
        local tweenIn = Animations.tween(instance, {Size = UDim2.new(originalSize.X.Scale * scale, originalSize.X.Offset * scale, originalSize.Y.Scale * scale, originalSize.Y.Offset * scale)}, duration / 2)
        tweenIn:Play()
        tweenIn.Completed:Wait()
        
        local tweenOut = Animations.tween(instance, {Size = originalSize}, duration / 2)
        tweenOut:Play()
    end)
end

function Animations.shake(instance, intensity, duration)
    duration = duration or 0.3
    local originalPosition = instance.Position
    local elapsed = 0
    local frequency = 30
    
    spawn(function()
        while elapsed < duration do
            local deltaTime = RunService.RenderStepped:Wait()
            elapsed = elapsed + deltaTime
            
            local offsetX = math.random(-intensity, intensity) * (1 - elapsed / duration)
            local offsetY = math.random(-intensity, intensity) * (1 - elapsed / duration)
            
            instance.Position = UDim2.new(
                originalPosition.X.Scale,
                originalPosition.X.Offset + offsetX,
                originalPosition.Y.Scale,
                originalPosition.Y.Offset + offsetY
            )
        end
        
        instance.Position = originalPosition
    end)
end

function Animations.rotate(instance, angle, duration)
    duration = duration or GlobalState.AnimationSpeed
    local tween = Animations.tween(instance, {Rotation = angle}, duration)
    tween:Play()
    return tween
end

function Animations.color(instance, color, duration)
    local tween = Animations.tween(instance, {BackgroundColor3 = color}, duration)
    tween:Play()
    return tween
end

-- ============================================================
-- SECTION 5: UI COMPONENT FACTORY - PART 1
-- ============================================================

local UIComponents = {}

function UIComponents.createFrame(parent, properties)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = properties.BackgroundColor3 or CurrentTheme.Background
    frame.BackgroundTransparency = properties.BackgroundTransparency or 0.3
    frame.BorderSizePixel = 0
    frame.Size = properties.Size or UDim2.new(0, 100, 0, 50)
    frame.Position = properties.Position or UDim2.new(0, 0, 0, 0)
    frame.Name = properties.Name or "Frame"
    frame.Parent = parent
    
    if properties.Visible ~= nil then
        frame.Visible = properties.Visible
    end
    
    return frame
end

function UIComponents.createButton(parent, properties)
    local button = Instance.new("TextButton")
    button.BackgroundColor3 = properties.BackgroundColor3 or CurrentTheme.Primary
    button.BackgroundTransparency = properties.BackgroundTransparency or 0.3
    button.BorderSizePixel = 0
    button.Size = properties.Size or UDim2.new(0, 50, 0, 30)
    button.Position = properties.Position or UDim2.new(0, 0, 0, 0)
    button.Text = properties.Text or "Button"
    button.TextColor3 = properties.TextColor3 or CurrentTheme.Text
    button.TextSize = properties.TextSize or 14
    button.TextScaled = properties.TextScaled or false
    button.TextWrapped = properties.TextWrapped or true
    button.Font = properties.Font or Enum.Font.GothamBold
    button.Name = properties.Name or "Button"
    button.AutoButtonColor = properties.AutoButtonColor or true
    button.Parent = parent
    
    if properties.Visible ~= nil then
        button.Visible = properties.Visible
    end
    
    -- Hover effects
    if properties.HoverEffects ~= false then
        button.MouseEnter:Connect(function()
            Animations.color(button, CurrentTheme.Accent, 0.1)
        end)
        
        button.MouseLeave:Connect(function()
            Animations.color(button, CurrentTheme.Primary, 0.1)
        end)
    end
    
    -- Click sound
    if GlobalState.SoundEnabled then
        button.MouseButton1Click:Connect(function()
            -- Placeholder for click sound
        end)
    end
    
    return button
end

function UIComponents.createTextLabel(parent, properties)
    local label = Instance.new("TextLabel")
    label.BackgroundColor3 = properties.BackgroundColor3 or CurrentTheme.Background
    label.BackgroundTransparency = properties.BackgroundTransparency or 1
    label.BorderSizePixel = 0
    label.Size = properties.Size or UDim2.new(0, 100, 0, 30)
    label.Position = properties.Position or UDim2.new(0, 0, 0, 0)
    label.Text = properties.Text or "Label"
    label.TextColor3 = properties.TextColor3 or CurrentTheme.Text
    label.TextSize = properties.TextSize or 14
    label.TextScaled = properties.TextScaled or false
    label.TextWrapped = properties.TextWrapped or true
    label.Font = properties.Font or Enum.Font.Gotham
    label.TextXAlignment = properties.TextXAlignment or Enum.TextXAlignment.Center
    label.TextYAlignment = properties.TextYAlignment or Enum.TextYAlignment.Center
    label.Name = properties.Name or "Label"
    label.Parent = parent
    
    if properties.Visible ~= nil then
        label.Visible = properties.Visible
    end
    
    return label
end

function UIComponents.createTextBox(parent, properties)
    local textbox = Instance.new("TextBox")
    textbox.BackgroundColor3 = properties.BackgroundColor3 or CurrentTheme.Surface
    textbox.BackgroundTransparency = properties.BackgroundTransparency or 0.3
    textbox.BorderSizePixel = 0
    textbox.Size = properties.Size or UDim2.new(0, 100, 0, 30)
    textbox.Position = properties.Position or UDim2.new(0, 0, 0, 0)
    textbox.Text = properties.Text or ""
    textbox.TextColor3 = properties.TextColor3 or CurrentTheme.Text
    textbox.TextSize = properties.TextSize or 14
    textbox.TextScaled = properties.TextScaled or false
    textbox.TextWrapped = properties.TextWrapped or true
    textbox.Font = properties.Font or Enum.Font.Gotham
    textbox.PlaceholderText = properties.PlaceholderText or ""
    textbox.PlaceholderColor3 = properties.PlaceholderColor3 or CurrentTheme.TextSecondary
    textbox.ClearTextOnFocus = properties.ClearTextOnFocus or false
    textbox.Name = properties.Name or "TextBox"
    textbox.Parent = parent
    
    if properties.Visible ~= nil then
        textbox.Visible = properties.Visible
    end
    
    return textbox
end

function UIComponents.createImageButton(parent, properties)
    local imagebutton = Instance.new("ImageButton")
    imagebutton.BackgroundColor3 = properties.BackgroundColor3 or CurrentTheme.Primary
    imagebutton.BackgroundTransparency = properties.BackgroundTransparency or 0.3
    imagebutton.Size = properties.Size or UDim2.new(0, 50, 0, 50)
    imagebutton.Position = properties.Position or UDim2.new(0, 0, 0, 0)
    imagebutton.Image = properties.Image or ""
    imagebutton.ImageColor3 = properties.ImageColor3 or CurrentTheme.Text
    imagebutton.ImageRectOffset = properties.ImageRectOffset or Vector2.new(0, 0)
    imagebutton.ImageRectSize = properties.ImageRectSize or Vector2.new(0, 0)
    imagebutton.ScaleType = properties.ScaleType or Enum.ScaleType.Fit
    imagebutton.Name = properties.Name or "ImageButton"
    imagebutton.Parent = parent
    
    if properties.Visible ~= nil then
        imagebutton.Visible = properties.Visible
    end
    
    return imagebutton
end

function UIComponents.createScrollingFrame(parent, properties)
    local scrollingframe = Instance.new("ScrollingFrame")
    scrollingframe.BackgroundColor3 = properties.BackgroundColor3 or CurrentTheme.Background
    scrollingframe.BackgroundTransparency = properties.BackgroundTransparency or 0.3
    scrollingframe.BorderSizePixel = 0
    scrollingframe.Size = properties.Size or UDim2.new(0, 100, 0, 100)
    scrollingframe.Position = properties.Position or UDim2.new(0, 0, 0, 0)
    scrollingframe.ScrollBarThickness = properties.ScrollBarThickness or 5
    scrollingframe.ScrollBarImageColor3 = properties.ScrollBarImageColor3 or CurrentTheme.Accent
    scrollingframe.CanvasSize = properties.CanvasSize or UDim2.new(0, 0, 0, 0)
    scrollingframe.AutomaticCanvasSize = properties.AutomaticCanvasSize or Enum.AutomaticSize.None
    scrollingframe.ElasticBehavior = properties.ElasticBehavior or Enum.ElasticBehavior.Always
    scrollingframe.Name = properties.Name or "ScrollingFrame"
    scrollingframe.Parent = parent
    
    if properties.Visible ~= nil then
        scrollingframe.Visible = properties.Visible
    end
    
    return scrollingframe
end

function UIComponents.createFrameWithGlass(parent, properties)
    local frame = UIComponents.createFrame(parent, properties)
    
    -- Glass gradient effect
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    })
    gradient.Rotation = 45
    gradient.Parent = frame
    
    return frame
end

function UIComponents.createTextButtonWithIcon(parent, properties)
    local button = UIComponents.createButton(parent, properties)
    
    if properties.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, properties.IconSize or 20, 0, properties.IconSize or 20)
        icon.Position = UDim2.new(0, 5, 0.5, -properties.IconSize/2 or -10)
        icon.BackgroundTransparency = 1
        icon.Image = properties.Icon
        icon.ImageColor3 = CurrentTheme.Text
        icon.ScaleType = Enum.ScaleType.Fit
        icon.Parent = button
        
        -- Adjust text position
        button.TextXAlignment = Enum.TextXAlignment.Right
        button.TextPadding = UDim.new(0, properties.IconSize + 10 or 30)
    end
    
    return button
end

function UIComponents.createSlider(parent, properties)
    local sliderFrame = UIComponents.createFrame(parent, {
        Size = properties.Size or UDim2.new(0, 100, 0, 20),
        Position = properties.Position,
        BackgroundColor3 = CurrentTheme.Surface,
    })
    
    local sliderFill = UIComponents.createFrame(sliderFrame, {
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundColor3 = CurrentTheme.Primary,
    })
    
    local sliderKnob = UIComponents.createFrame(sliderFill, {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -8, 0.5, -8),
        BackgroundColor3 = CurrentTheme.Accent,
    })
    
    local minValue = properties.Min or 0
    local maxValue = properties.Max or 100
    local currentValue = properties.Default or (maxValue - minValue) / 2
    local valueLabel = UIComponents.createTextLabel(sliderFrame, {
        Size = UDim2.new(1, 0, 1, 0),
        Text = tostring(round(currentValue)),
        TextSize = 10,
    })
    
    local dragging = false
    
    local function updateSlider(input)
        local relativePosition = (input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X
        relativePosition = clamp(relativePosition, 0, 1)
        
        currentValue = lerp(minValue, maxValue, relativePosition)
        sliderFill.Size = UDim2.new(relativePosition, 0, 1, 0)
        valueLabel.Text = tostring(round(currentValue))
        
        if properties.OnValueChanged then
            properties.OnValueChanged(currentValue)
        end
    end
    
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    
    sliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                        input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    return sliderFrame, function() return currentValue end, function(val)
        currentValue = clamp(val, minValue, maxValue)
        local relativePosition = (currentValue - minValue) / (maxValue - minValue)
        sliderFill.Size = UDim2.new(relativePosition, 0, 1, 0)
        valueLabel.Text = tostring(round(currentValue))
    end
end

function UIComponents.createToggle(parent, properties)
    local toggleFrame = UIComponents.createFrame(parent, {
        Size = UDim2.new(0, 50, 0, 26),
        Position = properties.Position,
        BackgroundColor3 = CurrentTheme.Surface,
    })
    
    local toggleKnob = UIComponents.createFrame(toggleFrame, {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(0, 2, 0.5, -11),
        BackgroundColor3 = CurrentTheme.Text,
    })
    
    local enabled = properties.Enabled or false
    local label = nil
    
    if properties.Label then
        label = UIComponents.createTextLabel(parent, {
            Size = UDim2.new(0, 100, 0, 20),
            Position = properties.LabelPosition or UDim2.new(0, 60, 0.5, -10),
            Text = properties.Label,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
    end
    
    local function updateToggle()
        if enabled then
            toggleKnob.Position = UDim2.new(1, -24, 0.5, -11)
            toggleFrame.BackgroundColor3 = CurrentTheme.Success
        else
            toggleKnob.Position = UDim2.new(0, 2, 0.5, -11)
            toggleFrame.BackgroundColor3 = CurrentTheme.Surface
        end
    end
    
    toggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            enabled = not enabled
            updateToggle()
            if properties.OnToggle then
                properties.OnToggle(enabled)
            end
        end
    end)
    
    updateToggle()
    
    return toggleFrame, function() return enabled end, function(val)
        enabled = val
        updateToggle()
    end
end

function UIComponents.createDropdown(parent, properties)
    local dropdownFrame = UIComponents.createFrame(parent, {
        Size = properties.Size or UDim2.new(0, 100, 0, 30),
        Position = properties.Position,
        BackgroundColor3 = CurrentTheme.Surface,
    })
    
    local dropdownLabel = UIComponents.createTextLabel(dropdownFrame, {
        Size = UDim2.new(1, -30, 1, 0),
        Text = properties.Default or "Select...",
        TextXAlignment = Enum.TextXAlignment.Left,
        TextPadding = UDim.new(0, 10, 0, 0),
    })
    
    local dropdownArrow = UIComponents.createTextLabel(dropdownFrame, {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0.5, -10),
        Text = "▼",
        TextSize = 10,
    })
    
    local dropdownList = UIComponents.createScrollingFrame(parent, {
        Size = UDim2.new(0, 100, 0, 100),
        Position = properties.Position,
        BackgroundColor3 = CurrentTheme.Background,
        Visible = false,
    })
    
    local options = properties.Options or {}
    local selectedOption = nil
    
    for i, option in ipairs(options) do
        local optionButton = UIComponents.createButton(dropdownList, {
            Size = UDim2.new(1, 0, 0, 25),
            Position = UDim2.new(0, 5, 0, 5 + (i - 1) * 27),
            Text = option,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextPadding = UDim.new(0, 10, 0, 0),
        })
        
        optionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            dropdownLabel.Text = option
            dropdownList.Visible = false
            if properties.OnSelect then
                properties.OnSelect(option)
            end
        end)
    end
    
    dropdownFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dropdownList.Visible = not dropdownList.Visible
        end
    end)
    
    return dropdownFrame, function() return selectedOption end
end

function UIComponents.createTabSystem(parent, properties)
    local tabContainer = UIComponents.createFrame(parent, {
        Size = properties.Size or UDim2.new(0, 300, 0, 200),
        Position = properties.Position,
        BackgroundColor3 = CurrentTheme.Background,
    })
    
    local tabHeader = UIComponents.createFrame(tabContainer, {
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = CurrentTheme.Surface,
    })
    
    local tabContent = UIComponents.createFrame(tabContainer, {
        Size = UDim2.new(1, 0, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = CurrentTheme.Background,
    })
    
    local tabs = {}
    local activeTab = nil
    
    local headerLayout = Instance.new("UIListLayout")
    headerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    headerLayout.FillDirection = Enum.FillDirection.Horizontal
    headerLayout.Padding = UDim.new(0, 5)
    headerLayout.Parent = tabHeader
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.Parent = tabHeader
    
    function tabContainer:AddTab(name)
        local tabButton = UIComponents.createButton(tabHeader, {
            Size = UDim2.new(0, 80, 0, 30),
            Text = name,
            TextSize = 12,
        })
        
        local tabPage = UIComponents.createFrame(tabContent, {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
        })
        
        tabs[name] = {
            Button = tabButton,
            Page = tabPage,
        }
        
        tabButton.MouseButton1Click:Connect(function()
            self:SetActiveTab(name)
        end)
        
        if not activeTab then
            self:SetActiveTab(name)
        end
        
        return tabPage
    end
    
    function tabContainer:SetActiveTab(name)
        for tabName, tab in pairs(tabs) do
            tab.Page.Visible = (tabName == name)
            tab.Button.BackgroundColor3 = (tabName == name) and CurrentTheme.Primary or CurrentTheme.Surface
        end
        activeTab = name
    end
    
    return tabContainer
end

function UIComponents.createProgressBar(parent, properties)
    local progressFrame = UIComponents.createFrame(parent, {
        Size = properties.Size or UDim2.new(0, 100, 0, 10),
        Position = properties.Position,
        BackgroundColor3 = CurrentTheme.Surface,
    })
    
    local progressFill = UIComponents.createFrame(progressFrame, {
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundColor3 = CurrentTheme.Primary,
    })
    
    local progressLabel = UIComponents.createTextLabel(progressFrame, {
        Size = UDim2.new(1, 0, 1, 0),
        Text = "50%",
        TextSize = 8,
    })
    
    local minValue = properties.Min or 0
    local maxValue = properties.Max or 100
    local currentValue = properties.Default or 50
    
    local function updateProgress()
        local percentage = (currentValue - minValue) / (maxValue - minValue)
        progressFill.Size = UDim2.new(clamp(percentage, 0, 1), 0, 1, 0)
        progressLabel.Text = formatNumber(percentage * 100) .. "%"
    end
    
    updateProgress()
    
    return progressFrame, function() return currentValue end, function(val)
        currentValue = clamp(val, minValue, maxValue)
        updateProgress()
    end
end

function UIComponents.createIconButton(parent, properties)
    local button = UIComponents.createImageButton(parent, {
        Size = properties.Size or UDim2.new(0, 30, 0, 30),
        Position = properties.Position,
        Image = properties.Icon,
        ImageRectOffset = properties.IconRectOffset,
        ImageRectSize = properties.IconRectSize,
        BackgroundColor3 = CurrentTheme.Primary,
    })
    
    if properties.Tooltip then
        local tooltip = UIComponents.createTextLabel(button, {
            Size = UDim2.new(0, 100, 0, 30),
            Position = UDim2.new(0.5, -50, 1, 5),
            Text = properties.Tooltip,
            TextSize = 10,
            BackgroundColor3 = CurrentTheme.Surface,
            Visible = false,
        })
        
        button.MouseEnter:Connect(function()
            tooltip.Visible = true
        end)
        
        button.MouseLeave:Connect(function()
            tooltip.Visible = false
        end)
    end
    
    return button
end

-- ============================================================
-- SECTION 6: CORNER AND STROKE UTILITIES
-- ============================================================

local function addCorner(instance, radius)
    if not instance then return end
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or UDim.new(0, 10)
    corner.Parent = instance
    return corner
end

local function addStroke(instance, color, thickness)
    if not instance then return end
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or CurrentTheme.Border
    stroke.Thickness = thickness or 2
    stroke.Parent = instance
    return stroke
end

local function addGradient(instance, rotation, colors)
    if not instance then return end
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = rotation or 45
    gradient.Color = ColorSequence.new(colors or {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    })
    gradient.Parent = instance
    return gradient
end

local function addPadding(instance, padding)
    if not instance then return end
    local paddingInstance = Instance.new("UIPadding")
    paddingInstance.PaddingTop = UDim.new(0, padding.Top or 0)
    paddingInstance.PaddingBottom = UDim.new(0, padding.Bottom or 0)
    paddingInstance.PaddingLeft = UDim.new(0, padding.Left or 0)
    paddingInstance.PaddingRight = UDim.new(0, padding.Right or 0)
    paddingInstance.Parent = instance
    return paddingInstance
end

local function addLayout(instance, layoutType, properties)
    if not instance then return end
    
    local layout
    if layoutType == "List" then
        layout = Instance.new("UIListLayout")
    elseif layoutType == "Grid" then
        layout = Instance.new("UIGridLayout")
    elseif layoutType == "Frame" then
        layout = Instance.new("UIFlexItem")
    end
    
    if layout and properties then
        for property, value in pairs(properties) do
            layout[property] = value
        end
        layout.Parent = instance
    end
    
    return layout
end

-- ============================================================
-- SECTION 7: DRAG SYSTEM
-- ============================================================

local DragSystem = {}

function DragSystem.makeDraggable(instance, options)
    options = options or {}
    local dragStart = nil
    local startPos = nil
    local isDragging = false
    local guiObject = instance
    
    -- Find the parent GUI
    while guiObject and not guiObject:IsA("ScreenGui") do
        guiObject = guiObject.Parent
    end
    
    if not guiObject then return end
    
    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = instance.Position
            
            if options.OnDragStart then
                options.OnDragStart()
            end
        end
    end
    
    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            
            if options.OnDragEnd then
                options.OnDragEnd()
            end
        end
    end
    
    local function onInputChanged(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                          input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            
            local newXOffset = startPos.X.Offset + delta.X
            local newYOffset = startPos.Y.Offset + delta.Y
            
            -- Apply boundaries if specified
            if options.Boundaries then
                local parentSize = guiObject.AbsoluteSize
                
                if options.Boundaries.Clamp then
                    newXOffset = clamp(newXOffset, 0, parentSize.X - instance.AbsoluteSize.X)
                    newYOffset = clamp(newYOffset, 0, parentSize.Y - instance.AbsoluteSize.Y)
                end
                
                if options.Boundaries.ScreenEdgePadding then
                    local padding = options.Boundaries.ScreenEdgePadding
                    newXOffset = clamp(newXOffset, -instance.AbsoluteSize.X + padding, parentSize.X - padding)
                    newYOffset = clamp(newYOffset, -instance.AbsoluteSize.Y + padding, parentSize.Y - padding)
                end
            end
            
            instance.Position = UDim2.new(
                startPos.X.Scale,
                newXOffset,
                startPos.Y.Scale,
                newYOffset
            )
            
            if options.OnDrag then
                options.OnDrag(instance.Position)
            end
        end
    end
    
    instance.InputBegan:Connect(onInputBegan)
    instance.InputEnded:Connect(onInputEnded)
    UserInputService.InputChanged:Connect(onInputChanged)
end

function DragSystem.makeResizable(instance, options)
    options = options or {}
    local isResizing = false
    local startSize = nil
    local startPos = nil
    local startInput = nil
    
    local resizeHandle = UIComponents.createFrame(instance, {
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(1, -10, 1, -10),
        BackgroundColor3 = CurrentTheme.Accent,
        Name = "ResizeHandle",
    })
    addCorner(resizeHandle, UDim.new(0, 5))
    
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            isResizing = true
            startSize = instance.Size
            startInput = input.Position
            
            if options.OnResizeStart then
                options.OnResizeStart()
            end
        end
    end)
    
    resizeHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            isResizing = false
            
            if options.OnResizeEnd then
                options.OnResizeEnd()
            end
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                         input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startInput
            
            local newWidth = math.max(options.MinWidth or 50, startSize.X.Offset + delta.X)
            local newHeight = math.max(options.MinHeight or 50, startSize.Y.Offset + delta.Y)
            
            instance.Size = UDim2.new(
                startSize.X.Scale,
                newWidth,
                startSize.Y.Scale,
                newHeight
            )
            
            if options.OnResize then
                options.OnResize(instance.Size)
            end
        end
    end)
end

-- ============================================================
-- SECTION 8: NOTIFICATION SYSTEM
-- ============================================================

local NotificationSystem = {}

function NotificationSystem.init(parentGui)
    local notificationContainer = UIComponents.createFrame(parentGui, {
        Size = UDim2.new(0, 300, 0, 200),
        Position = UDim2.new(0.5, -150, 0, 10),
        Name = "NotificationContainer",
        BackgroundTransparency = 1,
    })
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Padding = UDim.new(0, 5)
    layout.Parent = notificationContainer
    
    function NotificationSystem.notify(message, type, duration)
        type = type or "Info"
        duration = duration or 3
        
        local notificationColor
        if type == "Success" then
            notificationColor = CurrentTheme.Success
        elseif type == "Warning" then
            notificationColor = CurrentTheme.Warning
        elseif type == "Error" then
            notificationColor = CurrentTheme.Error
        else
            notificationColor = CurrentTheme.Primary
        end
        
        local notification = UIComponents.createFrame(notificationContainer, {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = CurrentTheme.Surface,
        })
        addCorner(notification, UDim.new(0, 8))
        addStroke(notification, notificationColor, 2)
        
        local notificationIcon = UIComponents.createTextLabel(notification, {
            Size = UDim2.new(0, 30, 1, 0),
            Position = UDim2.new(0, 5, 0, 0),
            Text = type == "Success" and "✓" or type == "Warning" and "⚠" or type == "Error" and "✗" or "ℹ",
            TextColor3 = notificationColor,
            TextSize = 16,
        })
        
        local notificationText = UIComponents.createTextLabel(notification, {
            Size = UDim2.new(1, -45, 1, 0),
            Position = UDim2.new(0, 40, 0, 0),
            Text = message,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
        })
        
        -- Animation
        notification.BackgroundTransparency = 1
        notification.TextTransparency = 1
        
        spawn(function()
            local tween = Animations.tween(notification, {
                BackgroundTransparency = 0.3,
            }, 0.3)
            tween:Play()
        end)
        
        -- Auto remove
        spawn(function()
            wait(duration)
            local fadeTween = Animations.tween(notification, {
                BackgroundTransparency = 1,
            }, 0.3)
            fadeTween:Play()
            fadeTween.Completed:Connect(function()
                notification:Destroy()
            end)
        end)
        
        return notification
    end
    
    return NotificationSystem
end

-- ============================================================
-- SECTION 9: HISTORY SYSTEM
-- ============================================================

local HistorySystem = {}

function HistorySystem.init()
    local history = {
        Actions = {},
        MaxSize = GlobalState.MaxHistorySize,
        UndoStack = {},
        RedoStack = {},
    }
    
    function history:addAction(action)
        table.insert(self.Actions, 1, action)
        
        -- Trim if over max size
        while #self.Actions > self.MaxSize do
            table.remove(self.Actions)
        end
        
        -- Clear redo stack on new action
        self.RedoStack = {}
        
        log(string.format("Action added: %s", action.Type))
    end
    
    function history:undo()
        local action = table.remove(self.Actions, 1)
        if action and action.Undo then
            local success, result = pcallSafe(action.Undo)
            if success then
                table.insert(self.RedoStack, action)
                log(string.format("Undone: %s", action.Type))
                return true
            else
                error(string.format("Failed to undo %s: %s", action.Type, result))
            end
        end
        return false
    end
    
    function history:redo()
        local action = table.remove(self.RedoStack, 1)
        if action and action.Redo then
            local success, result = pcallSafe(action.Redo)
            if success then
                table.insert(self.Actions, 1, action)
                log(string.format("Redone: %s", action.Type))
                return true
            else
                error(string.format("Failed to redo %s: %s", action.Type, result))
            end
        end
        return false
    end
    
    function history:clear()
        self.Actions = {}
        self.UndoStack = {}
        self.RedoStack = {}
        log("History cleared")
    end
    
    function history:getRecent(count)
        count = count or 10
        local recent = {}
        for i = 1, math.min(count, #self.Actions) do
            table.insert(recent, self.Actions[i])
        end
        return recent
    end
    
    return history
end

-- ============================================================
-- SECTION 10: SETTINGS MANAGER
-- ============================================================

local SettingsManager = {}

function SettingsManager.init()
    local settings = {
        VFly = {
            DefaultSpeed = 300,
            AutoResetOnDeath = true,
            ShowControls = true,
            SmoothMode = true,
        },
        Clips = {
            AutoResetOnDeath = true,
            NoclipTransparency = 1,
            ShowNotifications = true,
        },
        Plate = {
            DefaultPlatformSize = "Medium",
            PlatformTransparency = 0.8,
            AutoClearOnDeath = false,
            ShowBorders = true,
            MaxPlatforms = 100,
        },
        RecTP = {
            DefaultDelay = 1,
            MaxPoints = 50,
            AutoLoop = false,
            ShowPath = true,
        },
        Speeds = {
            DefaultSpeed = 25,
            DefaultJumpPower = 50,
            SmoothTransition = true,
            AutoResetOnDeath = false,
        },
        TPSave = {
            AutoTeleportInterval = 1,
            SaveOrientation = true,
            MaxSavedPositions = 10,
        },
        Utils = {
            FullBrightLevel = 2,
            DarkModeLevel = 0,
            DefaultGravity = 196.2,
            XRayTransparency = 0.7,
        },
        UI = {
            AnimationSpeed = 0.3,
            GlobalScale = 1.0,
            SoundEnabled = true,
            VibrationEnabled = true,
            DebugMode = false,
        },
    }
    
    function settings:get(module, key)
        if self[module] then
            return self[module][key]
        end
        return nil
    end
    
    function settings:set(module, key, value)
        if self[module] then
            self[module][key] = value
            log(string.format("Setting %s.%s = %s", module, key, tostring(value)))
            return true
        end
        return false
    end
    
    function settings:getModule(module)
        return self[module] or {}
    end
    
    function settings:resetModule(module)
        -- Reset to defaults would require storing defaults
        log(string.format("Reset module %s settings", module))
    end
    
    function settings:resetAll()
        -- Reset all settings
        log("All settings reset")
    end
    
    return settings
end

-- ============================================================
-- SECTION 11: HOTKEY MANAGER
-- ============================================================

local HotkeyManager = {}

function HotkeyManager.init()
    local hotkeys = {}
    local enabled = true
    
    function hotkeys:register(keyCode, callback, description)
        local connection = UserInputService.InputBegan:Connect(function(input, processed)
            if not enabled then return end
            if processed then return end
            
            if input.KeyCode == keyCode then
                local success, err = pcallSafe(callback)
                if not success then
                    error(string.format("Hotkey callback error: %s", err))
                end
            end
        end)
        
        log(string.format("Hotkey registered: %s - %s", tostring(keyCode), description or "No description"))
        
        return connection
    end
    
    function hotkeys:unregister(connection)
        if connection then
            connection:Disconnect()
            log("Hotkey unregistered")
        end
    end
    
    function hotkeys:enable()
        enabled = true
        log("Hotkeys enabled")
    end
    
    function hotkeys:disable()
        enabled = false
        log("Hotkeys disabled")
    end
    
    function hotkeys:toggle()
        enabled = not enabled
        log(string.format("Hotkeys %s", enabled and "enabled" or "disabled"))
    end
    
    return hotkeys
end

-- ============================================================
-- SECTION 12: MAIN GUI CREATION
-- ============================================================

-- Create main ScreenGui
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "VIX Modules"
MainGui.ResetOnSpawn = false
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Try to parent to PlayerGui, fall back to CoreGui
local success, err = pcall(function()
    MainGui.Parent = player:WaitForChild("PlayerGui", 5)
end)

if not success then
    pcall(function()
        MainGui.Parent = game:GetService("CoreGui")
    end)
end

-- Initialize subsystems
local NotificationSystem = NotificationSystem.init(MainGui)
local HistorySystem = HistorySystem.init()
local SettingsManager = SettingsManager.init()
local HotkeyManager = HotkeyManager.init()

-- ============================================================
-- SECTION 13: TOGGLE BUTTON
-- ============================================================

local ToggleButton = UIComponents.createImageButton(MainGui, {
    Size = UDim2.new(0, 60, 0, 60),
    Position = UDim2.new(0.95, -30, 0.5, -30),
    Image = "rbxassetid://6031091004",
    ImageRectOffset = Vector2.new(464, 404),
    ImageRectSize = Vector2.new(36, 36),
    BackgroundColor3 = CurrentTheme.Primary,
    Name = "ToggleButton",
})

addCorner(ToggleButton, UDim.new(0.5, 0))
addStroke(ToggleButton, CurrentTheme.Accent, 3)

-- Pulse animation on hover
ToggleButton.MouseEnter:Connect(function()
    Animations.pulse(ToggleButton, 1.1, 0.2)
end)

local toggleRotation = 0
local isExpanded = true

ToggleButton.MouseButton1Click:Connect(function()
    isExpanded = not isExpanded
    
    spawn(function()
        for i = 1, 10 do
            toggleRotation = lerp(toggleRotation, isExpanded and 0 or 180, 0.3)
            ToggleButton.Rotation = toggleRotation
            wait(0.02)
        end
    end)
    
    if not isExpanded then
        -- Collapse animation
        local collapseTween = Animations.tween(MainContainer, {
            Size = UDim2.new(0, 0, 0, 0),
        }, 0.3)
        collapseTween:Play()
        
        Animations.move(ToggleButton, UDim2.new(0.5, -30, 0.5, -30), 0.3):Play()
        
        NotificationSystem.notify("VIX Modules Hidden", "Info", 2)
    else
        -- Expand animation
        Animations.move(ToggleButton, UDim2.new(0.95, -30, 0.5, -30), 0.3):Play()
        
        MainContainer:TweenSize(UDim2.new(0, 220, 0, 0), "Out", "Quad", 0.1)
        wait(0.1)
        MainContainer:TweenSize(UDim2.new(0, 220, 0, 600), "Out", "Quad", 0.3)
        
        NotificationSystem.notify("VIX Modules Shown", "Info", 2)
    end
end)

-- ============================================================
-- SECTION 14: MAIN CONTAINER
-- ============================================================

local MainContainer = UIComponents.createFrame(MainGui, {
    Size = UDim2.new(0, 220, 0, 600),
    Position = UDim2.new(0.95, -220, 0.5, -300),
    BackgroundColor3 = CurrentTheme.Background,
    Name = "MainContainer",
})

addCorner(MainContainer, UDim.new(0, 15))
addStroke(MainContainer, CurrentTheme.Border, 2)
addGradient(MainContainer, 45, {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 220, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
})

-- Make container draggable
DragSystem.makeDraggable(MainContainer, {
    Boundaries = {
        Clamp = true,
    },
    OnDragStart = function()
        log("Container drag started")
    end,
    OnDragEnd = function()
        log("Container drag ended")
    end
})

-- ============================================================
-- SECTION 15: HEADER
-- ============================================================

local Header = UIComponents.createFrame(MainContainer, {
    Size = UDim2.new(1, 0, 0, 50),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = CurrentTheme.Surface,
    Name = "Header",
})

addCorner(Header, UDim.new(0, 15))
-- Bottom corners only
local headerMask = UIComponents.createFrame(MainContainer, {
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 0, 35),
    BackgroundColor3 = CurrentTheme.Background,
    Name = "HeaderMask",
})

local HeaderTitle = UIComponents.createTextLabel(Header, {
    Size = UDim2.new(1, -80, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    Text = "VIX MODULES",
    TextSize = 18,
    Font = Enum.Font.GothamBlack,
    TextXAlignment = Enum.TextXAlignment.Left,
    Name = "Title",
})

local HeaderClose = UIComponents.createButton(Header, {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -70, 0.5, -15),
    Text = "✕",
    TextSize = 16,
    BackgroundColor3 = CurrentTheme.Error,
    Name = "CloseButton",
})
addCorner(HeaderClose, UDim.new(0, 8))

HeaderClose.MouseButton1Click:Connect(function()
    MainGui:Destroy()
    log("GUI destroyed")
end)

local HeaderMinimize = UIComponents.createButton(Header, {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -100, 0.5, -15),
    Text = "−",
    TextSize = 20,
    BackgroundColor3 = CurrentTheme.Primary,
    Name = "MinimizeButton",
})
addCorner(HeaderMinimize, UDim.new(0, 8))

HeaderMinimize.MouseButton1Click:Connect(function()
    ToggleButton.MouseButton1Click:Fire()
end)

-- ============================================================
-- SECTION 16: MODULE LIST
-- ============================================================

local ModuleList = UIComponents.createScrollingFrame(MainContainer, {
    Size = UDim2.new(1, 0, 1, -60),
    Position = UDim2.new(0, 0, 0, 55),
    BackgroundColor3 = CurrentTheme.Background,
    BackgroundTransparency = 0.5,
    ScrollBarThickness = 4,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Name = "ModuleList",
})

addPadding(ModuleList, {Top = 5, Bottom = 5, Left = 5, Right = 5})

local ModuleListLayout = Instance.new("UIListLayout")
ModuleListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ModuleListLayout.Padding = UDim.new(0, 8)
ModuleListLayout.Parent = ModuleList

-- ============================================================
-- SECTION 17: MODULE TOGGLE CREATION
-- ============================================================

local ModuleToggles = {}

function CreateModuleToggle(name, icon, order)
    local moduleFrame = UIComponents.createFrame(ModuleList, {
        Size = UDim2.new(1, -10, 0, 60),
        BackgroundColor3 = CurrentTheme.Surface,
        Name = name,
        LayoutOrder = order,
    })
    addCorner(moduleFrame, UDim.new(0, 10))
    
    -- Status indicator
    local statusDot = UIComponents.createFrame(moduleFrame, {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = CurrentTheme.Success,
        Name = "StatusDot",
    })
    addCorner(statusDot, UDim.new(1, 0))
    
    -- Module icon
    local iconLabel = UIComponents.createTextLabel(moduleFrame, {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 30, 0, 15),
        Text = icon,
        TextSize = 20,
        Name = "Icon",
    })
    
    -- Module name
    local nameLabel = UIComponents.createTextLabel(moduleFrame, {
        Size = UDim2.new(1, -120, 0, 20),
        Position = UDim2.new(0, 65, 0, 12),
        Text = name,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Name = "Name",
    })
    
    -- Module description
    local descLabel = UIComponents.createTextLabel(moduleFrame, {
        Size = UDim2.new(1, -120, 0, 15),
        Position = UDim2.new(0, 65, 0, 32),
        Text = "Click to configure",
        TextSize = 10,
        TextColor3 = CurrentTheme.TextSecondary,
        TextXAlignment = Enum.TextXAlignment.Left,
        Name = "Description",
    })
    
    -- Toggle switch
    local toggleSwitch = UIComponents.createFrame(moduleFrame, {
        Size = UDim2.new(0, 45, 0, 24),
        Position = UDim2.new(1, -55, 0, 18),
        BackgroundColor3 = CurrentTheme.Surface,
        Name = "ToggleSwitch",
    })
    addCorner(toggleSwitch, UDim.new(0, 12))
    
    local toggleKnob = UIComponents.createFrame(toggleSwitch, {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -22, 0.5, -10),
        BackgroundColor3 = CurrentTheme.Text,
        Name = "ToggleKnob",
    })
    addCorner(toggleKnob, UDim.new(1, 0))
    
    local enabled = true
    
    local function updateToggle()
        if enabled then
            statusDot.BackgroundColor3 = CurrentTheme.Success
            toggleKnob.Position = UDim2.new(1, -22, 0.5, -10)
            toggleSwitch.BackgroundColor3 = CurrentTheme.Success
            nameLabel.TextColor3 = CurrentTheme.Text
        else
            statusDot.BackgroundColor3 = CurrentTheme.Error
            toggleKnob.Position = UDim2.new(0, 2, 0.5, -10)
            toggleSwitch.BackgroundColor3 = CurrentTheme.Surface
            nameLabel.TextColor3 = CurrentTheme.TextSecondary
        end
    end
    
    toggleSwitch.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            enabled = not enabled
            updateToggle()
            Animations.pulse(toggleSwitch, 1.05, 0.2)
            
            if ModuleStates[name] then
                ModuleStates[name].Enabled = enabled
            end
            
            if enabled then
                NotificationSystem.notify(name .. " Enabled", "Success")
            else
                NotificationSystem.notify(name .. " Disabled", "Warning")
            end
        end
    end)
    
    updateToggle()
    
    -- Click to open module
    moduleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            Animations.pulse(moduleFrame, 1.02, 0.2)
        end
    end)
    
    return {
        Frame = moduleFrame,
        StatusDot = statusDot,
        NameLabel = nameLabel,
        DescLabel = descLabel,
        ToggleSwitch = toggleSwitch,
        ToggleKnob = toggleKnob,
        IsEnabled = function() return enabled end,
        SetEnabled = function(val)
            enabled = val
            updateToggle()
        end,
        SetDescription = function(text)
            descLabel.Text = text
        end,
    }
end

-- ============================================================
-- SECTION 18: CREATE ALL MODULE TOGGLES
-- ============================================================

ModuleToggles.VFly = CreateModuleToggle("VIX | VFly", "🚀", 1)
ModuleToggles.Clips = CreateModuleToggle("VIX | Clips", "👻", 2)
ModuleToggles.Plate = CreateModuleToggle("VIX | Plate", "🧱", 3)
ModuleToggles.RecTP = CreateModuleToggle("VIX | RecTP", "📍", 4)
ModuleToggles.Speeds = CreateModuleToggle("VIX | Speeds", "⚡", 5)
ModuleToggles.TPSave = CreateModuleToggle("VIX | TPSave", "💾", 6)
ModuleToggles.Utils = CreateModuleToggle("VIX | Utils", "🔧", 7)

-- ============================================================
-- SECTION 19: OPEN BUTTONS SECTION
-- ============================================================

local OpenButtonsSection = UIComponents.createFrame(ModuleList, {
    Size = UDim2.new(1, -10, 0, 250),
    BackgroundColor3 = CurrentTheme.Background,
    BackgroundTransparency = 0.7,
    LayoutOrder = 100,
    Name = "OpenButtonsSection",
})
addCorner(OpenButtonsSection, UDim.new(0, 10))

local OpenButtonsTitle = UIComponents.createTextLabel(OpenButtonsSection, {
    Size = UDim2.new(1, 0, 0, 25),
    Position = UDim2.new(0, 10, 0, 5),
    Text = "QUICK OPEN",
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    TextColor3 = CurrentTheme.Accent,
    TextXAlignment = Enum.TextXAlignment.Left,
    Name = "Title",
})

local OpenButtonsContainer = UIComponents.createFrame(OpenButtonsSection, {
    Size = UDim2.new(1, -20, 1, -35),
    Position = UDim2.new(0, 10, 0, 30),
    BackgroundTransparency = 1,
    Name = "ButtonsContainer",
})

local OpenButtonsLayout = Instance.new("UIGridLayout")
OpenButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
OpenButtonsLayout.CellSize = UDim2.new(0.48, -5, 0, 35)
OpenButtonsLayout.CellPadding = UDim2.new(0.04, 0, 0, 5)
OpenButtonsLayout.Parent = OpenButtonsContainer

local function CreateOpenButton(name, icon, callback)
    local btn = UIComponents.createButton(OpenButtonsContainer, {
        Text = icon .. " " .. name,
        TextSize = 11,
        BackgroundColor3 = CurrentTheme.Primary,
        Name = "Open" .. name,
    })
    addCorner(btn, UDim.new(0, 8))
    
    btn.MouseButton1Click:Connect(function()
        Animations.pulse(btn, 0.95, 0.2)
        callback()
    end)
    
    return btn
end

-- ============================================================
-- SECTION 20: VFLY MODULE
-- ============================================================

local VFlyModule = {}
local VFlyGui = Instance.new("ScreenGui")
VFlyGui.Name = "VFlyGui"
VFlyGui.Parent = MainGui

VFlyModule.Frame = UIComponents.createFrame(VFlyGui, {
    Size = UDim2.new(0, 140, 0, 180),
    Position = UDim2.new(0.4, 0, 0.3, 0),
    BackgroundColor3 = CurrentTheme.Surface,
    Name = "VFlyFrame",
    Visible = false,
})
addCorner(VFlyModule.Frame, UDim.new(0, 12))
addStroke(VFlyModule.Frame, CurrentTheme.Border, 2)

DragSystem.makeDraggable(VFlyModule.Frame)

-- VFly Header
local VFlyHeader = UIComponents.createFrame(VFlyModule.Frame, {
    Size = UDim2.new(1, 0, 0, 35),
    BackgroundColor3 = CurrentTheme.Primary,
    Name = "Header",
})
addCorner(VFlyHeader, UDim.new(0, 12))

local VFlyTitle = UIComponents.createTextLabel(VFlyHeader, {
    Size = UDim2.new(1, -40, 1, 0),
    Text = "VIX | VFly",
    TextSize = 12,
    Font = Enum.Font.GothamBold,
})

local VFlyClose = UIComponents.createButton(VFlyHeader, {
    Size = UDim2.new(0, 25, 0, 25),
    Position = UDim2.new(1, -30, 0.5, -12.5),
    Text = "✕",
    TextSize = 14,
    BackgroundColor3 = CurrentTheme.Error,
    Name = "Close",
})
addCorner(VFlyClose, UDim.new(0, 6))
VFlyClose.MouseButton1Click:Connect(function()
    VFlyModule.Frame.Visible = false
end)

-- Speed input
local VFlySpeedLabel = UIComponents.createTextLabel(VFlyModule.Frame, {
    Size = UDim2.new(1, -10, 0, 20),
    Position = UDim2.new(0, 5, 0, 40),
    Text = "Speed:",
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local VFlySpeedInput = UIComponents.createTextBox(VFlyModule.Frame, {
    Size = UDim2.new(1, -10, 0, 25),
    Position = UDim2.new(0, 5, 0, 58),
    Text = "300",
    TextSize = 12,
    PlaceholderText = "Enter speed...",
})

-- Status display
local VFlyStatus = UIComponents.createTextLabel(VFlyModule.Frame, {
    Size = UDim2.new(1, -10, 0, 20),
    Position = UDim2.new(0, 5, 0, 86),
    Text = "Status: OFF",
    TextSize = 11,
    TextColor3 = CurrentTheme.Error,
})

-- Fly buttons
local VFlyOnBtn = UIComponents.createButton(VFlyModule.Frame, {
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 110),
    Text = "FLY ON",
    TextSize = 12,
    BackgroundColor3 = CurrentTheme.Success,
    Name = "FlyOn",
})
addCorner(VFlyOnBtn, UDim.new(0, 8))

local VFlyOffBtn = UIComponents.createButton(VFlyModule.Frame, {
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 145),
    Text = "FLY OFF",
    TextSize = 12,
    BackgroundColor3 = CurrentTheme.Error,
    Name = "FlyOff",
    Visible = false,
})
addCorner(VFlyOffBtn, UDim.new(0, 8))

-- VFly Controls Frame (WASD buttons)
local VFlyControls = UIComponents.createFrame(MainGui, {
    Size = UDim2.new(0, 150, 0, 120),
    Position = UDim2.new(0.1, 0, 0.6, 0),
    BackgroundColor3 = CurrentTheme.Surface,
    Name = "VFlyControls",
    Visible = false,
})
addCorner(VFlyControls, UDim.new(0, 10))
addStroke(VFlyControls, CurrentTheme.Border, 2)

DragSystem.makeDraggable(VFlyControls)

-- Control buttons
local VFlyW = UIComponents.createButton(VFlyControls, {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0, 10, 0, 10),
    Text = "^",
    TextSize = 24,
    Name = "W",
})
addCorner(VFlyW, UDim.new(0, 8))

local VFlyS = UIComponents.createButton(VFlyControls, {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0, 10, 0, 65),
    Text = "^",
    TextSize = 24,
    Rotation = 180,
    Name = "S",
})
addCorner(VFlyS, UDim.new(0, 8))

local VFlyLoop = UIComponents.createButton(VFlyControls, {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0.5, 5, 0, 10),
    Text = "LOOP",
    TextSize = 10,
    Name = "Loop",
})
addCorner(VFlyLoop, UDim.new(0, 8))

local VFlyBoost = UIComponents.createButton(VFlyControls, {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0.5, 5, 0, 65),
    Text = "BOOST",
    TextSize = 10,
    Name = "Boost",
})
addCorner(VFlyBoost, UDim.new(0, 8))

-- VFly Logic
local isFlying = false
local isLooping = false
local loopConnection = nil
local currentDirection = nil

local function flyDirection(dir)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = hrp:FindFirstChildOfClass("BodyVelocity")
        if bv then
            local speed = tonumber(VFlySpeedInput.Text) or 300
            bv.Velocity = camera.CFrame.LookVector * dir * speed
        end
    end
end

local function stopFly()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = hrp:FindFirstChildOfClass("BodyVelocity")
        if bv then
            bv.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

VFlyOnBtn.MouseButton1Click:Connect(function()
    if isFlying then return end
    
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        NotificationSystem.notify("No character found!", "Error")
        return
    end
    
    isFlying = true
    VFlyOnBtn.Visible = false
    VFlyOffBtn.Visible = true
    VFlyStatus.Text = "Status: ON"
    VFlyStatus.TextColor3 = CurrentTheme.Success
    VFlyControls.Visible = true
    
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = hrp
    
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.D = 5000
    bg.P = 100000
    bg.Parent = hrp
    
    RunService.RenderStepped:Connect(function()
        if bg and hrp and hrp.Parent then
            bg.CFrame = camera.CFrame
        end
    end)
    
    NotificationSystem.notify("Flying enabled!", "Success")
end)

VFlyOffBtn.MouseButton1Click:Connect(function()
    isFlying = false
    VFlyOnBtn.Visible = true
    VFlyOffBtn.Visible = false
    VFlyStatus.Text = "Status: OFF"
    VFlyStatus.TextColor3 = CurrentTheme.Error
    VFlyControls.Visible = false
    
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, v in pairs(hrp:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                v:Destroy()
            end
        end
    end
    
    NotificationSystem.notify("Flying disabled!", "Warning")
end)

VFlyW.MouseButton1Click:Connect(function()
    currentDirection = 1
    if isLooping then
        if loopConnection then loopConnection:Disconnect() end
        loopConnection = RunService.RenderStepped:Connect(function()
            flyDirection(1)
        end)
    else
        flyDirection(1)
        wait(0.1)
        stopFly()
    end
end)

VFlyS.MouseButton1Click:Connect(function()
    currentDirection = -1
    if isLooping then
        if loopConnection then loopConnection:Disconnect() end
        loopConnection = RunService.RenderStepped:Connect(function()
            flyDirection(-1)
        end)
    else
        flyDirection(-1)
        wait(0.1)
        stopFly()
    end
end)

VFlyLoop.MouseButton1Click:Connect(function()
    isLooping = not isLooping
    VFlyLoop.BackgroundColor3 = isLooping and CurrentTheme.Warning or CurrentTheme.Primary
    Animations.shake(VFlyLoop, 3, 0.2)
end)

VFlyBoost.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = hrp:FindFirstChildOfClass("BodyVelocity")
        if bv then
            local speed = tonumber(VFlySpeedInput.Text) or 300
            for i = 1, 20 do
                bv.Velocity = camera.CFrame.LookVector * speed * 2
                wait(0.02)
            end
            bv.Velocity = Vector3.new(0, 0, 0)
            Animations.shake(VFlyControls, 5, 0.3)
        end
    end
end)

-- Open button for VFly
CreateOpenButton("VFly", "🚀", function()
    VFlyModule.Frame.Visible = true
    Animations.tween(VFlyModule.Frame, {Size = UDim2.new(0, 140, 0, 180)}, 0.3):Play()
end)

-- ============================================================
-- SECTION 21: CLIPS MODULE
-- ============================================================

local ClipsModule = {}
local ClipsGui = Instance.new("ScreenGui")
ClipsGui.Name = "ClipsGui"
ClipsGui.Parent = MainGui

ClipsModule.Frame = UIComponents.createFrame(ClipsGui, {
    Size = UDim2.new(0, 80, 0, 120),
    Position = UDim2.new(0.5, -40, 0.5, -60),
    BackgroundColor3 = CurrentTheme.Surface,
    Name = "ClipsFrame",
    Visible = false,
})
addCorner(ClipsModule.Frame, UDim.new(0, 12))
addStroke(ClipsModule.Frame, CurrentTheme.Border, 2)

DragSystem.makeDraggable(ClipsModule.Frame)

-- Header
local ClipsHeader = UIComponents.createTextLabel(ClipsModule.Frame, {
    Size = UDim2.new(1, 0, 0, 25),
    Text = "VIX | Clips",
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    BackgroundColor3 = CurrentTheme.Primary,
})

-- Buttons
local ClipsNoClip = UIComponents.createButton(ClipsModule.Frame, {
    Size = UDim2.new(0.9, 0, 0, 22),
    Position = UDim2.new(0.05, 0, 0, 28),
    Text = "NOCLIP",
    TextSize = 10,
    Name = "NoClip",
})
addCorner(ClipsNoClip, UDim.new(0, 6))

local ClipsReClip = UIComponents.createButton(ClipsModule.Frame, {
    Size = UDim2.new(0.9, 0, 0, 22),
    Position = UDim2.new(0.05, 0, 0, 53),
    Text = "RECLIP",
    TextSize = 10,
    Name = "ReClip",
})
addCorner(ClipsReClip, UDim.new(0, 6))

local ClipsInvis = UIComponents.createButton(ClipsModule.Frame, {
    Size = UDim2.new(0.9, 0, 0, 22),
    Position = UDim2.new(0.05, 0, 0, 78),
    Text = "INVIS",
    TextSize = 10,
    Name = "Invis",
})
addCorner(ClipsInvis, UDim.new(0, 6))

local ClipsAuto = UIComponents.createButton(ClipsModule.Frame, {
    Size = UDim2.new(0.9, 0, 0, 22),
    Position = UDim2.new(0.05, 0, 0, 103),
    Text = "AUTO",
    TextSize = 10,
    BackgroundColor3 = CurrentTheme.Surface,
    Name = "Auto",
})
addCorner(ClipsAuto, UDim.new(0, 6))

-- Close button
local ClipsClose = UIComponents.createButton(ClipsModule.Frame, {
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(1, -25, 0, 3),
    Text = "✕",
    TextSize = 10,
    BackgroundColor3 = CurrentTheme.Error,
    Name = "Close",
})
addCorner(ClipsClose, UDim.new(0, 5))
ClipsClose.MouseButton1Click:Connect(function()
    ClipsModule.Frame.Visible = false
end)

-- Clips Logic
local noclipEnabled = false
local autoNoclipEnabled = false
local invisEnabled = false

local function setNoclip(state)
    noclipEnabled = state
    local char = player.Character
    if not char then return end
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
    
    if state then
        NotificationSystem.notify("Noclip enabled!", "Success")
    else
        NotificationSystem.notify("Noclip disabled!", "Warning")
    end
end

local function setInvis(state)
    invisEnabled = state
    local char = player.Character
    if not char then return end
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanTouch = not state
        end
    end
    
    ClipsInvis.BackgroundColor3 = state and CurrentTheme.Success or CurrentTheme.Primary
    NotificationSystem.notify(state and "Invisibility ON!" or "Invisibility OFF!", state and "Success" or "Warning")
end

ClipsNoClip.MouseButton1Click:Connect(function()
    setNoclip(true)
end)

ClipsReClip.MouseButton1Click:Connect(function()
    setNoclip(false)
end)

ClipsInvis.MouseButton1Click:Connect(function()
    setInvis(not invisEnabled)
end)

ClipsAuto.MouseButton1Click:Connect(function()
    autoNoclipEnabled = not autoNoclipEnabled
    ClipsAuto.BackgroundColor3 = autoNoclipEnabled and CurrentTheme.Success or CurrentTheme.Surface
    Animations.pulse(ClipsAuto, 1.1, 0.2)
    
    if autoNoclipEnabled then
        NotificationSystem.notify("Auto noclip enabled!", "Info")
    end
end)

-- Auto noclip loop
spawn(function()
    while wait(1) do
        if autoNoclipEnabled then
            setNoclip(true)
        end
    end
end)

-- Character respawn handler
player.CharacterAdded:Connect(function(char)
    wait(0.5)
    if noclipEnabled or autoNoclipEnabled then
        setNoclip(true)
    end
end)

CreateOpenButton("Clips", "👻", function()
    ClipsModule.Frame.Visible = true
    Animations.tween(ClipsModule.Frame, {Size = UDim2.new(0, 80, 0, 120)}, 0.3):Play()
end)

-- ============================================================
-- SECTION 22: PLATE MODULE
-- ============================================================

local PlateModule = {}
local PlateGui = Instance.new("ScreenGui")
PlateGui.Name = "PlateGui"
PlateGui.Parent = MainGui

PlateModule.Frame = UIComponents.createFrame(PlateGui, {
    Size = UDim2.new(0, 220, 0, 200),
    Position = UDim2.new(0.1, 0, 0.2, 0),
    BackgroundColor3 = CurrentTheme.Surface,
    Name = "PlateFrame",
    Visible = false,
})
addCorner(PlateModule.Frame, UDim.new(0, 12))
addStroke(PlateModule.Frame, CurrentTheme.Border, 2)

DragSystem.makeDraggable(PlateModule.Frame)

-- Header
local PlateHeader = UIComponents.createFrame(PlateModule.Frame, {
    Size = UDim2.new(1, 0, 0, 35),
    BackgroundColor3 = CurrentTheme.Primary,
    Name = "Header",
})
addCorner(PlateHeader, UDim.new(0, 12))

local PlateTitle = UIComponents.createTextLabel(PlateHeader, {
    Size = UDim2.new(1, -50, 1, 0),
    Text = "VIX | Plate",
    TextSize = 14,
    Font = Enum.Font.GothamBold,
})

local PlateClose = UIComponents.createButton(PlateHeader, {
    Size = UDim2.new(0, 25, 0, 25),
    Position = UDim2.new(1, -30, 0.5, -12.5),
    Text = "✕",
    TextSize = 14,
    BackgroundColor3 = CurrentTheme.Error,
    Name = "Close",
})
addCorner(PlateClose, UDim.new(0, 6))
PlateClose.MouseButton1Click:Connect(function()
    PlateModule.Frame.Visible = false
end)

-- Buttons container
local PlateButtons = UIComponents.createFrame(PlateModule.Frame, {
    Size = UDim2.new(1, -10, 1, -45),
    Position = UDim2.new(0, 5, 0, 40),
    BackgroundTransparency = 1,
    Name = "Buttons",
})

addLayout(PlateButtons, "Grid", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    CellSize = UDim2.new(0.48, -3, 0, 35),
    CellPadding = UDim2.new(0.04, 0, 0, 3),
})

local createdParts = {}

local function createPlatform(size, text)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        NotificationSystem.notify("No character found!", "Error")
        return
    end
    
    local part = Instance.new("Part")
    part.Size = Vector3.new(size, 1, size)
    part.CFrame = hrp.CFrame * CFrame.new(0, -3.5, 0)
    part.Transparency = 0.8
    part.Anchored = true
    part.BrickColor = BrickColor.new("Bright red")
    part.Parent = workspace
    
    table.insert(createdParts, part)
    NotificationSystem.notify(string.format("%s platform created!", text), "Success")
    
    HistorySystem:addAction({
        Type = "CreatePlatform",
        Data = {part = part, size = size},
        Undo = function()
            part:Destroy()
        end,
        Redo = function()
            -- Recreate would need to store more data
        end
    })
end

local function createStairs(direction)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for i = 1, 50 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(5, 0.5, 2)
        part.CFrame = hrp.CFrame * CFrame.new(0, i * 0.5 * direction - 3.5, -i * 0.5)
        part.Transparency = 0.8
        part.Anchored = true
        part.BrickColor = BrickColor.new("Bright red")
        part.Parent = workspace
        table.insert(createdParts, part)
    end
    
    NotificationSystem.notify("Stairs created!", "Success")
end

-- Create all platform buttons
local platformButtons = {
    {"Up /", function() createStairs(1) end},
    {"Down \\", function() createStairs(-1) end},
    {"Small", function() createPlatform(15, "Small") end},
    {"Big", function() createPlatform(40, "Big") end},
    {"Huge", function() createPlatform(100, "Huge") end},
    {"Giant", function() createPlatform(300, "Giant") end},
    {"H-Stairs", function() 
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for i = 1, 50 do
            local part = Instance.new("Part")
            part.Size = Vector3.new(5, 0.5, 2)
            part.CFrame = hrp.CFrame * CFrame.new(i * 0.5 - 3.5, 0, -i * 0.5)
            part.Transparency = 0.8
            part.Anchored = true
            part.BrickColor = BrickColor.new("Bright red")
            part.Parent = workspace
            table.insert(createdParts, part)
        end
        NotificationSystem.notify("Horizontal stairs created!", "Success")
    end},
    {"V-Stairs", function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for i = 1, 15 do
            local part = Instance.new("Part")
            part.Size = Vector3.new(5, 0.5, 5)
            part.CFrame = hrp.CFrame * CFrame.new(0, 2 - 3.5, 0)
            part.Transparency = 0.8
            part.Anchored = true
            part.BrickColor = BrickColor.new("Bright red")
            part.Parent = workspace
            table.insert(createdParts, part)
            if i ~= 15 then
                task.delay(0.8, function()
                    if part and part.Parent then
                        part:Destroy()
                    end
                end)
            end
            wait(0.4)
        end
        NotificationSystem.notify("Vertical stairs created!", "Success")
    end},
    {"Clear All", function()
        for _, part in ipairs(createdParts) do
            if part and part.Parent then
                part:Destroy()
            end
        end
        createdParts = {}
        NotificationSystem.notify("All platforms cleared!", "Warning")
    end},
}

for _, data in ipairs(platformButtons) do
    local btn = UIComponents.createButton(PlateButtons, {
        Text = data[1],
        TextSize = 11,
        BackgroundColor3 = CurrentTheme.Primary,
        Name = data[1],
    })
    addCorner(btn, UDim.new(0, 6))
    btn.MouseButton1Click:Connect(data[2])
end

CreateOpenButton("Plate", "🧱", function()
    PlateModule.Frame.Visible = true
    Animations.tween(PlateModule.Frame, {Size = UDim2.new(0, 220, 0, 200)}, 0.3):Play()
end)

-- ============================================================
-- SECTION 23: RECTP MODULE
-- ============================================================

local RecTPModule = {}
local RecTPGui = Instance.new("ScreenGui")
RecTPGui.Name = "RecTPGui"
RecTPGui.Parent = MainGui

RecTPModule.Frame = UIComponents.createFrame(RecTPGui, {
    Size = UDim2.new(0, 160, 0, 180),
    Position = UDim2.new(0.05, 0, 0.3, 0),
    BackgroundColor3 = CurrentTheme.Surface,
    Name = "RecTPFrame",
    Visible = false,
})
addCorner(RecTPModule.Frame, UDim.new(0, 12))
addStroke(RecTPModule.Frame, CurrentTheme.Border, 2)

DragSystem.makeDraggable(RecTPModule.Frame)

-- Header
local RecTPHeader = UIComponents.createFrame(RecTPModule.Frame, {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = CurrentTheme.Primary,
    Name = "Header",
})
addCorner(RecTPHeader, UDim.new(0, 12))

local RecTPTitle = UIComponents.createTextLabel(RecTPHeader, {
    Size = UDim2.new(1, -50, 1, 0),
    Text = "VIX | RecTP",
    TextSize = 12,
    Font = Enum.Font.GothamBold,
})

local RecTPClose = UIComponents.createButton(RecTPHeader, {
    Size = UDim2.new(0, 25, 0, 25),
    Position = UDim2.new(1, -30, 0.5, -12.5),
    Text = "✕",
    TextSize = 12,
    BackgroundColor3 = CurrentTheme.Error,
    Name = "Close",
})
addCorner(RecTPClose, UDim.new(0, 6))
RecTPClose.MouseButton1Click:Connect(function()
    RecTPModule.Frame.Visible = false
end)

-- Controls
local RecTPButtons = UIComponents.createFrame(RecTPModule.Frame, {
    Size = UDim2.new(1, -10, 1, -40),
    Position = UDim2.new(0, 5, 0, 35),
    BackgroundTransparency = 1,
    Name = "Buttons",
})

addLayout(RecTPButtons, "Grid", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    CellSize = UDim2.new(0.48, -3, 0, 28),
    CellPadding = UDim2.new(0.04, 0, 0, 3),
})

-- RecTP Logic
local isRecording = false
local points = {}
local teleportDelay = 1
local autoTeleport = false
local cycleEnabled = false

local function addPoint()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        table.insert(points, hrp.Position)
        NotificationSystem.notify("Point added! (" .. #points .. ")", "Info")
    end
end

local function teleportToPoints()
    for _, point in ipairs(points) do
        if autoTeleport and player.Character then
            player.Character:SetPrimaryPartCFrame(CFrame.new(point))
            wait(teleportDelay)
        end
    end
    
    if cycleEnabled then
        while cycleEnabled and autoTeleport do
            wait(1)
            for _, point in ipairs(points) do
                if autoTeleport and player.Character then
                    player.Character:SetPrimaryPartCFrame(CFrame.new(point))
                    wait(teleportDelay)
                end
            end
        end
    end
end

local recTPButtons = {
    {"Rec", function()
        isRecording = not isRecording
        local btn = RecTPButtons:FindFirstChild("Rec")
        if btn then
            btn.Text = isRecording and "Stop" or "Rec"
            btn.BackgroundColor3 = isRecording and CurrentTheme.Warning or CurrentTheme.Primary
        end
        NotificationSystem.notify(isRecording and "Recording started!" or "Recording stopped!", isRecording and "Info" or "Success")
    end},
    {"+", function() addPoint() end},
    {"-", function()
        table.remove(points)
        NotificationSystem.notify("Last point removed!", "Warning")
    end},
    {"▶", function()
        autoTeleport = true
        teleportToPoints()
    end},
    {"⏸", function() autoTeleport = false end},
    {"Loop", function()
        cycleEnabled = not cycleEnabled
        local btn = RecTPButtons:FindFirstChild("Loop")
        if btn then
            btn.BackgroundColor3 = cycleEnabled and CurrentTheme.Success or CurrentTheme.Primary
        end
        NotificationSystem.notify(cycleEnabled and "Loop enabled!" or "Loop disabled!", cycleEnabled and "Info" or "Warning")
    end},
    {"→👤", function()
        local players = Players:GetPlayers()
        if #players > 1 then
            local randomPlayer
            repeat
                randomPlayer = players[math.random(#players)]
            until randomPlayer ~= player
            
            local hrp = randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and player.Character then
                player.Character:SetPrimaryPartCFrame(CFrame.new(hrp.Position))
                NotificationSystem.notify("Teleported to random player!", "Success")
            end
        end
    end},
}

for _, data in ipairs(recTPButtons) do
    local btn = UIComponents.createButton(RecTPButtons, {
        Text = data[1],
        TextSize = 10,
        BackgroundColor3 = CurrentTheme.Primary,
        Name = data[1],
    })
    addCorner(btn, UDim.new(0, 6))
    btn.MouseButton1Click:Connect(data[2])
end

-- Delay input
local RecTPDelayLabel = UIComponents.createTextLabel(RecTPModule.Frame, {
    Size = UDim2.new(0, 40, 0, 20),
    Position = UDim2.new(0, 5, 1, -25),
    Text = "Delay:",
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local RecTPDelayInput = UIComponents.createTextBox(RecTPModule.Frame, {
    Size = UDim2.new(0, 50, 0, 20),
    Position = UDim2.new(0, 45, 1, -25),
    Text = "1",
    TextSize = 10,
})
addCorner(RecTPDelayInput, UDim.new(0, 4))
RecTPDelayInput.FocusLost:Connect(function()
    local val = tonumber(RecTPDelayInput.Text)
    if val then
        teleportDelay = val
        NotificationSystem.notify("Delay set to " .. val .. "s", "Info")
    end
end)

CreateOpenButton("RecTP", "📍", function()
    RecTPModule.Frame.Visible = true
    Animations.tween(RecTPModule.Frame, {Size = UDim2.new(0, 160, 0, 180)}, 0.3):Play()
end)

-- ============================================================
-- SECTION 24: SPEEDS MODULE
-- ============================================================

local SpeedsModule = {}
local SpeedsGui = Instance.new("ScreenGui")
SpeedsGui.Name = "SpeedsGui"
SpeedsGui.Parent = MainGui

SpeedsModule.Frame = UIComponents.createFrame(SpeedsGui, {
    Size = UDim2.new(0, 80, 0, 90),
    Position = UDim2.new(0.5, -40, 0.6, 0),
    BackgroundColor3 = CurrentTheme.Surface,
    Name = "SpeedsFrame",
    Visible = false,
})
addCorner(SpeedsModule.Frame, UDim.new(0, 12))
addStroke(SpeedsModule.Frame, CurrentTheme.Border, 2)

DragSystem.makeDraggable(SpeedsModule.Frame)

-- Header
local SpeedsHeader = UIComponents.createTextLabel(SpeedsModule.Frame, {
    Size = UDim2.new(1, 0, 0, 25),
    Text = "VIX | Speeds",
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    BackgroundColor3 = CurrentTheme.Primary,
})

-- Close button
local SpeedsClose = UIComponents.createButton(SpeedsModule.Frame, {
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(1, -25, 0, 3),
    Text = "✕",
    TextSize = 10,
    BackgroundColor3 = CurrentTheme.Error,
    Name = "Close",
})
addCorner(SpeedsClose, UDim.new(0, 5))
SpeedsClose.MouseButton1Click:Connect(function()
    SpeedsModule.Frame.Visible = false
end)

-- Speed display
local SpeedsLabel = UIComponents.createTextLabel(SpeedsModule.Frame, {
    Size = UDim2.new(1, -10, 0, 20),
    Position = UDim2.new(0, 5, 0, 28),
    Text = "Speed: 16",
    TextSize = 12,
    TextColor3 = CurrentTheme.Accent,
})

-- Speed input
local SpeedsInput = UIComponents.createTextBox(SpeedsModule.Frame, {
    Size = UDim2.new(1, -10, 0, 25),
    Position = UDim2.new(0, 5, 0, 50),
    Text = "25",
    TextSize = 11,
    PlaceholderText = "Enter speed...",
})
addCorner(SpeedsInput, UDim.new(0, 6))

-- Apply button
local SpeedsApply = UIComponents.createButton(SpeedsModule.Frame, {
    Size = UDim2.new(1, -10, 0, 25),
    Position = UDim2.new(0, 5, 0, 80),
    Text = "APPLY",
    TextSize = 11,
    BackgroundColor3 = CurrentTheme.Success,
    Name = "Apply",
})
addCorner(SpeedsApply, UDim.new(0, 6))

-- Speeds Logic
local initialSpeed = 16
local initialJumpPower = 50
local currentSpeed = initialSpeed
local currentJumpPower = initialJumpPower
local savedSpeed = initialSpeed
local savedJumpPower = initialJumpPower
local targetSpeed = initialSpeed
local targetJumpPower = initialJumpPower
local isCustomSpeed = false

SpeedsApply.MouseButton1Click:Connect(function()
    local speedValue = tonumber(SpeedsInput.Text)
    if speedValue and speedValue < initialSpeed then
        speedValue = 25
        SpeedsInput.Text = "25"
    end
    
    if isCustomSpeed then
        targetSpeed = initialSpeed
        targetJumpPower = initialJumpPower
        isCustomSpeed = false
        SpeedsApply.Text = "APPLY"
        SpeedsApply.BackgroundColor3 = CurrentTheme.Success
        NotificationSystem.notify("Speed reset to default!", "Info")
    else
        if speedValue and speedValue > 0 then
            savedSpeed = currentSpeed
            savedJumpPower = currentJumpPower
            targetSpeed = speedValue
            targetJumpPower = initialJumpPower + speedValue / 1.5
            isCustomSpeed = true
            SpeedsApply.Text = "RESET"
            SpeedsApply.BackgroundColor3 = CurrentTheme.Warning
            NotificationSystem.notify("Speed set to " .. speedValue .. "!", "Success")
        end
    end
end)

spawn(function()
    while wait() do
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = isCustomSpeed and targetSpeed or savedSpeed
            humanoid.JumpPower = isCustomSpeed and targetJumpPower or savedJumpPower
            currentSpeed = humanoid.WalkSpeed
            currentJumpPower = humanoid.JumpPower
            SpeedsLabel.Text = "Speed: " .. math.floor(humanoid.WalkSpeed)
        end
    end
end)

CreateOpenButton("Speeds", "⚡", function()
    SpeedsModule.Frame.Visible = true
    Animations.tween(SpeedsModule.Frame, {Size = UDim2.new(0, 80, 0, 90)}, 0.3):Play()
end)

-- ============================================================
-- SECTION 25: TPSAVE MODULE
-- ============================================================

local TPSaveModule = {}
local TPSaveGui = Instance.new("ScreenGui")
TPSaveGui.Name = "TPSaveGui"
TPSaveGui.Parent = MainGui

TPSaveModule.Frame = UIComponents.createFrame(TPSaveGui, {
    Size = UDim2.new(0, 80, 0, 100),
    Position = UDim2.new(0.5, -40, 0.4, 0),
    BackgroundColor3 = CurrentTheme.Surface,
    Name = "TPSaveFrame",
    Visible = false,
})
addCorner(TPSaveModule.Frame, UDim.new(0, 12))
addStroke(TPSaveModule.Frame, CurrentTheme.Border, 2)

DragSystem.makeDraggable(TPSaveModule.Frame)

-- Header
local TPSaveHeader = UIComponents.createTextLabel(TPSaveModule.Frame, {
    Size = UDim2.new(1, 0, 0, 25),
    Text = "VIX | TPSave",
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    BackgroundColor3 = CurrentTheme.Primary,
})

-- Close button
local TPSaveClose = UIComponents.createButton(TPSaveModule.Frame, {
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(1, -25, 0, 3),
    Text = "✕",
    TextSize = 10,
    BackgroundColor3 = CurrentTheme.Error,
    Name = "Close",
})
addCorner(TPSaveClose, UDim.new(0, 5))
TPSaveClose.MouseButton1Click:Connect(function()
    TPSaveModule.Frame.Visible = false
end)

-- Buttons
local TPSaveSave = UIComponents.createButton(TPSaveModule.Frame, {
    Size = UDim2.new(0.9, 0, 0, 25),
    Position = UDim2.new(0.05, 0, 0, 28),
    Text = "SAVE",
    TextSize = 11,
    BackgroundColor3 = CurrentTheme.Success,
    Name = "Save",
})
addCorner(TPSaveSave, UDim.new(0, 6))

local TPSaveTeleport = UIComponents.createButton(TPSaveModule.Frame, {
    Size = UDim2.new(0.9, 0, 0, 25),
    Position = UDim2.new(0.05, 0, 0, 56),
    Text = "TELEPORT",
    TextSize = 11,
    BackgroundColor3 = CurrentTheme.Primary,
    Name = "Teleport",
})
addCorner(TPSaveTeleport, UDim.new(0, 6))

local TPSaveAuto = UIComponents.createButton(TPSaveModule.Frame, {
    Size = UDim2.new(0.9, 0, 0, 25),
    Position = UDim2.new(0.05, 0, 0, 84),
    Text = "AUTO: OFF",
    TextSize = 10,
    BackgroundColor3 = CurrentTheme.Surface,
    Name = "Auto",
})
addCorner(TPSaveAuto, UDim.new(0, 6))

-- TPSave Logic
local savedPosition = nil
local autoTPEnabled = false

TPSaveSave.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        savedPosition = hrp.Position
        TPSaveSave.BackgroundColor3 = CurrentTheme.Success
        Animations.pulse(TPSaveSave, 1.1, 0.3)
        NotificationSystem.notify("Position saved!", "Success")
    end
end)

TPSaveTeleport.MouseButton1Click:Connect(function()
    if savedPosition and player.Character then
        player.Character:SetPrimaryPartCFrame(CFrame.new(savedPosition))
        Animations.shake(TPSaveModule.Frame, 3, 0.3)
        NotificationSystem.notify("Teleported!", "Success")
    else
        NotificationSystem.notify("No position saved!", "Error")
    end
end)

TPSaveAuto.MouseButton1Click:Connect(function()
    autoTPEnabled = not autoTPEnabled
    TPSaveAuto.Text = "AUTO: " .. (autoTPEnabled and "ON" or "OFF")
    TPSaveAuto.BackgroundColor3 = autoTPEnabled and CurrentTheme.Success or CurrentTheme.Surface
    Animations.pulse(TPSaveAuto, 1.1, 0.2)
    NotificationSystem.notify(autoTPEnabled and "Auto teleport enabled!" or "Auto teleport disabled!", autoTPEnabled and "Info" or "Warning")
end)

spawn(function()
    while wait(1) do
        if autoTPEnabled and savedPosition and player.Character then
            player.Character:SetPrimaryPartCFrame(CFrame.new(savedPosition))
        end
    end
end)

CreateOpenButton("TPSave", "💾", function()
    TPSaveModule.Frame.Visible = true
    Animations.tween(TPSaveModule.Frame, {Size = UDim2.new(0, 80, 0, 100)}, 0.3):Play()
end)

-- ============================================================
-- SECTION 26: UTILS MODULE
-- ============================================================

local UtilsModule = {}
local UtilsGui = Instance.new("ScreenGui")
UtilsGui.Name = "UtilsGui"
UtilsGui.Parent = MainGui

UtilsModule.Frame = UIComponents.createFrame(UtilsGui, {
    Size = UDim2.new(0, 200, 0, 250),
    Position = UDim2.new(0.3, 0, 0.3, 0),
    BackgroundColor3 = CurrentTheme.Surface,
    Name = "UtilsFrame",
    Visible = false,
})
addCorner(UtilsModule.Frame, UDim.new(0, 12))
addStroke(UtilsModule.Frame, CurrentTheme.Border, 2)

DragSystem.makeDraggable(UtilsModule.Frame)

-- Header
local UtilsHeader = UIComponents.createFrame(UtilsModule.Frame, {
    Size = UDim2.new(1, 0, 0, 35),
    BackgroundColor3 = CurrentTheme.Primary,
    Name = "Header",
})
addCorner(UtilsHeader, UDim.new(0, 12))

local UtilsTitle = UIComponents.createTextLabel(UtilsHeader, {
    Size = UDim2.new(1, -50, 1, 0),
    Text = "VIX | Utils",
    TextSize = 14,
    Font = Enum.Font.GothamBold,
})

local UtilsClose = UIComponents.createButton(UtilsHeader, {
    Size = UDim2.new(0, 25, 0, 25),
    Position = UDim2.new(1, -30, 0.5, -12.5),
    Text = "✕",
    TextSize = 14,
    BackgroundColor3 = CurrentTheme.Error,
    Name = "Close",
})
addCorner(UtilsClose, UDim.new(0, 6))
UtilsClose.MouseButton1Click:Connect(function()
    UtilsModule.Frame.Visible = false
end)

-- Utils content
local UtilsContent = UIComponents.createFrame(UtilsModule.Frame, {
    Size = UDim2.new(1, -10, 1, -45),
    Position = UDim2.new(0, 5, 0, 40),
    BackgroundTransparency = 1,
    Name = "Content",
})

addLayout(UtilsContent, "Grid", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    CellSize = UDim2.new(0.48, -3, 0, 35),
    CellPadding = UDim2.new(0.04, 0, 0, 3),
})

-- Utils Logic
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

-- Create utils buttons
local utilsButtons = {
    {"💡 FullBright", function()
        fullbrightEnabled = not fullbrightEnabled
        if fullbrightEnabled then
            if darkmodeEnabled then
                darkmodeEnabled = false
            end
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.Brightness = 2
            Lighting.FogEnd = 100000
            Lighting.ClockTime = 12
            NotificationSystem.notify("FullBright enabled!", "Success")
        else
            Lighting.Ambient = originalAmbient
            Lighting.OutdoorAmbient = originalOutdoorAmbient
            Lighting.Brightness = originalBrightness
            NotificationSystem.notify("FullBright disabled!", "Warning")
        end
    end},
    {"🧥 DarkMode", function()
        darkmodeEnabled = not darkmodeEnabled
        if darkmodeEnabled then
            if fullbrightEnabled then
                fullbrightEnabled = false
            end
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            Lighting.Brightness = 0
            Lighting.FogEnd = 10
            Lighting.FogColor = Color3.new(0, 0, 0)
            NotificationSystem.notify("DarkMode enabled!", "Success")
        else
            Lighting.Ambient = originalAmbient
            Lighting.OutdoorAmbient = originalOutdoorAmbient
            Lighting.Brightness = originalBrightness
            Lighting.FogEnd = originalFogEnd
            Lighting.FogColor = originalFogColor
            NotificationSystem.notify("DarkMode disabled!", "Warning")
        end
    end},
    {"-10 Grav", function()
        workspace.Gravity = math.max(0, workspace.Gravity - 10)
        NotificationSystem.notify("Gravity: " .. math.floor(workspace.Gravity), "Info")
    end},
    {"+10 Grav", function()
        workspace.Gravity = workspace.Gravity + 10
        NotificationSystem.notify("Gravity: " .. math.floor(workspace.Gravity), "Info")
    end},
    {"Grav Reset", function()
        workspace.Gravity = 196.2
        NotificationSystem.notify("Gravity reset!", "Info")
    end},
    {"X-Ray ON", function()
        xRayEnabled = not xRayEnabled
        if xRayEnabled then
            updateXRayObjects()
            for part, _ in pairs(xRayObjects) do
                if part and part.Parent then
                    part.Transparency = 0.7
                end
            end
            NotificationSystem.notify("X-Ray enabled!", "Success")
        else
            for part, trans in pairs(xRayObjects) do
                if part and part.Parent then
                    part.Transparency = trans
                end
            end
            NotificationSystem.notify("X-Ray disabled!", "Warning")
        end
    end},
    {"X-Ray Reset", function()
        for part, trans in pairs(xRayObjects) do
            if part and part.Parent then
                part.Transparency = trans
            end
        end
        xRayEnabled = false
        NotificationSystem.notify("X-Ray reset!", "Info")
    end},
    {"↑ Jump", function()
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            Animations.shake(UtilsModule.Frame, 2, 0.2)
        end
    end},
}

for _, data in ipairs(utilsButtons) do
    local btn = UIComponents.createButton(UtilsContent, {
        Text = data[1],
        TextSize = 10,
        BackgroundColor3 = CurrentTheme.Primary,
        Name = data[1],
    })
    addCorner(btn, UDim.new(0, 6))
    btn.MouseButton1Click:Connect(data[2])
end

CreateOpenButton("Utils", "🔧", function()
    UtilsModule.Frame.Visible = true
    Animations.tween(UtilsModule.Frame, {Size = UDim2.new(0, 200, 0, 250)}, 0.3):Play()
end)

-- ============================================================
-- SECTION 27: HOTKEYS REGISTRATION
-- ============================================================

-- Register global hotkeys
HotkeyManager:register(Enum.KeyCode.F, function()
    if VFlyModule.Frame.Visible then
        VFlyOnBtn.MouseButton1Click:Fire()
    end
end, "Toggle Fly")

HotkeyManager:register(Enum.KeyCode.G, function()
    ToggleButton.MouseButton1Click:Fire()
end, "Toggle GUI")

-- ============================================================
-- SECTION 28: INITIALIZATION COMPLETE
-- ============================================================

log("VIX Modules initialized successfully!")
NotificationSystem.notify("VIX Modules Loaded!", "Success", 3)

-- Print statistics
log(string.format("Modules loaded: %d", 7))
log(string.format("UI Components created: %d+", 100))
log(string.format("Total Lines: %d+", 2500))

-- ============================================================
-- SECTION 29: CLEANUP AND MAINTENANCE
-- ============================================================

-- Cleanup on character death
player.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        -- Reset fly if active
        if isFlying then
            VFlyOffBtn.MouseButton1Click:Fire()
        end
        
        -- Clear noclip
        if noclipEnabled then
            setNoclip(false)
        end
        
        log("Character died - cleanup performed")
    end)
end)

-- Cleanup on script termination
game:BindToClose(function()
    log("Script terminating - cleaning up...")
    
    -- Destroy all created parts
    for _, part in ipairs(createdParts) do
        if part and part.Parent then
            pcall(function() part:Destroy() end)
        end
    end
    
    -- Reset lighting
    Lighting.Ambient = originalAmbient
    Lighting.OutdoorAmbient = originalOutdoorAmbient
    Lighting.Brightness = originalBrightness
    Lighting.FogEnd = originalFogEnd
    Lighting.FogColor = originalFogColor
    
    -- Reset gravity
    workspace.Gravity = 196.2
    
    log("Cleanup complete")
end)

-- ============================================================
-- SECTION 30: DEBUG AND DEVELOPMENT TOOLS
-- ============================================================

if GlobalState.DebugMode then
    -- Create debug console
    local DebugConsole = UIComponents.createFrame(MainGui, {
        Size = UDim2.new(0, 300, 0, 150),
        Position = UDim2.new(0, 10, 1, -160),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        Name = "DebugConsole",
        Visible = false,
    })
    addCorner(DebugConsole, UDim.new(0, 8))
    
    local DebugTitle = UIComponents.createTextLabel(DebugConsole, {
        Size = UDim2.new(1, 0, 0, 25),
        Text = "DEBUG CONSOLE",
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        BackgroundColor3 = CurrentTheme.Surface,
    })
    
    local DebugOutput = UIComponents.createScrollingFrame(DebugConsole, {
        Size = UDim2.new(1, -10, 1, -35),
        Position = UDim2.new(0, 5, 0, 30),
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        ScrollBarThickness = 3,
        Name = "Output",
    })
    
    local function addDebugLine(text)
        local line = UIComponents.createTextLabel(DebugOutput, {
            Size = UDim2.new(1, 0, 0, 18),
            Text = "[" .. os.date("%H:%M:%S") .. "] " .. text,
            TextSize = 10,
            TextColor3 = Color3.fromRGB(150, 255, 150),
            TextXAlignment = Enum.TextXAlignment.Left,
            Name = "Line",
        })
    end
    
    -- Override log function for debug
    local originalLog = log
    function log(message, level)
        originalLog(message, level)
        if GlobalState.DebugMode and DebugOutput then
            addDebugLine("[" .. (level or "INFO") .. "] " .. message)
        end
    end
    
    -- Toggle debug with Ctrl+D
    UserInputService.InputBegan:Connect(function(input, processed)
        if input.KeyCode == Enum.KeyCode.D and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            DebugConsole.Visible = not DebugConsole.Visible
        end
    end)
end

-- ============================================================
-- SECTION 31: PERFORMANCE MONITORING
-- ============================================================

if GlobalState.PerformanceMode then
    spawn(function()
        local fps = 0
        local lastTime = tick()
        local frames = 0
        
        while wait(1) do
            frames = frames + 1
            local currentTime = tick()
            
            if currentTime - lastTime >= 1 then
                fps = frames
                frames = 0
                lastTime = currentTime
                
                if GlobalState.DebugMode then
                    log(string.format("FPS: %d | Parts: %d | Memory: %.2f MB", 
                        fps, 
                        #workspace:GetDescendants(), 
                        collectgarbage("count") / 1024
                    ))
                end
            end
        end
    end)
end

-- ============================================================
-- SECTION 32: FINAL CUSTOMIZATION OPTIONS
-- ============================================================

local CustomizationPanel = {}

function CustomizationPanel.setTheme(themeName)
    if Themes[themeName] then
        CurrentTheme = Themes[themeName]
        NotificationSystem.notify("Theme changed to " .. themeName, "Success")
        log("Theme changed to: " .. themeName)
    else
        warn("Theme not found: " .. themeName)
    end
end

function CustomizationPanel.setScale(scale)
    GlobalState.GlobalScale = clamp(scale, 0.5, 2.0)
    MainContainer.Size = UDim2.new(0, 220 * GlobalState.GlobalScale, 0, 600 * GlobalState.GlobalScale)
    NotificationSystem.notify("Scale: " .. round(GlobalState.GlobalScale * 100) .. "%", "Info")
end

function CustomizationPanel.toggleSound()
    GlobalState.SoundEnabled = not GlobalState.SoundEnabled
    NotificationSystem.notify("Sound " .. (GlobalState.SoundEnabled and "enabled" or "disabled"), "Info")
end

function CustomizationPanel.toggleDebug()
    GlobalState.DebugMode = not GlobalState.DebugMode
    NotificationSystem.notify("Debug mode " .. (GlobalState.DebugMode and "enabled" or "disabled"), "Info")
end

-- ============================================================
-- SECTION 33: DOCUMENTATION AND HELP
-- ============================================================

--[[
    VIX MODULES DOCUMENTATION
    ==========================
    
    Features:
    ---------
    1. VFly - Flight module with speed control
       - W/S for directional flight
       - LOOP for continuous movement
       - BOOST for speed burst
       
    2. Clips - Noclip and invisibility
       - NOCLIP - Phase through walls
       - RECLIP - Restore collision
       - INVIS - Make character untouchable
       - AUTO - Automatic noclip on respawn
       
    3. Plate - Platform and stairs generator
       - Multiple platform sizes
       - Up/Down stairs
       - Horizontal/Vertical stairs
       - Clear all function
       
    4. RecTP - Record and teleport
       - Record multiple points
       - Play through points
       - Loop functionality
       - Random player teleport
       
    5. Speeds - Walk speed modifier
       - Custom speed input
       - Automatic jump power adjustment
       - Reset to default
       
    6. TPSave - Position saver
       - Save current position
       - Teleport to saved position
       - Auto teleport loop
       
    7. Utils - Miscellaneous utilities
       - FullBright/DarkMode
       - Gravity control
       - X-Ray vision
       - Jump button
       
    Hotkeys:
    --------
    - F: Toggle fly
    - G: Toggle GUI
    - Ctrl+D: Debug console (if enabled)
    
    Tips:
    -----
    - All modules are draggable on mobile
    - Use toggle switches to enable/disable modules
    - Notifications show feedback for actions
    - History system tracks recent actions
    
]]

-- ============================================================
-- SECTION 34: END OF SCRIPT
-- ============================================================

print("========================================")
print("VIX MODULES - ULTIMATE EDITION")
print("========================================")
print("Creator: VIXIE")
print("Version: 3.0")
print("========================================")
print("Script loaded successfully!")
print("Total lines: 2500+")
print("========================================")

-- THE END --
