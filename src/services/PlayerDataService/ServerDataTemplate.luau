--!strict

export type KillerData = {
	PriceType: string,
	Price: number,
	Owned: boolean,
	Abilities: { KillerAbilityData },
}

export type ItemData = {
	PriceType: string,
	Price: number,
	Owned: boolean,
}

export type PassiveData = {
	PriceType: string,
	Price: number,
	Owned: boolean,
}

export type EquippedData = {
	Killer: string,
	Survivor: { Item: string? },
	Passive: {
		Slot1: string?,
		Slot2: string?,
		Slot3: string?,
	},
}

export type Role = {
	player: Player,
	roleName: string,
	Apply: (self: Role) -> (),
	Remove: (self: Role) -> (),
}

export type KillerAbilityData = {
	Name: string,
	Tier: number,
	Requirement: number,
}

export type PlayerData = {
	-- Currency & Stats
	Money: number,
	Level: number,
	Dosa: number,
	Maruah: number,

	-- Equipped Items
	Equipped: EquippedData,

	-- General Inventory
	Inventory: { any },

	-- Owned Killers
	Killer: { [string]: KillerData },

	-- Survivor Items
	SurvivorItems: { [string]: ItemData },

	-- Passive Skills
	Passive: { [string]: PassiveData },

	-- Player Settings
}
return {
	-- Currency & Stats
	Money = 0,
	Level = 1,
	Dosa = 0,
	Maruah = 0,

	-- Equipped Items
	Equipped = {
		Killer = "5", -- Equipped killer ID
		Survivor = { Item = nil },
		Passive = {
			Slot1 = nil,
			Slot2 = nil,
			Slot3 = nil,
		},
	},

	-- General Inventory (optional)
	Inventory = {},

	-- Owned Killers
	Killer = {
		["1"] = {
			PriceType = "Money",
			Price = 6000,
			Owned = true,
			Abilities = {
				{ Name = "ShadowVeil", Tier = 1, Requirement = 1 },
				{ Name = "VoidFootsteps", Tier = 1, Requirement = 10 },
				{ Name = "NightmareVision", Tier = 1, Requirement = 30 },
			},
		},

		["2"] = {
			PriceType = "Money",
			Price = 7000,
			Owned = false,
			Abilities = {
				{ Name = "CrimsonDash", Tier = 1, Requirement = 1 },
				{ Name = "HemorrhageSlash", Tier = 1, Requirement = 10 },
				{ Name = "BloodFrenzy", Tier = 1, Requirement = 30 },
			},
		},

		["3"] = {
			PriceType = "Money",
			Price = 8000,
			Owned = false,
			Abilities = {
				{ Name = "PhantomClone", Tier = 1, Requirement = 1 },
				{ Name = "SoulTrap", Tier = 1, Requirement = 10 },
				{ Name = "MindShatter", Tier = 1, Requirement = 30 },
			},
		},

		["4"] = {
			PriceType = "Money",
			Price = 9000,
			Owned = false,
			Abilities = {
				{ Name = "InfernoDash", Tier = 1, Requirement = 1 },
				{ Name = "HellfireBurst", Tier = 1, Requirement = 10 },
				{ Name = "DreadAura", Tier = 1, Requirement = 30 },
			},
		},

		["5"] = {
			PriceType = "Money",
			Price = 10000,
			Owned = true,
			Abilities = {
				{ Name = "SpectralDrift", Tier = 1, Requirement = 1 },
				{ Name = "CursedGrip", Tier = 1, Requirement = 10 },
				{ Name = "DeathSense", Tier = 1, Requirement = 30 },
			},
		},
	},

	-- Survivor Items
	SurvivorItems = {
		["Flashlight"] = {
			PriceType = "Money",
			Price = 1000,
			Owned = true,
		},
		["Medkit"] = {
			PriceType = "Money",
			Price = 1500,
			Owned = true,
		},
		["Toolbox"] = {
			PriceType = "Money",
			Price = 2000,
			Owned = false,
		},
	},

	-- Passive Skills
	Passive = {
		["Pekak"] = {
			PriceType = "Dosa",
			Price = 250,
			Owned = false,
		},
		["MedkitMastery"] = {
			PriceType = "Dosa",
			Price = 250,
			Owned = true,
		},
		["Dash"] = {
			PriceType = "Dosa",
			Price = 4000,
			Owned = false,
		},
		["Invisibility"] = {
			PriceType = "Dosa",
			Price = 5000,
			Owned = false,
		},
	},
}
