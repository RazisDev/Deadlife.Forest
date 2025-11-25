--!strict
local Registry = {}
Registry.List = {} :: { [string]: any }

function Registry:Register(abilityName: string, class: any)
	self.List[abilityName] = class
end

function Registry:Get(abilityName: string)
	return self.List[abilityName]
end

return Registry
