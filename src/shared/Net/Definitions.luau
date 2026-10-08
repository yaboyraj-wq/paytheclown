--!strict
local Config = require("../Config/Runtime")
local definitions: { [string]: { direction: string, rate: number } } = {
	RunState = { direction = "S2C", rate = Config.UI_RATE },
	BoothState = { direction = "S2C", rate = Config.INPUT_RATE },
	Toast = { direction = "S2C", rate = Config.UI_RATE },
	Action = { direction = "C2S", rate = Config.UI_RATE },
	BoothInput = { direction = "C2S", rate = Config.INPUT_RATE },
}
return definitions
