--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Shared = game.ReplicatedStorage.Shared
local Net = require(Shared.Net.Net)
local Definitions = require(Shared.Net.Definitions)
local Input = require(Shared.Logic.InputRules)
local R = require(Shared.Config.Runtime)
local C = require(Shared.Config.Prototype)
local Booths = require(script.Parent.BoothService)
local Night = require(script.Parent.NightLoopService)
local Notify = require(script.Parent.Parent.Common.Notify)
local Logger = require(Shared.Util.Logger)
type Bucket = { start: number, count: number, seq: number, logged: boolean }
local buckets: { [Player]: { [string]: Bucket } } = {}
local schemas: { [string]: { string } } = {
	claim = { "kind", "seq", "booth" },
	stake = { "kind", "seq", "booth", "round", "amount" },
	vote = { "kind", "seq", "booth", "approval", "approve" },
	ready = { "kind", "seq" },
	skip = { "kind", "seq" },
	again = { "kind", "seq" },
	hello = { "kind", "seq" },
	stop = { "kind", "seq", "booth", "round", "time" },
	throw = { "kind", "seq", "booth", "round", "aim", "power", "spin" },
	setup = { "kind", "seq", "booth", "round", "count", "opening" },
	activity = { "kind", "seq", "booth", "round" },
	leave = { "kind", "seq", "booth", "round" },
	push = { "kind", "seq", "booth", "round" },
	bank = { "kind", "seq", "booth", "round" },
	reveal = { "kind", "seq", "booth", "round", "tile" },
}
local NetworkService = {}
local function valid(player: Player, channel: string, packet: any): boolean
	local time = workspace:GetServerTimeNow()
	buckets[player] = buckets[player] or {}
	local bucket = buckets[player][channel]
	if not bucket then
		bucket = { start = time, count = 0, seq = 0, logged = false }
		buckets[player][channel] = bucket
	end
	if time - bucket.start >= C.packetWindow then
		bucket.start = time
		bucket.count = 0
		bucket.logged = false
	end
	bucket.count += 1
	if
		bucket.count > Definitions[channel].rate
		or not Input.packet(packet)
		or type(packet.kind) ~= "string"
	then
		return false
	end
	local schema = schemas[packet.kind]
	if not schema or not Input.sequence(packet.seq, bucket.seq) then
		return false
	end
	for field in packet do
		if not table.find(schema, field) then
			return false
		end
	end
	for _, field in schema do
		if packet[field] == nil then
			return false
		end
	end
	for _, field in { "booth", "round", "approval" } do
		if packet[field] ~= nil and type(packet[field]) ~= "string" then
			return false
		end
	end
	if packet.approve ~= nil and type(packet.approve) ~= "boolean" then
		return false
	end
	bucket.seq = packet.seq
	return true
end
local function reject(player: Player, channel: string)
	local bucket = buckets[player][channel]
	if not bucket.logged then
		bucket.logged = true
		Logger.reject(channel, "rejected packet from " .. player.UserId)
	end
end
function NetworkService.init() end
function NetworkService.start()
	Net.get("Action").OnServerEvent:Connect(function(player, packet)
		if not valid(player, "Action", packet) then
			reject(player, "Action")
			return
		end
		local accepted = false
		if packet.kind == "claim" then
			accepted = Booths.claim(player, packet.booth)
		elseif packet.kind == "stake" then
			accepted = Booths.stake(player, packet.booth, packet.round, packet.amount)
		elseif packet.kind == "vote" then
			accepted = Booths.vote(player, packet.booth, packet.approval, packet.approve)
		elseif packet.kind == "ready" then
			accepted = Night.ready(player)
		elseif packet.kind == "skip" then
			accepted = Night.skip(player)
		elseif packet.kind == "again" then
			accepted = Night.again(player)
		elseif packet.kind == "hello" then
			accepted = true
			Net.get("RunState"):FireClient(player, Night.snapshot())
			Net.get("BoothState"):FireClient(player, Booths.snapshots())
		end
		if not accepted then
			reject(player, "Action")
			Notify.one(player, "TOAST.INVALID")
		end
	end)
	Net.get("BoothInput").OnServerEvent:Connect(function(player, packet)
		if not valid(player, "BoothInput", packet) then
			reject(player, "BoothInput")
			return
		end
		if not Booths.input(player, packet) then
			reject(player, "BoothInput")
		end
	end)
	Players.PlayerRemoving:Connect(function(player)
		buckets[player] = nil
	end)
	local elapsed = 0
	RunService.Heartbeat:Connect(function(delta)
		elapsed += delta
		if elapsed >= R.STATE_INTERVAL then
			elapsed = 0
			Net.get("RunState"):FireAllClients(Night.snapshot())
			Net.get("BoothState"):FireAllClients(Booths.snapshots())
		end
	end)
end
return NetworkService
