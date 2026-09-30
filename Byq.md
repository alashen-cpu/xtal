local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local UserInputService=game:GetService("UserInputService")
local Stats=game:GetService("Stats")
local HttpService=game:GetService("HttpService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local TeleportService=game:GetService("TeleportService")
local Lighting=game:GetService("Lighting")
local Workspace=game:GetService("Workspace")
local LocalPlayer=Players.LocalPlayer
local PlayerGui=LocalPlayer:WaitForChild("PlayerGui")
local CW,CH=280,34
local EW,EH=560,380
local old=PlayerGui:FindFirstChild("xtalDynamicIsland")
if old then old:Destroy()end
local gui=Instance.new("ScreenGui")
gui.Name="xtalDynamicIsland"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.DisplayOrder=9999
gui.Parent=PlayerGui
local island=Instance.new("Frame")
island.AnchorPoint=Vector2.new(0.5,0)
island.Position=UDim2.new(0.5,0,0,12)
island.Size=UDim2.fromOffset(CW,CH)
island.BackgroundColor3=Color3.fromRGB(25,28,35)
island.BorderSizePixel=0
island.ClipsDescendants=true
island.ZIndex=100
island.Parent=gui
Instance.new("UICorner",island).CornerRadius=UDim.new(1,0)
local bgGrad=Instance.new("UIGradient")
bgGrad.Color=ColorSequence.new(Color3.fromRGB(25,28,35),Color3.fromRGB(15,16,20))
bgGrad.Rotation=90
bgGrad.Parent=island
local ov=Instance.new("Frame")
ov.Size=UDim2.new(1,0,1,0)
ov.BackgroundColor3=Color3.fromRGB(0,0,0)
ov.BackgroundTransparency=0.5
ov.BorderSizePixel=0
ov.ZIndex=101
ov.Parent=island
Instance.new("UICorner",ov).CornerRadius=UDim.new(1,0)
local compact=Instance.new("Frame")
compact.Size=UDim2.new(1,0,1,0)
compact.BackgroundTransparency=1
compact.ZIndex=105
compact.Parent=island
local dot=Instance.new("Frame")
dot.AnchorPoint=Vector2.new(0,0.5)
dot.Position=UDim2.new(0,14,0.5,0)
dot.Size=UDim2.new(0,7,0,7)
dot.BackgroundColor3=Color3.fromRGB(255,255,255)
dot.BorderSizePixel=0
dot.ZIndex=106
dot.Parent=compact
Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
local titleLabel=Instance.new("TextLabel")
titleLabel.BackgroundTransparency=1
titleLabel.Position=UDim2.new(0,28,0,0)
titleLabel.Size=UDim2.new(0,50,1,0)
titleLabel.Font=Enum.Font.GothamBold
titleLabel.Text="xtal"
titleLabel.TextColor3=Color3.fromRGB(255,255,255)
titleLabel.TextSize=13
titleLabel.TextXAlignment=Enum.TextXAlignment.Left
titleLabel.ZIndex=106
titleLabel.Parent=compact
local s1=Instance.new("TextLabel")
s1.BackgroundTransparency=1
s1.Position=UDim2.new(0,78,0,0)
s1.Size=UDim2.new(0,12,1,0)
s1.Font=Enum.Font.GothamBold
s1.Text="·"
s1.TextColor3=Color3.fromRGB(200,202,210)
s1.TextSize=14
s1.ZIndex=106
s1.Parent=compact
local fpsLabel=Instance.new("TextLabel")
fpsLabel.BackgroundTransparency=1
fpsLabel.Position=UDim2.new(0,90,0,0)
fpsLabel.Size=UDim2.new(0,80,1,0)
fpsLabel.Font=Enum.Font.GothamMedium
fpsLabel.Text="FPS: --"
fpsLabel.TextColor3=Color3.fromRGB(240,242,250)
fpsLabel.TextSize=12
fpsLabel.TextXAlignment=Enum.TextXAlignment.Left
fpsLabel.ZIndex=106
fpsLabel.Parent=compact
local s2=Instance.new("TextLabel")
s2.BackgroundTransparency=1
s2.Position=UDim2.new(0,178,0,0)
s2.Size=UDim2.new(0,12,1,0)
s2.Font=Enum.Font.GothamBold
s2.Text="·"
s2.TextColor3=Color3.fromRGB(200,202,210)
s2.TextSize=14
s2.ZIndex=106
s2.Parent=compact
local pingLabel=Instance.new("TextLabel")
pingLabel.BackgroundTransparency=1
pingLabel.Position=UDim2.new(0,190,0,0)
pingLabel.Size=UDim2.new(0,90,1,0)
pingLabel.Font=Enum.Font.GothamMedium
pingLabel.Text="Ping: --"
pingLabel.TextColor3=Color3.fromRGB(240,242,250)
pingLabel.TextSize=12
pingLabel.TextXAlignment=Enum.TextXAlignment.Left
pingLabel.ZIndex=106
pingLabel.Parent=compact
local panel=Instance.new("Frame")
panel.AnchorPoint=Vector2.new(0.5,0.5)
panel.Position=UDim2.new(0.5,0,0.5,0)
panel.Size=UDim2.fromOffset(EW,EH)
panel.BackgroundColor3=Color3.fromRGB(25,28,35)
panel.BorderSizePixel=0
panel.ClipsDescendants=true
panel.Visible=false
panel.ZIndex=50
panel.Parent=gui
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,14)
local pGrad=Instance.new("UIGradient")
pGrad.Color=ColorSequence.new(Color3.fromRGB(25,28,35),Color3.fromRGB(15,16,20))
pGrad.Rotation=90
pGrad.Parent=panel
local pOv=Instance.new("Frame")
pOv.Size=UDim2.new(1,0,1,0)
pOv.BackgroundColor3=Color3.fromRGB(0,0,0)
pOv.BackgroundTransparency=0.5
pOv.BorderSizePixel=0
pOv.ZIndex=51
pOv.Parent=panel
Instance.new("UICorner",pOv).CornerRadius=UDim.new(0,14)
local closeBtn=Instance.new("TextButton")
closeBtn.AnchorPoint=Vector2.new(1,0)
closeBtn.Position=UDim2.new(1,-12,0,12)
closeBtn.Size=UDim2.new(0,26,0,26)
closeBtn.BackgroundColor3=Color3.fromRGB(50,52,62)
closeBtn.BackgroundTransparency=0.3
closeBtn.BorderSizePixel=0
closeBtn.Font=Enum.Font.GothamBold
closeBtn.Text="×"
closeBtn.TextColor3=Color3.fromRGB(220,222,230)
closeBtn.TextSize=16
closeBtn.ZIndex=60
closeBtn.Parent=panel
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,8)
local mT=Instance.new("TextLabel")
mT.BackgroundTransparency=1
mT.Position=UDim2.new(0,20,0,12)
mT.Size=UDim2.new(0,200,0,22)
mT.Font=Enum.Font.GothamBold
mT.Text="xtal"
mT.TextColor3=Color3.fromRGB(255,255,255)
mT.TextSize=14
mT.TextXAlignment=Enum.TextXAlignment.Left
mT.ZIndex=60
mT.Parent=panel
local mS=Instance.new("TextLabel")
mS.BackgroundTransparency=1
mS.Position=UDim2.new(0,20,0,32)
mS.Size=UDim2.new(0,300,0,14)
mS.Font=Enum.Font.Gotham
mS.Text="xtal hub"
mS.TextColor3=Color3.fromRGB(150,152,162)
mS.TextSize=10
mS.TextXAlignment=Enum.TextXAlignment.Left
mS.ZIndex=60
mS.Parent=panel
local sidebar=Instance.new("Frame")
sidebar.Position=UDim2.new(0,12,0,54)
sidebar.Size=UDim2.new(0,150,1,-66)
sidebar.BackgroundColor3=Color3.fromRGB(25,27,34)
sidebar.BackgroundTransparency=0.35
sidebar.BorderSizePixel=0
sidebar.ZIndex=55
sidebar.Parent=panel
Instance.new("UICorner",sidebar).CornerRadius=UDim.new(0,10)
local tabScroll=Instance.new("ScrollingFrame")
tabScroll.Position=UDim2.new(0,6,0,8)
tabScroll.Size=UDim2.new(1,-12,1,-14)
tabScroll.BackgroundTransparency=1
tabScroll.BorderSizePixel=0
tabScroll.ScrollBarThickness=2
tabScroll.ScrollBarImageColor3=Color3.fromRGB(90,92,102)
tabScroll.CanvasSize=UDim2.new(0,0,0,0)
tabScroll.ZIndex=56
tabScroll.Parent=sidebar
local tabLay=Instance.new("UIListLayout")
tabLay.Padding=UDim.new(0,4)
tabLay.SortOrder=Enum.SortOrder.LayoutOrder
tabLay.Parent=tabScroll
tabLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
tabScroll.CanvasSize=UDim2.new(0,0,0,tabLay.AbsoluteContentSize.Y+6)
end)
local cArea=Instance.new("Frame")
cArea.Position=UDim2.new(0,170,0,54)
cArea.Size=UDim2.new(1,-182,1,-66)
cArea.BackgroundColor3=Color3.fromRGB(25,27,34)
cArea.BackgroundTransparency=0.35
cArea.BorderSizePixel=0
cArea.ZIndex=55
cArea.Parent=panel
Instance.new("UICorner",cArea).CornerRadius=UDim.new(0,10)
local cScroll=Instance.new("ScrollingFrame")
cScroll.Size=UDim2.new(1,0,1,0)
cScroll.BackgroundTransparency=1
cScroll.BorderSizePixel=0
cScroll.ScrollBarThickness=2
cScroll.ScrollBarImageColor3=Color3.fromRGB(90,92,102)
cScroll.CanvasSize=UDim2.new(0,0,0,0)
cScroll.ZIndex=56
cScroll.Parent=cArea
local cP=Instance.new("UIPadding",cScroll)
cP.PaddingTop=UDim.new(0,8)
cP.PaddingBottom=UDim.new(0,8)
cP.PaddingLeft=UDim.new(0,8)
cP.PaddingRight=UDim.new(0,8)
local cLay=Instance.new("UIListLayout")
cLay.Padding=UDim.new(0,5)
cLay.SortOrder=Enum.SortOrder.LayoutOrder
cLay.Parent=cScroll
cLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
cScroll.CanvasSize=UDim2.new(0,0,0,cLay.AbsoluteContentSize.Y+16)
end)
local Island={}
Island.Expanded=false
Island.Tabs={}
Island.CurrentTab=nil
function Island:Expand()
if self.Expanded then return end
self.Expanded=true
panel.Visible=true
panel.Size=UDim2.fromOffset(EW,10)
TweenService:Create(panel,TweenInfo.new(0.38,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(EW,EH)}):Play()
end
function Island:Collapse()
if not self.Expanded then return end
self.Expanded=false
local tw=TweenService:Create(panel,TweenInfo.new(0.32,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{Size=UDim2.fromOffset(EW,10)})
tw.Completed:Connect(function()if not self.Expanded then panel.Visible=false end end)
tw:Play()
end
function Island:Toggle()
if self.Expanded then self:Collapse()else self:Expand()end
end
function Island:AddTab(name)
local btn=Instance.new("TextButton")
btn.Size=UDim2.new(1,0,0,28)
btn.BackgroundColor3=Color3.fromRGB(45,48,58)
btn.BackgroundTransparency=0.3
btn.BorderSizePixel=0
btn.Font=Enum.Font.GothamMedium
btn.Text="  "..name
btn.TextColor3=Color3.fromRGB(220,222,230)
btn.TextSize=11
btn.TextXAlignment=Enum.TextXAlignment.Left
btn.ZIndex=57
btn.Parent=tabScroll
Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
local tab={name=name,btn=btn,items={}}
table.insert(self.Tabs,tab)
btn.MouseButton1Click:Connect(function()self:SelectTab(tab)end)
return tab
end
function Island:SelectTab(tab)
for _,t in ipairs(self.Tabs)do
t.btn.BackgroundColor3=Color3.fromRGB(45,48,58)
t.btn.BackgroundTransparency=0.3
end
tab.btn.BackgroundColor3=Color3.fromRGB(90,130,200)
tab.btn.BackgroundTransparency=0
self.CurrentTab=tab
self:RenderTab(tab)
end
function Island:RenderTab(tab)
for _,c in ipairs(cScroll:GetChildren())do
if c:IsA("Frame")or c:IsA("TextButton")then c:Destroy()end
end
for _,item in ipairs(tab.items)do
if item.type=="label"then
local row=Instance.new("Frame")
row.Size=UDim2.new(1,0,0,24)
row.BackgroundColor3=Color3.fromRGB(40,43,52)
row.BackgroundTransparency=0.25
row.BorderSizePixel=0
row.ZIndex=57
row.Parent=cScroll
Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)
local lb=Instance.new("TextLabel")
lb.BackgroundTransparency=1
lb.Position=UDim2.new(0,10,0,0)
lb.Size=UDim2.new(0.55,0,1,0)
lb.Font=Enum.Font.GothamMedium
lb.Text=item.name
lb.TextColor3=Color3.fromRGB(230,232,240)
lb.TextSize=11
lb.TextXAlignment=Enum.TextXAlignment.Left
lb.ZIndex=58
lb.Parent=row
local vl=Instance.new("TextLabel")
vl.AnchorPoint=Vector2.new(1,0.5)
vl.Position=UDim2.new(1,-10,0.5,0)
vl.Size=UDim2.new(0.45,0,1,0)
vl.BackgroundTransparency=1
vl.Font=Enum.Font.GothamMedium
vl.Text=tostring(item.text or "")
vl.TextColor3=Color3.fromRGB(160,200,255)
vl.TextSize=11
vl.TextXAlignment=Enum.TextXAlignment.Right
vl.ZIndex=58
vl.Parent=row
elseif item.type=="button"then
local row=Instance.new("TextButton")
row.Size=UDim2.new(1,0,0,28)
row.BackgroundColor3=Color3.fromRGB(40,43,52)
row.BackgroundTransparency=0.25
row.BorderSizePixel=0
row.Font=Enum.Font.GothamMedium
row.Text="  "..item.name
row.TextColor3=Color3.fromRGB(230,232,240)
row.TextSize=11
row.TextXAlignment=Enum.TextXAlignment.Left
row.ZIndex=57
row.Parent=cScroll
Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)
row.MouseButton1Click:Connect(function()if item.callback then pcall(item.callback)end end)
elseif item.type=="toggle"then
local row=Instance.new("Frame")
row.Size=UDim2.new(1,0,0,28)
row.BackgroundColor3=Color3.fromRGB(40,43,52)
row.BackgroundTransparency=0.25
row.BorderSizePixel=0
row.ZIndex=57
row.Parent=cScroll
Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)
local lb=Instance.new("TextLabel")
lb.BackgroundTransparency=1
lb.Position=UDim2.new(0,10,0,0)
lb.Size=UDim2.new(1,-60,1,0)
lb.Font=Enum.Font.GothamMedium
lb.Text=item.name
lb.TextColor3=Color3.fromRGB(230,232,240)
lb.TextSize=11
lb.TextXAlignment=Enum.TextXAlignment.Left
lb.ZIndex=58
lb.Parent=row
local tr=Instance.new("Frame")
tr.AnchorPoint=Vector2.new(1,0.5)
tr.Position=UDim2.new(1,-10,0.5,0)
tr.Size=UDim2.new(0,32,0,18)
tr.BackgroundColor3=item.value and Color3.fromRGB(90,130,200)or Color3.fromRGB(55,58,68)
tr.BorderSizePixel=0
tr.ZIndex=58
tr.Parent=row
Instance.new("UICorner",tr).CornerRadius=UDim.new(1,0)
local kn=Instance.new("Frame")
kn.AnchorPoint=Vector2.new(0,0.5)
kn.Position=item.value and UDim2.new(1,-16,0.5,0)or UDim2.new(0,2,0.5,0)
kn.Size=UDim2.new(0,14,0,14)
kn.BackgroundColor3=Color3.fromRGB(255,255,255)
kn.BorderSizePixel=0
kn.ZIndex=59
kn.Parent=tr
Instance.new("UICorner",kn).CornerRadius=UDim.new(1,0)
local state=item.value or false
local bb=Instance.new("TextButton")
bb.Size=UDim2.new(1,0,1,0)
bb.BackgroundTransparency=1
bb.Text=""
bb.ZIndex=60
bb.Parent=row
bb.MouseButton1Click:Connect(function()
state=not state
item.value=state
TweenService:Create(tr,TweenInfo.new(0.2,Enum.EasingStyle.Quart),{BackgroundColor3=state and Color3.fromRGB(90,130,200)or Color3.fromRGB(55,58,68)}):Play()
TweenService:Create(kn,TweenInfo.new(0.2,Enum.EasingStyle.Quart),{Position=state and UDim2.new(1,-16,0.5,0)or UDim2.new(0,2,0.5,0)}):Play()
if item.callback then pcall(item.callback,state)end
end)
elseif item.type=="input"then
local row=Instance.new("Frame")
row.Size=UDim2.new(1,0,0,30)
row.BackgroundColor3=Color3.fromRGB(40,43,52)
row.BackgroundTransparency=0.25
row.BorderSizePixel=0
row.ZIndex=57
row.Parent=cScroll
Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)
local pf=Instance.new("TextLabel")
pf.BackgroundTransparency=1
pf.Position=UDim2.new(0,10,0,0)
pf.Size=UDim2.new(0.5,-10,1,0)
pf.Font=Enum.Font.GothamMedium
pf.Text=item.name
pf.TextColor3=Color3.fromRGB(200,202,212)
pf.TextSize=11
pf.TextXAlignment=Enum.TextXAlignment.Left
pf.ZIndex=58
pf.Parent=row
local box=Instance.new("TextBox")
box.AnchorPoint=Vector2.new(1,0.5)
box.Position=UDim2.new(1,-10,0.5,0)
box.Size=UDim2.new(0,120,1,-6)
box.BackgroundColor3=Color3.fromRGB(30,32,40)
box.BackgroundTransparency=0.2
box.BorderSizePixel=0
box.Font=Enum.Font.GothamMedium
box.Text=tostring(item.value or "")
box.PlaceholderText=item.placeholder or "输入"
box.PlaceholderColor3=Color3.fromRGB(120,122,132)
box.TextColor3=Color3.fromRGB(230,232,240)
box.TextSize=11
box.TextXAlignment=Enum.TextXAlignment.Center
box.ClearTextOnFocus=false
box.ZIndex=58
box.Parent=row
Instance.new("UICorner",box).CornerRadius=UDim.new(0,5)
box.FocusLost:Connect(function()
item.value=box.Text
if item.callback then pcall(item.callback,box.Text)end
end)
elseif item.type=="dropdown"then
local row=Instance.new("TextButton")
row.Size=UDim2.new(1,0,0,30)
row.BackgroundColor3=Color3.fromRGB(40,43,52)
row.BackgroundTransparency=0.25
row.BorderSizePixel=0
row.Text=""
row.AutoButtonColor=false
row.ZIndex=57
row.Parent=cScroll
Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)
local lb=Instance.new("TextLabel")
lb.BackgroundTransparency=1
lb.Position=UDim2.new(0,10,0,0)
lb.Size=UDim2.new(0.5,-10,1,0)
lb.Font=Enum.Font.GothamMedium
lb.Text=item.name
lb.TextColor3=Color3.fromRGB(200,202,212)
lb.TextSize=11
lb.TextXAlignment=Enum.TextXAlignment.Left
lb.ZIndex=58
lb.Parent=row
local vl=Instance.new("TextLabel")
vl.AnchorPoint=Vector2.new(1,0.5)
vl.Position=UDim2.new(1,-25,0.5,0)
vl.Size=UDim2.new(0.5,-30,1,0)
vl.BackgroundTransparency=1
vl.Font=Enum.Font.GothamBold
vl.Text=tostring(item.value or "")
vl.TextColor3=Color3.fromRGB(160,200,255)
vl.TextSize=11
vl.TextXAlignment=Enum.TextXAlignment.Right
vl.ZIndex=58
vl.Parent=row
local ar=Instance.new("TextLabel")
ar.AnchorPoint=Vector2.new(1,0.5)
ar.Position=UDim2.new(1,-8,0.5,0)
ar.Size=UDim2.new(0,16,1,0)
ar.BackgroundTransparency=1
ar.Font=Enum.Font.GothamBold
ar.Text="▾"
ar.TextColor3=Color3.fromRGB(160,200,255)
ar.TextSize=13
ar.ZIndex=58
ar.Parent=row
local openFrame=nil
local function closeList()
if openFrame then openFrame:Destroy() openFrame=nil end
end
row.MouseButton1Click:Connect(function()
if openFrame then closeList() return end
openFrame=Instance.new("Frame")
openFrame.Position=UDim2.new(0,0,1,4)
openFrame.Size=UDim2.new(1,0,0,math.min(#item.values,6)*26+8)
openFrame.BackgroundColor3=Color3.fromRGB(30,32,40)
openFrame.BorderSizePixel=0
openFrame.ZIndex=200
openFrame.Parent=row
Instance.new("UICorner",openFrame).CornerRadius=UDim.new(0,8)
local lp=Instance.new("UIPadding",openFrame)
lp.PaddingTop=UDim.new(0,4)
lp.PaddingBottom=UDim.new(0,4)
lp.PaddingLeft=UDim.new(0,4)
lp.PaddingRight=UDim.new(0,4)
local ll=Instance.new("UIListLayout",openFrame)
ll.Padding=UDim.new(0,2)
for _,v in ipairs(item.values)do
local ob=Instance.new("TextButton")
ob.Size=UDim2.new(1,0,0,22)
ob.BackgroundColor3=v==item.value and Color3.fromRGB(90,130,200)or Color3.fromRGB(45,48,58)
ob.BackgroundTransparency=0.2
ob.BorderSizePixel=0
ob.Font=Enum.Font.GothamMedium
ob.Text="  "..tostring(v)
ob.TextColor3=Color3.fromRGB(230,232,240)
ob.TextSize=11
ob.TextXAlignment=Enum.TextXAlignment.Left
ob.ZIndex=201
ob.Parent=openFrame
Instance.new("UICorner",ob).CornerRadius=UDim.new(0,5)
ob.MouseButton1Click:Connect(function()
item.value=v
vl.Text=tostring(v)
closeList()
if item.callback then pcall(item.callback,v)end
end)
end
end)
elseif item.type=="slider"then
local row=Instance.new("Frame")
row.Size=UDim2.new(1,0,0,38)
row.BackgroundColor3=Color3.fromRGB(40,43,52)
row.BackgroundTransparency=0.25
row.BorderSizePixel=0
row.ZIndex=57
row.Parent=cScroll
Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)
local lb=Instance.new("TextLabel")
lb.BackgroundTransparency=1
lb.Position=UDim2.new(0,10,0,2)
lb.Size=UDim2.new(0.6,0,0,16)
lb.Font=Enum.Font.GothamMedium
lb.Text=item.name
lb.TextColor3=Color3.fromRGB(230,232,240)
lb.TextSize=11
lb.TextXAlignment=Enum.TextXAlignment.Left
lb.ZIndex=58
lb.Parent=row
local vl=Instance.new("TextLabel")
vl.AnchorPoint=Vector2.new(1,0)
vl.Position=UDim2.new(1,-10,0,2)
vl.Size=UDim2.new(0.35,0,0,16)
vl.BackgroundTransparency=1
vl.Font=Enum.Font.GothamBold
vl.Text=tostring(item.value or item.min or 0)
vl.TextColor3=Color3.fromRGB(160,200,255)
vl.TextSize=11
vl.TextXAlignment=Enum.TextXAlignment.Right
vl.ZIndex=58
vl.Parent=row
local tb=Instance.new("Frame")
tb.Position=UDim2.new(0,10,0,26)
tb.Size=UDim2.new(1,-20,0,5)
tb.BackgroundColor3=Color3.fromRGB(55,58,68)
tb.BorderSizePixel=0
tb.ZIndex=57
tb.Parent=row
Instance.new("UICorner",tb).CornerRadius=UDim.new(1,0)
local minV=item.min or 0
local maxV=item.max or 100
local curV=item.value or minV
local fl=Instance.new("Frame")
fl.Size=UDim2.new((curV-minV)/(maxV-minV),0,1,0)
fl.BackgroundColor3=Color3.fromRGB(90,130,200)
fl.BorderSizePixel=0
fl.ZIndex=58
fl.Parent=tb
Instance.new("UICorner",fl).CornerRadius=UDim.new(1,0)
local drag=false
local function setV(x)
local rel=math.clamp((x-tb.AbsolutePosition.X)/tb.AbsoluteSize.X,0,1)
local nv=math.floor(minV+(maxV-minV)*rel)
item.value=nv
fl.Size=UDim2.new(rel,0,1,0)
vl.Text=tostring(nv)
if item.callback then pcall(item.callback,nv)end
end
local ha=Instance.new("TextButton")
ha.Position=UDim2.new(0,-5,0,-10)
ha.Size=UDim2.new(1,10,0,25)
ha.BackgroundTransparency=1
ha.Text=""
ha.ZIndex=60
ha.Parent=tb
ha.InputBegan:Connect(function(inp)
if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
drag=true setV(inp.Position.X)
end
end)
ha.InputEnded:Connect(function(inp)
if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
drag=false
end
end)
UserInputService.InputChanged:Connect(function(inp)
if drag and(inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch)then
setV(inp.Position.X)
end
end)
end
end
end
function Island:AddLabel(n,t)
local tab=self.CurrentTab
if not tab then return end
table.insert(tab.items,{type="label",name=n,text=t})
self:RenderTab(tab)
end
function Island:AddButton(n,cb)
local tab=self.CurrentTab
if not tab then return end
table.insert(tab.items,{type="button",name=n,callback=cb})
self:RenderTab(tab)
end
function Island:AddToggle(n,d,cb)
local tab=self.CurrentTab
if not tab then return end
table.insert(tab.items,{type="toggle",name=n,value=d or false,callback=cb})
self:RenderTab(tab)
end
function Island:AddInput(n,d,cb,ph)
local tab=self.CurrentTab
if not tab then return end
table.insert(tab.items,{type="input",name=n,value=d or "",callback=cb,placeholder=ph})
self:RenderTab(tab)
end
function Island:AddDropdown(n,values,default,cb)
local tab=self.CurrentTab
if not tab then return end
table.insert(tab.items,{type="dropdown",name=n,values=values,value=default or(values[1]or ""),callback=cb})
self:RenderTab(tab)
end
function Island:AddSlider(n,mn,mx,d,cb)
local tab=self.CurrentTab
if not tab then return end
table.insert(tab.items,{type="slider",name=n,min=mn,max=mx,value=d,callback=cb})
self:RenderTab(tab)
end
function Island:Notify(t,m,d)
d=d or 2.5
local pt,pf,pp=titleLabel.Text,fpsLabel.Text,pingLabel.Text
titleLabel.Text=t or "通知"
fpsLabel.Text=tostring(m or "")
pingLabel.Text=""
task.delay(d,function()
titleLabel.Text=pt
fpsLabel.Text=pf
pingLabel.Text=pp
end)
end
local clickT=0
compact.InputBegan:Connect(function(inp)
if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
clickT=tick()
end
end)
compact.InputEnded:Connect(function(inp)
if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
if(tick()-clickT)<0.4 then Island:Toggle()end
end
end)
closeBtn.MouseButton1Click:Connect(function()Island:Collapse()end)
task.spawn(function()
while island.Parent do
local fps=math.floor(Workspace:GetRealPhysicsFPS())
local ping=0
pcall(function()
local s=Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
ping=math.floor(tonumber(s:match("%d+"))or 0)
end)
fpsLabel.Text="FPS: "..tostring(fps)
pingLabel.Text="Ping: "..tostring(ping)
task.wait(0.5)
end
end)
getgenv().DynamicIsland=Island
local function Notify(t,d)pcall(function()Island:Notify(t,d)end)end

-- ═══════════ 服务器 ═══════════
local TServer=Island:AddTab("服务器")
Island:SelectTab(TServer)

Island:AddButton("浏览器",function()
local sg=Instance.new("ScreenGui")
sg.Name="ServerBrowserGui"
sg.Parent=game.CoreGui
local mf=Instance.new("Frame")
mf.Size=UDim2.new(0,400,0,300)
mf.Position=UDim2.new(0.5,-200,0.5,-150)
mf.BackgroundColor3=Color3.fromRGB(30,30,30)
mf.BorderSizePixel=0
mf.Active=true
mf.Draggable=true
mf.Parent=sg
local tb=Instance.new("Frame")
tb.Size=UDim2.new(1,0,0,30)
tb.BackgroundColor3=Color3.fromRGB(40,40,40)
tb.BorderSizePixel=0
tb.Parent=mf
local tt=Instance.new("TextLabel")
tt.Size=UDim2.new(1,-30,1,0)
tt.Position=UDim2.new(0,10,0,0)
tt.BackgroundTransparency=1
tt.Text="服务器浏览器"
tt.TextColor3=Color3.fromRGB(255,255,255)
tt.TextSize=16
tt.Font=Enum.Font.SourceSansBold
tt.TextXAlignment=Enum.TextXAlignment.Left
tt.Parent=tb
local cb=Instance.new("TextButton")
cb.Size=UDim2.new(0,20,0,20)
cb.Position=UDim2.new(1,-25,0,5)
cb.BackgroundColor3=Color3.fromRGB(200,50,50)
cb.Text="X"
cb.TextColor3=Color3.fromRGB(255,255,255)
cb.Font=Enum.Font.SourceSansBold
cb.TextSize=14
cb.Parent=tb
local sl=Instance.new("ScrollingFrame")
sl.Size=UDim2.new(1,-20,1,-80)
sl.Position=UDim2.new(0,10,0,40)
sl.BackgroundColor3=Color3.fromRGB(40,40,40)
sl.BorderSizePixel=0
sl.ScrollBarThickness=6
sl.CanvasSize=UDim2.new(0,0,0,0)
sl.Parent=mf
local rb=Instance.new("TextButton")
rb.Size=UDim2.new(0,100,0,30)
rb.Position=UDim2.new(0,10,1,-35)
rb.BackgroundColor3=Color3.fromRGB(50,120,200)
rb.Text="刷新"
rb.TextColor3=Color3.fromRGB(255,255,255)
rb.Font=Enum.Font.SourceSansBold
rb.TextSize=14
rb.Parent=mf
local stl=Instance.new("TextLabel")
stl.Size=UDim2.new(0,280,0,30)
stl.Position=UDim2.new(0,120,1,-35)
stl.BackgroundTransparency=1
stl.Text="准备就绪"
stl.TextColor3=Color3.fromRGB(200,200,200)
stl.TextSize=14
stl.Font=Enum.Font.SourceSans
stl.TextXAlignment=Enum.TextXAlignment.Left
stl.Parent=mf
local ull=Instance.new("UIListLayout")
ull.Parent=sl
ull.SortOrder=Enum.SortOrder.LayoutOrder
ull.Padding=UDim.new(0,5)
local function mkServer(si,idx)
local sb=Instance.new("Frame")
sb.Size=UDim2.new(1,-10,0,50)
sb.BackgroundColor3=Color3.fromRGB(50,50,50)
sb.BorderSizePixel=0
local pc=Instance.new("TextLabel")
pc.Size=UDim2.new(0,80,1,0)
pc.BackgroundTransparency=1
pc.Text=si.playing.."/"..si.maxPlayers
pc.TextColor3=Color3.fromRGB(255,255,255)
pc.TextSize=14
pc.Font=Enum.Font.SourceSans
pc.Parent=sb
local il=Instance.new("TextLabel")
il.Size=UDim2.new(0,200,0,20)
il.Position=UDim2.new(0,90,0,15)
il.BackgroundTransparency=1
il.Text="ID: "..si.id
il.TextColor3=Color3.fromRGB(200,200,200)
il.TextSize=12
il.Font=Enum.Font.SourceSans
il.TextXAlignment=Enum.TextXAlignment.Left
il.Parent=sb
local jb=Instance.new("TextButton")
jb.Size=UDim2.new(0,60,0,25)
jb.Position=UDim2.new(1,-70,0.5,-12.5)
jb.BackgroundColor3=Color3.fromRGB(70,150,70)
jb.Text="加入"
jb.TextColor3=Color3.fromRGB(255,255,255)
jb.Font=Enum.Font.SourceSansBold
jb.TextSize=14
jb.Parent=sb
jb.MouseButton1Click:Connect(function()
TeleportService:TeleportToPlaceInstance(game.PlaceId,si.id)
end)
return sb
end
local function fetch()
stl.Text="正在获取..."
for _,c in pairs(sl:GetChildren())do
if c:IsA("Frame")then c:Destroy()end
end
local ok,res=pcall(function()
return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
end)
if ok and res and res.data then
for i,srv in ipairs(res.data)do
mkServer({id=srv.id,playing=srv.playing,maxPlayers=srv.maxPlayers},i).Parent=sl
end
sl.CanvasSize=UDim2.new(0,0,0,ull.AbsoluteContentSize.Y+10)
stl.Text="找到 "..#res.data.." 个服务器"
else
stl.Text="获取失败"
end
end
rb.MouseButton1Click:Connect(fetch)
cb.MouseButton1Click:Connect(function()sg:Destroy()end)
fetch()
end)

Island:AddButton("重新加入服务器",function()
pcall(function()TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LocalPlayer)end)
end)

Island:AddButton("加入延迟低的服务器",function()
local ok,data=pcall(function()
return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
end)
if ok and data and data.data then
local av={}
for _,srv in ipairs(data.data)do
if srv.playing<srv.maxPlayers and srv.id~=game.JobId then table.insert(av,srv)end
end
if #av>0 then
local pick=av[math.random(1,#av)]
pcall(function()TeleportService:TeleportToPlaceInstance(game.PlaceId,pick.id,LocalPlayer)end)
end
end
end)

Island:AddButton("加入新手服务器",function()
local ok,data=pcall(function()
return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
end)
if ok and data and data.data then
table.sort(data.data,function(a,b)return a.playing<b.playing end)
for _,srv in ipairs(data.data)do
if srv.id~=game.JobId and srv.playing>0 then
pcall(function()TeleportService:TeleportToPlaceInstance(game.PlaceId,srv.id,LocalPlayer)end)
return
end
end
end
end)

-- ═══════════ 通用 ═══════════
local TGen=Island:AddTab("通用")
Island:SelectTab(TGen)

Island:AddButton("自杀",function()
local ch=LocalPlayer.Character
local hum=ch and ch:FindFirstChildOfClass("Humanoid")
if hum then hum.Health=0 end
end)

do
local RS=game:GetService("ReplicatedStorage")
local ok,Ragdolls=pcall(function()
return require(RS:WaitForChild("Modules"):WaitForChild("Rendering"):WaitForChild("Ragdolls"))
end)
if ok then
local function raEn()
local ch=LocalPlayer.Character
local hum=ch and ch:FindFirstChild("Humanoid")
if not hum then return end
hum.PlatformStand=true
Ragdolls.EnableRagdoll(ch)
end
local function raDis()
local ch=LocalPlayer.Character
local hum=ch and ch:FindFirstChild("Humanoid")
if not hum then return end
hum.PlatformStand=false
Ragdolls.DisableRagdoll(ch)
end
LocalPlayer.CharacterAdded:Connect(raDis)
Island:AddToggle("布娃娃模式",false,function(s)
if s then raEn()else raDis()end
end)
end
end

Island:AddButton("翻译过的Dex",function()
loadstring(game:HttpGet("https://gitee.com/cmbhbh/cmbh/raw/master/Bex.lua"))()
end)

Island:AddButton("低画质脚本",function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/vexroxd/My-Script-/main/roblox%20fps%20unlocker%20script.lua"))()
end)

-- 速度提升
do
local spdOn=false
Island:AddToggle("速度提升",false,function(v)
spdOn=v
if v then
task.spawn(function()
while spdOn do
local ch=LocalPlayer.Character
local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
local hum=ch and ch:FindFirstChildOfClass("Humanoid")
if hrp and hum and hum.MoveDirection.Magnitude>0 then
hrp:TranslateBy(hum.MoveDirection*7*RunService.RenderStepped:Wait())
else
RunService.RenderStepped:Wait()
end
end
end)
end
end)
end

-- 计时器位置
do
local TPos={side="Middle"}
local function apply()
local rt=LocalPlayer.PlayerGui:FindFirstChild("RoundTimer")
local m=rt and rt:FindFirstChild("Main")
if not m then return end
local x=(TPos.side=="Middle")and 0.5 or 0.9
m.Position=UDim2.new(x,0,m.Position.Y.Scale,m.Position.Y.Offset)
end
apply()
LocalPlayer.CharacterAdded:Connect(function()
task.wait(0.5)apply()
end)
Island:AddDropdown("计时器位置",{"中间","右侧"},"中间",function(s)
TPos.side=(s=="中间")and"Middle"or"Right"
apply()
end)
end

-- 显示聊天
do
local TCS=game:GetService("TextChatService")
Island:AddToggle("显示聊天",false,function(v)
local cfg=TCS:FindFirstChildOfClass("ChatWindowConfiguration")
if cfg then cfg.Enabled=v end
end)
end

-- 飞行
do
local FLYING=false
local flyKD,flyKU,flyC
local iyfs=50
local function flyRoot(c)
return c:FindFirstChild("HumanoidRootPart")or c:FindFirstChild("Torso")or c:FindFirstChild("UpperTorso")
end
local function stopFly()
FLYING=false
if flyKD then flyKD:Disconnect()flyKD=nil end
if flyKU then flyKU:Disconnect()flyKU=nil end
if flyC then flyC:Disconnect()flyC=nil end
local c=LocalPlayer.Character
if c then
local hu=c:FindFirstChildOfClass("Humanoid")
local rt=flyRoot(c)
if hu then hu.PlatformStand=false end
if rt then
for _,v in pairs(rt:GetChildren())do
if v:IsA("BodyGyro")or v:IsA("BodyVelocity")then v:Destroy()end
end
end
end
end
local function startFly()
local c=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hu=c:FindFirstChildOfClass("Humanoid")or c:WaitForChild("Humanoid")
local rt=flyRoot(c)
if not rt then return end
if flyKD then flyKD:Disconnect()end
if flyKU then flyKU:Disconnect()end
if flyC then flyC:Disconnect()end
local CT={F=0,B=0,L=0,R=0,Q=0,E=0}
local BG=Instance.new("BodyGyro")
local BV=Instance.new("BodyVelocity")
BG.P=9e4
BG.MaxTorque=Vector3.new(9e9,9e9,9e9)
BG.CFrame=rt.CFrame
BG.Parent=rt
BV.MaxForce=Vector3.new(9e9,9e9,9e9)
BV.Velocity=Vector3.new(0,0,0)
BV.Parent=rt
FLYING=true
flyKD=UserInputService.InputBegan:Connect(function(inp)
if inp.UserInputType==Enum.UserInputType.Keyboard then
if inp.KeyCode==Enum.KeyCode.W then CT.F=iyfs end
if inp.KeyCode==Enum.KeyCode.S then CT.B=-iyfs end
if inp.KeyCode==Enum.KeyCode.A then CT.L=-iyfs end
if inp.KeyCode==Enum.KeyCode.D then CT.R=iyfs end
if inp.KeyCode==Enum.KeyCode.E then CT.Q=iyfs*2 end
if inp.KeyCode==Enum.KeyCode.Q then CT.E=-iyfs*2 end
end
end)
flyKU=UserInputService.InputEnded:Connect(function(inp)
if inp.UserInputType==Enum.UserInputType.Keyboard then
if inp.KeyCode==Enum.KeyCode.W then CT.F=0 end
if inp.KeyCode==Enum.KeyCode.S then CT.B=0 end
if inp.KeyCode==Enum.KeyCode.A then CT.L=0 end
if inp.KeyCode==Enum.KeyCode.D then CT.R=0 end
if inp.KeyCode==Enum.KeyCode.E then CT.Q=0 end
if inp.KeyCode==Enum.KeyCode.Q then CT.E=0 end
end
end)
flyC=RunService.RenderStepped:Connect(function()
if not FLYING then return end
local cam=Workspace.CurrentCamera
local mv=Vector3.new(CT.L+CT.R,CT.Q+CT.E,CT.F+CT.B)
local ok,cm=pcall(function()
return require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
end)
if ok and cm then
local m=cm:GetMoveVector()
mv=Vector3.new(m.X,mv.Y,-m.Z)
end
BV.Velocity=(cam.CFrame.RightVector*mv.X+Vector3.new(0,mv.Y,0)+cam.CFrame.LookVector*mv.Z)*5
BG.CFrame=cam.CFrame
hu.PlatformStand=true
end)
end
Island:AddToggle("飞行",false,function(s)
if s then startFly()else stopFly()end
end)
Island:AddSlider("飞行速度",5,200,50,function(v)iyfs=v end)
end

-- 场景设置
do
local _env={Brightness=0,GlobalShadows=false,NoFog=false,Fullbright=false}
if not Lighting:GetAttribute("FogStart")then Lighting:SetAttribute("FogStart",Lighting.FogStart)end
if not Lighting:GetAttribute("FogEnd")then Lighting:SetAttribute("FogEnd",Lighting.FogEnd)end
local conn=nil
local function tickL()
Lighting.FogStart=_env.NoFog and 0 or Lighting:GetAttribute("FogStart")
Lighting.FogEnd=_env.NoFog and math.huge or Lighting:GetAttribute("FogEnd")
local fog=Lighting:FindFirstChildOfClass("Atmosphere")
if fog then
if not fog:GetAttribute("Density")then fog:SetAttribute("Density",fog.Density)end
fog.Density=_env.NoFog and 0 or fog:GetAttribute("Density")
end
if _env.Fullbright then
Lighting.OutdoorAmbient=Color3.new(1,1,1)
Lighting.Brightness=_env.Brightness or 0
Lighting.GlobalShadows=not _env.GlobalShadows
else
Lighting.OutdoorAmbient=Color3.fromRGB(55,55,55)
Lighting.Brightness=0
Lighting.GlobalShadows=true
end
end
local function setLoop(s)
if s then
if conn then conn:Disconnect()end
conn=RunService.RenderStepped:Connect(tickL)
else
if conn then conn:Disconnect()conn=nil end
Lighting.OutdoorAmbient=Color3.fromRGB(55,55,55)
Lighting.Brightness=0
Lighting.GlobalShadows=true
end
end
Island:AddSlider("亮度",0,3,0,function(v)_env.Brightness=v end)
Island:AddToggle("无阴影",false,function(s)_env.GlobalShadows=s end)
Island:AddToggle("除雾",false,function(s)_env.NoFog=s end)
Island:AddToggle("全亮总开关",false,function(s)
_env.Fullbright=s
setLoop(s)
end)
end

-- ═══════════ 透视 ═══════════
local TEsp=Island:AddTab("透视")
Island:SelectTab(TEsp)

-- 发电机透视
do
local GenConf={Enabled=false,ShowPercent=true,ShowDist=true,FilterFakes=true,Color=Color3.fromRGB(0,200,255)}
local GenCache={}
local GenList={}
local lastScan=0
local activeGens={}
local function prog(gen)
if not gen or not gen.Parent then return 0 end
local a=gen:GetAttribute("Progress")or gen:GetAttribute("RepairProgress")or gen:GetAttribute("Percent")
if a and type(a)=="number"then return a<=1 and math.floor(a*100)or math.floor(a)end
return 0
end
local function scan()
local list={}
local map=Workspace:FindFirstChild("Map")and Workspace.Map:FindFirstChild("Ingame")
if map then
for _,obj in ipairs(map:GetDescendants())do
if obj:IsA("Model")and(obj.Name=="Generator"or obj.Name:match("^SetupGenerators"))then
local fake=obj:FindFirstChild("FakeGenerator")~=nil or obj:GetAttribute("Fake")==true
local root=obj:FindFirstChild("Main")or obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
if root then
table.insert(list,{Model=obj,Root=root,IsFake=fake,Progress=prog(obj)})
end
end
end
end
GenList=list
end
local gui2=Instance.new("Folder")
gui2.Name="xtal_Gen_ESP"
gui2.Parent=(gethui and gethui())or game:GetService("CoreGui")
RunService.Heartbeat:Connect(function()
local cam=Workspace.CurrentCamera
if not cam then return end
if not GenConf.Enabled then
for _,bg in pairs(GenCache)do if bg.Gui then bg.Gui.Enabled=false end end
return
end
local now=tick()
if now-lastScan>=0.5 then
lastScan=now
scan()
end
activeGens={}
for _,gen in ipairs(GenList)do
if gen.Root and gen.Model and gen.Model.Parent then
local dist=(cam.CFrame.Position-gen.Root.Position).Magnitude
local bg=GenCache[gen.Model]
if GenConf.FilterFakes and gen.IsFake then
if bg then bg.Gui.Enabled=false bg.Gui.Adornee=nil end
elseif dist<=800 then
activeGens[gen.Model]=true
if not bg or not bg.Gui.Parent then
local bGui=Instance.new("BillboardGui")
bGui.Size=UDim2.fromOffset(200,20)
bGui.AlwaysOnTop=true
bGui.LightInfluence=0
bGui.StudsOffset=Vector3.new(0,2,0)
bGui.Parent=gui2
local lbl=Instance.new("TextLabel",bGui)
lbl.Size=UDim2.fromScale(1,1)
lbl.BackgroundTransparency=1
lbl.Font=Enum.Font.GothamBold
lbl.TextSize=12
lbl.TextStrokeTransparency=0
lbl.TextStrokeColor3=Color3.fromRGB(0,0,0)
GenCache[gen.Model]={Gui=bGui,Label=lbl}
bg=GenCache[gen.Model]
end
bg.Gui.Enabled=true
bg.Gui.Adornee=gen.Root
local dm=math.floor(dist/3.57)
local s=gen.IsFake and "[假]"or"发电机"
if GenConf.ShowPercent and not gen.IsFake then s=s.." ["..math.floor(gen.Progress).."%]"end
if GenConf.ShowDist then s=s.." • "..dm.."m"end
bg.Label.Text=s
bg.Label.TextColor3=gen.IsFake and Color3.fromRGB(255,50,50)or GenConf.Color
else
if bg then bg.Gui.Enabled=false bg.Gui.Adornee=nil end
end
end
end
for m,bg in pairs(GenCache)do
if not activeGens[m]then
if bg.Gui then bg.Gui.Enabled=false bg.Gui.Adornee=nil end
if not m.Parent then pcall(function()bg.Gui:Destroy()end)GenCache[m]=nil end
end
end
end)
Island:AddToggle("发电机透视",false,function(v)GenConf.Enabled=v end)
Island:AddToggle("显示进度%",true,function(v)GenConf.ShowPercent=v end)
Island:AddToggle("显示距离",true,function(v)GenConf.ShowDist=v end)
Island:AddToggle("过滤假发电机",true,function(v)GenConf.FilterFakes=v end)
end

-- 幸存者透视
do
local V={S_Enabled=false,S_Fill=Color3.fromRGB(40,255,120),S_Out=Color3.fromRGB(255,255,255),S_LF=2,S_LO=0,
ShowName=true,ShowDist=true,ShowHP=true,ShowRole=true,ShowStatus=true,ShowBox=true}
local HL={}
local TagCache={}
local function getRoot(c)
if not c or typeof(c)~="Instance"then return nil end
return c:FindFirstChild("HumanoidRootPart")or c.PrimaryPart
end
local function alive(c)
if not c then return false end
local rag=Workspace:FindFirstChild("Ragdolls")
if rag and c:IsDescendantOf(rag)then return false end
local h=c:FindFirstChildOfClass("Humanoid")
return h and h.Health>0 and c:GetAttribute("Dead")~=true
end
local gui3=Instance.new("Folder")
gui3.Name="xtal_Surv_ESP"
gui3.Parent=(gethui and gethui())or game:GetService("CoreGUI")
local tg=Instance.new("ScreenGui")
tg.Name="xtal_Surv_2D"
tg.ResetOnSpawn=false
tg.IgnoreGuiInset=true
tg.DisplayOrder=999
tg.Parent=(gethui and gethui())or game:GetService("CoreGUI")
local function getHL(m)
if not HL[m]then
local h=Instance.new("Highlight")
h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
h.Parent=gui3
HL[m]=h
end
return HL[m]
end
local function getTag(m)
if not TagCache[m]or not TagCache[m].Box or not TagCache[m].Box.Parent then
local box=Instance.new("Frame")
box.BackgroundTransparency=1
box.BorderSizePixel=0
box.Visible=false
box.Position=UDim2.fromOffset(-5000,-5000)
box.Size=UDim2.fromOffset(0,0)
box.ZIndex=100
box.Parent=tg
local st=Instance.new("UIStroke",box)
st.Name="Stroke"
st.Thickness=1.5
st.Transparency=1
local function mkHolder(anchor,pos,hA,vA)
local h=Instance.new("Frame",box)
h.BackgroundTransparency=1
h.AnchorPoint=anchor
h.Position=pos
h.Size=UDim2.new(0,260,0,0)
h.AutomaticSize=Enum.AutomaticSize.Y
h.ZIndex=101
local l=Instance.new("UIListLayout",h)
l.SortOrder=Enum.SortOrder.LayoutOrder
l.HorizontalAlignment=hA
l.VerticalAlignment=vA
l.Padding=UDim.new(0,1)
return h
end
local top=mkHolder(Vector2.new(0.5,1),UDim2.new(0.5,0,0,-3),Enum.HorizontalAlignment.Center,Enum.VerticalAlignment.Bottom)
local bot=mkHolder(Vector2.new(0.5,0),UDim2.new(0.5,0,1,3),Enum.HorizontalAlignment.Center,Enum.VerticalAlignment.Top)
local function mkLbl()
local l=Instance.new("TextLabel")
l.BackgroundTransparency=1
l.Font=Enum.Font.GothamBold
l.TextSize=12
l.TextColor3=Color3.fromRGB(255,255,255)
l.TextStrokeColor3=Color3.fromRGB(0,0,0)
l.TextStrokeTransparency=0
l.TextTransparency=0
l.Size=UDim2.new(1,0,0,14)
l.Visible=false
l.ZIndex=102
l.Parent=top
return l
end
TagCache[m]={Box=box,Stroke=st,Top=top,Bot=bot,
Role=mkLbl(),Name=mkLbl(),HP=mkLbl(),Dist=mkLbl()}
end
return TagCache[m]
end
RunService.Heartbeat:Connect(function()
local cam=Workspace.CurrentCamera
if not cam then return end
local my=LocalPlayer.Character
local rendered={}
local pf=Workspace:FindFirstChild("Players")
local sf=pf and pf:FindFirstChild("Survivors")
local cs={}
if sf then
for _,c in ipairs(sf:GetChildren())do
if c:IsA("Model")and c~=my then table.insert(cs,c)end
end
end
for _,ch in ipairs(cs)do
if alive(ch)then
local root=getRoot(ch)
local hum=ch:FindFirstChildOfClass("Humanoid")
if root and hum and hum.Health>0 then
local dist=(cam.CFrame.Position-root.Position).Magnitude
if dist<=900 then
local hl=getHL(ch)
if V.S_Enabled then
hl.Enabled=true
hl.Adornee=ch
hl.FillColor=V.S_Fill
hl.OutlineColor=V.S_Out
hl.FillTransparency=math.clamp(V.S_LF/5,0,1)
hl.OutlineTransparency=math.clamp(V.S_LO/5,0,1)
else
hl.Enabled=false
hl.Adornee=nil
end
local pos,on=cam:WorldToViewportPoint(root.Position)
if on and pos.Z>0 then
local tp=cam:WorldToViewportPoint(root.Position+Vector3.new(0,2.5,0))
local bp=cam:WorldToViewportPoint(root.Position-Vector3.new(0,3,0))
if tp.Z>0 and bp.Z>0 then
local bh=math.max(math.abs(bp.Y-tp.Y),10)
local bw=math.floor(bh*0.62)
local minX=math.floor(pos.X-bw/2)
local minY=math.floor(math.min(tp.Y,bp.Y))
local maxX=minX+bw
local maxY=minY+bh
if dist>3.5 and minX<maxX and minY<maxY then
local t=getTag(ch)
local dm=math.floor(dist/3.57)
local player=Players:GetPlayerFromCharacter(ch)
local dispName=(player and player.DisplayName)or ch:GetAttribute("ActorDisplayName")or ch.Name
t.Box.Position=UDim2.fromOffset(minX,minY)
t.Box.Size=UDim2.fromOffset(maxX-minX,maxY-minY)
t.Box.BackgroundColor3=Color3.fromRGB(0,0,0)
t.Box.BackgroundTransparency=0.85
t.Stroke.Color=Color3.fromRGB(255,255,255)
t.Stroke.Transparency=V.ShowBox and 0.2 or 1
t.Box.Visible=true
t.Role.Text="[幸存者]"
t.Role.Visible=V.ShowRole
t.Role.TextColor3=Color3.fromRGB(60,255,120)
t.Name.Text=dispName
t.Name.Visible=V.ShowName
t.Name.TextColor3=Color3.fromRGB(255,255,255)
t.HP.Text=math.floor(hum.Health).."/"..math.floor(hum.MaxHealth).." 生命"
t.HP.Visible=V.ShowHP
t.HP.TextColor3=Color3.fromRGB(60,255,120)
t.Dist.Text="["..dm.."m]"
t.Dist.Visible=V.ShowDist
t.Dist.TextColor3=Color3.fromRGB(255,255,255)
t.Dist.Parent=t.Bot
rendered[ch]=true
end
end
end
end
end
end
end
for m,t in pairs(TagCache)do
if not rendered[m]then
t.Box.Visible=false
t.Role.Visible=false
t.Name.Visible=false
t.HP.Visible=false
t.Dist.Visible=false
local hl=HL[m]
if hl then hl.Enabled=false hl.Adornee=nil end
if not m or not m.Parent then
pcall(function()t.Box:Destroy()end)
TagCache[m]=nil
end
end
end
end)
Island:AddToggle("幸存者透视",false,function(v)V.S_Enabled=v end)
Island:AddToggle("显示方框",true,function(v)V.ShowBox=v end)
Island:AddToggle("显示名字",true,function(v)V.ShowName=v end)
Island:AddToggle("显示血量",true,function(v)V.ShowHP=v end)
Island:AddToggle("显示距离",true,function(v)V.ShowDist=v end)
Island:AddToggle("显示标签",true,function(v)V.ShowRole=v end)
Island:AddSlider("内框透明度",0,5,2,function(v)V.S_LF=v end)
Island:AddSlider("外框透明度",0,5,0,function(v)V.S_LO=v end)
end

-- 杀手透视
do
local V={S_Enabled=false,S_Fill=Color3.fromRGB(255,40,40),S_Out=Color3.fromRGB(255,255,255),S_LF=2,S_LO=0,
ShowName=true,ShowDist=true,ShowHP=true,ShowRole=true,ShowBox=true}
local HL={}
local TagCache={}
local function getRoot(c)
if not c or typeof(c)~="Instance"then return nil end
return c:FindFirstChild("HumanoidRootPart")or c.PrimaryPart
end
local function alive(c)
if not c then return false end
local rag=Workspace:FindFirstChild("Ragdolls")
if rag and c:IsDescendantOf(rag)then return false end
local h=c:FindFirstChildOfClass("Humanoid")
return h and h.Health>0 and c:GetAttribute("Dead")~=true
end
local gui4=Instance.new("Folder")
gui4.Name="xtal_Killer_ESP"
gui4.Parent=(gethui and gethui())or game:GetService("CoreGUI")
local tg=Instance.new("ScreenGui")
tg.Name="xtal_Killer_2D"
tg.ResetOnSpawn=false
tg.IgnoreGuiInset=true
tg.DisplayOrder=999
tg.Parent=(gethui and gethui())or game:GetService("CoreGUI")
local function getHL(m)
if not HL[m]then
local h=Instance.new("Highlight")
h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
h.Parent=gui4
HL[m]=h
end
return HL[m]
end
local function getTag(m)
if not TagCache[m]or not TagCache[m].Box or not TagCache[m].Box.Parent then
local box=Instance.new("Frame")
box.BackgroundTransparency=1
box.BorderSizePixel=0
box.Visible=false
box.Position=UDim2.fromOffset(-5000,-5000)
box.Size=UDim2.fromOffset(0,0)
box.ZIndex=100
box.Parent=tg
local st=Instance.new("UIStroke",box)
st.Name="Stroke"
st.Thickness=1.5
st.Transparency=1
local function mkHolder(anchor,pos,hA,vA)
local h=Instance.new("Frame",box)
h.BackgroundTransparency=1
h.AnchorPoint=anchor
h.Position=pos
h.Size=UDim2.new(0,260,0,0)
h.AutomaticSize=Enum.AutomaticSize.Y
h.ZIndex=101
local l=Instance.new("UIListLayout",h)
l.SortOrder=Enum.SortOrder.LayoutOrder
l.HorizontalAlignment=hA
l.VerticalAlignment=vA
l.Padding=UDim.new(0,1)
return h
end
local top=mkHolder(Vector2.new(0.5,1),UDim2.new(0.5,0,0,-3),Enum.HorizontalAlignment.Center,Enum.VerticalAlignment.Bottom)
local bot=mkHolder(Vector2.new(0.5,0),UDim2.new(0.5,0,1,3),Enum.HorizontalAlignment.Center,Enum.VerticalAlignment.Top)
local function mkLbl()
local l=Instance.new("TextLabel")
l.BackgroundTransparency=1
l.Font=Enum.Font.GothamBold
l.TextSize=12
l.TextColor3=Color3.fromRGB(255,255,255)
l.TextStrokeColor3=Color3.fromRGB(0,0,0)
l.TextStrokeTransparency=0
l.TextTransparency=0
l.Size=UDim2.new(1,0,0,14)
l.Visible=false
l.ZIndex=102
l.Parent=top
return l
end
TagCache[m]={Box=box,Stroke=st,Top=top,Bot=bot,
Role=mkLbl(),Name=mkLbl(),HP=mkLbl(),Dist=mkLbl()}
end
return TagCache[m]
end
RunService.Heartbeat:Connect(function()
local cam=Workspace.CurrentCamera
if not cam then return end
local my=LocalPlayer.Character
local rendered={}
local pf=Workspace:FindFirstChild("Players")
local kf=pf and pf:FindFirstChild("Killers")
local cs={}
if kf then
for _,c in ipairs(kf:GetChildren())do
if c:IsA("Model")and c~=my then table.insert(cs,c)end
end
end
for _,ch in ipairs(cs)do
if alive(ch)then
local root=getRoot(ch)
local hum=ch:FindFirstChildOfClass("Humanoid")
if root and hum and hum.Health>0 then
local dist=(cam.CFrame.Position-root.Position).Magnitude
if dist<=900 then
local hl=getHL(ch)
if V.S_Enabled then
hl.Enabled=true
hl.Adornee=ch
hl.FillColor=V.S_Fill
hl.OutlineColor=V.S_Out
hl.FillTransparency=math.clamp(V.S_LF/5,0,1)
hl.OutlineTransparency=math.clamp(V.S_LO/5,0,1)
else
hl.Enabled=false
hl.Adornee=nil
end
local pos,on=cam:WorldToViewportPoint(root.Position)
if on and pos.Z>0 then
local tp=cam:WorldToViewportPoint(root.Position+Vector3.new(0,2.5,0))
local bp=cam:WorldToViewportPoint(root.Position-Vector3.new(0,3,0))
if tp.Z>0 and bp.Z>0 then
local bh=math.max(math.abs(bp.Y-tp.Y),10)
local bw=math.floor(bh*0.62)
local minX=math.floor(pos.X-bw/2)
local minY=math.floor(math.min(tp.Y,bp.Y))
local maxX=minX+bw
local maxY=minY+bh
if dist>3.5 and minX<maxX and minY<maxY then
local t=getTag(ch)
local dm=math.floor(dist/3.57)
local player=Players:GetPlayerFromCharacter(ch)
local dispName=(player and player.DisplayName)or ch:GetAttribute("ActorDisplayName")or ch.Name
t.Box.Position=UDim2.fromOffset(minX,minY)
t.Box.Size=UDim2.fromOffset(maxX-minX,maxY-minY)
t.Box.BackgroundColor3=Color3.fromRGB(0,0,0)
t.Box.BackgroundTransparency=0.85
t.Stroke.Color=Color3.fromRGB(255,255,255)
t.Stroke.Transparency=V.ShowBox and 0.2 or 1
t.Box.Visible=true
t.Role.Text="[杀手]"
t.Role.Visible=V.ShowRole
t.Role.TextColor3=Color3.fromRGB(255,60,60)
t.Name.Text=dispName
t.Name.Visible=V.ShowName
t.Name.TextColor3=Color3.fromRGB(255,255,255)
t.HP.Text=math.floor(hum.Health).."/"..math.floor(hum.MaxHealth).." 生命"
t.HP.Visible=V.ShowHP
t.HP.TextColor3=Color3.fromRGB(255,60,60)
t.Dist.Text="["..dm.."m]"
t.Dist.Visible=V.ShowDist
t.Dist.TextColor3=Color3.fromRGB(255,60,60)
t.Dist.Parent=t.Bot
rendered[ch]=true
end
end
end
end
end
end
end
for m,t in pairs(TagCache)do
if not rendered[m]then
t.Box.Visible=false
t.Role.Visible=false
t.Name.Visible=false
t.HP.Visible=false
t.Dist.Visible=false
local hl=HL[m]
if hl then hl.Enabled=false hl.Adornee=nil end
if not m or not m.Parent then
pcall(function()t.Box:Destroy()end)
TagCache[m]=nil
end
end
end
end)
Island:AddToggle("杀手透视",false,function(v)V.S_Enabled=v end)
Island:AddToggle("显示方框",true,function(v)V.ShowBox=v end)
Island:AddToggle("显示名字",true,function(v)V.ShowName=v end)
Island:AddToggle("显示血量",true,function(v)V.ShowHP=v end)
Island:AddToggle("显示距离",true,function(v)V.ShowDist=v end)
Island:AddToggle("显示标签",true,function(v)V.ShowRole=v end)
Island:AddSlider("内框透明度",0,5,2,function(v)V.S_LF=v end)
Island:AddSlider("外框透明度",0,5,0,function(v)V.S_LO=v end)
end

-- 物品透视
do
local IC={Enabled=false,ShowDist=true,Color=Color3.fromRGB(255,200,50)}
local Cache={}
local List={}
local lastScan=0
local lastIngame=nil
local gui5=Instance.new("Folder")
gui5.Name="xtal_Item_ESP"
gui5.Parent=(gethui and gethui())or game:GetService("CoreGUI")
local function upList()
local lst={}
local seen={}
local map=Workspace:FindFirstChild("Map")and Workspace.Map:FindFirstChild("Ingame")
local pf=Workspace:FindFirstChild("Players")
local scanF={Workspace}
if map then table.insert(scanF,map)end
for _,folder in ipairs(scanF)do
for _,obj in ipairs(folder:GetChildren())do
if obj.Name~="Players"and obj.Name~="Ragdolls"and obj.Name~="ItemLocations"then
local tc=obj:IsA("Tool")and obj or obj:FindFirstChildWhichIsA("Tool")
if tc and not seen[tc]then
local eq=(pf and tc:IsDescendantOf(pf))or tc:FindFirstAncestorOfClass("Player")or(tc.Parent and tc.Parent:FindFirstChildOfClass("Humanoid"))
if not eq then
local root=tc:FindFirstChild("ItemRoot")or tc:FindFirstChild("Handle")or tc:FindFirstChildWhichIsA("MeshPart")or tc:FindFirstChildWhichIsA("BasePart")
local prompt=tc:FindFirstChildOfClass("ProximityPrompt",true)
local nl=tc.Name:lower()
local fake=nl:find("fake")~=nil or tc:GetAttribute("Fake")==true or tc:GetAttribute("Trap")==true
local it=nil
if nl:find("cola")or nl:find("bloxiade")then it="可乐"
elseif nl:find("medkit")then it=fake and "假医疗包"or"医疗包"end
if it and root then
seen[tc]=true
table.insert(lst,{Instance=tc,Root=root,Prompt=prompt,Name=it,IsFake=fake})
end
end
end
end
end
end
List=lst
end
local function clr()
for _,bg in pairs(Cache)do
if bg.Gui then pcall(function()bg.Gui:Destroy()end)end
end
table.clear(Cache)
List={}
end
RunService.Heartbeat:Connect(function()
local cam=Workspace.CurrentCamera
if not cam then return end
local map=Workspace:FindFirstChild("Map")
local curIng=map and map:FindFirstChild("Ingame")
if curIng~=lastIngame then
lastIngame=curIng
clr()
end
if not IC.Enabled then
for _,bg in pairs(Cache)do
if bg.Gui then bg.Gui.Enabled=false bg.Gui.Adornee=nil end
end
return
end
local now=tick()
if now-lastScan>=0.5 then
lastScan=now
upList()
end
local myRoot=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local origin=myRoot and myRoot.Position or cam.CFrame.Position
local active={}
for _,itm in ipairs(List)do
if itm.Root and itm.Root.Parent and itm.Instance and itm.Instance.Parent then
local dist=(origin-itm.Root.Position).Magnitude
if dist<=200*3.57 then
active[itm.Instance]=true
local bg=Cache[itm.Instance]
if not bg or not bg.Gui.Parent then
local bGui=Instance.new("BillboardGui")
bGui.Size=UDim2.fromOffset(200,20)
bGui.AlwaysOnTop=true
bGui.LightInfluence=0
bGui.StudsOffset=Vector3.new(0,1.4,0)
bGui.Parent=gui5
local lbl=Instance.new("TextLabel",bGui)
lbl.Size=UDim2.fromScale(1,1)
lbl.BackgroundTransparency=1
lbl.Font=Enum.Font.GothamBold
lbl.TextSize=12
lbl.TextStrokeTransparency=0
lbl.TextStrokeColor3=Color3.fromRGB(0,0,0)
Cache[itm.Instance]={Gui=bGui,Label=lbl}
bg=Cache[itm.Instance]
end
bg.Gui.Enabled=true
bg.Gui.Adornee=itm.Root
local mc
if itm.IsFake then mc=Color3.fromRGB(255,50,50)
elseif itm.Name=="可乐"then mc=Color3.fromRGB(255,195,45)
else mc=IC.Color end
local dm=math.floor(dist/3.57)
local s="["..itm.Name:upper().."]"
if IC.ShowDist then s=s.." • "..dm.."m"end
bg.Label.TextColor3=mc
bg.Label.Text=s
end
end
end
for i,c in pairs(Cache)do
if not active[i]then
if c.Gui then c.Gui.Enabled=false c.Gui.Adornee=nil end
if not i.Parent then
if c.Gui then pcall(function()c.Gui:Destroy()end)end
Cache[i]=nil
end
end
end
end)
Island:AddToggle("物品透视",false,function(v)
IC.Enabled=v
if not v then
for _,bg in pairs(Cache)do
if bg.Gui then bg.Gui.Enabled=false bg.Gui.Adornee=nil end
end
end
end)
Island:AddToggle("显示距离",true,function(v)IC.ShowDist=v end)
end

-- ═══════════ 发电机 ═══════════
local TGene=Island:AddTab("发电机")
Island:SelectTab(TGene)

do
local RS=game:GetService("ReplicatedStorage")
local Config={AutoCompleteGenerators=false,GeneratorHelper=false,InstantlyEnterGenerator=false,AutoGeneratorFarm=false,PuzzleDelay=0.08,LegitPuzzles=false,LegitPuzzleDelay=0.08,SelectedGenerator=1}
local RoundGenerators={}
local CurrentPuzzle=nil
local CompletingAll=false
local function IsKiller()
local ch=LocalPlayer.Character
if not ch then return false end
local pf=Workspace:FindFirstChild("Players")
local kf=pf and pf:FindFirstChild("Killers")
return kf~=nil and ch.Parent==kf
end
local function GetMap()
local map=Workspace:FindFirstChild("Map")
local ing=map and map:FindFirstChild("Ingame")
return ing and ing:FindFirstChild("Map")
end
local function UpdateGens()
local gm=GetMap()
if not gm then RoundGenerators={}return end
local g={}
for _,o in ipairs(gm:GetChildren())do
if o.Name=="Generator"then table.insert(g,o)end
end
RoundGenerators=g
end
task.spawn(function()
while task.wait(0.3)do UpdateGens()end
end)
local function GetClosest()
local ch=LocalPlayer.Character
local root=ch and ch:FindFirstChild("HumanoidRootPart")
if not root then return nil end
for i,gen in ipairs(RoundGenerators)do
local pos=gen:FindFirstChild("Positions")
local cen=pos and pos:FindFirstChild("Center")
if cen and(cen.Position-root.Position).Magnitude<=7 then return gen end
end
return nil
end
local function isOccupied(gen)
if not gen then return false end
local pos=gen:FindFirstChild("Positions")
local cen=pos and pos:FindFirstChild("Center")
if not cen then return false end
local function scan(f)
if not f then return false end
for _,p in ipairs(f:GetChildren())do
if p:GetAttribute("Username")~=LocalPlayer.Name then
local r=p:FindFirstChild("HumanoidRootPart")
if r and(cen.Position-r.Position).Magnitude<=40 then return true end
end
end
return false
end
return scan(Workspace:FindFirstChild("Players")and Workspace.Players:FindFirstChild("Survivors"))or scan(Workspace:FindFirstChild("Players")and Workspace.Players:FindFirstChild("Killers"))
end
local function autoSolve(p,force)
if not p or not p.Solution then return end
local function isNb(r1,c1,r2,c2)
return(r2==r1-1 and c2==c1)or(r2==r1+1 and c2==c1)or(r2==r1 and c2==c1-1)or(r2==r1 and c2==c1+1)
end
local function order(path,sp)
if not path or #path==0 then return path end
local st=(sp and sp[1])or path[1]
local lk={}
for _,p2 in ipairs(path)do lk[p2.row.."-"..p2.col]={row=p2.row,col=p2.col}end
local ord={}
local cur={row=st.row,col=st.col}
table.insert(ord,cur)
lk[cur.row.."-"..cur.col]=nil
while next(lk)do
local ad=false
for k,v in pairs(lk)do
if isNb(cur.row,cur.col,v.row,v.col)then
table.insert(ord,v)
lk[k]=nil
cur=v
ad=true
break
end
end
if not ad then break end
end
return ord
end
for i=1,#p.Solution do
local path=p.Solution[i]
local tp=p.targetPairs and p.targetPairs[i]
local ord=order(path,tp)
p.paths[i]={}
for _,pt in ipairs(ord)do
if not force and not Config.AutoCompleteGenerators then return end
table.insert(p.paths[i],{row=pt.row,col=pt.col})
pcall(function()p:updateGui()end)
if Config.LegitPuzzles then
local g=GetClosest()
if g and isOccupied(g)then task.wait(Config.LegitPuzzleDelay)else task.wait(Config.PuzzleDelay)end
else
task.wait(Config.PuzzleDelay)
end
end
pcall(function()p:checkForWin()end)
end
end
pcall(function()
local Flow=require(RS.Modules.Minigames.FlowGameManager.FlowGame)
local orig=Flow.new
local hooked
hooked=hookfunction(orig,newcclosure(function(...)
local p=hooked(...)
CurrentPuzzle=p
if Config.AutoCompleteGenerators then
task.spawn(function()pcall(autoSolve,p)end)
end
return p
end))
end)
task.spawn(function()
while task.wait(0.1)do
for _,gen in ipairs(RoundGenerators)do
local main=gen:FindFirstChild("Main")
local prompt=main and main:FindFirstChild("Prompt")
if prompt then prompt.HoldDuration=Config.InstantlyEnterGenerator and 0 or 0.25 end
end
end
end)
local function completeAll()
if CompletingAll then return end
if IsKiller()then return end
CompletingAll=true
task.spawn(function()
for _,gen in ipairs(RoundGenerators)do
local ch=LocalPlayer.Character
local root=ch and ch:FindFirstChild("HumanoidRootPart")
if not root then continue end
task.wait(0.3)
local prog=gen:FindFirstChild("Progress")
if not prog or prog.Value==100 then continue end
local main=gen:FindFirstChild("Main")
local prompt=main and main:FindFirstChild("Prompt")
if not prompt then continue end
local pos=gen:FindFirstChild("Positions")
if pos and pos:FindFirstChild("Center")then
root.CFrame=pos.Center.CFrame
end
task.wait(0.4)
local puzzleUI=LocalPlayer.PlayerGui:FindFirstChild("PuzzleUI")
if not(puzzleUI and puzzleUI.Enabled)then continue end
task.spawn(function()
local lp
while task.wait()and gen:FindFirstChild("Progress")and gen.Progress.Value~=100 and LocalPlayer.PlayerGui:FindFirstChild("PuzzleUI")do
if CurrentPuzzle==lp then continue end
lp=CurrentPuzzle
if not Config.AutoCompleteGenerators then pcall(autoSolve,CurrentPuzzle,true)end
end
end)
repeat task.wait()until not gen:FindFirstChild("Progress")or gen.Progress.Value==100 or not LocalPlayer.PlayerGui:FindFirstChild("PuzzleUI")
end
CompletingAll=false
end)
end
Island:AddToggle("自动绘制修机",false,function(v)Config.AutoCompleteGenerators=v end)
Island:AddToggle("瞬间进入发电机",false,function(v)Config.InstantlyEnterGenerator=v end)
Island:AddButton("自动完成所有发电机",function()completeAll()end)
Island:AddButton("完成当前发电机",function()
if not LocalPlayer.PlayerGui:FindFirstChild("PuzzleUI")then return end
task.spawn(function()
local gen=GetClosest()
if not gen then return end
local lp
while task.wait()and gen:FindFirstChild("Progress")and gen.Progress.Value~=100 and LocalPlayer.PlayerGui:FindFirstChild("PuzzleUI")do
if CurrentPuzzle==lp then continue end
lp=CurrentPuzzle
if not Config.AutoCompleteGenerators then pcall(autoSolve,CurrentPuzzle,true)end
end
end)
end)
Island:AddSlider("解谜速度",0.02,1,0.07,function(v)Config.PuzzleDelay=v end)
Island:AddDropdown("选择发电机",{"1","2","3","4","5"},"1",function(v)Config.SelectedGenerator=tonumber(v)or 1 end)
Island:AddButton("传送到发电机",function()
local gen=RoundGenerators[Config.SelectedGenerator]
local ch=LocalPlayer.Character
local root=ch and ch:FindFirstChild("HumanoidRootPart")
if gen and root then
local pos=gen:FindFirstChild("Positions")
local cen=pos and pos:FindFirstChild("Center")
if cen then root.CFrame=cen.CFrame end
end
end)
end

-- ═══════════ 幸存者 ═══════════
local TSurv=Island:AddTab("幸存者")
Island:SelectTab(TSurv)

-- 自动特技
do
local RS=game:GetService("ReplicatedStorage")
local VIM=game:GetService("VirtualInputManager")
local ok,VCfg=pcall(function()
return require(RS:WaitForChild("Assets"):WaitForChild("Survivors"):WaitForChild("Veeronica"):WaitForChild("Config"))
end)
local ok2,VBeh=pcall(function()
return RS:WaitForChild("Assets"):WaitForChild("Survivors"):WaitForChild("Veeronica"):WaitForChild("Behavior")
end)
local autoTr=false
local function isSkating()
local ch=LocalPlayer.Character
if not ch or ch.Name~="Veeronica"then return false end
if not ok2 or not VBeh then return false end
local h=VBeh:FindFirstChild("Highlight")
if not h or h.Adornee~=ch then return false end
return true
end
Island:AddToggle("自动特技",false,function(s)
autoTr=s
if s then
task.spawn(function()
while autoTr do
if isSkating()then
for i=1,2 do
VIM:SendKeyEvent(i<2,Enum.KeyCode.Space,false,game)
task.wait()
end
end
task.wait()
end
end)
end
end)
Island:AddToggle("Sk8控制",false,function(s)
if not ok or not VCfg then return end
VCfg.Sk8TurnControl=s and 6.5 or 0.65
end)
end

-- 自动背刺
do
local prox=8,behindDist=3.5,coneDeg=70,cd=5,lastTrig=0,aimRef=0
local enabled=false,dagEnabled=false
local backstabType="Lerp"
local rangeMode="Behind"
local function getChar()return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()end
local function getDagBtn()
local pg=LocalPlayer:FindFirstChild("PlayerGui")
local mui=pg and pg:FindFirstChild("MainUI")
local c=mui and mui:FindFirstChild("AbilityContainer")
return c and c:FindFirstChild("Dagger")
end
local function getCD()
local b=getDagBtn()
if not b then return nil end
return b:FindFirstChild("CooldownTime")or b:FindFirstChildWhichIsA("NumberValue")or b:FindFirstChildWhichIsA("StringValue")
end
local function readCD(o)
if not o then return nil end
if o:IsA("NumberValue")then return o.Value end
if o:IsA("StringValue")then return tonumber(o.Value)end
if o:IsA("TextLabel")or o:IsA("TextBox")then return tonumber(o.Text)end
return nil
end
local function getK()
local pf=Workspace:FindFirstChild("Players")
return pf and pf:FindFirstChild("Killers")
end
local function isValid(m)
if not m then return false end
local h=m:FindFirstChild("HumanoidRootPart")
local hum=m:FindFirstChildWhichIsA("Humanoid")
return h and hum and hum.Health and hum.Health>0
end
local function tryBtn(b)
if not b then return false end
pcall(function()if b.Activate then b:Activate()end end)
pcall(function()
local conns=getconnections(b.MouseButton1Click)
for _,c in ipairs(conns)do
pcall(function()if c.Function then c.Function()end end)
end
end)
return true
end
task.spawn(function()
while task.wait(0.05)do
if not enabled then continue end
local kf=getK()
if not kf then continue end
local ch=getChar()
local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
if not hrp then continue end
local trig=false
for _,k in pairs(kf:GetChildren())do
if trig then break end
if isValid(k)then
local khrp=k:FindFirstChild("HumanoidRootPart")
local dist=(khrp.Position-hrp.Position).Magnitude
if dist<=prox then
local ok2=false
local toP=(hrp.Position-khrp.Position).Unit
local back=-khrp.CFrame.LookVector
local dot=toP:Dot(back)
local thr=math.cos(math.rad(coneDeg))
ok2=dot>=thr
if(rangeMode=="Around"or ok2)and os.clock()-lastTrig>=cd then
local cdv=readCD(getCD())
if not(cdv and cdv>0.1)then
lastTrig=os.clock()
trig=true
task.spawn(function()
local hum=ch:FindFirstChildWhichIsA("Humanoid")
if hum then
hum.AutoRotate=false
local start=tick()
while tick()-start<0.45 do
if khrp and hrp then
local kcf=khrp.CFrame
local bp=kcf.Position-(kcf.LookVector.Unit*behindDist)
bp=Vector3.new(bp.X,kcf.Position.Y,bp.Z)
hrp.CFrame=hrp.CFrame:Lerp(CFrame.new(bp,bp+kcf.LookVector.Unit),0.55)
end
RunService.Heartbeat:Wait()
end
hum.AutoRotate=true
end
if dagEnabled then tryBtn(getDagBtn())end
end)
end
end
end
end
end
end
end)
Island:AddToggle("自动背刺",false,function(s)enabled=s end)
Island:AddToggle("背刺时自动攻击",false,function(s)dagEnabled=s end)
Island:AddDropdown("背刺类型",{"缓动位移","瞬移"},"缓动位移",function(v)
backstabType=(v=="缓动位移")and"Lerp"or"Teleport"
end)
Island:AddDropdown("范围模式",{"全范围","背后"},"背后",function(v)
rangeMode=(v=="全范围")and"Around"or"Behind"
end)
Island:AddSlider("检测范围",1,30,8,function(v)prox=v end)
Island:AddSlider("背后距离",0.5,10,3.5,function(v)behindDist=v end)
Island:AddSlider("背后锥角",10,180,70,function(v)coneDeg=v end)
end

-- 机会 / 自动抛硬币
do
local CFS={Enabled=false,TargetCharge=3}
local lastCF=0,2
local function readCharges()
local ok,txt=pcall(function()
local pg=LocalPlayer:FindFirstChild("PlayerGui")
local mui=pg and pg:FindFirstChild("MainUI")
local a=mui and mui:FindFirstChild("AbilityContainer")
local c=a and a:FindFirstChild("Reroll")
local l=c and c:FindFirstChild("Charges")
return l and tostring(l.Text)or nil
end)
return ok and txt or nil
end
task.spawn(function()
while true do
task.wait(0.5)
if not CFS.Enabled then continue end
local now=tick()
if now-lastCF<2 then continue end
local isChance=false
local pf=Workspace:FindFirstChild("Players")
local sf=pf and pf:FindFirstChild("Survivors")
if sf then
for _,s in ipairs(sf:GetChildren())do
if s:GetAttribute("Username")==LocalPlayer.Name and s.Name=="Chance"then
isChance=true break
end
end
end
if not isChance then continue end
local ch=tonumber(readCharges())
if ch and ch<CFS.TargetCharge then
lastCF=now
pcall(function()
game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer("UseActorAbility",{buffer.fromstring("\003\b\000\000\000CoinFlip")})
end)
end
end
end)
Island:AddToggle("自动抛硬币翻转",false,function(v)CFS.Enabled=v end)
Island:AddDropdown("硬币充能层数",{"1","2","3"},"3",function(v)CFS.TargetCharge=tonumber(v)end)
end

-- 自动挣脱
do
local AE=false,CD=0.5
Island:AddToggle("吸血鬼自动挣脱",false,function(s)AE=s end)
Island:AddSlider("挣脱间隔",0.1,1.5,0.5,function(v)CD=v end)
local function setup()
local pg=LocalPlayer:FindFirstChild("PlayerGui")
if not pg then return end
local tu=pg:FindFirstChild("TemporaryUI")
if not tu then
pg.ChildAdded:Connect(function(c)
if c.Name=="TemporaryUI"then setup()end
end)
return
end
tu.ChildAdded:Connect(function(ui)
if ui.Name:upper()=="QTE"and ui:FindFirstChildOfClass("UIAspectRatioConstraint")then
task.spawn(function()
while ui and ui.Visible and AE do
local c=CD
local half=c*0.2
local w=math.random()*(c+half-(c-half))+(c-half)
task.wait(w)
if not AE then break end
local pf=Workspace:FindFirstChild("Players")
local kf=pf and pf:FindFirstChild("Killers")
if kf then
for _,k in ipairs(kf:GetChildren())do
if k.Name:lower()=="nosferatu"then
local kp=Players:GetPlayerFromCharacter(k)
if kp then
local net=game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
local n=net and net:FindFirstChild("Network")
local n2=n and n:FindFirstChild("Network")
local re=n2 and n2:FindFirstChild("RemoteEvent")
if re then
re:FireServer(kp.Name.."NosHookQTE",{true})
end
end
end
end
end
end
end)
end
end)
end
task.spawn(function()
if LocalPlayer:FindFirstChild("PlayerGui")then setup()end
end)
end

-- ═══════════ 杀手 ═══════════
local TKill=Island:AddTab("杀手")
Island:SelectTab(TKill)

-- 碰撞箱扩展
do
local HE={enabled=false,range=10}
task.spawn(function()
while true do
RunService.Heartbeat:Wait()
if HE.enabled then
local ch=LocalPlayer.Character
local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
if not hrp then continue end
local det=false
local hf=Workspace:FindFirstChild("Hitboxes")
local un=ch:GetAttribute("Username")or LocalPlayer.Name
local hn=un.."Hitbox"
if hf and ch then
for _,p in ipairs(hf:GetChildren())do
if p.Name==hn then
if hrp and(p.Position-hrp.Position).Magnitude<=15 then
det=true
end
break
end
end
end
if det and ch and hrp and hrp.Parent then
local v=hrp.AssemblyLinearVelocity
if v.Magnitude>0.5 then
local d=HE.range*6
local md=v.Magnitude>0 and v.Unit or hrp.CFrame.LookVector
local nv=v+(md*d)
hrp.AssemblyLinearVelocity=Vector3.new(nv.X,v.Y,nv.Z)
RunService.RenderStepped:Wait()
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")then
LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity=v
end
end
end
end
end
end)
Island:AddToggle("碰撞箱扩展",false,function(v)HE.enabled=v end)
Island:AddSlider("碰撞箱长度",0,50,10,function(v)HE.range=math.floor(v)end)
end

-- 自瞄
do
local A={on=false,cooldown=0.3,lockTime=0.4,maxDist=30,smooth=0.35,targeting=false,target=nil,lastFired=0}
local function isKiller()
local ch=LocalPlayer.Character
if not ch then return false end
local kf=Workspace:FindFirstChild("Players")and Workspace.Players:FindFirstChild("Killers")
return kf and ch:IsDescendantOf(kf)
end
local function nearest()
local ch=LocalPlayer.Character
local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
if not hrp then return nil end
local sf=Workspace:FindFirstChild("Players")and Workspace.Players:FindFirstChild("Survivors")
if not sf then return nil end
local best,bd=nil,math.huge
for _,m in ipairs(sf:GetChildren())do
if m:IsA("Model")and m~=ch then
local hu=m:FindFirstChildOfClass("Humanoid")
local r=m:FindFirstChild("HumanoidRootPart")
if hu and r and hu.Health>0 then
local d=(r.Position-hrp.Position).Magnitude
if d<bd and d<=A.maxDist then bd=d best=r end
end
end
end
return best
end
RunService.RenderStepped:Connect(function()
if not A.on or not A.targeting or not A.target then return end
local ch=LocalPlayer.Character
local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
if not hrp then return end
if not A.target.Parent then A.targeting=false return end
local hu=A.target.Parent:FindFirstChildOfClass("Humanoid")
if not hu or hu.Health<=0 then A.targeting=false return end
local flat=Vector3.new(A.target.Position.X-hrp.Position.X,0,A.target.Position.Z-hrp.Position.Z)
if flat.Magnitude>0 then
flat=flat.Unit
hrp.CFrame=hrp.CFrame:Lerp(CFrame.new(hrp.Position,hrp.Position+flat),A.smooth)
end
end)
task.spawn(function()
while task.wait(0.1)do
if not A.on then continue end
if not isKiller()then continue end
local ch=LocalPlayer.Character
local hu=ch and ch:FindFirstChildOfClass("Humanoid")
if not hu then continue end
local attacking=false
for _,t in ipairs(hu:GetPlayingAnimationTracks())do
if t.TimePosition/t.Length<0.5 then attacking=true break end
end
if attacking and tick()-A.lastFired>=A.cooldown then
local t=nearest()
if t then
A.lastFired=tick()
A.targeting=true
A.target=t
local oh=hu.AutoRotate
hu.AutoRotate=false
task.delay(A.lockTime,function()
A.targeting=false
hu.AutoRotate=oh
end)
end
end
end
end)
Island:AddToggle("使用自瞄",false,function(v)A.on=v end)
Island:AddSlider("自瞄距离",5,100,30,function(v)A.maxDist=v end)
Island:AddSlider("平滑度",0.05,1,0.35,function(v)A.smooth=v end)
end

-- 自动格挡
do
local AB=false
local ABConns={}
local LB={}
local HP=Vector3.new(4.5,6,7.5)
local function getBtn(n)
local pg=LocalPlayer:FindFirstChild("PlayerGui")
local mui=pg and pg:FindFirstChild("MainUI")
local c=mui and mui:FindFirstChild("AbilityContainer")
return c and c:FindFirstChild(n)
end
local function press(b)
if not b then return false end
local cd=b:FindFirstChild("CooldownTime")
if cd and cd.Text~=""then return false end
pcall(function()b:Activate()end)
pcall(function()
local cc=getconnections(b.MouseButton1Click)
for _,c in ipairs(cc)do pcall(function()c:Fire()end)end
end)
return true
end
local function block()return press(getBtn("Block")or getBtn("Guard"))end
local function startDet(K,q)
local visual=Instance.new("Part")
visual.Size=HP
visual.Color=Color3.fromRGB(255,255,255)
visual.Material=Enum.Material.ForceField
visual.Transparency=0.5
visual.Anchored=true
visual.CanCollide=false
visual.Parent=Workspace:FindFirstChild("Hitboxes")or Workspace
local hp=Instance.new("SelectionBox")
hp.Adornee=visual
hp.Color3=Color3.fromRGB(255,255,255)
hp.LineThickness=0.01
hp.Parent=visual
local conn=RunService.Heartbeat:Connect(function()
if visual and visual.Parent and q and q.Parent then
visual.CFrame=q.CFrame*CFrame.new(0,0,-1.4)
else
conn:Disconnect()
end
end)
local lc=LocalPlayer.Character
if not lc then task.delay(1.5,function()
visual:Destroy()conn:Disconnect()
end)return end
local lq=lc:FindFirstChild("QueryHitbox")
if not lq then task.delay(1.5,function()
visual:Destroy()conn:Disconnect()
end)return end
local start=tick()
local hbConn
hbConn=RunService.Heartbeat:Connect(function()
if not AB or tick()-start>1.5 then
hbConn:Disconnect()
visual:Destroy()
conn:Disconnect()
return
end
if not q or not q.Parent then
hbConn:Disconnect()
visual:Destroy()
conn:Disconnect()
return
end
local pp=OverlapParams.new()
pp.MaxParts=1
pp.FilterType=Enum.RaycastFilterType.Include
pp.FilterDescendantsInstances={lq}
local pr=Instance.new("Part")
pr.Size=HP
pr.Anchored=true
pr.CanCollide=false
pr.Transparency=1
pr.CFrame=q.CFrame*CFrame.new(0,0,-1.4)
pr.Parent=Workspace:FindFirstChild("Hitboxes")or Workspace
local hits=Workspace:GetPartsInPart(pr,pp)
pr:Destroy()
if #hits>0 then
block()
hbConn:Disconnect()
visual:Destroy()
conn:Disconnect()
end
end)
end
local function enableAB()
if not AB then return end
for _,c in ipairs(ABConns)do pcall(function()c:Disconnect()end)end
ABConns={}
local pf=Workspace:FindFirstChild("Players")
local kf=pf and pf:FindFirstChild("Killers")
if not kf then return end
local function bind(K)
if not Players:GetPlayerFromCharacter(K)then return end
local q=K:FindFirstChild("QueryHitbox")
if not q then return end
local blockLocked=false
local a1=K:GetAttributeChangedSignal("AbilityLastUsed"):Connect(function()
if not blockLocked then startDet(K,q)else blockLocked=false end
end)
local a2=K:GetAttributeChangedSignal("AbilitiesUsed"):Connect(function()
blockLocked=true
end)
table.insert(ABConns,{Disconnect=function()a1:Disconnect()a2:Disconnect()end})
end
for _,K in ipairs(kf:GetChildren())do bind(K)end
table.insert(ABConns,kf.ChildAdded:Connect(bind))
end
Island:AddToggle("自动格挡",false,function(v)
AB=v
if v then enableAB()else
for _,c in ipairs(ABConns)do pcall(function()c:Disconnect()end)end
ABConns={}
end
end)
end

-- 防背刺（有蚊子）
do
local ABS={on=false,range=40,duration=1.5,locked=false}
local trig={["86710781315432"]=true,["99820161736138"]=true}
local function findTT()
local p=Workspace:FindFirstChild("Players")
if not p then return nil end
for _,f in ipairs(p:GetChildren())do
local t=f:FindFirstChild("TwoTime")
if t then return t end
end
return nil
end
local function trigger()
pcall(function()
if ABS.locked then return end
local ch=LocalPlayer.Character
local mr=ch and ch:FindFirstChild("HumanoidRootPart")
if not mr then return end
local tt=findTT()
if not tt then return end
local tr=tt:FindFirstChild("HumanoidRootPart")
if not tr then return end
if(mr.Position-tr.Position).Magnitude>ABS.range then return end
ABS.locked=true
task.spawn(function()
local dl=tick()+ABS.duration
while tick()<dl do
if not ABS.on then break end
local c=LocalPlayer.Character
local r=c and c:FindFirstChild("HumanoidRootPart")
if not r or not tr.Parent then break end
r.CFrame=CFrame.lookAt(r.Position,Vector3.new(tr.Position.X,r.Position.Y,tr.Position.Z))
RunService.RenderStepped:Wait()
end
ABS.locked=false
end)
end)
end
local conn
task.spawn(function()
conn=Workspace.DescendantAdded:Connect(function(o)
if not ABS.on then return end
if o:IsA("Sound")then
local id=o.SoundId:match("%d+")
if id and trig[id]then trigger()end
end
end)
end)
Island:AddToggle("防背刺",false,function(s)
ABS.on=s
if not s then ABS.locked=false end
end)
Island:AddSlider("防背刺范围",10,120,40,function(v)ABS.range=v end)
end

-- 杀死全部人
do
local KA={active=false,teleport=false,fly=false,flying=false,current=nil}
local function isKiller()
local ch=LocalPlayer.Character
if not ch then return false end
local kf=Workspace:FindFirstChild("Players")and Workspace.Players:FindFirstChild("Killers")
return kf and ch:IsDescendantOf(kf)
end
local function nearest()
local ch=LocalPlayer.Character
local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
if not hrp then return nil end
local sf=Workspace:FindFirstChild("Players")and Workspace.Players:FindFirstChild("Survivors")
if not sf then return nil end
local best,bd=nil,math.huge
for _,m in ipairs(sf:GetChildren())do
if m:IsA("Model")and m:FindFirstChild("Humanoid")and m.Humanoid.Health>0 then
local r=m:FindFirstChild("HumanoidRootPart")
if r then
local d=(r.Position-hrp.Position).Magnitude
if d<bd then bd=d best=m end
end
end
end
return best
end
local function goTo(t)
if t and t:FindFirstChild("HumanoidRootPart")then
local ch=LocalPlayer.Character
if not ch then return end
local hrp=ch:FindFirstChild("HumanoidRootPart")
if not hrp then return end
local tr=t.HumanoidRootPart
if KA.teleport then
local lv=tr.CFrame.LookVector
local p=tr.Position-lv*2.7+Vector3.new(0,1.5,0)
hrp.CFrame=CFrame.new(p)
hrp.CFrame=CFrame.lookAt(p,tr.Position)
else
ch.Humanoid:MoveTo(tr.Position)
end
end
end
task.spawn(function()
while task.wait()do
if KA.active and isKiller()then
if KA.current and(not KA.current.Parent or not KA.current:FindFirstChild("Humanoid")or KA.current.Humanoid.Health<=0)then
KA.current=nil
end
if not KA.current then
KA.current=nearest()
end
if KA.current then goTo(KA.current)end
end
end
end)
Island:AddToggle("击杀模式",false,function(v)
KA.active=v
if not v then
KA.current=nil
local ch=LocalPlayer.Character
if ch and ch:FindFirstChildOfClass("Humanoid")then
pcall(function()ch.Humanoid:MoveTo(ch.HumanoidRootPart.Position)end)
end
end
end)
Island:AddToggle("传送模式",false,function(v)KA.teleport=v end)
Island:AddButton("切换目标",function()KA.current=nearest()end)
end

-- 吸力
do
local SC={enabled=false,strength=50,maxDist=100}
task.spawn(function()
while RunService.RenderStepped:Wait()do
if not SC.enabled then continue end
local ch=LocalPlayer.Character
if not ch then continue end
local hrp=ch:FindFirstChild("HumanoidRootPart")
if not hrp then continue end
local sf=Workspace:FindFirstChild("Players")and Workspace.Players:FindFirstChild("Survivors")
if not sf then continue end
local best,bd=nil,math.huge
for _,m in ipairs(sf:GetChildren())do
if m~=ch and m:IsA("Model")then
local hu=m:FindFirstChildOfClass("Humanoid")
local r=m:FindFirstChild("HumanoidRootPart")
if hu and r and hu.Health>0 then
local d=(r.Position-hrp.Position).Magnitude
if d<bd and d<=SC.maxDist then bd=d best=r end
end
end
end
if best then
local dir=(best.Position-hrp.Position)
if dir.Magnitude>0.1 then
dir=dir.Unit
local v=hrp.AssemblyLinearVelocity
hrp.AssemblyLinearVelocity=v:Lerp(v+dir*SC.strength,0.3)
end
end
end
end)
Island:AddToggle("吸力",false,function(v)SC.enabled=v end)
Island:AddSlider("吸力强度",5,100,50,function(v)SC.strength=v end)
Island:AddSlider("搜索距离",20,200,100,function(v)SC.maxDist=v end)
end

-- ═══════════ 娱乐 ═══════════
local TFun=Island:AddTab("娱乐")
Island:SelectTab(TFun)

Island:AddButton("解锁全部角色和皮肤",function()
task.spawn(function()
local purchased=LocalPlayer:WaitForChild("PlayerData"):WaitForChild("Purchased")
local kf=purchased:FindFirstChild("Killers")or Instance.new("Folder",purchased)
kf.Name="Killers"
local sf=purchased:FindFirstChild("Survivors")or Instance.new("Folder",purchased)
sf.Name="Survivors"
local skf=purchased:FindFirstChild("Skins")or Instance.new("Folder",purchased)
skf.Name="Skins"
local assets=ReplicatedStorage:WaitForChild("Assets")
for _,k in ipairs(assets:WaitForChild("Killers"):GetChildren())do
if not kf:FindFirstChild(k.Name)then Instance.new("StringValue",kf).Name=k.Name end
end
for _,s in ipairs(assets:WaitForChild("Survivors"):GetChildren())do
if not sf:FindFirstChild(s.Name)then Instance.new("StringValue",sf).Name=s.Name end
end
for _,sk in ipairs(assets:WaitForChild("Skins"):GetDescendants())do
if(sk:IsA("Folder")or sk:IsA("Model"))and not skf:FindFirstChild(sk.Name)then
Instance.new("StringValue",skf).Name=sk.Name
end
end
end)
end)

Island:AddButton("解锁所有动作",function()
task.spawn(function()
local purchased=LocalPlayer:WaitForChild("PlayerData"):WaitForChild("Purchased")
local ef=purchased:FindFirstChild("Emotes")or Instance.new("Folder",purchased)
ef.Name="Emotes"
local e=ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Emotes")
for _,m in ipairs(e:GetDescendants())do
if m:IsA("ModuleScript")and not ef:FindFirstChild(m.Name)then
Instance.new("StringValue",ef).Name=m.Name
end
end
end)
end)

Island:AddButton("解锁VIP权限",function()
LocalPlayer:SetAttribute("VIP",true)
local pd=LocalPlayer:WaitForChild("PlayerData")
local v=pd:FindFirstChild("VIP")
if not v then
v=Instance.new("BoolValue")
v.Name="VIP"
v.Parent=pd
end
v.Value=true
end)

do
local stats={Money="钱",NetWorth="净资产",KillerChance="杀手几率",TimePlayed="游玩时间",KillerWins="杀手胜利",Kills="击杀数",SurvivorWins="幸存者胜利",ObjectivesCompleted="任务完成数"}
for sn,dn in pairs(stats)do
Island:AddInput("设置 "..dn,"",function(v)
pcall(function()
local st=LocalPlayer:FindFirstChild("PlayerData")and LocalPlayer.PlayerData:FindFirstChild("Stats")
if not st then return end
local o=st:FindFirstChild(sn,true)
if o and(o:IsA("NumberValue")or o:IsA("IntValue"))then
local n=tonumber(v)
if n then o.Value=n end
end
end)
end,"输入数值")
end
end

Island:SelectTab(TServer)
Island:Notify("xtal","加载完毕",3)
print("xtal 脚本加载完毕")
