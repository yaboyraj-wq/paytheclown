--!strict
local Input = require("./InputRules")
local Payout = {}
function Payout.tickets(stake: number, multiplier: number, maximum: number): number
	assert(Input.integer(stake) and stake >= 0, "Invalid payout stake")
	assert(Input.finite(multiplier) and Input.finite(maximum), "Invalid payout multiplier")
	return math.floor(stake * math.clamp(multiplier, 0, maximum))
end
return Payout
