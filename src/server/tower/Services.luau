--!strict
local Lifecycle = require(game.ReplicatedStorage.Shared.Util.Lifecycle)
local services: { Lifecycle.Unit } = {
	require(script.Parent.WorldService),
	require(script.Parent.BoothService),
	require(script.Parent.NightLoopService),
	require(script.Parent.NetworkService),
	require(script.Parent.AdminService),
}
return services
