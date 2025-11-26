--!strict
local Registry = require(script.Parent.KillerSkillRegistry)

local PhantomClone = {}
PhantomClone.__index = PhantomClone

local DURATIONS = { 5, 10, 15 }
local COOLDOWNS = { 30, 25, 20 }

function PhantomClone.new(player: Player, tier: number)
	local self = {
		player = player,
		tier = tier,
		isCooldown = false,
		cooldownRemaining = 0,
		_originalTransparency = {},
	}
	return setmetatable(self, PhantomClone)
end

function PhantomClone:Activate()
	if self.isCooldown then
		return
	end

	local char = self.player.Character
	if not char then
		return
	end

	-- START COOLDOWN
	self.isCooldown = true
	self.cooldownRemaining = COOLDOWNS[self.tier]
	self:_startCooldownWorker()

	-- APPLY INVISIBILITY
	local duration = DURATIONS[self.tier]
	self._originalTransparency = {}

	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			-- Save original transparency
			self._originalTransparency[part] = part.Transparency

			if part.Name == "HumanoidRootPart" then
				continue
			end

			part.Transparency = 0.8
		end
	end

	-- RESTORE AFTER DURATION
	task.delay(duration, function()
		local newChar = self.player.Character
		if not newChar then
			return
		end

		for part, old in pairs(self._originalTransparency) do
			if part and part.Parent then
				part.Transparency = old
			end
		end
	end)
end

-- Cooldown ticking in background
function PhantomClone:_startCooldownWorker()
	task.spawn(function()
		while self.cooldownRemaining > 0 do
			self.cooldownRemaining -= 1

			print("Cooldown:", self.cooldownRemaining)

			-- If you want UI update:
			-- RemoteEvent:FireClient(self.player, "UpdateCooldown", "PhantomClone", self.cooldownRemaining)

			task.wait(1)
		end

		self.isCooldown = false
	end)
end

function PhantomClone:GetCooldown()
	return COOLDOWNS[self.tier]
end

function PhantomClone:GetDescription()
	return `Become invisible for {DURATIONS[self.tier]} seconds.`
end

Registry:Register("PhantomClone", PhantomClone)
return PhantomClone
