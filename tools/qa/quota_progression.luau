-- Temporary DEV server Script. Exercises real services; remove by stopping Play.
local Env = require(game.ReplicatedStorage.Shared.Config.Environment).DEV
assert(game.PlaceId == Env.PlaceId and game.GameId == Env.GameId, "DEV only")
local T = game.ServerScriptService.Tower
local N, S, J = require(T.NightLoopService), require(T.RunStore), require(T.JarService)
local player = game.Players:GetPlayers()[1]
assert(player and #game.Players:GetPlayers() == 1, "single-client QA fixture")
local serial = 0
local function step()
	N.step(workspace:GetServerTimeNow())
end
local function setJar(amount)
	serial += 1
	assert(J.change(amount - J.balance(), "DEV_QA", "quota-qa:" .. serial, 0))
end
local function depart()
	N.depart()
	S.deadline = 0
	step()
	S.deadline = 0
	step()
	assert(S.phase == "NIGHT")
end
local function close()
	S.deadline = 0
	step()
	S.graceEnd = 0.001
	step()
	assert(S.phase == "CLOSING")
	S.deadline = 0
	step()
end
local function nextDay()
	S.deadline = 0
	step()
	assert(S.phase == "DAY")
end
N.reset()
assert(S.quota == 780 and S.nextQuota == 780 and S.tokens == 5)
-- Before the first departure, a four-person preview must not leave rounding
-- behind after three players leave. Represent that saved preview baseline.
S.quotaCrewSize = 4
S.nextQuota = 1900
step()
assert(S.quota == 780, "first departure must recalculate the original baseline for the present crew")
depart()
assert(S.quota == 780)
local auditCount = #J.audit()
close()
assert(S.phase == "RESULT_SUCCESS" and J.balance() == 1000, "keep the full jar")
assert(#J.audit() == auditCount, "count is not a jar transaction")
assert(S.tokens == 16 and S.tokenReward == 11 and S.nextQuota == 1200 and S.successfulNights == 1)
-- Deliberately repeat the same closing callback: it must not award or advance again.
S.phase = "CLOSING"
S.deadline = 0
step()
assert(S.tokens == 16 and S.successfulNights == 1 and S.nextQuota == 1200 and J.balance() == 1000)
S.phase = "RESULT_SUCCESS"
nextDay()
assert(S.night == 2 and S.quota == 1200 and J.balance() == 1000)
-- Day balance changes cannot trigger another catch-up calculation.
setJar(1500)
step()
assert(S.quota == 1200)
setJar(1200)
depart()
assert(S.quota == 1200, "departure must preserve earned quota history")
close()
assert(S.tokens == 25 and S.tokenReward == 9 and S.nextQuota == 1800 and J.balance() == 1200)
nextDay()
depart()
setJar(9000)
S.tokens = 98
close()
assert(S.successfulNights == 3 and S.tokens == 99 and S.tokenReward == 1, "wallet cap reports actual award")
assert(S.nextQuota == 12000 and J.balance() == 9000, "large surplus feeds the next threshold")
nextDay()
depart()
setJar(12000)
S.tokens = 0
close()
assert(S.tokenReward == 11 and S.tokens == 11, "fourth night uses Floor 2 base")
assert(S.nextQuota == 23000 and J.balance() == 12000)

N.reset()
depart()
setJar(779)
close()
assert(S.phase == "RESULT_FAIL" and S.tokens == 5 and S.tokenReward == 0)
assert(S.successfulNights == 0 and S.nextQuota == 780 and J.balance() == 779)
S.deadline = 0
step()
assert(S.phase == "CANNON")
S.deadline = 0
step()
assert(S.phase == "RUN_OVER" and N.again(player))
assert(S.quota == 780 and S.nextQuota == 780 and S.successfulNights == 0 and J.balance() == 1000)

depart()
setJar(0)
N.adminResult(true)
close()
assert(
	J.balance() == 780 and S.tokens == 14 and S.nextQuota == 1000,
	"forced pass tops up once and retains it"
)
local forceCount = 0
for _, entry in J.audit() do
	assert(entry.reason ~= "QUOTA", "no quota debit")
	if entry.reason == "DEV_FORCE" then
		forceCount += 1
	end
end
assert(forceCount == 1)
N.adminNight(4)
assert(S.successfulNights == 3 and S.quota == 2600, "DEV jump uses nominal solo history")
depart()
setJar(2600)
close()
assert(S.tokenReward == 11 and J.balance() == 2600)

N.adminNight(2)
S.quotaCrewSize = 2
S.nextQuota = 2300
step()
assert(S.quota == 1500 and S.nextQuota == 2300, "Day preview rescales from the closing crew baseline")
step()
assert(S.quota == 1500 and S.nextQuota == 2300, "repeated previews never compound scaling")
depart()
assert(S.quota == 1500 and S.quotaCrewSize == 1, "lock the new crew's quota at departure")

print(
	"[PTC QA] Retained jar, catch-up progression, floor rewards, cap, duplicate closing, failure and replay PASS"
)
workspace:SetAttribute("PTCQuotaQA", "PASS")
N.reset()
depart()
close()
-- Leave the ordinary first-night result visible for screenshot and client checks.
