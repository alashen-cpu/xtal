local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local HttpService       = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService   = game:GetService("TeleportService")
local Lighting          = game:GetService("Lighting")
local CoreGui           = game:GetService("CoreGui")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================
-- [0] 加载动画
-- ============================================================
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "xtalLoading"
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true
LoadingGui.DisplayOrder = 9999
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() LoadingGui.Parent = CoreGui end)
if not LoadingGui.Parent then LoadingGui.Parent = playerGui end

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
-- [1] 加载 MoonLua UI
-- ============================================================
local UI_URL = "https://sikon.226618.xyz/moon lua UI源码.lua"

local ok, Library = pcall(function()
    return loadstring(game:HttpGet(UI_URL))()
end)

if not ok or type(Library) ~= "table" then
    warn("[xtal] UI 库加载失败: " .. tostring(Library))
    return
end

local Window = Library:CreateWindow({
    Name              = "xtal",
    Title             = "xtal_script",
    Version           = "v1.0",
    Theme             = "Nord",
    Backdrop          = true,
    ShowBackdrop      = true,
    GradientAnimation = true,
    ConfigFolder      = "xtal",
    SearchTab         = false,
    Visible           = true,
})

local function Notify(title, content)
    pcall(function()
        Window:Notify({ Title = title, Content = content, Duration = 3 })
    end)
end

-- ============================================================
-- [2] 服务与远程引用
-- ============================================================
local Core, CharValue, AbilityRemote, ActionRemote, DashRemote
pcall(function() Core = require(ReplicatedStorage:WaitForChild("Core", 3)) end)
pcall(function()
    local D = player:WaitForChild("Data", 3)
    if D then CharValue = D:WaitForChild("Character", 3) end
end)
pcall(function() AbilityRemote = ReplicatedStorage:WaitForChild("Remotes", 3):WaitForChild("Abilities", 3):WaitForChild("Ability", 3) end)
pcall(function() ActionRemote = ReplicatedStorage:WaitForChild("Remotes", 3):WaitForChild("Combat", 3):WaitForChild("Action", 3) end)
pcall(function() DashRemote = ReplicatedStorage:WaitForChild("Remotes", 3):WaitForChild("Character", 3):WaitForChild("Dash", 3) end)

local function getRoot(c) return c and c:FindFirstChild("HumanoidRootPart") end
local function getLRoot() return getRoot(player.Character) end

local IgFriend = false
local lastDash = 0
local function dash()
    if not DashRemote then return end
    local n = tick()
    if n - lastDash < 0.2 then return end
    lastDash = n
    local h = getLRoot()
    if not h then return end
    pcall(function() DashRemote:FireServer(h.CFrame, "L", h.CFrame.LookVector, nil, n) end)
end

-- ============================================================
-- [3] 光环逻辑
-- ============================================================
local function sendWCA(targets)
    if not CharValue or not AbilityRemote or not ActionRemote then return end
    if #targets == 0 then return end
    local combo
    pcall(function() combo = ReplicatedStorage.Characters[CharValue.Value].WallCombo end)
    if not combo then return end
    local hl = {}
    for _, c in ipairs(targets) do
        for i = 1, 20 do table.insert(hl, c) end
    end
    pcall(function() AbilityRemote:FireServer(combo, 69) end)
    pcall(function()
        ActionRemote:FireServer(combo, "", 4, 69, {
            BestHitCharacter = nil,
            HitCharacters = hl,
            Ignore = {},
            Actions = {},
        })
    end)
end

local function getTIR(rng)
    local root = getLRoot()
    if not root then return {} end
    local ts = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local skip = false
            if IgFriend then
                local ok2, isF = pcall(function() return player:IsFriendsWith(p.UserId) end)
                if ok2 and isF then skip = true end
            end
            if not skip then
                local tr = getRoot(p.Character)
                local h = p.Character:FindFirstChild("Humanoid")
                if tr and h and h.Health > 0 then
                    if (tr.Position - root.Position).Magnitude <= rng then
                        if not p.Character:GetAttribute("Invincible") then
                            table.insert(ts, p.Character)
                        end
                    end
                end
            end
        end
    end
    return ts
end

local A1Range = 100
local A1C
local function SetAura1(s)
    if A1C then A1C:Disconnect(); A1C = nil end
    if s then
        A1C = RunService.Heartbeat:Connect(function()
            dash()
            sendWCA(getTIR(A1Range))
        end)
        Notify("杀戮光环 v3", "已开启")
    else
        Notify("杀戮光环 v3", "已关闭")
    end
end

local A2Range = 70
local A2C
local A2List, A2I = {}, 1
local A2LastDash = 0
local function SetAura2(s)
    if A2C then A2C:Disconnect(); A2C = nil end
    if s then
        A2C = RunService.Heartbeat:Connect(function()
            local cnt = (CharValue and CharValue.Value == "Gon") and 20 or 50
            local h = getLRoot()
            if not h then return end
            if tick() - A2LastDash > 0.25 then
                A2LastDash = tick()
                pcall(function() DashRemote:FireServer(h.CFrame, "L", h.CFrame.LookVector, nil, tick()) end)
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local skip = false
                    if IgFriend then
                        local ok2, isF = pcall(function() return player:IsFriendsWith(p.UserId) end)
                        if ok2 and isF then skip = true end
                    end
                    if not skip then
                        local hu = p.Character:FindFirstChild("Humanoid")
                        local rt = p.Character:FindFirstChild("HumanoidRootPart")
                        if hu and rt and hu.Health > 0 and (rt.Position - h.Position).Magnitude <= A2Range then
                            if not p.Character:GetAttribute("Invincible") then
                                for i = 1, cnt do
                                    A2List[A2I] = p.Character
                                    A2I = A2I + 1
                                end
                            end
                        end
                    end
                end
            end
            if A2I > 1 then
                local combo
                pcall(function() combo = ReplicatedStorage.Characters[CharValue.Value].WallCombo end)
                if combo then
                    pcall(function()
                        AbilityRemote:FireServer(combo, 69)
                        ActionRemote:FireServer(combo, "", 4, 69, {
                            BestHitCharacter = nil,
                            HitCharacters = A2List,
                            Ignore = {},
                            Actions = {},
                        })
                    end)
                end
                table.clear(A2List)
                A2I = 1
            end
        end)
        Notify("杀戮光环 v3+", "已开启")
    else
        Notify("杀戮光环 v3+", "已关闭")
    end
end

local A4Range = 100
local A4Density = 30
local A4Interval = 0.2
local A4C
local A4LastDash = 0
local function aura4Collect()
    local h = getLRoot()
    if not h then return {} end
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local skip = false
            if IgFriend then
                local ok2, isF = pcall(function() return player:IsFriendsWith(p.UserId) end)
                if ok2 and isF then skip = true end
            end
            if not skip then
                local hu = p.Character:FindFirstChild("Humanoid")
                local rt = p.Character:FindFirstChild("HumanoidRootPart")
                if hu and rt and hu.Health > 0 and (rt.Position - h.Position).Magnitude <= A4Range then
                    if not p.Character:GetAttribute("Invincible") then
                        table.insert(list, p.Character)
                    end
                end
            end
        end
    end
    return list
end
local function SetAura4(s)
    if A4C then A4C:Disconnect(); A4C = nil end
    if s then
        A4C = RunService.Heartbeat:Connect(function()
            if not AbilityRemote or not ActionRemote or not CharValue then return end
            local h = getLRoot()
            if not h then return end
            if tick() - A4LastDash > A4Interval then
                A4LastDash = tick()
                pcall(function() DashRemote:FireServer(h.CFrame, "L", h.CFrame.LookVector, nil, tick()) end)
            end
            local targets = aura4Collect()
            if #targets == 0 then return end
            local combo
            pcall(function() combo = ReplicatedStorage.Characters[CharValue.Value].WallCombo end)
            if not combo then return end
            local hl = {}
            for _, c in ipairs(targets) do
                for i = 1, A4Density do table.insert(hl, c) end
            end
            pcall(function() AbilityRemote:FireServer(combo, 69) end)
            pcall(function()
                ActionRemote:FireServer(combo, "", 4, 69, {
                    BestHitCharacter = nil,
                    HitCharacters = hl,
                    Ignore = {},
                    Actions = {},
                })
            end)
        end)
        Notify("杀戮光环 v4", "已开启")
    else
        Notify("杀戮光环 v4", "已关闭")
    end
end

local A5Range = 150
local A5Density = 60
local A5Interval = 0.12
local A5C
local A5LastDash = 0
local function aura5Collect()
    local h = getLRoot()
    if not h then return {} end
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local skip = false
            if IgFriend then
                local ok2, isF = pcall(function() return player:IsFriendsWith(p.UserId) end)
                if ok2 and isF then skip = true end
            end
            if not skip then
                local hu = p.Character:FindFirstChild("Humanoid")
                local rt = p.Character:FindFirstChild("HumanoidRootPart")
                if hu and rt and hu.Health > 0 and (rt.Position - h.Position).Magnitude <= A5Range then
                    if not p.Character:GetAttribute("Invincible") then
                        table.insert(list, p.Character)
                    end
                end
            end
        end
    end
    return list
end
local function SetAura5(s)
    if A5C then A5C:Disconnect(); A5C = nil end
    if s then
        A5C = RunService.Heartbeat:Connect(function()
            if not AbilityRemote or not ActionRemote or not CharValue then return end
            local h = getLRoot()
            if not h then return end
            if tick() - A5LastDash > A5Interval then
                A5LastDash = tick()
                pcall(function() DashRemote:FireServer(h.CFrame, "L", h.CFrame.LookVector, nil, tick()) end)
            end
            local targets = aura5Collect()
            if #targets == 0 then return end
            local combo
            pcall(function() combo = ReplicatedStorage.Characters[CharValue.Value].WallCombo end)
            if not combo then return end
            local hl = {}
            for _, c in ipairs(targets) do
                for i = 1, A5Density do table.insert(hl, c) end
            end
            pcall(function() AbilityRemote:FireServer(combo, 69) end)
            pcall(function()
                ActionRemote:FireServer(combo, "", 4, 69, {
                    BestHitCharacter = nil,
                    HitCharacters = hl,
                    Ignore = {},
                    Actions = {},
                })
            end)
        end)
        Notify("杀戮光环 v4+", "已开启")
    else
        Notify("杀戮光环 v4+", "已关闭")
    end
end

local W1Range = 100
local W1Interval = 0
local W1LastT = 0
local W1C
local function SetWC1(s)
    if W1C then W1C:Disconnect(); W1C = nil end
    if s then
        W1C = RunService.Heartbeat:Connect(function()
            if not Core then return end
            local h = player.Character and player.Character:FindFirstChild("Head")
            if not h then return end
            local n = tick()
            if W1Interval > 0 and n - W1LastT < W1Interval then return end
            local ht = false
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local tr = getRoot(p.Character)
                    if tr and (tr.Position - h.Position).Magnitude <= W1Range then
                        ht = true
                        break
                    end
                end
            end
            if not ht then return end
            W1LastT = n
            local hr = Core.Get("Combat", "Hit").Box(nil, player.Character, { Size = Vector3.new(W1Range, W1Range, W1Range) })
            if not hr then return end
            local ab
            pcall(function() ab = ReplicatedStorage.Characters[CharValue.Value].WallCombo end)
            if not ab then return end
            pcall(function()
                Core.Get("Combat", "Ability").Activate(ab, hr, h.Position + Vector3.new(0, 0, 2.5))
            end)
        end)
        Notify("墙打光环 v3", "已开启")
    else
        Notify("墙打光环 v3", "已关闭")
    end
end

local W2Range = 100
local W2Interval = 0.05
local W2LastT, W2LastDash = 0, 0
local W2C, W2DC
local function wcV2Has(rng)
    local h = player.Character and player.Character:FindFirstChild("Head")
    if not h then return false end
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            if (pl.Character.HumanoidRootPart.Position - h.Position).Magnitude <= rng then
                return true
            end
        end
    end
    return false
end
local function wcV2Exec()
    if not Core then return end
    local h = player.Character and player.Character:FindFirstChild("Head")
    if not h then return end
    local n = tick()
    if n - W2LastT < W2Interval then return end
    if not wcV2Has(W2Range) then return end
    W2LastT = n
    local res
    local ok2 = pcall(function()
        res = Core.Get("Combat", "Hit").Box(nil, player.Character, { Size = Vector3.new(W2Range, W2Range, W2Range) })
    end)
    if not ok2 or not res then return end
    local combo
    pcall(function() combo = ReplicatedStorage.Characters[CharValue.Value].WallCombo end)
    if not combo then return end
    pcall(function()
        Core.Get("Combat", "Ability").Activate(combo, res, h.Position + Vector3.new(0, 0, 2.5))
    end)
end
local function SetWC2(s)
    if W2C then W2C:Disconnect(); W2C = nil end
    if W2DC then W2DC:Disconnect(); W2DC = nil end
    if s then
        W2C = RunService.Heartbeat:Connect(wcV2Exec)
        W2DC = RunService.Heartbeat:Connect(function()
            local h = getLRoot()
            if not h then return end
            local n = tick()
            if n - W2LastDash < W2Interval then return end
            W2LastDash = n
            pcall(function() DashRemote:FireServer(h.CFrame, "F", h.CFrame.LookVector, nil, n) end)
        end)
        Notify("墙打光环 v3+", "已开启")
    else
        Notify("墙打光环 v3+", "已关闭")
    end
end

local W4Range = 150
local W4Interval = 0.03
local W4IgnoreNPC = false
local W4C, W4DC
local W4LastT, W4LastDash = 0, 0
local function wcV4Collect()
    local h = player.Character and player.Character:FindFirstChild("Head")
    if not h then return {} end
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local skip = false
            if IgFriend then
                local ok2, isF = pcall(function() return player:IsFriendsWith(p.UserId) end)
                if ok2 and isF then skip = true end
            end
            if not skip then
                local tr = getRoot(p.Character)
                local hu = p.Character:FindFirstChild("Humanoid")
                if tr and hu and hu.Health > 0 then
                    if (tr.Position - h.Position).Magnitude <= W4Range then
                        if not p.Character:GetAttribute("Invincible") then
                            table.insert(list, p.Character)
                        end
                    end
                end
            end
        end
    end
    return list
end
local function wcV4Exec()
    if not Core or not CharValue then return end
    local h = player.Character and player.Character:FindFirstChild("Head")
    if not h then return end
    local n = tick()
    if n - W4LastT < W4Interval then return end
    W4LastT = n
    local targets = wcV4Collect()
    if #targets == 0 then return end
    local combo
    pcall(function() combo = ReplicatedStorage.Characters[CharValue.Value].WallCombo end)
    if not combo then return end
    if W4IgnoreNPC then
        local hl = {}
        for _, c in ipairs(targets) do
            for i = 1, 20 do table.insert(hl, c) end
        end
        local an = "Action" .. math.random(1000, 9999)
        local rid = math.random(100000, 999999)
        pcall(function() AbilityRemote:FireServer(combo, rid) end)
        pcall(function()
            ActionRemote:FireServer(combo, "Characters:" .. CharValue.Value .. ":WallCombo", 1, rid, {
                HitboxCFrames = { nil },
                BestHitCharacter = targets[1],
                HitCharacters = hl,
                Ignore = { [an] = {} },
                DeathInfo = {},
                Actions = { [an] = {} },
                HitInfo = { Blocked = false, IsFacing = true, IsInFront = true },
                BlockedCharacters = {},
                ServerTime = tick(),
                FromCFrame = nil,
            }, an)
        end)
    else
        local res
        local ok2 = pcall(function()
            res = Core.Get("Combat", "Hit").Box(nil, player.Character, { Size = Vector3.new(W4Range, W4Range, W4Range) })
        end)
        if not ok2 or not res then return end
        pcall(function()
            Core.Get("Combat", "Ability").Activate(combo, res, h.Position + Vector3.new(0, 0, 2.5))
        end)
    end
end

local hideWallAnim   = false
local hideWallAnimV4 = false
local wallAnimIds = {
    ["rbxassetid://15853335966"] = true,
    ["rbxassetid://17561546657"] = true,
}

local function refreshWallAnims()
    wallAnimIds = {
        ["rbxassetid://15853335966"] = true,
        ["rbxassetid://17561546657"] = true,
    }
    pcall(function()
        local cn = CharValue and CharValue.Value
        if not cn then return end
        local cf = ReplicatedStorage:FindFirstChild("Characters")
        if not cf then return end
        local charFolder = cf:FindFirstChild(cn)
        if not charFolder then return end
        local wc = charFolder:FindFirstChild("WallCombo")
        if not wc then return end
        if wc:IsA("Animation") and wc.AnimationId and wc.AnimationId ~= "" then
            wallAnimIds[wc.AnimationId] = true
        end
        for _, v in ipairs(wc:GetDescendants()) do
            if v:IsA("Animation") and v.AnimationId and v.AnimationId ~= "" then
                wallAnimIds[v.AnimationId] = true
            end
        end
    end)
end

local function shouldHideAnim()
    return hideWallAnim or hideWallAnimV4
end

local function stopMatchingAnims()
    if not shouldHideAnim() then return end
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return end
    local ok2, tracks = pcall(function() return animator:GetPlayingAnimationTracks() end)
    if not ok2 then return end
    for _, track in ipairs(tracks) do
        local ok3, anim = pcall(function() return track.Animation end)
        if ok3 and anim and anim.AnimationId and wallAnimIds[anim.AnimationId] then
            pcall(function() track:Stop(0) end)
        end
    end
end

RunService.Heartbeat:Connect(stopMatchingAnims)

local function hookHideWallAnim(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = humanoid:WaitForChild("Animator", 5)
    end
    if not animator then return end
    animator.AnimationPlayed:Connect(function(track)
        if not shouldHideAnim() then return end
        local anim = track.Animation
        if not anim then return end
        if anim.AnimationId and wallAnimIds[anim.AnimationId] then
            pcall(function() track:Stop(0) end)
        end
    end)
end

player.CharacterAdded:Connect(function(char)
    refreshWallAnims()
    task.wait(0.1)
    hookHideWallAnim(char)
end)

if player.Character then
    refreshWallAnims()
    hookHideWallAnim(player.Character)
end

if CharValue then
    CharValue.Changed:Connect(function()
        refreshWallAnims()
        task.wait(0.1)
        if player.Character then hookHideWallAnim(player.Character) end
    end)
end

local wc4PrevHideAnim = false

local function SetWC4(s)
    if W4C then W4C:Disconnect(); W4C = nil end
    if W4DC then W4DC:Disconnect(); W4DC = nil end
    if s then
        wc4PrevHideAnim = hideWallAnimV4
        hideWallAnimV4  = true
        W4C = RunService.Heartbeat:Connect(wcV4Exec)
        W4DC = RunService.Heartbeat:Connect(function()
            local h = getLRoot()
            if not h then return end
            if not player.Character then return end
            local head = player.Character:FindFirstChild("Head")
            if not head then return end
            local near = false
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local tr = getRoot(p.Character)
                    if tr and (tr.Position - head.Position).Magnitude <= W4Range then
                        near = true
                        break
                    end
                end
            end
            if not near then return end
            local n = tick()
            if n - W4LastDash < W4Interval * 2 then return end
            W4LastDash = n
            pcall(function() DashRemote:FireServer(h.CFrame, "F", h.CFrame.LookVector, nil, n) end)
        end)
        Notify("墙打光环 v4", "已开启")
    else
        hideWallAnimV4 = wc4PrevHideAnim
        Notify("墙打光环 v4", "已关闭")
    end
end

UserInputService.InputBegan:Connect(function(inp, pr)
    if pr then return end
    if inp.KeyCode == Enum.KeyCode.E then wcV2Exec() end
end)

local WudiE = false
task.spawn(function()
    while task.wait(0.01) do
        if WudiE and AbilityRemote and ActionRemote and CharValue then
            pcall(function()
                local pc = player.Character
                if not pc then return end
                local cn = CharValue.Value
                if not cn then return end
                local cf = ReplicatedStorage:FindFirstChild("Characters")
                if not cf or not cf:FindFirstChild(cn) then return end
                local ab = cf[cn]:FindFirstChild("WallCombo")
                if not ab then return end
                local an = "Action" .. math.random(1000, 9999)
                local rid = math.random(100000, 999999)
                local args = {
                    ab, "Characters:" .. cn .. ":WallCombo", 1, rid,
                    {
                        HitboxCFrames = { nil },
                        BestHitCharacter = pc,
                        HitCharacters = { pc },
                        Ignore = { [an] = { pc } },
                        DeathInfo = {},
                        Actions = { [an] = {} },
                        HitInfo = { Blocked = false, IsFacing = true, IsInFront = true },
                        BlockedCharacters = {},
                        ServerTime = tick(),
                        FromCFrame = nil,
                    },
                    an,
                }
                AbilityRemote:FireServer(ab, rid)
                ActionRemote:FireServer(unpack(args))
            end)
        end
    end
end)

-- ============================================================
-- [4] 瞬时复活
-- ============================================================
local InstantRespawnOn = false
local savedPosition = nil
local healthWatcher = nil
local respawnHandler = nil
local hasTriggered = false

_G.Lives999TeleportDelay = 0.2

local function hasReplicateSignal()
    return type(replicatesignal) == "function"
end

local function instantReset()
    local character = player.Character
    if not character then return end
    if hasReplicateSignal() then
        replicatesignal(player.Kill)
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
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            if humanoid and rootPart then
                local healthStr = tostring(math.floor(humanoid.Health))
                if string.sub(healthStr, 1, 1) == "0" and not hasTriggered then
                    hasTriggered = true
                    if char:GetAttribute("Grabbed") then
                        task.spawn(function()
                            while char and char:GetAttribute("Grabbed") do task.wait(0.1) end
                            local currentRootPart = char:FindFirstChild("HumanoidRootPart")
                            if currentRootPart then
                                savedPosition = currentRootPart.CFrame
                                instantReset()
                            end
                        end)
                    else
                        savedPosition = rootPart.CFrame
                        instantReset()
                    end
                elseif string.sub(healthStr, 1, 1) ~= "0" then
                    hasTriggered = false
                end
            end
        end
    end)
    respawnHandler = player.CharacterAdded:Connect(function(char)
        if not InstantRespawnOn or not savedPosition then return end
        local rootPart = char:WaitForChild("HumanoidRootPart", 5)
        if not rootPart then return end
        local delay = _G.Lives999TeleportDelay or 0.2
        task.wait(delay)
        pcall(function()
            require(player.PlayerScripts.Character.FullCustomReplication).Override(char, savedPosition)
        end)
        savedPosition = nil
    end)
end

-- ============================================================
-- [5] Hitbox
-- ============================================================
local origBox
local HB = { X = 40, Y = 40, Z = 40, M = "Override", V = false }
local function applyHB(on)
    if not Core then return end
    local cb
    local ok2 = pcall(function() cb = Core.Get("Combat", "Hit") end)
    if not ok2 or not cb then return end
    if on then
        if not origBox then origBox = cb.Box end
        if not origBox then return end
        cb.Box = function(...)
            local a = { ... }
            if not a[3] or type(a[3]) ~= "table" then return origBox(...) end
            local sz
            if HB.M == "Add" then
                local o = a[3].Size or Vector3.new()
                sz = Vector3.new(o.X + HB.X, o.Y + HB.Y, o.Z + HB.Z)
            else
                sz = Vector3.new(HB.X, HB.Y, HB.Z)
            end
            local bt, vt = origBox(a[1], a[2], { Size = sz })
            return bt, vt
        end
    elseif origBox then
        cb.Box = origBox
    end
end

-- ============================================================
-- [6] 透视
-- ============================================================
local EspD = {}
local EspC, EspUC = nil, nil
local EspConf = {
    TeamCheck = false, FriendCheck = false,
    ShowName = true, ShowDistance = true,
    ShowHealthBar = true, ShowHealthText = true,
    ShowBox = true, ShowBoxFill = true,
    ShowChams = false, ShowTracer = false,
    MaxDistance = 1000, BoxThickness = 2, HealthBarWidth = 3,
    BoxFillColor = Color3.fromRGB(0, 0, 0),
    BoxFillTransparency = 0.5,
    ChamsColor = Color3.fromRGB(255, 0, 0),
    ChamsOutlineColor = Color3.fromRGB(255, 255, 255),
    ChamsTransparency = 0.5,
    TracerColor = Color3.fromRGB(255, 255, 255),
    TracerOrigin = "Bottom", HealthBasedColor = true,
}

local function makeEsp(p)
    if p == player or EspD[p] or not Drawing then return end
    local d = {}
    d.B = Drawing.new("Square"); d.B.Thickness = 2; d.B.Filled = false; d.B.Transparency = 1; d.B.Visible = false
    d.BF = Drawing.new("Square"); d.BF.Thickness = 1; d.BF.Filled = true; d.BF.Transparency = 0.5; d.BF.Visible = false
    d.N = Drawing.new("Text"); d.N.Size = 13; d.N.Center = true; d.N.Outline = true; d.N.OutlineColor = Color3.fromRGB(0, 0, 0); d.N.Visible = false
    d.D = Drawing.new("Text"); d.D.Size = 12; d.D.Center = true; d.D.Outline = true; d.D.OutlineColor = Color3.fromRGB(0, 0, 0); d.D.Visible = false
    d.HBg = Drawing.new("Square"); d.HBg.Thickness = 1; d.HBg.Color = Color3.fromRGB(0, 0, 0); d.HBg.Filled = true; d.HBg.Transparency = 0.5; d.HBg.Visible = false
    d.HB2 = Drawing.new("Square"); d.HB2.Thickness = 1; d.HB2.Filled = true; d.HB2.Transparency = 1; d.HB2.Visible = false
    d.HT = Drawing.new("Text"); d.HT.Size = 10; d.HT.Center = true; d.HT.Outline = true; d.HT.OutlineColor = Color3.fromRGB(0, 0, 0); d.HT.Visible = false
    d.Tr = Drawing.new("Line"); d.Tr.Thickness = 1; d.Tr.Transparency = 1; d.Tr.Visible = false
    local Ch = Instance.new("Highlight")
    Ch.FillColor = EspConf.ChamsColor
    Ch.OutlineColor = EspConf.ChamsOutlineColor
    Ch.FillTransparency = 0.5
    Ch.OutlineTransparency = 0
    Ch.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Ch.Adornee = nil
    Ch.Parent = workspace
    Ch.Enabled = false
    d.Ch = Ch
    EspD[p] = d
end

local function getSB(c)
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local mnX, mnY, mxX, mxY = math.huge, math.huge, -math.huge, -math.huge
    local av = false
    for _, pt in ipairs(c:GetDescendants()) do
        if pt:IsA("BasePart") and pt.Transparency < 1 then
            local ps, on = cam:WorldToViewportPoint(pt.Position)
            if on then
                av = true
                mnX = math.min(mnX, ps.X); mnY = math.min(mnY, ps.Y)
                mxX = math.max(mxX, ps.X); mxY = math.max(mxY, ps.Y)
            end
        end
    end
    if not av then return nil end
    return {
        MinX = mnX, MinY = mnY, MaxX = mxX, MaxY = mxY,
        Width = mxX - mnX, Height = mxY - mnY,
        CenterX = (mnX + mxX) / 2, CenterY = (mnY + mxY) / 2,
    }
end

local function updateEsp()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vs = cam.ViewportSize
    local bc = Vector2.new(vs.X / 2, vs.Y)
    for p, d in pairs(EspD) do
        local c = p and p.Character
        local hu = c and c:FindFirstChildOfClass("Humanoid")
        local rt = c and c:FindFirstChild("HumanoidRootPart")
        local show = hu and hu.Health > 0 and rt
        if show and EspConf.TeamCheck and p.Team == player.Team then show = false end
        if show and EspConf.FriendCheck then
            local ok2, isF = pcall(function() return player:IsFriendsWith(p.UserId) end)
            if ok2 and isF then show = false end
        end
        if show then
            local dist = (cam.CFrame.Position - rt.Position).Magnitude
            local b = getSB(c)
            if b and b.Width > 0 and b.Height > 0 and dist <= EspConf.MaxDistance then
                local hp = hu.Health / hu.MaxHealth
                local col = Color3.fromRGB(255, 255, 255)
                if EspConf.HealthBasedColor then
                    if hp > 0.5 then col = Color3.fromRGB(0, 255, 0)
                    elseif hp > 0.25 then col = Color3.fromRGB(255, 255, 0)
                    else col = Color3.fromRGB(255, 0, 0) end
                end
                if EspConf.ShowBox then
                    d.B.Position = Vector2.new(b.MinX, b.MinY)
                    d.B.Size = Vector2.new(b.Width, b.Height)
                    d.B.Color = col
                    d.B.Thickness = EspConf.BoxThickness
                    d.B.Visible = true
                else d.B.Visible = false end
                if EspConf.ShowBoxFill then
                    d.BF.Position = Vector2.new(b.MinX + 1, b.MinY + 1)
                    d.BF.Size = Vector2.new(b.Width - 2, b.Height - 2)
                    d.BF.Color = EspConf.BoxFillColor
                    d.BF.Transparency = EspConf.BoxFillTransparency
                    d.BF.Visible = true
                else d.BF.Visible = false end
                if EspConf.ShowName then
                    d.N.Text = p.Name
                    d.N.Position = Vector2.new(b.CenterX, b.MinY - 16)
                    d.N.Visible = true
                else d.N.Visible = false end
                if EspConf.ShowDistance then
                    d.D.Text = "[" .. math.floor(dist) .. "m]"
                    d.D.Position = Vector2.new(b.CenterX, b.MaxY + 4)
                    d.D.Visible = true
                else d.D.Visible = false end
                if EspConf.ShowHealthBar then
                    d.HBg.Position = Vector2.new(b.MinX - EspConf.HealthBarWidth - 2, b.MinY)
                    d.HBg.Size = Vector2.new(EspConf.HealthBarWidth, b.Height)
                    d.HBg.Visible = true
                    d.HB2.Position = Vector2.new(b.MinX - EspConf.HealthBarWidth - 2, b.MaxY - b.Height * hp)
                    d.HB2.Size = Vector2.new(EspConf.HealthBarWidth, b.Height * hp)
                    d.HB2.Color = col
                    d.HB2.Visible = true
                else
                    d.HBg.Visible = false
                    d.HB2.Visible = false
                end
                if EspConf.ShowHealthText then
                    d.HT.Text = math.floor(hp * 100) .. "%"
                    d.HT.Color = col
                    d.HT.Position = Vector2.new(b.MinX - EspConf.HealthBarWidth - 12, b.CenterY)
                    d.HT.Visible = true
                else d.HT.Visible = false end
                if EspConf.ShowChams then
                    d.Ch.Adornee = c
                    d.Ch.FillColor = EspConf.ChamsColor
                    d.Ch.OutlineColor = EspConf.ChamsOutlineColor
                    d.Ch.FillTransparency = EspConf.ChamsTransparency
                    d.Ch.Enabled = true
                else d.Ch.Enabled = false end
                if EspConf.ShowTracer then
                    local org = EspConf.TracerOrigin == "Top" and Vector2.new(bc.X, 0) or bc
                    d.Tr.From = org
                    d.Tr.To = Vector2.new(b.CenterX, b.CenterY)
                    d.Tr.Color = EspConf.TracerColor
                    d.Tr.Visible = true
                else d.Tr.Visible = false end
            else
                for _, v in pairs(d) do
                    if type(v) == "userdata" and v.Visible ~= nil then v.Visible = false end
                end
                d.Ch.Enabled = false
            end
        else
            for _, v in pairs(d) do
                if type(v) == "userdata" and v.Visible ~= nil then v.Visible = false end
            end
            d.Ch.Enabled = false
        end
    end
end

local function startEsp()
    for _, p in ipairs(Players:GetPlayers()) do makeEsp(p) end
    EspC = Players.PlayerAdded:Connect(function(p)
        task.wait(1)
        makeEsp(p)
    end)
    EspUC = RunService.RenderStepped:Connect(updateEsp)
end

local function stopEsp()
    if EspC then EspC:Disconnect(); EspC = nil end
    if EspUC then EspUC:Disconnect(); EspUC = nil end
    for _, d in pairs(EspD) do
        for _, v in pairs(d) do
            pcall(function()
                if type(v) == "userdata" and v.Remove then v:Remove()
                elseif v and v.Destroy then v:Destroy() end
            end)
        end
    end
    EspD = {}
end

-- ============================================================
-- [7] 移动/防卡/飞行/环绕/延迟
-- ============================================================
local ALOn, ALC = false, nil
local function setAL(s)
    ALOn = s
    if s then
        if not ALC then
            ALC = task.spawn(function()
                while ALOn do
                    pcall(function()
                        for _, v in ipairs(workspace:GetDescendants()) do
                            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                                v.Enabled = false
                            end
                        end
                        Lighting.GlobalShadows = false
                        Lighting.FogEnd = 9e9
                    end)
                    task.wait(0.5)
                end
            end)
        end
        Notify("防卡", "已开启")
    else
        if ALC then task.cancel(ALC); ALC = nil end
        pcall(function()
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                    v.Enabled = true
                end
            end
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 1000
        end)
        Notify("防卡", "已关闭")
    end
end

local SpdE, SpdM, SpdC = false, 2, nil
local function setSpd(s, m)
    SpdE = s
    SpdM = m
    if s then
        if not SpdC then
            SpdC = RunService.RenderStepped:Connect(function(dt)
                if not SpdE then return end
                local c = player.Character
                if not c then return end
                local hu = c:FindFirstChildOfClass("Humanoid")
                local rt = c:FindFirstChild("HumanoidRootPart")
                if hu and rt and hu.MoveDirection.Magnitude > 0 then
                    rt.CFrame = rt.CFrame + hu.MoveDirection * ((SpdM - 1) * 16) * dt
                end
            end)
        end
        Notify("移动加速", "已开启 x" .. tostring(SpdM))
    else
        if SpdC then SpdC:Disconnect(); SpdC = nil end
        Notify("移动加速", "已关闭")
    end
end

local FLYING = false
local flyKD, flyKU, flyC
local iyfs = 2
local function flyRoot(c) return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") end

local function NOFLY()
    FLYING = false
    if flyKD then flyKD:Disconnect(); flyKD = nil end
    if flyKU then flyKU:Disconnect(); flyKU = nil end
    if flyC then flyC:Disconnect(); flyC = nil end
    local c = player.Character
    if c then
        local hu = c:FindFirstChildOfClass("Humanoid")
        local rt = flyRoot(c)
        if hu then hu.PlatformStand = false end
        if rt then
            for _, v in pairs(rt:GetChildren()) do
                if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
            end
        end
    end
end

local function sFLY()
    local c = player.Character or player.CharacterAdded:Wait()
    local hu = c:FindFirstChildOfClass("Humanoid") or c:WaitForChild("Humanoid")
    local rt = flyRoot(c)
    if not rt then return end
    if flyKD then flyKD:Disconnect() end
    if flyKU then flyKU:Disconnect() end
    if flyC then flyC:Disconnect() end
    local CT = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }
    local BG = Instance.new("BodyGyro")
    local BV = Instance.new("BodyVelocity")
    BG.P = 9e4
    BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BG.CFrame = rt.CFrame
    BG.Parent = rt
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.Parent = rt
    FLYING = true
    flyKD = UserInputService.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Keyboard then
            if inp.KeyCode == Enum.KeyCode.W then CT.F = iyfs end
            if inp.KeyCode == Enum.KeyCode.S then CT.B = -iyfs end
            if inp.KeyCode == Enum.KeyCode.A then CT.L = -iyfs end
            if inp.KeyCode == Enum.KeyCode.D then CT.R = iyfs end
            if inp.KeyCode == Enum.KeyCode.E then CT.Q = iyfs * 2 end
            if inp.KeyCode == Enum.KeyCode.Q then CT.E = -iyfs * 2 end
        end
    end)
    flyKU = UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Keyboard then
            if inp.KeyCode == Enum.KeyCode.W then CT.F = 0 end
            if inp.KeyCode == Enum.KeyCode.S then CT.B = 0 end
            if inp.KeyCode == Enum.KeyCode.A then CT.L = 0 end
            if inp.KeyCode == Enum.KeyCode.D then CT.R = 0 end
            if inp.KeyCode == Enum.KeyCode.E then CT.Q = 0 end
            if inp.KeyCode == Enum.KeyCode.Q then CT.E = 0 end
        end
    end)
    flyC = RunService.RenderStepped:Connect(function()
        if not FLYING then return end
        local cam = workspace.CurrentCamera
        local mv = Vector3.new(CT.L + CT.R, CT.Q + CT.E, CT.F + CT.B)
        pcall(function()
            local cm = require(player.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
            local m = cm:GetMoveVector()
            mv = Vector3.new(m.X * iyfs, mv.Y, -m.Z * iyfs)
        end)
        BV.Velocity = (cam.CFrame.RightVector * mv.X + Vector3.new(0, mv.Y, 0) + cam.CFrame.LookVector * mv.Z) * 50
        BG.CFrame = cam.CFrame
        hu.PlatformStand = true
    end)
end

-- 环绕
local LG = { SelectedName = nil, IsFollowing = false, Mode = nil, Target = nil, Conn = nil }
local LGT = "最近"
local LGK = "NIL"
local QLGK = "NIL"

local function findNear()
    local c = player.Character
    local r = c and c:FindFirstChild("HumanoidRootPart")
    if not r then return nil end
    local o = r.Position
    local n, bd = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - o).Magnitude
            if d < bd then bd, n = d, p end
        end
    end
    return n
end

LG.Stop = function()
    LG.IsFollowing = false
    LG.Target = nil
    LG.Mode = nil
    if LG.Conn then LG.Conn:Disconnect(); LG.Conn = nil end
    Notify("环绕", "已停止")
end

LG.StartWithTarget = function(t, m)
    if not t then return end
    LG.Target = t
    LG.Mode = m
    LG.IsFollowing = true
    if LG.Conn then LG.Conn:Disconnect() end
    LG.Conn = RunService.Heartbeat:Connect(function()
        if not LG.IsFollowing then return end
        local t2 = LG.Target
        if not t2 or not t2.Character or not t2.Character:FindFirstChild("HumanoidRootPart") then
            LG.IsFollowing = false
            if LG.Conn then LG.Conn:Disconnect(); LG.Conn = nil end
            return
        end
        local mc = player.Character
        if not mc then return end
        local cf = t2.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0.1, 4)
        pcall(function()
            require(player.PlayerScripts.Character.FullCustomReplication).Override(mc, cf)
        end)
    end)
    Notify("环绕", "跟随中: " .. t.Name)
end

UserInputService.InputBegan:Connect(function(inp, gp)
    if gp or not inp.KeyCode then return end
    if LGK ~= "NIL" and inp.KeyCode.Name == LGK then
        if not LG.IsFollowing then
            local t
            if LGT == "最近" or LGT == "closest" then
                t = findNear()
            else
                t = Players:FindFirstChild(LGT)
            end
            if t then LG.StartWithTarget(t, "selected") else Notify("环绕", "无目标") end
        else
            LG.Stop()
        end
    end
    if QLGK ~= "NIL" and inp.KeyCode.Name == QLGK then
        if not LG.IsFollowing or LG.Mode ~= "quick" then
            local n = findNear()
            if n then LG.StartWithTarget(n, "quick") end
        else
            LG.Stop()
        end
    end
end)

-- 服务器延迟方法二
local function lagger2()
    if not AbilityRemote or not ActionRemote or not CharValue then return end
    local pc = player.Character
    if not pc then return end
    local h = pc:FindFirstChild("Head")
    if not h then return end
    local cV = CharValue.Value
    if not cV then return end
    local cf = ReplicatedStorage:FindFirstChild("Characters")
    if not cf or not cf:FindFirstChild(cV) then return end
    local wc = cf[cV]:FindFirstChild("WallCombo")
    if not wc then return end
    local ch = workspace:FindFirstChild("Characters")
    if not ch then return end
    local np = ch:FindFirstChild("NPCs")
    if not np then return end
    local bum = np:FindFirstChild("The Ultimate Bum")
    if not bum then return end
    for _ = 1, 100 do
        local an = "Action" .. math.random(1000, 9999)
        local rid = math.random(100000, 999999)
        local args = {
            wc, "Characters:" .. cV .. ":WallCombo", 1, rid,
            {
                HitboxCFrames = { nil },
                BestHitCharacter = bum,
                HitCharacters = { bum },
                Ignore = { [an] = { bum } },
                DeathInfo = {},
                Actions = { [an] = {} },
                HitInfo = { Blocked = false, IsFacing = true, IsInFront = true },
                BlockedCharacters = {},
                ServerTime = tick(),
                FromCFrame = nil,
            },
            an,
        }
        pcall(function() AbilityRemote:FireServer(wc, rid) end)
        pcall(function() ActionRemote:FireServer(unpack(args)) end)
    end
end

-- 反服务器延迟
local aslOn, aslConn = false, nil
local aslCache = {}
local function phantomPlayer(p, ch)
    if not aslOn then return end
    local d = aslCache[p]
    if not d or d.isPhantom then return end
    d.isPhantom = true
    local h = ch:FindFirstChildOfClass("Humanoid")
    if h then h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
    local r = ch:FindFirstChild("HumanoidRootPart")
    if r then r.Anchored = true end
    for _, x in ipairs(ch:GetDescendants()) do
        if x:IsA("BasePart") then
            if not d.ot[x] then d.ot[x] = x.Transparency end
            x.Transparency = 1
        end
    end
end
local function restorePlayer(p, ch)
    local d = aslCache[p]
    if not d then return end
    d.isPhantom = false
    if ch then
        local h = ch:FindFirstChildOfClass("Humanoid")
        if h then h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer end
        local r = ch:FindFirstChild("HumanoidRootPart")
        if r then r.Anchored = false end
    end
    for x, t in pairs(d.ot) do
        if x and x.Parent then x.Transparency = t end
    end
    d.ot = {}
end
local function initCache(p)
    if not aslCache[p] then aslCache[p] = { isPhantom = false, ot = {} } end
end
local function applyAllASL()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            initCache(p)
            if p.Character then phantomPlayer(p, p.Character) end
        end
    end
end
local function setASL(s)
    aslOn = s
    if s then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then initCache(p) end
        end
        applyAllASL()
        if not aslConn then
            aslConn = RunService.Heartbeat:Connect(function()
                if not aslOn then return end
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        initCache(p)
                        phantomPlayer(p, p.Character)
                    end
                end
            end)
        end
        Notify("反服务器延迟", "已开启")
    else
        if aslConn then aslConn:Disconnect(); aslConn = nil end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                restorePlayer(p, p.Character)
            end
        end
        Notify("反服务器延迟", "已关闭")
    end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= player then
        initCache(p)
        p.CharacterAdded:Connect(function(ch)
            task.wait(0.5)
            if aslOn then phantomPlayer(p, ch) end
        end)
    end
end)

-- ============================================================
-- [8] Tab 与控件
-- ============================================================
local TabCombat   = Window:CreateTab("战斗")
local TabHitbox   = Window:CreateTab("Hitbox")
local TabEsp      = Window:CreateTab("透视")
local TabChar     = Window:CreateTab("人物")
local TabOrbit    = Window:CreateTab("环绕")
local TabLag      = Window:CreateTab("服务器延迟")
local TabUtil     = Window:CreateTab("实用")
local TabAbout    = Window:CreateTab("关于")

-- 战斗
local pageAura     = TabCombat:CreateModule("光环", "bolt", {})
local pageCombatEx = TabCombat:CreateModule("通用", "shield", {})

pageAura:CreateToggle("杀戮光环 v3", false, SetAura1)
pageAura:CreateSlider("v3 范围", 30, 400, 100, function(v) A1Range = v end)

pageAura:CreateToggle("杀戮光环 v3+", false, SetAura2)
pageAura:CreateSlider("v3+ 范围", 30, 400, 70, function(v) A2Range = v end)

pageAura:CreateToggle("杀戮光环 v4", false, SetAura4)
pageAura:CreateSlider("v4 范围", 30, 500, 100, function(v) A4Range = v end)
pageAura:CreateSlider("v4 命中密度", 5, 100, 30, function(v) A4Density = v end)
pageAura:CreateSlider("v4 冲刺间隔", 0.05, 0.5, 0.2, function(v) A4Interval = v end)

pageAura:CreateToggle("杀戮光环 v4+", false, SetAura5)
pageAura:CreateSlider("v4+ 范围", 30, 600, 150, function(v) A5Range = v end)
pageAura:CreateSlider("v4+ 命中密度", 5, 150, 60, function(v) A5Density = v end)
pageAura:CreateSlider("v4+ 冲刺间隔", 0.05, 0.5, 0.12, function(v) A5Interval = v end)

pageAura:CreateToggle("墙打光环 v3", false, SetWC1)
pageAura:CreateSlider("墙打 v3 范围", 30, 400, 100, function(v) W1Range = v end)

pageAura:CreateToggle("墙打光环 v3+", false, SetWC2)
pageAura:CreateSlider("墙打 v3+ 范围", 30, 400, 100, function(v) W2Range = v end)
pageAura:CreateSlider("墙打 v3+ 间隔", 0.01, 1, 0.05, function(v) W2Interval = v end)

pageAura:CreateToggle("墙打光环 v4", false, SetWC4)
pageAura:CreateSlider("墙打 v4 范围", 30, 500, 150, function(v) W4Range = v end)
pageAura:CreateSlider("墙打 v4 间隔", 0.01, 1, 0.03, function(v) W4Interval = v end)

pageCombatEx:CreateToggle("无敌", false, function(s)
    WudiE = s
    Notify("无敌", s and "已开启" or "已关闭")
end)

pageCombatEx:CreateToggle("忽略好友", false, function(s) IgFriend = s end)
pageCombatEx:CreateToggle("隐藏墙打动画", false, function(s) hideWallAnim = s end)

-- Hitbox
local pageHit = TabHitbox:CreateModule("判定扩展", "crosshair", {})
pageHit:CreateToggle("开启范围扩展", false, applyHB)
pageHit:CreateSelector("扩展方式", { "覆盖", "叠加" }, "覆盖", function(t)
    HB.M = (t == "叠加") and "Add" or "Override"
end)
pageHit:CreateSlider("横向尺寸", 1, 250, 40, function(v) HB.X = v end)
pageHit:CreateSlider("纵向尺寸", 1, 250, 40, function(v) HB.Y = v end)
pageHit:CreateSlider("前后尺寸", 1, 250, 40, function(v) HB.Z = v end)

-- 透视
local pageEspBase = TabEsp:CreateModule("基本", "eye", {})
local pageEspVis  = TabEsp:CreateModule("显示元素", "layers", {})

pageEspBase:CreateToggle("玩家透视", false, function(s)
    if s then startEsp() Notify("玩家透视", "已开启")
    else stopEsp() Notify("玩家透视", "已关闭") end
end)
pageEspBase:CreateToggle("队伍检测", false, function(s) EspConf.TeamCheck = s end)
pageEspBase:CreateToggle("好友检测", false, function(s) EspConf.FriendCheck = s end)
pageEspBase:CreateSlider("最大距离", 100, 5000, 1000, function(v) EspConf.MaxDistance = v end)

pageEspVis:CreateToggle("显示方框", true, function(s) EspConf.ShowBox = s end)
pageEspVis:CreateToggle("方框填充", true, function(s) EspConf.ShowBoxFill = s end)
pageEspVis:CreateToggle("显示名字", true, function(s) EspConf.ShowName = s end)
pageEspVis:CreateToggle("显示距离", true, function(s) EspConf.ShowDistance = s end)
pageEspVis:CreateToggle("显示血条", true, function(s) EspConf.ShowHealthBar = s end)
pageEspVis:CreateToggle("显示血量%", true, function(s) EspConf.ShowHealthText = s end)
pageEspVis:CreateToggle("显示高亮", false, function(s) EspConf.ShowChams = s end)
pageEspVis:CreateToggle("显示追踪线", false, function(s) EspConf.ShowTracer = s end)

-- 人物
local pageMove = TabChar:CreateModule("移动", "run", {})
local pageMisc = TabChar:CreateModule("杂项", "sparkles", {})

pageMove:CreateToggle("移动加速", false, function(s) setSpd(s, SpdM) end)
pageMove:CreateSlider("加速倍率", 1, 10, 2, function(v) SpdM = v if SpdE then setSpd(true, v) end end)
pageMove:CreateToggle("飞行", false, function(s)
    if s then sFLY() Notify("飞行", "已开启")
    else NOFLY() Notify("飞行", "已关闭") end
end)
pageMove:CreateSlider("飞行速度", 1, 10, 2, function(v) iyfs = v end)

pageMisc:CreateToggle("防卡", false, setAL)

-- 环绕
local orbitNames = { "最近" }
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= player then table.insert(orbitNames, p.Name) end
end

local pageOrb = TabOrbit:CreateModule("环绕设置", "orbit", {})

pageOrb:CreateSelector("环绕目标", orbitNames, "最近", function(t)
    LGT = (t == "最近") and "closest" or t
    LG.SelectedName = t
end)

local keyList = {
    "NIL",
    "E", "Q", "R", "T", "Y", "G", "F", "V", "C", "B", "H", "J", "K", "L",
    "Z", "X", "N", "M", "P", "U", "I", "O",
    "RightShift", "LeftShift", "RightControl", "LeftControl",
    "Tab", "CapsLock",
    "One", "Two", "Three", "Four", "Five", "Six",
}

pageOrb:CreateSelector("环绕按键", keyList, "NIL", function(t)
    LGK = t
    if t ~= "NIL" then
        Notify("环绕按键", "已绑定 " .. t)
    else
        Notify("环绕按键", "已解绑")
    end
end)

pageOrb:CreateSelector("快速环绕按键", keyList, "NIL", function(t)
    QLGK = t
    if t ~= "NIL" then
        Notify("快速环绕按键", "已绑定 " .. t)
    else
        Notify("快速环绕按键", "已解绑")
    end
end)

-- 服务器延迟
local sl1On, sl1Pos = false, nil
local sl2On, sl2C = false, nil

local pageLag = TabLag:CreateModule("延迟方法", "activity", {})

pageLag:CreateToggle("延迟方法一", false, function(v)
    if v then
        sl1On = true
        local h = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if h then sl1Pos = h.CFrame h.CollisionGroup = "None" end
        task.spawn(function()
            while sl1On do
                local c = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if c then
                    pcall(function()
                        DashRemote:FireServer(unpack({ [1] = CFrame.new(0, 0, 0), [2] = "R", [3] = nil, [5] = nil }))
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
        local h = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if h then
            h.CFrame = CFrame.new(0, -120, 0)
            task.wait(0.2)
            if sl1Pos then h.CFrame = sl1Pos end
            h.CollisionGroup = "Characters"
        end
        Notify("延迟方法一", "已关闭")
    end
end)

pageLag:CreateToggle("延迟方法二", false, function(v)
    if v then
        sl2On = true
        sl2C = RunService.Heartbeat:Connect(function() if sl2On then pcall(lagger2) end end)
        Notify("延迟方法二", "已开启")
    else
        sl2On = false
        if sl2C then sl2C:Disconnect(); sl2C = nil end
        Notify("延迟方法二", "已关闭")
    end
end)

local pageASL = TabLag:CreateModule("反服务器延迟", "shield-off", {})
pageASL:CreateToggle("反服务器延迟", false, function(s) setASL(s) end)

-- 实用
local pageRevive = TabUtil:CreateModule("复活功能", "refresh-cw", {})

pageRevive:CreateToggle("瞬时复活（999 命）", false, function(s)
    InstantRespawnOn = s
    if s then
        start999Lives()
        Notify("瞬时复活", "已开启")
    else
        stop999Lives()
        hasTriggered = false
        savedPosition = nil
        Notify("瞬时复活", "已关闭")
    end
end)

pageRevive:CreateInput({
    Name = "复活传送延迟(秒)",
    Default = "0.2",
    Placeholder = "默认 0.2",
    Callback = function(v)
        local n = tonumber(v)
        if n and n >= 0 then
            _G.Lives999TeleportDelay = n
        end
    end,
})

local pageServer = TabUtil:CreateModule("服务器", "server", {})

pageServer:CreateButton("重进服务器", function()
    TeleportService:Teleport(game.PlaceId, player)
    Notify("服务器", "正在重进")
end)

pageServer:CreateButton("服务器跳转", function()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local File = pcall(function()
        AllIDs = game:GetService("HttpService"):JSONDecode(readfile("NotSameServers.json"))
    end)
    if not File then
        table.insert(AllIDs, actualHour)
        writefile("NotSameServers.json", game:GetService("HttpService"):JSONEncode(AllIDs))
    end
    local function TPReturner()
        local Site
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100"))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. foundAnything))
        end
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        for _, v in pairs(Site.data) do
            local Possible = true
            local ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _, Existing in pairs(AllIDs) do
                    if ID == tostring(Existing) then Possible = false end
                end
                if Possible then
                    table.insert(AllIDs, ID)
                    pcall(function()
                        writefile("NotSameServers.json", game:GetService("HttpService"):JSONEncode(AllIDs))
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, player)
                    end)
                    return
                end
            end
        end
    end
    pcall(function()
        TPReturner()
        if foundAnything ~= "" then TPReturner() end
    end)
end)

-- 关于
local pageAbout = TabAbout:CreateModule("信息", "info", {})
pageAbout:CreateButton("版本: xtal v1.0", function() end)
pageAbout:CreateButton("作者: Develop by xtal", function() end)

task.defer(function()
    task.wait(1)
    pcall(function()
        local found = nil
        for _, v in ipairs(playerGui:GetDescendants()) do
            if v:IsA("TextBox") then
                local ph = v.PlaceholderText or ""
                if string.find(ph, "搜索") or string.find(string.lower(ph), "search") then
                    found = v
                    break
                end
            end
        end
        if not found then return end
        if found.Parent then found.Parent.Visible = false end
    end)
end)

Window:Notify({
    Title    = "xtal 已加载",
    Content  = "所有功能已就绪（含瞬时复活）",
    Duration = 5,
})
