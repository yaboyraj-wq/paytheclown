--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lifecycle = require(ReplicatedStorage:WaitForChild("Shared").Util.Lifecycle)
local RuntimeController = require(script.Parent.Common.Controllers.RuntimeController)
local units: { Lifecycle.Unit } = { RuntimeController }
if script.Parent:FindFirstChild("Tower") then
	table.insert(units, require(script.Parent.Tower.Controllers.GameController))
end
Lifecycle.run(units)
