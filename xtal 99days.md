repeat task.wait() until game:IsLoaded()

local Players           = game:GetService("Players")
local LocalPlayer       = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local Workspace         = workspace
local TweenService      = game:GetService("TweenService")
local Lighting          = game:GetService("Lighting")
local CoreGui           = game:GetService("CoreGui")

-- ============================================================
-- [0] 彩虹 Xtal 加载动画（约 5 秒）
-- ============================================================
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "xtalLoading"
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true
LoadingGui.DisplayOrder = 9999
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() LoadingGui.Parent = CoreGui end)
if not LoadingGui.Parent then
    LoadingGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

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
print("[xtal] 库版本:", Library.Version)

-- ============================================================
-- 窗口
-- ============================================================
local Window = Library:CreateWindow({
    Name              = "xtal",
    Title             = "xtal脚本",
    Version           = "V2",
    Theme             = "Nord",
    Backdrop          = true,
    ShowBackdrop      = true,
    GradientAnimation = true,
    ConfigFolder      = "xtal",
    SearchTab         = true,
    Visible           = true,
})

Window:Notify({
    Title    = "xtal脚本_V2",
    Content  = "尊贵的用户 " .. LocalPlayer.Name .. " 欢迎使用 xtal 脚本",
    Duration = 6,
})

-- ============================================================
-- 人物
-- ============================================================
local TabMovement  = Window:CreateTab("人物")
local PageMovement = TabMovement:CreateModule("人物", "running", {})

PageMovement:CreateButton("禁用反作弊", function()
    local currentRoom = LocalPlayer:GetAttribute("CurrentRoom")
    if currentRoom == 0 then
        if replicatesignal then
            replicatesignal(LocalPlayer.Kill)
            Window:Notify({ Title = "反作弊", Content = "反作弊已禁用，你可以飞行穿过一切", Duration = 10 })
        else
            Window:Notify({ Title = "错误", Content = "您的执行器不支持 replicatesignal 功能", Duration = 5 })
        end
    else
        Window:Notify({ Title = "提示", Content = "你需要在电梯中使用此功能", Duration = 5 })
    end
end)

PageMovement:CreateToggle("反作弊绕过", false, function(Value)
    local RemoteFolder = ReplicatedStorage:FindFirstChild("RemotesFolder")
    if not Value then
        if RemoteFolder and RemoteFolder:FindFirstChild("ClimbLadder") then
            RemoteFolder.ClimbLadder:FireServer()
        end
    else
        Window:Notify({ Title = "反作弊", Content = "请上梯子以激活绕过", Duration = 9 })
    end
end)

do
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    char:GetAttributeChangedSignal("Climbing"):Connect(function()
        if char:GetAttribute("Climbing") == true then
            task.spawn(function()
                task.wait(0.1)
                char:SetAttribute("Climbing", false)
                Window:Notify({ Title = "反作弊", Content = "已绕过反作弊，攀爬重置", Duration = 7 })
            end)
        end
    end)
end

PageMovement:CreateToggle("反作弊操纵", false, function(Value)
    local Camera    = workspace.CurrentCamera
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local savedCamCFrame, camLocked, acmButton, acmButtonActive = nil, false, nil, false

    local BUTTON_SIZE = UDim2.new(0, 70, 0, 35)
    local BUTTON_POSITION = UDim2.new(1, -80, 0.5, -17)
    local BUTTON_COLOR = Color3.fromRGB(45, 45, 45)
    local BUTTON_ACTIVE_COLOR = Color3.fromRGB(90, 90, 90)

    local function createACMButton()
        if not UserInputService.TouchEnabled or acmButton then return end
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "ACMGui"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = PlayerGui

        local button = Instance.new("TextButton")
        button.Name = "ACMButton"
        button.Size = BUTTON_SIZE
        button.Position = BUTTON_POSITION
        button.BackgroundColor3 = BUTTON_COLOR
        button.Text = "ACM"
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 16
        button.BorderSizePixel = 0
        button.Parent = screenGui

        button.MouseButton1Down:Connect(function()
            acmButtonActive = true
            button.BackgroundColor3 = BUTTON_ACTIVE_COLOR
        end)
        button.MouseButton1Up:Connect(function()
            acmButtonActive = false
            button.BackgroundColor3 = BUTTON_COLOR
        end)
        acmButton = screenGui
    end

    local function removeACMButton()
        if acmButton then acmButton:Destroy() acmButton = nil acmButtonActive = false end
    end

    if Value then
        createACMButton()
        RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            if not cam then return end
            local active = Value and acmButtonActive
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if active and hrp then
                if not camLocked then
                    savedCamCFrame = cam.CFrame
                    cam.CameraType = Enum.CameraType.Scriptable
                    camLocked = true
                    hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 10000)
                end
                cam.CFrame = savedCamCFrame
            elseif camLocked then
                cam.CameraType = Enum.CameraType.Custom
                camLocked = false
                savedCamCFrame = nil
            end
        end)
    else
        removeACMButton()
    end
end)

PageMovement:CreateKeybind("反作弊操纵按键", Enum.KeyCode.T, function() end)

-- 速度
local SpeedValue, SpeedEnabled, SpeedConnection = 21, false, nil
PageMovement:CreateToggle("开启速度", false, function(Value)
    SpeedEnabled = Value
    if Value then
        SpeedConnection = RunService.Heartbeat:Connect(function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.WalkSpeed = SpeedValue end
        end)
        Window:Notify({ Title = "移速", Content = "自定义移速已启用: " .. SpeedValue, Duration = 3 })
    else
        if SpeedConnection then SpeedConnection:Disconnect() SpeedConnection = nil end
        Window:Notify({ Title = "移速", Content = "自定义移速已禁用", Duration = 3 })
    end
end)

PageMovement:CreateSlider("速度数值", 0, 100, 21, function(Value)
    SpeedValue = Value
    if SpeedEnabled then
        Window:Notify({ Title = "移速", Content = "移速已更新: " .. Value, Duration = 2 })
    end
end)

PageMovement:CreateToggle("即时加速度", false, function(Value)
    local OldAccel = PhysicalProperties.new(0.01, 0.7, 0, 1, 1)
    local function updateAcceleration()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CustomPhysicalProperties = Value and PhysicalProperties.new(100, 0, 0, 0, 0) or OldAccel
        end
    end
    updateAcceleration()
    Window:Notify({ Title = "加速度", Content = Value and "即时加速度已启用" or "即时加速度已禁用", Duration = 3 })
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1.5)
        updateAcceleration()
    end)
end)

-- 飞行
local isFlying = false
local flyConnections = {}
local flyKeys = { W=false, A=false, S=false, D=false, Space=false, Shift=false }
local FlySpeed = 50

local function startFly()
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local bv = Instance.new("BodyVelocity")
    bv.Name = "FlyVelocity"
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    local bg = Instance.new("BodyGyro")
    bg.Name = "FlyGyro"
    bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bg.P = 20000
    bg.D = 1000
    bg.Parent = hrp

    humanoid.AutoRotate = false
    humanoid.PlatformStand = true
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)

    local ib = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.W then flyKeys.W = true
        elseif input.KeyCode == Enum.KeyCode.A then flyKeys.A = true
        elseif input.KeyCode == Enum.KeyCode.S then flyKeys.S = true
        elseif input.KeyCode == Enum.KeyCode.D then flyKeys.D = true
        elseif input.KeyCode == Enum.KeyCode.Space then flyKeys.Space = true
        elseif input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Shift = true
        end
    end)
    table.insert(flyConnections, ib)

    local ie = UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then flyKeys.W = false
        elseif input.KeyCode == Enum.KeyCode.A then flyKeys.A = false
        elseif input.KeyCode == Enum.KeyCode.S then flyKeys.S = false
        elseif input.KeyCode == Enum.KeyCode.D then flyKeys.D = false
        elseif input.KeyCode == Enum.KeyCode.Space then flyKeys.Space = false
        elseif input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Shift = false
        end
    end)
    table.insert(flyConnections, ie)

    local rc = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        if not cam or not hrp or not hrp:FindFirstChild("FlyVelocity") or not humanoid or humanoid.Health <= 0 then
            return
        end
        local move = Vector3.zero
        if flyKeys.W then move = move + cam.CFrame.LookVector end
        if flyKeys.S then move = move - cam.CFrame.LookVector end
        if flyKeys.A then move = move - cam.CFrame.RightVector end
        if flyKeys.D then move = move + cam.CFrame.RightVector end
        if flyKeys.Space then move = move + Vector3.new(0,1,0) end
        if flyKeys.Shift then move = move - Vector3.new(0,1,0) end
        bv.Velocity = (move.Magnitude > 0) and (move.Unit * FlySpeed) or Vector3.zero
        bg.CFrame = cam.CFrame
    end)
    table.insert(flyConnections, rc)
end

local function stopFly()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local fv = hrp:FindFirstChild("FlyVelocity") if fv then fv:Destroy() end
        local fg = hrp:FindFirstChild("FlyGyro") if fg then fg:Destroy() end
    end
    if humanoid then
        humanoid.AutoRotate = true
        humanoid.PlatformStand = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
    for _, c in ipairs(flyConnections) do c:Disconnect() end
    flyConnections = {}
    flyKeys = { W=false, A=false, S=false, D=false, Space=false, Shift=false }
end

PageMovement:CreateToggle("开启飞行", false, function(Value)
    isFlying = Value
    if Value then startFly() Window:Notify({ Title = "飞行", Content = "飞行模式已启用", Duration = 3 })
    else stopFly() Window:Notify({ Title = "飞行", Content = "飞行模式已禁用", Duration = 3 }) end
end)

PageMovement:CreateKeybind("飞行电脑切换键", Enum.KeyCode.F, function() end)

PageMovement:CreateSlider("飞行速度", 0, 150, 50, function(Value)
    FlySpeed = Value
    if isFlying then
        Window:Notify({ Title = "飞行", Content = "飞行速度已更新: " .. Value, Duration = 2 })
    end
end)

-- 穿墙
local noclipConnection = nil
local originalGroups = {}
PageMovement:CreateToggle("穿墙模式", false, function(Value)
    local function enableNoclip()
        if noclipConnection then return end
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        if not originalGroups[part] then originalGroups[part] = part.CollisionGroup end
                        part.CollisionGroup = "Default"
                    end
                end
            end
        end)
    end
    local function disableNoclip()
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        local char = LocalPlayer.Character
        if not char then return end
        local collision = char:FindFirstChild("Collision")
        local crouch = collision and collision:FindFirstChild("CollisionCrouch")
        if collision and crouch then
            local crouching = collision.CollisionGroup == "PlayerCrouching"
            collision.CanCollide = not crouching
            crouch.CanCollide = crouching
        end
    end
    if Value then enableNoclip() Window:Notify({ Title = "穿墙", Content = "穿墙模式已启用", Duration = 3 })
    else disableNoclip() Window:Notify({ Title = "穿墙", Content = "穿墙模式已禁用", Duration = 3 }) end
end)

PageMovement:CreateKeybind("穿墙电脑切换键", Enum.KeyCode.N, function() end)

-- 爬梯
local LadderSpeedValue, LadderSpeedEnabled, LadderConnection = 20, false, nil
PageMovement:CreateToggle("更快爬梯", false, function(on)
    if on then
        LadderConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum:GetState() == Enum.HumanoidStateType.Climbing then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, LadderSpeedValue, hrp.Velocity.Z)
            end
        end)
        Window:Notify({ Title = "爬梯", Content = "梯子加速已启用", Duration = 3 })
    elseif LadderConnection then
        LadderConnection:Disconnect()
        LadderConnection = nil
        Window:Notify({ Title = "爬梯", Content = "梯子加速已禁用", Duration = 3 })
    end
end)

PageMovement:CreateSlider("爬梯速度", 0, 100, 20, function(Value)
    LadderSpeedValue = Value
    if LadderSpeedEnabled then
        Window:Notify({ Title = "爬梯", Content = "爬梯速度已更新: " .. Value, Duration = 2 })
    end
end)

PageMovement:CreateToggle("始终可跳跃", false, function(Value)
    if LocalPlayer.Character then LocalPlayer.Character:SetAttribute("CanJump", Value) end
    Window:Notify({ Title = "跳跃", Content = Value and "始终跳跃已启用" or "始终跳跃已禁用", Duration = 3 })
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(1.5)
        newChar:SetAttribute("CanJump", Value)
    end)
end)

-- ============================================================
-- 自动类
-- ============================================================
local TabAuto  = Window:CreateTab("自动类")
local PageAuto = TabAuto:CreateModule("自动类", "puzzle", {})

PageAuto:CreateToggle("自动锚点代码求解", false, function(enabled)
    local running = false
    if enabled then
        if running then return end
        running = true
        task.spawn(function()
            local playerGui = LocalPlayer:WaitForChild("PlayerGui")
            local function findFrame()
                local mainUI = playerGui:FindFirstChild("MainUI")
                if mainUI and mainUI:FindFirstChild("MainFrame") then
                    local f = mainUI.MainFrame:FindFirstChild("AnchorHintFrame")
                    if f then return f end
                end
                local aui = playerGui:FindFirstChild("AnchorHintUI")
                if aui then
                    local f = aui:FindFirstChild("AnchorHintFrame")
                    if f then return f end
                end
                return nil
            end

            while running do
                task.wait(0.9)
                local frame = findFrame()
                if frame then
                    local anchorName = (frame:FindFirstChild("AnchorCode") and frame.AnchorCode.Text) or ''
                    local codeText = (frame:FindFirstChild("Code") and frame.Code.Text) or ''
                    if anchorName ~= '' and codeText ~= '' then
                        local anchorObject
                        for _, obj in ipairs(Workspace.CurrentRooms:GetDescendants()) do
                            if obj.Name == "MinesAnchor" then
                                local sign = obj:FindFirstChild("Sign")
                                if sign then
                                    local label = sign:FindFirstChild("TextLabel") or sign:FindFirstChildWhichIsA("TextLabel")
                                    if label and label.Text == anchorName then anchorObject = obj break end
                                end
                            end
                        end
                        if anchorObject then
                            local note = anchorObject:FindFirstChild("Note")
                            if not note then
                                Window:Notify({ Title = "锚点代码", Content = "锚点 "..anchorName.." 代码是 "..codeText, Duration = 3 })
                            else
                                local sg = note:FindFirstChildOfClass("SurfaceGui") or note:FindFirstChild("SurfaceGui")
                                local noteText = (sg and sg:FindFirstChild("TextLabel") and sg.TextLabel.Text) or '0'
                                local noteValue = tonumber(noteText) or 0
                                local solved = ''
                                for i = 1, #codeText do
                                    local digit = tonumber(codeText:sub(i, i)) or 0
                                    digit = (digit + noteValue) % 10
                                    solved = solved .. tostring(digit)
                                end
                                Window:Notify({ Title = "锚点代码", Content = "锚点 "..anchorName.." 代码是 "..solved, Duration = 5 })
                            end
                        end
                    end
                else
                    task.wait(0.25)
                end
            end
        end)
    else
        running = false
    end
end)

PageAuto:CreateToggle("自动断路器游戏", false, function(Value)
    local RemoteFolder = ReplicatedStorage:FindFirstChild("RemotesFolder")
        or ReplicatedStorage:FindFirstChild("EntityInfo")
        or ReplicatedStorage:FindFirstChild("Bricks")

    while Value and task.wait() do
        if not Value then break end
        local currentRoom = LocalPlayer:GetAttribute("CurrentRoom")
        if currentRoom ~= 100 then
            Window:Notify({ Title = "提示", Content = "你需要在100号房间使用此功能", Duration = 5 })
            break
        end

        local Breaker
        for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
            if v.Name == "ElevatorBreaker" then Breaker = v break end
        end

        if Breaker then
            local solved = true
            for _, v in ipairs(Breaker:GetChildren()) do
                if v.Name == "BreakerSwitch" then
                    local codeText = Breaker:WaitForChild("SurfaceGui").Frame.Code.Text
                    if v:GetAttribute("ID") == tonumber(codeText) then
                        if Breaker.SurfaceGui.Frame.Code.Frame.BackgroundTransparency == 0 then
                            v:SetAttribute("Enabled", true)
                            if not v.Sound.Playing then v.Sound.Playing = true end
                            v.Material = Enum.Material.Neon
                            v.Light.Attachment.Spark:Emit(1)
                            v.PrismaticConstraint.TargetPosition = -0.2
                        else
                            v:SetAttribute("Enabled", false)
                            if not v.Sound.Playing then v.Sound.Playing = true end
                            v.PrismaticConstraint.TargetPosition = 0.2
                            v.Material = Enum.Material.Glass
                            solved = false
                        end
                    end
                end
            end
            if solved and RemoteFolder then
                local r = RemoteFolder:FindFirstChild("BreakerMinigame")
                if r then r:FireServer("Solved") end
            end
        end
    end
end)

-- 自动隐藏[防怪物]
PageAuto:CreateToggle("自动隐藏[防怪物]", false, function(Value)
    local EntityDistances = {
        RushMoving = 50, BackdoorRush = 50, AmbushMoving = 100, A60 = 100, A120 = 35,
    }
    local Rooms = workspace.CurrentRooms
    local Connections = {}

    local function GetHiding()
        local Closest, Prompt
        local currRoom = Rooms and Rooms[LocalPlayer:GetAttribute("CurrentRoom")]
        if not currRoom then return nil end
        local char = LocalPlayer.Character
        if not char then return nil end
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Collision") or char.PrimaryPart
        if not hrp then return nil end

        local function distFromPlayer(model)
            if not model then return math.huge end
            local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
            if not part then return math.huge end
            return (part.Position - hrp.Position).Magnitude
        end

        local assets = currRoom:FindFirstChild("Assets")
        if assets then
            for _, v in pairs(assets:GetChildren()) do
                if v:IsA("Model") then
                    if ((v.Name == "Locker_Large") or (v.Name == "Wardrobe") or (v.Name == "Toolshed")
                        or (v.Name == "Bed") or (v.Name == "Rooms_Locker") or (v.Name == "Rooms_Locker_Fridge")
                        or (v.Name == "Backdoor_Wardrobe"))
                        and v:FindFirstChild("HidePrompt") and v:FindFirstChild("HiddenPlayer")
                    then
                        if not v.HiddenPlayer.Value and not v:FindFirstChild("HideEntityOnSpot", true) then
                            if Closest then
                                if distFromPlayer(v) < distFromPlayer(Closest) then Closest = v Prompt = v.HidePrompt end
                            else Closest = v Prompt = v.HidePrompt end
                        end
                    elseif v.Name == "Double_Bed" then
                        for _, x in pairs(v:GetChildren()) do
                            if x.Name == "DoubleBed" and x:FindFirstChild("HidePrompt") and x:FindFirstChild("HiddenPlayer") then
                                if not x.HiddenPlayer.Value and not x:FindFirstChild("HideEntityOnSpot", true) then
                                    if Closest then
                                        if distFromPlayer(x) < distFromPlayer(Closest) then Closest = x Prompt = x.HidePrompt end
                                    else Closest = x Prompt = x.HidePrompt end
                                end
                            end
                        end
                    elseif v.Name == "Dumpster" then
                        for _, x in pairs(v:GetChildren()) do
                            if x:FindFirstChild("HidePrompt") and x:FindFirstChild("HiddenPlayer") then
                                local dumpsterBaseHasSpot = v:FindFirstChild("DumpsterBase") and v.DumpsterBase:FindFirstChild("HideEntityOnSpot")
                                if not x.HiddenPlayer.Value and not dumpsterBaseHasSpot then
                                    if Closest then
                                        if distFromPlayer(x) < distFromPlayer(Closest) then Closest = x Prompt = x.HidePrompt end
                                    else Closest = x Prompt = x.HidePrompt end
                                end
                            end
                        end
                    end
                elseif v:IsA("Folder") then
                    if v.Name == "Blockage" then
                        for _, x in pairs(v:GetChildren()) do
                            if x:IsA("Model") and x.Name == "Wardrobe" and x:FindFirstChild("HiddenPlayer") and x:FindFirstChild("HidePrompt") then
                                if not x.HiddenPlayer.Value then
                                    if Closest then
                                        if distFromPlayer(x) < distFromPlayer(Closest) then Closest = x Prompt = x.HidePrompt end
                                    else Closest = x Prompt = x.HidePrompt end
                                end
                            end
                        end
                    elseif v.Name == "Vents" then
                        for _, x in pairs(v:GetChildren()) do
                            if x.Name == "CircularVent" and x:FindFirstChild("Grate") and x.Grate:FindFirstChild("HidePrompt") and x:FindFirstChild("HiddenPlayer") then
                                if not x.HiddenPlayer.Value and not v:FindFirstChild("HideEntityOnSpot", true) then
                                    if Closest then
                                        if distFromPlayer(x) < distFromPlayer(Closest) then Closest = x Prompt = x.Grate.HidePrompt end
                                    else Closest = x Prompt = x.Grate.HidePrompt end
                                end
                            end
                        end
                    end
                end
            end
        end

        for _, v in pairs(currRoom:GetChildren()) do
            if v:IsA("Model") and v.Name == "CircularVent" and v:FindFirstChild("Grate")
                and v.Grate:FindFirstChild("HidePrompt") and v:FindFirstChild("HiddenPlayer")
            then
                if not v.HiddenPlayer.Value and not v:FindFirstChild("HideEntityOnSpot", true) then
                    if Closest then
                        if distFromPlayer(v) < distFromPlayer(Closest) then Closest = v Prompt = v.Grate.HidePrompt end
                    else Closest = v Prompt = v.Grate.HidePrompt end
                end
            end
        end

        return Prompt
    end

    if Value then
        table.insert(Connections, workspace.ChildAdded:Connect(function(v)
            if v:IsA("Model") and EntityDistances[v.Name] then
                task.wait(1)
                local Part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart", true)
                if not Part then return end
                v:SetAttribute("_Prediction", Part.Position)

                while v.Parent and Value do
                    task.spawn(function()
                        local LastPosition = Part.Position
                        task.wait(0.3333333333333333)
                        if Part and Part.Parent then
                            v:SetAttribute("_Prediction", Part.Position - LastPosition)
                        end
                    end)

                    local IncludeList = {}
                    for _, Room in pairs(Rooms:GetChildren()) do
                        if Room:FindFirstChild("Assets") then table.insert(IncludeList, Room.Assets) end
                        if Room:FindFirstChild("Parts") then table.insert(IncludeList, Room.Parts) end
                    end

                    local rp = RaycastParams.new()
                    rp.FilterDescendantsInstances = IncludeList
                    rp.FilterType = Enum.RaycastFilterType.Include

                    local Count = {0.2, 0.4, 0.6, 0.8, 1}
                    local entityInRange = false

                    for i = 1, #Count do
                        local Number = 1.5 * Count[i]
                        local predAttr = v:GetAttribute("_Prediction")
                        local Prediction = (predAttr and (predAttr * 3)) or Vector3.zero
                        Prediction = Prediction * Number

                        local char = LocalPlayer.Character
                        if not char then break end
                        local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Collision") or char.PrimaryPart
                        if not hrp then break end

                        if Vector3.new(Prediction.X, 0, Prediction.Z).Magnitude > 1 then
                            local PredictionPosition = Part.Position + Prediction
                            local Raycast = workspace:Raycast(hrp.Position, PredictionPosition - hrp.Position, rp)
                            local adjustedDistance = EntityDistances[v.Name]
                            local distanceToEntity = (PredictionPosition - hrp.Position).Magnitude
                            if not Raycast and distanceToEntity <= adjustedDistance then
                                entityInRange = true
                                local Prompt = GetHiding()
                                if Prompt then pcall(function() fireproximityprompt(Prompt) end) end
                                break
                            end
                        end
                    end

                    local char = LocalPlayer.Character
                    if char and not entityInRange and char:GetAttribute("Hiding") then
                        char:SetAttribute("Hiding", false)
                    end
                    task.wait()
                end
            end
        end))
    else
        for _, c in ipairs(Connections) do c:Disconnect() end
        Connections = {}
    end
end)

PageAuto:CreateSelector("自动隐藏模式", {"Safety", "Close Call"}, "Safety", function(Value) end)
PageAuto:CreateSlider("预测时间", 0.1, 1.5, 1.5, function(Value) end)
PageAuto:CreateSlider("距离倍数", 1, 1.5, 1, function(Value) end)

-- 自动互动
local AutoInteractDistance = 10
PageAuto:CreateToggle("自动互动", false, function(Value)
    if Value then
        local AutoInteractConnection
        local CachedInteractables = {}
        local PromptSeen = {}
        local InteractableModels = {
            AlarmClock = true, GlitchCub = true, Aloe = true, BandagePack = true, Battery = true,
            TimerLever = true, OuterPart = true, BatteryPack = true, Candle = true, LiveBreakerPolePickup = true,
            Compass = true, Crucifix = true, ElectricalRoomKey = true, Flashlight = true, Glowstick = true,
            HolyHandGrenade = true, Lantern = true, LaserPointer = true, Lighter = true, Lockpick = true,
            LotusFlower = true, LotusPetalPickup = true, Multitool = true, NVCS3000 = true, OutdoorsKey = true,
            Shears = true, SkeletonKey = true, Smoothie = true, SolutionPaper = true, Spotlight = true,
            StarlightVial = true, StarlightJug = true, StarlightBottle = true, Vitamins = true,
        }

        local function PickRootPart(obj, prompt)
            if prompt and prompt.Parent and prompt.Parent:IsA("BasePart") then return prompt.Parent end
            if obj:IsA("Model") then
                if obj.PrimaryPart and obj.PrimaryPart:IsA("BasePart") then return obj.PrimaryPart end
                local common = obj:FindFirstChild("Main", true) or obj:FindFirstChild("Handle", true) or obj:FindFirstChild("Door", true)
                if common and common:IsA("BasePart") then return common end
            end
            return obj:FindFirstChildWhichIsA("BasePart", true)
        end

        local function AddPromptsFromObject(obj)
            for _, desc in ipairs(obj:GetDescendants()) do
                if desc:IsA("ProximityPrompt") and not PromptSeen[desc] then
                    local root = PickRootPart(obj, desc)
                    if root then
                        PromptSeen[desc] = true
                        table.insert(CachedInteractables, { prompt = desc, part = root, last = 0 })
                    end
                end
            end
        end

        local function CollectTargets(folder)
            for _, v in ipairs(folder:GetChildren()) do
                if v:IsA("Model") or v:IsA("Folder") then
                    if v.Name == "DrawerContainer" or InteractableModels[v.Name] or v.Name == "RoomsLootItem"
                        or v.Name == "Locker_Small" or v.Name == "Toolbox" or v.Name == "ChestBox"
                        or v.Name == "Toolshed_Small" or v.Name == "CrucifixOnTheWall"
                    then
                        AddPromptsFromObject(v)
                    end
                    CollectTargets(v)
                end
            end
        end

        local function RefreshTargets()
            CachedInteractables = {}
            PromptSeen = {}
            local CurrentRoom = workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]
            if not CurrentRoom then return end
            CollectTargets(CurrentRoom)
        end

        local lastCheck, interval = 0, 0.2

        local function AutoInteractStep(dt)
            lastCheck = lastCheck + dt
            if lastCheck < interval then return end
            lastCheck = 0

            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Collision") then return end
            local charPos = LocalPlayer.Character.Collision.Position
            local now = tick()

            for i = #CachedInteractables, 1, -1 do
                local entry = CachedInteractables[i]
                local prompt, part = entry.prompt, entry.part
                if not prompt or not prompt.Parent or not part or not part:IsDescendantOf(workspace) then
                    table.remove(CachedInteractables, i)
                else
                    local dist = (part.Position - charPos).Magnitude
                    if dist <= AutoInteractDistance and (now - (entry.last or 0)) >= 0.35 then
                        entry.last = now
                        task.spawn(function() pcall(function() fireproximityprompt(prompt) end) end)
                    end
                end
            end
        end

        RefreshTargets()
        AutoInteractConnection = RunService.Heartbeat:Connect(AutoInteractStep)

        local attributeConn, roomDescConn
        attributeConn = LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
            RefreshTargets()
            if roomDescConn then roomDescConn:Disconnect() roomDescConn = nil end
            local cr = workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]
            if cr then roomDescConn = cr.DescendantAdded:Connect(function() task.defer(RefreshTargets) end) end
        end)

        local cr = workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]
        if cr then roomDescConn = cr.DescendantAdded:Connect(function() task.defer(RefreshTargets) end) end

        _G.StopAutoInteract = function()
            if AutoInteractConnection then AutoInteractConnection:Disconnect() AutoInteractConnection = nil end
            if attributeConn then attributeConn:Disconnect() attributeConn = nil end
            if roomDescConn then roomDescConn:Disconnect() roomDescConn = nil end
            CachedInteractables, PromptSeen = {}, {}
        end
    elseif _G.StopAutoInteract then
        _G.StopAutoInteract()
        _G.StopAutoInteract = nil
    end
end)

PageAuto:CreateSlider("自动互动距离", 1, 20, 10, function(Value)
    AutoInteractDistance = Value
end)

-- 自动矿车
PageAuto:CreateToggle("自动矿车推动", false, function(Value)
    local Rooms = workspace:WaitForChild("CurrentRooms")
    if _G.AutoMinecartConn then _G.AutoMinecartConn:Disconnect() _G.AutoMinecartConn = nil end
    if _G.AutoMinecartLoop then _G.AutoMinecartLoop:Disconnect() _G.AutoMinecartLoop = nil end

    if Value then
        local function tryPush(cartModel)
            local cart = cartModel:FindFirstChild("Cart")
            if not cart then return end
            local prompt = cart:FindFirstChild("PushPrompt")
            if not prompt then return end
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            if (root.Position - prompt.Parent.Position).Magnitude <= (prompt.MaxActivationDistance or 10) then
                fireproximityprompt(prompt)
            end
        end

        _G.AutoMinecartConn = Rooms.DescendantAdded:Connect(function(obj)
            if obj.Name == "MinecartMoving" then task.defer(function() tryPush(obj) end) end
        end)

        _G.AutoMinecartLoop = RunService.Heartbeat:Connect(function()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            for _, obj in ipairs(Rooms:GetDescendants()) do
                if obj.Name == "MinecartMoving" then tryPush(obj) end
            end
        end)
    else
        if _G.AutoMinecartConn then _G.AutoMinecartConn:Disconnect() end
        if _G.AutoMinecartLoop then _G.AutoMinecartLoop:Disconnect() end
        _G.AutoMinecartConn, _G.AutoMinecartLoop = nil, nil
    end
end)

-- 自动拾取投掷物
PageAuto:CreateToggle("自动拾取投掷物", false, function(Value)
    local targetProps = {"WoodenCrate","OilBarrel","GarbageBag","Trashcan","CardboardBox_Normal","Hat_Stand","CardboardBox_Wide","Office_Chair"}
    local running = true
    if Value then
        task.spawn(function()
            while running and Value do
                local bigProps = workspace:FindFirstChild("BigProps")
                if bigProps then
                    for _, name in ipairs(targetProps) do
                        local prop = bigProps:FindFirstChild(name)
                        if prop then
                            for _, d in ipairs(prop:GetDescendants()) do
                                if d:IsA("ProximityPrompt") then
                                    d.MaxActivationDistance = 20
                                    if d.Enabled then pcall(fireproximityprompt, d) end
                                end
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    else
        running = false
    end
end)

-- 自动破门
PageAuto:CreateToggle("自动破门", false, function(Value)
    local connections, running = {}, false
    local targetNames = {"DoorPieceBottom", "DoorPieceTop"}

    local function safeDisconnect()
        for _, c in ipairs(connections) do
            if c and c.Disconnect then pcall(function() c:Disconnect() end) end
        end
        connections = {}
    end

    local function handlePrompt(p)
        pcall(function() p.MaxActivationDistance = 40 end)
        if p.Enabled then pcall(fireproximityprompt, p) end
    end

    local function processModel(m)
        for _, n in ipairs(targetNames) do
            local part = m:FindFirstChild(n, true)
            if part then
                for _, d in ipairs(part:GetDescendants()) do
                    if d:IsA("ProximityPrompt") then pcall(handlePrompt, d) end
                end
                local con = part.DescendantAdded:Connect(function(desc)
                    if desc:IsA("ProximityPrompt") then pcall(function() task.defer(handlePrompt, desc) end) end
                end)
                table.insert(connections, con)
            end
        end
    end

    local function scanAll()
        local cr = workspace:FindFirstChild("CurrentRooms")
        if not cr then return end
        for _, room in ipairs(cr:GetDescendants()) do
            if room:IsA("Model") or room:IsA("Folder") then processModel(room) end
        end
    end

    if Value then
        running = true
        safeDisconnect()
        task.spawn(function()
            scanAll()
            local cr = workspace:FindFirstChild("CurrentRooms")
            if cr then
                local con = cr.DescendantAdded:Connect(function(d)
                    if not running then return end
                    local model = d
                    while model and not (model:IsA("Model") or model:IsA("Folder")) do model = model.Parent end
                    if model then task.defer(processModel, model) end
                end)
                table.insert(connections, con)
            end
            while running and Value do scanAll() task.wait(0.8) end
        end)
    else
        running = false
        safeDisconnect()
    end
end)

-- 自动拾取
PageAuto:CreateToggle("自动拾取", false, function(Value)
    local connections, running = {}, false
    local function safeDisconnect()
        for _, c in ipairs(connections) do
            if c and c.Disconnect then pcall(function() c:Disconnect() end) end
        end
        connections = {}
    end
    local function handlePrompt(p)
        pcall(function() p.MaxActivationDistance = 40 end)
        if p.Enabled then pcall(fireproximityprompt, p) end
    end
    local function processDrop(d)
        for _, desc in ipairs(d:GetDescendants()) do
            if desc:IsA("ProximityPrompt") then pcall(handlePrompt, desc) end
        end
        local con = d.DescendantAdded:Connect(function(desc)
            if desc:IsA("ProximityPrompt") then pcall(function() task.defer(handlePrompt, desc) end) end
        end)
        table.insert(connections, con)
    end
    local function scanDrops()
        local drops = workspace:FindFirstChild("Drops")
        if not drops then return end
        for _, child in ipairs(drops:GetChildren()) do
            if child:IsA("Model") or child:IsA("Folder") then processDrop(child) end
        end
    end

    if Value then
        running = true
        safeDisconnect()
        task.spawn(function()
            scanDrops()
            local drops = workspace:FindFirstChild("Drops")
            if drops then
                local con = drops.ChildAdded:Connect(function(c)
                    if not running then return end
                    if c:IsA("Model") or c:IsA("Folder") then task.defer(processDrop, c) end
                end)
                table.insert(connections, con)
            end
            while running and Value do scanDrops() task.wait(0.8) end
        end)
    else
        running = false
        safeDisconnect()
    end
end)

-- 自动开火
PageAuto:CreateToggle("自动开火", false, function(Value)
    local Camera = workspace.CurrentCamera
    local RAY_DISTANCE = 50
    local con, triggered = nil, false

    local function isTargetVisible(targetPos)
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.FilterDescendantsInstances = {LocalPlayer.Character}
        local origin = Camera.CFrame.Position
        local result = workspace:Raycast(origin, targetPos - origin, rp)
        if not result then return true end
        return (result.Instance.Position - targetPos).Magnitude < 3
    end

    local function update()
        if not LocalPlayer.Character or not Camera then
            if triggered then pcall(mouse1release) triggered = false end
            return
        end
        local lookVector = Camera.CFrame.LookVector
        local origin = Camera.CFrame.Position
        local bestTarget, bestDot = nil, 0.995

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local targetPos = plr.Character.HumanoidRootPart.Position
                local dot = lookVector:Dot((targetPos - origin).Unit)
                if dot > bestDot then
                    local dist = (targetPos - origin).Magnitude
                    if dist < RAY_DISTANCE and isTargetVisible(targetPos) then
                        bestDot = dot bestTarget = plr
                    end
                end
            end
        end

        if bestTarget then
            if not triggered then
                Window:Notify({ Title = "自动开火", Content = "正在向 " .. bestTarget.Name .. " 开火", Duration = 2 })
                pcall(mouse1press)
                triggered = true
            end
        elseif triggered then
            pcall(mouse1release)
            triggered = false
        end
    end

    if Value then
        if con and con.Connected then con:Disconnect() end
        con = RunService.RenderStepped:Connect(function() pcall(update) end)
    else
        if con then con:Disconnect() con = nil end
        if triggered then pcall(mouse1release) triggered = false end
    end
end)

-- 自动房间
PageAuto:CreateToggle("自动房间", false, function(enabled)
    local PathfindingService = game:GetService("PathfindingService")
    local rooms = Workspace:WaitForChild("CurrentRooms")
    local gameData = ReplicatedStorage:WaitForChild("GameData")
    local floor = gameData:WaitForChild("Floor")
    local active = false
    local runner, clone

    local function stop()
        active = false
        if runner then runner:Disconnect() runner = nil end
        if clone and clone.Parent then clone:Destroy() end
        LocalPlayer:SetAttribute("AutoRoomsActive", false)
    end

    if not enabled then stop() return end
    LocalPlayer:SetAttribute("AutoRoomsActive", true)
    active = true

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("CollisionPart") then
        clone = LocalPlayer.Character.CollisionPart:Clone()
        clone.Name = "_AutoRoomsCollision"
        clone.Massless = true
        clone.Anchored = false
        clone.CanCollide = false
        clone.CanQuery = false
        clone.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0.7, 0, 1, 1)
        clone.Parent = LocalPlayer.Character
    end

    local function findClosestLocker()
        local best, bestDist = nil, math.huge
        for _, obj in ipairs(rooms:GetDescendants()) do
            if obj.Name == "Rooms_Locker" or obj.Name == "Rooms_Locker_Fridge" then
                if obj.PrimaryPart then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - obj.PrimaryPart.Position).Magnitude
                    if dist < bestDist then best = obj bestDist = dist end
                end
            end
        end
        return best
    end

    local function walkTo(target)
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local path = PathfindingService:CreatePath({
            AgentRadius = 2, AgentHeight = 1, AgentCanJump = false, WaypointSpacing = 5,
        })
        path:ComputeAsync(char.HumanoidRootPart.Position, target.Position)
        if path.Status == Enum.PathStatus.Success then
            for _, wp in ipairs(path:GetWaypoints()) do
                if not active then return end
                char:FindFirstChildOfClass("Humanoid"):MoveTo(wp.Position)
                char.Humanoid.MoveToFinished:Wait()
            end
        end
    end

    runner = RunService.Heartbeat:Connect(function()
        if not active then return end
        if floor.Value ~= "Rooms" then return stop() end
        if gameData.LatestRoom.Value >= 1000 then return stop() end

        local entity = Workspace:FindFirstChild("A60") or Workspace:FindFirstChild("A120")
            or Workspace:FindFirstChild("GlitchRush") or Workspace:FindFirstChild("GlitchAmbush")

        if entity and entity.PrimaryPart and entity.PrimaryPart.Position.Y > -6 then
            local locker = findClosestLocker()
            if locker and locker.PrimaryPart then
                local hide = locker:FindFirstChild("HidePoint")
                if not hide then
                    hide = Instance.new("Part")
                    hide.Name = "HidePoint"
                    hide.Anchored = true
                    hide.Transparency = 1
                    hide.CanCollide = false
                    hide.Position = locker.PrimaryPart.Position + (locker.PrimaryPart.CFrame.LookVector * 7)
                    hide.Parent = locker
                end
                walkTo(hide)
                task.wait(0.1)
                local prompt = locker:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    if fireproximityprompt then fireproximityprompt(prompt)
                    else prompt:InputHoldBegin() prompt:InputHoldEnd() end
                end
            end
        else
            local currentRoom = gameData.LatestRoom.Value
            local door = rooms[currentRoom] and rooms[currentRoom]:FindFirstChild("Door", true)
            if door and door:FindFirstChild("Door") then walkTo(door.Door) end
        end
    end)
end)

-- 反AFK
PageAuto:CreateToggle("反AFK", false, function(Value)
    local VirtualUser = game:GetService("VirtualUser")
    local AntiAFKConnection
    if Value then
        AntiAFKConnection = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        Window:Notify({ Title = "反AFK", Content = "反AFK已启用", Duration = 3 })
    elseif AntiAFKConnection then
        AntiAFKConnection:Disconnect()
        AntiAFKConnection = nil
        Window:Notify({ Title = "反AFK", Content = "反AFK已禁用", Duration = 3 })
    end
end)

-- 自动门范围
PageAuto:CreateToggle("自动门范围", false, function(Value)
    local doorReachLoop
    if Value then
        local Rooms = workspace:FindFirstChild("CurrentRooms")
        if not Rooms then return end
        doorReachLoop = task.spawn(function()
            while Value do
                for _, room in pairs(Rooms:GetChildren()) do
                    local door = room:FindFirstChild("Door")
                    if door and door:FindFirstChild("ClientOpen") then
                        door.ClientOpen:FireServer()
                    end
                end
                task.wait(0.5)
            end
        end)
        Window:Notify({ Title = "自动门", Content = "自动门范围已启用", Duration = 3 })
    else
        doorReachLoop = nil
        Window:Notify({ Title = "自动门", Content = "自动门范围已禁用", Duration = 3 })
    end
end)

-- 即时互动
PageAuto:CreateToggle("即时互动", false, function(Value)
    if getgenv().ProximityConnection then
        getgenv().ProximityConnection:Disconnect()
        getgenv().ProximityConnection = nil
    end

    local function modifyPrompt(prompt, instant)
        if not prompt:IsA("ProximityPrompt") then return end
        if instant then
            if not prompt:GetAttribute("OriginalHoldDuration") then
                prompt:SetAttribute("OriginalHoldDuration", prompt.HoldDuration)
                prompt:SetAttribute("OriginalLineOfSight", prompt.RequiresLineOfSight)
            end
            prompt.HoldDuration = 0
            prompt.RequiresLineOfSight = false
        else
            prompt.HoldDuration = prompt:GetAttribute("OriginalHoldDuration") or 1
            prompt.RequiresLineOfSight = prompt:GetAttribute("OriginalLineOfSight") or true
        end
    end

    local currentRooms = workspace:FindFirstChild("CurrentRooms")
    if currentRooms then
        for _, prompt in ipairs(currentRooms:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then modifyPrompt(prompt, Value) end
        end
    end

    if Value and currentRooms then
        getgenv().ProximityConnection = currentRooms.DescendantAdded:Connect(function(desc)
            if desc:IsA("ProximityPrompt") then modifyPrompt(desc, true) end
        end)
    end

    Window:Notify({ Title = "即时互动", Content = Value and "已启用" or "已禁用", Duration = 3 })
end)

PageAuto:CreateSlider("既时互动范围提升", 1, 5, 1, function(multiplier)
    local originalRanges = {}
    local rangeConnections = {}

    local function updateProximityPromptRanges(m)
        local function modifyPrompt(prompt)
            if not originalRanges[prompt] then originalRanges[prompt] = prompt.MaxActivationDistance end
            prompt.MaxActivationDistance = originalRanges[prompt] * m
        end
        for _, descendant in pairs(workspace:GetDescendants()) do
            if descendant:IsA("ProximityPrompt") then modifyPrompt(descendant) end
        end
        for _, player in pairs(Players:GetPlayers()) do
            if player.PlayerGui then
                for _, descendant in pairs(player.PlayerGui:GetDescendants()) do
                    if descendant:IsA("ProximityPrompt") then modifyPrompt(descendant) end
                end
            end
        end
    end

    local function setupRangeConnections(m)
        for _, conn in pairs(rangeConnections) do conn:Disconnect() end
        rangeConnections = {}
        table.insert(rangeConnections, workspace.DescendantAdded:Connect(function(d)
            if d:IsA("ProximityPrompt") then
                task.wait(0.1)
                originalRanges[d] = d.MaxActivationDistance
                d.MaxActivationDistance = originalRanges[d] * m
            end
        end))
        for _, player in pairs(Players:GetPlayers()) do
            if player.PlayerGui then
                table.insert(rangeConnections, player.PlayerGui.DescendantAdded:Connect(function(d)
                    if d:IsA("ProximityPrompt") then
                        task.wait(0.1)
                        originalRanges[d] = d.MaxActivationDistance
                        d.MaxActivationDistance = originalRanges[d] * m
                    end
                end))
            end
        end
    end

    if multiplier == 1 then
        for prompt, originalRange in pairs(originalRanges) do
            if prompt and prompt.Parent then prompt.MaxActivationDistance = originalRange end
        end
        for _, conn in pairs(rangeConnections) do conn:Disconnect() end
        rangeConnections = {}
    else
        updateProximityPromptRanges(multiplier)
        setupRangeConnections(multiplier)
    end
    Window:Notify({ Title = "互动范围", Content = "已设置为 " .. multiplier .. "x", Duration = 3 })
end)

-- ============================================================
-- 规避类
-- ============================================================
local TabEvade  = Window:CreateTab("规避类")
local PageEvade = TabEvade:CreateModule("规避类", "shield", {})

PageEvade:CreateToggle("规避Screech", false, function(on)
    if on then
        for _, inst in ipairs(workspace:GetDescendants()) do
            if inst.Name == "Screech" then pcall(function() inst:Destroy() end) end
        end
        getgenv().AntiScreechConn = workspace.DescendantAdded:Connect(function(inst)
            if inst.Name == "Screech" then
                task.defer(function()
                    if inst and inst.Parent then pcall(function() inst:Destroy() end) end
                end)
            end
        end)
    elseif getgenv().AntiScreechConn then
        getgenv().AntiScreechConn:Disconnect()
        getgenv().AntiScreechConn = nil
    end
end)

PageEvade:CreateToggle("规避Gloom蛋", false, function(Value)
    if getgenv().AntiGloomConn then getgenv().AntiGloomConn:Disconnect() getgenv().AntiGloomConn = nil end
    local rooms = workspace:WaitForChild("CurrentRooms")
    if Value then
        for _, v in ipairs(rooms:GetDescendants()) do
            if v.Name == "GloomEgg" then
                local egg = v:FindFirstChild("Egg")
                if egg then egg.CanTouch = false end
            end
        end
        getgenv().AntiGloomConn = rooms.DescendantAdded:Connect(function(v)
            if v.Name == "GloomEgg" then
                local egg = v:WaitForChild("Egg", 9e9)
                if egg then egg.CanTouch = false end
            elseif v.Name == "Egg" and v.Parent and v.Parent.Name == "GloomEgg" then
                v.CanTouch = false
            end
        end)
    else
        for _, v in ipairs(rooms:GetDescendants()) do
            if v.Name == "GloomEgg" then
                local egg = v:FindFirstChild("Egg")
                if egg then egg.CanTouch = true end
            end
        end
    end
end)

PageEvade:CreateToggle("规避Dread", false, function(isEnabled)
    local modules = LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules
    local dreadModule = modules:FindFirstChild("Dread") or modules:FindFirstChild("_Dread")
    if dreadModule then
        dreadModule.Name = isEnabled and "_Dread" or "Dread"
    end
end)

PageEvade:CreateToggle("规避Giggle", false, function(Value)
    if getgenv().AntiGiggleConn then getgenv().AntiGiggleConn:Disconnect() getgenv().AntiGiggleConn = nil end
    local rooms = workspace:WaitForChild("CurrentRooms")
    if Value then
        for _, v in ipairs(rooms:GetDescendants()) do
            if v.Name == "GiggleCeiling" then
                local hitbox = v:FindFirstChild("Hitbox")
                if hitbox then hitbox.CanTouch = false end
            end
        end
        getgenv().AntiGiggleConn = rooms.DescendantAdded:Connect(function(v)
            if v.Name == "GiggleCeiling" then
                local hitbox = v:WaitForChild("Hitbox", 9e9)
                if hitbox then hitbox.CanTouch = false end
            elseif v.Name == "Hitbox" and v.Parent and v.Parent.Name == "GiggleCeiling" then
                v.CanTouch = false
            end
        end)
    else
        for _, v in ipairs(rooms:GetDescendants()) do
            if v.Name == "GiggleCeiling" then
                local hitbox = v:FindFirstChild("Hitbox")
                if hitbox then hitbox.CanTouch = true end
            end
        end
    end
end)

PageEvade:CreateToggle("规避Figure听觉", false, function(Value)
    local crouchConnection
    if crouchConnection then crouchConnection:Disconnect() crouchConnection = nil end
    if Value then
        crouchConnection = RunService.Heartbeat:Connect(function()
            ReplicatedStorage.RemotesFolder.Crouch:FireServer(true)
        end)
    else
        ReplicatedStorage.RemotesFolder.Crouch:FireServer(false)
    end
end)

PageEvade:CreateToggle("规避Surge", false, function(Value)
    if Value then
        local surgeClient = ReplicatedStorage:WaitForChild("FloorReplicated"):WaitForChild("ClientRemote"):FindFirstChild("SurgeClient")
        if surgeClient then surgeClient:Destroy() end
    end
end)

PageEvade:CreateToggle("规避Halt", false, function(Value)
    local entityModules = ReplicatedStorage:WaitForChild("ModulesClient"):WaitForChild("EntityModules")
    if Value then
        local shade = entityModules:FindFirstChild("Shade")
        if shade and shade:IsA("ModuleScript") then shade.Name = "_Shade" end
    else
        local shade = entityModules:FindFirstChild("_Shade")
        if shade and shade:IsA("ModuleScript") then shade.Name = "Shade" end
    end
end)

PageEvade:CreateToggle("规避Lookman", false, function(Value)
    if Value then
        if workspace:FindFirstChild("BackdoorLookman") then
            ReplicatedStorage.RemotesFolder.MotorReplication:FireServer(-890)
        end
    end
end)

PageEvade:CreateToggle("规避Snare", false, function(Value)
    local currentRooms = workspace:WaitForChild("CurrentRooms")
    local function handleSnare(snare)
        if snare.Name == "Snare" then
            local hitbox = snare:FindFirstChild("Hitbox")
            if hitbox then hitbox.CanTouch = not Value
            else
                snare.ChildAdded:Connect(function(child)
                    if child.Name == "Hitbox" then child.CanTouch = not Value end
                end)
            end
        end
    end
    for _, v in ipairs(currentRooms:GetDescendants()) do handleSnare(v) end
    currentRooms.DescendantAdded:Connect(handleSnare)
end)

PageEvade:CreateToggle("规避Seek障碍物", false, function(Value)
    local Rooms = workspace.CurrentRooms
    if Value then
        getgenv().AntiSeekObstaclesConn = Rooms.DescendantAdded:Connect(function(desc)
            if desc.Name == "Seek_Arm" then
                desc:WaitForChild("AnimatorPart", 9e9)
                desc.AnimatorPart.CanTouch = false
                desc.AnimatorPart.Transparency = 1
                for _, p in desc:GetDescendants() do if p:IsA("BasePart") then p.Transparency = 1 end end
            elseif desc.Name == "ChandelierObstruction" then
                desc:WaitForChild("HurtPart", 9e9)
                desc.HurtPart.CanTouch = false
                desc.HurtPart.Transparency = 1
                for _, p in desc:GetDescendants() do if p:IsA("BasePart") then p.Transparency = 1 end end
            end
        end)
        for _, v in Rooms:GetDescendants() do
            if v.Name == "Seek_Arm" and v:IsA("Model") then
                v:WaitForChild("AnimatorPart", 9e9)
                v.AnimatorPart.CanTouch = false
                v.AnimatorPart.Transparency = 1
            elseif v.Name == "ChandelierObstruction" and v:IsA("Model") then
                v:WaitForChild("HurtPart", 9e9)
                v.HurtPart.CanTouch = false
                v.HurtPart.Transparency = 1
            end
        end
    else
        if getgenv().AntiSeekObstaclesConn then getgenv().AntiSeekObstaclesConn:Disconnect() end
        for _, v in Rooms:GetDescendants() do
            if v.Name == "Seek_Arm" and v:IsA("Model") then
                v:WaitForChild("AnimatorPart", 9e9)
                v.AnimatorPart.CanTouch = true
                v.AnimatorPart.Transparency = 0
            elseif v.Name == "ChandelierObstruction" and v:IsA("Model") then
                v:WaitForChild("HurtPart", 9e9)
                v.HurtPart.CanTouch = true
                v.HurtPart.Transparency = 0
            end
        end
    end
end)

PageEvade:CreateToggle("规避Dupe门", false, function(Value)
    for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
        if v.Name == "DoorFake" then
            v:WaitForChild("Hidden").CanTouch = not Value
            local lock = v:FindFirstChild("Lock")
            if lock then
                local prompt = lock:FindFirstChildOfClass("ProximityPrompt")
                if prompt then prompt.ClickablePrompt = not Value end
            end
        end
    end
end)

PageEvade:CreateToggle("规避真空区域", false, function(Value)
    for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
        if v.Name == "SideroomSpace" then
            for _, part in ipairs(v:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanTouch = not Value
                    part.CanCollide = Value
                end
            end
        end
    end
end)

PageEvade:CreateToggle("规避Eyes", false, function(Value)
    local Connections = {}
    if Value then
        Connections.AntiEyes = RunService.RenderStepped:Connect(function()
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
            if not LocalPlayer.Character:GetAttribute("Hiding") then
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name == "Eyes" and v:FindFirstChild("Core") and v.Core:FindFirstChild("Ambience") and v.Core.Ambience.Playing then
                        ReplicatedStorage.RemotesFolder.MotorReplication:FireServer(-650)
                        break
                    end
                end
            end
        end)
    elseif Connections.AntiEyes then
        Connections.AntiEyes:Disconnect()
        Connections.AntiEyes = nil
    end
end)

PageEvade:CreateToggle("规避A-90", false, function(ad)
    local modules = LocalPlayer.PlayerGui:FindFirstChild("MainUI")
        and LocalPlayer.PlayerGui.MainUI:FindFirstChild("Initiator")
        and LocalPlayer.PlayerGui.MainUI.Initiator:FindFirstChild("Main_Game")
        and LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game:FindFirstChild("RemoteListener")
        and LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules")
    local c3 = modules and (modules:FindFirstChild("A90") or modules:FindFirstChild("_A90"))
    if c3 then c3.Name = ad and "_A90" or "A90" end
    local rf = ReplicatedStorage:FindFirstChild("RemotesFolder")
    local remote = rf and (rf:FindFirstChild("A90") or rf:FindFirstChild("_A90"))
    if remote then remote.Name = ad and "_A90" or "A90" end
end)

PageEvade:CreateToggle("规避虚空效果", false, function(Value)
    local entityModules = ReplicatedStorage:FindFirstChild("ModulesClient") and ReplicatedStorage.ModulesClient:FindFirstChild("EntityModules")
    if not entityModules then return end
    local vm = entityModules:FindFirstChild("Void") or entityModules:FindFirstChild("_Void")
    if not vm then return end
    if Value then
        if vm.Name == "Void" then vm.Name = "_Void" end
    elseif vm.Name == "_Void" then
        vm.Name = "Void"
    end
end)

PageEvade:CreateToggle("规避Haste效果", false, function(Value)
    if ReplicatedStorage.FloorReplicated.ClientRemote:FindFirstChild("Haste") then
        ReplicatedStorage.FloorReplicated.ClientRemote.Haste.Ambience:GetPropertyChangedSignal("Playing"):Connect(function()
            if Value then ReplicatedStorage.FloorReplicated.ClientRemote.Haste.Ambience.Playing = false end
        end)
    end
    for _, v in workspace.CurrentCamera:GetChildren() do
        if v.Name == "LiveSanity" and workspace:FindFirstChild("EntityModel") then
            v.Enabled = not Value
        end
    end
end)

PageEvade:CreateToggle("规避Firedamp", false, function(Value)
    local camera = workspace:WaitForChild("Camera")
    local targets = { LiveSantity = true, LiveFiredamp = true }
    local function checkAndDelete(obj) if targets[obj.Name] then obj:Destroy() end end
    if getgenv().AntiFiredampConnection then getgenv().AntiFiredampConnection:Disconnect() getgenv().AntiFiredampConnection = nil end
    if Value then
        for _, child in ipairs(camera:GetChildren()) do checkAndDelete(child) end
        getgenv().AntiFiredampConnection = camera.ChildAdded:Connect(checkAndDelete)
    end
end)

PageEvade:CreateToggle("规避矿井氛围", false, function(Value)
    local Lighting = game:GetService("Lighting")
    if Value then
        local ca = Lighting:FindFirstChild("CaveAtmosphere") if ca then ca:Destroy() end
        local cv = Lighting:FindFirstChild("Caves") if cv then cv:Destroy() end
    end
end)

PageEvade:CreateToggle("规避氧气/理智效果", false, function(Value)
    local Lighting = game:GetService("Lighting")
    if Value then
        local s = Lighting:FindFirstChild("Sanity") if s then s:Destroy() end
        local o = Lighting:FindFirstChild("OxygenCC") if o then o:Destroy() end
        local b = Lighting:FindFirstChild("OxygenBlur") if b then b:Destroy() end
    end
end)

PageEvade:CreateToggle("无雾效果", false, function(Value)
    local lighting = game:GetService("Lighting")
    local cave = lighting:FindFirstChild("CaveAtmosphere")
    if Value then
        if cave and cave:IsA("Atmosphere") then cave.Density = 0
        else lighting.FogStart = 1000000 lighting.FogEnd = 1000000 end
    elseif cave and cave:IsA("Atmosphere") then
        cave.Density = 0.15
    else
        lighting.FogStart = 150 lighting.FogEnd = 150
    end
end)

PageEvade:CreateToggle("无相机抖动", false, function(Value)
    local RequiredMainGame = require(LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainUI"):WaitForChild("Initiator"):WaitForChild("Main_Game"))
    task.spawn(function()
        while Value and RequiredMainGame do
            task.wait()
            if typeof(RequiredMainGame.csgo) == "CFrame" then RequiredMainGame.csgo = CFrame.new() end
        end
    end)
end)

PageEvade:CreateToggle("无头部晃动", false, function(Value)
    local RequiredMainGame = require(LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainUI"):WaitForChild("Initiator"):WaitForChild("Main_Game"))
    if Value then
        if not getgenv().HeadBobDisabler then
            getgenv().HeadBobDisabler = RunService.RenderStepped:Connect(function()
                if RequiredMainGame and RequiredMainGame.spring then
                    if typeof(RequiredMainGame.spring.Target) == "Vector3" then
                        RequiredMainGame.spring.Target = Vector3.zero
                        RequiredMainGame.spring.Position = Vector3.zero
                    end
                end
            end)
        end
    elseif getgenv().HeadBobDisabler then
        getgenv().HeadBobDisabler:Disconnect()
        getgenv().HeadBobDisabler = nil
    end
end)

PageEvade:CreateToggle("无过场动画", false, function(Value)
    local RemoteListener = LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game:WaitForChild("RemoteListener")
    local CutScenes = RemoteListener:FindFirstChild("Cutscenes") or RemoteListener:FindFirstChild("_Cutscenes")
    if not CutScenes then
        CutScenes = RemoteListener:WaitForChild("Cutscenes", 3) or RemoteListener:WaitForChild("_Cutscenes", 3)
    end
    if CutScenes then CutScenes.Name = Value and "_Cutscenes" or "Cutscenes" end
end)

PageEvade:CreateToggle("规避隐藏边缘", false, function(Value)
    LocalPlayer.PlayerGui.MainUI.MainFrame.HideVignette.Image = Value and "rbxassetid://0" or "rbxassetid://6100076320"
end)

PageEvade:CreateToggle("防卡顿", false, function(Value)
    local Modifiers = workspace:FindFirstChild("Modifiers")
    if Modifiers and not Modifiers:FindFirstChild("Jammin") then return end
    local mainTrack = game:GetService("SoundService"):FindFirstChild("Main")
    if mainTrack then
        local jamming = mainTrack:FindFirstChild("Jamming")
        if jamming then jamming.Enabled = not Value end
    end
    local mainUI = LocalPlayer.PlayerGui:FindFirstChild("MainUI")
    if mainUI then
        local healthGui = mainUI:FindFirstChild("Initiator") and mainUI.Initiator:FindFirstChild("Main_Game") and mainUI.Initiator.Main_Game:FindFirstChild("Health")
        if healthGui then
            local jamSound = healthGui:FindFirstChild("Jam")
            if jamSound then jamSound.Playing = not Value end
        end
    end
end)

PageEvade:CreateToggle("防香蕉皮", false, function(Value)
    local currentRooms = workspace:WaitForChild("CurrentRooms")
    if getgenv().antiBananaConn then getgenv().antiBananaConn:Disconnect() getgenv().antiBananaConn = nil end
    for _, v in pairs(currentRooms:GetDescendants()) do
        if v.Name == "BananaPeel" and v:IsA("BasePart") then v.CanTouch = not Value end
    end
    if Value then
        getgenv().antiBananaConn = currentRooms.DescendantAdded:Connect(function(v)
            if v.Name == "BananaPeel" and v:IsA("BasePart") then v.CanTouch = false end
        end)
    end
end)

PageEvade:CreateToggle("防Jeff杀手", false, function(Value)
    local currentRooms = workspace:WaitForChild("CurrentRooms")
    if getgenv().antiJeffConn then getgenv().antiJeffConn:Disconnect() getgenv().antiJeffConn = nil end
    for _, model in pairs(currentRooms:GetDescendants()) do
        if model.Name == "JeffTheKiller" and model:IsA("Model") then
            for _, part in ipairs(model:GetChildren()) do
                if part:IsA("BasePart") then part.CanTouch = not Value end
            end
        end
    end
    if Value then
        getgenv().antiJeffConn = currentRooms.DescendantAdded:Connect(function(v)
            if v.Name == "JeffTheKiller" and v:IsA("Model") then
                for _, part in ipairs(v:GetChildren()) do
                    if part:IsA("BasePart") then part.CanTouch = false end
                end
            end
        end)
    end
end)

-- ============================================================
-- 透视功能
-- ============================================================
local TabESP = Window:CreateTab("透视功能")
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/MSESP/refs/heads/main/source.luau"))()
ESPLibrary.GlobalConfig.Distance = false

local ColorConfig = {
    ["红色"] = Color3.fromRGB(255, 0, 0),
    ["绿色"] = Color3.fromRGB(0, 255, 0),
    ["蓝色"] = Color3.fromRGB(0, 0, 255),
    ["黄色"] = Color3.fromRGB(255, 255, 0),
    ["紫色"] = Color3.fromRGB(255, 0, 255),
    ["青色"] = Color3.fromRGB(0, 255, 255),
    ["粉色"] = Color3.fromRGB(255, 182, 193),
    ["橙色"] = Color3.fromRGB(255, 165, 0),
    ["白色"] = Color3.fromRGB(255, 255, 255),
    ["彩虹动态"] = Color3.fromRGB(255, 0, 0),
}

local ColorList = {"红色","绿色","蓝色","黄色","紫色","青色","粉色","橙色","白色","彩虹动态"}

local ESPGroup = TabESP:CreateModule("ESP设置", "eye", {})

ESPGroup:CreateToggle("启用追踪线", false, function(Value)
    _G.EnableTracers = Value
    UpdateAllESP()
end)

ESPGroup:CreateToggle("启用方向箭头", false, function(Value)
    _G.EnableArrows = Value
    UpdateAllESP()
end)

ESPGroup:CreateSelector("ESP类型", {"高亮", "文字", "选择框"}, "高亮", function(Value)
    local espTypes = { ["高亮"] = "Highlight", ["文字"] = "Text", ["选择框"] = "SelectionBox" }
    _G.ESPType = espTypes[Value]
    UpdateAllESP()
end)

local ObjectESPGroup = TabESP:CreateModule("物体透视", "package", {})

local ObjectESPConfig = {
    { Name = "DoorESP", Title = "门透视", DefaultColor = "白色", Models = {"Door"}, DisplayName = "门" },
    { Name = "ObjectiveESP", Title = "目标物品透视", DefaultColor = "黄色", Models = {"KeyObtain","FuseObtain","LiveBreakerPolePickup"}, DisplayName = "目标物品" },
    { Name = "CoinESP", Title = "金币透视", DefaultColor = "白色", Models = {"GoldPile"}, DisplayName = "金币" },
    { Name = "MinesGeneratorESP", Title = "矿洞发电机透视", DefaultColor = "青色", Models = {"MinesGenerator"}, DisplayName = "发电机" },
    { Name = "LeverESP", Title = "杠杆透视", DefaultColor = "橙色", Models = {"LeverForGate"}, DisplayName = "杠杆" },
    { Name = "ItemESP", Title = "所有物品透视", DefaultColor = "黄色",
      Models = {"AlarmClock","Aloe","BandagePack","Battery","BatteryPack","Candle","Compass","Crucifix","Flashlight","Glowstick","HolyHandGrenade","Lantern","LaserPointer","Lighter","Lockpick","LotusFlower","Multitool","NVCS3000","Shears","SkeletonKey","Smoothie","Vitamins"},
      DisplayName = "物品" },
    { Name = "ClosetESP", Title = "柜子透视", DefaultColor = "粉色", Models = {"Wardrobe","Toolshed","Locker_Large","Backdoor_Wardrobe"}, DisplayName = "柜子" },
    { Name = "AnchorESP", Title = "锚点透视", DefaultColor = "粉色", Models = {"MinesAnchor"}, DisplayName = "锚点" },
    { Name = "LibraryBookESP", Title = "图书馆书籍透视", DefaultColor = "青色", Models = {"LiveHintBook"}, DisplayName = "书籍" },
    { Name = "ChestESP", Title = "宝箱透视", DefaultColor = "绿色", Models = {"ChestBox","ChestBoxLocked"}, DisplayName = "宝箱" },
}

local EntityESPConfig = {
    { Name = "SeekESP", Title = "追逐者透视", DefaultColor = "红色", Models = {"SeekMoving"}, DisplayName = "追逐者" },
    { Name = "FigureESP", Title = "雕像透视", DefaultColor = "白色", Models = {"FigureRig"}, DisplayName = "雕像" },
    { Name = "AmbushESP", Title = "伏击透视", DefaultColor = "白色", Models = {"AmbushMoving"}, DisplayName = "伏击" },
    { Name = "RushESP", Title = "冲刺透视", DefaultColor = "白色", Models = {"RushMoving"}, DisplayName = "冲刺" },
    { Name = "SnareESP", Title = "陷阱透视", DefaultColor = "白色", Models = {"Snare"}, DisplayName = "陷阱" },
    { Name = "GiggleESP", Title = "傻笑透视", DefaultColor = "白色", Models = {"GiggleCeiling"}, DisplayName = "傻笑" },
    { Name = "EyestalkESP", Title = "眼柄透视", DefaultColor = "白色", Models = {"EyestalkMoving"}, DisplayName = "眼柄" },
    { Name = "MandrakeESP", Title = "曼德拉草透视", DefaultColor = "白色", Models = {"Mandrake"}, DisplayName = "曼德拉草" },
    { Name = "GroundskeeperESP", Title = "园丁透视", DefaultColor = "白色", Models = {"Groundskeeper"}, DisplayName = "园丁" },
    { Name = "BlitzESP", Title = "闪电透视", DefaultColor = "白色", Models = {"BackdoorRush"}, DisplayName = "闪电" },
}

for _, config in ipairs(ObjectESPConfig) do
    ObjectESPGroup:CreateToggle(config.Title, false, function(Value)
        CreateESP(config.Name, Value, config.Models, config.DisplayName, _G[config.Name .. "_Color"])
    end)
    ObjectESPGroup:CreateSelector(config.Title .. "颜色", ColorList, config.DefaultColor, function(Value)
        _G[config.Name .. "_Color"] = ColorConfig[Value]
        if _G[config.Name .. "_Enabled"] then
            CreateESP(config.Name, true, config.Models, config.DisplayName, _G[config.Name .. "_Color"])
        end
    end)
end

local EntityESPGroup = TabESP:CreateModule("实体透视", "user", {})

for _, config in ipairs(EntityESPConfig) do
    EntityESPGroup:CreateToggle(config.Title, false, function(Value)
        CreateESP(config.Name, Value, config.Models, config.DisplayName, _G[config.Name .. "_Color"])
    end)
    EntityESPGroup:CreateSelector(config.Title .. "颜色", ColorList, config.DefaultColor, function(Value)
        _G[config.Name .. "_Color"] = ColorConfig[Value]
        if _G[config.Name .. "_Enabled"] then
            CreateESP(config.Name, true, config.Models, config.DisplayName, _G[config.Name .. "_Color"])
        end
    end)
end

local ESPData = {}
local RainbowConnection

function CreateESP(espName, enabled, targetModels, displayName, color)
    if not enabled then
        if ESPData[espName] then
            for _, element in pairs(ESPData[espName].Elements) do
                if element and element.Destroy then element:Destroy() end
            end
            if ESPData[espName].Connections then
                for _, conn in pairs(ESPData[espName].Connections) do
                    if conn then conn:Disconnect() end
                end
            end
            ESPData[espName] = nil
        end
        _G[espName .. "_Enabled"] = false
        return
    end

    _G[espName .. "_Enabled"] = true

    if not ESPData[espName] then
        ESPData[espName] = { Elements = {}, Connections = {}, Models = targetModels, DisplayName = displayName, Color = color or Color3.fromRGB(255,255,255) }
    else
        for _, element in pairs(ESPData[espName].Elements) do
            if element and element.Destroy then element:Destroy() end
        end
        ESPData[espName].Elements = {}
    end
    ESPData[espName].Color = color or ESPData[espName].Color

    local function AddESPToObject(obj)
        if not obj:IsA("Model") then return end
        local isValid = false
        for _, modelName in ipairs(targetModels) do
            if obj.Name == modelName then isValid = true break end
        end
        if not isValid then return end

        local targetPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
        if not targetPart then return end

        for _, existing in pairs(ESPData[espName].Elements) do
            if existing.Object == obj then return end
        end

        local espSettings = {
            Name = displayName,
            Model = targetPart,
            Color = ESPData[espName].Color,
            MaxDistance = 1000,
            TextSize = 14,
            ESPType = _G.ESPType or "Highlight",
            FillColor = ESPData[espName].Color,
            OutlineColor = ESPData[espName].Color,
            FillTransparency = 0.7,
            OutlineTransparency = 0,
            Tracer = { Enabled = _G.EnableTracers or false, Color = ESPData[espName].Color, From = "Bottom" },
            Arrow = { Enabled = _G.EnableArrows or false, Color = ESPData[espName].Color },
        }

        local espElement = ESPLibrary:Add(espSettings)
        table.insert(ESPData[espName].Elements, { Object = obj, Element = espElement, Part = targetPart })
    end

    for _, obj in ipairs(workspace:GetDescendants()) do AddESPToObject(obj) end

    local addedConn = workspace.DescendantAdded:Connect(function(obj)
        if _G[espName .. "_Enabled"] then AddESPToObject(obj) end
    end)
    local removingConn = workspace.DescendantRemoving:Connect(function(obj)
        if not _G[espName .. "_Enabled"] then return end
        for i, elementData in ipairs(ESPData[espName].Elements) do
            if elementData.Object == obj then
                if elementData.Element and elementData.Element.Destroy then elementData.Element:Destroy() end
                table.remove(ESPData[espName].Elements, i)
                break
            end
        end
    end)

    local updateConn = RunService.Heartbeat:Connect(function()
        if not _G[espName .. "_Enabled"] then updateConn:Disconnect() return end
        local player = LocalPlayer
        local character = player and player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        local currentColor = ESPData[espName].Color
        if ESPData[espName].Color == ColorConfig["彩虹动态"] then
            local time = tick()
            currentColor = Color3.new(
                math.sin(time * 2) * 0.5 + 0.5,
                math.sin(time * 2 + 2) * 0.5 + 0.5,
                math.sin(time * 2 + 4) * 0.5 + 0.5
            )
        end

        for i, elementData in ipairs(ESPData[espName].Elements) do
            if elementData.Object and elementData.Object.Parent and elementData.Part and elementData.Part.Parent then
                if elementData.Element then
                    local distance = (rootPart.Position - elementData.Part.Position).Magnitude
                    elementData.Element.CurrentSettings.Name = string.format("%s\n%d单位", displayName, math.floor(distance))
                    elementData.Element.CurrentSettings.Color = currentColor
                    elementData.Element.CurrentSettings.FillColor = currentColor
                    elementData.Element.CurrentSettings.OutlineColor = currentColor
                    elementData.Element.CurrentSettings.Tracer.Color = currentColor
                    elementData.Element.CurrentSettings.Arrow.Color = currentColor
                    elementData.Element.CurrentSettings.Tracer.Enabled = _G.EnableTracers or false
                    elementData.Element.CurrentSettings.Arrow.Enabled = _G.EnableArrows or false
                    elementData.Element.CurrentSettings.ESPType = _G.ESPType or "Highlight"
                end
            else
                if elementData.Element and elementData.Element.Destroy then elementData.Element:Destroy() end
                table.remove(ESPData[espName].Elements, i)
            end
        end
    end)

    table.insert(ESPData[espName].Connections, addedConn)
    table.insert(ESPData[espName].Connections, removingConn)
    table.insert(ESPData[espName].Connections, updateConn)
end

function UpdateAllESP()
    for espName, data in pairs(ESPData) do
        if _G[espName .. "_Enabled"] then
            CreateESP(espName, true, data.Models, data.DisplayName, data.Color)
        end
    end
end

for _, config in ipairs(ObjectESPConfig) do _G[config.Name .. "_Color"] = ColorConfig[config.DefaultColor] end
for _, config in ipairs(EntityESPConfig) do _G[config.Name .. "_Color"] = ColorConfig[config.DefaultColor] end

local function StartRainbowEffect()
    if RainbowConnection then RainbowConnection:Disconnect() end
    RainbowConnection = RunService.Heartbeat:Connect(function()
        local time = tick()
        ColorConfig["彩虹动态"] = Color3.new(
            math.sin(time * 2) * 0.5 + 0.5,
            math.sin(time * 2 + 2) * 0.5 + 0.5,
            math.sin(time * 2 + 4) * 0.5 + 0.5
        )
        for espName, data in pairs(ESPData) do
            if data.Color == ColorConfig["彩虹动态"] and _G[espName .. "_Enabled"] then
                data.Color = ColorConfig["彩虹动态"]
            end
        end
    end)
end

local function CleanupESP()
    for espName, data in pairs(ESPData) do
        for _, elementData in pairs(data.Elements) do
            if elementData.Element and elementData.Element.Destroy then elementData.Element:Destroy() end
        end
        for _, conn in pairs(data.Connections) do if conn then conn:Disconnect() end end
    end
    ESPData = {}
    if RainbowConnection then RainbowConnection:Disconnect() RainbowConnection = nil end
end

LocalPlayer.AncestryChanged:Connect(function(_, parent) if not parent then CleanupESP() end end)
StartRainbowEffect()

_G.ESPType = "Highlight"
_G.EnableTracers = false
_G.EnableArrows = false

-- ============================================================
-- 提示
-- ============================================================
local TabNotify = Window:CreateTab("提示")
local NotifyGroup = TabNotify:CreateModule("实体刷新提示", "bell", {})

local EntityNotifications = {
    Screech = { Description = "尖啸者已生成", Color = Color3.fromRGB(255,255,0) },
    Halt = { Description = "暂停实体已出现", Color = Color3.fromRGB(0,255,255) },
    FigureRig = { Description = "检测到雕像", Color = Color3.fromRGB(255,0,0) },
    Eyes = { Description = "眼睛实体已生成", Color = Color3.fromRGB(127,30,220) },
    SeekMoving = { Description = "追逐者已生成", Color = Color3.fromRGB(255,100,100) },
    RushMoving = { Description = "冲刺正在接近", Color = Color3.fromRGB(0,255,0) },
    AmbushMoving = { Description = "伏击正在接近", Color = Color3.fromRGB(80,255,110) },
    A60 = { Description = "A-60 正在冲刺", Color = Color3.fromRGB(200,50,50) },
    A120 = { Description = "A-120 在附近", Color = Color3.fromRGB(55,55,55) },
    GiggleCeiling = { Description = "傻笑在天花板上", Color = Color3.fromRGB(200,200,200) },
    GrumbleRig = { Description = "咕噜在巡逻", Color = Color3.fromRGB(150,150,150) },
    GloombatSwarm = { Description = "暗影蝙蝠群来袭", Color = Color3.fromRGB(100,100,100) },
    Dread = { Description = "恐惧实体已激活", Color = Color3.fromRGB(80,80,80) },
    BackdoorLookman = { Description = "观察者在注视", Color = Color3.fromRGB(110,15,15) },
    Snare = { Description = "陷阱已生成", Color = Color3.fromRGB(100,100,100) },
    WorldLotus = { Description = "检测到世界莲花", Color = Color3.fromRGB(200,230,50) },
    Bramble = { Description = "荆棘在生长", Color = Color3.fromRGB(50,150,30) },
    Caws = { Description = "乌鸦在飞行", Color = Color3.fromRGB(30,30,30) },
    Eyestalk = { Description = "眼柄将要追逐", Color = Color3.fromRGB(150,80,200) },
    Grampy = { Description = "爷爷已出现", Color = Color3.fromRGB(180,180,180) },
    Groundskeeper = { Description = "园丁在附近", Color = Color3.fromRGB(100,150,50) },
    Mandrake = { Description = "曼德拉草在尖叫", Color = Color3.fromRGB(130,80,30) },
    Monument = { Description = "纪念碑已激活", Color = Color3.fromRGB(150,150,150) },
    Surge = { Description = "浪涌在充能", Color = Color3.fromRGB(230,130,30) },
    BackdoorRush = { Description = "闪电即将到来", Color = Color3.fromRGB(230,130,30) },
}

local NotifyConnections = {}

function SetupEntityNotification(entityName, enabled)
    if NotifyConnections[entityName] then
        NotifyConnections[entityName]:Disconnect()
        NotifyConnections[entityName] = nil
    end
    if NotifyConnections[entityName .. "_Rooms"] then
        NotifyConnections[entityName .. "_Rooms"]:Disconnect()
        NotifyConnections[entityName .. "_Rooms"] = nil
    end
    if not enabled then return end

    local entityData = EntityNotifications[entityName]
    if not entityData then return end

    local function onEntityAdded(obj)
        if obj.Name == entityName then
            Window:Notify({ Title = "实体刷新", Content = entityData.Description, Duration = 5 })
        end
    end

    NotifyConnections[entityName] = workspace.ChildAdded:Connect(onEntityAdded)

    local rooms = workspace:FindFirstChild("CurrentRooms")
    if rooms then
        NotifyConnections[entityName .. "_Rooms"] = rooms.DescendantAdded:Connect(function(obj)
            if obj.Name == entityName then
                Window:Notify({ Title = "实体刷新", Content = entityData.Description, Duration = 5 })
            end
        end)
    end
end

local entityToggleList = {
    { Title = "尖啸者提示",   Name = "Screech" },
    { Title = "暂停实体提示", Name = "Halt" },
    { Title = "雕像提示",     Name = "FigureRig" },
    { Title = "眼睛提示",     Name = "Eyes" },
    { Title = "追逐者提示",   Name = "SeekMoving" },
    { Title = "冲刺提示",     Name = "RushMoving" },
    { Title = "伏击提示",     Name = "AmbushMoving" },
    { Title = "A-60提示",     Name = "A60" },
    { Title = "A-120提示",    Name = "A120" },
    { Title = "傻笑提示",     Name = "GiggleCeiling" },
    { Title = "咕噜提示",     Name = "GrumbleRig" },
    { Title = "暗影蝙蝠提示", Name = "GloombatSwarm" },
    { Title = "恐惧提示",     Name = "Dread" },
    { Title = "观察者提示",   Name = "BackdoorLookman" },
    { Title = "陷阱提示",     Name = "Snare" },
    { Title = "世界莲花提示", Name = "WorldLotus" },
    { Title = "荆棘提示",     Name = "Bramble" },
    { Title = "乌鸦提示",     Name = "Caws" },
    { Title = "眼柄提示",     Name = "Eyestalk" },
    { Title = "爷爷提示",     Name = "Grampy" },
    { Title = "园丁提示",     Name = "Groundskeeper" },
    { Title = "曼德拉草提示", Name = "Mandrake" },
    { Title = "纪念碑提示",   Name = "Monument" },
    { Title = "浪涌提示",     Name = "Surge" },
    { Title = "闪电提示",     Name = "BackdoorRush" },
}

for _, item in ipairs(entityToggleList) do
    NotifyGroup:CreateToggle(item.Title, false, function(Value)
        SetupEntityNotification(item.Name, Value)
    end)
end

-- ============================================================
-- 加载完成
-- ============================================================
Window:Notify({
    Title    = "xtal脚本_V2",
    Content  = "所有标签页已加载完成",
    Duration = 5,
})
