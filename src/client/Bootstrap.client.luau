--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lifecycle = require(ReplicatedStorage:WaitForChild("Shared").Util.Lifecycle)
local RuntimeController = require(script.Parent.Common.Controllers.RuntimeController)
Lifecycle.run({ RuntimeController })
