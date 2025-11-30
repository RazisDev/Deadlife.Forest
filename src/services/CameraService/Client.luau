local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local KillerCamera = require(ReplicatedStorage.Shared.Services.CameraService.CameraServiceUtils)

local CameraServiceClient = {}

local function apply()
	local char = player.Character
	if not char then
		return
	end

	local root = char:FindFirstChild("HumanoidRootPart")
	local isKiller = player:GetAttribute("IsKiller")

	if isKiller and root then
		for _, obj in ipairs(char:GetDescendants()) do
			if obj:IsA("Accessory") then
				local handle = obj:FindFirstChild("Handle")
				if handle then
					handle.LocalTransparencyModifier = 1
				end
			end

			if obj:IsA("BasePart") then
				if obj.Name == "Head" or obj.Name == "Torso" then
					obj.LocalTransparencyModifier = 1
				end
			end
		end
		KillerCamera:Enable(root)
	else
		KillerCamera:Disable()
	end
end

function CameraServiceClient:Init()
	player.AttributeChanged:Connect(function(attr)
		if attr == "IsKiller" then
			apply()
		end
	end)

	player.CharacterAdded:Connect(function()
		task.wait(0.1) -- let killer model fully load
		apply()
	end)
end

return CameraServiceClient
