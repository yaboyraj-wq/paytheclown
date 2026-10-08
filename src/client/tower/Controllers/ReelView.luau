--!strict
local Shared = game.ReplicatedStorage.Shared
local C = require(Shared.Config.Prototype)
local R = require(Shared.Config.Runtime)
local Reels = require(Shared.Logic.BoothLogic.Reels)
local Locale = require(Shared.Util.Locale)
local ReelView = {}
local folder: Instance? = nil
local labels: { { TextLabel } } = {}
local function connect(): boolean
	if folder and folder.Parent then
		return true
	end
	local world = workspace:FindFirstChild("Prototype")
	local booths = if world then world:FindFirstChild("Booths") else nil
	local booth = if booths then booths:FindFirstChild("STOP_REELS") else nil
	folder = if booth then booth:FindFirstChild("Reels") else nil
	if not folder then
		return false
	end
	labels = {}
	for index = 1, C.reelCount do
		local reel = folder:FindFirstChild("Reel" .. index)
		local display = if reel then reel:FindFirstChild("Window") else nil
		if not display then
			folder = nil
			return false
		end
		labels[index] = {}
		for row in C.reelRows do
			local label = display:FindFirstChild("Row" .. row)
			if not label or not label:IsA("TextLabel") then
				folder = nil
				return false
			end
			labels[index][row] = label
		end
	end
	return true
end
function ReelView.render(booths: { any }, time: number)
	if not connect() then
		return
	end
	for _, booth in booths do
		if booth.id ~= "STOP_REELS" then
			continue
		end
		for index, rows in labels do
			local strip = booth.strips[index]
			local symbols = {}
			if booth.state ~= "IDLE" and strip and #strip > 0 then
				local position = Reels.displayPosition(
					booth.offsets[index],
					R.PROTOTYPE_FLOOR,
					index,
					booth.state,
					booth.startTime,
					time,
					booth.positions[index]
				)
				symbols = Reels.window(strip, position)
			end
			for row, label in rows do
				local value = if symbols[row] then Locale.text("REELS.SYMBOL." .. symbols[row]) else ""
				if label.Text ~= value then
					label.Text = value
				end
			end
		end
		break
	end
end
return ReelView
