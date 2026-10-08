--!strict
-- Keep the prototype's full numeric register reviewable alongside the economy spec.
local fs = require("@lune/fs")
local serde = require("@lune/serde")
local config = require("../src/shared/Config/Prototype")
local path = "docs/04_Economy_and_Balancing.md"
local source = fs.readFile(path)
local marker = "## 14. M1 gray-box measurements and presentation defaults"
local at = string.find(source, marker, 1, true)
if at then
	source = string.sub(source, 1, at - 1)
end
fs.writeFile(
	path,
	source
		.. "\n"
		.. marker
		.. "\n\nThese prototype-only starting values are mirrored exactly in `Config/Prototype.luau`. Distances are studs, angles radians, durations seconds, and UI measurements design pixels. They do not replace booth payout tables.\n\n```json\n"
		.. serde.encode("json", config, true)
		.. "\n```\n"
)
