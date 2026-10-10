local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Main GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VirtualKeyboardGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Button Constructor Function
local function createButton(name, text, position, size)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Text = text
	btn.Position = position
	btn.Size = size
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextScaled = true
	btn.Font = Enum.Font.SourceSansBold
	btn.BackgroundTransparency = 0.3
	btn.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.2, 0)
	corner.Parent = btn
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.5
	stroke.Parent = btn
	
	return btn
end

-- Left Side (WASD Movement Keys)
local btnW = createButton("BtnW", "W", UDim2.new(0.12, 0, 0.58, 0), UDim2.new(0, 45, 0, 45))
local btnA = createButton("BtnA", "A", UDim2.new(0.06, 0, 0.67, 0), UDim2.new(0, 45, 0, 45))
local btnS = createButton("BtnS", "S", UDim2.new(0.12, 0, 0.67, 0), UDim2.new(0, 45, 0, 45))
local btnD = createButton("BtnD", "D", UDim2.new(0.18, 0, 0.67, 0), UDim2.new(0, 45, 0, 45))

-- Right Side (Mouse and Jump Buttons)
local btnRMB  = createButton("BtnRMB", "RMB", UDim2.new(0.72, 0, 0.70, 0), UDim2.new(0, 50, 0, 40))
local btnLMB  = createButton("BtnLMB", "LMB", UDim2.new(0.80, 0, 0.70, 0), UDim2.new(0, 50, 0, 40))
local btnJump = createButton("BtnJUMP", "JUMP", UDim2.new(0.88, 0, 0.70, 0), UDim2.new(0, 55, 0, 40))

-- Movement State Variables
local keysPressed = { W = false, A = false, S = false, D = false }

local function setupKeyEvents(button, key)
	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			keysPressed[key] = true
		end
	end)
	button.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			keysPressed[key] = false
		end
	end)
end

setupKeyEvents(btnW, "W")
setupKeyEvents(btnA, "A")
setupKeyEvents(btnS, "S")
setupKeyEvents(btnD, "D")

-- Jump Handler
btnJump.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		local character = player.Character
		if character and character:FindFirstChild("Humanoid") then
			character.Humanoid.Jump = true
		end
	end
end)

-- Continuous Render Loop for Character Movement
RunService.RenderStepped:Connect(function()
	local character = player.Character
	if character and character:FindFirstChild("Humanoid") then
		local x, z = 0, 0
		if keysPressed.W then z = z - 1 end
		if keysPressed.S then z = z + 1 end
		if keysPressed.A then x = x - 1 end
		if keysPressed.D then x = x + 1 end
		
		if x ~= 0 or z ~= 0 then
			character.Humanoid:Move(Vector3.new(x, 0, z), true)
		end
	end
end)
