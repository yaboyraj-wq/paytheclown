--!strict
return function(test: (string, () -> ()) -> ())
	test("remote token bucket refills smoothly and bounds immediate bursts", function()
		local Rate = require("../../src/shared/Logic/RateLimit")
		local state = Rate.new(10, 0)
		for _ = 1, 10 do
			assert(Rate.consume(state, 0), "initial capacity allowed")
		end
		assert(not Rate.consume(state, 0), "immediate overflow dropped")
		assert(not Rate.consume(state, 0.05), "partial token is insufficient")
		assert(Rate.consume(state, 0.1), "one replenished token allowed")
		assert(not state.kicked, "normal burst cannot kick")
	end)
	test("three consecutive seconds of extreme spam trigger a kick", function()
		local Rate = require("../../src/shared/Logic/RateLimit")
		local state = Rate.new(10, 0)
		for second = 0, 2 do
			for _ = 1, 51 do
				Rate.consume(state, second + 0.1)
			end
			assert(not state.kicked, "three full windows required")
		end
		Rate.advance(state, 3)
		assert(state.kicked, "sustained spam must kick")
		assert(not Rate.consume(state, 10), "kick stays latched")
	end)
	test("isolated bursts, exact threshold and idle gaps do not kick", function()
		local Rate = require("../../src/shared/Logic/RateLimit")
		local exact = Rate.new(10, 0)
		for second = 0, 5 do
			for _ = 1, 50 do
				Rate.consume(exact, second + 0.1)
			end
		end
		Rate.advance(exact, 6)
		assert(not exact.kicked, "threshold is strictly greater than 5x")
		local burst = Rate.new(20, 0)
		for _ = 1, 1000 do
			Rate.consume(burst, 0)
		end
		Rate.advance(burst, 1)
		assert(not burst.kicked, "one extreme window cannot kick")
		Rate.advance(burst, 3)
		assert(burst.extremeSeconds == 0, "idle gap resets the streak")
		for second = 3, 4 do
			for _ = 1, 101 do
				Rate.consume(burst, second + 0.1)
			end
		end
		Rate.advance(burst, 5)
		assert(not burst.kicked, "two new windows do not combine with an old burst")
	end)
end
