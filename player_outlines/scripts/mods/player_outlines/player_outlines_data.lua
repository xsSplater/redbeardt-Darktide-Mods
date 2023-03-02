local mod = get_mod("player_outlines")

return {
	name = "Player Outlines",
	description = mod:localize("mod_description"),
	options = {
		widgets = {
			{
				setting_id = "show_hologram",
				type = "checkbox",
				default_value = true
			}, {
				setting_id = "show_mesh",
				type = "checkbox",
				default_value = true
			}, {
				setting_id = "show_outline",
				type = "checkbox",
				default_value = true
			}, {
				setting_id = "show_in_hub",
				type = "checkbox",
				default_value = false
			}, {
				setting_id = "mission_nameplates_max_distance",
				title = "mission_nameplates_max_distance_title",
				tooltip = "mission_nameplates_max_distance_tt",
				type = "numeric",
				range = { 0, 500 },
				default_value = 500
			}, {
				setting_id = "assist_marker_max_distance",
				title = "assist_marker_max_distance_title",
				tooltip = "assist_marker_max_distance_tt",
				type = "numeric",
				range = { 0, 200 },
				default_value = 200
			}
		}
	}
}
