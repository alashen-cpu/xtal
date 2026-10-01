repeat task.wait() until game:IsLoaded()

-- ============================================================
-- [0] 彩虹 Xtal 加载动画（约 5 秒）
-- ============================================================
do
    local _Players      = game:GetService("Players")
    local _RunService   = game:GetService("RunService")
    local _TweenService = game:GetService("TweenService")
    local _Lighting     = game:GetService("Lighting")
    local _CoreGui      = game:GetService("CoreGui")
    local _LocalPlayer  = _Players.LocalPlayer
    local _PlayerGui    = _LocalPlayer:WaitForChild("PlayerGui")

    local LoadingGui = Instance.new("ScreenGui")
    LoadingGui.Name = "xtalLoading"
    LoadingGui.ResetOnSpawn = false
    LoadingGui.IgnoreGuiInset = true
    LoadingGui.DisplayOrder = 10000
    LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() LoadingGui.Parent = _CoreGui end)
    if not LoadingGui.Parent then LoadingGui.Parent = _PlayerGui end

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
    Blur.Parent = _Lighting

    local rainbowActive = false
    local rainbowHue = 0

    local function startRainbow()
        rainbowActive = true
        task.spawn(function()
            while rainbowActive do
                _RunService.RenderStepped:Wait()
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
        _TweenService:Create(Blur, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Size = 24}):Play()
        _TweenService:Create(Backdrop, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
        _TweenService:Create(TipLabel, TweenInfo.new(0.6), {TextTransparency = 0}):Play()

        task.wait(0.5)

        for i, data in ipairs(letterLabels) do
            local lbl = data.label
            local stroke = data.stroke
            lbl.TextTransparency = 1
            lbl.Rotation = -25
            stroke.Transparency = 1

            local info = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            _TweenService:Create(lbl, info, {TextTransparency = 0}):Play()
            _TweenService:Create(lbl, info, {Rotation = 0}):Play()
            _TweenService:Create(stroke, info, {Transparency = 0}):Play()
            task.wait(1)
        end

        task.wait(0.5)

        local fadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        for _, data in ipairs(letterLabels) do
            _TweenService:Create(data.label, fadeInfo, {TextTransparency = 1, Rotation = 15}):Play()
            _TweenService:Create(data.stroke, fadeInfo, {Transparency = 1}):Play()
        end
        _TweenService:Create(TipLabel, fadeInfo, {TextTransparency = 1}):Play()
        _TweenService:Create(Backdrop, fadeInfo, {BackgroundTransparency = 1}):Play()
        _TweenService:Create(Blur, fadeInfo, {Size = 0}):Play()

        task.wait(0.7)
        rainbowActive = false
        if Blur then Blur:Destroy() end
        if LoadingGui then LoadingGui:Destroy() end
    end

    playLoadingAnimation()
end

-- ============================================================
-- [0.5] 强力解锁 —— 提前 Hook 所有锁相关检测函数
-- ============================================================
local unlockStats = { gcFields = 0, gcFuncs = 0, values = 0, remotes = 0 }

do
    -- Hook 所有名字带锁关键字的函数（返回 true）
    if hookfunction and getgc then
        for _, obj in pairs(getgc(true)) do
            if type(obj) == "table" then
                for k, v in pairs(obj) do
                    if type(v) == "function" and type(k) == "string" then
                        local kl = k:lower()
                        if kl:find("islock") or kl:find("canaccess") or kl:find("hasaccess")
                            or kl:find("isavailable") or kl:find("isunlock") or kl:find("isbought")
                            or kl:find("checklock") or kl:find("checkunlock") then
                            pcall(function()
                                hookfunction(v, function() return true end)
                                unlockStats.gcFuncs = unlockStats.gcFuncs + 1
                            end)
                        end
                    end
                end
            end
        end
    end

    -- 强制所有带锁关键字的 bool 字段 = true
    if getgc then
        for _, obj in pairs(getgc(true)) do
            if type(obj) == "table" then
                for k, v in pairs(obj) do
                    if type(k) == "string" and type(v) == "boolean" then
                        local kl = k:lower()
                        if kl:find("lock") or kl:find("access") or kl:find("available") or kl:find("bought") then
                            pcall(function()
                                rawset(obj, k, true)
                                unlockStats.gcFields = unlockStats.gcFields + 1
                            end)
                        end
                    end
                end
            end
        end
    end

    -- 遍历所有 BoolValue，名字带锁关键字的直接 true
    local searchRoots = { game:GetService("Players").LocalPlayer }
    local dataFolder = game:GetService("Players").LocalPlayer:FindFirstChild("Data")
    if dataFolder then table.insert(searchRoots, dataFolder) end
    table.insert(searchRoots, game:GetService("ReplicatedStorage"))
    table.insert(searchRoots, workspace)

    for _, root in ipairs(searchRoots) do
        for _, v in pairs(root:GetDescendants()) do
            if v:IsA("BoolValue") then
                local n = v.Name:lower()
                if n:find("lock") or n:find("unlock") or n:find("access") or n:find("bought") or n:find("purchase") then
                    pcall(function()
                        v.Value = true
                        unlockStats.values = unlockStats.values + 1
                    end)
                end
            elseif v:IsA("IntValue") or v:IsA("NumberValue") then
                local n = v.Name:lower()
                if n:find("level") or n:find("progress") or n:find("rank") then
                    pcall(function()
                        if v.Value < 9999 then v.Value = 9999 end
                        unlockStats.values = unlockStats.values + 1
                    end)
                end
            end
        end
    end

    -- 触发所有 unlock/open 相关 Remote
    for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        local n = remote.Name:lower()
        if n:find("unlock") or n:find("open") or n:find("purchase") or n:find("buy") then
            if remote:IsA("RemoteFunction") then
                pcall(function() remote:InvokeServer("unlock") end)
                pcall(function() remote:InvokeServer("all") end)
                pcall(function() remote:InvokeServer() end)
                unlockStats.remotes = unlockStats.remotes + 1
            elseif remote:IsA("RemoteEvent") then
                pcall(function() remote:FireServer("unlock") end)
                pcall(function() remote:FireServer("all") end)
                pcall(function() remote:FireServer() end)
                unlockStats.remotes = unlockStats.remotes + 1
            end
        end
    end

    print(string.format("[xtal] 解锁完成: %d 个字段, %d 个函数, %d 个值, %d 个远程",
        unlockStats.gcFields, unlockStats.gcFuncs, unlockStats.values, unlockStats.remotes))
end

-- ============================================================
-- [1] 加载 MoonLua UI
-- ============================================================
local UI_URL = "https://sikon.226618.xyz/moon lua UI源码.lua"
local ok, Library = pcall(function()
    return loadstring(game:HttpGet(UI_URL))()
end)
if not ok or type(Library) ~= "table" then
    warn("[xtal] MoonLua UI 加载失败: " .. tostring(Library))
    return
end
print("[xtal] 库版本:", Library.Version)

local Window = Library:CreateWindow({
    Name              = "xtal",
    Title             = "xtal脚本-tsb ",
    Version           = "V2",
    Theme             = "Nord",
    Backdrop          = true,
    ShowBackdrop      = true,
    GradientAnimation = true,
    ConfigFolder      = "xtal_TSB",
    SearchTab         = true,
    Visible           = true,
})

Window:Notify({
    Title    = "xtal",
    Content  = "解锁完成 | " .. unlockStats.gcFields .. " 字段 / " .. unlockStats.gcFuncs .. " 函数",
    Duration = 6,
})

-- ============================================================
-- 服务与状态
-- ============================================================
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser       = game:GetService("VirtualUser")
local StarterGui        = game:GetService("StarterGui")
local LocalPlayer       = Players.LocalPlayer
local Camera            = workspace.CurrentCamera

local currentChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local currentHum  = currentChar:WaitForChild("Humanoid")
local currentAnim = currentHum:FindFirstChildOfClass("Animator")

local SpeedValue = 9
local JumpValue  = 200

local autoVoidEnabled = false
local tpBackEnabled   = false
local autoVoidPos     = Vector3.new(150, -495, 30)

local ANIM_WHIRLWIND = "rbxassetid://12296113986"
local ANIM_TOMAHAWK  = "rbxassetid://136370737633649"

local voidAnimList = {
    { id = "12273188754", timewait = 0.5 },
    { id = "12296113986", timewait = 0.5 },
    { id = "15145462680", timewait = 1.5 },
    { id = "16139108718", timewait = 0.1 },
    { id = "17889080495", timewait = 0 },
    { id = "14705929107", timewait = 1.3 },
    { id = "14701242661", timewait = 3 },
    { id = "14920779925", timewait = 0.2 },
    { id = "16062712948", timewait = 1 },
}

local function notify(title, content, duration)
    pcall(function()
        Window:Notify({ Title = title, Content = content, Duration = duration or 3 })
    end)
end

-- ============================================================
-- Tab 创建
-- ============================================================
local TabMain     = Window:CreateTab("主要")
local TabMisc     = Window:CreateTab("杂项")
local TabFight    = Window:CreateTab("战斗")
local TabTech     = Window:CreateTab("技巧")
local TabLag      = Window:CreateTab("防卡")
local TabAnim     = Window:CreateTab("动画")
local TabPlace    = Window:CreateTab("传送")
local TabMoveset  = Window:CreateTab("形态")
local TabFling    = Window:CreateTab("抛飞")
local TabInfo     = Window:CreateTab("信息")

-- ============================================================
-- 主要 Tab
-- ============================================================
local PageAutos = TabMain:CreateModule("自动化", "star", {})

PageAutos:CreateSelector("自动传送位置", {
    "地图", "像素", "虚空", "黑暗", "山顶", "反击点", "原子基地",
    "原子基地上方", "原子斩", "监狱"
}, "虚空", function(v)
    if v == "地图" then autoVoidPos = Vector3.new(150, 505, 30)
    elseif v == "像素" then autoVoidPos = Vector3.new(30000000, 30000000, 30000000)
    elseif v == "虚空" then autoVoidPos = Vector3.new(150, -495, 30)
    elseif v == "黑暗" then autoVoidPos = Vector3.new(0, 900000000002, 0)
    elseif v == "山顶" then autoVoidPos = Vector3.new(155.577, 628.742, -447.938)
    elseif v == "反击点" then autoVoidPos = Vector3.new(-68, 29, 20346)
    elseif v == "原子基地" then autoVoidPos = Vector3.new(1063, 30, 23006)
    elseif v == "原子基地上方" then autoVoidPos = Vector3.new(1063, 405, 23006)
    elseif v == "原子斩" then autoVoidPos = Vector3.new(1063, 131, 23006)
    elseif v == "监狱" then autoVoidPos = Vector3.new(438, 439, -376)
    end
end)

PageAutos:CreateToggle("自动 VOID / 传送", false, function(v)
    autoVoidEnabled = v
end)

PageAutos:CreateToggle("结束时传送回原位", false, function(v)
    tpBackEnabled = v
end)

local autoWhirlwind = false
PageAutos:CreateToggle("自动旋风扣篮", false, function(v)
    autoWhirlwind = v
end)

local function whirlwindHandler(animTrack)
    if autoWhirlwind and animTrack.Animation.AnimationId == ANIM_WHIRLWIND then
        task.wait(1.2)
        local hrp = currentChar:FindFirstChild("HumanoidRootPart")
        if hrp then
            local p = hrp.Position
            hrp.CFrame = CFrame.new(p.X, p.Y + 100, p.Z)
        end
    end
end

local autoWallCombo = false
local wcAnims = {
    ["rbxassetid://17325537719"] = true,
    ["rbxassetid://10469643643"] = true,
    ["rbxassetid://13294471966"] = true,
    ["rbxassetid://13295936866"] = true,
    ["rbxassetid://13378708199"] = true,
    ["rbxassetid://14136436157"] = true,
    ["rbxassetid://15162694192"] = true,
    ["rbxassetid://16552234590"] = true,
    ["rbxassetid://17889290569"] = true,
}

local function pressQ()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
end

local function wcHandler(animTrack, char)
    if not autoWallCombo or not animTrack.Animation then return end
    if wcAnims[animTrack.Animation.AnimationId] then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local cf = hrp.CFrame
            local startT = tick()
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not autoWallCombo or tick() - startT >= 0.3 then
                    if hrp and hrp.Parent then hrp.CFrame = cf end
                    conn:Disconnect()
                elseif hrp and hrp.Parent then
                    hrp.CFrame = cf * CFrame.Angles(math.rad(-25), 0, 0)
                end
            end)
        end
    end
end

local wcDescConn, wcAnimConn
local function bindWallCombo(char)
    if wcDescConn then wcDescConn:Disconnect() end
    if wcAnimConn then wcAnimConn:Disconnect() end
    wcDescConn = char.DescendantAdded:Connect(function(desc)
        if desc:IsA("ObjectValue") and desc.Name:lower() == "wallcombo" and autoWallCombo then
            local t = tick()
            repeat
                pressQ()
                task.wait()
            until not desc.Parent or desc.Parent ~= char or tick() - t >= (desc:GetAttribute("DeleteMe") or 0.6)
        end
    end)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        wcAnimConn = hum.AnimationPlayed:Connect(function(t)
            wcHandler(t, char)
        end)
    end
end

PageAutos:CreateToggle("自动 WallCombo + 全场 WallCombo", false, function(v)
    autoWallCombo = v
    if v then
        if LocalPlayer.Character then bindWallCombo(LocalPlayer.Character) end
    else
        if wcDescConn then wcDescConn:Disconnect() wcDescConn = nil end
        if wcAnimConn then wcAnimConn:Disconnect() wcAnimConn = nil end
    end
end)

-- 反隐身
local PageAntis = TabMain:CreateModule("反作弊", "shield", {})
local antiInvis = false
local invisAnims = {
    ["136370737633649"] = true,
    ["18182425133"] = true,
    ["18236605028"] = true,
}

PageAntis:CreateToggle("反隐身", false, function(v)
    antiInvis = v
end)

RunService.RenderStepped:Connect(function()
    if not antiInvis then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local anim = hum and hum:FindFirstChildOfClass("Animator")
            if anim then
                for _, t in ipairs(anim:GetPlayingAnimationTracks()) do
                    local id = t.Animation and t.Animation.AnimationId:gsub("rbxassetid://", "")
                    if id and invisAnims[id] then t:Stop() end
                end
            end
        end
    end
end)

local antiDeathCounter = false
local antiDeathThread
local function startAntiDeath()
    antiDeathCounter = true
    antiDeathThread = task.spawn(function()
        while antiDeathCounter do
            task.wait()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local anim = char:FindFirstChildOfClass("Animator")
                if anim then
                    for _, t in ipairs(anim:GetPlayingAnimationTracks()) do
                        if t.Animation.AnimationId == "rbxassetid://1234567890" then
                            task.wait(0.5)
                            local pos = char.HumanoidRootPart.Position
                            repeat
                                task.wait()
                                char.HumanoidRootPart.CFrame = CFrame.new(1000, -499, 1000)
                                task.wait(4)
                                char.HumanoidRootPart.CFrame = CFrame.new(pos)
                                task.wait(0.1)
                            until false
                        end
                    end
                end
            end
        end
    end)
end
local function stopAntiDeath()
    antiDeathCounter = false
    if antiDeathThread then task.cancel(antiDeathThread) antiDeathThread = nil end
end

PageAntis:CreateToggle("反死亡计数", false, function(v)
    if v then startAntiDeath() else stopAntiDeath() end
end)

local antiAfkConn
PageAntis:CreateToggle("反挂机", false, function(v)
    if v then
        if antiAfkConn then antiAfkConn:Disconnect() end
        antiAfkConn = LocalPlayer.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(10)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    elseif antiAfkConn then
        antiAfkConn:Disconnect() antiAfkConn = nil
    end
end)

-- OP 功能（强化解锁）
local PageOP = TabMain:CreateModule("OP 功能", "eye", {})

PageOP:CreateButton("解锁全部区域 (强力版)", function()
    local unlocked = 0

    -- 方式 1：getgc 扫描所有带锁字段 → true
    if getgc then
        for _, obj in pairs(getgc(true)) do
            if type(obj) == "table" then
                for k, v in pairs(obj) do
                    if type(k) == "string" then
                        local kl = k:lower()
                        if (kl:find("lock") or kl:find("unlock") or kl:find("access")
                            or kl:find("available") or kl:find("bought") or kl:find("purchase"))
                            and type(v) == "boolean" then
                            pcall(function()
                                rawset(obj, k, true)
                                unlocked = unlocked + 1
                            end)
                        end
                    end
                end
            end
        end
    end

    -- 方式 2：Hook 所有锁检测函数
    if hookfunction and getgc then
        for _, obj in pairs(getgc(true)) do
            if type(obj) == "table" then
                for k, v in pairs(obj) do
                    if type(v) == "function" and type(k) == "string" then
                        local kl = k:lower()
                        if kl:find("islock") or kl:find("canaccess") or kl:find("hasaccess")
                            or kl:find("isavailable") or kl:find("isunlock") then
                            pcall(function()
                                hookfunction(v, function() return true end)
                                unlocked = unlocked + 1
                            end)
                        end
                    end
                end
            end
        end
    end

    -- 方式 3：BoolValue 扫描
    local roots = { LocalPlayer, LocalPlayer:FindFirstChild("Data"), ReplicatedStorage, workspace }
    for _, root in ipairs(roots) do
        if root then
            for _, v in pairs(root:GetDescendants()) do
                if v:IsA("BoolValue") then
                    local n = v.Name:lower()
                    if n:find("lock") or n:find("unlock") or n:find("access") or n:find("bought") then
                        pcall(function()
                            v.Value = true
                            unlocked = unlocked + 1
                        end)
                    end
                end
            end
        end
    end

    -- 方式 4：触发所有 unlock 相关 Remote
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        local n = remote.Name:lower()
        if n:find("unlock") or n:find("open") then
            if remote:IsA("RemoteFunction") then
                pcall(function() remote:InvokeServer("unlock") end)
                pcall(function() remote:InvokeServer("all") end)
            elseif remote:IsA("RemoteEvent") then
                pcall(function() remote:FireServer("unlock") end)
                pcall(function() remote:FireServer("all") end)
            end
        end
    end

    workspace:SetAttribute("AllPlacesUnlocked", true)
    workspace:SetAttribute("PlacesUnlocked", true)
    workspace:SetAttribute("UnlockedPlaces", true)

    notify("解锁", "已处理 " .. unlocked .. " 个锁")
end)

PageOP:CreateButton("重置技能冷却", function()
    workspace:SetAttribute("NoDashCooldown", true)
    workspace:SetAttribute("EffectAffects", 1)
    notify("冷却", "技能冷却已重置")
end)

local PageNoDash = TabMain:CreateModule("无冷却", "zap", {})
PageNoDash:CreateToggle("无冲刺冷却", false, function(v)
    workspace:SetAttribute("EffectAffects", v and 1 or 0)
    workspace:SetAttribute("NoDashCooldown", v)
end)

-- 隐身
local PageInvis = TabMain:CreateModule("隐身", "eye-off", {})
local invisChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local invisHum = invisChar:WaitForChild("Humanoid")
local invisAnim = invisHum:FindFirstChildOfClass("Animator")
local invisEnabled = false
local invisTrack = nil

local function setCharTransparency(t)
    if invisChar then
        for _, name in ipairs({"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}) do
            local part = invisChar:FindFirstChild(name)
            if part and part:IsA("BasePart") then part.Transparency = t end
        end
    end
end

local function playInvisAnim()
    if not invisTrack or not invisTrack.IsPlaying then
        local a = Instance.new("Animation")
        a.AnimationId = ANIM_TOMAHAWK
        invisTrack = invisAnim:LoadAnimation(a)
        invisTrack:Play()
        invisTrack.TimePosition = 4.56
        invisTrack:AdjustSpeed(0)
    end
end

local function stopInvisAnim()
    if invisTrack and invisTrack.IsPlaying then
        invisTrack:Stop()
        invisTrack = nil
    end
end

PageInvis:CreateToggle("隐身", false, function(v)
    invisEnabled = v
    if v then setCharTransparency(0.5)
    else setCharTransparency(0) stopInvisAnim() end
end)

RunService.RenderStepped:Connect(function()
    if invisEnabled and invisTrack and invisTrack.IsPlaying then stopInvisAnim() end
end)
RunService.Heartbeat:Connect(function()
    if invisEnabled then playInvisAnim() end
end)

-- ESP
local PageESP = TabMain:CreateModule("透视", "package", {})
local espDeathEnabled = false
local espUltEnabled = false
local espAllEnabled = false
local espTrackers = {}

PageESP:CreateToggle("死亡计数透视", false, function(v) espDeathEnabled = v end)

task.spawn(function()
    while true do
        task.wait(1)
        if espDeathEnabled then
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("Counter") then
                    if not p:FindFirstChild("SkullBillboard") then
                        local head = p.Character:FindFirstChild("Head")
                        if head then
                            local bb = Instance.new("BillboardGui", head)
                            bb.Size = UDim2.new(5, 0, 5, 0)
                            bb.Adornee = head
                            bb.AlwaysOnTop = true
                            local lbl = Instance.new("TextLabel", bb)
                            lbl.Size = UDim2.new(1, 0, 1, 0)
                            lbl.Text = "💀"
                            lbl.TextSize = 50
                            lbl.BackgroundTransparency = 1
                            lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
                            local ov = Instance.new("ObjectValue", p)
                            ov.Name = "SkullBillboard"
                            ov.Value = bb
                        end
                    end
                elseif p:FindFirstChild("SkullBillboard") then
                    p.SkullBillboard.Value:Destroy()
                    p.SkullBillboard:Destroy()
                end
            end
        else
            for _, p in ipairs(Players:GetPlayers()) do
                if p:FindFirstChild("SkullBillboard") then
                    p.SkullBillboard.Value:Destroy()
                    p.SkullBillboard:Destroy()
                end
            end
        end
    end
end)

local function addUltTag(char, plr)
    if not espUltEnabled then return end
    local head = char:FindFirstChild("Head")
    if not head or head:FindFirstChild("UltimateTag") then return end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "UltimateTag"
    bb.Size = UDim2.new(0, 150, 0, 70)
    bb.StudsOffset = Vector3.new(0, 4, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = head
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 0.8
    lbl.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    lbl.TextColor3 = Color3.fromRGB(255, 255, 0)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.FredokaOne
    lbl.TextStrokeTransparency = 0.5
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    local function upd()
        local u = plr:GetAttribute("Ultimate")
        lbl.Text = u and "大招: " .. tostring(math.floor(u)) or "大招: N/A"
    end
    upd()
    plr:GetAttributeChangedSignal("Ultimate"):Connect(upd)
end

PageESP:CreateToggle("大招进度透视", false, function(v)
    espUltEnabled = v
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and v then addUltTag(p.Character, p)
        elseif not v and p.Character then
            local tag = p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("UltimateTag")
            if tag then tag:Destroy() end
        end
    end
end)

local function addPlayerInfo(plr, char)
    if not espAllEnabled then return end
    local hum = char:WaitForChild("Humanoid")
    local head = char:WaitForChild("Head")
    local txt = Drawing.new("Text")
    txt.Visible = false
    txt.Center = true
    txt.Outline = true
    txt.Font = 3
    txt.Size = 18
    txt.Color = Color3.fromRGB(255, 255, 255)
    local function getTxt()
        local ping = math.floor(plr:GetAttribute("Ping") or 0)
        local device = plr:GetAttribute("Mobile") and "手机" or "PC"
        local streak = workspace.Live:FindFirstChild(plr.Name) and workspace.Live[plr.Name]:GetAttribute("CurrentStreak") or 0
        return "[ " .. plr.Name .. " | 延迟: " .. ping .. " | " .. device .. " | 连胜: " .. streak .. " ]"
    end
    local conns = {}
    local function cleanup()
        txt:Remove()
        for _, c in ipairs(conns) do c:Disconnect() end
        espTrackers[plr] = nil
    end
    table.insert(conns, char.AncestryChanged:Connect(function(_, p) if not p then cleanup() end end))
    table.insert(conns, hum.Died:Connect(cleanup))
    table.insert(conns, RunService.RenderStepped:Connect(function()
        if not espAllEnabled or not head or not head.Parent then cleanup() return end
        local sp, on = Camera:WorldToViewportPoint(head.Position)
        if on then
            txt.Position = Vector2.new(sp.X, sp.Y - 27)
            txt.Text = getTxt()
            txt.Visible = true
        else
            txt.Visible = false
        end
    end))
    espTrackers[plr] = { cleanup }
end

PageESP:CreateToggle("全部玩家信息透视", false, function(v)
    espAllEnabled = v
    if v then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then addPlayerInfo(p, p.Character) end
        end
    else
        for _, data in pairs(espTrackers) do
            if data[1] then data[1]() end
        end
        espTrackers = {}
    end
end)

-- 移动
local PageMove = TabMain:CreateModule("移动", "settings", {})
local speedToggle = false

local function setSpeed(v)
    speedToggle = v
    if v then
        task.spawn(function()
            while speedToggle and currentChar and currentChar.Parent do
                local hum = currentChar:FindFirstChildOfClass("Humanoid")
                if hum and hum.MoveDirection.Magnitude > 0 then
                    currentChar:TranslateBy(hum.MoveDirection * SpeedValue * RunService.Heartbeat:Wait() * 7)
                else
                    task.wait()
                end
            end
        end)
    end
end

PageMove:CreateToggle("移速 (V 键开关)", false, setSpeed)
PageMove:CreateSlider("移速数值", 1, 100, 9, function(v) SpeedValue = v end)

UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.V and not gp then
        setSpeed(not speedToggle)
    end
end)

local jumpBoost = false
PageMove:CreateToggle("跳跃增强", false, function(v)
    jumpBoost = v
    if v then
        task.spawn(function()
            while jumpBoost do
                if currentHum and currentHum:GetState() == Enum.HumanoidStateType.Jumping then
                    currentChar.HumanoidRootPart.CFrame = currentChar.HumanoidRootPart.CFrame * CFrame.new(0, JumpValue, 0)
                end
                task.wait()
            end
        end)
    end
end)

PageMove:CreateSlider("跳跃数值", 1, 1000, 200, function(v) JumpValue = v end)

PageMove:CreateToggle("无硬直", false, function(v)
    task.spawn(function()
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if v == true then
                pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 25 end)
            else
                conn:Disconnect()
            end
        end)
    end)
end)

-- 角色
local PageChar = TabMain:CreateModule("角色", "box", {})
local fakeDownslam = false

PageChar:CreateToggle("假下砸动画", false, function(v) fakeDownslam = v end)

currentHum.StateChanged:Connect(function(_, new)
    if fakeDownslam and new == Enum.HumanoidStateType.Jumping then
        local a = Instance.new("Animation")
        a.AnimationId = "rbxassetid://10470104242"
        local t = currentHum:LoadAnimation(a)
        task.wait(0.3)
        t:Play()
    end
end)

PageChar:CreateToggle("自动回安全区", false, function(v)
    if v then
        task.spawn(function()
            local sent = false
            while v do
                if currentHum and currentHum.Health < 45 and not sent then
                    currentChar.HumanoidRootPart.CFrame = CFrame.new(150, 705, 30)
                    sent = true
                elseif currentHum and currentHum.Health == 50 and sent then
                    sent = false
                end
                task.wait(0.15)
            end
        end)
    end
end)

PageChar:CreateToggle("出生特效石", false, function(v)
    if v then
        task.spawn(function()
            while v and currentChar and currentChar:FindFirstChild("Communicate") do
                currentChar.Communicate:FireServer({ Dash = Enum.KeyCode.S, Key = Enum.KeyCode.Q, Goal = "KeyPress" })
                task.wait(0.15)
            end
        end)
    end
end)

local roastList = {
    "菜", "再来一次吧", "你这水平不行", "太简单了", "你太菜了",
    "开玩笑吧?", "打不过我", "别哭啊", "差不多得了", "Ez",
}
PageChar:CreateToggle("嘲讽死亡玩家", false, function(v)
    if v then
        task.spawn(function()
            while v do
                local hrp = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local closest, dist = nil, 65
                    for _, m in ipairs(workspace.Live:GetChildren()) do
                        local h = m:FindFirstChildOfClass("Humanoid")
                        local r = m:FindFirstChild("HumanoidRootPart")
                        if h and r and m ~= currentChar and h.Health == 0 then
                            local d = (hrp.Position - r.Position).magnitude
                            if d < dist then dist = d closest = r end
                        end
                    end
                    if closest then
                        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(roastList[math.random(#roastList)], "All")
                    end
                end
                task.wait(2.85)
            end
        end)
    end
end)

-- ============================================================
-- 杂项 Tab
-- ============================================================
local PageUni = TabMisc:CreateModule("通用脚本", "flame", {})

PageUni:CreateButton("无限收益", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)
PageUni:CreateButton("Dex 浏览器", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Classic-Dex-Explorer-21009"))()
end)
PageUni:CreateButton("Remote 间谍", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"))()
end)
PageUni:CreateButton("手机键盘", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt", true))()
end)
PageUni:CreateButton("动画记录器", function()
    loadstring(game:HttpGet("https://pastefy.app/juBGMpCZ/raw"))()
end)
PageUni:CreateButton("F3X 建造工具", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/refs/heads/main/f3x.lua"))()
end)
PageUni:CreateButton("飞行 V3", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/xuSMWfDu"))()
end)
PageUni:CreateButton("VFX 记录器", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/2uXfJqdU"))()
end)
PageUni:CreateButton("自动格挡 V10", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/TSB/refs/heads/main/CombatGui"))()
end)

local PagePlayer = TabMisc:CreateModule("玩家", "star", {})
PagePlayer:CreateButton("跳服", function() loadstring(game:HttpGet("https://pastefy.app/uTXUoORd/raw"))() end)
PagePlayer:CreateButton("重新进服", function() game:GetService("TeleportService"):Teleport(game.PlaceId) end)
PagePlayer:CreateButton("重置角色", function() loadstring(game:HttpGet("https://pastefy.app/YPv8xrYN/raw"))() end)
PagePlayer:CreateButton("修复相机 V1", function()
    Camera.CameraType = Enum.CameraType.Custom
    LocalPlayer.CameraMode = Enum.CameraMode.Classic
end)
PagePlayer:CreateButton("修复相机 V2", function() loadstring(game:HttpGet("https://pastefy.app/IrvnCaF2/raw"))() end)

local PageRandom = TabMisc:CreateModule("随机", "utensils", {})
PageRandom:CreateButton("购买限定表情", function() loadstring(game:HttpGet("https://pastefy.app/UiPAjkB4/raw"))() end)
PageRandom:CreateButton("奇怪角色 Mod", function() loadstring(game:HttpGet("https://pastefy.app/dwPwscTr/raw"))() end)
PageRandom:CreateButton("奇怪攻击", function() loadstring(game:HttpGet("https://pastefy.app/jP73sWh8/raw"))() end)
PageRandom:CreateButton("秃头假人", function() loadstring(game:HttpGet("https://pastefy.app/b1matovZ/raw"))() end)
PageRandom:CreateButton("疯狂旋转", function() loadstring(game:HttpGet("https://pastefy.app/BFB6IlAQ/raw"))() end)
PageRandom:CreateButton("疯狂跳舞", function() loadstring(game:HttpGet("https://pastefy.app/I5eLfnge/raw"))() end)
PageRandom:CreateToggle("反飞行封禁", false, function(v) workspace:SetAttribute("VIPServer", v) end)

-- ============================================================
-- 战斗 Tab
-- ============================================================
local PageFarm = TabFight:CreateModule("农场", "map", {})

PageFarm:CreateButton("垃圾桶击杀农场", function()
    getgenv().Settings = { TargetHealth = 50, CharacterHeight = 8, ResetStreak = false, AntiDC = false }
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DiosDi/VexonHub/refs/heads/main/TrashCan-Farm"))()
end)
PageFarm:CreateButton("自动获取表情", function()
    loadstring(game:HttpGet("https://pastefy.app/bqVKWKRG/raw"))()
end)

local resetStreak = false
PageFarm:CreateToggle("自动重置连胜", false, function(v)
    resetStreak = v
    if v then
        task.spawn(function()
            while resetStreak do
                local live = workspace:FindFirstChild("Live")
                if live then
                    local me = live:FindFirstChild(LocalPlayer.Name)
                    if me and (me:GetAttribute("CurrentStreak") or 0) >= 9 then
                        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if h then h.Health = 0 end
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

local autoKillLowest = false
PageFarm:CreateToggle("自动打最低血量玩家", false, function(v)
    autoKillLowest = v
    if v then
        task.spawn(function()
            while autoKillLowest do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local target, hp = nil, math.huge
                    for _, m in ipairs(workspace.Live:GetChildren()) do
                        if Players:GetPlayerFromCharacter(m) then
                            local h = m:FindFirstChildOfClass("Humanoid")
                            local r = m:FindFirstChild("HumanoidRootPart")
                            if h and r and m ~= char and h.Health > 0 and h.Health <= 35 then
                                hp = h.Health target = r
                            end
                        end
                    end
                    if target then
                        char:SetPrimaryPartCFrame(CFrame.new(
                            target.Position - Vector3.new(0, target.Size.Y / 2, 0)
                            - target.CFrame.LookVector * 5 + Vector3.new(0, -6, 0),
                            target.Position - Vector3.new(0, target.Size.Y / 2, 0)))
                        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                            if tool:IsA("Tool") and tool.Name ~= "Prey's Peril" and tool.Name ~= "Split Second Counter" then
                                char:WaitForChild("Humanoid"):EquipTool(tool)
                                tool:Activate()
                                char:WaitForChild("Humanoid"):UnequipTools()
                            end
                        end
                    else
                        char.HumanoidRootPart.CFrame = CFrame.new(150, 705, 30)
                    end
                end
                task.wait(0.015)
            end
        end)
    end
end)

local autoKillNearest = false
PageFarm:CreateToggle("自动打最近玩家", false, function(v)
    autoKillNearest = v
    if v then
        task.spawn(function()
            while autoKillNearest do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local target, dist = nil, math.huge
                    for _, m in ipairs(workspace.Live:GetChildren()) do
                        if Players:GetPlayerFromCharacter(m) then
                            local h = m:FindFirstChildOfClass("Humanoid")
                            local r = m:FindFirstChild("HumanoidRootPart")
                            if h and r and m ~= char and h.Health > 0 then
                                local d = (hrp.Position - r.Position).magnitude
                                if d < dist then dist = d target = r end
                            end
                        end
                    end
                    if target then
                        char:SetPrimaryPartCFrame(CFrame.new(
                            target.Position - Vector3.new(0, target.Size.Y / 2, 0)
                            - target.CFrame.LookVector * 5 + Vector3.new(0, -6, 0),
                            target.Position - Vector3.new(0, target.Size.Y / 2, 0)))
                    end
                end
                task.wait(0.015)
            end
        end)
    end
end)

local autoGiveKills = false
PageFarm:CreateToggle("自动送人头", false, function(v)
    autoGiveKills = v
    if v then
        task.spawn(function()
            while autoGiveKills do
                pcall(function()
                    local me = workspace.Live[LocalPlayer.Name]
                    local h = me:FindFirstChild("Humanoid")
                    if h.MaxHealth ~= h.Health then LocalPlayer.Character.Humanoid.Health = 0 end
                end)
                task.wait(0.35)
            end
        end)
    end
end)

local PageFighting = TabFight:CreateModule("战斗", "sword", {})

local aimCamKey = "Z"
local aimCharKey = "X"
local aimCamOn, aimCharOn = false, false
local aimTarget

local function findCenterTarget()
    local dist = math.huge
    local target
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local h = p.Character:FindFirstChild("Humanoid")
            if h and h.Health > 0 then
                local hrp = p.Character.HumanoidRootPart
                local sp, on = Camera:WorldToViewportPoint(hrp.Position)
                if on then
                    local d = (center - Vector2.new(sp.X, sp.Y)).Magnitude
                    if d < dist then dist = d target = hrp end
                end
            end
        end
    end
    return target
end

RunService.Heartbeat:Connect(function()
    if not aimTarget or not aimTarget.Parent then return end
    local h = aimTarget.Parent:FindFirstChild("Humanoid")
    if not h or h.Health <= 0 then aimTarget = nil return end
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    local predicted = aimTarget.Position + aimTarget.Velocity * 0.016
    if aimCamOn then Camera.CFrame = CFrame.new(Camera.CFrame.Position, predicted) end
    if aimCharOn then myHrp.CFrame = CFrame.new(myHrp.Position, Vector3.new(predicted.X, myHrp.Position.Y, predicted.Z)) end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if input.KeyCode.Name == aimCamKey then
        aimCamOn = not aimCamOn aimCharOn = false
        aimTarget = (aimCamOn or aimCharOn) and findCenterTarget() or nil
    elseif input.KeyCode.Name == aimCharKey then
        aimCharOn = not aimCharOn aimCamOn = false
        aimTarget = (aimCamOn or aimCharOn) and findCenterTarget() or nil
    end
end)

PageFighting:CreateToggle("瞄准锁定 (相机)", false, function(v)
    aimCamOn = v aimCharOn = false
    aimTarget = v and findCenterTarget() or nil
end)
PageFighting:CreateToggle("瞄准锁定 (角色)", false, function(v)
    aimCharOn = v aimCamOn = false
    aimTarget = v and findCenterTarget() or nil
end)

local autoPunchReach = false
PageFighting:CreateToggle("M1 攻击距离扩展", false, function(v)
    autoPunchReach = v
    if v then
        task.spawn(function()
            while autoPunchReach do
                pcall(function()
                    local me = workspace.Live[LocalPlayer.Name]
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if me:FindFirstChild("M1ing") and hrp then
                        local target, dist = nil, 999999
                        for _, m in ipairs(workspace.Live:GetChildren()) do
                            local h = m:FindFirstChildOfClass("Humanoid")
                            local r = m:FindFirstChild("HumanoidRootPart")
                            if h and r and m ~= char and h.Health > 0 then
                                local d = (hrp.Position - r.Position).magnitude
                                if d < dist then dist = d target = r end
                            end
                        end
                        if target then
                            local pos = target.Position - target.CFrame.LookVector * 3
                            char:SetPrimaryPartCFrame(CFrame.new(pos, pos + (target.Position - pos).unit))
                        end
                    end
                end)
                task.wait(0.015)
            end
        end)
    end
end)

local autoHit = false
PageFighting:CreateToggle("自动攻击", false, function(v)
    autoHit = v
    if v then
        task.spawn(function()
            while autoHit do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            if (hrp.Position - p.Character.HumanoidRootPart.Position).Magnitude < 10 then
                                char.Communicate:FireServer({ Goal = "LeftClick", Mobile = true })
                                task.wait(0.1)
                                char.Communicate:FireServer({ Goal = "LeftClickRelease", Mobile = true })
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

local autoDodge = false
PageFighting:CreateToggle("自动闪避玩家", false, function(v)
    autoDodge = v
    if v then
        local dodgeAnims = {
            10479335397, 13380255751, 10468665991, 10466974800, 10471336737,
            12510170988, 12272894215, 12296882427, 12307656616,
        }
        task.spawn(function()
            local conn
            conn = RunService.RenderStepped:Connect(function()
                if not autoDodge then conn:Disconnect() return end
                pcall(function()
                    for _, m in ipairs(workspace.Live:GetChildren()) do
                        if m:IsA("Model") and m:FindFirstChild("Head") and m.Head ~= LocalPlayer.Character.Head then
                            if (m.Head.Position - LocalPlayer.Character.Head.Position).magnitude <= 25 then
                                local h = m:FindFirstChildOfClass("Humanoid")
                                if h and h.Health > 0 then
                                    local isAttacking = false
                                    for _, t in pairs(h:GetPlayingAnimationTracks()) do
                                        if table.find(dodgeAnims, tonumber(t.Animation.AnimationId:match("%d+"))) then
                                            isAttacking = true break
                                        end
                                    end
                                    if m:FindFirstChild("M1ing") or isAttacking then
                                        LocalPlayer.Character.HumanoidRootPart.CFrame =
                                            CFrame.new(m.Head.Position + m.Head.CFrame.lookVector * -5, m.Head.Position)
                                    end
                                end
                            end
                        end
                    end
                end)
            end)
        end)
    end
end)

PageFighting:CreateButton("简易击杀面板", function()
    loadstring(game:HttpGet("https://pastefy.app/7qmTI84P/raw"))()
end)

-- ============================================================
-- 技巧 Tab
-- ============================================================
local PageTech = TabTech:CreateModule("技巧脚本", "box", {})
PageTech:CreateButton("M1 重置脚本", function()
    getgenv().keybinds = { m1reset = Enum.KeyCode.R, emotedash = Enum.KeyCode.T, rotation = Enum.KeyCode.H }
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Slaphello/M1-Reset-And-Emote-Dash-TSB-OLD-/refs/heads/main/M1R%26ED%20TSB"))()
end)
PageTech:CreateButton("自动京都脚本", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Auto%20kyoto%20ma%20hoa"))() end)
PageTech:CreateButton("循环冲刺", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Loop%20Dash%20Rework%20Script%20Real"))() end)
PageTech:CreateButton("奥利奥冲刺", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Oreo%20Tech%20Script"))() end)
PageTech:CreateButton("龙卷风冲刺", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Idk%20lolololol"))() end)
PageTech:CreateButton("超强冲刺", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/Supa%20tech%20script"))() end)
PageTech:CreateButton("后撤步 (手机)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/BackDash%20Tech"))() end)
PageTech:CreateButton("后撤步 (电脑)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/BackDash%20For%20Pc"))() end)

local PageAutoTech = TabTech:CreateModule("自动技巧", "sword", {})
local trueDownSlam = false
local tdsConn

PageAutoTech:CreateToggle("真·下砸", false, function(v)
    trueDownSlam = v
    if tdsConn then tdsConn:Disconnect() tdsConn = nil end
    if not v then return end
    local slamList = {
        ["rbxassetid://13532600125"] = true, ["rbxassetid://10469630950"] = true,
        ["rbxassetid://13296577783"] = true, ["rbxassetid://13370310513"] = true,
        ["rbxassetid://15240216931"] = true, ["rbxassetid://16515520431"] = true,
        ["rbxassetid://17889461810"] = true,
    }
    local uppercutList = {
        ["rbxassetid://13532604085"] = true, ["rbxassetid://10469639222"] = true,
        ["rbxassetid://13295919399"] = true, ["rbxassetid://13378751717"] = true,
        ["rbxassetid://15240176873"] = true, ["rbxassetid://16515448089"] = true,
        ["rbxassetid://17889471098"] = true,
    }
    local cd = {}
    local myChar, myHum
    local function refresh()
        myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        myHum = myChar:WaitForChild("Humanoid")
        myChar.PrimaryPart = myChar:WaitForChild("HumanoidRootPart")
    end
    local function lift()
        if not myChar or not myChar.PrimaryPart then return end
        local cs = Camera.CameraSubject
        Camera.CameraSubject = nil
        local p = myChar:GetPivot()
        local target = p + Vector3.new(0, 7, 0)
        for i = 1, 10 do
            myChar:PivotTo(p:Lerp(target, i / 10))
            task.wait(0.01)
        end
        Camera.CameraSubject = cs
    end
    refresh()
    tdsConn = RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character ~= myChar then refresh() end
        for _, t in pairs(myHum:GetPlayingAnimationTracks()) do
            local id = tostring(t.Animation.AnimationId)
            local now = tick()
            if slamList[id] and (not cd[id] or now - cd[id] > 0.5) then
                cd[id] = now
                task.delay(0.15, lift)
            elseif uppercutList[id] and (not cd[id] or now - cd[id] > 0.5) then
                cd[id] = now
                task.delay(0.15, function() myHum:ChangeState(Enum.HumanoidStateType.Jumping) end)
            end
        end
    end)
end)

local twistAnim = "rbxassetid://13294471966"
local twistOn = false
local twistConn

local function twistQ()
    LocalPlayer.Character.Communicate:FireServer({ Dash = Enum.KeyCode.W, Key = Enum.KeyCode.Q, Goal = "KeyPress" })
end
local function twistForward()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 3) end
end

PageAutoTech:CreateToggle("自动扭曲技巧", false, function(v)
    twistOn = v
    if twistConn then twistConn:Disconnect() twistConn = nil end
    if not v then return end
    local hum = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("Humanoid")
    local function bindAnim(h)
        twistConn = h.AnimationPlayed:Connect(function(t)
            if t.Animation and t.Animation.AnimationId == twistAnim and not twistOn then return end
            if t.Animation and t.Animation.AnimationId == twistAnim then
                task.delay(0.23, function() twistForward() twistQ() end)
            end
        end)
    end
    local a = hum:FindFirstChildOfClass("Animator")
    if a then bindAnim(a) else hum.ChildAdded:Connect(function(c) if c:IsA("Animator") then bindAnim(c) end end) end
end)

local instaTwistOn = false
local instaTwistConn
PageAutoTech:CreateToggle("瞬间扭曲技巧", false, function(v)
    instaTwistOn = v
    if instaTwistConn then instaTwistConn:Disconnect() instaTwistConn = nil end
    if not v then return end
    local hum = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("Humanoid")
    local anim = hum:FindFirstChildOfClass("Animator")
    if not anim then return end
    instaTwistConn = anim.AnimationPlayed:Connect(function(t)
        if t.Animation and t.Animation.AnimationId == twistAnim and not instaTwistOn then return end
        if t.Animation and t.Animation.AnimationId == twistAnim then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * -1 end
            task.delay(0.25, function()
                twistQ()
                task.wait(0.26)
                local hrp2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp2 then
                    local cf = hrp2.CFrame
                    local back = -cf.LookVector
                    hrp2.CFrame = CFrame.lookAt(cf.Position, cf.Position + back)
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + back)
                end
            end)
        end
    end)
end)

local flowGraspOn = false
local flowGraspConn
PageAutoTech:CreateToggle("流动 + 抓取", false, function(v)
    flowGraspOn = v
    if flowGraspConn then flowGraspConn:Disconnect() flowGraspConn = nil end
    if not v then return end
    local flowingAnim = "rbxassetid://12273188754"
    local triggered = false
    flowGraspConn = RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        local playing = false
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
            if t.Animation and t.Animation.AnimationId == flowingAnim then playing = true break end
        end
        if playing and not triggered then
            triggered = true
            task.delay(1.8, function()
                local target = hrp.CFrame + hrp.CFrame.LookVector * 24
                local tw = TweenService:Create(hrp, TweenInfo.new(0.1), { CFrame = target })
                tw:Play()
                tw.Completed:Wait()
                local grasp = LocalPlayer.Backpack:FindFirstChild("Hunter's Grasp")
                local comm = char:FindFirstChild("Communicate")
                if grasp and comm then comm:FireServer({ Tool = grasp, Goal = "Console Move" }) end
                triggered = false
            end)
        elseif not playing then
            triggered = false
        end
    end)
end)

-- ============================================================
-- 防卡 Tab
-- ============================================================
local PageLag = TabLag:CreateModule("防卡", "heart", {})
PageLag:CreateButton("清除生成石头", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/louismich4el/ItsLouisPlayz-Scripts/main/TSB%20Anti%20Lag.lua"))()
end)
PageLag:CreateToggle("低画质模式", false, function(v)
    if not v then return end
    pcall(function()
        sethiddenproperty(game.Lighting, "Technology", 2)
        sethiddenproperty(workspace.Terrain, "Decoration", false)
        workspace.Terrain.WaterWaveSize = 0
        workspace.Terrain.WaterWaveSpeed = 0
        workspace.Terrain.WaterReflectance = 0
        workspace.Terrain.WaterTransparency = 0
        game.Lighting.GlobalShadows = 0
        game.Lighting.FogEnd = 9e9
        game.Lighting.Brightness = 0
        settings().Rendering.QualityLevel = "Level01"
        for _, o in pairs(workspace:GetDescendants()) do
            if o:IsA("BasePart") and not o:IsA("MeshPart") then
                o.Material = "Plastic" o.Reflectance = 0
            elseif o:IsA("Decal") or o:IsA("Texture") then
                o.Transparency = 1
            elseif o:IsA("ParticleEmitter") or o:IsA("Trail") then
                o.Lifetime = NumberRange.new(0)
            elseif o:IsA("Explosion") then
                o.BlastPressure = 1 o.BlastRadius = 1
            elseif o:IsA("Fire") or o:IsA("SpotLight") or o:IsA("Smoke") or o:IsA("Sparkles") then
                o.Enabled = false
            elseif o:IsA("MeshPart") then
                o.Material = "Plastic" o.Reflectance = 0
            end
        end
    end)
end)

local mapPart = workspace:FindFirstChild("Map")
if mapPart then
    local hiddenParts = {}
    local function toggleMapPart(name, show)
        local p = mapPart:FindFirstChild(name)
        if show then
            if not p and hiddenParts[name] then hiddenParts[name].Parent = mapPart end
        elseif p then
            hiddenParts[name] = p
            p.Parent = nil
        end
    end
    local PageHide = TabLag:CreateModule("隐藏场景", "package", {})
    PageHide:CreateToggle("树", true, function(v) toggleMapPart("Trees", v) end)
    PageHide:CreateToggle("墙", true, function(v) toggleMapPart("Walls", v) end)
    PageHide:CreateToggle("草", true, function(v) toggleMapPart("Grass", v) toggleMapPart("GrassBottom", v) end)
    PageHide:CreateToggle("长椅", true, function(v) toggleMapPart("Benchs", v) end)
end

-- ============================================================
-- 动画 Tab
-- ============================================================
local PageAnim = TabAnim:CreateModule("动画控制", "eye", {})
PageAnim:CreateInput({
    Name = "播放动画 ID",
    Default = "",
    Placeholder = "例如: 12296113986",
    Callback = function(v)
        if tonumber(v) then
            local a = Instance.new("Animation")
            a.AnimationId = "rbxassetid://" .. v
            local hum = currentChar:FindFirstChildOfClass("Humanoid")
            if hum then
                local anim = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
                anim:LoadAnimation(a):Play()
            end
        end
    end,
})

local noAnimConn1
PageAnim:CreateToggle("禁用动画", false, function(v)
    if noAnimConn1 then noAnimConn1:Disconnect() noAnimConn1 = nil end
    if v then
        local hum = currentChar:WaitForChild("Humanoid")
        noAnimConn1 = hum.AnimationPlayed:Connect(function(t)
            if t.Animation.AnimationId:match("%d+") ~= "136370737633649" then t:Stop() end
        end)
    end
end)

local PageChars = TabAnim:CreateModule("角色动画", "user", {})
for _, item in ipairs({
    { "KJ/Gojo/假人 特殊动画", "https://pastefy.app/qfu9PA3v/raw" },
    { "埼玉 动画", "https://pastefy.app/77H3wRXO/raw" },
    { "饿狼 动画", "https://pastefy.app/VY6onISD/raw" },
    { "杰诺斯 动画", "https://pastefy.app/0EPn6woL/raw" },
    { "索尼克 动画", "https://pastefy.app/KaiJDJHg/raw" },
    { "金属球棒 动画", "https://pastefy.app/mObEgCqc/raw" },
    { "原子武士 动画", "https://pastefy.app/9bllab1z/raw" },
    { "龙卷 动画", "https://pastefy.app/qhJrd1zw/raw" },
    { "水龙 动画", "https://pastefy.app/AKyKbIt0/raw" },
}) do
    PageChars:CreateButton(item[1], function() loadstring(game:HttpGet(item[2]))() end)
end

-- ============================================================
-- 传送 Tab
-- ============================================================
local PageTP = TabPlace:CreateModule("传送", "map", {})
PageTP:CreateButton("传送面板", function() loadstring(game:HttpGet("https://pastefy.app/uiTL0dfO/raw"))() end)
PageTP:CreateButton("冻结锁定传送", function() loadstring(game:HttpGet("https://pastefy.app/yxXqDjA2/raw"))() end)
PageTP:CreateButton("传送到假人", function() loadstring(game:HttpGet("https://pastefy.app/oJwPZY4a/raw"))() end)

local tpPoints = {
    { "地图中央", 139, 440, 32 },
    { "监狱", 438, 439, -376 },
    { "山顶", 155, 628, -447 },
    { "门 1", 17, 440, -301 },
    { "门 2", 290, 440, 361 },
    { "角 1", 29, 442, 488 },
    { "角 2", -261, 442, -248 },
    { "角 3", 263, 442, -456 },
    { "角 4", 566, 442, 274 },
    { "反击点", -68, 29, 20346 },
    { "反击点上方", -78, 84, 20354 },
    { "原子基地", 1063, 30, 23006 },
    { "原子基地上方", 1063, 405, 23006 },
    { "原子斩", 1063, 131, 23006 },
    { "原子斩上方", 1063, 190, 23006 },
    { "小安全区", 150, 505, 30 },
    { "大安全区", 150, 705, 30 },
    { "虚空", 150, -495, 30 },
    { "黑暗", 0, 900000000005, 0 },
    { "像素", 30000000, 30000000, 30000000 },
}
for _, pt in ipairs(tpPoints) do
    PageTP:CreateButton("传送到" .. pt[1], function()
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            c.HumanoidRootPart.CFrame = CFrame.new(pt[2], pt[3], pt[4])
        end
    end)
end

-- ============================================================
-- 形态 Tab
-- ============================================================
local PageMoveset = TabMoveset:CreateModule("角色形态", "box", {})
local movesets = {
    { "垃圾幽灵 (通用)", "https://raw.githubusercontent.com/DiosDi/VexonHub/refs/heads/main/TheGarbageGhost" },
    { "垃圾桶人 (通用)", "https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Trashcan%20Man" },
    { "星空滑翔者 (通用)", "https://raw.githubusercontent.com/Reapvitalized/TSB/refs/heads/main/SG_DEMO.lua" },
    { "KJ (埼玉)", "https://rawscripts.net/raw/The-Strongest-Battlegrounds-JK-Moveset-24889" },
    { "拳士 (埼玉)", "https://raw.githubusercontent.com/Kenjihin69/Kenjihin69/refs/heads/main/Tp%20exploit%20saitama%20to%20jun" },
    { "五条悟 1 (埼玉)", "https://raw.githubusercontent.com/Nova2ezz/jjs-gojo-/refs/heads/main/SaitamaToGojoV3_SOURCE-obfuscated_2.txt" },
    { "五条悟 2 (埼玉)", "https://raw.githubusercontent.com/skibiditoiletfan2007/BaldyToSorcerer/refs/heads/main/LatestV2.lua" },
    { "真人 (埼玉)", "https://raw.githubusercontent.com/dendendenver1/mahitotsbthing/refs/heads/main/main.lua" },
    { "虎杖/宿傩 (埼玉)", "https://pastebin.com/raw/1yaXL0rA" },
    { "黑崎一护 (埼玉)", "https://raw.githubusercontent.com/grest0n/CustomMovesets/refs/heads/main/Ichigo%20Kurosaki" },
    { "波奇 (埼玉)", "https://raw.githubusercontent.com/dendendenver1/HakariTSB/refs/heads/main/HakariTSB.lua" },
    { "亚瑟 (饿狼)", "https://raw.githubusercontent.com/Reapvitalized/TSB/refs/heads/main/ARCAURA.lua" },
    { "KJ (饿狼)", "https://rawscripts.net/raw/KJ-The-Strongest-Battlegrounds-Garou-to-kj-27085" },
    { "链锯人 (饿狼)", "https://gist.githubusercontent.com/GoldenHeads2/0fd8d36993c850f3fac89e5adf793076/raw/ab4f5a42bd0b2e24a32a46301d533ea849ca771c/gistfile1.txt" },
    { "奥卡伦 (饿狼)", "https://rawscripts.net/raw/The-Strongest-Battlegrounds-Garou-to-OKARUN-24065" },
    { "宿傩 (饿狼)", "https://rawscripts.net/raw/The-Strongest-Battlegrounds-Garou-to-Sukuna-24081" },
    { "赛博精神病 (饿狼)", "https://pastebin.com/raw/7V1mUBtQ" },
    { "悟空 V2 (饿狼)", "https://rawscripts.net/raw/The-Strongest-Battlegrounds-Goku-Moveset-V2-17977" },
    { "米诺斯 (饿狼)", "https://raw.githubusercontent.com/S1gmaGuy/MinosPrimeFixed/refs/heads/main/ThefixIsSoSigma" },
    { "伏黑惠 (原子武士)", "https://rawscripts.net/raw/The-Strongest-Battlegrounds-Toji-moveset-for-Atomic-Samurai-22498" },
    { "宿傩 (原子武士)", "https://pastebin.com/raw/gUrBYsGK" },
    { "伏黑惠 (索尼克)", "https://rawscripts.net/raw/The-Strongest-Battlegrounds-Toji-moveset-21449" },
    { "沃尔特 (索尼克)", "https://raw.githubusercontent.com/Reapvitalized/TSB/refs/heads/main/VOLTA.lua" },
    { "阿波菲尼亚 (金属球棒)", "https://raw.githubusercontent.com/Reapvitalized/TSB/main/APOPHENIA.lua" },
}
for _, set in ipairs(movesets) do
    PageMoveset:CreateButton(set[1], function() loadstring(game:HttpGet(set[2]))() end)
end

-- ============================================================
-- 抛飞 Tab
-- ============================================================
local PageFling = TabFling:CreateModule("抛飞", "user", {})
local selectedFlingTarget = nil
local flingStates = { teleport = false, view = false, aimCam = false, aimChar = false, orbit = false }

PageFling:CreateInput({
    Title = "选择目标玩家",
    Placeholder = "输入玩家名",
    Callback = function(v)
        if not v or v == "" then selectedFlingTarget = nil return end
        local lv = string.lower(v)
        for _, p in ipairs(Players:GetPlayers()) do
            if string.find(string.lower(p.Name), lv, 1, true) or string.find(string.lower(p.DisplayName), lv, 1, true) then
                selectedFlingTarget = p
                notify("抛飞", "已选择: " .. p.DisplayName)
                return
            end
        end
        notify("抛飞", "未找到玩家")
    end,
})

PageFling:CreateButton("传送到目标", function()
    if not selectedFlingTarget then notify("抛飞", "未选择玩家") return end
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local tHrp = selectedFlingTarget.Character and selectedFlingTarget.Character:FindFirstChild("HumanoidRootPart")
    if myHrp and tHrp then myHrp.CFrame = tHrp.CFrame end
end)

PageFling:CreateToggle("循环传送", false, function(v)
    flingStates.teleport = v
    if v and selectedFlingTarget then
        task.spawn(function()
            while flingStates.teleport and selectedFlingTarget and selectedFlingTarget.Parent do
                local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local tHrp = selectedFlingTarget.Character and selectedFlingTarget.Character:FindFirstChild("HumanoidRootPart")
                if myHrp and tHrp then myHrp.CFrame = tHrp.CFrame end
                task.wait()
            end
        end)
    end
end)

PageFling:CreateToggle("循环查看", false, function(v)
    flingStates.view = v
    if v and selectedFlingTarget then
        task.spawn(function()
            while flingStates.view and selectedFlingTarget and selectedFlingTarget.Parent do
                local tHum = selectedFlingTarget.Character and selectedFlingTarget.Character:FindFirstChildOfClass("Humanoid")
                if tHum then Camera.CameraSubject = tHum end
                task.wait(0.1)
            end
        end)
    end
end)

PageFling:CreateToggle("瞄准锁定 (相机)", false, function(v)
    flingStates.aimCam = v
    if v and selectedFlingTarget then
        task.spawn(function()
            while flingStates.aimCam and selectedFlingTarget and selectedFlingTarget.Parent do
                local head = selectedFlingTarget.Character and selectedFlingTarget.Character:FindFirstChild("Head")
                if head then Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position) end
                RunService.RenderStepped:Wait()
            end
        end)
    end
end)

PageFling:CreateToggle("瞄准锁定 (角色)", false, function(v)
    flingStates.aimChar = v
    if v and selectedFlingTarget then
        task.spawn(function()
            while flingStates.aimChar and selectedFlingTarget and selectedFlingTarget.Parent do
                local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local tHrp = selectedFlingTarget.Character and selectedFlingTarget.Character:FindFirstChild("HumanoidRootPart")
                if myHrp and tHrp then myHrp.CFrame = CFrame.new(myHrp.Position, tHrp.Position) end
                RunService.Heartbeat:Wait()
            end
        end)
    end
end)

PageFling:CreateToggle("环绕目标", false, function(v)
    flingStates.orbit = v
    if v and selectedFlingTarget then
        local angle, speed, radius = 0, 8, 10
        task.spawn(function()
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not flingStates.orbit or not selectedFlingTarget or not selectedFlingTarget.Parent then
                    conn:Disconnect() return
                end
                local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local tHrp = selectedFlingTarget.Character and selectedFlingTarget.Character:FindFirstChild("HumanoidRootPart")
                if myHrp and tHrp then
                    angle = angle + speed
                    myHrp.CFrame = CFrame.new(tHrp.Position) * CFrame.Angles(0, math.rad(angle), 0) * CFrame.new(radius, 0, 0)
                end
            end)
        end)
    end
end)

local flingAura = false
PageFling:CreateToggle("抛飞光环", false, function(v)
    flingAura = v
    if v then
        task.spawn(function()
            while flingAura do
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            if (hrp.Position - p.Character.HumanoidRootPart.Position).Magnitude <= 15 then
                                pcall(function() miniFling(p) end)
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- ============================================================
-- 信息 Tab
-- ============================================================
local PageInfo = TabInfo:CreateModule("信息", "info", {})
PageInfo:CreateButton("xtal 脚本 V2", function()
    notify("xtal", "当前版本: V2 | 已自动解锁全部区域")
end)
PageInfo:CreateButton("按 R 键切换界面", function()
    notify("xtal", "按 R 显示/隐藏界面")
end)
PageInfo:CreateButton("按 V 键开关移速", function()
    notify("xtal", "按 V 开关移速加速")
end)

-- ============================================================
-- 初始化监听
-- ============================================================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    currentChar = newChar
    currentHum = newChar:WaitForChild("Humanoid")
    currentAnim = currentHum:FindFirstChildOfClass("Animator")
    if autoWallCombo then bindWallCombo(newChar) end
    if currentAnim then currentAnim.AnimationPlayed:Connect(whirlwindHandler) end
    currentHum.AnimationPlayed:Connect(whirlwindHandler)
end)

if currentAnim then currentAnim.AnimationPlayed:Connect(whirlwindHandler) end
currentHum.AnimationPlayed:Connect(whirlwindHandler)

local function onAnimPlayed(animTrack)
    if not autoVoidEnabled then return end
    local id = animTrack.Animation and animTrack.Animation.AnimationId
    if not id then return end
    for _, entry in ipairs(voidAnimList) do
        if id == "rbxassetid://" .. entry.id then
            local hrp = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local savedCF = hrp.CFrame
            task.wait(entry.timewait)
            if currentChar and currentChar.Parent and autoVoidEnabled and currentHum.Health > 0 then
                hrp.CFrame = CFrame.new(autoVoidPos)
                animTrack.Stopped:Wait()
                if autoVoidEnabled and tpBackEnabled then hrp.CFrame = savedCF end
            end
            break
        end
    end
end

if currentAnim then currentAnim.AnimationPlayed:Connect(onAnimPlayed) end
currentHum.AnimationPlayed:Connect(onAnimPlayed)

print("[xtal] ✅ 脚本加载完成 | 解锁统计:")
print(string.format("  GC 字段: %d | GC 函数: %d | 值: %d | 远程: %d",
    unlockStats.gcFields, unlockStats.gcFuncs, unlockStats.values, unlockStats.remotes))

Window:Notify({
    Title    = "xtal",
    Content  = "所有功能已就绪 | 按 R 切换界面",
    Duration = 5,
})
