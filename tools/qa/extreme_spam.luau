-- Run as a temporary DEV LocalScript. Expected: generic disconnect after three extreme seconds.
local Env = require(game.ReplicatedStorage.Shared.Config.Environment).DEV
assert(game.PlaceId == Env.PlaceId and game.GameId == Env.GameId, "DEV only")
for _ = 1, 25 do
	for _ = 1, 20 do
		game.ReplicatedStorage.Net.Action:FireServer({ kind = "fakeResult", payout = 9999999999 })
	end
	task.wait(0.2)
end
