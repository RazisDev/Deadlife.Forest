-----------------------------
-- GuiActionsEnum --
-----------------------------
local enum = {
	UpdateObjectives = "UpdateObjectives",
	ObjectiveFulfilled = "ObjectiveFulfilled",
	ObjectiveFailed = "ObjectiveFailed",
	UpdateTasks = "UpdateTasks",
	UpdateTask = "UpdateTask",
	TaskFulfilled = "TaskFulfilled",
	AddObjective = "AddObjective",
	SmallMessage = "SmallMessage",
	UpdateCountdown = "UpdateCountdown",
	HideTaskFrame = "HideTaskFrame",
	CollectedMoney = "CollectedMoney",
	IntroMessage = "IntroMessage",
	OutroFrame = "OutroFrame",
	Died = "Died",
}

setmetatable(enum, {
	__index = function(self, key)
		error(("%s is not a valid member of %s"):format(tostring(key), script.Name))
	end,
})

return enum
