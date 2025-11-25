--!strict
local Base = require(script.Parent._BaseKillerSkills)
local Registry = require(script.Parent.KillerSkillRegistry)

local ShadowVeil = {}
ShadowVeil.__index = ShadowVeil
setmetatable(ShadowVeil, Base)

local DURATIONS = { 5, 10, 15 }
local COOLDOWNS = { 30, 25, 20 }

function ShadowVeil.new(player: Player, tier: number)
	local self = { playe = player, tier = tier }
	setmetatable(self, ShadowVeil)
	return self :: any
end

function ShadowVeil:Activate()
	local char = self.player.Character
	if not char then
		return
	end

	local duration = DURATIONS[self.tier]

	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Transparency = 1
		end
	end

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

function ShadowVeil:GetCooldown()
	return COOLDOWNS[self.tier]
end

function ShadowVeil:GetDescription()
	local d = DURATIONS[self.tier]
	return `Become invisible for {d} seconds.`
end

Registry:Register("ShadowVeil", ShadowVeil)
return ShadowVeil
