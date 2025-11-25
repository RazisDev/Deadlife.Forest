local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local RoleModule = require(ServerScriptService.Modules.Game.RoleModule.RoleModuleServer)
local BaseRole = require(ReplicatedStorage.Shared.Classes.Roles._BaseRole)
local MatchEvent = ReplicatedStorage.Events.Remotes.MatchEvent
local startGameEvent = ServerStorage.Events.Bindables.StartGame

-- Your existing event/services
local playersLoadedEvent = ReplicatedStorage.Events.Remotes.PlayerLoaded

local GameServiceServer = {}
GameServiceServer.Roles = {} :: { [Player]: BaseRole.Role }

function GameServiceServer:Init()
	startGameEvent.Event:Connect(function()
		self:OnStartMatch()
	end)
end

function GameServiceServer:OnStartMatch()
	print("[MatchService] All players loaded. Starting Match.")

	local players = Players:GetPlayers()
	self.Roles = RoleModule.Assign(players)

	-- Assign roles (random or fixed)
	for _, role in pairs(self.Roles) do
		role:Apply()
	end

	-- Notify client of assigned role
	for player, roleObject in pairs(self.Roles) do
		MatchEvent:FireClient(player, "RoleAssigned", {
			role = roleObject.roleName, -- "Killer" or "Survivor"
		})
	end

	self:StartRound()
end

function GameServiceServer:StartRound()
	print("[GameServiceServer] Round has started!")

	--🔥 Your existing startGame() moved here
	warn("The game is starting.")

	-- Signal clients that loading is done
	playersLoadedEvent:FireAllClients()

	-- Start Intro cutscene (bus intro)
	--gameCommsEvent:FireAllClients(GameCommsEnum.ToClient.StartIntroScene, { Bus = workspace.Outdoor.Bus })
end

return GameServiceServer
