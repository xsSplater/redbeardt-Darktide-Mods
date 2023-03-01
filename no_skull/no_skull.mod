return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`no_skull` encountered an error loading the Darktide Mod Framework.")

		new_mod("no_skull", {
			mod_script       = "no_skull/scripts/mods/no_skull/no_skull",
			mod_data         = "no_skull/scripts/mods/no_skull/no_skull_data",
			mod_localization = "no_skull/scripts/mods/no_skull/no_skull_localization",
		})
	end,
	packages = {},
}
