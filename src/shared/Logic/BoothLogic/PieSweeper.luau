--!strict
local C = require("../../Config/Booths").PIE_SWEEPER
local Runtime = require("../../Config/Runtime")
export type Board = {
	pies: { [number]: boolean },
	revealed: { [number]: number },
	count: number,
	opening: number,
	safeCount: number,
}
local PieSweeper = {}
function PieSweeper.neighbors(tile: number): { number }
	local result = {}
	local x, y = (tile - 1) % C.width, math.floor((tile - 1) / C.width)
	for dx = -1, 1 do
		for dy = -1, 1 do
			if
				(dx ~= 0 or dy ~= 0)
				and x + dx >= 0
				and x + dx < C.width
				and y + dy >= 0
				and y + dy < C.height
			then
				table.insert(result, (y + dy) * C.width + x + dx + 1)
			end
		end
	end
	return result
end
function PieSweeper.create(count: number, opening: number, order: { number }): Board
	local excluded = { [opening] = true }
	if count <= C.neighborProtectionLimit then
		for _, tile in PieSweeper.neighbors(opening) do
			excluded[tile] = true
		end
	end
	local board: Board = { pies = {}, revealed = {}, count = count, opening = opening, safeCount = 0 }
	local added = 0
	for _, tile in order do
		if not excluded[tile] and not board.pies[tile] then
			board.pies[tile] = true
			added += 1
			if added == count then
				break
			end
		end
	end
	assert(added == count, "Setup must contain enough distinct eligible tiles")
	return board
end
function PieSweeper.neighborCount(board: Board, tile: number): number
	local count = 0
	for _, neighbor in PieSweeper.neighbors(tile) do
		if board.pies[neighbor] then
			count += 1
		end
	end
	return count
end
function PieSweeper.reveal(board: Board, tile: number): boolean
	if board.pies[tile] or board.revealed[tile] ~= nil then
		return false
	end
	board.revealed[tile] = PieSweeper.neighborCount(board, tile)
	board.safeCount += 1
	return true
end
function PieSweeper.multiplier(pies: number, revealed: number): number
	if revealed <= 1 then
		return 1
	end
	local total = C.width * C.height
	local multiplier = 1
	-- Remove the guaranteed first tile from both numerator and denominator.
	for i = 1, revealed - 1 do
		multiplier *= (total - i) / (total - pies - i)
	end
	return math.min(C.maxMultiplier, math.round(multiplier * Runtime.DECIMALS) / Runtime.DECIMALS)
end
return PieSweeper
