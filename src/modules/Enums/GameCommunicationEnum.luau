-----------------------------
-- GameCommunicationEnum --
-----------------------------
local enum = {
	ToServer = {
		RequestRespawn = "RequestRespawn",
	},
	ToClient = {
		PlaySound = "PlaySound",
		StopSound = "StopSound",
		ChangeSoundToInside = "ChangeSoundToInside",
		ChangeSoundToBasement = "ChangeSoundToBasement",
		StartIntroScene = "StartIntroScene",
		StartStairScene = "StartStairScene",
		Lightning = "Lightning",
		RespawnGranted = "RespawnGranted",
	},
}

setmetatable(enum, {
	__index = function(self, key)
		error(("%s is not a valid member of %s"):format(tostring(key), script.Name))
	end,
})

return enum
