-- =====================================================
-- ScriptVault UI Library v3.0.0
-- Professional Roblox UI Library - Complete Edition
-- GitHub: github.com/BursaliAlperen/ScriptVault-AutoFarm
-- Usage: local SV = loadstring(game:HttpGet("RAW_URL"))()
-- =====================================================

local SV = {}
SV.__index = SV
SV._VERSION = "3.0.0"
SV._BUILD = "20260101"

-- =====================================================
-- SERVICES
-- =====================================================
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ContentProvider  = game:GetService("ContentProvider")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local Stats            = game:GetService("Stats")
local Workspace        = game:GetService("Workspace")
local LP               = Players.LocalPlayer

-- =====================================================
-- DEFAULT CUSTOM ICONS (your assets)
-- =====================================================
SV.Icons = {
    Logo        = "rbxassetid://111637853140695",
    Auto        = "rbxassetid://122032243989747",
    Farm        = "rbxassetid://11330204834",
    Favorites   = "rbxassetid://138880939782808",
    Info        = "rbxassetid://17829948066",
    Teleports   = "rbxassetid://16538185173",
    Settings    = "rbxassetid://9405931578",
    Home        = "rbxassetid://6031075931",
    Player      = "rbxassetid://6031225389",
    Stats       = "rbxassetid://6031279000",
    Combat      = "rbxassetid://6031094678",
    Tools       = "rbxassetid://6035067834",
    Misc        = "rbxassetid://6031154871",
    Shop        = "rbxassetid://6034280643",
    Visual      = "rbxassetid://6031302945",
    Key         = "rbxassetid://6031265976",
    Lock        = "rbxassetid://6031216977",
    Script      = "rbxassetid://6034277377",
    Debug       = "rbxassetid://6031090990",
    Folder      = "rbxassetid://6034982098",
}

-- =====================================================
-- THEMES
-- =====================================================
local Themes = {}

local function RegisterTheme(name, colors)
    Themes[name] = colors
end

RegisterTheme("DarkBlue", {
    Background        = Color3.fromRGB(15, 16, 24),
    Sidebar           = Color3.fromRGB(20, 21, 32),
    TopBar            = Color3.fromRGB(22, 23, 35),
    Element           = Color3.fromRGB(28, 29, 44),
    ElementHover      = Color3.fromRGB(36, 37, 56),
    ElementActive     = Color3.fromRGB(42, 44, 66),
    Accent            = Color3.fromRGB(0, 120, 255),
    AccentHover       = Color3.fromRGB(30, 145, 255),
    AccentDark        = Color3.fromRGB(0, 90, 200),
    Text              = Color3.fromRGB(240, 242, 255),
    TextMuted         = Color3.fromRGB(160, 165, 190),
    TextDark          = Color3.fromRGB(110, 115, 140),
    ToggleOn          = Color3.fromRGB(0, 150, 255),
    ToggleOff         = Color3.fromRGB(48, 50, 70),
    Button            = Color3.fromRGB(0, 110, 220),
    ButtonHover       = Color3.fromRGB(0, 135, 255),
    Success           = Color3.fromRGB(0, 200, 110),
    Warning           = Color3.fromRGB(230, 165, 0),
    Error             = Color3.fromRGB(225, 60, 60),
    Slider            = Color3.fromRGB(38, 40, 60),
    SliderFill        = Color3.fromRGB(0, 135, 255),
    Dropdown          = Color3.fromRGB(32, 33, 50),
    DropdownHover     = Color3.fromRGB(48, 50, 74),
    Input             = Color3.fromRGB(36, 37, 55),
    InputFocus        = Color3.fromRGB(42, 44, 66),
    Border            = Color3.fromRGB(0, 120, 255),
    Separator         = Color3.fromRGB(40, 42, 62),
    Shadow            = Color3.fromRGB(0, 0, 0),
    Overlay           = Color3.fromRGB(0, 0, 0),
})

RegisterTheme("Midnight", {
    Background        = Color3.fromRGB(10, 10, 15),
    Sidebar           = Color3.fromRGB(15, 15, 22),
    TopBar            = Color3.fromRGB(15, 15, 22),
    Element           = Color3.fromRGB(22, 22, 32),
    ElementHover      = Color3.fromRGB(30, 30, 44),
    ElementActive     = Color3.fromRGB(38, 38, 55),
    Accent            = Color3.fromRGB(180, 100, 255),
    AccentHover       = Color3.fromRGB(200, 130, 255),
    AccentDark        = Color3.fromRGB(140, 70, 220),
    Text              = Color3.fromRGB(245, 240, 255),
    TextMuted         = Color3.fromRGB(165, 155, 185),
    TextDark          = Color3.fromRGB(115, 105, 135),
    ToggleOn          = Color3.fromRGB(180, 100, 255),
    ToggleOff         = Color3.fromRGB(42, 38, 60),
    Button            = Color3.fromRGB(150, 80, 240),
    ButtonHover       = Color3.fromRGB(175, 105, 255),
    Success           = Color3.fromRGB(0, 200, 130),
    Warning           = Color3.fromRGB(240, 175, 0),
    Error             = Color3.fromRGB(230, 60, 80),
    Slider            = Color3.fromRGB(35, 30, 50),
    SliderFill        = Color3.fromRGB(180, 100, 255),
    Dropdown          = Color3.fromRGB(26, 24, 40),
    DropdownHover     = Color3.fromRGB(42, 38, 62),
    Input             = Color3.fromRGB(30, 28, 46),
    InputFocus        = Color3.fromRGB(40, 36, 60),
    Border            = Color3.fromRGB(180, 100, 255),
    Separator         = Color3.fromRGB(38, 34, 55),
    Shadow            = Color3.fromRGB(0, 0, 0),
    Overlay           = Color3.fromRGB(0, 0, 0),
})

RegisterTheme("Ocean", {
    Background        = Color3.fromRGB(12, 20, 28),
    Sidebar           = Color3.fromRGB(16, 26, 36),
    TopBar            = Color3.fromRGB(18, 28, 40),
    Element           = Color3.fromRGB(24, 36, 50),
    ElementHover      = Color3.fromRGB(32, 46, 62),
    ElementActive     = Color3.fromRGB(40, 56, 74),
    Accent            = Color3.fromRGB(0, 200, 220),
    AccentHover       = Color3.fromRGB(30, 220, 240),
    AccentDark        = Color3.fromRGB(0, 160, 180),
    Text              = Color3.fromRGB(235, 250, 255),
    TextMuted         = Color3.fromRGB(150, 175, 195),
    TextDark          = Color3.fromRGB(100, 125, 145),
    ToggleOn          = Color3.fromRGB(0, 200, 220),
    ToggleOff         = Color3.fromRGB(38, 52, 68),
    Button            = Color3.fromRGB(0, 170, 190),
    ButtonHover       = Color3.fromRGB(0, 200, 220),
    Success           = Color3.fromRGB(0, 210, 140),
    Warning           = Color3.fromRGB(245, 180, 20),
    Error             = Color3.fromRGB(235, 70, 70),
    Slider            = Color3.fromRGB(32, 46, 62),
    SliderFill        = Color3.fromRGB(0, 200, 220),
    Dropdown          = Color3.fromRGB(26, 40, 54),
    DropdownHover     = Color3.fromRGB(42, 58, 76),
    Input             = Color3.fromRGB(30, 44, 60),
    InputFocus        = Color3.fromRGB(40, 56, 74),
    Border            = Color3.fromRGB(0, 200, 220),
    Separator         = Color3.fromRGB(38, 54, 70),
    Shadow            = Color3.fromRGB(0, 0, 0),
    Overlay           = Color3.fromRGB(0, 0, 0),
})

RegisterTheme("Monochrome", {
    Background        = Color3.fromRGB(18, 18, 18),
    Sidebar           = Color3.fromRGB(24, 24, 24),
    TopBar            = Color3.fromRGB(24, 24, 24),
    Element           = Color3.fromRGB(32, 32, 32),
    ElementHover      = Color3.fromRGB(44, 44, 44),
    ElementActive     = Color3.fromRGB(56, 56, 56),
    Accent            = Color3.fromRGB(240, 240, 240),
    AccentHover       = Color3.fromRGB(255, 255, 255),
    AccentDark        = Color3.fromRGB(180, 180, 180),
    Text              = Color3.fromRGB(245, 245, 245),
    TextMuted         = Color3.fromRGB(160, 160, 160),
    TextDark          = Color3.fromRGB(110, 110, 110),
    ToggleOn          = Color3.fromRGB(240, 240, 240),
    ToggleOff         = Color3.fromRGB(48, 48, 48),
    Button            = Color3.fromRGB(200, 200, 200),
    ButtonHover       = Color3.fromRGB(230, 230, 230),
    Success           = Color3.fromRGB(160, 220, 160),
    Warning           = Color3.fromRGB(230, 210, 130),
    Error             = Color3.fromRGB(230, 130, 130),
    Slider            = Color3.fromRGB(44, 44, 44),
    SliderFill        = Color3.fromRGB(240, 240, 240),
    Dropdown          = Color3.fromRGB(36, 36, 36),
    DropdownHover     = Color3.fromRGB(52, 52, 52),
    Input             = Color3.fromRGB(40, 40, 40),
    InputFocus        = Color3.fromRGB(52, 52, 52),
    Border            = Color3.fromRGB(120, 120, 120),
    Separator         = Color3.fromRGB(50, 50, 50),
    Shadow            = Color3.fromRGB(0, 0, 0),
    Overlay           = Color3.fromRGB(0, 0, 0),
})

RegisterTheme("Light", {
    Background        = Color3.fromRGB(245, 247, 250),
    Sidebar           = Color3.fromRGB(238, 241, 246),
    TopBar            = Color3.fromRGB(238, 241, 246),
    Element           = Color3.fromRGB(255, 255, 255),
    ElementHover      = Color3.fromRGB(245, 248, 252),
    ElementActive     = Color3.fromRGB(235, 240, 248),
    Accent            = Color3.fromRGB(0, 120, 220),
    AccentHover       = Color3.fromRGB(30, 145, 245),
    AccentDark        = Color3.fromRGB(0, 90, 180),
    Text              = Color3.fromRGB(30, 32, 45),
    TextMuted         = Color3.fromRGB(100, 105, 125),
    TextDark          = Color3.fromRGB(150, 155, 175),
    ToggleOn          = Color3.fromRGB(0, 150, 240),
    ToggleOff         = Color3.fromRGB(210, 215, 225),
    Button            = Color3.fromRGB(0, 110, 210),
    ButtonHover       = Color3.fromRGB(0, 135, 245),
    Success           = Color3.fromRGB(0, 175, 90),
    Warning           = Color3.fromRGB(220, 150, 0),
    Error             = Color3.fromRGB(220, 50, 50),
    Slider            = Color3.fromRGB(225, 230, 240),
    SliderFill        = Color3.fromRGB(0, 135, 240),
    Dropdown          = Color3.fromRGB(245, 248, 252),
    DropdownHover     = Color3.fromRGB(235, 240, 248),
    Input             = Color3.fromRGB(245, 248, 252),
    InputFocus        = Color3.fromRGB(235, 240, 248),
    Border            = Color3.fromRGB(200, 210, 225),
    Separator         = Color3.fromRGB(220, 225, 235),
    Shadow            = Color3.fromRGB(0, 0, 0),
    Overlay           = Color3.fromRGB(0, 0, 0),
})

RegisterTheme("Sunset", {
    Background        = Color3.fromRGB(24, 15, 20),
    Sidebar           = Color3.fromRGB(32, 20, 28),
    TopBar            = Color3.fromRGB(36, 22, 32),
    Element           = Color3.fromRGB(42, 26, 38),
    ElementHover      = Color3.fromRGB(56, 34, 48),
    ElementActive     = Color3.fromRGB(70, 42, 58),
    Accent            = Color3.fromRGB(255, 100, 100),
    AccentHover       = Color3.fromRGB(255, 130, 130),
    AccentDark        = Color3.fromRGB(220, 70, 70),
    Text              = Color3.fromRGB(255, 240, 240),
    TextMuted         = Color3.fromRGB(200, 165, 175),
    TextDark          = Color3.fromRGB(140, 110, 120),
    ToggleOn          = Color3.fromRGB(255, 100, 100),
    ToggleOff         = Color3.fromRGB(60, 42, 52),
    Button            = Color3.fromRGB(230, 80, 90),
    ButtonHover       = Color3.fromRGB(255, 110, 120),
    Success           = Color3.fromRGB(200, 200, 100),
    Warning           = Color3.fromRGB(255, 190, 80),
    Error             = Color3.fromRGB(255, 80, 80),
    Slider            = Color3.fromRGB(50, 32, 42),
    SliderFill        = Color3.fromRGB(255, 100, 100),
    Dropdown          = Color3.fromRGB(38, 24, 34),
    DropdownHover     = Color3.fromRGB(58, 36, 50),
    Input             = Color3.fromRGB(44, 28, 38),
    InputFocus        = Color3.fromRGB(58, 36, 50),
    Border            = Color3.fromRGB(255, 100, 100),
    Separator         = Color3.fromRGB(60, 40, 50),
    Shadow            = Color3.fromRGB(0, 0, 0),
    Overlay           = Color3.fromRGB(0, 0, 0),
})

RegisterTheme("Forest", {
    Background        = Color3.fromRGB(14, 22, 16),
    Sidebar           = Color3.fromRGB(20, 30, 22),
    TopBar            = Color3.fromRGB(22, 32, 24),
    Element           = Color3.fromRGB(28, 40, 32),
    ElementHover      = Color3.fromRGB(38, 52, 42),
    ElementActive     = Color3.fromRGB(48, 66, 54),
    Accent            = Color3.fromRGB(80, 220, 120),
    AccentHover       = Color3.fromRGB(110, 240, 140),
    AccentDark        = Color3.fromRGB(60, 180, 90),
    Text              = Color3.fromRGB(230, 250, 235),
    TextMuted         = Color3.fromRGB(150, 180, 160),
    TextDark          = Color3.fromRGB(105, 130, 115),
    ToggleOn          = Color3.fromRGB(80, 220, 120),
    ToggleOff         = Color3.fromRGB(40, 55, 46),
    Button            = Color3.fromRGB(60, 180, 90),
    ButtonHover       = Color3.fromRGB(80, 220, 120),
    Success           = Color3.fromRGB(80, 240, 140),
    Warning           = Color3.fromRGB(220, 200, 80),
    Error             = Color3.fromRGB(230, 80, 80),
    Slider            = Color3.fromRGB(36, 52, 42),
    SliderFill        = Color3.fromRGB(80, 220, 120),
    Dropdown          = Color3.fromRGB(28, 44, 34),
    DropdownHover     = Color3.fromRGB(46, 66, 54),
    Input             = Color3.fromRGB(32, 48, 38),
    InputFocus        = Color3.fromRGB(42, 62, 50),
    Border            = Color3.fromRGB(80, 220, 120),
    Separator         = Color3.fromRGB(42, 60, 48),
    Shadow            = Color3.fromRGB(0, 0, 0),
    Overlay           = Color3.fromRGB(0, 0, 0),
})

-- =====================================================
-- UTILITIES
-- =====================================================
local function Create(instanceType, properties, parent)
    local instance = Instance.new(instanceType)
    for prop, value in pairs(properties or {}) do
        pcall(function() instance[prop] = value end)
    end
    if parent then
        instance.Parent = parent
    end
    return instance
end

local function Tween(instance, properties, duration, style, direction)
    if not instance then return end
    local info = TweenInfo.new(
        duration or 0.2,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

local function Safe(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then warn("[SV] " .. tostring(err)) end
    return ok
end

local function Lerp(a, b, t)
    return a + (b - a) * t
end

local function FormatNumber(n)
    if type(n) ~= "number" then return tostring(n) end
    local formatted = tostring(math.floor(n))
    local k
    while true do
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then break end
    end
    return formatted
end

local function FormatTime(seconds)
    seconds = math.floor(seconds or 0)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    if h > 0 then
        return string.format("%02d:%02d:%02d", h, m, s)
    end
    return string.format("%02d:%02d", m, s)
end

local function RoundTo(n, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(n * mult + 0.5) / mult
end

local function GetPing()
    local ok, ping = pcall(function()
        return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    end)
    return ok and ping or 0
end

local function GetMemory()
    local ok, mem = pcall(function()
        return math.floor(Stats:GetTotalMemoryUsageMb())
    end)
    return ok and mem or 0
end

local function IsTouchDevice()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function StartsWith(s, prefix)
    return s:sub(1, #prefix) == prefix
end

-- =====================================================
-- ICON LOADER
-- =====================================================
local IconCache = {}
local IconLoading = {}

local function NormalizeIconId(id)
    if not id then return nil end
    if type(id) == "number" then return "rbxassetid://" .. tostring(id) end
    if type(id) == "string" then
        if StartsWith(id, "rbxassetid://") then return id end
        if id:match("^%d+$") then return "rbxassetid://" .. id end
        return id
    end
    return nil
end

local function PreloadIcon(assetId)
    if not assetId or IconCache[assetId] or IconLoading[assetId] then return end
    IconLoading[assetId] = true
    task.spawn(function()
        pcall(function()
            local tempImg = Instance.new("ImageLabel")
            tempImg.Image = assetId
            ContentProvider:PreloadAsync({ tempImg })
            tempImg:Destroy()
            IconCache[assetId] = true
            IconLoading[assetId] = nil
        end)
    end)
end

local function LoadIcon(id, size, color, parent)
    local assetId = NormalizeIconId(id)
    if not assetId then return nil end

    local img = Create("ImageLabel", {
        Parent = parent,
        BackgroundTransparency = 1,
        Size = size or UDim2.new(0, 20, 0, 20),
        Image = assetId,
        ImageColor3 = color or Color3.fromRGB(255, 255, 255),
        ScaleType = Enum.ScaleType.Fit,
    })

    PreloadIcon(assetId)
    return img
end

-- =====================================================
-- SV LOGO DRAWER
-- =====================================================
local function DrawSVLogo(parent, size, colors)
    size = size or 60
    colors = colors or { primary = Color3.fromRGB(0, 120, 255) }

    local wrap = Create("Frame", {
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, size, 0, size),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    })

    local ring = Create("Frame", {
        Parent = wrap,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = colors.primary,
        BorderSizePixel = 0,
    })
    Create("UICorner", { Parent = ring, CornerRadius = UDim.new(1, 0) })
    Create("UIGradient", {
        Parent = ring,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(139, 92, 246)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 220)),
        }),
        Rotation = 45,
    })

    -- Custom logo asset
    local logoImg = LoadIcon(SV.Icons.Logo, UDim2.new(0.88, 0, 0.88, 0), Color3.fromRGB(255, 255, 255), ring)
    if logoImg then
        logoImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        logoImg.AnchorPoint = Vector2.new(0.5, 0.5)
    end

    Create("UIStroke", {
        Parent = ring,
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 2,
        Transparency = 0.4,
    })

    return wrap
end

-- =====================================================
-- DIALOG SYSTEM
-- =====================================================
local DialogManager = {}
DialogManager.__index = DialogManager

function DialogManager.new(screenGui, colors)
    local self = setmetatable({}, DialogManager)
    self.screenGui = screenGui
    self.colors = colors
    return self
end

function DialogManager:Show(opts)
    opts = opts or {}
    local C = self.colors

    local overlay = Create("Frame", {
        Parent = self.screenGui,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = C.Overlay,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5000,
    })

    local box = Create("Frame", {
        Parent = overlay,
        Size = UDim2.new(0, 420, 0, 0),
        Position = UDim2.new(0.5, -210, 0.5, 0),
        BackgroundColor3 = C.Background,
        BorderSizePixel = 0,
        ZIndex = 5001,
    })
    Create("UICorner", { Parent = box, CornerRadius = UDim.new(0, 14) })
    Create("UIStroke", { Parent = box, Color = C.Border, Thickness = 1.5 })

    Create("TextLabel", {
        Parent = box,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -32, 0, 26),
        Position = UDim2.new(0, 16, 0, 18),
        Text = opts.Title or "Dialog",
        TextColor3 = C.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5002,
    })

    local contentLbl = Create("TextLabel", {
        Parent = box,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -32, 0, 0),
        Position = UDim2.new(0, 16, 0, 54),
        Text = opts.Content or "",
        TextColor3 = C.TextMuted,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        ZIndex = 5002,
    })

    task.wait(0)
    local bounds = contentLbl.TextBounds
    contentLbl.Size = UDim2.new(1, -32, 0, bounds.Y)

    local inputBox
    local inputOffset = 0
    if opts.InputPlaceholder then
        inputBox = Create("TextBox", {
            Parent = box,
            Size = UDim2.new(1, -32, 0, 34),
            Position = UDim2.new(0, 16, 0, 54 + bounds.Y + 12),
            BackgroundColor3 = C.Input,
            BorderSizePixel = 0,
            Text = opts.InputDefault or "",
            TextColor3 = C.Text,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            PlaceholderText = opts.InputPlaceholder,
            PlaceholderColor3 = C.TextDark,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
            ZIndex = 5002,
        })
        Create("UICorner", { Parent = inputBox, CornerRadius = UDim.new(0, 6) })
        Create("UIPadding", { Parent = inputBox, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })
        inputOffset = 46
    end

    local btnY = 54 + bounds.Y + 12 + inputOffset + 12
    local btnRow = Create("Frame", {
        Parent = box,
        Size = UDim2.new(1, -32, 0, 40),
        Position = UDim2.new(0, 16, 0, btnY),
        BackgroundTransparency = 1,
        ZIndex = 5002,
    })
    Create("UIListLayout", {
        Parent = btnRow,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 8),
    })

    local function close()
        Tween(overlay, { BackgroundTransparency = 1 }, 0.2)
        Tween(box, { Size = UDim2.new(0, 420, 0, 0), Position = UDim2.new(0.5, -210, 0.5, 0) }, 0.2)
        task.wait(0.22)
        overlay:Destroy()
    end

    local function addButton(text, variant, callback)
        local variantColors = {
            Primary = C.Button,
            Success = C.Success,
            Warning = C.Warning,
            Error = C.Error,
            Ghost = C.Element,
        }
        local baseColor = variantColors[variant] or C.Button

        local btn = Create("TextButton", {
            Parent = btnRow,
            Size = UDim2.new(0, 110, 1, 0),
            BackgroundColor3 = baseColor,
            BorderSizePixel = 0,
            Text = text,
            TextColor3 = C.Text,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
            ZIndex = 5003,
        })
        Create("UICorner", { Parent = btn, CornerRadius = UDim.new(0, 6) })

        btn.MouseEnter:Connect(function()
            Tween(btn, { BackgroundColor3 = C.AccentHover }, 0.1)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, { BackgroundColor3 = baseColor }, 0.1)
        end)

        btn.MouseButton1Click:Connect(function()
            local inputValue = inputBox and inputBox.Text or nil
            if callback then Safe(callback, inputValue) end
            close()
        end)
    end

    if opts.Buttons then
        for _, b in ipairs(opts.Buttons) do
            addButton(b.Text or "OK", b.Variant or "Primary", b.Callback)
        end
    else
        addButton("Cancel", "Ghost", nil)
        addButton("Confirm", "Primary", opts.OnConfirm)
    end

    Tween(overlay, { BackgroundTransparency = 0.55 }, 0.2)
    local finalHeight = btnY + 56
    Tween(box, { Size = UDim2.new(0, 420, 0, finalHeight), Position = UDim2.new(0.5, -210, 0.5, -finalHeight / 2) }, 0.3, Enum.EasingStyle.Back)

    return close
end

-- =====================================================
-- TOOLTIP SYSTEM
-- =====================================================
local function AttachTooltip(target, text, colors)
    local C = colors
    local tooltip

    target.MouseEnter:Connect(function()
        if not target.Parent then return end
        local mouse = UserInputService:GetMouseLocation()
        local parentGui = target:FindFirstAncestorWhichIsA("ScreenGui") or LP:FindFirstChild("PlayerGui")
        if not parentGui then return end
        tooltip = Create("Frame", {
            Parent = parentGui,
            Size = UDim2.new(0, 0, 0, 26),
            Position = UDim2.new(0, mouse.X + 12, 0, mouse.Y + 12),
            BackgroundColor3 = C.Background,
            BorderSizePixel = 0,
            ZIndex = 6000,
        })
        Create("UICorner", { Parent = tooltip, CornerRadius = UDim.new(0, 6) })
        Create("UIStroke", { Parent = tooltip, Color = C.Border, Thickness = 1 })

        local label = Create("TextLabel", {
            Parent = tooltip,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -16, 1, 0),
            Position = UDim2.new(0, 8, 0, 0),
            Text = text,
            TextColor3 = C.Text,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 6001,
        })

        task.wait(0)
        local b = label.TextBounds
        tooltip.Size = UDim2.new(0, b.X + 20, 0, 26)
    end)

    target.MouseLeave:Connect(function()
        if tooltip then
            tooltip:Destroy()
            tooltip = nil
        end
    end)
end

-- =====================================================
-- CONTEXT MENU
-- =====================================================
local function AttachContextMenu(target, options, colors)
    local C = colors
    local menu

    target.MouseButton2Click:Connect(function()
        if menu then menu:Destroy() end
        local mouse = UserInputService:GetMouseLocation()
        local parentGui = target:FindFirstAncestorWhichIsA("ScreenGui") or LP:FindFirstChild("PlayerGui")
        if not parentGui then return end

        menu = Create("Frame", {
            Parent = parentGui,
            Size = UDim2.new(0, 160, 0, #options * 30 + 8),
            Position = UDim2.new(0, mouse.X, 0, mouse.Y),
            BackgroundColor3 = C.Background,
            BorderSizePixel = 0,
            ZIndex = 7000,
        })
        Create("UICorner", { Parent = menu, CornerRadius = UDim.new(0, 8) })
        Create("UIStroke", { Parent = menu, Color = C.Border, Thickness = 1 })
        Create("UIListLayout", { Parent = menu, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })
        Create("UIPadding", { Parent = menu, PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4) })

        for _, opt in ipairs(options) do
            local btn = Create("TextButton", {
                Parent = menu,
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundColor3 = C.Element,
                BorderSizePixel = 0,
                Text = opt.Text or "Item",
                TextColor3 = C.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                ZIndex = 7001,
            })
            Create("UICorner", { Parent = btn, CornerRadius = UDim.new(0, 4) })
            Create("UIPadding", { Parent = btn, PaddingLeft = UDim.new(0, 10) })

            btn.MouseEnter:Connect(function()
                Tween(btn, { BackgroundColor3 = C.ElementHover }, 0.1)
            end)
            btn.MouseLeave:Connect(function()
                Tween(btn, { BackgroundColor3 = C.Element }, 0.1)
            end)
            btn.MouseButton1Click:Connect(function()
                if opt.Callback then Safe(opt.Callback) end
                menu:Destroy()
                menu = nil
            end)
        end

        task.spawn(function()
            local conn
            conn = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    task.wait(0.05)
                    if menu then
                        menu:Destroy()
                        menu = nil
                    end
                    if conn then conn:Disconnect() end
                end
            end)
        end)
    end)
end

-- =====================================================
-- NOTIFICATION SYSTEM
-- =====================================================
local NotifySystem = {}
NotifySystem.__index = NotifySystem

function NotifySystem.new(screenGui, colors, options)
    local self = setmetatable({}, NotifySystem)
    self.screenGui = screenGui
    self.colors = colors
    self.options = options or {}
    self.container = Create("Frame", {
        Parent = screenGui,
        Size = UDim2.new(0, 340, 1, -40),
        Position = UDim2.new(1, -360, 0, 20),
        BackgroundTransparency = 1,
        ZIndex = 1000,
    })
    Create("UIListLayout", {
        Parent = self.container,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,
    })
    self.active = {}
    return self
end

function NotifySystem:Push(opts)
    opts = opts or {}
    local C = self.colors
    local title = opts.Title or "Notification"
    local content = opts.Content or ""
    local duration = opts.Duration or 5
    local nType = opts.Type or "Info"
    local iconId = opts.Icon

    local typeColor = C.Accent
    if nType == "Success" then typeColor = C.Success
    elseif nType == "Warning" then typeColor = C.Warning
    elseif nType == "Error" then typeColor = C.Error end

    local limit = self.options.Limit or 5
    while #self.active >= limit do
        local oldest = table.remove(self.active, 1)
        if oldest and oldest.Parent then oldest:Destroy() end
    end

    local n = Create("Frame", {
        Parent = self.container,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = C.Element,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })
    Create("UICorner", { Parent = n, CornerRadius = UDim.new(0, 10) })
    Create("UIStroke", { Parent = n, Color = typeColor, Thickness = 1.5, Transparency = 0.4 })

    Create("Frame", {
        Parent = n,
        Size = UDim2.new(0, 3, 1, -16),
        Position = UDim2.new(0, 0, 0, 8),
        BackgroundColor3 = typeColor,
        BorderSizePixel = 0,
    })

    local iconCircle = Create("Frame", {
        Parent = n,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 14, 0, 12),
        BackgroundColor3 = typeColor,
        BorderSizePixel = 0,
    })
    Create("UICorner", { Parent = iconCircle, CornerRadius = UDim.new(1, 0) })

    if iconId then
        local img = LoadIcon(iconId, UDim2.new(0.65, 0, 0.65, 0), Color3.fromRGB(255, 255, 255), iconCircle)
        if img then
            img.Position = UDim2.new(0.5, 0, 0.5, 0)
            img.AnchorPoint = Vector2.new(0.5, 0.5)
        end
    else
        local icons = { Info = "i", Success = "OK", Warning = "!", Error = "X" }
        Create("TextLabel", {
            Parent = iconCircle,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Text = icons[nType] or "i",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12,
            Font = Enum.Font.GothamBold,
        })
    end

    Create("TextLabel", {
        Parent = n,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -64, 0, 18),
        Position = UDim2.new(0, 54, 0, 10),
        Text = title,
        TextColor3 = C.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local contentLbl = Create("TextLabel", {
        Parent = n,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -64, 0, 0),
        Position = UDim2.new(0, 54, 0, 30),
        Text = content,
        TextColor3 = C.TextMuted,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
    })

    task.wait(0)
    local bounds = contentLbl.TextBounds
    local h = 30 + math.max(bounds.Y, 16) + 12
    contentLbl.Size = UDim2.new(1, -64, 0, bounds.Y)
    n.Size = UDim2.new(1, 0, 0, h)

    table.insert(self.active, n)

    n.Position = UDim2.new(1, 60, 0, 0)
    Tween(n, { Position = UDim2.new(0, 0, 0, 0) }, 0.32, Enum.EasingStyle.Quint)

    task.delay(duration, function()
        if n.Parent then
            Tween(n, { Position = UDim2.new(1, 60, 0, 0) }, 0.28, Enum.EasingStyle.Quad)
            task.wait(0.3)
            for i, v in ipairs(self.active) do
                if v == n then
                    table.remove(self.active, i)
                    break
                end
            end
            pcall(function() n:Destroy() end)
        end
    end)

    return n
end

-- =====================================================
-- MAIN WINDOW
-- =====================================================
function SV:CreateWindow(options)
    options = options or {}

    local WindowName        = options.Name or "ScriptVault"
    local LoadingTitle      = options.LoadingTitle or WindowName
    local LoadingSubtitle   = options.LoadingSubtitle or "Loading..."
    local ThemeName         = options.Theme or "Ocean"
    local Width             = options.Width or 760
    local Height            = options.Height or 520
    local MinWidth          = options.MinWidth or 560
    local MinHeight         = options.MinHeight or 360
    local SidebarWidth      = options.SidebarWidth or 210
    local ToggleKeybind     = options.ToggleKeybind or Enum.KeyCode.RightShift
    local ShowWatermark     = options.Watermark
    if ShowWatermark == nil then ShowWatermark = true end
    local ConfigurationSaving = options.ConfigurationSaving or { Enabled = false }
    local AccentIcon        = options.Icon or SV.Icons.Logo
    local Resizable         = options.Resizable
    if Resizable == nil then Resizable = true end

    local Colors = Themes[ThemeName] or Themes.Ocean

    -- ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "ScriptVaultUI_" .. tostring(math.random(100000, 999999)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        DisplayOrder = 999999,
    })

    local attached = false
    pcall(function()
        if gethui then
            ScreenGui.Parent = gethui()
            attached = true
        elseif LP:FindFirstChild("PlayerGui") then
            ScreenGui.Parent = LP.PlayerGui
            attached = true
        end
    end)
    if not attached then
        pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
    end

    -- ==========================================
    -- LOADING SCREEN
    -- ==========================================
    local LoadingFrame = Create("Frame", {
        Size = UDim2.new(0, 420, 0, 260),
        Position = UDim2.new(0.5, -210, 0.5, -130),
        BackgroundColor3 = Colors.Background,
        BorderSizePixel = 0,
        ZIndex = 100,
        Parent = ScreenGui,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 16) }, LoadingFrame)
    Create("UIStroke", { Color = Colors.Accent, Thickness = 2 }, LoadingFrame)

    local GlowRing = Create("Frame", {
        Parent = LoadingFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 24, 1, 24),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 99,
    })
    Create("UICorner", { Parent = GlowRing, CornerRadius = UDim.new(0, 20) })
    Create("UIStroke", { Parent = GlowRing, Color = Colors.Accent, Thickness = 1, Transparency = 0.5 })

    local LoadLogoWrap = Create("Frame", {
        Parent = LoadingFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 110, 0, 110),
        Position = UDim2.new(0.5, -55, 0, 22),
    })
    local logo = DrawSVLogo(LoadLogoWrap, 110, { primary = Colors.Accent })

    task.spawn(function()
        while logo and logo.Parent do
            Tween(logo, { Size = UDim2.new(0, 100, 0, 100) }, 0.7, Enum.EasingStyle.Sine)
            task.wait(0.7)
            if not logo.Parent then break end
            Tween(logo, { Size = UDim2.new(0, 110, 0, 110) }, 0.7, Enum.EasingStyle.Sine)
            task.wait(0.7)
        end
    end)

    task.spawn(function()
        local rot = 0
        while GlowRing.Parent do
            rot = (rot + 3) % 360
            GlowRing.Rotation = rot
            task.wait(0.03)
        end
    end)

    Create("TextLabel", {
        Parent = LoadingFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 142),
        Text = LoadingTitle,
        TextColor3 = Colors.Text,
        TextSize = 24,
        Font = Enum.Font.GothamBold,
    })

    Create("TextLabel", {
        Parent = LoadingFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        Position = UDim2.new(0, 0, 0, 174),
        Text = LoadingSubtitle,
        TextColor3 = Colors.Accent,
        TextSize = 13,
        Font = Enum.Font.Gotham,
    })

    local LoadBarBg = Create("Frame", {
        Parent = LoadingFrame,
        Size = UDim2.new(0.75, 0, 0, 6),
        Position = UDim2.new(0.125, 0, 0, 208),
        BackgroundColor3 = Colors.ToggleOff,
        BorderSizePixel = 0,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0) }, LoadBarBg)

    local LoadBarFill = Create("Frame", {
        Parent = LoadBarBg,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Colors.Accent,
        BorderSizePixel = 0,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0) }, LoadBarFill)
    Create("UIGradient", {
        Parent = LoadBarFill,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Colors.Accent),
            ColorSequenceKeypoint.new(1, Colors.AccentHover),
        }),
        Rotation = 15,
    })

    local LoadPct = Create("TextLabel", {
        Parent = LoadingFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 0, 224),
        Text = "0%",
        TextColor3 = Colors.TextMuted,
        TextSize = 11,
        Font = Enum.Font.Gotham,
    })

    -- ==========================================
    -- MAIN WINDOW
    -- ==========================================
    local Window = Create("Frame", {
        Name = "MainWindow",
        Size = UDim2.new(0, Width, 0, Height),
        Position = UDim2.new(0.5, -Width / 2, 0.5, -Height / 2),
        BackgroundColor3 = Colors.Background,
        BorderSizePixel = 0,
        Active = true,
        Visible = false,
        Parent = ScreenGui,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 14) }, Window)
    Create("UIStroke", { Color = Colors.Border, Thickness = 1.5 }, Window)

    local shadow = Create("Frame", {
        Parent = Window,
        BackgroundColor3 = Colors.Shadow,
        BackgroundTransparency = 0.75,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 12, 1, 12),
        Position = UDim2.new(0, -6, 0, -6),
        ZIndex = -1,
    })
    Create("UICorner", { Parent = shadow, CornerRadius = UDim.new(0, 18) })

    -- ==========================================
    -- TOP BAR
    -- ==========================================
    local TopBar = Create("Frame", {
        Parent = Window,
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = Colors.TopBar,
        BorderSizePixel = 0,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 14) }, TopBar)
    Create("Frame", {
        Parent = TopBar,
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Colors.TopBar,
        BorderSizePixel = 0,
    })

    local TopLogoHolder = Create("Frame", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 12, 0.5, -14),
    })
    LoadIcon(AccentIcon, UDim2.new(1, 0, 1, 0), Color3.fromRGB(255, 255, 255), TopLogoHolder)

    Create("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -350, 1, 0),
        Position = UDim2.new(0, 48, 0, 0),
        Text = WindowName,
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- Search bar
    local SearchWrap = Create("Frame", {
        Parent = TopBar,
        Size = UDim2.new(0, 220, 0, 30),
        Position = UDim2.new(1, -330, 0.5, -15),
        BackgroundColor3 = Colors.Input,
        BorderSizePixel = 0,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8) }, SearchWrap)
    local SearchStroke = Create("UIStroke", { Parent = SearchWrap, Color = Colors.Separator, Thickness = 1 })

    local searchIcon = LoadIcon(SV.Icons.Info, UDim2.new(0, 16, 0, 16), Colors.TextMuted, SearchWrap)
    if searchIcon then searchIcon.Position = UDim2.new(0, 8, 0.5, -8) end

    local SearchBox = Create("TextBox", {
        Parent = SearchWrap,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -34, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        Text = "",
        PlaceholderText = "Search...",
        PlaceholderColor3 = Colors.TextDark,
        TextColor3 = Colors.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
    })

    SearchBox.Focused:Connect(function()
        Tween(SearchStroke, { Color = Colors.Accent }, 0.15)
    end)
    SearchBox.FocusLost:Connect(function()
        Tween(SearchStroke, { Color = Colors.Separator }, 0.15)
    end)

    local MinBtn = Create("TextButton", {
        Parent = TopBar,
        Size = UDim2.new(0, 30, 0, 28),
        Position = UDim2.new(1, -105, 0.5, -14),
        BackgroundColor3 = Colors.Warning,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 7) }, MinBtn)
    Create("Frame", {
        Parent = MinBtn,
        Size = UDim2.new(0, 12, 0, 2),
        Position = UDim2.new(0.5, -6, 0.5, -1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
    })

    local CloseBtn = Create("TextButton", {
        Parent = TopBar,
        Size = UDim2.new(0, 30, 0, 28),
        Position = UDim2.new(1, -70, 0.5, -14),
        BackgroundColor3 = Colors.Error,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 7) }, CloseBtn)
    for _, rot in ipairs({ 45, -45 }) do
        Create("Frame", {
            Parent = CloseBtn,
            Size = UDim2.new(0, 12, 0, 2),
            Position = UDim2.new(0.5, -6, 0.5, -1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Rotation = rot,
        })
    end

    MinBtn.MouseEnter:Connect(function() Tween(MinBtn, { BackgroundColor3 = Color3.fromRGB(245, 175, 20) }, 0.1) end)
    MinBtn.MouseLeave:Connect(function() Tween(MinBtn, { BackgroundColor3 = Colors.Warning }, 0.1) end)
    CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, { BackgroundColor3 = Color3.fromRGB(245, 80, 80) }, 0.1) end)
    CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, { BackgroundColor3 = Colors.Error }, 0.1) end)

    -- ==========================================
    -- SIDEBAR
    -- ==========================================
    local Sidebar = Create("Frame", {
        Parent = Window,
        Size = UDim2.new(0, SidebarWidth, 1, -46),
        Position = UDim2.new(0, 0, 0, 46),
        BackgroundColor3 = Colors.Sidebar,
        BorderSizePixel = 0,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 0, 0, 14) }, Sidebar)

    local LogoPanel = Create("Frame", {
        Parent = Sidebar,
        Size = UDim2.new(1, 0, 0, 130),
        BackgroundTransparency = 1,
    })

    local LogoHolder = Create("Frame", {
        Parent = LogoPanel,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 80, 0, 80),
        Position = UDim2.new(0.5, -40, 0, 16),
    })
    DrawSVLogo(LogoHolder, 80, { primary = Colors.Accent })

    Create("TextLabel", {
        Parent = LogoPanel,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        Position = UDim2.new(0, 0, 0, 100),
        Text = WindowName,
        TextColor3 = Colors.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
    })

    Create("TextLabel", {
        Parent = LogoPanel,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 0, 116),
        Text = "v" .. SV._VERSION,
        TextColor3 = Colors.Accent,
        TextSize = 10,
        Font = Enum.Font.Gotham,
    })

    local TabList = Create("ScrollingFrame", {
        Parent = Sidebar,
        Size = UDim2.new(1, 0, 1, -132),
        Position = UDim2.new(0, 0, 0, 132),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Colors.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    })
    Create("UIListLayout", {
        Parent = TabList,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    Create("UIPadding", {
        Parent = TabList,
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 8),
    })

    -- ==========================================
    -- CONTENT AREA
    -- ==========================================
    local ContentArea = Create("Frame", {
        Parent = Window,
        Size = UDim2.new(1, -SidebarWidth, 1, -46),
        Position = UDim2.new(0, SidebarWidth, 0, 46),
        BackgroundColor3 = Colors.Background,
        BorderSizePixel = 0,
        ClipsDescendants = false,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 0, 14, 0) }, ContentArea)

    -- ==========================================
    -- NOTIFICATIONS
    -- ==========================================
    local Notify = NotifySystem.new(ScreenGui, Colors, { Limit = 5 })

    -- ==========================================
    -- DIALOG
    -- ==========================================
    local Dialog = DialogManager.new(ScreenGui, Colors)

    -- ==========================================
    -- WATERMARK
    -- ==========================================
    local Watermark
    if ShowWatermark then
        Watermark = Create("Frame", {
            Parent = ScreenGui,
            Size = UDim2.new(0, 300, 0, 30),
            Position = UDim2.new(0, 16, 0, 16),
            BackgroundColor3 = Colors.Background,
            BackgroundTransparency = 0.15,
            BorderSizePixel = 0,
            ZIndex = 999,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 8) }, Watermark)
        Create("UIStroke", { Parent = Watermark, Color = Colors.Accent, Thickness = 1, Transparency = 0.4 })

        local wmLogo = Create("Frame", {
            Parent = Watermark,
            Size = UDim2.new(0, 22, 0, 22),
            Position = UDim2.new(0, 4, 0.5, -11),
            BackgroundColor3 = Colors.Accent,
            BorderSizePixel = 0,
        })
        Create("UICorner", { Parent = wmLogo, CornerRadius = UDim.new(1, 0) })
        local wmIcon = LoadIcon(AccentIcon, UDim2.new(0.85, 0, 0.85, 0), Color3.fromRGB(255, 255, 255), wmLogo)
        if wmIcon then
            wmIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
            wmIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        end

        local wmText = Create("TextLabel", {
            Parent = Watermark,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -38, 1, 0),
            Position = UDim2.new(0, 32, 0, 0),
            Text = "ScriptVault | -- FPS | -- ms | -- MB",
            TextColor3 = Colors.Text,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        task.spawn(function()
            local frames, t0 = 0, tick()
            RunService.RenderStepped:Connect(function()
                frames = frames + 1
                if tick() - t0 >= 1 then
                    pcall(function()
                        wmText.Text = string.format(
                            "ScriptVault | %d FPS | %d ms | %d MB",
                            frames, GetPing(), GetMemory()
                        )
                    end)
                    frames, t0 = 0, tick()
                end
            end)
        end)
    end

    -- ==========================================
    -- DRAGGING
    -- ==========================================
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Window.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- ==========================================
    -- RESIZING
    -- ==========================================
    if Resizable then
        local ResizeHandle = Create("TextButton", {
            Parent = Window,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, -20, 1, -20),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 10,
        })

        for i = 1, 3 do
            local dot = Create("Frame", {
                Parent = ResizeHandle,
                Size = UDim2.new(0, 3, 0, 3),
                Position = UDim2.new(1, -4 - (i - 1) * 4, 1, -4),
                BackgroundColor3 = Colors.TextMuted,
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
            })
            Create("UICorner", { Parent = dot, CornerRadius = UDim.new(1, 0) })
        end

        local rDragging, rStart, rSize = false, nil, nil

        ResizeHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                rDragging = true
                rStart = input.Position
                rSize = Window.AbsoluteSize
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        rDragging = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if rDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - rStart
                Window.Size = UDim2.new(
                    0, math.max(MinWidth, rSize.X + delta.X),
                    0, math.max(MinHeight, rSize.Y + delta.Y)
                )
            end
        end)
    end

    -- ==========================================
    -- MINIMIZE / RESTORE
    -- ==========================================
    local isMinimized = false

    local MinIcon = Create("TextButton", {
        Parent = ScreenGui,
        Size = UDim2.new(0, 64, 0, 64),
        Position = UDim2.new(1, -84, 0.5, -32),
        BackgroundColor3 = Colors.Accent,
        BorderSizePixel = 0,
        Text = "",
        Visible = false,
        ZIndex = 500,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0) }, MinIcon)
    Create("UIStroke", { Parent = MinIcon, Color = Colors.AccentHover, Thickness = 2 })
    local minIconImg = LoadIcon(AccentIcon, UDim2.new(0.75, 0, 0.75, 0), Color3.fromRGB(255, 255, 255), MinIcon)
    if minIconImg then
        minIconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        minIconImg.AnchorPoint = Vector2.new(0.5, 0.5)
    end

    local function Minimize()
        if isMinimized then return end
        isMinimized = true
        Tween(Window, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(1, -84, 0.5, -32),
        }, 0.25)
        task.wait(0.25)
        Window.Visible = false
        MinIcon.Visible = true
        MinIcon.Size = UDim2.new(0, 0, 0, 0)
        Tween(MinIcon, { Size = UDim2.new(0, 64, 0, 64) }, 0.35, Enum.EasingStyle.Back)
    end

    local function Restore()
        if not isMinimized then return end
        isMinimized = false
        Tween(MinIcon, { Size = UDim2.new(0, 0, 0, 0) }, 0.2)
        task.wait(0.2)
        MinIcon.Visible = false
        Window.Visible = true
        Window.Size = UDim2.new(0, 0, 0, 0)
        Window.Position = UDim2.new(1, -84, 0.5, -32)
        Tween(Window, {
            Size = UDim2.new(0, Width, 0, Height),
            Position = UDim2.new(0.5, -Width / 2, 0.5, -Height / 2),
        }, 0.35, Enum.EasingStyle.Back)
    end

    MinBtn.MouseButton1Click:Connect(Minimize)
    MinIcon.MouseButton1Click:Connect(Restore)

    local function CloseWindow()
        Tween(Window, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
        }, 0.25)
        task.wait(0.25)
        ScreenGui:Destroy()
    end

    CloseBtn.MouseButton1Click:Connect(CloseWindow)

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == ToggleKeybind then
            if isMinimized then Restore() else Minimize() end
        end
    end)

    -- ==========================================
    -- TAB SYSTEM
    -- ==========================================
    local Tabs, TabContents = {}, {}
    local CurrentTab = nil
    local searchQuery = ""

    local function CreateTab(name, iconId, tabOptions)
        tabOptions = tabOptions or {}
        local order = tabOptions.Order or (#Tabs + 1)

        local TabBtn = Create("TextButton", {
            Parent = TabList,
            Size = UDim2.new(1, 0, 0, 42),
            BackgroundColor3 = Colors.Element,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = order,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 8) }, TabBtn)

        local Indicator = Create("Frame", {
            Parent = TabBtn,
            Size = UDim2.new(0, 3, 0, 24),
            Position = UDim2.new(0, 0, 0.5, -12),
            BackgroundColor3 = Colors.Accent,
            BorderSizePixel = 0,
            Visible = false,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 3) }, Indicator)

        local resolvedIcon = iconId or SV.Icons.Home
        local Icon = LoadIcon(resolvedIcon, UDim2.new(0, 20, 0, 20), Colors.TextMuted, TabBtn)
        if Icon then
            Icon.Position = UDim2.new(0, 14, 0.5, -10)
        end

        local Text = Create("TextLabel", {
            Parent = TabBtn,
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 44, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Colors.TextMuted,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local Badge
        if tabOptions.Badge then
            Badge = Create("Frame", {
                Parent = TabBtn,
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(1, -26, 0.5, -9),
                BackgroundColor3 = Colors.Accent,
                BorderSizePixel = 0,
            })
            Create("UICorner", { Parent = Badge, CornerRadius = UDim.new(1, 0) })
            Create("TextLabel", {
                Parent = Badge,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = tostring(tabOptions.Badge),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 10,
                Font = Enum.Font.GothamBold,
            })
        end

        local Content = Create("ScrollingFrame", {
            Parent = ContentArea,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Colors.Accent,
            BorderSizePixel = 0,
            ClipsDescendants = false,
        })
        Create("UIListLayout", {
            Parent = Content,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })
        Create("UIPadding", {
            Parent = Content,
            PaddingTop = UDim.new(0, 16),
            PaddingBottom = UDim.new(0, 16),
            PaddingLeft = UDim.new(0, 16),
            PaddingRight = UDim.new(0, 16),
        })

        local function Activate()
            if CurrentTab and CurrentTab ~= TabBtn then
                Tween(CurrentTab, { BackgroundColor3 = Colors.Element }, 0.15)
                local oldInd = CurrentTab:FindFirstChild("Indicator")
                if oldInd then oldInd.Visible = false end
                local oldIcon = CurrentTab:FindFirstChildOfClass("ImageLabel")
                if oldIcon then Tween(oldIcon, { ImageColor3 = Colors.TextMuted }, 0.15) end
                local oldText = CurrentTab:FindFirstChildOfClass("TextLabel")
                if oldText then Tween(oldText, { TextColor3 = Colors.TextMuted }, 0.15) end
            end
            CurrentTab = TabBtn
            Tween(TabBtn, { BackgroundColor3 = Colors.ElementHover }, 0.15)
            Indicator.Visible = true
            if Icon then Tween(Icon, { ImageColor3 = Colors.Text }, 0.15) end
            Tween(Text, { TextColor3 = Colors.Text }, 0.15)

            for tabName, tabContent in pairs(TabContents) do
                tabContent.Visible = (tabName == name)
            end
        end

        TabBtn.MouseButton1Click:Connect(Activate)
        TabBtn.MouseEnter:Connect(function()
            if CurrentTab ~= TabBtn then
                Tween(TabBtn, { BackgroundColor3 = Colors.ElementHover }, 0.12)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if CurrentTab ~= TabBtn then
                Tween(TabBtn, { BackgroundColor3 = Colors.Element }, 0.12)
            end
        end)

        table.insert(Tabs, { name = name, button = TabBtn, content = Content })
        TabContents[name] = Content
        if not CurrentTab then Activate() end

        -- ==========================================
        -- ELEMENT BUILDERS
        -- ==========================================
        local ElementID = 0
        local function NextOrder()
            ElementID = ElementID + 1
            return ElementID
        end

        local Tab = {}

        function Tab:CreateSection(title)
            local c = Create("Frame", {
                Parent = Content,
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                LayoutOrder = NextOrder(),
            })
            Create("Frame", {
                Parent = c,
                Size = UDim2.new(0, 3, 0, 16),
                Position = UDim2.new(0, 0, 0.5, -8),
                BackgroundColor3 = Colors.Accent,
                BorderSizePixel = 0,
            })
            Create("TextLabel", {
                Parent = c,
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = string.upper(title),
                TextColor3 = Colors.TextMuted,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            return c
        end

        function Tab:CreateDivider()
            return Create("Frame", {
                Parent = Content,
                Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = Colors.Separator,
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
            })
        end

        function Tab:CreateLabel(text)
            return Create("TextLabel", {
                Parent = Content,
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Colors.Text,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = NextOrder(),
            })
        end

        function Tab:CreateParagraph(opts)
            opts = opts or {}
            local c = Create("Frame", {
                Parent = Content,
                Size = UDim2.new(1, 0, 0, 100),
                BackgroundColor3 = Colors.Element,
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
            })
            Create("UICorner", { Parent = c, CornerRadius = UDim.new(0, 8) })
            Create("UIStroke", { Parent = c, Color = Colors.Separator, Thickness = 1 })

            local iconImg = LoadIcon(SV.Icons.Info, UDim2.new(0, 18, 0, 18), Colors.Accent, c)
            if iconImg then iconImg.Position = UDim2.new(0, 12, 0, 12) end

            Create("TextLabel", {
                Parent = c,
                Size = UDim2.new(1, -50, 0, 22),
                Position = UDim2.new(0, 38, 0, 10),
                BackgroundTransparency = 1,
                Text = opts.Title or "Info",
                TextColor3 = Colors.Text,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local body = Create("TextLabel", {
                Parent = c,
                Size = UDim2.new(1, -24, 1, -44),
                Position = UDim2.new(0, 12, 0, 36),
                BackgroundTransparency = 1,
                Text = opts.Content or "",
                TextColor3 = Colors.TextMuted,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true,
            })

            task.wait(0)
            local bounds = body.TextBounds
            c.Size = UDim2.new(1, 0, 0, 44 + bounds.Y + 6)
            body.Size = UDim2.new(1, -24, 0, bounds.Y)

            return c
        end

        function Tab:CreateToggle(opts)
            opts = opts or {}
            local c = Create("Frame", {
                Parent = Content,
                Size = UDim2.new(1, 0, 0, opts.Description and 58 or 44),
                BackgroundColor3 = Colors.Element,
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
            })
            Create("UICorner", { Parent = c, CornerRadius = UDim.new(0, 8) })

            local btn = Create("TextButton", {
                Parent = c,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
            })

            Create("TextLabel", {
                Parent = c,
                Size = UDim2.new(1, -75, 0, 20),
                Position = UDim2.new(0, 14, 0, opts.Description and 10 or 12),
                BackgroundTransparency = 1,
                Text = opts.Name or "Toggle",
                TextColor3 = Colors.Text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            if opts.Description then
                Create("TextLabel", {
                    Parent = c,
                    Size = UDim2.new(1, -75, 0, 16),
                    Position = UDim2.new(0, 14, 0, 30),
                    BackgroundTransparency = 1,
                    Text = opts.Description,
                    TextColor3 = Colors.TextDark,
                    TextSize = 10,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
            end

            local track = Create("Frame", {
                Parent = c,
                Size = UDim2.new(0, 44, 0, 24),
                Position = UDim2.new(1, -58, 0.5, -12),
                BackgroundColor3 = (opts.CurrentValue or false) and Colors.ToggleOn or Colors.ToggleOff,
                BorderSizePixel = 0,
            })
            Create("UICorner", { Parent = track, CornerRadius = UDim.new(1, 0) })

            local knob = Create("Frame", {
                Parent = track,
                Size = UDim2.new(0, 18, 0, 18),
                Position = (opts.CurrentValue or false) and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
            })
            Create("UICorner", { Parent = knob, CornerRadius = UDim.new(1, 0) })

            local value = opts.CurrentValue or false

            local function setValue(v)
                value = v
                Tween(knob, {
                    Position = v and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                }, 0.18)
                Tween(track, { BackgroundColor3 = v and Colors.ToggleOn or Colors.ToggleOff }, 0.18)
                if opts.Callback then Safe(opts.Callback, v) end
            end

            btn.MouseButton1Click:Connect(function() setValue(not value) end)
            c.MouseEnter:Connect(function() Tween(c, { BackgroundColor3 = Colors.ElementHover }, 0.12) end)
            c.MouseLeave:Connect(function() Tween(c, { BackgroundColor3 = Colors.Element }, 0.12) end)

            if opts.Tooltip then AttachTooltip(c, opts.Tooltip, Colors) end

            return {
                Container = c,
                SetValue = setValue,
                GetValue = function() return value end,
                Set = setValue,
            }
        end

        function Tab:CreateButton(opts)
            opts = opts or {}
            local variant = opts.Variant or "Primary"
            local variantColors = {
                Primary = { base = Colors.Button, hover = Colors.ButtonHover },
                Success = { base = Colors.Success, hover = Color3.fromRGB(0, 220, 130) },
                Warning = { base = Colors.Warning, hover = Color3.fromRGB(245, 180, 20) },
                Error = { base = Colors.Error, hover = Color3.fromRGB(245, 80, 80) },
                Ghost = { base = Colors.Element, hover = Colors.ElementHover },
            }
            local vc = variantColors[variant] or variantColors.Primary

            local btn = Create("TextButton", {
                Parent = Content,
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = vc.base,
                BorderSizePixel = 0,
                Text = opts.Name or "Button",
                TextColor3 = Colors.Text,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                AutoButtonColor = false,
                LayoutOrder = NextOrder(),
            })
            Create("UICorner", { Parent = btn, CornerRadius = UDim.new(0, 8) })

            btn.MouseEnter:Connect(function()
                Tween(btn, { BackgroundColor3 = vc.hover, Size = UDim2.new(1, 2, 0, 42) }, 0.12)
            end)
            btn.MouseLeave:Connect(function()
                Tween(btn, { BackgroundColor3 = vc.base, Size = UDim2.new(1, 0, 0, 42) }, 0.12)
            end)
            btn.MouseButton1Click:Connect(function()
                if opts.Callback then Safe(opts.Callback) end
            end)

            if opts.Tooltip then AttachTooltip(btn, opts.Tooltip, Colors) end

            return btn
        end

        function Tab:CreateSlider(opts)
            opts = opts or {}
            local range = opts.Range or { 0, 100 }
            local mn, mx = range[1], range[2]
            local step = opts.Increment or 1
            local value = opts.CurrentValue or mn

            local c = Create("Frame", {
                Parent = Content,
                Size = UDim2.new(1, 0, 0, 60),
                BackgroundColor3 = Colors.Element,
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
            })
            Create("UICorner", { Parent = c, CornerRadius = UDim.new(0, 8) })

            Create("TextLabel", {
                Parent = c,
                Size = UDim2.new(1, -80, 0, 20),
                Position = UDim2.new(0, 14, 0, 8),
                BackgroundTransparency = 1,
                Text = opts.Name or "Slider",
                TextColor3 = Colors.Text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local vl = Create("TextLabel", {
                Parent = c,
                Size = UDim2.new(0, 60, 0, 20),
                Position = UDim2.new(1, -70, 0, 8),
                BackgroundTransparency = 1,
                Text = tostring(value),
                TextColor3 = Colors.Accent,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
            })

            local track = Create("Frame", {
                Parent = c,
                Size = UDim2.new(1, -28, 0, 8),
                Position = UDim2.new(0, 14, 1, -22),
                BackgroundColor3 = Colors.Slider,
                BorderSizePixel = 0,
            })
            Create("UICorner", { Parent = track, CornerRadius = UDim.new(1, 0) })

            local fill = Create("Frame", {
                Parent = track,
                Size = UDim2.new((value - mn) / (mx - mn), 0, 1, 0),
                BackgroundColor3 = Colors.SliderFill,
                BorderSizePixel = 0,
            })
            Create("UICorner", { Parent = fill, CornerRadius = UDim.new(1, 0) })

            local knob = Create("Frame", {
                Parent = track,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new((value - mn) / (mx - mn), -8, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                ZIndex = 5,
            })
            Create("UICorner", { Parent = knob, CornerRadius = UDim.new(1, 0) })

            local drag = false

            local function update(input)
                local relX = input.Position.X - track.AbsolutePosition.X
                local pos = math.clamp(relX / track.AbsoluteSize.X, 0, 1)
                local v = mn + (mx - mn) * pos
                v = math.floor(v / step + 0.5) * step
                v = math.clamp(v, mn, mx)

                knob.Position = UDim2.new(pos, -8, 0.5, -8)
                fill.Size = UDim2.new(pos, 0, 1, 0)
                vl.Text = tostring(v)
                value = v
                if opts.Callback then Safe(opts.Callback, v) end
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    drag = true
                    update(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    drag = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if drag and (input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input)
                end
            end)

            return {
                Container = c,
                SetValue = function(v)
                    v = math.clamp(v, mn, mx)
                    local pos = (v - mn) / (mx - mn)
                    knob.Position = UDim2.new(pos, -8, 0.5, -8)
                    fill.Size = UDim2.new(pos, 0, 1, 0)
                    vl.Text = tostring(v)
                    value = v
                    if opts.Callback then Safe(opts.Callback, v) end
                end,
                GetValue = function() return value end,
            }
        end

        function Tab:CreateDropdown(opts)
            opts = opts or {}
            local options = opts.Options or {}
            local multiple = opts.MultipleOptions or false
            local selected = {}
            local current = opts.CurrentOption or (multiple and {} or (options[1] or "None"))

            if type(current) == "string" then
                selected[current] = true
            elseif type(current) == "table" then
                for _, v in ipairs(current) do selected[v] = true end
            end

            local c = Create("Frame", {
                Parent = Content,
                Size = UDim2.new(1, 0, 0, 64),
                BackgroundColor3 = Colors.Element,
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
                ClipsDescendants = false,
            })
            Create("UICorner", { Parent = c, CornerRadius = UDim.new(0, 8) })

            Create("TextLabel", {
                Parent = c,
                Size = UDim2.new(1, -30, 0, 18),
                Position = UDim2.new(0, 14, 0, 6),
                BackgroundTransparency = 1,
                Text = opts.Name or "Dropdown",
                TextColor3 = Colors.Text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local selectBtn = Create("TextButton", {
                Parent = c,
                Size = UDim2.new(1, -28, 0, 32),
                Position = UDim2.new(0, 14, 0, 26),
                BackgroundColor3 = Colors.Input,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
            })
            Create("UICorner", { Parent = selectBtn, CornerRadius = UDim.new(0, 6) })

            local displayText
            local function updateDisplay()
                if multiple then
                    local list = {}
                    for k in pairs(selected) do table.insert(list, k) end
                    if #list == 0 then
                        displayText = "None"
                    elseif #list <= 2 then
                        displayText = table.concat(list, ", ")
                    else
                        displayText = list[1] .. " +" .. (#list - 1)
                    end
                else
                    displayText = current
                end
            end
            updateDisplay()

            local textLabel = Create("TextLabel", {
                Parent = selectBtn,
                Size = UDim2.new(1, -40, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = tostring(displayText),
                TextColor3 = Colors.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local arrow = Create("TextLabel", {
                Parent = selectBtn,
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -24, 0, 0),
                BackgroundTransparency = 1,
                Text = "v",
                TextColor3 = Colors.TextMuted,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
            })

            local listFrame = Create("ScrollingFrame", {
                Parent = Window,
                Size = UDim2.new(0, 200, 0, 0),
                BackgroundColor3 = Colors.Dropdown,
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 30000,
                ScrollBarThickness = 3,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ClipsDescendants = false,
            })
            Create("UICorner", { Parent = listFrame, CornerRadius = UDim.new(0, 6) })
            Create("UIStroke", { Parent = listFrame, Color = Colors.Border, Thickness = 1, Transparency = 0.4 })
            Create("UIListLayout", { Parent = listFrame, Padding = UDim.new(0, 2) })
            Create("UIPadding", {
                Parent = listFrame,
                PaddingTop = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 4),
                PaddingRight = UDim.new(0, 4),
            })

            local isOpen = false

            local function toggleList()
                isOpen = not isOpen
                if isOpen then
                    listFrame.Size = UDim2.new(0, selectBtn.AbsoluteSize.X, 0, math.min(#options * 32 + 8, 220))
                    listFrame.Position = UDim2.new(
                        0,
                        selectBtn.AbsolutePosition.X - Window.AbsolutePosition.X,
                        0,
                        (selectBtn.AbsolutePosition.Y - Window.AbsolutePosition.Y) + selectBtn.AbsoluteSize.Y + 2
                    )
                    listFrame.Visible = true
                else
                    listFrame.Visible = false
                end
            end

            selectBtn.MouseButton1Click:Connect(toggleList)

            local optionButtons = {}
            for _, opt in ipairs(options) do
                local ob = Create("TextButton", {
                    Parent = listFrame,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Colors.DropdownHover,
                    BorderSizePixel = 0,
                    Text = opt,
                    TextColor3 = Colors.Text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    AutoButtonColor = false,
                    ZIndex = 30001,
                })
                Create("UICorner", { Parent = ob, CornerRadius = UDim.new(0, 5) })

                ob.MouseEnter:Connect(function()
                    Tween(ob, { BackgroundColor3 = Colors.ElementHover }, 0.1)
                end)
                ob.MouseLeave:Connect(function()
                    Tween(ob, { BackgroundColor3 = Colors.DropdownHover }, 0.1)
                end)

                ob.MouseButton1Click:Connect(function()
                    if multiple then
                        selected[opt] = not selected[opt] or nil
                        updateDisplay()
                        textLabel.Text = tostring(displayText)
                        local list = {}
                        for k in pairs(selected) do table.insert(list, k) end
                        if opts.Callback then Safe(opts.Callback, list) end
                    else
                        current = opt
                        selected = { [opt] = true }
                        updateDisplay()
                        textLabel.Text = tostring(displayText)
                        toggleList()
                        if opts.Callback then Safe(opts.Callback, opt) end
                    end
                end)

                table.insert(optionButtons, ob)
            end

            return {
                Container = c,
                SetValue = function(v)
                    current = v
                    updateDisplay()
                    textLabel.Text = tostring(displayText)
                end,
                GetValue = function()
                    return multiple and selected or current
                end,
            }
        end

        function Tab:CreateInput(opts)
            opts = opts or {}
            local c = Create("Frame", {
                Parent = Content,
                Size = UDim2.new(1, 0, 0, 64),
                BackgroundColor3 = Colors.Element,
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
            })
            Create("UICorner", { Parent = c, CornerRadius = UDim.new(0, 8) })

            Create("TextLabel", {
                Parent = c,
                Size = UDim2.new(1, -30, 0, 18),
                Position = UDim2.new(0, 14, 0, 6),
                BackgroundTransparency = 1,
                Text = opts.Name or "Input",
                TextColor3 = Colors.Text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local inputBox = Create("TextBox", {
                Parent = c,
                Size = UDim2.new(1, -28, 0, 32),
                Position = UDim2.new(0, 14, 0, 26),
                BackgroundColor3 = Colors.Input,
                BorderSizePixel = 0,
                Text = opts.Default or "",
                TextColor3 = Colors.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                PlaceholderText = opts.Placeholder or "Enter...",
                PlaceholderColor3 = Colors.TextDark,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = opts.ClearOnFocus or false,
            })
            Create("UICorner", { Parent = inputBox, CornerRadius = UDim.new(0, 6) })
            Create("UIPadding", { Parent = inputBox, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })
            local stroke = Create("UIStroke", { Parent = inputBox, Color = Colors.Separator, Thickness = 1 })

            inputBox.Focused:Connect(function()
                Tween(stroke, { Color = Colors.Accent }, 0.15)
            end)
            inputBox.FocusLost:Connect(function(enterPressed)
                Tween(stroke, { Color = Colors.Separator }, 0.15)
                if enterPressed and opts.Callback then
                    Safe(opts.Callback, inputBox.Text)
                end
            end)

            return {
                Container = c,
                SetText = function(t) inputBox.Text = t end,
                GetText = function() return inputBox.Text end,
                Focus = function() inputBox:CaptureFocus() end,
            }
        end

        function Tab:CreateKeybind(opts)
            opts = opts or {}
            local currentKey = opts.Default or "None"

            local c = Create("Frame", {
                Parent = Content,
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = Colors.Element,
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
            })
            Create("UICorner", { Parent = c, CornerRadius = UDim.new(0, 8) })

            Create("TextLabel", {
                Parent = c,
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text = opts.Name or "Keybind",
                TextColor3 = Colors.Text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local keyBtn = Create("TextButton", {
                Parent = c,
                Size = UDim2.new(0, 60, 0, 28),
                Position = UDim2.new(1, -72, 0.5, -14),
                BackgroundColor3 = Colors.Input,
                BorderSizePixel = 0,
                Text = currentKey,
                TextColor3 = Colors.Text,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                AutoButtonColor = false,
            })
            Create("UICorner", { Parent = keyBtn, CornerRadius = UDim.new(0, 6) })

            local recording = false
            local inputConn

            keyBtn.MouseButton1Click:Connect(function()
                if recording then return end
                recording = true
                keyBtn.Text = "..."
                keyBtn.BackgroundColor3 = Colors.Accent

                inputConn = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode.Name
                        keyBtn.Text = currentKey
                        keyBtn.BackgroundColor3 = Colors.Input
                        recording = false
                        if inputConn then inputConn:Disconnect() end
                        if opts.Callback then Safe(opts.Callback, input.KeyCode) end
                    end
                end)
            end)

            return {
                Container = c,
                GetValue = function() return currentKey end,
                SetValue = function(v)
                    currentKey = v
                    keyBtn.Text = v
                end,
            }
        end

        function Tab:CreateColorPicker(opts)
            opts = opts or {}
            local currentColor = opts.Default or Color3.fromRGB(255, 255, 255)

            local c = Create("Frame", {
                Parent = Content,
                Size = UDim2.new(1, 0, 0, 180),
                BackgroundColor3 = Colors.Element,
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
            })
            Create("UICorner", { Parent = c, CornerRadius = UDim.new(0, 8) })

            Create("TextLabel", {
                Parent = c,
                Size = UDim2.new(1, -60, 0, 20),
                Position = UDim2.new(0, 14, 0, 8),
                BackgroundTransparency = 1,
                Text = opts.Name or "Color Picker",
                TextColor3 = Colors.Text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local preview = Create("Frame", {
                Parent = c,
                Size = UDim2.new(0, 40, 0, 24),
                Position = UDim2.new(1, -54, 0, 8),
                BackgroundColor3 = currentColor,
                BorderSizePixel = 0,
            })
            Create("UICorner", { Parent = preview, CornerRadius = UDim.new(0, 6) })

            local channels = { "R", "G", "B" }
            local startY = 38

            for i = 1, 3 do
                Create("TextLabel", {
                    Parent = c,
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(0, 14, 0, startY + (i - 1) * 40),
                    BackgroundTransparency = 1,
                    Text = channels[i],
                    TextColor3 = Colors.TextMuted,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })

                local track = Create("Frame", {
                    Parent = c,
                    Size = UDim2.new(1, -80, 0, 8),
                    Position = UDim2.new(0, 40, 0, startY + (i - 1) * 40 + 6),
                    BackgroundColor3 = Colors.Slider,
                    BorderSizePixel = 0,
                })
                Create("UICorner", { Parent = track, CornerRadius = UDim.new(1, 0) })

                local fill = Create("Frame", {
                    Parent = track,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Colors.SliderFill,
                    BorderSizePixel = 0,
                })
                Create("UICorner", { Parent = fill, CornerRadius = UDim.new(1, 0) })

                local knob = Create("Frame", {
                    Parent = track,
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(1, -7, 0.5, -7),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    ZIndex = 5,
                })
                Create("UICorner", { Parent = knob, CornerRadius = UDim.new(1, 0) })

                local dragging = false

                local function update(input)
                    local relX = math.clamp(
                        (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X,
                        0, 1
                    )
                    knob.Position = UDim2.new(relX, -7, 0.5, -7)
                    fill.Size = UDim2.new(relX, 0, 1, 0)

                    local r = currentColor.R * 255
                    local g = currentColor.G * 255
                    local b = currentColor.B * 255
                    if i == 1 then r = relX * 255
                    elseif i == 2 then g = relX * 255
                    else b = relX * 255 end

                    currentColor = Color3.fromRGB(r, g, b)
                    preview.BackgroundColor3 = currentColor
                    if opts.Callback then Safe(opts.Callback, currentColor) end
                end

                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        update(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch) then
                        update(input)
                    end
                end)
            end

            return {
                Container = c,
                GetValue = function() return currentColor end,
                SetValue = function(color)
                    currentColor = color
                    preview.BackgroundColor3 = color
                end,
            }
        end

        function Tab:CreateStatRow(opts)
            opts = opts or {}
            local c = Create("Frame", {
                Parent = Content,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Colors.Element,
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
            })
            Create("UICorner", { Parent = c, CornerRadius = UDim.new(0, 8) })

            Create("Frame", {
                Parent = c,
                Size = UDim2.new(0, 3, 1, -14),
                Position = UDim2.new(0, 0, 0, 7),
                BackgroundColor3 = opts.Color or Colors.Accent,
                BorderSizePixel = 0,
            })

            Create("TextLabel", {
                Parent = c,
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text = opts.Label or "Stat",
                TextColor3 = Colors.TextMuted,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local valueLabel = Create("TextLabel", {
                Parent = c,
                Size = UDim2.new(0.4, -14, 1, 0),
                Position = UDim2.new(0.6, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = tostring(opts.Value or "0"),
                TextColor3 = Colors.Text,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
            })

            if opts.Update then
                task.spawn(function()
                    while c.Parent do
                        local ok, v = pcall(opts.Update)
                        if ok then valueLabel.Text = tostring(v) end
                        task.wait(opts.Interval or 0.5)
                    end
                end)
            end

            return {
                Container = c,
                SetValue = function(v) valueLabel.Text = tostring(v) end,
            }
        end

        function Tab:CreateProgressBar(opts)
            opts = opts or {}
            local c = Create("Frame", {
                Parent = Content,
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = Colors.Element,
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
            })
            Create("UICorner", { Parent = c, CornerRadius = UDim.new(0, 8) })

            Create("TextLabel", {
                Parent = c,
                Size = UDim2.new(1, -100, 0, 16),
                Position = UDim2.new(0, 14, 0, 8),
                BackgroundTransparency = 1,
                Text = opts.Name or "Progress",
                TextColor3 = Colors.Text,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local valueLabel = Create("TextLabel", {
                Parent = c,
                Size = UDim2.new(0, 60, 0, 16),
                Position = UDim2.new(1, -74, 0, 8),
                BackgroundTransparency = 1,
                Text = "0%",
                TextColor3 = Colors.Accent,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
            })

            local track = Create("Frame", {
                Parent = c,
                Size = UDim2.new(1, -28, 0, 8),
                Position = UDim2.new(0, 14, 1, -18),
                BackgroundColor3 = Colors.Slider,
                BorderSizePixel = 0,
            })
            Create("UICorner", { Parent = track, CornerRadius = UDim.new(1, 0) })

            local fill = Create("Frame", {
                Parent = track,
                Size = UDim2.new(opts.Value or 0, 0, 1, 0),
                BackgroundColor3 = opts.Color or Colors.Accent,
                BorderSizePixel = 0,
            })
            Create("UICorner", { Parent = fill, CornerRadius = UDim.new(1, 0) })

            return {
                Container = c,
                SetValue = function(v)
                    v = math.clamp(v, 0, 1)
                    Tween(fill, { Size = UDim2.new(v, 0, 1, 0) }, 0.3)
                    valueLabel.Text = math.floor(v * 100) .. "%"
                end,
            }
        end

        function Tab:CreateCodeBlock(opts)
            opts = opts or {}
            local c = Create("Frame", {
                Parent = Content,
                Size = UDim2.new(1, 0, 0, 60),
                BackgroundColor3 = Color3.fromRGB(15, 15, 22),
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
            })
            Create("UICorner", { Parent = c, CornerRadius = UDim.new(0, 8) })

            local codeText = Create("TextLabel", {
                Parent = c,
                Size = UDim2.new(1, -20, 1, -20),
                Position = UDim2.new(0, 10, 0, 10),
                BackgroundTransparency = 1,
                Text = opts.Code or "print('Hello')",
                TextColor3 = Color3.fromRGB(150, 255, 180),
                TextSize = 11,
                Font = Enum.Font.Code,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true,
            })

            task.wait(0)
            local bounds = codeText.TextBounds
            c.Size = UDim2.new(1, 0, 0, bounds.Y + 24)
            codeText.Size = UDim2.new(1, -20, 0, bounds.Y)

            return c
        end

        function Tab:CreateImage(opts)
            opts = opts or {}
            local c = Create("Frame", {
                Parent = Content,
                Size = UDim2.new(1, 0, 0, opts.Height or 100),
                BackgroundColor3 = Colors.Element,
                BorderSizePixel = 0,
                LayoutOrder = NextOrder(),
                ClipsDescendants = true,
            })
            Create("UICorner", { Parent = c, CornerRadius = UDim.new(0, 8) })

            local img = LoadIcon(opts.Image, UDim2.new(1, -20, 1, -20), Color3.fromRGB(255, 255, 255), c)
            if img then
                img.Position = UDim2.new(0, 10, 0, 10)
            end

            return c
        end

        return Tab
    end

    -- ==========================================
    -- SEARCH
    -- ==========================================
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        searchQuery = SearchBox.Text
        for _, tab in ipairs(Tabs) do
            local matches = true
            if searchQuery ~= "" then
                matches = tab.name:lower():find(searchQuery:lower(), 1, true) ~= nil
            end
            tab.button.Visible = matches
        end
    end)

    -- ==========================================
    -- CONFIG SYSTEM
    -- ==========================================
    local ConfigData = {}

    local function SaveConfig(name)
        if not ConfigurationSaving.Enabled then return false end
        local fileName = (ConfigurationSaving.FileName or "sv_config") .. "_" .. (name or "default") .. ".json"
        local ok, encoded = pcall(function() return HttpService:JSONEncode(ConfigData) end)
        if ok and writefile then
            pcall(writefile, fileName, encoded)
            Notify:Push({
                Title = "Config Saved",
                Content = fileName,
                Type = "Success",
                Duration = 3,
            })
            return true
        end
        return false
    end

    local function LoadConfig(name)
        if not ConfigurationSaving.Enabled then return false end
        local fileName = (ConfigurationSaving.FileName or "sv_config") .. "_" .. (name or "default") .. ".json"
        if readfile and isfile and isfile(fileName) then
            local ok, data = pcall(function() return HttpService:JSONDecode(readfile(fileName)) end)
            if ok and data then
                ConfigData = data
                Notify:Push({
                    Title = "Config Loaded",
                    Content = fileName,
                    Type = "Success",
                    Duration = 3,
                })
                return true
            end
        end
        return false
    end

    -- ==========================================
    -- LOADING ANIMATION
    -- ==========================================
    task.spawn(function()
        local steps = { 0.15, 0.35, 0.55, 0.75, 0.95, 1.0 }
        for _, pct in ipairs(steps) do
            Tween(LoadBarFill, { Size = UDim2.new(pct, 0, 1, 0) }, 0.25)
            LoadPct.Text = math.floor(pct * 100) .. "%"
            task.wait(0.22)
        end
        task.wait(0.35)

        Tween(LoadingFrame, {
            Size = UDim2.new(0, 420, 0, 0),
            BackgroundTransparency = 1,
        }, 0.4, Enum.EasingStyle.Quint)
        Tween(GlowRing, { BackgroundTransparency = 1 }, 0.35)

        for _, child in ipairs(LoadingFrame:GetDescendants()) do
            if child:IsA("GuiObject") then
                pcall(function()
                    Tween(child, { BackgroundTransparency = 1, TextTransparency = 1, ImageTransparency = 1 }, 0.35)
                end)
            end
        end

        task.wait(0.5)
        pcall(function() LoadingFrame:Destroy() end)

        Window.Visible = true
        Window.Size = UDim2.new(0, 0, 0, 0)
        Tween(Window, {
            Size = UDim2.new(0, Width, 0, Height),
        }, 0.45, Enum.EasingStyle.Back)
    end)

    -- ==========================================
    -- WINDOW API
    -- ==========================================
    local WindowAPI = {}

    function WindowAPI:CreateTab(name, iconId, options)
        return CreateTab(name, iconId, options)
    end

    function WindowAPI:Notify(opts)
        return Notify:Push(opts)
    end

    function WindowAPI:Dialog(opts)
        return Dialog:Show(opts)
    end

    function WindowAPI:Confirm(title, content, onConfirm)
        return Dialog:Show({
            Title = title or "Confirm",
            Content = content or "Are you sure?",
            Buttons = {
                { Text = "Cancel", Variant = "Ghost" },
                { Text = "Confirm", Variant = "Primary", Callback = onConfirm },
            },
        })
    end

    function WindowAPI:Prompt(title, placeholder, onConfirm)
        return Dialog:Show({
            Title = title or "Input",
            Content = "Enter a value:",
            InputPlaceholder = placeholder or "...",
            Buttons = {
                { Text = "Cancel", Variant = "Ghost" },
                { Text = "OK", Variant = "Primary", Callback = onConfirm },
            },
        })
    end

    function WindowAPI:SaveConfig(name) return SaveConfig(name) end
    function WindowAPI:LoadConfig(name) return LoadConfig(name) end

    function WindowAPI:SetTheme(themeName)
        local newColors = Themes[themeName]
        if not newColors then return end
        for k, v in pairs(newColors) do
            Colors[k] = v
        end
        Notify:Push({
            Title = "Theme Changed",
            Content = themeName,
            Type = "Success",
            Duration = 2,
        })
    end

    function WindowAPI:GetThemes()
        local list = {}
        for k in pairs(Themes) do table.insert(list, k) end
        table.sort(list)
        return list
    end

    function WindowAPI:Destroy()
        pcall(function() ScreenGui:Destroy() end)
    end

    function WindowAPI:Minimize() Minimize() end
    function WindowAPI:Restore() Restore() end
    function WindowAPI:Close() CloseWindow() end

    function WindowAPI:GetWindow() return Window end
    function WindowAPI:GetSidebar() return Sidebar end
    function WindowAPI:GetContentArea() return ContentArea end
    function WindowAPI:GetConfig() return ConfigData end
    function WindowAPI:SetConfig(key, value) ConfigData[key] = value end
    function WindowAPI:GetConfigValue(key) return ConfigData[key] end
    function WindowAPI:IsMinimized() return isMinimized end
    function WindowAPI:GetScreenGui() return ScreenGui end

    -- Welcome notification
    task.delay(1.6, function()
        Notify:Push({
            Title = "ScriptVault Loaded",
            Content = "UI Library v" .. SV._VERSION .. " - Right Shift to toggle",
            Type = "Success",
            Duration = 5,
            Icon = SV.Icons.Logo,
        })
    end)

    return WindowAPI
end

-- =====================================================
-- LIBRARY INFO API
-- =====================================================
function SV:GetVersion() return SV._VERSION end
function SV:GetBuild() return SV._BUILD end

function SV:GetThemes()
    local list = {}
    for k in pairs(Themes) do table.insert(list, k) end
    table.sort(list)
    return list
end

function SV:GetIcons()
    local list = {}
    for k, v in pairs(SV.Icons) do
        table.insert(list, { Name = k, Id = v })
    end
    return list
end

function SV:SetIcon(key, id)
    SV.Icons[key] = id
end

function SV:RegisterTheme(name, colors)
    Themes[name] = colors
end

function SV:FormatNumber(n) return FormatNumber(n) end
function SV:FormatTime(s) return FormatTime(s) end
function SV:GetPing() return GetPing() end
function SV:GetMemory() return GetMemory() end
function SV:IsTouchDevice() return IsTouchDevice() end

-- =====================================================
-- RETURN LIBRARY
-- =====================================================
return SV
