--========================================================
-- PlayerDataServiceServer (Datastore + Patch System Only)
--========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local ServerDataTemplate = require(script.Parent.ServerDataTemplate)
local ProfileStore = require(ServerScriptService.ServerPackages._Index["lm-loleris_profilestore@1.0.3"]["profilestore"])
local DataTemplate = require(ServerScriptService.Services.PlayerDataService.ServerDataTemplate)

local PlayerDataServiceServer = {}
PlayerDataServiceServer.Profiles = {}
PlayerDataServiceServer.LoadFailures = {}

local storeName = RunService:IsStudio() and "PlayerDataStudio" or "PlayerDataLive"
local PlayerStore = ProfileStore.New(storeName, DataTemplate)

--------------------------------------------------------
-- INTERNAL: profile loader
--------------------------------------------------------
function PlayerDataServiceServer:_getProfile(player, timeout)
	timeout = timeout or 5

	if self.LoadFailures[player] then
		return false, "Profile failed to load"
	end

	local profile = self.Profiles[player]
	if profile and profile:IsActive() then
		return true, profile
	end

	local waited = 0
	while waited < timeout do
		local p = self.Profiles[player]
		if p and p:IsActive() then
			return true, p
		end
		task.wait(0.1)
		waited += 0.1
	end

	return false, "Profile not loaded"
end

function PlayerDataServiceServer:Get(player)
	local ok, profile = self:_getProfile(player)
	if not ok then
		return profile
	end
	return true, profile.Data
end

function PlayerDataServiceServer:GetKiller(player)
	local ok, profile = self:_getProfile(player)
	if not ok then
		return false, profile
	end

	return true, profile.Data.Killer
end

function PlayerDataServiceServer:GetPassive(player)
	local ok, profile = self:_getProfile(player)
	if not ok then
		return false, profile
	end

	return true, profile.Data.Passive
end

function PlayerDataServiceServer:GetPassiveSlot(player)
	local data = PlayerDataServiceServer:Get(player)

	return true
end

function PlayerDataServiceServer:GetOwnedKiller(player)
	local ok, profile = self:_getProfile(player)
	if not ok then
		return false, profile
	end

	local data = profile.Data
	local killerData = profile.Data.Killer
	local killerSlot = profile.Data.Equipped.Killer
	return true, { killerData, killerSlot }
end

function PlayerDataServiceServer:EquipKiller(player, killerId)
	local ok, profile = self:_getProfile(player)
	if not ok then
		return false, profile
	end

	local data = profile.Data

	-- Defensive: ensure Killer table exists
	if type(data.Killer) ~= "table" then
		return false, "Killer data corrupted on server"
	end

	local killerInfo = data.Killer[killerId]
	if not killerInfo then
		return false, "Unknown killer: " .. tostring(killerId)
	end

	if not killerInfo.Owned then
		return false, "You do not own killer " .. tostring(killerId)
	end

	-- Set equipped killer
	self:Set(player, { "Equipped", "Killer" }, killerId)

	-- return updated equipped data back to client
	return true
end

function PlayerDataServiceServer:GetEquipped(player)
	local ok, profile = self:_getProfile(player)
	if not ok then
		return false, profile
	end

	local data = profile.Data

	return data.Equipped
end

function PlayerDataServiceServer:Init() end

--------------------------------------------------------
-- Player lifecycle
--------------------------------------------------------
function PlayerDataServiceServer:_onJoin(player)
	local profile = PlayerStore:StartSessionAsync("Player_" .. player.UserId, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	if not profile then
		player:Kick("Data load failed")
		self.LoadFailures[player] = true
		return
	end

	profile:Reconcile()
	self.Profiles[player] = profile
	print(RunService:IsStudio())
	if RunService:IsStudio() then
		profile.Data.Killer = ServerDataTemplate.Killer
		profile.Data.Passive = ServerDataTemplate.Passive
		--profile.Data.Equipped.Passive = ServerDataTemplate.Equipped.Passive
		player:SetAttribute("Money", 100000 or 0)
		player:SetAttribute("Dosa", 10000 or 0)
		player:SetAttribute("Level", 10000 or 1)
		player:SetAttribute("ProfileReady", true)
	else
		local d = profile.Data
		player:SetAttribute("Money", d.Money or 0)
		player:SetAttribute("Dosa", d.Dosa or 0)
		player:SetAttribute("Level", d.Level or 1)
		player:SetAttribute("ProfileReady", true)
	end
end

function PlayerDataServiceServer:_onLeave(player)
	local profile = self.Profiles[player]
	if not profile then
		return
	end

	-- Pull-back attributes safely
	pcall(function()
		profile.Data.Money = player:GetAttribute("Money")
		profile.Data.Dosa = player:GetAttribute("Dosa")
		profile.Data.Level = player:GetAttribute("Level")
	end)

	profile:EndSession()
	self.Profiles[player] = nil
end

function PlayerDataServiceServer:Start()
	for _, p in ipairs(Players:GetPlayers()) do
		self:_onJoin(p)
	end

	Players.PlayerAdded:Connect(function(p)
		self:_onJoin(p)
	end)

	Players.PlayerRemoving:Connect(function(p)
		self:_onLeave(p)
	end)
end

return PlayerDataServiceServer
