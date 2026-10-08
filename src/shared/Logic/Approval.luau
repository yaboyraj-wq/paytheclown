--!strict
local Approval = {}
function Approval.blocked(enabled: boolean, votes: { boolean }): boolean
	local yes, no = 0, 0
	for _, approved in votes do
		if approved then
			yes += 1
		else
			no += 1
		end
	end
	return enabled and no > yes
end
return Approval
