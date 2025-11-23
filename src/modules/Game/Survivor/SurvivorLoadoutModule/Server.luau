local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerDataService = require(ServerScriptService.Services.PlayerDataService.PlayerDataServiceServer)
local PassiveService = require(ServerScriptService.Services.PassiveService.PassiveServiceServer)

local SurvivorLoadout = {}

function SurvivorLoadout.Apply(player)
	player:SetAttribute("IsKiller", false)

	-- Pull equipped data from DataStore
	local equipped = PlayerDataService:GetEquipped(player)
	if not equipped or type(equipped) ~= "table" then
		warn("[SurvivorLoadout] Invalid equipped data for", player.Name, equipped)
		return
	end

	-------------------------------
	-- APPLY SURVIVOR ITEMS
	-------------------------------
	local survivorItemId = equipped.Survivor
	if survivorItemId then
		-- You can extend based on item type
		if survivorItemId == "Flashlight" then
			-- give flashlight
		elseif survivorItemId == "Medkit" then
			-- give medkit
		elseif survivorItemId == "Toolbox" then
			-- give toolbox
		end
	end

	-------------------------------
	-- APPLY PASSIVES
	-------------------------------
	PassiveService:ApplyEquippedPassives(player)
end

return SurvivorLoadout
