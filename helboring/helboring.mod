return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`helboring` encountered an error loading the Darktide Mod Framework.")

		new_mod("helboring", {
			mod_script       = "helboring/scripts/mods/helboring/helboring",
			mod_data         = "helboring/scripts/mods/helboring/helboring_data",
			mod_localization = "helboring/scripts/mods/helboring/helboring_localization",
		})
	end,
	packages = {},
}
