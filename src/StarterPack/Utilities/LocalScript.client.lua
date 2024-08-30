local UtilitiesTool: Tool = script.Parent
local Backpack: Backpack = UtilitiesTool.Parent
local player: Player = Backpack.Parent
local ScreenGUI: ScreenGui = player.PlayerGui.ScreenGui
local UtilitiesFrame: GuiObject = ScreenGUI:FindFirstChild('UtilitiesFrame')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GetRecords = ReplicatedStorage:FindFirstChild('GetRecords')

UtilitiesTool.Equipped:Connect(function() 
	UtilitiesFrame.Visible = true
end)
UtilitiesTool.Unequipped:Connect(function()
	UtilitiesFrame.Visible = false
end)