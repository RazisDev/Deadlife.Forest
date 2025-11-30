local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)

local SkillButton = React.Component:extend("SkillButton")

function SkillButton:render(props)
	return {
		React.createElement("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.fromScale(1, 0.7),
			Size = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
		}, {
			React.createElement("ImageButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				--[[props.Position or ]]
				Position = UDim2.fromScale(0.94, 0.9),
				--[[props.Size or]]
				Size = UDim2.fromScale(0.06, 0.1),
			}, {
				React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
			}),
			React.createElement("ImageButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				--[[props.Position or ]]
				Position = UDim2.fromScale(0.95, 0.75),
				--[[props.Size or]]
				Size = UDim2.fromScale(0.06, 0.1),
			}, {
				React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
			}),
			React.createElement("ImageButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				--[[props.Position or ]]
				Position = UDim2.fromScale(0.85, 0.94),
				--[[props.Size or]]
				Size = UDim2.fromScale(0.06, 0.1),
			}, {
				React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
			}),
		}),
	}
end

return SkillButton
