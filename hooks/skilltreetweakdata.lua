local original_init = SkillTreeTweakData.init

function SkillTreeTweakData:init(...)
	original_init(self, ...)
	
	table.insert(self.specializations[14][1].upgrades, "player_cocaine_stacks_damaged_1")
	table.insert(self.specializations[14][3].upgrades, "player_cocaine_stacks_damage_reduction_1")
	table.remove(self.specializations[14][5].upgrades, 1)
	table.insert(self.specializations[14][5].upgrades, "player_cocaine_stacks_damaged_2")
	table.insert(self.specializations[14][7].upgrades, "player_cocaine_stacks_damage_reduction_2")
	
	
end