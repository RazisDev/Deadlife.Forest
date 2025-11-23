local enum = {
	Killer = "Killer",
	Survivor = "Survivor",
}

setmetatable(enum, {
	__index = function(self, key)
		error(("%s is not a valid member of %s"):format(tostring(key), script.Name))
	end,
})

return enum
