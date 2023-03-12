return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`bugfix_loc_markers` encountered an error loading the Darktide Mod Framework.")

		new_mod("bugfix_loc_markers", {
			mod_script       = "bugfix_loc_markers/scripts/mods/bugfix_loc_markers/bugfix_loc_markers",
			mod_data         = "bugfix_loc_markers/scripts/mods/bugfix_loc_markers/bugfix_loc_markers_data",
			mod_localization = "bugfix_loc_markers/scripts/mods/bugfix_loc_markers/bugfix_loc_markers_localization",
		})
	end,
	packages = {},
}
