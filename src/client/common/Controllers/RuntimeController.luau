--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Logger = require(ReplicatedStorage.Shared.Util.Logger)
local Version = require(ReplicatedStorage.Shared.Config.Version)
local RuntimeController = {}
function RuntimeController.init()
	ReplicatedStorage:WaitForChild("Net")
end
function RuntimeController.start()
	Logger.info("Client", Version.MILESTONE .. " bootstrap ready")
end
return RuntimeController
