local ServivorRole = {}

ServivorRole.__index = ServivorRole

function ServivorRole.new(player: Player, passive)
	local self = {
		player = player,
		passive = passive,
	}
	setmetatable(self, ServivorRole)
	return self
end

return ServivorRole
