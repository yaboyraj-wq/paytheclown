--!strict
return function(test: (string, () -> ()) -> ())
	test("world seeds reproduce a setup and separate nights, streams, plays and revisions", function()
		local Seeds = require("../../src/shared/Logic/WorldSeeds")
		local baseline = Seeds.derive(123456, { 1, 1, 1, 0 })
		assert(baseline == Seeds.derive(123456, { 1, 1, 1, 0 }), "same context reproduces setup")
		local cases = {
			{ 2, 1, 1, 0 },
			{ 1, 2, 1, 0 },
			{ 1, 1, 2, 0 },
			{ 1, 1, 1, 1 },
		}
		for _, context in cases do
			assert(Seeds.derive(123456, context) ~= baseline, "setup contexts must have independent seeds")
		end
		assert(Seeds.derive(654321, { 1, 1, 1, 0 }) ~= baseline, "new world changes Night 1 setup")
	end)
	test("derived seeds stay within the exact positive integer range at boundaries", function()
		local Seeds = require("../../src/shared/Logic/WorldSeeds")
		for _, master in { 1, 2147483646 } do
			local value = Seeds.derive(master, { 100, 3, 100000, 100000 })
			assert(value >= 1 and value <= 2147483646 and value % 1 == 0, "valid integer Random seed")
		end
	end)
end
