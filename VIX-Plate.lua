local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Header = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local HideButton = Instance.new("TextButton")
local ButtonsFrame = Instance.new("Frame")
local StairsFrame = Instance.new("Frame")
local PlatformsFrame = Instance.new("Frame")
local EffectsFrame = Instance.new("Frame")
local SettingsFrame = Instance.new("Frame")
local TabsFrame = Instance.new("Frame")
local TabButtons = {}

local createdObjects = {}
local platform = nil
local stairsUp = nil
local stairsDown = nil
local stairsLeft = nil
local stairsRight = nil
local stairs45Up = nil
local stairs45Down = nil
local stairsSpiral = nil
local platformSmall = nil
local platformMedium = nil
local platformLarge = nil
local platformXL = nil
local platformThin = nil
local platformLong = nil
local wallLeft = nil
local wallRight = nil
local rampUp = nil
local rampDown = nil
local rampLeft = nil
local rampRight = nil
local bridge = nil
local elevator = nil
local trapdoor = nil
local spawnPlatform = nil
local trailEffects = {}
local glowEffects = {}
local platformsArray = {}
local stairsArray = {}
local wallsArray = {}
local rampsArray = {}
local customObjects = {}

local settings = {
    transparency = 0.7,
    borderThickness = 4,
    platformHeight = -3.5,
    stairsLength = 200,
    stairsWidth = 5,
    stairsHeight = 0.5,
    autoFollow = true,
    showGrid = false,
    snapToGrid = false,
    gridSize = 5,
    theme = "red",
    lockToPlayer = true,
    showParticles = false,
    objectLimit = 100,
    autoClean = false,
    autoCleanTime = 60,
    keyboardMode = true,
    soundEnabled = true,
    animationSpeed = 0.25,
    glowIntensity = 1,
    trailLength = 10,
    platformSpeed = 1,
    elevatorSpeed = 5,
    mirrorMode = false,
    copyMode = false,
    pasteMode = false,
    selectedColor = Color3.fromRGB(255, 0, 0),
    selectedBrickColor = "Bright red"
}

local themes = {
    red = {
        primary = Color3.fromRGB(60, 0, 0),
        secondary = Color3.fromRGB(90, 0, 0),
        accent = Color3.fromRGB(170, 0, 0),
        button = Color3.fromRGB(175, 0, 0),
        buttonHover = Color3.fromRGB(200, 0, 0),
        border = Color3.fromRGB(255, 50, 50),
        text = Color3.fromRGB(255, 255, 255),
        gradient1 = Color3.fromRGB(80, 0, 0),
        gradient2 = Color3.fromRGB(50, 0, 0),
        glassBg = Color3.fromRGB(30, 0, 0),
        headerBg = Color3.fromRGB(100, 0, 0)
    },
    blue = {
        primary = Color3.fromRGB(0, 0, 60),
        secondary = Color3.fromRGB(0, 0, 90),
        accent = Color3.fromRGB(0, 0, 170),
        button = Color3.fromRGB(0, 0, 175),
        buttonHover = Color3.fromRGB(0, 0, 200),
        border = Color3.fromRGB(50, 50, 255),
        text = Color3.fromRGB(255, 255, 255),
        gradient1 = Color3.fromRGB(0, 0, 80),
        gradient2 = Color3.fromRGB(0, 0, 50),
        glassBg = Color3.fromRGB(0, 0, 30),
        headerBg = Color3.fromRGB(0, 0, 100)
    },
    green = {
        primary = Color3.fromRGB(0, 60, 0),
        secondary = Color3.fromRGB(0, 90, 0),
        accent = Color3.fromRGB(0, 170, 0),
        button = Color3.fromRGB(0, 175, 0),
        buttonHover = Color3.fromRGB(0, 200, 0),
        border = Color3.fromRGB(50, 255, 50),
        text = Color3.fromRGB(255, 255, 255),
        gradient1 = Color3.fromRGB(0, 80, 0),
        gradient2 = Color3.fromRGB(0, 50, 0),
        glassBg = Color3.fromRGB(0, 30, 0),
        headerBg = Color3.fromRGB(0, 100, 0)
    },
    purple = {
        primary = Color3.fromRGB(60, 0, 60),
        secondary = Color3.fromRGB(90, 0, 90),
        accent = Color3.fromRGB(170, 0, 170),
        button = Color3.fromRGB(175, 0, 175),
        buttonHover = Color3.fromRGB(200, 0, 200),
        border = Color3.fromRGB(255, 50, 255),
        text = Color3.fromRGB(255, 255, 255),
        gradient1 = Color3.fromRGB(80, 0, 80),
        gradient2 = Color3.fromRGB(50, 0, 50),
        glassBg = Color3.fromRGB(30, 0, 30),
        headerBg = Color3.fromRGB(100, 0, 100)
    },
    orange = {
        primary = Color3.fromRGB(60, 30, 0),
        secondary = Color3.fromRGB(90, 45, 0),
        accent = Color3.fromRGB(170, 85, 0),
        button = Color3.fromRGB(175, 87, 0),
        buttonHover = Color3.fromRGB(200, 100, 0),
        border = Color3.fromRGB(255, 150, 50),
        text = Color3.fromRGB(255, 255, 255),
        gradient1 = Color3.fromRGB(80, 40, 0),
        gradient2 = Color3.fromRGB(50, 25, 0),
        glassBg = Color3.fromRGB(30, 15, 0),
        headerBg = Color3.fromRGB(100, 50, 0)
    },
    cyan = {
        primary = Color3.fromRGB(0, 60, 60),
        secondary = Color3.fromRGB(0, 90, 90),
        accent = Color3.fromRGB(0, 170, 170),
        button = Color3.fromRGB(0, 175, 175),
        buttonHover = Color3.fromRGB(0, 200, 200),
        border = Color3.fromRGB(50, 255, 255),
        text = Color3.fromRGB(255, 255, 255),
        gradient1 = Color3.fromRGB(0, 80, 80),
        gradient2 = Color3.fromRGB(0, 50, 50),
        glassBg = Color3.fromRGB(0, 30, 30),
        headerBg = Color3.fromRGB(0, 100, 100)
    },
    white = {
        primary = Color3.fromRGB(60, 60, 60),
        secondary = Color3.fromRGB(90, 90, 90),
        accent = Color3.fromRGB(170, 170, 170),
        button = Color3.fromRGB(175, 175, 175),
        buttonHover = Color3.fromRGB(200, 200, 200),
        border = Color3.fromRGB(255, 255, 255),
        text = Color3.fromRGB(0, 0, 0),
        gradient1 = Color3.fromRGB(80, 80, 80),
        gradient2 = Color3.fromRGB(50, 50, 50),
        glassBg = Color3.fromRGB(30, 30, 30),
        headerBg = Color3.fromRGB(100, 100, 100)
    },
    black = {
        primary = Color3.fromRGB(40, 40, 40),
        secondary = Color3.fromRGB(60, 60, 60),
        accent = Color3.fromRGB(100, 100, 100),
        button = Color3.fromRGB(110, 110, 110),
        buttonHover = Color3.fromRGB(130, 130, 130),
        border = Color3.fromRGB(200, 200, 200),
        text = Color3.fromRGB(255, 255, 255),
        gradient1 = Color3.fromRGB(50, 50, 50),
        gradient2 = Color3.fromRGB(30, 30, 30),
        glassBg = Color3.fromRGB(20, 20, 20),
        headerBg = Color3.fromRGB(60, 60, 60)
    },
    gold = {
        primary = Color3.fromRGB(60, 50, 0),
        secondary = Color3.fromRGB(90, 75, 0),
        accent = Color3.fromRGB(170, 140, 0),
        button = Color3.fromRGB(175, 145, 0),
        buttonHover = Color3.fromRGB(200, 165, 0),
        border = Color3.fromRGB(255, 215, 0),
        text = Color3.fromRGB(255, 255, 255),
        gradient1 = Color3.fromRGB(80, 65, 0),
        gradient2 = Color3.fromRGB(50, 40, 0),
        glassBg = Color3.fromRGB(30, 25, 0),
        headerBg = Color3.fromRGB(100, 80, 0)
    },
    pink = {
        primary = Color3.fromRGB(60, 0, 30),
        secondary = Color3.fromRGB(90, 0, 45),
        accent = Color3.fromRGB(170, 0, 85),
        button = Color3.fromRGB(175, 0, 87),
        buttonHover = Color3.fromRGB(200, 0, 100),
        border = Color3.fromRGB(255, 50, 150),
        text = Color3.fromRGB(255, 255, 255),
        gradient1 = Color3.fromRGB(80, 0, 40),
        gradient2 = Color3.fromRGB(50, 0, 25),
        glassBg = Color3.fromRGB(30, 0, 15),
        headerBg = Color3.fromRGB(100, 0, 50)
    }
}

local currentTheme = themes[settings.theme]

local function makeCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
end

local function makeStroke(instance, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or currentTheme.border
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.Parent = instance
    return stroke
end

local function makeGradient(instance, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    gradient.Rotation = rotation or 90
    gradient.Parent = instance
    return gradient
end

local function addRedBorder(part)
    local topSurface = Instance.new("SurfaceGui", part)
    topSurface.Face = Enum.NormalId.Top
    local border = Instance.new("Frame", topSurface)
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundTransparency = 1
    local uiStroke = Instance.new("UIStroke", border)
    uiStroke.Color = currentTheme.border
    uiStroke.Thickness = settings.borderThickness
end

local function addGlow(part)
    local light = Instance.new("PointLight", part)
    light.Color = currentTheme.border
    light.Brightness = settings.glowIntensity
    light.Range = 10
    return light
end

local function addTrail(part)
    local trail = Instance.new("Trail", part)
    local a0 = Instance.new("Attachment", part)
    a0.Position = Vector3.new(0, 0.5, 0)
    local a1 = Instance.new("Attachment", part)
    a1.Position = Vector3.new(0, -0.5, 0)
    trail.Attachment0 = a0
    trail.Attachment1 = a1
    trail.Lifetime = settings.trailLength / 10
    trail.MinLength = 0.1
    trail.FaceCamera = true
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    return trail
end

local function addParticles(part)
    local particles = Instance.new("ParticleEmitter", part)
    particles.Color = ColorSequence.new(currentTheme.border)
    particles.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 0)
    })
    particles.Lifetime = NumberRange.new(0.5, 1)
    particles.Rate = 20
    particles.Speed = NumberRange.new(1, 3)
    particles.SpreadAngle = Vector2.new(360, 360)
    return particles
end

local function createObject(name, size, cframe, parent)
    local part = Instance.new("Part", parent or workspace)
    part.Name = name
    part.Size = size
    part.CFrame = cframe
    part.Transparency = settings.transparency
    part.Anchored = true
    part.BrickColor = BrickColor.new(settings.selectedBrickColor)
    addRedBorder(part)
    table.insert(createdObjects, part)
    table.insert(platformsArray, part)
    if settings.showParticles then
        addParticles(part)
    end
    if settings.glowIntensity > 0 then
        table.insert(glowEffects, addGlow(part))
    end
    if settings.trailLength > 0 then
        table.insert(trailEffects, addTrail(part))
    end
    return part
end

local function getPlayerHRP()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        return player.Character.HumanoidRootPart
    end
    return nil
end

local function getPlayerPosition()
    local hrp = getPlayerHRP()
    if hrp then
        return hrp.Position
    end
    return Vector3.new(0, 10, 0)
end

local function getPlayerCFrame()
    local hrp = getPlayerHRP()
    if hrp then
        return hrp.CFrame
    end
    return CFrame.new(0, 10, 0)
end

local function getLookDirection()
    local hrp = getPlayerHRP()
    if hrp then
        return hrp.CFrame.LookVector
    end
    return Vector3.new(0, 0, -1)
end

local function getRightDirection()
    local hrp = getPlayerHRP()
    if hrp then
        return hrp.CFrame.RightVector
    end
    return Vector3.new(1, 0, 0)
end

local function destroyObject(obj)
    if obj then
        obj:Destroy()
    end
end

local function clearAllObjects()
    for _, obj in ipairs(createdObjects) do
        destroyObject(obj)
    end
    createdObjects = {}
    platformsArray = {}
    stairsArray = {}
    wallsArray = {}
    rampsArray = {}
    for _, effect in ipairs(glowEffects) do
        destroyObject(effect)
    end
    glowEffects = {}
    for _, effect in ipairs(trailEffects) do
        destroyObject(effect)
    end
    trailEffects = {}
end

local function destroyStairsUp()
    if stairsUp then
        destroyObject(stairsUp)
        stairsUp = nil
    end
end

local function destroyStairsDown()
    if stairsDown then
        destroyObject(stairsDown)
        stairsDown = nil
    end
end

local function destroyStairsLeft()
    if stairsLeft then
        destroyObject(stairsLeft)
        stairsLeft = nil
    end
end

local function destroyStairsRight()
    if stairsRight then
        destroyObject(stairsRight)
        stairsRight = nil
    end
end

local function destroyStairs45Up()
    if stairs45Up then
        destroyObject(stairs45Up)
        stairs45Up = nil
    end
end

local function destroyStairs45Down()
    if stairs45Down then
        destroyObject(stairs45Down)
        stairs45Down = nil
    end
end

local function destroyStairsSpiral()
    if stairsSpiral then
        destroyObject(stairsSpiral)
        stairsSpiral = nil
    end
end

local function destroyAllStairs()
    destroyStairsUp()
    destroyStairsDown()
    destroyStairsLeft()
    destroyStairsRight()
    destroyStairs45Up()
    destroyStairs45Down()
    destroyStairsSpiral()
end

local function destroyPlatform()
    if platform then
        destroyObject(platform)
        platform = nil
    end
end

local function destroyPlatformSmall()
    if platformSmall then
        destroyObject(platformSmall)
        platformSmall = nil
    end
end

local function destroyPlatformMedium()
    if platformMedium then
        destroyObject(platformMedium)
        platformMedium = nil
    end
end

local function destroyPlatformLarge()
    if platformLarge then
        destroyObject(platformLarge)
        platformLarge = nil
    end
end

local function destroyPlatformXL()
    if platformXL then
        destroyObject(platformXL)
        platformXL = nil
    end
end

local function destroyPlatformThin()
    if platformThin then
        destroyObject(platformThin)
        platformThin = nil
    end
end

local function destroyPlatformLong()
    if platformLong then
        destroyObject(platformLong)
        platformLong = nil
    end
end

local function destroyAllPlatforms()
    destroyPlatform()
    destroyPlatformSmall()
    destroyPlatformMedium()
    destroyPlatformLarge()
    destroyPlatformXL()
    destroyPlatformThin()
    destroyPlatformLong()
end

local function destroyWallLeft()
    if wallLeft then
        destroyObject(wallLeft)
        wallLeft = nil
    end
end

local function destroyWallRight()
    if wallRight then
        destroyObject(wallRight)
        wallRight = nil
    end
end

local function destroyAllWalls()
    destroyWallLeft()
    destroyWallRight()
end

local function destroyRampUp()
    if rampUp then
        destroyObject(rampUp)
        rampUp = nil
    end
end

local function destroyRampDown()
    if rampDown then
        destroyObject(rampDown)
        rampDown = nil
    end
end

local function destroyRampLeft()
    if rampLeft then
        destroyObject(rampLeft)
        rampLeft = nil
    end
end

local function destroyRampRight()
    if rampRight then
        destroyObject(rampRight)
        rampRight = nil
    end
end

local function destroyAllRamps()
    destroyRampUp()
    destroyRampDown()
    destroyRampLeft()
    destroyRampRight()
end

local function destroyBridge()
    if bridge then
        destroyObject(bridge)
        bridge = nil
    end
end

local function destroyElevator()
    if elevator then
        destroyObject(elevator)
        elevator = nil
    end
end

local function destroyTrapdoor()
    if trapdoor then
        destroyObject(trapdoor)
        trapdoor = nil
    end
end

local function destroySpawnPlatform()
    if spawnPlatform then
        destroyObject(spawnPlatform)
        spawnPlatform = nil
    end
end

local function destroyAllCustomObjects()
    for _, obj in ipairs(customObjects) do
        destroyObject(obj)
    end
    customObjects = {}
end

local function createStairsUp()
    if stairsUp then
        destroyStairsUp()
        return
    end
    destroyStairsDown()
    destroyStairsLeft()
    destroyStairsRight()
    destroyStairs45Up()
    destroyStairs45Down()
    destroyStairsSpiral()
    local model = Instance.new("Model", workspace)
    stairsUp = model
    local part = Instance.new("Part", model)
    part.Name = "StairsUp"
    part.Size = Vector3.new(settings.stairsWidth, settings.stairsHeight, settings.stairsLength)
    part.Transparency = settings.transparency
    part.Anchored = true
    part.BrickColor = BrickColor.new(settings.selectedBrickColor)
    addRedBorder(part)
    table.insert(createdObjects, part)
    table.insert(stairsArray, part)
    local hrpPos = getPlayerPosition()
    local lookDir = getLookDirection()
    local endPos = hrpPos + lookDir * (settings.stairsLength / 2)
    part.CFrame = CFrame.lookAt(hrpPos + Vector3.new(0, settings.platformHeight, 0), endPos) * CFrame.Angles(math.rad(90), 0, math.rad(-45))
end

local function createStairsDown()
    if stairsDown then
        destroyStairsDown()
        return
    end
    destroyStairsUp()
    destroyStairsLeft()
    destroyStairsRight()
    destroyStairs45Up()
    destroyStairs45Down()
    destroyStairsSpiral()
    local model = Instance.new("Model", workspace)
    stairsDown = model
    local part = Instance.new("Part", model)
    part.Name = "StairsDown"
    part.Size = Vector3.new(settings.stairsWidth, settings.stairsHeight, settings.stairsLength)
    part.Transparency = settings.transparency
    part.Anchored = true
    part.BrickColor = BrickColor.new(settings.selectedBrickColor)
    addRedBorder(part)
    table.insert(createdObjects, part)
    table.insert(stairsArray, part)
    local hrpPos = getPlayerPosition()
    local lookDir = getLookDirection()
    local endPos = hrpPos - lookDir * (settings.stairsLength / 2)
    part.CFrame = CFrame.lookAt(hrpPos + Vector3.new(0, settings.platformHeight, 0), endPos) * CFrame.Angles(math.rad(90), 0, math.rad(45))
end

local function createStairsLeft()
    if stairsLeft then
        destroyStairsLeft()
        return
    end
    destroyStairsUp()
    destroyStairsDown()
    destroyStairsRight()
    destroyStairs45Up()
    destroyStairs45Down()
    destroyStairsSpiral()
    local model = Instance.new("Model", workspace)
    stairsLeft = model
    local part = Instance.new("Part", model)
    part.Name = "StairsLeft"
    part.Size = Vector3.new(settings.stairsWidth, settings.stairsHeight, settings.stairsLength)
    part.Transparency = settings.transparency
    part.Anchored = true
    part.BrickColor = BrickColor.new(settings.selectedBrickColor)
    addRedBorder(part)
    table.insert(createdObjects, part)
    table.insert(stairsArray, part)
    local hrpPos = getPlayerPosition()
    local rightDir = getRightDirection()
    local endPos = hrpPos - rightDir * (settings.stairsLength / 2)
    part.CFrame = CFrame.lookAt(hrpPos + Vector3.new(0, settings.platformHeight, 0), endPos) * CFrame.Angles(math.rad(90), math.rad(90), math.rad(-45))
end

local function createStairsRight()
    if stairsRight then
        destroyStairsRight()
        return
    end
    destroyStairsUp()
    destroyStairsDown()
    destroyStairsLeft()
    destroyStairs45Up()
    destroyStairs45Down()
    destroyStairsSpiral()
    local model = Instance.new("Model", workspace)
    stairsRight = model
    local part = Instance.new("Part", model)
    part.Name = "StairsRight"
    part.Size = Vector3.new(settings.stairsWidth, settings.stairsHeight, settings.stairsLength)
    part.Transparency = settings.transparency
    part.Anchored = true
    part.BrickColor = BrickColor.new(settings.selectedBrickColor)
    addRedBorder(part)
    table.insert(createdObjects, part)
    table.insert(stairsArray, part)
    local hrpPos = getPlayerPosition()
    local rightDir = getRightDirection()
    local endPos = hrpPos + rightDir * (settings.stairsLength / 2)
    part.CFrame = CFrame.lookAt(hrpPos + Vector3.new(0, settings.platformHeight, 0), endPos) * CFrame.Angles(math.rad(90), math.rad(-90), math.rad(-45))
end

local function createStairs45Up()
    if stairs45Up then
        destroyStairs45Up()
        return
    end
    destroyStairsUp()
    destroyStairsDown()
    destroyStairsLeft()
    destroyStairsRight()
    destroyStairs45Down()
    destroyStairsSpiral()
    local model = Instance.new("Model", workspace)
    stairs45Up = model
    local part = Instance.new("Part", model)
    part.Name = "Stairs45Up"
    part.Size = Vector3.new(settings.stairsWidth, settings.stairsHeight, settings.stairsLength)
    part.Transparency = settings.transparency
    part.Anchored = true
    part.BrickColor = BrickColor.new(settings.selectedBrickColor)
    addRedBorder(part)
    table.insert(createdObjects, part)
    table.insert(stairsArray, part)
    local hrpPos = getPlayerPosition()
    local lookDir = getLookDirection()
    local rightDir = getRightDirection()
    local diagonalDir = (lookDir + rightDir).Unit
    local endPos = hrpPos + diagonalDir * (settings.stairsLength / 2)
    part.CFrame = CFrame.lookAt(hrpPos + Vector3.new(0, settings.platformHeight, 0), endPos) * CFrame.Angles(math.rad(90), 0, math.rad(-45))
end

local function createStairs45Down()
    if stairs45Down then
        destroyStairs45Down()
        return
    end
    destroyStairsUp()
    destroyStairsDown()
    destroyStairsLeft()
    destroyStairsRight()
    destroyStairs45Up()
    destroyStairsSpiral()
    local model = Instance.new("Model", workspace)
    stairs45Down = model
    local part = Instance.new("Part", model)
    part.Name = "Stairs45Down"
    part.Size = Vector3.new(settings.stairsWidth, settings.stairsHeight, settings.stairsLength)
    part.Transparency = settings.transparency
    part.Anchored = true
    part.BrickColor = BrickColor.new(settings.selectedBrickColor)
    addRedBorder(part)
    table.insert(createdObjects, part)
    table.insert(stairsArray, part)
    local hrpPos = getPlayerPosition()
    local lookDir = getLookDirection()
    local rightDir = getRightDirection()
    local diagonalDir = (lookDir - rightDir).Unit
    local endPos = hrpPos + diagonalDir * (settings.stairsLength / 2)
    part.CFrame = CFrame.lookAt(hrpPos + Vector3.new(0, settings.platformHeight, 0), endPos) * CFrame.Angles(math.rad(90), 0, math.rad(-45))
end

local function createStairsSpiral()
    if stairsSpiral then
        destroyStairsSpiral()
        return
    end
    destroyStairsUp()
    destroyStairsDown()
    destroyStairsLeft()
    destroyStairsRight()
    destroyStairs45Up()
    destroyStairs45Down()
    local model = Instance.new("Model", workspace)
    stairsSpiral = model
    local steps = 20
    local radius = 10
    local heightPerStep = 2
    for i = 1, steps do
        local angle = (i / steps) * math.pi * 2
        local x = math.cos(angle) * radius
        local z = math.sin(angle) * radius
        local y = i * heightPerStep
        local part = Instance.new("Part", model)
        part.Name = "SpiralStep" .. i
        part.Size = Vector3.new(5, 0.5, 5)
        part.Transparency = settings.transparency
        part.Anchored = true
        part.BrickColor = BrickColor.new(settings.selectedBrickColor)
        addRedBorder(part)
        table.insert(createdObjects, part)
        table.insert(stairsArray, part)
        local hrpPos = getPlayerPosition()
        part.CFrame = CFrame.new(hrpPos.X + x, hrpPos.Y + y + settings.platformHeight, hrpPos.Z + z)
    end
end

local function createPlatformFollowing(size)
    destroyPlatform()
    local hrp = getPlayerHRP()
    if not hrp then return end
    local part = Instance.new("Part", workspace)
    part.Name = "PlatformFollowing"
    part.Size = size
    part.Transparency = settings.transparency
    part.Anchored = true
    part.BrickColor = BrickColor.new(settings.selectedBrickColor)
    addRedBorder(part)
    platform = part
    table.insert(createdObjects, part)
    table.insert(platformsArray, part)
    local baseY = hrp.Position.Y + settings.platformHeight
    part.CFrame = CFrame.new(hrp.Position.X, baseY, hrp.Position.Z)
    if settings.showParticles then
        addParticles(part)
    end
    local runService = game:GetService("RunService")
    local connection
    connection = runService.Heartbeat:Connect(function()
        if platform and getPlayerHRP() then
            local currentHRP = getPlayerHRP()
            if settings.lockToPlayer then
                part.CFrame = CFrame.new(currentHRP.Position.X, baseY, currentHRP.Position.Z)
            else
                platform = nil
                connection:Disconnect()
            end
        else
            platform = nil
            connection:Disconnect()
        end
    end)
end

local function createPlatformSmall()
    if platformSmall then
        destroyPlatformSmall()
        return
    end
    destroyPlatformMedium()
    destroyPlatformLarge()
    destroyPlatformXL()
    destroyPlatformThin()
    destroyPlatformLong()
    local hrp = getPlayerHRP()
    if not hrp then return end
    local part = createObject("PlatformSmall", Vector3.new(15, 1, 15), CFrame.new(hrp.Position.X, hrp.Position.Y + settings.platformHeight, hrp.Position.Z))
    platformSmall = part
    local runService = game:GetService("RunService")
    local connection
    connection = runService.Heartbeat:Connect(function()
        if platformSmall and getPlayerHRP() then
            local currentHRP = getPlayerHRP()
            part.CFrame = CFrame.new(currentHRP.Position.X, part.Position.Y, currentHRP.Position.Z)
        else
            platformSmall = nil
            connection:Disconnect()
        end
    end)
end

local function createPlatformMedium()
    if platformMedium then
        destroyPlatformMedium()
        return
    end
    destroyPlatformSmall()
    destroyPlatformLarge()
    destroyPlatformXL()
    destroyPlatformThin()
    destroyPlatformLong()
    local hrp = getPlayerHRP()
    if not hrp then return end
    local part = createObject("PlatformMedium", Vector3.new(25, 1, 25), CFrame.new(hrp.Position.X, hrp.Position.Y + settings.platformHeight, hrp.Position.Z))
    platformMedium = part
    local runService = game:GetService("RunService")
    local connection
    connection = runService.Heartbeat:Connect(function()
        if platformMedium and getPlayerHRP() then
            local currentHRP = getPlayerHRP()
            part.CFrame = CFrame.new(currentHRP.Position.X, part.Position.Y, currentHRP.Position.Z)
        else
            platformMedium = nil
            connection:Disconnect()
        end
    end)
end

local function createPlatformLarge()
    if platformLarge then
        destroyPlatformLarge()
        return
    end
    destroyPlatformSmall()
    destroyPlatformMedium()
    destroyPlatformXL()
    destroyPlatformThin()
    destroyPlatformLong()
    local hrp = getPlayerHRP()
    if not hrp then return end
    local part = createObject("PlatformLarge", Vector3.new(40, 1, 40), CFrame.new(hrp.Position.X, hrp.Position.Y + settings.platformHeight, hrp.Position.Z))
    platformLarge = part
    local runService = game:GetService("RunService")
    local connection
    connection = runService.Heartbeat:Connect(function()
        if platformLarge and getPlayerHRP() then
            local currentHRP = getPlayerHRP()
            part.CFrame = CFrame.new(currentHRP.Position.X, part.Position.Y, currentHRP.Position.Z)
        else
            platformLarge = nil
            connection:Disconnect()
        end
    end)
end

local function createPlatformXL()
    if platformXL then
        destroyPlatformXL()
        return
    end
    destroyPlatformSmall()
    destroyPlatformMedium()
    destroyPlatformLarge()
    destroyPlatformThin()
    destroyPlatformLong()
    local hrp = getPlayerHRP()
    if not hrp then return end
    local part = createObject("PlatformXL", Vector3.new(60, 1, 60), CFrame.new(hrp.Position.X, hrp.Position.Y + settings.platformHeight, hrp.Position.Z))
    platformXL = part
    local runService = game:GetService("RunService")
    local connection
    connection = runService.Heartbeat:Connect(function()
        if platformXL and getPlayerHRP() then
            local currentHRP = getPlayerHRP()
            part.CFrame = CFrame.new(currentHRP.Position.X, part.Position.Y, currentHRP.Position.Z)
        else
            platformXL = nil
            connection:Disconnect()
        end
    end)
end

local function createPlatformThin()
    if platformThin then
        destroyPlatformThin()
        return
    end
    destroyPlatformSmall()
    destroyPlatformMedium()
    destroyPlatformLarge()
    destroyPlatformXL()
    destroyPlatformLong()
    local hrp = getPlayerHRP()
    if not hrp then return end
    local part = createObject("PlatformThin", Vector3.new(20, 0.2, 20), CFrame.new(hrp.Position.X, hrp.Position.Y + settings.platformHeight, hrp.Position.Z))
    platformThin = part
    local runService = game:GetService("RunService")
    local connection
    connection = runService.Heartbeat:Connect(function()
        if platformThin and getPlayerHRP() then
            local currentHRP = getPlayerHRP()
            part.CFrame = CFrame.new(currentHRP.Position.X, part.Position.Y, currentHRP.Position.Z)
        else
            platformThin = nil
            connection:Disconnect()
        end
    end)
end

local function createPlatformLong()
    if platformLong then
        destroyPlatformLong()
        return
    end
    destroyPlatformSmall()
    destroyPlatformMedium()
    destroyPlatformLarge()
    destroyPlatformXL()
    destroyPlatformThin()
    local hrp = getPlayerHRP()
    if not hrp then return end
    local part = createObject("PlatformLong", Vector3.new(100, 1, 10), CFrame.new(hrp.Position.X, hrp.Position.Y + settings.platformHeight, hrp.Position.Z))
    platformLong = part
    local runService = game:GetService("RunService")
    local connection
    connection = runService.Heartbeat:Connect(function()
        if platformLong and getPlayerHRP() then
            local currentHRP = getPlayerHRP()
            part.CFrame = CFrame.new(currentHRP.Position.X, part.Position.Y, currentHRP.Position.Z)
        else
            platformLong = nil
            connection:Disconnect()
        end
    end)
end

local function createWallLeft()
    if wallLeft then
        destroyWallLeft()
        return
    end
    destroyWallRight()
    local hrp = getPlayerHRP()
    if not hrp then return end
    local rightDir = getRightDirection()
    local wallPos = hrp.Position - rightDir * 10
    local part = createObject("WallLeft", Vector3.new(1, 20, 10), CFrame.new(wallPos.X, wallPos.Y + 10, wallPos.Z))
    wallLeft = part
end

local function createWallRight()
    if wallRight then
        destroyWallRight()
        return
    end
    destroyWallLeft()
    local hrp = getPlayerHRP()
    if not hrp then return end
    local rightDir = getRightDirection()
    local wallPos = hrp.Position + rightDir * 10
    local part = createObject("WallRight", Vector3.new(1, 20, 10), CFrame.new(wallPos.X, wallPos.Y + 10, wallPos.Z))
    wallRight = part
end

local function createRampUp()
    if rampUp then
        destroyRampUp()
        return
    end
    destroyRampDown()
    destroyRampLeft()
    destroyRampRight()
    local hrp = getPlayerHRP()
    if not hrp then return end
    local lookDir = getLookDirection()
    local part = createObject("RampUp", Vector3.new(10, 0.5, 15), CFrame.new(hrp.Position.X, hrp.Position.Y + settings.platformHeight + 2.5, hrp.Position.Z) * CFrame.Angles(math.rad(-30), 0, 0))
    rampUp = part
end

local function createRampDown()
    if rampDown then
        destroyRampDown()
        return
    end
    destroyRampUp()
    destroyRampLeft()
    destroyRampRight()
    local hrp = getPlayerHRP()
    if not hrp then return end
    local part = createObject("RampDown", Vector3.new(10, 0.5, 15), CFrame.new(hrp.Position.X, hrp.Position.Y + settings.platformHeight + 2.5, hrp.Position.Z) * CFrame.Angles(math.rad(30), 0, 0))
    rampDown = part
end

local function createRampLeft()
    if rampLeft then
        destroyRampLeft()
        return
    end
    destroyRampUp()
    destroyRampDown()
    destroyRampRight()
    local hrp = getPlayerHRP()
    if not hrp then return end
    local part = createObject("RampLeft", Vector3.new(10, 0.5, 15), CFrame.new(hrp.Position.X, hrp.Position.Y + settings.platformHeight + 2.5, hrp.Position.Z) * CFrame.Angles(0, math.rad(90), math.rad(-30)))
    rampLeft = part
end

local function createRampRight()
    if rampRight then
        destroyRampRight()
        return
    end
    destroyRampUp()
    destroyRampDown()
    destroyRampLeft()
    local hrp = getPlayerHRP()
    if not hrp then return end
    local part = createObject("RampRight", Vector3.new(10, 0.5, 15), CFrame.new(hrp.Position.X, hrp.Position.Y + settings.platformHeight + 2.5, hrp.Position.Z) * CFrame.Angles(0, math.rad(-90), math.rad(-30)))
    rampRight = part
end

local function createBridge()
    if bridge then
        destroyBridge()
        return
    end
    local hrp = getPlayerHRP()
    if not hrp then return end
    local lookDir = getLookDirection()
    local bridgeLength = 50
    local bridgeWidth = 8
    local part = createObject("Bridge", Vector3.new(bridgeWidth, 0.5, bridgeLength), CFrame.new(hrp.Position.X, hrp.Position.Y + settings.platformHeight, hrp.Position.Z + bridgeLength/2) * CFrame.Angles(0, 0, 0))
    bridge = part
    for i = 1, 5 do
        local sidePart = createObject("BridgeSide" .. i, Vector3.new(0.5, 2, bridgeLength), CFrame.new(hrp.Position.X + (i <= 3 and -1 or 1) * (bridgeWidth/2 + 0.25), hrp.Position.Y + settings.platformHeight + 1, hrp.Position.Z + bridgeLength/2))
        table.insert(customObjects, sidePart)
    end
end

local function createElevator()
    if elevator then
        destroyElevator()
        return
    end
    local hrp = getPlayerHRP()
    if not hrp then return end
    local part = createObject("Elevator", Vector3.new(15, 1, 15), CFrame.new(hrp.Position.X, hrp.Position.Y + settings.platformHeight, hrp.Position.Z))
    elevator = part
    local runService = game:GetService("RunService")
    local goingUp = true
    local baseY = hrp.Position.Y + settings.platformHeight
    local connection
    connection = runService.Heartbeat:Connect(function()
        if elevator then
            local currentY = elevator.Position.Y
            if goingUp then
                elevator.CFrame = CFrame.new(elevator.Position.X, currentY + settings.elevatorSpeed * 0.016, elevator.Position.Z)
                if currentY > baseY + 50 then
                    goingUp = false
                end
            else
                elevator.CFrame = CFrame.new(elevator.Position.X, currentY - settings.elevatorSpeed * 0.016, elevator.Position.Z)
                if currentY < baseY - 50 then
                    goingUp = true
                end
            end
        else
            connection:Disconnect()
        end
    end)
end

local function createTrapdoor()
    if trapdoor then
        destroyTrapdoor()
        return
    end
    local hrp = getPlayerHRP()
    if not hrp then return end
    local part = createObject("Trapdoor", Vector3.new(10, 0.5, 10), CFrame.new(hrp.Position.X, hrp.Position.Y + settings.platformHeight, hrp.Position.Z))
    trapdoor = part
    task.delay(3, function()
        if trapdoor then
            trapdoor.Transparency = 1
            task.delay(2, function()
                if trapdoor then
                    trapdoor.Transparency = settings.transparency
                end
            end)
        end
    end)
end

local function createSpawnPlatform()
    if spawnPlatform then
        destroySpawnPlatform()
        return
    end
    local hrp = getPlayerHRP()
    if not hrp then return end
    local part = createObject("SpawnPlatform", Vector3.new(20, 1, 20), CFrame.new(hrp.Position.X, hrp.Position.Y + settings.platformHeight - 1, hrp.Position.Z))
    spawnPlatform = part
    local spawnLight = Instance.new("SpawnLocation", workspace)
    spawnLight.Size = Vector3.new(8, 1, 8)
    spawnLight.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y + settings.platformHeight + 0.5, hrp.Position.Z)
    spawnLight.Anchored = true
    spawnLight.BrickColor = BrickColor.new(settings.selectedBrickColor)
    spawnLight.Transparency = settings.transparency
    table.insert(createdObjects, spawnLight)
    table.insert(customObjects, spawnLight)
end

local function mirrorAllObjects()
    for _, obj in ipairs(createdObjects) do
        if obj and obj:IsA("BasePart") then
            local newCFrame = obj.CFrame * CFrame.new(0, 0, 0) * CFrame.Angles(0, math.pi, 0)
            local newObj = obj:Clone()
            newObj.CFrame = newCFrame
            newObj.Parent = workspace
            table.insert(createdObjects, newObj)
        end
    end
end

local function scaleAllObjects(scale)
    for _, obj in ipairs(createdObjects) do
        if obj and obj:IsA("BasePart") then
            obj.Size = obj.Size * scale
        end
    end
end

local function rotateAllObjects(angle)
    for _, obj in ipairs(createdObjects) do
        if obj and obj:IsA("BasePart") then
            obj.CFrame = obj.CFrame * CFrame.Angles(0, math.rad(angle), 0)
        end
    end
end

local function teleportAllObjects(offset)
    for _, obj in ipairs(createdObjects) do
        if obj and obj:IsA("BasePart") then
            obj.CFrame = obj.CFrame + offset
        end
    end
end

local function createGridFloor()
    local gridSize = settings.gridSize
    local gridModel = Instance.new("Model", workspace)
    gridModel.Name = "GridFloor"
    for x = -50, 50, gridSize do
        for z = -50, 50, gridSize do
            local gridPart = Instance.new("Part", gridModel)
            gridPart.Size = Vector3.new(0.1, 0.1, gridSize)
            gridPart.CFrame = CFrame.new(x, -0.05, z)
            gridPart.Transparency = 0.7
            gridPart.Anchored = true
            gridPart.BrickColor = BrickColor.new("Dark stone grey")
            gridPart.CanCollide = false
            table.insert(createdObjects, gridPart)
        end
    end
    return gridModel
end

local function destroyGridFloor()
    local grid = workspace:FindFirstChild("GridFloor")
    if grid then
        grid:Destroy()
        for i = #createdObjects, 1, -1 do
            if createdObjects[i] and createdObjects[i].Name:find("Grid") then
                table.remove(createdObjects, i)
            end
        end
    end
end

ScreenGui.Name = "VIX Plate"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = currentTheme.primary
MainFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Draggable = true
MainFrame.Active = true
makeCorner(MainFrame, 12)
makeStroke(MainFrame, currentTheme.border, 2, 0.3)

local glassBg = Instance.new("Frame", MainFrame)
glassBg.Size = UDim2.new(1, 0, 1, 0)
glassBg.BackgroundColor3 = currentTheme.glassBg
glassBg.BackgroundTransparency = 0.2
makeCorner(glassBg, 12)
makeGradient(glassBg, currentTheme.gradient1, currentTheme.gradient2, 90)

Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = currentTheme.headerBg
Header.Size = UDim2.new(0, 90, 0, 45)
Header.Position = UDim2.new(1, -95, 0, 5)
Header.BackgroundTransparency = 0.2
makeCorner(Header, 8)
makeGradient(Header, Color3.fromRGB(140, 0, 0), Color3.fromRGB(80, 0, 0), 90)
makeStroke(Header, currentTheme.border, 1, 0.4)

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

CloseButton.Name = "CloseButton"
CloseButton.Parent = Header
CloseButton.Size = UDim2.new(0, 36, 0, 36)
CloseButton.Position = UDim2.new(1, -41, 0.5, -18)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
CloseButton.TextColor3 = currentTheme.text
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.AutoButtonColor = true
makeCorner(CloseButton, 6)
makeStroke(CloseButton, currentTheme.border, 1, 0.5)

HideButton.Name = "HideButton"
HideButton.Parent = Header
HideButton.Size = UDim2.new(0, 36, 0, 36)
HideButton.Position = UDim2.new(1, -83, 0.5, -18)
HideButton.BackgroundColor3 = Color3.fromRGB(130, 0, 0)
HideButton.TextColor3 = currentTheme.text
HideButton.Text = "<"
HideButton.Font = Enum.Font.SourceSansBold
HideButton.TextSize = 18
HideButton.AutoButtonColor = true
makeCorner(HideButton, 6)
makeStroke(HideButton, currentTheme.border, 1, 0.5)

TabsFrame.Name = "TabsFrame"
TabsFrame.Parent = MainFrame
TabsFrame.Size = UDim2.new(0, 340, 0, 35)
TabsFrame.Position = UDim2.new(0, 5, 0, 5)
TabsFrame.BackgroundTransparency = 1

local function createTabButton(name, text, posX)
    local btn = Instance.new("TextButton", TabsFrame)
    btn.Name = name
    btn.Size = UDim2.new(0, 65, 0, 30)
    btn.Position = UDim2.new(0, posX, 0, 0)
    btn.BackgroundColor3 = currentTheme.button
    btn.TextColor3 = currentTheme.text
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 10
    btn.AutoButtonColor = true
    makeCorner(btn, 6)
    makeStroke(btn, currentTheme.border, 1, 0.6)
    return btn
end

local tabStairs = createTabButton("TabStairs", "STAIRS", 0)
local tabPlatforms = createTabButton("TabPlatforms", "PLAT", 70)
local tabWalls = createTabButton("TabWalls", "WALLS", 140)
local tabRamps = createTabButton("TabRamps", "RAMPS", 210)
local tabEffects = createTabButton("TabEffects", "FX", 280)

ButtonsFrame.Name = "ButtonsFrame"
ButtonsFrame.Parent = MainFrame
ButtonsFrame.Size = UDim2.new(0, 340, 0, 355)
ButtonsFrame.Position = UDim2.new(0, 5, 0, 45)
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.ClipsDescendants = true

StairsFrame.Name = "StairsFrame"
StairsFrame.Parent = ButtonsFrame
StairsFrame.Size = UDim2.new(1, -10, 0, 355)
StairsFrame.Position = UDim2.new(0, 5, 0, 0)
StairsFrame.BackgroundTransparency = 1
StairsFrame.Visible = true

PlatformsFrame.Name = "PlatformsFrame"
PlatformsFrame.Parent = ButtonsFrame
PlatformsFrame.Size = UDim2.new(1, -10, 0, 355)
PlatformsFrame.Position = UDim2.new(0, 5, 0, 0)
PlatformsFrame.BackgroundTransparency = 1
PlatformsFrame.Visible = false

EffectsFrame.Name = "EffectsFrame"
EffectsFrame.Parent = ButtonsFrame
EffectsFrame.Size = UDim2.new(1, -10, 0, 355)
EffectsFrame.Position = UDim2.new(0, 5, 0, 0)
EffectsFrame.BackgroundTransparency = 1
EffectsFrame.Visible = false

SettingsFrame.Name = "SettingsFrame"
SettingsFrame.Parent = ButtonsFrame
SettingsFrame.Size = UDim2.new(1, -10, 0, 355)
SettingsFrame.Position = UDim2.new(0, 5, 0, 0)
SettingsFrame.BackgroundTransparency = 1
SettingsFrame.Visible = false

local function createSquareButton(parent, name, text, posX, posY, color)
    local btn = Instance.new("TextButton", parent)
    btn.Name = name
    btn.Size = UDim2.new(0, 36, 0, 36)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.BackgroundColor3 = color or currentTheme.button
    btn.TextColor3 = currentTheme.text
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.TextWrapped = true
    btn.AutoButtonColor = true
    makeCorner(btn, 6)
    makeStroke(btn, currentTheme.border, 1, 0.6)
    return btn
end

local function createWideButton(parent, name, text, posX, posY, width)
    local btn = Instance.new("TextButton", parent)
    btn.Name = name
    btn.Size = UDim2.new(0, width or 160, 0, 32)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.BackgroundColor3 = currentTheme.button
    btn.TextColor3 = currentTheme.text
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 11
    btn.TextWrapped = true
    btn.AutoButtonColor = true
    makeCorner(btn, 6)
    makeStroke(btn, currentTheme.border, 1, 0.6)
    return btn
end

local function createToggleButton(parent, name, text, posX, posY, width)
    local btn = Instance.new("TextButton", parent)
    btn.Name = name
    btn.Size = UDim2.new(0, width or 160, 0, 32)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.BackgroundColor3 = currentTheme.button
    btn.TextColor3 = currentTheme.text
    btn.Text = text .. ": OFF"
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 11
    btn.TextWrapped = true
    btn.AutoButtonColor = true
    makeCorner(btn, 6)
    makeStroke(btn, currentTheme.border, 1, 0.6)
    return btn
end

local function createSlider(parent, name, text, posX, posY, min, max, default)
    local container = Instance.new("Frame", parent)
    container.Name = name
    container.Size = UDim2.new(0, 160, 0, 50)
    container.Position = UDim2.new(0, posX, 0, posY)
    container.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = currentTheme.text
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderBg = Instance.new("Frame", container)
    sliderBg.Size = UDim2.new(1, 0, 0, 10)
    sliderBg.Position = UDim2.new(0, 0, 0, 25)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    makeCorner(sliderBg, 5)
    
    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = currentTheme.accent
    makeCorner(sliderFill, 5)
    
    local sliderBtn = Instance.new("TextButton", sliderBg)
    sliderBtn.Size = UDim2.new(0, 16, 0, 16)
    sliderBtn.Position = UDim2.new((default - min) / (max - min), -8, 0, -3)
    sliderBtn.BackgroundColor3 = currentTheme.button
    sliderBtn.Text = ""
    sliderBtn.AutoButtonColor = true
    makeCorner(sliderBtn, 8)
    
    return container, sliderFill, sliderBtn, label, default, min, max
end

local btnStairsUp = createSquareButton(StairsFrame, "StairsUp", "/", 0, 0)
local btnStairsDown = createSquareButton(StairsFrame, "StairsDown", "\\", 41, 0)
local btnStairsLeft = createSquareButton(StairsFrame, "StairsLeft", "<", 82, 0)
local btnStairsRight = createSquareButton(StairsFrame, "StairsRight", ">", 123, 0)
local btnStairs45Up = createSquareButton(StairsFrame, "Stairs45Up", "/<", 164, 0)
local btnStairs45Down = createSquareButton(StairsFrame, "Stairs45Down", "\\>", 205, 0)
local btnStairsSpiral = createSquareButton(StairsFrame, "StairsSpiral", "◎", 246, 0)

local btnStairsUpWide = createWideButton(StairsFrame, "StairsUpWide", "Up Forward", 0, 45, 160)
local btnStairsDownWide = createWideButton(StairsFrame, "StairsDownWide", "Down Backward", 165, 45, 160)

local btnClearAllStairs = createWideButton(StairsFrame, "ClearAllStairs", "Clear All Stairs", 0, 85, 325)
local btnMirrorStairs = createWideButton(StairsFrame, "MirrorStairs", "Mirror Stairs", 0, 125, 160)
local btnRotateStairs = createWideButton(StairsFrame, "RotateStairs", "Rotate 90°", 165, 125, 160)

local btnPlatSmall = createSquareButton(PlatformsFrame, "PlatSmall", "S", 0, 0)
local btnPlatMed = createSquareButton(PlatformsFrame, "PlatMed", "M", 41, 0)
local btnPlatLarge = createSquareButton(PlatformsFrame, "PlatLarge", "L", 82, 0)
local btnPlatXL = createSquareButton(PlatformsFrame, "PlatXL", "XL", 123, 0)
local btnPlatThin = createSquareButton(PlatformsFrame, "PlatThin", "T", 164, 0)
local btnPlatLong = createSquareButton(PlatformsFrame, "PlatLong", "—", 205, 0)

local btnPlatSmallWide = createWideButton(PlatformsFrame, "PlatSmallWide", "Small (15x15)", 0, 45, 160)
local btnPlatMedWide = createWideButton(PlatformsFrame, "PlatMedWide", "Medium (25x25)", 165, 45, 160)
local btnPlatLargeWide = createWideButton(PlatformsFrame, "PlatLargeWide", "Large (40x40)", 0, 85, 160)
local btnPlatXLWide = createWideButton(PlatformsFrame, "PlatXLWide", "XL (60x60)", 165, 85, 160)
local btnPlatThinWide = createWideButton(PlatformsFrame, "PlatThinWide", "Thin (20x20)", 0, 125, 160)
local btnPlatLongWide = createWideButton(PlatformsFrame, "PlatLongWide", "Long (100x10)", 165, 125, 160)

local btnClearAllPlatforms = createWideButton(PlatformsFrame, "ClearAllPlatforms", "Clear All Platforms", 0, 165, 325)
local btnScaleUp = createWideButton(PlatformsFrame, "ScaleUp", "Scale Up 1.5x", 0, 205, 160)
local btnScaleDown = createWideButton(PlatformsFrame, "ScaleDown", "Scale Down 0.5x", 165, 205, 160)

local btnWallLeft = createSquareButton(EffectsFrame, "WallLeft", "L", 0, 0)
local btnWallRight = createSquareButton(EffectsFrame, "WallRight", "R", 41, 0)
local btnRampUp = createSquareButton(EffectsFrame, "RampUp", "▲", 82, 0)
local btnRampDown = createSquareButton(EffectsFrame, "RampDown", "▼", 123, 0)
local btnRampLeft = createSquareButton(EffectsFrame, "RampLeft", "◄", 164, 0)
local btnRampRight = createSquareButton(EffectsFrame, "RampRight", "►", 205, 0)

local btnBridge = createWideButton(EffectsFrame, "Bridge", "Bridge", 0, 45, 160)
local btnElevator = createWideButton(EffectsFrame, "Elevator", "Elevator", 165, 45, 160)
local btnTrapdoor = createWideButton(EffectsFrame, "Trapdoor", "Trapdoor", 0, 85, 160)
local btnSpawn = createWideButton(EffectsFrame, "Spawn", "Spawn Platform", 165, 85, 160)

local btnClearWalls = createWideButton(EffectsFrame, "ClearWalls", "Clear Walls", 0, 125, 160)
local btnClearRamps = createWideButton(EffectsFrame, "ClearRamps", "Clear Ramps", 165, 125, 160)
local btnClearAllEffects = createWideButton(EffectsFrame, "ClearAllEffects", "Clear All", 0, 165, 325)

local btnGlow = createToggleButton(EffectsFrame, "Glow", "Glow Effect", 0, 205, 160)
local btnParticles = createToggleButton(EffectsFrame, "Particles", "Particles", 0, 245, 160)
local btnTrail = createToggleButton(EffectsFrame, "Trail", "Trail Effect", 0, 285, 160)
local btnGrid = createToggleButton(EffectsFrame, "Grid", "Show Grid", 165, 205, 160)

local sliderTrans, sliderFillTrans, sliderBtnTrans, sliderLabelTrans, transVal, transMin, transMax = createSlider(SettingsFrame, "SliderTrans", "Transparency", 0, 0, 0, 1, settings.transparency)
local sliderHeight, sliderFillHeight, sliderBtnHeight, sliderLabelHeight, heightVal, heightMin, heightMax = createSlider(SettingsFrame, "SliderHeight", "Platform Height", 0, 60, -10, 10, settings.platformHeight)
local sliderLength, sliderFillLength, sliderBtnLength, sliderLabelLength, lengthVal, lengthMin, lengthMax = createSlider(SettingsFrame, "SliderLength", "Stairs Length", 0, 120, 50, 500, settings.stairsLength)
local sliderSpeed, sliderFillSpeed, sliderBtnSpeed, sliderLabelSpeed, speedVal, speedMin, speedMax = createSlider(SettingsFrame, "SliderSpeed", "Elevator Speed", 0, 180, 1, 20, settings.elevatorSpeed)
local sliderGlow, sliderFillGlow, sliderBtnGlow, sliderLabelGlow, glowVal, glowMin, glowMax = createSlider(SettingsFrame, "SliderGlow", "Glow Intensity", 0, 240, 0, 5, settings.glowIntensity)
local sliderTrail, sliderFillTrail, sliderBtnTrail, sliderLabelTrail, trailVal, trailMin, trailMax = createSlider(SettingsFrame, "SliderTrail", "Trail Length", 0, 300, 0, 30, settings.trailLength)

local btnThemeRed = createSquareButton(SettingsFrame, "ThemeRed", "R", 0, 360, themes.red.button)
local btnThemeBlue = createSquareButton(SettingsFrame, "ThemeBlue", "B", 41, 360, themes.blue.button)
local btnThemeGreen = createSquareButton(SettingsFrame, "ThemeGreen", "G", 82, 360, themes.green.button)
local btnThemePurple = createSquareButton(SettingsFrame, "ThemePurple", "P", 123, 360, themes.purple.button)
local btnThemeOrange = createSquareButton(SettingsFrame, "ThemeOrange", "O", 164, 360, themes.orange.button)
local btnThemeCyan = createSquareButton(SettingsFrame, "ThemeCyan", "C", 205, 360, themes.cyan.button)
local btnThemeWhite = createSquareButton(SettingsFrame, "ThemeWhite", "W", 246, 360, themes.white.button)
local btnThemeBlack = createSquareButton(SettingsFrame, "ThemeBlack", "K", 287, 360, themes.black.button)

local btnClearEverything = createWideButton(SettingsFrame, "ClearEverything", "CLEAR EVERYTHING", 0, 405, 325)
local btnTeleportUp = createWideButton(SettingsFrame, "TeleportUp", "Teleport Up +10", 0, 445, 160)
local btnTeleportDown = createWideButton(SettingsFrame, "TeleportDown", "Teleport Down -10", 165, 445, 160)

local function updateSlider(sliderFill, sliderBtn, label, value, min, max, text)
    local percent = (value - min) / (max - min)
    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
    sliderBtn.Position = UDim2.new(percent, -8, 0, -3)
    label.Text = text .. ": " .. string.format("%.2f", value)
end

local function setupSliderInteractions(sliderFill, sliderBtn, label, min, max, callback, text)
    local dragging = false
    sliderBtn.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    sliderBtn.MouseButton1Up:Connect(function()
        dragging = false
    end)
    
    sliderFill.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    sliderFill.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local parent = sliderFill.Parent
            local mousePos = game.Players.LocalPlayer:GetMouse().X
            local sliderPos = parent.AbsolutePosition.X
            local sliderWidth = parent.AbsoluteSize.X
            local relativeX = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
            local newValue = min + relativeX * (max - min)
            callback(newValue)
            updateSlider(sliderFill, sliderBtn, label, newValue, min, max, text)
        end
    end)
end

setupSliderInteractions(sliderFillTrans, sliderBtnTrans, sliderLabelTrans, transMin, transMax, function(val)
    settings.transparency = val
    for _, obj in ipairs(createdObjects) do
        if obj and obj:IsA("BasePart") then
            obj.Transparency = val
        end
    end
end, "Transparency")

setupSliderInteractions(sliderFillHeight, sliderBtnHeight, sliderLabelHeight, heightMin, heightMax, function(val)
    settings.platformHeight = val
end, "Platform Height")

setupSliderInteractions(sliderFillLength, sliderBtnLength, sliderLabelLength, lengthMin, lengthMax, function(val)
    settings.stairsLength = val
end, "Stairs Length")

setupSliderInteractions(sliderFillSpeed, sliderBtnSpeed, sliderLabelSpeed, speedMin, speedMax, function(val)
    settings.elevatorSpeed = val
end, "Elevator Speed")

setupSliderInteractions(sliderFillGlow, sliderBtnGlow, sliderLabelGlow, glowMin, glowMax, function(val)
    settings.glowIntensity = val
    for _, light in ipairs(glowEffects) do
        if light and light:IsA("PointLight") then
            light.Brightness = val
        end
    end
end, "Glow Intensity")

setupSliderInteractions(sliderFillTrail, sliderBtnTrail, sliderLabelTrail, trailMin, trailMax, function(val)
    settings.trailLength = val
    for _, trail in ipairs(trailEffects) do
        if trail and trail:IsA("Trail") then
            trail.Lifetime = val / 10
        end
    end
end, "Trail Length")

local function toggleButton(btn, settingKey)
    settings[settingKey] = not settings[settingKey]
    if settings[settingKey] then
        btn.Text = btn.Name:gsub("Btn", "") .. ": ON"
        btn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    else
        btn.Text = btn.Name:gsub("Btn", "") .. ": OFF"
        btn.BackgroundColor3 = currentTheme.button
    end
end

local function switchTab(tabName)
    StairsFrame.Visible = false
    PlatformsFrame.Visible = false
    EffectsFrame.Visible = false
    SettingsFrame.Visible = false
    
    for _, btn in ipairs(TabButtons) do
        btn.BackgroundColor3 = currentTheme.button
    end
    
    if tabName == "Stairs" then
        StairsFrame.Visible = true
        tabStairs.BackgroundColor3 = currentTheme.accent
    elseif tabName == "Platforms" then
        PlatformsFrame.Visible = true
        tabPlatforms.BackgroundColor3 = currentTheme.accent
    elseif tabName == "Effects" then
        EffectsFrame.Visible = true
        tabEffects.BackgroundColor3 = currentTheme.accent
    elseif tabName == "Settings" then
        SettingsFrame.Visible = true
        tabStairs.BackgroundColor3 = currentTheme.accent
    end
end

table.insert(TabButtons, tabStairs)
table.insert(TabButtons, tabPlatforms)
table.insert(TabButtons, tabEffects)

tabStairs.MouseButton1Click:Connect(function()
    switchTab("Stairs")
end)

tabPlatforms.MouseButton1Click:Connect(function()
    switchTab("Platforms")
end)

tabEffects.MouseButton1Click:Connect(function()
    switchTab("Effects")
end)

tabStairs.MouseButton1Click:Connect(function()
    switchTab("Settings")
end)

btnStairsUp.MouseButton1Click:Connect(function()
    createStairsUp()
end)

btnStairsDown.MouseButton1Click:Connect(function()
    createStairsDown()
end)

btnStairsLeft.MouseButton1Click:Connect(function()
    createStairsLeft()
end)

btnStairsRight.MouseButton1Click:Connect(function()
    createStairsRight()
end)

btnStairs45Up.MouseButton1Click:Connect(function()
    createStairs45Up()
end)

btnStairs45Down.MouseButton1Click:Connect(function()
    createStairs45Down()
end)

btnStairsSpiral.MouseButton1Click:Connect(function()
    createStairsSpiral()
end)

btnStairsUpWide.MouseButton1Click:Connect(function()
    createStairsUp()
end)

btnStairsDownWide.MouseButton1Click:Connect(function()
    createStairsDown()
end)

btnClearAllStairs.MouseButton1Click:Connect(function()
    destroyAllStairs()
end)

btnMirrorStairs.MouseButton1Click:Connect(function()
    mirrorAllObjects()
end)

btnRotateStairs.MouseButton1Click:Connect(function()
    rotateAllObjects(90)
end)

btnPlatSmall.MouseButton1Click:Connect(function()
    createPlatformSmall()
end)

btnPlatMed.MouseButton1Click:Connect(function()
    createPlatformMedium()
end)

btnPlatLarge.MouseButton1Click:Connect(function()
    createPlatformLarge()
end)

btnPlatXL.MouseButton1Click:Connect(function()
    createPlatformXL()
end)

btnPlatThin.MouseButton1Click:Connect(function()
    createPlatformThin()
end)

btnPlatLong.MouseButton1Click:Connect(function()
    createPlatformLong()
end)

btnPlatSmallWide.MouseButton1Click:Connect(function()
    createPlatformSmall()
end)

btnPlatMedWide.MouseButton1Click:Connect(function()
    createPlatformMedium()
end)

btnPlatLargeWide.MouseButton1Click:Connect(function()
    createPlatformLarge()
end)

btnPlatXLWide.MouseButton1Click:Connect(function()
    createPlatformXL()
end)

btnPlatThinWide.MouseButton1Click:Connect(function()
    createPlatformThin()
end)

btnPlatLongWide.MouseButton1Click:Connect(function()
    createPlatformLong()
end)

btnClearAllPlatforms.MouseButton1Click:Connect(function()
    destroyAllPlatforms()
end)

btnScaleUp.MouseButton1Click:Connect(function()
    scaleAllObjects(1.5)
end)

btnScaleDown.MouseButton1Click:Connect(function()
    scaleAllObjects(0.5)
end)

btnWallLeft.MouseButton1Click:Connect(function()
    createWallLeft()
end)

btnWallRight.MouseButton1Click:Connect(function()
    createWallRight()
end)

btnRampUp.MouseButton1Click:Connect(function()
    createRampUp()
end)

btnRampDown.MouseButton1Click:Connect(function()
    createRampDown()
end)

btnRampLeft.MouseButton1Click:Connect(function()
    createRampLeft()
end)

btnRampRight.MouseButton1Click:Connect(function()
    createRampRight()
end)

btnBridge.MouseButton1Click:Connect(function()
    createBridge()
end)

btnElevator.MouseButton1Click:Connect(function()
    createElevator()
end)

btnTrapdoor.MouseButton1Click:Connect(function()
    createTrapdoor()
end)

btnSpawn.MouseButton1Click:Connect(function()
    createSpawnPlatform()
end)

btnClearWalls.MouseButton1Click:Connect(function()
    destroyAllWalls()
end)

btnClearRamps.MouseButton1Click:Connect(function()
    destroyAllRamps()
end)

btnClearAllEffects.MouseButton1Click:Connect(function()
    destroyAllWalls()
    destroyAllRamps()
    destroyBridge()
    destroyElevator()
    destroyTrapdoor()
    destroySpawnPlatform()
end)

btnGlow.MouseButton1Click:Connect(function()
    toggleButton(btnGlow, "glowIntensity")
    settings.glowIntensity = settings.glowIntensity > 0 and 0 or 1
end)

btnParticles.MouseButton1Click:Connect(function()
    toggleButton(btnParticles, "showParticles")
end)

btnTrail.MouseButton1Click:Connect(function()
    toggleButton(btnTrail, "trailLength")
    settings.trailLength = settings.trailLength > 0 and 0 or 10
end)

btnGrid.MouseButton1Click:Connect(function()
    toggleButton(btnGrid, "showGrid")
    if settings.showGrid then
        createGridFloor()
    else
        destroyGridFloor()
    end
end)

btnThemeRed.MouseButton1Click:Connect(function()
    currentTheme = themes.red
    updateTheme()
end)

btnThemeBlue.MouseButton1Click:Connect(function()
    currentTheme = themes.blue
    updateTheme()
end)

btnThemeGreen.MouseButton1Click:Connect(function()
    currentTheme = themes.green
    updateTheme()
end)

btnThemePurple.MouseButton1Click:Connect(function()
    currentTheme = themes.purple
    updateTheme()
end)

btnThemeOrange.MouseButton1Click:Connect(function()
    currentTheme = themes.orange
    updateTheme()
end)

btnThemeCyan.MouseButton1Click:Connect(function()
    currentTheme = themes.cyan
    updateTheme()
end)

btnThemeWhite.MouseButton1Click:Connect(function()
    currentTheme = themes.white
    updateTheme()
end)

btnThemeBlack.MouseButton1Click:Connect(function()
    currentTheme = themes.black
    updateTheme()
end)

btnClearEverything.MouseButton1Click:Connect(function()
    clearAllObjects()
end)

btnTeleportUp.MouseButton1Click:Connect(function()
    teleportAllObjects(Vector3.new(0, 10, 0))
end)

btnTeleportDown.MouseButton1Click:Connect(function()
    teleportAllObjects(Vector3.new(0, -10, 0))
end)

local function updateTheme()
    MainFrame.BackgroundColor3 = currentTheme.primary
    glassBg.BackgroundColor3 = currentTheme.glassBg
    glassGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, currentTheme.gradient1),
        ColorSequenceKeypoint.new(1, currentTheme.gradient2)
    })
    Header.BackgroundColor3 = currentTheme.headerBg
    makeStroke(MainFrame, currentTheme.border, 2, 0.3)
    makeStroke(Header, currentTheme.border, 1, 0.4)
    
    local allButtons = {}
    for _, btn in ipairs(StairsFrame:GetDescendants()) do
        if btn:IsA("TextButton") then
            table.insert(allButtons, btn)
        end
    end
    for _, btn in ipairs(PlatformsFrame:GetDescendants()) do
        if btn:IsA("TextButton") then
            table.insert(allButtons, btn)
        end
    end
    for _, btn in ipairs(EffectsFrame:GetDescendants()) do
        if btn:IsA("TextButton") then
            table.insert(allButtons, btn)
        end
    end
    for _, btn in ipairs(SettingsFrame:GetDescendants()) do
        if btn:IsA("TextButton") then
            table.insert(allButtons, btn)
        end
    end
    
    for _, btn in ipairs(allButtons) do
        if btn.Name ~= "Glow" and btn.Name ~= "Particles" and btn.Name ~= "Trail" and btn.Name ~= "Grid" then
            btn.BackgroundColor3 = currentTheme.button
            btn.TextColor3 = currentTheme.text
        end
        local stroke = btn:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Color = currentTheme.border
        end
    end
    
    CloseButton.TextColor3 = currentTheme.text
    HideButton.TextColor3 = currentTheme.text
end

local function addHoverEffect(btn)
    local stroke = btn:FindFirstChildOfClass("UIStroke")
    btn.MouseEnter:Connect(function()
        if stroke then
            stroke.Color = Color3.fromRGB(255, 150, 150)
            stroke.Thickness = 2
        end
    end)
    btn.MouseLeave:Connect(function()
        if stroke then
            stroke.Color = currentTheme.border
            stroke.Thickness = 1
        end
    end)
end

local allButtonsList = {
    CloseButton, HideButton,
    tabStairs, tabPlatforms, tabEffects,
    btnStairsUp, btnStairsDown, btnStairsLeft, btnStairsRight, btnStairs45Up, btnStairs45Down, btnStairsSpiral,
    btnStairsUpWide, btnStairsDownWide, btnClearAllStairs, btnMirrorStairs, btnRotateStairs,
    btnPlatSmall, btnPlatMed, btnPlatLarge, btnPlatXL, btnPlatThin, btnPlatLong,
    btnPlatSmallWide, btnPlatMedWide, btnPlatLargeWide, btnPlatXLWide, btnPlatThinWide, btnPlatLongWide,
    btnClearAllPlatforms, btnScaleUp, btnScaleDown,
    btnWallLeft, btnWallRight, btnRampUp, btnRampDown, btnRampLeft, btnRampRight,
    btnBridge, btnElevator, btnTrapdoor, btnSpawn,
    btnClearWalls, btnClearRamps, btnClearAllEffects,
    btnGlow, btnParticles, btnTrail, btnGrid,
    btnThemeRed, btnThemeBlue, btnThemeGreen, btnThemePurple, btnThemeOrange, btnThemeCyan, btnThemeWhite, btnThemeBlack,
    btnClearEverything, btnTeleportUp, btnTeleportDown
}

for _, btn in ipairs(allButtonsList) do
    addHoverEffect(btn)
end

CloseButton.MouseButton1Click:Connect(function()
    clearAllObjects()
    ScreenGui:Destroy()
end)

local isHidden = false
HideButton.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    if isHidden then
        HideButton.Text = ">"
        MainFrame:TweenSize(UDim2.new(0, 95, 0, 55), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, settings.animationSpeed, true)
        ButtonsFrame:TweenPosition(UDim2.new(-1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, settings.animationSpeed, true)
        TabsFrame:TweenPosition(UDim2.new(-1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, settings.animationSpeed, true)
    else
        HideButton.Text = "<"
        MainFrame:TweenSize(UDim2.new(0, 350, 0, 400), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, settings.animationSpeed, true)
        ButtonsFrame:TweenPosition(UDim2.new(0, 5, 0, 45), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, settings.animationSpeed, true)
        TabsFrame:TweenPosition(UDim2.new(0, 5, 0, 5), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, settings.animationSpeed, true)
    end
end)

local function setupKeyboardShortcuts()
    local uis = game:GetService("UserInputService")
    
    uis.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.One then
            createStairsUp()
        elseif input.KeyCode == Enum.KeyCode.Two then
            createStairsDown()
        elseif input.KeyCode == Enum.KeyCode.Three then
            createStairsLeft()
        elseif input.KeyCode == Enum.KeyCode.Four then
            createStairsRight()
        elseif input.KeyCode == Enum.KeyCode.Five then
            createStairsSpiral()
        elseif input.KeyCode == Enum.KeyCode.Q then
            createPlatformSmall()
        elseif input.KeyCode == Enum.KeyCode.W then
            createPlatformMedium()
        elseif input.KeyCode == Enum.KeyCode.E then
            createPlatformLarge()
        elseif input.KeyCode == Enum.KeyCode.R then
            createPlatformXL()
        elseif input.KeyCode == Enum.KeyCode.T then
            createPlatformThin()
        elseif input.KeyCode == Enum.KeyCode.Y then
            createPlatformLong()
        elseif input.KeyCode == Enum.KeyCode.A then
            createWallLeft()
        elseif input.KeyCode == Enum.KeyCode.S then
            createWallRight()
        elseif input.KeyCode == Enum.KeyCode.D then
            createRampUp()
        elseif input.KeyCode == Enum.KeyCode.F then
            createRampDown()
        elseif input.KeyCode == Enum.KeyCode.G then
            createBridge()
        elseif input.KeyCode == Enum.KeyCode.H then
            createElevator()
        elseif input.KeyCode == Enum.KeyCode.J then
            createTrapdoor()
        elseif input.KeyCode == Enum.KeyCode.K then
            createSpawnPlatform()
        elseif input.KeyCode == Enum.KeyCode.Z then
            scaleAllObjects(1.5)
        elseif input.KeyCode == Enum.KeyCode.X then
            scaleAllObjects(0.5)
        elseif input.KeyCode == Enum.KeyCode.C then
            clearAllObjects()
        elseif input.KeyCode == Enum.KeyCode.V then
            mirrorAllObjects()
        elseif input.KeyCode == Enum.KeyCode.B then
            rotateAllObjects(90)
        elseif input.KeyCode == Enum.KeyCode.N then
            teleportAllObjects(Vector3.new(0, 10, 0))
        elseif input.KeyCode == Enum.KeyCode.M then
            teleportAllObjects(Vector3.new(0, -10, 0))
        end
    end)
end

setupKeyboardShortcuts()

local autoCleanConnection = nil
local function setupAutoClean()
    if autoCleanConnection then
        autoCleanConnection:Disconnect()
        autoCleanConnection = nil
    end
    
    if settings.autoClean then
        autoCleanConnection = game:GetService("RunService").Heartbeat:Connect(function()
            task.wait(settings.autoCleanTime)
            if #createdObjects > settings.objectLimit then
                local toRemove = #createdObjects - settings.objectLimit
                for i = 1, toRemove do
                    if createdObjects[1] then
                        destroyObject(createdObjects[1])
                        table.remove(createdObjects, 1)
                    end
                end
            end
        end)
    end
end

local player = game.Players.LocalPlayer
player.CharacterRemoving:Connect(function()
    destroyPlatform()
    destroyPlatformSmall()
    destroyPlatformMedium()
    destroyPlatformLarge()
    destroyPlatformXL()
    destroyPlatformThin()
    destroyPlatformLong()
end)

local function createQuickAccessBar()
    local quickBar = Instance.new("Frame", MainFrame)
    quickBar.Name = "QuickAccessBar"
    quickBar.Size = UDim2.new(0, 340, 0, 45)
    quickBar.Position = UDim2.new(0, 5, 0, 355)
    quickBar.BackgroundColor3 = currentTheme.primary
    quickBar.BackgroundTransparency = 0.3
    makeCorner(quickBar, 8)
    makeStroke(quickBar, currentTheme.border, 1, 0.5)
    
    local quickStairs = createSquareButton(quickBar, "QuickStairs", "/\\", 5, 5)
    local quickPlatform = createSquareButton(quickBar, "QuickPlatform", "[]", 46, 5)
    local quickWall = createSquareButton(quickBar, "QuickWall", "||", 87, 5)
    local quickRamp = createSquareButton(quickBar, "QuickRamp", "/", 128, 5)
    local quickElevator = createSquareButton(quickBar, "QuickElevator", "↑↓", 169, 5)
    local quickMirror = createSquareButton(quickBar, "QuickMirror", "⊗", 210, 5)
    local quickClear = createSquareButton(quickBar, "QuickClear", "X", 251, 5)
    
    quickStairs.MouseButton1Click:Connect(function()
        createStairsUp()
    end)
    
    quickPlatform.MouseButton1Click:Connect(function()
        createPlatformMedium()
    end)
    
    quickWall.MouseButton1Click:Connect(function()
        createWallLeft()
    end)
    
    quickRamp.MouseButton1Click:Connect(function()
        createRampUp()
    end)
    
    quickElevator.MouseButton1Click:Connect(function()
        createElevator()
    end)
    
    quickMirror.MouseButton1Click:Connect(function()
        mirrorAllObjects()
    end)
    
    quickClear.MouseButton1Click:Connect(function()
        clearAllObjects()
    end)
    
    addHoverEffect(quickStairs)
    addHoverEffect(quickPlatform)
    addHoverEffect(quickWall)
    addHoverEffect(quickRamp)
    addHoverEffect(quickElevator)
    addHoverEffect(quickMirror)
    addHoverEffect(quickClear)
end

createQuickAccessBar()

local function createStatusBar()
    local statusBar = Instance.new("Frame", MainFrame)
    statusBar.Name = "StatusBar"
    statusBar.Size = UDim2.new(0, 340, 0, 25)
    statusBar.Position = UDim2.new(0, 5, 0, 405)
    statusBar.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    statusBar.BackgroundTransparency = 0.3
    makeCorner(statusBar, 4)
    
    local statusLabel = Instance.new("TextLabel", statusBar)
    statusLabel.Size = UDim2.new(1, -10, 1, 0)
    statusLabel.Position = UDim2.new(0, 5, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Objects: 0 | Stairs: 0 | Platforms: 0"
    statusLabel.TextColor3 = currentTheme.text
    statusLabel.Font = Enum.Font.SourceSansBold
    statusLabel.TextSize = 10
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local runService = game:GetService("RunService")
    runService.Heartbeat:Connect(function()
        local totalObjects = #createdObjects
        local stairsCount = #stairsArray
        local platformsCount = #platformsArray
        statusLabel.Text = "Objects: " .. totalObjects .. " | Stairs: " .. stairsCount .. " | Platforms: " .. platformsCount .. " | Theme: " .. settings.theme
    end)
end

createStatusBar()

local function createHelpTooltip()
    local helpFrame = Instance.new("Frame", MainFrame)
    helpFrame.Name = "HelpFrame"
    helpFrame.Size = UDim2.new(0, 150, 0, 200)
    helpFrame.Position = UDim2.new(-1, -160, 0, 0)
    helpFrame.BackgroundColor3 = currentTheme.primary
    helpFrame.BackgroundTransparency = 0.1
    makeCorner(helpFrame, 8)
    makeStroke(helpFrame, currentTheme.border, 1, 0.5)
    
    local helpTitle = Instance.new("TextLabel", helpFrame)
    helpTitle.Size = UDim2.new(1, -10, 0, 25)
    helpTitle.Position = UDim2.new(0, 5, 0, 5)
    helpTitle.BackgroundTransparency = 1
    helpTitle.Text = "Keyboard Shortcuts"
    helpTitle.TextColor3 = currentTheme.text
    helpTitle.Font = Enum.Font.SourceSansBold
    helpTitle.TextSize = 12
    
    local shortcuts = {
        "1-5: Stairs types",
        "Q-T: Platform sizes",
        "A-S: Walls",
        "D-F: Ramps",
        "G-H: Bridge/Elevator",
        "J-K: Trapdoor/Spawn",
        "Z/X: Scale objects",
        "C: Clear all",
        "V: Mirror",
        "B: Rotate 90°",
        "N/M: Teleport ±10"
    }
    
    local yPos = 35
    for _, shortcut in ipairs(shortcuts) do
        local label = Instance.new("TextLabel", helpFrame)
        label.Size = UDim2.new(1, -10, 0, 15)
        label.Position = UDim2.new(0, 5, 0, yPos)
        label.BackgroundTransparency = 1
        label.Text = shortcut
        label.TextColor3 = currentTheme.text
        label.Font = Enum.Font.SourceSans
        label.TextSize = 9
        label.TextXAlignment = Enum.TextXAlignment.Left
        yPos = yPos + 15
    end
end

createHelpTooltip()

local function createObjectInfo()
    local infoFrame = Instance.new("Frame", MainFrame)
    infoFrame.Name = "InfoFrame"
    infoFrame.Size = UDim2.new(0, 150, 0, 100)
    infoFrame.Position = UDim2.new(1, 10, 0, 0)
    infoFrame.BackgroundColor3 = currentTheme.primary
    infoFrame.BackgroundTransparency = 0.1
    makeCorner(infoFrame, 8)
    makeStroke(infoFrame, currentTheme.border, 1, 0.5)
    
    local infoTitle = Instance.new("TextLabel", infoFrame)
    infoTitle.Size = UDim2.new(1, -10, 0, 20)
    infoTitle.Position = UDim2.new(0, 5, 0, 5)
    infoTitle.BackgroundTransparency = 1
    infoTitle.Text = "Settings"
    infoTitle.TextColor3 = currentTheme.text
    infoTitle.Font = Enum.Font.SourceSansBold
    infoTitle.TextSize = 12
    
    local settingsLabels = {
        "Transparency: " .. string.format("%.2f", settings.transparency),
        "Height: " .. string.format("%.2f", settings.platformHeight),
        "Length: " .. settings.stairsLength,
        "Speed: " .. settings.elevatorSpeed,
        "Glow: " .. string.format("%.2f", settings.glowIntensity),
        "Trail: " .. settings.trailLength
    }
    
    local yPos = 30
    for _, text in ipairs(settingsLabels) do
        local label = Instance.new("TextLabel", infoFrame)
        label.Size = UDim2.new(1, -10, 0, 12)
        label.Position = UDim2.new(0, 5, 0, yPos)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = currentTheme.text
        label.Font = Enum.Font.SourceSans
        label.TextSize = 9
        label.TextXAlignment = Enum.TextXAlignment.Left
        yPos = yPos + 12
    end
end

createObjectInfo()

local function createPresetsDropdown()
    local presetsFrame = Instance.new("Frame", MainFrame)
    presetsFrame.Name = "PresetsFrame"
    presetsFrame.Size = UDim2.new(0, 100, 0, 150)
    presetsFrame.Position = UDim2.new(0, -105, 0, 45)
    presetsFrame.BackgroundColor3 = currentTheme.primary
    presetsFrame.BackgroundTransparency = 0.1
    presetsFrame.Visible = false
    makeCorner(presetsFrame, 8)
    makeStroke(presetsFrame, currentTheme.border, 1, 0.5)
    
    local presetsTitle = Instance.new("TextLabel", presetsFrame)
    presetsTitle.Size = UDim2.new(1, -10, 0, 25)
    presetsTitle.Position = UDim2.new(0, 5, 0, 5)
    presetsTitle.BackgroundTransparency = 1
    presetsTitle.Text = "Presets"
    presetsTitle.TextColor3 = currentTheme.text
    presetsTitle.Font = Enum.Font.SourceSansBold
    presetsTitle.TextSize = 12
    
    local presets = {
        {name = "Tower", func = function()
            createStairsUp()
            createPlatformXL()
        end},
        {name = "Bridge", func = function()
            createBridge()
        end},
        {name = "Elevator", func = function()
            createElevator()
        end},
        {name = "Fortress", func = function()
            createPlatformLarge()
            createWallLeft()
            createWallRight()
            createRampUp()
        end},
        {name = "Spiral Tower", func = function()
            createStairsSpiral()
            createPlatformSmall()
        end},
        {name = "Ramp Jump", func = function()
            createRampUp()
            createPlatformMedium()
        end}
    }
    
    local yPos = 35
    for _, preset in ipairs(presets) do
        local btn = Instance.new("TextButton", presetsFrame)
        btn.Size = UDim2.new(1, -10, 0, 20)
        btn.Position = UDim2.new(0, 5, 0, yPos)
        btn.BackgroundColor3 = currentTheme.button
        btn.TextColor3 = currentTheme.text
        btn.Text = preset.name
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 10
        makeCorner(btn, 4)
        btn.MouseButton1Click:Connect(function()
            preset.func()
        end)
        addHoverEffect(btn)
        yPos = yPos + 22
    end
end

createPresetsDropdown()
