local Env = require(game.ReplicatedStorage.Shared.Config.Environment).DEV
assert(game.PlaceId == Env.PlaceId and game.GameId == Env.GameId, "DEV only")
local T = game.ServerScriptService.Tower
local N = require(T.NightLoopService)
local S = require(T.RunStore)
local J = require(T.JarService)
local B = require(T.BoothService)
local W = require(T.WorldService)
local A = require(T.AdminService)
local p = game.Players:GetPlayers()[1]
local function tick()
	N.step(workspace:GetServerTimeNow())
end
N.reset()
assert(S.phase == "DAY" and J.balance() == 1000)
assert(N.ready(p))
tick()
assert(S.departureEnd ~= nil)
S.departureEnd = 0
tick()
assert(S.phase == "DEPARTING" and S.quota == 260)
S.deadline = 0
tick()
assert(S.phase == "NIGHT_INTRO")
S.deadline = 0
tick()
assert(S.phase == "NIGHT")
p.Character:PivotTo(W.pad("STOP_REELS").CFrame + CFrame.new().Position + Vector3.new(0, 3, 0))
assert(B.claim(p, "STOP_REELS"))
local booth = B.current(p)
assert(booth)
assert(not B.stake(p, "STOP_REELS", booth.round, 0 / 0))
assert(B.stake(p, "STOP_REELS", booth.round, 10))
assert(J.balance() == 990)
B.resolve(booth, 3)
B.resolve(booth, 3)
assert(J.balance() == 1020, "duplicate resolve must not credit")
A.apply(p, "pass")
tick()
S.graceEnd = 0.001
tick()
assert(S.phase == "CLOSING")
S.deadline = 0
tick()
assert(S.phase == "RESULT_SUCCESS" and J.balance() == 760 and S.tokens == 12)
tick()
assert(J.balance() == 760, "quota must only settle once")
S.deadline = 0
tick()
assert(S.phase == "DAY" and S.night == 2)
N.depart()
S.deadline = 0
tick()
S.deadline = 0
tick()
A.apply(p, "fail")
tick()
S.graceEnd = 0.001
tick()
S.deadline = 0
tick()
assert(S.phase == "RESULT_FAIL")
S.deadline = 0
tick()
assert(S.phase == "CANNON")
S.deadline = 0
tick()
assert(S.phase == "RUN_OVER")
assert(N.again(p))
assert(J.balance() == 1000 and S.night == 1)
return { passed = true, history = N.history, audit = J.audit() }
