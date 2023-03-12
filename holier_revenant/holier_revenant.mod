return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`holier_revenant` encountered an error loading the Darktide Mod Framework.")

		new_mod("holier_revenant", {
			mod_script       = "holier_revenant/scripts/mods/holier_revenant/holier_revenant",
			mod_data         = "holier_revenant/scripts/mods/holier_revenant/holier_revenant_data",
			mod_localization = "holier_revenant/scripts/mods/holier_revenant/holier_revenant_localization",
		})
	end,
	packages = {},
}
