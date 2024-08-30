local ButtonsFrame = script.Parent
local BaseFrame = script.Parent.Parent
local TextHint: TextLabel = script.Parent.Parent.TextHint
local FillInsertData = require(script.Parent.Parent.Parent.Parent.FillInsertData)
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ManageRequest = ReplicatedStorage:FindFirstChild('ManageRequest')

ManageRequest.OnClientEvent:Connect(function(status: string)
	if status == 'success' then
		FillInsertData.load()
	end
end)

local button1bring: TextButton = script.Parent:FindFirstChild('1BringButton')
local button2go: TextButton = script.Parent:FindFirstChild('2GoButton')
local button3respawn: TextButton = script.Parent:FindFirstChild('3RespawnButton')
local button4destroy: TextButton = script.Parent:FindFirstChild('4DestroyButton')

local function onButtonMouseEnter(button: TextButton, hint: string)
	button:FindFirstChild('UIGradient').Color = ColorSequence.new(Color3.fromRGB(148, 148, 148))
	TextHint.Text = hint
end

local function onButtonMouseLeave(button: TextButton, hint: string)
	button:FindFirstChild('UIGradient').Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
end

local function onFrameMouseLeave()
	TextHint.Text = ''
end

button1bring.MouseEnter:Connect(function(x, y)
	onButtonMouseEnter(button1bring, 'Bring car')
end)
button2go.MouseEnter:Connect(function(x, y)
	onButtonMouseEnter(button2go, 'Go to car')
end)
button3respawn.MouseEnter:Connect(function(x, y)
	onButtonMouseEnter(button3respawn, 'Respawn car')
end)
button4destroy.MouseEnter:Connect(function(x, y)
	onButtonMouseEnter(button4destroy, 'Destroy car')
end)
ButtonsFrame.MouseLeave:Connect(onFrameMouseLeave)
button1bring.MouseLeave:Connect(function(x, y)
	onButtonMouseLeave(button1bring, 'Bring car')
end)
button2go.MouseLeave:Connect(function(x, y)
	onButtonMouseLeave(button2go, 'Bring car')
end)
button3respawn.MouseLeave:Connect(function(x, y)
	onButtonMouseLeave(button3respawn, 'Bring car')
end)
button4destroy.MouseLeave:Connect(function(x, y)
	onButtonMouseLeave(button4destroy, 'Bring car')
end)

button1bring.Activated:Connect(function()
	ManageRequest:FireServer(script.Parent.Parent:GetAttribute('asset_special_id'), 'bring')
end)
button2go.Activated:Connect(function()
	ManageRequest:FireServer(script.Parent.Parent:GetAttribute('asset_special_id'), 'go')
end)
button3respawn.Activated:Connect(function()
	ManageRequest:FireServer(script.Parent.Parent:GetAttribute('asset_special_id'), 'respawn')
end)
button4destroy.Activated:Connect(function()
	ManageRequest:FireServer(script.Parent.Parent:GetAttribute('asset_special_id'), 'destroy')
end)