--!strict
local Net = require(game.ReplicatedStorage.Shared.Net.Net)
local Notify = {}
function Notify.all(key: string, values: { [string]: any }?)
	Net.get("Toast"):FireAllClients({ key = key, values = values or {} })
end
function Notify.one(player: Player, key: string, values: { [string]: any }?)
	Net.get("Toast"):FireClient(player, { key = key, values = values or {} })
end
return Notify
