--[[
    SCRIPTVAULT +1 WINGS FOR EGGS | V1.1
    Single file, keyless, loadstring-ready.

    Loadstring:
        loadstring(game:HttpGet("https://raw.githubusercontent.com/USER/scriptvault/main/autofarm.lua"))()
]]

--=====================================================================
-- SERVICES
--=====================================================================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local VirtualUser      = game:GetService("VirtualUser")
local Lighting         = game:GetService("Lighting")
local LocalPlayer      = Players.LocalPlayer

--=====================================================================
-- CONFIG
--=====================================================================
local CFG = {
    Title    = "SCRIPTVAULT +1 WINGS FOR EGGS",
    Subtitle = "Autofarm Suite",
    Version  = "V1.1",
    Build    = "2026.1",
    Logo     = "rbxassetid://93348253170824",
    Decal    = "rbxassetid://111637853140695",
    IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled,
}

local FarmCfg = {
    SelectedIsland   = "Beach",
    Speed            = 200,
    ApproachSpeed    = 60,
    SafeHeight       = 120,
    EggName          = "egg",
    LoopDelay        = 0.15,
    SellInterval     = 2,
    ZoneMargin       = 50,
    EscapeHeight     = 12,
    PickupTimeout    = 5,
    PostDepositWait  = 1.5,
    StandPos         = Vector3.new(247.05, 4, 446.7),
    UpgradeWhich     = "Speed",
}

local State = {
    AutoFarm       = false,
    AutoSell       = false,
    AutoUpgrade    = false,
    AutoRebirth    = false,
    AutoIndex      = false,
    FarmRunning    = false,
    Holding        = false,
    PetsCollected  = 0,
    UpgradeTargets = { Speed = false, Stamina = false, Carry = false },
}

local Remotes = {
    SellAll = nil,
    Holding = nil,
    Place   = nil,
    Rebirth = nil,
    ClaimIndex = nil,
}

local Threads = {
    Farm = nil,
    Sell = nil,
    Upgrade = nil,
    Rebirth = nil,
    Index = nil,
}

--=====================================================================
-- THEME
--=====================================================================
local T = {
    BgTop      = Color3.fromRGB(10, 16, 32),
    BgBottom   = Color3.fromRGB(4, 6, 14),
    Surface    = Color3.fromRGB(14, 22, 42),
    SurfLight  = Color3.fromRGB(20, 32, 58),
    SurfHover  = Color3.fromRGB(26, 40, 72),
    SurfActive = Color3.fromRGB(36, 54, 92),
    Primary    = Color3.fromRGB(56, 132, 255),
    PrimaryLt  = Color3.fromRGB(112, 180, 255),
    Cyan       = Color3.fromRGB(0, 200, 255),
    Success    = Color3.fromRGB(72, 219, 130),
    Danger     = Color3.fromRGB(255, 84, 108),
    Warning    = Color3.fromRGB(255, 184, 76),
    Text       = Color3.fromRGB(235, 242, 255),
    TextSub    = Color3.fromRGB(155, 175, 210),
    TextMute   = Color3.fromRGB(90, 105, 140),
    Stroke     = Color3.fromRGB(38, 56, 96),
    StrokeLt   = Color3.fromRGB(70, 100, 155),
    Glow       = Color3.fromRGB(90, 160, 255),
}

--=====================================================================
-- HELPERS
--=====================================================================
local function new(class, props, children)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    for _, c in ipairs(children or {}) do c.Parent = o end
    return o
end

local function corner(parent, radius)
    return new("UICorner", { CornerRadius = UDim.new(0, radius or 8), Parent = parent })
end

local function stroke(parent, color, thickness, transparency)
    return new("UIStroke", {
        Color = color or T.Stroke,
        Thickness = thickness or 1,
        Transparency = transparency or 0.3,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent,
    })
end

local function grad(parent, c1, c2, rotation)
    return new("UIGradient", {
        Color = ColorSequence.new(c1, c2),
        Rotation = rotation or 0,
        Parent = parent,
    })
end

local function pad(parent, top, right, bottom, left)
    return new("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        PaddingLeft = UDim.new(0, left or 0),
        Parent = parent,
    })
end

local function tween(obj, duration, props, style, direction)
    local t = TweenService:Create(obj, TweenInfo.new(
        duration or 0.25,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    ), props)
    t:Play()
    return t
end

local function getViewport()
    local cam = workspace.CurrentCamera
    return cam and cam.ViewportSize or Vector2.new(1280, 720)
end

local function responsiveSize()
    local vp = getViewport()
    if CFG.IsMobile then
        return Vector2.new(math.min(vp.X - 20, 620), math.min(vp.Y - 100, 540))
    end
    return Vector2.new(math.min(vp.X - 60, 760), math.min(vp.Y - 60, 520))
end

local function getHRP()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart") or nil
end

--=====================================================================
-- ROOT GUI
--=====================================================================
local parentGui = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = new("ScreenGui", {
    Name = "ScriptVault_WingsForEggs",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 9999,
    Parent = parentGui,
})

--=====================================================================
-- NOTIFICATION SYSTEM
--=====================================================================
local NotifHolder

local function notify(title, message, kind, duration)
    if not NotifHolder then return end
    kind = kind or "info"
    duration = duration or 4
    local color = T.Primary
    if kind == "success" then color = T.Success end
    if kind == "error"   then color = T.Danger end
    if kind == "warning" then color = T.Warning end

    local card = new("Frame", {
        Size = UDim2.new(0, 300, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = T.Surface,
        BorderSizePixel = 0,
        BackgroundTransparency = 0.05,
        Parent = NotifHolder,
    })
    corner(card, 10)
    stroke(card, color, 1, 0.3)
    grad(card, T.SurfLight, T.Surface, 90)

    local accent = new("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Parent = card,
    })
    corner(accent, 2)

    new("TextLabel", {
        Size = UDim2.new(1, -22, 0, 20),
        Position = UDim2.new(0, 14, 0, 8),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = card,
    })

    new("TextLabel", {
        Size = UDim2.new(1, -22, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Position = UDim2.new(0, 14, 0, 30),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = T.TextSub,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = card,
    })
    pad(card, 0, 0, 10, 0)

    card.Position = UDim2.new(1, 40, 0, 0)
    card.BackgroundTransparency = 1
    tween(card, 0.35, {
        Position = UDim2.new(1, -320, 0, 0),
        BackgroundTransparency = 0.05,
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    task.delay(duration, function()
        if card and card.Parent then
            tween(card, 0.3, {
                Position = UDim2.new(1, 40, 0, 0),
                BackgroundTransparency = 1,
            })
            task.wait(0.3)
            if card then card:Destroy() end
        end
    end)
end

--=====================================================================
-- MAIN WINDOW
--=====================================================================
local Window = new("Frame", {
    Name = "Window",
    Size = UDim2.new(0, 0, 0, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundColor3 = T.BgBottom,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = ScreenGui,
})
corner(Window, 14)
stroke(Window, T.StrokeLt, 1, 0.4)
grad(Window, T.BgTop, T.BgBottom, 135)

new("ImageLabel", {
    Name = "Watermark",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Image = CFG.Decal,
    ImageColor3 = T.Primary,
    ImageTransparency = 0.94,
    ScaleType = Enum.ScaleType.Fit,
    ZIndex = 1,
    Parent = Window,
})

local glowFrame = new("Frame", {
    Size = UDim2.new(1, 4, 1, 4),
    Position = UDim2.new(0, -2, 0, -2),
    BackgroundTransparency = 1,
    ZIndex = 0,
    Parent = Window,
})
corner(glowFrame, 16)
stroke(glowFrame, T.Glow, 1, 0.85)

--=====================================================================
-- HEADER
--=====================================================================
local HeaderH = CFG.IsMobile and 66 or 58

local Header = new("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, HeaderH),
    BackgroundColor3 = T.Surface,
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    ZIndex = 5,
    Parent = Window,
})
grad(Header, Color3.fromRGB(20, 34, 62), Color3.fromRGB(10, 16, 32), 90)

new("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 1, -1),
    BackgroundColor3 = T.Primary,
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0,
    ZIndex = 6,
    Parent = Header,
})

local LogoSize = CFG.IsMobile and 46 or 40
local LogoBox = new("Frame", {
    Size = UDim2.new(0, LogoSize, 0, LogoSize),
    Position = UDim2.new(0, 14, 0, (HeaderH - LogoSize) / 2),
    BackgroundColor3 = T.Primary,
    BorderSizePixel = 0,
    ZIndex = 7,
    Parent = Header,
})
corner(LogoBox, 12)
grad(LogoBox, T.Primary, T.Cyan, 135)
stroke(LogoBox, T.PrimaryLt, 1, 0.4)

new("ImageLabel", {
    Size = UDim2.new(1, -10, 1, -10),
    Position = UDim2.new(0, 5, 0, 5),
    BackgroundTransparency = 1,
    Image = CFG.Logo,
    ScaleType = Enum.ScaleType.Fit,
    ZIndex = 8,
    Parent = LogoBox,
})

new("TextLabel", {
    Size = UDim2.new(0, 420, 0, 20),
    Position = UDim2.new(0, LogoSize + 24, 0, CFG.IsMobile and 15 or 11),
    BackgroundTransparency = 1,
    Text = CFG.Title,
    TextColor3 = T.Text,
    Font = Enum.Font.GothamBlack,
    TextSize = CFG.IsMobile and 14 or 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 7,
    Parent = Header,
})

new("TextLabel", {
    Size = UDim2.new(0, 420, 0, 14),
    Position = UDim2.new(0, LogoSize + 24, 0, CFG.IsMobile and 37 or 31),
    BackgroundTransparency = 1,
    Text = CFG.Subtitle .. "   |   " .. CFG.Version,
    TextColor3 = T.TextSub,
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 7,
    Parent = Header,
})

local hbSize = CFG.IsMobile and 40 or 32
local hbY = (HeaderH - hbSize) / 2

local function headerBtn(text, xOff, color, cb)
    local b = new("TextButton", {
        Size = UDim2.new(0, hbSize, 0, hbSize),
        Position = UDim2.new(1, xOff, 0, hbY),
        BackgroundColor3 = T.SurfHover,
        BackgroundTransparency = 0.3,
        Text = text,
        TextColor3 = T.TextSub,
        Font = Enum.Font.GothamBold,
        TextSize = CFG.IsMobile and 20 or 16,
        AutoButtonColor = false,
        ZIndex = 7,
        Parent = Header,
    })
    corner(b, 8)
    stroke(b, T.Stroke, 1, 0.4)
    b.MouseEnter:Connect(function()
        tween(b, 0.15, { BackgroundColor3 = color, BackgroundTransparency = 0 })
        b.TextColor3 = T.Text
    end)
    b.MouseLeave:Connect(function()
        tween(b, 0.15, { BackgroundColor3 = T.SurfHover, BackgroundTransparency = 0.3 })
        b.TextColor3 = T.TextSub
    end)
    b.MouseButton1Click:Connect(cb)
    return b
end

local CloseBtn = headerBtn("X", -hbSize - 14, T.Danger, function()
    tween(Window, 0.25, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.wait(0.26)
    Window.Visible = false
end)

local MinBtn = headerBtn("-", -hbSize * 2 - 22, T.Warning, function() end)

--=====================================================================
-- SIDEBAR
--=====================================================================
local SidebarW = CFG.IsMobile and 140 or 165

local Sidebar = new("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, SidebarW, 1, -HeaderH),
    Position = UDim2.new(0, 0, 0, HeaderH),
    BackgroundColor3 = T.Surface,
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    ZIndex = 4,
    Parent = Window,
})
new("UIListLayout", {
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = Sidebar,
})
pad(Sidebar, 14, 10, 0, 10)

--=====================================================================
-- PAGES HOLDER
--=====================================================================
local PagesHolder = new("Frame", {
    Name = "Pages",
    Size = UDim2.new(1, -SidebarW, 1, -HeaderH),
    Position = UDim2.new(0, SidebarW, 0, HeaderH),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    ZIndex = 3,
    Parent = Window,
})

--=====================================================================
-- COMPONENT LIBRARY
--=====================================================================
local C = {}

function C.Section(parent, text)
    local f = new("Frame", {
        Size = UDim2.new(1, -24, 0, 28),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    new("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        BackgroundTransparency = 1,
        Text = string.upper(text),
        TextColor3 = T.PrimaryLt,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = f,
    })
    local line = new("Frame", {
        Size = UDim2.new(1, -240, 0, 1),
        Position = UDim2.new(0, 200, 0.5, 0),
        BackgroundColor3 = T.StrokeLt,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Parent = f,
    })
    grad(line, T.StrokeLt, T.StrokeLt, 0)
    return f
end

function C.Toggle(parent, label, default, callback)
    local state = default or false
    local rowH = CFG.IsMobile and 48 or 38
    local row = new("Frame", {
        Size = UDim2.new(1, -24, 0, rowH),
        BackgroundColor3 = T.Surface,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = parent,
    })
    corner(row, 8)
    stroke(row, T.Stroke, 1, 0.6)
    pad(row, 0, 12, 0, 14)

    local labelLbl = new("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = T.Text,
        Font = Enum.Font.Gotham,
        TextSize = CFG.IsMobile and 13 or 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })

    local trackW = CFG.IsMobile and 52 or 42
    local trackH = CFG.IsMobile and 28 or 22
    local knobSize = CFG.IsMobile and 22 or 18

    local track = new("Frame", {
        Size = UDim2.new(0, trackW, 0, trackH),
        Position = UDim2.new(1, -trackW - 4, 0.5, -trackH / 2),
        BackgroundColor3 = state and T.Primary or T.SurfActive,
        BorderSizePixel = 0,
        Parent = row,
    })
    corner(track, trackH / 2)
    stroke(track, state and T.PrimaryLt or T.Stroke, 1, 0.4)

    local knob = new("Frame", {
        Size = UDim2.new(0, knobSize, 0, knobSize),
        Position = state and UDim2.new(1, -knobSize - 3, 0, 3) or UDim2.new(0, 3, 0, 3),
        BackgroundColor3 = T.Text,
        BorderSizePixel = 0,
        Parent = track,
    })
    corner(knob, knobSize / 2)

    local hit = new("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = row,
    })

    local function setState(v)
        state = v
        tween(track, 0.25, { BackgroundColor3 = state and T.Primary or T.SurfActive })
        tween(knob, 0.25, {
            Position = state and UDim2.new(1, -knobSize - 3, 0, 3) or UDim2.new(0, 3, 0, 3),
        })
        tween(labelLbl, 0.15, { TextColor3 = state and T.PrimaryLt or T.Text })
    end

    hit.MouseButton1Click:Connect(function()
        setState(not state)
        if callback then
            local ok, err = pcall(callback, state)
            if not ok then notify("Error", tostring(err), "error") end
        end
    end)

    return { Set = setState, Get = function() return state end }
end

function C.Slider(parent, label, minV, maxV, default, callback)
    local value = default or minV
    local rowH = CFG.IsMobile and 68 or 58
    local row = new("Frame", {
        Size = UDim2.new(1, -24, 0, rowH),
        BackgroundColor3 = T.Surface,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = parent,
    })
    corner(row, 8)
    stroke(row, T.Stroke, 1, 0.6)
    pad(row, 8, 14, 8, 14)

    new("TextLabel", {
        Size = UDim2.new(1, -60, 0, 16),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = T.Text,
        Font = Enum.Font.Gotham,
        TextSize = CFG.IsMobile and 13 or 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })

    local valLbl = new("TextLabel", {
        Size = UDim2.new(0, 60, 0, 16),
        Position = UDim2.new(1, -60, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(default),
        TextColor3 = T.PrimaryLt,
        Font = Enum.Font.GothamBold,
        TextSize = CFG.IsMobile and 13 or 12,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = row,
    })

    local trackH = CFG.IsMobile and 12 or 8
    local track = new("Frame", {
        Size = UDim2.new(1, 0, 0, trackH),
        Position = UDim2.new(0, 0, 0, CFG.IsMobile and 40 or 34),
        BackgroundColor3 = T.SurfActive,
        BorderSizePixel = 0,
        Parent = row,
    })
    corner(track, trackH / 2)

    local fill = new("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = T.Primary,
        BorderSizePixel = 0,
        Parent = track,
    })
    corner(fill, trackH / 2)
    grad(fill, T.Primary, T.Cyan, 0)

    local knobSize = CFG.IsMobile and 24 or 16
    local knob = new("Frame", {
        Size = UDim2.new(0, knobSize, 0, knobSize),
        Position = UDim2.new(0, 0, 0.5, -knobSize / 2),
        BackgroundColor3 = T.Text,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = track,
    })
    corner(knob, knobSize / 2)
    stroke(knob, T.Primary, 2, 0)

    local hit = new("TextButton", {
        Size = UDim2.new(1, 0, 0, CFG.IsMobile and 32 or 22),
        Position = UDim2.new(0, 0, 0.5, CFG.IsMobile and -16 or -11),
        BackgroundTransparency = 1,
        Text = "",
        Parent = track,
    })

    local function updateFromX(x)
        local relX = math.clamp(x - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
        local alpha = relX / track.AbsoluteSize.X
        value = minV + (maxV - minV) * alpha
        value = math.floor(value + 0.5)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, -knobSize / 2, 0.5, -knobSize / 2)
        valLbl.Text = tostring(value)
        if callback then pcall(callback, value) end
    end

    local dragging = false
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    task.defer(function()
        updateFromX(track.AbsolutePosition.X
            + (default - minV) / (maxV - minV) * track.AbsoluteSize.X)
    end)

    return {
        Set = function(v)
            value = v
            local alpha = (v - minV) / (maxV - minV)
            fill.Size = UDim2.new(alpha, 0, 1, 0)
            knob.Position = UDim2.new(alpha, -knobSize / 2, 0.5, -knobSize / 2)
            valLbl.Text = tostring(v)
        end,
        Get = function() return value end,
    }
end

function C.Button(parent, label, color, callback)
    local btnH = CFG.IsMobile and 46 or 38
    color = color or T.Primary
    local btn = new("TextButton", {
        Size = UDim2.new(1, -24, 0, btnH),
        BackgroundColor3 = color,
        Text = label,
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = CFG.IsMobile and 14 or 13,
        AutoButtonColor = false,
        Parent = parent,
    })
    corner(btn, 8)
    grad(btn, color, color:Lerp(Color3.new(1, 1, 1), 0.15), 0)
    stroke(btn, color:Lerp(Color3.new(1, 1, 1), 0.35), 1, 0.6)

    btn.MouseEnter:Connect(function()
        tween(btn, 0.15, { BackgroundColor3 = color:Lerp(Color3.new(1, 1, 1), 0.15) })
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, 0.15, { BackgroundColor3 = color })
    end)
    btn.MouseButton1Click:Connect(function()
        tween(btn, 0.08, { Size = UDim2.new(1, -28, 0, btnH - 3),
            Position = UDim2.new(0, 2, 0, 1.5) })
        task.wait(0.08)
        tween(btn, 0.1, { Size = UDim2.new(1, -24, 0, btnH),
            Position = UDim2.new(0, 0, 0, 0) })
        if callback then
            local ok, err = pcall(callback)
            if not ok then notify("Error", tostring(err), "error") end
        end
    end)
    return btn
end

function C.Dropdown(parent, label, options, default, callback)
    local current = default or options[1]
    local rowH = CFG.IsMobile and 48 or 40

    local row = new("Frame", {
        Size = UDim2.new(1, -24, 0, rowH),
        BackgroundColor3 = T.Surface,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = parent,
    })
    corner(row, 8)
    stroke(row, T.Stroke, 1, 0.6)
    pad(row, 0, 12, 0, 14)

    new("TextLabel", {
        Size = UDim2.new(0.4, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = T.Text,
        Font = Enum.Font.Gotham,
        TextSize = CFG.IsMobile and 13 or 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })

    local valueBtn = new("TextButton", {
        Size = UDim2.new(0, CFG.IsMobile and 200 or 160, 1, 0),
        Position = UDim2.new(1, CFG.IsMobile and -200 or -160, 0, 0),
        BackgroundTransparency = 1,
        Text = current .. "  v",
        TextColor3 = T.PrimaryLt,
        Font = Enum.Font.GothamMedium,
        TextSize = CFG.IsMobile and 13 or 12,
        TextXAlignment = Enum.TextXAlignment.Right,
        AutoButtonColor = false,
        Parent = row,
    })

    local listFrame = new("ScrollingFrame", {
        Size = UDim2.new(0, CFG.IsMobile and 200 or 160, 0, math.min(#options, 6) * 30 + 8),
        BackgroundColor3 = T.SurfLight,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 300,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = T.Stroke,
        CanvasSize = UDim2.new(0, 0, 0, #options * 32 + 8),
        Parent = ScreenGui,
    })
    corner(listFrame, 6)
    stroke(listFrame, T.Stroke, 1, 0.3)

    local listLayout = new("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = listFrame,
    })
    pad(listFrame, 4, 4, 4, 4)

    local backdrop = new("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Visible = false,
        ZIndex = 299,
        Parent = ScreenGui,
    })

    for i, opt in ipairs(options) do
        local optBtn = new("TextButton", {
            Size = UDim2.new(1, -4, 0, 30),
            BackgroundColor3 = T.SurfHover,
            BackgroundTransparency = 1,
            Text = "  " .. opt,
            TextColor3 = opt == current and T.PrimaryLt or T.Text,
            Font = Enum.Font.GothamMedium,
            TextSize = CFG.IsMobile and 13 or 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = i,
            AutoButtonColor = false,
            ZIndex = 301,
            Parent = listFrame,
        })
        corner(optBtn, 4)
        optBtn.MouseEnter:Connect(function()
            tween(optBtn, 0.1, { BackgroundTransparency = 0 })
        end)
        optBtn.MouseLeave:Connect(function()
            tween(optBtn, 0.1, { BackgroundTransparency = 1 })
        end)
        optBtn.MouseButton1Click:Connect(function()
            current = opt
            valueBtn.Text = current .. "  v"
            listFrame.Visible = false
            backdrop.Visible = false
            for _, child in ipairs(listFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    child.TextColor3 = (child.Text:gsub("^%s+", "")) == current
                        and T.PrimaryLt or T.Text
                end
            end
            if callback then pcall(callback, current) end
        end)
    end

    valueBtn.MouseButton1Click:Connect(function()
        if listFrame.Visible then
            listFrame.Visible = false
            backdrop.Visible = false
            return
        end
        local pos = valueBtn.AbsolutePosition
        local size = valueBtn.AbsoluteSize
        listFrame.Position = UDim2.new(0, pos.X - (listFrame.AbsoluteSize.X - size.X) + 4,
            0, pos.Y + size.Y + 4)
        listFrame.Visible = true
        backdrop.Visible = true
    end)

    backdrop.MouseButton1Click:Connect(function()
        listFrame.Visible = false
        backdrop.Visible = false
    end)

    return {
        Set = function(v) current = v; valueBtn.Text = v .. "  v" end,
        Get = function() return current end,
    }
end

--=====================================================================
-- PAGE SYSTEM
--=====================================================================
local Pages = {}
local PageOrder = { "Farm", "Upgrades", "Movement", "Visuals", "Settings", "About" }
local PageIcons = {
    Farm = ">", Upgrades = "^", Movement = ">>",
    Visuals = "O", Settings = "*", About = "?",
}

local function createPage(name)
    local page = new("ScrollingFrame", {
        Name = name .. "Page",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = CFG.IsMobile and 6 or 4,
        ScrollBarImageColor3 = T.Primary,
        ScrollBarImageTransparency = 0.3,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = PagesHolder,
    })
    pad(page, 14, 8, 20, 14)
    new("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = page,
    })
    Pages[name] = page
    return page
end

for _, n in ipairs(PageOrder) do createPage(n) end

local TabButtons = {}
local currentPage = nil

local function setPage(name)
    if currentPage == name then return end
    currentPage = name
    for pn, page in pairs(Pages) do
        if pn == name then
            page.Visible = true
            page.Position = UDim2.new(0, 30, 0, 0)
            page.GroupTransparency = 1
            tween(page, 0.3, {
                Position = UDim2.new(0, 0, 0, 0),
                GroupTransparency = 0,
            })
        else
            page.Visible = false
        end
    end
    for tn, btn in pairs(TabButtons) do
        local active = (tn == name)
        local bg = btn:FindFirstChild("BG")
        local accent = btn:FindFirstChild("Accent")
        local icon = btn:FindFirstChild("Icon")
        if bg then
            tween(bg, 0.2, {
                BackgroundTransparency = active and 0 or 1,
                BackgroundColor3 = active and T.SurfActive or T.SurfHover,
            })
        end
        if accent then
            tween(accent, 0.25, {
                Size = active and UDim2.new(0, 3, 0.7, 0) or UDim2.new(0, 3, 0, 0),
            })
        end
        if icon then
            tween(icon, 0.2, {
                TextColor3 = active and T.PrimaryLt or T.TextMute,
            })
        end
        btn.TextColor3 = active and T.Text or T.TextSub
    end
end

for i, name in ipairs(PageOrder) do
    local tabH = CFG.IsMobile and 46 or 40
    local btn = new("TextButton", {
        Size = UDim2.new(1, 0, 0, tabH),
        BackgroundTransparency = 1,
        Text = "      " .. name,
        TextColor3 = T.TextSub,
        Font = Enum.Font.GothamBold,
        TextSize = CFG.IsMobile and 13 or 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = i,
        AutoButtonColor = false,
        Parent = Sidebar,
    })
    corner(btn, 8)

    local bg = new("Frame", {
        Name = "BG",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = T.SurfActive,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = -1,
        Parent = btn,
    })
    corner(bg, 8)

    local accent = new("Frame", {
        Name = "Accent",
        Size = UDim2.new(0, 3, 0, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = T.Primary,
        BorderSizePixel = 0,
        Parent = btn,
    })
    corner(accent, 2)
    grad(accent, T.Primary, T.Cyan, 90)

    new("TextLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 24, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = PageIcons[name] or ".",
        TextColor3 = T.TextMute,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = btn,
    })

    btn.MouseEnter:Connect(function()
        if currentPage == name then return end
        tween(bg, 0.15, { BackgroundTransparency = 0.5, BackgroundColor3 = T.SurfHover })
        tween(accent, 0.2, { Size = UDim2.new(0, 3, 0.4, 0) })
    end)
    btn.MouseLeave:Connect(function()
        if currentPage == name then return end
        tween(bg, 0.15, { BackgroundTransparency = 1 })
        tween(accent, 0.2, { Size = UDim2.new(0, 3, 0, 0) })
    end)
    btn.MouseButton1Click:Connect(function() setPage(name) end)

    TabButtons[name] = btn
end

--=====================================================================
-- FARM ENGINE
--=====================================================================

local function findRemotes()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then
        local sm = ReplicatedStorage:FindFirstChild("SharedModules")
        if sm then
            local net = sm:FindFirstChild("Network")
            if net then remotes = net:FindFirstChild("Remotes") end
        end
    end
    if not remotes then
        for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("Folder") and v.Name:lower():find("remote") then
                remotes = v
                break
            end
        end
    end
    if not remotes then remotes = ReplicatedStorage end

    local function findChild(name)
        local direct = remotes:FindFirstChild(name)
        if direct then return direct end
        for _, v in ipairs(remotes:GetChildren()) do
            if v.Name:lower() == name:lower() then return v end
        end
        for _, v in ipairs(remotes:GetChildren()) do
            if v.Name:lower():find(name:lower()) then return v end
        end
        return nil
    end

    Remotes.SellAll    = findChild("Sell All Friends") or findChild("Sell All") or findChild("SellAll")
    Remotes.Holding    = findChild("Holding Friend")
    Remotes.Place      = findChild("Place Friend")
    Remotes.Rebirth    = findChild("Rebirth")
    Remotes.ClaimIndex = findChild("Claim All Index Rewards")

    if Remotes.Holding then
        pcall(function()
            Remotes.Holding.OnClientEvent:Connect(function(v)
                State.Holding = (v == true)
            end)
        end)
    end
end

local function fireRemote(remote, ...)
    if not remote then return end
    local args = { ... }
    pcall(function()
        remote:FireServer(table.unpack(args))
    end)
end

local function firePrompt(prompt)
    if not prompt then return false end
    local origMax = prompt.MaxActivationDistance
    local origHold = prompt.HoldDuration
    pcall(function()
        prompt.MaxActivationDistance = 100
        prompt.RequiresLineOfSight = false
        prompt.Enabled = true
        prompt.HoldDuration = 0
    end)

    local done = false
    if fireproximityprompt then
        if pcall(fireproximityprompt, prompt) then done = true end
    end
    if not done and keypress and keyrelease then
        pcall(function()
            keypress(Enum.KeyCode.E)
            task.wait(math.max(origHold, 0.1) + 0.05)
            keyrelease(Enum.KeyCode.E)
            done = true
        end)
    end
    task.delay(0.5, function()
        pcall(function()
            if prompt.Parent then
                prompt.HoldDuration = origHold
                prompt.MaxActivationDistance = origMax
            end
        end)
    end)
    return done
end

local function killVelocity(hrp)
    if not hrp then return end
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.Velocity = Vector3.zero
    end)
end

local function flyTo(targetPos, speed)
    local hrp = getHRP()
    if not hrp then return false end
    speed = speed or FarmCfg.Speed
    local startPos = hrp.Position
    local dist = (targetPos - startPos).Magnitude
    if dist < 0.25 then return true end

    local duration = math.max(dist / speed, 0.08)
    local t0 = tick()
    local unit = targetPos - startPos
    if unit.Magnitude > 0 then unit = unit.Unit end

    local stale = 0
    local lastPos = startPos

    while true do
        if not State.AutoFarm then return false end
        local hrpNow = getHRP()
        if not hrpNow then return false end

        local alpha = math.clamp((tick() - t0) / duration, 0, 1)
        local lerped = startPos:Lerp(targetPos, alpha)
        hrpNow.CFrame = CFrame.new(lerped, lerped + unit)
        killVelocity(hrpNow)

        if (hrpNow.Position - lastPos).Magnitude < 0.05 then
            stale = stale + 1
            if stale > 40 then return false end
        else
            stale = 0
            lastPos = hrpNow.Position
        end

        if alpha >= 1 then break end
        RunService.Heartbeat:Wait()
    end
    return true
end

local function flySmart(target, speed)
    speed = speed or FarmCfg.Speed
    local hrp = getHRP()
    if not hrp then return false end
    local pos = hrp.Position
    local safeY = math.max(pos.Y, target.Y) + FarmCfg.SafeHeight
    if not flyTo(Vector3.new(pos.X, safeY, pos.Z), speed) then return false end
    if not flyTo(Vector3.new(target.X, safeY, target.Z), speed) then return false end
    if not flyTo(target, speed) then return false end
    return true
end

local function getSpawnParts()
    local map = workspace:FindFirstChild("Map")
    return map and map:FindFirstChild("SpawnParts") or nil
end

local function getIslandList()
    local sp = getSpawnParts()
    if not sp then return {} end
    local out = {}
    for _, v in ipairs(sp:GetChildren()) do
        if v:IsA("Model") or v:IsA("Folder") then
            table.insert(out, v.Name)
        end
    end
    table.sort(out)
    return out
end

local function getIslandRoot(island)
    local sp = getSpawnParts()
    if not sp then return nil end
    local folder = sp:FindFirstChild(island)
    if not folder then return nil end
    local inner = folder:FindFirstChild(island)
    if inner and inner:IsA("BasePart") then return inner end
    for _, v in ipairs(folder:GetDescendants()) do
        if v:IsA("BasePart") then return v end
    end
    return nil
end

local function getRootOf(inst)
    if inst:IsA("BasePart") then return inst end
    local r = inst:FindFirstChild("RootPart", true)
    if not r then r = inst:FindFirstChild("HumanoidRootPart", true) end
    if not r then r = inst.PrimaryPart end
    return r
end

local function getOwnBase()
    local plots = workspace:FindFirstChild("Plots") or workspace:FindFirstChild("BasePlots")
    if plots then
        for _, v in ipairs(plots:GetChildren()) do
            local owner = v:FindFirstChild("owner")
            if owner then
                local val = owner.Value
                if val == LocalPlayer
                    or tostring(val) == tostring(LocalPlayer.UserId)
                    or tostring(val) == LocalPlayer.Name then
                    return v
                end
            end
        end
    end
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("owner") then
            local ov = v:FindFirstChild("owner").Value
            if ov == LocalPlayer
                or tostring(ov) == LocalPlayer.Name
                or tostring(ov) == tostring(LocalPlayer.UserId) then
                return v
            end
        end
    end
    return nil
end

local function getBaseDepositPos(base)
    if not base then return nil end
    for _, name in ipairs({ "BasePos1", "Base", "Spawn", "DepositPoint" }) do
        local part = base:FindFirstChild(name, true)
        if part and part:IsA("BasePart") then return part.Position end
    end
    local ok, pivot = pcall(function() return base:GetPivot().Position end)
    if ok then return pivot end
    return nil
end

local function inZone(pos, root)
    if not root then return true end
    local ok, localPos = pcall(function() return root.CFrame:PointToObjectSpace(pos) end)
    if not ok then return true end
    local zLimit = root.Size.Z / 2 + FarmCfg.ZoneMargin
    return math.abs(localPos.X) <= root.Size.X / 2 + FarmCfg.ZoneMargin
       and math.abs(localPos.Z) <= zLimit
end

local function getStealPrompt(inst)
    local sp = inst:FindFirstChild("StealPrompt", true)
    if sp and sp:IsA("ProximityPrompt") then return sp end
    for _, v in ipairs(inst:GetDescendants()) do
        if v:IsA("ProximityPrompt") then return v end
    end
    return nil
end

local function isCarrying()
    local char = LocalPlayer.Character
    if not char then return false end
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("WeldConstraint") or v:IsA("Weld") then
            local p0, p1 = v.Part0, v.Part1
            if p0 and p1 then
                local onChar = p0:IsDescendantOf(char) and p0
                    or (p1:IsDescendantOf(char) and p1 or nil)
                if onChar then
                    local other = (onChar == p0) and p1 or p0
                    local mdl = other:FindFirstAncestorOfClass("Model")
                    if mdl and mdl.Name:lower():find(FarmCfg.EggName:lower()) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function findEggs(island)
    local islandRoot = getIslandRoot(island)
    local container = workspace
    for _, name in ipairs({ "Live", "Friends" }) do
        container = container and container:FindFirstChild(name)
    end
    if not container then return {} end

    local list = {}
    for _, v in ipairs(container:GetChildren()) do
        local lower = v.Name:lower()
        if lower:find(FarmCfg.EggName:lower(), 1, true) then
            if v:IsA("Model") or v:IsA("BasePart") then
                local root = getRootOf(v)
                if root then
                    local parent = root.Parent
                    local prompt = getStealPrompt(v)
                    local ok = prompt and prompt.Enabled and inZone(parent.Position, islandRoot)
                    if ok then
                        table.insert(list, { inst = v, root = parent, prompt = prompt })
                    end
                end
            end
        end
    end

    local hrp = getHRP()
    if hrp then
        table.sort(list, function(a, b)
            return (a.root.Position - hrp.Position).Magnitude
                < (b.root.Position - hrp.Position).Magnitude
        end)
    end
    return list
end

local function stealEgg(egg)
    State.Holding = false
    local prompt = getStealPrompt(egg.inst) or egg.prompt
    if not prompt then return false end
    if not getHRP() then return false end

    flyTo(egg.root.Position, FarmCfg.ApproachSpeed)
    task.wait(0.12)
    firePrompt(prompt)

    local t0 = tick()
    while tick() - t0 < FarmCfg.PickupTimeout do
        if not State.AutoFarm then return false end
        if State.Holding then return true end
        if isCarrying() then State.Holding = true; return true end
        if not egg.root.Parent then State.Holding = true; return true end
        task.wait(0.1)
    end
    return false
end

local function depositAt(pos)
    if Remotes.Place then
        fireRemote(Remotes.Place)
        fireRemote(Remotes.Place, true)
        if pos then fireRemote(Remotes.Place, pos) end
    end

    local hrp = getHRP()
    if hrp then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") and v.Enabled then
                local par = v.Parent
                local p
                if par:IsA("BasePart") then
                    p = par.Position
                elseif par:IsA("Model") then
                    local ok, piv = pcall(function() return par:GetPivot().Position end)
                    if ok then p = piv end
                end
                if p and (p - hrp.Position).Magnitude <= 15 then
                    if fireproximityprompt then
                        pcall(fireproximityprompt, v)
                    end
                    pcall(function() v:InputHoldBegin() end)
                    task.delay(0.5, function()
                        pcall(function() v:InputHoldEnd() end)
                    end)
                end
            end
        end
    end

    task.wait(0.6)
    local t0 = tick()
    while tick() - t0 < 5 do
        if not State.AutoFarm then break end
        if not State.Holding then break end
        task.wait(0.15)
    end
    State.Holding = false
    task.wait(FarmCfg.PostDepositWait)
end

local function farmLoop()
    if State.FarmRunning then return end
    State.FarmRunning = true

    local hrp = getHRP()
    if hrp then pcall(function() hrp.Anchored = false end) end

    while State.AutoFarm do
        if not getHRP() then
            task.wait(1)
        else
            if State.Holding then
                local base = getOwnBase()
                local dep = base and getBaseDepositPos(base)
                if dep then
                    flySmart(dep + Vector3.new(0, 10, 0), FarmCfg.Speed)
                    depositAt(dep)
                end
                task.wait(0.3)
            end

            if State.AutoFarm then
                local eggs = findEggs(FarmCfg.SelectedIsland)
                if #eggs == 0 then
                    task.wait(1)
                else
                    local egg = eggs[1]
                    flySmart(egg.root.Position + Vector3.new(0, FarmCfg.SafeHeight, 0), FarmCfg.Speed)
                    if State.AutoFarm then task.wait(0.1) end

                    local ok = false
                    if State.AutoFarm and egg.inst.Parent then
                        ok = stealEgg(egg)
                    end

                    local hrpNow = getHRP()
                    if hrpNow then
                        flyTo(hrpNow.Position + Vector3.new(0, FarmCfg.EscapeHeight, 0), FarmCfg.ApproachSpeed)
                    end

                    if ok and State.AutoFarm then
                        State.PetsCollected = State.PetsCollected + 1
                        notify("Stolen", "Egg #" .. State.PetsCollected, "success")

                        local base = getOwnBase()
                        local dep = base and getBaseDepositPos(base)
                        if not dep then
                            local sp = workspace:FindFirstChild("SpawnLocation", true)
                            if sp then dep = sp.Position end
                        end
                        if dep then
                            flySmart(dep + Vector3.new(0, 8, 0), FarmCfg.Speed)
                            if State.Holding then depositAt(dep) end
                        end
                    else
                        if State.Holding then State.Holding = false end
                        task.wait(0.4)
                    end
                end
            end
        end
        task.wait(FarmCfg.LoopDelay)
    end

    State.FarmRunning = false
    local hrpEnd = getHRP()
    if hrpEnd then pcall(function() hrpEnd.Anchored = false end) end
end

local function sellLoop()
    while State.AutoSell do
        fireRemote(Remotes.SellAll)
        task.wait(FarmCfg.SellInterval)
    end
end

local function getMoney()
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    if not ls then return nil end
    for _, name in ipairs({ "Money", "Cash", "Coins" }) do
        local v = ls:FindFirstChild(name)
        if v and typeof(v.Value) == "number" then return v.Value end
    end
    return nil
end

local function getUpgradeRemote()
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("upgrade") then
            return v
        end
    end
    return nil
end

local UpgradeRemote = getUpgradeRemote()

local function upgradeLoop()
    while State.AutoUpgrade do
        local which = FarmCfg.UpgradeWhich
        if State.UpgradeTargets[which] then
            notify("Upgrade", which .. " MAX", "success")
            State.AutoUpgrade = false
            if UpgradeToggle then UpgradeToggle.Set(false) end
            break
        end
        if UpgradeRemote then
            pcall(function() UpgradeRemote:FireServer(which) end)
            task.wait(0.3)
        else
            task.wait(0.5)
        end
    end
end

local function rebirthLoop()
    while State.AutoRebirth do
        fireRemote(Remotes.Rebirth)
        State.UpgradeTargets.Speed = false
        State.UpgradeTargets.Stamina = false
        State.UpgradeTargets.Carry = false
        task.wait(5)
    end
end

local function indexLoop()
    local fails = 0
    while State.AutoIndex do
        if Remotes.ClaimIndex then
            local ok, res = pcall(function()
                return Remotes.ClaimIndex:InvokeServer()
            end)
            local claimed = ok and type(res) == "table" and res.success
            if claimed then
                fails = 0
                local cash = tonumber(res.cash) or 0
                if cash > 0 then
                    notify("Index", "Claimed +" .. tostring(math.floor(cash)), "success")
                end
            else
                fails = fails + 1
                if fails >= 3 then
                    task.wait(5)
                    fails = 0
                end
            end
            task.wait(3)
        else
            break
        end
    end
end

task.spawn(function()
    local sendNotif
    for _ = 1, 20 do
        pcall(function()
            sendNotif = ReplicatedStorage.SharedModules.Network.Remotes["Send Notification"]
        end)
        if sendNotif then break end
        task.wait(0.5)
    end
    if not sendNotif then return end

    sendNotif.OnClientEvent:Connect(function(...)
        for _, msg in ipairs({ ... }) do
            if type(msg) == "string" then
                local low = msg:lower()
                if low:find("maxed") then
                    for _, name in ipairs({ "Speed", "Stamina", "Carry" }) do
                        if low:find(name:lower()) then
                            State.UpgradeTargets[name] = true
                        end
                    end
                end
            end
        end
    end)
end)

task.spawn(function()
    task.wait(1.5)
    findRemotes()
    print("[SV] SellAll:", Remotes.SellAll and Remotes.SellAll.Name or "nil")
    print("[SV] Holding:", Remotes.Holding and Remotes.Holding.Name or "nil")
    print("[SV] Place:", Remotes.Place and Remotes.Place.Name or "nil")
    print("[SV] Rebirth:", Remotes.Rebirth and Remotes.Rebirth.Name or "nil")
    print("[SV] ClaimIndex:", Remotes.ClaimIndex and Remotes.ClaimIndex.Name or "nil")
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        hum.Died:Connect(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then pcall(function() hrp.Anchored = false end) end
        end)
    end
    if State.AutoFarm then State.Holding = false end
end)

--=====================================================================
-- FARM PAGE
--=====================================================================
local FarmAPI = { Toggles = {}, Sliders = {}, Dropdowns = {}, Callbacks = {} }
local farmPage = Pages["Farm"]

C.Section(farmPage, "Automation")

FarmAPI.Toggles.AutoFarm = C.Toggle(farmPage, "Enable Auto Farm", false, function(s)
    State.AutoFarm = s
    if s then
        notify("Auto Farm", "Started", "success")
        if not State.FarmRunning then
            Threads.Farm = task.spawn(farmLoop)
        end
    else
        notify("Auto Farm", "Stopped", "info")
        if Threads.Farm then pcall(task.cancel, Threads.Farm); Threads.Farm = nil end
    end
    if FarmAPI.Callbacks.OnAutoFarm then pcall(FarmAPI.Callbacks.OnAutoFarm, s) end
end)

FarmAPI.Toggles.AutoSell = C.Toggle(farmPage, "Auto Sell Pets", false, function(s)
    State.AutoSell = s
    if s then
        Threads.Sell = task.spawn(sellLoop)
        notify("Auto Sell", "Started", "success")
    else
        if Threads.Sell then pcall(task.cancel, Threads.Sell); Threads.Sell = nil end
        notify("Auto Sell", "Stopped", "info")
    end
    if FarmAPI.Callbacks.OnAutoSell then pcall(FarmAPI.Callbacks.OnAutoSell, s) end
end)

C.Section(farmPage, "Target")

local islandOptions = getIslandList()
if #islandOptions == 0 then islandOptions = { "Beach" } end

FarmAPI.Dropdowns.Island = C.Dropdown(farmPage, "Island", islandOptions, FarmCfg.SelectedIsland, function(v)
    FarmCfg.SelectedIsland = v
    notify("Island", "Target: " .. v, "info")
    if FarmAPI.Callbacks.OnIsland then pcall(FarmAPI.Callbacks.OnIsland, v) end
end)

C.Section(farmPage, "Tuning")

FarmAPI.Sliders.Speed = C.Slider(farmPage, "Flight Speed", 40, 600, FarmCfg.Speed, function(v)
    FarmCfg.Speed = v
    if FarmAPI.Callbacks.OnSpeed then pcall(FarmAPI.Callbacks.OnSpeed, v) end
end)

FarmAPI.Sliders.Height = C.Slider(farmPage, "Safe Height", 30, 200, FarmCfg.SafeHeight, function(v)
    FarmCfg.SafeHeight = v
    if FarmAPI.Callbacks.OnHeight then pcall(FarmAPI.Callbacks.OnHeight, v) end
end)

C.Section(farmPage, "Actions")

C.Button(farmPage, "Sell Now", T.Success, function()
    fireRemote(Remotes.SellAll)
    notify("Sell", "Triggered", "success")
end)

C.Button(farmPage, "Deposit Now", T.Primary, function()
    local base = getOwnBase()
    local dep = base and getBaseDepositPos(base)
    if dep then
        flySmart(dep + Vector3.new(0, 10, 0), FarmCfg.Speed)
        depositAt(dep)
        notify("Deposit", "Done", "success")
    else
        notify("Deposit", "Base not found", "error")
    end
end)

--=====================================================================
-- UPGRADES PAGE
--=====================================================================
local UpgradeAPI = { Toggles = {}, Dropdowns = {}, Callbacks = {} }
local upgPage = Pages["Upgrades"]

C.Section(upgPage, "Character Upgrades")

UpgradeAPI.Dropdowns.Which = C.Dropdown(upgPage, "Target", { "Speed", "Stamina", "Carry" },
    FarmCfg.UpgradeWhich, function(v)
    FarmCfg.UpgradeWhich = v
    notify("Upgrade", "Target: " .. v, "info")
end)

local UpgradeToggle
UpgradeToggle = C.Toggle(upgPage, "Auto Upgrade", false, function(s)
    State.AutoUpgrade = s
    if s then
        if State.UpgradeTargets[FarmCfg.UpgradeWhich] then
            notify("Upgrade", FarmCfg.UpgradeWhich .. " is MAX", "warning")
            State.AutoUpgrade = false
            UpgradeToggle.Set(false)
            return
        end
        Threads.Upgrade = task.spawn(upgradeLoop)
        notify("Auto Upgrade", "Started", "success")
    else
        if Threads.Upgrade then pcall(task.cancel, Threads.Upgrade); Threads.Upgrade = nil end
        notify("Auto Upgrade", "Stopped", "info")
    end
end)
UpgradeAPI.Toggles.Upgrade = UpgradeToggle

UpgradeAPI.Toggles.Rebirth = C.Toggle(upgPage, "Auto Rebirth", false, function(s)
    State.AutoRebirth = s
    if s then
        Threads.Rebirth = task.spawn(rebirthLoop)
        notify("Auto Rebirth", "Started", "success")
    else
        if Threads.Rebirth then pcall(task.cancel, Threads.Rebirth); Threads.Rebirth = nil end
        notify("Auto Rebirth", "Stopped", "info")
    end
end)

UpgradeAPI.Toggles.Index = C.Toggle(upgPage, "Auto Index Claim", false, function(s)
    State.AutoIndex = s
    if s then
        if not Remotes.ClaimIndex then
            notify("Index", "Remote not found", "error")
            State.AutoIndex = false
            UpgradeAPI.Toggles.Index.Set(false)
            return
        end
        Threads.Index = task.spawn(indexLoop)
        notify("Index", "Started", "success")
    else
        if Threads.Index then pcall(task.cancel, Threads.Index); Threads.Index = nil end
        notify("Index", "Stopped", "info")
    end
end)

--=====================================================================
-- MOVEMENT PAGE
--=====================================================================
local MoveAPI = { Toggles = {}, Sliders = {}, Callbacks = {} }
local movePage = Pages["Movement"]

C.Section(movePage, "Character")

MoveAPI.Toggles.InfiniteJump = C.Toggle(movePage, "Infinite Jump", false, function(s)
    MoveAPI._InfJump = s
end)

MoveAPI.Toggles.FullNoclip = C.Toggle(movePage, "Noclip", false, function(s)
    MoveAPI._Noclip = s
end)

C.Section(movePage, "Stats")

MoveAPI.Sliders.WalkSpeed = C.Slider(movePage, "Walk Speed", 16, 500, 16, function(v)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v end
end)

MoveAPI.Sliders.JumpPower = C.Slider(movePage, "Jump Power", 50, 500, 50, function(v)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = v
    end
end)

UserInputService.JumpRequest:Connect(function()
    if MoveAPI._InfJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

RunService.Stepped:Connect(function()
    if MoveAPI._Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

--=====================================================================
-- VISUALS PAGE
--=====================================================================
local VisAPI = { Toggles = {}, Callbacks = {} }
local visPage = Pages["Visuals"]

C.Section(visPage, "Rendering")

VisAPI.Toggles.Fullbright = C.Toggle(visPage, "Fullbright Lighting", false, function(s)
    if s then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1e6
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 2
        Lighting.GlobalShadows = true
    end
end)

VisAPI.Toggles.RemoveFog = C.Toggle(visPage, "Remove Fog", false, function(s)
    if s then
        Lighting.FogEnd = 1e6
        Lighting.FogStart = 1e6
    end
end)

C.Section(visPage, "Overlay")

VisAPI.Toggles.Watermark = C.Toggle(visPage, "Toggle Watermark", true, function(s)
    local wm = Window:FindFirstChild("Watermark")
    if wm then wm.Visible = s end
end)

--=====================================================================
-- SETTINGS PAGE
--=====================================================================
local setPage = Pages["Settings"]

C.Section(setPage, "Configuration")
C.Button(setPage, "Rescan Remotes", T.Primary, function()
    findRemotes()
    notify("Remotes", "Rescanned", "success")
end)
C.Button(setPage, "Unload Script", T.Danger, function()
    State.AutoFarm = false
    State.AutoSell = false
    State.AutoUpgrade = false
    State.AutoRebirth = false
    State.AutoIndex = false
    for _, th in pairs(Threads) do
        if th then pcall(task.cancel, th) end
    end
    ScreenGui:Destroy()
end)

--=====================================================================
-- ABOUT PAGE
--=====================================================================
local aboutPage = Pages["About"]

local logoBig = new("Frame", {
    Size = UDim2.new(0, 110, 0, 110),
    Position = UDim2.new(0.5, -55, 0, 20),
    BackgroundColor3 = T.Primary,
    BorderSizePixel = 0,
    Parent = aboutPage,
})
corner(logoBig, 22)
grad(logoBig, T.Primary, T.Cyan, 135)
stroke(logoBig, T.PrimaryLt, 1, 0.4)

new("ImageLabel", {
    Size = UDim2.new(1, -14, 1, -14),
    Position = UDim2.new(0, 7, 0, 7),
    BackgroundTransparency = 1,
    Image = CFG.Logo,
    ScaleType = Enum.ScaleType.Fit,
    Parent = logoBig,
})

new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 32),
    Position = UDim2.new(0, 0, 0, 140),
    BackgroundTransparency = 1,
    Text = CFG.Title,
    TextColor3 = T.Text,
    Font = Enum.Font.GothamBlack,
    TextSize = 16,
    Parent = aboutPage,
})

new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 0, 172),
    BackgroundTransparency = 1,
    Text = CFG.Subtitle,
    TextColor3 = T.TextSub,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    Parent = aboutPage,
})

new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 18),
    Position = UDim2.new(0, 0, 0, 194),
    BackgroundTransparency = 1,
    Text = CFG.Version .. "  |  Wisp Engine  |  Keyless",
    TextColor3 = T.TextMute,
    Font = Enum.Font.Code,
    TextSize = 11,
    Parent = aboutPage,
})

new("TextLabel", {
    Size = UDim2.new(1, -40, 0, 60),
    Position = UDim2.new(0, 20, 0, 220),
    BackgroundTransparency = 1,
    Text = "Steal-a-Brainrot autofarm engine.\nFlies to nearest egg, steals, deposits at your base, repeats.\nAuto sell, auto upgrade, auto rebirth, index claim.",
    TextColor3 = T.TextSub,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextWrapped = true,
    Parent = aboutPage,
})

--=====================================================================
-- FOOTER
--=====================================================================
local Footer = new("Frame", {
    Size = UDim2.new(1, 0, 0, 24),
    Position = UDim2.new(0, 0, 1, -24),
    BackgroundColor3 = T.Surface,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    ZIndex = 5,
    Parent = Window,
})

local StatusLbl = new("TextLabel", {
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 12, 0, 0),
    BackgroundTransparency = 1,
    Text = "Ready",
    TextColor3 = T.TextMute,
    Font = Enum.Font.Code,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Footer,
})

new("TextLabel", {
    Size = UDim2.new(0, 200, 1, 0),
    Position = UDim2.new(1, -212, 0, 0),
    BackgroundTransparency = 1,
    Text = CFG.Version,
    TextColor3 = T.PrimaryLt,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Right,
    Parent = Footer,
})

task.spawn(function()
    while Window and Window.Parent do
        task.wait(1)
        local ok, fps = pcall(function()
            return math.floor(1 / RunService.RenderStepped:Wait())
        end)
        if StatusLbl and StatusLbl.Parent then
            StatusLbl.Text = string.format("FPS: %d   |   Eggs: %d   |   Ping: %dms",
                ok and fps or 0,
                State.PetsCollected,
                math.floor(LocalPlayer:GetNetworkPing() * 1000))
        end
    end
end)

--=====================================================================
-- NOTIFICATION HOLDER
--=====================================================================
NotifHolder = new("Frame", {
    Size = UDim2.new(0, 320, 0, 500),
    Position = UDim2.new(1, -330, 0, 20),
    BackgroundTransparency = 1,
    ZIndex = 100,
    Parent = ScreenGui,
})
new("UIListLayout", {
    Padding = UDim.new(0, 8),
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = NotifHolder,
})

--=====================================================================
-- WINDOW DRAG
--=====================================================================
do
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Window.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Window.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

--=====================================================================
-- MINIMIZE
--=====================================================================
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        tween(Window, 0.35, { Size = UDim2.new(0, 280, 0, HeaderH) })
        PagesHolder.Visible = false
        Sidebar.Visible = false
        Footer.Visible = false
    else
        local s = responsiveSize()
        tween(Window, 0.35, { Size = UDim2.new(0, s.X, 0, s.Y) })
        task.wait(0.36)
        PagesHolder.Visible = true
        Sidebar.Visible = true
        Footer.Visible = true
    end
end)

--=====================================================================
-- FLOATING TOGGLE
--=====================================================================
local ToggleBtn = new("TextButton", {
    Name = "FloatingToggle",
    Size = UDim2.new(0, CFG.IsMobile and 66 or 56, 0, CFG.IsMobile and 66 or 56),
    Position = UDim2.new(1, -80, 0.5, -28),
    BackgroundColor3 = T.Primary,
    Text = "",
    AutoButtonColor = false,
    ZIndex = 200,
    Parent = ScreenGui,
})
corner(ToggleBtn, CFG.IsMobile and 33 or 28)
stroke(ToggleBtn, T.PrimaryLt, 2, 0.2)
grad(ToggleBtn, T.Primary, T.Cyan, 135)

local pulse = new("Frame", {
    Size = UDim2.new(1, -8, 1, -8),
    Position = UDim2.new(0, 4, 0, 4),
    BackgroundColor3 = T.PrimaryLt,
    BackgroundTransparency = 0.8,
    BorderSizePixel = 0,
    ZIndex = -1,
    Parent = ToggleBtn,
})
corner(pulse, 28)

task.spawn(function()
    while pulse and pulse.Parent do
        tween(pulse, 1.4, {
            BackgroundTransparency = 0.5,
            Size = UDim2.new(1, 8, 1, 8),
            Position = UDim2.new(0, -4, 0, -4) })
        task.wait(1.4)
        tween(pulse, 1.4, {
            BackgroundTransparency = 0.85,
            Size = UDim2.new(1, -8, 1, -8),
            Position = UDim2.new(0, 4, 0, 4) })
        task.wait(1.4)
    end
end)

new("ImageLabel", {
    Size = UDim2.new(1, -16, 1, -16),
    Position = UDim2.new(0, 8, 0, 8),
    BackgroundTransparency = 1,
    Image = CFG.Logo,
    ScaleType = Enum.ScaleType.Fit,
    ZIndex = 201,
    Parent = ToggleBtn,
})

local tDragging, tStart, tStartPos = false, nil, nil
local tTapTime, tMoved = 0, false

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        tDragging = true
        tStart = input.Position
        tStartPos = ToggleBtn.Position
        tTapTime = tick()
        tMoved = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if tDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - tStart
        if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then tMoved = true end
        if tMoved then
            ToggleBtn.Position = UDim2.new(
                tStartPos.X.Scale, tStartPos.X.Offset + delta.X,
                tStartPos.Y.Scale, tStartPos.Y.Offset + delta.Y)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        if tDragging and not tMoved and tick() - tTapTime < 0.5 then
            if Window.Visible then
                tween(Window, 0.25, {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                task.wait(0.26)
                Window.Visible = false
                tween(ToggleBtn, 0.2, { BackgroundColor3 = T.Primary })
            else
                local s = responsiveSize()
                Window.Visible = true
                Window.Size = UDim2.new(0, 0, 0, 0)
                Window.Position = UDim2.new(0.5, 0, 0.5, 0)
                tween(Window, 0.3, {
                    Size = UDim2.new(0, s.X, 0, s.Y),
                    Position = UDim2.new(0.5, -s.X / 2, 0.5, -s.Y / 2),
                }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                tween(ToggleBtn, 0.2, { BackgroundColor3 = T.Success })
            end
        end
        tDragging = false
    end
end)

--=====================================================================
-- KEYBIND
--=====================================================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if Window.Visible then
            tween(Window, 0.25, { Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0) })
            task.wait(0.26)
            Window.Visible = false
            tween(ToggleBtn, 0.2, { BackgroundColor3 = T.Primary })
        else
            local s = responsiveSize()
            Window.Visible = true
            Window.Size = UDim2.new(0, 0, 0, 0)
            Window.Position = UDim2.new(0.5, 0, 0.5, 0)
            tween(Window, 0.3, {
                Size = UDim2.new(0, s.X, 0, s.Y),
                Position = UDim2.new(0.5, -s.X / 2, 0.5, -s.Y / 2) })
            tween(ToggleBtn, 0.2, { BackgroundColor3 = T.Success })
        end
    end
end)

--=====================================================================
-- ANTI-AFK
--=====================================================================
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickStack(2)
    end)
end)

--=====================================================================
-- VIEWPORT CHANGE
--=====================================================================
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    if Window.Visible and not minimized then
        local s = responsiveSize()
        Window.Size = UDim2.new(0, s.X, 0, s.Y)
        Window.Position = UDim2.new(0.5, -s.X / 2, 0.5, -s.Y / 2)
    end
end)

--=====================================================================
-- INITIALIZE
--=====================================================================
setPage("Farm")

task.spawn(function()
    local s = responsiveSize()
    Window.Size = UDim2.new(0, 0, 0, 0)
    Window.Position = UDim2.new(0.5, 0, 0.5, 0)
    Window.Visible = true
    tween(Window, 0.45, {
        Size = UDim2.new(0, s.X, 0, s.Y),
        Position = UDim2.new(0.5, -s.X / 2, 0.5, -s.Y / 2),
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    ToggleBtn.BackgroundColor3 = T.Success
    task.wait(0.6)
    notify("SCRIPTVAULT +1 WINGS FOR EGGS V1.1",
        "Wisp engine ready. Toggle Auto Farm to begin.",
        "success")
end)

--=====================================================================
-- PUBLIC API
--=====================================================================
local API = {
    Version = CFG.Version,
    Farm = FarmAPI,
    Upgrades = UpgradeAPI,
    Movement = MoveAPI,
    Visuals = VisAPI,
    Config = FarmCfg,
    State = State,
    Remotes = Remotes,
    Notify = notify,
    Window = Window,
    ScreenGui = ScreenGui,
}

_G.ScriptVault = API
return API
