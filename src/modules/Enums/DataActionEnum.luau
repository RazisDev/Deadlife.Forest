-----------------------------
-- ENUM MODULE SCRIPT --
-----------------------------

local enum = {
	ToServer = {
		GetPlayerData = "GetPlayerData",
		GetEquipped = "GetEquipped",
		EquipKiller = "EquipKiller",
		UnequipKiller = "UnequipKiller",
		EquipItem = "EquipItem",
		UnequipItem = "UnequipItem",
		EquipPassive = "EquipPassive",
		UnequipPassive = "UnequipPassive",
		GetOwnedKiller = "GetOwnedKiller",
	},
	ToClient = {
		PlayerDataTabele = "PlayerDataTable",
	},
}

setmetatable(enum, {
	__index = function(key)
		error(("%s is not a valid member of %s"):format(tostring(key), script.Name))
	end,
})

return enum
