local mod  = get_mod("stuff_searcher")

return {
	name = "Stuff Searcher",
	description = mod:localize("mod_description"),
	is_togglable = false,
	options = {
		widgets = {
			{
				setting_id = "escape_defocuses",
				type = "checkbox",
				default_value = true
			}
		}
	}
}
