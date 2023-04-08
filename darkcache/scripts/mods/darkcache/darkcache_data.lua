local mod = get_mod("darkcache")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "armoury_caching",
				type = "checkbox",
				default_value = true
			}, {
				setting_id = "melk_caching",
				type = "checkbox",
				default_value = true
			}, {
				setting_id = "contracts_caching",
				type = "checkbox",
				default_value = true,
			}, {
				setting_id = "premium_store_caching",
				type = "checkbox",
				default_value = true
			}, {
				setting_id = "mission_board_caching",
				type = "checkbox",
				default_value = true
			}, {
				setting_id = "hub_caching",
				type = "checkbox",
				default_value = true
			}, {
				setting_id = "dev_mode",
				type = "checkbox",
				default_value = false
			}
		}
	}
}
