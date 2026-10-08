-- DEV-only integration probe. Run as a temporary server Script with two clients.
local Env = require(game.ReplicatedStorage.Shared.Config.Environment).DEV
assert(game.PlaceId == Env.PlaceId and game.GameId == Env.GameId, "DEV only")
local T = game.ServerScriptService.Tower
local N, S, B, J, W, A =
	require(T.NightLoopService),
	require(T.RunStore),
	require(T.BoothService),
	require(T.JarService),
	require(T.WorldService),
	require(T.AdminService)
local crew = game.Players:GetPlayers()
table.sort(crew, function(a, b)
	return a.Name < b.Name
end)
assert(#crew == 2, "two clients required")
local p1, p2 = crew[1], crew[2]
local function now()
	return workspace:GetServerTimeNow()
end
local function move(p, id)
	p.Character:PivotTo(W.pad(id).CFrame + Vector3.new(0, 3, 0))
end
N.reset()
N.depart()
S.deadline = 0
N.step(now())
S.deadline = 0
N.step(now())
assert(S.quota == 400 and S.crewSize == 2, "two-player quota")
move(p1, "STOP_REELS")
move(p2, "BLOCK_TOSS")
assert(B.claim(p1, "STOP_REELS") and B.claim(p2, "BLOCK_TOSS"))
local a, b = B.current(p1), B.current(p2)
assert(B.stake(p1, a.id, a.round, 700) and B.stake(p2, b.id, b.round, 700))
assert(J.balance() == 1000, "heads-ups do not debit")
a.pending.ends = 0
b.pending.ends = 0
B.step(now())
assert(J.balance() == 300 and a.stake + b.stake == 700, "competing stakes cannot overdraw")
local winner = if a.stake > 0 then a else b
B.resolve(winner, 0)
B.resolve(winner, 0)
assert(J.balance() == 300, "loss settles once")
B.reset()
A.apply(p1, "jar", 1000)
S.approval = true
assert(B.claim(p1, "STOP_REELS"))
a = B.current(p1)
assert(B.stake(p1, a.id, a.round, 500))
local old = a.pending.id
J.change(-10, "DEV_QA", "qa:decrease", 0)
a.pending.ends = 0
B.step(now())
assert(a.pending and a.pending.id ~= old and J.balance() == 990, "changed jar renews approval")
assert(not B.vote(p1, a.id, a.pending.id, false), "requester cannot vote")
assert(not B.vote(p2, a.id, old, false), "stale approval cannot vote")
assert(B.vote(p2, a.id, a.pending.id, false))
assert(not B.vote(p2, a.id, a.pending.id, true), "one response")
a.pending.ends = 0
B.step(now())
assert(a.state == "STAKING" and J.balance() == 990, "responding veto prevents debit")
S.approval = false
assert(B.stake(p1, a.id, a.round, 500))
assert(B.vote(p2, a.id, a.pending.id, false))
a.pending.ends = 0
B.step(now())
assert(a.state == "LOCKED" and J.balance() == 490, "friends default is heads-up only")
assert(
	not B.input(p2, { booth = a.id, round = a.round, seq = 1, kind = "stop", time = now() }),
	"wrong controller"
)
B.resolve(a, 0)
workspace:SetAttribute("PTCMultiplayerQA", "PASS")
print(
	"[PTC QA] Two-client shared jar, concurrent stakes, approval refresh/veto/default and wrong-controller checks PASS"
)
N.reset()
