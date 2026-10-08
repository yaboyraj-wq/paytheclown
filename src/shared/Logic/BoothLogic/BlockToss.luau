--!strict
local C = require("../../Config/Booths").BLOCK_TOSS
export type Result = { point: number?, multiplier: number? }
local BlockToss = {}
function BlockToss.result(total: number, point: number?, pointTosses: number): Result
	if point == nil then
		if table.find(C.openingWins, total) then
			return { multiplier = C.payout.win }
		end
		if table.find(C.openingLosses, total) then
			return { multiplier = C.payout.loss }
		end
		return { point = total }
	end
	if total == point then
		return {
			point = point,
			multiplier = if table.find(C.hardPoints, point) then C.payout.hardPoint else C.payout.win,
		}
	end
	if total == C.openingWins[1] then
		return { point = point, multiplier = C.payout.loss }
	end
	return { point = point, multiplier = if pointTosses >= C.maxPointTosses then C.payout.tie else nil }
end
return BlockToss
