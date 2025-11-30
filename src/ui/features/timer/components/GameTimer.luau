local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)

local TimerEvent = ReplicatedStorage.Events.Remotes.TimerEvent

local useState = React.useState
local useEffect = React.useEffect

local function format(sec: number): string
	local m = math.floor(sec / 60)
	local s = sec % 60
	return string.format("%02d:%02d", m, s)
end

local function GameTimer()
	local time, setTime = useState(0)
	local running, setRunning = useState(false)

	useEffect(function()
		local connection = TimerEvent.OnClientEvent:Connect(function(eventType, value)
			if eventType == "Start" then
				setRunning(true)
				setTime(value)
			elseif eventType == "Update" then
				setTime(value)
			elseif eventType == "Finished" then
				setRunning(false)
				setTime(0)
			end
		end)

		return function()
			connection:Disconnect()
		end
	end, {})

	if not running and time == 0 then
		return nil
	end

	return React.createElement("TextLabel", {
		Size = UDim2.fromOffset(200, 60),
		Position = UDim2.fromScale(0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Text = format(time),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 36,
		Font = Enum.Font.GothamBold,
	})
end

return GameTimer
