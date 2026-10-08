--!strict
local passed = 0
local failed = 0
local function test(name: string, callback: () -> ())
	local ok, message = pcall(callback)
	if ok then
		passed += 1
		print("PASS " .. name)
	else
		failed += 1
		print("FAIL " .. name .. ": " .. tostring(message))
	end
end
test("Retry returns recovery and stops after success", function()
	local Retry = require("../../src/shared/Util/Retry")
	local calls = 0
	local waits = {}
	local ok, result = Retry.call(function()
		calls += 1
		if calls < 3 then
			error("temporary")
		end
		return "recovered"
	end, function(seconds: number)
		table.insert(waits, seconds)
	end, function() end)
	assert(ok and result == "recovered", "operation should recover")
	assert(calls == 3 and #waits == 2 and waits[2] > waits[1], "backoff should grow and stop on success")
end)
test("Retry exhausts attempts without throwing", function()
	local Retry = require("../../src/shared/Util/Retry")
	local calls = 0
	local ok = Retry.call(function()
		calls += 1
		error("unavailable")
	end, function() end, function() end)
	assert(not ok and calls == 4, "failed operation should stop at retry budget")
end)
require("./rules")(test)
require("./rate_limits")(test)
require("./world_seeds")(test)
require("./quota_progression")(test)
print(string.format("Tests: %d passed, %d failed", passed, failed))
assert(failed == 0, "Test suite failed")
