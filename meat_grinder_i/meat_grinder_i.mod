return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`meat_grinder_i` encountered an error loading the Darktide Mod Framework.")

		new_mod("meat_grinder_i", {
			mod_script       = "meat_grinder_i/scripts/mods/meat_grinder_i/meat_grinder_i",
			mod_data         = "meat_grinder_i/scripts/mods/meat_grinder_i/meat_grinder_i_data",
			mod_localization = "meat_grinder_i/scripts/mods/meat_grinder_i/meat_grinder_i_localization",
		})
	end,
	packages = {},
}
