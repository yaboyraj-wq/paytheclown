--!strict
local E = require("../Config/Economy")
local Quota = {}
function Quota.roundNice(value: number): number
	local step = if value < E.ROUND_THRESHOLD then E.ROUND_SMALL else E.ROUND_LARGE
	return math.round(value / step) * step
end
function Quota.calculate(night: number, crew: number, difficulty: string): number
	local difficultyMap: { [string]: number } = E.DIFFICULTY
	local base = E.BASE_QUOTA[night]
		or math.round(E.BASE_QUOTA[#E.BASE_QUOTA] * E.ENDLESS_GROWTH ^ (night - #E.BASE_QUOTA))
	return Quota.roundNice(
		base
			* E.CREW_MULTIPLIER[math.clamp(crew, 1, #E.CREW_MULTIPLIER)]
			* (difficultyMap[difficulty] or E.DIFFICULTY.Normal)
	)
end
return Quota
