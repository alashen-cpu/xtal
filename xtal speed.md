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

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ============================================================
-- 窗口
-- ============================================================
local Window = Library:CreateWindow({
    Name              = "xtal",
    Title             = "xtal脚本 - 极速传奇",
    Version           = "V2",
    Theme             = "Nord",
    Backdrop          = true,
    ShowBackdrop      = true,
    GradientAnimation = true,
    ConfigFolder      = "xtal_CloudHub",
    SearchTab         = true,
    Visible           = true,
})

Window:Notify({
    Title    = "xtal",
    Content  = "欢迎 " .. LocalPlayer.Name .. " 使用 xtal 脚本",
    Duration = 5,
})

-- ============================================================
-- Tab
-- ============================================================
local TabFarm    = Window:CreateTab("自动刷功能")
local TabTP      = Window:CreateTab("传送功能")
local TabAutoFun = Window:CreateTab("自动功能")

-- ============================================================
-- 自动刷功能
-- ============================================================
local PageFarm = TabFarm:CreateModule("刷取功能", "layout-grid", {})

-- 自动刷经验 150
PageFarm:CreateToggle("自动刷经验 150", false, function(Value)
    autoXP = Value
    while autoXP do
        for _ = 1, 17 do
            ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
        end
        wait()
    end
end)

-- 自动刷速度 - 城市
local cssdkq = false
PageFarm:CreateToggle("自动刷速度 (城市)", false, function(state)
    cssdkq = state
    if state then
        while cssdkq do
            for _ = 1, 19 do
                ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb", "Red Orb", "City")
            end
            wait(1e-75)
        end
    end
    Window:Notify({
        Title = "xtal：",
        Content = state and "已开启自动刷速度" or "已关闭自动刷速度",
        Duration = 2,
    })
end)

-- 自动刷速度 - 白雪城
local bxsdkq = false
PageFarm:CreateToggle("自动刷速度 (白雪城)", false, function(state)
    bxsdkq = state
    if state then
        while bxsdkq do
            for _ = 1, 18 do
                ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb", "Red Orb", "Snow City")
            end
            wait(1e-75)
        end
    end
    Window:Notify({
        Title = "xtal：",
        Content = state and "已开启自动刷速度" or "已关闭自动刷速度",
        Duration = 2,
    })
end)

-- 自动刷速度 - 岩浆城
local dysdkq = false
PageFarm:CreateToggle("自动刷速度 (岩浆城)", false, function(state)
    dysdkq = state
    if state then
        while dysdkq do
            for _ = 1, 16 do
                ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb", "Red Orb", "Magma City")
            end
            wait(1e-75)
        end
    end
    Window:Notify({
        Title = "xtal：",
        Content = state and "已开启自动刷速度" or "已关闭自动刷速度",
        Duration = 2,
    })
end)

-- 自动刷速度 - 传奇公路
local cqsdkq = false
PageFarm:CreateToggle("自动刷速度 (传奇公路)", false, function(state)
    cqsdkq = state
    if state then
        while cqsdkq do
            for _ = 1, 16 do
                ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb", "Red Orb", "Legends Highway")
            end
            wait(1e-75)
        end
    end
    Window:Notify({
        Title = "xtal：",
        Content = state and "已开启自动刷速度" or "已关闭自动刷速度",
        Duration = 2,
    })
end)

-- 自动重生
local cskq = false
PageFarm:CreateToggle("自动重生", false, function(state)
    cskq = state
    if state then
        while cskq do
            ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("rebirthEvent"):FireServer("rebirthRequest")
            wait(1e-75)
        end
    end
    Window:Notify({
        Title = "xtal：",
        Content = state and "已开启自动重生" or "已关闭自动重生",
        Duration = 2,
    })
end)

-- 自动刷钻石 - 城市
local cszskq = false
PageFarm:CreateToggle("自动刷钻石 (城市)", false, function(state)
    cszskq = state
    if state then
        while cszskq do
            for _ = 1, 20 do
                ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb", "Gem", "City")
            end
            wait(1e-75)
        end
    end
    Window:Notify({
        Title = "xtal：",
        Content = state and "已开启自动刷钻石" or "已关闭自动刷钻石",
        Duration = 2,
    })
end)

-- 自动刷钻石 - 白雪城
local bxzskq = false
PageFarm:CreateToggle("自动刷钻石 (白雪城)", false, function(state)
    bxzskq = state
    if state then
        while bxzskq do
            for _ = 1, 20 do
                ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb", "Gem", "Snow City")
            end
            wait(1e-75)
        end
    end
    Window:Notify({
        Title = "xtal：",
        Content = state and "已开启自动刷钻石" or "已关闭自动刷钻石",
        Duration = 2,
    })
end)

-- 自动刷钻石 - 岩浆城
local yjzskq = false
PageFarm:CreateToggle("自动刷钻石 (岩浆城)", false, function(state)
    yjzskq = state
    if state then
        while yjzskq do
            for _ = 1, 20 do
                ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb", "Gem", "Magma City")
            end
            wait(1e-75)
        end
    end
    Window:Notify({
        Title = "xtal：",
        Content = state and "已开启自动刷钻石" or "已关闭自动刷钻石",
        Duration = 2,
    })
end)

-- 自动刷钻石 - 传奇公路
local cqzskq = false
PageFarm:CreateToggle("自动刷钻石 (传奇公路)", false, function(state)
    cqzskq = state
    if state then
        while cqzskq do
            for _ = 1, 20 do
                ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb", "Gem", "Legends Highway")
            end
            wait(1e-75)
        end
    end
    Window:Notify({
        Title = "xtal：",
        Content = state and "已开启自动刷钻石" or "已关闭自动刷钻石",
        Duration = 2,
    })
end)

-- ============================================================
-- 传送功能
-- ============================================================
local PageTP = TabTP:CreateModule("传送点", "map-pin", {})

local q = {
    CFrame.new(-278.8976135253906, 66.09315490722656, -10946.564453125),
    CFrame.new(3980.05029296875, 159.91925048828125, 5589.21533203125),
    CFrame.new(137.6853485107422, 75.40111541748047, -5972.4873046875),
    CFrame.new(-15376.439453125, 412.2984619140625, 4475.322265625),
    CFrame.new(-489.440673828125, 98.277099609375, 2502.03564453125),
    CFrame.new(-15167.5068359375, 382.1965026855469, 4888.2900390625),
    CFrame.new(2094.217041015625, 251.98931884765625, 12877.951171875),
    CFrame.new(-1645.1728515625, 69.02545928955078, 5337.923828125),
    CFrame.new(-13254.447265625, 222.44158935546875, 4891.56005859375),
    CFrame.new(-533.439208984375, 58.4377326965332, 209.794921875),
    CFrame.new(473.2319641113281, 66.08084106445312, -10867.8388671875),
    CFrame.new(2333.369873046875, 161.6602325439453, 13369.1240234375),
    CFrame.new(5392.5322265625, 297.8348388671875, 5885.2138671875),
    CFrame.new(3806.247802734375, 299.41748046875, 7225.6806640625),
    CFrame.new(1664.3343505859375, 80.900390625, 12589.7109375),
    CFrame.new(1769.7236328125, 80.90105438232422, 12879.7958984375),
    CFrame.new(-11097.05859375, 200.84193420410156, 4465.34375),
    CFrame.new(-13140.974609375, 200.84193420410156, 4465.39599609375),
    CFrame.new(-536.3781127929688, 58.43798065185547, -133.1399688720703),
    CFrame.new(2485.461181640625, 135.55299377441406, 12384.6455078125),
    CFrame.new(1173.287109375, 92.03070831298828, -6024.24365234375),
    CFrame.new(-85.52466583251953, 115.9759750366211, -107.73560333251953),
    CFrame.new(1805.7076416015625, 90.94168853759766, 4617.30712890625),
    CFrame.new(-350.6163330078125, 66.06715393066406, -8732.2490234375),
    CFrame.new(5666.32861328125, 326.5240478515625, 6494.826171875),
    CFrame.new(4516.66845703125, 221.20545959472656, 7181.7421875),
    CFrame.new(-1746.5504150390625, 150.5835418701172, 5372.54248046875),
    CFrame.new(5361.96826171875, 297.8207092285156, 7025.44482421875),
    CFrame.new(4650.1669921875, 221.213134765625, 5608.54345703125),
    CFrame.new(-12993.1826171875, 200.82785034179688, 5222.71337890625),
    CFrame.new(355.5094299316406, 111.75679779052734, -10924.6923828125),
    CFrame.new(1942.0057373046875, 93.18344116210938, -2047.2164306640625),
    CFrame.new(-15156.52734375, 355.08978271484375, 4141.91357421875),
    CFrame.new(2062.114990234375, 159.88404846191406, 4374.28076171875),
    CFrame.new(230.04505920410156, 94.17676544189453, 80.71623229980469),
}

local sqkq = false
PageTP:CreateToggle("自动刷圈 (传奇公路)", false, function(state)
    sqkq = state
    if state then
        while sqkq do
            for _, zdsq in ipairs(q) do
                LocalPlayer.Character.HumanoidRootPart.CFrame = zdsq
                wait(1e-75)
            end
            wait(1e-75)
        end
    else
        LocalPlayer.Character.HumanoidRootPart.CFrame =
            CFrame.new(-568.6292114257812, 3.1723721027374268, 412.86492919921875)
    end
    Window:Notify({
        Title = "xtal：",
        Content = state and "已开启自动刷圈" or "已关闭自动刷圈",
        Duration = 2,
    })
end)

local function tpTo(pos, label)
    if LocalPlayer.Character then
        LocalPlayer.Character.HumanoidRootPart.CFrame = pos
    end
    Window:Notify({ Title = "xtal：", Content = "已传送至 " .. label, Duration = 3 })
end

PageTP:CreateButton("传送至城市（出生点）", function()
    tpTo(CFrame.new(-568.6292114257812, 3.1723721027374268, 412.86492919921875), "城市出生点")
end)

PageTP:CreateButton("传送至神秘洞穴", function()
    tpTo(CFrame.new(-9683.048828125, 58.352359771728516, 3136.626953125), "神秘洞穴")
end)

PageTP:CreateButton("传送至白雪城市", function()
    tpTo(CFrame.new(-866.3868408203125, 3.222372055053711, 2165.70654296875), "白雪城市")
end)

PageTP:CreateButton("传送至地狱洞穴", function()
    tpTo(CFrame.new(-11041.357421875, 58.352359771728516, 4111.8251953125), "地狱洞穴")
end)

PageTP:CreateButton("传送至熔岩城市", function()
    tpTo(CFrame.new(1616.8270263671875, 3.2723801136016846, 4330.65234375), "熔岩城市")
end)

PageTP:CreateButton("传送至水手路线", function()
    tpTo(CFrame.new(-1618.4071044921875, 8.759234428405762, 4892.44091796875), "水手路线")
end)

PageTP:CreateButton("传送至电光洞穴", function()
    tpTo(CFrame.new(-13107.9892578125, 58.352359771728516, 4099.099609375), "电光洞穴")
end)

PageTP:CreateButton("传送至传奇公路", function()
    tpTo(CFrame.new(3673.601318359375, 70.75231170654297, 5588.7958984375), "传奇公路")
end)

PageTP:CreateButton("传送至丛林洞穴", function()
    tpTo(CFrame.new(-15266.7880859375, 239.7072296142578, 3769.77490234375), "丛林洞穴")
end)

-- ============================================================
-- 自动功能
-- ============================================================
local PageAutoFun = TabAutoFun:CreateModule("自动功能", "layout-grid", {})

-- 自动比赛
local zdbskq = false
PageAutoFun:CreateToggle("自动比赛", false, function(state)
    zdbskq = state
    if state then
        while zdbskq do
            ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("raceEvent"):FireServer("joinRace")
            wait(1e-75)
        end
    end
    Window:Notify({
        Title = "xtal：",
        Content = state and "已开启自动比赛" or "已关闭自动比赛",
        Duration = 2,
    })
end)

-- 自动刷速度 V2
local zdsdkq = false
PageAutoFun:CreateToggle("自动刷速度 V2", false, function(state)
    zdsdkq = state
    if state then
        while zdsdkq do
            for _ = 1, 20 do
                ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer(
                    "collectQuest", Instance.new("Folder", nil)
                )
            end
            wait(1e-75)
        end
    end
    Window:Notify({
        Title = "xtal：",
        Content = state and "已开启自动刷速度" or "已关闭自动刷速度",
        Duration = 2,
    })
end)

-- 自动买宠物
local mcwkq = false
PageAutoFun:CreateToggle("自动买宠物", false, function(state)
    mcwkq = state
    if state then
        while mcwkq do
            ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer("openCrystal", "Jungle Crystal")
            wait(1e-75)
        end
    end
    Window:Notify({
        Title = "xtal：",
        Content = state and "已开启自动买宠物" or "已关闭自动买宠物",
        Duration = 2,
    })
end)

-- 自动买尾迹
local mwjkq = false
PageAutoFun:CreateToggle("自动买尾迹", false, function(state)
    mwjkq = state
    if state then
        while mwjkq do
            ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer("openCrystal", "Inferno Crystal")
            wait(1e-75)
        end
    end
    Window:Notify({
        Title = "xtal：",
        Content = state and "已开启自动买尾迹" or "已关闭自动买尾迹",
        Duration = 2,
    })
end)

-- ============================================================
-- 加载完成
-- ============================================================
Window:Notify({
    Title    = "xtal",
    Content  = "所有标签页已加载完成",
    Duration = 5,
})
