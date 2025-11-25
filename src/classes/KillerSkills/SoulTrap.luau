--!strict
local Registry = require(script.Parent.KillerSkillRegistry)

local SoulTrap = {}
SoulTrap.__index = SoulTrap
SoulTrap.Name = "SoulTrap" -- Optional, used by auto-registration

local DURATIONS = { 5, 10, 15 }
local COOLDOWNS = { 30, 25, 20 }

function SoulTrap.new(player: Player, tier: number)
	local self = {
		player = player,
		tier = tier,
	}
	return setmetatable(self, SoulTrap)
end

function SoulTrap:Activate()
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

function SoulTrap:GetCooldown()
	return COOLDOWNS[self.tier]
end

function SoulTrap:GetDescription()
	local d = DURATIONS[self.tier]
	return `Become invisible for {d} seconds.`
end

Registry:Register("SoulTrap", SoulTrap)
print("Registry SoulTrap")
return SoulTrap
