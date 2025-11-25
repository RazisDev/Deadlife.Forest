local BaseKillerSkill = {}
BaseKillerSkill.__index = BaseKillerSkill

function BaseKillerSkill.new(player: Player, tier: number)
	local self = { playe = player, tier = tier }
	setmetatable(self, BaseKillerSkill)

	return self
end

function BaseKillerSkill:Activate() end
function BaseKillerSkill:GetCooldown(): number
	return 10
end
function BaseKillerSkill:GetDescription(): string
	return ""
end

return BaseKillerSkill
