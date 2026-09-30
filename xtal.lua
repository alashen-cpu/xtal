local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local COLLAPSED_W, COLLAPSED_H = 280, 34
local EXPANDED_W, EXPANDED_H = 560, 380
local TOP_OFFSET = 12

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
island.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
island.BorderSizePixel = 0
island.ClipsDescendants = true
island.ZIndex = 100
island.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = island

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new(Color3.fromRGB(25, 28, 35), Color3.fromRGB(15, 16, 20))
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
panel.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.Visible = false
panel.ZIndex = 50
panel.Parent = gui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 14)
panelCorner.Parent = panel

local panelGradient = Instance.new("UIGradient")
panelGradient.Color = ColorSequence.new(Color3.fromRGB(25, 28, 35), Color3.fromRGB(15, 16, 20))
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
sidebar.Size = UDim2.new(0, 150, 1, -66)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 27, 34)
sidebar.BackgroundTransparency = 0.35
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 55
sidebar.Parent = panel
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

local tabScroll = Instance.new("ScrollingFrame")
tabScroll.Position = UDim2.new(0, 6, 0, 8)
tabScroll.Size = UDim2.new(1, -12, 1, -14)
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
contentArea.Position = UDim2.new(0, 170, 0, 54)
contentArea.Size = UDim2.new(1, -182, 1, -66)
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
            row.Size = UDim2.new(1, 0, 0, 24)
            row.BackgroundColor3 = Color3.fromRGB(40, 43, 52)
            row.BackgroundTransparency = 0.25
            row.BorderSizePixel = 0
            row.ZIndex = 57
            row.Parent = contentScroll
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.Size = UDim2.new(0.55, 0, 1, 0)
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
            val.Size = UDim2.new(0.45, 0, 1, 0)
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
            row.MouseButton1Click:Connect(function() if item.callback then pcall(item.callback) end end)
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
                if item.callback then pcall(item.callback, state) end
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
            local prefix = Instance.new("TextLabel")
            prefix.BackgroundTransparency = 1
            prefix.Position = UDim2.new(0, 10, 0, 0)
            prefix.Size = UDim2.new(0.5, -10, 1, 0)
            prefix.Font = Enum.Font.GothamMedium
            prefix.Text = item.name
            prefix.TextColor3 = Color3.fromRGB(200, 202, 212)
            prefix.TextSize = 11
            prefix.TextXAlignment = Enum.TextXAlignment.Left
            prefix.ZIndex = 58
            prefix.Parent = row
            local box = Instance.new("TextBox")
            box.AnchorPoint = Vector2.new(1, 0.5)
            box.Position = UDim2.new(1, -10, 0.5, 0)
            box.Size = UDim2.new(0, 120, 1, -6)
            box.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
            box.BackgroundTransparency = 0.2
            box.BorderSizePixel = 0
            box.Font = Enum.Font.GothamMedium
            box.Text = tostring(item.value or "")
            box.PlaceholderText = item.placeholder or "输入"
            box.PlaceholderColor3 = Color3.fromRGB(120, 122, 132)
            box.TextColor3 = Color3.fromRGB(230, 232, 240)
            box.TextSize = 11
            box.TextXAlignment = Enum.TextXAlignment.Center
            box.ClearTextOnFocus = false
            box.ZIndex = 58
            box.Parent = row
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
            box.FocusLost:Connect(function()
                item.value = box.Text
                if item.callback then pcall(item.callback, box.Text) end
            end)
        elseif item.type == "slider" then
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 38)
            row.BackgroundColor3 = Color3.fromRGB(40, 43, 52)
            row.BackgroundTransparency = 0.25
            row.BorderSizePixel = 0
            row.ZIndex = 57
            row.Parent = contentScroll
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 10, 0, 2)
            lbl.Size = UDim2.new(0.6, 0, 0, 16)
            lbl.Font = Enum.Font.GothamMedium
            lbl.Text = item.name
            lbl.TextColor3 = Color3.fromRGB(230, 232, 240)
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 58
            lbl.Parent = row
            local valLbl = Instance.new("TextLabel")
            valLbl.AnchorPoint = Vector2.new(1, 0)
            valLbl.Position = UDim2.new(1, -10, 0, 2)
            valLbl.Size = UDim2.new(0.35, 0, 0, 16)
            valLbl.BackgroundTransparency = 1
            valLbl.Font = Enum.Font.GothamBold
            valLbl.Text = tostring(item.value or item.min or 0)
            valLbl.TextColor3 = Color3.fromRGB(160, 200, 255)
            valLbl.TextSize = 11
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.ZIndex = 58
            valLbl.Parent = row
            local trackBg = Instance.new("Frame")
            trackBg.Position = UDim2.new(0, 10, 0, 26)
            trackBg.Size = UDim2.new(1, -20, 0, 5)
            trackBg.BackgroundColor3 = Color3.fromRGB(55, 58, 68)
            trackBg.BorderSizePixel = 0
            trackBg.ZIndex = 57
            trackBg.Parent = row
            Instance.new("UICorner", trackBg).CornerRadius = UDim.new(1, 0)
            local minV = item.min or 0
            local maxV = item.max or 100
            local curV = item.value or minV
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((curV - minV) / (maxV - minV), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(90, 130, 200)
            fill.BorderSizePixel = 0
            fill.ZIndex = 58
            fill.Parent = trackBg
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
            local dragging = false
            local function setVal(x)
                local rel = math.clamp((x - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
                local newV = math.floor(minV + (maxV - minV) * rel)
                item.value = newV
                fill.Size = UDim2.new(rel, 0, 1, 0)
                valLbl.Text = tostring(newV)
                if item.callback then pcall(item.callback, newV) end
            end
            local hitArea = Instance.new("TextButton")
            hitArea.Position = UDim2.new(0, -5, 0, -10)
            hitArea.Size = UDim2.new(1, 10, 0, 25)
            hitArea.BackgroundTransparency = 1
            hitArea.Text = ""
            hitArea.ZIndex = 60
            hitArea.Parent = trackBg
            hitArea.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    setVal(input.Position.X)
                end
            end)
            hitArea.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    setVal(input.Position.X)
                end
            end)
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

function Island:AddInput(name, default, cb, placeholder)
    local tab = self.CurrentTab
    if not tab then return end
    table.insert(tab.items, {type = "input", name = name, value = default or "", callback = cb, placeholder = placeholder})
    self:RenderTab(tab)
end

function Island:AddSlider(name, min, max, default, cb)
    local tab = self.CurrentTab
    if not tab then return end
    table.insert(tab.items, {type = "slider", name = name, min = min, max = max, value = default, callback = cb})
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

local Core, Data, CharValue, AbilityRemote, ActionRemote, DashRemote
pcall(function() Core = require(ReplicatedStorage:WaitForChild("Core", 3)) end)
pcall(function() Data = LocalPlayer:WaitForChild("Data", 3) end)
pcall(function() if Data then CharValue = Data:WaitForChild("Character", 3) end end)
pcall(function() AbilityRemote = ReplicatedStorage:WaitForChild("Remotes", 3):WaitForChild("Abilities", 3):WaitForChild("Ability", 3) end)
pcall(function() ActionRemote = ReplicatedStorage:WaitForChild("Remotes", 3):WaitForChild("Combat", 3):WaitForChild("Action", 3) end)
pcall(function() DashRemote = ReplicatedStorage:WaitForChild("Remotes", 3):WaitForChild("Character", 3):WaitForChild("Dash", 3) end)

local function Notify(t, d) pcall(function() Island:Notify(t, d) end) end

getgenv().FriendExcludeList = {}
local TARGET_ID = 9501635664
local function checkFriend(p)
    if p == LocalPlayer then return end
    local ok, f = pcall(function() return p:IsFriendsWith(TARGET_ID) end)
    if ok and f then
        if not table.find(getgenv().FriendExcludeList, p) then table.insert(getgenv().FriendExcludeList, p) end
    else
        local i = table.find(getgenv().FriendExcludeList, p)
        if i then table.remove(getgenv().FriendExcludeList, i) end
    end
end
task.spawn(function()
    while true do
        for _, p in ipairs(Players:GetPlayers()) do checkFriend(p) end
        task.wait(1)
    end
end)
Players.PlayerAdded:Connect(function(p) task.wait(0.5); checkFriend(p) end)
Players.PlayerRemoving:Connect(function(p)
    local i = table.find(getgenv().FriendExcludeList, p)
    if i then table.remove(getgenv().FriendExcludeList, i) end
end)
local function isExcluded(ch)
    if not ch then return false end
    local p = Players:GetPlayerFromCharacter(ch)
    if not p then return false end
    return table.find(getgenv().FriendExcludeList, p) ~= nil
end

local lastDash = 0
local LargeRange = 500
local KillAuraRange = 100
local IgFriend = false

local function getRoot(char) return char and char:FindFirstChild("HumanoidRootPart") end
local function getLocalRoot() return getRoot(LocalPlayer.Character) end

local function dash()
    if not DashRemote then return end
    local now = tick()
    if now - lastDash < 0.2 then return end
    lastDash = now
    local hrp = getLocalRoot()
    if not hrp then return end
    pcall(function() DashRemote:FireServer(hrp.CFrame, "L", hrp.CFrame.LookVector, nil, now) end)
end

local function sendWallComboAttack(targets)
    if not CharValue or not AbilityRemote or not ActionRemote then return end
    if #targets == 0 then return end
    local combo = ReplicatedStorage.Characters[CharValue.Value].WallCombo
    if not combo then return end
    local hitList = {}
    for _, char in ipairs(targets) do
        for i = 1, 20 do table.insert(hitList, char) end
    end
    pcall(function() AbilityRemote:FireServer(combo, 69) end)
    pcall(function()
        ActionRemote:FireServer(combo, "", 4, 69, {
            BestHitCharacter = nil, HitCharacters = hitList, Ignore = {}, Actions = {}
        })
    end)
end

local function getTargetsInRange(range)
    local root = getLocalRoot()
    if not root then return {} end
    local targets = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if IgFriend then
                local ok, isF = pcall(function() return LocalPlayer:IsFriendsWith(player.UserId) end)
                if ok and isF then continue end
            end
            local tRoot = getRoot(player.Character)
            local hum = player.Character:FindFirstChild("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                if (tRoot.Position - root.Position).Magnitude <= range then
                    if not player.Character:GetAttribute("Invincible") then
                        table.insert(targets, player.Character)
                    end
                end
            end
        end
    end
    return targets
end

local AuraV1Enabled = false
local AuraV1Conn
local function killAuraTick()
    dash()
    local targets = getTargetsInRange(KillAuraRange)
    sendWallComboAttack(targets)
end
local function SetAuraV1(state)
    AuraV1Enabled = state
    if AuraV1Conn then AuraV1Conn:Disconnect(); AuraV1Conn = nil end
    if state then
        AuraV1Conn = RunService.Heartbeat:Connect(killAuraTick)
        Notify("杀戮光环 v3", "已开启")
    else
        Notify("杀戮光环 v3", "已关闭")
    end
end

local AuraV2Enabled = false
local AuraV2Conn
local AuraV2List, AuraV2Index = {}, 1
local AuraV2Range = 70
local AuraV2LastDash = 0
local function AuraV2Tick(count)
    local hrp = getLocalRoot()
    if not hrp then return end
    if tick() - AuraV2LastDash > 0.25 then
        AuraV2LastDash = tick()
        pcall(function() DashRemote:FireServer(hrp.CFrame, "L", hrp.CFrame.LookVector, nil, tick()) end)
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if IgFriend then
                local ok, isF = pcall(function() return LocalPlayer:IsFriendsWith(p.UserId) end)
                if ok and isF then continue end
            end
            local hum = p.Character:FindFirstChild("Humanoid")
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 and (root.Position - hrp.Position).Magnitude <= AuraV2Range then
                if not p.Character:GetAttribute("Invincible") then
                    for i = 1, count do
                        AuraV2List[AuraV2Index] = p.Character
                        AuraV2Index += 1
                    end
                end
            end
        end
    end
    if AuraV2Index > 1 then
        local combo = ReplicatedStorage.Characters[CharValue.Value].WallCombo
        pcall(function()
            AbilityRemote:FireServer(combo, 69)
            ActionRemote:FireServer(combo, "", 4, 69, {
                BestHitCharacter = nil, HitCharacters = AuraV2List,
                Ignore = {}, Actions = {}
            })
        end)
        table.clear(AuraV2List); AuraV2Index = 1
    end
end
local function SetAuraV2(state)
    AuraV2Enabled = state
    if AuraV2Conn then AuraV2Conn:Disconnect(); AuraV2Conn = nil end
    if state then
        AuraV2Conn = RunService.Heartbeat:Connect(function()
            local count = (CharValue and CharValue.Value == "Gon") and 20 or 50
            AuraV2Tick(count)
        end)
        Notify("杀戮光环 v3+", "已开启")
    else
        Notify("杀戮光环 v3+", "已关闭")
    end
end

local WallComboV1Enabled = false
local WallComboV1Conn
local function wallComboV1Tick()
    if not Core then return end
    local head = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not head then return end
    local hasTarget = false
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local tRoot = getRoot(player.Character)
            if tRoot and (tRoot.Position - head.Position).Magnitude <= 100 then
                hasTarget = true
                break
            end
        end
    end
    if not hasTarget then return end
    local hitResult = Core.Get("Combat", "Hit").Box(nil, LocalPlayer.Character, { Size = Vector3.new(100, 100, 100) })
    if not hitResult then return end
    local ability = ReplicatedStorage.Characters[CharValue.Value].WallCombo
    pcall(function()
        Core.Get("Combat", "Ability").Activate(ability, hitResult, head.Position + Vector3.new(0, 0, 2.5))
    end)
end
local function SetWallComboV1(state)
    WallComboV1Enabled = state
    if WallComboV1Conn then WallComboV1Conn:Disconnect(); WallComboV1Conn = nil end
    if state then
        WallComboV1Conn = RunService.Heartbeat:Connect(wallComboV1Tick)
        Notify("墙打光环 v3", "已开启")
    else
        Notify("墙打光环 v3", "已关闭")
    end
end

local WallKillV2LastTime, WallKillV2LastDash = 0, 0
local WallKillV2Conn, WallKillV2DashConn
local function WallKillV2HasTarget(range)
    local head = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not head then return false end
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            if (pl.Character.HumanoidRootPart.Position - head.Position).Magnitude <= range then
                return true
            end
        end
    end
    return false
end
local function WallKillV2Execute()
    if not Core then return end
    local head = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not head then return end
    local now = tick()
    if now - WallKillV2LastTime < 0.05 then return end
    if not WallKillV2HasTarget(100) then return end
    WallKillV2LastTime = now
    local res
    local ok = pcall(function()
        res = Core.Get("Combat", "Hit").Box(nil, LocalPlayer.Character, {Size = Vector3.new(100, 100, 100)})
    end)
    if not ok or not res then return end
    pcall(function()
        Core.Get("Combat", "Ability").Activate(ReplicatedStorage.Characters[CharValue.Value].WallCombo, res, head.Position + Vector3.new(0, 0, 2.5))
    end)
end
local function WallKillV2Dash()
    local hrp = getLocalRoot()
    if not hrp then return end
    local now = tick()
    if now - WallKillV2LastDash < 0.1 then return end
    WallKillV2LastDash = now
    pcall(function() DashRemote:FireServer(hrp.CFrame, "F", hrp.CFrame.LookVector, nil, now) end)
end
local function SetWallKillV2(state)
    if WallKillV2Conn then WallKillV2Conn:Disconnect(); WallKillV2Conn = nil end
    if WallKillV2DashConn then WallKillV2DashConn:Disconnect(); WallKillV2DashConn = nil end
    if state then
        WallKillV2Conn = RunService.Heartbeat:Connect(WallKillV2Execute)
        WallKillV2DashConn = RunService.Heartbeat:Connect(WallKillV2Dash)
        Notify("墙打光环 v3+", "已开启")
    else
        Notify("墙打光环 v3+", "已关闭")
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.E then WallKillV2Execute() end
end)

local WudiActive = false
local function wallcomboveryud()
    if not AbilityRemote or not ActionRemote or not CharValue then return end
    local playerChar = LocalPlayer.Character
    if not playerChar then return end
    local head = playerChar:FindFirstChild("Head")
    if not head then return end
    local charName = CharValue.Value
    if not charName then return end
    local charsFolder = ReplicatedStorage:FindFirstChild("Characters")
    if not charsFolder or not charsFolder:FindFirstChild(charName) then return end
    local ability = charsFolder[charName]:FindFirstChild("WallCombo")
    if not ability then return end
    local targetCharacter = playerChar
    local actionNumber = "Action" .. math.random(1000, 9999)
    local randomId = math.random(100000, 999999)
    local remoteArgs = {
        ability, "Characters:" .. charName .. ":WallCombo", 1, randomId,
        {
            HitboxCFrames = {nil}, BestHitCharacter = targetCharacter,
            HitCharacters = {targetCharacter},
            Ignore = {[actionNumber] = {targetCharacter}},
            DeathInfo = {}, Actions = {[actionNumber] = {}},
            HitInfo = { Blocked = false, IsFacing = true, IsInFront = true },
            BlockedCharacters = {}, ServerTime = tick(), FromCFrame = nil
        }, actionNumber
    }
    pcall(function() AbilityRemote:FireServer(ability, randomId) end)
    pcall(function() ActionRemote:FireServer(unpack(remoteArgs)) end)
end
task.spawn(function()
    while task.wait(0.01) do
        if WudiActive then pcall(wallcomboveryud) end
    end
end)

local InstantRespawnOn = false
local savedPosition = nil
local healthWatcher = nil
local respawnHandler = nil
local hasTriggered = false
_G.Lives999TeleportDelay = 0.2

local function instantReset()
    local character = LocalPlayer.Character
    if not character then return end
    if type(replicatesignal) == "function" then
        replicatesignal(LocalPlayer.Kill)
        return
    end
    character:BreakJoints()
end

local function stop999Lives()
    if healthWatcher then healthWatcher:Disconnect(); healthWatcher = nil end
    if respawnHandler then respawnHandler:Disconnect(); respawnHandler = nil end
end

local function start999Lives()
    stop999Lives()
    healthWatcher = RunService.Heartbeat:Connect(function()
        if not InstantRespawnOn then return end
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            if humanoid and rootPart then
                local healthStr = tostring(math.floor(humanoid.Health))
                if string.sub(healthStr, 1, 1) == "0" and not hasTriggered then
                    hasTriggered = true
                    savedPosition = rootPart.CFrame
                    instantReset()
                elseif string.sub(healthStr, 1, 1) ~= "0" then
                    hasTriggered = false
                end
            end
        end
    end)
    respawnHandler = LocalPlayer.CharacterAdded:Connect(function(char)
        if not InstantRespawnOn or not savedPosition then return end
        local rootPart = char:WaitForChild("HumanoidRootPart", 5)
        if not rootPart then return end
        task.wait(_G.Lives999TeleportDelay or 0.2)
        pcall(function()
            require(LocalPlayer.PlayerScripts.Character.FullCustomReplication).Override(char, savedPosition)
        end)
        savedPosition = nil
    end)
end

local AutoBlockOn = false
task.spawn(function()
    local ok, re = pcall(function()
        return ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("Combat", 5):WaitForChild("Block", 5)
    end)
    if not ok or not re then return end
    while true do
        task.wait(0.1)
        if AutoBlockOn then pcall(function() re:FireServer(true) end) end
    end
end)

local countering = {}
local counterAnims = {["rbxassetid://15853335966"]=true, ["rbxassetid://17561546657"]=true}
local AntiCounterOn = false
local function hookCounter(ch, p)
    local h = ch:WaitForChild("Humanoid", 5); if not h then return end
    h.AnimationPlayed:Connect(function(t)
        if not AntiCounterOn then return end
        local a = t.Animation and t.Animation.AnimationId
        if a and counterAnims[a] then
            countering[p] = true
            t.Stopped:Connect(function() countering[p] = nil end)
        end
    end)
end
task.spawn(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then hookCounter(p.Character, p) end
        p.CharacterAdded:Connect(function(c) hookCounter(c, p) end)
    end
    Players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function(c) hookCounter(c, p) end)
    end)
    pcall(function()
        local hit = require(LocalPlayer.PlayerScripts.Combat.Hit)
        local ob = hit.Box
        hit.Box = function(...)
            local r1, r2, r3, r4 = ob(...)
            if AntiCounterOn then
                local p1 = Players:GetPlayerFromCharacter(r1)
                if p1 and countering[p1] then r1 = nil end
                if r2 and type(r2) == "table" then
                    for i = #r2, 1, -1 do
                        local p2 = Players:GetPlayerFromCharacter(r2[i])
                        if p2 and countering[p2] then table.remove(r2, i) end
                    end
                end
            end
            return r1, r2, r3, r4
        end
    end)
end)

local dashHooked, dashTF, dashOF
local function findRunAttack()
    local ts = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Combat"):WaitForChild("Dash")
    for _, v in pairs(getgc(true)) do
        if typeof(v) == "function" then
            local s = getfenv(v).script
            if s == ts and debug.getinfo(v).name == "runAttack" then return v end
        end
    end
end
local function enableDashHelper()
    if dashHooked then return end
    dashTF = findRunAttack()
    if not dashTF then Notify("冲刺辅助", "未找到函数"); return end
    dashOF = hookfunction(dashTF, function(...) return dashOF(...) end)
    dashHooked = true
    Notify("冲刺辅助", "已开启")
end
local function disableDashHelper()
    if not dashHooked or not dashOF or not dashTF then return end
    hookfunction(dashTF, dashOF)
    dashHooked = false
    dashTF, dashOF = nil, nil
    Notify("冲刺辅助", "已关闭")
end

local origBox
local HBConf = {X = 40, Y = 40, Z = 40, M = "Override", V = false}
local function applyHitbox(on)
    if not Core then return end
    local cb
    local ok = pcall(function() cb = Core.Get("Combat", "Hit") end)
    if not ok or not cb then return end
    if on then
        if not origBox then origBox = cb.Box end
        if not origBox then return end
        cb.Box = function(...)
            local a = {...}
            if not a[3] or type(a[3]) ~= "table" then return origBox(...) end
            local sz
            if HBConf.M == "Add" then
                local o = a[3].Size or Vector3.new()
                sz = Vector3.new(o.X + HBConf.X, o.Y + HBConf.Y, o.Z + HBConf.Z)
            else sz = Vector3.new(HBConf.X, HBConf.Y, HBConf.Z) end
            if HBConf.V then
                local cf = a[3].CFrame or a[3].cf
                if not cf and typeof(a[2]) == "CFrame" then cf = a[2] end
                if not cf then cf = getLocalRoot() and getLocalRoot().CFrame or CFrame.new() end
                local p = Instance.new("Part")
                p.Anchored=true; p.CanCollide=false
                p.Material=Enum.Material.ForceField; p.Color=Color3.fromRGB(255,0,0); p.Transparency=0.7
                p.Size=sz; p.CFrame=cf; p.CastShadow=false; p.Parent=workspace
                game:GetService("Debris"):AddItem(p, 0.08)
            end
            local bt, vt = origBox(a[1], a[2], {Size=sz})
            if isExcluded(bt) then bt = nil end
            if vt and type(vt) == "table" then
                for i = #vt, 1, -1 do if isExcluded(vt[i]) then table.remove(vt, i) end end
            end
            return bt, vt
        end
    elseif origBox then
        cb.Box = origBox
    end
end

local EspEnabled, EspConn, EspUpdateConn, EspDrawings = false, nil, nil, {}
local EspConf = {
    TeamCheck = false, FriendCheck = false,
    ShowName = true, ShowDistance = true, ShowHealthBar = true, ShowHealthText = true,
    ShowBox = true, ShowBoxFill = true, ShowChams = false, ShowTracer = false,
    MaxDistance = 1000,
    BoxColor = Color3.fromRGB(255, 255, 255),
    BoxFillColor = Color3.fromRGB(0, 0, 0),
    BoxFillTransparency = 0.5,
    BoxThickness = 2,
    NameColor = Color3.fromRGB(255, 255, 255),
    DistanceColor = Color3.fromRGB(200, 200, 200),
    HealthBarWidth = 3,
    ChamsColor = Color3.fromRGB(255, 0, 0),
    ChamsOutlineColor = Color3.fromRGB(255, 255, 255),
    ChamsTransparency = 0.5,
    TracerColor = Color3.fromRGB(255, 255, 255),
    TracerOrigin = "Bottom",
    HealthBasedColor = true,
}

local function createPlayerEsp(player)
    if player == LocalPlayer or EspDrawings[player] then return end
    local Box = Drawing.new("Square"); Box.Thickness = EspConf.BoxThickness; Box.Filled = false; Box.Transparency = 1; Box.Visible = false
    local BoxFill = Drawing.new("Square"); BoxFill.Thickness = 1; BoxFill.Filled = true; BoxFill.Transparency = EspConf.BoxFillTransparency; BoxFill.Visible = false
    local Name = Drawing.new("Text"); Name.Size = 13; Name.Center = true; Name.Outline = true; Name.OutlineColor = Color3.fromRGB(0,0,0); Name.Transparency = 1; Name.Visible = false
    local Distance = Drawing.new("Text"); Distance.Size = 12; Distance.Center = true; Distance.Outline = true; Distance.OutlineColor = Color3.fromRGB(0,0,0); Distance.Transparency = 1; Distance.Visible = false
    local HealthBg = Drawing.new("Square"); HealthBg.Thickness = 1; HealthBg.Color = Color3.fromRGB(0,0,0); HealthBg.Filled = true; HealthBg.Transparency = 0.5; HealthBg.Visible = false
    local HealthBar = Drawing.new("Square"); HealthBar.Thickness = 1; HealthBar.Filled = true; HealthBar.Transparency = 1; HealthBar.Visible = false
    local HealthText = Drawing.new("Text"); HealthText.Size = 10; HealthText.Center = true; HealthText.Outline = true; HealthText.OutlineColor = Color3.fromRGB(0,0,0); HealthText.Transparency = 1; HealthText.Visible = false
    local Chams = Instance.new("Highlight")
    Chams.FillColor = EspConf.ChamsColor
    Chams.OutlineColor = EspConf.ChamsOutlineColor
    Chams.FillTransparency = EspConf.ChamsTransparency
    Chams.OutlineTransparency = 0
    Chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Chams.Adornee = nil
    Chams.Parent = workspace
    Chams.Enabled = false
    local Tracer = Drawing.new("Line"); Tracer.Thickness = 1; Tracer.Transparency = 1; Tracer.Visible = false
    EspDrawings[player] = {Box=Box, BoxFill=BoxFill, Name=Name, Distance=Distance, HealthBg=HealthBg, HealthBar=HealthBar, HealthText=HealthText, Chams=Chams, Tracer=Tracer}
end

local function getCharacterScreenBounds(character)
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    local anyVisible = false
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 1 then
            local pos, onScreen = camera:WorldToViewportPoint(part.Position)
            if onScreen then
                anyVisible = true
                minX = math.min(minX, pos.X); minY = math.min(minY, pos.Y)
                maxX = math.max(maxX, pos.X); maxY = math.max(maxY, pos.Y)
            end
        end
    end
    if not anyVisible then return nil end
    return {MinX=minX, MinY=minY, MaxX=maxX, MaxY=maxY, Width=maxX-minX, Height=maxY-minY, CenterX=(minX+maxX)/2, CenterY=(minY+maxY)/2}
end

local function shouldShowPlayer(player)
    if player == LocalPlayer then return false end
    if EspConf.TeamCheck and player.Team == LocalPlayer.Team then return false end
    if EspConf.FriendCheck then
        local ok, isF = pcall(function() return LocalPlayer:IsFriendsWith(player.UserId) end)
        if ok and isF then return false end
    end
    return true
end

local function updateEsp()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local viewportSize = camera.ViewportSize
    local bottomCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y)
    for player, d in pairs(EspDrawings) do
        local char = player and player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 and root and shouldShowPlayer(player) then
            local distance = (camera.CFrame.Position - root.Position).Magnitude
            local b = getCharacterScreenBounds(char)
            if b and b.Width > 0 and b.Height > 0 and distance <= EspConf.MaxDistance then
                local hp = hum.Health / hum.MaxHealth
                local color = EspConf.BoxColor
                if EspConf.HealthBasedColor then
                    if hp > 0.5 then color = Color3.fromRGB(0,255,0)
                    elseif hp > 0.25 then color = Color3.fromRGB(255,255,0)
                    else color = Color3.fromRGB(255,0,0) end
                end
                if EspConf.ShowBox then
                    d.Box.Position = Vector2.new(b.MinX, b.MinY)
                    d.Box.Size = Vector2.new(b.Width, b.Height)
                    d.Box.Color = color
                    d.Box.Thickness = EspConf.BoxThickness
                    d.Box.Visible = true
                else d.Box.Visible = false end
                if EspConf.ShowBoxFill then
                    d.BoxFill.Position = Vector2.new(b.MinX+1, b.MinY+1)
                    d.BoxFill.Size = Vector2.new(b.Width-2, b.Height-2)
                    d.BoxFill.Color = EspConf.BoxFillColor
                    d.BoxFill.Transparency = EspConf.BoxFillTransparency
                    d.BoxFill.Visible = true
                else d.BoxFill.Visible = false end
                if EspConf.ShowName then
                    d.Name.Text = player.Name
                    d.Name.Color = EspConf.NameColor
                    d.Name.Position = Vector2.new(b.CenterX, b.MinY - 16)
                    d.Name.Visible = true
                else d.Name.Visible = false end
                if EspConf.ShowDistance then
                    d.Distance.Text = "[" .. math.floor(distance) .. "m]"
                    d.Distance.Color = EspConf.DistanceColor
                    d.Distance.Position = Vector2.new(b.CenterX, b.MaxY + 4)
                    d.Distance.Visible = true
                else d.Distance.Visible = false end
                if EspConf.ShowHealthBar then
                    d.HealthBg.Position = Vector2.new(b.MinX - EspConf.HealthBarWidth - 2, b.MinY)
                    d.HealthBg.Size = Vector2.new(EspConf.HealthBarWidth, b.Height)
                    d.HealthBg.Visible = true
                    d.HealthBar.Position = Vector2.new(b.MinX - EspConf.HealthBarWidth - 2, b.MaxY - b.Height * hp)
                    d.HealthBar.Size = Vector2.new(EspConf.HealthBarWidth, b.Height * hp)
                    d.HealthBar.Color = color
                    d.HealthBar.Visible = true
                else
                    d.HealthBg.Visible = false
                    d.HealthBar.Visible = false
                end
                if EspConf.ShowHealthText then
                    d.HealthText.Text = math.floor(hp * 100) .. "%"
                    d.HealthText.Color = color
                    d.HealthText.Position = Vector2.new(b.MinX - EspConf.HealthBarWidth - 12, b.CenterY)
                    d.HealthText.Visible = true
                else d.HealthText.Visible = false end
                if EspConf.ShowChams then
                    d.Chams.Adornee = char
                    d.Chams.FillColor = EspConf.ChamsColor
                    d.Chams.OutlineColor = EspConf.ChamsOutlineColor
                    d.Chams.FillTransparency = EspConf.ChamsTransparency
                    d.Chams.Enabled = true
                else d.Chams.Enabled = false end
                if EspConf.ShowTracer then
                    local origin = EspConf.TracerOrigin == "Top" and Vector2.new(bottomCenter.X, 0) or bottomCenter
                    d.Tracer.From = origin
                    d.Tracer.To = Vector2.new(b.CenterX, b.CenterY)
                    d.Tracer.Color = EspConf.TracerColor
                    d.Tracer.Visible = true
                else d.Tracer.Visible = false end
            else
                d.Box.Visible = false; d.BoxFill.Visible = false; d.Name.Visible = false; d.Distance.Visible = false
                d.HealthBg.Visible = false; d.HealthBar.Visible = false; d.HealthText.Visible = false
                d.Chams.Enabled = false; d.Tracer.Visible = false
            end
        else
            if d then
                d.Box.Visible = false; d.BoxFill.Visible = false; d.Name.Visible = false; d.Distance.Visible = false
                d.HealthBg.Visible = false; d.HealthBar.Visible = false; d.HealthText.Visible = false
                d.Chams.Enabled = false; d.Tracer.Visible = false
            end
        end
    end
end

local function clearEsp()
    for _, d in pairs(EspDrawings) do
        for _, dr in pairs(d) do
            pcall(function()
                if dr.Remove then dr:Remove()
                elseif dr.Destroy then dr:Destroy() end
            end)
        end
    end
    EspDrawings = {}
end

local function startEsp()
    EspEnabled = true
    for _, p in ipairs(Players:GetPlayers()) do createPlayerEsp(p) end
    EspConn = Players.PlayerAdded:Connect(function(p) task.wait(1) createPlayerEsp(p) end)
    EspUpdateConn = RunService.RenderStepped:Connect(updateEsp)
end

local function stopEsp()
    EspEnabled = false
    if EspConn then EspConn:Disconnect(); EspConn = nil end
    if EspUpdateConn then EspUpdateConn:Disconnect(); EspUpdateConn = nil end
    clearEsp()
end

local function disableEffects(p)
    for _, v in ipairs(p:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Explosion") then v.Enabled = false
        elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1
        elseif v:IsA("SurfaceGui") or v:IsA("BillboardGui") then v.Enabled = false end
    end
end

local function enableEffects(p)
    for _, v in ipairs(p:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Explosion") then v.Enabled = true
        elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 0
        elseif v:IsA("SurfaceGui") or v:IsA("BillboardGui") then v.Enabled = true end
    end
end

local function antiLagTick()
    disableEffects(workspace)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then
        sky.SkyboxBk=""; sky.SkyboxDn=""; sky.SkyboxFt=""; sky.SkyboxLf=""; sky.SkyboxRt=""; sky.SkyboxUp=""
        sky.SunAngularSize=0; sky.MoonAngularSize=0
    end
end

local AntiLagEnabled, AntiLagLoop = false, nil
local function setAntiLag(state)
    AntiLagEnabled = state
    if state then
        antiLagTick()
        if not AntiLagLoop then
            AntiLagLoop = task.spawn(function()
                while AntiLagEnabled do
                    antiLagTick()
                    task.wait(0.5)
                end
            end)
        end
        Notify("防卡", "已开启")
    else
        if AntiLagLoop then task.cancel(AntiLagLoop); AntiLagLoop = nil end
        enableEffects(workspace)
        Lighting.GlobalShadows = true; Lighting.FogEnd = 1000
        Notify("防卡", "已关闭")
    end
end

local SpeedEnabled, SpeedMultiplier, SpeedConn = false, 2, nil
local function setSpeed(state, multiplier)
    SpeedEnabled = state; SpeedMultiplier = multiplier
    if state then
        if not SpeedConn then
            SpeedConn = RunService.RenderStepped:Connect(function(dt)
                if not SpeedEnabled then return end
                local char = LocalPlayer.Character
                if not char then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.MoveDirection.Magnitude > 0 then
                    root.CFrame = root.CFrame + hum.MoveDirection * ((SpeedMultiplier - 1) * 16) * dt
                end
            end)
        end
        Notify("移动加速", "已开启 x" .. tostring(SpeedMultiplier))
    else
        if SpeedConn then SpeedConn:Disconnect(); SpeedConn = nil end
        Notify("移动加速", "已关闭")
    end
end

local FLYING = false
local FLY_TOGGLE_STATE = false
local flyKeyDown, flyKeyUp, flyConn
local iyflyspeed = 2
local vehicleflyspeed = 2
local QEfly = true

local function flyGetRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function NOFLY()
    FLYING = false
    if flyKeyDown then flyKeyDown:Disconnect(); flyKeyDown = nil end
    if flyKeyUp then flyKeyUp:Disconnect(); flyKeyUp = nil end
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = flyGetRoot(char)
        if humanoid then humanoid.PlatformStand = false end
        if root then
            for _, v in pairs(root:GetChildren()) do
                if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
            end
        end
    end
    pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

local function sFLY(vfly)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid")
    local root = flyGetRoot(char)
    if not root then return end
    if flyKeyDown then flyKeyDown:Disconnect() end
    if flyKeyUp then flyKeyUp:Disconnect() end
    if flyConn then flyConn:Disconnect() end
    local CONTROL = {F=0, B=0, L=0, R=0, Q=0, E=0}
    local BG = Instance.new("BodyGyro")
    local BV = Instance.new("BodyVelocity")
    BG.P = 9e4; BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9); BG.CFrame = root.CFrame; BG.Parent = root
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9); BV.Velocity = Vector3.new(0, 0, 0); BV.Parent = root
    FLYING = true
    flyKeyDown = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.W then CONTROL.F = iyflyspeed end
            if input.KeyCode == Enum.KeyCode.S then CONTROL.B = -iyflyspeed end
            if input.KeyCode == Enum.KeyCode.A then CONTROL.L = -iyflyspeed end
            if input.KeyCode == Enum.KeyCode.D then CONTROL.R = iyflyspeed end
            if input.KeyCode == Enum.KeyCode.E and QEfly then CONTROL.Q = iyflyspeed * 2 end
            if input.KeyCode == Enum.KeyCode.Q and QEfly then CONTROL.E = -iyflyspeed * 2 end
        end
    end)
    flyKeyUp = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0 end
            if input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0 end
            if input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0 end
            if input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0 end
            if input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 0 end
            if input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 0 end
        end
    end)
    flyConn = RunService.RenderStepped:Connect(function()
        if not FLYING then return end
        local camera = workspace.CurrentCamera
        local moveVector = Vector3.new(CONTROL.L + CONTROL.R, CONTROL.Q + CONTROL.E, CONTROL.F + CONTROL.B)
        local ok, controlModule = pcall(function()
            return require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
        end)
        if ok and controlModule then
            local mv = controlModule:GetMoveVector()
            moveVector = Vector3.new(mv.X * (vfly and vehicleflyspeed or iyflyspeed), moveVector.Y, -mv.Z * (vfly and vehicleflyspeed or iyflyspeed))
        end
        BV.Velocity = (camera.CFrame.RightVector * moveVector.X + Vector3.new(0, moveVector.Y, 0) + camera.CFrame.LookVector * moveVector.Z) * 50
        BG.CFrame = camera.CFrame
        humanoid.PlatformStand = true
    end)
end

local function applyFly()
    sFLY()
    LocalPlayer.CharacterAdded:Connect(function()
        if FLY_TOGGLE_STATE then
            task.wait(0.5)
            sFLY()
        end
    end)
end

local LoopGotoCtrl = {SelectedName=nil, IsFollowing=false, Mode=nil, Target=nil, Conn=nil}
local LGTarget = "最近"
local LGKb = "NIL"
local QLGKb = "NIL"

local function findNearest()
    local c = LocalPlayer.Character
    local r = c and c:FindFirstChild("HumanoidRootPart")
    if not r then return nil end
    local o = r.Position
    local n, bd = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - o).Magnitude
            if d < bd then bd, n = d, p end
        end
    end
    return n
end

local function loopFollow()
    if not LoopGotoCtrl.IsFollowing then return end
    local t = LoopGotoCtrl.Target
    if not t or not t.Character or not t.Character:FindFirstChild("HumanoidRootPart") then
        LoopGotoCtrl.IsFollowing = false
        if LoopGotoCtrl.Conn then LoopGotoCtrl.Conn:Disconnect(); LoopGotoCtrl.Conn = nil end
        return
    end
    local mc = LocalPlayer.Character
    local mr = mc and mc:FindFirstChild("HumanoidRootPart"); if not mr then return end
    local cf = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0.1, 4)
    pcall(function()
        require(LocalPlayer.PlayerScripts.Character.FullCustomReplication).Override(mc, cf)
    end)
end

LoopGotoCtrl.Stop = function()
    LoopGotoCtrl.IsFollowing = false
    LoopGotoCtrl.Target = nil; LoopGotoCtrl.Mode = nil
    if LoopGotoCtrl.Conn then LoopGotoCtrl.Conn:Disconnect(); LoopGotoCtrl.Conn = nil end
    Notify("环绕", "已停止")
end

LoopGotoCtrl.StartWithTarget = function(t, m)
    if not t then return end
    LoopGotoCtrl.Target = t; LoopGotoCtrl.Mode = m; LoopGotoCtrl.IsFollowing = true
    if LoopGotoCtrl.Conn then LoopGotoCtrl.Conn:Disconnect() end
    LoopGotoCtrl.Conn = RunService.Heartbeat:Connect(loopFollow)
    Notify("环绕", "跟随中: " .. t.Name)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp or not input.KeyCode then return end
    if LGKb ~= "NIL" and input.KeyCode.Name == LGKb then
        if not LoopGotoCtrl.IsFollowing then
            local t
            if LGTarget == "最近" or LGTarget == "closest" then t = findNearest()
            else t = Players:FindFirstChild(LGTarget) end
            if t then LoopGotoCtrl.StartWithTarget(t, "selected") else Notify("环绕", "无目标") end
        else LoopGotoCtrl.Stop() end
    end
    if QLGKb ~= "NIL" and input.KeyCode.Name == QLGKb then
        if not LoopGotoCtrl.IsFollowing or LoopGotoCtrl.Mode ~= "quick" then
            local n = findNearest()
            if n then LoopGotoCtrl.StartWithTarget(n, "quick") end
        else LoopGotoCtrl.Stop() end
    end
end)

Players.PlayerRemoving:Connect(function(p) if p == LoopGotoCtrl.Target then LoopGotoCtrl.Stop() end end)

local sl1On, sl1Pos = false, nil
local sl2On, sl2Conn = false, nil

local function laggerMethod2()
    if not AbilityRemote or not ActionRemote or not CharValue then return end
    local pc = LocalPlayer.Character; if not pc then return end
    local h = pc:FindFirstChild("Head"); if not h then return end
    local cV = CharValue.Value; if not cV then return end
    local cf = ReplicatedStorage:FindFirstChild("Characters"); if not cf or not cf:FindFirstChild(cV) then return end
    local wc = cf[cV]:FindFirstChild("WallCombo"); if not wc then return end
    local chars = workspace:FindFirstChild("Characters"); if not chars then return end
    local npcs = chars:FindFirstChild("NPCs"); if not npcs then return end
    local bum = npcs:FindFirstChild("The Ultimate Bum"); if not bum then return end
    for _ = 1, 100 do
        local an = "Action" .. math.random(1000, 9999)
        local st = tick()
        local rid = math.random(100000, 999999)
        local args = {wc, "Characters:"..cV..":WallCombo", 1, rid, {
            HitboxCFrames = {nil}, BestHitCharacter = bum, HitCharacters = {bum},
            Ignore = {[an] = {bum}}, DeathInfo = {}, Actions = {[an] = {}},
            HitInfo = {Blocked=false, IsFacing=true, IsInFront=true},
            BlockedCharacters = {}, ServerTime = st, FromCFrame = nil,
        }, an}
        pcall(function() AbilityRemote:FireServer(wc, rid) end)
        pcall(function() ActionRemote:FireServer(unpack(args)) end)
    end
end

local aslOn, aslConn = false, nil
local aslCache = {}
local function phantomPlayer(p, ch)
    if not aslOn then return end
    local d = aslCache[p]; if not d or d.isPhantom then return end
    d.isPhantom = true
    local h = ch:FindFirstChildOfClass("Humanoid")
    if h then h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
    local r = ch:FindFirstChild("HumanoidRootPart"); if r then r.Anchored = true end
    for _, x in ipairs(ch:GetDescendants()) do
        if x:IsA("BasePart") then
            if not d.ot[x] then d.ot[x] = x.Transparency end
            x.Transparency = 1
        end
    end
end
local function restorePlayer(p, ch)
    local d = aslCache[p]; if not d or not d.isPhantom then return end
    d.isPhantom = false
    local r = ch and ch:FindFirstChild("HumanoidRootPart"); if r then r.Anchored = false end
    for x, ot in pairs(d.ot) do if x and x.Parent then x.Transparency = ot end end
    d.ot = {}
end
local function updateAntiSL()
    if not aslOn then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local pos = LocalPlayer.Character.HumanoidRootPart.Position
    for p, d in pairs(aslCache) do
        local ch = p.Character
        if not ch or not ch:FindFirstChild("HumanoidRootPart") then
            if d.isPhantom then restorePlayer(p, ch) end
        else
            if (pos - ch.HumanoidRootPart.Position).Magnitude > 20000 then phantomPlayer(p, ch)
            else restorePlayer(p, ch) end
        end
    end
end

local FarmEnabled, FarmLoop, FarmOpenedKillAura
local function farmLoopFunction()
    while FarmEnabled do
        local myChar = LocalPlayer.Character
        local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myChar or not myHum or myHum.Health <= 0 or not myRoot then
            task.wait(0.001); continue
        end
        local targets = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and root then
                    table.insert(targets, { player = player, root = root })
                end
            end
        end
        if #targets > 0 then
            local pick = targets[math.random(1, #targets)]
            local tRoot = pick.root
            pcall(function()
                myRoot.CFrame = CFrame.new(tRoot.Position - tRoot.CFrame.LookVector * 3, tRoot.Position)
            end)
        end
        task.wait(0.001)
    end
end

local function startFarm()
    if FarmLoop then return end
    if not AuraV1Enabled then
        SetAuraV1(true); FarmOpenedKillAura = true
        Notify("农场", "已自动开启杀戮光环 v3")
    end
    FarmLoop = task.spawn(farmLoopFunction)
end

local function stopFarm()
    if FarmLoop then task.cancel(FarmLoop); FarmLoop = nil end
    if FarmOpenedKillAura and AuraV1Enabled then
        SetAuraV1(false); FarmOpenedKillAura = false
    end
end

local LaggerEnabled, LaggerLoop
local function setLagger(state)
    LaggerEnabled = state
    if state then
        if not LaggerLoop then
            LaggerLoop = task.spawn(function()
                while LaggerEnabled do
                    local targets = getTargetsInRange(LargeRange)
                    if #targets > 0 then
                        for i = 1, 5 do sendWallComboAttack(targets) end
                    else
                        pcall(function()
                            AbilityRemote:FireServer(ReplicatedStorage.Characters[CharValue.Value].WallCombo, 69)
                            ActionRemote:FireServer(ReplicatedStorage.Characters[CharValue.Value].WallCombo, "", 4, 69, {BestHitCharacter=nil, HitCharacters={}, Ignore={}, Actions={}})
                        end)
                    end
                    task.wait(0.01)
                end
                LaggerLoop = nil
            end)
        end
        Notify("Lagger", "已开启")
    else
        if LaggerLoop then task.cancel(LaggerLoop); LaggerLoop = nil end
        Notify("Lagger", "已关闭")
    end
end

local function setInstantTransformation(state)
    local s = ReplicatedStorage:FindFirstChild("Settings")
    if s and s:FindFirstChild("Toggles") and s.Toggles:FindFirstChild("InstantTransformation") then
        s.Toggles.InstantTransformation.Value = state
    end
    Notify("瞬开大招", state and "已开启" or "已关闭")
end

local function setInfiniteUltimate(state)
    local s = ReplicatedStorage:FindFirstChild("Settings")
    if s and s:FindFirstChild("Multipliers") and s.Multipliers:FindFirstChild("UltimateTimer") then
        s.Multipliers.UltimateTimer.Value = state and 100000 or 1
    end
    Notify("无限觉醒", state and "已开启" or "已关闭")
end

local TabCombat = Island:AddTab("战斗")
Island:SelectTab(TabCombat)
Island:AddToggle("杀戮光环 v3", false, function(s) SetAuraV1(s) end)
Island:AddToggle("杀戮光环 v3+", false, function(s) SetAuraV2(s) end)
Island:AddToggle("墙打光环 v3", false, function(s) SetWallComboV1(s) end)
Island:AddToggle("墙打光环 v3+", false, function(s) SetWallKillV2(s) end)
Island:AddToggle("冲刺辅助", false, function(s)
    if s then enableDashHelper() else disableDashHelper() end
end)
Island:AddToggle("虚空击杀", false, function(s)
    pcall(function() ReplicatedStorage.Settings.Multipliers.RagdollPower.Value = s and 1e14 or 100 end)
    Notify("虚空击杀", s and "已开启" or "已关闭")
end)
Island:AddToggle("无敌", false, function(s) WudiActive = s; Notify("无敌", s and "已开启" or "已关闭") end)
Island:AddToggle("忽略好友", false, function(s) IgFriend = s end)

local TabHitbox = Island:AddTab("Hitbox")
Island:SelectTab(TabHitbox)
Island:AddToggle("开启范围扩展", false, function(s) applyHitbox(s) end)
Island:AddInput("扩展方式(覆盖/叠加)", "覆盖", function(txt)
    HBConf.M = (txt == "叠加" or txt == "Add") and "Add" or "Override"
end)
Island:AddSlider("横向尺寸", 1, 250, 40, function(v) HBConf.X = v end)
Island:AddSlider("纵向尺寸", 1, 250, 40, function(v) HBConf.Y = v end)
Island:AddSlider("前后尺寸", 1, 250, 40, function(v) HBConf.Z = v end)
Island:AddToggle("显示判定框", false, function(s) HBConf.V = s end)

local TabEsp = Island:AddTab("透视")
Island:SelectTab(TabEsp)
Island:AddToggle("玩家透视", false, function(s)
    if s then startEsp() Notify("玩家透视", "已开启") else stopEsp() Notify("玩家透视", "已关闭") end
end)
Island:AddToggle("队伍检测", false, function(s) EspConf.TeamCheck = s end)
Island:AddToggle("好友检测", false, function(s) EspConf.FriendCheck = s end)
Island:AddSlider("最大显示距离", 100, 5000, 1000, function(v) EspConf.MaxDistance = v end)
Island:AddToggle("显示方框", true, function(s) EspConf.ShowBox = s end)
Island:AddToggle("方框填充", true, function(s) EspConf.ShowBoxFill = s end)
Island:AddToggle("显示名字", true, function(s) EspConf.ShowName = s end)
Island:AddToggle("显示距离", true, function(s) EspConf.ShowDistance = s end)
Island:AddToggle("显示血条", true, function(s) EspConf.ShowHealthBar = s end)
Island:AddToggle("显示血量百分比", true, function(s) EspConf.ShowHealthText = s end)
Island:AddToggle("显示高亮 (Chams)", false, function(s) EspConf.ShowChams = s end)
Island:AddToggle("显示追踪线", false, function(s) EspConf.ShowTracer = s end)
Island:AddToggle("血量变色", true, function(s) EspConf.HealthBasedColor = s end)
Island:AddSlider("方框粗细", 1, 5, 2, function(v) EspConf.BoxThickness = v end)
Island:AddSlider("血条宽度", 1, 8, 3, function(v) EspConf.HealthBarWidth = v end)
Island:AddInput("追踪线起点(顶部/底部)", "底部", function(txt)
    EspConf.TracerOrigin = (txt == "顶部" or txt == "Top") and "Top" or "Bottom"
end)

local TabChar = Island:AddTab("人物")
Island:SelectTab(TabChar)
Island:AddToggle("移动加速", false, function(s) setSpeed(s, SpeedMultiplier) end)
Island:AddSlider("加速倍率", 1, 10, 2, function(v)
    SpeedMultiplier = v
    if SpeedEnabled then setSpeed(true, v) end
end)
Island:AddToggle("防卡", false, function(s) setAntiLag(s) end)
Island:AddToggle("飞行", false, function(s)
    FLY_TOGGLE_STATE = s
    if s then applyFly(); Notify("飞行", "已开启")
    else NOFLY(); Notify("飞行", "已关闭") end
end)
Island:AddSlider("飞行速度", 1, 10, 2, function(v)
    iyflyspeed = v
    vehicleflyspeed = v
end)

local TabOrbit = Island:AddTab("环绕")
Island:SelectTab(TabOrbit)
Island:AddInput("环绕目标(最近/名字)", "最近", function(txt)
    LGTarget = (txt == "最近" or txt == "closest") and "closest" or txt
    LoopGotoCtrl.SelectedName = txt
end, "最近")
Island:AddInput("环绕按键", "NIL", function(txt) LGKb = txt end, "NIL")
Island:AddInput("快速环绕按键", "NIL", function(txt) QLGKb = txt end, "NIL")
Island:AddToggle("跟随已选玩家", false, function(v)
    if v then
        local n = LoopGotoCtrl.SelectedName
        local t = n and Players:FindFirstChild(n) or nil
        if t then LoopGotoCtrl.StartWithTarget(t, "selected") else Notify("环绕", "未选玩家") end
    else
        if LoopGotoCtrl.Mode == "selected" then LoopGotoCtrl.Stop() end
    end
end)
Island:AddToggle("快速环绕", false, function(v)
    if v then
        local n = findNearest()
        if n then LoopGotoCtrl.StartWithTarget(n, "quick") else Notify("环绕", "无玩家") end
    else
        if LoopGotoCtrl.Mode == "quick" then LoopGotoCtrl.Stop() end
    end
end)

local TabFarm = Island:AddTab("农场")
Island:SelectTab(TabFarm)
Island:AddToggle("自动杀戮（农场）", false, function(s)
    FarmEnabled = s
    if s then startFarm(); Notify("农场", "已开启")
    else stopFarm(); Notify("农场", "已关闭") end
end)

local TabHelper = Island:AddTab("Helper")
Island:SelectTab(TabHelper)
Island:AddToggle("延迟服务器 (Lagger)", false, function(s) setLagger(s) end)
Island:AddToggle("瞬开大招", false, function(s) setInstantTransformation(s) end)
Island:AddToggle("无限觉醒", false, function(s) setInfiniteUltimate(s) end)
Island:AddToggle("瞬时复活", false, function(s)
    InstantRespawnOn = s
    if s then start999Lives() else stop999Lives() end
    Notify("瞬时复活", s and "已开启" or "已关闭")
end)
Island:AddToggle("自动格挡", false, function(s) AutoBlockOn = s; Notify("自动格挡", s and "已开启" or "已关闭") end)
Island:AddToggle("反反击", false, function(s) AntiCounterOn = s; Notify("反反击", s and "已开启" or "已关闭") end)

local TabSLag = Island:AddTab("服务器延迟")
Island:SelectTab(TabSLag)
Island:AddToggle("服务器延迟 方法一", false, function(v)
    if v then
        sl1On = true
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if h then sl1Pos = h.CFrame; h.CollisionGroup = "None" end
        task.spawn(function()
            while sl1On do
                local c = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if c then
                    pcall(function()
                        DashRemote:FireServer(unpack({[1]=CFrame.new(0,0,0), [2]="R", [3]=nil, [5]=nil}))
                    end)
                    task.wait()
                    c.CFrame = CFrame.new(870, 4.6, 460)
                    task.wait()
                    c.CFrame = CFrame.new(9e9, 4.6, 9e9)
                else task.wait() end
            end
        end)
        Notify("延迟方法一", "已开启")
    else
        sl1On = false
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if h then
            h.CFrame = CFrame.new(0, -120, 0)
            task.wait(0.2)
            if sl1Pos then h.CFrame = sl1Pos end
            h.CollisionGroup = "Characters"
        end
        Notify("延迟方法一", "已关闭")
    end
end)
Island:AddToggle("服务器延迟 方法二", false, function(v)
    if v then
        sl2On = true
        sl2Conn = RunService.Heartbeat:Connect(function() if sl2On then pcall(laggerMethod2) end end)
        Notify("延迟方法二", "已开启")
    else
        sl2On = false
        if sl2Conn then sl2Conn:Disconnect(); sl2Conn = nil end
        Notify("延迟方法二", "已关闭")
    end
end)
Island:AddToggle("反服务器延迟", false, function(v)
    if v then
        aslOn = true
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                aslCache[p] = {isPhantom=false, ot={}}
                p.CharacterAdded:Connect(function() task.wait(1); aslCache[p] = {isPhantom=false, ot={}} end)
            end
        end
        Players.PlayerAdded:Connect(function(p)
            if p ~= LocalPlayer then
                aslCache[p] = {isPhantom=false, ot={}}
                p.CharacterAdded:Connect(function() task.wait(1); aslCache[p] = {isPhantom=false, ot={}} end)
            end
        end)
        Players.PlayerRemoving:Connect(function(p) aslCache[p] = nil end)
        aslConn = RunService.RenderStepped:Connect(updateAntiSL)
        Notify("反服务器延迟", "已开启")
    else
        aslOn = false
        if aslConn then aslConn:Disconnect(); aslConn = nil end
        for p, d in pairs(aslCache) do if d.isPhantom and p.Character then restorePlayer(p, p.Character) end end
        aslCache = {}
        Notify("反服务器延迟", "已关闭")
    end
end)

local TabUtil = Island:AddTab("实用")
Island:SelectTab(TabUtil)
Island:AddButton("重进服务器", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
    Notify("服务器", "正在重进")
end)
Island:AddButton("服务器跳转", function()
    local ok, s = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if not ok then Notify("失败", "获取服务器失败"); return end
    local v = {}
    for _, x in pairs(s.data or {}) do
        if x.playing < x.maxPlayers and x.id ~= game.JobId then table.insert(v, x.id) end
    end
    if #v > 0 then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, v[math.random(#v)], LocalPlayer)
        Notify("服务器", "正在跳转")
    else
        Notify("失败", "无可用服务器")
    end
end)

Island:SelectTab(TabCombat)
Island:Notify("xtal", "加载完毕", 3)

print("xtal 脚本加载完毕")
