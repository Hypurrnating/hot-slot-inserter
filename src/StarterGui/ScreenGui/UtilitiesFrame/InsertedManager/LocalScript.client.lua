local UtilitiesFrame = script.Parent.Parent
local SlotInserts = UtilitiesFrame.InsertedManager.SlotInserts
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GetRecords = ReplicatedStorage:FindFirstChild('GetRecords')
local FillInsertData = require(script.Parent.FillInsertData)

UtilitiesFrame.Changed:Connect(function(property:string)
	if property == 'Visible' then
		if UtilitiesFrame.Visible then
			FillInsertData.load()
		end
	end
end)
