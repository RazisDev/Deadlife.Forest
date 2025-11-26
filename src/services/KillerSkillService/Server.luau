local AnalyticsService = game:GetService("AnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local killerRegisterSkill = require(ReplicatedStorage.Shared.Classes.KillerSkills.KillerSkillRegistry)
local SkillFolder = ReplicatedStorage.Shared.Classes.KillerSkills
local SkillEvent = ReplicatedStorage.Events.Remotes.KillerSkillEvent

local KillerSkillService = {}
KillerSkillService.Active = {} :: { [Player]: { [number]: any } }

---------------------------------------------------------------------
-- Assign the skill (instantiates skill object)
---------------------------------------------------------------------
function KillerSkillService:AssignSkill(player: Player, slot: number, abilityName: string, tier: number)
	local skillClass = killerRegisterSkill:Get(abilityName)

	if not skillClass then
		warn(`[KillerSkillService] Unknown skill: {abilityName}`)
		return
	end

	-- Create instance ✔
	local skillInstance = skillClass.new(player, tier)
	if not skillInstance then
		warn(`[KillerSkillService] Failed to create instance for {abilityName}`)
		return
	end

	self.Active[player] = self.Active[player] or {}
	self.Active[player][slot] = skillInstance

	print(`[KillerSkillService] Assigned {abilityName} slot {slot} (Tier {tier})`)
end

---------------------------------------------------------------------
-- Activate skill (calls instance:Activate())
---------------------------------------------------------------------
function KillerSkillService:Activate(player: Player, slot: number)
	local skillSet = self.Active[player]
	if not skillSet then
		return
	end

	local skill = skillSet[slot]
	if skill then
		print(`[KillerSkillService] Activating slot {slot} for {player.Name}`)
		skill:Activate()
	end
end

---------------------------------------------------------------------
-- Load all skills & setup event bridge
---------------------------------------------------------------------
function KillerSkillService:Init()
	-- Auto require all skills to register them

	for _, module in ipairs(SkillFolder:GetChildren()) do
		if module:IsA("ModuleScript") then
			require(module)
		end
	end

	SkillEvent.OnServerEvent:Connect(function(player, slot)
		self:Activate(player, slot)
	end)

	print("[KillerSkillService] Initialized")
end

return KillerSkillService
