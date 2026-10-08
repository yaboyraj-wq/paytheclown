--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Logger = require(ReplicatedStorage.Shared.Util.Logger)
local RuntimeController = {}
function RuntimeController.init()
	ReplicatedStorage:WaitForChild("Net")
end
function RuntimeController.start()
	Logger.info("Client", "M0 bootstrap ready")
end
return RuntimeController
