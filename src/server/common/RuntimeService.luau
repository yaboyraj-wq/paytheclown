--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Environment = require(ReplicatedStorage.Shared.Config.Environment)
local Net = require(ReplicatedStorage.Shared.Net.Net)
local Logger = require(ReplicatedStorage.Shared.Util.Logger)
local Version = require(ReplicatedStorage.Shared.Config.Version)
local RuntimeService = {}
function RuntimeService.init()
	assert(
		game.GameId == Environment.DEV.GameId and game.PlaceId == Environment.DEV.PlaceId,
		"Pay the Clown refuses to run outside the authorized DEV place"
	)
	Net.init()
end
function RuntimeService.start()
	Logger.info("Server", Version.MILESTONE .. " bootstrap ready in DEV")
end
return RuntimeService
