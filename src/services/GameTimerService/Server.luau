local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TimerEvent = ReplicatedStorage.Events.Remotes.TimerEvent
local startGameEvent = ServerStorage.Events.Bindables.StartGame

local GameTimerServiceServer = {}

local timeLeft = 0
local running = false

function GameTimerServiceServer:Count(duration)
	if running then
		return
	end
	running = true
	timeLeft = duration

	TimerEvent:FireAllClients("Start", timeLeft)

	task.spawn(function()
		while running and timeLeft > 0 do
			task.wait(1)
			timeLeft -= 1

			--print(timeLeft)

			TimerEvent:FireAllClients("Update", timeLeft)
		end

		running = false
		TimerEvent:FireAllClients("Finished")
	end)
end

function GameTimerServiceServer:Stop()
	running = false
end

local function OnStartMatch()
	GameTimerServiceServer:Count(300)
end

function GameTimerServiceServer:Init()
	startGameEvent.Event:Connect(function()
		OnStartMatch()
	end)
end

return GameTimerServiceServer
