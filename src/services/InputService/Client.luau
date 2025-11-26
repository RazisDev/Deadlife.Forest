local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local SkillEvent = ReplicatedStorage.Events.Remotes.KillerSkillEvent

local InputServiceClient = {}

function InputServiceClient:Start()
	UIS.InputBegan:Connect(function(input, gp)
		if gp then
			return
		end

		if input.KeyCode == Enum.KeyCode.Q then
			print("Q pess")
			SkillEvent:FireServer(1)
		elseif input.KeyCode == Enum.KeyCode.E then
			print("E pess")
			SkillEvent:FireServer(2)
		elseif input.KeyCode == Enum.KeyCode.R then
			print("R pess")
			SkillEvent:FireServer(3)
		end
	end)
end

return InputServiceClient
