local mod = get_mod("holier_revenant")

return {
	name = "Holier Revenant",
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
