return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`pickup_notif_tweaker` encountered an error loading the Darktide Mod Framework.")

		new_mod("pickup_notif_tweaker", {
			mod_script       = "pickup_notif_tweaker/scripts/mods/pickup_notif_tweaker/pickup_notif_tweaker",
			mod_data         = "pickup_notif_tweaker/scripts/mods/pickup_notif_tweaker/pickup_notif_tweaker_data",
			mod_localization = "pickup_notif_tweaker/scripts/mods/pickup_notif_tweaker/pickup_notif_tweaker_localization",
		})
	end,
	packages = {},
}
