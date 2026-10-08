--!strict
local R = require("../Config/Runtime")
local C = require("../Config/Prototype")
export type State = {
	rate: number,
	tokens: number,
	last: number,
	windowStart: number,
	count: number,
	extremeSeconds: number,
	kicked: boolean,
}
local RateLimit = {}
function RateLimit.new(rate: number, now: number): State
	return {
		rate = rate,
		tokens = rate,
		last = now,
		windowStart = now,
		count = 0,
		extremeSeconds = 0,
		kicked = false,
	}
end
function RateLimit.advance(state: State, now: number)
	state.tokens = math.min(state.rate, state.tokens + math.max(0, now - state.last) * state.rate)
	state.last = math.max(state.last, now)
	local elapsed = now - state.windowStart
	if elapsed < C.packetWindow then
		return
	end
	if state.count > state.rate * R.SPAM_MULTIPLIER * C.packetWindow then
		state.extremeSeconds += C.packetWindow
	else
		state.extremeSeconds = 0
	end
	state.kicked = state.kicked or state.extremeSeconds >= R.SPAM_SECONDS
	local windows = math.floor(elapsed / C.packetWindow)
	if windows > 1 then
		state.extremeSeconds = 0 -- Unobserved windows had no incoming packets.
	end
	state.windowStart += windows * C.packetWindow
	state.count = 0
end
function RateLimit.consume(state: State, now: number): boolean
	RateLimit.advance(state, now)
	state.count += 1
	if state.kicked or state.tokens < 1 then
		return false
	end
	state.tokens -= 1
	return true
end
return RateLimit
