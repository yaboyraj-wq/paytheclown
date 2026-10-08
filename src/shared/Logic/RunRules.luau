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
function RunRules.tokens(surplus: number, quota: number): number
	return E.TOKENS.survive
		+ math.min(E.TOKENS.surplusCap, math.floor(surplus / (quota * E.TOKENS.surplusFraction)))
end
return RunRules
