return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`barter_with_hadron` encountered an error loading the Darktide Mod Framework.")

		new_mod("barter_with_hadron", {
			mod_script       = "barter_with_hadron/scripts/mods/barter_with_hadron/barter_with_hadron",
			mod_data         = "barter_with_hadron/scripts/mods/barter_with_hadron/barter_with_hadron_data",
			mod_localization = "barter_with_hadron/scripts/mods/barter_with_hadron/barter_with_hadron_localization"
		})
	end,
	packages = {}
}
