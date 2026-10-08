--!strict
local Cleanup = {}
function Cleanup.new()
	local callbacks: { () -> () } = {}
	return {
		add = function(callback: () -> ())
			table.insert(callbacks, callback)
		end,
		destroy = function()
			for i = #callbacks, 1, -1 do
				callbacks[i]()
			end
			table.clear(callbacks)
		end,
	}
end
return Cleanup
