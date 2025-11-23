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
		["1"] = { PriceType = "Money", Price = 6000, Owned = true },
		["2"] = { PriceType = "Money", Price = 7000, Owned = false },
		["3"] = { PriceType = "Money", Price = 8000, Owned = false },
		["4"] = { PriceType = "Money", Price = 9000, Owned = false },
		["5"] = { PriceType = "Money", Price = 10000, Owned = true },
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

	-- Player Settings
	Settings = {
		Music = true,
		SFX = true,
		Volume = 1,
	},
}
