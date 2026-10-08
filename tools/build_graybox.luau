--!strict
-- Rebuilds only our original model file, never opens or edits an existing place.
local fs = require("@lune/fs")
local r = require("@lune/roblox")
local C = require("../src/shared/Config/Prototype")
local Strings = require("../src/shared/Config/Strings")
local Instance, Vector3, CFrame, Color3 = r.Instance, r.Vector3, r.CFrame, r.Color3
local function v(t)
	return Vector3.new(t[1], t[2], t[3])
end
local model = Instance.new("Model")
model.Name = "Prototype"
local function part(parent, name, size, position, color)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = v(size)
	p.CFrame = CFrame.new(position)
	p.Anchored = true
	p.Color = Color3.fromHex(color)
	p.TopSurface = r.Enum.SurfaceType.Smooth
	p.BottomSurface = r.Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end
local function sign(parent, name, key, size, position)
	local p = part(parent, name, size, position, C.colorDark)
	local gui = Instance.new("SurfaceGui")
	gui.Name = "Sign"
	gui.Face = r.Enum.NormalId.Front
	gui.SizingMode = r.Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = C.labelPixels
	gui.Parent = p
	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.Size = r.UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = Strings[key] or key
	label.TextSize = C.labelText
	label.TextColor3 = Color3.fromHex("FFFFFF")
	label.TextWrapped = true
	label.Parent = gui
	return p
end
part(model, "Floor", C.floorSize, v(C.floorPosition), C.colorFloor)
local ready = part(model, "ReadyPad", C.readySize, v(C.readyPosition), C.colorPad)
ready:SetAttribute("Station", "READY")
sign(model, "LotSign", "WORLD.LOT", C.signSize, v(C.lotSignPosition), C.colorDark)
local folder = Instance.new("Folder")
folder.Name = "Booths"
folder.Parent = model
for _, data in C.booths do
	local booth = Instance.new("Model")
	booth.Name = data.id
	booth.Parent = folder
	local center = v(data.position)
	part(booth, "ControlPad", C.padSize, center + v(C.padOffset), C.colorPad)
	local board = sign(booth, "Sign", "BOOTH." .. data.id, C.signSize, center + v(C.signOffset))
	-- Front faces positive Z toward arriving players.
	board.CFrame *= CFrame.Angles(0, math.pi, 0)
	for _, x in { -C.postX, C.postX } do
		part(booth, "Post", C.postSize, center + Vector3.new(x, C.postSize[2] / 2, C.postZ), C.colorPart)
	end
	if data.id == "BLOCK_TOSS" then
		part(booth, "Pit", C.pitSize, center, C.colorDark)
		for _, side in { -1, 1 } do
			part(
				booth,
				"PitWall",
				{ C.wallThickness, C.wallHeight, C.pitSize[3] },
				center + Vector3.new(side * C.pitHalf, C.wallHeight / 2, 0),
				C.colorPart
			)
			part(
				booth,
				"PitWall",
				{ C.pitSize[1], C.wallHeight, C.wallThickness },
				center + Vector3.new(0, C.wallHeight / 2, side * C.pitHalf),
				C.colorPart
			)
		end
	else
		part(booth, "Counter", C.counterSize, center, C.colorPart)
	end
	if data.id == "STOP_REELS" then
		local reels = Instance.new("Folder")
		reels.Name = "Reels"
		reels.Parent = booth
		for index = 1, C.reelCount do
			local reel = part(
				reels,
				"Reel" .. index,
				C.reelSize,
				center + v(C.reelOffset) + Vector3.new((index - (C.reelCount + 1) / 2) * C.reelSpacing, 0, 0),
				C.colorDark
			)
			reel.CFrame *= CFrame.Angles(0, math.pi, 0)
			local display = Instance.new("SurfaceGui")
			display.Name = "Window"
			display.Face = r.Enum.NormalId.Front
			display.SizingMode = r.Enum.SurfaceGuiSizingMode.PixelsPerStud
			display.PixelsPerStud = C.labelPixels
			display.Parent = reel
			for row, offset in C.reelRows do
				local label = Instance.new("TextLabel")
				label.Name = "Row" .. row
				label.Size = r.UDim2.fromScale(1, 1 / #C.reelRows)
				label.Position = r.UDim2.fromScale(0, (row - 1) / #C.reelRows)
				label.BackgroundColor3 = Color3.fromHex(if offset == 0 then C.reelCenterColor else C.colorPad)
				label.BorderSizePixel = 0
				label.TextColor3 = Color3.fromHex(C.colorDark)
				label.TextSize = C.reelSymbolText
				label.TextScaled = true
				local limit = Instance.new("UITextSizeConstraint")
				limit.MinTextSize = C.ui.small
				limit.MaxTextSize = C.reelSymbolText
				limit.Parent = label
				label.Text = ""
				label.Parent = display
			end
		end
	end
end
part(model, "Cannon", C.cannonSize, v(C.cannonPosition), C.colorDark)
fs.writeFile("assets/Graybox.rbxm", r.serializeModel({ model }))
print("Saved original gray-box floor, Lot 13 and three booths to assets/Graybox.rbxm")
