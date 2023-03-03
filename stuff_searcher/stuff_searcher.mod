return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`stuff_searcher` encountered an error while loading the Darktide Mod Framework.")

		new_mod("stuff_searcher", {
			mod_script          = "stuff_searcher/scripts/mods/stuff_searcher/stuff_searcher",
			mod_data            = "stuff_searcher/scripts/mods/stuff_searcher/stuff_searcher_data",
			mod_localization    = "stuff_searcher/scripts/mods/stuff_searcher/stuff_searcher_localization"
		})
	end,
	packages = {}
}
