-- Temporary DEV server Script: run after the player has loaded.
local Env = require(game.ReplicatedStorage.Shared.Config.Environment).DEV
assert(game.PlaceId == Env.PlaceId and game.GameId == Env.GameId, "DEV only")
local T = game.ServerScriptService.Tower
local N, S, B, W, J = require(T.NightLoopService), require(T.RunStore), require(T.BoothService), require(T.WorldService), require(T.JarService)
local R = require(game.ReplicatedStorage.Shared.Config.Runtime)
local p = game.Players:GetPlayers()[1]
local function enterNight()
	N.depart()
	S.deadline = 0
	N.step(workspace:GetServerTimeNow())
	S.deadline = 0
	N.step(workspace:GetServerTimeNow())
	assert(S.phase == "NIGHT")
end
local function claim(id)
	p.Character:PivotTo(W.pad(id).CFrame + Vector3.new(0, 3, 0))
	assert(B.claim(p, id))
	return B.current(p)
end
local function reelSignature(b)
	local parts = {}
	for i, strip in b.strips do
		table.insert(parts, table.concat(strip, ",") .. ":" .. b.offsets[i])
	end
	return table.concat(parts, "|")
end
local previous = S.worldSeed
for _ = 1, 8 do
	N.reset()
	assert(S.worldSeed ~= previous and S.worldSeed >= 1 and S.worldSeed <= R.WORLD_SEED_MAX)
	previous = S.worldSeed
end
assert(N.snapshot().worldSeed == nil, "master seed must stay server-only")
enterNight()
assert(S.worldSeed == previous, "departure preserves run seed")
local first = reelSignature(claim("STOP_REELS"))
N.adminNight(2)
assert(S.worldSeed == previous, "night jumps preserve run seed")
enterNight()
assert(reelSignature(claim("STOP_REELS")) ~= first, "different night has a different setup")
N.reset()
enterNight()
assert(reelSignature(claim("STOP_REELS")) ~= first, "new run changes Night 1")
N.reset()
enterNight()
local pie = claim("PIE_SWEEPER")
local board = pie.board
local pies = table.clone(board.pies)
assert(not B.stake(p, pie.id, pie.round, 10), "two-second preview must precede GO")
task.wait(R.PIE_PREVIEW_SECONDS + 0.1)
assert(B.stake(p, pie.id, pie.round, 10))
task.wait(R.LOCK_SECONDS + 0.1)
B.step(workspace:GetServerTimeNow())
assert(pie.state == "PUSH_DECISION" and board.safeCount == 1 and pie.multiplier == 1, "opening is one safe tile at 1x")
for tile in pies do
	assert(board.pies[tile], "GO must not reroll the preview")
end
local choice
for tile = 1, 25 do
	if not board.pies[tile] and board.revealed[tile] == nil then
		choice = tile
		break
	end
end
assert(B.input(p, { kind = "push", seq = 1, booth = pie.id, round = pie.round }))
assert(B.input(p, { kind = "reveal", seq = 2, booth = pie.id, round = pie.round, tile = choice }))
assert(board.safeCount == 2 and pie.multiplier == 1.14, "one picked tile adds exactly one step")
assert(B.input(p, { kind = "bank", seq = 3, booth = pie.id, round = pie.round }))
assert(pie.payout == 11 and J.balance() == 1001, "bank floors the per-pick payout")
workspace:SetAttribute("PTCPreplayLogic", "PASS")
print("[PTC QA] Fresh run seeds, night derivation, private master seed and single-pick Pie PASS")
N.reset()
