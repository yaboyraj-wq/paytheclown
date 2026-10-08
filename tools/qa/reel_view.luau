-- Temporary DEV LocalScript. Claim Reels and complete a round using ordinary inputs.
local Env = require(game.ReplicatedStorage.Shared.Config.Environment).DEV
assert(game.PlaceId == Env.PlaceId and game.GameId == Env.GameId, "DEV only")
local L = require(game.ReplicatedStorage.Shared.Util.Locale)
local Reels = require(game.ReplicatedStorage.Shared.Logic.BoothLogic.Reels)
local RunService = game:GetService("RunService")
game.ReplicatedStorage.Net.BoothState.OnClientEvent:Connect(function(booths)
	for _, b in booths do
		if b.id ~= "STOP_REELS" or (b.state ~= "STAKING" and b.state ~= "RESOLVING") then
			continue
		end
		local attribute = if b.state == "STAKING" then "PTCReelPreviewQA" else "PTCReelStoppedQA"
		if workspace:GetAttribute(attribute) == "PASS" then
			continue
		end
		-- Check during the actual result frame, before its short presentation ends.
		task.spawn(function()
			RunService.RenderStepped:Wait()
			RunService.Heartbeat:Wait() -- RenderStepped waiters can resume before the presentation callback.
			for i = 1, 3 do
				local expected = Reels.window(b.strips[i], b.positions[i] or b.offsets[i])
				for row = 1, 3 do
					local label =
						workspace.Prototype.Booths.STOP_REELS.Reels["Reel" .. i].Window["Row" .. row]
					assert(
						label.Text == L.text("REELS.SYMBOL." .. expected[row]),
						"world row differs from server setup/stop"
					)
				end
				if b.state == "RESOLVING" then
					assert(expected[2] == b.symbols[i], "center equals awarded symbol")
				end
			end
			local card = game.Players.LocalPlayer.PlayerGui.PayTheClown.Root.ReelPreview
			assert(
				card.Visible and card.Payouts.Visible and not card.Title.Visible and not card.Strip1.Visible,
				"payout-only panel"
			)
			workspace:SetAttribute(attribute, "PASS")
			print("[PTC QA] " .. attribute .. " PASS")
		end)
	end
end)
