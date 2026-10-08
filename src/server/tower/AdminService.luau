--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local Shared = game.ReplicatedStorage.Shared
local Env = require(Shared.Config.Environment).DEV
local C = require(Shared.Config.Prototype)
local R = require(Shared.Config.Runtime)
local Input = require(Shared.Logic.InputRules)
local Jar = require(script.Parent.JarService)
local Night = require(script.Parent.NightLoopService)
local Notify = require(script.Parent.Parent.Common.Notify)
local AdminService = { counter = 0 }
function AdminService.allowed(player: Player): boolean
	return game.PlaceId == Env.PlaceId
		and game.GameId == Env.GameId
		and (RunService:IsStudio() or (Env.OwnerUserId ~= 0 and player.UserId == Env.OwnerUserId))
end
function AdminService.apply(player: Player, command: string, value: number?): boolean
	if not AdminService.allowed(player) then
		return false
	end
	if command == C.adminCommands.jar then
		if not Input.integer(value) or (value :: number) < 0 or (value :: number) > C.adminMaxTickets then
			return false
		end
		AdminService.counter += 1
		Jar.change(
			(value :: number) - Jar.balance(),
			"DEV_SET_JAR",
			"admin:" .. AdminService.counter,
			player.UserId
		)
	elseif command == C.adminCommands.skip then
		Night.adminSkip()
	elseif command == C.adminCommands.night then
		if not Input.integer(value) or (value :: number) < 1 or (value :: number) > R.MAX_ADMIN_NIGHT then
			return false
		end
		Night.adminNight(value :: number)
	elseif command == C.adminCommands.pass then
		Night.adminResult(true)
	elseif command == C.adminCommands.fail then
		Night.adminResult(false)
	else
		return false
	end
	Notify.one(player, "TOAST.ADMIN", { command = command })
	return true
end
function AdminService.init() end
function AdminService.start()
	local command = Instance.new("TextChatCommand")
	command.Name = "PTCAdmin"
	command.PrimaryAlias = C.adminPrefix
	command.Parent = TextChatService
	command.Triggered:Connect(function(source, text)
		local player = Players:GetPlayerByUserId(source.UserId)
		if not player then
			return
		end
		local words = string.split(text, " ")
		AdminService.apply(player, words[2] or "", tonumber(words[3]))
	end)
end
return AdminService
