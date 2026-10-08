--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CAS = game:GetService("ContextActionService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Shared = game.ReplicatedStorage.Shared
local C = require(Shared.Config.Prototype)
local U = C.ui
local R = require(Shared.Config.Runtime)
local E = require(Shared.Config.Economy)
local B = require(Shared.Config.Booths)
local Theme = require(Shared.Config.UITheme)
local L = require(Shared.Util.Locale)
local Reels = require(Shared.Logic.BoothLogic.Reels)
local Stakes = require(Shared.Logic.Stakes)
local Net = require(Shared.Net.Net)
local Kit = require(script.Parent.Parent.Parent.Common.UI.Kit)
local Trove = require(game.ReplicatedStorage.Packages.Trove)
local player = Players.LocalPlayer
local GameController = {}
local cleanup = Trove.new()
local run: any = nil
local booths: { any } = {}
local active: any = nil
local sequence = { Action = 0, BoothInput = 0 }
local stake = E.STAKES[R.PROTOTYPE_FLOOR].min
local lastRound = ""
local flags: { [number]: boolean } = {}
local flagMode = false
local aim = 0
local spin = 0
local power = C.defaultPower
local chargeStart: number? = nil
local aimDrag = false
local cameraBooth = ""
local cameraTween: Tween? = nil
local toastEnd = 0
local toastText = ""
local approval: any = nil
local gui: ScreenGui
local root: Frame
local scale: UIScale
local refs: { [string]: any } = {}
local tiles: { TextButton } = {}
local reelLabels: { TextLabel } = {}
local stripLabels: { TextLabel } = {}
local previewLabels: { TextLabel } = {}
local function text(key: string, args: { [string]: any }?): string
	return L.text(key, args)
end
local function seconds(deadline: number): number
	return math.max(0, math.ceil(deadline - workspace:GetServerTimeNow()))
end
local function send(kind: string, values: { [string]: any }?)
	sequence.Action += 1
	local packet: { [string]: any } = values or {}
	packet.kind = kind
	packet.seq = sequence.Action
	Net.get("Action"):FireServer(packet)
end
local function input(kind: string, values: { [string]: any }?)
	if not active then
		return
	end
	sequence.BoothInput += 1
	local packet: { [string]: any } = values or {}
	packet.kind = kind
	packet.seq = sequence.BoothInput
	packet.booth = active.id
	packet.round = active.round
	Net.get("BoothInput"):FireServer(packet)
end
local function adjust(mode: string)
	if not run then
		return
	end
	local limits = E.STAKES[R.PROTOTYPE_FLOOR]
	local cap = math.min(limits.max, run.jar)
	if mode == "min" then
		stake = limits.min
	elseif mode == "max" then
		stake = cap
	elseif mode == "quarter" then
		stake = math.floor(cap * U.quarter)
	elseif mode == "half" then
		stake = math.floor(cap * U.half)
	elseif mode == "plus" then
		stake += limits.step
	elseif mode == "minus" then
		stake -= limits.step
	end
	stake = math.max(limits.min, math.min(stake, cap))
	input("activity")
end
local function primary(begin: boolean)
	if not active then
		return
	end
	if active.state == "STAKING" and begin then
		send("stake", { booth = active.id, round = active.round, amount = stake })
	elseif active.id == "STOP_REELS" and active.state == "PLAYING" and begin then
		input("stop", { time = workspace:GetServerTimeNow() })
	elseif active.id == "BLOCK_TOSS" and active.state == "PLAYING" and not active.physicsActive then
		if begin then
			chargeStart = workspace:GetServerTimeNow()
		elseif chargeStart then
			input("throw", { aim = aim, power = power, spin = spin })
			chargeStart = nil
		end
	end
end
local function label(parent: Instance, name: string, y: number, height: number, size: number?): TextLabel
	return Kit.label(
		parent,
		name,
		UDim2.new(1, -U.padding - U.padding, 0, height),
		UDim2.fromOffset(U.padding, y),
		size
	)
end
local function button(
	parent: Instance,
	name: string,
	key: string,
	x: number,
	y: number,
	width: number,
	callback: () -> ()
): TextButton
	return Kit.button(
		parent,
		name,
		text(key),
		UDim2.new(width, -U.gap, 0, U.button),
		UDim2.new(x, U.gap * U.half, 0, y),
		callback
	)
end
local function build()
	gui = Instance.new("ScreenGui")
	gui.Name = "PayTheClown"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = U.frameZ
	gui.Parent = player:WaitForChild("PlayerGui")
	cleanup:Add(gui)
	root = Instance.new("Frame")
	root.Name = "Root"
	root.BackgroundTransparency = 1
	root.Size = UDim2.fromScale(1, 1)
	root.Parent = gui
	scale = Instance.new("UIScale")
	scale.Parent = root
	local hud = Kit.frame(
		root,
		"HUD",
		UDim2.new(1, -U.padding - U.padding, 0, U.header),
		UDim2.fromOffset(U.padding, U.padding)
	)
	refs.hud = hud
	refs.jar = Kit.label(
		hud,
		"Jar",
		UDim2.new(U.meterWidth, 0, 0, U.smallRow),
		UDim2.fromOffset(U.padding, U.headerJarY),
		U.title
	)
	local bar = Kit.frame(
		hud,
		"QuotaBar",
		UDim2.new(U.meterWidth, -U.padding, 0, U.barHeight),
		UDim2.fromOffset(U.padding, U.headerBarY)
	)
	bar.BackgroundColor3 = Kit.color("CreamShade")
	refs.fill = Kit.frame(bar, "Fill", UDim2.fromScale(0, 1), UDim2.fromScale(0, 0))
	refs.fill.BackgroundColor3 = Kit.color("Teal")
	refs.crew = Kit.label(
		hud,
		"Crew",
		UDim2.new(1, -U.padding - U.padding, 0, U.crewHeight),
		UDim2.fromOffset(U.padding, U.headerCrewY),
		U.small
	)
	refs.phase = Kit.label(
		hud,
		"Phase",
		UDim2.new(U.phaseWidth, -U.padding, 0, U.smallRow),
		UDim2.new(U.headerPhaseX, 0, 0, U.headerJarY),
		U.body
	)
	refs.quota = Kit.label(
		hud,
		"Quota",
		UDim2.new(U.phaseWidth, -U.padding, 0, U.smallRow),
		UDim2.new(U.headerPhaseX, 0, 0, U.headerBarY - U.gap),
		U.small
	)
	refs.phaseAction = Kit.button(
		root,
		"PhaseAction",
		text("ACTION.READY"),
		UDim2.fromOffset(U.modalWidth, U.button),
		UDim2.new(U.half, 0, 1, -U.actionBottom),
		function()
			if not run then
				return
			end
			send(if run.phase == "DAY" then "ready" elseif run.phase == "RUN_OVER" then "again" else "skip")
		end
	)
	refs.phaseAction.AnchorPoint = Vector2.new(U.half, 1)
	refs.dayHint = Kit.label(
		root,
		"DayHint",
		UDim2.new(1, -U.margin - U.margin, 0, U.smallRow),
		UDim2.new(0, U.margin, 1, -U.actionBottom - U.button - U.smallRow),
		U.body
	)
	refs.dayHint.TextXAlignment = Enum.TextXAlignment.Center
	refs.prototype = Kit.label(
		root,
		"PrototypeLabel",
		UDim2.new(1, -U.margin - U.margin, 0, U.smallRow),
		UDim2.fromOffset(U.margin, U.header + U.padding),
		U.small
	)
	refs.prototype.Text = text("HUD.PROTOTYPE")
	refs.reelPreview = Kit.frame(
		root,
		"ReelPreview",
		UDim2.fromOffset(U.panelWidth, U.panelHeight),
		UDim2.new(1, -U.padding, 0, U.panelTop)
	)
	refs.reelPreview.AnchorPoint = Vector2.new(1, 0)
	local previewTitle = label(refs.reelPreview, "Title", U.sectionTitleY, U.titleRow, U.title)
	refs.previewTitle = previewTitle
	previewTitle.Text = text("REELS.PREVIEW")
	for index = 1, C.reelCount do
		previewLabels[index] = label(
			refs.reelPreview,
			"Strip" .. index,
			U.sectionRuleY + (index - 1) * U.reelHeight,
			U.reelHeight,
			U.body
		)
	end
	refs.previewPayouts =
		label(refs.reelPreview, "Payouts", U.sectionRuleY + C.reelCount * U.reelHeight, U.reelHeight, U.body)
	refs.previewPayouts.Text = text("REELS.PAYOUTS")
	local panel = Kit.frame(
		root,
		"BoothPanel",
		UDim2.fromOffset(U.panelWidth, U.panelHeight),
		UDim2.fromOffset(U.padding, U.panelTop)
	)
	refs.panel = panel
	refs.title = label(panel, "Title", U.sectionTitleY, U.titleRow, U.title)
	refs.rule = label(panel, "Rule", U.sectionRuleY, U.ruleRow, U.body)
	refs.status = label(panel, "Status", U.sectionStatusY, U.smallRow, U.small)
	local keypad = Instance.new("Frame")
	keypad.Name = "Keypad"
	keypad.Size = UDim2.new(1, 0, 0, U.gameBodyHeight)
	keypad.Position = UDim2.fromOffset(0, U.sectionContentY)
	keypad.BackgroundTransparency = 1
	keypad.Parent = panel
	refs.keypad = keypad
	refs.stake = label(keypad, "StakeValue", U.stakeValueY, U.titleRow, U.title)
	refs.limits = label(keypad, "Limits", U.stakeLimitsY, U.smallRow, U.small)
	for index, data in
		{
			{ "Min", "ACTION.MIN", "min" },
			{ "Quarter", "ACTION.QUARTER", "quarter" },
			{ "Half", "ACTION.HALF", "half" },
			{ "Max", "ACTION.MAX", "max" },
		}
	do
		button(keypad, data[1], data[2], (index - 1) * U.quarter, U.stakeChipsY, U.quarter, function()
			adjust(data[3])
		end)
	end
	button(keypad, "Minus", "ACTION.MINUS", 0, U.stakeAdjustY, U.half, function()
		adjust("minus")
	end)
	button(keypad, "Plus", "ACTION.PLUS", U.half, U.stakeAdjustY, U.half, function()
		adjust("plus")
	end)
	refs.go = button(keypad, "Go", "ACTION.GO", 0, U.stakeGoY, 1, function()
		primary(true)
	end)
	refs.close = button(keypad, "Close", "ACTION.CLOSE", 0, U.stakeGoY + U.row, 1, function()
		input("leave")
	end)
	local play = Instance.new("Frame")
	play.Name = "Play"
	play.Size = UDim2.new(1, 0, 0, U.gameBodyHeight)
	play.Position = UDim2.fromOffset(0, U.sectionContentY)
	play.BackgroundTransparency = 1
	play.Parent = panel
	refs.play = play
	local reelFrame = Instance.new("Frame")
	reelFrame.Name = "Reels"
	reelFrame.BackgroundTransparency = 1
	reelFrame.Size = UDim2.fromScale(1, 1)
	reelFrame.Parent = play
	refs.reels = reelFrame
	for index = 1, C.reelCount do
		local reel = Kit.frame(
			reelFrame,
			"Reel" .. index,
			UDim2.new(U.third, -U.gap, 0, U.reelHeight),
			UDim2.new((index - 1) * U.third, U.gap * U.half, 0, 0)
		)
		reel.BackgroundColor3 = Kit.color("CreamShade")
		local symbol = Kit.label(reel, "Symbol", UDim2.fromScale(1, 1), UDim2.fromScale(0, 0), U.body)
		symbol.TextXAlignment = Enum.TextXAlignment.Center
		symbol.TextColor3 = Kit.color("Ink")
		reelLabels[index] = symbol
		stripLabels[index] =
			label(reelFrame, "Strip" .. index, U.reelStripY + (index - 1) * U.ruleRow, U.ruleRow, U.stripText)
	end
	refs.stop = button(reelFrame, "Stop", "ACTION.STOP", 0, U.gameButtonY, 1, function()
		primary(true)
	end)
	local blockFrame = Instance.new("Frame")
	blockFrame.Name = "BlockControls"
	blockFrame.BackgroundTransparency = 1
	blockFrame.Size = UDim2.fromScale(1, 1)
	blockFrame.Parent = play
	refs.blocks = blockFrame
	refs.blockTitle = label(blockFrame, "Point", 0, U.titleRow, U.title)
	refs.blockResult = label(blockFrame, "Result", U.titleRow, U.smallRow, U.body)
	refs.blockParams = label(blockFrame, "Parameters", U.blockParamsY, U.row, U.body)
	button(blockFrame, "AimLeft", "ACTION.LEFT", 0, U.blockParamsY + U.row, U.half, function()
		aim = math.max(-C.angleMax, aim - C.aimStep)
	end)
	button(blockFrame, "AimRight", "ACTION.RIGHT", U.half, U.blockParamsY + U.row, U.half, function()
		aim = math.min(C.angleMax, aim + C.aimStep)
	end)
	refs.spin = button(blockFrame, "Spin", "ACTION.SPIN", 0, U.blockParamsY + U.row + U.row, 1, function()
		spin += 1
		if spin > 1 then
			spin = -1
		end
	end)
	refs.throw = button(blockFrame, "Throw", "ACTION.THROW", 0, U.gameButtonY, 1, function() end)
	cleanup:Connect(refs.throw.InputBegan, function(event: InputObject)
		if
			event.UserInputType == Enum.UserInputType.MouseButton1
			or event.UserInputType == Enum.UserInputType.Touch
		then
			primary(true)
		end
	end)
	cleanup:Connect(UIS.InputEnded, function(event: InputObject)
		if
			chargeStart
			and (
				event.UserInputType == Enum.UserInputType.MouseButton1
				or event.UserInputType == Enum.UserInputType.Touch
			)
		then
			primary(false)
		end
	end)
	local pieFrame = Kit.frame(
		root,
		"PieBoard",
		UDim2.fromOffset(U.board + U.padding + U.padding, U.panelHeight),
		UDim2.new(1, -U.padding, 0, U.panelTop)
	)
	pieFrame.AnchorPoint = Vector2.new(1, 0)
	refs.pie = pieFrame
	refs.pieTitle = label(pieFrame, "PieTitle", U.sectionTitleY, U.titleRow, U.body)
	for index = 1, B.PIE_SWEEPER.width * B.PIE_SWEEPER.height do
		local x = (index - 1) % B.PIE_SWEEPER.width
		local y = math.floor((index - 1) / B.PIE_SWEEPER.width)
		local tile = Kit.button(
			pieFrame,
			"Tile" .. index,
			text("PIE.UNKNOWN"),
			UDim2.fromOffset(U.tile, U.tile),
			UDim2.fromOffset(
				U.padding + x * (U.tile + U.gap * U.half),
				U.sectionRuleY + y * (U.tile + U.gap * U.half)
			),
			function()
				if not active then
					return
				end
				if active.state == "STAKING" then
					input("setup", { count = active.pieCount, opening = index })
				elseif flagMode then
					flags[index] = not flags[index]
				elseif active.state == "PLAYING" then
					input("reveal", { tile = index })
				end
			end
		)
		cleanup:Connect(tile.MouseButton2Click, function()
			flags[index] = not flags[index]
		end)
		tiles[index] = tile
	end
	refs.piesMinus = button(
		pieFrame,
		"FewerPies",
		"ACTION.MINUS",
		0,
		U.pieControlsY + U.ruleRow,
		U.third,
		function()
			if active then
				input("setup", {
					count = math.max(B.PIE_SWEEPER.allowed.F3[1], active.pieCount - 1),
					opening = active.opening,
				})
			end
		end
	)
	refs.piesPlus = button(
		pieFrame,
		"MorePies",
		"ACTION.PLUS",
		U.third,
		U.pieControlsY + U.ruleRow,
		U.third,
		function()
			if active then
				input("setup", {
					count = math.min(B.PIE_SWEEPER.allowed.F3[2], active.pieCount + 1),
					opening = active.opening,
				})
			end
		end
	)
	refs.flags = button(
		pieFrame,
		"Flags",
		"ACTION.FLAGS",
		U.third + U.third,
		U.pieControlsY + U.ruleRow,
		U.third,
		function()
			flagMode = not flagMode
		end
	)
	refs.pieHint = label(pieFrame, "PieHint", U.pieControlsY + U.ruleRow + U.row, U.smallRow, U.small)
	refs.piePlay = Instance.new("Frame")
	refs.piePlay.Name = "PieChoices"
	refs.piePlay.BackgroundTransparency = 1
	refs.piePlay.Size = UDim2.fromScale(1, 1)
	refs.piePlay.Parent = play
	refs.pieValue = label(refs.piePlay, "Value", 0, U.row, U.title)
	refs.pieDecision = label(refs.piePlay, "Decision", U.row, U.row, U.body)
	refs.push = button(refs.piePlay, "Push", "ACTION.PUSH", 0, U.gameButtonY, U.half, function()
		input("push")
	end)
	refs.bank = button(refs.piePlay, "Bank", "ACTION.BANK", U.half, U.gameButtonY, U.half, function()
		input("bank")
	end)
	local toast = Kit.frame(
		root,
		"Toast",
		UDim2.fromOffset(U.toastWidth, U.toastHeight),
		UDim2.new(U.half, 0, 0, U.toastTop)
	)
	toast.AnchorPoint = Vector2.new(U.half, 0)
	refs.toast = toast
	refs.toastText = label(toast, "Text", U.padding, U.ruleRow, U.body)
	refs.approve = button(toast, "Approve", "ACTION.APPROVE", 0, U.row, U.half, function()
		if approval then
			send("vote", { booth = approval.booth, approval = approval.id, approve = true })
		end
	end)
	refs.veto = button(toast, "Veto", "ACTION.VETO", U.half, U.row, U.half, function()
		if approval then
			send("vote", { booth = approval.booth, approval = approval.id, approve = false })
		end
	end)
	local result = Kit.frame(
		root,
		"Result",
		UDim2.fromOffset(U.modalWidth, U.modalHeight),
		UDim2.fromScale(U.half, U.half)
	)
	result.AnchorPoint = Vector2.new(U.half, U.half)
	refs.result = result
	refs.resultTitle = label(result, "Title", U.padding, U.ruleRow, U.title)
	refs.resultText = label(result, "Summary", U.row, U.modalHeight - U.row - U.padding, U.body)
end
local function camera(id: string)
	if id == cameraBooth then
		return
	end
	cameraBooth = id
	if cameraTween then
		cameraTween:Cancel()
		cameraTween = nil
	end
	local cam = workspace.CurrentCamera
	if not cam then
		return
	end
	if id == "" then
		cam.CameraType = Enum.CameraType.Custom
		return
	end
	for _, spec in C.booths do
		if spec.id == id then
			local center = Vector3.new(unpack(spec.position))
			cam.CameraType = Enum.CameraType.Scriptable
			local tween = TweenService:Create(cam, TweenInfo.new(U.cameraSeconds), {
				CFrame = CFrame.lookAt(
					center + Vector3.new(unpack(U.cameraOffset)),
					center + Vector3.new(unpack(U.cameraFocus))
				),
			})
			cameraTween = tween
			tween:Play()
			break
		end
	end
end
local function render()
	if not run then
		return
	end
	local time = workspace:GetServerTimeNow()
	local cam = workspace.CurrentCamera
	local viewport = if cam then cam.ViewportSize else Vector2.new(U.baseWidth, U.baseHeight)
	local factor = math.clamp(math.min(viewport.X / U.baseWidth, viewport.Y / U.baseHeight), U.scaleMin, 1)
	scale.Scale = factor
	root.Size = UDim2.fromScale(1 / factor, 1 / factor)
	Kit.text(refs.jar, text("HUD.JAR", { amount = run.jar }))
	refs.fill.Size = UDim2.fromScale(math.clamp(run.jar / math.max(1, run.quota), 0, 1), 1)
	local remaining = seconds(run.deadline)
	local clock = string.format("%d:%02d", math.floor(remaining / R.MINUTE), remaining % R.MINUTE)
	local phase = text("STATE." .. run.phase)
	if run.phase == "NIGHT" then
		if run.graceEnd > 0 then
			phase = text("HUD.GRACE", { seconds = seconds(run.graceEnd) })
		elseif run.finalCall then
			phase = text("HUD.FINAL")
		end
	end
	Kit.text(refs.phase, text("HUD.PHASE", { phase = phase, time = if run.deadline > 0 then clock else "" }))
	refs.phase.TextColor3 = Kit.color(if run.finalCall and run.phase == "NIGHT" then "Gold" else "Cream")
	Kit.text(refs.quota, text("HUD.NIGHT_INFO", { night = run.night, quota = run.quota }))
	local names = {}
	local ready = 0
	local meReady = false
	for _, member in run.crew do
		table.insert(
			names,
			text(
				"HUD.MEMBER",
				{ name = member.name, ready = if member.ready then text("HUD.READY_MARK") else "" }
			)
		)
		if member.ready then
			ready += 1
		end
		if member.id == player.UserId then
			meReady = member.ready
		end
	end
	Kit.text(refs.crew, text("HUD.CREW", { names = table.concat(names, text("COMMON.SEPARATOR")) }))
	refs.phaseAction.Visible = run.phase == "DAY" or run.phase == "RESULT_SUCCESS" or run.phase == "RUN_OVER"
	Kit.text(
		refs.phaseAction,
		text(
			if run.phase == "DAY"
				then (if meReady then "ACTION.UNREADY" else "ACTION.READY")
				elseif run.phase == "RUN_OVER" then "ACTION.AGAIN"
				else "ACTION.SKIP"
		)
	)
	Kit.enabled(refs.phaseAction, run.phase ~= "RUN_OVER" or run.host == player.UserId)
	refs.dayHint.Visible = refs.phaseAction.Visible
	Kit.text(
		refs.dayHint,
		if run.phase == "DAY"
			then text("HUD.READY_COUNT", {
				ready = ready,
				total = #run.crew,
				countdown = if run.departureEnd
					then text("HUD.LEAVES", { seconds = seconds(run.departureEnd) })
					else "",
			})
			elseif run.phase == "RUN_OVER" then text("RESULT.RESTART_HINT")
			else text("HUD.BILL", { bill = run.bill, tokens = run.tokens })
	)
	active = nil
	approval = nil
	for _, booth in booths do
		if booth.controller == player.UserId and booth.state ~= "IDLE" then
			active = booth
		end
		local p = booth.pending
		local userKey = tostring(player.UserId)
		if
			p
			and not approval
			and (p.eligible[player.UserId] or p.eligible[userKey])
			and p.ends > time
			and p.votes[player.UserId] == nil
			and p.votes[userKey] == nil
		then
			approval = { id = p.id, booth = booth.id }
			toastText = text("APPROVAL.TOAST", {
				name = booth.name,
				stake = p.amount,
				percent = math.floor(p.amount / math.max(1, p.jar) * R.PERCENT),
				booth = text("BOOTH." .. booth.id),
			})
		end
	end
	refs.panel.Visible = active ~= nil
	refs.reelPreview.Visible = active ~= nil and active.id ~= "PIE_SWEEPER" and active.state == "STAKING"
	refs.pie.Visible = active ~= nil and active.id == "PIE_SWEEPER"
	refs.result.Visible = run.phase == "RESULT_SUCCESS"
		or run.phase == "RESULT_FAIL"
		or run.phase == "RUN_OVER"
	if refs.result.Visible then
		Kit.text(refs.resultTitle, text("STATE." .. run.phase))
		Kit.text(
			refs.resultText,
			text("RESULT.SUMMARY", {
				jar = run.jar,
				won = run.won,
				lost = run.lost,
				name = if run.bestName ~= "" then run.bestName else text("RESULT.BEST_NONE"),
				best = run.best,
			})
		)
	end
	refs.toast.Visible = approval ~= nil or time < toastEnd
	Kit.text(refs.toastText, toastText)
	refs.approve.Visible = approval ~= nil and run.approval
	refs.veto.Visible = refs.approve.Visible
	if not active then
		camera("")
		return
	end
	if active.round ~= lastRound then
		lastRound = active.round
		stake = E.STAKES[R.PROTOTYPE_FLOOR].min
		flags = {}
		flagMode = false
		aim = 0
		spin = 0
		chargeStart = nil
	end
	local staging = active.state == "STAKING"
	refs.keypad.Visible = staging
	refs.play.Visible = not staging
	Kit.text(refs.title, text("BOOTH." .. active.id))
	Kit.text(refs.rule, text("RULE." .. active.id))
	Kit.text(
		refs.status,
		text("BOOTH_STATE." .. active.state, { multiplier = active.multiplier, payout = active.payout })
	)
	camera(if not staging and active.state ~= "COOLDOWN" then active.id else "")
	if staging then
		Kit.text(refs.stake, text("STAKE.VALUE", { stake = stake, jar = run.jar }))
		Kit.text(
			refs.limits,
			text("STAKE.LIMITS", {
				min = E.STAKES[R.PROTOTYPE_FLOOR].min,
				max = math.min(run.jar, E.STAKES[R.PROTOTYPE_FLOOR].max),
				big = if Stakes.big(stake, run.jar, R.PROTOTYPE_FLOOR) then text("STAKE.BIG") else "",
			})
		)
		Kit.enabled(
			refs.go,
			active.pending == nil
				and (active.id ~= "PIE_SWEEPER" or time >= active.previewEnd)
				and stake <= run.jar
				and run.phase == "NIGHT"
				and time < run.deadline
		)
		Kit.text(
			refs.go,
			if active.pending
				then text("STAKE.PENDING", { seconds = seconds(active.pending.ends) })
				else text("ACTION.GO")
		)
	end
	refs.reels.Visible = active.id == "STOP_REELS"
	refs.blocks.Visible = active.id == "BLOCK_TOSS"
	refs.piePlay.Visible = active.id == "PIE_SWEEPER"
	if active.id == "STOP_REELS" then
		Kit.text(refs.previewTitle, text("REELS.PREVIEW"))
		Kit.text(refs.previewPayouts, text("REELS.PAYOUTS"))
		for index = 1, C.reelCount do
			local symbol = active.symbols[index]
				or Reels.symbol(
					active.strips[index],
					active.offsets[index],
					R.PROTOTYPE_FLOOR,
					index,
					math.max(0, time - active.startTime)
				)
			Kit.text(reelLabels[index], text("REELS.SYMBOL." .. symbol))
			local strip = {}
			for _, name in active.strips[index] do
				table.insert(strip, text("REELS.SYMBOL." .. name))
			end
			Kit.text(
				stripLabels[index],
				text("REELS.STRIP", { reel = index, symbols = table.concat(strip, text("COMMON.SEPARATOR")) })
			)
			Kit.text(
				previewLabels[index],
				text("REELS.PREVIEW_STRIP", {
					reel = index,
					slot = active.offsets[index] + 1,
					offset = text("REELS.SYMBOL." .. active.strips[index][active.offsets[index] + 1]),
					symbols = table.concat(strip, text("COMMON.SEPARATOR")),
				})
			)
		end
		Kit.text(refs.stop, text("ACTION.STOP", { reel = math.min(C.reelCount, #active.symbols + 1) }))
		Kit.enabled(refs.stop, active.state == "PLAYING")
	elseif active.id == "BLOCK_TOSS" then
		Kit.text(refs.previewTitle, text("BOOTH.BLOCK_TOSS"))
		for index, key in { "BLOCK.OPENING_RULES", "BLOCK.POINT_RULES", "BLOCK.CONTROLS" } do
			Kit.text(previewLabels[index], text(key))
		end
		Kit.text(refs.previewPayouts, text("BLOCK.PAYOUTS"))
		if chargeStart then
			power = (time - chargeStart) % C.chargePeriod / C.chargePeriod
		end
		Kit.text(
			refs.blockTitle,
			if active.point
				then text(
					"BLOCK.POINT",
					{ point = active.point, toss = active.pointTosses, max = B.BLOCK_TOSS.maxPointTosses }
				)
				else text("BLOCK.OPENING")
		)
		Kit.text(
			refs.blockParams,
			text(
				"BLOCK.PARAMS",
				{ power = math.floor(power * R.PERCENT), aim = math.round(math.deg(aim)), spin = spin }
			)
		)
		Kit.text(refs.spin, text("ACTION.SPIN", { spin = spin }))
		Kit.text(
			refs.blockResult,
			if active.locks and time < active.locks
				then text("BLOCK.LOCKING", { seconds = seconds(active.locks) })
				elseif active.physicsActive then text("BLOCK.SETTLING")
				elseif #active.faces == 2 then text(
					"BLOCK.RESULT",
					{ a = active.faces[1], b = active.faces[2], total = active.faces[1] + active.faces[2] }
				)
				else ""
		)
		Kit.enabled(refs.throw, active.state == "PLAYING" and not active.physicsActive)
	elseif active.id == "PIE_SWEEPER" then
		Kit.text(refs.pieTitle, text("PIE.COUNT", { count = active.pieCount, opening = active.opening }))
		Kit.text(
			refs.flags,
			text("ACTION.FLAGS", { mode = text(if flagMode then "COMMON.ON" else "COMMON.OFF") })
		)
		Kit.enabled(refs.piesMinus, staging and active.pending == nil)
		Kit.enabled(refs.piesPlus, staging and active.pending == nil)
		Kit.text(
			refs.pieHint,
			if staging
				then (if time < active.previewEnd
					then text("PIE.PREVIEW", { seconds = seconds(active.previewEnd) })
					else text("PIE.PREVIEW_READY"))
				else text("PIE.PUSH_HINT")
		)
		for index, tile in tiles do
			local revealed = active.revealed[index] or active.revealed[tostring(index)]
			local isPie = active.preview and (active.preview[index] or active.preview[tostring(index)])
			Kit.text(
				tile,
				if staging
					then (if isPie
						then text("PIE.PIE")
						elseif index == active.opening then text("PIE.OPENING")
						else text("PIE.UNKNOWN"))
					elseif revealed ~= nil then tostring(revealed)
					elseif flags[index] then text("PIE.FLAG")
					else text("PIE.UNKNOWN")
			)
			tile.BackgroundColor3 = Kit.color(
				if staging and isPie then "CarnivalRed" elseif revealed ~= nil then "Teal" else "CreamShade"
			)
		end
		Kit.text(
			refs.pieValue,
			text("PIE.VALUE", {
				safe = active.safeCount,
				multiplier = active.multiplier,
				payout = math.floor(active.stake * active.multiplier),
			})
		)
		Kit.text(refs.pieDecision, text("PIE.DECISION", { seconds = seconds(active.deadline) }))
		Kit.enabled(refs.push, active.state == "PUSH_DECISION")
		Kit.enabled(refs.bank, active.state == "PUSH_DECISION" or active.state == "PLAYING")
	end
end
function GameController.init()
	build()
end
function GameController.start()
	cleanup:Connect(Net.get("RunState").OnClientEvent, function(state)
		run = state
	end)
	cleanup:Connect(Net.get("BoothState").OnClientEvent, function(state)
		booths = state
	end)
	cleanup:Connect(Net.get("Toast").OnClientEvent, function(message)
		toastText = text(message.key, message.values)
		toastEnd = workspace:GetServerTimeNow() + Theme.toastSeconds
	end)
	cleanup:Connect(RunService.RenderStepped, render)
	cleanup:Connect(UIS.InputBegan, function(event: InputObject, processed: boolean)
		if not processed and event.UserInputType == Enum.UserInputType.MouseButton2 then
			aimDrag = true
		end
	end)
	cleanup:Connect(UIS.InputEnded, function(event: InputObject)
		if event.UserInputType == Enum.UserInputType.MouseButton2 then
			aimDrag = false
		end
	end)
	cleanup:Connect(UIS.InputChanged, function(event: InputObject)
		if not active or active.id ~= "BLOCK_TOSS" or active.state ~= "PLAYING" then
			return
		end
		if aimDrag and event.UserInputType == Enum.UserInputType.MouseMovement then
			aim = math.clamp(aim + event.Delta.X * C.aimDragSensitivity, -C.angleMax, C.angleMax)
		elseif event.KeyCode == Enum.KeyCode.Thumbstick1 then
			aim = if math.abs(event.Position.X) > U.aimDeadzone then event.Position.X * C.angleMax else 0
		end
	end)
	CAS:BindAction("PTCPrimary", function(_, state, event)
		if not active then
			return Enum.ContextActionResult.Pass
		end
		if event.KeyCode == Enum.KeyCode.ButtonA then
			return Enum.ContextActionResult.Pass
		end
		if state == Enum.UserInputState.Begin then
			primary(true)
		elseif state == Enum.UserInputState.End then
			primary(false)
		end
		return Enum.ContextActionResult.Sink
	end, false, Enum.KeyCode.Space, Enum.KeyCode.ButtonA, Enum.KeyCode.ButtonR2)
	CAS:BindAction(
		"PTCPushBank",
		function(_, state, key)
			if not active or state ~= Enum.UserInputState.Begin then
				return Enum.ContextActionResult.Pass
			end
			if key.KeyCode == Enum.KeyCode.One or key.KeyCode == Enum.KeyCode.ButtonY then
				input("push")
			elseif
				key.KeyCode == Enum.KeyCode.Backspace
				or (key.KeyCode == Enum.KeyCode.ButtonB and active.state == "STAKING")
			then
				input("leave")
			else
				input("bank")
			end
			return Enum.ContextActionResult.Sink
		end,
		false,
		Enum.KeyCode.One,
		Enum.KeyCode.Two,
		Enum.KeyCode.ButtonY,
		Enum.KeyCode.ButtonB,
		Enum.KeyCode.Backspace
	)
	cleanup:Add(function()
		CAS:UnbindAction("PTCPrimary")
		CAS:UnbindAction("PTCPushBank")
		camera("")
	end)
	send("hello")
end
function GameController.destroy()
	cleanup:Destroy()
end
return GameController
