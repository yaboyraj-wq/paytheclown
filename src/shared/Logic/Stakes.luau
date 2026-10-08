--!strict
local E = require("../Config/Economy")
local Input = require("./InputRules")
local Stakes = {}
function Stakes.cap(jar: number, floor: number, rookie: boolean): number
	return math.floor(math.min(E.STAKES[floor].max, jar, if rookie then jar * E.ROOKIE_CAP else jar))
end
function Stakes.valid(amount: any, jar: number, floor: number, rookie: boolean): boolean
	return Input.integer(amount)
		and amount >= E.STAKES[floor].min
		and amount <= Stakes.cap(jar, floor, rookie)
end
function Stakes.big(amount: number, jar: number, floor: number): boolean
	return amount > jar * E.BIG_FRACTION and amount > E.STAKES[floor].min * E.BIG_MIN_MULTIPLE
end
return Stakes
