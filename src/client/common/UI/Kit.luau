--!strict
local C = require(game.ReplicatedStorage.Shared.Config.Prototype).ui
local Theme = require(game.ReplicatedStorage.Shared.Config.UITheme)
local Kit = {}
function Kit.color(name: string): Color3
	local colors: { [string]: string } = Theme.colors
	return Color3.fromHex(colors[name] or Theme.colors.Ink)
end
function Kit.round(object: GuiObject)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, C.corner)
	corner.Parent = object
end
function Kit.frame(parent: Instance, name: string, size: UDim2, position: UDim2): Frame
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Size = size
	frame.Position = position
	frame.BorderSizePixel = 0
	frame.BackgroundColor3 = Kit.color("Ink")
	frame.BackgroundTransparency = C.alpha
	frame.Parent = parent
	Kit.round(frame)
	return frame
end
function Kit.label(parent: Instance, name: string, size: UDim2, position: UDim2, textSize: number?): TextLabel
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Size = size
	label.Position = position
	label.BackgroundTransparency = 1
	label.Text = ""
	label.Font = Enum.Font.GothamBold
	label.TextSize = textSize or C.body
	label.TextColor3 = Kit.color("Cream")
	label.TextWrapped = true
	label.RichText = false
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent
	return label
end
function Kit.button(
	parent: Instance,
	name: string,
	text: string,
	size: UDim2,
	position: UDim2,
	callback: () -> ()
): TextButton
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = size
	button.Position = position
	button.Text = text
	button.TextSize = C.body
	button.TextWrapped = true
	button.RichText = false
	button.Font = Enum.Font.GothamBold
	button.BackgroundColor3 = Kit.color("Gold")
	button.TextColor3 = Kit.color("Ink")
	button.BorderSizePixel = 0
	button.AutoButtonColor = true
	button.Parent = parent
	Kit.round(button)
	button.Activated:Connect(callback)
	return button
end
function Kit.text(label: TextLabel | TextButton, value: string)
	if label.Text ~= value then
		if label:IsA("TextLabel") then
			label.Text = value
		else
			(label :: TextButton).Text = value
		end
	end
end
function Kit.enabled(button: TextButton, enabled: boolean)
	button.Interactable = enabled
	button.AutoButtonColor = enabled
	button.BackgroundColor3 = Kit.color(if enabled then "Gold" else "CreamShade")
end
return Kit
