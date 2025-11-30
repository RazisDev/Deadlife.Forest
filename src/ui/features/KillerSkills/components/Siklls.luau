-- ui/features/skills/components/SkillButton.luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)

local function SkillButton(props)
	-- props.skill: the killer skill instance
	-- props.icon: image asset
	-- props.position: UDim2

	local skill = props.skill

	local cooldown, setCooldown = React.useState(0)

	-- Listen to skill instance events
	React.useEffect(function()
		if not skill or not skill.Event then
			return
		end

		local conn = skill.Event.Event:Connect(function(eventType, value)
			if eventType == "CooldownUpdate" then
				setCooldown(value)
			elseif eventType == "CooldownComplete" then
				setCooldown(0)
			end
		end)

		return function()
			conn:Disconnect()
		end
	end, { skill })

	return React.createElement("ImageButton", {
		Size = UDim2.fromScale(0.07, 0.07),
		Position = props.position,
		Image = props.icon,
		BackgroundTransparency = 1,
	}, {

		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),

		UIStroke = React.createElement("UIStroke", {
			Color = Color3.fromRGB(255, 255, 255),
			Thickness = 2,
			Transparency = 0.4,
		}),

		CooldownLabel = React.createElement("TextLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = cooldown > 0 and tostring(cooldown) or "",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextScaled = true,
			Font = Enum.Font.GothamBold,
		}),
	})
end

return SkillButton
