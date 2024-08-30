-- HTTP REQUESTS MUST BE ENABLED IN EXPERIENCE !
local HttpService = game:GetService("HttpService")
local InsertService = game:GetService("InsertService")
local MarketPlaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService('Players')

local ModelInsertFire = ReplicatedStorage:FindFirstChild("ModelInsertFire")
local BindableFunction = script.Parent
local BindableRemoteFunction = ReplicatedStorage:FindFirstChild('GetRecords')
local NewInsert = script.Parent.NewInsert
local ManageRequest = ReplicatedStorage:FindFirstChild('ManageRequest')
local records = {}

-- This is cool-down that users need to wait before spawning the next car
local debounce = 10
-- These are the webhook URLs that will be used to send the notifications. You can use both Discord and Guilded webhooks.
local post_urls = {
	[1] = '',
	[2] = '',
	[3] = '',
}

-- You can either use the parents bindable function to get records data, or (if you are a client) use the the child remote function which will do it for you
local function cloneRecords(player: Player)
	local _data = {}
	if player then
		for k, v in pairs(records) do
			if k ~= player.UserId then
				continue
			end
			_data[k] = v
		end
		table.freeze(_data)
	else
		for k, v in pairs(records) do
			_data[k] = v
		end
		table.freeze(_data)
	end
	return _data
end
BindableFunction.OnInvoke = cloneRecords
BindableRemoteFunction.OnServerInvoke = cloneRecords

ManageRequest.OnServerEvent:Connect(function(player: Player, asset_special_id: string, action: string)
	local player_records = records[player.UserId]
	for utc, insert_data in pairs(player_records) do
		if insert_data['Model']:GetAttribute('SpecialID') == asset_special_id then
			if action == 'bring' then
				insert_data['Model']:GetChildren()[1]:PivotTo(player.Character.HumanoidRootPart.CFrame + Vector3.new(5, 5, 0))
			end
			if action == 'go' then
				player.Character:MoveTo((insert_data['Model']:GetChildren()[1]:GetPivot().Position))
			end
			if action == 'respawn' then
				local now_utc = DateTime.now().UnixTimestamp
				-- Debounce
				for index, data in pairs(records[player.UserId]) do
					if data['utc'] > (now_utc - debounce) then
						print('bouncing')
						return
					end
				end
				
				-- Proceed with respawn
				for index, data in records[player.UserId] do
					if data['Model']:GetAttribute('SpecialID') == asset_special_id then
						local car_position = insert_data['Model']:GetChildren()[1]:GetPivot()
						insert_data['Model']:GetChildren()[1]:destroy()
						local success, model: Model = pcall(InsertService.LoadAsset, InsertService, insert_data['ID'])
						if success then
							records[player.UserId][index]['Model'] = model
							records[player.UserId][index]['utc'] = now_utc
							records[player.UserId][#records[player.UserId]+1] = records[player.UserId][index]
							records[player.UserId][index] = nil
							model.Parent = workspace
							model:SetAttribute('SpecialID', tostring(DateTime.now().UnixTimestamp) .. '|' .. tostring(insert_data['ID']))
							model:PivotTo(car_position)
						end
					end
				end
				print(records[player.UserId])
			end
			if action == 'destroy' then
				insert_data['Model']:GetChildren()[1]:Destroy()
				for utc, data in records[player.UserId] do
					if data['Model']:GetAttribute('SpecialID') == asset_special_id then
						table.remove(records[player.UserId], utc)
					end
				end
			end
		end
		ManageRequest:FireClient(player, 'success')
	end
end)



local function constructWebhookData(Player: Player, ModelID: string, asset)
	local Data = {
		["embeds"] = {{
			title = tostring(Player.Name .. " Inserted"),
			description = "UTC at: " .. tostring(DateTime.now().UnixTimestamp),
			footer = {
				text = "These are just notifications, and are not necessarily hard proof. \nhttps://github.com/Hypurrnating/hot-slot-inserter/" .. "\n"
			},
			fields = {
				{name = '__Asset Info__', value = " ", inline = false},
				{
					name = 'Asset ID',
					value = tostring(ModelID) or "nil",
					inline = true
				},
				{
					name = 'Asset Name',
					value = tostring(asset.Name) or "nil",
					inline = true
				},
				{
					name = 'Asset Created At',
					value = tostring(asset.Created),
					inline = true
				},
				{
					name = 'Asset Updated At',
					value = tostring(asset.Updated),
					inline = true
				},
				{
					name = 'Asset Creator ID',
					value = tostring(asset.Creator.CreatorTargetId) or "nil",
					inline = true
				},
				{name = '__Inserted by/Player Info__', value = " ", inline = false},
				{
					name = 'Player ID',
					value =tostring(Player.UserId) or "nil",
					inline = true
				},
				{
					name = 'Player Username',
					value = tostring(Player.Name) or "nil",
					inline = true
				},
				{
					name = 'Player Displayname',
					value = tostring(Player.DisplayName) or "nil",
					inline = true
				},
				{name = '__Game Info__', value = " ", inline = false},
				{
					name = 'Game ID',
					value = tostring(game.GameId) or "nil",
					inline = true
				},
				{
					name = 'Game Creator ID',
					value = tostring(game.CreatorId) or "nil",
					inline = true
				},
				{
					name = 'Game Creator Type',
					value = tostring(game.CreatorType) or "nil",
					inline = true
				},
				{
					name = 'Game Job ID',
					value = tostring(game.JobId) or "nil",
					inline = true
				}
			}
		}}
	}
	local data = HttpService:JSONEncode(Data)
	return data
end

local function postToWebhook(url: string, data: string)
	local success, message = pcall(HttpService.PostAsync, HttpService, url, data)
	return success, message
end

ModelInsertFire.OnServerEvent:Connect(function(Player, ModelID)	
	-- Get the users spawn history
	local now_utc = DateTime.now().UnixTimestamp
	local record = records[Player.UserId]
	if record then
		-- Iterate over all spawns, and if spawning too quickly, ignore
		for index, data in pairs(record) do
			if data['utc'] > (now_utc - debounce) then
				print('Bouncing')
				
				local notif_data = {
					['Success'] = false,
					['ReqID'] = ModelID,
					['Player'] = Player,
					['msg'] = 'Wait '..tostring((data['utc']+10)-now_utc)..' more seconds'
				}
				ModelInsertFire:FireClient(Player, notif_data)
				return
			end
		end
	else
		-- Just create a empty table and assign it; help prevent errors further down
		records[Player.UserId] = {}
	end

	-- Append to the users spawn history
	-- Load model into game
	local success, model: Model = pcall(InsertService.LoadAsset, InsertService, ModelID)
	if success and model then
		model.Parent = workspace
		model:SetAttribute('SpecialID', tostring(now_utc) .. '|' .. tostring(ModelID))
		model:PivotTo(Player.Character.HumanoidRootPart.CFrame + Vector3.new(5, 5, 0))

		local success, product = pcall(MarketPlaceService.GetProductInfo, MarketPlaceService, ModelID)
		if not success then
			-- Create empty object to prevent errors
			product = {['Name'] = '', ['Created'] = '', ['Updated'] = ''}
			product['Creator'] = {['CreatorTargetId'] = ''}
		end
		
		table.insert(records[Player.UserId], {['utc'] = now_utc, ['ID'] = ModelID, ['Model'] = model, ['Product'] = product})

		local data = constructWebhookData(Player, ModelID, product)
		for index, url in pairs(post_urls) do
			local success, message = postToWebhook(url, data)
			print('Posted to webhook: ' .. tostring(success) .. " | " .. tostring(message))
		end

		local notif_data = {
			['Success'] = true,
			['ReqID'] = ModelID,
			['Model'] = model,
			['Product'] = product,
			['Player'] = Player,
			['utc'] = now_utc}

		ModelInsertFire:FireClient(Player, notif_data)
		NewInsert:Fire(notif_data)
	else
		local notif_data = {
			['Success'] = false,
			['ReqID'] = ModelID,
			['Player'] = Player,
			['msg'] = tostring(model)
		}
		ModelInsertFire:FireClient(Player, notif_data)
	end

end)
