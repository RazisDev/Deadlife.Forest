local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)

local RootUi = require(ReplicatedStorage.UI.app.RootUi)

return function(target)
	local root = ReactRoblox.createRoot(target)

	root:render(React.createElement(RootUi))

	return function()
		root:unmount()
	end
end
