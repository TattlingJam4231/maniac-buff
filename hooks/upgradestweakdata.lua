local original_player_definitions = UpgradesTweakData._player_definitions

function UpgradesTweakData:_player_definitions(...)
	original_player_definitions(self, ...)
	
	self.cocaine_stacks_convert_levels = {30, 25}
	self.cocaine_stacks_tick_t = 3
	self.max_cocaine_stacks_per_tick = 240
	self.max_cocaine_damage_per_tick = 240
	self.cocaine_stacks_decay_percentage_per_tick = 0.6
	self.cocaine_stacks_decay_amount_per_tick = 90
	self.cocaine_stacks_decay_t = 3
	self.cocaine_stacks_decay_trigger_t = 6
	self.max_total_cocaine_stacks = 600
	
	
	self.definitions.player_cocaine_stacks_damage_reduction_1 = {
		name_id = "menu_player_cocaine_stacks_damage_reduction_1",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "cocaine_stacks_damage_reduction_1",
			category = "player"
		}
	}
	self.definitions.player_cocaine_stacks_damaged_1 = {
		name_id = "menu_player_cocaine_stacks_damaged_1",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "cocaine_stacks_damaged_1",
			category = "player"
		}
	}
	
	self.definitions.player_cocaine_stacks_damage_reduction_2 = {
		name_id = "menu_player_cocaine_stacks_damage_reduction_2",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "cocaine_stacks_damage_reduction_2",
			category = "player"
		}
	}
	self.definitions.player_cocaine_stacks_damaged_2 = {
		name_id = "menu_player_cocaine_stacks_damaged_2",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "cocaine_stacks_damaged_2",
			category = "player"
		}
	}
	self.values.player.cocaine_stack_absorption_multiplier = {1.5}
	self.values.player.cocaine_stacks_damage_reduction_1 = {0.75}
	self.values.player.cocaine_stacks_damaged_1 = {80}
	self.values.player.cocaine_stacks_damage_reduction_2 = {0.65}
	self.values.player.cocaine_stacks_damaged_2 = {60}
end