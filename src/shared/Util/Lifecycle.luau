--!strict
export type Unit = { init: () -> (), start: () -> () }
local Lifecycle = {}
function Lifecycle.run(units: { Unit })
	for _, unit in units do
		unit.init()
	end
	for _, unit in units do
		unit.start()
	end
end
return Lifecycle
