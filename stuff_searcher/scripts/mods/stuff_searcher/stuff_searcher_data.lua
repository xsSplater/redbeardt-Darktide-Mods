local mod  = get_mod("stuff_searcher")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = false,
	options = {
		widgets = {
			{
				setting_id = "escape_defocuses",
				type = "checkbox",
				default_value = true
			},
			{
				setting_id = "debug_mode",
				type = "checkbox",
				default_value = false
			}
		}
	}
}
