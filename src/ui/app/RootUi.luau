local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local GameTimer = require(ReplicatedStorage.UI.features.timer.components.GameTimer)
local killerHub = require(ReplicatedStorage.UI.features.KillerSkills.Hub.SkillHub)
local SkillSButton = require(ReplicatedStorage.UI.features.KillerSkills.components.SkillButton)

return function()
	return React.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, {
		Timer = React.createElement(GameTimer),
		--killerHub = React.createElement(killerHub()),
		SkillSButton = React.createElement(SkillSButton),
	})
end
