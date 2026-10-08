--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Definitions = require("./Definitions")
local Net = {}
function Net.init()
	local folder = ReplicatedStorage:FindFirstChild("Net")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "Net"
		folder.Parent = ReplicatedStorage
	end
	for name in Definitions do
		if not folder:FindFirstChild(name) then
			local remote = Instance.new("RemoteEvent")
			remote.Name = name
			remote.Parent = folder
		end
	end
end
function Net.get(name: string): RemoteEvent
	assert(Definitions[name] ~= nil, "Unknown remote")
	return ReplicatedStorage:WaitForChild("Net"):WaitForChild(name) :: RemoteEvent
end
return Net
