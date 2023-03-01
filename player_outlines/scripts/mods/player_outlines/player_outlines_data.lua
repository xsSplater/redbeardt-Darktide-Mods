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
			}
		}
	}
}
