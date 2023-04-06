return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`darkcache` encountered an error loading the Darktide Mod Framework.")

		new_mod("darkcache", {
			mod_script       = "darkcache/scripts/mods/darkcache/darkcache",
			mod_data         = "darkcache/scripts/mods/darkcache/darkcache_data",
			mod_localization = "darkcache/scripts/mods/darkcache/darkcache_loc",
		})
	end,
	packages = {},
}
