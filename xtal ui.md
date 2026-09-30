local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local COLLAPSED_W, COLLAPSED_H = 280, 34
local EXPANDED_W, EXPANDED_H = 500, 320
local TOP_OFFSET = 12
local CONFIG_FILE = "xtal_island_config.json"

local function saveCfg(tbl)
    getgenv().xtalIslandCfg = tbl
    pcall(function()
        if writefile then writefile(CONFIG_FILE, HttpService:JSONEncode(tbl)) end
    end)
end

local function loadCfg()
    if getgenv().xtalIslandCfg then return getgenv().xtalIslandCfg end
    local data
    pcall(function()
        if isfile and readfile and isfile(CONFIG_FILE) then
            data = HttpService:JSONDecode(readfile(CONFIG_FILE))
        end
    end)
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
                TweenService:Create(track, TweenInfo.new(0.2, Enum.EasingStyle.Quart),
                    { BackgroundColor3 = state and Color3.fromRGB(90, 130, 200) or Color3.fromRGB(55, 58, 68) }):Play()
                TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quart),
                    { Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0) }):Play()
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
