local mod = get_mod("meat_grinder_i")

mod:hook_require("scripts/settings/game_mode/game_mode_settings_shooting_range", function(instance)
	instance.hotkeys.hotkeys.hotkey_inventory = "inventory_background_view"
end)

