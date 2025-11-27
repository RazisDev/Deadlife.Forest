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

function ServivorRole:Apply()
	self.player:SetAttribute("IsKiller", false)

	print(`[Servivor Role] Applied Servivor {self.killerId} to {self.player.Name}`)
end

return ServivorRole
