--!strict
local Ledger = require(game.ReplicatedStorage.Shared.Logic.JarLedger)
local E = require(game.ReplicatedStorage.Shared.Config.Economy)
local EconomyService = { jar = Ledger.new(E.DEFAULTS.jar) }
function EconomyService.reset()
	EconomyService.jar = Ledger.new(E.DEFAULTS.jar)
end
function EconomyService.change(delta: number, reason: string, id: string, player: number): boolean
	return Ledger.change(EconomyService.jar, delta, reason, id, player, workspace:GetServerTimeNow())
end
return EconomyService
