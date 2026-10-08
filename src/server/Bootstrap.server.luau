--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lifecycle = require(ReplicatedStorage.Shared.Util.Lifecycle)
local RuntimeService = require(script.Parent.Common.RuntimeService)
local units = { RuntimeService }
local tower = script.Parent:FindFirstChild("Tower")
if tower then
	for _, unit in require(script.Parent.Tower.Services) do
		table.insert(units, unit)
	end
end
Lifecycle.run(units)
