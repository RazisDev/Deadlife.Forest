--!strict
local Registry = require(script.Parent.KillerSkillRegistry)

local MindShatter = {}
MindShatter.__index = MindShatter
MindShatter.Name = "MindShatter" -- Optional, used by auto-registration

local DURATIONS = { 5, 10, 15 }
local COOLDOWNS = { 30, 25, 20 }

function MindShatter.new(player: Player, tier: number)
	local self = {
		player = player,
		tier = tier,
	}
	return setmetatable(self, MindShatter)
end

function MindShatter:Activate()
	local char = self.player.Character
	if not char then
		return
	end

	local duration = DURATIONS[self.tier]

	-- Make invisible
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Transparency = 1
		end
	end

	-- Restore transparency
	task.delay(duration, function()
		local char2 = self.player.Character
		if not char2 then
			return
		end

		for _, p in ipairs(char2:GetDescendants()) do
			if p:IsA("BasePart") then
				p.Transparency = 0
			end
		end
	end)
end

function MindShatter:GetCooldown()
	return COOLDOWNS[self.tier]
end

function MindShatter:GetDescription()
	local d = DURATIONS[self.tier]
	return `Become invisible for {d} seconds.`
end

Registry:Register("MindShatter", MindShatter)
print("Registry MindShatter")
return MindShatter
