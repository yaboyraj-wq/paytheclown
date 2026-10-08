--!strict
local R = require("../Config/Runtime")
local WorldSeeds = {}
function WorldSeeds.derive(worldSeed: number, context: { number }): number
	local seed = worldSeed
	for _, value in context do
		seed = (seed * R.SEED_MULTIPLIER + value) % R.SEED_MODULUS
	end
	return math.max(1, seed)
end
return WorldSeeds
