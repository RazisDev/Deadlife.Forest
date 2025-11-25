-----------------------------
-- PlayerJoinedService --
-----------------------------
-----------------------------
-- SERVICES --
-----------------------------
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-----------------------------
-- VARIABLES --
-----------------------------
local PlayerJoinedService = {}

local startGameEvent = ServerStorage.Events.Bindables.StartGame
local playerLoadedEvent = ReplicatedStorage.Events.Remotes.PlayerLoaded

local teleportData
local playersInGame = 0
local expectedPlayers = 0
local timeElapsed = 0
local loadedPlayers = {}

-----------------------------
-- PRIVATE FUNCTIONS --
-----------------------------

local function startGame()
	startGameEvent:Fire()
end

local function onDescendantRemoved(descendant)
	if descendant:IsA("BasePart") then
		descendant.CollisionGroup = "Default"
	end
end

local function onDescendantAdded(descendant)
	if descendant:IsA("BasePart") then
		descendant.CollisionGroup = "Player"
	end
end

local function onCharacterAdded(character)
	-- footsteps
	local rootPart = character.HumanoidRootPart
	local footstepSound = Instance.new("Sound")
	footstepSound.Name = "Footsteps"
	footstepSound.Volume = 0.15
	footstepSound.RollOffMaxDistance = 30
	footstepSound.RollOffMode = Enum.RollOffMode.InverseTapered
	footstepSound.PlayOnRemove = true
	footstepSound.Parent = rootPart

	for _, child in character:GetDescendants() do
		onDescendantAdded(child)
	end
	character.DescendantAdded:Connect(onDescendantAdded)
	character.DescendantRemoving:Connect(onDescendantRemoved)
end

local function onPlayerAdded(player: Player)
	playersInGame += 1
	print(playersInGame)
	player.CharacterAdded:Connect(onCharacterAdded)

	if teleportData then
		return
	end

	teleportData = player:GetJoinData().TeleportData
	if not teleportData then
		expectedPlayers = 1
	else
		expectedPlayers = teleportData.ExpectedPlayers
	end
end

local function onPlayerRemoving(player)
	playersInGame -= 1
	expectedPlayers -= 1
	local i = table.find(loadedPlayers, player)
	if i then
		table.remove(loadedPlayers, i)
	end
end

-----------------------------
-- PUBLIC FUNCTIONS --
-----------------------------
function PlayerJoinedService:Init()
	for _, player in Players:GetPlayers() do
		onPlayerAdded(player)
	end
	Players.PlayerAdded:Connect(onPlayerAdded)

	Players.PlayerRemoving:Connect(onPlayerRemoving)

	playerLoadedEvent.OnServerEvent:Connect(function(player)
		if not table.find(loadedPlayers, player) then
			table.insert(loadedPlayers, player)
		end
	end)
end

function PlayerJoinedService:Start()
	task.defer(function()
		if #Players:GetPlayers() == 0 then
			Players.PlayerAdded:Wait() -- wait for the first player to join
		end
		while expectedPlayers == 0 do
			task.wait()
		end

		print(expectedPlayers)
		while playersInGame < expectedPlayers do
			task.wait(1)
			timeElapsed += 1
			print("Waiting for players... (" .. playersInGame .. "/" .. expectedPlayers .. ")")
			if timeElapsed >= 60 then
				break
			end
		end

		timeElapsed = 0
		task.wait(1)

		while #loadedPlayers < playersInGame do
			timeElapsed += 1
			if timeElapsed >= 180 then
				for _, player in Players:GetPlayers() do
					if table.find(loadedPlayers, player) then
						continue
					end
					player:Kick("You took too long to load into the game!")
				end
			end
			task.wait(1)
		end
		print("Player in game is" .. playersInGame .. "player shurt be" .. expectedPlayers)
		startGame()
	end)
end

-----------------------------
-- MAIN --
-----------------------------
return PlayerJoinedService
