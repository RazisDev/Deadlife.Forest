local ReplicatedStorage = game:GetService("ReplicatedStorage")
local killerRegisterSkill = require(ReplicatedStorage.Shared.Classes.KillerSkills.KillerSkillRegistry)

local KillerSkillService = {}
KillerSkillService.Active = {} :: { [Player]: { [string]: any } }

-- Assign 1 ability
function KillerSkillService:AssignSkill(player: Player, slot: number, abilityName: string, tier: number)
	local class = killerRegisterSkill

	self.Active[player] = self.Active[player] or {}
	self.Active[player][slot] = class.Get(self, abilityName)
end

-- Activate slot 1/2/3
function KillerSkillService:Activate(player: Player, slot: number)
	local skillSet = self.Active[player]
	if not skillSet then
		return
	end

	local skill = skillSet[slot]
	if skill then
		skill:Activate()
	end
end

return KillerSkillService
