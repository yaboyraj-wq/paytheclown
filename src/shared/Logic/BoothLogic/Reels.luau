--!strict
local C = require("../../Config/Booths").STOP_REELS
local Reels = {}
function Reels.position(offset: number, floor: number, reel: number, time: number): number
	local speed = C.speeds[floor] * (if reel == 3 then C.thirdSpeed[floor] else 1)
	local omega = (math.pi + math.pi) / C.wobblePeriod[floor]
	return offset + speed * (time + C.wobble[floor] * (1 - math.cos(omega * time)) / omega)
end
function Reels.symbol(strip: { string }, offset: number, floor: number, reel: number, time: number): string
	return strip[math.floor(Reels.position(offset, floor, reel, time)) % #strip + 1]
end
function Reels.multiplier(symbols: { string }): number
	if symbols[1] == symbols[2] and symbols[2] == symbols[3] then
		if symbols[1] == "WADDLES" then
			return C.payout.waddles
		end
		if symbols[1] == "STAR" then
			return C.payout.star
		end
		return C.payout.triple
	end
	if symbols[1] == symbols[2] or symbols[1] == symbols[3] or symbols[2] == symbols[3] then
		return C.payout.pair
	end
	return C.payout.none
end
return Reels
