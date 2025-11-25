local BaseRole = {}
BaseRole.__index = BaseRole

export type Role = {
	player: Player,
	roleName: string,
	Apply: (self: Role) -> (),
	Remove: (self: Role) -> (),
}

function BaseRole.new(player: Player)
	local self = {
		player = player,
		roleName = "Base",
	}

	setmetatable(self, BaseRole)

	return self
end

function BaseRole:Apply() end
function BaseRole:Remove() end

return BaseRole
