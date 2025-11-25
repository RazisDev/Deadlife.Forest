local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local KillerSkillService = require(ServerScriptService.Services.KillerSkillService.KillerSkillServiceServer)
local ServerDataTemplate = require(ServerScriptService.Services.PlayerDataService.ServerDataTemplate)

type KillerAbilityData = ServerDataTemplate.KillerAbilityData
type playerLevelType = typeof(ServerDataTemplate.Level)

local KillerRole = {}
KillerRole.__index = KillerRole

function KillerRole.new(player: Player, killerId: string, abilities: { KillerAbilityData }, Level: playerLevelType)
	local self = {
		player = player,
		killerId = killerId,
		abilities = abilities,
		roleName = "killer",
		Level = Level,
	}
	setmetatable(self, KillerRole)
	return self
end

function KillerRole:Apply()
	self.player:SetAttribute("IsKiller", true)

	self:ApplyLoadout()
	self:ApplyAbilities()
	print(`[KILLER ROLE] Applied killer {self.killerId} to {self.player.Name}`)
end

function KillerRole:ApplyLoadout()
	local player: Player = self.player
	local char = player.Character
	if not char then
		return
	end

	local killerModels = ServerStorage:FindFirstChild("KillerModel")
	if not killerModels then
		warn("Missing folder: ServerStorage.KillerModel")
		return
	end

	local killerModel = killerModels:FindFirstChild(self.killerId)
	if not killerModel then
		warn(`Missing killer model for ID {self.killerId}`)
		return
	end

	local oldRoot = char:FindFirstChild("HumanoidRootPart")
	local oldCFrame: CFrame = oldRoot and oldRoot.CFrame or CFrame.new(0, 10, 0)

	local newModel = killerModel:Clone()
	newModel.Name = player.Name

	if not newModel.PrimaryPart then
		newModel.PrimaryPart = newModel:FindFirstChild("HumanoidRootPart")
	end

	newModel:SetPrimaryPartCFrame(oldCFrame)

	for _, scriptObj in ipairs(StarterPlayer.StarterCharacterScripts:GetChildren()) do
		scriptObj:Clone().Parent = newModel
	end

	task.wait()

	player.Character = newModel
	newModel.Parent = workspace

	char:Destroy()

	print(`[LOADOUT] Killer model {self.killerId} applied to {player.Name}`)
end

function KillerRole:ApplyAbilities()
	print("apply skill run")
	for slot, ability in ipairs(self.abilities) do
		print("Requirement:", ability.Requirement, "Player Level:", self.Level)
		print("UNLOCKED:", ability.Name)
		if self.Level >= ability.Requirement then
			KillerSkillService:AssignSkill(self.player, slot, ability.Name, ability.Tier)
		else
			print("LOCKED:", ability.Name)
		end
	end
end

function KillerRole:Remove()
	self.player:SetAttribute("IsKiller", false)
	print(`[KILLER ROLE] Removed killer role from {self.player.Name}`)
end

return KillerRole
