--!strict
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local Physics = game:GetService("PhysicsService")
local C = require(game.ReplicatedStorage.Shared.Config.Prototype)
local R = require(game.ReplicatedStorage.Shared.Config.Runtime)
local Locale = require(game.ReplicatedStorage.Shared.Util.Locale)
local Store = require(script.Parent.RunStore)
local WorldService = { model = nil :: Model? }
function WorldService.vector(value: { number }): Vector3
	return Vector3.new(value[1], value[2], value[3])
end
function WorldService.booth(id: string): Model
	return (WorldService.model :: Model):WaitForChild("Booths"):WaitForChild(id) :: Model
end
function WorldService.pad(id: string): BasePart
	return WorldService.booth(id):WaitForChild("ControlPad") :: BasePart
end
function WorldService.near(player: Player, part: BasePart, distance: number): boolean
	local character = player.Character
	local root = if character then character:FindFirstChild("HumanoidRootPart") else nil
	local humanoid = if character then character:FindFirstChildOfClass("Humanoid") else nil
	return root ~= nil
		and root:IsA("BasePart")
		and humanoid ~= nil
		and humanoid.Health > 0
		and (root.Position - part.Position).Magnitude <= distance
end
function WorldService.placePlayer(player: Player, night: boolean)
	local character = player.Character
	if not character then
		return
	end
	local position = WorldService.vector(if night then C.nightSpawn else C.daySpawn)
	local index = table.find(Players:GetPlayers(), player) or 1
	character:PivotTo(CFrame.new(position + Vector3.new((index - 1) * C.spawnSpread, 0, 0)))
end
function WorldService.init()
	Locale.init()
	for _, name in { "PTCBlocks", "PTCPit" } do
		if not Physics:IsCollisionGroupRegistered(name) then
			Physics:RegisterCollisionGroup(name)
		end
	end
	Physics:CollisionGroupSetCollidable("PTCBlocks", "Default", false)
	Physics:CollisionGroupSetCollidable("PTCBlocks", "PTCPit", true)
	local model = (ServerStorage.Assets.Graybox :: Model):Clone()
	model.Name = "Prototype"
	model.Parent = workspace
	WorldService.model = model
	for _, object in WorldService.booth("BLOCK_TOSS"):GetChildren() do
		if object:IsA("BasePart") and (object.Name == "Pit" or object.Name == "PitWall") then
			object.CollisionGroup = "PTCPit"
		end
	end
	for _, spec in C.booths do
		local prompt = Instance.new("ProximityPrompt")
		prompt.Name = "Play"
		prompt.ActionText = Locale.text("ACTION.PLAY")
		prompt.ObjectText = Locale.text("BOOTH." .. spec.id)
		prompt.MaxActivationDistance = R.CONTROLLER_DISTANCE
		prompt.RequiresLineOfSight = false
		prompt.Parent = WorldService.pad(spec.id)
	end
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "Ready"
	prompt.ActionText = Locale.text("ACTION.READY")
	prompt.ObjectText = Locale.text("WORLD.LOT")
	prompt.MaxActivationDistance = R.STATION_DISTANCE
	prompt.RequiresLineOfSight = false
	prompt.Parent = model:FindFirstChild("ReadyPad")
end
function WorldService.start()
	local function added(player: Player)
		player.CharacterAdded:Connect(function(character)
			character:WaitForChild("HumanoidRootPart")
			WorldService.placePlayer(
				player,
				Store.phase ~= "DAY" and Store.phase ~= "LOADING" and Store.phase ~= "RUN_OVER"
			)
		end)
		if player.Character then
			WorldService.placePlayer(player, Store.phase ~= "DAY" and Store.phase ~= "LOADING")
		end
	end
	Players.PlayerAdded:Connect(added)
	for _, player in Players:GetPlayers() do
		added(player)
	end
end
return WorldService
