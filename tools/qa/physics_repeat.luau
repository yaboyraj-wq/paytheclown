local Env = require(game.ReplicatedStorage.Shared.Config.Environment).DEV
assert(game.PlaceId == Env.PlaceId and game.GameId == Env.GameId, "DEV only")
local T = game.ServerScriptService.Tower
local P = require(T.booths.BlockPhysics)
local W = require(T.WorldService)
local model = Instance.new("Model")
model.Name = "PhysicsQA"
model.Parent = workspace
for _, v in W.booth("BLOCK_TOSS"):GetChildren() do
	if v.Name == "Pit" or v.Name == "PitWall" then
		local copy = v:Clone()
		copy.Position += Vector3.new(0, 0, 200)
		copy.Parent = model
	end
end
local round = P.new(model)
local results = {}
for trial = 1, 20 do
	P.throw(round, 0, 0.5, 0, workspace:GetServerTimeNow())
	local total, void
	repeat
		task.wait(0.05)
		total, void = P.step(round, workspace:GetServerTimeNow())
	until total or void
	table.insert(results, if void then "VOID" else tostring(total))
	workspace:SetAttribute("PTCPhysicsTrial", trial)
end
workspace:SetAttribute("PTCPhysicsResults", game.HttpService:JSONEncode(results))
print("[PTC QA] Physics repeated throws: " .. table.concat(results, ","))
model:Destroy()
