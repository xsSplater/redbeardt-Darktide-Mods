local mod = get_mod("helboring")

return {
	name = "Helboring",
	description = mod:localize("mod_description"),
	options = {
		widgets = {
			{
				setting_id = "charging_hold",
				default_value = {},
				title = "charging_hold_title",
				type = "keybind",
				keybind_global = false,
				keybind_trigger = "held",
				keybind_type = "function_call",
				function_name = "charging_hold"
			}, {
				setting_id = "charging_start",
				default_value = {},
				title = "charging_start_title",
				tooltip = "charging_start_tt",
				type = "keybind",
				keybind_global = false,
				keybind_trigger = "pressed",
				keybind_type = "function_call",
				function_name = "charging_start"
			}, {
				setting_id = "charging_stop",
				default_value = {},
				title = "charging_stop_title",
				tooltip = "charging_stop_tt",
				type = "keybind",
				keybind_global = false,
				keybind_trigger = "pressed",
				keybind_type = "function_call",
				function_name = "charging_stop"
			}
		}
	}
}
