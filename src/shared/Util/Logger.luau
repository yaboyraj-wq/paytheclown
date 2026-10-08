--!strict
local Logger = {}
function Logger.info(scope: string, message: string)
	print("[PTC][" .. scope .. "] " .. message)
end
function Logger.reject(scope: string, reason: string)
	-- Expected invalid inputs are audit messages, not script warnings.
	print("[PTC][REJECT][" .. scope .. "] " .. reason)
end
function Logger.error(scope: string, message: string)
	warn("[PTC][ERROR][" .. scope .. "] " .. message)
end
return Logger
