--!strict
local Config = require("../Config/Runtime")
local Retry = {}
function Retry.call<T>(operation: () -> T, sleep: (number) -> (), log: (string) -> ()): (boolean, T | string)
	local delaySeconds = Config.RETRY_INITIAL_SECONDS
	local lastError = ""
	for attempt = 1, Config.RETRY_ATTEMPTS do
		local ok, result = pcall(operation)
		if ok then
			return true, result
		end
		lastError = tostring(result)
		log("Retry attempt " .. tostring(attempt) .. " failed")
		if attempt < Config.RETRY_ATTEMPTS then
			sleep(delaySeconds)
			delaySeconds = math.min(delaySeconds * Config.RETRY_FACTOR, Config.RETRY_MAX_SECONDS)
		end
	end
	return false, lastError
end
return Retry
