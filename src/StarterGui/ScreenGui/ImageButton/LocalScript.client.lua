local player: Player = game:GetService("Players").LocalPlayer or game:GetService("Players"):FindFirstChildOfClass("Player")
local ScreenGUI: ScreenGui = player.PlayerGui.ScreenGui
local UtilitiesFrame: GuiObject = ScreenGUI:FindFirstChild('UtilitiesFrame')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GetRecords = ReplicatedStorage:FindFirstChild('GetRecords')

script.Parent.MouseButton1Click:Connect(function()
	UtilitiesFrame.Visible = true
end)