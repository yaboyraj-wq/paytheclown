--!strict
-- Only this private sandbox is authorized. Zero means unconfigured, never a fallback.
export type EnvironmentConfig = {
	GameId: number,
	PlaceId: number,
	HubPlaceId: number,
	TowerPlaceId: number,
	OwnerUserId: number,
	GroupId: number,
	ProductIds: { [string]: number },
	BadgeIds: { [string]: number },
	AssetIds: { [string]: number },
}
local Environment: { [string]: EnvironmentConfig } = {
	DEV = {
		GameId = 10769806964,
		PlaceId = 100356893013946,
		HubPlaceId = 0, -- Create the separate DEV hub at M4.
		TowerPlaceId = 0, -- Create the separate DEV tower at M4.
		OwnerUserId = 0, -- Owner must supply their user ID before published DEV admin access.
		GroupId = 0, -- Owner-created development group.
		ProductIds = {}, -- Filled by Products keys after owner creates DEV products.
		BadgeIds = {}, -- Filled by Badges keys after owner creates DEV badges.
		AssetIds = {}, -- Uploaded original art/audio IDs; no uploads in M0/M1.
	},
	LIVE = {
		GameId = 0, -- Owner-created LIVE universe, never authorized by DEV.
		PlaceId = 0,
		HubPlaceId = 0,
		TowerPlaceId = 0,
		OwnerUserId = 0,
		GroupId = 0,
		ProductIds = {},
		BadgeIds = {},
		AssetIds = {},
	},
}
local Products = require("./Products")
local Badges = require("./Badges")
for _, environment in Environment do
	for key in Products.GamePasses do
		environment.ProductIds[tostring(key)] = 0
	end
	for key in Products.DeveloperProducts do
		environment.ProductIds[tostring(key)] = 0
	end
	environment.ProductIds.SUB_CLUB = 0
	for key in Badges do
		environment.BadgeIds[tostring(key)] = 0
	end
	environment.AssetIds.UI_CLICK = 0 -- Original or licensed UI click sound, M5.
	environment.AssetIds.CANNON = 0 -- Original or licensed cannon sound, M5.
end
return Environment
