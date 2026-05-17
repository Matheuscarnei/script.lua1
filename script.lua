---------------------------------------------------
-- CONFIG
---------------------------------------------------

getgenv().AutoFarm = false

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

---------------------------------------------------
-- PEGAR CAIXA MAIS PRÓXIMA
---------------------------------------------------

local function getNearestBox()

	local char = player.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local nearest = nil
	local shortest = math.huge

	for _,v in pairs(workspace:GetDescendants()) do

		if v:IsA("MeshPart")
		and v.Name == "Base"
		and v.Transparency < 1
		then

			local dist =
				(v.Position - hrp.Position).Magnitude

			if dist < shortest then
				shortest = dist
				nearest = v
			end
		end
	end

	return nearest
end

---------------------------------------------------
-- AUTO FARM
---------------------------------------------------

task.spawn(function()

	while task.wait(0.2) do

		if getgenv().AutoFarm then

			local char = player.Character
			if not char then continue end

			local hum =
				char:FindFirstChildOfClass("Humanoid")

			if not hum then continue end

			local box = getNearestBox()

			if box then
				hum:MoveTo(box.Position)
			end
		end
	end
end)

---------------------------------------------------
-- REMOVER GUI ANTIGA
---------------------------------------------------

pcall(function()
	CoreGui:FindFirstChild("WLT_BoxFarm"):Destroy()
end)

---------------------------------------------------
-- GUI
---------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "WLT_BoxFarm"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

---------------------------------------------------
-- BOTÃO ABRIR
---------------------------------------------------

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0,60,0,60)
openBtn.Position = UDim2.new(0,20,0.5,-30)
openBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.TextScaled = true
openBtn.Font = Enum.Font.GothamBold
openBtn.Text = "WLT"
openBtn.Parent = gui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1,0)
openCorner.Parent = openBtn

---------------------------------------------------
-- PAINEL
---------------------------------------------------

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,260,0,170)
frame.Position = UDim2.new(0.5,-130,0.5,-85)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = false
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0,12)
frameCorner.Parent = frame

---------------------------------------------------
-- TOPO
---------------------------------------------------

local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,35)
top.BackgroundColor3 = Color3.fromRGB(35,35,35)
top.Parent = frame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0,12)
topCorner.Parent = top

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "WLT AUTO FARM"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = top

---------------------------------------------------
-- FECHAR
---------------------------------------------------

local close = Instance.new("TextButton")
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,2)
close.BackgroundTransparency = 1
close.Text = "X"
close.TextColor3 = Color3.new(1,0.3,0.3)
close.Font = Enum.Font.GothamBold
close.TextScaled = true
close.Parent = top

---------------------------------------------------
-- BOTÃO FARM
---------------------------------------------------

local farmBtn = Instance.new("TextButton")
farmBtn.Size = UDim2.new(1,-20,0,50)
farmBtn.Position = UDim2.new(0,10,0,60)
farmBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
farmBtn.TextColor3 = Color3.new(1,1,1)
farmBtn.Font = Enum.Font.GothamBold
farmBtn.TextScaled = true
farmBtn.Text = "AUTO FARM: OFF"
farmBtn.Parent = frame

local farmCorner = Instance.new("UICorner")
farmCorner.CornerRadius = UDim.new(0,10)
farmCorner.Parent = farmBtn

---------------------------------------------------
-- ABRIR / FECHAR
---------------------------------------------------

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

close.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

---------------------------------------------------
-- AUTO FARM BOTÃO
---------------------------------------------------

farmBtn.MouseButton1Click:Connect(function()

	getgenv().AutoFarm =
		not getgenv().AutoFarm

	if getgenv().AutoFarm then

		farmBtn.Text = "AUTO FARM: ON"
		farmBtn.BackgroundColor3 =
			Color3.fromRGB(0,170,0)

	else

		farmBtn.Text = "AUTO FARM: OFF"
		farmBtn.BackgroundColor3 =
			Color3.fromRGB(45,45,45)
	end
end)

---------------------------------------------------
-- ARRASTAR PAINEL
---------------------------------------------------

local dragging = false
local dragStart
local startPos

top.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.Touch
		or
		input.UserInputType ==
		Enum.UserInputType.MouseButton1
	then

		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()

			if input.UserInputState ==
				Enum.UserInputState.End
			then
				dragging = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)

	if dragging and (
		input.UserInputType ==
		Enum.UserInputType.Touch
		or
		input.UserInputType ==
		Enum.UserInputType.MouseMovement
	) then

		local delta =
			input.Position - dragStart

		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
