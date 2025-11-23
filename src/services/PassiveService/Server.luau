local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService.PlayerDataServiceServer)
local SkillPassives = require(ReplicatedStorage.Shared.Modules.Game.Passive.SkillPassives)

local PassiveService = {}
PassiveService._active = {} -- [player] = { Slot1 = passiveId, Slot2 = passiveId, Slot3 = passiveId }

----------------------------------------
-- REMOVE ALL PASSIVES FOR PLAYER
----------------------------------------
function PassiveService:ClearPassives(player)
	local active = self._active[player]
	if not active then
		return
	end

	for slotName, passiveId in pairs(active) do
		local passiveDef = SkillPassives[passiveId]
		if passiveDef and passiveDef.unapply then
			local ok, err = pcall(function()
				passiveDef.unapply(player, slotName)
			end)

			if not ok then
				warn("[PassiveService] Failed to unapply passive:", passiveId, err)
			end
		end
	end

	self._active[player] = nil
end

----------------------------------------
-- APPLY ALL EQUIPPED PASSIVES
----------------------------------------
function PassiveService:ApplyEquippedPassives(player)
	local equipped = PlayerDataService:GetEquipped(player)

	if not equipped or type(equipped) ~= "table" then
		warn("[PassiveService] Invalid equipped table for", player.Name)
		return
	end

	local passiveSlots = equipped.Passive
	if not passiveSlots then
		warn("[PassiveService] Equipped.Passive missing for", player.Name)
		return
	end

	-- Clear old passives first
	self:ClearPassives(player)

	self._active[player] = {}

	for slotName, passiveId in pairs(passiveSlots) do
		if passiveId then
			local passiveDef = SkillPassives[passiveId]

			if passiveDef and passiveDef.apply then
				local ok, err = pcall(function()
					passiveDef.apply(player, slotName)
				end)

				if not ok then
					warn("[PassiveService] Failed to apply passive", passiveId, "->", err)
				else
					self._active[player][slotName] = passiveId
				end
			else
				warn("[PassiveService] Passive definition missing:", passiveId)
			end
		end
	end
end

----------------------------------------
-- CLEANUP ON PLAYER REMOVE
----------------------------------------
function PassiveService:Init()
	Players.PlayerRemoving:Connect(function(player)
		self:ClearPassives(player)
	end)
end

return PassiveService
