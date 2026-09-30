local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local UserInputService=game:GetService("UserInputService")
local Stats=game:GetService("Stats")
local HttpService=game:GetService("HttpService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local TeleportService=game:GetService("TeleportService")
local Lighting=game:GetService("Lighting")
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
mT.Text="xtal v1.0"
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
mS.Text="Develop by xtal"
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
if openFrame then
openFrame:Destroy()
openFrame=nil
end
end
row.MouseButton1Click:Connect(function()
if openFrame then closeList()
return
end
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
drag=true
setV(inp.Position.X)
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
local Core,CharValue,AbilityRemote,ActionRemote,DashRemote
pcall(function()Core=require(ReplicatedStorage:WaitForChild("Core",3))end)
pcall(function()
local D=LocalPlayer:WaitForChild("Data",3)
if D then CharValue=D:WaitForChild("Character",3)end
end)
pcall(function()AbilityRemote=ReplicatedStorage:WaitForChild("Remotes",3):WaitForChild("Abilities",3):WaitForChild("Ability",3)end)
pcall(function()ActionRemote=ReplicatedStorage:WaitForChild("Remotes",3):WaitForChild("Combat",3):WaitForChild("Action",3)end)
pcall(function()DashRemote=ReplicatedStorage:WaitForChild("Remotes",3):WaitForChild("Character",3):WaitForChild("Dash",3)end)
local function Notify(t,d)pcall(function()Island:Notify(t,d)end)end
local lastDash=0
local IgFriend=false
local function getRoot(c)return c and c:FindFirstChild("HumanoidRootPart")end
local function getLRoot()return getRoot(LocalPlayer.Character)end
local function dash()
if not DashRemote then return end
local n=tick()
if n-lastDash<0.2 then return end
lastDash=n
local h=getLRoot()
if not h then return end
pcall(function()DashRemote:FireServer(h.CFrame,"L",h.CFrame.LookVector,nil,n)end)
end
local function sendWCA(targets)
if not CharValue or not AbilityRemote or not ActionRemote then return end
if #targets==0 then return end
local combo=ReplicatedStorage.Characters[CharValue.Value].WallCombo
if not combo then return end
local hl={}
for _,c in ipairs(targets)do
for i=1,20 do table.insert(hl,c)end
end
pcall(function()AbilityRemote:FireServer(combo,69)end)
pcall(function()
ActionRemote:FireServer(combo,"",4,69,{BestHitCharacter=nil,HitCharacters=hl,Ignore={},Actions={}})
end)
end
local function getTIR(rng)
local root=getLRoot()
if not root then return{}end
local ts={}
for _,p in ipairs(Players:GetPlayers())do
if p~=LocalPlayer and p.Character then
local skip=false
if IgFriend then
local ok,isF=pcall(function()return LocalPlayer:IsFriendsWith(p.UserId)end)
if ok and isF then skip=true end
end
if not skip then
local tr=getRoot(p.Character)
local h=p.Character:FindFirstChild("Humanoid")
if tr and h and h.Health>0 then
if(tr.Position-root.Position).Magnitude<=rng then
if not p.Character:GetAttribute("Invincible")then
table.insert(ts,p.Character)
end
end
end
end
end
end
return ts
end
local A1E=false
local A1C
local function auraTick()
dash()
local t=getTIR(100)
sendWCA(t)
end
local function SetAura1(s)
A1E=s
if A1C then A1C:Disconnect()
A1C=nil end
if s then
A1C=RunService.Heartbeat:Connect(auraTick)
Notify("杀戮光环 v3","已开启")
else
Notify("杀戮光环 v3","已关闭")
end
end
local A2E=false
local A2C
local A2List,A2I={},1
local A2LastDash=0
local function aura2Tick(cnt)
local h=getLRoot()
if not h then return end
if tick()-A2LastDash>0.25 then
A2LastDash=tick()
pcall(function()DashRemote:FireServer(h.CFrame,"L",h.CFrame.LookVector,nil,tick())end)
end
for _,p in ipairs(Players:GetPlayers())do
if p~=LocalPlayer and p.Character then
local skip=false
if IgFriend then
local ok,isF=pcall(function()return LocalPlayer:IsFriendsWith(p.UserId)end)
if ok and isF then skip=true end
end
if not skip then
local hu=p.Character:FindFirstChild("Humanoid")
local rt=p.Character:FindFirstChild("HumanoidRootPart")
if hu and rt and hu.Health>0 and(rt.Position-h.Position).Magnitude<=70 then
if not p.Character:GetAttribute("Invincible")then
for i=1,cnt do
A2List[A2I]=p.Character
A2I=A2I+1
end
end
end
end
end
end
if A2I>1 then
local combo=ReplicatedStorage.Characters[CharValue.Value].WallCombo
pcall(function()
AbilityRemote:FireServer(combo,69)
ActionRemote:FireServer(combo,"",4,69,{BestHitCharacter=nil,HitCharacters=A2List,Ignore={},Actions={}})
end)
table.clear(A2List)
A2I=1
end
end
local function SetAura2(s)
A2E=s
if A2C then A2C:Disconnect()
A2C=nil end
if s then
A2C=RunService.Heartbeat:Connect(function()
local cnt=(CharValue and CharValue.Value=="Gon")and 20 or 50
aura2Tick(cnt)
end)
Notify("杀戮光环 v3+","已开启")
else
Notify("杀戮光环 v3+","已关闭")
end
end
local W1E=false
local W1C
local function wcV1Tick()
if not Core then return end
local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
if not h then return end
local ht=false
for _,p in ipairs(Players:GetPlayers())do
if p~=LocalPlayer and p.Character then
local tr=getRoot(p.Character)
if tr and(tr.Position-h.Position).Magnitude<=100 then
ht=true
break
end
end
end
if not ht then return end
local hr=Core.Get("Combat","Hit").Box(nil,LocalPlayer.Character,{Size=Vector3.new(100,100,100)})
if not hr then return end
local ab=ReplicatedStorage.Characters[CharValue.Value].WallCombo
pcall(function()
Core.Get("Combat","Ability").Activate(ab,hr,h.Position+Vector3.new(0,0,2.5))
end)
end
local function SetWC1(s)
W1E=s
if W1C then W1C:Disconnect()
W1C=nil end
if s then
W1C=RunService.Heartbeat:Connect(wcV1Tick)
Notify("墙打光环 v3","已开启")
else
Notify("墙打光环 v3","已关闭")
end
end
local W2LastT,W2LastDash=0,0
local W2C,W2DC
local function wcV2Has(rng)
local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
if not h then return false end
for _,pl in ipairs(Players:GetPlayers())do
if pl~=LocalPlayer and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")then
if(pl.Character.HumanoidRootPart.Position-h.Position).Magnitude<=rng then
return true
end
end
end
return false
end
local function wcV2Exec()
if not Core then return end
local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
if not h then return end
local n=tick()
if n-W2LastT<0.05 then return end
if not wcV2Has(100)then return end
W2LastT=n
local res
local ok=pcall(function()
res=Core.Get("Combat","Hit").Box(nil,LocalPlayer.Character,{Size=Vector3.new(100,100,100)})
end)
if not ok or not res then return end
pcall(function()
Core.Get("Combat","Ability").Activate(ReplicatedStorage.Characters[CharValue.Value].WallCombo,res,h.Position+Vector3.new(0,0,2.5))
end)
end
local function wcV2Dash()
local h=getLRoot()
if not h then return end
local n=tick()
if n-W2LastDash<0.1 then return end
W2LastDash=n
pcall(function()DashRemote:FireServer(h.CFrame,"F",h.CFrame.LookVector,nil,n)end)
end
local function SetWC2(s)
if W2C then W2C:Disconnect()
W2C=nil end
if W2DC then W2DC:Disconnect()
W2DC=nil end
if s then
W2C=RunService.Heartbeat:Connect(wcV2Exec)
W2DC=RunService.Heartbeat:Connect(wcV2Dash)
Notify("墙打光环 v3+","已开启")
else
Notify("墙打光环 v3+","已关闭")
end
end
UserInputService.InputBegan:Connect(function(inp,pr)
if pr then return end
if inp.KeyCode==Enum.KeyCode.E then wcV2Exec()end
end)
local WudiE=false
local function wudi()
if not AbilityRemote or not ActionRemote or not CharValue then return end
local pc=LocalPlayer.Character
if not pc then return end
local h=pc:FindFirstChild("Head")
if not h then return end
local cn=CharValue.Value
if not cn then return end
local cf=ReplicatedStorage:FindFirstChild("Characters")
if not cf or not cf:FindFirstChild(cn)then return end
local ab=cf[cn]:FindFirstChild("WallCombo")
if not ab then return end
local an="Action"..math.random(1000,9999)
local rid=math.random(100000,999999)
local args={ab,"Characters:"..cn..":WallCombo",1,rid,{HitboxCFrames={nil},BestHitCharacter=pc,HitCharacters={pc},Ignore={[an]={pc}},DeathInfo={},Actions={[an]={}},HitInfo={Blocked=false,IsFacing=true,IsInFront=true},BlockedCharacters={},ServerTime=tick(),FromCFrame=nil},an}
pcall(function()AbilityRemote:FireServer(ab,rid)end)
pcall(function()ActionRemote:FireServer(unpack(args))end)
end
task.spawn(function()
while task.wait(0.01)do
if WudiE then pcall(wudi)end
end
end)
local IRE=false
local savedPos=nil
local hW,rH
local hasT=false
local function iReset()
local c=LocalPlayer.Character
if not c then return end
if type(replicatesignal)=="function"then
replicatesignal(LocalPlayer.Kill)
return
end
c:BreakJoints()
end
local function stopIR()
if hW then hW:Disconnect()
hW=nil end
if rH then rH:Disconnect()
rH=nil end
end
local function startIR()
stopIR()
hW=RunService.Heartbeat:Connect(function()
if not IRE then return end
local c=LocalPlayer.Character
if c then
local hu=c:FindFirstChild("Humanoid")
local rp=c:FindFirstChild("HumanoidRootPart")
if hu and rp then
local hs=tostring(math.floor(hu.Health))
if string.sub(hs,1,1)=="0"and not hasT then
hasT=true
savedPos=rp.CFrame
iReset()
elseif string.sub(hs,1,1)~="0"then
hasT=false
end
end
end
end)
rH=LocalPlayer.CharacterAdded:Connect(function(c)
if not IRE or not savedPos then return end
local rp=c:WaitForChild("HumanoidRootPart",5)
if not rp then return end
task.wait(0.2)
pcall(function()
require(LocalPlayer.PlayerScripts.Character.FullCustomReplication).Override(c,savedPos)
end)
savedPos=nil
end)
end
local ABE=false
task.spawn(function()
local ok,re=pcall(function()
return ReplicatedStorage:WaitForChild("Remotes",5):WaitForChild("Combat",5):WaitForChild("Block",5)
end)
if not ok or not re then return end
while true do
task.wait(0.1)
if ABE then pcall(function()re:FireServer(true)end)end
end
end)
local ct={}
local cAnims={["rbxassetid://15853335966"]=true,["rbxassetid://17561546657"]=true}
local ACE=false
local function hookC(ch,p)
local h=ch:WaitForChild("Humanoid",5)
if not h then return end
h.AnimationPlayed:Connect(function(t)
if not ACE then return end
local a=t.Animation and t.Animation.AnimationId
if a and cAnims[a]then
ct[p]=true
t.Stopped:Connect(function()ct[p]=nil end)
end
end)
end
task.spawn(function()
for _,p in ipairs(Players:GetPlayers())do
if p.Character then hookC(p.Character,p)end
p.CharacterAdded:Connect(function(c)hookC(c,p)end)
end
Players.PlayerAdded:Connect(function(p)
p.CharacterAdded:Connect(function(c)hookC(c,p)end)
end)
pcall(function()
local hit=require(LocalPlayer.PlayerScripts.Combat.Hit)
local ob=hit.Box
hit.Box=function(...)
local r1,r2,r3,r4=ob(...)
if ACE then
local p1=Players:GetPlayerFromCharacter(r1)
if p1 and ct[p1]then r1=nil end
if r2 and type(r2)=="table"then
for i=#r2,1,-1 do
local p2=Players:GetPlayerFromCharacter(r2[i])
if p2 and ct[p2]then table.remove(r2,i)end
end
end
end
return r1,r2,r3,r4
end
end)
end)
local origBox
local HB={X=40,Y=40,Z=40,M="Override",V=false}
local function applyHB(on)
if not Core then return end
local cb
local ok=pcall(function()cb=Core.Get("Combat","Hit")end)
if not ok or not cb then return end
if on then
if not origBox then origBox=cb.Box end
if not origBox then return end
cb.Box=function(...)
local a={...}
if not a[3]or type(a[3])~="table"then return origBox(...)end
local sz
if HB.M=="Add"then
local o=a[3].Size or Vector3.new()
sz=Vector3.new(o.X+HB.X,o.Y+HB.Y,o.Z+HB.Z)
else sz=Vector3.new(HB.X,HB.Y,HB.Z)end
if HB.V then
local cf=a[3].CFrame or a[3].cf
if not cf and typeof(a[2])=="CFrame"then cf=a[2]end
if not cf then cf=getLRoot()and getLRoot().CFrame or CFrame.new()end
local pt=Instance.new("Part")
pt.Anchored=true
pt.CanCollide=false
pt.Material=Enum.Material.ForceField
pt.Color=Color3.fromRGB(255,0,0)
pt.Transparency=0.7
pt.Size=sz
pt.CFrame=cf
pt.CastShadow=false
pt.Parent=workspace
game:GetService("Debris"):AddItem(pt,0.08)
end
local bt,vt=origBox(a[1],a[2],{Size=sz})
return bt,vt
end
elseif origBox then
cb.Box=origBox
end
end
local EspOn,EspC,EspUC,EspD=false,nil,nil,{}
local EspConf={TeamCheck=false,FriendCheck=false,ShowName=true,ShowDistance=true,ShowHealthBar=true,ShowHealthText=true,ShowBox=true,ShowBoxFill=true,ShowChams=false,ShowTracer=false,MaxDistance=1000,BoxColor=Color3.fromRGB(255,255,255),BoxFillColor=Color3.fromRGB(0,0,0),BoxFillTransparency=0.5,BoxThickness=2,NameColor=Color3.fromRGB(255,255,255),DistanceColor=Color3.fromRGB(200,200,200),HealthBarWidth=3,ChamsColor=Color3.fromRGB(255,0,0),ChamsOutlineColor=Color3.fromRGB(255,255,255),ChamsTransparency=0.5,TracerColor=Color3.fromRGB(255,255,255),TracerOrigin="Bottom",HealthBasedColor=true}
local function makeEsp(p)
if p==LocalPlayer or EspD[p]then return end
local B=Drawing.new("Square")
B.Thickness=EspConf.BoxThickness
B.Filled=false
B.Transparency=1
B.Visible=false
local BF=Drawing.new("Square")
BF.Thickness=1
BF.Filled=true
BF.Transparency=EspConf.BoxFillTransparency
BF.Visible=false
local N=Drawing.new("Text")
N.Size=13
N.Center=true
N.Outline=true
N.OutlineColor=Color3.fromRGB(0,0,0)
N.Transparency=1
N.Visible=false
local D=Drawing.new("Text")
D.Size=12
D.Center=true
D.Outline=true
D.OutlineColor=Color3.fromRGB(0,0,0)
D.Transparency=1
D.Visible=false
local HBg=Drawing.new("Square")
HBg.Thickness=1
HBg.Color=Color3.fromRGB(0,0,0)
HBg.Filled=true
HBg.Transparency=0.5
HBg.Visible=false
local HB2=Drawing.new("Square")
HB2.Thickness=1
HB2.Filled=true
HB2.Transparency=1
HB2.Visible=false
local HT=Drawing.new("Text")
HT.Size=10
HT.Center=true
HT.Outline=true
HT.OutlineColor=Color3.fromRGB(0,0,0)
HT.Transparency=1
HT.Visible=false
local Ch=Instance.new("Highlight")
Ch.FillColor=EspConf.ChamsColor
Ch.OutlineColor=EspConf.ChamsOutlineColor
Ch.FillTransparency=EspConf.ChamsTransparency
Ch.OutlineTransparency=0
Ch.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
Ch.Adornee=nil
Ch.Parent=workspace
Ch.Enabled=false
local Tr=Drawing.new("Line")
Tr.Thickness=1
Tr.Transparency=1
Tr.Visible=false
EspD[p]={B=B,BF=BF,N=N,D=D,HBg=HBg,HB2=HB2,HT=HT,Ch=Ch,Tr=Tr}
end
local function getSB(c)
local cam=workspace.CurrentCamera
if not cam then return nil end
local mnX,mnY,mxX,mxY=math.huge,math.huge,-math.huge,-math.huge
local av=false
for _,pt in ipairs(c:GetDescendants())do
if pt:IsA("BasePart")and pt.Transparency<1 then
local ps,on=cam:WorldToViewportPoint(pt.Position)
if on then
av=true
mnX=math.min(mnX,ps.X)
mnY=math.min(mnY,ps.Y)
mxX=math.max(mxX,ps.X)
mxY=math.max(mxY,ps.Y)
end
end
end
if not av then return nil end
return{MinX=mnX,MinY=mnY,MaxX=mxX,MaxY=mxY,Width=mxX-mnX,Height=mxY-mnY,CenterX=(mnX+mxX)/2,CenterY=(mnY+mxY)/2}
end
local function shouldShow(p)
if p==LocalPlayer then return false end
if EspConf.TeamCheck and p.Team==LocalPlayer.Team then return false end
if EspConf.FriendCheck then
local ok,isF=pcall(function()return LocalPlayer:IsFriendsWith(p.UserId)end)
if ok and isF then return false end
end
return true
end
local function updateEsp()
local cam=workspace.CurrentCamera
if not cam then return end
local vs=cam.ViewportSize
local bc=Vector2.new(vs.X/2,vs.Y)
for p,d in pairs(EspD)do
local c=p and p.Character
local hu=c and c:FindFirstChildOfClass("Humanoid")
local rt=c and c:FindFirstChild("HumanoidRootPart")
if hu and hu.Health>0 and rt and shouldShow(p)then
local dist=(cam.CFrame.Position-rt.Position).Magnitude
local b=getSB(c)
if b and b.Width>0 and b.Height>0 and dist<=EspConf.MaxDistance then
local hp=hu.Health/hu.MaxHealth
local col=EspConf.BoxColor
if EspConf.HealthBasedColor then
if hp>0.5 then col=Color3.fromRGB(0,255,0)
elseif hp>0.25 then col=Color3.fromRGB(255,255,0)
else col=Color3.fromRGB(255,0,0)end
end
if EspConf.ShowBox then
d.B.Position=Vector2.new(b.MinX,b.MinY)
d.B.Size=Vector2.new(b.Width,b.Height)
d.B.Color=col
d.B.Thickness=EspConf.BoxThickness
d.B.Visible=true
else d.B.Visible=false end
if EspConf.ShowBoxFill then
d.BF.Position=Vector2.new(b.MinX+1,b.MinY+1)
d.BF.Size=Vector2.new(b.Width-2,b.Height-2)
d.BF.Color=EspConf.BoxFillColor
d.BF.Transparency=EspConf.BoxFillTransparency
d.BF.Visible=true
else d.BF.Visible=false end
if EspConf.ShowName then
d.N.Text=p.Name
d.N.Color=EspConf.NameColor
d.N.Position=Vector2.new(b.CenterX,b.MinY-16)
d.N.Visible=true
else d.N.Visible=false end
if EspConf.ShowDistance then
d.D.Text="["..math.floor(dist).."m]"
d.D.Color=EspConf.DistanceColor
d.D.Position=Vector2.new(b.CenterX,b.MaxY+4)
d.D.Visible=true
else d.D.Visible=false end
if EspConf.ShowHealthBar then
d.HBg.Position=Vector2.new(b.MinX-EspConf.HealthBarWidth-2,b.MinY)
d.HBg.Size=Vector2.new(EspConf.HealthBarWidth,b.Height)
d.HBg.Visible=true
d.HB2.Position=Vector2.new(b.MinX-EspConf.HealthBarWidth-2,b.MaxY-b.Height*hp)
d.HB2.Size=Vector2.new(EspConf.HealthBarWidth,b.Height*hp)
d.HB2.Color=col
d.HB2.Visible=true
else
d.HBg.Visible=false
d.HB2.Visible=false
end
if EspConf.ShowHealthText then
d.HT.Text=math.floor(hp*100).."%"
d.HT.Color=col
d.HT.Position=Vector2.new(b.MinX-EspConf.HealthBarWidth-12,b.CenterY)
d.HT.Visible=true
else d.HT.Visible=false end
if EspConf.ShowChams then
d.Ch.Adornee=c
d.Ch.FillColor=EspConf.ChamsColor
d.Ch.OutlineColor=EspConf.ChamsOutlineColor
d.Ch.FillTransparency=EspConf.ChamsTransparency
d.Ch.Enabled=true
else d.Ch.Enabled=false end
if EspConf.ShowTracer then
local org=EspConf.TracerOrigin=="Top"and Vector2.new(bc.X,0)or bc
d.Tr.From=org
d.Tr.To=Vector2.new(b.CenterX,b.CenterY)
d.Tr.Color=EspConf.TracerColor
d.Tr.Visible=true
else d.Tr.Visible=false end
else
d.B.Visible=false
d.BF.Visible=false
d.N.Visible=false
d.D.Visible=false
d.HBg.Visible=false
d.HB2.Visible=false
d.HT.Visible=false
d.Ch.Enabled=false
d.Tr.Visible=false
end
else
if d then
d.B.Visible=false
d.BF.Visible=false
d.N.Visible=false
d.D.Visible=false
d.HBg.Visible=false
d.HB2.Visible=false
d.HT.Visible=false
d.Ch.Enabled=false
d.Tr.Visible=false
end
end
end
end
local function clearEsp()
for _,d in pairs(EspD)do
for _,dr in pairs(d)do
pcall(function()
if dr.Remove then dr:Remove()
elseif dr.Destroy then dr:Destroy()end
end)
end
end
EspD={}
end
local function startEsp()
EspOn=true
for _,p in ipairs(Players:GetPlayers())do makeEsp(p)end
EspC=Players.PlayerAdded:Connect(function(p)task.wait(1)makeEsp(p)end)
EspUC=RunService.RenderStepped:Connect(updateEsp)
end
local function stopEsp()
EspOn=false
if EspC then EspC:Disconnect()
EspC=nil end
if EspUC then EspUC:Disconnect()
EspUC=nil end
clearEsp()
end
local function disEff(p)
for _,v in ipairs(p:GetDescendants())do
if v:IsA("ParticleEmitter")or v:IsA("Trail")or v:IsA("Beam")or v:IsA("Fire")or v:IsA("Smoke")or v:IsA("Explosion")then v.Enabled=false
elseif v:IsA("Decal")or v:IsA("Texture")then v.Transparency=1
elseif v:IsA("SurfaceGui")or v:IsA("BillboardGui")then v.Enabled=false end
end
end
local function enEff(p)
for _,v in ipairs(p:GetDescendants())do
if v:IsA("ParticleEmitter")or v:IsA("Trail")or v:IsA("Beam")or v:IsA("Fire")or v:IsA("Smoke")or v:IsA("Explosion")then v.Enabled=true
elseif v:IsA("Decal")or v:IsA("Texture")then v.Transparency=0
elseif v:IsA("SurfaceGui")or v:IsA("BillboardGui")then v.Enabled=true end
end
end
local function alTick()
disEff(workspace)
Lighting.GlobalShadows=false
Lighting.FogEnd=9e9
local sk=Lighting:FindFirstChildOfClass("Sky")
if sk then
sk.SkyboxBk=""
sk.SkyboxDn=""
sk.SkyboxFt=""
sk.SkyboxLf=""
sk.SkyboxRt=""
sk.SkyboxUp=""
sk.SunAngularSize=0
sk.MoonAngularSize=0
end
end
local ALOn,ALC=false,nil
local function setAL(s)
ALOn=s
if s then
alTick()
if not ALC then
ALC=task.spawn(function()
while ALOn do
alTick()
task.wait(0.5)
end
end)
end
Notify("防卡","已开启")
else
if ALC then task.cancel(ALC)
ALC=nil end
enEff(workspace)
Lighting.GlobalShadows=true
Lighting.FogEnd=1000
Notify("防卡","已关闭")
end
end
local SpdE,SpdM,SpdC=false,2,nil
local function setSpd(s,m)
SpdE=s
SpdM=m
if s then
if not SpdC then
SpdC=RunService.RenderStepped:Connect(function(dt)
if not SpdE then return end
local c=LocalPlayer.Character
if not c then return end
local hu=c:FindFirstChildOfClass("Humanoid")
local rt=c:FindFirstChild("HumanoidRootPart")
if hu and rt and hu.MoveDirection.Magnitude>0 then
rt.CFrame=rt.CFrame+hu.MoveDirection*((SpdM-1)*16)*dt
end
end)
end
Notify("移动加速","已开启 x"..tostring(SpdM))
else
if SpdC then SpdC:Disconnect()
SpdC=nil end
Notify("移动加速","已关闭")
end
end
local FLYING=false
local FLYState=false
local flyKD,flyKU,flyC
local iyfs=2
local vfs=2
local function flyRoot(c)return c:FindFirstChild("HumanoidRootPart")or c:FindFirstChild("Torso")or c:FindFirstChild("UpperTorso")end
local function NOFLY()
FLYING=false
if flyKD then flyKD:Disconnect()
flyKD=nil end
if flyKU then flyKU:Disconnect()
flyKU=nil end
if flyC then flyC:Disconnect()
flyC=nil end
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
pcall(function()workspace.CurrentCamera.CameraType=Enum.CameraType.Custom end)
end
local function sFLY(vf)
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
local cam=workspace.CurrentCamera
local mv=Vector3.new(CT.L+CT.R,CT.Q+CT.E,CT.F+CT.B)
local ok,cm=pcall(function()
return require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
end)
if ok and cm then
local m=cm:GetMoveVector()
mv=Vector3.new(m.X*(vf and vfs or iyfs),mv.Y,-m.Z*(vf and vfs or iyfs))
end
BV.Velocity=(cam.CFrame.RightVector*mv.X+Vector3.new(0,mv.Y,0)+cam.CFrame.LookVector*mv.Z)*50
BG.CFrame=cam.CFrame
hu.PlatformStand=true
end)
end
local function applyFly()
sFLY()
LocalPlayer.CharacterAdded:Connect(function()
if FLYState then
task.wait(0.5)
sFLY()
end
end)
end
local LG={SelectedName=nil,IsFollowing=false,Mode=nil,Target=nil,Conn=nil}
local LGT="最近"
local LGK="NIL"
local QLGK="NIL"
local function findNear()
local c=LocalPlayer.Character
local r=c and c:FindFirstChild("HumanoidRootPart")
if not r then return nil end
local o=r.Position
local n,bd=nil,math.huge
for _,p in ipairs(Players:GetPlayers())do
if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart")then
local d=(p.Character.HumanoidRootPart.Position-o).Magnitude
if d<bd then bd,n=d,p end
end
end
return n
end
local function loopF()
if not LG.IsFollowing then return end
local t=LG.Target
if not t or not t.Character or not t.Character:FindFirstChild("HumanoidRootPart")then
LG.IsFollowing=false
if LG.Conn then LG.Conn:Disconnect()
LG.Conn=nil end
return
end
local mc=LocalPlayer.Character
local mr=mc and mc:FindFirstChild("HumanoidRootPart")
if not mr then return end
local cf=t.Character.HumanoidRootPart.CFrame*CFrame.new(0,0.1,4)
pcall(function()
require(LocalPlayer.PlayerScripts.Character.FullCustomReplication).Override(mc,cf)
end)
end
LG.Stop=function()
LG.IsFollowing=false
LG.Target=nil
LG.Mode=nil
if LG.Conn then LG.Conn:Disconnect()
LG.Conn=nil end
Notify("环绕","已停止")
end
LG.StartWithTarget=function(t,m)
if not t then return end
LG.Target=t
LG.Mode=m
LG.IsFollowing=true
if LG.Conn then LG.Conn:Disconnect()end
LG.Conn=RunService.Heartbeat:Connect(loopF)
Notify("环绕","跟随中: "..t.Name)
end
UserInputService.InputBegan:Connect(function(inp,gp)
if gp or not inp.KeyCode then return end
if LGK~="NIL"and inp.KeyCode.Name==LGK then
if not LG.IsFollowing then
local t
if LGT=="最近"or LGT=="closest"then t=findNear()
else t=Players:FindFirstChild(LGT)end
if t then LG.StartWithTarget(t,"selected")else Notify("环绕","无目标")end
else LG.Stop()end
end
if QLGK~="NIL"and inp.KeyCode.Name==QLGK then
if not LG.IsFollowing or LG.Mode~="quick"then
local n=findNear()
if n then LG.StartWithTarget(n,"quick")end
else LG.Stop()end
end
end)
Players.PlayerRemoving:Connect(function(p)if p==LG.Target then LG.Stop()end end)
local sl1On,sl1Pos=false,nil
local sl2On,sl2C=false,nil
local function lagger2()
if not AbilityRemote or not ActionRemote or not CharValue then return end
local pc=LocalPlayer.Character
if not pc then return end
local h=pc:FindFirstChild("Head")
if not h then return end
local cV=CharValue.Value
if not cV then return end
local cf=ReplicatedStorage:FindFirstChild("Characters")
if not cf or not cf:FindFirstChild(cV)then return end
local wc=cf[cV]:FindFirstChild("WallCombo")
if not wc then return end
local ch=workspace:FindFirstChild("Characters")
if not ch then return end
local np=ch:FindFirstChild("NPCs")
if not np then return end
local bum=np:FindFirstChild("The Ultimate Bum")
if not bum then return end
for _=1,100 do
local an="Action"..math.random(1000,9999)
local st=tick()
local rid=math.random(100000,999999)
local args={wc,"Characters:"..cV..":WallCombo",1,rid,{HitboxCFrames={nil},BestHitCharacter=bum,HitCharacters={bum},Ignore={[an]={bum}},DeathInfo={},Actions={[an]={}},HitInfo={Blocked=false,IsFacing=true,IsInFront=true},BlockedCharacters={},ServerTime=st,FromCFrame=nil},an}
pcall(function()AbilityRemote:FireServer(wc,rid)end)
pcall(function()ActionRemote:FireServer(unpack(args))end)
end
end
local aslOn,aslC=false,nil
local aslCache={}
local function phantom(p,ch)
if not aslOn then return end
local d=aslCache[p]
if not d or d.isPhantom then return end
d.isPhantom=true
local h=ch:FindFirstChildOfClass("Humanoid")
if h then h.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None end
local r=ch:FindFirstChild("HumanoidRootPart")
if r then r.Anchored=true end
for _,x in ipairs(ch:GetDescendants())do
if x:IsA("BasePart")then
if not d.ot[x]then d.ot[x]=x.Transparency end
x.Transparency=1
end
end
end
local function restore(p,ch)
local d=aslCache[p]
if not d or not d.isPhantom then return end
d.isPhantom=false
local r=ch and ch:FindFirstChild("HumanoidRootPart")
if r then r.Anchored=false end
for x,ot in pairs(d.ot)do
if x and x.Parent then x.Transparency=ot end
end
d.ot={}
end
local function updASL()
if not aslOn then return end
if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart")then return end
local pos=LocalPlayer.Character.HumanoidRootPart.Position
for p,d in pairs(aslCache)do
local ch=p.Character
if not ch or not ch:FindFirstChild("HumanoidRootPart")then
if d.isPhantom then restore(p,ch)end
else
if(pos-ch.HumanoidRootPart.Position).Magnitude>20000 then phantom(p,ch)
else restore(p,ch)end
end
end
end
local function setIT(s)
local cfg=ReplicatedStorage:FindFirstChild("Settings")
if cfg and cfg:FindFirstChild("Toggles")and cfg.Toggles:FindFirstChild("InstantTransformation")then
cfg.Toggles.InstantTransformation.Value=s
end
Notify("瞬开大招",s and"已开启"or"已关闭")
end
local function setIU(s)
local cfg=ReplicatedStorage:FindFirstChild("Settings")
if cfg and cfg:FindFirstChild("Multipliers")and cfg.Multipliers:FindFirstChild("UltimateTimer")then
cfg.Multipliers.UltimateTimer.Value=s and 100000 or 1
end
Notify("无限觉醒",s and"已开启"or"已关闭")
end
local TC=Island:AddTab("战斗")
Island:SelectTab(TC)
Island:AddToggle("杀戮光环 v3",false,function(s)SetAura1(s)end)
Island:AddToggle("杀戮光环 v3+",false,function(s)SetAura2(s)end)
Island:AddToggle("墙打光环 v3",false,function(s)SetWC1(s)end)
Island:AddToggle("墙打光环 v3+",false,function(s)SetWC2(s)end)
Island:AddToggle("无敌",false,function(s)WudiE=s
Notify("无敌",s and"已开启"or"已关闭")end)
Island:AddToggle("忽略好友",false,function(s)IgFriend=s end)
local TH=Island:AddTab("Hitbox")
Island:SelectTab(TH)
Island:AddToggle("开启范围扩展",false,function(s)applyHB(s)end)
Island:AddDropdown("扩展方式",{"覆盖","叠加"},"覆盖",function(t)HB.M=(t=="叠加")and"Add"or"Override"end)
Island:AddSlider("横向尺寸",1,250,40,function(v)HB.X=v end)
Island:AddSlider("纵向尺寸",1,250,40,function(v)HB.Y=v end)
Island:AddSlider("前后尺寸",1,250,40,function(v)HB.Z=v end)
Island:AddToggle("显示判定框",false,function(s)HB.V=s end)
local TE=Island:AddTab("透视")
Island:SelectTab(TE)
Island:AddToggle("玩家透视",false,function(s)
if s then startEsp()Notify("玩家透视","已开启")else stopEsp()Notify("玩家透视","已关闭")end
end)
Island:AddToggle("队伍检测",false,function(s)EspConf.TeamCheck=s end)
Island:AddToggle("好友检测",false,function(s)EspConf.FriendCheck=s end)
Island:AddSlider("最大显示距离",100,5000,1000,function(v)EspConf.MaxDistance=v end)
Island:AddToggle("显示方框",true,function(s)EspConf.ShowBox=s end)
Island:AddToggle("方框填充",true,function(s)EspConf.ShowBoxFill=s end)
Island:AddToggle("显示名字",true,function(s)EspConf.ShowName=s end)
Island:AddToggle("显示距离",true,function(s)EspConf.ShowDistance=s end)
Island:AddToggle("显示血条",true,function(s)EspConf.ShowHealthBar=s end)
Island:AddToggle("显示血量百分比",true,function(s)EspConf.ShowHealthText=s end)
Island:AddToggle("显示高亮",false,function(s)EspConf.ShowChams=s end)
Island:AddToggle("显示追踪线",false,function(s)EspConf.ShowTracer=s end)
Island:AddToggle("血量变色",true,function(s)EspConf.HealthBasedColor=s end)
Island:AddSlider("方框粗细",1,5,2,function(v)EspConf.BoxThickness=v end)
Island:AddSlider("血条宽度",1,8,3,function(v)EspConf.HealthBarWidth=v end)
Island:AddDropdown("追踪线起点",{"顶部","底部"},"底部",function(t)EspConf.TracerOrigin=(t=="顶部")and"Top"or"Bottom"end)
local TCh=Island:AddTab("人物")
Island:SelectTab(TCh)
Island:AddToggle("移动加速",false,function(s)setSpd(s,SpdM)end)
Island:AddSlider("加速倍率",1,10,2,function(v)
SpdM=v
if SpdE then setSpd(true,v)end
end)
Island:AddToggle("防卡",false,function(s)setAL(s)end)
Island:AddToggle("飞行",false,function(s)
FLYState=s
if s then applyFly()
Notify("飞行","已开启")
else NOFLY()
Notify("飞行","已关闭")end
end)
Island:AddSlider("飞行速度",1,10,2,function(v)
iyfs=v
vfs=v
end)
local TO=Island:AddTab("环绕")
Island:SelectTab(TO)
local orbitNames={"最近"}
for _,p in ipairs(Players:GetPlayers())do
if p~=LocalPlayer then table.insert(orbitNames,p.Name)end
end
Island:AddDropdown("环绕目标",orbitNames,"最近",function(t)
LGT=(t=="最近")and"closest"or t
LG.SelectedName=t
end)
Island:AddButton("刷新玩家列表",function()
local newNames={"最近"}
for _,p in ipairs(Players:GetPlayers())do
if p~=LocalPlayer then table.insert(newNames,p.Name)end
end
Island:Notify("环绕","已刷新(重新切换Tab查看)")
end)
Island:AddInput("环绕按键","NIL",function(t)LGK=t end,"NIL")
Island:AddInput("快速环绕按键","NIL",function(t)QLGK=t end,"NIL")
Island:AddToggle("跟随已选玩家",false,function(v)
if v then
local n=LG.SelectedName
local t=n and Players:FindFirstChild(n)or nil
if t then LG.StartWithTarget(t,"selected")else Notify("环绕","未选玩家")end
else
if LG.Mode=="selected"then LG.Stop()end
end
end)
Island:AddToggle("快速环绕",false,function(v)
if v then
local n=findNear()
if n then LG.StartWithTarget(n,"quick")else Notify("环绕","无玩家")end
else
if LG.Mode=="quick"then LG.Stop()end
end
end)
local THel=Island:AddTab("Helper")
Island:SelectTab(THel)
Island:AddToggle("瞬开大招",false,function(s)setIT(s)end)
Island:AddToggle("无限觉醒",false,function(s)setIU(s)end)
Island:AddToggle("瞬时复活",false,function(s)
IRE=s
if s then startIR()else stopIR()end
Notify("瞬时复活",s and"已开启"or"已关闭")
end)
Island:AddToggle("自动格挡",false,function(s)ABE=s
Notify("自动格挡",s and"已开启"or"已关闭")end)
Island:AddToggle("反反击",false,function(s)ACE=s
Notify("反反击",s and"已开启"or"已关闭")end)
local TSL=Island:AddTab("服务器延迟")
Island:SelectTab(TSL)
Island:AddToggle("服务器延迟 方法一",false,function(v)
if v then
sl1On=true
local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if h then sl1Pos=h.CFrame
h.CollisionGroup="None"end
task.spawn(function()
while sl1On do
local c=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if c then
pcall(function()
DashRemote:FireServer(unpack({[1]=CFrame.new(0,0,0),[2]="R",[3]=nil,[5]=nil}))
end)
task.wait()
c.CFrame=CFrame.new(870,4.6,460)
task.wait()
c.CFrame=CFrame.new(9e9,4.6,9e9)
else task.wait()end
end
end)
Notify("延迟方法一","已开启")
else
sl1On=false
local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if h then
h.CFrame=CFrame.new(0,-120,0)
task.wait(0.2)
if sl1Pos then h.CFrame=sl1Pos end
h.CollisionGroup="Characters"
end
Notify("延迟方法一","已关闭")
end
end)
Island:AddToggle("服务器延迟 方法二",false,function(v)
if v then
sl2On=true
sl2C=RunService.Heartbeat:Connect(function()
if sl2On then pcall(lagger2)end
end)
Notify("延迟方法二","已开启")
else
sl2On=false
if sl2C then sl2C:Disconnect()
sl2C=nil end
Notify("延迟方法二","已关闭")
end
end)
Island:AddToggle("反服务器延迟",false,function(v)
if v then
aslOn=true
for _,p in ipairs(Players:GetPlayers())do
if p~=LocalPlayer then
aslCache[p]={isPhantom=false,ot={}}
p.CharacterAdded:Connect(function()
task.wait(1)
aslCache[p]={isPhantom=false,ot={}}
end)
end
end
Players.PlayerAdded:Connect(function(p)
if p~=LocalPlayer then
aslCache[p]={isPhantom=false,ot={}}
p.CharacterAdded:Connect(function()
task.wait(1)
aslCache[p]={isPhantom=false,ot={}}
end)
end
end)
Players.PlayerRemoving:Connect(function(p)aslCache[p]=nil end)
aslC=RunService.RenderStepped:Connect(updASL)
Notify("反服务器延迟","已开启")
else
aslOn=false
if aslC then aslC:Disconnect()
aslC=nil end
for p,d in pairs(aslCache)do
if d.isPhantom and p.Character then restore(p,p.Character)end
end
aslCache={}
Notify("反服务器延迟","已关闭")
end
end)
local TU=Island:AddTab("实用")
Island:SelectTab(TU)
Island:AddButton("重进服务器",function()
TeleportService:Teleport(game.PlaceId,LocalPlayer)
Notify("服务器","正在重进")
end)
Island:AddButton("服务器跳转",function()
local ok,s=pcall(function()
return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
end)
if not ok then Notify("失败","获取服务器失败")
return end
local v={}
for _,x in pairs(s.data or{})do
if x.playing<x.maxPlayers and x.id~=game.JobId then table.insert(v,x.id)end
end
if #v>0 then
TeleportService:TeleportToPlaceInstance(game.PlaceId,v[math.random(#v)],LocalPlayer)
Notify("服务器","正在跳转")
else
Notify("失败","无可用服务器")
end
end)
Island:SelectTab(TC)
Island:Notify("xtal","加载完毕",3)
print("xtal 脚本加载完毕")
