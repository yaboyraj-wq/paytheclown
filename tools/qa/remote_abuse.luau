-- Run as a temporary LocalScript in the authorized DEV test client.
local env = require(game.ReplicatedStorage.Shared.Config.Environment).DEV
assert(game.PlaceId == env.PlaceId and game.GameId == env.GameId, "DEV only")
local net = game.ReplicatedStorage.Net
for _, channel in { "Action", "BoothInput" } do
	local remote = net[channel]
	remote:FireServer(nil)
	remote:FireServer("not a packet")
	remote:FireServer({ kind = "stake", seq = 1, amount = 0 / 0 })
	remote:FireServer({ kind = "stake", seq = 2, amount = math.huge })
	remote:FireServer({ kind = string.rep("x", 1000), seq = 3 })
	remote:FireServer({ kind = "stake", seq = 4, amount = { 1000 } })
	remote:FireServer({ kind = "stake", seq = -1, booth = "STOP_REELS", round = "stale", amount = 100 })
	remote:FireServer({ kind = "stake", seq = 0, booth = "STOP_REELS", round = "stale", amount = 100 })
	for _ = 1, 1000 do
		remote:FireServer({ kind = "fakeResult", payout = 9999999999 })
	end
end
print("[PTC QA] Invalid payload and burst-spam probe sent; verify unchanged jar and rejection logs on server")
