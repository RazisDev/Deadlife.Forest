local Rodux = require(game.ReplicatedStorage.Packages.Rodux)
local rootReducer = require(script.reducer)

local store = Rodux.Store.new(rootReducer, nil, {
	Rodux.loggerMiddleware,
})

return store
