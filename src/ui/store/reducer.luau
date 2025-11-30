local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rodux = require(ReplicatedStorage.Packages.Rodux)

local rootReducer = Rodux.combineReducers({})

return rootReducer
