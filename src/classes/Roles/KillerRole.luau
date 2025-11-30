local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Teams = game:GetService("Teams")
local Workspace = game:GetService("Workspace")

local KillerSkillService = require(ServerScriptService.Services.KillerSkillService.KillerSkillServiceServer)
local ServerDataTemplate = require(ServerScriptService.Services.PlayerDataService.ServerDataTemplate)

type KillerAbilityData = ServerDataTemplate.KillerAbilityData
type playerLevelType = typeof(ServerDataTemplate.Level)

local KillerRole = {}
KillerRole.__index = KillerRole

local CharKillerSkill = {}

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

	-- Set team to Killer
	local killerTeam = game:GetService("Teams"):FindFirstChild("Killer")
	if killerTeam then
		self.player.Team = killerTeam
	end

	self:ApplyLoadout()
	self:ApplyAbilities()

	-- Auto-reapply on respawn with debounce
	if not self.respawnConnection then
		self.respawnConnection = self.player.CharacterAdded:Connect(function(character)
			-- Prevent infinite loop
			if self.isApplyingLoadout then
				return
			end

			-- Wait for character to fully load
			character:WaitForChild("HumanoidRootPart")

			self:ApplyLoadout()
			self:ApplyAbilities()
		end)
	end

	print(`[KILLER ROLE] Applied killer {self.killerId} to {self.player.Name}`)
end

function KillerRole:ApplyLoadout()
	-- Set debounce flag
	self.isApplyingLoadout = true

	local player: Player = self.player
	local char = player.Character
	if not char then
		self.isApplyingLoadout = false
		return
	end

	local killerModels = ServerStorage:FindFirstChild("KillerModel")
	if not killerModels then
		warn("Missing folder: ServerStorage.KillerModel")
		self.isApplyingLoadout = false
		return
	end

	local killerModel = killerModels:FindFirstChild(self.killerId)
	if not killerModel then
		warn(`Missing killer model for ID {self.killerId}`)
		self.isApplyingLoadout = false
		return
	end

	-- Get killer spawn location with offset
	local killerSpawn = workspace:FindFirstChild("SpawnLocationKiller")
	local spawnCFrame = killerSpawn and killerSpawn.CFrame or CFrame.new(0, 10, 0)
	local offset = CFrame.new(0, 5, 0)
	spawnCFrame = spawnCFrame * offset

	local newModel = killerModel:Clone()
	newModel.Name = player.Name

	if not newModel.PrimaryPart then
		newModel.PrimaryPart = newModel:FindFirstChild("HumanoidRootPart")
	end

	-- Use spawn CFrame for new spawns, old CFrame for respawns
	newModel:SetPrimaryPartCFrame(spawnCFrame)

	for _, scriptObj in ipairs(StarterPlayer.StarterCharacterScripts:GetChildren()) do
		scriptObj:Clone().Parent = newModel
	end

	task.wait()

	player.Character = newModel
	newModel.Parent = workspace

	char:Destroy()

	-- Release debounce after a short delay
	task.wait(0.1)
	self.isApplyingLoadout = false

	print(`[LOADOUT] Killer model {self.killerId} applied to {player.Name}`)
end

function KillerRole:ApplyAbilities()
	print("apply skill run")
	for slot, ability in ipairs(self.abilities) do
		if self.Level >= ability.Requirement then
			KillerSkillService:AssignSkill(self.player, slot, ability.Name, ability.Tier)
			CharKillerSkill[self.player] = { slot, ability.Name, ability.Tier }
			print(CharKillerSkill)
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
