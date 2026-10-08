--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Shared = game.ReplicatedStorage.Shared
local R = require(Shared.Config.Runtime)
local E = require(Shared.Config.Economy)
local C = require(Shared.Config.Prototype)
local Quota = require(Shared.Logic.Quota)
local Rules = require(Shared.Logic.RunRules)
local Store = require(script.Parent.RunStore)
local Jar = require(script.Parent.JarService)
local Booths = require(script.Parent.BoothService)
local World = require(script.Parent.WorldService)
local Notify = require(script.Parent.Parent.Common.Notify)
local NightLoopService = { history = {} :: { string } }
local function now(): number
	return workspace:GetServerTimeNow()
end
local function enter(phase: string, duration: number?)
	Store.phase = phase
	Store.entered = now()
	Store.deadline = if duration then Store.entered + duration else 0
	table.insert(NightLoopService.history, phase)
	workspace:SetAttribute("PTCPhase", phase)
	workspace:SetAttribute("PTCNight", Store.night)
end
local function moveCrew(night: boolean)
	for _, player in Players:GetPlayers() do
		World.placePlayer(player, night)
	end
end
function NightLoopService.reset()
	Store.run += 1
	Store.nightAttempt = 0
	Store.night = 1
	Store.tokens = E.DEFAULTS.tokens
	Store.bill = E.BILL.Normal
	Store.ready = {}
	Store.skip = {}
	Store.completed = {}
	Store.quota = Quota.calculate(1, math.max(1, #Players:GetPlayers()), E.DEFAULTS.difficulty)
	Store.closingPaid = false
	Store.finalCall = false
	Store.graceEnd = 0
	Store.departureEnd = nil
	Store.departureDelay = nil
	Store.forcedResult = nil
	Store.won = 0
	Store.lost = 0
	Store.best = 0
	Store.bestName = ""
	Jar.reset()
	Booths.reset()
	enter("DAY")
	moveCrew(false)
end
function NightLoopService.depart()
	if Store.phase ~= "DAY" or #Players:GetPlayers() == 0 then
		return
	end
	Store.crewSize = math.clamp(#Players:GetPlayers(), 1, R.MAX_CREW)
	Store.nightAttempt += 1
	Store.quota = Quota.calculate(Store.night, Store.crewSize, E.DEFAULTS.difficulty)
	Store.ready = {}
	Store.skip = {}
	Store.closingPaid = false
	Store.finalCall = false
	Store.graceEnd = 0
	Store.forcedResult = nil
	Store.won = 0
	Store.lost = 0
	Store.best = 0
	Store.bestName = ""
	Booths.reset()
	enter("DEPARTING", R.DEPART_SECONDS)
end
function NightLoopService.ready(player: Player): boolean
	if Store.phase ~= "DAY" then
		return false
	end
	Store.ready[player.UserId] = not Store.ready[player.UserId]
	return true
end
function NightLoopService.skip(player: Player): boolean
	if Store.phase ~= "RESULT_SUCCESS" or now() - Store.entered < R.RESULT_SKIP_AFTER then
		return false
	end
	Store.skip[player.UserId] = true
	return true
end
function NightLoopService.again(player: Player): boolean
	if Store.phase ~= "RUN_OVER" or Store.host ~= player.UserId then
		return false
	end
	NightLoopService.reset()
	return true
end
function NightLoopService.adminSkip()
	if Store.phase == "DAY" then
		NightLoopService.depart()
	elseif Store.phase == "NIGHT" or Store.deadline > 0 then
		Store.deadline = now()
	end
end
function NightLoopService.adminNight(night: number)
	Booths.closing(true)
	Store.night = night
	Store.ready = {}
	Store.departureEnd = nil
	Store.departureDelay = nil
	Store.quota = Quota.calculate(night, math.max(1, #Players:GetPlayers()), E.DEFAULTS.difficulty)
	enter("DAY")
	moveCrew(false)
end
function NightLoopService.adminResult(passed: boolean)
	Store.forcedResult = passed
	if Store.phase == "NIGHT" then
		Store.deadline = now()
	end
end
local function nextDay()
	Store.night += 1
	Store.ready = {}
	Store.skip = {}
	Store.departureEnd = nil
	Store.departureDelay = nil
	Store.quota = Quota.calculate(Store.night, math.max(1, #Players:GetPlayers()), E.DEFAULTS.difficulty)
	enter("DAY")
	moveCrew(false)
end
function NightLoopService.step(time: number)
	if Store.phase == "LOADING" then
		local ready = false
		for _, player in Players:GetPlayers() do
			if player.Character then
				ready = true
			end
		end
		if ready or time >= Store.deadline then
			NightLoopService.reset()
		end
	elseif Store.phase == "DAY" then
		local ready = 0
		for _, player in Players:GetPlayers() do
			if Store.ready[player.UserId] then
				ready += 1
			end
		end
		local delay = Rules.readyDelay(ready, #Players:GetPlayers())
		if delay ~= Store.departureDelay then
			Store.departureDelay = delay
			Store.departureEnd = if delay then time + delay else nil
		end
		if Store.departureEnd and time >= Store.departureEnd then
			NightLoopService.depart()
		end
	elseif Store.phase == "DEPARTING" and time >= Store.deadline then
		moveCrew(true)
		enter("NIGHT_INTRO", R.NIGHT_INTRO_SECONDS)
	elseif Store.phase == "NIGHT_INTRO" and time >= Store.deadline then
		enter("NIGHT", R.NIGHT_SECONDS)
	elseif Store.phase == "NIGHT" then
		if time >= Store.deadline then
			if Store.graceEnd == 0 then
				Store.graceEnd = Store.deadline + R.CLOSING_GRACE_SECONDS
				Booths.closing(false)
			end
			if time >= Store.graceEnd then
				Booths.closing(true)
				enter("CLOSING", R.CLOSING_SECONDS)
			end
		elseif not Store.finalCall and Store.deadline - time <= R.FINAL_CALL_SECONDS then
			Store.finalCall = true
			Notify.all("TOAST.FINAL")
		end
	elseif Store.phase == "CLOSING" and time >= Store.deadline and not Store.closingPaid then
		Store.closingPaid = true
		if Store.forcedResult == true and Jar.balance() < Store.quota then
			Jar.change(
				Store.quota - Jar.balance(),
				"DEV_FORCE",
				tostring(Store.run) .. ":" .. Store.nightAttempt .. ":force",
				0
			)
		end
		local success = if Store.forcedResult ~= nil then Store.forcedResult else Jar.balance() >= Store.quota
		if success then
			assert(
				Jar.change(
					-Store.quota,
					"QUOTA",
					tostring(Store.run) .. ":" .. Store.nightAttempt .. ":quota",
					0
				),
				"Quota must settle once"
			)
			Store.tokens = math.min(E.MAX_TOKENS, Store.tokens + Rules.tokens(Jar.balance(), Store.quota))
			for _, player in Players:GetPlayers() do
				Store.completed[player.UserId] = (Store.completed[player.UserId] or 0) + 1
			end
			enter("RESULT_SUCCESS", R.RESULT_SECONDS)
		else
			enter("RESULT_FAIL", R.RESULT_SKIP_AFTER)
		end
	elseif Store.phase == "RESULT_SUCCESS" then
		local votes = 0
		for _, player in Players:GetPlayers() do
			if Store.skip[player.UserId] then
				votes += 1
			end
		end
		if
			time >= Store.deadline
			or (time - Store.entered >= R.RESULT_SKIP_AFTER and votes > #Players:GetPlayers() - votes)
		then
			nextDay()
		end
	elseif Store.phase == "RESULT_FAIL" and time >= Store.deadline then
		enter("CANNON", R.CANNON_SECONDS)
		for _, player in Players:GetPlayers() do
			local character = player.Character
			local root = if character then character:FindFirstChild("HumanoidRootPart") else nil
			if root and root:IsA("BasePart") and character then
				character:PivotTo(CFrame.new(World.vector(C.cannonPosition)))
				root:SetNetworkOwner(nil)
				root:ApplyImpulse(Vector3.new(0, R.CANNON_UP, R.CANNON_FORWARD) * root.AssemblyMass)
			end
		end
	elseif Store.phase == "CANNON" and time >= Store.deadline then
		enter("RUN_OVER")
		for _, player in Players:GetPlayers() do
			local character = player.Character
			local root = if character then character:FindFirstChild("HumanoidRootPart") else nil
			if root and root:IsA("BasePart") then
				root:SetNetworkOwnershipAuto()
			end
		end
	end
	Booths.step(time)
end
function NightLoopService.snapshot(): { [string]: any }
	local crew = {}
	for _, player in Players:GetPlayers() do
		table.insert(
			crew,
			{ id = player.UserId, name = player.DisplayName, ready = Store.ready[player.UserId] or false }
		)
	end
	return {
		phase = Store.phase,
		night = Store.night,
		quota = Store.quota,
		crewSize = Store.crewSize,
		jar = Jar.balance(),
		tokens = Store.tokens,
		bill = Store.bill,
		deadline = Store.deadline,
		entered = Store.entered,
		graceEnd = Store.graceEnd,
		finalCall = Store.finalCall,
		departureEnd = Store.departureEnd,
		crew = crew,
		approval = Store.approval,
		privacy = Store.privacy,
		host = Store.host,
		run = Store.run,
		won = Store.won,
		lost = Store.lost,
		best = Store.best,
		bestName = Store.bestName,
	}
end
function NightLoopService.init()
	enter("LOADING", R.LOADING_SECONDS)
end
function NightLoopService.start()
	local function added(player: Player)
		if Store.host == 0 then
			Store.host = player.UserId
		end
	end
	Players.PlayerAdded:Connect(added)
	for _, player in Players:GetPlayers() do
		added(player)
	end
	Players.PlayerRemoving:Connect(function(player)
		Store.ready[player.UserId] = nil
		Store.skip[player.UserId] = nil
		if Store.host == player.UserId then
			Store.host = 0
			for _, other in Players:GetPlayers() do
				if other ~= player then
					Store.host = other.UserId
					break
				end
			end
		end
	end)
	local readyPrompt = (World.model :: Model)
			:WaitForChild("ReadyPad")
			:WaitForChild("Ready") :: ProximityPrompt
	readyPrompt.Triggered:Connect(NightLoopService.ready)
	local elapsed = 0
	RunService.Heartbeat:Connect(function(delta)
		elapsed += delta
		if elapsed >= R.STATE_INTERVAL then
			elapsed = 0
			NightLoopService.step(now())
		end
	end)
end
return NightLoopService
