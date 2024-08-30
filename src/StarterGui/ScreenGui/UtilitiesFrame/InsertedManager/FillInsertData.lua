-- im ngl, this needs to be rewritten and cleaned up

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GetRecords = ReplicatedStorage:FindFirstChild('GetRecords')
local UtilitiesFrame = script.Parent.Parent
local SlotInserts = UtilitiesFrame.InsertedManager.SlotInserts

local module = {}

-- insane that this isnt a builtin function
local function getKeys(_table: table)
	local _keys = {}
	for k, v in pairs(_table) do
		_keys[#_keys+1] = k
	end
	return _keys
end
local function find(_table: table, value: any)
	-- Search table for specified value, and return boolean
	for k, v in pairs(_table) do
		if v == value then
			return true
		end
	end
	return false
end

local function refresh()
	local records = GetRecords:InvokeServer()
	local existing = {}
	for index, child in pairs(SlotInserts:GetChildren()) do
		if child:IsA('Frame') then
			existing[#existing+1] = child
		end
	end
	local insertsByID: table = {}
	local existingByID: table = {}
	local toInsert = {}
	
	-- Sort insert data and the ones present in GUI by ID
	for user_id, inserts in pairs(records) do
		for index, data in pairs(inserts) do
			insertsByID[data['Model']:GetAttribute('SpecialID')] = data
		end
	end
	for index, exist in pairs(existing) do
		local asset_special_id = exist:GetAttribute('asset_special_id')
		if asset_special_id then
			existingByID[asset_special_id] = exist
		end
	end
	
	-- Add the cars to GUI here if they arent already are in the GUI
	for user_id, inserts in pairs(records) do
		for index, data in pairs(inserts) do
			-- if this model already exists in GUI, ignore. else add to GUI
			if find(getKeys(existingByID), data['Model']:GetAttribute('SpecialID')) then
				continue
			end
			-- Load into frame
			local BaseFrame = SlotInserts:FindFirstChild('BaseFrame')
			local Frame = BaseFrame:Clone()
			Frame:FindFirstChild('TextLabel').Text = data['Product']['Name']
			Frame:FindFirstChild('ImageLabel').Image = 'rbxthumb://type=Asset&id='.. tostring(data['ID']) ..'&w=420&h=420'
			Frame:SetAttribute('asset_special_id', data['Model']:GetAttribute('SpecialID'))
			Frame.Visible = true
			Frame.Parent = SlotInserts
		end
	end
	
	-- clear deleted models from GUI that no longer exist in player's real records
	for index, frame in pairs(existing) do
		if frame:GetAttribute('asset_special_id') == '' then
			continue
		end
		if not find(getKeys(insertsByID), frame:GetAttribute('asset_special_id')) then
			frame:Destroy()
		end
	end
end

local function loadData()
	local records = GetRecords:InvokeServer()
	for user_id, inserts in pairs(records) do
		for utc, insert_data in pairs(inserts) do
			-- Append asset special ids to a list, then check that list and see if the current asset has already been filled into gui
			local _filled = SlotInserts:GetChildren()
			local filled_ids = {}
			for index, insert: Frame in pairs(_filled) do
				table.insert(filled_ids, insert:GetAttribute('asset_special_id'))
			end
			if table.find(filled_ids, insert_data['Model']:GetAttribute('SpecialID')) then
				continue
			end
				

		end
	end
end
module.load = refresh

return module
