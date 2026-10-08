--!strict
local C = require("../../Config/Booths").STOP_REELS
local Prototype = require("../../Config/Prototype")
local Reels = {}
function Reels.position(offset: number, floor: number, reel: number, time: number): number
	local speed = C.speeds[floor] * (if reel == 3 then C.thirdSpeed[floor] else 1)
	local omega = (math.pi + math.pi) / C.wobblePeriod[floor]
	return offset + speed * (time + C.wobble[floor] * (1 - math.cos(omega * time)) / omega)
end
function Reels.symbol(strip: { string }, offset: number, floor: number, reel: number, time: number): string
	return strip[math.floor(Reels.position(offset, floor, reel, time)) % #strip + 1]
end
function Reels.displayPosition(
	offset: number,
	floor: number,
	reel: number,
	phase: string,
	startTime: number,
	now: number,
	stopped: number?
): number
	if stopped then
		return stopped
	end
	return if phase == "PLAYING"
		then Reels.position(offset, floor, reel, math.max(0, now - startTime))
		else offset
end
function Reels.window(strip: { string }, position: number): { string }
	local symbols = {}
	for _, offset in Prototype.reelRows do
		table.insert(symbols, strip[(math.floor(position) + offset) % #strip + 1])
	end
	return symbols
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
