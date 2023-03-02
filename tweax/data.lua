local mod = get_mod("tweax")

return {
	name = "Redbeardt's Tweax",
	description = mod:localize("mod_description"),
	is_togglable = false,
	options = {
		widgets = {
			{
				setting_id = "threat_skull_marker_max_distance",
				type = "numeric",
				range = { 0, 200 },
				default_value = 200
			}, {
				setting_id = "fix_marker_colours",
				type = "checkbox",
				default_value = false
			}
		}
	}
}
