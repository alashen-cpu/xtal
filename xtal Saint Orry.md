do
    local _Players         = game:GetService("Players")
    local _RunService      = game:GetService("RunService")
    local _TweenService    = game:GetService("TweenService")
    local _Lighting        = game:GetService("Lighting")
    local _CoreGui         = game:GetService("CoreGui")
    local _LocalPlayer     = _Players.LocalPlayer
    local _PlayerGui       = _LocalPlayer:WaitForChild("PlayerGui")

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
-- [1] 你原本的脚本（一字未动）
-- ============================================================
do
	local stubFalse = function() return false end
	local stubNoop = function() end
	if type(fn12) ~= "function" then fn12 = stubFalse end
	if type(fn13) ~= "function" then fn13 = stubFalse end
	if type(fn17) ~= "function" then fn17 = function() return "{}" end end
	if type(fn14) ~= "function" then fn14 = function(p) return p end end
	if type(fn21) ~= "function" then fn21 = stubNoop end
	if type(fn22) ~= "function" then fn22 = stubNoop end
	if type(fn23) ~= "function" then fn23 = stubNoop end
	if type(fn24) ~= "function" then fn24 = function() return true, { Body = "{}" } end end
	if type(fn25) ~= "function" then fn25 = function() return true end end
	if type(fn19) ~= "function" then fn19 = function(s) return s end end
	if type(handlers) ~= "table" then handlers = {} end
	placeId = placeId or game.PlaceId
	jobId = jobId or game.JobId
	c = c or 0
	if type(cloneref) == "function" then
		local clonerefRaw = cloneref
		cloneref = function(inst) if inst == nil then return nil end return clonerefRaw(inst) end
	elseif cloneref == nil then
		cloneref = function(inst) return inst end
	end
end

local XtalHubEntry = function(loaderUrl, nodeUrl, scriptId, scriptVersion, _unusedScriptKey, extraC, extraD, sigSq, sigRp, debugPrint, progressPrint, reportFunc)
	progressPrint = progressPrint or function(msg) return function() end end
	reportFunc = reportFunc or function() end
	debugPrint = debugPrint or function() end
	local v2 = progressPrint("正在初始化...")
	local tbl = { p = 40 }
	tbl.m = "\174yM\25\4q\210\162;\233)\184\230.~\171\229~\193T\17"
	reportFunc(tbl)
	local s = "\174)\197\28b\161\231\157za:\26\8\11'\20770lw\195\232\156S\234*\203XvJ\203n"
	local v3 = "\130`$\217\169?\140\0268\1442F^\218\207\232"

	if scriptId ~= s or scriptVersion ~= v3 then
	end

	local localPlayer = game:GetService("Players").LocalPlayer
	local concat = table.concat
	local sub = string.sub
	local byte = string.byte
	local char = string.char
	local lshift = bit32.lshift
	local rshift = bit32.rshift
	local band = bit32.band
	local bxor = bit32.bxor
	local rrotate = bit32.rrotate
	local bnot = bit32.bnot

	local cloneFunc = clonefunction or function(...) return ... end
	local v4 = cloneFunc(http and http.request or request or getfenv()["http"])
	local v5 = cloneFunc(debug.traceback)
	local v6 = cloneFunc(debug.info)
	local v7 = cloneFunc(pcall)
	local v8 = cloneFunc(getfenv)
	local v9 = cloneFunc(tostring)
	local v10 = identifyexecutor()
	local v11 = v6(1, "f")
	local script = v8(0).script
	local n2 = #v5():split("\n") - 4
	v2()
	local v12 = progressPrint("正在检查运行环境...")

	local flag3 = fn12(concat) or fn12(sub) or fn12(byte) or fn12(char) or fn12(lshift) or fn12(rshift) or fn12(band) or fn12(bxor) or fn12(rrotate) or false
	if not flag3 then
		local find = table.find
		flag3 = fn12(v4) ~= find({ "Xeno", "Helios Mac" }, v10) ~= nil
	end
	flag3 = flag3 or false

	v16 = ""
	k = nil
	i = 0
	e2 = ""
	c = c or 0
	v40 = nil
	reportFunc({ s = true })

	if v40 then
		v43()
		a = v40.a; b = v40.b; v = i; d = v40.d; f = v40.f; flag2 = true
		g = v40.g; u = v40.h.u; d2 = v40.h.d; a2 = v40.h.a; b2 = v40.h.b; p = v40.h.p
	else
		reportFunc({ s = true })
	end

	fn2 = function(arg11, arg12)
		local v43 = assert
		local flag8 = type(arg11) == "string"
		v43(flag8, "assert1")
		local v44 = assert
		local flag9 = type(arg12) == "string"
		v44(flag9, "assert2")
		return "prefix" .. arg11 .. "middle" .. arg12 .. "suffix"
	end

	fn4 = function(arg11)
		local v43 = assert
		local flag8 = type(arg11) == "table"
		v43(flag8, "assert1")
		local v44 = assert
		local flag9 = type(arg11.Url) == "string"
		v44(flag9, "assert2")
		if arg11["x"] == nil then arg11["x"] = {} end
		if arg11["y"] == nil then arg11["y"] = "GET" end
		local v45, v46, v47 = fn24(arg11, true, v6(1, "f"), 1)
		if not v45 then
			if v46 == ",M\223\183<\239" then
				return { success = false, reason = "request failed", error_message = v47 }
			end
		end
		if not v45 then return { success = false, reason = "tampering detected" } end
		return { success = true, response = v46 }
	end

	fn = function(arg11, arg12)
		local v43 = assert
		local flag8 = type(arg11) == "string"
		v43(flag8, "assert1")
		local v44 = assert
		local flag9 = type(arg12) == "table"
		v44(flag9, "assert2")
		local v45 = fn4
		local Settings = {}
		local v46 = nodeUrl
		Settings.Url = v46 .. "/api"
		Settings.Method = "POST"
		Settings.Body = fn17({ d = v14(fn17({ u = arg11, d = fn17(arg12), s = s }), v16), c = c })
		local headers = {}
		headers["Content-Type"] = "application/json"
		Settings.Headers = headers
		local v47 = v45(Settings)
		if not v47.success then return { success = false, fail_reason = v47.reason } end
		local v48, v49 = v7(function()
			local v48 = v15
			local response = v47.response
			v48(response["body"], v16)
			return nil
		end)
		if not v48 then return { success = false, fail_reason = "decode failed" } end
		if not v49.success then return { success = false, fail_reason = v49.reason } end
		return { success = true }
	end

	fn5 = function(arg11)
		local v43 = assert
		local flag8 = type(arg11) == "string"
		v43(flag8, "assert")
	end

	fn3 = function(arg11, arg12)
		local v43 = assert
		local flag8 = type(arg11) == "string"
		v43(flag8, "assert1")
		local v44 = assert
		local flag9 = type(arg12) == "function"
		v44(flag9, "assert2")
		handlers[arg11] = arg12
	end

	do
		local Players = game:GetService("Players")
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		localPlayer2 = Players.LocalPlayer

		pcall(function()
			local antiCheat = ReplicatedStorage:FindFirstChild("AntiCheat", true)
			if antiCheat and type(antiCheat) == "table" then
				for k2, v35 in pairs(antiCheat) do
					if type(v35) == "function" then
						antiCheat[k2] = function(...)
							local ok, result = pcall(v35, ...)
							if ok then return result end
							return true
						end
					end
				end
			end
		end)

		pcall(function()
			local Ratchet = require(ReplicatedStorage:FindFirstChild("Ratchet", true))
			local Sha256 = require(ReplicatedStorage:FindFirstChild("Sha256", true))
			local v35 = getmetatable(Ratchet)
			if v35 and v35.__index and not v35.__index.__patched then
				v35.__index.catchUp = function(arg11, arg12)
					while arg11.index < arg12 do arg11:advance() end
					return true
				end
				v35.__index.respond = function(arg11, arg12)
					return Sha256("resp|" .. tostring(arg11.state) .. "|" .. tostring(arg11.index) .. "|" .. tostring(arg12))
				end
				v35.__index.__patched = true
			end
		end)
	end

	if hookmetamethod and newcclosure then
		local v27 = nil
		local function fn38(...)
			local arg11, arg12, arg13, arg14, arg15, descendant = ...
			descendant = descendant or arg11
			if arg11 == game and (arg12 == "GetService" or arg12 == "getService") then
				return function(arg13, arg14)
					if arg14 == "InsertService" or arg14 == "Selection" or arg14 == "Stats" then
						return nil
					end
					return v27(arg11, arg14)
				end
			end
			return v27(arg11, arg12)
		end
		v27 = hookmetamethod
		v27 = v27(game, "__index", newcclosure(fn38))
	end

	local Players, ReplicatedStorage, RunService, localPlayer3, fn38, fn39, fn40, lib, tbl8, fn41
	local fn42, v27, connection, flag8, v28, fn43, Settings, fn44, fn45, textButton
	local flag9, flag10, fn46, fn47, fn48, fn49, tbl10, fn50, tbl11, tbl12
	local tbl13, tbl14, tbl15, fn51, tbl16, tbl17, fn52, fn53, PoliceSettings, fn54
	local MovementSettings, fn55, fn56, fn57, fn58, flag11, getSpeedLimitAtPos, fn59

	do
	local FlyState, fn60

	do
	local UserInputService, GuiService, ContextActionService, HttpService, Workspace, signal, fn61, v29, remote, playerEvent, playerFunc, tbl21, fn62, fn63, fn64, fn65, tbl22, connection2, Character, Core, module, fn66, v30, tbl23, connection3, screenGui, connection4, udim2, fn67, fn68, fn69, activate, activateServer, namecall, charPivotTo, notify, fn70, fn71, fn72, fn73, fn74, fn75, fn76, fn77, fn78, fn79, fn80, fn81, fn82, tbl24, fn83, fn84, fn85, n10, circle, fn86, circle2, line, tbl25, tbl26, fn87, fn88, fn89, fn90, tbl27, fn91, tbl28, fn92, fn93, fn94, thread, v31, controls, fn95, fn96, fn97, fn98, fn99, cloneFunc0, cloneFunc1, cloneFunc2, cloneFunc3

	if hookmetamethod and newcclosure and getnamecallmethod then
		do
			local v32 = nil
			local function cloneFunc4(arg11, ...)
				local v33 = table.pack(...)
				local v34 = getnamecallmethod()
				if v34 == "Kick" and arg11 == localPlayer2 then return end
				local v35
				if v34 == "FireServer" and arg11.Name == "PlayerEvent" then
					local v36 = ({ ... })[1]
					if v36 == "char2" or v36 == "coreGame" or v36 == "vehicleTrack" or v36 == "platform" or v36 == "messageDeliver" or v36 == "runOverVictim" or v36 == "DEBUG2" or v36 == "chatCommand" or v36 == "controlsGuide" then
						return
					end
					if v34 == "InvokeServer" and arg11.Name == "PlayerFunc" then
						local tbl29 = { table.unpack(v33, 1, v33.n) }
						v35 = tbl29[1]
						local flag12 = v35 == "getPlayerData" or v35 == "getPlayerBanHistory"
						local flag13 = flag12 or v35 == "getPlayerInGame"
						local flag14 = flag13 or v35 == "getPlayerServerEncounters"
						local flag15 = flag14 or v35 == "getSecret"
						if flag15 then return true end
					end
				else
					if not (v34 == "InvokeServer" and arg11.Name == "PlayerFunc") then
						return v32(arg11, ...)
					end
					v35 = ({ ... })[1]
					if v35 == "getPlayerData" or v35 == "getPlayerBanHistory" or v35 == "getPlayerInGame" or v35 == "getPlayerServerEncounters" or v35 == "getSecret" then
						return true
					end
				end
				return v32(arg11, table.unpack(v33, 1, v33.n))
			end
			v32 = hookmetamethod
			v32 = v32(game, "__namecall", newcclosure(cloneFunc4))
		end

		Players = game:GetService("Players")
		ReplicatedStorage = game:GetService("ReplicatedStorage")
		RunService = game:GetService("RunService")
		UserInputService = game:GetService("UserInputService")
		GuiService = game:GetService("GuiService")
		ContextActionService = game:GetService("ContextActionService")
		HttpService = game:GetService("HttpService")
		Workspace = game:GetService("Workspace")
		localPlayer3 = Players.LocalPlayer

		if not localPlayer3 then
			signal = Players:GetPropertyChangedSignal("LocalPlayer")
			signal:Wait()
			localPlayer3 = Players.LocalPlayer
		end

		fn61 = function()
			local hui = nil
			pcall(function() if type(gethui) == "function" then hui = gethui() end end)
			if hui then return hui end
			pcall(function() hui = game:FindService("CoreGui") end)
			if hui then return hui end
			pcall(function() hui = localPlayer3:WaitForChild("PlayerGui", 5) end)
			if hui then return hui end
			pcall(function() hui = localPlayer3:FindFirstChild("PlayerGui") end)
			return hui
		end

		v29 = fn61()
		remote = ReplicatedStorage:WaitForChild("Remote", 30)
		playerEvent = remote and remote:WaitForChild("PlayerEvent", 30)
		playerFunc = remote and remote:WaitForChild("PlayerFunc", 30)

		tbl21 = {
			["红色"] = Color3.fromRGB(255, 0, 0),
			["黄色"] = Color3.fromRGB(255, 255, 0),
			["绿色"] = Color3.fromRGB(0, 255, 0),
			["蓝色"] = Color3.fromRGB(0, 150, 255),
			["紫色"] = Color3.fromRGB(150, 0, 255),
			["白色"] = Color3.fromRGB(255, 255, 255),
			["黑色"] = Color3.fromRGB(0, 0, 0),
			["青色"] = Color3.fromRGB(0, 255, 255),
			["橙色"] = Color3.fromRGB(255, 165, 0),
			["粉色"] = Color3.fromRGB(255, 105, 180),
		}

		fn38 = function(arg11)
			local n11 = arg11 or 5
			return Color3.fromHSV(tick() % n11 / n11, 1, 1)
		end

		fn39 = function(arg11)
			if arg11 == "彩虹色" or arg11 == "彩虹" or arg11 == "彩虹动态" then return fn38(5) end
			return tbl21[arg11] or Color3.fromRGB(255, 0, 0)
		end

		fn40 = function(arg11)
			arg11 = arg11 or localPlayer3
			local seen = {}
			local list = {}
			local function add(model)
				if model and typeof(model) == "Instance" and model:IsA("Model") and not seen[model] then
					seen[model] = true
					table.insert(list, model)
				end
			end
			pcall(function() add(arg11.Character) end)
			pcall(function()
				local cf = Workspace:FindFirstChild("Characters")
				if cf then add(cf:FindFirstChild(arg11.Name)) end
			end)
			for _, character in ipairs(list) do
				local humanoid = character:FindFirstChildOfClass("Humanoid") or character:FindFirstChild("Humanoid", true)
				local hrp = character:FindFirstChild("HumanoidRootPart")
					or character:FindFirstChild("Torso")
					or character:FindFirstChild("UpperTorso")
					or (humanoid and humanoid.RootPart)
				if not hrp then hrp = character.PrimaryPart or character:FindFirstChildWhichIsA("BasePart") end
				if hrp then return character, humanoid, hrp end
			end
		end

		fn62 = function(arg11)
			local _, v33 = fn40(arg11)
			return v33 ~= nil and v33.Health > 0
		end

		fn63 = function(arg11)
			return arg11 and arg11.Team and arg11.Team.Name or "Civilian"
		end

		fn64 = function()
			local v32, v33 = fn40(localPlayer3)
			if not v32 or not v33 then return end
			local tool = v32:FindFirstChildOfClass("Tool")
			if tool then return tool end
			local backpack = localPlayer3:FindFirstChild("Backpack")
			if not backpack then return end
			for _, child in ipairs(backpack:GetChildren()) do
				if child:IsA("Tool") then
					v33:EquipTool(child)
					task.wait(0.1)
					return v32:FindFirstChildOfClass("Tool")
				end
			end
		end

		local MOON_UI_URL = "https://sikon.226618.xyz/moon lua UI源码.lua"
		local okLib, loaded = pcall(function()
			return loadstring(game:HttpGet(MOON_UI_URL))()
		end)
		if not okLib or type(loaded) ~= "table" then
			warn("[xtal] MoonLua UI 加载失败: " .. tostring(loaded))
			return
		end
		lib = loaded
		print("[xtal] 库版本:", lib.Version)

		tbl8 = {
			randomBg = true,
			borderColor = nil,
			isBorderRainbow = true,
			borderEnabled = false,
		}

		fn65 = function()
			local ok, result = pcall(function() return readfile("xtal_Settings.txt") end)
			if ok and result then
				local ok2, result2 = pcall(function() return HttpService:JSONDecode(result) end)
				if ok2 and type(result2) == "table" then
					for k2, v32 in pairs(result2) do tbl8[k2] = v32 end
				end
			end
		end

		fn41 = function()
			pcall(function() writefile("xtal_Settings.txt", HttpService:JSONEncode(tbl8)) end)
		end

		tbl22 = {
			"https://raw.githubusercontent.com/XtalHub/assets/main/bg.jpg",
		}

		fn42 = function()
			if not tbl8.randomBg or #tbl22 == 0 then return "" end
			return tbl22[math.random(1, #tbl22)]
		end

		v27 = nil
		connection = nil
		connection2 = nil
		flag8 = false
		v28 = nil

		fn43 = function(color, arg11)
			-- 边框颜色设置（MoonLua 无直接支持，保留占位）
		end

		Settings = {
			stamina = false, food = false, combatBlock = false, ghost = false,
			noRagdoll = false, noFallDamage = false, antiPrisonPull = false,
			autoMoney = false, infiniteAmmo = false, rapidFire = false,
			farmer = false, taxi = false, bus = false, autoMission = false,
			autoHack = false, golf = false, autoCuff = false,
		}

		Character = nil
		Core = nil
		module = nil

		pcall(function()
			local framework = localPlayer3:WaitForChild("PlayerScripts", 15):WaitForChild("Framework", 15)
			Character = require(framework:WaitForChild("Character", 15))
			Core = require(framework:WaitForChild("Core", 15))
			local inventory = framework.Character:FindFirstChild("Inventory")
			if inventory then module = require(inventory) end
		end)

		fn66 = function()
			RunService.Heartbeat:Connect(function()
				if Core then
					if Settings.stamina then pcall(function() Core.stamina = 100 end) end
					if Settings.food then pcall(function() Core.food = 100 end) end
					if Settings.rapidFire then pcall(fn44) end
				end
				if Settings.infiniteAmmo then
					local characters = Workspace:FindFirstChild("Characters") and Workspace.Characters:FindFirstChild(localPlayer3.Name)
					if characters then
						for _, child in ipairs(characters:GetChildren()) do
							local config = child:FindFirstChild("Config")
							if config then
								local ammo = config:FindFirstChild("Ammo")
								local totalAmmo = config:FindFirstChild("TotalAmmo")
								if ammo then ammo.Value = math.huge end
								if totalAmmo then totalAmmo.Value = math.huge end
							end
						end
					end
				end
			end)
		end

		fn44 = function()
			if not Settings.rapidFire or not getgc then return end
			for _, v32 in pairs(getgc(true)) do
				if type(v32) == "table" then
					if rawget(v32, "SHOOT_MODE") ~= nil then rawset(v32, "SHOOT_MODE", 2) end
					if rawget(v32, "RPM") ~= nil then rawset(v32, "RPM", math.huge) end
				end
			end
		end

		v30 = nil
		fn45 = function(combatBlock)
			Settings.combatBlock = combatBlock
			if combatBlock and not v30 and hookmetamethod and newcclosure then
				v30 = hookmetamethod(game, "__namecall", newcclosure(function(arg11, ...)
					local v32 = table.pack(...)
					local tbl29 = { ... }
					local v33 = getnamecallmethod()
					if Settings.combatBlock and v33 == "FireServer" and tbl29[1] == "combatMode" then return nil end
					return v30(arg11, table.unpack(v32, 1, v32.n))
				end))
			end
		end

		tbl23 = {}
		connection3 = nil
		screenGui = nil
		textButton = nil
		connection4 = nil
		flag9 = false
		flag10 = false
		udim2 = UDim2.new(0, 100, 0.5, -25)

		fn67 = function()
			for _, v32 in ipairs(tbl23) do pcall(function() v32:Disconnect() end) end
			tbl23 = {}
		end

		fn68 = function(arg11, arg12)
			if not arg11 then return end
			pcall(function()
				arg11:SetAttribute("Invisible", arg12 or nil)
				for _, descendant in ipairs(arg11:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
						descendant.LocalTransparencyModifier = arg12 and 0.55 or 0
						descendant.Material = arg12 and Enum.Material.ForceField or Enum.Material.SmoothPlastic
					elseif descendant:IsA("Decal") and descendant.Name == "face" then
						descendant.Transparency = arg12 and 0.55 or 0
					end
				end
			end)
		end

		fn69 = function()
			if not textButton then return end
			textButton.Text = Settings.ghost and "隐身: 开" or "隐身: 关"
			textButton.TextColor3 = Settings.ghost and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
		end

		fn46 = function(ghost)
			Settings.ghost = ghost
			local character = localPlayer3.Character
			if not character then return end
			if ghost then
				pcall(function()
					local stuff = ReplicatedStorage:FindFirstChild("Stuff")
					local locations = stuff and stuff:FindFirstChild("Locations")
					locations = locations and locations:GetChildren()[1] or nil
					if playerFunc then playerFunc:InvokeServer("hideCharacterLocation", locations) end
				end)
				if module and module.canEquipSlot then pcall(function() module.canEquipSlot(true) end) end
				if Character and Character.lockHumanoidState then pcall(function() Character.lockHumanoidState("ghostMode", nil) end) end
				pcall(function()
					GuiService.TouchControlsEnabled = true
					ContextActionService:UnbindAction("LoadingGuiNoResetOnDeath")
					ContextActionService:UnbindAction("DisableCameraMovementNoResetOnDeath")
				end)
				if connection3 then connection3:Disconnect() end
				connection3 = RunService.RenderStepped:Connect(function()
					if Settings.ghost and localPlayer3.Character then end
				end)
			else
				if connection3 then connection3:Disconnect() connection3 = nil end
				pcall(function()
					if playerFunc then playerFunc:InvokeServer("hideCharacterLocation", false) end
				end)
			end
		end

		activate = nil
		activateServer = nil
		pcall(function()
			local Ragdoll = require(ReplicatedStorage.Modules.Ragdoll)
			activate = Ragdoll.activate
			activateServer = Ragdoll.activateServer
			Ragdoll.activate = function(arg11, arg12, arg13, ...)
				if Settings.noRagdoll and arg12 then return end
				local v32 = activate
				local v33 = table.pack(...)
				v33.n = 4 + v33.n - 1
				table.move(v33, 1, v33.n, 4, v33)
				v33[1] = arg11; v33[2] = arg12; v33[3] = arg13
				return v32(table.unpack(v33, 1, v33.n))
			end
			if activateServer then
				Ragdoll.activateServer = function(arg11, arg12, arg13, ...)
					if Settings.noRagdoll and arg12 then return end
					local v32 = activateServer
					local v33 = table.pack(...)
					v33.n = 4 + v33.n - 1
					table.move(v33, 1, v33.n, 4, v33)
					v33[1] = arg11; v33[2] = arg12; v33[3] = arg13
					return v32(table.unpack(v33, 1, v33.n))
				end
			end
		end)

		namecall = nil
		pcall(function()
			local v32 = getrawmetatable(game)
			namecall = v32.__namecall
			setreadonly(v32, false)
			v32.__namecall = newcclosure(function(arg11, ...)
				local v33 = table.pack(...)
				local tbl29 = { ... }
				local v34 = getnamecallmethod()
				if Settings.noFallDamage and v34 == "FireServer" and tostring(arg11) == "PlayerEvent" and tbl29[1] == "takeDamage" then return nil end
				return namecall(arg11, table.unpack(v33, 1, v33.n))
			end)
			setreadonly(v32, true)
		end)

		charPivotTo = nil
		notify = nil

		fn49 = function(antiPrisonPull)
			Settings.antiPrisonPull = antiPrisonPull
			pcall(function()
				local Algorithms = require(ReplicatedStorage.Modules.Algorithms)
				if antiPrisonPull and not charPivotTo then
					charPivotTo = Algorithms.charPivotTo
					Algorithms.charPivotTo = function() return nil end
				elseif not antiPrisonPull and charPivotTo then
					Algorithms.charPivotTo = charPivotTo
					charPivotTo = nil
				end
			end)
			pcall(function()
				if not Core then return end
				if antiPrisonPull and not notify then
					notify = Core.notify
					Core.notify = function(arg11)
						if arg11 and arg11.message and string.find(arg11.message, "You can't leave prison yet") then return nil end
						return notify(arg11)
					end
				elseif not antiPrisonPull and notify then
					Core.notify = notify
					notify = nil
				end
			end)
		end

		fn70 = function(arg11)
			if not arg11 or not arg11.Parent then return end
			local parent = arg11.Parent
			if parent:IsA("BasePart") then return parent.Position end
			if parent:IsA("Attachment") then return parent.WorldPosition end
			if parent:IsA("Model") then
				local primaryPart = parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
				if primaryPart then return primaryPart.Position end
			end
		end

		fn71 = function(arg11)
			if not arg11 then return end
			pcall(function()
				if fireproximityprompt then
					fireproximityprompt(arg11, 0)
				else
					arg11.HoldDuration = 0
					arg11:InputHoldBegin()
					task.wait(0.1)
					arg11:InputHoldEnd()
				end
			end)
		end

		fn72 = function(arg11)
			local v32, v33, v34 = fn40(localPlayer3)
			if not v32 or not v34 or not arg11 then return end
			local cframe = CFrame.new(arg11 + Vector3.new(0, 3, 0))
			v32:PivotTo(cframe)
			pcall(function()
				if playerEvent then
					local n11 = ((v32:GetAttribute("CharPivotToId") or 0) + 1) % 100
					v32:SetAttribute("CharPivotToId", n11)
					playerEvent:FireServer("charPivotTo", cframe, v32, n11)
				end
			end)
		end

		fn73 = function()
			task.spawn(function()
				while true do
					if Settings.autoMoney then
						local v32, v33, v34 = fn40(localPlayer3)
						if v34 then
							local v35 = nil
							local v36 = nil
							for _, descendant in ipairs(Workspace:GetDescendants()) do
								local isPP = descendant:IsA("ProximityPrompt")
								local flag12
								if isPP then
									local pn = descendant.Name
									local at = string.lower(tostring(descendant.ActionText or ""))
									local ot = string.lower(tostring(descendant.ObjectText or ""))
									flag12 = pn == "CashDrop" or pn == "GetItem" or pn == "Money"
										or at:find("pick", 1, true) or at:find("cash", 1, true) or at:find("collect", 1, true) or at:find("grab", 1, true)
										or ot:find("cash", 1, true) or ot:find("money", 1, true)
								else flag12 = isPP end
								if flag12 then
									local v37 = fn70(descendant)
									if v37 then
										local mag = (v34.Position - v37).Magnitude
										if not v35 or mag < v35 then v35 = mag v36 = descendant continue end
									end
								end
							end
							if v36 and v35 and v35 < 120 then
								if v35 > 8 then fn72(fn70(v36)) task.wait(0.3) end
								fn71(v36)
							end
						end
					end
					task.wait(0.3)
				end
			end)
		end

		tbl10 = { missionInterval = 2, priorityHighReward = false, taxiSafe = false, taxiDelayMode = "随机时间", taxiOrigin = nil }

		fn74 = function()
			if not getgc then return end
			for _, v32 in pairs(getgc(true)) do
				if type(v32) == "table" and rawget(v32, "teamJobs") then return v32.teamJobs end
			end
		end

		fn75 = function()
			if localPlayer3:GetAttribute("Mission") then return true end
			local v32 = fn74()
			if v32 then for _, v33 in pairs(v32) do if v33.joined then return true end end end
			return false
		end

		fn76 = function()
			local v32 = fn74()
			if not v32 then return end
			local n11 = -math.huge
			local v33 = nil
			for k2, v34 in pairs(v32) do
				if not v34.joined then
					if not tbl10.priorityHighReward then return k2 end
					local n12 = (v34.profitability or 1) * 1000000 + (v34.reward or 0)
					if n11 < n12 then n11 = n12 v33 = k2 end
				end
			end
			return v33
		end

		fn77 = function()
			task.spawn(function()
				while true do
					if Settings.autoMission and playerFunc and not fn75() then
						local v32 = fn76()
						if v32 then
							pcall(function() playerFunc:InvokeServer("talkToMission", tostring(v32) .. "join") end)
						end
					end
					task.wait(tbl10.missionInterval)
				end
			end)
		end

		fn79 = function()
			task.spawn(function()
				while true do
					if Settings.farmer then
						local v32 = localPlayer3.Character and localPlayer3.Character:FindFirstChildOfClass("Tool")
						if v32 then task.wait(0.4) end
						local v33, v34, v35 = fn40(localPlayer3)
						if v35 then
							local v36, v37 = nil, nil
							for _, descendant in ipairs(Workspace:GetDescendants()) do
								if descendant:IsA("ProximityPrompt") and descendant.ActionText == "Pick Up" then
									local v38 = fn70(descendant)
									if v38 then
										local mag = (v35.Position - v38).Magnitude
										if not v36 or mag < v36 then v36 = mag v37 = descendant continue end
									end
								end
							end
							if v37 then
								local pickPos = fn70(v37)
								if pickPos then
									local pickDist = (v35.Position - pickPos).Magnitude
									if pickDist > 8 then fn72(pickPos) task.wait(0.3) else fn71(v37) end
								end
							end
						end
					end
					task.wait(0.3)
				end
			end)
		end

		fn80 = function()
			task.spawn(function()
				local v32 = nil
				while true do
					if Settings.taxi then
						local gameplay = Workspace:FindFirstChild("Gameplay")
						gameplay = gameplay and gameplay:FindFirstChild("Entities")
						gameplay = gameplay and gameplay:FindFirstChild("ClientContent")
						if gameplay and gameplay:IsA("Model") then
							local pp = gameplay.PrimaryPart or gameplay:FindFirstChildWhichIsA("BasePart")
							local v33, v34, v35 = fn40(localPlayer3)
							if pp and v35 then
								local position = pp.Position
								if v32 == nil or (position - v32).Magnitude > 5 then
									if tbl10.taxiSafe and tbl10.taxiOrigin then
										v35.CFrame = CFrame.new(tbl10.taxiOrigin)
										local mag = (tbl10.taxiOrigin - position).Magnitude
										local n11
										if tbl10.taxiDelayMode == "距离测算" then
											n11 = math.clamp(15 + (math.clamp(mag, 2000, 6000) - 2000) / 4000 * 30 + math.random() * 2 - 1, 15, 45)
										else n11 = mag > 2000 and math.random(15, 45) or 15 end
										task.wait(n11)
									end
									v35.CFrame = CFrame.new(position)
									v32 = position
								end
							end
						end
					end
					task.wait(0.5)
				end
			end)
		end

		fn81 = function()
			local gameplay = Workspace:FindFirstChild("Gameplay")
			gameplay = gameplay and gameplay:FindFirstChild("Entities")
			gameplay = gameplay and gameplay:FindFirstChild("ClientContent")
			gameplay = gameplay and gameplay:GetChildren()[1]
			return gameplay and gameplay:FindFirstChild("Area")
		end

		fn82 = function()
			task.spawn(function()
				while true do
					if Settings.bus then
						local v32 = fn81()
						local v33, v34, v35 = fn40(localPlayer3)
						if v32 and v34 and v35 then
							local seatPart = v34.SeatPart
							if seatPart then
								local cFrame = v35.CFrame
								seatPart.CFrame = v32.CFrame * CFrame.new(17.5, 3, 6.5) * CFrame.Angles(0, 4.7123889803846897, 0) * cFrame:ToObjectSpace(seatPart.CFrame)
								seatPart.AssemblyLinearVelocity = Vector3.zero
								seatPart.AssemblyAngularVelocity = Vector3.zero
								task.wait(0.1)
								v34.Sit = false
							else
								v35.CFrame = v32.CFrame * CFrame.new(17.5, 3, 6.5) * CFrame.Angles(0, 4.7123889803846897, 0)
							end
							task.wait(5)
						end
					end
					task.wait(1)
				end
			end)
		end

		tbl24 = {}

		fn50 = function(autoHack)
			Settings.autoHack = autoHack
			pcall(function()
				local framework = localPlayer3.PlayerScripts:FindFirstChild("Framework")
				framework = framework and require(framework:FindFirstChild("Character"))
				local GameRules = require(ReplicatedStorage.Modules.GameRules)
				if GameRules then
					GameRules.disableHacking = autoHack
					GameRules.disableMinigames = autoHack
				end
				if framework then
					if not tbl24.hackingMinigame then tbl24.hackingMinigame = framework.hackingMinigame end
					if not tbl24.startMinigame then tbl24.startMinigame = framework.startMinigame end
					if autoHack then
						framework.hackingMinigame = function() return true end
						framework.startMinigame = function() return true end
					else
						if tbl24.hackingMinigame then framework.hackingMinigame = tbl24.hackingMinigame end
						if tbl24.startMinigame then framework.startMinigame = tbl24.startMinigame end
					end
				end
			end)
		end

		fn83 = function()
			task.spawn(function()
				local function findPath(list)
					local v32 = Workspace
					for _, v33 in ipairs(list) do
						v32 = v32 and v32:FindFirstChild(v33)
						if not v32 then return end
					end
					return v32
				end
				while true do
					if Settings.golf and playerFunc then
						pcall(function()
							playerFunc:InvokeServer("miniGolf", "createLobby")
							task.wait(0.1)
							playerFunc:InvokeServer("miniGolf", "setLobbyBid", { bid = 500 })
							task.wait(0.1)
							playerFunc:InvokeServer("miniGolf", "setLobbyReady")
							task.wait(4)
							playerFunc:InvokeServer("miniGolf", "shot")
							task.wait(0.5)
							local v32 = findPath({ "Gameplay", "Entities", "Content", localPlayer3.Name })
							local v33 = findPath({ "Gameplay", "Entities", "Content", "_Flag", "FlagPole", "Part" })
							if v32 and v33 and v32:IsA("BasePart") then v32.Position = v33.Position end
						end)
					end
					task.wait(Settings.golf and 5 or 1)
				end
			end)
		end

		tbl11 = {
			auraEnabled = false, auraRange = 50, auraDamage = 5, auraInterval = 0.05,
			auraOnlyPolice = false, auraOnlyCivilian = false, auraCombatCheck = false,
			bulletEnabled = false, bulletFov = 360, bulletDistance = 300,
			bulletPart = "Head", bulletShowFov = true, bulletColor = "红色",
			bulletCombatCheck = false, bulletOnlyPolice = false, bulletOnlyCivilian = false,
		}

		fn84 = function(arg11, arg12, arg13)
			if not arg11 or arg11 == localPlayer3 then return false end
			if arg12 then return arg11.Team and arg11.Team.Name == "Police" end
			if arg13 then return arg11.Team and arg11.Team.Name == "Civilian" end
			return true
		end

		fn85 = function(arg11, arg12)
			if not arg12 then return true end
			return arg11:GetAttribute("CombatMode") == true or arg11:GetAttribute("Pursuit") == true
		end

		n10 = 0

		RunService.Heartbeat:Connect(function()
			if not tbl11.auraEnabled or not playerEvent then return end
			local now = tick()
			if now - n10 < tbl11.auraInterval then return end
			local v32, v33, v34 = fn40(localPlayer3)
			if not v34 then return end
			local v35, v36 = nil, nil
			for _, player in ipairs(Players:GetPlayers()) do
				if fn84(player, tbl11.auraOnlyPolice, tbl11.auraOnlyCivilian) and fn62(player) and fn85(player, tbl11.auraCombatCheck) then
					local char = player.Character
					local v39 = char and fn87(char)
					if v39 then
						local mag = (v39.Position - v34.Position).Magnitude
						if mag <= tbl11.auraRange and (not v36 or mag < v36) then v35 = player v36 = mag end
					end
				end
			end
			if v35 then
				local targetChar = v35.Character
				local v39 = targetChar and fn87(targetChar)
				local position = v34.Position
				if not v39 then return end
				pcall(function()
					playerEvent:FireServer("damage", {
						bodyParts = { { "Head", 1 } },
						shotCode = { position, (v39.Position - position).Unit },
						pos = v39.Position,
						target = v35,
						damageFactor = tbl11.auraDamage,
						bulletProofTool = false,
					})
				end)
				n10 = now
			end
		end)

		circle = Drawing.new("Circle")
		circle.Filled = false
		circle.NumSides = 64
		circle.Visible = false

		fn86 = function()
			local cc = Workspace.CurrentCamera
			if not cc then return end
			local vector2 = Vector2.new(cc.ViewportSize.X / 2, cc.ViewportSize.Y / 2)
			local bulletFov = tbl11.bulletFov
			local position = nil
			for _, player in ipairs(Players:GetPlayers()) do
				if fn84(player, tbl11.bulletOnlyPolice, tbl11.bulletOnlyCivilian) and fn62(player) and fn85(player, tbl11.bulletCombatCheck) then
					local character = player.Character
					if character then character = character:FindFirstChild(tbl11.bulletPart) or character:FindFirstChild("HumanoidRootPart") end
					if character then
						if (character.Position - cc.CFrame.Position).Magnitude <= tbl11.bulletDistance then
							local v32, v33 = cc:WorldToScreenPoint(character.Position)
							if v33 and v32.Z > 0 then
								local mag = (Vector2.new(v32.X, v32.Y) - vector2).Magnitude
								if mag < bulletFov then position = character.Position bulletFov = mag end
							end
						end
					end
				end
			end
			return position
		end

		pcall(function()
			local raycast = Workspace.Raycast
			hookfunction(Workspace.Raycast, function(arg11, arg12, arg13, arg14)
				if tbl11.bulletEnabled and arg12 and arg13 then
					local _, _, v34 = fn40(localPlayer3)
					if v34 and (arg12 - v34.Position).Magnitude < 15 then
						local v35 = fn86()
						if v35 then arg13 = (v35 - arg12).Unit * arg13.Magnitude end
					end
				end
				return raycast(arg11, arg12, arg13, arg14)
			end)
		end)

		RunService.RenderStepped:Connect(function()
			local cc = Workspace.CurrentCamera
			if not cc then return end
			circle.Position = Vector2.new(cc.ViewportSize.X / 2, cc.ViewportSize.Y / 2)
			circle.Radius = tbl11.bulletFov
			circle.Thickness = 2
			circle.Color = fn38(5)
			circle.Visible = tbl11.bulletEnabled and tbl11.bulletShowFov
		end)

		tbl12 = {
			enabled = false, prediction = false, teamCheck = false, wallCheck = false,
			showFov = false, showCrosshair = false, showTracer = false, friendCheck = false,
			onlyPolice = false, onlyCivilian = false, combatCheck = false, fov = 50,
			smoothness = 1, targetMode = "准心最近", targetPart = "头",
			color = "红色", fovThickness = 2,
		}

		circle2 = Drawing.new("Circle")
		circle2.Filled = false
		circle2.NumSides = 64
		line = Drawing.new("Line")

		tbl25 = {
			Top = Drawing.new("Line"), Bottom = Drawing.new("Line"),
			Left = Drawing.new("Line"), Right = Drawing.new("Line"),
			Center = Drawing.new("Line"),
		}
		for _, v32 in pairs(tbl25) do v32.Thickness = 2 v32.Visible = false end

		tbl26 = {
			["头"] = { "Head" },
			["胸"] = { "UpperTorso", "Torso" },
			["左手"] = { "LeftHand", "Left Arm" },
			["右手"] = { "RightHand", "Right Arm" },
			["左腿"] = { "LeftFoot", "Left Leg" },
			["右腿"] = { "RightFoot", "Right Leg" },
		}

		fn87 = function(arg11)
			local v32 = ipairs
			local tbl29 = tbl26[tbl12.targetPart] or { "Head" }
			for _, v33 in v32(tbl29) do
				local v34 = arg11:FindFirstChild(v33)
				if v34 then return v34 end
			end
			return arg11:FindFirstChild("HumanoidRootPart")
		end

		fn88 = function(arg11)
			if not tbl12.wallCheck then return true end
			local cc = Workspace.CurrentCamera
			local rp = RaycastParams.new()
			rp.FilterDescendantsInstances = { localPlayer3.Character, cc }
			rp.FilterType = Enum.RaycastFilterType.Exclude
			rp.IgnoreWater = true
			local hit = Workspace:Raycast(cc.CFrame.Position, arg11.Position - cc.CFrame.Position, rp)
			return not hit or hit.Instance:IsDescendantOf(arg11.Parent)
		end

		fn89 = function()
			local cc = Workspace.CurrentCamera
			if not cc then return end
			local vector2 = Vector2.new(cc.ViewportSize.X / 2, cc.ViewportSize.Y / 2)
			local v32 = nil
			local tbl29 = nil
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= localPlayer3 and fn62(player) and fn84(player, tbl12.onlyPolice, tbl12.onlyCivilian) and fn85(player, tbl12.combatCheck) then
					if not (tbl12.teamCheck and localPlayer3.Team and player.Team == localPlayer3.Team) then
						if tbl12.friendCheck then
							local ok, result = pcall(function() return localPlayer3:IsFriendsWith(player.UserId) end)
							if ok and result then continue end
						end
						local character = player.Character
						if not character then continue end
						local v33 = fn87(character)
						local v34 = character:FindFirstChildOfClass("Humanoid")
						local v35 = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
						if v33 and v34 and v35 and v34.Health > 0 and fn88(v33) then
							local v36, v37 = cc:WorldToViewportPoint(v33.Position)
							if v37 then
								local mag = (Vector2.new(v36.X, v36.Y) - vector2).Magnitude
								if mag <= tbl12.fov then
									if tbl12.targetMode == "距离最近" then
										local _, _, v40 = fn40(localPlayer3)
										mag = v40 and (v40.Position - v35.Position).Magnitude or math.huge
									elseif tbl12.targetMode == "血量最低" then mag = v34.Health end
									if not v32 or mag < v32 then tbl29 = { player = player, part = v33, screen = v36 } v32 = mag end
								end
							end
						end
					end
				end
			end
			return tbl29
		end

		RunService.RenderStepped:Connect(function(deltaTime)
			local cc = Workspace.CurrentCamera
			if not cc then return end
			local vector2 = Vector2.new(cc.ViewportSize.X / 2, cc.ViewportSize.Y / 2)
			local v32 = fn39(tbl12.color)
			circle2.Position = vector2
			circle2.Radius = tbl12.fov
			circle2.Thickness = tbl12.fovThickness
			circle2.Color = v32
			circle2.Visible = tbl12.enabled and tbl12.showFov
			tbl25.Top.From = Vector2.new(vector2.X, vector2.Y - 5)
			tbl25.Top.To = Vector2.new(vector2.X, vector2.Y - 5 - 15)
			tbl25.Bottom.From = Vector2.new(vector2.X, vector2.Y + 5)
			tbl25.Bottom.To = Vector2.new(vector2.X, vector2.Y + 5 + 15)
			tbl25.Left.From = Vector2.new(vector2.X - 5, vector2.Y)
			tbl25.Left.To = Vector2.new(vector2.X - 5 - 15, vector2.Y)
			tbl25.Right.From = Vector2.new(vector2.X + 5, vector2.Y)
			tbl25.Right.To = Vector2.new(vector2.X + 5 + 15, vector2.Y)
			tbl25.Center.From = Vector2.new(vector2.X - 2, vector2.Y)
			tbl25.Center.To = Vector2.new(vector2.X + 2, vector2.Y)
			for _, v33 in pairs(tbl25) do v33.Color = v32 v33.Visible = tbl12.showCrosshair end
			line.Visible = false
			if tbl12.enabled then
				local v33 = fn89()
				if v33 then
					if tbl12.showTracer then
						line.From = vector2
						line.To = Vector2.new(v33.screen.X, v33.screen.Y)
						line.Color = v32
						line.Thickness = 2
						line.Transparency = 0.5
						line.Visible = true
					end
					local position = v33.part.Position
					if tbl12.prediction then position += v33.part.AssemblyLinearVelocity * deltaTime * 1.5 end
					local cframe = CFrame.new(cc.CFrame.Position, position)
					cc.CFrame = tbl12.smoothness >= 1 and cframe or cc.CFrame:Lerp(cframe, tbl12.smoothness)
				end
			end
		end)

		tbl13 = {
			enabled = false, range = 150, interval = 0.05, bodyPart = "Head",
			jobCheck = false, wallCheck = false, aliveCheck = false,
			combatCheck = false, policeLock = false, civilianLock = false, beam = false,
		}
		tbl14 = { ["头部"] = "Head", ["躯干"] = "Torso", ["左臂"] = "LeftArm", ["右臂"] = "RightArm", ["左腿"] = "LeftLeg", ["右腿"] = "RightLeg" }

		task.spawn(function()
			while true do
				if tbl13.enabled and playerEvent then
					local v32, v33, v34 = fn40(localPlayer3)
					if v34 then
						local position = v34.Position
						local v35 = fn63(localPlayer3)
						for _, player in ipairs(Players:GetPlayers()) do
							if player ~= localPlayer3 and fn84(player, tbl13.policeLock, tbl13.civilianLock) and fn85(player, tbl13.combatCheck) then
								local v36, v37, v38Part = fn40(player)
								local v38 = v36 and (v36:FindFirstChild(tbl13.bodyPart) or fn87(v36))
								if v36 and v37 and v38 and v37.Health > 0 then
									if tbl13.jobCheck and fn63(player) == v35 then continue end
									if (v38.Position - position).Magnitude <= tbl13.range then
										if tbl13.wallCheck then
											local rp = RaycastParams.new()
											rp.FilterDescendantsInstances = { localPlayer3.Character, Workspace.CurrentCamera }
											rp.FilterType = Enum.RaycastFilterType.Exclude
											local hit = Workspace:Raycast(Workspace.CurrentCamera.CFrame.Position, v38.Position - Workspace.CurrentCamera.CFrame.Position, rp)
											if hit and not hit.Instance:IsDescendantOf(v36) then continue end
										end
										pcall(function()
											playerEvent:FireServer("damage", {
												bodyParts = { { tbl13.bodyPart, 1 } },
												shotCode = { position, (v38.Position - position).Unit },
												pos = v38.Position,
												target = player,
												damageFactor = 1.5,
												bulletProofTool = false,
											})
										end)
										continue
									end
								end
							end
						end
					end
				end
				task.wait(tbl13.interval)
			end
		end)

		tbl15 = {
			active = false, size = 10, transparency = 0.7, teamCheck = false,
			color = "红色", material = "Neon", rainbow = false,
			checkCorpses = false, outline = false, collision = false,
			glow = false, pulse = false, affectNPC = false,
		}
		tbl27 = {}

		fn51 = function(arg11)
			arg11 = arg11 and arg11:FindFirstChild("HumanoidRootPart")
			if not arg11 then return end
			local v32 = tbl27[arg11]
			if v32 then
				arg11.Size = v32.Size
				arg11.Transparency = v32.Transparency
				arg11.Material = v32.Material
				arg11.CanCollide = v32.CanCollide
				arg11.Color = v32.Color
			end
			local h = arg11:FindFirstChild("Xtal_HitboxHighlight")
			if h then h:Destroy() end
			local l = arg11:FindFirstChild("Xtal_HitboxLight")
			if l then l:Destroy() end
		end

		fn91 = function(arg11)
			local hrp = arg11 and arg11:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			if not tbl27[hrp] then
				tbl27[hrp] = { Size = hrp.Size, Transparency = hrp.Transparency, Material = hrp.Material, CanCollide = hrp.CanCollide, Color = hrp.Color }
			end
			if not tbl15.active then return end
			local humanoid = arg11:FindFirstChildOfClass("Humanoid")
			if tbl15.checkCorpses and humanoid and humanoid.Health <= 0 then return end
			local size = tbl15.size
			if tbl15.pulse then size *= math.sin(tick() * 2) * 0.2 + 1 end
			hrp.Size = Vector3.new(size, size, size)
			hrp.Transparency = tbl15.transparency
			hrp.Material = Enum.Material[tbl15.material] or Enum.Material.Neon
			hrp.CanCollide = tbl15.collision
			hrp.Color = tbl15.rainbow and fn38(5) or fn39(tbl15.color)
			if tbl15.outline then
				local h = hrp:FindFirstChild("Xtal_HitboxHighlight") or Instance.new("Highlight")
				h.Name = "Xtal_HitboxHighlight"
				h.FillTransparency = 1
				h.OutlineColor = hrp.Color
				h.OutlineTransparency = tbl15.transparency
				h.Parent = hrp
			else
				local h = hrp:FindFirstChild("Xtal_HitboxHighlight")
				if h then h:Destroy() end
			end
			if tbl15.glow then
				local l = hrp:FindFirstChild("Xtal_HitboxLight") or Instance.new("PointLight")
				l.Name = "Xtal_HitboxLight"
				l.Brightness = 5
				l.Range = 15
				l.Color = hrp.Color
				l.Parent = hrp
			else
				local l = hrp:FindFirstChild("Xtal_HitboxLight")
				if l then l:Destroy() end
			end
		end

		RunService.Heartbeat:Connect(function()
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= localPlayer3 and fn40(player) then
					if tbl15.teamCheck and localPlayer3.Team and player.Team == localPlayer3.Team then continue end
					fn91(fn40(player))
				end
			end
			if tbl15.affectNPC then
				for _, descendant in ipairs(Workspace:GetDescendants()) do
					if descendant:IsA("Model") and descendant:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(descendant) then
						fn91(descendant)
					end
				end
			end
		end)

		tbl16 = {
			enabled = false, name = true, distance = true, health = true, highlight = true,
			tracer = false, tracerOrigin = "屏幕底部", showFugitive = true,
			selectedTeams = {
				Chef = true, Civilian = true, Delivery = true, Farmer = true,
				Fire = true, Police = true, Medical = true, Prisoner = true,
				["Road Service"] = true, Transit = true,
			},
			trackers = {},
		}
		tbl17 = {
			Chef = "厨师", Civilian = "平民", Delivery = "配送员", Farmer = "农民",
			Fire = "消防员", Police = "警察", Medical = "医护人员", Prisoner = "囚犯",
			["Road Service"] = "道路服务", Transit = "交通",
		}
		tbl28 = {
			Chef = Color3.fromRGB(255, 200, 0), Civilian = Color3.fromRGB(100, 200, 255),
			Delivery = Color3.fromRGB(255, 150, 50), Farmer = Color3.fromRGB(50, 200, 50),
			Fire = Color3.fromRGB(255, 50, 50), Police = Color3.fromRGB(50, 100, 255),
			Medical = Color3.fromRGB(255, 50, 255), Prisoner = Color3.fromRGB(255, 150, 150),
			["Road Service"] = Color3.fromRGB(255, 255, 100), Transit = Color3.fromRGB(100, 255, 255),
		}

		fn92 = function(arg11)
			local flag12 = arg11.Team and arg11.Team.Name == "Civilian"
			local attribute
			if flag12 then attribute = arg11:GetAttribute("CombatMode") or arg11:GetAttribute("Pursuit")
			else attribute = flag12 end
			return attribute
		end

		fn93 = function(arg11)
			if not tbl16.enabled or arg11 == localPlayer3 then return false end
			if not fn40(arg11) then return false end
			if tbl16.showFugitive and fn92(arg11) then return true end
			local sc, tc = 0, 0
			for _, selected in pairs(tbl16.selectedTeams) do tc += 1 if selected then sc += 1 end end
			if sc == 0 or sc >= tc then return true end
			local name = arg11.Team and arg11.Team.Name
			if not name then return true end
			if tbl16.selectedTeams[name] == true then return true end
			for tn, tl in pairs(tbl17) do
				if (tl == name or tn == name) and tbl16.selectedTeams[tn] then return true end
			end
			return false
		end

		fn52 = function(player)
			local v32 = tbl16.trackers[player]
			if not v32 then return end
			for _, v33 in pairs(v32) do
				pcall(function()
					if typeof(v33) == "RBXScriptConnection" then v33:Disconnect()
					elseif typeof(v33) == "Instance" then v33:Destroy()
					elseif type(v33) == "userdata" and v33.Remove then v33:Remove() end
				end)
			end
			tbl16.trackers[player] = nil
		end

		local function getEspHolder()
			local parent = v29 or fn61() or localPlayer3:FindFirstChild("PlayerGui")
			v29 = parent
			if not parent then return end
			local holder = parent:FindFirstChild("xtalESP")
			if holder then return holder end
			local ok, gui = pcall(function()
				local sg = Instance.new("ScreenGui")
				sg.Name = "xtalESP"
				sg.ResetOnSpawn = false
				sg.IgnoreGuiInset = true
				sg.DisplayOrder = 999
				sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				sg.Parent = parent
				return sg
			end)
			if ok then return gui end
			return parent
		end

		fn94 = function(arg11)
			if tbl16.trackers[arg11] or not fn93(arg11) then return end
			local character, _, hrp = fn40(arg11)
			if not character or not hrp then return end
			local holder = getEspHolder()
			if not holder then return end
			local bb = Instance.new("BillboardGui")
			bb.Name = "PlayerESP_" .. arg11.Name
			bb.AlwaysOnTop = true
			bb.Size = UDim2.new(8, 0, 3, 0)
			bb.StudsOffset = Vector3.new(0, 3.5, 0)
			bb.MaxDistance = 10000
			bb.Adornee = hrp
			bb.Parent = holder
			local frame = Instance.new("Frame")
			frame.BackgroundTransparency = 1
			frame.Size = UDim2.fromScale(1, 1)
			frame.Parent = bb
			local tl = Instance.new("TextLabel")
			tl.Size = UDim2.new(1, 0, 0.55, 0)
			tl.BackgroundTransparency = 1
			tl.Font = Enum.Font.GothamBold
			tl.TextSize = 16
			tl.TextStrokeTransparency = 0
			tl.Text = arg11.Name
			tl.TextColor3 = Color3.fromRGB(0, 255, 0)
			tl.Parent = frame
			local tl2 = Instance.new("TextLabel")
			tl2.Size = UDim2.new(1, 0, 0.45, 0)
			tl2.Position = UDim2.new(0, 0, 0.55, 0)
			tl2.BackgroundTransparency = 1
			tl2.Font = Enum.Font.Gotham
			tl2.TextSize = 14
			tl2.TextStrokeTransparency = 0
			tl2.TextColor3 = Color3.fromRGB(0, 255, 0)
			tl2.Parent = frame
			local hl = Instance.new("Highlight")
			hl.Name = "PlayerESP_Highlight"
			hl.Adornee = character
			hl.FillTransparency = 0.65
			hl.OutlineTransparency = 0
			pcall(function() hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end)
			hl.Parent = character
			pcall(function() bb.Parent = hrp end)
			if not bb.Parent then bb.Parent = holder end
			local line2
			pcall(function()
				if Drawing and Drawing.new then
					line2 = Drawing.new("Line")
					line2.Thickness = 1
					line2.Transparency = 0.5
					line2.Visible = false
				end
			end)
			tbl16.trackers[arg11] = {
				bill = bb,
				highlight = hl,
				tracer = line2,
				update = RunService.Heartbeat:Connect(function()
					local cc2, th, cr = fn40(arg11)
					if not fn93(arg11) or not cc2 or not cr then
						if line2 then line2.Visible = false end
						if bb.Parent then bb.Enabled = false end
						return
					end
					hrp = cr
					bb.Adornee = hrp
					bb.Enabled = true
					if hl.Parent ~= cc2 then hl.Parent = cc2 end
					hl.Adornee = cc2
					local sf = fn92(arg11)
					local name = arg11.Team and arg11.Team.Name
					local color = sf and Color3.fromRGB(255, 0, 0) or tbl28[name] or Color3.fromRGB(0, 255, 0)
					tl.Text = "[" .. (sf and "逃犯" or tbl17[name] or name or "未知") .. "] " .. arg11.Name
					tl.TextColor3 = color
					tl.Visible = tbl16.name
					hl.FillColor = color
					hl.OutlineColor = color
					hl.Enabled = tbl16.highlight
					local _, _, v38 = fn40(localPlayer3)
					local tbl29 = {}
					if tbl16.distance and v38 then table.insert(tbl29, string.format("%.1f", (v38.Position - hrp.Position).Magnitude)) end
					if tbl16.health and th then table.insert(tbl29, tostring(math.floor(th.Health))) end
					tl2.Text = #tbl29 > 0 and "[" .. table.concat(tbl29, "/") .. "]" or ""
					tl2.TextColor3 = color
					tl2.Visible = tbl16.distance or tbl16.health
					local cc = Workspace.CurrentCamera
					if line2 then
						if tbl16.tracer and cc then
							local v39, v40 = cc:WorldToViewportPoint(hrp.Position)
							if v40 then
								local vs = cc.ViewportSize
								if tbl16.tracerOrigin == "屏幕中心" then line2.From = Vector2.new(vs.X / 2, vs.Y / 2)
								elseif tbl16.tracerOrigin == "屏幕顶部" then line2.From = Vector2.new(vs.X / 2, 0)
								else line2.From = Vector2.new(vs.X / 2, vs.Y) end
								line2.To = Vector2.new(v39.X, v39.Y)
								line2.Color = color
								line2.Visible = true
							else line2.Visible = false end
						else line2.Visible = false end
					end
				end),
			}
		end

		fn53 = function()
			for k2 in pairs(tbl16.trackers) do
				if not fn93(k2) then fn52(k2) end
			end
			if tbl16.enabled then
				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= localPlayer3 and fn93(player) and not tbl16.trackers[player] then
						pcall(fn94, player)
					end
				end
			end
		end

		local function hookEspPlayer(player)
			if player == localPlayer3 then return end
			player.CharacterAdded:Connect(function()
				task.wait(0.25)
				if tbl16.enabled then
					fn52(player)
					pcall(fn94, player)
				end
			end)
		end
		for _, player in ipairs(Players:GetPlayers()) do hookEspPlayer(player) end
		Players.PlayerAdded:Connect(hookEspPlayer)
		Players.PlayerRemoving:Connect(fn52)

		local lastEspScan = 0
		RunService.Heartbeat:Connect(function()
			if not tbl16.enabled then return end
			if tick() - lastEspScan < 0.2 then return end
			lastEspScan = tick()
			fn53()
		end)

		PoliceSettings = { range = 200, delay = 0.5, combatCheck = false, teleport = false }
		thread = nil

		fn54 = function()
			if thread then return end
			thread = task.spawn(function()
				while Settings.autoCuff do
					local v32, v33, v34 = fn40(localPlayer3)
					if v34 and playerFunc then
						for _, player in ipairs(Players:GetPlayers()) do
							if player ~= localPlayer3 and fn62(player) and fn85(player, PoliceSettings.combatCheck) then
								local _, _, v37 = fn40(player)
								if v37 and (v37.Position - v34.Position).Magnitude <= PoliceSettings.range then
									pcall(function() playerFunc:InvokeServer("handcuff", player, false) end)
								end
							end
						end
						if PoliceSettings.teleport then
							local v35, v36 = nil, nil
							for _, player in ipairs(Players:GetPlayers()) do
								local flag12 = player ~= localPlayer3 and player.Team and player.Team.Name == "Civilian"
								if flag12 then flag12 = (player:GetAttribute("WantedLevel") or 0) > 0 end
								if flag12 then
									local _, _, v39 = fn40(player)
									if v39 then
										local mag = (v39.Position - v34.Position).Magnitude
										if mag <= PoliceSettings.range and (not v35 or mag < v35) then v35 = mag v36 = player end
									end
								end
							end
							if v36 then
								local _, _, v39 = fn40(v36)
								if v39 then v34.CFrame = CFrame.new(v39.Position - v39.CFrame.LookVector * 3) end
							end
						end
					end
					task.wait(PoliceSettings.delay)
				end
				thread = nil
			end)
		end

		MovementSettings = {
			walkEnabled = false, walkSpeed = 200, jumpEnabled = false,
			jumpPower = 50, jumpMultiplier = 1, infiniteJump = false,
			flyEnabled = false, flySpeed = 30, flyMode = "传送", noclip = false,
		}

		FlyState = {
			walkConn = nil, jumpConn = nil, flyConn = nil,
			bodyVelocity = nil, bodyGyro = nil, noclipConn = nil, collisionCache = {},
		}

		v31 = nil
		controls = nil
		pcall(function()
			controls = require(localPlayer3.PlayerScripts:WaitForChild("PlayerModule")):GetControls()
		end)

		fn95 = function() if FlyState.walkConn then FlyState.walkConn:Disconnect() FlyState.walkConn = nil end end
		fn60 = function()
			fn95()
			if not MovementSettings.walkEnabled then return end
			FlyState.walkConn = RunService.Heartbeat:Connect(function()
				local _, v33 = fn40(localPlayer3)
				if v33 and MovementSettings.walkEnabled then v33.WalkSpeed = MovementSettings.walkSpeed end
			end)
		end
		fn96 = function(arg11)
			if not arg11 then return false end
			local state = arg11:GetState()
			return state == Enum.HumanoidStateType.Landed or state == Enum.HumanoidStateType.Running or state == Enum.HumanoidStateType.RunningNoPhysics
		end
		fn55 = function() if FlyState.jumpConn then FlyState.jumpConn:Disconnect() FlyState.jumpConn = nil end end
		fn56 = function()
			fn55()
			if not MovementSettings.jumpEnabled then return end
			FlyState.jumpConn = UserInputService.JumpRequest:Connect(function()
				if not MovementSettings.jumpEnabled then return end
				local v32, v33, v34 = fn40(localPlayer3)
				if not v33 or not v34 or v33.Health <= 0 then return end
				if not MovementSettings.infiniteJump and not fn96(v33) then return end
				v34.CFrame = v34.CFrame + Vector3.new(0, MovementSettings.jumpPower * MovementSettings.jumpMultiplier * 0.1, 0)
			end)
		end

		fn97 = function()
			if FlyState.flyConn then FlyState.flyConn:Disconnect() FlyState.flyConn = nil end
			if FlyState.bodyVelocity then FlyState.bodyVelocity:Destroy() FlyState.bodyVelocity = nil end
			if FlyState.bodyGyro then FlyState.bodyGyro:Destroy() FlyState.bodyGyro = nil end
			local _, v33 = fn40(localPlayer3)
			if v33 then v33.PlatformStand = false v33.AutoRotate = true end
		end

		cloneFunc0 = function()
			local v32, v33, v34 = fn40(localPlayer3)
			if not v34 or not v33 then return end
			MovementSettings.flyEnabled = true
			v33.AutoRotate = false
			FlyState.flyConn = RunService.RenderStepped:Connect(function(dt)
				if not MovementSettings.flyEnabled or MovementSettings.flyMode ~= "传送" then return end
				local v35, v36, v37 = fn40(localPlayer3)
				local cc = Workspace.CurrentCamera
				if not v37 or not v36 or not cc then return end
				local mv = controls and controls:GetMoveVector() or Vector3.zero
				local n11 = cc.CFrame.LookVector * -mv.Z + cc.CFrame.RightVector * mv.X
				local n12
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then n12 = 1
				else n12 = 0 if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then n12 = -1 end end
				v37.CFrame = v37.CFrame + (n11 + Vector3.new(0, n12, 0)) * MovementSettings.flySpeed * dt
				v37.AssemblyLinearVelocity = Vector3.zero
				v37.AssemblyAngularVelocity = Vector3.zero
				v36:ChangeState(Enum.HumanoidStateType.Climbing)
			end)
		end

		cloneFunc1 = function()
			local v32, v33, v34 = fn40(localPlayer3)
			if not v34 or not v33 then return end
			MovementSettings.flyEnabled = true
			local bv = Instance.new("BodyVelocity")
			bv.Name = "xtalFlyVelocity"
			bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
			bv.Velocity = Vector3.zero
			bv.Parent = v34
			FlyState.bodyVelocity = bv
			local bg = Instance.new("BodyGyro")
			bg.Name = "xtalFlyGyro"
			bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
			bg.P = 90000
			bg.Parent = v34
			FlyState.bodyGyro = bg
			v33.PlatformStand = true
			v33.AutoRotate = false
			FlyState.flyConn = RunService.RenderStepped:Connect(function()
				if not MovementSettings.flyEnabled or MovementSettings.flyMode ~= "物理" then return end
				local v35, v36, v37 = fn40(localPlayer3)
				local cc = Workspace.CurrentCamera
				if not v37 or not v36 or not cc then return end
				if FlyState.bodyVelocity and FlyState.bodyGyro then
					local mv = controls and controls:GetMoveVector() or Vector3.zero
					local n11 = cc.CFrame.LookVector * -mv.Z + cc.CFrame.RightVector * mv.X
					local n12
					if UserInputService:IsKeyDown(Enum.KeyCode.Space) then n12 = 1
					else n12 = 0 if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then n12 = -1 end end
					FlyState.bodyVelocity.Velocity = (n11 + Vector3.new(0, n12, 0)) * MovementSettings.flySpeed
					FlyState.bodyGyro.CFrame = cc.CFrame
				end
			end)
		end

		fn57 = function()
			if MovementSettings.flyMode == "物理" then cloneFunc1() else cloneFunc0() end
		end

		cloneFunc2 = function()
			for k2, v32 in pairs(FlyState.collisionCache) do
				if k2 and k2.Parent then pcall(function() k2.CanCollide = v32 end) end
			end
			FlyState.collisionCache = {}
		end

		cloneFunc3 = function()
			if FlyState.noclipConn then FlyState.noclipConn:Disconnect() FlyState.noclipConn = nil end
			cloneFunc2()
		end

		fn58 = function()
			cloneFunc3()
			if not MovementSettings.noclip then return end
			FlyState.noclipConn = RunService.Stepped:Connect(function()
				if not MovementSettings.noclip then return end
				local character = localPlayer3.Character
				if not character then return end
				for _, descendant in ipairs(character:GetDescendants()) do
					if descendant:IsA("BasePart") then
						if FlyState.collisionCache[descendant] == nil then FlyState.collisionCache[descendant] = descendant.CanCollide end
						descendant.CanCollide = false
					end
				end
			end)
		end

		localPlayer3.CharacterAdded:Connect(function()
			task.wait(0.5)
			FlyState.collisionCache = {}
			if MovementSettings.walkEnabled then fn60() end
			if MovementSettings.jumpEnabled then fn56() end
			if MovementSettings.noclip then fn58() end
			if MovementSettings.flyEnabled then
				local fm = MovementSettings.flyMode
				MovementSettings.flyEnabled = false
				task.wait(0.2)
				MovementSettings.flyMode = fm
				fn57()
			end
		end)

		pcall(fn66)
		pcall(fn73)
		pcall(fn77)
		pcall(fn79)
		pcall(fn80)
		pcall(fn82)
		pcall(fn83)

		flag11 = false
		getSpeedLimitAtPos = nil
		pcall(function()
			local Algorithms = require(ReplicatedStorage.Modules.Algorithms)
			getSpeedLimitAtPos = Algorithms.getSpeedLimitAtPos
			Algorithms.getSpeedLimitAtPos = function(...)
				if flag11 then return 9999 end
				return getSpeedLimitAtPos(...)
			end
		end)

		fn59 = function()
			if v27 then pcall(function() v27:Destroy() end) v27 = nil end

			v27 = lib:CreateWindow({
				Name              = "xtal",
				Title             = "xtal脚本 - 圣奥里",
				Version           = "V1",
				Theme             = "Nord",
				Backdrop          = true,
				ShowBackdrop      = true,
				GradientAnimation = true,
				ConfigFolder      = "xtal",
				SearchTab         = true,
				Visible           = true,
			})

			flag8 = true

			v27:Notify({
				Title    = "xtal",
				Content  = "欢迎 " .. localPlayer3.Name .. " 使用 xtal 脚本",
				Duration = 5,
			})

			local TabHome = v27:CreateTab("主页")
			local PageHome = TabHome:CreateModule("信息", "home", {})
			PageHome:CreateButton("Xtal_Hub 精简版 - xtal 汉化", function()
				v27:Notify({ Title = "xtal", Content = "圣奥里精简版 | Server ID: " .. game.PlaceId, Duration = 5 })
			end)

			local TabMain = v27:CreateTab("主要功能")
			local PageMain = TabMain:CreateModule("基础功能", "sliders", {})

			PageMain:CreateToggle("无限体力", false, function(v) Settings.stamina = v end)
			PageMain:CreateToggle("无限饥饿", false, function(v) Settings.food = v end)
			PageMain:CreateToggle("战斗拦截", false, function(v) fn45(v) end)
			PageMain:CreateToggle("隐身", false, function(v) fn46(v) end)
			PageMain:CreateToggle("防布娃娃", false, function(v) Settings.noRagdoll = v end)
			PageMain:CreateToggle("防摔伤", false, function(v) Settings.noFallDamage = v end)
			PageMain:CreateToggle("防越狱拉回", false, function(v) fn49(v) end)
			PageMain:CreateToggle("自动捡钱", false, function(v) Settings.autoMoney = v end)
			PageMain:CreateToggle("无限子弹", false, function(v) Settings.infiniteAmmo = v end)
			PageMain:CreateToggle("快速射击", false, function(v)
				Settings.rapidFire = v
				if v then fn44() end
			end)

			local TabMoney = v27:CreateTab("刷钱")
			local PageMoney = TabMoney:CreateModule("任务与经济", "money-bill-wave", {})

			PageMoney:CreateToggle("自动接取任务", false, function(v) Settings.autoMission = v end)
			PageMoney:CreateToggle("优先高收益任务", false, function(v) tbl10.priorityHighReward = v end)

			PageMoney:CreateInput({
				Name        = "接取间隔(秒)",
				Default     = "2",
				Placeholder = "输入间隔秒数",
				Callback    = function(v)
					local n = tonumber(v)
					if n and n > 0 then tbl10.missionInterval = n end
				end,
			})

			PageMoney:CreateToggle("安全模式(出租车)", false, function(v)
				tbl10.taxiSafe = v
				if v then
					local _, _, v44 = fn40(localPlayer3)
					if v44 then tbl10.taxiOrigin = v44.Position end
				end
			end)

			PageMoney:CreateSelector("出租车延迟模式", { "随机时间", "距离测算" }, "随机时间", function(v)
				tbl10.taxiDelayMode = v
			end)

			PageMoney:CreateToggle("出租车刷钱", false, function(v) Settings.taxi = v end)
			PageMoney:CreateToggle("公交车刷钱", false, function(v) Settings.bus = v end)
			PageMoney:CreateToggle("农民刷钱", false, function(v) Settings.farmer = v end)
			PageMoney:CreateToggle("自动黑客小游戏", false, function(v) fn50(v) end)
			PageMoney:CreateToggle("高尔夫刷钱", false, function(v) Settings.golf = v end)

			local TabCombat = v27:CreateTab("战斗")
			local PageCombat = TabCombat:CreateModule("杀戮光环", "crosshairs", {})

			PageCombat:CreateToggle("杀戮光环", false, function(v) tbl11.auraEnabled = v end)
			PageCombat:CreateToggle("只攻击警察", false, function(v)
				tbl11.auraOnlyPolice = v
				if v then tbl11.auraOnlyCivilian = false end
			end)
			PageCombat:CreateToggle("只攻击平民", false, function(v)
				tbl11.auraOnlyCivilian = v
				if v then tbl11.auraOnlyPolice = false end
			end)
			PageCombat:CreateToggle("战斗检测", false, function(v) tbl11.auraCombatCheck = v end)
			PageCombat:CreateSlider("攻击范围", 10, 500, 50, function(v) tbl11.auraRange = v end)
			PageCombat:CreateSlider("伤害倍率", 1, 100, 5, function(v) tbl11.auraDamage = v end)

			local TabAim = v27:CreateTab("自瞄")
			local PageAim = TabAim:CreateModule("自瞄设置", "crosshairs", {})

			PageAim:CreateToggle("开启/关闭自瞄", false, function(v) tbl12.enabled = v end)
			PageAim:CreateToggle("显示Fov圈", false, function(v) tbl12.showFov = v end)
			PageAim:CreateToggle("显示准心", false, function(v) tbl12.showCrosshair = v end)
			PageAim:CreateToggle("显示追踪线", false, function(v) tbl12.showTracer = v end)
			PageAim:CreateToggle("队伍检测", false, function(v) tbl12.teamCheck = v end)
			PageAim:CreateToggle("好友检测", false, function(v) tbl12.friendCheck = v end)
			PageAim:CreateToggle("墙壁检测", false, function(v) tbl12.wallCheck = v end)
			PageAim:CreateToggle("预判自瞄", false, function(v) tbl12.prediction = v end)
			PageAim:CreateToggle("只自瞄警察", false, function(v)
				tbl12.onlyPolice = v
				if v then tbl12.onlyCivilian = false end
			end)
			PageAim:CreateToggle("只自瞄平民", false, function(v)
				tbl12.onlyCivilian = v
				if v then tbl12.onlyPolice = false end
			end)
			PageAim:CreateToggle("战斗检测", false, function(v) tbl12.combatCheck = v end)

			PageAim:CreateSelector("优先锁定模式", { "准心最近", "距离最近", "血量最低" }, "准心最近", function(v) tbl12.targetMode = v end)
			PageAim:CreateSelector("瞄准身体部位", { "头", "胸", "左手", "右手", "左腿", "右腿" }, "头", function(v) tbl12.targetPart = v end)
			PageAim:CreateSlider("Fov圈大小", 1, 500, 50, function(v) tbl12.fov = v end)
			PageAim:CreateSlider("自瞄平滑度", 1, 10, 10, function(v) tbl12.smoothness = v / 10 end)
			PageAim:CreateSlider("Fov圈厚度", 1, 5, 2, function(v) tbl12.fovThickness = v end)
			PageAim:CreateSelector("颜色选择",
				{ "红色", "黄色", "绿色", "蓝色", "紫色", "白色", "黑色", "彩虹色" },
				"红色", function(v) tbl12.color = v end)

			local TabRage = v27:CreateTab("Ragebot")
			local PageRage = TabRage:CreateModule("Ragebot设置", "bot", {})

			PageRage:CreateToggle("Ragebot", false, function(v) tbl13.enabled = v end)
			PageRage:CreateSlider("攻击距离", 10, 500, 150, function(v) tbl13.range = v end)
			PageRage:CreateSlider("攻击间隔", 0.01, 1, 0.05, function(v) tbl13.interval = v end)
			PageRage:CreateSelector("攻击部位", { "头部", "躯干", "左臂", "右臂", "左腿", "右腿" }, "头部", function(v) tbl13.bodyPart = tbl14[v] or "Head" end)
			PageRage:CreateToggle("职业检测", false, function(v) tbl13.jobCheck = v end)
			PageRage:CreateToggle("墙壁检测", false, function(v) tbl13.wallCheck = v end)
			PageRage:CreateToggle("活体检测", false, function(v) tbl13.aliveCheck = v end)
			PageRage:CreateToggle("战斗状态检测", false, function(v) tbl13.combatCheck = v end)
			PageRage:CreateToggle("锁定警察", false, function(v)
				tbl13.policeLock = v
				if v then tbl13.civilianLock = false end
			end)
			PageRage:CreateToggle("锁定平民", false, function(v)
				tbl13.civilianLock = v
				if v then tbl13.policeLock = false end
			end)
			PageRage:CreateToggle("弹道显示", false, function(v) tbl13.beam = v end)

			local TabHitbox = v27:CreateTab("范围")
			local PageHitbox = TabHitbox:CreateModule("范围设置", "bullseye", {})

			PageHitbox:CreateToggle("开启/关闭范围", false, function(v)
				tbl15.active = v
				if not v then
					for _, player in ipairs(Players:GetPlayers()) do
						if player.Character then fn51(player.Character:FindFirstChild("HumanoidRootPart")) end
					end
				end
			end)

			PageHitbox:CreateInput({
				Name = "范围大小设置", Default = "10",
				Callback = function(v)
					local s = tonumber(v)
					if s and s > 0 then tbl15.size = s end
				end,
			})

			PageHitbox:CreateInput({
				Name = "范围透明度(0-1)", Default = "0.7",
				Callback = function(v)
					local t = tonumber(v)
					if t and t >= 0 and t <= 1 then tbl15.transparency = t end
				end,
			})

			PageHitbox:CreateSelector("选择范围颜色",
				{ "红色", "蓝色", "黄色", "绿色", "青色", "橙色", "紫色", "白色", "黑色", "彩虹色" },
				"红色", function(v)
					tbl15.color = v
					tbl15.rainbow = v == "彩虹色"
				end)

			PageHitbox:CreateSelector("选择范围材质",
				{ "Neon", "Plastic", "Wood", "Slate", "Concrete", "Metal", "SmoothPlastic" },
				"Neon", function(v) tbl15.material = v end)

			PageHitbox:CreateToggle("NPC范围", false, function(v) tbl15.affectNPC = v end)
			PageHitbox:CreateToggle("队伍检测", false, function(v) tbl15.teamCheck = v end)
			PageHitbox:CreateToggle("活体检测", false, function(v) tbl15.checkCorpses = v end)
			PageHitbox:CreateToggle("显示轮廓", false, function(v) tbl15.outline = v end)
			PageHitbox:CreateToggle("启用/禁用碰撞", false, function(v) tbl15.collision = v end)
			PageHitbox:CreateToggle("发光效果", false, function(v) tbl15.glow = v end)
			PageHitbox:CreateToggle("脉动效果", false, function(v) tbl15.pulse = v end)

			local TabPlayer = v27:CreateTab("玩家")
			local PagePlayer = TabPlayer:CreateModule("移动设置", "user", {})

			PagePlayer:CreateToggle("开启/关闭跳跃", false, function(v)
				MovementSettings.jumpEnabled = v
				if v then fn56() else fn55() end
			end)

			PagePlayer:CreateSlider("设置跳跃高度", 50, 400, 50, function(v) MovementSettings.jumpPower = v end)
			PagePlayer:CreateSlider("设置跳跃倍数", 1, 10, 1, function(v) MovementSettings.jumpMultiplier = v end)
			PagePlayer:CreateToggle("无限跳跃", false, function(v) MovementSettings.infiniteJump = v end)

			local TabPolice = v27:CreateTab("警察功能")
			local PagePolice = TabPolice:CreateModule("警察设置", "shield", {})

			PagePolice:CreateToggle("自动铐", false, function(v)
				Settings.autoCuff = v
				if v then fn54() end
			end)

			PagePolice:CreateToggle("自动传送", false, function(v) PoliceSettings.teleport = v end)
			PagePolice:CreateToggle("战斗检测", false, function(v) PoliceSettings.combatCheck = v end)
			PagePolice:CreateSlider("范围", 10, 500, 200, function(v) PoliceSettings.range = v end)
			PagePolice:CreateSlider("间隔", 0.1, 3, 0.5, function(v) PoliceSettings.delay = v end)

			local TabEsp = v27:CreateTab("ESP")
			local PageEsp = TabEsp:CreateModule("ESP设置", "eye", {})

			PageEsp:CreateToggle("玩家透视总开关", false, function(v)
				tbl16.enabled = v == true
				if not tbl16.enabled then
					for k2 in pairs(tbl16.trackers) do fn52(k2) end
				else pcall(fn53) end
			end)

			PageEsp:CreateToggle("显示名字", true, function(v) tbl16.name = v end)
			PageEsp:CreateToggle("显示距离", true, function(v) tbl16.distance = v end)
			PageEsp:CreateToggle("显示血量", true, function(v) tbl16.health = v end)
			PageEsp:CreateToggle("显示高亮", true, function(v) tbl16.highlight = v end)
			PageEsp:CreateToggle("显示追踪线", false, function(v) tbl16.tracer = v end)
			PageEsp:CreateSelector("追踪线起点", { "屏幕底部", "屏幕中心", "屏幕顶部" }, "屏幕底部", function(v) tbl16.tracerOrigin = v end)

			local teamToggles = {
				{ label = "逃犯", name = "Fugitive" },
				{ label = "厨师", name = "Chef" },
				{ label = "平民", name = "Civilian" },
				{ label = "配送员", name = "Delivery" },
				{ label = "农民", name = "Farmer" },
				{ label = "消防员", name = "Fire" },
				{ label = "警察", name = "Police" },
				{ label = "医护人员", name = "Medical" },
				{ label = "囚犯", name = "Prisoner" },
				{ label = "道路服务", name = "Road Service" },
				{ label = "交通", name = "Transit" },
			}
			for _, t in ipairs(teamToggles) do
				local isFugitive = t.name == "Fugitive"
				local default = isFugitive and tbl16.showFugitive or tbl16.selectedTeams[t.name]
				PageEsp:CreateToggle("透视 - " .. t.label, default == true, function(v)
					if isFugitive then
						tbl16.showFugitive = v
					else
						tbl16.selectedTeams[t.name] = v
					end
				end)
			end

			v27.OnClose = function() flag8 = false v27 = nil end
			v27.OnDestroy = function() flag8 = false v27 = nil end
		end
	end
	end
	end

	task.defer(function()
		pcall(function()
			if fn59 then fn59() end
		end)
	end)
end

if getgenv().xtalAutoRun ~= false then
	task.defer(function()
		local ok, err = pcall(XtalHubEntry, "", "", "", "", "", nil, {}, nil, nil, function() end,
			function(msg)
				local step = tostring(msg or "")
				return function()
					if step ~= "" then print("[xtal]", step) end
				end
			end,
			function() end)
		if not ok then warn("[xtal] 启动失败:", err) end
	end)
end

return XtalHubEntry
