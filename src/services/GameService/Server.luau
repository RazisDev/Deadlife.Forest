local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local Sections = require(ServerScriptService.Modules.Game.GameSection.GameSectionServer)
local RoleModule = require(ServerScriptService.Modules.Game.RoleModule.RoleModuleServer)
local KillerLoadout = require(ServerScriptService.Modules.Game.Killer.KillerLoadoutModule.KillerLoadoutModuleServer)
local SurvivorLoadout =
	require(ServerScriptService.Modules.Game.Survivor.SurvivorLoadoutModule.SurvivorLoadoutModuleServer)

local MatchEvent = ReplicatedStorage.Events.Remotes.MatchEvent
local startGameEvent = ServerStorage.Events.Bindables.StartGame

-- Your existing event/services
local playersLoadedEvent = ReplicatedStorage.Events.Remotes.PlayerLoaded
local gameCommsEvent = ReplicatedStorage.Events.Remotes.GameCommunication

local GameCommsEnum = require(ReplicatedStorage.Shared.Modules.Enums.GameCommunicationEnum)

local MatchService = {}
MatchService.Roles = {}

function MatchService:Init()
	startGameEvent.Event:Connect(function()
		self:OnStartMatch()
	end)
end

function MatchService:OnStartMatch()
	print("[MatchService] All players loaded. Starting Match.")

	local players = Players:GetPlayers()

	-- Assign roles
	self.Roles = RoleModule.Assign(players)

	-- Apply loadouts
	for player, role in pairs(self.Roles) do
		if role == "Killer" then
			KillerLoadout.Apply(player)
		else
			SurvivorLoadout.Apply(player)
		end
	end

	-- Notify clients (You are Killer/Survivor)
	for player, role in pairs(self.Roles) do
		MatchEvent:FireClient(player, "RoleAssigned", {
			role = role,
		})
	end

	-- Continue to actual round intro
	self:StartRound()
end

function MatchService:StartRound()
	print("[MatchService] Round has started!")

	--🔥 Your existing startGame() moved here
	warn("The game is starting.")

	-- Signal clients that loading is done
	playersLoadedEvent:FireAllClients()

	-- Start Intro cutscene (bus intro)
	--gameCommsEvent:FireAllClients(GameCommsEnum.ToClient.StartIntroScene, { Bus = workspace.Outdoor.Bus })
end

return MatchService
