-- Run in DEV server with Player1 and Player2. Close Player1's client during the extended decision window.
local Env = require(game.ReplicatedStorage.Shared.Config.Environment).DEV
assert(game.PlaceId == Env.PlaceId and game.GameId == Env.GameId, "DEV only")
local T = game.ServerScriptService.Tower
local N, S, B, J, W =
	require(T.NightLoopService),
	require(T.RunStore),
	require(T.BoothService),
	require(T.JarService),
	require(T.WorldService)
local p = game.Players:FindFirstChild("Player1")
local other = game.Players:FindFirstChild("Player2")
N.reset()
N.depart()
S.deadline = 0
N.step(workspace:GetServerTimeNow())
S.deadline = 0
N.step(workspace:GetServerTimeNow())
p.Character:PivotTo(W.pad("PIE_SWEEPER").CFrame + Vector3.new(0, 3, 0))
assert(B.claim(p, "PIE_SWEEPER"))
local b = B.current(p)
local order = {}
for i = 1, 25 do
	order[i] = i
end
b.pieCount = 8
b.board = require(game.ReplicatedStorage.Shared.Logic.BoothLogic.PieSweeper).create(8, 13, order)
b.previewEnd = 0
assert(B.stake(p, b.id, b.round, 10))
b.startTime = 0
B.step(workspace:GetServerTimeNow())
assert(b.state == "PUSH_DECISION")
b.deadline = workspace:GetServerTimeNow() + 120
workspace:SetAttribute("PTCDisconnectExpected", J.balance() + 10)
game.Players.PlayerRemoving:Connect(function(leaving)
	if leaving == p then
		task.delay(0.5, function()
			assert(
				J.balance() == workspace:GetAttribute("PTCDisconnectExpected"),
				"disconnect must bank once"
			)
			assert(S.host == other.UserId, "host transfers")
			workspace:SetAttribute("PTCDisconnectQA", "PASS")
			print("[PTC QA] Actual disconnect banks pending Pie once and transfers host PASS")
		end)
	end
end)
