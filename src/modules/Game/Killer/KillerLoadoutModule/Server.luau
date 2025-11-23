local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local KillerLoadout = {}

function KillerLoadout.Apply(player)
	player:SetAttribute("IsKiller", true)

	local char = player.Character
	if not char then
		return
	end

	local killerId = player:GetAttribute("EquippedKiller") or "1"
	local killerModel = ServerStorage.KillerModel:FindFirstChild(killerId)

	if not killerModel then
		warn("Killer model missing:", killerId)
		return
	end

	-- Store old position
	local oldRootPart = char:FindFirstChild("HumanoidRootPart")
	local oldCFrame = oldRootPart and oldRootPart.CFrame or CFrame.new(0, 10, 0)

	-- Clone the killer model
	local newModel = killerModel:Clone()
	newModel.Name = player.Name

	-- Set PrimaryPart if not already set
	if not newModel.PrimaryPart then
		newModel.PrimaryPart = newModel:FindFirstChild("HumanoidRootPart")
	end

	-- Set position
	newModel:SetPrimaryPartCFrame(oldCFrame)

	-- Copy StarterCharacterScripts
	for _, object in ipairs(game.StarterPlayer.StarterCharacterScripts:GetChildren()) do
		local newObject = object:Clone()
		newObject.Parent = newModel
	end

	-- Small wait for scripts to initialize
	task.wait(0.1)

	-- NOW assign to player
	player.Character = newModel
	newModel.Parent = workspace

	-- Destroy old model
	char:Destroy()

	print("Applied killer loadout to", player.Name)
end

return KillerLoadout
