-- UI.luau (client-only module)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)

local RootUi = require(ReplicatedStorage.UI.app.RootUi)

local Ui = {}

function Ui:Init()
	print("[UI] Init")
end

function Ui:Start()
	print("[UI] Start")

	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

	local element = React.createElement(RootUi)
	ReactRoblox.createRoot(playerGui):render(element)
end

return Ui
