local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoleEnum = require(ReplicatedStorage.Shared.Modules.Enums.RoleEnum)

local RoleModule = {}

function RoleModule.Assign(players)
	local roles = {}

	-- SAFETY #1: No players
	if not players or #players == 0 then
		warn("[RoleModule] No players available for role assignment.")
		return roles
	end

	-- SAFETY #2: Single player test
	if #players == 1 then
		roles[players[1]] = RoleEnum.Killer
		return roles
	end

	-- SAFE RANDOM
	local killerIndex = math.random(1, #players)
	local killer = players[killerIndex]

	roles[killer] = RoleEnum.Killer

	for _, plr in ipairs(players) do
		if plr ~= killer then
			roles[plr] = RoleEnum.Survivor
		end
	end

	return roles
end

return RoleModule
