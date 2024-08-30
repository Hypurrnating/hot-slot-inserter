local button = script.Parent.TextButton
local inputBox = script.Parent.TextBox
local UtilitiesFrame = script.Parent.Parent
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ModelInsertFire = ReplicatedStorage:FindFirstChild("ModelInsertFire")
local GetRecords = ReplicatedStorage:FindFirstChild('GetRecords')
local FillInsertData = require(script.Parent.Parent.InsertedManager.FillInsertData)

local last_insert_req = nil

button.MouseButton1Click:Connect(function()
	last_insert_req = inputBox.Text
	ModelInsertFire:FireServer(inputBox.Text)
	inputBox.Text = ''
	inputBox.PlaceholderText = 'The server is working...'
end)

ModelInsertFire.OnClientEvent:Connect(function(payload)
	if payload['Player'].UserId ~= Players.LocalPlayer.UserId then
		return
	elseif payload['ReqID'] ~= last_insert_req then
		return
	elseif not payload['Success'] then
		inputBox.PlaceholderText = payload['msg']
		return
	end	
	
	inputBox.PlaceholderText = 'Success'
	FillInsertData.load()
end)