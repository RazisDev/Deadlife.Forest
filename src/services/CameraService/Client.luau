local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local CameraServiceClient = {}
function CameraServiceClient:applyKillerCamera()
	if player:GetAttribute("IsKiller") then
		player.CameraMode = Enum.CameraMode.LockFirstPerson
		camera.CameraSubject = player.Character:WaitForChild("Humanoid")
	else
		player.CameraMode = Enum.CameraMode.Classic
	end
end

function CameraServiceClient:Init()
	player.AttributeChanged:Connect(function(attr)
		if attr == "IsKiller" then
			CameraServiceClient:applyKillerCamera()
		end
	end)
end

function CameraServiceClient:Start()
	player.CharacterAdded:Connect(function()
		task.wait(0.1)
		CameraServiceClient:applyKillerCamera()
	end)
end
-- When character respawns

return CameraServiceClient
