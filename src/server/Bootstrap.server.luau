--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lifecycle = require(ReplicatedStorage.Shared.Util.Lifecycle)
local RuntimeService = require(script.Parent.Common.RuntimeService)
Lifecycle.run({ RuntimeService })
