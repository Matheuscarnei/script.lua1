---------------------------------------------------
-- CONFIG
---------------------------------------------------

getgenv().AutoFarm = false

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

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

			local hrp =
				char:FindFirstChild("HumanoidRootPart")

			if not hum or not hrp then
				continue
			end

			local box = getNearestBox()

			if box then

				hum:MoveTo(box.Position)

			end
		end
	end
end)

---------------------------------------------------
-- GUI
---------------------------------------------------

pcall(function()
	CoreGui:FindFirstChild("BoxFarmGui"):Destroy()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "BoxFarmGui"
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,180,0,80)
frame.Position = UDim2.new(0.5,-90,0.8,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Parent = gui

local button = Instance.new("TextButton")
button.Size = UDim2.new(1,-20,1,-20)
button.Position = UDim2.new(0,10,0,10)
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(40,40,40)
button.TextColor3 = Color3.new(1,1,1)
button.Text = "AUTO FARM: OFF"
button.Parent = frame

button.MouseButton1Click:Connect(function()

	getgenv().AutoFarm =
		not getgenv().AutoFarm

	if getgenv().AutoFarm then
		button.Text = "AUTO FARM: ON"
	else
		button.Text = "AUTO FARM: OFF"
	end
end)
