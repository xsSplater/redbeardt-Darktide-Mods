local mod = get_mod("holier_revenant")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	options = {
		widgets = {
			{
				setting_id = "gradual_background_update",
				type = "checkbox",
				default_value = false
			}
		}
	}
}
