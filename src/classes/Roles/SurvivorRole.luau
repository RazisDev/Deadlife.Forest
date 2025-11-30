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
	local killerTeam = game:GetService("Teams"):FindFirstChild("Servivor")
	if killerTeam then
		self.player.Team = killerTeam
	else
		warn("[KILLER ROLE] Killer team not found in Teams service")
	end
	self:ApplyLoadout()

	print(`[Servivor Role] Applied Servivor {self.killerId} to {self.player.Name}`)
end

function ServivorRole:ApplyLoadout()
	local player: Player = self.player
	local char = player.Character
	if not char then
		return
	end

	local ServivorSpawn = workspace:FindFirstChild("SpawnLocationServivor")
	local spawnCFrame = ServivorSpawn and ServivorSpawn.CFrame or CFrame.new(0, 10, 0)
	local offset = CFrame.new(0, 6, 0)
	char:SetPrimaryPartCFrame(spawnCFrame * offset)
	task.wait()
end

return ServivorRole
