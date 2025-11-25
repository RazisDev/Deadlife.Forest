--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local KillerRole = require(ReplicatedStorage.Shared.Classes.Roles.KillerRole)
local SurvivorRole = require(ReplicatedStorage.Shared.Classes.Roles.SurvivorRole)
local DataTemplate = require(ServerScriptService.Services.PlayerDataService.ServerDataTemplate)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService.PlayerDataServiceServer)

type PlayerData = DataTemplate.PlayerData

local RoleModule = {}

-- You can adjust this signature if your PlayerDataService API is different
local function getPlayerData(player: Player): PlayerData
	-- TODO: replace with your real accessor (e.g. PlayerDataService:Get(player))
	local data = PlayerDataService:Get(player)
	return data :: PlayerData
end

function RoleModule.Assign(players: { Player }): { [Player]: Player }
	local roles: { [Player]: Player } = {}

	if #players == 0 then
		return roles
	end

	-- pick 1 random killer
	local killerIndex = math.random(1, #players)
	local killerPlayer = players[killerIndex]

	for _, player in ipairs(players) do
		local playerData = getPlayerData(player)
		local killerId = playerData.Equipped.Killer
		local killerData = playerData.Killer[killerId]
		local abilities = killerData.Abilities

		local playerLevel = playerData.Level
		if player == killerPlayer then
			local killerRole = KillerRole.new(player, killerId, abilities, playerLevel)
			if killerRole then
				roles[player] = killerRole
			else
				-- fallback as survivor if data is bad
				roles[player] = SurvivorRole.new(player, playerData)
			end
		else
			roles[player] = SurvivorRole.new(player, playerData)
		end
	end

	return roles
end

return RoleModule
