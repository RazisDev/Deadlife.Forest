-- Shared/Services/GameTimerService/GameTimerServiceClient.luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TimerEvent = ReplicatedStorage.Events.Remotes.TimerEvent

local GameTimerServiceClient = {}

function GameTimerServiceClient:Init()
	print("[TimerClient] Init")
end

function GameTimerServiceClient:Start()
	print("[TimerClient] Start")
	-- nothing needed here, component will subscribe itself
end

return GameTimerServiceClient
