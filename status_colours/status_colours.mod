return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`status_colours` encountered an error loading the Darktide Mod Framework.")

		new_mod("status_colours", {
			mod_script       = "status_colours/scripts/mods/status_colours/status_colours",
			mod_data         = "status_colours/scripts/mods/status_colours/status_colours_data",
			mod_localization = "status_colours/scripts/mods/status_colours/status_colours_localization",
		})
	end,
	packages = {},
}
