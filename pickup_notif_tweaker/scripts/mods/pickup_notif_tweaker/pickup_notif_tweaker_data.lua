local mod = get_mod("pickup_notif_tweaker")

return {
	name = "Pickup Notifications Tweaker",
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "show_text",
				type = "checkbox",
				default_value = true
			}, {
				setting_id = "show_icons",
				type = "checkbox",
				default_value = true
			}, {
				setting_id = "show_background",
				type = "checkbox",
				default_value = true
			}, {
				setting_id = "play_sounds",
				type = "checkbox",
				default_value = true
			}, {
				setting_id = "scale",
				type = "numeric",
				default_value = 100,
				range = { 20, 200 }
			}, {
				setting_id = "use_custom_background_colour",
				type = "checkbox",
				default_value = false
			}, {
				setting_id = "custom_background_alpha",
				type = "numeric",
				range = { 0, 255 },
				default_value = 255
			}, {
				setting_id = "custom_background_red",
				type = "numeric",
				range = { 0, 255 },
				default_value = 128
			}, {
				setting_id = "custom_background_green",
				type = "numeric",
				range = { 0, 255 },
				default_value = 128
			}, {
				setting_id = "custom_background_blue",
				type = "numeric",
				range = { 0, 255 },
				default_value = 128
			}
		}
	}
}
