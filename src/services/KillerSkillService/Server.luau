local ReplicatedStorage = game:GetService("ReplicatedStorage")
local killerRegisterSkill = require(ReplicatedStorage.Shared.Classes.KillerSkills.KillerSkillRegistry)
local SkillFolder = ReplicatedStorage.Shared.Classes.KillerSkills

for _, module in ipairs(SkillFolder:GetChildren()) do
	if module:IsA("ModuleScript") then
		require(module)
	end
end

local KillerSkillService = {}
KillerSkillService.Active = {} :: { [Player]: { [string]: any } }

-- Assign 1 ability
function KillerSkillService:AssignSkill(player: Player, slot: number, abilityName: string, tier: number)
	local skillClass = killerRegisterSkill:Get(abilityName)

	if not skillClass then
		warn(`[KillerSkillService] Unknown skill: {abilityName}`)
		return
	end

	self.Active[player] = self.Active[player] or {}
	self.Active[player][slot] = skillClass -- store the class or instance
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
