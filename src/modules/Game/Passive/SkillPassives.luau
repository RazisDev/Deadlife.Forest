local SkillPassives

SkillPassives = {

	MedkitMastery = {
		name = "Medkit Mastery",
		tiers = { 5, 10, 15 },
		effectDescription = [[Healing Efficiency Increased by <b><font color="#87FF5A">5</font>/<font color="#FFD93D">10</font>/<font color="#FF3D3D">15</font>%</b>, Generator Repair Speed Reduced by <b>5%</b>.]],
		quote = [["Nah, just survive until the end."]],
		icon = "rbxassetid://87178146018521",
		price = 250,
		apply = function(player, slotName)
			-- Apply the effect for this passive
			player:SetAttribute("HealingBoost", 10)
		end,
	},
	Pekak = {
		name = "Pekak",
		tiers = { 5, 10, 15 },
		effectDescription = [[Hearing Efficiency Increased by <b><font color="#87FF5A">5</font>/<font color="#FFD93D">10</font>/<font color="#FF3D3D">15</font>%</b>.]],
		quote = [["I Know You Coming,HEHEHEH."]],
		icon = "rbxassetid://126808034296649",
		price = 250,
		apply = function(player, slotName)
			player:SetAttribute("FootstepRangeBoost", 5)
		end,
	},

	-- Add more passives here in future
}

return SkillPassives
