local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "xtal",
    SubTitle = "战斗 / Hitbox / 透视 / 人物 / 锁定 / 农场 / Helper / 服务器延迟 / 实用",
    Theme = "Dark",
    Size = UDim2.fromOffset(620, 760)
})

local MainTab = Window:Tab({ Title = "战斗", Icon = "rbxassetid://6031068432", Border = true })
local MainSection = MainTab:Section({ Title = "功能控制" })
local HitboxTab = Window:Tab({ Title = "Hitbox", Icon = "crosshair", Border = true })
local HitboxSection = HitboxTab:Section({ Title = "范围调整" })
local EspTab = Window:Tab({ Title = "透视", Icon = "rbxassetid://6031068432", Border = true })
local EspSection = EspTab:Section({ Title = "透视功能" })
local EspVisualSection = EspTab:Section({ Title = "视觉选项" })
local CharacterTab = Window:Tab({ Title = "人物功能", Icon = "rbxassetid://6031068432", Border = true })
local CharacterSection = CharacterTab:Section({ Title = "加速 / 防御 / 防卡 / 飞行" })
local LockTab = Window:Tab({ Title = "锁定功能", Icon = "rbxassetid://6031068432", Border = true })
local LockSection = LockTab:Section({ Title = "目标锁定 / 带来全部人" })
local LoopGotoSection = LockTab:Section({ Title = "循环传送" })
local FarmTab = Window:Tab({ Title = "农场", Icon = "rbxassetid://6031068432", Border = true })
local FarmSection = FarmTab:Section({ Title = "自动杀戮" })
local HelperTab = Window:Tab({ Title = "Helper", Icon = "rbxassetid://6031068432", Border = true })
local HelperSection = HelperTab:Section({ Title = "辅助功能" })
local ServerLaggerTab = Window:Tab({ Title = "服务器延迟", Icon = "server", Border = true })
local ServerLaggerSection = ServerLaggerTab:Section({ Title = "延迟控制" })
local UtilityTab = Window:Tab({ Title = "实用", Icon = "box", Border = true })
local UtilitySection = UtilityTab:Section({ Title = "服务器工具" })

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

local Core = require(ReplicatedStorage:WaitForChild("Core"))
local Data = LocalPlayer:WaitForChild("Data")
local CharValue = Data:WaitForChild("Character")
local AbilityRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Abilities"):WaitForChild("Ability")
local ActionRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Action")
local DashRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Character"):WaitForChild("Dash")

local function Notify(title, desc, icon)
    pcall(function()
        WindUI:Notify({ Title = title, Desc = desc, Icon = icon or "check", Duration = 2 })
    end)
end

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
local function checkAllPlayers() for _, p in ipairs(Players:GetPlayers()) do checkFriend(p) end end
task.spawn(checkAllPlayers)
task.spawn(function() while true do task.wait(1); checkAllPlayers() end end)
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

local EspEnabled, EspConn, EspUpdateConn, EspDrawings = false, nil, nil, {}
local EspConf = {
    TeamCheck = false,
    FriendCheck = false,
    ShowName = true,
    ShowDistance = true,
    ShowHealthBar = true,
    ShowHealthText = true,
    ShowBox = true,
    ShowBoxFill = true,
    ShowChams = false,
    ShowTracer = false,
    ShowSkeleton = false,
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

local SpeedEnabled, SpeedMultiplier, SpeedConn = false, 2, nil
local AntiLagEnabled, AntiLagLoop = false, nil
local LockTargetName, LockEnabled, LockLoop, LockPlayerDropdown, LockToggleUI
local BringAllEnabled, BringAllLoop
local FarmEnabled, FarmLoop, FarmOpenedKillAura
local LaggerEnabled, LaggerLoop
local InstantTransformationEnabled, InfiniteUltimateEnabled
local IgFriend = false

local function getRoot(char) return char and char:FindFirstChild("HumanoidRootPart") end
local function getLocalRoot() return getRoot(LocalPlayer.Character) end

local function dash()
    local now = tick()
    if now - lastDash < 0.2 then return end
    lastDash = now
    local hrp = getLocalRoot()
    if not hrp then return end
    pcall(function()
        DashRemote:FireServer(hrp.CFrame, "L", hrp.CFrame.LookVector, nil, now)
    end)
end

local function sendWallComboAttack(targets)
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

local function getPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then table.insert(names, player.Name) end
    end
    return names
end

-- 杀戮光环 v3
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
        Notify("杀戮光环 v3", "已开启", "sword")
    else
        Notify("杀戮光环 v3", "已关闭", "sword")
    end
end

-- 杀戮光环 v3+
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
            local count = (CharValue.Value == "Gon") and 20 or 50
            AuraV2Tick(count)
        end)
        Notify("杀戮光环 v3+", "已开启", "target")
    else
        Notify("杀戮光环 v3+", "已关闭", "target")
    end
end

-- 墙打光环 v3
local WallComboV1Enabled = false
local WallComboV1Conn
local function wallComboV1Tick()
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
        Notify("墙打光环 v3", "已开启", "zap")
    else
        Notify("墙打光环 v3", "已关闭", "zap")
    end
end

-- 墙打光环 v3+
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
        Notify("墙打光环 v3+", "已开启", "zap")
    else
        Notify("墙打光环 v3+", "已关闭", "zap")
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.E then WallKillV2Execute() end
end)

-- 无敌
local WudiActive = false
local function wallcomboveryud()
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

-- 瞬时复活（999 命）
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
    local character = LocalPlayer.Character
    if not character then return end
    if hasReplicateSignal() then
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
    respawnHandler = LocalPlayer.CharacterAdded:Connect(function(char)
        if not InstantRespawnOn or not savedPosition then return end
        local rootPart = char:WaitForChild("HumanoidRootPart", 5)
        if not rootPart then return end
        local delay = _G.Lives999TeleportDelay or 0.2
        task.wait(delay)
        require(LocalPlayer.PlayerScripts.Character.FullCustomReplication).Override(char, savedPosition)
        savedPosition = nil
    end)
end

-- 自动格挡
local AutoBlockOn = false
task.spawn(function()
    local re = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Block")
    while true do
        task.wait(0.1)
        if AutoBlockOn then pcall(function() re:FireServer(true) end) end
    end
end)

-- 反反击
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

-- 冲刺辅助
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
    if not dashTF then Notify("冲刺辅助", "未找到函数", "x"); return end
    dashOF = hookfunction(dashTF, function(...) return dashOF(...) end)
    dashHooked = true
    Notify("冲刺辅助", "已开启", "zap")
end
local function disableDashHelper()
    if not dashHooked or not dashOF or not dashTF then return end
    hookfunction(dashTF, dashOF)
    dashHooked = false
    dashTF, dashOF = nil, nil
    Notify("冲刺辅助", "已关闭", "zap")
end

-- Hitbox
local origBox
local HBConf = {X = 40, Y = 40, Z = 40, M = "Override", V = false}
local function applyHitbox(on)
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

-- ═══════════════════════════════════════════
-- 优化后的透视
-- ═══════════════════════════════════════════
local function createPlayerEsp(player)
    if player == LocalPlayer or EspDrawings[player] then return end
    local Box = Drawing.new("Square")
    Box.Thickness = EspConf.BoxThickness
    Box.Filled = false
    Box.Transparency = 1
    Box.Visible = false

    local BoxFill = Drawing.new("Square")
    BoxFill.Thickness = 1
    BoxFill.Filled = true
    BoxFill.Transparency = EspConf.BoxFillTransparency
    BoxFill.Visible = false

    local Name = Drawing.new("Text")
    Name.Size = 13
    Name.Center = true
    Name.Outline = true
    Name.OutlineColor = Color3.fromRGB(0,0,0)
    Name.Transparency = 1
    Name.Visible = false

    local Distance = Drawing.new("Text")
    Distance.Size = 12
    Distance.Center = true
    Distance.Outline = true
    Distance.OutlineColor = Color3.fromRGB(0,0,0)
    Distance.Transparency = 1
    Distance.Visible = false

    local HealthBg = Drawing.new("Square")
    HealthBg.Thickness = 1
    HealthBg.Color = Color3.fromRGB(0,0,0)
    HealthBg.Filled = true
    HealthBg.Transparency = 0.5
    HealthBg.Visible = false

    local HealthBar = Drawing.new("Square")
    HealthBar.Thickness = 1
    HealthBar.Filled = true
    HealthBar.Transparency = 1
    HealthBar.Visible = false

    local HealthText = Drawing.new("Text")
    HealthText.Size = 10
    HealthText.Center = true
    HealthText.Outline = true
    HealthText.OutlineColor = Color3.fromRGB(0,0,0)
    HealthText.Transparency = 1
    HealthText.Visible = false

    local Chams = Instance.new("Highlight")
    Chams.FillColor = EspConf.ChamsColor
    Chams.OutlineColor = EspConf.ChamsOutlineColor
    Chams.FillTransparency = EspConf.ChamsTransparency
    Chams.OutlineTransparency = 0
    Chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Chams.Adornee = nil
    Chams.Parent = workspace
    Chams.Enabled = false

    local Tracer = Drawing.new("Line")
    Tracer.Thickness = 1
    Tracer.Transparency = 1
    Tracer.Visible = false

    EspDrawings[player] = {
        Box = Box, BoxFill = BoxFill, Name = Name, Distance = Distance,
        HealthBg = HealthBg, HealthBar = HealthBar, HealthText = HealthText,
        Chams = Chams, Tracer = Tracer
    }
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
    return { MinX=minX, MinY=minY, MaxX=maxX, MaxY=maxY, Width=maxX-minX, Height=maxY-minY, CenterX=(minX+maxX)/2, CenterY=(minY+maxY)/2 }
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

                -- 方框
                if EspConf.ShowBox then
                    d.Box.Position = Vector2.new(b.MinX, b.MinY)
                    d.Box.Size = Vector2.new(b.Width, b.Height)
                    d.Box.Color = color
                    d.Box.Thickness = EspConf.BoxThickness
                    d.Box.Visible = true
                else
                    d.Box.Visible = false
                end

                -- 方框填充
                if EspConf.ShowBoxFill then
                    d.BoxFill.Position = Vector2.new(b.MinX+1, b.MinY+1)
                    d.BoxFill.Size = Vector2.new(b.Width-2, b.Height-2)
                    d.BoxFill.Color = EspConf.BoxFillColor
                    d.BoxFill.Transparency = EspConf.BoxFillTransparency
                    d.BoxFill.Visible = true
                else
                    d.BoxFill.Visible = false
                end

                -- 名字
                if EspConf.ShowName then
                    d.Name.Text = player.Name
                    d.Name.Color = EspConf.NameColor
                    d.Name.Position = Vector2.new(b.CenterX, b.MinY - 16)
                    d.Name.Visible = true
                else
                    d.Name.Visible = false
                end

                -- 距离
                if EspConf.ShowDistance then
                    d.Distance.Text = "[" .. math.floor(distance) .. "m]"
                    d.Distance.Color = EspConf.DistanceColor
                    d.Distance.Position = Vector2.new(b.CenterX, b.MaxY + 4)
                    d.Distance.Visible = true
                else
                    d.Distance.Visible = false
                end

                -- 血条
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

                -- 血量文字
                if EspConf.ShowHealthText then
                    d.HealthText.Text = math.floor(hp * 100) .. "%"
                    d.HealthText.Color = color
                    d.HealthText.Position = Vector2.new(b.MinX - EspConf.HealthBarWidth - 12, b.CenterY)
                    d.HealthText.Visible = true
                else
                    d.HealthText.Visible = false
                end

                -- 高亮 (Chams)
                if EspConf.ShowChams then
                    d.Chams.Adornee = char
                    d.Chams.FillColor = EspConf.ChamsColor
                    d.Chams.OutlineColor = EspConf.ChamsOutlineColor
                    d.Chams.FillTransparency = EspConf.ChamsTransparency
                    d.Chams.Enabled = true
                else
                    d.Chams.Enabled = false
                end

                -- 追踪线
                if EspConf.ShowTracer then
                    local origin = EspConf.TracerOrigin == "Top" and Vector2.new(bottomCenter.X, 0) or bottomCenter
                    d.Tracer.From = origin
                    d.Tracer.To = Vector2.new(b.CenterX, b.CenterY)
                    d.Tracer.Color = EspConf.TracerColor
                    d.Tracer.Visible = true
                else
                    d.Tracer.Visible = false
                end
            else
                d.Box.Visible = false
                d.BoxFill.Visible = false
                d.Name.Visible = false
                d.Distance.Visible = false
                d.HealthBg.Visible = false
                d.HealthBar.Visible = false
                d.HealthText.Visible = false
                d.Chams.Enabled = false
                d.Tracer.Visible = false
            end
        else
            if d then
                d.Box.Visible = false
                d.BoxFill.Visible = false
                d.Name.Visible = false
                d.Distance.Visible = false
                d.HealthBg.Visible = false
                d.HealthBar.Visible = false
                d.HealthText.Visible = false
                d.Chams.Enabled = false
                d.Tracer.Visible = false
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

-- 防卡
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

local function setAntiLag(state)
    AntiLagEnabled = state
    if state then
        antiLagTick()
        if not AntiLagLoop then AntiLagLoop = task.spawn(function() while AntiLagEnabled do antiLagTick() task.wait(0.5) end end) end
        Notify("防卡", "已开启", "shield")
    else
        if AntiLagLoop then task.cancel(AntiLagLoop); AntiLagLoop = nil end
        enableEffects(workspace)
        Lighting.GlobalShadows = true; Lighting.FogEnd = 1000
        Notify("防卡", "已关闭", "shield-off")
    end
end

-- 移动加速
local function setSpeed(state, multiplier)
    SpeedEnabled = state; SpeedMultiplier = multiplier
    if state then
        if not SpeedConn then SpeedConn = RunService.RenderStepped:Connect(function(dt)
            if not SpeedEnabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.MoveDirection.Magnitude > 0 then
                root.CFrame = root.CFrame + hum.MoveDirection * ((SpeedMultiplier - 1) * 16) * dt
            end
        end) end
        Notify("移动加速", "已开启 (倍率 " .. tostring(SpeedMultiplier) .. ")", "rabbit")
    else
        if SpeedConn then SpeedConn:Disconnect(); SpeedConn = nil end
        Notify("移动加速", "已关闭", "rabbit")
    end
end

-- 飞行
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

-- 循环传送
LoopGotoCtrl = LoopGotoCtrl or {SelectedName=nil, Keybind=nil, IsFollowing=false, Mode=nil, Target=nil, Conn=nil}
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
    Notify("循环传送", "已停止", "square")
end

LoopGotoCtrl.StartWithTarget = function(t, m)
    if not t then return end
    LoopGotoCtrl.Target = t; LoopGotoCtrl.Mode = m; LoopGotoCtrl.IsFollowing = true
    if LoopGotoCtrl.Conn then LoopGotoCtrl.Conn:Disconnect() end
    LoopGotoCtrl.Conn = RunService.Heartbeat:Connect(loopFollow)
    Notify("循环传送", "跟随中: " .. t.Name, "navigation")
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp or not input.KeyCode then return end
    if LGKb ~= "NIL" and input.KeyCode.Name == LGKb then
        if not LoopGotoCtrl.IsFollowing then
            local t
            if LGTarget == "最近" or LGTarget == "closest" then t = findNearest()
            else t = Players:FindFirstChild(LGTarget) end
            if t then LoopGotoCtrl.StartWithTarget(t, "selected") else Notify("循环传送", "无目标", "x") end
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

-- 服务器延迟 方法一
local sl1On, sl1Pos = false, nil

-- 服务器延迟 方法二
local sl2On, sl2Conn = false, nil
local function laggerMethod2()
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

-- 反服务器延迟
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

-- 农场
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
        Notify("农场", "已自动开启杀戮光环 v3", "wheat")
    end
    FarmLoop = task.spawn(farmLoopFunction)
end

local function stopFarm()
    if FarmLoop then task.cancel(FarmLoop); FarmLoop = nil end
    if FarmOpenedKillAura and AuraV1Enabled then
        SetAuraV1(false); FarmOpenedKillAura = false
    end
end

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
        Notify("Lagger", "已开启", "server")
    else
        if LaggerLoop then task.cancel(LaggerLoop); LaggerLoop = nil end
        Notify("Lagger", "已关闭", "server")
    end
end

local function setInstantTransformation(state)
    InstantTransformationEnabled = state
    local s = ReplicatedStorage:FindFirstChild("Settings")
    if s and s:FindFirstChild("Toggles") and s.Toggles:FindFirstChild("InstantTransformation") then s.Toggles.InstantTransformation.Value = state end
    Notify("瞬开大招", state and "已开启" or "已关闭", "zap")
end

local function setInfiniteUltimate(state)
    InfiniteUltimateEnabled = state
    local s = ReplicatedStorage:FindFirstChild("Settings")
    if s and s:FindFirstChild("Multipliers") and s.Multipliers:FindFirstChild("UltimateTimer") then
        s.Multipliers.UltimateTimer.Value = state and 100000 or 1
    end
    Notify("无限觉醒", state and "已开启" or "已关闭", "infinity")
end

-- ============================================================
-- 战斗 UI
-- ============================================================
MainSection:Toggle({ Title = "杀戮光环 v3", Icon = "sword", Value = false, Callback = function(state) SetAuraV1(state) end })
MainSection:Toggle({ Title = "杀戮光环 v3+", Icon = "target", Value = false, Callback = function(state) SetAuraV2(state) end })
MainSection:Toggle({ Title = "墙打光环 v3", Icon = "zap", Value = false, Callback = function(state) SetWallComboV1(state) end })
MainSection:Toggle({ Title = "墙打光环 v3+", Icon = "zap", Value = false, Callback = function(state) SetWallKillV2(state) end })
MainSection:Toggle({ Title = "冲刺辅助", Icon = "wind", Value = false, Callback = function(state)
    if state then enableDashHelper() else disableDashHelper() end
end })
MainSection:Toggle({ Title = "虚空击杀", Icon = "skull", Value = false, Callback = function(state)
    pcall(function() ReplicatedStorage.Settings.Multipliers.RagdollPower.Value = state and 1e14 or 100 end)
    Notify("虚空击杀", state and "已开启" or "已关闭", "skull")
end })
MainSection:Toggle({ Title = "无敌", Icon = "shield", Value = false, Callback = function(state) WudiActive = state; Notify("无敌", state and "已开启" or "已关闭", "shield") end })
MainSection:Toggle({ Title = "忽略好友", Icon = "users", Value = false, Callback = function(state) IgFriend = state end })

-- Hitbox UI
HitboxSection:Toggle({ Title = "开启范围扩展", Value = false, Callback = function(v) applyHitbox(v) end })
HitboxSection:Dropdown({ Title = "扩展方式", Values = {"覆盖","叠加"}, Value = "覆盖", Callback = function(v) HBConf.M = (v == "叠加") and "Add" or "Override" end })
HitboxSection:Slider({ Title = "横向尺寸", Value = { Min = 1, Max = 250, Default = 40 }, Callback = function(v) HBConf.X = v end })
HitboxSection:Slider({ Title = "纵向尺寸", Value = { Min = 1, Max = 250, Default = 40 }, Callback = function(v) HBConf.Y = v end })
HitboxSection:Slider({ Title = "前后尺寸", Value = { Min = 1, Max = 250, Default = 40 }, Callback = function(v) HBConf.Z = v end })
HitboxSection:Toggle({ Title = "显示判定框", Value = false, Callback = function(v) HBConf.V = v end })

-- ═══════════════════════════════════════════
-- 优化后的透视 UI
-- ═══════════════════════════════════════════
EspSection:Toggle({ Title = "玩家透视", Value = false, Callback = function(state)
    if state then startEsp() Notify("玩家透视", "已开启", "eye") else stopEsp() Notify("玩家透视", "已关闭", "eye-off") end
end })
EspSection:Toggle({ Title = "队伍检测", Desc = "排除队友", Value = false, Callback = function(v) EspConf.TeamCheck = v end })
EspSection:Toggle({ Title = "好友检测", Desc = "排除好友", Value = false, Callback = function(v) EspConf.FriendCheck = v end })
EspSection:Slider({ Title = "最大显示距离", Value = { Min = 100, Max = 5000, Default = 1000 }, Callback = function(v) EspConf.MaxDistance = v end })

EspVisualSection:Toggle({ Title = "显示方框", Value = true, Callback = function(v) EspConf.ShowBox = v end })
EspVisualSection:Toggle({ Title = "方框填充", Value = true, Callback = function(v) EspConf.ShowBoxFill = v end })
EspVisualSection:Toggle({ Title = "显示名字", Value = true, Callback = function(v) EspConf.ShowName = v end })
EspVisualSection:Toggle({ Title = "显示距离", Value = true, Callback = function(v) EspConf.ShowDistance = v end })
EspVisualSection:Toggle({ Title = "显示血条", Value = true, Callback = function(v) EspConf.ShowHealthBar = v end })
EspVisualSection:Toggle({ Title = "显示血量百分比", Value = true, Callback = function(v) EspConf.ShowHealthText = v end })
EspVisualSection:Toggle({ Title = "显示高亮 (Chams)", Value = false, Callback = function(v) EspConf.ShowChams = v end })
EspVisualSection:Toggle({ Title = "显示追踪线", Value = false, Callback = function(v) EspConf.ShowTracer = v end })
EspVisualSection:Toggle({ Title = "血量变色", Desc = "根据血量改变方框颜色", Value = true, Callback = function(v) EspConf.HealthBasedColor = v end })
EspVisualSection:Slider({ Title = "方框粗细", Value = { Min = 1, Max = 5, Default = 2 }, Callback = function(v) EspConf.BoxThickness = v end })
EspVisualSection:Slider({ Title = "方框填充透明度", Value = { Min = 0, Max = 1, Default = 0.5 }, Callback = function(v) EspConf.BoxFillTransparency = v end })
EspVisualSection:Slider({ Title = "血条宽度", Value = { Min = 1, Max = 8, Default = 3 }, Callback = function(v) EspConf.HealthBarWidth = v end })
EspVisualSection:Dropdown({ Title = "追踪线起点", Values = {"底部","顶部"}, Value = "底部", Callback = function(v) EspConf.TracerOrigin = (v == "顶部") and "Top" or "Bottom" end })

-- 人物 UI
CharacterSection:Toggle({ Title = "移动加速", Value = false, Callback = function(s) setSpeed(s, SpeedMultiplier) end })
CharacterSection:Slider({ Title = "加速倍率", Value = { Min = 1, Max = 10, Default = 2 }, Callback = function(v) SpeedMultiplier = v; if SpeedEnabled then setSpeed(true, v) end end })
CharacterSection:Toggle({ Title = "防卡", Value = false, Callback = function(s) setAntiLag(s) end })
CharacterSection:Toggle({ Title = "飞行", Icon = "plane", Value = false, Callback = function(state)
    FLY_TOGGLE_STATE = state
    if state then applyFly(); Notify("飞行", "已开启", "plane")
    else NOFLY(); Notify("飞行", "已关闭", "plane") end
end })
CharacterSection:Slider({ Title = "飞行速度", Value = { Min = 1, Max = 10, Default = 2 }, Callback = function(v)
    iyflyspeed = v; vehicleflyspeed = v
end })

-- 锁定 UI
local function refreshPlayerDropdown()
    if LockPlayerDropdown then LockPlayerDropdown:Refresh(getPlayerNames()) end
end
LockPlayerDropdown = LockSection:Dropdown({ Title = "选择目标玩家", Values = getPlayerNames(), Value = nil, Callback = function(name) LockTargetName = name end })
LockSection:Button({ Title = "刷新玩家列表", Callback = refreshPlayerDropdown })
LockToggleUI = LockSection:Toggle({ Title = "持续传送到目标后背", Value = false, Callback = function(state)
    LockEnabled = state
    if state then
        if not LockTargetName then LockToggleUI:Set(false); return end
        if not LockLoop then LockLoop = task.spawn(function()
            while LockEnabled do
                local targetPlayer
                for _, p in ipairs(Players:GetPlayers()) do if p.Name == LockTargetName then targetPlayer = p; break end end
                if not targetPlayer then LockEnabled = false; LockToggleUI:Set(false); break end
                if targetPlayer.Character then
                    local tRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local myRoot = getLocalRoot()
                    if tRoot and myRoot then pcall(function() myRoot.CFrame = CFrame.new(tRoot.Position - tRoot.CFrame.LookVector * 3, tRoot.Position) end) end
                end
                task.wait(0.05)
            end
            LockLoop = nil
        end) end
        Notify("锁定目标", "已开启 -> " .. tostring(LockTargetName), "crosshair")
    else
        if LockLoop then task.cancel(LockLoop); LockLoop = nil end
        Notify("锁定目标", "已关闭", "crosshair")
    end
end })
LockSection:Toggle({ Title = "带来全部人", Value = false, Callback = function(state)
    BringAllEnabled = state
    if state then
        if not BringAllLoop then
            BringAllLoop = task.spawn(function()
                while BringAllEnabled do
                    local myRoot = getLocalRoot()
                    if myRoot then
                        local targets = {}
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character then
                                local root = player.Character:FindFirstChild("HumanoidRootPart")
                                if root then
                                    pcall(function()
                                        root.CFrame = myRoot.CFrame * CFrame.new(0, 0, -3)
                                        player.Character:SetPrimaryPartCFrame(myRoot.CFrame * CFrame.new(0, 0, -3))
                                    end)
                                    table.insert(targets, player.Character)
                                end
                            end
                        end
                        sendWallComboAttack(targets)
                    end
                    task.wait(0.05)
                end
                BringAllLoop = nil
            end)
        end
        Notify("带来全部人", "已开启", "users")
    else
        if BringAllLoop then task.cancel(BringAllLoop); BringAllLoop = nil end
        Notify("带来全部人", "已关闭", "users")
    end
end })

-- 循环传送 UI
LoopGotoSection:Dropdown({ Title = "目标玩家", Values = (function()
    local n = {"最近"}
    for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(n, p.Name) end end
    return n
end)(), Value = "最近", Callback = function(v)
    LGTarget = (v == "最近") and "closest" or v
    LoopGotoCtrl.SelectedName = v
end })
LoopGotoSection:Button({ Title = "刷新列表", Callback = function() Notify("循环传送", "已刷新", "refresh-cw") end })
LoopGotoSection:Dropdown({ Title = "循环传送按键", Values = {"NIL","E","Q","R","T","Y","G","F","V","C","B","H","J","K","L"}, Value = "NIL", Callback = function(v) LGKb = v end })
LoopGotoSection:Dropdown({ Title = "快速传送按键", Values = {"NIL","E","Q","R","T","Y","G","F","V","C","B","H","J","K","L"}, Value = "NIL", Callback = function(v) QLGKb = v end })
LoopGotoSection:Toggle({ Title = "跟随已选玩家", Value = false, Callback = function(v)
    if v then
        local n = LoopGotoCtrl.SelectedName
        local t = n and Players:FindFirstChild(n) or nil
        if t then LoopGotoCtrl.StartWithTarget(t, "selected") else Notify("循环传送", "未选玩家", "x") end
    else
        if LoopGotoCtrl.Mode == "selected" then LoopGotoCtrl.Stop() end
    end
end })
LoopGotoSection:Toggle({ Title = "快速循环传送", Value = false, Callback = function(v)
    if v then
        local n = findNearest()
        if n then LoopGotoCtrl.StartWithTarget(n, "quick") else Notify("循环传送", "无玩家", "x") end
    else
        if LoopGotoCtrl.Mode == "quick" then LoopGotoCtrl.Stop() end
    end
end })

-- 农场 UI
FarmSection:Toggle({ Title = "自动杀戮（农场）", Value = false, Callback = function(state)
    FarmEnabled = state
    if state then startFarm(); Notify("农场", "已开启", "wheat")
    else stopFarm(); Notify("农场", "已关闭", "wheat") end
end })

-- Helper UI
HelperSection:Toggle({ Title = "延迟服务器 (Lagger)", Value = false, Callback = function(s) setLagger(s) end })
HelperSection:Toggle({ Title = "瞬开大招", Value = false, Callback = function(s) setInstantTransformation(s) end })
HelperSection:Toggle({ Title = "无限觉醒", Value = false, Callback = function(s) setInfiniteUltimate(s) end })
HelperSection:Toggle({ Title = "瞬时复活", Icon = "refresh-cw", Value = false, Callback = function(s)
    InstantRespawnOn = s
    if s then start999Lives() else stop999Lives() end
    Notify("瞬时复活", s and "已开启" or "已关闭", "refresh-cw")
end })
HelperSection:Toggle({ Title = "自动格挡", Icon = "shield", Value = false, Callback = function(s) AutoBlockOn = s; Notify("自动格挡", s and "已开启" or "已关闭", "shield") end })
HelperSection:Toggle({ Title = "反反击", Icon = "shield-off", Value = false, Callback = function(s) AntiCounterOn = s; Notify("反反击", s and "已开启" or "已关闭", "shield-off") end })

-- 服务器延迟 UI
ServerLaggerSection:Toggle({ Title = "服务器延迟 方法一", Value = false, Callback = function(v)
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
        Notify("延迟方法一", "已开启", "server")
    else
        sl1On = false
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if h then
            h.CFrame = CFrame.new(0, -120, 0)
            task.wait(0.2)
            if sl1Pos then h.CFrame = sl1Pos end
            h.CollisionGroup = "Characters"
        end
        Notify("延迟方法一", "已关闭", "server")
    end
end })
ServerLaggerSection:Toggle({ Title = "服务器延迟 方法二", Value = false, Callback = function(v)
    if v then
        sl2On = true
        sl2Conn = RunService.Heartbeat:Connect(function() if sl2On then pcall(laggerMethod2) end end)
        Notify("延迟方法二", "已开启", "server")
    else
        sl2On = false
        if sl2Conn then sl2Conn:Disconnect(); sl2Conn = nil end
        Notify("延迟方法二", "已关闭", "server")
    end
end })
ServerLaggerSection:Toggle({ Title = "反服务器延迟", Value = false, Callback = function(v)
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
        Notify("反服务器延迟", "已开启", "server")
    else
        aslOn = false
        if aslConn then aslConn:Disconnect(); aslConn = nil end
        for p, d in pairs(aslCache) do if d.isPhantom and p.Character then restorePlayer(p, p.Character) end end
        aslCache = {}
        Notify("反服务器延迟", "已关闭", "server")
    end
end })

-- 实用 UI
UtilitySection:Button({ Title = "重进服务器", Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer); Notify("服务器", "正在重进", "refresh-cw") end })
UtilitySection:Button({ Title = "服务器跳转", Callback = function()
    local ok, s = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if not ok then Notify("失败", "获取服务器失败", "x"); return end
    local v = {}
    for _, x in pairs(s.data or {}) do
        if x.playing < x.maxPlayers and x.id ~= game.JobId then table.insert(v, x.id) end
    end
    if #v > 0 then TeleportService:TeleportToPlaceInstance(game.PlaceId, v[math.random(#v)], LocalPlayer); Notify("服务器", "正在跳转", "refresh-cw")
    else Notify("失败", "无可用服务器", "x") end
end })

print("xtal 脚本加载完毕")
