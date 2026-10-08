--!strict
local E = require("../Config/Economy")
local C = E.QUOTA
local Quota = {}
local function difficultyFactor(difficulty: string): number
	local factors: { [string]: number } = E.DIFFICULTY
	return factors[difficulty] or E.DIFFICULTY.Normal
end
local function crewFactor(crew: number): number
	return E.CREW_MULTIPLIER[math.clamp(crew, 1, #E.CREW_MULTIPLIER)]
end
function Quota.roundSignificant(value: number): number
	if value == 0 then
		return 0
	end
	local exponent = math.floor(math.log10(math.abs(value))) - (C.significantDigits - 1)
	local step = C.decimalBase ^ exponent
	return math.round(value / step) * step
end
function Quota.initial(crew: number, difficulty: string): number
	return Quota.roundSignificant(C.initial * crewFactor(crew) * difficultyFactor(difficulty))
end
local function multiplier(successes: number): number
	local index = successes + 1
	local sequence = C.multipliers
	if sequence[index] then
		return sequence[index]
	end
	local count = #sequence
	local value = sequence[count]
	local delta = value - sequence[count - 1]
	local priorDelta = sequence[count - 1] - sequence[count - 2]
	local acceleration = math.max(C.minimumAcceleration, delta - priorDelta)
	if count >= 4 then
		acceleration = math.max(acceleration, priorDelta - (sequence[count - 2] - sequence[count - 3]))
	end
	for _ = count + 1, index do
		delta = math.max(C.minimumAcceleration, delta + acceleration)
		value = math.round((value + delta) * C.multiplierPrecision) / C.multiplierPrecision
	end
	return value
end
function Quota.advance(quota: number, jar: number, successes: number, difficulty: string): number
	return Quota.roundSignificant(
		(quota + C.catchUp * (jar - quota)) * multiplier(successes) * difficultyFactor(difficulty)
	)
end
function Quota.rescale(quota: number, priorCrew: number, crew: number): number
	return Quota.roundSignificant(quota * crewFactor(crew) / crewFactor(priorCrew))
end
-- DEV jumps have no real closing balances: use the documented at-quota baseline.
function Quota.nominal(night: number, crew: number, difficulty: string): number
	local quota = Quota.initial(crew, difficulty)
	for successes = 1, night - 1 do
		quota = Quota.advance(quota, quota, successes, difficulty)
	end
	return quota
end
return Quota
