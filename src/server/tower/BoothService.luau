--!strict
local Players = game:GetService("Players")
local Shared = game.ReplicatedStorage.Shared
local R = require(Shared.Config.Runtime)
local C = require(Shared.Config.Prototype)
local B = require(Shared.Config.Booths)
local E = require(Shared.Config.Economy)
local Input = require(Shared.Logic.InputRules)
local Stakes = require(Shared.Logic.Stakes)
local Approval = require(Shared.Logic.Approval)
local Reels = require(Shared.Logic.BoothLogic.Reels)
local Blocks = require(Shared.Logic.BoothLogic.BlockToss)
local Pie = require(Shared.Logic.BoothLogic.PieSweeper)
local Store = require(script.Parent.RunStore)
local Jar = require(script.Parent.JarService)
local World = require(script.Parent.WorldService)
local Physics = require(script.Parent.booths.BlockPhysics)
local Notify = require(script.Parent.Parent.Common.Notify)
local Locale = require(Shared.Util.Locale)
export type Pending = {
	id: string,
	amount: number,
	jar: number,
	ends: number,
	votes: { [number]: boolean },
	eligible: { [number]: boolean },
}
export type Booth = {
	id: string,
	state: string,
	controller: Player?,
	round: string,
	stake: number,
	entered: number,
	lastActive: number,
	away: number?,
	deadline: number,
	startTime: number,
	lastPress: number,
	lastSequence: number,
	closed: boolean,
	strips: { { string } },
	offsets: { number },
	symbols: { string },
	board: Pie.Board?,
	previewEnd: number,
	pieCount: number,
	opening: number,
	multiplier: number,
	payout: number,
	point: number?,
	pointTosses: number,
	voids: number,
	physics: Physics.PhysicsRound?,
	pending: Pending?,
	approvalVersion: number,
	faces: { number },
}
local BoothService = {
	booths = {} :: { [string]: Booth },
	blocks = {} :: { [number]: number },
	cooldowns = {} :: { [number]: number },
	counter = 0,
}
local function now(): number
	return workspace:GetServerTimeNow()
end
local function state(booth: Booth, value: string)
	booth.state = value
	booth.entered = now()
end
local function permutation(length: number, random: Random): { number }
	local order = {}
	for i = 1, length do
		order[i] = i
	end
	for i = length, 2, -1 do
		local j = random:NextInteger(1, i)
		order[i], order[j] = order[j], order[i]
	end
	return order
end
local function preview(booth: Booth)
	local random = Random.new(R.SEED + BoothService.counter + Store.night + booth.approvalVersion)
	booth.board = Pie.create(
		booth.pieCount,
		booth.opening,
		permutation(B.PIE_SWEEPER.width * B.PIE_SWEEPER.height, random)
	)
	booth.previewEnd = now() + R.PIE_PREVIEW_SECONDS
end
function BoothService.current(player: Player): Booth?
	for _, booth in BoothService.booths do
		if booth.controller == player then
			return booth
		end
	end
	return nil
end
local function clear(booth: Booth)
	if booth.physics then
		Physics.stop(booth.physics)
	end
	booth.controller = nil
	booth.pending = nil
	booth.stake = 0
	booth.symbols = {}
	booth.multiplier = 0
	booth.payout = 0
	booth.board = nil
	booth.away = nil
	booth.point = nil
	booth.pointTosses = 0
	booth.voids = 0
	booth.faces = {}
	state(booth, "IDLE")
end
function BoothService.reset()
	BoothService.blocks = {}
	BoothService.cooldowns = {}
	for _, booth in BoothService.booths do
		clear(booth)
		booth.closed = false
	end
end
function BoothService.resolve(booth: Booth, multiplier: number)
	if booth.stake <= 0 or booth.state == "RESOLVING" or booth.state == "COOLDOWN" then
		return
	end
	local player = booth.controller
	local settings: { [string]: any } = B
	booth.multiplier = math.clamp(multiplier, 0, settings[booth.id].maxMultiplier)
	booth.payout = Jar.pay(
		booth.stake,
		booth.multiplier,
		settings[booth.id].maxMultiplier,
		booth.round,
		if player then player.UserId else 0
	)
	if booth.physics then
		Physics.stop(booth.physics)
	end
	state(booth, "RESOLVING")
	Store.won += booth.payout
	local profit = booth.payout - booth.stake
	if profit > Store.best then
		Store.best = profit
		Store.bestName = if player then player.DisplayName else ""
	end
	Notify.all("TOAST.RESULT", {
		name = if player then player.DisplayName else "",
		booth = Locale.text("BOOTH." .. booth.id),
		multiplier = booth.multiplier,
		payout = booth.payout,
	})
end
local function safeMultiplier(booth: Booth): number
	local board = booth.board
	return if board and board.safeCount > 0 then Pie.multiplier(board.count, board.safeCount) else 0
end
local function reveal(booth: Booth, tile: number)
	local board = booth.board
	if not board or board.revealed[tile] ~= nil then
		return
	end
	if not Pie.reveal(board, tile) then
		BoothService.resolve(booth, 0)
		return
	end
	booth.multiplier = safeMultiplier(booth)
	if
		booth.multiplier >= B.PIE_SWEEPER.maxMultiplier
		or board.safeCount == B.PIE_SWEEPER.width * B.PIE_SWEEPER.height - board.count
	then
		BoothService.resolve(booth, booth.multiplier)
	else
		state(booth, "PUSH_DECISION")
		booth.deadline = now() + B.PIE_SWEEPER.decision.F3
	end
end
function BoothService.claim(player: Player, id: string): boolean
	local booth = BoothService.booths[id]
	if
		not booth
		or Store.phase ~= "NIGHT"
		or now() >= Store.deadline
		or booth.state ~= "IDLE"
		or BoothService.current(player)
		or not World.near(player, World.pad(id), R.CONTROLLER_DISTANCE)
	then
		return false
	end
	BoothService.counter += 1
	booth.round = tostring(Store.run) .. ":" .. tostring(BoothService.counter)
	booth.controller = player
	booth.closed = false
	booth.stake = 0
	booth.lastSequence = 0
	booth.lastPress = 0
	booth.lastActive = now()
	booth.approvalVersion = 0
	booth.pieCount = B.PIE_SWEEPER.minPies
	booth.opening = C.defaultOpening
	state(booth, "CLAIMED")
	local random = Random.new(R.SEED + Store.night + BoothService.counter)
	booth.offsets = {}
	booth.strips = {}
	booth.symbols = {}
	for index = 1, C.reelCount do
		local strip = {}
		for _, slot in
			permutation(#B.STOP_REELS.strip, Random.new(R.SEED + Store.night * C.reelCount + index))
		do
			table.insert(strip, B.STOP_REELS.strip[slot])
		end
		booth.strips[index] = strip
		booth.offsets[index] = random:NextInteger(0, #strip - 1)
	end
	if booth.id == "PIE_SWEEPER" then
		preview(booth)
	end
	state(booth, "STAKING")
	return true
end
local function pending(booth: Booth, amount: number)
	booth.approvalVersion += 1
	local eligible = {}
	for _, player in Players:GetPlayers() do
		if player ~= booth.controller then
			eligible[player.UserId] = true
		end
	end
	booth.pending = {
		id = booth.round .. ":" .. booth.approvalVersion,
		amount = amount,
		jar = Jar.balance(),
		ends = now() + E.APPROVAL_SECONDS,
		votes = {},
		eligible = eligible,
	}
end
local function lock(booth: Booth, amount: number): boolean
	local player = booth.controller
	if
		not player
		or Store.phase ~= "NIGHT"
		or now() >= Store.deadline
		or not World.near(player, World.pad(booth.id), R.CONTROLLER_DISTANCE)
	then
		return false
	end
	local rookie = Store.privacy == "Public" and (Store.completed[player.UserId] or 0) < 1
	if not Jar.lock(amount, R.PROTOTYPE_FLOOR, rookie, booth.round, player.UserId) then
		return false
	end
	booth.pending = nil
	booth.stake = amount
	Store.lost += amount
	state(booth, "LOCKED")
	booth.startTime = now() + R.LOCK_SECONDS
	booth.lastPress = booth.startTime - B.STOP_REELS.pressDebounce
	return true
end
function BoothService.stake(player: Player, id: string, round: string, amount: number): boolean
	local booth = BoothService.booths[id]
	if
		not booth
		or booth.controller ~= player
		or booth.round ~= round
		or booth.state ~= "STAKING"
		or booth.pending
		or not World.near(player, World.pad(id), R.CONTROLLER_DISTANCE)
		or Store.phase ~= "NIGHT"
		or now() >= Store.deadline
	then
		return false
	end
	local rookie = Store.privacy == "Public" and (Store.completed[player.UserId] or 0) < 1
	if not Stakes.valid(amount, Jar.balance(), R.PROTOTYPE_FLOOR, rookie) then
		return false
	end
	if id == "PIE_SWEEPER" and now() < booth.previewEnd then
		return false
	end
	booth.lastActive = now()
	if Stakes.big(amount, Jar.balance(), R.PROTOTYPE_FLOOR) then
		if now() < (BoothService.cooldowns[player.UserId] or 0) then
			Notify.one(player, "TOAST.COOLDOWN")
			return false
		end
		pending(booth, amount)
		return true
	end
	return lock(booth, amount)
end
function BoothService.vote(player: Player, id: string, approvalId: string, approve: boolean): boolean
	local booth = BoothService.booths[id]
	local request = if booth then booth.pending else nil
	if
		not request
		or request.id ~= approvalId
		or not request.eligible[player.UserId]
		or now() >= request.ends
		or request.votes[player.UserId] ~= nil
	then
		return false
	end
	request.votes[player.UserId] = approve
	return true
end
local function stopReel(booth: Booth, time: number)
	local index = #booth.symbols + 1
	if index > C.reelCount then
		return
	end
	booth.symbols[index] = Reels.symbol(
		booth.strips[index],
		booth.offsets[index],
		R.PROTOTYPE_FLOOR,
		index,
		time - booth.startTime
	)
	booth.lastPress = time
	if #booth.symbols == C.reelCount then
		BoothService.resolve(booth, Reels.multiplier(booth.symbols))
	end
end
function BoothService.input(player: Player, packet: { [string]: any }): boolean
	local booth = BoothService.booths[packet.booth]
	if
		not booth
		or booth.controller ~= player
		or packet.round ~= booth.round
		or not Input.sequence(packet.seq, booth.lastSequence)
		or not World.near(player, World.pad(booth.id), R.CONTROLLER_DISTANCE)
	then
		return false
	end
	booth.lastSequence = packet.seq
	booth.lastActive = now()
	if packet.kind == "leave" and booth.state == "STAKING" then
		clear(booth)
		return true
	end
	if packet.kind == "activity" and booth.state == "STAKING" then
		return true
	end
	if
		packet.kind == "setup"
		and booth.state == "STAKING"
		and not booth.pending
		and booth.id == "PIE_SWEEPER"
	then
		if
			not Input.integer(packet.count)
			or not Input.integer(packet.opening)
			or packet.count < B.PIE_SWEEPER.allowed.F3[1]
			or packet.count > B.PIE_SWEEPER.allowed.F3[2]
			or packet.opening < 1
			or packet.opening > B.PIE_SWEEPER.width * B.PIE_SWEEPER.height
		then
			return false
		end
		booth.pieCount = packet.count
		booth.opening = packet.opening
		booth.approvalVersion += 1
		preview(booth)
		return true
	end
	if booth.state ~= "PLAYING" and booth.state ~= "PUSH_DECISION" then
		return false
	end
	if packet.kind == "stop" and booth.id == "STOP_REELS" and booth.state == "PLAYING" then
		if
			not Input.timestamp(packet.time, now(), player:GetNetworkPing(), booth.lastPress)
			or packet.time < booth.startTime
			or packet.time - booth.lastPress < B.STOP_REELS.pressDebounce
		then
			return false
		end
		stopReel(booth, packet.time)
		return true
	elseif
		packet.kind == "throw"
		and booth.id == "BLOCK_TOSS"
		and booth.physics
		and not booth.physics.active
	then
		if
			not Input.finite(packet.aim)
			or not Input.finite(packet.power)
			or not Input.finite(packet.spin)
		then
			return false
		end
		local spin = math.round(math.clamp(packet.spin, -1, 1))
		Physics.throw(
			booth.physics,
			math.clamp(packet.aim, -C.angleMax, C.angleMax),
			math.clamp(packet.power, 0, 1),
			spin,
			now()
		)
		return true
	elseif booth.id == "PIE_SWEEPER" then
		if packet.kind == "bank" then
			BoothService.resolve(booth, safeMultiplier(booth))
			return true
		end
		if packet.kind == "push" and booth.state == "PUSH_DECISION" then
			state(booth, "PLAYING")
			booth.deadline = now() + B.PIE_SWEEPER.decision.F3
			local amount = math.floor(booth.stake * safeMultiplier(booth))
			if amount > Jar.balance() * E.BIG_FRACTION then
				Notify.all("TOAST.PUSH", { name = player.DisplayName, amount = amount })
			end
			return true
		end
		if
			packet.kind == "reveal"
			and booth.state == "PLAYING"
			and Input.integer(packet.tile)
			and packet.tile >= 1
			and packet.tile <= B.PIE_SWEEPER.width * B.PIE_SWEEPER.height
		then
			reveal(booth, packet.tile)
			return true
		end
	end
	return false
end
function BoothService.closing(final: boolean)
	for _, booth in BoothService.booths do
		booth.closed = true
		if booth.state == "STAKING" or booth.state == "CLAIMED" then
			clear(booth)
		elseif
			final and (booth.state == "LOCKED" or booth.state == "PLAYING" or booth.state == "PUSH_DECISION")
		then
			BoothService.resolve(booth, if booth.state == "PUSH_DECISION" then safeMultiplier(booth) else 0)
		end
	end
end
function BoothService.step(time: number)
	for _, booth in BoothService.booths do
		if booth.state == "STAKING" and booth.controller then
			if World.near(booth.controller, World.pad(booth.id), R.CONTROLLER_DISTANCE) then
				booth.away = nil
			else
				booth.away = booth.away or time
			end
			if
				time - booth.lastActive >= R.KEYPAD_IDLE_SECONDS
				or (booth.away and time - booth.away >= R.CLAIM_AWAY_SECONDS)
			then
				clear(booth)
				continue
			end
			local request = booth.pending
			if request and time >= request.ends then
				local votes = {}
				for id, vote in request.votes do
					if Players:GetPlayerByUserId(id) then
						table.insert(votes, vote)
					end
				end
				local player = booth.controller :: Player
				if Approval.blocked(Store.approval, votes) then
					BoothService.blocks[player.UserId] = (BoothService.blocks[player.UserId] or 0) + 1
					if BoothService.blocks[player.UserId] >= E.BLOCK_LIMIT then
						BoothService.cooldowns[player.UserId] = time + E.BIG_COOLDOWN
						BoothService.blocks[player.UserId] = 0
					end
					booth.pending = nil
					Notify.one(player, "TOAST.BLOCKED")
				elseif
					Jar.balance() < request.jar
					and Stakes.valid(request.amount, Jar.balance(), R.PROTOTYPE_FLOOR, false)
				then
					pending(booth, request.amount)
					booth.lastActive = time
					Notify.one(player, "TOAST.JAR_CHANGED")
				elseif not lock(booth, request.amount) then
					booth.pending = nil
					Notify.one(player, "TOAST.INVALID")
				end
			end
		elseif booth.state == "LOCKED" and time >= booth.startTime then
			state(booth, "PLAYING")
			booth.deadline = time + R.KEYPAD_IDLE_SECONDS
			if booth.id == "PIE_SWEEPER" then
				reveal(booth, booth.opening)
			end
		elseif booth.state == "PLAYING" then
			if booth.id == "STOP_REELS" then
				local stopTime = booth.startTime
					+ B.STOP_REELS.autoStopSeconds
					+ #booth.symbols * B.STOP_REELS.autoStopSpacing
				if time >= stopTime then
					stopReel(booth, stopTime)
				end
			elseif booth.id == "BLOCK_TOSS" and booth.physics then
				local total, void = Physics.step(booth.physics, time)
				if void then
					booth.voids += 1
					booth.deadline = time + R.KEYPAD_IDLE_SECONDS
					if booth.voids >= B.BLOCK_TOSS.maxVoids then
						BoothService.resolve(booth, 0)
					elseif booth.controller then
						Notify.one(
							booth.controller,
							"TOAST.VOID",
							{ voids = booth.voids, max = B.BLOCK_TOSS.maxVoids }
						)
					end
				elseif total then
					booth.faces = table.clone(booth.physics.faces)
					if booth.point then
						booth.pointTosses += 1
					end
					local result = Blocks.result(total, booth.point, booth.pointTosses)
					booth.point = result.point
					if result.multiplier ~= nil then
						BoothService.resolve(booth, result.multiplier)
					else
						booth.deadline = time + R.KEYPAD_IDLE_SECONDS
					end
				elseif not booth.physics.active and time >= booth.deadline then
					BoothService.resolve(booth, 0)
				end
			elseif booth.id == "PIE_SWEEPER" and time >= booth.deadline then
				BoothService.resolve(booth, safeMultiplier(booth))
			end
		elseif booth.state == "PUSH_DECISION" and time >= booth.deadline then
			BoothService.resolve(booth, safeMultiplier(booth))
		elseif booth.state == "RESOLVING" and time - booth.entered >= R.RESULT_PRESENT_SECONDS then
			state(booth, "COOLDOWN")
		elseif booth.state == "COOLDOWN" and time - booth.entered >= R.COOLDOWN_SECONDS then
			clear(booth)
		end
	end
end
function BoothService.snapshots(): { any }
	local result = {}
	for _, spec in C.booths do
		local b = BoothService.booths[spec.id]
		local board = b.board
		local request = b.pending
		table.insert(result, {
			id = b.id,
			state = b.state,
			controller = if b.controller then b.controller.UserId else 0,
			name = if b.controller then b.controller.DisplayName else "",
			round = b.round,
			stake = b.stake,
			startTime = b.startTime,
			symbols = table.clone(b.symbols),
			strips = b.strips,
			offsets = b.offsets,
			deadline = b.deadline,
			multiplier = b.multiplier,
			payout = b.payout,
			point = b.point,
			pointTosses = b.pointTosses,
			faces = b.faces,
			physicsActive = if b.physics then b.physics.active else false,
			locks = if b.physics then b.physics.locks else nil,
			pieCount = b.pieCount,
			opening = b.opening,
			previewEnd = b.previewEnd,
			preview = if board and b.state == "STAKING" then table.clone(board.pies) else nil,
			revealed = if board then table.clone(board.revealed) else {},
			safeCount = if board then board.safeCount else 0,
			pending = if request
				then {
					id = request.id,
					amount = request.amount,
					jar = request.jar,
					ends = request.ends,
					eligible = table.clone(request.eligible),
					votes = table.clone(request.votes),
				}
				else nil,
		})
	end
	return result
end
function BoothService.init()
	for _, spec in C.booths do
		local booth: Booth = {
			id = spec.id,
			state = "IDLE",
			round = "",
			stake = 0,
			entered = 0,
			lastActive = 0,
			deadline = 0,
			startTime = 0,
			lastPress = 0,
			lastSequence = 0,
			closed = false,
			strips = {},
			offsets = {},
			symbols = {},
			previewEnd = 0,
			pieCount = B.PIE_SWEEPER.minPies,
			opening = C.defaultOpening,
			multiplier = 0,
			payout = 0,
			pointTosses = 0,
			voids = 0,
			approvalVersion = 0,
			faces = {},
		}
		if spec.id == "BLOCK_TOSS" then
			booth.physics = Physics.new(World.booth("BLOCK_TOSS"))
		end
		BoothService.booths[spec.id] = booth
	end
end
function BoothService.start()
	for _, spec in C.booths do
		(World.pad(spec.id):FindFirstChild("Play") :: ProximityPrompt).Triggered:Connect(function(player)
			BoothService.claim(player, spec.id)
		end)
	end
	Players.PlayerRemoving:Connect(function(player)
		local booth = BoothService.current(player)
		if booth then
			if booth.stake > 0 then
				BoothService.resolve(booth, if booth.id == "PIE_SWEEPER" then safeMultiplier(booth) else 0)
			else
				clear(booth)
			end
		end
	end)
end
return BoothService
