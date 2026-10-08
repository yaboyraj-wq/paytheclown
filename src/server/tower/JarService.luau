--!strict
local Economy = require(script.Parent.Parent.Common.EconomyService)
local Stakes = require(game.ReplicatedStorage.Shared.Logic.Stakes)
local Payout = require(game.ReplicatedStorage.Shared.Logic.Payout)
local JarService = {}
function JarService.balance(): number
	return Economy.jar.balance
end
function JarService.reset()
	Economy.reset()
end
function JarService.lock(amount: number, floor: number, rookie: boolean, id: string, player: number): boolean
	if not Stakes.valid(amount, JarService.balance(), floor, rookie) then
		return false
	end
	return Economy.change(-amount, "STAKE", id .. ":stake", player)
end
function JarService.pay(
	stake: number,
	multiplier: number,
	maximum: number,
	id: string,
	player: number
): number
	local amount = Payout.tickets(stake, multiplier, maximum)
	local before = JarService.balance()
	if not Economy.change(amount, "BOOTH_PAYOUT", id .. ":payout", player) then
		return 0
	end
	return JarService.balance() - before
end
function JarService.change(delta: number, reason: string, id: string, player: number): boolean
	return Economy.change(delta, reason, id, player)
end
function JarService.audit()
	return table.clone(Economy.jar.audit)
end
return JarService
