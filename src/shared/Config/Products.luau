--!strict
-- Starting values from docs/04 and the corresponding system specification.
return {
	GamePasses = {
		GP_STARTER = {
			proposedRobux = 99,
			stars = 1000,
		},
		GP_VIP = {
			proposedRobux = 299,
			earnedBonus = 0.1,
			saveSlots = 6,
		},
		GP_2X_STARS = {
			proposedRobux = 399,
			earnedBonus = 1,
		},
		GP_EMOTE_PACK = {
			proposedRobux = 149,
			emotes = 5,
		},
		GP_PASS_S1 = {
			proposedRobux = 399,
			season = 1,
		},
	},
	DeveloperProducts = {
		DP_STARS_S = {
			proposedRobux = 99,
			stars = 500,
		},
		DP_STARS_M = {
			proposedRobux = 199,
			stars = 1100,
		},
		DP_STARS_L = {
			proposedRobux = 449,
			stars = 2600,
		},
		DP_STARS_XL = {
			proposedRobux = 899,
			stars = 5500,
		},
		DP_STARS_XXL = {
			proposedRobux = 1799,
			stars = 12000,
		},
		DP_TREAT_CANDY = {
			proposedRobux = 25,
			otherStars = 10,
		},
		DP_TREAT_FIREWORKS = {
			proposedRobux = 49,
			otherStars = 25,
		},
		DP_TREAT_CONFETTI = {
			proposedRobux = 75,
			otherStars = 40,
		},
		DP_KEEP_LIGHTS_ON = {
			proposedRobux = 49,
			perRun = 1,
			offerSeconds = 10,
		},
	},
	Subscription = {
		idKey = "SUB_CLUB",
		proposedUSD = 4.99,
		dailyStars = 100,
		monthlySaver = 1,
		extraReroll = 1,
	},
	privateServerProposedRobux = 100,
	cosmeticPriceRange = {
		49,
		399,
	},
	treatsPerDay = 3,
	defaultSaveSlots = 3,
	priceCacheSeconds = 300,
}
