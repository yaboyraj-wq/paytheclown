--!strict
local R = require("../Config/Runtime")
local E = require("../Config/Economy")
local RunRules = {}
function RunRules.readyDelay(ready: number, total: number): number?
	if total == 0 then
		return nil
	end
	if ready == total then
		return if total == 1 then R.READY_SOLO_SECONDS else R.READY_ALL_SECONDS
	end
	if ready > total - ready then
		return R.READY_MAJORITY_SECONDS
	end
	return nil
end
function RunRules.tokens(jar: number, quota: number, priorSuccesses: number): number
	if quota <= 0 or jar < quota then
		return 0
	end
	local floor =
		math.clamp(math.floor(priorSuccesses / E.TOKENS.successesPerFloor) + 1, 1, #E.TOKENS.floorBase)
	local extra = 0
	for _, tier in E.TOKENS.surplus[floor] do
		if jar / quota >= tier.ratio then
			extra = tier.reward
		end
	end
	return E.TOKENS.floorBase[floor] + extra
end
return RunRules
