repeat task.wait() until game:IsLoaded()
print("[xtal] 游戏已加载，开始初始化...")

local Stats              = game:GetService("Stats")
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local UserInputService   = game:GetService("UserInputService")
local CoreGui            = game:GetService("CoreGui")
local Lighting           = game:GetService("Lighting")
local TweenService       = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

local local_player = Players.LocalPlayer
local camera       = workspace.CurrentCamera

-- ============================================================
-- [0] 加载动画：模糊背景 + Xtal 字母弹出（5 秒）
-- ============================================================
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "xtalLoading"
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true
LoadingGui.DisplayOrder = 9999
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() LoadingGui.Parent = CoreGui end)
if not LoadingGui.Parent then LoadingGui.Parent = local_player:WaitForChild("PlayerGui") end

-- 全屏黑底
local Backdrop = Instance.new("Frame")
Backdrop.Size = UDim2.fromScale(1, 1)
Backdrop.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Backdrop.BackgroundTransparency = 1
Backdrop.BorderSizePixel = 0
Backdrop.ZIndex = 1
Backdrop.Parent = LoadingGui

-- 暗色遮罩
local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.fromScale(1, 1)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 0.35
Overlay.BorderSizePixel = 0
Overlay.ZIndex = 2
Overlay.Parent = LoadingGui

-- 中央横向容器
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

-- 底部加载提示
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

-- 创建每个字母（初始状态：缩小 + 透明）
local letterChars = { "X", "t", "a", "l" }
local letterLabels = {}

for i, ch in ipairs(letterChars) do
    local lbl = Instance.new("TextLabel")
    lbl.Name = "Letter_" .. i
    lbl.Size = UDim2.new(0, 120, 0, 160)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBlack
    lbl.Text = ch
    lbl.TextColor3 = Color3.fromRGB(120, 200, 255)
    lbl.TextScaled = true
    lbl.TextTransparency = 1
    lbl.LayoutOrder = i
    lbl.ZIndex = 4
    lbl.Parent = LetterHolder

    -- 渐变描边
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 3
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Transparency = 1
    stroke.Parent = lbl

    letterLabels[i] = { label = lbl, stroke = stroke }
end

-- 全场模糊
local Blur = Instance.new("BlurEffect")
Blur.Name = "xtalLoadingBlur"
Blur.Size = 0
Blur.Parent = Lighting

-- 播放动画：模糊 + 字母依次弹出
local function playLoadingAnimation()
    -- 1) 模糊从 0 → 24
    local blurTween = TweenService:Create(Blur, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Size = 24})
    blurTween:Play()
    TweenService:Create(Backdrop, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
    TweenService:Create(TipLabel, TweenInfo.new(0.6), {TextTransparency = 0}):Play()

    task.wait(0.5)

    -- 2) 字母依次弹出，每个间隔 1 秒
    for i, data in ipairs(letterLabels) do
        local lbl = data.label
        local stroke = data.stroke

        -- 起手状态
        lbl.TextTransparency = 1
        lbl.TextSize = 10
        lbl.Rotation = -25
        stroke.Transparency = 1

        -- 弹出
        local info = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(lbl, info, {TextTransparency = 0}):Play()
        TweenService:Create(lbl, info, {Rotation = 0}):Play()
        TweenService:Create(stroke, info, {Transparency = 0}):Play()

        -- 使用不同颜色（逐字渐变）
        local colors = {
            Color3.fromRGB(120, 200, 255),
            Color3.fromRGB(140, 230, 255),
            Color3.fromRGB(180, 250, 255),
            Color3.fromRGB(255, 220, 160),
        }
        lbl.TextColor3 = colors[i] or Color3.fromRGB(255, 255, 255)

        task.wait(1)
    end

    -- 3) 停留一小会（保证总时长 ≈ 5 秒）
    task.wait(0.5)

    -- 4) 淡出
    local fadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    for _, data in ipairs(letterLabels) do
        TweenService:Create(data.label, fadeInfo, {TextTransparency = 1, Rotation = 15}):Play()
        TweenService:Create(data.stroke, fadeInfo, {Transparency = 1}):Play()
    end
    TweenService:Create(TipLabel, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(Backdrop, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(Blur, fadeInfo, {Size = 0}):Play()

    task.wait(0.7)

    -- 清理
    if Blur then Blur:Destroy() end
    if LoadingGui then LoadingGui:Destroy() end
end

-- 播放动画（阻塞，让 UI 在动画结束后再出现）
playLoadingAnimation()

-- ============================================================
-- [1] 加载 MoonLua UI
-- ============================================================
local UI_URL = "https://sikon.226618.xyz/moon lua UI源码.lua"
local Library = nil

local function loadMoonUI()
    for attempt = 1, 3 do
        local ok, result = pcall(function()
            local src = game:HttpGet(UI_URL)
            if not src or #src < 100 then error("UI源码获取失败或内容过短") end
            return loadstring(src)()
        end)
        if ok and type(result) == "table" then
            print("[xtal] MoonLua UI 加载成功 (尝试 " .. attempt .. "/3)")
            return result
        end
        warn("[xtal] UI 加载尝试 " .. attempt .. " 失败: " .. tostring(result))
        task.wait(1)
    end
    return nil
end

Library = loadMoonUI()
if not Library then
    warn("[xtal] ❌ MoonLua UI 加载失败，请检查网络或更换执行器")
    return
end
print("[xtal] 库版本:", Library.Version)

local function SafeCall(fn, ...)
    local ok, result = pcall(fn, ...)
    if not ok then warn("[xtal] 调用错误: " .. tostring(result)) end
    return ok, result
end

-- ============================================================
-- [2] Nurysium 工具库
-- ============================================================
local Nurysium_Util
SafeCall(function()
    Nurysium_Util = loadstring(game:HttpGet("https://raw.githubusercontent.com/cracklua/cracks/m/sources/pitbull/Scripts/Blade%20Ball.lua"))()
end)

local nurysium_Data, hit_Sound, closest_Entity, parry_remote

getgenv().aura_Enabled       = false
getgenv().hit_sound_Enabled  = false
getgenv().hit_effect_Enabled = false
getgenv().night_mode_Enabled = false
getgenv().trail_Enabled      = false
getgenv().self_effect_Enabled = false

local Services = {
    game:GetService("AdService"),
    game:GetService("SocialService"),
}

function initializate(dataFolder_name)
    nurysium_Data = Instance.new("Folder", CoreGui)
    nurysium_Data.Name = dataFolder_name
    hit_Sound = Instance.new("Sound", nurysium_Data)
    hit_Sound.SoundId = "rbxassetid://936447863"
    hit_Sound.Volume = 5
end

local function get_closest_entity(Object)
    task.spawn(function()
        local max_distance = math.huge
        for _, entity in ipairs(workspace.Alive:GetChildren()) do
            if entity.Name ~= local_player.Name then
                local distance = (Object.Position - entity.HumanoidRootPart.Position).Magnitude
                if distance < max_distance then
                    closest_Entity = entity
                    max_distance = distance
                end
            end
        end
    end)
    return closest_Entity
end

function resolve_parry_Remote()
    for _, value in ipairs(Services) do
        local temp_remote = value:FindFirstChildOfClass("RemoteEvent")
        if temp_remote and temp_remote.Name:find("\n") then
            parry_remote = temp_remote
        end
    end
end

-- ============================================================
-- [3] Aura 逻辑
-- ============================================================
local aura_table = {
    canParry = true, is_Spamming = false, parry_Range = 0, spam_Range = 0,
    hit_Count = 0, hit_Time = tick(), ball_Warping = tick(), is_ball_Warping = false,
}

SafeCall(function()
    ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
        if getgenv().hit_sound_Enabled and hit_Sound then hit_Sound:Play() end
        if getgenv().hit_effect_Enabled then
            local ball = Nurysium_Util and Nurysium_Util.getBall()
            if ball then
                local hit_effect = game:GetObjects("rbxassetid://17407244385")[1]
                hit_effect.Parent = ball
                hit_effect:Emit(3)
                task.delay(5, function() hit_effect:Destroy() end)
            end
        end
    end)
    ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function()
        aura_table.hit_Count += 1
        task.delay(0.15, function() aura_table.hit_Count -= 1 end)
    end)
end)

SafeCall(function()
    workspace:WaitForChild("Balls").ChildRemoved:Connect(function()
        aura_table.hit_Count = 0
        aura_table.is_ball_Warping = false
        aura_table.is_Spamming = false
    end)
end)

-- 拖尾特效
task.defer(function()
    RunService.Heartbeat:Connect(function()
        if not local_player.Character or not local_player.Character.PrimaryPart then return end
        if getgenv().trail_Enabled then
            local trail = game:GetObjects("rbxassetid://17483658369")[1]
            trail.Name = "xtal_fx"
            if local_player.Character.PrimaryPart:FindFirstChild("xtal_fx") then return end
            local a0 = Instance.new("Attachment", local_player.Character.PrimaryPart)
            local a1 = Instance.new("Attachment", local_player.Character.PrimaryPart)
            a0.Position = Vector3.new(0, -2.411, 0)
            a1.Position = Vector3.new(0, 2.504, 0)
            trail.Parent = local_player.Character.PrimaryPart
            trail.Attachment0 = a0
            trail.Attachment1 = a1
        else
            if local_player.Character.PrimaryPart:FindFirstChild("xtal_fx") then
                local_player.Character.PrimaryPart["xtal_fx"]:Destroy()
            end
        end
    end)
end)

-- 夜间模式
task.defer(function()
    while task.wait(1) do
        local tweenTime = getgenv().night_mode_Enabled and 3.9 or 13.5
        TweenService:Create(Lighting, TweenInfo.new(3), {ClockTime = tweenTime}):Play()
    end
end)

-- Aura 主循环
task.spawn(function()
    RunService.PreRender:Connect(function()
        if not getgenv().aura_Enabled then return end
        if closest_Entity and parry_remote then
            local ent = workspace.Alive:FindFirstChild(closest_Entity.Name)
            if ent and ent.Humanoid.Health > 0 and aura_table.is_Spamming then
                if local_player:DistanceFromCharacter(closest_Entity.HumanoidRootPart.Position) <= aura_table.spam_Range then
                    pcall(function()
                        parry_remote:FireServer(0.5,
                            CFrame.new(camera.CFrame.Position, Vector3.zero),
                            {[closest_Entity.Name] = closest_Entity.HumanoidRootPart.Position},
                            {closest_Entity.HumanoidRootPart.Position.X, closest_Entity.HumanoidRootPart.Position.Y},
                            false)
                    end)
                end
            end
        end
    end)

    RunService.Heartbeat:Connect(function()
        if not getgenv().aura_Enabled then return end
        if not Nurysium_Util or not parry_remote then return end
        local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 10
        local self = Nurysium_Util.getBall()
        if not self then return end
        self:GetAttributeChangedSignal("target"):Once(function() aura_table.canParry = true end)
        if self:GetAttribute("target") ~= local_player.Name or not aura_table.canParry then return end
        get_closest_entity(local_player.Character.PrimaryPart)
        if not closest_Entity then return end

        local ball_Position = self.Position
        local ball_Velocity = self.AssemblyLinearVelocity
        if self:FindFirstChild("zoomies") then ball_Velocity = self.zoomies.VectorVelocity end
        local ball_Direction = (local_player.Character.PrimaryPart.Position - ball_Position).Unit
        local ball_Distance = local_player:DistanceFromCharacter(ball_Position)
        local ball_Dot = ball_Direction:Dot(ball_Velocity.Unit)
        local ball_Speed = ball_Velocity.Magnitude
        local ball_speed_Limited = math.min(ball_Speed / 1000, 0.1)

        local target_Position = closest_Entity.HumanoidRootPart.Position
        local target_Distance = local_player:DistanceFromCharacter(target_Position)
        local target_distance_Limited = math.min(target_Distance / 10000, 0.1)

        aura_table.spam_Range = math.max(ping / 10, 15) + ball_Speed / 7
        aura_table.parry_Range = math.max(math.max(ping, 4) + ball_Speed / 3.5, 9.5)
        aura_table.is_Spamming = aura_table.hit_Count > 1 or ball_Distance < 13.5
        if ball_Dot < -0.2 then aura_table.ball_Warping = tick() end

        task.spawn(function()
            if (tick() - aura_table.ball_Warping) >= 0.15 + target_distance_Limited - ball_speed_Limited or ball_Distance <= 10 then
                aura_table.is_ball_Warping = false return
            end
            aura_table.is_ball_Warping = true
        end)

        if ball_Distance <= aura_table.parry_Range and not aura_table.is_Spamming and not aura_table.is_ball_Warping then
            pcall(function()
                parry_remote:FireServer(0.5,
                    CFrame.new(camera.CFrame.Position, Vector3.new(math.random(0, 100), math.random(0, 1000), math.random(100, 1000))),
                    {[closest_Entity.Name] = target_Position},
                    {target_Position.X, target_Position.Y},
                    false)
            end)
            aura_table.canParry = false
            aura_table.hit_Time = tick()
            aura_table.hit_Count += 1
            task.delay(0.15, function() aura_table.hit_Count -= 1 end)
        end

        task.spawn(function()
            repeat RunService.Heartbeat:Wait() until (tick() - aura_table.hit_Time) >= 1
            aura_table.canParry = true
        end)
    end)
end)

initializate("xtal_temp")

-- 自动购买箱子
spawn(function()
    while true do
        wait(0.01)
        if getgenv().ASC then
            pcall(function()
                ReplicatedStorage.Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalSwordCrate)
            end)
        end
    end
end)
spawn(function()
    while true do
        wait(0.01)
        if getgenv().AEC then
            pcall(function()
                ReplicatedStorage.Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalExplosionCrate)
            end)
        end
    end
end)

-- 跟随球
spawn(function()
    local Ball = workspace:WaitForChild("Balls", 30)
    if not Ball then return end
    local currentTween = nil
    while true do
        wait(0.001)
        if getgenv().FB then
            local ball = Ball:FindFirstChildOfClass("Part")
            local char = local_player.Character
            if ball and char and char.PrimaryPart then
                local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false, 0)
                local distance = (char.PrimaryPart.Position - ball.Position).Magnitude
                if distance <= 1000 then
                    if currentTween then currentTween:Pause() end
                    currentTween = TweenService:Create(char.PrimaryPart, tweenInfo, {CFrame = ball.CFrame})
                    currentTween:Play()
                end
            end
        else
            if currentTween then currentTween:Pause() currentTween = nil end
        end
    end
end)

-- 反踢
task.defer(function()
    pcall(function()
        local old
        old = hookmetamethod(game, "__namecall", function(self, ...)
            local method = tostring(getnamecallmethod())
            if string.lower(method) == "kick" then return wait(9e9) end
            return old(self, ...)
        end)
    end)
    pcall(function()
        ReplicatedStorage.Security.RemoteEvent:Destroy()
        ReplicatedStorage.Security[""]:Destroy()
        ReplicatedStorage.Security:Destroy()
        local_player.PlayerScripts.Client.DeviceChecker:Destroy()
    end)
end)

-- ============================================================
-- [4] 创建主窗口
-- ============================================================
local gameName = "Blade Ball"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then gameName = info.Name end
end)

local Window = Library:CreateWindow({
    Name              = "xtal",
    Title             = "xtal | " .. gameName,
    Version           = "V1",
    Theme             = "Nord",
    Backdrop          = true,
    ShowBackdrop      = true,
    GradientAnimation = true,
    ConfigFolder      = "xtal",
    SearchTab         = true,
    Visible           = true,
})

Window:Notify({
    Title    = "xtal",
    Content  = "欢迎 " .. local_player.DisplayName .. " 使用 xtal 脚本",
    Duration = 5,
})

local TabInfo     = Window:CreateTab("信息")
local TabSettings = Window:CreateTab("设置")
local TabVision   = Window:CreateTab("透视")
local TabFunc     = Window:CreateTab("功能")
local TabShop     = Window:CreateTab("购物")
local TabMusic    = Window:CreateTab("音乐")
local TabTools    = Window:CreateTab("工具")

-- ============================================================
-- [5] 信息 Tab
-- ============================================================
local PageInfo = TabInfo:CreateModule("关于", "info", {})
PageInfo:CreateButton("加入 QQ 群 - 点击复制", function()
    setclipboard("https://qm.qq.com/q/4s2duWP6rK")
    Window:Notify({ Title = "xtal", Content = "已复制群链接到剪贴板", Duration = 3 })
end)
PageInfo:CreateButton("脚本永久免费 - QQ: 594229136", function()
    setclipboard("594229136")
    Window:Notify({ Title = "xtal", Content = "已复制 QQ 号", Duration = 3 })
end)

-- ============================================================
-- [6] 设置 Tab
-- ============================================================
local character = local_player.Character or local_player.CharacterAdded:Wait()
local originalSpeed = character.Humanoid.WalkSpeed
local originalFov = workspace.Camera.FieldOfView

local speedEnabled, fovEnabled = false, false
local speedValue, fovValue = 36, 80

local function applySpeed()
    local char = local_player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speedEnabled and speedValue or originalSpeed
    end
end
local function applyFov()
    workspace.Camera.FieldOfView = fovEnabled and fovValue or originalFov
end

local_player.CharacterAdded:Connect(function(newChar)
    character = newChar
    newChar:WaitForChild("Humanoid")
    task.wait(0.2)
    applySpeed()
end)

local PageMainSettings = TabSettings:CreateModule("主要", "settings", {})
PageMainSettings:CreateSlider("角色速度", 36, 1000, 36, function(v) speedValue = v applySpeed() end)
PageMainSettings:CreateSlider("视野范围 (FOV)", 80, 1000, 80, function(v) fovValue = v applyFov() end)

local PageOptions = TabSettings:CreateModule("选项", "sliders", {})
PageOptions:CreateToggle("启用速度修改", false, function(v) speedEnabled = v applySpeed() end)
PageOptions:CreateToggle("启用视野修改", false, function(v) fovEnabled = v applyFov() end)

local InfiniteJumpEnabled = false
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and local_player.Character then
        local hum = local_player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState("Jumping") end
    end
end)

local PageModify = TabSettings:CreateModule("修改", "wand", {})
PageModify:CreateToggle("无限跳跃", false, function(state) InfiniteJumpEnabled = state end)
PageModify:CreateToggle("夜间模式", false, function(v) getgenv().night_mode_Enabled = v end)

local currentTransparency = 0.7
local xrayState = false

local function toggleXRay(state, transparency)
    if state then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChildOfClass("Humanoid")
                and not (v.Parent.Parent and v.Parent.Parent:FindFirstChildOfClass("Humanoid")) then
                if not v:FindFirstChild("OriginalTransparency") then
                    local ot = Instance.new("NumberValue", v)
                    ot.Name = "OriginalTransparency"
                    ot.Value = v.LocalTransparencyModifier
                    v.LocalTransparencyModifier = transparency
                end
            end
        end
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChildOfClass("Humanoid")
                and not (v.Parent.Parent and v.Parent.Parent:FindFirstChildOfClass("Humanoid")) then
                if v:FindFirstChild("OriginalTransparency") then
                    v.LocalTransparencyModifier = v:WaitForChild("OriginalTransparency").Value
                    v:WaitForChild("OriginalTransparency"):Destroy()
                end
            end
        end
    end
end

PageModify:CreateToggle("开启穿墙透视", false, function(state)
    xrayState = state
    toggleXRay(xrayState, currentTransparency)
end)
PageModify:CreateSlider("穿墙透视强度", 0.1, 1, 0.7, function(v)
    currentTransparency = v
    if xrayState then toggleXRay(true, v) end
end)

-- 传送
local PageTP = TabSettings:CreateModule("传送", "map-pin", {})
local LastSelectedPlayer = nil
local IsLooping = false

local function TeleportToPlayer(playerName)
    local player = Players:FindFirstChild(playerName)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local char = local_player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
        end
    end
end

local function getPlayerNames()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= local_player then table.insert(list, p.Name) end
    end
    if #list == 0 then list = { "无玩家" } end
    return list
end

PageTP:CreateSelector("选择目标玩家", getPlayerNames(), "无玩家", function(v)
    if v ~= "" and v ~= LastSelectedPlayer and v ~= "无玩家" then
        TeleportToPlayer(v)
        LastSelectedPlayer = v
    end
end)

PageTP:CreateToggle("锁定目标传送", false, function(isToggled)
    IsLooping = isToggled
    while IsLooping do
        if LastSelectedPlayer then TeleportToPlayer(LastSelectedPlayer) end
        wait(0.05)
    end
end)

-- ============================================================
-- [7] 透视 Tab
-- ============================================================
local ESP
SafeCall(function()
    ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/cracklua/cracks/m/sources/pitbull/Scripts/Esp.lua"))()
    ESP:Toggle(false)
end)

local PageESP = TabVision:CreateModule("玩家透视", "eye", {})
PageESP:CreateToggle("启用玩家透视", false, function(v) if ESP then ESP:Toggle(v) end end)

local PageESPOpt = TabVision:CreateModule("透视选项", "settings", {})
PageESPOpt:CreateToggle("显示玩家名字", false, function(v) if ESP then ESP.Names = v end end)
PageESPOpt:CreateToggle("显示玩家方框", false, function(v) if ESP then ESP.Boxes = v end end)
PageESPOpt:CreateToggle("显示追踪射线", false, function(v) if ESP then ESP.Tracers = v end end)

-- ============================================================
-- [8] 功能 Tab
-- ============================================================
local autoParryAIEnabled = false
local PageMainFunc = TabFunc:CreateModule("主要功能", "sword", {})

PageMainFunc:CreateToggle("启用自动格挡", false, function(toggled)
    autoParryAIEnabled = toggled
    resolve_parry_Remote()
    getgenv().aura_Enabled = toggled
end)

PageMainFunc:CreateToggle("命中特效", false, function(toggled)
    getgenv().hit_effect_Enabled = toggled
end)

-- 视化格挡范围
getgenv().ViewParryArea = false
getgenv().ParryRange = 10
local maxRange = 25
local connection

local function ViewParryArea()
    local BallParry = Instance.new("Part", workspace)
    BallParry.Name = "Parry Range <xtal>"
    BallParry.Material = Enum.Material.ForceField
    BallParry.CastShadow = false
    BallParry.CanCollide = false
    BallParry.Anchored = true
    BallParry.BrickColor = BrickColor.new("Bright blue")
    BallParry.Shape = Enum.PartType.Ball

    local PartFind = workspace:FindFirstChild(BallParry.Name)
    if PartFind and PartFind ~= BallParry then PartFind:Destroy() end

    local isExpanding = false
    local Range = getgenv().ParryRange
    local initialRange = getgenv().ParryRange

    connection = RunService.Heartbeat:Connect(function()
        if not getgenv().ViewParryArea then
            connection:Disconnect()
            BallParry:Destroy()
            return
        end
        local plrChar = local_player.Character
        local plrPP = plrChar and plrChar:FindFirstChild("HumanoidRootPart")
        BallParry.BrickColor = BrickColor.new("Bright blue")
        if plrPP then BallParry.Position = plrPP.Position
        else BallParry.Position = Vector3.new(1000, 1000, 1000) end
        local self = Nurysium_Util and Nurysium_Util.getBall()
        if self and plrPP then
            local ball_Velocity = self.AssemblyLinearVelocity
            if self:FindFirstChild("zoomies") then ball_Velocity = self.zoomies.VectorVelocity end
            local ball_Position = self.Position
            local ball_Direction = (ball_Position - plrPP.Position).Unit
            local ball_Speed = ball_Velocity.Magnitude
            local ball_Dot = ball_Direction:Dot(ball_Velocity.Unit)
            local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 10
            local max_parry_Range = math.max(math.max(ping, 4) + ball_Speed / 1.5, maxRange)
            if ball_Dot < 0 then
                if not isExpanding then Range = initialRange isExpanding = true end
                Range = math.min(Range + ball_Speed / 5, max_parry_Range)
            else
                if isExpanding then Range = getgenv().ParryRange isExpanding = false end
            end
            BallParry.Size = Vector3.new(Range, Range, Range)
        end
    end)
end

PageMainFunc:CreateToggle("显示格挡范围球", false, function(toggled)
    getgenv().ViewParryArea = toggled
    if toggled then
        ViewParryArea()
    elseif connection then
        connection:Disconnect()
        local existing = workspace:FindFirstChild("Parry Range <xtal>")
        if existing then existing:Destroy() end
    end
end)

-- 手动挡模式
local hitremote
for _, v in next, game:GetDescendants() do
    if v and v.Name:find("\n") and v:IsA("RemoteEvent") then hitremote = v break end
end

local cframes = {
    CFrame.new(-Random.new():NextNumber(200, 500), Random.new():NextNumber(0, 40), -Random.new():NextNumber(70, 120)),
    CFrame.new(-Random.new():NextNumber(200, 500), Random.new():NextNumber(0, 40), -Random.new():NextNumber(70, 120)),
    CFrame.new(-Random.new():NextNumber(200, 500), Random.new():NextNumber(0, 80), -Random.new():NextNumber(70, 120)),
    CFrame.new(-Random.new():NextNumber(200, 600), Random.new():NextNumber(0, 80), -Random.new():NextNumber(70, 120)),
}

local function getcloseplr()
    local plr, dista = nil, math.huge
    local alive = workspace:FindFirstChild("Alive")
    for _, v in next, Players:GetPlayers() do
        if v ~= local_player and v.Character and alive
            and v.Character:IsDescendantOf(alive)
            and v.Character:FindFirstChildOfClass("Humanoid")
            and v.Character:FindFirstChildOfClass("Humanoid").Health > 0
            and v.Character.PrimaryPart then
            local dist = local_player:DistanceFromCharacter(v.Character.PrimaryPart.Position)
            if dist < dista then dista = dist plr = v end
        end
    end
    return plr
end

local function getplrs()
    local plrss = {}
    local alive = workspace:FindFirstChild("Alive")
    for _, v in next, Players:GetPlayers() do
        if v and v.Character and alive and v.Character:IsDescendantOf(alive) then
            plrss[v.Name] = v.Character.PrimaryPart.Position + Vector3.new(10, 10, 10)
        end
    end
    return plrss
end

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Position = UDim2.new(0, 40, 0, 20)
frame.Size = UDim2.new(0, 120, 0, 50)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.9
frame.BorderSizePixel = 0
frame.Name = "手动挡"
frame.Parent = gui

local button = Instance.new("TextButton")
button.Text = "手动挡"
button.Size = UDim2.new(1, -4, 1, -7)
button.Position = UDim2.new(0, 3, 0, 5)
button.BackgroundColor3 = Color3.new(0, 0, 0)
button.BackgroundTransparency = 0.5
button.BorderColor3 = Color3.new(0, 0, 0)
button.BorderSizePixel = 2
button.Font = Enum.Font.SourceSans
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 22
button.Parent = frame

local activated = false
local heartbeatConnection
local manualspamspeed = 8
local manspamcons = {}
local enabled = false
local debounce = false

local function deactivateClashMode()
    if heartbeatConnection then heartbeatConnection:Disconnect() heartbeatConnection = nil end
    for _, v in next, manspamcons do v:Disconnect() end
    table.clear(manspamcons)
    enabled = false
    button.Text = "关闭"
    button.TextColor3 = Color3.new(1, 0, 0)
end

local function activateClashMode()
    if not hitremote then return end
    local function fireHitRemote()
        if debounce then return end
        debounce = true
        delay(0.05, function() debounce = false end)
        for _ = 1, manualspamspeed do
            if not enabled then break end
            local closest = getcloseplr()
            local args = {
                0.5, cframes[math.random(1, #cframes)],
                closest and {[tostring(closest.Name)] = closest.Character.PrimaryPart.Position} or getplrs(),
                {math.random(200, 500), math.random(100, 200)}, false,
            }
            pcall(function() hitremote:FireServer(unpack(args)) end)
        end
    end
    heartbeatConnection = RunService.Heartbeat:Connect(function() if enabled then fireHitRemote() end end)
    table.insert(manspamcons, RunService.PreRender:Connect(function() if enabled then fireHitRemote() end end))
    enabled = true
    button.Text = "开启"
    button.TextColor3 = Color3.new(0, 1, 0)
end

local function toggleClashMode()
    activated = not activated
    if activated then activateClashMode() else deactivateClashMode() end
end

button.MouseButton1Click:Connect(toggleClashMode)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then toggleClashMode() end
end)

PageMainFunc:CreateToggle("启用手动挡 (快捷键 G)", false, function(state)
    if state then
        gui.Enabled = true
        if activated then activateClashMode() else deactivateClashMode() end
    else
        deactivateClashMode()
        gui.Enabled = false
    end
end)

-- 战斗选项
local PageCombat = TabFunc:CreateModule("战斗选项", "crosshairs", {})

PageCombat:CreateSelector("战斗模式",
    { "低级", "中级", "中级至高级", "支持", "高", "极端", "极端 [AI]" },
    "极端 [AI]", function(currentOption)
        if autoParryAIEnabled then
            Window:Notify({ Title = "xtal", Content = "已切换至 " .. currentOption .. " 模式", Duration = 3 })
        else
            Window:Notify({ Title = "xtal", Content = "请先启用自动格挡", Duration = 3 })
        end
    end)

PageCombat:CreateToggle("反曲线", false, function(toggled)
    getgenv().antiCurveEnabled = toggled
end)

local function preventCurve(ball)
    local previousPosition = ball.Position
    RunService.Heartbeat:Connect(function()
        if getgenv().antiCurveEnabled then
            local currentPosition = ball.Position
            local velocity = ball.Velocity
            if (currentPosition - previousPosition).Magnitude > 0.1 and velocity.Magnitude > 0 then
                ball.Velocity = (currentPosition - previousPosition).Unit * velocity.Magnitude
            end
            previousPosition = currentPosition
        end
    end)
end

local function onBallAdded(ball)
    if ball:IsA("BasePart") and ball.Name == "Ball" then preventCurve(ball) end
end

SafeCall(function()
    workspace:WaitForChild("Balls").ChildAdded:Connect(onBallAdded)
    for _, ball in ipairs(workspace:WaitForChild("Balls"):GetChildren()) do onBallAdded(ball) end
end)

-- 极速格挡
local aura_table2 = { canParry = true, parry_Range = 0, hit_Time = tick() }

local function get_closest_entity2(Object)
    local closest, maxd = nil, math.huge
    for _, entity in ipairs(workspace.Alive:GetChildren()) do
        if entity.Name ~= local_player.Name then
            local d = (Object.Position - entity.HumanoidRootPart.Position).Magnitude
            if d < maxd then closest = entity maxd = d end
        end
    end
    return closest
end

local function enableUltraFastBlocking(enable)
    if enable then
        RunService.Heartbeat:Connect(function()
            if not aura_table2.canParry or not parry_remote then return end
            local ce = get_closest_entity2(local_player.Character.PrimaryPart)
            if ce then
                local target_Position = ce.HumanoidRootPart.Position
                local ball = workspace:FindFirstChild("Ball")
                if ball then
                    local player_Position = local_player.Character.PrimaryPart.Position
                    local ball_Distance = (player_Position - ball.Position).Magnitude
                    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 10
                    aura_table2.parry_Range = math.max(math.max(ping, 2), 4.5)
                    if ball_Distance <= aura_table2.parry_Range then
                        pcall(function()
                            parry_remote:FireServer(0.5,
                                CFrame.new(camera.CFrame.Position, Vector3.new(math.random(0, 100), math.random(0, 1000), math.random(100, 1000))),
                                {[ce.Name] = target_Position},
                                {target_Position.X, target_Position.Y}, false)
                        end)
                        aura_table2.canParry = false
                        aura_table2.hit_Time = tick()
                        task.delay(0.01, function() aura_table2.canParry = true end)
                    end
                end
            end
        end)
    else
        aura_table2.canParry = false
    end
end

PageCombat:CreateToggle("极速格挡", false, function(toggled)
    enableUltraFastBlocking(toggled)
end)

-- 副功能
local PageSub = TabFunc:CreateModule("副功能", "star", {})
PageSub:CreateToggle("更改剑的声音", false, function(toggled) getgenv().hit_sound_Enabled = toggled end)
PageSub:CreateToggle("跟随球体", false, function(state) getgenv().FB = state end)
PageSub:CreateToggle("启用人物拖尾特效", false, function(state) getgenv().trail_Enabled = state end)

-- 检测自动点击器
local detectToggle = false
local detectionCooldowns = {}

UserInputService.InputBegan:Connect(function(input, gp)
    if not detectToggle or gp then return end
    local inputType = input.UserInputType
    local keyCode = input.KeyCode
    if (inputType == Enum.UserInputType.Keyboard and keyCode == Enum.KeyCode.F)
        or inputType == Enum.UserInputType.Touch then
        local now = tick()
        local userId = local_player.UserId
        if not detectionCooldowns[userId] then detectionCooldowns[userId] = 0 end
        if now - detectionCooldowns[userId] >= 22 then
            detectionCooldowns[userId] = now
            Window:Notify({ Title = "xtal", Content = "检测到快速点击行为", Duration = 5 })
        end
    end
end)

PageSub:CreateToggle("检测自动点击器", false, function(state) detectToggle = state end)

-- ============================================================
-- [9] 购物 Tab
-- ============================================================
local PageShop = TabShop:CreateModule("购买盒子", "shopping-cart", {})
PageShop:CreateButton("购买剑盒子 (80 币)", function()
    pcall(function()
        ReplicatedStorage.Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalSwordCrate)
    end)
end)
PageShop:CreateButton("购买爆炸盒子 (80 币)", function()
    pcall(function()
        ReplicatedStorage.Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalExplosionCrate)
    end)
end)

local PageAutoShop = TabShop:CreateModule("自动购买", "refresh-cw", {})
PageAutoShop:CreateToggle("自动购买剑盒子", false, function(state) getgenv().ASC = state end)
PageAutoShop:CreateToggle("自动购买爆炸盒", false, function(state) getgenv().AEC = state end)

-- ============================================================
-- [10] 音乐 Tab
-- ============================================================
local MusicId, MusicToggle, currentSound, pausedPosition = nil, false, nil, 0

local function playMusic()
    if MusicToggle and MusicId then
        if currentSound then currentSound:Stop() currentSound:Destroy() end
        currentSound = Instance.new("Sound", workspace)
        currentSound.SoundId = "rbxassetid://" .. MusicId
        currentSound.TimePosition = pausedPosition
        currentSound.Looped = true
        currentSound:Play()
    end
end

local PageMusic = TabMusic:CreateModule("音乐播放", "music", {})
PageMusic:CreateInput({
    Name = "音乐 ID", Default = "", Placeholder = "输入音乐 ID",
    Callback = function(v) MusicId = v playMusic() end,
})
PageMusic:CreateToggle("播放音乐", false, function(state)
    MusicToggle = state
    if MusicToggle then playMusic()
    else
        if currentSound then
            pausedPosition = currentSound.TimePosition
            currentSound:Stop()
        end
    end
end)
PageMusic:CreateButton("重放音乐", function()
    if MusicToggle and currentSound then
        currentSound.TimePosition = 0
        currentSound:Play()
    end
end)
PageMusic:CreateButton("播放推荐音乐 (Phonk)", function() MusicId = "16190782181" playMusic() end)
PageMusic:CreateButton("复制推荐音乐 ID", function() setclipboard("16190782181") end)

-- ============================================================
-- [11] 工具 Tab
-- ============================================================
local PageTools = TabTools:CreateModule("性能优化", "tool", {})

PageTools:CreateButton("一键防卡顿", function()
    local Terrain = workspace.Terrain
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 0
    for _, child in pairs(workspace:GetDescendants()) do
        if child:IsA("BasePart") and child.Name ~= "Terrain" then
            child.Material = Enum.Material.Plastic
            child.Reflectance = 0
        elseif child:IsA("Decal") or child:IsA("Texture") then child:Destroy()
        elseif child:IsA("ParticleEmitter") or child:IsA("Fire") or child:IsA("Smoke") then child.Enabled = false
        elseif child:IsA("Explosion") then child.Visible = false end
    end
    Window:Notify({ Title = "xtal", Content = "防卡顿已应用", Duration = 3 })
end)

PageTools:CreateToggle("显示帧数 / 延迟", false, function(state)
    if state then
        local Ping = Instance.new("ScreenGui")
        Ping.Name = "xtalPing"
        Ping.Parent = local_player:WaitForChild("PlayerGui")
        Ping.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        Ping.ResetOnSpawn = false

        local Pingtext = Instance.new("TextLabel")
        Pingtext.Name = "Pingtext"
        Pingtext.Parent = Ping
        Pingtext.BackgroundTransparency = 1
        Pingtext.Position = UDim2.new(1, -230, 0, 0)
        Pingtext.Size = UDim2.new(0, 120, 0, 25)
        Pingtext.Font = Enum.Font.SourceSans
        Pingtext.Text = "延迟: "
        Pingtext.TextColor3 = Color3.fromRGB(255, 255, 255)
        Pingtext.TextStrokeTransparency = 0.5
        Pingtext.TextScaled = true

        spawn(function()
            while Ping.Parent do
                wait(0.1)
                local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                local rp = math.floor(ping + 0.5)
                Pingtext.Text = "延迟: " .. rp
                Pingtext.TextColor3 = rp > 250 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
            end
        end)

        local FPSLabel = Instance.new("TextLabel")
        FPSLabel.Name = "FPSLabel"
        FPSLabel.Parent = Ping
        FPSLabel.BackgroundTransparency = 1
        FPSLabel.Position = UDim2.new(1, -120, 0, 0)
        FPSLabel.Size = UDim2.new(0, 100, 0, 25)
        FPSLabel.Font = Enum.Font.SourceSans
        FPSLabel.Text = "帧数: "
        FPSLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        FPSLabel.TextStrokeTransparency = 0.5
        FPSLabel.TextScaled = true

        local samples = {}
        RunService.RenderStepped:Connect(function()
            table.insert(samples, tick())
            if #samples > 60 then table.remove(samples, 1) end
        end)

        spawn(function()
            while Ping.Parent do
                wait(0.1)
                local count, total = 0, 0
                for i = 1, #samples - 1 do
                    if samples[i + 1] then
                        total = total + (samples[i + 1] - samples[i])
                        count = count + 1
                    end
                end
                if count > 0 then
                    local fps = count / total
                    FPSLabel.Text = "帧数: " .. math.floor(fps + 0.5)
                    FPSLabel.TextColor3 = fps < 30 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
                end
            end
        end)
    else
        local pg = local_player:FindFirstChild("PlayerGui")
        if pg then
            local p = pg:FindFirstChild("xtalPing")
            if p then p:Destroy() end
        end
    end
end)

PageTools:CreateButton("重置角色", function()
    if local_player.Character then
        local head = local_player.Character:FindFirstChild("Head")
        if head then head:Destroy() end
    end
end)

local antiAfkConn = nil
PageTools:CreateToggle("反挂机", false, function(state)
    if antiAfkConn then antiAfkConn:Disconnect() antiAfkConn = nil end
    if state then
        local VirtualUser = game:GetService("VirtualUser")
        antiAfkConn = local_player.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

local PageFPS = TabTools:CreateModule("帧数设置", "activity", {})
PageFPS:CreateSlider("解除帧数限制", 144, 1000, 1000, function(v)
    pcall(function() setfpscap(v) end)
end)
PageFPS:CreateToggle("启用帧数解锁", true, function(state)
    if state then pcall(function() setfpscap(10000000) end)
    else pcall(function() setfpscap(144) end) end
end)

local PageServer = TabTools:CreateModule("服务器工具", "server", {})

PageServer:CreateButton("跳转至其他服务器", function()
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
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, local_player)
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

PageServer:CreateButton("重新进入当前服务器", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, local_player)
end)

PageServer:CreateButton("退出服务器", function() game:Shutdown() end)

local PageOther = TabTools:CreateModule("其他选项", "more-horizontal", {})
PageOther:CreateButton("打开开发者控制台", function()
    game.StarterGui:SetCore("DevConsoleVisible", true)
end)
PageOther:CreateButton("获取经典工具 (锤子/克隆/抓取)", function()
    local backpack = local_player.Backpack
    local hammer = Instance.new("HopperBin")
    hammer.Name = "Hammer"
    hammer.BinType = Enum.BinType.Hammer
    hammer.Parent = backpack
    local ct = Instance.new("HopperBin")
    ct.Name = "Clone"
    ct.BinType = Enum.BinType.Clone
    ct.Parent = backpack
    local gt = Instance.new("HopperBin")
    gt.Name = "Grab"
    gt.BinType = Enum.BinType.Grab
    gt.Parent = backpack
end)

-- ============================================================
-- [12] 完成
-- ============================================================
pcall(function() setclipboard("https://qm.qq.com/q/4s2duWP6rK") end)

Window:Notify({
    Title    = "xtal",
    Content  = "加载完成，欢迎使用 xtal 脚本",
    Duration = 5,
})

print("[xtal] ✅ 所有功能已加载完成")
