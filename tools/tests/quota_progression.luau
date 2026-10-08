--!strict
return function(test: (string, () -> ()) -> ())
	local Q = require("../../src/shared/Logic/Quota")
	local R = require("../../src/shared/Logic/RunRules")
	test("starting quota scales the study baseline by crew and difficulty", function()
		for crew, expected in { 780, 1200, 1600, 1900, 2200, 2400 } do
			assert(Q.initial(crew, "Normal") == expected, "crew " .. crew)
		end
		assert(Q.initial(2, "Hard") == 1800 and Q.initial(2, "Extreme") == 2400, "difficulty baseline")
	end)
	test("quota rounds to two significant digits with midpoint away from zero", function()
		for _, row in
			{
				{ 0, 0 },
				{ 1250, 1300 },
				{ -1250, -1300 },
				{ 9949, 9900 },
				{ 9950, 10000 },
				{ 123456, 120000 },
				{ 0.125, 0.13 },
			}
		do
			assert(Q.roundSignificant(row[1]) == row[2], tostring(row[1]))
		end
	end)
	test("next quota uses retained balance and advances before reading the multiplier", function()
		assert(Q.advance(1200, 1200, 1, "Normal") == 1600, "first transition uses 1.3")
		assert(Q.advance(1200, 2000, 1, "Normal") == 2300, "75 percent catch-up before multiplying")
		assert(Q.advance(780, 1000, 1, "Normal") == 1200, "solo factor is not compounded again")
		assert(Q.advance(1800, 2400, 1, "Hard") == 4400, "difficulty applies each success")
	end)
	test("nominal quota history matches all twelve study steps", function()
		local histories = {
			Normal = { 1200, 1600, 2400, 4100, 7800, 16000, 37000, 96000, 290000, 960000, 3500000, 14000000 },
			Hard = {
				1800,
				3500,
				7900,
				20000,
				57000,
				180000,
				620000,
				2400000,
				11000000,
				54000000,
				290000000,
				1700000000,
			},
			Extreme = {
				2400,
				6200,
				19000,
				65000,
				250000,
				1100000,
				5100000,
				27000000,
				160000000,
				1100000000,
				7900000000,
				63000000000,
			},
		}
		for difficulty, history in histories do
			for night, expected in history do
				assert(Q.nominal(night, 2, difficulty) == expected, difficulty .. " night " .. night)
			end
		end
		assert(Q.nominal(13, 2, "Normal") == 63000000, "first extended multiplier 4.5")
		assert(Q.nominal(14, 2, "Normal") == 320000000, "next extended multiplier 5.1")
	end)
	test("crew changes rescale the pending quota once without redoing catch-up", function()
		assert(Q.rescale(2300, 2, 4) == 3600, "larger crew")
		assert(Q.rescale(2300, 2, 1) == 1500, "smaller crew")
		assert(Q.rescale(2300, 2, 2) == 2300, "same crew")
	end)
	test("floor rewards advance after the third sixth and ninth successes", function()
		for successes, expected in
			{ [0] = 9, [2] = 9, [3] = 11, [5] = 11, [6] = 13, [8] = 13, [9] = 15, [12] = 15 }
		do
			assert(R.tokens(1200, 1200, successes) == expected, "completed count " .. successes)
		end
		assert(R.tokens(1199, 1200, 0) == 0, "failure has no reward")
	end)
	test("surplus rewards use the highest inclusive ratio tier rather than adding tiers", function()
		local floors = {
			{ successes = 0, base = 9, extras = { 1, 2, 3, 4, 5, 5 } },
			{ successes = 3, base = 11, extras = { 2, 4, 6, 8, 10, 10 } },
			{ successes = 6, base = 13, extras = { 3, 6, 9, 12, 15, 20 } },
			{ successes = 9, base = 15, extras = { 4, 8, 12, 16, 20, 25 } },
		}
		for _, floor in floors do
			local previous = 0
			for i, balance in { 1320, 1500, 1800, 2400, 3600, 6000 } do
				assert(R.tokens(balance - 1, 1200, floor.successes) == floor.base + previous, "below tier")
				assert(R.tokens(balance, 1200, floor.successes) == floor.base + floor.extras[i], "at tier")
				previous = floor.extras[i]
			end
		end
	end)
end
