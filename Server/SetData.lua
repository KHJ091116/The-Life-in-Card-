local DataStore = game:GetService("DataStoreService")
local ProjectData = DataStore:GetDataStore("RovinciCode")
local Players = game:GetService("Players")
local Default_Value = {
	["Coint"] = 0,
	["Rating"] = 100
}
game:GetService("Players").PlayerAdded:Connect(function(plr)
	local Data = ProjectData:GetAsync(tostring(plr.UserId))
	if not Data then 
		Data = Default_Value
		ProjectData:SetAsync(tostring(plr.UserId), Default_Value)
	end
	
	local StarterGui = game:GetService("StarterGui")
	local ValueFolder = Instance.new("Folder",plr)
	local Coint,Rating = Instance.new("IntValue",ValueFolder),Instance.new("IntValue",ValueFolder)
	ValueFolder.Name = "Stats"
	Coint.Name = "Coint"
	Rating.Name = "Rating"
	Coint.Value = Data["Coint"]
	Rating.Value = Data["Rating"]
	
	-- Changed-Update
	local Coint = plr:WaitForChild("Stats"):WaitForChild("Coint")
	local Rating = plr:WaitForChild("Stats"):WaitForChild("Rating")
	Coint:GetPropertyChangedSignal("Value"):Connect(function()
		ProjectData:SetAsync(tostring(plr.UserId), {
			["Coint"] = plr.Stats.Coint.Value,
			["Rating"] = plr.Stats.Rating.Value
		})
	end)
	Rating:GetPropertyChangedSignal("Value"):Connect(function()
		ProjectData:SetAsync(tostring(plr.UserId), {
			["Coint"] = plr.Stats.Coint.Value,
			["Rating"] = plr.Stats.Rating.Value
		})
	end)
end)

Players.PlayerRemoving:Connect(function(plr)
	ProjectData:SetAsync(tostring(plr.UserId), {
		["Coint"] = plr.Stats.Coint.Value,
		["Rating"] = plr.Stats.Rating.Value
	})
end)