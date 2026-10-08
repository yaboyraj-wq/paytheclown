--!strict
local Runtime = require("../Config/Runtime")
local InputRules = {}
function InputRules.finite(value: any): boolean
	return type(value) == "number" and value == value and math.abs(value) < math.huge
end
function InputRules.integer(value: any): boolean
	return InputRules.finite(value) and value % 1 == 0
end
function InputRules.sequence(value: any, previous: number): boolean
	return InputRules.integer(value) and value > previous and value <= Runtime.MAX_SEQUENCE
end
function InputRules.timestamp(value: any, now: number, ping: number, previous: number): boolean
	return InputRules.finite(value)
		and value >= previous
		and value >= now - (math.clamp(ping, 0, Runtime.MAX_PING_SECONDS) + Runtime.INPUT_PAST_TOLERANCE)
		and value <= now + Runtime.INPUT_FUTURE_TOLERANCE
end
function InputRules.packet(value: any): boolean
	if type(value) ~= "table" then
		return false
	end
	local count = 0
	for key, item in value do
		count += 1
		if count > Runtime.MAX_PACKET_FIELDS or type(key) ~= "string" or #key > Runtime.MAX_PACKET_STRING then
			return false
		end
		if type(item) ~= "string" and type(item) ~= "boolean" and not InputRules.finite(item) then
			return false
		end
		if type(item) == "string" and #item > Runtime.MAX_PACKET_STRING then
			return false
		end
	end
	return true
end
return InputRules
