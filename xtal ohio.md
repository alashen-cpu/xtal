repeat task.wait() until game:IsLoaded()

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local Stats             = game:GetService("Stats")
local HttpService       = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService   = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local StarterGui        = game:GetService("StarterGui")
local CoreGui           = game:GetService("CoreGui")
local Lighting          = game:GetService("Lighting")
local Camera            = Workspace.CurrentCamera
local LocalPlayer       = Players.LocalPlayer
local PlayerGui         = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- [0] 彩虹 Xtal 加载动画（约 5 秒）
-- ============================================================
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "xtalLoading"
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true
LoadingGui.DisplayOrder = 10000
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() LoadingGui.Parent = CoreGui end)
if not LoadingGui.Parent then LoadingGui.Parent = PlayerGui end

local Backdrop = Instance.new("Frame")
Backdrop.Size = UDim2.fromScale(1, 1)
Backdrop.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Backdrop.BackgroundTransparency = 1
Backdrop.BorderSizePixel = 0
Backdrop.ZIndex = 1
Backdrop.Parent = LoadingGui

local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.fromScale(1, 1)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 0.35
Overlay.BorderSizePixel = 0
Overlay.ZIndex = 2
Overlay.Parent = LoadingGui

local LetterHolder = Instance.new("Frame")
LetterHolder.AnchorPoint = Vector2.new(0.5, 0.5)
LetterHolder.Position = UDim2.fromScale(0.5, 0.5)
LetterHolder.Size = UDim2.new(0, 600, 0, 200)
LetterHolder.BackgroundTransparency = 1
LetterHolder.ZIndex = 3
LetterHolder.Parent = LoadingGui

local LetterLayout = Instance.new("UIListLayout")
LetterLayout.FillDirection = Enum.FillDirection.Horizontal
LetterLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
LetterLayout.VerticalAlignment = Enum.VerticalAlignment.Center
LetterLayout.SortOrder = Enum.SortOrder.LayoutOrder
LetterLayout.Padding = UDim.new(0, 20)
LetterLayout.Parent = LetterHolder

local TipLabel = Instance.new("TextLabel")
TipLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TipLabel.Position = UDim2.fromScale(0.5, 0.78)
TipLabel.Size = UDim2.new(0, 500, 0, 40)
TipLabel.BackgroundTransparency = 1
TipLabel.Font = Enum.Font.GothamBold
TipLabel.Text = "正在加载 xtal 脚本..."
TipLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
TipLabel.TextSize = 22
TipLabel.TextTransparency = 1
TipLabel.ZIndex = 3
TipLabel.Parent = LoadingGui

local letterChars = { "X", "t", "a", "l" }
local letterLabels = {}
local allStrokes = {}

for i, ch in ipairs(letterChars) do
    local lbl = Instance.new("TextLabel")
    lbl.Name = "Letter_" .. i
    lbl.Size = UDim2.new(0, 120, 0, 160)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBlack
    lbl.Text = ch
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextScaled = true
    lbl.TextTransparency = 1
    lbl.LayoutOrder = i
    lbl.ZIndex = 4
    lbl.Parent = LetterHolder

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 3
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Transparency = 1
    stroke.Parent = lbl

    table.insert(allStrokes, { stroke = stroke, hueOffset = (i - 1) * 0.25 })
    letterLabels[i] = { label = lbl, stroke = stroke }
end

local Blur = Instance.new("BlurEffect")
Blur.Name = "xtalLoadingBlur"
Blur.Size = 0
Blur.Parent = Lighting

local rainbowActive = false
local rainbowHue = 0

local function startRainbow()
    rainbowActive = true
    task.spawn(function()
        while rainbowActive do
            RunService.RenderStepped:Wait()
            rainbowHue = (rainbowHue + 0.008) % 1
            for _, data in ipairs(allStrokes) do
                local h = (rainbowHue + data.hueOffset) % 1
                data.stroke.Color = Color3.fromHSV(h, 1, 1)
            end
        end
    end)
end

local function playLoadingAnimation()
    startRainbow()
    TweenService:Create(Blur, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Size = 24}):Play()
    TweenService:Create(Backdrop, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
    TweenService:Create(TipLabel, TweenInfo.new(0.6), {TextTransparency = 0}):Play()

    task.wait(0.5)

    for i, data in ipairs(letterLabels) do
        local lbl = data.label
        local stroke = data.stroke
        lbl.TextTransparency = 1
        lbl.Rotation = -25
        stroke.Transparency = 1

        local info = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(lbl, info, {TextTransparency = 0}):Play()
        TweenService:Create(lbl, info, {Rotation = 0}):Play()
        TweenService:Create(stroke, info, {Transparency = 0}):Play()
        task.wait(1)
    end

    task.wait(0.5)

    local fadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    for _, data in ipairs(letterLabels) do
        TweenService:Create(data.label, fadeInfo, {TextTransparency = 1, Rotation = 15}):Play()
        TweenService:Create(data.stroke, fadeInfo, {Transparency = 1}):Play()
    end
    TweenService:Create(TipLabel, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(Backdrop, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(Blur, fadeInfo, {Size = 0}):Play()

    task.wait(0.7)
    rainbowActive = false
    if Blur then Blur:Destroy() end
    if LoadingGui then LoadingGui:Destroy() end
end

playLoadingAnimation()

-- ============================================================
-- [1] 主脚本
-- ============================================================
local COLLAPSED_W, COLLAPSED_H = 280, 34
local EXPANDED_W, EXPANDED_H = 500, 320
local TOP_OFFSET = 12
local CONFIG_FILE = "xtal_island_config.json"

local function saveCfg(tbl)
    getgenv().xtalIslandCfg = tbl
    pcall(function() if writefile then writefile(CONFIG_FILE, HttpService:JSONEncode(tbl)) end end)
end
local function loadCfg()
    if getgenv().xtalIslandCfg then return getgenv().xtalIslandCfg end
    local data
    pcall(function() if isfile and readfile and isfile(CONFIG_FILE) then data = HttpService:JSONDecode(readfile(CONFIG_FILE)) end end)
    if data then getgenv().xtalIslandCfg = data end
    return data
end

local cfg = loadCfg() or {}
local savedC1 = cfg.c1 and Color3.fromRGB(cfg.c1[1], cfg.c1[2], cfg.c1[3]) or Color3.fromRGB(25, 28, 35)
local savedC2 = cfg.c2 and Color3.fromRGB(cfg.c2[1], cfg.c2[2], cfg.c2[3]) or Color3.fromRGB(15, 16, 20)

local old = PlayerGui:FindFirstChild("xtalDynamicIsland")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "xtalDynamicIsland"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 9999
gui.Parent = PlayerGui

local island = Instance.new("Frame")
island.AnchorPoint = Vector2.new(0.5, 0)
island.Position = UDim2.new(0.5, 0, 0, TOP_OFFSET)
island.Size = UDim2.fromOffset(COLLAPSED_W, COLLAPSED_H)
island.BackgroundColor3 = savedC1
island.BorderSizePixel = 0
island.ClipsDescendants = true
island.ZIndex = 100
island.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = island
local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new(savedC1, savedC2)
bgGradient.Rotation = 90
bgGradient.Parent = island
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.5
overlay.BorderSizePixel = 0
overlay.ZIndex = 101
overlay.Parent = island
local overlayCorner = Instance.new("UICorner")
overlayCorner.CornerRadius = UDim.new(1, 0)
overlayCorner.Parent = overlay
local compact = Instance.new("Frame")
compact.Size = UDim2.new(1, 0, 1, 0)
compact.BackgroundTransparency = 1
compact.ZIndex = 105
compact.Parent = island
local dot = Instance.new("Frame")
dot.AnchorPoint = Vector2.new(0, 0.5)
dot.Position = UDim2.new(0, 14, 0.5, 0)
dot.Size = UDim2.new(0, 7, 0, 7)
dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dot.BorderSizePixel = 0
dot.ZIndex = 106
dot.Parent = compact
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
local titleLabel = Instance.new("TextLabel")
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 28, 0, 0)
titleLabel.Size = UDim2.new(0, 50, 1, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "xtal"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 106
titleLabel.Parent = compact
local sep1 = Instance.new("TextLabel")
sep1.BackgroundTransparency = 1
sep1.Position = UDim2.new(0, 78, 0, 0)
sep1.Size = UDim2.new(0, 12, 1, 0)
sep1.Font = Enum.Font.GothamBold
sep1.Text = "·"
sep1.TextColor3 = Color3.fromRGB(200, 202, 210)
sep1.TextSize = 14
sep1.ZIndex = 106
sep1.Parent = compact
local fpsLabel = Instance.new("TextLabel")
fpsLabel.BackgroundTransparency = 1
fpsLabel.Position = UDim2.new(0, 90, 0, 0)
fpsLabel.Size = UDim2.new(0, 80, 1, 0)
fpsLabel.Font = Enum.Font.GothamMedium
fpsLabel.Text = "FPS: --"
fpsLabel.TextColor3 = Color3.fromRGB(240, 242, 250)
fpsLabel.TextSize = 12
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.ZIndex = 106
fpsLabel.Parent = compact
local sep2 = Instance.new("TextLabel")
sep2.BackgroundTransparency = 1
sep2.Position = UDim2.new(0, 178, 0, 0)
sep2.Size = UDim2.new(0, 12, 1, 0)
sep2.Font = Enum.Font.GothamBold
sep2.Text = "·"
sep2.TextColor3 = Color3.fromRGB(200, 202, 210)
sep2.TextSize = 14
sep2.ZIndex = 106
sep2.Parent = compact
local pingLabel = Instance.new("TextLabel")
pingLabel.BackgroundTransparency = 1
pingLabel.Position = UDim2.new(0, 190, 0, 0)
pingLabel.Size = UDim2.new(0, 90, 1, 0)
pingLabel.Font = Enum.Font.GothamMedium
pingLabel.Text = "Ping: --"
pingLabel.TextColor3 = Color3.fromRGB(240, 242, 250)
pingLabel.TextSize = 12
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.ZIndex = 106
pingLabel.Parent = compact

local panel = Instance.new("Frame")
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.new(0.5, 0, 0.5, 0)
panel.Size = UDim2.fromOffset(EXPANDED_W, EXPANDED_H)
panel.BackgroundColor3 = savedC1
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.Visible = false
panel.ZIndex = 50
panel.Parent = gui
local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 14)
panelCorner.Parent = panel
local panelGradient = Instance.new("UIGradient")
panelGradient.Color = ColorSequence.new(savedC1, savedC2)
panelGradient.Rotation = 90
panelGradient.Parent = panel
local panelOverlay = Instance.new("Frame")
panelOverlay.Size = UDim2.new(1, 0, 1, 0)
panelOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
panelOverlay.BackgroundTransparency = 0.5
panelOverlay.BorderSizePixel = 0
panelOverlay.ZIndex = 51
panelOverlay.Parent = panel
local panelOverlayCorner = Instance.new("UICorner")
panelOverlayCorner.CornerRadius = UDim.new(0, 14)
panelOverlayCorner.Parent = panelOverlay
local closeBtn = Instance.new("TextButton")
closeBtn.AnchorPoint = Vector2.new(1, 0)
closeBtn.Position = UDim2.new(1, -12, 0, 12)
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 52, 62)
closeBtn.BackgroundTransparency = 0.3
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(220, 222, 230)
closeBtn.TextSize = 16
closeBtn.ZIndex = 60
closeBtn.Parent = panel
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
local mTitle = Instance.new("TextLabel")
mTitle.BackgroundTransparency = 1
mTitle.Position = UDim2.new(0, 20, 0, 12)
mTitle.Size = UDim2.new(0, 200, 0, 22)
mTitle.Font = Enum.Font.GothamBold
mTitle.Text = "xtal  v1.0"
mTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
mTitle.TextSize = 14
mTitle.TextXAlignment = Enum.TextXAlignment.Left
mTitle.ZIndex = 60
mTitle.Parent = panel
local mSub = Instance.new("TextLabel")
mSub.BackgroundTransparency = 1
mSub.Position = UDim2.new(0, 20, 0, 32)
mSub.Size = UDim2.new(0, 300, 0, 14)
mSub.Font = Enum.Font.Gotham
mSub.Text = "Develop by xtal"
mSub.TextColor3 = Color3.fromRGB(150, 152, 162)
mSub.TextSize = 10
mSub.TextXAlignment = Enum.TextXAlignment.Left
mSub.ZIndex = 60
mSub.Parent = panel
local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.new(0, 12, 0, 54)
sidebar.Size = UDim2.new(0, 140, 1, -66)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 27, 34)
sidebar.BackgroundTransparency = 0.35
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 55
sidebar.Parent = panel
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)
local searchBox = Instance.new("TextBox")
searchBox.Position = UDim2.new(0, 8, 0, 8)
searchBox.Size = UDim2.new(1, -16, 0, 24)
searchBox.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
searchBox.BackgroundTransparency = 0.2
searchBox.BorderSizePixel = 0
searchBox.Font = Enum.Font.Gotham
searchBox.Text = ""
searchBox.PlaceholderText = "搜索"
searchBox.PlaceholderColor3 = Color3.fromRGB(130, 132, 142)
searchBox.TextColor3 = Color3.fromRGB(230, 232, 240)
searchBox.TextSize = 11
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.ClearTextOnFocus = false
searchBox.ZIndex = 56
searchBox.Parent = sidebar
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)
local sPad = Instance.new("UIPadding", searchBox)
sPad.PaddingLeft = UDim.new(0, 8)
local tabScroll = Instance.new("ScrollingFrame")
tabScroll.Position = UDim2.new(0, 6, 0, 38)
tabScroll.Size = UDim2.new(1, -12, 1, -44)
tabScroll.BackgroundTransparency = 1
tabScroll.BorderSizePixel = 0
tabScroll.ScrollBarThickness = 2
tabScroll.ScrollBarImageColor3 = Color3.fromRGB(90, 92, 102)
tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
tabScroll.ZIndex = 56
tabScroll.Parent = sidebar
local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 4)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabScroll
tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    tabScroll.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 6)
end)
local contentArea = Instance.new("Frame")
contentArea.Position = UDim2.new(0, 160, 0, 54)
contentArea.Size = UDim2.new(1, -172, 1, -66)
contentArea.BackgroundColor3 = Color3.fromRGB(25, 27, 34)
contentArea.BackgroundTransparency = 0.35
contentArea.BorderSizePixel = 0
contentArea.ZIndex = 55
contentArea.Parent = panel
Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 10)
local contentScroll = Instance.new("ScrollingFrame")
contentScroll.Size = UDim2.new(1, 0, 1, 0)
contentScroll.BackgroundTransparency = 1
contentScroll.BorderSizePixel = 0
contentScroll.ScrollBarThickness = 2
contentScroll.ScrollBarImageColor3 = Color3.fromRGB(90, 92, 102)
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
contentScroll.ZIndex = 56
contentScroll.Parent = contentArea
local cPad = Instance.new("UIPadding", contentScroll)
cPad.PaddingTop = UDim.new(0, 8)
cPad.PaddingBottom = UDim.new(0, 8)
cPad.PaddingLeft = UDim.new(0, 8)
cPad.PaddingRight = UDim.new(0, 8)
local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 5)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = contentScroll
contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 16)
end)

local primaryTouch = nil

UserInputService.TouchStarted:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and primaryTouch == nil then
        primaryTouch = input
    end
end)

UserInputService.TouchEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and input == primaryTouch then
        primaryTouch = nil
        contentScroll.ScrollingEnabled = false
        tabScroll.ScrollingEnabled = false
        task.delay(0.05, function()
            if primaryTouch == nil then
                contentScroll.ScrollingEnabled = true
                tabScroll.ScrollingEnabled = true
            end
        end)
    end
end)

local Island = {}
Island.Expanded = false
Island.Tabs = {}
Island.CurrentTab = nil

function Island:Expand()
    if self.Expanded then return end
    self.Expanded = true
    panel.Visible = true
    panel.Size = UDim2.fromOffset(EXPANDED_W, 10)
    TweenService:Create(panel, TweenInfo.new(0.38, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(EXPANDED_W, EXPANDED_H)
    }):Play()
end

function Island:Collapse()
    if not self.Expanded then return end
    self.Expanded = false
    local tw = TweenService:Create(panel, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
        Size = UDim2.fromOffset(EXPANDED_W, 10)
    })
    tw.Completed:Connect(function() if not self.Expanded then panel.Visible = false end end)
    tw:Play()
end

function Island:Toggle()
    if self.Expanded then self:Collapse() else self:Expand() end
end

function Island:AddTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamMedium
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(220, 222, 230)
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 57
    btn.Parent = tabScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local tab = {name = name, btn = btn, items = {}}
    table.insert(self.Tabs, tab)
    btn.MouseButton1Click:Connect(function() self:SelectTab(tab) end)
    return tab
end

function Island:SelectTab(tab)
    for _, t in ipairs(self.Tabs) do
        t.btn.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
        t.btn.BackgroundTransparency = 0.3
    end
    tab.btn.BackgroundColor3 = Color3.fromRGB(90, 130, 200)
    tab.btn.BackgroundTransparency = 0
    self.CurrentTab = tab
    self:RenderTab(tab)
end

function Island:RenderTab(tab)
    for _, c in ipairs(contentScroll:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end
    end
    for _, item in ipairs(tab.items) do
        if item.type == "label" then
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 28)
            row.BackgroundColor3 = Color3.fromRGB(40, 43, 52)
            row.BackgroundTransparency = 0.25
            row.BorderSizePixel = 0
            row.ZIndex = 57
            row.Parent = contentScroll
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.Size = UDim2.new(0.6, 0, 1, 0)
            lbl.Font = Enum.Font.GothamMedium
            lbl.Text = item.name
            lbl.TextColor3 = Color3.fromRGB(230, 232, 240)
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 58
            lbl.Parent = row
            local val = Instance.new("TextLabel")
            val.AnchorPoint = Vector2.new(1, 0.5)
            val.Position = UDim2.new(1, -10, 0.5, 0)
            val.Size = UDim2.new(0.4, 0, 1, 0)
            val.BackgroundTransparency = 1
            val.Font = Enum.Font.GothamMedium
            val.Text = tostring(item.text or "")
            val.TextColor3 = Color3.fromRGB(160, 200, 255)
            val.TextSize = 11
            val.TextXAlignment = Enum.TextXAlignment.Right
            val.ZIndex = 58
            val.Parent = row
        elseif item.type == "button" then
            local row = Instance.new("TextButton")
            row.Size = UDim2.new(1, 0, 0, 28)
            row.BackgroundColor3 = Color3.fromRGB(40, 43, 52)
            row.BackgroundTransparency = 0.25
            row.BorderSizePixel = 0
            row.Font = Enum.Font.GothamMedium
            row.Text = "  " .. item.name
            row.TextColor3 = Color3.fromRGB(230, 232, 240)
            row.TextSize = 11
            row.TextXAlignment = Enum.TextXAlignment.Left
            row.ZIndex = 57
            row.Parent = contentScroll
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
            row.MouseButton1Click:Connect(function() if item.callback then item.callback() end end)
        elseif item.type == "toggle" then
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 28)
            row.BackgroundColor3 = Color3.fromRGB(40, 43, 52)
            row.BackgroundTransparency = 0.25
            row.BorderSizePixel = 0
            row.ZIndex = 57
            row.Parent = contentScroll
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.Size = UDim2.new(1, -60, 1, 0)
            lbl.Font = Enum.Font.GothamMedium
            lbl.Text = item.name
            lbl.TextColor3 = Color3.fromRGB(230, 232, 240)
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 58
            lbl.Parent = row
            local track = Instance.new("Frame")
            track.AnchorPoint = Vector2.new(1, 0.5)
            track.Position = UDim2.new(1, -10, 0.5, 0)
            track.Size = UDim2.new(0, 32, 0, 18)
            track.BackgroundColor3 = item.value and Color3.fromRGB(90, 130, 200) or Color3.fromRGB(55, 58, 68)
            track.BorderSizePixel = 0
            track.ZIndex = 58
            track.Parent = row
            Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
            local knob = Instance.new("Frame")
            knob.AnchorPoint = Vector2.new(0, 0.5)
            knob.Position = item.value and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            knob.Size = UDim2.new(0, 14, 0, 14)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.BorderSizePixel = 0
            knob.ZIndex = 59
            knob.Parent = track
            Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
            local state = item.value or false
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.ZIndex = 60
            btn.Parent = row
            btn.MouseButton1Click:Connect(function()
                state = not state
                item.value = state
                TweenService:Create(track, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {BackgroundColor3 = state and Color3.fromRGB(90, 130, 200) or Color3.fromRGB(55, 58, 68)}):Play()
                TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}):Play()
                if item.callback then item.callback(state) end
            end)
        elseif item.type == "input" then
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 30)
            row.BackgroundColor3 = Color3.fromRGB(40, 43, 52)
            row.BackgroundTransparency = 0.25
            row.BorderSizePixel = 0
            row.ZIndex = 57
            row.Parent = contentScroll
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, -20, 1, -6)
            box.Position = UDim2.new(0, 10, 0, 3)
            box.BackgroundTransparency = 1
            box.Font = Enum.Font.GothamMedium
            box.Text = tostring(item.value or "")
            box.PlaceholderText = item.name
            box.PlaceholderColor3 = Color3.fromRGB(150, 152, 162)
            box.TextColor3 = Color3.fromRGB(230, 232, 240)
            box.TextSize = 11
            box.TextXAlignment = Enum.TextXAlignment.Left
            box.ClearTextOnFocus = false
            box.ZIndex = 58
            box.Parent = row
            box.FocusLost:Connect(function() if item.callback then item.callback(box.Text) end end)
        end
    end
end

function Island:AddLabel(name, text)
    local tab = self.CurrentTab
    if not tab then return end
    table.insert(tab.items, {type = "label", name = name, text = text})
    self:RenderTab(tab)
end

function Island:AddButton(name, cb)
    local tab = self.CurrentTab
    if not tab then return end
    table.insert(tab.items, {type = "button", name = name, callback = cb})
    self:RenderTab(tab)
end

function Island:AddToggle(name, default, cb)
    local tab = self.CurrentTab
    if not tab then return end
    table.insert(tab.items, {type = "toggle", name = name, value = default or false, callback = cb})
    self:RenderTab(tab)
end

function Island:AddInput(name, default, cb)
    local tab = self.CurrentTab
    if not tab then return end
    table.insert(tab.items, {type = "input", name = name, value = default or "", callback = cb})
    self:RenderTab(tab)
end

function Island:Notify(title, msg, duration)
    duration = duration or 2.5
    local pt, pf, pp = titleLabel.Text, fpsLabel.Text, pingLabel.Text
    titleLabel.Text = title or "通知"
    fpsLabel.Text = tostring(msg or "")
    pingLabel.Text = ""
    task.delay(duration, function()
        titleLabel.Text = pt
        fpsLabel.Text = pf
        pingLabel.Text = pp
    end)
end

function Island:SetBackgroundGradient(c1, c2, rotation)
    island.BackgroundColor3 = c1
    panel.BackgroundColor3 = c1
    bgGradient.Color = ColorSequence.new(c1, c2)
    panelGradient.Color = ColorSequence.new(c1, c2)
    saveCfg({
        c1 = {math.floor(c1.R * 255), math.floor(c1.G * 255), math.floor(c1.B * 255)},
        c2 = {math.floor(c2.R * 255), math.floor(c2.G * 255), math.floor(c2.B * 255)},
    })
end

local clickT = 0
compact.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        clickT = tick()
    end
end)
compact.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if (tick() - clickT) < 0.4 then Island:Toggle() end
    end
end)
closeBtn.MouseButton1Click:Connect(function() Island:Collapse() end)

task.spawn(function()
    while island.Parent do
        local fps = math.floor(Workspace:GetRealPhysicsFPS())
        local ping = 0
        pcall(function()
            local s = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
            ping = math.floor(tonumber(s:match("%d+")) or 0)
        end)
        fpsLabel.Text = "FPS: " .. tostring(fps)
        pingLabel.Text = "Ping: " .. tostring(ping)
        task.wait(0.5)
    end
end)

getgenv().DynamicIsland = Island

local devv, Signal, GUID, FireServer, InvokeServer, v3item, inventory, melee
pcall(function()
    devv = require(ReplicatedStorage:WaitForChild("devv", 5))
    Signal = devv.load("Signal")
    GUID = devv.load("GUID")
    FireServer = Signal.FireServer
    InvokeServer = Signal.InvokeServer
    v3item = devv.load("v3item")
    inventory = v3item.inventory
    melee = devv.load("ClientReplicator")
end)

_G.HealthThreshold = 0
_G.BladeAuraEnabled = false
local AutoArmor = false
local autokz = false
local healThread = nil
local AutoKnockReset = false
local antiKBEnabled = false
local AutoAntiVoid = false
local sudu = nil
local Speed = 1
local jumpConn = nil
local skinvoid = false
local autoskin = false
local skinsec = ""
local autobank = false
local bankThread = nil
local fovConnection = nil
local DrawingCache = {}
local nametagEnabled = false

local function ClearDrawings()
    for _, draw in pairs(DrawingCache) do pcall(function() draw:Remove() end) end
    DrawingCache = {}
end

local function GetPlayerCash(plr)
    local stats = plr:FindFirstChild("stats")
    if not stats then return nil end
    local money = stats:FindFirstChild("Money")
    return money and money.Value or nil
end

getgenv().TrailColors = {
    StartColor = Color3.fromRGB(0, 255, 255),
    MiddleColor1 = Color3.fromRGB(173, 216, 230),
    MiddleColor2 = Color3.fromRGB(255, 255, 255),
    EndColor = Color3.fromRGB(30, 144, 255)
}
getgenv().AuraConfig = { SelectedTarget = "all", LockAttack = false, ShieldCheck = true }

local function robloxNotify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = duration or 3})
    end)
end

local function hasShieldProtection(player)
    if not player or not player.Character then return false end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    for _, desc in pairs(player.Character:GetDescendants()) do
        if desc:IsA("ForceField") or desc.Name:lower():find("shield") then return true end
    end
    return false
end

local function getFilteredTargets()
    local targets = {}
    local validPlayers = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            if not getgenv().AuraConfig.ShieldCheck or not hasShieldProtection(p) then
                table.insert(validPlayers, p)
            end
        end
    end
    if getgenv().AuraConfig.LockAttack and getgenv().AuraConfig.SelectedTarget ~= "all" then
        for _, p in ipairs(validPlayers) do
            if p.Name == getgenv().AuraConfig.SelectedTarget then
                table.insert(targets, p)
                break
            end
        end
    else
        targets = validPlayers
    end
    return targets
end

local function generatePlayerList()
    local list = {"all"}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p.Name) end
    end
    return list
end

local function createBeautifulTrail(origin, targetPos)
    local trailContainer = Instance.new("Folder")
    trailContainer.Name = "MagicTrail"
    trailContainer.Parent = Workspace
    local midPoint = (origin + targetPos) / 2
    local direction = (targetPos - origin).Unit
    local perpendicular = Vector3.new(-direction.Z, direction.Y, direction.X) * 3
    local controlPoint = midPoint + perpendicular + Vector3.new(0, math.random(-3, 3), 0)
    local function bezier(p0, p1, p2, t) return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 end
    local curvePoints = {}
    for i = 0, 20 do
        local t = i / 20
        table.insert(curvePoints, bezier(origin, controlPoint, targetPos, t))
    end
    for i = 1, #curvePoints - 1 do
        local p1, p2 = curvePoints[i], curvePoints[i + 1]
        local distance = (p2 - p1).Magnitude
        local beamPart = Instance.new("Part")
        beamPart.Size = Vector3.new(0.15, 0.15, distance)
        beamPart.Anchored = true
        beamPart.CanCollide = false
        beamPart.Material = Enum.Material.Neon
        beamPart.Transparency = 0.3
        beamPart.CFrame = CFrame.new(p1, p2) * CFrame.new(0, 0, -distance / 2)
        beamPart.Parent = trailContainer
        local t = i / (#curvePoints - 1)
        local color
        if t < 0.3 then color = getgenv().TrailColors.StartColor
        elseif t < 0.6 then color = getgenv().TrailColors.MiddleColor1
        elseif t < 0.9 then color = getgenv().TrailColors.MiddleColor2
        else color = getgenv().TrailColors.EndColor end
        beamPart.Color = color
        local pl = Instance.new("PointLight", beamPart)
        pl.Brightness = 5
        pl.Range = 3
        pl.Color = color
        local pt = Instance.new("ParticleEmitter", beamPart)
        pt.Size = NumberSequence.new(0.1, 0.3)
        pt.Transparency = NumberSequence.new(0.3, 0.8)
        pt.Lifetime = NumberRange.new(0.5, 1)
        pt.Rate = 50
        pt.Speed = NumberRange.new(1, 2)
        pt.VelocitySpread = 180
        pt.Color = ColorSequence.new(color)
    end
    task.delay(1.5, function() if trailContainer and trailContainer.Parent then trailContainer:Destroy() end end)
end

local lp = LocalPlayer
local dartOn = false
local dartCachedHitId = nil
local dartCurrentTarget = nil
local dartHeartConnections = {}
local dartNinjaStarBuyThread = nil
local targetSelector = nil
local teleportLoopConn = nil
local teleportEnabled = false

local function dartCleanupConnections()
    for _, conn in ipairs(dartHeartConnections) do if conn then conn:Disconnect() end end
    dartHeartConnections = {}
    if teleportLoopConn then teleportLoopConn:Disconnect() teleportLoopConn = nil end
end

local function dartEquipNinjaStar()
    if not inventory then return nil end
    local itm = inventory.getItems and inventory.getItems() or inventory.items or {}
    for _, v in next, itm do
        if v.name == "Ninja Star" then
            Signal.FireServer("equip", v.guid)
            return v.guid
        end
    end
    return nil
end

local function dartInitThrow()
    local sg = dartEquipNinjaStar()
    if not sg then return end
    local c = lp.Character
    if not c then return end
    local rh = c:FindFirstChild("RightHand")
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not rh or not hrp then return end
    local mp = rh.Position + Vector3.new(0, 0.5, 0)
    local tp = mp + Vector3.new(50, 0, 0)
    local vel = (tp - mp).Unit * 150
    createBeautifulTrail(mp, tp)
    local ok2, r1, hid = pcall(function() return Signal.InvokeServer("throwSticky", GUID(), "Ninja Star", sg, vel, tp) end)
    if ok2 and r1 and hid then dartCachedHitId = hid end
end

local function dartFindValidTarget()
    local targets = getFilteredTargets()
    if #targets == 0 then return nil end
    local closest, minDist = nil, math.huge
    local myPos = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character.HumanoidRootPart.Position
    if not myPos then return nil end
    for _, player in ipairs(targets) do
        local char = player.Character
        local head = char:FindFirstChild("Head")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if head and hrp then
            local dist = (hrp.Position - myPos).Magnitude
            if dist < minDist and dist <= 50 then minDist = dist closest = {player = player, head = head} end
        end
    end
    return closest
end

local function dartRapidThrowAttack()
    if not dartOn or not dartCachedHitId then return end
    local targetData = dartFindValidTarget()
    if not targetData then return end
    local head = targetData.head
    local tp = head.Position
    local wcf = CFrame.new(tp, tp + Vector3.new(0, 1, 0))
    local rcf = CFrame.new(0, 0, 0)
    local c = lp.Character
    if c and c:FindFirstChild("RightHand") then createBeautifulTrail(c.RightHand.Position, tp) end
    for i = 1, 15 do Signal.InvokeServer("hitSticky", dartCachedHitId, head, rcf, wcf) end
end

local function getRandomValidTarget()
    local validTargets = getFilteredTargets()
    if #validTargets == 0 then return nil end
    return validTargets[math.random(1, #validTargets)]
end

local function dartFastTeleport()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hrp then robloxNotify("传送失败", "自身角色未加载", 3) return end
    local validTargets = getFilteredTargets()
    if #validTargets == 0 then robloxNotify("传送失败", "无有效传送目标", 3) dartCurrentTarget = nil return end
    if getgenv().AuraConfig.SelectedTarget ~= "all" then
        dartCurrentTarget = nil
        for _, p in ipairs(validTargets) do
            if p.Name == getgenv().AuraConfig.SelectedTarget then dartCurrentTarget = p break end
        end
        if not dartCurrentTarget then dartCurrentTarget = getRandomValidTarget() end
    else
        if not dartCurrentTarget or hasShieldProtection(dartCurrentTarget) or not dartCurrentTarget.Character or not dartCurrentTarget.Character:FindFirstChild("HumanoidRootPart") or dartCurrentTarget.Character.Humanoid.Health <= 0 then
            dartCurrentTarget = getRandomValidTarget()
        end
    end
    if not dartCurrentTarget then return end
    local targetChar = dartCurrentTarget.Character
    if not targetChar then dartCurrentTarget = nil return end
    local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHrp then dartCurrentTarget = nil return end
    local targetHum = targetChar:FindFirstChild("Humanoid")
    if not targetHum or targetHum.Health <= 0 then dartCurrentTarget = nil return end
    if getgenv().AuraConfig.ShieldCheck and hasShieldProtection(dartCurrentTarget) then dartCurrentTarget = getRandomValidTarget() return end
    hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 1.5)
end

local function startTeleportLoop()
    if teleportLoopConn then teleportLoopConn:Disconnect() end
    teleportLoopConn = RunService.Heartbeat:Connect(function()
        if teleportEnabled and dartOn then dartFastTeleport() task.wait(0.3) end
    end)
end

local tabKill = Island:AddTab("杀戮")
Island:SelectTab(tabKill)
Island:AddToggle("锁定攻击", false, function(v) getgenv().AuraConfig.LockAttack = v dartCurrentTarget = nil end)
Island:AddToggle("护盾检测", true, function(v) getgenv().AuraConfig.ShieldCheck = v dartCurrentTarget = nil end)
Island:AddToggle("自动持续传送", false, function(v)
    teleportEnabled = v
    dartCurrentTarget = nil
    if v and dartOn then startTeleportLoop()
    else if teleportLoopConn then teleportLoopConn:Disconnect() teleportLoopConn = nil end end
end)
Island:AddToggle("忍者飞镖光环", false, function(state)
    dartOn = state
    dartCleanupConnections()
    if state then
        dartEquipNinjaStar()
        task.wait(0.1)
        dartInitThrow()
        local conn = RunService.RenderStepped:Connect(function() if not dartOn then return end dartRapidThrowAttack() end)
        table.insert(dartHeartConnections, conn)
        if teleportEnabled then startTeleportLoop() end
    end
end)
Island:AddToggle("自动购买飞镖", false, function(state)
    if dartNinjaStarBuyThread then dartNinjaStarBuyThread:Disconnect() dartNinjaStarBuyThread = nil end
    if state then
        dartNinjaStarBuyThread = RunService.Heartbeat:Connect(function() Signal.InvokeServer("attemptPurchase", "Ninja Star") end)
    end
end)
Island:AddToggle("香蕉皮光环", false, function(state) _G.AuraEnabled = state if not state then _G.TargetId = nil end end)
Island:AddToggle("战斧", false, function(state) _G.BladeAuraEnabled = state end)

local lastAttack, lastAmmo = 0, 0
local function getTarget()
    local targets = getFilteredTargets()
    if #targets == 0 then return nil end
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local target, dist = nil, 150
    for _, plr in ipairs(targets) do
        local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
        local tHum = plr.Character:FindFirstChildOfClass("Humanoid")
        if tRoot and tHum and tHum.Health >= (_G.HealthThreshold or 0) then
            local d = (root.Position - tRoot.Position).Magnitude
            if d < dist then dist = d target = plr end
        end
    end
    return target
end

local function hackthrow(plr, itemname, itemguid, velocity, epos)
    if plr ~= lp then return end
    task.spawn(function()
        local throwGuid = GUID()
        local char = plr.Character
        if char and char:FindFirstChild("RightHand") then createBeautifulTrail(char.RightHand.Position, epos) end
        local success, stickyId = InvokeServer("throwSticky", throwGuid, itemname, itemguid, velocity, epos)
        if not success then return end
        local dummyPart = Instance.new("Part")
        dummyPart.Size = Vector3.new(2, 2, 2)
        dummyPart.Position = epos
        dummyPart.Anchored = true
        dummyPart.Transparency = 1
        dummyPart.CanCollide = true
        dummyPart.Parent = Workspace
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        rayParams.FilterDescendantsInstances = {plr.Character, Workspace.Game.Local, Workspace.Game.Drones}
        local dist = (epos - plr.Character.Head.Position).Magnitude
        local rayResult = Workspace:Raycast(plr.Character.Head.Position, (epos - plr.Character.Head.Position).Unit * (dist + 5), rayParams)
        if rayResult and rayResult.Instance then
            local hitPart = rayResult.Instance
            local relativeHitCFrame = hitPart.CFrame:ToObjectSpace(CFrame.new(rayResult.Position, rayResult.Position + rayResult.Normal))
            local stickyCFrame = CFrame.new(rayResult.Position)
            if dummyPart.Parent then dummyPart:Destroy() end
            _G.throwargs = {"hitSticky", stickyId or throwGuid, hitPart, relativeHitCFrame, stickyCFrame}
            InvokeServer("hitSticky", stickyId or throwGuid, hitPart, relativeHitCFrame, stickyCFrame)
        else
            if dummyPart.Parent then dummyPart:Destroy() end
        end
    end)
end

local function finditem(str)
    if not inventory then return nil end
    for _, data in next, (inventory.items or {}) do
        if data.name == str or data.type == str or data.subtype == str then return data end
    end
end

local function executebladekill(plr, head)
    local item = finditem("Tomahawk")
    if item then
        FireServer("equip", item.guid)
        if not _G.throwargs then
            local char = lp.Character
            if not char then return end
            local hand = char:FindFirstChild("RightHand")
            if not hand then return end
            local spos = hand.Position
            local epos = head.Position
            local velocity = (epos - spos).Unit * ((spos - epos).Magnitude * 15)
            createBeautifulTrail(spos, epos)
            task.spawn(InvokeServer, "attemptPurchaseAmmo", "Tomahawk")
            hackthrow(lp, "Tomahawk", item.guid, velocity, epos)
        end
        if _G.throwargs then _G.throwargs[3] = head task.spawn(InvokeServer, unpack(_G.throwargs)) end
    else
        task.spawn(InvokeServer, "attemptPurchase", "Tomahawk")
    end
end

local function attack(plr)
    local now = tick()
    if now - lastAttack < 0.03 then return end
    lastAttack = now
    local tChar = plr.Character
    local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
    local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
    if not tRoot or not tHum or tHum.Health < 15 then return end
    task.spawn(function()
        local items = inventory and inventory.items or {}
        local banana = nil
        for _, v in next, items do if v.name == "Banana Peel" then banana = v break end end
        if not banana then pcall(function() InvokeServer("attemptPurchase", "Banana Peel") end) return end
        FireServer("equip", banana.guid)
        local pred = tRoot.AssemblyLinearVelocity * 0.2
        local cf = tRoot.CFrame * CFrame.new(0, -1, 0) + pred
        local rcf = tRoot.CFrame:ToObjectSpace(cf)
        local char = lp.Character
        if char and char:FindFirstChild("RightHand") then createBeautifulTrail(char.RightHand.Position, cf.Position) end
        if not _G.TargetId then
            local ok2, _, id = pcall(function() return InvokeServer("throwSticky", GUID(), "Banana Peel", banana.guid, Vector3.new(0, 100, 0), cf.Position) end)
            if ok2 and id then _G.TargetId = id end
        end
        if _G.TargetId then pcall(function() InvokeServer("hitSticky", _G.TargetId, tRoot, rcf, cf) end) end
    end)
end

RunService.Heartbeat:Connect(function()
    if _G.AuraEnabled then
        local target = getTarget()
        if target then attack(target) end
        if tick() - lastAmmo > 0.5 then
            lastAmmo = tick()
            task.spawn(function() pcall(function() InvokeServer("attemptPurchaseAmmo", "Banana Peel") end) end)
        end
    end
    if _G.BladeAuraEnabled then
        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local target = getTarget()
        if target then
            local tChar = target.Character
            local hum = tChar and tChar:FindFirstChildOfClass("Humanoid")
            local head = tChar and tChar:FindFirstChild("Head")
            if head and hum and hum.Health > 0 then
                local dist = (hrp.Position - head.Position).Magnitude
                if dist < 190 then executebladekill(target, head) end
            end
        end
    end
end)

local tabMoney = Island:AddTab("刷钱")
Island:SelectTab(tabMoney)

local function findAllBankCash()
    local cash = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if string.find(string.lower(obj.Name), "bankcash") then
            if obj:IsA("Model") then
                local primaryPart = obj.PrimaryPart
                if not primaryPart then
                    for _, desc in ipairs(obj:GetDescendants()) do if desc:IsA("BasePart") then primaryPart = desc break end end
                end
                if primaryPart then table.insert(cash, primaryPart) end
            elseif obj:IsA("BasePart") then table.insert(cash, obj) end
        end
    end
    return cash
end

local function pressE()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)
    pcall(function()
        UserInputService:SetFocusedTextBox(nil)
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.None)
    end)
end

local function bankLoop(teleportMode)
    while autobank do
        local character = LocalPlayer.Character
        if not character then task.wait(0.1) continue end
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then task.wait(0.1) continue end
        local cashList = findAllBankCash()
        if #cashList == 0 then
            if teleportMode then root.CFrame = CFrame.new(1156.01, -40.29, 192.84) end
            task.wait(5)
            continue
        end
        local nearest, nearestDist = nil, math.huge
        for _, cash in ipairs(cashList) do
            local dist = (cash.Position - root.Position).Magnitude
            if dist < nearestDist then nearestDist = dist nearest = cash end
        end
        if nearest then
            root.CFrame = nearest.CFrame * CFrame.new(0, 3, 0)
            task.wait(0.3)
            for i = 1, 10 do pressE() end
            task.wait(0.01)
        end
        task.wait(0.01)
    end
end

local function startBankLoop(tp)
    if bankThread then return end
    bankThread = task.spawn(function() bankLoop(tp) bankThread = nil end)
end

local function stopBankLoop()
    if bankThread then task.cancel(bankThread) bankThread = nil end
end

Island:AddToggle("自动银行", false, function(v) autobank = v if v then startBankLoop(false) else stopBankLoop() end end)
Island:AddToggle("挂机银行", false, function(v) autobank = v if v then startBankLoop(true) else stopBankLoop() end end)

Island:AddToggle("自动制作劳力士并领取", false, function(v)
    getgenv().AutoCraftClaimGem = v
    if not v then return end
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not getgenv().AutoCraftClaimGem then conn:Disconnect() return end
        pcall(function()
            Signal.InvokeServer("beginCraft", 'RollieCraft')
            Signal.InvokeServer("claimCraft", 'RollieCraft')
        end)
    end)
end)

Island:AddToggle("自动开启幸运方块", false, function(v)
    getgenv().AutoOpenLuckyBlock = v
    if not v then return end
    task.spawn(function()
        local list = {"Green Lucky Block", "Orange Lucky Block", "Purple Lucky Block"}
        while getgenv().AutoOpenLuckyBlock do
            for _, item in next, v3item.inventory.items do
                if table.find(list, item.name) then
                    local useid = item.guid
                    pcall(function()
                        Signal.FireServer("equip", useid)
                        task.wait(0.1)
                        Signal.FireServer("useConsumable", useid)
                        task.wait(0.1)
                        Signal.FireServer("removeItem", useid)
                    end)
                    break
                end
            end
            task.wait(0.05)
        end
    end)
end)

Island:AddToggle("自动空投", false, function(v)
    getgenv().AutoPickAirdropMain = v
    if not v then return end
    task.spawn(function()
        while getgenv().AutoPickAirdropMain do
            local character = LocalPlayer.Character
            if character then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local originalPosition = rootPart.CFrame
                    local airdrops = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Airdrops") and Workspace.Game.Airdrops:GetChildren() or {}
                    for _, airdrop in pairs(airdrops) do
                        if airdrop:FindFirstChild('Airdrop') and airdrop.Airdrop:FindFirstChild("ProximityPrompt") then
                            local prompt = airdrop.Airdrop.ProximityPrompt
                            prompt.RequiresLineOfSight = false
                            prompt.HoldDuration = 0
                            rootPart.CFrame = airdrop.Airdrop.CFrame
                            task.wait(0.1)
                            for i = 1, 15 do
                                if fireproximityprompt then fireproximityprompt(prompt) else firesignal(prompt.Triggered) end
                                task.wait(0.02)
                            end
                            task.wait(0.3)
                            rootPart.CFrame = originalPosition
                            break
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

Island:AddToggle("自动租房", false, function(v)
    getgenv().AutoRentHouse = v
    if not v then return end
    task.spawn(function()
        local last = tick()
        while getgenv().AutoRentHouse do
            if tick() - last >= 2 then
                pcall(function()
                    for _, h in pairs(Workspace.HousingPlots:GetChildren()) do
                        if not h:GetAttribute("Owner") then Signal.InvokeServer("rentHouse", h) end
                    end
                end)
                last = tick()
            end
            task.wait(0.1)
        end
    end)
end)

Island:AddToggle("自动售卖全部物品", false, function(v)
    getgenv().AutoSellAll = v
    if not v then return end
    task.spawn(function()
        local last = tick()
        while getgenv().AutoSellAll do
            if tick() - last >= 1 then
                pcall(function()
                    for _, item in next, v3item.inventory.items do
                        Signal.FireServer("equip", item.guid)
                        Signal.FireServer("sellItem", item.guid)
                    end
                end)
                last = tick()
            end
            task.wait(0.1)
        end
    end)
end)

Island:AddToggle("自动开启材料盒", false, function(v)
    getgenv().AutoOpenMaterialBox = v
    if not v then return end
    task.spawn(function()
        local list = {"Electronics", "Weapon Parts"}
        while getgenv().AutoOpenMaterialBox do
            for _, item in next, v3item.inventory.items do
                if table.find(list, item.name) then
                    local useid = item.guid
                    pcall(function()
                        Signal.FireServer("equip", useid)
                        task.wait(0.1)
                        Signal.FireServer("useConsumable", useid)
                        task.wait(0.1)
                        Signal.FireServer("removeItem", useid)
                    end)
                    break
                end
            end
            task.wait(0.5)
        end
    end)
end)

local function bindAutoPick(title, items, key)
    Island:AddToggle(title, false, function(state)
        getgenv()[key] = state
        if not state then return end
        task.spawn(function()
            while getgenv()[key] do
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root or not root:IsDescendantOf(game) then
                    char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    root = char:WaitForChild("HumanoidRootPart")
                end
                local gameFolder = Workspace:FindFirstChild("Game")
                local entities = gameFolder and gameFolder:FindFirstChild("Entities")
                local pickup = entities and entities:FindFirstChild("ItemPickup")
                if pickup and root then
                    for _, box in pairs(pickup:GetChildren()) do
                        for _, v in pairs(box:GetChildren()) do
                            if v:IsA("MeshPart") or v:IsA("Part") then
                                local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                                if prompt and table.find(items, prompt.ObjectText) then
                                    root.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                                    prompt.RequiresLineOfSight = false
                                    prompt.HoldDuration = 0
                                    task.wait(0.05)
                                    if fireproximityprompt then fireproximityprompt(prompt) else firesignal(prompt.Triggered) end
                                end
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end)
end

bindAutoPick("自动捡稀有物品", {
    "Heart Crossbow","Void Gem","Diamond","Nuclear Missile Launcher","NextBot Grenade","Rollie","Gold Crown","Dark Matter Gem","Diamond Glock","Diamond Banana Peel","Spirit Kunai","Kunai","Purple Lucky Block","Snowflake Balloon","Suitcase Nuke","Nuke Launcher","Easter Basket","Gold Cup","Pearl Necklace","Treasure Map","Spectral Scythe","Bunny Balloon","Ghost Balloon","Clover Balloon","Bat Balloon","Gold Clover Balloon","Golden Rose","Black Rose","Heart Balloon","Skull Balloon","Money Printer"
}, "AutoPickEnabled")
bindAutoPick("自动捡印钞机", {"Money Printer","Daily Printer"}, "AutoPickPrinter")
bindAutoPick("自动捡载具钥匙", {"Helicopter Key","Mustang Key"}, "AutoPickKey")
bindAutoPick("自动捡稀有枪械", {"Diamond Glock","Gold AK-47","Golden Dragon"}, "AutoPickGun")
bindAutoPick("自动捡稀有宝石", {"Void Gem","Diamond","Diamond Ring","Gold Crown","Dark Matter Gem","Gold Cup","Rollie"}, "AutoPickRare")
bindAutoPick("自动捡材料", {"Electronics","Weapon Parts"}, "AutoPickMaterial")
bindAutoPick("自动捡糖果棒", {"Candy Cane","Blue Candy Cane"}, "AutoPickCandy")
bindAutoPick("自动捡幸运方块", {"Green Lucky Block","Orange Lucky Block","Purple Lucky Block"}, "AutoPickLuckyBlock")
bindAutoPick("自动捡核弹", {"Nuclear Missile Launcher","NextBot Grenade","Suitcase Nuke","Nuke Launcher"}, "AutoPickNuke")
bindAutoPick("自动捡气球", {"Snowflake Balloon","Bunny Balloon","Ghost Balloon","Clover Balloon","Bat Balloon","Gold Clover Balloon","Heart Balloon","Skull Balloon","Golden Rose","Black Rose","Spirit Kunai","Kunai"}, "AutoPickBalloon")
bindAutoPick("自动捡蓝卡", {"Police Armory Keycard"}, "AutoPoliceKey")
bindAutoPick("自动捡红卡", {"Military Armory Keycard"}, "AutoMilitaryKey")

Island:AddToggle("自动保险箱", false, function(state)
    local enabled = state
    if state then
        task.spawn(function()
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart")
            local originalPosition = hrp.CFrame
            local equippedItem = v3item.inventory.getEquippedItem()
            local originalEquipped = equippedItem and equippedItem.guid
            while enabled do
                character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                hrp = character:WaitForChild("HumanoidRootPart")
                Signal.InvokeServer("attemptPurchase", "Lockpick")
                task.wait(0.2)
                local allSafes = {}
                for _, t in ipairs({"LargeSafe","MediumSafe","SmallSafe","JewelSafe","GoldJewelSafe"}) do
                    local folder = Workspace.Game.Entities:FindFirstChild(t)
                    if folder then for _, s in pairs(folder:GetChildren()) do table.insert(allSafes, s) end end
                end
                for _, safe in pairs(allSafes) do
                    if not enabled then break end
                    local prompt = safe:FindFirstChild("ProximityPrompt", true)
                    if prompt and prompt.Enabled then
                        local pos = safe.PrimaryPart and safe.PrimaryPart.Position or safe.WorldPivot.Position
                        hrp.CFrame = CFrame.new(pos)
                        task.wait(0.3)
                        fireproximityprompt(prompt)
                        task.wait(1)
                    end
                end
                task.wait(1)
            end
            if originalPosition then hrp.CFrame = originalPosition end
            if originalEquipped then Signal.FireServer("equip", originalEquipped) end
        end)
    end
end)

Island:AddToggle("开锁光环", false, function(state)
    if not state then return end
    task.spawn(function()
        while true do
            Signal.InvokeServer("attemptPurchase", "Lockpick")
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, t in ipairs({"LargeSafe","MediumSafe","SmallSafe","JewelSafe","GoldJewelSafe"}) do
                    local folder = Workspace.Game.Entities:FindFirstChild(t)
                    if folder then
                        for _, safe in pairs(folder:GetChildren()) do
                            local p = safe:FindFirstChild("ProximityPrompt", true)
                            if p and (hrp.Position - safe.WorldPivot.Position).magnitude <= 45 then
                                fireproximityprompt(p)
                            end
                        end
                    end
                end
            end
            task.wait(0.2)
        end
    end)
end)

Island:AddToggle("现金光环", false, function(state)
    if not state then return end
    task.spawn(function()
        while true do
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, cash in pairs(Workspace.Game.Entities.CashBundle:GetChildren()) do
                    local part = cash:FindFirstChildOfClass("Part")
                    if part and (hrp.Position - part.Position).magnitude <= 30 then
                        local cd = cash:FindFirstChildOfClass("ClickDetector")
                        if cd then fireclickdetector(cd) end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

local tabBypass = Island:AddTab("绕过")
Island:SelectTab(tabBypass)
Island:AddButton("绕过移动经销商", function()
    local pjyd
    pjyd = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        if getnamecallmethod() == "InvokeServer" and args[2] == true then
            args[2] = false
            return pjyd(self, unpack(args))
        end
        return pjyd(self, ...)
    end)
    LocalPlayer:SetAttribute("mobileDealer", true)
    local md = require(ReplicatedStorage.devv.shared.Indicies.mobileDealer)
    for _, items in pairs(md) do for _, item in ipairs(items) do item.stock = 999999 end end
end)
Island:AddButton("绕过高级动作", function()
    for _, v in pairs(LocalPlayer.PlayerGui.Emotes.Frame.ScrollingFrame:GetDescendants()) do
        if v.Name == "Locked" then v.Visible = false end
    end
end)
Island:AddButton("绕过飞行封禁", function()
    local d = ReplicatedStorage:FindFirstChild("devv")
    if d then local r = d:FindFirstChild("remoteStorage") if r and r:FindFirstChild("makeExplosion") then r.makeExplosion:Destroy() end end
end)
Island:AddButton("绕过战斗状态", function()
    for _, func in pairs(getgc(true)) do
        if type(func) == "function" then
            local info = debug.getinfo(func)
            if info.name == "isInCombat" or (info.source and info.source:find("combatIndicator")) then
                hookfunction(func, function() return false end)
            end
        end
    end
end)

local tabPlayer = Island:AddTab("人物")
Island:SelectTab(tabPlayer)
Island:AddToggle("移速修改", false, function(v)
    if v then
        sudu = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Parent then
                if char.Humanoid.MoveDirection.Magnitude > 0 then
                    char:TranslateBy(char.Humanoid.MoveDirection * Speed / 10)
                end
            end
        end)
    elseif sudu then sudu:Disconnect() sudu = nil end
end)
Island:AddToggle("扩大视野", false, function(v)
    if v then
        fovConnection = RunService.Heartbeat:Connect(function() Workspace.CurrentCamera.FieldOfView = 120 end)
    elseif fovConnection then fovConnection:Disconnect() fovConnection = nil end
end)
Island:AddButton("修改9个物品栏", function()
    pcall(function()
        local xtalHub = require(ReplicatedStorage.devv.client.Objects.v3item)
        xtalHub.inventory.numSlots = 9
    end)
end)
Island:AddButton("全枪无限子弹", function()
    local function setAmmo()
        for _, item in pairs(v3item.inventory.items) do
            if item and item.ammoManager then
                item.ammoManager:setAmmo(9999)
                item.ammoManager:setAmmoOut(9999)
            end
        end
    end
    setAmmo()
    task.spawn(function() while true do pcall(setAmmo) task.wait(25) end end)
end)
Island:AddButton("全枪射速提升", function()
    local function boost()
        for _, item in pairs(v3item.inventory.items) do
            if item then
                item.fireDebounce = 0.01
                item.reloadTime = 0.1
                if item.ammoManager then item.ammoManager.ammo = 9999 end
            end
        end
    end
    boost()
    task.spawn(function() while true do pcall(boost) task.wait(30) end end)
end)
Island:AddButton("全枪无后坐力", function()
    local function noRecoil()
        for _, item in pairs(v3item.inventory.items) do
            if item then
                item.recoilAdd = 0 item.maxRecoil = 0
                item.recoilDiminishFactor = 0 item.recoilFastDiminishFactor = 0
                item.baseSpread = 0 item.baseAimSpread = 0
                item.spread = 0 item.aimSpread = 0
            end
        end
    end
    noRecoil()
    task.spawn(function() while true do pcall(noRecoil) task.wait(30) end end)
end)
Island:AddToggle("无限跳跃", false, function(v)
    if v then
        jumpConn = UserInputService.JumpRequest:Connect(function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    elseif jumpConn then jumpConn:Disconnect() jumpConn = nil end
end)
Island:AddToggle("快速互动", false, function(v)
    if v then
        game.ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt) prompt.HoldDuration = 0 end)
    end
end)

local tabESP = Island:AddTab("ESP")
Island:SelectTab(tabESP)
Island:AddToggle("玩家金钱透视", false, function(v)
    nametagEnabled = v
    if not v then ClearDrawings() end
end)
RunService.RenderStepped:Connect(function()
    if not nametagEnabled then return end
    ClearDrawings()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not plr.Character then continue end
        local head = plr.Character:FindFirstChild("Head")
        if not head then continue end
        local cash = GetPlayerCash(plr)
        if cash == nil then continue end
        local pos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
        if not onScreen then continue end
        local text = Drawing.new("Text")
        text.Text = plr.Name .. " | $" .. cash
        text.Position = Vector2.new(pos.X, pos.Y - 30)
        text.Color = Color3.new(1, 1, 0)
        text.Outline = true
        text.Size = 16
        text.Center = true
        text.Visible = true
        table.insert(DrawingCache, text)
    end
end)

local itemESPEnabled = false
Island:AddToggle("物品透视", false, function(v)
    itemESPEnabled = v
    if not v then ClearDrawings() end
end)
RunService.RenderStepped:Connect(function()
    if not itemESPEnabled then return end
    local folder = Workspace:FindFirstChild("Game") and Workspace.Game:FindFirstChild("Entities") and Workspace.Game.Entities:FindFirstChild("ItemPickup")
    if not folder then return end
    for _, obj in pairs(folder:GetChildren()) do
        local part = obj.PrimaryPart or obj:FindFirstChildOfClass("Part")
        if part then
            local name = obj:GetAttribute("itemName") or obj.Name
            local pos = part.Position
            local screen, onScreen = Camera:WorldToViewportPoint(pos)
            if onScreen then
                local text = Drawing.new("Text")
                text.Text = string.format("[%s] %.1f", name, (Camera.CFrame.Position - pos).Magnitude)
                text.Size = 14
                text.Center = true
                text.Color = Color3.new(0, 1, 1)
                text.Outline = true
                text.Position = Vector2.new(screen.X, screen.Y - 20)
                text.Visible = true
                table.insert(DrawingCache, text)
            end
        end
    end
end)

local tabTeTraX = Island:AddTab("TeTraX")
Island:SelectTab(tabTeTraX)

local function bindTeTraX(title, items, key)
    Island:AddToggle(title, false, function(state)
        getgenv()[key] = state
        if not state then return end
        task.spawn(function()
            while getgenv()[key] do
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local root = char:FindFirstChild("HumanoidRootPart")
                local pickup = Workspace.Game and Workspace.Game.Entities and Workspace.Game.Entities:FindFirstChild("ItemPickup")
                if pickup and root then
                    for _, box in pairs(pickup:GetChildren()) do
                        for _, v in pairs(box:GetChildren()) do
                            if v:IsA("MeshPart") or v:IsA("Part") then
                                local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                                if prompt and table.find(items, prompt.ObjectText) then
                                    root.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                                    prompt.RequiresLineOfSight = false
                                    prompt.HoldDuration = 0
                                    task.wait(0.05)
                                    if fireproximityprompt then fireproximityprompt(prompt) else firesignal(prompt.Triggered) end
                                end
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end)
end

bindTeTraX("宝藏物品", {"Treasure Map","Pearl Necklace","Seashell","Purple Seashell","Blue Seashell"}, "AutoPickTreasure")
bindTeTraX("黄金枪械", {"Gold AK-47","Gold Deagle"}, "AutoPickGoldGun")
bindTeTraX("礼物/幸运方块", {"Small Present","Medium Present","Large Present","Gold Lucky Block","Orange Lucky Block","Purple Lucky Block","Green Lucky Block","Red Lucky Block","Blue Lucky Block"}, "AutoPickPresent")
bindTeTraX("稀有宝石", {"Diamond","Diamond Ring","Diamond Ore","Rollie","Dark Matter Gem","Void Gem","Gold Cup","Gold Crown"}, "AutoPickRareGem")
bindTeTraX("蓝卡", {"Police Armory Keycard"}, "AutoPickBlueCard")
bindTeTraX("红卡", {"Military Armory Keycard"}, "AutoPickRedCard")
bindTeTraX("金条", {"Gold Bar"}, "AutoPickGoldBar")
bindTeTraX("车辆钥匙", {"Mustang Key","Cruiser Key","Helicopter Key","Airdrop Marker"}, "AutoPickCarKey")

-- ============================================================
-- 完成
-- ============================================================
print("[xtal] ✅ 动态岛脚本加载完成")
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "xtal",
        Text = "动态岛脚本已加载完成",
        Duration = 5
    })
end)
