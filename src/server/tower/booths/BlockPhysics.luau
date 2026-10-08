--!strict
local Shared = game.ReplicatedStorage.Shared
local C = require(Shared.Config.Prototype)
local B = require(Shared.Config.Booths).BLOCK_TOSS
local World = require(script.Parent.Parent.WorldService)
export type PhysicsRound = {
	parts: { BasePart },
	center: Vector3,
	active: boolean,
	started: number,
	still: number?,
	locks: number?,
	faces: { number },
}
local BlockPhysics = {}
function BlockPhysics.new(parent: Model): PhysicsRound
	local center = (parent:FindFirstChild("Pit") :: BasePart).Position
	local round: PhysicsRound = { parts = {}, center = center, active = false, started = 0, faces = {} }
	for index = 1, 2 do
		local part = Instance.new("Part")
		part.Name = "Block" .. index
		part.Size = Vector3.one * C.cubeSize
		part.Anchored = true
		part.Color = Color3.fromHex(C.colorPart)
		part.CollisionGroup = "PTCBlocks"
		part.CustomPhysicalProperties =
			PhysicalProperties.new(C.density, C.friction, B.bounce[1], C.weight, C.weight)
		part.CFrame = CFrame.new(
			center
				+ Vector3.new(
					if index == 1 then -C.cubeSpacing else C.cubeSpacing,
					C.cubeStartY,
					C.cubeStartZ
				)
		)
		for _, face in C.faces do
			local gui = Instance.new("SurfaceGui")
			local faces: { [string]: Enum.NormalId } = {
				Top = Enum.NormalId.Top,
				Bottom = Enum.NormalId.Bottom,
				Right = Enum.NormalId.Right,
				Left = Enum.NormalId.Left,
				Front = Enum.NormalId.Front,
				Back = Enum.NormalId.Back,
			}
			gui.Face = faces[face.face]
			gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
			gui.PixelsPerStud = C.labelPixels
			gui.Parent = part
			local label = Instance.new("TextLabel")
			label.Size = UDim2.fromScale(1, 1)
			label.BackgroundTransparency = 1
			label.Text = C.facesText[face.value]
			label.TextSize = C.labelText
			label.TextColor3 = Color3.fromHex(C.colorDark)
			label.Font = Enum.Font.GothamBold
			label.Parent = gui
		end
		part.Parent = parent
		table.insert(round.parts, part)
	end
	return round
end
function BlockPhysics.top(part: BasePart): (number, Vector3, number)
	local best, normal, value = -math.huge, Vector3.yAxis, 1
	for _, face in C.faces do
		local world = part.CFrame:VectorToWorldSpace(World.vector(face.normal))
		local dot = world:Dot(Vector3.yAxis)
		if dot > best then
			best = dot
			normal = world
			value = face.value
		end
	end
	return value, normal, best
end
function BlockPhysics.flatten(part: BasePart)
	local _, normal, dot = BlockPhysics.top(part)
	local axis = normal:Cross(Vector3.yAxis)
	if axis.Magnitude > 0 then
		local rotation = CFrame.fromAxisAngle(axis.Unit, math.acos(math.clamp(dot, -1, 1)))
		part.CFrame = CFrame.new(part.Position) * rotation * part.CFrame.Rotation
	end
	part.AssemblyLinearVelocity = Vector3.zero
	part.AssemblyAngularVelocity = Vector3.zero
end
function BlockPhysics.throw(round: PhysicsRound, aim: number, power: number, spin: number, now: number)
	round.active = true
	round.started = now
	round.still = nil
	round.locks = nil
	round.faces = {}
	for index, part in round.parts do
		part.Anchored = true
		part.CFrame = CFrame.new(
			round.center
				+ Vector3.new(
					if index == 1 then -C.cubeSpacing else C.cubeSpacing,
					C.cubeStartY,
					C.cubeStartZ
				)
		)
		part.Anchored = false
		part:SetNetworkOwner(nil)
		local speed = C.powerBase + C.powerRange * power
		part.AssemblyLinearVelocity =
			Vector3.new(math.sin(aim) * speed, C.upBase + C.upRange * power, -math.cos(aim) * speed)
		part.AssemblyAngularVelocity = Vector3.new(
			C.angularBase + C.angularPower * power,
			spin * C.angularSpin,
			if index == 1 then C.angularZ else -C.angularZ
		)
	end
end
function BlockPhysics.stop(round: PhysicsRound)
	round.active = false
	for _, part in round.parts do
		part.Anchored = true
	end
end
function BlockPhysics.step(round: PhysicsRound, now: number): (number?, boolean)
	if not round.active then
		return nil, false
	end
	if round.locks then
		if now >= round.locks then
			BlockPhysics.stop(round)
			return round.faces[1] + round.faces[2], false
		end
		return nil, false
	end
	local settled = true
	for _, part in round.parts do
		local relative = part.Position - round.center
		if
			math.abs(relative.X) > C.pitHalf + C.pitMargin
			or math.abs(relative.Z) > C.pitHalf + C.pitMargin
			or relative.Y < C.voidY
		then
			BlockPhysics.stop(round)
			return nil, true
		end
		local slow = part.AssemblyLinearVelocity.Magnitude < B.settleSpeed
			and part.AssemblyAngularVelocity.Magnitude < B.settleAngular
		if now - round.started >= B.tiltSeconds and slow then
			BlockPhysics.flatten(part)
		end
		if not slow then
			settled = false
		end
	end
	if settled then
		round.still = round.still or now
	else
		round.still = nil
	end
	if
		(round.still and now - round.still >= B.settleSeconds)
		or now - round.started >= B.maxPhysicsSeconds
	then
		for _, part in round.parts do
			BlockPhysics.flatten(part)
			part.Anchored = true
			local value = BlockPhysics.top(part)
			table.insert(round.faces, value)
		end
		round.locks = now + B.bonkSeconds
	end
	return nil, false
end
return BlockPhysics
