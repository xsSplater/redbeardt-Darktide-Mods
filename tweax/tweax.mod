return {
	run = function()
		fassert(rawget(_G, "new_mod", "`tweax` encountered an error loading the Darktide Mod Framework."))

		new_mod("tweax", {
			mod_script       = "tweax/tweax",
			mod_data         = "tweax/data",
			mod_localization = "tweax/loc"
		})
	end,
	packages = {}
}
