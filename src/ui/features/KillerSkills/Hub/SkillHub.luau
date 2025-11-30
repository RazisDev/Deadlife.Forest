local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local SkillButton = require(ReplicatedStorage.UI.features.KillerSkills.components.Siklls)

return function(props)
	-- props.skill1 is PhantomClone instance
	-- props.skill2 maybe SoulTrap
	-- props.skill3 maybe MindShatter

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	}, {

		PhantomCloneBtn = React.createElement(SkillButton, {
			skill = props.skill1,
			icon = "rbxassetid://123",
			position = UDim2.fromScale(0.8, 0.75),
		}),

		SoulTrapBtn = React.createElement(SkillButton, {
			skill = props.skill2,
			icon = "rbxassetid://456",
			position = UDim2.fromScale(0.87, 0.75),
		}),

		MindShatterBtn = React.createElement(SkillButton, {
			skill = props.skill3,
			icon = "rbxassetid://789",
			position = UDim2.fromScale(0.94, 0.75),
		}),
	})
end
